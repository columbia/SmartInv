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
1233 // File: @openzeppelin/contracts/utils/Context.sol
1234 
1235 
1236 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 /**
1241  * @dev Provides information about the current execution context, including the
1242  * sender of the transaction and its data. While these are generally available
1243  * via msg.sender and msg.data, they should not be accessed in such a direct
1244  * manner, since when dealing with meta-transactions the account sending and
1245  * paying for execution may not be the actual sender (as far as an application
1246  * is concerned).
1247  *
1248  * This contract is only required for intermediate, library-like contracts.
1249  */
1250 abstract contract Context {
1251     function _msgSender() internal view virtual returns (address) {
1252         return msg.sender;
1253     }
1254 
1255     function _msgData() internal view virtual returns (bytes calldata) {
1256         return msg.data;
1257     }
1258 }
1259 
1260 // File: @openzeppelin/contracts/access/Ownable.sol
1261 
1262 
1263 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 
1268 /**
1269  * @dev Contract module which provides a basic access control mechanism, where
1270  * there is an account (an owner) that can be granted exclusive access to
1271  * specific functions.
1272  *
1273  * By default, the owner account will be the one that deploys the contract. This
1274  * can later be changed with {transferOwnership}.
1275  *
1276  * This module is used through inheritance. It will make available the modifier
1277  * `onlyOwner`, which can be applied to your functions to restrict their use to
1278  * the owner.
1279  */
1280 abstract contract Ownable is Context {
1281     address private _owner;
1282 
1283     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1284 
1285     /**
1286      * @dev Initializes the contract setting the deployer as the initial owner.
1287      */
1288     constructor() {
1289         _transferOwnership(_msgSender());
1290     }
1291 
1292     /**
1293      * @dev Throws if called by any account other than the owner.
1294      */
1295     modifier onlyOwner() {
1296         _checkOwner();
1297         _;
1298     }
1299 
1300     /**
1301      * @dev Returns the address of the current owner.
1302      */
1303     function owner() public view virtual returns (address) {
1304         return _owner;
1305     }
1306 
1307     /**
1308      * @dev Throws if the sender is not the owner.
1309      */
1310     function _checkOwner() internal view virtual {
1311         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1312     }
1313 
1314     /**
1315      * @dev Leaves the contract without owner. It will not be possible to call
1316      * `onlyOwner` functions anymore. Can only be called by the current owner.
1317      *
1318      * NOTE: Renouncing ownership will leave the contract without an owner,
1319      * thereby removing any functionality that is only available to the owner.
1320      */
1321     function renounceOwnership() public virtual onlyOwner {
1322         _transferOwnership(address(0));
1323     }
1324 
1325     /**
1326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1327      * Can only be called by the current owner.
1328      */
1329     function transferOwnership(address newOwner) public virtual onlyOwner {
1330         require(newOwner != address(0), "Ownable: new owner is the zero address");
1331         _transferOwnership(newOwner);
1332     }
1333 
1334     /**
1335      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1336      * Internal function without access restriction.
1337      */
1338     function _transferOwnership(address newOwner) internal virtual {
1339         address oldOwner = _owner;
1340         _owner = newOwner;
1341         emit OwnershipTransferred(oldOwner, newOwner);
1342     }
1343 }
1344 
1345 // File: @openzeppelin/contracts/utils/Strings.sol
1346 
1347 
1348 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1349 
1350 pragma solidity ^0.8.0;
1351 
1352 /**
1353  * @dev String operations.
1354  */
1355 library Strings {
1356     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1357     uint8 private constant _ADDRESS_LENGTH = 20;
1358 
1359     /**
1360      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1361      */
1362     function toString(uint256 value) internal pure returns (string memory) {
1363         // Inspired by OraclizeAPI's implementation - MIT licence
1364         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1365 
1366         if (value == 0) {
1367             return "0";
1368         }
1369         uint256 temp = value;
1370         uint256 digits;
1371         while (temp != 0) {
1372             digits++;
1373             temp /= 10;
1374         }
1375         bytes memory buffer = new bytes(digits);
1376         while (value != 0) {
1377             digits -= 1;
1378             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1379             value /= 10;
1380         }
1381         return string(buffer);
1382     }
1383 
1384     /**
1385      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1386      */
1387     function toHexString(uint256 value) internal pure returns (string memory) {
1388         if (value == 0) {
1389             return "0x00";
1390         }
1391         uint256 temp = value;
1392         uint256 length = 0;
1393         while (temp != 0) {
1394             length++;
1395             temp >>= 8;
1396         }
1397         return toHexString(value, length);
1398     }
1399 
1400     /**
1401      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1402      */
1403     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1404         bytes memory buffer = new bytes(2 * length + 2);
1405         buffer[0] = "0";
1406         buffer[1] = "x";
1407         for (uint256 i = 2 * length + 1; i > 1; --i) {
1408             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1409             value >>= 4;
1410         }
1411         require(value == 0, "Strings: hex length insufficient");
1412         return string(buffer);
1413     }
1414 
1415     /**
1416      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1417      */
1418     function toHexString(address addr) internal pure returns (string memory) {
1419         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1420     }
1421 }
1422 
1423 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1424 
1425 
1426 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1427 
1428 pragma solidity ^0.8.0;
1429 
1430 /**
1431  * @dev These functions deal with verification of Merkle Tree proofs.
1432  *
1433  * The proofs can be generated using the JavaScript library
1434  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1435  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1436  *
1437  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1438  *
1439  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1440  * hashing, or use a hash function other than keccak256 for hashing leaves.
1441  * This is because the concatenation of a sorted pair of internal nodes in
1442  * the merkle tree could be reinterpreted as a leaf value.
1443  */
1444 library MerkleProof {
1445     /**
1446      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1447      * defined by `root`. For this, a `proof` must be provided, containing
1448      * sibling hashes on the branch from the leaf to the root of the tree. Each
1449      * pair of leaves and each pair of pre-images are assumed to be sorted.
1450      */
1451     function verify(
1452         bytes32[] memory proof,
1453         bytes32 root,
1454         bytes32 leaf
1455     ) internal pure returns (bool) {
1456         return processProof(proof, leaf) == root;
1457     }
1458 
1459     /**
1460      * @dev Calldata version of {verify}
1461      *
1462      * _Available since v4.7._
1463      */
1464     function verifyCalldata(
1465         bytes32[] calldata proof,
1466         bytes32 root,
1467         bytes32 leaf
1468     ) internal pure returns (bool) {
1469         return processProofCalldata(proof, leaf) == root;
1470     }
1471 
1472     /**
1473      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1474      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1475      * hash matches the root of the tree. When processing the proof, the pairs
1476      * of leafs & pre-images are assumed to be sorted.
1477      *
1478      * _Available since v4.4._
1479      */
1480     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1481         bytes32 computedHash = leaf;
1482         for (uint256 i = 0; i < proof.length; i++) {
1483             computedHash = _hashPair(computedHash, proof[i]);
1484         }
1485         return computedHash;
1486     }
1487 
1488     /**
1489      * @dev Calldata version of {processProof}
1490      *
1491      * _Available since v4.7._
1492      */
1493     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1494         bytes32 computedHash = leaf;
1495         for (uint256 i = 0; i < proof.length; i++) {
1496             computedHash = _hashPair(computedHash, proof[i]);
1497         }
1498         return computedHash;
1499     }
1500 
1501     /**
1502      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1503      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1504      *
1505      * _Available since v4.7._
1506      */
1507     function multiProofVerify(
1508         bytes32[] memory proof,
1509         bool[] memory proofFlags,
1510         bytes32 root,
1511         bytes32[] memory leaves
1512     ) internal pure returns (bool) {
1513         return processMultiProof(proof, proofFlags, leaves) == root;
1514     }
1515 
1516     /**
1517      * @dev Calldata version of {multiProofVerify}
1518      *
1519      * _Available since v4.7._
1520      */
1521     function multiProofVerifyCalldata(
1522         bytes32[] calldata proof,
1523         bool[] calldata proofFlags,
1524         bytes32 root,
1525         bytes32[] memory leaves
1526     ) internal pure returns (bool) {
1527         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1528     }
1529 
1530     /**
1531      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1532      * consuming from one or the other at each step according to the instructions given by
1533      * `proofFlags`.
1534      *
1535      * _Available since v4.7._
1536      */
1537     function processMultiProof(
1538         bytes32[] memory proof,
1539         bool[] memory proofFlags,
1540         bytes32[] memory leaves
1541     ) internal pure returns (bytes32 merkleRoot) {
1542         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1543         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1544         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1545         // the merkle tree.
1546         uint256 leavesLen = leaves.length;
1547         uint256 totalHashes = proofFlags.length;
1548 
1549         // Check proof validity.
1550         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1551 
1552         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1553         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1554         bytes32[] memory hashes = new bytes32[](totalHashes);
1555         uint256 leafPos = 0;
1556         uint256 hashPos = 0;
1557         uint256 proofPos = 0;
1558         // At each step, we compute the next hash using two values:
1559         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1560         //   get the next hash.
1561         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1562         //   `proof` array.
1563         for (uint256 i = 0; i < totalHashes; i++) {
1564             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1565             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1566             hashes[i] = _hashPair(a, b);
1567         }
1568 
1569         if (totalHashes > 0) {
1570             return hashes[totalHashes - 1];
1571         } else if (leavesLen > 0) {
1572             return leaves[0];
1573         } else {
1574             return proof[0];
1575         }
1576     }
1577 
1578     /**
1579      * @dev Calldata version of {processMultiProof}
1580      *
1581      * _Available since v4.7._
1582      */
1583     function processMultiProofCalldata(
1584         bytes32[] calldata proof,
1585         bool[] calldata proofFlags,
1586         bytes32[] memory leaves
1587     ) internal pure returns (bytes32 merkleRoot) {
1588         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1589         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1590         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1591         // the merkle tree.
1592         uint256 leavesLen = leaves.length;
1593         uint256 totalHashes = proofFlags.length;
1594 
1595         // Check proof validity.
1596         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1597 
1598         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1599         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1600         bytes32[] memory hashes = new bytes32[](totalHashes);
1601         uint256 leafPos = 0;
1602         uint256 hashPos = 0;
1603         uint256 proofPos = 0;
1604         // At each step, we compute the next hash using two values:
1605         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1606         //   get the next hash.
1607         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1608         //   `proof` array.
1609         for (uint256 i = 0; i < totalHashes; i++) {
1610             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1611             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1612             hashes[i] = _hashPair(a, b);
1613         }
1614 
1615         if (totalHashes > 0) {
1616             return hashes[totalHashes - 1];
1617         } else if (leavesLen > 0) {
1618             return leaves[0];
1619         } else {
1620             return proof[0];
1621         }
1622     }
1623 
1624     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1625         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1626     }
1627 
1628     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1629         /// @solidity memory-safe-assembly
1630         assembly {
1631             mstore(0x00, a)
1632             mstore(0x20, b)
1633             value := keccak256(0x00, 0x40)
1634         }
1635     }
1636 }
1637 
1638 // File: contracts/hello.sol
1639 
1640 
1641 
1642 pragma solidity >=0.8.14;
1643 
1644 
1645 
1646 
1647 
1648 contract KumaBoss is ERC721A, Ownable {
1649       /******Supply******/
1650       uint256 public maxNFTSupply = 5555;
1651 
1652       /******Trx******/
1653       uint256 public maxMintPerTransaction = 1;
1654       uint256 public maxMintPerAccount = 1;
1655 
1656       /******Mint_Prices******/
1657       uint256 public publicMintPrice = 0 ether;
1658       uint256 public whitelistMintPrice = 0 ether;
1659 
1660       /******Time******/
1661       uint64 public publicMintTime;
1662       uint64 public whitelistMintTime;
1663 
1664       /******Others******/
1665       bytes32 public whitelistMerkleRoot;
1666       string public ext = ".json";
1667       bool public publicSwitch = true;
1668       bool public whitelistSwitch = true;
1669       string private _baseTokenURI;
1670       using Strings for uint256;
1671 
1672     constructor() ERC721A("TESTINGGGG", "TB") {}
1673 
1674     function publicMint(uint256 qty) external payable {
1675         require(publicMintTime !=0 &&  block.timestamp >= publicMintTime,"its not time for Public Mint");
1676         require(publicSwitch == true,"Public mint is paused");
1677         require(qty > 0, "Mint qty should be over 0");
1678         require(qty <= maxMintPerTransaction, "Max mint per transaction exceeded");
1679         require(_numberMinted(msg.sender) + qty <= maxMintPerAccount,"you are unable to mint anymore");
1680         require(totalSupply() + qty <= maxNFTSupply, "Reached max supply");
1681         require(msg.value >= publicMintPrice * qty, "Insufficient Funds");
1682 
1683       _safeMint(msg.sender, qty);
1684     }
1685 
1686     function whitelistMint(bytes32[] calldata _merkleProof, uint256 qty) external payable {
1687         require(whitelistSwitch == true,"Whitelist mint have been Paused");
1688         require(qty > 0, "Mint amount should be over 0");
1689         require(_numberMinted(msg.sender) + qty <= maxMintPerAccount,"you are unable to mint anymore");
1690         require(whitelistMintTime !=0 &&  block.timestamp >= whitelistMintTime,"its not time for whitelist");
1691         require(qty <= maxMintPerTransaction, "Max mint per transaction exceeded");
1692         require(whitelistValidity(_merkleProof), "Invalid proof");
1693         require(msg.value >= whitelistMintPrice * qty, "Insufficient Funds");
1694 
1695       _safeMint(msg.sender, qty);
1696     }
1697 
1698     /*****Setters*****/
1699     function setMaxNFTSupply(uint256 _maxNFTSupply) public onlyOwner{
1700       maxNFTSupply = _maxNFTSupply;
1701     }
1702 
1703     function setMaxMintPerTrx(uint256 _maxMintPerTrx) public onlyOwner{
1704       maxMintPerTransaction = _maxMintPerTrx;
1705     }
1706 
1707     function setMaxMintPerAcc(uint256 _maxMintPerAcc) public onlyOwner{
1708       maxMintPerAccount = _maxMintPerAcc;
1709     }
1710 
1711     function setPublicMintPrice(uint256 _publicMintPrice) public onlyOwner{
1712       publicMintPrice = _publicMintPrice;
1713     }
1714 
1715     function setWhitelistMintPrice(uint256 _whitelistMintPrice) public onlyOwner{
1716       whitelistMintPrice = _whitelistMintPrice;
1717     }
1718 
1719     function pausePublicMint() public onlyOwner {
1720       publicSwitch = !publicSwitch; 
1721     }
1722 
1723     function pauseWhitelistMint() public onlyOwner {
1724       whitelistSwitch = !whitelistSwitch; 
1725     }
1726 
1727     function setPublicMintTime(uint32 _publicMintTime) external onlyOwner {
1728       publicMintTime = _publicMintTime;
1729     }
1730 
1731     function setWhitelistMintTIme(uint32 _whitelistMinttime) external onlyOwner {
1732       whitelistMintTime = _whitelistMinttime;
1733     }
1734 
1735     function bossMint( uint256 quantity) payable public onlyOwner {
1736         require(totalSupply() + quantity <= maxNFTSupply);
1737         _safeMint(msg.sender, quantity);
1738     }
1739 
1740     function bossAirdrop( address to, uint256 airdropNum) payable public onlyOwner {
1741       require(totalSupply() + airdropNum <= maxNFTSupply);
1742         _safeMint(to, airdropNum);
1743     }
1744 
1745     function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1746         whitelistMerkleRoot = _whitelistMerkleRoot;
1747     }
1748 
1749     function _baseURI() internal view virtual override returns (string memory) {
1750       return _baseTokenURI;
1751     }
1752     
1753     function setBaseURI(string calldata baseURI) public onlyOwner {
1754       _baseTokenURI = baseURI;
1755     }
1756 
1757     /*****Checkers*****/
1758     function tokenURI(uint256 tokenId)
1759       public
1760       view
1761       virtual
1762       override
1763       returns (string memory)
1764     {
1765       require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1766       string memory currentBaseURI = _baseURI();
1767       return bytes(currentBaseURI).length > 0
1768           ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ext))
1769           : "";
1770     }
1771 
1772     function whitelistValidity(bytes32[] calldata _merkleProof) public view returns (bool){
1773         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1774         require(MerkleProof.verify(_merkleProof, whitelistMerkleRoot, leaf), "Incorrect proof");
1775         return true; 
1776     }
1777 
1778     function amountMinted() public view returns(uint256){
1779       return _numberMinted(msg.sender);
1780     }
1781 
1782     function totalMinted() public view returns(uint256){
1783       return _totalMinted();
1784     }
1785 
1786     function withdraw() public onlyOwner {
1787       payable(msg.sender).transfer(payable(address(this)).balance);   
1788     }
1789 }