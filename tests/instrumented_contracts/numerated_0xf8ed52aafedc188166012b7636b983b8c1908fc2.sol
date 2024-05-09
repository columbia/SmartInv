1 // SPDX-License-Identifier: MIT
2 // ERC721A Contracts v4.2.3
3 // Creator: Chiru Labs
4 
5 pragma solidity ^0.8.17;
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
296 contract ERC721A is IERC721A {
297     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
298     struct TokenApprovalRef {
299         address value;
300     }
301 
302     // =============================================================
303     //                           CONSTANTS
304     // =============================================================
305 
306     // Mask of an entry in packed address data.
307     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
308 
309     // The bit position of `numberMinted` in packed address data.
310     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
311 
312     // The bit position of `numberBurned` in packed address data.
313     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
314 
315     // The bit position of `aux` in packed address data.
316     uint256 private constant _BITPOS_AUX = 192;
317 
318     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
319     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
320 
321     // The bit position of `startTimestamp` in packed ownership.
322     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
323 
324     // The bit mask of the `burned` bit in packed ownership.
325     uint256 private constant _BITMASK_BURNED = 1 << 224;
326 
327     // The bit position of the `nextInitialized` bit in packed ownership.
328     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
329 
330     // The bit mask of the `nextInitialized` bit in packed ownership.
331     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
332 
333     // The bit position of `extraData` in packed ownership.
334     uint256 private constant _BITPOS_EXTRA_DATA = 232;
335 
336     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
337     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
338 
339     // The mask of the lower 160 bits for addresses.
340     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
341 
342     // The maximum `quantity` that can be minted with {_mintERC2309}.
343     // This limit is to prevent overflows on the address data entries.
344     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
345     // is required to cause an overflow, which is unrealistic.
346     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
347 
348     // The `Transfer` event signature is given by:
349     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
350     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
351         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
352 
353     // =============================================================
354     //                            STORAGE
355     // =============================================================
356 
357     // The next token ID to be minted.
358     uint256 private _currentIndex;
359 
360     // The number of tokens burned.
361     uint256 private _burnCounter;
362 
363     // Token name
364     string private _name;
365 
366     // Token symbol
367     string private _symbol;
368 
369     // Mapping from token ID to ownership details
370     // An empty struct value does not necessarily mean the token is unowned.
371     // See {_packedOwnershipOf} implementation for details.
372     //
373     // Bits Layout:
374     // - [0..159]   `addr`
375     // - [160..223] `startTimestamp`
376     // - [224]      `burned`
377     // - [225]      `nextInitialized`
378     // - [232..255] `extraData`
379     mapping(uint256 => uint256) private _packedOwnerships;
380 
381     // Mapping owner address to address data.
382     //
383     // Bits Layout:
384     // - [0..63]    `balance`
385     // - [64..127]  `numberMinted`
386     // - [128..191] `numberBurned`
387     // - [192..255] `aux`
388     mapping(address => uint256) private _packedAddressData;
389 
390     // Mapping from token ID to approved address.
391     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
392 
393     // Mapping from owner to operator approvals
394     mapping(address => mapping(address => bool)) private _operatorApprovals;
395 
396     // =============================================================
397     //                          CONSTRUCTOR
398     // =============================================================
399 
400     constructor(string memory name_, string memory symbol_) {
401         _name = name_;
402         _symbol = symbol_;
403         _currentIndex = _startTokenId();
404     }
405 
406     // =============================================================
407     //                   TOKEN COUNTING OPERATIONS
408     // =============================================================
409 
410     /**
411      * @dev Returns the starting token ID.
412      * To change the starting token ID, please override this function.
413      */
414     function _startTokenId() internal view virtual returns (uint256) {
415         return 0;
416     }
417 
418     /**
419      * @dev Returns the next token ID to be minted.
420      */
421     function _nextTokenId() internal view virtual returns (uint256) {
422         return _currentIndex;
423     }
424 
425     /**
426      * @dev Returns the total number of tokens in existence.
427      * Burned tokens will reduce the count.
428      * To get the total number of tokens minted, please see {_totalMinted}.
429      */
430     function totalSupply() public view virtual override returns (uint256) {
431         // Counter underflow is impossible as _burnCounter cannot be incremented
432         // more than `_currentIndex - _startTokenId()` times.
433         unchecked {
434             return _currentIndex - _burnCounter - _startTokenId();
435         }
436     }
437 
438     /**
439      * @dev Returns the total amount of tokens minted in the contract.
440      */
441     function _totalMinted() internal view virtual returns (uint256) {
442         // Counter underflow is impossible as `_currentIndex` does not decrement,
443         // and it is initialized to `_startTokenId()`.
444         unchecked {
445             return _currentIndex - _startTokenId();
446         }
447     }
448 
449     /**
450      * @dev Returns the total number of tokens burned.
451      */
452     function _totalBurned() internal view virtual returns (uint256) {
453         return _burnCounter;
454     }
455 
456     // =============================================================
457     //                    ADDRESS DATA OPERATIONS
458     // =============================================================
459 
460     /**
461      * @dev Returns the number of tokens in `owner`'s account.
462      */
463     function balanceOf(address owner) public view virtual override returns (uint256) {
464         if (owner == address(0)) revert BalanceQueryForZeroAddress();
465         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
466     }
467 
468     /**
469      * Returns the number of tokens minted by `owner`.
470      */
471     function _numberMinted(address owner) internal view returns (uint256) {
472         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
473     }
474 
475     /**
476      * Returns the number of tokens burned by or on behalf of `owner`.
477      */
478     function _numberBurned(address owner) internal view returns (uint256) {
479         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
480     }
481 
482     /**
483      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
484      */
485     function _getAux(address owner) internal view returns (uint64) {
486         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
487     }
488 
489     /**
490      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
491      * If there are multiple variables, please pack them into a uint64.
492      */
493     function _setAux(address owner, uint64 aux) internal virtual {
494         uint256 packed = _packedAddressData[owner];
495         uint256 auxCasted;
496         // Cast `aux` with assembly to avoid redundant masking.
497         assembly {
498             auxCasted := aux
499         }
500         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
501         _packedAddressData[owner] = packed;
502     }
503 
504     // =============================================================
505     //                            IERC165
506     // =============================================================
507 
508     /**
509      * @dev Returns true if this contract implements the interface defined by
510      * `interfaceId`. See the corresponding
511      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
512      * to learn more about how these ids are created.
513      *
514      * This function call must use less than 30000 gas.
515      */
516     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517         // The interface IDs are constants representing the first 4 bytes
518         // of the XOR of all function selectors in the interface.
519         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
520         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
521         return
522             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
523             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
524             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
525     }
526 
527     // =============================================================
528     //                        IERC721Metadata
529     // =============================================================
530 
531     /**
532      * @dev Returns the token collection name.
533      */
534     function name() public view virtual override returns (string memory) {
535         return _name;
536     }
537 
538     /**
539      * @dev Returns the token collection symbol.
540      */
541     function symbol() public view virtual override returns (string memory) {
542         return _symbol;
543     }
544 
545     /**
546      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
547      */
548     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
549         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
550 
551         string memory baseURI = _baseURI();
552         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
553     }
554 
555     /**
556      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
557      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
558      * by default, it can be overridden in child contracts.
559      */
560     function _baseURI() internal view virtual returns (string memory) {
561         return '';
562     }
563 
564     // =============================================================
565     //                     OWNERSHIPS OPERATIONS
566     // =============================================================
567 
568     /**
569      * @dev Returns the owner of the `tokenId` token.
570      *
571      * Requirements:
572      *
573      * - `tokenId` must exist.
574      */
575     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
576         return address(uint160(_packedOwnershipOf(tokenId)));
577     }
578 
579     /**
580      * @dev Gas spent here starts off proportional to the maximum mint batch size.
581      * It gradually moves to O(1) as tokens get transferred around over time.
582      */
583     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
584         return _unpackedOwnership(_packedOwnershipOf(tokenId));
585     }
586 
587     /**
588      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
589      */
590     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
591         return _unpackedOwnership(_packedOwnerships[index]);
592     }
593 
594     /**
595      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
596      */
597     function _initializeOwnershipAt(uint256 index) internal virtual {
598         if (_packedOwnerships[index] == 0) {
599             _packedOwnerships[index] = _packedOwnershipOf(index);
600         }
601     }
602 
603     /**
604      * Returns the packed ownership data of `tokenId`.
605      */
606     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
607         uint256 curr = tokenId;
608 
609         unchecked {
610             if (_startTokenId() <= curr)
611                 if (curr < _currentIndex) {
612                     uint256 packed = _packedOwnerships[curr];
613                     // If not burned.
614                     if (packed & _BITMASK_BURNED == 0) {
615                         // Invariant:
616                         // There will always be an initialized ownership slot
617                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
618                         // before an unintialized ownership slot
619                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
620                         // Hence, `curr` will not underflow.
621                         //
622                         // We can directly compare the packed value.
623                         // If the address is zero, packed will be zero.
624                         while (packed == 0) {
625                             packed = _packedOwnerships[--curr];
626                         }
627                         return packed;
628                     }
629                 }
630         }
631         revert OwnerQueryForNonexistentToken();
632     }
633 
634     /**
635      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
636      */
637     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
638         ownership.addr = address(uint160(packed));
639         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
640         ownership.burned = packed & _BITMASK_BURNED != 0;
641         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
642     }
643 
644     /**
645      * @dev Packs ownership data into a single uint256.
646      */
647     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
648         assembly {
649             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
650             owner := and(owner, _BITMASK_ADDRESS)
651             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
652             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
653         }
654     }
655 
656     /**
657      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
658      */
659     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
660         // For branchless setting of the `nextInitialized` flag.
661         assembly {
662             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
663             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
664         }
665     }
666 
667     // =============================================================
668     //                      APPROVAL OPERATIONS
669     // =============================================================
670 
671     /**
672      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
673      * The approval is cleared when the token is transferred.
674      *
675      * Only a single account can be approved at a time, so approving the
676      * zero address clears previous approvals.
677      *
678      * Requirements:
679      *
680      * - The caller must own the token or be an approved operator.
681      * - `tokenId` must exist.
682      *
683      * Emits an {Approval} event.
684      */
685     function approve(address to, uint256 tokenId) public payable virtual override {
686         address owner = ownerOf(tokenId);
687 
688         if (_msgSenderERC721A() != owner)
689             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
690                 revert ApprovalCallerNotOwnerNorApproved();
691             }
692 
693         _tokenApprovals[tokenId].value = to;
694         emit Approval(owner, to, tokenId);
695     }
696 
697     /**
698      * @dev Returns the account approved for `tokenId` token.
699      *
700      * Requirements:
701      *
702      * - `tokenId` must exist.
703      */
704     function getApproved(uint256 tokenId) public view virtual override returns (address) {
705         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
706 
707         return _tokenApprovals[tokenId].value;
708     }
709 
710     /**
711      * @dev Approve or remove `operator` as an operator for the caller.
712      * Operators can call {transferFrom} or {safeTransferFrom}
713      * for any token owned by the caller.
714      *
715      * Requirements:
716      *
717      * - The `operator` cannot be the caller.
718      *
719      * Emits an {ApprovalForAll} event.
720      */
721     function setApprovalForAll(address operator, bool approved) public virtual override {
722         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
723         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
724     }
725 
726     /**
727      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
728      *
729      * See {setApprovalForAll}.
730      */
731     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
732         return _operatorApprovals[owner][operator];
733     }
734 
735     /**
736      * @dev Returns whether `tokenId` exists.
737      *
738      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
739      *
740      * Tokens start existing when they are minted. See {_mint}.
741      */
742     function _exists(uint256 tokenId) internal view virtual returns (bool) {
743         return
744             _startTokenId() <= tokenId &&
745             tokenId < _currentIndex && // If within bounds,
746             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
747     }
748 
749     /**
750      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
751      */
752     function _isSenderApprovedOrOwner(
753         address approvedAddress,
754         address owner,
755         address msgSender
756     ) private pure returns (bool result) {
757         assembly {
758             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
759             owner := and(owner, _BITMASK_ADDRESS)
760             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
761             msgSender := and(msgSender, _BITMASK_ADDRESS)
762             // `msgSender == owner || msgSender == approvedAddress`.
763             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
764         }
765     }
766 
767     /**
768      * @dev Returns the storage slot and value for the approved address of `tokenId`.
769      */
770     function _getApprovedSlotAndAddress(uint256 tokenId)
771         private
772         view
773         returns (uint256 approvedAddressSlot, address approvedAddress)
774     {
775         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
776         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
777         assembly {
778             approvedAddressSlot := tokenApproval.slot
779             approvedAddress := sload(approvedAddressSlot)
780         }
781     }
782 
783     // =============================================================
784     //                      TRANSFER OPERATIONS
785     // =============================================================
786 
787     /**
788      * @dev Transfers `tokenId` from `from` to `to`.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must be owned by `from`.
795      * - If the caller is not `from`, it must be approved to move this token
796      * by either {approve} or {setApprovalForAll}.
797      *
798      * Emits a {Transfer} event.
799      */
800     function transferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) public payable virtual override {
805         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
806 
807         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
808 
809         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
810 
811         // The nested ifs save around 20+ gas over a compound boolean condition.
812         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
813             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
814 
815         if (to == address(0)) revert TransferToZeroAddress();
816 
817         _beforeTokenTransfers(from, to, tokenId, 1);
818 
819         // Clear approvals from the previous owner.
820         assembly {
821             if approvedAddress {
822                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
823                 sstore(approvedAddressSlot, 0)
824             }
825         }
826 
827         // Underflow of the sender's balance is impossible because we check for
828         // ownership above and the recipient's balance can't realistically overflow.
829         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
830         unchecked {
831             // We can directly increment and decrement the balances.
832             --_packedAddressData[from]; // Updates: `balance -= 1`.
833             ++_packedAddressData[to]; // Updates: `balance += 1`.
834 
835             // Updates:
836             // - `address` to the next owner.
837             // - `startTimestamp` to the timestamp of transfering.
838             // - `burned` to `false`.
839             // - `nextInitialized` to `true`.
840             _packedOwnerships[tokenId] = _packOwnershipData(
841                 to,
842                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
843             );
844 
845             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
846             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
847                 uint256 nextTokenId = tokenId + 1;
848                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
849                 if (_packedOwnerships[nextTokenId] == 0) {
850                     // If the next slot is within bounds.
851                     if (nextTokenId != _currentIndex) {
852                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
853                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
854                     }
855                 }
856             }
857         }
858 
859         emit Transfer(from, to, tokenId);
860         _afterTokenTransfers(from, to, tokenId, 1);
861     }
862 
863     /**
864      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
865      */
866     function safeTransferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public payable virtual override {
871         safeTransferFrom(from, to, tokenId, '');
872     }
873 
874     /**
875      * @dev Safely transfers `tokenId` token from `from` to `to`.
876      *
877      * Requirements:
878      *
879      * - `from` cannot be the zero address.
880      * - `to` cannot be the zero address.
881      * - `tokenId` token must exist and be owned by `from`.
882      * - If the caller is not `from`, it must be approved to move this token
883      * by either {approve} or {setApprovalForAll}.
884      * - If `to` refers to a smart contract, it must implement
885      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
886      *
887      * Emits a {Transfer} event.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory _data
894     ) public payable virtual override {
895         transferFrom(from, to, tokenId);
896         if (to.code.length != 0)
897             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
898                 revert TransferToNonERC721ReceiverImplementer();
899             }
900     }
901 
902     /**
903      * @dev Hook that is called before a set of serially-ordered token IDs
904      * are about to be transferred. This includes minting.
905      * And also called before burning one token.
906      *
907      * `startTokenId` - the first token ID to be transferred.
908      * `quantity` - the amount to be transferred.
909      *
910      * Calling conditions:
911      *
912      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
913      * transferred to `to`.
914      * - When `from` is zero, `tokenId` will be minted for `to`.
915      * - When `to` is zero, `tokenId` will be burned by `from`.
916      * - `from` and `to` are never both zero.
917      */
918     function _beforeTokenTransfers(
919         address from,
920         address to,
921         uint256 startTokenId,
922         uint256 quantity
923     ) internal virtual {}
924 
925     /**
926      * @dev Hook that is called after a set of serially-ordered token IDs
927      * have been transferred. This includes minting.
928      * And also called after one token has been burned.
929      *
930      * `startTokenId` - the first token ID to be transferred.
931      * `quantity` - the amount to be transferred.
932      *
933      * Calling conditions:
934      *
935      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
936      * transferred to `to`.
937      * - When `from` is zero, `tokenId` has been minted for `to`.
938      * - When `to` is zero, `tokenId` has been burned by `from`.
939      * - `from` and `to` are never both zero.
940      */
941     function _afterTokenTransfers(
942         address from,
943         address to,
944         uint256 startTokenId,
945         uint256 quantity
946     ) internal virtual {}
947 
948     /**
949      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
950      *
951      * `from` - Previous owner of the given token ID.
952      * `to` - Target address that will receive the token.
953      * `tokenId` - Token ID to be transferred.
954      * `_data` - Optional data to send along with the call.
955      *
956      * Returns whether the call correctly returned the expected magic value.
957      */
958     function _checkContractOnERC721Received(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) private returns (bool) {
964         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
965             bytes4 retval
966         ) {
967             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
968         } catch (bytes memory reason) {
969             if (reason.length == 0) {
970                 revert TransferToNonERC721ReceiverImplementer();
971             } else {
972                 assembly {
973                     revert(add(32, reason), mload(reason))
974                 }
975             }
976         }
977     }
978 
979     // =============================================================
980     //                        MINT OPERATIONS
981     // =============================================================
982 
983     /**
984      * @dev Mints `quantity` tokens and transfers them to `to`.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `quantity` must be greater than 0.
990      *
991      * Emits a {Transfer} event for each mint.
992      */
993     function _mint(address to, uint256 quantity) internal virtual {
994         uint256 startTokenId = _currentIndex;
995         if (quantity == 0) revert MintZeroQuantity();
996 
997         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
998 
999         // Overflows are incredibly unrealistic.
1000         // `balance` and `numberMinted` have a maximum limit of 2**64.
1001         // `tokenId` has a maximum limit of 2**256.
1002         unchecked {
1003             // Updates:
1004             // - `balance += quantity`.
1005             // - `numberMinted += quantity`.
1006             //
1007             // We can directly add to the `balance` and `numberMinted`.
1008             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1009 
1010             // Updates:
1011             // - `address` to the owner.
1012             // - `startTimestamp` to the timestamp of minting.
1013             // - `burned` to `false`.
1014             // - `nextInitialized` to `quantity == 1`.
1015             _packedOwnerships[startTokenId] = _packOwnershipData(
1016                 to,
1017                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1018             );
1019 
1020             uint256 toMasked;
1021             uint256 end = startTokenId + quantity;
1022 
1023             // Use assembly to loop and emit the `Transfer` event for gas savings.
1024             // The duplicated `log4` removes an extra check and reduces stack juggling.
1025             // The assembly, together with the surrounding Solidity code, have been
1026             // delicately arranged to nudge the compiler into producing optimized opcodes.
1027             assembly {
1028                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1029                 toMasked := and(to, _BITMASK_ADDRESS)
1030                 // Emit the `Transfer` event.
1031                 log4(
1032                     0, // Start of data (0, since no data).
1033                     0, // End of data (0, since no data).
1034                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1035                     0, // `address(0)`.
1036                     toMasked, // `to`.
1037                     startTokenId // `tokenId`.
1038                 )
1039 
1040                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1041                 // that overflows uint256 will make the loop run out of gas.
1042                 // The compiler will optimize the `iszero` away for performance.
1043                 for {
1044                     let tokenId := add(startTokenId, 1)
1045                 } iszero(eq(tokenId, end)) {
1046                     tokenId := add(tokenId, 1)
1047                 } {
1048                     // Emit the `Transfer` event. Similar to above.
1049                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1050                 }
1051             }
1052             if (toMasked == 0) revert MintToZeroAddress();
1053 
1054             _currentIndex = end;
1055         }
1056         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1057     }
1058 
1059     /**
1060      * @dev Mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * This function is intended for efficient minting only during contract creation.
1063      *
1064      * It emits only one {ConsecutiveTransfer} as defined in
1065      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1066      * instead of a sequence of {Transfer} event(s).
1067      *
1068      * Calling this function outside of contract creation WILL make your contract
1069      * non-compliant with the ERC721 standard.
1070      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1071      * {ConsecutiveTransfer} event is only permissible during contract creation.
1072      *
1073      * Requirements:
1074      *
1075      * - `to` cannot be the zero address.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {ConsecutiveTransfer} event.
1079      */
1080     function _mintERC2309(address to, uint256 quantity) internal virtual {
1081         uint256 startTokenId = _currentIndex;
1082         if (to == address(0)) revert MintToZeroAddress();
1083         if (quantity == 0) revert MintZeroQuantity();
1084         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1089         unchecked {
1090             // Updates:
1091             // - `balance += quantity`.
1092             // - `numberMinted += quantity`.
1093             //
1094             // We can directly add to the `balance` and `numberMinted`.
1095             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1096 
1097             // Updates:
1098             // - `address` to the owner.
1099             // - `startTimestamp` to the timestamp of minting.
1100             // - `burned` to `false`.
1101             // - `nextInitialized` to `quantity == 1`.
1102             _packedOwnerships[startTokenId] = _packOwnershipData(
1103                 to,
1104                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1105             );
1106 
1107             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1108 
1109             _currentIndex = startTokenId + quantity;
1110         }
1111         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1112     }
1113 
1114     /**
1115      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1116      *
1117      * Requirements:
1118      *
1119      * - If `to` refers to a smart contract, it must implement
1120      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1121      * - `quantity` must be greater than 0.
1122      *
1123      * See {_mint}.
1124      *
1125      * Emits a {Transfer} event for each mint.
1126      */
1127     function _safeMint(
1128         address to,
1129         uint256 quantity,
1130         bytes memory _data
1131     ) internal virtual {
1132         _mint(to, quantity);
1133 
1134         unchecked {
1135             if (to.code.length != 0) {
1136                 uint256 end = _currentIndex;
1137                 uint256 index = end - quantity;
1138                 do {
1139                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1140                         revert TransferToNonERC721ReceiverImplementer();
1141                     }
1142                 } while (index < end);
1143                 // Reentrancy protection.
1144                 if (_currentIndex != end) revert();
1145             }
1146         }
1147     }
1148 
1149     /**
1150      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1151      */
1152     function _safeMint(address to, uint256 quantity) internal virtual {
1153         _safeMint(to, quantity, '');
1154     }
1155 
1156     // =============================================================
1157     //                        BURN OPERATIONS
1158     // =============================================================
1159 
1160     /**
1161      * @dev Equivalent to `_burn(tokenId, false)`.
1162      */
1163     function _burn(uint256 tokenId) internal virtual {
1164         _burn(tokenId, false);
1165     }
1166 
1167     /**
1168      * @dev Destroys `tokenId`.
1169      * The approval is cleared when the token is burned.
1170      *
1171      * Requirements:
1172      *
1173      * - `tokenId` must exist.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1178         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1179 
1180         address from = address(uint160(prevOwnershipPacked));
1181 
1182         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1183 
1184         if (approvalCheck) {
1185             // The nested ifs save around 20+ gas over a compound boolean condition.
1186             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1187                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1188         }
1189 
1190         _beforeTokenTransfers(from, address(0), tokenId, 1);
1191 
1192         // Clear approvals from the previous owner.
1193         assembly {
1194             if approvedAddress {
1195                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1196                 sstore(approvedAddressSlot, 0)
1197             }
1198         }
1199 
1200         // Underflow of the sender's balance is impossible because we check for
1201         // ownership above and the recipient's balance can't realistically overflow.
1202         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1203         unchecked {
1204             // Updates:
1205             // - `balance -= 1`.
1206             // - `numberBurned += 1`.
1207             //
1208             // We can directly decrement the balance, and increment the number burned.
1209             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1210             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1211 
1212             // Updates:
1213             // - `address` to the last owner.
1214             // - `startTimestamp` to the timestamp of burning.
1215             // - `burned` to `true`.
1216             // - `nextInitialized` to `true`.
1217             _packedOwnerships[tokenId] = _packOwnershipData(
1218                 from,
1219                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1220             );
1221 
1222             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1223             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1224                 uint256 nextTokenId = tokenId + 1;
1225                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1226                 if (_packedOwnerships[nextTokenId] == 0) {
1227                     // If the next slot is within bounds.
1228                     if (nextTokenId != _currentIndex) {
1229                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1230                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1231                     }
1232                 }
1233             }
1234         }
1235 
1236         emit Transfer(from, address(0), tokenId);
1237         _afterTokenTransfers(from, address(0), tokenId, 1);
1238 
1239         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1240         unchecked {
1241             _burnCounter++;
1242         }
1243     }
1244 
1245     // =============================================================
1246     //                     EXTRA DATA OPERATIONS
1247     // =============================================================
1248 
1249     /**
1250      * @dev Directly sets the extra data for the ownership data `index`.
1251      */
1252     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1253         uint256 packed = _packedOwnerships[index];
1254         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1255         uint256 extraDataCasted;
1256         // Cast `extraData` with assembly to avoid redundant masking.
1257         assembly {
1258             extraDataCasted := extraData
1259         }
1260         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1261         _packedOwnerships[index] = packed;
1262     }
1263 
1264     /**
1265      * @dev Called during each token transfer to set the 24bit `extraData` field.
1266      * Intended to be overridden by the cosumer contract.
1267      *
1268      * `previousExtraData` - the value of `extraData` before transfer.
1269      *
1270      * Calling conditions:
1271      *
1272      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1273      * transferred to `to`.
1274      * - When `from` is zero, `tokenId` will be minted for `to`.
1275      * - When `to` is zero, `tokenId` will be burned by `from`.
1276      * - `from` and `to` are never both zero.
1277      */
1278     function _extraData(
1279         address from,
1280         address to,
1281         uint24 previousExtraData
1282     ) internal view virtual returns (uint24) {}
1283 
1284     /**
1285      * @dev Returns the next extra data for the packed ownership data.
1286      * The returned result is shifted into position.
1287      */
1288     function _nextExtraData(
1289         address from,
1290         address to,
1291         uint256 prevOwnershipPacked
1292     ) private view returns (uint256) {
1293         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1294         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1295     }
1296 
1297     // =============================================================
1298     //                       OTHER OPERATIONS
1299     // =============================================================
1300 
1301     /**
1302      * @dev Returns the message sender (defaults to `msg.sender`).
1303      *
1304      * If you are writing GSN compatible contracts, you need to override this function.
1305      */
1306     function _msgSenderERC721A() internal view virtual returns (address) {
1307         return msg.sender;
1308     }
1309 
1310     /**
1311      * @dev Converts a uint256 to its ASCII string decimal representation.
1312      */
1313     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1314         assembly {
1315             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1316             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1317             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1318             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1319             let m := add(mload(0x40), 0xa0)
1320             // Update the free memory pointer to allocate.
1321             mstore(0x40, m)
1322             // Assign the `str` to the end.
1323             str := sub(m, 0x20)
1324             // Zeroize the slot after the string.
1325             mstore(str, 0)
1326 
1327             // Cache the end of the memory to calculate the length later.
1328             let end := str
1329 
1330             // We write the string from rightmost digit to leftmost digit.
1331             // The following is essentially a do-while loop that also handles the zero case.
1332             // prettier-ignore
1333             for { let temp := value } 1 {} {
1334                 str := sub(str, 1)
1335                 // Write the character to the pointer.
1336                 // The ASCII index of the '0' character is 48.
1337                 mstore8(str, add(48, mod(temp, 10)))
1338                 // Keep dividing `temp` until zero.
1339                 temp := div(temp, 10)
1340                 // prettier-ignore
1341                 if iszero(temp) { break }
1342             }
1343 
1344             let length := sub(end, str)
1345             // Move the pointer 32 bytes leftwards to make room for the length.
1346             str := sub(str, 0x20)
1347             // Store the length.
1348             mstore(str, length)
1349         }
1350     }
1351 }
1352 
1353 contract BatchBurn is ERC721A{
1354     
1355     address private immutable _owner;
1356     modifier onlyOwner() { 
1357         require(_owner==msg.sender);
1358         _; 
1359     }
1360 
1361     uint256 public constant MAX_SUPPLY = 2500;
1362     uint256 public constant MAX_FREE_PER_WALLET = 1;
1363     uint256 public COST = 0.001 ether;
1364 
1365     string private useContractURI = "QmPUxEAwjogmPNkCZSHoH9H4TpEmk8KgnuYghHoD36C321";
1366     string private useBaseURI = "QmfM7tBMJdnF5WBFA8BrteEkNvcCMNaA9DLV7pChcj8R6x";
1367 
1368     constructor() ERC721A("Batch Burn", "BaBu") {
1369         _owner = msg.sender;
1370     }
1371 
1372     function batchBurn(uint256[] calldata ids) external onlyOwner{
1373         for(uint256 i=0; i < ids.length; i++){
1374             _burn(ids[i]);
1375         }
1376     }
1377 
1378     function mint(uint256 amount) external payable{
1379         address _caller = _msgSenderERC721A();
1380 
1381         require(totalSupply() + amount <= MAX_SUPPLY, "Sold Out");
1382         require(amount*COST <= msg.value, "Value to Low");
1383 
1384         _mint(_caller, amount);
1385     }
1386 
1387     function freeMint() external{
1388         address _caller = _msgSenderERC721A();
1389         uint256 amount = MAX_FREE_PER_WALLET;
1390 
1391         require(totalSupply() + amount <= MAX_SUPPLY, "Freemint Sold Out");
1392         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
1393 
1394         _mint(_caller, amount);
1395     }
1396 
1397 
1398     function setData(string memory _contract, string memory _base) external onlyOwner{
1399         useContractURI = _contract;
1400         useBaseURI = _base;
1401     }
1402 
1403     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1404         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1405         string memory baseURI = useBaseURI;
1406         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI)) : "";
1407     }
1408 
1409     function contractURI() public view returns (string memory) {
1410         return string(abi.encodePacked("ipfs://", useContractURI));
1411     }
1412 
1413     function withdraw() external onlyOwner {
1414         uint256 balance = address(this).balance;
1415         payable(msg.sender).transfer(balance);
1416     }
1417 }