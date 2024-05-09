1 // -- - - ---   
2 // -- - - ---   
3 // -- - - ---    ________  __    __  ________        __    __   ______   ______   ______   ________  _______  
4 // -- - - ---   /        |/  |  /  |/        |      /  \  /  | /      \ /      | /      \ /        |/       \ 
5 // -- - - ---   $$$$$$$$/ $$ |  $$ |$$$$$$$$/       $$  \ $$ |/$$$$$$  |$$$$$$/ /$$$$$$  |$$$$$$$$/ $$$$$$$  |
6 // -- - - ---      $$ |   $$ |__$$ |$$ |__          $$$  \$$ |$$ |  $$ |  $$ |  $$ \__$$/ $$ |__    $$ |__$$ |
7 // -- - - ---      $$ |   $$    $$ |$$    |         $$$$  $$ |$$ |  $$ |  $$ |  $$      \ $$    |   $$    $$< 
8 // -- - - ---      $$ |   $$$$$$$$ |$$$$$/          $$ $$ $$ |$$ |  $$ |  $$ |   $$$$$$  |$$$$$/    $$$$$$$  |
9 // -- - - ---      $$ |   $$ |  $$ |$$ |_____       $$ |$$$$ |$$ \__$$ | _$$ |_ /  \__$$ |$$ |_____ $$ |  $$ |
10 // -- - - ---      $$ |   $$ |  $$ |$$       |      $$ | $$$ |$$    $$/ / $$   |$$    $$/ $$       |$$ |  $$ |
11 // -- - - ---      $$/    $$/   $$/ $$$$$$$$/       $$/   $$/  $$$$$$/  $$$$$$/  $$$$$$/  $$$$$$$$/ $$/   $$/ 
12 // -- - - ---                                                                                                 
13 // -- - - ---                                                                                                 
14 // -- - - ---            
15 // SPDX-License-Identifier: MIT                                                                                     
16 
17 
18 // File: erc721a/contracts/IERC721A.sol
19 
20 
21 // ERC721A Contracts v4.1.0
22 // Creator: Chiru Labs
23 
24 pragma solidity ^0.8.4;
25 
26 /**
27  * @dev Interface of an ERC721A compliant contract.
28  */
29 interface IERC721A {
30     /**
31      * The caller must own the token or be an approved operator.
32      */
33     error ApprovalCallerNotOwnerNorApproved();
34 
35     /**
36      * The token does not exist.
37      */
38     error ApprovalQueryForNonexistentToken();
39 
40     /**
41      * The caller cannot approve to their own address.
42      */
43     error ApproveToCaller();
44 
45     /**
46      * Cannot query the balance for the zero address.
47      */
48     error BalanceQueryForZeroAddress();
49 
50     /**
51      * Cannot mint to the zero address.
52      */
53     error MintToZeroAddress();
54 
55     /**
56      * The quantity of tokens minted must be more than zero.
57      */
58     error MintZeroQuantity();
59 
60     /**
61      * The token does not exist.
62      */
63     error OwnerQueryForNonexistentToken();
64 
65     /**
66      * The caller must own the token or be an approved operator.
67      */
68     error TransferCallerNotOwnerNorApproved();
69 
70     /**
71      * The token must be owned by `from`.
72      */
73     error TransferFromIncorrectOwner();
74 
75     /**
76      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
77      */
78     error TransferToNonERC721ReceiverImplementer();
79 
80     /**
81      * Cannot transfer to the zero address.
82      */
83     error TransferToZeroAddress();
84 
85     /**
86      * The token does not exist.
87      */
88     error URIQueryForNonexistentToken();
89 
90     /**
91      * The `quantity` minted with ERC2309 exceeds the safety limit.
92      */
93     error MintERC2309QuantityExceedsLimit();
94 
95     /**
96      * The `extraData` cannot be set on an unintialized ownership slot.
97      */
98     error OwnershipNotInitializedForExtraData();
99 
100     struct TokenOwnership {
101         // The address of the owner.
102         address addr;
103         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
104         uint64 startTimestamp;
105         // Whether the token has been burned.
106         bool burned;
107         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
108         uint24 extraData;
109     }
110 
111     /**
112      * @dev Returns the total amount of tokens stored by the contract.
113      *
114      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     // ==============================
119     //            IERC165
120     // ==============================
121 
122     /**
123      * @dev Returns true if this contract implements the interface defined by
124      * `interfaceId`. See the corresponding
125      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
126      * to learn more about how these ids are created.
127      *
128      * This function call must use less than 30 000 gas.
129      */
130     function supportsInterface(bytes4 interfaceId) external view returns (bool);
131 
132     // ==============================
133     //            IERC721
134     // ==============================
135 
136     /**
137      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
143      */
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
148      */
149     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
150 
151     /**
152      * @dev Returns the number of tokens in ``owner``'s account.
153      */
154     function balanceOf(address owner) external view returns (uint256 balance);
155 
156     /**
157      * @dev Returns the owner of the `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function ownerOf(uint256 tokenId) external view returns (address owner);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`.
167      *
168      * Requirements:
169      *
170      * - `from` cannot be the zero address.
171      * - `to` cannot be the zero address.
172      * - `tokenId` token must exist and be owned by `from`.
173      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
174      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
175      *
176      * Emits a {Transfer} event.
177      */
178     function safeTransferFrom(
179         address from,
180         address to,
181         uint256 tokenId,
182         bytes calldata data
183     ) external;
184 
185     /**
186      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
187      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must exist and be owned by `from`.
194      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
196      *
197      * Emits a {Transfer} event.
198      */
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external;
204 
205     /**
206      * @dev Transfers `tokenId` token from `from` to `to`.
207      *
208      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
209      *
210      * Requirements:
211      *
212      * - `from` cannot be the zero address.
213      * - `to` cannot be the zero address.
214      * - `tokenId` token must be owned by `from`.
215      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) external;
224 
225     /**
226      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
227      * The approval is cleared when the token is transferred.
228      *
229      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
230      *
231      * Requirements:
232      *
233      * - The caller must own the token or be an approved operator.
234      * - `tokenId` must exist.
235      *
236      * Emits an {Approval} event.
237      */
238     function approve(address to, uint256 tokenId) external;
239 
240     /**
241      * @dev Approve or remove `operator` as an operator for the caller.
242      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
243      *
244      * Requirements:
245      *
246      * - The `operator` cannot be the caller.
247      *
248      * Emits an {ApprovalForAll} event.
249      */
250     function setApprovalForAll(address operator, bool _approved) external;
251 
252     /**
253      * @dev Returns the account approved for `tokenId` token.
254      *
255      * Requirements:
256      *
257      * - `tokenId` must exist.
258      */
259     function getApproved(uint256 tokenId) external view returns (address operator);
260 
261     /**
262      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
263      *
264      * See {setApprovalForAll}
265      */
266     function isApprovedForAll(address owner, address operator) external view returns (bool);
267 
268     // ==============================
269     //        IERC721Metadata
270     // ==============================
271 
272     /**
273      * @dev Returns the token collection name.
274      */
275     function name() external view returns (string memory);
276 
277     /**
278      * @dev Returns the token collection symbol.
279      */
280     function symbol() external view returns (string memory);
281 
282     /**
283      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
284      */
285     function tokenURI(uint256 tokenId) external view returns (string memory);
286 
287     // ==============================
288     //            IERC2309
289     // ==============================
290 
291     /**
292      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
293      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
294      */
295     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
296 }
297 
298 // File: erc721a/contracts/ERC721A.sol
299 
300 
301 // ERC721A Contracts v4.1.0
302 // Creator: Chiru Labs
303 
304 pragma solidity ^0.8.4;
305 
306 
307 /**
308  * @dev ERC721 token receiver interface.
309  */
310 interface ERC721A__IERC721Receiver {
311     function onERC721Received(
312         address operator,
313         address from,
314         uint256 tokenId,
315         bytes calldata data
316     ) external returns (bytes4);
317 }
318 
319 /**
320  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
321  * including the Metadata extension. Built to optimize for lower gas during batch mints.
322  *
323  * Assumes serials are sequentially minted starting at `_startTokenId()`
324  * (defaults to 0, e.g. 0, 1, 2, 3..).
325  *
326  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
327  *
328  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
329  */
330 contract ERC721A is IERC721A {
331     // Mask of an entry in packed address data.
332     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
333 
334     // The bit position of `numberMinted` in packed address data.
335     uint256 private constant BITPOS_NUMBER_MINTED = 64;
336 
337     // The bit position of `numberBurned` in packed address data.
338     uint256 private constant BITPOS_NUMBER_BURNED = 128;
339 
340     // The bit position of `aux` in packed address data.
341     uint256 private constant BITPOS_AUX = 192;
342 
343     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
344     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
345 
346     // The bit position of `startTimestamp` in packed ownership.
347     uint256 private constant BITPOS_START_TIMESTAMP = 160;
348 
349     // The bit mask of the `burned` bit in packed ownership.
350     uint256 private constant BITMASK_BURNED = 1 << 224;
351 
352     // The bit position of the `nextInitialized` bit in packed ownership.
353     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
354 
355     // The bit mask of the `nextInitialized` bit in packed ownership.
356     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
357 
358     // The bit position of `extraData` in packed ownership.
359     uint256 private constant BITPOS_EXTRA_DATA = 232;
360 
361     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
362     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
363 
364     // The mask of the lower 160 bits for addresses.
365     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
366 
367     // The maximum `quantity` that can be minted with `_mintERC2309`.
368     // This limit is to prevent overflows on the address data entries.
369     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
370     // is required to cause an overflow, which is unrealistic.
371     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
372 
373     // The tokenId of the next token to be minted.
374     uint256 private _currentIndex;
375 
376     // The number of tokens burned.
377     uint256 private _burnCounter;
378 
379     // Token name
380     string private _name;
381 
382     // Token symbol
383     string private _symbol;
384 
385     // Mapping from token ID to ownership details
386     // An empty struct value does not necessarily mean the token is unowned.
387     // See `_packedOwnershipOf` implementation for details.
388     //
389     // Bits Layout:
390     // - [0..159]   `addr`
391     // - [160..223] `startTimestamp`
392     // - [224]      `burned`
393     // - [225]      `nextInitialized`
394     // - [232..255] `extraData`
395     mapping(uint256 => uint256) private _packedOwnerships;
396 
397     // Mapping owner address to address data.
398     //
399     // Bits Layout:
400     // - [0..63]    `balance`
401     // - [64..127]  `numberMinted`
402     // - [128..191] `numberBurned`
403     // - [192..255] `aux`
404     mapping(address => uint256) private _packedAddressData;
405 
406     // Mapping from token ID to approved address.
407     mapping(uint256 => address) private _tokenApprovals;
408 
409     // Mapping from owner to operator approvals
410     mapping(address => mapping(address => bool)) private _operatorApprovals;
411 
412     constructor(string memory name_, string memory symbol_) {
413         _name = name_;
414         _symbol = symbol_;
415         _currentIndex = _startTokenId();
416     }
417 
418     /**
419      * @dev Returns the starting token ID.
420      * To change the starting token ID, please override this function.
421      */
422     function _startTokenId() internal view virtual returns (uint256) {
423         return 0;
424     }
425 
426     /**
427      * @dev Returns the next token ID to be minted.
428      */
429     function _nextTokenId() internal view returns (uint256) {
430         return _currentIndex;
431     }
432 
433     /**
434      * @dev Returns the total number of tokens in existence.
435      * Burned tokens will reduce the count.
436      * To get the total number of tokens minted, please see `_totalMinted`.
437      */
438     function totalSupply() public view override returns (uint256) {
439         // Counter underflow is impossible as _burnCounter cannot be incremented
440         // more than `_currentIndex - _startTokenId()` times.
441         unchecked {
442             return _currentIndex - _burnCounter - _startTokenId();
443         }
444     }
445 
446     /**
447      * @dev Returns the total amount of tokens minted in the contract.
448      */
449     function _totalMinted() internal view returns (uint256) {
450         // Counter underflow is impossible as _currentIndex does not decrement,
451         // and it is initialized to `_startTokenId()`
452         unchecked {
453             return _currentIndex - _startTokenId();
454         }
455     }
456 
457     /**
458      * @dev Returns the total number of tokens burned.
459      */
460     function _totalBurned() internal view returns (uint256) {
461         return _burnCounter;
462     }
463 
464     /**
465      * @dev See {IERC165-supportsInterface}.
466      */
467     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
468         // The interface IDs are constants representing the first 4 bytes of the XOR of
469         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
470         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
471         return
472             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
473             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
474             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
475     }
476 
477     /**
478      * @dev See {IERC721-balanceOf}.
479      */
480     function balanceOf(address owner) public view override returns (uint256) {
481         if (owner == address(0)) revert BalanceQueryForZeroAddress();
482         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
483     }
484 
485     /**
486      * Returns the number of tokens minted by `owner`.
487      */
488     function _numberMinted(address owner) internal view returns (uint256) {
489         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
490     }
491 
492     /**
493      * Returns the number of tokens burned by or on behalf of `owner`.
494      */
495     function _numberBurned(address owner) internal view returns (uint256) {
496         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
497     }
498 
499     /**
500      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
501      */
502     function _getAux(address owner) internal view returns (uint64) {
503         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
504     }
505 
506     /**
507      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
508      * If there are multiple variables, please pack them into a uint64.
509      */
510     function _setAux(address owner, uint64 aux) internal {
511         uint256 packed = _packedAddressData[owner];
512         uint256 auxCasted;
513         // Cast `aux` with assembly to avoid redundant masking.
514         assembly {
515             auxCasted := aux
516         }
517         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
518         _packedAddressData[owner] = packed;
519     }
520 
521     /**
522      * Returns the packed ownership data of `tokenId`.
523      */
524     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
525         uint256 curr = tokenId;
526 
527         unchecked {
528             if (_startTokenId() <= curr)
529                 if (curr < _currentIndex) {
530                     uint256 packed = _packedOwnerships[curr];
531                     // If not burned.
532                     if (packed & BITMASK_BURNED == 0) {
533                         // Invariant:
534                         // There will always be an ownership that has an address and is not burned
535                         // before an ownership that does not have an address and is not burned.
536                         // Hence, curr will not underflow.
537                         //
538                         // We can directly compare the packed value.
539                         // If the address is zero, packed is zero.
540                         while (packed == 0) {
541                             packed = _packedOwnerships[--curr];
542                         }
543                         return packed;
544                     }
545                 }
546         }
547         revert OwnerQueryForNonexistentToken();
548     }
549 
550     /**
551      * Returns the unpacked `TokenOwnership` struct from `packed`.
552      */
553     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
554         ownership.addr = address(uint160(packed));
555         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
556         ownership.burned = packed & BITMASK_BURNED != 0;
557         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
558     }
559 
560     /**
561      * Returns the unpacked `TokenOwnership` struct at `index`.
562      */
563     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
564         return _unpackedOwnership(_packedOwnerships[index]);
565     }
566 
567     /**
568      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
569      */
570     function _initializeOwnershipAt(uint256 index) internal {
571         if (_packedOwnerships[index] == 0) {
572             _packedOwnerships[index] = _packedOwnershipOf(index);
573         }
574     }
575 
576     /**
577      * Gas spent here starts off proportional to the maximum mint batch size.
578      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
579      */
580     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
581         return _unpackedOwnership(_packedOwnershipOf(tokenId));
582     }
583 
584     /**
585      * @dev Packs ownership data into a single uint256.
586      */
587     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
588         assembly {
589             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
590             owner := and(owner, BITMASK_ADDRESS)
591             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
592             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
593         }
594     }
595 
596     /**
597      * @dev See {IERC721-ownerOf}.
598      */
599     function ownerOf(uint256 tokenId) public view override returns (address) {
600         return address(uint160(_packedOwnershipOf(tokenId)));
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-name}.
605      */
606     function name() public view virtual override returns (string memory) {
607         return _name;
608     }
609 
610     /**
611      * @dev See {IERC721Metadata-symbol}.
612      */
613     function symbol() public view virtual override returns (string memory) {
614         return _symbol;
615     }
616 
617     /**
618      * @dev See {IERC721Metadata-tokenURI}.
619      */
620     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
621         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
622 
623         string memory baseURI = _baseURI();
624         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
625     }
626 
627     /**
628      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
629      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
630      * by default, it can be overridden in child contracts.
631      */
632     function _baseURI() internal view virtual returns (string memory) {
633         return '';
634     }
635 
636     /**
637      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
638      */
639     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
640         // For branchless setting of the `nextInitialized` flag.
641         assembly {
642             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
643             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
644         }
645     }
646 
647     /**
648      * @dev See {IERC721-approve}.
649      */
650     function approve(address to, uint256 tokenId) public override {
651         address owner = ownerOf(tokenId);
652 
653         if (_msgSenderERC721A() != owner)
654             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
655                 revert ApprovalCallerNotOwnerNorApproved();
656             }
657 
658         _tokenApprovals[tokenId] = to;
659         emit Approval(owner, to, tokenId);
660     }
661 
662     /**
663      * @dev See {IERC721-getApproved}.
664      */
665     function getApproved(uint256 tokenId) public view override returns (address) {
666         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
667 
668         return _tokenApprovals[tokenId];
669     }
670 
671     /**
672      * @dev See {IERC721-setApprovalForAll}.
673      */
674     function setApprovalForAll(address operator, bool approved) public virtual override {
675         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
676 
677         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
678         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
679     }
680 
681     /**
682      * @dev See {IERC721-isApprovedForAll}.
683      */
684     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
685         return _operatorApprovals[owner][operator];
686     }
687 
688     /**
689      * @dev See {IERC721-safeTransferFrom}.
690      */
691     function safeTransferFrom(
692         address from,
693         address to,
694         uint256 tokenId
695     ) public virtual override {
696         safeTransferFrom(from, to, tokenId, '');
697     }
698 
699     /**
700      * @dev See {IERC721-safeTransferFrom}.
701      */
702     function safeTransferFrom(
703         address from,
704         address to,
705         uint256 tokenId,
706         bytes memory _data
707     ) public virtual override {
708         transferFrom(from, to, tokenId);
709         if (to.code.length != 0)
710             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
711                 revert TransferToNonERC721ReceiverImplementer();
712             }
713     }
714 
715     /**
716      * @dev Returns whether `tokenId` exists.
717      *
718      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
719      *
720      * Tokens start existing when they are minted (`_mint`),
721      */
722     function _exists(uint256 tokenId) internal view returns (bool) {
723         return
724             _startTokenId() <= tokenId &&
725             tokenId < _currentIndex && // If within bounds,
726             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
727     }
728 
729     /**
730      * @dev Equivalent to `_safeMint(to, quantity, '')`.
731      */
732     function _safeMint(address to, uint256 quantity) internal {
733         _safeMint(to, quantity, '');
734     }
735 
736     /**
737      * @dev Safely mints `quantity` tokens and transfers them to `to`.
738      *
739      * Requirements:
740      *
741      * - If `to` refers to a smart contract, it must implement
742      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
743      * - `quantity` must be greater than 0.
744      *
745      * See {_mint}.
746      *
747      * Emits a {Transfer} event for each mint.
748      */
749     function _safeMint(
750         address to,
751         uint256 quantity,
752         bytes memory _data
753     ) internal {
754         _mint(to, quantity);
755 
756         unchecked {
757             if (to.code.length != 0) {
758                 uint256 end = _currentIndex;
759                 uint256 index = end - quantity;
760                 do {
761                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
762                         revert TransferToNonERC721ReceiverImplementer();
763                     }
764                 } while (index < end);
765                 // Reentrancy protection.
766                 if (_currentIndex != end) revert();
767             }
768         }
769     }
770 
771     /**
772      * @dev Mints `quantity` tokens and transfers them to `to`.
773      *
774      * Requirements:
775      *
776      * - `to` cannot be the zero address.
777      * - `quantity` must be greater than 0.
778      *
779      * Emits a {Transfer} event for each mint.
780      */
781     function _mint(address to, uint256 quantity) internal {
782         uint256 startTokenId = _currentIndex;
783         if (to == address(0)) revert MintToZeroAddress();
784         if (quantity == 0) revert MintZeroQuantity();
785 
786         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
787 
788         // Overflows are incredibly unrealistic.
789         // `balance` and `numberMinted` have a maximum limit of 2**64.
790         // `tokenId` has a maximum limit of 2**256.
791         unchecked {
792             // Updates:
793             // - `balance += quantity`.
794             // - `numberMinted += quantity`.
795             //
796             // We can directly add to the `balance` and `numberMinted`.
797             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
798 
799             // Updates:
800             // - `address` to the owner.
801             // - `startTimestamp` to the timestamp of minting.
802             // - `burned` to `false`.
803             // - `nextInitialized` to `quantity == 1`.
804             _packedOwnerships[startTokenId] = _packOwnershipData(
805                 to,
806                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
807             );
808 
809             uint256 tokenId = startTokenId;
810             uint256 end = startTokenId + quantity;
811             do {
812                 emit Transfer(address(0), to, tokenId++);
813             } while (tokenId < end);
814 
815             _currentIndex = end;
816         }
817         _afterTokenTransfers(address(0), to, startTokenId, quantity);
818     }
819 
820     /**
821      * @dev Mints `quantity` tokens and transfers them to `to`.
822      *
823      * This function is intended for efficient minting only during contract creation.
824      *
825      * It emits only one {ConsecutiveTransfer} as defined in
826      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
827      * instead of a sequence of {Transfer} event(s).
828      *
829      * Calling this function outside of contract creation WILL make your contract
830      * non-compliant with the ERC721 standard.
831      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
832      * {ConsecutiveTransfer} event is only permissible during contract creation.
833      *
834      * Requirements:
835      *
836      * - `to` cannot be the zero address.
837      * - `quantity` must be greater than 0.
838      *
839      * Emits a {ConsecutiveTransfer} event.
840      */
841     function _mintERC2309(address to, uint256 quantity) internal {
842         uint256 startTokenId = _currentIndex;
843         if (to == address(0)) revert MintToZeroAddress();
844         if (quantity == 0) revert MintZeroQuantity();
845         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
846 
847         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
848 
849         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
850         unchecked {
851             // Updates:
852             // - `balance += quantity`.
853             // - `numberMinted += quantity`.
854             //
855             // We can directly add to the `balance` and `numberMinted`.
856             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
857 
858             // Updates:
859             // - `address` to the owner.
860             // - `startTimestamp` to the timestamp of minting.
861             // - `burned` to `false`.
862             // - `nextInitialized` to `quantity == 1`.
863             _packedOwnerships[startTokenId] = _packOwnershipData(
864                 to,
865                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
866             );
867 
868             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
869 
870             _currentIndex = startTokenId + quantity;
871         }
872         _afterTokenTransfers(address(0), to, startTokenId, quantity);
873     }
874 
875     /**
876      * @dev Returns the storage slot and value for the approved address of `tokenId`.
877      */
878     function _getApprovedAddress(uint256 tokenId)
879         private
880         view
881         returns (uint256 approvedAddressSlot, address approvedAddress)
882     {
883         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
884         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
885         assembly {
886             // Compute the slot.
887             mstore(0x00, tokenId)
888             mstore(0x20, tokenApprovalsPtr.slot)
889             approvedAddressSlot := keccak256(0x00, 0x40)
890             // Load the slot's value from storage.
891             approvedAddress := sload(approvedAddressSlot)
892         }
893     }
894 
895     /**
896      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
897      */
898     function _isOwnerOrApproved(
899         address approvedAddress,
900         address from,
901         address msgSender
902     ) private pure returns (bool result) {
903         assembly {
904             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
905             from := and(from, BITMASK_ADDRESS)
906             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
907             msgSender := and(msgSender, BITMASK_ADDRESS)
908             // `msgSender == from || msgSender == approvedAddress`.
909             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
910         }
911     }
912 
913     /**
914      * @dev Transfers `tokenId` from `from` to `to`.
915      *
916      * Requirements:
917      *
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must be owned by `from`.
920      *
921      * Emits a {Transfer} event.
922      */
923     function transferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public virtual override {
928         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
929 
930         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
931 
932         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
933 
934         // The nested ifs save around 20+ gas over a compound boolean condition.
935         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
936             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
937 
938         if (to == address(0)) revert TransferToZeroAddress();
939 
940         _beforeTokenTransfers(from, to, tokenId, 1);
941 
942         // Clear approvals from the previous owner.
943         assembly {
944             if approvedAddress {
945                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
946                 sstore(approvedAddressSlot, 0)
947             }
948         }
949 
950         // Underflow of the sender's balance is impossible because we check for
951         // ownership above and the recipient's balance can't realistically overflow.
952         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
953         unchecked {
954             // We can directly increment and decrement the balances.
955             --_packedAddressData[from]; // Updates: `balance -= 1`.
956             ++_packedAddressData[to]; // Updates: `balance += 1`.
957 
958             // Updates:
959             // - `address` to the next owner.
960             // - `startTimestamp` to the timestamp of transfering.
961             // - `burned` to `false`.
962             // - `nextInitialized` to `true`.
963             _packedOwnerships[tokenId] = _packOwnershipData(
964                 to,
965                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
966             );
967 
968             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
969             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
970                 uint256 nextTokenId = tokenId + 1;
971                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
972                 if (_packedOwnerships[nextTokenId] == 0) {
973                     // If the next slot is within bounds.
974                     if (nextTokenId != _currentIndex) {
975                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
976                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
977                     }
978                 }
979             }
980         }
981 
982         emit Transfer(from, to, tokenId);
983         _afterTokenTransfers(from, to, tokenId, 1);
984     }
985 
986     /**
987      * @dev Equivalent to `_burn(tokenId, false)`.
988      */
989     function _burn(uint256 tokenId) internal virtual {
990         _burn(tokenId, false);
991     }
992 
993     /**
994      * @dev Destroys `tokenId`.
995      * The approval is cleared when the token is burned.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1004         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1005 
1006         address from = address(uint160(prevOwnershipPacked));
1007 
1008         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1009 
1010         if (approvalCheck) {
1011             // The nested ifs save around 20+ gas over a compound boolean condition.
1012             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1013                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1014         }
1015 
1016         _beforeTokenTransfers(from, address(0), tokenId, 1);
1017 
1018         // Clear approvals from the previous owner.
1019         assembly {
1020             if approvedAddress {
1021                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1022                 sstore(approvedAddressSlot, 0)
1023             }
1024         }
1025 
1026         // Underflow of the sender's balance is impossible because we check for
1027         // ownership above and the recipient's balance can't realistically overflow.
1028         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1029         unchecked {
1030             // Updates:
1031             // - `balance -= 1`.
1032             // - `numberBurned += 1`.
1033             //
1034             // We can directly decrement the balance, and increment the number burned.
1035             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1036             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1037 
1038             // Updates:
1039             // - `address` to the last owner.
1040             // - `startTimestamp` to the timestamp of burning.
1041             // - `burned` to `true`.
1042             // - `nextInitialized` to `true`.
1043             _packedOwnerships[tokenId] = _packOwnershipData(
1044                 from,
1045                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1046             );
1047 
1048             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1049             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1050                 uint256 nextTokenId = tokenId + 1;
1051                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1052                 if (_packedOwnerships[nextTokenId] == 0) {
1053                     // If the next slot is within bounds.
1054                     if (nextTokenId != _currentIndex) {
1055                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1056                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1057                     }
1058                 }
1059             }
1060         }
1061 
1062         emit Transfer(from, address(0), tokenId);
1063         _afterTokenTransfers(from, address(0), tokenId, 1);
1064 
1065         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1066         unchecked {
1067             _burnCounter++;
1068         }
1069     }
1070 
1071     /**
1072      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1073      *
1074      * @param from address representing the previous owner of the given token ID
1075      * @param to target address that will receive the tokens
1076      * @param tokenId uint256 ID of the token to be transferred
1077      * @param _data bytes optional data to send along with the call
1078      * @return bool whether the call correctly returned the expected magic value
1079      */
1080     function _checkContractOnERC721Received(
1081         address from,
1082         address to,
1083         uint256 tokenId,
1084         bytes memory _data
1085     ) private returns (bool) {
1086         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1087             bytes4 retval
1088         ) {
1089             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1090         } catch (bytes memory reason) {
1091             if (reason.length == 0) {
1092                 revert TransferToNonERC721ReceiverImplementer();
1093             } else {
1094                 assembly {
1095                     revert(add(32, reason), mload(reason))
1096                 }
1097             }
1098         }
1099     }
1100 
1101     /**
1102      * @dev Directly sets the extra data for the ownership data `index`.
1103      */
1104     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1105         uint256 packed = _packedOwnerships[index];
1106         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1107         uint256 extraDataCasted;
1108         // Cast `extraData` with assembly to avoid redundant masking.
1109         assembly {
1110             extraDataCasted := extraData
1111         }
1112         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1113         _packedOwnerships[index] = packed;
1114     }
1115 
1116     /**
1117      * @dev Returns the next extra data for the packed ownership data.
1118      * The returned result is shifted into position.
1119      */
1120     function _nextExtraData(
1121         address from,
1122         address to,
1123         uint256 prevOwnershipPacked
1124     ) private view returns (uint256) {
1125         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1126         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1127     }
1128 
1129     /**
1130      * @dev Called during each token transfer to set the 24bit `extraData` field.
1131      * Intended to be overridden by the cosumer contract.
1132      *
1133      * `previousExtraData` - the value of `extraData` before transfer.
1134      *
1135      * Calling conditions:
1136      *
1137      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1138      * transferred to `to`.
1139      * - When `from` is zero, `tokenId` will be minted for `to`.
1140      * - When `to` is zero, `tokenId` will be burned by `from`.
1141      * - `from` and `to` are never both zero.
1142      */
1143     function _extraData(
1144         address from,
1145         address to,
1146         uint24 previousExtraData
1147     ) internal view virtual returns (uint24) {}
1148 
1149     /**
1150      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1151      * This includes minting.
1152      * And also called before burning one token.
1153      *
1154      * startTokenId - the first token id to be transferred
1155      * quantity - the amount to be transferred
1156      *
1157      * Calling conditions:
1158      *
1159      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1160      * transferred to `to`.
1161      * - When `from` is zero, `tokenId` will be minted for `to`.
1162      * - When `to` is zero, `tokenId` will be burned by `from`.
1163      * - `from` and `to` are never both zero.
1164      */
1165     function _beforeTokenTransfers(
1166         address from,
1167         address to,
1168         uint256 startTokenId,
1169         uint256 quantity
1170     ) internal virtual {}
1171 
1172     /**
1173      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1174      * This includes minting.
1175      * And also called after one token has been burned.
1176      *
1177      * startTokenId - the first token id to be transferred
1178      * quantity - the amount to be transferred
1179      *
1180      * Calling conditions:
1181      *
1182      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1183      * transferred to `to`.
1184      * - When `from` is zero, `tokenId` has been minted for `to`.
1185      * - When `to` is zero, `tokenId` has been burned by `from`.
1186      * - `from` and `to` are never both zero.
1187      */
1188     function _afterTokenTransfers(
1189         address from,
1190         address to,
1191         uint256 startTokenId,
1192         uint256 quantity
1193     ) internal virtual {}
1194 
1195     /**
1196      * @dev Returns the message sender (defaults to `msg.sender`).
1197      *
1198      * If you are writing GSN compatible contracts, you need to override this function.
1199      */
1200     function _msgSenderERC721A() internal view virtual returns (address) {
1201         return msg.sender;
1202     }
1203 
1204     /**
1205      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1206      */
1207     function _toString(uint256 value) internal pure returns (string memory ptr) {
1208         assembly {
1209             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1210             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1211             // We will need 1 32-byte word to store the length,
1212             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1213             ptr := add(mload(0x40), 128)
1214             // Update the free memory pointer to allocate.
1215             mstore(0x40, ptr)
1216 
1217             // Cache the end of the memory to calculate the length later.
1218             let end := ptr
1219 
1220             // We write the string from the rightmost digit to the leftmost digit.
1221             // The following is essentially a do-while loop that also handles the zero case.
1222             // Costs a bit more than early returning for the zero case,
1223             // but cheaper in terms of deployment and overall runtime costs.
1224             for {
1225                 // Initialize and perform the first pass without check.
1226                 let temp := value
1227                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1228                 ptr := sub(ptr, 1)
1229                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1230                 mstore8(ptr, add(48, mod(temp, 10)))
1231                 temp := div(temp, 10)
1232             } temp {
1233                 // Keep dividing `temp` until zero.
1234                 temp := div(temp, 10)
1235             } {
1236                 // Body of the for loop.
1237                 ptr := sub(ptr, 1)
1238                 mstore8(ptr, add(48, mod(temp, 10)))
1239             }
1240 
1241             let length := sub(end, ptr)
1242             // Move the pointer 32 bytes leftwards to make room for the length.
1243             ptr := sub(ptr, 32)
1244             // Store the length.
1245             mstore(ptr, length)
1246         }
1247     }
1248 }
1249 
1250 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1251 
1252 
1253 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1254 
1255 pragma solidity ^0.8.0;
1256 
1257 /**
1258  * @dev Contract module that helps prevent reentrant calls to a function.
1259  *
1260  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1261  * available, which can be applied to functions to make sure there are no nested
1262  * (reentrant) calls to them.
1263  *
1264  * Note that because there is a single `nonReentrant` guard, functions marked as
1265  * `nonReentrant` may not call one another. This can be worked around by making
1266  * those functions `private`, and then adding `external` `nonReentrant` entry
1267  * points to them.
1268  *
1269  * TIP: If you would like to learn more about reentrancy and alternative ways
1270  * to protect against it, check out our blog post
1271  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1272  */
1273 abstract contract ReentrancyGuard {
1274     // Booleans are more expensive than uint256 or any type that takes up a full
1275     // word because each write operation emits an extra SLOAD to first read the
1276     // slot's contents, replace the bits taken up by the boolean, and then write
1277     // back. This is the compiler's defense against contract upgrades and
1278     // pointer aliasing, and it cannot be disabled.
1279 
1280     // The values being non-zero value makes deployment a bit more expensive,
1281     // but in exchange the refund on every call to nonReentrant will be lower in
1282     // amount. Since refunds are capped to a percentage of the total
1283     // transaction's gas, it is best to keep them low in cases like this one, to
1284     // increase the likelihood of the full refund coming into effect.
1285     uint256 private constant _NOT_ENTERED = 1;
1286     uint256 private constant _ENTERED = 2;
1287 
1288     uint256 private _status;
1289 
1290     constructor() {
1291         _status = _NOT_ENTERED;
1292     }
1293 
1294     /**
1295      * @dev Prevents a contract from calling itself, directly or indirectly.
1296      * Calling a `nonReentrant` function from another `nonReentrant`
1297      * function is not supported. It is possible to prevent this from happening
1298      * by making the `nonReentrant` function external, and making it call a
1299      * `private` function that does the actual work.
1300      */
1301     modifier nonReentrant() {
1302         // On the first call to nonReentrant, _notEntered will be true
1303         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1304 
1305         // Any calls to nonReentrant after this point will fail
1306         _status = _ENTERED;
1307 
1308         _;
1309 
1310         // By storing the original value once again, a refund is triggered (see
1311         // https://eips.ethereum.org/EIPS/eip-2200)
1312         _status = _NOT_ENTERED;
1313     }
1314 }
1315 
1316 // File: @openzeppelin/contracts/utils/Context.sol
1317 
1318 
1319 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1320 
1321 pragma solidity ^0.8.0;
1322 
1323 /**
1324  * @dev Provides information about the current execution context, including the
1325  * sender of the transaction and its data. While these are generally available
1326  * via msg.sender and msg.data, they should not be accessed in such a direct
1327  * manner, since when dealing with meta-transactions the account sending and
1328  * paying for execution may not be the actual sender (as far as an application
1329  * is concerned).
1330  *
1331  * This contract is only required for intermediate, library-like contracts.
1332  */
1333 abstract contract Context {
1334     function _msgSender() internal view virtual returns (address) {
1335         return msg.sender;
1336     }
1337 
1338     function _msgData() internal view virtual returns (bytes calldata) {
1339         return msg.data;
1340     }
1341 }
1342 
1343 // File: @openzeppelin/contracts/access/Ownable.sol
1344 
1345 
1346 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1347 
1348 pragma solidity ^0.8.0;
1349 
1350 
1351 /**
1352  * @dev Contract module which provides a basic access control mechanism, where
1353  * there is an account (an owner) that can be granted exclusive access to
1354  * specific functions.
1355  *
1356  * By default, the owner account will be the one that deploys the contract. This
1357  * can later be changed with {transferOwnership}.
1358  *
1359  * This module is used through inheritance. It will make available the modifier
1360  * `onlyOwner`, which can be applied to your functions to restrict their use to
1361  * the owner.
1362  */
1363 abstract contract Ownable is Context {
1364     address private _owner;
1365 
1366     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1367 
1368     /**
1369      * @dev Initializes the contract setting the deployer as the initial owner.
1370      */
1371     constructor() {
1372         _transferOwnership(_msgSender());
1373     }
1374 
1375     /**
1376      * @dev Throws if called by any account other than the owner.
1377      */
1378     modifier onlyOwner() {
1379         _checkOwner();
1380         _;
1381     }
1382 
1383     /**
1384      * @dev Returns the address of the current owner.
1385      */
1386     function owner() public view virtual returns (address) {
1387         return _owner;
1388     }
1389 
1390     /**
1391      * @dev Throws if the sender is not the owner.
1392      */
1393     function _checkOwner() internal view virtual {
1394         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1395     }
1396 
1397     /**
1398      * @dev Leaves the contract without owner. It will not be possible to call
1399      * `onlyOwner` functions anymore. Can only be called by the current owner.
1400      *
1401      * NOTE: Renouncing ownership will leave the contract without an owner,
1402      * thereby removing any functionality that is only available to the owner.
1403      */
1404     function renounceOwnership() public virtual onlyOwner {
1405         _transferOwnership(address(0));
1406     }
1407 
1408     /**
1409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1410      * Can only be called by the current owner.
1411      */
1412     function transferOwnership(address newOwner) public virtual onlyOwner {
1413         require(newOwner != address(0), "Ownable: new owner is the zero address");
1414         _transferOwnership(newOwner);
1415     }
1416 
1417     /**
1418      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1419      * Internal function without access restriction.
1420      */
1421     function _transferOwnership(address newOwner) internal virtual {
1422         address oldOwner = _owner;
1423         _owner = newOwner;
1424         emit OwnershipTransferred(oldOwner, newOwner);
1425     }
1426 }
1427 
1428 // File: contracts/noiser.sol
1429 
1430 pragma solidity ^0.8.4;
1431 
1432 
1433 
1434 
1435 
1436 contract TheNoiser is Ownable, ERC721A, ReentrancyGuard {
1437     constructor() ERC721A("TheNoiser", "NOISER") {
1438         theNoiserSetting.price = 5000000000000000;
1439         theNoiserSetting.maxSupply = 10000;
1440         theNoiserSetting.maxMint = 5;
1441     }
1442 
1443     struct TheNoiserSetting {
1444         uint256 price;
1445         uint256 maxMint;
1446         uint256 maxSupply;
1447     }
1448 
1449     mapping(address => uint256) public minted;
1450     TheNoiserSetting public theNoiserSetting;
1451 
1452     function mint(uint256 quantity) external payable {
1453         TheNoiserSetting memory config = theNoiserSetting;
1454         uint256 price = uint256(config.price);
1455         uint256 maxMint = uint256(config.maxMint);
1456         uint256 buyed = getAddressBuyed(msg.sender);
1457 
1458         require(buyed == 0, "Unable to mint");
1459 
1460         require(
1461             totalSupply() + quantity <= getMaxSupply(),
1462             "Sold out."
1463         );
1464     
1465         require(
1466             buyed + quantity <= maxMint,
1467             "Exceed maxmium mint."
1468         );
1469 
1470         bool requirePay = quantity > 1 ? true : false;
1471         if (requirePay) {
1472             uint256 finalPrice = (quantity - 1) * price;
1473             
1474             require(
1475                 finalPrice <= msg.value,
1476                 "No enough eth."
1477             );
1478         }
1479 
1480         _safeMint(msg.sender, quantity);
1481         minted[msg.sender] += quantity;
1482     }
1483 
1484     function makeTheNoiser(uint256 quantity) external onlyOwner {
1485         require(
1486             totalSupply() + quantity <= getMaxSupply(),
1487             "Sold out."
1488         );
1489 
1490         _safeMint(msg.sender, quantity);
1491     }
1492 
1493     function getAddressBuyed(address owner) public view returns (uint256) {
1494         return minted[owner];
1495     }
1496     
1497     function getMaxSupply() private view returns (uint256) {
1498         TheNoiserSetting memory config = theNoiserSetting;
1499         uint256 max = uint256(config.maxSupply);
1500         return max;
1501     }
1502 
1503     string private _baseTokenURI;
1504 
1505     function _baseURI() internal view virtual override returns (string memory) {
1506         return _baseTokenURI;
1507     }
1508 
1509     function setURI(string calldata baseURI) external onlyOwner {
1510         _baseTokenURI = baseURI;
1511     }
1512 
1513     function setPrice(uint256 _price) external onlyOwner {
1514         theNoiserSetting.price = _price;
1515     }
1516 
1517     function withdraw() external onlyOwner nonReentrant {
1518         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1519         require(success, "...");
1520     }
1521 }