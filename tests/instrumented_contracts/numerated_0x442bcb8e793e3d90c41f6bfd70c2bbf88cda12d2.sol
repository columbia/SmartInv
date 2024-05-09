1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 
4 /**
5  * @dev Interface of ERC721A.
6  */
7 interface IERC721A {
8     /**
9      * The caller must own the token or be an approved operator.
10      */
11     error ApprovalCallerNotOwnerNorApproved();
12 
13     /**
14      * The token does not exist.
15      */
16     error ApprovalQueryForNonexistentToken();
17 
18     /**
19      * Cannot query the balance for the zero address.
20      */
21     error BalanceQueryForZeroAddress();
22 
23     /**
24      * Cannot mint to the zero address.
25      */
26     error MintToZeroAddress();
27 
28     /**
29      * The quantity of tokens minted must be more than zero.
30      */
31     error MintZeroQuantity();
32 
33     /**
34      * The token does not exist.
35      */
36     error OwnerQueryForNonexistentToken();
37 
38     /**
39      * The caller must own the token or be an approved operator.
40      */
41     error TransferCallerNotOwnerNorApproved();
42 
43     /**
44      * The token must be owned by `from`.
45      */
46     error TransferFromIncorrectOwner();
47 
48     /**
49      * Cannot safely transfer to a contract that does not implement the
50      * ERC721Receiver interface.
51      */
52     error TransferToNonERC721ReceiverImplementer();
53 
54     /**
55      * Cannot transfer to the zero address.
56      */
57     error TransferToZeroAddress();
58 
59     /**
60      * The token does not exist.
61      */
62     error URIQueryForNonexistentToken();
63 
64     /**
65      * The `quantity` minted with ERC2309 exceeds the safety limit.
66      */
67     error MintERC2309QuantityExceedsLimit();
68 
69     /**
70      * The `extraData` cannot be set on an unintialized ownership slot.
71      */
72     error OwnershipNotInitializedForExtraData();
73 
74     // =============================================================
75     //                            STRUCTS
76     // =============================================================
77 
78     struct TokenOwnership {
79         // The address of the owner.
80         address addr;
81         // Stores the start time of ownership with minimal overhead for tokenomics.
82         uint64 startTimestamp;
83         // Whether the token has been burned.
84         bool burned;
85         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
86         uint24 extraData;
87     }
88 
89     // =============================================================
90     //                         TOKEN COUNTERS
91     // =============================================================
92 
93     /**
94      * @dev Returns the total number of tokens in existence.
95      * Burned tokens will reduce the count.
96      * To get the total number of tokens minted, please see {_totalMinted}.
97      */
98     function totalSupply() external view returns (uint256);
99 
100     // =============================================================
101     //                            IERC165
102     // =============================================================
103 
104     /**
105      * @dev Returns true if this contract implements the interface defined by
106      * `interfaceId`. See the corresponding
107      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
108      * to learn more about how these ids are created.
109      *
110      * This function call must use less than 30000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 
114     // =============================================================
115     //                            IERC721
116     // =============================================================
117 
118     /**
119      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
122 
123     /**
124      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
125      */
126     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables or disables
130      * (`approved`) `operator` to manage all of its assets.
131      */
132     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
133 
134     /**
135      * @dev Returns the number of tokens in `owner`'s account.
136      */
137     function balanceOf(address owner) external view returns (uint256 balance);
138 
139     /**
140      * @dev Returns the owner of the `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function ownerOf(uint256 tokenId) external view returns (address owner);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`,
150      * checking first that contract recipients are aware of the ERC721 protocol
151      * to prevent tokens from being forever locked.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be have been allowed to move
159      * this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement
161      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external payable;
171 
172     /**
173      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external payable;
180 
181     /**
182      * @dev Transfers `tokenId` from `from` to `to`.
183      *
184      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
185      * whenever possible.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must be owned by `from`.
192      * - If the caller is not `from`, it must be approved to move this token
193      * by either {approve} or {setApprovalForAll}.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(
198         address from,
199         address to,
200         uint256 tokenId
201     ) external payable;
202 
203     /**
204      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
205      * The approval is cleared when the token is transferred.
206      *
207      * Only a single account can be approved at a time, so approving the
208      * zero address clears previous approvals.
209      *
210      * Requirements:
211      *
212      * - The caller must own the token or be an approved operator.
213      * - `tokenId` must exist.
214      *
215      * Emits an {Approval} event.
216      */
217     function approve(address to, uint256 tokenId) external payable;
218 
219     /**
220      * @dev Approve or remove `operator` as an operator for the caller.
221      * Operators can call {transferFrom} or {safeTransferFrom}
222      * for any token owned by the caller.
223      *
224      * Requirements:
225      *
226      * - The `operator` cannot be the caller.
227      *
228      * Emits an {ApprovalForAll} event.
229      */
230     function setApprovalForAll(address operator, bool _approved) external;
231 
232     /**
233      * @dev Returns the account approved for `tokenId` token.
234      *
235      * Requirements:
236      *
237      * - `tokenId` must exist.
238      */
239     function getApproved(uint256 tokenId) external view returns (address operator);
240 
241     /**
242      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
243      *
244      * See {setApprovalForAll}.
245      */
246     function isApprovedForAll(address owner, address operator) external view returns (bool);
247 
248     // =============================================================
249     //                        IERC721Metadata
250     // =============================================================
251 
252     /**
253      * @dev Returns the token collection name.
254      */
255     function name() external view returns (string memory);
256 
257     /**
258      * @dev Returns the token collection symbol.
259      */
260     function symbol() external view returns (string memory);
261 
262     /**
263      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
264      */
265     function tokenURI(uint256 tokenId) external view returns (string memory);
266 
267     // =============================================================
268     //                           IERC2309
269     // =============================================================
270 
271     /**
272      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
273      * (inclusive) is transferred from `from` to `to`, as defined in the
274      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
275      *
276      * See {_mintERC2309} for more details.
277      */
278     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
279 }
280 
281 /**
282  * @dev Interface of ERC721 token receiver.
283  */
284 interface ERC721A__IERC721Receiver {
285     function onERC721Received(
286         address operator,
287         address from,
288         uint256 tokenId,
289         bytes calldata data
290     ) external returns (bytes4);
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
308 contract ERC721A is IERC721A {
309     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
310     struct TokenApprovalRef {
311         address value;
312     }
313 
314     // =============================================================
315     //                           CONSTANTS
316     // =============================================================
317 
318     // Mask of an entry in packed address data.
319     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
320 
321     // The bit position of `numberMinted` in packed address data.
322     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
323 
324     // The bit position of `numberBurned` in packed address data.
325     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
326 
327     // The bit position of `aux` in packed address data.
328     uint256 private constant _BITPOS_AUX = 192;
329 
330     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
331     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
332 
333     // The bit position of `startTimestamp` in packed ownership.
334     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
335 
336     // The bit mask of the `burned` bit in packed ownership.
337     uint256 private constant _BITMASK_BURNED = 1 << 224;
338 
339     // The bit position of the `nextInitialized` bit in packed ownership.
340     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
341 
342     // The bit mask of the `nextInitialized` bit in packed ownership.
343     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
344 
345     // The bit position of `extraData` in packed ownership.
346     uint256 private constant _BITPOS_EXTRA_DATA = 232;
347 
348     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
349     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
350 
351     // The mask of the lower 160 bits for addresses.
352     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
353 
354     // The maximum `quantity` that can be minted with {_mintERC2309}.
355     // This limit is to prevent overflows on the address data entries.
356     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
357     // is required to cause an overflow, which is unrealistic.
358     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
359 
360     // The `Transfer` event signature is given by:
361     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
362     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
363         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
364 
365     // =============================================================
366     //                            STORAGE
367     // =============================================================
368 
369     // The next token ID to be minted.
370     uint256 private _currentIndex;
371 
372     // The number of tokens burned.
373     uint256 private _burnCounter;
374 
375     // Token name
376     string private _name;
377 
378     // Token symbol
379     string private _symbol;
380 
381     // Mapping from token ID to ownership details
382     // An empty struct value does not necessarily mean the token is unowned.
383     // See {_packedOwnershipOf} implementation for details.
384     //
385     // Bits Layout:
386     // - [0..159]   `addr`
387     // - [160..223] `startTimestamp`
388     // - [224]      `burned`
389     // - [225]      `nextInitialized`
390     // - [232..255] `extraData`
391     mapping(uint256 => uint256) private _packedOwnerships;
392 
393     // Mapping owner address to address data.
394     //
395     // Bits Layout:
396     // - [0..63]    `balance`
397     // - [64..127]  `numberMinted`
398     // - [128..191] `numberBurned`
399     // - [192..255] `aux`
400     mapping(address => uint256) private _packedAddressData;
401 
402     // Mapping from token ID to approved address.
403     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
404 
405     // Mapping from owner to operator approvals
406     mapping(address => mapping(address => bool)) private _operatorApprovals;
407 
408     // =============================================================
409     //                          CONSTRUCTOR
410     // =============================================================
411 
412     constructor(string memory name_, string memory symbol_) {
413         _name = name_;
414         _symbol = symbol_;
415         _currentIndex = _startTokenId();
416     }
417 
418     // =============================================================
419     //                   TOKEN COUNTING OPERATIONS
420     // =============================================================
421 
422     /**
423      * @dev Returns the starting token ID.
424      * To change the starting token ID, please override this function.
425      */
426     function _startTokenId() internal view virtual returns (uint256) {
427         return 0;
428     }
429 
430     /**
431      * @dev Returns the next token ID to be minted.
432      */
433     function _nextTokenId() internal view virtual returns (uint256) {
434         return _currentIndex;
435     }
436 
437     /**
438      * @dev Returns the total number of tokens in existence.
439      * Burned tokens will reduce the count.
440      * To get the total number of tokens minted, please see {_totalMinted}.
441      */
442     function totalSupply() public view virtual override returns (uint256) {
443         // Counter underflow is impossible as _burnCounter cannot be incremented
444         // more than `_currentIndex - _startTokenId()` times.
445         unchecked {
446             return _currentIndex - _burnCounter - _startTokenId();
447         }
448     }
449 
450     /**
451      * @dev Returns the total amount of tokens minted in the contract.
452      */
453     function _totalMinted() internal view virtual returns (uint256) {
454         // Counter underflow is impossible as `_currentIndex` does not decrement,
455         // and it is initialized to `_startTokenId()`.
456         unchecked {
457             return _currentIndex - _startTokenId();
458         }
459     }
460 
461     /**
462      * @dev Returns the total number of tokens burned.
463      */
464     function _totalBurned() internal view virtual returns (uint256) {
465         return _burnCounter;
466     }
467 
468     // =============================================================
469     //                    ADDRESS DATA OPERATIONS
470     // =============================================================
471 
472     /**
473      * @dev Returns the number of tokens in `owner`'s account.
474      */
475     function balanceOf(address owner) public view virtual override returns (uint256) {
476         if (owner == address(0)) revert BalanceQueryForZeroAddress();
477         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
478     }
479 
480     /**
481      * Returns the number of tokens minted by `owner`.
482      */
483     function _numberMinted(address owner) internal view returns (uint256) {
484         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
485     }
486 
487     /**
488      * Returns the number of tokens burned by or on behalf of `owner`.
489      */
490     function _numberBurned(address owner) internal view returns (uint256) {
491         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
492     }
493 
494     /**
495      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
496      */
497     function _getAux(address owner) internal view returns (uint64) {
498         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
499     }
500 
501     /**
502      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
503      * If there are multiple variables, please pack them into a uint64.
504      */
505     function _setAux(address owner, uint64 aux) internal virtual {
506         uint256 packed = _packedAddressData[owner];
507         uint256 auxCasted;
508         // Cast `aux` with assembly to avoid redundant masking.
509         assembly {
510             auxCasted := aux
511         }
512         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
513         _packedAddressData[owner] = packed;
514     }
515 
516     // =============================================================
517     //                            IERC165
518     // =============================================================
519 
520     /**
521      * @dev Returns true if this contract implements the interface defined by
522      * `interfaceId`. See the corresponding
523      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
524      * to learn more about how these ids are created.
525      *
526      * This function call must use less than 30000 gas.
527      */
528     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529         // The interface IDs are constants representing the first 4 bytes
530         // of the XOR of all function selectors in the interface.
531         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
532         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
533         return
534             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
535             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
536             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
537     }
538 
539     // =============================================================
540     //                        IERC721Metadata
541     // =============================================================
542 
543     /**
544      * @dev Returns the token collection name.
545      */
546     function name() public view virtual override returns (string memory) {
547         return _name;
548     }
549 
550     /**
551      * @dev Returns the token collection symbol.
552      */
553     function symbol() public view virtual override returns (string memory) {
554         return _symbol;
555     }
556 
557     /**
558      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
559      */
560     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
561         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
562 
563         string memory baseURI = _baseURI();
564         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
565     }
566 
567     /**
568      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
569      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
570      * by default, it can be overridden in child contracts.
571      */
572     function _baseURI() internal view virtual returns (string memory) {
573         return '';
574     }
575 
576     // =============================================================
577     //                     OWNERSHIPS OPERATIONS
578     // =============================================================
579 
580     /**
581      * @dev Returns the owner of the `tokenId` token.
582      *
583      * Requirements:
584      *
585      * - `tokenId` must exist.
586      */
587     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
588         return address(uint160(_packedOwnershipOf(tokenId)));
589     }
590 
591     /**
592      * @dev Gas spent here starts off proportional to the maximum mint batch size.
593      * It gradually moves to O(1) as tokens get transferred around over time.
594      */
595     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
596         return _unpackedOwnership(_packedOwnershipOf(tokenId));
597     }
598 
599     /**
600      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
601      */
602     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
603         return _unpackedOwnership(_packedOwnerships[index]);
604     }
605 
606     /**
607      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
608      */
609     function _initializeOwnershipAt(uint256 index) internal virtual {
610         if (_packedOwnerships[index] == 0) {
611             _packedOwnerships[index] = _packedOwnershipOf(index);
612         }
613     }
614 
615     /**
616      * Returns the packed ownership data of `tokenId`.
617      */
618     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
619         uint256 curr = tokenId;
620 
621         unchecked {
622             if (_startTokenId() <= curr)
623                 if (curr < _currentIndex) {
624                     uint256 packed = _packedOwnerships[curr];
625                     // If not burned.
626                     if (packed & _BITMASK_BURNED == 0) {
627                         // Invariant:
628                         // There will always be an initialized ownership slot
629                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
630                         // before an unintialized ownership slot
631                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
632                         // Hence, `curr` will not underflow.
633                         //
634                         // We can directly compare the packed value.
635                         // If the address is zero, packed will be zero.
636                         while (packed == 0) {
637                             packed = _packedOwnerships[--curr];
638                         }
639                         return packed;
640                     }
641                 }
642         }
643         revert OwnerQueryForNonexistentToken();
644     }
645 
646     /**
647      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
648      */
649     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
650         ownership.addr = address(uint160(packed));
651         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
652         ownership.burned = packed & _BITMASK_BURNED != 0;
653         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
654     }
655 
656     /**
657      * @dev Packs ownership data into a single uint256.
658      */
659     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
660         assembly {
661             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
662             owner := and(owner, _BITMASK_ADDRESS)
663             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
664             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
665         }
666     }
667 
668     /**
669      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
670      */
671     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
672         // For branchless setting of the `nextInitialized` flag.
673         assembly {
674             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
675             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
676         }
677     }
678 
679     // =============================================================
680     //                      APPROVAL OPERATIONS
681     // =============================================================
682 
683     /**
684      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
685      * The approval is cleared when the token is transferred.
686      *
687      * Only a single account can be approved at a time, so approving the
688      * zero address clears previous approvals.
689      *
690      * Requirements:
691      *
692      * - The caller must own the token or be an approved operator.
693      * - `tokenId` must exist.
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address to, uint256 tokenId) public payable virtual override {
698         address owner = ownerOf(tokenId);
699 
700         if (_msgSenderERC721A() != owner)
701             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
702                 revert ApprovalCallerNotOwnerNorApproved();
703             }
704 
705         _tokenApprovals[tokenId].value = to;
706         emit Approval(owner, to, tokenId);
707     }
708 
709     /**
710      * @dev Returns the account approved for `tokenId` token.
711      *
712      * Requirements:
713      *
714      * - `tokenId` must exist.
715      */
716     function getApproved(uint256 tokenId) public view virtual override returns (address) {
717         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
718 
719         return _tokenApprovals[tokenId].value;
720     }
721 
722     /**
723      * @dev Approve or remove `operator` as an operator for the caller.
724      * Operators can call {transferFrom} or {safeTransferFrom}
725      * for any token owned by the caller.
726      *
727      * Requirements:
728      *
729      * - The `operator` cannot be the caller.
730      *
731      * Emits an {ApprovalForAll} event.
732      */
733     function setApprovalForAll(address operator, bool approved) public virtual override {
734         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
735         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
736     }
737 
738     /**
739      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
740      *
741      * See {setApprovalForAll}.
742      */
743     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
744         return _operatorApprovals[owner][operator];
745     }
746 
747     /**
748      * @dev Returns whether `tokenId` exists.
749      *
750      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
751      *
752      * Tokens start existing when they are minted. See {_mint}.
753      */
754     function _exists(uint256 tokenId) internal view virtual returns (bool) {
755         return
756             _startTokenId() <= tokenId &&
757             tokenId < _currentIndex && // If within bounds,
758             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
759     }
760 
761     /**
762      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
763      */
764     function _isSenderApprovedOrOwner(
765         address approvedAddress,
766         address owner,
767         address msgSender
768     ) private pure returns (bool result) {
769         assembly {
770             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
771             owner := and(owner, _BITMASK_ADDRESS)
772             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
773             msgSender := and(msgSender, _BITMASK_ADDRESS)
774             // `msgSender == owner || msgSender == approvedAddress`.
775             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
776         }
777     }
778 
779     /**
780      * @dev Returns the storage slot and value for the approved address of `tokenId`.
781      */
782     function _getApprovedSlotAndAddress(uint256 tokenId)
783         private
784         view
785         returns (uint256 approvedAddressSlot, address approvedAddress)
786     {
787         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
788         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
789         assembly {
790             approvedAddressSlot := tokenApproval.slot
791             approvedAddress := sload(approvedAddressSlot)
792         }
793     }
794 
795     // =============================================================
796     //                      TRANSFER OPERATIONS
797     // =============================================================
798 
799     /**
800      * @dev Transfers `tokenId` from `from` to `to`.
801      *
802      * Requirements:
803      *
804      * - `from` cannot be the zero address.
805      * - `to` cannot be the zero address.
806      * - `tokenId` token must be owned by `from`.
807      * - If the caller is not `from`, it must be approved to move this token
808      * by either {approve} or {setApprovalForAll}.
809      *
810      * Emits a {Transfer} event.
811      */
812     function transferFrom(
813         address from,
814         address to,
815         uint256 tokenId
816     ) public payable virtual override {
817         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
818 
819         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
820 
821         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
822 
823         // The nested ifs save around 20+ gas over a compound boolean condition.
824         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
825             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
826 
827         if (to == address(0)) revert TransferToZeroAddress();
828 
829         _beforeTokenTransfers(from, to, tokenId, 1);
830 
831         // Clear approvals from the previous owner.
832         assembly {
833             if approvedAddress {
834                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
835                 sstore(approvedAddressSlot, 0)
836             }
837         }
838 
839         // Underflow of the sender's balance is impossible because we check for
840         // ownership above and the recipient's balance can't realistically overflow.
841         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
842         unchecked {
843             // We can directly increment and decrement the balances.
844             --_packedAddressData[from]; // Updates: `balance -= 1`.
845             ++_packedAddressData[to]; // Updates: `balance += 1`.
846 
847             // Updates:
848             // - `address` to the next owner.
849             // - `startTimestamp` to the timestamp of transfering.
850             // - `burned` to `false`.
851             // - `nextInitialized` to `true`.
852             _packedOwnerships[tokenId] = _packOwnershipData(
853                 to,
854                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
855             );
856 
857             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
858             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
859                 uint256 nextTokenId = tokenId + 1;
860                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
861                 if (_packedOwnerships[nextTokenId] == 0) {
862                     // If the next slot is within bounds.
863                     if (nextTokenId != _currentIndex) {
864                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
865                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
866                     }
867                 }
868             }
869         }
870 
871         emit Transfer(from, to, tokenId);
872         _afterTokenTransfers(from, to, tokenId, 1);
873     }
874 
875     /**
876      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public payable virtual override {
883         safeTransferFrom(from, to, tokenId, '');
884     }
885 
886     /**
887      * @dev Safely transfers `tokenId` token from `from` to `to`.
888      *
889      * Requirements:
890      *
891      * - `from` cannot be the zero address.
892      * - `to` cannot be the zero address.
893      * - `tokenId` token must exist and be owned by `from`.
894      * - If the caller is not `from`, it must be approved to move this token
895      * by either {approve} or {setApprovalForAll}.
896      * - If `to` refers to a smart contract, it must implement
897      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
898      *
899      * Emits a {Transfer} event.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) public payable virtual override {
907         transferFrom(from, to, tokenId);
908         if (to.code.length != 0)
909             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
910                 revert TransferToNonERC721ReceiverImplementer();
911             }
912     }
913 
914     /**
915      * @dev Hook that is called before a set of serially-ordered token IDs
916      * are about to be transferred. This includes minting.
917      * And also called before burning one token.
918      *
919      * `startTokenId` - the first token ID to be transferred.
920      * `quantity` - the amount to be transferred.
921      *
922      * Calling conditions:
923      *
924      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
925      * transferred to `to`.
926      * - When `from` is zero, `tokenId` will be minted for `to`.
927      * - When `to` is zero, `tokenId` will be burned by `from`.
928      * - `from` and `to` are never both zero.
929      */
930     function _beforeTokenTransfers(
931         address from,
932         address to,
933         uint256 startTokenId,
934         uint256 quantity
935     ) internal virtual {}
936 
937     /**
938      * @dev Hook that is called after a set of serially-ordered token IDs
939      * have been transferred. This includes minting.
940      * And also called after one token has been burned.
941      *
942      * `startTokenId` - the first token ID to be transferred.
943      * `quantity` - the amount to be transferred.
944      *
945      * Calling conditions:
946      *
947      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
948      * transferred to `to`.
949      * - When `from` is zero, `tokenId` has been minted for `to`.
950      * - When `to` is zero, `tokenId` has been burned by `from`.
951      * - `from` and `to` are never both zero.
952      */
953     function _afterTokenTransfers(
954         address from,
955         address to,
956         uint256 startTokenId,
957         uint256 quantity
958     ) internal virtual {}
959 
960     /**
961      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
962      *
963      * `from` - Previous owner of the given token ID.
964      * `to` - Target address that will receive the token.
965      * `tokenId` - Token ID to be transferred.
966      * `_data` - Optional data to send along with the call.
967      *
968      * Returns whether the call correctly returned the expected magic value.
969      */
970     function _checkContractOnERC721Received(
971         address from,
972         address to,
973         uint256 tokenId,
974         bytes memory _data
975     ) private returns (bool) {
976         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
977             bytes4 retval
978         ) {
979             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
980         } catch (bytes memory reason) {
981             if (reason.length == 0) {
982                 revert TransferToNonERC721ReceiverImplementer();
983             } else {
984                 assembly {
985                     revert(add(32, reason), mload(reason))
986                 }
987             }
988         }
989     }
990 
991     // =============================================================
992     //                        MINT OPERATIONS
993     // =============================================================
994 
995     /**
996      * @dev Mints `quantity` tokens and transfers them to `to`.
997      *
998      * Requirements:
999      *
1000      * - `to` cannot be the zero address.
1001      * - `quantity` must be greater than 0.
1002      *
1003      * Emits a {Transfer} event for each mint.
1004      */
1005     function _mint(address to, uint256 quantity) internal virtual {
1006         uint256 startTokenId = _currentIndex;
1007         if (quantity == 0) revert MintZeroQuantity();
1008 
1009         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1010 
1011         // Overflows are incredibly unrealistic.
1012         // `balance` and `numberMinted` have a maximum limit of 2**64.
1013         // `tokenId` has a maximum limit of 2**256.
1014         unchecked {
1015             // Updates:
1016             // - `balance += quantity`.
1017             // - `numberMinted += quantity`.
1018             //
1019             // We can directly add to the `balance` and `numberMinted`.
1020             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1021 
1022             // Updates:
1023             // - `address` to the owner.
1024             // - `startTimestamp` to the timestamp of minting.
1025             // - `burned` to `false`.
1026             // - `nextInitialized` to `quantity == 1`.
1027             _packedOwnerships[startTokenId] = _packOwnershipData(
1028                 to,
1029                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1030             );
1031 
1032             uint256 toMasked;
1033             uint256 end = startTokenId + quantity;
1034 
1035             // Use assembly to loop and emit the `Transfer` event for gas savings.
1036             // The duplicated `log4` removes an extra check and reduces stack juggling.
1037             // The assembly, together with the surrounding Solidity code, have been
1038             // delicately arranged to nudge the compiler into producing optimized opcodes.
1039             assembly {
1040                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1041                 toMasked := and(to, _BITMASK_ADDRESS)
1042                 // Emit the `Transfer` event.
1043                 log4(
1044                     0, // Start of data (0, since no data).
1045                     0, // End of data (0, since no data).
1046                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1047                     0, // `address(0)`.
1048                     toMasked, // `to`.
1049                     startTokenId // `tokenId`.
1050                 )
1051 
1052                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1053                 // that overflows uint256 will make the loop run out of gas.
1054                 // The compiler will optimize the `iszero` away for performance.
1055                 for {
1056                     let tokenId := add(startTokenId, 1)
1057                 } iszero(eq(tokenId, end)) {
1058                     tokenId := add(tokenId, 1)
1059                 } {
1060                     // Emit the `Transfer` event. Similar to above.
1061                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1062                 }
1063             }
1064             if (toMasked == 0) revert MintToZeroAddress();
1065 
1066             _currentIndex = end;
1067         }
1068         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1069     }
1070 
1071     /**
1072      * @dev Mints `quantity` tokens and transfers them to `to`.
1073      *
1074      * This function is intended for efficient minting only during contract creation.
1075      *
1076      * It emits only one {ConsecutiveTransfer} as defined in
1077      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1078      * instead of a sequence of {Transfer} event(s).
1079      *
1080      * Calling this function outside of contract creation WILL make your contract
1081      * non-compliant with the ERC721 standard.
1082      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1083      * {ConsecutiveTransfer} event is only permissible during contract creation.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {ConsecutiveTransfer} event.
1091      */
1092     function _mintERC2309(address to, uint256 quantity) internal virtual {
1093         uint256 startTokenId = _currentIndex;
1094         if (to == address(0)) revert MintToZeroAddress();
1095         if (quantity == 0) revert MintZeroQuantity();
1096         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1097 
1098         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1099 
1100         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1101         unchecked {
1102             // Updates:
1103             // - `balance += quantity`.
1104             // - `numberMinted += quantity`.
1105             //
1106             // We can directly add to the `balance` and `numberMinted`.
1107             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1108 
1109             // Updates:
1110             // - `address` to the owner.
1111             // - `startTimestamp` to the timestamp of minting.
1112             // - `burned` to `false`.
1113             // - `nextInitialized` to `quantity == 1`.
1114             _packedOwnerships[startTokenId] = _packOwnershipData(
1115                 to,
1116                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1117             );
1118 
1119             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1120 
1121             _currentIndex = startTokenId + quantity;
1122         }
1123         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1124     }
1125 
1126     /**
1127      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1128      *
1129      * Requirements:
1130      *
1131      * - If `to` refers to a smart contract, it must implement
1132      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1133      * - `quantity` must be greater than 0.
1134      *
1135      * See {_mint}.
1136      *
1137      * Emits a {Transfer} event for each mint.
1138      */
1139     function _safeMint(
1140         address to,
1141         uint256 quantity,
1142         bytes memory _data
1143     ) internal virtual {
1144         _mint(to, quantity);
1145 
1146         unchecked {
1147             if (to.code.length != 0) {
1148                 uint256 end = _currentIndex;
1149                 uint256 index = end - quantity;
1150                 do {
1151                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1152                         revert TransferToNonERC721ReceiverImplementer();
1153                     }
1154                 } while (index < end);
1155                 // Reentrancy protection.
1156                 if (_currentIndex != end) revert();
1157             }
1158         }
1159     }
1160 
1161     /**
1162      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1163      */
1164     function _safeMint(address to, uint256 quantity) internal virtual {
1165         _safeMint(to, quantity, '');
1166     }
1167 
1168     // =============================================================
1169     //                        BURN OPERATIONS
1170     // =============================================================
1171 
1172     /**
1173      * @dev Equivalent to `_burn(tokenId, false)`.
1174      */
1175     function _burn(uint256 tokenId) internal virtual {
1176         _burn(tokenId, false);
1177     }
1178 
1179     /**
1180      * @dev Destroys `tokenId`.
1181      * The approval is cleared when the token is burned.
1182      *
1183      * Requirements:
1184      *
1185      * - `tokenId` must exist.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1190         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1191 
1192         address from = address(uint160(prevOwnershipPacked));
1193 
1194         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1195 
1196         if (approvalCheck) {
1197             // The nested ifs save around 20+ gas over a compound boolean condition.
1198             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1199                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1200         }
1201 
1202         _beforeTokenTransfers(from, address(0), tokenId, 1);
1203 
1204         // Clear approvals from the previous owner.
1205         assembly {
1206             if approvedAddress {
1207                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1208                 sstore(approvedAddressSlot, 0)
1209             }
1210         }
1211 
1212         // Underflow of the sender's balance is impossible because we check for
1213         // ownership above and the recipient's balance can't realistically overflow.
1214         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1215         unchecked {
1216             // Updates:
1217             // - `balance -= 1`.
1218             // - `numberBurned += 1`.
1219             //
1220             // We can directly decrement the balance, and increment the number burned.
1221             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1222             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1223 
1224             // Updates:
1225             // - `address` to the last owner.
1226             // - `startTimestamp` to the timestamp of burning.
1227             // - `burned` to `true`.
1228             // - `nextInitialized` to `true`.
1229             _packedOwnerships[tokenId] = _packOwnershipData(
1230                 from,
1231                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1232             );
1233 
1234             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1235             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1236                 uint256 nextTokenId = tokenId + 1;
1237                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1238                 if (_packedOwnerships[nextTokenId] == 0) {
1239                     // If the next slot is within bounds.
1240                     if (nextTokenId != _currentIndex) {
1241                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1242                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1243                     }
1244                 }
1245             }
1246         }
1247 
1248         emit Transfer(from, address(0), tokenId);
1249         _afterTokenTransfers(from, address(0), tokenId, 1);
1250 
1251         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1252         unchecked {
1253             _burnCounter++;
1254         }
1255     }
1256 
1257     // =============================================================
1258     //                     EXTRA DATA OPERATIONS
1259     // =============================================================
1260 
1261     /**
1262      * @dev Directly sets the extra data for the ownership data `index`.
1263      */
1264     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1265         uint256 packed = _packedOwnerships[index];
1266         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1267         uint256 extraDataCasted;
1268         // Cast `extraData` with assembly to avoid redundant masking.
1269         assembly {
1270             extraDataCasted := extraData
1271         }
1272         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1273         _packedOwnerships[index] = packed;
1274     }
1275 
1276     /**
1277      * @dev Called during each token transfer to set the 24bit `extraData` field.
1278      * Intended to be overridden by the cosumer contract.
1279      *
1280      * `previousExtraData` - the value of `extraData` before transfer.
1281      *
1282      * Calling conditions:
1283      *
1284      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1285      * transferred to `to`.
1286      * - When `from` is zero, `tokenId` will be minted for `to`.
1287      * - When `to` is zero, `tokenId` will be burned by `from`.
1288      * - `from` and `to` are never both zero.
1289      */
1290     function _extraData(
1291         address from,
1292         address to,
1293         uint24 previousExtraData
1294     ) internal view virtual returns (uint24) {}
1295 
1296     /**
1297      * @dev Returns the next extra data for the packed ownership data.
1298      * The returned result is shifted into position.
1299      */
1300     function _nextExtraData(
1301         address from,
1302         address to,
1303         uint256 prevOwnershipPacked
1304     ) private view returns (uint256) {
1305         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1306         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1307     }
1308 
1309     // =============================================================
1310     //                       OTHER OPERATIONS
1311     // =============================================================
1312 
1313     /**
1314      * @dev Returns the message sender (defaults to `msg.sender`).
1315      *
1316      * If you are writing GSN compatible contracts, you need to override this function.
1317      */
1318     function _msgSenderERC721A() internal view virtual returns (address) {
1319         return msg.sender;
1320     }
1321 
1322     /**
1323      * @dev Converts a uint256 to its ASCII string decimal representation.
1324      */
1325     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1326         assembly {
1327             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1328             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1329             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1330             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1331             let m := add(mload(0x40), 0xa0)
1332             // Update the free memory pointer to allocate.
1333             mstore(0x40, m)
1334             // Assign the `str` to the end.
1335             str := sub(m, 0x20)
1336             // Zeroize the slot after the string.
1337             mstore(str, 0)
1338 
1339             // Cache the end of the memory to calculate the length later.
1340             let end := str
1341 
1342             // We write the string from rightmost digit to leftmost digit.
1343             // The following is essentially a do-while loop that also handles the zero case.
1344             // prettier-ignore
1345             for { let temp := value } 1 {} {
1346                 str := sub(str, 1)
1347                 // Write the character to the pointer.
1348                 // The ASCII index of the '0' character is 48.
1349                 mstore8(str, add(48, mod(temp, 10)))
1350                 // Keep dividing `temp` until zero.
1351                 temp := div(temp, 10)
1352                 // prettier-ignore
1353                 if iszero(temp) { break }
1354             }
1355 
1356             let length := sub(end, str)
1357             // Move the pointer 32 bytes leftwards to make room for the length.
1358             str := sub(str, 0x20)
1359             // Store the length.
1360             mstore(str, length)
1361         }
1362     }
1363 }
1364 
1365 /**
1366  * @dev Collection of functions related to the address type
1367  */
1368 library Address {
1369     /**
1370      * @dev Returns true if `account` is a contract.
1371      *
1372      * [IMPORTANT]
1373      * ====
1374      * It is unsafe to assume that an address for which this function returns
1375      * false is an externally-owned account (EOA) and not a contract.
1376      *
1377      * Among others, `isContract` will return false for the following
1378      * types of addresses:
1379      *
1380      *  - an externally-owned account
1381      *  - a contract in construction
1382      *  - an address where a contract will be created
1383      *  - an address where a contract lived, but was destroyed
1384      * ====
1385      *
1386      * [IMPORTANT]
1387      * ====
1388      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1389      *
1390      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1391      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1392      * constructor.
1393      * ====
1394      */
1395     function isContract(address account) internal view returns (bool) {
1396         // This method relies on extcodesize/address.code.length, which returns 0
1397         // for contracts in construction, since the code is only stored at the end
1398         // of the constructor execution.
1399 
1400         return account.code.length > 0;
1401     }
1402 
1403     /**
1404      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1405      * `recipient`, forwarding all available gas and reverting on errors.
1406      *
1407      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1408      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1409      * imposed by `transfer`, making them unable to receive funds via
1410      * `transfer`. {sendValue} removes this limitation.
1411      *
1412      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1413      *
1414      * IMPORTANT: because control is transferred to `recipient`, care must be
1415      * taken to not create reentrancy vulnerabilities. Consider using
1416      * {ReentrancyGuard} or the
1417      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1418      */
1419     function sendValue(address payable recipient, uint256 amount) internal {
1420         require(address(this).balance >= amount, "Address: insufficient balance");
1421 
1422         (bool success, ) = recipient.call{value: amount}("");
1423         require(success, "Address: unable to send value, recipient may have reverted");
1424     }
1425 
1426     /**
1427      * @dev Performs a Solidity function call using a low level `call`. A
1428      * plain `call` is an unsafe replacement for a function call: use this
1429      * function instead.
1430      *
1431      * If `target` reverts with a revert reason, it is bubbled up by this
1432      * function (like regular Solidity function calls).
1433      *
1434      * Returns the raw returned data. To convert to the expected return value,
1435      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1436      *
1437      * Requirements:
1438      *
1439      * - `target` must be a contract.
1440      * - calling `target` with `data` must not revert.
1441      *
1442      * _Available since v3.1._
1443      */
1444     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1445         return functionCall(target, data, "Address: low-level call failed");
1446     }
1447 
1448     /**
1449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1450      * `errorMessage` as a fallback revert reason when `target` reverts.
1451      *
1452      * _Available since v3.1._
1453      */
1454     function functionCall(
1455         address target,
1456         bytes memory data,
1457         string memory errorMessage
1458     ) internal returns (bytes memory) {
1459         return functionCallWithValue(target, data, 0, errorMessage);
1460     }
1461 
1462     /**
1463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1464      * but also transferring `value` wei to `target`.
1465      *
1466      * Requirements:
1467      *
1468      * - the calling contract must have an ETH balance of at least `value`.
1469      * - the called Solidity function must be `payable`.
1470      *
1471      * _Available since v3.1._
1472      */
1473     function functionCallWithValue(
1474         address target,
1475         bytes memory data,
1476         uint256 value
1477     ) internal returns (bytes memory) {
1478         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1479     }
1480 
1481     /**
1482      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1483      * with `errorMessage` as a fallback revert reason when `target` reverts.
1484      *
1485      * _Available since v3.1._
1486      */
1487     function functionCallWithValue(
1488         address target,
1489         bytes memory data,
1490         uint256 value,
1491         string memory errorMessage
1492     ) internal returns (bytes memory) {
1493         require(address(this).balance >= value, "Address: insufficient balance for call");
1494         require(isContract(target), "Address: call to non-contract");
1495 
1496         (bool success, bytes memory returndata) = target.call{value: value}(data);
1497         return verifyCallResult(success, returndata, errorMessage);
1498     }
1499 
1500     /**
1501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1502      * but performing a static call.
1503      *
1504      * _Available since v3.3._
1505      */
1506     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1507         return functionStaticCall(target, data, "Address: low-level static call failed");
1508     }
1509 
1510     /**
1511      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1512      * but performing a static call.
1513      *
1514      * _Available since v3.3._
1515      */
1516     function functionStaticCall(
1517         address target,
1518         bytes memory data,
1519         string memory errorMessage
1520     ) internal view returns (bytes memory) {
1521         require(isContract(target), "Address: static call to non-contract");
1522 
1523         (bool success, bytes memory returndata) = target.staticcall(data);
1524         return verifyCallResult(success, returndata, errorMessage);
1525     }
1526 
1527     /**
1528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1529      * but performing a delegate call.
1530      *
1531      * _Available since v3.4._
1532      */
1533     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1534         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1535     }
1536 
1537     /**
1538      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1539      * but performing a delegate call.
1540      *
1541      * _Available since v3.4._
1542      */
1543     function functionDelegateCall(
1544         address target,
1545         bytes memory data,
1546         string memory errorMessage
1547     ) internal returns (bytes memory) {
1548         require(isContract(target), "Address: delegate call to non-contract");
1549 
1550         (bool success, bytes memory returndata) = target.delegatecall(data);
1551         return verifyCallResult(success, returndata, errorMessage);
1552     }
1553 
1554     /**
1555      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1556      * revert reason using the provided one.
1557      *
1558      * _Available since v4.3._
1559      */
1560     function verifyCallResult(
1561         bool success,
1562         bytes memory returndata,
1563         string memory errorMessage
1564     ) internal pure returns (bytes memory) {
1565         if (success) {
1566             return returndata;
1567         } else {
1568             // Look for revert reason and bubble it up if present
1569             if (returndata.length > 0) {
1570                 // The easiest way to bubble the revert reason is using memory via assembly
1571                 /// @solidity memory-safe-assembly
1572                 assembly {
1573                     let returndata_size := mload(returndata)
1574                     revert(add(32, returndata), returndata_size)
1575                 }
1576             } else {
1577                 revert(errorMessage);
1578             }
1579         }
1580     }
1581 }
1582 
1583 /**
1584  * @dev Provides information about the current execution context, including the
1585  * sender of the transaction and its data. While these are generally available
1586  * via msg.sender and msg.data, they should not be accessed in such a direct
1587  * manner, since when dealing with meta-transactions the account sending and
1588  * paying for execution may not be the actual sender (as far as an application
1589  * is concerned).
1590  *
1591  * This contract is only required for intermediate, library-like contracts.
1592  */
1593 abstract contract Context {
1594     function _msgSender() internal view virtual returns (address) {
1595         return msg.sender;
1596     }
1597 
1598     function _msgData() internal view virtual returns (bytes calldata) {
1599         return msg.data;
1600     }
1601 }
1602 
1603 /**
1604  * @dev String operations.
1605  */
1606 library Strings {
1607     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1608     uint8 private constant _ADDRESS_LENGTH = 20;
1609 
1610     /**
1611      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1612      */
1613     function toString(uint256 value) internal pure returns (string memory) {
1614         // Inspired by OraclizeAPI's implementation - MIT licence
1615         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1616 
1617         if (value == 0) {
1618             return "0";
1619         }
1620         uint256 temp = value;
1621         uint256 digits;
1622         while (temp != 0) {
1623             digits++;
1624             temp /= 10;
1625         }
1626         bytes memory buffer = new bytes(digits);
1627         while (value != 0) {
1628             digits -= 1;
1629             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1630             value /= 10;
1631         }
1632         return string(buffer);
1633     }
1634 
1635     /**
1636      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1637      */
1638     function toHexString(uint256 value) internal pure returns (string memory) {
1639         if (value == 0) {
1640             return "0x00";
1641         }
1642         uint256 temp = value;
1643         uint256 length = 0;
1644         while (temp != 0) {
1645             length++;
1646             temp >>= 8;
1647         }
1648         return toHexString(value, length);
1649     }
1650 
1651     /**
1652      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1653      */
1654     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1655         bytes memory buffer = new bytes(2 * length + 2);
1656         buffer[0] = "0";
1657         buffer[1] = "x";
1658         for (uint256 i = 2 * length + 1; i > 1; --i) {
1659             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1660             value >>= 4;
1661         }
1662         require(value == 0, "Strings: hex length insufficient");
1663         return string(buffer);
1664     }
1665 
1666     /**
1667      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1668      */
1669     function toHexString(address addr) internal pure returns (string memory) {
1670         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1671     }
1672 }
1673 
1674 abstract contract Ownable is Context {
1675     address private _owner;
1676 
1677     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1678 
1679     /**
1680      * @dev Initializes the contract setting the deployer as the initial owner.
1681      */
1682     constructor() {
1683         _transferOwnership(_msgSender());
1684     }
1685 
1686     /**
1687      * @dev Throws if called by any account other than the owner.
1688      */
1689     modifier onlyOwner() {
1690         _checkOwner();
1691         _;
1692     }
1693 
1694     /**
1695      * @dev Returns the address of the current owner.
1696      */
1697     function owner() public view virtual returns (address) {
1698         return _owner;
1699     }
1700 
1701     /**
1702      * @dev Throws if the sender is not the owner.
1703      */
1704     function _checkOwner() internal view virtual {
1705         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1706     }
1707 
1708     /**
1709      * @dev Leaves the contract without owner. It will not be possible to call
1710      * `onlyOwner` functions anymore. Can only be called by the current owner.
1711      *
1712      * NOTE: Renouncing ownership will leave the contract without an owner,
1713      * thereby removing any functionality that is only available to the owner.
1714      */
1715     function renounceOwnership() public virtual onlyOwner {
1716         _transferOwnership(address(0));
1717     }
1718 
1719     /**
1720      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1721      * Can only be called by the current owner.
1722      */
1723     function transferOwnership(address newOwner) public virtual onlyOwner {
1724         require(newOwner != address(0), "Ownable: new owner is the zero address");
1725         _transferOwnership(newOwner);
1726     }
1727 
1728     /**
1729      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1730      * Internal function without access restriction.
1731      */
1732     function _transferOwnership(address newOwner) internal virtual {
1733         address oldOwner = _owner;
1734         _owner = newOwner;
1735         emit OwnershipTransferred(oldOwner, newOwner);
1736     }
1737 }
1738 
1739 // White list contract
1740 contract Whitelist is Ownable{
1741 
1742     constructor() {}
1743 
1744     // white list wallets
1745     mapping(address => uint256) public whitelistWallets;
1746 
1747 
1748     // add wallets to white list
1749     function addWhitelist(address[] calldata receivers) external onlyOwner {
1750         for (uint256 i = 0; i < receivers.length; i++) {
1751             whitelistWallets[receivers[i]] = 1;
1752         }
1753     }
1754 
1755     // is a wallet in whitelist
1756     function isInWhitelist(address wallet) public view returns(bool){
1757         return whitelistWallets[wallet] == 1;
1758     }
1759 }
1760 
1761 contract PowerMan is ERC721A, Whitelist {
1762 
1763     using Strings for uint256;
1764 
1765     uint256 public constant MAX_SUPPLY = 2000;
1766     //
1767     string private _tokenBaseURI;
1768 
1769     uint256 public price = 0.05 ether;
1770     uint256 public count;
1771     uint256 public startTime;
1772     uint256 public endTime;
1773     uint256 public saleTime = 24 hours;
1774     //
1775     uint256 public teamCount;
1776     uint256 public tokenId;
1777     mapping (address=>uint) public userInfo;
1778 
1779     constructor() ERC721A("Power Man", "Power Man")   {}
1780 
1781     function launch() public onlyOwner(){
1782         require(startTime == 0, "already started!");
1783         startTime = block.timestamp;
1784         endTime = startTime + saleTime;
1785     }
1786 
1787     // 
1788     function mint(uint256 _amount)
1789         public
1790         payable
1791         callerIsUser
1792     {
1793         require(block.timestamp>=startTime && block.timestamp<=endTime , "not sale time!");
1794         require(_amount > 0 && userInfo[msg.sender] + _amount  <= 15,"Exceed sales max limit!");
1795         require(_amount+count <= MAX_SUPPLY,"Maximum count exceeded!");
1796         require(isInWhitelist(msg.sender),"Not in whitelist yet!");
1797         uint256 cost = price * _amount;
1798         require(cost == msg.value,"invalid value!");
1799         safeTransfer(owner(),msg.value);
1800         count = count + _amount;
1801         userInfo[msg.sender] = userInfo[msg.sender] + _amount;
1802         // safe mint for every NFT
1803         _mint(msg.sender, _amount);
1804     }
1805 
1806     function burn(uint256 _tokenId) public {
1807         _burn(_tokenId);
1808     }
1809 
1810     function safeTransfer(address to, uint value) internal {
1811         (bool success,) = to.call{value:value}(new bytes(0));
1812         require(success, 'Transfer: ETH_TRANSFER_FAILED');
1813     }
1814 
1815     function setPrice(uint256 _price) public onlyOwner{
1816         require(price > 0,"Invalid price!");
1817         price = _price;
1818     }
1819 
1820     function setBaseURI(string calldata URI) external onlyOwner {
1821         _tokenBaseURI = URI;
1822     }
1823 
1824     function _baseURI()
1825         internal
1826         view
1827         override(ERC721A)
1828         returns (string memory)
1829     {
1830         return _tokenBaseURI;
1831     }
1832 
1833     function _startTokenId() internal view virtual override returns (uint256) {
1834         return 1;
1835     }
1836 
1837     // 
1838     modifier callerIsUser() {
1839         require(tx.origin == msg.sender, "not user!");
1840         _;
1841     }
1842 }