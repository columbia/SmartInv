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
1085 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
1086 
1087 
1088 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1089 
1090 pragma solidity ^0.8.0;
1091 
1092 /**
1093  * @dev Provides information about the current execution context, including the
1094  * sender of the transaction and its data. While these are generally available
1095  * via msg.sender and msg.data, they should not be accessed in such a direct
1096  * manner, since when dealing with meta-transactions the account sending and
1097  * paying for execution may not be the actual sender (as far as an application
1098  * is concerned).
1099  *
1100  * This contract is only required for intermediate, library-like contracts.
1101  */
1102 abstract contract Context {
1103     function _msgSender() internal view virtual returns (address) {
1104         return msg.sender;
1105     }
1106 
1107     function _msgData() internal view virtual returns (bytes calldata) {
1108         return msg.data;
1109     }
1110 }
1111 
1112 
1113 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1114 
1115 
1116 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 /**
1121  * @dev Contract module which provides a basic access control mechanism, where
1122  * there is an account (an owner) that can be granted exclusive access to
1123  * specific functions.
1124  *
1125  * By default, the owner account will be the one that deploys the contract. This
1126  * can later be changed with {transferOwnership}.
1127  *
1128  * This module is used through inheritance. It will make available the modifier
1129  * `onlyOwner`, which can be applied to your functions to restrict their use to
1130  * the owner.
1131  */
1132 abstract contract Ownable is Context {
1133     address private _owner;
1134 
1135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1136 
1137     /**
1138      * @dev Initializes the contract setting the deployer as the initial owner.
1139      */
1140     constructor() {
1141         _transferOwnership(_msgSender());
1142     }
1143 
1144     /**
1145      * @dev Returns the address of the current owner.
1146      */
1147     function owner() public view virtual returns (address) {
1148         return _owner;
1149     }
1150 
1151     /**
1152      * @dev Throws if called by any account other than the owner.
1153      */
1154     modifier onlyOwner() {
1155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1156         _;
1157     }
1158 
1159     /**
1160      * @dev Leaves the contract without owner. It will not be possible to call
1161      * `onlyOwner` functions anymore. Can only be called by the current owner.
1162      *
1163      * NOTE: Renouncing ownership will leave the contract without an owner,
1164      * thereby removing any functionality that is only available to the owner.
1165      */
1166     function renounceOwnership() public virtual onlyOwner {
1167         _transferOwnership(address(0));
1168     }
1169 
1170     /**
1171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1172      * Can only be called by the current owner.
1173      */
1174     function transferOwnership(address newOwner) public virtual onlyOwner {
1175         require(newOwner != address(0), "Ownable: new owner is the zero address");
1176         _transferOwnership(newOwner);
1177     }
1178 
1179     /**
1180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1181      * Internal function without access restriction.
1182      */
1183     function _transferOwnership(address newOwner) internal virtual {
1184         address oldOwner = _owner;
1185         _owner = newOwner;
1186         emit OwnershipTransferred(oldOwner, newOwner);
1187     }
1188 }
1189 
1190 
1191 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.6.0
1192 
1193 
1194 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1195 
1196 pragma solidity ^0.8.0;
1197 
1198 /**
1199  * @dev These functions deal with verification of Merkle Trees proofs.
1200  *
1201  * The proofs can be generated using the JavaScript library
1202  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1203  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1204  *
1205  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1206  *
1207  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1208  * hashing, or use a hash function other than keccak256 for hashing leaves.
1209  * This is because the concatenation of a sorted pair of internal nodes in
1210  * the merkle tree could be reinterpreted as a leaf value.
1211  */
1212 library MerkleProof {
1213     /**
1214      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1215      * defined by `root`. For this, a `proof` must be provided, containing
1216      * sibling hashes on the branch from the leaf to the root of the tree. Each
1217      * pair of leaves and each pair of pre-images are assumed to be sorted.
1218      */
1219     function verify(
1220         bytes32[] memory proof,
1221         bytes32 root,
1222         bytes32 leaf
1223     ) internal pure returns (bool) {
1224         return processProof(proof, leaf) == root;
1225     }
1226 
1227     /**
1228      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1229      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1230      * hash matches the root of the tree. When processing the proof, the pairs
1231      * of leafs & pre-images are assumed to be sorted.
1232      *
1233      * _Available since v4.4._
1234      */
1235     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1236         bytes32 computedHash = leaf;
1237         for (uint256 i = 0; i < proof.length; i++) {
1238             bytes32 proofElement = proof[i];
1239             if (computedHash <= proofElement) {
1240                 // Hash(current computed hash + current element of the proof)
1241                 computedHash = _efficientHash(computedHash, proofElement);
1242             } else {
1243                 // Hash(current element of the proof + current computed hash)
1244                 computedHash = _efficientHash(proofElement, computedHash);
1245             }
1246         }
1247         return computedHash;
1248     }
1249 
1250     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1251         assembly {
1252             mstore(0x00, a)
1253             mstore(0x20, b)
1254             value := keccak256(0x00, 0x40)
1255         }
1256     }
1257 }
1258 
1259 
1260 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
1261 
1262 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1263 
1264 pragma solidity ^0.8.0;
1265 
1266 /**
1267  * @dev String operations.
1268  */
1269 library Strings {
1270     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1271 
1272     /**
1273      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1274      */
1275     function toString(uint256 value) internal pure returns (string memory) {
1276         // Inspired by OraclizeAPI's implementation - MIT licence
1277         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1278 
1279         if (value == 0) {
1280             return "0";
1281         }
1282         uint256 temp = value;
1283         uint256 digits;
1284         while (temp != 0) {
1285             digits++;
1286             temp /= 10;
1287         }
1288         bytes memory buffer = new bytes(digits);
1289         while (value != 0) {
1290             digits -= 1;
1291             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1292             value /= 10;
1293         }
1294         return string(buffer);
1295     }
1296 
1297     /**
1298      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1299      */
1300     function toHexString(uint256 value) internal pure returns (string memory) {
1301         if (value == 0) {
1302             return "0x00";
1303         }
1304         uint256 temp = value;
1305         uint256 length = 0;
1306         while (temp != 0) {
1307             length++;
1308             temp >>= 8;
1309         }
1310         return toHexString(value, length);
1311     }
1312 
1313     /**
1314      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1315      */
1316     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1317         bytes memory buffer = new bytes(2 * length + 2);
1318         buffer[0] = "0";
1319         buffer[1] = "x";
1320         for (uint256 i = 2 * length + 1; i > 1; --i) {
1321             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1322             value >>= 4;
1323         }
1324         require(value == 0, "Strings: hex length insufficient");
1325         return string(buffer);
1326     }
1327 }
1328 
1329 
1330 // File contracts/OmegaOrc.sol
1331 
1332 /// SPDX-License-Identifier: MIT
1333 
1334 pragma solidity 0.8.7;
1335 
1336 contract OmegaOrc is ERC721A, Ownable {
1337     using Strings for uint256;
1338 
1339     string public baseURI;
1340     uint256 public constant maxPerOne = 1;
1341     uint256 public constant maxPerTwo = 2;
1342     uint256 public constant maxPerThree = 3;
1343     uint256 public constant orcSupply = 1333;
1344 
1345     bytes32 public merkleRootOne =
1346         0x8db2bf88bb01c9d0b09241ccee6cfab3560a4c732b4c34f0ede66c503992e127;
1347     bytes32 public merkleRootTwo =
1348         0x425d1bb1828566451fe5f0484ea32aff160a0e6d6e3715cad35e09d0436e645a;
1349     bytes32 public merkleRootThree =
1350         0xad54200330683c1b0fe4f3c9131fbbbf17489cfd77c8debe3f32fc0b4078a5ac;
1351     bytes32 public merkleRootFinal =
1352         0x72e5fdfab6e99537eedc6913b42da7585f2268574624ac938dc2c3f1ae07f5cf;
1353 
1354     
1355     bool public publicOpen = false;
1356     bool public burnOpen = false;
1357 
1358     mapping(address => uint256) mintedOne;
1359     mapping(address => uint256) mintedTwo;
1360     mapping(address => uint256) mintedThree;
1361     mapping(address => uint256) mintedFinal;
1362 
1363     mapping(address => uint256) mintedPublic;
1364 
1365     modifier onlySender() {
1366         require(msg.sender == tx.origin);
1367         _;
1368     }
1369     modifier isPublicOpen() {
1370         require(publicOpen == true);
1371         _;
1372     }
1373     modifier isBurnOpen() {
1374         require(burnOpen == true);
1375         _;
1376     }
1377 
1378     
1379 
1380     constructor(string memory _initBaseURI) ERC721A("Omega Orc", "OORC") {
1381         setBaseURI(_initBaseURI);
1382         _mint(msg.sender, 10);
1383     }
1384 
1385     function publicMint() public payable isPublicOpen onlySender {
1386         require(mintedPublic[msg.sender] < maxPerOne);
1387         require(totalSupply() + maxPerOne <= orcSupply);
1388 
1389         mintedPublic[msg.sender] += maxPerOne;
1390         _mint(msg.sender, maxPerOne);
1391     }
1392 
1393     function finalMint(bytes32[] calldata _merkleProof)
1394         public
1395         payable
1396         onlySender
1397     {
1398         require(mintedFinal[msg.sender] < maxPerOne);
1399         require(totalSupply() + maxPerOne <= orcSupply);
1400 
1401         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1402         require(
1403             MerkleProof.verify(_merkleProof, merkleRootFinal, leaf),
1404             "Invalid proof."
1405         );
1406 
1407         mintedFinal[msg.sender] += maxPerOne;
1408         _mint(msg.sender, maxPerOne);
1409     }
1410 
1411     function oneMint(bytes32[] calldata _merkleProof)
1412         public
1413         payable
1414         onlySender
1415     {
1416         require(mintedOne[msg.sender] < maxPerOne);
1417         require(totalSupply() + maxPerOne <= orcSupply);
1418 
1419         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1420         require(
1421             MerkleProof.verify(_merkleProof, merkleRootOne, leaf),
1422             "Invalid proof."
1423         );
1424 
1425         mintedOne[msg.sender] += maxPerOne;
1426         _mint(msg.sender, maxPerOne);
1427     }
1428 
1429     function twoMint(bytes32[] calldata _merkleProof)
1430         public
1431         payable
1432         onlySender
1433     {
1434         require(mintedTwo[msg.sender] < maxPerTwo);
1435         require(totalSupply() + maxPerTwo <= orcSupply);
1436 
1437         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1438         require(
1439             MerkleProof.verify(_merkleProof, merkleRootTwo, leaf),
1440             "Invalid proof."
1441         );
1442 
1443         mintedTwo[msg.sender] += maxPerTwo;
1444         _mint(msg.sender, maxPerTwo);
1445     }
1446 
1447     function threeMint(bytes32[] calldata _merkleProof)
1448         public
1449         payable
1450         onlySender
1451     {
1452         require(mintedThree[msg.sender] < maxPerThree);
1453         require(totalSupply() + maxPerThree <= orcSupply);
1454 
1455         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1456         require(
1457             MerkleProof.verify(_merkleProof, merkleRootThree, leaf),
1458             "Invalid proof."
1459         );
1460 
1461         mintedThree[msg.sender] += maxPerThree;
1462         _mint(msg.sender, maxPerThree);
1463     }
1464 
1465     function changeMerkleOne(bytes32 incoming) public onlyOwner {
1466         merkleRootOne = incoming;
1467     }
1468 
1469     function changeMerkleTwo(bytes32 incoming) public onlyOwner {
1470         merkleRootTwo = incoming;
1471     }
1472 
1473     function changeMerkleThree(bytes32 incoming) public onlyOwner {
1474         merkleRootThree = incoming;
1475     }
1476 
1477     function changeMerkleFinal(bytes32 incoming) public onlyOwner {
1478         merkleRootFinal = incoming;
1479     }
1480 
1481     function flipPublic() public onlyOwner
1482     {
1483         publicOpen = !publicOpen;
1484     }
1485 
1486     function flipBurn() public onlyOwner
1487     {
1488         burnOpen = !burnOpen;
1489     }
1490 
1491     function burnOrc(uint256 tokenID) public isBurnOpen
1492     {
1493         _burn(tokenID);
1494     }
1495 
1496     function burnOrcs(uint256[] memory tokenIDs) public isBurnOpen
1497     {
1498         for(uint256 i=0; i<tokenIDs.length; i++)
1499         {
1500             _burn(tokenIDs[i]);
1501         }
1502     }
1503 
1504     function withdrawEther() external onlyOwner {
1505         (bool hs, ) = payable(msg.sender).call{value: address(this).balance}(
1506             ""
1507         );
1508         require(hs);
1509     }
1510 
1511     function _baseURI() internal view virtual override returns (string memory) {
1512         return baseURI;
1513     }
1514 
1515     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1516         baseURI = _newBaseURI;
1517     }
1518 
1519     function tokenURI(uint256 tokenId)
1520         public
1521         view
1522         virtual
1523         override
1524         returns (string memory)
1525     {
1526         require(
1527             _exists(tokenId),
1528             "ERC721AMetadata: URI query for nonexistent token"
1529         );
1530         string memory currentBaseURI = _baseURI();
1531         return
1532             bytes(currentBaseURI).length > 0
1533                 ? string(
1534                     abi.encodePacked(
1535                         currentBaseURI,
1536                         tokenId.toString(),
1537                         ".json"
1538                     )
1539                 )
1540                 : "";
1541     }
1542 
1543     function getBalance() public view returns (uint256) {
1544         return address(this).balance;
1545     }
1546 
1547     function walletOfOwner(address address_)
1548         public
1549         view
1550         virtual
1551         returns (uint256[] memory)
1552     {
1553         uint256 _balance = balanceOf(address_);
1554         uint256[] memory _tokens = new uint256[](_balance);
1555         uint256 _index;
1556         uint256 _loopThrough = totalSupply();
1557         for (uint256 i = 0; i < _loopThrough; i++) {
1558             bool _exists = _exists(i);
1559             if (_exists) {
1560                 if (ownerOf(i) == address_) {
1561                     _tokens[_index] = i;
1562                     _index++;
1563                 }
1564             } else if (!_exists && _tokens[_balance - 1] == 0) {
1565                 _loopThrough++;
1566             }
1567         }
1568         return _tokens;
1569     }
1570 }