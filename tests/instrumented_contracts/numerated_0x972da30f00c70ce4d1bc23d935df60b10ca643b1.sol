1 // SPDX-License-Identifier: MIT
2 // File: erc721a/contracts/IERC721A.sol
3 
4 
5 // ERC721A Contracts v4.1.0
6 // Creator: Chiru Labs
7 
8 pragma solidity ^0.8.4;
9 
10 /**
11  * @dev Interface of an ERC721A compliant contract.
12  */
13 interface IERC721A {
14     /**
15      * The caller must own the token or be an approved operator.
16      */
17     error ApprovalCallerNotOwnerNorApproved();
18 
19     /**
20      * The token does not exist.
21      */
22     error ApprovalQueryForNonexistentToken();
23 
24     /**
25      * The caller cannot approve to their own address.
26      */
27     error ApproveToCaller();
28 
29     /**
30      * Cannot query the balance for the zero address.
31      */
32     error BalanceQueryForZeroAddress();
33 
34     /**
35      * Cannot mint to the zero address.
36      */
37     error MintToZeroAddress();
38 
39     /**
40      * The quantity of tokens minted must be more than zero.
41      */
42     error MintZeroQuantity();
43 
44     /**
45      * The token does not exist.
46      */
47     error OwnerQueryForNonexistentToken();
48 
49     /**
50      * The caller must own the token or be an approved operator.
51      */
52     error TransferCallerNotOwnerNorApproved();
53 
54     /**
55      * The token must be owned by `from`.
56      */
57     error TransferFromIncorrectOwner();
58 
59     /**
60      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
61      */
62     error TransferToNonERC721ReceiverImplementer();
63 
64     /**
65      * Cannot transfer to the zero address.
66      */
67     error TransferToZeroAddress();
68 
69     /**
70      * The token does not exist.
71      */
72     error URIQueryForNonexistentToken();
73 
74     /**
75      * The `quantity` minted with ERC2309 exceeds the safety limit.
76      */
77     error MintERC2309QuantityExceedsLimit();
78 
79     /**
80      * The `extraData` cannot be set on an unintialized ownership slot.
81      */
82     error OwnershipNotInitializedForExtraData();
83 
84     struct TokenOwnership {
85         // The address of the owner.
86         address addr;
87         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
88         uint64 startTimestamp;
89         // Whether the token has been burned.
90         bool burned;
91         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
92         uint24 extraData;
93     }
94 
95     /**
96      * @dev Returns the total amount of tokens stored by the contract.
97      *
98      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     // ==============================
103     //            IERC165
104     // ==============================
105 
106     /**
107      * @dev Returns true if this contract implements the interface defined by
108      * `interfaceId`. See the corresponding
109      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
110      * to learn more about how these ids are created.
111      *
112      * This function call must use less than 30 000 gas.
113      */
114     function supportsInterface(bytes4 interfaceId) external view returns (bool);
115 
116     // ==============================
117     //            IERC721
118     // ==============================
119 
120     /**
121      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
124 
125     /**
126      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
127      */
128     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
132      */
133     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
134 
135     /**
136      * @dev Returns the number of tokens in ``owner``'s account.
137      */
138     function balanceOf(address owner) external view returns (uint256 balance);
139 
140     /**
141      * @dev Returns the owner of the `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function ownerOf(uint256 tokenId) external view returns (address owner);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
171      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external;
188 
189     /**
190      * @dev Transfers `tokenId` token from `from` to `to`.
191      *
192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
214      *
215      * Requirements:
216      *
217      * - The caller must own the token or be an approved operator.
218      * - `tokenId` must exist.
219      *
220      * Emits an {Approval} event.
221      */
222     function approve(address to, uint256 tokenId) external;
223 
224     /**
225      * @dev Approve or remove `operator` as an operator for the caller.
226      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
227      *
228      * Requirements:
229      *
230      * - The `operator` cannot be the caller.
231      *
232      * Emits an {ApprovalForAll} event.
233      */
234     function setApprovalForAll(address operator, bool _approved) external;
235 
236     /**
237      * @dev Returns the account approved for `tokenId` token.
238      *
239      * Requirements:
240      *
241      * - `tokenId` must exist.
242      */
243     function getApproved(uint256 tokenId) external view returns (address operator);
244 
245     /**
246      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
247      *
248      * See {setApprovalForAll}
249      */
250     function isApprovedForAll(address owner, address operator) external view returns (bool);
251 
252     // ==============================
253     //        IERC721Metadata
254     // ==============================
255 
256     /**
257      * @dev Returns the token collection name.
258      */
259     function name() external view returns (string memory);
260 
261     /**
262      * @dev Returns the token collection symbol.
263      */
264     function symbol() external view returns (string memory);
265 
266     /**
267      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
268      */
269     function tokenURI(uint256 tokenId) external view returns (string memory);
270 
271     // ==============================
272     //            IERC2309
273     // ==============================
274 
275     /**
276      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
277      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
278      */
279     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
280 }
281 
282 // File: erc721a/contracts/ERC721A.sol
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
407         return 0;
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
458             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
459     }
460 
461     /**
462      * @dev See {IERC721-balanceOf}.
463      */
464     function balanceOf(address owner) public view override returns (uint256) {
465         if (owner == address(0)) revert BalanceQueryForZeroAddress();
466         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
467     }
468 
469     /**
470      * Returns the number of tokens minted by `owner`.
471      */
472     function _numberMinted(address owner) internal view returns (uint256) {
473         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
474     }
475 
476     /**
477      * Returns the number of tokens burned by or on behalf of `owner`.
478      */
479     function _numberBurned(address owner) internal view returns (uint256) {
480         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
481     }
482 
483     /**
484      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
485      */
486     function _getAux(address owner) internal view returns (uint64) {
487         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
488     }
489 
490     /**
491      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
492      * If there are multiple variables, please pack them into a uint64.
493      */
494     function _setAux(address owner, uint64 aux) internal {
495         uint256 packed = _packedAddressData[owner];
496         uint256 auxCasted;
497         // Cast `aux` with assembly to avoid redundant masking.
498         assembly {
499             auxCasted := aux
500         }
501         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
502         _packedAddressData[owner] = packed;
503     }
504 
505     /**
506      * Returns the packed ownership data of `tokenId`.
507      */
508     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
509         uint256 curr = tokenId;
510 
511         unchecked {
512             if (_startTokenId() <= curr)
513                 if (curr < _currentIndex) {
514                     uint256 packed = _packedOwnerships[curr];
515                     // If not burned.
516                     if (packed & BITMASK_BURNED == 0) {
517                         // Invariant:
518                         // There will always be an ownership that has an address and is not burned
519                         // before an ownership that does not have an address and is not burned.
520                         // Hence, curr will not underflow.
521                         //
522                         // We can directly compare the packed value.
523                         // If the address is zero, packed is zero.
524                         while (packed == 0) {
525                             packed = _packedOwnerships[--curr];
526                         }
527                         return packed;
528                     }
529                 }
530         }
531         revert OwnerQueryForNonexistentToken();
532     }
533 
534     /**
535      * Returns the unpacked `TokenOwnership` struct from `packed`.
536      */
537     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
538         ownership.addr = address(uint160(packed));
539         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
540         ownership.burned = packed & BITMASK_BURNED != 0;
541         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
542     }
543 
544     /**
545      * Returns the unpacked `TokenOwnership` struct at `index`.
546      */
547     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
548         return _unpackedOwnership(_packedOwnerships[index]);
549     }
550 
551     /**
552      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
553      */
554     function _initializeOwnershipAt(uint256 index) internal {
555         if (_packedOwnerships[index] == 0) {
556             _packedOwnerships[index] = _packedOwnershipOf(index);
557         }
558     }
559 
560     /**
561      * Gas spent here starts off proportional to the maximum mint batch size.
562      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
563      */
564     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
565         return _unpackedOwnership(_packedOwnershipOf(tokenId));
566     }
567 
568     /**
569      * @dev Packs ownership data into a single uint256.
570      */
571     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
572         assembly {
573             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
574             owner := and(owner, BITMASK_ADDRESS)
575             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
576             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
577         }
578     }
579 
580     /**
581      * @dev See {IERC721-ownerOf}.
582      */
583     function ownerOf(uint256 tokenId) public view override returns (address) {
584         return address(uint160(_packedOwnershipOf(tokenId)));
585     }
586 
587     /**
588      * @dev See {IERC721Metadata-name}.
589      */
590     function name() public view virtual override returns (string memory) {
591         return _name;
592     }
593 
594     /**
595      * @dev See {IERC721Metadata-symbol}.
596      */
597     function symbol() public view virtual override returns (string memory) {
598         return _symbol;
599     }
600 
601     /**
602      * @dev See {IERC721Metadata-tokenURI}.
603      */
604     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
605         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
606 
607         string memory baseURI = _baseURI();
608         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
609     }
610 
611     /**
612      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
613      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
614      * by default, it can be overridden in child contracts.
615      */
616     function _baseURI() internal view virtual returns (string memory) {
617         return '';
618     }
619 
620     /**
621      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
622      */
623     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
624         // For branchless setting of the `nextInitialized` flag.
625         assembly {
626             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
627             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
628         }
629     }
630 
631     /**
632      * @dev See {IERC721-approve}.
633      */
634     function approve(address to, uint256 tokenId) public override {
635         address owner = ownerOf(tokenId);
636 
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
660 
661         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
662         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
663     }
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
1233 
1234 // File: @openzeppelin/contracts/utils/Context.sol
1235 
1236 
1237 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1238 
1239 pragma solidity ^0.8.0;
1240 
1241 /**
1242  * @dev Provides information about the current execution context, including the
1243  * sender of the transaction and its data. While these are generally available
1244  * via msg.sender and msg.data, they should not be accessed in such a direct
1245  * manner, since when dealing with meta-transactions the account sending and
1246  * paying for execution may not be the actual sender (as far as an application
1247  * is concerned).
1248  *
1249  * This contract is only required for intermediate, library-like contracts.
1250  */
1251 abstract contract Context {
1252     function _msgSender() internal view virtual returns (address) {
1253         return msg.sender;
1254     }
1255 
1256     function _msgData() internal view virtual returns (bytes calldata) {
1257         return msg.data;
1258     }
1259 }
1260 
1261 // File: @openzeppelin/contracts/access/Ownable.sol
1262 
1263 
1264 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1265 
1266 pragma solidity ^0.8.0;
1267 
1268 
1269 /**
1270  * @dev Contract module which provides a basic access control mechanism, where
1271  * there is an account (an owner) that can be granted exclusive access to
1272  * specific functions.
1273  *
1274  * By default, the owner account will be the one that deploys the contract. This
1275  * can later be changed with {transferOwnership}.
1276  *
1277  * This module is used through inheritance. It will make available the modifier
1278  * `onlyOwner`, which can be applied to your functions to restrict their use to
1279  * the owner.
1280  */
1281 abstract contract Ownable is Context {
1282     address private _owner;
1283 
1284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1285 
1286     /**
1287      * @dev Initializes the contract setting the deployer as the initial owner.
1288      */
1289     constructor() {
1290         _transferOwnership(_msgSender());
1291     }
1292 
1293     /**
1294      * @dev Returns the address of the current owner.
1295      */
1296     function owner() public view virtual returns (address) {
1297         return _owner;
1298     }
1299 
1300     /**
1301      * @dev Throws if called by any account other than the owner.
1302      */
1303     modifier onlyOwner() {
1304         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1305         _;
1306     }
1307 
1308     /**
1309      * @dev Leaves the contract without owner. It will not be possible to call
1310      * `onlyOwner` functions anymore. Can only be called by the current owner.
1311      *
1312      * NOTE: Renouncing ownership will leave the contract without an owner,
1313      * thereby removing any functionality that is only available to the owner.
1314      */
1315     function renounceOwnership() public virtual onlyOwner {
1316         _transferOwnership(address(0));
1317     }
1318 
1319     /**
1320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1321      * Can only be called by the current owner.
1322      */
1323     function transferOwnership(address newOwner) public virtual onlyOwner {
1324         require(newOwner != address(0), "Ownable: new owner is the zero address");
1325         _transferOwnership(newOwner);
1326     }
1327 
1328     /**
1329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1330      * Internal function without access restriction.
1331      */
1332     function _transferOwnership(address newOwner) internal virtual {
1333         address oldOwner = _owner;
1334         _owner = newOwner;
1335         emit OwnershipTransferred(oldOwner, newOwner);
1336     }
1337 }
1338 
1339 // File: contracts/TopGuns/TopGuns.sol
1340 
1341 
1342 pragma solidity ^0.8.14;
1343 
1344 
1345 
1346 contract TopGuns is Ownable, ERC721A{
1347     uint256 public MAX_AMOUNT = 7000;
1348     uint256 public _max_per_wallet = 3;
1349     bool public _saleIsActive = false;
1350     string private _nftBaseURI = "ipfs://QmbGz9MkmA8ehTMVtyakf6UCgx1ew5SiQXGzmZbfGofizE/";
1351     uint256 public _listing_price = 0;
1352     mapping(address => uint256) public balances;
1353 
1354     constructor()
1355     ERC721A("TopGuns", "TOPGUNS")
1356     {}
1357 
1358     function setListingPrice(uint256 price) external onlyOwner {
1359       _listing_price = price;
1360     }
1361 
1362     function setMaxPerWallet(uint256 max_per_wallet) external onlyOwner {
1363       _max_per_wallet = max_per_wallet;
1364     }
1365 
1366 
1367 
1368     function _baseURI() internal view virtual override returns (string memory){
1369         return _nftBaseURI;
1370     }
1371 
1372 
1373     function setBaseURI(string calldata newURI) external onlyOwner{
1374       _nftBaseURI = newURI;
1375     }
1376 
1377     function flipSaleState() public onlyOwner {
1378         _saleIsActive = !_saleIsActive;
1379     }
1380 
1381 
1382     function withdraw() public onlyOwner {
1383         payable(owner()).transfer(address(this).balance);
1384       }
1385 
1386 
1387     function mint(uint256 _amount) external payable {
1388         require(_saleIsActive, "sale not active");
1389         require(totalSupply() + _amount <= (MAX_AMOUNT), "supply limited");
1390         require(msg.value >= (_listing_price * _amount), "not enough funds submitted");
1391         require(balances[msg.sender] + _amount <= _max_per_wallet, "wallet limit reached");
1392         balances[msg.sender] += _amount;
1393         _safeMint(msg.sender, _amount);
1394     }
1395 
1396     function airDropMany(address[] memory _addr) external onlyOwner {
1397        require(totalSupply() + _addr.length <= (MAX_AMOUNT), "you would exceed the limit");
1398 
1399        for (uint i = 0; i < _addr.length; i++) {
1400            _safeMint(_addr[i], 1);
1401 
1402        }
1403 
1404    }
1405 
1406 
1407 }