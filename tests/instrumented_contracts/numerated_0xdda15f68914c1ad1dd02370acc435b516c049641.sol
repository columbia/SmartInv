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
967 
968         bytes memory _data
969     ) private returns (bool) {
970         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
971             bytes4 retval
972         ) {
973             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
974         } catch (bytes memory reason) {
975             if (reason.length == 0) {
976                 revert TransferToNonERC721ReceiverImplementer();
977             } else {
978                 assembly {
979                     revert(add(32, reason), mload(reason))
980                 }
981             }
982         }
983     }
984 
985     /**
986      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
987      * And also called before burning one token.
988      *
989      * startTokenId - the first token id to be transferred
990      * quantity - the amount to be transferred
991      *
992      * Calling conditions:
993      *
994      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
995      * transferred to `to`.
996      * - When `from` is zero, `tokenId` will be minted for `to`.
997      * - When `to` is zero, `tokenId` will be burned by `from`.
998      * - `from` and `to` are never both zero.
999      */
1000     function _beforeTokenTransfers(
1001         address from,
1002         address to,
1003         uint256 startTokenId,
1004         uint256 quantity
1005     ) internal virtual {}
1006 
1007     /**
1008      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1009      * minting.
1010      * And also called after one token has been burned.
1011      *
1012      * startTokenId - the first token id to be transferred
1013      * quantity - the amount to be transferred
1014      *
1015      * Calling conditions:
1016      *
1017      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1018      * transferred to `to`.
1019      * - When `from` is zero, `tokenId` has been minted for `to`.
1020      * - When `to` is zero, `tokenId` has been burned by `from`.
1021      * - `from` and `to` are never both zero.
1022      */
1023     function _afterTokenTransfers(
1024         address from,
1025         address to,
1026         uint256 startTokenId,
1027         uint256 quantity
1028     ) internal virtual {}
1029 
1030     /**
1031      * @dev Returns the message sender (defaults to `msg.sender`).
1032      *
1033      * If you are writing GSN compatible contracts, you need to override this function.
1034      */
1035     function _msgSenderERC721A() internal view virtual returns (address) {
1036         return msg.sender;
1037     }
1038 
1039     /**
1040      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1041      */
1042     function _toString(uint256 value) internal pure returns (string memory ptr) {
1043         assembly {
1044             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1045             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1046             // We will need 1 32-byte word to store the length, 
1047             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1048             ptr := add(mload(0x40), 128)
1049             // Update the free memory pointer to allocate.
1050             mstore(0x40, ptr)
1051 
1052             // Cache the end of the memory to calculate the length later.
1053             let end := ptr
1054 
1055             // We write the string from the rightmost digit to the leftmost digit.
1056             // The following is essentially a do-while loop that also handles the zero case.
1057             // Costs a bit more than early returning for the zero case,
1058             // but cheaper in terms of deployment and overall runtime costs.
1059             for { 
1060                 // Initialize and perform the first pass without check.
1061                 let temp := value
1062                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1063                 ptr := sub(ptr, 1)
1064                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1065                 mstore8(ptr, add(48, mod(temp, 10)))
1066                 temp := div(temp, 10)
1067             } temp { 
1068                 // Keep dividing `temp` until zero.
1069                 temp := div(temp, 10)
1070             } { // Body of the for loop.
1071                 ptr := sub(ptr, 1)
1072                 mstore8(ptr, add(48, mod(temp, 10)))
1073             }
1074             
1075             let length := sub(end, ptr)
1076             // Move the pointer 32 bytes leftwards to make room for the length.
1077             ptr := sub(ptr, 32)
1078             // Store the length.
1079             mstore(ptr, length)
1080         }
1081     }
1082 }
1083 
1084 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1085 
1086 
1087 // ERC721A Contracts v4.0.0
1088 // Creator: Chiru Labs
1089 
1090 pragma solidity ^0.8.4;
1091 
1092 
1093 /**
1094  * @dev Interface of an ERC721AQueryable compliant contract.
1095  */
1096 interface IERC721AQueryable is IERC721A {
1097     /**
1098      * Invalid query range (`start` >= `stop`).
1099      */
1100     error InvalidQueryRange();
1101 
1102     /**
1103      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1104      *
1105      * If the `tokenId` is out of bounds:
1106      *   - `addr` = `address(0)`
1107      *   - `startTimestamp` = `0`
1108      *   - `burned` = `false`
1109      *
1110      * If the `tokenId` is burned:
1111      *   - `addr` = `<Address of owner before token was burned>`
1112      *   - `startTimestamp` = `<Timestamp when token was burned>`
1113      *   - `burned = `true`
1114      *
1115      * Otherwise:
1116      *   - `addr` = `<Address of owner>`
1117      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1118      *   - `burned = `false`
1119      */
1120     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1121 
1122     /**
1123      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1124      * See {ERC721AQueryable-explicitOwnershipOf}
1125      */
1126     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1127 
1128     /**
1129      * @dev Returns an array of token IDs owned by `owner`,
1130      * in the range [`start`, `stop`)
1131      * (i.e. `start <= tokenId < stop`).
1132      *
1133      * This function allows for tokens to be queried if the collection
1134      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1135      *
1136      * Requirements:
1137      *
1138      * - `start` < `stop`
1139      */
1140     function tokensOfOwnerIn(
1141         address owner,
1142         uint256 start,
1143         uint256 stop
1144     ) external view returns (uint256[] memory);
1145 
1146     /**
1147      * @dev Returns an array of token IDs owned by `owner`.
1148      *
1149      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1150      * It is meant to be called off-chain.
1151      *
1152      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1153      * multiple smaller scans if the collection is large enough to cause
1154      * an out-of-gas error (10K pfp collections should be fine).
1155      */
1156     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1157 }
1158 
1159 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1160 
1161 
1162 // ERC721A Contracts v4.0.0
1163 // Creator: Chiru Labs
1164 
1165 pragma solidity ^0.8.4;
1166 
1167 
1168 
1169 /**
1170  * @title ERC721A Queryable
1171  * @dev ERC721A subclass with convenience query functions.
1172  */
1173 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1174     /**
1175      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1176      *
1177      * If the `tokenId` is out of bounds:
1178      *   - `addr` = `address(0)`
1179      *   - `startTimestamp` = `0`
1180      *   - `burned` = `false`
1181      *
1182      * If the `tokenId` is burned:
1183      *   - `addr` = `<Address of owner before token was burned>`
1184      *   - `startTimestamp` = `<Timestamp when token was burned>`
1185      *   - `burned = `true`
1186      *
1187      * Otherwise:
1188      *   - `addr` = `<Address of owner>`
1189      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1190      *   - `burned = `false`
1191      */
1192     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1193         TokenOwnership memory ownership;
1194         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1195             return ownership;
1196         }
1197         ownership = _ownershipAt(tokenId);
1198         if (ownership.burned) {
1199             return ownership;
1200         }
1201         return _ownershipOf(tokenId);
1202     }
1203 
1204     /**
1205      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1206      * See {ERC721AQueryable-explicitOwnershipOf}
1207      */
1208     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1209         unchecked {
1210             uint256 tokenIdsLength = tokenIds.length;
1211             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1212             for (uint256 i; i != tokenIdsLength; ++i) {
1213                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1214             }
1215             return ownerships;
1216         }
1217     }
1218 
1219     /**
1220      * @dev Returns an array of token IDs owned by `owner`,
1221      * in the range [`start`, `stop`)
1222      * (i.e. `start <= tokenId < stop`).
1223      *
1224      * This function allows for tokens to be queried if the collection
1225      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1226      *
1227      * Requirements:
1228      *
1229      * - `start` < `stop`
1230      */
1231     function tokensOfOwnerIn(
1232         address owner,
1233         uint256 start,
1234         uint256 stop
1235     ) external view override returns (uint256[] memory) {
1236         unchecked {
1237             if (start >= stop) revert InvalidQueryRange();
1238             uint256 tokenIdsIdx;
1239             uint256 stopLimit = _nextTokenId();
1240             // Set `start = max(start, _startTokenId())`.
1241             if (start < _startTokenId()) {
1242                 start = _startTokenId();
1243             }
1244             // Set `stop = min(stop, stopLimit)`.
1245             if (stop > stopLimit) {
1246                 stop = stopLimit;
1247             }
1248             uint256 tokenIdsMaxLength = balanceOf(owner);
1249             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1250             // to cater for cases where `balanceOf(owner)` is too big.
1251             if (start < stop) {
1252                 uint256 rangeLength = stop - start;
1253                 if (rangeLength < tokenIdsMaxLength) {
1254                     tokenIdsMaxLength = rangeLength;
1255                 }
1256             } else {
1257                 tokenIdsMaxLength = 0;
1258             }
1259             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1260             if (tokenIdsMaxLength == 0) {
1261                 return tokenIds;
1262             }
1263             // We need to call `explicitOwnershipOf(start)`,
1264             // because the slot at `start` may not be initialized.
1265             TokenOwnership memory ownership = explicitOwnershipOf(start);
1266             address currOwnershipAddr;
1267             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1268             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1269             if (!ownership.burned) {
1270                 currOwnershipAddr = ownership.addr;
1271             }
1272             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1273                 ownership = _ownershipAt(i);
1274                 if (ownership.burned) {
1275                     continue;
1276                 }
1277                 if (ownership.addr != address(0)) {
1278                     currOwnershipAddr = ownership.addr;
1279                 }
1280                 if (currOwnershipAddr == owner) {
1281                     tokenIds[tokenIdsIdx++] = i;
1282                 }
1283             }
1284             // Downsize the array to fit.
1285             assembly {
1286                 mstore(tokenIds, tokenIdsIdx)
1287             }
1288             return tokenIds;
1289         }
1290     }
1291 
1292     /**
1293      * @dev Returns an array of token IDs owned by `owner`.
1294      *
1295      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1296      * It is meant to be called off-chain.
1297      *
1298      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1299      * multiple smaller scans if the collection is large enough to cause
1300      * an out-of-gas error (10K pfp collections should be fine).
1301      */
1302     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1303         unchecked {
1304             uint256 tokenIdsIdx;
1305             address currOwnershipAddr;
1306             uint256 tokenIdsLength = balanceOf(owner);
1307             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1308             TokenOwnership memory ownership;
1309             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1310                 ownership = _ownershipAt(i);
1311                 if (ownership.burned) {
1312                     continue;
1313                 }
1314                 if (ownership.addr != address(0)) {
1315                     currOwnershipAddr = ownership.addr;
1316                 }
1317                 if (currOwnershipAddr == owner) {
1318                     tokenIds[tokenIdsIdx++] = i;
1319                 }
1320             }
1321             return tokenIds;
1322         }
1323     }
1324 }
1325 
1326 // File: @openzeppelin/contracts/utils/Strings.sol
1327 
1328 
1329 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1330 
1331 pragma solidity ^0.8.0;
1332 
1333 /**
1334  * @dev String operations.
1335  */
1336 library Strings {
1337     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1338 
1339     /**
1340      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1341      */
1342     function toString(uint256 value) internal pure returns (string memory) {
1343         // Inspired by OraclizeAPI's implementation - MIT licence
1344         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1345 
1346         if (value == 0) {
1347             return "0";
1348         }
1349         uint256 temp = value;
1350         uint256 digits;
1351         while (temp != 0) {
1352             digits++;
1353             temp /= 10;
1354         }
1355         bytes memory buffer = new bytes(digits);
1356         while (value != 0) {
1357             digits -= 1;
1358             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1359             value /= 10;
1360         }
1361         return string(buffer);
1362     }
1363 
1364     /**
1365      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1366      */
1367     function toHexString(uint256 value) internal pure returns (string memory) {
1368         if (value == 0) {
1369             return "0x00";
1370         }
1371         uint256 temp = value;
1372         uint256 length = 0;
1373         while (temp != 0) {
1374             length++;
1375             temp >>= 8;
1376         }
1377         return toHexString(value, length);
1378     }
1379 
1380     /**
1381      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1382      */
1383     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1384         bytes memory buffer = new bytes(2 * length + 2);
1385         buffer[0] = "0";
1386         buffer[1] = "x";
1387         for (uint256 i = 2 * length + 1; i > 1; --i) {
1388             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1389             value >>= 4;
1390         }
1391         require(value == 0, "Strings: hex length insufficient");
1392         return string(buffer);
1393     }
1394 }
1395 
1396 // File: @openzeppelin/contracts/utils/math/Math.sol
1397 
1398 
1399 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
1400 
1401 pragma solidity ^0.8.0;
1402 
1403 /**
1404  * @dev Standard math utilities missing in the Solidity language.
1405  */
1406 library Math {
1407     /**
1408      * @dev Returns the largest of two numbers.
1409      */
1410     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1411         return a >= b ? a : b;
1412     }
1413 
1414     /**
1415      * @dev Returns the smallest of two numbers.
1416      */
1417     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1418         return a < b ? a : b;
1419     }
1420 
1421     /**
1422      * @dev Returns the average of two numbers. The result is rounded towards
1423      * zero.
1424      */
1425     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1426         // (a + b) / 2 can overflow.
1427         return (a & b) + (a ^ b) / 2;
1428     }
1429 
1430     /**
1431      * @dev Returns the ceiling of the division of two numbers.
1432      *
1433      * This differs from standard division with `/` in that it rounds up instead
1434      * of rounding down.
1435      */
1436     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1437         // (a + b - 1) / b can overflow on addition, so we distribute.
1438         return a / b + (a % b == 0 ? 0 : 1);
1439     }
1440 }
1441 
1442 // File: @openzeppelin/contracts/utils/Arrays.sol
1443 
1444 
1445 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
1446 
1447 pragma solidity ^0.8.0;
1448 
1449 
1450 /**
1451  * @dev Collection of functions related to array types.
1452  */
1453 library Arrays {
1454     /**
1455      * @dev Searches a sorted `array` and returns the first index that contains
1456      * a value greater or equal to `element`. If no such index exists (i.e. all
1457      * values in the array are strictly less than `element`), the array length is
1458      * returned. Time complexity O(log n).
1459      *
1460      * `array` is expected to be sorted in ascending order, and to contain no
1461      * repeated elements.
1462      */
1463     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1464         if (array.length == 0) {
1465             return 0;
1466         }
1467 
1468         uint256 low = 0;
1469         uint256 high = array.length;
1470 
1471         while (low < high) {
1472             uint256 mid = Math.average(low, high);
1473 
1474             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1475             // because Math.average rounds down (it does integer division with truncation).
1476             if (array[mid] > element) {
1477                 high = mid;
1478             } else {
1479                 low = mid + 1;
1480             }
1481         }
1482 
1483         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1484         if (low > 0 && array[low - 1] == element) {
1485             return low - 1;
1486         } else {
1487             return low;
1488         }
1489     }
1490 }
1491 
1492 // File: @openzeppelin/contracts/utils/Context.sol
1493 
1494 
1495 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1496 
1497 pragma solidity ^0.8.0;
1498 
1499 /**
1500  * @dev Provides information about the current execution context, including the
1501  * sender of the transaction and its data. While these are generally available
1502  * via msg.sender and msg.data, they should not be accessed in such a direct
1503  * manner, since when dealing with meta-transactions the account sending and
1504  * paying for execution may not be the actual sender (as far as an application
1505  * is concerned).
1506  *
1507  * This contract is only required for intermediate, library-like contracts.
1508  */
1509 abstract contract Context {
1510     function _msgSender() internal view virtual returns (address) {
1511         return msg.sender;
1512     }
1513 
1514     function _msgData() internal view virtual returns (bytes calldata) {
1515         return msg.data;
1516     }
1517 }
1518 
1519 // File: @openzeppelin/contracts/access/Ownable.sol
1520 
1521 
1522 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1523 
1524 pragma solidity ^0.8.0;
1525 
1526 
1527 /**
1528  * @dev Contract module which provides a basic access control mechanism, where
1529  * there is an account (an owner) that can be granted exclusive access to
1530  * specific functions.
1531  *
1532  * By default, the owner account will be the one that deploys the contract. This
1533  * can later be changed with {transferOwnership}.
1534  *
1535  * This module is used through inheritance. It will make available the modifier
1536  * `onlyOwner`, which can be applied to your functions to restrict their use to
1537  * the owner.
1538  */
1539 abstract contract Ownable is Context {
1540     address private _owner;
1541 
1542     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1543 
1544     /**
1545      * @dev Initializes the contract setting the deployer as the initial owner.
1546      */
1547     constructor() {
1548         _transferOwnership(_msgSender());
1549     }
1550 
1551     /**
1552      * @dev Returns the address of the current owner.
1553      */
1554     function owner() public view virtual returns (address) {
1555         return _owner;
1556     }
1557 
1558     /**
1559      * @dev Throws if called by any account other than the owner.
1560      */
1561     modifier onlyOwner() {
1562         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1563         _;
1564     }
1565 
1566     /**
1567      * @dev Leaves the contract without owner. It will not be possible to call
1568      * `onlyOwner` functions anymore. Can only be called by the current owner.
1569      *
1570      * NOTE: Renouncing ownership will leave the contract without an owner,
1571      * thereby removing any functionality that is only available to the owner.
1572      */
1573     function renounceOwnership() public virtual onlyOwner {
1574         _transferOwnership(address(0));
1575     }
1576 
1577     /**
1578      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1579      * Can only be called by the current owner.
1580      */
1581     function transferOwnership(address newOwner) public virtual onlyOwner {
1582         require(newOwner != address(0), "Ownable: new owner is the zero address");
1583         _transferOwnership(newOwner);
1584     }
1585 
1586     /**
1587      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1588      * Internal function without access restriction.
1589      */
1590     function _transferOwnership(address newOwner) internal virtual {
1591         address oldOwner = _owner;
1592         _owner = newOwner;
1593         emit OwnershipTransferred(oldOwner, newOwner);
1594     }
1595 }
1596 
1597 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1598 
1599 
1600 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1601 
1602 pragma solidity ^0.8.0;
1603 
1604 /**
1605  * @dev Contract module that helps prevent reentrant calls to a function.
1606  *
1607  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1608  * available, which can be applied to functions to make sure there are no nested
1609  * (reentrant) calls to them.
1610  *
1611  * Note that because there is a single `nonReentrant` guard, functions marked as
1612  * `nonReentrant` may not call one another. This can be worked around by making
1613  * those functions `private`, and then adding `external` `nonReentrant` entry
1614  * points to them.
1615  *
1616  * TIP: If you would like to learn more about reentrancy and alternative ways
1617  * to protect against it, check out our blog post
1618  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1619  */
1620 abstract contract ReentrancyGuard {
1621     // Booleans are more expensive than uint256 or any type that takes up a full
1622     // word because each write operation emits an extra SLOAD to first read the
1623     // slot's contents, replace the bits taken up by the boolean, and then write
1624     // back. This is the compiler's defense against contract upgrades and
1625     // pointer aliasing, and it cannot be disabled.
1626 
1627     // The values being non-zero value makes deployment a bit more expensive,
1628     // but in exchange the refund on every call to nonReentrant will be lower in
1629     // amount. Since refunds are capped to a percentage of the total
1630     // transaction's gas, it is best to keep them low in cases like this one, to
1631     // increase the likelihood of the full refund coming into effect.
1632     uint256 private constant _NOT_ENTERED = 1;
1633     uint256 private constant _ENTERED = 2;
1634 
1635     uint256 private _status;
1636 
1637     constructor() {
1638         _status = _NOT_ENTERED;
1639     }
1640 
1641     /**
1642      * @dev Prevents a contract from calling itself, directly or indirectly.
1643      * Calling a `nonReentrant` function from another `nonReentrant`
1644      * function is not supported. It is possible to prevent this from happening
1645      * by making the `nonReentrant` function external, and making it call a
1646      * `private` function that does the actual work.
1647      */
1648     modifier nonReentrant() {
1649         // On the first call to nonReentrant, _notEntered will be true
1650         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1651 
1652         // Any calls to nonReentrant after this point will fail
1653         _status = _ENTERED;
1654 
1655         _;
1656 
1657         // By storing the original value once again, a refund is triggered (see
1658         // https://eips.ethereum.org/EIPS/eip-2200)
1659         _status = _NOT_ENTERED;
1660     }
1661 }
1662 
1663 // File: contracts/wulftown.sol
1664 
1665 
1666 
1667 
1668 
1669 
1670 
1671 
1672 
1673 
1674 pragma solidity >=0.8.13 <0.9.0;
1675 
1676 contract wulftownwtf is ERC721A, Ownable, ReentrancyGuard {
1677 
1678   using Strings for uint256;
1679 
1680 // ================== Variables Start =======================
1681     
1682   string public uri;
1683   string public uriSuffix = ".json";
1684   uint256 public cost1 = 0 ether;
1685   uint256 public cost2 = 0.003 ether;
1686   uint256 public supplyLimit = 3333;
1687   uint256 public maxMintAmountPerTxPhase1 = 2;
1688   uint256 public maxMintAmountPerTxPhase2 = 18;
1689   uint256 public maxLimitPerWallet = 20;
1690   bool public sale = false;
1691   bool public revealed = true;
1692 
1693 // ================== Variables End =======================  
1694 
1695 // ================== Constructor Start =======================
1696 
1697   constructor(
1698     string memory _uri
1699   ) ERC721A("wulftown.wtf", "WFT")  {
1700     seturi(_uri);
1701   }
1702 
1703 // ================== Constructor End =======================
1704 
1705 // ================== Mint Functions Start =======================
1706 
1707   function UpdateCost(uint256 _supply, uint256 _mintAmount) internal view returns  (uint256 _cost) {
1708 
1709     if (balanceOf(msg.sender) + _mintAmount <= 2 && _supply <1000) {
1710         return cost1;
1711     }
1712     if (balanceOf(msg.sender) + _mintAmount <= 10 && _supply < supplyLimit){
1713         return cost2;
1714     }
1715   }
1716   
1717   function Mint(uint256 _mintAmount) public payable {
1718     //Dynamic Price
1719     uint256 supply = totalSupply();
1720     // Normal requirements 
1721     require(sale, 'The Sale is paused!');
1722     require(_mintAmount > 0 && _mintAmount <= 10, 'Invalid mint amount!');
1723     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
1724     require(balanceOf(msg.sender) + _mintAmount <= maxLimitPerWallet, 'Max mint per wallet exceeded!');
1725     require(msg.value >= UpdateCost(supply, _mintAmount) * _mintAmount, 'Insufficient funds!');
1726      
1727     // Mint
1728      _safeMint(_msgSender(), _mintAmount);
1729   }  
1730 
1731   function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
1732     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
1733     _safeMint(_receiver, _mintAmount);
1734   }
1735 
1736 // ================== Mint Functions End =======================  
1737 
1738 // ================== Set Functions Start =======================
1739 
1740 // reveal
1741   function setRevealed(bool _state) public onlyOwner {
1742     revealed = _state;
1743   }
1744 
1745 // uri
1746   function seturi(string memory _uri) public onlyOwner {
1747     uri = _uri;
1748   }
1749 
1750   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1751     uriSuffix = _uriSuffix;
1752   }
1753 
1754 // sales toggle
1755   function setSaleStatus(bool _sale) public onlyOwner {
1756     sale = _sale;
1757   }
1758 
1759 // max per tx Phase1
1760   function setMaxMintAmountPerTxPhase1(uint256 _maxMintAmountPerTxPhase1) public onlyOwner {
1761     maxMintAmountPerTxPhase1 = _maxMintAmountPerTxPhase1;
1762   }
1763 
1764   // max per tx Phase2
1765   function setMaxMintAmountPerTxPhase2(uint256 _maxMintAmountPerTxPhase2) public onlyOwner {
1766     maxMintAmountPerTxPhase2 = _maxMintAmountPerTxPhase2;
1767   }
1768 
1769 // max per wallet
1770   function setmaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
1771     maxLimitPerWallet = _maxLimitPerWallet;
1772   }
1773 
1774 // price
1775 
1776   function setcost1(uint256 _cost1) public onlyOwner {
1777     cost1 = _cost1;
1778   }  
1779 
1780   function setcost2(uint256 _cost2) public onlyOwner {
1781     cost2 = _cost2;
1782   }  
1783 
1784 // supply limit
1785   function setsupplyLimit(uint256 _supplyLimit) public onlyOwner {
1786     supplyLimit = _supplyLimit;
1787   }
1788 
1789 // ================== Set Functions End =======================
1790 
1791 // ================== Withdraw Function Start =======================
1792   
1793   function withdraw() public onlyOwner nonReentrant {
1794         uint _balance = address(this).balance;
1795         payable(0x3c8AED7aF5004dB3Cf1594e54DC598f678fb7E0a).transfer(_balance);
1796          (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1797         require(os);
1798   }
1799 // ================== Withdraw Function End=======================  
1800 
1801 // ================== Read Functions Start =======================
1802  
1803   function price(uint256 _mintAmount) public view returns (uint256){
1804          if (balanceOf(msg.sender) + _mintAmount <= 2 && totalSupply() <1000) {
1805           return cost1;
1806           }
1807          if (balanceOf(msg.sender) + _mintAmount <= 10 && totalSupply() < supplyLimit){
1808           return cost2;
1809         }
1810   }
1811 
1812 function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1813     unchecked {
1814         uint256[] memory a = new uint256[](balanceOf(owner)); 
1815         uint256 end = _nextTokenId();
1816         uint256 tokenIdsIdx;
1817         address currOwnershipAddr;
1818         for (uint256 i; i < end; i++) {
1819             TokenOwnership memory ownership = _ownershipAt(i);
1820             if (ownership.burned) {
1821                 continue;
1822             }
1823             if (ownership.addr != address(0)) {
1824                 currOwnershipAddr = ownership.addr;
1825             }
1826             if (currOwnershipAddr == owner) {
1827                 a[tokenIdsIdx++] = i;
1828             }
1829         }
1830         return a;    
1831     }
1832 }
1833 
1834   function _startTokenId() internal view virtual override returns (uint256) {
1835     return 1;
1836   }
1837 
1838   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1839     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1840 
1841     //if (revealed == false) {
1842     //  return hiddenMetadataUri;
1843     //}
1844 
1845     string memory currentBaseURI = _baseURI();
1846     return bytes(currentBaseURI).length > 0
1847         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1848         : '';
1849   }
1850 
1851   function _baseURI() internal view virtual override returns (string memory) {
1852     return uri;
1853   }
1854 
1855 // ================== Read Functions End =======================  
1856 
1857 }