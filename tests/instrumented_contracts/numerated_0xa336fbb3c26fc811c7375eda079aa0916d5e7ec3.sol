1 // SPDX-License-Identifier: MIT
2 // ERC721A Contracts v4.2.2
3 
4 /* 
5     CODEDETH: READ THE RULES! (EXPERIMENT!!!)
6 */
7 
8 pragma solidity 0.8.16;
9 
10 /**
11  * @dev Interface of ERC721A.
12  */
13 interface IERC721A {
14     /**
15      * The caller must own the token or be an approved operator.
16      */
17     error ApprovalCallerNotOwnerNorApproved();
18 
19     /**
20      * The token does not exist.
21      */
22     error ApprovalQueryForNonexistentToken();
23 
24     /**
25      * Cannot query the balance for the zero address.
26      */
27     error BalanceQueryForZeroAddress();
28 
29     /**
30      * Cannot mint to the zero address.
31      */
32     error MintToZeroAddress();
33 
34     /**
35      * The quantity of tokens minted must be more than zero.
36      */
37     error MintZeroQuantity();
38 
39     /**
40      * The token does not exist.
41      */
42     error OwnerQueryForNonexistentToken();
43 
44     /**
45      * The caller must own the token or be an approved operator.
46      */
47     error TransferCallerNotOwnerNorApproved();
48 
49     /**
50      * The token must be owned by `from`.
51      */
52     error TransferFromIncorrectOwner();
53 
54     /**
55      * Cannot safely transfer to a contract that does not implement the
56      * ERC721Receiver interface.
57      */
58     error TransferToNonERC721ReceiverImplementer();
59 
60     /**
61      * Cannot transfer to the zero address.
62      */
63     error TransferToZeroAddress();
64 
65     /**
66      * The token does not exist.
67      */
68     error URIQueryForNonexistentToken();
69 
70     /**
71      * The `quantity` minted with ERC2309 exceeds the safety limit.
72      */
73     error MintERC2309QuantityExceedsLimit();
74 
75     /**
76      * The `extraData` cannot be set on an unintialized ownership slot.
77      */
78     error OwnershipNotInitializedForExtraData();
79 
80     // =============================================================
81     //                            STRUCTS
82     // =============================================================
83 
84     struct TokenOwnership {
85         // The address of the owner.
86         address addr;
87         // Stores the start time of ownership with minimal overhead for tokenomics.
88         uint64 startTimestamp;
89         // Whether the token has been burned.
90         bool burned;
91         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
92         uint24 extraData;
93     }
94 
95     // =============================================================
96     //                         TOKEN COUNTERS
97     // =============================================================
98 
99     /**
100      * @dev Returns the total number of tokens in existence.
101      * Burned tokens will reduce the count.
102      * To get the total number of tokens minted, please see {_totalMinted}.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     // =============================================================
107     //                            IERC165
108     // =============================================================
109 
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 
120     // =============================================================
121     //                            IERC721
122     // =============================================================
123 
124     /**
125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables or disables
136      * (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in `owner`'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`,
156      * checking first that contract recipients are aware of the ERC721 protocol
157      * to prevent tokens from being forever locked.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be have been allowed to move
165      * this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement
167      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external;
177 
178     /**
179      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Transfers `tokenId` from `from` to `to`.
189      *
190      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
191      * whenever possible.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token
199      * by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the
214      * zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external;
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom}
228      * for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}.
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 
254     // =============================================================
255     //                        IERC721Metadata
256     // =============================================================
257 
258     /**
259      * @dev Returns the token collection name.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the token collection symbol.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
270      */
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 
273     // =============================================================
274     //                           IERC2309
275     // =============================================================
276 
277     /**
278      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
279      * (inclusive) is transferred from `from` to `to`, as defined in the
280      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
281      *
282      * See {_mintERC2309} for more details.
283      */
284     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
285 }
286 
287 /**
288  * @dev Interface of ERC721 token receiver.
289  */
290 interface ERC721A__IERC721Receiver {
291     function onERC721Received(
292         address operator,
293         address from,
294         uint256 tokenId,
295         bytes calldata data
296     ) external returns (bytes4);
297 }
298 
299 /**
300  * @title ERC721A
301  *
302  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
303  * Non-Fungible Token Standard, including the Metadata extension.
304  * Optimized for lower gas during batch mints.
305  *
306  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
307  * starting from `_startTokenId()`.
308  *
309  * Assumptions:
310  *
311  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
312  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
313  */
314 contract ERC721A is IERC721A {
315 
316 	address public _owner;
317     modifier onlyOwner() { 
318         require(_owner==msg.sender, "No!"); 
319         _; 
320     }
321 
322 	function withdraw() external onlyOwner {
323         uint256 balance = address(this).balance;
324         payable(msg.sender).transfer(balance);
325     }
326 
327     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
328     struct TokenApprovalRef {
329         address value;
330     }
331 
332     // =============================================================
333     //                           CONSTANTS
334     // =============================================================
335 
336     // Mask of an entry in packed address data.
337     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
338 
339     // The bit position of `numberMinted` in packed address data.
340     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
341 
342     // The bit position of `numberBurned` in packed address data.
343     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
344 
345     // The bit position of `aux` in packed address data.
346     uint256 private constant _BITPOS_AUX = 192;
347 
348     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
349     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
350 
351     // The bit position of `startTimestamp` in packed ownership.
352     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
353 
354     // The bit mask of the `burned` bit in packed ownership.
355     uint256 private constant _BITMASK_BURNED = 1 << 224;
356 
357     // The bit position of the `nextInitialized` bit in packed ownership.
358     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
359 
360     // The bit mask of the `nextInitialized` bit in packed ownership.
361     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
362 
363     // The bit position of `extraData` in packed ownership.
364     uint256 private constant _BITPOS_EXTRA_DATA = 232;
365 
366     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
367     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
368 
369     // The mask of the lower 160 bits for addresses.
370     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
371 
372     // The maximum `quantity` that can be minted with {_mintERC2309}.
373     // This limit is to prevent overflows on the address data entries.
374     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
375     // is required to cause an overflow, which is unrealistic.
376     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
377 
378     // The `Transfer` event signature is given by:
379     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
380     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
381         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
382 
383     // =============================================================
384     //                            STORAGE
385     // =============================================================
386 
387     // The next token ID to be minted.
388     uint256 private _currentIndex;
389 
390     // The number of tokens burned.
391     uint256 private _burnCounter;
392 
393     // Token name
394     string private _name;
395 
396     // Token symbol
397     string private _symbol;
398 
399     // Mapping from token ID to ownership details
400     // An empty struct value does not necessarily mean the token is unowned.
401     // See {_packedOwnershipOf} implementation for details.
402     //
403     // Bits Layout:
404     // - [0..159]   `addr`
405     // - [160..223] `startTimestamp`
406     // - [224]      `burned`
407     // - [225]      `nextInitialized`
408     // - [232..255] `extraData`
409     mapping(uint256 => uint256) private _packedOwnerships;
410 
411     // Mapping owner address to address data.
412     //
413     // Bits Layout:
414     // - [0..63]    `balance`
415     // - [64..127]  `numberMinted`
416     // - [128..191] `numberBurned`
417     // - [192..255] `aux`
418     mapping(address => uint256) private _packedAddressData;
419 
420     // Mapping from token ID to approved address.
421     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
422 
423     // Mapping from owner to operator approvals
424     mapping(address => mapping(address => bool)) public _operatorApprovals;
425 
426     // =============================================================
427     //                          CONSTRUCTOR
428     // =============================================================
429 
430     constructor(string memory name_, string memory symbol_) {
431         _name = name_;
432         _symbol = symbol_;
433         _currentIndex = _startTokenId();
434 		_owner = msg.sender;
435     }
436 
437     // =============================================================
438     //                   TOKEN COUNTING OPERATIONS
439     // =============================================================
440 
441     /**
442      * @dev Returns the starting token ID.
443      * To change the starting token ID, please override this function.
444      */
445     function _startTokenId() internal view virtual returns (uint256) {
446         return 0;
447     }
448 
449     /**
450      * @dev Returns the next token ID to be minted.
451      */
452     function _nextTokenId() internal view virtual returns (uint256) {
453         return _currentIndex;
454     }
455 
456     /**
457      * @dev Returns the total number of tokens in existence.
458      * Burned tokens will reduce the count.
459      * To get the total number of tokens minted, please see {_totalMinted}.
460      */
461     function totalSupply() public view virtual override returns (uint256) {
462         // Counter underflow is impossible as _burnCounter cannot be incremented
463         // more than `_currentIndex - _startTokenId()` times.
464         unchecked {
465             return _currentIndex - _burnCounter - _startTokenId();
466         }
467     }
468 
469     /**
470      * @dev Returns the total amount of tokens minted in the contract.
471      */
472     function _totalMinted() internal view virtual returns (uint256) {
473         // Counter underflow is impossible as `_currentIndex` does not decrement,
474         // and it is initialized to `_startTokenId()`.
475         unchecked {
476             return _currentIndex - _startTokenId();
477         }
478     }
479 
480     /**
481      * @dev Returns the total number of tokens burned.
482      */
483     function _totalBurned() internal view virtual returns (uint256) {
484         return _burnCounter;
485     }
486 
487     // =============================================================
488     //                    ADDRESS DATA OPERATIONS
489     // =============================================================
490 
491     /**
492      * @dev Returns the number of tokens in `owner`'s account.
493      */
494     function balanceOf(address owner) public view virtual override returns (uint256) {
495         if (owner == address(0)) revert BalanceQueryForZeroAddress();
496         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
497     }
498 
499     /**
500      * Returns the number of tokens minted by `owner`.
501      */
502     function _numberMinted(address owner) internal view returns (uint256) {
503         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
504     }
505 
506     /**
507      * Returns the number of tokens burned by or on behalf of `owner`.
508      */
509     function _numberBurned(address owner) internal view returns (uint256) {
510         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
511     }
512 
513     /**
514      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
515      */
516     function _getAux(address owner) internal view returns (uint64) {
517         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
518     }
519 
520     /**
521      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
522      * If there are multiple variables, please pack them into a uint64.
523      */
524     function _setAux(address owner, uint64 aux) internal virtual {
525         uint256 packed = _packedAddressData[owner];
526         uint256 auxCasted;
527         // Cast `aux` with assembly to avoid redundant masking.
528         assembly {
529             auxCasted := aux
530         }
531         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
532         _packedAddressData[owner] = packed;
533     }
534 
535     // =============================================================
536     //                            IERC165
537     // =============================================================
538 
539     /**
540      * @dev Returns true if this contract implements the interface defined by
541      * `interfaceId`. See the corresponding
542      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
543      * to learn more about how these ids are created.
544      *
545      * This function call must use less than 30000 gas.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548         // The interface IDs are constants representing the first 4 bytes
549         // of the XOR of all function selectors in the interface.
550         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
551         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
552         return
553             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
554             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
555             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
556     }
557 
558     // =============================================================
559     //                        IERC721Metadata
560     // =============================================================
561 
562     /**
563      * @dev Returns the token collection name.
564      */
565     function name() public view virtual override returns (string memory) {
566         return _name;
567     }
568 
569     /**
570      * @dev Returns the token collection symbol.
571      */
572     function symbol() public view virtual override returns (string memory) {
573         return _symbol;
574     }
575 
576     /**
577      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
578      */
579     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
580         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
581 
582         string memory baseURI = _baseURI();
583         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
584     }
585 
586     /**
587      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
588      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
589      * by default, it can be overridden in child contracts.
590      */
591     function _baseURI() internal view virtual returns (string memory) {
592         return '';
593     }
594 
595     // =============================================================
596     //                     OWNERSHIPS OPERATIONS
597     // =============================================================
598 
599     /**
600      * @dev Returns the owner of the `tokenId` token.
601      *
602      * Requirements:
603      *
604      * - `tokenId` must exist.
605      */
606     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
607         return address(uint160(_packedOwnershipOf(tokenId)));
608     }
609 
610     /**
611      * @dev Gas spent here starts off proportional to the maximum mint batch size.
612      * It gradually moves to O(1) as tokens get transferred around over time.
613      */
614     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
615         return _unpackedOwnership(_packedOwnershipOf(tokenId));
616     }
617 
618     /**
619      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
620      */
621     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
622         return _unpackedOwnership(_packedOwnerships[index]);
623     }
624 
625     /**
626      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
627      */
628     function _initializeOwnershipAt(uint256 index) internal virtual {
629         if (_packedOwnerships[index] == 0) {
630             _packedOwnerships[index] = _packedOwnershipOf(index);
631         }
632     }
633 
634     /**
635      * Returns the packed ownership data of `tokenId`.
636      */
637     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
638         uint256 curr = tokenId;
639 
640         unchecked {
641             if (_startTokenId() <= curr)
642                 if (curr < _currentIndex) {
643                     uint256 packed = _packedOwnerships[curr];
644                     // If not burned.
645                     if (packed & _BITMASK_BURNED == 0) {
646                         // Invariant:
647                         // There will always be an initialized ownership slot
648                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
649                         // before an unintialized ownership slot
650                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
651                         // Hence, `curr` will not underflow.
652                         //
653                         // We can directly compare the packed value.
654                         // If the address is zero, packed will be zero.
655                         while (packed == 0) {
656                             packed = _packedOwnerships[--curr];
657                         }
658                         return packed;
659                     }
660                 }
661         }
662         revert OwnerQueryForNonexistentToken();
663     }
664 
665     /**
666      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
667      */
668     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
669         ownership.addr = address(uint160(packed));
670         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
671         ownership.burned = packed & _BITMASK_BURNED != 0;
672         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
673     }
674 
675     /**
676      * @dev Packs ownership data into a single uint256.
677      */
678     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
679         assembly {
680             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
681             owner := and(owner, _BITMASK_ADDRESS)
682             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
683             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
684         }
685     }
686 
687     /**
688      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
689      */
690     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
691         // For branchless setting of the `nextInitialized` flag.
692         assembly {
693             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
694             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
695         }
696     }
697 
698     // =============================================================
699     //                      APPROVAL OPERATIONS
700     // =============================================================
701 
702     /**
703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
704      * The approval is cleared when the token is transferred.
705      *
706      * Only a single account can be approved at a time, so approving the
707      * zero address clears previous approvals.
708      *
709      * Requirements:
710      *
711      * - The caller must own the token or be an approved operator.
712      * - `tokenId` must exist.
713      *
714      * Emits an {Approval} event.
715      */
716     function approve(address to, uint256 tokenId) public virtual override {
717         address owner = ownerOf(tokenId);
718 
719         if (_msgSenderERC721A() != owner)
720             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
721                 revert ApprovalCallerNotOwnerNorApproved();
722             }
723 
724         _tokenApprovals[tokenId].value = to;
725         emit Approval(owner, to, tokenId);
726     }
727 
728     /**
729      * @dev Returns the account approved for `tokenId` token.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      */
735     function getApproved(uint256 tokenId) public view virtual override returns (address) {
736         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
737 
738         return _tokenApprovals[tokenId].value;
739     }
740 
741     /**
742      * @dev Approve or remove `operator` as an operator for the caller.
743      * Operators can call {transferFrom} or {safeTransferFrom}
744      * for any token owned by the caller.
745      *
746      * Requirements:
747      *
748      * - The `operator` cannot be the caller.
749      *
750      * Emits an {ApprovalForAll} event.
751      */
752     function setApprovalForAll(address operator, bool approved) public virtual override {
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
807         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
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
836 
837         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
838 
839         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
840 
841         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
842 
843         // The nested ifs save around 20+ gas over a compound boolean condition.
844         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
845             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
846 
847         if (to == address(0)) revert TransferToZeroAddress();
848 
849         _beforeTokenTransfers(from, to, tokenId, 1);
850 
851         // Clear approvals from the previous owner.
852         assembly {
853             if approvedAddress {
854                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
855                 sstore(approvedAddressSlot, 0)
856             }
857         }
858 
859         // Underflow of the sender's balance is impossible because we check for
860         // ownership above and the recipient's balance can't realistically overflow.
861         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
862         unchecked {
863             // We can directly increment and decrement the balances.
864             --_packedAddressData[from]; // Updates: `balance -= 1`.
865             ++_packedAddressData[to]; // Updates: `balance += 1`.
866 
867             // Updates:
868             // - `address` to the next owner.
869             // - `startTimestamp` to the timestamp of transfering.
870             // - `burned` to `false`.
871             // - `nextInitialized` to `true`.
872             _packedOwnerships[tokenId] = _packOwnershipData(
873                 to,
874                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
875             );
876 
877             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
878             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
879                 uint256 nextTokenId = tokenId + 1;
880                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
881                 if (_packedOwnerships[nextTokenId] == 0) {
882                     // If the next slot is within bounds.
883                     if (nextTokenId != _currentIndex) {
884                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
885                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
886                     }
887                 }
888             }
889         }
890 
891         emit Transfer(from, to, tokenId);
892         _afterTokenTransfers(from, to, tokenId, 1);
893     }
894 
895     /**
896      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) public virtual override {
903         safeTransferFrom(from, to, tokenId, '');
904     }
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
926     ) public virtual override {
927         transferFrom(from, to, tokenId);
928         if (to.code.length != 0)
929             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
930                 revert TransferToNonERC721ReceiverImplementer();
931             }
932     }
933 
934     /**
935      * @dev Hook that is called before a set of serially-ordered token IDs
936      * are about to be transferred. This includes minting.
937      * And also called before burning one token.
938      *
939      * `startTokenId` - the first token ID to be transferred.
940      * `quantity` - the amount to be transferred.
941      *
942      * Calling conditions:
943      *
944      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
945      * transferred to `to`.
946      * - When `from` is zero, `tokenId` will be minted for `to`.
947      * - When `to` is zero, `tokenId` will be burned by `from`.
948      * - `from` and `to` are never both zero.
949      */
950     function _beforeTokenTransfers(
951         address from,
952         address to,
953         uint256 startTokenId,
954         uint256 quantity
955     ) internal virtual {}
956 
957     /**
958      * @dev Hook that is called after a set of serially-ordered token IDs
959      * have been transferred. This includes minting.
960      * And also called after one token has been burned.
961      *
962      * `startTokenId` - the first token ID to be transferred.
963      * `quantity` - the amount to be transferred.
964      *
965      * Calling conditions:
966      *
967      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
968      * transferred to `to`.
969      * - When `from` is zero, `tokenId` has been minted for `to`.
970      * - When `to` is zero, `tokenId` has been burned by `from`.
971      * - `from` and `to` are never both zero.
972      */
973     function _afterTokenTransfers(
974         address from,
975         address to,
976         uint256 startTokenId,
977         uint256 quantity
978     ) internal virtual {}
979 
980     /**
981      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
982      *
983      * `from` - Previous owner of the given token ID.
984      * `to` - Target address that will receive the token.
985      * `tokenId` - Token ID to be transferred.
986      * `_data` - Optional data to send along with the call.
987      *
988      * Returns whether the call correctly returned the expected magic value.
989      */
990     function _checkContractOnERC721Received(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) private returns (bool) {
996         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
997             bytes4 retval
998         ) {
999             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1000         } catch (bytes memory reason) {
1001             if (reason.length == 0) {
1002                 revert TransferToNonERC721ReceiverImplementer();
1003             } else {
1004                 assembly {
1005                     revert(add(32, reason), mload(reason))
1006                 }
1007             }
1008         }
1009     }
1010 
1011     // =============================================================
1012     //                        MINT OPERATIONS
1013     // =============================================================
1014 
1015     /**
1016      * @dev Mints `quantity` tokens and transfers them to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `quantity` must be greater than 0.
1022      *
1023      * Emits a {Transfer} event for each mint.
1024      */
1025     function _mint(address to, uint256 quantity) internal virtual {
1026         uint256 startTokenId = _currentIndex;
1027         if (quantity == 0) revert MintZeroQuantity();
1028 
1029         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1030 
1031         // Overflows are incredibly unrealistic.
1032         // `balance` and `numberMinted` have a maximum limit of 2**64.
1033         // `tokenId` has a maximum limit of 2**256.
1034         unchecked {
1035             // Updates:
1036             // - `balance += quantity`.
1037             // - `numberMinted += quantity`.
1038             //
1039             // We can directly add to the `balance` and `numberMinted`.
1040             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1041 
1042             // Updates:
1043             // - `address` to the owner.
1044             // - `startTimestamp` to the timestamp of minting.
1045             // - `burned` to `false`.
1046             // - `nextInitialized` to `quantity == 1`.
1047             _packedOwnerships[startTokenId] = _packOwnershipData(
1048                 to,
1049                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1050             );
1051 
1052             uint256 toMasked;
1053             uint256 end = startTokenId + quantity;
1054 
1055             // Use assembly to loop and emit the `Transfer` event for gas savings.
1056             // The duplicated `log4` removes an extra check and reduces stack juggling.
1057             // The assembly, together with the surrounding Solidity code, have been
1058             // delicately arranged to nudge the compiler into producing optimized opcodes.
1059             assembly {
1060                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1061                 toMasked := and(to, _BITMASK_ADDRESS)
1062                 // Emit the `Transfer` event.
1063                 log4(
1064                     0, // Start of data (0, since no data).
1065                     0, // End of data (0, since no data).
1066                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1067                     0, // `address(0)`.
1068                     toMasked, // `to`.
1069                     startTokenId // `tokenId`.
1070                 )
1071 
1072                 for {
1073                     let tokenId := add(startTokenId, 1)
1074                 } iszero(eq(tokenId, end)) {
1075                     tokenId := add(tokenId, 1)
1076                 } {
1077                     // Emit the `Transfer` event. Similar to above.
1078                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1079                 }
1080             }
1081             if (toMasked == 0) revert MintToZeroAddress();
1082 
1083             _currentIndex = end;
1084         }
1085         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1086     }
1087 
1088     /**
1089      * @dev Mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * This function is intended for efficient minting only during contract creation.
1092      *
1093      * It emits only one {ConsecutiveTransfer} as defined in
1094      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1095      * instead of a sequence of {Transfer} event(s).
1096      *
1097      * Calling this function outside of contract creation WILL make your contract
1098      * non-compliant with the ERC721 standard.
1099      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1100      * {ConsecutiveTransfer} event is only permissible during contract creation.
1101      *
1102      * Requirements:
1103      *
1104      * - `to` cannot be the zero address.
1105      * - `quantity` must be greater than 0.
1106      *
1107      * Emits a {ConsecutiveTransfer} event.
1108      */
1109     function _mintERC2309(address to, uint256 quantity) internal virtual {
1110         uint256 startTokenId = _currentIndex;
1111         if (to == address(0)) revert MintToZeroAddress();
1112         if (quantity == 0) revert MintZeroQuantity();
1113         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1114 
1115         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1116 
1117         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1118         unchecked {
1119             // Updates:
1120             // - `balance += quantity`.
1121             // - `numberMinted += quantity`.
1122             //
1123             // We can directly add to the `balance` and `numberMinted`.
1124             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1125 
1126             // Updates:
1127             // - `address` to the owner.
1128             // - `startTimestamp` to the timestamp of minting.
1129             // - `burned` to `false`.
1130             // - `nextInitialized` to `quantity == 1`.
1131             _packedOwnerships[startTokenId] = _packOwnershipData(
1132                 to,
1133                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1134             );
1135 
1136             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1137 
1138             _currentIndex = startTokenId + quantity;
1139         }
1140         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1141     }
1142 
1143     /**
1144      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - If `to` refers to a smart contract, it must implement
1149      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1150      * - `quantity` must be greater than 0.
1151      *
1152      * See {_mint}.
1153      *
1154      * Emits a {Transfer} event for each mint.
1155      */
1156     function _safeMint(
1157         address to,
1158         uint256 quantity,
1159         bytes memory _data
1160     ) internal virtual {
1161         _mint(to, quantity);
1162 
1163         unchecked {
1164             if (to.code.length != 0) {
1165                 uint256 end = _currentIndex;
1166                 uint256 index = end - quantity;
1167                 do {
1168                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1169                         revert TransferToNonERC721ReceiverImplementer();
1170                     }
1171                 } while (index < end);
1172                 // Reentrancy protection.
1173                 if (_currentIndex != end) revert();
1174             }
1175         }
1176     }
1177 
1178     /**
1179      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1180      */
1181     function _safeMint(address to, uint256 quantity) internal virtual {
1182         _safeMint(to, quantity, '');
1183     }
1184 
1185     // =============================================================
1186     //                        BURN OPERATIONS
1187     // =============================================================
1188 
1189     /**
1190      * @dev Equivalent to `_burn(tokenId, false)`.
1191      */
1192     function _burn(uint256 tokenId) internal virtual {
1193         _burn(tokenId, false);
1194     }
1195 
1196     /**
1197      * @dev Destroys `tokenId`.
1198      * The approval is cleared when the token is burned.
1199      *
1200      * Requirements:
1201      *
1202      * - `tokenId` must exist.
1203      *
1204      * Emits a {Transfer} event.
1205      */
1206     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1207         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1208 
1209         address from = address(uint160(prevOwnershipPacked));
1210 
1211         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1212 
1213         if (approvalCheck) {
1214             // The nested ifs save around 20+ gas over a compound boolean condition.
1215             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1216                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1217         }
1218 
1219         _beforeTokenTransfers(from, address(0), tokenId, 1);
1220 
1221         // Clear approvals from the previous owner.
1222         assembly {
1223             if approvedAddress {
1224                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1225                 sstore(approvedAddressSlot, 0)
1226             }
1227         }
1228 
1229         // Underflow of the sender's balance is impossible because we check for
1230         // ownership above and the recipient's balance can't realistically overflow.
1231         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1232         unchecked {
1233             // Updates:
1234             // - `balance -= 1`.
1235             // - `numberBurned += 1`.
1236             //
1237             // We can directly decrement the balance, and increment the number burned.
1238             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1239             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1240 
1241             // Updates:
1242             // - `address` to the last owner.
1243             // - `startTimestamp` to the timestamp of burning.
1244             // - `burned` to `true`.
1245             // - `nextInitialized` to `true`.
1246             _packedOwnerships[tokenId] = _packOwnershipData(
1247                 from,
1248                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1249             );
1250 
1251             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1252             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1253                 uint256 nextTokenId = tokenId + 1;
1254                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1255                 if (_packedOwnerships[nextTokenId] == 0) {
1256                     // If the next slot is within bounds.
1257                     if (nextTokenId != _currentIndex) {
1258                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1259                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1260                     }
1261                 }
1262             }
1263         }
1264 
1265         emit Transfer(from, address(0), tokenId);
1266         _afterTokenTransfers(from, address(0), tokenId, 1);
1267 
1268         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1269         unchecked {
1270             _burnCounter++;
1271         }
1272     }
1273 
1274     // =============================================================
1275     //                     EXTRA DATA OPERATIONS
1276     // =============================================================
1277 
1278     /**
1279      * @dev Directly sets the extra data for the ownership data `index`.
1280      */
1281     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1282         uint256 packed = _packedOwnerships[index];
1283         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1284         uint256 extraDataCasted;
1285         // Cast `extraData` with assembly to avoid redundant masking.
1286         assembly {
1287             extraDataCasted := extraData
1288         }
1289         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1290         _packedOwnerships[index] = packed;
1291     }
1292 
1293     /**
1294      * @dev Called during each token transfer to set the 24bit `extraData` field.
1295      * Intended to be overridden by the cosumer contract.
1296      *
1297      * `previousExtraData` - the value of `extraData` before transfer.
1298      *
1299      * Calling conditions:
1300      *
1301      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1302      * transferred to `to`.
1303      * - When `from` is zero, `tokenId` will be minted for `to`.
1304      * - When `to` is zero, `tokenId` will be burned by `from`.
1305      * - `from` and `to` are never both zero.
1306      */
1307     function _extraData(
1308         address from,
1309         address to,
1310         uint24 previousExtraData
1311     ) internal view virtual returns (uint24) {}
1312 
1313     /**
1314      * @dev Returns the next extra data for the packed ownership data.
1315      * The returned result is shifted into position.
1316      */
1317     function _nextExtraData(
1318         address from,
1319         address to,
1320         uint256 prevOwnershipPacked
1321     ) private view returns (uint256) {
1322         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1323         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1324     }
1325 
1326     // =============================================================
1327     //                       OTHER OPERATIONS
1328     // =============================================================
1329 
1330     /**
1331      * @dev Returns the message sender (defaults to `msg.sender`).
1332      *
1333      * If you are writing GSN compatible contracts, you need to override this function.
1334      */
1335     function _msgSenderERC721A() internal view virtual returns (address) {
1336         return msg.sender;
1337     }
1338 
1339     /**
1340      * @dev Converts a uint256 to its ASCII string decimal representation.
1341      */
1342     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1343         assembly {
1344             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1345             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1346             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1347             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1348             let m := add(mload(0x40), 0xa0)
1349             // Update the free memory pointer to allocate.
1350             mstore(0x40, m)
1351             // Assign the `str` to the end.
1352             str := sub(m, 0x20)
1353             // Zeroize the slot after the string.
1354             mstore(str, 0)
1355 
1356             // Cache the end of the memory to calculate the length later.
1357             let end := str
1358 
1359             // We write the string from rightmost digit to leftmost digit.
1360             // The following is essentially a do-while loop that also handles the zero case.
1361             // prettier-ignore
1362             for { let temp := value } 1 {} {
1363                 str := sub(str, 1)
1364                 // Write the character to the pointer.
1365                 // The ASCII index of the '0' character is 48.
1366                 mstore8(str, add(48, mod(temp, 10)))
1367                 // Keep dividing `temp` until zero.
1368                 temp := div(temp, 10)
1369                 // prettier-ignore
1370                 if iszero(temp) { break }
1371             }
1372 
1373             let length := sub(end, str)
1374             // Move the pointer 32 bytes leftwards to make room for the length.
1375             str := sub(str, 0x20)
1376             // Store the length.
1377             mstore(str, length)
1378         }
1379     }
1380 }
1381 
1382 
1383 library Base64 {
1384     /**
1385      * @dev Base64 Encoding/Decoding Table
1386      */
1387     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1388 
1389     /**
1390      * @dev Converts a `bytes` to its Bytes64 `string` representation.
1391      */
1392     function encode(bytes memory data) internal pure returns (string memory) {
1393         /**
1394          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
1395          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
1396          */
1397         if (data.length == 0) return "";
1398 
1399         // Loads the table into memory
1400         string memory table = _TABLE;
1401 
1402         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
1403         // and split into 4 numbers of 6 bits.
1404         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
1405         // - `data.length + 2`  -> Round up
1406         // - `/ 3`              -> Number of 3-bytes chunks
1407         // - `4 *`              -> 4 characters for each chunk
1408         string memory result = new string(4 * ((data.length + 2) / 3));
1409 
1410         /// @solidity memory-safe-assembly
1411         assembly {
1412             // Prepare the lookup table (skip the first "length" byte)
1413             let tablePtr := add(table, 1)
1414 
1415             // Prepare result pointer, jump over length
1416             let resultPtr := add(result, 32)
1417 
1418             // Run over the input, 3 bytes at a time
1419             for {
1420                 let dataPtr := data
1421                 let endPtr := add(data, mload(data))
1422             } lt(dataPtr, endPtr) {
1423 
1424             } {
1425                 // Advance 3 bytes
1426                 dataPtr := add(dataPtr, 3)
1427                 let input := mload(dataPtr)
1428 
1429                 // To write each character, shift the 3 bytes (18 bits) chunk
1430                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
1431                 // and apply logical AND with 0x3F which is the number of
1432                 // the previous character in the ASCII table prior to the Base64 Table
1433                 // The result is then added to the table to get the character to write,
1434                 // and finally write it in the result pointer but with a left shift
1435                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
1436 
1437                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1438                 resultPtr := add(resultPtr, 1) // Advance
1439 
1440                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1441                 resultPtr := add(resultPtr, 1) // Advance
1442 
1443                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
1444                 resultPtr := add(resultPtr, 1) // Advance
1445 
1446                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
1447                 resultPtr := add(resultPtr, 1) // Advance
1448             }
1449 
1450             // When data `bytes` is not exactly 3 bytes long
1451             // it is padded with `=` characters at the end
1452             switch mod(mload(data), 3)
1453             case 1 {
1454                 mstore8(sub(resultPtr, 1), 0x3d)
1455                 mstore8(sub(resultPtr, 2), 0x3d)
1456             }
1457             case 2 {
1458                 mstore8(sub(resultPtr, 1), 0x3d)
1459             }
1460         }
1461 
1462         return result;
1463     }
1464 }
1465 
1466 
1467 contract CodedEth is ERC721A{
1468 
1469 	error Penalty();
1470     mapping(address => mapping(uint256 => uint256)) public votes;
1471 
1472     uint256 public VOTES_THRESH = 3;
1473     uint256 public constant MAX_WALLET_MINT = 100;
1474     uint256 public constant MAX_FREE_MINT_PER_WALLET = 1;
1475     uint256 public constant MAX_SUPPLY = 2233;
1476     uint256 public constant COST = 0.002 ether;
1477 
1478     constructor() ERC721A("CodedEth","CODETH"){}
1479 
1480     function freeMint() public payable{
1481         uint256 amount = 1;
1482         require(totalSupply()+amount <= MAX_SUPPLY-275);
1483         require(_numberMinted(msg.sender)+amount <= MAX_FREE_MINT_PER_WALLET);
1484         _mint(msg.sender, amount);
1485     }
1486 
1487     function mint(uint256 amount) public payable{
1488         require(totalSupply()+amount <= MAX_SUPPLY);
1489         require(_numberMinted(msg.sender)+amount <= MAX_WALLET_MINT);
1490         require(COST*amount <= msg.value);
1491         _mint(msg.sender, amount);
1492     }
1493 
1494     function daySinceEpoche() public view returns (uint256){
1495         uint256 s = block.timestamp;
1496         return s / (60*60*24);
1497     }
1498 
1499     function voteSingle(uint256 tokenId) external {
1500         address user = ownerOf(tokenId);
1501         votes[user][daySinceEpoche()]++;
1502     }
1503 
1504     function voteMany(uint256[] memory ids) external {
1505         for(uint256 i=0; i < ids.length; i++){
1506             uint256 tokenId = ids[i];
1507             address user = ownerOf(tokenId);
1508             votes[user][daySinceEpoche()]++;
1509         }
1510     }
1511 
1512     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1513         if(votes[owner][daySinceEpoche()]>=VOTES_THRESH){ return false; }
1514         return _operatorApprovals[owner][operator];
1515     }
1516 
1517 	function transferFrom(
1518         address from,
1519         address to,
1520         uint256 tokenId
1521     ) public virtual override {
1522         votes[to][daySinceEpoche()] += votes[from][daySinceEpoche()];
1523         super.transferFrom(from, to, tokenId);
1524     }
1525 
1526 	// HELPER
1527 
1528 	function substring(string memory str, uint startIndex, uint endIndex) internal view returns (string memory) { 
1529         bytes memory strBytes = bytes(str); 
1530         bytes memory result = new bytes(endIndex-startIndex); 
1531         for(uint i = startIndex; i < endIndex; i++) 
1532         {
1533             result[i-startIndex] = strBytes[i]; 
1534         } 
1535         return string(result); 
1536     }
1537 
1538    
1539     function random(uint256 nonce) public view returns (bytes32){
1540         return keccak256(abi.encodePacked(nonce));
1541     }
1542 
1543     function getAttributes(uint256 tokenId) public view returns(uint256, uint256, uint256, uint256, uint256){
1544         bytes5 r = bytes5(random(tokenId));
1545 
1546         uint256 r_base = uint8(r[0])%8;
1547         uint256 r_body = uint8(r[1])%14;
1548         uint256 r_aura = uint8(r[2])%14;
1549         uint256 r_bodysize = uint8(r[3])%300;
1550         uint256 r_aurasize = uint8(r[4])%50;
1551 
1552         return (r_base, r_body, r_aura, r_bodysize, r_aurasize);
1553     }
1554 
1555     function int2Color(string memory colors, uint256 value) public view returns (string memory){
1556 		return substring(colors, value*7, (value+1)*7);
1557 	}
1558  
1559     function render(uint256 _tokenId) internal view returns (string memory) {
1560 		string memory primary = "#705c74#e8e4a4#f0942c#18e4b4#787434#a8e4f4#3a677e#d0cccc";
1561 		string memory secondary = "#80643c#6c4428#60544c#b87c04#f4fcc8#c8b49c#f8949c#848c88#0854a4#a00c0c#f8ecec#60844c#ed0454#f4d204";
1562 
1563 		(uint256 r_base, uint256 r_body, uint256 r_aura, uint256 r_bodysize, uint256 r_aurasize) = getAttributes(_tokenId);
1564 
1565 
1566         string memory base = int2Color(primary, r_base);
1567         string memory body = int2Color(secondary, r_body);
1568         string memory aura = int2Color(secondary, r_aura);
1569 		string memory size = _toString(100 + r_bodysize);
1570 		string memory sizep = _toString(100 + r_bodysize + r_aurasize);
1571 
1572         return string.concat(
1573 			'<svg xmlns="http://www.w3.org/2000/svg" id="x" preserveAspectRatio="xMinYMin meet" viewBox="0 0 1000 1000">',
1574 			'<filter id="blur">',
1575 			'<feGaussianBlur in="SourceGraphic" stdDeviation="0.5" />',
1576 			'</filter>',
1577 			'<rect fill="',base,'" width="1000" height="1000" filter="url(#blur)"/>',
1578 			'<circle cx="500" cy="500" r="',sizep,'" fill="',aura,'" filter="url(#blur)" />',
1579 			'<circle cx="500" cy="500" r="',size,'" fill="',body,'" filter="url(#blur)" />',
1580 			'</svg>',
1581 			''
1582         );
1583     }
1584 
1585     function tokenURI(uint256 _tokenId)
1586         public
1587         view
1588         override
1589         returns (string memory)
1590     {
1591         require(_exists(_tokenId), "token does not exists");
1592 
1593         string memory svg = string(abi.encodePacked(render(_tokenId)));
1594         string memory json = Base64.encode(
1595             abi.encodePacked(
1596 				'{"name": "CodedEth #',_toString(_tokenId),'"',
1597 				',"description":"CodedEth Experiment, enjoy"',
1598                 ',"image": "data:image/svg+xml;base64,', Base64.encode(bytes(svg)), '"}'
1599             )
1600         );
1601 
1602         return string(abi.encodePacked("data:application/json;base64,", json));
1603     }
1604 
1605     function contractURI() public view returns (string memory) {
1606         return 'ipfs://QmQLGBffZvD79jdfP6joN1z9hmDUf7WGxhifE9cLL8UkeP';
1607     }
1608 }