1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 
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
285  * @dev Interface of ERC721 token receiver.
286  */
287 interface ERC721A__IERC721Receiver {
288     function onERC721Received(
289         address operator,
290         address from,
291         uint256 tokenId,
292         bytes calldata data
293     ) external returns (bytes4);
294 }
295 
296 /**
297  * @title ERC721A
298  *
299  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
300  * Non-Fungible Token Standard, including the Metadata extension.
301  * Optimized for lower gas during batch mints.
302  *
303  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
304  * starting from `_startTokenId()`.
305  *
306  * Assumptions:
307  *
308  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
309  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
310  */
311 contract ERC721A is IERC721A {
312     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
313     struct TokenApprovalRef {
314         address value;
315     }
316 
317     // =============================================================
318     //                           CONSTANTS
319     // =============================================================
320 
321     // Mask of an entry in packed address data.
322     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
323 
324     // The bit position of `numberMinted` in packed address data.
325     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
326 
327     // The bit position of `numberBurned` in packed address data.
328     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
329 
330     // The bit position of `aux` in packed address data.
331     uint256 private constant _BITPOS_AUX = 192;
332 
333     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
334     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
335 
336     // The bit position of `startTimestamp` in packed ownership.
337     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
338 
339     // The bit mask of the `burned` bit in packed ownership.
340     uint256 private constant _BITMASK_BURNED = 1 << 224;
341 
342     // The bit position of the `nextInitialized` bit in packed ownership.
343     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
344 
345     // The bit mask of the `nextInitialized` bit in packed ownership.
346     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
347 
348     // The bit position of `extraData` in packed ownership.
349     uint256 private constant _BITPOS_EXTRA_DATA = 232;
350 
351     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
352     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
353 
354     // The mask of the lower 160 bits for addresses.
355     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
356 
357     // The maximum `quantity` that can be minted with {_mintERC2309}.
358     // This limit is to prevent overflows on the address data entries.
359     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
360     // is required to cause an overflow, which is unrealistic.
361     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
362 
363     // The `Transfer` event signature is given by:
364     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
365     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
366         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
367 
368     // =============================================================
369     //                            STORAGE
370     // =============================================================
371 
372     // The next token ID to be minted.
373     uint256 private _currentIndex;
374 
375     // The number of tokens burned.
376     uint256 private _burnCounter;
377 
378     // Token name
379     string private _name;
380 
381     // Token symbol
382     string private _symbol;
383 
384     // Mapping from token ID to ownership details
385     // An empty struct value does not necessarily mean the token is unowned.
386     // See {_packedOwnershipOf} implementation for details.
387     //
388     // Bits Layout:
389     // - [0..159]   `addr`
390     // - [160..223] `startTimestamp`
391     // - [224]      `burned`
392     // - [225]      `nextInitialized`
393     // - [232..255] `extraData`
394     mapping(uint256 => uint256) private _packedOwnerships;
395 
396     // Mapping owner address to address data.
397     //
398     // Bits Layout:
399     // - [0..63]    `balance`
400     // - [64..127]  `numberMinted`
401     // - [128..191] `numberBurned`
402     // - [192..255] `aux`
403     mapping(address => uint256) private _packedAddressData;
404 
405     // Mapping from token ID to approved address.
406     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
407 
408     // Mapping from owner to operator approvals
409     mapping(address => mapping(address => bool)) private _operatorApprovals;
410 
411     // =============================================================
412     //                          CONSTRUCTOR
413     // =============================================================
414 
415     constructor(string memory name_, string memory symbol_) {
416         _name = name_;
417         _symbol = symbol_;
418         _currentIndex = _startTokenId();
419     }
420 
421     // =============================================================
422     //                   TOKEN COUNTING OPERATIONS
423     // =============================================================
424 
425     /**
426      * @dev Returns the starting token ID.
427      * To change the starting token ID, please override this function.
428      */
429     function _startTokenId() internal view virtual returns (uint256) {
430         return 1;
431     }
432 
433     /**
434      * @dev Returns the next token ID to be minted.
435      */
436     function _nextTokenId() internal view virtual returns (uint256) {
437         return _currentIndex;
438     }
439 
440     /**
441      * @dev Returns the total number of tokens in existence.
442      * Burned tokens will reduce the count.
443      * To get the total number of tokens minted, please see {_totalMinted}.
444      */
445     function totalSupply() public view virtual override returns (uint256) {
446         // Counter underflow is impossible as _burnCounter cannot be incremented
447         // more than `_currentIndex - _startTokenId()` times.
448         unchecked {
449             return _currentIndex - _burnCounter - _startTokenId();
450         }
451     }
452 
453     /**
454      * @dev Returns the total amount of tokens minted in the contract.
455      */
456     function _totalMinted() internal view virtual returns (uint256) {
457         // Counter underflow is impossible as `_currentIndex` does not decrement,
458         // and it is initialized to `_startTokenId()`.
459         unchecked {
460             return _currentIndex - _startTokenId();
461         }
462     }
463 
464     /**
465      * @dev Returns the total number of tokens burned.
466      */
467     function _totalBurned() internal view virtual returns (uint256) {
468         return _burnCounter;
469     }
470 
471     // =============================================================
472     //                    ADDRESS DATA OPERATIONS
473     // =============================================================
474 
475     /**
476      * @dev Returns the number of tokens in `owner`'s account.
477      */
478     function balanceOf(address owner) public view virtual override returns (uint256) {
479         if (owner == address(0)) revert BalanceQueryForZeroAddress();
480         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
481     }
482 
483     /**
484      * Returns the number of tokens minted by `owner`.
485      */
486     function _numberMinted(address owner) internal view returns (uint256) {
487         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
488     }
489 
490     /**
491      * Returns the number of tokens burned by or on behalf of `owner`.
492      */
493     function _numberBurned(address owner) internal view returns (uint256) {
494         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
495     }
496 
497     /**
498      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
499      */
500     function _getAux(address owner) internal view returns (uint64) {
501         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
502     }
503 
504     /**
505      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
506      * If there are multiple variables, please pack them into a uint64.
507      */
508     function _setAux(address owner, uint64 aux) internal virtual {
509         uint256 packed = _packedAddressData[owner];
510         uint256 auxCasted;
511         // Cast `aux` with assembly to avoid redundant masking.
512         assembly {
513             auxCasted := aux
514         }
515         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
516         _packedAddressData[owner] = packed;
517     }
518 
519     // =============================================================
520     //                            IERC165
521     // =============================================================
522 
523     /**
524      * @dev Returns true if this contract implements the interface defined by
525      * `interfaceId`. See the corresponding
526      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
527      * to learn more about how these ids are created.
528      *
529      * This function call must use less than 30000 gas.
530      */
531     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
532         // The interface IDs are constants representing the first 4 bytes
533         // of the XOR of all function selectors in the interface.
534         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
535         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
536         return
537             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
538             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
539             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
540     }
541 
542     // =============================================================
543     //                        IERC721Metadata
544     // =============================================================
545 
546     /**
547      * @dev Returns the token collection name.
548      */
549     function name() public view virtual override returns (string memory) {
550         return _name;
551     }
552 
553     /**
554      * @dev Returns the token collection symbol.
555      */
556     function symbol() public view virtual override returns (string memory) {
557         return _symbol;
558     }
559 
560     /**
561      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
562      */
563     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
564         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
565 
566         string memory baseURI = _baseURI();
567         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
568     }
569 
570     /**
571      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
572      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
573      * by default, it can be overridden in child contracts.
574      */
575     function _baseURI() internal view virtual returns (string memory) {
576         return '';
577     }
578 
579     // =============================================================
580     //                     OWNERSHIPS OPERATIONS
581     // =============================================================
582 
583     /**
584      * @dev Returns the owner of the `tokenId` token.
585      *
586      * Requirements:
587      *
588      * - `tokenId` must exist.
589      */
590     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
591         return address(uint160(_packedOwnershipOf(tokenId)));
592     }
593 
594     /**
595      * @dev Gas spent here starts off proportional to the maximum mint batch size.
596      * It gradually moves to O(1) as tokens get transferred around over time.
597      */
598     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
599         return _unpackedOwnership(_packedOwnershipOf(tokenId));
600     }
601 
602     /**
603      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
604      */
605     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
606         return _unpackedOwnership(_packedOwnerships[index]);
607     }
608 
609     /**
610      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
611      */
612     function _initializeOwnershipAt(uint256 index) internal virtual {
613         if (_packedOwnerships[index] == 0) {
614             _packedOwnerships[index] = _packedOwnershipOf(index);
615         }
616     }
617 
618     /**
619      * Returns the packed ownership data of `tokenId`.
620      */
621     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
622         uint256 curr = tokenId;
623 
624         unchecked {
625             if (_startTokenId() <= curr)
626                 if (curr < _currentIndex) {
627                     uint256 packed = _packedOwnerships[curr];
628                     // If not burned.
629                     if (packed & _BITMASK_BURNED == 0) {
630                         // Invariant:
631                         // There will always be an initialized ownership slot
632                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
633                         // before an unintialized ownership slot
634                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
635                         // Hence, `curr` will not underflow.
636                         //
637                         // We can directly compare the packed value.
638                         // If the address is zero, packed will be zero.
639                         while (packed == 0) {
640                             packed = _packedOwnerships[--curr];
641                         }
642                         return packed;
643                     }
644                 }
645         }
646         revert OwnerQueryForNonexistentToken();
647     }
648 
649     /**
650      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
651      */
652     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
653         ownership.addr = address(uint160(packed));
654         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
655         ownership.burned = packed & _BITMASK_BURNED != 0;
656         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
657     }
658 
659     /**
660      * @dev Packs ownership data into a single uint256.
661      */
662     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
663         assembly {
664             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
665             owner := and(owner, _BITMASK_ADDRESS)
666             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
667             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
668         }
669     }
670 
671     /**
672      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
673      */
674     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
675         // For branchless setting of the `nextInitialized` flag.
676         assembly {
677             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
678             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
679         }
680     }
681 
682     // =============================================================
683     //                      APPROVAL OPERATIONS
684     // =============================================================
685 
686     /**
687      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
688      * The approval is cleared when the token is transferred.
689      *
690      * Only a single account can be approved at a time, so approving the
691      * zero address clears previous approvals.
692      *
693      * Requirements:
694      *
695      * - The caller must own the token or be an approved operator.
696      * - `tokenId` must exist.
697      *
698      * Emits an {Approval} event.
699      */
700     function approve(address to, uint256 tokenId) public payable virtual override {
701         address owner = ownerOf(tokenId);
702 
703         if (_msgSenderERC721A() != owner)
704             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
705                 revert ApprovalCallerNotOwnerNorApproved();
706             }
707 
708         _tokenApprovals[tokenId].value = to;
709         emit Approval(owner, to, tokenId);
710     }
711 
712     /**
713      * @dev Returns the account approved for `tokenId` token.
714      *
715      * Requirements:
716      *
717      * - `tokenId` must exist.
718      */
719     function getApproved(uint256 tokenId) public view virtual override returns (address) {
720         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
721 
722         return _tokenApprovals[tokenId].value;
723     }
724 
725     /**
726      * @dev Approve or remove `operator` as an operator for the caller.
727      * Operators can call {transferFrom} or {safeTransferFrom}
728      * for any token owned by the caller.
729      *
730      * Requirements:
731      *
732      * - The `operator` cannot be the caller.
733      *
734      * Emits an {ApprovalForAll} event.
735      */
736     function setApprovalForAll(address operator, bool approved) public virtual override {
737         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
738         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
739     }
740 
741     /**
742      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
743      *
744      * See {setApprovalForAll}.
745      */
746     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
747         return _operatorApprovals[owner][operator];
748     }
749 
750     /**
751      * @dev Returns whether `tokenId` exists.
752      *
753      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
754      *
755      * Tokens start existing when they are minted. See {_mint}.
756      */
757     function _exists(uint256 tokenId) internal view virtual returns (bool) {
758         return
759             _startTokenId() <= tokenId &&
760             tokenId < _currentIndex && // If within bounds,
761             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
762     }
763 
764     /**
765      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
766      */
767     function _isSenderApprovedOrOwner(
768         address approvedAddress,
769         address owner,
770         address msgSender
771     ) private pure returns (bool result) {
772         assembly {
773             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
774             owner := and(owner, _BITMASK_ADDRESS)
775             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
776             msgSender := and(msgSender, _BITMASK_ADDRESS)
777             // `msgSender == owner || msgSender == approvedAddress`.
778             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
779         }
780     }
781 
782     /**
783      * @dev Returns the storage slot and value for the approved address of `tokenId`.
784      */
785     function _getApprovedSlotAndAddress(uint256 tokenId)
786         private
787         view
788         returns (uint256 approvedAddressSlot, address approvedAddress)
789     {
790         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
791         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
792         assembly {
793             approvedAddressSlot := tokenApproval.slot
794             approvedAddress := sload(approvedAddressSlot)
795         }
796     }
797 
798     // =============================================================
799     //                      TRANSFER OPERATIONS
800     // =============================================================
801 
802     /**
803      * @dev Transfers `tokenId` from `from` to `to`.
804      *
805      * Requirements:
806      *
807      * - `from` cannot be the zero address.
808      * - `to` cannot be the zero address.
809      * - `tokenId` token must be owned by `from`.
810      * - If the caller is not `from`, it must be approved to move this token
811      * by either {approve} or {setApprovalForAll}.
812      *
813      * Emits a {Transfer} event.
814      */
815     function transferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) public payable virtual override {
820         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
821 
822         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
823 
824         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
825 
826         // The nested ifs save around 20+ gas over a compound boolean condition.
827         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
828             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
829 
830         if (to == address(0)) revert TransferToZeroAddress();
831 
832         _beforeTokenTransfers(from, to, tokenId, 1);
833 
834         // Clear approvals from the previous owner.
835         assembly {
836             if approvedAddress {
837                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
838                 sstore(approvedAddressSlot, 0)
839             }
840         }
841 
842         // Underflow of the sender's balance is impossible because we check for
843         // ownership above and the recipient's balance can't realistically overflow.
844         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
845         unchecked {
846             // We can directly increment and decrement the balances.
847             --_packedAddressData[from]; // Updates: `balance -= 1`.
848             ++_packedAddressData[to]; // Updates: `balance += 1`.
849 
850             // Updates:
851             // - `address` to the next owner.
852             // - `startTimestamp` to the timestamp of transfering.
853             // - `burned` to `false`.
854             // - `nextInitialized` to `true`.
855             _packedOwnerships[tokenId] = _packOwnershipData(
856                 to,
857                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
858             );
859 
860             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
861             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
862                 uint256 nextTokenId = tokenId + 1;
863                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
864                 if (_packedOwnerships[nextTokenId] == 0) {
865                     // If the next slot is within bounds.
866                     if (nextTokenId != _currentIndex) {
867                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
868                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
869                     }
870                 }
871             }
872         }
873 
874         emit Transfer(from, to, tokenId);
875         _afterTokenTransfers(from, to, tokenId, 1);
876     }
877 
878     /**
879      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) public payable virtual override {
886         safeTransferFrom(from, to, tokenId, '');
887     }
888 
889     /**
890      * @dev Safely transfers `tokenId` token from `from` to `to`.
891      *
892      * Requirements:
893      *
894      * - `from` cannot be the zero address.
895      * - `to` cannot be the zero address.
896      * - `tokenId` token must exist and be owned by `from`.
897      * - If the caller is not `from`, it must be approved to move this token
898      * by either {approve} or {setApprovalForAll}.
899      * - If `to` refers to a smart contract, it must implement
900      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) public payable virtual override {
910         transferFrom(from, to, tokenId);
911         if (to.code.length != 0)
912             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
913                 revert TransferToNonERC721ReceiverImplementer();
914             }
915     }
916 
917     /**
918      * @dev Hook that is called before a set of serially-ordered token IDs
919      * are about to be transferred. This includes minting.
920      * And also called before burning one token.
921      *
922      * `startTokenId` - the first token ID to be transferred.
923      * `quantity` - the amount to be transferred.
924      *
925      * Calling conditions:
926      *
927      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
928      * transferred to `to`.
929      * - When `from` is zero, `tokenId` will be minted for `to`.
930      * - When `to` is zero, `tokenId` will be burned by `from`.
931      * - `from` and `to` are never both zero.
932      */
933     function _beforeTokenTransfers(
934         address from,
935         address to,
936         uint256 startTokenId,
937         uint256 quantity
938     ) internal virtual {}
939 
940     /**
941      * @dev Hook that is called after a set of serially-ordered token IDs
942      * have been transferred. This includes minting.
943      * And also called after one token has been burned.
944      *
945      * `startTokenId` - the first token ID to be transferred.
946      * `quantity` - the amount to be transferred.
947      *
948      * Calling conditions:
949      *
950      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
951      * transferred to `to`.
952      * - When `from` is zero, `tokenId` has been minted for `to`.
953      * - When `to` is zero, `tokenId` has been burned by `from`.
954      * - `from` and `to` are never both zero.
955      */
956     function _afterTokenTransfers(
957         address from,
958         address to,
959         uint256 startTokenId,
960         uint256 quantity
961     ) internal virtual {}
962 
963     /**
964      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
965      *
966      * `from` - Previous owner of the given token ID.
967      * `to` - Target address that will receive the token.
968      * `tokenId` - Token ID to be transferred.
969      * `_data` - Optional data to send along with the call.
970      *
971      * Returns whether the call correctly returned the expected magic value.
972      */
973     function _checkContractOnERC721Received(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) private returns (bool) {
979         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
980             bytes4 retval
981         ) {
982             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
983         } catch (bytes memory reason) {
984             if (reason.length == 0) {
985                 revert TransferToNonERC721ReceiverImplementer();
986             } else {
987                 assembly {
988                     revert(add(32, reason), mload(reason))
989                 }
990             }
991         }
992     }
993 
994     // =============================================================
995     //                        MINT OPERATIONS
996     // =============================================================
997 
998     /**
999      * @dev Mints `quantity` tokens and transfers them to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `to` cannot be the zero address.
1004      * - `quantity` must be greater than 0.
1005      *
1006      * Emits a {Transfer} event for each mint.
1007      */
1008     function _mint(address to, uint256 quantity) internal virtual {
1009         uint256 startTokenId = _currentIndex;
1010         if (quantity == 0) revert MintZeroQuantity();
1011 
1012         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1013 
1014         // Overflows are incredibly unrealistic.
1015         // `balance` and `numberMinted` have a maximum limit of 2**64.
1016         // `tokenId` has a maximum limit of 2**256.
1017         unchecked {
1018             // Updates:
1019             // - `balance += quantity`.
1020             // - `numberMinted += quantity`.
1021             //
1022             // We can directly add to the `balance` and `numberMinted`.
1023             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1024 
1025             // Updates:
1026             // - `address` to the owner.
1027             // - `startTimestamp` to the timestamp of minting.
1028             // - `burned` to `false`.
1029             // - `nextInitialized` to `quantity == 1`.
1030             _packedOwnerships[startTokenId] = _packOwnershipData(
1031                 to,
1032                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1033             );
1034 
1035             uint256 toMasked;
1036             uint256 end = startTokenId + quantity;
1037 
1038             // Use assembly to loop and emit the `Transfer` event for gas savings.
1039             // The duplicated `log4` removes an extra check and reduces stack juggling.
1040             // The assembly, together with the surrounding Solidity code, have been
1041             // delicately arranged to nudge the compiler into producing optimized opcodes.
1042             assembly {
1043                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1044                 toMasked := and(to, _BITMASK_ADDRESS)
1045                 // Emit the `Transfer` event.
1046                 log4(
1047                     0, // Start of data (0, since no data).
1048                     0, // End of data (0, since no data).
1049                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1050                     0, // `address(0)`.
1051                     toMasked, // `to`.
1052                     startTokenId // `tokenId`.
1053                 )
1054 
1055                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1056                 // that overflows uint256 will make the loop run out of gas.
1057                 // The compiler will optimize the `iszero` away for performance.
1058                 for {
1059                     let tokenId := add(startTokenId, 1)
1060                 } iszero(eq(tokenId, end)) {
1061                     tokenId := add(tokenId, 1)
1062                 } {
1063                     // Emit the `Transfer` event. Similar to above.
1064                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1065                 }
1066             }
1067             if (toMasked == 0) revert MintToZeroAddress();
1068 
1069             _currentIndex = end;
1070         }
1071         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1072     }
1073 
1074     /**
1075      * @dev Mints `quantity` tokens and transfers them to `to`.
1076      *
1077      * This function is intended for efficient minting only during contract creation.
1078      *
1079      * It emits only one {ConsecutiveTransfer} as defined in
1080      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1081      * instead of a sequence of {Transfer} event(s).
1082      *
1083      * Calling this function outside of contract creation WILL make your contract
1084      * non-compliant with the ERC721 standard.
1085      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1086      * {ConsecutiveTransfer} event is only permissible during contract creation.
1087      *
1088      * Requirements:
1089      *
1090      * - `to` cannot be the zero address.
1091      * - `quantity` must be greater than 0.
1092      *
1093      * Emits a {ConsecutiveTransfer} event.
1094      */
1095     function _mintERC2309(address to, uint256 quantity) internal virtual {
1096         uint256 startTokenId = _currentIndex;
1097         if (to == address(0)) revert MintToZeroAddress();
1098         if (quantity == 0) revert MintZeroQuantity();
1099         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1100 
1101         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1102 
1103         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1104         unchecked {
1105             // Updates:
1106             // - `balance += quantity`.
1107             // - `numberMinted += quantity`.
1108             //
1109             // We can directly add to the `balance` and `numberMinted`.
1110             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1111 
1112             // Updates:
1113             // - `address` to the owner.
1114             // - `startTimestamp` to the timestamp of minting.
1115             // - `burned` to `false`.
1116             // - `nextInitialized` to `quantity == 1`.
1117             _packedOwnerships[startTokenId] = _packOwnershipData(
1118                 to,
1119                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1120             );
1121 
1122             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1123 
1124             _currentIndex = startTokenId + quantity;
1125         }
1126         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1127     }
1128 
1129     /**
1130      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - If `to` refers to a smart contract, it must implement
1135      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1136      * - `quantity` must be greater than 0.
1137      *
1138      * See {_mint}.
1139      *
1140      * Emits a {Transfer} event for each mint.
1141      */
1142     function _safeMint(
1143         address to,
1144         uint256 quantity,
1145         bytes memory _data
1146     ) internal virtual {
1147         _mint(to, quantity);
1148 
1149         unchecked {
1150             if (to.code.length != 0) {
1151                 uint256 end = _currentIndex;
1152                 uint256 index = end - quantity;
1153                 do {
1154                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1155                         revert TransferToNonERC721ReceiverImplementer();
1156                     }
1157                 } while (index < end);
1158                 // Reentrancy protection.
1159                 if (_currentIndex != end) revert();
1160             }
1161         }
1162     }
1163 
1164     /**
1165      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1166      */
1167     function _safeMint(address to, uint256 quantity) internal virtual {
1168         _safeMint(to, quantity, '');
1169     }
1170 
1171     // =============================================================
1172     //                        BURN OPERATIONS
1173     // =============================================================
1174 
1175     /**
1176      * @dev Equivalent to `_burn(tokenId, false)`.
1177      */
1178     function _burn(uint256 tokenId) internal virtual {
1179         _burn(tokenId, false);
1180     }
1181 
1182     /**
1183      * @dev Destroys `tokenId`.
1184      * The approval is cleared when the token is burned.
1185      *
1186      * Requirements:
1187      *
1188      * - `tokenId` must exist.
1189      *
1190      * Emits a {Transfer} event.
1191      */
1192     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1193         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1194 
1195         address from = address(uint160(prevOwnershipPacked));
1196 
1197         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1198 
1199         if (approvalCheck) {
1200             // The nested ifs save around 20+ gas over a compound boolean condition.
1201             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1202                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1203         }
1204 
1205         _beforeTokenTransfers(from, address(0), tokenId, 1);
1206 
1207         // Clear approvals from the previous owner.
1208         assembly {
1209             if approvedAddress {
1210                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1211                 sstore(approvedAddressSlot, 0)
1212             }
1213         }
1214 
1215         // Underflow of the sender's balance is impossible because we check for
1216         // ownership above and the recipient's balance can't realistically overflow.
1217         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1218         unchecked {
1219             // Updates:
1220             // - `balance -= 1`.
1221             // - `numberBurned += 1`.
1222             //
1223             // We can directly decrement the balance, and increment the number burned.
1224             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1225             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1226 
1227             // Updates:
1228             // - `address` to the last owner.
1229             // - `startTimestamp` to the timestamp of burning.
1230             // - `burned` to `true`.
1231             // - `nextInitialized` to `true`.
1232             _packedOwnerships[tokenId] = _packOwnershipData(
1233                 from,
1234                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1235             );
1236 
1237             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1238             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1239                 uint256 nextTokenId = tokenId + 1;
1240                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1241                 if (_packedOwnerships[nextTokenId] == 0) {
1242                     // If the next slot is within bounds.
1243                     if (nextTokenId != _currentIndex) {
1244                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1245                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1246                     }
1247                 }
1248             }
1249         }
1250 
1251         emit Transfer(from, address(0), tokenId);
1252         _afterTokenTransfers(from, address(0), tokenId, 1);
1253 
1254         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1255         unchecked {
1256             _burnCounter++;
1257         }
1258     }
1259 
1260     // =============================================================
1261     //                     EXTRA DATA OPERATIONS
1262     // =============================================================
1263 
1264     /**
1265      * @dev Directly sets the extra data for the ownership data `index`.
1266      */
1267     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1268         uint256 packed = _packedOwnerships[index];
1269         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1270         uint256 extraDataCasted;
1271         // Cast `extraData` with assembly to avoid redundant masking.
1272         assembly {
1273             extraDataCasted := extraData
1274         }
1275         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1276         _packedOwnerships[index] = packed;
1277     }
1278 
1279     /**
1280      * @dev Called during each token transfer to set the 24bit `extraData` field.
1281      * Intended to be overridden by the cosumer contract.
1282      *
1283      * `previousExtraData` - the value of `extraData` before transfer.
1284      *
1285      * Calling conditions:
1286      *
1287      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1288      * transferred to `to`.
1289      * - When `from` is zero, `tokenId` will be minted for `to`.
1290      * - When `to` is zero, `tokenId` will be burned by `from`.
1291      * - `from` and `to` are never both zero.
1292      */
1293     function _extraData(
1294         address from,
1295         address to,
1296         uint24 previousExtraData
1297     ) internal view virtual returns (uint24) {}
1298 
1299     /**
1300      * @dev Returns the next extra data for the packed ownership data.
1301      * The returned result is shifted into position.
1302      */
1303     function _nextExtraData(
1304         address from,
1305         address to,
1306         uint256 prevOwnershipPacked
1307     ) private view returns (uint256) {
1308         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1309         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1310     }
1311 
1312     // =============================================================
1313     //                       OTHER OPERATIONS
1314     // =============================================================
1315 
1316     /**
1317      * @dev Returns the message sender (defaults to `msg.sender`).
1318      *
1319      * If you are writing GSN compatible contracts, you need to override this function.
1320      */
1321     function _msgSenderERC721A() internal view virtual returns (address) {
1322         return msg.sender;
1323     }
1324 
1325     /**
1326      * @dev Converts a uint256 to its ASCII string decimal representation.
1327      */
1328     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1329         assembly {
1330             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1331             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1332             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1333             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1334             let m := add(mload(0x40), 0xa0)
1335             // Update the free memory pointer to allocate.
1336             mstore(0x40, m)
1337             // Assign the `str` to the end.
1338             str := sub(m, 0x20)
1339             // Zeroize the slot after the string.
1340             mstore(str, 0)
1341 
1342             // Cache the end of the memory to calculate the length later.
1343             let end := str
1344 
1345             // We write the string from rightmost digit to leftmost digit.
1346             // The following is essentially a do-while loop that also handles the zero case.
1347             // prettier-ignore
1348             for { let temp := value } 1 {} {
1349                 str := sub(str, 1)
1350                 // Write the character to the pointer.
1351                 // The ASCII index of the '0' character is 48.
1352                 mstore8(str, add(48, mod(temp, 10)))
1353                 // Keep dividing `temp` until zero.
1354                 temp := div(temp, 10)
1355                 // prettier-ignore
1356                 if iszero(temp) { break }
1357             }
1358 
1359             let length := sub(end, str)
1360             // Move the pointer 32 bytes leftwards to make room for the length.
1361             str := sub(str, 0x20)
1362             // Store the length.
1363             mstore(str, length)
1364         }
1365     }
1366 }
1367 library MerkleProof {
1368     /**
1369      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1370      * defined by `root`. For this, a `proof` must be provided, containing
1371      * sibling hashes on the branch from the leaf to the root of the tree. Each
1372      * pair of leaves and each pair of pre-images are assumed to be sorted.
1373      */
1374     function verify(
1375         bytes32[] memory proof,
1376         bytes32 root,
1377         bytes32 leaf
1378     ) internal pure returns (bool) {
1379         return processProof(proof, leaf) == root;
1380     }
1381 
1382     /**
1383      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1384      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1385      * hash matches the root of the tree. When processing the proof, the pairs
1386      * of leafs & pre-images are assumed to be sorted.
1387      *
1388      * _Available since v4.4._
1389      */
1390     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1391         bytes32 computedHash = leaf;
1392         for (uint256 i = 0; i < proof.length; i++) {
1393             bytes32 proofElement = proof[i];
1394             if (computedHash <= proofElement) {
1395                 // Hash(current computed hash + current element of the proof)
1396                 computedHash = _efficientHash(computedHash, proofElement);
1397             } else {
1398                 // Hash(current element of the proof + current computed hash)
1399                 computedHash = _efficientHash(proofElement, computedHash);
1400             }
1401         }
1402         return computedHash;
1403     }
1404 
1405     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1406         assembly {
1407             mstore(0x00, a)
1408             mstore(0x20, b)
1409             value := keccak256(0x00, 0x40)
1410         }
1411     }
1412 }
1413 library SafeMath {
1414     /**
1415      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1416      *
1417      * _Available since v3.4._
1418      */
1419     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1420         unchecked {
1421             uint256 c = a + b;
1422             if (c < a) return (false, 0);
1423             return (true, c);
1424         }
1425     }
1426 
1427     /**
1428      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1429      *
1430      * _Available since v3.4._
1431      */
1432     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1433         unchecked {
1434             if (b > a) return (false, 0);
1435             return (true, a - b);
1436         }
1437     }
1438 
1439     /**
1440      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1441      *
1442      * _Available since v3.4._
1443      */
1444     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1445         unchecked {
1446             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1447             // benefit is lost if 'b' is also tested.
1448             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1449             if (a == 0) return (true, 0);
1450             uint256 c = a * b;
1451             if (c / a != b) return (false, 0);
1452             return (true, c);
1453         }
1454     }
1455 
1456     /**
1457      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1458      *
1459      * _Available since v3.4._
1460      */
1461     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1462         unchecked {
1463             if (b == 0) return (false, 0);
1464             return (true, a / b);
1465         }
1466     }
1467 
1468     /**
1469      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1470      *
1471      * _Available since v3.4._
1472      */
1473     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1474         unchecked {
1475             if (b == 0) return (false, 0);
1476             return (true, a % b);
1477         }
1478     }
1479 
1480     /**
1481      * @dev Returns the addition of two unsigned integers, reverting on
1482      * overflow.
1483      *
1484      * Counterpart to Solidity's `+` operator.
1485      *
1486      * Requirements:
1487      *
1488      * - Addition cannot overflow.
1489      */
1490     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1491         return a + b;
1492     }
1493 
1494     /**
1495      * @dev Returns the subtraction of two unsigned integers, reverting on
1496      * overflow (when the result is negative).
1497      *
1498      * Counterpart to Solidity's `-` operator.
1499      *
1500      * Requirements:
1501      *
1502      * - Subtraction cannot overflow.
1503      */
1504     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1505         return a - b;
1506     }
1507 
1508     /**
1509      * @dev Returns the multiplication of two unsigned integers, reverting on
1510      * overflow.
1511      *
1512      * Counterpart to Solidity's `*` operator.
1513      *
1514      * Requirements:
1515      *
1516      * - Multiplication cannot overflow.
1517      */
1518     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1519         return a * b;
1520     }
1521 
1522     /**
1523      * @dev Returns the integer division of two unsigned integers, reverting on
1524      * division by zero. The result is rounded towards zero.
1525      *
1526      * Counterpart to Solidity's `/` operator.
1527      *
1528      * Requirements:
1529      *
1530      * - The divisor cannot be zero.
1531      */
1532     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1533         return a / b;
1534     }
1535 
1536     /**
1537      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1538      * reverting when dividing by zero.
1539      *
1540      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1541      * opcode (which leaves remaining gas untouched) while Solidity uses an
1542      * invalid opcode to revert (consuming all remaining gas).
1543      *
1544      * Requirements:
1545      *
1546      * - The divisor cannot be zero.
1547      */
1548     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1549         return a % b;
1550     }
1551 
1552     /**
1553      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1554      * overflow (when the result is negative).
1555      *
1556      * CAUTION: This function is deprecated because it requires allocating memory for the error
1557      * message unnecessarily. For custom revert reasons use {trySub}.
1558      *
1559      * Counterpart to Solidity's `-` operator.
1560      *
1561      * Requirements:
1562      *
1563      * - Subtraction cannot overflow.
1564      */
1565     function sub(
1566         uint256 a,
1567         uint256 b,
1568         string memory errorMessage
1569     ) internal pure returns (uint256) {
1570         unchecked {
1571             require(b <= a, errorMessage);
1572             return a - b;
1573         }
1574     }
1575 
1576     /**
1577      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1578      * division by zero. The result is rounded towards zero.
1579      *
1580      * Counterpart to Solidity's `/` operator. Note: this function uses a
1581      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1582      * uses an invalid opcode to revert (consuming all remaining gas).
1583      *
1584      * Requirements:
1585      *
1586      * - The divisor cannot be zero.
1587      */
1588     function div(
1589         uint256 a,
1590         uint256 b,
1591         string memory errorMessage
1592     ) internal pure returns (uint256) {
1593         unchecked {
1594             require(b > 0, errorMessage);
1595             return a / b;
1596         }
1597     }
1598 
1599     /**
1600      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1601      * reverting with custom message when dividing by zero.
1602      *
1603      * CAUTION: This function is deprecated because it requires allocating memory for the error
1604      * message unnecessarily. For custom revert reasons use {tryMod}.
1605      *
1606      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1607      * opcode (which leaves remaining gas untouched) while Solidity uses an
1608      * invalid opcode to revert (consuming all remaining gas).
1609      *
1610      * Requirements:
1611      *
1612      * - The divisor cannot be zero.
1613      */
1614     function mod(
1615         uint256 a,
1616         uint256 b,
1617         string memory errorMessage
1618     ) internal pure returns (uint256) {
1619         unchecked {
1620             require(b > 0, errorMessage);
1621             return a % b;
1622         }
1623     }
1624 }
1625 library Counters {
1626     struct Counter {
1627         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1628         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1629         // this feature: see https://github.com/ethereum/solidity/issues/4637
1630         uint256 _value; // default: 0
1631     }
1632 
1633     function current(Counter storage counter) internal view returns (uint256) {
1634         return counter._value;
1635     }
1636 
1637     function increment(Counter storage counter) internal {
1638         unchecked {
1639             counter._value += 1;
1640         }
1641     }
1642 
1643     function decrement(Counter storage counter) internal {
1644         uint256 value = counter._value;
1645         require(value > 0, "Counter: decrement overflow");
1646         unchecked {
1647             counter._value = value - 1;
1648         }
1649     }
1650 
1651     function reset(Counter storage counter) internal {
1652         counter._value = 0;
1653     }
1654 }
1655 library Strings {
1656     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1657     uint8 private constant _ADDRESS_LENGTH = 20;
1658 
1659     /**
1660      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1661      */
1662     function toString(uint256 value) internal pure returns (string memory) {
1663         // Inspired by OraclizeAPI's implementation - MIT licence
1664         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1665 
1666         if (value == 0) {
1667             return "0";
1668         }
1669         uint256 temp = value;
1670         uint256 digits;
1671         while (temp != 0) {
1672             digits++;
1673             temp /= 10;
1674         }
1675         bytes memory buffer = new bytes(digits);
1676         while (value != 0) {
1677             digits -= 1;
1678             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1679             value /= 10;
1680         }
1681         return string(buffer);
1682     }
1683 
1684     /**
1685      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1686      */
1687     function toHexString(uint256 value) internal pure returns (string memory) {
1688         if (value == 0) {
1689             return "0x00";
1690         }
1691         uint256 temp = value;
1692         uint256 length = 0;
1693         while (temp != 0) {
1694             length++;
1695             temp >>= 8;
1696         }
1697         return toHexString(value, length);
1698     }
1699 
1700     /**
1701      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1702      */
1703     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1704         bytes memory buffer = new bytes(2 * length + 2);
1705         buffer[0] = "0";
1706         buffer[1] = "x";
1707         for (uint256 i = 2 * length + 1; i > 1; --i) {
1708             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1709             value >>= 4;
1710         }
1711         require(value == 0, "Strings: hex length insufficient");
1712         return string(buffer);
1713     }
1714 
1715     /**
1716      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1717      */
1718     function toHexString(address addr) internal pure returns (string memory) {
1719         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1720     }
1721 }
1722 library ECDSA {
1723     enum RecoverError {
1724         NoError,
1725         InvalidSignature,
1726         InvalidSignatureLength,
1727         InvalidSignatureS,
1728         InvalidSignatureV
1729     }
1730 
1731     function _throwError(RecoverError error) private pure {
1732         if (error == RecoverError.NoError) {
1733             return; // no error: do nothing
1734         } else if (error == RecoverError.InvalidSignature) {
1735             revert("ECDSA: invalid signature");
1736         } else if (error == RecoverError.InvalidSignatureLength) {
1737             revert("ECDSA: invalid signature length");
1738         } else if (error == RecoverError.InvalidSignatureS) {
1739             revert("ECDSA: invalid signature 's' value");
1740         } else if (error == RecoverError.InvalidSignatureV) {
1741             revert("ECDSA: invalid signature 'v' value");
1742         }
1743     }
1744 
1745     /**
1746      * @dev Returns the address that signed a hashed message (`hash`) with
1747      * `signature` or error string. This address can then be used for verification purposes.
1748      *
1749      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1750      * this function rejects them by requiring the `s` value to be in the lower
1751      * half order, and the `v` value to be either 27 or 28.
1752      *
1753      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1754      * verification to be secure: it is possible to craft signatures that
1755      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1756      * this is by receiving a hash of the original message (which may otherwise
1757      * be too long), and then calling {toEthSignedMessageHash} on it.
1758      *
1759      * Documentation for signature generation:
1760      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1761      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1762      *
1763      * _Available since v4.3._
1764      */
1765     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1766         if (signature.length == 65) {
1767             bytes32 r;
1768             bytes32 s;
1769             uint8 v;
1770             // ecrecover takes the signature parameters, and the only way to get them
1771             // currently is to use assembly.
1772             /// @solidity memory-safe-assembly
1773             assembly {
1774                 r := mload(add(signature, 0x20))
1775                 s := mload(add(signature, 0x40))
1776                 v := byte(0, mload(add(signature, 0x60)))
1777             }
1778             return tryRecover(hash, v, r, s);
1779         } else {
1780             return (address(0), RecoverError.InvalidSignatureLength);
1781         }
1782     }
1783 
1784     /**
1785      * @dev Returns the address that signed a hashed message (`hash`) with
1786      * `signature`. This address can then be used for verification purposes.
1787      *
1788      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1789      * this function rejects them by requiring the `s` value to be in the lower
1790      * half order, and the `v` value to be either 27 or 28.
1791      *
1792      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1793      * verification to be secure: it is possible to craft signatures that
1794      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1795      * this is by receiving a hash of the original message (which may otherwise
1796      * be too long), and then calling {toEthSignedMessageHash} on it.
1797      */
1798     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1799         (address recovered, RecoverError error) = tryRecover(hash, signature);
1800         _throwError(error);
1801         return recovered;
1802     }
1803 
1804     /**
1805      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1806      *
1807      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1808      *
1809      * _Available since v4.3._
1810      */
1811     function tryRecover(
1812         bytes32 hash,
1813         bytes32 r,
1814         bytes32 vs
1815     ) internal pure returns (address, RecoverError) {
1816         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1817         uint8 v = uint8((uint256(vs) >> 255) + 27);
1818         return tryRecover(hash, v, r, s);
1819     }
1820 
1821     /**
1822      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1823      *
1824      * _Available since v4.2._
1825      */
1826     function recover(
1827         bytes32 hash,
1828         bytes32 r,
1829         bytes32 vs
1830     ) internal pure returns (address) {
1831         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1832         _throwError(error);
1833         return recovered;
1834     }
1835 
1836     /**
1837      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1838      * `r` and `s` signature fields separately.
1839      *
1840      * _Available since v4.3._
1841      */
1842     function tryRecover(
1843         bytes32 hash,
1844         uint8 v,
1845         bytes32 r,
1846         bytes32 s
1847     ) internal pure returns (address, RecoverError) {
1848         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1849         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1850         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1851         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1852         //
1853         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1854         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1855         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1856         // these malleable signatures as well.
1857         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1858             return (address(0), RecoverError.InvalidSignatureS);
1859         }
1860         if (v != 27 && v != 28) {
1861             return (address(0), RecoverError.InvalidSignatureV);
1862         }
1863 
1864         // If the signature is valid (and not malleable), return the signer address
1865         address signer = ecrecover(hash, v, r, s);
1866         if (signer == address(0)) {
1867             return (address(0), RecoverError.InvalidSignature);
1868         }
1869 
1870         return (signer, RecoverError.NoError);
1871     }
1872 
1873     /**
1874      * @dev Overload of {ECDSA-recover} that receives the `v`,
1875      * `r` and `s` signature fields separately.
1876      */
1877     function recover(
1878         bytes32 hash,
1879         uint8 v,
1880         bytes32 r,
1881         bytes32 s
1882     ) internal pure returns (address) {
1883         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1884         _throwError(error);
1885         return recovered;
1886     }
1887 
1888     /**
1889      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1890      * produces hash corresponding to the one signed with the
1891      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1892      * JSON-RPC method as part of EIP-191.
1893      *
1894      * See {recover}.
1895      */
1896     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1897         // 32 is the length in bytes of hash,
1898         // enforced by the type signature above
1899         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1900     }
1901 
1902     /**
1903      * @dev Returns an Ethereum Signed Message, created from `s`. This
1904      * produces hash corresponding to the one signed with the
1905      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1906      * JSON-RPC method as part of EIP-191.
1907      *
1908      * See {recover}.
1909      */
1910     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1911         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1912     }
1913 
1914     /**
1915      * @dev Returns an Ethereum Signed Typed Data, created from a
1916      * `domainSeparator` and a `structHash`. This produces hash corresponding
1917      * to the one signed with the
1918      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1919      * JSON-RPC method as part of EIP-712.
1920      *
1921      * See {recover}.
1922      */
1923     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1924         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1925     }
1926 }
1927 abstract contract Context {
1928     function _msgSender() internal view virtual returns (address) {
1929         return msg.sender;
1930     }
1931 
1932     function _msgData() internal view virtual returns (bytes calldata) {
1933         return msg.data;
1934     }
1935 }
1936 abstract contract Ownable is Context {
1937     address private _owner;
1938 
1939     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1940 
1941     /**
1942      * @dev Initializes the contract setting the deployer as the initial owner.
1943      */
1944     constructor() {
1945         _transferOwnership(_msgSender());
1946     }
1947 
1948     /**
1949      * @dev Throws if called by any account other than the owner.
1950      */
1951     modifier onlyOwner() {
1952         _checkOwner();
1953         _;
1954     }
1955 
1956     /**
1957      * @dev Returns the address of the current owner.
1958      */
1959     function owner() public view virtual returns (address) {
1960         return _owner;
1961     }
1962 
1963     /**
1964      * @dev Throws if the sender is not the owner.
1965      */
1966     function _checkOwner() internal view virtual {
1967         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1968     }
1969 
1970     /**
1971      * @dev Leaves the contract without owner. It will not be possible to call
1972      * `onlyOwner` functions anymore. Can only be called by the current owner.
1973      *
1974      * NOTE: Renouncing ownership will leave the contract without an owner,
1975      * thereby removing any functionality that is only available to the owner.
1976      */
1977     function renounceOwnership() public virtual onlyOwner {
1978         _transferOwnership(address(0));
1979     }
1980 
1981     /**
1982      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1983      * Can only be called by the current owner.
1984      */
1985     function transferOwnership(address newOwner) public virtual onlyOwner {
1986         require(newOwner != address(0), "Ownable: new owner is the zero address");
1987         _transferOwnership(newOwner);
1988     }
1989 
1990     /**
1991      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1992      * Internal function without access restriction.
1993      */
1994     function _transferOwnership(address newOwner) internal virtual {
1995         address oldOwner = _owner;
1996         _owner = newOwner;
1997         emit OwnershipTransferred(oldOwner, newOwner);
1998     }
1999 }
2000 library Address {
2001     /**
2002      * @dev Returns true if `account` is a contract.
2003      *
2004      * [IMPORTANT]
2005      * ====
2006      * It is unsafe to assume that an address for which this function returns
2007      * false is an externally-owned account (EOA) and not a contract.
2008      *
2009      * Among others, `isContract` will return false for the following
2010      * types of addresses:
2011      *
2012      *  - an externally-owned account
2013      *  - a contract in construction
2014      *  - an address where a contract will be created
2015      *  - an address where a contract lived, but was destroyed
2016      * ====
2017      *
2018      * [IMPORTANT]
2019      * ====
2020      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2021      *
2022      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2023      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2024      * constructor.
2025      * ====
2026      */
2027     function isContract(address account) internal view returns (bool) {
2028         // This method relies on extcodesize/address.code.length, which returns 0
2029         // for contracts in construction, since the code is only stored at the end
2030         // of the constructor execution.
2031 
2032         return account.code.length > 0;
2033     }
2034 
2035     /**
2036      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2037      * `recipient`, forwarding all available gas and reverting on errors.
2038      *
2039      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2040      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2041      * imposed by `transfer`, making them unable to receive funds via
2042      * `transfer`. {sendValue} removes this limitation.
2043      *
2044      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2045      *
2046      * IMPORTANT: because control is transferred to `recipient`, care must be
2047      * taken to not create reentrancy vulnerabilities. Consider using
2048      * {ReentrancyGuard} or the
2049      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2050      */
2051     function sendValue(address payable recipient, uint256 amount) internal {
2052         require(address(this).balance >= amount, "Address: insufficient balance");
2053 
2054         (bool success, ) = recipient.call{value: amount}("");
2055         require(success, "Address: unable to send value, recipient may have reverted");
2056     }
2057 
2058     /**
2059      * @dev Performs a Solidity function call using a low level `call`. A
2060      * plain `call` is an unsafe replacement for a function call: use this
2061      * function instead.
2062      *
2063      * If `target` reverts with a revert reason, it is bubbled up by this
2064      * function (like regular Solidity function calls).
2065      *
2066      * Returns the raw returned data. To convert to the expected return value,
2067      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2068      *
2069      * Requirements:
2070      *
2071      * - `target` must be a contract.
2072      * - calling `target` with `data` must not revert.
2073      *
2074      * _Available since v3.1._
2075      */
2076     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2077         return functionCall(target, data, "Address: low-level call failed");
2078     }
2079 
2080     /**
2081      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2082      * `errorMessage` as a fallback revert reason when `target` reverts.
2083      *
2084      * _Available since v3.1._
2085      */
2086     function functionCall(
2087         address target,
2088         bytes memory data,
2089         string memory errorMessage
2090     ) internal returns (bytes memory) {
2091         return functionCallWithValue(target, data, 0, errorMessage);
2092     }
2093 
2094     /**
2095      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2096      * but also transferring `value` wei to `target`.
2097      *
2098      * Requirements:
2099      *
2100      * - the calling contract must have an ETH balance of at least `value`.
2101      * - the called Solidity function must be `payable`.
2102      *
2103      * _Available since v3.1._
2104      */
2105     function functionCallWithValue(
2106         address target,
2107         bytes memory data,
2108         uint256 value
2109     ) internal returns (bytes memory) {
2110         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2111     }
2112 
2113     /**
2114      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2115      * with `errorMessage` as a fallback revert reason when `target` reverts.
2116      *
2117      * _Available since v3.1._
2118      */
2119     function functionCallWithValue(
2120         address target,
2121         bytes memory data,
2122         uint256 value,
2123         string memory errorMessage
2124     ) internal returns (bytes memory) {
2125         require(address(this).balance >= value, "Address: insufficient balance for call");
2126         require(isContract(target), "Address: call to non-contract");
2127 
2128         (bool success, bytes memory returndata) = target.call{value: value}(data);
2129         return verifyCallResult(success, returndata, errorMessage);
2130     }
2131 
2132     /**
2133      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2134      * but performing a static call.
2135      *
2136      * _Available since v3.3._
2137      */
2138     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2139         return functionStaticCall(target, data, "Address: low-level static call failed");
2140     }
2141 
2142     /**
2143      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2144      * but performing a static call.
2145      *
2146      * _Available since v3.3._
2147      */
2148     function functionStaticCall(
2149         address target,
2150         bytes memory data,
2151         string memory errorMessage
2152     ) internal view returns (bytes memory) {
2153         require(isContract(target), "Address: static call to non-contract");
2154 
2155         (bool success, bytes memory returndata) = target.staticcall(data);
2156         return verifyCallResult(success, returndata, errorMessage);
2157     }
2158 
2159     /**
2160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2161      * but performing a delegate call.
2162      *
2163      * _Available since v3.4._
2164      */
2165     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2166         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2167     }
2168 
2169     /**
2170      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2171      * but performing a delegate call.
2172      *
2173      * _Available since v3.4._
2174      */
2175     function functionDelegateCall(  
2176         address target,
2177         bytes memory data,
2178         string memory errorMessage
2179     ) internal returns (bytes memory) {
2180         require(isContract(target), "Address: delegate call to non-contract");
2181 
2182         (bool success, bytes memory returndata) = target.delegatecall(data);
2183         return verifyCallResult(success, returndata, errorMessage);
2184     }
2185 
2186     /**
2187      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2188      * revert reason using the provided one.
2189      *
2190      * _Available since v4.3._
2191      */
2192     function verifyCallResult(
2193         bool success,
2194         bytes memory returndata,
2195         string memory errorMessage
2196     ) internal pure returns (bytes memory) {
2197         if (success) {
2198             return returndata;
2199         } else {
2200             // Look for revert reason and bubble it up if present
2201             if (returndata.length > 0) {
2202                 // The easiest way to bubble the revert reason is using memory via assembly
2203                 /// @solidity memory-safe-assembly
2204                 assembly {
2205                     let returndata_size := mload(returndata)
2206                     revert(add(32, returndata), returndata_size)
2207                 }
2208             } else {
2209                 revert(errorMessage);
2210             }
2211         }
2212     }
2213 }
2214 contract KRLRacers is ERC721A,  Ownable {
2215     using SafeMath for uint256;
2216     using Counters for Counters.Counter;
2217     using ECDSA for bytes32;
2218     bytes32 public root;
2219     address private _signerAddress;
2220     address public saleModifier;
2221     string private baseURI_;
2222     mapping(bytes=>bool) public usedSigns;
2223     uint256 public immutable MAX_SUPPLY = 12000;
2224     uint256 public immutable HOLDERS_LIMIT = 7681;
2225     uint256 public immutable ALLOWLIST_LIMIT = 4000;
2226     uint256 public CURRENT_ALLOWLIST_CAP;
2227     uint256 public HOLDER_MINT_PRICE =0.03 ether;
2228     uint256 public MINT_PRICE=0.09 ether;
2229     uint256 private HOLDERS_MINTED;
2230     uint256 private ALLOWLIST_MINTED;
2231     uint256 public HOLDER_SALE_START_TIME=1663682400;
2232     uint256 public HOLDER_SALE_END_TIME=1664546400;
2233     uint256 public ALLOWLIST_SALE_START_TIME=1664028000;
2234     uint256 public ALLOWLIST_SALE_END_TIME=1666447200;
2235     uint256 public PUBLIC_SALE_START_TIME;
2236     uint256 public PUBLIC_SALE_END_TIME;   
2237     mapping(address=>uint256) private holderMinted;
2238     mapping(address=>uint256) private allowlistMinted;
2239     mapping(address=>uint256) private collabMinted;
2240     mapping(address=> bool) public holderFees;
2241     event HolderSaleTimeChanged(uint256 startTime, uint256 endTime);
2242     event AllowListSaleTimeChanged(uint256 startTime, uint256 endTime);
2243     event PublicSaleTimeChanged(uint256 startTime, uint256 endTime);
2244 
2245 
2246     constructor(address signerAddress_) ERC721A("KRL Racers", "Racers") {       
2247         _signerAddress = signerAddress_;
2248         setBaseURI("https://api-nft.kartracingleague.com/api/nft/");
2249     }
2250 
2251     function checkHolderWallet(address wallet) public view returns(uint256) {
2252         return holderMinted[wallet];
2253     }
2254     function checkAllowlistWallet(address wallet) public view returns(uint256) {
2255         return allowlistMinted[wallet];
2256     }
2257     function checkCollabWalletMinted(address wallet) public view returns(uint256) {
2258         return collabMinted[wallet];
2259     }
2260 
2261     function checkHolderMinted() public view returns(uint256){
2262         return HOLDERS_MINTED;
2263     }
2264     function checkAllowlistMinted() public view returns(uint256){
2265         return ALLOWLIST_MINTED;
2266     }
2267 
2268 
2269     function _baseURI() internal view virtual override  returns (string memory) {
2270         return baseURI_;
2271     }
2272 
2273     modifier isModifier {
2274         require(msg.sender == owner() || msg.sender ==saleModifier, "You cant do it");
2275         _;
2276     }
2277 
2278     function availableForAllowlist() public view  returns(uint256){
2279         require(whenAllowlistSaleIsOn()==true,"whitelist sale not start yet" );
2280         if(block.timestamp>HOLDER_SALE_END_TIME){
2281         return CURRENT_ALLOWLIST_CAP.add(HOLDERS_LIMIT.sub(HOLDERS_MINTED));
2282         } else {
2283             return CURRENT_ALLOWLIST_CAP;
2284         }
2285     }
2286 
2287     function whenHolderSaleIsOn() public view  returns (bool) {
2288         if(block.timestamp > HOLDER_SALE_START_TIME && block.timestamp < HOLDER_SALE_END_TIME)
2289         {
2290             return true;
2291         }
2292         else {
2293             return false;
2294         }
2295     }
2296     function whenAllowlistSaleIsOn() public view  returns (bool) {
2297         if(block.timestamp > ALLOWLIST_SALE_START_TIME && block.timestamp < ALLOWLIST_SALE_END_TIME)
2298         {
2299             return true;
2300         }
2301         else {
2302              return false;
2303         }
2304         
2305     }
2306     function whenPublicaleIsOn() public view  returns (bool) {
2307         if(block.timestamp > PUBLIC_SALE_START_TIME && block.timestamp < PUBLIC_SALE_END_TIME)
2308         {
2309             return true;
2310         }
2311         else 
2312         {
2313             return false;
2314         }
2315         
2316     }    
2317 
2318     function setAllowlistCap(uint256 limit_) public isModifier {
2319         CURRENT_ALLOWLIST_CAP = limit_;
2320     }
2321 
2322     function changeHolderSaleTime(uint256 startTime, uint256 endTime) public isModifier {
2323         HOLDER_SALE_START_TIME = startTime;
2324         HOLDER_SALE_END_TIME = endTime;
2325         emit HolderSaleTimeChanged(startTime, endTime);
2326     }
2327 
2328     function startAllowlistPhase(uint256 startTime, uint256 endTime) public isModifier {
2329         ALLOWLIST_SALE_START_TIME = startTime;
2330         ALLOWLIST_SALE_END_TIME = endTime;
2331         emit AllowListSaleTimeChanged(startTime, endTime);
2332     }
2333 
2334     function changePublicSaleTime(uint256 startTime, uint256 endTime) public isModifier {
2335         PUBLIC_SALE_START_TIME = startTime;
2336         PUBLIC_SALE_END_TIME = endTime;
2337         emit PublicSaleTimeChanged(startTime, endTime);
2338     }
2339 
2340     function changeSignerwallet(address _signerWallet) public isModifier {
2341         _signerAddress = _signerWallet;
2342     }
2343 
2344     function setSaleModifier(address wallet) public isModifier {
2345         saleModifier = wallet;
2346     }
2347 
2348     function holderMintNew(uint256 quantity, bytes calldata signature) public payable  {
2349         require(whenHolderSaleIsOn()==true,"Holder sale is not ON");
2350         require(usedSigns[signature]==false,"signature already use");
2351         usedSigns[signature]=true;
2352         HOLDERS_MINTED+=quantity;
2353         holderMinted[msg.sender]+=quantity;
2354         require(checkHolderMinted()<=HOLDERS_LIMIT, "Mint would exceed limit");
2355         require(checkSign(signature,quantity)==_signerAddress, "Invalid Signature");
2356         if(holderFees[msg.sender]==false){
2357           require(msg.value == HOLDER_MINT_PRICE, "Send proper mint fees");
2358           holderFees[msg.sender] = true;
2359           payable(owner()).transfer(msg.value);  
2360         }
2361         require(totalSupply().add(quantity)<=MAX_SUPPLY, "Exceeding Max Limit");            
2362         _safeMint(msg.sender, quantity);
2363       
2364     }
2365 
2366     function allowListMint(uint256 quantity, bytes32[] calldata proof) public payable  {
2367        require(whenAllowlistSaleIsOn()==true,"whitelist sale not start yet" );
2368        require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not a part of Allowlist");
2369        require(msg.value == quantity * MINT_PRICE, "Send proper msg value");
2370        require(totalSupply().add(quantity)<=MAX_SUPPLY, "Exceeding Max Limit");
2371        ALLOWLIST_MINTED+=quantity;
2372        require(checkAllowlistMinted()<=availableForAllowlist(), "Will Exceed Allowlist Limit");
2373        allowlistMinted[msg.sender]+=quantity;
2374        payable(owner()).transfer(msg.value);
2375         _safeMint(msg.sender, quantity);
2376     }
2377 
2378 
2379 
2380     function publicMint(uint256 quantity) public payable  {
2381        require(whenPublicaleIsOn()==true,"public sale is not on");
2382        require(msg.value == quantity * MINT_PRICE, "Send proper msg value");
2383        require(totalSupply().add(quantity)<=MAX_SUPPLY, "Exceeding Max Limit");
2384        payable(owner()).transfer(msg.value);
2385         _safeMint(msg.sender, quantity);
2386      
2387     }
2388 
2389     function CollabMint(uint256 quantity, bytes calldata signature) public payable {
2390         require(usedSigns[signature]==false,"signature already use");
2391         usedSigns[signature]=true;
2392         collabMinted[msg.sender]+=quantity;
2393         require(checkCollabSign(signature,collabMinted[msg.sender])==_signerAddress, "Invalid Signature");
2394         require(msg.value == MINT_PRICE.mul(quantity), "Send proper mint fees");
2395         require(totalSupply().add(quantity)<=MAX_SUPPLY, "Exceeding Max Limit");            
2396         payable(owner()).transfer(msg.value);
2397        _safeMint(msg.sender, quantity);
2398     }
2399 
2400 
2401 
2402     function setBaseURI(string memory baseuri) public onlyOwner {
2403         baseURI_ = baseuri;
2404     }
2405 
2406     function checkSign(bytes calldata signature,uint256 quantity) private view returns (address) {
2407         return keccak256(
2408             abi.encodePacked(
2409                "\x19Ethereum Signed Message:\n32",
2410                 keccak256(abi.encodePacked(totalSupply().add(quantity)))    
2411             )
2412         ).recover(signature);
2413     }
2414 
2415     function getsignInput(address wallet, uint256 amt) public pure returns(bytes32){
2416         return((keccak256(abi.encodePacked([keccak256(abi.encodePacked(wallet)), bytes32(amt)]))));
2417     }
2418     
2419     function checkCollabSign(bytes calldata signature, uint256 quantity) public view returns (address) {
2420         return keccak256(
2421             abi.encodePacked(
2422                "\x19Ethereum Signed Message:\n32",
2423                 (getsignInput(msg.sender, quantity))  
2424             )
2425         ).recover(signature);
2426     }
2427     
2428     function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
2429         return MerkleProof.verify(proof, root, leaf);
2430     }
2431 
2432     function setRoot(bytes32 _root) public isModifier {
2433         root = _root;
2434     }
2435     function burn(uint256 tokenId) public {
2436         require(ownerOf(tokenId) == msg.sender,"you are not owner of token");
2437             _burn(tokenId);
2438     }
2439 
2440     function withdraw() public payable onlyOwner {
2441         payable(owner()).transfer(balanceOf(address(this)));
2442     }
2443 
2444 }