1 // File: Beings/IERC721A.sol
2 
3 
4 // ERC721A Contracts v4.1.0
5 // Creator: Chiru Labs
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10  * @dev Interface of an ERC721A compliant contract.
11  */
12 interface IERC721A {
13     /**
14      * The caller must own the token or be an approved operator.
15      */
16     error ApprovalCallerNotOwnerNorApproved();
17 
18     /**
19      * The token does not exist.
20      */
21     error ApprovalQueryForNonexistentToken();
22 
23     /**
24      * The caller cannot approve to their own address.
25      */
26     error ApproveToCaller();
27 
28     /**
29      * Cannot query the balance for the zero address.
30      */
31     error BalanceQueryForZeroAddress();
32 
33     /**
34      * Cannot mint to the zero address.
35      */
36     error MintToZeroAddress();
37 
38     /**
39      * The quantity of tokens minted must be more than zero.
40      */
41     error MintZeroQuantity();
42 
43     /**
44      * The token does not exist.
45      */
46     error OwnerQueryForNonexistentToken();
47 
48     /**
49      * The caller must own the token or be an approved operator.
50      */
51     error TransferCallerNotOwnerNorApproved();
52 
53     /**
54      * The token must be owned by `from`.
55      */
56     error TransferFromIncorrectOwner();
57 
58     /**
59      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
60      */
61     error TransferToNonERC721ReceiverImplementer();
62 
63     /**
64      * Cannot transfer to the zero address.
65      */
66     error TransferToZeroAddress();
67 
68     /**
69      * The token does not exist.
70      */
71     error URIQueryForNonexistentToken();
72 
73     /**
74      * The `quantity` minted with ERC2309 exceeds the safety limit.
75      */
76     error MintERC2309QuantityExceedsLimit();
77 
78     /**
79      * The `extraData` cannot be set on an unintialized ownership slot.
80      */
81     error OwnershipNotInitializedForExtraData();
82 
83     struct TokenOwnership {
84         // The address of the owner.
85         address addr;
86         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
87         uint64 startTimestamp;
88         // Whether the token has been burned.
89         bool burned;
90         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
91         uint24 extraData;
92     }
93 
94     /**
95      * @dev Returns the total amount of tokens stored by the contract.
96      *
97      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     // ==============================
102     //            IERC165
103     // ==============================
104 
105     /**
106      * @dev Returns true if this contract implements the interface defined by
107      * `interfaceId`. See the corresponding
108      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
109      * to learn more about how these ids are created.
110      *
111      * This function call must use less than 30 000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
114 
115     // ==============================
116     //            IERC721
117     // ==============================
118 
119     /**
120      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
123 
124     /**
125      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
126      */
127     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
131      */
132     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
133 
134     /**
135      * @dev Returns the number of tokens in ``owner``'s account.
136      */
137     function balanceOf(address owner) external view returns (uint256 balance);
138 
139     /**
140      * @dev Returns the owner of the `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function ownerOf(uint256 tokenId) external view returns (address owner);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
170      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must exist and be owned by `from`.
177      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external;
187 
188     /**
189      * @dev Transfers `tokenId` token from `from` to `to`.
190      *
191      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external;
207 
208     /**
209      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
210      * The approval is cleared when the token is transferred.
211      *
212      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
213      *
214      * Requirements:
215      *
216      * - The caller must own the token or be an approved operator.
217      * - `tokenId` must exist.
218      *
219      * Emits an {Approval} event.
220      */
221     function approve(address to, uint256 tokenId) external;
222 
223     /**
224      * @dev Approve or remove `operator` as an operator for the caller.
225      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
226      *
227      * Requirements:
228      *
229      * - The `operator` cannot be the caller.
230      *
231      * Emits an {ApprovalForAll} event.
232      */
233     function setApprovalForAll(address operator, bool _approved) external;
234 
235     /**
236      * @dev Returns the account approved for `tokenId` token.
237      *
238      * Requirements:
239      *
240      * - `tokenId` must exist.
241      */
242     function getApproved(uint256 tokenId) external view returns (address operator);
243 
244     /**
245      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
246      *
247      * See {setApprovalForAll}
248      */
249     function isApprovedForAll(address owner, address operator) external view returns (bool);
250 
251     // ==============================
252     //        IERC721Metadata
253     // ==============================
254 
255     /**
256      * @dev Returns the token collection name.
257      */
258     function name() external view returns (string memory);
259 
260     /**
261      * @dev Returns the token collection symbol.
262      */
263     function symbol() external view returns (string memory);
264 
265     /**
266      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
267      */
268     function tokenURI(uint256 tokenId) external view returns (string memory);
269 
270     // ==============================
271     //            IERC2309
272     // ==============================
273 
274     /**
275      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
276      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
277      */
278     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
279 }
280 // File: Beings/ERC721A.sol
281 
282 
283 // ERC721A Contracts v4.1.0
284 // Creator: Chiru Labs
285 
286 pragma solidity ^0.8.4;
287 
288 
289 /**
290  * @dev ERC721 token receiver interface.
291  */
292 interface ERC721A__IERC721Receiver {
293     function onERC721Received(
294         address operator,
295         address from,
296         uint256 tokenId,
297         bytes calldata data
298     ) external returns (bytes4);
299 }
300 
301 /**
302  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
303  * including the Metadata extension. Built to optimize for lower gas during batch mints.
304  *
305  * Assumes serials are sequentially minted starting at `_startTokenId()`
306  * (defaults to 0, e.g. 0, 1, 2, 3..).
307  *
308  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
309  *
310  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
311  */
312 contract ERC721A is IERC721A {
313     // Reference type for token approval.
314     struct TokenApprovalRef {
315         address value;
316     }
317 
318     // Mask of an entry in packed address data.
319     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
320 
321     // The bit position of `numberMinted` in packed address data.
322     uint256 private constant BITPOS_NUMBER_MINTED = 64;
323 
324     // The bit position of `numberBurned` in packed address data.
325     uint256 private constant BITPOS_NUMBER_BURNED = 128;
326 
327     // The bit position of `aux` in packed address data.
328     uint256 private constant BITPOS_AUX = 192;
329 
330     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
331     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
332 
333     // The bit position of `startTimestamp` in packed ownership.
334     uint256 private constant BITPOS_START_TIMESTAMP = 160;
335 
336     // The bit mask of the `burned` bit in packed ownership.
337     uint256 private constant BITMASK_BURNED = 1 << 224;
338 
339     // The bit position of the `nextInitialized` bit in packed ownership.
340     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
341 
342     // The bit mask of the `nextInitialized` bit in packed ownership.
343     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
344 
345     // The bit position of `extraData` in packed ownership.
346     uint256 private constant BITPOS_EXTRA_DATA = 232;
347 
348     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
349     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
350 
351     // The mask of the lower 160 bits for addresses.
352     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
353 
354     // The maximum `quantity` that can be minted with `_mintERC2309`.
355     // This limit is to prevent overflows on the address data entries.
356     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
357     // is required to cause an overflow, which is unrealistic.
358     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
359 
360     // The tokenId of the next token to be minted.
361     uint256 private _currentIndex;
362 
363     // The number of tokens burned.
364     uint256 private _burnCounter;
365 
366     // Token name
367     string private _name;
368 
369     // Token symbol
370     string private _symbol;
371 
372     // Mapping from token ID to ownership details
373     // An empty struct value does not necessarily mean the token is unowned.
374     // See `_packedOwnershipOf` implementation for details.
375     //
376     // Bits Layout:
377     // - [0..159]   `addr`
378     // - [160..223] `startTimestamp`
379     // - [224]      `burned`
380     // - [225]      `nextInitialized`
381     // - [232..255] `extraData`
382     mapping(uint256 => uint256) private _packedOwnerships;
383 
384     // Mapping owner address to address data.
385     //
386     // Bits Layout:
387     // - [0..63]    `balance`
388     // - [64..127]  `numberMinted`
389     // - [128..191] `numberBurned`
390     // - [192..255] `aux`
391     mapping(address => uint256) private _packedAddressData;
392 
393     // Mapping from token ID to approved address.
394     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
395 
396     // Mapping from owner to operator approvals
397     mapping(address => mapping(address => bool)) private _operatorApprovals;
398 
399     constructor(string memory name_, string memory symbol_) {
400         _name = name_;
401         _symbol = symbol_;
402         _currentIndex = _startTokenId();
403     }
404 
405     /**
406      * @dev Returns the starting token ID.
407      * To change the starting token ID, please override this function.
408      */
409     function _startTokenId() internal view virtual returns (uint256) {
410         return 0;
411     }
412 
413     /**
414      * @dev Returns the next token ID to be minted.
415      */
416     function _nextTokenId() internal view virtual returns (uint256) {
417         return _currentIndex;
418     }
419 
420     /**
421      * @dev Returns the total number of tokens in existence.
422      * Burned tokens will reduce the count.
423      * To get the total number of tokens minted, please see `_totalMinted`.
424      */
425     function totalSupply() public view virtual override returns (uint256) {
426         // Counter underflow is impossible as _burnCounter cannot be incremented
427         // more than `_currentIndex - _startTokenId()` times.
428         unchecked {
429             return _currentIndex - _burnCounter - _startTokenId();
430         }
431     }
432 
433     /**
434      * @dev Returns the total amount of tokens minted in the contract.
435      */
436     function _totalMinted() internal view virtual returns (uint256) {
437         // Counter underflow is impossible as _currentIndex does not decrement,
438         // and it is initialized to `_startTokenId()`
439         unchecked {
440             return _currentIndex - _startTokenId();
441         }
442     }
443 
444     /**
445      * @dev Returns the total number of tokens burned.
446      */
447     function _totalBurned() internal view virtual returns (uint256) {
448         return _burnCounter;
449     }
450 
451     /**
452      * @dev See {IERC165-supportsInterface}.
453      */
454     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
455         // The interface IDs are constants representing the first 4 bytes of the XOR of
456         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
457         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
458         return
459             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
460             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
461             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
462     }
463 
464     /**
465      * @dev See {IERC721-balanceOf}.
466      */
467     function balanceOf(address owner) public view virtual override returns (uint256) {
468         if (owner == address(0)) revert BalanceQueryForZeroAddress();
469         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
470     }
471 
472     /**
473      * Returns the number of tokens minted by `owner`.
474      */
475     function _numberMinted(address owner) internal view virtual returns (uint256) {
476         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
477     }
478 
479     /**
480      * Returns the number of tokens burned by or on behalf of `owner`.
481      */
482     function _numberBurned(address owner) internal view virtual returns (uint256) {
483         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
484     }
485 
486     /**
487      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
488      */
489     function _getAux(address owner) internal view virtual returns (uint64) {
490         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
491     }
492 
493     /**
494      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
495      * If there are multiple variables, please pack them into a uint64.
496      */
497     function _setAux(address owner, uint64 aux) internal virtual {
498         uint256 packed = _packedAddressData[owner];
499         uint256 auxCasted;
500         // Cast `aux` with assembly to avoid redundant masking.
501         assembly {
502             auxCasted := aux
503         }
504         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
505         _packedAddressData[owner] = packed;
506     }
507 
508     /**
509      * Returns the packed ownership data of `tokenId`.
510      */
511     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
512         uint256 curr = tokenId;
513 
514         unchecked {
515             if (_startTokenId() <= curr)
516                 if (curr < _currentIndex) {
517                     uint256 packed = _packedOwnerships[curr];
518                     // If not burned.
519                     if (packed & BITMASK_BURNED == 0) {
520                         // Invariant:
521                         // There will always be an ownership that has an address and is not burned
522                         // before an ownership that does not have an address and is not burned.
523                         // Hence, curr will not underflow.
524                         //
525                         // We can directly compare the packed value.
526                         // If the address is zero, packed is zero.
527                         while (packed == 0) {
528                             packed = _packedOwnerships[--curr];
529                         }
530                         return packed;
531                     }
532                 }
533         }
534         revert OwnerQueryForNonexistentToken();
535     }
536 
537     /**
538      * Returns the unpacked `TokenOwnership` struct from `packed`.
539      */
540     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
541         ownership.addr = address(uint160(packed));
542         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
543         ownership.burned = packed & BITMASK_BURNED != 0;
544         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
545     }
546 
547     /**
548      * Returns the unpacked `TokenOwnership` struct at `index`.
549      */
550     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
551         return _unpackedOwnership(_packedOwnerships[index]);
552     }
553 
554     /**
555      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
556      */
557     function _initializeOwnershipAt(uint256 index) internal virtual {
558         if (_packedOwnerships[index] == 0) {
559             _packedOwnerships[index] = _packedOwnershipOf(index);
560         }
561     }
562 
563     /**
564      * Gas spent here starts off proportional to the maximum mint batch size.
565      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
566      */
567     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
568         return _unpackedOwnership(_packedOwnershipOf(tokenId));
569     }
570 
571     /**
572      * @dev Packs ownership data into a single uint256.
573      */
574     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
575         assembly {
576             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
577             owner := and(owner, BITMASK_ADDRESS)
578             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
579             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
580         }
581     }
582 
583     /**
584      * @dev See {IERC721-ownerOf}.
585      */
586     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
587         return address(uint160(_packedOwnershipOf(tokenId)));
588     }
589 
590     /**
591      * @dev See {IERC721Metadata-name}.
592      */
593     function name() public view virtual override returns (string memory) {
594         return _name;
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-symbol}.
599      */
600     function symbol() public view virtual override returns (string memory) {
601         return _symbol;
602     }
603 
604     /**
605      * @dev See {IERC721Metadata-tokenURI}.
606      */
607     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
608         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
609 
610         string memory baseURI = _baseURI();
611         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
612     }
613 
614     /**
615      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
616      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
617      * by default, it can be overridden in child contracts.
618      */
619     function _baseURI() internal view virtual returns (string memory) {
620         return '';
621     }
622 
623     /**
624      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
625      */
626     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
627         // For branchless setting of the `nextInitialized` flag.
628         assembly {
629             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
630             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
631         }
632     }
633 
634     /**
635      * @dev See {IERC721-approve}.
636      */
637     function approve(address to, uint256 tokenId) public virtual override {
638         address owner = ownerOf(tokenId);
639 
640         if (_msgSenderERC721A() != owner)
641             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
642                 revert ApprovalCallerNotOwnerNorApproved();
643             }
644 
645         _tokenApprovals[tokenId].value = to;
646         emit Approval(owner, to, tokenId);
647     }
648 
649     /**
650      * @dev See {IERC721-getApproved}.
651      */
652     function getApproved(uint256 tokenId) public view virtual override returns (address) {
653         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
654 
655         return _tokenApprovals[tokenId].value;
656     }
657 
658     /**
659      * @dev See {IERC721-setApprovalForAll}.
660      */
661     function setApprovalForAll(address operator, bool approved) public virtual override {
662         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
663 
664         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
665         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
666     }
667 
668     /**
669      * @dev See {IERC721-isApprovedForAll}.
670      */
671     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
672         return _operatorApprovals[owner][operator];
673     }
674 
675     /**
676      * @dev See {IERC721-safeTransferFrom}.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) public virtual override {
683         safeTransferFrom(from, to, tokenId, '');
684     }
685 
686     /**
687      * @dev See {IERC721-safeTransferFrom}.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId,
693         bytes memory _data
694     ) public virtual override {
695         transferFrom(from, to, tokenId);
696         if (to.code.length != 0)
697             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
698                 revert TransferToNonERC721ReceiverImplementer();
699             }
700     }
701 
702     /**
703      * @dev Returns whether `tokenId` exists.
704      *
705      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
706      *
707      * Tokens start existing when they are minted (`_mint`),
708      */
709     function _exists(uint256 tokenId) internal view virtual returns (bool) {
710         return
711             _startTokenId() <= tokenId &&
712             tokenId < _currentIndex && // If within bounds,
713             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
714     }
715 
716     /**
717      * @dev Equivalent to `_safeMint(to, quantity, '')`.
718      */
719     function _safeMint(address to, uint256 quantity) internal virtual {
720         _safeMint(to, quantity, '');
721     }
722 
723     /**
724      * @dev Safely mints `quantity` tokens and transfers them to `to`.
725      *
726      * Requirements:
727      *
728      * - If `to` refers to a smart contract, it must implement
729      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
730      * - `quantity` must be greater than 0.
731      *
732      * See {_mint}.
733      *
734      * Emits a {Transfer} event for each mint.
735      */
736     function _safeMint(
737         address to,
738         uint256 quantity,
739         bytes memory _data
740     ) internal virtual {
741         _mint(to, quantity);
742 
743         unchecked {
744             if (to.code.length != 0) {
745                 uint256 end = _currentIndex;
746                 uint256 index = end - quantity;
747                 do {
748                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
749                         revert TransferToNonERC721ReceiverImplementer();
750                     }
751                 } while (index < end);
752                 // Reentrancy protection.
753                 if (_currentIndex != end) revert();
754             }
755         }
756     }
757 
758     /**
759      * @dev Mints `quantity` tokens and transfers them to `to`.
760      *
761      * Requirements:
762      *
763      * - `to` cannot be the zero address.
764      * - `quantity` must be greater than 0.
765      *
766      * Emits a {Transfer} event for each mint.
767      */
768     function _mint(address to, uint256 quantity) internal virtual {
769         uint256 startTokenId = _currentIndex;
770         if (to == address(0)) revert MintToZeroAddress();
771         if (quantity == 0) revert MintZeroQuantity();
772 
773         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
774 
775         // Overflows are incredibly unrealistic.
776         // `balance` and `numberMinted` have a maximum limit of 2**64.
777         // `tokenId` has a maximum limit of 2**256.
778         unchecked {
779             // Updates:
780             // - `balance += quantity`.
781             // - `numberMinted += quantity`.
782             //
783             // We can directly add to the `balance` and `numberMinted`.
784             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
785 
786             // Updates:
787             // - `address` to the owner.
788             // - `startTimestamp` to the timestamp of minting.
789             // - `burned` to `false`.
790             // - `nextInitialized` to `quantity == 1`.
791             _packedOwnerships[startTokenId] = _packOwnershipData(
792                 to,
793                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
794             );
795 
796             uint256 tokenId = startTokenId;
797             uint256 end = startTokenId + quantity;
798             do {
799                 emit Transfer(address(0), to, tokenId++);
800             } while (tokenId < end);
801 
802             _currentIndex = end;
803         }
804         _afterTokenTransfers(address(0), to, startTokenId, quantity);
805     }
806 
807     /**
808      * @dev Mints `quantity` tokens and transfers them to `to`.
809      *
810      * This function is intended for efficient minting only during contract creation.
811      *
812      * It emits only one {ConsecutiveTransfer} as defined in
813      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
814      * instead of a sequence of {Transfer} event(s).
815      *
816      * Calling this function outside of contract creation WILL make your contract
817      * non-compliant with the ERC721 standard.
818      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
819      * {ConsecutiveTransfer} event is only permissible during contract creation.
820      *
821      * Requirements:
822      *
823      * - `to` cannot be the zero address.
824      * - `quantity` must be greater than 0.
825      *
826      * Emits a {ConsecutiveTransfer} event.
827      */
828     function _mintERC2309(address to, uint256 quantity) internal virtual {
829         uint256 startTokenId = _currentIndex;
830         if (to == address(0)) revert MintToZeroAddress();
831         if (quantity == 0) revert MintZeroQuantity();
832         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
833 
834         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
835 
836         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
837         unchecked {
838             // Updates:
839             // - `balance += quantity`.
840             // - `numberMinted += quantity`.
841             //
842             // We can directly add to the `balance` and `numberMinted`.
843             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
844 
845             // Updates:
846             // - `address` to the owner.
847             // - `startTimestamp` to the timestamp of minting.
848             // - `burned` to `false`.
849             // - `nextInitialized` to `quantity == 1`.
850             _packedOwnerships[startTokenId] = _packOwnershipData(
851                 to,
852                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
853             );
854 
855             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
856 
857             _currentIndex = startTokenId + quantity;
858         }
859         _afterTokenTransfers(address(0), to, startTokenId, quantity);
860     }
861 
862     /**
863      * @dev Returns the storage slot and value for the approved address of `tokenId`.
864      */
865     function _getApprovedAddress(uint256 tokenId)
866         private
867         view
868         returns (uint256 approvedAddressSlot, address approvedAddress)
869     {
870         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
871         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
872         assembly {
873             approvedAddressSlot := tokenApproval.slot
874             approvedAddress := sload(approvedAddressSlot)
875         }
876     }
877 
878     /**
879      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
880      */
881     function _isOwnerOrApproved(
882         address approvedAddress,
883         address from,
884         address msgSender
885     ) private pure returns (bool result) {
886         assembly {
887             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
888             from := and(from, BITMASK_ADDRESS)
889             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
890             msgSender := and(msgSender, BITMASK_ADDRESS)
891             // `msgSender == from || msgSender == approvedAddress`.
892             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
893         }
894     }
895 
896     /**
897      * @dev Transfers `tokenId` from `from` to `to`.
898      *
899      * Requirements:
900      *
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must be owned by `from`.
903      *
904      * Emits a {Transfer} event.
905      */
906     function transferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
912 
913         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
914 
915         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
916 
917         // The nested ifs save around 20+ gas over a compound boolean condition.
918         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
919             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
920 
921         if (to == address(0)) revert TransferToZeroAddress();
922 
923         _beforeTokenTransfers(from, to, tokenId, 1);
924 
925         // Clear approvals from the previous owner.
926         assembly {
927             if approvedAddress {
928                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
929                 sstore(approvedAddressSlot, 0)
930             }
931         }
932 
933         // Underflow of the sender's balance is impossible because we check for
934         // ownership above and the recipient's balance can't realistically overflow.
935         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
936         unchecked {
937             // We can directly increment and decrement the balances.
938             --_packedAddressData[from]; // Updates: `balance -= 1`.
939             ++_packedAddressData[to]; // Updates: `balance += 1`.
940 
941             // Updates:
942             // - `address` to the next owner.
943             // - `startTimestamp` to the timestamp of transfering.
944             // - `burned` to `false`.
945             // - `nextInitialized` to `true`.
946             _packedOwnerships[tokenId] = _packOwnershipData(
947                 to,
948                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
949             );
950 
951             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
952             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
953                 uint256 nextTokenId = tokenId + 1;
954                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
955                 if (_packedOwnerships[nextTokenId] == 0) {
956                     // If the next slot is within bounds.
957                     if (nextTokenId != _currentIndex) {
958                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
959                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
960                     }
961                 }
962             }
963         }
964 
965         emit Transfer(from, to, tokenId);
966         _afterTokenTransfers(from, to, tokenId, 1);
967     }
968 
969     /**
970      * @dev Equivalent to `_burn(tokenId, false)`.
971      */
972     function _burn(uint256 tokenId) internal virtual {
973         _burn(tokenId, false);
974     }
975 
976     /**
977      * @dev Destroys `tokenId`.
978      * The approval is cleared when the token is burned.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
987         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
988 
989         address from = address(uint160(prevOwnershipPacked));
990 
991         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
992 
993         if (approvalCheck) {
994             // The nested ifs save around 20+ gas over a compound boolean condition.
995             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
996                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
997         }
998 
999         _beforeTokenTransfers(from, address(0), tokenId, 1);
1000 
1001         // Clear approvals from the previous owner.
1002         assembly {
1003             if approvedAddress {
1004                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1005                 sstore(approvedAddressSlot, 0)
1006             }
1007         }
1008 
1009         // Underflow of the sender's balance is impossible because we check for
1010         // ownership above and the recipient's balance can't realistically overflow.
1011         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1012         unchecked {
1013             // Updates:
1014             // - `balance -= 1`.
1015             // - `numberBurned += 1`.
1016             //
1017             // We can directly decrement the balance, and increment the number burned.
1018             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1019             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1020 
1021             // Updates:
1022             // - `address` to the last owner.
1023             // - `startTimestamp` to the timestamp of burning.
1024             // - `burned` to `true`.
1025             // - `nextInitialized` to `true`.
1026             _packedOwnerships[tokenId] = _packOwnershipData(
1027                 from,
1028                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1029             );
1030 
1031             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1032             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1033                 uint256 nextTokenId = tokenId + 1;
1034                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1035                 if (_packedOwnerships[nextTokenId] == 0) {
1036                     // If the next slot is within bounds.
1037                     if (nextTokenId != _currentIndex) {
1038                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1039                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1040                     }
1041                 }
1042             }
1043         }
1044 
1045         emit Transfer(from, address(0), tokenId);
1046         _afterTokenTransfers(from, address(0), tokenId, 1);
1047 
1048         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1049         unchecked {
1050             _burnCounter++;
1051         }
1052     }
1053 
1054     /**
1055      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1056      *
1057      * @param from address representing the previous owner of the given token ID
1058      * @param to target address that will receive the tokens
1059      * @param tokenId uint256 ID of the token to be transferred
1060      * @param _data bytes optional data to send along with the call
1061      * @return bool whether the call correctly returned the expected magic value
1062      */
1063     function _checkContractOnERC721Received(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) private returns (bool) {
1069         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1070             bytes4 retval
1071         ) {
1072             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1073         } catch (bytes memory reason) {
1074             if (reason.length == 0) {
1075                 revert TransferToNonERC721ReceiverImplementer();
1076             } else {
1077                 assembly {
1078                     revert(add(32, reason), mload(reason))
1079                 }
1080             }
1081         }
1082     }
1083 
1084     /**
1085      * @dev Directly sets the extra data for the ownership data `index`.
1086      */
1087     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1088         uint256 packed = _packedOwnerships[index];
1089         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1090         uint256 extraDataCasted;
1091         // Cast `extraData` with assembly to avoid redundant masking.
1092         assembly {
1093             extraDataCasted := extraData
1094         }
1095         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1096         _packedOwnerships[index] = packed;
1097     }
1098 
1099     /**
1100      * @dev Returns the next extra data for the packed ownership data.
1101      * The returned result is shifted into position.
1102      */
1103     function _nextExtraData(
1104         address from,
1105         address to,
1106         uint256 prevOwnershipPacked
1107     ) private view returns (uint256) {
1108         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1109         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1110     }
1111 
1112     /**
1113      * @dev Called during each token transfer to set the 24bit `extraData` field.
1114      * Intended to be overridden by the cosumer contract.
1115      *
1116      * `previousExtraData` - the value of `extraData` before transfer.
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` will be minted for `to`.
1123      * - When `to` is zero, `tokenId` will be burned by `from`.
1124      * - `from` and `to` are never both zero.
1125      */
1126     function _extraData(
1127         address from,
1128         address to,
1129         uint24 previousExtraData
1130     ) internal view virtual returns (uint24) {}
1131 
1132     /**
1133      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1134      * This includes minting.
1135      * And also called before burning one token.
1136      *
1137      * startTokenId - the first token id to be transferred
1138      * quantity - the amount to be transferred
1139      *
1140      * Calling conditions:
1141      *
1142      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1143      * transferred to `to`.
1144      * - When `from` is zero, `tokenId` will be minted for `to`.
1145      * - When `to` is zero, `tokenId` will be burned by `from`.
1146      * - `from` and `to` are never both zero.
1147      */
1148     function _beforeTokenTransfers(
1149         address from,
1150         address to,
1151         uint256 startTokenId,
1152         uint256 quantity
1153     ) internal virtual {}
1154 
1155     /**
1156      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1157      * This includes minting.
1158      * And also called after one token has been burned.
1159      *
1160      * startTokenId - the first token id to be transferred
1161      * quantity - the amount to be transferred
1162      *
1163      * Calling conditions:
1164      *
1165      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1166      * transferred to `to`.
1167      * - When `from` is zero, `tokenId` has been minted for `to`.
1168      * - When `to` is zero, `tokenId` has been burned by `from`.
1169      * - `from` and `to` are never both zero.
1170      */
1171     function _afterTokenTransfers(
1172         address from,
1173         address to,
1174         uint256 startTokenId,
1175         uint256 quantity
1176     ) internal virtual {}
1177 
1178     /**
1179      * @dev Returns the message sender (defaults to `msg.sender`).
1180      *
1181      * If you are writing GSN compatible contracts, you need to override this function.
1182      */
1183     function _msgSenderERC721A() internal view virtual returns (address) {
1184         return msg.sender;
1185     }
1186 
1187     /**
1188      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1189      */
1190     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1191         assembly {
1192             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1193             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1194             // We will need 1 32-byte word to store the length,
1195             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1196             ptr := add(mload(0x40), 128)
1197             // Update the free memory pointer to allocate.
1198             mstore(0x40, ptr)
1199 
1200             // Cache the end of the memory to calculate the length later.
1201             let end := ptr
1202 
1203             // We write the string from the rightmost digit to the leftmost digit.
1204             // The following is essentially a do-while loop that also handles the zero case.
1205             // Costs a bit more than early returning for the zero case,
1206             // but cheaper in terms of deployment and overall runtime costs.
1207             for {
1208                 // Initialize and perform the first pass without check.
1209                 let temp := value
1210                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1211                 ptr := sub(ptr, 1)
1212                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1213                 mstore8(ptr, add(48, mod(temp, 10)))
1214                 temp := div(temp, 10)
1215             } temp {
1216                 // Keep dividing `temp` until zero.
1217                 temp := div(temp, 10)
1218             } {
1219                 // Body of the for loop.
1220                 ptr := sub(ptr, 1)
1221                 mstore8(ptr, add(48, mod(temp, 10)))
1222             }
1223 
1224             let length := sub(end, ptr)
1225             // Move the pointer 32 bytes leftwards to make room for the length.
1226             ptr := sub(ptr, 32)
1227             // Store the length.
1228             mstore(ptr, length)
1229         }
1230     }
1231 }
1232 // File: @openzeppelin/contracts/utils/Strings.sol
1233 
1234 
1235 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1236 
1237 pragma solidity ^0.8.0;
1238 
1239 /**
1240  * @dev String operations.
1241  */
1242 library Strings {
1243     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1244     uint8 private constant _ADDRESS_LENGTH = 20;
1245 
1246     /**
1247      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1248      */
1249     function toString(uint256 value) internal pure returns (string memory) {
1250         // Inspired by OraclizeAPI's implementation - MIT licence
1251         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1252 
1253         if (value == 0) {
1254             return "0";
1255         }
1256         uint256 temp = value;
1257         uint256 digits;
1258         while (temp != 0) {
1259             digits++;
1260             temp /= 10;
1261         }
1262         bytes memory buffer = new bytes(digits);
1263         while (value != 0) {
1264             digits -= 1;
1265             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1266             value /= 10;
1267         }
1268         return string(buffer);
1269     }
1270 
1271     /**
1272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1273      */
1274     function toHexString(uint256 value) internal pure returns (string memory) {
1275         if (value == 0) {
1276             return "0x00";
1277         }
1278         uint256 temp = value;
1279         uint256 length = 0;
1280         while (temp != 0) {
1281             length++;
1282             temp >>= 8;
1283         }
1284         return toHexString(value, length);
1285     }
1286 
1287     /**
1288      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1289      */
1290     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1291         bytes memory buffer = new bytes(2 * length + 2);
1292         buffer[0] = "0";
1293         buffer[1] = "x";
1294         for (uint256 i = 2 * length + 1; i > 1; --i) {
1295             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1296             value >>= 4;
1297         }
1298         require(value == 0, "Strings: hex length insufficient");
1299         return string(buffer);
1300     }
1301 
1302     /**
1303      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1304      */
1305     function toHexString(address addr) internal pure returns (string memory) {
1306         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1307     }
1308 }
1309 
1310 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1311 
1312 
1313 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1314 
1315 pragma solidity ^0.8.0;
1316 
1317 /**
1318  * @dev These functions deal with verification of Merkle Tree proofs.
1319  *
1320  * The proofs can be generated using the JavaScript library
1321  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1322  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1323  *
1324  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1325  *
1326  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1327  * hashing, or use a hash function other than keccak256 for hashing leaves.
1328  * This is because the concatenation of a sorted pair of internal nodes in
1329  * the merkle tree could be reinterpreted as a leaf value.
1330  */
1331 library MerkleProof {
1332     /**
1333      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1334      * defined by `root`. For this, a `proof` must be provided, containing
1335      * sibling hashes on the branch from the leaf to the root of the tree. Each
1336      * pair of leaves and each pair of pre-images are assumed to be sorted.
1337      */
1338     function verify(
1339         bytes32[] memory proof,
1340         bytes32 root,
1341         bytes32 leaf
1342     ) internal pure returns (bool) {
1343         return processProof(proof, leaf) == root;
1344     }
1345 
1346     /**
1347      * @dev Calldata version of {verify}
1348      *
1349      * _Available since v4.7._
1350      */
1351     function verifyCalldata(
1352         bytes32[] calldata proof,
1353         bytes32 root,
1354         bytes32 leaf
1355     ) internal pure returns (bool) {
1356         return processProofCalldata(proof, leaf) == root;
1357     }
1358 
1359     /**
1360      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1361      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1362      * hash matches the root of the tree. When processing the proof, the pairs
1363      * of leafs & pre-images are assumed to be sorted.
1364      *
1365      * _Available since v4.4._
1366      */
1367     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1368         bytes32 computedHash = leaf;
1369         for (uint256 i = 0; i < proof.length; i++) {
1370             computedHash = _hashPair(computedHash, proof[i]);
1371         }
1372         return computedHash;
1373     }
1374 
1375     /**
1376      * @dev Calldata version of {processProof}
1377      *
1378      * _Available since v4.7._
1379      */
1380     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1381         bytes32 computedHash = leaf;
1382         for (uint256 i = 0; i < proof.length; i++) {
1383             computedHash = _hashPair(computedHash, proof[i]);
1384         }
1385         return computedHash;
1386     }
1387 
1388     /**
1389      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1390      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1391      *
1392      * _Available since v4.7._
1393      */
1394     function multiProofVerify(
1395         bytes32[] memory proof,
1396         bool[] memory proofFlags,
1397         bytes32 root,
1398         bytes32[] memory leaves
1399     ) internal pure returns (bool) {
1400         return processMultiProof(proof, proofFlags, leaves) == root;
1401     }
1402 
1403     /**
1404      * @dev Calldata version of {multiProofVerify}
1405      *
1406      * _Available since v4.7._
1407      */
1408     function multiProofVerifyCalldata(
1409         bytes32[] calldata proof,
1410         bool[] calldata proofFlags,
1411         bytes32 root,
1412         bytes32[] memory leaves
1413     ) internal pure returns (bool) {
1414         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1415     }
1416 
1417     /**
1418      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1419      * consuming from one or the other at each step according to the instructions given by
1420      * `proofFlags`.
1421      *
1422      * _Available since v4.7._
1423      */
1424     function processMultiProof(
1425         bytes32[] memory proof,
1426         bool[] memory proofFlags,
1427         bytes32[] memory leaves
1428     ) internal pure returns (bytes32 merkleRoot) {
1429         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1430         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1431         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1432         // the merkle tree.
1433         uint256 leavesLen = leaves.length;
1434         uint256 totalHashes = proofFlags.length;
1435 
1436         // Check proof validity.
1437         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1438 
1439         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1440         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1441         bytes32[] memory hashes = new bytes32[](totalHashes);
1442         uint256 leafPos = 0;
1443         uint256 hashPos = 0;
1444         uint256 proofPos = 0;
1445         // At each step, we compute the next hash using two values:
1446         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1447         //   get the next hash.
1448         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1449         //   `proof` array.
1450         for (uint256 i = 0; i < totalHashes; i++) {
1451             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1452             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1453             hashes[i] = _hashPair(a, b);
1454         }
1455 
1456         if (totalHashes > 0) {
1457             return hashes[totalHashes - 1];
1458         } else if (leavesLen > 0) {
1459             return leaves[0];
1460         } else {
1461             return proof[0];
1462         }
1463     }
1464 
1465     /**
1466      * @dev Calldata version of {processMultiProof}
1467      *
1468      * _Available since v4.7._
1469      */
1470     function processMultiProofCalldata(
1471         bytes32[] calldata proof,
1472         bool[] calldata proofFlags,
1473         bytes32[] memory leaves
1474     ) internal pure returns (bytes32 merkleRoot) {
1475         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1476         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1477         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1478         // the merkle tree.
1479         uint256 leavesLen = leaves.length;
1480         uint256 totalHashes = proofFlags.length;
1481 
1482         // Check proof validity.
1483         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1484 
1485         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1486         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1487         bytes32[] memory hashes = new bytes32[](totalHashes);
1488         uint256 leafPos = 0;
1489         uint256 hashPos = 0;
1490         uint256 proofPos = 0;
1491         // At each step, we compute the next hash using two values:
1492         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1493         //   get the next hash.
1494         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1495         //   `proof` array.
1496         for (uint256 i = 0; i < totalHashes; i++) {
1497             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1498             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1499             hashes[i] = _hashPair(a, b);
1500         }
1501 
1502         if (totalHashes > 0) {
1503             return hashes[totalHashes - 1];
1504         } else if (leavesLen > 0) {
1505             return leaves[0];
1506         } else {
1507             return proof[0];
1508         }
1509     }
1510 
1511     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1512         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1513     }
1514 
1515     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1516         /// @solidity memory-safe-assembly
1517         assembly {
1518             mstore(0x00, a)
1519             mstore(0x20, b)
1520             value := keccak256(0x00, 0x40)
1521         }
1522     }
1523 }
1524 
1525 // File: @openzeppelin/contracts/utils/Context.sol
1526 
1527 
1528 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1529 
1530 pragma solidity ^0.8.0;
1531 
1532 /**
1533  * @dev Provides information about the current execution context, including the
1534  * sender of the transaction and its data. While these are generally available
1535  * via msg.sender and msg.data, they should not be accessed in such a direct
1536  * manner, since when dealing with meta-transactions the account sending and
1537  * paying for execution may not be the actual sender (as far as an application
1538  * is concerned).
1539  *
1540  * This contract is only required for intermediate, library-like contracts.
1541  */
1542 abstract contract Context {
1543     function _msgSender() internal view virtual returns (address) {
1544         return msg.sender;
1545     }
1546 
1547     function _msgData() internal view virtual returns (bytes calldata) {
1548         return msg.data;
1549     }
1550 }
1551 
1552 // File: @openzeppelin/contracts/access/Ownable.sol
1553 
1554 
1555 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1556 
1557 pragma solidity ^0.8.0;
1558 
1559 
1560 /**
1561  * @dev Contract module which provides a basic access control mechanism, where
1562  * there is an account (an owner) that can be granted exclusive access to
1563  * specific functions.
1564  *
1565  * By default, the owner account will be the one that deploys the contract. This
1566  * can later be changed with {transferOwnership}.
1567  *
1568  * This module is used through inheritance. It will make available the modifier
1569  * `onlyOwner`, which can be applied to your functions to restrict their use to
1570  * the owner.
1571  */
1572 abstract contract Ownable is Context {
1573     address private _owner;
1574 
1575     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1576 
1577     /**
1578      * @dev Initializes the contract setting the deployer as the initial owner.
1579      */
1580     constructor() {
1581         _transferOwnership(_msgSender());
1582     }
1583 
1584     /**
1585      * @dev Throws if called by any account other than the owner.
1586      */
1587     modifier onlyOwner() {
1588         _checkOwner();
1589         _;
1590     }
1591 
1592     /**
1593      * @dev Returns the address of the current owner.
1594      */
1595     function owner() public view virtual returns (address) {
1596         return _owner;
1597     }
1598 
1599     /**
1600      * @dev Throws if the sender is not the owner.
1601      */
1602     function _checkOwner() internal view virtual {
1603         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1604     }
1605 
1606     /**
1607      * @dev Leaves the contract without owner. It will not be possible to call
1608      * `onlyOwner` functions anymore. Can only be called by the current owner.
1609      *
1610      * NOTE: Renouncing ownership will leave the contract without an owner,
1611      * thereby removing any functionality that is only available to the owner.
1612      */
1613     function renounceOwnership() public virtual onlyOwner {
1614         _transferOwnership(address(0));
1615     }
1616 
1617     /**
1618      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1619      * Can only be called by the current owner.
1620      */
1621     function transferOwnership(address newOwner) public virtual onlyOwner {
1622         require(newOwner != address(0), "Ownable: new owner is the zero address");
1623         _transferOwnership(newOwner);
1624     }
1625 
1626     /**
1627      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1628      * Internal function without access restriction.
1629      */
1630     function _transferOwnership(address newOwner) internal virtual {
1631         address oldOwner = _owner;
1632         _owner = newOwner;
1633         emit OwnershipTransferred(oldOwner, newOwner);
1634     }
1635 }
1636 
1637 // File: Beings/BeingsNFT.sol
1638 
1639 
1640 pragma solidity ^0.8.12;
1641 //@author DavidNazareno
1642 //@title  Beings NFT
1643 
1644 
1645 
1646 
1647 
1648 contract BeingsNFT is Ownable, ERC721A {
1649     using Strings for uint256;
1650 
1651     enum BeingsState {
1652         NONE,
1653         WHITELISTSALE,
1654         PREMINTSALE,
1655         PUBLICSALE,
1656         SOLDOUT,
1657         REVEAL
1658     }
1659 
1660     BeingsState public currentState;
1661 
1662     string public baseURI;
1663     string public notRevealURI;
1664 
1665     uint256 private constant MAX_SUPPLY = 5555;
1666     uint256 private constant MAX_WHITELIST = 6100;
1667     uint256 private constant MAX_PREMINT = 300;
1668     uint256 private constant SALES_PRICE = 0 ether;
1669     uint256 private constant MAX_PER_WALLET = 1;
1670 
1671     address public teamAddress;
1672     bytes32 public whitelistMerkleRoot;
1673     bytes32 public premintMerkleRoot;
1674  
1675     mapping(address => uint256) public amountperWallet;
1676  
1677 
1678     constructor(
1679         address _team,
1680         bytes32 _whitelistMerkleRoot,
1681         bytes32 _premintMerkleRoot,
1682         string memory _baseURI,
1683         string memory _notRevealURI
1684     ) ERC721A("Beings", "BEINGS") {
1685         teamAddress = _team;
1686         whitelistMerkleRoot = _whitelistMerkleRoot;
1687         premintMerkleRoot = _premintMerkleRoot;
1688         baseURI = _baseURI;
1689         notRevealURI = _notRevealURI;
1690     }
1691 
1692     modifier callerIsUser() {
1693         require(tx.origin == msg.sender, "The caller is another contract");
1694         _;
1695     }
1696 
1697     modifier atState(BeingsState state) {
1698         require(currentState == state, "Wait dude not is the moment");
1699         _;
1700     }
1701 
1702     modifier validateMemberAddress(
1703         bytes32[] calldata _merkleProof,
1704         bytes32 _merkleRoot
1705     ) {
1706         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1707         require(
1708             MerkleProof.verify(_merkleProof, _merkleRoot, leaf),
1709             "You are not a member"
1710         );
1711         _;
1712     }
1713 
1714     modifier validateSupply(uint256 _maxSupply) {
1715         require(
1716             totalSupply() + MAX_PER_WALLET <= _maxSupply,
1717             "Max supply exceeded"
1718         );
1719         _;
1720     }
1721 
1722   
1723 
1724     modifier validateMintPerWallet() {
1725         require(
1726             amountperWallet[msg.sender] < MAX_PER_WALLET,
1727             "You can only get 1 NFT on the Sale"
1728         );
1729         _;
1730     }
1731 
1732     function WhiteListMint(bytes32[] calldata _proof)
1733         external
1734         payable
1735         callerIsUser
1736         atState(BeingsState.WHITELISTSALE)
1737         validateMintPerWallet
1738         validateSupply(MAX_WHITELIST)
1739         validateMemberAddress(_proof, whitelistMerkleRoot)
1740      
1741     {
1742         amountperWallet[msg.sender] += MAX_PER_WALLET;
1743         _safeMint(msg.sender, MAX_PER_WALLET);
1744     }
1745 
1746     function PreMint(bytes32[] calldata _proof)
1747         external
1748         payable
1749         callerIsUser
1750         atState(BeingsState.PREMINTSALE)
1751         validateMintPerWallet
1752         validateSupply(MAX_PREMINT + MAX_WHITELIST)
1753         validateMemberAddress(_proof, premintMerkleRoot)
1754         
1755     {
1756         amountperWallet[msg.sender] += MAX_PER_WALLET;
1757         _safeMint(msg.sender, MAX_PER_WALLET);
1758     }
1759 
1760     function PublicSaleMint()
1761         external
1762         payable
1763         callerIsUser
1764         atState(BeingsState.PUBLICSALE)
1765         validateSupply(MAX_SUPPLY)
1766         validateMintPerWallet
1767   
1768     {
1769         amountperWallet[msg.sender] += MAX_PER_WALLET;
1770         _safeMint(msg.sender, MAX_PER_WALLET);
1771     }
1772 
1773     function TeamMint(uint256 _maxTeamMint) external payable onlyOwner {
1774         _safeMint(teamAddress, _maxTeamMint);
1775     }
1776 
1777     function tokenURI(uint256 _tokenId)
1778         public
1779         view
1780         virtual
1781         override
1782         returns (string memory)
1783     {
1784 
1785          require(_exists(_tokenId), "URI query for nonexistent token");
1786 
1787         if (currentState != BeingsState.REVEAL) {
1788             return string(notRevealURI);
1789         }
1790         require(_exists(_tokenId), "URI query for nonexistent token");
1791         return string(abi.encodePacked(baseURI, (_tokenId+1).toString(), ".json"));
1792     }
1793 
1794     function withdrawAll(address _wallet) external onlyOwner {
1795         uint256 balance = address(this).balance;
1796         payable(_wallet).transfer(balance);
1797     }
1798 
1799     function setTeamAddress(address _team) external onlyOwner {
1800         teamAddress = _team;
1801     }
1802 
1803 
1804 
1805     function setBaseUri(string memory _baseURI) external onlyOwner {
1806         baseURI = _baseURI;
1807     }
1808 
1809     function setBeingsState(uint256 _step) external onlyOwner {
1810         currentState = BeingsState(_step);
1811     }
1812 
1813     function setNotRevealURI(string memory _uri) external onlyOwner {
1814         notRevealURI = _uri;
1815     }
1816 
1817     function setWhitelistMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1818         whitelistMerkleRoot = _merkleRoot;
1819     }
1820 
1821     function setPremintMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1822         premintMerkleRoot = _merkleRoot;
1823     }
1824 }