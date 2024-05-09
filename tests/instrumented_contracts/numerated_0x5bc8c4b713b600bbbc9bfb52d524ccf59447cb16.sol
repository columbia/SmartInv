1 // File: contracts/IERC721A.sol
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
280 // File: contracts/ERC721A_royalty.sol
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
313     // Mask of an entry in packed address data.
314     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
315 
316     // The bit position of `numberMinted` in packed address data.
317     uint256 private constant BITPOS_NUMBER_MINTED = 64;
318 
319     // The bit position of `numberBurned` in packed address data.
320     uint256 private constant BITPOS_NUMBER_BURNED = 128;
321 
322     // The bit position of `aux` in packed address data.
323     uint256 private constant BITPOS_AUX = 192;
324 
325     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
326     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
327 
328     // The bit position of `startTimestamp` in packed ownership.
329     uint256 private constant BITPOS_START_TIMESTAMP = 160;
330 
331     // The bit mask of the `burned` bit in packed ownership.
332     uint256 private constant BITMASK_BURNED = 1 << 224;
333 
334     // The bit position of the `nextInitialized` bit in packed ownership.
335     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
336 
337     // The bit mask of the `nextInitialized` bit in packed ownership.
338     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
339 
340     // The bit position of `extraData` in packed ownership.
341     uint256 private constant BITPOS_EXTRA_DATA = 232;
342 
343     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
344     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
345 
346     // The mask of the lower 160 bits for addresses.
347     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
348 
349     // The maximum `quantity` that can be minted with `_mintERC2309`.
350     // This limit is to prevent overflows on the address data entries.
351     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
352     // is required to cause an overflow, which is unrealistic.
353     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
354 
355     // The tokenId of the next token to be minted.
356     uint256 private _currentIndex;
357 
358     // The number of tokens burned.
359     uint256 private _burnCounter;
360 
361     // Token name
362     string private _name;
363 
364     // Token symbol
365     string private _symbol;
366 
367     // Mapping from token ID to ownership details
368     // An empty struct value does not necessarily mean the token is unowned.
369     // See `_packedOwnershipOf` implementation for details.
370     //
371     // Bits Layout:
372     // - [0..159]   `addr`
373     // - [160..223] `startTimestamp`
374     // - [224]      `burned`
375     // - [225]      `nextInitialized`
376     // - [232..255] `extraData`
377     mapping(uint256 => uint256) private _packedOwnerships;
378 
379     // Mapping owner address to address data.
380     //
381     // Bits Layout:
382     // - [0..63]    `balance`
383     // - [64..127]  `numberMinted`
384     // - [128..191] `numberBurned`
385     // - [192..255] `aux`
386     mapping(address => uint256) private _packedAddressData;
387 
388     // Mapping from token ID to approved address.
389     mapping(uint256 => address) private _tokenApprovals;
390 
391     // Mapping from owner to operator approvals
392     mapping(address => mapping(address => bool)) private _operatorApprovals;
393 
394     constructor(string memory name_, string memory symbol_) {
395         _name = name_;
396         _symbol = symbol_;
397         _currentIndex = _startTokenId();
398     }
399 
400     /**
401      * @dev Returns the starting token ID.
402      * To change the starting token ID, please override this function.
403      */
404     function _startTokenId() internal view virtual returns (uint256) {
405         return 1;
406     }
407 
408     /**
409      * @dev Returns the next token ID to be minted.
410      */
411     function _nextTokenId() internal view returns (uint256) {
412         return _currentIndex;
413     }
414 
415     /**
416      * @dev Returns the total number of tokens in existence.
417      * Burned tokens will reduce the count.
418      * To get the total number of tokens minted, please see `_totalMinted`.
419      */
420     function totalSupply() public view override returns (uint256) {
421         // Counter underflow is impossible as _burnCounter cannot be incremented
422         // more than `_currentIndex - _startTokenId()` times.
423         unchecked {
424             return _currentIndex - _burnCounter - _startTokenId();
425         }
426     }
427 
428     /**
429      * @dev Returns the total amount of tokens minted in the contract.
430      */
431     function _totalMinted() internal view returns (uint256) {
432         // Counter underflow is impossible as _currentIndex does not decrement,
433         // and it is initialized to `_startTokenId()`
434         unchecked {
435             return _currentIndex - _startTokenId();
436         }
437     }
438 
439     /**
440      * @dev Returns the total number of tokens burned.
441      */
442     function _totalBurned() internal view returns (uint256) {
443         return _burnCounter;
444     }
445 
446     /**
447      * @dev See {IERC165-supportsInterface}.
448      */
449     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
450         // The interface IDs are constants representing the first 4 bytes of the XOR of
451         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
452         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
453         return
454             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
455             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
456             interfaceId == 0x2a55205a || // ERC 2981 rotyalty
457             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
458     }
459 
460     /**
461      * @dev See {IERC721-balanceOf}.
462      */
463     function balanceOf(address owner) public view override returns (uint256) {
464         if (owner == address(0)) revert BalanceQueryForZeroAddress();
465         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
466     }
467 
468     /**
469      * Returns the number of tokens minted by `owner`.
470      */
471     function _numberMinted(address owner) internal view returns (uint256) {
472         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
473     }
474 
475     /**
476      * Returns the number of tokens burned by or on behalf of `owner`.
477      */
478     function _numberBurned(address owner) internal view returns (uint256) {
479         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
480     }
481 
482     /**
483      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
484      */
485     function _getAux(address owner) internal view returns (uint64) {
486         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
487     }
488 
489     /**
490      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
491      * If there are multiple variables, please pack them into a uint64.
492      */
493     function _setAux(address owner, uint64 aux) internal {
494         uint256 packed = _packedAddressData[owner];
495         uint256 auxCasted;
496         // Cast `aux` with assembly to avoid redundant masking.
497         assembly {
498             auxCasted := aux
499         }
500         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
501         _packedAddressData[owner] = packed;
502     }
503 
504     /**
505      * Returns the packed ownership data of `tokenId`.
506      */
507     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
508         uint256 curr = tokenId;
509 
510         unchecked {
511             if (_startTokenId() <= curr)
512                 if (curr < _currentIndex) {
513                     uint256 packed = _packedOwnerships[curr];
514                     // If not burned.
515                     if (packed & BITMASK_BURNED == 0) {
516                         // Invariant:
517                         // There will always be an ownership that has an address and is not burned
518                         // before an ownership that does not have an address and is not burned.
519                         // Hence, curr will not underflow.
520                         //
521                         // We can directly compare the packed value.
522                         // If the address is zero, packed is zero.
523                         while (packed == 0) {
524                             packed = _packedOwnerships[--curr];
525                         }
526                         return packed;
527                     }
528                 }
529         }
530         revert OwnerQueryForNonexistentToken();
531     }
532 
533     /**
534      * Returns the unpacked `TokenOwnership` struct from `packed`.
535      */
536     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
537         ownership.addr = address(uint160(packed));
538         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
539         ownership.burned = packed & BITMASK_BURNED != 0;
540         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
541     }
542 
543     /**
544      * Returns the unpacked `TokenOwnership` struct at `index`.
545      */
546     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
547         return _unpackedOwnership(_packedOwnerships[index]);
548     }
549 
550     /**
551      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
552      */
553     function _initializeOwnershipAt(uint256 index) internal {
554         if (_packedOwnerships[index] == 0) {
555             _packedOwnerships[index] = _packedOwnershipOf(index);
556         }
557     }
558 
559     /**
560      * Gas spent here starts off proportional to the maximum mint batch size.
561      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
562      */
563     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
564         return _unpackedOwnership(_packedOwnershipOf(tokenId));
565     }
566 
567     /**
568      * @dev Packs ownership data into a single uint256.
569      */
570     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
571         assembly {
572             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
573             owner := and(owner, BITMASK_ADDRESS)
574             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
575             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
576         }
577     }
578 
579     /**
580      * @dev See {IERC721-ownerOf}.
581      */
582     function ownerOf(uint256 tokenId) public view override returns (address) {
583         return address(uint160(_packedOwnershipOf(tokenId)));
584     }
585 
586     /**
587      * @dev See {IERC721Metadata-name}.
588      */
589     function name() public view virtual override returns (string memory) {
590         return _name;
591     }
592 
593     /**
594      * @dev See {IERC721Metadata-symbol}.
595      */
596     function symbol() public view virtual override returns (string memory) {
597         return _symbol;
598     }
599 
600     /**
601      * @dev See {IERC721Metadata-tokenURI}.
602      */
603     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
604         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
605 
606         string memory baseURI = _baseURI();
607         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
608     }
609 
610     /**
611      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
612      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
613      * by default, it can be overridden in child contracts.
614      */
615     function _baseURI() internal view virtual returns (string memory) {
616         return '';
617     }
618 
619     /**
620      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
621      */
622     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
623         // For branchless setting of the `nextInitialized` flag.
624         assembly {
625             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
626             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
627         }
628     }
629 
630     /**
631      * @dev See {IERC721-approve}.
632      */
633     function approve(address to, uint256 tokenId) public virtual override {
634         address owner = ownerOf(tokenId);
635         if (_msgSenderERC721A() != owner)
636             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
637                 revert ApprovalCallerNotOwnerNorApproved();
638             }
639 
640         _tokenApprovals[tokenId] = to;
641         emit Approval(owner, to, tokenId);
642     }
643 
644     /**
645      * @dev See {IERC721-getApproved}.
646      */
647     function getApproved(uint256 tokenId) public view override returns (address) {
648         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
649 
650         return _tokenApprovals[tokenId];
651     }
652 
653     /**
654      * @dev See {IERC721-setApprovalForAll}.
655      */
656     function setApprovalForAll(address operator, bool approved) public virtual override {
657         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
658         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
659         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
660     }
661     
662 
663     /**
664      * @dev See {IERC721-isApprovedForAll}.
665      */
666     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
667         return _operatorApprovals[owner][operator];
668     }
669 
670     /**
671      * @dev See {IERC721-safeTransferFrom}.
672      */
673     function safeTransferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) public virtual override {
678         safeTransferFrom(from, to, tokenId, '');
679     }
680 
681     /**
682      * @dev See {IERC721-safeTransferFrom}.
683      */
684     function safeTransferFrom(
685         address from,
686         address to,
687         uint256 tokenId,
688         bytes memory _data
689     ) public virtual override {
690         transferFrom(from, to, tokenId);
691         if (to.code.length != 0)
692             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
693                 revert TransferToNonERC721ReceiverImplementer();
694             }
695     }
696 
697     /**
698      * @dev Returns whether `tokenId` exists.
699      *
700      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
701      *
702      * Tokens start existing when they are minted (`_mint`),
703      */
704     function _exists(uint256 tokenId) internal view returns (bool) {
705         return
706             _startTokenId() <= tokenId &&
707             tokenId < _currentIndex && // If within bounds,
708             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
709     }
710 
711     /**
712      * @dev Equivalent to `_safeMint(to, quantity, '')`.
713      */
714     function _safeMint(address to, uint256 quantity) internal {
715         _safeMint(to, quantity, '');
716     }
717 
718     /**
719      * @dev Safely mints `quantity` tokens and transfers them to `to`.
720      *
721      * Requirements:
722      *
723      * - If `to` refers to a smart contract, it must implement
724      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
725      * - `quantity` must be greater than 0.
726      *
727      * See {_mint}.
728      *
729      * Emits a {Transfer} event for each mint.
730      */
731     function _safeMint(
732         address to,
733         uint256 quantity,
734         bytes memory _data
735     ) internal {
736         _mint(to, quantity);
737 
738         unchecked {
739             if (to.code.length != 0) {
740                 uint256 end = _currentIndex;
741                 uint256 index = end - quantity;
742                 do {
743                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
744                         revert TransferToNonERC721ReceiverImplementer();
745                     }
746                 } while (index < end);
747                 // Reentrancy protection.
748                 if (_currentIndex != end) revert();
749             }
750         }
751     }
752 
753     /**
754      * @dev Mints `quantity` tokens and transfers them to `to`.
755      *
756      * Requirements:
757      *
758      * - `to` cannot be the zero address.
759      * - `quantity` must be greater than 0.
760      *
761      * Emits a {Transfer} event for each mint.
762      */
763     function _mint(address to, uint256 quantity) internal {
764         uint256 startTokenId = _currentIndex;
765         if (to == address(0)) revert MintToZeroAddress();
766         if (quantity == 0) revert MintZeroQuantity();
767 
768         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
769 
770         // Overflows are incredibly unrealistic.
771         // `balance` and `numberMinted` have a maximum limit of 2**64.
772         // `tokenId` has a maximum limit of 2**256.
773         unchecked {
774             // Updates:
775             // - `balance += quantity`.
776             // - `numberMinted += quantity`.
777             //
778             // We can directly add to the `balance` and `numberMinted`.
779             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
780 
781             // Updates:
782             // - `address` to the owner.
783             // - `startTimestamp` to the timestamp of minting.
784             // - `burned` to `false`.
785             // - `nextInitialized` to `quantity == 1`.
786             _packedOwnerships[startTokenId] = _packOwnershipData(
787                 to,
788                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
789             );
790 
791             uint256 tokenId = startTokenId;
792             uint256 end = startTokenId + quantity;
793             do {
794                 emit Transfer(address(0), to, tokenId++);
795             } while (tokenId < end);
796 
797             _currentIndex = end;
798         }
799         _afterTokenTransfers(address(0), to, startTokenId, quantity);
800     }
801 
802     /**
803      * @dev Mints `quantity` tokens and transfers them to `to`.
804      *
805      * This function is intended for efficient minting only during contract creation.
806      *
807      * It emits only one {ConsecutiveTransfer} as defined in
808      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
809      * instead of a sequence of {Transfer} event(s).
810      *
811      * Calling this function outside of contract creation WILL make your contract
812      * non-compliant with the ERC721 standard.
813      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
814      * {ConsecutiveTransfer} event is only permissible during contract creation.
815      *
816      * Requirements:
817      *
818      * - `to` cannot be the zero address.
819      * - `quantity` must be greater than 0.
820      *
821      * Emits a {ConsecutiveTransfer} event.
822      */
823     function _mintERC2309(address to, uint256 quantity) internal {
824         uint256 startTokenId = _currentIndex;
825         if (to == address(0)) revert MintToZeroAddress();
826         if (quantity == 0) revert MintZeroQuantity();
827         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
828 
829         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
830 
831         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
832         unchecked {
833             // Updates:
834             // - `balance += quantity`.
835             // - `numberMinted += quantity`.
836             //
837             // We can directly add to the `balance` and `numberMinted`.
838             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
839 
840             // Updates:
841             // - `address` to the owner.
842             // - `startTimestamp` to the timestamp of minting.
843             // - `burned` to `false`.
844             // - `nextInitialized` to `quantity == 1`.
845             _packedOwnerships[startTokenId] = _packOwnershipData(
846                 to,
847                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
848             );
849 
850             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
851 
852             _currentIndex = startTokenId + quantity;
853         }
854         _afterTokenTransfers(address(0), to, startTokenId, quantity);
855     }
856 
857     /**
858      * @dev Returns the storage slot and value for the approved address of `tokenId`.
859      */
860     function _getApprovedAddress(uint256 tokenId)
861         private
862         view
863         returns (uint256 approvedAddressSlot, address approvedAddress)
864     {
865         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
866         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
867         assembly {
868             // Compute the slot.
869             mstore(0x00, tokenId)
870             mstore(0x20, tokenApprovalsPtr.slot)
871             approvedAddressSlot := keccak256(0x00, 0x40)
872             // Load the slot's value from storage.
873             approvedAddress := sload(approvedAddressSlot)
874         }
875     }
876 
877     /**
878      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
879      */
880     function _isOwnerOrApproved(
881         address approvedAddress,
882         address from,
883         address msgSender
884     ) private pure returns (bool result) {
885         assembly {
886             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
887             from := and(from, BITMASK_ADDRESS)
888             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
889             msgSender := and(msgSender, BITMASK_ADDRESS)
890             // `msgSender == from || msgSender == approvedAddress`.
891             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
892         }
893     }
894 
895     /**
896      * @dev Transfers `tokenId` from `from` to `to`.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must be owned by `from`.
902      *
903      * Emits a {Transfer} event.
904      */
905     function transferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public virtual override {
910         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
911 
912         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
913 
914         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
915 
916         // The nested ifs save around 20+ gas over a compound boolean condition.
917         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
918             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
919 
920         if (to == address(0)) revert TransferToZeroAddress();
921 
922         _beforeTokenTransfers(from, to, tokenId, 1);
923 
924         // Clear approvals from the previous owner.
925         assembly {
926             if approvedAddress {
927                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
928                 sstore(approvedAddressSlot, 0)
929             }
930         }
931 
932         // Underflow of the sender's balance is impossible because we check for
933         // ownership above and the recipient's balance can't realistically overflow.
934         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
935         unchecked {
936             // We can directly increment and decrement the balances.
937             --_packedAddressData[from]; // Updates: `balance -= 1`.
938             ++_packedAddressData[to]; // Updates: `balance += 1`.
939 
940             // Updates:
941             // - `address` to the next owner.
942             // - `startTimestamp` to the timestamp of transfering.
943             // - `burned` to `false`.
944             // - `nextInitialized` to `true`.
945             _packedOwnerships[tokenId] = _packOwnershipData(
946                 to,
947                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
948             );
949 
950             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
951             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
952                 uint256 nextTokenId = tokenId + 1;
953                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
954                 if (_packedOwnerships[nextTokenId] == 0) {
955                     // If the next slot is within bounds.
956                     if (nextTokenId != _currentIndex) {
957                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
958                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
959                     }
960                 }
961             }
962         }
963 
964         emit Transfer(from, to, tokenId);
965         _afterTokenTransfers(from, to, tokenId, 1);
966     }
967 
968     /**
969      * @dev Equivalent to `_burn(tokenId, false)`.
970      */
971     function _burn(uint256 tokenId) internal virtual {
972         _burn(tokenId, false);
973     }
974 
975     /**
976      * @dev Destroys `tokenId`.
977      * The approval is cleared when the token is burned.
978      *
979      * Requirements:
980      *
981      * - `tokenId` must exist.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
986         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
987 
988         address from = address(uint160(prevOwnershipPacked));
989 
990         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
991 
992         if (approvalCheck) {
993             // The nested ifs save around 20+ gas over a compound boolean condition.
994             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
995                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
996         }
997 
998         _beforeTokenTransfers(from, address(0), tokenId, 1);
999 
1000         // Clear approvals from the previous owner.
1001         assembly {
1002             if approvedAddress {
1003                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1004                 sstore(approvedAddressSlot, 0)
1005             }
1006         }
1007 
1008         // Underflow of the sender's balance is impossible because we check for
1009         // ownership above and the recipient's balance can't realistically overflow.
1010         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1011         unchecked {
1012             // Updates:
1013             // - `balance -= 1`.
1014             // - `numberBurned += 1`.
1015             //
1016             // We can directly decrement the balance, and increment the number burned.
1017             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1018             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1019 
1020             // Updates:
1021             // - `address` to the last owner.
1022             // - `startTimestamp` to the timestamp of burning.
1023             // - `burned` to `true`.
1024             // - `nextInitialized` to `true`.
1025             _packedOwnerships[tokenId] = _packOwnershipData(
1026                 from,
1027                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1028             );
1029 
1030             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1031             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1032                 uint256 nextTokenId = tokenId + 1;
1033                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1034                 if (_packedOwnerships[nextTokenId] == 0) {
1035                     // If the next slot is within bounds.
1036                     if (nextTokenId != _currentIndex) {
1037                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1038                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1039                     }
1040                 }
1041             }
1042         }
1043 
1044         emit Transfer(from, address(0), tokenId);
1045         _afterTokenTransfers(from, address(0), tokenId, 1);
1046 
1047         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1048         unchecked {
1049             _burnCounter++;
1050         }
1051     }
1052 
1053     /**
1054      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1055      *
1056      * @param from address representing the previous owner of the given token ID
1057      * @param to target address that will receive the tokens
1058      * @param tokenId uint256 ID of the token to be transferred
1059      * @param _data bytes optional data to send along with the call
1060      * @return bool whether the call correctly returned the expected magic value
1061      */
1062     function _checkContractOnERC721Received(
1063         address from,
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) private returns (bool) {
1068         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1069             bytes4 retval
1070         ) {
1071             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1072         } catch (bytes memory reason) {
1073             if (reason.length == 0) {
1074                 revert TransferToNonERC721ReceiverImplementer();
1075             } else {
1076                 assembly {
1077                     revert(add(32, reason), mload(reason))
1078                 }
1079             }
1080         }
1081     }
1082 
1083     /**
1084      * @dev Directly sets the extra data for the ownership data `index`.
1085      */
1086     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1087         uint256 packed = _packedOwnerships[index];
1088         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1089         uint256 extraDataCasted;
1090         // Cast `extraData` with assembly to avoid redundant masking.
1091         assembly {
1092             extraDataCasted := extraData
1093         }
1094         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1095         _packedOwnerships[index] = packed;
1096     }
1097 
1098     /**
1099      * @dev Returns the next extra data for the packed ownership data.
1100      * The returned result is shifted into position.
1101      */
1102     function _nextExtraData(
1103         address from,
1104         address to,
1105         uint256 prevOwnershipPacked
1106     ) private view returns (uint256) {
1107         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1108         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1109     }
1110 
1111     /**
1112      * @dev Called during each token transfer to set the 24bit `extraData` field.
1113      * Intended to be overridden by the cosumer contract.
1114      *
1115      * `previousExtraData` - the value of `extraData` before transfer.
1116      *
1117      * Calling conditions:
1118      *
1119      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1120      * transferred to `to`.
1121      * - When `from` is zero, `tokenId` will be minted for `to`.
1122      * - When `to` is zero, `tokenId` will be burned by `from`.
1123      * - `from` and `to` are never both zero.
1124      */
1125     function _extraData(
1126         address from,
1127         address to,
1128         uint24 previousExtraData
1129     ) internal view virtual returns (uint24) {}
1130 
1131     /**
1132      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1133      * This includes minting.
1134      * And also called before burning one token.
1135      *
1136      * startTokenId - the first token id to be transferred
1137      * quantity - the amount to be transferred
1138      *
1139      * Calling conditions:
1140      *
1141      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1142      * transferred to `to`.
1143      * - When `from` is zero, `tokenId` will be minted for `to`.
1144      * - When `to` is zero, `tokenId` will be burned by `from`.
1145      * - `from` and `to` are never both zero.
1146      */
1147     function _beforeTokenTransfers(
1148         address from,
1149         address to,
1150         uint256 startTokenId,
1151         uint256 quantity
1152     ) internal virtual {}
1153 
1154     /**
1155      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1156      * This includes minting.
1157      * And also called after one token has been burned.
1158      *
1159      * startTokenId - the first token id to be transferred
1160      * quantity - the amount to be transferred
1161      *
1162      * Calling conditions:
1163      *
1164      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1165      * transferred to `to`.
1166      * - When `from` is zero, `tokenId` has been minted for `to`.
1167      * - When `to` is zero, `tokenId` has been burned by `from`.
1168      * - `from` and `to` are never both zero.
1169      */
1170     function _afterTokenTransfers(
1171         address from,
1172         address to,
1173         uint256 startTokenId,
1174         uint256 quantity
1175     ) internal virtual {}
1176 
1177     /**
1178      * @dev Returns the message sender (defaults to `msg.sender`).
1179      *
1180      * If you are writing GSN compatible contracts, you need to override this function.
1181      */
1182     function _msgSenderERC721A() internal view virtual returns (address) {
1183         return msg.sender;
1184     }
1185 
1186     /**
1187      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1188      */
1189     function _toString(uint256 value) internal pure returns (string memory ptr) {
1190         assembly {
1191             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1192             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1193             // We will need 1 32-byte word to store the length,
1194             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1195             ptr := add(mload(0x40), 128)
1196             // Update the free memory pointer to allocate.
1197             mstore(0x40, ptr)
1198 
1199             // Cache the end of the memory to calculate the length later.
1200             let end := ptr
1201 
1202             // We write the string from the rightmost digit to the leftmost digit.
1203             // The following is essentially a do-while loop that also handles the zero case.
1204             // Costs a bit more than early returning for the zero case,
1205             // but cheaper in terms of deployment and overall runtime costs.
1206             for {
1207                 // Initialize and perform the first pass without check.
1208                 let temp := value
1209                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1210                 ptr := sub(ptr, 1)
1211                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1212                 mstore8(ptr, add(48, mod(temp, 10)))
1213                 temp := div(temp, 10)
1214             } temp {
1215                 // Keep dividing `temp` until zero.
1216                 temp := div(temp, 10)
1217             } {
1218                 // Body of the for loop.
1219                 ptr := sub(ptr, 1)
1220                 mstore8(ptr, add(48, mod(temp, 10)))
1221             }
1222 
1223             let length := sub(end, ptr)
1224             // Move the pointer 32 bytes leftwards to make room for the length.
1225             ptr := sub(ptr, 32)
1226             // Store the length.
1227             mstore(ptr, length)
1228         }
1229     }
1230 }
1231 // File: contracts/IOperatorFilterRegistry.sol
1232 
1233 
1234 pragma solidity ^0.8.13;
1235 
1236 interface IOperatorFilterRegistry {
1237     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1238     function register(address registrant) external;
1239     function registerAndSubscribe(address registrant, address subscription) external;
1240     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1241     function unregister(address addr) external;
1242     function updateOperator(address registrant, address operator, bool filtered) external;
1243     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1244     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1245     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1246     function subscribe(address registrant, address registrantToSubscribe) external;
1247     function unsubscribe(address registrant, bool copyExistingEntries) external;
1248     function subscriptionOf(address addr) external returns (address registrant);
1249     function subscribers(address registrant) external returns (address[] memory);
1250     function subscriberAt(address registrant, uint256 index) external returns (address);
1251     function copyEntriesOf(address registrant, address registrantToCopy) external;
1252     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1253     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1254     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1255     function filteredOperators(address addr) external returns (address[] memory);
1256     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1257     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1258     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1259     function isRegistered(address addr) external returns (bool);
1260     function codeHashOf(address addr) external returns (bytes32);
1261 }
1262 
1263 // File: contracts/OperatorFilterer.sol
1264 
1265 
1266 pragma solidity ^0.8.13;
1267 
1268 
1269 /**
1270  * @title  OperatorFilterer
1271  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1272  *         registrant's entries in the OperatorFilterRegistry.
1273  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1274  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1275  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1276  */
1277 abstract contract OperatorFilterer {
1278     error OperatorNotAllowed(address operator);
1279 
1280     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1281         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1282 
1283     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1284         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1285         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1286         // order for the modifier to filter addresses.
1287         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1288             if (subscribe) {
1289                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1290             } else {
1291                 if (subscriptionOrRegistrantToCopy != address(0)) {
1292                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1293                 } else {
1294                     OPERATOR_FILTER_REGISTRY.register(address(this));
1295                 }
1296             }
1297         }
1298     }
1299 
1300     modifier onlyAllowedOperator(address from) virtual {
1301         // Allow spending tokens from addresses with balance
1302         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1303         // from an EOA.
1304         if (from != msg.sender) {
1305             _checkFilterOperator(msg.sender);
1306         }
1307         _;
1308     }
1309 
1310     modifier onlyAllowedOperatorApproval(address operator) virtual {
1311         _checkFilterOperator(operator);
1312         _;
1313     }
1314 
1315     function _checkFilterOperator(address operator) internal view virtual {
1316         // Check registry code length to facilitate testing in environments without a deployed registry.
1317         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1318             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1319                 revert OperatorNotAllowed(operator);
1320             }
1321         }
1322     }
1323 }
1324 
1325 // File: contracts/DefaultOperatorFilterer.sol
1326 
1327 
1328 pragma solidity ^0.8.13;
1329 
1330 
1331 /**
1332  * @title  DefaultOperatorFilterer
1333  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1334  */
1335 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1336     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1337 
1338     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1339 }
1340 
1341 // File: @openzeppelin/contracts/utils/math/Math.sol
1342 
1343 
1344 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1345 
1346 pragma solidity ^0.8.0;
1347 
1348 /**
1349  * @dev Standard math utilities missing in the Solidity language.
1350  */
1351 library Math {
1352     enum Rounding {
1353         Down, // Toward negative infinity
1354         Up, // Toward infinity
1355         Zero // Toward zero
1356     }
1357 
1358     /**
1359      * @dev Returns the largest of two numbers.
1360      */
1361     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1362         return a > b ? a : b;
1363     }
1364 
1365     /**
1366      * @dev Returns the smallest of two numbers.
1367      */
1368     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1369         return a < b ? a : b;
1370     }
1371 
1372     /**
1373      * @dev Returns the average of two numbers. The result is rounded towards
1374      * zero.
1375      */
1376     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1377         // (a + b) / 2 can overflow.
1378         return (a & b) + (a ^ b) / 2;
1379     }
1380 
1381     /**
1382      * @dev Returns the ceiling of the division of two numbers.
1383      *
1384      * This differs from standard division with `/` in that it rounds up instead
1385      * of rounding down.
1386      */
1387     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1388         // (a + b - 1) / b can overflow on addition, so we distribute.
1389         return a == 0 ? 0 : (a - 1) / b + 1;
1390     }
1391 
1392     /**
1393      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1394      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1395      * with further edits by Uniswap Labs also under MIT license.
1396      */
1397     function mulDiv(
1398         uint256 x,
1399         uint256 y,
1400         uint256 denominator
1401     ) internal pure returns (uint256 result) {
1402         unchecked {
1403             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1404             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1405             // variables such that product = prod1 * 2^256 + prod0.
1406             uint256 prod0; // Least significant 256 bits of the product
1407             uint256 prod1; // Most significant 256 bits of the product
1408             assembly {
1409                 let mm := mulmod(x, y, not(0))
1410                 prod0 := mul(x, y)
1411                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1412             }
1413 
1414             // Handle non-overflow cases, 256 by 256 division.
1415             if (prod1 == 0) {
1416                 return prod0 / denominator;
1417             }
1418 
1419             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1420             require(denominator > prod1);
1421 
1422             ///////////////////////////////////////////////
1423             // 512 by 256 division.
1424             ///////////////////////////////////////////////
1425 
1426             // Make division exact by subtracting the remainder from [prod1 prod0].
1427             uint256 remainder;
1428             assembly {
1429                 // Compute remainder using mulmod.
1430                 remainder := mulmod(x, y, denominator)
1431 
1432                 // Subtract 256 bit number from 512 bit number.
1433                 prod1 := sub(prod1, gt(remainder, prod0))
1434                 prod0 := sub(prod0, remainder)
1435             }
1436 
1437             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1438             // See https://cs.stackexchange.com/q/138556/92363.
1439 
1440             // Does not overflow because the denominator cannot be zero at this stage in the function.
1441             uint256 twos = denominator & (~denominator + 1);
1442             assembly {
1443                 // Divide denominator by twos.
1444                 denominator := div(denominator, twos)
1445 
1446                 // Divide [prod1 prod0] by twos.
1447                 prod0 := div(prod0, twos)
1448 
1449                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1450                 twos := add(div(sub(0, twos), twos), 1)
1451             }
1452 
1453             // Shift in bits from prod1 into prod0.
1454             prod0 |= prod1 * twos;
1455 
1456             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1457             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1458             // four bits. That is, denominator * inv = 1 mod 2^4.
1459             uint256 inverse = (3 * denominator) ^ 2;
1460 
1461             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1462             // in modular arithmetic, doubling the correct bits in each step.
1463             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1464             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1465             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1466             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1467             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1468             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1469 
1470             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1471             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1472             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1473             // is no longer required.
1474             result = prod0 * inverse;
1475             return result;
1476         }
1477     }
1478 
1479     /**
1480      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1481      */
1482     function mulDiv(
1483         uint256 x,
1484         uint256 y,
1485         uint256 denominator,
1486         Rounding rounding
1487     ) internal pure returns (uint256) {
1488         uint256 result = mulDiv(x, y, denominator);
1489         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1490             result += 1;
1491         }
1492         return result;
1493     }
1494 
1495     /**
1496      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1497      *
1498      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1499      */
1500     function sqrt(uint256 a) internal pure returns (uint256) {
1501         if (a == 0) {
1502             return 0;
1503         }
1504 
1505         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1506         //
1507         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1508         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1509         //
1510         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1511         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1512         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1513         //
1514         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1515         uint256 result = 1 << (log2(a) >> 1);
1516 
1517         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1518         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1519         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1520         // into the expected uint128 result.
1521         unchecked {
1522             result = (result + a / result) >> 1;
1523             result = (result + a / result) >> 1;
1524             result = (result + a / result) >> 1;
1525             result = (result + a / result) >> 1;
1526             result = (result + a / result) >> 1;
1527             result = (result + a / result) >> 1;
1528             result = (result + a / result) >> 1;
1529             return min(result, a / result);
1530         }
1531     }
1532 
1533     /**
1534      * @notice Calculates sqrt(a), following the selected rounding direction.
1535      */
1536     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1537         unchecked {
1538             uint256 result = sqrt(a);
1539             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1540         }
1541     }
1542 
1543     /**
1544      * @dev Return the log in base 2, rounded down, of a positive value.
1545      * Returns 0 if given 0.
1546      */
1547     function log2(uint256 value) internal pure returns (uint256) {
1548         uint256 result = 0;
1549         unchecked {
1550             if (value >> 128 > 0) {
1551                 value >>= 128;
1552                 result += 128;
1553             }
1554             if (value >> 64 > 0) {
1555                 value >>= 64;
1556                 result += 64;
1557             }
1558             if (value >> 32 > 0) {
1559                 value >>= 32;
1560                 result += 32;
1561             }
1562             if (value >> 16 > 0) {
1563                 value >>= 16;
1564                 result += 16;
1565             }
1566             if (value >> 8 > 0) {
1567                 value >>= 8;
1568                 result += 8;
1569             }
1570             if (value >> 4 > 0) {
1571                 value >>= 4;
1572                 result += 4;
1573             }
1574             if (value >> 2 > 0) {
1575                 value >>= 2;
1576                 result += 2;
1577             }
1578             if (value >> 1 > 0) {
1579                 result += 1;
1580             }
1581         }
1582         return result;
1583     }
1584 
1585     /**
1586      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1587      * Returns 0 if given 0.
1588      */
1589     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1590         unchecked {
1591             uint256 result = log2(value);
1592             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1593         }
1594     }
1595 
1596     /**
1597      * @dev Return the log in base 10, rounded down, of a positive value.
1598      * Returns 0 if given 0.
1599      */
1600     function log10(uint256 value) internal pure returns (uint256) {
1601         uint256 result = 0;
1602         unchecked {
1603             if (value >= 10**64) {
1604                 value /= 10**64;
1605                 result += 64;
1606             }
1607             if (value >= 10**32) {
1608                 value /= 10**32;
1609                 result += 32;
1610             }
1611             if (value >= 10**16) {
1612                 value /= 10**16;
1613                 result += 16;
1614             }
1615             if (value >= 10**8) {
1616                 value /= 10**8;
1617                 result += 8;
1618             }
1619             if (value >= 10**4) {
1620                 value /= 10**4;
1621                 result += 4;
1622             }
1623             if (value >= 10**2) {
1624                 value /= 10**2;
1625                 result += 2;
1626             }
1627             if (value >= 10**1) {
1628                 result += 1;
1629             }
1630         }
1631         return result;
1632     }
1633 
1634     /**
1635      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1636      * Returns 0 if given 0.
1637      */
1638     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1639         unchecked {
1640             uint256 result = log10(value);
1641             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1642         }
1643     }
1644 
1645     /**
1646      * @dev Return the log in base 256, rounded down, of a positive value.
1647      * Returns 0 if given 0.
1648      *
1649      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1650      */
1651     function log256(uint256 value) internal pure returns (uint256) {
1652         uint256 result = 0;
1653         unchecked {
1654             if (value >> 128 > 0) {
1655                 value >>= 128;
1656                 result += 16;
1657             }
1658             if (value >> 64 > 0) {
1659                 value >>= 64;
1660                 result += 8;
1661             }
1662             if (value >> 32 > 0) {
1663                 value >>= 32;
1664                 result += 4;
1665             }
1666             if (value >> 16 > 0) {
1667                 value >>= 16;
1668                 result += 2;
1669             }
1670             if (value >> 8 > 0) {
1671                 result += 1;
1672             }
1673         }
1674         return result;
1675     }
1676 
1677     /**
1678      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1679      * Returns 0 if given 0.
1680      */
1681     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1682         unchecked {
1683             uint256 result = log256(value);
1684             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1685         }
1686     }
1687 }
1688 
1689 // File: @openzeppelin/contracts/utils/Strings.sol
1690 
1691 
1692 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1693 
1694 pragma solidity ^0.8.0;
1695 
1696 
1697 /**
1698  * @dev String operations.
1699  */
1700 library Strings {
1701     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1702     uint8 private constant _ADDRESS_LENGTH = 20;
1703 
1704     /**
1705      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1706      */
1707     function toString(uint256 value) internal pure returns (string memory) {
1708         unchecked {
1709             uint256 length = Math.log10(value) + 1;
1710             string memory buffer = new string(length);
1711             uint256 ptr;
1712             /// @solidity memory-safe-assembly
1713             assembly {
1714                 ptr := add(buffer, add(32, length))
1715             }
1716             while (true) {
1717                 ptr--;
1718                 /// @solidity memory-safe-assembly
1719                 assembly {
1720                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1721                 }
1722                 value /= 10;
1723                 if (value == 0) break;
1724             }
1725             return buffer;
1726         }
1727     }
1728 
1729     /**
1730      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1731      */
1732     function toHexString(uint256 value) internal pure returns (string memory) {
1733         unchecked {
1734             return toHexString(value, Math.log256(value) + 1);
1735         }
1736     }
1737 
1738     /**
1739      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1740      */
1741     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1742         bytes memory buffer = new bytes(2 * length + 2);
1743         buffer[0] = "0";
1744         buffer[1] = "x";
1745         for (uint256 i = 2 * length + 1; i > 1; --i) {
1746             buffer[i] = _SYMBOLS[value & 0xf];
1747             value >>= 4;
1748         }
1749         require(value == 0, "Strings: hex length insufficient");
1750         return string(buffer);
1751     }
1752 
1753     /**
1754      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1755      */
1756     function toHexString(address addr) internal pure returns (string memory) {
1757         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1758     }
1759 }
1760 
1761 // File: @openzeppelin/contracts/utils/Address.sol
1762 
1763 
1764 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1765 
1766 pragma solidity ^0.8.1;
1767 
1768 /**
1769  * @dev Collection of functions related to the address type
1770  */
1771 library Address {
1772     /**
1773      * @dev Returns true if `account` is a contract.
1774      *
1775      * [IMPORTANT]
1776      * ====
1777      * It is unsafe to assume that an address for which this function returns
1778      * false is an externally-owned account (EOA) and not a contract.
1779      *
1780      * Among others, `isContract` will return false for the following
1781      * types of addresses:
1782      *
1783      *  - an externally-owned account
1784      *  - a contract in construction
1785      *  - an address where a contract will be created
1786      *  - an address where a contract lived, but was destroyed
1787      * ====
1788      *
1789      * [IMPORTANT]
1790      * ====
1791      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1792      *
1793      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1794      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1795      * constructor.
1796      * ====
1797      */
1798     function isContract(address account) internal view returns (bool) {
1799         // This method relies on extcodesize/address.code.length, which returns 0
1800         // for contracts in construction, since the code is only stored at the end
1801         // of the constructor execution.
1802 
1803         return account.code.length > 0;
1804     }
1805 
1806     /**
1807      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1808      * `recipient`, forwarding all available gas and reverting on errors.
1809      *
1810      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1811      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1812      * imposed by `transfer`, making them unable to receive funds via
1813      * `transfer`. {sendValue} removes this limitation.
1814      *
1815      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1816      *
1817      * IMPORTANT: because control is transferred to `recipient`, care must be
1818      * taken to not create reentrancy vulnerabilities. Consider using
1819      * {ReentrancyGuard} or the
1820      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1821      */
1822     function sendValue(address payable recipient, uint256 amount) internal {
1823         require(address(this).balance >= amount, "Address: insufficient balance");
1824 
1825         (bool success, ) = recipient.call{value: amount}("");
1826         require(success, "Address: unable to send value, recipient may have reverted");
1827     }
1828 
1829     /**
1830      * @dev Performs a Solidity function call using a low level `call`. A
1831      * plain `call` is an unsafe replacement for a function call: use this
1832      * function instead.
1833      *
1834      * If `target` reverts with a revert reason, it is bubbled up by this
1835      * function (like regular Solidity function calls).
1836      *
1837      * Returns the raw returned data. To convert to the expected return value,
1838      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1839      *
1840      * Requirements:
1841      *
1842      * - `target` must be a contract.
1843      * - calling `target` with `data` must not revert.
1844      *
1845      * _Available since v3.1._
1846      */
1847     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1848         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1849     }
1850 
1851     /**
1852      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1853      * `errorMessage` as a fallback revert reason when `target` reverts.
1854      *
1855      * _Available since v3.1._
1856      */
1857     function functionCall(
1858         address target,
1859         bytes memory data,
1860         string memory errorMessage
1861     ) internal returns (bytes memory) {
1862         return functionCallWithValue(target, data, 0, errorMessage);
1863     }
1864 
1865     /**
1866      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1867      * but also transferring `value` wei to `target`.
1868      *
1869      * Requirements:
1870      *
1871      * - the calling contract must have an ETH balance of at least `value`.
1872      * - the called Solidity function must be `payable`.
1873      *
1874      * _Available since v3.1._
1875      */
1876     function functionCallWithValue(
1877         address target,
1878         bytes memory data,
1879         uint256 value
1880     ) internal returns (bytes memory) {
1881         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1882     }
1883 
1884     /**
1885      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1886      * with `errorMessage` as a fallback revert reason when `target` reverts.
1887      *
1888      * _Available since v3.1._
1889      */
1890     function functionCallWithValue(
1891         address target,
1892         bytes memory data,
1893         uint256 value,
1894         string memory errorMessage
1895     ) internal returns (bytes memory) {
1896         require(address(this).balance >= value, "Address: insufficient balance for call");
1897         (bool success, bytes memory returndata) = target.call{value: value}(data);
1898         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1899     }
1900 
1901     /**
1902      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1903      * but performing a static call.
1904      *
1905      * _Available since v3.3._
1906      */
1907     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1908         return functionStaticCall(target, data, "Address: low-level static call failed");
1909     }
1910 
1911     /**
1912      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1913      * but performing a static call.
1914      *
1915      * _Available since v3.3._
1916      */
1917     function functionStaticCall(
1918         address target,
1919         bytes memory data,
1920         string memory errorMessage
1921     ) internal view returns (bytes memory) {
1922         (bool success, bytes memory returndata) = target.staticcall(data);
1923         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1924     }
1925 
1926     /**
1927      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1928      * but performing a delegate call.
1929      *
1930      * _Available since v3.4._
1931      */
1932     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1933         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1934     }
1935 
1936     /**
1937      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1938      * but performing a delegate call.
1939      *
1940      * _Available since v3.4._
1941      */
1942     function functionDelegateCall(
1943         address target,
1944         bytes memory data,
1945         string memory errorMessage
1946     ) internal returns (bytes memory) {
1947         (bool success, bytes memory returndata) = target.delegatecall(data);
1948         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1949     }
1950 
1951     /**
1952      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1953      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1954      *
1955      * _Available since v4.8._
1956      */
1957     function verifyCallResultFromTarget(
1958         address target,
1959         bool success,
1960         bytes memory returndata,
1961         string memory errorMessage
1962     ) internal view returns (bytes memory) {
1963         if (success) {
1964             if (returndata.length == 0) {
1965                 // only check isContract if the call was successful and the return data is empty
1966                 // otherwise we already know that it was a contract
1967                 require(isContract(target), "Address: call to non-contract");
1968             }
1969             return returndata;
1970         } else {
1971             _revert(returndata, errorMessage);
1972         }
1973     }
1974 
1975     /**
1976      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1977      * revert reason or using the provided one.
1978      *
1979      * _Available since v4.3._
1980      */
1981     function verifyCallResult(
1982         bool success,
1983         bytes memory returndata,
1984         string memory errorMessage
1985     ) internal pure returns (bytes memory) {
1986         if (success) {
1987             return returndata;
1988         } else {
1989             _revert(returndata, errorMessage);
1990         }
1991     }
1992 
1993     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1994         // Look for revert reason and bubble it up if present
1995         if (returndata.length > 0) {
1996             // The easiest way to bubble the revert reason is using memory via assembly
1997             /// @solidity memory-safe-assembly
1998             assembly {
1999                 let returndata_size := mload(returndata)
2000                 revert(add(32, returndata), returndata_size)
2001             }
2002         } else {
2003             revert(errorMessage);
2004         }
2005     }
2006 }
2007 
2008 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
2009 
2010 
2011 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
2012 
2013 pragma solidity ^0.8.0;
2014 
2015 /**
2016  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
2017  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
2018  *
2019  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
2020  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
2021  * need to send a transaction, and thus is not required to hold Ether at all.
2022  */
2023 interface IERC20Permit {
2024     /**
2025      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
2026      * given ``owner``'s signed approval.
2027      *
2028      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
2029      * ordering also apply here.
2030      *
2031      * Emits an {Approval} event.
2032      *
2033      * Requirements:
2034      *
2035      * - `spender` cannot be the zero address.
2036      * - `deadline` must be a timestamp in the future.
2037      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
2038      * over the EIP712-formatted function arguments.
2039      * - the signature must use ``owner``'s current nonce (see {nonces}).
2040      *
2041      * For more information on the signature format, see the
2042      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
2043      * section].
2044      */
2045     function permit(
2046         address owner,
2047         address spender,
2048         uint256 value,
2049         uint256 deadline,
2050         uint8 v,
2051         bytes32 r,
2052         bytes32 s
2053     ) external;
2054 
2055     /**
2056      * @dev Returns the current nonce for `owner`. This value must be
2057      * included whenever a signature is generated for {permit}.
2058      *
2059      * Every successful call to {permit} increases ``owner``'s nonce by one. This
2060      * prevents a signature from being used multiple times.
2061      */
2062     function nonces(address owner) external view returns (uint256);
2063 
2064     /**
2065      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
2066      */
2067     // solhint-disable-next-line func-name-mixedcase
2068     function DOMAIN_SEPARATOR() external view returns (bytes32);
2069 }
2070 
2071 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2072 
2073 
2074 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2075 
2076 pragma solidity ^0.8.0;
2077 
2078 /**
2079  * @dev Interface of the ERC20 standard as defined in the EIP.
2080  */
2081 interface IERC20 {
2082     /**
2083      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2084      * another (`to`).
2085      *
2086      * Note that `value` may be zero.
2087      */
2088     event Transfer(address indexed from, address indexed to, uint256 value);
2089 
2090     /**
2091      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2092      * a call to {approve}. `value` is the new allowance.
2093      */
2094     event Approval(address indexed owner, address indexed spender, uint256 value);
2095 
2096     /**
2097      * @dev Returns the amount of tokens in existence.
2098      */
2099     function totalSupply() external view returns (uint256);
2100 
2101     /**
2102      * @dev Returns the amount of tokens owned by `account`.
2103      */
2104     function balanceOf(address account) external view returns (uint256);
2105 
2106     /**
2107      * @dev Moves `amount` tokens from the caller's account to `to`.
2108      *
2109      * Returns a boolean value indicating whether the operation succeeded.
2110      *
2111      * Emits a {Transfer} event.
2112      */
2113     function transfer(address to, uint256 amount) external returns (bool);
2114 
2115     /**
2116      * @dev Returns the remaining number of tokens that `spender` will be
2117      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2118      * zero by default.
2119      *
2120      * This value changes when {approve} or {transferFrom} are called.
2121      */
2122     function allowance(address owner, address spender) external view returns (uint256);
2123 
2124     /**
2125      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2126      *
2127      * Returns a boolean value indicating whether the operation succeeded.
2128      *
2129      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2130      * that someone may use both the old and the new allowance by unfortunate
2131      * transaction ordering. One possible solution to mitigate this race
2132      * condition is to first reduce the spender's allowance to 0 and set the
2133      * desired value afterwards:
2134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2135      *
2136      * Emits an {Approval} event.
2137      */
2138     function approve(address spender, uint256 amount) external returns (bool);
2139 
2140     /**
2141      * @dev Moves `amount` tokens from `from` to `to` using the
2142      * allowance mechanism. `amount` is then deducted from the caller's
2143      * allowance.
2144      *
2145      * Returns a boolean value indicating whether the operation succeeded.
2146      *
2147      * Emits a {Transfer} event.
2148      */
2149     function transferFrom(
2150         address from,
2151         address to,
2152         uint256 amount
2153     ) external returns (bool);
2154 }
2155 
2156 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
2157 
2158 
2159 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
2160 
2161 pragma solidity ^0.8.0;
2162 
2163 
2164 
2165 
2166 /**
2167  * @title SafeERC20
2168  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2169  * contract returns false). Tokens that return no value (and instead revert or
2170  * throw on failure) are also supported, non-reverting calls are assumed to be
2171  * successful.
2172  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2173  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2174  */
2175 library SafeERC20 {
2176     using Address for address;
2177 
2178     function safeTransfer(
2179         IERC20 token,
2180         address to,
2181         uint256 value
2182     ) internal {
2183         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2184     }
2185 
2186     function safeTransferFrom(
2187         IERC20 token,
2188         address from,
2189         address to,
2190         uint256 value
2191     ) internal {
2192         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2193     }
2194 
2195     /**
2196      * @dev Deprecated. This function has issues similar to the ones found in
2197      * {IERC20-approve}, and its usage is discouraged.
2198      *
2199      * Whenever possible, use {safeIncreaseAllowance} and
2200      * {safeDecreaseAllowance} instead.
2201      */
2202     function safeApprove(
2203         IERC20 token,
2204         address spender,
2205         uint256 value
2206     ) internal {
2207         // safeApprove should only be called when setting an initial allowance,
2208         // or when resetting it to zero. To increase and decrease it, use
2209         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2210         require(
2211             (value == 0) || (token.allowance(address(this), spender) == 0),
2212             "SafeERC20: approve from non-zero to non-zero allowance"
2213         );
2214         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2215     }
2216 
2217     function safeIncreaseAllowance(
2218         IERC20 token,
2219         address spender,
2220         uint256 value
2221     ) internal {
2222         uint256 newAllowance = token.allowance(address(this), spender) + value;
2223         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2224     }
2225 
2226     function safeDecreaseAllowance(
2227         IERC20 token,
2228         address spender,
2229         uint256 value
2230     ) internal {
2231         unchecked {
2232             uint256 oldAllowance = token.allowance(address(this), spender);
2233             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2234             uint256 newAllowance = oldAllowance - value;
2235             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2236         }
2237     }
2238 
2239     function safePermit(
2240         IERC20Permit token,
2241         address owner,
2242         address spender,
2243         uint256 value,
2244         uint256 deadline,
2245         uint8 v,
2246         bytes32 r,
2247         bytes32 s
2248     ) internal {
2249         uint256 nonceBefore = token.nonces(owner);
2250         token.permit(owner, spender, value, deadline, v, r, s);
2251         uint256 nonceAfter = token.nonces(owner);
2252         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
2253     }
2254 
2255     /**
2256      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2257      * on the return value: the return value is optional (but if data is returned, it must not be false).
2258      * @param token The token targeted by the call.
2259      * @param data The call data (encoded using abi.encode or one of its variants).
2260      */
2261     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2262         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2263         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
2264         // the target address contains contract code and also asserts for success in the low-level call.
2265 
2266         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2267         if (returndata.length > 0) {
2268             // Return data is optional
2269             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2270         }
2271     }
2272 }
2273 
2274 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2275 
2276 
2277 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
2278 
2279 pragma solidity ^0.8.0;
2280 
2281 /**
2282  * @dev These functions deal with verification of Merkle Tree proofs.
2283  *
2284  * The tree and the proofs can be generated using our
2285  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
2286  * You will find a quickstart guide in the readme.
2287  *
2288  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
2289  * hashing, or use a hash function other than keccak256 for hashing leaves.
2290  * This is because the concatenation of a sorted pair of internal nodes in
2291  * the merkle tree could be reinterpreted as a leaf value.
2292  * OpenZeppelin's JavaScript library generates merkle trees that are safe
2293  * against this attack out of the box.
2294  */
2295 library MerkleProof {
2296     /**
2297      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2298      * defined by `root`. For this, a `proof` must be provided, containing
2299      * sibling hashes on the branch from the leaf to the root of the tree. Each
2300      * pair of leaves and each pair of pre-images are assumed to be sorted.
2301      */
2302     function verify(
2303         bytes32[] memory proof,
2304         bytes32 root,
2305         bytes32 leaf
2306     ) internal pure returns (bool) {
2307         return processProof(proof, leaf) == root;
2308     }
2309 
2310     /**
2311      * @dev Calldata version of {verify}
2312      *
2313      * _Available since v4.7._
2314      */
2315     function verifyCalldata(
2316         bytes32[] calldata proof,
2317         bytes32 root,
2318         bytes32 leaf
2319     ) internal pure returns (bool) {
2320         return processProofCalldata(proof, leaf) == root;
2321     }
2322 
2323     /**
2324      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
2325      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2326      * hash matches the root of the tree. When processing the proof, the pairs
2327      * of leafs & pre-images are assumed to be sorted.
2328      *
2329      * _Available since v4.4._
2330      */
2331     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2332         bytes32 computedHash = leaf;
2333         for (uint256 i = 0; i < proof.length; i++) {
2334             computedHash = _hashPair(computedHash, proof[i]);
2335         }
2336         return computedHash;
2337     }
2338 
2339     /**
2340      * @dev Calldata version of {processProof}
2341      *
2342      * _Available since v4.7._
2343      */
2344     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
2345         bytes32 computedHash = leaf;
2346         for (uint256 i = 0; i < proof.length; i++) {
2347             computedHash = _hashPair(computedHash, proof[i]);
2348         }
2349         return computedHash;
2350     }
2351 
2352     /**
2353      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
2354      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2355      *
2356      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2357      *
2358      * _Available since v4.7._
2359      */
2360     function multiProofVerify(
2361         bytes32[] memory proof,
2362         bool[] memory proofFlags,
2363         bytes32 root,
2364         bytes32[] memory leaves
2365     ) internal pure returns (bool) {
2366         return processMultiProof(proof, proofFlags, leaves) == root;
2367     }
2368 
2369     /**
2370      * @dev Calldata version of {multiProofVerify}
2371      *
2372      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2373      *
2374      * _Available since v4.7._
2375      */
2376     function multiProofVerifyCalldata(
2377         bytes32[] calldata proof,
2378         bool[] calldata proofFlags,
2379         bytes32 root,
2380         bytes32[] memory leaves
2381     ) internal pure returns (bool) {
2382         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2383     }
2384 
2385     /**
2386      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2387      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2388      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2389      * respectively.
2390      *
2391      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2392      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2393      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2394      *
2395      * _Available since v4.7._
2396      */
2397     function processMultiProof(
2398         bytes32[] memory proof,
2399         bool[] memory proofFlags,
2400         bytes32[] memory leaves
2401     ) internal pure returns (bytes32 merkleRoot) {
2402         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2403         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2404         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2405         // the merkle tree.
2406         uint256 leavesLen = leaves.length;
2407         uint256 totalHashes = proofFlags.length;
2408 
2409         // Check proof validity.
2410         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2411 
2412         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2413         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2414         bytes32[] memory hashes = new bytes32[](totalHashes);
2415         uint256 leafPos = 0;
2416         uint256 hashPos = 0;
2417         uint256 proofPos = 0;
2418         // At each step, we compute the next hash using two values:
2419         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2420         //   get the next hash.
2421         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2422         //   `proof` array.
2423         for (uint256 i = 0; i < totalHashes; i++) {
2424             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2425             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2426             hashes[i] = _hashPair(a, b);
2427         }
2428 
2429         if (totalHashes > 0) {
2430             return hashes[totalHashes - 1];
2431         } else if (leavesLen > 0) {
2432             return leaves[0];
2433         } else {
2434             return proof[0];
2435         }
2436     }
2437 
2438     /**
2439      * @dev Calldata version of {processMultiProof}.
2440      *
2441      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2442      *
2443      * _Available since v4.7._
2444      */
2445     function processMultiProofCalldata(
2446         bytes32[] calldata proof,
2447         bool[] calldata proofFlags,
2448         bytes32[] memory leaves
2449     ) internal pure returns (bytes32 merkleRoot) {
2450         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2451         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2452         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2453         // the merkle tree.
2454         uint256 leavesLen = leaves.length;
2455         uint256 totalHashes = proofFlags.length;
2456 
2457         // Check proof validity.
2458         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2459 
2460         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2461         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2462         bytes32[] memory hashes = new bytes32[](totalHashes);
2463         uint256 leafPos = 0;
2464         uint256 hashPos = 0;
2465         uint256 proofPos = 0;
2466         // At each step, we compute the next hash using two values:
2467         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2468         //   get the next hash.
2469         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2470         //   `proof` array.
2471         for (uint256 i = 0; i < totalHashes; i++) {
2472             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2473             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2474             hashes[i] = _hashPair(a, b);
2475         }
2476 
2477         if (totalHashes > 0) {
2478             return hashes[totalHashes - 1];
2479         } else if (leavesLen > 0) {
2480             return leaves[0];
2481         } else {
2482             return proof[0];
2483         }
2484     }
2485 
2486     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2487         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2488     }
2489 
2490     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2491         /// @solidity memory-safe-assembly
2492         assembly {
2493             mstore(0x00, a)
2494             mstore(0x20, b)
2495             value := keccak256(0x00, 0x40)
2496         }
2497     }
2498 }
2499 
2500 // File: @openzeppelin/contracts/utils/Context.sol
2501 
2502 
2503 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2504 
2505 pragma solidity ^0.8.0;
2506 
2507 /**
2508  * @dev Provides information about the current execution context, including the
2509  * sender of the transaction and its data. While these are generally available
2510  * via msg.sender and msg.data, they should not be accessed in such a direct
2511  * manner, since when dealing with meta-transactions the account sending and
2512  * paying for execution may not be the actual sender (as far as an application
2513  * is concerned).
2514  *
2515  * This contract is only required for intermediate, library-like contracts.
2516  */
2517 abstract contract Context {
2518     function _msgSender() internal view virtual returns (address) {
2519         return msg.sender;
2520     }
2521 
2522     function _msgData() internal view virtual returns (bytes calldata) {
2523         return msg.data;
2524     }
2525 }
2526 
2527 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
2528 
2529 
2530 // OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)
2531 
2532 pragma solidity ^0.8.0;
2533 
2534 
2535 
2536 
2537 /**
2538  * @title PaymentSplitter
2539  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2540  * that the Ether will be split in this way, since it is handled transparently by the contract.
2541  *
2542  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2543  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2544  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
2545  * time of contract deployment and can't be updated thereafter.
2546  *
2547  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2548  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2549  * function.
2550  *
2551  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2552  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2553  * to run tests before sending real value to this contract.
2554  */
2555 contract PaymentSplitter is Context {
2556     event PayeeAdded(address account, uint256 shares);
2557     event PaymentReleased(address to, uint256 amount);
2558     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
2559     event PaymentReceived(address from, uint256 amount);
2560 
2561     uint256 private _totalShares;
2562     uint256 private _totalReleased;
2563 
2564     mapping(address => uint256) private _shares;
2565     mapping(address => uint256) private _released;
2566     address[] private _payees;
2567 
2568     mapping(IERC20 => uint256) private _erc20TotalReleased;
2569     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2570 
2571     /**
2572      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2573      * the matching position in the `shares` array.
2574      *
2575      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2576      * duplicates in `payees`.
2577      */
2578     constructor(address[] memory payees, uint256[] memory shares_) payable {
2579         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2580         require(payees.length > 0, "PaymentSplitter: no payees");
2581 
2582         for (uint256 i = 0; i < payees.length; i++) {
2583             _addPayee(payees[i], shares_[i]);
2584         }
2585     }
2586 
2587     /**
2588      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2589      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2590      * reliability of the events, and not the actual splitting of Ether.
2591      *
2592      * To learn more about this see the Solidity documentation for
2593      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2594      * functions].
2595      */
2596     receive() external payable virtual {
2597         emit PaymentReceived(_msgSender(), msg.value);
2598     }
2599 
2600     /**
2601      * @dev Getter for the total shares held by payees.
2602      */
2603     function totalShares() public view returns (uint256) {
2604         return _totalShares;
2605     }
2606 
2607     /**
2608      * @dev Getter for the total amount of Ether already released.
2609      */
2610     function totalReleased() public view returns (uint256) {
2611         return _totalReleased;
2612     }
2613 
2614     /**
2615      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2616      * contract.
2617      */
2618     function totalReleased(IERC20 token) public view returns (uint256) {
2619         return _erc20TotalReleased[token];
2620     }
2621 
2622     /**
2623      * @dev Getter for the amount of shares held by an account.
2624      */
2625     function shares(address account) public view returns (uint256) {
2626         return _shares[account];
2627     }
2628 
2629     /**
2630      * @dev Getter for the amount of Ether already released to a payee.
2631      */
2632     function released(address account) public view returns (uint256) {
2633         return _released[account];
2634     }
2635 
2636     /**
2637      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2638      * IERC20 contract.
2639      */
2640     function released(IERC20 token, address account) public view returns (uint256) {
2641         return _erc20Released[token][account];
2642     }
2643 
2644     /**
2645      * @dev Getter for the address of the payee number `index`.
2646      */
2647     function payee(uint256 index) public view returns (address) {
2648         return _payees[index];
2649     }
2650 
2651     /**
2652      * @dev Getter for the amount of payee's releasable Ether.
2653      */
2654     function releasable(address account) public view returns (uint256) {
2655         uint256 totalReceived = address(this).balance + totalReleased();
2656         return _pendingPayment(account, totalReceived, released(account));
2657     }
2658 
2659     /**
2660      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
2661      * IERC20 contract.
2662      */
2663     function releasable(IERC20 token, address account) public view returns (uint256) {
2664         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
2665         return _pendingPayment(account, totalReceived, released(token, account));
2666     }
2667 
2668     /**
2669      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2670      * total shares and their previous withdrawals.
2671      */
2672     function release(address payable account) public virtual {
2673         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2674 
2675         uint256 payment = releasable(account);
2676 
2677         require(payment != 0, "PaymentSplitter: account is not due payment");
2678 
2679         // _totalReleased is the sum of all values in _released.
2680         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
2681         _totalReleased += payment;
2682         unchecked {
2683             _released[account] += payment;
2684         }
2685 
2686         Address.sendValue(account, payment);
2687         emit PaymentReleased(account, payment);
2688     }
2689 
2690     /**
2691      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2692      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2693      * contract.
2694      */
2695     function release(IERC20 token, address account) public virtual {
2696         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2697 
2698         uint256 payment = releasable(token, account);
2699 
2700         require(payment != 0, "PaymentSplitter: account is not due payment");
2701 
2702         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
2703         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
2704         // cannot overflow.
2705         _erc20TotalReleased[token] += payment;
2706         unchecked {
2707             _erc20Released[token][account] += payment;
2708         }
2709 
2710         SafeERC20.safeTransfer(token, account, payment);
2711         emit ERC20PaymentReleased(token, account, payment);
2712     }
2713 
2714     /**
2715      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2716      * already released amounts.
2717      */
2718     function _pendingPayment(
2719         address account,
2720         uint256 totalReceived,
2721         uint256 alreadyReleased
2722     ) private view returns (uint256) {
2723         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2724     }
2725 
2726     /**
2727      * @dev Add a new payee to the contract.
2728      * @param account The address of the payee to add.
2729      * @param shares_ The number of shares owned by the payee.
2730      */
2731     function _addPayee(address account, uint256 shares_) private {
2732         require(account != address(0), "PaymentSplitter: account is the zero address");
2733         require(shares_ > 0, "PaymentSplitter: shares are 0");
2734         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2735 
2736         _payees.push(account);
2737         _shares[account] = shares_;
2738         _totalShares = _totalShares + shares_;
2739         emit PayeeAdded(account, shares_);
2740     }
2741 }
2742 
2743 // File: @openzeppelin/contracts/access/Ownable.sol
2744 
2745 
2746 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2747 
2748 pragma solidity ^0.8.0;
2749 
2750 
2751 /**
2752  * @dev Contract module which provides a basic access control mechanism, where
2753  * there is an account (an owner) that can be granted exclusive access to
2754  * specific functions.
2755  *
2756  * By default, the owner account will be the one that deploys the contract. This
2757  * can later be changed with {transferOwnership}.
2758  *
2759  * This module is used through inheritance. It will make available the modifier
2760  * `onlyOwner`, which can be applied to your functions to restrict their use to
2761  * the owner.
2762  */
2763 abstract contract Ownable is Context {
2764     address private _owner;
2765 
2766     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2767 
2768     /**
2769      * @dev Initializes the contract setting the deployer as the initial owner.
2770      */
2771     constructor() {
2772         _transferOwnership(_msgSender());
2773     }
2774 
2775     /**
2776      * @dev Throws if called by any account other than the owner.
2777      */
2778     modifier onlyOwner() {
2779         _checkOwner();
2780         _;
2781     }
2782 
2783     /**
2784      * @dev Returns the address of the current owner.
2785      */
2786     function owner() public view virtual returns (address) {
2787         return _owner;
2788     }
2789 
2790     /**
2791      * @dev Throws if the sender is not the owner.
2792      */
2793     function _checkOwner() internal view virtual {
2794         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2795     }
2796 
2797     /**
2798      * @dev Leaves the contract without owner. It will not be possible to call
2799      * `onlyOwner` functions anymore. Can only be called by the current owner.
2800      *
2801      * NOTE: Renouncing ownership will leave the contract without an owner,
2802      * thereby removing any functionality that is only available to the owner.
2803      */
2804     function renounceOwnership() public virtual onlyOwner {
2805         _transferOwnership(address(0));
2806     }
2807 
2808     /**
2809      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2810      * Can only be called by the current owner.
2811      */
2812     function transferOwnership(address newOwner) public virtual onlyOwner {
2813         require(newOwner != address(0), "Ownable: new owner is the zero address");
2814         _transferOwnership(newOwner);
2815     }
2816 
2817     /**
2818      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2819      * Internal function without access restriction.
2820      */
2821     function _transferOwnership(address newOwner) internal virtual {
2822         address oldOwner = _owner;
2823         _owner = newOwner;
2824         emit OwnershipTransferred(oldOwner, newOwner);
2825     }
2826 }
2827 
2828 // File: contracts/KASOKU.sol
2829 
2830 
2831 pragma solidity ^0.8.12;
2832 
2833 
2834 
2835 
2836 
2837 
2838 
2839 contract KASOKU is Ownable, ERC721A, PaymentSplitter, DefaultOperatorFilterer {
2840 
2841     using Strings for uint;
2842 
2843     enum Step {
2844         Before,
2845         WhitelistSale,
2846         PublicSale,
2847         SoldOut
2848     }
2849 
2850     string public baseURI;
2851 
2852     Step public sellingStep;
2853 
2854     uint public  MAX_SUPPLY = 999;
2855     uint public  MAX_TOTAL_PUBLIC = 999;
2856     uint public  MAX_TOTAL_WL = 999;
2857 
2858 
2859     uint public MAX_PER_WALLET_PUBLIC = 999;
2860     uint public MAX_PER_WALLET_WL = 3;
2861 
2862 
2863     uint public wlSalePrice = 0.01 ether;
2864     uint public publicSalePrice = 0.013 ether;
2865 
2866     bytes32 public merkleRootWL;
2867 
2868 
2869     mapping(address => uint) public amountNFTsperWalletPUBLIC;
2870     mapping(address => uint) public amountNFTsperWalletWL;
2871 
2872 
2873     uint private teamLength;
2874 
2875     uint96 royaltyFeesInBips;
2876     address royaltyReceiver;
2877 
2878     constructor(uint96 _royaltyFeesInBips, address[] memory _team, uint[] memory _teamShares, bytes32 _merkleRootWL, string memory _baseURI) ERC721A("KASOKU", "KASOKU")
2879     PaymentSplitter(_team, _teamShares) {
2880         merkleRootWL = _merkleRootWL;
2881         baseURI = _baseURI;
2882         teamLength = _team.length;
2883         royaltyFeesInBips = _royaltyFeesInBips;
2884         royaltyReceiver = msg.sender;
2885     }
2886 
2887     modifier callerIsUser() {
2888         require(tx.origin == msg.sender, "The caller is another contract");
2889         _;
2890     }
2891 
2892    function whitelistMint(address _account, uint _quantity, bytes32[] calldata _proof) external payable callerIsUser {
2893         uint price = wlSalePrice;
2894         require(sellingStep == Step.WhitelistSale, "Whitelist sale is not activated");
2895         require(isWhiteListed(msg.sender, _proof), "Not whitelisted");
2896         require(amountNFTsperWalletWL[msg.sender] + _quantity <= MAX_PER_WALLET_WL, "Max per wallet limit reached");
2897         require(totalSupply() + _quantity <= MAX_TOTAL_WL, "Max supply exceeded");
2898         require(totalSupply() + _quantity <= MAX_SUPPLY, "Max supply exceeded");
2899         require(msg.value >= price * _quantity, "Not enought funds");
2900         amountNFTsperWalletWL[msg.sender] += _quantity;
2901         _safeMint(_account, _quantity);
2902     }
2903 
2904 
2905     function publicSaleMint(address _account, uint _quantity) external payable callerIsUser {
2906         uint price = publicSalePrice;
2907         require(price != 0, "Price is 0");
2908         require(sellingStep == Step.PublicSale, "Public sale is not activated");
2909         require(totalSupply() + _quantity <= MAX_TOTAL_PUBLIC, "Max supply exceeded");
2910         require(totalSupply() + _quantity <= MAX_SUPPLY, "Max supply exceeded");
2911         require(amountNFTsperWalletPUBLIC[msg.sender] + _quantity <= MAX_PER_WALLET_PUBLIC, "Max per wallet limit reached");
2912         require(msg.value >= price * _quantity, "Not enought funds");
2913         amountNFTsperWalletPUBLIC[msg.sender] += _quantity;
2914         _safeMint(_account, _quantity);
2915     }
2916 
2917     function gift(address _to, uint _quantity) external onlyOwner {
2918         require(totalSupply() + _quantity <= MAX_SUPPLY, "Reached max Supply");
2919         _safeMint(_to, _quantity);
2920     }
2921 
2922     function lowerSupply (uint _MAX_SUPPLY) external onlyOwner{
2923         require(_MAX_SUPPLY < MAX_SUPPLY, "Cannot increase supply!");
2924         MAX_SUPPLY = _MAX_SUPPLY;
2925     }
2926 
2927     function setMaxTotalPUBLIC(uint _MAX_TOTAL_PUBLIC) external onlyOwner {
2928         MAX_TOTAL_PUBLIC = _MAX_TOTAL_PUBLIC;
2929     }
2930 
2931     function setMaxTotalWL(uint _MAX_TOTAL_WL) external onlyOwner {
2932         MAX_TOTAL_WL = _MAX_TOTAL_WL;
2933     }
2934 
2935     function setMaxPerWalletWL(uint _MAX_PER_WALLET_WL) external onlyOwner {
2936         MAX_PER_WALLET_WL = _MAX_PER_WALLET_WL;
2937     }
2938 
2939     function setMaxPerWalletPUBLIC(uint _MAX_PER_WALLET_PUBLIC) external onlyOwner {
2940         MAX_PER_WALLET_PUBLIC = _MAX_PER_WALLET_PUBLIC;
2941     }
2942 
2943     function setWLSalePrice(uint _wlSalePrice) external onlyOwner {
2944         wlSalePrice = _wlSalePrice;
2945     }
2946 
2947     function setPublicSalePrice(uint _publicSalePrice) external onlyOwner {
2948         publicSalePrice = _publicSalePrice;
2949     }
2950 
2951     function setBaseUri(string memory _baseURI) external onlyOwner {
2952         baseURI = _baseURI;
2953     }
2954 
2955     function setStep(uint _step) external onlyOwner {
2956         sellingStep = Step(_step);
2957     }
2958 
2959     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
2960         require(_exists(_tokenId), "URI query for nonexistent token");
2961 
2962         return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
2963     }
2964 
2965     //Whitelist
2966     function setMerkleRootWL(bytes32 _merkleRootWL) external onlyOwner {
2967         merkleRootWL = _merkleRootWL;
2968     }
2969 
2970     function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
2971         return _verifyWL(leaf(_account), _proof);
2972     }
2973 
2974     function leaf(address _account) internal pure returns(bytes32) {
2975         return keccak256(abi.encodePacked(_account));
2976     }
2977 
2978     function _verifyWL(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
2979         return MerkleProof.verify(_proof, merkleRootWL, _leaf);
2980     }
2981 
2982     function royaltyInfo (
2983     uint256 _tokenId,
2984     uint256 _salePrice
2985      ) external view returns (
2986         address receiver,
2987         uint256 royaltyAmount
2988      ){
2989          return (royaltyReceiver, calculateRoyalty(_salePrice));
2990      }
2991 
2992     function calculateRoyalty(uint256 _salePrice) view public returns (uint256){
2993         return(_salePrice / 10000) * royaltyFeesInBips;
2994     }
2995 
2996     function setRoyaltyInfo (address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
2997         royaltyReceiver = _receiver;
2998         royaltyFeesInBips = _royaltyFeesInBips;
2999     }
3000 
3001     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3002         super.setApprovalForAll(operator, approved);
3003     }
3004 
3005     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
3006         super.approve(operator, tokenId);
3007     }
3008 
3009     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3010         super.transferFrom(from, to, tokenId);
3011     }
3012 
3013     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3014         super.safeTransferFrom(from, to, tokenId);
3015     }
3016     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3017         public
3018         override
3019         onlyAllowedOperator(from)
3020     {
3021         super.safeTransferFrom(from, to, tokenId, data);
3022     }
3023 
3024     //ReleaseALL
3025     function releaseAll() external onlyOwner {
3026         for(uint i = 0 ; i < teamLength ; i++) {
3027             release(payable(payee(i)));
3028         }
3029     }
3030 
3031     receive() override external payable {
3032         revert('Only if you mint');
3033     }
3034 
3035 }