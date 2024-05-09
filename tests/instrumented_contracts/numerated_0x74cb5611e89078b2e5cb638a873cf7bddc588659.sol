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
281 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
282 
283 
284 // ERC721A Contracts v4.1.0
285 // Creator: Chiru Labs
286 
287 pragma solidity ^0.8.4;
288 
289 
290 /**
291  * @dev Interface of an ERC721AQueryable compliant contract.
292  */
293 interface IERC721AQueryable is IERC721A {
294     /**
295      * Invalid query range (`start` >= `stop`).
296      */
297     error InvalidQueryRange();
298 
299     /**
300      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
301      *
302      * If the `tokenId` is out of bounds:
303      *   - `addr` = `address(0)`
304      *   - `startTimestamp` = `0`
305      *   - `burned` = `false`
306      *
307      * If the `tokenId` is burned:
308      *   - `addr` = `<Address of owner before token was burned>`
309      *   - `startTimestamp` = `<Timestamp when token was burned>`
310      *   - `burned = `true`
311      *
312      * Otherwise:
313      *   - `addr` = `<Address of owner>`
314      *   - `startTimestamp` = `<Timestamp of start of ownership>`
315      *   - `burned = `false`
316      */
317     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
318 
319     /**
320      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
321      * See {ERC721AQueryable-explicitOwnershipOf}
322      */
323     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
324 
325     /**
326      * @dev Returns an array of token IDs owned by `owner`,
327      * in the range [`start`, `stop`)
328      * (i.e. `start <= tokenId < stop`).
329      *
330      * This function allows for tokens to be queried if the collection
331      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
332      *
333      * Requirements:
334      *
335      * - `start` < `stop`
336      */
337     function tokensOfOwnerIn(
338         address owner,
339         uint256 start,
340         uint256 stop
341     ) external view returns (uint256[] memory);
342 
343     /**
344      * @dev Returns an array of token IDs owned by `owner`.
345      *
346      * This function scans the ownership mapping and is O(totalSupply) in complexity.
347      * It is meant to be called off-chain.
348      *
349      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
350      * multiple smaller scans if the collection is large enough to cause
351      * an out-of-gas error (10K pfp collections should be fine).
352      */
353     function tokensOfOwner(address owner) external view returns (uint256[] memory);
354 }
355 
356 // File: erc721a/contracts/interfaces/IERC721A.sol
357 
358 
359 // ERC721A Contracts v4.1.0
360 // Creator: Chiru Labs
361 
362 pragma solidity ^0.8.4;
363 
364 
365 // File: erc721a/contracts/ERC721A.sol
366 
367 
368 // ERC721A Contracts v4.1.0
369 // Creator: Chiru Labs
370 
371 pragma solidity ^0.8.4;
372 
373 
374 /**
375  * @dev ERC721 token receiver interface.
376  */
377 interface ERC721A__IERC721Receiver {
378     function onERC721Received(
379         address operator,
380         address from,
381         uint256 tokenId,
382         bytes calldata data
383     ) external returns (bytes4);
384 }
385 
386 /**
387  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
388  * including the Metadata extension. Built to optimize for lower gas during batch mints.
389  *
390  * Assumes serials are sequentially minted starting at `_startTokenId()`
391  * (defaults to 0, e.g. 0, 1, 2, 3..).
392  *
393  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
394  *
395  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
396  */
397 contract ERC721A is IERC721A {
398     // Mask of an entry in packed address data.
399     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
400 
401     // The bit position of `numberMinted` in packed address data.
402     uint256 private constant BITPOS_NUMBER_MINTED = 64;
403 
404     // The bit position of `numberBurned` in packed address data.
405     uint256 private constant BITPOS_NUMBER_BURNED = 128;
406 
407     // The bit position of `aux` in packed address data.
408     uint256 private constant BITPOS_AUX = 192;
409 
410     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
411     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
412 
413     // The bit position of `startTimestamp` in packed ownership.
414     uint256 private constant BITPOS_START_TIMESTAMP = 160;
415 
416     // The bit mask of the `burned` bit in packed ownership.
417     uint256 private constant BITMASK_BURNED = 1 << 224;
418 
419     // The bit position of the `nextInitialized` bit in packed ownership.
420     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
421 
422     // The bit mask of the `nextInitialized` bit in packed ownership.
423     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
424 
425     // The bit position of `extraData` in packed ownership.
426     uint256 private constant BITPOS_EXTRA_DATA = 232;
427 
428     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
429     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
430 
431     // The mask of the lower 160 bits for addresses.
432     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
433 
434     // The maximum `quantity` that can be minted with `_mintERC2309`.
435     // This limit is to prevent overflows on the address data entries.
436     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
437     // is required to cause an overflow, which is unrealistic.
438     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
439 
440     // The tokenId of the next token to be minted.
441     uint256 private _currentIndex;
442 
443     // The number of tokens burned.
444     uint256 private _burnCounter;
445 
446     // Token name
447     string private _name;
448 
449     // Token symbol
450     string private _symbol;
451 
452     // Mapping from token ID to ownership details
453     // An empty struct value does not necessarily mean the token is unowned.
454     // See `_packedOwnershipOf` implementation for details.
455     //
456     // Bits Layout:
457     // - [0..159]   `addr`
458     // - [160..223] `startTimestamp`
459     // - [224]      `burned`
460     // - [225]      `nextInitialized`
461     // - [232..255] `extraData`
462     mapping(uint256 => uint256) private _packedOwnerships;
463 
464     // Mapping owner address to address data.
465     //
466     // Bits Layout:
467     // - [0..63]    `balance`
468     // - [64..127]  `numberMinted`
469     // - [128..191] `numberBurned`
470     // - [192..255] `aux`
471     mapping(address => uint256) private _packedAddressData;
472 
473     // Mapping from token ID to approved address.
474     mapping(uint256 => address) private _tokenApprovals;
475 
476     // Mapping from owner to operator approvals
477     mapping(address => mapping(address => bool)) private _operatorApprovals;
478 
479     constructor(string memory name_, string memory symbol_) {
480         _name = name_;
481         _symbol = symbol_;
482         _currentIndex = _startTokenId();
483     }
484 
485     /**
486      * @dev Returns the starting token ID.
487      * To change the starting token ID, please override this function.
488      */
489     function _startTokenId() internal view virtual returns (uint256) {
490         return 0;
491     }
492 
493     /**
494      * @dev Returns the next token ID to be minted.
495      */
496     function _nextTokenId() internal view returns (uint256) {
497         return _currentIndex;
498     }
499 
500     /**
501      * @dev Returns the total number of tokens in existence.
502      * Burned tokens will reduce the count.
503      * To get the total number of tokens minted, please see `_totalMinted`.
504      */
505     function totalSupply() public view override returns (uint256) {
506         // Counter underflow is impossible as _burnCounter cannot be incremented
507         // more than `_currentIndex - _startTokenId()` times.
508         unchecked {
509             return _currentIndex - _burnCounter - _startTokenId();
510         }
511     }
512 
513     /**
514      * @dev Returns the total amount of tokens minted in the contract.
515      */
516     function _totalMinted() internal view returns (uint256) {
517         // Counter underflow is impossible as _currentIndex does not decrement,
518         // and it is initialized to `_startTokenId()`
519         unchecked {
520             return _currentIndex - _startTokenId();
521         }
522     }
523 
524     /**
525      * @dev Returns the total number of tokens burned.
526      */
527     function _totalBurned() internal view returns (uint256) {
528         return _burnCounter;
529     }
530 
531     /**
532      * @dev See {IERC165-supportsInterface}.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         // The interface IDs are constants representing the first 4 bytes of the XOR of
536         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
537         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
538         return
539             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
540             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
541             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
542     }
543 
544     /**
545      * @dev See {IERC721-balanceOf}.
546      */
547     function balanceOf(address owner) public view override returns (uint256) {
548         if (owner == address(0)) revert BalanceQueryForZeroAddress();
549         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
550     }
551 
552     /**
553      * Returns the number of tokens minted by `owner`.
554      */
555     function _numberMinted(address owner) internal view returns (uint256) {
556         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
557     }
558 
559     /**
560      * Returns the number of tokens burned by or on behalf of `owner`.
561      */
562     function _numberBurned(address owner) internal view returns (uint256) {
563         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
564     }
565 
566     /**
567      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
568      */
569     function _getAux(address owner) internal view returns (uint64) {
570         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
571     }
572 
573     /**
574      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
575      * If there are multiple variables, please pack them into a uint64.
576      */
577     function _setAux(address owner, uint64 aux) internal {
578         uint256 packed = _packedAddressData[owner];
579         uint256 auxCasted;
580         // Cast `aux` with assembly to avoid redundant masking.
581         assembly {
582             auxCasted := aux
583         }
584         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
585         _packedAddressData[owner] = packed;
586     }
587 
588     /**
589      * Returns the packed ownership data of `tokenId`.
590      */
591     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
592         uint256 curr = tokenId;
593 
594         unchecked {
595             if (_startTokenId() <= curr)
596                 if (curr < _currentIndex) {
597                     uint256 packed = _packedOwnerships[curr];
598                     // If not burned.
599                     if (packed & BITMASK_BURNED == 0) {
600                         // Invariant:
601                         // There will always be an ownership that has an address and is not burned
602                         // before an ownership that does not have an address and is not burned.
603                         // Hence, curr will not underflow.
604                         //
605                         // We can directly compare the packed value.
606                         // If the address is zero, packed is zero.
607                         while (packed == 0) {
608                             packed = _packedOwnerships[--curr];
609                         }
610                         return packed;
611                     }
612                 }
613         }
614         revert OwnerQueryForNonexistentToken();
615     }
616 
617     /**
618      * Returns the unpacked `TokenOwnership` struct from `packed`.
619      */
620     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
621         ownership.addr = address(uint160(packed));
622         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
623         ownership.burned = packed & BITMASK_BURNED != 0;
624         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
625     }
626 
627     /**
628      * Returns the unpacked `TokenOwnership` struct at `index`.
629      */
630     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
631         return _unpackedOwnership(_packedOwnerships[index]);
632     }
633 
634     /**
635      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
636      */
637     function _initializeOwnershipAt(uint256 index) internal {
638         if (_packedOwnerships[index] == 0) {
639             _packedOwnerships[index] = _packedOwnershipOf(index);
640         }
641     }
642 
643     /**
644      * Gas spent here starts off proportional to the maximum mint batch size.
645      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
646      */
647     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
648         return _unpackedOwnership(_packedOwnershipOf(tokenId));
649     }
650 
651     /**
652      * @dev Packs ownership data into a single uint256.
653      */
654     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
655         assembly {
656             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
657             owner := and(owner, BITMASK_ADDRESS)
658             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
659             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
660         }
661     }
662 
663     /**
664      * @dev See {IERC721-ownerOf}.
665      */
666     function ownerOf(uint256 tokenId) public view override returns (address) {
667         return address(uint160(_packedOwnershipOf(tokenId)));
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-name}.
672      */
673     function name() public view virtual override returns (string memory) {
674         return _name;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-symbol}.
679      */
680     function symbol() public view virtual override returns (string memory) {
681         return _symbol;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-tokenURI}.
686      */
687     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
688         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
689 
690         string memory baseURI = _baseURI();
691         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
692     }
693 
694     /**
695      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
696      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
697      * by default, it can be overridden in child contracts.
698      */
699     function _baseURI() internal view virtual returns (string memory) {
700         return '';
701     }
702 
703     /**
704      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
705      */
706     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
707         // For branchless setting of the `nextInitialized` flag.
708         assembly {
709             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
710             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
711         }
712     }
713 
714     /**
715      * @dev See {IERC721-approve}.
716      */
717     function approve(address to, uint256 tokenId) public override {
718         address owner = ownerOf(tokenId);
719 
720         if (_msgSenderERC721A() != owner)
721             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
722                 revert ApprovalCallerNotOwnerNorApproved();
723             }
724 
725         _tokenApprovals[tokenId] = to;
726         emit Approval(owner, to, tokenId);
727     }
728 
729     /**
730      * @dev See {IERC721-getApproved}.
731      */
732     function getApproved(uint256 tokenId) public view override returns (address) {
733         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
734 
735         return _tokenApprovals[tokenId];
736     }
737 
738     /**
739      * @dev See {IERC721-setApprovalForAll}.
740      */
741     function setApprovalForAll(address operator, bool approved) public virtual override {
742         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
743 
744         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
745         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
746     }
747 
748     /**
749      * @dev See {IERC721-isApprovedForAll}.
750      */
751     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
752         return _operatorApprovals[owner][operator];
753     }
754 
755     /**
756      * @dev See {IERC721-safeTransferFrom}.
757      */
758     function safeTransferFrom(
759         address from,
760         address to,
761         uint256 tokenId
762     ) public virtual override {
763         safeTransferFrom(from, to, tokenId, '');
764     }
765 
766     /**
767      * @dev See {IERC721-safeTransferFrom}.
768      */
769     function safeTransferFrom(
770         address from,
771         address to,
772         uint256 tokenId,
773         bytes memory _data
774     ) public virtual override {
775         transferFrom(from, to, tokenId);
776         if (to.code.length != 0)
777             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
778                 revert TransferToNonERC721ReceiverImplementer();
779             }
780     }
781 
782     /**
783      * @dev Returns whether `tokenId` exists.
784      *
785      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
786      *
787      * Tokens start existing when they are minted (`_mint`),
788      */
789     function _exists(uint256 tokenId) internal view returns (bool) {
790         return
791             _startTokenId() <= tokenId &&
792             tokenId < _currentIndex && // If within bounds,
793             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
794     }
795 
796     /**
797      * @dev Equivalent to `_safeMint(to, quantity, '')`.
798      */
799     function _safeMint(address to, uint256 quantity) internal {
800         _safeMint(to, quantity, '');
801     }
802 
803     /**
804      * @dev Safely mints `quantity` tokens and transfers them to `to`.
805      *
806      * Requirements:
807      *
808      * - If `to` refers to a smart contract, it must implement
809      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
810      * - `quantity` must be greater than 0.
811      *
812      * See {_mint}.
813      *
814      * Emits a {Transfer} event for each mint.
815      */
816     function _safeMint(
817         address to,
818         uint256 quantity,
819         bytes memory _data
820     ) internal {
821         _mint(to, quantity);
822 
823         unchecked {
824             if (to.code.length != 0) {
825                 uint256 end = _currentIndex;
826                 uint256 index = end - quantity;
827                 do {
828                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
829                         revert TransferToNonERC721ReceiverImplementer();
830                     }
831                 } while (index < end);
832                 // Reentrancy protection.
833                 if (_currentIndex != end) revert();
834             }
835         }
836     }
837 
838     /**
839      * @dev Mints `quantity` tokens and transfers them to `to`.
840      *
841      * Requirements:
842      *
843      * - `to` cannot be the zero address.
844      * - `quantity` must be greater than 0.
845      *
846      * Emits a {Transfer} event for each mint.
847      */
848     function _mint(address to, uint256 quantity) internal {
849         uint256 startTokenId = _currentIndex;
850         if (to == address(0)) revert MintToZeroAddress();
851         if (quantity == 0) revert MintZeroQuantity();
852 
853         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
854 
855         // Overflows are incredibly unrealistic.
856         // `balance` and `numberMinted` have a maximum limit of 2**64.
857         // `tokenId` has a maximum limit of 2**256.
858         unchecked {
859             // Updates:
860             // - `balance += quantity`.
861             // - `numberMinted += quantity`.
862             //
863             // We can directly add to the `balance` and `numberMinted`.
864             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
865 
866             // Updates:
867             // - `address` to the owner.
868             // - `startTimestamp` to the timestamp of minting.
869             // - `burned` to `false`.
870             // - `nextInitialized` to `quantity == 1`.
871             _packedOwnerships[startTokenId] = _packOwnershipData(
872                 to,
873                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
874             );
875 
876             uint256 tokenId = startTokenId;
877             uint256 end = startTokenId + quantity;
878             do {
879                 emit Transfer(address(0), to, tokenId++);
880             } while (tokenId < end);
881 
882             _currentIndex = end;
883         }
884         _afterTokenTransfers(address(0), to, startTokenId, quantity);
885     }
886 
887     /**
888      * @dev Mints `quantity` tokens and transfers them to `to`.
889      *
890      * This function is intended for efficient minting only during contract creation.
891      *
892      * It emits only one {ConsecutiveTransfer} as defined in
893      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
894      * instead of a sequence of {Transfer} event(s).
895      *
896      * Calling this function outside of contract creation WILL make your contract
897      * non-compliant with the ERC721 standard.
898      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
899      * {ConsecutiveTransfer} event is only permissible during contract creation.
900      *
901      * Requirements:
902      *
903      * - `to` cannot be the zero address.
904      * - `quantity` must be greater than 0.
905      *
906      * Emits a {ConsecutiveTransfer} event.
907      */
908     function _mintERC2309(address to, uint256 quantity) internal {
909         uint256 startTokenId = _currentIndex;
910         if (to == address(0)) revert MintToZeroAddress();
911         if (quantity == 0) revert MintZeroQuantity();
912         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
913 
914         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
915 
916         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
917         unchecked {
918             // Updates:
919             // - `balance += quantity`.
920             // - `numberMinted += quantity`.
921             //
922             // We can directly add to the `balance` and `numberMinted`.
923             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
924 
925             // Updates:
926             // - `address` to the owner.
927             // - `startTimestamp` to the timestamp of minting.
928             // - `burned` to `false`.
929             // - `nextInitialized` to `quantity == 1`.
930             _packedOwnerships[startTokenId] = _packOwnershipData(
931                 to,
932                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
933             );
934 
935             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
936 
937             _currentIndex = startTokenId + quantity;
938         }
939         _afterTokenTransfers(address(0), to, startTokenId, quantity);
940     }
941 
942     /**
943      * @dev Returns the storage slot and value for the approved address of `tokenId`.
944      */
945     function _getApprovedAddress(uint256 tokenId)
946         private
947         view
948         returns (uint256 approvedAddressSlot, address approvedAddress)
949     {
950         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
951         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
952         assembly {
953             // Compute the slot.
954             mstore(0x00, tokenId)
955             mstore(0x20, tokenApprovalsPtr.slot)
956             approvedAddressSlot := keccak256(0x00, 0x40)
957             // Load the slot's value from storage.
958             approvedAddress := sload(approvedAddressSlot)
959         }
960     }
961 
962     /**
963      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
964      */
965     function _isOwnerOrApproved(
966         address approvedAddress,
967         address from,
968         address msgSender
969     ) private pure returns (bool result) {
970         assembly {
971             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
972             from := and(from, BITMASK_ADDRESS)
973             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
974             msgSender := and(msgSender, BITMASK_ADDRESS)
975             // `msgSender == from || msgSender == approvedAddress`.
976             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
977         }
978     }
979 
980     /**
981      * @dev Transfers `tokenId` from `from` to `to`.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must be owned by `from`.
987      *
988      * Emits a {Transfer} event.
989      */
990     function transferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) public virtual override {
995         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
996 
997         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
998 
999         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1000 
1001         // The nested ifs save around 20+ gas over a compound boolean condition.
1002         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1003             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1004 
1005         if (to == address(0)) revert TransferToZeroAddress();
1006 
1007         _beforeTokenTransfers(from, to, tokenId, 1);
1008 
1009         // Clear approvals from the previous owner.
1010         assembly {
1011             if approvedAddress {
1012                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1013                 sstore(approvedAddressSlot, 0)
1014             }
1015         }
1016 
1017         // Underflow of the sender's balance is impossible because we check for
1018         // ownership above and the recipient's balance can't realistically overflow.
1019         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1020         unchecked {
1021             // We can directly increment and decrement the balances.
1022             --_packedAddressData[from]; // Updates: `balance -= 1`.
1023             ++_packedAddressData[to]; // Updates: `balance += 1`.
1024 
1025             // Updates:
1026             // - `address` to the next owner.
1027             // - `startTimestamp` to the timestamp of transfering.
1028             // - `burned` to `false`.
1029             // - `nextInitialized` to `true`.
1030             _packedOwnerships[tokenId] = _packOwnershipData(
1031                 to,
1032                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1033             );
1034 
1035             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1036             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1037                 uint256 nextTokenId = tokenId + 1;
1038                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1039                 if (_packedOwnerships[nextTokenId] == 0) {
1040                     // If the next slot is within bounds.
1041                     if (nextTokenId != _currentIndex) {
1042                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1043                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1044                     }
1045                 }
1046             }
1047         }
1048 
1049         emit Transfer(from, to, tokenId);
1050         _afterTokenTransfers(from, to, tokenId, 1);
1051     }
1052 
1053     /**
1054      * @dev Equivalent to `_burn(tokenId, false)`.
1055      */
1056     function _burn(uint256 tokenId) internal virtual {
1057         _burn(tokenId, false);
1058     }
1059 
1060     /**
1061      * @dev Destroys `tokenId`.
1062      * The approval is cleared when the token is burned.
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must exist.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1071         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1072 
1073         address from = address(uint160(prevOwnershipPacked));
1074 
1075         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1076 
1077         if (approvalCheck) {
1078             // The nested ifs save around 20+ gas over a compound boolean condition.
1079             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1080                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1081         }
1082 
1083         _beforeTokenTransfers(from, address(0), tokenId, 1);
1084 
1085         // Clear approvals from the previous owner.
1086         assembly {
1087             if approvedAddress {
1088                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1089                 sstore(approvedAddressSlot, 0)
1090             }
1091         }
1092 
1093         // Underflow of the sender's balance is impossible because we check for
1094         // ownership above and the recipient's balance can't realistically overflow.
1095         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1096         unchecked {
1097             // Updates:
1098             // - `balance -= 1`.
1099             // - `numberBurned += 1`.
1100             //
1101             // We can directly decrement the balance, and increment the number burned.
1102             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1103             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1104 
1105             // Updates:
1106             // - `address` to the last owner.
1107             // - `startTimestamp` to the timestamp of burning.
1108             // - `burned` to `true`.
1109             // - `nextInitialized` to `true`.
1110             _packedOwnerships[tokenId] = _packOwnershipData(
1111                 from,
1112                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1113             );
1114 
1115             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1116             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1117                 uint256 nextTokenId = tokenId + 1;
1118                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1119                 if (_packedOwnerships[nextTokenId] == 0) {
1120                     // If the next slot is within bounds.
1121                     if (nextTokenId != _currentIndex) {
1122                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1123                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1124                     }
1125                 }
1126             }
1127         }
1128 
1129         emit Transfer(from, address(0), tokenId);
1130         _afterTokenTransfers(from, address(0), tokenId, 1);
1131 
1132         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1133         unchecked {
1134             _burnCounter++;
1135         }
1136     }
1137 
1138     /**
1139      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1140      *
1141      * @param from address representing the previous owner of the given token ID
1142      * @param to target address that will receive the tokens
1143      * @param tokenId uint256 ID of the token to be transferred
1144      * @param _data bytes optional data to send along with the call
1145      * @return bool whether the call correctly returned the expected magic value
1146      */
1147     function _checkContractOnERC721Received(
1148         address from,
1149         address to,
1150         uint256 tokenId,
1151         bytes memory _data
1152     ) private returns (bool) {
1153         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1154             bytes4 retval
1155         ) {
1156             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1157         } catch (bytes memory reason) {
1158             if (reason.length == 0) {
1159                 revert TransferToNonERC721ReceiverImplementer();
1160             } else {
1161                 assembly {
1162                     revert(add(32, reason), mload(reason))
1163                 }
1164             }
1165         }
1166     }
1167 
1168     /**
1169      * @dev Directly sets the extra data for the ownership data `index`.
1170      */
1171     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1172         uint256 packed = _packedOwnerships[index];
1173         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1174         uint256 extraDataCasted;
1175         // Cast `extraData` with assembly to avoid redundant masking.
1176         assembly {
1177             extraDataCasted := extraData
1178         }
1179         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1180         _packedOwnerships[index] = packed;
1181     }
1182 
1183     /**
1184      * @dev Returns the next extra data for the packed ownership data.
1185      * The returned result is shifted into position.
1186      */
1187     function _nextExtraData(
1188         address from,
1189         address to,
1190         uint256 prevOwnershipPacked
1191     ) private view returns (uint256) {
1192         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1193         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1194     }
1195 
1196     /**
1197      * @dev Called during each token transfer to set the 24bit `extraData` field.
1198      * Intended to be overridden by the cosumer contract.
1199      *
1200      * `previousExtraData` - the value of `extraData` before transfer.
1201      *
1202      * Calling conditions:
1203      *
1204      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1205      * transferred to `to`.
1206      * - When `from` is zero, `tokenId` will be minted for `to`.
1207      * - When `to` is zero, `tokenId` will be burned by `from`.
1208      * - `from` and `to` are never both zero.
1209      */
1210     function _extraData(
1211         address from,
1212         address to,
1213         uint24 previousExtraData
1214     ) internal view virtual returns (uint24) {}
1215 
1216     /**
1217      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1218      * This includes minting.
1219      * And also called before burning one token.
1220      *
1221      * startTokenId - the first token id to be transferred
1222      * quantity - the amount to be transferred
1223      *
1224      * Calling conditions:
1225      *
1226      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1227      * transferred to `to`.
1228      * - When `from` is zero, `tokenId` will be minted for `to`.
1229      * - When `to` is zero, `tokenId` will be burned by `from`.
1230      * - `from` and `to` are never both zero.
1231      */
1232     function _beforeTokenTransfers(
1233         address from,
1234         address to,
1235         uint256 startTokenId,
1236         uint256 quantity
1237     ) internal virtual {}
1238 
1239     /**
1240      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1241      * This includes minting.
1242      * And also called after one token has been burned.
1243      *
1244      * startTokenId - the first token id to be transferred
1245      * quantity - the amount to be transferred
1246      *
1247      * Calling conditions:
1248      *
1249      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1250      * transferred to `to`.
1251      * - When `from` is zero, `tokenId` has been minted for `to`.
1252      * - When `to` is zero, `tokenId` has been burned by `from`.
1253      * - `from` and `to` are never both zero.
1254      */
1255     function _afterTokenTransfers(
1256         address from,
1257         address to,
1258         uint256 startTokenId,
1259         uint256 quantity
1260     ) internal virtual {}
1261 
1262     /**
1263      * @dev Returns the message sender (defaults to `msg.sender`).
1264      *
1265      * If you are writing GSN compatible contracts, you need to override this function.
1266      */
1267     function _msgSenderERC721A() internal view virtual returns (address) {
1268         return msg.sender;
1269     }
1270 
1271     /**
1272      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1273      */
1274     function _toString(uint256 value) internal pure returns (string memory ptr) {
1275         assembly {
1276             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1277             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1278             // We will need 1 32-byte word to store the length,
1279             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1280             ptr := add(mload(0x40), 128)
1281             // Update the free memory pointer to allocate.
1282             mstore(0x40, ptr)
1283 
1284             // Cache the end of the memory to calculate the length later.
1285             let end := ptr
1286 
1287             // We write the string from the rightmost digit to the leftmost digit.
1288             // The following is essentially a do-while loop that also handles the zero case.
1289             // Costs a bit more than early returning for the zero case,
1290             // but cheaper in terms of deployment and overall runtime costs.
1291             for {
1292                 // Initialize and perform the first pass without check.
1293                 let temp := value
1294                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1295                 ptr := sub(ptr, 1)
1296                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1297                 mstore8(ptr, add(48, mod(temp, 10)))
1298                 temp := div(temp, 10)
1299             } temp {
1300                 // Keep dividing `temp` until zero.
1301                 temp := div(temp, 10)
1302             } {
1303                 // Body of the for loop.
1304                 ptr := sub(ptr, 1)
1305                 mstore8(ptr, add(48, mod(temp, 10)))
1306             }
1307 
1308             let length := sub(end, ptr)
1309             // Move the pointer 32 bytes leftwards to make room for the length.
1310             ptr := sub(ptr, 32)
1311             // Store the length.
1312             mstore(ptr, length)
1313         }
1314     }
1315 }
1316 
1317 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1318 
1319 
1320 // ERC721A Contracts v4.1.0
1321 // Creator: Chiru Labs
1322 
1323 pragma solidity ^0.8.4;
1324 
1325 
1326 
1327 /**
1328  * @title ERC721A Queryable
1329  * @dev ERC721A subclass with convenience query functions.
1330  */
1331 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1332     /**
1333      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1334      *
1335      * If the `tokenId` is out of bounds:
1336      *   - `addr` = `address(0)`
1337      *   - `startTimestamp` = `0`
1338      *   - `burned` = `false`
1339      *   - `extraData` = `0`
1340      *
1341      * If the `tokenId` is burned:
1342      *   - `addr` = `<Address of owner before token was burned>`
1343      *   - `startTimestamp` = `<Timestamp when token was burned>`
1344      *   - `burned = `true`
1345      *   - `extraData` = `<Extra data when token was burned>`
1346      *
1347      * Otherwise:
1348      *   - `addr` = `<Address of owner>`
1349      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1350      *   - `burned = `false`
1351      *   - `extraData` = `<Extra data at start of ownership>`
1352      */
1353     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1354         TokenOwnership memory ownership;
1355         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1356             return ownership;
1357         }
1358         ownership = _ownershipAt(tokenId);
1359         if (ownership.burned) {
1360             return ownership;
1361         }
1362         return _ownershipOf(tokenId);
1363     }
1364 
1365     /**
1366      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1367      * See {ERC721AQueryable-explicitOwnershipOf}
1368      */
1369     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1370         unchecked {
1371             uint256 tokenIdsLength = tokenIds.length;
1372             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1373             for (uint256 i; i != tokenIdsLength; ++i) {
1374                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1375             }
1376             return ownerships;
1377         }
1378     }
1379 
1380     /**
1381      * @dev Returns an array of token IDs owned by `owner`,
1382      * in the range [`start`, `stop`)
1383      * (i.e. `start <= tokenId < stop`).
1384      *
1385      * This function allows for tokens to be queried if the collection
1386      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1387      *
1388      * Requirements:
1389      *
1390      * - `start` < `stop`
1391      */
1392     function tokensOfOwnerIn(
1393         address owner,
1394         uint256 start,
1395         uint256 stop
1396     ) external view override returns (uint256[] memory) {
1397         unchecked {
1398             if (start >= stop) revert InvalidQueryRange();
1399             uint256 tokenIdsIdx;
1400             uint256 stopLimit = _nextTokenId();
1401             // Set `start = max(start, _startTokenId())`.
1402             if (start < _startTokenId()) {
1403                 start = _startTokenId();
1404             }
1405             // Set `stop = min(stop, stopLimit)`.
1406             if (stop > stopLimit) {
1407                 stop = stopLimit;
1408             }
1409             uint256 tokenIdsMaxLength = balanceOf(owner);
1410             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1411             // to cater for cases where `balanceOf(owner)` is too big.
1412             if (start < stop) {
1413                 uint256 rangeLength = stop - start;
1414                 if (rangeLength < tokenIdsMaxLength) {
1415                     tokenIdsMaxLength = rangeLength;
1416                 }
1417             } else {
1418                 tokenIdsMaxLength = 0;
1419             }
1420             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1421             if (tokenIdsMaxLength == 0) {
1422                 return tokenIds;
1423             }
1424             // We need to call `explicitOwnershipOf(start)`,
1425             // because the slot at `start` may not be initialized.
1426             TokenOwnership memory ownership = explicitOwnershipOf(start);
1427             address currOwnershipAddr;
1428             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1429             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1430             if (!ownership.burned) {
1431                 currOwnershipAddr = ownership.addr;
1432             }
1433             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1434                 ownership = _ownershipAt(i);
1435                 if (ownership.burned) {
1436                     continue;
1437                 }
1438                 if (ownership.addr != address(0)) {
1439                     currOwnershipAddr = ownership.addr;
1440                 }
1441                 if (currOwnershipAddr == owner) {
1442                     tokenIds[tokenIdsIdx++] = i;
1443                 }
1444             }
1445             // Downsize the array to fit.
1446             assembly {
1447                 mstore(tokenIds, tokenIdsIdx)
1448             }
1449             return tokenIds;
1450         }
1451     }
1452 
1453     /**
1454      * @dev Returns an array of token IDs owned by `owner`.
1455      *
1456      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1457      * It is meant to be called off-chain.
1458      *
1459      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1460      * multiple smaller scans if the collection is large enough to cause
1461      * an out-of-gas error (10K pfp collections should be fine).
1462      */
1463     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1464         unchecked {
1465             uint256 tokenIdsIdx;
1466             address currOwnershipAddr;
1467             uint256 tokenIdsLength = balanceOf(owner);
1468             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1469             TokenOwnership memory ownership;
1470             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1471                 ownership = _ownershipAt(i);
1472                 if (ownership.burned) {
1473                     continue;
1474                 }
1475                 if (ownership.addr != address(0)) {
1476                     currOwnershipAddr = ownership.addr;
1477                 }
1478                 if (currOwnershipAddr == owner) {
1479                     tokenIds[tokenIdsIdx++] = i;
1480                 }
1481             }
1482             return tokenIds;
1483         }
1484     }
1485 }
1486 
1487 // File: hardhat/console.sol
1488 
1489 
1490 pragma solidity >= 0.4.22 <0.9.0;
1491 
1492 library console {
1493 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1494 
1495 	function _sendLogPayload(bytes memory payload) private view {
1496 		uint256 payloadLength = payload.length;
1497 		address consoleAddress = CONSOLE_ADDRESS;
1498 		assembly {
1499 			let payloadStart := add(payload, 32)
1500 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1501 		}
1502 	}
1503 
1504 	function log() internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log()"));
1506 	}
1507 
1508 	function logInt(int p0) internal view {
1509 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1510 	}
1511 
1512 	function logUint(uint p0) internal view {
1513 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1514 	}
1515 
1516 	function logString(string memory p0) internal view {
1517 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1518 	}
1519 
1520 	function logBool(bool p0) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1522 	}
1523 
1524 	function logAddress(address p0) internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1526 	}
1527 
1528 	function logBytes(bytes memory p0) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1530 	}
1531 
1532 	function logBytes1(bytes1 p0) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1534 	}
1535 
1536 	function logBytes2(bytes2 p0) internal view {
1537 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1538 	}
1539 
1540 	function logBytes3(bytes3 p0) internal view {
1541 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1542 	}
1543 
1544 	function logBytes4(bytes4 p0) internal view {
1545 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1546 	}
1547 
1548 	function logBytes5(bytes5 p0) internal view {
1549 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1550 	}
1551 
1552 	function logBytes6(bytes6 p0) internal view {
1553 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1554 	}
1555 
1556 	function logBytes7(bytes7 p0) internal view {
1557 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1558 	}
1559 
1560 	function logBytes8(bytes8 p0) internal view {
1561 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1562 	}
1563 
1564 	function logBytes9(bytes9 p0) internal view {
1565 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1566 	}
1567 
1568 	function logBytes10(bytes10 p0) internal view {
1569 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1570 	}
1571 
1572 	function logBytes11(bytes11 p0) internal view {
1573 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1574 	}
1575 
1576 	function logBytes12(bytes12 p0) internal view {
1577 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1578 	}
1579 
1580 	function logBytes13(bytes13 p0) internal view {
1581 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1582 	}
1583 
1584 	function logBytes14(bytes14 p0) internal view {
1585 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1586 	}
1587 
1588 	function logBytes15(bytes15 p0) internal view {
1589 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1590 	}
1591 
1592 	function logBytes16(bytes16 p0) internal view {
1593 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1594 	}
1595 
1596 	function logBytes17(bytes17 p0) internal view {
1597 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1598 	}
1599 
1600 	function logBytes18(bytes18 p0) internal view {
1601 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1602 	}
1603 
1604 	function logBytes19(bytes19 p0) internal view {
1605 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1606 	}
1607 
1608 	function logBytes20(bytes20 p0) internal view {
1609 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1610 	}
1611 
1612 	function logBytes21(bytes21 p0) internal view {
1613 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1614 	}
1615 
1616 	function logBytes22(bytes22 p0) internal view {
1617 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1618 	}
1619 
1620 	function logBytes23(bytes23 p0) internal view {
1621 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1622 	}
1623 
1624 	function logBytes24(bytes24 p0) internal view {
1625 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1626 	}
1627 
1628 	function logBytes25(bytes25 p0) internal view {
1629 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1630 	}
1631 
1632 	function logBytes26(bytes26 p0) internal view {
1633 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1634 	}
1635 
1636 	function logBytes27(bytes27 p0) internal view {
1637 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1638 	}
1639 
1640 	function logBytes28(bytes28 p0) internal view {
1641 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1642 	}
1643 
1644 	function logBytes29(bytes29 p0) internal view {
1645 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1646 	}
1647 
1648 	function logBytes30(bytes30 p0) internal view {
1649 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1650 	}
1651 
1652 	function logBytes31(bytes31 p0) internal view {
1653 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1654 	}
1655 
1656 	function logBytes32(bytes32 p0) internal view {
1657 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1658 	}
1659 
1660 	function log(uint p0) internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1662 	}
1663 
1664 	function log(string memory p0) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1666 	}
1667 
1668 	function log(bool p0) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1670 	}
1671 
1672 	function log(address p0) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1674 	}
1675 
1676 	function log(uint p0, uint p1) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1678 	}
1679 
1680 	function log(uint p0, string memory p1) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1682 	}
1683 
1684 	function log(uint p0, bool p1) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1686 	}
1687 
1688 	function log(uint p0, address p1) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1690 	}
1691 
1692 	function log(string memory p0, uint p1) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1694 	}
1695 
1696 	function log(string memory p0, string memory p1) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1698 	}
1699 
1700 	function log(string memory p0, bool p1) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1702 	}
1703 
1704 	function log(string memory p0, address p1) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1706 	}
1707 
1708 	function log(bool p0, uint p1) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1710 	}
1711 
1712 	function log(bool p0, string memory p1) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1714 	}
1715 
1716 	function log(bool p0, bool p1) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1718 	}
1719 
1720 	function log(bool p0, address p1) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1722 	}
1723 
1724 	function log(address p0, uint p1) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1726 	}
1727 
1728 	function log(address p0, string memory p1) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1730 	}
1731 
1732 	function log(address p0, bool p1) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1734 	}
1735 
1736 	function log(address p0, address p1) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1738 	}
1739 
1740 	function log(uint p0, uint p1, uint p2) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1742 	}
1743 
1744 	function log(uint p0, uint p1, string memory p2) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1746 	}
1747 
1748 	function log(uint p0, uint p1, bool p2) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1750 	}
1751 
1752 	function log(uint p0, uint p1, address p2) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1754 	}
1755 
1756 	function log(uint p0, string memory p1, uint p2) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1758 	}
1759 
1760 	function log(uint p0, string memory p1, string memory p2) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1762 	}
1763 
1764 	function log(uint p0, string memory p1, bool p2) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1766 	}
1767 
1768 	function log(uint p0, string memory p1, address p2) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1770 	}
1771 
1772 	function log(uint p0, bool p1, uint p2) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1774 	}
1775 
1776 	function log(uint p0, bool p1, string memory p2) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1778 	}
1779 
1780 	function log(uint p0, bool p1, bool p2) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1782 	}
1783 
1784 	function log(uint p0, bool p1, address p2) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1786 	}
1787 
1788 	function log(uint p0, address p1, uint p2) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1790 	}
1791 
1792 	function log(uint p0, address p1, string memory p2) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1794 	}
1795 
1796 	function log(uint p0, address p1, bool p2) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1798 	}
1799 
1800 	function log(uint p0, address p1, address p2) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1802 	}
1803 
1804 	function log(string memory p0, uint p1, uint p2) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1806 	}
1807 
1808 	function log(string memory p0, uint p1, string memory p2) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1810 	}
1811 
1812 	function log(string memory p0, uint p1, bool p2) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1814 	}
1815 
1816 	function log(string memory p0, uint p1, address p2) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1818 	}
1819 
1820 	function log(string memory p0, string memory p1, uint p2) internal view {
1821 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1822 	}
1823 
1824 	function log(string memory p0, string memory p1, string memory p2) internal view {
1825 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1826 	}
1827 
1828 	function log(string memory p0, string memory p1, bool p2) internal view {
1829 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1830 	}
1831 
1832 	function log(string memory p0, string memory p1, address p2) internal view {
1833 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1834 	}
1835 
1836 	function log(string memory p0, bool p1, uint p2) internal view {
1837 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1838 	}
1839 
1840 	function log(string memory p0, bool p1, string memory p2) internal view {
1841 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1842 	}
1843 
1844 	function log(string memory p0, bool p1, bool p2) internal view {
1845 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1846 	}
1847 
1848 	function log(string memory p0, bool p1, address p2) internal view {
1849 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1850 	}
1851 
1852 	function log(string memory p0, address p1, uint p2) internal view {
1853 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1854 	}
1855 
1856 	function log(string memory p0, address p1, string memory p2) internal view {
1857 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1858 	}
1859 
1860 	function log(string memory p0, address p1, bool p2) internal view {
1861 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1862 	}
1863 
1864 	function log(string memory p0, address p1, address p2) internal view {
1865 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1866 	}
1867 
1868 	function log(bool p0, uint p1, uint p2) internal view {
1869 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1870 	}
1871 
1872 	function log(bool p0, uint p1, string memory p2) internal view {
1873 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1874 	}
1875 
1876 	function log(bool p0, uint p1, bool p2) internal view {
1877 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1878 	}
1879 
1880 	function log(bool p0, uint p1, address p2) internal view {
1881 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1882 	}
1883 
1884 	function log(bool p0, string memory p1, uint p2) internal view {
1885 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1886 	}
1887 
1888 	function log(bool p0, string memory p1, string memory p2) internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1890 	}
1891 
1892 	function log(bool p0, string memory p1, bool p2) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1894 	}
1895 
1896 	function log(bool p0, string memory p1, address p2) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1898 	}
1899 
1900 	function log(bool p0, bool p1, uint p2) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1902 	}
1903 
1904 	function log(bool p0, bool p1, string memory p2) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1906 	}
1907 
1908 	function log(bool p0, bool p1, bool p2) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1910 	}
1911 
1912 	function log(bool p0, bool p1, address p2) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1914 	}
1915 
1916 	function log(bool p0, address p1, uint p2) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1918 	}
1919 
1920 	function log(bool p0, address p1, string memory p2) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1922 	}
1923 
1924 	function log(bool p0, address p1, bool p2) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1926 	}
1927 
1928 	function log(bool p0, address p1, address p2) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1930 	}
1931 
1932 	function log(address p0, uint p1, uint p2) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1934 	}
1935 
1936 	function log(address p0, uint p1, string memory p2) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1938 	}
1939 
1940 	function log(address p0, uint p1, bool p2) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1942 	}
1943 
1944 	function log(address p0, uint p1, address p2) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1946 	}
1947 
1948 	function log(address p0, string memory p1, uint p2) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1950 	}
1951 
1952 	function log(address p0, string memory p1, string memory p2) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1954 	}
1955 
1956 	function log(address p0, string memory p1, bool p2) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1958 	}
1959 
1960 	function log(address p0, string memory p1, address p2) internal view {
1961 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1962 	}
1963 
1964 	function log(address p0, bool p1, uint p2) internal view {
1965 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1966 	}
1967 
1968 	function log(address p0, bool p1, string memory p2) internal view {
1969 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1970 	}
1971 
1972 	function log(address p0, bool p1, bool p2) internal view {
1973 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1974 	}
1975 
1976 	function log(address p0, bool p1, address p2) internal view {
1977 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1978 	}
1979 
1980 	function log(address p0, address p1, uint p2) internal view {
1981 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1982 	}
1983 
1984 	function log(address p0, address p1, string memory p2) internal view {
1985 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1986 	}
1987 
1988 	function log(address p0, address p1, bool p2) internal view {
1989 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1990 	}
1991 
1992 	function log(address p0, address p1, address p2) internal view {
1993 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1994 	}
1995 
1996 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1997 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1998 	}
1999 
2000 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
2001 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
2002 	}
2003 
2004 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
2005 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
2006 	}
2007 
2008 	function log(uint p0, uint p1, uint p2, address p3) internal view {
2009 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
2010 	}
2011 
2012 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
2013 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
2014 	}
2015 
2016 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
2017 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
2018 	}
2019 
2020 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
2021 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
2022 	}
2023 
2024 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
2025 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
2026 	}
2027 
2028 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
2029 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
2030 	}
2031 
2032 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
2033 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
2034 	}
2035 
2036 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
2037 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
2038 	}
2039 
2040 	function log(uint p0, uint p1, bool p2, address p3) internal view {
2041 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
2042 	}
2043 
2044 	function log(uint p0, uint p1, address p2, uint p3) internal view {
2045 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
2046 	}
2047 
2048 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
2049 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
2050 	}
2051 
2052 	function log(uint p0, uint p1, address p2, bool p3) internal view {
2053 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
2054 	}
2055 
2056 	function log(uint p0, uint p1, address p2, address p3) internal view {
2057 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
2058 	}
2059 
2060 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
2061 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
2062 	}
2063 
2064 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
2065 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
2066 	}
2067 
2068 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
2069 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
2070 	}
2071 
2072 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
2073 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
2074 	}
2075 
2076 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
2077 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
2078 	}
2079 
2080 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
2081 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
2082 	}
2083 
2084 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
2085 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
2086 	}
2087 
2088 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
2089 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
2090 	}
2091 
2092 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
2093 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
2094 	}
2095 
2096 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
2097 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2098 	}
2099 
2100 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2101 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2102 	}
2103 
2104 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2105 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2106 	}
2107 
2108 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2109 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2110 	}
2111 
2112 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2113 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2114 	}
2115 
2116 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2117 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2118 	}
2119 
2120 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2121 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2122 	}
2123 
2124 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2125 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2126 	}
2127 
2128 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2129 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2130 	}
2131 
2132 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2133 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2134 	}
2135 
2136 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2137 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2138 	}
2139 
2140 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2141 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2142 	}
2143 
2144 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2145 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2146 	}
2147 
2148 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2149 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2150 	}
2151 
2152 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2153 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2154 	}
2155 
2156 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2157 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2158 	}
2159 
2160 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2161 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2162 	}
2163 
2164 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2165 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2166 	}
2167 
2168 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2169 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2170 	}
2171 
2172 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2173 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2174 	}
2175 
2176 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2177 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2178 	}
2179 
2180 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2181 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2182 	}
2183 
2184 	function log(uint p0, bool p1, address p2, address p3) internal view {
2185 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2186 	}
2187 
2188 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2189 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2190 	}
2191 
2192 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2193 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2194 	}
2195 
2196 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2197 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2198 	}
2199 
2200 	function log(uint p0, address p1, uint p2, address p3) internal view {
2201 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2202 	}
2203 
2204 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2205 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2206 	}
2207 
2208 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2209 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2210 	}
2211 
2212 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2213 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2214 	}
2215 
2216 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2217 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2218 	}
2219 
2220 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2221 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2222 	}
2223 
2224 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2225 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2226 	}
2227 
2228 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2229 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2230 	}
2231 
2232 	function log(uint p0, address p1, bool p2, address p3) internal view {
2233 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2234 	}
2235 
2236 	function log(uint p0, address p1, address p2, uint p3) internal view {
2237 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2238 	}
2239 
2240 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2241 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2242 	}
2243 
2244 	function log(uint p0, address p1, address p2, bool p3) internal view {
2245 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2246 	}
2247 
2248 	function log(uint p0, address p1, address p2, address p3) internal view {
2249 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2250 	}
2251 
2252 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2253 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2254 	}
2255 
2256 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2257 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2258 	}
2259 
2260 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2261 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2262 	}
2263 
2264 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2265 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2266 	}
2267 
2268 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2269 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2270 	}
2271 
2272 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2273 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2274 	}
2275 
2276 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2277 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2278 	}
2279 
2280 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2281 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2282 	}
2283 
2284 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2285 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2286 	}
2287 
2288 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2289 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2290 	}
2291 
2292 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2293 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2294 	}
2295 
2296 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2297 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2298 	}
2299 
2300 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2301 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2302 	}
2303 
2304 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2305 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2306 	}
2307 
2308 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2309 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2310 	}
2311 
2312 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2313 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2314 	}
2315 
2316 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2317 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2318 	}
2319 
2320 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2321 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2322 	}
2323 
2324 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2325 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2326 	}
2327 
2328 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2329 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2330 	}
2331 
2332 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2333 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2334 	}
2335 
2336 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2337 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2338 	}
2339 
2340 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2341 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2342 	}
2343 
2344 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2345 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2346 	}
2347 
2348 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2349 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2350 	}
2351 
2352 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2353 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2354 	}
2355 
2356 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2357 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2358 	}
2359 
2360 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2361 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2362 	}
2363 
2364 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2365 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2366 	}
2367 
2368 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2369 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2370 	}
2371 
2372 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2373 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2374 	}
2375 
2376 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2377 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2378 	}
2379 
2380 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2381 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2382 	}
2383 
2384 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2385 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2386 	}
2387 
2388 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2389 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2390 	}
2391 
2392 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2393 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2394 	}
2395 
2396 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2397 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2398 	}
2399 
2400 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2401 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2402 	}
2403 
2404 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2405 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2406 	}
2407 
2408 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2409 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2410 	}
2411 
2412 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2413 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2414 	}
2415 
2416 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2417 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2418 	}
2419 
2420 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2421 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2422 	}
2423 
2424 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2425 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2426 	}
2427 
2428 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2429 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2430 	}
2431 
2432 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2433 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2434 	}
2435 
2436 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2437 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2438 	}
2439 
2440 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2441 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2442 	}
2443 
2444 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2445 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2446 	}
2447 
2448 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2449 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2450 	}
2451 
2452 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2453 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2454 	}
2455 
2456 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2457 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2458 	}
2459 
2460 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2461 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2462 	}
2463 
2464 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2465 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2466 	}
2467 
2468 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2469 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2470 	}
2471 
2472 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2473 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2474 	}
2475 
2476 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2477 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2478 	}
2479 
2480 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2481 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2482 	}
2483 
2484 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2485 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2486 	}
2487 
2488 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2489 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2490 	}
2491 
2492 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2493 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2494 	}
2495 
2496 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2497 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2498 	}
2499 
2500 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2501 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2502 	}
2503 
2504 	function log(string memory p0, address p1, address p2, address p3) internal view {
2505 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2506 	}
2507 
2508 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2509 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2510 	}
2511 
2512 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2513 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2514 	}
2515 
2516 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2517 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2518 	}
2519 
2520 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2521 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2522 	}
2523 
2524 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2525 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2526 	}
2527 
2528 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2529 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2530 	}
2531 
2532 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2533 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2534 	}
2535 
2536 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2537 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2538 	}
2539 
2540 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2541 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2542 	}
2543 
2544 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2545 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2546 	}
2547 
2548 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2549 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2550 	}
2551 
2552 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2553 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2554 	}
2555 
2556 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2557 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2558 	}
2559 
2560 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2561 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2562 	}
2563 
2564 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2565 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2566 	}
2567 
2568 	function log(bool p0, uint p1, address p2, address p3) internal view {
2569 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2570 	}
2571 
2572 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2573 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2574 	}
2575 
2576 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2577 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2578 	}
2579 
2580 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2581 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2582 	}
2583 
2584 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2585 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2586 	}
2587 
2588 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2589 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2590 	}
2591 
2592 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2593 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2594 	}
2595 
2596 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2597 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2598 	}
2599 
2600 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2601 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2602 	}
2603 
2604 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2605 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2606 	}
2607 
2608 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2609 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2610 	}
2611 
2612 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2613 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2614 	}
2615 
2616 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2617 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2618 	}
2619 
2620 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2621 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2622 	}
2623 
2624 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2625 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2626 	}
2627 
2628 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2629 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2630 	}
2631 
2632 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2633 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2634 	}
2635 
2636 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2637 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2638 	}
2639 
2640 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2641 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2642 	}
2643 
2644 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2645 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2646 	}
2647 
2648 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2649 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2650 	}
2651 
2652 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2653 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2654 	}
2655 
2656 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2657 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2658 	}
2659 
2660 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2661 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2662 	}
2663 
2664 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2665 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2666 	}
2667 
2668 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2669 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2670 	}
2671 
2672 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2673 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2674 	}
2675 
2676 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2677 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2678 	}
2679 
2680 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2681 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2682 	}
2683 
2684 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2685 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2686 	}
2687 
2688 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2689 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2690 	}
2691 
2692 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2693 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2694 	}
2695 
2696 	function log(bool p0, bool p1, address p2, address p3) internal view {
2697 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2698 	}
2699 
2700 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2701 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2702 	}
2703 
2704 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2705 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2706 	}
2707 
2708 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2709 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2710 	}
2711 
2712 	function log(bool p0, address p1, uint p2, address p3) internal view {
2713 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2714 	}
2715 
2716 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2717 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2718 	}
2719 
2720 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2721 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2722 	}
2723 
2724 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2725 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2726 	}
2727 
2728 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2729 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2730 	}
2731 
2732 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2733 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2734 	}
2735 
2736 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2737 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2738 	}
2739 
2740 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2741 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2742 	}
2743 
2744 	function log(bool p0, address p1, bool p2, address p3) internal view {
2745 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2746 	}
2747 
2748 	function log(bool p0, address p1, address p2, uint p3) internal view {
2749 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2750 	}
2751 
2752 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2753 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2754 	}
2755 
2756 	function log(bool p0, address p1, address p2, bool p3) internal view {
2757 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2758 	}
2759 
2760 	function log(bool p0, address p1, address p2, address p3) internal view {
2761 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2762 	}
2763 
2764 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2765 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2766 	}
2767 
2768 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2769 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2770 	}
2771 
2772 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2773 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2774 	}
2775 
2776 	function log(address p0, uint p1, uint p2, address p3) internal view {
2777 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2778 	}
2779 
2780 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2781 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2782 	}
2783 
2784 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2785 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2786 	}
2787 
2788 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2789 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2790 	}
2791 
2792 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2793 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2794 	}
2795 
2796 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2797 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2798 	}
2799 
2800 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2801 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2802 	}
2803 
2804 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2805 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2806 	}
2807 
2808 	function log(address p0, uint p1, bool p2, address p3) internal view {
2809 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2810 	}
2811 
2812 	function log(address p0, uint p1, address p2, uint p3) internal view {
2813 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2814 	}
2815 
2816 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2817 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2818 	}
2819 
2820 	function log(address p0, uint p1, address p2, bool p3) internal view {
2821 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2822 	}
2823 
2824 	function log(address p0, uint p1, address p2, address p3) internal view {
2825 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2826 	}
2827 
2828 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2829 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2830 	}
2831 
2832 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2833 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2834 	}
2835 
2836 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2837 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2838 	}
2839 
2840 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2841 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2842 	}
2843 
2844 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2845 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2846 	}
2847 
2848 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2849 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2850 	}
2851 
2852 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2853 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2854 	}
2855 
2856 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2857 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2858 	}
2859 
2860 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2861 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2862 	}
2863 
2864 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2865 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2866 	}
2867 
2868 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2869 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2870 	}
2871 
2872 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2873 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2874 	}
2875 
2876 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2877 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2878 	}
2879 
2880 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2881 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2882 	}
2883 
2884 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2885 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2886 	}
2887 
2888 	function log(address p0, string memory p1, address p2, address p3) internal view {
2889 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2890 	}
2891 
2892 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2893 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2894 	}
2895 
2896 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2897 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2898 	}
2899 
2900 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2901 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2902 	}
2903 
2904 	function log(address p0, bool p1, uint p2, address p3) internal view {
2905 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2906 	}
2907 
2908 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2909 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2910 	}
2911 
2912 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2913 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2914 	}
2915 
2916 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2917 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2918 	}
2919 
2920 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2921 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2922 	}
2923 
2924 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2925 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2926 	}
2927 
2928 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2929 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2930 	}
2931 
2932 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2933 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2934 	}
2935 
2936 	function log(address p0, bool p1, bool p2, address p3) internal view {
2937 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2938 	}
2939 
2940 	function log(address p0, bool p1, address p2, uint p3) internal view {
2941 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2942 	}
2943 
2944 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2945 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2946 	}
2947 
2948 	function log(address p0, bool p1, address p2, bool p3) internal view {
2949 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2950 	}
2951 
2952 	function log(address p0, bool p1, address p2, address p3) internal view {
2953 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2954 	}
2955 
2956 	function log(address p0, address p1, uint p2, uint p3) internal view {
2957 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2958 	}
2959 
2960 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2961 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2962 	}
2963 
2964 	function log(address p0, address p1, uint p2, bool p3) internal view {
2965 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2966 	}
2967 
2968 	function log(address p0, address p1, uint p2, address p3) internal view {
2969 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2970 	}
2971 
2972 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2973 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2974 	}
2975 
2976 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2977 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2978 	}
2979 
2980 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2981 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2982 	}
2983 
2984 	function log(address p0, address p1, string memory p2, address p3) internal view {
2985 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2986 	}
2987 
2988 	function log(address p0, address p1, bool p2, uint p3) internal view {
2989 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2990 	}
2991 
2992 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2993 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2994 	}
2995 
2996 	function log(address p0, address p1, bool p2, bool p3) internal view {
2997 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2998 	}
2999 
3000 	function log(address p0, address p1, bool p2, address p3) internal view {
3001 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3002 	}
3003 
3004 	function log(address p0, address p1, address p2, uint p3) internal view {
3005 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
3006 	}
3007 
3008 	function log(address p0, address p1, address p2, string memory p3) internal view {
3009 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3010 	}
3011 
3012 	function log(address p0, address p1, address p2, bool p3) internal view {
3013 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3014 	}
3015 
3016 	function log(address p0, address p1, address p2, address p3) internal view {
3017 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3018 	}
3019 
3020 }
3021 
3022 // File: @openzeppelin/contracts/utils/Context.sol
3023 
3024 
3025 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3026 
3027 pragma solidity ^0.8.0;
3028 
3029 /**
3030  * @dev Provides information about the current execution context, including the
3031  * sender of the transaction and its data. While these are generally available
3032  * via msg.sender and msg.data, they should not be accessed in such a direct
3033  * manner, since when dealing with meta-transactions the account sending and
3034  * paying for execution may not be the actual sender (as far as an application
3035  * is concerned).
3036  *
3037  * This contract is only required for intermediate, library-like contracts.
3038  */
3039 abstract contract Context {
3040     function _msgSender() internal view virtual returns (address) {
3041         return msg.sender;
3042     }
3043 
3044     function _msgData() internal view virtual returns (bytes calldata) {
3045         return msg.data;
3046     }
3047 }
3048 
3049 // File: @openzeppelin/contracts/access/Ownable.sol
3050 
3051 
3052 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
3053 
3054 pragma solidity ^0.8.0;
3055 
3056 
3057 /**
3058  * @dev Contract module which provides a basic access control mechanism, where
3059  * there is an account (an owner) that can be granted exclusive access to
3060  * specific functions.
3061  *
3062  * By default, the owner account will be the one that deploys the contract. This
3063  * can later be changed with {transferOwnership}.
3064  *
3065  * This module is used through inheritance. It will make available the modifier
3066  * `onlyOwner`, which can be applied to your functions to restrict their use to
3067  * the owner.
3068  */
3069 abstract contract Ownable is Context {
3070     address private _owner;
3071 
3072     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3073 
3074     /**
3075      * @dev Initializes the contract setting the deployer as the initial owner.
3076      */
3077     constructor() {
3078         _transferOwnership(_msgSender());
3079     }
3080 
3081     /**
3082      * @dev Returns the address of the current owner.
3083      */
3084     function owner() public view virtual returns (address) {
3085         return _owner;
3086     }
3087 
3088     /**
3089      * @dev Throws if called by any account other than the owner.
3090      */
3091     modifier onlyOwner() {
3092         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3093         _;
3094     }
3095 
3096     /**
3097      * @dev Leaves the contract without owner. It will not be possible to call
3098      * `onlyOwner` functions anymore. Can only be called by the current owner.
3099      *
3100      * NOTE: Renouncing ownership will leave the contract without an owner,
3101      * thereby removing any functionality that is only available to the owner.
3102      */
3103     function renounceOwnership() public virtual onlyOwner {
3104         _transferOwnership(address(0));
3105     }
3106 
3107     /**
3108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3109      * Can only be called by the current owner.
3110      */
3111     function transferOwnership(address newOwner) public virtual onlyOwner {
3112         require(newOwner != address(0), "Ownable: new owner is the zero address");
3113         _transferOwnership(newOwner);
3114     }
3115 
3116     /**
3117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3118      * Internal function without access restriction.
3119      */
3120     function _transferOwnership(address newOwner) internal virtual {
3121         address oldOwner = _owner;
3122         _owner = newOwner;
3123         emit OwnershipTransferred(oldOwner, newOwner);
3124     }
3125 }
3126 
3127 // File: @openzeppelin/contracts/utils/Strings.sol
3128 
3129 
3130 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
3131 
3132 pragma solidity ^0.8.0;
3133 
3134 /**
3135  * @dev String operations.
3136  */
3137 library Strings {
3138     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
3139 
3140     /**
3141      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
3142      */
3143     function toString(uint256 value) internal pure returns (string memory) {
3144         // Inspired by OraclizeAPI's implementation - MIT licence
3145         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
3146 
3147         if (value == 0) {
3148             return "0";
3149         }
3150         uint256 temp = value;
3151         uint256 digits;
3152         while (temp != 0) {
3153             digits++;
3154             temp /= 10;
3155         }
3156         bytes memory buffer = new bytes(digits);
3157         while (value != 0) {
3158             digits -= 1;
3159             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
3160             value /= 10;
3161         }
3162         return string(buffer);
3163     }
3164 
3165     /**
3166      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
3167      */
3168     function toHexString(uint256 value) internal pure returns (string memory) {
3169         if (value == 0) {
3170             return "0x00";
3171         }
3172         uint256 temp = value;
3173         uint256 length = 0;
3174         while (temp != 0) {
3175             length++;
3176             temp >>= 8;
3177         }
3178         return toHexString(value, length);
3179     }
3180 
3181     /**
3182      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
3183      */
3184     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
3185         bytes memory buffer = new bytes(2 * length + 2);
3186         buffer[0] = "0";
3187         buffer[1] = "x";
3188         for (uint256 i = 2 * length + 1; i > 1; --i) {
3189             buffer[i] = _HEX_SYMBOLS[value & 0xf];
3190             value >>= 4;
3191         }
3192         require(value == 0, "Strings: hex length insufficient");
3193         return string(buffer);
3194     }
3195 }
3196 
3197 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
3198 
3199 
3200 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
3201 
3202 pragma solidity ^0.8.0;
3203 
3204 
3205 /**
3206  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
3207  *
3208  * These functions can be used to verify that a message was signed by the holder
3209  * of the private keys of a given address.
3210  */
3211 library ECDSA {
3212     enum RecoverError {
3213         NoError,
3214         InvalidSignature,
3215         InvalidSignatureLength,
3216         InvalidSignatureS,
3217         InvalidSignatureV
3218     }
3219 
3220     function _throwError(RecoverError error) private pure {
3221         if (error == RecoverError.NoError) {
3222             return; // no error: do nothing
3223         } else if (error == RecoverError.InvalidSignature) {
3224             revert("ECDSA: invalid signature");
3225         } else if (error == RecoverError.InvalidSignatureLength) {
3226             revert("ECDSA: invalid signature length");
3227         } else if (error == RecoverError.InvalidSignatureS) {
3228             revert("ECDSA: invalid signature 's' value");
3229         } else if (error == RecoverError.InvalidSignatureV) {
3230             revert("ECDSA: invalid signature 'v' value");
3231         }
3232     }
3233 
3234     /**
3235      * @dev Returns the address that signed a hashed message (`hash`) with
3236      * `signature` or error string. This address can then be used for verification purposes.
3237      *
3238      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
3239      * this function rejects them by requiring the `s` value to be in the lower
3240      * half order, and the `v` value to be either 27 or 28.
3241      *
3242      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
3243      * verification to be secure: it is possible to craft signatures that
3244      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
3245      * this is by receiving a hash of the original message (which may otherwise
3246      * be too long), and then calling {toEthSignedMessageHash} on it.
3247      *
3248      * Documentation for signature generation:
3249      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
3250      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
3251      *
3252      * _Available since v4.3._
3253      */
3254     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
3255         // Check the signature length
3256         // - case 65: r,s,v signature (standard)
3257         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
3258         if (signature.length == 65) {
3259             bytes32 r;
3260             bytes32 s;
3261             uint8 v;
3262             // ecrecover takes the signature parameters, and the only way to get them
3263             // currently is to use assembly.
3264             assembly {
3265                 r := mload(add(signature, 0x20))
3266                 s := mload(add(signature, 0x40))
3267                 v := byte(0, mload(add(signature, 0x60)))
3268             }
3269             return tryRecover(hash, v, r, s);
3270         } else if (signature.length == 64) {
3271             bytes32 r;
3272             bytes32 vs;
3273             // ecrecover takes the signature parameters, and the only way to get them
3274             // currently is to use assembly.
3275             assembly {
3276                 r := mload(add(signature, 0x20))
3277                 vs := mload(add(signature, 0x40))
3278             }
3279             return tryRecover(hash, r, vs);
3280         } else {
3281             return (address(0), RecoverError.InvalidSignatureLength);
3282         }
3283     }
3284 
3285     /**
3286      * @dev Returns the address that signed a hashed message (`hash`) with
3287      * `signature`. This address can then be used for verification purposes.
3288      *
3289      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
3290      * this function rejects them by requiring the `s` value to be in the lower
3291      * half order, and the `v` value to be either 27 or 28.
3292      *
3293      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
3294      * verification to be secure: it is possible to craft signatures that
3295      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
3296      * this is by receiving a hash of the original message (which may otherwise
3297      * be too long), and then calling {toEthSignedMessageHash} on it.
3298      */
3299     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
3300         (address recovered, RecoverError error) = tryRecover(hash, signature);
3301         _throwError(error);
3302         return recovered;
3303     }
3304 
3305     /**
3306      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
3307      *
3308      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
3309      *
3310      * _Available since v4.3._
3311      */
3312     function tryRecover(
3313         bytes32 hash,
3314         bytes32 r,
3315         bytes32 vs
3316     ) internal pure returns (address, RecoverError) {
3317         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
3318         uint8 v = uint8((uint256(vs) >> 255) + 27);
3319         return tryRecover(hash, v, r, s);
3320     }
3321 
3322     /**
3323      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
3324      *
3325      * _Available since v4.2._
3326      */
3327     function recover(
3328         bytes32 hash,
3329         bytes32 r,
3330         bytes32 vs
3331     ) internal pure returns (address) {
3332         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
3333         _throwError(error);
3334         return recovered;
3335     }
3336 
3337     /**
3338      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
3339      * `r` and `s` signature fields separately.
3340      *
3341      * _Available since v4.3._
3342      */
3343     function tryRecover(
3344         bytes32 hash,
3345         uint8 v,
3346         bytes32 r,
3347         bytes32 s
3348     ) internal pure returns (address, RecoverError) {
3349         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
3350         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
3351         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
3352         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
3353         //
3354         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
3355         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
3356         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
3357         // these malleable signatures as well.
3358         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
3359             return (address(0), RecoverError.InvalidSignatureS);
3360         }
3361         if (v != 27 && v != 28) {
3362             return (address(0), RecoverError.InvalidSignatureV);
3363         }
3364 
3365         // If the signature is valid (and not malleable), return the signer address
3366         address signer = ecrecover(hash, v, r, s);
3367         if (signer == address(0)) {
3368             return (address(0), RecoverError.InvalidSignature);
3369         }
3370 
3371         return (signer, RecoverError.NoError);
3372     }
3373 
3374     /**
3375      * @dev Overload of {ECDSA-recover} that receives the `v`,
3376      * `r` and `s` signature fields separately.
3377      */
3378     function recover(
3379         bytes32 hash,
3380         uint8 v,
3381         bytes32 r,
3382         bytes32 s
3383     ) internal pure returns (address) {
3384         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
3385         _throwError(error);
3386         return recovered;
3387     }
3388 
3389     /**
3390      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
3391      * produces hash corresponding to the one signed with the
3392      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
3393      * JSON-RPC method as part of EIP-191.
3394      *
3395      * See {recover}.
3396      */
3397     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
3398         // 32 is the length in bytes of hash,
3399         // enforced by the type signature above
3400         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
3401     }
3402 
3403     /**
3404      * @dev Returns an Ethereum Signed Message, created from `s`. This
3405      * produces hash corresponding to the one signed with the
3406      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
3407      * JSON-RPC method as part of EIP-191.
3408      *
3409      * See {recover}.
3410      */
3411     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
3412         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
3413     }
3414 
3415     /**
3416      * @dev Returns an Ethereum Signed Typed Data, created from a
3417      * `domainSeparator` and a `structHash`. This produces hash corresponding
3418      * to the one signed with the
3419      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
3420      * JSON-RPC method as part of EIP-712.
3421      *
3422      * See {recover}.
3423      */
3424     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
3425         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
3426     }
3427 }
3428 
3429 // File: contracts/Wizards.sol
3430 
3431 
3432 
3433 pragma solidity ^0.8.4;
3434 
3435 
3436 
3437 
3438 
3439 
3440 
3441 
3442 // contract by @kntrvlr
3443 
3444 contract Wizards is ERC721A, Ownable, ERC721AQueryable {
3445   using Strings for uint256;
3446 
3447   string public baseURI;
3448   uint256 public presaleCost = 0.05 ether;
3449   uint256 public cost = 0.09 ether;
3450   uint16 public maxSupply = 333; 
3451   uint8 public maxMintAmount = 20;
3452   bool public saleIsActive = true;
3453   address public whitelistAuthority = 0x7283C4B4993d005EA98Ae8f93584E2e93b978701;
3454   address public payoutAddress = 0x30e424E2d641612DAabfB4Aa00cffF62D45771a2;
3455   uint256 public presaleStart;
3456   uint256 public publicSaleStart = 253370764800;
3457   uint8 public whitelistAllocation = 1;
3458   mapping(address => uint8) public whitelistClaimed;
3459 
3460   constructor(
3461     string memory _name,
3462     string memory _symbol,
3463     string memory _initBaseURI,
3464     uint256 _presaleStart
3465   ) ERC721A(_name, _symbol) {
3466     setBaseURI(_initBaseURI);
3467     setPresaleStart(_presaleStart);
3468     mint(msg.sender, 50);
3469   }
3470 
3471   function _baseURI() internal view virtual override returns (string memory) {
3472     return baseURI;
3473   }
3474 
3475   function validateWhitelistSignature(bytes memory signature) public view returns (address) {
3476     bytes32 hashedAddress = keccak256((abi.encodePacked(msg.sender)));
3477     bytes32 messageDigest = keccak256(
3478         abi.encodePacked(
3479             "\x19Ethereum Signed Message:\n32", 
3480             hashedAddress
3481         )
3482     );
3483     address _signer = ECDSA.recover(messageDigest, signature);
3484     require(_signer == whitelistAuthority, "Invalid Authority");
3485     return _signer;
3486 }
3487  
3488   function mint(address _to, uint256 _mintAmount) public payable {
3489     uint256 supply = totalSupply();
3490     if (msg.sender != owner()) {
3491         require(saleIsActive, "Not yet active.");
3492         require(msg.value >= cost * _mintAmount, "Insufficient payment");
3493         require(block.timestamp >= publicSaleStart, "Not started");
3494         require(_mintAmount <= maxMintAmount, "Exceeded maxMintAmount");
3495     }
3496     require(_mintAmount > 0, "Mint amount can't be 0");
3497     require(supply + _mintAmount <= maxSupply, "Not enough remaining Wizards");
3498 
3499     _mint(_to, _mintAmount);
3500   }
3501 
3502   function presaleMint(address _to, uint256 _mintAmount, bytes memory signature) public payable {
3503     validateWhitelistSignature(signature);
3504     uint256 supply = totalSupply();
3505     if (msg.sender != owner()) {
3506         require(saleIsActive, "Not yet active.");
3507         require(msg.value >= presaleCost * _mintAmount, "Insufficient payment");
3508         require(block.timestamp >= presaleStart, "Not started");
3509     }
3510     require(block.timestamp < publicSaleStart, "Presale closed.");
3511     require((whitelistClaimed[msg.sender] + _mintAmount) <= whitelistAllocation, "Allocation exceeded");
3512     require(_mintAmount > 0, "Mint Amount can't be 0");
3513     require(_mintAmount <= maxMintAmount, "Exceeded limit per mint");
3514     require(supply + _mintAmount <= maxSupply, "Not enough remaining Wizards");
3515     whitelistClaimed[msg.sender] = whitelistClaimed[msg.sender] + uint8(_mintAmount);
3516 
3517     _mint(_to, _mintAmount);
3518   }
3519 
3520   function tokenURI(uint256 tokenId)
3521     public
3522     view
3523     virtual
3524     override
3525     returns (string memory)
3526   {
3527     require(
3528       _exists(tokenId),
3529       "ERC721Metadata: URI query for nonexistent token"
3530     );
3531 
3532     string memory currentBaseURI = _baseURI();
3533     return bytes(currentBaseURI).length > 0
3534         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
3535         : "";
3536   }
3537 
3538   function setWhitelistAuthority(address _address) public onlyOwner {
3539     whitelistAuthority = _address;
3540   }
3541 
3542   function setWhitelistAllocation(uint8 _newAllocation) public onlyOwner {
3543     require(_newAllocation <= 5, "Max 5");
3544     whitelistAllocation = _newAllocation;
3545   }
3546 
3547   function setPresaleStart(uint256 _timestamp) public onlyOwner {
3548     presaleStart = _timestamp;
3549   }
3550 
3551   function setPublicSaleStart(uint256 _timestamp) public onlyOwner {
3552     publicSaleStart = _timestamp;
3553   }
3554 
3555   function setCost(uint256 _newCost) public onlyOwner {
3556     cost = _newCost;
3557   }
3558 
3559   function setPresaleCost(uint256 _newCost) public onlyOwner {
3560     presaleCost = _newCost;
3561   }
3562 
3563   function setMaxSupply(uint16 _newMaxSupply) public onlyOwner {
3564     uint256 supply = totalSupply();
3565     require(_newMaxSupply >= supply, "Can't be lower than current supply");
3566     require(_newMaxSupply <= 3333, "3333 is hard max");
3567     maxSupply = _newMaxSupply;
3568   }
3569 
3570   function setBaseURI(string memory _newBaseURI) public onlyOwner {
3571     baseURI = _newBaseURI;
3572   }
3573 
3574   function setSaleIsActive(bool _state) public onlyOwner {
3575     saleIsActive = _state;
3576   }
3577 
3578   function withdraw(uint256 _amount) public payable onlyOwner {
3579     uint toWithdraw;
3580     uint balance = address(this).balance;
3581     if (_amount == 0) {
3582       toWithdraw = balance;
3583     } else {
3584       toWithdraw = _amount;
3585     }
3586     // =============================================================================
3587     (bool os, ) = payable(payoutAddress).call{value: toWithdraw}("");
3588     require(os);
3589     // =============================================================================
3590   }
3591 }