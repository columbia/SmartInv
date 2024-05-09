1 /**
2  █████╗ ██████╗ ███████╗    ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ███╗███╗   ███╗██╗   ██╗
3 ██╔══██╗██╔══██╗██╔════╝    ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗ ████║████╗ ████║██║   ██║
4 ███████║██████╔╝█████╗      ██████╔╝█████╗  ██║     ██║   ██║██╔████╔██║██╔████╔██║██║   ██║
5 ██╔══██║██╔═══╝ ██╔══╝      ██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██║   ██║
6 ██║  ██║██║     ███████╗    ██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║╚██████╔╝
7 ╚═╝  ╚═╝╚═╝     ╚══════╝    ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝ ╚═════╝ 
8                                                                                             
9  */
10 
11 // SPDX-License-Identifier: MIT 
12                                                                                                                                                                                                                           
13 pragma solidity ^0.8.12;
14 
15 /**
16  * @dev Interface of ERC721A.
17  */
18 interface IERC721A {
19     /**
20      * The caller must own the token or be an approved operator.
21      */
22     error ApprovalCallerNotOwnerNorApproved();
23 
24     /**
25      * The token does not exist.
26      */
27     error ApprovalQueryForNonexistentToken();
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
60      * Cannot safely transfer to a contract that does not implement the
61      * ERC721Receiver interface.
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
85     // =============================================================
86     //                            STRUCTS
87     // =============================================================
88 
89     struct TokenOwnership {
90         // The address of the owner.
91         address addr;
92         // Stores the start time of ownership with minimal overhead for tokenomics.
93         uint64 startTimestamp;
94         // Whether the token has been burned.
95         bool burned;
96         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
97         uint24 extraData;
98     }
99 
100     // =============================================================
101     //                         TOKEN COUNTERS
102     // =============================================================
103 
104     /**
105      * @dev Returns the total number of tokens in existence.
106      * Burned tokens will reduce the count.
107      * To get the total number of tokens minted, please see {_totalMinted}.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     // =============================================================
112     //                            IERC165
113     // =============================================================
114 
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 
125     // =============================================================
126     //                            IERC721
127     // =============================================================
128 
129     /**
130      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
131      */
132     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
136      */
137     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
138 
139     /**
140      * @dev Emitted when `owner` enables or disables
141      * (`approved`) `operator` to manage all of its assets.
142      */
143     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
144 
145     /**
146      * @dev Returns the number of tokens in `owner`'s account.
147      */
148     function balanceOf(address owner) external view returns (uint256 balance);
149 
150     /**
151      * @dev Returns the owner of the `tokenId` token.
152      *
153      * Requirements:
154      *
155      * - `tokenId` must exist.
156      */
157     function ownerOf(uint256 tokenId) external view returns (address owner);
158 
159     /**
160      * @dev Safely transfers `tokenId` token from `from` to `to`,
161      * checking first that contract recipients are aware of the ERC721 protocol
162      * to prevent tokens from being forever locked.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be have been allowed to move
170      * this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement
172      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId,
180         bytes calldata data
181     ) external payable;
182 
183     /**
184      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
185      */
186     function safeTransferFrom(
187         address from,
188         address to,
189         uint256 tokenId
190     ) external payable;
191 
192     /**
193      * @dev Transfers `tokenId` from `from` to `to`.
194      *
195      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
196      * whenever possible.
197      *
198      * Requirements:
199      *
200      * - `from` cannot be the zero address.
201      * - `to` cannot be the zero address.
202      * - `tokenId` token must be owned by `from`.
203      * - If the caller is not `from`, it must be approved to move this token
204      * by either {approve} or {setApprovalForAll}.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transferFrom(
209         address from,
210         address to,
211         uint256 tokenId
212     ) external payable;
213 
214     /**
215      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
216      * The approval is cleared when the token is transferred.
217      *
218      * Only a single account can be approved at a time, so approving the
219      * zero address clears previous approvals.
220      *
221      * Requirements:
222      *
223      * - The caller must own the token or be an approved operator.
224      * - `tokenId` must exist.
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address to, uint256 tokenId) external payable;
229 
230     /**
231      * @dev Approve or remove `operator` as an operator for the caller.
232      * Operators can call {transferFrom} or {safeTransferFrom}
233      * for any token owned by the caller.
234      *
235      * Requirements:
236      *
237      * - The `operator` cannot be the caller.
238      *
239      * Emits an {ApprovalForAll} event.
240      */
241     function setApprovalForAll(address operator, bool _approved) external;
242 
243     /**
244      * @dev Returns the account approved for `tokenId` token.
245      *
246      * Requirements:
247      *
248      * - `tokenId` must exist.
249      */
250     function getApproved(uint256 tokenId) external view returns (address operator);
251 
252     /**
253      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
254      *
255      * See {setApprovalForAll}.
256      */
257     function isApprovedForAll(address owner, address operator) external view returns (bool);
258 
259     // =============================================================
260     //                        IERC721Metadata
261     // =============================================================
262 
263     /**
264      * @dev Returns the token collection name.
265      */
266     function name() external view returns (string memory);
267 
268     /**
269      * @dev Returns the token collection symbol.
270      */
271     function symbol() external view returns (string memory);
272 
273     /**
274      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
275      */
276     function tokenURI(uint256 tokenId) external view returns (string memory);
277 
278     // =============================================================
279     //                           IERC2309
280     // =============================================================
281 
282     /**
283      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
284      * (inclusive) is transferred from `from` to `to`, as defined in the
285      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
286      *
287      * See {_mintERC2309} for more details.
288      */
289     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
290 }
291 
292 /**
293  * @title ERC721A
294  *
295  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
296  * Non-Fungible Token Standard, including the Metadata extension.
297  * Optimized for lower gas during batch mints.
298  *
299  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
300  * starting from `_startTokenId()`.
301  *
302  * Assumptions:
303  *
304  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
305  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
306  */
307 interface ERC721A__IERC721Receiver {
308     function onERC721Received(
309         address operator,
310         address from,
311         uint256 tokenId,
312         bytes calldata data
313     ) external returns (bytes4);
314 }
315 
316 /**
317  * @title ERC721A
318  *
319  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
320  * Non-Fungible Token Standard, including the Metadata extension.
321  * Optimized for lower gas during batch mints.
322  *
323  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
324  * starting from `_startTokenId()`.
325  *
326  * Assumptions:
327  *
328  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
329  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
330  */
331 contract ERC721A is IERC721A {
332     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
333     struct TokenApprovalRef {
334         address value;
335     }
336 
337     // =============================================================
338     //                           CONSTANTS
339     // =============================================================
340 
341     // Mask of an entry in packed address data.
342     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
343 
344     // The bit position of `numberMinted` in packed address data.
345     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
346 
347     // The bit position of `numberBurned` in packed address data.
348     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
349 
350     // The bit position of `aux` in packed address data.
351     uint256 private constant _BITPOS_AUX = 192;
352 
353     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
354     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
355 
356     // The bit position of `startTimestamp` in packed ownership.
357     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
358 
359     // The bit mask of the `burned` bit in packed ownership.
360     uint256 private constant _BITMASK_BURNED = 1 << 224;
361 
362     // The bit position of the `nextInitialized` bit in packed ownership.
363     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
364 
365     // The bit mask of the `nextInitialized` bit in packed ownership.
366     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
367 
368     // The bit position of `extraData` in packed ownership.
369     uint256 private constant _BITPOS_EXTRA_DATA = 232;
370 
371     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
372     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
373 
374     // The mask of the lower 160 bits for addresses.
375     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
376 
377     // The maximum `quantity` that can be minted with {_mintERC2309}.
378     // This limit is to prevent overflows on the address data entries.
379     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
380     // is required to cause an overflow, which is unrealistic.
381     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
382 
383     // The `Transfer` event signature is given by:
384     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
385     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
386         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
387 
388     // =============================================================
389     //                            STORAGE
390     // =============================================================
391 
392     // The next token ID to be minted.
393     uint256 private _currentIndex;
394 
395     // The number of tokens burned.
396     uint256 private _burnCounter;
397 
398     // Token name
399     string private _name;
400 
401     // Token symbol
402     string private _symbol;
403 
404     // Mapping from token ID to ownership details
405     // An empty struct value does not necessarily mean the token is unowned.
406     // See {_packedOwnershipOf} implementation for details.
407     //
408     // Bits Layout:
409     // - [0..159]   `addr`
410     // - [160..223] `startTimestamp`
411     // - [224]      `burned`
412     // - [225]      `nextInitialized`
413     // - [232..255] `extraData`
414     mapping(uint256 => uint256) private _packedOwnerships;
415 
416     // Mapping owner address to address data.
417     //
418     // Bits Layout:
419     // - [0..63]    `balance`
420     // - [64..127]  `numberMinted`
421     // - [128..191] `numberBurned`
422     // - [192..255] `aux`
423     mapping(address => uint256) private _packedAddressData;
424 
425     // Mapping from token ID to approved address.
426     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
427 
428     // Mapping from owner to operator approvals
429     mapping(address => mapping(address => bool)) private _operatorApprovals;
430 
431     // =============================================================
432     //                          CONSTRUCTOR
433     // =============================================================
434 
435     constructor(string memory name_, string memory symbol_) {
436         _name = name_;
437         _symbol = symbol_;
438         _currentIndex = _startTokenId();
439     }
440 
441     // =============================================================
442     //                   TOKEN COUNTING OPERATIONS
443     // =============================================================
444 
445     /**
446      * @dev Returns the starting token ID.
447      * To change the starting token ID, please override this function.
448      */
449     function _startTokenId() internal view virtual returns (uint256) {
450         return 0;
451     }
452 
453     /**
454      * @dev Returns the next token ID to be minted.
455      */
456     function _nextTokenId() internal view virtual returns (uint256) {
457         return _currentIndex;
458     }
459 
460     /**
461      * @dev Returns the total number of tokens in existence.
462      * Burned tokens will reduce the count.
463      * To get the total number of tokens minted, please see {_totalMinted}.
464      */
465     function totalSupply() public view virtual override returns (uint256) {
466         // Counter underflow is impossible as _burnCounter cannot be incremented
467         // more than `_currentIndex - _startTokenId()` times.
468         unchecked {
469             return _currentIndex - _burnCounter - _startTokenId();
470         }
471     }
472 
473     /**
474      * @dev Returns the total amount of tokens minted in the contract.
475      */
476     function _totalMinted() internal view virtual returns (uint256) {
477         // Counter underflow is impossible as `_currentIndex` does not decrement,
478         // and it is initialized to `_startTokenId()`.
479         unchecked {
480             return _currentIndex - _startTokenId();
481         }
482     }
483 
484     /**
485      * @dev Returns the total number of tokens burned.
486      */
487     function _totalBurned() internal view virtual returns (uint256) {
488         return _burnCounter;
489     }
490 
491     // =============================================================
492     //                    ADDRESS DATA OPERATIONS
493     // =============================================================
494 
495     /**
496      * @dev Returns the number of tokens in `owner`'s account.
497      */
498     function balanceOf(address owner) public view virtual override returns (uint256) {
499         if (owner == address(0)) revert BalanceQueryForZeroAddress();
500         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
501     }
502 
503     /**
504      * Returns the number of tokens minted by `owner`.
505      */
506     function _numberMinted(address owner) internal view returns (uint256) {
507         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
508     }
509 
510     /**
511      * Returns the number of tokens burned by or on behalf of `owner`.
512      */
513     function _numberBurned(address owner) internal view returns (uint256) {
514         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
515     }
516 
517     /**
518      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
519      */
520     function _getAux(address owner) internal view returns (uint64) {
521         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
522     }
523 
524     /**
525      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
526      * If there are multiple variables, please pack them into a uint64.
527      */
528     function _setAux(address owner, uint64 aux) internal virtual {
529         uint256 packed = _packedAddressData[owner];
530         uint256 auxCasted;
531         // Cast `aux` with assembly to avoid redundant masking.
532         assembly {
533             auxCasted := aux
534         }
535         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
536         _packedAddressData[owner] = packed;
537     }
538 
539     // =============================================================
540     //                            IERC165
541     // =============================================================
542 
543     /**
544      * @dev Returns true if this contract implements the interface defined by
545      * `interfaceId`. See the corresponding
546      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
547      * to learn more about how these ids are created.
548      *
549      * This function call must use less than 30000 gas.
550      */
551     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552         // The interface IDs are constants representing the first 4 bytes
553         // of the XOR of all function selectors in the interface.
554         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
555         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
556         return
557             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
558             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
559             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
560     }
561 
562     // =============================================================
563     //                        IERC721Metadata
564     // =============================================================
565 
566     /**
567      * @dev Returns the token collection name.
568      */
569     function name() public view virtual override returns (string memory) {
570         return _name;
571     }
572 
573     /**
574      * @dev Returns the token collection symbol.
575      */
576     function symbol() public view virtual override returns (string memory) {
577         return _symbol;
578     }
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
584         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
585 
586         string memory baseURI = _baseURI();
587         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
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
720     function approve(address to, uint256 tokenId) public payable virtual override {
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
757         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
758         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
759     }
760 
761     /**
762      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
763      *
764      * See {setApprovalForAll}.
765      */
766     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
767         return _operatorApprovals[owner][operator];
768     }
769 
770     /**
771      * @dev Returns whether `tokenId` exists.
772      *
773      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
774      *
775      * Tokens start existing when they are minted. See {_mint}.
776      */
777     function _exists(uint256 tokenId) internal view virtual returns (bool) {
778         return
779             _startTokenId() <= tokenId &&
780             tokenId < _currentIndex && // If within bounds,
781             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
782     }
783 
784     /**
785      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
786      */
787     function _isSenderApprovedOrOwner(
788         address approvedAddress,
789         address owner,
790         address msgSender
791     ) private pure returns (bool result) {
792         assembly {
793             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
794             owner := and(owner, _BITMASK_ADDRESS)
795             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
796             msgSender := and(msgSender, _BITMASK_ADDRESS)
797             // `msgSender == owner || msgSender == approvedAddress`.
798             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
799         }
800     }
801 
802     /**
803      * @dev Returns the storage slot and value for the approved address of `tokenId`.
804      */
805     function _getApprovedSlotAndAddress(uint256 tokenId)
806         private
807         view
808         returns (uint256 approvedAddressSlot, address approvedAddress)
809     {
810         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
811         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
812         assembly {
813             approvedAddressSlot := tokenApproval.slot
814             approvedAddress := sload(approvedAddressSlot)
815         }
816     }
817 
818     // =============================================================
819     //                      TRANSFER OPERATIONS
820     // =============================================================
821 
822     /**
823      * @dev Transfers `tokenId` from `from` to `to`.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must be owned by `from`.
830      * - If the caller is not `from`, it must be approved to move this token
831      * by either {approve} or {setApprovalForAll}.
832      *
833      * Emits a {Transfer} event.
834      */
835     function transferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) public payable virtual override {
840 
841         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
842 
843         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
844 
845         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
846 
847         // The nested ifs save around 20+ gas over a compound boolean condition.
848         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
849             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
850 
851         if (to == address(0)) revert TransferToZeroAddress();
852 
853         _beforeTokenTransfers(from, to, tokenId, 1);
854 
855         // Clear approvals from the previous owner.
856         assembly {
857             if approvedAddress {
858                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
859                 sstore(approvedAddressSlot, 0)
860             }
861         }
862 
863         // Underflow of the sender's balance is impossible because we check for
864         // ownership above and the recipient's balance can't realistically overflow.
865         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
866         unchecked {
867             // We can directly increment and decrement the balances.
868             --_packedAddressData[from]; // Updates: `balance -= 1`.
869             ++_packedAddressData[to]; // Updates: `balance += 1`.
870 
871             // Updates:
872             // - `address` to the next owner.
873             // - `startTimestamp` to the timestamp of transfering.
874             // - `burned` to `false`.
875             // - `nextInitialized` to `true`.
876             _packedOwnerships[tokenId] = _packOwnershipData(
877                 to,
878                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
879             );
880 
881             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
882             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
883                 uint256 nextTokenId = tokenId + 1;
884                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
885                 if (_packedOwnerships[nextTokenId] == 0) {
886                     // If the next slot is within bounds.
887                     if (nextTokenId != _currentIndex) {
888                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
889                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
890                     }
891                 }
892             }
893         }
894 
895         emit Transfer(from, to, tokenId);
896         _afterTokenTransfers(from, to, tokenId, 1);
897     }
898 
899     /**
900      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public payable virtual override {
907         safeTransferFrom(from, to, tokenId, '');
908     }
909 
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
931     ) public payable virtual override {
932         transferFrom(from, to, tokenId);
933         if (to.code.length != 0)
934             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
935                 revert TransferToNonERC721ReceiverImplementer();
936             }
937     }
938 
939 
940     /**
941      * @dev Hook that is called before a set of serially-ordered token IDs
942      * are about to be transferred. This includes minting.
943      * And also called before burning one token.
944      *
945      * `startTokenId` - the first token ID to be transferred.
946      * `quantity` - the amount to be transferred.
947      *
948      * Calling conditions:
949      *
950      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
951      * transferred to `to`.
952      * - When `from` is zero, `tokenId` will be minted for `to`.
953      * - When `to` is zero, `tokenId` will be burned by `from`.
954      * - `from` and `to` are never both zero.
955      */
956     function _beforeTokenTransfers(
957         address from,
958         address to,
959         uint256 startTokenId,
960         uint256 quantity
961     ) internal virtual {}
962 
963     /**
964      * @dev Hook that is called after a set of serially-ordered token IDs
965      * have been transferred. This includes minting.
966      * And also called after one token has been burned.
967      *
968      * `startTokenId` - the first token ID to be transferred.
969      * `quantity` - the amount to be transferred.
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` has been minted for `to`.
976      * - When `to` is zero, `tokenId` has been burned by `from`.
977      * - `from` and `to` are never both zero.
978      */
979     function _afterTokenTransfers(
980         address from,
981         address to,
982         uint256 startTokenId,
983         uint256 quantity
984     ) internal virtual {
985     }
986 
987     /**
988      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
989      *
990      * `from` - Previous owner of the given token ID.
991      * `to` - Target address that will receive the token.
992      * `tokenId` - Token ID to be transferred.
993      * `_data` - Optional data to send along with the call.
994      *
995      * Returns whether the call correctly returned the expected magic value.
996      */
997     function _checkContractOnERC721Received(
998         address from,
999         address to,
1000         uint256 tokenId,
1001         bytes memory _data
1002     ) private returns (bool) {
1003         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1004             bytes4 retval
1005         ) {
1006             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1007         } catch (bytes memory reason) {
1008             if (reason.length == 0) {
1009                 revert TransferToNonERC721ReceiverImplementer();
1010             } else {
1011                 assembly {
1012                     revert(add(32, reason), mload(reason))
1013                 }
1014             }
1015         }
1016     }
1017 
1018     // =============================================================
1019     //                        MINT OPERATIONS
1020     // =============================================================
1021 
1022     /**
1023      * @dev Mints `quantity` tokens and transfers them to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - `to` cannot be the zero address.
1028      * - `quantity` must be greater than 0.
1029      *
1030      * Emits a {Transfer} event for each mint.
1031      */
1032     function _mint(address to, uint256 quantity) internal virtual {
1033         uint256 startTokenId = _currentIndex;
1034         if (quantity == 0) revert MintZeroQuantity();
1035 
1036         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1037 
1038         // Overflows are incredibly unrealistic.
1039         // `balance` and `numberMinted` have a maximum limit of 2**64.
1040         // `tokenId` has a maximum limit of 2**256.
1041         unchecked {
1042             // Updates:
1043             // - `balance += quantity`.
1044             // - `numberMinted += quantity`.
1045             //
1046             // We can directly add to the `balance` and `numberMinted`.
1047             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1048 
1049             // Updates:
1050             // - `address` to the owner.
1051             // - `startTimestamp` to the timestamp of minting.
1052             // - `burned` to `false`.
1053             // - `nextInitialized` to `quantity == 1`.
1054             _packedOwnerships[startTokenId] = _packOwnershipData(
1055                 to,
1056                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1057             );
1058 
1059             uint256 toMasked;
1060             uint256 end = startTokenId + quantity;
1061 
1062             // Use assembly to loop and emit the `Transfer` event for gas savings.
1063             // The duplicated `log4` removes an extra check and reduces stack juggling.
1064             // The assembly, together with the surrounding Solidity code, have been
1065             // delicately arranged to nudge the compiler into producing optimized opcodes.
1066             assembly {
1067                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1068                 toMasked := and(to, _BITMASK_ADDRESS)
1069                 // Emit the `Transfer` event.
1070                 log4(
1071                     0, // Start of data (0, since no data).
1072                     0, // End of data (0, since no data).
1073                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1074                     0, // `address(0)`.
1075                     toMasked, // `to`.
1076                     startTokenId // `tokenId`.
1077                 )
1078 
1079                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1080                 // that overflows uint256 will make the loop run out of gas.
1081                 // The compiler will optimize the `iszero` away for performance.
1082                 for {
1083                     let tokenId := add(startTokenId, 1)
1084                 } iszero(eq(tokenId, end)) {
1085                     tokenId := add(tokenId, 1)
1086                 } {
1087                     // Emit the `Transfer` event. Similar to above.
1088                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1089                 }
1090             }
1091             if (toMasked == 0) revert MintToZeroAddress();
1092 
1093             _currentIndex = end;
1094         }
1095         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1096     }
1097 
1098     /**
1099      * @dev Mints `quantity` tokens and transfers them to `to`.
1100      *
1101      * This function is intended for efficient minting only during contract creation.
1102      *
1103      * It emits only one {ConsecutiveTransfer} as defined in
1104      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1105      * instead of a sequence of {Transfer} event(s).
1106      *
1107      * Calling this function outside of contract creation WILL make your contract
1108      * non-compliant with the ERC721 standard.
1109      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1110      * {ConsecutiveTransfer} event is only permissible during contract creation.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `quantity` must be greater than 0.
1116      *
1117      * Emits a {ConsecutiveTransfer} event.
1118      */
1119     function _mintERC2309(address to, uint256 quantity) internal virtual {
1120         uint256 startTokenId = _currentIndex;
1121         if (to == address(0)) revert MintToZeroAddress();
1122         if (quantity == 0) revert MintZeroQuantity();
1123         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1124 
1125         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1126 
1127         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1128         unchecked {
1129             // Updates:
1130             // - `balance += quantity`.
1131             // - `numberMinted += quantity`.
1132             //
1133             // We can directly add to the `balance` and `numberMinted`.
1134             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1135 
1136             // Updates:
1137             // - `address` to the owner.
1138             // - `startTimestamp` to the timestamp of minting.
1139             // - `burned` to `false`.
1140             // - `nextInitialized` to `quantity == 1`.
1141             _packedOwnerships[startTokenId] = _packOwnershipData(
1142                 to,
1143                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1144             );
1145 
1146             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1147 
1148             _currentIndex = startTokenId + quantity;
1149         }
1150         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1151     }
1152 
1153     /**
1154      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - If `to` refers to a smart contract, it must implement
1159      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1160      * - `quantity` must be greater than 0.
1161      *
1162      * See {_mint}.
1163      *
1164      * Emits a {Transfer} event for each mint.
1165      */
1166     function _safeMint(
1167         address to,
1168         uint256 quantity,
1169         bytes memory _data
1170     ) internal virtual {
1171         _mint(to, quantity);
1172 
1173         unchecked {
1174             if (to.code.length != 0) {
1175                 uint256 end = _currentIndex;
1176                 uint256 index = end - quantity;
1177                 do {
1178                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1179                         revert TransferToNonERC721ReceiverImplementer();
1180                     }
1181                 } while (index < end);
1182                 // Reentrancy protection.
1183                 if (_currentIndex != end) revert();
1184             }
1185         }
1186     }
1187 
1188     /**
1189      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1190      */
1191     function _safeMint(address to, uint256 quantity) internal virtual {
1192         _safeMint(to, quantity, '');
1193     }
1194 
1195     // =============================================================
1196     //                        BURN OPERATIONS
1197     // =============================================================
1198 
1199     /**
1200      * @dev Equivalent to `_burn(tokenId, false)`.
1201      */
1202     function _burn(uint256 tokenId) internal virtual {
1203         _burn(tokenId, false);
1204     }
1205 
1206     /**
1207      * @dev Destroys `tokenId`.
1208      * The approval is cleared when the token is burned.
1209      *
1210      * Requirements:
1211      *
1212      * - `tokenId` must exist.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1217         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1218 
1219         address from = address(uint160(prevOwnershipPacked));
1220 
1221         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1222 
1223         if (approvalCheck) {
1224             // The nested ifs save around 20+ gas over a compound boolean condition.
1225             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1226                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1227         }
1228 
1229         _beforeTokenTransfers(from, address(0), tokenId, 1);
1230 
1231         // Clear approvals from the previous owner.
1232         assembly {
1233             if approvedAddress {
1234                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1235                 sstore(approvedAddressSlot, 0)
1236             }
1237         }
1238 
1239         // Underflow of the sender's balance is impossible because we check for
1240         // ownership above and the recipient's balance can't realistically overflow.
1241         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1242         unchecked {
1243             // Updates:
1244             // - `balance -= 1`.
1245             // - `numberBurned += 1`.
1246             //
1247             // We can directly decrement the balance, and increment the number burned.
1248             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1249             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1250 
1251             // Updates:
1252             // - `address` to the last owner.
1253             // - `startTimestamp` to the timestamp of burning.
1254             // - `burned` to `true`.
1255             // - `nextInitialized` to `true`.
1256             _packedOwnerships[tokenId] = _packOwnershipData(
1257                 from,
1258                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1259             );
1260 
1261             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1262             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1263                 uint256 nextTokenId = tokenId + 1;
1264                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1265                 if (_packedOwnerships[nextTokenId] == 0) {
1266                     // If the next slot is within bounds.
1267                     if (nextTokenId != _currentIndex) {
1268                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1269                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1270                     }
1271                 }
1272             }
1273         }
1274 
1275         emit Transfer(from, address(0), tokenId);
1276         _afterTokenTransfers(from, address(0), tokenId, 1);
1277 
1278         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1279         unchecked {
1280             _burnCounter++;
1281         }
1282     }
1283 
1284     // =============================================================
1285     //                     EXTRA DATA OPERATIONS
1286     // =============================================================
1287 
1288     /**
1289      * @dev Directly sets the extra data for the ownership data `index`.
1290      */
1291     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1292         uint256 packed = _packedOwnerships[index];
1293         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1294         uint256 extraDataCasted;
1295         // Cast `extraData` with assembly to avoid redundant masking.
1296         assembly {
1297             extraDataCasted := extraData
1298         }
1299         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1300         _packedOwnerships[index] = packed;
1301     }
1302 
1303     /**
1304      * @dev Called during each token transfer to set the 24bit `extraData` field.
1305      * Intended to be overridden by the cosumer contract.
1306      *
1307      * `previousExtraData` - the value of `extraData` before transfer.
1308      *
1309      * Calling conditions:
1310      *
1311      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1312      * transferred to `to`.
1313      * - When `from` is zero, `tokenId` will be minted for `to`.
1314      * - When `to` is zero, `tokenId` will be burned by `from`.
1315      * - `from` and `to` are never both zero.
1316      */
1317     function _extraData(
1318         address from,
1319         address to,
1320         uint24 previousExtraData
1321     ) internal view virtual returns (uint24) {}
1322 
1323     /**
1324      * @dev Returns the next extra data for the packed ownership data.
1325      * The returned result is shifted into position.
1326      */
1327     function _nextExtraData(
1328         address from,
1329         address to,
1330         uint256 prevOwnershipPacked
1331     ) private view returns (uint256) {
1332         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1333         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1334     }
1335 
1336     // =============================================================
1337     //                       OTHER OPERATIONS
1338     // =============================================================
1339 
1340     /**
1341      * @dev Returns the message sender (defaults to `msg.sender`).
1342      *
1343      * If you are writing GSN compatible contracts, you need to override this function.
1344      */
1345     function _msgSenderERC721A() internal view virtual returns (address) {
1346         return msg.sender;
1347     }
1348 
1349     /**
1350      * @dev Converts a uint256 to its ASCII string decimal representation.
1351      */
1352     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1353         assembly {
1354             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1355             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1356             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1357             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1358             let m := add(mload(0x40), 0xa0)
1359             // Update the free memory pointer to allocate.
1360             mstore(0x40, m)
1361             // Assign the `str` to the end.
1362             str := sub(m, 0x20)
1363             // Zeroize the slot after the string.
1364             mstore(str, 0)
1365 
1366             // Cache the end of the memory to calculate the length later.
1367             let end := str
1368 
1369             // We write the string from rightmost digit to leftmost digit.
1370             // The following is essentially a do-while loop that also handles the zero case.
1371             // prettier-ignore
1372             for { let temp := value } 1 {} {
1373                 str := sub(str, 1)
1374                 // Write the character to the pointer.
1375                 // The ASCII index of the '0' character is 48.
1376                 mstore8(str, add(48, mod(temp, 10)))
1377                 // Keep dividing `temp` until zero.
1378                 temp := div(temp, 10)
1379                 // prettier-ignore
1380                 if iszero(temp) { break }
1381             }
1382 
1383             let length := sub(end, str)
1384             // Move the pointer 32 bytes leftwards to make room for the length.
1385             str := sub(str, 0x20)
1386             // Store the length.
1387             mstore(str, length)
1388         }
1389     }
1390 }
1391 
1392 
1393 contract ApeRecommu is ERC721A {
1394     string uri = "ipfs://bafybeiglvsp54eqjxzzv5hzbrazsow2mg4rbpksvidgfkouir65gu6bhs4/";
1395 
1396     address public owner;
1397 
1398     uint256 public maxSupply;
1399 
1400     uint256 public mintPrice;
1401 
1402     uint256 private maxPerWallet;
1403 
1404     uint256 private maxPerTx;
1405 
1406     function claim(uint256 amount) payable public {
1407         require(totalSupply() + amount <= maxSupply);
1408         require(msg.value >= mintPrice * amount);
1409         _safeMint(msg.sender, amount);
1410     }
1411 
1412     function claim() public {
1413         require(msg.sender == tx.origin);
1414         require(totalSupply() + 1 <= maxSupply);
1415         require(balanceOf(msg.sender) < maxPerWallet);
1416         _mints(msg.sender);
1417     }
1418 
1419     function _mints(address addr) internal {
1420         _mint(msg.sender, FreeNum());
1421     }
1422 
1423     function teamMint(address addr, uint256 amount) public onlyOwner {
1424         require(totalSupply() + amount <= maxSupply);
1425         _safeMint(addr, amount);
1426     }
1427 
1428     function setMintPrice(uint256 _publicPrice) external onlyOwner {
1429         mintPrice = _publicPrice;
1430     }    
1431     
1432     modifier onlyOwner {
1433         require(owner == msg.sender);
1434         _;
1435     }
1436 
1437     constructor() ERC721A("Ape Recommu", "AR") {
1438         owner = msg.sender;
1439         maxSupply = 3333;
1440         mintPrice = 0.001 ether;
1441         maxPerWallet = 10;
1442         maxPerTx = 10;
1443     }
1444 
1445     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1446         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1447     }
1448 
1449     function FreeNum() internal returns (uint256){
1450         if (totalSupply() < 1000) {
1451             return 4;
1452         }
1453         if (totalSupply() < 2000) {
1454             return 2;
1455         }
1456         return 1;
1457     }
1458 
1459     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1460         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1461         return (owner, royaltyAmount);
1462     }
1463 
1464     function withdraw() external onlyOwner {
1465         payable(msg.sender).transfer(address(this).balance);
1466     }
1467 
1468 }