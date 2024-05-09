1 // File: erc721a/contracts/IERC721A.sol
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
281 // File: erc721a/contracts/ERC721A.sol
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
314     // Mask of an entry in packed address data.
315     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
316 
317     // The bit position of `numberMinted` in packed address data.
318     uint256 private constant BITPOS_NUMBER_MINTED = 64;
319 
320     // The bit position of `numberBurned` in packed address data.
321     uint256 private constant BITPOS_NUMBER_BURNED = 128;
322 
323     // The bit position of `aux` in packed address data.
324     uint256 private constant BITPOS_AUX = 192;
325 
326     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
327     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
328 
329     // The bit position of `startTimestamp` in packed ownership.
330     uint256 private constant BITPOS_START_TIMESTAMP = 160;
331 
332     // The bit mask of the `burned` bit in packed ownership.
333     uint256 private constant BITMASK_BURNED = 1 << 224;
334 
335     // The bit position of the `nextInitialized` bit in packed ownership.
336     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
337 
338     // The bit mask of the `nextInitialized` bit in packed ownership.
339     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
340 
341     // The bit position of `extraData` in packed ownership.
342     uint256 private constant BITPOS_EXTRA_DATA = 232;
343 
344     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
345     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
346 
347     // The mask of the lower 160 bits for addresses.
348     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
349 
350     // The maximum `quantity` that can be minted with `_mintERC2309`.
351     // This limit is to prevent overflows on the address data entries.
352     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
353     // is required to cause an overflow, which is unrealistic.
354     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
355 
356     // The tokenId of the next token to be minted.
357     uint256 private _currentIndex;
358 
359     // The number of tokens burned.
360     uint256 private _burnCounter;
361 
362     // Token name
363     string private _name;
364 
365     // Token symbol
366     string private _symbol;
367 
368     // Mapping from token ID to ownership details
369     // An empty struct value does not necessarily mean the token is unowned.
370     // See `_packedOwnershipOf` implementation for details.
371     //
372     // Bits Layout:
373     // - [0..159]   `addr`
374     // - [160..223] `startTimestamp`
375     // - [224]      `burned`
376     // - [225]      `nextInitialized`
377     // - [232..255] `extraData`
378     mapping(uint256 => uint256) private _packedOwnerships;
379 
380     // Mapping owner address to address data.
381     //
382     // Bits Layout:
383     // - [0..63]    `balance`
384     // - [64..127]  `numberMinted`
385     // - [128..191] `numberBurned`
386     // - [192..255] `aux`
387     mapping(address => uint256) private _packedAddressData;
388 
389     // Mapping from token ID to approved address.
390     mapping(uint256 => address) private _tokenApprovals;
391 
392     // Mapping from owner to operator approvals
393     mapping(address => mapping(address => bool)) private _operatorApprovals;
394 
395     constructor(string memory name_, string memory symbol_) {
396         _name = name_;
397         _symbol = symbol_;
398         _currentIndex = _startTokenId();
399     }
400 
401     /**
402      * @dev Returns the starting token ID.
403      * To change the starting token ID, please override this function.
404      */
405     function _startTokenId() internal view virtual returns (uint256) {
406         return 0;
407     }
408 
409     /**
410      * @dev Returns the next token ID to be minted.
411      */
412     function _nextTokenId() internal view returns (uint256) {
413         return _currentIndex;
414     }
415 
416     /**
417      * @dev Returns the total number of tokens in existence.
418      * Burned tokens will reduce the count.
419      * To get the total number of tokens minted, please see `_totalMinted`.
420      */
421     function totalSupply() public view override returns (uint256) {
422         // Counter underflow is impossible as _burnCounter cannot be incremented
423         // more than `_currentIndex - _startTokenId()` times.
424         unchecked {
425             return _currentIndex - _burnCounter - _startTokenId();
426         }
427     }
428 
429     /**
430      * @dev Returns the total amount of tokens minted in the contract.
431      */
432     function _totalMinted() internal view returns (uint256) {
433         // Counter underflow is impossible as _currentIndex does not decrement,
434         // and it is initialized to `_startTokenId()`
435         unchecked {
436             return _currentIndex - _startTokenId();
437         }
438     }
439 
440     /**
441      * @dev Returns the total number of tokens burned.
442      */
443     function _totalBurned() internal view returns (uint256) {
444         return _burnCounter;
445     }
446 
447     /**
448      * @dev See {IERC165-supportsInterface}.
449      */
450     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
451         // The interface IDs are constants representing the first 4 bytes of the XOR of
452         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
453         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
454         return
455             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
456             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
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
633     function approve(address to, uint256 tokenId) public override {
634         address owner = ownerOf(tokenId);
635 
636         if (_msgSenderERC721A() != owner)
637             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
638                 revert ApprovalCallerNotOwnerNorApproved();
639             }
640 
641         _tokenApprovals[tokenId] = to;
642         emit Approval(owner, to, tokenId);
643     }
644 
645     /**
646      * @dev See {IERC721-getApproved}.
647      */
648     function getApproved(uint256 tokenId) public view override returns (address) {
649         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
650 
651         return _tokenApprovals[tokenId];
652     }
653 
654     /**
655      * @dev See {IERC721-setApprovalForAll}.
656      */
657     function setApprovalForAll(address operator, bool approved) public virtual override {
658         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
659 
660         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
661         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
662     }
663 
664     /**
665      * @dev See {IERC721-isApprovedForAll}.
666      */
667     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
668         return _operatorApprovals[owner][operator];
669     }
670 
671     /**
672      * @dev See {IERC721-safeTransferFrom}.
673      */
674     function safeTransferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) public virtual override {
679         safeTransferFrom(from, to, tokenId, '');
680     }
681 
682     /**
683      * @dev See {IERC721-safeTransferFrom}.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId,
689         bytes memory _data
690     ) public virtual override {
691         transferFrom(from, to, tokenId);
692         if (to.code.length != 0)
693             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
694                 revert TransferToNonERC721ReceiverImplementer();
695             }
696     }
697 
698     /**
699      * @dev Returns whether `tokenId` exists.
700      *
701      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
702      *
703      * Tokens start existing when they are minted (`_mint`),
704      */
705     function _exists(uint256 tokenId) internal view returns (bool) {
706         return
707             _startTokenId() <= tokenId &&
708             tokenId < _currentIndex && // If within bounds,
709             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
710     }
711 
712     /**
713      * @dev Equivalent to `_safeMint(to, quantity, '')`.
714      */
715     function _safeMint(address to, uint256 quantity) internal {
716         _safeMint(to, quantity, '');
717     }
718 
719     /**
720      * @dev Safely mints `quantity` tokens and transfers them to `to`.
721      *
722      * Requirements:
723      *
724      * - If `to` refers to a smart contract, it must implement
725      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
726      * - `quantity` must be greater than 0.
727      *
728      * See {_mint}.
729      *
730      * Emits a {Transfer} event for each mint.
731      */
732     function _safeMint(
733         address to,
734         uint256 quantity,
735         bytes memory _data
736     ) internal {
737         _mint(to, quantity);
738 
739         unchecked {
740             if (to.code.length != 0) {
741                 uint256 end = _currentIndex;
742                 uint256 index = end - quantity;
743                 do {
744                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
745                         revert TransferToNonERC721ReceiverImplementer();
746                     }
747                 } while (index < end);
748                 // Reentrancy protection.
749                 if (_currentIndex != end) revert();
750             }
751         }
752     }
753 
754     /**
755      * @dev Mints `quantity` tokens and transfers them to `to`.
756      *
757      * Requirements:
758      *
759      * - `to` cannot be the zero address.
760      * - `quantity` must be greater than 0.
761      *
762      * Emits a {Transfer} event for each mint.
763      */
764     function _mint(address to, uint256 quantity) internal {
765         uint256 startTokenId = _currentIndex;
766         if (to == address(0)) revert MintToZeroAddress();
767         if (quantity == 0) revert MintZeroQuantity();
768 
769         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
770 
771         // Overflows are incredibly unrealistic.
772         // `balance` and `numberMinted` have a maximum limit of 2**64.
773         // `tokenId` has a maximum limit of 2**256.
774         unchecked {
775             // Updates:
776             // - `balance += quantity`.
777             // - `numberMinted += quantity`.
778             //
779             // We can directly add to the `balance` and `numberMinted`.
780             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
781 
782             // Updates:
783             // - `address` to the owner.
784             // - `startTimestamp` to the timestamp of minting.
785             // - `burned` to `false`.
786             // - `nextInitialized` to `quantity == 1`.
787             _packedOwnerships[startTokenId] = _packOwnershipData(
788                 to,
789                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
790             );
791 
792             uint256 tokenId = startTokenId;
793             uint256 end = startTokenId + quantity;
794             do {
795                 emit Transfer(address(0), to, tokenId++);
796             } while (tokenId < end);
797 
798             _currentIndex = end;
799         }
800         _afterTokenTransfers(address(0), to, startTokenId, quantity);
801     }
802 
803     /**
804      * @dev Mints `quantity` tokens and transfers them to `to`.
805      *
806      * This function is intended for efficient minting only during contract creation.
807      *
808      * It emits only one {ConsecutiveTransfer} as defined in
809      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
810      * instead of a sequence of {Transfer} event(s).
811      *
812      * Calling this function outside of contract creation WILL make your contract
813      * non-compliant with the ERC721 standard.
814      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
815      * {ConsecutiveTransfer} event is only permissible during contract creation.
816      *
817      * Requirements:
818      *
819      * - `to` cannot be the zero address.
820      * - `quantity` must be greater than 0.
821      *
822      * Emits a {ConsecutiveTransfer} event.
823      */
824     function _mintERC2309(address to, uint256 quantity) internal {
825         uint256 startTokenId = _currentIndex;
826         if (to == address(0)) revert MintToZeroAddress();
827         if (quantity == 0) revert MintZeroQuantity();
828         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
829 
830         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
831 
832         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
833         unchecked {
834             // Updates:
835             // - `balance += quantity`.
836             // - `numberMinted += quantity`.
837             //
838             // We can directly add to the `balance` and `numberMinted`.
839             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
840 
841             // Updates:
842             // - `address` to the owner.
843             // - `startTimestamp` to the timestamp of minting.
844             // - `burned` to `false`.
845             // - `nextInitialized` to `quantity == 1`.
846             _packedOwnerships[startTokenId] = _packOwnershipData(
847                 to,
848                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
849             );
850 
851             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
852 
853             _currentIndex = startTokenId + quantity;
854         }
855         _afterTokenTransfers(address(0), to, startTokenId, quantity);
856     }
857 
858     /**
859      * @dev Returns the storage slot and value for the approved address of `tokenId`.
860      */
861     function _getApprovedAddress(uint256 tokenId)
862         private
863         view
864         returns (uint256 approvedAddressSlot, address approvedAddress)
865     {
866         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
867         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
868         assembly {
869             // Compute the slot.
870             mstore(0x00, tokenId)
871             mstore(0x20, tokenApprovalsPtr.slot)
872             approvedAddressSlot := keccak256(0x00, 0x40)
873             // Load the slot's value from storage.
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
1087     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
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
1190     function _toString(uint256 value) internal pure returns (string memory ptr) {
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
1232 
1233 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1234 
1235 
1236 // ERC721A Contracts v4.1.0
1237 // Creator: Chiru Labs
1238 
1239 pragma solidity ^0.8.4;
1240 
1241 
1242 /**
1243  * @dev Interface of an ERC721AQueryable compliant contract.
1244  */
1245 interface IERC721AQueryable is IERC721A {
1246     /**
1247      * Invalid query range (`start` >= `stop`).
1248      */
1249     error InvalidQueryRange();
1250 
1251     /**
1252      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1253      *
1254      * If the `tokenId` is out of bounds:
1255      *   - `addr` = `address(0)`
1256      *   - `startTimestamp` = `0`
1257      *   - `burned` = `false`
1258      *
1259      * If the `tokenId` is burned:
1260      *   - `addr` = `<Address of owner before token was burned>`
1261      *   - `startTimestamp` = `<Timestamp when token was burned>`
1262      *   - `burned = `true`
1263      *
1264      * Otherwise:
1265      *   - `addr` = `<Address of owner>`
1266      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1267      *   - `burned = `false`
1268      */
1269     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1270 
1271     /**
1272      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1273      * See {ERC721AQueryable-explicitOwnershipOf}
1274      */
1275     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1276 
1277     /**
1278      * @dev Returns an array of token IDs owned by `owner`,
1279      * in the range [`start`, `stop`)
1280      * (i.e. `start <= tokenId < stop`).
1281      *
1282      * This function allows for tokens to be queried if the collection
1283      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1284      *
1285      * Requirements:
1286      *
1287      * - `start` < `stop`
1288      */
1289     function tokensOfOwnerIn(
1290         address owner,
1291         uint256 start,
1292         uint256 stop
1293     ) external view returns (uint256[] memory);
1294 
1295     /**
1296      * @dev Returns an array of token IDs owned by `owner`.
1297      *
1298      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1299      * It is meant to be called off-chain.
1300      *
1301      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1302      * multiple smaller scans if the collection is large enough to cause
1303      * an out-of-gas error (10K pfp collections should be fine).
1304      */
1305     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1306 }
1307 
1308 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1309 
1310 
1311 // ERC721A Contracts v4.1.0
1312 // Creator: Chiru Labs
1313 
1314 pragma solidity ^0.8.4;
1315 
1316 
1317 
1318 /**
1319  * @title ERC721A Queryable
1320  * @dev ERC721A subclass with convenience query functions.
1321  */
1322 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1323     /**
1324      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1325      *
1326      * If the `tokenId` is out of bounds:
1327      *   - `addr` = `address(0)`
1328      *   - `startTimestamp` = `0`
1329      *   - `burned` = `false`
1330      *   - `extraData` = `0`
1331      *
1332      * If the `tokenId` is burned:
1333      *   - `addr` = `<Address of owner before token was burned>`
1334      *   - `startTimestamp` = `<Timestamp when token was burned>`
1335      *   - `burned = `true`
1336      *   - `extraData` = `<Extra data when token was burned>`
1337      *
1338      * Otherwise:
1339      *   - `addr` = `<Address of owner>`
1340      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1341      *   - `burned = `false`
1342      *   - `extraData` = `<Extra data at start of ownership>`
1343      */
1344     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1345         TokenOwnership memory ownership;
1346         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1347             return ownership;
1348         }
1349         ownership = _ownershipAt(tokenId);
1350         if (ownership.burned) {
1351             return ownership;
1352         }
1353         return _ownershipOf(tokenId);
1354     }
1355 
1356     /**
1357      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1358      * See {ERC721AQueryable-explicitOwnershipOf}
1359      */
1360     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1361         unchecked {
1362             uint256 tokenIdsLength = tokenIds.length;
1363             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1364             for (uint256 i; i != tokenIdsLength; ++i) {
1365                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1366             }
1367             return ownerships;
1368         }
1369     }
1370 
1371     /**
1372      * @dev Returns an array of token IDs owned by `owner`,
1373      * in the range [`start`, `stop`)
1374      * (i.e. `start <= tokenId < stop`).
1375      *
1376      * This function allows for tokens to be queried if the collection
1377      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1378      *
1379      * Requirements:
1380      *
1381      * - `start` < `stop`
1382      */
1383     function tokensOfOwnerIn(
1384         address owner,
1385         uint256 start,
1386         uint256 stop
1387     ) external view override returns (uint256[] memory) {
1388         unchecked {
1389             if (start >= stop) revert InvalidQueryRange();
1390             uint256 tokenIdsIdx;
1391             uint256 stopLimit = _nextTokenId();
1392             // Set `start = max(start, _startTokenId())`.
1393             if (start < _startTokenId()) {
1394                 start = _startTokenId();
1395             }
1396             // Set `stop = min(stop, stopLimit)`.
1397             if (stop > stopLimit) {
1398                 stop = stopLimit;
1399             }
1400             uint256 tokenIdsMaxLength = balanceOf(owner);
1401             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1402             // to cater for cases where `balanceOf(owner)` is too big.
1403             if (start < stop) {
1404                 uint256 rangeLength = stop - start;
1405                 if (rangeLength < tokenIdsMaxLength) {
1406                     tokenIdsMaxLength = rangeLength;
1407                 }
1408             } else {
1409                 tokenIdsMaxLength = 0;
1410             }
1411             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1412             if (tokenIdsMaxLength == 0) {
1413                 return tokenIds;
1414             }
1415             // We need to call `explicitOwnershipOf(start)`,
1416             // because the slot at `start` may not be initialized.
1417             TokenOwnership memory ownership = explicitOwnershipOf(start);
1418             address currOwnershipAddr;
1419             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1420             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1421             if (!ownership.burned) {
1422                 currOwnershipAddr = ownership.addr;
1423             }
1424             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1425                 ownership = _ownershipAt(i);
1426                 if (ownership.burned) {
1427                     continue;
1428                 }
1429                 if (ownership.addr != address(0)) {
1430                     currOwnershipAddr = ownership.addr;
1431                 }
1432                 if (currOwnershipAddr == owner) {
1433                     tokenIds[tokenIdsIdx++] = i;
1434                 }
1435             }
1436             // Downsize the array to fit.
1437             assembly {
1438                 mstore(tokenIds, tokenIdsIdx)
1439             }
1440             return tokenIds;
1441         }
1442     }
1443 
1444     /**
1445      * @dev Returns an array of token IDs owned by `owner`.
1446      *
1447      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1448      * It is meant to be called off-chain.
1449      *
1450      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1451      * multiple smaller scans if the collection is large enough to cause
1452      * an out-of-gas error (10K pfp collections should be fine).
1453      */
1454     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1455         unchecked {
1456             uint256 tokenIdsIdx;
1457             address currOwnershipAddr;
1458             uint256 tokenIdsLength = balanceOf(owner);
1459             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1460             TokenOwnership memory ownership;
1461             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1462                 ownership = _ownershipAt(i);
1463                 if (ownership.burned) {
1464                     continue;
1465                 }
1466                 if (ownership.addr != address(0)) {
1467                     currOwnershipAddr = ownership.addr;
1468                 }
1469                 if (currOwnershipAddr == owner) {
1470                     tokenIds[tokenIdsIdx++] = i;
1471                 }
1472             }
1473             return tokenIds;
1474         }
1475     }
1476 }
1477 
1478 // File: @openzeppelin/contracts/utils/Strings.sol
1479 
1480 
1481 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1482 
1483 pragma solidity ^0.8.0;
1484 
1485 /**
1486  * @dev String operations.
1487  */
1488 library Strings {
1489     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1490     uint8 private constant _ADDRESS_LENGTH = 20;
1491 
1492     /**
1493      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1494      */
1495     function toString(uint256 value) internal pure returns (string memory) {
1496         // Inspired by OraclizeAPI's implementation - MIT licence
1497         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1498 
1499         if (value == 0) {
1500             return "0";
1501         }
1502         uint256 temp = value;
1503         uint256 digits;
1504         while (temp != 0) {
1505             digits++;
1506             temp /= 10;
1507         }
1508         bytes memory buffer = new bytes(digits);
1509         while (value != 0) {
1510             digits -= 1;
1511             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1512             value /= 10;
1513         }
1514         return string(buffer);
1515     }
1516 
1517     /**
1518      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1519      */
1520     function toHexString(uint256 value) internal pure returns (string memory) {
1521         if (value == 0) {
1522             return "0x00";
1523         }
1524         uint256 temp = value;
1525         uint256 length = 0;
1526         while (temp != 0) {
1527             length++;
1528             temp >>= 8;
1529         }
1530         return toHexString(value, length);
1531     }
1532 
1533     /**
1534      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1535      */
1536     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1537         bytes memory buffer = new bytes(2 * length + 2);
1538         buffer[0] = "0";
1539         buffer[1] = "x";
1540         for (uint256 i = 2 * length + 1; i > 1; --i) {
1541             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1542             value >>= 4;
1543         }
1544         require(value == 0, "Strings: hex length insufficient");
1545         return string(buffer);
1546     }
1547 
1548     /**
1549      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1550      */
1551     function toHexString(address addr) internal pure returns (string memory) {
1552         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1553     }
1554 }
1555 
1556 // File: @openzeppelin/contracts/utils/Address.sol
1557 
1558 
1559 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1560 
1561 pragma solidity ^0.8.1;
1562 
1563 /**
1564  * @dev Collection of functions related to the address type
1565  */
1566 library Address {
1567     /**
1568      * @dev Returns true if `account` is a contract.
1569      *
1570      * [IMPORTANT]
1571      * ====
1572      * It is unsafe to assume that an address for which this function returns
1573      * false is an externally-owned account (EOA) and not a contract.
1574      *
1575      * Among others, `isContract` will return false for the following
1576      * types of addresses:
1577      *
1578      *  - an externally-owned account
1579      *  - a contract in construction
1580      *  - an address where a contract will be created
1581      *  - an address where a contract lived, but was destroyed
1582      * ====
1583      *
1584      * [IMPORTANT]
1585      * ====
1586      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1587      *
1588      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1589      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1590      * constructor.
1591      * ====
1592      */
1593     function isContract(address account) internal view returns (bool) {
1594         // This method relies on extcodesize/address.code.length, which returns 0
1595         // for contracts in construction, since the code is only stored at the end
1596         // of the constructor execution.
1597 
1598         return account.code.length > 0;
1599     }
1600 
1601     /**
1602      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1603      * `recipient`, forwarding all available gas and reverting on errors.
1604      *
1605      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1606      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1607      * imposed by `transfer`, making them unable to receive funds via
1608      * `transfer`. {sendValue} removes this limitation.
1609      *
1610      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1611      *
1612      * IMPORTANT: because control is transferred to `recipient`, care must be
1613      * taken to not create reentrancy vulnerabilities. Consider using
1614      * {ReentrancyGuard} or the
1615      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1616      */
1617     function sendValue(address payable recipient, uint256 amount) internal {
1618         require(address(this).balance >= amount, "Address: insufficient balance");
1619 
1620         (bool success, ) = recipient.call{value: amount}("");
1621         require(success, "Address: unable to send value, recipient may have reverted");
1622     }
1623 
1624     /**
1625      * @dev Performs a Solidity function call using a low level `call`. A
1626      * plain `call` is an unsafe replacement for a function call: use this
1627      * function instead.
1628      *
1629      * If `target` reverts with a revert reason, it is bubbled up by this
1630      * function (like regular Solidity function calls).
1631      *
1632      * Returns the raw returned data. To convert to the expected return value,
1633      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1634      *
1635      * Requirements:
1636      *
1637      * - `target` must be a contract.
1638      * - calling `target` with `data` must not revert.
1639      *
1640      * _Available since v3.1._
1641      */
1642     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1643         return functionCall(target, data, "Address: low-level call failed");
1644     }
1645 
1646     /**
1647      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1648      * `errorMessage` as a fallback revert reason when `target` reverts.
1649      *
1650      * _Available since v3.1._
1651      */
1652     function functionCall(
1653         address target,
1654         bytes memory data,
1655         string memory errorMessage
1656     ) internal returns (bytes memory) {
1657         return functionCallWithValue(target, data, 0, errorMessage);
1658     }
1659 
1660     /**
1661      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1662      * but also transferring `value` wei to `target`.
1663      *
1664      * Requirements:
1665      *
1666      * - the calling contract must have an ETH balance of at least `value`.
1667      * - the called Solidity function must be `payable`.
1668      *
1669      * _Available since v3.1._
1670      */
1671     function functionCallWithValue(
1672         address target,
1673         bytes memory data,
1674         uint256 value
1675     ) internal returns (bytes memory) {
1676         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1677     }
1678 
1679     /**
1680      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1681      * with `errorMessage` as a fallback revert reason when `target` reverts.
1682      *
1683      * _Available since v3.1._
1684      */
1685     function functionCallWithValue(
1686         address target,
1687         bytes memory data,
1688         uint256 value,
1689         string memory errorMessage
1690     ) internal returns (bytes memory) {
1691         require(address(this).balance >= value, "Address: insufficient balance for call");
1692         require(isContract(target), "Address: call to non-contract");
1693 
1694         (bool success, bytes memory returndata) = target.call{value: value}(data);
1695         return verifyCallResult(success, returndata, errorMessage);
1696     }
1697 
1698     /**
1699      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1700      * but performing a static call.
1701      *
1702      * _Available since v3.3._
1703      */
1704     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1705         return functionStaticCall(target, data, "Address: low-level static call failed");
1706     }
1707 
1708     /**
1709      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1710      * but performing a static call.
1711      *
1712      * _Available since v3.3._
1713      */
1714     function functionStaticCall(
1715         address target,
1716         bytes memory data,
1717         string memory errorMessage
1718     ) internal view returns (bytes memory) {
1719         require(isContract(target), "Address: static call to non-contract");
1720 
1721         (bool success, bytes memory returndata) = target.staticcall(data);
1722         return verifyCallResult(success, returndata, errorMessage);
1723     }
1724 
1725     /**
1726      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1727      * but performing a delegate call.
1728      *
1729      * _Available since v3.4._
1730      */
1731     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1732         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1733     }
1734 
1735     /**
1736      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1737      * but performing a delegate call.
1738      *
1739      * _Available since v3.4._
1740      */
1741     function functionDelegateCall(
1742         address target,
1743         bytes memory data,
1744         string memory errorMessage
1745     ) internal returns (bytes memory) {
1746         require(isContract(target), "Address: delegate call to non-contract");
1747 
1748         (bool success, bytes memory returndata) = target.delegatecall(data);
1749         return verifyCallResult(success, returndata, errorMessage);
1750     }
1751 
1752     /**
1753      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1754      * revert reason using the provided one.
1755      *
1756      * _Available since v4.3._
1757      */
1758     function verifyCallResult(
1759         bool success,
1760         bytes memory returndata,
1761         string memory errorMessage
1762     ) internal pure returns (bytes memory) {
1763         if (success) {
1764             return returndata;
1765         } else {
1766             // Look for revert reason and bubble it up if present
1767             if (returndata.length > 0) {
1768                 // The easiest way to bubble the revert reason is using memory via assembly
1769                 /// @solidity memory-safe-assembly
1770                 assembly {
1771                     let returndata_size := mload(returndata)
1772                     revert(add(32, returndata), returndata_size)
1773                 }
1774             } else {
1775                 revert(errorMessage);
1776             }
1777         }
1778     }
1779 }
1780 
1781 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1782 
1783 
1784 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1785 
1786 pragma solidity ^0.8.0;
1787 
1788 /**
1789  * @dev Interface of the ERC165 standard, as defined in the
1790  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1791  *
1792  * Implementers can declare support of contract interfaces, which can then be
1793  * queried by others ({ERC165Checker}).
1794  *
1795  * For an implementation, see {ERC165}.
1796  */
1797 interface IERC165 {
1798     /**
1799      * @dev Returns true if this contract implements the interface defined by
1800      * `interfaceId`. See the corresponding
1801      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1802      * to learn more about how these ids are created.
1803      *
1804      * This function call must use less than 30 000 gas.
1805      */
1806     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1807 }
1808 
1809 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1810 
1811 
1812 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1813 
1814 pragma solidity ^0.8.0;
1815 
1816 
1817 /**
1818  * @dev Implementation of the {IERC165} interface.
1819  *
1820  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1821  * for the additional interface id that will be supported. For example:
1822  *
1823  * ```solidity
1824  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1825  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1826  * }
1827  * ```
1828  *
1829  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1830  */
1831 abstract contract ERC165 is IERC165 {
1832     /**
1833      * @dev See {IERC165-supportsInterface}.
1834      */
1835     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1836         return interfaceId == type(IERC165).interfaceId;
1837     }
1838 }
1839 
1840 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1841 
1842 
1843 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1844 
1845 pragma solidity ^0.8.0;
1846 
1847 
1848 /**
1849  * @dev Interface for the NFT Royalty Standard.
1850  *
1851  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1852  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1853  *
1854  * _Available since v4.5._
1855  */
1856 interface IERC2981 is IERC165 {
1857     /**
1858      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1859      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1860      */
1861     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1862         external
1863         view
1864         returns (address receiver, uint256 royaltyAmount);
1865 }
1866 
1867 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1868 
1869 
1870 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1871 
1872 pragma solidity ^0.8.0;
1873 
1874 
1875 
1876 /**
1877  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1878  *
1879  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1880  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1881  *
1882  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1883  * fee is specified in basis points by default.
1884  *
1885  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1886  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1887  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1888  *
1889  * _Available since v4.5._
1890  */
1891 abstract contract ERC2981 is IERC2981, ERC165 {
1892     struct RoyaltyInfo {
1893         address receiver;
1894         uint96 royaltyFraction;
1895     }
1896 
1897     RoyaltyInfo private _defaultRoyaltyInfo;
1898     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1899 
1900     /**
1901      * @dev See {IERC165-supportsInterface}.
1902      */
1903     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1904         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1905     }
1906 
1907     /**
1908      * @inheritdoc IERC2981
1909      */
1910     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1911         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1912 
1913         if (royalty.receiver == address(0)) {
1914             royalty = _defaultRoyaltyInfo;
1915         }
1916 
1917         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1918 
1919         return (royalty.receiver, royaltyAmount);
1920     }
1921 
1922     /**
1923      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1924      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1925      * override.
1926      */
1927     function _feeDenominator() internal pure virtual returns (uint96) {
1928         return 10000;
1929     }
1930 
1931     /**
1932      * @dev Sets the royalty information that all ids in this contract will default to.
1933      *
1934      * Requirements:
1935      *
1936      * - `receiver` cannot be the zero address.
1937      * - `feeNumerator` cannot be greater than the fee denominator.
1938      */
1939     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1940         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1941         require(receiver != address(0), "ERC2981: invalid receiver");
1942 
1943         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1944     }
1945 
1946     /**
1947      * @dev Removes default royalty information.
1948      */
1949     function _deleteDefaultRoyalty() internal virtual {
1950         delete _defaultRoyaltyInfo;
1951     }
1952 
1953     /**
1954      * @dev Sets the royalty information for a specific token id, overriding the global default.
1955      *
1956      * Requirements:
1957      *
1958      * - `receiver` cannot be the zero address.
1959      * - `feeNumerator` cannot be greater than the fee denominator.
1960      */
1961     function _setTokenRoyalty(
1962         uint256 tokenId,
1963         address receiver,
1964         uint96 feeNumerator
1965     ) internal virtual {
1966         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1967         require(receiver != address(0), "ERC2981: Invalid parameters");
1968 
1969         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1970     }
1971 
1972     /**
1973      * @dev Resets royalty information for the token id back to the global default.
1974      */
1975     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1976         delete _tokenRoyaltyInfo[tokenId];
1977     }
1978 }
1979 
1980 // File: @openzeppelin/contracts/utils/Context.sol
1981 
1982 
1983 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1984 
1985 pragma solidity ^0.8.0;
1986 
1987 /**
1988  * @dev Provides information about the current execution context, including the
1989  * sender of the transaction and its data. While these are generally available
1990  * via msg.sender and msg.data, they should not be accessed in such a direct
1991  * manner, since when dealing with meta-transactions the account sending and
1992  * paying for execution may not be the actual sender (as far as an application
1993  * is concerned).
1994  *
1995  * This contract is only required for intermediate, library-like contracts.
1996  */
1997 abstract contract Context {
1998     function _msgSender() internal view virtual returns (address) {
1999         return msg.sender;
2000     }
2001 
2002     function _msgData() internal view virtual returns (bytes calldata) {
2003         return msg.data;
2004     }
2005 }
2006 
2007 // File: @openzeppelin/contracts/access/Ownable.sol
2008 
2009 
2010 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2011 
2012 pragma solidity ^0.8.0;
2013 
2014 
2015 /**
2016  * @dev Contract module which provides a basic access control mechanism, where
2017  * there is an account (an owner) that can be granted exclusive access to
2018  * specific functions.
2019  *
2020  * By default, the owner account will be the one that deploys the contract. This
2021  * can later be changed with {transferOwnership}.
2022  *
2023  * This module is used through inheritance. It will make available the modifier
2024  * `onlyOwner`, which can be applied to your functions to restrict their use to
2025  * the owner.
2026  */
2027 abstract contract Ownable is Context {
2028     address private _owner;
2029 
2030     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2031 
2032     /**
2033      * @dev Initializes the contract setting the deployer as the initial owner.
2034      */
2035     constructor() {
2036         _transferOwnership(_msgSender());
2037     }
2038 
2039     /**
2040      * @dev Throws if called by any account other than the owner.
2041      */
2042     modifier onlyOwner() {
2043         _checkOwner();
2044         _;
2045     }
2046 
2047     /**
2048      * @dev Returns the address of the current owner.
2049      */
2050     function owner() public view virtual returns (address) {
2051         return _owner;
2052     }
2053 
2054     /**
2055      * @dev Throws if the sender is not the owner.
2056      */
2057     function _checkOwner() internal view virtual {
2058         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2059     }
2060 
2061     /**
2062      * @dev Leaves the contract without owner. It will not be possible to call
2063      * `onlyOwner` functions anymore. Can only be called by the current owner.
2064      *
2065      * NOTE: Renouncing ownership will leave the contract without an owner,
2066      * thereby removing any functionality that is only available to the owner.
2067      */
2068     function renounceOwnership() public virtual onlyOwner {
2069         _transferOwnership(address(0));
2070     }
2071 
2072     /**
2073      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2074      * Can only be called by the current owner.
2075      */
2076     function transferOwnership(address newOwner) public virtual onlyOwner {
2077         require(newOwner != address(0), "Ownable: new owner is the zero address");
2078         _transferOwnership(newOwner);
2079     }
2080 
2081     /**
2082      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2083      * Internal function without access restriction.
2084      */
2085     function _transferOwnership(address newOwner) internal virtual {
2086         address oldOwner = _owner;
2087         _owner = newOwner;
2088         emit OwnershipTransferred(oldOwner, newOwner);
2089     }
2090 }
2091 
2092 // File: GRIND2/3-Demon.sol
2093 
2094 
2095 pragma solidity ^0.8.9;
2096 
2097 
2098 
2099 
2100 
2101 
2102 contract DemonSlayyyyyyya is ERC2981, ERC721AQueryable, Ownable {
2103     using Address for address payable;
2104     using Strings for uint256;
2105 
2106     uint256 public immutable _price;
2107     uint32 public immutable _txLimit;
2108     uint32 public immutable _maxSupply;
2109     uint32 public immutable _teamReserved;
2110     uint32 public immutable _walletLimit;
2111 
2112     bool public _started;
2113     uint32 public _teamMinted;
2114     string public _metadataURI = "ipfs://QmXHWWzAyQTFr35B287ccbKWZaW8a69EX2KKeTnRZoaT5m/";
2115 
2116     struct HelperState {
2117         uint256 price;
2118         uint32 txLimit;
2119         uint32 walletLimit;
2120         uint32 maxSupply;
2121         uint32 teamReserved;
2122         uint32 totalMinted;
2123         uint32 userMinted;
2124         bool started;
2125     }
2126 
2127     constructor( uint256 price, uint32 maxSupply, uint32 txLimit, uint32 walletLimit, uint32 teamReserved) ERC721A("Demon", "DEMON") {
2128         _price = price;
2129         _maxSupply = maxSupply;
2130         _txLimit = txLimit;
2131         _walletLimit = walletLimit;
2132         _teamReserved = teamReserved;
2133 
2134         _setDefaultRoyalty(owner(), 500);
2135     }
2136 
2137     function mint(uint32 amount) external payable {
2138         require(_started, "Sale is not started");
2139         require(amount + _totalMinted() <= _maxSupply - _teamReserved, "Exceed max supply");
2140         require(amount <= _txLimit, "Exceed transaction limit");
2141 
2142         uint256 minted = _numberMinted(msg.sender);
2143         if (minted > 0) {
2144             require(msg.value >= amount * _price, "Insufficient funds");
2145         } else {
2146             require(msg.value >= (amount - 1) * _price, "Insufficient funds");
2147         }
2148 
2149         require(minted + amount <= _walletLimit, "Exceed wallet limit");
2150 
2151         _safeMint(msg.sender, amount);
2152     }
2153 
2154     function _state(address minter) external view returns (HelperState memory) {
2155         return
2156             HelperState({
2157                 price: _price,
2158                 txLimit: _txLimit,
2159                 walletLimit: _walletLimit,
2160                 maxSupply: _maxSupply,
2161                 teamReserved: _teamReserved,
2162                 totalMinted: uint32(ERC721A._totalMinted()),
2163                 userMinted: uint32(_numberMinted(minter)),
2164                 started: _started
2165             });
2166     }
2167 
2168     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2169         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2170 
2171         string memory baseURI = _metadataURI;
2172         return string(abi.encodePacked(baseURI, tokenId.toString(), ""));
2173     }
2174 
2175     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2981, ERC721A) returns (bool) {
2176         return
2177             interfaceId == type(IERC2981).interfaceId ||
2178             interfaceId == type(IERC721A).interfaceId ||
2179             super.supportsInterface(interfaceId);
2180     }
2181 
2182     function devMint(address to, uint32 amount) external onlyOwner {
2183         _teamMinted += amount;
2184         require (_teamMinted <= _teamReserved, "Exceed max supply");
2185         _safeMint(to, amount);
2186     }
2187 
2188     function setFeeNumerator(uint96 feeNumerator) external onlyOwner {
2189         _setDefaultRoyalty(owner(), feeNumerator);
2190     }
2191 
2192     function setStarted(bool started) external onlyOwner {
2193         _started = started;
2194     }
2195 
2196     function setMetadataURI(string memory uri) external onlyOwner {
2197         _metadataURI = uri;
2198     }
2199 
2200     function withdraw() external onlyOwner {
2201         payable(msg.sender).sendValue(address(this).balance);
2202     }
2203 }