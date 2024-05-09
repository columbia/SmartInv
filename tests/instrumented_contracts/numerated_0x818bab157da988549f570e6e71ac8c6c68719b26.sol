1 // Sources flattened with hardhat v2.9.6 https://hardhat.org
2 
3 // File erc721a/contracts/IERC721A.sol@v4.0.0
4 
5 // SPDX-License-Identifier: MIT
6 // ERC721A Contracts v4.0.0
7 // Creator: Chiru Labs
8 
9 pragma solidity ^0.8.4;
10 
11 /**
12  * @dev Interface of an ERC721A compliant contract.
13  */
14 interface IERC721A {
15     /**
16      * The caller must own the token or be an approved operator.
17      */
18     error ApprovalCallerNotOwnerNorApproved();
19 
20     /**
21      * The token does not exist.
22      */
23     error ApprovalQueryForNonexistentToken();
24 
25     /**
26      * The caller cannot approve to their own address.
27      */
28     error ApproveToCaller();
29 
30     /**
31      * The caller cannot approve to the current owner.
32      */
33     error ApprovalToCurrentOwner();
34 
35     /**
36      * Cannot query the balance for the zero address.
37      */
38     error BalanceQueryForZeroAddress();
39 
40     /**
41      * Cannot mint to the zero address.
42      */
43     error MintToZeroAddress();
44 
45     /**
46      * The quantity of tokens minted must be more than zero.
47      */
48     error MintZeroQuantity();
49 
50     /**
51      * The token does not exist.
52      */
53     error OwnerQueryForNonexistentToken();
54 
55     /**
56      * The caller must own the token or be an approved operator.
57      */
58     error TransferCallerNotOwnerNorApproved();
59 
60     /**
61      * The token must be owned by `from`.
62      */
63     error TransferFromIncorrectOwner();
64 
65     /**
66      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
67      */
68     error TransferToNonERC721ReceiverImplementer();
69 
70     /**
71      * Cannot transfer to the zero address.
72      */
73     error TransferToZeroAddress();
74 
75     /**
76      * The token does not exist.
77      */
78     error URIQueryForNonexistentToken();
79 
80     struct TokenOwnership {
81         // The address of the owner.
82         address addr;
83         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
84         uint64 startTimestamp;
85         // Whether the token has been burned.
86         bool burned;
87     }
88 
89     /**
90      * @dev Returns the total amount of tokens stored by the contract.
91      *
92      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
93      */
94     function totalSupply() external view returns (uint256);
95 
96     // ==============================
97     //            IERC165
98     // ==============================
99 
100     /**
101      * @dev Returns true if this contract implements the interface defined by
102      * `interfaceId`. See the corresponding
103      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
104      * to learn more about how these ids are created.
105      *
106      * This function call must use less than 30 000 gas.
107      */
108     function supportsInterface(bytes4 interfaceId) external view returns (bool);
109 
110     // ==============================
111     //            IERC721
112     // ==============================
113 
114     /**
115      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
116      */
117     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
118 
119     /**
120      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
121      */
122     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
123 
124     /**
125      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
126      */
127     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
128 
129     /**
130      * @dev Returns the number of tokens in ``owner``'s account.
131      */
132     function balanceOf(address owner) external view returns (uint256 balance);
133 
134     /**
135      * @dev Returns the owner of the `tokenId` token.
136      *
137      * Requirements:
138      *
139      * - `tokenId` must exist.
140      */
141     function ownerOf(uint256 tokenId) external view returns (address owner);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 
163     /**
164      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
165      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId
181     ) external;
182 
183     /**
184      * @dev Transfers `tokenId` token from `from` to `to`.
185      *
186      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
187      *
188      * Requirements:
189      *
190      * - `from` cannot be the zero address.
191      * - `to` cannot be the zero address.
192      * - `tokenId` token must be owned by `from`.
193      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(
198         address from,
199         address to,
200         uint256 tokenId
201     ) external;
202 
203     /**
204      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
205      * The approval is cleared when the token is transferred.
206      *
207      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
208      *
209      * Requirements:
210      *
211      * - The caller must own the token or be an approved operator.
212      * - `tokenId` must exist.
213      *
214      * Emits an {Approval} event.
215      */
216     function approve(address to, uint256 tokenId) external;
217 
218     /**
219      * @dev Approve or remove `operator` as an operator for the caller.
220      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
221      *
222      * Requirements:
223      *
224      * - The `operator` cannot be the caller.
225      *
226      * Emits an {ApprovalForAll} event.
227      */
228     function setApprovalForAll(address operator, bool _approved) external;
229 
230     /**
231      * @dev Returns the account approved for `tokenId` token.
232      *
233      * Requirements:
234      *
235      * - `tokenId` must exist.
236      */
237     function getApproved(uint256 tokenId) external view returns (address operator);
238 
239     /**
240      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
241      *
242      * See {setApprovalForAll}
243      */
244     function isApprovedForAll(address owner, address operator) external view returns (bool);
245 
246     // ==============================
247     //        IERC721Metadata
248     // ==============================
249 
250     /**
251      * @dev Returns the token collection name.
252      */
253     function name() external view returns (string memory);
254 
255     /**
256      * @dev Returns the token collection symbol.
257      */
258     function symbol() external view returns (string memory);
259 
260     /**
261      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
262      */
263     function tokenURI(uint256 tokenId) external view returns (string memory);
264 }
265 
266 
267 // File erc721a/contracts/ERC721A.sol@v4.0.0
268 
269 
270 // ERC721A Contracts v4.0.0
271 // Creator: Chiru Labs
272 
273 pragma solidity ^0.8.4;
274 
275 /**
276  * @dev ERC721 token receiver interface.
277  */
278 interface ERC721A__IERC721Receiver {
279     function onERC721Received(
280         address operator,
281         address from,
282         uint256 tokenId,
283         bytes calldata data
284     ) external returns (bytes4);
285 }
286 
287 /**
288  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
289  * the Metadata extension. Built to optimize for lower gas during batch mints.
290  *
291  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
292  *
293  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
294  *
295  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
296  */
297 contract ERC721A is IERC721A {
298     // Mask of an entry in packed address data.
299     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
300 
301     // The bit position of `numberMinted` in packed address data.
302     uint256 private constant BITPOS_NUMBER_MINTED = 64;
303 
304     // The bit position of `numberBurned` in packed address data.
305     uint256 private constant BITPOS_NUMBER_BURNED = 128;
306 
307     // The bit position of `aux` in packed address data.
308     uint256 private constant BITPOS_AUX = 192;
309 
310     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
311     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
312 
313     // The bit position of `startTimestamp` in packed ownership.
314     uint256 private constant BITPOS_START_TIMESTAMP = 160;
315 
316     // The bit mask of the `burned` bit in packed ownership.
317     uint256 private constant BITMASK_BURNED = 1 << 224;
318     
319     // The bit position of the `nextInitialized` bit in packed ownership.
320     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
321 
322     // The bit mask of the `nextInitialized` bit in packed ownership.
323     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
324 
325     // The tokenId of the next token to be minted.
326     uint256 private _currentIndex;
327 
328     // The number of tokens burned.
329     uint256 private _burnCounter;
330 
331     // Token name
332     string private _name;
333 
334     // Token symbol
335     string private _symbol;
336 
337     // Mapping from token ID to ownership details
338     // An empty struct value does not necessarily mean the token is unowned.
339     // See `_packedOwnershipOf` implementation for details.
340     //
341     // Bits Layout:
342     // - [0..159]   `addr`
343     // - [160..223] `startTimestamp`
344     // - [224]      `burned`
345     // - [225]      `nextInitialized`
346     mapping(uint256 => uint256) private _packedOwnerships;
347 
348     // Mapping owner address to address data.
349     //
350     // Bits Layout:
351     // - [0..63]    `balance`
352     // - [64..127]  `numberMinted`
353     // - [128..191] `numberBurned`
354     // - [192..255] `aux`
355     mapping(address => uint256) private _packedAddressData;
356 
357     // Mapping from token ID to approved address.
358     mapping(uint256 => address) private _tokenApprovals;
359 
360     // Mapping from owner to operator approvals
361     mapping(address => mapping(address => bool)) private _operatorApprovals;
362 
363     constructor(string memory name_, string memory symbol_) {
364         _name = name_;
365         _symbol = symbol_;
366         _currentIndex = _startTokenId();
367     }
368 
369     /**
370      * @dev Returns the starting token ID. 
371      * To change the starting token ID, please override this function.
372      */
373     function _startTokenId() internal view virtual returns (uint256) {
374         return 0;
375     }
376 
377     /**
378      * @dev Returns the next token ID to be minted.
379      */
380     function _nextTokenId() internal view returns (uint256) {
381         return _currentIndex;
382     }
383 
384     /**
385      * @dev Returns the total number of tokens in existence.
386      * Burned tokens will reduce the count. 
387      * To get the total number of tokens minted, please see `_totalMinted`.
388      */
389     function totalSupply() public view override returns (uint256) {
390         // Counter underflow is impossible as _burnCounter cannot be incremented
391         // more than `_currentIndex - _startTokenId()` times.
392         unchecked {
393             return _currentIndex - _burnCounter - _startTokenId();
394         }
395     }
396 
397     /**
398      * @dev Returns the total amount of tokens minted in the contract.
399      */
400     function _totalMinted() internal view returns (uint256) {
401         // Counter underflow is impossible as _currentIndex does not decrement,
402         // and it is initialized to `_startTokenId()`
403         unchecked {
404             return _currentIndex - _startTokenId();
405         }
406     }
407 
408     /**
409      * @dev Returns the total number of tokens burned.
410      */
411     function _totalBurned() internal view returns (uint256) {
412         return _burnCounter;
413     }
414 
415     /**
416      * @dev See {IERC165-supportsInterface}.
417      */
418     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
419         // The interface IDs are constants representing the first 4 bytes of the XOR of
420         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
421         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
422         return
423             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
424             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
425             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
426     }
427 
428     /**
429      * @dev See {IERC721-balanceOf}.
430      */
431     function balanceOf(address owner) public view override returns (uint256) {
432         if (owner == address(0)) revert BalanceQueryForZeroAddress();
433         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
434     }
435 
436     /**
437      * Returns the number of tokens minted by `owner`.
438      */
439     function _numberMinted(address owner) internal view returns (uint256) {
440         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
441     }
442 
443     /**
444      * Returns the number of tokens burned by or on behalf of `owner`.
445      */
446     function _numberBurned(address owner) internal view returns (uint256) {
447         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
448     }
449 
450     /**
451      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
452      */
453     function _getAux(address owner) internal view returns (uint64) {
454         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
455     }
456 
457     /**
458      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
459      * If there are multiple variables, please pack them into a uint64.
460      */
461     function _setAux(address owner, uint64 aux) internal {
462         uint256 packed = _packedAddressData[owner];
463         uint256 auxCasted;
464         assembly { // Cast aux without masking.
465             auxCasted := aux
466         }
467         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
468         _packedAddressData[owner] = packed;
469     }
470 
471     /**
472      * Returns the packed ownership data of `tokenId`.
473      */
474     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
475         uint256 curr = tokenId;
476 
477         unchecked {
478             if (_startTokenId() <= curr)
479                 if (curr < _currentIndex) {
480                     uint256 packed = _packedOwnerships[curr];
481                     // If not burned.
482                     if (packed & BITMASK_BURNED == 0) {
483                         // Invariant:
484                         // There will always be an ownership that has an address and is not burned
485                         // before an ownership that does not have an address and is not burned.
486                         // Hence, curr will not underflow.
487                         //
488                         // We can directly compare the packed value.
489                         // If the address is zero, packed is zero.
490                         while (packed == 0) {
491                             packed = _packedOwnerships[--curr];
492                         }
493                         return packed;
494                     }
495                 }
496         }
497         revert OwnerQueryForNonexistentToken();
498     }
499 
500     /**
501      * Returns the unpacked `TokenOwnership` struct from `packed`.
502      */
503     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
504         ownership.addr = address(uint160(packed));
505         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
506         ownership.burned = packed & BITMASK_BURNED != 0;
507     }
508 
509     /**
510      * Returns the unpacked `TokenOwnership` struct at `index`.
511      */
512     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
513         return _unpackedOwnership(_packedOwnerships[index]);
514     }
515 
516     /**
517      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
518      */
519     function _initializeOwnershipAt(uint256 index) internal {
520         if (_packedOwnerships[index] == 0) {
521             _packedOwnerships[index] = _packedOwnershipOf(index);
522         }
523     }
524 
525     /**
526      * Gas spent here starts off proportional to the maximum mint batch size.
527      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
528      */
529     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
530         return _unpackedOwnership(_packedOwnershipOf(tokenId));
531     }
532 
533     /**
534      * @dev See {IERC721-ownerOf}.
535      */
536     function ownerOf(uint256 tokenId) public view override returns (address) {
537         return address(uint160(_packedOwnershipOf(tokenId)));
538     }
539 
540     /**
541      * @dev See {IERC721Metadata-name}.
542      */
543     function name() public view virtual override returns (string memory) {
544         return _name;
545     }
546 
547     /**
548      * @dev See {IERC721Metadata-symbol}.
549      */
550     function symbol() public view virtual override returns (string memory) {
551         return _symbol;
552     }
553 
554     /**
555      * @dev See {IERC721Metadata-tokenURI}.
556      */
557     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
558         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
559 
560         string memory baseURI = _baseURI();
561         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
562     }
563 
564     /**
565      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
566      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
567      * by default, can be overriden in child contracts.
568      */
569     function _baseURI() internal view virtual returns (string memory) {
570         return '';
571     }
572 
573     /**
574      * @dev Casts the address to uint256 without masking.
575      */
576     function _addressToUint256(address value) private pure returns (uint256 result) {
577         assembly {
578             result := value
579         }
580     }
581 
582     /**
583      * @dev Casts the boolean to uint256 without branching.
584      */
585     function _boolToUint256(bool value) private pure returns (uint256 result) {
586         assembly {
587             result := value
588         }
589     }
590 
591     /**
592      * @dev See {IERC721-approve}.
593      */
594     function approve(address to, uint256 tokenId) public override {
595         address owner = address(uint160(_packedOwnershipOf(tokenId)));
596         if (to == owner) revert ApprovalToCurrentOwner();
597 
598         if (_msgSenderERC721A() != owner)
599             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
600                 revert ApprovalCallerNotOwnerNorApproved();
601             }
602 
603         _tokenApprovals[tokenId] = to;
604         emit Approval(owner, to, tokenId);
605     }
606 
607     /**
608      * @dev See {IERC721-getApproved}.
609      */
610     function getApproved(uint256 tokenId) public view override returns (address) {
611         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
612 
613         return _tokenApprovals[tokenId];
614     }
615 
616     /**
617      * @dev See {IERC721-setApprovalForAll}.
618      */
619     function setApprovalForAll(address operator, bool approved) public virtual override {
620         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
621 
622         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
623         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
624     }
625 
626     /**
627      * @dev See {IERC721-isApprovedForAll}.
628      */
629     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
630         return _operatorApprovals[owner][operator];
631     }
632 
633     /**
634      * @dev See {IERC721-transferFrom}.
635      */
636     function transferFrom(
637         address from,
638         address to,
639         uint256 tokenId
640     ) public virtual override {
641         _transfer(from, to, tokenId);
642     }
643 
644     /**
645      * @dev See {IERC721-safeTransferFrom}.
646      */
647     function safeTransferFrom(
648         address from,
649         address to,
650         uint256 tokenId
651     ) public virtual override {
652         safeTransferFrom(from, to, tokenId, '');
653     }
654 
655     /**
656      * @dev See {IERC721-safeTransferFrom}.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId,
662         bytes memory _data
663     ) public virtual override {
664         _transfer(from, to, tokenId);
665         if (to.code.length != 0)
666             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
667                 revert TransferToNonERC721ReceiverImplementer();
668             }
669     }
670 
671     /**
672      * @dev Returns whether `tokenId` exists.
673      *
674      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
675      *
676      * Tokens start existing when they are minted (`_mint`),
677      */
678     function _exists(uint256 tokenId) internal view returns (bool) {
679         return
680             _startTokenId() <= tokenId &&
681             tokenId < _currentIndex && // If within bounds,
682             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
683     }
684 
685     /**
686      * @dev Equivalent to `_safeMint(to, quantity, '')`.
687      */
688     function _safeMint(address to, uint256 quantity) internal {
689         _safeMint(to, quantity, '');
690     }
691 
692     /**
693      * @dev Safely mints `quantity` tokens and transfers them to `to`.
694      *
695      * Requirements:
696      *
697      * - If `to` refers to a smart contract, it must implement
698      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
699      * - `quantity` must be greater than 0.
700      *
701      * Emits a {Transfer} event.
702      */
703     function _safeMint(
704         address to,
705         uint256 quantity,
706         bytes memory _data
707     ) internal {
708         uint256 startTokenId = _currentIndex;
709         if (to == address(0)) revert MintToZeroAddress();
710         if (quantity == 0) revert MintZeroQuantity();
711 
712         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
713 
714         // Overflows are incredibly unrealistic.
715         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
716         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
717         unchecked {
718             // Updates:
719             // - `balance += quantity`.
720             // - `numberMinted += quantity`.
721             //
722             // We can directly add to the balance and number minted.
723             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
724 
725             // Updates:
726             // - `address` to the owner.
727             // - `startTimestamp` to the timestamp of minting.
728             // - `burned` to `false`.
729             // - `nextInitialized` to `quantity == 1`.
730             _packedOwnerships[startTokenId] =
731                 _addressToUint256(to) |
732                 (block.timestamp << BITPOS_START_TIMESTAMP) |
733                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
734 
735             uint256 updatedIndex = startTokenId;
736             uint256 end = updatedIndex + quantity;
737 
738             if (to.code.length != 0) {
739                 do {
740                     emit Transfer(address(0), to, updatedIndex);
741                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
742                         revert TransferToNonERC721ReceiverImplementer();
743                     }
744                 } while (updatedIndex < end);
745                 // Reentrancy protection
746                 if (_currentIndex != startTokenId) revert();
747             } else {
748                 do {
749                     emit Transfer(address(0), to, updatedIndex++);
750                 } while (updatedIndex < end);
751             }
752             _currentIndex = updatedIndex;
753         }
754         _afterTokenTransfers(address(0), to, startTokenId, quantity);
755     }
756 
757     /**
758      * @dev Mints `quantity` tokens and transfers them to `to`.
759      *
760      * Requirements:
761      *
762      * - `to` cannot be the zero address.
763      * - `quantity` must be greater than 0.
764      *
765      * Emits a {Transfer} event.
766      */
767     function _mint(address to, uint256 quantity) internal {
768         uint256 startTokenId = _currentIndex;
769         if (to == address(0)) revert MintToZeroAddress();
770         if (quantity == 0) revert MintZeroQuantity();
771 
772         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
773 
774         // Overflows are incredibly unrealistic.
775         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
776         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
777         unchecked {
778             // Updates:
779             // - `balance += quantity`.
780             // - `numberMinted += quantity`.
781             //
782             // We can directly add to the balance and number minted.
783             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
784 
785             // Updates:
786             // - `address` to the owner.
787             // - `startTimestamp` to the timestamp of minting.
788             // - `burned` to `false`.
789             // - `nextInitialized` to `quantity == 1`.
790             _packedOwnerships[startTokenId] =
791                 _addressToUint256(to) |
792                 (block.timestamp << BITPOS_START_TIMESTAMP) |
793                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
794 
795             uint256 updatedIndex = startTokenId;
796             uint256 end = updatedIndex + quantity;
797 
798             do {
799                 emit Transfer(address(0), to, updatedIndex++);
800             } while (updatedIndex < end);
801 
802             _currentIndex = updatedIndex;
803         }
804         _afterTokenTransfers(address(0), to, startTokenId, quantity);
805     }
806 
807     /**
808      * @dev Transfers `tokenId` from `from` to `to`.
809      *
810      * Requirements:
811      *
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must be owned by `from`.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _transfer(
818         address from,
819         address to,
820         uint256 tokenId
821     ) private {
822         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
823 
824         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
825 
826         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
827             isApprovedForAll(from, _msgSenderERC721A()) ||
828             getApproved(tokenId) == _msgSenderERC721A());
829 
830         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
831         if (to == address(0)) revert TransferToZeroAddress();
832 
833         _beforeTokenTransfers(from, to, tokenId, 1);
834 
835         // Clear approvals from the previous owner.
836         delete _tokenApprovals[tokenId];
837 
838         // Underflow of the sender's balance is impossible because we check for
839         // ownership above and the recipient's balance can't realistically overflow.
840         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
841         unchecked {
842             // We can directly increment and decrement the balances.
843             --_packedAddressData[from]; // Updates: `balance -= 1`.
844             ++_packedAddressData[to]; // Updates: `balance += 1`.
845 
846             // Updates:
847             // - `address` to the next owner.
848             // - `startTimestamp` to the timestamp of transfering.
849             // - `burned` to `false`.
850             // - `nextInitialized` to `true`.
851             _packedOwnerships[tokenId] =
852                 _addressToUint256(to) |
853                 (block.timestamp << BITPOS_START_TIMESTAMP) |
854                 BITMASK_NEXT_INITIALIZED;
855 
856             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
857             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
858                 uint256 nextTokenId = tokenId + 1;
859                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
860                 if (_packedOwnerships[nextTokenId] == 0) {
861                     // If the next slot is within bounds.
862                     if (nextTokenId != _currentIndex) {
863                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
864                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
865                     }
866                 }
867             }
868         }
869 
870         emit Transfer(from, to, tokenId);
871         _afterTokenTransfers(from, to, tokenId, 1);
872     }
873 
874     /**
875      * @dev Equivalent to `_burn(tokenId, false)`.
876      */
877     function _burn(uint256 tokenId) internal virtual {
878         _burn(tokenId, false);
879     }
880 
881     /**
882      * @dev Destroys `tokenId`.
883      * The approval is cleared when the token is burned.
884      *
885      * Requirements:
886      *
887      * - `tokenId` must exist.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
892         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
893 
894         address from = address(uint160(prevOwnershipPacked));
895 
896         if (approvalCheck) {
897             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
898                 isApprovedForAll(from, _msgSenderERC721A()) ||
899                 getApproved(tokenId) == _msgSenderERC721A());
900 
901             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
902         }
903 
904         _beforeTokenTransfers(from, address(0), tokenId, 1);
905 
906         // Clear approvals from the previous owner.
907         delete _tokenApprovals[tokenId];
908 
909         // Underflow of the sender's balance is impossible because we check for
910         // ownership above and the recipient's balance can't realistically overflow.
911         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
912         unchecked {
913             // Updates:
914             // - `balance -= 1`.
915             // - `numberBurned += 1`.
916             //
917             // We can directly decrement the balance, and increment the number burned.
918             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
919             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
920 
921             // Updates:
922             // - `address` to the last owner.
923             // - `startTimestamp` to the timestamp of burning.
924             // - `burned` to `true`.
925             // - `nextInitialized` to `true`.
926             _packedOwnerships[tokenId] =
927                 _addressToUint256(from) |
928                 (block.timestamp << BITPOS_START_TIMESTAMP) |
929                 BITMASK_BURNED | 
930                 BITMASK_NEXT_INITIALIZED;
931 
932             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
933             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
934                 uint256 nextTokenId = tokenId + 1;
935                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
936                 if (_packedOwnerships[nextTokenId] == 0) {
937                     // If the next slot is within bounds.
938                     if (nextTokenId != _currentIndex) {
939                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
940                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
941                     }
942                 }
943             }
944         }
945 
946         emit Transfer(from, address(0), tokenId);
947         _afterTokenTransfers(from, address(0), tokenId, 1);
948 
949         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
950         unchecked {
951             _burnCounter++;
952         }
953     }
954 
955     /**
956      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
957      *
958      * @param from address representing the previous owner of the given token ID
959      * @param to target address that will receive the tokens
960      * @param tokenId uint256 ID of the token to be transferred
961      * @param _data bytes optional data to send along with the call
962      * @return bool whether the call correctly returned the expected magic value
963      */
964     function _checkContractOnERC721Received(
965         address from,
966         address to,
967         uint256 tokenId,
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
1084 
1085 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.6.0
1086 
1087 
1088 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1089 
1090 pragma solidity ^0.8.0;
1091 
1092 /**
1093  * @dev These functions deal with verification of Merkle Trees proofs.
1094  *
1095  * The proofs can be generated using the JavaScript library
1096  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1097  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1098  *
1099  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1100  *
1101  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1102  * hashing, or use a hash function other than keccak256 for hashing leaves.
1103  * This is because the concatenation of a sorted pair of internal nodes in
1104  * the merkle tree could be reinterpreted as a leaf value.
1105  */
1106 library MerkleProof {
1107     /**
1108      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1109      * defined by `root`. For this, a `proof` must be provided, containing
1110      * sibling hashes on the branch from the leaf to the root of the tree. Each
1111      * pair of leaves and each pair of pre-images are assumed to be sorted.
1112      */
1113     function verify(
1114         bytes32[] memory proof,
1115         bytes32 root,
1116         bytes32 leaf
1117     ) internal pure returns (bool) {
1118         return processProof(proof, leaf) == root;
1119     }
1120 
1121     /**
1122      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1123      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1124      * hash matches the root of the tree. When processing the proof, the pairs
1125      * of leafs & pre-images are assumed to be sorted.
1126      *
1127      * _Available since v4.4._
1128      */
1129     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1130         bytes32 computedHash = leaf;
1131         for (uint256 i = 0; i < proof.length; i++) {
1132             bytes32 proofElement = proof[i];
1133             if (computedHash <= proofElement) {
1134                 // Hash(current computed hash + current element of the proof)
1135                 computedHash = _efficientHash(computedHash, proofElement);
1136             } else {
1137                 // Hash(current element of the proof + current computed hash)
1138                 computedHash = _efficientHash(proofElement, computedHash);
1139             }
1140         }
1141         return computedHash;
1142     }
1143 
1144     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1145         assembly {
1146             mstore(0x00, a)
1147             mstore(0x20, b)
1148             value := keccak256(0x00, 0x40)
1149         }
1150     }
1151 }
1152 
1153 
1154 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
1155 
1156 
1157 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1158 
1159 pragma solidity ^0.8.0;
1160 
1161 /**
1162  * @dev Provides information about the current execution context, including the
1163  * sender of the transaction and its data. While these are generally available
1164  * via msg.sender and msg.data, they should not be accessed in such a direct
1165  * manner, since when dealing with meta-transactions the account sending and
1166  * paying for execution may not be the actual sender (as far as an application
1167  * is concerned).
1168  *
1169  * This contract is only required for intermediate, library-like contracts.
1170  */
1171 abstract contract Context {
1172     function _msgSender() internal view virtual returns (address) {
1173         return msg.sender;
1174     }
1175 
1176     function _msgData() internal view virtual returns (bytes calldata) {
1177         return msg.data;
1178     }
1179 }
1180 
1181 
1182 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1183 
1184 
1185 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 /**
1190  * @dev Contract module which provides a basic access control mechanism, where
1191  * there is an account (an owner) that can be granted exclusive access to
1192  * specific functions.
1193  *
1194  * By default, the owner account will be the one that deploys the contract. This
1195  * can later be changed with {transferOwnership}.
1196  *
1197  * This module is used through inheritance. It will make available the modifier
1198  * `onlyOwner`, which can be applied to your functions to restrict their use to
1199  * the owner.
1200  */
1201 abstract contract Ownable is Context {
1202     address private _owner;
1203 
1204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1205 
1206     /**
1207      * @dev Initializes the contract setting the deployer as the initial owner.
1208      */
1209     constructor() {
1210         _transferOwnership(_msgSender());
1211     }
1212 
1213     /**
1214      * @dev Returns the address of the current owner.
1215      */
1216     function owner() public view virtual returns (address) {
1217         return _owner;
1218     }
1219 
1220     /**
1221      * @dev Throws if called by any account other than the owner.
1222      */
1223     modifier onlyOwner() {
1224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1225         _;
1226     }
1227 
1228     /**
1229      * @dev Leaves the contract without owner. It will not be possible to call
1230      * `onlyOwner` functions anymore. Can only be called by the current owner.
1231      *
1232      * NOTE: Renouncing ownership will leave the contract without an owner,
1233      * thereby removing any functionality that is only available to the owner.
1234      */
1235     function renounceOwnership() public virtual onlyOwner {
1236         _transferOwnership(address(0));
1237     }
1238 
1239     /**
1240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1241      * Can only be called by the current owner.
1242      */
1243     function transferOwnership(address newOwner) public virtual onlyOwner {
1244         require(newOwner != address(0), "Ownable: new owner is the zero address");
1245         _transferOwnership(newOwner);
1246     }
1247 
1248     /**
1249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1250      * Internal function without access restriction.
1251      */
1252     function _transferOwnership(address newOwner) internal virtual {
1253         address oldOwner = _owner;
1254         _owner = newOwner;
1255         emit OwnershipTransferred(oldOwner, newOwner);
1256     }
1257 }
1258 
1259 
1260 // File contracts/DeadBears.sol
1261 
1262 pragma solidity ^0.8.4;
1263 
1264 
1265 
1266 contract DeadBears is ERC721A, Ownable {
1267     uint256 public MAX_SUPPLY = 4444;
1268     uint256 public MAX_BUY_SUPPLY = 4000;
1269     uint256 public MAX_FREE_SUPPLY = 333;
1270     uint256 public PRICE = 0.03 ether;
1271     string public BASE_URI = "";
1272 
1273     uint256 public freeClaimed = 0;
1274     uint256 public bought = 0;
1275 
1276     bytes32 public merkleRoot;
1277     mapping(address => bool) public hasClaimed;
1278 
1279     bool public open;
1280     uint256 public walletLimit;
1281     bool public disableOwnerMint;
1282 
1283     constructor() ERC721A("DeadBears", "DEADB") {
1284         open = false;
1285         walletLimit = 20;
1286         disableOwnerMint = false;
1287     }
1288 
1289     function ownerMint(uint256 num) public onlyOwner {
1290         require(!disableOwnerMint);
1291         _safeMint(msg.sender, num);
1292     }
1293 
1294     function mintWhitelist(bytes32[] calldata proof) external {
1295         require(open);
1296         require(freeClaimed < MAX_FREE_SUPPLY);
1297 
1298         if (hasClaimed[msg.sender]) revert();
1299 
1300         // Verify merkle proof, or revert if not in tree
1301         bytes32 leaf = keccak256(abi.encodePacked(msg.sender, uint256(1)));
1302         bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
1303         if (!isValidLeaf) revert();
1304 
1305         // Set address to claimed
1306         hasClaimed[msg.sender] = true;
1307 
1308         // Mint tokens to address
1309         _safeMint(msg.sender, 1);
1310 
1311         freeClaimed += 1;
1312     }
1313 
1314     function mint(uint256 quantity) external payable {
1315         require(open);
1316         require(bought < MAX_BUY_SUPPLY);
1317 
1318         if (quantity > walletLimit) {
1319             quantity = walletLimit;
1320         }
1321 
1322         if (quantity + _totalMinted() > MAX_SUPPLY) {
1323             quantity = MAX_SUPPLY - _totalMinted();
1324         }
1325 
1326         require(msg.value >= quantity * PRICE, "Not enough ETH sent.");
1327 
1328         _safeMint(msg.sender, quantity);
1329         bought += 1;
1330 
1331         uint256 remaining = msg.value - (quantity * PRICE);
1332         if (remaining > 0) {
1333             (bool success, ) = msg.sender.call{value: remaining}("");
1334             require(success);
1335         }
1336     }
1337 
1338     function _baseURI() internal view override returns (string memory) {
1339         return BASE_URI;
1340     }
1341 
1342     function setBaseUri(string calldata _baseUri) public onlyOwner {
1343         BASE_URI = _baseUri;
1344     }
1345 
1346     function setMerkleRoot(bytes32 root) public onlyOwner {
1347         merkleRoot = root;
1348     }
1349 
1350     function setWalletLimit(uint256 limit) public onlyOwner {
1351         walletLimit = limit;
1352     }
1353 
1354     function setOpen(bool o) public onlyOwner {
1355         open = o;
1356     }
1357 
1358     function permanentlyDisableOwnerMint() public onlyOwner {
1359         disableOwnerMint = true;
1360     }
1361 
1362     function withdraw() external onlyOwner {
1363         uint256 bal = address(this).balance;
1364         payable(address(0x84f6FfeF5d9e888049e46C7eDD618a817f6c2c06)).call{value: bal}("");
1365     }
1366 }