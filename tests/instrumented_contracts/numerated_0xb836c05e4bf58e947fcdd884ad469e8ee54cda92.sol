1 pragma solidity ^0.8.4;
2 
3 /**
4  * @dev Interface of ERC721A.
5  */
6 interface IERC721A {
7     /**
8      * The caller must own the token or be an approved operator.
9      */
10     error ApprovalCallerNotOwnerNorApproved();
11 
12     /**
13      * The token does not exist.
14      */
15     error ApprovalQueryForNonexistentToken();
16 
17     /**
18      * Cannot query the balance for the zero address.
19      */
20     error BalanceQueryForZeroAddress();
21 
22     /**
23      * Cannot mint to the zero address.
24      */
25     error MintToZeroAddress();
26 
27     /**
28      * The quantity of tokens minted must be more than zero.
29      */
30     error MintZeroQuantity();
31 
32     /**
33      * The token does not exist.
34      */
35     error OwnerQueryForNonexistentToken();
36 
37     /**
38      * The caller must own the token or be an approved operator.
39      */
40     error TransferCallerNotOwnerNorApproved();
41 
42     /**
43      * The token must be owned by `from`.
44      */
45     error TransferFromIncorrectOwner();
46 
47     /**
48      * Cannot safely transfer to a contract that does not implement the
49      * ERC721Receiver interface.
50      */
51     error TransferToNonERC721ReceiverImplementer();
52 
53     /**
54      * Cannot transfer to the zero address.
55      */
56     error TransferToZeroAddress();
57 
58     /**
59      * The token does not exist.
60      */
61     error URIQueryForNonexistentToken();
62 
63     /**
64      * The `quantity` minted with ERC2309 exceeds the safety limit.
65      */
66     error MintERC2309QuantityExceedsLimit();
67 
68     /**
69      * The `extraData` cannot be set on an unintialized ownership slot.
70      */
71     error OwnershipNotInitializedForExtraData();
72 
73     // =============================================================
74     //                            STRUCTS
75     // =============================================================
76 
77     struct TokenOwnership {
78         // The address of the owner.
79         address addr;
80         // Stores the start time of ownership with minimal overhead for tokenomics.
81         uint64 startTimestamp;
82         // Whether the token has been burned.
83         bool burned;
84         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
85         uint24 extraData;
86     }
87 
88     // =============================================================
89     //                         TOKEN COUNTERS
90     // =============================================================
91 
92     /**
93      * @dev Returns the total number of tokens in existence.
94      * Burned tokens will reduce the count.
95      * To get the total number of tokens minted, please see {_totalMinted}.
96      */
97     function totalSupply() external view returns (uint256);
98 
99     // =============================================================
100     //                            IERC165
101     // =============================================================
102 
103     /**
104      * @dev Returns true if this contract implements the interface defined by
105      * `interfaceId`. See the corresponding
106      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
107      * to learn more about how these ids are created.
108      *
109      * This function call must use less than 30000 gas.
110      */
111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
112 
113     // =============================================================
114     //                            IERC721
115     // =============================================================
116 
117     /**
118      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
124      */
125     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables or disables
129      * (`approved`) `operator` to manage all of its assets.
130      */
131     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
132 
133     /**
134      * @dev Returns the number of tokens in `owner`'s account.
135      */
136     function balanceOf(address owner) external view returns (uint256 balance);
137 
138     /**
139      * @dev Returns the owner of the `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function ownerOf(uint256 tokenId) external view returns (address owner);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`,
149      * checking first that contract recipients are aware of the ERC721 protocol
150      * to prevent tokens from being forever locked.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be have been allowed to move
158      * this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement
160      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external payable;
170 
171     /**
172      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId
178     ) external payable;
179 
180     /**
181      * @dev Transfers `tokenId` from `from` to `to`.
182      *
183      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
184      * whenever possible.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token
192      * by either {approve} or {setApprovalForAll}.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external payable;
201 
202     /**
203      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
204      * The approval is cleared when the token is transferred.
205      *
206      * Only a single account can be approved at a time, so approving the
207      * zero address clears previous approvals.
208      *
209      * Requirements:
210      *
211      * - The caller must own the token or be an approved operator.
212      * - `tokenId` must exist.
213      *
214      * Emits an {Approval} event.
215      */
216     function approve(address to, uint256 tokenId) external payable;
217 
218     /**
219      * @dev Approve or remove `operator` as an operator for the caller.
220      * Operators can call {transferFrom} or {safeTransferFrom}
221      * for any token owned by the caller.
222      *
223      * Requirements:
224      *
225      * - The `operator` cannot be the caller.
226      *
227      * Emits an {ApprovalForAll} event.
228      */
229     function setApprovalForAll(address operator, bool _approved) external;
230 
231     /**
232      * @dev Returns the account approved for `tokenId` token.
233      *
234      * Requirements:
235      *
236      * - `tokenId` must exist.
237      */
238     function getApproved(uint256 tokenId) external view returns (address operator);
239 
240     /**
241      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
242      *
243      * See {setApprovalForAll}.
244      */
245     function isApprovedForAll(address owner, address operator) external view returns (bool);
246 
247     // =============================================================
248     //                        IERC721Metadata
249     // =============================================================
250 
251     /**
252      * @dev Returns the token collection name.
253      */
254     function name() external view returns (string memory);
255 
256     /**
257      * @dev Returns the token collection symbol.
258      */
259     function symbol() external view returns (string memory);
260 
261     /**
262      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
263      */
264     function tokenURI(uint256 tokenId) external view returns (string memory);
265 
266     // =============================================================
267     //                           IERC2309
268     // =============================================================
269 
270     /**
271      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
272      * (inclusive) is transferred from `from` to `to`, as defined in the
273      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
274      *
275      * See {_mintERC2309} for more details.
276      */
277     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
278 }
279 
280 
281 
282 
283 pragma solidity ^0.8.4;
284 
285 /**
286  * @dev Interface of ERC721 token receiver.
287  */
288 interface ERC721A__IERC721Receiver {
289     function onERC721Received(
290         address operator,
291         address from,
292         uint256 tokenId,
293         bytes calldata data
294     ) external returns (bytes4);
295 }
296 
297 /**
298  * @title ERC721A
299  *
300  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
301  * Non-Fungible Token Standard, including the Metadata extension.
302  * Optimized for lower gas during batch mints.
303  *
304  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
305  * starting from `_startTokenId()`.
306  *
307  * Assumptions:
308  *
309  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
310  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
311  */
312 contract ERC721A is IERC721A {
313     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
314     struct TokenApprovalRef {
315         address value;
316     }
317 
318     // =============================================================
319     //                           CONSTANTS
320     // =============================================================
321 
322     // Mask of an entry in packed address data.
323     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
324 
325     // The bit position of `numberMinted` in packed address data.
326     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
327 
328     // The bit position of `numberBurned` in packed address data.
329     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
330 
331     // The bit position of `aux` in packed address data.
332     uint256 private constant _BITPOS_AUX = 192;
333 
334     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
335     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
336 
337     // The bit position of `startTimestamp` in packed ownership.
338     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
339 
340     // The bit mask of the `burned` bit in packed ownership.
341     uint256 private constant _BITMASK_BURNED = 1 << 224;
342 
343     // The bit position of the `nextInitialized` bit in packed ownership.
344     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
345 
346     // The bit mask of the `nextInitialized` bit in packed ownership.
347     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
348 
349     // The bit position of `extraData` in packed ownership.
350     uint256 private constant _BITPOS_EXTRA_DATA = 232;
351 
352     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
353     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
354 
355     // The mask of the lower 160 bits for addresses.
356     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
357 
358     // The maximum `quantity` that can be minted with {_mintERC2309}.
359     // This limit is to prevent overflows on the address data entries.
360     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
361     // is required to cause an overflow, which is unrealistic.
362     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
363 
364     // The `Transfer` event signature is given by:
365     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
366     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
367         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
368 
369     // =============================================================
370     //                            STORAGE
371     // =============================================================
372 
373     // The next token ID to be minted.
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
387     // See {_packedOwnershipOf} implementation for details.
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
407     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
408 
409     // Mapping from owner to operator approvals
410     mapping(address => mapping(address => bool)) private _operatorApprovals;
411 
412     // =============================================================
413     //                          CONSTRUCTOR
414     // =============================================================
415 
416     constructor(string memory name_, string memory symbol_) {
417         _name = name_;
418         _symbol = symbol_;
419         _currentIndex = _startTokenId();
420     }
421 
422     // =============================================================
423     //                   TOKEN COUNTING OPERATIONS
424     // =============================================================
425 
426     /**
427      * @dev Returns the starting token ID.
428      * To change the starting token ID, please override this function.
429      */
430     function _startTokenId() internal view virtual returns (uint256) {
431         return 0;
432     }
433 
434     /**
435      * @dev Returns the next token ID to be minted.
436      */
437     function _nextTokenId() internal view virtual returns (uint256) {
438         return _currentIndex;
439     }
440 
441     /**
442      * @dev Returns the total number of tokens in existence.
443      * Burned tokens will reduce the count.
444      * To get the total number of tokens minted, please see {_totalMinted}.
445      */
446     function totalSupply() public view virtual override returns (uint256) {
447         // Counter underflow is impossible as _burnCounter cannot be incremented
448         // more than `_currentIndex - _startTokenId()` times.
449         unchecked {
450             return _currentIndex - _burnCounter - _startTokenId();
451         }
452     }
453 
454     /**
455      * @dev Returns the total amount of tokens minted in the contract.
456      */
457     function _totalMinted() internal view virtual returns (uint256) {
458         // Counter underflow is impossible as `_currentIndex` does not decrement,
459         // and it is initialized to `_startTokenId()`.
460         unchecked {
461             return _currentIndex - _startTokenId();
462         }
463     }
464 
465     /**
466      * @dev Returns the total number of tokens burned.
467      */
468     function _totalBurned() internal view virtual returns (uint256) {
469         return _burnCounter;
470     }
471 
472     // =============================================================
473     //                    ADDRESS DATA OPERATIONS
474     // =============================================================
475 
476     /**
477      * @dev Returns the number of tokens in `owner`'s account.
478      */
479     function balanceOf(address owner) public view virtual override returns (uint256) {
480         if (owner == address(0)) revert BalanceQueryForZeroAddress();
481         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
482     }
483 
484     /**
485      * Returns the number of tokens minted by `owner`.
486      */
487     function _numberMinted(address owner) internal view returns (uint256) {
488         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
489     }
490 
491     /**
492      * Returns the number of tokens burned by or on behalf of `owner`.
493      */
494     function _numberBurned(address owner) internal view returns (uint256) {
495         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
496     }
497 
498     /**
499      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
500      */
501     function _getAux(address owner) internal view returns (uint64) {
502         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
503     }
504 
505     /**
506      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
507      * If there are multiple variables, please pack them into a uint64.
508      */
509     function _setAux(address owner, uint64 aux) internal virtual {
510         uint256 packed = _packedAddressData[owner];
511         uint256 auxCasted;
512         // Cast `aux` with assembly to avoid redundant masking.
513         assembly {
514             auxCasted := aux
515         }
516         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
517         _packedAddressData[owner] = packed;
518     }
519 
520     // =============================================================
521     //                            IERC165
522     // =============================================================
523 
524     /**
525      * @dev Returns true if this contract implements the interface defined by
526      * `interfaceId`. See the corresponding
527      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
528      * to learn more about how these ids are created.
529      *
530      * This function call must use less than 30000 gas.
531      */
532     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533         // The interface IDs are constants representing the first 4 bytes
534         // of the XOR of all function selectors in the interface.
535         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
536         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
537         return
538             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
539             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
540             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
541     }
542 
543     // =============================================================
544     //                        IERC721Metadata
545     // =============================================================
546 
547     /**
548      * @dev Returns the token collection name.
549      */
550     function name() public view virtual override returns (string memory) {
551         return _name;
552     }
553 
554     /**
555      * @dev Returns the token collection symbol.
556      */
557     function symbol() public view virtual override returns (string memory) {
558         return _symbol;
559     }
560 
561     /**
562      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
563      */
564     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
565         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
566 
567         string memory baseURI = _baseURI();
568         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
569     }
570 
571     /**
572      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
573      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
574      * by default, it can be overridden in child contracts.
575      */
576     function _baseURI() internal view virtual returns (string memory) {
577         return '';
578     }
579 
580     // =============================================================
581     //                     OWNERSHIPS OPERATIONS
582     // =============================================================
583 
584     /**
585      * @dev Returns the owner of the `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
592         return address(uint160(_packedOwnershipOf(tokenId)));
593     }
594 
595     /**
596      * @dev Gas spent here starts off proportional to the maximum mint batch size.
597      * It gradually moves to O(1) as tokens get transferred around over time.
598      */
599     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
600         return _unpackedOwnership(_packedOwnershipOf(tokenId));
601     }
602 
603     /**
604      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
605      */
606     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
607         return _unpackedOwnership(_packedOwnerships[index]);
608     }
609 
610     /**
611      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
612      */
613     function _initializeOwnershipAt(uint256 index) internal virtual {
614         if (_packedOwnerships[index] == 0) {
615             _packedOwnerships[index] = _packedOwnershipOf(index);
616         }
617     }
618 
619     /**
620      * Returns the packed ownership data of `tokenId`.
621      */
622     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
623         uint256 curr = tokenId;
624 
625         unchecked {
626             if (_startTokenId() <= curr)
627                 if (curr < _currentIndex) {
628                     uint256 packed = _packedOwnerships[curr];
629                     // If not burned.
630                     if (packed & _BITMASK_BURNED == 0) {
631                         // Invariant:
632                         // There will always be an initialized ownership slot
633                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
634                         // before an unintialized ownership slot
635                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
636                         // Hence, `curr` will not underflow.
637                         //
638                         // We can directly compare the packed value.
639                         // If the address is zero, packed will be zero.
640                         while (packed == 0) {
641                             packed = _packedOwnerships[--curr];
642                         }
643                         return packed;
644                     }
645                 }
646         }
647         revert OwnerQueryForNonexistentToken();
648     }
649 
650     /**
651      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
652      */
653     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
654         ownership.addr = address(uint160(packed));
655         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
656         ownership.burned = packed & _BITMASK_BURNED != 0;
657         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
658     }
659 
660     /**
661      * @dev Packs ownership data into a single uint256.
662      */
663     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
664         assembly {
665             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
666             owner := and(owner, _BITMASK_ADDRESS)
667             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
668             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
669         }
670     }
671 
672     /**
673      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
674      */
675     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
676         // For branchless setting of the `nextInitialized` flag.
677         assembly {
678             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
679             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
680         }
681     }
682 
683     // =============================================================
684     //                      APPROVAL OPERATIONS
685     // =============================================================
686 
687     /**
688      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
689      * The approval is cleared when the token is transferred.
690      *
691      * Only a single account can be approved at a time, so approving the
692      * zero address clears previous approvals.
693      *
694      * Requirements:
695      *
696      * - The caller must own the token or be an approved operator.
697      * - `tokenId` must exist.
698      *
699      * Emits an {Approval} event.
700      */
701     function approve(address to, uint256 tokenId) public payable virtual override {
702         address owner = ownerOf(tokenId);
703 
704         if (_msgSenderERC721A() != owner)
705             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
706                 revert ApprovalCallerNotOwnerNorApproved();
707             }
708 
709         _tokenApprovals[tokenId].value = to;
710         emit Approval(owner, to, tokenId);
711     }
712 
713     /**
714      * @dev Returns the account approved for `tokenId` token.
715      *
716      * Requirements:
717      *
718      * - `tokenId` must exist.
719      */
720     function getApproved(uint256 tokenId) public view virtual override returns (address) {
721         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
722 
723         return _tokenApprovals[tokenId].value;
724     }
725 
726     /**
727      * @dev Approve or remove `operator` as an operator for the caller.
728      * Operators can call {transferFrom} or {safeTransferFrom}
729      * for any token owned by the caller.
730      *
731      * Requirements:
732      *
733      * - The `operator` cannot be the caller.
734      *
735      * Emits an {ApprovalForAll} event.
736      */
737     function setApprovalForAll(address operator, bool approved) public virtual override {
738         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
739         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
740     }
741 
742     /**
743      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
744      *
745      * See {setApprovalForAll}.
746      */
747     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
748         return _operatorApprovals[owner][operator];
749     }
750 
751     /**
752      * @dev Returns whether `tokenId` exists.
753      *
754      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
755      *
756      * Tokens start existing when they are minted. See {_mint}.
757      */
758     function _exists(uint256 tokenId) internal view virtual returns (bool) {
759         return
760             _startTokenId() <= tokenId &&
761             tokenId < _currentIndex && // If within bounds,
762             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
763     }
764 
765     /**
766      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
767      */
768     function _isSenderApprovedOrOwner(
769         address approvedAddress,
770         address owner,
771         address msgSender
772     ) private pure returns (bool result) {
773         assembly {
774             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
775             owner := and(owner, _BITMASK_ADDRESS)
776             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
777             msgSender := and(msgSender, _BITMASK_ADDRESS)
778             // `msgSender == owner || msgSender == approvedAddress`.
779             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
780         }
781     }
782 
783     /**
784      * @dev Returns the storage slot and value for the approved address of `tokenId`.
785      */
786     function _getApprovedSlotAndAddress(uint256 tokenId)
787         private
788         view
789         returns (uint256 approvedAddressSlot, address approvedAddress)
790     {
791         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
792         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
793         assembly {
794             approvedAddressSlot := tokenApproval.slot
795             approvedAddress := sload(approvedAddressSlot)
796         }
797     }
798 
799     // =============================================================
800     //                      TRANSFER OPERATIONS
801     // =============================================================
802 
803     /**
804      * @dev Transfers `tokenId` from `from` to `to`.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must be owned by `from`.
811      * - If the caller is not `from`, it must be approved to move this token
812      * by either {approve} or {setApprovalForAll}.
813      *
814      * Emits a {Transfer} event.
815      */
816     function transferFrom(
817         address from,
818         address to,
819         uint256 tokenId
820     ) public payable virtual override {
821         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
822 
823         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
824 
825         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
826 
827         // The nested ifs save around 20+ gas over a compound boolean condition.
828         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
829             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
830 
831         if (to == address(0)) revert TransferToZeroAddress();
832 
833         _beforeTokenTransfers(from, to, tokenId, 1);
834 
835         // Clear approvals from the previous owner.
836         assembly {
837             if approvedAddress {
838                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
839                 sstore(approvedAddressSlot, 0)
840             }
841         }
842 
843         // Underflow of the sender's balance is impossible because we check for
844         // ownership above and the recipient's balance can't realistically overflow.
845         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
846         unchecked {
847             // We can directly increment and decrement the balances.
848             --_packedAddressData[from]; // Updates: `balance -= 1`.
849             ++_packedAddressData[to]; // Updates: `balance += 1`.
850 
851             // Updates:
852             // - `address` to the next owner.
853             // - `startTimestamp` to the timestamp of transfering.
854             // - `burned` to `false`.
855             // - `nextInitialized` to `true`.
856             _packedOwnerships[tokenId] = _packOwnershipData(
857                 to,
858                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
859             );
860 
861             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
862             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
863                 uint256 nextTokenId = tokenId + 1;
864                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
865                 if (_packedOwnerships[nextTokenId] == 0) {
866                     // If the next slot is within bounds.
867                     if (nextTokenId != _currentIndex) {
868                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
869                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
870                     }
871                 }
872             }
873         }
874 
875         emit Transfer(from, to, tokenId);
876         _afterTokenTransfers(from, to, tokenId, 1);
877     }
878 
879     /**
880      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public payable virtual override {
887         safeTransferFrom(from, to, tokenId, '');
888     }
889 
890     /**
891      * @dev Safely transfers `tokenId` token from `from` to `to`.
892      *
893      * Requirements:
894      *
895      * - `from` cannot be the zero address.
896      * - `to` cannot be the zero address.
897      * - `tokenId` token must exist and be owned by `from`.
898      * - If the caller is not `from`, it must be approved to move this token
899      * by either {approve} or {setApprovalForAll}.
900      * - If `to` refers to a smart contract, it must implement
901      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
902      *
903      * Emits a {Transfer} event.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) public payable virtual override {
911         transferFrom(from, to, tokenId);
912         if (to.code.length != 0)
913             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
914                 revert TransferToNonERC721ReceiverImplementer();
915             }
916     }
917 
918     /**
919      * @dev Hook that is called before a set of serially-ordered token IDs
920      * are about to be transferred. This includes minting.
921      * And also called before burning one token.
922      *
923      * `startTokenId` - the first token ID to be transferred.
924      * `quantity` - the amount to be transferred.
925      *
926      * Calling conditions:
927      *
928      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
929      * transferred to `to`.
930      * - When `from` is zero, `tokenId` will be minted for `to`.
931      * - When `to` is zero, `tokenId` will be burned by `from`.
932      * - `from` and `to` are never both zero.
933      */
934     function _beforeTokenTransfers(
935         address from,
936         address to,
937         uint256 startTokenId,
938         uint256 quantity
939     ) internal virtual {}
940 
941     /**
942      * @dev Hook that is called after a set of serially-ordered token IDs
943      * have been transferred. This includes minting.
944      * And also called after one token has been burned.
945      *
946      * `startTokenId` - the first token ID to be transferred.
947      * `quantity` - the amount to be transferred.
948      *
949      * Calling conditions:
950      *
951      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
952      * transferred to `to`.
953      * - When `from` is zero, `tokenId` has been minted for `to`.
954      * - When `to` is zero, `tokenId` has been burned by `from`.
955      * - `from` and `to` are never both zero.
956      */
957     function _afterTokenTransfers(
958         address from,
959         address to,
960         uint256 startTokenId,
961         uint256 quantity
962     ) internal virtual {}
963 
964     /**
965      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
966      *
967      * `from` - Previous owner of the given token ID.
968      * `to` - Target address that will receive the token.
969      * `tokenId` - Token ID to be transferred.
970      * `_data` - Optional data to send along with the call.
971      *
972      * Returns whether the call correctly returned the expected magic value.
973      */
974     function _checkContractOnERC721Received(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) private returns (bool) {
980         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
981             bytes4 retval
982         ) {
983             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
984         } catch (bytes memory reason) {
985             if (reason.length == 0) {
986                 revert TransferToNonERC721ReceiverImplementer();
987             } else {
988                 assembly {
989                     revert(add(32, reason), mload(reason))
990                 }
991             }
992         }
993     }
994 
995     // =============================================================
996     //                        MINT OPERATIONS
997     // =============================================================
998 
999     /**
1000      * @dev Mints `quantity` tokens and transfers them to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `quantity` must be greater than 0.
1006      *
1007      * Emits a {Transfer} event for each mint.
1008      */
1009     function _mint(address to, uint256 quantity) internal virtual {
1010         uint256 startTokenId = _currentIndex;
1011         if (quantity == 0) revert MintZeroQuantity();
1012 
1013         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1014 
1015         // Overflows are incredibly unrealistic.
1016         // `balance` and `numberMinted` have a maximum limit of 2**64.
1017         // `tokenId` has a maximum limit of 2**256.
1018         unchecked {
1019             // Updates:
1020             // - `balance += quantity`.
1021             // - `numberMinted += quantity`.
1022             //
1023             // We can directly add to the `balance` and `numberMinted`.
1024             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1025 
1026             // Updates:
1027             // - `address` to the owner.
1028             // - `startTimestamp` to the timestamp of minting.
1029             // - `burned` to `false`.
1030             // - `nextInitialized` to `quantity == 1`.
1031             _packedOwnerships[startTokenId] = _packOwnershipData(
1032                 to,
1033                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1034             );
1035 
1036             uint256 toMasked;
1037             uint256 end = startTokenId + quantity;
1038 
1039             // Use assembly to loop and emit the `Transfer` event for gas savings.
1040             // The duplicated `log4` removes an extra check and reduces stack juggling.
1041             // The assembly, together with the surrounding Solidity code, have been
1042             // delicately arranged to nudge the compiler into producing optimized opcodes.
1043             assembly {
1044                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1045                 toMasked := and(to, _BITMASK_ADDRESS)
1046                 // Emit the `Transfer` event.
1047                 log4(
1048                     0, // Start of data (0, since no data).
1049                     0, // End of data (0, since no data).
1050                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1051                     0, // `address(0)`.
1052                     toMasked, // `to`.
1053                     startTokenId // `tokenId`.
1054                 )
1055 
1056                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1057                 // that overflows uint256 will make the loop run out of gas.
1058                 // The compiler will optimize the `iszero` away for performance.
1059                 for {
1060                     let tokenId := add(startTokenId, 1)
1061                 } iszero(eq(tokenId, end)) {
1062                     tokenId := add(tokenId, 1)
1063                 } {
1064                     // Emit the `Transfer` event. Similar to above.
1065                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1066                 }
1067             }
1068             if (toMasked == 0) revert MintToZeroAddress();
1069 
1070             _currentIndex = end;
1071         }
1072         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1073     }
1074 
1075     /**
1076      * @dev Mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * This function is intended for efficient minting only during contract creation.
1079      *
1080      * It emits only one {ConsecutiveTransfer} as defined in
1081      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1082      * instead of a sequence of {Transfer} event(s).
1083      *
1084      * Calling this function outside of contract creation WILL make your contract
1085      * non-compliant with the ERC721 standard.
1086      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1087      * {ConsecutiveTransfer} event is only permissible during contract creation.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * Emits a {ConsecutiveTransfer} event.
1095      */
1096     function _mintERC2309(address to, uint256 quantity) internal virtual {
1097         uint256 startTokenId = _currentIndex;
1098         if (to == address(0)) revert MintToZeroAddress();
1099         if (quantity == 0) revert MintZeroQuantity();
1100         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1105         unchecked {
1106             // Updates:
1107             // - `balance += quantity`.
1108             // - `numberMinted += quantity`.
1109             //
1110             // We can directly add to the `balance` and `numberMinted`.
1111             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1112 
1113             // Updates:
1114             // - `address` to the owner.
1115             // - `startTimestamp` to the timestamp of minting.
1116             // - `burned` to `false`.
1117             // - `nextInitialized` to `quantity == 1`.
1118             _packedOwnerships[startTokenId] = _packOwnershipData(
1119                 to,
1120                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1121             );
1122 
1123             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1124 
1125             _currentIndex = startTokenId + quantity;
1126         }
1127         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128     }
1129 
1130     /**
1131      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - If `to` refers to a smart contract, it must implement
1136      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1137      * - `quantity` must be greater than 0.
1138      *
1139      * See {_mint}.
1140      *
1141      * Emits a {Transfer} event for each mint.
1142      */
1143     function _safeMint(
1144         address to,
1145         uint256 quantity,
1146         bytes memory _data
1147     ) internal virtual {
1148         _mint(to, quantity);
1149 
1150         unchecked {
1151             if (to.code.length != 0) {
1152                 uint256 end = _currentIndex;
1153                 uint256 index = end - quantity;
1154                 do {
1155                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1156                         revert TransferToNonERC721ReceiverImplementer();
1157                     }
1158                 } while (index < end);
1159                 // Reentrancy protection.
1160                 if (_currentIndex != end) revert();
1161             }
1162         }
1163     }
1164 
1165     /**
1166      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1167      */
1168     function _safeMint(address to, uint256 quantity) internal virtual {
1169         _safeMint(to, quantity, '');
1170     }
1171 
1172     // =============================================================
1173     //                        BURN OPERATIONS
1174     // =============================================================
1175 
1176     /**
1177      * @dev Equivalent to `_burn(tokenId, false)`.
1178      */
1179     function _burn(uint256 tokenId) internal virtual {
1180         _burn(tokenId, false);
1181     }
1182 
1183     /**
1184      * @dev Destroys `tokenId`.
1185      * The approval is cleared when the token is burned.
1186      *
1187      * Requirements:
1188      *
1189      * - `tokenId` must exist.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1194         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1195 
1196         address from = address(uint160(prevOwnershipPacked));
1197 
1198         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1199 
1200         if (approvalCheck) {
1201             // The nested ifs save around 20+ gas over a compound boolean condition.
1202             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1203                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1204         }
1205 
1206         _beforeTokenTransfers(from, address(0), tokenId, 1);
1207 
1208         // Clear approvals from the previous owner.
1209         assembly {
1210             if approvedAddress {
1211                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1212                 sstore(approvedAddressSlot, 0)
1213             }
1214         }
1215 
1216         // Underflow of the sender's balance is impossible because we check for
1217         // ownership above and the recipient's balance can't realistically overflow.
1218         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1219         unchecked {
1220             // Updates:
1221             // - `balance -= 1`.
1222             // - `numberBurned += 1`.
1223             //
1224             // We can directly decrement the balance, and increment the number burned.
1225             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1226             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1227 
1228             // Updates:
1229             // - `address` to the last owner.
1230             // - `startTimestamp` to the timestamp of burning.
1231             // - `burned` to `true`.
1232             // - `nextInitialized` to `true`.
1233             _packedOwnerships[tokenId] = _packOwnershipData(
1234                 from,
1235                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1236             );
1237 
1238             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1239             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1240                 uint256 nextTokenId = tokenId + 1;
1241                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1242                 if (_packedOwnerships[nextTokenId] == 0) {
1243                     // If the next slot is within bounds.
1244                     if (nextTokenId != _currentIndex) {
1245                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1246                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1247                     }
1248                 }
1249             }
1250         }
1251 
1252         emit Transfer(from, address(0), tokenId);
1253         _afterTokenTransfers(from, address(0), tokenId, 1);
1254 
1255         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1256         unchecked {
1257             _burnCounter++;
1258         }
1259     }
1260 
1261     // =============================================================
1262     //                     EXTRA DATA OPERATIONS
1263     // =============================================================
1264 
1265     /**
1266      * @dev Directly sets the extra data for the ownership data `index`.
1267      */
1268     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1269         uint256 packed = _packedOwnerships[index];
1270         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1271         uint256 extraDataCasted;
1272         // Cast `extraData` with assembly to avoid redundant masking.
1273         assembly {
1274             extraDataCasted := extraData
1275         }
1276         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1277         _packedOwnerships[index] = packed;
1278     }
1279 
1280     /**
1281      * @dev Called during each token transfer to set the 24bit `extraData` field.
1282      * Intended to be overridden by the cosumer contract.
1283      *
1284      * `previousExtraData` - the value of `extraData` before transfer.
1285      *
1286      * Calling conditions:
1287      *
1288      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1289      * transferred to `to`.
1290      * - When `from` is zero, `tokenId` will be minted for `to`.
1291      * - When `to` is zero, `tokenId` will be burned by `from`.
1292      * - `from` and `to` are never both zero.
1293      */
1294     function _extraData(
1295         address from,
1296         address to,
1297         uint24 previousExtraData
1298     ) internal view virtual returns (uint24) {}
1299 
1300     /**
1301      * @dev Returns the next extra data for the packed ownership data.
1302      * The returned result is shifted into position.
1303      */
1304     function _nextExtraData(
1305         address from,
1306         address to,
1307         uint256 prevOwnershipPacked
1308     ) private view returns (uint256) {
1309         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1310         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1311     }
1312 
1313     // =============================================================
1314     //                       OTHER OPERATIONS
1315     // =============================================================
1316 
1317     /**
1318      * @dev Returns the message sender (defaults to `msg.sender`).
1319      *
1320      * If you are writing GSN compatible contracts, you need to override this function.
1321      */
1322     function _msgSenderERC721A() internal view virtual returns (address) {
1323         return msg.sender;
1324     }
1325 
1326     /**
1327      * @dev Converts a uint256 to its ASCII string decimal representation.
1328      */
1329     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1330         assembly {
1331             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1332             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1333             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1334             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1335             let m := add(mload(0x40), 0xa0)
1336             // Update the free memory pointer to allocate.
1337             mstore(0x40, m)
1338             // Assign the `str` to the end.
1339             str := sub(m, 0x20)
1340             // Zeroize the slot after the string.
1341             mstore(str, 0)
1342 
1343             // Cache the end of the memory to calculate the length later.
1344             let end := str
1345 
1346             // We write the string from rightmost digit to leftmost digit.
1347             // The following is essentially a do-while loop that also handles the zero case.
1348             // prettier-ignore
1349             for { let temp := value } 1 {} {
1350                 str := sub(str, 1)
1351                 // Write the character to the pointer.
1352                 // The ASCII index of the '0' character is 48.
1353                 mstore8(str, add(48, mod(temp, 10)))
1354                 // Keep dividing `temp` until zero.
1355                 temp := div(temp, 10)
1356                 // prettier-ignore
1357                 if iszero(temp) { break }
1358             }
1359 
1360             let length := sub(end, str)
1361             // Move the pointer 32 bytes leftwards to make room for the length.
1362             str := sub(str, 0x20)
1363             // Store the length.
1364             mstore(str, length)
1365         }
1366     }
1367 }
1368 
1369 
1370 
1371 
1372 pragma solidity ^0.8.0;
1373 
1374 /**
1375  * @dev Contract module that helps prevent reentrant calls to a function.
1376  *
1377  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1378  * available, which can be applied to functions to make sure there are no nested
1379  * (reentrant) calls to them.
1380  *
1381  * Note that because there is a single `nonReentrant` guard, functions marked as
1382  * `nonReentrant` may not call one another. This can be worked around by making
1383  * those functions `private`, and then adding `external` `nonReentrant` entry
1384  * points to them.
1385  *
1386  * TIP: If you would like to learn more about reentrancy and alternative ways
1387  * to protect against it, check out our blog post
1388  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1389  */
1390 abstract contract ReentrancyGuard {
1391     // Booleans are more expensive than uint256 or any type that takes up a full
1392     // word because each write operation emits an extra SLOAD to first read the
1393     // slot's contents, replace the bits taken up by the boolean, and then write
1394     // back. This is the compiler's defense against contract upgrades and
1395     // pointer aliasing, and it cannot be disabled.
1396 
1397     // The values being non-zero value makes deployment a bit more expensive,
1398     // but in exchange the refund on every call to nonReentrant will be lower in
1399     // amount. Since refunds are capped to a percentage of the total
1400     // transaction's gas, it is best to keep them low in cases like this one, to
1401     // increase the likelihood of the full refund coming into effect.
1402     uint256 private constant _NOT_ENTERED = 1;
1403     uint256 private constant _ENTERED = 2;
1404 
1405     uint256 private _status;
1406 
1407     constructor() {
1408         _status = _NOT_ENTERED;
1409     }
1410 
1411     /**
1412      * @dev Prevents a contract from calling itself, directly or indirectly.
1413      * Calling a `nonReentrant` function from another `nonReentrant`
1414      * function is not supported. It is possible to prevent this from happening
1415      * by making the `nonReentrant` function external, and making it call a
1416      * `private` function that does the actual work.
1417      */
1418     modifier nonReentrant() {
1419         // On the first call to nonReentrant, _notEntered will be true
1420         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1421 
1422         // Any calls to nonReentrant after this point will fail
1423         _status = _ENTERED;
1424 
1425         _;
1426 
1427         // By storing the original value once again, a refund is triggered (see
1428         // https://eips.ethereum.org/EIPS/eip-2200)
1429         _status = _NOT_ENTERED;
1430     }
1431 }
1432 
1433 
1434 
1435 
1436 pragma solidity ^0.8.0;
1437 
1438 /**
1439  * @dev These functions deal with verification of Merkle Tree proofs.
1440  *
1441  * The proofs can be generated using the JavaScript library
1442  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1443  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1444  *
1445  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1446  *
1447  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1448  * hashing, or use a hash function other than keccak256 for hashing leaves.
1449  * This is because the concatenation of a sorted pair of internal nodes in
1450  * the merkle tree could be reinterpreted as a leaf value.
1451  */
1452 library MerkleProof {
1453     /**
1454      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1455      * defined by `root`. For this, a `proof` must be provided, containing
1456      * sibling hashes on the branch from the leaf to the root of the tree. Each
1457      * pair of leaves and each pair of pre-images are assumed to be sorted.
1458      */
1459     function verify(
1460         bytes32[] memory proof,
1461         bytes32 root,
1462         bytes32 leaf
1463     ) internal pure returns (bool) {
1464         return processProof(proof, leaf) == root;
1465     }
1466 
1467     /**
1468      * @dev Calldata version of {verify}
1469      *
1470      * _Available since v4.7._
1471      */
1472     function verifyCalldata(
1473         bytes32[] calldata proof,
1474         bytes32 root,
1475         bytes32 leaf
1476     ) internal pure returns (bool) {
1477         return processProofCalldata(proof, leaf) == root;
1478     }
1479 
1480     /**
1481      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1482      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1483      * hash matches the root of the tree. When processing the proof, the pairs
1484      * of leafs & pre-images are assumed to be sorted.
1485      *
1486      * _Available since v4.4._
1487      */
1488     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1489         bytes32 computedHash = leaf;
1490         for (uint256 i = 0; i < proof.length; i++) {
1491             computedHash = _hashPair(computedHash, proof[i]);
1492         }
1493         return computedHash;
1494     }
1495 
1496     /**
1497      * @dev Calldata version of {processProof}
1498      *
1499      * _Available since v4.7._
1500      */
1501     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1502         bytes32 computedHash = leaf;
1503         for (uint256 i = 0; i < proof.length; i++) {
1504             computedHash = _hashPair(computedHash, proof[i]);
1505         }
1506         return computedHash;
1507     }
1508 
1509     /**
1510      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1511      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1512      *
1513      * _Available since v4.7._
1514      */
1515     function multiProofVerify(
1516         bytes32[] memory proof,
1517         bool[] memory proofFlags,
1518         bytes32 root,
1519         bytes32[] memory leaves
1520     ) internal pure returns (bool) {
1521         return processMultiProof(proof, proofFlags, leaves) == root;
1522     }
1523 
1524     /**
1525      * @dev Calldata version of {multiProofVerify}
1526      *
1527      * _Available since v4.7._
1528      */
1529     function multiProofVerifyCalldata(
1530         bytes32[] calldata proof,
1531         bool[] calldata proofFlags,
1532         bytes32 root,
1533         bytes32[] memory leaves
1534     ) internal pure returns (bool) {
1535         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1536     }
1537 
1538     /**
1539      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1540      * consuming from one or the other at each step according to the instructions given by
1541      * `proofFlags`.
1542      *
1543      * _Available since v4.7._
1544      */
1545     function processMultiProof(
1546         bytes32[] memory proof,
1547         bool[] memory proofFlags,
1548         bytes32[] memory leaves
1549     ) internal pure returns (bytes32 merkleRoot) {
1550         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1551         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1552         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1553         // the merkle tree.
1554         uint256 leavesLen = leaves.length;
1555         uint256 totalHashes = proofFlags.length;
1556 
1557         // Check proof validity.
1558         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1559 
1560         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1561         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1562         bytes32[] memory hashes = new bytes32[](totalHashes);
1563         uint256 leafPos = 0;
1564         uint256 hashPos = 0;
1565         uint256 proofPos = 0;
1566         // At each step, we compute the next hash using two values:
1567         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1568         //   get the next hash.
1569         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1570         //   `proof` array.
1571         for (uint256 i = 0; i < totalHashes; i++) {
1572             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1573             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1574             hashes[i] = _hashPair(a, b);
1575         }
1576 
1577         if (totalHashes > 0) {
1578             return hashes[totalHashes - 1];
1579         } else if (leavesLen > 0) {
1580             return leaves[0];
1581         } else {
1582             return proof[0];
1583         }
1584     }
1585 
1586     /**
1587      * @dev Calldata version of {processMultiProof}
1588      *
1589      * _Available since v4.7._
1590      */
1591     function processMultiProofCalldata(
1592         bytes32[] calldata proof,
1593         bool[] calldata proofFlags,
1594         bytes32[] memory leaves
1595     ) internal pure returns (bytes32 merkleRoot) {
1596         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1597         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1598         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1599         // the merkle tree.
1600         uint256 leavesLen = leaves.length;
1601         uint256 totalHashes = proofFlags.length;
1602 
1603         // Check proof validity.
1604         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1605 
1606         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1607         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1608         bytes32[] memory hashes = new bytes32[](totalHashes);
1609         uint256 leafPos = 0;
1610         uint256 hashPos = 0;
1611         uint256 proofPos = 0;
1612         // At each step, we compute the next hash using two values:
1613         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1614         //   get the next hash.
1615         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1616         //   `proof` array.
1617         for (uint256 i = 0; i < totalHashes; i++) {
1618             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1619             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1620             hashes[i] = _hashPair(a, b);
1621         }
1622 
1623         if (totalHashes > 0) {
1624             return hashes[totalHashes - 1];
1625         } else if (leavesLen > 0) {
1626             return leaves[0];
1627         } else {
1628             return proof[0];
1629         }
1630     }
1631 
1632     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1633         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1634     }
1635 
1636     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1637         /// @solidity memory-safe-assembly
1638         assembly {
1639             mstore(0x00, a)
1640             mstore(0x20, b)
1641             value := keccak256(0x00, 0x40)
1642         }
1643     }
1644 }
1645 
1646 
1647 
1648 
1649 pragma solidity ^0.8.0;
1650 
1651 /**
1652  * @dev String operations.
1653  */
1654 library Strings {
1655     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1656     uint8 private constant _ADDRESS_LENGTH = 20;
1657 
1658     /**
1659      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1660      */
1661     function toString(uint256 value) internal pure returns (string memory) {
1662         // Inspired by OraclizeAPI's implementation - MIT licence
1663         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1664 
1665         if (value == 0) {
1666             return "0";
1667         }
1668         uint256 temp = value;
1669         uint256 digits;
1670         while (temp != 0) {
1671             digits++;
1672             temp /= 10;
1673         }
1674         bytes memory buffer = new bytes(digits);
1675         while (value != 0) {
1676             digits -= 1;
1677             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1678             value /= 10;
1679         }
1680         return string(buffer);
1681     }
1682 
1683     /**
1684      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1685      */
1686     function toHexString(uint256 value) internal pure returns (string memory) {
1687         if (value == 0) {
1688             return "0x00";
1689         }
1690         uint256 temp = value;
1691         uint256 length = 0;
1692         while (temp != 0) {
1693             length++;
1694             temp >>= 8;
1695         }
1696         return toHexString(value, length);
1697     }
1698 
1699     /**
1700      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1701      */
1702     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1703         bytes memory buffer = new bytes(2 * length + 2);
1704         buffer[0] = "0";
1705         buffer[1] = "x";
1706         for (uint256 i = 2 * length + 1; i > 1; --i) {
1707             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1708             value >>= 4;
1709         }
1710         require(value == 0, "Strings: hex length insufficient");
1711         return string(buffer);
1712     }
1713 
1714     /**
1715      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1716      */
1717     function toHexString(address addr) internal pure returns (string memory) {
1718         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1719     }
1720 }
1721 
1722 
1723 
1724 
1725 pragma solidity ^0.8.0;
1726 
1727 /**
1728  * @dev Provides information about the current execution context, including the
1729  * sender of the transaction and its data. While these are generally available
1730  * via msg.sender and msg.data, they should not be accessed in such a direct
1731  * manner, since when dealing with meta-transactions the account sending and
1732  * paying for execution may not be the actual sender (as far as an application
1733  * is concerned).
1734  *
1735  * This contract is only required for intermediate, library-like contracts.
1736  */
1737 abstract contract Context {
1738     function _msgSender() internal view virtual returns (address) {
1739         return msg.sender;
1740     }
1741 
1742     function _msgData() internal view virtual returns (bytes calldata) {
1743         return msg.data;
1744     }
1745 }
1746 
1747 
1748 
1749 
1750 pragma solidity ^0.8.0;
1751 
1752 /**
1753  * @dev Contract module which provides a basic access control mechanism, where
1754  * there is an account (an owner) that can be granted exclusive access to
1755  * specific functions.
1756  *
1757  * By default, the owner account will be the one that deploys the contract. This
1758  * can later be changed with {transferOwnership}.
1759  *
1760  * This module is used through inheritance. It will make available the modifier
1761  * `onlyOwner`, which can be applied to your functions to restrict their use to
1762  * the owner.
1763  */
1764 abstract contract Ownable is Context {
1765     address private _owner;
1766 
1767     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1768 
1769     /**
1770      * @dev Initializes the contract setting the deployer as the initial owner.
1771      */
1772     constructor() {
1773         _transferOwnership(_msgSender());
1774     }
1775 
1776     /**
1777      * @dev Throws if called by any account other than the owner.
1778      */
1779     modifier onlyOwner() {
1780         _checkOwner();
1781         _;
1782     }
1783 
1784     /**
1785      * @dev Returns the address of the current owner.
1786      */
1787     function owner() public view virtual returns (address) {
1788         return _owner;
1789     }
1790 
1791     /**
1792      * @dev Throws if the sender is not the owner.
1793      */
1794     function _checkOwner() internal view virtual {
1795         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1796     }
1797 
1798     /**
1799      * @dev Leaves the contract without owner. It will not be possible to call
1800      * `onlyOwner` functions anymore. Can only be called by the current owner.
1801      *
1802      * NOTE: Renouncing ownership will leave the contract without an owner,
1803      * thereby removing any functionality that is only available to the owner.
1804      */
1805     function renounceOwnership() public virtual onlyOwner {
1806         _transferOwnership(address(0));
1807     }
1808 
1809     /**
1810      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1811      * Can only be called by the current owner.
1812      */
1813     function transferOwnership(address newOwner) public virtual onlyOwner {
1814         require(newOwner != address(0), "Ownable: new owner is the zero address");
1815         _transferOwnership(newOwner);
1816     }
1817 
1818     /**
1819      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1820      * Internal function without access restriction.
1821      */
1822     function _transferOwnership(address newOwner) internal virtual {
1823         address oldOwner = _owner;
1824         _owner = newOwner;
1825         emit OwnershipTransferred(oldOwner, newOwner);
1826     }
1827 }
1828 
1829 
1830 
1831 pragma solidity ^0.8.13;
1832 
1833 
1834 
1835 
1836 
1837 contract IconicNFT721a is ERC721A, ReentrancyGuard, Ownable{
1838   string public baseURI;
1839   bool public mintingActive = false;
1840   bool public burningActive = false;
1841   bool public allowlistActive = false;
1842   uint256 public mintPrice;
1843   uint64 public mintSize;
1844   uint64 public maxMintsPerAddress = 3;
1845   bytes32 public allowlistMerkleRoot = '';
1846   address payable iconicAddress;
1847   address admin;
1848 
1849   constructor(string memory name_, string memory symbol_, string memory baseURI_,
1850         bytes32 merkleRoot_, address iconicAddress_, uint256 mintPrice_, uint64 mintSize_)
1851         ERC721A(name_, symbol_) {
1852         require(_msgSenderERC721A() != iconicAddress_, "Error");
1853         admin = _msgSenderERC721A();
1854         
1855         baseURI = baseURI_;
1856         allowlistMerkleRoot = merkleRoot_;
1857         iconicAddress = payable(iconicAddress_);
1858         mintPrice = mintPrice_;
1859         mintSize = mintSize_;
1860     }
1861 
1862   function setAllowListActive(bool active) public {
1863     require(_msgSenderERC721A() == admin, "Not Authorized");
1864     allowlistActive = active;
1865   }
1866 
1867   function setMintingActive(bool active) public {
1868     require(_msgSenderERC721A() == admin, "Not Authorized");
1869     mintingActive = active;
1870   }
1871 
1872   function setBurningActive(bool active) public {
1873     require(_msgSenderERC721A() == admin, "Not Authorized");
1874     burningActive = active;
1875   }
1876 
1877   function setBaseTokenURI(string memory baseURI_) public {
1878     require(_msgSenderERC721A() == admin, "Not Authorized");
1879 
1880     baseURI = baseURI_;
1881   }
1882 
1883  function setMintSize(uint64 mintSize_) public {
1884     require(_msgSenderERC721A() == admin, "Not Authorized");
1885 
1886     mintSize= mintSize_;
1887   }
1888 
1889    function setMintPrice(uint256 mintPrice_) public {
1890     require(_msgSenderERC721A() == admin, "Not Authorized");
1891 
1892     mintPrice = mintPrice_;
1893   }
1894 
1895   function setMaxMintsPerAddress(uint64 maxMintsPerAddress_) public {
1896     require(_msgSenderERC721A() == admin, "Not Authorized");
1897 
1898     maxMintsPerAddress = maxMintsPerAddress_;
1899   }
1900 
1901   function setAllowList(bytes32 merkleRoot) public {
1902     require(_msgSenderERC721A() == admin, "Not Authorized");
1903 
1904     allowlistMerkleRoot = merkleRoot; 
1905   }
1906 
1907   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1908     require(_exists(tokenId), "Token does not exist");
1909 
1910     return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
1911   }
1912 
1913   function _startTokenId() internal pure override returns (uint256) {
1914     return 1;
1915   }
1916 
1917   function allowlistMint(bytes32[] calldata merkleProof, uint16 amount) external payable nonReentrant() {
1918         // @notice using Checks-Effects-Interactions
1919         require(allowlistActive, "Allow list minting not enabled");
1920         require(msg.value == mintPrice * amount, "Incorrect amount of ether sent");
1921         require(_totalMinted() + amount <= mintSize, "Can not mint that many");
1922 
1923         uint64 mintCountBySender = _getAux(_msgSenderERC721A()) + amount;
1924         require(mintCountBySender <= maxMintsPerAddress, "Exceeds allowed mints");
1925 
1926         require(
1927             MerkleProof.verify(
1928                 merkleProof,
1929                 allowlistMerkleRoot,
1930                 keccak256(abi.encodePacked(_msgSenderERC721A()))
1931             ),
1932             "Address not in allowlist"
1933         );
1934 
1935         iconicAddress.transfer(msg.value);
1936         _mint(_msgSenderERC721A(), amount);
1937         _setAux(_msgSenderERC721A(), mintCountBySender);
1938     }
1939 
1940     function mint(uint16 amount) external payable nonReentrant() {
1941         // @notice using Checks-Effects-Interactions
1942         require(mintingActive, "Minting not enabled");
1943         require(msg.value == mintPrice * amount, "Incorrect amount of ether sent");
1944         require(_totalMinted() + amount <= mintSize, "Can not mint that many");
1945 
1946         uint64 mintCountBySender = _getAux(_msgSenderERC721A()) + amount;
1947         require(mintCountBySender <= maxMintsPerAddress, "Exceeds allowed mints");
1948         
1949         require(balanceOf(_msgSenderERC721A()) + amount <= maxMintsPerAddress, "Exceeds maximum allowed mints");
1950         
1951         iconicAddress.transfer(msg.value);
1952         _mint(_msgSenderERC721A(), amount);
1953         _setAux(_msgSenderERC721A(), mintCountBySender);
1954     }
1955 
1956     function burn(uint256 tokenId) public {
1957         require(burningActive, "Burning is not enabled");
1958         _burn(tokenId, true);
1959     }
1960 }