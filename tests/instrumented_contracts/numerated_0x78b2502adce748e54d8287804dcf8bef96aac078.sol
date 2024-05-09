1 // File: GPU.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-06-30
5 */
6 
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
265 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
266 
267 
268 // ERC721A Contracts v3.3.0
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
1083 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
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
1095     uint8 private constant _ADDRESS_LENGTH = 20;
1096 
1097     /**
1098      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1099      */
1100     function toString(uint256 value) internal pure returns (string memory) {
1101         // Inspired by OraclizeAPI's implementation - MIT licence
1102         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1103 
1104         if (value == 0) {
1105             return "0";
1106         }
1107         uint256 temp = value;
1108         uint256 digits;
1109         while (temp != 0) {
1110             digits++;
1111             temp /= 10;
1112         }
1113         bytes memory buffer = new bytes(digits);
1114         while (value != 0) {
1115             digits -= 1;
1116             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1117             value /= 10;
1118         }
1119         return string(buffer);
1120     }
1121 
1122     /**
1123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1124      */
1125     function toHexString(uint256 value) internal pure returns (string memory) {
1126         if (value == 0) {
1127             return "0x00";
1128         }
1129         uint256 temp = value;
1130         uint256 length = 0;
1131         while (temp != 0) {
1132             length++;
1133             temp >>= 8;
1134         }
1135         return toHexString(value, length);
1136     }
1137 
1138     /**
1139      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1140      */
1141     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1142         bytes memory buffer = new bytes(2 * length + 2);
1143         buffer[0] = "0";
1144         buffer[1] = "x";
1145         for (uint256 i = 2 * length + 1; i > 1; --i) {
1146             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1147             value >>= 4;
1148         }
1149         require(value == 0, "Strings: hex length insufficient");
1150         return string(buffer);
1151     }
1152 
1153     /**
1154      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1155      */
1156     function toHexString(address addr) internal pure returns (string memory) {
1157         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1158     }
1159 }
1160 
1161 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1162 
1163 
1164 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1165 
1166 pragma solidity ^0.8.0;
1167 
1168 /**
1169  * @dev Provides information about the current execution context, including the
1170  * sender of the transaction and its data. While these are generally available
1171  * via msg.sender and msg.data, they should not be accessed in such a direct
1172  * manner, since when dealing with meta-transactions the account sending and
1173  * paying for execution may not be the actual sender (as far as an application
1174  * is concerned).
1175  *
1176  * This contract is only required for intermediate, library-like contracts.
1177  */
1178 abstract contract Context {
1179     function _msgSender() internal view virtual returns (address) {
1180         return msg.sender;
1181     }
1182 
1183     function _msgData() internal view virtual returns (bytes calldata) {
1184         return msg.data;
1185     }
1186 }
1187 
1188 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1189 
1190 
1191 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1192 
1193 pragma solidity ^0.8.0;
1194 
1195 
1196 /**
1197  * @dev Contract module which provides a basic access control mechanism, where
1198  * there is an account (an owner) that can be granted exclusive access to
1199  * specific functions.
1200  *
1201  * By default, the owner account will be the one that deploys the contract. This
1202  * can later be changed with {transferOwnership}.
1203  *
1204  * This module is used through inheritance. It will make available the modifier
1205  * `onlyOwner`, which can be applied to your functions to restrict their use to
1206  * the owner.
1207  */
1208 abstract contract Ownable is Context {
1209     address private _owner;
1210 
1211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1212 
1213     /**
1214      * @dev Initializes the contract setting the deployer as the initial owner.
1215      */
1216     constructor() {
1217         _transferOwnership(_msgSender());
1218     }
1219 
1220     /**
1221      * @dev Returns the address of the current owner.
1222      */
1223     function owner() public view virtual returns (address) {
1224         return _owner;
1225     }
1226 
1227     /**
1228      * @dev Throws if called by any account other than the owner.
1229      */
1230     modifier onlyOwner() {
1231         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1232         _;
1233     }
1234 
1235     /**
1236      * @dev Leaves the contract without owner. It will not be possible to call
1237      * `onlyOwner` functions anymore. Can only be called by the current owner.
1238      *
1239      * NOTE: Renouncing ownership will leave the contract without an owner,
1240      * thereby removing any functionality that is only available to the owner.
1241      */
1242     function renounceOwnership() public virtual onlyOwner {
1243         _transferOwnership(address(0));
1244     }
1245 
1246     /**
1247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1248      * Can only be called by the current owner.
1249      */
1250     function transferOwnership(address newOwner) public virtual onlyOwner {
1251         require(newOwner != address(0), "Ownable: new owner is the zero address");
1252         _transferOwnership(newOwner);
1253     }
1254 
1255     /**
1256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1257      * Internal function without access restriction.
1258      */
1259     function _transferOwnership(address newOwner) internal virtual {
1260         address oldOwner = _owner;
1261         _owner = newOwner;
1262         emit OwnershipTransferred(oldOwner, newOwner);
1263     }
1264 }
1265 
1266 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1267 
1268 
1269 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1270 
1271 pragma solidity ^0.8.1;
1272 
1273 /**
1274  * @dev Collection of functions related to the address type
1275  */
1276 library Address {
1277     /**
1278      * @dev Returns true if `account` is a contract.
1279      *
1280      * [IMPORTANT]
1281      * ====
1282      * It is unsafe to assume that an address for which this function returns
1283      * false is an externally-owned account (EOA) and not a contract.
1284      *
1285      * Among others, `isContract` will return false for the following
1286      * types of addresses:
1287      *
1288      *  - an externally-owned account
1289      *  - a contract in construction
1290      *  - an address where a contract will be created
1291      *  - an address where a contract lived, but was destroyed
1292      * ====
1293      *
1294      * [IMPORTANT]
1295      * ====
1296      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1297      *
1298      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1299      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1300      * constructor.
1301      * ====
1302      */
1303     function isContract(address account) internal view returns (bool) {
1304         // This method relies on extcodesize/address.code.length, which returns 0
1305         // for contracts in construction, since the code is only stored at the end
1306         // of the constructor execution.
1307 
1308         return account.code.length > 0;
1309     }
1310 
1311     /**
1312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1313      * `recipient`, forwarding all available gas and reverting on errors.
1314      *
1315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1317      * imposed by `transfer`, making them unable to receive funds via
1318      * `transfer`. {sendValue} removes this limitation.
1319      *
1320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1321      *
1322      * IMPORTANT: because control is transferred to `recipient`, care must be
1323      * taken to not create reentrancy vulnerabilities. Consider using
1324      * {ReentrancyGuard} or the
1325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1326      */
1327     function sendValue(address payable recipient, uint256 amount) internal {
1328         require(address(this).balance >= amount, "Address: insufficient balance");
1329 
1330         (bool success, ) = recipient.call{value: amount}("");
1331         require(success, "Address: unable to send value, recipient may have reverted");
1332     }
1333 
1334     /**
1335      * @dev Performs a Solidity function call using a low level `call`. A
1336      * plain `call` is an unsafe replacement for a function call: use this
1337      * function instead.
1338      *
1339      * If `target` reverts with a revert reason, it is bubbled up by this
1340      * function (like regular Solidity function calls).
1341      *
1342      * Returns the raw returned data. To convert to the expected return value,
1343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1344      *
1345      * Requirements:
1346      *
1347      * - `target` must be a contract.
1348      * - calling `target` with `data` must not revert.
1349      *
1350      * _Available since v3.1._
1351      */
1352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1353         return functionCall(target, data, "Address: low-level call failed");
1354     }
1355 
1356     /**
1357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1358      * `errorMessage` as a fallback revert reason when `target` reverts.
1359      *
1360      * _Available since v3.1._
1361      */
1362     function functionCall(
1363         address target,
1364         bytes memory data,
1365         string memory errorMessage
1366     ) internal returns (bytes memory) {
1367         return functionCallWithValue(target, data, 0, errorMessage);
1368     }
1369 
1370     /**
1371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1372      * but also transferring `value` wei to `target`.
1373      *
1374      * Requirements:
1375      *
1376      * - the calling contract must have an ETH balance of at least `value`.
1377      * - the called Solidity function must be `payable`.
1378      *
1379      * _Available since v3.1._
1380      */
1381     function functionCallWithValue(
1382         address target,
1383         bytes memory data,
1384         uint256 value
1385     ) internal returns (bytes memory) {
1386         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1387     }
1388 
1389     /**
1390      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1391      * with `errorMessage` as a fallback revert reason when `target` reverts.
1392      *
1393      * _Available since v3.1._
1394      */
1395     function functionCallWithValue(
1396         address target,
1397         bytes memory data,
1398         uint256 value,
1399         string memory errorMessage
1400     ) internal returns (bytes memory) {
1401         require(address(this).balance >= value, "Address: insufficient balance for call");
1402         require(isContract(target), "Address: call to non-contract");
1403 
1404         (bool success, bytes memory returndata) = target.call{value: value}(data);
1405         return verifyCallResult(success, returndata, errorMessage);
1406     }
1407 
1408     /**
1409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1410      * but performing a static call.
1411      *
1412      * _Available since v3.3._
1413      */
1414     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1415         return functionStaticCall(target, data, "Address: low-level static call failed");
1416     }
1417 
1418     /**
1419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1420      * but performing a static call.
1421      *
1422      * _Available since v3.3._
1423      */
1424     function functionStaticCall(
1425         address target,
1426         bytes memory data,
1427         string memory errorMessage
1428     ) internal view returns (bytes memory) {
1429         require(isContract(target), "Address: static call to non-contract");
1430 
1431         (bool success, bytes memory returndata) = target.staticcall(data);
1432         return verifyCallResult(success, returndata, errorMessage);
1433     }
1434 
1435     /**
1436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1437      * but performing a delegate call.
1438      *
1439      * _Available since v3.4._
1440      */
1441     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1442         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1443     }
1444 
1445     /**
1446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1447      * but performing a delegate call.
1448      *
1449      * _Available since v3.4._
1450      */
1451     function functionDelegateCall(
1452         address target,
1453         bytes memory data,
1454         string memory errorMessage
1455     ) internal returns (bytes memory) {
1456         require(isContract(target), "Address: delegate call to non-contract");
1457 
1458         (bool success, bytes memory returndata) = target.delegatecall(data);
1459         return verifyCallResult(success, returndata, errorMessage);
1460     }
1461 
1462     /**
1463      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1464      * revert reason using the provided one.
1465      *
1466      * _Available since v4.3._
1467      */
1468     function verifyCallResult(
1469         bool success,
1470         bytes memory returndata,
1471         string memory errorMessage
1472     ) internal pure returns (bytes memory) {
1473         if (success) {
1474             return returndata;
1475         } else {
1476             // Look for revert reason and bubble it up if present
1477             if (returndata.length > 0) {
1478                 // The easiest way to bubble the revert reason is using memory via assembly
1479 
1480                 assembly {
1481                     let returndata_size := mload(returndata)
1482                     revert(add(32, returndata), returndata_size)
1483                 }
1484             } else {
1485                 revert(errorMessage);
1486             }
1487         }
1488     }
1489 }
1490 
1491 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1492 
1493 
1494 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1495 
1496 pragma solidity ^0.8.0;
1497 
1498 /**
1499  * @title ERC721 token receiver interface
1500  * @dev Interface for any contract that wants to support safeTransfers
1501  * from ERC721 asset contracts.
1502  */
1503 interface IERC721Receiver {
1504     /**
1505      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1506      * by `operator` from `from`, this function is called.
1507      *
1508      * It must return its Solidity selector to confirm the token transfer.
1509      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1510      *
1511      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1512      */
1513     function onERC721Received(
1514         address operator,
1515         address from,
1516         uint256 tokenId,
1517         bytes calldata data
1518     ) external returns (bytes4);
1519 }
1520 
1521 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1522 
1523 
1524 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1525 
1526 pragma solidity ^0.8.0;
1527 
1528 /**
1529  * @dev Interface of the ERC165 standard, as defined in the
1530  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1531  *
1532  * Implementers can declare support of contract interfaces, which can then be
1533  * queried by others ({ERC165Checker}).
1534  *
1535  * For an implementation, see {ERC165}.
1536  */
1537 interface IERC165 {
1538     /**
1539      * @dev Returns true if this contract implements the interface defined by
1540      * `interfaceId`. See the corresponding
1541      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1542      * to learn more about how these ids are created.
1543      *
1544      * This function call must use less than 30 000 gas.
1545      */
1546     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1547 }
1548 
1549 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1550 
1551 
1552 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1553 
1554 pragma solidity ^0.8.0;
1555 
1556 
1557 /**
1558  * @dev Implementation of the {IERC165} interface.
1559  *
1560  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1561  * for the additional interface id that will be supported. For example:
1562  *
1563  * ```solidity
1564  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1565  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1566  * }
1567  * ```
1568  *
1569  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1570  */
1571 abstract contract ERC165 is IERC165 {
1572     /**
1573      * @dev See {IERC165-supportsInterface}.
1574      */
1575     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1576         return interfaceId == type(IERC165).interfaceId;
1577     }
1578 }
1579 
1580 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1581 
1582 
1583 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1584 
1585 pragma solidity ^0.8.0;
1586 
1587 
1588 /**
1589  * @dev Required interface of an ERC721 compliant contract.
1590  */
1591 interface IERC721 is IERC165 {
1592     /**
1593      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1594      */
1595     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1596 
1597     /**
1598      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1599      */
1600     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1601 
1602     /**
1603      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1604      */
1605     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1606 
1607     /**
1608      * @dev Returns the number of tokens in ``owner``'s account.
1609      */
1610     function balanceOf(address owner) external view returns (uint256 balance);
1611 
1612     /**
1613      * @dev Returns the owner of the `tokenId` token.
1614      *
1615      * Requirements:
1616      *
1617      * - `tokenId` must exist.
1618      */
1619     function ownerOf(uint256 tokenId) external view returns (address owner);
1620 
1621     /**
1622      * @dev Safely transfers `tokenId` token from `from` to `to`.
1623      *
1624      * Requirements:
1625      *
1626      * - `from` cannot be the zero address.
1627      * - `to` cannot be the zero address.
1628      * - `tokenId` token must exist and be owned by `from`.
1629      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1631      *
1632      * Emits a {Transfer} event.
1633      */
1634     function safeTransferFrom(
1635         address from,
1636         address to,
1637         uint256 tokenId,
1638         bytes calldata data
1639     ) external;
1640 
1641     /**
1642      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1643      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1644      *
1645      * Requirements:
1646      *
1647      * - `from` cannot be the zero address.
1648      * - `to` cannot be the zero address.
1649      * - `tokenId` token must exist and be owned by `from`.
1650      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1651      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1652      *
1653      * Emits a {Transfer} event.
1654      */
1655     function safeTransferFrom(
1656         address from,
1657         address to,
1658         uint256 tokenId
1659     ) external;
1660 
1661     /**
1662      * @dev Transfers `tokenId` token from `from` to `to`.
1663      *
1664      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1665      *
1666      * Requirements:
1667      *
1668      * - `from` cannot be the zero address.
1669      * - `to` cannot be the zero address.
1670      * - `tokenId` token must be owned by `from`.
1671      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function transferFrom(
1676         address from,
1677         address to,
1678         uint256 tokenId
1679     ) external;
1680 
1681     /**
1682      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1683      * The approval is cleared when the token is transferred.
1684      *
1685      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1686      *
1687      * Requirements:
1688      *
1689      * - The caller must own the token or be an approved operator.
1690      * - `tokenId` must exist.
1691      *
1692      * Emits an {Approval} event.
1693      */
1694     function approve(address to, uint256 tokenId) external;
1695 
1696     /**
1697      * @dev Approve or remove `operator` as an operator for the caller.
1698      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1699      *
1700      * Requirements:
1701      *
1702      * - The `operator` cannot be the caller.
1703      *
1704      * Emits an {ApprovalForAll} event.
1705      */
1706     function setApprovalForAll(address operator, bool _approved) external;
1707 
1708     /**
1709      * @dev Returns the account approved for `tokenId` token.
1710      *
1711      * Requirements:
1712      *
1713      * - `tokenId` must exist.
1714      */
1715     function getApproved(uint256 tokenId) external view returns (address operator);
1716 
1717     /**
1718      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1719      *
1720      * See {setApprovalForAll}
1721      */
1722     function isApprovedForAll(address owner, address operator) external view returns (bool);
1723 }
1724 
1725 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1726 
1727 
1728 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1729 
1730 pragma solidity ^0.8.0;
1731 
1732 
1733 /**
1734  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1735  * @dev See https://eips.ethereum.org/EIPS/eip-721
1736  */
1737 interface IERC721Metadata is IERC721 {
1738     /**
1739      * @dev Returns the token collection name.
1740      */
1741     function name() external view returns (string memory);
1742 
1743     /**
1744      * @dev Returns the token collection symbol.
1745      */
1746     function symbol() external view returns (string memory);
1747 
1748     /**
1749      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1750      */
1751     function tokenURI(uint256 tokenId) external view returns (string memory);
1752 }
1753 
1754 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1755 
1756 
1757 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1758 
1759 pragma solidity ^0.8.0;
1760 
1761 
1762 
1763 
1764 
1765 
1766 
1767 
1768 /**
1769  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1770  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1771  * {ERC721Enumerable}.
1772  */
1773 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1774     using Address for address;
1775     using Strings for uint256;
1776 
1777     // Token name
1778     string private _name;
1779 
1780     // Token symbol
1781     string private _symbol;
1782 
1783     // Mapping from token ID to owner address
1784     mapping(uint256 => address) private _owners;
1785 
1786     // Mapping owner address to token count
1787     mapping(address => uint256) private _balances;
1788 
1789     // Mapping from token ID to approved address
1790     mapping(uint256 => address) private _tokenApprovals;
1791 
1792     // Mapping from owner to operator approvals
1793     mapping(address => mapping(address => bool)) private _operatorApprovals;
1794 
1795     /**
1796      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1797      */
1798     constructor(string memory name_, string memory symbol_) {
1799         _name = name_;
1800         _symbol = symbol_;
1801     }
1802 
1803     /**
1804      * @dev See {IERC165-supportsInterface}.
1805      */
1806     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1807         return
1808             interfaceId == type(IERC721).interfaceId ||
1809             interfaceId == type(IERC721Metadata).interfaceId ||
1810             super.supportsInterface(interfaceId);
1811     }
1812 
1813     /**
1814      * @dev See {IERC721-balanceOf}.
1815      */
1816     function balanceOf(address owner) public view virtual override returns (uint256) {
1817         require(owner != address(0), "ERC721: address zero is not a valid owner");
1818         return _balances[owner];
1819     }
1820 
1821     /**
1822      * @dev See {IERC721-ownerOf}.
1823      */
1824     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1825         address owner = _owners[tokenId];
1826         require(owner != address(0), "ERC721: owner query for nonexistent token");
1827         return owner;
1828     }
1829 
1830     /**
1831      * @dev See {IERC721Metadata-name}.
1832      */
1833     function name() public view virtual override returns (string memory) {
1834         return _name;
1835     }
1836 
1837     /**
1838      * @dev See {IERC721Metadata-symbol}.
1839      */
1840     function symbol() public view virtual override returns (string memory) {
1841         return _symbol;
1842     }
1843 
1844     /**
1845      * @dev See {IERC721Metadata-tokenURI}.
1846      */
1847     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1848         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1849 
1850         string memory baseURI = _baseURI();
1851         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1852     }
1853 
1854     /**
1855      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1856      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1857      * by default, can be overridden in child contracts.
1858      */
1859     function _baseURI() internal view virtual returns (string memory) {
1860         return "";
1861     }
1862 
1863     /**
1864      * @dev See {IERC721-approve}.
1865      */
1866     function approve(address to, uint256 tokenId) public virtual override {
1867         address owner = ERC721.ownerOf(tokenId);
1868         require(to != owner, "ERC721: approval to current owner");
1869 
1870         require(
1871             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1872             "ERC721: approve caller is not owner nor approved for all"
1873         );
1874 
1875         _approve(to, tokenId);
1876     }
1877 
1878     /**
1879      * @dev See {IERC721-getApproved}.
1880      */
1881     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1882         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1883 
1884         return _tokenApprovals[tokenId];
1885     }
1886 
1887     /**
1888      * @dev See {IERC721-setApprovalForAll}.
1889      */
1890     function setApprovalForAll(address operator, bool approved) public virtual override {
1891         _setApprovalForAll(_msgSender(), operator, approved);
1892     }
1893 
1894     /**
1895      * @dev See {IERC721-isApprovedForAll}.
1896      */
1897     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1898         return _operatorApprovals[owner][operator];
1899     }
1900 
1901     /**
1902      * @dev See {IERC721-transferFrom}.
1903      */
1904     function transferFrom(
1905         address from,
1906         address to,
1907         uint256 tokenId
1908     ) public virtual override {
1909         //solhint-disable-next-line max-line-length
1910         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1911 
1912         _transfer(from, to, tokenId);
1913     }
1914 
1915     /**
1916      * @dev See {IERC721-safeTransferFrom}.
1917      */
1918     function safeTransferFrom(
1919         address from,
1920         address to,
1921         uint256 tokenId
1922     ) public virtual override {
1923         safeTransferFrom(from, to, tokenId, "");
1924     }
1925 
1926     /**
1927      * @dev See {IERC721-safeTransferFrom}.
1928      */
1929     function safeTransferFrom(
1930         address from,
1931         address to,
1932         uint256 tokenId,
1933         bytes memory data
1934     ) public virtual override {
1935         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1936         _safeTransfer(from, to, tokenId, data);
1937     }
1938 
1939     /**
1940      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1941      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1942      *
1943      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1944      *
1945      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1946      * implement alternative mechanisms to perform token transfer, such as signature-based.
1947      *
1948      * Requirements:
1949      *
1950      * - `from` cannot be the zero address.
1951      * - `to` cannot be the zero address.
1952      * - `tokenId` token must exist and be owned by `from`.
1953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1954      *
1955      * Emits a {Transfer} event.
1956      */
1957     function _safeTransfer(
1958         address from,
1959         address to,
1960         uint256 tokenId,
1961         bytes memory data
1962     ) internal virtual {
1963         _transfer(from, to, tokenId);
1964         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1965     }
1966 
1967     /**
1968      * @dev Returns whether `tokenId` exists.
1969      *
1970      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1971      *
1972      * Tokens start existing when they are minted (`_mint`),
1973      * and stop existing when they are burned (`_burn`).
1974      */
1975     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1976         return _owners[tokenId] != address(0);
1977     }
1978 
1979     /**
1980      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1981      *
1982      * Requirements:
1983      *
1984      * - `tokenId` must exist.
1985      */
1986     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1987         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1988         address owner = ERC721.ownerOf(tokenId);
1989         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1990     }
1991 
1992     /**
1993      * @dev Safely mints `tokenId` and transfers it to `to`.
1994      *
1995      * Requirements:
1996      *
1997      * - `tokenId` must not exist.
1998      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1999      *
2000      * Emits a {Transfer} event.
2001      */
2002     function _safeMint(address to, uint256 tokenId) internal virtual {
2003         _safeMint(to, tokenId, "");
2004     }
2005 
2006     /**
2007      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2008      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2009      */
2010     function _safeMint(
2011         address to,
2012         uint256 tokenId,
2013         bytes memory data
2014     ) internal virtual {
2015         _mint(to, tokenId);
2016         require(
2017             _checkOnERC721Received(address(0), to, tokenId, data),
2018             "ERC721: transfer to non ERC721Receiver implementer"
2019         );
2020     }
2021 
2022     /**
2023      * @dev Mints `tokenId` and transfers it to `to`.
2024      *
2025      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2026      *
2027      * Requirements:
2028      *
2029      * - `tokenId` must not exist.
2030      * - `to` cannot be the zero address.
2031      *
2032      * Emits a {Transfer} event.
2033      */
2034     function _mint(address to, uint256 tokenId) internal virtual {
2035         require(to != address(0), "ERC721: mint to the zero address");
2036         require(!_exists(tokenId), "ERC721: token already minted");
2037 
2038         _beforeTokenTransfer(address(0), to, tokenId);
2039 
2040         _balances[to] += 1;
2041         _owners[tokenId] = to;
2042 
2043         emit Transfer(address(0), to, tokenId);
2044 
2045         _afterTokenTransfer(address(0), to, tokenId);
2046     }
2047 
2048     /**
2049      * @dev Destroys `tokenId`.
2050      * The approval is cleared when the token is burned.
2051      *
2052      * Requirements:
2053      *
2054      * - `tokenId` must exist.
2055      *
2056      * Emits a {Transfer} event.
2057      */
2058     function _burn(uint256 tokenId) internal virtual {
2059         address owner = ERC721.ownerOf(tokenId);
2060 
2061         _beforeTokenTransfer(owner, address(0), tokenId);
2062 
2063         // Clear approvals
2064         _approve(address(0), tokenId);
2065 
2066         _balances[owner] -= 1;
2067         delete _owners[tokenId];
2068 
2069         emit Transfer(owner, address(0), tokenId);
2070 
2071         _afterTokenTransfer(owner, address(0), tokenId);
2072     }
2073 
2074     /**
2075      * @dev Transfers `tokenId` from `from` to `to`.
2076      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2077      *
2078      * Requirements:
2079      *
2080      * - `to` cannot be the zero address.
2081      * - `tokenId` token must be owned by `from`.
2082      *
2083      * Emits a {Transfer} event.
2084      */
2085     function _transfer(
2086         address from,
2087         address to,
2088         uint256 tokenId
2089     ) internal virtual {
2090         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2091         require(to != address(0), "ERC721: transfer to the zero address");
2092 
2093         _beforeTokenTransfer(from, to, tokenId);
2094 
2095         // Clear approvals from the previous owner
2096         _approve(address(0), tokenId);
2097 
2098         _balances[from] -= 1;
2099         _balances[to] += 1;
2100         _owners[tokenId] = to;
2101 
2102         emit Transfer(from, to, tokenId);
2103 
2104         _afterTokenTransfer(from, to, tokenId);
2105     }
2106 
2107     /**
2108      * @dev Approve `to` to operate on `tokenId`
2109      *
2110      * Emits an {Approval} event.
2111      */
2112     function _approve(address to, uint256 tokenId) internal virtual {
2113         _tokenApprovals[tokenId] = to;
2114         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2115     }
2116 
2117     /**
2118      * @dev Approve `operator` to operate on all of `owner` tokens
2119      *
2120      * Emits an {ApprovalForAll} event.
2121      */
2122     function _setApprovalForAll(
2123         address owner,
2124         address operator,
2125         bool approved
2126     ) internal virtual {
2127         require(owner != operator, "ERC721: approve to caller");
2128         _operatorApprovals[owner][operator] = approved;
2129         emit ApprovalForAll(owner, operator, approved);
2130     }
2131 
2132     /**
2133      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2134      * The call is not executed if the target address is not a contract.
2135      *
2136      * @param from address representing the previous owner of the given token ID
2137      * @param to target address that will receive the tokens
2138      * @param tokenId uint256 ID of the token to be transferred
2139      * @param data bytes optional data to send along with the call
2140      * @return bool whether the call correctly returned the expected magic value
2141      */
2142     function _checkOnERC721Received(
2143         address from,
2144         address to,
2145         uint256 tokenId,
2146         bytes memory data
2147     ) private returns (bool) {
2148         if (to.isContract()) {
2149             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2150                 return retval == IERC721Receiver.onERC721Received.selector;
2151             } catch (bytes memory reason) {
2152                 if (reason.length == 0) {
2153                     revert("ERC721: transfer to non ERC721Receiver implementer");
2154                 } else {
2155                     assembly {
2156                         revert(add(32, reason), mload(reason))
2157                     }
2158                 }
2159             }
2160         } else {
2161             return true;
2162         }
2163     }
2164 
2165     /**
2166      * @dev Hook that is called before any token transfer. This includes minting
2167      * and burning.
2168      *
2169      * Calling conditions:
2170      *
2171      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2172      * transferred to `to`.
2173      * - When `from` is zero, `tokenId` will be minted for `to`.
2174      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2175      * - `from` and `to` are never both zero.
2176      *
2177      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2178      */
2179     function _beforeTokenTransfer(
2180         address from,
2181         address to,
2182         uint256 tokenId
2183     ) internal virtual {}
2184 
2185     /**
2186      * @dev Hook that is called after any transfer of tokens. This includes
2187      * minting and burning.
2188      *
2189      * Calling conditions:
2190      *
2191      * - when `from` and `to` are both non-zero.
2192      * - `from` and `to` are never both zero.
2193      *
2194      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2195      */
2196     function _afterTokenTransfer(
2197         address from,
2198         address to,
2199         uint256 tokenId
2200     ) internal virtual {}
2201 }
2202 
2203 // File: contracts/ODYC.sol
2204 
2205 
2206 pragma solidity ^0.8.0;
2207 
2208 
2209 contract GPU is ERC721A, Ownable {
2210     using Strings for uint256;
2211 
2212     string private baseURI;
2213 
2214     uint256 public price = 0.008 ether;
2215 
2216     uint256 public maxPerTx = 10;
2217 
2218     uint256 public maxFreePerWallet = 10;
2219 
2220     uint256 public totalFree = 900;
2221 
2222     uint256 public maxSupply = 10000;
2223 
2224     bool public mintEnabled = false;
2225 
2226     mapping(address => uint256) private _mintedFreeAmount;
2227 
2228     constructor() ERC721A("GPU SOLDIER", "GPU SOLDIER") {
2229         _safeMint(msg.sender, 100);
2230         setBaseURI("ipfs://QmYgNfmyi25K9owaSFckjU4qgB95y9nr8vTMrWLRShSfYJ/");
2231     }
2232 
2233     function mint(uint256 count) external payable {
2234         uint256 cost = price;
2235         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2236             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2237 
2238         if (isFree) {
2239             cost = 0;
2240         }
2241 
2242         require(msg.value >= count * cost, "Please send the exact amount.");
2243         require(totalSupply() + count < maxSupply + 1, "No more");
2244         require(mintEnabled, "Minting is not live yet");
2245         require(count < maxPerTx + 1, "Max per TX reached.");
2246 
2247         if (isFree) {
2248             _mintedFreeAmount[msg.sender] += count;
2249         }
2250 
2251         _safeMint(msg.sender, count);
2252     }
2253 
2254     function _baseURI() internal view virtual override returns (string memory) {
2255         return baseURI;
2256     }
2257 
2258     function tokenURI(uint256 tokenId)
2259         public
2260         view
2261         virtual
2262         override
2263         returns (string memory)
2264     {
2265         require(
2266             _exists(tokenId),
2267             "ERC721Metadata: URI query for nonexistent token"
2268         );
2269         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2270     }
2271 
2272     function setBaseURI(string memory uri) public onlyOwner {
2273         baseURI = uri;
2274     }
2275 
2276     function setFreeAmount(uint256 amount) external onlyOwner {
2277         totalFree = amount;
2278     }
2279 
2280     function setPrice(uint256 _newPrice) external onlyOwner {
2281         price = _newPrice;
2282     }
2283 
2284     function flipSale() external onlyOwner {
2285         mintEnabled = !mintEnabled;
2286     }
2287 
2288     function withdraw() external onlyOwner {
2289         (bool success, ) = payable(msg.sender).call{
2290             value: address(this).balance
2291         }("");
2292         require(success, "Transfer failed.");
2293     }
2294 }