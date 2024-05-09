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
1419         _nonReentrantBefore();
1420         _;
1421         _nonReentrantAfter();
1422     }
1423 
1424     function _nonReentrantBefore() private {
1425         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1426         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1427 
1428         // Any calls to nonReentrant after this point will fail
1429         _status = _ENTERED;
1430     }
1431 
1432     function _nonReentrantAfter() private {
1433         // By storing the original value once again, a refund is triggered (see
1434         // https://eips.ethereum.org/EIPS/eip-2200)
1435         _status = _NOT_ENTERED;
1436     }
1437 }
1438 
1439 
1440 
1441 
1442 pragma solidity ^0.8.0;
1443 
1444 /**
1445  * @dev These functions deal with verification of Merkle Tree proofs.
1446  *
1447  * The tree and the proofs can be generated using our
1448  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1449  * You will find a quickstart guide in the readme.
1450  *
1451  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1452  * hashing, or use a hash function other than keccak256 for hashing leaves.
1453  * This is because the concatenation of a sorted pair of internal nodes in
1454  * the merkle tree could be reinterpreted as a leaf value.
1455  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1456  * against this attack out of the box.
1457  */
1458 library MerkleProof {
1459     /**
1460      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1461      * defined by `root`. For this, a `proof` must be provided, containing
1462      * sibling hashes on the branch from the leaf to the root of the tree. Each
1463      * pair of leaves and each pair of pre-images are assumed to be sorted.
1464      */
1465     function verify(
1466         bytes32[] memory proof,
1467         bytes32 root,
1468         bytes32 leaf
1469     ) internal pure returns (bool) {
1470         return processProof(proof, leaf) == root;
1471     }
1472 
1473     /**
1474      * @dev Calldata version of {verify}
1475      *
1476      * _Available since v4.7._
1477      */
1478     function verifyCalldata(
1479         bytes32[] calldata proof,
1480         bytes32 root,
1481         bytes32 leaf
1482     ) internal pure returns (bool) {
1483         return processProofCalldata(proof, leaf) == root;
1484     }
1485 
1486     /**
1487      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1488      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1489      * hash matches the root of the tree. When processing the proof, the pairs
1490      * of leafs & pre-images are assumed to be sorted.
1491      *
1492      * _Available since v4.4._
1493      */
1494     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1495         bytes32 computedHash = leaf;
1496         for (uint256 i = 0; i < proof.length; i++) {
1497             computedHash = _hashPair(computedHash, proof[i]);
1498         }
1499         return computedHash;
1500     }
1501 
1502     /**
1503      * @dev Calldata version of {processProof}
1504      *
1505      * _Available since v4.7._
1506      */
1507     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1508         bytes32 computedHash = leaf;
1509         for (uint256 i = 0; i < proof.length; i++) {
1510             computedHash = _hashPair(computedHash, proof[i]);
1511         }
1512         return computedHash;
1513     }
1514 
1515     /**
1516      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1517      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1518      *
1519      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1520      *
1521      * _Available since v4.7._
1522      */
1523     function multiProofVerify(
1524         bytes32[] memory proof,
1525         bool[] memory proofFlags,
1526         bytes32 root,
1527         bytes32[] memory leaves
1528     ) internal pure returns (bool) {
1529         return processMultiProof(proof, proofFlags, leaves) == root;
1530     }
1531 
1532     /**
1533      * @dev Calldata version of {multiProofVerify}
1534      *
1535      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1536      *
1537      * _Available since v4.7._
1538      */
1539     function multiProofVerifyCalldata(
1540         bytes32[] calldata proof,
1541         bool[] calldata proofFlags,
1542         bytes32 root,
1543         bytes32[] memory leaves
1544     ) internal pure returns (bool) {
1545         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1546     }
1547 
1548     /**
1549      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1550      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1551      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1552      * respectively.
1553      *
1554      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1555      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1556      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1557      *
1558      * _Available since v4.7._
1559      */
1560     function processMultiProof(
1561         bytes32[] memory proof,
1562         bool[] memory proofFlags,
1563         bytes32[] memory leaves
1564     ) internal pure returns (bytes32 merkleRoot) {
1565         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1566         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1567         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1568         // the merkle tree.
1569         uint256 leavesLen = leaves.length;
1570         uint256 totalHashes = proofFlags.length;
1571 
1572         // Check proof validity.
1573         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1574 
1575         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1576         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1577         bytes32[] memory hashes = new bytes32[](totalHashes);
1578         uint256 leafPos = 0;
1579         uint256 hashPos = 0;
1580         uint256 proofPos = 0;
1581         // At each step, we compute the next hash using two values:
1582         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1583         //   get the next hash.
1584         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1585         //   `proof` array.
1586         for (uint256 i = 0; i < totalHashes; i++) {
1587             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1588             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1589             hashes[i] = _hashPair(a, b);
1590         }
1591 
1592         if (totalHashes > 0) {
1593             return hashes[totalHashes - 1];
1594         } else if (leavesLen > 0) {
1595             return leaves[0];
1596         } else {
1597             return proof[0];
1598         }
1599     }
1600 
1601     /**
1602      * @dev Calldata version of {processMultiProof}.
1603      *
1604      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1605      *
1606      * _Available since v4.7._
1607      */
1608     function processMultiProofCalldata(
1609         bytes32[] calldata proof,
1610         bool[] calldata proofFlags,
1611         bytes32[] memory leaves
1612     ) internal pure returns (bytes32 merkleRoot) {
1613         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1614         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1615         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1616         // the merkle tree.
1617         uint256 leavesLen = leaves.length;
1618         uint256 totalHashes = proofFlags.length;
1619 
1620         // Check proof validity.
1621         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1622 
1623         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1624         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1625         bytes32[] memory hashes = new bytes32[](totalHashes);
1626         uint256 leafPos = 0;
1627         uint256 hashPos = 0;
1628         uint256 proofPos = 0;
1629         // At each step, we compute the next hash using two values:
1630         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1631         //   get the next hash.
1632         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1633         //   `proof` array.
1634         for (uint256 i = 0; i < totalHashes; i++) {
1635             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1636             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1637             hashes[i] = _hashPair(a, b);
1638         }
1639 
1640         if (totalHashes > 0) {
1641             return hashes[totalHashes - 1];
1642         } else if (leavesLen > 0) {
1643             return leaves[0];
1644         } else {
1645             return proof[0];
1646         }
1647     }
1648 
1649     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1650         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1651     }
1652 
1653     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1654         /// @solidity memory-safe-assembly
1655         assembly {
1656             mstore(0x00, a)
1657             mstore(0x20, b)
1658             value := keccak256(0x00, 0x40)
1659         }
1660     }
1661 }
1662 
1663 
1664 
1665 
1666 pragma solidity ^0.8.0;
1667 
1668 /**
1669  * @dev Provides information about the current execution context, including the
1670  * sender of the transaction and its data. While these are generally available
1671  * via msg.sender and msg.data, they should not be accessed in such a direct
1672  * manner, since when dealing with meta-transactions the account sending and
1673  * paying for execution may not be the actual sender (as far as an application
1674  * is concerned).
1675  *
1676  * This contract is only required for intermediate, library-like contracts.
1677  */
1678 abstract contract Context {
1679     function _msgSender() internal view virtual returns (address) {
1680         return msg.sender;
1681     }
1682 
1683     function _msgData() internal view virtual returns (bytes calldata) {
1684         return msg.data;
1685     }
1686 }
1687 
1688 
1689 
1690 
1691 pragma solidity ^0.8.0;
1692 
1693 /**
1694  * @dev Contract module which provides a basic access control mechanism, where
1695  * there is an account (an owner) that can be granted exclusive access to
1696  * specific functions.
1697  *
1698  * By default, the owner account will be the one that deploys the contract. This
1699  * can later be changed with {transferOwnership}.
1700  *
1701  * This module is used through inheritance. It will make available the modifier
1702  * `onlyOwner`, which can be applied to your functions to restrict their use to
1703  * the owner.
1704  */
1705 abstract contract Ownable is Context {
1706     address private _owner;
1707 
1708     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1709 
1710     /**
1711      * @dev Initializes the contract setting the deployer as the initial owner.
1712      */
1713     constructor() {
1714         _transferOwnership(_msgSender());
1715     }
1716 
1717     /**
1718      * @dev Throws if called by any account other than the owner.
1719      */
1720     modifier onlyOwner() {
1721         _checkOwner();
1722         _;
1723     }
1724 
1725     /**
1726      * @dev Returns the address of the current owner.
1727      */
1728     function owner() public view virtual returns (address) {
1729         return _owner;
1730     }
1731 
1732     /**
1733      * @dev Throws if the sender is not the owner.
1734      */
1735     function _checkOwner() internal view virtual {
1736         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1737     }
1738 
1739     /**
1740      * @dev Leaves the contract without owner. It will not be possible to call
1741      * `onlyOwner` functions anymore. Can only be called by the current owner.
1742      *
1743      * NOTE: Renouncing ownership will leave the contract without an owner,
1744      * thereby removing any functionality that is only available to the owner.
1745      */
1746     function renounceOwnership() public virtual onlyOwner {
1747         _transferOwnership(address(0));
1748     }
1749 
1750     /**
1751      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1752      * Can only be called by the current owner.
1753      */
1754     function transferOwnership(address newOwner) public virtual onlyOwner {
1755         require(newOwner != address(0), "Ownable: new owner is the zero address");
1756         _transferOwnership(newOwner);
1757     }
1758 
1759     /**
1760      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1761      * Internal function without access restriction.
1762      */
1763     function _transferOwnership(address newOwner) internal virtual {
1764         address oldOwner = _owner;
1765         _owner = newOwner;
1766         emit OwnershipTransferred(oldOwner, newOwner);
1767     }
1768 }
1769 
1770 
1771 
1772 
1773 pragma solidity ^0.8.0;
1774 
1775 /**
1776  * @dev Standard math utilities missing in the Solidity language.
1777  */
1778 library Math {
1779     enum Rounding {
1780         Down, // Toward negative infinity
1781         Up, // Toward infinity
1782         Zero // Toward zero
1783     }
1784 
1785     /**
1786      * @dev Returns the largest of two numbers.
1787      */
1788     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1789         return a > b ? a : b;
1790     }
1791 
1792     /**
1793      * @dev Returns the smallest of two numbers.
1794      */
1795     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1796         return a < b ? a : b;
1797     }
1798 
1799     /**
1800      * @dev Returns the average of two numbers. The result is rounded towards
1801      * zero.
1802      */
1803     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1804         // (a + b) / 2 can overflow.
1805         return (a & b) + (a ^ b) / 2;
1806     }
1807 
1808     /**
1809      * @dev Returns the ceiling of the division of two numbers.
1810      *
1811      * This differs from standard division with `/` in that it rounds up instead
1812      * of rounding down.
1813      */
1814     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1815         // (a + b - 1) / b can overflow on addition, so we distribute.
1816         return a == 0 ? 0 : (a - 1) / b + 1;
1817     }
1818 
1819     /**
1820      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1821      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1822      * with further edits by Uniswap Labs also under MIT license.
1823      */
1824     function mulDiv(
1825         uint256 x,
1826         uint256 y,
1827         uint256 denominator
1828     ) internal pure returns (uint256 result) {
1829         unchecked {
1830             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1831             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1832             // variables such that product = prod1 * 2^256 + prod0.
1833             uint256 prod0; // Least significant 256 bits of the product
1834             uint256 prod1; // Most significant 256 bits of the product
1835             assembly {
1836                 let mm := mulmod(x, y, not(0))
1837                 prod0 := mul(x, y)
1838                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1839             }
1840 
1841             // Handle non-overflow cases, 256 by 256 division.
1842             if (prod1 == 0) {
1843                 return prod0 / denominator;
1844             }
1845 
1846             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1847             require(denominator > prod1);
1848 
1849             ///////////////////////////////////////////////
1850             // 512 by 256 division.
1851             ///////////////////////////////////////////////
1852 
1853             // Make division exact by subtracting the remainder from [prod1 prod0].
1854             uint256 remainder;
1855             assembly {
1856                 // Compute remainder using mulmod.
1857                 remainder := mulmod(x, y, denominator)
1858 
1859                 // Subtract 256 bit number from 512 bit number.
1860                 prod1 := sub(prod1, gt(remainder, prod0))
1861                 prod0 := sub(prod0, remainder)
1862             }
1863 
1864             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1865             // See https://cs.stackexchange.com/q/138556/92363.
1866 
1867             // Does not overflow because the denominator cannot be zero at this stage in the function.
1868             uint256 twos = denominator & (~denominator + 1);
1869             assembly {
1870                 // Divide denominator by twos.
1871                 denominator := div(denominator, twos)
1872 
1873                 // Divide [prod1 prod0] by twos.
1874                 prod0 := div(prod0, twos)
1875 
1876                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1877                 twos := add(div(sub(0, twos), twos), 1)
1878             }
1879 
1880             // Shift in bits from prod1 into prod0.
1881             prod0 |= prod1 * twos;
1882 
1883             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1884             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1885             // four bits. That is, denominator * inv = 1 mod 2^4.
1886             uint256 inverse = (3 * denominator) ^ 2;
1887 
1888             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1889             // in modular arithmetic, doubling the correct bits in each step.
1890             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1891             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1892             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1893             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1894             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1895             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1896 
1897             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1898             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1899             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1900             // is no longer required.
1901             result = prod0 * inverse;
1902             return result;
1903         }
1904     }
1905 
1906     /**
1907      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1908      */
1909     function mulDiv(
1910         uint256 x,
1911         uint256 y,
1912         uint256 denominator,
1913         Rounding rounding
1914     ) internal pure returns (uint256) {
1915         uint256 result = mulDiv(x, y, denominator);
1916         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1917             result += 1;
1918         }
1919         return result;
1920     }
1921 
1922     /**
1923      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1924      *
1925      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1926      */
1927     function sqrt(uint256 a) internal pure returns (uint256) {
1928         if (a == 0) {
1929             return 0;
1930         }
1931 
1932         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1933         //
1934         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1935         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1936         //
1937         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1938         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1939         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1940         //
1941         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1942         uint256 result = 1 << (log2(a) >> 1);
1943 
1944         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1945         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1946         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1947         // into the expected uint128 result.
1948         unchecked {
1949             result = (result + a / result) >> 1;
1950             result = (result + a / result) >> 1;
1951             result = (result + a / result) >> 1;
1952             result = (result + a / result) >> 1;
1953             result = (result + a / result) >> 1;
1954             result = (result + a / result) >> 1;
1955             result = (result + a / result) >> 1;
1956             return min(result, a / result);
1957         }
1958     }
1959 
1960     /**
1961      * @notice Calculates sqrt(a), following the selected rounding direction.
1962      */
1963     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1964         unchecked {
1965             uint256 result = sqrt(a);
1966             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1967         }
1968     }
1969 
1970     /**
1971      * @dev Return the log in base 2, rounded down, of a positive value.
1972      * Returns 0 if given 0.
1973      */
1974     function log2(uint256 value) internal pure returns (uint256) {
1975         uint256 result = 0;
1976         unchecked {
1977             if (value >> 128 > 0) {
1978                 value >>= 128;
1979                 result += 128;
1980             }
1981             if (value >> 64 > 0) {
1982                 value >>= 64;
1983                 result += 64;
1984             }
1985             if (value >> 32 > 0) {
1986                 value >>= 32;
1987                 result += 32;
1988             }
1989             if (value >> 16 > 0) {
1990                 value >>= 16;
1991                 result += 16;
1992             }
1993             if (value >> 8 > 0) {
1994                 value >>= 8;
1995                 result += 8;
1996             }
1997             if (value >> 4 > 0) {
1998                 value >>= 4;
1999                 result += 4;
2000             }
2001             if (value >> 2 > 0) {
2002                 value >>= 2;
2003                 result += 2;
2004             }
2005             if (value >> 1 > 0) {
2006                 result += 1;
2007             }
2008         }
2009         return result;
2010     }
2011 
2012     /**
2013      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2014      * Returns 0 if given 0.
2015      */
2016     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2017         unchecked {
2018             uint256 result = log2(value);
2019             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2020         }
2021     }
2022 
2023     /**
2024      * @dev Return the log in base 10, rounded down, of a positive value.
2025      * Returns 0 if given 0.
2026      */
2027     function log10(uint256 value) internal pure returns (uint256) {
2028         uint256 result = 0;
2029         unchecked {
2030             if (value >= 10**64) {
2031                 value /= 10**64;
2032                 result += 64;
2033             }
2034             if (value >= 10**32) {
2035                 value /= 10**32;
2036                 result += 32;
2037             }
2038             if (value >= 10**16) {
2039                 value /= 10**16;
2040                 result += 16;
2041             }
2042             if (value >= 10**8) {
2043                 value /= 10**8;
2044                 result += 8;
2045             }
2046             if (value >= 10**4) {
2047                 value /= 10**4;
2048                 result += 4;
2049             }
2050             if (value >= 10**2) {
2051                 value /= 10**2;
2052                 result += 2;
2053             }
2054             if (value >= 10**1) {
2055                 result += 1;
2056             }
2057         }
2058         return result;
2059     }
2060 
2061     /**
2062      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2063      * Returns 0 if given 0.
2064      */
2065     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2066         unchecked {
2067             uint256 result = log10(value);
2068             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2069         }
2070     }
2071 
2072     /**
2073      * @dev Return the log in base 256, rounded down, of a positive value.
2074      * Returns 0 if given 0.
2075      *
2076      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2077      */
2078     function log256(uint256 value) internal pure returns (uint256) {
2079         uint256 result = 0;
2080         unchecked {
2081             if (value >> 128 > 0) {
2082                 value >>= 128;
2083                 result += 16;
2084             }
2085             if (value >> 64 > 0) {
2086                 value >>= 64;
2087                 result += 8;
2088             }
2089             if (value >> 32 > 0) {
2090                 value >>= 32;
2091                 result += 4;
2092             }
2093             if (value >> 16 > 0) {
2094                 value >>= 16;
2095                 result += 2;
2096             }
2097             if (value >> 8 > 0) {
2098                 result += 1;
2099             }
2100         }
2101         return result;
2102     }
2103 
2104     /**
2105      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2106      * Returns 0 if given 0.
2107      */
2108     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2109         unchecked {
2110             uint256 result = log256(value);
2111             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2112         }
2113     }
2114 }
2115 
2116 
2117 
2118 
2119 pragma solidity ^0.8.0;
2120 
2121 /**
2122  * @dev String operations.
2123  */
2124 library Strings {
2125     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2126     uint8 private constant _ADDRESS_LENGTH = 20;
2127 
2128     /**
2129      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2130      */
2131     function toString(uint256 value) internal pure returns (string memory) {
2132         unchecked {
2133             uint256 length = Math.log10(value) + 1;
2134             string memory buffer = new string(length);
2135             uint256 ptr;
2136             /// @solidity memory-safe-assembly
2137             assembly {
2138                 ptr := add(buffer, add(32, length))
2139             }
2140             while (true) {
2141                 ptr--;
2142                 /// @solidity memory-safe-assembly
2143                 assembly {
2144                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2145                 }
2146                 value /= 10;
2147                 if (value == 0) break;
2148             }
2149             return buffer;
2150         }
2151     }
2152 
2153     /**
2154      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2155      */
2156     function toHexString(uint256 value) internal pure returns (string memory) {
2157         unchecked {
2158             return toHexString(value, Math.log256(value) + 1);
2159         }
2160     }
2161 
2162     /**
2163      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2164      */
2165     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2166         bytes memory buffer = new bytes(2 * length + 2);
2167         buffer[0] = "0";
2168         buffer[1] = "x";
2169         for (uint256 i = 2 * length + 1; i > 1; --i) {
2170             buffer[i] = _SYMBOLS[value & 0xf];
2171             value >>= 4;
2172         }
2173         require(value == 0, "Strings: hex length insufficient");
2174         return string(buffer);
2175     }
2176 
2177     /**
2178      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2179      */
2180     function toHexString(address addr) internal pure returns (string memory) {
2181         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2182     }
2183 }
2184 
2185 
2186 
2187 pragma solidity ^0.8.13;
2188 
2189 interface IOperatorFilterRegistry {
2190     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2191     function register(address registrant) external;
2192     function registerAndSubscribe(address registrant, address subscription) external;
2193     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2194     function unregister(address addr) external;
2195     function updateOperator(address registrant, address operator, bool filtered) external;
2196     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2197     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2198     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2199     function subscribe(address registrant, address registrantToSubscribe) external;
2200     function unsubscribe(address registrant, bool copyExistingEntries) external;
2201     function subscriptionOf(address addr) external returns (address registrant);
2202     function subscribers(address registrant) external returns (address[] memory);
2203     function subscriberAt(address registrant, uint256 index) external returns (address);
2204     function copyEntriesOf(address registrant, address registrantToCopy) external;
2205     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2206     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2207     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2208     function filteredOperators(address addr) external returns (address[] memory);
2209     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2210     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2211     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2212     function isRegistered(address addr) external returns (bool);
2213     function codeHashOf(address addr) external returns (bytes32);
2214 }
2215 
2216 
2217 
2218 pragma solidity ^0.8.13;
2219 
2220 /**
2221  * @title  OperatorFilterer
2222  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2223  *         registrant's entries in the OperatorFilterRegistry.
2224  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2225  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2226  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2227  */
2228 abstract contract OperatorFilterer {
2229     error OperatorNotAllowed(address operator);
2230 
2231     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2232         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
2233 
2234     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2235         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2236         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2237         // order for the modifier to filter addresses.
2238         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2239             if (subscribe) {
2240                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2241             } else {
2242                 if (subscriptionOrRegistrantToCopy != address(0)) {
2243                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2244                 } else {
2245                     OPERATOR_FILTER_REGISTRY.register(address(this));
2246                 }
2247             }
2248         }
2249     }
2250 
2251     modifier onlyAllowedOperator(address from) virtual {
2252         // Allow spending tokens from addresses with balance
2253         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2254         // from an EOA.
2255         if (from != msg.sender) {
2256             _checkFilterOperator(msg.sender);
2257         }
2258         _;
2259     }
2260 
2261     modifier onlyAllowedOperatorApproval(address operator) virtual {
2262         _checkFilterOperator(operator);
2263         _;
2264     }
2265 
2266     function _checkFilterOperator(address operator) internal view virtual {
2267         // Check registry code length to facilitate testing in environments without a deployed registry.
2268         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2269             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2270                 revert OperatorNotAllowed(operator);
2271             }
2272         }
2273     }
2274 }
2275 
2276 
2277 
2278 pragma solidity ^0.8.13;
2279 
2280 /**
2281  * @title  DefaultOperatorFilterer
2282  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2283  */
2284 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2285     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2286 
2287     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
2288 }
2289 
2290 
2291 
2292 pragma solidity ^0.8.17;
2293 
2294 
2295 
2296 
2297 
2298 
2299 contract IconicNFT721a is ERC721A, ReentrancyGuard, Ownable, DefaultOperatorFilterer {
2300   uint16 public maxMintsPerAddress = 1;
2301   mapping(address => int16) public artPassMints;
2302 
2303   bool public artPassMintingActive = false;
2304   bool public allowListMintingActive = false;
2305   bool public mintingActive = false;
2306   bool public burningActive = false;
2307   bytes32 public allowListMerkleRoot = '';
2308   bytes32 public artPassMerkleRoot = '';
2309 
2310   string public baseURI;
2311   uint256 public mintPrice;
2312   uint64 public mintSize;
2313   address payable iconicAddress;
2314   address admin;
2315 
2316   constructor(string memory name_,
2317     string memory symbol_,
2318     string memory baseURI_,
2319     bytes32 artPassMerkleRoot_,
2320     bytes32 allowListMerkleRoot_,
2321     address iconicAddress_,
2322     uint256 mintPrice_,
2323     uint64 mintSize_)
2324     ERC721A(name_, symbol_) {
2325     require(_msgSenderERC721A() != iconicAddress_, "Error");
2326     admin = _msgSenderERC721A();
2327 
2328     baseURI = baseURI_;
2329     artPassMerkleRoot = artPassMerkleRoot_;
2330     allowListMerkleRoot = allowListMerkleRoot_;
2331     iconicAddress = payable(iconicAddress_);
2332     mintPrice = mintPrice_;
2333     mintSize = mintSize_;
2334   }
2335 
2336   function enableArtPassMinting() public requiresAdmin {
2337     artPassMintingActive = true;
2338   }
2339 
2340   function disableArtPassMinting() public requiresAdmin {
2341     artPassMintingActive = false;
2342   }
2343 
2344   function enableAllowListMinting() public requiresAdmin {
2345     allowListMintingActive = true;
2346   }
2347 
2348   function disableAllowListMinting() public requiresAdmin {
2349     allowListMintingActive = false;
2350   }
2351 
2352   function enableMinting() public requiresAdmin {
2353     mintingActive = true;
2354   }
2355 
2356   function disableMinting() public requiresAdmin {
2357     mintingActive = false;
2358   }
2359 
2360   function enableTokenBurning() public requiresAdmin {
2361     burningActive = true;
2362   }
2363 
2364   function disableTokenBurning() public requiresAdmin {
2365     burningActive = false;
2366   }
2367 
2368   function setBaseTokenURI(string memory baseURI_) public requiresAdmin {
2369     baseURI = baseURI_;
2370   }
2371 
2372  function setMintSize(uint64 mintSize_) public requiresAdmin {
2373     mintSize = mintSize_;
2374   }
2375 
2376   function setMintPrice(uint256 mintPrice_) public requiresAdmin {
2377     mintPrice = mintPrice_;
2378   }
2379 
2380   function setMaxMintsPerAddress(uint8 maxMintsPerAddress_) public requiresAdmin {
2381     maxMintsPerAddress = maxMintsPerAddress_;
2382   }
2383 
2384   function setArtPassMerkleRoot(bytes32 merkleRoot_) public requiresAdmin {
2385     artPassMerkleRoot = merkleRoot_;
2386   }
2387 
2388   function setAllowListMerkleRoot(bytes32 merkleRoot_) public requiresAdmin {
2389     allowListMerkleRoot = merkleRoot_;
2390   }
2391 
2392   function setAdditionalArtPassMints(address[] memory artPassHolders, int8[] memory extras) public requiresAdmin {
2393     //remember to zero out old addresses
2394     require(artPassHolders.length == extras.length, "incorrect list");
2395 
2396     for(uint16 i = 0; i < artPassHolders.length; i++) {
2397       artPassMints[artPassHolders[i]] = extras[i];
2398     }
2399   }
2400 
2401   function getAvailableArtPassMintCount(address artPassHolder) public view returns (uint16) {
2402     int16 availableMints = 1 + artPassMints[artPassHolder];
2403     return uint16(availableMints);
2404   }
2405 
2406   function artPassMint(bytes32[] calldata merkleProof, uint16 amount) external payable nonReentrant() {
2407     require(artPassMintingActive, "Art Pass minting not enabled");
2408     require(msg.value == mintPrice * amount, "Incorrect amount of ether sent");
2409     require(_totalMinted() + amount <= mintSize, "Mint exceeds collection size");
2410     require(getAvailableArtPassMintCount(_msgSenderERC721A())>= amount, "Exceeds Art Pass holder mint limit");
2411 
2412     require(
2413         MerkleProof.verify(
2414             merkleProof,
2415             artPassMerkleRoot,
2416             keccak256(abi.encodePacked(_msgSenderERC721A()))
2417         ),
2418         "Not an Art Pass holder"
2419     );
2420 
2421     iconicAddress.transfer(msg.value);
2422     _mint(_msgSenderERC721A(), amount);
2423     artPassMints[_msgSenderERC721A()] = artPassMints[_msgSenderERC721A()] - int16(amount);
2424   }
2425 
2426   function allowlistMint(bytes32[] calldata merkleProof, uint16 amount) external payable nonReentrant() {
2427     require(allowListMintingActive, "Allow list minting not enabled");
2428     require(msg.value == mintPrice * amount, "Incorrect amount of ether sent");
2429     require(_totalMinted() + amount <= mintSize, "Mint exceeds collection size");
2430 
2431     uint64 mintCountBySender = _getAux(_msgSenderERC721A()) + amount;
2432     require(mintCountBySender <= maxMintsPerAddress, "Exceeds per address mint limit");
2433 
2434     require(
2435         MerkleProof.verify(
2436             merkleProof,
2437             allowListMerkleRoot,
2438             keccak256(abi.encodePacked(_msgSenderERC721A()))
2439         ),
2440         "Address not in allowlist"
2441     );
2442 
2443     iconicAddress.transfer(msg.value);
2444     _mint(_msgSenderERC721A(), amount);
2445     _setAux(_msgSenderERC721A(), mintCountBySender);
2446   }
2447 
2448   function mint(uint16 amount) external payable nonReentrant() {
2449     require(mintingActive, "Minting not enabled");
2450     require(msg.value == mintPrice * amount, "Incorrect amount of ether sent");
2451     require(_totalMinted() + amount <= mintSize, "Mint exceeds collection size");
2452 
2453     uint64 mintCountBySender = _getAux(_msgSenderERC721A()) + amount;
2454     require(mintCountBySender <= maxMintsPerAddress, "Exceeds per address mint limit");
2455 
2456     iconicAddress.transfer(msg.value);
2457     _mint(_msgSenderERC721A(), amount);
2458     _setAux(_msgSenderERC721A(), mintCountBySender);
2459   }
2460 
2461   function burn(uint256 tokenId) public {
2462     require(burningActive, "Token burning is not enabled");
2463     _burn(tokenId, true);
2464   }
2465 
2466   function _startTokenId() internal pure override returns (uint256) {
2467     return 1;
2468   }
2469 
2470   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2471     require(_exists(tokenId), "Token does not exist");
2472     return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
2473   }
2474 
2475   modifier requiresAdmin() {
2476     require(_msgSenderERC721A() == admin, "Not Authorized");
2477    _;
2478   }
2479 
2480   /* Operator Filter Registry Overrides */
2481   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2482     super.setApprovalForAll(operator, approved);
2483   }
2484 
2485   function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2486     super.approve(operator, tokenId);
2487   }
2488 
2489   function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2490     super.transferFrom(from, to, tokenId);
2491   }
2492 
2493   function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2494     super.safeTransferFrom(from, to, tokenId);
2495   }
2496 
2497   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2498     public
2499     payable
2500     override
2501     onlyAllowedOperator(from)
2502   {
2503     super.safeTransferFrom(from, to, tokenId, data);
2504   }
2505 }