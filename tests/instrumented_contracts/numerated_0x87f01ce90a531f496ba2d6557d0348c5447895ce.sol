1 /*
2   ___  _   _  __  __  ____  __    ____  _  _  ___
3  / __)( )_( )(  )(  )(  _ \(  )  (_  _)( \( )/ __)
4 ( (__  ) _ (  )(__)(  ) _ < )(__  _)(_  )  ( \__ \
5  \___)(_) (_)(______)(____/(____)(____)(_)\_)(___/  ~ Reborn ~
6 
7 By Christian Montoya
8 m0nt0y4.eth
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 
14 
15 // File: erc721a/contracts/IERC721A.sol
16 
17 
18 // ERC721A Contracts v4.2.2
19 // Creator: Chiru Labs
20 
21 pragma solidity ^0.8.4;
22 
23 /**
24  * @dev Interface of ERC721A.
25  */
26 interface IERC721A {
27     /**
28      * The caller must own the token or be an approved operator.
29      */
30     error ApprovalCallerNotOwnerNorApproved();
31 
32     /**
33      * The token does not exist.
34      */
35     error ApprovalQueryForNonexistentToken();
36 
37     /**
38      * The caller cannot approve to their own address.
39      */
40     error ApproveToCaller();
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
194     ) external;
195 
196     /**
197      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
198      */
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external;
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
225     ) external;
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
241     function approve(address to, uint256 tokenId) external;
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
305 // File: erc721a/contracts/ERC721A.sol
306 
307 
308 // ERC721A Contracts v4.2.2
309 // Creator: Chiru Labs
310 
311 pragma solidity ^0.8.4;
312 
313 
314 /**
315  * @dev Interface of ERC721 token receiver.
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
342     // Reference type for token approval.
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
730     function approve(address to, uint256 tokenId) public virtual override {
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
767         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
768 
769         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
770         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
771     }
772 
773     /**
774      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
775      *
776      * See {setApprovalForAll}.
777      */
778     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
779         return _operatorApprovals[owner][operator];
780     }
781 
782     /**
783      * @dev Returns whether `tokenId` exists.
784      *
785      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
786      *
787      * Tokens start existing when they are minted. See {_mint}.
788      */
789     function _exists(uint256 tokenId) internal view virtual returns (bool) {
790         return
791             _startTokenId() <= tokenId &&
792             tokenId < _currentIndex && // If within bounds,
793             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
794     }
795 
796     /**
797      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
798      */
799     function _isSenderApprovedOrOwner(
800         address approvedAddress,
801         address owner,
802         address msgSender
803     ) private pure returns (bool result) {
804         assembly {
805             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
806             owner := and(owner, _BITMASK_ADDRESS)
807             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
808             msgSender := and(msgSender, _BITMASK_ADDRESS)
809             // `msgSender == owner || msgSender == approvedAddress`.
810             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
811         }
812     }
813 
814     /**
815      * @dev Returns the storage slot and value for the approved address of `tokenId`.
816      */
817     function _getApprovedSlotAndAddress(uint256 tokenId)
818         private
819         view
820         returns (uint256 approvedAddressSlot, address approvedAddress)
821     {
822         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
823         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
824         assembly {
825             approvedAddressSlot := tokenApproval.slot
826             approvedAddress := sload(approvedAddressSlot)
827         }
828     }
829 
830     // =============================================================
831     //                      TRANSFER OPERATIONS
832     // =============================================================
833 
834     /**
835      * @dev Transfers `tokenId` from `from` to `to`.
836      *
837      * Requirements:
838      *
839      * - `from` cannot be the zero address.
840      * - `to` cannot be the zero address.
841      * - `tokenId` token must be owned by `from`.
842      * - If the caller is not `from`, it must be approved to move this token
843      * by either {approve} or {setApprovalForAll}.
844      *
845      * Emits a {Transfer} event.
846      */
847     function transferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) public virtual override {
852         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
853 
854         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
855 
856         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
857 
858         // The nested ifs save around 20+ gas over a compound boolean condition.
859         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
860             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
861 
862         if (to == address(0)) revert TransferToZeroAddress();
863 
864         _beforeTokenTransfers(from, to, tokenId, 1);
865 
866         // Clear approvals from the previous owner.
867         assembly {
868             if approvedAddress {
869                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
870                 sstore(approvedAddressSlot, 0)
871             }
872         }
873 
874         // Underflow of the sender's balance is impossible because we check for
875         // ownership above and the recipient's balance can't realistically overflow.
876         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
877         unchecked {
878             // We can directly increment and decrement the balances.
879             --_packedAddressData[from]; // Updates: `balance -= 1`.
880             ++_packedAddressData[to]; // Updates: `balance += 1`.
881 
882             // Updates:
883             // - `address` to the next owner.
884             // - `startTimestamp` to the timestamp of transfering.
885             // - `burned` to `false`.
886             // - `nextInitialized` to `true`.
887             _packedOwnerships[tokenId] = _packOwnershipData(
888                 to,
889                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
890             );
891 
892             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
893             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
894                 uint256 nextTokenId = tokenId + 1;
895                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
896                 if (_packedOwnerships[nextTokenId] == 0) {
897                     // If the next slot is within bounds.
898                     if (nextTokenId != _currentIndex) {
899                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
900                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
901                     }
902                 }
903             }
904         }
905 
906         emit Transfer(from, to, tokenId);
907         _afterTokenTransfers(from, to, tokenId, 1);
908     }
909 
910     /**
911      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId
917     ) public virtual override {
918         safeTransferFrom(from, to, tokenId, '');
919     }
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
941     ) public virtual override {
942         transferFrom(from, to, tokenId);
943         if (to.code.length != 0)
944             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
945                 revert TransferToNonERC721ReceiverImplementer();
946             }
947     }
948 
949     /**
950      * @dev Hook that is called before a set of serially-ordered token IDs
951      * are about to be transferred. This includes minting.
952      * And also called before burning one token.
953      *
954      * `startTokenId` - the first token ID to be transferred.
955      * `quantity` - the amount to be transferred.
956      *
957      * Calling conditions:
958      *
959      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
960      * transferred to `to`.
961      * - When `from` is zero, `tokenId` will be minted for `to`.
962      * - When `to` is zero, `tokenId` will be burned by `from`.
963      * - `from` and `to` are never both zero.
964      */
965     function _beforeTokenTransfers(
966         address from,
967         address to,
968         uint256 startTokenId,
969         uint256 quantity
970     ) internal virtual {}
971 
972     /**
973      * @dev Hook that is called after a set of serially-ordered token IDs
974      * have been transferred. This includes minting.
975      * And also called after one token has been burned.
976      *
977      * `startTokenId` - the first token ID to be transferred.
978      * `quantity` - the amount to be transferred.
979      *
980      * Calling conditions:
981      *
982      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
983      * transferred to `to`.
984      * - When `from` is zero, `tokenId` has been minted for `to`.
985      * - When `to` is zero, `tokenId` has been burned by `from`.
986      * - `from` and `to` are never both zero.
987      */
988     function _afterTokenTransfers(
989         address from,
990         address to,
991         uint256 startTokenId,
992         uint256 quantity
993     ) internal virtual {}
994 
995     /**
996      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
997      *
998      * `from` - Previous owner of the given token ID.
999      * `to` - Target address that will receive the token.
1000      * `tokenId` - Token ID to be transferred.
1001      * `_data` - Optional data to send along with the call.
1002      *
1003      * Returns whether the call correctly returned the expected magic value.
1004      */
1005     function _checkContractOnERC721Received(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) private returns (bool) {
1011         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1012             bytes4 retval
1013         ) {
1014             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1015         } catch (bytes memory reason) {
1016             if (reason.length == 0) {
1017                 revert TransferToNonERC721ReceiverImplementer();
1018             } else {
1019                 assembly {
1020                     revert(add(32, reason), mload(reason))
1021                 }
1022             }
1023         }
1024     }
1025 
1026     // =============================================================
1027     //                        MINT OPERATIONS
1028     // =============================================================
1029 
1030     /**
1031      * @dev Mints `quantity` tokens and transfers them to `to`.
1032      *
1033      * Requirements:
1034      *
1035      * - `to` cannot be the zero address.
1036      * - `quantity` must be greater than 0.
1037      *
1038      * Emits a {Transfer} event for each mint.
1039      */
1040     function _mint(address to, uint256 quantity) internal virtual {
1041         uint256 startTokenId = _currentIndex;
1042         if (quantity == 0) revert MintZeroQuantity();
1043 
1044         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1045 
1046         // Overflows are incredibly unrealistic.
1047         // `balance` and `numberMinted` have a maximum limit of 2**64.
1048         // `tokenId` has a maximum limit of 2**256.
1049         unchecked {
1050             // Updates:
1051             // - `balance += quantity`.
1052             // - `numberMinted += quantity`.
1053             //
1054             // We can directly add to the `balance` and `numberMinted`.
1055             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1056 
1057             // Updates:
1058             // - `address` to the owner.
1059             // - `startTimestamp` to the timestamp of minting.
1060             // - `burned` to `false`.
1061             // - `nextInitialized` to `quantity == 1`.
1062             _packedOwnerships[startTokenId] = _packOwnershipData(
1063                 to,
1064                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1065             );
1066 
1067             uint256 toMasked;
1068             uint256 end = startTokenId + quantity;
1069 
1070             // Use assembly to loop and emit the `Transfer` event for gas savings.
1071             assembly {
1072                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1073                 toMasked := and(to, _BITMASK_ADDRESS)
1074                 // Emit the `Transfer` event.
1075                 log4(
1076                     0, // Start of data (0, since no data).
1077                     0, // End of data (0, since no data).
1078                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1079                     0, // `address(0)`.
1080                     toMasked, // `to`.
1081                     startTokenId // `tokenId`.
1082                 )
1083 
1084                 for {
1085                     let tokenId := add(startTokenId, 1)
1086                 } iszero(eq(tokenId, end)) {
1087                     tokenId := add(tokenId, 1)
1088                 } {
1089                     // Emit the `Transfer` event. Similar to above.
1090                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1091                 }
1092             }
1093             if (toMasked == 0) revert MintToZeroAddress();
1094 
1095             _currentIndex = end;
1096         }
1097         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1098     }
1099 
1100     /**
1101      * @dev Mints `quantity` tokens and transfers them to `to`.
1102      *
1103      * This function is intended for efficient minting only during contract creation.
1104      *
1105      * It emits only one {ConsecutiveTransfer} as defined in
1106      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1107      * instead of a sequence of {Transfer} event(s).
1108      *
1109      * Calling this function outside of contract creation WILL make your contract
1110      * non-compliant with the ERC721 standard.
1111      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1112      * {ConsecutiveTransfer} event is only permissible during contract creation.
1113      *
1114      * Requirements:
1115      *
1116      * - `to` cannot be the zero address.
1117      * - `quantity` must be greater than 0.
1118      *
1119      * Emits a {ConsecutiveTransfer} event.
1120      */
1121     function _mintERC2309(address to, uint256 quantity) internal virtual {
1122         uint256 startTokenId = _currentIndex;
1123         if (to == address(0)) revert MintToZeroAddress();
1124         if (quantity == 0) revert MintZeroQuantity();
1125         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1126 
1127         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1128 
1129         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1130         unchecked {
1131             // Updates:
1132             // - `balance += quantity`.
1133             // - `numberMinted += quantity`.
1134             //
1135             // We can directly add to the `balance` and `numberMinted`.
1136             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1137 
1138             // Updates:
1139             // - `address` to the owner.
1140             // - `startTimestamp` to the timestamp of minting.
1141             // - `burned` to `false`.
1142             // - `nextInitialized` to `quantity == 1`.
1143             _packedOwnerships[startTokenId] = _packOwnershipData(
1144                 to,
1145                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1146             );
1147 
1148             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1149 
1150             _currentIndex = startTokenId + quantity;
1151         }
1152         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1153     }
1154 
1155     /**
1156      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1157      *
1158      * Requirements:
1159      *
1160      * - If `to` refers to a smart contract, it must implement
1161      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1162      * - `quantity` must be greater than 0.
1163      *
1164      * See {_mint}.
1165      *
1166      * Emits a {Transfer} event for each mint.
1167      */
1168     function _safeMint(
1169         address to,
1170         uint256 quantity,
1171         bytes memory _data
1172     ) internal virtual {
1173         _mint(to, quantity);
1174 
1175         unchecked {
1176             if (to.code.length != 0) {
1177                 uint256 end = _currentIndex;
1178                 uint256 index = end - quantity;
1179                 do {
1180                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1181                         revert TransferToNonERC721ReceiverImplementer();
1182                     }
1183                 } while (index < end);
1184                 // Reentrancy protection.
1185                 if (_currentIndex != end) revert();
1186             }
1187         }
1188     }
1189 
1190     /**
1191      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1192      */
1193     function _safeMint(address to, uint256 quantity) internal virtual {
1194         _safeMint(to, quantity, '');
1195     }
1196 
1197     // =============================================================
1198     //                        BURN OPERATIONS
1199     // =============================================================
1200 
1201     /**
1202      * @dev Equivalent to `_burn(tokenId, false)`.
1203      */
1204     function _burn(uint256 tokenId) internal virtual {
1205         _burn(tokenId, false);
1206     }
1207 
1208     /**
1209      * @dev Destroys `tokenId`.
1210      * The approval is cleared when the token is burned.
1211      *
1212      * Requirements:
1213      *
1214      * - `tokenId` must exist.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1219         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1220 
1221         address from = address(uint160(prevOwnershipPacked));
1222 
1223         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1224 
1225         if (approvalCheck) {
1226             // The nested ifs save around 20+ gas over a compound boolean condition.
1227             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1228                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1229         }
1230 
1231         _beforeTokenTransfers(from, address(0), tokenId, 1);
1232 
1233         // Clear approvals from the previous owner.
1234         assembly {
1235             if approvedAddress {
1236                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1237                 sstore(approvedAddressSlot, 0)
1238             }
1239         }
1240 
1241         // Underflow of the sender's balance is impossible because we check for
1242         // ownership above and the recipient's balance can't realistically overflow.
1243         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1244         unchecked {
1245             // Updates:
1246             // - `balance -= 1`.
1247             // - `numberBurned += 1`.
1248             //
1249             // We can directly decrement the balance, and increment the number burned.
1250             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1251             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1252 
1253             // Updates:
1254             // - `address` to the last owner.
1255             // - `startTimestamp` to the timestamp of burning.
1256             // - `burned` to `true`.
1257             // - `nextInitialized` to `true`.
1258             _packedOwnerships[tokenId] = _packOwnershipData(
1259                 from,
1260                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1261             );
1262 
1263             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1264             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1265                 uint256 nextTokenId = tokenId + 1;
1266                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1267                 if (_packedOwnerships[nextTokenId] == 0) {
1268                     // If the next slot is within bounds.
1269                     if (nextTokenId != _currentIndex) {
1270                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1271                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1272                     }
1273                 }
1274             }
1275         }
1276 
1277         emit Transfer(from, address(0), tokenId);
1278         _afterTokenTransfers(from, address(0), tokenId, 1);
1279 
1280         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1281         unchecked {
1282             _burnCounter++;
1283         }
1284     }
1285 
1286     // =============================================================
1287     //                     EXTRA DATA OPERATIONS
1288     // =============================================================
1289 
1290     /**
1291      * @dev Directly sets the extra data for the ownership data `index`.
1292      */
1293     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1294         uint256 packed = _packedOwnerships[index];
1295         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1296         uint256 extraDataCasted;
1297         // Cast `extraData` with assembly to avoid redundant masking.
1298         assembly {
1299             extraDataCasted := extraData
1300         }
1301         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1302         _packedOwnerships[index] = packed;
1303     }
1304 
1305     /**
1306      * @dev Called during each token transfer to set the 24bit `extraData` field.
1307      * Intended to be overridden by the cosumer contract.
1308      *
1309      * `previousExtraData` - the value of `extraData` before transfer.
1310      *
1311      * Calling conditions:
1312      *
1313      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1314      * transferred to `to`.
1315      * - When `from` is zero, `tokenId` will be minted for `to`.
1316      * - When `to` is zero, `tokenId` will be burned by `from`.
1317      * - `from` and `to` are never both zero.
1318      */
1319     function _extraData(
1320         address from,
1321         address to,
1322         uint24 previousExtraData
1323     ) internal view virtual returns (uint24) {}
1324 
1325     /**
1326      * @dev Returns the next extra data for the packed ownership data.
1327      * The returned result is shifted into position.
1328      */
1329     function _nextExtraData(
1330         address from,
1331         address to,
1332         uint256 prevOwnershipPacked
1333     ) private view returns (uint256) {
1334         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1335         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1336     }
1337 
1338     // =============================================================
1339     //                       OTHER OPERATIONS
1340     // =============================================================
1341 
1342     /**
1343      * @dev Returns the message sender (defaults to `msg.sender`).
1344      *
1345      * If you are writing GSN compatible contracts, you need to override this function.
1346      */
1347     function _msgSenderERC721A() internal view virtual returns (address) {
1348         return msg.sender;
1349     }
1350 
1351     /**
1352      * @dev Converts a uint256 to its ASCII string decimal representation.
1353      */
1354     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1355         assembly {
1356             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1357             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1358             // We will need 1 32-byte word to store the length,
1359             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1360             str := add(mload(0x40), 0x80)
1361             // Update the free memory pointer to allocate.
1362             mstore(0x40, str)
1363 
1364             // Cache the end of the memory to calculate the length later.
1365             let end := str
1366 
1367             // We write the string from rightmost digit to leftmost digit.
1368             // The following is essentially a do-while loop that also handles the zero case.
1369             // prettier-ignore
1370             for { let temp := value } 1 {} {
1371                 str := sub(str, 1)
1372                 // Write the character to the pointer.
1373                 // The ASCII index of the '0' character is 48.
1374                 mstore8(str, add(48, mod(temp, 10)))
1375                 // Keep dividing `temp` until zero.
1376                 temp := div(temp, 10)
1377                 // prettier-ignore
1378                 if iszero(temp) { break }
1379             }
1380 
1381             let length := sub(end, str)
1382             // Move the pointer 32 bytes leftwards to make room for the length.
1383             str := sub(str, 0x20)
1384             // Store the length.
1385             mstore(str, length)
1386         }
1387     }
1388 }
1389 
1390 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1391 
1392 
1393 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1394 
1395 pragma solidity ^0.8.0;
1396 
1397 /**
1398  * @dev These functions deal with verification of Merkle Tree proofs.
1399  *
1400  * The proofs can be generated using the JavaScript library
1401  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1402  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1403  *
1404  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1405  *
1406  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1407  * hashing, or use a hash function other than keccak256 for hashing leaves.
1408  * This is because the concatenation of a sorted pair of internal nodes in
1409  * the merkle tree could be reinterpreted as a leaf value.
1410  */
1411 library MerkleProof {
1412     /**
1413      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1414      * defined by `root`. For this, a `proof` must be provided, containing
1415      * sibling hashes on the branch from the leaf to the root of the tree. Each
1416      * pair of leaves and each pair of pre-images are assumed to be sorted.
1417      */
1418     function verify(
1419         bytes32[] memory proof,
1420         bytes32 root,
1421         bytes32 leaf
1422     ) internal pure returns (bool) {
1423         return processProof(proof, leaf) == root;
1424     }
1425 
1426     /**
1427      * @dev Calldata version of {verify}
1428      *
1429      * _Available since v4.7._
1430      */
1431     function verifyCalldata(
1432         bytes32[] calldata proof,
1433         bytes32 root,
1434         bytes32 leaf
1435     ) internal pure returns (bool) {
1436         return processProofCalldata(proof, leaf) == root;
1437     }
1438 
1439     /**
1440      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1441      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1442      * hash matches the root of the tree. When processing the proof, the pairs
1443      * of leafs & pre-images are assumed to be sorted.
1444      *
1445      * _Available since v4.4._
1446      */
1447     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1448         bytes32 computedHash = leaf;
1449         for (uint256 i = 0; i < proof.length; i++) {
1450             computedHash = _hashPair(computedHash, proof[i]);
1451         }
1452         return computedHash;
1453     }
1454 
1455     /**
1456      * @dev Calldata version of {processProof}
1457      *
1458      * _Available since v4.7._
1459      */
1460     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1461         bytes32 computedHash = leaf;
1462         for (uint256 i = 0; i < proof.length; i++) {
1463             computedHash = _hashPair(computedHash, proof[i]);
1464         }
1465         return computedHash;
1466     }
1467 
1468     /**
1469      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1470      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1471      *
1472      * _Available since v4.7._
1473      */
1474     function multiProofVerify(
1475         bytes32[] memory proof,
1476         bool[] memory proofFlags,
1477         bytes32 root,
1478         bytes32[] memory leaves
1479     ) internal pure returns (bool) {
1480         return processMultiProof(proof, proofFlags, leaves) == root;
1481     }
1482 
1483     /**
1484      * @dev Calldata version of {multiProofVerify}
1485      *
1486      * _Available since v4.7._
1487      */
1488     function multiProofVerifyCalldata(
1489         bytes32[] calldata proof,
1490         bool[] calldata proofFlags,
1491         bytes32 root,
1492         bytes32[] memory leaves
1493     ) internal pure returns (bool) {
1494         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1495     }
1496 
1497     /**
1498      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1499      * consuming from one or the other at each step according to the instructions given by
1500      * `proofFlags`.
1501      *
1502      * _Available since v4.7._
1503      */
1504     function processMultiProof(
1505         bytes32[] memory proof,
1506         bool[] memory proofFlags,
1507         bytes32[] memory leaves
1508     ) internal pure returns (bytes32 merkleRoot) {
1509         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1510         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1511         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1512         // the merkle tree.
1513         uint256 leavesLen = leaves.length;
1514         uint256 totalHashes = proofFlags.length;
1515 
1516         // Check proof validity.
1517         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1518 
1519         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1520         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1521         bytes32[] memory hashes = new bytes32[](totalHashes);
1522         uint256 leafPos = 0;
1523         uint256 hashPos = 0;
1524         uint256 proofPos = 0;
1525         // At each step, we compute the next hash using two values:
1526         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1527         //   get the next hash.
1528         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1529         //   `proof` array.
1530         for (uint256 i = 0; i < totalHashes; i++) {
1531             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1532             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1533             hashes[i] = _hashPair(a, b);
1534         }
1535 
1536         if (totalHashes > 0) {
1537             return hashes[totalHashes - 1];
1538         } else if (leavesLen > 0) {
1539             return leaves[0];
1540         } else {
1541             return proof[0];
1542         }
1543     }
1544 
1545     /**
1546      * @dev Calldata version of {processMultiProof}
1547      *
1548      * _Available since v4.7._
1549      */
1550     function processMultiProofCalldata(
1551         bytes32[] calldata proof,
1552         bool[] calldata proofFlags,
1553         bytes32[] memory leaves
1554     ) internal pure returns (bytes32 merkleRoot) {
1555         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1556         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1557         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1558         // the merkle tree.
1559         uint256 leavesLen = leaves.length;
1560         uint256 totalHashes = proofFlags.length;
1561 
1562         // Check proof validity.
1563         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1564 
1565         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1566         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1567         bytes32[] memory hashes = new bytes32[](totalHashes);
1568         uint256 leafPos = 0;
1569         uint256 hashPos = 0;
1570         uint256 proofPos = 0;
1571         // At each step, we compute the next hash using two values:
1572         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1573         //   get the next hash.
1574         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1575         //   `proof` array.
1576         for (uint256 i = 0; i < totalHashes; i++) {
1577             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1578             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1579             hashes[i] = _hashPair(a, b);
1580         }
1581 
1582         if (totalHashes > 0) {
1583             return hashes[totalHashes - 1];
1584         } else if (leavesLen > 0) {
1585             return leaves[0];
1586         } else {
1587             return proof[0];
1588         }
1589     }
1590 
1591     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1592         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1593     }
1594 
1595     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1596         /// @solidity memory-safe-assembly
1597         assembly {
1598             mstore(0x00, a)
1599             mstore(0x20, b)
1600             value := keccak256(0x00, 0x40)
1601         }
1602     }
1603 }
1604 
1605 // File: @openzeppelin/contracts/utils/Context.sol
1606 
1607 
1608 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1609 
1610 pragma solidity ^0.8.0;
1611 
1612 /**
1613  * @dev Provides information about the current execution context, including the
1614  * sender of the transaction and its data. While these are generally available
1615  * via msg.sender and msg.data, they should not be accessed in such a direct
1616  * manner, since when dealing with meta-transactions the account sending and
1617  * paying for execution may not be the actual sender (as far as an application
1618  * is concerned).
1619  *
1620  * This contract is only required for intermediate, library-like contracts.
1621  */
1622 abstract contract Context {
1623     function _msgSender() internal view virtual returns (address) {
1624         return msg.sender;
1625     }
1626 
1627     function _msgData() internal view virtual returns (bytes calldata) {
1628         return msg.data;
1629     }
1630 }
1631 
1632 // File: @openzeppelin/contracts/access/Ownable.sol
1633 
1634 
1635 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1636 
1637 pragma solidity ^0.8.0;
1638 
1639 
1640 /**
1641  * @dev Contract module which provides a basic access control mechanism, where
1642  * there is an account (an owner) that can be granted exclusive access to
1643  * specific functions.
1644  *
1645  * By default, the owner account will be the one that deploys the contract. This
1646  * can later be changed with {transferOwnership}.
1647  *
1648  * This module is used through inheritance. It will make available the modifier
1649  * `onlyOwner`, which can be applied to your functions to restrict their use to
1650  * the owner.
1651  */
1652 abstract contract Ownable is Context {
1653     address private _owner;
1654 
1655     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1656 
1657     /**
1658      * @dev Initializes the contract setting the deployer as the initial owner.
1659      */
1660     constructor() {
1661         _transferOwnership(_msgSender());
1662     }
1663 
1664     /**
1665      * @dev Returns the address of the current owner.
1666      */
1667     function owner() public view virtual returns (address) {
1668         return _owner;
1669     }
1670 
1671     /**
1672      * @dev Throws if called by any account other than the owner.
1673      */
1674     modifier onlyOwner() {
1675         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1676         _;
1677     }
1678 
1679     /**
1680      * @dev Leaves the contract without owner. It will not be possible to call
1681      * `onlyOwner` functions anymore. Can only be called by the current owner.
1682      *
1683      * NOTE: Renouncing ownership will leave the contract without an owner,
1684      * thereby removing any functionality that is only available to the owner.
1685      */
1686     function renounceOwnership() public virtual onlyOwner {
1687         _transferOwnership(address(0));
1688     }
1689 
1690     /**
1691      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1692      * Can only be called by the current owner.
1693      */
1694     function transferOwnership(address newOwner) public virtual onlyOwner {
1695         require(newOwner != address(0), "Ownable: new owner is the zero address");
1696         _transferOwnership(newOwner);
1697     }
1698 
1699     /**
1700      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1701      * Internal function without access restriction.
1702      */
1703     function _transferOwnership(address newOwner) internal virtual {
1704         address oldOwner = _owner;
1705         _owner = newOwner;
1706         emit OwnershipTransferred(oldOwner, newOwner);
1707     }
1708 }
1709 
1710 // File: @openzeppelin/contracts/utils/Base64.sol
1711 
1712 
1713 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
1714 
1715 pragma solidity ^0.8.0;
1716 
1717 /**
1718  * @dev Provides a set of functions to operate with Base64 strings.
1719  *
1720  * _Available since v4.5._
1721  */
1722 library Base64 {
1723     /**
1724      * @dev Base64 Encoding/Decoding Table
1725      */
1726     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1727 
1728     /**
1729      * @dev Converts a `bytes` to its Bytes64 `string` representation.
1730      */
1731     function encode(bytes memory data) internal pure returns (string memory) {
1732         /**
1733          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
1734          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
1735          */
1736         if (data.length == 0) return "";
1737 
1738         // Loads the table into memory
1739         string memory table = _TABLE;
1740 
1741         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
1742         // and split into 4 numbers of 6 bits.
1743         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
1744         // - `data.length + 2`  -> Round up
1745         // - `/ 3`              -> Number of 3-bytes chunks
1746         // - `4 *`              -> 4 characters for each chunk
1747         string memory result = new string(4 * ((data.length + 2) / 3));
1748 
1749         /// @solidity memory-safe-assembly
1750         assembly {
1751             // Prepare the lookup table (skip the first "length" byte)
1752             let tablePtr := add(table, 1)
1753 
1754             // Prepare result pointer, jump over length
1755             let resultPtr := add(result, 32)
1756 
1757             // Run over the input, 3 bytes at a time
1758             for {
1759                 let dataPtr := data
1760                 let endPtr := add(data, mload(data))
1761             } lt(dataPtr, endPtr) {
1762 
1763             } {
1764                 // Advance 3 bytes
1765                 dataPtr := add(dataPtr, 3)
1766                 let input := mload(dataPtr)
1767 
1768                 // To write each character, shift the 3 bytes (18 bits) chunk
1769                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
1770                 // and apply logical AND with 0x3F which is the number of
1771                 // the previous character in the ASCII table prior to the Base64 Table
1772                 // The result is then added to the table to get the character to write,
1773                 // and finally write it in the result pointer but with a left shift
1774                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
1775 
1776                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1777                 resultPtr := add(resultPtr, 1) // Advance
1778 
1779                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1780                 resultPtr := add(resultPtr, 1) // Advance
1781 
1782                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
1783                 resultPtr := add(resultPtr, 1) // Advance
1784 
1785                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
1786                 resultPtr := add(resultPtr, 1) // Advance
1787             }
1788 
1789             // When data `bytes` is not exactly 3 bytes long
1790             // it is padded with `=` characters at the end
1791             switch mod(mload(data), 3)
1792             case 1 {
1793                 mstore8(sub(resultPtr, 1), 0x3d)
1794                 mstore8(sub(resultPtr, 2), 0x3d)
1795             }
1796             case 2 {
1797                 mstore8(sub(resultPtr, 1), 0x3d)
1798             }
1799         }
1800 
1801         return result;
1802     }
1803 }
1804 
1805 // File: contracts/ChublinsReborn.sol
1806 
1807 /*
1808   ___  _   _  __  __  ____  __    ____  _  _  ___
1809  / __)( )_( )(  )(  )(  _ \(  )  (_  _)( \( )/ __)
1810 ( (__  ) _ (  )(__)(  ) _ < )(__  _)(_  )  ( \__ \
1811  \___)(_) (_)(______)(____/(____)(____)(_)\_)(___/  ~ Reborn ~
1812 
1813 By Christian Montoya
1814 m0nt0y4.eth
1815 
1816 */
1817 
1818 pragma solidity ^0.8.17;
1819 
1820 // Chublins Reborn Contract v1
1821 // Creator: Christian Montoya
1822 contract ChublinsReborn is ERC721A, Ownable { 
1823     constructor() ERC721A("Chublins Reborn", "CHUB") { }
1824 
1825     uint256 private _basePrice = 0.01 ether; 
1826     uint16 private _maxSupply = 5556; 
1827     uint16 private _maxMint = 2;
1828     bool private _publicMintOpen; 
1829     bool private _pngsAvailable; 
1830     bytes32 public merkleRoot; 
1831     string private _baseTokenURI = "https://chublins.xyz/png/"; 
1832     uint8[5556] private _chubFlags; // will track license status and whether to return PNG or SVG
1833 
1834     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner { 
1835         merkleRoot = _merkleRoot; 
1836     }
1837 
1838     function openPublicMint() external onlyOwner {
1839         _publicMintOpen = true; 
1840     }
1841 
1842     function isPublicMintOpen() external view returns (bool) {
1843         return _publicMintOpen;
1844     }
1845 
1846     function setMaxMintPerWallet(uint16 max) external onlyOwner { 
1847         _maxMint = max; 
1848     }
1849 
1850     function allowListMint(uint256 quantity, bytes32[] calldata merkleProof) external payable {
1851         require(maxSupply() >= (totalSupply() + quantity)); 
1852         require(_numberMinted(msg.sender) + quantity <= _maxMint);
1853         require(msg.value == (_basePrice * quantity));
1854         require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender)))); 
1855         _mint(msg.sender, quantity);
1856     }
1857 
1858     function mint(uint256 quantity) external payable {
1859         require(_publicMintOpen && maxSupply() >= (totalSupply() + quantity)); 
1860         require(_numberMinted(msg.sender) + quantity <= _maxMint); 
1861         require(msg.value == (_basePrice * quantity));
1862         require(msg.sender == tx.origin); 
1863         _mint(msg.sender, quantity);
1864     }
1865 
1866     // this is for raffles and for making secondary buyers from first collection whole 
1867     function ownerMint(uint256 quantity) external onlyOwner {
1868         require(maxSupply() >= (totalSupply() + quantity)); 
1869         _mint(msg.sender, quantity);
1870     }
1871 
1872     // traits
1873 
1874     string[8] private _bgColors = ["c0caff","ff6b6b","ffdd59","0be881","fd9644","a55eea","778ca3","f8a5c2"];
1875     string[8] private _bgColorIds = ["sky","tomato","lemon","jade","clementine","royal","slate","sakura"];
1876 
1877     string[3] private _ears = [
1878         '',
1879 		'<path d="M-46 -140 -26 -170 -6 -140M124 -137 144 -167 164 -137" class="lnft"/>',
1880 		'<path d="M-48,-142 a0.9,1 0 0,1 60,-8M116,-146 a0.9,1 0 0,1 60,12" class="lnft th"/>'
1881 	];
1882     string[3] private _earIds = ["none","cat","bear"];
1883 
1884     string[4] private _hats = [
1885         '',
1886         '<ellipse cx="62" cy="-128" rx="50" ry="15"/><path d="M27,-130 a1,1 0 0,1 70,0"/><path d="M27,-130 a6,1 0 1,0 70,0" stroke="gray" stroke-width="2"/>',
1887         '<path d="M16 -112a1 1 0 0 1 100 0M16 -112a2.5 1.5 18 1 0 100 0"/><path d="M17-112h99" stroke="#000" stroke-width="2"/><path d="M16-112a50 6.25 0 1 0 100 0" stroke="#555" stroke-width="2" stroke-linecap="round"/><text x="52" y="-117" fill="#ddd">chub</text>',
1888         '<path d="m62-146 4-58-40-20" class="lnrt"/><circle cx="26" cy="-224" r="14"/>'
1889     ];
1890     string[4] private _hatIds = ["none","bowl","cap","antenna"];
1891 
1892     string[14] private _eyes = [
1893         '<circle cx="10" cy="10" r="10"/><circle cx="130" cy="10" r="10"/>',
1894         '<path id="eye" class="lnft" style="fill:#000;stroke-linejoin:round" d="M10.4-18v9.6V-18.1zm-17.7 7.7 6.2 7.3-6.2-7.3zm35.3 0-6.2 7.3 6.2-7.3zM10.4-3.8C.95-4.2-5.7 7.4-.65 15.3c4.3 8.4 17.7 8.4 22 0 4.6-7.2-.44-17.7-8.8-18.9-1.1-.15z"/><use xlink:href="#eye" transform="translate(120)"/>',
1895         '<g id="eye"><circle cx="10" cy="10" r="30"/><circle cx="25" cy="5" r="8" fill="#fff"/><circle cx="-8" cy="20" r="4" fill="#fff"/></g><use xlink:href="#eye" transform="translate(120)"/>',
1896         '<g id="eye"><circle cx="10" cy="10" r="30"/><circle cx="10" cy="10" r="24" class="wlrt"/></g><use xlink:href="#eye" transform="translate(120)"/>',
1897         '<rect x="24" y="-18" width="16" height="48" ry="8"/><rect x="100" y="-18" width="16" height="48" ry="8"/>', 
1898         '<g class="lnrt"><path d="M40 10 A10 10 10 10 0 13 10"/><path d="M140 11 A10 10 10 10 100 12 10"/></g>',
1899         '<path class="lnrt" d="M-5 0h50M90 0h50"/><circle cx="28" cy="12" r="13"/><circle cx="123" cy="12" r="13"/>', 
1900         '<path class="lnrt" d="m-12 18 25-36m0 0 25 36m62 0 25-36m0 0 25 36"/>', 
1901         '<path d="m0-18 42 42M0 24l42-42m54 0 42 42m-42 0 42-42" class="lnrt"/>', 
1902         '<path stroke="#000" class="th" d="M-5-30 44-6m63 0 48-24"/><circle cx="22" cy="12" r="13"/><circle cx="127" cy="12" r="13"/>',
1903         '<path class="lnrt" d="m-6 -16 40 24m0 0 -40 24m152 0 -40 -24m0 0 40 -24"/>',
1904         '<path id="eye" d="M13.3 36.3C-1.7 38.4-13 19.4-4 7.2c5-8.9 21-12.4 25.7-1.3 3.7 7.4-3.6 17.9-11.9 15.7-4-1.6-2.8-8.1 1.4-8.3 5.4-1.3.38-8.7-3.5-4.9C1.1 10.8-.35 20.5 4.9 25c4 3.9 10.4 3.1 14.8.4C31.5 19.3 31.1-.1 18.4-5.2 3-12-14.9 3.7-12.7 19.7c.7 5.5-8.4 6.3-8.7.8-2.7-21.2 19.5-41.4 40.3-34.9C37.1-9.6 43.1 15.8 29.8 28.5c-4.3 4.5-10.2 7.3-16.4 7.8Z"/><use xlink:href="#eye" transform="rotate(180 70 10)"/>',
1905         '<path d="M10.2-17.8c-7.5-.17-14.8 2-21.4 5.6-6.8 3.4-12.6 8.8-16.1 15.6-1.6 3.1.7 6.3 1.8 9.2 2.8 5.2 5.7 10.7 10.6 14.3 2 .8-.9-3.5-1.2-4.7-2.4-4.9-4.3-10-5.6-15.2 3.8-5 7.8-10 13.3-13.2 1.5-1.3 4.4-2.4 2.9.7-3.1 11.2-2.5 24.2 4.3 34 .8 2 5.2 4.3 4 6.1-2.2.6-1.6 1.5.3 1.2 8.9-.2 17.7-.5 26.9-1.3 3.3-.8-2.9-.9-3.7-1.4 2.4-3.6 5.3-7 6.6-11.2 3.2-8.5 3.5-17.9 1.2-26.6 2.2-.3 5.2 2.8 7.5 4.1 1.7.6 4.7 4.8 5.7 3.2-3.4-9-12.2-14.5-22.8-17.7-5.1-2-10.7-2.5-16.1-2.5ZM4.8 6.6c-.5 5.4 1.8 12.1 7.4 13.8 4.9 1.4 9.3-3 10.5-7.4 1.5-2.4-1-7.7 3.3-6.2 2.9.3 7.5.7 6.5 4.9-.7 6.6-3.3 13-7.7 18-1 .9-1.9 2.1-3 2.8l-14.9.7c-3.4-3.2-6.5-6.7-8.3-11-1.7-4-3.2-8.3-2.9-12.7 1.2-3.3 6.5-1.7 9.2-3Z" id="eye"/><use xlink:href="#eye" transform="matrix(-1 0 0 1 142 0)"/>',
1906         '<g fill="#f3322c"><path d="M-42 -3H96V7H-32V21H-42"/><g id="eye"><path fill="#fff" d="M-10 -23H40V27H-10z" stroke="#f3322c" stroke-width="10"/><path fill="#000" d="M15 -18H35V22H15z"/></g><use xlink:href="#eye" x="108"/></g>'
1907     ]; 
1908     string[14] private _eyeIds = [
1909         "tiny",
1910         "lashes",
1911         "bubble",
1912         "froyo",
1913         "socket",
1914         "chuffed",
1915         "displeased",
1916         "kitty", 
1917         "deceased", 
1918         "angry",
1919         "embarrassed",
1920         "dizzy",
1921         "anime",
1922         "nounish"
1923     ];
1924 
1925     string[5] private _cheeks = [
1926         '', 
1927         '<g fill="pink"><ellipse cx="10" cy="60" rx="20" ry="10"/><ellipse cx="130" cy="60" rx="20" ry="10"/></g>', 
1928         '<path d="m15 6 10 12a12.8 12.8 0 1 1-20 0L15 6z" fill="#8af" transform="rotate(5 -432.172 -87.711)"/>', 
1929         '<path d="m15 6 10 12a12.8 12.8 0 1 1-20 0L15 6z" fill="none" stroke="black" stroke-width="3" transform="rotate(5 -432.172 -87.711)"/>',
1930         '<path id="chk" fill="#faf" d="M-9.5 24c.6-3.9 5-3.9 6.8-1.6 1.9-2.3 6.3-2.2 6.8 1.6.5 3.4-4 6.2-6.8 8.1-2.8-1.8-7.4-4.6-6.8-8.1z" transform="matrix(2 0 0 2.4 0 0)"/><use xlink:href="#chk" transform="translate(148)"/>'
1931     ]; 
1932     string[5] private _cheekIds = [
1933         "plain",
1934         "pink",
1935         "tear",
1936         "tattoo",
1937         "hearts"
1938     ]; 
1939 
1940     string[12] private _mouths = [
1941         '<path d="M39,100 a1,1 0 0,0 60,0"/>',
1942         '<path d="m39 116 61-0" class="lnrt"/>',
1943         '<path d="M-99 -124a1 .9 0 0 0 60 0" class="lnrt" transform="rotate(180)"/>',
1944         '<path d="M39,100 a1,0.9 0 0,0 60,0" class="lnrt"/>', 
1945         '<g class="lnrt"><path d="M37 108a1 .7 0 0 0 62 0"/><path d="M-31 109a1 .2 0 0 0 20 0" transform="rotate(-30)"/></g>',
1946         '<path d="m27 120 14-10 14 10 14-10 14 10 14-10 14 10" class="lnrt"/>', 
1947         '<ellipse cx="69" cy="114" rx="18" ry="24"/>',
1948         '<path d="M35 127c-5.2-5.8-5.5-15.6-.6-22.5 4.5-6.3 10.3-6.4 22.2-.3 11.4 5.9 15.9 5.9 25.8.02 9.6-5.7 15.1-6 19.6-1 5 5.6 6 12.7 2.9 20.1-3.8 9-9 10-21 3.9-12.3-6-17-6-28.7-.2-11.3 5.9-14.6 5.9-19.8.07z"/>',
1949         '<path d="M29,105 a1,1 0 0,0 40,0M70,105 a1,1 0 0,0 40,0" class="lnrt"/>', 
1950         '<path d="M66,120 a0.6,0.6 0 0,0 0,-20M66,140 a1.2,1 0 0,0 0,-20" class="lnrt tn"/>',
1951         '<g class="lnrt"><path d="M60,128 a0.3,0.5 0 0,0 28,-3" fill="pink" class="tn"/><path d="M36,110 a0.99,0.5 0 0,0 65,0"/></g>',
1952         '<path d="M39,100 a1,1 0 0,0 60,0"/><path fill="#fff" d="M58 103H68V116H58M70 103H80V116H70"/>'
1953     ]; 
1954     string[12] private _mouthIds = [
1955         "happy",
1956         "uncertain",
1957         "sad",
1958         "elated",
1959         "chuffed",
1960         "angry", 
1961         "shocked",
1962         "disgusted",
1963         "goopy",
1964         "kissy",
1965         "playful",
1966         "toothy"
1967     ]; 
1968 
1969     string[6] private _accessories = [
1970         '',
1971         '<path id="ac" d="m60,68c-12.4,0.9 -12.3,13.7 -29.3,12.3 7.3,13.5 24.4,13.4 34.3,6.8 9.8,-6.7 4.8,-19.7 -5,-19z"/><use xlink:href="#ac" transform="scale(-1,1),translate(-139)"/>',
1972         '<path fill="red" stroke="red" stroke-width="7" stroke-linejoin="round" d="m-44-82 20 15 20-15v30l-20-15-20 15z"/><rect x="-34.5" y="-77.5" width="21" height="21" rx="4" fill="red" stroke="#fff" stroke-width="2"/>',
1973         '<path d="M-12 -53c-3.7-2.1-6.1-6.2-6.1-10.6 0-4.4 2.3-8.5 6.1-10.7m-37.7 0c3.7 2.1 6.1 6.2 6.1 10.6 0 4.4-2.3 8.5-6.1 10.7m8.2 8.2c2.1-3.7 6.2-6.1 10.6-6.1 4.4 0 8.5 2.3 10.7 6.1m0-37.7c-2.1 3.7-6.2 6.1-10.6 6.1-4.4 0-8.5-2.3-10.7-6.1" class="lnrt tn"/>',
1974         '<path d="m2.5 10.8 1.5.5.4 1.6.4-1.6 1.5-.5-1.5-.5-.4-1.5-.4 1.5zM.5 3.5l2.1.7.6 2.2.6-2.2 2.1-.7-2.1-.7L3.2.7l-.6 2.2zm8.1-2L7.6 5.3l-2.6 1.1 2.6 1.1 1 3.8L9.7 7.4l2.5-1.1-2.5-1.1z" fill="#ffc502" transform="matrix(4.5 0 0 4.5 -92 -68)"/>',
1975         '<g class="lnrt tn" transform="matrix(.39878 -.01397 .035 .4 -150 -158)"><clipPath id="clp"><path d="M220 190h30v54h-30z"/></clipPath><ellipse id="b" cx="250" cy="217" rx="25" ry="27" fill="#f8b"/><use transform="rotate(60 250 250)" xlink:href="#b"/><use transform="rotate(120 250 250)" xlink:href="#b"/><use transform="rotate(180 250 250)" xlink:href="#b"/><use transform="rotate(240 250 250)" xlink:href="#b"/><use transform="rotate(300 250 250)" xlink:href="#b"/><use xlink:href="#b" clip-path="url(#clp)"/><circle cx="250" cy="250" r="18" fill="#fdc"/></g>'
1976     ]; 
1977     string[6] private _accessoryIds = [
1978         "none",
1979         "mustache",
1980         "bow",
1981         "pop",
1982         "sparkle",
1983         "flower"
1984     ]; 
1985 
1986     string[3] private _filters = [
1987         '', 
1988         '<feTurbulence baseFrequency="0" type="fractalNoise" stitchTiles="noStitch"><animate id="wvy" attributeName="baseFrequency" dur="6s" begin="1.5s;wvy.end+1.5s" values="0;0.03;0" keyTimes="0;0.5;1" easing="ease-in-out"/></feTurbulence><feDisplacementMap in="SourceGraphic" scale="14"/>',
1989         '<feTurbulence baseFrequency="0.6" type="fractalNoise"/><feDisplacementMap in="SourceGraphic" scale="0"><animate id="gltch" attributeName="scale" dur="2.5s" begin="1.5s;gltch.end+3.5s" values="36.7;58.8;36.9;15;13.3;47.3;58.2;21.6;46.5;40.2;35.8;36.1;42.7;32.2;46.6;33.7;17.3;52.1;30.8;40.4;44;36.2;16.2;20;15.7;50.9;30.8"/></feDisplacementMap>'
1990     ]; 
1991     string[3] private _filterIds = ["none", "wavy", "glitchy"]; 
1992 
1993     string[3] private _licenses = ["ARR", "CC BY-NC", "CC0"]; 
1994     
1995     function getLicense(uint256 id) public view returns (string memory) { 
1996         require(_exists(id)); 
1997         uint256 licenseId = _chubFlags[id] % 10; // 0, 1 or 2
1998         if(licenseId > 2) { licenseId = 2; /* this should never happen */ }
1999         return _licenses[licenseId]; 
2000     }
2001 
2002     function usePng(uint256 id) public view returns (bool) { 
2003         require(_exists(id)); 
2004         return _chubFlags[id] > 9; 
2005     }
2006 
2007     struct chubData { 
2008         uint8 bgColorIndex; 
2009         uint8 earsIndex; 
2010         uint8 hatIndex; 
2011         uint8 eyesIndex; 
2012         uint8 cheeksIndex; 
2013         uint8 mouthIndex; 
2014         uint8 accessoryIndex; 
2015         uint8 filterIndex; 
2016         uint8 licenseIndex; 
2017         bool shimmer; 
2018     }
2019 
2020     function makeChub(uint256 id) internal view returns (chubData memory) {
2021         chubData memory chub;
2022 
2023         // random background color
2024         uint256 rand = uint256(keccak256(abi.encodePacked(id, address(this), "1"))) % _bgColors.length;
2025         chub.bgColorIndex = uint8(rand); 
2026 
2027         // random ears
2028         rand = uint256(keccak256(abi.encodePacked(id, address(this), "2"))) % 10;
2029         if(rand >= _ears.length) { rand = 0; } 
2030         chub.earsIndex = uint8(rand); 
2031 
2032         // random hats
2033         rand = uint256(keccak256(abi.encodePacked(id, address(this), "3"))) % 12;
2034         if(rand >= _hats.length) { rand = 0; }
2035         chub.hatIndex = uint8(rand); 
2036 
2037         // random eyes 
2038         rand = uint256(keccak256(abi.encodePacked(id, address(this), "4"))) % _eyes.length;
2039         chub.eyesIndex = uint8(rand); 
2040 
2041         // random cheeks 
2042         rand = uint256(keccak256(abi.encodePacked(id, address(this), "5"))) % 20;
2043         if(rand >= _cheeks.length) { rand = 0; }
2044         chub.cheeksIndex = uint8(rand); 
2045 
2046         // random mouths
2047         rand = uint256(keccak256(abi.encodePacked(id, address(this), "6"))) % _mouths.length;
2048         chub.mouthIndex = uint8(rand); 
2049 
2050         // random accessories 
2051         rand = uint256(keccak256(abi.encodePacked(id, address(this), "7"))) % 24; 
2052         if(rand >= _accessories.length) { rand = 0; }
2053         chub.accessoryIndex = uint8(rand); 
2054 
2055         // random filters 
2056         rand = uint256(keccak256(abi.encodePacked(id, address(this), "8"))) % 100;
2057         if(rand >= _filters.length) { rand = 0; }
2058         chub.filterIndex = uint8(rand); 
2059 
2060         chub.licenseIndex = _chubFlags[id] % 10; // 0, 1 or 2
2061         if(chub.licenseIndex > 2) { chub.licenseIndex = 2; /* this should never happen */ }
2062 
2063         // random shimmer 
2064         rand = uint256(keccak256(abi.encodePacked(id, address(this), "9"))) % 16;
2065         chub.shimmer = ( rand < 1 ); 
2066 
2067         return chub; 
2068     }
2069 
2070     function makeSVG(chubData memory chub) internal view returns (string memory) {
2071         string memory filterUrl = ''; 
2072         string memory filter = ''; 
2073         if(chub.filterIndex > 0) { 
2074             filterUrl = string.concat(" filter='url(#",_filterIds[chub.filterIndex],")'"); 
2075             filter = string.concat('<filter id="',_filterIds[chub.filterIndex],'" x="-50%" y="-50%" width="200%" height="200%">',_filters[chub.filterIndex],'</filter>'); 
2076         }
2077         string memory bgfilter = ''; 
2078         if(chub.shimmer) { 
2079             bgfilter = '<path d="M0 0H600V600H0" filter="url(#fbg)"/>'; 
2080             filter = string.concat(filter,'<filter x="0" y="0" width="100%" height="100%" id="fbg"><feTurbulence baseFrequency="0.0024 0.0036" numOctaves="16" seed="18"/></filter>'); 
2081         }
2082         string memory output = "<svg width='600' height='600' viewBox='0 0 600 600' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'><style>.lnft,.lnrt{stroke:#000;stroke-linecap:round}.lnft{fill:gray;stroke-width:8;}.lnrt{fill:none;stroke-width:7;stroke-linejoin:bezel}.th{stroke-width:12}.tn{stroke-width:4}.wlrt{stroke:#fff;stroke-width:3}text{font-family:'Comic Sans MS','Comic Sans','Chalkboard SE','Comic Neue',cursive;font-size:12pt}</style><defs>"; 
2083         output = string.concat(output,filter,"</defs><path d='M0 0H600V600H0' fill='#",_bgColors[chub.bgColorIndex],"'/>",bgfilter,"<g id='chub' cursor='pointer'",filterUrl,"><g fill='#fff'><ellipse cx='300' cy='460' rx='160' ry='50'/><path d='M140 140h320v320H140z'/></g><ellipse cx='300' cy='140' rx='160' ry='50' fill='#F8F4F4'/><g id='face' transform='rotate(-5 3422.335 -2819.49)'>"); 
2084         return string.concat(output,_ears[chub.earsIndex],_hats[chub.hatIndex],_eyes[chub.eyesIndex],_mouths[chub.mouthIndex],_cheeks[chub.cheeksIndex],_accessories[chub.accessoryIndex],"</g><animateMotion path='M0,0 -3,-9 0,-18 6,-9 2,0 0,4z' keyPoints='0;0.1875;0.375;0.5625;0.75;0.9;1' keyTimes='0;0.18;0.37;0.58;0.72;0.87;1' dur='0.6s' begin='click'/></g></svg>"); 
2085         
2086     }
2087 
2088     function makeTrait(string memory tt, string memory tv) internal pure returns (string memory) { 
2089         return string.concat('{"trait_type":"',tt,'","value":"',tv,'"}'); 
2090     }
2091 
2092     function makeTraits(chubData memory chub) internal view returns (string memory) { 
2093         string memory shimmer = chub.shimmer ? unicode"✨" : ""; 
2094         shimmer = string.concat(_bgColorIds[chub.bgColorIndex],shimmer); 
2095         return string.concat('[',makeTrait("BG Color",shimmer),',',makeTrait("Ears",_earIds[chub.earsIndex]),',',makeTrait("Hat",_hatIds[chub.hatIndex]),',',makeTrait("Eyes",_eyeIds[chub.eyesIndex]),',',makeTrait("Mouth",_mouthIds[chub.mouthIndex]),',',makeTrait("Cheeks",_cheekIds[chub.cheeksIndex]),',',makeTrait("Accessory",_accessoryIds[chub.accessoryIndex]),',',makeTrait("Filter",_filterIds[chub.filterIndex]),',',makeTrait("License",_licenses[chub.licenseIndex]),']'); 
2096     }
2097 
2098     function tokenSVG(uint256 tokenId) external view returns (string memory) {
2099         require(_exists(tokenId)); 
2100 
2101         return makeSVG(makeChub(tokenId)); 
2102     }
2103 
2104     function tokenTraits(uint256 tokenId) external view returns (string memory) { 
2105         require(_exists(tokenId)); 
2106 
2107         return makeTraits(makeChub(tokenId)); 
2108     }
2109 
2110     function tokenURI(uint256 tokenId) override public view returns (string memory) {
2111         require(_exists(tokenId)); 
2112         
2113         chubData memory chub = makeChub(tokenId);
2114 
2115         string memory output; 
2116         if(usePng(tokenId) && _pngsAvailable) {
2117             output = string.concat(_baseTokenURI, _toString(tokenId), ".png"); 
2118         }
2119         else { 
2120             output = string.concat("data:image/svg+xml;base64,", Base64.encode(bytes(makeSVG(chub)))); 
2121         }
2122 
2123         output = string.concat('{"name":"Chublin #',_toString(tokenId),'", "description":"A Chublin born of the blockchain.","attributes":',makeTraits(chub),', "image":"', output, '"}'); 
2124         return string.concat('data:application/json;base64,',Base64.encode(bytes(output))); 
2125     }
2126 
2127     function maxSupply() public view returns (uint16) {
2128         return _maxSupply;
2129     }
2130 
2131     function reduceSupply(uint16 value) external onlyOwner {
2132         require(totalSupply() < value && value < maxSupply());
2133         _maxSupply = value;
2134     }
2135 
2136     function setBaseURI(string calldata baseURI) external onlyOwner {
2137         _baseTokenURI = baseURI;
2138     }
2139 
2140     function withdrawFunds() external onlyOwner {
2141         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2142         require(success);
2143     }
2144 
2145     function pngsAvailable() external view returns (bool) {
2146         return _pngsAvailable;
2147     }
2148 
2149     function togglePNGsAvailable() external onlyOwner {
2150         _pngsAvailable = !_pngsAvailable;
2151     }
2152 
2153     function toggleOnChainArt(uint256 tokenId) external returns(bool){
2154         require(ownerOf(tokenId) == msg.sender);
2155         
2156         if(usePng(tokenId)) { 
2157             unchecked {
2158                 _chubFlags[tokenId] -= 10; 
2159             }
2160         }
2161         else { 
2162             unchecked {
2163                 _chubFlags[tokenId] += 10; 
2164             }
2165         }
2166 
2167         return usePng(tokenId); 
2168     }
2169 
2170     function modifyLicense(uint256 tokenId, uint8 level) external returns(string memory){
2171         require(ownerOf(tokenId) == msg.sender);
2172         require(level == 1 || level == 2);
2173         uint8 currentLicense = _chubFlags[tokenId] % 10; // 0, 1 or 2
2174 
2175         if(currentLicense == 0) {
2176             // if current level is 0, you can set it to 1 or 2
2177             unchecked {
2178                 _chubFlags[tokenId] += level;
2179             }
2180             return _licenses[level]; 
2181         }
2182         else if(currentLicense == 1 && level == 2) {
2183             // if current level is 1 or 2, you can set it to 2
2184             unchecked { 
2185                 _chubFlags[tokenId] += 1;
2186             }
2187             return _licenses[level]; 
2188         }
2189         revert(); 
2190     }
2191     // thank you for reading my contract 
2192 }