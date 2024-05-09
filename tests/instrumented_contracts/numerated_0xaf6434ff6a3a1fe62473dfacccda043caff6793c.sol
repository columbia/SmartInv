1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-28
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-24
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
12 
13 
14 // ERC721A Contracts v3.3.0
15 // Creator: Chiru Labs
16 
17 pragma solidity ^0.8.4;
18 
19 /**
20  * @dev Interface of an ERC721A compliant contract.
21  */
22 interface IERC721A {
23     /**
24      * The caller must own the token or be an approved operator.
25      */
26     error ApprovalCallerNotOwnerNorApproved();
27 
28     /**
29      * The token does not exist.
30      */
31     error ApprovalQueryForNonexistentToken();
32 
33     /**
34      * The caller cannot approve to their own address.
35      */
36     error ApproveToCaller();
37 
38     /**
39      * The caller cannot approve to the current owner.
40      */
41     error ApprovalToCurrentOwner();
42 
43     /**
44      * Cannot query the balance for the zero address.
45      */
46     error BalanceQueryForZeroAddress();
47 
48     /**
49      * Cannot mint to the zero address.
50      */
51     error MintToZeroAddress();
52 
53     /**
54      * The quantity of tokens minted must be more than zero.
55      */
56     error MintZeroQuantity();
57 
58     /**
59      * The token does not exist.
60      */
61     error OwnerQueryForNonexistentToken();
62 
63     /**
64      * The caller must own the token or be an approved operator.
65      */
66     error TransferCallerNotOwnerNorApproved();
67 
68     /**
69      * The token must be owned by `from`.
70      */
71     error TransferFromIncorrectOwner();
72 
73     /**
74      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
75      */
76     error TransferToNonERC721ReceiverImplementer();
77 
78     /**
79      * Cannot transfer to the zero address.
80      */
81     error TransferToZeroAddress();
82 
83     /**
84      * The token does not exist.
85      */
86     error URIQueryForNonexistentToken();
87 
88     struct TokenOwnership {
89         // The address of the owner.
90         address addr;
91         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
92         uint64 startTimestamp;
93         // Whether the token has been burned.
94         bool burned;
95     }
96 
97     /**
98      * @dev Returns the total amount of tokens stored by the contract.
99      *
100      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
101      */
102     function totalSupply() external view returns (uint256);
103 
104     // ==============================
105     //            IERC165
106     // ==============================
107 
108     /**
109      * @dev Returns true if this contract implements the interface defined by
110      * `interfaceId`. See the corresponding
111      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
112      * to learn more about how these ids are created.
113      *
114      * This function call must use less than 30 000 gas.
115      */
116     function supportsInterface(bytes4 interfaceId) external view returns (bool);
117 
118     // ==============================
119     //            IERC721
120     // ==============================
121 
122     /**
123      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
129      */
130     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
134      */
135     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
136 
137     /**
138      * @dev Returns the number of tokens in ``owner``'s account.
139      */
140     function balanceOf(address owner) external view returns (uint256 balance);
141 
142     /**
143      * @dev Returns the owner of the `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function ownerOf(uint256 tokenId) external view returns (address owner);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
173      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Transfers `tokenId` token from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
213      * The approval is cleared when the token is transferred.
214      *
215      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
216      *
217      * Requirements:
218      *
219      * - The caller must own the token or be an approved operator.
220      * - `tokenId` must exist.
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address to, uint256 tokenId) external;
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 
254     // ==============================
255     //        IERC721Metadata
256     // ==============================
257 
258     /**
259      * @dev Returns the token collection name.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the token collection symbol.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
270      */
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 }
273 
274 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
275 
276 
277 // ERC721A Contracts v3.3.0
278 // Creator: Chiru Labs
279 
280 pragma solidity ^0.8.4;
281 
282 
283 /**
284  * @dev ERC721 token receiver interface.
285  */
286 interface ERC721A__IERC721Receiver {
287     function onERC721Received(
288         address operator,
289         address from,
290         uint256 tokenId,
291         bytes calldata data
292     ) external returns (bytes4);
293 }
294 
295 /**
296  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
297  * the Metadata extension. Built to optimize for lower gas during batch mints.
298  *
299  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
300  *
301  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
302  *
303  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
304  */
305 contract ERC721A is IERC721A {
306     // Mask of an entry in packed address data.
307     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
308 
309     // The bit position of `numberMinted` in packed address data.
310     uint256 private constant BITPOS_NUMBER_MINTED = 64;
311 
312     // The bit position of `numberBurned` in packed address data.
313     uint256 private constant BITPOS_NUMBER_BURNED = 128;
314 
315     // The bit position of `aux` in packed address data.
316     uint256 private constant BITPOS_AUX = 192;
317 
318     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
319     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
320 
321     // The bit position of `startTimestamp` in packed ownership.
322     uint256 private constant BITPOS_START_TIMESTAMP = 160;
323 
324     // The bit mask of the `burned` bit in packed ownership.
325     uint256 private constant BITMASK_BURNED = 1 << 224;
326     
327     // The bit position of the `nextInitialized` bit in packed ownership.
328     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
329 
330     // The bit mask of the `nextInitialized` bit in packed ownership.
331     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
332 
333     // The tokenId of the next token to be minted.
334     uint256 private _currentIndex;
335 
336     // The number of tokens burned.
337     uint256 private _burnCounter;
338 
339     // Token name
340     string private _name;
341 
342     // Token symbol
343     string private _symbol;
344 
345     // Mapping from token ID to ownership details
346     // An empty struct value does not necessarily mean the token is unowned.
347     // See `_packedOwnershipOf` implementation for details.
348     //
349     // Bits Layout:
350     // - [0..159]   `addr`
351     // - [160..223] `startTimestamp`
352     // - [224]      `burned`
353     // - [225]      `nextInitialized`
354     mapping(uint256 => uint256) private _packedOwnerships;
355 
356     // Mapping owner address to address data.
357     //
358     // Bits Layout:
359     // - [0..63]    `balance`
360     // - [64..127]  `numberMinted`
361     // - [128..191] `numberBurned`
362     // - [192..255] `aux`
363     mapping(address => uint256) private _packedAddressData;
364 
365     // Mapping from token ID to approved address.
366     mapping(uint256 => address) private _tokenApprovals;
367 
368     // Mapping from owner to operator approvals
369     mapping(address => mapping(address => bool)) private _operatorApprovals;
370 
371     constructor(string memory name_, string memory symbol_) {
372         _name = name_;
373         _symbol = symbol_;
374         _currentIndex = _startTokenId();
375     }
376 
377     /**
378      * @dev Returns the starting token ID. 
379      * To change the starting token ID, please override this function.
380      */
381     function _startTokenId() internal view virtual returns (uint256) {
382         return 0;
383     }
384 
385     /**
386      * @dev Returns the next token ID to be minted.
387      */
388     function _nextTokenId() internal view returns (uint256) {
389         return _currentIndex;
390     }
391 
392     /**
393      * @dev Returns the total number of tokens in existence.
394      * Burned tokens will reduce the count. 
395      * To get the total number of tokens minted, please see `_totalMinted`.
396      */
397     function totalSupply() public view override returns (uint256) {
398         // Counter underflow is impossible as _burnCounter cannot be incremented
399         // more than `_currentIndex - _startTokenId()` times.
400         unchecked {
401             return _currentIndex - _burnCounter - _startTokenId();
402         }
403     }
404 
405     /**
406      * @dev Returns the total amount of tokens minted in the contract.
407      */
408     function _totalMinted() internal view returns (uint256) {
409         // Counter underflow is impossible as _currentIndex does not decrement,
410         // and it is initialized to `_startTokenId()`
411         unchecked {
412             return _currentIndex - _startTokenId();
413         }
414     }
415 
416     /**
417      * @dev Returns the total number of tokens burned.
418      */
419     function _totalBurned() internal view returns (uint256) {
420         return _burnCounter;
421     }
422 
423     /**
424      * @dev See {IERC165-supportsInterface}.
425      */
426     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
427         // The interface IDs are constants representing the first 4 bytes of the XOR of
428         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
429         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
430         return
431             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
432             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
433             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
434     }
435 
436     /**
437      * @dev See {IERC721-balanceOf}.
438      */
439     function balanceOf(address owner) public view override returns (uint256) {
440         if (owner == address(0)) revert BalanceQueryForZeroAddress();
441         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
442     }
443 
444     /**
445      * Returns the number of tokens minted by `owner`.
446      */
447     function _numberMinted(address owner) internal view returns (uint256) {
448         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
449     }
450 
451     /**
452      * Returns the number of tokens burned by or on behalf of `owner`.
453      */
454     function _numberBurned(address owner) internal view returns (uint256) {
455         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
456     }
457 
458     /**
459      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
460      */
461     function _getAux(address owner) internal view returns (uint64) {
462         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
463     }
464 
465     /**
466      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
467      * If there are multiple variables, please pack them into a uint64.
468      */
469     function _setAux(address owner, uint64 aux) internal {
470         uint256 packed = _packedAddressData[owner];
471         uint256 auxCasted;
472         assembly { // Cast aux without masking.
473             auxCasted := aux
474         }
475         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
476         _packedAddressData[owner] = packed;
477     }
478 
479     /**
480      * Returns the packed ownership data of `tokenId`.
481      */
482     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
483         uint256 curr = tokenId;
484 
485         unchecked {
486             if (_startTokenId() <= curr)
487                 if (curr < _currentIndex) {
488                     uint256 packed = _packedOwnerships[curr];
489                     // If not burned.
490                     if (packed & BITMASK_BURNED == 0) {
491                         // Invariant:
492                         // There will always be an ownership that has an address and is not burned
493                         // before an ownership that does not have an address and is not burned.
494                         // Hence, curr will not underflow.
495                         //
496                         // We can directly compare the packed value.
497                         // If the address is zero, packed is zero.
498                         while (packed == 0) {
499                             packed = _packedOwnerships[--curr];
500                         }
501                         return packed;
502                     }
503                 }
504         }
505         revert OwnerQueryForNonexistentToken();
506     }
507 
508     /**
509      * Returns the unpacked `TokenOwnership` struct from `packed`.
510      */
511     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
512         ownership.addr = address(uint160(packed));
513         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
514         ownership.burned = packed & BITMASK_BURNED != 0;
515     }
516 
517     /**
518      * Returns the unpacked `TokenOwnership` struct at `index`.
519      */
520     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
521         return _unpackedOwnership(_packedOwnerships[index]);
522     }
523 
524     /**
525      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
526      */
527     function _initializeOwnershipAt(uint256 index) internal {
528         if (_packedOwnerships[index] == 0) {
529             _packedOwnerships[index] = _packedOwnershipOf(index);
530         }
531     }
532 
533     /**
534      * Gas spent here starts off proportional to the maximum mint batch size.
535      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
536      */
537     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
538         return _unpackedOwnership(_packedOwnershipOf(tokenId));
539     }
540 
541     /**
542      * @dev See {IERC721-ownerOf}.
543      */
544     function ownerOf(uint256 tokenId) public view override returns (address) {
545         return address(uint160(_packedOwnershipOf(tokenId)));
546     }
547 
548     /**
549      * @dev See {IERC721Metadata-name}.
550      */
551     function name() public view virtual override returns (string memory) {
552         return _name;
553     }
554 
555     /**
556      * @dev See {IERC721Metadata-symbol}.
557      */
558     function symbol() public view virtual override returns (string memory) {
559         return _symbol;
560     }
561 
562     /**
563      * @dev See {IERC721Metadata-tokenURI}.
564      */
565     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
566         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
567 
568         string memory baseURI = _baseURI();
569         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
570     }
571 
572     /**
573      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
574      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
575      * by default, can be overriden in child contracts.
576      */
577     function _baseURI() internal view virtual returns (string memory) {
578         return '';
579     }
580 
581     /**
582      * @dev Casts the address to uint256 without masking.
583      */
584     function _addressToUint256(address value) private pure returns (uint256 result) {
585         assembly {
586             result := value
587         }
588     }
589 
590     /**
591      * @dev Casts the boolean to uint256 without branching.
592      */
593     function _boolToUint256(bool value) private pure returns (uint256 result) {
594         assembly {
595             result := value
596         }
597     }
598 
599     /**
600      * @dev See {IERC721-approve}.
601      */
602     function approve(address to, uint256 tokenId) public override {
603         address owner = address(uint160(_packedOwnershipOf(tokenId)));
604         if (to == owner) revert ApprovalToCurrentOwner();
605 
606         if (_msgSenderERC721A() != owner)
607             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
608                 revert ApprovalCallerNotOwnerNorApproved();
609             }
610 
611         _tokenApprovals[tokenId] = to;
612         emit Approval(owner, to, tokenId);
613     }
614 
615     /**
616      * @dev See {IERC721-getApproved}.
617      */
618     function getApproved(uint256 tokenId) public view override returns (address) {
619         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
620 
621         return _tokenApprovals[tokenId];
622     }
623 
624     /**
625      * @dev See {IERC721-setApprovalForAll}.
626      */
627     function setApprovalForAll(address operator, bool approved) public virtual override {
628         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
629 
630         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
631         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
632     }
633 
634     /**
635      * @dev See {IERC721-isApprovedForAll}.
636      */
637     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
638         return _operatorApprovals[owner][operator];
639     }
640 
641     /**
642      * @dev See {IERC721-transferFrom}.
643      */
644     function transferFrom(
645         address from,
646         address to,
647         uint256 tokenId
648     ) public virtual override {
649         _transfer(from, to, tokenId);
650     }
651 
652     /**
653      * @dev See {IERC721-safeTransferFrom}.
654      */
655     function safeTransferFrom(
656         address from,
657         address to,
658         uint256 tokenId
659     ) public virtual override {
660         safeTransferFrom(from, to, tokenId, '');
661     }
662 
663     /**
664      * @dev See {IERC721-safeTransferFrom}.
665      */
666     function safeTransferFrom(
667         address from,
668         address to,
669         uint256 tokenId,
670         bytes memory _data
671     ) public virtual override {
672         _transfer(from, to, tokenId);
673         if (to.code.length != 0)
674             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
675                 revert TransferToNonERC721ReceiverImplementer();
676             }
677     }
678 
679     /**
680      * @dev Returns whether `tokenId` exists.
681      *
682      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
683      *
684      * Tokens start existing when they are minted (`_mint`),
685      */
686     function _exists(uint256 tokenId) internal view returns (bool) {
687         return
688             _startTokenId() <= tokenId &&
689             tokenId < _currentIndex && // If within bounds,
690             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
691     }
692 
693     /**
694      * @dev Equivalent to `_safeMint(to, quantity, '')`.
695      */
696     function _safeMint(address to, uint256 quantity) internal {
697         _safeMint(to, quantity, '');
698     }
699 
700     /**
701      * @dev Safely mints `quantity` tokens and transfers them to `to`.
702      *
703      * Requirements:
704      *
705      * - If `to` refers to a smart contract, it must implement
706      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
707      * - `quantity` must be greater than 0.
708      *
709      * Emits a {Transfer} event.
710      */
711     function _safeMint(
712         address to,
713         uint256 quantity,
714         bytes memory _data
715     ) internal {
716         uint256 startTokenId = _currentIndex;
717         if (to == address(0)) revert MintToZeroAddress();
718         if (quantity == 0) revert MintZeroQuantity();
719 
720         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
721 
722         // Overflows are incredibly unrealistic.
723         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
724         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
725         unchecked {
726             // Updates:
727             // - `balance += quantity`.
728             // - `numberMinted += quantity`.
729             //
730             // We can directly add to the balance and number minted.
731             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
732 
733             // Updates:
734             // - `address` to the owner.
735             // - `startTimestamp` to the timestamp of minting.
736             // - `burned` to `false`.
737             // - `nextInitialized` to `quantity == 1`.
738             _packedOwnerships[startTokenId] =
739                 _addressToUint256(to) |
740                 (block.timestamp << BITPOS_START_TIMESTAMP) |
741                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
742 
743             uint256 updatedIndex = startTokenId;
744             uint256 end = updatedIndex + quantity;
745 
746             if (to.code.length != 0) {
747                 do {
748                     emit Transfer(address(0), to, updatedIndex);
749                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
750                         revert TransferToNonERC721ReceiverImplementer();
751                     }
752                 } while (updatedIndex < end);
753                 // Reentrancy protection
754                 if (_currentIndex != startTokenId) revert();
755             } else {
756                 do {
757                     emit Transfer(address(0), to, updatedIndex++);
758                 } while (updatedIndex < end);
759             }
760             _currentIndex = updatedIndex;
761         }
762         _afterTokenTransfers(address(0), to, startTokenId, quantity);
763     }
764 
765     /**
766      * @dev Mints `quantity` tokens and transfers them to `to`.
767      *
768      * Requirements:
769      *
770      * - `to` cannot be the zero address.
771      * - `quantity` must be greater than 0.
772      *
773      * Emits a {Transfer} event.
774      */
775     function _mint(address to, uint256 quantity) internal {
776         uint256 startTokenId = _currentIndex;
777         if (to == address(0)) revert MintToZeroAddress();
778         if (quantity == 0) revert MintZeroQuantity();
779 
780         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
781 
782         // Overflows are incredibly unrealistic.
783         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
784         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
785         unchecked {
786             // Updates:
787             // - `balance += quantity`.
788             // - `numberMinted += quantity`.
789             //
790             // We can directly add to the balance and number minted.
791             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
792 
793             // Updates:
794             // - `address` to the owner.
795             // - `startTimestamp` to the timestamp of minting.
796             // - `burned` to `false`.
797             // - `nextInitialized` to `quantity == 1`.
798             _packedOwnerships[startTokenId] =
799                 _addressToUint256(to) |
800                 (block.timestamp << BITPOS_START_TIMESTAMP) |
801                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
802 
803             uint256 updatedIndex = startTokenId;
804             uint256 end = updatedIndex + quantity;
805 
806             do {
807                 emit Transfer(address(0), to, updatedIndex++);
808             } while (updatedIndex < end);
809 
810             _currentIndex = updatedIndex;
811         }
812         _afterTokenTransfers(address(0), to, startTokenId, quantity);
813     }
814 
815     /**
816      * @dev Transfers `tokenId` from `from` to `to`.
817      *
818      * Requirements:
819      *
820      * - `to` cannot be the zero address.
821      * - `tokenId` token must be owned by `from`.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _transfer(
826         address from,
827         address to,
828         uint256 tokenId
829     ) private {
830         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
831 
832         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
833 
834         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
835             isApprovedForAll(from, _msgSenderERC721A()) ||
836             getApproved(tokenId) == _msgSenderERC721A());
837 
838         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
839         if (to == address(0)) revert TransferToZeroAddress();
840 
841         _beforeTokenTransfers(from, to, tokenId, 1);
842 
843         // Clear approvals from the previous owner.
844         delete _tokenApprovals[tokenId];
845 
846         // Underflow of the sender's balance is impossible because we check for
847         // ownership above and the recipient's balance can't realistically overflow.
848         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
849         unchecked {
850             // We can directly increment and decrement the balances.
851             --_packedAddressData[from]; // Updates: `balance -= 1`.
852             ++_packedAddressData[to]; // Updates: `balance += 1`.
853 
854             // Updates:
855             // - `address` to the next owner.
856             // - `startTimestamp` to the timestamp of transfering.
857             // - `burned` to `false`.
858             // - `nextInitialized` to `true`.
859             _packedOwnerships[tokenId] =
860                 _addressToUint256(to) |
861                 (block.timestamp << BITPOS_START_TIMESTAMP) |
862                 BITMASK_NEXT_INITIALIZED;
863 
864             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
865             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
866                 uint256 nextTokenId = tokenId + 1;
867                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
868                 if (_packedOwnerships[nextTokenId] == 0) {
869                     // If the next slot is within bounds.
870                     if (nextTokenId != _currentIndex) {
871                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
872                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
873                     }
874                 }
875             }
876         }
877 
878         emit Transfer(from, to, tokenId);
879         _afterTokenTransfers(from, to, tokenId, 1);
880     }
881 
882     /**
883      * @dev Equivalent to `_burn(tokenId, false)`.
884      */
885     function _burn(uint256 tokenId) internal virtual {
886         _burn(tokenId, false);
887     }
888 
889     /**
890      * @dev Destroys `tokenId`.
891      * The approval is cleared when the token is burned.
892      *
893      * Requirements:
894      *
895      * - `tokenId` must exist.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
900         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
901 
902         address from = address(uint160(prevOwnershipPacked));
903 
904         if (approvalCheck) {
905             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
906                 isApprovedForAll(from, _msgSenderERC721A()) ||
907                 getApproved(tokenId) == _msgSenderERC721A());
908 
909             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
910         }
911 
912         _beforeTokenTransfers(from, address(0), tokenId, 1);
913 
914         // Clear approvals from the previous owner.
915         delete _tokenApprovals[tokenId];
916 
917         // Underflow of the sender's balance is impossible because we check for
918         // ownership above and the recipient's balance can't realistically overflow.
919         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
920         unchecked {
921             // Updates:
922             // - `balance -= 1`.
923             // - `numberBurned += 1`.
924             //
925             // We can directly decrement the balance, and increment the number burned.
926             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
927             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
928 
929             // Updates:
930             // - `address` to the last owner.
931             // - `startTimestamp` to the timestamp of burning.
932             // - `burned` to `true`.
933             // - `nextInitialized` to `true`.
934             _packedOwnerships[tokenId] =
935                 _addressToUint256(from) |
936                 (block.timestamp << BITPOS_START_TIMESTAMP) |
937                 BITMASK_BURNED | 
938                 BITMASK_NEXT_INITIALIZED;
939 
940             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
941             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
942                 uint256 nextTokenId = tokenId + 1;
943                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
944                 if (_packedOwnerships[nextTokenId] == 0) {
945                     // If the next slot is within bounds.
946                     if (nextTokenId != _currentIndex) {
947                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
948                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
949                     }
950                 }
951             }
952         }
953 
954         emit Transfer(from, address(0), tokenId);
955         _afterTokenTransfers(from, address(0), tokenId, 1);
956 
957         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
958         unchecked {
959             _burnCounter++;
960         }
961     }
962 
963     /**
964      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
965      *
966      * @param from address representing the previous owner of the given token ID
967      * @param to target address that will receive the tokens
968      * @param tokenId uint256 ID of the token to be transferred
969      * @param _data bytes optional data to send along with the call
970      * @return bool whether the call correctly returned the expected magic value
971      */
972     function _checkContractOnERC721Received(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) private returns (bool) {
978         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
979             bytes4 retval
980         ) {
981             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
982         } catch (bytes memory reason) {
983             if (reason.length == 0) {
984                 revert TransferToNonERC721ReceiverImplementer();
985             } else {
986                 assembly {
987                     revert(add(32, reason), mload(reason))
988                 }
989             }
990         }
991     }
992 
993     /**
994      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
995      * And also called before burning one token.
996      *
997      * startTokenId - the first token id to be transferred
998      * quantity - the amount to be transferred
999      *
1000      * Calling conditions:
1001      *
1002      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1003      * transferred to `to`.
1004      * - When `from` is zero, `tokenId` will be minted for `to`.
1005      * - When `to` is zero, `tokenId` will be burned by `from`.
1006      * - `from` and `to` are never both zero.
1007      */
1008     function _beforeTokenTransfers(
1009         address from,
1010         address to,
1011         uint256 startTokenId,
1012         uint256 quantity
1013     ) internal virtual {}
1014 
1015     /**
1016      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1017      * minting.
1018      * And also called after one token has been burned.
1019      *
1020      * startTokenId - the first token id to be transferred
1021      * quantity - the amount to be transferred
1022      *
1023      * Calling conditions:
1024      *
1025      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1026      * transferred to `to`.
1027      * - When `from` is zero, `tokenId` has been minted for `to`.
1028      * - When `to` is zero, `tokenId` has been burned by `from`.
1029      * - `from` and `to` are never both zero.
1030      */
1031     function _afterTokenTransfers(
1032         address from,
1033         address to,
1034         uint256 startTokenId,
1035         uint256 quantity
1036     ) internal virtual {}
1037 
1038     /**
1039      * @dev Returns the message sender (defaults to `msg.sender`).
1040      *
1041      * If you are writing GSN compatible contracts, you need to override this function.
1042      */
1043     function _msgSenderERC721A() internal view virtual returns (address) {
1044         return msg.sender;
1045     }
1046 
1047     /**
1048      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1049      */
1050     function _toString(uint256 value) internal pure returns (string memory ptr) {
1051         assembly {
1052             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1053             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1054             // We will need 1 32-byte word to store the length, 
1055             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1056             ptr := add(mload(0x40), 128)
1057             // Update the free memory pointer to allocate.
1058             mstore(0x40, ptr)
1059 
1060             // Cache the end of the memory to calculate the length later.
1061             let end := ptr
1062 
1063             // We write the string from the rightmost digit to the leftmost digit.
1064             // The following is essentially a do-while loop that also handles the zero case.
1065             // Costs a bit more than early returning for the zero case,
1066             // but cheaper in terms of deployment and overall runtime costs.
1067             for { 
1068                 // Initialize and perform the first pass without check.
1069                 let temp := value
1070                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1071                 ptr := sub(ptr, 1)
1072                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1073                 mstore8(ptr, add(48, mod(temp, 10)))
1074                 temp := div(temp, 10)
1075             } temp { 
1076                 // Keep dividing `temp` until zero.
1077                 temp := div(temp, 10)
1078             } { // Body of the for loop.
1079                 ptr := sub(ptr, 1)
1080                 mstore8(ptr, add(48, mod(temp, 10)))
1081             }
1082             
1083             let length := sub(end, ptr)
1084             // Move the pointer 32 bytes leftwards to make room for the length.
1085             ptr := sub(ptr, 32)
1086             // Store the length.
1087             mstore(ptr, length)
1088         }
1089     }
1090 }
1091 
1092 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1093 
1094 
1095 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 /**
1100  * @dev String operations.
1101  */
1102 library Strings {
1103     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1104     uint8 private constant _ADDRESS_LENGTH = 20;
1105 
1106     /**
1107      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1108      */
1109     function toString(uint256 value) internal pure returns (string memory) {
1110         // Inspired by OraclizeAPI's implementation - MIT licence
1111         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1112 
1113         if (value == 0) {
1114             return "0";
1115         }
1116         uint256 temp = value;
1117         uint256 digits;
1118         while (temp != 0) {
1119             digits++;
1120             temp /= 10;
1121         }
1122         bytes memory buffer = new bytes(digits);
1123         while (value != 0) {
1124             digits -= 1;
1125             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1126             value /= 10;
1127         }
1128         return string(buffer);
1129     }
1130 
1131     /**
1132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1133      */
1134     function toHexString(uint256 value) internal pure returns (string memory) {
1135         if (value == 0) {
1136             return "0x00";
1137         }
1138         uint256 temp = value;
1139         uint256 length = 0;
1140         while (temp != 0) {
1141             length++;
1142             temp >>= 8;
1143         }
1144         return toHexString(value, length);
1145     }
1146 
1147     /**
1148      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1149      */
1150     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1151         bytes memory buffer = new bytes(2 * length + 2);
1152         buffer[0] = "0";
1153         buffer[1] = "x";
1154         for (uint256 i = 2 * length + 1; i > 1; --i) {
1155             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1156             value >>= 4;
1157         }
1158         require(value == 0, "Strings: hex length insufficient");
1159         return string(buffer);
1160     }
1161 
1162     /**
1163      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1164      */
1165     function toHexString(address addr) internal pure returns (string memory) {
1166         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1167     }
1168 }
1169 
1170 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1171 
1172 
1173 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 /**
1178  * @dev Provides information about the current execution context, including the
1179  * sender of the transaction and its data. While these are generally available
1180  * via msg.sender and msg.data, they should not be accessed in such a direct
1181  * manner, since when dealing with meta-transactions the account sending and
1182  * paying for execution may not be the actual sender (as far as an application
1183  * is concerned).
1184  *
1185  * This contract is only required for intermediate, library-like contracts.
1186  */
1187 abstract contract Context {
1188     function _msgSender() internal view virtual returns (address) {
1189         return msg.sender;
1190     }
1191 
1192     function _msgData() internal view virtual returns (bytes calldata) {
1193         return msg.data;
1194     }
1195 }
1196 
1197 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1198 
1199 
1200 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1201 
1202 pragma solidity ^0.8.0;
1203 
1204 
1205 /**
1206  * @dev Contract module which provides a basic access control mechanism, where
1207  * there is an account (an owner) that can be granted exclusive access to
1208  * specific functions.
1209  *
1210  * By default, the owner account will be the one that deploys the contract. This
1211  * can later be changed with {transferOwnership}.
1212  *
1213  * This module is used through inheritance. It will make available the modifier
1214  * `onlyOwner`, which can be applied to your functions to restrict their use to
1215  * the owner.
1216  */
1217 abstract contract Ownable is Context {
1218     address private _owner;
1219 
1220     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1221 
1222     /**
1223      * @dev Initializes the contract setting the deployer as the initial owner.
1224      */
1225     constructor() {
1226         _transferOwnership(_msgSender());
1227     }
1228 
1229     /**
1230      * @dev Returns the address of the current owner.
1231      */
1232     function owner() public view virtual returns (address) {
1233         return _owner;
1234     }
1235 
1236     /**
1237      * @dev Throws if called by any account other than the owner.
1238      */
1239     modifier onlyOwner() {
1240         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1241         _;
1242     }
1243 
1244     /**
1245      * @dev Leaves the contract without owner. It will not be possible to call
1246      * `onlyOwner` functions anymore. Can only be called by the current owner.
1247      *
1248      * NOTE: Renouncing ownership will leave the contract without an owner,
1249      * thereby removing any functionality that is only available to the owner.
1250      */
1251     function renounceOwnership() public virtual onlyOwner {
1252         _transferOwnership(address(0));
1253     }
1254 
1255     /**
1256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1257      * Can only be called by the current owner.
1258      */
1259     function transferOwnership(address newOwner) public virtual onlyOwner {
1260         require(newOwner != address(0), "Ownable: new owner is the zero address");
1261         _transferOwnership(newOwner);
1262     }
1263 
1264     /**
1265      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1266      * Internal function without access restriction.
1267      */
1268     function _transferOwnership(address newOwner) internal virtual {
1269         address oldOwner = _owner;
1270         _owner = newOwner;
1271         emit OwnershipTransferred(oldOwner, newOwner);
1272     }
1273 }
1274 
1275 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1276 
1277 
1278 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1279 
1280 pragma solidity ^0.8.1;
1281 
1282 /**
1283  * @dev Collection of functions related to the address type
1284  */
1285 library Address {
1286     /**
1287      * @dev Returns true if `account` is a contract.
1288      *
1289      * [IMPORTANT]
1290      * ====
1291      * It is unsafe to assume that an address for which this function returns
1292      * false is an externally-owned account (EOA) and not a contract.
1293      *
1294      * Among others, `isContract` will return false for the following
1295      * types of addresses:
1296      *
1297      *  - an externally-owned account
1298      *  - a contract in construction
1299      *  - an address where a contract will be created
1300      *  - an address where a contract lived, but was destroyed
1301      * ====
1302      *
1303      * [IMPORTANT]
1304      * ====
1305      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1306      *
1307      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1308      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1309      * constructor.
1310      * ====
1311      */
1312     function isContract(address account) internal view returns (bool) {
1313         // This method relies on extcodesize/address.code.length, which returns 0
1314         // for contracts in construction, since the code is only stored at the end
1315         // of the constructor execution.
1316 
1317         return account.code.length > 0;
1318     }
1319 
1320     /**
1321      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1322      * `recipient`, forwarding all available gas and reverting on errors.
1323      *
1324      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1325      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1326      * imposed by `transfer`, making them unable to receive funds via
1327      * `transfer`. {sendValue} removes this limitation.
1328      *
1329      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1330      *
1331      * IMPORTANT: because control is transferred to `recipient`, care must be
1332      * taken to not create reentrancy vulnerabilities. Consider using
1333      * {ReentrancyGuard} or the
1334      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1335      */
1336     function sendValue(address payable recipient, uint256 amount) internal {
1337         require(address(this).balance >= amount, "Address: insufficient balance");
1338 
1339         (bool success, ) = recipient.call{value: amount}("");
1340         require(success, "Address: unable to send value, recipient may have reverted");
1341     }
1342 
1343     /**
1344      * @dev Performs a Solidity function call using a low level `call`. A
1345      * plain `call` is an unsafe replacement for a function call: use this
1346      * function instead.
1347      *
1348      * If `target` reverts with a revert reason, it is bubbled up by this
1349      * function (like regular Solidity function calls).
1350      *
1351      * Returns the raw returned data. To convert to the expected return value,
1352      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1353      *
1354      * Requirements:
1355      *
1356      * - `target` must be a contract.
1357      * - calling `target` with `data` must not revert.
1358      *
1359      * _Available since v3.1._
1360      */
1361     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1362         return functionCall(target, data, "Address: low-level call failed");
1363     }
1364 
1365     /**
1366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1367      * `errorMessage` as a fallback revert reason when `target` reverts.
1368      *
1369      * _Available since v3.1._
1370      */
1371     function functionCall(
1372         address target,
1373         bytes memory data,
1374         string memory errorMessage
1375     ) internal returns (bytes memory) {
1376         return functionCallWithValue(target, data, 0, errorMessage);
1377     }
1378 
1379     /**
1380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1381      * but also transferring `value` wei to `target`.
1382      *
1383      * Requirements:
1384      *
1385      * - the calling contract must have an ETH balance of at least `value`.
1386      * - the called Solidity function must be `payable`.
1387      *
1388      * _Available since v3.1._
1389      */
1390     function functionCallWithValue(
1391         address target,
1392         bytes memory data,
1393         uint256 value
1394     ) internal returns (bytes memory) {
1395         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1396     }
1397 
1398     /**
1399      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1400      * with `errorMessage` as a fallback revert reason when `target` reverts.
1401      *
1402      * _Available since v3.1._
1403      */
1404     function functionCallWithValue(
1405         address target,
1406         bytes memory data,
1407         uint256 value,
1408         string memory errorMessage
1409     ) internal returns (bytes memory) {
1410         require(address(this).balance >= value, "Address: insufficient balance for call");
1411         require(isContract(target), "Address: call to non-contract");
1412 
1413         (bool success, bytes memory returndata) = target.call{value: value}(data);
1414         return verifyCallResult(success, returndata, errorMessage);
1415     }
1416 
1417     /**
1418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1419      * but performing a static call.
1420      *
1421      * _Available since v3.3._
1422      */
1423     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1424         return functionStaticCall(target, data, "Address: low-level static call failed");
1425     }
1426 
1427     /**
1428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1429      * but performing a static call.
1430      *
1431      * _Available since v3.3._
1432      */
1433     function functionStaticCall(
1434         address target,
1435         bytes memory data,
1436         string memory errorMessage
1437     ) internal view returns (bytes memory) {
1438         require(isContract(target), "Address: static call to non-contract");
1439 
1440         (bool success, bytes memory returndata) = target.staticcall(data);
1441         return verifyCallResult(success, returndata, errorMessage);
1442     }
1443 
1444     /**
1445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1446      * but performing a delegate call.
1447      *
1448      * _Available since v3.4._
1449      */
1450     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1451         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1452     }
1453 
1454     /**
1455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1456      * but performing a delegate call.
1457      *
1458      * _Available since v3.4._
1459      */
1460     function functionDelegateCall(
1461         address target,
1462         bytes memory data,
1463         string memory errorMessage
1464     ) internal returns (bytes memory) {
1465         require(isContract(target), "Address: delegate call to non-contract");
1466 
1467         (bool success, bytes memory returndata) = target.delegatecall(data);
1468         return verifyCallResult(success, returndata, errorMessage);
1469     }
1470 
1471     /**
1472      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1473      * revert reason using the provided one.
1474      *
1475      * _Available since v4.3._
1476      */
1477     function verifyCallResult(
1478         bool success,
1479         bytes memory returndata,
1480         string memory errorMessage
1481     ) internal pure returns (bytes memory) {
1482         if (success) {
1483             return returndata;
1484         } else {
1485             // Look for revert reason and bubble it up if present
1486             if (returndata.length > 0) {
1487                 // The easiest way to bubble the revert reason is using memory via assembly
1488 
1489                 assembly {
1490                     let returndata_size := mload(returndata)
1491                     revert(add(32, returndata), returndata_size)
1492                 }
1493             } else {
1494                 revert(errorMessage);
1495             }
1496         }
1497     }
1498 }
1499 
1500 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1501 
1502 
1503 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1504 
1505 pragma solidity ^0.8.0;
1506 
1507 /**
1508  * @title ERC721 token receiver interface
1509  * @dev Interface for any contract that wants to support safeTransfers
1510  * from ERC721 asset contracts.
1511  */
1512 interface IERC721Receiver {
1513     /**
1514      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1515      * by `operator` from `from`, this function is called.
1516      *
1517      * It must return its Solidity selector to confirm the token transfer.
1518      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1519      *
1520      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1521      */
1522     function onERC721Received(
1523         address operator,
1524         address from,
1525         uint256 tokenId,
1526         bytes calldata data
1527     ) external returns (bytes4);
1528 }
1529 
1530 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1531 
1532 
1533 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1534 
1535 pragma solidity ^0.8.0;
1536 
1537 /**
1538  * @dev Interface of the ERC165 standard, as defined in the
1539  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1540  *
1541  * Implementers can declare support of contract interfaces, which can then be
1542  * queried by others ({ERC165Checker}).
1543  *
1544  * For an implementation, see {ERC165}.
1545  */
1546 interface IERC165 {
1547     /**
1548      * @dev Returns true if this contract implements the interface defined by
1549      * `interfaceId`. See the corresponding
1550      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1551      * to learn more about how these ids are created.
1552      *
1553      * This function call must use less than 30 000 gas.
1554      */
1555     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1556 }
1557 
1558 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1559 
1560 
1561 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1562 
1563 pragma solidity ^0.8.0;
1564 
1565 
1566 /**
1567  * @dev Implementation of the {IERC165} interface.
1568  *
1569  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1570  * for the additional interface id that will be supported. For example:
1571  *
1572  * ```solidity
1573  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1574  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1575  * }
1576  * ```
1577  *
1578  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1579  */
1580 abstract contract ERC165 is IERC165 {
1581     /**
1582      * @dev See {IERC165-supportsInterface}.
1583      */
1584     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1585         return interfaceId == type(IERC165).interfaceId;
1586     }
1587 }
1588 
1589 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1590 
1591 
1592 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1593 
1594 pragma solidity ^0.8.0;
1595 
1596 
1597 /**
1598  * @dev Required interface of an ERC721 compliant contract.
1599  */
1600 interface IERC721 is IERC165 {
1601     /**
1602      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1603      */
1604     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1605 
1606     /**
1607      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1608      */
1609     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1610 
1611     /**
1612      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1613      */
1614     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1615 
1616     /**
1617      * @dev Returns the number of tokens in ``owner``'s account.
1618      */
1619     function balanceOf(address owner) external view returns (uint256 balance);
1620 
1621     /**
1622      * @dev Returns the owner of the `tokenId` token.
1623      *
1624      * Requirements:
1625      *
1626      * - `tokenId` must exist.
1627      */
1628     function ownerOf(uint256 tokenId) external view returns (address owner);
1629 
1630     /**
1631      * @dev Safely transfers `tokenId` token from `from` to `to`.
1632      *
1633      * Requirements:
1634      *
1635      * - `from` cannot be the zero address.
1636      * - `to` cannot be the zero address.
1637      * - `tokenId` token must exist and be owned by `from`.
1638      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1639      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1640      *
1641      * Emits a {Transfer} event.
1642      */
1643     function safeTransferFrom(
1644         address from,
1645         address to,
1646         uint256 tokenId,
1647         bytes calldata data
1648     ) external;
1649 
1650     /**
1651      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1652      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1653      *
1654      * Requirements:
1655      *
1656      * - `from` cannot be the zero address.
1657      * - `to` cannot be the zero address.
1658      * - `tokenId` token must exist and be owned by `from`.
1659      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1660      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1661      *
1662      * Emits a {Transfer} event.
1663      */
1664     function safeTransferFrom(
1665         address from,
1666         address to,
1667         uint256 tokenId
1668     ) external;
1669 
1670     /**
1671      * @dev Transfers `tokenId` token from `from` to `to`.
1672      *
1673      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1674      *
1675      * Requirements:
1676      *
1677      * - `from` cannot be the zero address.
1678      * - `to` cannot be the zero address.
1679      * - `tokenId` token must be owned by `from`.
1680      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684     function transferFrom(
1685         address from,
1686         address to,
1687         uint256 tokenId
1688     ) external;
1689 
1690     /**
1691      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1692      * The approval is cleared when the token is transferred.
1693      *
1694      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1695      *
1696      * Requirements:
1697      *
1698      * - The caller must own the token or be an approved operator.
1699      * - `tokenId` must exist.
1700      *
1701      * Emits an {Approval} event.
1702      */
1703     function approve(address to, uint256 tokenId) external;
1704 
1705     /**
1706      * @dev Approve or remove `operator` as an operator for the caller.
1707      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1708      *
1709      * Requirements:
1710      *
1711      * - The `operator` cannot be the caller.
1712      *
1713      * Emits an {ApprovalForAll} event.
1714      */
1715     function setApprovalForAll(address operator, bool _approved) external;
1716 
1717     /**
1718      * @dev Returns the account approved for `tokenId` token.
1719      *
1720      * Requirements:
1721      *
1722      * - `tokenId` must exist.
1723      */
1724     function getApproved(uint256 tokenId) external view returns (address operator);
1725 
1726     /**
1727      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1728      *
1729      * See {setApprovalForAll}
1730      */
1731     function isApprovedForAll(address owner, address operator) external view returns (bool);
1732 }
1733 
1734 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1735 
1736 
1737 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1738 
1739 pragma solidity ^0.8.0;
1740 
1741 
1742 /**
1743  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1744  * @dev See https://eips.ethereum.org/EIPS/eip-721
1745  */
1746 interface IERC721Metadata is IERC721 {
1747     /**
1748      * @dev Returns the token collection name.
1749      */
1750     function name() external view returns (string memory);
1751 
1752     /**
1753      * @dev Returns the token collection symbol.
1754      */
1755     function symbol() external view returns (string memory);
1756 
1757     /**
1758      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1759      */
1760     function tokenURI(uint256 tokenId) external view returns (string memory);
1761 }
1762 
1763 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1764 
1765 
1766 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1767 
1768 pragma solidity ^0.8.0;
1769 
1770 
1771 
1772 
1773 
1774 
1775 
1776 
1777 /**
1778  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1779  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1780  * {ERC721Enumerable}.
1781  */
1782 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1783     using Address for address;
1784     using Strings for uint256;
1785 
1786     // Token name
1787     string private _name;
1788 
1789     // Token symbol
1790     string private _symbol;
1791 
1792     // Mapping from token ID to owner address
1793     mapping(uint256 => address) private _owners;
1794 
1795     // Mapping owner address to token count
1796     mapping(address => uint256) private _balances;
1797 
1798     // Mapping from token ID to approved address
1799     mapping(uint256 => address) private _tokenApprovals;
1800 
1801     // Mapping from owner to operator approvals
1802     mapping(address => mapping(address => bool)) private _operatorApprovals;
1803 
1804     /**
1805      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1806      */
1807     constructor(string memory name_, string memory symbol_) {
1808         _name = name_;
1809         _symbol = symbol_;
1810     }
1811 
1812     /**
1813      * @dev See {IERC165-supportsInterface}.
1814      */
1815     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1816         return
1817             interfaceId == type(IERC721).interfaceId ||
1818             interfaceId == type(IERC721Metadata).interfaceId ||
1819             super.supportsInterface(interfaceId);
1820     }
1821 
1822     /**
1823      * @dev See {IERC721-balanceOf}.
1824      */
1825     function balanceOf(address owner) public view virtual override returns (uint256) {
1826         require(owner != address(0), "ERC721: address zero is not a valid owner");
1827         return _balances[owner];
1828     }
1829 
1830     /**
1831      * @dev See {IERC721-ownerOf}.
1832      */
1833     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1834         address owner = _owners[tokenId];
1835         require(owner != address(0), "ERC721: owner query for nonexistent token");
1836         return owner;
1837     }
1838 
1839     /**
1840      * @dev See {IERC721Metadata-name}.
1841      */
1842     function name() public view virtual override returns (string memory) {
1843         return _name;
1844     }
1845 
1846     /**
1847      * @dev See {IERC721Metadata-symbol}.
1848      */
1849     function symbol() public view virtual override returns (string memory) {
1850         return _symbol;
1851     }
1852 
1853     /**
1854      * @dev See {IERC721Metadata-tokenURI}.
1855      */
1856     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1857         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1858 
1859         string memory baseURI = _baseURI();
1860         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1861     }
1862 
1863     /**
1864      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1865      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1866      * by default, can be overridden in child contracts.
1867      */
1868     function _baseURI() internal view virtual returns (string memory) {
1869         return "";
1870     }
1871 
1872     /**
1873      * @dev See {IERC721-approve}.
1874      */
1875     function approve(address to, uint256 tokenId) public virtual override {
1876         address owner = ERC721.ownerOf(tokenId);
1877         require(to != owner, "ERC721: approval to current owner");
1878 
1879         require(
1880             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1881             "ERC721: approve caller is not owner nor approved for all"
1882         );
1883 
1884         _approve(to, tokenId);
1885     }
1886 
1887     /**
1888      * @dev See {IERC721-getApproved}.
1889      */
1890     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1891         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1892 
1893         return _tokenApprovals[tokenId];
1894     }
1895 
1896     /**
1897      * @dev See {IERC721-setApprovalForAll}.
1898      */
1899     function setApprovalForAll(address operator, bool approved) public virtual override {
1900         _setApprovalForAll(_msgSender(), operator, approved);
1901     }
1902 
1903     /**
1904      * @dev See {IERC721-isApprovedForAll}.
1905      */
1906     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1907         return _operatorApprovals[owner][operator];
1908     }
1909 
1910     /**
1911      * @dev See {IERC721-transferFrom}.
1912      */
1913     function transferFrom(
1914         address from,
1915         address to,
1916         uint256 tokenId
1917     ) public virtual override {
1918         //solhint-disable-next-line max-line-length
1919         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1920 
1921         _transfer(from, to, tokenId);
1922     }
1923 
1924     /**
1925      * @dev See {IERC721-safeTransferFrom}.
1926      */
1927     function safeTransferFrom(
1928         address from,
1929         address to,
1930         uint256 tokenId
1931     ) public virtual override {
1932         safeTransferFrom(from, to, tokenId, "");
1933     }
1934 
1935     /**
1936      * @dev See {IERC721-safeTransferFrom}.
1937      */
1938     function safeTransferFrom(
1939         address from,
1940         address to,
1941         uint256 tokenId,
1942         bytes memory data
1943     ) public virtual override {
1944         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1945         _safeTransfer(from, to, tokenId, data);
1946     }
1947 
1948     /**
1949      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1950      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1951      *
1952      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1953      *
1954      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1955      * implement alternative mechanisms to perform token transfer, such as signature-based.
1956      *
1957      * Requirements:
1958      *
1959      * - `from` cannot be the zero address.
1960      * - `to` cannot be the zero address.
1961      * - `tokenId` token must exist and be owned by `from`.
1962      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1963      *
1964      * Emits a {Transfer} event.
1965      */
1966     function _safeTransfer(
1967         address from,
1968         address to,
1969         uint256 tokenId,
1970         bytes memory data
1971     ) internal virtual {
1972         _transfer(from, to, tokenId);
1973         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1974     }
1975 
1976     /**
1977      * @dev Returns whether `tokenId` exists.
1978      *
1979      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1980      *
1981      * Tokens start existing when they are minted (`_mint`),
1982      * and stop existing when they are burned (`_burn`).
1983      */
1984     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1985         return _owners[tokenId] != address(0);
1986     }
1987 
1988     /**
1989      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1990      *
1991      * Requirements:
1992      *
1993      * - `tokenId` must exist.
1994      */
1995     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1996         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1997         address owner = ERC721.ownerOf(tokenId);
1998         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1999     }
2000 
2001     /**
2002      * @dev Safely mints `tokenId` and transfers it to `to`.
2003      *
2004      * Requirements:
2005      *
2006      * - `tokenId` must not exist.
2007      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2008      *
2009      * Emits a {Transfer} event.
2010      */
2011     function _safeMint(address to, uint256 tokenId) internal virtual {
2012         _safeMint(to, tokenId, "");
2013     }
2014 
2015     /**
2016      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2017      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2018      */
2019     function _safeMint(
2020         address to,
2021         uint256 tokenId,
2022         bytes memory data
2023     ) internal virtual {
2024         _mint(to, tokenId);
2025         require(
2026             _checkOnERC721Received(address(0), to, tokenId, data),
2027             "ERC721: transfer to non ERC721Receiver implementer"
2028         );
2029     }
2030 
2031     /**
2032      * @dev Mints `tokenId` and transfers it to `to`.
2033      *
2034      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2035      *
2036      * Requirements:
2037      *
2038      * - `tokenId` must not exist.
2039      * - `to` cannot be the zero address.
2040      *
2041      * Emits a {Transfer} event.
2042      */
2043     function _mint(address to, uint256 tokenId) internal virtual {
2044         require(to != address(0), "ERC721: mint to the zero address");
2045         require(!_exists(tokenId), "ERC721: token already minted");
2046 
2047         _beforeTokenTransfer(address(0), to, tokenId);
2048 
2049         _balances[to] += 1;
2050         _owners[tokenId] = to;
2051 
2052         emit Transfer(address(0), to, tokenId);
2053 
2054         _afterTokenTransfer(address(0), to, tokenId);
2055     }
2056 
2057     /**
2058      * @dev Destroys `tokenId`.
2059      * The approval is cleared when the token is burned.
2060      *
2061      * Requirements:
2062      *
2063      * - `tokenId` must exist.
2064      *
2065      * Emits a {Transfer} event.
2066      */
2067     function _burn(uint256 tokenId) internal virtual {
2068         address owner = ERC721.ownerOf(tokenId);
2069 
2070         _beforeTokenTransfer(owner, address(0), tokenId);
2071 
2072         // Clear approvals
2073         _approve(address(0), tokenId);
2074 
2075         _balances[owner] -= 1;
2076         delete _owners[tokenId];
2077 
2078         emit Transfer(owner, address(0), tokenId);
2079 
2080         _afterTokenTransfer(owner, address(0), tokenId);
2081     }
2082 
2083     /**
2084      * @dev Transfers `tokenId` from `from` to `to`.
2085      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2086      *
2087      * Requirements:
2088      *
2089      * - `to` cannot be the zero address.
2090      * - `tokenId` token must be owned by `from`.
2091      *
2092      * Emits a {Transfer} event.
2093      */
2094     function _transfer(
2095         address from,
2096         address to,
2097         uint256 tokenId
2098     ) internal virtual {
2099         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2100         require(to != address(0), "ERC721: transfer to the zero address");
2101 
2102         _beforeTokenTransfer(from, to, tokenId);
2103 
2104         // Clear approvals from the previous owner
2105         _approve(address(0), tokenId);
2106 
2107         _balances[from] -= 1;
2108         _balances[to] += 1;
2109         _owners[tokenId] = to;
2110 
2111         emit Transfer(from, to, tokenId);
2112 
2113         _afterTokenTransfer(from, to, tokenId);
2114     }
2115 
2116     /**
2117      * @dev Approve `to` to operate on `tokenId`
2118      *
2119      * Emits an {Approval} event.
2120      */
2121     function _approve(address to, uint256 tokenId) internal virtual {
2122         _tokenApprovals[tokenId] = to;
2123         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2124     }
2125 
2126     /**
2127      * @dev Approve `operator` to operate on all of `owner` tokens
2128      *
2129      * Emits an {ApprovalForAll} event.
2130      */
2131     function _setApprovalForAll(
2132         address owner,
2133         address operator,
2134         bool approved
2135     ) internal virtual {
2136         require(owner != operator, "ERC721: approve to caller");
2137         _operatorApprovals[owner][operator] = approved;
2138         emit ApprovalForAll(owner, operator, approved);
2139     }
2140 
2141     /**
2142      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2143      * The call is not executed if the target address is not a contract.
2144      *
2145      * @param from address representing the previous owner of the given token ID
2146      * @param to target address that will receive the tokens
2147      * @param tokenId uint256 ID of the token to be transferred
2148      * @param data bytes optional data to send along with the call
2149      * @return bool whether the call correctly returned the expected magic value
2150      */
2151     function _checkOnERC721Received(
2152         address from,
2153         address to,
2154         uint256 tokenId,
2155         bytes memory data
2156     ) private returns (bool) {
2157         if (to.isContract()) {
2158             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2159                 return retval == IERC721Receiver.onERC721Received.selector;
2160             } catch (bytes memory reason) {
2161                 if (reason.length == 0) {
2162                     revert("ERC721: transfer to non ERC721Receiver implementer");
2163                 } else {
2164                     assembly {
2165                         revert(add(32, reason), mload(reason))
2166                     }
2167                 }
2168             }
2169         } else {
2170             return true;
2171         }
2172     }
2173 
2174     /**
2175      * @dev Hook that is called before any token transfer. This includes minting
2176      * and burning.
2177      *
2178      * Calling conditions:
2179      *
2180      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2181      * transferred to `to`.
2182      * - When `from` is zero, `tokenId` will be minted for `to`.
2183      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2184      * - `from` and `to` are never both zero.
2185      *
2186      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2187      */
2188     function _beforeTokenTransfer(
2189         address from,
2190         address to,
2191         uint256 tokenId
2192     ) internal virtual {}
2193 
2194     /**
2195      * @dev Hook that is called after any transfer of tokens. This includes
2196      * minting and burning.
2197      *
2198      * Calling conditions:
2199      *
2200      * - when `from` and `to` are both non-zero.
2201      * - `from` and `to` are never both zero.
2202      *
2203      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2204      */
2205     function _afterTokenTransfer(
2206         address from,
2207         address to,
2208         uint256 tokenId
2209     ) internal virtual {}
2210 }
2211 
2212 
2213 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
2214 
2215 pragma solidity ^0.8.0;
2216 
2217 /**
2218  * @dev These functions deal with verification of Merkle Trees proofs.
2219  *
2220  * The proofs can be generated using the JavaScript library
2221  * https://github.com/miguelmota/merkletreejs[merkletreejs].
2222  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
2223  *
2224  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
2225  */
2226 library MerkleProof {
2227     /**
2228      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2229      * defined by `root`. For this, a `proof` must be provided, containing
2230      * sibling hashes on the branch from the leaf to the root of the tree. Each
2231      * pair of leaves and each pair of pre-images are assumed to be sorted.
2232      */
2233     function verify(
2234         bytes32[] memory proof,
2235         bytes32 root,
2236         bytes32 leaf
2237     ) internal pure returns (bool) {
2238         return processProof(proof, leaf) == root;
2239     }
2240 
2241     /**
2242      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
2243      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2244      * hash matches the root of the tree. When processing the proof, the pairs
2245      * of leafs & pre-images are assumed to be sorted.
2246      *
2247      * _Available since v4.4._
2248      */
2249     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2250         bytes32 computedHash = leaf;
2251         for (uint256 i = 0; i < proof.length; i++) {
2252             bytes32 proofElement = proof[i];
2253             if (computedHash <= proofElement) {
2254                 // Hash(current computed hash + current element of the proof)
2255                 computedHash = _efficientHash(computedHash, proofElement);
2256             } else {
2257                 // Hash(current element of the proof + current computed hash)
2258                 computedHash = _efficientHash(proofElement, computedHash);
2259             }
2260         }
2261         return computedHash;
2262     }
2263 
2264     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2265         assembly {
2266             mstore(0x00, a)
2267             mstore(0x20, b)
2268             value := keccak256(0x00, 0x40)
2269         }
2270     }
2271 }
2272 
2273 
2274 
2275 pragma solidity ^0.8.0;
2276 
2277 interface IEYNFT {
2278     enum SaleStatus {
2279         PAUSED,
2280         PRESALE,
2281         PUBLIC
2282     }
2283 }
2284 
2285 
2286 pragma solidity ^0.8.0;
2287 
2288 
2289 contract Emptyeyes is IEYNFT,ERC721A, Ownable {
2290     using Strings for uint256;
2291 
2292     string private baseURI;
2293 
2294     uint256 public ogMaxPerTx = 25;
2295 
2296     uint256 public wlMaxPerTx = 15;
2297 
2298     uint256 public maxPerTx = 3;
2299 
2300     uint256 public maxSupply = 6300;
2301 
2302     address private _paymentAddress;    
2303 
2304     bytes32 public ogMerkleRoot;
2305 
2306     bytes32 public wlMerkleRoot;
2307 
2308     SaleStatus public saleStatus = SaleStatus.PAUSED;
2309 
2310 
2311     mapping(address => uint256) private _ogMintedCount;
2312     mapping(address => uint256) private _wlMintedCount;
2313     mapping(address => uint256) private _mintedCount;
2314 
2315     constructor(address paymentAddress) ERC721A("Empty eyes", "Empty eyes")
2316     {
2317         _paymentAddress = paymentAddress;
2318     }
2319 
2320     modifier mintCheck(SaleStatus status, uint256 count) {
2321         require(saleStatus == status, "Emptyeyes: Not operational");
2322         require(
2323             _totalMinted() + count <= maxSupply,
2324             "Emptyeyes: Number of requested tokens will exceed max supply"
2325         );
2326         _;
2327     }
2328 
2329     function setOgMerkleRoot(bytes32 root) external  onlyOwner {
2330         ogMerkleRoot = root;
2331     }
2332 
2333     function setWlMerkleRoot(bytes32 root) external  onlyOwner {
2334         wlMerkleRoot = root;
2335     }
2336 
2337 
2338     function mintOgWhitelist(bytes32[] calldata merkleProof, uint256 count) external
2339         payable 
2340         mintCheck(SaleStatus.PRESALE, count)
2341     {
2342         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2343         require(
2344             MerkleProof.verify(merkleProof, ogMerkleRoot, leaf),
2345             "Emptyeyes: You are not  whitelisted"
2346         );
2347         require(
2348             _ogMintedCount[msg.sender] + count <= ogMaxPerTx,
2349             "Emptyeyes: Number of requested tokens will exceed the limit per account"
2350         );
2351         _ogMintedCount[msg.sender] += count;
2352         _safeMint(msg.sender, count);
2353     }
2354 
2355     function mintWlWhitelist(bytes32[] calldata merkleProof, uint256 count) external
2356         payable 
2357         mintCheck(SaleStatus.PRESALE, count)
2358     {
2359         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2360         require(
2361             MerkleProof.verify(merkleProof, wlMerkleRoot, leaf),
2362             "Emptyeyes: You are not  whitelisted"
2363         );
2364         require(
2365             _wlMintedCount[msg.sender] + count <= wlMaxPerTx,
2366             "Emptyeyes: Number of requested tokens will exceed the limit per account"
2367         );
2368         _wlMintedCount[msg.sender] += count;
2369         _safeMint(msg.sender, count);
2370     }
2371 
2372 
2373     function mint(uint256 count) external
2374         payable 
2375         mintCheck(SaleStatus.PUBLIC, count)
2376     {
2377         require(
2378             _mintedCount[msg.sender] + count <= maxPerTx,
2379             "Emptyeyes: Number of requested tokens will exceed the limit per account"
2380         );
2381         _mintedCount[msg.sender] += count;
2382         _safeMint(msg.sender, count);
2383     }
2384 
2385     function setSaleStatus(SaleStatus status) external  onlyOwner {
2386         saleStatus = status;
2387     }
2388 
2389 
2390     function _baseURI() internal view virtual override returns (string memory) {
2391         return baseURI;
2392     }
2393 
2394     function tokenURI(uint256 tokenId)
2395         public
2396         view
2397         virtual
2398         override
2399         returns (string memory)
2400     {
2401         require(
2402             _exists(tokenId),
2403             "Emptyeyes: URI query for nonexistent token"
2404         );
2405         return  bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "ipfs://bafkreieqr5pfn4sz5v2ikgqkuhk4w2dpeeh5zdratbsfme6wcbzezury24";
2406     }
2407 
2408     function setBaseURI(string memory uri) public onlyOwner {
2409         baseURI = uri;
2410     }
2411 
2412     function withdraw() external  onlyOwner {
2413         uint256 balance = address(this).balance;
2414         require(balance > 0, "Emptyeyes: Insufficient balance");
2415         (bool success, ) = payable(_paymentAddress).call{value: balance}("");
2416         require(success, "Emptyeyes: Withdrawal failed");
2417     }
2418 
2419     function airDrop(uint256 quantity, address[] calldata _address) external onlyOwner returns (uint256) {
2420         require(quantity > 0 && totalSupply() + quantity <= maxSupply, "Emptyeyes: Invalid amount!");
2421         uint256 i = 0;
2422         while (i < _address.length) {
2423             _safeMint(_address[i], quantity);
2424             i += 1;
2425         }
2426         return(i);
2427     }
2428 
2429 }