1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.15;
3 
4 /* LookAtThisAwesomeContract.eth */
5 /* ENS Maxis Team */
6 
7 // File erc721a/contracts/IERC721A.sol@v4.2.2
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
24      * The caller cannot approve to their own address.
25      */
26     error ApproveToCaller();
27 
28     /**
29      * Cannot query the balance for the zero address.
30      */
31     error BalanceQueryForZeroAddress();
32 
33     /**
34      * Cannot mint to the zero address.
35      */
36     error MintToZeroAddress();
37 
38     /**
39      * The quantity of tokens minted must be more than zero.
40      */
41     error MintZeroQuantity();
42 
43     /**
44      * The token does not exist.
45      */
46     error OwnerQueryForNonexistentToken();
47 
48     /**
49      * The caller must own the token or be an approved operator.
50      */
51     error TransferCallerNotOwnerNorApproved();
52 
53     /**
54      * The token must be owned by `from`.
55      */
56     error TransferFromIncorrectOwner();
57 
58     /**
59      * Cannot safely transfer to a contract that does not implement the
60      * ERC721Receiver interface.
61      */
62     error TransferToNonERC721ReceiverImplementer();
63 
64     /**
65      * Cannot transfer to the zero address.
66      */
67     error TransferToZeroAddress();
68 
69     /**
70      * The token does not exist.
71      */
72     error URIQueryForNonexistentToken();
73 
74     /**
75      * The `quantity` minted with ERC2309 exceeds the safety limit.
76      */
77     error MintERC2309QuantityExceedsLimit();
78 
79     /**
80      * The `extraData` cannot be set on an unintialized ownership slot.
81      */
82     error OwnershipNotInitializedForExtraData();
83 
84     // =============================================================
85     //                            STRUCTS
86     // =============================================================
87 
88     struct TokenOwnership {
89         // The address of the owner.
90         address addr;
91         // Stores the start time of ownership with minimal overhead for tokenomics.
92         uint64 startTimestamp;
93         // Whether the token has been burned.
94         bool burned;
95         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
96         uint24 extraData;
97     }
98 
99     // =============================================================
100     //                         TOKEN COUNTERS
101     // =============================================================
102 
103     /**
104      * @dev Returns the total number of tokens in existence.
105      * Burned tokens will reduce the count.
106      * To get the total number of tokens minted, please see {_totalMinted}.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     // =============================================================
111     //                            IERC165
112     // =============================================================
113 
114     /**
115      * @dev Returns true if this contract implements the interface defined by
116      * `interfaceId`. See the corresponding
117      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
118      * to learn more about how these ids are created.
119      *
120      * This function call must use less than 30000 gas.
121      */
122     function supportsInterface(bytes4 interfaceId) external view returns (bool);
123 
124     // =============================================================
125     //                            IERC721
126     // =============================================================
127 
128     /**
129      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
135      */
136     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables or disables
140      * (`approved`) `operator` to manage all of its assets.
141      */
142     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
143 
144     /**
145      * @dev Returns the number of tokens in `owner`'s account.
146      */
147     function balanceOf(address owner) external view returns (uint256 balance);
148 
149     /**
150      * @dev Returns the owner of the `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function ownerOf(uint256 tokenId) external view returns (address owner);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`,
160      * checking first that contract recipients are aware of the ERC721 protocol
161      * to prevent tokens from being forever locked.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be have been allowed to move
169      * this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement
171      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId,
179         bytes calldata data
180     ) external;
181 
182     /**
183      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Transfers `tokenId` from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
195      * whenever possible.
196      *
197      * Requirements:
198      *
199      * - `from` cannot be the zero address.
200      * - `to` cannot be the zero address.
201      * - `tokenId` token must be owned by `from`.
202      * - If the caller is not `from`, it must be approved to move this token
203      * by either {approve} or {setApprovalForAll}.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 
213     /**
214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
215      * The approval is cleared when the token is transferred.
216      *
217      * Only a single account can be approved at a time, so approving the
218      * zero address clears previous approvals.
219      *
220      * Requirements:
221      *
222      * - The caller must own the token or be an approved operator.
223      * - `tokenId` must exist.
224      *
225      * Emits an {Approval} event.
226      */
227     function approve(address to, uint256 tokenId) external;
228 
229     /**
230      * @dev Approve or remove `operator` as an operator for the caller.
231      * Operators can call {transferFrom} or {safeTransferFrom}
232      * for any token owned by the caller.
233      *
234      * Requirements:
235      *
236      * - The `operator` cannot be the caller.
237      *
238      * Emits an {ApprovalForAll} event.
239      */
240     function setApprovalForAll(address operator, bool _approved) external;
241 
242     /**
243      * @dev Returns the account approved for `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function getApproved(uint256 tokenId) external view returns (address operator);
250 
251     /**
252      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
253      *
254      * See {setApprovalForAll}.
255      */
256     function isApprovedForAll(address owner, address operator) external view returns (bool);
257 
258     // =============================================================
259     //                        IERC721Metadata
260     // =============================================================
261 
262     /**
263      * @dev Returns the token collection name.
264      */
265     function name() external view returns (string memory);
266 
267     /**
268      * @dev Returns the token collection symbol.
269      */
270     function symbol() external view returns (string memory);
271 
272     /**
273      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
274      */
275     function tokenURI(uint256 tokenId) external view returns (string memory);
276 
277     // =============================================================
278     //                           IERC2309
279     // =============================================================
280 
281     /**
282      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
283      * (inclusive) is transferred from `from` to `to`, as defined in the
284      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
285      *
286      * See {_mintERC2309} for more details.
287      */
288     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
289 }
290 
291 // File erc721a/contracts/ERC721A.sol@v4.2.2
292 
293 // ERC721A Contracts v4.2.2
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
326     // Reference type for token approval.
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
635     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
636         uint256 curr = tokenId;
637 
638         unchecked {
639             if (_startTokenId() <= curr)
640                 if (curr < _currentIndex) {
641                     uint256 packed = _packedOwnerships[curr];
642                     // If not burned.
643                     if (packed & _BITMASK_BURNED == 0) {
644                         // Invariant:
645                         // There will always be an initialized ownership slot
646                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
647                         // before an unintialized ownership slot
648                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
649                         // Hence, `curr` will not underflow.
650                         //
651                         // We can directly compare the packed value.
652                         // If the address is zero, packed will be zero.
653                         while (packed == 0) {
654                             packed = _packedOwnerships[--curr];
655                         }
656                         return packed;
657                     }
658                 }
659         }
660         revert OwnerQueryForNonexistentToken();
661     }
662 
663     /**
664      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
665      */
666     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
667         ownership.addr = address(uint160(packed));
668         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
669         ownership.burned = packed & _BITMASK_BURNED != 0;
670         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
671     }
672 
673     /**
674      * @dev Packs ownership data into a single uint256.
675      */
676     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
677         assembly {
678             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
679             owner := and(owner, _BITMASK_ADDRESS)
680             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
681             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
682         }
683     }
684 
685     /**
686      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
687      */
688     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
689         // For branchless setting of the `nextInitialized` flag.
690         assembly {
691             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
692             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
693         }
694     }
695 
696     // =============================================================
697     //                      APPROVAL OPERATIONS
698     // =============================================================
699 
700     /**
701      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
702      * The approval is cleared when the token is transferred.
703      *
704      * Only a single account can be approved at a time, so approving the
705      * zero address clears previous approvals.
706      *
707      * Requirements:
708      *
709      * - The caller must own the token or be an approved operator.
710      * - `tokenId` must exist.
711      *
712      * Emits an {Approval} event.
713      */
714     function approve(address to, uint256 tokenId) public virtual override {
715         address owner = ownerOf(tokenId);
716 
717         if (_msgSenderERC721A() != owner)
718             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
719                 revert ApprovalCallerNotOwnerNorApproved();
720             }
721 
722         _tokenApprovals[tokenId].value = to;
723         emit Approval(owner, to, tokenId);
724     }
725 
726     /**
727      * @dev Returns the account approved for `tokenId` token.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function getApproved(uint256 tokenId) public view virtual override returns (address) {
734         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
735 
736         return _tokenApprovals[tokenId].value;
737     }
738 
739     /**
740      * @dev Approve or remove `operator` as an operator for the caller.
741      * Operators can call {transferFrom} or {safeTransferFrom}
742      * for any token owned by the caller.
743      *
744      * Requirements:
745      *
746      * - The `operator` cannot be the caller.
747      *
748      * Emits an {ApprovalForAll} event.
749      */
750     function setApprovalForAll(address operator, bool approved) public virtual override {
751         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
752 
753         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
754         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
755     }
756 
757     /**
758      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
759      *
760      * See {setApprovalForAll}.
761      */
762     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
763         return _operatorApprovals[owner][operator];
764     }
765 
766     /**
767      * @dev Returns whether `tokenId` exists.
768      *
769      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
770      *
771      * Tokens start existing when they are minted. See {_mint}.
772      */
773     function _exists(uint256 tokenId) internal view virtual returns (bool) {
774         return
775             _startTokenId() <= tokenId &&
776             tokenId < _currentIndex && // If within bounds,
777             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
778     }
779 
780     /**
781      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
782      */
783     function _isSenderApprovedOrOwner(
784         address approvedAddress,
785         address owner,
786         address msgSender
787     ) private pure returns (bool result) {
788         assembly {
789             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
790             owner := and(owner, _BITMASK_ADDRESS)
791             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
792             msgSender := and(msgSender, _BITMASK_ADDRESS)
793             // `msgSender == owner || msgSender == approvedAddress`.
794             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
795         }
796     }
797 
798     /**
799      * @dev Returns the storage slot and value for the approved address of `tokenId`.
800      */
801     function _getApprovedSlotAndAddress(uint256 tokenId)
802         private
803         view
804         returns (uint256 approvedAddressSlot, address approvedAddress)
805     {
806         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
807         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
808         assembly {
809             approvedAddressSlot := tokenApproval.slot
810             approvedAddress := sload(approvedAddressSlot)
811         }
812     }
813 
814     // =============================================================
815     //                      TRANSFER OPERATIONS
816     // =============================================================
817 
818     /**
819      * @dev Transfers `tokenId` from `from` to `to`.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must be owned by `from`.
826      * - If the caller is not `from`, it must be approved to move this token
827      * by either {approve} or {setApprovalForAll}.
828      *
829      * Emits a {Transfer} event.
830      */
831     function transferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public virtual override {
836         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
837 
838         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
839 
840         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
841 
842         // The nested ifs save around 20+ gas over a compound boolean condition.
843         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
844             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
845 
846         if (to == address(0)) revert TransferToZeroAddress();
847 
848         _beforeTokenTransfers(from, to, tokenId, 1);
849 
850         // Clear approvals from the previous owner.
851         assembly {
852             if approvedAddress {
853                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
854                 sstore(approvedAddressSlot, 0)
855             }
856         }
857 
858         // Underflow of the sender's balance is impossible because we check for
859         // ownership above and the recipient's balance can't realistically overflow.
860         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
861         unchecked {
862             // We can directly increment and decrement the balances.
863             --_packedAddressData[from]; // Updates: `balance -= 1`.
864             ++_packedAddressData[to]; // Updates: `balance += 1`.
865 
866             // Updates:
867             // - `address` to the next owner.
868             // - `startTimestamp` to the timestamp of transfering.
869             // - `burned` to `false`.
870             // - `nextInitialized` to `true`.
871             _packedOwnerships[tokenId] = _packOwnershipData(
872                 to,
873                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
874             );
875 
876             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
877             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
878                 uint256 nextTokenId = tokenId + 1;
879                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
880                 if (_packedOwnerships[nextTokenId] == 0) {
881                     // If the next slot is within bounds.
882                     if (nextTokenId != _currentIndex) {
883                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
884                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
885                     }
886                 }
887             }
888         }
889 
890         emit Transfer(from, to, tokenId);
891         _afterTokenTransfers(from, to, tokenId, 1);
892     }
893 
894     /**
895      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId
901     ) public virtual override {
902         safeTransferFrom(from, to, tokenId, '');
903     }
904 
905     /**
906      * @dev Safely transfers `tokenId` token from `from` to `to`.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If the caller is not `from`, it must be approved to move this token
914      * by either {approve} or {setApprovalForAll}.
915      * - If `to` refers to a smart contract, it must implement
916      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) public virtual override {
926         transferFrom(from, to, tokenId);
927         if (to.code.length != 0)
928             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
929                 revert TransferToNonERC721ReceiverImplementer();
930             }
931     }
932 
933     /**
934      * @dev Hook that is called before a set of serially-ordered token IDs
935      * are about to be transferred. This includes minting.
936      * And also called before burning one token.
937      *
938      * `startTokenId` - the first token ID to be transferred.
939      * `quantity` - the amount to be transferred.
940      *
941      * Calling conditions:
942      *
943      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
944      * transferred to `to`.
945      * - When `from` is zero, `tokenId` will be minted for `to`.
946      * - When `to` is zero, `tokenId` will be burned by `from`.
947      * - `from` and `to` are never both zero.
948      */
949     function _beforeTokenTransfers(
950         address from,
951         address to,
952         uint256 startTokenId,
953         uint256 quantity
954     ) internal virtual {}
955 
956     /**
957      * @dev Hook that is called after a set of serially-ordered token IDs
958      * have been transferred. This includes minting.
959      * And also called after one token has been burned.
960      *
961      * `startTokenId` - the first token ID to be transferred.
962      * `quantity` - the amount to be transferred.
963      *
964      * Calling conditions:
965      *
966      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
967      * transferred to `to`.
968      * - When `from` is zero, `tokenId` has been minted for `to`.
969      * - When `to` is zero, `tokenId` has been burned by `from`.
970      * - `from` and `to` are never both zero.
971      */
972     function _afterTokenTransfers(
973         address from,
974         address to,
975         uint256 startTokenId,
976         uint256 quantity
977     ) internal virtual {}
978 
979     /**
980      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
981      *
982      * `from` - Previous owner of the given token ID.
983      * `to` - Target address that will receive the token.
984      * `tokenId` - Token ID to be transferred.
985      * `_data` - Optional data to send along with the call.
986      *
987      * Returns whether the call correctly returned the expected magic value.
988      */
989     function _checkContractOnERC721Received(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes memory _data
994     ) private returns (bool) {
995         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
996             bytes4 retval
997         ) {
998             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
999         } catch (bytes memory reason) {
1000             if (reason.length == 0) {
1001                 revert TransferToNonERC721ReceiverImplementer();
1002             } else {
1003                 assembly {
1004                     revert(add(32, reason), mload(reason))
1005                 }
1006             }
1007         }
1008     }
1009 
1010     // =============================================================
1011     //                        MINT OPERATIONS
1012     // =============================================================
1013 
1014     /**
1015      * @dev Mints `quantity` tokens and transfers them to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `quantity` must be greater than 0.
1021      *
1022      * Emits a {Transfer} event for each mint.
1023      */
1024     function _mint(address to, uint256 quantity) internal virtual {
1025         uint256 startTokenId = _currentIndex;
1026         if (quantity == 0) revert MintZeroQuantity();
1027 
1028         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1029 
1030         // Overflows are incredibly unrealistic.
1031         // `balance` and `numberMinted` have a maximum limit of 2**64.
1032         // `tokenId` has a maximum limit of 2**256.
1033         unchecked {
1034             // Updates:
1035             // - `balance += quantity`.
1036             // - `numberMinted += quantity`.
1037             //
1038             // We can directly add to the `balance` and `numberMinted`.
1039             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1040 
1041             // Updates:
1042             // - `address` to the owner.
1043             // - `startTimestamp` to the timestamp of minting.
1044             // - `burned` to `false`.
1045             // - `nextInitialized` to `quantity == 1`.
1046             _packedOwnerships[startTokenId] = _packOwnershipData(
1047                 to,
1048                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1049             );
1050 
1051             uint256 toMasked;
1052             uint256 end = startTokenId + quantity;
1053 
1054             // Use assembly to loop and emit the `Transfer` event for gas savings.
1055             assembly {
1056                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1057                 toMasked := and(to, _BITMASK_ADDRESS)
1058                 // Emit the `Transfer` event.
1059                 log4(
1060                     0, // Start of data (0, since no data).
1061                     0, // End of data (0, since no data).
1062                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1063                     0, // `address(0)`.
1064                     toMasked, // `to`.
1065                     startTokenId // `tokenId`.
1066                 )
1067 
1068                 for {
1069                     let tokenId := add(startTokenId, 1)
1070                 } iszero(eq(tokenId, end)) {
1071                     tokenId := add(tokenId, 1)
1072                 } {
1073                     // Emit the `Transfer` event. Similar to above.
1074                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1075                 }
1076             }
1077             if (toMasked == 0) revert MintToZeroAddress();
1078 
1079             _currentIndex = end;
1080         }
1081         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1082     }
1083 
1084     /**
1085      * @dev Mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * This function is intended for efficient minting only during contract creation.
1088      *
1089      * It emits only one {ConsecutiveTransfer} as defined in
1090      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1091      * instead of a sequence of {Transfer} event(s).
1092      *
1093      * Calling this function outside of contract creation WILL make your contract
1094      * non-compliant with the ERC721 standard.
1095      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1096      * {ConsecutiveTransfer} event is only permissible during contract creation.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `quantity` must be greater than 0.
1102      *
1103      * Emits a {ConsecutiveTransfer} event.
1104      */
1105     function _mintERC2309(address to, uint256 quantity) internal virtual {
1106         uint256 startTokenId = _currentIndex;
1107         if (to == address(0)) revert MintToZeroAddress();
1108         if (quantity == 0) revert MintZeroQuantity();
1109         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1110 
1111         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1112 
1113         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1114         unchecked {
1115             // Updates:
1116             // - `balance += quantity`.
1117             // - `numberMinted += quantity`.
1118             //
1119             // We can directly add to the `balance` and `numberMinted`.
1120             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1121 
1122             // Updates:
1123             // - `address` to the owner.
1124             // - `startTimestamp` to the timestamp of minting.
1125             // - `burned` to `false`.
1126             // - `nextInitialized` to `quantity == 1`.
1127             _packedOwnerships[startTokenId] = _packOwnershipData(
1128                 to,
1129                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1130             );
1131 
1132             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1133 
1134             _currentIndex = startTokenId + quantity;
1135         }
1136         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1137     }
1138 
1139     /**
1140      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - If `to` refers to a smart contract, it must implement
1145      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1146      * - `quantity` must be greater than 0.
1147      *
1148      * See {_mint}.
1149      *
1150      * Emits a {Transfer} event for each mint.
1151      */
1152     function _safeMint(
1153         address to,
1154         uint256 quantity,
1155         bytes memory _data
1156     ) internal virtual {
1157         _mint(to, quantity);
1158 
1159         unchecked {
1160             if (to.code.length != 0) {
1161                 uint256 end = _currentIndex;
1162                 uint256 index = end - quantity;
1163                 do {
1164                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1165                         revert TransferToNonERC721ReceiverImplementer();
1166                     }
1167                 } while (index < end);
1168                 // Reentrancy protection.
1169                 if (_currentIndex != end) revert();
1170             }
1171         }
1172     }
1173 
1174     /**
1175      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1176      */
1177     function _safeMint(address to, uint256 quantity) internal virtual {
1178         _safeMint(to, quantity, '');
1179     }
1180 
1181     // =============================================================
1182     //                        BURN OPERATIONS
1183     // =============================================================
1184 
1185     /**
1186      * @dev Equivalent to `_burn(tokenId, false)`.
1187      */
1188     function _burn(uint256 tokenId) internal virtual {
1189         _burn(tokenId, false);
1190     }
1191 
1192     /**
1193      * @dev Destroys `tokenId`.
1194      * The approval is cleared when the token is burned.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1203         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1204 
1205         address from = address(uint160(prevOwnershipPacked));
1206 
1207         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1208 
1209         if (approvalCheck) {
1210             // The nested ifs save around 20+ gas over a compound boolean condition.
1211             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1212                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1213         }
1214 
1215         _beforeTokenTransfers(from, address(0), tokenId, 1);
1216 
1217         // Clear approvals from the previous owner.
1218         assembly {
1219             if approvedAddress {
1220                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1221                 sstore(approvedAddressSlot, 0)
1222             }
1223         }
1224 
1225         // Underflow of the sender's balance is impossible because we check for
1226         // ownership above and the recipient's balance can't realistically overflow.
1227         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1228         unchecked {
1229             // Updates:
1230             // - `balance -= 1`.
1231             // - `numberBurned += 1`.
1232             //
1233             // We can directly decrement the balance, and increment the number burned.
1234             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1235             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1236 
1237             // Updates:
1238             // - `address` to the last owner.
1239             // - `startTimestamp` to the timestamp of burning.
1240             // - `burned` to `true`.
1241             // - `nextInitialized` to `true`.
1242             _packedOwnerships[tokenId] = _packOwnershipData(
1243                 from,
1244                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1245             );
1246 
1247             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1248             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1249                 uint256 nextTokenId = tokenId + 1;
1250                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1251                 if (_packedOwnerships[nextTokenId] == 0) {
1252                     // If the next slot is within bounds.
1253                     if (nextTokenId != _currentIndex) {
1254                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1255                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1256                     }
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(from, address(0), tokenId);
1262         _afterTokenTransfers(from, address(0), tokenId, 1);
1263 
1264         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1265         unchecked {
1266             _burnCounter++;
1267         }
1268     }
1269 
1270     // =============================================================
1271     //                     EXTRA DATA OPERATIONS
1272     // =============================================================
1273 
1274     /**
1275      * @dev Directly sets the extra data for the ownership data `index`.
1276      */
1277     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1278         uint256 packed = _packedOwnerships[index];
1279         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1280         uint256 extraDataCasted;
1281         // Cast `extraData` with assembly to avoid redundant masking.
1282         assembly {
1283             extraDataCasted := extraData
1284         }
1285         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1286         _packedOwnerships[index] = packed;
1287     }
1288 
1289     /**
1290      * @dev Called during each token transfer to set the 24bit `extraData` field.
1291      * Intended to be overridden by the cosumer contract.
1292      *
1293      * `previousExtraData` - the value of `extraData` before transfer.
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` will be minted for `to`.
1300      * - When `to` is zero, `tokenId` will be burned by `from`.
1301      * - `from` and `to` are never both zero.
1302      */
1303     function _extraData(
1304         address from,
1305         address to,
1306         uint24 previousExtraData
1307     ) internal view virtual returns (uint24) {}
1308 
1309     /**
1310      * @dev Returns the next extra data for the packed ownership data.
1311      * The returned result is shifted into position.
1312      */
1313     function _nextExtraData(
1314         address from,
1315         address to,
1316         uint256 prevOwnershipPacked
1317     ) private view returns (uint256) {
1318         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1319         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1320     }
1321 
1322     // =============================================================
1323     //                       OTHER OPERATIONS
1324     // =============================================================
1325 
1326     /**
1327      * @dev Returns the message sender (defaults to `msg.sender`).
1328      *
1329      * If you are writing GSN compatible contracts, you need to override this function.
1330      */
1331     function _msgSenderERC721A() internal view virtual returns (address) {
1332         return msg.sender;
1333     }
1334 
1335     /**
1336      * @dev Converts a uint256 to its ASCII string decimal representation.
1337      */
1338     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1339         assembly {
1340             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1341             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1342             // We will need 1 32-byte word to store the length,
1343             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1344             str := add(mload(0x40), 0x80)
1345             // Update the free memory pointer to allocate.
1346             mstore(0x40, str)
1347 
1348             // Cache the end of the memory to calculate the length later.
1349             let end := str
1350 
1351             // We write the string from rightmost digit to leftmost digit.
1352             // The following is essentially a do-while loop that also handles the zero case.
1353             // prettier-ignore
1354             for { let temp := value } 1 {} {
1355                 str := sub(str, 1)
1356                 // Write the character to the pointer.
1357                 // The ASCII index of the '0' character is 48.
1358                 mstore8(str, add(48, mod(temp, 10)))
1359                 // Keep dividing `temp` until zero.
1360                 temp := div(temp, 10)
1361                 // prettier-ignore
1362                 if iszero(temp) { break }
1363             }
1364 
1365             let length := sub(end, str)
1366             // Move the pointer 32 bytes leftwards to make room for the length.
1367             str := sub(str, 0x20)
1368             // Store the length.
1369             mstore(str, length)
1370         }
1371     }
1372 }
1373 
1374 // File @openzeppelin/contracts/utils/Context.sol@v4.7.2
1375 
1376 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1377 
1378 pragma solidity ^0.8.0;
1379 
1380 /**
1381  * @dev Provides information about the current execution context, including the
1382  * sender of the transaction and its data. While these are generally available
1383  * via msg.sender and msg.data, they should not be accessed in such a direct
1384  * manner, since when dealing with meta-transactions the account sending and
1385  * paying for execution may not be the actual sender (as far as an application
1386  * is concerned).
1387  *
1388  * This contract is only required for intermediate, library-like contracts.
1389  */
1390 abstract contract Context {
1391     function _msgSender() internal view virtual returns (address) {
1392         return msg.sender;
1393     }
1394 
1395     function _msgData() internal view virtual returns (bytes calldata) {
1396         return msg.data;
1397     }
1398 }
1399 
1400 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.2
1401 
1402 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1403 
1404 pragma solidity ^0.8.0;
1405 
1406 /**
1407  * @dev Contract module which provides a basic access control mechanism, where
1408  * there is an account (an owner) that can be granted exclusive access to
1409  * specific functions.
1410  *
1411  * By default, the owner account will be the one that deploys the contract. This
1412  * can later be changed with {transferOwnership}.
1413  *
1414  * This module is used through inheritance. It will make available the modifier
1415  * `onlyOwner`, which can be applied to your functions to restrict their use to
1416  * the owner.
1417  */
1418 abstract contract Ownable is Context {
1419     address private _owner;
1420 
1421     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1422 
1423     /**
1424      * @dev Initializes the contract setting the deployer as the initial owner.
1425      */
1426     constructor() {
1427         _transferOwnership(_msgSender());
1428     }
1429 
1430     /**
1431      * @dev Throws if called by any account other than the owner.
1432      */
1433     modifier onlyOwner() {
1434         _checkOwner();
1435         _;
1436     }
1437 
1438     /**
1439      * @dev Returns the address of the current owner.
1440      */
1441     function owner() public view virtual returns (address) {
1442         return _owner;
1443     }
1444 
1445     /**
1446      * @dev Throws if the sender is not the owner.
1447      */
1448     function _checkOwner() internal view virtual {
1449         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1450     }
1451 
1452     /**
1453      * @dev Leaves the contract without owner. It will not be possible to call
1454      * `onlyOwner` functions anymore. Can only be called by the current owner.
1455      *
1456      * NOTE: Renouncing ownership will leave the contract without an owner,
1457      * thereby removing any functionality that is only available to the owner.
1458      */
1459     function renounceOwnership() public virtual onlyOwner {
1460         _transferOwnership(address(0));
1461     }
1462 
1463     /**
1464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1465      * Can only be called by the current owner.
1466      */
1467     function transferOwnership(address newOwner) public virtual onlyOwner {
1468         require(newOwner != address(0), "Ownable: new owner is the zero address");
1469         _transferOwnership(newOwner);
1470     }
1471 
1472     /**
1473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1474      * Internal function without access restriction.
1475      */
1476     function _transferOwnership(address newOwner) internal virtual {
1477         address oldOwner = _owner;
1478         _owner = newOwner;
1479         emit OwnershipTransferred(oldOwner, newOwner);
1480     }
1481 }
1482 
1483 // File @divergencetech/ethier/contracts/erc721/BaseTokenURI.sol@v0.35.1
1484 
1485 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
1486 pragma solidity >=0.8.0 <0.9.0;
1487 
1488 /**
1489 @notice ERC721 extension that overrides the OpenZeppelin _baseURI() function to
1490 return a prefix that can be set by the contract owner.
1491  */
1492 contract BaseTokenURI is Ownable {
1493     /// @notice Base token URI used as a prefix by tokenURI().
1494     string public baseTokenURI;
1495 
1496     constructor(string memory _baseTokenURI) {
1497         setBaseTokenURI(_baseTokenURI);
1498     }
1499 
1500     /// @notice Sets the base token URI prefix.
1501     function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
1502         baseTokenURI = _baseTokenURI;
1503     }
1504 
1505     /**
1506     @notice Concatenates and returns the base token URI and the token ID without
1507     any additional characters (e.g. a slash).
1508     @dev This requires that an inheriting contract that also inherits from OZ's
1509     ERC721 will have to override both contracts; although we could simply
1510     require that users implement their own _baseURI() as here, this can easily
1511     be forgotten and the current approach guides them with compiler errors. This
1512     favours the latter half of "APIs should be easy to use and hard to misuse"
1513     from https://www.infoq.com/articles/API-Design-Joshua-Bloch/.
1514      */
1515     function _baseURI() internal view virtual returns (string memory) {
1516         return baseTokenURI;
1517     }
1518 }
1519 
1520 // File @divergencetech/ethier/contracts/utils/Monotonic.sol@v0.35.1
1521 
1522 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
1523 pragma solidity >=0.8.0 <0.9.0;
1524 
1525 /**
1526 @notice Provides monotonic increasing and decreasing values, similar to
1527 OpenZeppelin's Counter but (a) limited in direction, and (b) allowing for steps
1528 > 1.
1529  */
1530 library Monotonic {
1531     /**
1532     @notice Holds a value that can only increase.
1533     @dev The internal value MUST NOT be accessed directly. Instead use current()
1534     and add().
1535      */
1536     struct Increaser {
1537         uint256 value;
1538     }
1539 
1540     /// @notice Returns the current value of the Increaser.
1541     function current(Increaser storage incr) internal view returns (uint256) {
1542         return incr.value;
1543     }
1544 
1545     /// @notice Adds x to the Increaser's value.
1546     function add(Increaser storage incr, uint256 x) internal {
1547         incr.value += x;
1548     }
1549 
1550     /**
1551     @notice Holds a value that can only decrease.
1552     @dev The internal value MUST NOT be accessed directly. Instead use current()
1553     and subtract().
1554      */
1555     struct Decreaser {
1556         uint256 value;
1557     }
1558 
1559     /// @notice Returns the current value of the Decreaser.
1560     function current(Decreaser storage decr) internal view returns (uint256) {
1561         return decr.value;
1562     }
1563 
1564     /// @notice Subtracts x from the Decreaser's value.
1565     function subtract(Decreaser storage decr, uint256 x) internal {
1566         decr.value -= x;
1567     }
1568 }
1569 
1570 // File @openzeppelin/contracts/security/Pausable.sol@v4.7.2
1571 
1572 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1573 
1574 pragma solidity ^0.8.0;
1575 
1576 /**
1577  * @dev Contract module which allows children to implement an emergency stop
1578  * mechanism that can be triggered by an authorized account.
1579  *
1580  * This module is used through inheritance. It will make available the
1581  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1582  * the functions of your contract. Note that they will not be pausable by
1583  * simply including this module, only once the modifiers are put in place.
1584  */
1585 abstract contract Pausable is Context {
1586     /**
1587      * @dev Emitted when the pause is triggered by `account`.
1588      */
1589     event Paused(address account);
1590 
1591     /**
1592      * @dev Emitted when the pause is lifted by `account`.
1593      */
1594     event Unpaused(address account);
1595 
1596     bool private _paused;
1597 
1598     /**
1599      * @dev Initializes the contract in unpaused state.
1600      */
1601     constructor() {
1602         _paused = false;
1603     }
1604 
1605     /**
1606      * @dev Modifier to make a function callable only when the contract is not paused.
1607      *
1608      * Requirements:
1609      *
1610      * - The contract must not be paused.
1611      */
1612     modifier whenNotPaused() {
1613         _requireNotPaused();
1614         _;
1615     }
1616 
1617     /**
1618      * @dev Modifier to make a function callable only when the contract is paused.
1619      *
1620      * Requirements:
1621      *
1622      * - The contract must be paused.
1623      */
1624     modifier whenPaused() {
1625         _requirePaused();
1626         _;
1627     }
1628 
1629     /**
1630      * @dev Returns true if the contract is paused, and false otherwise.
1631      */
1632     function paused() public view virtual returns (bool) {
1633         return _paused;
1634     }
1635 
1636     /**
1637      * @dev Throws if the contract is paused.
1638      */
1639     function _requireNotPaused() internal view virtual {
1640         require(!paused(), "Pausable: paused");
1641     }
1642 
1643     /**
1644      * @dev Throws if the contract is not paused.
1645      */
1646     function _requirePaused() internal view virtual {
1647         require(paused(), "Pausable: not paused");
1648     }
1649 
1650     /**
1651      * @dev Triggers stopped state.
1652      *
1653      * Requirements:
1654      *
1655      * - The contract must not be paused.
1656      */
1657     function _pause() internal virtual whenNotPaused {
1658         _paused = true;
1659         emit Paused(_msgSender());
1660     }
1661 
1662     /**
1663      * @dev Returns to normal state.
1664      *
1665      * Requirements:
1666      *
1667      * - The contract must be paused.
1668      */
1669     function _unpause() internal virtual whenPaused {
1670         _paused = false;
1671         emit Unpaused(_msgSender());
1672     }
1673 }
1674 
1675 // File @divergencetech/ethier/contracts/utils/OwnerPausable.sol@v0.35.1
1676 
1677 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
1678 pragma solidity >=0.8.0 <0.9.0;
1679 
1680 /// @notice A Pausable contract that can only be toggled by the Owner.
1681 contract OwnerPausable is Ownable, Pausable {
1682     /// @notice Pauses the contract.
1683     function pause() public onlyOwner {
1684         Pausable._pause();
1685     }
1686 
1687     /// @notice Unpauses the contract.
1688     function unpause() public onlyOwner {
1689         Pausable._unpause();
1690     }
1691 }
1692 
1693 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.2
1694 
1695 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1696 
1697 pragma solidity ^0.8.0;
1698 
1699 /**
1700  * @dev Contract module that helps prevent reentrant calls to a function.
1701  *
1702  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1703  * available, which can be applied to functions to make sure there are no nested
1704  * (reentrant) calls to them.
1705  *
1706  * Note that because there is a single `nonReentrant` guard, functions marked as
1707  * `nonReentrant` may not call one another. This can be worked around by making
1708  * those functions `private`, and then adding `external` `nonReentrant` entry
1709  * points to them.
1710  *
1711  * TIP: If you would like to learn more about reentrancy and alternative ways
1712  * to protect against it, check out our blog post
1713  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1714  */
1715 abstract contract ReentrancyGuard {
1716     // Booleans are more expensive than uint256 or any type that takes up a full
1717     // word because each write operation emits an extra SLOAD to first read the
1718     // slot's contents, replace the bits taken up by the boolean, and then write
1719     // back. This is the compiler's defense against contract upgrades and
1720     // pointer aliasing, and it cannot be disabled.
1721 
1722     // The values being non-zero value makes deployment a bit more expensive,
1723     // but in exchange the refund on every call to nonReentrant will be lower in
1724     // amount. Since refunds are capped to a percentage of the total
1725     // transaction's gas, it is best to keep them low in cases like this one, to
1726     // increase the likelihood of the full refund coming into effect.
1727     uint256 private constant _NOT_ENTERED = 1;
1728     uint256 private constant _ENTERED = 2;
1729 
1730     uint256 private _status;
1731 
1732     constructor() {
1733         _status = _NOT_ENTERED;
1734     }
1735 
1736     /**
1737      * @dev Prevents a contract from calling itself, directly or indirectly.
1738      * Calling a `nonReentrant` function from another `nonReentrant`
1739      * function is not supported. It is possible to prevent this from happening
1740      * by making the `nonReentrant` function external, and making it call a
1741      * `private` function that does the actual work.
1742      */
1743     modifier nonReentrant() {
1744         // On the first call to nonReentrant, _notEntered will be true
1745         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1746 
1747         // Any calls to nonReentrant after this point will fail
1748         _status = _ENTERED;
1749 
1750         _;
1751 
1752         // By storing the original value once again, a refund is triggered (see
1753         // https://eips.ethereum.org/EIPS/eip-2200)
1754         _status = _NOT_ENTERED;
1755     }
1756 }
1757 
1758 // File @openzeppelin/contracts/utils/Address.sol@v4.7.2
1759 
1760 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1761 
1762 pragma solidity ^0.8.1;
1763 
1764 /**
1765  * @dev Collection of functions related to the address type
1766  */
1767 library Address {
1768     /**
1769      * @dev Returns true if `account` is a contract.
1770      *
1771      * [IMPORTANT]
1772      * ====
1773      * It is unsafe to assume that an address for which this function returns
1774      * false is an externally-owned account (EOA) and not a contract.
1775      *
1776      * Among others, `isContract` will return false for the following
1777      * types of addresses:
1778      *
1779      *  - an externally-owned account
1780      *  - a contract in construction
1781      *  - an address where a contract will be created
1782      *  - an address where a contract lived, but was destroyed
1783      * ====
1784      *
1785      * [IMPORTANT]
1786      * ====
1787      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1788      *
1789      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1790      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1791      * constructor.
1792      * ====
1793      */
1794     function isContract(address account) internal view returns (bool) {
1795         // This method relies on extcodesize/address.code.length, which returns 0
1796         // for contracts in construction, since the code is only stored at the end
1797         // of the constructor execution.
1798 
1799         return account.code.length > 0;
1800     }
1801 
1802     /**
1803      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1804      * `recipient`, forwarding all available gas and reverting on errors.
1805      *
1806      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1807      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1808      * imposed by `transfer`, making them unable to receive funds via
1809      * `transfer`. {sendValue} removes this limitation.
1810      *
1811      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1812      *
1813      * IMPORTANT: because control is transferred to `recipient`, care must be
1814      * taken to not create reentrancy vulnerabilities. Consider using
1815      * {ReentrancyGuard} or the
1816      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1817      */
1818     function sendValue(address payable recipient, uint256 amount) internal {
1819         require(address(this).balance >= amount, "Address: insufficient balance");
1820 
1821         (bool success, ) = recipient.call{value: amount}("");
1822         require(success, "Address: unable to send value, recipient may have reverted");
1823     }
1824 
1825     /**
1826      * @dev Performs a Solidity function call using a low level `call`. A
1827      * plain `call` is an unsafe replacement for a function call: use this
1828      * function instead.
1829      *
1830      * If `target` reverts with a revert reason, it is bubbled up by this
1831      * function (like regular Solidity function calls).
1832      *
1833      * Returns the raw returned data. To convert to the expected return value,
1834      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1835      *
1836      * Requirements:
1837      *
1838      * - `target` must be a contract.
1839      * - calling `target` with `data` must not revert.
1840      *
1841      * _Available since v3.1._
1842      */
1843     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1844         return functionCall(target, data, "Address: low-level call failed");
1845     }
1846 
1847     /**
1848      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1849      * `errorMessage` as a fallback revert reason when `target` reverts.
1850      *
1851      * _Available since v3.1._
1852      */
1853     function functionCall(
1854         address target,
1855         bytes memory data,
1856         string memory errorMessage
1857     ) internal returns (bytes memory) {
1858         return functionCallWithValue(target, data, 0, errorMessage);
1859     }
1860 
1861     /**
1862      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1863      * but also transferring `value` wei to `target`.
1864      *
1865      * Requirements:
1866      *
1867      * - the calling contract must have an ETH balance of at least `value`.
1868      * - the called Solidity function must be `payable`.
1869      *
1870      * _Available since v3.1._
1871      */
1872     function functionCallWithValue(
1873         address target,
1874         bytes memory data,
1875         uint256 value
1876     ) internal returns (bytes memory) {
1877         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1878     }
1879 
1880     /**
1881      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1882      * with `errorMessage` as a fallback revert reason when `target` reverts.
1883      *
1884      * _Available since v3.1._
1885      */
1886     function functionCallWithValue(
1887         address target,
1888         bytes memory data,
1889         uint256 value,
1890         string memory errorMessage
1891     ) internal returns (bytes memory) {
1892         require(address(this).balance >= value, "Address: insufficient balance for call");
1893         require(isContract(target), "Address: call to non-contract");
1894 
1895         (bool success, bytes memory returndata) = target.call{value: value}(data);
1896         return verifyCallResult(success, returndata, errorMessage);
1897     }
1898 
1899     /**
1900      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1901      * but performing a static call.
1902      *
1903      * _Available since v3.3._
1904      */
1905     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1906         return functionStaticCall(target, data, "Address: low-level static call failed");
1907     }
1908 
1909     /**
1910      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1911      * but performing a static call.
1912      *
1913      * _Available since v3.3._
1914      */
1915     function functionStaticCall(
1916         address target,
1917         bytes memory data,
1918         string memory errorMessage
1919     ) internal view returns (bytes memory) {
1920         require(isContract(target), "Address: static call to non-contract");
1921 
1922         (bool success, bytes memory returndata) = target.staticcall(data);
1923         return verifyCallResult(success, returndata, errorMessage);
1924     }
1925 
1926     /**
1927      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1928      * but performing a delegate call.
1929      *
1930      * _Available since v3.4._
1931      */
1932     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1933         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1934     }
1935 
1936     /**
1937      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1938      * but performing a delegate call.
1939      *
1940      * _Available since v3.4._
1941      */
1942     function functionDelegateCall(
1943         address target,
1944         bytes memory data,
1945         string memory errorMessage
1946     ) internal returns (bytes memory) {
1947         require(isContract(target), "Address: delegate call to non-contract");
1948 
1949         (bool success, bytes memory returndata) = target.delegatecall(data);
1950         return verifyCallResult(success, returndata, errorMessage);
1951     }
1952 
1953     /**
1954      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1955      * revert reason using the provided one.
1956      *
1957      * _Available since v4.3._
1958      */
1959     function verifyCallResult(
1960         bool success,
1961         bytes memory returndata,
1962         string memory errorMessage
1963     ) internal pure returns (bytes memory) {
1964         if (success) {
1965             return returndata;
1966         } else {
1967             // Look for revert reason and bubble it up if present
1968             if (returndata.length > 0) {
1969                 // The easiest way to bubble the revert reason is using memory via assembly
1970                 /// @solidity memory-safe-assembly
1971                 assembly {
1972                     let returndata_size := mload(returndata)
1973                     revert(add(32, returndata), returndata_size)
1974                 }
1975             } else {
1976                 revert(errorMessage);
1977             }
1978         }
1979     }
1980 }
1981 
1982 // File @openzeppelin/contracts/utils/math/Math.sol@v4.7.2
1983 
1984 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
1985 
1986 pragma solidity ^0.8.0;
1987 
1988 /**
1989  * @dev Standard math utilities missing in the Solidity language.
1990  */
1991 library Math {
1992     enum Rounding {
1993         Down, // Toward negative infinity
1994         Up, // Toward infinity
1995         Zero // Toward zero
1996     }
1997 
1998     /**
1999      * @dev Returns the largest of two numbers.
2000      */
2001     function max(uint256 a, uint256 b) internal pure returns (uint256) {
2002         return a >= b ? a : b;
2003     }
2004 
2005     /**
2006      * @dev Returns the smallest of two numbers.
2007      */
2008     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2009         return a < b ? a : b;
2010     }
2011 
2012     /**
2013      * @dev Returns the average of two numbers. The result is rounded towards
2014      * zero.
2015      */
2016     function average(uint256 a, uint256 b) internal pure returns (uint256) {
2017         // (a + b) / 2 can overflow.
2018         return (a & b) + (a ^ b) / 2;
2019     }
2020 
2021     /**
2022      * @dev Returns the ceiling of the division of two numbers.
2023      *
2024      * This differs from standard division with `/` in that it rounds up instead
2025      * of rounding down.
2026      */
2027     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
2028         // (a + b - 1) / b can overflow on addition, so we distribute.
2029         return a == 0 ? 0 : (a - 1) / b + 1;
2030     }
2031 
2032     /**
2033      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
2034      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
2035      * with further edits by Uniswap Labs also under MIT license.
2036      */
2037     function mulDiv(
2038         uint256 x,
2039         uint256 y,
2040         uint256 denominator
2041     ) internal pure returns (uint256 result) {
2042         unchecked {
2043             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
2044             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
2045             // variables such that product = prod1 * 2^256 + prod0.
2046             uint256 prod0; // Least significant 256 bits of the product
2047             uint256 prod1; // Most significant 256 bits of the product
2048             assembly {
2049                 let mm := mulmod(x, y, not(0))
2050                 prod0 := mul(x, y)
2051                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
2052             }
2053 
2054             // Handle non-overflow cases, 256 by 256 division.
2055             if (prod1 == 0) {
2056                 return prod0 / denominator;
2057             }
2058 
2059             // Make sure the result is less than 2^256. Also prevents denominator == 0.
2060             require(denominator > prod1);
2061 
2062             ///////////////////////////////////////////////
2063             // 512 by 256 division.
2064             ///////////////////////////////////////////////
2065 
2066             // Make division exact by subtracting the remainder from [prod1 prod0].
2067             uint256 remainder;
2068             assembly {
2069                 // Compute remainder using mulmod.
2070                 remainder := mulmod(x, y, denominator)
2071 
2072                 // Subtract 256 bit number from 512 bit number.
2073                 prod1 := sub(prod1, gt(remainder, prod0))
2074                 prod0 := sub(prod0, remainder)
2075             }
2076 
2077             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
2078             // See https://cs.stackexchange.com/q/138556/92363.
2079 
2080             // Does not overflow because the denominator cannot be zero at this stage in the function.
2081             uint256 twos = denominator & (~denominator + 1);
2082             assembly {
2083                 // Divide denominator by twos.
2084                 denominator := div(denominator, twos)
2085 
2086                 // Divide [prod1 prod0] by twos.
2087                 prod0 := div(prod0, twos)
2088 
2089                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
2090                 twos := add(div(sub(0, twos), twos), 1)
2091             }
2092 
2093             // Shift in bits from prod1 into prod0.
2094             prod0 |= prod1 * twos;
2095 
2096             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
2097             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
2098             // four bits. That is, denominator * inv = 1 mod 2^4.
2099             uint256 inverse = (3 * denominator) ^ 2;
2100 
2101             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
2102             // in modular arithmetic, doubling the correct bits in each step.
2103             inverse *= 2 - denominator * inverse; // inverse mod 2^8
2104             inverse *= 2 - denominator * inverse; // inverse mod 2^16
2105             inverse *= 2 - denominator * inverse; // inverse mod 2^32
2106             inverse *= 2 - denominator * inverse; // inverse mod 2^64
2107             inverse *= 2 - denominator * inverse; // inverse mod 2^128
2108             inverse *= 2 - denominator * inverse; // inverse mod 2^256
2109 
2110             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
2111             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
2112             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
2113             // is no longer required.
2114             result = prod0 * inverse;
2115             return result;
2116         }
2117     }
2118 
2119     /**
2120      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
2121      */
2122     function mulDiv(
2123         uint256 x,
2124         uint256 y,
2125         uint256 denominator,
2126         Rounding rounding
2127     ) internal pure returns (uint256) {
2128         uint256 result = mulDiv(x, y, denominator);
2129         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
2130             result += 1;
2131         }
2132         return result;
2133     }
2134 
2135     /**
2136      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
2137      *
2138      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
2139      */
2140     function sqrt(uint256 a) internal pure returns (uint256) {
2141         if (a == 0) {
2142             return 0;
2143         }
2144 
2145         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
2146         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
2147         // `msb(a) <= a < 2*msb(a)`.
2148         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
2149         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
2150         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
2151         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
2152         uint256 result = 1;
2153         uint256 x = a;
2154         if (x >> 128 > 0) {
2155             x >>= 128;
2156             result <<= 64;
2157         }
2158         if (x >> 64 > 0) {
2159             x >>= 64;
2160             result <<= 32;
2161         }
2162         if (x >> 32 > 0) {
2163             x >>= 32;
2164             result <<= 16;
2165         }
2166         if (x >> 16 > 0) {
2167             x >>= 16;
2168             result <<= 8;
2169         }
2170         if (x >> 8 > 0) {
2171             x >>= 8;
2172             result <<= 4;
2173         }
2174         if (x >> 4 > 0) {
2175             x >>= 4;
2176             result <<= 2;
2177         }
2178         if (x >> 2 > 0) {
2179             result <<= 1;
2180         }
2181 
2182         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2183         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2184         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2185         // into the expected uint128 result.
2186         unchecked {
2187             result = (result + a / result) >> 1;
2188             result = (result + a / result) >> 1;
2189             result = (result + a / result) >> 1;
2190             result = (result + a / result) >> 1;
2191             result = (result + a / result) >> 1;
2192             result = (result + a / result) >> 1;
2193             result = (result + a / result) >> 1;
2194             return min(result, a / result);
2195         }
2196     }
2197 
2198     /**
2199      * @notice Calculates sqrt(a), following the selected rounding direction.
2200      */
2201     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2202         uint256 result = sqrt(a);
2203         if (rounding == Rounding.Up && result * result < a) {
2204             result += 1;
2205         }
2206         return result;
2207     }
2208 }
2209 
2210 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.2
2211 
2212 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
2213 
2214 pragma solidity ^0.8.0;
2215 
2216 /**
2217  * @dev String operations.
2218  */
2219 library Strings {
2220     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2221     uint8 private constant _ADDRESS_LENGTH = 20;
2222 
2223     /**
2224      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2225      */
2226     function toString(uint256 value) internal pure returns (string memory) {
2227         // Inspired by OraclizeAPI's implementation - MIT licence
2228         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2229 
2230         if (value == 0) {
2231             return "0";
2232         }
2233         uint256 temp = value;
2234         uint256 digits;
2235         while (temp != 0) {
2236             digits++;
2237             temp /= 10;
2238         }
2239         bytes memory buffer = new bytes(digits);
2240         while (value != 0) {
2241             digits -= 1;
2242             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2243             value /= 10;
2244         }
2245         return string(buffer);
2246     }
2247 
2248     /**
2249      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2250      */
2251     function toHexString(uint256 value) internal pure returns (string memory) {
2252         if (value == 0) {
2253             return "0x00";
2254         }
2255         uint256 temp = value;
2256         uint256 length = 0;
2257         while (temp != 0) {
2258             length++;
2259             temp >>= 8;
2260         }
2261         return toHexString(value, length);
2262     }
2263 
2264     /**
2265      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2266      */
2267     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2268         bytes memory buffer = new bytes(2 * length + 2);
2269         buffer[0] = "0";
2270         buffer[1] = "x";
2271         for (uint256 i = 2 * length + 1; i > 1; --i) {
2272             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2273             value >>= 4;
2274         }
2275         require(value == 0, "Strings: hex length insufficient");
2276         return string(buffer);
2277     }
2278 
2279     /**
2280      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2281      */
2282     function toHexString(address addr) internal pure returns (string memory) {
2283         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2284     }
2285 }
2286 
2287 // File @divergencetech/ethier/contracts/sales/Seller.sol@v0.35.1
2288 
2289 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
2290 pragma solidity >=0.8.0 <0.9.0;
2291 
2292 
2293 
2294 /**
2295 @notice An abstract contract providing the _purchase() function to:
2296  - Enforce per-wallet / per-transaction limits
2297  - Calculate required cost, forwarding to a beneficiary, and refunding extra
2298  */
2299 abstract contract Seller is OwnerPausable, ReentrancyGuard {
2300     using Address for address payable;
2301     using Monotonic for Monotonic.Increaser;
2302     using Strings for uint256;
2303 
2304     /**
2305     @dev Note that the address limits are vulnerable to wallet farming.
2306     @param maxPerAddress Unlimited if zero.
2307     @param maxPerTex Unlimited if zero.
2308     @param freeQuota Maximum number that can be purchased free of charge by
2309     the contract owner.
2310     @param reserveFreeQuota Whether to excplitly reserve the freeQuota amount
2311     and not let it be eroded by regular purchases.
2312     @param lockFreeQuota If true, calls to setSellerConfig() will ignore changes
2313     to freeQuota. Can be locked after initial setting, but not unlocked. This
2314     allows a contract owner to commit to a maximum number of reserved items.
2315     @param lockTotalInventory Similar to lockFreeQuota but applied to
2316     totalInventory.
2317     */
2318     struct SellerConfig {
2319         uint256 totalInventory;
2320         uint256 maxPerAddress;
2321         uint256 maxPerTx;
2322         uint248 freeQuota;
2323         bool reserveFreeQuota;
2324         bool lockFreeQuota;
2325         bool lockTotalInventory;
2326     }
2327 
2328     constructor(SellerConfig memory config, address payable _beneficiary) {
2329         setSellerConfig(config);
2330         setBeneficiary(_beneficiary);
2331     }
2332 
2333     /// @notice Configuration of purchase limits.
2334     SellerConfig public sellerConfig;
2335 
2336     /// @notice Sets the seller config.
2337     function setSellerConfig(SellerConfig memory config) public onlyOwner {
2338         require(
2339             config.totalInventory >= config.freeQuota,
2340             "Seller: excessive free quota"
2341         );
2342         require(
2343             config.totalInventory >= _totalSold.current(),
2344             "Seller: inventory < already sold"
2345         );
2346         require(
2347             config.freeQuota >= purchasedFreeOfCharge.current(),
2348             "Seller: free quota < already used"
2349         );
2350 
2351         // Overriding the in-memory fields before copying the whole struct, as
2352         // against writing individual fields, gives a greater guarantee of
2353         // correctness as the code is simpler to read.
2354         if (sellerConfig.lockTotalInventory) {
2355             config.lockTotalInventory = true;
2356             config.totalInventory = sellerConfig.totalInventory;
2357         }
2358         if (sellerConfig.lockFreeQuota) {
2359             config.lockFreeQuota = true;
2360             config.freeQuota = sellerConfig.freeQuota;
2361         }
2362         sellerConfig = config;
2363     }
2364 
2365     /// @notice Recipient of revenues.
2366     address payable public beneficiary;
2367 
2368     /// @notice Sets the recipient of revenues.
2369     function setBeneficiary(address payable _beneficiary) public onlyOwner {
2370         beneficiary = _beneficiary;
2371     }
2372 
2373     /**
2374     @dev Must return the current cost of a batch of items. This may be constant
2375     or, for example, decreasing for a Dutch auction or increasing for a bonding
2376     curve.
2377     @param n The number of items being purchased.
2378     @param metadata Arbitrary data, propagated by the call to _purchase() that
2379     can be used to charge different prices. This value is a uint256 instead of
2380     bytes as this allows simple passing of a set cost (see
2381     ArbitraryPriceSeller).
2382      */
2383     function cost(uint256 n, uint256 metadata)
2384         public
2385         view
2386         virtual
2387         returns (uint256);
2388 
2389     /**
2390     @dev Called by both _purchase() and purchaseFreeOfCharge() after all limits
2391     have been put in place; must perform all contract-specific sale logic, e.g.
2392     ERC721 minting. When _handlePurchase() is called, the value returned by
2393     Seller.totalSold() will be the POST-purchase amount to allow for the
2394     checks-effects-interactions (ECI) pattern as _handlePurchase() may include
2395     an interaction. _handlePurchase() MUST itself implement the CEI pattern.
2396     @param to The recipient of the item(s).
2397     @param n The number of items allowed to be purchased, which MAY be less than
2398     to the number passed to _purchase() but SHALL be greater than zero.
2399     @param freeOfCharge Indicates that the call originated from
2400     purchaseFreeOfCharge() and not _purchase().
2401     */
2402     function _handlePurchase(
2403         address to,
2404         uint256 n,
2405         bool freeOfCharge
2406     ) internal virtual;
2407 
2408     /**
2409     @notice Tracks total number of items sold by this contract, including those
2410     purchased free of charge by the contract owner.
2411      */
2412     Monotonic.Increaser private _totalSold;
2413 
2414     /// @notice Returns the total number of items sold by this contract.
2415     function totalSold() public view returns (uint256) {
2416         return _totalSold.current();
2417     }
2418 
2419     /**
2420     @notice Tracks the number of items already bought by an address, regardless
2421     of transferring out (in the case of ERC721).
2422     @dev This isn't public as it may be skewed due to differences in msg.sender
2423     and tx.origin, which it treats in the same way such that
2424     sum(_bought)>=totalSold().
2425      */
2426     mapping(address => uint256) private _bought;
2427 
2428     /**
2429     @notice Returns min(n, max(extra items addr can purchase)) and reverts if 0.
2430     @param zeroMsg The message with which to revert on 0 extra.
2431      */
2432     function _capExtra(
2433         uint256 n,
2434         address addr,
2435         string memory zeroMsg
2436     ) internal view returns (uint256) {
2437         uint256 extra = sellerConfig.maxPerAddress - _bought[addr];
2438         if (extra == 0) {
2439             revert(string(abi.encodePacked("Seller: ", zeroMsg)));
2440         }
2441         return Math.min(n, extra);
2442     }
2443 
2444     /// @notice Emitted when a buyer is refunded.
2445     event Refund(address indexed buyer, uint256 amount);
2446 
2447     /// @notice Emitted on all purchases of non-zero amount.
2448     event Revenue(
2449         address indexed beneficiary,
2450         uint256 numPurchased,
2451         uint256 amount
2452     );
2453 
2454     /// @notice Tracks number of items purchased free of charge.
2455     Monotonic.Increaser private purchasedFreeOfCharge;
2456 
2457     /**
2458     @notice Allows the contract owner to purchase without payment, within the
2459     quota enforced by the SellerConfig.
2460      */
2461     function purchaseFreeOfCharge(address to, uint256 n)
2462         public
2463         onlyOwner
2464         whenNotPaused
2465     {
2466         /**
2467          * ##### CHECKS
2468          */
2469 
2470         uint256 freeQuota = sellerConfig.freeQuota;
2471         n = Math.min(n, freeQuota - purchasedFreeOfCharge.current());
2472         require(n > 0, "Seller: Free quota exceeded");
2473 
2474         uint256 totalInventory = sellerConfig.totalInventory;
2475         n = Math.min(n, totalInventory - _totalSold.current());
2476         require(n > 0, "Seller: Sold out");
2477 
2478         /**
2479          * ##### EFFECTS
2480          */
2481         _totalSold.add(n);
2482         purchasedFreeOfCharge.add(n);
2483 
2484         /**
2485          * ##### INTERACTIONS
2486          */
2487         _handlePurchase(to, n, true);
2488         assert(_totalSold.current() <= totalInventory);
2489         assert(purchasedFreeOfCharge.current() <= freeQuota);
2490     }
2491 
2492     /**
2493     @notice Convenience function for calling _purchase() with empty costMetadata
2494     when unneeded.
2495      */
2496     function _purchase(address to, uint256 requested) internal virtual {
2497         _purchase(to, requested, 0);
2498     }
2499 
2500     /**
2501     @notice Enforces all purchase limits (counts and costs) before calling
2502     _handlePurchase(), after which the received funds are disbursed to the
2503     beneficiary, less any required refunds.
2504     @param to The final recipient of the item(s).
2505     @param requested The number of items requested for purchase, which MAY be
2506     reduced when passed to _handlePurchase().
2507     @param costMetadata Arbitrary data, propagated in the call to cost(), to be
2508     optionally used in determining the price.
2509      */
2510     function _purchase(
2511         address to,
2512         uint256 requested,
2513         uint256 costMetadata
2514     ) internal nonReentrant whenNotPaused {
2515         /**
2516          * ##### CHECKS
2517          */
2518         SellerConfig memory config = sellerConfig;
2519 
2520         uint256 n = config.maxPerTx == 0
2521             ? requested
2522             : Math.min(requested, config.maxPerTx);
2523 
2524         uint256 maxAvailable;
2525         uint256 sold;
2526 
2527         if (config.reserveFreeQuota) {
2528             maxAvailable = config.totalInventory - config.freeQuota;
2529             sold = _totalSold.current() - purchasedFreeOfCharge.current();
2530         } else {
2531             maxAvailable = config.totalInventory;
2532             sold = _totalSold.current();
2533         }
2534 
2535         n = Math.min(n, maxAvailable - sold);
2536         require(n > 0, "Seller: Sold out");
2537 
2538         if (config.maxPerAddress > 0) {
2539             bool alsoLimitSender = _msgSender() != to;
2540             // solhint-disable-next-line avoid-tx-origin
2541             bool alsoLimitOrigin = tx.origin != _msgSender() && tx.origin != to;
2542 
2543             n = _capExtra(n, to, "Buyer limit");
2544             if (alsoLimitSender) {
2545                 n = _capExtra(n, _msgSender(), "Sender limit");
2546             }
2547             if (alsoLimitOrigin) {
2548                 // solhint-disable-next-line avoid-tx-origin
2549                 n = _capExtra(n, tx.origin, "Origin limit");
2550             }
2551 
2552             _bought[to] += n;
2553             if (alsoLimitSender) {
2554                 _bought[_msgSender()] += n;
2555             }
2556             if (alsoLimitOrigin) {
2557                 // solhint-disable-next-line avoid-tx-origin
2558                 _bought[tx.origin] += n;
2559             }
2560         }
2561 
2562         uint256 _cost = cost(n, costMetadata);
2563         if (msg.value < _cost) {
2564             revert(
2565                 string(
2566                     abi.encodePacked(
2567                         "Seller: Costs ",
2568                         (_cost / 1e9).toString(),
2569                         " GWei"
2570                     )
2571                 )
2572             );
2573         }
2574 
2575         /**
2576          * ##### EFFECTS
2577          */
2578         _totalSold.add(n);
2579         assert(_totalSold.current() <= config.totalInventory);
2580 
2581         /**
2582          * ##### INTERACTIONS
2583          */
2584 
2585         // As _handlePurchase() is often an ERC721 safeMint(), it constitutes an
2586         // interaction.
2587         _handlePurchase(to, n, false);
2588 
2589         // Ideally we'd be using a PullPayment here, but the user experience is
2590         // poor when there's a variable cost or the number of items purchased
2591         // has been capped. We've addressed reentrancy with both a nonReentrant
2592         // modifier and the checks, effects, interactions pattern.
2593 
2594         if (_cost > 0) {
2595             beneficiary.sendValue(_cost);
2596             emit Revenue(beneficiary, n, _cost);
2597         }
2598 
2599         if (msg.value > _cost) {
2600             address payable reimburse = payable(_msgSender());
2601             uint256 refund = msg.value - _cost;
2602 
2603             // Using Address.sendValue() here would mask the revertMsg upon
2604             // reentrancy, but we want to expose it to allow for more precise
2605             // testing. This otherwise uses the exact same pattern as
2606             // Address.sendValue().
2607             // solhint-disable-next-line avoid-low-level-calls
2608             (bool success, bytes memory returnData) = reimburse.call{
2609                 value: refund
2610             }("");
2611             // Although `returnData` will have a spurious prefix, all we really
2612             // care about is that it contains the ReentrancyGuard reversion
2613             // message so we can check in the tests.
2614             require(success, string(returnData));
2615 
2616             emit Refund(reimburse, refund);
2617         }
2618     }
2619 }
2620 
2621 // File @divergencetech/ethier/contracts/sales/FixedPriceSeller.sol@v0.35.1
2622 
2623 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
2624 pragma solidity >=0.8.0 <0.9.0;
2625 
2626 /// @notice A Seller with fixed per-item price.
2627 abstract contract FixedPriceSeller is Seller {
2628     constructor(
2629         uint256 _price,
2630         Seller.SellerConfig memory sellerConfig,
2631         address payable _beneficiary
2632     ) Seller(sellerConfig, _beneficiary) {
2633         setPrice(_price);
2634     }
2635 
2636     /**
2637     @notice The fixed per-item price.
2638     @dev Fixed as in not changing with time nor number of items, but not a
2639     constant.
2640      */
2641     uint256 public price;
2642 
2643     /// @notice Sets the per-item price.
2644     function setPrice(uint256 _price) public onlyOwner {
2645         price = _price;
2646     }
2647 
2648     /**
2649     @notice Override of Seller.cost() with fixed price.
2650     @dev The second parameter, metadata propagated from the call to _purchase(),
2651     is ignored.
2652      */
2653     function cost(uint256 n, uint256) public view override returns (uint256) {
2654         return n * price;
2655     }
2656 }
2657 
2658 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.7.2
2659 
2660 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
2661 
2662 pragma solidity ^0.8.0;
2663 
2664 /**
2665  * @dev External interface of AccessControl declared to support ERC165 detection.
2666  */
2667 interface IAccessControl {
2668     /**
2669      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
2670      *
2671      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
2672      * {RoleAdminChanged} not being emitted signaling this.
2673      *
2674      * _Available since v3.1._
2675      */
2676     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
2677 
2678     /**
2679      * @dev Emitted when `account` is granted `role`.
2680      *
2681      * `sender` is the account that originated the contract call, an admin role
2682      * bearer except when using {AccessControl-_setupRole}.
2683      */
2684     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
2685 
2686     /**
2687      * @dev Emitted when `account` is revoked `role`.
2688      *
2689      * `sender` is the account that originated the contract call:
2690      *   - if using `revokeRole`, it is the admin role bearer
2691      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
2692      */
2693     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
2694 
2695     /**
2696      * @dev Returns `true` if `account` has been granted `role`.
2697      */
2698     function hasRole(bytes32 role, address account) external view returns (bool);
2699 
2700     /**
2701      * @dev Returns the admin role that controls `role`. See {grantRole} and
2702      * {revokeRole}.
2703      *
2704      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
2705      */
2706     function getRoleAdmin(bytes32 role) external view returns (bytes32);
2707 
2708     /**
2709      * @dev Grants `role` to `account`.
2710      *
2711      * If `account` had not been already granted `role`, emits a {RoleGranted}
2712      * event.
2713      *
2714      * Requirements:
2715      *
2716      * - the caller must have ``role``'s admin role.
2717      */
2718     function grantRole(bytes32 role, address account) external;
2719 
2720     /**
2721      * @dev Revokes `role` from `account`.
2722      *
2723      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2724      *
2725      * Requirements:
2726      *
2727      * - the caller must have ``role``'s admin role.
2728      */
2729     function revokeRole(bytes32 role, address account) external;
2730 
2731     /**
2732      * @dev Revokes `role` from the calling account.
2733      *
2734      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2735      * purpose is to provide a mechanism for accounts to lose their privileges
2736      * if they are compromised (such as when a trusted device is misplaced).
2737      *
2738      * If the calling account had been granted `role`, emits a {RoleRevoked}
2739      * event.
2740      *
2741      * Requirements:
2742      *
2743      * - the caller must be `account`.
2744      */
2745     function renounceRole(bytes32 role, address account) external;
2746 }
2747 
2748 // File @openzeppelin/contracts/access/IAccessControlEnumerable.sol@v4.7.2
2749 
2750 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
2751 
2752 pragma solidity ^0.8.0;
2753 
2754 /**
2755  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
2756  */
2757 interface IAccessControlEnumerable is IAccessControl {
2758     /**
2759      * @dev Returns one of the accounts that have `role`. `index` must be a
2760      * value between 0 and {getRoleMemberCount}, non-inclusive.
2761      *
2762      * Role bearers are not sorted in any particular way, and their ordering may
2763      * change at any point.
2764      *
2765      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2766      * you perform all queries on the same block. See the following
2767      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2768      * for more information.
2769      */
2770     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
2771 
2772     /**
2773      * @dev Returns the number of accounts that have `role`. Can be used
2774      * together with {getRoleMember} to enumerate all bearers of a role.
2775      */
2776     function getRoleMemberCount(bytes32 role) external view returns (uint256);
2777 }
2778 
2779 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.2
2780 
2781 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2782 
2783 pragma solidity ^0.8.0;
2784 
2785 /**
2786  * @dev Interface of the ERC165 standard, as defined in the
2787  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2788  *
2789  * Implementers can declare support of contract interfaces, which can then be
2790  * queried by others ({ERC165Checker}).
2791  *
2792  * For an implementation, see {ERC165}.
2793  */
2794 interface IERC165 {
2795     /**
2796      * @dev Returns true if this contract implements the interface defined by
2797      * `interfaceId`. See the corresponding
2798      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2799      * to learn more about how these ids are created.
2800      *
2801      * This function call must use less than 30 000 gas.
2802      */
2803     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2804 }
2805 
2806 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.2
2807 
2808 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2809 
2810 pragma solidity ^0.8.0;
2811 
2812 /**
2813  * @dev Implementation of the {IERC165} interface.
2814  *
2815  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2816  * for the additional interface id that will be supported. For example:
2817  *
2818  * ```solidity
2819  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2820  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2821  * }
2822  * ```
2823  *
2824  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2825  */
2826 abstract contract ERC165 is IERC165 {
2827     /**
2828      * @dev See {IERC165-supportsInterface}.
2829      */
2830     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2831         return interfaceId == type(IERC165).interfaceId;
2832     }
2833 }
2834 
2835 // File @openzeppelin/contracts/access/AccessControl.sol@v4.7.2
2836 
2837 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
2838 
2839 pragma solidity ^0.8.0;
2840 
2841 
2842 /**
2843  * @dev Contract module that allows children to implement role-based access
2844  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2845  * members except through off-chain means by accessing the contract event logs. Some
2846  * applications may benefit from on-chain enumerability, for those cases see
2847  * {AccessControlEnumerable}.
2848  *
2849  * Roles are referred to by their `bytes32` identifier. These should be exposed
2850  * in the external API and be unique. The best way to achieve this is by
2851  * using `public constant` hash digests:
2852  *
2853  * ```
2854  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2855  * ```
2856  *
2857  * Roles can be used to represent a set of permissions. To restrict access to a
2858  * function call, use {hasRole}:
2859  *
2860  * ```
2861  * function foo() public {
2862  *     require(hasRole(MY_ROLE, msg.sender));
2863  *     ...
2864  * }
2865  * ```
2866  *
2867  * Roles can be granted and revoked dynamically via the {grantRole} and
2868  * {revokeRole} functions. Each role has an associated admin role, and only
2869  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2870  *
2871  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2872  * that only accounts with this role will be able to grant or revoke other
2873  * roles. More complex role relationships can be created by using
2874  * {_setRoleAdmin}.
2875  *
2876  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2877  * grant and revoke this role. Extra precautions should be taken to secure
2878  * accounts that have been granted it.
2879  */
2880 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2881     struct RoleData {
2882         mapping(address => bool) members;
2883         bytes32 adminRole;
2884     }
2885 
2886     mapping(bytes32 => RoleData) private _roles;
2887 
2888     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2889 
2890     /**
2891      * @dev Modifier that checks that an account has a specific role. Reverts
2892      * with a standardized message including the required role.
2893      *
2894      * The format of the revert reason is given by the following regular expression:
2895      *
2896      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2897      *
2898      * _Available since v4.1._
2899      */
2900     modifier onlyRole(bytes32 role) {
2901         _checkRole(role);
2902         _;
2903     }
2904 
2905     /**
2906      * @dev See {IERC165-supportsInterface}.
2907      */
2908     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2909         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2910     }
2911 
2912     /**
2913      * @dev Returns `true` if `account` has been granted `role`.
2914      */
2915     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2916         return _roles[role].members[account];
2917     }
2918 
2919     /**
2920      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2921      * Overriding this function changes the behavior of the {onlyRole} modifier.
2922      *
2923      * Format of the revert message is described in {_checkRole}.
2924      *
2925      * _Available since v4.6._
2926      */
2927     function _checkRole(bytes32 role) internal view virtual {
2928         _checkRole(role, _msgSender());
2929     }
2930 
2931     /**
2932      * @dev Revert with a standard message if `account` is missing `role`.
2933      *
2934      * The format of the revert reason is given by the following regular expression:
2935      *
2936      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2937      */
2938     function _checkRole(bytes32 role, address account) internal view virtual {
2939         if (!hasRole(role, account)) {
2940             revert(
2941                 string(
2942                     abi.encodePacked(
2943                         "AccessControl: account ",
2944                         Strings.toHexString(uint160(account), 20),
2945                         " is missing role ",
2946                         Strings.toHexString(uint256(role), 32)
2947                     )
2948                 )
2949             );
2950         }
2951     }
2952 
2953     /**
2954      * @dev Returns the admin role that controls `role`. See {grantRole} and
2955      * {revokeRole}.
2956      *
2957      * To change a role's admin, use {_setRoleAdmin}.
2958      */
2959     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2960         return _roles[role].adminRole;
2961     }
2962 
2963     /**
2964      * @dev Grants `role` to `account`.
2965      *
2966      * If `account` had not been already granted `role`, emits a {RoleGranted}
2967      * event.
2968      *
2969      * Requirements:
2970      *
2971      * - the caller must have ``role``'s admin role.
2972      *
2973      * May emit a {RoleGranted} event.
2974      */
2975     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2976         _grantRole(role, account);
2977     }
2978 
2979     /**
2980      * @dev Revokes `role` from `account`.
2981      *
2982      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2983      *
2984      * Requirements:
2985      *
2986      * - the caller must have ``role``'s admin role.
2987      *
2988      * May emit a {RoleRevoked} event.
2989      */
2990     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2991         _revokeRole(role, account);
2992     }
2993 
2994     /**
2995      * @dev Revokes `role` from the calling account.
2996      *
2997      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2998      * purpose is to provide a mechanism for accounts to lose their privileges
2999      * if they are compromised (such as when a trusted device is misplaced).
3000      *
3001      * If the calling account had been revoked `role`, emits a {RoleRevoked}
3002      * event.
3003      *
3004      * Requirements:
3005      *
3006      * - the caller must be `account`.
3007      *
3008      * May emit a {RoleRevoked} event.
3009      */
3010     function renounceRole(bytes32 role, address account) public virtual override {
3011         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
3012 
3013         _revokeRole(role, account);
3014     }
3015 
3016     /**
3017      * @dev Grants `role` to `account`.
3018      *
3019      * If `account` had not been already granted `role`, emits a {RoleGranted}
3020      * event. Note that unlike {grantRole}, this function doesn't perform any
3021      * checks on the calling account.
3022      *
3023      * May emit a {RoleGranted} event.
3024      *
3025      * [WARNING]
3026      * ====
3027      * This function should only be called from the constructor when setting
3028      * up the initial roles for the system.
3029      *
3030      * Using this function in any other way is effectively circumventing the admin
3031      * system imposed by {AccessControl}.
3032      * ====
3033      *
3034      * NOTE: This function is deprecated in favor of {_grantRole}.
3035      */
3036     function _setupRole(bytes32 role, address account) internal virtual {
3037         _grantRole(role, account);
3038     }
3039 
3040     /**
3041      * @dev Sets `adminRole` as ``role``'s admin role.
3042      *
3043      * Emits a {RoleAdminChanged} event.
3044      */
3045     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
3046         bytes32 previousAdminRole = getRoleAdmin(role);
3047         _roles[role].adminRole = adminRole;
3048         emit RoleAdminChanged(role, previousAdminRole, adminRole);
3049     }
3050 
3051     /**
3052      * @dev Grants `role` to `account`.
3053      *
3054      * Internal function without access restriction.
3055      *
3056      * May emit a {RoleGranted} event.
3057      */
3058     function _grantRole(bytes32 role, address account) internal virtual {
3059         if (!hasRole(role, account)) {
3060             _roles[role].members[account] = true;
3061             emit RoleGranted(role, account, _msgSender());
3062         }
3063     }
3064 
3065     /**
3066      * @dev Revokes `role` from `account`.
3067      *
3068      * Internal function without access restriction.
3069      *
3070      * May emit a {RoleRevoked} event.
3071      */
3072     function _revokeRole(bytes32 role, address account) internal virtual {
3073         if (hasRole(role, account)) {
3074             _roles[role].members[account] = false;
3075             emit RoleRevoked(role, account, _msgSender());
3076         }
3077     }
3078 }
3079 
3080 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.7.2
3081 
3082 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
3083 
3084 pragma solidity ^0.8.0;
3085 
3086 /**
3087  * @dev Library for managing
3088  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
3089  * types.
3090  *
3091  * Sets have the following properties:
3092  *
3093  * - Elements are added, removed, and checked for existence in constant time
3094  * (O(1)).
3095  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
3096  *
3097  * ```
3098  * contract Example {
3099  *     // Add the library methods
3100  *     using EnumerableSet for EnumerableSet.AddressSet;
3101  *
3102  *     // Declare a set state variable
3103  *     EnumerableSet.AddressSet private mySet;
3104  * }
3105  * ```
3106  *
3107  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
3108  * and `uint256` (`UintSet`) are supported.
3109  *
3110  * [WARNING]
3111  * ====
3112  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
3113  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
3114  *
3115  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
3116  * ====
3117  */
3118 library EnumerableSet {
3119     // To implement this library for multiple types with as little code
3120     // repetition as possible, we write it in terms of a generic Set type with
3121     // bytes32 values.
3122     // The Set implementation uses private functions, and user-facing
3123     // implementations (such as AddressSet) are just wrappers around the
3124     // underlying Set.
3125     // This means that we can only create new EnumerableSets for types that fit
3126     // in bytes32.
3127 
3128     struct Set {
3129         // Storage of set values
3130         bytes32[] _values;
3131         // Position of the value in the `values` array, plus 1 because index 0
3132         // means a value is not in the set.
3133         mapping(bytes32 => uint256) _indexes;
3134     }
3135 
3136     /**
3137      * @dev Add a value to a set. O(1).
3138      *
3139      * Returns true if the value was added to the set, that is if it was not
3140      * already present.
3141      */
3142     function _add(Set storage set, bytes32 value) private returns (bool) {
3143         if (!_contains(set, value)) {
3144             set._values.push(value);
3145             // The value is stored at length-1, but we add 1 to all indexes
3146             // and use 0 as a sentinel value
3147             set._indexes[value] = set._values.length;
3148             return true;
3149         } else {
3150             return false;
3151         }
3152     }
3153 
3154     /**
3155      * @dev Removes a value from a set. O(1).
3156      *
3157      * Returns true if the value was removed from the set, that is if it was
3158      * present.
3159      */
3160     function _remove(Set storage set, bytes32 value) private returns (bool) {
3161         // We read and store the value's index to prevent multiple reads from the same storage slot
3162         uint256 valueIndex = set._indexes[value];
3163 
3164         if (valueIndex != 0) {
3165             // Equivalent to contains(set, value)
3166             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
3167             // the array, and then remove the last element (sometimes called as 'swap and pop').
3168             // This modifies the order of the array, as noted in {at}.
3169 
3170             uint256 toDeleteIndex = valueIndex - 1;
3171             uint256 lastIndex = set._values.length - 1;
3172 
3173             if (lastIndex != toDeleteIndex) {
3174                 bytes32 lastValue = set._values[lastIndex];
3175 
3176                 // Move the last value to the index where the value to delete is
3177                 set._values[toDeleteIndex] = lastValue;
3178                 // Update the index for the moved value
3179                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
3180             }
3181 
3182             // Delete the slot where the moved value was stored
3183             set._values.pop();
3184 
3185             // Delete the index for the deleted slot
3186             delete set._indexes[value];
3187 
3188             return true;
3189         } else {
3190             return false;
3191         }
3192     }
3193 
3194     /**
3195      * @dev Returns true if the value is in the set. O(1).
3196      */
3197     function _contains(Set storage set, bytes32 value) private view returns (bool) {
3198         return set._indexes[value] != 0;
3199     }
3200 
3201     /**
3202      * @dev Returns the number of values on the set. O(1).
3203      */
3204     function _length(Set storage set) private view returns (uint256) {
3205         return set._values.length;
3206     }
3207 
3208     /**
3209      * @dev Returns the value stored at position `index` in the set. O(1).
3210      *
3211      * Note that there are no guarantees on the ordering of values inside the
3212      * array, and it may change when more values are added or removed.
3213      *
3214      * Requirements:
3215      *
3216      * - `index` must be strictly less than {length}.
3217      */
3218     function _at(Set storage set, uint256 index) private view returns (bytes32) {
3219         return set._values[index];
3220     }
3221 
3222     /**
3223      * @dev Return the entire set in an array
3224      *
3225      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3226      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3227      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3228      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3229      */
3230     function _values(Set storage set) private view returns (bytes32[] memory) {
3231         return set._values;
3232     }
3233 
3234     // Bytes32Set
3235 
3236     struct Bytes32Set {
3237         Set _inner;
3238     }
3239 
3240     /**
3241      * @dev Add a value to a set. O(1).
3242      *
3243      * Returns true if the value was added to the set, that is if it was not
3244      * already present.
3245      */
3246     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
3247         return _add(set._inner, value);
3248     }
3249 
3250     /**
3251      * @dev Removes a value from a set. O(1).
3252      *
3253      * Returns true if the value was removed from the set, that is if it was
3254      * present.
3255      */
3256     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
3257         return _remove(set._inner, value);
3258     }
3259 
3260     /**
3261      * @dev Returns true if the value is in the set. O(1).
3262      */
3263     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
3264         return _contains(set._inner, value);
3265     }
3266 
3267     /**
3268      * @dev Returns the number of values in the set. O(1).
3269      */
3270     function length(Bytes32Set storage set) internal view returns (uint256) {
3271         return _length(set._inner);
3272     }
3273 
3274     /**
3275      * @dev Returns the value stored at position `index` in the set. O(1).
3276      *
3277      * Note that there are no guarantees on the ordering of values inside the
3278      * array, and it may change when more values are added or removed.
3279      *
3280      * Requirements:
3281      *
3282      * - `index` must be strictly less than {length}.
3283      */
3284     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
3285         return _at(set._inner, index);
3286     }
3287 
3288     /**
3289      * @dev Return the entire set in an array
3290      *
3291      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3292      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3293      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3294      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3295      */
3296     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
3297         return _values(set._inner);
3298     }
3299 
3300     // AddressSet
3301 
3302     struct AddressSet {
3303         Set _inner;
3304     }
3305 
3306     /**
3307      * @dev Add a value to a set. O(1).
3308      *
3309      * Returns true if the value was added to the set, that is if it was not
3310      * already present.
3311      */
3312     function add(AddressSet storage set, address value) internal returns (bool) {
3313         return _add(set._inner, bytes32(uint256(uint160(value))));
3314     }
3315 
3316     /**
3317      * @dev Removes a value from a set. O(1).
3318      *
3319      * Returns true if the value was removed from the set, that is if it was
3320      * present.
3321      */
3322     function remove(AddressSet storage set, address value) internal returns (bool) {
3323         return _remove(set._inner, bytes32(uint256(uint160(value))));
3324     }
3325 
3326     /**
3327      * @dev Returns true if the value is in the set. O(1).
3328      */
3329     function contains(AddressSet storage set, address value) internal view returns (bool) {
3330         return _contains(set._inner, bytes32(uint256(uint160(value))));
3331     }
3332 
3333     /**
3334      * @dev Returns the number of values in the set. O(1).
3335      */
3336     function length(AddressSet storage set) internal view returns (uint256) {
3337         return _length(set._inner);
3338     }
3339 
3340     /**
3341      * @dev Returns the value stored at position `index` in the set. O(1).
3342      *
3343      * Note that there are no guarantees on the ordering of values inside the
3344      * array, and it may change when more values are added or removed.
3345      *
3346      * Requirements:
3347      *
3348      * - `index` must be strictly less than {length}.
3349      */
3350     function at(AddressSet storage set, uint256 index) internal view returns (address) {
3351         return address(uint160(uint256(_at(set._inner, index))));
3352     }
3353 
3354     /**
3355      * @dev Return the entire set in an array
3356      *
3357      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3358      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3359      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3360      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3361      */
3362     function values(AddressSet storage set) internal view returns (address[] memory) {
3363         bytes32[] memory store = _values(set._inner);
3364         address[] memory result;
3365 
3366         /// @solidity memory-safe-assembly
3367         assembly {
3368             result := store
3369         }
3370 
3371         return result;
3372     }
3373 
3374     // UintSet
3375 
3376     struct UintSet {
3377         Set _inner;
3378     }
3379 
3380     /**
3381      * @dev Add a value to a set. O(1).
3382      *
3383      * Returns true if the value was added to the set, that is if it was not
3384      * already present.
3385      */
3386     function add(UintSet storage set, uint256 value) internal returns (bool) {
3387         return _add(set._inner, bytes32(value));
3388     }
3389 
3390     /**
3391      * @dev Removes a value from a set. O(1).
3392      *
3393      * Returns true if the value was removed from the set, that is if it was
3394      * present.
3395      */
3396     function remove(UintSet storage set, uint256 value) internal returns (bool) {
3397         return _remove(set._inner, bytes32(value));
3398     }
3399 
3400     /**
3401      * @dev Returns true if the value is in the set. O(1).
3402      */
3403     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
3404         return _contains(set._inner, bytes32(value));
3405     }
3406 
3407     /**
3408      * @dev Returns the number of values on the set. O(1).
3409      */
3410     function length(UintSet storage set) internal view returns (uint256) {
3411         return _length(set._inner);
3412     }
3413 
3414     /**
3415      * @dev Returns the value stored at position `index` in the set. O(1).
3416      *
3417      * Note that there are no guarantees on the ordering of values inside the
3418      * array, and it may change when more values are added or removed.
3419      *
3420      * Requirements:
3421      *
3422      * - `index` must be strictly less than {length}.
3423      */
3424     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
3425         return uint256(_at(set._inner, index));
3426     }
3427 
3428     /**
3429      * @dev Return the entire set in an array
3430      *
3431      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3432      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3433      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3434      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3435      */
3436     function values(UintSet storage set) internal view returns (uint256[] memory) {
3437         bytes32[] memory store = _values(set._inner);
3438         uint256[] memory result;
3439 
3440         /// @solidity memory-safe-assembly
3441         assembly {
3442             result := store
3443         }
3444 
3445         return result;
3446     }
3447 }
3448 
3449 // File @openzeppelin/contracts/access/AccessControlEnumerable.sol@v4.7.2
3450 
3451 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
3452 
3453 pragma solidity ^0.8.0;
3454 
3455 /**
3456  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
3457  */
3458 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
3459     using EnumerableSet for EnumerableSet.AddressSet;
3460 
3461     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
3462 
3463     /**
3464      * @dev See {IERC165-supportsInterface}.
3465      */
3466     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3467         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
3468     }
3469 
3470     /**
3471      * @dev Returns one of the accounts that have `role`. `index` must be a
3472      * value between 0 and {getRoleMemberCount}, non-inclusive.
3473      *
3474      * Role bearers are not sorted in any particular way, and their ordering may
3475      * change at any point.
3476      *
3477      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
3478      * you perform all queries on the same block. See the following
3479      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
3480      * for more information.
3481      */
3482     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
3483         return _roleMembers[role].at(index);
3484     }
3485 
3486     /**
3487      * @dev Returns the number of accounts that have `role`. Can be used
3488      * together with {getRoleMember} to enumerate all bearers of a role.
3489      */
3490     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
3491         return _roleMembers[role].length();
3492     }
3493 
3494     /**
3495      * @dev Overload {_grantRole} to track enumerable memberships
3496      */
3497     function _grantRole(bytes32 role, address account) internal virtual override {
3498         super._grantRole(role, account);
3499         _roleMembers[role].add(account);
3500     }
3501 
3502     /**
3503      * @dev Overload {_revokeRole} to track enumerable memberships
3504      */
3505     function _revokeRole(bytes32 role, address account) internal virtual override {
3506         super._revokeRole(role, account);
3507         _roleMembers[role].remove(account);
3508     }
3509 }
3510 
3511 // File contracts/ITokenURIGenerator.sol
3512 
3513 pragma solidity 0.8.15;
3514 
3515 interface ITokenURIGenerator {
3516   function tokenURI(uint256 tokenId) external pure returns(string memory);
3517 }
3518 
3519 // File contracts/ENSMaxis.sol
3520 
3521 pragma solidity 0.8.15;
3522 
3523 contract ENSMaxis is
3524   AccessControlEnumerable,
3525   ERC721A,
3526   BaseTokenURI,
3527   FixedPriceSeller
3528 {
3529   ITokenURIGenerator public renderingContract;
3530   bool public isSaleOpen = false;
3531 
3532   constructor()
3533     ERC721A('ENS Maxis', 'ENSMAXIS')
3534     BaseTokenURI('')
3535 
3536     FixedPriceSeller(
3537       0 ether,
3538 
3539       Seller.SellerConfig({
3540         totalInventory: 10_000,
3541         lockTotalInventory: true,
3542         maxPerAddress: 1,
3543         maxPerTx: 1,
3544         freeQuota: 1_000,
3545         lockFreeQuota: true,
3546         reserveFreeQuota: true
3547       }),
3548 
3549       beneficiary
3550     )
3551   {
3552     _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
3553   }
3554 
3555   function _handlePurchase(
3556     address to,
3557     uint256 n,
3558     bool
3559   ) internal override {
3560     require(isSaleOpen, 'SALE_NOT_OPEN');
3561     _safeMint(to, n);
3562   }
3563 
3564   function AlexaRegisterTheGameIsOnDotETH() external onlyOwner {
3565     isSaleOpen = true;
3566   }
3567 
3568   function AlexaRegisterIAmAnOGMaxisDotETH(address to) external payable {
3569     require(isSaleOpen, 'SALE_NOT_OPEN');
3570     _purchase(to, 1);
3571   }
3572 
3573   function _baseURI()
3574     internal
3575     view
3576     override(BaseTokenURI, ERC721A)
3577     returns (string memory)
3578   {
3579     return BaseTokenURI._baseURI();
3580   }
3581 
3582   function setRenderingContract(ITokenURIGenerator _contract)
3583     external
3584     onlyOwner
3585   {
3586     renderingContract = _contract;
3587   }
3588 
3589   function tokenURI(uint256 tokenId)
3590     public
3591     view
3592     override
3593     returns(string memory)
3594   {
3595     if(address(renderingContract) != address(0)) {
3596       return renderingContract.tokenURI(tokenId);
3597     }
3598 
3599     return super.tokenURI(tokenId);
3600   }
3601 
3602   function supportsInterface(bytes4 interfaceId)
3603     public
3604     view
3605     override(ERC721A, AccessControlEnumerable)
3606     returns(bool)
3607   {
3608     return super.supportsInterface(interfaceId);
3609   }
3610 }