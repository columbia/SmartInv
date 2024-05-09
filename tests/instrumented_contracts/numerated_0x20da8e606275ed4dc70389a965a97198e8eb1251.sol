1 // SPDX-License-Identifier: MIT
2 
3 //░██████╗░█████╗░███╗░░░███╗██╗░░░██╗██████╗░░█████╗░██╗  ██████╗░███████╗████████╗░██████╗
4 //██╔════╝██╔══██╗████╗░████║██║░░░██║██╔══██╗██╔══██╗██║  ██╔══██╗██╔════╝╚══██╔══╝██╔════╝
5 //╚█████╗░███████║██╔████╔██║██║░░░██║██████╔╝███████║██║  ██████╔╝█████╗░░░░░██║░░░╚█████╗░
6 //░╚═══██╗██╔══██║██║╚██╔╝██║██║░░░██║██╔══██╗██╔══██║██║  ██╔═══╝░██╔══╝░░░░░██║░░░░╚═══██╗
7 //██████╔╝██║░░██║██║░╚═╝░██║╚██████╔╝██║░░██║██║░░██║██║  ██║░░░░░███████╗░░░██║░░░██████╔╝
8 //╚═════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝  ╚═╝░░░░░╚══════╝░░░╚═╝░░░╚═════╝░
9 
10 pragma solidity ^0.8.7;
11 
12 /**
13  * @dev Interface of ERC721A.
14  */
15 interface IERC721A {
16     /**
17      * The caller must own the token or be an approved operator.
18      */
19     error ApprovalCallerNotOwnerNorApproved();
20 
21     /**
22      * The token does not exist.
23      */
24     error ApprovalQueryForNonexistentToken();
25 
26     /**
27      * Cannot query the balance for the zero address.
28      */
29     error BalanceQueryForZeroAddress();
30 
31     /**
32      * Cannot mint to the zero address.
33      */
34     error MintToZeroAddress();
35 
36     /**
37      * The quantity of tokens minted must be more than zero.
38      */
39     error MintZeroQuantity();
40 
41     /**
42      * The token does not exist.
43      */
44     error OwnerQueryForNonexistentToken();
45 
46     /**
47      * The caller must own the token or be an approved operator.
48      */
49     error TransferCallerNotOwnerNorApproved();
50 
51     /**
52      * The token must be owned by `from`.
53      */
54     error TransferFromIncorrectOwner();
55 
56     /**
57      * Cannot safely transfer to a contract that does not implement the
58      * ERC721Receiver interface.
59      */
60     error TransferToNonERC721ReceiverImplementer();
61 
62     /**
63      * Cannot transfer to the zero address.
64      */
65     error TransferToZeroAddress();
66 
67     /**
68      * The token does not exist.
69      */
70     error URIQueryForNonexistentToken();
71 
72     /**
73      * The `quantity` minted with ERC2309 exceeds the safety limit.
74      */
75     error MintERC2309QuantityExceedsLimit();
76 
77     /**
78      * The `extraData` cannot be set on an unintialized ownership slot.
79      */
80     error OwnershipNotInitializedForExtraData();
81 
82     // =============================================================
83     //                            STRUCTS
84     // =============================================================
85 
86     struct TokenOwnership {
87         // The address of the owner.
88         address addr;
89         // Stores the start time of ownership with minimal overhead for tokenomics.
90         uint64 startTimestamp;
91         // Whether the token has been burned.
92         bool burned;
93         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
94         uint24 extraData;
95     }
96 
97     // =============================================================
98     //                         TOKEN COUNTERS
99     // =============================================================
100 
101     /**
102      * @dev Returns the total number of tokens in existence.
103      * Burned tokens will reduce the count.
104      * To get the total number of tokens minted, please see {_totalMinted}.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     // =============================================================
109     //                            IERC165
110     // =============================================================
111 
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 
122     // =============================================================
123     //                            IERC721
124     // =============================================================
125 
126     /**
127      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
133      */
134     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables or disables
138      * (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in `owner`'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`,
158      * checking first that contract recipients are aware of the ERC721 protocol
159      * to prevent tokens from being forever locked.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be have been allowed to move
167      * this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement
169      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId,
177         bytes calldata data
178     ) external payable;
179 
180     /**
181      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external payable;
188 
189     /**
190      * @dev Transfers `tokenId` from `from` to `to`.
191      *
192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
193      * whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token
201      * by either {approve} or {setApprovalForAll}.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external payable;
210 
211     /**
212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
213      * The approval is cleared when the token is transferred.
214      *
215      * Only a single account can be approved at a time, so approving the
216      * zero address clears previous approvals.
217      *
218      * Requirements:
219      *
220      * - The caller must own the token or be an approved operator.
221      * - `tokenId` must exist.
222      *
223      * Emits an {Approval} event.
224      */
225     function approve(address to, uint256 tokenId) external payable;
226 
227     /**
228      * @dev Approve or remove `operator` as an operator for the caller.
229      * Operators can call {transferFrom} or {safeTransferFrom}
230      * for any token owned by the caller.
231      *
232      * Requirements:
233      *
234      * - The `operator` cannot be the caller.
235      *
236      * Emits an {ApprovalForAll} event.
237      */
238     function setApprovalForAll(address operator, bool _approved) external;
239 
240     /**
241      * @dev Returns the account approved for `tokenId` token.
242      *
243      * Requirements:
244      *
245      * - `tokenId` must exist.
246      */
247     function getApproved(uint256 tokenId) external view returns (address operator);
248 
249     /**
250      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
251      *
252      * See {setApprovalForAll}.
253      */
254     function isApprovedForAll(address owner, address operator) external view returns (bool);
255 
256     // =============================================================
257     //                        IERC721Metadata
258     // =============================================================
259 
260     /**
261      * @dev Returns the token collection name.
262      */
263     function name() external view returns (string memory);
264 
265     /**
266      * @dev Returns the token collection symbol.
267      */
268     function symbol() external view returns (string memory);
269 
270     /**
271      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
272      */
273     function tokenURI(uint256 tokenId) external view returns (string memory);
274 
275     // =============================================================
276     //                           IERC2309
277     // =============================================================
278 
279     /**
280      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
281      * (inclusive) is transferred from `from` to `to`, as defined in the
282      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
283      *
284      * See {_mintERC2309} for more details.
285      */
286     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
287 }
288 
289 /**
290  * @title ERC721A
291  *
292  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
293  * Non-Fungible Token Standard, including the Metadata extension.
294  * Optimized for lower gas during batch mints.
295  *
296  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
297  * starting from `_startTokenId()`.
298  *
299  * Assumptions:
300  *
301  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
302  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
303  */
304 interface ERC721A__IERC721Receiver {
305     function onERC721Received(
306         address operator,
307         address from,
308         uint256 tokenId,
309         bytes calldata data
310     ) external returns (bytes4);
311 }
312 
313 /**
314  * @title ERC721A
315  *
316  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
317  * Non-Fungible Token Standard, including the Metadata extension.
318  * Optimized for lower gas during batch mints.
319  *
320  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
321  * starting from `_startTokenId()`.
322  *
323  * Assumptions:
324  *
325  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
326  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
327  */
328 contract ERC721A is IERC721A {
329     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
330     struct TokenApprovalRef {
331         address value;
332     }
333 
334     // =============================================================
335     //                           CONSTANTS
336     // =============================================================
337 
338     // Mask of an entry in packed address data.
339     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
340 
341     // The bit position of `numberMinted` in packed address data.
342     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
343 
344     // The bit position of `numberBurned` in packed address data.
345     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
346 
347     // The bit position of `aux` in packed address data.
348     uint256 private constant _BITPOS_AUX = 192;
349 
350     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
351     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
352 
353     // The bit position of `startTimestamp` in packed ownership.
354     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
355 
356     // The bit mask of the `burned` bit in packed ownership.
357     uint256 private constant _BITMASK_BURNED = 1 << 224;
358 
359     // The bit position of the `nextInitialized` bit in packed ownership.
360     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
361 
362     // The bit mask of the `nextInitialized` bit in packed ownership.
363     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
364 
365     // The bit position of `extraData` in packed ownership.
366     uint256 private constant _BITPOS_EXTRA_DATA = 232;
367 
368     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
369     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
370 
371     // The mask of the lower 160 bits for addresses.
372     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
373 
374     // The maximum `quantity` that can be minted with {_mintERC2309}.
375     // This limit is to prevent overflows on the address data entries.
376     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
377     // is required to cause an overflow, which is unrealistic.
378     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
379 
380     // The `Transfer` event signature is given by:
381     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
382     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
383         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
384 
385     // =============================================================
386     //                            STORAGE
387     // =============================================================
388 
389     // The next token ID to be minted.
390     uint256 private _currentIndex;
391 
392     // The number of tokens burned.
393     uint256 private _burnCounter;
394 
395     // Token name
396     string private _name;
397 
398     // Token symbol
399     string private _symbol;
400 
401     // Mapping from token ID to ownership details
402     // An empty struct value does not necessarily mean the token is unowned.
403     // See {_packedOwnershipOf} implementation for details.
404     //
405     // Bits Layout:
406     // - [0..159]   `addr`
407     // - [160..223] `startTimestamp`
408     // - [224]      `burned`
409     // - [225]      `nextInitialized`
410     // - [232..255] `extraData`
411     mapping(uint256 => uint256) private _packedOwnerships;
412 
413     // Mapping owner address to address data.
414     //
415     // Bits Layout:
416     // - [0..63]    `balance`
417     // - [64..127]  `numberMinted`
418     // - [128..191] `numberBurned`
419     // - [192..255] `aux`
420     mapping(address => uint256) private _packedAddressData;
421 
422     // Mapping from token ID to approved address.
423     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
424 
425     // Mapping from owner to operator approvals
426     mapping(address => mapping(address => bool)) private _operatorApprovals;
427 
428     // =============================================================
429     //                          CONSTRUCTOR
430     // =============================================================
431 
432     constructor(string memory name_, string memory symbol_) {
433         _name = name_;
434         _symbol = symbol_;
435         _currentIndex = _startTokenId();
436     }
437 
438     // =============================================================
439     //                   TOKEN COUNTING OPERATIONS
440     // =============================================================
441 
442     /**
443      * @dev Returns the starting token ID.
444      * To change the starting token ID, please override this function.
445      */
446     function _startTokenId() internal view virtual returns (uint256) {
447         return 1;
448     }
449 
450     /**
451      * @dev Returns the next token ID to be minted.
452      */
453     function _nextTokenId() internal view virtual returns (uint256) {
454         return _currentIndex;
455     }
456 
457     /**
458      * @dev Returns the total number of tokens in existence.
459      * Burned tokens will reduce the count.
460      * To get the total number of tokens minted, please see {_totalMinted}.
461      */
462     function totalSupply() public view virtual override returns (uint256) {
463         // Counter underflow is impossible as _burnCounter cannot be incremented
464         // more than `_currentIndex - _startTokenId()` times.
465         unchecked {
466             return _currentIndex - _burnCounter - _startTokenId();
467         }
468     }
469 
470     /**
471      * @dev Returns the total amount of tokens minted in the contract.
472      */
473     function _totalMinted() internal view virtual returns (uint256) {
474         // Counter underflow is impossible as `_currentIndex` does not decrement,
475         // and it is initialized to `_startTokenId()`.
476         unchecked {
477             return _currentIndex - _startTokenId();
478         }
479     }
480 
481     /**
482      * @dev Returns the total number of tokens burned.
483      */
484     function _totalBurned() internal view virtual returns (uint256) {
485         return _burnCounter;
486     }
487 
488     // =============================================================
489     //                    ADDRESS DATA OPERATIONS
490     // =============================================================
491 
492     /**
493      * @dev Returns the number of tokens in `owner`'s account.
494      */
495     function balanceOf(address owner) public view virtual override returns (uint256) {
496         if (owner == address(0)) revert BalanceQueryForZeroAddress();
497         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
498     }
499 
500     /**
501      * Returns the number of tokens minted by `owner`.
502      */
503     function _numberMinted(address owner) internal view returns (uint256) {
504         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
505     }
506 
507     /**
508      * Returns the number of tokens burned by or on behalf of `owner`.
509      */
510     function _numberBurned(address owner) internal view returns (uint256) {
511         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
512     }
513 
514     /**
515      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
516      */
517     function _getAux(address owner) internal view returns (uint64) {
518         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
519     }
520 
521     /**
522      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
523      * If there are multiple variables, please pack them into a uint64.
524      */
525     function _setAux(address owner, uint64 aux) internal virtual {
526         uint256 packed = _packedAddressData[owner];
527         uint256 auxCasted;
528         // Cast `aux` with assembly to avoid redundant masking.
529         assembly {
530             auxCasted := aux
531         }
532         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
533         _packedAddressData[owner] = packed;
534     }
535 
536     // =============================================================
537     //                            IERC165
538     // =============================================================
539 
540     /**
541      * @dev Returns true if this contract implements the interface defined by
542      * `interfaceId`. See the corresponding
543      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
544      * to learn more about how these ids are created.
545      *
546      * This function call must use less than 30000 gas.
547      */
548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549         // The interface IDs are constants representing the first 4 bytes
550         // of the XOR of all function selectors in the interface.
551         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
552         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
553         return
554             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
555             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
556             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
557     }
558 
559     // =============================================================
560     //                        IERC721Metadata
561     // =============================================================
562 
563     /**
564      * @dev Returns the token collection name.
565      */
566     function name() public view virtual override returns (string memory) {
567         return _name;
568     }
569 
570     /**
571      * @dev Returns the token collection symbol.
572      */
573     function symbol() public view virtual override returns (string memory) {
574         return _symbol;
575     }
576 
577     /**
578      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
579      */
580     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
581         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
582 
583         string memory baseURI = _baseURI();
584         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
585     }
586 
587     /**
588      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
589      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
590      * by default, it can be overridden in child contracts.
591      */
592     function _baseURI() internal view virtual returns (string memory) {
593         return '';
594     }
595 
596     // =============================================================
597     //                     OWNERSHIPS OPERATIONS
598     // =============================================================
599 
600     /**
601      * @dev Returns the owner of the `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
608         return address(uint160(_packedOwnershipOf(tokenId)));
609     }
610 
611     /**
612      * @dev Gas spent here starts off proportional to the maximum mint batch size.
613      * It gradually moves to O(1) as tokens get transferred around over time.
614      */
615     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
616         return _unpackedOwnership(_packedOwnershipOf(tokenId));
617     }
618 
619     /**
620      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
621      */
622     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
623         return _unpackedOwnership(_packedOwnerships[index]);
624     }
625 
626     /**
627      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
628      */
629     function _initializeOwnershipAt(uint256 index) internal virtual {
630         if (_packedOwnerships[index] == 0) {
631             _packedOwnerships[index] = _packedOwnershipOf(index);
632         }
633     }
634 
635     /**
636      * Returns the packed ownership data of `tokenId`.
637      */
638     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
639         uint256 curr = tokenId;
640 
641         unchecked {
642             if (_startTokenId() <= curr)
643                 if (curr < _currentIndex) {
644                     uint256 packed = _packedOwnerships[curr];
645                     // If not burned.
646                     if (packed & _BITMASK_BURNED == 0) {
647                         // Invariant:
648                         // There will always be an initialized ownership slot
649                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
650                         // before an unintialized ownership slot
651                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
652                         // Hence, `curr` will not underflow.
653                         //
654                         // We can directly compare the packed value.
655                         // If the address is zero, packed will be zero.
656                         while (packed == 0) {
657                             packed = _packedOwnerships[--curr];
658                         }
659                         return packed;
660                     }
661                 }
662         }
663         revert OwnerQueryForNonexistentToken();
664     }
665 
666     /**
667      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
668      */
669     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
670         ownership.addr = address(uint160(packed));
671         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
672         ownership.burned = packed & _BITMASK_BURNED != 0;
673         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
674     }
675 
676     /**
677      * @dev Packs ownership data into a single uint256.
678      */
679     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
680         assembly {
681             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
682             owner := and(owner, _BITMASK_ADDRESS)
683             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
684             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
685         }
686     }
687 
688     /**
689      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
690      */
691     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
692         // For branchless setting of the `nextInitialized` flag.
693         assembly {
694             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
695             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
696         }
697     }
698 
699     // =============================================================
700     //                      APPROVAL OPERATIONS
701     // =============================================================
702 
703     /**
704      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
705      * The approval is cleared when the token is transferred.
706      *
707      * Only a single account can be approved at a time, so approving the
708      * zero address clears previous approvals.
709      *
710      * Requirements:
711      *
712      * - The caller must own the token or be an approved operator.
713      * - `tokenId` must exist.
714      *
715      * Emits an {Approval} event.
716      */
717     function approve(address to, uint256 tokenId) public payable virtual override {
718         address owner = ownerOf(tokenId);
719 
720         if (_msgSenderERC721A() != owner)
721             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
722                 revert ApprovalCallerNotOwnerNorApproved();
723             }
724 
725         _tokenApprovals[tokenId].value = to;
726         emit Approval(owner, to, tokenId);
727     }
728 
729     /**
730      * @dev Returns the account approved for `tokenId` token.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function getApproved(uint256 tokenId) public view virtual override returns (address) {
737         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
738 
739         return _tokenApprovals[tokenId].value;
740     }
741 
742     /**
743      * @dev Approve or remove `operator` as an operator for the caller.
744      * Operators can call {transferFrom} or {safeTransferFrom}
745      * for any token owned by the caller.
746      *
747      * Requirements:
748      *
749      * - The `operator` cannot be the caller.
750      *
751      * Emits an {ApprovalForAll} event.
752      */
753     function setApprovalForAll(address operator, bool approved) public virtual override {
754         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
755         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
756     }
757 
758     /**
759      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
760      *
761      * See {setApprovalForAll}.
762      */
763     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
764         return _operatorApprovals[owner][operator];
765     }
766 
767     /**
768      * @dev Returns whether `tokenId` exists.
769      *
770      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
771      *
772      * Tokens start existing when they are minted. See {_mint}.
773      */
774     function _exists(uint256 tokenId) internal view virtual returns (bool) {
775         return
776             _startTokenId() <= tokenId &&
777             tokenId < _currentIndex && // If within bounds,
778             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
779     }
780 
781     /**
782      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
783      */
784     function _isSenderApprovedOrOwner(
785         address approvedAddress,
786         address owner,
787         address msgSender
788     ) private pure returns (bool result) {
789         assembly {
790             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
791             owner := and(owner, _BITMASK_ADDRESS)
792             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
793             msgSender := and(msgSender, _BITMASK_ADDRESS)
794             // `msgSender == owner || msgSender == approvedAddress`.
795             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
796         }
797     }
798 
799     /**
800      * @dev Returns the storage slot and value for the approved address of `tokenId`.
801      */
802     function _getApprovedSlotAndAddress(uint256 tokenId)
803         private
804         view
805         returns (uint256 approvedAddressSlot, address approvedAddress)
806     {
807         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
808         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
809         assembly {
810             approvedAddressSlot := tokenApproval.slot
811             approvedAddress := sload(approvedAddressSlot)
812         }
813     }
814 
815     // =============================================================
816     //                      TRANSFER OPERATIONS
817     // =============================================================
818 
819     /**
820      * @dev Transfers `tokenId` from `from` to `to`.
821      *
822      * Requirements:
823      *
824      * - `from` cannot be the zero address.
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must be owned by `from`.
827      * - If the caller is not `from`, it must be approved to move this token
828      * by either {approve} or {setApprovalForAll}.
829      *
830      * Emits a {Transfer} event.
831      */
832     function transferFrom(
833         address from,
834         address to,
835         uint256 tokenId
836     ) public payable virtual override {
837         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
838 
839         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
840 
841         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
842 
843         // The nested ifs save around 20+ gas over a compound boolean condition.
844         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
845             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
846 
847         if (to == address(0)) revert TransferToZeroAddress();
848 
849         _beforeTokenTransfers(from, to, tokenId, 1);
850 
851         // Clear approvals from the previous owner.
852         assembly {
853             if approvedAddress {
854                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
855                 sstore(approvedAddressSlot, 0)
856             }
857         }
858 
859         // Underflow of the sender's balance is impossible because we check for
860         // ownership above and the recipient's balance can't realistically overflow.
861         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
862         unchecked {
863             // We can directly increment and decrement the balances.
864             --_packedAddressData[from]; // Updates: `balance -= 1`.
865             ++_packedAddressData[to]; // Updates: `balance += 1`.
866 
867             // Updates:
868             // - `address` to the next owner.
869             // - `startTimestamp` to the timestamp of transfering.
870             // - `burned` to `false`.
871             // - `nextInitialized` to `true`.
872             _packedOwnerships[tokenId] = _packOwnershipData(
873                 to,
874                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
875             );
876 
877             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
878             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
879                 uint256 nextTokenId = tokenId + 1;
880                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
881                 if (_packedOwnerships[nextTokenId] == 0) {
882                     // If the next slot is within bounds.
883                     if (nextTokenId != _currentIndex) {
884                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
885                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
886                     }
887                 }
888             }
889         }
890 
891         emit Transfer(from, to, tokenId);
892         _afterTokenTransfers(from, to, tokenId, 1);
893     }
894 
895     /**
896      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) public payable virtual override {
903         safeTransferFrom(from, to, tokenId, '');
904     }
905 
906     /**
907      * @dev Safely transfers `tokenId` token from `from` to `to`.
908      *
909      * Requirements:
910      *
911      * - `from` cannot be the zero address.
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must exist and be owned by `from`.
914      * - If the caller is not `from`, it must be approved to move this token
915      * by either {approve} or {setApprovalForAll}.
916      * - If `to` refers to a smart contract, it must implement
917      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
918      *
919      * Emits a {Transfer} event.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) public payable virtual override {
927         transferFrom(from, to, tokenId);
928         if (to.code.length != 0)
929             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
930                 revert TransferToNonERC721ReceiverImplementer();
931             }
932     }
933 
934     /**
935      * @dev Hook that is called before a set of serially-ordered token IDs
936      * are about to be transferred. This includes minting.
937      * And also called before burning one token.
938      *
939      * `startTokenId` - the first token ID to be transferred.
940      * `quantity` - the amount to be transferred.
941      *
942      * Calling conditions:
943      *
944      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
945      * transferred to `to`.
946      * - When `from` is zero, `tokenId` will be minted for `to`.
947      * - When `to` is zero, `tokenId` will be burned by `from`.
948      * - `from` and `to` are never both zero.
949      */
950     function _beforeTokenTransfers(
951         address from,
952         address to,
953         uint256 startTokenId,
954         uint256 quantity
955     ) internal virtual {}
956 
957     /**
958      * @dev Hook that is called after a set of serially-ordered token IDs
959      * have been transferred. This includes minting.
960      * And also called after one token has been burned.
961      *
962      * `startTokenId` - the first token ID to be transferred.
963      * `quantity` - the amount to be transferred.
964      *
965      * Calling conditions:
966      *
967      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
968      * transferred to `to`.
969      * - When `from` is zero, `tokenId` has been minted for `to`.
970      * - When `to` is zero, `tokenId` has been burned by `from`.
971      * - `from` and `to` are never both zero.
972      */
973     function _afterTokenTransfers(
974         address from,
975         address to,
976         uint256 startTokenId,
977         uint256 quantity
978     ) internal virtual {}
979 
980     /**
981      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
982      *
983      * `from` - Previous owner of the given token ID.
984      * `to` - Target address that will receive the token.
985      * `tokenId` - Token ID to be transferred.
986      * `_data` - Optional data to send along with the call.
987      *
988      * Returns whether the call correctly returned the expected magic value.
989      */
990     function _checkContractOnERC721Received(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) private returns (bool) {
996         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
997             bytes4 retval
998         ) {
999             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1000         } catch (bytes memory reason) {
1001             if (reason.length == 0) {
1002                 revert TransferToNonERC721ReceiverImplementer();
1003             } else {
1004                 assembly {
1005                     revert(add(32, reason), mload(reason))
1006                 }
1007             }
1008         }
1009     }
1010 
1011     // =============================================================
1012     //                        MINT OPERATIONS
1013     // =============================================================
1014 
1015     /**
1016      * @dev Mints `quantity` tokens and transfers them to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `quantity` must be greater than 0.
1022      *
1023      * Emits a {Transfer} event for each mint.
1024      */
1025     function _mint(address to, uint256 quantity) internal virtual {
1026         uint256 startTokenId = _currentIndex;
1027         if (quantity == 0) revert MintZeroQuantity();
1028 
1029         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1030 
1031         // Overflows are incredibly unrealistic.
1032         // `balance` and `numberMinted` have a maximum limit of 2**64.
1033         // `tokenId` has a maximum limit of 2**256.
1034         unchecked {
1035             // Updates:
1036             // - `balance += quantity`.
1037             // - `numberMinted += quantity`.
1038             //
1039             // We can directly add to the `balance` and `numberMinted`.
1040             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1041 
1042             // Updates:
1043             // - `address` to the owner.
1044             // - `startTimestamp` to the timestamp of minting.
1045             // - `burned` to `false`.
1046             // - `nextInitialized` to `quantity == 1`.
1047             _packedOwnerships[startTokenId] = _packOwnershipData(
1048                 to,
1049                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1050             );
1051 
1052             uint256 toMasked;
1053             uint256 end = startTokenId + quantity;
1054 
1055             // Use assembly to loop and emit the `Transfer` event for gas savings.
1056             // The duplicated `log4` removes an extra check and reduces stack juggling.
1057             // The assembly, together with the surrounding Solidity code, have been
1058             // delicately arranged to nudge the compiler into producing optimized opcodes.
1059             assembly {
1060                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1061                 toMasked := and(to, _BITMASK_ADDRESS)
1062                 // Emit the `Transfer` event.
1063                 log4(
1064                     0, // Start of data (0, since no data).
1065                     0, // End of data (0, since no data).
1066                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1067                     0, // `address(0)`.
1068                     toMasked, // `to`.
1069                     startTokenId // `tokenId`.
1070                 )
1071 
1072                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1073                 // that overflows uint256 will make the loop run out of gas.
1074                 // The compiler will optimize the `iszero` away for performance.
1075                 for {
1076                     let tokenId := add(startTokenId, 1)
1077                 } iszero(eq(tokenId, end)) {
1078                     tokenId := add(tokenId, 1)
1079                 } {
1080                     // Emit the `Transfer` event. Similar to above.
1081                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1082                 }
1083             }
1084             if (toMasked == 0) revert MintToZeroAddress();
1085 
1086             _currentIndex = end;
1087         }
1088         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1089     }
1090 
1091     /**
1092      * @dev Mints `quantity` tokens and transfers them to `to`.
1093      *
1094      * This function is intended for efficient minting only during contract creation.
1095      *
1096      * It emits only one {ConsecutiveTransfer} as defined in
1097      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1098      * instead of a sequence of {Transfer} event(s).
1099      *
1100      * Calling this function outside of contract creation WILL make your contract
1101      * non-compliant with the ERC721 standard.
1102      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1103      * {ConsecutiveTransfer} event is only permissible during contract creation.
1104      *
1105      * Requirements:
1106      *
1107      * - `to` cannot be the zero address.
1108      * - `quantity` must be greater than 0.
1109      *
1110      * Emits a {ConsecutiveTransfer} event.
1111      */
1112     function _mintERC2309(address to, uint256 quantity) internal virtual {
1113         uint256 startTokenId = _currentIndex;
1114         if (to == address(0)) revert MintToZeroAddress();
1115         if (quantity == 0) revert MintZeroQuantity();
1116         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1117 
1118         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1119 
1120         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1121         unchecked {
1122             // Updates:
1123             // - `balance += quantity`.
1124             // - `numberMinted += quantity`.
1125             //
1126             // We can directly add to the `balance` and `numberMinted`.
1127             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1128 
1129             // Updates:
1130             // - `address` to the owner.
1131             // - `startTimestamp` to the timestamp of minting.
1132             // - `burned` to `false`.
1133             // - `nextInitialized` to `quantity == 1`.
1134             _packedOwnerships[startTokenId] = _packOwnershipData(
1135                 to,
1136                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1137             );
1138 
1139             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1140 
1141             _currentIndex = startTokenId + quantity;
1142         }
1143         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1144     }
1145 
1146     /**
1147      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1148      *
1149      * Requirements:
1150      *
1151      * - If `to` refers to a smart contract, it must implement
1152      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1153      * - `quantity` must be greater than 0.
1154      *
1155      * See {_mint}.
1156      *
1157      * Emits a {Transfer} event for each mint.
1158      */
1159     function _safeMint(
1160         address to,
1161         uint256 quantity,
1162         bytes memory _data
1163     ) internal virtual {
1164         _mint(to, quantity);
1165 
1166         unchecked {
1167             if (to.code.length != 0) {
1168                 uint256 end = _currentIndex;
1169                 uint256 index = end - quantity;
1170                 do {
1171                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1172                         revert TransferToNonERC721ReceiverImplementer();
1173                     }
1174                 } while (index < end);
1175                 // Reentrancy protection.
1176                 if (_currentIndex != end) revert();
1177             }
1178         }
1179     }
1180 
1181     /**
1182      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1183      */
1184     function _safeMint(address to, uint256 quantity) internal virtual {
1185         _safeMint(to, quantity, '');
1186     }
1187 
1188     // =============================================================
1189     //                        BURN OPERATIONS
1190     // =============================================================
1191 
1192     /**
1193      * @dev Equivalent to `_burn(tokenId, false)`.
1194      */
1195     function _burn(uint256 tokenId) internal virtual {
1196         _burn(tokenId, false);
1197     }
1198 
1199     /**
1200      * @dev Destroys `tokenId`.
1201      * The approval is cleared when the token is burned.
1202      *
1203      * Requirements:
1204      *
1205      * - `tokenId` must exist.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1210         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1211 
1212         address from = address(uint160(prevOwnershipPacked));
1213 
1214         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1215 
1216         if (approvalCheck) {
1217             // The nested ifs save around 20+ gas over a compound boolean condition.
1218             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1219                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1220         }
1221 
1222         _beforeTokenTransfers(from, address(0), tokenId, 1);
1223 
1224         // Clear approvals from the previous owner.
1225         assembly {
1226             if approvedAddress {
1227                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1228                 sstore(approvedAddressSlot, 0)
1229             }
1230         }
1231 
1232         // Underflow of the sender's balance is impossible because we check for
1233         // ownership above and the recipient's balance can't realistically overflow.
1234         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1235         unchecked {
1236             // Updates:
1237             // - `balance -= 1`.
1238             // - `numberBurned += 1`.
1239             //
1240             // We can directly decrement the balance, and increment the number burned.
1241             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1242             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1243 
1244             // Updates:
1245             // - `address` to the last owner.
1246             // - `startTimestamp` to the timestamp of burning.
1247             // - `burned` to `true`.
1248             // - `nextInitialized` to `true`.
1249             _packedOwnerships[tokenId] = _packOwnershipData(
1250                 from,
1251                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1252             );
1253 
1254             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1255             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1256                 uint256 nextTokenId = tokenId + 1;
1257                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1258                 if (_packedOwnerships[nextTokenId] == 0) {
1259                     // If the next slot is within bounds.
1260                     if (nextTokenId != _currentIndex) {
1261                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1262                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1263                     }
1264                 }
1265             }
1266         }
1267 
1268         emit Transfer(from, address(0), tokenId);
1269         _afterTokenTransfers(from, address(0), tokenId, 1);
1270 
1271         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1272         unchecked {
1273             _burnCounter++;
1274         }
1275     }
1276 
1277     // =============================================================
1278     //                     EXTRA DATA OPERATIONS
1279     // =============================================================
1280 
1281     /**
1282      * @dev Directly sets the extra data for the ownership data `index`.
1283      */
1284     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1285         uint256 packed = _packedOwnerships[index];
1286         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1287         uint256 extraDataCasted;
1288         // Cast `extraData` with assembly to avoid redundant masking.
1289         assembly {
1290             extraDataCasted := extraData
1291         }
1292         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1293         _packedOwnerships[index] = packed;
1294     }
1295 
1296     /**
1297      * @dev Called during each token transfer to set the 24bit `extraData` field.
1298      * Intended to be overridden by the cosumer contract.
1299      *
1300      * `previousExtraData` - the value of `extraData` before transfer.
1301      *
1302      * Calling conditions:
1303      *
1304      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1305      * transferred to `to`.
1306      * - When `from` is zero, `tokenId` will be minted for `to`.
1307      * - When `to` is zero, `tokenId` will be burned by `from`.
1308      * - `from` and `to` are never both zero.
1309      */
1310     function _extraData(
1311         address from,
1312         address to,
1313         uint24 previousExtraData
1314     ) internal view virtual returns (uint24) {}
1315 
1316     /**
1317      * @dev Returns the next extra data for the packed ownership data.
1318      * The returned result is shifted into position.
1319      */
1320     function _nextExtraData(
1321         address from,
1322         address to,
1323         uint256 prevOwnershipPacked
1324     ) private view returns (uint256) {
1325         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1326         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1327     }
1328 
1329     // =============================================================
1330     //                       OTHER OPERATIONS
1331     // =============================================================
1332 
1333     /**
1334      * @dev Returns the message sender (defaults to `msg.sender`).
1335      *
1336      * If you are writing GSN compatible contracts, you need to override this function.
1337      */
1338     function _msgSenderERC721A() internal view virtual returns (address) {
1339         return msg.sender;
1340     }
1341 
1342     /**
1343      * @dev Converts a uint256 to its ASCII string decimal representation.
1344      */
1345     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1346         assembly {
1347             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1348             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1349             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1350             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1351             let m := add(mload(0x40), 0xa0)
1352             // Update the free memory pointer to allocate.
1353             mstore(0x40, m)
1354             // Assign the `str` to the end.
1355             str := sub(m, 0x20)
1356             // Zeroize the slot after the string.
1357             mstore(str, 0)
1358 
1359             // Cache the end of the memory to calculate the length later.
1360             let end := str
1361 
1362             // We write the string from rightmost digit to leftmost digit.
1363             // The following is essentially a do-while loop that also handles the zero case.
1364             // prettier-ignore
1365             for { let temp := value } 1 {} {
1366                 str := sub(str, 1)
1367                 // Write the character to the pointer.
1368                 // The ASCII index of the '0' character is 48.
1369                 mstore8(str, add(48, mod(temp, 10)))
1370                 // Keep dividing `temp` until zero.
1371                 temp := div(temp, 10)
1372                 // prettier-ignore
1373                 if iszero(temp) { break }
1374             }
1375 
1376             let length := sub(end, str)
1377             // Move the pointer 32 bytes leftwards to make room for the length.
1378             str := sub(str, 0x20)
1379             // Store the length.
1380             mstore(str, length)
1381         }
1382     }
1383 }
1384 
1385 
1386 interface IOperatorFilterRegistry {
1387     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1388     function register(address registrant) external;
1389     function registerAndSubscribe(address registrant, address subscription) external;
1390     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1391     function unregister(address addr) external;
1392     function updateOperator(address registrant, address operator, bool filtered) external;
1393     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1394     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1395     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1396     function subscribe(address registrant, address registrantToSubscribe) external;
1397     function unsubscribe(address registrant, bool copyExistingEntries) external;
1398     function subscriptionOf(address addr) external returns (address registrant);
1399     function subscribers(address registrant) external returns (address[] memory);
1400     function subscriberAt(address registrant, uint256 index) external returns (address);
1401     function copyEntriesOf(address registrant, address registrantToCopy) external;
1402     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1403     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1404     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1405     function filteredOperators(address addr) external returns (address[] memory);
1406     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1407     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1408     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1409     function isRegistered(address addr) external returns (bool);
1410     function codeHashOf(address addr) external returns (bytes32);
1411 }
1412 
1413 
1414 /**
1415  * @title  OperatorFilterer
1416  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1417  *         registrant's entries in the OperatorFilterRegistry.
1418  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1419  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1420  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1421  */
1422 abstract contract OperatorFilterer {
1423     error OperatorNotAllowed(address operator);
1424 
1425     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1426         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1427 
1428     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1429         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1430         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1431         // order for the modifier to filter addresses.
1432         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1433             if (subscribe) {
1434                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1435             } else {
1436                 if (subscriptionOrRegistrantToCopy != address(0)) {
1437                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1438                 } else {
1439                     OPERATOR_FILTER_REGISTRY.register(address(this));
1440                 }
1441             }
1442         }
1443     }
1444 
1445     modifier onlyAllowedOperator(address from) virtual {
1446         // Check registry code length to facilitate testing in environments without a deployed registry.
1447         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1448             // Allow spending tokens from addresses with balance
1449             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1450             // from an EOA.
1451             if (from == msg.sender) {
1452                 _;
1453                 return;
1454             }
1455             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1456                 revert OperatorNotAllowed(msg.sender);
1457             }
1458         }
1459         _;
1460     }
1461 
1462     modifier onlyAllowedOperatorApproval(address operator) virtual {
1463         // Check registry code length to facilitate testing in environments without a deployed registry.
1464         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1465             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1466                 revert OperatorNotAllowed(operator);
1467             }
1468         }
1469         _;
1470     }
1471 }
1472 
1473 /**
1474  * @title  DefaultOperatorFilterer
1475  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1476  */
1477 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1478     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1479 
1480     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1481 }
1482 
1483 /////////////////////////////////////////////////////////////////////////////////////////
1484 ///  ИЗМЕНЯТЬ ПРОЕКТ ЗДЕСЬ //////////////////////////////////////////////////////////////
1485 ///  ВВЕСТИ СУППЛАЙ, ЦЕНУ, МАКС МИНТОВ НА ТРАНЗАКЦИЮ, МАКС ФРИМИНТОВ ////////////////////
1486 ///  ЦЕНУ В ДВУХ ПОЛЯХ ВВЕСТИ////////////////////////////////////////////////////////////
1487 /// ПОСЛЕ КОНТРАКТ ПИСАТЬ НАЗВАНИЕ КОНТРАКТА ////////////////////////////////////////////
1488 contract SamuraiPetsbyAnon is ERC721A, DefaultOperatorFilterer {
1489     uint256 public maxSupply = 321; 
1490     uint256 private price = 0.005 ether;
1491     string public ShowPrice = "0.005 ether";
1492     uint256 private maxPerTx = 5;
1493     string public baseURI;
1494     error LengthsDoNotMatch();
1495 
1496     function SamuraiMint(uint256 amount) payable public {
1497         require(totalSupply() + amount <= maxSupply);
1498         require(amount <= maxPerTx);
1499         require(msg.value >= amount * price);
1500         _safeMint(msg.sender, amount);
1501     }
1502 
1503 
1504     function batchMintForAddresses(address[] calldata addresses_, uint256[] calldata amounts_) external onlyOwner {
1505         if (addresses_.length != amounts_.length) revert LengthsDoNotMatch();
1506         unchecked {
1507             for (uint32 i = 0; i < addresses_.length; i++) {
1508                 _mint(addresses_[i], amounts_[i]);
1509             }
1510         }
1511     }
1512 
1513     address public owner;
1514     modifier onlyOwner {
1515         require(owner == msg.sender);
1516         _;
1517     }
1518 /////////////////////////////////////////////////////////////////////////////////////////////////////
1519 //////////////// ВНУТРИ ERC721A ПИСАТЬ НАЗВАНИЕ КОЛЛЕКЦИИ (ОПЕНСИ) И НАЗВАНИЕ ТОКЕНА ////////////////
1520 /////////////////////////////////////////////////////////////////////////////////////////////////////
1521     constructor() ERC721A("Samurai Pets", "SP") {
1522         owner = msg.sender;
1523     }
1524     
1525     function setPrice(uint256 newPrice, uint256 maxPerT) external onlyOwner {
1526         price = newPrice;
1527         maxPerTx = maxPerT;
1528     }
1529 
1530 /////// ФУНКЦИЯ ДЛЯ ЗАГРУЗКИ МЕТАДАННЫХ, МЕТАДАННЫЕ СОЗДАВАТЬ НА mintplex.xyz, через NFT UP //////
1531     function setBaseURI(string memory newBaseURI_) external onlyOwner {
1532         baseURI = newBaseURI_;
1533     }
1534 
1535     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1536         return string(abi.encodePacked(baseURI, _toString(tokenId), ".json"));
1537     }
1538     
1539     function withdraw() external onlyOwner {
1540         payable(msg.sender).transfer(address(this).balance);
1541     }
1542 
1543     function cutS(uint256 maxT) external onlyOwner {
1544         maxSupply = maxT;
1545     }
1546 
1547     /////////////////////////////
1548     // OPENSEA FILTER REGISTRY 
1549     /////////////////////////////
1550 
1551     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1552         super.setApprovalForAll(operator, approved);
1553     }
1554 
1555     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1556         super.approve(operator, tokenId);
1557     }
1558 
1559     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1560         super.transferFrom(from, to, tokenId);
1561     }
1562 
1563     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1564         super.safeTransferFrom(from, to, tokenId);
1565     }
1566 
1567     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
1568         super.safeTransferFrom(from, to, tokenId, data);
1569     }
1570 }