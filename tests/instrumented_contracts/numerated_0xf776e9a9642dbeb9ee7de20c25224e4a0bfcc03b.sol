1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-20
3 */
4 
5 // File: contracts\IERC721A.sol
6 
7 
8 // ERC721A Contracts v4.2.3
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
179     ) external payable;
180 
181     /**
182      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external payable;
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
210     ) external payable;
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
226     function approve(address to, uint256 tokenId) external payable;
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
290 // File: contracts\ERC721A.sol
291 
292 
293 // ERC721A Contracts v4.2.3
294 // Creator: Chiru Labs
295 
296 pragma solidity ^0.8.4;
297 
298 /**
299  * @dev Interface of ERC721 token receiver.
300  */
301 interface ERC721A__IERC721Receiver {
302     function onERC721Received(
303         address operator,
304         address from,
305         uint256 tokenId,
306         bytes calldata data
307     ) external returns (bytes4);
308 }
309 
310 /**
311  * @title ERC721A
312  *
313  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
314  * Non-Fungible Token Standard, including the Metadata extension.
315  * Optimized for lower gas during batch mints.
316  *
317  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
318  * starting from `_startTokenId()`.
319  *
320  * Assumptions:
321  *
322  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
323  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
324  */
325 contract ERC721A is IERC721A {
326     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
327     struct TokenApprovalRef {
328         address value;
329     }
330 
331     // =============================================================
332     //                           CONSTANTS
333     // =============================================================
334 
335     // Mask of an entry in packed address data.
336     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
337 
338     // The bit position of `numberMinted` in packed address data.
339     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
340 
341     // The bit position of `numberBurned` in packed address data.
342     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
343 
344     // The bit position of `aux` in packed address data.
345     uint256 private constant _BITPOS_AUX = 192;
346 
347     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
348     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
349 
350     // The bit position of `startTimestamp` in packed ownership.
351     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
352 
353     // The bit mask of the `burned` bit in packed ownership.
354     uint256 private constant _BITMASK_BURNED = 1 << 224;
355 
356     // The bit position of the `nextInitialized` bit in packed ownership.
357     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
358 
359     // The bit mask of the `nextInitialized` bit in packed ownership.
360     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
361 
362     // The bit position of `extraData` in packed ownership.
363     uint256 private constant _BITPOS_EXTRA_DATA = 232;
364 
365     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
366     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
367 
368     // The mask of the lower 160 bits for addresses.
369     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
370 
371     // The maximum `quantity` that can be minted with {_mintERC2309}.
372     // This limit is to prevent overflows on the address data entries.
373     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
374     // is required to cause an overflow, which is unrealistic.
375     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
376 
377     // The `Transfer` event signature is given by:
378     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
379     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
380         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
381 
382     // =============================================================
383     //                            STORAGE
384     // =============================================================
385 
386     // The next token ID to be minted.
387     uint256 internal _currentIndex;
388 
389     // The number of tokens burned.
390     uint256 private _burnCounter;
391 
392     // Token name
393     string private _name;
394 
395     // Token symbol
396     string private _symbol;
397 
398     // Mapping from token ID to ownership details
399     // An empty struct value does not necessarily mean the token is unowned.
400     // See {_packedOwnershipOf} implementation for details.
401     //
402     // Bits Layout:
403     // - [0..159]   `addr`
404     // - [160..223] `startTimestamp`
405     // - [224]      `burned`
406     // - [225]      `nextInitialized`
407     // - [232..255] `extraData`
408     mapping(uint256 => uint256) private _packedOwnerships;
409 
410     // Mapping owner address to address data.
411     //
412     // Bits Layout:
413     // - [0..63]    `balance`
414     // - [64..127]  `numberMinted`
415     // - [128..191] `numberBurned`
416     // - [192..255] `aux`
417     mapping(address => uint256) private _packedAddressData;
418 
419     // Mapping from token ID to approved address.
420     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
421 
422     // Mapping from owner to operator approvals
423     mapping(address => mapping(address => bool)) internal _operatorApprovals;
424 
425     // =============================================================
426     //                          CONSTRUCTOR
427     // =============================================================
428 
429     constructor(string memory name_, string memory symbol_) {
430         _name = name_;
431         _symbol = symbol_;
432         _currentIndex = _startTokenId();
433     }
434 
435     // =============================================================
436     //                   TOKEN COUNTING OPERATIONS
437     // =============================================================
438 
439     /**
440      * @dev Returns the starting token ID.
441      * To change the starting token ID, please override this function.
442      */
443     function _startTokenId() internal view virtual returns (uint256) {
444         return 1;
445     }
446 
447     /**
448      * @dev Returns the next token ID to be minted.
449      */
450     function _nextTokenId() internal view virtual returns (uint256) {
451         return _currentIndex;
452     }
453 
454     /**
455      * @dev Returns the total number of tokens in existence.
456      * Burned tokens will reduce the count.
457      * To get the total number of tokens minted, please see {_totalMinted}.
458      */
459     function totalSupply() public view virtual override returns (uint256) {
460         // Counter underflow is impossible as _burnCounter cannot be incremented
461         // more than `_currentIndex - _startTokenId()` times.
462         unchecked {
463             return _currentIndex - _burnCounter - _startTokenId();
464         }
465     }
466 
467     /**
468      * @dev Returns the total amount of tokens minted in the contract.
469      */
470     function _totalMinted() internal view virtual returns (uint256) {
471         // Counter underflow is impossible as `_currentIndex` does not decrement,
472         // and it is initialized to `_startTokenId()`.
473         unchecked {
474             return _currentIndex - _startTokenId();
475         }
476     }
477 
478     /**
479      * @dev Returns the total number of tokens burned.
480      */
481     function _totalBurned() internal view virtual returns (uint256) {
482         return _burnCounter;
483     }
484 
485     // =============================================================
486     //                    ADDRESS DATA OPERATIONS
487     // =============================================================
488 
489     /**
490      * @dev Returns the number of tokens in `owner`'s account.
491      */
492     function balanceOf(address owner) public view virtual override returns (uint256) {
493         if (owner == address(0)) revert BalanceQueryForZeroAddress();
494         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
495     }
496 
497     /**
498      * Returns the number of tokens minted by `owner`.
499      */
500     function _numberMinted(address owner) internal view returns (uint256) {
501         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
502     }
503 
504     /**
505      * Returns the number of tokens burned by or on behalf of `owner`.
506      */
507     function _numberBurned(address owner) internal view returns (uint256) {
508         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
509     }
510 
511     /**
512      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
513      */
514     function _getAux(address owner) internal view returns (uint64) {
515         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
516     }
517 
518     /**
519      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
520      * If there are multiple variables, please pack them into a uint64.
521      */
522     function _setAux(address owner, uint64 aux) internal virtual {
523         uint256 packed = _packedAddressData[owner];
524         uint256 auxCasted;
525         // Cast `aux` with assembly to avoid redundant masking.
526         assembly {
527             auxCasted := aux
528         }
529         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
530         _packedAddressData[owner] = packed;
531     }
532 
533     // =============================================================
534     //                            IERC165
535     // =============================================================
536 
537     /**
538      * @dev Returns true if this contract implements the interface defined by
539      * `interfaceId`. See the corresponding
540      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
541      * to learn more about how these ids are created.
542      *
543      * This function call must use less than 30000 gas.
544      */
545     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546         // The interface IDs are constants representing the first 4 bytes
547         // of the XOR of all function selectors in the interface.
548         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
549         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
550         return
551             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
552             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
553             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
554     }
555 
556     // =============================================================
557     //                        IERC721Metadata
558     // =============================================================
559 
560     /**
561      * @dev Returns the token collection name.
562      */
563     function name() public view virtual override returns (string memory) {
564         return _name;
565     }
566 
567     /**
568      * @dev Returns the token collection symbol.
569      */
570     function symbol() public view virtual override returns (string memory) {
571         return _symbol;
572     }
573 
574     /**
575      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
576      */
577     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
578         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
579 
580         string memory baseURI = _baseURI();
581         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
582     }
583 
584     /**
585      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
586      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
587      * by default, it can be overridden in child contracts.
588      */
589     function _baseURI() internal view virtual returns (string memory) {
590         return '';
591     }
592 
593     // =============================================================
594     //                     OWNERSHIPS OPERATIONS
595     // =============================================================
596 
597     /**
598      * @dev Returns the owner of the `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
605         return address(uint160(_packedOwnershipOf(tokenId)));
606     }
607 
608     /**
609      * @dev Gas spent here starts off proportional to the maximum mint batch size.
610      * It gradually moves to O(1) as tokens get transferred around over time.
611      */
612     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
613         return _unpackedOwnership(_packedOwnershipOf(tokenId));
614     }
615 
616     /**
617      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
618      */
619     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
620         return _unpackedOwnership(_packedOwnerships[index]);
621     }
622 
623     /**
624      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
625      */
626     function _initializeOwnershipAt(uint256 index) internal virtual {
627         if (_packedOwnerships[index] == 0) {
628             _packedOwnerships[index] = _packedOwnershipOf(index);
629         }
630     }
631 
632     /**
633      * Returns the packed ownership data of `tokenId`.
634      */
635     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
636         if (_startTokenId() <= tokenId) {
637             packed = _packedOwnerships[tokenId];
638             // If not burned.
639             if (packed & _BITMASK_BURNED == 0) {
640                 // If the data at the starting slot does not exist, start the scan.
641                 if (packed == 0) {
642                     if (tokenId >= _currentIndex) revert OwnerQueryForNonexistentToken();
643                     // Invariant:
644                     // There will always be an initialized ownership slot
645                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
646                     // before an unintialized ownership slot
647                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
648                     // Hence, `tokenId` will not underflow.
649                     //
650                     // We can directly compare the packed value.
651                     // If the address is zero, packed will be zero.
652                     for (;;) {
653                         unchecked {
654                             packed = _packedOwnerships[--tokenId];
655                         }
656                         if (packed == 0) continue;
657                         return packed;
658                     }
659                 }
660                 // Otherwise, the data exists and is not burned. We can skip the scan.
661                 // This is possible because we have already achieved the target condition.
662                 // This saves 2143 gas on transfers of initialized tokens.
663                 return packed;
664             }
665         }
666         revert OwnerQueryForNonexistentToken();
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
725         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
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
742         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
743         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
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
762     function _exists(uint256 tokenId) internal view virtual returns (bool) {
763         return
764             _startTokenId() <= tokenId &&
765             tokenId < _currentIndex && // If within bounds,
766             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
767     }
768 
769     /**
770      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
771      */
772     function _isSenderApprovedOrOwner(
773         address approvedAddress,
774         address owner,
775         address msgSender
776     ) private pure returns (bool result) {
777         assembly {
778             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
779             owner := and(owner, _BITMASK_ADDRESS)
780             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
781             msgSender := and(msgSender, _BITMASK_ADDRESS)
782             // `msgSender == owner || msgSender == approvedAddress`.
783             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
784         }
785     }
786 
787     /**
788      * @dev Returns the storage slot and value for the approved address of `tokenId`.
789      */
790     function _getApprovedSlotAndAddress(uint256 tokenId)
791         private
792         view
793         returns (uint256 approvedAddressSlot, address approvedAddress)
794     {
795         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
796         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
797         assembly {
798             approvedAddressSlot := tokenApproval.slot
799             approvedAddress := sload(approvedAddressSlot)
800         }
801     }
802 
803     // =============================================================
804     //                      TRANSFER OPERATIONS
805     // =============================================================
806 
807     /**
808      * @dev Transfers `tokenId` from `from` to `to`.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      * - If the caller is not `from`, it must be approved to move this token
816      * by either {approve} or {setApprovalForAll}.
817      *
818      * Emits a {Transfer} event.
819      */
820     function transferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) public payable virtual override {
825         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
826 
827         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
828 
829         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
830 
831         // The nested ifs save around 20+ gas over a compound boolean condition.
832         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
833             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
834 
835         if (to == address(0)) revert TransferToZeroAddress();
836 
837         _beforeTokenTransfers(from, to, tokenId, 1);
838 
839         // Clear approvals from the previous owner.
840         assembly {
841             if approvedAddress {
842                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
843                 sstore(approvedAddressSlot, 0)
844             }
845         }
846 
847         // Underflow of the sender's balance is impossible because we check for
848         // ownership above and the recipient's balance can't realistically overflow.
849         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
850         unchecked {
851             // We can directly increment and decrement the balances.
852             --_packedAddressData[from]; // Updates: `balance -= 1`.
853             ++_packedAddressData[to]; // Updates: `balance += 1`.
854 
855             // Updates:
856             // - `address` to the next owner.
857             // - `startTimestamp` to the timestamp of transfering.
858             // - `burned` to `false`.
859             // - `nextInitialized` to `true`.
860             _packedOwnerships[tokenId] = _packOwnershipData(
861                 to,
862                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
863             );
864 
865             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
866             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
867                 uint256 nextTokenId = tokenId + 1;
868                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
869                 if (_packedOwnerships[nextTokenId] == 0) {
870                     // If the next slot is within bounds.
871                     if (nextTokenId != _currentIndex) {
872                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
873                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
874                     }
875                 }
876             }
877         }
878 
879         emit Transfer(from, to, tokenId);
880         _afterTokenTransfers(from, to, tokenId, 1);
881     }
882 
883 
884     
885 
886     /**
887      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId
893     ) public payable virtual override {
894         safeTransferFrom(from, to, tokenId, '');
895     }
896 
897     /**
898      * @dev Safely transfers `tokenId` token from `from` to `to`.
899      *
900      * Requirements:
901      *
902      * - `from` cannot be the zero address.
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must exist and be owned by `from`.
905      * - If the caller is not `from`, it must be approved to move this token
906      * by either {approve} or {setApprovalForAll}.
907      * - If `to` refers to a smart contract, it must implement
908      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
909      *
910      * Emits a {Transfer} event.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) public payable virtual override {
918         transferFrom(from, to, tokenId);
919         if (to.code.length != 0)
920             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
921                 revert TransferToNonERC721ReceiverImplementer();
922             }
923     }
924 
925     /**
926      * @dev Hook that is called before a set of serially-ordered token IDs
927      * are about to be transferred. This includes minting.
928      * And also called before burning one token.
929      *
930      * `startTokenId` - the first token ID to be transferred.
931      * `quantity` - the amount to be transferred.
932      *
933      * Calling conditions:
934      *
935      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
936      * transferred to `to`.
937      * - When `from` is zero, `tokenId` will be minted for `to`.
938      * - When `to` is zero, `tokenId` will be burned by `from`.
939      * - `from` and `to` are never both zero.
940      */
941     function _beforeTokenTransfers(
942         address from,
943         address to,
944         uint256 startTokenId,
945         uint256 quantity
946     ) internal virtual {}
947 
948     /**
949      * @dev Hook that is called after a set of serially-ordered token IDs
950      * have been transferred. This includes minting.
951      * And also called after one token has been burned.
952      *
953      * `startTokenId` - the first token ID to be transferred.
954      * `quantity` - the amount to be transferred.
955      *
956      * Calling conditions:
957      *
958      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
959      * transferred to `to`.
960      * - When `from` is zero, `tokenId` has been minted for `to`.
961      * - When `to` is zero, `tokenId` has been burned by `from`.
962      * - `from` and `to` are never both zero.
963      */
964     function _afterTokenTransfers(
965         address from,
966         address to,
967         uint256 startTokenId,
968         uint256 quantity
969     ) internal virtual {}
970 
971     /**
972      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
973      *
974      * `from` - Previous owner of the given token ID.
975      * `to` - Target address that will receive the token.
976      * `tokenId` - Token ID to be transferred.
977      * `_data` - Optional data to send along with the call.
978      *
979      * Returns whether the call correctly returned the expected magic value.
980      */
981     function _checkContractOnERC721Received(
982         address from,
983         address to,
984         uint256 tokenId,
985         bytes memory _data
986     ) private returns (bool) {
987         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
988             bytes4 retval
989         ) {
990             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
991         } catch (bytes memory reason) {
992             if (reason.length == 0) {
993                 revert TransferToNonERC721ReceiverImplementer();
994             } else {
995                 assembly {
996                     revert(add(32, reason), mload(reason))
997                 }
998             }
999         }
1000     }
1001 
1002     // =============================================================
1003     //                        MINT OPERATIONS
1004     // =============================================================
1005 
1006     /**
1007      * @dev Mints `quantity` tokens and transfers them to `to`.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      * - `quantity` must be greater than 0.
1013      *
1014      * Emits a {Transfer} event for each mint.
1015      */
1016     function _mint(address to, uint256 quantity) internal virtual {
1017         uint256 startTokenId = _currentIndex;
1018         if (quantity == 0) revert MintZeroQuantity();
1019 
1020         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1021 
1022         // Overflows are incredibly unrealistic.
1023         // `balance` and `numberMinted` have a maximum limit of 2**64.
1024         // `tokenId` has a maximum limit of 2**256.
1025         unchecked {
1026             // Updates:
1027             // - `balance += quantity`.
1028             // - `numberMinted += quantity`.
1029             //
1030             // We can directly add to the `balance` and `numberMinted`.
1031             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1032 
1033             // Updates:
1034             // - `address` to the owner.
1035             // - `startTimestamp` to the timestamp of minting.
1036             // - `burned` to `false`.
1037             // - `nextInitialized` to `quantity == 1`.
1038             _packedOwnerships[startTokenId] = _packOwnershipData(
1039                 to,
1040                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1041             );
1042 
1043             uint256 toMasked;
1044             uint256 end = startTokenId + quantity;
1045 
1046             // Use assembly to loop and emit the `Transfer` event for gas savings.
1047             // The duplicated `log4` removes an extra check and reduces stack juggling.
1048             // The assembly, together with the surrounding Solidity code, have been
1049             // delicately arranged to nudge the compiler into producing optimized opcodes.
1050             assembly {
1051                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1052                 toMasked := and(to, _BITMASK_ADDRESS)
1053                 // Emit the `Transfer` event.
1054                 log4(
1055                     0, // Start of data (0, since no data).
1056                     0, // End of data (0, since no data).
1057                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1058                     0, // `address(0)`.
1059                     toMasked, // `to`.
1060                     startTokenId // `tokenId`.
1061                 )
1062 
1063                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1064                 // that overflows uint256 will make the loop run out of gas.
1065                 // The compiler will optimize the `iszero` away for performance.
1066                 for {
1067                     let tokenId := add(startTokenId, 1)
1068                 } iszero(eq(tokenId, end)) {
1069                     tokenId := add(tokenId, 1)
1070                 } {
1071                     // Emit the `Transfer` event. Similar to above.
1072                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1073                 }
1074             }
1075             if (toMasked == 0) revert MintToZeroAddress();
1076 
1077             _currentIndex = end;
1078         }
1079         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1080     }
1081 
1082     /**
1083      * @dev Mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * This function is intended for efficient minting only during contract creation.
1086      *
1087      * It emits only one {ConsecutiveTransfer} as defined in
1088      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1089      * instead of a sequence of {Transfer} event(s).
1090      *
1091      * Calling this function outside of contract creation WILL make your contract
1092      * non-compliant with the ERC721 standard.
1093      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1094      * {ConsecutiveTransfer} event is only permissible during contract creation.
1095      *
1096      * Requirements:
1097      *
1098      * - `to` cannot be the zero address.
1099      * - `quantity` must be greater than 0.
1100      *
1101      * Emits a {ConsecutiveTransfer} event.
1102      */
1103     function _mintERC2309(address to, uint256 quantity) internal virtual {
1104         uint256 startTokenId = _currentIndex;
1105         if (to == address(0)) revert MintToZeroAddress();
1106         if (quantity == 0) revert MintZeroQuantity();
1107         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1108 
1109         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1110 
1111         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1112         unchecked {
1113             // Updates:
1114             // - `balance += quantity`.
1115             // - `numberMinted += quantity`.
1116             //
1117             // We can directly add to the `balance` and `numberMinted`.
1118             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1119 
1120             // Updates:
1121             // - `address` to the owner.
1122             // - `startTimestamp` to the timestamp of minting.
1123             // - `burned` to `false`.
1124             // - `nextInitialized` to `quantity == 1`.
1125             _packedOwnerships[startTokenId] = _packOwnershipData(
1126                 to,
1127                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1128             );
1129 
1130             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1131 
1132             _currentIndex = startTokenId + quantity;
1133         }
1134         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1135     }
1136 
1137     /**
1138      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - If `to` refers to a smart contract, it must implement
1143      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1144      * - `quantity` must be greater than 0.
1145      *
1146      * See {_mint}.
1147      *
1148      * Emits a {Transfer} event for each mint.
1149      */
1150     function _safeMint(
1151         address to,
1152         uint256 quantity,
1153         bytes memory _data
1154     ) internal virtual {
1155         _mint(to, quantity);
1156 
1157         unchecked {
1158             if (to.code.length != 0) {
1159                 uint256 end = _currentIndex;
1160                 uint256 index = end - quantity;
1161                 do {
1162                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1163                         revert TransferToNonERC721ReceiverImplementer();
1164                     }
1165                 } while (index < end);
1166                 // Reentrancy protection.
1167                 if (_currentIndex != end) revert();
1168             }
1169         }
1170     }
1171 
1172     /**
1173      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1174      */
1175     function _safeMint(address to, uint256 quantity) internal virtual {
1176         _safeMint(to, quantity, '');
1177     }
1178 
1179     // =============================================================
1180     //                       APPROVAL OPERATIONS
1181     // =============================================================
1182 
1183     /**
1184      * @dev Equivalent to `_approve(to, tokenId, false)`.
1185      */
1186     function _approve(address to, uint256 tokenId) internal virtual {
1187         _approve(to, tokenId, false);
1188     }
1189 
1190     /**
1191      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1192      * The approval is cleared when the token is transferred.
1193      *
1194      * Only a single account can be approved at a time, so approving the
1195      * zero address clears previous approvals.
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must exist.
1200      *
1201      * Emits an {Approval} event.
1202      */
1203     function _approve(
1204         address to,
1205         uint256 tokenId,
1206         bool approvalCheck
1207     ) internal virtual {
1208         address owner = ownerOf(tokenId);
1209 
1210         if (approvalCheck)
1211             if (_msgSenderERC721A() != owner)
1212                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1213                     revert ApprovalCallerNotOwnerNorApproved();
1214                 }
1215 
1216         _tokenApprovals[tokenId].value = to;
1217         emit Approval(owner, to, tokenId);
1218     }
1219 
1220     // =============================================================
1221     //                        BURN OPERATIONS
1222     // =============================================================
1223 
1224     /**
1225      * @dev Equivalent to `_burn(tokenId, false)`.
1226      */
1227     function _burn(uint256 tokenId) internal virtual {
1228         _burn(tokenId, false);
1229     }
1230 
1231     /**
1232      * @dev Destroys `tokenId`.
1233      * The approval is cleared when the token is burned.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1242         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1243 
1244         address from = address(uint160(prevOwnershipPacked));
1245 
1246         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1247 
1248         if (approvalCheck) {
1249             // The nested ifs save around 20+ gas over a compound boolean condition.
1250             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1251                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1252         }
1253 
1254         _beforeTokenTransfers(from, address(0), tokenId, 1);
1255 
1256         // Clear approvals from the previous owner.
1257         assembly {
1258             if approvedAddress {
1259                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1260                 sstore(approvedAddressSlot, 0)
1261             }
1262         }
1263 
1264         // Underflow of the sender's balance is impossible because we check for
1265         // ownership above and the recipient's balance can't realistically overflow.
1266         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1267         unchecked {
1268             // Updates:
1269             // - `balance -= 1`.
1270             // - `numberBurned += 1`.
1271             //
1272             // We can directly decrement the balance, and increment the number burned.
1273             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1274             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1275 
1276             // Updates:
1277             // - `address` to the last owner.
1278             // - `startTimestamp` to the timestamp of burning.
1279             // - `burned` to `true`.
1280             // - `nextInitialized` to `true`.
1281             _packedOwnerships[tokenId] = _packOwnershipData(
1282                 from,
1283                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1284             );
1285 
1286             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1287             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1288                 uint256 nextTokenId = tokenId + 1;
1289                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1290                 if (_packedOwnerships[nextTokenId] == 0) {
1291                     // If the next slot is within bounds.
1292                     if (nextTokenId != _currentIndex) {
1293                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1294                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1295                     }
1296                 }
1297             }
1298         }
1299 
1300         emit Transfer(from, address(0), tokenId);
1301         _afterTokenTransfers(from, address(0), tokenId, 1);
1302 
1303         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1304         unchecked {
1305             _burnCounter++;
1306         }
1307     }
1308 
1309     // =============================================================
1310     //                     EXTRA DATA OPERATIONS
1311     // =============================================================
1312 
1313     /**
1314      * @dev Directly sets the extra data for the ownership data `index`.
1315      */
1316     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1317         uint256 packed = _packedOwnerships[index];
1318         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1319         uint256 extraDataCasted;
1320         // Cast `extraData` with assembly to avoid redundant masking.
1321         assembly {
1322             extraDataCasted := extraData
1323         }
1324         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1325         _packedOwnerships[index] = packed;
1326     }
1327 
1328     /**
1329      * @dev Called during each token transfer to set the 24bit `extraData` field.
1330      * Intended to be overridden by the cosumer contract.
1331      *
1332      * `previousExtraData` - the value of `extraData` before transfer.
1333      *
1334      * Calling conditions:
1335      *
1336      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1337      * transferred to `to`.
1338      * - When `from` is zero, `tokenId` will be minted for `to`.
1339      * - When `to` is zero, `tokenId` will be burned by `from`.
1340      * - `from` and `to` are never both zero.
1341      */
1342     function _extraData(
1343         address from,
1344         address to,
1345         uint24 previousExtraData
1346     ) internal view virtual returns (uint24) {}
1347 
1348     /**
1349      * @dev Returns the next extra data for the packed ownership data.
1350      * The returned result is shifted into position.
1351      */
1352     function _nextExtraData(
1353         address from,
1354         address to,
1355         uint256 prevOwnershipPacked
1356     ) private view returns (uint256) {
1357         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1358         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1359     }
1360 
1361     // =============================================================
1362     //                       OTHER OPERATIONS
1363     // =============================================================
1364 
1365     /**
1366      * @dev Returns the message sender (defaults to `msg.sender`).
1367      *
1368      * If you are writing GSN compatible contracts, you need to override this function.
1369      */
1370     function _msgSenderERC721A() internal view virtual returns (address) {
1371         return msg.sender;
1372     }
1373 
1374     /**
1375      * @dev Converts a uint256 to its ASCII string decimal representation.
1376      */
1377     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1378         assembly {
1379             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1380             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1381             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1382             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1383             let m := add(mload(0x40), 0xa0)
1384             // Update the free memory pointer to allocate.
1385             mstore(0x40, m)
1386             // Assign the `str` to the end.
1387             str := sub(m, 0x20)
1388             // Zeroize the slot after the string.
1389             mstore(str, 0)
1390 
1391             // Cache the end of the memory to calculate the length later.
1392             let end := str
1393 
1394             // We write the string from rightmost digit to leftmost digit.
1395             // The following is essentially a do-while loop that also handles the zero case.
1396             // prettier-ignore
1397             for { let temp := value } 1 {} {
1398                 str := sub(str, 1)
1399                 // Write the character to the pointer.
1400                 // The ASCII index of the '0' character is 48.
1401                 mstore8(str, add(48, mod(temp, 10)))
1402                 // Keep dividing `temp` until zero.
1403                 temp := div(temp, 10)
1404                 // prettier-ignore
1405                 if iszero(temp) { break }
1406             }
1407 
1408             let length := sub(end, str)
1409             // Move the pointer 32 bytes leftwards to make room for the length.
1410             str := sub(str, 0x20)
1411             // Store the length.
1412             mstore(str, length)
1413         }
1414     }
1415 }
1416 
1417 // File: contracts\OpenseaStandard\IOperatorFilterRegistry.sol
1418 
1419 
1420 pragma solidity ^0.8.13;
1421 
1422 interface IOperatorFilterRegistry {
1423     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1424     function register(address registrant) external;
1425     function registerAndSubscribe(address registrant, address subscription) external;
1426     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1427     function unregister(address addr) external;
1428     function updateOperator(address registrant, address operator, bool filtered) external;
1429     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1430     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1431     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1432     function subscribe(address registrant, address registrantToSubscribe) external;
1433     function unsubscribe(address registrant, bool copyExistingEntries) external;
1434     function subscriptionOf(address addr) external returns (address registrant);
1435     function subscribers(address registrant) external returns (address[] memory);
1436     function subscriberAt(address registrant, uint256 index) external returns (address);
1437     function copyEntriesOf(address registrant, address registrantToCopy) external;
1438     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1439     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1440     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1441     function filteredOperators(address addr) external returns (address[] memory);
1442     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1443     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1444     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1445     function isRegistered(address addr) external returns (bool);
1446     function codeHashOf(address addr) external returns (bytes32);
1447 }
1448 
1449 // File: contracts\OpenseaStandard\OperatorFilterer.sol
1450 
1451 
1452 pragma solidity ^0.8.13;
1453 
1454 /**
1455  * @title  OperatorFilterer
1456  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1457  *         registrant's entries in the OperatorFilterRegistry.
1458  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1459  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1460  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1461  */
1462 abstract contract OperatorFilterer {
1463     error OperatorNotAllowed(address operator);
1464 
1465     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1466         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1467 
1468     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1469         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1470         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1471         // order for the modifier to filter addresses.
1472         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1473             if (subscribe) {
1474                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1475             } else {
1476                 if (subscriptionOrRegistrantToCopy != address(0)) {
1477                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1478                 } else {
1479                     OPERATOR_FILTER_REGISTRY.register(address(this));
1480                 }
1481             }
1482         }
1483     }
1484 
1485     modifier onlyAllowedOperator(address from) virtual {
1486         // Check registry code length to facilitate testing in environments without a deployed registry.
1487         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1488             // Allow spending tokens from addresses with balance
1489             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1490             // from an EOA.
1491             if (from == msg.sender) {
1492                 _;
1493                 return;
1494             }
1495             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1496                 revert OperatorNotAllowed(msg.sender);
1497             }
1498         }
1499         _;
1500     }
1501 
1502     modifier onlyAllowedOperatorApproval(address operator) virtual {
1503         // Check registry code length to facilitate testing in environments without a deployed registry.
1504         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1505             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1506                 revert OperatorNotAllowed(operator);
1507             }
1508         }
1509         _;
1510     }
1511 }
1512 
1513 // File: contracts\OpenseaStandard\DefaultOperatorFilterer.sol
1514 
1515 
1516 pragma solidity ^0.8.13;
1517 
1518 /**
1519  * @title  DefaultOperatorFilterer
1520  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1521  */
1522 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1523     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1524 
1525     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1526 }
1527 
1528 // File: contracts\CollectionProxy\CollectionStorage.sol
1529 
1530 pragma solidity ^0.8.13;
1531 
1532 contract CollectionStorage {
1533 
1534 // Counters.Counter tokenIds;
1535 string public baseURI;
1536 mapping(address => bool) public _allowAddress;
1537 
1538 
1539  mapping(uint256 => bytes32) internal whiteListRoot;
1540 
1541  uint256 internal MaxSupply;
1542 
1543  uint256 public status;
1544 
1545  uint256 internal mainPrice;
1546 
1547  address internal seller;
1548 
1549  uint256 internal royalty;
1550 
1551  mapping(uint256 => uint256) public supplyPerRarity;
1552  mapping(uint256 => uint256) public mintedPerRarity;
1553 
1554  uint256 internal seed;
1555 
1556  
1557 
1558  mapping(uint256 => uint256)public tokenRarity; 
1559 
1560  uint256[] rarity;
1561 
1562  struct SaleDetail {
1563     uint256 startTime;
1564     uint256 endTime;
1565     uint256 price;
1566  }
1567 
1568  mapping (uint256=>SaleDetail) internal _saleDetails;
1569  mapping(address => mapping(uint256 => uint256)) internal userBought;
1570  mapping(uint256 => bool) internal isReserveWhitelist;
1571 
1572 }
1573 
1574 // File: @openzeppelin\contracts\utils\Context.sol
1575 
1576 
1577 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1578 
1579 pragma solidity ^0.8.0;
1580 
1581 /**
1582  * @dev Provides information about the current execution context, including the
1583  * sender of the transaction and its data. While these are generally available
1584  * via msg.sender and msg.data, they should not be accessed in such a direct
1585  * manner, since when dealing with meta-transactions the account sending and
1586  * paying for execution may not be the actual sender (as far as an application
1587  * is concerned).
1588  *
1589  * This contract is only required for intermediate, library-like contracts.
1590  */
1591 abstract contract Context {
1592     function _msgSender() internal view virtual returns (address) {
1593         return msg.sender;
1594     }
1595 
1596     function _msgData() internal view virtual returns (bytes calldata) {
1597         return msg.data;
1598     }
1599 }
1600 
1601 // File: contracts\CollectionProxy\Ownable.sol
1602 
1603 
1604 
1605 pragma solidity ^0.8.0;
1606 /**
1607  * @dev Contract module which provides a basic access control mechanism, where
1608  * there is an account (an owner) that can be granted exclusive access to
1609  * specific functions.
1610  *
1611  * By default, the owner account will be the one that deploys the contract. This
1612  * can later be changed with {transferOwnership}.
1613  *
1614  * This module is used through inheritance. It will make available the modifier
1615  * `onlyOwner`, which can be applied to your functions to restrict their use to
1616  * the owner.
1617  */
1618 abstract contract Ownable is Context {
1619     address private _owner;
1620 
1621     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1622 
1623     /**
1624      * @dev Initializes the contract setting the deployer as the initial owner.
1625      */
1626     constructor() {
1627         _setOwner(_msgSender());
1628     }
1629 
1630     /**
1631      * @dev Returns the address of the current owner.
1632      */
1633     function owner() public view virtual returns (address) {
1634         return _owner;
1635     }
1636 
1637     /**
1638      * @dev Throws if called by any account other than the owner.
1639      */
1640     modifier onlyOwner() {
1641         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1642         _;
1643     }
1644 
1645     /**
1646      * @dev Leaves the contract without owner. It will not be possible to call
1647      * `onlyOwner` functions anymore. Can only be called by the current owner.
1648      *
1649      * NOTE: Renouncing ownership will leave the contract without an owner,
1650      * thereby removing any functionality that is only available to the owner.
1651      */
1652     function renounceOwnership() public virtual onlyOwner {
1653         _setOwner(address(0));
1654     }
1655 
1656     /**
1657      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1658      * Can only be called by the current owner.
1659      */
1660     function transferOwnership(address newOwner) public virtual onlyOwner {
1661         require(newOwner != address(0), "Ownable: new owner is the zero address");
1662         _setOwner(newOwner);
1663     }
1664 
1665     function _setOwner(address newOwner) internal {
1666         address oldOwner = _owner;
1667         _owner = newOwner;
1668         emit OwnershipTransferred(oldOwner, newOwner);
1669     }
1670 }
1671 
1672 // File: @openzeppelin\contracts\utils\Strings.sol
1673 
1674 
1675 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1676 
1677 pragma solidity ^0.8.0;
1678 
1679 /**
1680  * @dev String operations.
1681  */
1682 library Strings {
1683     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1684     uint8 private constant _ADDRESS_LENGTH = 20;
1685 
1686     /**
1687      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1688      */
1689     function toString(uint256 value) internal pure returns (string memory) {
1690         // Inspired by OraclizeAPI's implementation - MIT licence
1691         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1692 
1693         if (value == 0) {
1694             return "0";
1695         }
1696         uint256 temp = value;
1697         uint256 digits;
1698         while (temp != 0) {
1699             digits++;
1700             temp /= 10;
1701         }
1702         bytes memory buffer = new bytes(digits);
1703         while (value != 0) {
1704             digits -= 1;
1705             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1706             value /= 10;
1707         }
1708         return string(buffer);
1709     }
1710 
1711     /**
1712      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1713      */
1714     function toHexString(uint256 value) internal pure returns (string memory) {
1715         if (value == 0) {
1716             return "0x00";
1717         }
1718         uint256 temp = value;
1719         uint256 length = 0;
1720         while (temp != 0) {
1721             length++;
1722             temp >>= 8;
1723         }
1724         return toHexString(value, length);
1725     }
1726 
1727     /**
1728      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1729      */
1730     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1731         bytes memory buffer = new bytes(2 * length + 2);
1732         buffer[0] = "0";
1733         buffer[1] = "x";
1734         for (uint256 i = 2 * length + 1; i > 1; --i) {
1735             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1736             value >>= 4;
1737         }
1738         require(value == 0, "Strings: hex length insufficient");
1739         return string(buffer);
1740     }
1741 
1742     /**
1743      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1744      */
1745     function toHexString(address addr) internal pure returns (string memory) {
1746         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1747     }
1748 }
1749 
1750 // File: @openzeppelin\contracts\utils\Address.sol
1751 
1752 
1753 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1754 
1755 pragma solidity ^0.8.1;
1756 
1757 /**
1758  * @dev Collection of functions related to the address type
1759  */
1760 library Address {
1761     /**
1762      * @dev Returns true if `account` is a contract.
1763      *
1764      * [IMPORTANT]
1765      * ====
1766      * It is unsafe to assume that an address for which this function returns
1767      * false is an externally-owned account (EOA) and not a contract.
1768      *
1769      * Among others, `isContract` will return false for the following
1770      * types of addresses:
1771      *
1772      *  - an externally-owned account
1773      *  - a contract in construction
1774      *  - an address where a contract will be created
1775      *  - an address where a contract lived, but was destroyed
1776      * ====
1777      *
1778      * [IMPORTANT]
1779      * ====
1780      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1781      *
1782      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1783      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1784      * constructor.
1785      * ====
1786      */
1787     function isContract(address account) internal view returns (bool) {
1788         // This method relies on extcodesize/address.code.length, which returns 0
1789         // for contracts in construction, since the code is only stored at the end
1790         // of the constructor execution.
1791 
1792         return account.code.length > 0;
1793     }
1794 
1795     /**
1796      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1797      * `recipient`, forwarding all available gas and reverting on errors.
1798      *
1799      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1800      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1801      * imposed by `transfer`, making them unable to receive funds via
1802      * `transfer`. {sendValue} removes this limitation.
1803      *
1804      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1805      *
1806      * IMPORTANT: because control is transferred to `recipient`, care must be
1807      * taken to not create reentrancy vulnerabilities. Consider using
1808      * {ReentrancyGuard} or the
1809      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1810      */
1811     function sendValue(address payable recipient, uint256 amount) internal {
1812         require(address(this).balance >= amount, "Address: insufficient balance");
1813 
1814         (bool success, ) = recipient.call{value: amount}("");
1815         require(success, "Address: unable to send value, recipient may have reverted");
1816     }
1817 
1818     /**
1819      * @dev Performs a Solidity function call using a low level `call`. A
1820      * plain `call` is an unsafe replacement for a function call: use this
1821      * function instead.
1822      *
1823      * If `target` reverts with a revert reason, it is bubbled up by this
1824      * function (like regular Solidity function calls).
1825      *
1826      * Returns the raw returned data. To convert to the expected return value,
1827      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1828      *
1829      * Requirements:
1830      *
1831      * - `target` must be a contract.
1832      * - calling `target` with `data` must not revert.
1833      *
1834      * _Available since v3.1._
1835      */
1836     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1837         return functionCall(target, data, "Address: low-level call failed");
1838     }
1839 
1840     /**
1841      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1842      * `errorMessage` as a fallback revert reason when `target` reverts.
1843      *
1844      * _Available since v3.1._
1845      */
1846     function functionCall(
1847         address target,
1848         bytes memory data,
1849         string memory errorMessage
1850     ) internal returns (bytes memory) {
1851         return functionCallWithValue(target, data, 0, errorMessage);
1852     }
1853 
1854     /**
1855      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1856      * but also transferring `value` wei to `target`.
1857      *
1858      * Requirements:
1859      *
1860      * - the calling contract must have an ETH balance of at least `value`.
1861      * - the called Solidity function must be `payable`.
1862      *
1863      * _Available since v3.1._
1864      */
1865     function functionCallWithValue(
1866         address target,
1867         bytes memory data,
1868         uint256 value
1869     ) internal returns (bytes memory) {
1870         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1871     }
1872 
1873     /**
1874      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1875      * with `errorMessage` as a fallback revert reason when `target` reverts.
1876      *
1877      * _Available since v3.1._
1878      */
1879     function functionCallWithValue(
1880         address target,
1881         bytes memory data,
1882         uint256 value,
1883         string memory errorMessage
1884     ) internal returns (bytes memory) {
1885         require(address(this).balance >= value, "Address: insufficient balance for call");
1886         require(isContract(target), "Address: call to non-contract");
1887 
1888         (bool success, bytes memory returndata) = target.call{value: value}(data);
1889         return verifyCallResult(success, returndata, errorMessage);
1890     }
1891 
1892     /**
1893      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1894      * but performing a static call.
1895      *
1896      * _Available since v3.3._
1897      */
1898     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1899         return functionStaticCall(target, data, "Address: low-level static call failed");
1900     }
1901 
1902     /**
1903      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1904      * but performing a static call.
1905      *
1906      * _Available since v3.3._
1907      */
1908     function functionStaticCall(
1909         address target,
1910         bytes memory data,
1911         string memory errorMessage
1912     ) internal view returns (bytes memory) {
1913         require(isContract(target), "Address: static call to non-contract");
1914 
1915         (bool success, bytes memory returndata) = target.staticcall(data);
1916         return verifyCallResult(success, returndata, errorMessage);
1917     }
1918 
1919     /**
1920      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1921      * but performing a delegate call.
1922      *
1923      * _Available since v3.4._
1924      */
1925     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1926         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1927     }
1928 
1929     /**
1930      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1931      * but performing a delegate call.
1932      *
1933      * _Available since v3.4._
1934      */
1935     function functionDelegateCall(
1936         address target,
1937         bytes memory data,
1938         string memory errorMessage
1939     ) internal returns (bytes memory) {
1940         require(isContract(target), "Address: delegate call to non-contract");
1941 
1942         (bool success, bytes memory returndata) = target.delegatecall(data);
1943         return verifyCallResult(success, returndata, errorMessage);
1944     }
1945 
1946     /**
1947      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1948      * revert reason using the provided one.
1949      *
1950      * _Available since v4.3._
1951      */
1952     function verifyCallResult(
1953         bool success,
1954         bytes memory returndata,
1955         string memory errorMessage
1956     ) internal pure returns (bytes memory) {
1957         if (success) {
1958             return returndata;
1959         } else {
1960             // Look for revert reason and bubble it up if present
1961             if (returndata.length > 0) {
1962                 // The easiest way to bubble the revert reason is using memory via assembly
1963                 /// @solidity memory-safe-assembly
1964                 assembly {
1965                     let returndata_size := mload(returndata)
1966                     revert(add(32, returndata), returndata_size)
1967                 }
1968             } else {
1969                 revert(errorMessage);
1970             }
1971         }
1972     }
1973 }
1974 
1975 // File: @openzeppelin\contracts\utils\math\SafeMath.sol
1976 
1977 
1978 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1979 
1980 pragma solidity ^0.8.0;
1981 
1982 // CAUTION
1983 // This version of SafeMath should only be used with Solidity 0.8 or later,
1984 // because it relies on the compiler's built in overflow checks.
1985 
1986 /**
1987  * @dev Wrappers over Solidity's arithmetic operations.
1988  *
1989  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1990  * now has built in overflow checking.
1991  */
1992 library SafeMath {
1993     /**
1994      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1995      *
1996      * _Available since v3.4._
1997      */
1998     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1999         unchecked {
2000             uint256 c = a + b;
2001             if (c < a) return (false, 0);
2002             return (true, c);
2003         }
2004     }
2005 
2006     /**
2007      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
2008      *
2009      * _Available since v3.4._
2010      */
2011     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2012         unchecked {
2013             if (b > a) return (false, 0);
2014             return (true, a - b);
2015         }
2016     }
2017 
2018     /**
2019      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2020      *
2021      * _Available since v3.4._
2022      */
2023     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2024         unchecked {
2025             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2026             // benefit is lost if 'b' is also tested.
2027             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2028             if (a == 0) return (true, 0);
2029             uint256 c = a * b;
2030             if (c / a != b) return (false, 0);
2031             return (true, c);
2032         }
2033     }
2034 
2035     /**
2036      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2037      *
2038      * _Available since v3.4._
2039      */
2040     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2041         unchecked {
2042             if (b == 0) return (false, 0);
2043             return (true, a / b);
2044         }
2045     }
2046 
2047     /**
2048      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2049      *
2050      * _Available since v3.4._
2051      */
2052     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2053         unchecked {
2054             if (b == 0) return (false, 0);
2055             return (true, a % b);
2056         }
2057     }
2058 
2059     /**
2060      * @dev Returns the addition of two unsigned integers, reverting on
2061      * overflow.
2062      *
2063      * Counterpart to Solidity's `+` operator.
2064      *
2065      * Requirements:
2066      *
2067      * - Addition cannot overflow.
2068      */
2069     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2070         return a + b;
2071     }
2072 
2073     /**
2074      * @dev Returns the subtraction of two unsigned integers, reverting on
2075      * overflow (when the result is negative).
2076      *
2077      * Counterpart to Solidity's `-` operator.
2078      *
2079      * Requirements:
2080      *
2081      * - Subtraction cannot overflow.
2082      */
2083     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2084         return a - b;
2085     }
2086 
2087     /**
2088      * @dev Returns the multiplication of two unsigned integers, reverting on
2089      * overflow.
2090      *
2091      * Counterpart to Solidity's `*` operator.
2092      *
2093      * Requirements:
2094      *
2095      * - Multiplication cannot overflow.
2096      */
2097     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2098         return a * b;
2099     }
2100 
2101     /**
2102      * @dev Returns the integer division of two unsigned integers, reverting on
2103      * division by zero. The result is rounded towards zero.
2104      *
2105      * Counterpart to Solidity's `/` operator.
2106      *
2107      * Requirements:
2108      *
2109      * - The divisor cannot be zero.
2110      */
2111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2112         return a / b;
2113     }
2114 
2115     /**
2116      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2117      * reverting when dividing by zero.
2118      *
2119      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2120      * opcode (which leaves remaining gas untouched) while Solidity uses an
2121      * invalid opcode to revert (consuming all remaining gas).
2122      *
2123      * Requirements:
2124      *
2125      * - The divisor cannot be zero.
2126      */
2127     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2128         return a % b;
2129     }
2130 
2131     /**
2132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2133      * overflow (when the result is negative).
2134      *
2135      * CAUTION: This function is deprecated because it requires allocating memory for the error
2136      * message unnecessarily. For custom revert reasons use {trySub}.
2137      *
2138      * Counterpart to Solidity's `-` operator.
2139      *
2140      * Requirements:
2141      *
2142      * - Subtraction cannot overflow.
2143      */
2144     function sub(
2145         uint256 a,
2146         uint256 b,
2147         string memory errorMessage
2148     ) internal pure returns (uint256) {
2149         unchecked {
2150             require(b <= a, errorMessage);
2151             return a - b;
2152         }
2153     }
2154 
2155     /**
2156      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2157      * division by zero. The result is rounded towards zero.
2158      *
2159      * Counterpart to Solidity's `/` operator. Note: this function uses a
2160      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2161      * uses an invalid opcode to revert (consuming all remaining gas).
2162      *
2163      * Requirements:
2164      *
2165      * - The divisor cannot be zero.
2166      */
2167     function div(
2168         uint256 a,
2169         uint256 b,
2170         string memory errorMessage
2171     ) internal pure returns (uint256) {
2172         unchecked {
2173             require(b > 0, errorMessage);
2174             return a / b;
2175         }
2176     }
2177 
2178     /**
2179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2180      * reverting with custom message when dividing by zero.
2181      *
2182      * CAUTION: This function is deprecated because it requires allocating memory for the error
2183      * message unnecessarily. For custom revert reasons use {tryMod}.
2184      *
2185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2186      * opcode (which leaves remaining gas untouched) while Solidity uses an
2187      * invalid opcode to revert (consuming all remaining gas).
2188      *
2189      * Requirements:
2190      *
2191      * - The divisor cannot be zero.
2192      */
2193     function mod(
2194         uint256 a,
2195         uint256 b,
2196         string memory errorMessage
2197     ) internal pure returns (uint256) {
2198         unchecked {
2199             require(b > 0, errorMessage);
2200             return a % b;
2201         }
2202     }
2203 }
2204 
2205 // File: contracts\MerkleProof.sol
2206 
2207 
2208 
2209 pragma solidity ^0.8.13;
2210 
2211 library MerkleProof {
2212     
2213     function verify(
2214         bytes32[] memory proof,
2215         bytes32 root,
2216         bytes32 leaf
2217     ) internal pure returns (bool) {
2218         return processProof(proof, leaf) == root;
2219     }
2220 
2221     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2222         bytes32 computedHash = leaf;
2223         for (uint256 i = 0; i < proof.length; i++) {
2224             bytes32 proofElement = proof[i];
2225             if (computedHash <= proofElement) {
2226                 // Hash(current computed hash + current element of the proof)
2227                 computedHash = _efficientHash(computedHash, proofElement);
2228             } else {
2229                 // Hash(current element of the proof + current computed hash)
2230                 computedHash = _efficientHash(proofElement, computedHash);
2231             }
2232         }
2233         return computedHash;
2234     }
2235 
2236     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2237         assembly {
2238             mstore(0x00, a)
2239             mstore(0x20, b)
2240             value := keccak256(0x00, 0x40)
2241         }
2242     }
2243 }
2244 
2245 // File: contracts\Collection.sol
2246 
2247 
2248 pragma solidity ^0.8.13;
2249 /**
2250 > Collection
2251 @notice this contract is standard ERC721 to used as xanalia user's collection managing his NFTs
2252  */
2253 contract Collection is ERC721A, DefaultOperatorFilterer, Ownable, CollectionStorage{
2254 using Strings for uint256;
2255 using SafeMath for uint256;
2256 using Address for address;
2257 using Strings for address;
2258 
2259 
2260   constructor() ERC721A("DEEMO THE MOVIE NFT", "DEEMO")   {
2261     _setOwner(msg.sender);
2262     _allowAddress[msg.sender] = true;
2263     setAuthor(0x0A48Bc1E082e6f923f9A5b1C044c1780DD2A8821);
2264     setTransferAllowed(msg.sender, true);
2265     setWhitelistRoot(0xaaf83cc9f706b3a917bb1d952f10234215acfc29e118ceb18a935081f0bda7f1, 2,true);
2266     baseURI = "https://testapi.xanalia.com/xanalia/get-nft-meta?tokenId=";
2267   
2268   }
2269 modifier isValid() {
2270   require(_allowAddress[msg.sender], "not authorize");
2271   _;
2272 }
2273 
2274  mapping(address => bool) public isTransferAllowed;
2275     mapping(uint256 => bool) public nftLock;
2276 
2277      modifier  onlyTransferAllowed(address from) {
2278         require(isTransferAllowed[from],"ERC721: transfer not allowed");
2279         _;
2280     }
2281 
2282      modifier  isNFTLock(uint256 tokenId) {
2283         require(!nftLock[tokenId],"ERC721: NFT is locked");
2284         _;
2285     }
2286 
2287      function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2288         require(isTransferAllowed[operator],"ERC721: transfer not allowed");
2289         super.setApprovalForAll(operator, approved);
2290     }
2291 
2292     function approve(address operator, uint256 tokenId) public payable  override onlyAllowedOperatorApproval(operator) {
2293         require(isTransferAllowed[operator],"ERC721: transfer not allowed");
2294         super.approve(operator, tokenId);
2295     }
2296 
2297     
2298 
2299 
2300      // OpenSea Enforcer functions
2301     function transferFrom(address from, address to, uint256 tokenId) public payable override  onlyAllowedOperator(from) {
2302         require(isTransferAllowed[msg.sender],"ERC721: transfer not allowed");
2303         require(!nftLock[tokenId],"ERC721: NFT is locked");
2304         super.transferFrom(from, to, tokenId);
2305     }
2306 
2307     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override   onlyAllowedOperator(from) {
2308         require(isTransferAllowed[msg.sender],"ERC721: transfer not allowed");
2309         require(!nftLock[tokenId],"ERC721: NFT is locked");
2310         super.safeTransferFrom(from, to, tokenId);
2311     }
2312 
2313     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
2314         require(isTransferAllowed[msg.sender],"ERC721: transfer not allowed");
2315         require(!nftLock[tokenId],"ERC721: NFT is locked");
2316         super.safeTransferFrom(from, to, tokenId, data);
2317     }
2318 
2319 
2320 
2321 function getUserBoughtCount( address _add, uint256 whitelistType) public view returns(uint256) {
2322   return userBought[_add][whitelistType];
2323 }
2324 function isWhitelisted(address account, bytes32[] calldata proof, uint256 quantity, uint256 whiteListType) public view returns (bool) {
2325         return _verify(_leaf(account, quantity), proof, whiteListRoot[whiteListType]);
2326     }
2327     function _leaf(address account, uint256 quantity) public pure returns (bytes32) {
2328         return keccak256(abi.encode(account, quantity));
2329     }
2330     function _verify(bytes32 leaf,bytes32[] memory proof,bytes32 root) internal pure returns (bool) {
2331         return MerkleProof.verify(proof, root, leaf);
2332     }
2333 
2334     /**
2335 @notice function resposible of minting new NFTs of the collection.
2336  @param to_ address of account to whom newely created NFT's ownership to be passed
2337  @param countNFTs_ URI of newely created NFT
2338  Note only owner can mint NFT
2339  */
2340   function mint(address to_, uint256 countNFTs_) isValid() public returns(uint256, uint256) {
2341     require(MaxSupply >= totalSupply()+ countNFTs_, "exceeding supply");
2342     uint256 start = _currentIndex;
2343      _safeMint(to_, countNFTs_);
2344     uint256 end = _currentIndex - 1;
2345       uint256 rand;
2346     uint256 percentageRare = supplyPerRarity[2].mul(100).div(MaxSupply);
2347     for (uint256 index = start; index <= end; index++) {
2348         if(supplyPerRarity[1] <= mintedPerRarity[1] + 1){
2349           rand = 2;
2350           
2351         } else if (supplyPerRarity[2] <= mintedPerRarity[2] + 1 ){
2352           rand = 1;
2353         }else {
2354           rand = uint256(keccak256(abi.encode(seed + countNFTs_ + totalSupply(),seed + index, block.timestamp,tx.origin, owner()))) % 100;
2355           if(percentageRare >= rand){
2356             rand = 1;
2357           }else {
2358             rand = 2;
2359           }
2360         }
2361         mintedPerRarity[rand]++;
2362         tokenRarity[index] = rand;
2363         rarity.push(rand);
2364        }
2365     emit Mint(start, end, countNFTs_, to_, rarity);
2366     delete rarity;
2367     return (start, end);
2368   }
2369 
2370   function setSeed(uint256 _seed) onlyOwner public {
2371     seed = _seed;
2372   }
2373  
2374 
2375    
2376 
2377   function preOrderDeemoNFT(bytes32[] calldata proof, uint256 limit)  payable external {
2378     require(msg.sender == tx.origin, "101");
2379     uint256 whiteListType = 2;
2380     require(_saleDetails[whiteListType].startTime <= block.timestamp, "sale not started yet");
2381     require(_saleDetails[whiteListType].endTime > block.timestamp, "sale has ended");
2382     uint256 quantity =  getUserBoughtCount(msg.sender,whiteListType) + limit;
2383     require(isWhitelisted(msg.sender, proof, quantity,whiteListType), "not authorize");
2384     require(MaxSupply >=   mintedPerRarity[4], "soldout");
2385     uint256 depositAmount = msg.value;
2386     uint256 price = mainPrice;
2387     price = price * limit;
2388     require(price <= depositAmount, "NFT 108");
2389     mintedPerRarity[4]+=limit;
2390     (bool success,) = payable(seller).call{value: price}("");
2391     if(!success) revert("unable to receive eth");
2392     if(depositAmount - price > 0) {
2393         ( success,) = payable(msg.sender).call{value: (depositAmount - price)}("");
2394         if(!success) revert("unable to send eth");
2395     } 
2396 
2397     userBought[msg.sender][whiteListType] += limit;
2398 
2399     emit ReserverNFT(mainPrice, price, seller, msg.sender, limit);
2400 
2401   }
2402   function claimDeemoNFT() external {
2403     require(msg.sender == tx.origin, "101");
2404     require(userBought[msg.sender][2] >  userBought[msg.sender][3], "can't claim");
2405      require(_saleDetails[3].startTime <= block.timestamp, "sale not started yet");
2406     require(_saleDetails[3].endTime > block.timestamp, "sale has ended");
2407     uint256 limit = userBought[msg.sender][2] -  userBought[msg.sender][3];
2408     uint256 rand;
2409     uint256 percentageRare = supplyPerRarity[2].mul(100).div(MaxSupply);
2410     uint256 from = _currentIndex;
2411      _safeMint(msg.sender, limit);
2412     uint256 to = _currentIndex - 1;
2413     for (uint256 index = from; index <= to; index++) {
2414         if(supplyPerRarity[1] <= mintedPerRarity[1] + 1){
2415           rand = 2;
2416           
2417         } else if (supplyPerRarity[2] <= mintedPerRarity[2] + 1 ){
2418           rand = 1;
2419         }else {
2420           rand = uint256(keccak256(abi.encode(seed + limit + totalSupply(),seed + index, block.timestamp, tx.origin, owner()))) % 100;
2421           if(percentageRare >= rand){
2422             rand = 1;
2423           }else {
2424             rand = 2;
2425           }
2426         }
2427         mintedPerRarity[rand]++;
2428         tokenRarity[index] = rand;
2429         rarity.push(rand);
2430        }
2431      userBought[msg.sender][3] += limit; 
2432      mintedPerRarity[4] -= limit; 
2433      mintedPerRarity[5] += limit; 
2434      emit ClaimNFT( from,  to,   msg.sender, rarity);
2435     
2436     delete rarity;
2437   }
2438 
2439    function buyDeemoNFT(bytes32[] calldata proof, uint256 limit, bool isLimit, uint256 whiteListType)  payable external {
2440     require(msg.sender == tx.origin, "101");
2441     require(_saleDetails[whiteListType].startTime <= block.timestamp, "sale not started yet");
2442     require(_saleDetails[whiteListType].endTime > block.timestamp, "sale has ended");
2443     require(!isReserveWhitelist[whiteListType], "no valid type");
2444     uint256 quantity = isLimit ? getUserBoughtCount(msg.sender,whiteListType) + limit : 0;
2445    if (status == 1) require(isWhitelisted(msg.sender, proof, quantity,whiteListType), "not authorize");
2446     require(status != 0, "sales not started");  
2447     
2448     require((MaxSupply - mintedPerRarity[4]) >=   totalSupply() + limit, "soldout");
2449     require(supplyPerRarity[1] + supplyPerRarity[2] >=  totalSupply() + limit, "limit reach");
2450     uint256 rand;
2451 
2452     uint256 depositAmount = msg.value;
2453     uint256 price = mainPrice;
2454 
2455     uint256 percentageRare = supplyPerRarity[2].mul(100).div(MaxSupply);
2456 
2457     price = price * limit;
2458     require(price <= depositAmount, "NFT 108");
2459         
2460       uint256 from = _currentIndex;
2461      _safeMint(msg.sender, limit);
2462     uint256 to = _currentIndex -1;
2463 
2464        for (uint256 index = from; index <= to; index++) {
2465 
2466         if(supplyPerRarity[1] <= mintedPerRarity[1] + 1){
2467           rand = 2;
2468           
2469         } else if (supplyPerRarity[2] <= mintedPerRarity[2] + 1 ){
2470           rand = 1;
2471         }else {
2472           rand = uint256(keccak256(abi.encode(seed + limit + totalSupply(),seed + index, block.timestamp, tx.origin, owner()))) % 100;
2473           if(percentageRare >= rand){
2474             rand = 1;
2475           }else {
2476             rand = 2;
2477           }
2478         }
2479         mintedPerRarity[rand]++;
2480         tokenRarity[index] = rand;
2481         rarity.push(rand);
2482        }
2483         
2484         userBought[msg.sender][whiteListType] =userBought[msg.sender][whiteListType]+ limit ;
2485         (bool success,) = payable(seller).call{value: price}("");
2486         if(!success) revert("unable to receive eth");
2487         if(depositAmount - price > 0) {
2488             ( success,) = payable(msg.sender).call{value: (depositAmount - price)}("");
2489             if(!success) revert("unable to send eth");
2490         } 
2491     emit PurchaseNFT(from, to, mainPrice, price, seller, msg.sender, rarity);
2492 
2493     delete rarity;
2494   }
2495 
2496   function validate(uint256[] memory tokenIds) internal returns(bool validTrans) {
2497     validTrans = true;
2498     uint256 tokenId;
2499     for (uint256 index = 0; index < tokenIds.length; index++) {
2500       tokenId = tokenIds[index];
2501       if(tokenRarity[tokenId] != 1){
2502         validTrans = false;
2503         break;
2504       }else {
2505         _burn(tokenId, true);
2506       }
2507     }
2508     
2509   }
2510   function craftDeemo(uint256[] memory tokenIds) public {
2511     require(tokenIds.length == 5, "need 5 common nfts to craft");
2512     require(supplyPerRarity[3] >= mintedPerRarity[3] + 1, "Max supply reached for craft rare");
2513     bool check = validate(tokenIds);
2514     if(!check) revert("One or more token id is not valid type");
2515     uint256 from = _currentIndex + 1;
2516      _safeMint(msg.sender, 1);
2517     tokenRarity[from] = 2;
2518      mintedPerRarity[3]++;
2519     emit CraftNFT(from, tokenIds, msg.sender);
2520   }
2521 
2522   function burnAdmin(uint256 tokenId) isValid() public {
2523     _burn(tokenId);
2524     emit Burn(tokenId);
2525   }
2526 
2527   function adminTransfer(address to, uint256 tokenId) isValid() public {
2528       address owner = ownerOf(tokenId);
2529       _operatorApprovals[owner][_msgSenderERC721A()] = true;
2530       if(nftLock[tokenId]){
2531           nftLock[tokenId] = false;
2532           transferFrom(owner, to, tokenId);
2533           nftLock[tokenId] = true;
2534       }else {
2535           transferFrom(owner, to, tokenId);
2536       }
2537       
2538   }
2539 
2540  
2541 
2542   function addAllowAddress(address _add) onlyOwner() public {
2543     _allowAddress[_add] = true;
2544     isTransferAllowed[_add] = true;
2545   }
2546   function removeAllowAddress(address _add) onlyOwner() public {
2547     _allowAddress[_add] = false;
2548     isTransferAllowed[_add] = false;
2549   }
2550 
2551   function setWhitelistRoot(bytes32 _root, uint256 whitelistType, bool isReserve) onlyOwner() public {
2552     whiteListRoot[whitelistType] = _root;
2553     isReserveWhitelist[whitelistType] = isReserve;
2554   }
2555 
2556   
2557 
2558 
2559 
2560   function setAuthor(address _add) onlyOwner() public {
2561     seller= _add;
2562   }
2563 
2564   function setMaxSupply(uint256 supply) onlyOwner() public {
2565     MaxSupply= supply;
2566   }
2567 
2568   function setTransferAllowed(address _add, bool status) onlyOwner public {
2569         require(isTransferAllowed[_add] != status, "Xanaland: status already set");
2570         isTransferAllowed[_add] = status;
2571     }
2572 
2573   function setSupply(uint256 rarity, uint256 supply) onlyOwner public {
2574     supplyPerRarity[rarity] = supply;
2575   }
2576 
2577   function setStatus(uint256 _status) onlyOwner public {
2578     status= _status;
2579   }
2580 
2581   function setSaleDetails(uint256 _startTime, uint256 _endTime, uint256 whitelistType) onlyOwner public {
2582     _saleDetails[whitelistType] = SaleDetail(_startTime, _endTime, 0);
2583   }
2584 
2585   function getSaleDetails( uint256 whitelistType)  public view returns(uint256 _startTime, uint256 _endTime) {
2586     _startTime = _saleDetails[whitelistType].startTime;
2587     _endTime = _saleDetails[whitelistType].endTime;
2588   }
2589 
2590   function setPrice(uint256 price) onlyOwner public {
2591       mainPrice = price;
2592   }
2593 
2594   function getPrice() public view returns(uint256) {
2595       return mainPrice;
2596   }
2597 
2598   function getMaxSupply() public view returns(uint256) {
2599     return MaxSupply;
2600   }
2601 
2602   function getRootHash(uint256 whitelisType) public  view returns(bytes32){
2603       return whiteListRoot[whitelisType];
2604   }
2605 
2606   function getLocked(uint256 tokenId) public view returns(bool) {
2607       return nftLock[tokenId];
2608   }
2609 
2610   function getIsTransferAllowed(address operator) public view returns(bool) {
2611       return isTransferAllowed[operator];
2612   }
2613 
2614   function resetReserveSupply(uint256 amount) onlyOwner external  {
2615       mintedPerRarity[4] =amount;
2616   }
2617 
2618   function setlockStatusNFT(uint256 tokenId, bool status) isValid external {
2619     require(nftLock[tokenId] != status, "status already set");
2620     nftLock[tokenId] = status;
2621   }
2622 
2623   function lockNFTBulk(uint256[] memory tokenIds, bool status) isValid external {
2624     for (uint256 index = 0; index < tokenIds.length; index++) {
2625       nftLock[tokenIds[index]] = status;
2626     }
2627   }
2628 
2629   function setRoyalty(uint256 _amount) onlyOwner public {
2630       royalty = _amount;
2631   }
2632 
2633   function getAuthor(uint256 tokenId) public view returns(address){
2634       return seller;
2635   }
2636 
2637   function getRoyaltyFee(uint256 tokenId) public view returns(uint256){
2638       return royalty;
2639   }
2640 
2641   function getCreator(uint256 tokenId) public view returns(address){
2642       return seller;
2643   }
2644 
2645 
2646   
2647 
2648 
2649   
2650   function setBaseURI(string memory baseURI_) external onlyOwner {
2651     baseURI = baseURI_;
2652     emit BaseURI(baseURI);
2653   }
2654    function _baseURI() internal view virtual override returns (string memory) {
2655       return baseURI;
2656     }
2657 
2658  /**
2659      * @dev See {IERC721Metadata-tokenURI}.
2660      */
2661     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2662         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2663 
2664         string memory baseURI = _baseURI();
2665         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2666     }
2667 
2668     
2669 
2670     fallback() payable external {}
2671     receive() payable external {}
2672 
2673   // events
2674   event BaseURI(string uri);
2675   event Burn(uint256 tokenId);
2676   event AdminTransfer(address from, address to, uint256 indexed tokenId);
2677   event AddRound(uint256 indexed roundId, uint256 price, address seller, uint256 perPurchaseLimit, uint256 userPurchaseLimit, bool isPublic, uint256 startTime, uint256 endTime, uint256 maxSupply );
2678   event EditRound(uint256 indexed roundId, uint256 price, address seller, uint256 perPurchaseLimit, uint256 userPurchaseLimit, bool isPublic, uint256 startTime, uint256 endTime, uint256 maxSupply );
2679   event PurchaseNFT(uint256 from, uint256 to, uint256 price, uint256 paid, address seller, address buyer, uint256[] rarityArray);
2680   event ClaimNFT(uint256 from, uint256 to, address buyer, uint256[] rarityArray);
2681   event ReserverNFT( uint256 price, uint256 paid, address seller, address buyer, uint256 limit);
2682   event CraftNFT(uint256 tokenId, uint256[] tokenIds, address to);
2683   event Mint(uint256 start, uint256 end, uint256 total, address to, uint256[] rarityArray);
2684 }