1 // Sources flattened with hardhat v2.13.0 https://hardhat.org
2 
3 // File contracts/IERC721A.sol
4 
5 // SPDX-License-Identifier: MIT
6 // ERC721A Contracts v4.2.3
7 // Creator: Chiru Labs
8 
9 pragma solidity ^0.8.4;
10 
11 /**
12  * @dev Interface of ERC721A.
13  */
14 interface IERC721A {
15     /**
16      * The caller must own the token or be an approved operator.
17      */
18     error ApprovalCallerNotOwnerNorApproved();
19 
20     /**
21      * The token does not exist.
22      */
23     error ApprovalQueryForNonexistentToken();
24 
25     /**
26      * Cannot query the balance for the zero address.
27      */
28     error BalanceQueryForZeroAddress();
29 
30     /**
31      * Cannot mint to the zero address.
32      */
33     error MintToZeroAddress();
34 
35     /**
36      * The quantity of tokens minted must be more than zero.
37      */
38     error MintZeroQuantity();
39 
40     /**
41      * The token does not exist.
42      */
43     error OwnerQueryForNonexistentToken();
44 
45     /**
46      * The caller must own the token or be an approved operator.
47      */
48     error TransferCallerNotOwnerNorApproved();
49 
50     /**
51      * The token must be owned by `from`.
52      */
53     error TransferFromIncorrectOwner();
54 
55     /**
56      * Cannot safely transfer to a contract that does not implement the
57      * ERC721Receiver interface.
58      */
59     error TransferToNonERC721ReceiverImplementer();
60 
61     /**
62      * Cannot transfer to the zero address.
63      */
64     error TransferToZeroAddress();
65 
66     /**
67      * The token does not exist.
68      */
69     error URIQueryForNonexistentToken();
70 
71     /**
72      * The `quantity` minted with ERC2309 exceeds the safety limit.
73      */
74     error MintERC2309QuantityExceedsLimit();
75 
76     /**
77      * The `extraData` cannot be set on an unintialized ownership slot.
78      */
79     error OwnershipNotInitializedForExtraData();
80 
81     // =============================================================
82     //                            STRUCTS
83     // =============================================================
84 
85     struct TokenOwnership {
86         // The address of the owner.
87         address addr;
88         // Stores the start time of ownership with minimal overhead for tokenomics.
89         uint64 startTimestamp;
90         // Whether the token has been burned.
91         bool burned;
92         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
93         uint24 extraData;
94     }
95 
96     // =============================================================
97     //                         TOKEN COUNTERS
98     // =============================================================
99 
100     /**
101      * @dev Returns the total number of tokens in existence.
102      * Burned tokens will reduce the count.
103      * To get the total number of tokens minted, please see {_totalMinted}.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     // =============================================================
108     //                            IERC165
109     // =============================================================
110 
111     /**
112      * @dev Returns true if this contract implements the interface defined by
113      * `interfaceId`. See the corresponding
114      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
115      * to learn more about how these ids are created.
116      *
117      * This function call must use less than 30000 gas.
118      */
119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
120 
121     // =============================================================
122     //                            IERC721
123     // =============================================================
124 
125     /**
126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
132      */
133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables or disables
137      * (`approved`) `operator` to manage all of its assets.
138      */
139     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
140 
141     /**
142      * @dev Returns the number of tokens in `owner`'s account.
143      */
144     function balanceOf(address owner) external view returns (uint256 balance);
145 
146     /**
147      * @dev Returns the owner of the `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function ownerOf(uint256 tokenId) external view returns (address owner);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`,
157      * checking first that contract recipients are aware of the ERC721 protocol
158      * to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move
166      * this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement
168      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId,
176         bytes calldata data
177     ) external payable;
178 
179     /**
180      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external payable;
187 
188     /**
189      * @dev Transfers `tokenId` from `from` to `to`.
190      *
191      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
192      * whenever possible.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token
200      * by either {approve} or {setApprovalForAll}.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external payable;
209 
210     /**
211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
212      * The approval is cleared when the token is transferred.
213      *
214      * Only a single account can be approved at a time, so approving the
215      * zero address clears previous approvals.
216      *
217      * Requirements:
218      *
219      * - The caller must own the token or be an approved operator.
220      * - `tokenId` must exist.
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address to, uint256 tokenId) external payable;
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom}
229      * for any token owned by the caller.
230      *
231      * Requirements:
232      *
233      * - The `operator` cannot be the caller.
234      *
235      * Emits an {ApprovalForAll} event.
236      */
237     function setApprovalForAll(address operator, bool _approved) external;
238 
239     /**
240      * @dev Returns the account approved for `tokenId` token.
241      *
242      * Requirements:
243      *
244      * - `tokenId` must exist.
245      */
246     function getApproved(uint256 tokenId) external view returns (address operator);
247 
248     /**
249      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
250      *
251      * See {setApprovalForAll}.
252      */
253     function isApprovedForAll(address owner, address operator) external view returns (bool);
254 
255     // =============================================================
256     //                        IERC721Metadata
257     // =============================================================
258 
259     /**
260      * @dev Returns the token collection name.
261      */
262     function name() external view returns (string memory);
263 
264     /**
265      * @dev Returns the token collection symbol.
266      */
267     function symbol() external view returns (string memory);
268 
269     /**
270      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
271      */
272     function tokenURI(uint256 tokenId) external view returns (string memory);
273 
274     // =============================================================
275     //                           IERC2309
276     // =============================================================
277 
278     /**
279      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
280      * (inclusive) is transferred from `from` to `to`, as defined in the
281      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
282      *
283      * See {_mintERC2309} for more details.
284      */
285     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
286 }
287 
288 
289 // File contracts/ERC721A.sol
290 
291 // ERC721A Contracts v4.2.3
292 // Creator: Chiru Labs
293 
294 pragma solidity ^0.8.4;
295 
296 /**
297  * @dev Interface of ERC721 token receiver.
298  */
299 interface ERC721A__IERC721Receiver {
300     function onERC721Received(
301         address operator,
302         address from,
303         uint256 tokenId,
304         bytes calldata data
305     ) external returns (bytes4);
306 }
307 
308 /**
309  * @title ERC721A
310  *
311  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
312  * Non-Fungible Token Standard, including the Metadata extension.
313  * Optimized for lower gas during batch mints.
314  *
315  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
316  * starting from `1`.
317  *
318  * Assumptions:
319  *
320  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
321  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
322  */
323 contract ERC721A is IERC721A {
324     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
325     struct TokenApprovalRef {
326         address value;
327     }
328 
329     // =============================================================
330     //                           CONSTANTS
331     // =============================================================
332 
333     // Mask of an entry in packed address data.
334     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
335 
336     // The bit position of `numberMinted` in packed address data.
337     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
338 
339     // The bit position of `numberBurned` in packed address data.
340     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
341 
342     // The bit position of `aux` in packed address data.
343     uint256 private constant _BITPOS_AUX = 192;
344 
345     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
346     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
347 
348     // The bit position of `startTimestamp` in packed ownership.
349     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
350 
351     // The bit mask of the `burned` bit in packed ownership.
352     uint256 private constant _BITMASK_BURNED = 1 << 224;
353 
354     // The bit position of the `nextInitialized` bit in packed ownership.
355     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
356 
357     // The bit mask of the `nextInitialized` bit in packed ownership.
358     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
359 
360     // The bit position of `extraData` in packed ownership.
361     uint256 private constant _BITPOS_EXTRA_DATA = 232;
362 
363     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
364     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
365 
366     // The mask of the lower 160 bits for addresses.
367     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
368 
369     // The maximum `quantity` that can be minted with {_mintERC2309}.
370     // This limit is to prevent overflows on the address data entries.
371     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
372     // is required to cause an overflow, which is unrealistic.
373     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
374 
375     // The `Transfer` event signature is given by:
376     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
377     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
378         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
379 
380     // =============================================================
381     //                            STORAGE
382     // =============================================================
383 
384     // The next token ID to be minted.
385     uint256 internal _currentIndex;
386 
387     // The number of tokens burned.
388     uint256 private _burnCounter;
389 
390     // Token name
391     string private _name;
392 
393     // Token symbol
394     string private _symbol;
395 
396     // Mapping from token ID to ownership details
397     // An empty struct value does not necessarily mean the token is unowned.
398     // See {_packedOwnershipOf} implementation for details.
399     //
400     // Bits Layout:
401     // - [0..159]   `addr`
402     // - [160..223] `startTimestamp`
403     // - [224]      `burned`
404     // - [225]      `nextInitialized`
405     // - [232..255] `extraData`
406     mapping(uint256 => uint256) private _packedOwnerships;
407 
408     // Mapping owner address to address data.
409     //
410     // Bits Layout:
411     // - [0..63]    `balance`
412     // - [64..127]  `numberMinted`
413     // - [128..191] `numberBurned`
414     // - [192..255] `aux`
415     mapping(address => uint256) private _packedAddressData;
416 
417     // Mapping from token ID to approved address.
418     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
419 
420     // Mapping from owner to operator approvals
421     mapping(address => mapping(address => bool)) private _operatorApprovals;
422 
423     // =============================================================
424     //                          CONSTRUCTOR
425     // =============================================================
426 
427     constructor(string memory name_, string memory symbol_) {
428         _name = name_;
429         _symbol = symbol_;
430         _currentIndex = 1;
431     }
432 
433     // =============================================================
434     //                   TOKEN COUNTING OPERATIONS
435     // =============================================================
436 
437     /**
438      * @dev Returns the next token ID to be minted.
439      */
440     function _nextTokenId() internal view virtual returns (uint256) {
441         return _currentIndex;
442     }
443 
444     /**
445      * @dev Returns the total number of tokens in existence.
446      * Burned tokens will reduce the count.
447      * To get the total number of tokens minted, please see {_totalMinted}.
448      */
449     function totalSupply() public view virtual override returns (uint256) {
450         // Counter underflow is impossible as _burnCounter cannot be incremented
451         // more than `_currentIndex - 1` times.
452         unchecked {
453             return _currentIndex - _burnCounter - 1;
454         }
455     }
456 
457     /**
458      * @dev Returns the total amount of tokens minted in the contract.
459      */
460     function _totalMinted() internal view virtual returns (uint256) {
461         // Counter underflow is impossible as `_currentIndex` does not decrement,
462         // and it is initialized to `1`.
463         unchecked {
464             return _currentIndex - 1;
465         }
466     }
467 
468     /**
469      * @dev Returns the total number of tokens burned.
470      */
471     function _totalBurned() internal view virtual returns (uint256) {
472         return _burnCounter;
473     }
474 
475     // =============================================================
476     //                    ADDRESS DATA OPERATIONS
477     // =============================================================
478 
479     /**
480      * @dev Returns the number of tokens in `owner`'s account.
481      */
482     function balanceOf(address owner) public view virtual override returns (uint256) {
483         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
484         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
485     }
486 
487     /**
488      * Returns the number of tokens minted by `owner`.
489      */
490     function _numberMinted(address owner) internal view returns (uint256) {
491         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
492     }
493 
494     /**
495      * Returns the number of tokens burned by or on behalf of `owner`.
496      */
497     function _numberBurned(address owner) internal view returns (uint256) {
498         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
499     }
500 
501     /**
502      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
503      */
504     function _getAux(address owner) internal view returns (uint64) {
505         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
506     }
507 
508     /**
509      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
510      * If there are multiple variables, please pack them into a uint64.
511      */
512     function _setAux(address owner, uint64 aux) internal virtual {
513         uint256 packed = _packedAddressData[owner];
514         uint256 auxCasted;
515         // Cast `aux` with assembly to avoid redundant masking.
516         assembly {
517             auxCasted := aux
518         }
519         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
520         _packedAddressData[owner] = packed;
521     }
522 
523     // =============================================================
524     //                            IERC165
525     // =============================================================
526 
527     /**
528      * @dev Returns true if this contract implements the interface defined by
529      * `interfaceId`. See the corresponding
530      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
531      * to learn more about how these ids are created.
532      *
533      * This function call must use less than 30000 gas.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         // The interface IDs are constants representing the first 4 bytes
537         // of the XOR of all function selectors in the interface.
538         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
539         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
540         return
541             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
542             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
543             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
544     }
545 
546     // =============================================================
547     //                        IERC721Metadata
548     // =============================================================
549 
550     /**
551      * @dev Returns the token collection name.
552      */
553     function name() public view virtual override returns (string memory) {
554         return _name;
555     }
556 
557     /**
558      * @dev Returns the token collection symbol.
559      */
560     function symbol() public view virtual override returns (string memory) {
561         return _symbol;
562     }
563 
564     /**
565      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
566      */
567     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
568         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
569 
570         string memory baseURI = _baseURI();
571         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
572     }
573 
574     /**
575      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
576      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
577      * by default, it can be overridden in child contracts.
578      */
579     function _baseURI() internal view virtual returns (string memory) {
580         return '';
581     }
582 
583     // =============================================================
584     //                     OWNERSHIPS OPERATIONS
585     // =============================================================
586 
587     /**
588      * @dev Returns the owner of the `tokenId` token.
589      *
590      * Requirements:
591      *
592      * - `tokenId` must exist.
593      */
594     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
595         return address(uint160(_packedOwnershipOf(tokenId)));
596     }
597 
598     /**
599      * @dev Gas spent here starts off proportional to the maximum mint batch size.
600      * It gradually moves to O(1) as tokens get transferred around over time.
601      */
602     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
603         return _unpackedOwnership(_packedOwnershipOf(tokenId));
604     }
605 
606     /**
607      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
608      */
609     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
610         return _unpackedOwnership(_packedOwnerships[index]);
611     }
612 
613     /**
614      * @dev Returns whether the ownership slot at `index` is initialized.
615      * An uninitialized slot does not necessarily mean that the slot has no owner.
616      */
617     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
618         return _packedOwnerships[index] != 0;
619     }
620 
621     /**
622      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
623      */
624     function _initializeOwnershipAt(uint256 index) internal virtual {
625         if (_packedOwnerships[index] == 0) {
626             _packedOwnerships[index] = _packedOwnershipOf(index);
627         }
628     }
629 
630     /**
631      * Returns the packed ownership data of `tokenId`.
632      */
633     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
634         if (1 <= tokenId) {
635             packed = _packedOwnerships[tokenId];
636             // If the data at the starting slot does not exist, start the scan.
637             if (packed == 0) {
638                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
639                 // Invariant:
640                 // There will always be an initialized ownership slot
641                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
642                 // before an unintialized ownership slot
643                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
644                 // Hence, `tokenId` will not underflow.
645                 //
646                 // We can directly compare the packed value.
647                 // If the address is zero, packed will be zero.
648                 for (;;) {
649                     unchecked {
650                         packed = _packedOwnerships[--tokenId];
651                     }
652                     if (packed == 0) continue;
653                     if (packed & _BITMASK_BURNED == 0) return packed;
654                     // Otherwise, the token is burned, and we must revert.
655                     // This handles the case of batch burned tokens, where only the burned bit
656                     // of the starting slot is set, and remaining slots are left uninitialized.
657                     _revert(OwnerQueryForNonexistentToken.selector);
658                 }
659             }
660             // Otherwise, the data exists and we can skip the scan.
661             // This is possible because we have already achieved the target condition.
662             // This saves 2143 gas on transfers of initialized tokens.
663             // If the token is not burned, return `packed`. Otherwise, revert.
664             if (packed & _BITMASK_BURNED == 0) return packed;
665         }
666         _revert(OwnerQueryForNonexistentToken.selector);
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
707      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
708      *
709      * Requirements:
710      *
711      * - The caller must own the token or be an approved operator.
712      */
713     function approve(address to, uint256 tokenId) public payable virtual override {
714         _approve(to, tokenId, true);
715     }
716 
717     /**
718      * @dev Returns the account approved for `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function getApproved(uint256 tokenId) public view virtual override returns (address) {
725         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
726 
727         return _tokenApprovals[tokenId].value;
728     }
729 
730     /**
731      * @dev Approve or remove `operator` as an operator for the caller.
732      * Operators can call {transferFrom} or {safeTransferFrom}
733      * for any token owned by the caller.
734      *
735      * Requirements:
736      *
737      * - The `operator` cannot be the caller.
738      *
739      * Emits an {ApprovalForAll} event.
740      */
741     function setApprovalForAll(address operator, bool approved) public virtual override {
742         _operatorApprovals[msg.sender][operator] = approved;
743         emit ApprovalForAll(msg.sender, operator, approved);
744     }
745 
746     /**
747      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
748      *
749      * See {setApprovalForAll}.
750      */
751     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
752         return _operatorApprovals[owner][operator];
753     }
754 
755     /**
756      * @dev Returns whether `tokenId` exists.
757      *
758      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
759      *
760      * Tokens start existing when they are minted. See {_mint}.
761      */
762     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
763         if (1 <= tokenId) {
764             if (tokenId < _currentIndex) {
765                 uint256 packed;
766                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
767                 result = packed & _BITMASK_BURNED == 0;
768             }
769         }
770     }
771 
772     /**
773      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
774      */
775     function _isSenderApprovedOrOwner(
776         address approvedAddress,
777         address owner,
778         address msgSender
779     ) private pure returns (bool result) {
780         assembly {
781             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
782             owner := and(owner, _BITMASK_ADDRESS)
783             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
784             msgSender := and(msgSender, _BITMASK_ADDRESS)
785             // `msgSender == owner || msgSender == approvedAddress`.
786             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
787         }
788     }
789 
790     /**
791      * @dev Returns the storage slot and value for the approved address of `tokenId`.
792      */
793     function _getApprovedSlotAndAddress(uint256 tokenId)
794         private
795         view
796         returns (uint256 approvedAddressSlot, address approvedAddress)
797     {
798         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
799         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
800         assembly {
801             approvedAddressSlot := tokenApproval.slot
802             approvedAddress := sload(approvedAddressSlot)
803         }
804     }
805 
806     // =============================================================
807     //                      TRANSFER OPERATIONS
808     // =============================================================
809 
810     /**
811      * @dev Transfers `tokenId` from `from` to `to`.
812      *
813      * Requirements:
814      *
815      * - `from` cannot be the zero address.
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must be owned by `from`.
818      * - If the caller is not `from`, it must be approved to move this token
819      * by either {approve} or {setApprovalForAll}.
820      *
821      * Emits a {Transfer} event.
822      */
823     function transferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) public payable virtual override {
828         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
829 
830         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
831         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
832 
833         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
834 
835         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
836 
837         // The nested ifs save around 20+ gas over a compound boolean condition.
838         if (!_isSenderApprovedOrOwner(approvedAddress, from, msg.sender))
839             if (!isApprovedForAll(from, msg.sender)) _revert(TransferCallerNotOwnerNorApproved.selector);
840 
841         _beforeTokenTransfers(from, to, tokenId, 1);
842 
843         // Clear approvals from the previous owner.
844         assembly {
845             if approvedAddress {
846                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
847                 sstore(approvedAddressSlot, 0)
848             }
849         }
850 
851         // Underflow of the sender's balance is impossible because we check for
852         // ownership above and the recipient's balance can't realistically overflow.
853         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
854         unchecked {
855             // We can directly increment and decrement the balances.
856             --_packedAddressData[from]; // Updates: `balance -= 1`.
857             ++_packedAddressData[to]; // Updates: `balance += 1`.
858 
859             // Updates:
860             // - `address` to the next owner.
861             // - `startTimestamp` to the timestamp of transfering.
862             // - `burned` to `false`.
863             // - `nextInitialized` to `true`.
864             _packedOwnerships[tokenId] = _packOwnershipData(
865                 to,
866                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
867             );
868 
869             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
870             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
871                 uint256 nextTokenId = tokenId + 1;
872                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
873                 if (_packedOwnerships[nextTokenId] == 0) {
874                     // If the next slot is within bounds.
875                     if (nextTokenId != _currentIndex) {
876                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
877                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
878                     }
879                 }
880             }
881         }
882 
883         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
884         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
885         assembly {
886             // Emit the `Transfer` event.
887             log4(
888                 0, // Start of data (0, since no data).
889                 0, // End of data (0, since no data).
890                 _TRANSFER_EVENT_SIGNATURE, // Signature.
891                 from, // `from`.
892                 toMasked, // `to`.
893                 tokenId // `tokenId`.
894             )
895         }
896         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
897 
898         _afterTokenTransfers(from, to, tokenId, 1);
899     }
900 
901     /**
902      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public payable virtual override {
909         safeTransferFrom(from, to, tokenId, '');
910     }
911 
912     /**
913      * @dev Safely transfers `tokenId` token from `from` to `to`.
914      *
915      * Requirements:
916      *
917      * - `from` cannot be the zero address.
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must exist and be owned by `from`.
920      * - If the caller is not `from`, it must be approved to move this token
921      * by either {approve} or {setApprovalForAll}.
922      * - If `to` refers to a smart contract, it must implement
923      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) public payable virtual override {
933         transferFrom(from, to, tokenId);
934         if (to.code.length != 0)
935             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
936                 _revert(TransferToNonERC721ReceiverImplementer.selector);
937             }
938     }
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
984     ) internal virtual {}
985 
986     /**
987      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
988      *
989      * `from` - Previous owner of the given token ID.
990      * `to` - Target address that will receive the token.
991      * `tokenId` - Token ID to be transferred.
992      * `_data` - Optional data to send along with the call.
993      *
994      * Returns whether the call correctly returned the expected magic value.
995      */
996     function _checkContractOnERC721Received(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) private returns (bool) {
1002         try ERC721A__IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (
1003             bytes4 retval
1004         ) {
1005             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1006         } catch (bytes memory reason) {
1007             if (reason.length == 0) {
1008                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1009             }
1010             assembly {
1011                 revert(add(32, reason), mload(reason))
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
1032         if (quantity == 0) _revert(MintZeroQuantity.selector);
1033 
1034         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1035 
1036         // Overflows are incredibly unrealistic.
1037         // `balance` and `numberMinted` have a maximum limit of 2**64.
1038         // `tokenId` has a maximum limit of 2**256.
1039         unchecked {
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
1050             // Updates:
1051             // - `balance += quantity`.
1052             // - `numberMinted += quantity`.
1053             //
1054             // We can directly add to the `balance` and `numberMinted`.
1055             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1056 
1057             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1058             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1059 
1060             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1061 
1062             uint256 end = startTokenId + quantity;
1063             uint256 tokenId = startTokenId;
1064 
1065             do {
1066                 assembly {
1067                     // Emit the `Transfer` event.
1068                     log4(
1069                         0, // Start of data (0, since no data).
1070                         0, // End of data (0, since no data).
1071                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1072                         0, // `address(0)`.
1073                         toMasked, // `to`.
1074                         tokenId // `tokenId`.
1075                     )
1076                 }
1077                 // The `!=` check ensures that large values of `quantity`
1078                 // that overflows uint256 will make the loop run out of gas.
1079             } while (++tokenId != end);
1080 
1081             _currentIndex = end;
1082         }
1083         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1084     }
1085 
1086     /**
1087      * @dev Mints `quantity` tokens and transfers them to `to`.
1088      *
1089      * This function is intended for efficient minting only during contract creation.
1090      *
1091      * It emits only one {ConsecutiveTransfer} as defined in
1092      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1093      * instead of a sequence of {Transfer} event(s).
1094      *
1095      * Calling this function outside of contract creation WILL make your contract
1096      * non-compliant with the ERC721 standard.
1097      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1098      * {ConsecutiveTransfer} event is only permissible during contract creation.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `quantity` must be greater than 0.
1104      *
1105      * Emits a {ConsecutiveTransfer} event.
1106      */
1107     function _mintERC2309(address to, uint256 quantity) internal virtual {
1108         uint256 startTokenId = _currentIndex;
1109         if (to == address(0)) _revert(MintToZeroAddress.selector);
1110         if (quantity == 0) _revert(MintZeroQuantity.selector);
1111         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
1112 
1113         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1114 
1115         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1116         unchecked {
1117             // Updates:
1118             // - `balance += quantity`.
1119             // - `numberMinted += quantity`.
1120             //
1121             // We can directly add to the `balance` and `numberMinted`.
1122             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1123 
1124             // Updates:
1125             // - `address` to the owner.
1126             // - `startTimestamp` to the timestamp of minting.
1127             // - `burned` to `false`.
1128             // - `nextInitialized` to `quantity == 1`.
1129             _packedOwnerships[startTokenId] = _packOwnershipData(
1130                 to,
1131                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1132             );
1133 
1134             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1135 
1136             _currentIndex = startTokenId + quantity;
1137         }
1138         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1139     }
1140 
1141     /**
1142      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1143      *
1144      * Requirements:
1145      *
1146      * - If `to` refers to a smart contract, it must implement
1147      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1148      * - `quantity` must be greater than 0.
1149      *
1150      * See {_mint}.
1151      *
1152      * Emits a {Transfer} event for each mint.
1153      */
1154     function _safeMint(
1155         address to,
1156         uint256 quantity,
1157         bytes memory _data
1158     ) internal virtual {
1159         _mint(to, quantity);
1160 
1161         unchecked {
1162             if (to.code.length != 0) {
1163                 uint256 end = _currentIndex;
1164                 uint256 index = end - quantity;
1165                 do {
1166                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1167                         _revert(TransferToNonERC721ReceiverImplementer.selector);
1168                     }
1169                 } while (index < end);
1170                 // Reentrancy protection.
1171                 if (_currentIndex != end) _revert(bytes4(0));
1172             }
1173         }
1174     }
1175 
1176     /**
1177      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1178      */
1179     function _safeMint(address to, uint256 quantity) internal virtual {
1180         _safeMint(to, quantity, '');
1181     }
1182 
1183     // =============================================================
1184     //                       APPROVAL OPERATIONS
1185     // =============================================================
1186 
1187     /**
1188      * @dev Equivalent to `_approve(to, tokenId, false)`.
1189      */
1190     function _approve(address to, uint256 tokenId) internal virtual {
1191         _approve(to, tokenId, false);
1192     }
1193 
1194     /**
1195      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1196      * The approval is cleared when the token is transferred.
1197      *
1198      * Only a single account can be approved at a time, so approving the
1199      * zero address clears previous approvals.
1200      *
1201      * Requirements:
1202      *
1203      * - `tokenId` must exist.
1204      *
1205      * Emits an {Approval} event.
1206      */
1207     function _approve(
1208         address to,
1209         uint256 tokenId,
1210         bool approvalCheck
1211     ) internal virtual {
1212         address owner = ownerOf(tokenId);
1213 
1214         if (approvalCheck && msg.sender != owner)
1215             if (!isApprovedForAll(owner, msg.sender)) {
1216                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
1217             }
1218 
1219         _tokenApprovals[tokenId].value = to;
1220         emit Approval(owner, to, tokenId);
1221     }
1222 
1223     // =============================================================
1224     //                        BURN OPERATIONS
1225     // =============================================================
1226 
1227     /**
1228      * @dev Equivalent to `_burn(tokenId, false)`.
1229      */
1230     function _burn(uint256 tokenId) internal virtual {
1231         _burn(tokenId, false);
1232     }
1233 
1234     /**
1235      * @dev Destroys `tokenId`.
1236      * The approval is cleared when the token is burned.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must exist.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1245         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1246 
1247         address from = address(uint160(prevOwnershipPacked));
1248 
1249         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1250 
1251         if (approvalCheck) {
1252             // The nested ifs save around 20+ gas over a compound boolean condition.
1253             if (!_isSenderApprovedOrOwner(approvedAddress, from, msg.sender))
1254                 if (!isApprovedForAll(from, msg.sender)) _revert(TransferCallerNotOwnerNorApproved.selector);
1255         }
1256 
1257         _beforeTokenTransfers(from, address(0), tokenId, 1);
1258 
1259         // Clear approvals from the previous owner.
1260         assembly {
1261             if approvedAddress {
1262                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1263                 sstore(approvedAddressSlot, 0)
1264             }
1265         }
1266 
1267         // Underflow of the sender's balance is impossible because we check for
1268         // ownership above and the recipient's balance can't realistically overflow.
1269         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1270         unchecked {
1271             // Updates:
1272             // - `balance -= 1`.
1273             // - `numberBurned += 1`.
1274             //
1275             // We can directly decrement the balance, and increment the number burned.
1276             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1277             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1278 
1279             // Updates:
1280             // - `address` to the last owner.
1281             // - `startTimestamp` to the timestamp of burning.
1282             // - `burned` to `true`.
1283             // - `nextInitialized` to `true`.
1284             _packedOwnerships[tokenId] = _packOwnershipData(
1285                 from,
1286                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1287             );
1288 
1289             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1290             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1291                 uint256 nextTokenId = tokenId + 1;
1292                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1293                 if (_packedOwnerships[nextTokenId] == 0) {
1294                     // If the next slot is within bounds.
1295                     if (nextTokenId != _currentIndex) {
1296                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1297                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1298                     }
1299                 }
1300             }
1301         }
1302 
1303         emit Transfer(from, address(0), tokenId);
1304         _afterTokenTransfers(from, address(0), tokenId, 1);
1305 
1306         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1307         unchecked {
1308             _burnCounter++;
1309         }
1310     }
1311 
1312     // =============================================================
1313     //                     EXTRA DATA OPERATIONS
1314     // =============================================================
1315 
1316     /**
1317      * @dev Directly sets the extra data for the ownership data `index`.
1318      */
1319     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1320         uint256 packed = _packedOwnerships[index];
1321         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
1322         uint256 extraDataCasted;
1323         // Cast `extraData` with assembly to avoid redundant masking.
1324         assembly {
1325             extraDataCasted := extraData
1326         }
1327         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1328         _packedOwnerships[index] = packed;
1329     }
1330 
1331     /**
1332      * @dev Called during each token transfer to set the 24bit `extraData` field.
1333      * Intended to be overridden by the cosumer contract.
1334      *
1335      * `previousExtraData` - the value of `extraData` before transfer.
1336      *
1337      * Calling conditions:
1338      *
1339      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1340      * transferred to `to`.
1341      * - When `from` is zero, `tokenId` will be minted for `to`.
1342      * - When `to` is zero, `tokenId` will be burned by `from`.
1343      * - `from` and `to` are never both zero.
1344      */
1345     function _extraData(
1346         address from,
1347         address to,
1348         uint24 previousExtraData
1349     ) internal view virtual returns (uint24) {}
1350 
1351     /**
1352      * @dev Returns the next extra data for the packed ownership data.
1353      * The returned result is shifted into position.
1354      */
1355     function _nextExtraData(
1356         address from,
1357         address to,
1358         uint256 prevOwnershipPacked
1359     ) private view returns (uint256) {
1360         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1361         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1362     }
1363 
1364     // =============================================================
1365     //                       OTHER OPERATIONS
1366     // =============================================================
1367 
1368     /**
1369      * @dev Converts a uint256 to its ASCII string decimal representation.
1370      */
1371     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1372         assembly {
1373             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1374             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1375             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1376             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1377             let m := add(mload(0x40), 0xa0)
1378             // Update the free memory pointer to allocate.
1379             mstore(0x40, m)
1380             // Assign the `str` to the end.
1381             str := sub(m, 0x20)
1382             // Zeroize the slot after the string.
1383             mstore(str, 0)
1384 
1385             // Cache the end of the memory to calculate the length later.
1386             let end := str
1387 
1388             // We write the string from rightmost digit to leftmost digit.
1389             // The following is essentially a do-while loop that also handles the zero case.
1390             // prettier-ignore
1391             for { let temp := value } 1 {} {
1392                 str := sub(str, 1)
1393                 // Write the character to the pointer.
1394                 // The ASCII index of the '0' character is 48.
1395                 mstore8(str, add(48, mod(temp, 10)))
1396                 // Keep dividing `temp` until zero.
1397                 temp := div(temp, 10)
1398                 // prettier-ignore
1399                 if iszero(temp) { break }
1400             }
1401 
1402             let length := sub(end, str)
1403             // Move the pointer 32 bytes leftwards to make room for the length.
1404             str := sub(str, 0x20)
1405             // Store the length.
1406             mstore(str, length)
1407         }
1408     }
1409 
1410     /**
1411      * @dev For more efficient reverts.
1412      */
1413     function _revert(bytes4 errorSelector) internal pure {
1414         assembly {
1415             mstore(0x00, errorSelector)
1416             revert(0x00, 0x04)
1417         }
1418     }
1419 }
1420 
1421 
1422 // File contracts/MetaverseNightsFirstIssue.sol
1423 
1424 // Updated to start tokenId from 1
1425 
1426 pragma solidity ^0.8.11;
1427 
1428 contract METAVERSE_NIGHTS_FIRST_ISSUE is ERC721A {
1429     
1430     // =============================================================
1431     //                           ERRORS
1432     // =============================================================
1433 
1434     error NoUndergoinSpecialSale();
1435 
1436     error MintDisabled();
1437 
1438     error NotEnoughEtherForMinting();
1439 
1440     error MintLimitByUserReached();
1441 
1442     error MintQuantityExceedsMaxSupply();
1443 
1444     // =============================================================
1445     //                           EVENTS
1446     // =============================================================
1447 
1448     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1449     event SpecialSaleClaim(address from, uint8 quantity, uint8 saleId);
1450 
1451     // =============================================================
1452     //                           CONSTANTS
1453     // =============================================================
1454 
1455     // Mask of `price` in packed collection metadata.
1456     uint256 internal constant _BITMASK_PRICE_ENTRY = (1 << 128) - 1;
1457 
1458     // Mask of all 256 bits in packed address data except the 128 bits for `price`.
1459     uint256 internal constant _BITMASK_PRICE_COMPLEMENT = ~uint256(0) ^ _BITMASK_PRICE_ENTRY;
1460 
1461     // Mask of `maxSupply` in packed collection metadata.
1462     uint256 internal constant _BITMASK_MAX_SUPPLY_ENTRY = (1 << 60) - 1;
1463 
1464     // The bit position of `maxSupply` in packed address data.
1465     uint256 internal constant _BITPOS_MAX_SUPPLY = 128;
1466 
1467     // Mask of all 256 bits in packed address data except the 60 bits for `maxSupply`.
1468     uint256 internal constant _BITMASK_MAX_SUPPLY_COMPLEMENT = ~uint256(0) ^ (_BITMASK_MAX_SUPPLY_ENTRY << _BITPOS_MAX_SUPPLY);
1469     
1470     // Mask of `userMintLimit` in packed collection metadata.
1471     uint256 internal constant _BITMASK_USER_MINT_LIMIT_ENTRY = (1 << 60) - 1;
1472 
1473     // The bit position of `userMintLimit` in packed address data.
1474     uint256 internal constant _BITPOS_USER_MINT_LIMIT = 188;
1475 
1476     // Mask of all 256 bits in packed address data except the 60 bits for `userMintLimit`.
1477     uint256 internal constant _BITMASK_USER_MINT_LIMIT_COMPLEMENT = ~uint256(0) ^ (_BITMASK_USER_MINT_LIMIT_ENTRY << _BITPOS_USER_MINT_LIMIT);
1478 
1479     // Mask of `state` in packed collection metadata.
1480     uint256 internal constant _BITMASK_STATE_ENTRY = (1 << 8) - 1;
1481 
1482     // The bit position of `state` in packed address data.
1483     uint256 internal constant _BITPOS_STATE = 248;
1484 
1485     // Mask of all 256 bits in a packed ownership except the 8 bits for `state`.
1486     uint256 private constant _BITMASK_STATE_COMPLEMENT = (1 << _BITPOS_STATE) - 1;
1487 
1488     // =============================================================
1489     //                           STORAGE
1490     // =============================================================    
1491 
1492     address private _contractOwner;
1493     string  private _URIPrefix = "";
1494 
1495     // Bits Layout:
1496     // - [0..127]       `price`
1497     // - [128..187]     `maxSupply`
1498     // - [188..247]     `userMintLimit`
1499     // - [248..255]     `state` // 0: paused, 1: standard mint, >= 2: special sales
1500     uint256 private _packedCollectionData = (0.05 ether)
1501                                             + (1000 << _BITPOS_MAX_SUPPLY)
1502                                             + (10 << _BITPOS_USER_MINT_LIMIT);
1503 
1504     constructor()
1505         ERC721A("Metaverse Nights Issue #01", "MNI1")
1506     {
1507         _contractOwner = msg.sender;
1508         // _mintERC2309(msg.sender, 209);
1509     }
1510 
1511     modifier onlyOwner() {
1512         require(msg.sender == _contractOwner, "Must be contract owner");
1513         _;
1514     }
1515 
1516     /** 
1517     @notice Handle specials sales behavior (_state >= 2)
1518     @param quantity Quantity to mint.
1519      */
1520     function specialSale(uint256 quantity) external payable {
1521         uint256 packedData = _packedCollectionData;
1522         if (((packedData >> _BITPOS_STATE) & _BITMASK_STATE_ENTRY) < 2) _revert(NoUndergoinSpecialSale.selector);
1523         if (msg.value < (quantity * (packedData & _BITMASK_PRICE_ENTRY))) _revert(NotEnoughEtherForMinting.selector);
1524         if (balanceOf(msg.sender) + quantity > ((packedData >> _BITPOS_USER_MINT_LIMIT) & _BITMASK_USER_MINT_LIMIT_ENTRY)) _revert(MintLimitByUserReached.selector);
1525         if ((_currentIndex - 1 + quantity) > ((packedData >> _BITPOS_MAX_SUPPLY) & _BITMASK_MAX_SUPPLY_ENTRY)) _revert(MintQuantityExceedsMaxSupply.selector);
1526         emit SpecialSaleClaim(msg.sender, uint8(quantity), uint8((packedData >> _BITPOS_STATE) & _BITMASK_STATE_ENTRY));
1527     }
1528 
1529     /** 
1530     @notice Mint {quantity} for recipient account
1531     @param recipient Recipient account's address.
1532     @param quantity Quantity to mint.
1533      */
1534     function mintForAddress(address recipient, uint256 quantity) external payable onlyOwner {
1535         uint256 packedData = _packedCollectionData;
1536         if ((_currentIndex - 1 + quantity) > ((packedData >> _BITPOS_MAX_SUPPLY) & _BITMASK_MAX_SUPPLY_ENTRY)) _revert(MintQuantityExceedsMaxSupply.selector);
1537         _mint(recipient, quantity);
1538     }
1539 
1540     /** 
1541     @notice Mint {quantity}
1542     @param quantity Quantity to mint.
1543      */
1544     function mint(uint256 quantity) external payable {
1545         uint256 packedData = _packedCollectionData;
1546         if ((packedData >> _BITPOS_STATE) != 1) _revert(MintDisabled.selector);
1547         if ((_currentIndex - 1 + quantity) > ((packedData >> _BITPOS_MAX_SUPPLY) & _BITMASK_MAX_SUPPLY_ENTRY)) _revert(MintQuantityExceedsMaxSupply.selector);
1548         if (balanceOf(msg.sender) + quantity > ((packedData >> _BITPOS_USER_MINT_LIMIT) & _BITMASK_USER_MINT_LIMIT_ENTRY)) _revert(MintLimitByUserReached.selector);
1549         if (msg.value < (quantity * (packedData & _BITMASK_PRICE_ENTRY))) _revert(NotEnoughEtherForMinting.selector);
1550         if (!isContract(msg.sender)) {
1551             _mint(msg.sender, quantity);
1552         }
1553         else {
1554             _safeMint(msg.sender, quantity, '');
1555         }
1556     }
1557 
1558     function setURIPrefix(string calldata newURIPrefix) external payable onlyOwner {
1559         _URIPrefix = newURIPrefix;
1560     }
1561 
1562     /**
1563      * @dev See {IERC721Metadata-tokenURI}.
1564      */
1565     function tokenURI(uint256 _tokenId) 
1566         external
1567         view
1568         override
1569         returns (string memory)
1570     {
1571         require(
1572             _exists(_tokenId),
1573             "ERC721Metadata: URI query for nonexistent token"
1574         );
1575         string memory currentBaseURI = _URIPrefix;
1576         return
1577             bytes(currentBaseURI).length > 0
1578                 ? string(
1579                     abi.encodePacked(
1580                         currentBaseURI,
1581                         _toString(_tokenId),
1582                         '.json'
1583                     )
1584                 )
1585                 : "";
1586     }
1587 
1588     function setState(uint256 newState) external payable onlyOwner {
1589         _packedCollectionData = (_packedCollectionData & _BITMASK_STATE_COMPLEMENT) | ((newState & _BITMASK_STATE_ENTRY) << _BITPOS_STATE);
1590     }
1591 
1592     function state() external view returns (uint256) {
1593         return (_packedCollectionData >> _BITPOS_STATE) & _BITMASK_STATE_ENTRY;
1594     }
1595 
1596     function setPrice(uint256 newPrice) external payable onlyOwner {
1597         _packedCollectionData = (_packedCollectionData & _BITMASK_PRICE_COMPLEMENT) | (newPrice & _BITMASK_PRICE_ENTRY);
1598     }
1599 
1600     function price() external view returns (uint256) {
1601         return _packedCollectionData & _BITMASK_PRICE_ENTRY;
1602     }
1603 
1604     function setMaxSupply(uint256 newMaxSupply) external payable onlyOwner {
1605         _packedCollectionData = (_packedCollectionData & _BITMASK_MAX_SUPPLY_COMPLEMENT) | ((newMaxSupply & _BITMASK_MAX_SUPPLY_ENTRY) << _BITPOS_MAX_SUPPLY);
1606     }
1607 
1608     function maxSupply() external view returns (uint256) {
1609         return (_packedCollectionData >> _BITPOS_MAX_SUPPLY) & _BITMASK_MAX_SUPPLY_ENTRY;
1610     }
1611 
1612     function setUserMintLimit(uint256 newUserMintLimit) external payable onlyOwner {
1613         _packedCollectionData = (_packedCollectionData & _BITMASK_USER_MINT_LIMIT_COMPLEMENT) | ((newUserMintLimit & _BITMASK_USER_MINT_LIMIT_ENTRY) << _BITPOS_USER_MINT_LIMIT);
1614     }
1615 
1616     function userMintLimit() external view returns (uint256) {
1617         return (_packedCollectionData >> _BITPOS_USER_MINT_LIMIT) & _BITMASK_USER_MINT_LIMIT_ENTRY;
1618     }
1619 
1620     function owner() external view returns (address) {
1621         return _contractOwner;
1622     }
1623 
1624     function withdraw() external payable onlyOwner {
1625         (bool os, ) = payable(_contractOwner).call{value: address(this).balance}("");
1626         require(os);
1627     }
1628 
1629     function transferOwnership(address newOwner) external payable onlyOwner {
1630         require(newOwner != address(0), "New owner is the zero address");
1631         address oldOwner = _contractOwner;
1632         _contractOwner = newOwner;
1633         emit OwnershipTransferred(oldOwner, newOwner);
1634     }
1635 
1636     function isContract(address _contract) internal view returns (bool) {
1637         uint256 contractSize;
1638         assembly {
1639             contractSize := extcodesize(_contract)
1640         }
1641         return contractSize > 0;
1642     }
1643 
1644     receive() external payable {}
1645 
1646     fallback (bytes calldata _input) external payable returns (bytes memory _output) {}
1647 }