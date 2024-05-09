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
12 
13 
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
31      * Cannot query the balance for the zero address.
32      */
33     error BalanceQueryForZeroAddress();
34 
35     /**
36      * Cannot mint to the zero address.
37      */
38     error MintToZeroAddress();
39 
40     /**
41      * The quantity of tokens minted must be more than zero.
42      */
43     error MintZeroQuantity();
44 
45     /**
46      * The token does not exist.
47      */
48     error OwnerQueryForNonexistentToken();
49 
50     /**
51      * The caller must own the token or be an approved operator.
52      */
53     error TransferCallerNotOwnerNorApproved();
54 
55     /**
56      * The token must be owned by `from`.
57      */
58     error TransferFromIncorrectOwner();
59 
60     /**
61      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
62      */
63     error TransferToNonERC721ReceiverImplementer();
64 
65     /**
66      * Cannot transfer to the zero address.
67      */
68     error TransferToZeroAddress();
69 
70     /**
71      * The token does not exist.
72      */
73     error URIQueryForNonexistentToken();
74 
75     /**
76      * The `quantity` minted with ERC2309 exceeds the safety limit.
77      */
78     error MintERC2309QuantityExceedsLimit();
79 
80     /**
81      * The `extraData` cannot be set on an unintialized ownership slot.
82      */
83     error OwnershipNotInitializedForExtraData();
84 
85     struct TokenOwnership {
86         // The address of the owner.
87         address addr;
88         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
89         uint64 startTimestamp;
90         // Whether the token has been burned.
91         bool burned;
92         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
93         uint24 extraData;
94     }
95 
96     /**
97      * @dev Returns the total amount of tokens stored by the contract.
98      *
99      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     // ==============================
104     //            IERC165
105     // ==============================
106 
107     /**
108      * @dev Returns true if this contract implements the interface defined by
109      * `interfaceId`. See the corresponding
110      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
111      * to learn more about how these ids are created.
112      *
113      * This function call must use less than 30 000 gas.
114      */
115     function supportsInterface(bytes4 interfaceId) external view returns (bool);
116 
117     // ==============================
118     //            IERC721
119     // ==============================
120 
121     /**
122      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
125 
126     /**
127      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
128      */
129     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
133      */
134     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
135 
136     /**
137      * @dev Returns the number of tokens in ``owner``'s account.
138      */
139     function balanceOf(address owner) external view returns (uint256 balance);
140 
141     /**
142      * @dev Returns the owner of the `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function ownerOf(uint256 tokenId) external view returns (address owner);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
172      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external;
189 
190     /**
191      * @dev Transfers `tokenId` token from `from` to `to`.
192      *
193      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external;
209 
210     /**
211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
212      * The approval is cleared when the token is transferred.
213      *
214      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external;
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns the account approved for `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function getApproved(uint256 tokenId) external view returns (address operator);
245 
246     /**
247      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
248      *
249      * See {setApprovalForAll}
250      */
251     function isApprovedForAll(address owner, address operator) external view returns (bool);
252 
253     // ==============================
254     //        IERC721Metadata
255     // ==============================
256 
257     /**
258      * @dev Returns the token collection name.
259      */
260     function name() external view returns (string memory);
261 
262     /**
263      * @dev Returns the token collection symbol.
264      */
265     function symbol() external view returns (string memory);
266 
267     /**
268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
269      */
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 
272     // ==============================
273     //            IERC2309
274     // ==============================
275 
276     /**
277      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
278      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
279      */
280     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
281 }
282 // File: contracts/ERC721A_royalty.sol
283 
284 
285 // ERC721A Contracts v4.1.0
286 // Creator: Chiru Labs
287 
288 pragma solidity ^0.8.4;
289 
290 
291 /**
292  * @dev ERC721 token receiver interface.
293  */
294 interface ERC721A__IERC721Receiver {
295     function onERC721Received(
296         address operator,
297         address from,
298         uint256 tokenId,
299         bytes calldata data
300     ) external returns (bytes4);
301 }
302 
303 /**
304  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
305  * including the Metadata extension. Built to optimize for lower gas during batch mints.
306  *
307  * Assumes serials are sequentially minted starting at `_startTokenId()`
308  * (defaults to 0, e.g. 0, 1, 2, 3..).
309  *
310  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
311  *
312  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
313  */
314 contract ERC721A is IERC721A {
315     // Mask of an entry in packed address data.
316     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
317 
318     // The bit position of `numberMinted` in packed address data.
319     uint256 private constant BITPOS_NUMBER_MINTED = 64;
320 
321     // The bit position of `numberBurned` in packed address data.
322     uint256 private constant BITPOS_NUMBER_BURNED = 128;
323 
324     // The bit position of `aux` in packed address data.
325     uint256 private constant BITPOS_AUX = 192;
326 
327     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
328     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
329 
330     // The bit position of `startTimestamp` in packed ownership.
331     uint256 private constant BITPOS_START_TIMESTAMP = 160;
332 
333     // The bit mask of the `burned` bit in packed ownership.
334     uint256 private constant BITMASK_BURNED = 1 << 224;
335 
336     // The bit position of the `nextInitialized` bit in packed ownership.
337     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
338 
339     // The bit mask of the `nextInitialized` bit in packed ownership.
340     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
341 
342     // The bit position of `extraData` in packed ownership.
343     uint256 private constant BITPOS_EXTRA_DATA = 232;
344 
345     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
346     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
347 
348     // The mask of the lower 160 bits for addresses.
349     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
350 
351     // The maximum `quantity` that can be minted with `_mintERC2309`.
352     // This limit is to prevent overflows on the address data entries.
353     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
354     // is required to cause an overflow, which is unrealistic.
355     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
356 
357     // The tokenId of the next token to be minted.
358     uint256 private _currentIndex;
359 
360     // The number of tokens burned.
361     uint256 private _burnCounter;
362 
363     // Token name
364     string private _name;
365 
366     // Token symbol
367     string private _symbol;
368 
369     // Mapping from token ID to ownership details
370     // An empty struct value does not necessarily mean the token is unowned.
371     // See `_packedOwnershipOf` implementation for details.
372     //
373     // Bits Layout:
374     // - [0..159]   `addr`
375     // - [160..223] `startTimestamp`
376     // - [224]      `burned`
377     // - [225]      `nextInitialized`
378     // - [232..255] `extraData`
379     mapping(uint256 => uint256) private _packedOwnerships;
380 
381     // Mapping owner address to address data.
382     //
383     // Bits Layout:
384     // - [0..63]    `balance`
385     // - [64..127]  `numberMinted`
386     // - [128..191] `numberBurned`
387     // - [192..255] `aux`
388     mapping(address => uint256) private _packedAddressData;
389 
390     // Mapping from token ID to approved address.
391     mapping(uint256 => address) private _tokenApprovals;
392 
393     // Mapping from owner to operator approvals
394     mapping(address => mapping(address => bool)) private _operatorApprovals;
395 
396     constructor(string memory name_, string memory symbol_) {
397         _name = name_;
398         _symbol = symbol_;
399         _currentIndex = _startTokenId();
400     }
401 
402     /**
403      * @dev Returns the starting token ID.
404      * To change the starting token ID, please override this function.
405      */
406     function _startTokenId() internal view virtual returns (uint256) {
407         return 1;
408     }
409 
410     /**
411      * @dev Returns the next token ID to be minted.
412      */
413     function _nextTokenId() internal view returns (uint256) {
414         return _currentIndex;
415     }
416 
417     /**
418      * @dev Returns the total number of tokens in existence.
419      * Burned tokens will reduce the count.
420      * To get the total number of tokens minted, please see `_totalMinted`.
421      */
422     function totalSupply() public view override returns (uint256) {
423         // Counter underflow is impossible as _burnCounter cannot be incremented
424         // more than `_currentIndex - _startTokenId()` times.
425         unchecked {
426             return _currentIndex - _burnCounter - _startTokenId();
427         }
428     }
429 
430     /**
431      * @dev Returns the total amount of tokens minted in the contract.
432      */
433     function _totalMinted() internal view returns (uint256) {
434         // Counter underflow is impossible as _currentIndex does not decrement,
435         // and it is initialized to `_startTokenId()`
436         unchecked {
437             return _currentIndex - _startTokenId();
438         }
439     }
440 
441     /**
442      * @dev Returns the total number of tokens burned.
443      */
444     function _totalBurned() internal view returns (uint256) {
445         return _burnCounter;
446     }
447 
448     /**
449      * @dev See {IERC165-supportsInterface}.
450      */
451     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
452         // The interface IDs are constants representing the first 4 bytes of the XOR of
453         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
454         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
455         return
456             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
457             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
458             interfaceId == 0x2a55205a || // ERC 2981 rotyalty
459             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
460     }
461 
462     /**
463      * @dev See {IERC721-balanceOf}.
464      */
465     function balanceOf(address owner) public view override returns (uint256) {
466         if (owner == address(0)) revert BalanceQueryForZeroAddress();
467         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
468     }
469 
470     /**
471      * Returns the number of tokens minted by `owner`.
472      */
473     function _numberMinted(address owner) internal view returns (uint256) {
474         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
475     }
476 
477     /**
478      * Returns the number of tokens burned by or on behalf of `owner`.
479      */
480     function _numberBurned(address owner) internal view returns (uint256) {
481         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
482     }
483 
484     /**
485      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
486      */
487     function _getAux(address owner) internal view returns (uint64) {
488         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
489     }
490 
491     /**
492      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
493      * If there are multiple variables, please pack them into a uint64.
494      */
495     function _setAux(address owner, uint64 aux) internal {
496         uint256 packed = _packedAddressData[owner];
497         uint256 auxCasted;
498         // Cast `aux` with assembly to avoid redundant masking.
499         assembly {
500             auxCasted := aux
501         }
502         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
503         _packedAddressData[owner] = packed;
504     }
505 
506     /**
507      * Returns the packed ownership data of `tokenId`.
508      */
509     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
510         uint256 curr = tokenId;
511 
512         unchecked {
513             if (_startTokenId() <= curr)
514                 if (curr < _currentIndex) {
515                     uint256 packed = _packedOwnerships[curr];
516                     // If not burned.
517                     if (packed & BITMASK_BURNED == 0) {
518                         // Invariant:
519                         // There will always be an ownership that has an address and is not burned
520                         // before an ownership that does not have an address and is not burned.
521                         // Hence, curr will not underflow.
522                         //
523                         // We can directly compare the packed value.
524                         // If the address is zero, packed is zero.
525                         while (packed == 0) {
526                             packed = _packedOwnerships[--curr];
527                         }
528                         return packed;
529                     }
530                 }
531         }
532         revert OwnerQueryForNonexistentToken();
533     }
534 
535     /**
536      * Returns the unpacked `TokenOwnership` struct from `packed`.
537      */
538     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
539         ownership.addr = address(uint160(packed));
540         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
541         ownership.burned = packed & BITMASK_BURNED != 0;
542         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
543     }
544 
545     /**
546      * Returns the unpacked `TokenOwnership` struct at `index`.
547      */
548     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
549         return _unpackedOwnership(_packedOwnerships[index]);
550     }
551 
552     /**
553      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
554      */
555     function _initializeOwnershipAt(uint256 index) internal {
556         if (_packedOwnerships[index] == 0) {
557             _packedOwnerships[index] = _packedOwnershipOf(index);
558         }
559     }
560 
561     /**
562      * Gas spent here starts off proportional to the maximum mint batch size.
563      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
564      */
565     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
566         return _unpackedOwnership(_packedOwnershipOf(tokenId));
567     }
568 
569     /**
570      * @dev Packs ownership data into a single uint256.
571      */
572     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
573         assembly {
574             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
575             owner := and(owner, BITMASK_ADDRESS)
576             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
577             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
578         }
579     }
580 
581     /**
582      * @dev See {IERC721-ownerOf}.
583      */
584     function ownerOf(uint256 tokenId) public view override returns (address) {
585         return address(uint160(_packedOwnershipOf(tokenId)));
586     }
587 
588     /**
589      * @dev See {IERC721Metadata-name}.
590      */
591     function name() public view virtual override returns (string memory) {
592         return _name;
593     }
594 
595     /**
596      * @dev See {IERC721Metadata-symbol}.
597      */
598     function symbol() public view virtual override returns (string memory) {
599         return _symbol;
600     }
601 
602     /**
603      * @dev See {IERC721Metadata-tokenURI}.
604      */
605     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
606         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
607 
608         string memory baseURI = _baseURI();
609         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
610     }
611 
612     /**
613      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
614      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
615      * by default, it can be overridden in child contracts.
616      */
617     function _baseURI() internal view virtual returns (string memory) {
618         return '';
619     }
620 
621     /**
622      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
623      */
624     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
625         // For branchless setting of the `nextInitialized` flag.
626         assembly {
627             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
628             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
629         }
630     }
631 
632     /**
633      * @dev See {IERC721-approve}.
634      */
635     function approve(address to, uint256 tokenId) public virtual override {
636         address owner = ownerOf(tokenId);
637         if (_msgSenderERC721A() != owner)
638             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
639                 revert ApprovalCallerNotOwnerNorApproved();
640             }
641 
642         _tokenApprovals[tokenId] = to;
643         emit Approval(owner, to, tokenId);
644     }
645 
646     /**
647      * @dev See {IERC721-getApproved}.
648      */
649     function getApproved(uint256 tokenId) public view override returns (address) {
650         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
651 
652         return _tokenApprovals[tokenId];
653     }
654 
655     /**
656      * @dev See {IERC721-setApprovalForAll}.
657      */
658     function setApprovalForAll(address operator, bool approved) public virtual override {
659         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
660         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
661         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
662     }
663     
664 
665     /**
666      * @dev See {IERC721-isApprovedForAll}.
667      */
668     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
669         return _operatorApprovals[owner][operator];
670     }
671 
672     /**
673      * @dev See {IERC721-safeTransferFrom}.
674      */
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) public virtual override {
680         safeTransferFrom(from, to, tokenId, '');
681     }
682 
683     /**
684      * @dev See {IERC721-safeTransferFrom}.
685      */
686     function safeTransferFrom(
687         address from,
688         address to,
689         uint256 tokenId,
690         bytes memory _data
691     ) public virtual override {
692         transferFrom(from, to, tokenId);
693         if (to.code.length != 0)
694             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
695                 revert TransferToNonERC721ReceiverImplementer();
696             }
697     }
698 
699     /**
700      * @dev Returns whether `tokenId` exists.
701      *
702      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
703      *
704      * Tokens start existing when they are minted (`_mint`),
705      */
706     function _exists(uint256 tokenId) internal view returns (bool) {
707         return
708             _startTokenId() <= tokenId &&
709             tokenId < _currentIndex && // If within bounds,
710             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
711     }
712 
713     /**
714      * @dev Equivalent to `_safeMint(to, quantity, '')`.
715      */
716     function _safeMint(address to, uint256 quantity) internal {
717         _safeMint(to, quantity, '');
718     }
719 
720     /**
721      * @dev Safely mints `quantity` tokens and transfers them to `to`.
722      *
723      * Requirements:
724      *
725      * - If `to` refers to a smart contract, it must implement
726      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
727      * - `quantity` must be greater than 0.
728      *
729      * See {_mint}.
730      *
731      * Emits a {Transfer} event for each mint.
732      */
733     function _safeMint(
734         address to,
735         uint256 quantity,
736         bytes memory _data
737     ) internal {
738         _mint(to, quantity);
739 
740         unchecked {
741             if (to.code.length != 0) {
742                 uint256 end = _currentIndex;
743                 uint256 index = end - quantity;
744                 do {
745                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
746                         revert TransferToNonERC721ReceiverImplementer();
747                     }
748                 } while (index < end);
749                 // Reentrancy protection.
750                 if (_currentIndex != end) revert();
751             }
752         }
753     }
754 
755     /**
756      * @dev Mints `quantity` tokens and transfers them to `to`.
757      *
758      * Requirements:
759      *
760      * - `to` cannot be the zero address.
761      * - `quantity` must be greater than 0.
762      *
763      * Emits a {Transfer} event for each mint.
764      */
765     function _mint(address to, uint256 quantity) internal {
766         uint256 startTokenId = _currentIndex;
767         if (to == address(0)) revert MintToZeroAddress();
768         if (quantity == 0) revert MintZeroQuantity();
769 
770         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
771 
772         // Overflows are incredibly unrealistic.
773         // `balance` and `numberMinted` have a maximum limit of 2**64.
774         // `tokenId` has a maximum limit of 2**256.
775         unchecked {
776             // Updates:
777             // - `balance += quantity`.
778             // - `numberMinted += quantity`.
779             //
780             // We can directly add to the `balance` and `numberMinted`.
781             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
782 
783             // Updates:
784             // - `address` to the owner.
785             // - `startTimestamp` to the timestamp of minting.
786             // - `burned` to `false`.
787             // - `nextInitialized` to `quantity == 1`.
788             _packedOwnerships[startTokenId] = _packOwnershipData(
789                 to,
790                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
791             );
792 
793             uint256 tokenId = startTokenId;
794             uint256 end = startTokenId + quantity;
795             do {
796                 emit Transfer(address(0), to, tokenId++);
797             } while (tokenId < end);
798 
799             _currentIndex = end;
800         }
801         _afterTokenTransfers(address(0), to, startTokenId, quantity);
802     }
803 
804     /**
805      * @dev Mints `quantity` tokens and transfers them to `to`.
806      *
807      * This function is intended for efficient minting only during contract creation.
808      *
809      * It emits only one {ConsecutiveTransfer} as defined in
810      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
811      * instead of a sequence of {Transfer} event(s).
812      *
813      * Calling this function outside of contract creation WILL make your contract
814      * non-compliant with the ERC721 standard.
815      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
816      * {ConsecutiveTransfer} event is only permissible during contract creation.
817      *
818      * Requirements:
819      *
820      * - `to` cannot be the zero address.
821      * - `quantity` must be greater than 0.
822      *
823      * Emits a {ConsecutiveTransfer} event.
824      */
825     function _mintERC2309(address to, uint256 quantity) internal {
826         uint256 startTokenId = _currentIndex;
827         if (to == address(0)) revert MintToZeroAddress();
828         if (quantity == 0) revert MintZeroQuantity();
829         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
830 
831         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
832 
833         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
834         unchecked {
835             // Updates:
836             // - `balance += quantity`.
837             // - `numberMinted += quantity`.
838             //
839             // We can directly add to the `balance` and `numberMinted`.
840             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
841 
842             // Updates:
843             // - `address` to the owner.
844             // - `startTimestamp` to the timestamp of minting.
845             // - `burned` to `false`.
846             // - `nextInitialized` to `quantity == 1`.
847             _packedOwnerships[startTokenId] = _packOwnershipData(
848                 to,
849                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
850             );
851 
852             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
853 
854             _currentIndex = startTokenId + quantity;
855         }
856         _afterTokenTransfers(address(0), to, startTokenId, quantity);
857     }
858 
859     /**
860      * @dev Returns the storage slot and value for the approved address of `tokenId`.
861      */
862     function _getApprovedAddress(uint256 tokenId)
863         private
864         view
865         returns (uint256 approvedAddressSlot, address approvedAddress)
866     {
867         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
868         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
869         assembly {
870             // Compute the slot.
871             mstore(0x00, tokenId)
872             mstore(0x20, tokenApprovalsPtr.slot)
873             approvedAddressSlot := keccak256(0x00, 0x40)
874             // Load the slot's value from storage.
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
1088     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
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
1191     function _toString(uint256 value) internal pure returns (string memory ptr) {
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
1233 // File: contracts/IOperatorFilterRegistry.sol
1234 
1235 
1236 pragma solidity ^0.8.13;
1237 
1238 interface IOperatorFilterRegistry {
1239     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1240     function register(address registrant) external;
1241     function registerAndSubscribe(address registrant, address subscription) external;
1242     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1243     function unregister(address addr) external;
1244     function updateOperator(address registrant, address operator, bool filtered) external;
1245     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1246     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1247     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1248     function subscribe(address registrant, address registrantToSubscribe) external;
1249     function unsubscribe(address registrant, bool copyExistingEntries) external;
1250     function subscriptionOf(address addr) external returns (address registrant);
1251     function subscribers(address registrant) external returns (address[] memory);
1252     function subscriberAt(address registrant, uint256 index) external returns (address);
1253     function copyEntriesOf(address registrant, address registrantToCopy) external;
1254     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1255     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1256     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1257     function filteredOperators(address addr) external returns (address[] memory);
1258     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1259     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1260     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1261     function isRegistered(address addr) external returns (bool);
1262     function codeHashOf(address addr) external returns (bytes32);
1263 }
1264 
1265 // File: contracts/OperatorFilterer.sol
1266 
1267 
1268 pragma solidity ^0.8.13;
1269 
1270 
1271 /**
1272  * @title  OperatorFilterer
1273  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1274  *         registrant's entries in the OperatorFilterRegistry.
1275  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1276  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1277  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1278  */
1279 abstract contract OperatorFilterer {
1280     error OperatorNotAllowed(address operator);
1281 
1282     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1283         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1284 
1285     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1286         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1287         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1288         // order for the modifier to filter addresses.
1289         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1290             if (subscribe) {
1291                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1292             } else {
1293                 if (subscriptionOrRegistrantToCopy != address(0)) {
1294                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1295                 } else {
1296                     OPERATOR_FILTER_REGISTRY.register(address(this));
1297                 }
1298             }
1299         }
1300     }
1301 
1302     modifier onlyAllowedOperator(address from) virtual {
1303         // Allow spending tokens from addresses with balance
1304         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1305         // from an EOA.
1306         if (from != msg.sender) {
1307             _checkFilterOperator(msg.sender);
1308         }
1309         _;
1310     }
1311 
1312     modifier onlyAllowedOperatorApproval(address operator) virtual {
1313         _checkFilterOperator(operator);
1314         _;
1315     }
1316 
1317     function _checkFilterOperator(address operator) internal view virtual {
1318         // Check registry code length to facilitate testing in environments without a deployed registry.
1319         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1320             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1321                 revert OperatorNotAllowed(operator);
1322             }
1323         }
1324     }
1325 }
1326 
1327 // File: contracts/DefaultOperatorFilterer.sol
1328 
1329 
1330 pragma solidity ^0.8.13;
1331 
1332 
1333 /**
1334  * @title  DefaultOperatorFilterer
1335  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1336  */
1337 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1338     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1339 
1340     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1341 }
1342 
1343 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
1344 
1345 
1346 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
1347 
1348 pragma solidity ^0.8.0;
1349 
1350 /**
1351  * @dev Standard signed math utilities missing in the Solidity language.
1352  */
1353 library SignedMath {
1354     /**
1355      * @dev Returns the largest of two signed numbers.
1356      */
1357     function max(int256 a, int256 b) internal pure returns (int256) {
1358         return a > b ? a : b;
1359     }
1360 
1361     /**
1362      * @dev Returns the smallest of two signed numbers.
1363      */
1364     function min(int256 a, int256 b) internal pure returns (int256) {
1365         return a < b ? a : b;
1366     }
1367 
1368     /**
1369      * @dev Returns the average of two signed numbers without overflow.
1370      * The result is rounded towards zero.
1371      */
1372     function average(int256 a, int256 b) internal pure returns (int256) {
1373         // Formula from the book "Hacker's Delight"
1374         int256 x = (a & b) + ((a ^ b) >> 1);
1375         return x + (int256(uint256(x) >> 255) & (a ^ b));
1376     }
1377 
1378     /**
1379      * @dev Returns the absolute unsigned value of a signed value.
1380      */
1381     function abs(int256 n) internal pure returns (uint256) {
1382         unchecked {
1383             // must be unchecked in order to support `n = type(int256).min`
1384             return uint256(n >= 0 ? n : -n);
1385         }
1386     }
1387 }
1388 
1389 // File: @openzeppelin/contracts/utils/math/Math.sol
1390 
1391 
1392 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
1393 
1394 pragma solidity ^0.8.0;
1395 
1396 /**
1397  * @dev Standard math utilities missing in the Solidity language.
1398  */
1399 library Math {
1400     enum Rounding {
1401         Down, // Toward negative infinity
1402         Up, // Toward infinity
1403         Zero // Toward zero
1404     }
1405 
1406     /**
1407      * @dev Returns the largest of two numbers.
1408      */
1409     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1410         return a > b ? a : b;
1411     }
1412 
1413     /**
1414      * @dev Returns the smallest of two numbers.
1415      */
1416     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1417         return a < b ? a : b;
1418     }
1419 
1420     /**
1421      * @dev Returns the average of two numbers. The result is rounded towards
1422      * zero.
1423      */
1424     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1425         // (a + b) / 2 can overflow.
1426         return (a & b) + (a ^ b) / 2;
1427     }
1428 
1429     /**
1430      * @dev Returns the ceiling of the division of two numbers.
1431      *
1432      * This differs from standard division with `/` in that it rounds up instead
1433      * of rounding down.
1434      */
1435     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1436         // (a + b - 1) / b can overflow on addition, so we distribute.
1437         return a == 0 ? 0 : (a - 1) / b + 1;
1438     }
1439 
1440     /**
1441      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1442      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1443      * with further edits by Uniswap Labs also under MIT license.
1444      */
1445     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
1446         unchecked {
1447             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1448             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1449             // variables such that product = prod1 * 2^256 + prod0.
1450             uint256 prod0; // Least significant 256 bits of the product
1451             uint256 prod1; // Most significant 256 bits of the product
1452             assembly {
1453                 let mm := mulmod(x, y, not(0))
1454                 prod0 := mul(x, y)
1455                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1456             }
1457 
1458             // Handle non-overflow cases, 256 by 256 division.
1459             if (prod1 == 0) {
1460                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
1461                 // The surrounding unchecked block does not change this fact.
1462                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
1463                 return prod0 / denominator;
1464             }
1465 
1466             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1467             require(denominator > prod1, "Math: mulDiv overflow");
1468 
1469             ///////////////////////////////////////////////
1470             // 512 by 256 division.
1471             ///////////////////////////////////////////////
1472 
1473             // Make division exact by subtracting the remainder from [prod1 prod0].
1474             uint256 remainder;
1475             assembly {
1476                 // Compute remainder using mulmod.
1477                 remainder := mulmod(x, y, denominator)
1478 
1479                 // Subtract 256 bit number from 512 bit number.
1480                 prod1 := sub(prod1, gt(remainder, prod0))
1481                 prod0 := sub(prod0, remainder)
1482             }
1483 
1484             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1485             // See https://cs.stackexchange.com/q/138556/92363.
1486 
1487             // Does not overflow because the denominator cannot be zero at this stage in the function.
1488             uint256 twos = denominator & (~denominator + 1);
1489             assembly {
1490                 // Divide denominator by twos.
1491                 denominator := div(denominator, twos)
1492 
1493                 // Divide [prod1 prod0] by twos.
1494                 prod0 := div(prod0, twos)
1495 
1496                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1497                 twos := add(div(sub(0, twos), twos), 1)
1498             }
1499 
1500             // Shift in bits from prod1 into prod0.
1501             prod0 |= prod1 * twos;
1502 
1503             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1504             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1505             // four bits. That is, denominator * inv = 1 mod 2^4.
1506             uint256 inverse = (3 * denominator) ^ 2;
1507 
1508             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1509             // in modular arithmetic, doubling the correct bits in each step.
1510             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1511             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1512             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1513             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1514             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1515             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1516 
1517             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1518             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1519             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1520             // is no longer required.
1521             result = prod0 * inverse;
1522             return result;
1523         }
1524     }
1525 
1526     /**
1527      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1528      */
1529     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
1530         uint256 result = mulDiv(x, y, denominator);
1531         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1532             result += 1;
1533         }
1534         return result;
1535     }
1536 
1537     /**
1538      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1539      *
1540      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1541      */
1542     function sqrt(uint256 a) internal pure returns (uint256) {
1543         if (a == 0) {
1544             return 0;
1545         }
1546 
1547         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1548         //
1549         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1550         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1551         //
1552         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1553         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1554         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1555         //
1556         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1557         uint256 result = 1 << (log2(a) >> 1);
1558 
1559         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1560         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1561         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1562         // into the expected uint128 result.
1563         unchecked {
1564             result = (result + a / result) >> 1;
1565             result = (result + a / result) >> 1;
1566             result = (result + a / result) >> 1;
1567             result = (result + a / result) >> 1;
1568             result = (result + a / result) >> 1;
1569             result = (result + a / result) >> 1;
1570             result = (result + a / result) >> 1;
1571             return min(result, a / result);
1572         }
1573     }
1574 
1575     /**
1576      * @notice Calculates sqrt(a), following the selected rounding direction.
1577      */
1578     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1579         unchecked {
1580             uint256 result = sqrt(a);
1581             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1582         }
1583     }
1584 
1585     /**
1586      * @dev Return the log in base 2, rounded down, of a positive value.
1587      * Returns 0 if given 0.
1588      */
1589     function log2(uint256 value) internal pure returns (uint256) {
1590         uint256 result = 0;
1591         unchecked {
1592             if (value >> 128 > 0) {
1593                 value >>= 128;
1594                 result += 128;
1595             }
1596             if (value >> 64 > 0) {
1597                 value >>= 64;
1598                 result += 64;
1599             }
1600             if (value >> 32 > 0) {
1601                 value >>= 32;
1602                 result += 32;
1603             }
1604             if (value >> 16 > 0) {
1605                 value >>= 16;
1606                 result += 16;
1607             }
1608             if (value >> 8 > 0) {
1609                 value >>= 8;
1610                 result += 8;
1611             }
1612             if (value >> 4 > 0) {
1613                 value >>= 4;
1614                 result += 4;
1615             }
1616             if (value >> 2 > 0) {
1617                 value >>= 2;
1618                 result += 2;
1619             }
1620             if (value >> 1 > 0) {
1621                 result += 1;
1622             }
1623         }
1624         return result;
1625     }
1626 
1627     /**
1628      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1629      * Returns 0 if given 0.
1630      */
1631     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1632         unchecked {
1633             uint256 result = log2(value);
1634             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1635         }
1636     }
1637 
1638     /**
1639      * @dev Return the log in base 10, rounded down, of a positive value.
1640      * Returns 0 if given 0.
1641      */
1642     function log10(uint256 value) internal pure returns (uint256) {
1643         uint256 result = 0;
1644         unchecked {
1645             if (value >= 10 ** 64) {
1646                 value /= 10 ** 64;
1647                 result += 64;
1648             }
1649             if (value >= 10 ** 32) {
1650                 value /= 10 ** 32;
1651                 result += 32;
1652             }
1653             if (value >= 10 ** 16) {
1654                 value /= 10 ** 16;
1655                 result += 16;
1656             }
1657             if (value >= 10 ** 8) {
1658                 value /= 10 ** 8;
1659                 result += 8;
1660             }
1661             if (value >= 10 ** 4) {
1662                 value /= 10 ** 4;
1663                 result += 4;
1664             }
1665             if (value >= 10 ** 2) {
1666                 value /= 10 ** 2;
1667                 result += 2;
1668             }
1669             if (value >= 10 ** 1) {
1670                 result += 1;
1671             }
1672         }
1673         return result;
1674     }
1675 
1676     /**
1677      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1678      * Returns 0 if given 0.
1679      */
1680     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1681         unchecked {
1682             uint256 result = log10(value);
1683             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
1684         }
1685     }
1686 
1687     /**
1688      * @dev Return the log in base 256, rounded down, of a positive value.
1689      * Returns 0 if given 0.
1690      *
1691      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1692      */
1693     function log256(uint256 value) internal pure returns (uint256) {
1694         uint256 result = 0;
1695         unchecked {
1696             if (value >> 128 > 0) {
1697                 value >>= 128;
1698                 result += 16;
1699             }
1700             if (value >> 64 > 0) {
1701                 value >>= 64;
1702                 result += 8;
1703             }
1704             if (value >> 32 > 0) {
1705                 value >>= 32;
1706                 result += 4;
1707             }
1708             if (value >> 16 > 0) {
1709                 value >>= 16;
1710                 result += 2;
1711             }
1712             if (value >> 8 > 0) {
1713                 result += 1;
1714             }
1715         }
1716         return result;
1717     }
1718 
1719     /**
1720      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
1721      * Returns 0 if given 0.
1722      */
1723     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1724         unchecked {
1725             uint256 result = log256(value);
1726             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
1727         }
1728     }
1729 }
1730 
1731 // File: @openzeppelin/contracts/utils/Strings.sol
1732 
1733 
1734 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
1735 
1736 pragma solidity ^0.8.0;
1737 
1738 
1739 
1740 /**
1741  * @dev String operations.
1742  */
1743 library Strings {
1744     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1745     uint8 private constant _ADDRESS_LENGTH = 20;
1746 
1747     /**
1748      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1749      */
1750     function toString(uint256 value) internal pure returns (string memory) {
1751         unchecked {
1752             uint256 length = Math.log10(value) + 1;
1753             string memory buffer = new string(length);
1754             uint256 ptr;
1755             /// @solidity memory-safe-assembly
1756             assembly {
1757                 ptr := add(buffer, add(32, length))
1758             }
1759             while (true) {
1760                 ptr--;
1761                 /// @solidity memory-safe-assembly
1762                 assembly {
1763                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1764                 }
1765                 value /= 10;
1766                 if (value == 0) break;
1767             }
1768             return buffer;
1769         }
1770     }
1771 
1772     /**
1773      * @dev Converts a `int256` to its ASCII `string` decimal representation.
1774      */
1775     function toString(int256 value) internal pure returns (string memory) {
1776         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
1777     }
1778 
1779     /**
1780      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1781      */
1782     function toHexString(uint256 value) internal pure returns (string memory) {
1783         unchecked {
1784             return toHexString(value, Math.log256(value) + 1);
1785         }
1786     }
1787 
1788     /**
1789      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1790      */
1791     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1792         bytes memory buffer = new bytes(2 * length + 2);
1793         buffer[0] = "0";
1794         buffer[1] = "x";
1795         for (uint256 i = 2 * length + 1; i > 1; --i) {
1796             buffer[i] = _SYMBOLS[value & 0xf];
1797             value >>= 4;
1798         }
1799         require(value == 0, "Strings: hex length insufficient");
1800         return string(buffer);
1801     }
1802 
1803     /**
1804      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1805      */
1806     function toHexString(address addr) internal pure returns (string memory) {
1807         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1808     }
1809 
1810     /**
1811      * @dev Returns true if the two strings are equal.
1812      */
1813     function equal(string memory a, string memory b) internal pure returns (bool) {
1814         return keccak256(bytes(a)) == keccak256(bytes(b));
1815     }
1816 }
1817 
1818 // File: @openzeppelin/contracts/utils/Address.sol
1819 
1820 
1821 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
1822 
1823 pragma solidity ^0.8.1;
1824 
1825 /**
1826  * @dev Collection of functions related to the address type
1827  */
1828 library Address {
1829     /**
1830      * @dev Returns true if `account` is a contract.
1831      *
1832      * [IMPORTANT]
1833      * ====
1834      * It is unsafe to assume that an address for which this function returns
1835      * false is an externally-owned account (EOA) and not a contract.
1836      *
1837      * Among others, `isContract` will return false for the following
1838      * types of addresses:
1839      *
1840      *  - an externally-owned account
1841      *  - a contract in construction
1842      *  - an address where a contract will be created
1843      *  - an address where a contract lived, but was destroyed
1844      *
1845      * Furthermore, `isContract` will also return true if the target contract within
1846      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
1847      * which only has an effect at the end of a transaction.
1848      * ====
1849      *
1850      * [IMPORTANT]
1851      * ====
1852      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1853      *
1854      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1855      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1856      * constructor.
1857      * ====
1858      */
1859     function isContract(address account) internal view returns (bool) {
1860         // This method relies on extcodesize/address.code.length, which returns 0
1861         // for contracts in construction, since the code is only stored at the end
1862         // of the constructor execution.
1863 
1864         return account.code.length > 0;
1865     }
1866 
1867     /**
1868      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1869      * `recipient`, forwarding all available gas and reverting on errors.
1870      *
1871      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1872      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1873      * imposed by `transfer`, making them unable to receive funds via
1874      * `transfer`. {sendValue} removes this limitation.
1875      *
1876      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1877      *
1878      * IMPORTANT: because control is transferred to `recipient`, care must be
1879      * taken to not create reentrancy vulnerabilities. Consider using
1880      * {ReentrancyGuard} or the
1881      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1882      */
1883     function sendValue(address payable recipient, uint256 amount) internal {
1884         require(address(this).balance >= amount, "Address: insufficient balance");
1885 
1886         (bool success, ) = recipient.call{value: amount}("");
1887         require(success, "Address: unable to send value, recipient may have reverted");
1888     }
1889 
1890     /**
1891      * @dev Performs a Solidity function call using a low level `call`. A
1892      * plain `call` is an unsafe replacement for a function call: use this
1893      * function instead.
1894      *
1895      * If `target` reverts with a revert reason, it is bubbled up by this
1896      * function (like regular Solidity function calls).
1897      *
1898      * Returns the raw returned data. To convert to the expected return value,
1899      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1900      *
1901      * Requirements:
1902      *
1903      * - `target` must be a contract.
1904      * - calling `target` with `data` must not revert.
1905      *
1906      * _Available since v3.1._
1907      */
1908     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1909         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1910     }
1911 
1912     /**
1913      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1914      * `errorMessage` as a fallback revert reason when `target` reverts.
1915      *
1916      * _Available since v3.1._
1917      */
1918     function functionCall(
1919         address target,
1920         bytes memory data,
1921         string memory errorMessage
1922     ) internal returns (bytes memory) {
1923         return functionCallWithValue(target, data, 0, errorMessage);
1924     }
1925 
1926     /**
1927      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1928      * but also transferring `value` wei to `target`.
1929      *
1930      * Requirements:
1931      *
1932      * - the calling contract must have an ETH balance of at least `value`.
1933      * - the called Solidity function must be `payable`.
1934      *
1935      * _Available since v3.1._
1936      */
1937     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1938         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1939     }
1940 
1941     /**
1942      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1943      * with `errorMessage` as a fallback revert reason when `target` reverts.
1944      *
1945      * _Available since v3.1._
1946      */
1947     function functionCallWithValue(
1948         address target,
1949         bytes memory data,
1950         uint256 value,
1951         string memory errorMessage
1952     ) internal returns (bytes memory) {
1953         require(address(this).balance >= value, "Address: insufficient balance for call");
1954         (bool success, bytes memory returndata) = target.call{value: value}(data);
1955         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1956     }
1957 
1958     /**
1959      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1960      * but performing a static call.
1961      *
1962      * _Available since v3.3._
1963      */
1964     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1965         return functionStaticCall(target, data, "Address: low-level static call failed");
1966     }
1967 
1968     /**
1969      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1970      * but performing a static call.
1971      *
1972      * _Available since v3.3._
1973      */
1974     function functionStaticCall(
1975         address target,
1976         bytes memory data,
1977         string memory errorMessage
1978     ) internal view returns (bytes memory) {
1979         (bool success, bytes memory returndata) = target.staticcall(data);
1980         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1981     }
1982 
1983     /**
1984      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1985      * but performing a delegate call.
1986      *
1987      * _Available since v3.4._
1988      */
1989     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1990         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1991     }
1992 
1993     /**
1994      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1995      * but performing a delegate call.
1996      *
1997      * _Available since v3.4._
1998      */
1999     function functionDelegateCall(
2000         address target,
2001         bytes memory data,
2002         string memory errorMessage
2003     ) internal returns (bytes memory) {
2004         (bool success, bytes memory returndata) = target.delegatecall(data);
2005         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2006     }
2007 
2008     /**
2009      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2010      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2011      *
2012      * _Available since v4.8._
2013      */
2014     function verifyCallResultFromTarget(
2015         address target,
2016         bool success,
2017         bytes memory returndata,
2018         string memory errorMessage
2019     ) internal view returns (bytes memory) {
2020         if (success) {
2021             if (returndata.length == 0) {
2022                 // only check isContract if the call was successful and the return data is empty
2023                 // otherwise we already know that it was a contract
2024                 require(isContract(target), "Address: call to non-contract");
2025             }
2026             return returndata;
2027         } else {
2028             _revert(returndata, errorMessage);
2029         }
2030     }
2031 
2032     /**
2033      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2034      * revert reason or using the provided one.
2035      *
2036      * _Available since v4.3._
2037      */
2038     function verifyCallResult(
2039         bool success,
2040         bytes memory returndata,
2041         string memory errorMessage
2042     ) internal pure returns (bytes memory) {
2043         if (success) {
2044             return returndata;
2045         } else {
2046             _revert(returndata, errorMessage);
2047         }
2048     }
2049 
2050     function _revert(bytes memory returndata, string memory errorMessage) private pure {
2051         // Look for revert reason and bubble it up if present
2052         if (returndata.length > 0) {
2053             // The easiest way to bubble the revert reason is using memory via assembly
2054             /// @solidity memory-safe-assembly
2055             assembly {
2056                 let returndata_size := mload(returndata)
2057                 revert(add(32, returndata), returndata_size)
2058             }
2059         } else {
2060             revert(errorMessage);
2061         }
2062     }
2063 }
2064 
2065 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol
2066 
2067 
2068 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)
2069 
2070 pragma solidity ^0.8.0;
2071 
2072 /**
2073  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
2074  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
2075  *
2076  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
2077  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
2078  * need to send a transaction, and thus is not required to hold Ether at all.
2079  */
2080 interface IERC20Permit {
2081     /**
2082      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
2083      * given ``owner``'s signed approval.
2084      *
2085      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
2086      * ordering also apply here.
2087      *
2088      * Emits an {Approval} event.
2089      *
2090      * Requirements:
2091      *
2092      * - `spender` cannot be the zero address.
2093      * - `deadline` must be a timestamp in the future.
2094      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
2095      * over the EIP712-formatted function arguments.
2096      * - the signature must use ``owner``'s current nonce (see {nonces}).
2097      *
2098      * For more information on the signature format, see the
2099      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
2100      * section].
2101      */
2102     function permit(
2103         address owner,
2104         address spender,
2105         uint256 value,
2106         uint256 deadline,
2107         uint8 v,
2108         bytes32 r,
2109         bytes32 s
2110     ) external;
2111 
2112     /**
2113      * @dev Returns the current nonce for `owner`. This value must be
2114      * included whenever a signature is generated for {permit}.
2115      *
2116      * Every successful call to {permit} increases ``owner``'s nonce by one. This
2117      * prevents a signature from being used multiple times.
2118      */
2119     function nonces(address owner) external view returns (uint256);
2120 
2121     /**
2122      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
2123      */
2124     // solhint-disable-next-line func-name-mixedcase
2125     function DOMAIN_SEPARATOR() external view returns (bytes32);
2126 }
2127 
2128 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2129 
2130 
2131 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
2132 
2133 pragma solidity ^0.8.0;
2134 
2135 /**
2136  * @dev Interface of the ERC20 standard as defined in the EIP.
2137  */
2138 interface IERC20 {
2139     /**
2140      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2141      * another (`to`).
2142      *
2143      * Note that `value` may be zero.
2144      */
2145     event Transfer(address indexed from, address indexed to, uint256 value);
2146 
2147     /**
2148      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2149      * a call to {approve}. `value` is the new allowance.
2150      */
2151     event Approval(address indexed owner, address indexed spender, uint256 value);
2152 
2153     /**
2154      * @dev Returns the amount of tokens in existence.
2155      */
2156     function totalSupply() external view returns (uint256);
2157 
2158     /**
2159      * @dev Returns the amount of tokens owned by `account`.
2160      */
2161     function balanceOf(address account) external view returns (uint256);
2162 
2163     /**
2164      * @dev Moves `amount` tokens from the caller's account to `to`.
2165      *
2166      * Returns a boolean value indicating whether the operation succeeded.
2167      *
2168      * Emits a {Transfer} event.
2169      */
2170     function transfer(address to, uint256 amount) external returns (bool);
2171 
2172     /**
2173      * @dev Returns the remaining number of tokens that `spender` will be
2174      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2175      * zero by default.
2176      *
2177      * This value changes when {approve} or {transferFrom} are called.
2178      */
2179     function allowance(address owner, address spender) external view returns (uint256);
2180 
2181     /**
2182      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2183      *
2184      * Returns a boolean value indicating whether the operation succeeded.
2185      *
2186      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2187      * that someone may use both the old and the new allowance by unfortunate
2188      * transaction ordering. One possible solution to mitigate this race
2189      * condition is to first reduce the spender's allowance to 0 and set the
2190      * desired value afterwards:
2191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2192      *
2193      * Emits an {Approval} event.
2194      */
2195     function approve(address spender, uint256 amount) external returns (bool);
2196 
2197     /**
2198      * @dev Moves `amount` tokens from `from` to `to` using the
2199      * allowance mechanism. `amount` is then deducted from the caller's
2200      * allowance.
2201      *
2202      * Returns a boolean value indicating whether the operation succeeded.
2203      *
2204      * Emits a {Transfer} event.
2205      */
2206     function transferFrom(address from, address to, uint256 amount) external returns (bool);
2207 }
2208 
2209 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
2210 
2211 
2212 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/utils/SafeERC20.sol)
2213 
2214 pragma solidity ^0.8.0;
2215 
2216 
2217 
2218 
2219 /**
2220  * @title SafeERC20
2221  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2222  * contract returns false). Tokens that return no value (and instead revert or
2223  * throw on failure) are also supported, non-reverting calls are assumed to be
2224  * successful.
2225  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2226  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2227  */
2228 library SafeERC20 {
2229     using Address for address;
2230 
2231     /**
2232      * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
2233      * non-reverting calls are assumed to be successful.
2234      */
2235     function safeTransfer(IERC20 token, address to, uint256 value) internal {
2236         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2237     }
2238 
2239     /**
2240      * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
2241      * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
2242      */
2243     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
2244         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2245     }
2246 
2247     /**
2248      * @dev Deprecated. This function has issues similar to the ones found in
2249      * {IERC20-approve}, and its usage is discouraged.
2250      *
2251      * Whenever possible, use {safeIncreaseAllowance} and
2252      * {safeDecreaseAllowance} instead.
2253      */
2254     function safeApprove(IERC20 token, address spender, uint256 value) internal {
2255         // safeApprove should only be called when setting an initial allowance,
2256         // or when resetting it to zero. To increase and decrease it, use
2257         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2258         require(
2259             (value == 0) || (token.allowance(address(this), spender) == 0),
2260             "SafeERC20: approve from non-zero to non-zero allowance"
2261         );
2262         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2263     }
2264 
2265     /**
2266      * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
2267      * non-reverting calls are assumed to be successful.
2268      */
2269     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2270         uint256 oldAllowance = token.allowance(address(this), spender);
2271         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
2272     }
2273 
2274     /**
2275      * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
2276      * non-reverting calls are assumed to be successful.
2277      */
2278     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2279         unchecked {
2280             uint256 oldAllowance = token.allowance(address(this), spender);
2281             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2282             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
2283         }
2284     }
2285 
2286     /**
2287      * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
2288      * non-reverting calls are assumed to be successful. Compatible with tokens that require the approval to be set to
2289      * 0 before setting it to a non-zero value.
2290      */
2291     function forceApprove(IERC20 token, address spender, uint256 value) internal {
2292         bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);
2293 
2294         if (!_callOptionalReturnBool(token, approvalCall)) {
2295             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
2296             _callOptionalReturn(token, approvalCall);
2297         }
2298     }
2299 
2300     /**
2301      * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
2302      * Revert on invalid signature.
2303      */
2304     function safePermit(
2305         IERC20Permit token,
2306         address owner,
2307         address spender,
2308         uint256 value,
2309         uint256 deadline,
2310         uint8 v,
2311         bytes32 r,
2312         bytes32 s
2313     ) internal {
2314         uint256 nonceBefore = token.nonces(owner);
2315         token.permit(owner, spender, value, deadline, v, r, s);
2316         uint256 nonceAfter = token.nonces(owner);
2317         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
2318     }
2319 
2320     /**
2321      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2322      * on the return value: the return value is optional (but if data is returned, it must not be false).
2323      * @param token The token targeted by the call.
2324      * @param data The call data (encoded using abi.encode or one of its variants).
2325      */
2326     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2327         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2328         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
2329         // the target address contains contract code and also asserts for success in the low-level call.
2330 
2331         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2332         require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2333     }
2334 
2335     /**
2336      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2337      * on the return value: the return value is optional (but if data is returned, it must not be false).
2338      * @param token The token targeted by the call.
2339      * @param data The call data (encoded using abi.encode or one of its variants).
2340      *
2341      * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
2342      */
2343     function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
2344         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2345         // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
2346         // and not revert is the subcall reverts.
2347 
2348         (bool success, bytes memory returndata) = address(token).call(data);
2349         return
2350             success && (returndata.length == 0 || abi.decode(returndata, (bool))) && Address.isContract(address(token));
2351     }
2352 }
2353 
2354 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2355 
2356 
2357 // OpenZeppelin Contracts (last updated v4.9.2) (utils/cryptography/MerkleProof.sol)
2358 
2359 pragma solidity ^0.8.0;
2360 
2361 /**
2362  * @dev These functions deal with verification of Merkle Tree proofs.
2363  *
2364  * The tree and the proofs can be generated using our
2365  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
2366  * You will find a quickstart guide in the readme.
2367  *
2368  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
2369  * hashing, or use a hash function other than keccak256 for hashing leaves.
2370  * This is because the concatenation of a sorted pair of internal nodes in
2371  * the merkle tree could be reinterpreted as a leaf value.
2372  * OpenZeppelin's JavaScript library generates merkle trees that are safe
2373  * against this attack out of the box.
2374  */
2375 library MerkleProof {
2376     /**
2377      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2378      * defined by `root`. For this, a `proof` must be provided, containing
2379      * sibling hashes on the branch from the leaf to the root of the tree. Each
2380      * pair of leaves and each pair of pre-images are assumed to be sorted.
2381      */
2382     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
2383         return processProof(proof, leaf) == root;
2384     }
2385 
2386     /**
2387      * @dev Calldata version of {verify}
2388      *
2389      * _Available since v4.7._
2390      */
2391     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
2392         return processProofCalldata(proof, leaf) == root;
2393     }
2394 
2395     /**
2396      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
2397      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2398      * hash matches the root of the tree. When processing the proof, the pairs
2399      * of leafs & pre-images are assumed to be sorted.
2400      *
2401      * _Available since v4.4._
2402      */
2403     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2404         bytes32 computedHash = leaf;
2405         for (uint256 i = 0; i < proof.length; i++) {
2406             computedHash = _hashPair(computedHash, proof[i]);
2407         }
2408         return computedHash;
2409     }
2410 
2411     /**
2412      * @dev Calldata version of {processProof}
2413      *
2414      * _Available since v4.7._
2415      */
2416     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
2417         bytes32 computedHash = leaf;
2418         for (uint256 i = 0; i < proof.length; i++) {
2419             computedHash = _hashPair(computedHash, proof[i]);
2420         }
2421         return computedHash;
2422     }
2423 
2424     /**
2425      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
2426      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2427      *
2428      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2429      *
2430      * _Available since v4.7._
2431      */
2432     function multiProofVerify(
2433         bytes32[] memory proof,
2434         bool[] memory proofFlags,
2435         bytes32 root,
2436         bytes32[] memory leaves
2437     ) internal pure returns (bool) {
2438         return processMultiProof(proof, proofFlags, leaves) == root;
2439     }
2440 
2441     /**
2442      * @dev Calldata version of {multiProofVerify}
2443      *
2444      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2445      *
2446      * _Available since v4.7._
2447      */
2448     function multiProofVerifyCalldata(
2449         bytes32[] calldata proof,
2450         bool[] calldata proofFlags,
2451         bytes32 root,
2452         bytes32[] memory leaves
2453     ) internal pure returns (bool) {
2454         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2455     }
2456 
2457     /**
2458      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2459      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2460      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2461      * respectively.
2462      *
2463      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2464      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2465      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2466      *
2467      * _Available since v4.7._
2468      */
2469     function processMultiProof(
2470         bytes32[] memory proof,
2471         bool[] memory proofFlags,
2472         bytes32[] memory leaves
2473     ) internal pure returns (bytes32 merkleRoot) {
2474         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
2475         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2476         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2477         // the merkle tree.
2478         uint256 leavesLen = leaves.length;
2479         uint256 proofLen = proof.length;
2480         uint256 totalHashes = proofFlags.length;
2481 
2482         // Check proof validity.
2483         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
2484 
2485         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2486         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2487         bytes32[] memory hashes = new bytes32[](totalHashes);
2488         uint256 leafPos = 0;
2489         uint256 hashPos = 0;
2490         uint256 proofPos = 0;
2491         // At each step, we compute the next hash using two values:
2492         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2493         //   get the next hash.
2494         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
2495         //   `proof` array.
2496         for (uint256 i = 0; i < totalHashes; i++) {
2497             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2498             bytes32 b = proofFlags[i]
2499                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
2500                 : proof[proofPos++];
2501             hashes[i] = _hashPair(a, b);
2502         }
2503 
2504         if (totalHashes > 0) {
2505             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
2506             unchecked {
2507                 return hashes[totalHashes - 1];
2508             }
2509         } else if (leavesLen > 0) {
2510             return leaves[0];
2511         } else {
2512             return proof[0];
2513         }
2514     }
2515 
2516     /**
2517      * @dev Calldata version of {processMultiProof}.
2518      *
2519      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2520      *
2521      * _Available since v4.7._
2522      */
2523     function processMultiProofCalldata(
2524         bytes32[] calldata proof,
2525         bool[] calldata proofFlags,
2526         bytes32[] memory leaves
2527     ) internal pure returns (bytes32 merkleRoot) {
2528         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
2529         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2530         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2531         // the merkle tree.
2532         uint256 leavesLen = leaves.length;
2533         uint256 proofLen = proof.length;
2534         uint256 totalHashes = proofFlags.length;
2535 
2536         // Check proof validity.
2537         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
2538 
2539         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2540         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2541         bytes32[] memory hashes = new bytes32[](totalHashes);
2542         uint256 leafPos = 0;
2543         uint256 hashPos = 0;
2544         uint256 proofPos = 0;
2545         // At each step, we compute the next hash using two values:
2546         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2547         //   get the next hash.
2548         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
2549         //   `proof` array.
2550         for (uint256 i = 0; i < totalHashes; i++) {
2551             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2552             bytes32 b = proofFlags[i]
2553                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
2554                 : proof[proofPos++];
2555             hashes[i] = _hashPair(a, b);
2556         }
2557 
2558         if (totalHashes > 0) {
2559             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
2560             unchecked {
2561                 return hashes[totalHashes - 1];
2562             }
2563         } else if (leavesLen > 0) {
2564             return leaves[0];
2565         } else {
2566             return proof[0];
2567         }
2568     }
2569 
2570     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2571         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2572     }
2573 
2574     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2575         /// @solidity memory-safe-assembly
2576         assembly {
2577             mstore(0x00, a)
2578             mstore(0x20, b)
2579             value := keccak256(0x00, 0x40)
2580         }
2581     }
2582 }
2583 
2584 // File: @openzeppelin/contracts/utils/Context.sol
2585 
2586 
2587 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2588 
2589 pragma solidity ^0.8.0;
2590 
2591 /**
2592  * @dev Provides information about the current execution context, including the
2593  * sender of the transaction and its data. While these are generally available
2594  * via msg.sender and msg.data, they should not be accessed in such a direct
2595  * manner, since when dealing with meta-transactions the account sending and
2596  * paying for execution may not be the actual sender (as far as an application
2597  * is concerned).
2598  *
2599  * This contract is only required for intermediate, library-like contracts.
2600  */
2601 abstract contract Context {
2602     function _msgSender() internal view virtual returns (address) {
2603         return msg.sender;
2604     }
2605 
2606     function _msgData() internal view virtual returns (bytes calldata) {
2607         return msg.data;
2608     }
2609 }
2610 
2611 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
2612 
2613 
2614 // OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)
2615 
2616 pragma solidity ^0.8.0;
2617 
2618 
2619 
2620 
2621 /**
2622  * @title PaymentSplitter
2623  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2624  * that the Ether will be split in this way, since it is handled transparently by the contract.
2625  *
2626  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2627  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2628  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
2629  * time of contract deployment and can't be updated thereafter.
2630  *
2631  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2632  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2633  * function.
2634  *
2635  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2636  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2637  * to run tests before sending real value to this contract.
2638  */
2639 contract PaymentSplitter is Context {
2640     event PayeeAdded(address account, uint256 shares);
2641     event PaymentReleased(address to, uint256 amount);
2642     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
2643     event PaymentReceived(address from, uint256 amount);
2644 
2645     uint256 private _totalShares;
2646     uint256 private _totalReleased;
2647 
2648     mapping(address => uint256) private _shares;
2649     mapping(address => uint256) private _released;
2650     address[] private _payees;
2651 
2652     mapping(IERC20 => uint256) private _erc20TotalReleased;
2653     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2654 
2655     /**
2656      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2657      * the matching position in the `shares` array.
2658      *
2659      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2660      * duplicates in `payees`.
2661      */
2662     constructor(address[] memory payees, uint256[] memory shares_) payable {
2663         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2664         require(payees.length > 0, "PaymentSplitter: no payees");
2665 
2666         for (uint256 i = 0; i < payees.length; i++) {
2667             _addPayee(payees[i], shares_[i]);
2668         }
2669     }
2670 
2671     /**
2672      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2673      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2674      * reliability of the events, and not the actual splitting of Ether.
2675      *
2676      * To learn more about this see the Solidity documentation for
2677      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2678      * functions].
2679      */
2680     receive() external payable virtual {
2681         emit PaymentReceived(_msgSender(), msg.value);
2682     }
2683 
2684     /**
2685      * @dev Getter for the total shares held by payees.
2686      */
2687     function totalShares() public view returns (uint256) {
2688         return _totalShares;
2689     }
2690 
2691     /**
2692      * @dev Getter for the total amount of Ether already released.
2693      */
2694     function totalReleased() public view returns (uint256) {
2695         return _totalReleased;
2696     }
2697 
2698     /**
2699      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2700      * contract.
2701      */
2702     function totalReleased(IERC20 token) public view returns (uint256) {
2703         return _erc20TotalReleased[token];
2704     }
2705 
2706     /**
2707      * @dev Getter for the amount of shares held by an account.
2708      */
2709     function shares(address account) public view returns (uint256) {
2710         return _shares[account];
2711     }
2712 
2713     /**
2714      * @dev Getter for the amount of Ether already released to a payee.
2715      */
2716     function released(address account) public view returns (uint256) {
2717         return _released[account];
2718     }
2719 
2720     /**
2721      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2722      * IERC20 contract.
2723      */
2724     function released(IERC20 token, address account) public view returns (uint256) {
2725         return _erc20Released[token][account];
2726     }
2727 
2728     /**
2729      * @dev Getter for the address of the payee number `index`.
2730      */
2731     function payee(uint256 index) public view returns (address) {
2732         return _payees[index];
2733     }
2734 
2735     /**
2736      * @dev Getter for the amount of payee's releasable Ether.
2737      */
2738     function releasable(address account) public view returns (uint256) {
2739         uint256 totalReceived = address(this).balance + totalReleased();
2740         return _pendingPayment(account, totalReceived, released(account));
2741     }
2742 
2743     /**
2744      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
2745      * IERC20 contract.
2746      */
2747     function releasable(IERC20 token, address account) public view returns (uint256) {
2748         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
2749         return _pendingPayment(account, totalReceived, released(token, account));
2750     }
2751 
2752     /**
2753      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2754      * total shares and their previous withdrawals.
2755      */
2756     function release(address payable account) public virtual {
2757         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2758 
2759         uint256 payment = releasable(account);
2760 
2761         require(payment != 0, "PaymentSplitter: account is not due payment");
2762 
2763         // _totalReleased is the sum of all values in _released.
2764         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
2765         _totalReleased += payment;
2766         unchecked {
2767             _released[account] += payment;
2768         }
2769 
2770         Address.sendValue(account, payment);
2771         emit PaymentReleased(account, payment);
2772     }
2773 
2774     /**
2775      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2776      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2777      * contract.
2778      */
2779     function release(IERC20 token, address account) public virtual {
2780         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2781 
2782         uint256 payment = releasable(token, account);
2783 
2784         require(payment != 0, "PaymentSplitter: account is not due payment");
2785 
2786         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
2787         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
2788         // cannot overflow.
2789         _erc20TotalReleased[token] += payment;
2790         unchecked {
2791             _erc20Released[token][account] += payment;
2792         }
2793 
2794         SafeERC20.safeTransfer(token, account, payment);
2795         emit ERC20PaymentReleased(token, account, payment);
2796     }
2797 
2798     /**
2799      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2800      * already released amounts.
2801      */
2802     function _pendingPayment(
2803         address account,
2804         uint256 totalReceived,
2805         uint256 alreadyReleased
2806     ) private view returns (uint256) {
2807         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2808     }
2809 
2810     /**
2811      * @dev Add a new payee to the contract.
2812      * @param account The address of the payee to add.
2813      * @param shares_ The number of shares owned by the payee.
2814      */
2815     function _addPayee(address account, uint256 shares_) private {
2816         require(account != address(0), "PaymentSplitter: account is the zero address");
2817         require(shares_ > 0, "PaymentSplitter: shares are 0");
2818         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2819 
2820         _payees.push(account);
2821         _shares[account] = shares_;
2822         _totalShares = _totalShares + shares_;
2823         emit PayeeAdded(account, shares_);
2824     }
2825 }
2826 
2827 // File: @openzeppelin/contracts/access/Ownable.sol
2828 
2829 
2830 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
2831 
2832 pragma solidity ^0.8.0;
2833 
2834 
2835 /**
2836  * @dev Contract module which provides a basic access control mechanism, where
2837  * there is an account (an owner) that can be granted exclusive access to
2838  * specific functions.
2839  *
2840  * By default, the owner account will be the one that deploys the contract. This
2841  * can later be changed with {transferOwnership}.
2842  *
2843  * This module is used through inheritance. It will make available the modifier
2844  * `onlyOwner`, which can be applied to your functions to restrict their use to
2845  * the owner.
2846  */
2847 abstract contract Ownable is Context {
2848     address private _owner;
2849 
2850     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2851 
2852     /**
2853      * @dev Initializes the contract setting the deployer as the initial owner.
2854      */
2855     constructor() {
2856         _transferOwnership(_msgSender());
2857     }
2858 
2859     /**
2860      * @dev Throws if called by any account other than the owner.
2861      */
2862     modifier onlyOwner() {
2863         _checkOwner();
2864         _;
2865     }
2866 
2867     /**
2868      * @dev Returns the address of the current owner.
2869      */
2870     function owner() public view virtual returns (address) {
2871         return _owner;
2872     }
2873 
2874     /**
2875      * @dev Throws if the sender is not the owner.
2876      */
2877     function _checkOwner() internal view virtual {
2878         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2879     }
2880 
2881     /**
2882      * @dev Leaves the contract without owner. It will not be possible to call
2883      * `onlyOwner` functions. Can only be called by the current owner.
2884      *
2885      * NOTE: Renouncing ownership will leave the contract without an owner,
2886      * thereby disabling any functionality that is only available to the owner.
2887      */
2888     function renounceOwnership() public virtual onlyOwner {
2889         _transferOwnership(address(0));
2890     }
2891 
2892     /**
2893      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2894      * Can only be called by the current owner.
2895      */
2896     function transferOwnership(address newOwner) public virtual onlyOwner {
2897         require(newOwner != address(0), "Ownable: new owner is the zero address");
2898         _transferOwnership(newOwner);
2899     }
2900 
2901     /**
2902      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2903      * Internal function without access restriction.
2904      */
2905     function _transferOwnership(address newOwner) internal virtual {
2906         address oldOwner = _owner;
2907         _owner = newOwner;
2908         emit OwnershipTransferred(oldOwner, newOwner);
2909     }
2910 }
2911 
2912 // File: contracts/ToonTabz.sol
2913 
2914 
2915 pragma solidity ^0.8.18;
2916 
2917 
2918 
2919 
2920 
2921 
2922 
2923 contract ToonTabz is Ownable, ERC721A, PaymentSplitter, DefaultOperatorFilterer {
2924 
2925     using Strings for uint;
2926 
2927     enum Step {
2928         Before,
2929         WhitelistSale,
2930         PublicSale,
2931         SoldOut
2932     }
2933 
2934     string public baseURI;
2935 
2936     Step public sellingStep;
2937 
2938     uint public  MAX_SUPPLY = 10000;
2939     uint public  MAX_TOTAL_PUBLIC = 10000;
2940     uint public  MAX_TOTAL_WL = 10000;
2941 
2942 
2943     uint public MAX_PER_WALLET_PUBLIC = 5;
2944     uint public MAX_PER_WALLET_WL = 3;
2945 
2946 
2947     uint public wlSalePrice = 0.0069 ether;
2948     uint public publicSalePrice = 0.0069 ether;
2949 
2950     bytes32 public merkleRootWL;
2951 
2952 
2953     mapping(address => uint) public amountNFTsperWalletPUBLIC;
2954     mapping(address => uint) public amountNFTsperWalletWL;
2955 
2956 
2957     uint private teamLength;
2958 
2959     uint96 royaltyFeesInBips;
2960     address royaltyReceiver;
2961 
2962     constructor(uint96 _royaltyFeesInBips, address[] memory _team, uint[] memory _teamShares, bytes32 _merkleRootWL, string memory _baseURI) ERC721A("ToonTabz", "TTBZ")
2963     PaymentSplitter(_team, _teamShares) {
2964         merkleRootWL = _merkleRootWL;
2965         baseURI = _baseURI;
2966         teamLength = _team.length;
2967         royaltyFeesInBips = _royaltyFeesInBips;
2968         royaltyReceiver = msg.sender;
2969     }
2970 
2971     modifier callerIsUser() {
2972         require(tx.origin == msg.sender, "The caller is another contract");
2973         _;
2974     }
2975 
2976    function whitelistMint(address _account, uint _quantity, bytes32[] calldata _proof) external payable callerIsUser {
2977         uint price = wlSalePrice;
2978         require(sellingStep == Step.WhitelistSale, "Whitelist sale is not activated");
2979         require(msg.sender == _account, "Mint with your own wallet.");
2980         require(isWhiteListed(msg.sender, _proof), "Not whitelisted");
2981         require(amountNFTsperWalletWL[msg.sender] + _quantity <= MAX_PER_WALLET_WL, "Max per wallet limit reached");
2982         require(totalSupply() + _quantity <= MAX_TOTAL_WL, "Max supply exceeded");
2983         require(totalSupply() + _quantity <= MAX_SUPPLY, "Max supply exceeded");
2984         require(msg.value >= price * _quantity, "Not enought funds");
2985         amountNFTsperWalletWL[msg.sender] += _quantity;
2986         _safeMint(_account, _quantity);
2987     }
2988 
2989 
2990     function publicSaleMint(address _account, uint _quantity) external payable callerIsUser {
2991         uint price = publicSalePrice;
2992         require(msg.sender == _account, "Mint with your own wallet.");
2993         require(sellingStep == Step.PublicSale, "Public sale is not activated");
2994         require(totalSupply() + _quantity <= MAX_TOTAL_PUBLIC, "Max supply exceeded");
2995         require(totalSupply() + _quantity <= MAX_SUPPLY, "Max supply exceeded");
2996         require(amountNFTsperWalletPUBLIC[msg.sender] + _quantity <= MAX_PER_WALLET_PUBLIC, "Max per wallet limit reached");
2997         require(msg.value >= price * _quantity, "Not enought funds");
2998         amountNFTsperWalletPUBLIC[msg.sender] += _quantity;
2999         _safeMint(_account, _quantity);
3000     }
3001 
3002     function gift(address _to, uint _quantity) external onlyOwner {
3003         require(totalSupply() + _quantity <= MAX_SUPPLY, "Reached max Supply");
3004         _safeMint(_to, _quantity);
3005     }
3006 
3007     function lowerSupply (uint _MAX_SUPPLY) external onlyOwner{
3008         require(_MAX_SUPPLY < MAX_SUPPLY, "Cannot increase supply!");
3009         MAX_SUPPLY = _MAX_SUPPLY;
3010     }
3011 
3012     function setMaxTotalPUBLIC(uint _MAX_TOTAL_PUBLIC) external onlyOwner {
3013         MAX_TOTAL_PUBLIC = _MAX_TOTAL_PUBLIC;
3014     }
3015 
3016     function setMaxTotalWL(uint _MAX_TOTAL_WL) external onlyOwner {
3017         MAX_TOTAL_WL = _MAX_TOTAL_WL;
3018     }
3019 
3020     function setMaxPerWalletWL(uint _MAX_PER_WALLET_WL) external onlyOwner {
3021         MAX_PER_WALLET_WL = _MAX_PER_WALLET_WL;
3022     }
3023 
3024     function setMaxPerWalletPUBLIC(uint _MAX_PER_WALLET_PUBLIC) external onlyOwner {
3025         MAX_PER_WALLET_PUBLIC = _MAX_PER_WALLET_PUBLIC;
3026     }
3027 
3028     function setWLSalePrice(uint _wlSalePrice) external onlyOwner {
3029         wlSalePrice = _wlSalePrice;
3030     }
3031 
3032     function setPublicSalePrice(uint _publicSalePrice) external onlyOwner {
3033         publicSalePrice = _publicSalePrice;
3034     }
3035 
3036     function setBaseUri(string memory _baseURI) external onlyOwner {
3037         baseURI = _baseURI;
3038     }
3039 
3040     function setStep(uint _step) external onlyOwner {
3041         sellingStep = Step(_step);
3042     }
3043 
3044     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
3045         require(_exists(_tokenId), "URI query for nonexistent token");
3046 
3047         return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
3048     }
3049 
3050     //Whitelist
3051     function setMerkleRootWL(bytes32 _merkleRootWL) external onlyOwner {
3052         merkleRootWL = _merkleRootWL;
3053     }
3054 
3055     function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
3056         return _verifyWL(leaf(_account), _proof);
3057     }
3058 
3059     function leaf(address _account) internal pure returns(bytes32) {
3060         return keccak256(abi.encodePacked(_account));
3061     }
3062 
3063     function _verifyWL(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
3064         return MerkleProof.verify(_proof, merkleRootWL, _leaf);
3065     }
3066 
3067     function royaltyInfo (
3068     uint256 _tokenId,
3069     uint256 _salePrice
3070      ) external view returns (
3071         address receiver,
3072         uint256 royaltyAmount
3073      ){
3074          return (royaltyReceiver, calculateRoyalty(_salePrice));
3075      }
3076 
3077     function calculateRoyalty(uint256 _salePrice) view public returns (uint256){
3078         return(_salePrice / 10000) * royaltyFeesInBips;
3079     }
3080 
3081     function setRoyaltyInfo (address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
3082         royaltyReceiver = _receiver;
3083         royaltyFeesInBips = _royaltyFeesInBips;
3084     }
3085 
3086     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3087         super.setApprovalForAll(operator, approved);
3088     }
3089 
3090     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
3091         super.approve(operator, tokenId);
3092     }
3093 
3094     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3095         super.transferFrom(from, to, tokenId);
3096     }
3097 
3098     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3099         super.safeTransferFrom(from, to, tokenId);
3100     }
3101     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3102         public
3103         override
3104         onlyAllowedOperator(from)
3105     {
3106         super.safeTransferFrom(from, to, tokenId, data);
3107     }
3108 
3109     //ReleaseALL
3110     function releaseAll() external onlyOwner {
3111         for(uint i = 0 ; i < teamLength ; i++) {
3112             release(payable(payee(i)));
3113         }
3114     }
3115 
3116     receive() override external payable {
3117         revert('Only if you mint');
3118     }
3119 
3120 }