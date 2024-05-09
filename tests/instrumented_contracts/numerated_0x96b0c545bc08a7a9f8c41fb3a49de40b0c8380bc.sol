1 // SPDX-License-Identifier: MIXED
2 
3 // Sources flattened with hardhat v2.10.1 https://hardhat.org
4 
5 // File contracts/IERC721A.sol
6 
7 // License-Identifier: MIT
8 // ERC721A Contracts v4.2.2
9 // Creator: Chiru Labs
10 
11 pragma solidity ^0.8.4;
12 
13 /**
14  * @dev Interface of ERC721A.
15  */
16 interface IERC721A {
17     /**
18      * The caller must own the token or be an approved operator.
19      */
20     error ApprovalCallerNotOwnerNorApproved();
21 
22     /**
23      * The token does not exist.
24      */
25     error ApprovalQueryForNonexistentToken();
26 
27     /**
28      * The caller cannot approve to their own address.
29      */
30     error ApproveToCaller();
31 
32     /**
33      * Cannot query the balance for the zero address.
34      */
35     error BalanceQueryForZeroAddress();
36 
37     /**
38      * Cannot mint to the zero address.
39      */
40     error MintToZeroAddress();
41 
42     /**
43      * The quantity of tokens minted must be more than zero.
44      */
45     error MintZeroQuantity();
46 
47     /**
48      * The token does not exist.
49      */
50     error OwnerQueryForNonexistentToken();
51 
52     /**
53      * The caller must own the token or be an approved operator.
54      */
55     error TransferCallerNotOwnerNorApproved();
56 
57     /**
58      * The token must be owned by `from`.
59      */
60     error TransferFromIncorrectOwner();
61 
62     /**
63      * Cannot safely transfer to a contract that does not implement the
64      * ERC721Receiver interface.
65      */
66     error TransferToNonERC721ReceiverImplementer();
67 
68     /**
69      * Cannot transfer to the zero address.
70      */
71     error TransferToZeroAddress();
72 
73     /**
74      * The token does not exist.
75      */
76     error URIQueryForNonexistentToken();
77 
78     /**
79      * The `quantity` minted with ERC2309 exceeds the safety limit.
80      */
81     error MintERC2309QuantityExceedsLimit();
82 
83     /**
84      * The `extraData` cannot be set on an unintialized ownership slot.
85      */
86     error OwnershipNotInitializedForExtraData();
87 
88     // =============================================================
89     //                            STRUCTS
90     // =============================================================
91 
92     struct TokenOwnership {
93         // The address of the owner.
94         address addr;
95         // Stores the start time of ownership with minimal overhead for tokenomics.
96         uint64 startTimestamp;
97         // Whether the token has been burned.
98         bool burned;
99         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
100         uint24 extraData;
101     }
102 
103     // =============================================================
104     //                         TOKEN COUNTERS
105     // =============================================================
106 
107     /**
108      * @dev Returns the total number of tokens in existence.
109      * Burned tokens will reduce the count.
110      * To get the total number of tokens minted, please see {_totalMinted}.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     // =============================================================
115     //                            IERC165
116     // =============================================================
117 
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 
128     // =============================================================
129     //                            IERC721
130     // =============================================================
131 
132     /**
133      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
139      */
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables or disables
144      * (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in `owner`'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`,
164      * checking first that contract recipients are aware of the ERC721 protocol
165      * to prevent tokens from being forever locked.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be have been allowed to move
173      * this token by either {approve} or {setApprovalForAll}.
174      * - If `to` refers to a smart contract, it must implement
175      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external;
185 
186     /**
187      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId
193     ) external;
194 
195     /**
196      * @dev Transfers `tokenId` from `from` to `to`.
197      *
198      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
199      * whenever possible.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must be owned by `from`.
206      * - If the caller is not `from`, it must be approved to move this token
207      * by either {approve} or {setApprovalForAll}.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(
212         address from,
213         address to,
214         uint256 tokenId
215     ) external;
216 
217     /**
218      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
219      * The approval is cleared when the token is transferred.
220      *
221      * Only a single account can be approved at a time, so approving the
222      * zero address clears previous approvals.
223      *
224      * Requirements:
225      *
226      * - The caller must own the token or be an approved operator.
227      * - `tokenId` must exist.
228      *
229      * Emits an {Approval} event.
230      */
231     function approve(address to, uint256 tokenId) external;
232 
233     /**
234      * @dev Approve or remove `operator` as an operator for the caller.
235      * Operators can call {transferFrom} or {safeTransferFrom}
236      * for any token owned by the caller.
237      *
238      * Requirements:
239      *
240      * - The `operator` cannot be the caller.
241      *
242      * Emits an {ApprovalForAll} event.
243      */
244     function setApprovalForAll(address operator, bool _approved) external;
245 
246     /**
247      * @dev Returns the account approved for `tokenId` token.
248      *
249      * Requirements:
250      *
251      * - `tokenId` must exist.
252      */
253     function getApproved(uint256 tokenId) external view returns (address operator);
254 
255     /**
256      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
257      *
258      * See {setApprovalForAll}.
259      */
260     function isApprovedForAll(address owner, address operator) external view returns (bool);
261 
262     // =============================================================
263     //                        IERC721Metadata
264     // =============================================================
265 
266     /**
267      * @dev Returns the token collection name.
268      */
269     function name() external view returns (string memory);
270 
271     /**
272      * @dev Returns the token collection symbol.
273      */
274     function symbol() external view returns (string memory);
275 
276     /**
277      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
278      */
279     function tokenURI(uint256 tokenId) external view returns (string memory);
280 
281     // =============================================================
282     //                           IERC2309
283     // =============================================================
284 
285     /**
286      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
287      * (inclusive) is transferred from `from` to `to`, as defined in the
288      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
289      *
290      * See {_mintERC2309} for more details.
291      */
292     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
293 }
294 
295 
296 // File contracts/ERC721A.sol
297 
298 // License-Identifier: MIT
299 // ERC721A Contracts v4.2.2
300 // Creator: Chiru Labs
301 
302 pragma solidity ^0.8.4;
303 /**
304  * @dev Interface of ERC721 token receiver.
305  */
306 interface ERC721A__IERC721Receiver {
307     function onERC721Received(
308         address operator,
309         address from,
310         uint256 tokenId,
311         bytes calldata data
312     ) external returns (bytes4);
313 }
314 
315 /**
316  * @title ERC721A
317  *
318  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
319  * Non-Fungible Token Standard, including the Metadata extension.
320  * Optimized for lower gas during batch mints.
321  *
322  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
323  * starting from `_startTokenId()`.
324  *
325  * Assumptions:
326  *
327  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
328  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
329  */
330 contract ERC721A is IERC721A {
331     // Reference type for token approval.
332     struct TokenApprovalRef {
333         address value;
334     }
335 
336     // =============================================================
337     //                           CONSTANTS
338     // =============================================================
339 
340     // Mask of an entry in packed address data.
341     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
342 
343     // The bit position of `numberMinted` in packed address data.
344     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
345 
346     // The bit position of `numberBurned` in packed address data.
347     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
348 
349     // The bit position of `aux` in packed address data.
350     uint256 private constant _BITPOS_AUX = 192;
351 
352     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
353     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
354 
355     // The bit position of `startTimestamp` in packed ownership.
356     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
357 
358     // The bit mask of the `burned` bit in packed ownership.
359     uint256 private constant _BITMASK_BURNED = 1 << 224;
360 
361     // The bit position of the `nextInitialized` bit in packed ownership.
362     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
363 
364     // The bit mask of the `nextInitialized` bit in packed ownership.
365     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
366 
367     // The bit position of `extraData` in packed ownership.
368     uint256 private constant _BITPOS_EXTRA_DATA = 232;
369 
370     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
371     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
372 
373     // The mask of the lower 160 bits for addresses.
374     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
375 
376     // The maximum `quantity` that can be minted with {_mintERC2309}.
377     // This limit is to prevent overflows on the address data entries.
378     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
379     // is required to cause an overflow, which is unrealistic.
380     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
381 
382     // The `Transfer` event signature is given by:
383     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
384     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
385         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
386 
387     // =============================================================
388     //                            STORAGE
389     // =============================================================
390 
391     // The next token ID to be minted.
392     uint256 private _currentIndex;
393 
394     // The number of tokens burned.
395     uint256 private _burnCounter;
396 
397     // Token name
398     string private _name;
399 
400     // Token symbol
401     string private _symbol;
402 
403     // Mapping from token ID to ownership details
404     // An empty struct value does not necessarily mean the token is unowned.
405     // See {_packedOwnershipOf} implementation for details.
406     //
407     // Bits Layout:
408     // - [0..159]   `addr`
409     // - [160..223] `startTimestamp`
410     // - [224]      `burned`
411     // - [225]      `nextInitialized`
412     // - [232..255] `extraData`
413     mapping(uint256 => uint256) private _packedOwnerships;
414 
415     // Mapping owner address to address data.
416     //
417     // Bits Layout:
418     // - [0..63]    `balance`
419     // - [64..127]  `numberMinted`
420     // - [128..191] `numberBurned`
421     // - [192..255] `aux`
422     mapping(address => uint256) private _packedAddressData;
423 
424     // Mapping from token ID to approved address.
425     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
426 
427     // Mapping from owner to operator approvals
428     mapping(address => mapping(address => bool)) private _operatorApprovals;
429 
430     // =============================================================
431     //                          CONSTRUCTOR
432     // =============================================================
433 
434     constructor(string memory name_, string memory symbol_) {
435         _name = name_;
436         _symbol = symbol_;
437         _currentIndex = _startTokenId();
438     }
439 
440     // =============================================================
441     //                   TOKEN COUNTING OPERATIONS
442     // =============================================================
443 
444     /**
445      * @dev Returns the starting token ID.
446      * To change the starting token ID, please override this function.
447      */
448     function _startTokenId() internal view virtual returns (uint256) {
449         return 0;
450     }
451 
452     /**
453      * @dev Returns the next token ID to be minted.
454      */
455     function _nextTokenId() internal view virtual returns (uint256) {
456         return _currentIndex;
457     }
458 
459     /**
460      * @dev Returns the total number of tokens in existence.
461      * Burned tokens will reduce the count.
462      * To get the total number of tokens minted, please see {_totalMinted}.
463      */
464     function totalSupply() public view virtual override returns (uint256) {
465         // Counter underflow is impossible as _burnCounter cannot be incremented
466         // more than `_currentIndex - _startTokenId()` times.
467         unchecked {
468             return _currentIndex - _burnCounter - _startTokenId();
469         }
470     }
471 
472     /**
473      * @dev Returns the total amount of tokens minted in the contract.
474      */
475     function _totalMinted() internal view virtual returns (uint256) {
476         // Counter underflow is impossible as `_currentIndex` does not decrement,
477         // and it is initialized to `_startTokenId()`.
478         unchecked {
479             return _currentIndex - _startTokenId();
480         }
481     }
482 
483     /**
484      * @dev Returns the total number of tokens burned.
485      */
486     function _totalBurned() internal view virtual returns (uint256) {
487         return _burnCounter;
488     }
489 
490     // =============================================================
491     //                    ADDRESS DATA OPERATIONS
492     // =============================================================
493 
494     /**
495      * @dev Returns the number of tokens in `owner`'s account.
496      */
497     function balanceOf(address owner) public view virtual override returns (uint256) {
498         if (owner == address(0)) revert BalanceQueryForZeroAddress();
499         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
500     }
501 
502     /**
503      * Returns the number of tokens minted by `owner`.
504      */
505     function _numberMinted(address owner) internal view returns (uint256) {
506         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
507     }
508 
509     /**
510      * Returns the number of tokens burned by or on behalf of `owner`.
511      */
512     function _numberBurned(address owner) internal view returns (uint256) {
513         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
514     }
515 
516     /**
517      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
518      */
519     function _getAux(address owner) internal view returns (uint64) {
520         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
521     }
522 
523     /**
524      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
525      * If there are multiple variables, please pack them into a uint64.
526      */
527     function _setAux(address owner, uint64 aux) internal virtual {
528         uint256 packed = _packedAddressData[owner];
529         uint256 auxCasted;
530         // Cast `aux` with assembly to avoid redundant masking.
531         assembly {
532             auxCasted := aux
533         }
534         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
535         _packedAddressData[owner] = packed;
536     }
537 
538     // =============================================================
539     //                            IERC165
540     // =============================================================
541 
542     /**
543      * @dev Returns true if this contract implements the interface defined by
544      * `interfaceId`. See the corresponding
545      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
546      * to learn more about how these ids are created.
547      *
548      * This function call must use less than 30000 gas.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551         // The interface IDs are constants representing the first 4 bytes
552         // of the XOR of all function selectors in the interface.
553         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
554         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
555         return
556             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
557             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
558             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
559     }
560 
561     // =============================================================
562     //                        IERC721Metadata
563     // =============================================================
564 
565     /**
566      * @dev Returns the token collection name.
567      */
568     function name() public view virtual override returns (string memory) {
569         return _name;
570     }
571 
572     /**
573      * @dev Returns the token collection symbol.
574      */
575     function symbol() public view virtual override returns (string memory) {
576         return _symbol;
577     }
578 
579     /**
580      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
581      */
582     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
583         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
584 
585         string memory baseURI = _baseURI();
586         baseURI = string(abi.encodePacked(baseURI, _toString(tokenId)));
587         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, ".json")) : '';
588     }
589 
590     /**
591      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
592      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
593      * by default, it can be overridden in child contracts.
594      */
595     function _baseURI() internal view virtual returns (string memory) {
596         return '';
597     }
598 
599     // =============================================================
600     //                     OWNERSHIPS OPERATIONS
601     // =============================================================
602 
603     /**
604      * @dev Returns the owner of the `tokenId` token.
605      *
606      * Requirements:
607      *
608      * - `tokenId` must exist.
609      */
610     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
611         return address(uint160(_packedOwnershipOf(tokenId)));
612     }
613 
614     /**
615      * @dev Gas spent here starts off proportional to the maximum mint batch size.
616      * It gradually moves to O(1) as tokens get transferred around over time.
617      */
618     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
619         return _unpackedOwnership(_packedOwnershipOf(tokenId));
620     }
621 
622     /**
623      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
624      */
625     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
626         return _unpackedOwnership(_packedOwnerships[index]);
627     }
628 
629     /**
630      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
631      */
632     function _initializeOwnershipAt(uint256 index) internal virtual {
633         if (_packedOwnerships[index] == 0) {
634             _packedOwnerships[index] = _packedOwnershipOf(index);
635         }
636     }
637 
638     /**
639      * Returns the packed ownership data of `tokenId`.
640      */
641     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
642         uint256 curr = tokenId;
643 
644         unchecked {
645             if (_startTokenId() <= curr)
646                 if (curr < _currentIndex) {
647                     uint256 packed = _packedOwnerships[curr];
648                     // If not burned.
649                     if (packed & _BITMASK_BURNED == 0) {
650                         // Invariant:
651                         // There will always be an initialized ownership slot
652                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
653                         // before an unintialized ownership slot
654                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
655                         // Hence, `curr` will not underflow.
656                         //
657                         // We can directly compare the packed value.
658                         // If the address is zero, packed will be zero.
659                         while (packed == 0) {
660                             packed = _packedOwnerships[--curr];
661                         }
662                         return packed;
663                     }
664                 }
665         }
666         revert OwnerQueryForNonexistentToken();
667     }
668 
669     /**
670      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
671      */
672     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
673         ownership.addr = address(uint160(packed));
674         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
675         ownership.burned = packed & _BITMASK_BURNED != 0;
676         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
677     }
678 
679     /**
680      * @dev Packs ownership data into a single uint256.
681      */
682     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
683         assembly {
684             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
685             owner := and(owner, _BITMASK_ADDRESS)
686             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
687             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
688         }
689     }
690 
691     /**
692      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
693      */
694     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
695         // For branchless setting of the `nextInitialized` flag.
696         assembly {
697             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
698             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
699         }
700     }
701 
702     // =============================================================
703     //                      APPROVAL OPERATIONS
704     // =============================================================
705 
706     /**
707      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
708      * The approval is cleared when the token is transferred.
709      *
710      * Only a single account can be approved at a time, so approving the
711      * zero address clears previous approvals.
712      *
713      * Requirements:
714      *
715      * - The caller must own the token or be an approved operator.
716      * - `tokenId` must exist.
717      *
718      * Emits an {Approval} event.
719      */
720     function approve(address to, uint256 tokenId) public virtual override {
721         address owner = ownerOf(tokenId);
722 
723         if (_msgSenderERC721A() != owner)
724             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
725                 revert ApprovalCallerNotOwnerNorApproved();
726             }
727 
728         _tokenApprovals[tokenId].value = to;
729         emit Approval(owner, to, tokenId);
730     }
731 
732     /**
733      * @dev Returns the account approved for `tokenId` token.
734      *
735      * Requirements:
736      *
737      * - `tokenId` must exist.
738      */
739     function getApproved(uint256 tokenId) public view virtual override returns (address) {
740         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
741 
742         return _tokenApprovals[tokenId].value;
743     }
744 
745     /**
746      * @dev Approve or remove `operator` as an operator for the caller.
747      * Operators can call {transferFrom} or {safeTransferFrom}
748      * for any token owned by the caller.
749      *
750      * Requirements:
751      *
752      * - The `operator` cannot be the caller.
753      *
754      * Emits an {ApprovalForAll} event.
755      */
756     function setApprovalForAll(address operator, bool approved) public virtual override {
757         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
758 
759         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
760         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
761     }
762 
763     /**
764      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
765      *
766      * See {setApprovalForAll}.
767      */
768     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
769         return _operatorApprovals[owner][operator];
770     }
771 
772     /**
773      * @dev Returns whether `tokenId` exists.
774      *
775      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
776      *
777      * Tokens start existing when they are minted. See {_mint}.
778      */
779     function _exists(uint256 tokenId) internal view virtual returns (bool) {
780         return
781             _startTokenId() <= tokenId &&
782             tokenId < _currentIndex && // If within bounds,
783             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
784     }
785 
786     /**
787      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
788      */
789     function _isSenderApprovedOrOwner(
790         address approvedAddress,
791         address owner,
792         address msgSender
793     ) private pure returns (bool result) {
794         assembly {
795             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
796             owner := and(owner, _BITMASK_ADDRESS)
797             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
798             msgSender := and(msgSender, _BITMASK_ADDRESS)
799             // `msgSender == owner || msgSender == approvedAddress`.
800             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
801         }
802     }
803 
804     /**
805      * @dev Returns the storage slot and value for the approved address of `tokenId`.
806      */
807     function _getApprovedSlotAndAddress(uint256 tokenId)
808         private
809         view
810         returns (uint256 approvedAddressSlot, address approvedAddress)
811     {
812         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
813         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
814         assembly {
815             approvedAddressSlot := tokenApproval.slot
816             approvedAddress := sload(approvedAddressSlot)
817         }
818     }
819 
820     // =============================================================
821     //                      TRANSFER OPERATIONS
822     // =============================================================
823 
824     /**
825      * @dev Transfers `tokenId` from `from` to `to`.
826      *
827      * Requirements:
828      *
829      * - `from` cannot be the zero address.
830      * - `to` cannot be the zero address.
831      * - `tokenId` token must be owned by `from`.
832      * - If the caller is not `from`, it must be approved to move this token
833      * by either {approve} or {setApprovalForAll}.
834      *
835      * Emits a {Transfer} event.
836      */
837     function transferFrom(
838         address from,
839         address to,
840         uint256 tokenId
841     ) public virtual override {
842         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
843 
844         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
845 
846         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
847 
848         // The nested ifs save around 20+ gas over a compound boolean condition.
849         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
850             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
851 
852         if (to == address(0)) revert TransferToZeroAddress();
853 
854         _beforeTokenTransfers(from, to, tokenId, 1);
855 
856         // Clear approvals from the previous owner.
857         assembly {
858             if approvedAddress {
859                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
860                 sstore(approvedAddressSlot, 0)
861             }
862         }
863 
864         // Underflow of the sender's balance is impossible because we check for
865         // ownership above and the recipient's balance can't realistically overflow.
866         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
867         unchecked {
868             // We can directly increment and decrement the balances.
869             --_packedAddressData[from]; // Updates: `balance -= 1`.
870             ++_packedAddressData[to]; // Updates: `balance += 1`.
871 
872             // Updates:
873             // - `address` to the next owner.
874             // - `startTimestamp` to the timestamp of transfering.
875             // - `burned` to `false`.
876             // - `nextInitialized` to `true`.
877             _packedOwnerships[tokenId] = _packOwnershipData(
878                 to,
879                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
880             );
881 
882             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
883             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
884                 uint256 nextTokenId = tokenId + 1;
885                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
886                 if (_packedOwnerships[nextTokenId] == 0) {
887                     // If the next slot is within bounds.
888                     if (nextTokenId != _currentIndex) {
889                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
890                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
891                     }
892                 }
893             }
894         }
895 
896         emit Transfer(from, to, tokenId);
897         _afterTokenTransfers(from, to, tokenId, 1);
898     }
899 
900     /**
901      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId
907     ) public virtual override {
908         safeTransferFrom(from, to, tokenId, '');
909     }
910 
911     /**
912      * @dev Safely transfers `tokenId` token from `from` to `to`.
913      *
914      * Requirements:
915      *
916      * - `from` cannot be the zero address.
917      * - `to` cannot be the zero address.
918      * - `tokenId` token must exist and be owned by `from`.
919      * - If the caller is not `from`, it must be approved to move this token
920      * by either {approve} or {setApprovalForAll}.
921      * - If `to` refers to a smart contract, it must implement
922      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
923      *
924      * Emits a {Transfer} event.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) public virtual override {
932         transferFrom(from, to, tokenId);
933         if (to.code.length != 0)
934             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
935                 revert TransferToNonERC721ReceiverImplementer();
936             }
937     }
938 
939     /**
940      * @dev Hook that is called before a set of serially-ordered token IDs
941      * are about to be transferred. This includes minting.
942      * And also called before burning one token.
943      *
944      * `startTokenId` - the first token ID to be transferred.
945      * `quantity` - the amount to be transferred.
946      *
947      * Calling conditions:
948      *
949      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
950      * transferred to `to`.
951      * - When `from` is zero, `tokenId` will be minted for `to`.
952      * - When `to` is zero, `tokenId` will be burned by `from`.
953      * - `from` and `to` are never both zero.
954      */
955     function _beforeTokenTransfers(
956         address from,
957         address to,
958         uint256 startTokenId,
959         uint256 quantity
960     ) internal virtual {}
961 
962     /**
963      * @dev Hook that is called after a set of serially-ordered token IDs
964      * have been transferred. This includes minting.
965      * And also called after one token has been burned.
966      *
967      * `startTokenId` - the first token ID to be transferred.
968      * `quantity` - the amount to be transferred.
969      *
970      * Calling conditions:
971      *
972      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
973      * transferred to `to`.
974      * - When `from` is zero, `tokenId` has been minted for `to`.
975      * - When `to` is zero, `tokenId` has been burned by `from`.
976      * - `from` and `to` are never both zero.
977      */
978     function _afterTokenTransfers(
979         address from,
980         address to,
981         uint256 startTokenId,
982         uint256 quantity
983     ) internal virtual {}
984 
985     /**
986      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
987      *
988      * `from` - Previous owner of the given token ID.
989      * `to` - Target address that will receive the token.
990      * `tokenId` - Token ID to be transferred.
991      * `_data` - Optional data to send along with the call.
992      *
993      * Returns whether the call correctly returned the expected magic value.
994      */
995     function _checkContractOnERC721Received(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) private returns (bool) {
1001         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1002             bytes4 retval
1003         ) {
1004             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1005         } catch (bytes memory reason) {
1006             if (reason.length == 0) {
1007                 revert TransferToNonERC721ReceiverImplementer();
1008             } else {
1009                 assembly {
1010                     revert(add(32, reason), mload(reason))
1011                 }
1012             }
1013         }
1014     }
1015 
1016     // =============================================================
1017     //                        MINT OPERATIONS
1018     // =============================================================
1019 
1020     /**
1021      * @dev Mints `quantity` tokens and transfers them to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `quantity` must be greater than 0.
1027      *
1028      * Emits a {Transfer} event for each mint.
1029      */
1030     function _mint(address to, uint256 quantity) internal virtual {
1031         uint256 startTokenId = _currentIndex;
1032         if (quantity == 0) revert MintZeroQuantity();
1033 
1034         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1035 
1036         // Overflows are incredibly unrealistic.
1037         // `balance` and `numberMinted` have a maximum limit of 2**64.
1038         // `tokenId` has a maximum limit of 2**256.
1039         unchecked {
1040             // Updates:
1041             // - `balance += quantity`.
1042             // - `numberMinted += quantity`.
1043             //
1044             // We can directly add to the `balance` and `numberMinted`.
1045             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1046 
1047             // Updates:
1048             // - `address` to the owner.
1049             // - `startTimestamp` to the timestamp of minting.
1050             // - `burned` to `false`.
1051             // - `nextInitialized` to `quantity == 1`.
1052             _packedOwnerships[startTokenId] = _packOwnershipData(
1053                 to,
1054                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1055             );
1056 
1057             uint256 toMasked;
1058             uint256 end = startTokenId + quantity;
1059 
1060             // Use assembly to loop and emit the `Transfer` event for gas savings.
1061             // The duplicated `log4` removes an extra check and reduces stack juggling.
1062             // The assembly, together with the surrounding Solidity code, have been
1063             // delicately arranged to nudge the compiler into producing optimized opcodes.
1064             assembly {
1065                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1066                 toMasked := and(to, _BITMASK_ADDRESS)
1067                 // Emit the `Transfer` event.
1068                 log4(
1069                     0, // Start of data (0, since no data).
1070                     0, // End of data (0, since no data).
1071                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1072                     0, // `address(0)`.
1073                     toMasked, // `to`.
1074                     startTokenId // `tokenId`.
1075                 )
1076 
1077                 for {
1078                     let tokenId := add(startTokenId, 1)
1079                 } iszero(eq(tokenId, end)) {
1080                     tokenId := add(tokenId, 1)
1081                 } {
1082                     // Emit the `Transfer` event. Similar to above.
1083                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1084                 }
1085             }
1086             if (toMasked == 0) revert MintToZeroAddress();
1087 
1088             _currentIndex = end;
1089         }
1090         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1091     }
1092 
1093     /**
1094      * @dev Mints `quantity` tokens and transfers them to `to`.
1095      *
1096      * This function is intended for efficient minting only during contract creation.
1097      *
1098      * It emits only one {ConsecutiveTransfer} as defined in
1099      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1100      * instead of a sequence of {Transfer} event(s).
1101      *
1102      * Calling this function outside of contract creation WILL make your contract
1103      * non-compliant with the ERC721 standard.
1104      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1105      * {ConsecutiveTransfer} event is only permissible during contract creation.
1106      *
1107      * Requirements:
1108      *
1109      * - `to` cannot be the zero address.
1110      * - `quantity` must be greater than 0.
1111      *
1112      * Emits a {ConsecutiveTransfer} event.
1113      */
1114     function _mintERC2309(address to, uint256 quantity) internal virtual {
1115         uint256 startTokenId = _currentIndex;
1116         if (to == address(0)) revert MintToZeroAddress();
1117         if (quantity == 0) revert MintZeroQuantity();
1118         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1119 
1120         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1121 
1122         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1123         unchecked {
1124             // Updates:
1125             // - `balance += quantity`.
1126             // - `numberMinted += quantity`.
1127             //
1128             // We can directly add to the `balance` and `numberMinted`.
1129             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1130 
1131             // Updates:
1132             // - `address` to the owner.
1133             // - `startTimestamp` to the timestamp of minting.
1134             // - `burned` to `false`.
1135             // - `nextInitialized` to `quantity == 1`.
1136             _packedOwnerships[startTokenId] = _packOwnershipData(
1137                 to,
1138                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1139             );
1140 
1141             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1142 
1143             _currentIndex = startTokenId + quantity;
1144         }
1145         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1146     }
1147 
1148     /**
1149      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - If `to` refers to a smart contract, it must implement
1154      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1155      * - `quantity` must be greater than 0.
1156      *
1157      * See {_mint}.
1158      *
1159      * Emits a {Transfer} event for each mint.
1160      */
1161     function _safeMint(
1162         address to,
1163         uint256 quantity,
1164         bytes memory _data
1165     ) internal virtual {
1166         _mint(to, quantity);
1167 
1168         unchecked {
1169             if (to.code.length != 0) {
1170                 uint256 end = _currentIndex;
1171                 uint256 index = end - quantity;
1172                 do {
1173                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1174                         revert TransferToNonERC721ReceiverImplementer();
1175                     }
1176                 } while (index < end);
1177                 // Reentrancy protection.
1178                 if (_currentIndex != end) revert();
1179             }
1180         }
1181     }
1182 
1183     /**
1184      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1185      */
1186     function _safeMint(address to, uint256 quantity) internal virtual {
1187         _safeMint(to, quantity, '');
1188     }
1189 
1190     // =============================================================
1191     //                        BURN OPERATIONS
1192     // =============================================================
1193 
1194     /**
1195      * @dev Equivalent to `_burn(tokenId, false)`.
1196      */
1197     function _burn(uint256 tokenId) internal virtual {
1198         _burn(tokenId, false);
1199     }
1200 
1201     /**
1202      * @dev Destroys `tokenId`.
1203      * The approval is cleared when the token is burned.
1204      *
1205      * Requirements:
1206      *
1207      * - `tokenId` must exist.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1212         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1213 
1214         address from = address(uint160(prevOwnershipPacked));
1215 
1216         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1217 
1218         if (approvalCheck) {
1219             // The nested ifs save around 20+ gas over a compound boolean condition.
1220             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1221                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1222         }
1223 
1224         _beforeTokenTransfers(from, address(0), tokenId, 1);
1225 
1226         // Clear approvals from the previous owner.
1227         assembly {
1228             if approvedAddress {
1229                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1230                 sstore(approvedAddressSlot, 0)
1231             }
1232         }
1233 
1234         // Underflow of the sender's balance is impossible because we check for
1235         // ownership above and the recipient's balance can't realistically overflow.
1236         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1237         unchecked {
1238             // Updates:
1239             // - `balance -= 1`.
1240             // - `numberBurned += 1`.
1241             //
1242             // We can directly decrement the balance, and increment the number burned.
1243             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1244             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1245 
1246             // Updates:
1247             // - `address` to the last owner.
1248             // - `startTimestamp` to the timestamp of burning.
1249             // - `burned` to `true`.
1250             // - `nextInitialized` to `true`.
1251             _packedOwnerships[tokenId] = _packOwnershipData(
1252                 from,
1253                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1254             );
1255 
1256             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1257             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1258                 uint256 nextTokenId = tokenId + 1;
1259                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1260                 if (_packedOwnerships[nextTokenId] == 0) {
1261                     // If the next slot is within bounds.
1262                     if (nextTokenId != _currentIndex) {
1263                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1264                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1265                     }
1266                 }
1267             }
1268         }
1269 
1270         emit Transfer(from, address(0), tokenId);
1271         _afterTokenTransfers(from, address(0), tokenId, 1);
1272 
1273         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1274         unchecked {
1275             _burnCounter++;
1276         }
1277     }
1278 
1279     // =============================================================
1280     //                     EXTRA DATA OPERATIONS
1281     // =============================================================
1282 
1283     /**
1284      * @dev Directly sets the extra data for the ownership data `index`.
1285      */
1286     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1287         uint256 packed = _packedOwnerships[index];
1288         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1289         uint256 extraDataCasted;
1290         // Cast `extraData` with assembly to avoid redundant masking.
1291         assembly {
1292             extraDataCasted := extraData
1293         }
1294         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1295         _packedOwnerships[index] = packed;
1296     }
1297 
1298     /**
1299      * @dev Called during each token transfer to set the 24bit `extraData` field.
1300      * Intended to be overridden by the cosumer contract.
1301      *
1302      * `previousExtraData` - the value of `extraData` before transfer.
1303      *
1304      * Calling conditions:
1305      *
1306      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1307      * transferred to `to`.
1308      * - When `from` is zero, `tokenId` will be minted for `to`.
1309      * - When `to` is zero, `tokenId` will be burned by `from`.
1310      * - `from` and `to` are never both zero.
1311      */
1312     function _extraData(
1313         address from,
1314         address to,
1315         uint24 previousExtraData
1316     ) internal view virtual returns (uint24) {}
1317 
1318     /**
1319      * @dev Returns the next extra data for the packed ownership data.
1320      * The returned result is shifted into position.
1321      */
1322     function _nextExtraData(
1323         address from,
1324         address to,
1325         uint256 prevOwnershipPacked
1326     ) private view returns (uint256) {
1327         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1328         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1329     }
1330 
1331     // =============================================================
1332     //                       OTHER OPERATIONS
1333     // =============================================================
1334 
1335     /**
1336      * @dev Returns the message sender (defaults to `msg.sender`).
1337      *
1338      * If you are writing GSN compatible contracts, you need to override this function.
1339      */
1340     function _msgSenderERC721A() internal view virtual returns (address) {
1341         return msg.sender;
1342     }
1343 
1344     /**
1345      * @dev Converts a uint256 to its ASCII string decimal representation.
1346      */
1347     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1348         assembly {
1349             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1350             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1351             // We will need 1 32-byte word to store the length,
1352             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1353             str := add(mload(0x40), 0x80)
1354             // Update the free memory pointer to allocate.
1355             mstore(0x40, str)
1356 
1357             // Cache the end of the memory to calculate the length later.
1358             let end := str
1359 
1360             // We write the string from rightmost digit to leftmost digit.
1361             // The following is essentially a do-while loop that also handles the zero case.
1362             // prettier-ignore
1363             for { let temp := value } 1 {} {
1364                 str := sub(str, 1)
1365                 // Write the character to the pointer.
1366                 // The ASCII index of the '0' character is 48.
1367                 mstore8(str, add(48, mod(temp, 10)))
1368                 // Keep dividing `temp` until zero.
1369                 temp := div(temp, 10)
1370                 // prettier-ignore
1371                 if iszero(temp) { break }
1372             }
1373 
1374             let length := sub(end, str)
1375             // Move the pointer 32 bytes leftwards to make room for the length.
1376             str := sub(str, 0x20)
1377             // Store the length.
1378             mstore(str, length)
1379         }
1380     }
1381 }
1382 
1383 
1384 // File contracts/Ownable.sol
1385 
1386 // License-Identifier: MIT
1387 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1388 
1389 pragma solidity ^0.8.0;
1390 
1391 abstract contract Context {
1392     function _msgSender() internal view virtual returns (address) {
1393         return msg.sender;
1394     }
1395 
1396     function _msgData() internal view virtual returns (bytes calldata) {
1397         return msg.data;
1398     }
1399 }
1400 
1401 /**
1402  * @dev Contract module which provides a basic access control mechanism, where
1403  * there is an account (an owner) that can be granted exclusive access to
1404  * specific functions.
1405  *
1406  * By default, the owner account will be the one that deploys the contract. This
1407  * can later be changed with {transferOwnership}.
1408  *
1409  * This module is used through inheritance. It will make available the modifier
1410  * `onlyOwner`, which can be applied to your functions to restrict their use to
1411  * the owner.
1412  */
1413 abstract contract Ownable is Context {
1414     address private _owner;
1415 
1416     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1417 
1418     /**
1419      * @dev Initializes the contract setting the deployer as the initial owner.
1420      */
1421     constructor() {
1422         _transferOwnership(_msgSender());
1423     }
1424 
1425     /**
1426      * @dev Returns the address of the current owner.
1427      */
1428     function owner() public view virtual returns (address) {
1429         return _owner;
1430     }
1431 
1432     /**
1433      * @dev Throws if called by any account other than the owner.
1434      */
1435     modifier onlyOwner() {
1436         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1437         _;
1438     }
1439 
1440     /**
1441      * @dev Leaves the contract without owner. It will not be possible to call
1442      * `onlyOwner` functions anymore. Can only be called by the current owner.
1443      *
1444      * NOTE: Renouncing ownership will leave the contract without an owner,
1445      * thereby removing any functionality that is only available to the owner.
1446      */
1447     function renounceOwnership() public virtual onlyOwner {
1448         _transferOwnership(address(0));
1449     }
1450 
1451     /**
1452      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1453      * Can only be called by the current owner.
1454      */
1455     function transferOwnership(address newOwner) public virtual onlyOwner {
1456         require(newOwner != address(0), "Ownable: new owner is the zero address");
1457         _transferOwnership(newOwner);
1458     }
1459 
1460     /**
1461      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1462      * Internal function without access restriction.
1463      */
1464     function _transferOwnership(address newOwner) internal virtual {
1465         address oldOwner = _owner;
1466         _owner = newOwner;
1467         emit OwnershipTransferred(oldOwner, newOwner);
1468     }
1469 }
1470 
1471 
1472 // File contracts/labyrinths.sol
1473 
1474 // License-Identifier: MIT
1475 
1476 pragma solidity ^0.8.4;
1477 contract Labyrinths is ERC721A, Ownable {
1478     bool minted;
1479     string baseURI;
1480 
1481     constructor() ERC721A("Labyrinths", "LABYRINTH") {
1482         baseURI = "ipfs://QmZWRRS8114emSzTVf8iNPehTgvUZNHkRquMf826aBPFNW/";
1483     }
1484 
1485     function _baseURI() internal view virtual override returns (string memory) {
1486         return baseURI;
1487     }
1488 
1489     function setBaseURI(string memory newURI) external onlyOwner() {
1490         baseURI = newURI;
1491     }
1492 
1493     function mint() external payable {
1494         require(!minted, "Mint already completed");
1495         _mint(msg.sender, 1918);
1496         minted = true;
1497     }
1498 }