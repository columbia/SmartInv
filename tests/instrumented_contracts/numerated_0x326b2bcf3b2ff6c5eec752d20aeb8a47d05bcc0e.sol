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
1233 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1234 
1235 
1236 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 /**
1241  * @dev Contract module that helps prevent reentrant calls to a function.
1242  *
1243  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1244  * available, which can be applied to functions to make sure there are no nested
1245  * (reentrant) calls to them.
1246  *
1247  * Note that because there is a single `nonReentrant` guard, functions marked as
1248  * `nonReentrant` may not call one another. This can be worked around by making
1249  * those functions `private`, and then adding `external` `nonReentrant` entry
1250  * points to them.
1251  *
1252  * TIP: If you would like to learn more about reentrancy and alternative ways
1253  * to protect against it, check out our blog post
1254  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1255  */
1256 abstract contract ReentrancyGuard {
1257     // Booleans are more expensive than uint256 or any type that takes up a full
1258     // word because each write operation emits an extra SLOAD to first read the
1259     // slot's contents, replace the bits taken up by the boolean, and then write
1260     // back. This is the compiler's defense against contract upgrades and
1261     // pointer aliasing, and it cannot be disabled.
1262 
1263     // The values being non-zero value makes deployment a bit more expensive,
1264     // but in exchange the refund on every call to nonReentrant will be lower in
1265     // amount. Since refunds are capped to a percentage of the total
1266     // transaction's gas, it is best to keep them low in cases like this one, to
1267     // increase the likelihood of the full refund coming into effect.
1268     uint256 private constant _NOT_ENTERED = 1;
1269     uint256 private constant _ENTERED = 2;
1270 
1271     uint256 private _status;
1272 
1273     constructor() {
1274         _status = _NOT_ENTERED;
1275     }
1276 
1277     /**
1278      * @dev Prevents a contract from calling itself, directly or indirectly.
1279      * Calling a `nonReentrant` function from another `nonReentrant`
1280      * function is not supported. It is possible to prevent this from happening
1281      * by making the `nonReentrant` function external, and making it call a
1282      * `private` function that does the actual work.
1283      */
1284     modifier nonReentrant() {
1285         // On the first call to nonReentrant, _notEntered will be true
1286         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1287 
1288         // Any calls to nonReentrant after this point will fail
1289         _status = _ENTERED;
1290 
1291         _;
1292 
1293         // By storing the original value once again, a refund is triggered (see
1294         // https://eips.ethereum.org/EIPS/eip-2200)
1295         _status = _NOT_ENTERED;
1296     }
1297 }
1298 
1299 // File: @openzeppelin/contracts/utils/Address.sol
1300 
1301 
1302 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1303 
1304 pragma solidity ^0.8.1;
1305 
1306 /**
1307  * @dev Collection of functions related to the address type
1308  */
1309 library Address {
1310     /**
1311      * @dev Returns true if `account` is a contract.
1312      *
1313      * [IMPORTANT]
1314      * ====
1315      * It is unsafe to assume that an address for which this function returns
1316      * false is an externally-owned account (EOA) and not a contract.
1317      *
1318      * Among others, `isContract` will return false for the following
1319      * types of addresses:
1320      *
1321      *  - an externally-owned account
1322      *  - a contract in construction
1323      *  - an address where a contract will be created
1324      *  - an address where a contract lived, but was destroyed
1325      * ====
1326      *
1327      * [IMPORTANT]
1328      * ====
1329      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1330      *
1331      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1332      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1333      * constructor.
1334      * ====
1335      */
1336     function isContract(address account) internal view returns (bool) {
1337         // This method relies on extcodesize/address.code.length, which returns 0
1338         // for contracts in construction, since the code is only stored at the end
1339         // of the constructor execution.
1340 
1341         return account.code.length > 0;
1342     }
1343 
1344     /**
1345      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1346      * `recipient`, forwarding all available gas and reverting on errors.
1347      *
1348      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1349      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1350      * imposed by `transfer`, making them unable to receive funds via
1351      * `transfer`. {sendValue} removes this limitation.
1352      *
1353      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1354      *
1355      * IMPORTANT: because control is transferred to `recipient`, care must be
1356      * taken to not create reentrancy vulnerabilities. Consider using
1357      * {ReentrancyGuard} or the
1358      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1359      */
1360     function sendValue(address payable recipient, uint256 amount) internal {
1361         require(address(this).balance >= amount, "Address: insufficient balance");
1362 
1363         (bool success, ) = recipient.call{value: amount}("");
1364         require(success, "Address: unable to send value, recipient may have reverted");
1365     }
1366 
1367     /**
1368      * @dev Performs a Solidity function call using a low level `call`. A
1369      * plain `call` is an unsafe replacement for a function call: use this
1370      * function instead.
1371      *
1372      * If `target` reverts with a revert reason, it is bubbled up by this
1373      * function (like regular Solidity function calls).
1374      *
1375      * Returns the raw returned data. To convert to the expected return value,
1376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1377      *
1378      * Requirements:
1379      *
1380      * - `target` must be a contract.
1381      * - calling `target` with `data` must not revert.
1382      *
1383      * _Available since v3.1._
1384      */
1385     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1386         return functionCall(target, data, "Address: low-level call failed");
1387     }
1388 
1389     /**
1390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1391      * `errorMessage` as a fallback revert reason when `target` reverts.
1392      *
1393      * _Available since v3.1._
1394      */
1395     function functionCall(
1396         address target,
1397         bytes memory data,
1398         string memory errorMessage
1399     ) internal returns (bytes memory) {
1400         return functionCallWithValue(target, data, 0, errorMessage);
1401     }
1402 
1403     /**
1404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1405      * but also transferring `value` wei to `target`.
1406      *
1407      * Requirements:
1408      *
1409      * - the calling contract must have an ETH balance of at least `value`.
1410      * - the called Solidity function must be `payable`.
1411      *
1412      * _Available since v3.1._
1413      */
1414     function functionCallWithValue(
1415         address target,
1416         bytes memory data,
1417         uint256 value
1418     ) internal returns (bytes memory) {
1419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1420     }
1421 
1422     /**
1423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1424      * with `errorMessage` as a fallback revert reason when `target` reverts.
1425      *
1426      * _Available since v3.1._
1427      */
1428     function functionCallWithValue(
1429         address target,
1430         bytes memory data,
1431         uint256 value,
1432         string memory errorMessage
1433     ) internal returns (bytes memory) {
1434         require(address(this).balance >= value, "Address: insufficient balance for call");
1435         require(isContract(target), "Address: call to non-contract");
1436 
1437         (bool success, bytes memory returndata) = target.call{value: value}(data);
1438         return verifyCallResult(success, returndata, errorMessage);
1439     }
1440 
1441     /**
1442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1443      * but performing a static call.
1444      *
1445      * _Available since v3.3._
1446      */
1447     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1448         return functionStaticCall(target, data, "Address: low-level static call failed");
1449     }
1450 
1451     /**
1452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1453      * but performing a static call.
1454      *
1455      * _Available since v3.3._
1456      */
1457     function functionStaticCall(
1458         address target,
1459         bytes memory data,
1460         string memory errorMessage
1461     ) internal view returns (bytes memory) {
1462         require(isContract(target), "Address: static call to non-contract");
1463 
1464         (bool success, bytes memory returndata) = target.staticcall(data);
1465         return verifyCallResult(success, returndata, errorMessage);
1466     }
1467 
1468     /**
1469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1470      * but performing a delegate call.
1471      *
1472      * _Available since v3.4._
1473      */
1474     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1475         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1476     }
1477 
1478     /**
1479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1480      * but performing a delegate call.
1481      *
1482      * _Available since v3.4._
1483      */
1484     function functionDelegateCall(
1485         address target,
1486         bytes memory data,
1487         string memory errorMessage
1488     ) internal returns (bytes memory) {
1489         require(isContract(target), "Address: delegate call to non-contract");
1490 
1491         (bool success, bytes memory returndata) = target.delegatecall(data);
1492         return verifyCallResult(success, returndata, errorMessage);
1493     }
1494 
1495     /**
1496      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1497      * revert reason using the provided one.
1498      *
1499      * _Available since v4.3._
1500      */
1501     function verifyCallResult(
1502         bool success,
1503         bytes memory returndata,
1504         string memory errorMessage
1505     ) internal pure returns (bytes memory) {
1506         if (success) {
1507             return returndata;
1508         } else {
1509             // Look for revert reason and bubble it up if present
1510             if (returndata.length > 0) {
1511                 // The easiest way to bubble the revert reason is using memory via assembly
1512 
1513                 assembly {
1514                     let returndata_size := mload(returndata)
1515                     revert(add(32, returndata), returndata_size)
1516                 }
1517             } else {
1518                 revert(errorMessage);
1519             }
1520         }
1521     }
1522 }
1523 
1524 // File: @openzeppelin/contracts/utils/Strings.sol
1525 
1526 
1527 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1528 
1529 pragma solidity ^0.8.0;
1530 
1531 /**
1532  * @dev String operations.
1533  */
1534 library Strings {
1535     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1536 
1537     /**
1538      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1539      */
1540     function toString(uint256 value) internal pure returns (string memory) {
1541         // Inspired by OraclizeAPI's implementation - MIT licence
1542         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1543 
1544         if (value == 0) {
1545             return "0";
1546         }
1547         uint256 temp = value;
1548         uint256 digits;
1549         while (temp != 0) {
1550             digits++;
1551             temp /= 10;
1552         }
1553         bytes memory buffer = new bytes(digits);
1554         while (value != 0) {
1555             digits -= 1;
1556             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1557             value /= 10;
1558         }
1559         return string(buffer);
1560     }
1561 
1562     /**
1563      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1564      */
1565     function toHexString(uint256 value) internal pure returns (string memory) {
1566         if (value == 0) {
1567             return "0x00";
1568         }
1569         uint256 temp = value;
1570         uint256 length = 0;
1571         while (temp != 0) {
1572             length++;
1573             temp >>= 8;
1574         }
1575         return toHexString(value, length);
1576     }
1577 
1578     /**
1579      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1580      */
1581     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1582         bytes memory buffer = new bytes(2 * length + 2);
1583         buffer[0] = "0";
1584         buffer[1] = "x";
1585         for (uint256 i = 2 * length + 1; i > 1; --i) {
1586             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1587             value >>= 4;
1588         }
1589         require(value == 0, "Strings: hex length insufficient");
1590         return string(buffer);
1591     }
1592 }
1593 
1594 // File: @openzeppelin/contracts/utils/Context.sol
1595 
1596 
1597 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1598 
1599 pragma solidity ^0.8.0;
1600 
1601 /**
1602  * @dev Provides information about the current execution context, including the
1603  * sender of the transaction and its data. While these are generally available
1604  * via msg.sender and msg.data, they should not be accessed in such a direct
1605  * manner, since when dealing with meta-transactions the account sending and
1606  * paying for execution may not be the actual sender (as far as an application
1607  * is concerned).
1608  *
1609  * This contract is only required for intermediate, library-like contracts.
1610  */
1611 abstract contract Context {
1612     function _msgSender() internal view virtual returns (address) {
1613         return msg.sender;
1614     }
1615 
1616     function _msgData() internal view virtual returns (bytes calldata) {
1617         return msg.data;
1618     }
1619 }
1620 
1621 // File: @openzeppelin/contracts/security/Pausable.sol
1622 
1623 
1624 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1625 
1626 pragma solidity ^0.8.0;
1627 
1628 
1629 /**
1630  * @dev Contract module which allows children to implement an emergency stop
1631  * mechanism that can be triggered by an authorized account.
1632  *
1633  * This module is used through inheritance. It will make available the
1634  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1635  * the functions of your contract. Note that they will not be pausable by
1636  * simply including this module, only once the modifiers are put in place.
1637  */
1638 abstract contract Pausable is Context {
1639     /**
1640      * @dev Emitted when the pause is triggered by `account`.
1641      */
1642     event Paused(address account);
1643 
1644     /**
1645      * @dev Emitted when the pause is lifted by `account`.
1646      */
1647     event Unpaused(address account);
1648 
1649     bool private _paused;
1650 
1651     /**
1652      * @dev Initializes the contract in unpaused state.
1653      */
1654     constructor() {
1655         _paused = false;
1656     }
1657 
1658     /**
1659      * @dev Returns true if the contract is paused, and false otherwise.
1660      */
1661     function paused() public view virtual returns (bool) {
1662         return _paused;
1663     }
1664 
1665     /**
1666      * @dev Modifier to make a function callable only when the contract is not paused.
1667      *
1668      * Requirements:
1669      *
1670      * - The contract must not be paused.
1671      */
1672     modifier whenNotPaused() {
1673         require(!paused(), "Pausable: paused");
1674         _;
1675     }
1676 
1677     /**
1678      * @dev Modifier to make a function callable only when the contract is paused.
1679      *
1680      * Requirements:
1681      *
1682      * - The contract must be paused.
1683      */
1684     modifier whenPaused() {
1685         require(paused(), "Pausable: not paused");
1686         _;
1687     }
1688 
1689     /**
1690      * @dev Triggers stopped state.
1691      *
1692      * Requirements:
1693      *
1694      * - The contract must not be paused.
1695      */
1696     function _pause() internal virtual whenNotPaused {
1697         _paused = true;
1698         emit Paused(_msgSender());
1699     }
1700 
1701     /**
1702      * @dev Returns to normal state.
1703      *
1704      * Requirements:
1705      *
1706      * - The contract must be paused.
1707      */
1708     function _unpause() internal virtual whenPaused {
1709         _paused = false;
1710         emit Unpaused(_msgSender());
1711     }
1712 }
1713 
1714 // File: @openzeppelin/contracts/access/Ownable.sol
1715 
1716 
1717 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1718 
1719 pragma solidity ^0.8.0;
1720 
1721 
1722 /**
1723  * @dev Contract module which provides a basic access control mechanism, where
1724  * there is an account (an owner) that can be granted exclusive access to
1725  * specific functions.
1726  *
1727  * By default, the owner account will be the one that deploys the contract. This
1728  * can later be changed with {transferOwnership}.
1729  *
1730  * This module is used through inheritance. It will make available the modifier
1731  * `onlyOwner`, which can be applied to your functions to restrict their use to
1732  * the owner.
1733  */
1734 abstract contract Ownable is Context {
1735     address private _owner;
1736 
1737     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1738 
1739     /**
1740      * @dev Initializes the contract setting the deployer as the initial owner.
1741      */
1742     constructor() {
1743         _transferOwnership(_msgSender());
1744     }
1745 
1746     /**
1747      * @dev Returns the address of the current owner.
1748      */
1749     function owner() public view virtual returns (address) {
1750         return _owner;
1751     }
1752 
1753     /**
1754      * @dev Throws if called by any account other than the owner.
1755      */
1756     modifier onlyOwner() {
1757         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1758         _;
1759     }
1760 
1761     /**
1762      * @dev Leaves the contract without owner. It will not be possible to call
1763      * `onlyOwner` functions anymore. Can only be called by the current owner.
1764      *
1765      * NOTE: Renouncing ownership will leave the contract without an owner,
1766      * thereby removing any functionality that is only available to the owner.
1767      */
1768     function renounceOwnership() public virtual onlyOwner {
1769         _transferOwnership(address(0));
1770     }
1771 
1772     /**
1773      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1774      * Can only be called by the current owner.
1775      */
1776     function transferOwnership(address newOwner) public virtual onlyOwner {
1777         require(newOwner != address(0), "Ownable: new owner is the zero address");
1778         _transferOwnership(newOwner);
1779     }
1780 
1781     /**
1782      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1783      * Internal function without access restriction.
1784      */
1785     function _transferOwnership(address newOwner) internal virtual {
1786         address oldOwner = _owner;
1787         _owner = newOwner;
1788         emit OwnershipTransferred(oldOwner, newOwner);
1789     }
1790 }
1791 
1792 // File: contracts/StrangeIllusions.sol
1793 
1794 
1795 
1796 pragma solidity ^0.8.0;
1797 
1798 contract StrangeIllusions is ERC721A, Ownable, ReentrancyGuard {
1799   using Address for address;
1800   using Strings for uint;
1801 
1802 
1803   string  public  baseTokenURI = "";
1804   uint256  public  maxSupply = 1000;
1805   uint256 public  MAX_MINTS_PER_TX = 10;
1806   uint256 public  PUBLIC_SALE_PRICE = 0.001 ether;
1807   uint256 public  NUM_FREE_MINTS = 800;
1808   uint256 public  MAX_FREE_PER_WALLET = 1;
1809   bool public isPublicSaleActive = true;
1810 
1811   constructor(
1812 
1813   ) ERC721A("Strange Illusions by Chris Ellis", "SICE") {
1814 
1815   }
1816 
1817 
1818   function mint(uint256 numberOfTokens)
1819       external
1820       payable
1821   {
1822     require(isPublicSaleActive, "Public sale is not open");
1823     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1824 
1825     if (numberOfTokens > MAX_FREE_PER_WALLET) {
1826         require(
1827             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1828             "Incorrect ETH value sent"
1829         );
1830         require(
1831             numberOfTokens <= MAX_MINTS_PER_TX,
1832             "Max mints per transaction exceeded"
1833         );
1834         } else {
1835             require(
1836                 numberOfTokens <= MAX_FREE_PER_WALLET,
1837                 "Max mints per transaction exceeded"
1838             );
1839         }
1840         _safeMint(msg.sender, numberOfTokens);
1841   }
1842 
1843   function setBaseURI(string memory baseURI)
1844     public
1845     onlyOwner
1846   {
1847     baseTokenURI = baseURI;
1848   }
1849 
1850   function treasuryMint(uint quantity)
1851     public
1852     onlyOwner
1853   {
1854     require(
1855       quantity > 0,
1856       "Invalid mint amount"
1857     );
1858     require(
1859       totalSupply() + quantity <= maxSupply,
1860       "Maximum supply exceeded"
1861     );
1862     _safeMint(msg.sender, quantity);
1863   }
1864 
1865   function withdraw()
1866     public
1867     onlyOwner
1868     nonReentrant
1869   {
1870     Address.sendValue(payable(msg.sender), address(this).balance);
1871   }
1872 
1873   function tokenURI(uint _tokenId)
1874     public
1875     view
1876     virtual
1877     override
1878     returns (string memory)
1879   {
1880     require(
1881       _exists(_tokenId),
1882       "ERC721Metadata: URI query for nonexistent token"
1883     );
1884     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1885   }
1886 
1887   function _baseURI()
1888     internal
1889     view
1890     virtual
1891     override
1892     returns (string memory)
1893   {
1894     return baseTokenURI;
1895   }
1896 
1897   function setIsPublicSaleActive(bool _isPublicSaleActive)
1898       external
1899       onlyOwner
1900   {
1901       isPublicSaleActive = _isPublicSaleActive;
1902   }
1903 
1904   function setNumFreeMints(uint256 _numfreemints)
1905       external
1906       onlyOwner
1907   {
1908       NUM_FREE_MINTS = _numfreemints;
1909   }
1910 
1911   function setSalePrice(uint256 _price)
1912       external
1913       onlyOwner
1914   {
1915       PUBLIC_SALE_PRICE = _price;
1916   }
1917 
1918   function setMaxLimitPerTransaction(uint256 _limit)
1919       external
1920       onlyOwner
1921   {
1922       MAX_MINTS_PER_TX = _limit;
1923   }
1924 
1925   function setFreeLimitPerWallet(uint256 _limit)
1926       external
1927       onlyOwner
1928   {
1929       MAX_FREE_PER_WALLET = _limit;
1930   }
1931 }