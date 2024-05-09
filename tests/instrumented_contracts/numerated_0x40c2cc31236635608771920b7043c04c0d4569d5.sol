1 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
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
280 
281 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
282 
283 
284 // ERC721A Contracts v4.1.0
285 // Creator: Chiru Labs
286 
287 pragma solidity ^0.8.4;
288 
289 
290 /**
291  * @dev ERC721 token receiver interface.
292  */
293 interface ERC721A__IERC721Receiver {
294     function onERC721Received(
295         address operator,
296         address from,
297         uint256 tokenId,
298         bytes calldata data
299     ) external returns (bytes4);
300 }
301 
302 /**
303  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
304  * including the Metadata extension. Built to optimize for lower gas during batch mints.
305  *
306  * Assumes serials are sequentially minted starting at `_startTokenId()`
307  * (defaults to 0, e.g. 0, 1, 2, 3..).
308  *
309  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
310  *
311  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
312  */
313 contract ERC721A is IERC721A {
314     // Reference type for token approval.
315     struct TokenApprovalRef {
316         address value;
317     }
318 
319     // Mask of an entry in packed address data.
320     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
321 
322     // The bit position of `numberMinted` in packed address data.
323     uint256 private constant BITPOS_NUMBER_MINTED = 64;
324 
325     // The bit position of `numberBurned` in packed address data.
326     uint256 private constant BITPOS_NUMBER_BURNED = 128;
327 
328     // The bit position of `aux` in packed address data.
329     uint256 private constant BITPOS_AUX = 192;
330 
331     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
332     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
333 
334     // The bit position of `startTimestamp` in packed ownership.
335     uint256 private constant BITPOS_START_TIMESTAMP = 160;
336 
337     // The bit mask of the `burned` bit in packed ownership.
338     uint256 private constant BITMASK_BURNED = 1 << 224;
339 
340     // The bit position of the `nextInitialized` bit in packed ownership.
341     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
342 
343     // The bit mask of the `nextInitialized` bit in packed ownership.
344     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
345 
346     // The bit position of `extraData` in packed ownership.
347     uint256 private constant BITPOS_EXTRA_DATA = 232;
348 
349     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
350     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
351 
352     // The mask of the lower 160 bits for addresses.
353     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
354 
355     // The maximum `quantity` that can be minted with `_mintERC2309`.
356     // This limit is to prevent overflows on the address data entries.
357     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
358     // is required to cause an overflow, which is unrealistic.
359     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
360 
361     // The tokenId of the next token to be minted.
362     uint256 private _currentIndex;
363 
364     // The number of tokens burned.
365     uint256 private _burnCounter;
366 
367     // Token name
368     string private _name;
369 
370     // Token symbol
371     string private _symbol;
372 
373     // Mapping from token ID to ownership details
374     // An empty struct value does not necessarily mean the token is unowned.
375     // See `_packedOwnershipOf` implementation for details.
376     //
377     // Bits Layout:
378     // - [0..159]   `addr`
379     // - [160..223] `startTimestamp`
380     // - [224]      `burned`
381     // - [225]      `nextInitialized`
382     // - [232..255] `extraData`
383     mapping(uint256 => uint256) private _packedOwnerships;
384 
385     // Mapping owner address to address data.
386     //
387     // Bits Layout:
388     // - [0..63]    `balance`
389     // - [64..127]  `numberMinted`
390     // - [128..191] `numberBurned`
391     // - [192..255] `aux`
392     mapping(address => uint256) private _packedAddressData;
393 
394     // Mapping from token ID to approved address.
395     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
396 
397     // Mapping from owner to operator approvals
398     mapping(address => mapping(address => bool)) private _operatorApprovals;
399 
400     constructor(string memory name_, string memory symbol_) {
401         _name = name_;
402         _symbol = symbol_;
403         _currentIndex = _startTokenId();
404     }
405 
406     /**
407      * @dev Returns the starting token ID.
408      * To change the starting token ID, please override this function.
409      */
410     function _startTokenId() internal view virtual returns (uint256) {
411         return 0;
412     }
413 
414     /**
415      * @dev Returns the next token ID to be minted.
416      */
417     function _nextTokenId() internal view virtual returns (uint256) {
418         return _currentIndex;
419     }
420 
421     /**
422      * @dev Returns the total number of tokens in existence.
423      * Burned tokens will reduce the count.
424      * To get the total number of tokens minted, please see `_totalMinted`.
425      */
426     function totalSupply() public view virtual override returns (uint256) {
427         // Counter underflow is impossible as _burnCounter cannot be incremented
428         // more than `_currentIndex - _startTokenId()` times.
429         unchecked {
430             return _currentIndex - _burnCounter - _startTokenId();
431         }
432     }
433 
434     /**
435      * @dev Returns the total amount of tokens minted in the contract.
436      */
437     function _totalMinted() internal view virtual returns (uint256) {
438         // Counter underflow is impossible as _currentIndex does not decrement,
439         // and it is initialized to `_startTokenId()`
440         unchecked {
441             return _currentIndex - _startTokenId();
442         }
443     }
444 
445     /**
446      * @dev Returns the total number of tokens burned.
447      */
448     function _totalBurned() internal view virtual returns (uint256) {
449         return _burnCounter;
450     }
451 
452     /**
453      * @dev See {IERC165-supportsInterface}.
454      */
455     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
456         // The interface IDs are constants representing the first 4 bytes of the XOR of
457         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
458         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
459         return
460             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
461             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
462             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
463     }
464 
465     /**
466      * @dev See {IERC721-balanceOf}.
467      */
468     function balanceOf(address owner) public view virtual override returns (uint256) {
469         if (owner == address(0)) revert BalanceQueryForZeroAddress();
470         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
471     }
472 
473     /**
474      * Returns the number of tokens minted by `owner`.
475      */
476     function _numberMinted(address owner) internal view virtual returns (uint256) {
477         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
478     }
479 
480     /**
481      * Returns the number of tokens burned by or on behalf of `owner`.
482      */
483     function _numberBurned(address owner) internal view virtual returns (uint256) {
484         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
485     }
486 
487     /**
488      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
489      */
490     function _getAux(address owner) internal view virtual returns (uint64) {
491         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
492     }
493 
494     /**
495      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
496      * If there are multiple variables, please pack them into a uint64.
497      */
498     function _setAux(address owner, uint64 aux) internal virtual {
499         uint256 packed = _packedAddressData[owner];
500         uint256 auxCasted;
501         // Cast `aux` with assembly to avoid redundant masking.
502         assembly {
503             auxCasted := aux
504         }
505         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
506         _packedAddressData[owner] = packed;
507     }
508 
509     /**
510      * Returns the packed ownership data of `tokenId`.
511      */
512     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
513         uint256 curr = tokenId;
514 
515         unchecked {
516             if (_startTokenId() <= curr)
517                 if (curr < _currentIndex) {
518                     uint256 packed = _packedOwnerships[curr];
519                     // If not burned.
520                     if (packed & BITMASK_BURNED == 0) {
521                         // Invariant:
522                         // There will always be an ownership that has an address and is not burned
523                         // before an ownership that does not have an address and is not burned.
524                         // Hence, curr will not underflow.
525                         //
526                         // We can directly compare the packed value.
527                         // If the address is zero, packed is zero.
528                         while (packed == 0) {
529                             packed = _packedOwnerships[--curr];
530                         }
531                         return packed;
532                     }
533                 }
534         }
535         revert OwnerQueryForNonexistentToken();
536     }
537 
538     /**
539      * Returns the unpacked `TokenOwnership` struct from `packed`.
540      */
541     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
542         ownership.addr = address(uint160(packed));
543         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
544         ownership.burned = packed & BITMASK_BURNED != 0;
545         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
546     }
547 
548     /**
549      * Returns the unpacked `TokenOwnership` struct at `index`.
550      */
551     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
552         return _unpackedOwnership(_packedOwnerships[index]);
553     }
554 
555     /**
556      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
557      */
558     function _initializeOwnershipAt(uint256 index) internal virtual {
559         if (_packedOwnerships[index] == 0) {
560             _packedOwnerships[index] = _packedOwnershipOf(index);
561         }
562     }
563 
564     /**
565      * Gas spent here starts off proportional to the maximum mint batch size.
566      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
567      */
568     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
569         return _unpackedOwnership(_packedOwnershipOf(tokenId));
570     }
571 
572     /**
573      * @dev Packs ownership data into a single uint256.
574      */
575     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
576         assembly {
577             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
578             owner := and(owner, BITMASK_ADDRESS)
579             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
580             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
581         }
582     }
583 
584     /**
585      * @dev See {IERC721-ownerOf}.
586      */
587     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
588         return address(uint160(_packedOwnershipOf(tokenId)));
589     }
590 
591     /**
592      * @dev See {IERC721Metadata-name}.
593      */
594     function name() public view virtual override returns (string memory) {
595         return _name;
596     }
597 
598     /**
599      * @dev See {IERC721Metadata-symbol}.
600      */
601     function symbol() public view virtual override returns (string memory) {
602         return _symbol;
603     }
604 
605     /**
606      * @dev See {IERC721Metadata-tokenURI}.
607      */
608     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
609         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
610 
611         string memory baseURI = _baseURI();
612         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
613     }
614 
615     /**
616      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
617      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
618      * by default, it can be overridden in child contracts.
619      */
620     function _baseURI() internal view virtual returns (string memory) {
621         return '';
622     }
623 
624     /**
625      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
626      */
627     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
628         // For branchless setting of the `nextInitialized` flag.
629         assembly {
630             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
631             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
632         }
633     }
634 
635     /**
636      * @dev See {IERC721-approve}.
637      */
638     function approve(address to, uint256 tokenId) public virtual override {
639         address owner = ownerOf(tokenId);
640 
641         if (_msgSenderERC721A() != owner)
642             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
643                 revert ApprovalCallerNotOwnerNorApproved();
644             }
645 
646         _tokenApprovals[tokenId].value = to;
647         emit Approval(owner, to, tokenId);
648     }
649 
650     /**
651      * @dev See {IERC721-getApproved}.
652      */
653     function getApproved(uint256 tokenId) public view virtual override returns (address) {
654         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
655 
656         return _tokenApprovals[tokenId].value;
657     }
658 
659     /**
660      * @dev See {IERC721-setApprovalForAll}.
661      */
662     function setApprovalForAll(address operator, bool approved) public virtual override {
663         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
664 
665         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
666         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
667     }
668 
669     /**
670      * @dev See {IERC721-isApprovedForAll}.
671      */
672     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
673         return _operatorApprovals[owner][operator];
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId
683     ) public virtual override {
684         safeTransferFrom(from, to, tokenId, '');
685     }
686 
687     /**
688      * @dev See {IERC721-safeTransferFrom}.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId,
694         bytes memory _data
695     ) public virtual override {
696         transferFrom(from, to, tokenId);
697         if (to.code.length != 0)
698             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
699                 revert TransferToNonERC721ReceiverImplementer();
700             }
701     }
702 
703     /**
704      * @dev Returns whether `tokenId` exists.
705      *
706      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
707      *
708      * Tokens start existing when they are minted (`_mint`),
709      */
710     function _exists(uint256 tokenId) internal view virtual returns (bool) {
711         return
712             _startTokenId() <= tokenId &&
713             tokenId < _currentIndex && // If within bounds,
714             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
715     }
716 
717     /**
718      * @dev Equivalent to `_safeMint(to, quantity, '')`.
719      */
720     function _safeMint(address to, uint256 quantity) internal virtual {
721         _safeMint(to, quantity, '');
722     }
723 
724     /**
725      * @dev Safely mints `quantity` tokens and transfers them to `to`.
726      *
727      * Requirements:
728      *
729      * - If `to` refers to a smart contract, it must implement
730      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
731      * - `quantity` must be greater than 0.
732      *
733      * See {_mint}.
734      *
735      * Emits a {Transfer} event for each mint.
736      */
737     function _safeMint(
738         address to,
739         uint256 quantity,
740         bytes memory _data
741     ) internal virtual {
742         _mint(to, quantity);
743 
744         unchecked {
745             if (to.code.length != 0) {
746                 uint256 end = _currentIndex;
747                 uint256 index = end - quantity;
748                 do {
749                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
750                         revert TransferToNonERC721ReceiverImplementer();
751                     }
752                 } while (index < end);
753                 // Reentrancy protection.
754                 if (_currentIndex != end) revert();
755             }
756         }
757     }
758 
759     /**
760      * @dev Mints `quantity` tokens and transfers them to `to`.
761      *
762      * Requirements:
763      *
764      * - `to` cannot be the zero address.
765      * - `quantity` must be greater than 0.
766      *
767      * Emits a {Transfer} event for each mint.
768      */
769     function _mint(address to, uint256 quantity) internal virtual {
770         uint256 startTokenId = _currentIndex;
771         if (to == address(0)) revert MintToZeroAddress();
772         if (quantity == 0) revert MintZeroQuantity();
773 
774         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
775 
776         // Overflows are incredibly unrealistic.
777         // `balance` and `numberMinted` have a maximum limit of 2**64.
778         // `tokenId` has a maximum limit of 2**256.
779         unchecked {
780             // Updates:
781             // - `balance += quantity`.
782             // - `numberMinted += quantity`.
783             //
784             // We can directly add to the `balance` and `numberMinted`.
785             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
786 
787             // Updates:
788             // - `address` to the owner.
789             // - `startTimestamp` to the timestamp of minting.
790             // - `burned` to `false`.
791             // - `nextInitialized` to `quantity == 1`.
792             _packedOwnerships[startTokenId] = _packOwnershipData(
793                 to,
794                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
795             );
796 
797             uint256 tokenId = startTokenId;
798             uint256 end = startTokenId + quantity;
799             do {
800                 emit Transfer(address(0), to, tokenId++);
801             } while (tokenId < end);
802 
803             _currentIndex = end;
804         }
805         _afterTokenTransfers(address(0), to, startTokenId, quantity);
806     }
807 
808     /**
809      * @dev Mints `quantity` tokens and transfers them to `to`.
810      *
811      * This function is intended for efficient minting only during contract creation.
812      *
813      * It emits only one {ConsecutiveTransfer} as defined in
814      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
815      * instead of a sequence of {Transfer} event(s).
816      *
817      * Calling this function outside of contract creation WILL make your contract
818      * non-compliant with the ERC721 standard.
819      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
820      * {ConsecutiveTransfer} event is only permissible during contract creation.
821      *
822      * Requirements:
823      *
824      * - `to` cannot be the zero address.
825      * - `quantity` must be greater than 0.
826      *
827      * Emits a {ConsecutiveTransfer} event.
828      */
829     function _mintERC2309(address to, uint256 quantity) internal virtual {
830         uint256 startTokenId = _currentIndex;
831         if (to == address(0)) revert MintToZeroAddress();
832         if (quantity == 0) revert MintZeroQuantity();
833         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
834 
835         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
836 
837         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
838         unchecked {
839             // Updates:
840             // - `balance += quantity`.
841             // - `numberMinted += quantity`.
842             //
843             // We can directly add to the `balance` and `numberMinted`.
844             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
845 
846             // Updates:
847             // - `address` to the owner.
848             // - `startTimestamp` to the timestamp of minting.
849             // - `burned` to `false`.
850             // - `nextInitialized` to `quantity == 1`.
851             _packedOwnerships[startTokenId] = _packOwnershipData(
852                 to,
853                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
854             );
855 
856             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
857 
858             _currentIndex = startTokenId + quantity;
859         }
860         _afterTokenTransfers(address(0), to, startTokenId, quantity);
861     }
862 
863     /**
864      * @dev Returns the storage slot and value for the approved address of `tokenId`.
865      */
866     function _getApprovedAddress(uint256 tokenId)
867         private
868         view
869         returns (uint256 approvedAddressSlot, address approvedAddress)
870     {
871         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
872         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
873         assembly {
874             approvedAddressSlot := tokenApproval.slot
875             approvedAddress := sload(approvedAddressSlot)
876         }
877     }
878 
879     /**
880      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
881      */
882     function _isOwnerOrApproved(
883         address approvedAddress,
884         address from,
885         address msgSender
886     ) private pure returns (bool result) {
887         assembly {
888             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
889             from := and(from, BITMASK_ADDRESS)
890             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
891             msgSender := and(msgSender, BITMASK_ADDRESS)
892             // `msgSender == from || msgSender == approvedAddress`.
893             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
894         }
895     }
896 
897     /**
898      * @dev Transfers `tokenId` from `from` to `to`.
899      *
900      * Requirements:
901      *
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must be owned by `from`.
904      *
905      * Emits a {Transfer} event.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public virtual override {
912         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
913 
914         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
915 
916         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
917 
918         // The nested ifs save around 20+ gas over a compound boolean condition.
919         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
920             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
921 
922         if (to == address(0)) revert TransferToZeroAddress();
923 
924         _beforeTokenTransfers(from, to, tokenId, 1);
925 
926         // Clear approvals from the previous owner.
927         assembly {
928             if approvedAddress {
929                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
930                 sstore(approvedAddressSlot, 0)
931             }
932         }
933 
934         // Underflow of the sender's balance is impossible because we check for
935         // ownership above and the recipient's balance can't realistically overflow.
936         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
937         unchecked {
938             // We can directly increment and decrement the balances.
939             --_packedAddressData[from]; // Updates: `balance -= 1`.
940             ++_packedAddressData[to]; // Updates: `balance += 1`.
941 
942             // Updates:
943             // - `address` to the next owner.
944             // - `startTimestamp` to the timestamp of transfering.
945             // - `burned` to `false`.
946             // - `nextInitialized` to `true`.
947             _packedOwnerships[tokenId] = _packOwnershipData(
948                 to,
949                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
950             );
951 
952             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
953             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
954                 uint256 nextTokenId = tokenId + 1;
955                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
956                 if (_packedOwnerships[nextTokenId] == 0) {
957                     // If the next slot is within bounds.
958                     if (nextTokenId != _currentIndex) {
959                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
960                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
961                     }
962                 }
963             }
964         }
965 
966         emit Transfer(from, to, tokenId);
967         _afterTokenTransfers(from, to, tokenId, 1);
968     }
969 
970     /**
971      * @dev Equivalent to `_burn(tokenId, false)`.
972      */
973     function _burn(uint256 tokenId) internal virtual {
974         _burn(tokenId, false);
975     }
976 
977     /**
978      * @dev Destroys `tokenId`.
979      * The approval is cleared when the token is burned.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must exist.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
988         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
989 
990         address from = address(uint160(prevOwnershipPacked));
991 
992         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
993 
994         if (approvalCheck) {
995             // The nested ifs save around 20+ gas over a compound boolean condition.
996             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
997                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
998         }
999 
1000         _beforeTokenTransfers(from, address(0), tokenId, 1);
1001 
1002         // Clear approvals from the previous owner.
1003         assembly {
1004             if approvedAddress {
1005                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1006                 sstore(approvedAddressSlot, 0)
1007             }
1008         }
1009 
1010         // Underflow of the sender's balance is impossible because we check for
1011         // ownership above and the recipient's balance can't realistically overflow.
1012         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1013         unchecked {
1014             // Updates:
1015             // - `balance -= 1`.
1016             // - `numberBurned += 1`.
1017             //
1018             // We can directly decrement the balance, and increment the number burned.
1019             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1020             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1021 
1022             // Updates:
1023             // - `address` to the last owner.
1024             // - `startTimestamp` to the timestamp of burning.
1025             // - `burned` to `true`.
1026             // - `nextInitialized` to `true`.
1027             _packedOwnerships[tokenId] = _packOwnershipData(
1028                 from,
1029                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1030             );
1031 
1032             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1033             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1034                 uint256 nextTokenId = tokenId + 1;
1035                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1036                 if (_packedOwnerships[nextTokenId] == 0) {
1037                     // If the next slot is within bounds.
1038                     if (nextTokenId != _currentIndex) {
1039                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1040                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1041                     }
1042                 }
1043             }
1044         }
1045 
1046         emit Transfer(from, address(0), tokenId);
1047         _afterTokenTransfers(from, address(0), tokenId, 1);
1048 
1049         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1050         unchecked {
1051             _burnCounter++;
1052         }
1053     }
1054 
1055     /**
1056      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1057      *
1058      * @param from address representing the previous owner of the given token ID
1059      * @param to target address that will receive the tokens
1060      * @param tokenId uint256 ID of the token to be transferred
1061      * @param _data bytes optional data to send along with the call
1062      * @return bool whether the call correctly returned the expected magic value
1063      */
1064     function _checkContractOnERC721Received(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) private returns (bool) {
1070         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1071             bytes4 retval
1072         ) {
1073             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1074         } catch (bytes memory reason) {
1075             if (reason.length == 0) {
1076                 revert TransferToNonERC721ReceiverImplementer();
1077             } else {
1078                 assembly {
1079                     revert(add(32, reason), mload(reason))
1080                 }
1081             }
1082         }
1083     }
1084 
1085     /**
1086      * @dev Directly sets the extra data for the ownership data `index`.
1087      */
1088     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1089         uint256 packed = _packedOwnerships[index];
1090         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1091         uint256 extraDataCasted;
1092         // Cast `extraData` with assembly to avoid redundant masking.
1093         assembly {
1094             extraDataCasted := extraData
1095         }
1096         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1097         _packedOwnerships[index] = packed;
1098     }
1099 
1100     /**
1101      * @dev Returns the next extra data for the packed ownership data.
1102      * The returned result is shifted into position.
1103      */
1104     function _nextExtraData(
1105         address from,
1106         address to,
1107         uint256 prevOwnershipPacked
1108     ) private view returns (uint256) {
1109         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1110         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1111     }
1112 
1113     /**
1114      * @dev Called during each token transfer to set the 24bit `extraData` field.
1115      * Intended to be overridden by the cosumer contract.
1116      *
1117      * `previousExtraData` - the value of `extraData` before transfer.
1118      *
1119      * Calling conditions:
1120      *
1121      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1122      * transferred to `to`.
1123      * - When `from` is zero, `tokenId` will be minted for `to`.
1124      * - When `to` is zero, `tokenId` will be burned by `from`.
1125      * - `from` and `to` are never both zero.
1126      */
1127     function _extraData(
1128         address from,
1129         address to,
1130         uint24 previousExtraData
1131     ) internal view virtual returns (uint24) {}
1132 
1133     /**
1134      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1135      * This includes minting.
1136      * And also called before burning one token.
1137      *
1138      * startTokenId - the first token id to be transferred
1139      * quantity - the amount to be transferred
1140      *
1141      * Calling conditions:
1142      *
1143      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1144      * transferred to `to`.
1145      * - When `from` is zero, `tokenId` will be minted for `to`.
1146      * - When `to` is zero, `tokenId` will be burned by `from`.
1147      * - `from` and `to` are never both zero.
1148      */
1149     function _beforeTokenTransfers(
1150         address from,
1151         address to,
1152         uint256 startTokenId,
1153         uint256 quantity
1154     ) internal virtual {}
1155 
1156     /**
1157      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1158      * This includes minting.
1159      * And also called after one token has been burned.
1160      *
1161      * startTokenId - the first token id to be transferred
1162      * quantity - the amount to be transferred
1163      *
1164      * Calling conditions:
1165      *
1166      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1167      * transferred to `to`.
1168      * - When `from` is zero, `tokenId` has been minted for `to`.
1169      * - When `to` is zero, `tokenId` has been burned by `from`.
1170      * - `from` and `to` are never both zero.
1171      */
1172     function _afterTokenTransfers(
1173         address from,
1174         address to,
1175         uint256 startTokenId,
1176         uint256 quantity
1177     ) internal virtual {}
1178 
1179     /**
1180      * @dev Returns the message sender (defaults to `msg.sender`).
1181      *
1182      * If you are writing GSN compatible contracts, you need to override this function.
1183      */
1184     function _msgSenderERC721A() internal view virtual returns (address) {
1185         return msg.sender;
1186     }
1187 
1188     /**
1189      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1190      */
1191     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1192         assembly {
1193             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1194             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1195             // We will need 1 32-byte word to store the length,
1196             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1197             ptr := add(mload(0x40), 128)
1198             // Update the free memory pointer to allocate.
1199             mstore(0x40, ptr)
1200 
1201             // Cache the end of the memory to calculate the length later.
1202             let end := ptr
1203 
1204             // We write the string from the rightmost digit to the leftmost digit.
1205             // The following is essentially a do-while loop that also handles the zero case.
1206             // Costs a bit more than early returning for the zero case,
1207             // but cheaper in terms of deployment and overall runtime costs.
1208             for {
1209                 // Initialize and perform the first pass without check.
1210                 let temp := value
1211                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1212                 ptr := sub(ptr, 1)
1213                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1214                 mstore8(ptr, add(48, mod(temp, 10)))
1215                 temp := div(temp, 10)
1216             } temp {
1217                 // Keep dividing `temp` until zero.
1218                 temp := div(temp, 10)
1219             } {
1220                 // Body of the for loop.
1221                 ptr := sub(ptr, 1)
1222                 mstore8(ptr, add(48, mod(temp, 10)))
1223             }
1224 
1225             let length := sub(end, ptr)
1226             // Move the pointer 32 bytes leftwards to make room for the length.
1227             ptr := sub(ptr, 32)
1228             // Store the length.
1229             mstore(ptr, length)
1230         }
1231     }
1232 }
1233 
1234 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1235 
1236 
1237 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1238 
1239 pragma solidity ^0.8.0;
1240 
1241 /**
1242  * @dev Interface of the ERC165 standard, as defined in the
1243  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1244  *
1245  * Implementers can declare support of contract interfaces, which can then be
1246  * queried by others ({ERC165Checker}).
1247  *
1248  * For an implementation, see {ERC165}.
1249  */
1250 interface IERC165 {
1251     /**
1252      * @dev Returns true if this contract implements the interface defined by
1253      * `interfaceId`. See the corresponding
1254      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1255      * to learn more about how these ids are created.
1256      *
1257      * This function call must use less than 30 000 gas.
1258      */
1259     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1260 }
1261 
1262 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1263 
1264 
1265 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1266 
1267 pragma solidity ^0.8.0;
1268 
1269 
1270 /**
1271  * @dev Required interface of an ERC721 compliant contract.
1272  */
1273 interface IERC721 is IERC165 {
1274     /**
1275      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1276      */
1277     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1278 
1279     /**
1280      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1281      */
1282     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1283 
1284     /**
1285      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1286      */
1287     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1288 
1289     /**
1290      * @dev Returns the number of tokens in ``owner``'s account.
1291      */
1292     function balanceOf(address owner) external view returns (uint256 balance);
1293 
1294     /**
1295      * @dev Returns the owner of the `tokenId` token.
1296      *
1297      * Requirements:
1298      *
1299      * - `tokenId` must exist.
1300      */
1301     function ownerOf(uint256 tokenId) external view returns (address owner);
1302 
1303     /**
1304      * @dev Safely transfers `tokenId` token from `from` to `to`.
1305      *
1306      * Requirements:
1307      *
1308      * - `from` cannot be the zero address.
1309      * - `to` cannot be the zero address.
1310      * - `tokenId` token must exist and be owned by `from`.
1311      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1312      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function safeTransferFrom(
1317         address from,
1318         address to,
1319         uint256 tokenId,
1320         bytes calldata data
1321     ) external;
1322 
1323     /**
1324      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1325      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1326      *
1327      * Requirements:
1328      *
1329      * - `from` cannot be the zero address.
1330      * - `to` cannot be the zero address.
1331      * - `tokenId` token must exist and be owned by `from`.
1332      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1333      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function safeTransferFrom(
1338         address from,
1339         address to,
1340         uint256 tokenId
1341     ) external;
1342 
1343     /**
1344      * @dev Transfers `tokenId` token from `from` to `to`.
1345      *
1346      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1347      *
1348      * Requirements:
1349      *
1350      * - `from` cannot be the zero address.
1351      * - `to` cannot be the zero address.
1352      * - `tokenId` token must be owned by `from`.
1353      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1354      *
1355      * Emits a {Transfer} event.
1356      */
1357     function transferFrom(
1358         address from,
1359         address to,
1360         uint256 tokenId
1361     ) external;
1362 
1363     /**
1364      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1365      * The approval is cleared when the token is transferred.
1366      *
1367      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1368      *
1369      * Requirements:
1370      *
1371      * - The caller must own the token or be an approved operator.
1372      * - `tokenId` must exist.
1373      *
1374      * Emits an {Approval} event.
1375      */
1376     function approve(address to, uint256 tokenId) external;
1377 
1378     /**
1379      * @dev Approve or remove `operator` as an operator for the caller.
1380      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1381      *
1382      * Requirements:
1383      *
1384      * - The `operator` cannot be the caller.
1385      *
1386      * Emits an {ApprovalForAll} event.
1387      */
1388     function setApprovalForAll(address operator, bool _approved) external;
1389 
1390     /**
1391      * @dev Returns the account approved for `tokenId` token.
1392      *
1393      * Requirements:
1394      *
1395      * - `tokenId` must exist.
1396      */
1397     function getApproved(uint256 tokenId) external view returns (address operator);
1398 
1399     /**
1400      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1401      *
1402      * See {setApprovalForAll}
1403      */
1404     function isApprovedForAll(address owner, address operator) external view returns (bool);
1405 }
1406 
1407 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1408 
1409 
1410 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1411 
1412 pragma solidity ^0.8.0;
1413 
1414 
1415 /**
1416  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1417  * @dev See https://eips.ethereum.org/EIPS/eip-721
1418  */
1419 interface IERC721Metadata is IERC721 {
1420     /**
1421      * @dev Returns the token collection name.
1422      */
1423     function name() external view returns (string memory);
1424 
1425     /**
1426      * @dev Returns the token collection symbol.
1427      */
1428     function symbol() external view returns (string memory);
1429 
1430     /**
1431      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1432      */
1433     function tokenURI(uint256 tokenId) external view returns (string memory);
1434 }
1435 
1436 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1437 
1438 
1439 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1440 
1441 pragma solidity ^0.8.0;
1442 
1443 
1444 /**
1445  * @dev Implementation of the {IERC165} interface.
1446  *
1447  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1448  * for the additional interface id that will be supported. For example:
1449  *
1450  * ```solidity
1451  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1452  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1453  * }
1454  * ```
1455  *
1456  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1457  */
1458 abstract contract ERC165 is IERC165 {
1459     /**
1460      * @dev See {IERC165-supportsInterface}.
1461      */
1462     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1463         return interfaceId == type(IERC165).interfaceId;
1464     }
1465 }
1466 
1467 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1468 
1469 
1470 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1471 
1472 pragma solidity ^0.8.0;
1473 
1474 /**
1475  * @title ERC721 token receiver interface
1476  * @dev Interface for any contract that wants to support safeTransfers
1477  * from ERC721 asset contracts.
1478  */
1479 interface IERC721Receiver {
1480     /**
1481      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1482      * by `operator` from `from`, this function is called.
1483      *
1484      * It must return its Solidity selector to confirm the token transfer.
1485      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1486      *
1487      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1488      */
1489     function onERC721Received(
1490         address operator,
1491         address from,
1492         uint256 tokenId,
1493         bytes calldata data
1494     ) external returns (bytes4);
1495 }
1496 
1497 // File: @openzeppelin/contracts/utils/Address.sol
1498 
1499 
1500 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1501 
1502 pragma solidity ^0.8.1;
1503 
1504 /**
1505  * @dev Collection of functions related to the address type
1506  */
1507 library Address {
1508     /**
1509      * @dev Returns true if `account` is a contract.
1510      *
1511      * [IMPORTANT]
1512      * ====
1513      * It is unsafe to assume that an address for which this function returns
1514      * false is an externally-owned account (EOA) and not a contract.
1515      *
1516      * Among others, `isContract` will return false for the following
1517      * types of addresses:
1518      *
1519      *  - an externally-owned account
1520      *  - a contract in construction
1521      *  - an address where a contract will be created
1522      *  - an address where a contract lived, but was destroyed
1523      * ====
1524      *
1525      * [IMPORTANT]
1526      * ====
1527      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1528      *
1529      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1530      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1531      * constructor.
1532      * ====
1533      */
1534     function isContract(address account) internal view returns (bool) {
1535         // This method relies on extcodesize/address.code.length, which returns 0
1536         // for contracts in construction, since the code is only stored at the end
1537         // of the constructor execution.
1538 
1539         return account.code.length > 0;
1540     }
1541 
1542     /**
1543      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1544      * `recipient`, forwarding all available gas and reverting on errors.
1545      *
1546      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1547      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1548      * imposed by `transfer`, making them unable to receive funds via
1549      * `transfer`. {sendValue} removes this limitation.
1550      *
1551      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1552      *
1553      * IMPORTANT: because control is transferred to `recipient`, care must be
1554      * taken to not create reentrancy vulnerabilities. Consider using
1555      * {ReentrancyGuard} or the
1556      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1557      */
1558     function sendValue(address payable recipient, uint256 amount) internal {
1559         require(address(this).balance >= amount, "Address: insufficient balance");
1560 
1561         (bool success, ) = recipient.call{value: amount}("");
1562         require(success, "Address: unable to send value, recipient may have reverted");
1563     }
1564 
1565     /**
1566      * @dev Performs a Solidity function call using a low level `call`. A
1567      * plain `call` is an unsafe replacement for a function call: use this
1568      * function instead.
1569      *
1570      * If `target` reverts with a revert reason, it is bubbled up by this
1571      * function (like regular Solidity function calls).
1572      *
1573      * Returns the raw returned data. To convert to the expected return value,
1574      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1575      *
1576      * Requirements:
1577      *
1578      * - `target` must be a contract.
1579      * - calling `target` with `data` must not revert.
1580      *
1581      * _Available since v3.1._
1582      */
1583     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1584         return functionCall(target, data, "Address: low-level call failed");
1585     }
1586 
1587     /**
1588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1589      * `errorMessage` as a fallback revert reason when `target` reverts.
1590      *
1591      * _Available since v3.1._
1592      */
1593     function functionCall(
1594         address target,
1595         bytes memory data,
1596         string memory errorMessage
1597     ) internal returns (bytes memory) {
1598         return functionCallWithValue(target, data, 0, errorMessage);
1599     }
1600 
1601     /**
1602      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1603      * but also transferring `value` wei to `target`.
1604      *
1605      * Requirements:
1606      *
1607      * - the calling contract must have an ETH balance of at least `value`.
1608      * - the called Solidity function must be `payable`.
1609      *
1610      * _Available since v3.1._
1611      */
1612     function functionCallWithValue(
1613         address target,
1614         bytes memory data,
1615         uint256 value
1616     ) internal returns (bytes memory) {
1617         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1618     }
1619 
1620     /**
1621      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1622      * with `errorMessage` as a fallback revert reason when `target` reverts.
1623      *
1624      * _Available since v3.1._
1625      */
1626     function functionCallWithValue(
1627         address target,
1628         bytes memory data,
1629         uint256 value,
1630         string memory errorMessage
1631     ) internal returns (bytes memory) {
1632         require(address(this).balance >= value, "Address: insufficient balance for call");
1633         require(isContract(target), "Address: call to non-contract");
1634 
1635         (bool success, bytes memory returndata) = target.call{value: value}(data);
1636         return verifyCallResult(success, returndata, errorMessage);
1637     }
1638 
1639     /**
1640      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1641      * but performing a static call.
1642      *
1643      * _Available since v3.3._
1644      */
1645     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1646         return functionStaticCall(target, data, "Address: low-level static call failed");
1647     }
1648 
1649     /**
1650      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1651      * but performing a static call.
1652      *
1653      * _Available since v3.3._
1654      */
1655     function functionStaticCall(
1656         address target,
1657         bytes memory data,
1658         string memory errorMessage
1659     ) internal view returns (bytes memory) {
1660         require(isContract(target), "Address: static call to non-contract");
1661 
1662         (bool success, bytes memory returndata) = target.staticcall(data);
1663         return verifyCallResult(success, returndata, errorMessage);
1664     }
1665 
1666     /**
1667      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1668      * but performing a delegate call.
1669      *
1670      * _Available since v3.4._
1671      */
1672     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1673         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1674     }
1675 
1676     /**
1677      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1678      * but performing a delegate call.
1679      *
1680      * _Available since v3.4._
1681      */
1682     function functionDelegateCall(
1683         address target,
1684         bytes memory data,
1685         string memory errorMessage
1686     ) internal returns (bytes memory) {
1687         require(isContract(target), "Address: delegate call to non-contract");
1688 
1689         (bool success, bytes memory returndata) = target.delegatecall(data);
1690         return verifyCallResult(success, returndata, errorMessage);
1691     }
1692 
1693     /**
1694      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1695      * revert reason using the provided one.
1696      *
1697      * _Available since v4.3._
1698      */
1699     function verifyCallResult(
1700         bool success,
1701         bytes memory returndata,
1702         string memory errorMessage
1703     ) internal pure returns (bytes memory) {
1704         if (success) {
1705             return returndata;
1706         } else {
1707             // Look for revert reason and bubble it up if present
1708             if (returndata.length > 0) {
1709                 // The easiest way to bubble the revert reason is using memory via assembly
1710                 /// @solidity memory-safe-assembly
1711                 assembly {
1712                     let returndata_size := mload(returndata)
1713                     revert(add(32, returndata), returndata_size)
1714                 }
1715             } else {
1716                 revert(errorMessage);
1717             }
1718         }
1719     }
1720 }
1721 
1722 // File: @openzeppelin/contracts/utils/Context.sol
1723 
1724 
1725 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1726 
1727 pragma solidity ^0.8.0;
1728 
1729 /**
1730  * @dev Provides information about the current execution context, including the
1731  * sender of the transaction and its data. While these are generally available
1732  * via msg.sender and msg.data, they should not be accessed in such a direct
1733  * manner, since when dealing with meta-transactions the account sending and
1734  * paying for execution may not be the actual sender (as far as an application
1735  * is concerned).
1736  *
1737  * This contract is only required for intermediate, library-like contracts.
1738  */
1739 abstract contract Context {
1740     function _msgSender() internal view virtual returns (address) {
1741         return msg.sender;
1742     }
1743 
1744     function _msgData() internal view virtual returns (bytes calldata) {
1745         return msg.data;
1746     }
1747 }
1748 
1749 // File: @openzeppelin/contracts/access/Ownable.sol
1750 
1751 
1752 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1753 
1754 pragma solidity ^0.8.0;
1755 
1756 
1757 /**
1758  * @dev Contract module which provides a basic access control mechanism, where
1759  * there is an account (an owner) that can be granted exclusive access to
1760  * specific functions.
1761  *
1762  * By default, the owner account will be the one that deploys the contract. This
1763  * can later be changed with {transferOwnership}.
1764  *
1765  * This module is used through inheritance. It will make available the modifier
1766  * `onlyOwner`, which can be applied to your functions to restrict their use to
1767  * the owner.
1768  */
1769 abstract contract Ownable is Context {
1770     address private _owner;
1771 
1772     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1773 
1774     /**
1775      * @dev Initializes the contract setting the deployer as the initial owner.
1776      */
1777     constructor() {
1778         _transferOwnership(_msgSender());
1779     }
1780 
1781     /**
1782      * @dev Throws if called by any account other than the owner.
1783      */
1784     modifier onlyOwner() {
1785         _checkOwner();
1786         _;
1787     }
1788 
1789     /**
1790      * @dev Returns the address of the current owner.
1791      */
1792     function owner() public view virtual returns (address) {
1793         return _owner;
1794     }
1795 
1796     /**
1797      * @dev Throws if the sender is not the owner.
1798      */
1799     function _checkOwner() internal view virtual {
1800         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1801     }
1802 
1803     /**
1804      * @dev Leaves the contract without owner. It will not be possible to call
1805      * `onlyOwner` functions anymore. Can only be called by the current owner.
1806      *
1807      * NOTE: Renouncing ownership will leave the contract without an owner,
1808      * thereby removing any functionality that is only available to the owner.
1809      */
1810     function renounceOwnership() public virtual onlyOwner {
1811         _transferOwnership(address(0));
1812     }
1813 
1814     /**
1815      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1816      * Can only be called by the current owner.
1817      */
1818     function transferOwnership(address newOwner) public virtual onlyOwner {
1819         require(newOwner != address(0), "Ownable: new owner is the zero address");
1820         _transferOwnership(newOwner);
1821     }
1822 
1823     /**
1824      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1825      * Internal function without access restriction.
1826      */
1827     function _transferOwnership(address newOwner) internal virtual {
1828         address oldOwner = _owner;
1829         _owner = newOwner;
1830         emit OwnershipTransferred(oldOwner, newOwner);
1831     }
1832 }
1833 
1834 // File: @openzeppelin/contracts/utils/Strings.sol
1835 
1836 
1837 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1838 
1839 pragma solidity ^0.8.0;
1840 
1841 /**
1842  * @dev String operations.
1843  */
1844 library Strings {
1845     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1846     uint8 private constant _ADDRESS_LENGTH = 20;
1847 
1848     /**
1849      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1850      */
1851     function toString(uint256 value) internal pure returns (string memory) {
1852         // Inspired by OraclizeAPI's implementation - MIT licence
1853         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1854 
1855         if (value == 0) {
1856             return "0";
1857         }
1858         uint256 temp = value;
1859         uint256 digits;
1860         while (temp != 0) {
1861             digits++;
1862             temp /= 10;
1863         }
1864         bytes memory buffer = new bytes(digits);
1865         while (value != 0) {
1866             digits -= 1;
1867             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1868             value /= 10;
1869         }
1870         return string(buffer);
1871     }
1872 
1873     /**
1874      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1875      */
1876     function toHexString(uint256 value) internal pure returns (string memory) {
1877         if (value == 0) {
1878             return "0x00";
1879         }
1880         uint256 temp = value;
1881         uint256 length = 0;
1882         while (temp != 0) {
1883             length++;
1884             temp >>= 8;
1885         }
1886         return toHexString(value, length);
1887     }
1888 
1889     /**
1890      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1891      */
1892     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1893         bytes memory buffer = new bytes(2 * length + 2);
1894         buffer[0] = "0";
1895         buffer[1] = "x";
1896         for (uint256 i = 2 * length + 1; i > 1; --i) {
1897             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1898             value >>= 4;
1899         }
1900         require(value == 0, "Strings: hex length insufficient");
1901         return string(buffer);
1902     }
1903 
1904     /**
1905      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1906      */
1907     function toHexString(address addr) internal pure returns (string memory) {
1908         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1909     }
1910 }
1911 
1912 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1913 
1914 
1915 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1916 
1917 pragma solidity ^0.8.0;
1918 
1919 /**
1920  * @dev Contract module that helps prevent reentrant calls to a function.
1921  *
1922  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1923  * available, which can be applied to functions to make sure there are no nested
1924  * (reentrant) calls to them.
1925  *
1926  * Note that because there is a single `nonReentrant` guard, functions marked as
1927  * `nonReentrant` may not call one another. This can be worked around by making
1928  * those functions `private`, and then adding `external` `nonReentrant` entry
1929  * points to them.
1930  *
1931  * TIP: If you would like to learn more about reentrancy and alternative ways
1932  * to protect against it, check out our blog post
1933  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1934  */
1935 abstract contract ReentrancyGuard {
1936     // Booleans are more expensive than uint256 or any type that takes up a full
1937     // word because each write operation emits an extra SLOAD to first read the
1938     // slot's contents, replace the bits taken up by the boolean, and then write
1939     // back. This is the compiler's defense against contract upgrades and
1940     // pointer aliasing, and it cannot be disabled.
1941 
1942     // The values being non-zero value makes deployment a bit more expensive,
1943     // but in exchange the refund on every call to nonReentrant will be lower in
1944     // amount. Since refunds are capped to a percentage of the total
1945     // transaction's gas, it is best to keep them low in cases like this one, to
1946     // increase the likelihood of the full refund coming into effect.
1947     uint256 private constant _NOT_ENTERED = 1;
1948     uint256 private constant _ENTERED = 2;
1949 
1950     uint256 private _status;
1951 
1952     constructor() {
1953         _status = _NOT_ENTERED;
1954     }
1955 
1956     /**
1957      * @dev Prevents a contract from calling itself, directly or indirectly.
1958      * Calling a `nonReentrant` function from another `nonReentrant`
1959      * function is not supported. It is possible to prevent this from happening
1960      * by making the `nonReentrant` function external, and making it call a
1961      * `private` function that does the actual work.
1962      */
1963     modifier nonReentrant() {
1964         // On the first call to nonReentrant, _notEntered will be true
1965         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1966 
1967         // Any calls to nonReentrant after this point will fail
1968         _status = _ENTERED;
1969 
1970         _;
1971 
1972         // By storing the original value once again, a refund is triggered (see
1973         // https://eips.ethereum.org/EIPS/eip-2200)
1974         _status = _NOT_ENTERED;
1975     }
1976 }
1977 
1978 // File: contracts/y33ts.sol
1979 
1980 
1981 
1982 pragma solidity ^0.8.4;
1983 
1984 
1985 
1986 
1987 
1988 
1989 
1990 
1991 
1992 
1993 
1994 
1995 pragma solidity ^0.8.0;
1996 
1997 contract y33ts is ERC721A, Ownable, ReentrancyGuard {
1998   using Address for address;
1999   using Strings for uint;
2000 
2001   string  public  baseTokenURI = "ipfs://QmcEb4WpgL6cdFgjfVhxshMX4d9WA1PqPBKL4ywrrxHB74";
2002   uint256 public  maxSupply = 999;
2003   uint256 public  MAX_MINTS_PER_TX = 3;
2004   uint256 public  PUBLIC_SALE_PRICE = 0.00333 ether;
2005   uint256 public  NUM_FREE_MINTS = 99;
2006   uint256 public  MAX_FREE_PER_WALLET = 3;
2007   uint256 public freeNFTAlreadyMinted = 0;
2008   bool public isPublicSaleActive = false;
2009 
2010   constructor(
2011 
2012   ) ERC721A("y33ts", "y33ts") {
2013 
2014   }
2015 
2016 
2017   function mint(uint256 numberOfTokens)
2018       external
2019       payable
2020   {
2021     require(isPublicSaleActive, "Public sale is not open");
2022     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
2023 
2024     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
2025         require(
2026             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2027             "Incorrect ETH value sent"
2028         );
2029     } else {
2030         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
2031         require(
2032             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2033             "Incorrect ETH value sent"
2034         );
2035         require(
2036             numberOfTokens <= MAX_MINTS_PER_TX,
2037             "Max mints per transaction exceeded"
2038         );
2039         } else {
2040             require(
2041                 numberOfTokens <= MAX_FREE_PER_WALLET,
2042                 "Max mints per transaction exceeded"
2043             );
2044             freeNFTAlreadyMinted += numberOfTokens;
2045         }
2046     }
2047     _safeMint(msg.sender, numberOfTokens);
2048   }
2049 
2050   function setBaseURI(string memory baseURI)
2051     public
2052     onlyOwner
2053   {
2054     baseTokenURI = baseURI;
2055   }
2056 
2057   function treasuryMint(uint quantity)
2058     public
2059     onlyOwner
2060   {
2061     require(
2062       quantity > 0,
2063       "Invalid mint amount"
2064     );
2065     require(
2066       totalSupply() + quantity <= maxSupply,
2067       "Maximum supply exceeded"
2068     );
2069     _safeMint(msg.sender, quantity);
2070   }
2071 
2072   function withdraw()
2073     public
2074     onlyOwner
2075     nonReentrant
2076   {
2077     Address.sendValue(payable(msg.sender), address(this).balance);
2078   }
2079 
2080   function tokenURI(uint _tokenId)
2081     public
2082     view
2083     virtual
2084     override
2085     returns (string memory)
2086   {
2087     require(
2088       _exists(_tokenId),
2089       "ERC721Metadata: URI query for nonexistent token"
2090     );
2091     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
2092   }
2093 
2094   function _baseURI()
2095     internal
2096     view
2097     virtual
2098     override
2099     returns (string memory)
2100   {
2101     return baseTokenURI;
2102   }
2103 
2104   function setIsPublicSaleActive(bool _isPublicSaleActive)
2105       external
2106       onlyOwner
2107   {
2108       isPublicSaleActive = _isPublicSaleActive;
2109   }
2110 
2111   function setNumFreeMints(uint256 _numfreemints)
2112       external
2113       onlyOwner
2114   {
2115       NUM_FREE_MINTS = _numfreemints;
2116   }
2117 
2118   function setSalePrice(uint256 _price)
2119       external
2120       onlyOwner
2121   {
2122       PUBLIC_SALE_PRICE = _price;
2123   }
2124 
2125   function setMaxLimitPerTransaction(uint256 _limit)
2126       external
2127       onlyOwner
2128   {
2129       MAX_MINTS_PER_TX = _limit;
2130   }
2131 
2132   function setFreeLimitPerWallet(uint256 _limit)
2133       external
2134       onlyOwner
2135   {
2136       MAX_FREE_PER_WALLET = _limit;
2137   }
2138 }