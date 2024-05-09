1 // File: contracts/3_Ballot.sol
2 
3 
4 /*
5 DAEMONS
6 */
7 
8 // ERC721A Contracts v3.3.0
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
266 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
267 
268 
269 // ERC721A Contracts v3.3.0
270 // Creator: Chiru Labs
271 
272 pragma solidity ^0.8.4;
273 
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
1084 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1085 
1086 
1087 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1088 
1089 pragma solidity ^0.8.0;
1090 
1091 /**
1092  * @dev String operations.
1093  */
1094 library Strings {
1095     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1096     uint8 private constant _ADDRESS_LENGTH = 20;
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
1153 
1154     /**
1155      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1156      */
1157     function toHexString(address addr) internal pure returns (string memory) {
1158         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1159     }
1160 }
1161 
1162 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1163 
1164 
1165 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 /**
1170  * @dev Provides information about the current execution context, including the
1171  * sender of the transaction and its data. While these are generally available
1172  * via msg.sender and msg.data, they should not be accessed in such a direct
1173  * manner, since when dealing with meta-transactions the account sending and
1174  * paying for execution may not be the actual sender (as far as an application
1175  * is concerned).
1176  *
1177  * This contract is only required for intermediate, library-like contracts.
1178  */
1179 abstract contract Context {
1180     function _msgSender() internal view virtual returns (address) {
1181         return msg.sender;
1182     }
1183 
1184     function _msgData() internal view virtual returns (bytes calldata) {
1185         return msg.data;
1186     }
1187 }
1188 
1189 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1190 
1191 
1192 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1193 
1194 pragma solidity ^0.8.0;
1195 
1196 
1197 /**
1198  * @dev Contract module which provides a basic access control mechanism, where
1199  * there is an account (an owner) that can be granted exclusive access to
1200  * specific functions.
1201  *
1202  * By default, the owner account will be the one that deploys the contract. This
1203  * can later be changed with {transferOwnership}.
1204  *
1205  * This module is used through inheritance. It will make available the modifier
1206  * `onlyOwner`, which can be applied to your functions to restrict their use to
1207  * the owner.
1208  */
1209 abstract contract Ownable is Context {
1210     address private _owner;
1211 
1212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1213 
1214     /**
1215      * @dev Initializes the contract setting the deployer as the initial owner.
1216      */
1217     constructor() {
1218         _transferOwnership(_msgSender());
1219     }
1220 
1221     /**
1222      * @dev Returns the address of the current owner.
1223      */
1224     function owner() public view virtual returns (address) {
1225         return _owner;
1226     }
1227 
1228     /**
1229      * @dev Throws if called by any account other than the owner.
1230      */
1231     modifier onlyOwner() {
1232         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1233         _;
1234     }
1235 
1236     /**
1237      * @dev Leaves the contract without owner. It will not be possible to call
1238      * `onlyOwner` functions anymore. Can only be called by the current owner.
1239      *
1240      * NOTE: Renouncing ownership will leave the contract without an owner,
1241      * thereby removing any functionality that is only available to the owner.
1242      */
1243     function renounceOwnership() public virtual onlyOwner {
1244         _transferOwnership(address(0));
1245     }
1246 
1247     /**
1248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1249      * Can only be called by the current owner.
1250      */
1251     function transferOwnership(address newOwner) public virtual onlyOwner {
1252         require(newOwner != address(0), "Ownable: new owner is the zero address");
1253         _transferOwnership(newOwner);
1254     }
1255 
1256     /**
1257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1258      * Internal function without access restriction.
1259      */
1260     function _transferOwnership(address newOwner) internal virtual {
1261         address oldOwner = _owner;
1262         _owner = newOwner;
1263         emit OwnershipTransferred(oldOwner, newOwner);
1264     }
1265 }
1266 
1267 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1268 
1269 
1270 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1271 
1272 pragma solidity ^0.8.1;
1273 
1274 /**
1275  * @dev Collection of functions related to the address type
1276  */
1277 library Address {
1278     /**
1279      * @dev Returns true if `account` is a contract.
1280      *
1281      * [IMPORTANT]
1282      * ====
1283      * It is unsafe to assume that an address for which this function returns
1284      * false is an externally-owned account (EOA) and not a contract.
1285      *
1286      * Among others, `isContract` will return false for the following
1287      * types of addresses:
1288      *
1289      *  - an externally-owned account
1290      *  - a contract in construction
1291      *  - an address where a contract will be created
1292      *  - an address where a contract lived, but was destroyed
1293      * ====
1294      *
1295      * [IMPORTANT]
1296      * ====
1297      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1298      *
1299      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1300      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1301      * constructor.
1302      * ====
1303      */
1304     function isContract(address account) internal view returns (bool) {
1305         // This method relies on extcodesize/address.code.length, which returns 0
1306         // for contracts in construction, since the code is only stored at the end
1307         // of the constructor execution.
1308 
1309         return account.code.length > 0;
1310     }
1311 
1312     /**
1313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1314      * `recipient`, forwarding all available gas and reverting on errors.
1315      *
1316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1318      * imposed by `transfer`, making them unable to receive funds via
1319      * `transfer`. {sendValue} removes this limitation.
1320      *
1321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1322      *
1323      * IMPORTANT: because control is transferred to `recipient`, care must be
1324      * taken to not create reentrancy vulnerabilities. Consider using
1325      * {ReentrancyGuard} or the
1326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1327      */
1328     function sendValue(address payable recipient, uint256 amount) internal {
1329         require(address(this).balance >= amount, "Address: insufficient balance");
1330 
1331         (bool success, ) = recipient.call{value: amount}("");
1332         require(success, "Address: unable to send value, recipient may have reverted");
1333     }
1334 
1335     /**
1336      * @dev Performs a Solidity function call using a low level `call`. A
1337      * plain `call` is an unsafe replacement for a function call: use this
1338      * function instead.
1339      *
1340      * If `target` reverts with a revert reason, it is bubbled up by this
1341      * function (like regular Solidity function calls).
1342      *
1343      * Returns the raw returned data. To convert to the expected return value,
1344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1345      *
1346      * Requirements:
1347      *
1348      * - `target` must be a contract.
1349      * - calling `target` with `data` must not revert.
1350      *
1351      * _Available since v3.1._
1352      */
1353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1354         return functionCall(target, data, "Address: low-level call failed");
1355     }
1356 
1357     /**
1358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1359      * `errorMessage` as a fallback revert reason when `target` reverts.
1360      *
1361      * _Available since v3.1._
1362      */
1363     function functionCall(
1364         address target,
1365         bytes memory data,
1366         string memory errorMessage
1367     ) internal returns (bytes memory) {
1368         return functionCallWithValue(target, data, 0, errorMessage);
1369     }
1370 
1371     /**
1372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1373      * but also transferring `value` wei to `target`.
1374      *
1375      * Requirements:
1376      *
1377      * - the calling contract must have an ETH balance of at least `value`.
1378      * - the called Solidity function must be `payable`.
1379      *
1380      * _Available since v3.1._
1381      */
1382     function functionCallWithValue(
1383         address target,
1384         bytes memory data,
1385         uint256 value
1386     ) internal returns (bytes memory) {
1387         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1388     }
1389 
1390     /**
1391      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1392      * with `errorMessage` as a fallback revert reason when `target` reverts.
1393      *
1394      * _Available since v3.1._
1395      */
1396     function functionCallWithValue(
1397         address target,
1398         bytes memory data,
1399         uint256 value,
1400         string memory errorMessage
1401     ) internal returns (bytes memory) {
1402         require(address(this).balance >= value, "Address: insufficient balance for call");
1403         require(isContract(target), "Address: call to non-contract");
1404 
1405         (bool success, bytes memory returndata) = target.call{value: value}(data);
1406         return verifyCallResult(success, returndata, errorMessage);
1407     }
1408 
1409     /**
1410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1411      * but performing a static call.
1412      *
1413      * _Available since v3.3._
1414      */
1415     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1416         return functionStaticCall(target, data, "Address: low-level static call failed");
1417     }
1418 
1419     /**
1420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1421      * but performing a static call.
1422      *
1423      * _Available since v3.3._
1424      */
1425     function functionStaticCall(
1426         address target,
1427         bytes memory data,
1428         string memory errorMessage
1429     ) internal view returns (bytes memory) {
1430         require(isContract(target), "Address: static call to non-contract");
1431 
1432         (bool success, bytes memory returndata) = target.staticcall(data);
1433         return verifyCallResult(success, returndata, errorMessage);
1434     }
1435 
1436     /**
1437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1438      * but performing a delegate call.
1439      *
1440      * _Available since v3.4._
1441      */
1442     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1443         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1444     }
1445 
1446     /**
1447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1448      * but performing a delegate call.
1449      *
1450      * _Available since v3.4._
1451      */
1452     function functionDelegateCall(
1453         address target,
1454         bytes memory data,
1455         string memory errorMessage
1456     ) internal returns (bytes memory) {
1457         require(isContract(target), "Address: delegate call to non-contract");
1458 
1459         (bool success, bytes memory returndata) = target.delegatecall(data);
1460         return verifyCallResult(success, returndata, errorMessage);
1461     }
1462 
1463     /**
1464      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1465      * revert reason using the provided one.
1466      *
1467      * _Available since v4.3._
1468      */
1469     function verifyCallResult(
1470         bool success,
1471         bytes memory returndata,
1472         string memory errorMessage
1473     ) internal pure returns (bytes memory) {
1474         if (success) {
1475             return returndata;
1476         } else {
1477             // Look for revert reason and bubble it up if present
1478             if (returndata.length > 0) {
1479                 // The easiest way to bubble the revert reason is using memory via assembly
1480 
1481                 assembly {
1482                     let returndata_size := mload(returndata)
1483                     revert(add(32, returndata), returndata_size)
1484                 }
1485             } else {
1486                 revert(errorMessage);
1487             }
1488         }
1489     }
1490 }
1491 
1492 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1493 
1494 
1495 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1496 
1497 pragma solidity ^0.8.0;
1498 
1499 /**
1500  * @title ERC721 token receiver interface
1501  * @dev Interface for any contract that wants to support safeTransfers
1502  * from ERC721 asset contracts.
1503  */
1504 interface IERC721Receiver {
1505     /**
1506      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1507      * by `operator` from `from`, this function is called.
1508      *
1509      * It must return its Solidity selector to confirm the token transfer.
1510      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1511      *
1512      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1513      */
1514     function onERC721Received(
1515         address operator,
1516         address from,
1517         uint256 tokenId,
1518         bytes calldata data
1519     ) external returns (bytes4);
1520 }
1521 
1522 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1523 
1524 
1525 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1526 
1527 pragma solidity ^0.8.0;
1528 
1529 /**
1530  * @dev Interface of the ERC165 standard, as defined in the
1531  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1532  *
1533  * Implementers can declare support of contract interfaces, which can then be
1534  * queried by others ({ERC165Checker}).
1535  *
1536  * For an implementation, see {ERC165}.
1537  */
1538 interface IERC165 {
1539     /**
1540      * @dev Returns true if this contract implements the interface defined by
1541      * `interfaceId`. See the corresponding
1542      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1543      * to learn more about how these ids are created.
1544      *
1545      * This function call must use less than 30 000 gas.
1546      */
1547     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1548 }
1549 
1550 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1551 
1552 
1553 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1554 
1555 pragma solidity ^0.8.0;
1556 
1557 
1558 /**
1559  * @dev Implementation of the {IERC165} interface.
1560  *
1561  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1562  * for the additional interface id that will be supported. For example:
1563  *
1564  * ```solidity
1565  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1566  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1567  * }
1568  * ```
1569  *
1570  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1571  */
1572 abstract contract ERC165 is IERC165 {
1573     /**
1574      * @dev See {IERC165-supportsInterface}.
1575      */
1576     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1577         return interfaceId == type(IERC165).interfaceId;
1578     }
1579 }
1580 
1581 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1582 
1583 
1584 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 
1589 /**
1590  * @dev Required interface of an ERC721 compliant contract.
1591  */
1592 interface IERC721 is IERC165 {
1593     /**
1594      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1595      */
1596     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1597 
1598     /**
1599      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1600      */
1601     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1602 
1603     /**
1604      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1605      */
1606     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1607 
1608     /**
1609      * @dev Returns the number of tokens in ``owner``'s account.
1610      */
1611     function balanceOf(address owner) external view returns (uint256 balance);
1612 
1613     /**
1614      * @dev Returns the owner of the `tokenId` token.
1615      *
1616      * Requirements:
1617      *
1618      * - `tokenId` must exist.
1619      */
1620     function ownerOf(uint256 tokenId) external view returns (address owner);
1621 
1622     /**
1623      * @dev Safely transfers `tokenId` token from `from` to `to`.
1624      *
1625      * Requirements:
1626      *
1627      * - `from` cannot be the zero address.
1628      * - `to` cannot be the zero address.
1629      * - `tokenId` token must exist and be owned by `from`.
1630      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1631      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1632      *
1633      * Emits a {Transfer} event.
1634      */
1635     function safeTransferFrom(
1636         address from,
1637         address to,
1638         uint256 tokenId,
1639         bytes calldata data
1640     ) external;
1641 
1642     /**
1643      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1644      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1645      *
1646      * Requirements:
1647      *
1648      * - `from` cannot be the zero address.
1649      * - `to` cannot be the zero address.
1650      * - `tokenId` token must exist and be owned by `from`.
1651      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1652      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1653      *
1654      * Emits a {Transfer} event.
1655      */
1656     function safeTransferFrom(
1657         address from,
1658         address to,
1659         uint256 tokenId
1660     ) external;
1661 
1662     /**
1663      * @dev Transfers `tokenId` token from `from` to `to`.
1664      *
1665      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1666      *
1667      * Requirements:
1668      *
1669      * - `from` cannot be the zero address.
1670      * - `to` cannot be the zero address.
1671      * - `tokenId` token must be owned by `from`.
1672      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1673      *
1674      * Emits a {Transfer} event.
1675      */
1676     function transferFrom(
1677         address from,
1678         address to,
1679         uint256 tokenId
1680     ) external;
1681 
1682     /**
1683      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1684      * The approval is cleared when the token is transferred.
1685      *
1686      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1687      *
1688      * Requirements:
1689      *
1690      * - The caller must own the token or be an approved operator.
1691      * - `tokenId` must exist.
1692      *
1693      * Emits an {Approval} event.
1694      */
1695     function approve(address to, uint256 tokenId) external;
1696 
1697     /**
1698      * @dev Approve or remove `operator` as an operator for the caller.
1699      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1700      *
1701      * Requirements:
1702      *
1703      * - The `operator` cannot be the caller.
1704      *
1705      * Emits an {ApprovalForAll} event.
1706      */
1707     function setApprovalForAll(address operator, bool _approved) external;
1708 
1709     /**
1710      * @dev Returns the account approved for `tokenId` token.
1711      *
1712      * Requirements:
1713      *
1714      * - `tokenId` must exist.
1715      */
1716     function getApproved(uint256 tokenId) external view returns (address operator);
1717 
1718     /**
1719      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1720      *
1721      * See {setApprovalForAll}
1722      */
1723     function isApprovedForAll(address owner, address operator) external view returns (bool);
1724 }
1725 
1726 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1727 
1728 
1729 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1730 
1731 pragma solidity ^0.8.0;
1732 
1733 
1734 /**
1735  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1736  * @dev See https://eips.ethereum.org/EIPS/eip-721
1737  */
1738 interface IERC721Metadata is IERC721 {
1739     /**
1740      * @dev Returns the token collection name.
1741      */
1742     function name() external view returns (string memory);
1743 
1744     /**
1745      * @dev Returns the token collection symbol.
1746      */
1747     function symbol() external view returns (string memory);
1748 
1749     /**
1750      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1751      */
1752     function tokenURI(uint256 tokenId) external view returns (string memory);
1753 }
1754 
1755 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1756 
1757 
1758 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1759 
1760 pragma solidity ^0.8.0;
1761 
1762 
1763 
1764 
1765 
1766 
1767 
1768 
1769 /**
1770  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1771  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1772  * {ERC721Enumerable}.
1773  */
1774 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1775     using Address for address;
1776     using Strings for uint256;
1777 
1778     // Token name
1779     string private _name;
1780 
1781     // Token symbol
1782     string private _symbol;
1783 
1784     // Mapping from token ID to owner address
1785     mapping(uint256 => address) private _owners;
1786 
1787     // Mapping owner address to token count
1788     mapping(address => uint256) private _balances;
1789 
1790     // Mapping from token ID to approved address
1791     mapping(uint256 => address) private _tokenApprovals;
1792 
1793     // Mapping from owner to operator approvals
1794     mapping(address => mapping(address => bool)) private _operatorApprovals;
1795 
1796     /**
1797      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1798      */
1799     constructor(string memory name_, string memory symbol_) {
1800         _name = name_;
1801         _symbol = symbol_;
1802     }
1803 
1804     /**
1805      * @dev See {IERC165-supportsInterface}.
1806      */
1807     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1808         return
1809             interfaceId == type(IERC721).interfaceId ||
1810             interfaceId == type(IERC721Metadata).interfaceId ||
1811             super.supportsInterface(interfaceId);
1812     }
1813 
1814     /**
1815      * @dev See {IERC721-balanceOf}.
1816      */
1817     function balanceOf(address owner) public view virtual override returns (uint256) {
1818         require(owner != address(0), "ERC721: address zero is not a valid owner");
1819         return _balances[owner];
1820     }
1821 
1822     /**
1823      * @dev See {IERC721-ownerOf}.
1824      */
1825     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1826         address owner = _owners[tokenId];
1827         require(owner != address(0), "ERC721: owner query for nonexistent token");
1828         return owner;
1829     }
1830 
1831     /**
1832      * @dev See {IERC721Metadata-name}.
1833      */
1834     function name() public view virtual override returns (string memory) {
1835         return _name;
1836     }
1837 
1838     /**
1839      * @dev See {IERC721Metadata-symbol}.
1840      */
1841     function symbol() public view virtual override returns (string memory) {
1842         return _symbol;
1843     }
1844 
1845     /**
1846      * @dev See {IERC721Metadata-tokenURI}.
1847      */
1848     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1849         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1850 
1851         string memory baseURI = _baseURI();
1852         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1853     }
1854 
1855     /**
1856      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1857      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1858      * by default, can be overridden in child contracts.
1859      */
1860     function _baseURI() internal view virtual returns (string memory) {
1861         return "";
1862     }
1863 
1864     /**
1865      * @dev See {IERC721-approve}.
1866      */
1867     function approve(address to, uint256 tokenId) public virtual override {
1868         address owner = ERC721.ownerOf(tokenId);
1869         require(to != owner, "ERC721: approval to current owner");
1870 
1871         require(
1872             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1873             "ERC721: approve caller is not owner nor approved for all"
1874         );
1875 
1876         _approve(to, tokenId);
1877     }
1878 
1879     /**
1880      * @dev See {IERC721-getApproved}.
1881      */
1882     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1883         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1884 
1885         return _tokenApprovals[tokenId];
1886     }
1887 
1888     /**
1889      * @dev See {IERC721-setApprovalForAll}.
1890      */
1891     function setApprovalForAll(address operator, bool approved) public virtual override {
1892         _setApprovalForAll(_msgSender(), operator, approved);
1893     }
1894 
1895     /**
1896      * @dev See {IERC721-isApprovedForAll}.
1897      */
1898     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1899         return _operatorApprovals[owner][operator];
1900     }
1901 
1902     /**
1903      * @dev See {IERC721-transferFrom}.
1904      */
1905     function transferFrom(
1906         address from,
1907         address to,
1908         uint256 tokenId
1909     ) public virtual override {
1910         //solhint-disable-next-line max-line-length
1911         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1912 
1913         _transfer(from, to, tokenId);
1914     }
1915 
1916     /**
1917      * @dev See {IERC721-safeTransferFrom}.
1918      */
1919     function safeTransferFrom(
1920         address from,
1921         address to,
1922         uint256 tokenId
1923     ) public virtual override {
1924         safeTransferFrom(from, to, tokenId, "");
1925     }
1926 
1927     /**
1928      * @dev See {IERC721-safeTransferFrom}.
1929      */
1930     function safeTransferFrom(
1931         address from,
1932         address to,
1933         uint256 tokenId,
1934         bytes memory data
1935     ) public virtual override {
1936         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1937         _safeTransfer(from, to, tokenId, data);
1938     }
1939 
1940     /**
1941      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1942      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1943      *
1944      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1945      *
1946      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1947      * implement alternative mechanisms to perform token transfer, such as signature-based.
1948      *
1949      * Requirements:
1950      *
1951      * - `from` cannot be the zero address.
1952      * - `to` cannot be the zero address.
1953      * - `tokenId` token must exist and be owned by `from`.
1954      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1955      *
1956      * Emits a {Transfer} event.
1957      */
1958     function _safeTransfer(
1959         address from,
1960         address to,
1961         uint256 tokenId,
1962         bytes memory data
1963     ) internal virtual {
1964         _transfer(from, to, tokenId);
1965         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1966     }
1967 
1968     /**
1969      * @dev Returns whether `tokenId` exists.
1970      *
1971      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1972      *
1973      * Tokens start existing when they are minted (`_mint`),
1974      * and stop existing when they are burned (`_burn`).
1975      */
1976     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1977         return _owners[tokenId] != address(0);
1978     }
1979 
1980     /**
1981      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1982      *
1983      * Requirements:
1984      *
1985      * - `tokenId` must exist.
1986      */
1987     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1988         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1989         address owner = ERC721.ownerOf(tokenId);
1990         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1991     }
1992 
1993     /**
1994      * @dev Safely mints `tokenId` and transfers it to `to`.
1995      *
1996      * Requirements:
1997      *
1998      * - `tokenId` must not exist.
1999      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2000      *
2001      * Emits a {Transfer} event.
2002      */
2003     function _safeMint(address to, uint256 tokenId) internal virtual {
2004         _safeMint(to, tokenId, "");
2005     }
2006 
2007     /**
2008      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2009      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2010      */
2011     function _safeMint(
2012         address to,
2013         uint256 tokenId,
2014         bytes memory data
2015     ) internal virtual {
2016         _mint(to, tokenId);
2017         require(
2018             _checkOnERC721Received(address(0), to, tokenId, data),
2019             "ERC721: transfer to non ERC721Receiver implementer"
2020         );
2021     }
2022 
2023     /**
2024      * @dev Mints `tokenId` and transfers it to `to`.
2025      *
2026      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2027      *
2028      * Requirements:
2029      *
2030      * - `tokenId` must not exist.
2031      * - `to` cannot be the zero address.
2032      *
2033      * Emits a {Transfer} event.
2034      */
2035     function _mint(address to, uint256 tokenId) internal virtual {
2036         require(to != address(0), "ERC721: mint to the zero address");
2037         require(!_exists(tokenId), "ERC721: token already minted");
2038 
2039         _beforeTokenTransfer(address(0), to, tokenId);
2040 
2041         _balances[to] += 1;
2042         _owners[tokenId] = to;
2043 
2044         emit Transfer(address(0), to, tokenId);
2045 
2046         _afterTokenTransfer(address(0), to, tokenId);
2047     }
2048 
2049     /**
2050      * @dev Destroys `tokenId`.
2051      * The approval is cleared when the token is burned.
2052      *
2053      * Requirements:
2054      *
2055      * - `tokenId` must exist.
2056      *
2057      * Emits a {Transfer} event.
2058      */
2059     function _burn(uint256 tokenId) internal virtual {
2060         address owner = ERC721.ownerOf(tokenId);
2061 
2062         _beforeTokenTransfer(owner, address(0), tokenId);
2063 
2064         // Clear approvals
2065         _approve(address(0), tokenId);
2066 
2067         _balances[owner] -= 1;
2068         delete _owners[tokenId];
2069 
2070         emit Transfer(owner, address(0), tokenId);
2071 
2072         _afterTokenTransfer(owner, address(0), tokenId);
2073     }
2074 
2075     /**
2076      * @dev Transfers `tokenId` from `from` to `to`.
2077      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2078      *
2079      * Requirements:
2080      *
2081      * - `to` cannot be the zero address.
2082      * - `tokenId` token must be owned by `from`.
2083      *
2084      * Emits a {Transfer} event.
2085      */
2086     function _transfer(
2087         address from,
2088         address to,
2089         uint256 tokenId
2090     ) internal virtual {
2091         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2092         require(to != address(0), "ERC721: transfer to the zero address");
2093 
2094         _beforeTokenTransfer(from, to, tokenId);
2095 
2096         // Clear approvals from the previous owner
2097         _approve(address(0), tokenId);
2098 
2099         _balances[from] -= 1;
2100         _balances[to] += 1;
2101         _owners[tokenId] = to;
2102 
2103         emit Transfer(from, to, tokenId);
2104 
2105         _afterTokenTransfer(from, to, tokenId);
2106     }
2107 
2108     /**
2109      * @dev Approve `to` to operate on `tokenId`
2110      *
2111      * Emits an {Approval} event.
2112      */
2113     function _approve(address to, uint256 tokenId) internal virtual {
2114         _tokenApprovals[tokenId] = to;
2115         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2116     }
2117 
2118     /**
2119      * @dev Approve `operator` to operate on all of `owner` tokens
2120      *
2121      * Emits an {ApprovalForAll} event.
2122      */
2123     function _setApprovalForAll(
2124         address owner,
2125         address operator,
2126         bool approved
2127     ) internal virtual {
2128         require(owner != operator, "ERC721: approve to caller");
2129         _operatorApprovals[owner][operator] = approved;
2130         emit ApprovalForAll(owner, operator, approved);
2131     }
2132 
2133     /**
2134      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2135      * The call is not executed if the target address is not a contract.
2136      *
2137      * @param from address representing the previous owner of the given token ID
2138      * @param to target address that will receive the tokens
2139      * @param tokenId uint256 ID of the token to be transferred
2140      * @param data bytes optional data to send along with the call
2141      * @return bool whether the call correctly returned the expected magic value
2142      */
2143     function _checkOnERC721Received(
2144         address from,
2145         address to,
2146         uint256 tokenId,
2147         bytes memory data
2148     ) private returns (bool) {
2149         if (to.isContract()) {
2150             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2151                 return retval == IERC721Receiver.onERC721Received.selector;
2152             } catch (bytes memory reason) {
2153                 if (reason.length == 0) {
2154                     revert("ERC721: transfer to non ERC721Receiver implementer");
2155                 } else {
2156                     assembly {
2157                         revert(add(32, reason), mload(reason))
2158                     }
2159                 }
2160             }
2161         } else {
2162             return true;
2163         }
2164     }
2165 
2166     /**
2167      * @dev Hook that is called before any token transfer. This includes minting
2168      * and burning.
2169      *
2170      * Calling conditions:
2171      *
2172      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2173      * transferred to `to`.
2174      * - When `from` is zero, `tokenId` will be minted for `to`.
2175      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2176      * - `from` and `to` are never both zero.
2177      *
2178      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2179      */
2180     function _beforeTokenTransfer(
2181         address from,
2182         address to,
2183         uint256 tokenId
2184     ) internal virtual {}
2185 
2186     /**
2187      * @dev Hook that is called after any transfer of tokens. This includes
2188      * minting and burning.
2189      *
2190      * Calling conditions:
2191      *
2192      * - when `from` and `to` are both non-zero.
2193      * - `from` and `to` are never both zero.
2194      *
2195      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2196      */
2197     function _afterTokenTransfer(
2198         address from,
2199         address to,
2200         uint256 tokenId
2201     ) internal virtual {}
2202 }
2203 
2204 
2205 
2206 
2207 pragma solidity ^0.8.0;
2208 
2209 
2210 
2211 
2212 contract daemones is ERC721A, Ownable {
2213     using Strings for uint256;
2214 
2215     string private baseURI;
2216 
2217     uint256 public price = 0.0033 ether;
2218 
2219     uint256 public maxPerTx = 3;
2220 
2221     uint256 public maxFreePerWallet = 0;
2222 
2223     uint256 public totalFree = 0;
2224 
2225     uint256 public maxSupply = 3333;
2226 
2227     bool public mintEnabled = false;
2228 
2229     mapping(address => uint256) private _mintedFreeAmount;
2230 
2231     constructor() ERC721A("daemones", "DMNS") {
2232         _safeMint(msg.sender, 25);
2233         setBaseURI("ipfs://QmPGQDCcfTzAhJMsV6FbTySzEic2rBS9nmaZ85va4oY6bt/");
2234     }
2235 
2236     function mint(uint256 count) external payable {
2237         uint256 cost = price;
2238         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2239             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2240 
2241         if (isFree) {
2242             cost = 0;
2243         }
2244 
2245         require(msg.value >= count * cost, "Please send the exact amount.");
2246         require(totalSupply() + count < maxSupply + 1, "No more");
2247         require(mintEnabled, "Minting is not live yet");
2248         require(count < maxPerTx + 1, "Max per TX reached.");
2249 
2250         if (isFree) {
2251             _mintedFreeAmount[msg.sender] += count;
2252         }
2253 
2254         _safeMint(msg.sender, count);
2255     }
2256 
2257     function _baseURI() internal view virtual override returns (string memory) {
2258         return baseURI;
2259     }
2260 
2261     function tokenURI(uint256 tokenId)
2262         public
2263         view
2264         virtual
2265         override
2266         returns (string memory)
2267     {
2268         require(
2269             _exists(tokenId),
2270             "ERC721Metadata: URI query for nonexistent token"
2271         );
2272         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2273     }
2274 
2275     function setBaseURI(string memory uri) public onlyOwner {
2276         baseURI = uri;
2277     }
2278 
2279     function setFreeAmount(uint256 amount) external onlyOwner {
2280         totalFree = amount;
2281     }
2282 
2283     function setPrice(uint256 _newPrice) external onlyOwner {
2284         price = _newPrice;
2285     }
2286 
2287     function flipSale() external onlyOwner {
2288         mintEnabled = !mintEnabled;
2289     }
2290 
2291     function withdraw() external onlyOwner {
2292         (bool success, ) = payable(msg.sender).call{
2293             value: address(this).balance
2294         }("");
2295         require(success, "Transfer failed.");
2296     }
2297 }