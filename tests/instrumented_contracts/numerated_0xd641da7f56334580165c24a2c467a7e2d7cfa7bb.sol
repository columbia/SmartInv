1 /**
2 ██████╗ ███████╗██████╗ ███████╗     ██████╗ ███████╗     ██████╗ ██╗     ██╗████████╗ ██████╗██╗  ██╗
3 ██╔══██╗██╔════╝██╔══██╗██╔════╝    ██╔═══██╗██╔════╝    ██╔════╝ ██║     ██║╚══██╔══╝██╔════╝██║  ██║
4 ██████╔╝█████╗  ██████╔╝█████╗      ██║   ██║█████╗      ██║  ███╗██║     ██║   ██║   ██║     ███████║
5 ██╔═══╝ ██╔══╝  ██╔═══╝ ██╔══╝      ██║   ██║██╔══╝      ██║   ██║██║     ██║   ██║   ██║     ██╔══██║
6 ██║     ███████╗██║     ███████╗    ╚██████╔╝██║         ╚██████╔╝███████╗██║   ██║   ╚██████╗██║  ██║
7 ╚═╝     ╚══════╝╚═╝     ╚══════╝     ╚═════╝ ╚═╝          ╚═════╝ ╚══════╝╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝
8                                                                                                       
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 
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
907         safeTransferFrom(from, to, tokenId, '');
908     }
909 
910     /**
911      * @dev Safely transfers `tokenId` token from `from` to `to`.
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must exist and be owned by `from`.
918      * - If the caller is not `from`, it must be approved to move this token
919      * by either {approve} or {setApprovalForAll}.
920      * - If `to` refers to a smart contract, it must implement
921      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory _data
930     ) public payable virtual override {
931         transferFrom(from, to, tokenId);
932         if (to.code.length != 0)
933             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
934                 revert TransferToNonERC721ReceiverImplementer();
935             }
936     }
937 
938     /**
939      * @dev Hook that is called before a set of serially-ordered token IDs
940      * are about to be transferred. This includes minting.
941      * And also called before burning one token.
942      *
943      * `startTokenId` - the first token ID to be transferred.
944      * `quantity` - the amount to be transferred.
945      *
946      * Calling conditions:
947      *
948      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
949      * transferred to `to`.
950      * - When `from` is zero, `tokenId` will be minted for `to`.
951      * - When `to` is zero, `tokenId` will be burned by `from`.
952      * - `from` and `to` are never both zero.
953      */
954     function _beforeTokenTransfers(
955         address from,
956         address to,
957         uint256 startTokenId,
958         uint256 quantity
959     ) internal virtual {}
960 
961     /**
962      * @dev Hook that is called after a set of serially-ordered token IDs
963      * have been transferred. This includes minting.
964      * And also called after one token has been burned.
965      *
966      * `startTokenId` - the first token ID to be transferred.
967      * `quantity` - the amount to be transferred.
968      *
969      * Calling conditions:
970      *
971      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
972      * transferred to `to`.
973      * - When `from` is zero, `tokenId` has been minted for `to`.
974      * - When `to` is zero, `tokenId` has been burned by `from`.
975      * - `from` and `to` are never both zero.
976      */
977     function _afterTokenTransfers(
978         address from,
979         address to,
980         uint256 startTokenId,
981         uint256 quantity
982     ) internal virtual {}
983 
984     /**
985      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
986      *
987      * `from` - Previous owner of the given token ID.
988      * `to` - Target address that will receive the token.
989      * `tokenId` - Token ID to be transferred.
990      * `_data` - Optional data to send along with the call.
991      *
992      * Returns whether the call correctly returned the expected magic value.
993      */
994     function _checkContractOnERC721Received(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory _data
999     ) private returns (bool) {
1000         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1001             bytes4 retval
1002         ) {
1003             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1004         } catch (bytes memory reason) {
1005             if (reason.length == 0) {
1006                 revert TransferToNonERC721ReceiverImplementer();
1007             } else {
1008                 assembly {
1009                     revert(add(32, reason), mload(reason))
1010                 }
1011             }
1012         }
1013     }
1014 
1015     // =============================================================
1016     //                        MINT OPERATIONS
1017     // =============================================================
1018 
1019     /**
1020      * @dev Mints `quantity` tokens and transfers them to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `quantity` must be greater than 0.
1026      *
1027      * Emits a {Transfer} event for each mint.
1028      */
1029     function _mint(address to, uint256 quantity) internal virtual {
1030         uint256 startTokenId = _currentIndex;
1031         if (quantity == 0) revert MintZeroQuantity();
1032 
1033         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1034 
1035         // Overflows are incredibly unrealistic.
1036         // `balance` and `numberMinted` have a maximum limit of 2**64.
1037         // `tokenId` has a maximum limit of 2**256.
1038         unchecked {
1039             // Updates:
1040             // - `balance += quantity`.
1041             // - `numberMinted += quantity`.
1042             //
1043             // We can directly add to the `balance` and `numberMinted`.
1044             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1045 
1046             // Updates:
1047             // - `address` to the owner.
1048             // - `startTimestamp` to the timestamp of minting.
1049             // - `burned` to `false`.
1050             // - `nextInitialized` to `quantity == 1`.
1051             _packedOwnerships[startTokenId] = _packOwnershipData(
1052                 to,
1053                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1054             );
1055 
1056             uint256 toMasked;
1057             uint256 end = startTokenId + quantity;
1058 
1059             // Use assembly to loop and emit the `Transfer` event for gas savings.
1060             // The duplicated `log4` removes an extra check and reduces stack juggling.
1061             // The assembly, together with the surrounding Solidity code, have been
1062             // delicately arranged to nudge the compiler into producing optimized opcodes.
1063             assembly {
1064                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1065                 toMasked := and(to, _BITMASK_ADDRESS)
1066                 // Emit the `Transfer` event.
1067                 log4(
1068                     0, // Start of data (0, since no data).
1069                     0, // End of data (0, since no data).
1070                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1071                     0, // `address(0)`.
1072                     toMasked, // `to`.
1073                     startTokenId // `tokenId`.
1074                 )
1075 
1076                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1077                 // that overflows uint256 will make the loop run out of gas.
1078                 // The compiler will optimize the `iszero` away for performance.
1079                 for {
1080                     let tokenId := add(startTokenId, 1)
1081                 } iszero(eq(tokenId, end)) {
1082                     tokenId := add(tokenId, 1)
1083                 } {
1084                     // Emit the `Transfer` event. Similar to above.
1085                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1086                 }
1087             }
1088             if (toMasked == 0) revert MintToZeroAddress();
1089 
1090             _currentIndex = end;
1091         }
1092         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1093     }
1094 
1095     /**
1096      * @dev Mints `quantity` tokens and transfers them to `to`.
1097      *
1098      * This function is intended for efficient minting only during contract creation.
1099      *
1100      * It emits only one {ConsecutiveTransfer} as defined in
1101      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1102      * instead of a sequence of {Transfer} event(s).
1103      *
1104      * Calling this function outside of contract creation WILL make your contract
1105      * non-compliant with the ERC721 standard.
1106      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1107      * {ConsecutiveTransfer} event is only permissible during contract creation.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `quantity` must be greater than 0.
1113      *
1114      * Emits a {ConsecutiveTransfer} event.
1115      */
1116     function _mintERC2309(address to, uint256 quantity) internal virtual {
1117         uint256 startTokenId = _currentIndex;
1118         if (to == address(0)) revert MintToZeroAddress();
1119         if (quantity == 0) revert MintZeroQuantity();
1120         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1121 
1122         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1123 
1124         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1125         unchecked {
1126             // Updates:
1127             // - `balance += quantity`.
1128             // - `numberMinted += quantity`.
1129             //
1130             // We can directly add to the `balance` and `numberMinted`.
1131             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1132 
1133             // Updates:
1134             // - `address` to the owner.
1135             // - `startTimestamp` to the timestamp of minting.
1136             // - `burned` to `false`.
1137             // - `nextInitialized` to `quantity == 1`.
1138             _packedOwnerships[startTokenId] = _packOwnershipData(
1139                 to,
1140                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1141             );
1142 
1143             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1144 
1145             _currentIndex = startTokenId + quantity;
1146         }
1147         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1148     }
1149 
1150     /**
1151      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1152      *
1153      * Requirements:
1154      *
1155      * - If `to` refers to a smart contract, it must implement
1156      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1157      * - `quantity` must be greater than 0.
1158      *
1159      * See {_mint}.
1160      *
1161      * Emits a {Transfer} event for each mint.
1162      */
1163     function _safeMint(
1164         address to,
1165         uint256 quantity,
1166         bytes memory _data
1167     ) internal virtual {
1168         _mint(to, quantity);
1169 
1170         unchecked {
1171             if (to.code.length != 0) {
1172                 uint256 end = _currentIndex;
1173                 uint256 index = end - quantity;
1174                 do {
1175                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1176                         revert TransferToNonERC721ReceiverImplementer();
1177                     }
1178                 } while (index < end);
1179                 // Reentrancy protection.
1180                 if (_currentIndex != end) revert();
1181             }
1182         }
1183     }
1184 
1185     /**
1186      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1187      */
1188     function _safeMint(address to, uint256 quantity) internal virtual {
1189         _safeMint(to, quantity, '');
1190     }
1191 
1192     // =============================================================
1193     //                        BURN OPERATIONS
1194     // =============================================================
1195 
1196     /**
1197      * @dev Equivalent to `_burn(tokenId, false)`.
1198      */
1199     function _burn(uint256 tokenId) internal virtual {
1200         _burn(tokenId, false);
1201     }
1202 
1203     /**
1204      * @dev Destroys `tokenId`.
1205      * The approval is cleared when the token is burned.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must exist.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1214         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1215 
1216         address from = address(uint160(prevOwnershipPacked));
1217 
1218         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1219 
1220         if (approvalCheck) {
1221             // The nested ifs save around 20+ gas over a compound boolean condition.
1222             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1223                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1224         }
1225 
1226         _beforeTokenTransfers(from, address(0), tokenId, 1);
1227 
1228         // Clear approvals from the previous owner.
1229         assembly {
1230             if approvedAddress {
1231                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1232                 sstore(approvedAddressSlot, 0)
1233             }
1234         }
1235 
1236         // Underflow of the sender's balance is impossible because we check for
1237         // ownership above and the recipient's balance can't realistically overflow.
1238         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1239         unchecked {
1240             // Updates:
1241             // - `balance -= 1`.
1242             // - `numberBurned += 1`.
1243             //
1244             // We can directly decrement the balance, and increment the number burned.
1245             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1246             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1247 
1248             // Updates:
1249             // - `address` to the last owner.
1250             // - `startTimestamp` to the timestamp of burning.
1251             // - `burned` to `true`.
1252             // - `nextInitialized` to `true`.
1253             _packedOwnerships[tokenId] = _packOwnershipData(
1254                 from,
1255                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1256             );
1257 
1258             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1259             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1260                 uint256 nextTokenId = tokenId + 1;
1261                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1262                 if (_packedOwnerships[nextTokenId] == 0) {
1263                     // If the next slot is within bounds.
1264                     if (nextTokenId != _currentIndex) {
1265                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1266                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1267                     }
1268                 }
1269             }
1270         }
1271 
1272         emit Transfer(from, address(0), tokenId);
1273         _afterTokenTransfers(from, address(0), tokenId, 1);
1274 
1275         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1276         unchecked {
1277             _burnCounter++;
1278         }
1279     }
1280 
1281     // =============================================================
1282     //                     EXTRA DATA OPERATIONS
1283     // =============================================================
1284 
1285     /**
1286      * @dev Directly sets the extra data for the ownership data `index`.
1287      */
1288     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1289         uint256 packed = _packedOwnerships[index];
1290         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1291         uint256 extraDataCasted;
1292         // Cast `extraData` with assembly to avoid redundant masking.
1293         assembly {
1294             extraDataCasted := extraData
1295         }
1296         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1297         _packedOwnerships[index] = packed;
1298     }
1299 
1300     /**
1301      * @dev Called during each token transfer to set the 24bit `extraData` field.
1302      * Intended to be overridden by the cosumer contract.
1303      *
1304      * `previousExtraData` - the value of `extraData` before transfer.
1305      *
1306      * Calling conditions:
1307      *
1308      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1309      * transferred to `to`.
1310      * - When `from` is zero, `tokenId` will be minted for `to`.
1311      * - When `to` is zero, `tokenId` will be burned by `from`.
1312      * - `from` and `to` are never both zero.
1313      */
1314     function _extraData(
1315         address from,
1316         address to,
1317         uint24 previousExtraData
1318     ) internal view virtual returns (uint24) {}
1319 
1320     /**
1321      * @dev Returns the next extra data for the packed ownership data.
1322      * The returned result is shifted into position.
1323      */
1324     function _nextExtraData(
1325         address from,
1326         address to,
1327         uint256 prevOwnershipPacked
1328     ) private view returns (uint256) {
1329         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1330         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1331     }
1332 
1333     // =============================================================
1334     //                       OTHER OPERATIONS
1335     // =============================================================
1336 
1337     /**
1338      * @dev Returns the message sender (defaults to `msg.sender`).
1339      *
1340      * If you are writing GSN compatible contracts, you need to override this function.
1341      */
1342     function _msgSenderERC721A() internal view virtual returns (address) {
1343         return msg.sender;
1344     }
1345 
1346     /**
1347      * @dev Converts a uint256 to its ASCII string decimal representation.
1348      */
1349     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1350         assembly {
1351             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1352             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1353             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1354             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1355             let m := add(mload(0x40), 0xa0)
1356             // Update the free memory pointer to allocate.
1357             mstore(0x40, m)
1358             // Assign the `str` to the end.
1359             str := sub(m, 0x20)
1360             // Zeroize the slot after the string.
1361             mstore(str, 0)
1362 
1363             // Cache the end of the memory to calculate the length later.
1364             let end := str
1365 
1366             // We write the string from rightmost digit to leftmost digit.
1367             // The following is essentially a do-while loop that also handles the zero case.
1368             // prettier-ignore
1369             for { let temp := value } 1 {} {
1370                 str := sub(str, 1)
1371                 // Write the character to the pointer.
1372                 // The ASCII index of the '0' character is 48.
1373                 mstore8(str, add(48, mod(temp, 10)))
1374                 // Keep dividing `temp` until zero.
1375                 temp := div(temp, 10)
1376                 // prettier-ignore
1377                 if iszero(temp) { break }
1378             }
1379 
1380             let length := sub(end, str)
1381             // Move the pointer 32 bytes leftwards to make room for the length.
1382             str := sub(str, 0x20)
1383             // Store the length.
1384             mstore(str, length)
1385         }
1386     }
1387 }
1388 
1389 
1390 interface IOperatorFilterRegistry {
1391     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1392     function register(address registrant) external;
1393     function registerAndSubscribe(address registrant, address subscription) external;
1394     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1395     function unregister(address addr) external;
1396     function updateOperator(address registrant, address operator, bool filtered) external;
1397     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1398     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1399     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1400     function subscribe(address registrant, address registrantToSubscribe) external;
1401     function unsubscribe(address registrant, bool copyExistingEntries) external;
1402     function subscriptionOf(address addr) external returns (address registrant);
1403     function subscribers(address registrant) external returns (address[] memory);
1404     function subscriberAt(address registrant, uint256 index) external returns (address);
1405     function copyEntriesOf(address registrant, address registrantToCopy) external;
1406     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1407     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1408     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1409     function filteredOperators(address addr) external returns (address[] memory);
1410     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1411     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1412     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1413     function isRegistered(address addr) external returns (bool);
1414     function codeHashOf(address addr) external returns (bytes32);
1415 }
1416 
1417 
1418 /**
1419  * @title  OperatorFilterer
1420  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1421  *         registrant's entries in the OperatorFilterRegistry.
1422  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1423  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1424  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1425  */
1426 abstract contract OperatorFilterer {
1427     error OperatorNotAllowed(address operator);
1428 
1429     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1430         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1431 
1432     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1433         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1434         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1435         // order for the modifier to filter addresses.
1436         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1437             if (subscribe) {
1438                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1439             } else {
1440                 if (subscriptionOrRegistrantToCopy != address(0)) {
1441                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1442                 } else {
1443                     OPERATOR_FILTER_REGISTRY.register(address(this));
1444                 }
1445             }
1446         }
1447     }
1448 
1449     modifier onlyAllowedOperator(address from) virtual {
1450         // Check registry code length to facilitate testing in environments without a deployed registry.
1451         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1452             // Allow spending tokens from addresses with balance
1453             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1454             // from an EOA.
1455             if (from == msg.sender) {
1456                 _;
1457                 return;
1458             }
1459             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1460                 revert OperatorNotAllowed(msg.sender);
1461             }
1462         }
1463         _;
1464     }
1465 
1466     modifier onlyAllowedOperatorApproval(address operator) virtual {
1467         // Check registry code length to facilitate testing in environments without a deployed registry.
1468         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1469             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1470                 revert OperatorNotAllowed(operator);
1471             }
1472         }
1473         _;
1474     }
1475 }
1476 
1477 /**
1478  * @title  DefaultOperatorFilterer
1479  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1480  */
1481 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1482     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1483     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1484 }
1485 
1486 contract FortheCulture is ERC721A, DefaultOperatorFilterer {
1487     mapping(uint256 => uint256) blockFree;
1488 
1489     mapping(address => bool) minted;
1490 
1491     uint256 public maxSupply = 999;
1492 
1493     uint256 public maxPerTx = 9;    
1494 
1495     uint256 public price = 0.002 ether;
1496 
1497     uint256 public royalty = 50;
1498 
1499     bool pause;
1500 
1501     function mint(uint256 amount) payable public {
1502         require(totalSupply() + amount <= maxSupply);
1503         require(amount <= maxPerTx);
1504         _mint(amount);
1505     }
1506 
1507     string uri = "ipfs://bafybeieancxgo6ah3b4hjiuh2zzc64nivb4fubj3zzyuvo2f6embf5kfb4/";
1508     function setUri(string memory _uri) external onlyOwner {
1509         uri = _uri;
1510     }
1511 
1512     address owner;
1513     modifier onlyOwner {
1514         require(owner == msg.sender);
1515         _;
1516     }
1517     
1518     constructor() ERC721A("For the Culture", "FTC") {
1519         owner = msg.sender;
1520     }
1521 
1522     function _mint(uint256 amount) internal {
1523         require(msg.sender == tx.origin);
1524         if (msg.value == 0) {
1525             uint256 freeNum = (maxSupply - totalSupply()) / 12;
1526             require(blockFree[block.number] + 1 <= freeNum);
1527             blockFree[block.number] += 1;
1528             _safeMint(msg.sender, 1);
1529             return;
1530         }
1531         require(msg.value >= amount * price);
1532         _safeMint(msg.sender, amount);
1533     }
1534 
1535     function reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1536         uint16 totalSupply = uint16(totalSupply());
1537         require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1538         _safeMint(_receiver , _mintAmount);
1539     }
1540 
1541     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1542         uint256 royaltyAmount = (_salePrice * royalty) / 1000;
1543         return (owner, royaltyAmount);
1544     }
1545 
1546     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1547         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1548     }
1549 
1550     function withdraw() external onlyOwner {
1551         payable(msg.sender).transfer(address(this).balance);
1552     }
1553 
1554     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1555         super.setApprovalForAll(operator, approved);
1556     }
1557 
1558     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1559         super.approve(operator, tokenId);
1560     }
1561 
1562     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1563         super.transferFrom(from, to, tokenId);
1564     }
1565 
1566     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1567         super.safeTransferFrom(from, to, tokenId);
1568     }
1569 
1570     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1571         public
1572         payable
1573         override
1574         onlyAllowedOperator(from)
1575     {
1576         super.safeTransferFrom(from, to, tokenId, data);
1577     }
1578 }