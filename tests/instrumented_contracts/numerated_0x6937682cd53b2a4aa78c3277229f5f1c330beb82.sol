1 // Sources flattened with hardhat v2.9.7 https://hardhat.org
2 
3 // File erc721a/contracts/IERC721A.sol@v4.0.0
4 
5 
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
1085 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
1086 
1087 
1088 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1089 
1090 pragma solidity ^0.8.0;
1091 
1092 /**
1093  * @dev String operations.
1094  */
1095 library Strings {
1096     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1097 
1098     /**
1099      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1100      */
1101     function toString(uint256 value) internal pure returns (string memory) {
1102         // Inspired by OraclizeAPI's implementation - MIT licence
1103         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1104 
1105         if (value == 0) {
1106             return "0";
1107         }
1108         uint256 temp = value;
1109         uint256 digits;
1110         while (temp != 0) {
1111             digits++;
1112             temp /= 10;
1113         }
1114         bytes memory buffer = new bytes(digits);
1115         while (value != 0) {
1116             digits -= 1;
1117             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1118             value /= 10;
1119         }
1120         return string(buffer);
1121     }
1122 
1123     /**
1124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1125      */
1126     function toHexString(uint256 value) internal pure returns (string memory) {
1127         if (value == 0) {
1128             return "0x00";
1129         }
1130         uint256 temp = value;
1131         uint256 length = 0;
1132         while (temp != 0) {
1133             length++;
1134             temp >>= 8;
1135         }
1136         return toHexString(value, length);
1137     }
1138 
1139     /**
1140      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1141      */
1142     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1143         bytes memory buffer = new bytes(2 * length + 2);
1144         buffer[0] = "0";
1145         buffer[1] = "x";
1146         for (uint256 i = 2 * length + 1; i > 1; --i) {
1147             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1148             value >>= 4;
1149         }
1150         require(value == 0, "Strings: hex length insufficient");
1151         return string(buffer);
1152     }
1153 }
1154 
1155 
1156 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.6.0
1157 
1158 
1159 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 /**
1164  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1165  *
1166  * These functions can be used to verify that a message was signed by the holder
1167  * of the private keys of a given address.
1168  */
1169 library ECDSA {
1170     enum RecoverError {
1171         NoError,
1172         InvalidSignature,
1173         InvalidSignatureLength,
1174         InvalidSignatureS,
1175         InvalidSignatureV
1176     }
1177 
1178     function _throwError(RecoverError error) private pure {
1179         if (error == RecoverError.NoError) {
1180             return; // no error: do nothing
1181         } else if (error == RecoverError.InvalidSignature) {
1182             revert("ECDSA: invalid signature");
1183         } else if (error == RecoverError.InvalidSignatureLength) {
1184             revert("ECDSA: invalid signature length");
1185         } else if (error == RecoverError.InvalidSignatureS) {
1186             revert("ECDSA: invalid signature 's' value");
1187         } else if (error == RecoverError.InvalidSignatureV) {
1188             revert("ECDSA: invalid signature 'v' value");
1189         }
1190     }
1191 
1192     /**
1193      * @dev Returns the address that signed a hashed message (`hash`) with
1194      * `signature` or error string. This address can then be used for verification purposes.
1195      *
1196      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1197      * this function rejects them by requiring the `s` value to be in the lower
1198      * half order, and the `v` value to be either 27 or 28.
1199      *
1200      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1201      * verification to be secure: it is possible to craft signatures that
1202      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1203      * this is by receiving a hash of the original message (which may otherwise
1204      * be too long), and then calling {toEthSignedMessageHash} on it.
1205      *
1206      * Documentation for signature generation:
1207      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1208      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1209      *
1210      * _Available since v4.3._
1211      */
1212     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1213         // Check the signature length
1214         // - case 65: r,s,v signature (standard)
1215         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1216         if (signature.length == 65) {
1217             bytes32 r;
1218             bytes32 s;
1219             uint8 v;
1220             // ecrecover takes the signature parameters, and the only way to get them
1221             // currently is to use assembly.
1222             assembly {
1223                 r := mload(add(signature, 0x20))
1224                 s := mload(add(signature, 0x40))
1225                 v := byte(0, mload(add(signature, 0x60)))
1226             }
1227             return tryRecover(hash, v, r, s);
1228         } else if (signature.length == 64) {
1229             bytes32 r;
1230             bytes32 vs;
1231             // ecrecover takes the signature parameters, and the only way to get them
1232             // currently is to use assembly.
1233             assembly {
1234                 r := mload(add(signature, 0x20))
1235                 vs := mload(add(signature, 0x40))
1236             }
1237             return tryRecover(hash, r, vs);
1238         } else {
1239             return (address(0), RecoverError.InvalidSignatureLength);
1240         }
1241     }
1242 
1243     /**
1244      * @dev Returns the address that signed a hashed message (`hash`) with
1245      * `signature`. This address can then be used for verification purposes.
1246      *
1247      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1248      * this function rejects them by requiring the `s` value to be in the lower
1249      * half order, and the `v` value to be either 27 or 28.
1250      *
1251      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1252      * verification to be secure: it is possible to craft signatures that
1253      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1254      * this is by receiving a hash of the original message (which may otherwise
1255      * be too long), and then calling {toEthSignedMessageHash} on it.
1256      */
1257     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1258         (address recovered, RecoverError error) = tryRecover(hash, signature);
1259         _throwError(error);
1260         return recovered;
1261     }
1262 
1263     /**
1264      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1265      *
1266      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1267      *
1268      * _Available since v4.3._
1269      */
1270     function tryRecover(
1271         bytes32 hash,
1272         bytes32 r,
1273         bytes32 vs
1274     ) internal pure returns (address, RecoverError) {
1275         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1276         uint8 v = uint8((uint256(vs) >> 255) + 27);
1277         return tryRecover(hash, v, r, s);
1278     }
1279 
1280     /**
1281      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1282      *
1283      * _Available since v4.2._
1284      */
1285     function recover(
1286         bytes32 hash,
1287         bytes32 r,
1288         bytes32 vs
1289     ) internal pure returns (address) {
1290         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1291         _throwError(error);
1292         return recovered;
1293     }
1294 
1295     /**
1296      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1297      * `r` and `s` signature fields separately.
1298      *
1299      * _Available since v4.3._
1300      */
1301     function tryRecover(
1302         bytes32 hash,
1303         uint8 v,
1304         bytes32 r,
1305         bytes32 s
1306     ) internal pure returns (address, RecoverError) {
1307         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1308         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1309         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1310         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1311         //
1312         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1313         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1314         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1315         // these malleable signatures as well.
1316         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1317             return (address(0), RecoverError.InvalidSignatureS);
1318         }
1319         if (v != 27 && v != 28) {
1320             return (address(0), RecoverError.InvalidSignatureV);
1321         }
1322 
1323         // If the signature is valid (and not malleable), return the signer address
1324         address signer = ecrecover(hash, v, r, s);
1325         if (signer == address(0)) {
1326             return (address(0), RecoverError.InvalidSignature);
1327         }
1328 
1329         return (signer, RecoverError.NoError);
1330     }
1331 
1332     /**
1333      * @dev Overload of {ECDSA-recover} that receives the `v`,
1334      * `r` and `s` signature fields separately.
1335      */
1336     function recover(
1337         bytes32 hash,
1338         uint8 v,
1339         bytes32 r,
1340         bytes32 s
1341     ) internal pure returns (address) {
1342         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1343         _throwError(error);
1344         return recovered;
1345     }
1346 
1347     /**
1348      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1349      * produces hash corresponding to the one signed with the
1350      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1351      * JSON-RPC method as part of EIP-191.
1352      *
1353      * See {recover}.
1354      */
1355     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1356         // 32 is the length in bytes of hash,
1357         // enforced by the type signature above
1358         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1359     }
1360 
1361     /**
1362      * @dev Returns an Ethereum Signed Message, created from `s`. This
1363      * produces hash corresponding to the one signed with the
1364      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1365      * JSON-RPC method as part of EIP-191.
1366      *
1367      * See {recover}.
1368      */
1369     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1370         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1371     }
1372 
1373     /**
1374      * @dev Returns an Ethereum Signed Typed Data, created from a
1375      * `domainSeparator` and a `structHash`. This produces hash corresponding
1376      * to the one signed with the
1377      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1378      * JSON-RPC method as part of EIP-712.
1379      *
1380      * See {recover}.
1381      */
1382     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1383         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1384     }
1385 }
1386 
1387 
1388 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
1389 
1390 
1391 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1392 
1393 pragma solidity ^0.8.0;
1394 
1395 /**
1396  * @dev Interface of the ERC165 standard, as defined in the
1397  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1398  *
1399  * Implementers can declare support of contract interfaces, which can then be
1400  * queried by others ({ERC165Checker}).
1401  *
1402  * For an implementation, see {ERC165}.
1403  */
1404 interface IERC165 {
1405     /**
1406      * @dev Returns true if this contract implements the interface defined by
1407      * `interfaceId`. See the corresponding
1408      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1409      * to learn more about how these ids are created.
1410      *
1411      * This function call must use less than 30 000 gas.
1412      */
1413     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1414 }
1415 
1416 
1417 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
1418 
1419 
1420 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1421 
1422 pragma solidity ^0.8.0;
1423 
1424 /**
1425  * @dev Required interface of an ERC721 compliant contract.
1426  */
1427 interface IERC721 is IERC165 {
1428     /**
1429      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1430      */
1431     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1432 
1433     /**
1434      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1435      */
1436     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1437 
1438     /**
1439      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1440      */
1441     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1442 
1443     /**
1444      * @dev Returns the number of tokens in ``owner``'s account.
1445      */
1446     function balanceOf(address owner) external view returns (uint256 balance);
1447 
1448     /**
1449      * @dev Returns the owner of the `tokenId` token.
1450      *
1451      * Requirements:
1452      *
1453      * - `tokenId` must exist.
1454      */
1455     function ownerOf(uint256 tokenId) external view returns (address owner);
1456 
1457     /**
1458      * @dev Safely transfers `tokenId` token from `from` to `to`.
1459      *
1460      * Requirements:
1461      *
1462      * - `from` cannot be the zero address.
1463      * - `to` cannot be the zero address.
1464      * - `tokenId` token must exist and be owned by `from`.
1465      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1466      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1467      *
1468      * Emits a {Transfer} event.
1469      */
1470     function safeTransferFrom(
1471         address from,
1472         address to,
1473         uint256 tokenId,
1474         bytes calldata data
1475     ) external;
1476 
1477     /**
1478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1480      *
1481      * Requirements:
1482      *
1483      * - `from` cannot be the zero address.
1484      * - `to` cannot be the zero address.
1485      * - `tokenId` token must exist and be owned by `from`.
1486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1488      *
1489      * Emits a {Transfer} event.
1490      */
1491     function safeTransferFrom(
1492         address from,
1493         address to,
1494         uint256 tokenId
1495     ) external;
1496 
1497     /**
1498      * @dev Transfers `tokenId` token from `from` to `to`.
1499      *
1500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1501      *
1502      * Requirements:
1503      *
1504      * - `from` cannot be the zero address.
1505      * - `to` cannot be the zero address.
1506      * - `tokenId` token must be owned by `from`.
1507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function transferFrom(
1512         address from,
1513         address to,
1514         uint256 tokenId
1515     ) external;
1516 
1517     /**
1518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1519      * The approval is cleared when the token is transferred.
1520      *
1521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1522      *
1523      * Requirements:
1524      *
1525      * - The caller must own the token or be an approved operator.
1526      * - `tokenId` must exist.
1527      *
1528      * Emits an {Approval} event.
1529      */
1530     function approve(address to, uint256 tokenId) external;
1531 
1532     /**
1533      * @dev Approve or remove `operator` as an operator for the caller.
1534      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1535      *
1536      * Requirements:
1537      *
1538      * - The `operator` cannot be the caller.
1539      *
1540      * Emits an {ApprovalForAll} event.
1541      */
1542     function setApprovalForAll(address operator, bool _approved) external;
1543 
1544     /**
1545      * @dev Returns the account approved for `tokenId` token.
1546      *
1547      * Requirements:
1548      *
1549      * - `tokenId` must exist.
1550      */
1551     function getApproved(uint256 tokenId) external view returns (address operator);
1552 
1553     /**
1554      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1555      *
1556      * See {setApprovalForAll}
1557      */
1558     function isApprovedForAll(address owner, address operator) external view returns (bool);
1559 }
1560 
1561 
1562 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
1563 
1564 
1565 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1566 
1567 pragma solidity ^0.8.0;
1568 
1569 /**
1570  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1571  * @dev See https://eips.ethereum.org/EIPS/eip-721
1572  */
1573 interface IERC721Metadata is IERC721 {
1574     /**
1575      * @dev Returns the token collection name.
1576      */
1577     function name() external view returns (string memory);
1578 
1579     /**
1580      * @dev Returns the token collection symbol.
1581      */
1582     function symbol() external view returns (string memory);
1583 
1584     /**
1585      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1586      */
1587     function tokenURI(uint256 tokenId) external view returns (string memory);
1588 }
1589 
1590 
1591 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
1592 
1593 
1594 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1595 
1596 pragma solidity ^0.8.0;
1597 
1598 /**
1599  * @dev Provides information about the current execution context, including the
1600  * sender of the transaction and its data. While these are generally available
1601  * via msg.sender and msg.data, they should not be accessed in such a direct
1602  * manner, since when dealing with meta-transactions the account sending and
1603  * paying for execution may not be the actual sender (as far as an application
1604  * is concerned).
1605  *
1606  * This contract is only required for intermediate, library-like contracts.
1607  */
1608 abstract contract Context {
1609     function _msgSender() internal view virtual returns (address) {
1610         return msg.sender;
1611     }
1612 
1613     function _msgData() internal view virtual returns (bytes calldata) {
1614         return msg.data;
1615     }
1616 }
1617 
1618 
1619 // File @openzeppelin/contracts/security/Pausable.sol@v4.6.0
1620 
1621 
1622 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1623 
1624 pragma solidity ^0.8.0;
1625 
1626 /**
1627  * @dev Contract module which allows children to implement an emergency stop
1628  * mechanism that can be triggered by an authorized account.
1629  *
1630  * This module is used through inheritance. It will make available the
1631  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1632  * the functions of your contract. Note that they will not be pausable by
1633  * simply including this module, only once the modifiers are put in place.
1634  */
1635 abstract contract Pausable is Context {
1636     /**
1637      * @dev Emitted when the pause is triggered by `account`.
1638      */
1639     event Paused(address account);
1640 
1641     /**
1642      * @dev Emitted when the pause is lifted by `account`.
1643      */
1644     event Unpaused(address account);
1645 
1646     bool private _paused;
1647 
1648     /**
1649      * @dev Initializes the contract in unpaused state.
1650      */
1651     constructor() {
1652         _paused = false;
1653     }
1654 
1655     /**
1656      * @dev Returns true if the contract is paused, and false otherwise.
1657      */
1658     function paused() public view virtual returns (bool) {
1659         return _paused;
1660     }
1661 
1662     /**
1663      * @dev Modifier to make a function callable only when the contract is not paused.
1664      *
1665      * Requirements:
1666      *
1667      * - The contract must not be paused.
1668      */
1669     modifier whenNotPaused() {
1670         require(!paused(), "Pausable: paused");
1671         _;
1672     }
1673 
1674     /**
1675      * @dev Modifier to make a function callable only when the contract is paused.
1676      *
1677      * Requirements:
1678      *
1679      * - The contract must be paused.
1680      */
1681     modifier whenPaused() {
1682         require(paused(), "Pausable: not paused");
1683         _;
1684     }
1685 
1686     /**
1687      * @dev Triggers stopped state.
1688      *
1689      * Requirements:
1690      *
1691      * - The contract must not be paused.
1692      */
1693     function _pause() internal virtual whenNotPaused {
1694         _paused = true;
1695         emit Paused(_msgSender());
1696     }
1697 
1698     /**
1699      * @dev Returns to normal state.
1700      *
1701      * Requirements:
1702      *
1703      * - The contract must be paused.
1704      */
1705     function _unpause() internal virtual whenPaused {
1706         _paused = false;
1707         emit Unpaused(_msgSender());
1708     }
1709 }
1710 
1711 
1712 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1713 
1714 
1715 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1716 
1717 pragma solidity ^0.8.0;
1718 
1719 /**
1720  * @dev Contract module which provides a basic access control mechanism, where
1721  * there is an account (an owner) that can be granted exclusive access to
1722  * specific functions.
1723  *
1724  * By default, the owner account will be the one that deploys the contract. This
1725  * can later be changed with {transferOwnership}.
1726  *
1727  * This module is used through inheritance. It will make available the modifier
1728  * `onlyOwner`, which can be applied to your functions to restrict their use to
1729  * the owner.
1730  */
1731 abstract contract Ownable is Context {
1732     address private _owner;
1733 
1734     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1735 
1736     /**
1737      * @dev Initializes the contract setting the deployer as the initial owner.
1738      */
1739     constructor() {
1740         _transferOwnership(_msgSender());
1741     }
1742 
1743     /**
1744      * @dev Returns the address of the current owner.
1745      */
1746     function owner() public view virtual returns (address) {
1747         return _owner;
1748     }
1749 
1750     /**
1751      * @dev Throws if called by any account other than the owner.
1752      */
1753     modifier onlyOwner() {
1754         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1755         _;
1756     }
1757 
1758     /**
1759      * @dev Leaves the contract without owner. It will not be possible to call
1760      * `onlyOwner` functions anymore. Can only be called by the current owner.
1761      *
1762      * NOTE: Renouncing ownership will leave the contract without an owner,
1763      * thereby removing any functionality that is only available to the owner.
1764      */
1765     function renounceOwnership() public virtual onlyOwner {
1766         _transferOwnership(address(0));
1767     }
1768 
1769     /**
1770      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1771      * Can only be called by the current owner.
1772      */
1773     function transferOwnership(address newOwner) public virtual onlyOwner {
1774         require(newOwner != address(0), "Ownable: new owner is the zero address");
1775         _transferOwnership(newOwner);
1776     }
1777 
1778     /**
1779      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1780      * Internal function without access restriction.
1781      */
1782     function _transferOwnership(address newOwner) internal virtual {
1783         address oldOwner = _owner;
1784         _owner = newOwner;
1785         emit OwnershipTransferred(oldOwner, newOwner);
1786     }
1787 }
1788 
1789 
1790 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.6.0
1791 
1792 
1793 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1794 
1795 pragma solidity ^0.8.0;
1796 
1797 /**
1798  * @dev External interface of AccessControl declared to support ERC165 detection.
1799  */
1800 interface IAccessControl {
1801     /**
1802      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1803      *
1804      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1805      * {RoleAdminChanged} not being emitted signaling this.
1806      *
1807      * _Available since v3.1._
1808      */
1809     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1810 
1811     /**
1812      * @dev Emitted when `account` is granted `role`.
1813      *
1814      * `sender` is the account that originated the contract call, an admin role
1815      * bearer except when using {AccessControl-_setupRole}.
1816      */
1817     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1818 
1819     /**
1820      * @dev Emitted when `account` is revoked `role`.
1821      *
1822      * `sender` is the account that originated the contract call:
1823      *   - if using `revokeRole`, it is the admin role bearer
1824      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1825      */
1826     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1827 
1828     /**
1829      * @dev Returns `true` if `account` has been granted `role`.
1830      */
1831     function hasRole(bytes32 role, address account) external view returns (bool);
1832 
1833     /**
1834      * @dev Returns the admin role that controls `role`. See {grantRole} and
1835      * {revokeRole}.
1836      *
1837      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1838      */
1839     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1840 
1841     /**
1842      * @dev Grants `role` to `account`.
1843      *
1844      * If `account` had not been already granted `role`, emits a {RoleGranted}
1845      * event.
1846      *
1847      * Requirements:
1848      *
1849      * - the caller must have ``role``'s admin role.
1850      */
1851     function grantRole(bytes32 role, address account) external;
1852 
1853     /**
1854      * @dev Revokes `role` from `account`.
1855      *
1856      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1857      *
1858      * Requirements:
1859      *
1860      * - the caller must have ``role``'s admin role.
1861      */
1862     function revokeRole(bytes32 role, address account) external;
1863 
1864     /**
1865      * @dev Revokes `role` from the calling account.
1866      *
1867      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1868      * purpose is to provide a mechanism for accounts to lose their privileges
1869      * if they are compromised (such as when a trusted device is misplaced).
1870      *
1871      * If the calling account had been granted `role`, emits a {RoleRevoked}
1872      * event.
1873      *
1874      * Requirements:
1875      *
1876      * - the caller must be `account`.
1877      */
1878     function renounceRole(bytes32 role, address account) external;
1879 }
1880 
1881 
1882 // File @openzeppelin/contracts/access/IAccessControlEnumerable.sol@v4.6.0
1883 
1884 
1885 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
1886 
1887 pragma solidity ^0.8.0;
1888 
1889 /**
1890  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1891  */
1892 interface IAccessControlEnumerable is IAccessControl {
1893     /**
1894      * @dev Returns one of the accounts that have `role`. `index` must be a
1895      * value between 0 and {getRoleMemberCount}, non-inclusive.
1896      *
1897      * Role bearers are not sorted in any particular way, and their ordering may
1898      * change at any point.
1899      *
1900      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1901      * you perform all queries on the same block. See the following
1902      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1903      * for more information.
1904      */
1905     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1906 
1907     /**
1908      * @dev Returns the number of accounts that have `role`. Can be used
1909      * together with {getRoleMember} to enumerate all bearers of a role.
1910      */
1911     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1912 }
1913 
1914 
1915 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
1916 
1917 
1918 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1919 
1920 pragma solidity ^0.8.0;
1921 
1922 /**
1923  * @dev Implementation of the {IERC165} interface.
1924  *
1925  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1926  * for the additional interface id that will be supported. For example:
1927  *
1928  * ```solidity
1929  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1930  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1931  * }
1932  * ```
1933  *
1934  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1935  */
1936 abstract contract ERC165 is IERC165 {
1937     /**
1938      * @dev See {IERC165-supportsInterface}.
1939      */
1940     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1941         return interfaceId == type(IERC165).interfaceId;
1942     }
1943 }
1944 
1945 
1946 // File @openzeppelin/contracts/access/AccessControl.sol@v4.6.0
1947 
1948 
1949 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
1950 
1951 pragma solidity ^0.8.0;
1952 
1953 
1954 
1955 
1956 /**
1957  * @dev Contract module that allows children to implement role-based access
1958  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1959  * members except through off-chain means by accessing the contract event logs. Some
1960  * applications may benefit from on-chain enumerability, for those cases see
1961  * {AccessControlEnumerable}.
1962  *
1963  * Roles are referred to by their `bytes32` identifier. These should be exposed
1964  * in the external API and be unique. The best way to achieve this is by
1965  * using `public constant` hash digests:
1966  *
1967  * ```
1968  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1969  * ```
1970  *
1971  * Roles can be used to represent a set of permissions. To restrict access to a
1972  * function call, use {hasRole}:
1973  *
1974  * ```
1975  * function foo() public {
1976  *     require(hasRole(MY_ROLE, msg.sender));
1977  *     ...
1978  * }
1979  * ```
1980  *
1981  * Roles can be granted and revoked dynamically via the {grantRole} and
1982  * {revokeRole} functions. Each role has an associated admin role, and only
1983  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1984  *
1985  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1986  * that only accounts with this role will be able to grant or revoke other
1987  * roles. More complex role relationships can be created by using
1988  * {_setRoleAdmin}.
1989  *
1990  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1991  * grant and revoke this role. Extra precautions should be taken to secure
1992  * accounts that have been granted it.
1993  */
1994 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1995     struct RoleData {
1996         mapping(address => bool) members;
1997         bytes32 adminRole;
1998     }
1999 
2000     mapping(bytes32 => RoleData) private _roles;
2001 
2002     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2003 
2004     /**
2005      * @dev Modifier that checks that an account has a specific role. Reverts
2006      * with a standardized message including the required role.
2007      *
2008      * The format of the revert reason is given by the following regular expression:
2009      *
2010      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2011      *
2012      * _Available since v4.1._
2013      */
2014     modifier onlyRole(bytes32 role) {
2015         _checkRole(role);
2016         _;
2017     }
2018 
2019     /**
2020      * @dev See {IERC165-supportsInterface}.
2021      */
2022     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2023         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2024     }
2025 
2026     /**
2027      * @dev Returns `true` if `account` has been granted `role`.
2028      */
2029     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2030         return _roles[role].members[account];
2031     }
2032 
2033     /**
2034      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2035      * Overriding this function changes the behavior of the {onlyRole} modifier.
2036      *
2037      * Format of the revert message is described in {_checkRole}.
2038      *
2039      * _Available since v4.6._
2040      */
2041     function _checkRole(bytes32 role) internal view virtual {
2042         _checkRole(role, _msgSender());
2043     }
2044 
2045     /**
2046      * @dev Revert with a standard message if `account` is missing `role`.
2047      *
2048      * The format of the revert reason is given by the following regular expression:
2049      *
2050      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2051      */
2052     function _checkRole(bytes32 role, address account) internal view virtual {
2053         if (!hasRole(role, account)) {
2054             revert(
2055                 string(
2056                     abi.encodePacked(
2057                         "AccessControl: account ",
2058                         Strings.toHexString(uint160(account), 20),
2059                         " is missing role ",
2060                         Strings.toHexString(uint256(role), 32)
2061                     )
2062                 )
2063             );
2064         }
2065     }
2066 
2067     /**
2068      * @dev Returns the admin role that controls `role`. See {grantRole} and
2069      * {revokeRole}.
2070      *
2071      * To change a role's admin, use {_setRoleAdmin}.
2072      */
2073     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2074         return _roles[role].adminRole;
2075     }
2076 
2077     /**
2078      * @dev Grants `role` to `account`.
2079      *
2080      * If `account` had not been already granted `role`, emits a {RoleGranted}
2081      * event.
2082      *
2083      * Requirements:
2084      *
2085      * - the caller must have ``role``'s admin role.
2086      */
2087     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2088         _grantRole(role, account);
2089     }
2090 
2091     /**
2092      * @dev Revokes `role` from `account`.
2093      *
2094      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2095      *
2096      * Requirements:
2097      *
2098      * - the caller must have ``role``'s admin role.
2099      */
2100     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2101         _revokeRole(role, account);
2102     }
2103 
2104     /**
2105      * @dev Revokes `role` from the calling account.
2106      *
2107      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2108      * purpose is to provide a mechanism for accounts to lose their privileges
2109      * if they are compromised (such as when a trusted device is misplaced).
2110      *
2111      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2112      * event.
2113      *
2114      * Requirements:
2115      *
2116      * - the caller must be `account`.
2117      */
2118     function renounceRole(bytes32 role, address account) public virtual override {
2119         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2120 
2121         _revokeRole(role, account);
2122     }
2123 
2124     /**
2125      * @dev Grants `role` to `account`.
2126      *
2127      * If `account` had not been already granted `role`, emits a {RoleGranted}
2128      * event. Note that unlike {grantRole}, this function doesn't perform any
2129      * checks on the calling account.
2130      *
2131      * [WARNING]
2132      * ====
2133      * This function should only be called from the constructor when setting
2134      * up the initial roles for the system.
2135      *
2136      * Using this function in any other way is effectively circumventing the admin
2137      * system imposed by {AccessControl}.
2138      * ====
2139      *
2140      * NOTE: This function is deprecated in favor of {_grantRole}.
2141      */
2142     function _setupRole(bytes32 role, address account) internal virtual {
2143         _grantRole(role, account);
2144     }
2145 
2146     /**
2147      * @dev Sets `adminRole` as ``role``'s admin role.
2148      *
2149      * Emits a {RoleAdminChanged} event.
2150      */
2151     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2152         bytes32 previousAdminRole = getRoleAdmin(role);
2153         _roles[role].adminRole = adminRole;
2154         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2155     }
2156 
2157     /**
2158      * @dev Grants `role` to `account`.
2159      *
2160      * Internal function without access restriction.
2161      */
2162     function _grantRole(bytes32 role, address account) internal virtual {
2163         if (!hasRole(role, account)) {
2164             _roles[role].members[account] = true;
2165             emit RoleGranted(role, account, _msgSender());
2166         }
2167     }
2168 
2169     /**
2170      * @dev Revokes `role` from `account`.
2171      *
2172      * Internal function without access restriction.
2173      */
2174     function _revokeRole(bytes32 role, address account) internal virtual {
2175         if (hasRole(role, account)) {
2176             _roles[role].members[account] = false;
2177             emit RoleRevoked(role, account, _msgSender());
2178         }
2179     }
2180 }
2181 
2182 
2183 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.6.0
2184 
2185 
2186 // OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/EnumerableSet.sol)
2187 
2188 pragma solidity ^0.8.0;
2189 
2190 /**
2191  * @dev Library for managing
2192  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
2193  * types.
2194  *
2195  * Sets have the following properties:
2196  *
2197  * - Elements are added, removed, and checked for existence in constant time
2198  * (O(1)).
2199  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
2200  *
2201  * ```
2202  * contract Example {
2203  *     // Add the library methods
2204  *     using EnumerableSet for EnumerableSet.AddressSet;
2205  *
2206  *     // Declare a set state variable
2207  *     EnumerableSet.AddressSet private mySet;
2208  * }
2209  * ```
2210  *
2211  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
2212  * and `uint256` (`UintSet`) are supported.
2213  */
2214 library EnumerableSet {
2215     // To implement this library for multiple types with as little code
2216     // repetition as possible, we write it in terms of a generic Set type with
2217     // bytes32 values.
2218     // The Set implementation uses private functions, and user-facing
2219     // implementations (such as AddressSet) are just wrappers around the
2220     // underlying Set.
2221     // This means that we can only create new EnumerableSets for types that fit
2222     // in bytes32.
2223 
2224     struct Set {
2225         // Storage of set values
2226         bytes32[] _values;
2227         // Position of the value in the `values` array, plus 1 because index 0
2228         // means a value is not in the set.
2229         mapping(bytes32 => uint256) _indexes;
2230     }
2231 
2232     /**
2233      * @dev Add a value to a set. O(1).
2234      *
2235      * Returns true if the value was added to the set, that is if it was not
2236      * already present.
2237      */
2238     function _add(Set storage set, bytes32 value) private returns (bool) {
2239         if (!_contains(set, value)) {
2240             set._values.push(value);
2241             // The value is stored at length-1, but we add 1 to all indexes
2242             // and use 0 as a sentinel value
2243             set._indexes[value] = set._values.length;
2244             return true;
2245         } else {
2246             return false;
2247         }
2248     }
2249 
2250     /**
2251      * @dev Removes a value from a set. O(1).
2252      *
2253      * Returns true if the value was removed from the set, that is if it was
2254      * present.
2255      */
2256     function _remove(Set storage set, bytes32 value) private returns (bool) {
2257         // We read and store the value's index to prevent multiple reads from the same storage slot
2258         uint256 valueIndex = set._indexes[value];
2259 
2260         if (valueIndex != 0) {
2261             // Equivalent to contains(set, value)
2262             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
2263             // the array, and then remove the last element (sometimes called as 'swap and pop').
2264             // This modifies the order of the array, as noted in {at}.
2265 
2266             uint256 toDeleteIndex = valueIndex - 1;
2267             uint256 lastIndex = set._values.length - 1;
2268 
2269             if (lastIndex != toDeleteIndex) {
2270                 bytes32 lastValue = set._values[lastIndex];
2271 
2272                 // Move the last value to the index where the value to delete is
2273                 set._values[toDeleteIndex] = lastValue;
2274                 // Update the index for the moved value
2275                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
2276             }
2277 
2278             // Delete the slot where the moved value was stored
2279             set._values.pop();
2280 
2281             // Delete the index for the deleted slot
2282             delete set._indexes[value];
2283 
2284             return true;
2285         } else {
2286             return false;
2287         }
2288     }
2289 
2290     /**
2291      * @dev Returns true if the value is in the set. O(1).
2292      */
2293     function _contains(Set storage set, bytes32 value) private view returns (bool) {
2294         return set._indexes[value] != 0;
2295     }
2296 
2297     /**
2298      * @dev Returns the number of values on the set. O(1).
2299      */
2300     function _length(Set storage set) private view returns (uint256) {
2301         return set._values.length;
2302     }
2303 
2304     /**
2305      * @dev Returns the value stored at position `index` in the set. O(1).
2306      *
2307      * Note that there are no guarantees on the ordering of values inside the
2308      * array, and it may change when more values are added or removed.
2309      *
2310      * Requirements:
2311      *
2312      * - `index` must be strictly less than {length}.
2313      */
2314     function _at(Set storage set, uint256 index) private view returns (bytes32) {
2315         return set._values[index];
2316     }
2317 
2318     /**
2319      * @dev Return the entire set in an array
2320      *
2321      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2322      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2323      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2324      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2325      */
2326     function _values(Set storage set) private view returns (bytes32[] memory) {
2327         return set._values;
2328     }
2329 
2330     // Bytes32Set
2331 
2332     struct Bytes32Set {
2333         Set _inner;
2334     }
2335 
2336     /**
2337      * @dev Add a value to a set. O(1).
2338      *
2339      * Returns true if the value was added to the set, that is if it was not
2340      * already present.
2341      */
2342     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2343         return _add(set._inner, value);
2344     }
2345 
2346     /**
2347      * @dev Removes a value from a set. O(1).
2348      *
2349      * Returns true if the value was removed from the set, that is if it was
2350      * present.
2351      */
2352     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2353         return _remove(set._inner, value);
2354     }
2355 
2356     /**
2357      * @dev Returns true if the value is in the set. O(1).
2358      */
2359     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
2360         return _contains(set._inner, value);
2361     }
2362 
2363     /**
2364      * @dev Returns the number of values in the set. O(1).
2365      */
2366     function length(Bytes32Set storage set) internal view returns (uint256) {
2367         return _length(set._inner);
2368     }
2369 
2370     /**
2371      * @dev Returns the value stored at position `index` in the set. O(1).
2372      *
2373      * Note that there are no guarantees on the ordering of values inside the
2374      * array, and it may change when more values are added or removed.
2375      *
2376      * Requirements:
2377      *
2378      * - `index` must be strictly less than {length}.
2379      */
2380     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
2381         return _at(set._inner, index);
2382     }
2383 
2384     /**
2385      * @dev Return the entire set in an array
2386      *
2387      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2388      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2389      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2390      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2391      */
2392     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
2393         return _values(set._inner);
2394     }
2395 
2396     // AddressSet
2397 
2398     struct AddressSet {
2399         Set _inner;
2400     }
2401 
2402     /**
2403      * @dev Add a value to a set. O(1).
2404      *
2405      * Returns true if the value was added to the set, that is if it was not
2406      * already present.
2407      */
2408     function add(AddressSet storage set, address value) internal returns (bool) {
2409         return _add(set._inner, bytes32(uint256(uint160(value))));
2410     }
2411 
2412     /**
2413      * @dev Removes a value from a set. O(1).
2414      *
2415      * Returns true if the value was removed from the set, that is if it was
2416      * present.
2417      */
2418     function remove(AddressSet storage set, address value) internal returns (bool) {
2419         return _remove(set._inner, bytes32(uint256(uint160(value))));
2420     }
2421 
2422     /**
2423      * @dev Returns true if the value is in the set. O(1).
2424      */
2425     function contains(AddressSet storage set, address value) internal view returns (bool) {
2426         return _contains(set._inner, bytes32(uint256(uint160(value))));
2427     }
2428 
2429     /**
2430      * @dev Returns the number of values in the set. O(1).
2431      */
2432     function length(AddressSet storage set) internal view returns (uint256) {
2433         return _length(set._inner);
2434     }
2435 
2436     /**
2437      * @dev Returns the value stored at position `index` in the set. O(1).
2438      *
2439      * Note that there are no guarantees on the ordering of values inside the
2440      * array, and it may change when more values are added or removed.
2441      *
2442      * Requirements:
2443      *
2444      * - `index` must be strictly less than {length}.
2445      */
2446     function at(AddressSet storage set, uint256 index) internal view returns (address) {
2447         return address(uint160(uint256(_at(set._inner, index))));
2448     }
2449 
2450     /**
2451      * @dev Return the entire set in an array
2452      *
2453      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2454      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2455      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2456      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2457      */
2458     function values(AddressSet storage set) internal view returns (address[] memory) {
2459         bytes32[] memory store = _values(set._inner);
2460         address[] memory result;
2461 
2462         assembly {
2463             result := store
2464         }
2465 
2466         return result;
2467     }
2468 
2469     // UintSet
2470 
2471     struct UintSet {
2472         Set _inner;
2473     }
2474 
2475     /**
2476      * @dev Add a value to a set. O(1).
2477      *
2478      * Returns true if the value was added to the set, that is if it was not
2479      * already present.
2480      */
2481     function add(UintSet storage set, uint256 value) internal returns (bool) {
2482         return _add(set._inner, bytes32(value));
2483     }
2484 
2485     /**
2486      * @dev Removes a value from a set. O(1).
2487      *
2488      * Returns true if the value was removed from the set, that is if it was
2489      * present.
2490      */
2491     function remove(UintSet storage set, uint256 value) internal returns (bool) {
2492         return _remove(set._inner, bytes32(value));
2493     }
2494 
2495     /**
2496      * @dev Returns true if the value is in the set. O(1).
2497      */
2498     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
2499         return _contains(set._inner, bytes32(value));
2500     }
2501 
2502     /**
2503      * @dev Returns the number of values on the set. O(1).
2504      */
2505     function length(UintSet storage set) internal view returns (uint256) {
2506         return _length(set._inner);
2507     }
2508 
2509     /**
2510      * @dev Returns the value stored at position `index` in the set. O(1).
2511      *
2512      * Note that there are no guarantees on the ordering of values inside the
2513      * array, and it may change when more values are added or removed.
2514      *
2515      * Requirements:
2516      *
2517      * - `index` must be strictly less than {length}.
2518      */
2519     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
2520         return uint256(_at(set._inner, index));
2521     }
2522 
2523     /**
2524      * @dev Return the entire set in an array
2525      *
2526      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2527      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2528      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2529      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2530      */
2531     function values(UintSet storage set) internal view returns (uint256[] memory) {
2532         bytes32[] memory store = _values(set._inner);
2533         uint256[] memory result;
2534 
2535         assembly {
2536             result := store
2537         }
2538 
2539         return result;
2540     }
2541 }
2542 
2543 
2544 // File @openzeppelin/contracts/access/AccessControlEnumerable.sol@v4.6.0
2545 
2546 
2547 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
2548 
2549 pragma solidity ^0.8.0;
2550 
2551 
2552 
2553 /**
2554  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
2555  */
2556 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
2557     using EnumerableSet for EnumerableSet.AddressSet;
2558 
2559     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
2560 
2561     /**
2562      * @dev See {IERC165-supportsInterface}.
2563      */
2564     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2565         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
2566     }
2567 
2568     /**
2569      * @dev Returns one of the accounts that have `role`. `index` must be a
2570      * value between 0 and {getRoleMemberCount}, non-inclusive.
2571      *
2572      * Role bearers are not sorted in any particular way, and their ordering may
2573      * change at any point.
2574      *
2575      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2576      * you perform all queries on the same block. See the following
2577      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2578      * for more information.
2579      */
2580     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
2581         return _roleMembers[role].at(index);
2582     }
2583 
2584     /**
2585      * @dev Returns the number of accounts that have `role`. Can be used
2586      * together with {getRoleMember} to enumerate all bearers of a role.
2587      */
2588     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
2589         return _roleMembers[role].length();
2590     }
2591 
2592     /**
2593      * @dev Overload {_grantRole} to track enumerable memberships
2594      */
2595     function _grantRole(bytes32 role, address account) internal virtual override {
2596         super._grantRole(role, account);
2597         _roleMembers[role].add(account);
2598     }
2599 
2600     /**
2601      * @dev Overload {_revokeRole} to track enumerable memberships
2602      */
2603     function _revokeRole(bytes32 role, address account) internal virtual override {
2604         super._revokeRole(role, account);
2605         _roleMembers[role].remove(account);
2606     }
2607 }
2608 
2609 
2610 // File contracts/IFaceX.sol
2611 
2612 pragma solidity 0.8.13;
2613 
2614 interface IFaceX {
2615 
2616     function mintTo(address _to, uint256 _quantity) external;
2617 
2618 }
2619 
2620 
2621 // File contracts/FaceX.sol
2622 
2623 //SPDX-License-Identifier: UNLICENSED
2624 pragma solidity 0.8.13;
2625 
2626 
2627 
2628 
2629 
2630 
2631 
2632 contract FaceX is ERC721A, Ownable, AccessControlEnumerable, Pausable, IFaceX {
2633     using Strings for uint256;
2634     using ECDSA for bytes32;
2635 
2636     uint256 public constant MAX_SUPPLY = 4000;
2637 
2638     //Genral admin role, grants minter role to sale contract.
2639     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
2640     //Minter role, allowed to perform mints on this contract.
2641     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2642 
2643     //Base uri for metadatas, used only after reveal
2644     string public baseURI;
2645 
2646     //uri for metadatas pre-reveal
2647     string public notRevealedUri;
2648 
2649     //Indicates if NFTs have been revealed
2650     bool public revealed = false;
2651 
2652     constructor() ERC721A("FaceX", "FACEX") {
2653         _setRoleAdmin(MINTER_ROLE, ADMIN_ROLE); //Admin role manages minter role
2654 
2655         _grantRole(ADMIN_ROLE, msg.sender); //Initial admin is deployer
2656 
2657         _safeMint(msg.sender, 1); // To configure OpenSea
2658     }
2659 
2660     //Restrict function access to admin only
2661     modifier onlyAdmin() {
2662         require(
2663             hasRole(ADMIN_ROLE, msg.sender),
2664             "You are not allowed to perform this action."
2665         );
2666         _;
2667     }
2668 
2669     //Restrict function access to minter only
2670     modifier onlyMinter() {
2671         require(
2672             hasRole(MINTER_ROLE, msg.sender),
2673             "You are not allowed to perform this action."
2674         );
2675         _;
2676     }
2677 
2678     //Allows ADMIN_ROLE to be transfered
2679     function transferAdmin(address _to) external onlyAdmin {
2680         require(_to != address(0), "Can't put 0 address");
2681 
2682         _revokeRole(ADMIN_ROLE, msg.sender);
2683         _grantRole(ADMIN_ROLE, _to);
2684     }
2685 
2686     /**
2687      * @dev Use this function with an address that has been granted the minter role to mint tokens
2688      * @param _to the address that the tokens will be minted to
2689      * @param _quantity Quantity to mint
2690      */
2691     function mintTo(address _to, uint256 _quantity) external onlyMinter {
2692         require(totalSupply() + _quantity <= MAX_SUPPLY, "Max Supply Reached");
2693 
2694         _safeMint(_to, _quantity);
2695     }
2696 
2697     //Reveal the NFTs. Calling the function multiple time does not affect the metadatas
2698     function reveal() public onlyAdmin {
2699         revealed = true;
2700     }
2701 
2702     //Change the uri for pre-reveal
2703     function setNotRevealedURI(string memory _notRevealedURI) public onlyAdmin {
2704         notRevealedUri = _notRevealedURI;
2705     }
2706 
2707     //Change the uri post reveal
2708     function setBaseURI(string memory _newBaseURI) public onlyAdmin {
2709         baseURI = _newBaseURI;
2710     }
2711 
2712     /**
2713      * @dev This function override the base tokenURI function to manage the revealed state.
2714      * @dev When the NFTs are not revealed they all have the same URI. When they are revealed the URI is formed as : `baseURI/tokenId`
2715      *
2716      */
2717     function tokenURI(uint256 tokenId)
2718         public
2719         view
2720         override(ERC721A)
2721         returns (string memory)
2722     {
2723         if (revealed == false) {
2724             return notRevealedUri;
2725         }
2726 
2727         string memory currentBaseURI = baseURI;
2728         return
2729             bytes(currentBaseURI).length > 0
2730                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
2731                 : "";
2732     }
2733 
2734     /**
2735      * @dev Indicates that this contract supports both ERC721Metadata and AccessControlEnumerable interfaces
2736      */
2737     function supportsInterface(bytes4 interfaceId)
2738         public
2739         view
2740         virtual
2741         override(AccessControlEnumerable, ERC721A)
2742         returns (bool)
2743     {
2744         if (interfaceId == type(IAccessControlEnumerable).interfaceId) {
2745             return true;
2746         }
2747         if (interfaceId == type(IERC721Metadata).interfaceId) {
2748             return true;
2749         }
2750         return super.supportsInterface(interfaceId);
2751     }
2752 }