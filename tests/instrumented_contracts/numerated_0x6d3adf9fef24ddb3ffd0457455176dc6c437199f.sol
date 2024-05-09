1 // SPDX-License-Identifier: MIT
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
1083 // File: @openzeppelin/contracts/utils/Strings.sol
1084 
1085 
1086 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1087 
1088 pragma solidity ^0.8.0;
1089 
1090 /**
1091  * @dev String operations.
1092  */
1093 library Strings {
1094     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
1151 }
1152 
1153 // File: @openzeppelin/contracts/utils/Context.sol
1154 
1155 
1156 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 /**
1161  * @dev Provides information about the current execution context, including the
1162  * sender of the transaction and its data. While these are generally available
1163  * via msg.sender and msg.data, they should not be accessed in such a direct
1164  * manner, since when dealing with meta-transactions the account sending and
1165  * paying for execution may not be the actual sender (as far as an application
1166  * is concerned).
1167  *
1168  * This contract is only required for intermediate, library-like contracts.
1169  */
1170 abstract contract Context {
1171     function _msgSender() internal view virtual returns (address) {
1172         return msg.sender;
1173     }
1174 
1175     function _msgData() internal view virtual returns (bytes calldata) {
1176         return msg.data;
1177     }
1178 }
1179 
1180 // File: @openzeppelin/contracts/access/Ownable.sol
1181 
1182 
1183 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 
1188 /**
1189  * @dev Contract module which provides a basic access control mechanism, where
1190  * there is an account (an owner) that can be granted exclusive access to
1191  * specific functions.
1192  *
1193  * By default, the owner account will be the one that deploys the contract. This
1194  * can later be changed with {transferOwnership}.
1195  *
1196  * This module is used through inheritance. It will make available the modifier
1197  * `onlyOwner`, which can be applied to your functions to restrict their use to
1198  * the owner.
1199  */
1200 abstract contract Ownable is Context {
1201     address private _owner;
1202 
1203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1204 
1205     /**
1206      * @dev Initializes the contract setting the deployer as the initial owner.
1207      */
1208     constructor() {
1209         _transferOwnership(_msgSender());
1210     }
1211 
1212     /**
1213      * @dev Returns the address of the current owner.
1214      */
1215     function owner() public view virtual returns (address) {
1216         return _owner;
1217     }
1218 
1219     /**
1220      * @dev Throws if called by any account other than the owner.
1221      */
1222     modifier onlyOwner() {
1223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1224         _;
1225     }
1226 
1227     /**
1228      * @dev Leaves the contract without owner. It will not be possible to call
1229      * `onlyOwner` functions anymore. Can only be called by the current owner.
1230      *
1231      * NOTE: Renouncing ownership will leave the contract without an owner,
1232      * thereby removing any functionality that is only available to the owner.
1233      */
1234     function renounceOwnership() public virtual onlyOwner {
1235         _transferOwnership(address(0));
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Can only be called by the current owner.
1241      */
1242     function transferOwnership(address newOwner) public virtual onlyOwner {
1243         require(newOwner != address(0), "Ownable: new owner is the zero address");
1244         _transferOwnership(newOwner);
1245     }
1246 
1247     /**
1248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1249      * Internal function without access restriction.
1250      */
1251     function _transferOwnership(address newOwner) internal virtual {
1252         address oldOwner = _owner;
1253         _owner = newOwner;
1254         emit OwnershipTransferred(oldOwner, newOwner);
1255     }
1256 }
1257 
1258 // File: contracts/ogreworld.sol
1259 
1260 
1261 pragma solidity >=0.8.0 <0.9.0;
1262 
1263 
1264 contract OgreWorld is ERC721A, Ownable {
1265     using Strings for uint256;
1266 
1267     enum ContractMintState {
1268         PAUSED,
1269         PUBLIC
1270     }
1271 
1272     ContractMintState public contractState = ContractMintState.PAUSED;
1273 
1274     string public uriPrefix = "";
1275     string public hiddenMetadataUri = "ipfs://QmQGKRwEJ5oq2C7d79xqEE17D16VAUWwYRhZAKhqos1tx3/hidden.json";
1276 
1277     uint256 public maxSupply = 5000;
1278     uint256 public maxMintAmountPerTx = 2;
1279     uint256 public maxMintAmount = 2;
1280 
1281     mapping(address => uint256) private _mintAllowance;
1282 
1283     constructor() ERC721A("Ogreworldwtf Official", "OGREWRLD") {}
1284 
1285     // OVERRIDES
1286     function _startTokenId() internal view virtual override returns (uint256) {
1287         return 1;
1288     }
1289 
1290     function _baseURI() internal view virtual override returns (string memory) {
1291         return uriPrefix;
1292     }
1293 
1294     modifier mintCompliance(uint256 _mintAmount) {
1295         require(
1296             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
1297             "Invalid mint amount"
1298         );
1299         require(
1300             totalSupply() + _mintAmount <= maxSupply,
1301             "Max supply exceeded"
1302         );
1303         _;
1304     }
1305 
1306     // MINTING FUNCTIONS
1307     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1308         require(contractState == ContractMintState.PUBLIC, "Public mint is disabled");
1309         require(_mintAllowance[msg.sender] + _mintAmount <= maxMintAmount);
1310 
1311         
1312         _safeMint(msg.sender, _mintAmount);
1313         _mintAllowance[msg.sender] = _mintAllowance[msg.sender] + _mintAmount;
1314         
1315     }
1316 
1317 
1318     function mintForAddress(uint256 _mintAmount, address _receiver)
1319         public
1320         onlyOwner
1321     {
1322         require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded");
1323         _safeMint(_receiver, _mintAmount);
1324     }
1325 
1326     function batchMint(uint256 _mintAmount, address[] memory _receiver)
1327         public
1328         onlyOwner
1329     {
1330         for (uint256 i = 0; i < _receiver.length; i++) {
1331             _safeMint(_receiver[i], _mintAmount);
1332         }
1333     }
1334 
1335     function numberMinted(address _minter) public view returns (uint256) {
1336         return _numberMinted(_minter);
1337     }
1338 
1339     function tokenURI(uint256 _tokenId)
1340         public
1341         view
1342         virtual
1343         override
1344         returns (string memory)
1345     {
1346         require(
1347             _exists(_tokenId),
1348             "ERC721Metadata: URI query for nonexistent token"
1349         );
1350 
1351         string memory currentBaseURI = _baseURI();
1352 
1353         return
1354             bytes(currentBaseURI).length > 0
1355                 ? string(
1356                     abi.encodePacked(
1357                         currentBaseURI,
1358                         _tokenId.toString(),
1359                         ".json"
1360                     )
1361                 )
1362                 : hiddenMetadataUri;
1363     }
1364 
1365     function walletOfOwner(address _owner)
1366         public
1367         view
1368         returns (uint256[] memory)
1369     {
1370         uint256 ownerTokenCount = balanceOf(_owner);
1371         uint256[] memory ownerTokens = new uint256[](ownerTokenCount);
1372         uint256 ownerTokenIdx = 0;
1373         for (
1374             uint256 tokenIdx = _startTokenId();
1375             tokenIdx <= totalSupply();
1376             tokenIdx++
1377         ) {
1378             if (ownerOf(tokenIdx) == _owner) {
1379                 ownerTokens[ownerTokenIdx] = tokenIdx;
1380                 ownerTokenIdx++;
1381             }
1382         }
1383         return ownerTokens;
1384     }
1385 
1386     function setState(ContractMintState _contractState) public onlyOwner {
1387         contractState = _contractState;
1388     }
1389 
1390     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
1391         public
1392         onlyOwner
1393     {
1394         maxMintAmountPerTx = _maxMintAmountPerTx;
1395     }
1396 
1397     function setMaxMintAmount(uint256 _maxMintAmount)
1398         public
1399         onlyOwner
1400     {
1401         maxMintAmount = _maxMintAmount;
1402     }
1403 
1404     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1405         require(_maxSupply < maxSupply, "Cannot increase the supply");
1406         maxSupply = _maxSupply;
1407     }
1408 
1409     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
1410         public
1411         onlyOwner
1412     {
1413         hiddenMetadataUri = _hiddenMetadataUri;
1414     }
1415 
1416     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1417         uriPrefix = _uriPrefix;
1418     }
1419 
1420     function remainingPublicMints(address userAddress) public view returns (uint256) { 
1421             return maxMintAmount - _mintAllowance[userAddress];
1422     }
1423 
1424 
1425     // WITHDRAW
1426     function withdraw() public onlyOwner {
1427 
1428         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1429         require(os);
1430     }
1431 }