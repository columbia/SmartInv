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
1233 // File: @openzeppelin/contracts/utils/Address.sol
1234 
1235 
1236 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1237 
1238 pragma solidity ^0.8.1;
1239 
1240 /**
1241  * @dev Collection of functions related to the address type
1242  */
1243 library Address {
1244     /**
1245      * @dev Returns true if `account` is a contract.
1246      *
1247      * [IMPORTANT]
1248      * ====
1249      * It is unsafe to assume that an address for which this function returns
1250      * false is an externally-owned account (EOA) and not a contract.
1251      *
1252      * Among others, `isContract` will return false for the following
1253      * types of addresses:
1254      *
1255      *  - an externally-owned account
1256      *  - a contract in construction
1257      *  - an address where a contract will be created
1258      *  - an address where a contract lived, but was destroyed
1259      * ====
1260      *
1261      * [IMPORTANT]
1262      * ====
1263      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1264      *
1265      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1266      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1267      * constructor.
1268      * ====
1269      */
1270     function isContract(address account) internal view returns (bool) {
1271         // This method relies on extcodesize/address.code.length, which returns 0
1272         // for contracts in construction, since the code is only stored at the end
1273         // of the constructor execution.
1274 
1275         return account.code.length > 0;
1276     }
1277 
1278     /**
1279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1280      * `recipient`, forwarding all available gas and reverting on errors.
1281      *
1282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1284      * imposed by `transfer`, making them unable to receive funds via
1285      * `transfer`. {sendValue} removes this limitation.
1286      *
1287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1288      *
1289      * IMPORTANT: because control is transferred to `recipient`, care must be
1290      * taken to not create reentrancy vulnerabilities. Consider using
1291      * {ReentrancyGuard} or the
1292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1293      */
1294     function sendValue(address payable recipient, uint256 amount) internal {
1295         require(address(this).balance >= amount, "Address: insufficient balance");
1296 
1297         (bool success, ) = recipient.call{value: amount}("");
1298         require(success, "Address: unable to send value, recipient may have reverted");
1299     }
1300 
1301     /**
1302      * @dev Performs a Solidity function call using a low level `call`. A
1303      * plain `call` is an unsafe replacement for a function call: use this
1304      * function instead.
1305      *
1306      * If `target` reverts with a revert reason, it is bubbled up by this
1307      * function (like regular Solidity function calls).
1308      *
1309      * Returns the raw returned data. To convert to the expected return value,
1310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1311      *
1312      * Requirements:
1313      *
1314      * - `target` must be a contract.
1315      * - calling `target` with `data` must not revert.
1316      *
1317      * _Available since v3.1._
1318      */
1319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1320         return functionCall(target, data, "Address: low-level call failed");
1321     }
1322 
1323     /**
1324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1325      * `errorMessage` as a fallback revert reason when `target` reverts.
1326      *
1327      * _Available since v3.1._
1328      */
1329     function functionCall(
1330         address target,
1331         bytes memory data,
1332         string memory errorMessage
1333     ) internal returns (bytes memory) {
1334         return functionCallWithValue(target, data, 0, errorMessage);
1335     }
1336 
1337     /**
1338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1339      * but also transferring `value` wei to `target`.
1340      *
1341      * Requirements:
1342      *
1343      * - the calling contract must have an ETH balance of at least `value`.
1344      * - the called Solidity function must be `payable`.
1345      *
1346      * _Available since v3.1._
1347      */
1348     function functionCallWithValue(
1349         address target,
1350         bytes memory data,
1351         uint256 value
1352     ) internal returns (bytes memory) {
1353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1354     }
1355 
1356     /**
1357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1358      * with `errorMessage` as a fallback revert reason when `target` reverts.
1359      *
1360      * _Available since v3.1._
1361      */
1362     function functionCallWithValue(
1363         address target,
1364         bytes memory data,
1365         uint256 value,
1366         string memory errorMessage
1367     ) internal returns (bytes memory) {
1368         require(address(this).balance >= value, "Address: insufficient balance for call");
1369         require(isContract(target), "Address: call to non-contract");
1370 
1371         (bool success, bytes memory returndata) = target.call{value: value}(data);
1372         return verifyCallResult(success, returndata, errorMessage);
1373     }
1374 
1375     /**
1376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1377      * but performing a static call.
1378      *
1379      * _Available since v3.3._
1380      */
1381     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1382         return functionStaticCall(target, data, "Address: low-level static call failed");
1383     }
1384 
1385     /**
1386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1387      * but performing a static call.
1388      *
1389      * _Available since v3.3._
1390      */
1391     function functionStaticCall(
1392         address target,
1393         bytes memory data,
1394         string memory errorMessage
1395     ) internal view returns (bytes memory) {
1396         require(isContract(target), "Address: static call to non-contract");
1397 
1398         (bool success, bytes memory returndata) = target.staticcall(data);
1399         return verifyCallResult(success, returndata, errorMessage);
1400     }
1401 
1402     /**
1403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1404      * but performing a delegate call.
1405      *
1406      * _Available since v3.4._
1407      */
1408     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1409         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1410     }
1411 
1412     /**
1413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1414      * but performing a delegate call.
1415      *
1416      * _Available since v3.4._
1417      */
1418     function functionDelegateCall(
1419         address target,
1420         bytes memory data,
1421         string memory errorMessage
1422     ) internal returns (bytes memory) {
1423         require(isContract(target), "Address: delegate call to non-contract");
1424 
1425         (bool success, bytes memory returndata) = target.delegatecall(data);
1426         return verifyCallResult(success, returndata, errorMessage);
1427     }
1428 
1429     /**
1430      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1431      * revert reason using the provided one.
1432      *
1433      * _Available since v4.3._
1434      */
1435     function verifyCallResult(
1436         bool success,
1437         bytes memory returndata,
1438         string memory errorMessage
1439     ) internal pure returns (bytes memory) {
1440         if (success) {
1441             return returndata;
1442         } else {
1443             // Look for revert reason and bubble it up if present
1444             if (returndata.length > 0) {
1445                 // The easiest way to bubble the revert reason is using memory via assembly
1446                 /// @solidity memory-safe-assembly
1447                 assembly {
1448                     let returndata_size := mload(returndata)
1449                     revert(add(32, returndata), returndata_size)
1450                 }
1451             } else {
1452                 revert(errorMessage);
1453             }
1454         }
1455     }
1456 }
1457 
1458 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1459 
1460 
1461 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 /**
1466  * @dev Interface of the ERC20 standard as defined in the EIP.
1467  */
1468 interface IERC20 {
1469     /**
1470      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1471      * another (`to`).
1472      *
1473      * Note that `value` may be zero.
1474      */
1475     event Transfer(address indexed from, address indexed to, uint256 value);
1476 
1477     /**
1478      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1479      * a call to {approve}. `value` is the new allowance.
1480      */
1481     event Approval(address indexed owner, address indexed spender, uint256 value);
1482 
1483     /**
1484      * @dev Returns the amount of tokens in existence.
1485      */
1486     function totalSupply() external view returns (uint256);
1487 
1488     /**
1489      * @dev Returns the amount of tokens owned by `account`.
1490      */
1491     function balanceOf(address account) external view returns (uint256);
1492 
1493     /**
1494      * @dev Moves `amount` tokens from the caller's account to `to`.
1495      *
1496      * Returns a boolean value indicating whether the operation succeeded.
1497      *
1498      * Emits a {Transfer} event.
1499      */
1500     function transfer(address to, uint256 amount) external returns (bool);
1501 
1502     /**
1503      * @dev Returns the remaining number of tokens that `spender` will be
1504      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1505      * zero by default.
1506      *
1507      * This value changes when {approve} or {transferFrom} are called.
1508      */
1509     function allowance(address owner, address spender) external view returns (uint256);
1510 
1511     /**
1512      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1513      *
1514      * Returns a boolean value indicating whether the operation succeeded.
1515      *
1516      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1517      * that someone may use both the old and the new allowance by unfortunate
1518      * transaction ordering. One possible solution to mitigate this race
1519      * condition is to first reduce the spender's allowance to 0 and set the
1520      * desired value afterwards:
1521      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1522      *
1523      * Emits an {Approval} event.
1524      */
1525     function approve(address spender, uint256 amount) external returns (bool);
1526 
1527     /**
1528      * @dev Moves `amount` tokens from `from` to `to` using the
1529      * allowance mechanism. `amount` is then deducted from the caller's
1530      * allowance.
1531      *
1532      * Returns a boolean value indicating whether the operation succeeded.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function transferFrom(
1537         address from,
1538         address to,
1539         uint256 amount
1540     ) external returns (bool);
1541 }
1542 
1543 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1544 
1545 
1546 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1547 
1548 pragma solidity ^0.8.0;
1549 
1550 
1551 /**
1552  * @dev Interface for the optional metadata functions from the ERC20 standard.
1553  *
1554  * _Available since v4.1._
1555  */
1556 interface IERC20Metadata is IERC20 {
1557     /**
1558      * @dev Returns the name of the token.
1559      */
1560     function name() external view returns (string memory);
1561 
1562     /**
1563      * @dev Returns the symbol of the token.
1564      */
1565     function symbol() external view returns (string memory);
1566 
1567     /**
1568      * @dev Returns the decimals places of the token.
1569      */
1570     function decimals() external view returns (uint8);
1571 }
1572 
1573 // File: @openzeppelin/contracts/utils/Context.sol
1574 
1575 
1576 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1577 
1578 pragma solidity ^0.8.0;
1579 
1580 /**
1581  * @dev Provides information about the current execution context, including the
1582  * sender of the transaction and its data. While these are generally available
1583  * via msg.sender and msg.data, they should not be accessed in such a direct
1584  * manner, since when dealing with meta-transactions the account sending and
1585  * paying for execution may not be the actual sender (as far as an application
1586  * is concerned).
1587  *
1588  * This contract is only required for intermediate, library-like contracts.
1589  */
1590 abstract contract Context {
1591     function _msgSender() internal view virtual returns (address) {
1592         return msg.sender;
1593     }
1594 
1595     function _msgData() internal view virtual returns (bytes calldata) {
1596         return msg.data;
1597     }
1598 }
1599 
1600 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1601 
1602 
1603 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
1604 
1605 pragma solidity ^0.8.0;
1606 
1607 
1608 
1609 
1610 /**
1611  * @dev Implementation of the {IERC20} interface.
1612  *
1613  * This implementation is agnostic to the way tokens are created. This means
1614  * that a supply mechanism has to be added in a derived contract using {_mint}.
1615  * For a generic mechanism see {ERC20PresetMinterPauser}.
1616  *
1617  * TIP: For a detailed writeup see our guide
1618  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1619  * to implement supply mechanisms].
1620  *
1621  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1622  * instead returning `false` on failure. This behavior is nonetheless
1623  * conventional and does not conflict with the expectations of ERC20
1624  * applications.
1625  *
1626  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1627  * This allows applications to reconstruct the allowance for all accounts just
1628  * by listening to said events. Other implementations of the EIP may not emit
1629  * these events, as it isn't required by the specification.
1630  *
1631  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1632  * functions have been added to mitigate the well-known issues around setting
1633  * allowances. See {IERC20-approve}.
1634  */
1635 contract ERC20 is Context, IERC20, IERC20Metadata {
1636     mapping(address => uint256) private _balances;
1637 
1638     mapping(address => mapping(address => uint256)) private _allowances;
1639 
1640     uint256 private _totalSupply;
1641 
1642     string private _name;
1643     string private _symbol;
1644 
1645     /**
1646      * @dev Sets the values for {name} and {symbol}.
1647      *
1648      * The default value of {decimals} is 18. To select a different value for
1649      * {decimals} you should overload it.
1650      *
1651      * All two of these values are immutable: they can only be set once during
1652      * construction.
1653      */
1654     constructor(string memory name_, string memory symbol_) {
1655         _name = name_;
1656         _symbol = symbol_;
1657     }
1658 
1659     /**
1660      * @dev Returns the name of the token.
1661      */
1662     function name() public view virtual override returns (string memory) {
1663         return _name;
1664     }
1665 
1666     /**
1667      * @dev Returns the symbol of the token, usually a shorter version of the
1668      * name.
1669      */
1670     function symbol() public view virtual override returns (string memory) {
1671         return _symbol;
1672     }
1673 
1674     /**
1675      * @dev Returns the number of decimals used to get its user representation.
1676      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1677      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1678      *
1679      * Tokens usually opt for a value of 18, imitating the relationship between
1680      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1681      * overridden;
1682      *
1683      * NOTE: This information is only used for _display_ purposes: it in
1684      * no way affects any of the arithmetic of the contract, including
1685      * {IERC20-balanceOf} and {IERC20-transfer}.
1686      */
1687     function decimals() public view virtual override returns (uint8) {
1688         return 18;
1689     }
1690 
1691     /**
1692      * @dev See {IERC20-totalSupply}.
1693      */
1694     function totalSupply() public view virtual override returns (uint256) {
1695         return _totalSupply;
1696     }
1697 
1698     /**
1699      * @dev See {IERC20-balanceOf}.
1700      */
1701     function balanceOf(address account) public view virtual override returns (uint256) {
1702         return _balances[account];
1703     }
1704 
1705     /**
1706      * @dev See {IERC20-transfer}.
1707      *
1708      * Requirements:
1709      *
1710      * - `to` cannot be the zero address.
1711      * - the caller must have a balance of at least `amount`.
1712      */
1713     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1714         address owner = _msgSender();
1715         _transfer(owner, to, amount);
1716         return true;
1717     }
1718 
1719     /**
1720      * @dev See {IERC20-allowance}.
1721      */
1722     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1723         return _allowances[owner][spender];
1724     }
1725 
1726     /**
1727      * @dev See {IERC20-approve}.
1728      *
1729      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1730      * `transferFrom`. This is semantically equivalent to an infinite approval.
1731      *
1732      * Requirements:
1733      *
1734      * - `spender` cannot be the zero address.
1735      */
1736     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1737         address owner = _msgSender();
1738         _approve(owner, spender, amount);
1739         return true;
1740     }
1741 
1742     /**
1743      * @dev See {IERC20-transferFrom}.
1744      *
1745      * Emits an {Approval} event indicating the updated allowance. This is not
1746      * required by the EIP. See the note at the beginning of {ERC20}.
1747      *
1748      * NOTE: Does not update the allowance if the current allowance
1749      * is the maximum `uint256`.
1750      *
1751      * Requirements:
1752      *
1753      * - `from` and `to` cannot be the zero address.
1754      * - `from` must have a balance of at least `amount`.
1755      * - the caller must have allowance for ``from``'s tokens of at least
1756      * `amount`.
1757      */
1758     function transferFrom(
1759         address from,
1760         address to,
1761         uint256 amount
1762     ) public virtual override returns (bool) {
1763         address spender = _msgSender();
1764         _spendAllowance(from, spender, amount);
1765         _transfer(from, to, amount);
1766         return true;
1767     }
1768 
1769     /**
1770      * @dev Atomically increases the allowance granted to `spender` by the caller.
1771      *
1772      * This is an alternative to {approve} that can be used as a mitigation for
1773      * problems described in {IERC20-approve}.
1774      *
1775      * Emits an {Approval} event indicating the updated allowance.
1776      *
1777      * Requirements:
1778      *
1779      * - `spender` cannot be the zero address.
1780      */
1781     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1782         address owner = _msgSender();
1783         _approve(owner, spender, allowance(owner, spender) + addedValue);
1784         return true;
1785     }
1786 
1787     /**
1788      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1789      *
1790      * This is an alternative to {approve} that can be used as a mitigation for
1791      * problems described in {IERC20-approve}.
1792      *
1793      * Emits an {Approval} event indicating the updated allowance.
1794      *
1795      * Requirements:
1796      *
1797      * - `spender` cannot be the zero address.
1798      * - `spender` must have allowance for the caller of at least
1799      * `subtractedValue`.
1800      */
1801     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1802         address owner = _msgSender();
1803         uint256 currentAllowance = allowance(owner, spender);
1804         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1805         unchecked {
1806             _approve(owner, spender, currentAllowance - subtractedValue);
1807         }
1808 
1809         return true;
1810     }
1811 
1812     /**
1813      * @dev Moves `amount` of tokens from `from` to `to`.
1814      *
1815      * This internal function is equivalent to {transfer}, and can be used to
1816      * e.g. implement automatic token fees, slashing mechanisms, etc.
1817      *
1818      * Emits a {Transfer} event.
1819      *
1820      * Requirements:
1821      *
1822      * - `from` cannot be the zero address.
1823      * - `to` cannot be the zero address.
1824      * - `from` must have a balance of at least `amount`.
1825      */
1826     function _transfer(
1827         address from,
1828         address to,
1829         uint256 amount
1830     ) internal virtual {
1831         require(from != address(0), "ERC20: transfer from the zero address");
1832         require(to != address(0), "ERC20: transfer to the zero address");
1833 
1834         _beforeTokenTransfer(from, to, amount);
1835 
1836         uint256 fromBalance = _balances[from];
1837         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1838         unchecked {
1839             _balances[from] = fromBalance - amount;
1840         }
1841         _balances[to] += amount;
1842 
1843         emit Transfer(from, to, amount);
1844 
1845         _afterTokenTransfer(from, to, amount);
1846     }
1847 
1848     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1849      * the total supply.
1850      *
1851      * Emits a {Transfer} event with `from` set to the zero address.
1852      *
1853      * Requirements:
1854      *
1855      * - `account` cannot be the zero address.
1856      */
1857     function _mint(address account, uint256 amount) internal virtual {
1858         require(account != address(0), "ERC20: mint to the zero address");
1859 
1860         _beforeTokenTransfer(address(0), account, amount);
1861 
1862         _totalSupply += amount;
1863         _balances[account] += amount;
1864         emit Transfer(address(0), account, amount);
1865 
1866         _afterTokenTransfer(address(0), account, amount);
1867     }
1868 
1869     /**
1870      * @dev Destroys `amount` tokens from `account`, reducing the
1871      * total supply.
1872      *
1873      * Emits a {Transfer} event with `to` set to the zero address.
1874      *
1875      * Requirements:
1876      *
1877      * - `account` cannot be the zero address.
1878      * - `account` must have at least `amount` tokens.
1879      */
1880     function _burn(address account, uint256 amount) internal virtual {
1881         require(account != address(0), "ERC20: burn from the zero address");
1882 
1883         _beforeTokenTransfer(account, address(0), amount);
1884 
1885         uint256 accountBalance = _balances[account];
1886         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1887         unchecked {
1888             _balances[account] = accountBalance - amount;
1889         }
1890         _totalSupply -= amount;
1891 
1892         emit Transfer(account, address(0), amount);
1893 
1894         _afterTokenTransfer(account, address(0), amount);
1895     }
1896 
1897     /**
1898      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1899      *
1900      * This internal function is equivalent to `approve`, and can be used to
1901      * e.g. set automatic allowances for certain subsystems, etc.
1902      *
1903      * Emits an {Approval} event.
1904      *
1905      * Requirements:
1906      *
1907      * - `owner` cannot be the zero address.
1908      * - `spender` cannot be the zero address.
1909      */
1910     function _approve(
1911         address owner,
1912         address spender,
1913         uint256 amount
1914     ) internal virtual {
1915         require(owner != address(0), "ERC20: approve from the zero address");
1916         require(spender != address(0), "ERC20: approve to the zero address");
1917 
1918         _allowances[owner][spender] = amount;
1919         emit Approval(owner, spender, amount);
1920     }
1921 
1922     /**
1923      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1924      *
1925      * Does not update the allowance amount in case of infinite allowance.
1926      * Revert if not enough allowance is available.
1927      *
1928      * Might emit an {Approval} event.
1929      */
1930     function _spendAllowance(
1931         address owner,
1932         address spender,
1933         uint256 amount
1934     ) internal virtual {
1935         uint256 currentAllowance = allowance(owner, spender);
1936         if (currentAllowance != type(uint256).max) {
1937             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1938             unchecked {
1939                 _approve(owner, spender, currentAllowance - amount);
1940             }
1941         }
1942     }
1943 
1944     /**
1945      * @dev Hook that is called before any transfer of tokens. This includes
1946      * minting and burning.
1947      *
1948      * Calling conditions:
1949      *
1950      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1951      * will be transferred to `to`.
1952      * - when `from` is zero, `amount` tokens will be minted for `to`.
1953      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1954      * - `from` and `to` are never both zero.
1955      *
1956      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1957      */
1958     function _beforeTokenTransfer(
1959         address from,
1960         address to,
1961         uint256 amount
1962     ) internal virtual {}
1963 
1964     /**
1965      * @dev Hook that is called after any transfer of tokens. This includes
1966      * minting and burning.
1967      *
1968      * Calling conditions:
1969      *
1970      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1971      * has been transferred to `to`.
1972      * - when `from` is zero, `amount` tokens have been minted for `to`.
1973      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1974      * - `from` and `to` are never both zero.
1975      *
1976      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1977      */
1978     function _afterTokenTransfer(
1979         address from,
1980         address to,
1981         uint256 amount
1982     ) internal virtual {}
1983 }
1984 
1985 // File: @openzeppelin/contracts/access/Ownable.sol
1986 
1987 
1988 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1989 
1990 pragma solidity ^0.8.0;
1991 
1992 
1993 /**
1994  * @dev Contract module which provides a basic access control mechanism, where
1995  * there is an account (an owner) that can be granted exclusive access to
1996  * specific functions.
1997  *
1998  * By default, the owner account will be the one that deploys the contract. This
1999  * can later be changed with {transferOwnership}.
2000  *
2001  * This module is used through inheritance. It will make available the modifier
2002  * `onlyOwner`, which can be applied to your functions to restrict their use to
2003  * the owner.
2004  */
2005 abstract contract Ownable is Context {
2006     address private _owner;
2007 
2008     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2009 
2010     /**
2011      * @dev Initializes the contract setting the deployer as the initial owner.
2012      */
2013     constructor() {
2014         _transferOwnership(_msgSender());
2015     }
2016 
2017     /**
2018      * @dev Throws if called by any account other than the owner.
2019      */
2020     modifier onlyOwner() {
2021         _checkOwner();
2022         _;
2023     }
2024 
2025     /**
2026      * @dev Returns the address of the current owner.
2027      */
2028     function owner() public view virtual returns (address) {
2029         return _owner;
2030     }
2031 
2032     /**
2033      * @dev Throws if the sender is not the owner.
2034      */
2035     function _checkOwner() internal view virtual {
2036         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2037     }
2038 
2039     /**
2040      * @dev Leaves the contract without owner. It will not be possible to call
2041      * `onlyOwner` functions anymore. Can only be called by the current owner.
2042      *
2043      * NOTE: Renouncing ownership will leave the contract without an owner,
2044      * thereby removing any functionality that is only available to the owner.
2045      */
2046     function renounceOwnership() public virtual onlyOwner {
2047         _transferOwnership(address(0));
2048     }
2049 
2050     /**
2051      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2052      * Can only be called by the current owner.
2053      */
2054     function transferOwnership(address newOwner) public virtual onlyOwner {
2055         require(newOwner != address(0), "Ownable: new owner is the zero address");
2056         _transferOwnership(newOwner);
2057     }
2058 
2059     /**
2060      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2061      * Internal function without access restriction.
2062      */
2063     function _transferOwnership(address newOwner) internal virtual {
2064         address oldOwner = _owner;
2065         _owner = newOwner;
2066         emit OwnershipTransferred(oldOwner, newOwner);
2067     }
2068 }
2069 
2070 // File: @openzeppelin/contracts/utils/Strings.sol
2071 
2072 
2073 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
2074 
2075 pragma solidity ^0.8.0;
2076 
2077 /**
2078  * @dev String operations.
2079  */
2080 library Strings {
2081     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2082     uint8 private constant _ADDRESS_LENGTH = 20;
2083 
2084     /**
2085      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2086      */
2087     function toString(uint256 value) internal pure returns (string memory) {
2088         // Inspired by OraclizeAPI's implementation - MIT licence
2089         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2090 
2091         if (value == 0) {
2092             return "0";
2093         }
2094         uint256 temp = value;
2095         uint256 digits;
2096         while (temp != 0) {
2097             digits++;
2098             temp /= 10;
2099         }
2100         bytes memory buffer = new bytes(digits);
2101         while (value != 0) {
2102             digits -= 1;
2103             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2104             value /= 10;
2105         }
2106         return string(buffer);
2107     }
2108 
2109     /**
2110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2111      */
2112     function toHexString(uint256 value) internal pure returns (string memory) {
2113         if (value == 0) {
2114             return "0x00";
2115         }
2116         uint256 temp = value;
2117         uint256 length = 0;
2118         while (temp != 0) {
2119             length++;
2120             temp >>= 8;
2121         }
2122         return toHexString(value, length);
2123     }
2124 
2125     /**
2126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2127      */
2128     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2129         bytes memory buffer = new bytes(2 * length + 2);
2130         buffer[0] = "0";
2131         buffer[1] = "x";
2132         for (uint256 i = 2 * length + 1; i > 1; --i) {
2133             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2134             value >>= 4;
2135         }
2136         require(value == 0, "Strings: hex length insufficient");
2137         return string(buffer);
2138     }
2139 
2140     /**
2141      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2142      */
2143     function toHexString(address addr) internal pure returns (string memory) {
2144         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2145     }
2146 }
2147 
2148 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2149 
2150 
2151 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
2152 
2153 pragma solidity ^0.8.0;
2154 
2155 
2156 /**
2157  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2158  *
2159  * These functions can be used to verify that a message was signed by the holder
2160  * of the private keys of a given address.
2161  */
2162 library ECDSA {
2163     enum RecoverError {
2164         NoError,
2165         InvalidSignature,
2166         InvalidSignatureLength,
2167         InvalidSignatureS,
2168         InvalidSignatureV
2169     }
2170 
2171     function _throwError(RecoverError error) private pure {
2172         if (error == RecoverError.NoError) {
2173             return; // no error: do nothing
2174         } else if (error == RecoverError.InvalidSignature) {
2175             revert("ECDSA: invalid signature");
2176         } else if (error == RecoverError.InvalidSignatureLength) {
2177             revert("ECDSA: invalid signature length");
2178         } else if (error == RecoverError.InvalidSignatureS) {
2179             revert("ECDSA: invalid signature 's' value");
2180         } else if (error == RecoverError.InvalidSignatureV) {
2181             revert("ECDSA: invalid signature 'v' value");
2182         }
2183     }
2184 
2185     /**
2186      * @dev Returns the address that signed a hashed message (`hash`) with
2187      * `signature` or error string. This address can then be used for verification purposes.
2188      *
2189      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2190      * this function rejects them by requiring the `s` value to be in the lower
2191      * half order, and the `v` value to be either 27 or 28.
2192      *
2193      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2194      * verification to be secure: it is possible to craft signatures that
2195      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2196      * this is by receiving a hash of the original message (which may otherwise
2197      * be too long), and then calling {toEthSignedMessageHash} on it.
2198      *
2199      * Documentation for signature generation:
2200      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
2201      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
2202      *
2203      * _Available since v4.3._
2204      */
2205     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
2206         // Check the signature length
2207         // - case 65: r,s,v signature (standard)
2208         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
2209         if (signature.length == 65) {
2210             bytes32 r;
2211             bytes32 s;
2212             uint8 v;
2213             // ecrecover takes the signature parameters, and the only way to get them
2214             // currently is to use assembly.
2215             /// @solidity memory-safe-assembly
2216             assembly {
2217                 r := mload(add(signature, 0x20))
2218                 s := mload(add(signature, 0x40))
2219                 v := byte(0, mload(add(signature, 0x60)))
2220             }
2221             return tryRecover(hash, v, r, s);
2222         } else if (signature.length == 64) {
2223             bytes32 r;
2224             bytes32 vs;
2225             // ecrecover takes the signature parameters, and the only way to get them
2226             // currently is to use assembly.
2227             /// @solidity memory-safe-assembly
2228             assembly {
2229                 r := mload(add(signature, 0x20))
2230                 vs := mload(add(signature, 0x40))
2231             }
2232             return tryRecover(hash, r, vs);
2233         } else {
2234             return (address(0), RecoverError.InvalidSignatureLength);
2235         }
2236     }
2237 
2238     /**
2239      * @dev Returns the address that signed a hashed message (`hash`) with
2240      * `signature`. This address can then be used for verification purposes.
2241      *
2242      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2243      * this function rejects them by requiring the `s` value to be in the lower
2244      * half order, and the `v` value to be either 27 or 28.
2245      *
2246      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2247      * verification to be secure: it is possible to craft signatures that
2248      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2249      * this is by receiving a hash of the original message (which may otherwise
2250      * be too long), and then calling {toEthSignedMessageHash} on it.
2251      */
2252     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2253         (address recovered, RecoverError error) = tryRecover(hash, signature);
2254         _throwError(error);
2255         return recovered;
2256     }
2257 
2258     /**
2259      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
2260      *
2261      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2262      *
2263      * _Available since v4.3._
2264      */
2265     function tryRecover(
2266         bytes32 hash,
2267         bytes32 r,
2268         bytes32 vs
2269     ) internal pure returns (address, RecoverError) {
2270         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
2271         uint8 v = uint8((uint256(vs) >> 255) + 27);
2272         return tryRecover(hash, v, r, s);
2273     }
2274 
2275     /**
2276      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2277      *
2278      * _Available since v4.2._
2279      */
2280     function recover(
2281         bytes32 hash,
2282         bytes32 r,
2283         bytes32 vs
2284     ) internal pure returns (address) {
2285         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2286         _throwError(error);
2287         return recovered;
2288     }
2289 
2290     /**
2291      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2292      * `r` and `s` signature fields separately.
2293      *
2294      * _Available since v4.3._
2295      */
2296     function tryRecover(
2297         bytes32 hash,
2298         uint8 v,
2299         bytes32 r,
2300         bytes32 s
2301     ) internal pure returns (address, RecoverError) {
2302         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2303         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2304         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2305         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2306         //
2307         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2308         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2309         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2310         // these malleable signatures as well.
2311         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2312             return (address(0), RecoverError.InvalidSignatureS);
2313         }
2314         if (v != 27 && v != 28) {
2315             return (address(0), RecoverError.InvalidSignatureV);
2316         }
2317 
2318         // If the signature is valid (and not malleable), return the signer address
2319         address signer = ecrecover(hash, v, r, s);
2320         if (signer == address(0)) {
2321             return (address(0), RecoverError.InvalidSignature);
2322         }
2323 
2324         return (signer, RecoverError.NoError);
2325     }
2326 
2327     /**
2328      * @dev Overload of {ECDSA-recover} that receives the `v`,
2329      * `r` and `s` signature fields separately.
2330      */
2331     function recover(
2332         bytes32 hash,
2333         uint8 v,
2334         bytes32 r,
2335         bytes32 s
2336     ) internal pure returns (address) {
2337         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2338         _throwError(error);
2339         return recovered;
2340     }
2341 
2342     /**
2343      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2344      * produces hash corresponding to the one signed with the
2345      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2346      * JSON-RPC method as part of EIP-191.
2347      *
2348      * See {recover}.
2349      */
2350     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2351         // 32 is the length in bytes of hash,
2352         // enforced by the type signature above
2353         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2354     }
2355 
2356     /**
2357      * @dev Returns an Ethereum Signed Message, created from `s`. This
2358      * produces hash corresponding to the one signed with the
2359      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2360      * JSON-RPC method as part of EIP-191.
2361      *
2362      * See {recover}.
2363      */
2364     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2365         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
2366     }
2367 
2368     /**
2369      * @dev Returns an Ethereum Signed Typed Data, created from a
2370      * `domainSeparator` and a `structHash`. This produces hash corresponding
2371      * to the one signed with the
2372      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2373      * JSON-RPC method as part of EIP-712.
2374      *
2375      * See {recover}.
2376      */
2377     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2378         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2379     }
2380 }
2381 
2382 // File: contracts/skullki.sol
2383 
2384 
2385 pragma solidity ^0.8.4;
2386 
2387 
2388 
2389 
2390 
2391 
2392 
2393 error ErrorSaleNotStarted();
2394 error ErrorInsufficientFund();
2395 error ErrorExceedTransactionLimit();
2396 error ErrorExceedWalletLimit();
2397 error ErrorExceedMaxSupply();
2398 
2399 contract Skullki is ERC721A, Ownable {
2400     using Address for address payable;
2401     using ECDSA for bytes32;
2402     using Strings for uint256;
2403 
2404     uint256 public immutable MintPrice;
2405     uint32 public immutable MaxSupply;
2406     uint32 public immutable WalletLimit;
2407 
2408     bool public Started;
2409     string public _metadataURI = "";
2410 
2411     constructor(
2412         uint256 mintPrice,
2413         uint32 maxSupply,
2414         uint32 walletLimit
2415     ) ERC721A("Skullki", "SK") {
2416         MintPrice = mintPrice;
2417         MaxSupply = maxSupply;
2418         WalletLimit = walletLimit;
2419 
2420     }
2421 
2422     function mint(uint32 amount) external payable {
2423         if (!Started) revert ErrorSaleNotStarted();
2424         if (amount + _totalMinted() > MaxSupply) revert ErrorExceedMaxSupply();
2425 
2426         uint256 requiredValue = amount * MintPrice;
2427         uint64 userMinted = _getAux(msg.sender);
2428         if (userMinted == 0) requiredValue -= MintPrice;
2429 
2430         userMinted += amount;
2431         _setAux(msg.sender, userMinted);
2432         if (userMinted > WalletLimit) revert ErrorExceedWalletLimit();
2433 
2434         if (msg.value < requiredValue) revert ErrorInsufficientFund();
2435 
2436         _safeMint(msg.sender, amount);
2437     }
2438 
2439     struct State {
2440         uint256 mintPrice;
2441         uint32 walletLimit;
2442         uint32 maxSupply;
2443         uint32 totalMinted;
2444         uint32 userMinted;
2445         bool started;
2446     }
2447 
2448     function _state(address minter) external view returns (State memory) {
2449         return
2450             State({
2451                 mintPrice: MintPrice,
2452                 walletLimit: WalletLimit,
2453                 maxSupply: MaxSupply,
2454                 totalMinted: uint32(ERC721A._totalMinted()),
2455                 userMinted: uint32(_getAux(minter)),
2456                 started: Started
2457             });
2458     }
2459 
2460     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2461         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2462 
2463         string memory baseURI = _metadataURI;
2464         return string(abi.encodePacked(baseURI, tokenId.toString()));
2465     }
2466 
2467 
2468     function setStarted(bool started) external onlyOwner {
2469         Started = started;
2470     }
2471 
2472     function setMetadataURI(string memory uri) external onlyOwner {
2473         _metadataURI = uri;
2474     }
2475 
2476     function withdraw() external onlyOwner {
2477         payable(msg.sender).sendValue(address(this).balance);
2478     }
2479 }