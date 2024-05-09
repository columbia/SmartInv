1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
4 
5 
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
283 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
284 
285 
286 // ERC721A Contracts v4.1.0
287 // Creator: Chiru Labs
288 
289 pragma solidity ^0.8.4;
290 
291 
292 /**
293  * @dev ERC721 token receiver interface.
294  */
295 interface ERC721A__IERC721Receiver {
296     function onERC721Received(
297         address operator,
298         address from,
299         uint256 tokenId,
300         bytes calldata data
301     ) external returns (bytes4);
302 }
303 
304 /**
305  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
306  * including the Metadata extension. Built to optimize for lower gas during batch mints.
307  *
308  * Assumes serials are sequentially minted starting at `_startTokenId()`
309  * (defaults to 0, e.g. 0, 1, 2, 3..).
310  *
311  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
312  *
313  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
314  */
315 contract ERC721A is IERC721A {
316     // Mask of an entry in packed address data.
317     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
318 
319     // The bit position of `numberMinted` in packed address data.
320     uint256 private constant BITPOS_NUMBER_MINTED = 64;
321 
322     // The bit position of `numberBurned` in packed address data.
323     uint256 private constant BITPOS_NUMBER_BURNED = 128;
324 
325     // The bit position of `aux` in packed address data.
326     uint256 private constant BITPOS_AUX = 192;
327 
328     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
329     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
330 
331     // The bit position of `startTimestamp` in packed ownership.
332     uint256 private constant BITPOS_START_TIMESTAMP = 160;
333 
334     // The bit mask of the `burned` bit in packed ownership.
335     uint256 private constant BITMASK_BURNED = 1 << 224;
336 
337     // The bit position of the `nextInitialized` bit in packed ownership.
338     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
339 
340     // The bit mask of the `nextInitialized` bit in packed ownership.
341     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
342 
343     // The bit position of `extraData` in packed ownership.
344     uint256 private constant BITPOS_EXTRA_DATA = 232;
345 
346     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
347     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
348 
349     // The mask of the lower 160 bits for addresses.
350     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
351 
352     // The maximum `quantity` that can be minted with `_mintERC2309`.
353     // This limit is to prevent overflows on the address data entries.
354     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
355     // is required to cause an overflow, which is unrealistic.
356     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
357 
358     // The tokenId of the next token to be minted.
359     uint256 private _currentIndex;
360 
361     // The number of tokens burned.
362     uint256 private _burnCounter;
363 
364     // Token name
365     string private _name;
366 
367     // Token symbol
368     string private _symbol;
369 
370     // Mapping from token ID to ownership details
371     // An empty struct value does not necessarily mean the token is unowned.
372     // See `_packedOwnershipOf` implementation for details.
373     //
374     // Bits Layout:
375     // - [0..159]   `addr`
376     // - [160..223] `startTimestamp`
377     // - [224]      `burned`
378     // - [225]      `nextInitialized`
379     // - [232..255] `extraData`
380     mapping(uint256 => uint256) private _packedOwnerships;
381 
382     // Mapping owner address to address data.
383     //
384     // Bits Layout:
385     // - [0..63]    `balance`
386     // - [64..127]  `numberMinted`
387     // - [128..191] `numberBurned`
388     // - [192..255] `aux`
389     mapping(address => uint256) private _packedAddressData;
390 
391     // Mapping from token ID to approved address.
392     mapping(uint256 => address) private _tokenApprovals;
393 
394     // Mapping from owner to operator approvals
395     mapping(address => mapping(address => bool)) private _operatorApprovals;
396 
397     constructor(string memory name_, string memory symbol_) {
398         _name = name_;
399         _symbol = symbol_;
400         _currentIndex = _startTokenId();
401     }
402 
403     /**
404      * @dev Returns the starting token ID.
405      * To change the starting token ID, please override this function.
406      */
407     function _startTokenId() internal view virtual returns (uint256) {
408         return 0;
409     }
410 
411     /**
412      * @dev Returns the next token ID to be minted.
413      */
414     function _nextTokenId() internal view virtual returns (uint256) {
415         return _currentIndex;
416     }
417 
418     /**
419      * @dev Returns the total number of tokens in existence.
420      * Burned tokens will reduce the count.
421      * To get the total number of tokens minted, please see `_totalMinted`.
422      */
423     function totalSupply() public view virtual override returns (uint256) {
424         // Counter underflow is impossible as _burnCounter cannot be incremented
425         // more than `_currentIndex - _startTokenId()` times.
426         unchecked {
427             return _currentIndex - _burnCounter - _startTokenId();
428         }
429     }
430 
431     /**
432      * @dev Returns the total amount of tokens minted in the contract.
433      */
434     function _totalMinted() internal view virtual returns (uint256) {
435         // Counter underflow is impossible as _currentIndex does not decrement,
436         // and it is initialized to `_startTokenId()`
437         unchecked {
438             return _currentIndex - _startTokenId();
439         }
440     }
441 
442     /**
443      * @dev Returns the total number of tokens burned.
444      */
445     function _totalBurned() internal view virtual returns (uint256) {
446         return _burnCounter;
447     }
448 
449     /**
450      * @dev See {IERC165-supportsInterface}.
451      */
452     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
453         // The interface IDs are constants representing the first 4 bytes of the XOR of
454         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
455         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
456         return
457             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
458             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
459             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
460     }
461 
462     /**
463      * @dev See {IERC721-balanceOf}.
464      */
465     function balanceOf(address owner) public view virtual override returns (uint256) {
466         if (owner == address(0)) revert BalanceQueryForZeroAddress();
467         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
468     }
469 
470     /**
471      * Returns the number of tokens minted by `owner`.
472      */
473     function _numberMinted(address owner) internal view virtual returns (uint256) {
474         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
475     }
476 
477     /**
478      * Returns the number of tokens burned by or on behalf of `owner`.
479      */
480     function _numberBurned(address owner) internal view virtual returns (uint256) {
481         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
482     }
483 
484     /**
485      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
486      */
487     function _getAux(address owner) internal view virtual returns (uint64) {
488         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
489     }
490 
491     /**
492      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
493      * If there are multiple variables, please pack them into a uint64.
494      */
495     function _setAux(address owner, uint64 aux) internal virtual {
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
548     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
549         return _unpackedOwnership(_packedOwnerships[index]);
550     }
551 
552     /**
553      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
554      */
555     function _initializeOwnershipAt(uint256 index) internal virtual {
556         if (_packedOwnerships[index] == 0) {
557             _packedOwnerships[index] = _packedOwnershipOf(index);
558         }
559     }
560 
561     /**
562      * Gas spent here starts off proportional to the maximum mint batch size.
563      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
564      */
565     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
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
584     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
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
637 
638         if (_msgSenderERC721A() != owner)
639             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
640                 revert ApprovalCallerNotOwnerNorApproved();
641             }
642 
643         _tokenApprovals[tokenId] = to;
644         emit Approval(owner, to, tokenId);
645     }
646 
647     /**
648      * @dev See {IERC721-getApproved}.
649      */
650     function getApproved(uint256 tokenId) public view virtual override returns (address) {
651         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
652 
653         return _tokenApprovals[tokenId];
654     }
655 
656     /**
657      * @dev See {IERC721-setApprovalForAll}.
658      */
659     function setApprovalForAll(address operator, bool approved) public virtual override {
660         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
661 
662         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
663         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
664     }
665 
666     /**
667      * @dev See {IERC721-isApprovedForAll}.
668      */
669     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
670         return _operatorApprovals[owner][operator];
671     }
672 
673     /**
674      * @dev See {IERC721-safeTransferFrom}.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) public virtual override {
681         safeTransferFrom(from, to, tokenId, '');
682     }
683 
684     /**
685      * @dev See {IERC721-safeTransferFrom}.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId,
691         bytes memory _data
692     ) public virtual override {
693         transferFrom(from, to, tokenId);
694         if (to.code.length != 0)
695             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
696                 revert TransferToNonERC721ReceiverImplementer();
697             }
698     }
699 
700     /**
701      * @dev Returns whether `tokenId` exists.
702      *
703      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
704      *
705      * Tokens start existing when they are minted (`_mint`),
706      */
707     function _exists(uint256 tokenId) internal view virtual returns (bool) {
708         return
709             _startTokenId() <= tokenId &&
710             tokenId < _currentIndex && // If within bounds,
711             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
712     }
713 
714     /**
715      * @dev Equivalent to `_safeMint(to, quantity, '')`.
716      */
717     function _safeMint(address to, uint256 quantity) internal virtual {
718         _safeMint(to, quantity, '');
719     }
720 
721     /**
722      * @dev Safely mints `quantity` tokens and transfers them to `to`.
723      *
724      * Requirements:
725      *
726      * - If `to` refers to a smart contract, it must implement
727      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
728      * - `quantity` must be greater than 0.
729      *
730      * See {_mint}.
731      *
732      * Emits a {Transfer} event for each mint.
733      */
734     function _safeMint(
735         address to,
736         uint256 quantity,
737         bytes memory _data
738     ) internal virtual {
739         _mint(to, quantity);
740 
741         unchecked {
742             if (to.code.length != 0) {
743                 uint256 end = _currentIndex;
744                 uint256 index = end - quantity;
745                 do {
746                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
747                         revert TransferToNonERC721ReceiverImplementer();
748                     }
749                 } while (index < end);
750                 // Reentrancy protection.
751                 if (_currentIndex != end) revert();
752             }
753         }
754     }
755 
756     /**
757      * @dev Mints `quantity` tokens and transfers them to `to`.
758      *
759      * Requirements:
760      *
761      * - `to` cannot be the zero address.
762      * - `quantity` must be greater than 0.
763      *
764      * Emits a {Transfer} event for each mint.
765      */
766     function _mint(address to, uint256 quantity) internal virtual {
767         uint256 startTokenId = _currentIndex;
768         if (to == address(0)) revert MintToZeroAddress();
769         if (quantity == 0) revert MintZeroQuantity();
770 
771         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
772 
773         // Overflows are incredibly unrealistic.
774         // `balance` and `numberMinted` have a maximum limit of 2**64.
775         // `tokenId` has a maximum limit of 2**256.
776         unchecked {
777             // Updates:
778             // - `balance += quantity`.
779             // - `numberMinted += quantity`.
780             //
781             // We can directly add to the `balance` and `numberMinted`.
782             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
783 
784             // Updates:
785             // - `address` to the owner.
786             // - `startTimestamp` to the timestamp of minting.
787             // - `burned` to `false`.
788             // - `nextInitialized` to `quantity == 1`.
789             _packedOwnerships[startTokenId] = _packOwnershipData(
790                 to,
791                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
792             );
793 
794             uint256 tokenId = startTokenId;
795             uint256 end = startTokenId + quantity;
796             do {
797                 emit Transfer(address(0), to, tokenId++);
798             } while (tokenId < end);
799 
800             _currentIndex = end;
801         }
802         _afterTokenTransfers(address(0), to, startTokenId, quantity);
803     }
804 
805     /**
806      * @dev Mints `quantity` tokens and transfers them to `to`.
807      *
808      * This function is intended for efficient minting only during contract creation.
809      *
810      * It emits only one {ConsecutiveTransfer} as defined in
811      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
812      * instead of a sequence of {Transfer} event(s).
813      *
814      * Calling this function outside of contract creation WILL make your contract
815      * non-compliant with the ERC721 standard.
816      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
817      * {ConsecutiveTransfer} event is only permissible during contract creation.
818      *
819      * Requirements:
820      *
821      * - `to` cannot be the zero address.
822      * - `quantity` must be greater than 0.
823      *
824      * Emits a {ConsecutiveTransfer} event.
825      */
826     function _mintERC2309(address to, uint256 quantity) internal virtual {
827         uint256 startTokenId = _currentIndex;
828         if (to == address(0)) revert MintToZeroAddress();
829         if (quantity == 0) revert MintZeroQuantity();
830         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
831 
832         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
833 
834         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
835         unchecked {
836             // Updates:
837             // - `balance += quantity`.
838             // - `numberMinted += quantity`.
839             //
840             // We can directly add to the `balance` and `numberMinted`.
841             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
842 
843             // Updates:
844             // - `address` to the owner.
845             // - `startTimestamp` to the timestamp of minting.
846             // - `burned` to `false`.
847             // - `nextInitialized` to `quantity == 1`.
848             _packedOwnerships[startTokenId] = _packOwnershipData(
849                 to,
850                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
851             );
852 
853             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
854 
855             _currentIndex = startTokenId + quantity;
856         }
857         _afterTokenTransfers(address(0), to, startTokenId, quantity);
858     }
859 
860     /**
861      * @dev Returns the storage slot and value for the approved address of `tokenId`.
862      */
863     function _getApprovedAddress(uint256 tokenId)
864         private
865         view
866         returns (uint256 approvedAddressSlot, address approvedAddress)
867     {
868         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
869         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
870         assembly {
871             // Compute the slot.
872             mstore(0x00, tokenId)
873             mstore(0x20, tokenApprovalsPtr.slot)
874             approvedAddressSlot := keccak256(0x00, 0x40)
875             // Load the slot's value from storage.
876             approvedAddress := sload(approvedAddressSlot)
877         }
878     }
879 
880     /**
881      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
882      */
883     function _isOwnerOrApproved(
884         address approvedAddress,
885         address from,
886         address msgSender
887     ) private pure returns (bool result) {
888         assembly {
889             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
890             from := and(from, BITMASK_ADDRESS)
891             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
892             msgSender := and(msgSender, BITMASK_ADDRESS)
893             // `msgSender == from || msgSender == approvedAddress`.
894             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
895         }
896     }
897 
898     /**
899      * @dev Transfers `tokenId` from `from` to `to`.
900      *
901      * Requirements:
902      *
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must be owned by `from`.
905      *
906      * Emits a {Transfer} event.
907      */
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
914 
915         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
916 
917         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
918 
919         // The nested ifs save around 20+ gas over a compound boolean condition.
920         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
921             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
922 
923         if (to == address(0)) revert TransferToZeroAddress();
924 
925         _beforeTokenTransfers(from, to, tokenId, 1);
926 
927         // Clear approvals from the previous owner.
928         assembly {
929             if approvedAddress {
930                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
931                 sstore(approvedAddressSlot, 0)
932             }
933         }
934 
935         // Underflow of the sender's balance is impossible because we check for
936         // ownership above and the recipient's balance can't realistically overflow.
937         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
938         unchecked {
939             // We can directly increment and decrement the balances.
940             --_packedAddressData[from]; // Updates: `balance -= 1`.
941             ++_packedAddressData[to]; // Updates: `balance += 1`.
942 
943             // Updates:
944             // - `address` to the next owner.
945             // - `startTimestamp` to the timestamp of transfering.
946             // - `burned` to `false`.
947             // - `nextInitialized` to `true`.
948             _packedOwnerships[tokenId] = _packOwnershipData(
949                 to,
950                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
951             );
952 
953             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
954             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
955                 uint256 nextTokenId = tokenId + 1;
956                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
957                 if (_packedOwnerships[nextTokenId] == 0) {
958                     // If the next slot is within bounds.
959                     if (nextTokenId != _currentIndex) {
960                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
961                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
962                     }
963                 }
964             }
965         }
966 
967         emit Transfer(from, to, tokenId);
968         _afterTokenTransfers(from, to, tokenId, 1);
969     }
970 
971     /**
972      * @dev Equivalent to `_burn(tokenId, false)`.
973      */
974     function _burn(uint256 tokenId) internal virtual {
975         _burn(tokenId, false);
976     }
977 
978     /**
979      * @dev Destroys `tokenId`.
980      * The approval is cleared when the token is burned.
981      *
982      * Requirements:
983      *
984      * - `tokenId` must exist.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
989         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
990 
991         address from = address(uint160(prevOwnershipPacked));
992 
993         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
994 
995         if (approvalCheck) {
996             // The nested ifs save around 20+ gas over a compound boolean condition.
997             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
998                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
999         }
1000 
1001         _beforeTokenTransfers(from, address(0), tokenId, 1);
1002 
1003         // Clear approvals from the previous owner.
1004         assembly {
1005             if approvedAddress {
1006                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1007                 sstore(approvedAddressSlot, 0)
1008             }
1009         }
1010 
1011         // Underflow of the sender's balance is impossible because we check for
1012         // ownership above and the recipient's balance can't realistically overflow.
1013         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1014         unchecked {
1015             // Updates:
1016             // - `balance -= 1`.
1017             // - `numberBurned += 1`.
1018             //
1019             // We can directly decrement the balance, and increment the number burned.
1020             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1021             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1022 
1023             // Updates:
1024             // - `address` to the last owner.
1025             // - `startTimestamp` to the timestamp of burning.
1026             // - `burned` to `true`.
1027             // - `nextInitialized` to `true`.
1028             _packedOwnerships[tokenId] = _packOwnershipData(
1029                 from,
1030                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1031             );
1032 
1033             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1034             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1035                 uint256 nextTokenId = tokenId + 1;
1036                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1037                 if (_packedOwnerships[nextTokenId] == 0) {
1038                     // If the next slot is within bounds.
1039                     if (nextTokenId != _currentIndex) {
1040                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1041                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1042                     }
1043                 }
1044             }
1045         }
1046 
1047         emit Transfer(from, address(0), tokenId);
1048         _afterTokenTransfers(from, address(0), tokenId, 1);
1049 
1050         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1051         unchecked {
1052             _burnCounter++;
1053         }
1054     }
1055 
1056     /**
1057      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1058      *
1059      * @param from address representing the previous owner of the given token ID
1060      * @param to target address that will receive the tokens
1061      * @param tokenId uint256 ID of the token to be transferred
1062      * @param _data bytes optional data to send along with the call
1063      * @return bool whether the call correctly returned the expected magic value
1064      */
1065     function _checkContractOnERC721Received(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) private returns (bool) {
1071         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1072             bytes4 retval
1073         ) {
1074             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1075         } catch (bytes memory reason) {
1076             if (reason.length == 0) {
1077                 revert TransferToNonERC721ReceiverImplementer();
1078             } else {
1079                 assembly {
1080                     revert(add(32, reason), mload(reason))
1081                 }
1082             }
1083         }
1084     }
1085 
1086     /**
1087      * @dev Directly sets the extra data for the ownership data `index`.
1088      */
1089     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1090         uint256 packed = _packedOwnerships[index];
1091         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1092         uint256 extraDataCasted;
1093         // Cast `extraData` with assembly to avoid redundant masking.
1094         assembly {
1095             extraDataCasted := extraData
1096         }
1097         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1098         _packedOwnerships[index] = packed;
1099     }
1100 
1101     /**
1102      * @dev Returns the next extra data for the packed ownership data.
1103      * The returned result is shifted into position.
1104      */
1105     function _nextExtraData(
1106         address from,
1107         address to,
1108         uint256 prevOwnershipPacked
1109     ) private view returns (uint256) {
1110         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1111         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1112     }
1113 
1114     /**
1115      * @dev Called during each token transfer to set the 24bit `extraData` field.
1116      * Intended to be overridden by the cosumer contract.
1117      *
1118      * `previousExtraData` - the value of `extraData` before transfer.
1119      *
1120      * Calling conditions:
1121      *
1122      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1123      * transferred to `to`.
1124      * - When `from` is zero, `tokenId` will be minted for `to`.
1125      * - When `to` is zero, `tokenId` will be burned by `from`.
1126      * - `from` and `to` are never both zero.
1127      */
1128     function _extraData(
1129         address from,
1130         address to,
1131         uint24 previousExtraData
1132     ) internal view virtual returns (uint24) {}
1133 
1134     /**
1135      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1136      * This includes minting.
1137      * And also called before burning one token.
1138      *
1139      * startTokenId - the first token id to be transferred
1140      * quantity - the amount to be transferred
1141      *
1142      * Calling conditions:
1143      *
1144      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1145      * transferred to `to`.
1146      * - When `from` is zero, `tokenId` will be minted for `to`.
1147      * - When `to` is zero, `tokenId` will be burned by `from`.
1148      * - `from` and `to` are never both zero.
1149      */
1150     function _beforeTokenTransfers(
1151         address from,
1152         address to,
1153         uint256 startTokenId,
1154         uint256 quantity
1155     ) internal virtual {}
1156 
1157     /**
1158      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1159      * This includes minting.
1160      * And also called after one token has been burned.
1161      *
1162      * startTokenId - the first token id to be transferred
1163      * quantity - the amount to be transferred
1164      *
1165      * Calling conditions:
1166      *
1167      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1168      * transferred to `to`.
1169      * - When `from` is zero, `tokenId` has been minted for `to`.
1170      * - When `to` is zero, `tokenId` has been burned by `from`.
1171      * - `from` and `to` are never both zero.
1172      */
1173     function _afterTokenTransfers(
1174         address from,
1175         address to,
1176         uint256 startTokenId,
1177         uint256 quantity
1178     ) internal virtual {}
1179 
1180     /**
1181      * @dev Returns the message sender (defaults to `msg.sender`).
1182      *
1183      * If you are writing GSN compatible contracts, you need to override this function.
1184      */
1185     function _msgSenderERC721A() internal view virtual returns (address) {
1186         return msg.sender;
1187     }
1188 
1189     /**
1190      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1191      */
1192     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1193         assembly {
1194             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1195             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1196             // We will need 1 32-byte word to store the length,
1197             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1198             ptr := add(mload(0x40), 128)
1199             // Update the free memory pointer to allocate.
1200             mstore(0x40, ptr)
1201 
1202             // Cache the end of the memory to calculate the length later.
1203             let end := ptr
1204 
1205             // We write the string from the rightmost digit to the leftmost digit.
1206             // The following is essentially a do-while loop that also handles the zero case.
1207             // Costs a bit more than early returning for the zero case,
1208             // but cheaper in terms of deployment and overall runtime costs.
1209             for {
1210                 // Initialize and perform the first pass without check.
1211                 let temp := value
1212                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1213                 ptr := sub(ptr, 1)
1214                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1215                 mstore8(ptr, add(48, mod(temp, 10)))
1216                 temp := div(temp, 10)
1217             } temp {
1218                 // Keep dividing `temp` until zero.
1219                 temp := div(temp, 10)
1220             } {
1221                 // Body of the for loop.
1222                 ptr := sub(ptr, 1)
1223                 mstore8(ptr, add(48, mod(temp, 10)))
1224             }
1225 
1226             let length := sub(end, ptr)
1227             // Move the pointer 32 bytes leftwards to make room for the length.
1228             ptr := sub(ptr, 32)
1229             // Store the length.
1230             mstore(ptr, length)
1231         }
1232     }
1233 }
1234 
1235 // File: @openzeppelin/contracts/utils/Context.sol
1236 
1237 
1238 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1239 
1240 pragma solidity ^0.8.0;
1241 
1242 /**
1243  * @dev Provides information about the current execution context, including the
1244  * sender of the transaction and its data. While these are generally available
1245  * via msg.sender and msg.data, they should not be accessed in such a direct
1246  * manner, since when dealing with meta-transactions the account sending and
1247  * paying for execution may not be the actual sender (as far as an application
1248  * is concerned).
1249  *
1250  * This contract is only required for intermediate, library-like contracts.
1251  */
1252 abstract contract Context {
1253     function _msgSender() internal view virtual returns (address) {
1254         return msg.sender;
1255     }
1256 
1257     function _msgData() internal view virtual returns (bytes calldata) {
1258         return msg.data;
1259     }
1260 }
1261 
1262 // File: @openzeppelin/contracts/access/Ownable.sol
1263 
1264 
1265 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1266 
1267 pragma solidity ^0.8.0;
1268 
1269 
1270 /**
1271  * @dev Contract module which provides a basic access control mechanism, where
1272  * there is an account (an owner) that can be granted exclusive access to
1273  * specific functions.
1274  *
1275  * By default, the owner account will be the one that deploys the contract. This
1276  * can later be changed with {transferOwnership}.
1277  *
1278  * This module is used through inheritance. It will make available the modifier
1279  * `onlyOwner`, which can be applied to your functions to restrict their use to
1280  * the owner.
1281  */
1282 abstract contract Ownable is Context {
1283     address private _owner;
1284 
1285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1286 
1287     /**
1288      * @dev Initializes the contract setting the deployer as the initial owner.
1289      */
1290     constructor() {
1291         _transferOwnership(_msgSender());
1292     }
1293 
1294     /**
1295      * @dev Throws if called by any account other than the owner.
1296      */
1297     modifier onlyOwner() {
1298         _checkOwner();
1299         _;
1300     }
1301 
1302     /**
1303      * @dev Returns the address of the current owner.
1304      */
1305     function owner() public view virtual returns (address) {
1306         return _owner;
1307     }
1308 
1309     /**
1310      * @dev Throws if the sender is not the owner.
1311      */
1312     function _checkOwner() internal view virtual {
1313         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1314     }
1315 
1316     /**
1317      * @dev Leaves the contract without owner. It will not be possible to call
1318      * `onlyOwner` functions anymore. Can only be called by the current owner.
1319      *
1320      * NOTE: Renouncing ownership will leave the contract without an owner,
1321      * thereby removing any functionality that is only available to the owner.
1322      */
1323     function renounceOwnership() public virtual onlyOwner {
1324         _transferOwnership(address(0));
1325     }
1326 
1327     /**
1328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1329      * Can only be called by the current owner.
1330      */
1331     function transferOwnership(address newOwner) public virtual onlyOwner {
1332         require(newOwner != address(0), "Ownable: new owner is the zero address");
1333         _transferOwnership(newOwner);
1334     }
1335 
1336     /**
1337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1338      * Internal function without access restriction.
1339      */
1340     function _transferOwnership(address newOwner) internal virtual {
1341         address oldOwner = _owner;
1342         _owner = newOwner;
1343         emit OwnershipTransferred(oldOwner, newOwner);
1344     }
1345 }
1346 
1347 // File: abortthebabies.sol
1348 
1349 
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 
1354 
1355 contract AbortedBabies is Ownable, ERC721A{
1356     uint256 public NftsToMint = 10000;
1357     uint256 public maxTokensPerWallet = 10;
1358     uint256 public maxFreePerWallet = 2;
1359     uint256 public mintPrice = 0.005 ether;
1360     string private _uri = "ipfs://QmTSM4cbGYjMu6MXYVNJP189BdgQxisfHQ6Hw23k2Azks1/";
1361     bool public saleActivity = true;
1362     
1363 
1364     constructor () ERC721A("AbortedBabies","ABB"){      
1365     }
1366 
1367     function mintAdmin (address account, uint256 amount) public onlyOwner{
1368         _safeMint(account , amount);
1369     }
1370     
1371     function mint (uint256 amount) public payable{
1372         require (saleActivity == true , "Not minting yet");
1373         require (amount + balanceOf(msg.sender) <= maxTokensPerWallet , "Max 10 per wallet");
1374         require (totalSupply() + amount <= NftsToMint , "Sold out");
1375 
1376         if (balanceOf(msg.sender)>1) {
1377             require (amount * mintPrice <= msg.value);
1378         }
1379 
1380         else if (balanceOf(msg.sender) == 1) {
1381             require ((amount-1) * mintPrice <= msg.value);
1382         }
1383 
1384         else if (balanceOf(msg.sender) == 0 && amount>2){
1385             require ((amount-2) * mintPrice <= msg.value);
1386         }
1387 
1388         _safeMint (msg.sender , amount, "");
1389     }
1390 
1391     
1392 
1393     function setSaleActivity(bool issaleon) public onlyOwner{
1394         saleActivity = issaleon;
1395     }
1396 
1397     function setMaxNftsToMint(uint256 maxnftstomint) public onlyOwner{
1398         NftsToMint = maxnftstomint;
1399     }
1400 
1401 
1402     function setMaxTokensPerWallet (uint256 tokens) public onlyOwner {
1403         maxTokensPerWallet = tokens;
1404     }
1405 
1406     function setMaxFreePerWallet (uint256 maxfree) public onlyOwner {
1407         maxFreePerWallet = maxfree;
1408     }
1409 
1410     function setMintPrice (uint256 newprice) public onlyOwner {
1411         mintPrice = newprice;
1412     }
1413 
1414     function setUri (string memory uri) public onlyOwner {
1415         _uri = uri;
1416     }
1417 
1418     function currentOwner () view public  {
1419         owner();
1420     }
1421 
1422     function TransferOwnership (address newOwner) public onlyOwner{
1423         _transferOwnership(newOwner);
1424     }
1425 
1426     function _baseURI() internal view override returns (string memory) {
1427        return _uri;
1428     }
1429 
1430 
1431     function getBalance() private view returns(uint256) {
1432         return address(this).balance;
1433     }
1434 
1435     function withdraw() public onlyOwner {
1436         address payable owner = payable(msg.sender);
1437         owner.transfer(getBalance());
1438     }
1439 }