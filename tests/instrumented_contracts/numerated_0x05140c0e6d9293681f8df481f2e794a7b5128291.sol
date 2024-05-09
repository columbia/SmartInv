1 // SPDX-License-Identifier: Unlicensed
2 // File: erc721a/contracts/IERC721A.sol
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
264 
265 // File: erc721a/contracts/ERC721A.sol
266 
267 
268 // ERC721A Contracts v4.0.0
269 // Creator: Chiru Labs
270 
271 pragma solidity ^0.8.4;
272 
273 
274 /**
275  * @dev ERC721 token receiver interface.
276  */
277 interface ERC721A__IERC721Receiver {
278     function onERC721Received(
279         address operator,
280         address from,
281         uint256 tokenId,
282         bytes calldata data
283     ) external returns (bytes4);
284 }
285 
286 /**
287  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
288  * the Metadata extension. Built to optimize for lower gas during batch mints.
289  *
290  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
291  *
292  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
293  *
294  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
295  */
296 contract ERC721A is IERC721A {
297     // Mask of an entry in packed address data.
298     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
299 
300     // The bit position of `numberMinted` in packed address data.
301     uint256 private constant BITPOS_NUMBER_MINTED = 64;
302 
303     // The bit position of `numberBurned` in packed address data.
304     uint256 private constant BITPOS_NUMBER_BURNED = 128;
305 
306     // The bit position of `aux` in packed address data.
307     uint256 private constant BITPOS_AUX = 192;
308 
309     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
310     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
311 
312     // The bit position of `startTimestamp` in packed ownership.
313     uint256 private constant BITPOS_START_TIMESTAMP = 160;
314 
315     // The bit mask of the `burned` bit in packed ownership.
316     uint256 private constant BITMASK_BURNED = 1 << 224;
317     
318     // The bit position of the `nextInitialized` bit in packed ownership.
319     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
320 
321     // The bit mask of the `nextInitialized` bit in packed ownership.
322     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
323 
324     // The tokenId of the next token to be minted.
325     uint256 private _currentIndex;
326 
327     // The number of tokens burned.
328     uint256 private _burnCounter;
329 
330     // Token name
331     string private _name;
332 
333     // Token symbol
334     string private _symbol;
335 
336     // Mapping from token ID to ownership details
337     // An empty struct value does not necessarily mean the token is unowned.
338     // See `_packedOwnershipOf` implementation for details.
339     //
340     // Bits Layout:
341     // - [0..159]   `addr`
342     // - [160..223] `startTimestamp`
343     // - [224]      `burned`
344     // - [225]      `nextInitialized`
345     mapping(uint256 => uint256) private _packedOwnerships;
346 
347     // Mapping owner address to address data.
348     //
349     // Bits Layout:
350     // - [0..63]    `balance`
351     // - [64..127]  `numberMinted`
352     // - [128..191] `numberBurned`
353     // - [192..255] `aux`
354     mapping(address => uint256) private _packedAddressData;
355 
356     // Mapping from token ID to approved address.
357     mapping(uint256 => address) private _tokenApprovals;
358 
359     // Mapping from owner to operator approvals
360     mapping(address => mapping(address => bool)) private _operatorApprovals;
361 
362     constructor(string memory name_, string memory symbol_) {
363         _name = name_;
364         _symbol = symbol_;
365         _currentIndex = _startTokenId();
366     }
367 
368     /**
369      * @dev Returns the starting token ID. 
370      * To change the starting token ID, please override this function.
371      */
372     function _startTokenId() internal view virtual returns (uint256) {
373         return 0;
374     }
375 
376     /**
377      * @dev Returns the next token ID to be minted.
378      */
379     function _nextTokenId() internal view returns (uint256) {
380         return _currentIndex;
381     }
382 
383     /**
384      * @dev Returns the total number of tokens in existence.
385      * Burned tokens will reduce the count. 
386      * To get the total number of tokens minted, please see `_totalMinted`.
387      */
388     function totalSupply() public view override returns (uint256) {
389         // Counter underflow is impossible as _burnCounter cannot be incremented
390         // more than `_currentIndex - _startTokenId()` times.
391         unchecked {
392             return _currentIndex - _burnCounter - _startTokenId();
393         }
394     }
395 
396     /**
397      * @dev Returns the total amount of tokens minted in the contract.
398      */
399     function _totalMinted() internal view returns (uint256) {
400         // Counter underflow is impossible as _currentIndex does not decrement,
401         // and it is initialized to `_startTokenId()`
402         unchecked {
403             return _currentIndex - _startTokenId();
404         }
405     }
406 
407     /**
408      * @dev Returns the total number of tokens burned.
409      */
410     function _totalBurned() internal view returns (uint256) {
411         return _burnCounter;
412     }
413 
414     /**
415      * @dev See {IERC165-supportsInterface}.
416      */
417     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
418         // The interface IDs are constants representing the first 4 bytes of the XOR of
419         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
420         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
421         return
422             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
423             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
424             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
425     }
426 
427     /**
428      * @dev See {IERC721-balanceOf}.
429      */
430     function balanceOf(address owner) public view override returns (uint256) {
431         if (owner == address(0)) revert BalanceQueryForZeroAddress();
432         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
433     }
434 
435     /**
436      * Returns the number of tokens minted by `owner`.
437      */
438     function _numberMinted(address owner) internal view returns (uint256) {
439         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
440     }
441 
442     /**
443      * Returns the number of tokens burned by or on behalf of `owner`.
444      */
445     function _numberBurned(address owner) internal view returns (uint256) {
446         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
447     }
448 
449     /**
450      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
451      */
452     function _getAux(address owner) internal view returns (uint64) {
453         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
454     }
455 
456     /**
457      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
458      * If there are multiple variables, please pack them into a uint64.
459      */
460     function _setAux(address owner, uint64 aux) internal {
461         uint256 packed = _packedAddressData[owner];
462         uint256 auxCasted;
463         assembly { // Cast aux without masking.
464             auxCasted := aux
465         }
466         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
467         _packedAddressData[owner] = packed;
468     }
469 
470     /**
471      * Returns the packed ownership data of `tokenId`.
472      */
473     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
474         uint256 curr = tokenId;
475 
476         unchecked {
477             if (_startTokenId() <= curr)
478                 if (curr < _currentIndex) {
479                     uint256 packed = _packedOwnerships[curr];
480                     // If not burned.
481                     if (packed & BITMASK_BURNED == 0) {
482                         // Invariant:
483                         // There will always be an ownership that has an address and is not burned
484                         // before an ownership that does not have an address and is not burned.
485                         // Hence, curr will not underflow.
486                         //
487                         // We can directly compare the packed value.
488                         // If the address is zero, packed is zero.
489                         while (packed == 0) {
490                             packed = _packedOwnerships[--curr];
491                         }
492                         return packed;
493                     }
494                 }
495         }
496         revert OwnerQueryForNonexistentToken();
497     }
498 
499     /**
500      * Returns the unpacked `TokenOwnership` struct from `packed`.
501      */
502     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
503         ownership.addr = address(uint160(packed));
504         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
505         ownership.burned = packed & BITMASK_BURNED != 0;
506     }
507 
508     /**
509      * Returns the unpacked `TokenOwnership` struct at `index`.
510      */
511     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
512         return _unpackedOwnership(_packedOwnerships[index]);
513     }
514 
515     /**
516      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
517      */
518     function _initializeOwnershipAt(uint256 index) internal {
519         if (_packedOwnerships[index] == 0) {
520             _packedOwnerships[index] = _packedOwnershipOf(index);
521         }
522     }
523 
524     /**
525      * Gas spent here starts off proportional to the maximum mint batch size.
526      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
527      */
528     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
529         return _unpackedOwnership(_packedOwnershipOf(tokenId));
530     }
531 
532     /**
533      * @dev See {IERC721-ownerOf}.
534      */
535     function ownerOf(uint256 tokenId) public view override returns (address) {
536         return address(uint160(_packedOwnershipOf(tokenId)));
537     }
538 
539     /**
540      * @dev See {IERC721Metadata-name}.
541      */
542     function name() public view virtual override returns (string memory) {
543         return _name;
544     }
545 
546     /**
547      * @dev See {IERC721Metadata-symbol}.
548      */
549     function symbol() public view virtual override returns (string memory) {
550         return _symbol;
551     }
552 
553     /**
554      * @dev See {IERC721Metadata-tokenURI}.
555      */
556     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
557         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
558 
559         string memory baseURI = _baseURI();
560         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
561     }
562 
563     /**
564      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
565      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
566      * by default, can be overriden in child contracts.
567      */
568     function _baseURI() internal view virtual returns (string memory) {
569         return '';
570     }
571 
572     /**
573      * @dev Casts the address to uint256 without masking.
574      */
575     function _addressToUint256(address value) private pure returns (uint256 result) {
576         assembly {
577             result := value
578         }
579     }
580 
581     /**
582      * @dev Casts the boolean to uint256 without branching.
583      */
584     function _boolToUint256(bool value) private pure returns (uint256 result) {
585         assembly {
586             result := value
587         }
588     }
589 
590     /**
591      * @dev See {IERC721-approve}.
592      */
593     function approve(address to, uint256 tokenId) public override {
594         address owner = address(uint160(_packedOwnershipOf(tokenId)));
595         if (to == owner) revert ApprovalToCurrentOwner();
596 
597         if (_msgSenderERC721A() != owner)
598             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
599                 revert ApprovalCallerNotOwnerNorApproved();
600             }
601 
602         _tokenApprovals[tokenId] = to;
603         emit Approval(owner, to, tokenId);
604     }
605 
606     /**
607      * @dev See {IERC721-getApproved}.
608      */
609     function getApproved(uint256 tokenId) public view override returns (address) {
610         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
611 
612         return _tokenApprovals[tokenId];
613     }
614 
615     /**
616      * @dev See {IERC721-setApprovalForAll}.
617      */
618     function setApprovalForAll(address operator, bool approved) public virtual override {
619         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
620 
621         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
622         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
623     }
624 
625     /**
626      * @dev See {IERC721-isApprovedForAll}.
627      */
628     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
629         return _operatorApprovals[owner][operator];
630     }
631 
632     /**
633      * @dev See {IERC721-transferFrom}.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) public virtual override {
640         _transfer(from, to, tokenId);
641     }
642 
643     /**
644      * @dev See {IERC721-safeTransferFrom}.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) public virtual override {
651         safeTransferFrom(from, to, tokenId, '');
652     }
653 
654     /**
655      * @dev See {IERC721-safeTransferFrom}.
656      */
657     function safeTransferFrom(
658         address from,
659         address to,
660         uint256 tokenId,
661         bytes memory _data
662     ) public virtual override {
663         _transfer(from, to, tokenId);
664         if (to.code.length != 0)
665             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
666                 revert TransferToNonERC721ReceiverImplementer();
667             }
668     }
669 
670     /**
671      * @dev Returns whether `tokenId` exists.
672      *
673      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
674      *
675      * Tokens start existing when they are minted (`_mint`),
676      */
677     function _exists(uint256 tokenId) internal view returns (bool) {
678         return
679             _startTokenId() <= tokenId &&
680             tokenId < _currentIndex && // If within bounds,
681             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
682     }
683 
684     /**
685      * @dev Equivalent to `_safeMint(to, quantity, '')`.
686      */
687     function _safeMint(address to, uint256 quantity) internal {
688         _safeMint(to, quantity, '');
689     }
690 
691     /**
692      * @dev Safely mints `quantity` tokens and transfers them to `to`.
693      *
694      * Requirements:
695      *
696      * - If `to` refers to a smart contract, it must implement
697      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
698      * - `quantity` must be greater than 0.
699      *
700      * Emits a {Transfer} event.
701      */
702     function _safeMint(
703         address to,
704         uint256 quantity,
705         bytes memory _data
706     ) internal {
707         uint256 startTokenId = _currentIndex;
708         if (to == address(0)) revert MintToZeroAddress();
709         if (quantity == 0) revert MintZeroQuantity();
710 
711         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
712 
713         // Overflows are incredibly unrealistic.
714         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
715         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
716         unchecked {
717             // Updates:
718             // - `balance += quantity`.
719             // - `numberMinted += quantity`.
720             //
721             // We can directly add to the balance and number minted.
722             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
723 
724             // Updates:
725             // - `address` to the owner.
726             // - `startTimestamp` to the timestamp of minting.
727             // - `burned` to `false`.
728             // - `nextInitialized` to `quantity == 1`.
729             _packedOwnerships[startTokenId] =
730                 _addressToUint256(to) |
731                 (block.timestamp << BITPOS_START_TIMESTAMP) |
732                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
733 
734             uint256 updatedIndex = startTokenId;
735             uint256 end = updatedIndex + quantity;
736 
737             if (to.code.length != 0) {
738                 do {
739                     emit Transfer(address(0), to, updatedIndex);
740                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
741                         revert TransferToNonERC721ReceiverImplementer();
742                     }
743                 } while (updatedIndex < end);
744                 // Reentrancy protection
745                 if (_currentIndex != startTokenId) revert();
746             } else {
747                 do {
748                     emit Transfer(address(0), to, updatedIndex++);
749                 } while (updatedIndex < end);
750             }
751             _currentIndex = updatedIndex;
752         }
753         _afterTokenTransfers(address(0), to, startTokenId, quantity);
754     }
755 
756     /**
757      * @dev Mints `quantity` tokens and transfers them to `to`.
758      *
759      * Requirements:
760      *
761      * - `to` cannot be the zero address.
762      * - `quantity` must be greater than 0.
763      *
764      * Emits a {Transfer} event.
765      */
766     function _mint(address to, uint256 quantity) internal {
767         uint256 startTokenId = _currentIndex;
768         if (to == address(0)) revert MintToZeroAddress();
769         if (quantity == 0) revert MintZeroQuantity();
770 
771         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
772 
773         // Overflows are incredibly unrealistic.
774         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
775         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
776         unchecked {
777             // Updates:
778             // - `balance += quantity`.
779             // - `numberMinted += quantity`.
780             //
781             // We can directly add to the balance and number minted.
782             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
783 
784             // Updates:
785             // - `address` to the owner.
786             // - `startTimestamp` to the timestamp of minting.
787             // - `burned` to `false`.
788             // - `nextInitialized` to `quantity == 1`.
789             _packedOwnerships[startTokenId] =
790                 _addressToUint256(to) |
791                 (block.timestamp << BITPOS_START_TIMESTAMP) |
792                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
793 
794             uint256 updatedIndex = startTokenId;
795             uint256 end = updatedIndex + quantity;
796 
797             do {
798                 emit Transfer(address(0), to, updatedIndex++);
799             } while (updatedIndex < end);
800 
801             _currentIndex = updatedIndex;
802         }
803         _afterTokenTransfers(address(0), to, startTokenId, quantity);
804     }
805 
806     /**
807      * @dev Transfers `tokenId` from `from` to `to`.
808      *
809      * Requirements:
810      *
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must be owned by `from`.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _transfer(
817         address from,
818         address to,
819         uint256 tokenId
820     ) private {
821         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
822 
823         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
824 
825         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
826             isApprovedForAll(from, _msgSenderERC721A()) ||
827             getApproved(tokenId) == _msgSenderERC721A());
828 
829         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
830         if (to == address(0)) revert TransferToZeroAddress();
831 
832         _beforeTokenTransfers(from, to, tokenId, 1);
833 
834         // Clear approvals from the previous owner.
835         delete _tokenApprovals[tokenId];
836 
837         // Underflow of the sender's balance is impossible because we check for
838         // ownership above and the recipient's balance can't realistically overflow.
839         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
840         unchecked {
841             // We can directly increment and decrement the balances.
842             --_packedAddressData[from]; // Updates: `balance -= 1`.
843             ++_packedAddressData[to]; // Updates: `balance += 1`.
844 
845             // Updates:
846             // - `address` to the next owner.
847             // - `startTimestamp` to the timestamp of transfering.
848             // - `burned` to `false`.
849             // - `nextInitialized` to `true`.
850             _packedOwnerships[tokenId] =
851                 _addressToUint256(to) |
852                 (block.timestamp << BITPOS_START_TIMESTAMP) |
853                 BITMASK_NEXT_INITIALIZED;
854 
855             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
856             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
857                 uint256 nextTokenId = tokenId + 1;
858                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
859                 if (_packedOwnerships[nextTokenId] == 0) {
860                     // If the next slot is within bounds.
861                     if (nextTokenId != _currentIndex) {
862                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
863                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
864                     }
865                 }
866             }
867         }
868 
869         emit Transfer(from, to, tokenId);
870         _afterTokenTransfers(from, to, tokenId, 1);
871     }
872 
873     /**
874      * @dev Equivalent to `_burn(tokenId, false)`.
875      */
876     function _burn(uint256 tokenId) internal virtual {
877         _burn(tokenId, false);
878     }
879 
880     /**
881      * @dev Destroys `tokenId`.
882      * The approval is cleared when the token is burned.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
891         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
892 
893         address from = address(uint160(prevOwnershipPacked));
894 
895         if (approvalCheck) {
896             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
897                 isApprovedForAll(from, _msgSenderERC721A()) ||
898                 getApproved(tokenId) == _msgSenderERC721A());
899 
900             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
901         }
902 
903         _beforeTokenTransfers(from, address(0), tokenId, 1);
904 
905         // Clear approvals from the previous owner.
906         delete _tokenApprovals[tokenId];
907 
908         // Underflow of the sender's balance is impossible because we check for
909         // ownership above and the recipient's balance can't realistically overflow.
910         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
911         unchecked {
912             // Updates:
913             // - `balance -= 1`.
914             // - `numberBurned += 1`.
915             //
916             // We can directly decrement the balance, and increment the number burned.
917             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
918             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
919 
920             // Updates:
921             // - `address` to the last owner.
922             // - `startTimestamp` to the timestamp of burning.
923             // - `burned` to `true`.
924             // - `nextInitialized` to `true`.
925             _packedOwnerships[tokenId] =
926                 _addressToUint256(from) |
927                 (block.timestamp << BITPOS_START_TIMESTAMP) |
928                 BITMASK_BURNED | 
929                 BITMASK_NEXT_INITIALIZED;
930 
931             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
932             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
933                 uint256 nextTokenId = tokenId + 1;
934                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
935                 if (_packedOwnerships[nextTokenId] == 0) {
936                     // If the next slot is within bounds.
937                     if (nextTokenId != _currentIndex) {
938                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
939                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
940                     }
941                 }
942             }
943         }
944 
945         emit Transfer(from, address(0), tokenId);
946         _afterTokenTransfers(from, address(0), tokenId, 1);
947 
948         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
949         unchecked {
950             _burnCounter++;
951         }
952     }
953 
954     /**
955      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
956      *
957      * @param from address representing the previous owner of the given token ID
958      * @param to target address that will receive the tokens
959      * @param tokenId uint256 ID of the token to be transferred
960      * @param _data bytes optional data to send along with the call
961      * @return bool whether the call correctly returned the expected magic value
962      */
963     function _checkContractOnERC721Received(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) private returns (bool) {
969         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
970             bytes4 retval
971         ) {
972             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
973         } catch (bytes memory reason) {
974             if (reason.length == 0) {
975                 revert TransferToNonERC721ReceiverImplementer();
976             } else {
977                 assembly {
978                     revert(add(32, reason), mload(reason))
979                 }
980             }
981         }
982     }
983 
984     /**
985      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
986      * And also called before burning one token.
987      *
988      * startTokenId - the first token id to be transferred
989      * quantity - the amount to be transferred
990      *
991      * Calling conditions:
992      *
993      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
994      * transferred to `to`.
995      * - When `from` is zero, `tokenId` will be minted for `to`.
996      * - When `to` is zero, `tokenId` will be burned by `from`.
997      * - `from` and `to` are never both zero.
998      */
999     function _beforeTokenTransfers(
1000         address from,
1001         address to,
1002         uint256 startTokenId,
1003         uint256 quantity
1004     ) internal virtual {}
1005 
1006     /**
1007      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1008      * minting.
1009      * And also called after one token has been burned.
1010      *
1011      * startTokenId - the first token id to be transferred
1012      * quantity - the amount to be transferred
1013      *
1014      * Calling conditions:
1015      *
1016      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1017      * transferred to `to`.
1018      * - When `from` is zero, `tokenId` has been minted for `to`.
1019      * - When `to` is zero, `tokenId` has been burned by `from`.
1020      * - `from` and `to` are never both zero.
1021      */
1022     function _afterTokenTransfers(
1023         address from,
1024         address to,
1025         uint256 startTokenId,
1026         uint256 quantity
1027     ) internal virtual {}
1028 
1029     /**
1030      * @dev Returns the message sender (defaults to `msg.sender`).
1031      *
1032      * If you are writing GSN compatible contracts, you need to override this function.
1033      */
1034     function _msgSenderERC721A() internal view virtual returns (address) {
1035         return msg.sender;
1036     }
1037 
1038     /**
1039      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1040      */
1041     function _toString(uint256 value) internal pure returns (string memory ptr) {
1042         assembly {
1043             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1044             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1045             // We will need 1 32-byte word to store the length, 
1046             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1047             ptr := add(mload(0x40), 128)
1048             // Update the free memory pointer to allocate.
1049             mstore(0x40, ptr)
1050 
1051             // Cache the end of the memory to calculate the length later.
1052             let end := ptr
1053 
1054             // We write the string from the rightmost digit to the leftmost digit.
1055             // The following is essentially a do-while loop that also handles the zero case.
1056             // Costs a bit more than early returning for the zero case,
1057             // but cheaper in terms of deployment and overall runtime costs.
1058             for { 
1059                 // Initialize and perform the first pass without check.
1060                 let temp := value
1061                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1062                 ptr := sub(ptr, 1)
1063                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1064                 mstore8(ptr, add(48, mod(temp, 10)))
1065                 temp := div(temp, 10)
1066             } temp { 
1067                 // Keep dividing `temp` until zero.
1068                 temp := div(temp, 10)
1069             } { // Body of the for loop.
1070                 ptr := sub(ptr, 1)
1071                 mstore8(ptr, add(48, mod(temp, 10)))
1072             }
1073             
1074             let length := sub(end, ptr)
1075             // Move the pointer 32 bytes leftwards to make room for the length.
1076             ptr := sub(ptr, 32)
1077             // Store the length.
1078             mstore(ptr, length)
1079         }
1080     }
1081 }
1082 
1083 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1084 
1085 
1086 // ERC721A Contracts v4.0.0
1087 // Creator: Chiru Labs
1088 
1089 pragma solidity ^0.8.4;
1090 
1091 
1092 /**
1093  * @dev Interface of an ERC721AQueryable compliant contract.
1094  */
1095 interface IERC721AQueryable is IERC721A {
1096     /**
1097      * Invalid query range (`start` >= `stop`).
1098      */
1099     error InvalidQueryRange();
1100 
1101     /**
1102      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1103      *
1104      * If the `tokenId` is out of bounds:
1105      *   - `addr` = `address(0)`
1106      *   - `startTimestamp` = `0`
1107      *   - `burned` = `false`
1108      *
1109      * If the `tokenId` is burned:
1110      *   - `addr` = `<Address of owner before token was burned>`
1111      *   - `startTimestamp` = `<Timestamp when token was burned>`
1112      *   - `burned = `true`
1113      *
1114      * Otherwise:
1115      *   - `addr` = `<Address of owner>`
1116      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1117      *   - `burned = `false`
1118      */
1119     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1120 
1121     /**
1122      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1123      * See {ERC721AQueryable-explicitOwnershipOf}
1124      */
1125     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1126 
1127     /**
1128      * @dev Returns an array of token IDs owned by `owner`,
1129      * in the range [`start`, `stop`)
1130      * (i.e. `start <= tokenId < stop`).
1131      *
1132      * This function allows for tokens to be queried if the collection
1133      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1134      *
1135      * Requirements:
1136      *
1137      * - `start` < `stop`
1138      */
1139     function tokensOfOwnerIn(
1140         address owner,
1141         uint256 start,
1142         uint256 stop
1143     ) external view returns (uint256[] memory);
1144 
1145     /**
1146      * @dev Returns an array of token IDs owned by `owner`.
1147      *
1148      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1149      * It is meant to be called off-chain.
1150      *
1151      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1152      * multiple smaller scans if the collection is large enough to cause
1153      * an out-of-gas error (10K pfp collections should be fine).
1154      */
1155     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1156 }
1157 
1158 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1159 
1160 
1161 // ERC721A Contracts v4.0.0
1162 // Creator: Chiru Labs
1163 
1164 pragma solidity ^0.8.4;
1165 
1166 
1167 
1168 /**
1169  * @title ERC721A Queryable
1170  * @dev ERC721A subclass with convenience query functions.
1171  */
1172 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1173     /**
1174      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1175      *
1176      * If the `tokenId` is out of bounds:
1177      *   - `addr` = `address(0)`
1178      *   - `startTimestamp` = `0`
1179      *   - `burned` = `false`
1180      *
1181      * If the `tokenId` is burned:
1182      *   - `addr` = `<Address of owner before token was burned>`
1183      *   - `startTimestamp` = `<Timestamp when token was burned>`
1184      *   - `burned = `true`
1185      *
1186      * Otherwise:
1187      *   - `addr` = `<Address of owner>`
1188      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1189      *   - `burned = `false`
1190      */
1191     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1192         TokenOwnership memory ownership;
1193         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1194             return ownership;
1195         }
1196         ownership = _ownershipAt(tokenId);
1197         if (ownership.burned) {
1198             return ownership;
1199         }
1200         return _ownershipOf(tokenId);
1201     }
1202 
1203     /**
1204      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1205      * See {ERC721AQueryable-explicitOwnershipOf}
1206      */
1207     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1208         unchecked {
1209             uint256 tokenIdsLength = tokenIds.length;
1210             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1211             for (uint256 i; i != tokenIdsLength; ++i) {
1212                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1213             }
1214             return ownerships;
1215         }
1216     }
1217 
1218     /**
1219      * @dev Returns an array of token IDs owned by `owner`,
1220      * in the range [`start`, `stop`)
1221      * (i.e. `start <= tokenId < stop`).
1222      *
1223      * This function allows for tokens to be queried if the collection
1224      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1225      *
1226      * Requirements:
1227      *
1228      * - `start` < `stop`
1229      */
1230     function tokensOfOwnerIn(
1231         address owner,
1232         uint256 start,
1233         uint256 stop
1234     ) external view override returns (uint256[] memory) {
1235         unchecked {
1236             if (start >= stop) revert InvalidQueryRange();
1237             uint256 tokenIdsIdx;
1238             uint256 stopLimit = _nextTokenId();
1239             // Set `start = max(start, _startTokenId())`.
1240             if (start < _startTokenId()) {
1241                 start = _startTokenId();
1242             }
1243             // Set `stop = min(stop, stopLimit)`.
1244             if (stop > stopLimit) {
1245                 stop = stopLimit;
1246             }
1247             uint256 tokenIdsMaxLength = balanceOf(owner);
1248             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1249             // to cater for cases where `balanceOf(owner)` is too big.
1250             if (start < stop) {
1251                 uint256 rangeLength = stop - start;
1252                 if (rangeLength < tokenIdsMaxLength) {
1253                     tokenIdsMaxLength = rangeLength;
1254                 }
1255             } else {
1256                 tokenIdsMaxLength = 0;
1257             }
1258             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1259             if (tokenIdsMaxLength == 0) {
1260                 return tokenIds;
1261             }
1262             // We need to call `explicitOwnershipOf(start)`,
1263             // because the slot at `start` may not be initialized.
1264             TokenOwnership memory ownership = explicitOwnershipOf(start);
1265             address currOwnershipAddr;
1266             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1267             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1268             if (!ownership.burned) {
1269                 currOwnershipAddr = ownership.addr;
1270             }
1271             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1272                 ownership = _ownershipAt(i);
1273                 if (ownership.burned) {
1274                     continue;
1275                 }
1276                 if (ownership.addr != address(0)) {
1277                     currOwnershipAddr = ownership.addr;
1278                 }
1279                 if (currOwnershipAddr == owner) {
1280                     tokenIds[tokenIdsIdx++] = i;
1281                 }
1282             }
1283             // Downsize the array to fit.
1284             assembly {
1285                 mstore(tokenIds, tokenIdsIdx)
1286             }
1287             return tokenIds;
1288         }
1289     }
1290 
1291     /**
1292      * @dev Returns an array of token IDs owned by `owner`.
1293      *
1294      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1295      * It is meant to be called off-chain.
1296      *
1297      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1298      * multiple smaller scans if the collection is large enough to cause
1299      * an out-of-gas error (10K pfp collections should be fine).
1300      */
1301     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1302         unchecked {
1303             uint256 tokenIdsIdx;
1304             address currOwnershipAddr;
1305             uint256 tokenIdsLength = balanceOf(owner);
1306             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1307             TokenOwnership memory ownership;
1308             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1309                 ownership = _ownershipAt(i);
1310                 if (ownership.burned) {
1311                     continue;
1312                 }
1313                 if (ownership.addr != address(0)) {
1314                     currOwnershipAddr = ownership.addr;
1315                 }
1316                 if (currOwnershipAddr == owner) {
1317                     tokenIds[tokenIdsIdx++] = i;
1318                 }
1319             }
1320             return tokenIds;
1321         }
1322     }
1323 }
1324 
1325 // File: @openzeppelin/contracts/utils/Strings.sol
1326 
1327 
1328 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1329 
1330 pragma solidity ^0.8.0;
1331 
1332 /**
1333  * @dev String operations.
1334  */
1335 library Strings {
1336     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1337 
1338     /**
1339      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1340      */
1341     function toString(uint256 value) internal pure returns (string memory) {
1342         // Inspired by OraclizeAPI's implementation - MIT licence
1343         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1344 
1345         if (value == 0) {
1346             return "0";
1347         }
1348         uint256 temp = value;
1349         uint256 digits;
1350         while (temp != 0) {
1351             digits++;
1352             temp /= 10;
1353         }
1354         bytes memory buffer = new bytes(digits);
1355         while (value != 0) {
1356             digits -= 1;
1357             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1358             value /= 10;
1359         }
1360         return string(buffer);
1361     }
1362 
1363     /**
1364      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1365      */
1366     function toHexString(uint256 value) internal pure returns (string memory) {
1367         if (value == 0) {
1368             return "0x00";
1369         }
1370         uint256 temp = value;
1371         uint256 length = 0;
1372         while (temp != 0) {
1373             length++;
1374             temp >>= 8;
1375         }
1376         return toHexString(value, length);
1377     }
1378 
1379     /**
1380      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1381      */
1382     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1383         bytes memory buffer = new bytes(2 * length + 2);
1384         buffer[0] = "0";
1385         buffer[1] = "x";
1386         for (uint256 i = 2 * length + 1; i > 1; --i) {
1387             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1388             value >>= 4;
1389         }
1390         require(value == 0, "Strings: hex length insufficient");
1391         return string(buffer);
1392     }
1393 }
1394 
1395 // File: @openzeppelin/contracts/utils/math/Math.sol
1396 
1397 
1398 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
1399 
1400 pragma solidity ^0.8.0;
1401 
1402 /**
1403  * @dev Standard math utilities missing in the Solidity language.
1404  */
1405 library Math {
1406     /**
1407      * @dev Returns the largest of two numbers.
1408      */
1409     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1410         return a >= b ? a : b;
1411     }
1412 
1413     /**
1414      * @dev Returns the smallest of two numbers.
1415      */
1416     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1417         return a < b ? a : b;
1418     }
1419 
1420     /**
1421      * @dev Returns the average of two numbers. The result is rounded towards
1422      * zero.
1423      */
1424     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1425         // (a + b) / 2 can overflow.
1426         return (a & b) + (a ^ b) / 2;
1427     }
1428 
1429     /**
1430      * @dev Returns the ceiling of the division of two numbers.
1431      *
1432      * This differs from standard division with `/` in that it rounds up instead
1433      * of rounding down.
1434      */
1435     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1436         // (a + b - 1) / b can overflow on addition, so we distribute.
1437         return a / b + (a % b == 0 ? 0 : 1);
1438     }
1439 }
1440 
1441 // File: @openzeppelin/contracts/utils/Arrays.sol
1442 
1443 
1444 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
1445 
1446 pragma solidity ^0.8.0;
1447 
1448 
1449 /**
1450  * @dev Collection of functions related to array types.
1451  */
1452 library Arrays {
1453     /**
1454      * @dev Searches a sorted `array` and returns the first index that contains
1455      * a value greater or equal to `element`. If no such index exists (i.e. all
1456      * values in the array are strictly less than `element`), the array length is
1457      * returned. Time complexity O(log n).
1458      *
1459      * `array` is expected to be sorted in ascending order, and to contain no
1460      * repeated elements.
1461      */
1462     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1463         if (array.length == 0) {
1464             return 0;
1465         }
1466 
1467         uint256 low = 0;
1468         uint256 high = array.length;
1469 
1470         while (low < high) {
1471             uint256 mid = Math.average(low, high);
1472 
1473             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1474             // because Math.average rounds down (it does integer division with truncation).
1475             if (array[mid] > element) {
1476                 high = mid;
1477             } else {
1478                 low = mid + 1;
1479             }
1480         }
1481 
1482         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1483         if (low > 0 && array[low - 1] == element) {
1484             return low - 1;
1485         } else {
1486             return low;
1487         }
1488     }
1489 }
1490 
1491 // File: @openzeppelin/contracts/utils/Context.sol
1492 
1493 
1494 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1495 
1496 pragma solidity ^0.8.0;
1497 
1498 /**
1499  * @dev Provides information about the current execution context, including the
1500  * sender of the transaction and its data. While these are generally available
1501  * via msg.sender and msg.data, they should not be accessed in such a direct
1502  * manner, since when dealing with meta-transactions the account sending and
1503  * paying for execution may not be the actual sender (as far as an application
1504  * is concerned).
1505  *
1506  * This contract is only required for intermediate, library-like contracts.
1507  */
1508 abstract contract Context {
1509     function _msgSender() internal view virtual returns (address) {
1510         return msg.sender;
1511     }
1512 
1513     function _msgData() internal view virtual returns (bytes calldata) {
1514         return msg.data;
1515     }
1516 }
1517 
1518 // File: @openzeppelin/contracts/access/Ownable.sol
1519 
1520 
1521 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1522 
1523 pragma solidity ^0.8.0;
1524 
1525 
1526 /**
1527  * @dev Contract module which provides a basic access control mechanism, where
1528  * there is an account (an owner) that can be granted exclusive access to
1529  * specific functions.
1530  *
1531  * By default, the owner account will be the one that deploys the contract. This
1532  * can later be changed with {transferOwnership}.
1533  *
1534  * This module is used through inheritance. It will make available the modifier
1535  * `onlyOwner`, which can be applied to your functions to restrict their use to
1536  * the owner.
1537  */
1538 abstract contract Ownable is Context {
1539     address private _owner;
1540 
1541     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1542 
1543     /**
1544      * @dev Initializes the contract setting the deployer as the initial owner.
1545      */
1546     constructor() {
1547         _transferOwnership(_msgSender());
1548     }
1549 
1550     /**
1551      * @dev Returns the address of the current owner.
1552      */
1553     function owner() public view virtual returns (address) {
1554         return _owner;
1555     }
1556 
1557     /**
1558      * @dev Throws if called by any account other than the owner.
1559      */
1560     modifier onlyOwner() {
1561         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1562         _;
1563     }
1564 
1565     /**
1566      * @dev Leaves the contract without owner. It will not be possible to call
1567      * `onlyOwner` functions anymore. Can only be called by the current owner.
1568      *
1569      * NOTE: Renouncing ownership will leave the contract without an owner,
1570      * thereby removing any functionality that is only available to the owner.
1571      */
1572     function renounceOwnership() public virtual onlyOwner {
1573         _transferOwnership(address(0));
1574     }
1575 
1576     /**
1577      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1578      * Can only be called by the current owner.
1579      */
1580     function transferOwnership(address newOwner) public virtual onlyOwner {
1581         require(newOwner != address(0), "Ownable: new owner is the zero address");
1582         _transferOwnership(newOwner);
1583     }
1584 
1585     /**
1586      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1587      * Internal function without access restriction.
1588      */
1589     function _transferOwnership(address newOwner) internal virtual {
1590         address oldOwner = _owner;
1591         _owner = newOwner;
1592         emit OwnershipTransferred(oldOwner, newOwner);
1593     }
1594 }
1595 
1596 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1597 
1598 
1599 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1600 
1601 pragma solidity ^0.8.0;
1602 
1603 /**
1604  * @dev Contract module that helps prevent reentrant calls to a function.
1605  *
1606  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1607  * available, which can be applied to functions to make sure there are no nested
1608  * (reentrant) calls to them.
1609  *
1610  * Note that because there is a single `nonReentrant` guard, functions marked as
1611  * `nonReentrant` may not call one another. This can be worked around by making
1612  * those functions `private`, and then adding `external` `nonReentrant` entry
1613  * points to them.
1614  *
1615  * TIP: If you would like to learn more about reentrancy and alternative ways
1616  * to protect against it, check out our blog post
1617  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1618  */
1619 abstract contract ReentrancyGuard {
1620     // Booleans are more expensive than uint256 or any type that takes up a full
1621     // word because each write operation emits an extra SLOAD to first read the
1622     // slot's contents, replace the bits taken up by the boolean, and then write
1623     // back. This is the compiler's defense against contract upgrades and
1624     // pointer aliasing, and it cannot be disabled.
1625 
1626     // The values being non-zero value makes deployment a bit more expensive,
1627     // but in exchange the refund on every call to nonReentrant will be lower in
1628     // amount. Since refunds are capped to a percentage of the total
1629     // transaction's gas, it is best to keep them low in cases like this one, to
1630     // increase the likelihood of the full refund coming into effect.
1631     uint256 private constant _NOT_ENTERED = 1;
1632     uint256 private constant _ENTERED = 2;
1633 
1634     uint256 private _status;
1635 
1636     constructor() {
1637         _status = _NOT_ENTERED;
1638     }
1639 
1640     /**
1641      * @dev Prevents a contract from calling itself, directly or indirectly.
1642      * Calling a `nonReentrant` function from another `nonReentrant`
1643      * function is not supported. It is possible to prevent this from happening
1644      * by making the `nonReentrant` function external, and making it call a
1645      * `private` function that does the actual work.
1646      */
1647     modifier nonReentrant() {
1648         // On the first call to nonReentrant, _notEntered will be true
1649         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1650 
1651         // Any calls to nonReentrant after this point will fail
1652         _status = _ENTERED;
1653 
1654         _;
1655 
1656         // By storing the original value once again, a refund is triggered (see
1657         // https://eips.ethereum.org/EIPS/eip-2200)
1658         _status = _NOT_ENTERED;
1659     }
1660 }
1661 
1662 // File: ogrevillage.sol
1663 
1664 
1665 
1666 /*
1667                                                                                                                  
1668 */
1669 
1670 
1671 
1672 
1673 
1674 
1675 
1676 
1677 pragma solidity >=0.8.13 <0.9.0;
1678 
1679 contract test is ERC721A, Ownable, ReentrancyGuard {
1680 
1681   using Strings for uint256;
1682 
1683 // ================== Variables Start =======================
1684     
1685   string public uri;
1686   string public uriSuffix = ".json";
1687   string public hiddenMetadataUri;
1688   uint256 public cost1 = 0 ether;
1689   uint256 public cost2 = 0.0069 ether;
1690   uint256 public supplyLimit = 2510;
1691   uint256 public maxMintAmountPerTx = 10;
1692   uint256 public maxLimitPerWallet = 20;
1693   bool public sale = false;
1694   bool public revealed = true;
1695 
1696 // ================== Variables End =======================  
1697 
1698 // ================== Constructor Start =======================
1699 
1700   constructor(
1701     string memory _uri
1702   ) ERC721A("ogrevillage.wtf", "OVW")  {
1703     seturi(_uri);
1704   }
1705 
1706 // ================== Constructor End =======================
1707 
1708 // ================== Mint Functions Start =======================
1709 
1710   function UpdateCost(uint256 _supply) internal view returns  (uint256 _cost) {
1711 
1712       if (_supply < 999) {
1713           return cost1;
1714         }
1715       if (_supply < supplyLimit){
1716           return cost2;
1717         }
1718   }
1719   
1720   function Mint(uint256 _mintAmount) public payable {
1721     //Dynamic Price
1722     uint256 supply = totalSupply();
1723     // Normal requirements 
1724     require(sale, 'The Sale is paused!');
1725     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1726     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
1727     require(balanceOf(msg.sender) + _mintAmount <= maxLimitPerWallet, 'Max mint per wallet exceeded!');
1728     require(msg.value >= UpdateCost(supply) * _mintAmount, 'Insufficient funds!');
1729      
1730     // Mint
1731      _safeMint(_msgSender(), _mintAmount);
1732   }  
1733 
1734   function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
1735     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
1736     _safeMint(_receiver, _mintAmount);
1737   }
1738 
1739 // ================== Mint Functions End =======================  
1740 
1741 // ================== Set Functions Start =======================
1742 
1743 // reveal
1744   function setRevealed(bool _state) public onlyOwner {
1745     revealed = _state;
1746   }
1747 
1748 // uri
1749   function seturi(string memory _uri) public onlyOwner {
1750     uri = _uri;
1751   }
1752 
1753   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1754     uriSuffix = _uriSuffix;
1755   }
1756 
1757   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1758     hiddenMetadataUri = _hiddenMetadataUri;
1759   }
1760 
1761 // sales toggle
1762   function setSaleStatus(bool _sale) public onlyOwner {
1763     sale = _sale;
1764   }
1765 
1766 // max per tx
1767   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1768     maxMintAmountPerTx = _maxMintAmountPerTx;
1769   }
1770 
1771 // pax per wallet
1772   function setmaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
1773     maxLimitPerWallet = _maxLimitPerWallet;
1774   }
1775 
1776 // price
1777 
1778   function setcost1(uint256 _cost1) public onlyOwner {
1779     cost1 = _cost1;
1780   }  
1781 
1782   function setcost2(uint256 _cost2) public onlyOwner {
1783     cost2 = _cost2;
1784   }  
1785 
1786 // supply limit
1787   function setsupplyLimit(uint256 _supplyLimit) public onlyOwner {
1788     supplyLimit = _supplyLimit;
1789   }
1790 
1791 // ================== Set Functions End =======================
1792 
1793 // ================== Withdraw Function Start =======================
1794   
1795   function withdraw() public onlyOwner nonReentrant {
1796         uint _balance = address(this).balance;
1797         payable(0x2861A7A392dc71e6186f89633C08E09eeAcc673D).transfer(_balance * 100 / 100);
1798          (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1799         require(os);
1800   }
1801 
1802 // ================== Withdraw Function End=======================  
1803 
1804 // ================== Read Functions Start =======================
1805  
1806   function price() public view returns (uint256){
1807          if (totalSupply() < 999) {
1808           return cost1;
1809           }
1810          if (totalSupply() < supplyLimit){
1811           return cost2;
1812         }
1813 
1814   }
1815 
1816 function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1817     unchecked {
1818         uint256[] memory a = new uint256[](balanceOf(owner)); 
1819         uint256 end = _nextTokenId();
1820         uint256 tokenIdsIdx;
1821         address currOwnershipAddr;
1822         for (uint256 i; i < end; i++) {
1823             TokenOwnership memory ownership = _ownershipAt(i);
1824             if (ownership.burned) {
1825                 continue;
1826             }
1827             if (ownership.addr != address(0)) {
1828                 currOwnershipAddr = ownership.addr;
1829             }
1830             if (currOwnershipAddr == owner) {
1831                 a[tokenIdsIdx++] = i;
1832             }
1833         }
1834         return a;    
1835     }
1836 }
1837 
1838   function _startTokenId() internal view virtual override returns (uint256) {
1839     return 1;
1840   }
1841 
1842   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1843     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1844 
1845     if (revealed == false) {
1846       return hiddenMetadataUri;
1847     }
1848 
1849     string memory currentBaseURI = _baseURI();
1850     return bytes(currentBaseURI).length > 0
1851         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1852         : '';
1853   }
1854 
1855   function _baseURI() internal view virtual override returns (string memory) {
1856     return uri;
1857   }
1858 
1859 // ================== Read Functions End =======================  
1860 
1861 }