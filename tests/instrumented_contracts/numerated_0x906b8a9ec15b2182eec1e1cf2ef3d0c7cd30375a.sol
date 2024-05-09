1 // Sources flattened with hardhat v2.9.9 https://hardhat.org
2 
3 // File erc721a/contracts/IERC721A.sol@v4.1.0
4 
5 // SPDX-License-Identifier: MIT
6 // ERC721A Contracts v4.1.0
7 // Creator: Chiru Labs
8 
9 pragma solidity ^0.8.4;
10 
11 /**
12  * @dev Interface of an ERC721A compliant contract.
13  */
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
282 
283 
284 // File erc721a/contracts/ERC721A.sol@v4.1.0
285 
286 // ERC721A Contracts v4.1.0
287 // Creator: Chiru Labs
288 
289 pragma solidity ^0.8.4;
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
1234 
1235 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
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
1261 
1262 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
1263 
1264 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1265 
1266 pragma solidity ^0.8.0;
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
1345 
1346 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.0
1347 
1348 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1349 
1350 pragma solidity ^0.8.0;
1351 
1352 /**
1353  * @dev Contract module that helps prevent reentrant calls to a function.
1354  *
1355  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1356  * available, which can be applied to functions to make sure there are no nested
1357  * (reentrant) calls to them.
1358  *
1359  * Note that because there is a single `nonReentrant` guard, functions marked as
1360  * `nonReentrant` may not call one another. This can be worked around by making
1361  * those functions `private`, and then adding `external` `nonReentrant` entry
1362  * points to them.
1363  *
1364  * TIP: If you would like to learn more about reentrancy and alternative ways
1365  * to protect against it, check out our blog post
1366  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1367  */
1368 abstract contract ReentrancyGuard {
1369     // Booleans are more expensive than uint256 or any type that takes up a full
1370     // word because each write operation emits an extra SLOAD to first read the
1371     // slot's contents, replace the bits taken up by the boolean, and then write
1372     // back. This is the compiler's defense against contract upgrades and
1373     // pointer aliasing, and it cannot be disabled.
1374 
1375     // The values being non-zero value makes deployment a bit more expensive,
1376     // but in exchange the refund on every call to nonReentrant will be lower in
1377     // amount. Since refunds are capped to a percentage of the total
1378     // transaction's gas, it is best to keep them low in cases like this one, to
1379     // increase the likelihood of the full refund coming into effect.
1380     uint256 private constant _NOT_ENTERED = 1;
1381     uint256 private constant _ENTERED = 2;
1382 
1383     uint256 private _status;
1384 
1385     constructor() {
1386         _status = _NOT_ENTERED;
1387     }
1388 
1389     /**
1390      * @dev Prevents a contract from calling itself, directly or indirectly.
1391      * Calling a `nonReentrant` function from another `nonReentrant`
1392      * function is not supported. It is possible to prevent this from happening
1393      * by making the `nonReentrant` function external, and making it call a
1394      * `private` function that does the actual work.
1395      */
1396     modifier nonReentrant() {
1397         _nonReentrantBefore();
1398         _;
1399         _nonReentrantAfter();
1400     }
1401 
1402     function _nonReentrantBefore() private {
1403         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1404         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1405 
1406         // Any calls to nonReentrant after this point will fail
1407         _status = _ENTERED;
1408     }
1409 
1410     function _nonReentrantAfter() private {
1411         // By storing the original value once again, a refund is triggered (see
1412         // https://eips.ethereum.org/EIPS/eip-2200)
1413         _status = _NOT_ENTERED;
1414     }
1415 }
1416 
1417 
1418 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
1419 
1420 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1421 
1422 pragma solidity ^0.8.0;
1423 
1424 /**
1425  * @dev Standard math utilities missing in the Solidity language.
1426  */
1427 library Math {
1428     enum Rounding {
1429         Down, // Toward negative infinity
1430         Up, // Toward infinity
1431         Zero // Toward zero
1432     }
1433 
1434     /**
1435      * @dev Returns the largest of two numbers.
1436      */
1437     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1438         return a > b ? a : b;
1439     }
1440 
1441     /**
1442      * @dev Returns the smallest of two numbers.
1443      */
1444     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1445         return a < b ? a : b;
1446     }
1447 
1448     /**
1449      * @dev Returns the average of two numbers. The result is rounded towards
1450      * zero.
1451      */
1452     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1453         // (a + b) / 2 can overflow.
1454         return (a & b) + (a ^ b) / 2;
1455     }
1456 
1457     /**
1458      * @dev Returns the ceiling of the division of two numbers.
1459      *
1460      * This differs from standard division with `/` in that it rounds up instead
1461      * of rounding down.
1462      */
1463     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1464         // (a + b - 1) / b can overflow on addition, so we distribute.
1465         return a == 0 ? 0 : (a - 1) / b + 1;
1466     }
1467 
1468     /**
1469      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1470      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1471      * with further edits by Uniswap Labs also under MIT license.
1472      */
1473     function mulDiv(
1474         uint256 x,
1475         uint256 y,
1476         uint256 denominator
1477     ) internal pure returns (uint256 result) {
1478         unchecked {
1479             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1480             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1481             // variables such that product = prod1 * 2^256 + prod0.
1482             uint256 prod0; // Least significant 256 bits of the product
1483             uint256 prod1; // Most significant 256 bits of the product
1484             assembly {
1485                 let mm := mulmod(x, y, not(0))
1486                 prod0 := mul(x, y)
1487                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1488             }
1489 
1490             // Handle non-overflow cases, 256 by 256 division.
1491             if (prod1 == 0) {
1492                 return prod0 / denominator;
1493             }
1494 
1495             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1496             require(denominator > prod1);
1497 
1498             ///////////////////////////////////////////////
1499             // 512 by 256 division.
1500             ///////////////////////////////////////////////
1501 
1502             // Make division exact by subtracting the remainder from [prod1 prod0].
1503             uint256 remainder;
1504             assembly {
1505                 // Compute remainder using mulmod.
1506                 remainder := mulmod(x, y, denominator)
1507 
1508                 // Subtract 256 bit number from 512 bit number.
1509                 prod1 := sub(prod1, gt(remainder, prod0))
1510                 prod0 := sub(prod0, remainder)
1511             }
1512 
1513             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1514             // See https://cs.stackexchange.com/q/138556/92363.
1515 
1516             // Does not overflow because the denominator cannot be zero at this stage in the function.
1517             uint256 twos = denominator & (~denominator + 1);
1518             assembly {
1519                 // Divide denominator by twos.
1520                 denominator := div(denominator, twos)
1521 
1522                 // Divide [prod1 prod0] by twos.
1523                 prod0 := div(prod0, twos)
1524 
1525                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1526                 twos := add(div(sub(0, twos), twos), 1)
1527             }
1528 
1529             // Shift in bits from prod1 into prod0.
1530             prod0 |= prod1 * twos;
1531 
1532             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1533             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1534             // four bits. That is, denominator * inv = 1 mod 2^4.
1535             uint256 inverse = (3 * denominator) ^ 2;
1536 
1537             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1538             // in modular arithmetic, doubling the correct bits in each step.
1539             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1540             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1541             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1542             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1543             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1544             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1545 
1546             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1547             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1548             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1549             // is no longer required.
1550             result = prod0 * inverse;
1551             return result;
1552         }
1553     }
1554 
1555     /**
1556      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1557      */
1558     function mulDiv(
1559         uint256 x,
1560         uint256 y,
1561         uint256 denominator,
1562         Rounding rounding
1563     ) internal pure returns (uint256) {
1564         uint256 result = mulDiv(x, y, denominator);
1565         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1566             result += 1;
1567         }
1568         return result;
1569     }
1570 
1571     /**
1572      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1573      *
1574      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1575      */
1576     function sqrt(uint256 a) internal pure returns (uint256) {
1577         if (a == 0) {
1578             return 0;
1579         }
1580 
1581         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1582         //
1583         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1584         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1585         //
1586         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1587         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1588         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1589         //
1590         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1591         uint256 result = 1 << (log2(a) >> 1);
1592 
1593         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1594         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1595         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1596         // into the expected uint128 result.
1597         unchecked {
1598             result = (result + a / result) >> 1;
1599             result = (result + a / result) >> 1;
1600             result = (result + a / result) >> 1;
1601             result = (result + a / result) >> 1;
1602             result = (result + a / result) >> 1;
1603             result = (result + a / result) >> 1;
1604             result = (result + a / result) >> 1;
1605             return min(result, a / result);
1606         }
1607     }
1608 
1609     /**
1610      * @notice Calculates sqrt(a), following the selected rounding direction.
1611      */
1612     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1613         unchecked {
1614             uint256 result = sqrt(a);
1615             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1616         }
1617     }
1618 
1619     /**
1620      * @dev Return the log in base 2, rounded down, of a positive value.
1621      * Returns 0 if given 0.
1622      */
1623     function log2(uint256 value) internal pure returns (uint256) {
1624         uint256 result = 0;
1625         unchecked {
1626             if (value >> 128 > 0) {
1627                 value >>= 128;
1628                 result += 128;
1629             }
1630             if (value >> 64 > 0) {
1631                 value >>= 64;
1632                 result += 64;
1633             }
1634             if (value >> 32 > 0) {
1635                 value >>= 32;
1636                 result += 32;
1637             }
1638             if (value >> 16 > 0) {
1639                 value >>= 16;
1640                 result += 16;
1641             }
1642             if (value >> 8 > 0) {
1643                 value >>= 8;
1644                 result += 8;
1645             }
1646             if (value >> 4 > 0) {
1647                 value >>= 4;
1648                 result += 4;
1649             }
1650             if (value >> 2 > 0) {
1651                 value >>= 2;
1652                 result += 2;
1653             }
1654             if (value >> 1 > 0) {
1655                 result += 1;
1656             }
1657         }
1658         return result;
1659     }
1660 
1661     /**
1662      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1663      * Returns 0 if given 0.
1664      */
1665     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1666         unchecked {
1667             uint256 result = log2(value);
1668             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1669         }
1670     }
1671 
1672     /**
1673      * @dev Return the log in base 10, rounded down, of a positive value.
1674      * Returns 0 if given 0.
1675      */
1676     function log10(uint256 value) internal pure returns (uint256) {
1677         uint256 result = 0;
1678         unchecked {
1679             if (value >= 10**64) {
1680                 value /= 10**64;
1681                 result += 64;
1682             }
1683             if (value >= 10**32) {
1684                 value /= 10**32;
1685                 result += 32;
1686             }
1687             if (value >= 10**16) {
1688                 value /= 10**16;
1689                 result += 16;
1690             }
1691             if (value >= 10**8) {
1692                 value /= 10**8;
1693                 result += 8;
1694             }
1695             if (value >= 10**4) {
1696                 value /= 10**4;
1697                 result += 4;
1698             }
1699             if (value >= 10**2) {
1700                 value /= 10**2;
1701                 result += 2;
1702             }
1703             if (value >= 10**1) {
1704                 result += 1;
1705             }
1706         }
1707         return result;
1708     }
1709 
1710     /**
1711      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1712      * Returns 0 if given 0.
1713      */
1714     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1715         unchecked {
1716             uint256 result = log10(value);
1717             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1718         }
1719     }
1720 
1721     /**
1722      * @dev Return the log in base 256, rounded down, of a positive value.
1723      * Returns 0 if given 0.
1724      *
1725      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1726      */
1727     function log256(uint256 value) internal pure returns (uint256) {
1728         uint256 result = 0;
1729         unchecked {
1730             if (value >> 128 > 0) {
1731                 value >>= 128;
1732                 result += 16;
1733             }
1734             if (value >> 64 > 0) {
1735                 value >>= 64;
1736                 result += 8;
1737             }
1738             if (value >> 32 > 0) {
1739                 value >>= 32;
1740                 result += 4;
1741             }
1742             if (value >> 16 > 0) {
1743                 value >>= 16;
1744                 result += 2;
1745             }
1746             if (value >> 8 > 0) {
1747                 result += 1;
1748             }
1749         }
1750         return result;
1751     }
1752 
1753     /**
1754      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1755      * Returns 0 if given 0.
1756      */
1757     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1758         unchecked {
1759             uint256 result = log256(value);
1760             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1761         }
1762     }
1763 }
1764 
1765 
1766 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
1767 
1768 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1769 
1770 pragma solidity ^0.8.0;
1771 
1772 /**
1773  * @dev String operations.
1774  */
1775 library Strings {
1776     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1777     uint8 private constant _ADDRESS_LENGTH = 20;
1778 
1779     /**
1780      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1781      */
1782     function toString(uint256 value) internal pure returns (string memory) {
1783         unchecked {
1784             uint256 length = Math.log10(value) + 1;
1785             string memory buffer = new string(length);
1786             uint256 ptr;
1787             /// @solidity memory-safe-assembly
1788             assembly {
1789                 ptr := add(buffer, add(32, length))
1790             }
1791             while (true) {
1792                 ptr--;
1793                 /// @solidity memory-safe-assembly
1794                 assembly {
1795                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1796                 }
1797                 value /= 10;
1798                 if (value == 0) break;
1799             }
1800             return buffer;
1801         }
1802     }
1803 
1804     /**
1805      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1806      */
1807     function toHexString(uint256 value) internal pure returns (string memory) {
1808         unchecked {
1809             return toHexString(value, Math.log256(value) + 1);
1810         }
1811     }
1812 
1813     /**
1814      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1815      */
1816     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1817         bytes memory buffer = new bytes(2 * length + 2);
1818         buffer[0] = "0";
1819         buffer[1] = "x";
1820         for (uint256 i = 2 * length + 1; i > 1; --i) {
1821             buffer[i] = _SYMBOLS[value & 0xf];
1822             value >>= 4;
1823         }
1824         require(value == 0, "Strings: hex length insufficient");
1825         return string(buffer);
1826     }
1827 
1828     /**
1829      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1830      */
1831     function toHexString(address addr) internal pure returns (string memory) {
1832         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1833     }
1834 }
1835 
1836 
1837 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.2.1
1838 
1839 pragma solidity ^0.8.13;
1840 
1841 interface IOperatorFilterRegistry {
1842     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1843     function register(address registrant) external;
1844     function registerAndSubscribe(address registrant, address subscription) external;
1845     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1846     function updateOperator(address registrant, address operator, bool filtered) external;
1847     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1848     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1849     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1850     function subscribe(address registrant, address registrantToSubscribe) external;
1851     function unsubscribe(address registrant, bool copyExistingEntries) external;
1852     function subscriptionOf(address addr) external returns (address registrant);
1853     function subscribers(address registrant) external returns (address[] memory);
1854     function subscriberAt(address registrant, uint256 index) external returns (address);
1855     function copyEntriesOf(address registrant, address registrantToCopy) external;
1856     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1857     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1858     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1859     function filteredOperators(address addr) external returns (address[] memory);
1860     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1861     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1862     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1863     function isRegistered(address addr) external returns (bool);
1864     function codeHashOf(address addr) external returns (bytes32);
1865 }
1866 
1867 
1868 // File operator-filter-registry/src/OperatorFilterer.sol@v1.2.1
1869 
1870 pragma solidity ^0.8.13;
1871 
1872 abstract contract OperatorFilterer {
1873     error OperatorNotAllowed(address operator);
1874 
1875     IOperatorFilterRegistry constant operatorFilterRegistry =
1876         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1877 
1878     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1879         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1880         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1881         // order for the modifier to filter addresses.
1882         if (address(operatorFilterRegistry).code.length > 0) {
1883             if (subscribe) {
1884                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1885             } else {
1886                 if (subscriptionOrRegistrantToCopy != address(0)) {
1887                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1888                 } else {
1889                     operatorFilterRegistry.register(address(this));
1890                 }
1891             }
1892         }
1893     }
1894 
1895     modifier onlyAllowedOperator(address from) virtual {
1896         // Check registry code length to facilitate testing in environments without a deployed registry.
1897         if (address(operatorFilterRegistry).code.length > 0) {
1898             // Allow spending tokens from addresses with balance
1899             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1900             // from an EOA.
1901             if (from == msg.sender) {
1902                 _;
1903                 return;
1904             }
1905             if (
1906                 !(
1907                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1908                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1909                 )
1910             ) {
1911                 revert OperatorNotAllowed(msg.sender);
1912             }
1913         }
1914         _;
1915     }
1916 }
1917 
1918 
1919 // File operator-filter-registry/src/DefaultOperatorFilterer.sol@v1.2.1
1920 
1921 pragma solidity ^0.8.13;
1922 
1923 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1924     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1925 
1926     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1927 }
1928 
1929 
1930 // File contracts/france.sol
1931 
1932 
1933 pragma solidity >=0.8.9 <0.9.0;
1934 
1935 
1936 
1937 
1938 
1939 contract ItsFrance  is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
1940     using Strings for uint256;
1941 
1942     mapping (address => uint256) public walletTokens;
1943     uint256 public price = 0 ether;
1944     uint256 public maxTokensPerTx = 1;
1945     uint256 public freeTokensPerWallet = 1;
1946     uint256 public limitTokensPerWallet = 1;
1947     uint256 public maxSupply = 2222;
1948     bool public openForMint = true;
1949     string public baseURI = "https://purple-electoral-penguin-724.mypinata.cloud/ipfs/QmZ9vqPu7TQSZyfqAyx9Sej7FeQAWxPzesxgt5J8EB37W8/";
1950 
1951 
1952     constructor() ERC721A("It's France", "WINNER")  DefaultOperatorFilterer(){}
1953 
1954     function mint(uint256 amount) external payable {
1955         require(amount > 0, "Invalid mint amount!");
1956         require(totalSupply() + amount <= maxSupply, "Max supply exceeded!");
1957         if (msg.sender != owner()) {
1958             require(openForMint, "Public mint is not open yet");
1959             require(amount <= maxTokensPerTx, "Exceeded max number tokens per tx");
1960             require(walletTokens[msg.sender] + amount <= limitTokensPerWallet, 'Exceed limit tokens per wallet!');            
1961             require(tx.origin == msg.sender, "The caller is another contract");
1962             uint256 tokensAlreadyMint = walletTokens[msg.sender];
1963             uint256 remainFree = (freeTokensPerWallet > tokensAlreadyMint ? (freeTokensPerWallet - tokensAlreadyMint) : 0);
1964             require(
1965                 msg.value >= (amount - remainFree) * price,
1966                 "Insufficient funds!"
1967             );
1968             walletTokens[msg.sender] += amount;
1969         }
1970         _mint(msg.sender, amount);
1971     }
1972 
1973     function devMint(uint256 _mintAmount, address _receiver) public onlyOwner {
1974         require(
1975             totalSupply() + _mintAmount <= maxSupply,
1976             "Max supply exceeded!"
1977         );
1978         _mint(_receiver, _mintAmount);
1979     }
1980 
1981     function _startTokenId() internal view virtual override returns (uint256) {
1982         return 1;
1983     }
1984 
1985     function setMaxTokensPerTx(uint256 _maxTokensPerTx) external onlyOwner {
1986         maxTokensPerTx = _maxTokensPerTx;
1987     }
1988 
1989     function setMaxTokensPerWallet(uint256 _maxTokensPerWallet) external onlyOwner {
1990         limitTokensPerWallet = _maxTokensPerWallet;
1991     }
1992 
1993     function setTokenPrice(uint256 _price) public onlyOwner {
1994         price = _price;
1995     }
1996 
1997     function setFreeTokensPerWallet(uint256 amount) public onlyOwner {
1998         freeTokensPerWallet = amount;
1999     }
2000 
2001     function tokenURI(uint256 _tokenId)
2002         public
2003         view
2004         virtual
2005         override
2006         returns (string memory)
2007     {
2008         require(
2009             _exists(_tokenId),
2010             "ERC721Metadata: URI query for nonexistent token"
2011         );
2012 
2013         string memory currentBaseURI = baseURI;
2014         return
2015             bytes(currentBaseURI).length > 0
2016                 ? string(
2017                     abi.encodePacked(
2018                         currentBaseURI,
2019                         _tokenId.toString(),
2020                         ".json"
2021                     )
2022                 )
2023                 : "";
2024     }
2025 
2026     function _baseURI() internal view virtual override returns (string memory) {
2027         return baseURI;
2028     }
2029 
2030     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2031         baseURI = _newBaseURI;
2032     }
2033 
2034     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
2035         maxSupply = _maxSupply;
2036     }
2037 
2038     function setSaleForPublic(bool _state) public onlyOwner {
2039         openForMint = _state;
2040     }
2041 
2042     function withdraw() public onlyOwner nonReentrant {
2043         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2044         require(os);
2045     }
2046 
2047     function transferFrom(address from, address to, uint256 tokenId)
2048         public
2049         override
2050         onlyAllowedOperator(from)
2051     {
2052         super.transferFrom(from, to, tokenId);
2053     }
2054 
2055     function safeTransferFrom(address from, address to, uint256 tokenId)
2056         public
2057         override
2058         onlyAllowedOperator(from)
2059     {
2060         super.safeTransferFrom(from, to, tokenId);
2061     }
2062 
2063     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2064         public
2065         override
2066         onlyAllowedOperator(from)
2067     {
2068         super.safeTransferFrom(from, to, tokenId, data);
2069     }
2070 }