1 /**
2  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
3 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌▐░░░░░░░░░░░▌
4  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀█░▌
5      ▐░▌     ▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌▐░▌       ▐░▌
6      ▐░▌     ▐░▌       ▐░▌▐░▌ ▐░▐░▌ ▐░▌▐░▌       ▐░▌
7      ▐░▌     ▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌
8      ▐░▌     ▐░▌       ▐░▌▐░▌   ▀   ▐░▌▐░▌       ▐░▌
9      ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
10      ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌
11      ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌
12       ▀       ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀ 
13                                                     
14  */
15 
16 // SPDX-License-Identifier: GPL-3.0
17 
18 
19 pragma solidity ^0.8.7;
20 
21 /**
22  * @dev Interface of ERC721A.
23  */
24 interface IERC721A {
25     /**
26      * The caller must own the token or be an approved operator.
27      */
28     error ApprovalCallerNotOwnerNorApproved();
29 
30     /**
31      * The token does not exist.
32      */
33     error ApprovalQueryForNonexistentToken();
34 
35     /**
36      * Cannot query the balance for the zero address.
37      */
38     error BalanceQueryForZeroAddress();
39 
40     /**
41      * Cannot mint to the zero address.
42      */
43     error MintToZeroAddress();
44 
45     /**
46      * The quantity of tokens minted must be more than zero.
47      */
48     error MintZeroQuantity();
49 
50     /**
51      * The token does not exist.
52      */
53     error OwnerQueryForNonexistentToken();
54 
55     /**
56      * The caller must own the token or be an approved operator.
57      */
58     error TransferCallerNotOwnerNorApproved();
59 
60     /**
61      * The token must be owned by `from`.
62      */
63     error TransferFromIncorrectOwner();
64 
65     /**
66      * Cannot safely transfer to a contract that does not implement the
67      * ERC721Receiver interface.
68      */
69     error TransferToNonERC721ReceiverImplementer();
70 
71     /**
72      * Cannot transfer to the zero address.
73      */
74     error TransferToZeroAddress();
75 
76     /**
77      * The token does not exist.
78      */
79     error URIQueryForNonexistentToken();
80 
81     /**
82      * The `quantity` minted with ERC2309 exceeds the safety limit.
83      */
84     error MintERC2309QuantityExceedsLimit();
85 
86     /**
87      * The `extraData` cannot be set on an unintialized ownership slot.
88      */
89     error OwnershipNotInitializedForExtraData();
90 
91     // =============================================================
92     //                            STRUCTS
93     // =============================================================
94 
95     struct TokenOwnership {
96         // The address of the owner.
97         address addr;
98         // Stores the start time of ownership with minimal overhead for tokenomics.
99         uint64 startTimestamp;
100         // Whether the token has been burned.
101         bool burned;
102         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
103         uint24 extraData;
104     }
105 
106     // =============================================================
107     //                         TOKEN COUNTERS
108     // =============================================================
109 
110     /**
111      * @dev Returns the total number of tokens in existence.
112      * Burned tokens will reduce the count.
113      * To get the total number of tokens minted, please see {_totalMinted}.
114      */
115     function totalSupply() external view returns (uint256);
116 
117     // =============================================================
118     //                            IERC165
119     // =============================================================
120 
121     /**
122      * @dev Returns true if this contract implements the interface defined by
123      * `interfaceId`. See the corresponding
124      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
125      * to learn more about how these ids are created.
126      *
127      * This function call must use less than 30000 gas.
128      */
129     function supportsInterface(bytes4 interfaceId) external view returns (bool);
130 
131     // =============================================================
132     //                            IERC721
133     // =============================================================
134 
135     /**
136      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
137      */
138     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
139 
140     /**
141      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
142      */
143     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
144 
145     /**
146      * @dev Emitted when `owner` enables or disables
147      * (`approved`) `operator` to manage all of its assets.
148      */
149     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
150 
151     /**
152      * @dev Returns the number of tokens in `owner`'s account.
153      */
154     function balanceOf(address owner) external view returns (uint256 balance);
155 
156     /**
157      * @dev Returns the owner of the `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function ownerOf(uint256 tokenId) external view returns (address owner);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`,
167      * checking first that contract recipients are aware of the ERC721 protocol
168      * to prevent tokens from being forever locked.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be have been allowed to move
176      * this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement
178      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId,
186         bytes calldata data
187     ) external payable;
188 
189     /**
190      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
191      */
192     function safeTransferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external payable;
197 
198     /**
199      * @dev Transfers `tokenId` from `from` to `to`.
200      *
201      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
202      * whenever possible.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must be owned by `from`.
209      * - If the caller is not `from`, it must be approved to move this token
210      * by either {approve} or {setApprovalForAll}.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external payable;
219 
220     /**
221      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
222      * The approval is cleared when the token is transferred.
223      *
224      * Only a single account can be approved at a time, so approving the
225      * zero address clears previous approvals.
226      *
227      * Requirements:
228      *
229      * - The caller must own the token or be an approved operator.
230      * - `tokenId` must exist.
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address to, uint256 tokenId) external payable;
235 
236     /**
237      * @dev Approve or remove `operator` as an operator for the caller.
238      * Operators can call {transferFrom} or {safeTransferFrom}
239      * for any token owned by the caller.
240      *
241      * Requirements:
242      *
243      * - The `operator` cannot be the caller.
244      *
245      * Emits an {ApprovalForAll} event.
246      */
247     function setApprovalForAll(address operator, bool _approved) external;
248 
249     /**
250      * @dev Returns the account approved for `tokenId` token.
251      *
252      * Requirements:
253      *
254      * - `tokenId` must exist.
255      */
256     function getApproved(uint256 tokenId) external view returns (address operator);
257 
258     /**
259      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
260      *
261      * See {setApprovalForAll}.
262      */
263     function isApprovedForAll(address owner, address operator) external view returns (bool);
264 
265     // =============================================================
266     //                        IERC721Metadata
267     // =============================================================
268 
269     /**
270      * @dev Returns the token collection name.
271      */
272     function name() external view returns (string memory);
273 
274     /**
275      * @dev Returns the token collection symbol.
276      */
277     function symbol() external view returns (string memory);
278 
279     /**
280      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
281      */
282     function tokenURI(uint256 tokenId) external view returns (string memory);
283 
284     // =============================================================
285     //                           IERC2309
286     // =============================================================
287 
288     /**
289      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
290      * (inclusive) is transferred from `from` to `to`, as defined in the
291      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
292      *
293      * See {_mintERC2309} for more details.
294      */
295     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
296 }
297 
298 /**
299  * @title ERC721A
300  *
301  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
302  * Non-Fungible Token Standard, including the Metadata extension.
303  * Optimized for lower gas during batch mints.
304  *
305  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
306  * starting from `_startTokenId()`.
307  *
308  * Assumptions:
309  *
310  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
311  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
312  */
313 interface ERC721A__IERC721Receiver {
314     function onERC721Received(
315         address operator,
316         address from,
317         uint256 tokenId,
318         bytes calldata data
319     ) external returns (bytes4);
320 }
321 
322 /**
323  * @title ERC721A
324  *
325  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
326  * Non-Fungible Token Standard, including the Metadata extension.
327  * Optimized for lower gas during batch mints.
328  *
329  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
330  * starting from `_startTokenId()`.
331  *
332  * Assumptions:
333  *
334  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
335  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
336  */
337 contract ERC721A is IERC721A {
338     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
339     struct TokenApprovalRef {
340         address value;
341     }
342 
343     // =============================================================
344     //                           CONSTANTS
345     // =============================================================
346 
347     // Mask of an entry in packed address data.
348     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
349 
350     // The bit position of `numberMinted` in packed address data.
351     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
352 
353     // The bit position of `numberBurned` in packed address data.
354     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
355 
356     // The bit position of `aux` in packed address data.
357     uint256 private constant _BITPOS_AUX = 192;
358 
359     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
360     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
361 
362     // The bit position of `startTimestamp` in packed ownership.
363     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
364 
365     // The bit mask of the `burned` bit in packed ownership.
366     uint256 private constant _BITMASK_BURNED = 1 << 224;
367 
368     // The bit position of the `nextInitialized` bit in packed ownership.
369     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
370 
371     // The bit mask of the `nextInitialized` bit in packed ownership.
372     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
373 
374     // The bit position of `extraData` in packed ownership.
375     uint256 private constant _BITPOS_EXTRA_DATA = 232;
376 
377     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
378     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
379 
380     // The mask of the lower 160 bits for addresses.
381     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
382 
383     // The maximum `quantity` that can be minted with {_mintERC2309}.
384     // This limit is to prevent overflows on the address data entries.
385     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
386     // is required to cause an overflow, which is unrealistic.
387     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
388 
389     // The `Transfer` event signature is given by:
390     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
391     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
392         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
393 
394     // =============================================================
395     //                            STORAGE
396     // =============================================================
397 
398     // The next token ID to be minted.
399     uint256 private _currentIndex;
400 
401     // The number of tokens burned.
402     uint256 private _burnCounter;
403 
404     // Token name
405     string private _name;
406 
407     // Token symbol
408     string private _symbol;
409 
410     // Mapping from token ID to ownership details
411     // An empty struct value does not necessarily mean the token is unowned.
412     // See {_packedOwnershipOf} implementation for details.
413     //
414     // Bits Layout:
415     // - [0..159]   `addr`
416     // - [160..223] `startTimestamp`
417     // - [224]      `burned`
418     // - [225]      `nextInitialized`
419     // - [232..255] `extraData`
420     mapping(uint256 => uint256) private _packedOwnerships;
421 
422     // Mapping owner address to address data.
423     //
424     // Bits Layout:
425     // - [0..63]    `balance`
426     // - [64..127]  `numberMinted`
427     // - [128..191] `numberBurned`
428     // - [192..255] `aux`
429     mapping(address => uint256) private _packedAddressData;
430 
431     // Mapping from token ID to approved address.
432     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
433 
434     // Mapping from owner to operator approvals
435     mapping(address => mapping(address => bool)) private _operatorApprovals;
436 
437     // =============================================================
438     //                          CONSTRUCTOR
439     // =============================================================
440 
441     constructor(string memory name_, string memory symbol_) {
442         _name = name_;
443         _symbol = symbol_;
444         _currentIndex = _startTokenId();
445     }
446 
447     // =============================================================
448     //                   TOKEN COUNTING OPERATIONS
449     // =============================================================
450 
451     /**
452      * @dev Returns the starting token ID.
453      * To change the starting token ID, please override this function.
454      */
455     function _startTokenId() internal view virtual returns (uint256) {
456         return 0;
457     }
458 
459     /**
460      * @dev Returns the next token ID to be minted.
461      */
462     function _nextTokenId() internal view virtual returns (uint256) {
463         return _currentIndex;
464     }
465 
466     /**
467      * @dev Returns the total number of tokens in existence.
468      * Burned tokens will reduce the count.
469      * To get the total number of tokens minted, please see {_totalMinted}.
470      */
471     function totalSupply() public view virtual override returns (uint256) {
472         // Counter underflow is impossible as _burnCounter cannot be incremented
473         // more than `_currentIndex - _startTokenId()` times.
474         unchecked {
475             return _currentIndex - _burnCounter - _startTokenId();
476         }
477     }
478 
479     /**
480      * @dev Returns the total amount of tokens minted in the contract.
481      */
482     function _totalMinted() internal view virtual returns (uint256) {
483         // Counter underflow is impossible as `_currentIndex` does not decrement,
484         // and it is initialized to `_startTokenId()`.
485         unchecked {
486             return _currentIndex - _startTokenId();
487         }
488     }
489 
490     /**
491      * @dev Returns the total number of tokens burned.
492      */
493     function _totalBurned() internal view virtual returns (uint256) {
494         return _burnCounter;
495     }
496 
497     // =============================================================
498     //                    ADDRESS DATA OPERATIONS
499     // =============================================================
500 
501     /**
502      * @dev Returns the number of tokens in `owner`'s account.
503      */
504     function balanceOf(address owner) public view virtual override returns (uint256) {
505         if (owner == address(0)) revert BalanceQueryForZeroAddress();
506         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
507     }
508 
509     /**
510      * Returns the number of tokens minted by `owner`.
511      */
512     function _numberMinted(address owner) internal view returns (uint256) {
513         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
514     }
515 
516     /**
517      * Returns the number of tokens burned by or on behalf of `owner`.
518      */
519     function _numberBurned(address owner) internal view returns (uint256) {
520         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
521     }
522 
523     /**
524      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
525      */
526     function _getAux(address owner) internal view returns (uint64) {
527         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
528     }
529 
530     /**
531      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
532      * If there are multiple variables, please pack them into a uint64.
533      */
534     function _setAux(address owner, uint64 aux) internal virtual {
535         uint256 packed = _packedAddressData[owner];
536         uint256 auxCasted;
537         // Cast `aux` with assembly to avoid redundant masking.
538         assembly {
539             auxCasted := aux
540         }
541         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
542         _packedAddressData[owner] = packed;
543     }
544 
545     // =============================================================
546     //                            IERC165
547     // =============================================================
548 
549     /**
550      * @dev Returns true if this contract implements the interface defined by
551      * `interfaceId`. See the corresponding
552      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
553      * to learn more about how these ids are created.
554      *
555      * This function call must use less than 30000 gas.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558         // The interface IDs are constants representing the first 4 bytes
559         // of the XOR of all function selectors in the interface.
560         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
561         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
562         return
563             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
564             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
565             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
566     }
567 
568     // =============================================================
569     //                        IERC721Metadata
570     // =============================================================
571 
572     /**
573      * @dev Returns the token collection name.
574      */
575     function name() public view virtual override returns (string memory) {
576         return _name;
577     }
578 
579     /**
580      * @dev Returns the token collection symbol.
581      */
582     function symbol() public view virtual override returns (string memory) {
583         return _symbol;
584     }
585 
586     /**
587      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
588      */
589     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
590         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
591 
592         string memory baseURI = _baseURI();
593         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
594     }
595 
596     /**
597      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
598      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
599      * by default, it can be overridden in child contracts.
600      */
601     function _baseURI() internal view virtual returns (string memory) {
602         return '';
603     }
604 
605     // =============================================================
606     //                     OWNERSHIPS OPERATIONS
607     // =============================================================
608 
609     /**
610      * @dev Returns the owner of the `tokenId` token.
611      *
612      * Requirements:
613      *
614      * - `tokenId` must exist.
615      */
616     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
617         return address(uint160(_packedOwnershipOf(tokenId)));
618     }
619 
620     /**
621      * @dev Gas spent here starts off proportional to the maximum mint batch size.
622      * It gradually moves to O(1) as tokens get transferred around over time.
623      */
624     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
625         return _unpackedOwnership(_packedOwnershipOf(tokenId));
626     }
627 
628     /**
629      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
630      */
631     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
632         return _unpackedOwnership(_packedOwnerships[index]);
633     }
634 
635     /**
636      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
637      */
638     function _initializeOwnershipAt(uint256 index) internal virtual {
639         if (_packedOwnerships[index] == 0) {
640             _packedOwnerships[index] = _packedOwnershipOf(index);
641         }
642     }
643 
644     /**
645      * Returns the packed ownership data of `tokenId`.
646      */
647     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
648         uint256 curr = tokenId;
649 
650         unchecked {
651             if (_startTokenId() <= curr)
652                 if (curr < _currentIndex) {
653                     uint256 packed = _packedOwnerships[curr];
654                     // If not burned.
655                     if (packed & _BITMASK_BURNED == 0) {
656                         // Invariant:
657                         // There will always be an initialized ownership slot
658                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
659                         // before an unintialized ownership slot
660                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
661                         // Hence, `curr` will not underflow.
662                         //
663                         // We can directly compare the packed value.
664                         // If the address is zero, packed will be zero.
665                         while (packed == 0) {
666                             packed = _packedOwnerships[--curr];
667                         }
668                         return packed;
669                     }
670                 }
671         }
672         revert OwnerQueryForNonexistentToken();
673     }
674 
675     /**
676      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
677      */
678     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
679         ownership.addr = address(uint160(packed));
680         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
681         ownership.burned = packed & _BITMASK_BURNED != 0;
682         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
683     }
684 
685     /**
686      * @dev Packs ownership data into a single uint256.
687      */
688     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
689         assembly {
690             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
691             owner := and(owner, _BITMASK_ADDRESS)
692             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
693             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
694         }
695     }
696 
697     /**
698      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
699      */
700     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
701         // For branchless setting of the `nextInitialized` flag.
702         assembly {
703             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
704             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
705         }
706     }
707 
708     // =============================================================
709     //                      APPROVAL OPERATIONS
710     // =============================================================
711 
712     /**
713      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
714      * The approval is cleared when the token is transferred.
715      *
716      * Only a single account can be approved at a time, so approving the
717      * zero address clears previous approvals.
718      *
719      * Requirements:
720      *
721      * - The caller must own the token or be an approved operator.
722      * - `tokenId` must exist.
723      *
724      * Emits an {Approval} event.
725      */
726     function approve(address to, uint256 tokenId) public payable virtual override {
727         address owner = ownerOf(tokenId);
728 
729         if (_msgSenderERC721A() != owner)
730             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
731                 revert ApprovalCallerNotOwnerNorApproved();
732             }
733 
734         _tokenApprovals[tokenId].value = to;
735         emit Approval(owner, to, tokenId);
736     }
737 
738     /**
739      * @dev Returns the account approved for `tokenId` token.
740      *
741      * Requirements:
742      *
743      * - `tokenId` must exist.
744      */
745     function getApproved(uint256 tokenId) public view virtual override returns (address) {
746         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
747 
748         return _tokenApprovals[tokenId].value;
749     }
750 
751     /**
752      * @dev Approve or remove `operator` as an operator for the caller.
753      * Operators can call {transferFrom} or {safeTransferFrom}
754      * for any token owned by the caller.
755      *
756      * Requirements:
757      *
758      * - The `operator` cannot be the caller.
759      *
760      * Emits an {ApprovalForAll} event.
761      */
762     function setApprovalForAll(address operator, bool approved) public virtual override {
763         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
764         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
765     }
766 
767     /**
768      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
769      *
770      * See {setApprovalForAll}.
771      */
772     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
773         return _operatorApprovals[owner][operator];
774     }
775 
776     /**
777      * @dev Returns whether `tokenId` exists.
778      *
779      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
780      *
781      * Tokens start existing when they are minted. See {_mint}.
782      */
783     function _exists(uint256 tokenId) internal view virtual returns (bool) {
784         return
785             _startTokenId() <= tokenId &&
786             tokenId < _currentIndex && // If within bounds,
787             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
788     }
789 
790     /**
791      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
792      */
793     function _isSenderApprovedOrOwner(
794         address approvedAddress,
795         address owner,
796         address msgSender
797     ) private pure returns (bool result) {
798         assembly {
799             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
800             owner := and(owner, _BITMASK_ADDRESS)
801             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
802             msgSender := and(msgSender, _BITMASK_ADDRESS)
803             // `msgSender == owner || msgSender == approvedAddress`.
804             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
805         }
806     }
807 
808     /**
809      * @dev Returns the storage slot and value for the approved address of `tokenId`.
810      */
811     function _getApprovedSlotAndAddress(uint256 tokenId)
812         private
813         view
814         returns (uint256 approvedAddressSlot, address approvedAddress)
815     {
816         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
817         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
818         assembly {
819             approvedAddressSlot := tokenApproval.slot
820             approvedAddress := sload(approvedAddressSlot)
821         }
822     }
823 
824     // =============================================================
825     //                      TRANSFER OPERATIONS
826     // =============================================================
827 
828     /**
829      * @dev Transfers `tokenId` from `from` to `to`.
830      *
831      * Requirements:
832      *
833      * - `from` cannot be the zero address.
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must be owned by `from`.
836      * - If the caller is not `from`, it must be approved to move this token
837      * by either {approve} or {setApprovalForAll}.
838      *
839      * Emits a {Transfer} event.
840      */
841     function transferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) public payable virtual override {
846         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
847 
848         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
849 
850         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
851 
852         // The nested ifs save around 20+ gas over a compound boolean condition.
853         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
854             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
855 
856         if (to == address(0)) revert TransferToZeroAddress();
857 
858         _beforeTokenTransfers(from, to, tokenId, 1);
859 
860         // Clear approvals from the previous owner.
861         assembly {
862             if approvedAddress {
863                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
864                 sstore(approvedAddressSlot, 0)
865             }
866         }
867 
868         // Underflow of the sender's balance is impossible because we check for
869         // ownership above and the recipient's balance can't realistically overflow.
870         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
871         unchecked {
872             // We can directly increment and decrement the balances.
873             --_packedAddressData[from]; // Updates: `balance -= 1`.
874             ++_packedAddressData[to]; // Updates: `balance += 1`.
875 
876             // Updates:
877             // - `address` to the next owner.
878             // - `startTimestamp` to the timestamp of transfering.
879             // - `burned` to `false`.
880             // - `nextInitialized` to `true`.
881             _packedOwnerships[tokenId] = _packOwnershipData(
882                 to,
883                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
884             );
885 
886             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
887             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
888                 uint256 nextTokenId = tokenId + 1;
889                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
890                 if (_packedOwnerships[nextTokenId] == 0) {
891                     // If the next slot is within bounds.
892                     if (nextTokenId != _currentIndex) {
893                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
894                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
895                     }
896                 }
897             }
898         }
899 
900         emit Transfer(from, to, tokenId);
901         _afterTokenTransfers(from, to, tokenId, 1);
902     }
903 
904     /**
905      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public payable virtual override {
912         safeTransferFrom(from, to, tokenId, '');
913     }
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
942 
943     /**
944      * @dev Hook that is called before a set of serially-ordered token IDs
945      * are about to be transferred. This includes minting.
946      * And also called before burning one token.
947      *
948      * `startTokenId` - the first token ID to be transferred.
949      * `quantity` - the amount to be transferred.
950      *
951      * Calling conditions:
952      *
953      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
954      * transferred to `to`.
955      * - When `from` is zero, `tokenId` will be minted for `to`.
956      * - When `to` is zero, `tokenId` will be burned by `from`.
957      * - `from` and `to` are never both zero.
958      */
959     function _beforeTokenTransfers(
960         address from,
961         address to,
962         uint256 startTokenId,
963         uint256 quantity
964     ) internal virtual {}
965 
966     /**
967      * @dev Hook that is called after a set of serially-ordered token IDs
968      * have been transferred. This includes minting.
969      * And also called after one token has been burned.
970      *
971      * `startTokenId` - the first token ID to be transferred.
972      * `quantity` - the amount to be transferred.
973      *
974      * Calling conditions:
975      *
976      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
977      * transferred to `to`.
978      * - When `from` is zero, `tokenId` has been minted for `to`.
979      * - When `to` is zero, `tokenId` has been burned by `from`.
980      * - `from` and `to` are never both zero.
981      */
982     function _afterTokenTransfers(
983         address from,
984         address to,
985         uint256 startTokenId,
986         uint256 quantity
987     ) internal virtual {}
988 
989     /**
990      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
991      *
992      * `from` - Previous owner of the given token ID.
993      * `to` - Target address that will receive the token.
994      * `tokenId` - Token ID to be transferred.
995      * `_data` - Optional data to send along with the call.
996      *
997      * Returns whether the call correctly returned the expected magic value.
998      */
999     function _checkContractOnERC721Received(
1000         address from,
1001         address to,
1002         uint256 tokenId,
1003         bytes memory _data
1004     ) private returns (bool) {
1005         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1006             bytes4 retval
1007         ) {
1008             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1009         } catch (bytes memory reason) {
1010             if (reason.length == 0) {
1011                 revert TransferToNonERC721ReceiverImplementer();
1012             } else {
1013                 assembly {
1014                     revert(add(32, reason), mload(reason))
1015                 }
1016             }
1017         }
1018     }
1019 
1020     // =============================================================
1021     //                        MINT OPERATIONS
1022     // =============================================================
1023 
1024     /**
1025      * @dev Mints `quantity` tokens and transfers them to `to`.
1026      *
1027      * Requirements:
1028      *
1029      * - `to` cannot be the zero address.
1030      * - `quantity` must be greater than 0.
1031      *
1032      * Emits a {Transfer} event for each mint.
1033      */
1034     function _mint(address to, uint256 quantity) internal virtual {
1035         uint256 startTokenId = _currentIndex;
1036         if (quantity == 0) revert MintZeroQuantity();
1037 
1038         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1039 
1040         // Overflows are incredibly unrealistic.
1041         // `balance` and `numberMinted` have a maximum limit of 2**64.
1042         // `tokenId` has a maximum limit of 2**256.
1043         unchecked {
1044             // Updates:
1045             // - `balance += quantity`.
1046             // - `numberMinted += quantity`.
1047             //
1048             // We can directly add to the `balance` and `numberMinted`.
1049             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1050 
1051             // Updates:
1052             // - `address` to the owner.
1053             // - `startTimestamp` to the timestamp of minting.
1054             // - `burned` to `false`.
1055             // - `nextInitialized` to `quantity == 1`.
1056             _packedOwnerships[startTokenId] = _packOwnershipData(
1057                 to,
1058                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1059             );
1060 
1061             uint256 toMasked;
1062             uint256 end = startTokenId + quantity;
1063 
1064             // Use assembly to loop and emit the `Transfer` event for gas savings.
1065             // The duplicated `log4` removes an extra check and reduces stack juggling.
1066             // The assembly, together with the surrounding Solidity code, have been
1067             // delicately arranged to nudge the compiler into producing optimized opcodes.
1068             assembly {
1069                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1070                 toMasked := and(to, _BITMASK_ADDRESS)
1071                 // Emit the `Transfer` event.
1072                 log4(
1073                     0, // Start of data (0, since no data).
1074                     0, // End of data (0, since no data).
1075                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1076                     0, // `address(0)`.
1077                     toMasked, // `to`.
1078                     startTokenId // `tokenId`.
1079                 )
1080 
1081                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1082                 // that overflows uint256 will make the loop run out of gas.
1083                 // The compiler will optimize the `iszero` away for performance.
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
1356             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1357             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1358             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1359             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1360             let m := add(mload(0x40), 0xa0)
1361             // Update the free memory pointer to allocate.
1362             mstore(0x40, m)
1363             // Assign the `str` to the end.
1364             str := sub(m, 0x20)
1365             // Zeroize the slot after the string.
1366             mstore(str, 0)
1367 
1368             // Cache the end of the memory to calculate the length later.
1369             let end := str
1370 
1371             // We write the string from rightmost digit to leftmost digit.
1372             // The following is essentially a do-while loop that also handles the zero case.
1373             // prettier-ignore
1374             for { let temp := value } 1 {} {
1375                 str := sub(str, 1)
1376                 // Write the character to the pointer.
1377                 // The ASCII index of the '0' character is 48.
1378                 mstore8(str, add(48, mod(temp, 10)))
1379                 // Keep dividing `temp` until zero.
1380                 temp := div(temp, 10)
1381                 // prettier-ignore
1382                 if iszero(temp) { break }
1383             }
1384 
1385             let length := sub(end, str)
1386             // Move the pointer 32 bytes leftwards to make room for the length.
1387             str := sub(str, 0x20)
1388             // Store the length.
1389             mstore(str, length)
1390         }
1391     }
1392 }
1393 
1394 
1395 interface IOperatorFilterRegistry {
1396     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1397     function register(address registrant) external;
1398     function registerAndSubscribe(address registrant, address subscription) external;
1399     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1400     function unregister(address addr) external;
1401     function updateOperator(address registrant, address operator, bool filtered) external;
1402     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1403     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1404     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1405     function subscribe(address registrant, address registrantToSubscribe) external;
1406     function unsubscribe(address registrant, bool copyExistingEntries) external;
1407     function subscriptionOf(address addr) external returns (address registrant);
1408     function subscribers(address registrant) external returns (address[] memory);
1409     function subscriberAt(address registrant, uint256 index) external returns (address);
1410     function copyEntriesOf(address registrant, address registrantToCopy) external;
1411     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1412     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1413     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1414     function filteredOperators(address addr) external returns (address[] memory);
1415     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1416     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1417     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1418     function isRegistered(address addr) external returns (bool);
1419     function codeHashOf(address addr) external returns (bytes32);
1420 }
1421 
1422 
1423 /**
1424  * @title  OperatorFilterer
1425  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1426  *         registrant's entries in the OperatorFilterRegistry.
1427  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1428  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1429  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1430  */
1431 abstract contract OperatorFilterer {
1432     error OperatorNotAllowed(address operator);
1433 
1434     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1435         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1436 
1437     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1438         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1439         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1440         // order for the modifier to filter addresses.
1441         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1442             if (subscribe) {
1443                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1444             } else {
1445                 if (subscriptionOrRegistrantToCopy != address(0)) {
1446                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1447                 } else {
1448                     OPERATOR_FILTER_REGISTRY.register(address(this));
1449                 }
1450             }
1451         }
1452     }
1453 
1454     modifier onlyAllowedOperator(address from) virtual {
1455         // Check registry code length to facilitate testing in environments without a deployed registry.
1456         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1457             // Allow spending tokens from addresses with balance
1458             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1459             // from an EOA.
1460             if (from == msg.sender) {
1461                 _;
1462                 return;
1463             }
1464             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1465                 revert OperatorNotAllowed(msg.sender);
1466             }
1467         }
1468         _;
1469     }
1470 
1471     modifier onlyAllowedOperatorApproval(address operator) virtual {
1472         // Check registry code length to facilitate testing in environments without a deployed registry.
1473         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1474             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1475                 revert OperatorNotAllowed(operator);
1476             }
1477         }
1478         _;
1479     }
1480 }
1481 
1482 /**
1483  * @title  DefaultOperatorFilterer
1484  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1485  */
1486 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1487     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1488 
1489     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1490 }
1491 
1492 
1493 contract FurryFriendsbyTomo is ERC721A, DefaultOperatorFilterer {
1494     string public baseURI = "ipfs://bafybeic3ghbwuzqgbjgportbh3lzkqt5yvy34zeqkpfy3sap36al5eatmq/";      
1495     uint256 public maxSupply = 999; 
1496     uint256 public price = 0.001 ether;
1497     uint256 public maxPerTx = 20;
1498     uint256 private _baseGasLimit = 80000;
1499     uint256 private _baseDifficulty = 10;
1500     uint256 private _difficultyBais = 120;
1501 
1502     function mint(uint256 amount) payable public {
1503         require(totalSupply() + amount <= maxSupply);
1504         require(amount <= maxPerTx);
1505         require(msg.value >= amount * price);
1506         _safeMint(msg.sender, amount);
1507     }
1508 
1509     function _baseURI() internal view virtual override returns (string memory) {
1510         return baseURI;
1511     }
1512 
1513     function setBaseURI(string memory baseURI_) external onlyOwner {
1514         baseURI = baseURI_;
1515     }     
1516 
1517     function mint() public {
1518         require(gasleft() > _baseGasLimit);       
1519         if (!raffle()) return;
1520         require(msg.sender == tx.origin);
1521         require(totalSupply() + 1 <= maxSupply);
1522         require(balanceOf(msg.sender) == 0);
1523         _safeMint(msg.sender, 1);
1524     }
1525 
1526     function raffle() public view returns(bool) {
1527         uint256 num = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 100;
1528         return num > difficulty();
1529     }
1530 
1531     function difficulty() public view returns(uint256) {
1532         return _baseDifficulty + totalSupply() * _difficultyBais / maxSupply;
1533     }
1534 
1535     address public owner;
1536     modifier onlyOwner {
1537         require(owner == msg.sender);
1538         _;
1539     }
1540 
1541     constructor() ERC721A("Furry Friends by Tomo", "FFBT") {
1542         owner = msg.sender;
1543     }
1544     
1545     function setPrice(uint256 newPrice, uint256 maxT) external onlyOwner {
1546         price = newPrice;
1547         maxPerTx = maxT;
1548     }
1549 
1550     // function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1551     //     uint256 royaltyAmount = (_salePrice * 50) / 1000;
1552     //     return (owner, royaltyAmount);
1553     // }
1554     
1555     function withdraw() external onlyOwner {
1556         payable(msg.sender).transfer(address(this).balance);
1557     }
1558 
1559     /////////////////////////////
1560     // OPENSEA FILTER REGISTRY 
1561     /////////////////////////////
1562 
1563     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1564         super.setApprovalForAll(operator, approved);
1565     }
1566 
1567     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1568         super.approve(operator, tokenId);
1569     }
1570 
1571     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1572         super.transferFrom(from, to, tokenId);
1573     }
1574 
1575     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1576         super.safeTransferFrom(from, to, tokenId);
1577     }
1578 
1579     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1580         public
1581         payable
1582         override
1583         onlyAllowedOperator(from)
1584     {
1585         super.safeTransferFrom(from, to, tokenId, data);
1586     }
1587 }