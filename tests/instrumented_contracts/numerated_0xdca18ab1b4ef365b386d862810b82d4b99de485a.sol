1 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
2 //....................................................................................................................................//
3 //... MMMMMMMMMMM..MMMMMMMMMMMM...MMMMMMMMMMM...MMM......MMM...MMMMMMMMMMM..MMMMMMMMMMMM...MMMMMMMMMMM...MMMMMMMMMMMM..MMMMMMMMMMMM...//
4 //...MMMMMMMMMMMM..MMMMMMMMMMMM..MMMMMMMMMMMMM..MMM......MMM..MMMMMMMMMMMM..MMMMMMMMMMMM..MMMMMMMMMMMMM..MMMMMMMMMMMM..MMMMMMMMMMMM...//
5 //...MMM.....................MM..MMM.......MMM..MMM......MMM..MMM....................MMM..MMM.......MMM....................MMM........//
6 //...MMM..MMMMMMM..MMMMMMMMMMMM..MMMMMMMMMMMMM..MMMMMMMMMMMM..MMM...........MMMMMMMMMMMM..MMMMMMMMMMMMM..MMMMMMMMMMMM......MMM........//
7 //...MMM..MMMMMMM..MMMMMMMMMMMM..MMMMMMMMMMMMM..MMMMMMMMMMMM..MMM...........MMMMMMMMMMMM..MMMMMMMMMMMMM..MMMMMMMMMMMM......MMM........//
8 //...MMM.......MM..MMM.....MMM...MMM.......MMM................MMM...........MMM.....MM....MMM.......MMM..MMM...............MMM........//
9 //...MMMMMMMMMMMM..MMM......MMM..MMM.......MMM..MMMMMMMMMMMM..MMMMMMMMMMMM..MMM.....MMM...MMM.......MMM..MMM...............MMM........//
10 //....MMMMMMMMMMM..MMM.......MM..MMM.......MMM...MMMMMMMMMM....MMMMMMMMMMM..MMM......MMM..MMM.......MMM..MMM...............MMM........//
11 //....................................................................................................................................//
12 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
13 
14 // File erc721a/contracts/IERC721A.sol@v4.2.3
15 
16 // SPDX-License-Identifier: MIT
17 // ERC721A Contracts v4.2.3
18 // Creator: Chiru Labs
19 
20 pragma solidity ^0.8.4;
21 
22 /**
23  * @dev Interface of ERC721A.
24  */
25 interface IERC721A {
26     /**
27      * The caller must own the token or be an approved operator.
28      */
29     error ApprovalCallerNotOwnerNorApproved();
30 
31     /**
32      * The token does not exist.
33      */
34     error ApprovalQueryForNonexistentToken();
35 
36     /**
37      * Cannot query the balance for the zero address.
38      */
39     error BalanceQueryForZeroAddress();
40 
41     /**
42      * Cannot mint to the zero address.
43      */
44     error MintToZeroAddress();
45 
46     /**
47      * The quantity of tokens minted must be more than zero.
48      */
49     error MintZeroQuantity();
50 
51     /**
52      * The token does not exist.
53      */
54     error OwnerQueryForNonexistentToken();
55 
56     /**
57      * The caller must own the token or be an approved operator.
58      */
59     error TransferCallerNotOwnerNorApproved();
60 
61     /**
62      * The token must be owned by `from`.
63      */
64     error TransferFromIncorrectOwner();
65 
66     /**
67      * Cannot safely transfer to a contract that does not implement the
68      * ERC721Receiver interface.
69      */
70     error TransferToNonERC721ReceiverImplementer();
71 
72     /**
73      * Cannot transfer to the zero address.
74      */
75     error TransferToZeroAddress();
76 
77     /**
78      * The token does not exist.
79      */
80     error URIQueryForNonexistentToken();
81 
82     /**
83      * The `quantity` minted with ERC2309 exceeds the safety limit.
84      */
85     error MintERC2309QuantityExceedsLimit();
86 
87     /**
88      * The `extraData` cannot be set on an unintialized ownership slot.
89      */
90     error OwnershipNotInitializedForExtraData();
91 
92     // =============================================================
93     //                            STRUCTS
94     // =============================================================
95 
96     struct TokenOwnership {
97         // The address of the owner.
98         address addr;
99         // Stores the start time of ownership with minimal overhead for tokenomics.
100         uint64 startTimestamp;
101         // Whether the token has been burned.
102         bool burned;
103         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
104         uint24 extraData;
105     }
106 
107     // =============================================================
108     //                         TOKEN COUNTERS
109     // =============================================================
110 
111     /**
112      * @dev Returns the total number of tokens in existence.
113      * Burned tokens will reduce the count.
114      * To get the total number of tokens minted, please see {_totalMinted}.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     // =============================================================
119     //                            IERC165
120     // =============================================================
121 
122     /**
123      * @dev Returns true if this contract implements the interface defined by
124      * `interfaceId`. See the corresponding
125      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
126      * to learn more about how these ids are created.
127      *
128      * This function call must use less than 30000 gas.
129      */
130     function supportsInterface(bytes4 interfaceId) external view returns (bool);
131 
132     // =============================================================
133     //                            IERC721
134     // =============================================================
135 
136     /**
137      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
143      */
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables or disables
148      * (`approved`) `operator` to manage all of its assets.
149      */
150     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
151 
152     /**
153      * @dev Returns the number of tokens in `owner`'s account.
154      */
155     function balanceOf(address owner) external view returns (uint256 balance);
156 
157     /**
158      * @dev Returns the owner of the `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function ownerOf(uint256 tokenId) external view returns (address owner);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`,
168      * checking first that contract recipients are aware of the ERC721 protocol
169      * to prevent tokens from being forever locked.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be have been allowed to move
177      * this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement
179      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId,
187         bytes calldata data
188     ) external payable;
189 
190     /**
191      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
192      */
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external payable;
198 
199     /**
200      * @dev Transfers `tokenId` from `from` to `to`.
201      *
202      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
203      * whenever possible.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must be owned by `from`.
210      * - If the caller is not `from`, it must be approved to move this token
211      * by either {approve} or {setApprovalForAll}.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(
216         address from,
217         address to,
218         uint256 tokenId
219     ) external payable;
220 
221     /**
222      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
223      * The approval is cleared when the token is transferred.
224      *
225      * Only a single account can be approved at a time, so approving the
226      * zero address clears previous approvals.
227      *
228      * Requirements:
229      *
230      * - The caller must own the token or be an approved operator.
231      * - `tokenId` must exist.
232      *
233      * Emits an {Approval} event.
234      */
235     function approve(address to, uint256 tokenId) external payable;
236 
237     /**
238      * @dev Approve or remove `operator` as an operator for the caller.
239      * Operators can call {transferFrom} or {safeTransferFrom}
240      * for any token owned by the caller.
241      *
242      * Requirements:
243      *
244      * - The `operator` cannot be the caller.
245      *
246      * Emits an {ApprovalForAll} event.
247      */
248     function setApprovalForAll(address operator, bool _approved) external;
249 
250     /**
251      * @dev Returns the account approved for `tokenId` token.
252      *
253      * Requirements:
254      *
255      * - `tokenId` must exist.
256      */
257     function getApproved(uint256 tokenId) external view returns (address operator);
258 
259     /**
260      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
261      *
262      * See {setApprovalForAll}.
263      */
264     function isApprovedForAll(address owner, address operator) external view returns (bool);
265 
266     // =============================================================
267     //                        IERC721Metadata
268     // =============================================================
269 
270     /**
271      * @dev Returns the token collection name.
272      */
273     function name() external view returns (string memory);
274 
275     /**
276      * @dev Returns the token collection symbol.
277      */
278     function symbol() external view returns (string memory);
279 
280     /**
281      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
282      */
283     function tokenURI(uint256 tokenId) external view returns (string memory);
284 
285     // =============================================================
286     //                           IERC2309
287     // =============================================================
288 
289     /**
290      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
291      * (inclusive) is transferred from `from` to `to`, as defined in the
292      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
293      *
294      * See {_mintERC2309} for more details.
295      */
296     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
297 }
298 
299 
300 // File erc721a/contracts/ERC721A.sol@v4.2.3
301 
302 
303 // ERC721A Contracts v4.2.3
304 // Creator: Chiru Labs
305 
306 pragma solidity ^0.8.4;
307 
308 /**
309  * @dev Interface of ERC721 token receiver.
310  */
311 interface ERC721A__IERC721Receiver {
312     function onERC721Received(
313         address operator,
314         address from,
315         uint256 tokenId,
316         bytes calldata data
317     ) external returns (bytes4);
318 }
319 
320 /**
321  * @title ERC721A
322  *
323  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
324  * Non-Fungible Token Standard, including the Metadata extension.
325  * Optimized for lower gas during batch mints.
326  *
327  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
328  * starting from `_startTokenId()`.
329  *
330  * Assumptions:
331  *
332  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
333  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
334  */
335 contract ERC721A is IERC721A {
336     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
337     struct TokenApprovalRef {
338         address value;
339     }
340 
341     // =============================================================
342     //                           CONSTANTS
343     // =============================================================
344 
345     // Mask of an entry in packed address data.
346     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
347 
348     // The bit position of `numberMinted` in packed address data.
349     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
350 
351     // The bit position of `numberBurned` in packed address data.
352     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
353 
354     // The bit position of `aux` in packed address data.
355     uint256 private constant _BITPOS_AUX = 192;
356 
357     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
358     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
359 
360     // The bit position of `startTimestamp` in packed ownership.
361     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
362 
363     // The bit mask of the `burned` bit in packed ownership.
364     uint256 private constant _BITMASK_BURNED = 1 << 224;
365 
366     // The bit position of the `nextInitialized` bit in packed ownership.
367     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
368 
369     // The bit mask of the `nextInitialized` bit in packed ownership.
370     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
371 
372     // The bit position of `extraData` in packed ownership.
373     uint256 private constant _BITPOS_EXTRA_DATA = 232;
374 
375     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
376     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
377 
378     // The mask of the lower 160 bits for addresses.
379     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
380 
381     // The maximum `quantity` that can be minted with {_mintERC2309}.
382     // This limit is to prevent overflows on the address data entries.
383     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
384     // is required to cause an overflow, which is unrealistic.
385     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
386 
387     // The `Transfer` event signature is given by:
388     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
389     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
390         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
391 
392     // =============================================================
393     //                            STORAGE
394     // =============================================================
395 
396     // The next token ID to be minted.
397     uint256 private _currentIndex;
398 
399     // The number of tokens burned.
400     uint256 private _burnCounter;
401 
402     // Token name
403     string private _name;
404 
405     // Token symbol
406     string private _symbol;
407 
408     // Mapping from token ID to ownership details
409     // An empty struct value does not necessarily mean the token is unowned.
410     // See {_packedOwnershipOf} implementation for details.
411     //
412     // Bits Layout:
413     // - [0..159]   `addr`
414     // - [160..223] `startTimestamp`
415     // - [224]      `burned`
416     // - [225]      `nextInitialized`
417     // - [232..255] `extraData`
418     mapping(uint256 => uint256) private _packedOwnerships;
419 
420     // Mapping owner address to address data.
421     //
422     // Bits Layout:
423     // - [0..63]    `balance`
424     // - [64..127]  `numberMinted`
425     // - [128..191] `numberBurned`
426     // - [192..255] `aux`
427     mapping(address => uint256) private _packedAddressData;
428 
429     // Mapping from token ID to approved address.
430     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
431 
432     // Mapping from owner to operator approvals
433     mapping(address => mapping(address => bool)) private _operatorApprovals;
434 
435     // =============================================================
436     //                          CONSTRUCTOR
437     // =============================================================
438 
439     constructor(string memory name_, string memory symbol_) {
440         _name = name_;
441         _symbol = symbol_;
442         _currentIndex = _startTokenId();
443     }
444 
445     // =============================================================
446     //                   TOKEN COUNTING OPERATIONS
447     // =============================================================
448 
449     /**
450      * @dev Returns the starting token ID.
451      * To change the starting token ID, please override this function.
452      */
453     function _startTokenId() internal view virtual returns (uint256) {
454         return 0;
455     }
456 
457     /**
458      * @dev Returns the next token ID to be minted.
459      */
460     function _nextTokenId() internal view virtual returns (uint256) {
461         return _currentIndex;
462     }
463 
464     /**
465      * @dev Returns the total number of tokens in existence.
466      * Burned tokens will reduce the count.
467      * To get the total number of tokens minted, please see {_totalMinted}.
468      */
469     function totalSupply() public view virtual override returns (uint256) {
470         // Counter underflow is impossible as _burnCounter cannot be incremented
471         // more than `_currentIndex - _startTokenId()` times.
472         unchecked {
473             return _currentIndex - _burnCounter - _startTokenId();
474         }
475     }
476 
477     /**
478      * @dev Returns the total amount of tokens minted in the contract.
479      */
480     function _totalMinted() internal view virtual returns (uint256) {
481         // Counter underflow is impossible as `_currentIndex` does not decrement,
482         // and it is initialized to `_startTokenId()`.
483         unchecked {
484             return _currentIndex - _startTokenId();
485         }
486     }
487 
488     /**
489      * @dev Returns the total number of tokens burned.
490      */
491     function _totalBurned() internal view virtual returns (uint256) {
492         return _burnCounter;
493     }
494 
495     // =============================================================
496     //                    ADDRESS DATA OPERATIONS
497     // =============================================================
498 
499     /**
500      * @dev Returns the number of tokens in `owner`'s account.
501      */
502     function balanceOf(address owner) public view virtual override returns (uint256) {
503         if (owner == address(0)) revert BalanceQueryForZeroAddress();
504         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
505     }
506 
507     /**
508      * Returns the number of tokens minted by `owner`.
509      */
510     function _numberMinted(address owner) internal view returns (uint256) {
511         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
512     }
513 
514     /**
515      * Returns the number of tokens burned by or on behalf of `owner`.
516      */
517     function _numberBurned(address owner) internal view returns (uint256) {
518         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
519     }
520 
521     /**
522      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
523      */
524     function _getAux(address owner) internal view returns (uint64) {
525         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
526     }
527 
528     /**
529      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
530      * If there are multiple variables, please pack them into a uint64.
531      */
532     function _setAux(address owner, uint64 aux) internal virtual {
533         uint256 packed = _packedAddressData[owner];
534         uint256 auxCasted;
535         // Cast `aux` with assembly to avoid redundant masking.
536         assembly {
537             auxCasted := aux
538         }
539         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
540         _packedAddressData[owner] = packed;
541     }
542 
543     // =============================================================
544     //                            IERC165
545     // =============================================================
546 
547     /**
548      * @dev Returns true if this contract implements the interface defined by
549      * `interfaceId`. See the corresponding
550      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
551      * to learn more about how these ids are created.
552      *
553      * This function call must use less than 30000 gas.
554      */
555     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556         // The interface IDs are constants representing the first 4 bytes
557         // of the XOR of all function selectors in the interface.
558         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
559         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
560         return
561             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
562             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
563             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
564     }
565 
566     // =============================================================
567     //                        IERC721Metadata
568     // =============================================================
569 
570     /**
571      * @dev Returns the token collection name.
572      */
573     function name() public view virtual override returns (string memory) {
574         return _name;
575     }
576 
577     /**
578      * @dev Returns the token collection symbol.
579      */
580     function symbol() public view virtual override returns (string memory) {
581         return _symbol;
582     }
583 
584     /**
585      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
586      */
587     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
588         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
589 
590         string memory baseURI = _baseURI();
591         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
592     }
593 
594     /**
595      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
596      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
597      * by default, it can be overridden in child contracts.
598      */
599     function _baseURI() internal view virtual returns (string memory) {
600         return '';
601     }
602 
603     // =============================================================
604     //                     OWNERSHIPS OPERATIONS
605     // =============================================================
606 
607     /**
608      * @dev Returns the owner of the `tokenId` token.
609      *
610      * Requirements:
611      *
612      * - `tokenId` must exist.
613      */
614     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
615         return address(uint160(_packedOwnershipOf(tokenId)));
616     }
617 
618     /**
619      * @dev Gas spent here starts off proportional to the maximum mint batch size.
620      * It gradually moves to O(1) as tokens get transferred around over time.
621      */
622     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
623         return _unpackedOwnership(_packedOwnershipOf(tokenId));
624     }
625 
626     /**
627      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
628      */
629     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
630         return _unpackedOwnership(_packedOwnerships[index]);
631     }
632 
633     /**
634      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
635      */
636     function _initializeOwnershipAt(uint256 index) internal virtual {
637         if (_packedOwnerships[index] == 0) {
638             _packedOwnerships[index] = _packedOwnershipOf(index);
639         }
640     }
641 
642     /**
643      * Returns the packed ownership data of `tokenId`.
644      */
645     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
646         uint256 curr = tokenId;
647 
648         unchecked {
649             if (_startTokenId() <= curr)
650                 if (curr < _currentIndex) {
651                     uint256 packed = _packedOwnerships[curr];
652                     // If not burned.
653                     if (packed & _BITMASK_BURNED == 0) {
654                         // Invariant:
655                         // There will always be an initialized ownership slot
656                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
657                         // before an unintialized ownership slot
658                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
659                         // Hence, `curr` will not underflow.
660                         //
661                         // We can directly compare the packed value.
662                         // If the address is zero, packed will be zero.
663                         while (packed == 0) {
664                             packed = _packedOwnerships[--curr];
665                         }
666                         return packed;
667                     }
668                 }
669         }
670         revert OwnerQueryForNonexistentToken();
671     }
672 
673     /**
674      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
675      */
676     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
677         ownership.addr = address(uint160(packed));
678         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
679         ownership.burned = packed & _BITMASK_BURNED != 0;
680         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
681     }
682 
683     /**
684      * @dev Packs ownership data into a single uint256.
685      */
686     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
687         assembly {
688             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
689             owner := and(owner, _BITMASK_ADDRESS)
690             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
691             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
692         }
693     }
694 
695     /**
696      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
697      */
698     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
699         // For branchless setting of the `nextInitialized` flag.
700         assembly {
701             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
702             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
703         }
704     }
705 
706     // =============================================================
707     //                      APPROVAL OPERATIONS
708     // =============================================================
709 
710     /**
711      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
712      * The approval is cleared when the token is transferred.
713      *
714      * Only a single account can be approved at a time, so approving the
715      * zero address clears previous approvals.
716      *
717      * Requirements:
718      *
719      * - The caller must own the token or be an approved operator.
720      * - `tokenId` must exist.
721      *
722      * Emits an {Approval} event.
723      */
724     function approve(address to, uint256 tokenId) public payable virtual override {
725         address owner = ownerOf(tokenId);
726 
727         if (_msgSenderERC721A() != owner)
728             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
729                 revert ApprovalCallerNotOwnerNorApproved();
730             }
731 
732         _tokenApprovals[tokenId].value = to;
733         emit Approval(owner, to, tokenId);
734     }
735 
736     /**
737      * @dev Returns the account approved for `tokenId` token.
738      *
739      * Requirements:
740      *
741      * - `tokenId` must exist.
742      */
743     function getApproved(uint256 tokenId) public view virtual override returns (address) {
744         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
745 
746         return _tokenApprovals[tokenId].value;
747     }
748 
749     /**
750      * @dev Approve or remove `operator` as an operator for the caller.
751      * Operators can call {transferFrom} or {safeTransferFrom}
752      * for any token owned by the caller.
753      *
754      * Requirements:
755      *
756      * - The `operator` cannot be the caller.
757      *
758      * Emits an {ApprovalForAll} event.
759      */
760     function setApprovalForAll(address operator, bool approved) public virtual override {
761         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
762         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
763     }
764 
765     /**
766      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
767      *
768      * See {setApprovalForAll}.
769      */
770     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
771         return _operatorApprovals[owner][operator];
772     }
773 
774     /**
775      * @dev Returns whether `tokenId` exists.
776      *
777      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
778      *
779      * Tokens start existing when they are minted. See {_mint}.
780      */
781     function _exists(uint256 tokenId) internal view virtual returns (bool) {
782         return
783             _startTokenId() <= tokenId &&
784             tokenId < _currentIndex && // If within bounds,
785             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
786     }
787 
788     /**
789      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
790      */
791     function _isSenderApprovedOrOwner(
792         address approvedAddress,
793         address owner,
794         address msgSender
795     ) private pure returns (bool result) {
796         assembly {
797             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
798             owner := and(owner, _BITMASK_ADDRESS)
799             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
800             msgSender := and(msgSender, _BITMASK_ADDRESS)
801             // `msgSender == owner || msgSender == approvedAddress`.
802             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
803         }
804     }
805 
806     /**
807      * @dev Returns the storage slot and value for the approved address of `tokenId`.
808      */
809     function _getApprovedSlotAndAddress(uint256 tokenId)
810         private
811         view
812         returns (uint256 approvedAddressSlot, address approvedAddress)
813     {
814         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
815         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
816         assembly {
817             approvedAddressSlot := tokenApproval.slot
818             approvedAddress := sload(approvedAddressSlot)
819         }
820     }
821 
822     // =============================================================
823     //                      TRANSFER OPERATIONS
824     // =============================================================
825 
826     /**
827      * @dev Transfers `tokenId` from `from` to `to`.
828      *
829      * Requirements:
830      *
831      * - `from` cannot be the zero address.
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must be owned by `from`.
834      * - If the caller is not `from`, it must be approved to move this token
835      * by either {approve} or {setApprovalForAll}.
836      *
837      * Emits a {Transfer} event.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public payable virtual override {
844         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
845 
846         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
847 
848         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
849 
850         // The nested ifs save around 20+ gas over a compound boolean condition.
851         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
852             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
853 
854         if (to == address(0)) revert TransferToZeroAddress();
855 
856         _beforeTokenTransfers(from, to, tokenId, 1);
857 
858         // Clear approvals from the previous owner.
859         assembly {
860             if approvedAddress {
861                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
862                 sstore(approvedAddressSlot, 0)
863             }
864         }
865 
866         // Underflow of the sender's balance is impossible because we check for
867         // ownership above and the recipient's balance can't realistically overflow.
868         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
869         unchecked {
870             // We can directly increment and decrement the balances.
871             --_packedAddressData[from]; // Updates: `balance -= 1`.
872             ++_packedAddressData[to]; // Updates: `balance += 1`.
873 
874             // Updates:
875             // - `address` to the next owner.
876             // - `startTimestamp` to the timestamp of transfering.
877             // - `burned` to `false`.
878             // - `nextInitialized` to `true`.
879             _packedOwnerships[tokenId] = _packOwnershipData(
880                 to,
881                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
882             );
883 
884             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
885             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
886                 uint256 nextTokenId = tokenId + 1;
887                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
888                 if (_packedOwnerships[nextTokenId] == 0) {
889                     // If the next slot is within bounds.
890                     if (nextTokenId != _currentIndex) {
891                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
892                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
893                     }
894                 }
895             }
896         }
897 
898         emit Transfer(from, to, tokenId);
899         _afterTokenTransfers(from, to, tokenId, 1);
900     }
901 
902     /**
903      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public payable virtual override {
910         safeTransferFrom(from, to, tokenId, '');
911     }
912 
913     /**
914      * @dev Safely transfers `tokenId` token from `from` to `to`.
915      *
916      * Requirements:
917      *
918      * - `from` cannot be the zero address.
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must exist and be owned by `from`.
921      * - If the caller is not `from`, it must be approved to move this token
922      * by either {approve} or {setApprovalForAll}.
923      * - If `to` refers to a smart contract, it must implement
924      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
925      *
926      * Emits a {Transfer} event.
927      */
928     function safeTransferFrom(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) public payable virtual override {
934         transferFrom(from, to, tokenId);
935         if (to.code.length != 0)
936             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
937                 revert TransferToNonERC721ReceiverImplementer();
938             }
939     }
940 
941     /**
942      * @dev Hook that is called before a set of serially-ordered token IDs
943      * are about to be transferred. This includes minting.
944      * And also called before burning one token.
945      *
946      * `startTokenId` - the first token ID to be transferred.
947      * `quantity` - the amount to be transferred.
948      *
949      * Calling conditions:
950      *
951      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
952      * transferred to `to`.
953      * - When `from` is zero, `tokenId` will be minted for `to`.
954      * - When `to` is zero, `tokenId` will be burned by `from`.
955      * - `from` and `to` are never both zero.
956      */
957     function _beforeTokenTransfers(
958         address from,
959         address to,
960         uint256 startTokenId,
961         uint256 quantity
962     ) internal virtual {}
963 
964     /**
965      * @dev Hook that is called after a set of serially-ordered token IDs
966      * have been transferred. This includes minting.
967      * And also called after one token has been burned.
968      *
969      * `startTokenId` - the first token ID to be transferred.
970      * `quantity` - the amount to be transferred.
971      *
972      * Calling conditions:
973      *
974      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
975      * transferred to `to`.
976      * - When `from` is zero, `tokenId` has been minted for `to`.
977      * - When `to` is zero, `tokenId` has been burned by `from`.
978      * - `from` and `to` are never both zero.
979      */
980     function _afterTokenTransfers(
981         address from,
982         address to,
983         uint256 startTokenId,
984         uint256 quantity
985     ) internal virtual {}
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
1393 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v4.2.3
1394 
1395 
1396 // ERC721A Contracts v4.2.3
1397 // Creator: Chiru Labs
1398 
1399 pragma solidity ^0.8.4;
1400 
1401 /**
1402  * @dev Interface of ERC721AQueryable.
1403  */
1404 interface IERC721AQueryable is IERC721A {
1405     /**
1406      * Invalid query range (`start` >= `stop`).
1407      */
1408     error InvalidQueryRange();
1409 
1410     /**
1411      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1412      *
1413      * If the `tokenId` is out of bounds:
1414      *
1415      * - `addr = address(0)`
1416      * - `startTimestamp = 0`
1417      * - `burned = false`
1418      * - `extraData = 0`
1419      *
1420      * If the `tokenId` is burned:
1421      *
1422      * - `addr = <Address of owner before token was burned>`
1423      * - `startTimestamp = <Timestamp when token was burned>`
1424      * - `burned = true`
1425      * - `extraData = <Extra data when token was burned>`
1426      *
1427      * Otherwise:
1428      *
1429      * - `addr = <Address of owner>`
1430      * - `startTimestamp = <Timestamp of start of ownership>`
1431      * - `burned = false`
1432      * - `extraData = <Extra data at start of ownership>`
1433      */
1434     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1435 
1436     /**
1437      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1438      * See {ERC721AQueryable-explicitOwnershipOf}
1439      */
1440     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1441 
1442     /**
1443      * @dev Returns an array of token IDs owned by `owner`,
1444      * in the range [`start`, `stop`)
1445      * (i.e. `start <= tokenId < stop`).
1446      *
1447      * This function allows for tokens to be queried if the collection
1448      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1449      *
1450      * Requirements:
1451      *
1452      * - `start < stop`
1453      */
1454     function tokensOfOwnerIn(
1455         address owner,
1456         uint256 start,
1457         uint256 stop
1458     ) external view returns (uint256[] memory);
1459 
1460     /**
1461      * @dev Returns an array of token IDs owned by `owner`.
1462      *
1463      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1464      * It is meant to be called off-chain.
1465      *
1466      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1467      * multiple smaller scans if the collection is large enough to cause
1468      * an out-of-gas error (10K collections should be fine).
1469      */
1470     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1471 }
1472 
1473 
1474 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v4.2.3
1475 
1476 
1477 // ERC721A Contracts v4.2.3
1478 // Creator: Chiru Labs
1479 
1480 pragma solidity ^0.8.4;
1481 
1482 
1483 /**
1484  * @title ERC721AQueryable.
1485  *
1486  * @dev ERC721A subclass with convenience query functions.
1487  */
1488 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1489     /**
1490      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1491      *
1492      * If the `tokenId` is out of bounds:
1493      *
1494      * - `addr = address(0)`
1495      * - `startTimestamp = 0`
1496      * - `burned = false`
1497      * - `extraData = 0`
1498      *
1499      * If the `tokenId` is burned:
1500      *
1501      * - `addr = <Address of owner before token was burned>`
1502      * - `startTimestamp = <Timestamp when token was burned>`
1503      * - `burned = true`
1504      * - `extraData = <Extra data when token was burned>`
1505      *
1506      * Otherwise:
1507      *
1508      * - `addr = <Address of owner>`
1509      * - `startTimestamp = <Timestamp of start of ownership>`
1510      * - `burned = false`
1511      * - `extraData = <Extra data at start of ownership>`
1512      */
1513     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1514         TokenOwnership memory ownership;
1515         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1516             return ownership;
1517         }
1518         ownership = _ownershipAt(tokenId);
1519         if (ownership.burned) {
1520             return ownership;
1521         }
1522         return _ownershipOf(tokenId);
1523     }
1524 
1525     /**
1526      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1527      * See {ERC721AQueryable-explicitOwnershipOf}
1528      */
1529     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1530         external
1531         view
1532         virtual
1533         override
1534         returns (TokenOwnership[] memory)
1535     {
1536         unchecked {
1537             uint256 tokenIdsLength = tokenIds.length;
1538             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1539             for (uint256 i; i != tokenIdsLength; ++i) {
1540                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1541             }
1542             return ownerships;
1543         }
1544     }
1545 
1546     /**
1547      * @dev Returns an array of token IDs owned by `owner`,
1548      * in the range [`start`, `stop`)
1549      * (i.e. `start <= tokenId < stop`).
1550      *
1551      * This function allows for tokens to be queried if the collection
1552      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1553      *
1554      * Requirements:
1555      *
1556      * - `start < stop`
1557      */
1558     function tokensOfOwnerIn(
1559         address owner,
1560         uint256 start,
1561         uint256 stop
1562     ) external view virtual override returns (uint256[] memory) {
1563         unchecked {
1564             if (start >= stop) revert InvalidQueryRange();
1565             uint256 tokenIdsIdx;
1566             uint256 stopLimit = _nextTokenId();
1567             // Set `start = max(start, _startTokenId())`.
1568             if (start < _startTokenId()) {
1569                 start = _startTokenId();
1570             }
1571             // Set `stop = min(stop, stopLimit)`.
1572             if (stop > stopLimit) {
1573                 stop = stopLimit;
1574             }
1575             uint256 tokenIdsMaxLength = balanceOf(owner);
1576             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1577             // to cater for cases where `balanceOf(owner)` is too big.
1578             if (start < stop) {
1579                 uint256 rangeLength = stop - start;
1580                 if (rangeLength < tokenIdsMaxLength) {
1581                     tokenIdsMaxLength = rangeLength;
1582                 }
1583             } else {
1584                 tokenIdsMaxLength = 0;
1585             }
1586             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1587             if (tokenIdsMaxLength == 0) {
1588                 return tokenIds;
1589             }
1590             // We need to call `explicitOwnershipOf(start)`,
1591             // because the slot at `start` may not be initialized.
1592             TokenOwnership memory ownership = explicitOwnershipOf(start);
1593             address currOwnershipAddr;
1594             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1595             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1596             if (!ownership.burned) {
1597                 currOwnershipAddr = ownership.addr;
1598             }
1599             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1600                 ownership = _ownershipAt(i);
1601                 if (ownership.burned) {
1602                     continue;
1603                 }
1604                 if (ownership.addr != address(0)) {
1605                     currOwnershipAddr = ownership.addr;
1606                 }
1607                 if (currOwnershipAddr == owner) {
1608                     tokenIds[tokenIdsIdx++] = i;
1609                 }
1610             }
1611             // Downsize the array to fit.
1612             assembly {
1613                 mstore(tokenIds, tokenIdsIdx)
1614             }
1615             return tokenIds;
1616         }
1617     }
1618 
1619     /**
1620      * @dev Returns an array of token IDs owned by `owner`.
1621      *
1622      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1623      * It is meant to be called off-chain.
1624      *
1625      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1626      * multiple smaller scans if the collection is large enough to cause
1627      * an out-of-gas error (10K collections should be fine).
1628      */
1629     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1630         unchecked {
1631             uint256 tokenIdsIdx;
1632             address currOwnershipAddr;
1633             uint256 tokenIdsLength = balanceOf(owner);
1634             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1635             TokenOwnership memory ownership;
1636             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1637                 ownership = _ownershipAt(i);
1638                 if (ownership.burned) {
1639                     continue;
1640                 }
1641                 if (ownership.addr != address(0)) {
1642                     currOwnershipAddr = ownership.addr;
1643                 }
1644                 if (currOwnershipAddr == owner) {
1645                     tokenIds[tokenIdsIdx++] = i;
1646                 }
1647             }
1648             return tokenIds;
1649         }
1650     }
1651 }
1652 
1653 
1654 // File erc721a/contracts/extensions/IERC721ABurnable.sol@v4.2.3
1655 
1656 
1657 // ERC721A Contracts v4.2.3
1658 // Creator: Chiru Labs
1659 
1660 pragma solidity ^0.8.4;
1661 
1662 /**
1663  * @dev Interface of ERC721ABurnable.
1664  */
1665 interface IERC721ABurnable is IERC721A {
1666     /**
1667      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1668      *
1669      * Requirements:
1670      *
1671      * - The caller must own `tokenId` or be an approved operator.
1672      */
1673     function burn(uint256 tokenId) external;
1674 }
1675 
1676 
1677 // File erc721a/contracts/extensions/ERC721ABurnable.sol@v4.2.3
1678 
1679 
1680 // ERC721A Contracts v4.2.3
1681 // Creator: Chiru Labs
1682 
1683 pragma solidity ^0.8.4;
1684 
1685 
1686 /**
1687  * @title ERC721ABurnable.
1688  *
1689  * @dev ERC721A token that can be irreversibly burned (destroyed).
1690  */
1691 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1692     /**
1693      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1694      *
1695      * Requirements:
1696      *
1697      * - The caller must own `tokenId` or be an approved operator.
1698      */
1699     function burn(uint256 tokenId) public virtual override {
1700         _burn(tokenId, true);
1701     }
1702 }
1703 
1704 
1705 // File contracts/OperatorFilterer.sol
1706 
1707 
1708 pragma solidity ^0.8.0;
1709 
1710 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
1711 /// mandatory on-chain royalty enforcement in order for new collections to
1712 /// receive royalties.
1713 /// For more information, see:
1714 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
1715 abstract contract OperatorFilterer {
1716     /// @dev The default OpenSea operator blocklist subscription.
1717     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1718 
1719     /// @dev The OpenSea operator filter registry.
1720     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
1721 
1722     /// @dev Registers the current contract to OpenSea's operator filter,
1723     /// and subscribe to the default OpenSea operator blocklist.
1724     /// Note: Will not revert nor update existing settings for repeated registration.
1725     function _registerForOperatorFiltering() internal virtual {
1726         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
1727     }
1728 
1729     /// @dev Registers the current contract to OpenSea's operator filter.
1730     /// Note: Will not revert nor update existing settings for repeated registration.
1731     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
1732         internal
1733         virtual
1734     {
1735         /// @solidity memory-safe-assembly
1736         assembly {
1737             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
1738 
1739             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
1740             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
1741 
1742             for {} iszero(subscribe) {} {
1743                 if iszero(subscriptionOrRegistrantToCopy) {
1744                     functionSelector := 0x4420e486 // `register(address)`.
1745                     break
1746                 }
1747                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
1748                 break
1749             }
1750             // Store the function selector.
1751             mstore(0x00, shl(224, functionSelector))
1752             // Store the `address(this)`.
1753             mstore(0x04, address())
1754             // Store the `subscriptionOrRegistrantToCopy`.
1755             mstore(0x24, subscriptionOrRegistrantToCopy)
1756             // Register into the registry.
1757             if iszero(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x04)) {
1758                 // If the function selector has not been overwritten,
1759                 // it is an out-of-gas error.
1760                 if eq(shr(224, mload(0x00)), functionSelector) {
1761                     // To prevent gas under-estimation.
1762                     revert(0, 0)
1763                 }
1764             }
1765             // Restore the part of the free memory pointer that was overwritten,
1766             // which is guaranteed to be zero, because of Solidity's memory size limits.
1767             mstore(0x24, 0)
1768         }
1769     }
1770 
1771     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
1772     modifier onlyAllowedOperator(address from) virtual {
1773         if (from != msg.sender) {
1774             if (!_isPriorityOperator(msg.sender)) {
1775                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
1776             }
1777         }
1778         _;
1779     }
1780 
1781     /// @dev Modifier to guard a function from approving a blocked operator..
1782     modifier onlyAllowedOperatorApproval(address operator) virtual {
1783         if (!_isPriorityOperator(operator)) {
1784             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
1785         }
1786         _;
1787     }
1788 
1789     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
1790     function _revertIfBlocked(address operator) private view {
1791         /// @solidity memory-safe-assembly
1792         assembly {
1793             // Store the function selector of `isOperatorAllowed(address,address)`,
1794             // shifted left by 6 bytes, which is enough for 8tb of memory.
1795             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
1796             mstore(0x00, 0xc6171134001122334455)
1797             // Store the `address(this)`.
1798             mstore(0x1a, address())
1799             // Store the `operator`.
1800             mstore(0x3a, operator)
1801 
1802             // `isOperatorAllowed` always returns true if it does not revert.
1803             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
1804                 // Bubble up the revert if the staticcall reverts.
1805                 returndatacopy(0x00, 0x00, returndatasize())
1806                 revert(0x00, returndatasize())
1807             }
1808 
1809             // We'll skip checking if `from` is inside the blacklist.
1810             // Even though that can block transferring out of wrapper contracts,
1811             // we don't want tokens to be stuck.
1812 
1813             // Restore the part of the free memory pointer that was overwritten,
1814             // which is guaranteed to be zero, if less than 8tb of memory is used.
1815             mstore(0x3a, 0)
1816         }
1817     }
1818 
1819     /// @dev For deriving contracts to override, so that operator filtering
1820     /// can be turned on / off.
1821     /// Returns true by default.
1822     function _operatorFilteringEnabled() internal view virtual returns (bool) {
1823         return true;
1824     }
1825 
1826     /// @dev For deriving contracts to override, so that preferred marketplaces can
1827     /// skip operator filtering, helping users save gas.
1828     /// Returns false for all inputs by default.
1829     function _isPriorityOperator(address) internal view virtual returns (bool) {
1830         return false;
1831     }
1832 }
1833 
1834 
1835 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.0
1836 
1837 
1838 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1839 
1840 pragma solidity ^0.8.0;
1841 
1842 /**
1843  * @dev Contract module that helps prevent reentrant calls to a function.
1844  *
1845  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1846  * available, which can be applied to functions to make sure there are no nested
1847  * (reentrant) calls to them.
1848  *
1849  * Note that because there is a single `nonReentrant` guard, functions marked as
1850  * `nonReentrant` may not call one another. This can be worked around by making
1851  * those functions `private`, and then adding `external` `nonReentrant` entry
1852  * points to them.
1853  *
1854  * TIP: If you would like to learn more about reentrancy and alternative ways
1855  * to protect against it, check out our blog post
1856  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1857  */
1858 abstract contract ReentrancyGuard {
1859     // Booleans are more expensive than uint256 or any type that takes up a full
1860     // word because each write operation emits an extra SLOAD to first read the
1861     // slot's contents, replace the bits taken up by the boolean, and then write
1862     // back. This is the compiler's defense against contract upgrades and
1863     // pointer aliasing, and it cannot be disabled.
1864 
1865     // The values being non-zero value makes deployment a bit more expensive,
1866     // but in exchange the refund on every call to nonReentrant will be lower in
1867     // amount. Since refunds are capped to a percentage of the total
1868     // transaction's gas, it is best to keep them low in cases like this one, to
1869     // increase the likelihood of the full refund coming into effect.
1870     uint256 private constant _NOT_ENTERED = 1;
1871     uint256 private constant _ENTERED = 2;
1872 
1873     uint256 private _status;
1874 
1875     constructor() {
1876         _status = _NOT_ENTERED;
1877     }
1878 
1879     /**
1880      * @dev Prevents a contract from calling itself, directly or indirectly.
1881      * Calling a `nonReentrant` function from another `nonReentrant`
1882      * function is not supported. It is possible to prevent this from happening
1883      * by making the `nonReentrant` function external, and making it call a
1884      * `private` function that does the actual work.
1885      */
1886     modifier nonReentrant() {
1887         _nonReentrantBefore();
1888         _;
1889         _nonReentrantAfter();
1890     }
1891 
1892     function _nonReentrantBefore() private {
1893         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1894         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1895 
1896         // Any calls to nonReentrant after this point will fail
1897         _status = _ENTERED;
1898     }
1899 
1900     function _nonReentrantAfter() private {
1901         // By storing the original value once again, a refund is triggered (see
1902         // https://eips.ethereum.org/EIPS/eip-2200)
1903         _status = _NOT_ENTERED;
1904     }
1905 }
1906 
1907 
1908 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
1909 
1910 
1911 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1912 
1913 pragma solidity ^0.8.0;
1914 
1915 /**
1916  * @dev Provides information about the current execution context, including the
1917  * sender of the transaction and its data. While these are generally available
1918  * via msg.sender and msg.data, they should not be accessed in such a direct
1919  * manner, since when dealing with meta-transactions the account sending and
1920  * paying for execution may not be the actual sender (as far as an application
1921  * is concerned).
1922  *
1923  * This contract is only required for intermediate, library-like contracts.
1924  */
1925 abstract contract Context {
1926     function _msgSender() internal view virtual returns (address) {
1927         return msg.sender;
1928     }
1929 
1930     function _msgData() internal view virtual returns (bytes calldata) {
1931         return msg.data;
1932     }
1933 }
1934 
1935 
1936 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
1937 
1938 
1939 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1940 
1941 pragma solidity ^0.8.0;
1942 
1943 /**
1944  * @dev Contract module which provides a basic access control mechanism, where
1945  * there is an account (an owner) that can be granted exclusive access to
1946  * specific functions.
1947  *
1948  * By default, the owner account will be the one that deploys the contract. This
1949  * can later be changed with {transferOwnership}.
1950  *
1951  * This module is used through inheritance. It will make available the modifier
1952  * `onlyOwner`, which can be applied to your functions to restrict their use to
1953  * the owner.
1954  */
1955 abstract contract Ownable is Context {
1956     address private _owner;
1957 
1958     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1959 
1960     /**
1961      * @dev Initializes the contract setting the deployer as the initial owner.
1962      */
1963     constructor() {
1964         _transferOwnership(_msgSender());
1965     }
1966 
1967     /**
1968      * @dev Throws if called by any account other than the owner.
1969      */
1970     modifier onlyOwner() {
1971         _checkOwner();
1972         _;
1973     }
1974 
1975     /**
1976      * @dev Returns the address of the current owner.
1977      */
1978     function owner() public view virtual returns (address) {
1979         return _owner;
1980     }
1981 
1982     /**
1983      * @dev Throws if the sender is not the owner.
1984      */
1985     function _checkOwner() internal view virtual {
1986         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1987     }
1988 
1989     /**
1990      * @dev Leaves the contract without owner. It will not be possible to call
1991      * `onlyOwner` functions anymore. Can only be called by the current owner.
1992      *
1993      * NOTE: Renouncing ownership will leave the contract without an owner,
1994      * thereby removing any functionality that is only available to the owner.
1995      */
1996     function renounceOwnership() public virtual onlyOwner {
1997         _transferOwnership(address(0));
1998     }
1999 
2000     /**
2001      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2002      * Can only be called by the current owner.
2003      */
2004     function transferOwnership(address newOwner) public virtual onlyOwner {
2005         require(newOwner != address(0), "Ownable: new owner is the zero address");
2006         _transferOwnership(newOwner);
2007     }
2008 
2009     /**
2010      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2011      * Internal function without access restriction.
2012      */
2013     function _transferOwnership(address newOwner) internal virtual {
2014         address oldOwner = _owner;
2015         _owner = newOwner;
2016         emit OwnershipTransferred(oldOwner, newOwner);
2017     }
2018 }
2019 
2020 
2021 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
2022 
2023 
2024 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2025 
2026 pragma solidity ^0.8.0;
2027 
2028 /**
2029  * @dev Interface of the ERC165 standard, as defined in the
2030  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2031  *
2032  * Implementers can declare support of contract interfaces, which can then be
2033  * queried by others ({ERC165Checker}).
2034  *
2035  * For an implementation, see {ERC165}.
2036  */
2037 interface IERC165 {
2038     /**
2039      * @dev Returns true if this contract implements the interface defined by
2040      * `interfaceId`. See the corresponding
2041      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2042      * to learn more about how these ids are created.
2043      *
2044      * This function call must use less than 30 000 gas.
2045      */
2046     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2047 }
2048 
2049 
2050 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.8.0
2051 
2052 
2053 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
2054 
2055 pragma solidity ^0.8.0;
2056 
2057 /**
2058  * @dev Interface for the NFT Royalty Standard.
2059  *
2060  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2061  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2062  *
2063  * _Available since v4.5._
2064  */
2065 interface IERC2981 is IERC165 {
2066     /**
2067      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2068      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2069      */
2070     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2071         external
2072         view
2073         returns (address receiver, uint256 royaltyAmount);
2074 }
2075 
2076 
2077 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.0
2078 
2079 
2080 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2081 
2082 pragma solidity ^0.8.0;
2083 
2084 /**
2085  * @dev Implementation of the {IERC165} interface.
2086  *
2087  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2088  * for the additional interface id that will be supported. For example:
2089  *
2090  * ```solidity
2091  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2092  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2093  * }
2094  * ```
2095  *
2096  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2097  */
2098 abstract contract ERC165 is IERC165 {
2099     /**
2100      * @dev See {IERC165-supportsInterface}.
2101      */
2102     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2103         return interfaceId == type(IERC165).interfaceId;
2104     }
2105 }
2106 
2107 
2108 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.8.0
2109 
2110 
2111 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
2112 
2113 pragma solidity ^0.8.0;
2114 
2115 
2116 /**
2117  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2118  *
2119  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2120  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2121  *
2122  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2123  * fee is specified in basis points by default.
2124  *
2125  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2126  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2127  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2128  *
2129  * _Available since v4.5._
2130  */
2131 abstract contract ERC2981 is IERC2981, ERC165 {
2132     struct RoyaltyInfo {
2133         address receiver;
2134         uint96 royaltyFraction;
2135     }
2136 
2137     RoyaltyInfo private _defaultRoyaltyInfo;
2138     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2139 
2140     /**
2141      * @dev See {IERC165-supportsInterface}.
2142      */
2143     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2144         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2145     }
2146 
2147     /**
2148      * @inheritdoc IERC2981
2149      */
2150     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
2151         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2152 
2153         if (royalty.receiver == address(0)) {
2154             royalty = _defaultRoyaltyInfo;
2155         }
2156 
2157         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
2158 
2159         return (royalty.receiver, royaltyAmount);
2160     }
2161 
2162     /**
2163      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2164      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2165      * override.
2166      */
2167     function _feeDenominator() internal pure virtual returns (uint96) {
2168         return 10000;
2169     }
2170 
2171     /**
2172      * @dev Sets the royalty information that all ids in this contract will default to.
2173      *
2174      * Requirements:
2175      *
2176      * - `receiver` cannot be the zero address.
2177      * - `feeNumerator` cannot be greater than the fee denominator.
2178      */
2179     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2180         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2181         require(receiver != address(0), "ERC2981: invalid receiver");
2182 
2183         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2184     }
2185 
2186     /**
2187      * @dev Removes default royalty information.
2188      */
2189     function _deleteDefaultRoyalty() internal virtual {
2190         delete _defaultRoyaltyInfo;
2191     }
2192 
2193     /**
2194      * @dev Sets the royalty information for a specific token id, overriding the global default.
2195      *
2196      * Requirements:
2197      *
2198      * - `receiver` cannot be the zero address.
2199      * - `feeNumerator` cannot be greater than the fee denominator.
2200      */
2201     function _setTokenRoyalty(
2202         uint256 tokenId,
2203         address receiver,
2204         uint96 feeNumerator
2205     ) internal virtual {
2206         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2207         require(receiver != address(0), "ERC2981: Invalid parameters");
2208 
2209         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2210     }
2211 
2212     /**
2213      * @dev Resets royalty information for the token id back to the global default.
2214      */
2215     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2216         delete _tokenRoyaltyInfo[tokenId];
2217     }
2218 }
2219 
2220 
2221 // File @openzeppelin/contracts/utils/structs/BitMaps.sol@v4.8.0
2222 
2223 
2224 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/BitMaps.sol)
2225 pragma solidity ^0.8.0;
2226 
2227 /**
2228  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
2229  * Largely inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
2230  */
2231 library BitMaps {
2232     struct BitMap {
2233         mapping(uint256 => uint256) _data;
2234     }
2235 
2236     /**
2237      * @dev Returns whether the bit at `index` is set.
2238      */
2239     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
2240         uint256 bucket = index >> 8;
2241         uint256 mask = 1 << (index & 0xff);
2242         return bitmap._data[bucket] & mask != 0;
2243     }
2244 
2245     /**
2246      * @dev Sets the bit at `index` to the boolean `value`.
2247      */
2248     function setTo(
2249         BitMap storage bitmap,
2250         uint256 index,
2251         bool value
2252     ) internal {
2253         if (value) {
2254             set(bitmap, index);
2255         } else {
2256             unset(bitmap, index);
2257         }
2258     }
2259 
2260     /**
2261      * @dev Sets the bit at `index`.
2262      */
2263     function set(BitMap storage bitmap, uint256 index) internal {
2264         uint256 bucket = index >> 8;
2265         uint256 mask = 1 << (index & 0xff);
2266         bitmap._data[bucket] |= mask;
2267     }
2268 
2269     /**
2270      * @dev Unsets the bit at `index`.
2271      */
2272     function unset(BitMap storage bitmap, uint256 index) internal {
2273         uint256 bucket = index >> 8;
2274         uint256 mask = 1 << (index & 0xff);
2275         bitmap._data[bucket] &= ~mask;
2276     }
2277 }
2278 
2279 
2280 // File contracts/GraycraftOmega.sol
2281 
2282 
2283 pragma solidity 0.8.4;
2284 
2285 
2286 
2287 
2288 
2289 
2290 
2291 
2292 
2293 interface IERC721 {
2294     /**
2295      * @dev Returns the number of tokens in ``owner``'s account.
2296      */
2297     function balanceOf(address owner) external view returns (uint256 balance);
2298 
2299     /**
2300      * @dev Returns the owner of the `tokenId` token.
2301      *
2302      * Requirements:
2303      *
2304      * - `tokenId` must exist.
2305      */
2306     function ownerOf(uint256 tokenId) external view returns (address owner);
2307 }
2308 
2309 contract GraycraftOmega is
2310     ERC721AQueryable,
2311     ERC721ABurnable,
2312     OperatorFilterer,
2313     Ownable,
2314     ReentrancyGuard,
2315     ERC2981
2316 {
2317     using BitMaps for BitMaps.BitMap;
2318 
2319     address public constant GRAYCRAFT1_ADDRESS = 0x9030807ba4C71831808408CbF892bfA1261A6E7D; // mainnet
2320     address public constant GRAYCRAFT2_ADDRESS = 0x2BD60F290060451e3644a7559D520C2e9b32C7e9; // mainnet
2321 
2322     uint256 public constant MAX_GRAYCRAFT = 8888; // max of 8,888
2323     uint256 public constant MAX_RESERVED = 5585; // max of 5,585
2324 
2325     string public constant GC_PROVENANCE = "";
2326     uint public graycraftPrice = 0.25 ether;
2327     
2328     uint public teamGraycrafts = 60; // These are reserved for team
2329     uint public reservedGraycrafts = 0; // These are the total amount that has been reserved
2330 
2331     bool public saleIsActive = false; // determines whether sales is active
2332     bool public claimIsActive = false; // determines whether claiming phase is active
2333     
2334     mapping(address => uint) public mintPerAddress; // owner => amount minted
2335     mapping(address => bool) public admins; // account => has permissions
2336 
2337     BitMaps.BitMap private gc1Claimed; // tokenId => hasClaimed?
2338     BitMaps.BitMap private gc2Claimed; // tokenId => hasClaimed?
2339 
2340     bool public operatorFilteringEnabled;
2341     string private _baseTokenURI;
2342 
2343     constructor() ERC721A("GRAYCRAFT Omega Project", "MECH") {
2344         _registerForOperatorFiltering();
2345         operatorFilteringEnabled = true;
2346 
2347         // Set royalty receiver to the contract creator,
2348         // at 7.5% (default denominator is 10000).
2349         _setDefaultRoyalty(msg.sender, 750);
2350     }
2351 
2352     /* ========== Public view functions ========== */
2353 
2354     // Checks to see if user has graycraft
2355     function hasGraycraft(address _owner) public view returns (bool) {
2356         return IERC721(GRAYCRAFT1_ADDRESS).balanceOf(_owner) > 0 || IERC721(GRAYCRAFT2_ADDRESS).balanceOf(_owner) > 0;
2357     }
2358 
2359     function claimableGc1Amount(address _owner) public view returns (uint256) {
2360         return IERC721(GRAYCRAFT1_ADDRESS).balanceOf(_owner) * 5;
2361     }
2362     
2363     function claimableGc2Amount(address _owner) public view returns (uint256) {
2364         return IERC721(GRAYCRAFT2_ADDRESS).balanceOf(_owner);
2365     }
2366 
2367     function gc1HasClaimed(uint index) external view returns (bool) {
2368         return gc1Claimed.get(index);
2369     }
2370     
2371     function gc2HasClaimed(uint index) external view returns (bool) {
2372         return gc2Claimed.get(index);
2373     }
2374 
2375     /* ========== External public sales functions ========== */
2376 
2377     function claimGraycraft1(uint256[] calldata tokenIds) external nonReentrant {
2378         require(claimIsActive);
2379 
2380         // Loops to check if all specified tokenIds are from owners
2381         // Ensures that tokenId has never claimed before
2382         // Also will record which tokenId has issued a claim before
2383         for (uint i = 0; i < tokenIds.length; ++i) {
2384             uint256 tokenId = tokenIds[i];
2385             require(IERC721(GRAYCRAFT1_ADDRESS).ownerOf(tokenId) == msg.sender, "not owner");
2386             require(!gc1Claimed.get(tokenId), "claimed before");
2387             gc1Claimed.setTo(tokenId, true);
2388         }
2389 
2390         // Gets the number of crafts that can be claimed, will apply necessary multiplier
2391         uint numberOfTokens = tokenIds.length * 5;
2392 
2393         // Max supply exceeded
2394         require(_totalMinted() + numberOfTokens <= MAX_GRAYCRAFT);
2395 
2396         // Exceeded reserved slots
2397         require(reservedGraycrafts + numberOfTokens <= MAX_RESERVED);
2398 
2399         // For each craft that we allow for claims, we add to count
2400         reservedGraycrafts += numberOfTokens;
2401 
2402         _mint(msg.sender, numberOfTokens);
2403     }
2404 
2405     function claimGraycraft2(uint256[] calldata tokenIds) external nonReentrant {
2406         require(claimIsActive);
2407 
2408         // Loops to check if all specified tokenIds are from owners
2409         // Ensures that tokenId has never claimed before
2410         // Also will record which tokenId has issued a claim before
2411         for (uint i = 0; i < tokenIds.length; ++i) {
2412             uint256 tokenId = tokenIds[i];
2413             require(IERC721(GRAYCRAFT2_ADDRESS).ownerOf(tokenId) == msg.sender, "not owner");
2414             require(!gc2Claimed.get(tokenId), "claimed before");
2415             gc2Claimed.setTo(tokenId, true);
2416         }
2417 
2418         // Gets the number of crafts that can be claimed, will apply necessary multiplier
2419         uint numberOfTokens = tokenIds.length;
2420 
2421         // Max supply exceeded
2422         require(_totalMinted() + numberOfTokens <= MAX_GRAYCRAFT);
2423 
2424         // Exceeded reserved slots
2425         require(reservedGraycrafts + numberOfTokens <= MAX_RESERVED);
2426 
2427         // For each craft that we allow for claims, we add to count
2428         reservedGraycrafts += numberOfTokens;
2429 
2430         _mint(msg.sender, numberOfTokens);
2431     }
2432 
2433     // Allows whitelisted users to mint
2434     // Number of slots per address
2435     function whitelistMintGraycraft(uint numberOfTokens) external payable nonReentrant {
2436         require(claimIsActive); // During claim phase, whitelisted users can start minting
2437         require(_totalMinted() + numberOfTokens <= MAX_GRAYCRAFT); // Max supply exceeded
2438         require(graycraftPrice * numberOfTokens <= msg.value); // Value sent is not correct
2439         require(numberOfTokens <= mintPerAddress[msg.sender]); // Ensure WL mint limit is enforced
2440         
2441         mintPerAddress[msg.sender] = mintPerAddress[msg.sender] - numberOfTokens; // WL mint has a limit
2442         
2443         _mint(msg.sender, numberOfTokens);
2444     }
2445 
2446     // mints graycraft for the general public
2447     function mintGraycraft(uint numberOfTokens) external payable nonReentrant {
2448         require(saleIsActive); // Sale must be active
2449         require(_totalMinted() + numberOfTokens <= MAX_GRAYCRAFT); // Max supply exceeded
2450         require(graycraftPrice * numberOfTokens <= msg.value); // Value sent is not correct
2451 
2452         _mint(msg.sender, numberOfTokens);
2453     }
2454 
2455     /* ========== External owner functions ========== */
2456 
2457     // mints graycraft as giveaways
2458     function giveAway(address to, uint numberOfTokens) external nonReentrant onlyOwnerOrAdmin {
2459         require(_totalMinted() + numberOfTokens <= MAX_GRAYCRAFT);
2460         require(numberOfTokens <= teamGraycrafts); // Max supply exceeded
2461 
2462         _mint(to, numberOfTokens);
2463 
2464         teamGraycrafts = teamGraycrafts - numberOfTokens;
2465     }
2466 
2467     // we set the number of whitelisted amounts per user that is whitelisted that can mint
2468     function setWhitelist(address[] calldata _accounts, uint[] calldata _amounts) external onlyOwnerOrAdmin {
2469         for (uint i = 0; i < _accounts.length; ++i) {
2470             mintPerAddress[_accounts[i]] = _amounts[i];
2471         }
2472     }
2473 
2474     // withdraw funds
2475     function withdraw() external onlyOwnerOrAdmin {
2476         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2477         require(success, "Transfer failed.");
2478     }
2479 
2480     // flips the state for claims
2481     // if state is flipped from the closed state to open state, do nothing (this means we are opening claims for the first time)
2482     // if state is flipped from open to closed state, we will set the RESERVED amounts to 0, thus allowing public to mint them
2483     function flipClaimState() external onlyOwnerOrAdmin {
2484         claimIsActive = !claimIsActive;
2485     }
2486 
2487     // flips the state for sales
2488     function flipSaleState() external onlyOwnerOrAdmin {
2489         saleIsActive = !saleIsActive;
2490     }
2491 
2492     // sets price of graycraft
2493     function setGraycraftPrice(uint256 _price) external onlyOwnerOrAdmin {
2494         graycraftPrice = _price;
2495     }
2496     
2497     // set admin permissions
2498     function setAdmin(address _account, bool _activate) public onlyOwner {
2499         admins[_account] = _activate;
2500     }
2501     
2502     // set team allocation
2503     function setTeamAllocation(uint256 _amount) public onlyOwnerOrAdmin {
2504         teamGraycrafts = _amount;
2505     }
2506 
2507     // Allows the owner to set the base token URI.
2508     function setTokenURI(string calldata newUriBase) external onlyOwnerOrAdmin {
2509         _baseTokenURI = newUriBase;
2510     }
2511 
2512     /* ========== Modifiers ========== */
2513     
2514     modifier onlyOwnerOrAdmin() {
2515         require(owner() == msg.sender || admins[msg.sender], "not owner or admin");
2516         _;
2517     }
2518 
2519     /* ========== Standard token functions ========== */
2520 
2521     function setApprovalForAll(address operator, bool approved)
2522         public
2523         override (ERC721A)
2524         onlyAllowedOperatorApproval(operator)
2525     {
2526         super.setApprovalForAll(operator, approved);
2527     }
2528 
2529     function approve(address operator, uint256 tokenId)
2530         public
2531         payable
2532         override (ERC721A)
2533         onlyAllowedOperatorApproval(operator)
2534     {
2535         super.approve(operator, tokenId);
2536     }
2537 
2538     function transferFrom(address from, address to, uint256 tokenId)
2539         public
2540         payable
2541         override (ERC721A)
2542         onlyAllowedOperator(from)
2543     {
2544         super.transferFrom(from, to, tokenId);
2545     }
2546 
2547     function safeTransferFrom(address from, address to, uint256 tokenId)
2548         public
2549         payable
2550         override (ERC721A)
2551         onlyAllowedOperator(from)
2552     {
2553         super.safeTransferFrom(from, to, tokenId);
2554     }
2555 
2556     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2557         public
2558         payable
2559         override (ERC721A)
2560         onlyAllowedOperator(from)
2561     {
2562         super.safeTransferFrom(from, to, tokenId, data);
2563     }
2564 
2565     function supportsInterface(bytes4 interfaceId)
2566         public
2567         view
2568         override (ERC721A, ERC2981)
2569         returns (bool)
2570     {
2571         // Supports the following `interfaceId`s:
2572         // - IERC165: 0x01ffc9a7
2573         // - IERC721: 0x80ac58cd
2574         // - IERC721Metadata: 0x5b5e139f
2575         // - IERC2981: 0x2a55205a
2576         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
2577     }
2578 
2579     function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
2580         _setDefaultRoyalty(receiver, feeNumerator);
2581     }
2582 
2583     function setOperatorFilteringEnabled(bool value) public onlyOwner {
2584         operatorFilteringEnabled = value;
2585     }
2586 
2587     function _isPriorityOperator(address operator) internal pure override returns (bool) {
2588         // OpenSea Seaport Conduit:
2589         // https://etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
2590         // https://goerli.etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
2591         return operator == address(0x1E0049783F008A0085193E00003D00cd54003c71);
2592     }
2593 
2594     function _baseURI() internal view override returns (string memory) {
2595         return _baseTokenURI;
2596     }
2597 }