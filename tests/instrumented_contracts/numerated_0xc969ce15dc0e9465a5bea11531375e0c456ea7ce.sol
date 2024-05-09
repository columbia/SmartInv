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
1233 // File: @openzeppelin/contracts/utils/Strings.sol
1234 
1235 
1236 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 /**
1241  * @dev String operations.
1242  */
1243 library Strings {
1244     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
1301 }
1302 
1303 // File: @openzeppelin/contracts/utils/Context.sol
1304 
1305 
1306 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1307 
1308 pragma solidity ^0.8.0;
1309 
1310 /**
1311  * @dev Provides information about the current execution context, including the
1312  * sender of the transaction and its data. While these are generally available
1313  * via msg.sender and msg.data, they should not be accessed in such a direct
1314  * manner, since when dealing with meta-transactions the account sending and
1315  * paying for execution may not be the actual sender (as far as an application
1316  * is concerned).
1317  *
1318  * This contract is only required for intermediate, library-like contracts.
1319  */
1320 abstract contract Context {
1321     function _msgSender() internal view virtual returns (address) {
1322         return msg.sender;
1323     }
1324 
1325     function _msgData() internal view virtual returns (bytes calldata) {
1326         return msg.data;
1327     }
1328 }
1329 
1330 // File: @openzeppelin/contracts/access/Ownable.sol
1331 
1332 
1333 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1334 
1335 pragma solidity ^0.8.0;
1336 
1337 
1338 /**
1339  * @dev Contract module which provides a basic access control mechanism, where
1340  * there is an account (an owner) that can be granted exclusive access to
1341  * specific functions.
1342  *
1343  * By default, the owner account will be the one that deploys the contract. This
1344  * can later be changed with {transferOwnership}.
1345  *
1346  * This module is used through inheritance. It will make available the modifier
1347  * `onlyOwner`, which can be applied to your functions to restrict their use to
1348  * the owner.
1349  */
1350 abstract contract Ownable is Context {
1351     address private _owner;
1352 
1353     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1354 
1355     /**
1356      * @dev Initializes the contract setting the deployer as the initial owner.
1357      */
1358     constructor() {
1359         _transferOwnership(_msgSender());
1360     }
1361 
1362     /**
1363      * @dev Returns the address of the current owner.
1364      */
1365     function owner() public view virtual returns (address) {
1366         return _owner;
1367     }
1368 
1369     /**
1370      * @dev Throws if called by any account other than the owner.
1371      */
1372     modifier onlyOwner() {
1373         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1374         _;
1375     }
1376 
1377     /**
1378      * @dev Leaves the contract without owner. It will not be possible to call
1379      * `onlyOwner` functions anymore. Can only be called by the current owner.
1380      *
1381      * NOTE: Renouncing ownership will leave the contract without an owner,
1382      * thereby removing any functionality that is only available to the owner.
1383      */
1384     function renounceOwnership() public virtual onlyOwner {
1385         _transferOwnership(address(0));
1386     }
1387 
1388     /**
1389      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1390      * Can only be called by the current owner.
1391      */
1392     function transferOwnership(address newOwner) public virtual onlyOwner {
1393         require(newOwner != address(0), "Ownable: new owner is the zero address");
1394         _transferOwnership(newOwner);
1395     }
1396 
1397     /**
1398      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1399      * Internal function without access restriction.
1400      */
1401     function _transferOwnership(address newOwner) internal virtual {
1402         address oldOwner = _owner;
1403         _owner = newOwner;
1404         emit OwnershipTransferred(oldOwner, newOwner);
1405     }
1406 }
1407 
1408 // File: @openzeppelin/contracts/utils/Address.sol
1409 
1410 
1411 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1412 
1413 pragma solidity ^0.8.1;
1414 
1415 /**
1416  * @dev Collection of functions related to the address type
1417  */
1418 library Address {
1419     /**
1420      * @dev Returns true if `account` is a contract.
1421      *
1422      * [IMPORTANT]
1423      * ====
1424      * It is unsafe to assume that an address for which this function returns
1425      * false is an externally-owned account (EOA) and not a contract.
1426      *
1427      * Among others, `isContract` will return false for the following
1428      * types of addresses:
1429      *
1430      *  - an externally-owned account
1431      *  - a contract in construction
1432      *  - an address where a contract will be created
1433      *  - an address where a contract lived, but was destroyed
1434      * ====
1435      *
1436      * [IMPORTANT]
1437      * ====
1438      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1439      *
1440      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1441      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1442      * constructor.
1443      * ====
1444      */
1445     function isContract(address account) internal view returns (bool) {
1446         // This method relies on extcodesize/address.code.length, which returns 0
1447         // for contracts in construction, since the code is only stored at the end
1448         // of the constructor execution.
1449 
1450         return account.code.length > 0;
1451     }
1452 
1453     /**
1454      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1455      * `recipient`, forwarding all available gas and reverting on errors.
1456      *
1457      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1458      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1459      * imposed by `transfer`, making them unable to receive funds via
1460      * `transfer`. {sendValue} removes this limitation.
1461      *
1462      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1463      *
1464      * IMPORTANT: because control is transferred to `recipient`, care must be
1465      * taken to not create reentrancy vulnerabilities. Consider using
1466      * {ReentrancyGuard} or the
1467      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1468      */
1469     function sendValue(address payable recipient, uint256 amount) internal {
1470         require(address(this).balance >= amount, "Address: insufficient balance");
1471 
1472         (bool success, ) = recipient.call{value: amount}("");
1473         require(success, "Address: unable to send value, recipient may have reverted");
1474     }
1475 
1476     /**
1477      * @dev Performs a Solidity function call using a low level `call`. A
1478      * plain `call` is an unsafe replacement for a function call: use this
1479      * function instead.
1480      *
1481      * If `target` reverts with a revert reason, it is bubbled up by this
1482      * function (like regular Solidity function calls).
1483      *
1484      * Returns the raw returned data. To convert to the expected return value,
1485      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1486      *
1487      * Requirements:
1488      *
1489      * - `target` must be a contract.
1490      * - calling `target` with `data` must not revert.
1491      *
1492      * _Available since v3.1._
1493      */
1494     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1495         return functionCall(target, data, "Address: low-level call failed");
1496     }
1497 
1498     /**
1499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1500      * `errorMessage` as a fallback revert reason when `target` reverts.
1501      *
1502      * _Available since v3.1._
1503      */
1504     function functionCall(
1505         address target,
1506         bytes memory data,
1507         string memory errorMessage
1508     ) internal returns (bytes memory) {
1509         return functionCallWithValue(target, data, 0, errorMessage);
1510     }
1511 
1512     /**
1513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1514      * but also transferring `value` wei to `target`.
1515      *
1516      * Requirements:
1517      *
1518      * - the calling contract must have an ETH balance of at least `value`.
1519      * - the called Solidity function must be `payable`.
1520      *
1521      * _Available since v3.1._
1522      */
1523     function functionCallWithValue(
1524         address target,
1525         bytes memory data,
1526         uint256 value
1527     ) internal returns (bytes memory) {
1528         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1529     }
1530 
1531     /**
1532      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1533      * with `errorMessage` as a fallback revert reason when `target` reverts.
1534      *
1535      * _Available since v3.1._
1536      */
1537     function functionCallWithValue(
1538         address target,
1539         bytes memory data,
1540         uint256 value,
1541         string memory errorMessage
1542     ) internal returns (bytes memory) {
1543         require(address(this).balance >= value, "Address: insufficient balance for call");
1544         require(isContract(target), "Address: call to non-contract");
1545 
1546         (bool success, bytes memory returndata) = target.call{value: value}(data);
1547         return verifyCallResult(success, returndata, errorMessage);
1548     }
1549 
1550     /**
1551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1552      * but performing a static call.
1553      *
1554      * _Available since v3.3._
1555      */
1556     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1557         return functionStaticCall(target, data, "Address: low-level static call failed");
1558     }
1559 
1560     /**
1561      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1562      * but performing a static call.
1563      *
1564      * _Available since v3.3._
1565      */
1566     function functionStaticCall(
1567         address target,
1568         bytes memory data,
1569         string memory errorMessage
1570     ) internal view returns (bytes memory) {
1571         require(isContract(target), "Address: static call to non-contract");
1572 
1573         (bool success, bytes memory returndata) = target.staticcall(data);
1574         return verifyCallResult(success, returndata, errorMessage);
1575     }
1576 
1577     /**
1578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1579      * but performing a delegate call.
1580      *
1581      * _Available since v3.4._
1582      */
1583     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1584         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1585     }
1586 
1587     /**
1588      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1589      * but performing a delegate call.
1590      *
1591      * _Available since v3.4._
1592      */
1593     function functionDelegateCall(
1594         address target,
1595         bytes memory data,
1596         string memory errorMessage
1597     ) internal returns (bytes memory) {
1598         require(isContract(target), "Address: delegate call to non-contract");
1599 
1600         (bool success, bytes memory returndata) = target.delegatecall(data);
1601         return verifyCallResult(success, returndata, errorMessage);
1602     }
1603 
1604     /**
1605      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1606      * revert reason using the provided one.
1607      *
1608      * _Available since v4.3._
1609      */
1610     function verifyCallResult(
1611         bool success,
1612         bytes memory returndata,
1613         string memory errorMessage
1614     ) internal pure returns (bytes memory) {
1615         if (success) {
1616             return returndata;
1617         } else {
1618             // Look for revert reason and bubble it up if present
1619             if (returndata.length > 0) {
1620                 // The easiest way to bubble the revert reason is using memory via assembly
1621 
1622                 assembly {
1623                     let returndata_size := mload(returndata)
1624                     revert(add(32, returndata), returndata_size)
1625                 }
1626             } else {
1627                 revert(errorMessage);
1628             }
1629         }
1630     }
1631 }
1632 
1633 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1634 
1635 
1636 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1637 
1638 pragma solidity ^0.8.0;
1639 
1640 /**
1641  * @title ERC721 token receiver interface
1642  * @dev Interface for any contract that wants to support safeTransfers
1643  * from ERC721 asset contracts.
1644  */
1645 interface IERC721Receiver {
1646     /**
1647      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1648      * by `operator` from `from`, this function is called.
1649      *
1650      * It must return its Solidity selector to confirm the token transfer.
1651      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1652      *
1653      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1654      */
1655     function onERC721Received(
1656         address operator,
1657         address from,
1658         uint256 tokenId,
1659         bytes calldata data
1660     ) external returns (bytes4);
1661 }
1662 
1663 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1664 
1665 
1666 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1667 
1668 pragma solidity ^0.8.0;
1669 
1670 /**
1671  * @dev Interface of the ERC165 standard, as defined in the
1672  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1673  *
1674  * Implementers can declare support of contract interfaces, which can then be
1675  * queried by others ({ERC165Checker}).
1676  *
1677  * For an implementation, see {ERC165}.
1678  */
1679 interface IERC165 {
1680     /**
1681      * @dev Returns true if this contract implements the interface defined by
1682      * `interfaceId`. See the corresponding
1683      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1684      * to learn more about how these ids are created.
1685      *
1686      * This function call must use less than 30 000 gas.
1687      */
1688     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1689 }
1690 
1691 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1692 
1693 
1694 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1695 
1696 pragma solidity ^0.8.0;
1697 
1698 
1699 /**
1700  * @dev Implementation of the {IERC165} interface.
1701  *
1702  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1703  * for the additional interface id that will be supported. For example:
1704  *
1705  * ```solidity
1706  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1707  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1708  * }
1709  * ```
1710  *
1711  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1712  */
1713 abstract contract ERC165 is IERC165 {
1714     /**
1715      * @dev See {IERC165-supportsInterface}.
1716      */
1717     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1718         return interfaceId == type(IERC165).interfaceId;
1719     }
1720 }
1721 
1722 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1723 
1724 
1725 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1726 
1727 pragma solidity ^0.8.0;
1728 
1729 
1730 /**
1731  * @dev Required interface of an ERC721 compliant contract.
1732  */
1733 interface IERC721 is IERC165 {
1734     /**
1735      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1736      */
1737     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1738 
1739     /**
1740      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1741      */
1742     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1743 
1744     /**
1745      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1746      */
1747     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1748 
1749     /**
1750      * @dev Returns the number of tokens in ``owner``'s account.
1751      */
1752     function balanceOf(address owner) external view returns (uint256 balance);
1753 
1754     /**
1755      * @dev Returns the owner of the `tokenId` token.
1756      *
1757      * Requirements:
1758      *
1759      * - `tokenId` must exist.
1760      */
1761     function ownerOf(uint256 tokenId) external view returns (address owner);
1762 
1763     /**
1764      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1765      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1766      *
1767      * Requirements:
1768      *
1769      * - `from` cannot be the zero address.
1770      * - `to` cannot be the zero address.
1771      * - `tokenId` token must exist and be owned by `from`.
1772      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1773      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1774      *
1775      * Emits a {Transfer} event.
1776      */
1777     function safeTransferFrom(
1778         address from,
1779         address to,
1780         uint256 tokenId
1781     ) external;
1782 
1783     /**
1784      * @dev Transfers `tokenId` token from `from` to `to`.
1785      *
1786      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1787      *
1788      * Requirements:
1789      *
1790      * - `from` cannot be the zero address.
1791      * - `to` cannot be the zero address.
1792      * - `tokenId` token must be owned by `from`.
1793      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1794      *
1795      * Emits a {Transfer} event.
1796      */
1797     function transferFrom(
1798         address from,
1799         address to,
1800         uint256 tokenId
1801     ) external;
1802 
1803     /**
1804      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1805      * The approval is cleared when the token is transferred.
1806      *
1807      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1808      *
1809      * Requirements:
1810      *
1811      * - The caller must own the token or be an approved operator.
1812      * - `tokenId` must exist.
1813      *
1814      * Emits an {Approval} event.
1815      */
1816     function approve(address to, uint256 tokenId) external;
1817 
1818     /**
1819      * @dev Returns the account approved for `tokenId` token.
1820      *
1821      * Requirements:
1822      *
1823      * - `tokenId` must exist.
1824      */
1825     function getApproved(uint256 tokenId) external view returns (address operator);
1826 
1827     /**
1828      * @dev Approve or remove `operator` as an operator for the caller.
1829      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1830      *
1831      * Requirements:
1832      *
1833      * - The `operator` cannot be the caller.
1834      *
1835      * Emits an {ApprovalForAll} event.
1836      */
1837     function setApprovalForAll(address operator, bool _approved) external;
1838 
1839     /**
1840      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1841      *
1842      * See {setApprovalForAll}
1843      */
1844     function isApprovedForAll(address owner, address operator) external view returns (bool);
1845 
1846     /**
1847      * @dev Safely transfers `tokenId` token from `from` to `to`.
1848      *
1849      * Requirements:
1850      *
1851      * - `from` cannot be the zero address.
1852      * - `to` cannot be the zero address.
1853      * - `tokenId` token must exist and be owned by `from`.
1854      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1855      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1856      *
1857      * Emits a {Transfer} event.
1858      */
1859     function safeTransferFrom(
1860         address from,
1861         address to,
1862         uint256 tokenId,
1863         bytes calldata data
1864     ) external;
1865 }
1866 
1867 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1868 
1869 
1870 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1871 
1872 pragma solidity ^0.8.0;
1873 
1874 
1875 /**
1876  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1877  * @dev See https://eips.ethereum.org/EIPS/eip-721
1878  */
1879 interface IERC721Metadata is IERC721 {
1880     /**
1881      * @dev Returns the token collection name.
1882      */
1883     function name() external view returns (string memory);
1884 
1885     /**
1886      * @dev Returns the token collection symbol.
1887      */
1888     function symbol() external view returns (string memory);
1889 
1890     /**
1891      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1892      */
1893     function tokenURI(uint256 tokenId) external view returns (string memory);
1894 }
1895 
1896 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1897 
1898 
1899 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1900 
1901 pragma solidity ^0.8.0;
1902 
1903 
1904 
1905 
1906 
1907 
1908 
1909 
1910 /**
1911  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1912  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1913  * {ERC721Enumerable}.
1914  */
1915 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1916     using Address for address;
1917     using Strings for uint256;
1918 
1919     // Token name
1920     string private _name;
1921 
1922     // Token symbol
1923     string private _symbol;
1924 
1925     // Mapping from token ID to owner address
1926     mapping(uint256 => address) private _owners;
1927 
1928     // Mapping owner address to token count
1929     mapping(address => uint256) private _balances;
1930 
1931     // Mapping from token ID to approved address
1932     mapping(uint256 => address) private _tokenApprovals;
1933 
1934     // Mapping from owner to operator approvals
1935     mapping(address => mapping(address => bool)) private _operatorApprovals;
1936 
1937     /**
1938      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1939      */
1940     constructor(string memory name_, string memory symbol_) {
1941         _name = name_;
1942         _symbol = symbol_;
1943     }
1944 
1945     /**
1946      * @dev See {IERC165-supportsInterface}.
1947      */
1948     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1949         return
1950             interfaceId == type(IERC721).interfaceId ||
1951             interfaceId == type(IERC721Metadata).interfaceId ||
1952             super.supportsInterface(interfaceId);
1953     }
1954 
1955     /**
1956      * @dev See {IERC721-balanceOf}.
1957      */
1958     function balanceOf(address owner) public view virtual override returns (uint256) {
1959         require(owner != address(0), "ERC721: balance query for the zero address");
1960         return _balances[owner];
1961     }
1962 
1963     /**
1964      * @dev See {IERC721-ownerOf}.
1965      */
1966     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1967         address owner = _owners[tokenId];
1968         require(owner != address(0), "ERC721: owner query for nonexistent token");
1969         return owner;
1970     }
1971 
1972     /**
1973      * @dev See {IERC721Metadata-name}.
1974      */
1975     function name() public view virtual override returns (string memory) {
1976         return _name;
1977     }
1978 
1979     /**
1980      * @dev See {IERC721Metadata-symbol}.
1981      */
1982     function symbol() public view virtual override returns (string memory) {
1983         return _symbol;
1984     }
1985 
1986     /**
1987      * @dev See {IERC721Metadata-tokenURI}.
1988      */
1989     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1990         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1991 
1992         string memory baseURI = _baseURI();
1993         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1994     }
1995 
1996     /**
1997      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1998      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1999      * by default, can be overriden in child contracts.
2000      */
2001     function _baseURI() internal view virtual returns (string memory) {
2002         return "";
2003     }
2004 
2005     /**
2006      * @dev See {IERC721-approve}.
2007      */
2008     function approve(address to, uint256 tokenId) public virtual override {
2009         address owner = ERC721.ownerOf(tokenId);
2010         require(to != owner, "ERC721: approval to current owner");
2011 
2012         require(
2013             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2014             "ERC721: approve caller is not owner nor approved for all"
2015         );
2016 
2017         _approve(to, tokenId);
2018     }
2019 
2020     /**
2021      * @dev See {IERC721-getApproved}.
2022      */
2023     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2024         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2025 
2026         return _tokenApprovals[tokenId];
2027     }
2028 
2029     /**
2030      * @dev See {IERC721-setApprovalForAll}.
2031      */
2032     function setApprovalForAll(address operator, bool approved) public virtual override {
2033         _setApprovalForAll(_msgSender(), operator, approved);
2034     }
2035 
2036     /**
2037      * @dev See {IERC721-isApprovedForAll}.
2038      */
2039     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2040         return _operatorApprovals[owner][operator];
2041     }
2042 
2043     /**
2044      * @dev See {IERC721-transferFrom}.
2045      */
2046     function transferFrom(
2047         address from,
2048         address to,
2049         uint256 tokenId
2050     ) public virtual override {
2051         //solhint-disable-next-line max-line-length
2052         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2053 
2054         _transfer(from, to, tokenId);
2055     }
2056 
2057     /**
2058      * @dev See {IERC721-safeTransferFrom}.
2059      */
2060     function safeTransferFrom(
2061         address from,
2062         address to,
2063         uint256 tokenId
2064     ) public virtual override {
2065         safeTransferFrom(from, to, tokenId, "");
2066     }
2067 
2068     /**
2069      * @dev See {IERC721-safeTransferFrom}.
2070      */
2071     function safeTransferFrom(
2072         address from,
2073         address to,
2074         uint256 tokenId,
2075         bytes memory _data
2076     ) public virtual override {
2077         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2078         _safeTransfer(from, to, tokenId, _data);
2079     }
2080 
2081     /**
2082      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2083      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2084      *
2085      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2086      *
2087      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2088      * implement alternative mechanisms to perform token transfer, such as signature-based.
2089      *
2090      * Requirements:
2091      *
2092      * - `from` cannot be the zero address.
2093      * - `to` cannot be the zero address.
2094      * - `tokenId` token must exist and be owned by `from`.
2095      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2096      *
2097      * Emits a {Transfer} event.
2098      */
2099     function _safeTransfer(
2100         address from,
2101         address to,
2102         uint256 tokenId,
2103         bytes memory _data
2104     ) internal virtual {
2105         _transfer(from, to, tokenId);
2106         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2107     }
2108 
2109     /**
2110      * @dev Returns whether `tokenId` exists.
2111      *
2112      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2113      *
2114      * Tokens start existing when they are minted (`_mint`),
2115      * and stop existing when they are burned (`_burn`).
2116      */
2117     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2118         return _owners[tokenId] != address(0);
2119     }
2120 
2121     /**
2122      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2123      *
2124      * Requirements:
2125      *
2126      * - `tokenId` must exist.
2127      */
2128     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2129         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2130         address owner = ERC721.ownerOf(tokenId);
2131         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2132     }
2133 
2134     /**
2135      * @dev Safely mints `tokenId` and transfers it to `to`.
2136      *
2137      * Requirements:
2138      *
2139      * - `tokenId` must not exist.
2140      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2141      *
2142      * Emits a {Transfer} event.
2143      */
2144     function _safeMint(address to, uint256 tokenId) internal virtual {
2145         _safeMint(to, tokenId, "");
2146     }
2147 
2148     /**
2149      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2150      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2151      */
2152     function _safeMint(
2153         address to,
2154         uint256 tokenId,
2155         bytes memory _data
2156     ) internal virtual {
2157         _mint(to, tokenId);
2158         require(
2159             _checkOnERC721Received(address(0), to, tokenId, _data),
2160             "ERC721: transfer to non ERC721Receiver implementer"
2161         );
2162     }
2163 
2164     /**
2165      * @dev Mints `tokenId` and transfers it to `to`.
2166      *
2167      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2168      *
2169      * Requirements:
2170      *
2171      * - `tokenId` must not exist.
2172      * - `to` cannot be the zero address.
2173      *
2174      * Emits a {Transfer} event.
2175      */
2176     function _mint(address to, uint256 tokenId) internal virtual {
2177         require(to != address(0), "ERC721: mint to the zero address");
2178         require(!_exists(tokenId), "ERC721: token already minted");
2179 
2180         _beforeTokenTransfer(address(0), to, tokenId);
2181 
2182         _balances[to] += 1;
2183         _owners[tokenId] = to;
2184 
2185         emit Transfer(address(0), to, tokenId);
2186 
2187         _afterTokenTransfer(address(0), to, tokenId);
2188     }
2189 
2190     /**
2191      * @dev Destroys `tokenId`.
2192      * The approval is cleared when the token is burned.
2193      *
2194      * Requirements:
2195      *
2196      * - `tokenId` must exist.
2197      *
2198      * Emits a {Transfer} event.
2199      */
2200     function _burn(uint256 tokenId) internal virtual {
2201         address owner = ERC721.ownerOf(tokenId);
2202 
2203         _beforeTokenTransfer(owner, address(0), tokenId);
2204 
2205         // Clear approvals
2206         _approve(address(0), tokenId);
2207 
2208         _balances[owner] -= 1;
2209         delete _owners[tokenId];
2210 
2211         emit Transfer(owner, address(0), tokenId);
2212 
2213         _afterTokenTransfer(owner, address(0), tokenId);
2214     }
2215 
2216     /**
2217      * @dev Transfers `tokenId` from `from` to `to`.
2218      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2219      *
2220      * Requirements:
2221      *
2222      * - `to` cannot be the zero address.
2223      * - `tokenId` token must be owned by `from`.
2224      *
2225      * Emits a {Transfer} event.
2226      */
2227     function _transfer(
2228         address from,
2229         address to,
2230         uint256 tokenId
2231     ) internal virtual {
2232         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2233         require(to != address(0), "ERC721: transfer to the zero address");
2234 
2235         _beforeTokenTransfer(from, to, tokenId);
2236 
2237         // Clear approvals from the previous owner
2238         _approve(address(0), tokenId);
2239 
2240         _balances[from] -= 1;
2241         _balances[to] += 1;
2242         _owners[tokenId] = to;
2243 
2244         emit Transfer(from, to, tokenId);
2245 
2246         _afterTokenTransfer(from, to, tokenId);
2247     }
2248 
2249     /**
2250      * @dev Approve `to` to operate on `tokenId`
2251      *
2252      * Emits a {Approval} event.
2253      */
2254     function _approve(address to, uint256 tokenId) internal virtual {
2255         _tokenApprovals[tokenId] = to;
2256         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2257     }
2258 
2259     /**
2260      * @dev Approve `operator` to operate on all of `owner` tokens
2261      *
2262      * Emits a {ApprovalForAll} event.
2263      */
2264     function _setApprovalForAll(
2265         address owner,
2266         address operator,
2267         bool approved
2268     ) internal virtual {
2269         require(owner != operator, "ERC721: approve to caller");
2270         _operatorApprovals[owner][operator] = approved;
2271         emit ApprovalForAll(owner, operator, approved);
2272     }
2273 
2274     /**
2275      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2276      * The call is not executed if the target address is not a contract.
2277      *
2278      * @param from address representing the previous owner of the given token ID
2279      * @param to target address that will receive the tokens
2280      * @param tokenId uint256 ID of the token to be transferred
2281      * @param _data bytes optional data to send along with the call
2282      * @return bool whether the call correctly returned the expected magic value
2283      */
2284     function _checkOnERC721Received(
2285         address from,
2286         address to,
2287         uint256 tokenId,
2288         bytes memory _data
2289     ) private returns (bool) {
2290         if (to.isContract()) {
2291             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2292                 return retval == IERC721Receiver.onERC721Received.selector;
2293             } catch (bytes memory reason) {
2294                 if (reason.length == 0) {
2295                     revert("ERC721: transfer to non ERC721Receiver implementer");
2296                 } else {
2297                     assembly {
2298                         revert(add(32, reason), mload(reason))
2299                     }
2300                 }
2301             }
2302         } else {
2303             return true;
2304         }
2305     }
2306 
2307     /**
2308      * @dev Hook that is called before any token transfer. This includes minting
2309      * and burning.
2310      *
2311      * Calling conditions:
2312      *
2313      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2314      * transferred to `to`.
2315      * - When `from` is zero, `tokenId` will be minted for `to`.
2316      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2317      * - `from` and `to` are never both zero.
2318      *
2319      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2320      */
2321     function _beforeTokenTransfer(
2322         address from,
2323         address to,
2324         uint256 tokenId
2325     ) internal virtual {}
2326 
2327     /**
2328      * @dev Hook that is called after any transfer of tokens. This includes
2329      * minting and burning.
2330      *
2331      * Calling conditions:
2332      *
2333      * - when `from` and `to` are both non-zero.
2334      * - `from` and `to` are never both zero.
2335      *
2336      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2337      */
2338     function _afterTokenTransfer(
2339         address from,
2340         address to,
2341         uint256 tokenId
2342     ) internal virtual {}
2343 }
2344 
2345 // File: contracts/SuperIceCreamParty.sol
2346 
2347 
2348 pragma solidity ^0.8.0;
2349 
2350 
2351 
2352 
2353 /*
2354 lloooddxxxkkkkkkkkkkkOOOOOO00000000KKXXXKKKXNXKXK0KKK0KXXK00000000000000OOkkkOOkkkxxxxxxxxxxdddoooll
2355 ooodxxxxxxkkkkkkkkkOOO0KKK00KKKXXXXKXXXXXXXNNXXNXXXXXXXNNXXXKKKKKKKKKXXXK000000OOOkkkkkkxxxxxddddooo
2356 ooddxxxxxxkkkkOOOOOOO0KXNNXXNXXNNNNXXNNNNNNNNNNNNNNNNXNNNNNNXXXXXXXXNNNNXXKKK00000OOOOOOOkkxxddddddd
2357 ddddxxxkkkkkkOO00OO00KKXNNNNNNNNNNNNNNWWNNNNNNWWWWWWNNNNNNNNNNNNXXNNNNNNNNNXKKXXKK0O000OOOkxxxxddddd
2358 ddddxxxkkOO0OO00KKKKXXXXNNWNNWWWWWWWNNWWWWWWNXOdlloox0NWWWWWNNNNNNNNNNNNNNNXXNXXXKKKKK0OOOkkxxxxxddd
2359 dxxxxxkkOO00KKKKKXNNNNNNNWWWWWWWWWWWWWWWWWWWO;.      .;dKWWWWWWWWWWWWWNWNNNNNNXXXXXXXKK0OOOOkkxxxxxx
2360 dxxxxkkkOO00KXXXXXNNNNWWWWWWWWWWWWWWWWWWWWWNo..dkc..    'xXWWWWWWWWWWWWWWNNNNNNNNNNNXXXKKKK0Okxxxxxx
2361 xxxxkkkOOO00KXNNNNNNWWWWWWWWWWWWWWWWWWWWWWWWXdd0Oc..      :0WWWWWWWWWWWWWWWWNNWNNNNNNNNNNXK0Okkkkxxx
2362 xxkkkOO000KKXXNNNNNWWWWWWWWWWWWWWWWWWWWWN0kdc;'..          ,OWWWWWWWWWWWWWWWWWWWWWWWWWNNNXXKKK00Okxx
2363 kkkkOOO0KKKXXNNNNNWWWWWWWWWWWWWWWWWWWW0o'.                  ,0WWWWWWWWWWWWWWWWWWWWWWWWNNNNNNXXKOkkxx
2364 xkkkOO0KXXXXXNNNNNWWWWWWWWWWWWWWWWWWWO'                      lXWWWWWWWWWWWWWWWWWWWWWWWWWWNNNXK0Okkxx
2365 kkkOOO0KKXNNNNNNNWWWWWWWWWWWWWWWWWWMNc                        'o0WWWWWWWWWWWWWWWWWWWWWWWWNNX0OOkkkkx
2366 OO0000KKKXNNNWWWWWWWWWWWWWWWWWWWWMMMNl                          .dNWWWWWWWWWWWWWWWWWWWWWNNXXKK0OOkkx
2367 OO00KXXXXNNNWWWWWWWWWWWWWWWWWWWMMMMWNx.                          .oNWWWWWWWWWWWWWWWWWWWNNNNNXXK0OOkk
2368 OOO0KXNNNNNWWWWWWWWWWWWWWWWWWWMMMNOc,.                            '0MWWWWWWWWWWWWWWWWWWNNNNNXKK0OOkk
2369 OO00KXNNNWWWWWWWWWWWWWWWWWWWWMMMKc.                               .OMMMWWWWWWWWWWWWWWWWWWNNXKKK00OOk
2370 OO0KKXXNNNWWWWWWWWWWWWWWWMMMMMMNl                                 :XMMMMWWWWWWWWWWWWWWWWWWNNXXXK00OO
2371 000KKXNNNWWWWWWWWWWWWWWWMMMMMMMK,                                 lXMMMMMWWWWWWWWWWWWWWWWWNNNXXK00OO
2372 KKKXXNNWWWWWWWWWWWWWWWWWMMMMMMMX:                                  ;0WMMMMMWWWWWWWWWWWWWWWNNNNXXKK0O
2373 0KKXNNNWWWWWWWWWWWWWWWWWMMMMMMMWO,              .;clddo:.           :XMMMMMMWWWWWWWWWWWWWWWWNNNNNXXK
2374 KKXXNNWWWWWWWWWWWWWWWWMMMMMMMMMMNx.           ,xKWMWKKNWXl.         .OMMMMMMWWWWWWWWWWWWWWWWWWWNNNNX
2375 0KXNNWWWWWWWWWWWWWWWWWMMMMMMMMW0c.          .xNMXxc;..cXMK;         ;KMMMMMMMWWWWWWWWWWWWWWWWWNNNNNX
2376 KKXNNWWWWWWWWWWWWWWWWMMMMMMMMM0,           ,OWW0;     :XMX;        ;OWMMMMMMMWWWWWWWWWWWWWWWWWWNNNNX
2377 XXNNNWWWWWWWWWWWWWWWWMMMMMMMMNl           'OMM0'     :KMWd.        :KWMMMMMMMMWWWWWWWWWWWWWWWWWWNNXX
2378 XNNWWWWWWWWWWWWWWWWWWMMMMMMMMN:           lNMNc    .dNMNo.          'OWMMMMMMWWWWWWWWWWWWWWWWWWWNNNX
2379 XXNNWWWWWWWWWWWWWWWWWMMMMMMMMWo           .dKO, .cx0WW0:             lNMMMMMMWWWWWWWWWWWWWWWWWWNNNXX
2380 XNNWWWWWWWWWWWWWWWWWWWMMMMMMMMXc            .. ,kNMWKl.             ,0WMMMMMMWWWWWWWWWWWWWWWWWNNXXKK
2381 XXNNNWWWWWWWWWWWWWWWWWMMMMMMMMM0;             cKMNKd'              ,OMMMMMMMMWWWWWWWWWWWWWWWWWWNNXK0
2382 XNNNNWWWWWWWWWWWWWWWWWWMMMMMMMMW0,           cXWO;.               'OWMMMMMMMMWWWWWWWWWWWWWWWWWWNXXKK
2383 KXNNNNNWWWWWWWWWWWWWWWWWMMMMMMMMX:          .kMO'                 ;KMMMMMMMMWWWWWWWWWWWWWWWWWNNNXKK0
2384 O0KXXNNNNWWWWWWWWWWWWWWWWMMMMMMMNc          .lXk.                 :XMMMMMMMWWWWWWWWWWWWWWWWWWNNXXKKK
2385 OO0KKXXNNNWWWWWWWWWWWWWWWWMMMMMMWo           .:c.                 lNMMMMMMMWWWWWWWWWWWWWWWWNNNXKK000
2386 OO00KXXXNNWWWWWWWWWWWWWWWWWMMMMMM0,         ,OXXl                'OMMMMMWWWWWWWWWWWWWWWWWWNNNXXKK0OO
2387 kOO0KKKKXNNWWWWWWWWWWWWWWWWWWMMMMWO'       .dWMWo               .kWMMMWWWWWWWWWWWWWWWWWWWWWNNNXK00OO
2388 kkOO00KXNNNNNWWWWWWWWWWWWWWWWWWMMMWk.       .co:.              .kWMMMWWWWWWWWWWWWWWWWWWWWWNNNNXK0OOO
2389 kkOO0KXXNNNNNWWWWWWWWWWWWWWWWWWMWMMKl.                        .c0WMWWWWWWWWWWWWWWWWWWWWNNNNNXXKK00Ok
2390 xkkOO0KKXXNNWWWWWWWWWWWWWWWWWWWWWWMMWk.                      .xWWWWWWWWWWWWWWWWWWWWWWWWNNNXKKK0000OO
2391 xxkkkOO0KXNWWWWWWWWWWWWWWWWWWWWWWWWWMK,                      ,0MWWWWWWWWWWWWWWWWWWWNNNNNNNXK00OOOkkk
2392 xxxkkOKXNNNWWWWWWWWWWWWWWWWWWWWWWWWWWNc                      :XWWWWWWWWWWWWWWWWWWWNNNNNXXXXXK0OOkkkx
2393 xxkkOKXXNNNNNWWWWWWWWWWWWWWWWWWWWWWWWWx.                    .dWWWWWWWWWWWWWWWWWWWWNNNNNXXKKK00OOkkkk
2394 xxkkO0KKKXNNNNWWWWWWWWWWWWWWWWWWWWWWWWO'                    .kWWWWWWWWWWWWWWWWWWWNNNNNXXKK000OOkkkxx
2395 xxxkkkOO0KXNNNNNNNNNWWWNNWWWWWWWWWWWWWX;                    ;KWWWWWWWWWWWWWWWWWWNNNNNXXK00OOOOkkxxxx
2396 xxxxxxkO0KKKKXXXNNNNNNNNNNNWWWWWWWWWWWNo                    lNWWWWWWWWWWWWWWWWWNNNXXXXXK00OOkkkxxxxd
2397 xxxxxxkkOOOO0KKXXXXXXXNNNNNNNWWWWWWWWWWx.                  .xWWWWWWWWWWWWNNNNNNNNNXKKKKK00OOkkxxxxxd
2398 ddddxxxxkkOOO0KKKKKXXXNXXNNNNNNNNNNNNNW0,                  'OWNNWWWWWWWNNNNNNXXXKKKK000000Okkxxxdddd
2399 dddddxxxxkOOO00000KKKXXKXNNNNNNNNNXXNXX0:                  ;0NNNNNNNNNNNNNNNXKK00OO00OOkkkkkkxxxdddd
2400 dddddddxxkkOOOOOOO00000KKXXNNNNNXXKK0Okkc.                .:kO00KNNNNXXNXXNNXK0OOOOOOOkkkkxxxxxxddoo
2401 oooddddxxxxxkkkkkkOOO00000KKXXXKKKKKOkxxxoc:;;,,,,',,,;;:clxkOO00KXXXKKKK0KKK00OOOkkkkkkkkxxxxxdddoo
2402 llooodddxxxxxxxxxxkkkOOOOOOO000000000OOOOOOO0OkOOkkkOOO00OO00KKKK00000000OOOOOOkkkkkkkkkkxxxxdddoool
2403 :cccllloooooooooooooddddddddxxdxxxxxxxxxxxkkkkxkkxxkkkkOOOkkOOOOkkxxxxxxxxxxxxxdddddddddddooollccccc
2404 */
2405 contract SuperIceCreamParty is ERC721A, Ownable {
2406 
2407     enum SaleStatus { NONE, PRIVATE, PUBLIC, UNLIMITED }
2408 
2409     string private _baseTokenURI;
2410     string private _prerevealURI;
2411     bool private revealed = false;
2412     uint256 public MAX_TOKENS = 10000;
2413     uint256 public constant MAX_TOKENS_FOR_TEAM = 100;
2414     uint256 public constant MAX_TOKENS_PER_PRIVATE_MINT = 20;
2415     uint256 public constant MAX_TOKENS_PER_PUBLIC_MINT = 20;
2416     uint256 public privatePrice = 0.000 ether;  // FREE!
2417     uint256 public publicPrice = 0.000 ether;  // FREE!
2418     uint256 public unlimitedPrice = 0.001 ether;  // AYCE!
2419     SaleStatus public saleStatus = SaleStatus.NONE;
2420     mapping(address => uint) public privateAllowList;
2421     mapping(address => uint) public privateMintCounts;
2422     mapping(address => uint) public publicMintCounts;
2423 
2424     constructor() ERC721A("Super Ice Cream Party", "ICECREAM") {
2425         _prerevealURI = "ipfs://bafybeicp2suolib2uphtn67mkkr5bgsbzydttbknwppmt33pvoxikusp5m";
2426         reserve();
2427     }
2428 
2429     modifier tryBlockContract() {
2430         require(tx.origin == msg.sender, "contracts cannot call this contract");
2431         _;
2432     }
2433 
2434     modifier canMint(uint _amount) {
2435         require(saleStatus != SaleStatus.NONE, "sale is not active");
2436         require(_amount > 0, "must mint at least one token");
2437         require(totalSupply() + _amount <= MAX_TOKENS, "minting would exceed max supply");
2438         _;
2439     }
2440 
2441     function _baseURI() internal view override returns (string memory) {
2442         return _baseTokenURI;
2443     }
2444 
2445     function setBaseURI(string calldata base) external onlyOwner {
2446         _baseTokenURI = base;
2447     }
2448 
2449     function setPrerevealURI(string calldata base) external onlyOwner {
2450         _prerevealURI = base;
2451     }
2452 
2453     function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
2454         if (!super._exists(tokenId)) revert URIQueryForNonexistentToken();
2455         if(!revealed) return _prerevealURI;
2456         return super.tokenURI(tokenId);
2457     }
2458 
2459     function reveal() external onlyOwner {
2460         revealed = true;
2461     }
2462 
2463     function setSaleStatus(SaleStatus targetSaleStatus) external onlyOwner {
2464         saleStatus = targetSaleStatus;
2465     }
2466 
2467     function setPrivateAllowList(address[] calldata addresses, uint[] calldata amount) external onlyOwner {
2468         for (uint256 i = 0; i < addresses.length; i++) {
2469             require(amount[i] <= MAX_TOKENS_PER_PRIVATE_MINT, "amount would exceed max allowed");
2470             privateAllowList[addresses[i]] = amount[i];
2471         }
2472     }
2473 
2474     // in case of unforseen event
2475     function removePrivateAllowList(address[] calldata addresses) external onlyOwner {
2476         for (uint256 i = 0; i < addresses.length; i++) {
2477             delete privateAllowList[addresses[i]];
2478         }
2479     }
2480 
2481     // in case of unforeseen event
2482     function setPrice(uint _publicPrice, uint _unlimitedPrice) public onlyOwner {
2483         publicPrice = _publicPrice;
2484         unlimitedPrice = _unlimitedPrice;
2485     }
2486 
2487     function reserve() private onlyOwner {
2488         require(totalSupply() < MAX_TOKENS_FOR_TEAM, "reserve tokens already minted");
2489 
2490         _safeMint(msg.sender, MAX_TOKENS_FOR_TEAM);
2491     }
2492 
2493     function privateMint(uint _amount) public payable canMint(_amount) tryBlockContract {
2494         require(saleStatus == SaleStatus.PRIVATE,  "private mint not active");
2495         uint allowed = privateAllowList[msg.sender];
2496         require(allowed > 0, "not in allowlist");
2497         require(_amount <= allowed, "minting exceeds allowlist limit");
2498         require(privateMintCounts[msg.sender] + _amount <= MAX_TOKENS_PER_PRIVATE_MINT, "minting exceeds address limit of 20");
2499         require(msg.value == privatePrice * _amount, "etheruem sent incorrect");
2500 
2501         privateAllowList[msg.sender] -= _amount;
2502         privateMintCounts[msg.sender] += _amount;
2503         _safeMint(msg.sender, _amount);
2504     }
2505 
2506     function publicMint(uint _amount) public payable canMint(_amount) tryBlockContract {
2507         require(saleStatus == SaleStatus.PUBLIC, "public mint not active");
2508         require(publicMintCounts[msg.sender] + _amount <= MAX_TOKENS_PER_PUBLIC_MINT, "minting exceeds address limit of 20");
2509         require(msg.value == publicPrice * _amount, "etheruem sent incorrect");
2510 
2511         publicMintCounts[msg.sender] += _amount;
2512         _safeMint(msg.sender, _amount);
2513     }
2514 
2515     function unlimitedMint(uint _amount) public payable canMint(_amount) tryBlockContract {
2516         require(saleStatus == SaleStatus.UNLIMITED, "unlimited mint is not active");
2517         require(msg.value == unlimitedPrice * _amount, "ethereum sent incorrect");
2518 
2519         _safeMint(msg.sender, _amount);
2520     }
2521 
2522     function withdraw() external onlyOwner {
2523         uint256 balance = address(this).balance;
2524         Address.sendValue(payable(owner()), balance);
2525     }
2526 }