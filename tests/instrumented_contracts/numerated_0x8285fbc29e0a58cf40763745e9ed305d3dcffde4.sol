1 // SPDX-License-Identifier: MIXED
2 
3 // Sources flattened with hardhat v2.13.0 https://hardhat.org
4 
5 // File lib/ERC721A/contracts/IERC721A.sol
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
28      * Cannot query the balance for the zero address.
29      */
30     error BalanceQueryForZeroAddress();
31 
32     /**
33      * Cannot mint to the zero address.
34      */
35     error MintToZeroAddress();
36 
37     /**
38      * The quantity of tokens minted must be more than zero.
39      */
40     error MintZeroQuantity();
41 
42     /**
43      * The token does not exist.
44      */
45     error OwnerQueryForNonexistentToken();
46 
47     /**
48      * The caller must own the token or be an approved operator.
49      */
50     error TransferCallerNotOwnerNorApproved();
51 
52     /**
53      * The token must be owned by `from`.
54      */
55     error TransferFromIncorrectOwner();
56 
57     /**
58      * Cannot safely transfer to a contract that does not implement the
59      * ERC721Receiver interface.
60      */
61     error TransferToNonERC721ReceiverImplementer();
62 
63     /**
64      * Cannot transfer to the zero address.
65      */
66     error TransferToZeroAddress();
67 
68     /**
69      * The token does not exist.
70      */
71     error URIQueryForNonexistentToken();
72 
73     /**
74      * The `quantity` minted with ERC2309 exceeds the safety limit.
75      */
76     error MintERC2309QuantityExceedsLimit();
77 
78     /**
79      * The `extraData` cannot be set on an unintialized ownership slot.
80      */
81     error OwnershipNotInitializedForExtraData();
82 
83     // =============================================================
84     //                            STRUCTS
85     // =============================================================
86 
87     struct TokenOwnership {
88         // The address of the owner.
89         address addr;
90         // Stores the start time of ownership with minimal overhead for tokenomics.
91         uint64 startTimestamp;
92         // Whether the token has been burned.
93         bool burned;
94         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
95         uint24 extraData;
96     }
97 
98     // =============================================================
99     //                         TOKEN COUNTERS
100     // =============================================================
101 
102     /**
103      * @dev Returns the total number of tokens in existence.
104      * Burned tokens will reduce the count.
105      * To get the total number of tokens minted, please see {_totalMinted}.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     // =============================================================
110     //                            IERC165
111     // =============================================================
112 
113     /**
114      * @dev Returns true if this contract implements the interface defined by
115      * `interfaceId`. See the corresponding
116      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
117      * to learn more about how these ids are created.
118      *
119      * This function call must use less than 30000 gas.
120      */
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122 
123     // =============================================================
124     //                            IERC721
125     // =============================================================
126 
127     /**
128      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
134      */
135     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables or disables
139      * (`approved`) `operator` to manage all of its assets.
140      */
141     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
142 
143     /**
144      * @dev Returns the number of tokens in `owner`'s account.
145      */
146     function balanceOf(address owner) external view returns (uint256 balance);
147 
148     /**
149      * @dev Returns the owner of the `tokenId` token.
150      *
151      * Requirements:
152      *
153      * - `tokenId` must exist.
154      */
155     function ownerOf(uint256 tokenId) external view returns (address owner);
156 
157     /**
158      * @dev Safely transfers `tokenId` token from `from` to `to`,
159      * checking first that contract recipients are aware of the ERC721 protocol
160      * to prevent tokens from being forever locked.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be have been allowed to move
168      * this token by either {approve} or {setApprovalForAll}.
169      * - If `to` refers to a smart contract, it must implement
170      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 
181     /**
182      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external;
189 
190     /**
191      * @dev Transfers `tokenId` from `from` to `to`.
192      *
193      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
194      * whenever possible.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token
202      * by either {approve} or {setApprovalForAll}.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transferFrom(
207         address from,
208         address to,
209         uint256 tokenId
210     ) external;
211 
212     /**
213      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
214      * The approval is cleared when the token is transferred.
215      *
216      * Only a single account can be approved at a time, so approving the
217      * zero address clears previous approvals.
218      *
219      * Requirements:
220      *
221      * - The caller must own the token or be an approved operator.
222      * - `tokenId` must exist.
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address to, uint256 tokenId) external;
227 
228     /**
229      * @dev Approve or remove `operator` as an operator for the caller.
230      * Operators can call {transferFrom} or {safeTransferFrom}
231      * for any token owned by the caller.
232      *
233      * Requirements:
234      *
235      * - The `operator` cannot be the caller.
236      *
237      * Emits an {ApprovalForAll} event.
238      */
239     function setApprovalForAll(address operator, bool _approved) external;
240 
241     /**
242      * @dev Returns the account approved for `tokenId` token.
243      *
244      * Requirements:
245      *
246      * - `tokenId` must exist.
247      */
248     function getApproved(uint256 tokenId) external view returns (address operator);
249 
250     /**
251      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
252      *
253      * See {setApprovalForAll}.
254      */
255     function isApprovedForAll(address owner, address operator) external view returns (bool);
256 
257     // =============================================================
258     //                        IERC721Metadata
259     // =============================================================
260 
261     /**
262      * @dev Returns the token collection name.
263      */
264     function name() external view returns (string memory);
265 
266     /**
267      * @dev Returns the token collection symbol.
268      */
269     function symbol() external view returns (string memory);
270 
271     /**
272      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
273      */
274     function tokenURI(uint256 tokenId) external view returns (string memory);
275 
276     // =============================================================
277     //                           IERC2309
278     // =============================================================
279 
280     /**
281      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
282      * (inclusive) is transferred from `from` to `to`, as defined in the
283      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
284      *
285      * See {_mintERC2309} for more details.
286      */
287     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
288 }
289 
290 
291 // File lib/ERC721A/contracts/ERC721A.sol
292 
293 // License-Identifier: MIT
294 // ERC721A Contracts v4.2.2
295 // Creator: Chiru Labs
296 
297 pragma solidity ^0.8.4;
298 
299 /**
300  * @dev Interface of ERC721 token receiver.
301  */
302 interface ERC721A__IERC721Receiver {
303     function onERC721Received(
304         address operator,
305         address from,
306         uint256 tokenId,
307         bytes calldata data
308     ) external returns (bytes4);
309 }
310 
311 /**
312  * @title ERC721A
313  *
314  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
315  * Non-Fungible Token Standard, including the Metadata extension.
316  * Optimized for lower gas during batch mints.
317  *
318  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
319  * starting from `_startTokenId()`.
320  *
321  * Assumptions:
322  *
323  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
324  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
325  */
326 contract ERC721A is IERC721A {
327     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
328     struct TokenApprovalRef {
329         address value;
330     }
331 
332     // =============================================================
333     //                           CONSTANTS
334     // =============================================================
335 
336     // Mask of an entry in packed address data.
337     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
338 
339     // The bit position of `numberMinted` in packed address data.
340     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
341 
342     // The bit position of `numberBurned` in packed address data.
343     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
344 
345     // The bit position of `aux` in packed address data.
346     uint256 private constant _BITPOS_AUX = 192;
347 
348     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
349     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
350 
351     // The bit position of `startTimestamp` in packed ownership.
352     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
353 
354     // The bit mask of the `burned` bit in packed ownership.
355     uint256 private constant _BITMASK_BURNED = 1 << 224;
356 
357     // The bit position of the `nextInitialized` bit in packed ownership.
358     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
359 
360     // The bit mask of the `nextInitialized` bit in packed ownership.
361     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
362 
363     // The bit position of `extraData` in packed ownership.
364     uint256 private constant _BITPOS_EXTRA_DATA = 232;
365 
366     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
367     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
368 
369     // The mask of the lower 160 bits for addresses.
370     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
371 
372     // The maximum `quantity` that can be minted with {_mintERC2309}.
373     // This limit is to prevent overflows on the address data entries.
374     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
375     // is required to cause an overflow, which is unrealistic.
376     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
377 
378     // The `Transfer` event signature is given by:
379     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
380     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
381         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
382 
383     // =============================================================
384     //                            STORAGE
385     // =============================================================
386 
387     // The next token ID to be minted.
388     uint256 private _currentIndex;
389 
390     // The number of tokens burned.
391     uint256 private _burnCounter;
392 
393     // Token name
394     string private _name;
395 
396     // Token symbol
397     string private _symbol;
398 
399     // Mapping from token ID to ownership details
400     // An empty struct value does not necessarily mean the token is unowned.
401     // See {_packedOwnershipOf} implementation for details.
402     //
403     // Bits Layout:
404     // - [0..159]   `addr`
405     // - [160..223] `startTimestamp`
406     // - [224]      `burned`
407     // - [225]      `nextInitialized`
408     // - [232..255] `extraData`
409     mapping(uint256 => uint256) private _packedOwnerships;
410 
411     // Mapping owner address to address data.
412     //
413     // Bits Layout:
414     // - [0..63]    `balance`
415     // - [64..127]  `numberMinted`
416     // - [128..191] `numberBurned`
417     // - [192..255] `aux`
418     mapping(address => uint256) private _packedAddressData;
419 
420     // Mapping from token ID to approved address.
421     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
422 
423     // Mapping from owner to operator approvals
424     mapping(address => mapping(address => bool)) private _operatorApprovals;
425 
426     // =============================================================
427     //                          CONSTRUCTOR
428     // =============================================================
429 
430     constructor(string memory name_, string memory symbol_) {
431         _name = name_;
432         _symbol = symbol_;
433         _currentIndex = _startTokenId();
434     }
435 
436     // =============================================================
437     //                   TOKEN COUNTING OPERATIONS
438     // =============================================================
439 
440     /**
441      * @dev Returns the starting token ID.
442      * To change the starting token ID, please override this function.
443      */
444     function _startTokenId() internal view virtual returns (uint256) {
445         return 0;
446     }
447 
448     /**
449      * @dev Returns the next token ID to be minted.
450      */
451     function _nextTokenId() internal view virtual returns (uint256) {
452         return _currentIndex;
453     }
454 
455     /**
456      * @dev Returns the total number of tokens in existence.
457      * Burned tokens will reduce the count.
458      * To get the total number of tokens minted, please see {_totalMinted}.
459      */
460     function totalSupply() public view virtual override returns (uint256) {
461         // Counter underflow is impossible as _burnCounter cannot be incremented
462         // more than `_currentIndex - _startTokenId()` times.
463         unchecked {
464             return _currentIndex - _burnCounter - _startTokenId();
465         }
466     }
467 
468     /**
469      * @dev Returns the total amount of tokens minted in the contract.
470      */
471     function _totalMinted() internal view virtual returns (uint256) {
472         // Counter underflow is impossible as `_currentIndex` does not decrement,
473         // and it is initialized to `_startTokenId()`.
474         unchecked {
475             return _currentIndex - _startTokenId();
476         }
477     }
478 
479     /**
480      * @dev Returns the total number of tokens burned.
481      */
482     function _totalBurned() internal view virtual returns (uint256) {
483         return _burnCounter;
484     }
485 
486     // =============================================================
487     //                    ADDRESS DATA OPERATIONS
488     // =============================================================
489 
490     /**
491      * @dev Returns the number of tokens in `owner`'s account.
492      */
493     function balanceOf(address owner) public view virtual override returns (uint256) {
494         if (owner == address(0)) revert BalanceQueryForZeroAddress();
495         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
496     }
497 
498     /**
499      * Returns the number of tokens minted by `owner`.
500      */
501     function _numberMinted(address owner) internal view returns (uint256) {
502         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
503     }
504 
505     /**
506      * Returns the number of tokens burned by or on behalf of `owner`.
507      */
508     function _numberBurned(address owner) internal view returns (uint256) {
509         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
510     }
511 
512     /**
513      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
514      */
515     function _getAux(address owner) internal view returns (uint64) {
516         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
517     }
518 
519     /**
520      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
521      * If there are multiple variables, please pack them into a uint64.
522      */
523     function _setAux(address owner, uint64 aux) internal virtual {
524         uint256 packed = _packedAddressData[owner];
525         uint256 auxCasted;
526         // Cast `aux` with assembly to avoid redundant masking.
527         assembly {
528             auxCasted := aux
529         }
530         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
531         _packedAddressData[owner] = packed;
532     }
533 
534     // =============================================================
535     //                            IERC165
536     // =============================================================
537 
538     /**
539      * @dev Returns true if this contract implements the interface defined by
540      * `interfaceId`. See the corresponding
541      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
542      * to learn more about how these ids are created.
543      *
544      * This function call must use less than 30000 gas.
545      */
546     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547         // The interface IDs are constants representing the first 4 bytes
548         // of the XOR of all function selectors in the interface.
549         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
550         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
551         return
552             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
553             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
554             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
555     }
556 
557     // =============================================================
558     //                        IERC721Metadata
559     // =============================================================
560 
561     /**
562      * @dev Returns the token collection name.
563      */
564     function name() public view virtual override returns (string memory) {
565         return _name;
566     }
567 
568     /**
569      * @dev Returns the token collection symbol.
570      */
571     function symbol() public view virtual override returns (string memory) {
572         return _symbol;
573     }
574 
575     /**
576      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
577      */
578     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
579         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
580 
581         string memory baseURI = _baseURI();
582         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
583     }
584 
585     /**
586      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
587      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
588      * by default, it can be overridden in child contracts.
589      */
590     function _baseURI() internal view virtual returns (string memory) {
591         return '';
592     }
593 
594     // =============================================================
595     //                     OWNERSHIPS OPERATIONS
596     // =============================================================
597 
598     /**
599      * @dev Returns the owner of the `tokenId` token.
600      *
601      * Requirements:
602      *
603      * - `tokenId` must exist.
604      */
605     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
606         return address(uint160(_packedOwnershipOf(tokenId)));
607     }
608 
609     /**
610      * @dev Gas spent here starts off proportional to the maximum mint batch size.
611      * It gradually moves to O(1) as tokens get transferred around over time.
612      */
613     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
614         return _unpackedOwnership(_packedOwnershipOf(tokenId));
615     }
616 
617     /**
618      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
619      */
620     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
621         return _unpackedOwnership(_packedOwnerships[index]);
622     }
623 
624     /**
625      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
626      */
627     function _initializeOwnershipAt(uint256 index) internal virtual {
628         if (_packedOwnerships[index] == 0) {
629             _packedOwnerships[index] = _packedOwnershipOf(index);
630         }
631     }
632 
633     /**
634      * Returns the packed ownership data of `tokenId`.
635      */
636     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
637         uint256 curr = tokenId;
638 
639         unchecked {
640             if (_startTokenId() <= curr)
641                 if (curr < _currentIndex) {
642                     uint256 packed = _packedOwnerships[curr];
643                     // If not burned.
644                     if (packed & _BITMASK_BURNED == 0) {
645                         // Invariant:
646                         // There will always be an initialized ownership slot
647                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
648                         // before an unintialized ownership slot
649                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
650                         // Hence, `curr` will not underflow.
651                         //
652                         // We can directly compare the packed value.
653                         // If the address is zero, packed will be zero.
654                         while (packed == 0) {
655                             packed = _packedOwnerships[--curr];
656                         }
657                         return packed;
658                     }
659                 }
660         }
661         revert OwnerQueryForNonexistentToken();
662     }
663 
664     /**
665      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
666      */
667     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
668         ownership.addr = address(uint160(packed));
669         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
670         ownership.burned = packed & _BITMASK_BURNED != 0;
671         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
672     }
673 
674     /**
675      * @dev Packs ownership data into a single uint256.
676      */
677     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
678         assembly {
679             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
680             owner := and(owner, _BITMASK_ADDRESS)
681             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
682             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
683         }
684     }
685 
686     /**
687      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
688      */
689     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
690         // For branchless setting of the `nextInitialized` flag.
691         assembly {
692             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
693             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
694         }
695     }
696 
697     // =============================================================
698     //                      APPROVAL OPERATIONS
699     // =============================================================
700 
701     /**
702      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
703      * The approval is cleared when the token is transferred.
704      *
705      * Only a single account can be approved at a time, so approving the
706      * zero address clears previous approvals.
707      *
708      * Requirements:
709      *
710      * - The caller must own the token or be an approved operator.
711      * - `tokenId` must exist.
712      *
713      * Emits an {Approval} event.
714      */
715     function approve(address to, uint256 tokenId) public virtual override {
716         address owner = ownerOf(tokenId);
717 
718         if (_msgSenderERC721A() != owner)
719             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
720                 revert ApprovalCallerNotOwnerNorApproved();
721             }
722 
723         _tokenApprovals[tokenId].value = to;
724         emit Approval(owner, to, tokenId);
725     }
726 
727     /**
728      * @dev Returns the account approved for `tokenId` token.
729      *
730      * Requirements:
731      *
732      * - `tokenId` must exist.
733      */
734     function getApproved(uint256 tokenId) public view virtual override returns (address) {
735         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
736 
737         return _tokenApprovals[tokenId].value;
738     }
739 
740     /**
741      * @dev Approve or remove `operator` as an operator for the caller.
742      * Operators can call {transferFrom} or {safeTransferFrom}
743      * for any token owned by the caller.
744      *
745      * Requirements:
746      *
747      * - The `operator` cannot be the caller.
748      *
749      * Emits an {ApprovalForAll} event.
750      */
751     function setApprovalForAll(address operator, bool approved) public virtual override {
752         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
753         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
754     }
755 
756     /**
757      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
758      *
759      * See {setApprovalForAll}.
760      */
761     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
762         return _operatorApprovals[owner][operator];
763     }
764 
765     /**
766      * @dev Returns whether `tokenId` exists.
767      *
768      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
769      *
770      * Tokens start existing when they are minted. See {_mint}.
771      */
772     function _exists(uint256 tokenId) internal view virtual returns (bool) {
773         return
774             _startTokenId() <= tokenId &&
775             tokenId < _currentIndex && // If within bounds,
776             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
777     }
778 
779     /**
780      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
781      */
782     function _isSenderApprovedOrOwner(
783         address approvedAddress,
784         address owner,
785         address msgSender
786     ) private pure returns (bool result) {
787         assembly {
788             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
789             owner := and(owner, _BITMASK_ADDRESS)
790             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
791             msgSender := and(msgSender, _BITMASK_ADDRESS)
792             // `msgSender == owner || msgSender == approvedAddress`.
793             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
794         }
795     }
796 
797     /**
798      * @dev Returns the storage slot and value for the approved address of `tokenId`.
799      */
800     function _getApprovedSlotAndAddress(uint256 tokenId)
801         private
802         view
803         returns (uint256 approvedAddressSlot, address approvedAddress)
804     {
805         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
806         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
807         assembly {
808             approvedAddressSlot := tokenApproval.slot
809             approvedAddress := sload(approvedAddressSlot)
810         }
811     }
812 
813     // =============================================================
814     //                      TRANSFER OPERATIONS
815     // =============================================================
816 
817     /**
818      * @dev Transfers `tokenId` from `from` to `to`.
819      *
820      * Requirements:
821      *
822      * - `from` cannot be the zero address.
823      * - `to` cannot be the zero address.
824      * - `tokenId` token must be owned by `from`.
825      * - If the caller is not `from`, it must be approved to move this token
826      * by either {approve} or {setApprovalForAll}.
827      *
828      * Emits a {Transfer} event.
829      */
830     function transferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) public virtual override {
835         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
836 
837         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
838 
839         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
840 
841         // The nested ifs save around 20+ gas over a compound boolean condition.
842         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
843             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
844 
845         if (to == address(0)) revert TransferToZeroAddress();
846 
847         _beforeTokenTransfers(from, to, tokenId, 1);
848 
849         // Clear approvals from the previous owner.
850         assembly {
851             if approvedAddress {
852                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
853                 sstore(approvedAddressSlot, 0)
854             }
855         }
856 
857         // Underflow of the sender's balance is impossible because we check for
858         // ownership above and the recipient's balance can't realistically overflow.
859         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
860         unchecked {
861             // We can directly increment and decrement the balances.
862             --_packedAddressData[from]; // Updates: `balance -= 1`.
863             ++_packedAddressData[to]; // Updates: `balance += 1`.
864 
865             // Updates:
866             // - `address` to the next owner.
867             // - `startTimestamp` to the timestamp of transfering.
868             // - `burned` to `false`.
869             // - `nextInitialized` to `true`.
870             _packedOwnerships[tokenId] = _packOwnershipData(
871                 to,
872                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
873             );
874 
875             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
876             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
877                 uint256 nextTokenId = tokenId + 1;
878                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
879                 if (_packedOwnerships[nextTokenId] == 0) {
880                     // If the next slot is within bounds.
881                     if (nextTokenId != _currentIndex) {
882                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
883                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
884                     }
885                 }
886             }
887         }
888 
889         emit Transfer(from, to, tokenId);
890         _afterTokenTransfers(from, to, tokenId, 1);
891     }
892 
893     /**
894      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         safeTransferFrom(from, to, tokenId, '');
902     }
903 
904     /**
905      * @dev Safely transfers `tokenId` token from `from` to `to`.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must exist and be owned by `from`.
912      * - If the caller is not `from`, it must be approved to move this token
913      * by either {approve} or {setApprovalForAll}.
914      * - If `to` refers to a smart contract, it must implement
915      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
916      *
917      * Emits a {Transfer} event.
918      */
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes memory _data
924     ) public virtual override {
925         transferFrom(from, to, tokenId);
926         if (to.code.length != 0)
927             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
928                 revert TransferToNonERC721ReceiverImplementer();
929             }
930     }
931 
932     /**
933      * @dev Hook that is called before a set of serially-ordered token IDs
934      * are about to be transferred. This includes minting.
935      * And also called before burning one token.
936      *
937      * `startTokenId` - the first token ID to be transferred.
938      * `quantity` - the amount to be transferred.
939      *
940      * Calling conditions:
941      *
942      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
943      * transferred to `to`.
944      * - When `from` is zero, `tokenId` will be minted for `to`.
945      * - When `to` is zero, `tokenId` will be burned by `from`.
946      * - `from` and `to` are never both zero.
947      */
948     function _beforeTokenTransfers(
949         address from,
950         address to,
951         uint256 startTokenId,
952         uint256 quantity
953     ) internal virtual {}
954 
955     /**
956      * @dev Hook that is called after a set of serially-ordered token IDs
957      * have been transferred. This includes minting.
958      * And also called after one token has been burned.
959      *
960      * `startTokenId` - the first token ID to be transferred.
961      * `quantity` - the amount to be transferred.
962      *
963      * Calling conditions:
964      *
965      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
966      * transferred to `to`.
967      * - When `from` is zero, `tokenId` has been minted for `to`.
968      * - When `to` is zero, `tokenId` has been burned by `from`.
969      * - `from` and `to` are never both zero.
970      */
971     function _afterTokenTransfers(
972         address from,
973         address to,
974         uint256 startTokenId,
975         uint256 quantity
976     ) internal virtual {}
977 
978     /**
979      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
980      *
981      * `from` - Previous owner of the given token ID.
982      * `to` - Target address that will receive the token.
983      * `tokenId` - Token ID to be transferred.
984      * `_data` - Optional data to send along with the call.
985      *
986      * Returns whether the call correctly returned the expected magic value.
987      */
988     function _checkContractOnERC721Received(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) private returns (bool) {
994         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
995             bytes4 retval
996         ) {
997             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
998         } catch (bytes memory reason) {
999             if (reason.length == 0) {
1000                 revert TransferToNonERC721ReceiverImplementer();
1001             } else {
1002                 assembly {
1003                     revert(add(32, reason), mload(reason))
1004                 }
1005             }
1006         }
1007     }
1008 
1009     // =============================================================
1010     //                        MINT OPERATIONS
1011     // =============================================================
1012 
1013     /**
1014      * @dev Mints `quantity` tokens and transfers them to `to`.
1015      *
1016      * Requirements:
1017      *
1018      * - `to` cannot be the zero address.
1019      * - `quantity` must be greater than 0.
1020      *
1021      * Emits a {Transfer} event for each mint.
1022      */
1023     function _mint(address to, uint256 quantity) internal virtual {
1024         uint256 startTokenId = _currentIndex;
1025         if (quantity == 0) revert MintZeroQuantity();
1026 
1027         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1028 
1029         // Overflows are incredibly unrealistic.
1030         // `balance` and `numberMinted` have a maximum limit of 2**64.
1031         // `tokenId` has a maximum limit of 2**256.
1032         unchecked {
1033             // Updates:
1034             // - `balance += quantity`.
1035             // - `numberMinted += quantity`.
1036             //
1037             // We can directly add to the `balance` and `numberMinted`.
1038             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1039 
1040             // Updates:
1041             // - `address` to the owner.
1042             // - `startTimestamp` to the timestamp of minting.
1043             // - `burned` to `false`.
1044             // - `nextInitialized` to `quantity == 1`.
1045             _packedOwnerships[startTokenId] = _packOwnershipData(
1046                 to,
1047                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1048             );
1049 
1050             uint256 toMasked;
1051             uint256 end = startTokenId + quantity;
1052 
1053             // Use assembly to loop and emit the `Transfer` event for gas savings.
1054             // The duplicated `log4` removes an extra check and reduces stack juggling.
1055             // The assembly, together with the surrounding Solidity code, have been
1056             // delicately arranged to nudge the compiler into producing optimized opcodes.
1057             assembly {
1058                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1059                 toMasked := and(to, _BITMASK_ADDRESS)
1060                 // Emit the `Transfer` event.
1061                 log4(
1062                     0, // Start of data (0, since no data).
1063                     0, // End of data (0, since no data).
1064                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1065                     0, // `address(0)`.
1066                     toMasked, // `to`.
1067                     startTokenId // `tokenId`.
1068                 )
1069 
1070                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1071                 // that overflows uint256 will make the loop run out of gas.
1072                 // The compiler will optimize the `iszero` away for performance.
1073                 for {
1074                     let tokenId := add(startTokenId, 1)
1075                 } iszero(eq(tokenId, end)) {
1076                     tokenId := add(tokenId, 1)
1077                 } {
1078                     // Emit the `Transfer` event. Similar to above.
1079                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1080                 }
1081             }
1082             if (toMasked == 0) revert MintToZeroAddress();
1083 
1084             _currentIndex = end;
1085         }
1086         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1087     }
1088 
1089     /**
1090      * @dev Mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * This function is intended for efficient minting only during contract creation.
1093      *
1094      * It emits only one {ConsecutiveTransfer} as defined in
1095      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1096      * instead of a sequence of {Transfer} event(s).
1097      *
1098      * Calling this function outside of contract creation WILL make your contract
1099      * non-compliant with the ERC721 standard.
1100      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1101      * {ConsecutiveTransfer} event is only permissible during contract creation.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `quantity` must be greater than 0.
1107      *
1108      * Emits a {ConsecutiveTransfer} event.
1109      */
1110     function _mintERC2309(address to, uint256 quantity) internal virtual {
1111         uint256 startTokenId = _currentIndex;
1112         if (to == address(0)) revert MintToZeroAddress();
1113         if (quantity == 0) revert MintZeroQuantity();
1114         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1115 
1116         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1117 
1118         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1119         unchecked {
1120             // Updates:
1121             // - `balance += quantity`.
1122             // - `numberMinted += quantity`.
1123             //
1124             // We can directly add to the `balance` and `numberMinted`.
1125             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1126 
1127             // Updates:
1128             // - `address` to the owner.
1129             // - `startTimestamp` to the timestamp of minting.
1130             // - `burned` to `false`.
1131             // - `nextInitialized` to `quantity == 1`.
1132             _packedOwnerships[startTokenId] = _packOwnershipData(
1133                 to,
1134                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1135             );
1136 
1137             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1138 
1139             _currentIndex = startTokenId + quantity;
1140         }
1141         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142     }
1143 
1144     /**
1145      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - If `to` refers to a smart contract, it must implement
1150      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1151      * - `quantity` must be greater than 0.
1152      *
1153      * See {_mint}.
1154      *
1155      * Emits a {Transfer} event for each mint.
1156      */
1157     function _safeMint(
1158         address to,
1159         uint256 quantity,
1160         bytes memory _data
1161     ) internal virtual {
1162         _mint(to, quantity);
1163 
1164         unchecked {
1165             if (to.code.length != 0) {
1166                 uint256 end = _currentIndex;
1167                 uint256 index = end - quantity;
1168                 do {
1169                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1170                         revert TransferToNonERC721ReceiverImplementer();
1171                     }
1172                 } while (index < end);
1173                 // Reentrancy protection.
1174                 if (_currentIndex != end) revert();
1175             }
1176         }
1177     }
1178 
1179     /**
1180      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1181      */
1182     function _safeMint(address to, uint256 quantity) internal virtual {
1183         _safeMint(to, quantity, '');
1184     }
1185 
1186     // =============================================================
1187     //                        BURN OPERATIONS
1188     // =============================================================
1189 
1190     /**
1191      * @dev Equivalent to `_burn(tokenId, false)`.
1192      */
1193     function _burn(uint256 tokenId) internal virtual {
1194         _burn(tokenId, false);
1195     }
1196 
1197     /**
1198      * @dev Destroys `tokenId`.
1199      * The approval is cleared when the token is burned.
1200      *
1201      * Requirements:
1202      *
1203      * - `tokenId` must exist.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1208         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1209 
1210         address from = address(uint160(prevOwnershipPacked));
1211 
1212         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1213 
1214         if (approvalCheck) {
1215             // The nested ifs save around 20+ gas over a compound boolean condition.
1216             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1217                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1218         }
1219 
1220         _beforeTokenTransfers(from, address(0), tokenId, 1);
1221 
1222         // Clear approvals from the previous owner.
1223         assembly {
1224             if approvedAddress {
1225                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1226                 sstore(approvedAddressSlot, 0)
1227             }
1228         }
1229 
1230         // Underflow of the sender's balance is impossible because we check for
1231         // ownership above and the recipient's balance can't realistically overflow.
1232         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1233         unchecked {
1234             // Updates:
1235             // - `balance -= 1`.
1236             // - `numberBurned += 1`.
1237             //
1238             // We can directly decrement the balance, and increment the number burned.
1239             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1240             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1241 
1242             // Updates:
1243             // - `address` to the last owner.
1244             // - `startTimestamp` to the timestamp of burning.
1245             // - `burned` to `true`.
1246             // - `nextInitialized` to `true`.
1247             _packedOwnerships[tokenId] = _packOwnershipData(
1248                 from,
1249                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1250             );
1251 
1252             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1253             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1254                 uint256 nextTokenId = tokenId + 1;
1255                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1256                 if (_packedOwnerships[nextTokenId] == 0) {
1257                     // If the next slot is within bounds.
1258                     if (nextTokenId != _currentIndex) {
1259                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1260                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1261                     }
1262                 }
1263             }
1264         }
1265 
1266         emit Transfer(from, address(0), tokenId);
1267         _afterTokenTransfers(from, address(0), tokenId, 1);
1268 
1269         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1270         unchecked {
1271             _burnCounter++;
1272         }
1273     }
1274 
1275     // =============================================================
1276     //                     EXTRA DATA OPERATIONS
1277     // =============================================================
1278 
1279     /**
1280      * @dev Directly sets the extra data for the ownership data `index`.
1281      */
1282     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1283         uint256 packed = _packedOwnerships[index];
1284         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1285         uint256 extraDataCasted;
1286         // Cast `extraData` with assembly to avoid redundant masking.
1287         assembly {
1288             extraDataCasted := extraData
1289         }
1290         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1291         _packedOwnerships[index] = packed;
1292     }
1293 
1294     /**
1295      * @dev Called during each token transfer to set the 24bit `extraData` field.
1296      * Intended to be overridden by the cosumer contract.
1297      *
1298      * `previousExtraData` - the value of `extraData` before transfer.
1299      *
1300      * Calling conditions:
1301      *
1302      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1303      * transferred to `to`.
1304      * - When `from` is zero, `tokenId` will be minted for `to`.
1305      * - When `to` is zero, `tokenId` will be burned by `from`.
1306      * - `from` and `to` are never both zero.
1307      */
1308     function _extraData(
1309         address from,
1310         address to,
1311         uint24 previousExtraData
1312     ) internal view virtual returns (uint24) {}
1313 
1314     /**
1315      * @dev Returns the next extra data for the packed ownership data.
1316      * The returned result is shifted into position.
1317      */
1318     function _nextExtraData(
1319         address from,
1320         address to,
1321         uint256 prevOwnershipPacked
1322     ) private view returns (uint256) {
1323         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1324         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1325     }
1326 
1327     // =============================================================
1328     //                       OTHER OPERATIONS
1329     // =============================================================
1330 
1331     /**
1332      * @dev Returns the message sender (defaults to `msg.sender`).
1333      *
1334      * If you are writing GSN compatible contracts, you need to override this function.
1335      */
1336     function _msgSenderERC721A() internal view virtual returns (address) {
1337         return msg.sender;
1338     }
1339 
1340     /**
1341      * @dev Converts a uint256 to its ASCII string decimal representation.
1342      */
1343     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1344         assembly {
1345             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1346             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1347             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1348             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1349             let m := add(mload(0x40), 0xa0)
1350             // Update the free memory pointer to allocate.
1351             mstore(0x40, m)
1352             // Assign the `str` to the end.
1353             str := sub(m, 0x20)
1354             // Zeroize the slot after the string.
1355             mstore(str, 0)
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
1384 // File lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
1385 
1386 // License-Identifier: MIT
1387 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1388 
1389 pragma solidity ^0.8.0;
1390 
1391 /**
1392  * @dev Interface of the ERC165 standard, as defined in the
1393  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1394  *
1395  * Implementers can declare support of contract interfaces, which can then be
1396  * queried by others ({ERC165Checker}).
1397  *
1398  * For an implementation, see {ERC165}.
1399  */
1400 interface IERC165 {
1401     /**
1402      * @dev Returns true if this contract implements the interface defined by
1403      * `interfaceId`. See the corresponding
1404      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1405      * to learn more about how these ids are created.
1406      *
1407      * This function call must use less than 30 000 gas.
1408      */
1409     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1410 }
1411 
1412 
1413 // File lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol
1414 
1415 // License-Identifier: MIT
1416 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1417 
1418 pragma solidity ^0.8.0;
1419 
1420 /**
1421  * @dev Interface for the NFT Royalty Standard.
1422  *
1423  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1424  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1425  *
1426  * _Available since v4.5._
1427  */
1428 interface IERC2981 is IERC165 {
1429     /**
1430      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1431      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1432      */
1433     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1434         external
1435         view
1436         returns (address receiver, uint256 royaltyAmount);
1437 }
1438 
1439 
1440 // File lib/operator-filter-registry/src/lib/Constants.sol
1441 
1442 // License-Identifier: MIT
1443 pragma solidity ^0.8.17;
1444 
1445 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1446 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1447 
1448 
1449 // File lib/operator-filter-registry/src/IOperatorFilterRegistry.sol
1450 
1451 // License-Identifier: MIT
1452 pragma solidity ^0.8.13;
1453 
1454 interface IOperatorFilterRegistry {
1455     /**
1456      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1457      *         true if supplied registrant address is not registered.
1458      */
1459     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1460 
1461     /**
1462      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1463      */
1464     function register(address registrant) external;
1465 
1466     /**
1467      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1468      */
1469     function registerAndSubscribe(address registrant, address subscription) external;
1470 
1471     /**
1472      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1473      *         address without subscribing.
1474      */
1475     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1476 
1477     /**
1478      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1479      *         Note that this does not remove any filtered addresses or codeHashes.
1480      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1481      */
1482     function unregister(address addr) external;
1483 
1484     /**
1485      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1486      */
1487     function updateOperator(address registrant, address operator, bool filtered) external;
1488 
1489     /**
1490      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1491      */
1492     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1493 
1494     /**
1495      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1496      */
1497     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1498 
1499     /**
1500      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1501      */
1502     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1503 
1504     /**
1505      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1506      *         subscription if present.
1507      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1508      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1509      *         used.
1510      */
1511     function subscribe(address registrant, address registrantToSubscribe) external;
1512 
1513     /**
1514      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1515      */
1516     function unsubscribe(address registrant, bool copyExistingEntries) external;
1517 
1518     /**
1519      * @notice Get the subscription address of a given registrant, if any.
1520      */
1521     function subscriptionOf(address addr) external returns (address registrant);
1522 
1523     /**
1524      * @notice Get the set of addresses subscribed to a given registrant.
1525      *         Note that order is not guaranteed as updates are made.
1526      */
1527     function subscribers(address registrant) external returns (address[] memory);
1528 
1529     /**
1530      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1531      *         Note that order is not guaranteed as updates are made.
1532      */
1533     function subscriberAt(address registrant, uint256 index) external returns (address);
1534 
1535     /**
1536      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1537      */
1538     function copyEntriesOf(address registrant, address registrantToCopy) external;
1539 
1540     /**
1541      * @notice Returns true if operator is filtered by a given address or its subscription.
1542      */
1543     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1544 
1545     /**
1546      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1547      */
1548     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1549 
1550     /**
1551      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1552      */
1553     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1554 
1555     /**
1556      * @notice Returns a list of filtered operators for a given address or its subscription.
1557      */
1558     function filteredOperators(address addr) external returns (address[] memory);
1559 
1560     /**
1561      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1562      *         Note that order is not guaranteed as updates are made.
1563      */
1564     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1565 
1566     /**
1567      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1568      *         its subscription.
1569      *         Note that order is not guaranteed as updates are made.
1570      */
1571     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1572 
1573     /**
1574      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1575      *         its subscription.
1576      *         Note that order is not guaranteed as updates are made.
1577      */
1578     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1579 
1580     /**
1581      * @notice Returns true if an address has registered
1582      */
1583     function isRegistered(address addr) external returns (bool);
1584 
1585     /**
1586      * @dev Convenience method to compute the code hash of an arbitrary contract
1587      */
1588     function codeHashOf(address addr) external returns (bytes32);
1589 }
1590 
1591 
1592 // File lib/operator-filter-registry/src/OperatorFilterer.sol
1593 
1594 // License-Identifier: MIT
1595 pragma solidity ^0.8.13;
1596 
1597 
1598 /**
1599  * @title  OperatorFilterer
1600  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1601  *         registrant's entries in the OperatorFilterRegistry.
1602  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1603  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1604  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1605  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1606  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1607  *         will be locked to the options set during construction.
1608  */
1609 
1610 abstract contract OperatorFilterer {
1611     /// @dev Emitted when an operator is not allowed.
1612     error OperatorNotAllowed(address operator);
1613 
1614     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1615         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1616 
1617     /// @dev The constructor that is called when the contract is being deployed.
1618     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1619         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1620         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1621         // order for the modifier to filter addresses.
1622         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1623             if (subscribe) {
1624                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1625             } else {
1626                 if (subscriptionOrRegistrantToCopy != address(0)) {
1627                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1628                 } else {
1629                     OPERATOR_FILTER_REGISTRY.register(address(this));
1630                 }
1631             }
1632         }
1633     }
1634 
1635     /**
1636      * @dev A helper function to check if an operator is allowed.
1637      */
1638     modifier onlyAllowedOperator(address from) virtual {
1639         // Allow spending tokens from addresses with balance
1640         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1641         // from an EOA.
1642         if (from != msg.sender) {
1643             _checkFilterOperator(msg.sender);
1644         }
1645         _;
1646     }
1647 
1648     /**
1649      * @dev A helper function to check if an operator approval is allowed.
1650      */
1651     modifier onlyAllowedOperatorApproval(address operator) virtual {
1652         _checkFilterOperator(operator);
1653         _;
1654     }
1655 
1656     /**
1657      * @dev A helper function to check if an operator is allowed.
1658      */
1659     function _checkFilterOperator(address operator) internal view virtual {
1660         // Check registry code length to facilitate testing in environments without a deployed registry.
1661         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1662             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1663             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1664             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1665                 revert OperatorNotAllowed(operator);
1666             }
1667         }
1668     }
1669 }
1670 
1671 
1672 // File lib/operator-filter-registry/src/DefaultOperatorFilterer.sol
1673 
1674 // License-Identifier: MIT
1675 pragma solidity ^0.8.13;
1676 
1677 
1678 /**
1679  * @title  DefaultOperatorFilterer
1680  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1681  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1682  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1683  *         will be locked to the options set during construction.
1684  */
1685 
1686 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1687     /// @dev The constructor that is called when the contract is being deployed.
1688     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1689 }
1690 
1691 
1692 // File lib/utility-contracts/src/ConstructorInitializable.sol
1693 
1694 // License-Identifier: MIT
1695 pragma solidity >=0.8.4;
1696 
1697 /**
1698  * @author emo.eth
1699  * @notice Abstract smart contract that provides an onlyUninitialized modifier which only allows calling when
1700  *         from within a constructor of some sort, whether directly instantiating an inherting contract,
1701  *         or when delegatecalling from a proxy
1702  */
1703 abstract contract ConstructorInitializable {
1704     error AlreadyInitialized();
1705 
1706     modifier onlyConstructor() {
1707         if (address(this).code.length != 0) {
1708             revert AlreadyInitialized();
1709         }
1710         _;
1711     }
1712 }
1713 
1714 
1715 // File lib/utility-contracts/src/TwoStepOwnable.sol
1716 
1717 // License-Identifier: MIT
1718 pragma solidity >=0.8.4;
1719 
1720 /**
1721 @notice A two-step extension of Ownable, where the new owner must claim ownership of the contract after owner initiates transfer
1722 Owner can cancel the transfer at any point before the new owner claims ownership.
1723 Helpful in guarding against transferring ownership to an address that is unable to act as the Owner.
1724 */
1725 abstract contract TwoStepOwnable is ConstructorInitializable {
1726     address private _owner;
1727 
1728     event OwnershipTransferred(
1729         address indexed previousOwner,
1730         address indexed newOwner
1731     );
1732 
1733     address internal potentialOwner;
1734 
1735     event PotentialOwnerUpdated(address newPotentialAdministrator);
1736 
1737     error NewOwnerIsZeroAddress();
1738     error NotNextOwner();
1739     error OnlyOwner();
1740 
1741     modifier onlyOwner() {
1742         _checkOwner();
1743         _;
1744     }
1745 
1746     constructor() {
1747         _initialize();
1748     }
1749 
1750     function _initialize() private onlyConstructor {
1751         _transferOwnership(msg.sender);
1752     }
1753 
1754     ///@notice Initiate ownership transfer to newPotentialOwner. Note: new owner will have to manually acceptOwnership
1755     ///@param newPotentialOwner address of potential new owner
1756     function transferOwnership(address newPotentialOwner)
1757         public
1758         virtual
1759         onlyOwner
1760     {
1761         if (newPotentialOwner == address(0)) {
1762             revert NewOwnerIsZeroAddress();
1763         }
1764         potentialOwner = newPotentialOwner;
1765         emit PotentialOwnerUpdated(newPotentialOwner);
1766     }
1767 
1768     ///@notice Claim ownership of smart contract, after the current owner has initiated the process with transferOwnership
1769     function acceptOwnership() public virtual {
1770         address _potentialOwner = potentialOwner;
1771         if (msg.sender != _potentialOwner) {
1772             revert NotNextOwner();
1773         }
1774         delete potentialOwner;
1775         emit PotentialOwnerUpdated(address(0));
1776         _transferOwnership(_potentialOwner);
1777     }
1778 
1779     ///@notice cancel ownership transfer
1780     function cancelOwnershipTransfer() public virtual onlyOwner {
1781         delete potentialOwner;
1782         emit PotentialOwnerUpdated(address(0));
1783     }
1784 
1785     function owner() public view virtual returns (address) {
1786         return _owner;
1787     }
1788 
1789     /**
1790      * @dev Throws if the sender is not the owner.
1791      */
1792     function _checkOwner() internal view virtual {
1793         if (_owner != msg.sender) {
1794             revert OnlyOwner();
1795         }
1796     }
1797 
1798     /**
1799      * @dev Leaves the contract without owner. It will not be possible to call
1800      * `onlyOwner` functions anymore. Can only be called by the current owner.
1801      *
1802      * NOTE: Renouncing ownership will leave the contract without an owner,
1803      * thereby removing any functionality that is only available to the owner.
1804      */
1805     function renounceOwnership() public virtual onlyOwner {
1806         _transferOwnership(address(0));
1807     }
1808 
1809     /**
1810      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1811      * Internal function without access restriction.
1812      */
1813     function _transferOwnership(address newOwner) internal virtual {
1814         address oldOwner = _owner;
1815         _owner = newOwner;
1816         emit OwnershipTransferred(oldOwner, newOwner);
1817     }
1818 }
1819 
1820 // File src/interfaces/ISeaDropTokenContractMetadata.sol
1821 
1822 // License-Identifier: MIT
1823 pragma solidity 0.8.17;
1824 
1825 interface ISeaDropTokenContractMetadata is IERC2981 {
1826     /**
1827      * @notice Throw if the max supply exceeds uint64, a limit
1828      *         due to the storage of bit-packed variables in ERC721A.
1829      */
1830     error CannotExceedMaxSupplyOfUint64(uint256 newMaxSupply);
1831 
1832     /**
1833      * @dev Revert with an error when attempting to set the provenance
1834      *      hash after the mint has started.
1835      */
1836     error ProvenanceHashCannotBeSetAfterMintStarted();
1837 
1838     /**
1839      * @dev Revert if the royalty basis points is greater than 10_000.
1840      */
1841     error InvalidRoyaltyBasisPoints(uint256 basisPoints);
1842 
1843     /**
1844      * @dev Revert if the royalty address is being set to the zero address.
1845      */
1846     error RoyaltyAddressCannotBeZeroAddress();
1847 
1848     /**
1849      * @dev Emit an event for token metadata reveals/updates,
1850      *      according to EIP-4906.
1851      *
1852      * @param _fromTokenId The start token id.
1853      * @param _toTokenId   The end token id.
1854      */
1855     event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);
1856 
1857     /**
1858      * @dev Emit an event when the URI for the collection-level metadata
1859      *      is updated.
1860      */
1861     event ContractURIUpdated(string newContractURI);
1862 
1863     /**
1864      * @dev Emit an event when the max token supply is updated.
1865      */
1866     event MaxSupplyUpdated(uint256 newMaxSupply);
1867 
1868     /**
1869      * @dev Emit an event with the previous and new provenance hash after
1870      *      being updated.
1871      */
1872     event ProvenanceHashUpdated(bytes32 previousHash, bytes32 newHash);
1873 
1874     /**
1875      * @dev Emit an event when the royalties info is updated.
1876      */
1877     event RoyaltyInfoUpdated(address receiver, uint256 bps);
1878 
1879     /**
1880      * @notice A struct defining royalty info for the contract.
1881      */
1882     struct RoyaltyInfo {
1883         address royaltyAddress;
1884         uint96 royaltyBps;
1885     }
1886 
1887     /**
1888      * @notice Sets the base URI for the token metadata and emits an event.
1889      *
1890      * @param tokenURI The new base URI to set.
1891      */
1892     function setBaseURI(string calldata tokenURI) external;
1893 
1894     /**
1895      * @notice Sets the contract URI for contract metadata.
1896      *
1897      * @param newContractURI The new contract URI.
1898      */
1899     function setContractURI(string calldata newContractURI) external;
1900 
1901     /**
1902      * @notice Sets the max supply and emits an event.
1903      *
1904      * @param newMaxSupply The new max supply to set.
1905      */
1906     function setMaxSupply(uint256 newMaxSupply) external;
1907 
1908     /**
1909      * @notice Sets the provenance hash and emits an event.
1910      *
1911      *         The provenance hash is used for random reveals, which
1912      *         is a hash of the ordered metadata to show it has not been
1913      *         modified after mint started.
1914      *
1915      *         This function will revert after the first item has been minted.
1916      *
1917      * @param newProvenanceHash The new provenance hash to set.
1918      */
1919     function setProvenanceHash(bytes32 newProvenanceHash) external;
1920 
1921     /**
1922      * @notice Sets the address and basis points for royalties.
1923      *
1924      * @param newInfo The struct to configure royalties.
1925      */
1926     function setRoyaltyInfo(RoyaltyInfo calldata newInfo) external;
1927 
1928     /**
1929      * @notice Returns the base URI for token metadata.
1930      */
1931     function baseURI() external view returns (string memory);
1932 
1933     /**
1934      * @notice Returns the contract URI.
1935      */
1936     function contractURI() external view returns (string memory);
1937 
1938     /**
1939      * @notice Returns the max token supply.
1940      */
1941     function maxSupply() external view returns (uint256);
1942 
1943     /**
1944      * @notice Returns the provenance hash.
1945      *         The provenance hash is used for random reveals, which
1946      *         is a hash of the ordered metadata to show it is unmodified
1947      *         after mint has started.
1948      */
1949     function provenanceHash() external view returns (bytes32);
1950 
1951     /**
1952      * @notice Returns the address that receives royalties.
1953      */
1954     function royaltyAddress() external view returns (address);
1955 
1956     /**
1957      * @notice Returns the royalty basis points out of 10_000.
1958      */
1959     function royaltyBasisPoints() external view returns (uint256);
1960 }
1961 
1962 
1963 // File src/ERC721ContractMetadata.sol
1964 
1965 // License-Identifier: MIT
1966 pragma solidity 0.8.17;
1967 
1968 /**
1969  * @title  ERC721ContractMetadata
1970  * @author James Wenzel (emo.eth)
1971  * @author Ryan Ghods (ralxz.eth)
1972  * @author Stephan Min (stephanm.eth)
1973  * @notice ERC721ContractMetadata is a token contract that extends ERC721A
1974  *         with additional metadata and ownership capabilities.
1975  */
1976 contract ERC721ContractMetadata is
1977     ERC721A,
1978     TwoStepOwnable,
1979     ISeaDropTokenContractMetadata
1980 {
1981     /// @notice Track the max supply.
1982     uint256 _maxSupply;
1983 
1984     /// @notice Track the base URI for token metadata.
1985     string _tokenBaseURI;
1986 
1987     /// @notice Track the contract URI for contract metadata.
1988     string _contractURI;
1989 
1990     /// @notice Track the provenance hash for guaranteeing metadata order
1991     ///         for random reveals.
1992     bytes32 _provenanceHash;
1993 
1994     /// @notice Track the royalty info: address to receive royalties, and
1995     ///         royalty basis points.
1996     RoyaltyInfo _royaltyInfo;
1997 
1998     /**
1999      * @dev Reverts if the sender is not the owner or the contract itself.
2000      *      This function is inlined instead of being a modifier
2001      *      to save contract space from being inlined N times.
2002      */
2003     function _onlyOwnerOrSelf() internal view {
2004         if (
2005             _cast(msg.sender == owner()) | _cast(msg.sender == address(this)) ==
2006             0
2007         ) {
2008             revert OnlyOwner();
2009         }
2010     }
2011 
2012     /**
2013      * @notice Deploy the token contract with its name and symbol.
2014      */
2015     constructor(string memory name, string memory symbol)
2016         ERC721A(name, symbol)
2017     {}
2018 
2019     /**
2020      * @notice Sets the base URI for the token metadata and emits an event.
2021      *
2022      * @param newBaseURI The new base URI to set.
2023      */
2024     function setBaseURI(string calldata newBaseURI) external override {
2025         // Ensure the sender is only the owner or contract itself.
2026         _onlyOwnerOrSelf();
2027 
2028         // Set the new base URI.
2029         _tokenBaseURI = newBaseURI;
2030 
2031         // Emit an event with the update.
2032         if (totalSupply() != 0) {
2033             emit BatchMetadataUpdate(1, _nextTokenId() - 1);
2034         }
2035     }
2036 
2037     /**
2038      * @notice Sets the contract URI for contract metadata.
2039      *
2040      * @param newContractURI The new contract URI.
2041      */
2042     function setContractURI(string calldata newContractURI) external override {
2043         // Ensure the sender is only the owner or contract itself.
2044         _onlyOwnerOrSelf();
2045 
2046         // Set the new contract URI.
2047         _contractURI = newContractURI;
2048 
2049         // Emit an event with the update.
2050         emit ContractURIUpdated(newContractURI);
2051     }
2052 
2053     /**
2054      * @notice Emit an event notifying metadata updates for
2055      *         a range of token ids, according to EIP-4906.
2056      *
2057      * @param fromTokenId The start token id.
2058      * @param toTokenId   The end token id.
2059      */
2060     function emitBatchMetadataUpdate(uint256 fromTokenId, uint256 toTokenId)
2061         external
2062     {
2063         // Ensure the sender is only the owner or contract itself.
2064         _onlyOwnerOrSelf();
2065 
2066         // Emit an event with the update.
2067         emit BatchMetadataUpdate(fromTokenId, toTokenId);
2068     }
2069 
2070     /**
2071      * @notice Sets the max token supply and emits an event.
2072      *
2073      * @param newMaxSupply The new max supply to set.
2074      */
2075     function setMaxSupply(uint256 newMaxSupply) external {
2076         // Ensure the sender is only the owner or contract itself.
2077         _onlyOwnerOrSelf();
2078 
2079         // Ensure the max supply does not exceed the maximum value of uint64.
2080         if (newMaxSupply > 2**64 - 1) {
2081             revert CannotExceedMaxSupplyOfUint64(newMaxSupply);
2082         }
2083 
2084         // Set the new max supply.
2085         _maxSupply = newMaxSupply;
2086 
2087         // Emit an event with the update.
2088         emit MaxSupplyUpdated(newMaxSupply);
2089     }
2090 
2091     /**
2092      * @notice Sets the provenance hash and emits an event.
2093      *
2094      *         The provenance hash is used for random reveals, which
2095      *         is a hash of the ordered metadata to show it has not been
2096      *         modified after mint started.
2097      *
2098      *         This function will revert after the first item has been minted.
2099      *
2100      * @param newProvenanceHash The new provenance hash to set.
2101      */
2102     function setProvenanceHash(bytes32 newProvenanceHash) external {
2103         // Ensure the sender is only the owner or contract itself.
2104         _onlyOwnerOrSelf();
2105 
2106         // Revert if any items have been minted.
2107         if (_totalMinted() > 0) {
2108             revert ProvenanceHashCannotBeSetAfterMintStarted();
2109         }
2110 
2111         // Keep track of the old provenance hash for emitting with the event.
2112         bytes32 oldProvenanceHash = _provenanceHash;
2113 
2114         // Set the new provenance hash.
2115         _provenanceHash = newProvenanceHash;
2116 
2117         // Emit an event with the update.
2118         emit ProvenanceHashUpdated(oldProvenanceHash, newProvenanceHash);
2119     }
2120 
2121     /**
2122      * @notice Sets the address and basis points for royalties.
2123      *
2124      * @param newInfo The struct to configure royalties.
2125      */
2126     function setRoyaltyInfo(RoyaltyInfo calldata newInfo) external {
2127         // Ensure the sender is only the owner or contract itself.
2128         _onlyOwnerOrSelf();
2129 
2130         // Revert if the new royalty address is the zero address.
2131         if (newInfo.royaltyAddress == address(0)) {
2132             revert RoyaltyAddressCannotBeZeroAddress();
2133         }
2134 
2135         // Revert if the new basis points is greater than 10_000.
2136         if (newInfo.royaltyBps > 10_000) {
2137             revert InvalidRoyaltyBasisPoints(newInfo.royaltyBps);
2138         }
2139 
2140         // Set the new royalty info.
2141         _royaltyInfo = newInfo;
2142 
2143         // Emit an event with the updated params.
2144         emit RoyaltyInfoUpdated(newInfo.royaltyAddress, newInfo.royaltyBps);
2145     }
2146 
2147     /**
2148      * @notice Returns the base URI for token metadata.
2149      */
2150     function baseURI() external view override returns (string memory) {
2151         return _baseURI();
2152     }
2153 
2154     /**
2155      * @notice Returns the base URI for the contract, which ERC721A uses
2156      *         to return tokenURI.
2157      */
2158     function _baseURI() internal view virtual override returns (string memory) {
2159         return _tokenBaseURI;
2160     }
2161 
2162     /**
2163      * @notice Returns the contract URI for contract metadata.
2164      */
2165     function contractURI() external view override returns (string memory) {
2166         return _contractURI;
2167     }
2168 
2169     /**
2170      * @notice Returns the max token supply.
2171      */
2172     function maxSupply() public view returns (uint256) {
2173         return _maxSupply;
2174     }
2175 
2176     /**
2177      * @notice Returns the provenance hash.
2178      *         The provenance hash is used for random reveals, which
2179      *         is a hash of the ordered metadata to show it is unmodified
2180      *         after mint has started.
2181      */
2182     function provenanceHash() external view override returns (bytes32) {
2183         return _provenanceHash;
2184     }
2185 
2186     /**
2187      * @notice Returns the address that receives royalties.
2188      */
2189     function royaltyAddress() external view returns (address) {
2190         return _royaltyInfo.royaltyAddress;
2191     }
2192 
2193     /**
2194      * @notice Returns the royalty basis points out of 10_000.
2195      */
2196     function royaltyBasisPoints() external view returns (uint256) {
2197         return _royaltyInfo.royaltyBps;
2198     }
2199 
2200     /**
2201      * @notice Called with the sale price to determine how much royalty
2202      *         is owed and to whom.
2203      *
2204      * @ param  _tokenId     The NFT asset queried for royalty information.
2205      * @param  _salePrice    The sale price of the NFT asset specified by
2206      *                       _tokenId.
2207      *
2208      * @return receiver      Address of who should be sent the royalty payment.
2209      * @return royaltyAmount The royalty payment amount for _salePrice.
2210      */
2211     function royaltyInfo(
2212         uint256, /* _tokenId */
2213         uint256 _salePrice
2214     ) external view returns (address receiver, uint256 royaltyAmount) {
2215         // Put the royalty info on the stack for more efficient access.
2216         RoyaltyInfo storage info = _royaltyInfo;
2217 
2218         // Set the royalty amount to the sale price times the royalty basis
2219         // points divided by 10_000.
2220         royaltyAmount = (_salePrice * info.royaltyBps) / 10_000;
2221 
2222         // Set the receiver of the royalty.
2223         receiver = info.royaltyAddress;
2224     }
2225 
2226     /**
2227      * @notice Returns whether the interface is supported.
2228      *
2229      * @param interfaceId The interface id to check against.
2230      */
2231     function supportsInterface(bytes4 interfaceId)
2232         public
2233         view
2234         virtual
2235         override(IERC165, ERC721A)
2236         returns (bool)
2237     {
2238         return
2239             interfaceId == type(IERC2981).interfaceId ||
2240             interfaceId == 0x49064906 || // ERC-4906
2241             super.supportsInterface(interfaceId);
2242     }
2243 
2244     /**
2245      * @dev Internal pure function to cast a `bool` value to a `uint256` value.
2246      *
2247      * @param b The `bool` value to cast.
2248      *
2249      * @return u The `uint256` value.
2250      */
2251     function _cast(bool b) internal pure returns (uint256 u) {
2252         assembly {
2253             u := b
2254         }
2255     }
2256 }
2257 
2258 
2259 // File lib/solmate/src/utils/ReentrancyGuard.sol
2260 
2261 // License-Identifier: AGPL-3.0-only
2262 pragma solidity >=0.8.0;
2263 
2264 /// @notice Gas optimized reentrancy protection for smart contracts.
2265 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/ReentrancyGuard.sol)
2266 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
2267 abstract contract ReentrancyGuard {
2268     uint256 private locked = 1;
2269 
2270     modifier nonReentrant() virtual {
2271         require(locked == 1, "REENTRANCY");
2272 
2273         locked = 2;
2274 
2275         _;
2276 
2277         locked = 1;
2278     }
2279 }
2280 
2281 
2282 // File src/lib/SeaDropStructs.sol
2283 
2284 // License-Identifier: MIT
2285 pragma solidity 0.8.17;
2286 
2287 /**
2288  * @notice A struct defining public drop data.
2289  *         Designed to fit efficiently in one storage slot.
2290  * 
2291  * @param mintPrice                The mint price per token. (Up to 1.2m
2292  *                                 of native token, e.g. ETH, MATIC)
2293  * @param startTime                The start time, ensure this is not zero.
2294  * @param endTIme                  The end time, ensure this is not zero.
2295  * @param maxTotalMintableByWallet Maximum total number of mints a user is
2296  *                                 allowed. (The limit for this field is
2297  *                                 2^16 - 1)
2298  * @param feeBps                   Fee out of 10_000 basis points to be
2299  *                                 collected.
2300  * @param restrictFeeRecipients    If false, allow any fee recipient;
2301  *                                 if true, check fee recipient is allowed.
2302  */
2303 struct PublicDrop {
2304     uint80 mintPrice; // 80/256 bits
2305     uint48 startTime; // 128/256 bits
2306     uint48 endTime; // 176/256 bits
2307     uint16 maxTotalMintableByWallet; // 224/256 bits
2308     uint16 feeBps; // 240/256 bits
2309     bool restrictFeeRecipients; // 248/256 bits
2310 }
2311 
2312 /**
2313  * @notice A struct defining token gated drop stage data.
2314  *         Designed to fit efficiently in one storage slot.
2315  * 
2316  * @param mintPrice                The mint price per token. (Up to 1.2m 
2317  *                                 of native token, e.g.: ETH, MATIC)
2318  * @param maxTotalMintableByWallet Maximum total number of mints a user is
2319  *                                 allowed. (The limit for this field is
2320  *                                 2^16 - 1)
2321  * @param startTime                The start time, ensure this is not zero.
2322  * @param endTime                  The end time, ensure this is not zero.
2323  * @param dropStageIndex           The drop stage index to emit with the event
2324  *                                 for analytical purposes. This should be 
2325  *                                 non-zero since the public mint emits
2326  *                                 with index zero.
2327  * @param maxTokenSupplyForStage   The limit of token supply this stage can
2328  *                                 mint within. (The limit for this field is
2329  *                                 2^16 - 1)
2330  * @param feeBps                   Fee out of 10_000 basis points to be
2331  *                                 collected.
2332  * @param restrictFeeRecipients    If false, allow any fee recipient;
2333  *                                 if true, check fee recipient is allowed.
2334  */
2335 struct TokenGatedDropStage {
2336     uint80 mintPrice; // 80/256 bits
2337     uint16 maxTotalMintableByWallet; // 96/256 bits
2338     uint48 startTime; // 144/256 bits
2339     uint48 endTime; // 192/256 bits
2340     uint8 dropStageIndex; // non-zero. 200/256 bits
2341     uint32 maxTokenSupplyForStage; // 232/256 bits
2342     uint16 feeBps; // 248/256 bits
2343     bool restrictFeeRecipients; // 256/256 bits
2344 }
2345 
2346 /**
2347  * @notice A struct defining mint params for an allow list.
2348  *         An allow list leaf will be composed of `msg.sender` and
2349  *         the following params.
2350  * 
2351  *         Note: Since feeBps is encoded in the leaf, backend should ensure
2352  *         that feeBps is acceptable before generating a proof.
2353  * 
2354  * @param mintPrice                The mint price per token.
2355  * @param maxTotalMintableByWallet Maximum total number of mints a user is
2356  *                                 allowed.
2357  * @param startTime                The start time, ensure this is not zero.
2358  * @param endTime                  The end time, ensure this is not zero.
2359  * @param dropStageIndex           The drop stage index to emit with the event
2360  *                                 for analytical purposes. This should be
2361  *                                 non-zero since the public mint emits with
2362  *                                 index zero.
2363  * @param maxTokenSupplyForStage   The limit of token supply this stage can
2364  *                                 mint within.
2365  * @param feeBps                   Fee out of 10_000 basis points to be
2366  *                                 collected.
2367  * @param restrictFeeRecipients    If false, allow any fee recipient;
2368  *                                 if true, check fee recipient is allowed.
2369  */
2370 struct MintParams {
2371     uint256 mintPrice; 
2372     uint256 maxTotalMintableByWallet;
2373     uint256 startTime;
2374     uint256 endTime;
2375     uint256 dropStageIndex; // non-zero
2376     uint256 maxTokenSupplyForStage;
2377     uint256 feeBps;
2378     bool restrictFeeRecipients;
2379 }
2380 
2381 /**
2382  * @notice A struct defining token gated mint params.
2383  * 
2384  * @param allowedNftToken    The allowed nft token contract address.
2385  * @param allowedNftTokenIds The token ids to redeem.
2386  */
2387 struct TokenGatedMintParams {
2388     address allowedNftToken;
2389     uint256[] allowedNftTokenIds;
2390 }
2391 
2392 /**
2393  * @notice A struct defining allow list data (for minting an allow list).
2394  * 
2395  * @param merkleRoot    The merkle root for the allow list.
2396  * @param publicKeyURIs If the allowListURI is encrypted, a list of URIs
2397  *                      pointing to the public keys. Empty if unencrypted.
2398  * @param allowListURI  The URI for the allow list.
2399  */
2400 struct AllowListData {
2401     bytes32 merkleRoot;
2402     string[] publicKeyURIs;
2403     string allowListURI;
2404 }
2405 
2406 /**
2407  * @notice A struct defining minimum and maximum parameters to validate for 
2408  *         signed mints, to minimize negative effects of a compromised signer.
2409  *
2410  * @param minMintPrice                The minimum mint price allowed.
2411  * @param maxMaxTotalMintableByWallet The maximum total number of mints allowed
2412  *                                    by a wallet.
2413  * @param minStartTime                The minimum start time allowed.
2414  * @param maxEndTime                  The maximum end time allowed.
2415  * @param maxMaxTokenSupplyForStage   The maximum token supply allowed.
2416  * @param minFeeBps                   The minimum fee allowed.
2417  * @param maxFeeBps                   The maximum fee allowed.
2418  */
2419 struct SignedMintValidationParams {
2420     uint80 minMintPrice; // 80/256 bits
2421     uint24 maxMaxTotalMintableByWallet; // 104/256 bits
2422     uint40 minStartTime; // 144/256 bits
2423     uint40 maxEndTime; // 184/256 bits
2424     uint40 maxMaxTokenSupplyForStage; // 224/256 bits
2425     uint16 minFeeBps; // 240/256 bits
2426     uint16 maxFeeBps; // 256/256 bits
2427 }
2428 
2429 
2430 // File src/interfaces/INonFungibleSeaDropToken.sol
2431 
2432 // License-Identifier: MIT
2433 pragma solidity 0.8.17;
2434 
2435 interface INonFungibleSeaDropToken is ISeaDropTokenContractMetadata {
2436     /**
2437      * @dev Revert with an error if a contract is not an allowed
2438      *      SeaDrop address.
2439      */
2440     error OnlyAllowedSeaDrop();
2441 
2442     /**
2443      * @dev Emit an event when allowed SeaDrop contracts are updated.
2444      */
2445     event AllowedSeaDropUpdated(address[] allowedSeaDrop);
2446 
2447     /**
2448      * @notice Update the allowed SeaDrop contracts.
2449      *         Only the owner or administrator can use this function.
2450      *
2451      * @param allowedSeaDrop The allowed SeaDrop addresses.
2452      */
2453     function updateAllowedSeaDrop(address[] calldata allowedSeaDrop) external;
2454 
2455     /**
2456      * @notice Mint tokens, restricted to the SeaDrop contract.
2457      *
2458      * @dev    NOTE: If a token registers itself with multiple SeaDrop
2459      *         contracts, the implementation of this function should guard
2460      *         against reentrancy. If the implementing token uses
2461      *         _safeMint(), or a feeRecipient with a malicious receive() hook
2462      *         is specified, the token or fee recipients may be able to execute
2463      *         another mint in the same transaction via a separate SeaDrop
2464      *         contract.
2465      *         This is dangerous if an implementing token does not correctly
2466      *         update the minterNumMinted and currentTotalSupply values before
2467      *         transferring minted tokens, as SeaDrop references these values
2468      *         to enforce token limits on a per-wallet and per-stage basis.
2469      *
2470      * @param minter   The address to mint to.
2471      * @param quantity The number of tokens to mint.
2472      */
2473     function mintSeaDrop(address minter, uint256 quantity) external;
2474 
2475     /**
2476      * @notice Returns a set of mint stats for the address.
2477      *         This assists SeaDrop in enforcing maxSupply,
2478      *         maxTotalMintableByWallet, and maxTokenSupplyForStage checks.
2479      *
2480      * @dev    NOTE: Implementing contracts should always update these numbers
2481      *         before transferring any tokens with _safeMint() to mitigate
2482      *         consequences of malicious onERC721Received() hooks.
2483      *
2484      * @param minter The minter address.
2485      */
2486     function getMintStats(address minter)
2487         external
2488         view
2489         returns (
2490             uint256 minterNumMinted,
2491             uint256 currentTotalSupply,
2492             uint256 maxSupply
2493         );
2494 
2495     /**
2496      * @notice Update the public drop data for this nft contract on SeaDrop.
2497      *         Only the owner or administrator can use this function.
2498      *
2499      *         The administrator can only update `feeBps`.
2500      *
2501      * @param seaDropImpl The allowed SeaDrop contract.
2502      * @param publicDrop  The public drop data.
2503      */
2504     function updatePublicDrop(
2505         address seaDropImpl,
2506         PublicDrop calldata publicDrop
2507     ) external;
2508 
2509     /**
2510      * @notice Update the allow list data for this nft contract on SeaDrop.
2511      *         Only the owner or administrator can use this function.
2512      *
2513      * @param seaDropImpl   The allowed SeaDrop contract.
2514      * @param allowListData The allow list data.
2515      */
2516     function updateAllowList(
2517         address seaDropImpl,
2518         AllowListData calldata allowListData
2519     ) external;
2520 
2521     /**
2522      * @notice Update the token gated drop stage data for this nft contract
2523      *         on SeaDrop.
2524      *         Only the owner or administrator can use this function.
2525      *
2526      *         The administrator, when present, must first set `feeBps`.
2527      *
2528      *         Note: If two INonFungibleSeaDropToken tokens are doing
2529      *         simultaneous token gated drop promotions for each other,
2530      *         they can be minted by the same actor until
2531      *         `maxTokenSupplyForStage` is reached. Please ensure the
2532      *         `allowedNftToken` is not running an active drop during the
2533      *         `dropStage` time period.
2534      *
2535      *
2536      * @param seaDropImpl     The allowed SeaDrop contract.
2537      * @param allowedNftToken The allowed nft token.
2538      * @param dropStage       The token gated drop stage data.
2539      */
2540     function updateTokenGatedDrop(
2541         address seaDropImpl,
2542         address allowedNftToken,
2543         TokenGatedDropStage calldata dropStage
2544     ) external;
2545 
2546     /**
2547      * @notice Update the drop URI for this nft contract on SeaDrop.
2548      *         Only the owner or administrator can use this function.
2549      *
2550      * @param seaDropImpl The allowed SeaDrop contract.
2551      * @param dropURI     The new drop URI.
2552      */
2553     function updateDropURI(address seaDropImpl, string calldata dropURI)
2554         external;
2555 
2556     /**
2557      * @notice Update the creator payout address for this nft contract on
2558      *         SeaDrop.
2559      *         Only the owner can set the creator payout address.
2560      *
2561      * @param seaDropImpl   The allowed SeaDrop contract.
2562      * @param payoutAddress The new payout address.
2563      */
2564     function updateCreatorPayoutAddress(
2565         address seaDropImpl,
2566         address payoutAddress
2567     ) external;
2568 
2569     /**
2570      * @notice Update the allowed fee recipient for this nft contract
2571      *         on SeaDrop.
2572      *         Only the administrator can set the allowed fee recipient.
2573      *
2574      * @param seaDropImpl  The allowed SeaDrop contract.
2575      * @param feeRecipient The new fee recipient.
2576      */
2577     function updateAllowedFeeRecipient(
2578         address seaDropImpl,
2579         address feeRecipient,
2580         bool allowed
2581     ) external;
2582 
2583     /**
2584      * @notice Update the server-side signers for this nft contract
2585      *         on SeaDrop.
2586      *         Only the owner or administrator can use this function.
2587      *
2588      * @param seaDropImpl                The allowed SeaDrop contract.
2589      * @param signer                     The signer to update.
2590      * @param signedMintValidationParams Minimum and maximum parameters
2591      *                                   to enforce for signed mints.
2592      */
2593     function updateSignedMintValidationParams(
2594         address seaDropImpl,
2595         address signer,
2596         SignedMintValidationParams memory signedMintValidationParams
2597     ) external;
2598 
2599     /**
2600      * @notice Update the allowed payers for this nft contract on SeaDrop.
2601      *         Only the owner or administrator can use this function.
2602      *
2603      * @param seaDropImpl The allowed SeaDrop contract.
2604      * @param payer       The payer to update.
2605      * @param allowed     Whether the payer is allowed.
2606      */
2607     function updatePayer(
2608         address seaDropImpl,
2609         address payer,
2610         bool allowed
2611     ) external;
2612 }
2613 
2614 
2615 // File src/lib/SeaDropErrorsAndEvents.sol
2616 
2617 // License-Identifier: MIT
2618 pragma solidity 0.8.17;
2619 
2620 interface SeaDropErrorsAndEvents {
2621     /**
2622      * @dev Revert with an error if the drop stage is not active.
2623      */
2624     error NotActive(
2625         uint256 currentTimestamp,
2626         uint256 startTimestamp,
2627         uint256 endTimestamp
2628     );
2629 
2630     /**
2631      * @dev Revert with an error if the mint quantity is zero.
2632      */
2633     error MintQuantityCannotBeZero();
2634 
2635     /**
2636      * @dev Revert with an error if the mint quantity exceeds the max allowed
2637      *      to be minted per wallet.
2638      */
2639     error MintQuantityExceedsMaxMintedPerWallet(uint256 total, uint256 allowed);
2640 
2641     /**
2642      * @dev Revert with an error if the mint quantity exceeds the max token
2643      *      supply.
2644      */
2645     error MintQuantityExceedsMaxSupply(uint256 total, uint256 maxSupply);
2646 
2647     /**
2648      * @dev Revert with an error if the mint quantity exceeds the max token
2649      *      supply for the stage.
2650      *      Note: The `maxTokenSupplyForStage` for public mint is
2651      *      always `type(uint).max`.
2652      */
2653     error MintQuantityExceedsMaxTokenSupplyForStage(
2654         uint256 total, 
2655         uint256 maxTokenSupplyForStage
2656     );
2657     
2658     /**
2659      * @dev Revert if the fee recipient is the zero address.
2660      */
2661     error FeeRecipientCannotBeZeroAddress();
2662 
2663     /**
2664      * @dev Revert if the fee recipient is not already included.
2665      */
2666     error FeeRecipientNotPresent();
2667 
2668     /**
2669      * @dev Revert if the fee basis points is greater than 10_000.
2670      */
2671     error InvalidFeeBps(uint256 feeBps);
2672 
2673     /**
2674      * @dev Revert if the fee recipient is already included.
2675      */
2676     error DuplicateFeeRecipient();
2677 
2678     /**
2679      * @dev Revert if the fee recipient is restricted and not allowed.
2680      */
2681     error FeeRecipientNotAllowed();
2682 
2683     /**
2684      * @dev Revert if the creator payout address is the zero address.
2685      */
2686     error CreatorPayoutAddressCannotBeZeroAddress();
2687 
2688     /**
2689      * @dev Revert with an error if the received payment is incorrect.
2690      */
2691     error IncorrectPayment(uint256 got, uint256 want);
2692 
2693     /**
2694      * @dev Revert with an error if the allow list proof is invalid.
2695      */
2696     error InvalidProof();
2697 
2698     /**
2699      * @dev Revert if a supplied signer address is the zero address.
2700      */
2701     error SignerCannotBeZeroAddress();
2702 
2703     /**
2704      * @dev Revert with an error if signer's signature is invalid.
2705      */
2706     error InvalidSignature(address recoveredSigner);
2707 
2708     /**
2709      * @dev Revert with an error if a signer is not included in
2710      *      the enumeration when removing.
2711      */
2712     error SignerNotPresent();
2713 
2714     /**
2715      * @dev Revert with an error if a payer is not included in
2716      *      the enumeration when removing.
2717      */
2718     error PayerNotPresent();
2719 
2720     /**
2721      * @dev Revert with an error if a payer is already included in mapping
2722      *      when adding.
2723      *      Note: only applies when adding a single payer, as duplicates in
2724      *      enumeration can be removed with updatePayer.
2725      */
2726     error DuplicatePayer();
2727 
2728     /**
2729      * @dev Revert with an error if the payer is not allowed. The minter must
2730      *      pay for their own mint.
2731      */
2732     error PayerNotAllowed();
2733 
2734     /**
2735      * @dev Revert if a supplied payer address is the zero address.
2736      */
2737     error PayerCannotBeZeroAddress();
2738 
2739     /**
2740      * @dev Revert with an error if the sender does not
2741      *      match the INonFungibleSeaDropToken interface.
2742      */
2743     error OnlyINonFungibleSeaDropToken(address sender);
2744 
2745     /**
2746      * @dev Revert with an error if the sender of a token gated supplied
2747      *      drop stage redeem is not the owner of the token.
2748      */
2749     error TokenGatedNotTokenOwner(
2750         address nftContract,
2751         address allowedNftToken,
2752         uint256 allowedNftTokenId
2753     );
2754 
2755     /**
2756      * @dev Revert with an error if the token id has already been used to
2757      *      redeem a token gated drop stage.
2758      */
2759     error TokenGatedTokenIdAlreadyRedeemed(
2760         address nftContract,
2761         address allowedNftToken,
2762         uint256 allowedNftTokenId
2763     );
2764 
2765     /**
2766      * @dev Revert with an error if an empty TokenGatedDropStage is provided
2767      *      for an already-empty TokenGatedDropStage.
2768      */
2769      error TokenGatedDropStageNotPresent();
2770 
2771     /**
2772      * @dev Revert with an error if an allowedNftToken is set to
2773      *      the zero address.
2774      */
2775      error TokenGatedDropAllowedNftTokenCannotBeZeroAddress();
2776 
2777     /**
2778      * @dev Revert with an error if an allowedNftToken is set to
2779      *      the drop token itself.
2780      */
2781      error TokenGatedDropAllowedNftTokenCannotBeDropToken();
2782 
2783 
2784     /**
2785      * @dev Revert with an error if supplied signed mint price is less than
2786      *      the minimum specified.
2787      */
2788     error InvalidSignedMintPrice(uint256 got, uint256 minimum);
2789 
2790     /**
2791      * @dev Revert with an error if supplied signed maxTotalMintableByWallet
2792      *      is greater than the maximum specified.
2793      */
2794     error InvalidSignedMaxTotalMintableByWallet(uint256 got, uint256 maximum);
2795 
2796     /**
2797      * @dev Revert with an error if supplied signed start time is less than
2798      *      the minimum specified.
2799      */
2800     error InvalidSignedStartTime(uint256 got, uint256 minimum);
2801     
2802     /**
2803      * @dev Revert with an error if supplied signed end time is greater than
2804      *      the maximum specified.
2805      */
2806     error InvalidSignedEndTime(uint256 got, uint256 maximum);
2807 
2808     /**
2809      * @dev Revert with an error if supplied signed maxTokenSupplyForStage
2810      *      is greater than the maximum specified.
2811      */
2812      error InvalidSignedMaxTokenSupplyForStage(uint256 got, uint256 maximum);
2813     
2814      /**
2815      * @dev Revert with an error if supplied signed feeBps is greater than
2816      *      the maximum specified, or less than the minimum.
2817      */
2818     error InvalidSignedFeeBps(uint256 got, uint256 minimumOrMaximum);
2819 
2820     /**
2821      * @dev Revert with an error if signed mint did not specify to restrict
2822      *      fee recipients.
2823      */
2824     error SignedMintsMustRestrictFeeRecipients();
2825 
2826     /**
2827      * @dev Revert with an error if a signature for a signed mint has already
2828      *      been used.
2829      */
2830     error SignatureAlreadyUsed();
2831 
2832     /**
2833      * @dev An event with details of a SeaDrop mint, for analytical purposes.
2834      * 
2835      * @param nftContract    The nft contract.
2836      * @param minter         The mint recipient.
2837      * @param feeRecipient   The fee recipient.
2838      * @param payer          The address who payed for the tx.
2839      * @param quantityMinted The number of tokens minted.
2840      * @param unitMintPrice  The amount paid for each token.
2841      * @param feeBps         The fee out of 10_000 basis points collected.
2842      * @param dropStageIndex The drop stage index. Items minted
2843      *                       through mintPublic() have
2844      *                       dropStageIndex of 0.
2845      */
2846     event SeaDropMint(
2847         address indexed nftContract,
2848         address indexed minter,
2849         address indexed feeRecipient,
2850         address payer,
2851         uint256 quantityMinted,
2852         uint256 unitMintPrice,
2853         uint256 feeBps,
2854         uint256 dropStageIndex
2855     );
2856 
2857     /**
2858      * @dev An event with updated public drop data for an nft contract.
2859      */
2860     event PublicDropUpdated(
2861         address indexed nftContract,
2862         PublicDrop publicDrop
2863     );
2864 
2865     /**
2866      * @dev An event with updated token gated drop stage data
2867      *      for an nft contract.
2868      */
2869     event TokenGatedDropStageUpdated(
2870         address indexed nftContract,
2871         address indexed allowedNftToken,
2872         TokenGatedDropStage dropStage
2873     );
2874 
2875     /**
2876      * @dev An event with updated allow list data for an nft contract.
2877      * 
2878      * @param nftContract        The nft contract.
2879      * @param previousMerkleRoot The previous allow list merkle root.
2880      * @param newMerkleRoot      The new allow list merkle root.
2881      * @param publicKeyURI       If the allow list is encrypted, the public key
2882      *                           URIs that can decrypt the list.
2883      *                           Empty if unencrypted.
2884      * @param allowListURI       The URI for the allow list.
2885      */
2886     event AllowListUpdated(
2887         address indexed nftContract,
2888         bytes32 indexed previousMerkleRoot,
2889         bytes32 indexed newMerkleRoot,
2890         string[] publicKeyURI,
2891         string allowListURI
2892     );
2893 
2894     /**
2895      * @dev An event with updated drop URI for an nft contract.
2896      */
2897     event DropURIUpdated(address indexed nftContract, string newDropURI);
2898 
2899     /**
2900      * @dev An event with the updated creator payout address for an nft
2901      *      contract.
2902      */
2903     event CreatorPayoutAddressUpdated(
2904         address indexed nftContract,
2905         address indexed newPayoutAddress
2906     );
2907 
2908     /**
2909      * @dev An event with the updated allowed fee recipient for an nft
2910      *      contract.
2911      */
2912     event AllowedFeeRecipientUpdated(
2913         address indexed nftContract,
2914         address indexed feeRecipient,
2915         bool indexed allowed
2916     );
2917 
2918     /**
2919      * @dev An event with the updated validation parameters for server-side
2920      *      signers.
2921      */
2922     event SignedMintValidationParamsUpdated(
2923         address indexed nftContract,
2924         address indexed signer,
2925         SignedMintValidationParams signedMintValidationParams
2926     );   
2927 
2928     /**
2929      * @dev An event with the updated payer for an nft contract.
2930      */
2931     event PayerUpdated(
2932         address indexed nftContract,
2933         address indexed payer,
2934         bool indexed allowed
2935     );
2936 }
2937 
2938 
2939 // File src/interfaces/ISeaDrop.sol
2940 
2941 // License-Identifier: MIT
2942 pragma solidity 0.8.17;
2943 
2944 interface ISeaDrop is SeaDropErrorsAndEvents {
2945     /**
2946      * @notice Mint a public drop.
2947      *
2948      * @param nftContract      The nft contract to mint.
2949      * @param feeRecipient     The fee recipient.
2950      * @param minterIfNotPayer The mint recipient if different than the payer.
2951      * @param quantity         The number of tokens to mint.
2952      */
2953     function mintPublic(
2954         address nftContract,
2955         address feeRecipient,
2956         address minterIfNotPayer,
2957         uint256 quantity
2958     ) external payable;
2959 
2960     /**
2961      * @notice Mint from an allow list.
2962      *
2963      * @param nftContract      The nft contract to mint.
2964      * @param feeRecipient     The fee recipient.
2965      * @param minterIfNotPayer The mint recipient if different than the payer.
2966      * @param quantity         The number of tokens to mint.
2967      * @param mintParams       The mint parameters.
2968      * @param proof            The proof for the leaf of the allow list.
2969      */
2970     function mintAllowList(
2971         address nftContract,
2972         address feeRecipient,
2973         address minterIfNotPayer,
2974         uint256 quantity,
2975         MintParams calldata mintParams,
2976         bytes32[] calldata proof
2977     ) external payable;
2978 
2979     /**
2980      * @notice Mint with a server-side signature.
2981      *         Note that a signature can only be used once.
2982      *
2983      * @param nftContract      The nft contract to mint.
2984      * @param feeRecipient     The fee recipient.
2985      * @param minterIfNotPayer The mint recipient if different than the payer.
2986      * @param quantity         The number of tokens to mint.
2987      * @param mintParams       The mint parameters.
2988      * @param salt             The sale for the signed mint.
2989      * @param signature        The server-side signature, must be an allowed
2990      *                         signer.
2991      */
2992     function mintSigned(
2993         address nftContract,
2994         address feeRecipient,
2995         address minterIfNotPayer,
2996         uint256 quantity,
2997         MintParams calldata mintParams,
2998         uint256 salt,
2999         bytes calldata signature
3000     ) external payable;
3001 
3002     /**
3003      * @notice Mint as an allowed token holder.
3004      *         This will mark the token id as redeemed and will revert if the
3005      *         same token id is attempted to be redeemed twice.
3006      *
3007      * @param nftContract      The nft contract to mint.
3008      * @param feeRecipient     The fee recipient.
3009      * @param minterIfNotPayer The mint recipient if different than the payer.
3010      * @param mintParams       The token gated mint params.
3011      */
3012     function mintAllowedTokenHolder(
3013         address nftContract,
3014         address feeRecipient,
3015         address minterIfNotPayer,
3016         TokenGatedMintParams calldata mintParams
3017     ) external payable;
3018 
3019     /**
3020      * @notice Emits an event to notify update of the drop URI.
3021      *
3022      *         This method assume msg.sender is an nft contract and its
3023      *         ERC165 interface id matches INonFungibleSeaDropToken.
3024      *
3025      *         Note: Be sure only authorized users can call this from
3026      *         token contracts that implement INonFungibleSeaDropToken.
3027      *
3028      * @param dropURI The new drop URI.
3029      */
3030     function updateDropURI(string calldata dropURI) external;
3031 
3032     /**
3033      * @notice Updates the public drop data for the nft contract
3034      *         and emits an event.
3035      *
3036      *         This method assume msg.sender is an nft contract and its
3037      *         ERC165 interface id matches INonFungibleSeaDropToken.
3038      *
3039      *         Note: Be sure only authorized users can call this from
3040      *         token contracts that implement INonFungibleSeaDropToken.
3041      *
3042      * @param publicDrop The public drop data.
3043      */
3044     function updatePublicDrop(PublicDrop calldata publicDrop) external;
3045 
3046     /**
3047      * @notice Updates the allow list merkle root for the nft contract
3048      *         and emits an event.
3049      *
3050      *         This method assume msg.sender is an nft contract and its
3051      *         ERC165 interface id matches INonFungibleSeaDropToken.
3052      *
3053      *         Note: Be sure only authorized users can call this from
3054      *         token contracts that implement INonFungibleSeaDropToken.
3055      *
3056      * @param allowListData The allow list data.
3057      */
3058     function updateAllowList(AllowListData calldata allowListData) external;
3059 
3060     /**
3061      * @notice Updates the token gated drop stage for the nft contract
3062      *         and emits an event.
3063      *
3064      *         This method assume msg.sender is an nft contract and its
3065      *         ERC165 interface id matches INonFungibleSeaDropToken.
3066      *
3067      *         Note: Be sure only authorized users can call this from
3068      *         token contracts that implement INonFungibleSeaDropToken.
3069      *
3070      *         Note: If two INonFungibleSeaDropToken tokens are doing
3071      *         simultaneous token gated drop promotions for each other,
3072      *         they can be minted by the same actor until
3073      *         `maxTokenSupplyForStage` is reached. Please ensure the
3074      *         `allowedNftToken` is not running an active drop during
3075      *         the `dropStage` time period.
3076      *
3077      * @param allowedNftToken The token gated nft token.
3078      * @param dropStage       The token gated drop stage data.
3079      */
3080     function updateTokenGatedDrop(
3081         address allowedNftToken,
3082         TokenGatedDropStage calldata dropStage
3083     ) external;
3084 
3085     /**
3086      * @notice Updates the creator payout address and emits an event.
3087      *
3088      *         This method assume msg.sender is an nft contract and its
3089      *         ERC165 interface id matches INonFungibleSeaDropToken.
3090      *
3091      *         Note: Be sure only authorized users can call this from
3092      *         token contracts that implement INonFungibleSeaDropToken.
3093      *
3094      * @param payoutAddress The creator payout address.
3095      */
3096     function updateCreatorPayoutAddress(address payoutAddress) external;
3097 
3098     /**
3099      * @notice Updates the allowed fee recipient and emits an event.
3100      *
3101      *         This method assume msg.sender is an nft contract and its
3102      *         ERC165 interface id matches INonFungibleSeaDropToken.
3103      *
3104      *         Note: Be sure only authorized users can call this from
3105      *         token contracts that implement INonFungibleSeaDropToken.
3106      *
3107      * @param feeRecipient The fee recipient.
3108      * @param allowed      If the fee recipient is allowed.
3109      */
3110     function updateAllowedFeeRecipient(address feeRecipient, bool allowed)
3111         external;
3112 
3113     /**
3114      * @notice Updates the allowed server-side signers and emits an event.
3115      *
3116      *         This method assume msg.sender is an nft contract and its
3117      *         ERC165 interface id matches INonFungibleSeaDropToken.
3118      *
3119      *         Note: Be sure only authorized users can call this from
3120      *         token contracts that implement INonFungibleSeaDropToken.
3121      *
3122      * @param signer                     The signer to update.
3123      * @param signedMintValidationParams Minimum and maximum parameters
3124      *                                   to enforce for signed mints.
3125      */
3126     function updateSignedMintValidationParams(
3127         address signer,
3128         SignedMintValidationParams calldata signedMintValidationParams
3129     ) external;
3130 
3131     /**
3132      * @notice Updates the allowed payer and emits an event.
3133      *
3134      *         This method assume msg.sender is an nft contract and its
3135      *         ERC165 interface id matches INonFungibleSeaDropToken.
3136      *
3137      *         Note: Be sure only authorized users can call this from
3138      *         token contracts that implement INonFungibleSeaDropToken.
3139      *
3140      * @param payer   The payer to add or remove.
3141      * @param allowed Whether to add or remove the payer.
3142      */
3143     function updatePayer(address payer, bool allowed) external;
3144 
3145     /**
3146      * @notice Returns the public drop data for the nft contract.
3147      *
3148      * @param nftContract The nft contract.
3149      */
3150     function getPublicDrop(address nftContract)
3151         external
3152         view
3153         returns (PublicDrop memory);
3154 
3155     /**
3156      * @notice Returns the creator payout address for the nft contract.
3157      *
3158      * @param nftContract The nft contract.
3159      */
3160     function getCreatorPayoutAddress(address nftContract)
3161         external
3162         view
3163         returns (address);
3164 
3165     /**
3166      * @notice Returns the allow list merkle root for the nft contract.
3167      *
3168      * @param nftContract The nft contract.
3169      */
3170     function getAllowListMerkleRoot(address nftContract)
3171         external
3172         view
3173         returns (bytes32);
3174 
3175     /**
3176      * @notice Returns if the specified fee recipient is allowed
3177      *         for the nft contract.
3178      *
3179      * @param nftContract  The nft contract.
3180      * @param feeRecipient The fee recipient.
3181      */
3182     function getFeeRecipientIsAllowed(address nftContract, address feeRecipient)
3183         external
3184         view
3185         returns (bool);
3186 
3187     /**
3188      * @notice Returns an enumeration of allowed fee recipients for an
3189      *         nft contract when fee recipients are enforced
3190      *
3191      * @param nftContract The nft contract.
3192      */
3193     function getAllowedFeeRecipients(address nftContract)
3194         external
3195         view
3196         returns (address[] memory);
3197 
3198     /**
3199      * @notice Returns the server-side signers for the nft contract.
3200      *
3201      * @param nftContract The nft contract.
3202      */
3203     function getSigners(address nftContract)
3204         external
3205         view
3206         returns (address[] memory);
3207 
3208     /**
3209      * @notice Returns the struct of SignedMintValidationParams for a signer.
3210      *
3211      * @param nftContract The nft contract.
3212      * @param signer      The signer.
3213      */
3214     function getSignedMintValidationParams(address nftContract, address signer)
3215         external
3216         view
3217         returns (SignedMintValidationParams memory);
3218 
3219     /**
3220      * @notice Returns the payers for the nft contract.
3221      *
3222      * @param nftContract The nft contract.
3223      */
3224     function getPayers(address nftContract)
3225         external
3226         view
3227         returns (address[] memory);
3228 
3229     /**
3230      * @notice Returns if the specified payer is allowed
3231      *         for the nft contract.
3232      *
3233      * @param nftContract The nft contract.
3234      * @param payer       The payer.
3235      */
3236     function getPayerIsAllowed(address nftContract, address payer)
3237         external
3238         view
3239         returns (bool);
3240 
3241     /**
3242      * @notice Returns the allowed token gated drop tokens for the nft contract.
3243      *
3244      * @param nftContract The nft contract.
3245      */
3246     function getTokenGatedAllowedTokens(address nftContract)
3247         external
3248         view
3249         returns (address[] memory);
3250 
3251     /**
3252      * @notice Returns the token gated drop data for the nft contract
3253      *         and token gated nft.
3254      *
3255      * @param nftContract     The nft contract.
3256      * @param allowedNftToken The token gated nft token.
3257      */
3258     function getTokenGatedDrop(address nftContract, address allowedNftToken)
3259         external
3260         view
3261         returns (TokenGatedDropStage memory);
3262 
3263     /**
3264      * @notice Returns whether the token id for a token gated drop has been
3265      *         redeemed.
3266      *
3267      * @param nftContract       The nft contract.
3268      * @param allowedNftToken   The token gated nft token.
3269      * @param allowedNftTokenId The token gated nft token id to check.
3270      */
3271     function getAllowedNftTokenIdIsRedeemed(
3272         address nftContract,
3273         address allowedNftToken,
3274         uint256 allowedNftTokenId
3275     ) external view returns (bool);
3276 }
3277 
3278 
3279 // File src/lib/ERC721SeaDropStructsErrorsAndEvents.sol
3280 
3281 // License-Identifier: MIT
3282 pragma solidity 0.8.17;
3283 
3284 interface ERC721SeaDropStructsErrorsAndEvents {
3285   /**
3286    * @notice Revert with an error if mint exceeds the max supply.
3287    */
3288   error MintQuantityExceedsMaxSupply(uint256 total, uint256 maxSupply);
3289 
3290   /**
3291    * @notice Revert with an error if the number of token gated 
3292    *         allowedNftTokens doesn't match the length of supplied
3293    *         drop stages.
3294    */
3295   error TokenGatedMismatch();
3296 
3297   /**
3298    *  @notice Revert with an error if the number of signers doesn't match
3299    *          the length of supplied signedMintValidationParams
3300    */
3301   error SignersMismatch();
3302 
3303   /**
3304    * @notice An event to signify that a SeaDrop token contract was deployed.
3305    */
3306   event SeaDropTokenDeployed();
3307 
3308   /**
3309    * @notice A struct to configure multiple contract options at a time.
3310    */
3311   struct MultiConfigureStruct {
3312     uint256 maxSupply;
3313     string baseURI;
3314     string contractURI;
3315     address seaDropImpl;
3316     PublicDrop publicDrop;
3317     string dropURI;
3318     AllowListData allowListData;
3319     address creatorPayoutAddress;
3320     bytes32 provenanceHash;
3321 
3322     address[] allowedFeeRecipients;
3323     address[] disallowedFeeRecipients;
3324 
3325     address[] allowedPayers;
3326     address[] disallowedPayers;
3327 
3328     // Token-gated
3329     address[] tokenGatedAllowedNftTokens;
3330     TokenGatedDropStage[] tokenGatedDropStages;
3331     address[] disallowedTokenGatedAllowedNftTokens;
3332 
3333     // Server-signed
3334     address[] signers;
3335     SignedMintValidationParams[] signedMintValidationParams;
3336     address[] disallowedSigners;
3337   }
3338 }
3339 
3340 
3341 // File src/ERC721SeaDrop.sol
3342 
3343 // License-Identifier: MIT
3344 pragma solidity 0.8.17;
3345 
3346 /**
3347  * @title  ERC721SeaDrop
3348  * @author James Wenzel (emo.eth)
3349  * @author Ryan Ghods (ralxz.eth)
3350  * @author Stephan Min (stephanm.eth)
3351  * @author Michael Cohen (notmichael.eth)
3352  * @notice ERC721SeaDrop is a token contract that contains methods
3353  *         to properly interact with SeaDrop.
3354  */
3355 contract ERC721SeaDrop is
3356     ERC721ContractMetadata,
3357     INonFungibleSeaDropToken,
3358     ERC721SeaDropStructsErrorsAndEvents,
3359     ReentrancyGuard,
3360     DefaultOperatorFilterer
3361 {
3362     /// @notice Track the allowed SeaDrop addresses.
3363     mapping(address => bool) internal _allowedSeaDrop;
3364 
3365     /// @notice Track the enumerated allowed SeaDrop addresses.
3366     address[] internal _enumeratedAllowedSeaDrop;
3367 
3368     /**
3369      * @dev Reverts if not an allowed SeaDrop contract.
3370      *      This function is inlined instead of being a modifier
3371      *      to save contract space from being inlined N times.
3372      *
3373      * @param seaDrop The SeaDrop address to check if allowed.
3374      */
3375     function _onlyAllowedSeaDrop(address seaDrop) internal view {
3376         if (_allowedSeaDrop[seaDrop] != true) {
3377             revert OnlyAllowedSeaDrop();
3378         }
3379     }
3380 
3381     /**
3382      * @notice Deploy the token contract with its name, symbol,
3383      *         and allowed SeaDrop addresses.
3384      */
3385     constructor(
3386         string memory name,
3387         string memory symbol,
3388         address[] memory allowedSeaDrop
3389     ) ERC721ContractMetadata(name, symbol) {
3390         // Put the length on the stack for more efficient access.
3391         uint256 allowedSeaDropLength = allowedSeaDrop.length;
3392 
3393         // Set the mapping for allowed SeaDrop contracts.
3394         for (uint256 i = 0; i < allowedSeaDropLength; ) {
3395             _allowedSeaDrop[allowedSeaDrop[i]] = true;
3396             unchecked {
3397                 ++i;
3398             }
3399         }
3400 
3401         // Set the enumeration.
3402         _enumeratedAllowedSeaDrop = allowedSeaDrop;
3403 
3404         // Emit an event noting the contract deployment.
3405         emit SeaDropTokenDeployed();
3406     }
3407 
3408     /**
3409      * @notice Update the allowed SeaDrop contracts.
3410      *         Only the owner or administrator can use this function.
3411      *
3412      * @param allowedSeaDrop The allowed SeaDrop addresses.
3413      */
3414     function updateAllowedSeaDrop(address[] calldata allowedSeaDrop)
3415         external
3416         virtual
3417         override
3418         onlyOwner
3419     {
3420         _updateAllowedSeaDrop(allowedSeaDrop);
3421     }
3422 
3423     /**
3424      * @notice Internal function to update the allowed SeaDrop contracts.
3425      *
3426      * @param allowedSeaDrop The allowed SeaDrop addresses.
3427      */
3428     function _updateAllowedSeaDrop(address[] calldata allowedSeaDrop) internal {
3429         // Put the length on the stack for more efficient access.
3430         uint256 enumeratedAllowedSeaDropLength = _enumeratedAllowedSeaDrop
3431             .length;
3432         uint256 allowedSeaDropLength = allowedSeaDrop.length;
3433 
3434         // Reset the old mapping.
3435         for (uint256 i = 0; i < enumeratedAllowedSeaDropLength; ) {
3436             _allowedSeaDrop[_enumeratedAllowedSeaDrop[i]] = false;
3437             unchecked {
3438                 ++i;
3439             }
3440         }
3441 
3442         // Set the new mapping for allowed SeaDrop contracts.
3443         for (uint256 i = 0; i < allowedSeaDropLength; ) {
3444             _allowedSeaDrop[allowedSeaDrop[i]] = true;
3445             unchecked {
3446                 ++i;
3447             }
3448         }
3449 
3450         // Set the enumeration.
3451         _enumeratedAllowedSeaDrop = allowedSeaDrop;
3452 
3453         // Emit an event for the update.
3454         emit AllowedSeaDropUpdated(allowedSeaDrop);
3455     }
3456 
3457     /**
3458      * @dev Overrides the `_startTokenId` function from ERC721A
3459      *      to start at token id `1`.
3460      *
3461      *      This is to avoid future possible problems since `0` is usually
3462      *      used to signal values that have not been set or have been removed.
3463      */
3464     function _startTokenId() internal view virtual override returns (uint256) {
3465         return 1;
3466     }
3467 
3468     /**
3469      * @dev Overrides the `tokenURI()` function from ERC721A
3470      *      to return just the base URI if it is implied to not be a directory.
3471      *
3472      *      This is to help with ERC721 contracts in which the same token URI
3473      *      is desired for each token, such as when the tokenURI is 'unrevealed'.
3474      */
3475     function tokenURI(uint256 tokenId)
3476         public
3477         view
3478         virtual
3479         override
3480         returns (string memory)
3481     {
3482         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
3483 
3484         string memory baseURI = _baseURI();
3485 
3486         // Exit early if the baseURI is empty.
3487         if (bytes(baseURI).length == 0) {
3488             return "";
3489         }
3490 
3491         // Check if the last character in baseURI is a slash.
3492         if (bytes(baseURI)[bytes(baseURI).length - 1] != bytes("/")[0]) {
3493             return baseURI;
3494         }
3495 
3496         return string(abi.encodePacked(baseURI, _toString(tokenId), "/metadata.json"));
3497     }
3498 
3499     /**
3500      * @notice Mint tokens, restricted to the SeaDrop contract.
3501      *
3502      * @dev    NOTE: If a token registers itself with multiple SeaDrop
3503      *         contracts, the implementation of this function should guard
3504      *         against reentrancy. If the implementing token uses
3505      *         _safeMint(), or a feeRecipient with a malicious receive() hook
3506      *         is specified, the token or fee recipients may be able to execute
3507      *         another mint in the same transaction via a separate SeaDrop
3508      *         contract.
3509      *         This is dangerous if an implementing token does not correctly
3510      *         update the minterNumMinted and currentTotalSupply values before
3511      *         transferring minted tokens, as SeaDrop references these values
3512      *         to enforce token limits on a per-wallet and per-stage basis.
3513      *
3514      *         ERC721A tracks these values automatically, but this note and
3515      *         nonReentrant modifier are left here to encourage best-practices
3516      *         when referencing this contract.
3517      *
3518      * @param minter   The address to mint to.
3519      * @param quantity The number of tokens to mint.
3520      */
3521     function mintSeaDrop(address minter, uint256 quantity)
3522         external
3523         virtual
3524         override
3525         nonReentrant
3526     {
3527         // Ensure the SeaDrop is allowed.
3528         _onlyAllowedSeaDrop(msg.sender);
3529 
3530         // Extra safety check to ensure the max supply is not exceeded.
3531         if (_totalMinted() + quantity > maxSupply()) {
3532             revert MintQuantityExceedsMaxSupply(
3533                 _totalMinted() + quantity,
3534                 maxSupply()
3535             );
3536         }
3537 
3538         // Mint the quantity of tokens to the minter.
3539         _safeMint(minter, quantity);
3540     }
3541 
3542     /**
3543      * @notice Update the public drop data for this nft contract on SeaDrop.
3544      *         Only the owner can use this function.
3545      *
3546      * @param seaDropImpl The allowed SeaDrop contract.
3547      * @param publicDrop  The public drop data.
3548      */
3549     function updatePublicDrop(
3550         address seaDropImpl,
3551         PublicDrop calldata publicDrop
3552     ) external virtual override {
3553         // Ensure the sender is only the owner or contract itself.
3554         _onlyOwnerOrSelf();
3555 
3556         // Ensure the SeaDrop is allowed.
3557         _onlyAllowedSeaDrop(seaDropImpl);
3558 
3559         // Update the public drop data on SeaDrop.
3560         ISeaDrop(seaDropImpl).updatePublicDrop(publicDrop);
3561     }
3562 
3563     /**
3564      * @notice Update the allow list data for this nft contract on SeaDrop.
3565      *         Only the owner can use this function.
3566      *
3567      * @param seaDropImpl   The allowed SeaDrop contract.
3568      * @param allowListData The allow list data.
3569      */
3570     function updateAllowList(
3571         address seaDropImpl,
3572         AllowListData calldata allowListData
3573     ) external virtual override {
3574         // Ensure the sender is only the owner or contract itself.
3575         _onlyOwnerOrSelf();
3576 
3577         // Ensure the SeaDrop is allowed.
3578         _onlyAllowedSeaDrop(seaDropImpl);
3579 
3580         // Update the allow list on SeaDrop.
3581         ISeaDrop(seaDropImpl).updateAllowList(allowListData);
3582     }
3583 
3584     /**
3585      * @notice Update the token gated drop stage data for this nft contract
3586      *         on SeaDrop.
3587      *         Only the owner can use this function.
3588      *
3589      *         Note: If two INonFungibleSeaDropToken tokens are doing
3590      *         simultaneous token gated drop promotions for each other,
3591      *         they can be minted by the same actor until
3592      *         `maxTokenSupplyForStage` is reached. Please ensure the
3593      *         `allowedNftToken` is not running an active drop during the
3594      *         `dropStage` time period.
3595      *
3596      * @param seaDropImpl     The allowed SeaDrop contract.
3597      * @param allowedNftToken The allowed nft token.
3598      * @param dropStage       The token gated drop stage data.
3599      */
3600     function updateTokenGatedDrop(
3601         address seaDropImpl,
3602         address allowedNftToken,
3603         TokenGatedDropStage calldata dropStage
3604     ) external virtual override {
3605         // Ensure the sender is only the owner or contract itself.
3606         _onlyOwnerOrSelf();
3607 
3608         // Ensure the SeaDrop is allowed.
3609         _onlyAllowedSeaDrop(seaDropImpl);
3610 
3611         // Update the token gated drop stage.
3612         ISeaDrop(seaDropImpl).updateTokenGatedDrop(allowedNftToken, dropStage);
3613     }
3614 
3615     /**
3616      * @notice Update the drop URI for this nft contract on SeaDrop.
3617      *         Only the owner can use this function.
3618      *
3619      * @param seaDropImpl The allowed SeaDrop contract.
3620      * @param dropURI     The new drop URI.
3621      */
3622     function updateDropURI(address seaDropImpl, string calldata dropURI)
3623         external
3624         virtual
3625         override
3626     {
3627         // Ensure the sender is only the owner or contract itself.
3628         _onlyOwnerOrSelf();
3629 
3630         // Ensure the SeaDrop is allowed.
3631         _onlyAllowedSeaDrop(seaDropImpl);
3632 
3633         // Update the drop URI.
3634         ISeaDrop(seaDropImpl).updateDropURI(dropURI);
3635     }
3636 
3637     /**
3638      * @notice Update the creator payout address for this nft contract on
3639      *         SeaDrop.
3640      *         Only the owner can set the creator payout address.
3641      *
3642      * @param seaDropImpl   The allowed SeaDrop contract.
3643      * @param payoutAddress The new payout address.
3644      */
3645     function updateCreatorPayoutAddress(
3646         address seaDropImpl,
3647         address payoutAddress
3648     ) external {
3649         // Ensure the sender is only the owner or contract itself.
3650         _onlyOwnerOrSelf();
3651 
3652         // Ensure the SeaDrop is allowed.
3653         _onlyAllowedSeaDrop(seaDropImpl);
3654 
3655         // Update the creator payout address.
3656         ISeaDrop(seaDropImpl).updateCreatorPayoutAddress(payoutAddress);
3657     }
3658 
3659     /**
3660      * @notice Update the allowed fee recipient for this nft contract
3661      *         on SeaDrop.
3662      *         Only the owner can set the allowed fee recipient.
3663      *
3664      * @param seaDropImpl  The allowed SeaDrop contract.
3665      * @param feeRecipient The new fee recipient.
3666      * @param allowed      If the fee recipient is allowed.
3667      */
3668     function updateAllowedFeeRecipient(
3669         address seaDropImpl,
3670         address feeRecipient,
3671         bool allowed
3672     ) external virtual {
3673         // Ensure the sender is only the owner or contract itself.
3674         _onlyOwnerOrSelf();
3675 
3676         // Ensure the SeaDrop is allowed.
3677         _onlyAllowedSeaDrop(seaDropImpl);
3678 
3679         // Update the allowed fee recipient.
3680         ISeaDrop(seaDropImpl).updateAllowedFeeRecipient(feeRecipient, allowed);
3681     }
3682 
3683     /**
3684      * @notice Update the server-side signers for this nft contract
3685      *         on SeaDrop.
3686      *         Only the owner can use this function.
3687      *
3688      * @param seaDropImpl                The allowed SeaDrop contract.
3689      * @param signer                     The signer to update.
3690      * @param signedMintValidationParams Minimum and maximum parameters to
3691      *                                   enforce for signed mints.
3692      */
3693     function updateSignedMintValidationParams(
3694         address seaDropImpl,
3695         address signer,
3696         SignedMintValidationParams memory signedMintValidationParams
3697     ) external virtual override {
3698         // Ensure the sender is only the owner or contract itself.
3699         _onlyOwnerOrSelf();
3700 
3701         // Ensure the SeaDrop is allowed.
3702         _onlyAllowedSeaDrop(seaDropImpl);
3703 
3704         // Update the signer.
3705         ISeaDrop(seaDropImpl).updateSignedMintValidationParams(
3706             signer,
3707             signedMintValidationParams
3708         );
3709     }
3710 
3711     /**
3712      * @notice Update the allowed payers for this nft contract on SeaDrop.
3713      *         Only the owner can use this function.
3714      *
3715      * @param seaDropImpl The allowed SeaDrop contract.
3716      * @param payer       The payer to update.
3717      * @param allowed     Whether the payer is allowed.
3718      */
3719     function updatePayer(
3720         address seaDropImpl,
3721         address payer,
3722         bool allowed
3723     ) external virtual override {
3724         // Ensure the sender is only the owner or contract itself.
3725         _onlyOwnerOrSelf();
3726 
3727         // Ensure the SeaDrop is allowed.
3728         _onlyAllowedSeaDrop(seaDropImpl);
3729 
3730         // Update the payer.
3731         ISeaDrop(seaDropImpl).updatePayer(payer, allowed);
3732     }
3733 
3734     /**
3735      * @notice Returns a set of mint stats for the address.
3736      *         This assists SeaDrop in enforcing maxSupply,
3737      *         maxTotalMintableByWallet, and maxTokenSupplyForStage checks.
3738      *
3739      * @dev    NOTE: Implementing contracts should always update these numbers
3740      *         before transferring any tokens with _safeMint() to mitigate
3741      *         consequences of malicious onERC721Received() hooks.
3742      *
3743      * @param minter The minter address.
3744      */
3745     function getMintStats(address minter)
3746         external
3747         view
3748         override
3749         returns (
3750             uint256 minterNumMinted,
3751             uint256 currentTotalSupply,
3752             uint256 maxSupply
3753         )
3754     {
3755         minterNumMinted = _numberMinted(minter);
3756         currentTotalSupply = _totalMinted();
3757         maxSupply = _maxSupply;
3758     }
3759 
3760     /**
3761      * @notice Returns whether the interface is supported.
3762      *
3763      * @param interfaceId The interface id to check against.
3764      */
3765     function supportsInterface(bytes4 interfaceId)
3766         public
3767         view
3768         virtual
3769         override(IERC165, ERC721ContractMetadata)
3770         returns (bool)
3771     {
3772         return
3773             interfaceId == type(INonFungibleSeaDropToken).interfaceId ||
3774             interfaceId == type(ISeaDropTokenContractMetadata).interfaceId ||
3775             // ERC721ContractMetadata returns supportsInterface true for
3776             //     EIP-2981
3777             // ERC721A returns supportsInterface true for
3778             //     ERC165, ERC721, ERC721Metadata
3779             super.supportsInterface(interfaceId);
3780     }
3781 
3782     /**
3783      * @dev Approve or remove `operator` as an operator for the caller.
3784      * Operators can call {transferFrom} or {safeTransferFrom}
3785      * for any token owned by the caller.
3786      *
3787      * Requirements:
3788      *
3789      * - The `operator` cannot be the caller.
3790      * - The `operator` must be allowed.
3791      *
3792      * Emits an {ApprovalForAll} event.
3793      */
3794     function setApprovalForAll(address operator, bool approved)
3795         public
3796         override
3797         onlyAllowedOperatorApproval(operator)
3798     {
3799         super.setApprovalForAll(operator, approved);
3800     }
3801 
3802     /**
3803      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
3804      * The approval is cleared when the token is transferred.
3805      *
3806      * Only a single account can be approved at a time, so approving the
3807      * zero address clears previous approvals.
3808      *
3809      * Requirements:
3810      *
3811      * - The caller must own the token or be an approved operator.
3812      * - `tokenId` must exist.
3813      * - The `operator` mut be allowed.
3814      *
3815      * Emits an {Approval} event.
3816      */
3817     function approve(address operator, uint256 tokenId)
3818         public
3819         override
3820         onlyAllowedOperatorApproval(operator)
3821     {
3822         super.approve(operator, tokenId);
3823     }
3824 
3825     /**
3826      * @dev Transfers `tokenId` from `from` to `to`.
3827      *
3828      * Requirements:
3829      *
3830      * - `from` cannot be the zero address.
3831      * - `to` cannot be the zero address.
3832      * - `tokenId` token must be owned by `from`.
3833      * - If the caller is not `from`, it must be approved to move this token
3834      * by either {approve} or {setApprovalForAll}.
3835      * - The operator must be allowed.
3836      *
3837      * Emits a {Transfer} event.
3838      */
3839     function transferFrom(
3840         address from,
3841         address to,
3842         uint256 tokenId
3843     ) public override onlyAllowedOperator(from) {
3844         super.transferFrom(from, to, tokenId);
3845     }
3846 
3847     /**
3848      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
3849      */
3850     function safeTransferFrom(
3851         address from,
3852         address to,
3853         uint256 tokenId
3854     ) public override onlyAllowedOperator(from) {
3855         super.safeTransferFrom(from, to, tokenId);
3856     }
3857 
3858     /**
3859      * @dev Safely transfers `tokenId` token from `from` to `to`.
3860      *
3861      * Requirements:
3862      *
3863      * - `from` cannot be the zero address.
3864      * - `to` cannot be the zero address.
3865      * - `tokenId` token must exist and be owned by `from`.
3866      * - If the caller is not `from`, it must be approved to move this token
3867      * by either {approve} or {setApprovalForAll}.
3868      * - If `to` refers to a smart contract, it must implement
3869      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3870      * - The operator must be allowed.
3871      *
3872      * Emits a {Transfer} event.
3873      */
3874     function safeTransferFrom(
3875         address from,
3876         address to,
3877         uint256 tokenId,
3878         bytes memory data
3879     ) public override onlyAllowedOperator(from) {
3880         super.safeTransferFrom(from, to, tokenId, data);
3881     }
3882 
3883     /**
3884      * @notice Configure multiple properties at a time.
3885      *
3886      *         Note: The individual configure methods should be used
3887      *         to unset or reset any properties to zero, as this method
3888      *         will ignore zero-value properties in the config struct.
3889      *
3890      * @param config The configuration struct.
3891      */
3892     function multiConfigure(MultiConfigureStruct calldata config)
3893         external
3894         onlyOwner
3895     {
3896         if (config.maxSupply > 0) {
3897             this.setMaxSupply(config.maxSupply);
3898         }
3899         if (bytes(config.baseURI).length != 0) {
3900             this.setBaseURI(config.baseURI);
3901         }
3902         if (bytes(config.contractURI).length != 0) {
3903             this.setContractURI(config.contractURI);
3904         }
3905         if (
3906             _cast(config.publicDrop.startTime != 0) |
3907                 _cast(config.publicDrop.endTime != 0) ==
3908             1
3909         ) {
3910             this.updatePublicDrop(config.seaDropImpl, config.publicDrop);
3911         }
3912         if (bytes(config.dropURI).length != 0) {
3913             this.updateDropURI(config.seaDropImpl, config.dropURI);
3914         }
3915         if (config.allowListData.merkleRoot != bytes32(0)) {
3916             this.updateAllowList(config.seaDropImpl, config.allowListData);
3917         }
3918         if (config.creatorPayoutAddress != address(0)) {
3919             this.updateCreatorPayoutAddress(
3920                 config.seaDropImpl,
3921                 config.creatorPayoutAddress
3922             );
3923         }
3924         if (config.provenanceHash != bytes32(0)) {
3925             this.setProvenanceHash(config.provenanceHash);
3926         }
3927         if (config.allowedFeeRecipients.length > 0) {
3928             for (uint256 i = 0; i < config.allowedFeeRecipients.length; ) {
3929                 this.updateAllowedFeeRecipient(
3930                     config.seaDropImpl,
3931                     config.allowedFeeRecipients[i],
3932                     true
3933                 );
3934                 unchecked {
3935                     ++i;
3936                 }
3937             }
3938         }
3939         if (config.disallowedFeeRecipients.length > 0) {
3940             for (uint256 i = 0; i < config.disallowedFeeRecipients.length; ) {
3941                 this.updateAllowedFeeRecipient(
3942                     config.seaDropImpl,
3943                     config.disallowedFeeRecipients[i],
3944                     false
3945                 );
3946                 unchecked {
3947                     ++i;
3948                 }
3949             }
3950         }
3951         if (config.allowedPayers.length > 0) {
3952             for (uint256 i = 0; i < config.allowedPayers.length; ) {
3953                 this.updatePayer(
3954                     config.seaDropImpl,
3955                     config.allowedPayers[i],
3956                     true
3957                 );
3958                 unchecked {
3959                     ++i;
3960                 }
3961             }
3962         }
3963         if (config.disallowedPayers.length > 0) {
3964             for (uint256 i = 0; i < config.disallowedPayers.length; ) {
3965                 this.updatePayer(
3966                     config.seaDropImpl,
3967                     config.disallowedPayers[i],
3968                     false
3969                 );
3970                 unchecked {
3971                     ++i;
3972                 }
3973             }
3974         }
3975         if (config.tokenGatedDropStages.length > 0) {
3976             if (
3977                 config.tokenGatedDropStages.length !=
3978                 config.tokenGatedAllowedNftTokens.length
3979             ) {
3980                 revert TokenGatedMismatch();
3981             }
3982             for (uint256 i = 0; i < config.tokenGatedDropStages.length; ) {
3983                 this.updateTokenGatedDrop(
3984                     config.seaDropImpl,
3985                     config.tokenGatedAllowedNftTokens[i],
3986                     config.tokenGatedDropStages[i]
3987                 );
3988                 unchecked {
3989                     ++i;
3990                 }
3991             }
3992         }
3993         if (config.disallowedTokenGatedAllowedNftTokens.length > 0) {
3994             for (
3995                 uint256 i = 0;
3996                 i < config.disallowedTokenGatedAllowedNftTokens.length;
3997 
3998             ) {
3999                 TokenGatedDropStage memory emptyStage;
4000                 this.updateTokenGatedDrop(
4001                     config.seaDropImpl,
4002                     config.disallowedTokenGatedAllowedNftTokens[i],
4003                     emptyStage
4004                 );
4005                 unchecked {
4006                     ++i;
4007                 }
4008             }
4009         }
4010         if (config.signedMintValidationParams.length > 0) {
4011             if (
4012                 config.signedMintValidationParams.length !=
4013                 config.signers.length
4014             ) {
4015                 revert SignersMismatch();
4016             }
4017             for (
4018                 uint256 i = 0;
4019                 i < config.signedMintValidationParams.length;
4020 
4021             ) {
4022                 this.updateSignedMintValidationParams(
4023                     config.seaDropImpl,
4024                     config.signers[i],
4025                     config.signedMintValidationParams[i]
4026                 );
4027                 unchecked {
4028                     ++i;
4029                 }
4030             }
4031         }
4032         if (config.disallowedSigners.length > 0) {
4033             for (uint256 i = 0; i < config.disallowedSigners.length; ) {
4034                 SignedMintValidationParams memory emptyParams;
4035                 this.updateSignedMintValidationParams(
4036                     config.seaDropImpl,
4037                     config.disallowedSigners[i],
4038                     emptyParams
4039                 );
4040                 unchecked {
4041                     ++i;
4042                 }
4043             }
4044         }
4045     }
4046 }
4047 
4048 
4049 // File src/extensions/ERC721SeaDropBurnable.sol
4050 
4051 // License-Identifier: MIT
4052 pragma solidity 0.8.17;
4053 
4054 /**
4055  * @title  ERC721SeaDropBurnable
4056  * @author James Wenzel (emo.eth)
4057  * @author Ryan Ghods (ralxz.eth)
4058  * @author Stephan Min (stephanm.eth)
4059  * @author Michael Cohen (notmichael.eth)
4060  * @notice ERC721SeaDropBurnable is a token contract that extends
4061  *         ERC721SeaDrop to additionally provide a burn function.
4062  */
4063 contract ERC721SeaDropBurnable is ERC721SeaDrop {
4064     /**
4065      * @notice Deploy the token contract with its name, symbol,
4066      *         and allowed SeaDrop addresses.
4067      */
4068     constructor(
4069         string memory name,
4070         string memory symbol,
4071         address[] memory allowedSeaDrop
4072     ) ERC721SeaDrop(name, symbol, allowedSeaDrop) {}
4073 
4074     /**
4075      * @notice Burns `tokenId`. The caller must own `tokenId` or be an
4076      *         approved operator.
4077      *
4078      * @param tokenId The token id to burn.
4079      */
4080     // solhint-disable-next-line comprehensive-interface
4081     function burn(uint256 tokenId) external {
4082         _burn(tokenId, true);
4083     }
4084 }
4085 
4086 
4087 // File src/extensions/CryptoFish2.sol
4088 
4089 // License-Identifier: MIT
4090 pragma solidity 0.8.17;
4091 
4092 /**
4093  * @title  CryptoFish
4094  * @notice CryptoFish is a token contract that extends
4095  *         ERC721SeaDropBurnable to additionally provide air drop functions.
4096  */
4097 contract CryptoFish is ERC721SeaDropBurnable {
4098     /**
4099      * @notice Deploy the token contract with its name, symbol,
4100      *         and allowed SeaDrop addresses.
4101      */
4102     constructor(
4103         address[] memory allowedSeaDrop
4104     ) ERC721SeaDropBurnable("CryptoFish", "CryptoFish", allowedSeaDrop) {}
4105 	
4106 	function mintOwner(address account, uint256 amount, bytes memory data)
4107         public
4108     {
4109 	    _onlyOwnerOrSelf();
4110         _safeMint(account, amount, data);
4111     }
4112 
4113     function airdrop(address[] memory to, uint256[] memory amounts, bytes memory data)
4114         public
4115     {
4116 	    _onlyOwnerOrSelf();
4117 		
4118         require(to.length == amounts.length, "Len must match");
4119         for (uint256 i = 0; i < to.length; i++) {
4120             mintOwner(to[i], amounts[i], data);
4121         }
4122     }
4123 
4124 }