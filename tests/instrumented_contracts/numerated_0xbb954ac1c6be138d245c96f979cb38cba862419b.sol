1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 /**
6  * @dev Interface of ERC721A.
7  */
8 interface IERC721A {
9     /**
10      * The caller must own the token or be an approved operator.
11      */
12     error ApprovalCallerNotOwnerNorApproved();
13 
14     /**
15      * The token does not exist.
16      */
17     error ApprovalQueryForNonexistentToken();
18 
19     /**
20      * The caller cannot approve to their own address.
21      */
22     error ApproveToCaller();
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
315     // Reference type for token approval.
316     struct TokenApprovalRef {
317         address value;
318     }
319 
320     // =============================================================
321     //                           CONSTANTS
322     // =============================================================
323 
324     // Mask of an entry in packed address data.
325     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
326 
327     // The bit position of `numberMinted` in packed address data.
328     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
329 
330     // The bit position of `numberBurned` in packed address data.
331     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
332 
333     // The bit position of `aux` in packed address data.
334     uint256 private constant _BITPOS_AUX = 192;
335 
336     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
337     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
338 
339     // The bit position of `startTimestamp` in packed ownership.
340     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
341 
342     // The bit mask of the `burned` bit in packed ownership.
343     uint256 private constant _BITMASK_BURNED = 1 << 224;
344 
345     // The bit position of the `nextInitialized` bit in packed ownership.
346     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
347 
348     // The bit mask of the `nextInitialized` bit in packed ownership.
349     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
350 
351     // The bit position of `extraData` in packed ownership.
352     uint256 private constant _BITPOS_EXTRA_DATA = 232;
353 
354     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
355     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
356 
357     // The mask of the lower 160 bits for addresses.
358     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
359 
360     // The maximum `quantity` that can be minted with {_mintERC2309}.
361     // This limit is to prevent overflows on the address data entries.
362     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
363     // is required to cause an overflow, which is unrealistic.
364     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
365 
366     // The `Transfer` event signature is given by:
367     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
368     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
369         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
370 
371     // =============================================================
372     //                            STORAGE
373     // =============================================================
374 
375     // The next token ID to be minted.
376     uint256 private _currentIndex;
377 
378     // The number of tokens burned.
379     uint256 private _burnCounter;
380 
381     // Token name
382     string private _name;
383 
384     // Token symbol
385     string private _symbol;
386 
387     // Mapping from token ID to ownership details
388     // An empty struct value does not necessarily mean the token is unowned.
389     // See {_packedOwnershipOf} implementation for details.
390     //
391     // Bits Layout:
392     // - [0..159]   `addr`
393     // - [160..223] `startTimestamp`
394     // - [224]      `burned`
395     // - [225]      `nextInitialized`
396     // - [232..255] `extraData`
397     mapping(uint256 => uint256) private _packedOwnerships;
398 
399     // Mapping owner address to address data.
400     //
401     // Bits Layout:
402     // - [0..63]    `balance`
403     // - [64..127]  `numberMinted`
404     // - [128..191] `numberBurned`
405     // - [192..255] `aux`
406     mapping(address => uint256) private _packedAddressData;
407 
408     // Mapping from token ID to approved address.
409     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
410 
411     // Mapping from owner to operator approvals
412     mapping(address => mapping(address => bool)) private _operatorApprovals;
413 
414     // =============================================================
415     //                          CONSTRUCTOR
416     // =============================================================
417 
418     constructor(string memory name_, string memory symbol_) {
419         _name = name_;
420         _symbol = symbol_;
421         _currentIndex = _startTokenId();
422     }
423 
424     // =============================================================
425     //                   TOKEN COUNTING OPERATIONS
426     // =============================================================
427 
428     /**
429      * @dev Returns the starting token ID.
430      * To change the starting token ID, please override this function.
431      */
432     function _startTokenId() internal view virtual returns (uint256) {
433         return 0;
434     }
435 
436     /**
437      * @dev Returns the next token ID to be minted.
438      */
439     function _nextTokenId() internal view virtual returns (uint256) {
440         return _currentIndex;
441     }
442 
443     /**
444      * @dev Returns the total number of tokens in existence.
445      * Burned tokens will reduce the count.
446      * To get the total number of tokens minted, please see {_totalMinted}.
447      */
448     function totalSupply() public view virtual override returns (uint256) {
449         // Counter underflow is impossible as _burnCounter cannot be incremented
450         // more than `_currentIndex - _startTokenId()` times.
451         unchecked {
452             return _currentIndex - _burnCounter - _startTokenId();
453         }
454     }
455 
456     /**
457      * @dev Returns the total amount of tokens minted in the contract.
458      */
459     function _totalMinted() internal view virtual returns (uint256) {
460         // Counter underflow is impossible as `_currentIndex` does not decrement,
461         // and it is initialized to `_startTokenId()`.
462         unchecked {
463             return _currentIndex - _startTokenId();
464         }
465     }
466 
467     /**
468      * @dev Returns the total number of tokens burned.
469      */
470     function _totalBurned() internal view virtual returns (uint256) {
471         return _burnCounter;
472     }
473 
474     // =============================================================
475     //                    ADDRESS DATA OPERATIONS
476     // =============================================================
477 
478     /**
479      * @dev Returns the number of tokens in `owner`'s account.
480      */
481     function balanceOf(address owner) public view virtual override returns (uint256) {
482         if (owner == address(0)) revert BalanceQueryForZeroAddress();
483         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
484     }
485 
486     /**
487      * Returns the number of tokens minted by `owner`.
488      */
489     function _numberMinted(address owner) internal view returns (uint256) {
490         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
491     }
492 
493     /**
494      * Returns the number of tokens burned by or on behalf of `owner`.
495      */
496     function _numberBurned(address owner) internal view returns (uint256) {
497         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
498     }
499 
500     /**
501      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
502      */
503     function _getAux(address owner) internal view returns (uint64) {
504         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
505     }
506 
507     /**
508      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
509      * If there are multiple variables, please pack them into a uint64.
510      */
511     function _setAux(address owner, uint64 aux) internal virtual {
512         uint256 packed = _packedAddressData[owner];
513         uint256 auxCasted;
514         // Cast `aux` with assembly to avoid redundant masking.
515         assembly {
516             auxCasted := aux
517         }
518         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
519         _packedAddressData[owner] = packed;
520     }
521 
522     // =============================================================
523     //                            IERC165
524     // =============================================================
525 
526     /**
527      * @dev Returns true if this contract implements the interface defined by
528      * `interfaceId`. See the corresponding
529      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
530      * to learn more about how these ids are created.
531      *
532      * This function call must use less than 30000 gas.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         // The interface IDs are constants representing the first 4 bytes
536         // of the XOR of all function selectors in the interface.
537         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
538         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
539         return
540             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
541             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
542             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
543     }
544 
545     // =============================================================
546     //                        IERC721Metadata
547     // =============================================================
548 
549     /**
550      * @dev Returns the token collection name.
551      */
552     function name() public view virtual override returns (string memory) {
553         return _name;
554     }
555 
556     /**
557      * @dev Returns the token collection symbol.
558      */
559     function symbol() public view virtual override returns (string memory) {
560         return _symbol;
561     }
562 
563     /**
564      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
565      */
566     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
567         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
568 
569         string memory baseURI = _baseURI();
570         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
571     }
572 
573     /**
574      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
575      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
576      * by default, it can be overridden in child contracts.
577      */
578     function _baseURI() internal view virtual returns (string memory) {
579         return '';
580     }
581 
582     // =============================================================
583     //                     OWNERSHIPS OPERATIONS
584     // =============================================================
585 
586     /**
587      * @dev Returns the owner of the `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
594         return address(uint160(_packedOwnershipOf(tokenId)));
595     }
596 
597     /**
598      * @dev Gas spent here starts off proportional to the maximum mint batch size.
599      * It gradually moves to O(1) as tokens get transferred around over time.
600      */
601     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
602         return _unpackedOwnership(_packedOwnershipOf(tokenId));
603     }
604 
605     /**
606      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
607      */
608     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
609         return _unpackedOwnership(_packedOwnerships[index]);
610     }
611 
612     /**
613      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
614      */
615     function _initializeOwnershipAt(uint256 index) internal virtual {
616         if (_packedOwnerships[index] == 0) {
617             _packedOwnerships[index] = _packedOwnershipOf(index);
618         }
619     }
620 
621     /**
622      * Returns the packed ownership data of `tokenId`.
623      */
624     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
625         uint256 curr = tokenId;
626 
627         unchecked {
628             if (_startTokenId() <= curr)
629                 if (curr < _currentIndex) {
630                     uint256 packed = _packedOwnerships[curr];
631                     // If not burned.
632                     if (packed & _BITMASK_BURNED == 0) {
633                         // Invariant:
634                         // There will always be an initialized ownership slot
635                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
636                         // before an unintialized ownership slot
637                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
638                         // Hence, `curr` will not underflow.
639                         //
640                         // We can directly compare the packed value.
641                         // If the address is zero, packed will be zero.
642                         while (packed == 0) {
643                             packed = _packedOwnerships[--curr];
644                         }
645                         return packed;
646                     }
647                 }
648         }
649         revert OwnerQueryForNonexistentToken();
650     }
651 
652     /**
653      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
654      */
655     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
656         ownership.addr = address(uint160(packed));
657         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
658         ownership.burned = packed & _BITMASK_BURNED != 0;
659         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
660     }
661 
662     /**
663      * @dev Packs ownership data into a single uint256.
664      */
665     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
666         assembly {
667             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
668             owner := and(owner, _BITMASK_ADDRESS)
669             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
670             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
671         }
672     }
673 
674     /**
675      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
676      */
677     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
678         // For branchless setting of the `nextInitialized` flag.
679         assembly {
680             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
681             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
682         }
683     }
684 
685     // =============================================================
686     //                      APPROVAL OPERATIONS
687     // =============================================================
688 
689     /**
690      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
691      * The approval is cleared when the token is transferred.
692      *
693      * Only a single account can be approved at a time, so approving the
694      * zero address clears previous approvals.
695      *
696      * Requirements:
697      *
698      * - The caller must own the token or be an approved operator.
699      * - `tokenId` must exist.
700      *
701      * Emits an {Approval} event.
702      */
703     function approve(address to, uint256 tokenId) public virtual override {
704         address owner = ownerOf(tokenId);
705 
706         if (_msgSenderERC721A() != owner)
707             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
708                 revert ApprovalCallerNotOwnerNorApproved();
709             }
710 
711         _tokenApprovals[tokenId].value = to;
712         emit Approval(owner, to, tokenId);
713     }
714 
715     /**
716      * @dev Returns the account approved for `tokenId` token.
717      *
718      * Requirements:
719      *
720      * - `tokenId` must exist.
721      */
722     function getApproved(uint256 tokenId) public view virtual override returns (address) {
723         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
724 
725         return _tokenApprovals[tokenId].value;
726     }
727 
728     /**
729      * @dev Approve or remove `operator` as an operator for the caller.
730      * Operators can call {transferFrom} or {safeTransferFrom}
731      * for any token owned by the caller.
732      *
733      * Requirements:
734      *
735      * - The `operator` cannot be the caller.
736      *
737      * Emits an {ApprovalForAll} event.
738      */
739     function setApprovalForAll(address operator, bool approved) public virtual override {
740         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
741 
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
796         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
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
824     ) public virtual override {
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
883     /**
884      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         safeTransferFrom(from, to, tokenId, '');
892     }
893 
894     /**
895      * @dev Safely transfers `tokenId` token from `from` to `to`.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must exist and be owned by `from`.
902      * - If the caller is not `from`, it must be approved to move this token
903      * by either {approve} or {setApprovalForAll}.
904      * - If `to` refers to a smart contract, it must implement
905      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
906      *
907      * Emits a {Transfer} event.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) public virtual override {
915         transferFrom(from, to, tokenId);
916         if (to.code.length != 0)
917             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
918                 revert TransferToNonERC721ReceiverImplementer();
919             }
920     }
921 
922     /**
923      * @dev Hook that is called before a set of serially-ordered token IDs
924      * are about to be transferred. This includes minting.
925      * And also called before burning one token.
926      *
927      * `startTokenId` - the first token ID to be transferred.
928      * `quantity` - the amount to be transferred.
929      *
930      * Calling conditions:
931      *
932      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
933      * transferred to `to`.
934      * - When `from` is zero, `tokenId` will be minted for `to`.
935      * - When `to` is zero, `tokenId` will be burned by `from`.
936      * - `from` and `to` are never both zero.
937      */
938     function _beforeTokenTransfers(
939         address from,
940         address to,
941         uint256 startTokenId,
942         uint256 quantity
943     ) internal virtual {}
944 
945     /**
946      * @dev Hook that is called after a set of serially-ordered token IDs
947      * have been transferred. This includes minting.
948      * And also called after one token has been burned.
949      *
950      * `startTokenId` - the first token ID to be transferred.
951      * `quantity` - the amount to be transferred.
952      *
953      * Calling conditions:
954      *
955      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
956      * transferred to `to`.
957      * - When `from` is zero, `tokenId` has been minted for `to`.
958      * - When `to` is zero, `tokenId` has been burned by `from`.
959      * - `from` and `to` are never both zero.
960      */
961     function _afterTokenTransfers(
962         address from,
963         address to,
964         uint256 startTokenId,
965         uint256 quantity
966     ) internal virtual {}
967 
968     /**
969      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
970      *
971      * `from` - Previous owner of the given token ID.
972      * `to` - Target address that will receive the token.
973      * `tokenId` - Token ID to be transferred.
974      * `_data` - Optional data to send along with the call.
975      *
976      * Returns whether the call correctly returned the expected magic value.
977      */
978     function _checkContractOnERC721Received(
979         address from,
980         address to,
981         uint256 tokenId,
982         bytes memory _data
983     ) private returns (bool) {
984         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
985             bytes4 retval
986         ) {
987             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
988         } catch (bytes memory reason) {
989             if (reason.length == 0) {
990                 revert TransferToNonERC721ReceiverImplementer();
991             } else {
992                 assembly {
993                     revert(add(32, reason), mload(reason))
994                 }
995             }
996         }
997     }
998 
999     // =============================================================
1000     //                        MINT OPERATIONS
1001     // =============================================================
1002 
1003     /**
1004      * @dev Mints `quantity` tokens and transfers them to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `to` cannot be the zero address.
1009      * - `quantity` must be greater than 0.
1010      *
1011      * Emits a {Transfer} event for each mint.
1012      */
1013     function _mint(address to, uint256 quantity) internal virtual {
1014         uint256 startTokenId = _currentIndex;
1015         if (quantity == 0) revert MintZeroQuantity();
1016 
1017         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1018 
1019         // Overflows are incredibly unrealistic.
1020         // `balance` and `numberMinted` have a maximum limit of 2**64.
1021         // `tokenId` has a maximum limit of 2**256.
1022         unchecked {
1023             // Updates:
1024             // - `balance += quantity`.
1025             // - `numberMinted += quantity`.
1026             //
1027             // We can directly add to the `balance` and `numberMinted`.
1028             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1029 
1030             // Updates:
1031             // - `address` to the owner.
1032             // - `startTimestamp` to the timestamp of minting.
1033             // - `burned` to `false`.
1034             // - `nextInitialized` to `quantity == 1`.
1035             _packedOwnerships[startTokenId] = _packOwnershipData(
1036                 to,
1037                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1038             );
1039 
1040             uint256 toMasked;
1041             uint256 end = startTokenId + quantity;
1042 
1043             // Use assembly to loop and emit the `Transfer` event for gas savings.
1044             assembly {
1045                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1046                 toMasked := and(to, _BITMASK_ADDRESS)
1047                 // Emit the `Transfer` event.
1048                 log4(
1049                     0, // Start of data (0, since no data).
1050                     0, // End of data (0, since no data).
1051                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1052                     0, // `address(0)`.
1053                     toMasked, // `to`.
1054                     startTokenId // `tokenId`.
1055                 )
1056 
1057                 for {
1058                     let tokenId := add(startTokenId, 1)
1059                 } iszero(eq(tokenId, end)) {
1060                     tokenId := add(tokenId, 1)
1061                 } {
1062                     // Emit the `Transfer` event. Similar to above.
1063                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1064                 }
1065             }
1066             if (toMasked == 0) revert MintToZeroAddress();
1067 
1068             _currentIndex = end;
1069         }
1070         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1071     }
1072 
1073     /**
1074      * @dev Mints `quantity` tokens and transfers them to `to`.
1075      *
1076      * This function is intended for efficient minting only during contract creation.
1077      *
1078      * It emits only one {ConsecutiveTransfer} as defined in
1079      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1080      * instead of a sequence of {Transfer} event(s).
1081      *
1082      * Calling this function outside of contract creation WILL make your contract
1083      * non-compliant with the ERC721 standard.
1084      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1085      * {ConsecutiveTransfer} event is only permissible during contract creation.
1086      *
1087      * Requirements:
1088      *
1089      * - `to` cannot be the zero address.
1090      * - `quantity` must be greater than 0.
1091      *
1092      * Emits a {ConsecutiveTransfer} event.
1093      */
1094     function _mintERC2309(address to, uint256 quantity) internal virtual {
1095         uint256 startTokenId = _currentIndex;
1096         if (to == address(0)) revert MintToZeroAddress();
1097         if (quantity == 0) revert MintZeroQuantity();
1098         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1099 
1100         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1101 
1102         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1103         unchecked {
1104             // Updates:
1105             // - `balance += quantity`.
1106             // - `numberMinted += quantity`.
1107             //
1108             // We can directly add to the `balance` and `numberMinted`.
1109             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1110 
1111             // Updates:
1112             // - `address` to the owner.
1113             // - `startTimestamp` to the timestamp of minting.
1114             // - `burned` to `false`.
1115             // - `nextInitialized` to `quantity == 1`.
1116             _packedOwnerships[startTokenId] = _packOwnershipData(
1117                 to,
1118                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1119             );
1120 
1121             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1122 
1123             _currentIndex = startTokenId + quantity;
1124         }
1125         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1126     }
1127 
1128     /**
1129      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1130      *
1131      * Requirements:
1132      *
1133      * - If `to` refers to a smart contract, it must implement
1134      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1135      * - `quantity` must be greater than 0.
1136      *
1137      * See {_mint}.
1138      *
1139      * Emits a {Transfer} event for each mint.
1140      */
1141     function _safeMint(
1142         address to,
1143         uint256 quantity,
1144         bytes memory _data
1145     ) internal virtual {
1146         _mint(to, quantity);
1147 
1148         unchecked {
1149             if (to.code.length != 0) {
1150                 uint256 end = _currentIndex;
1151                 uint256 index = end - quantity;
1152                 do {
1153                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1154                         revert TransferToNonERC721ReceiverImplementer();
1155                     }
1156                 } while (index < end);
1157                 // Reentrancy protection.
1158                 if (_currentIndex != end) revert();
1159             }
1160         }
1161     }
1162 
1163     /**
1164      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1165      */
1166     function _safeMint(address to, uint256 quantity) internal virtual {
1167         _safeMint(to, quantity, '');
1168     }
1169 
1170     // =============================================================
1171     //                        BURN OPERATIONS
1172     // =============================================================
1173 
1174     /**
1175      * @dev Equivalent to `_burn(tokenId, false)`.
1176      */
1177     function _burn(uint256 tokenId) internal virtual {
1178         _burn(tokenId, false);
1179     }
1180 
1181     /**
1182      * @dev Destroys `tokenId`.
1183      * The approval is cleared when the token is burned.
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must exist.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1192         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1193 
1194         address from = address(uint160(prevOwnershipPacked));
1195 
1196         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1197 
1198         if (approvalCheck) {
1199             // The nested ifs save around 20+ gas over a compound boolean condition.
1200             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1201                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1202         }
1203 
1204         _beforeTokenTransfers(from, address(0), tokenId, 1);
1205 
1206         // Clear approvals from the previous owner.
1207         assembly {
1208             if approvedAddress {
1209                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1210                 sstore(approvedAddressSlot, 0)
1211             }
1212         }
1213 
1214         // Underflow of the sender's balance is impossible because we check for
1215         // ownership above and the recipient's balance can't realistically overflow.
1216         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1217         unchecked {
1218             // Updates:
1219             // - `balance -= 1`.
1220             // - `numberBurned += 1`.
1221             //
1222             // We can directly decrement the balance, and increment the number burned.
1223             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1224             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1225 
1226             // Updates:
1227             // - `address` to the last owner.
1228             // - `startTimestamp` to the timestamp of burning.
1229             // - `burned` to `true`.
1230             // - `nextInitialized` to `true`.
1231             _packedOwnerships[tokenId] = _packOwnershipData(
1232                 from,
1233                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1234             );
1235 
1236             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1237             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1238                 uint256 nextTokenId = tokenId + 1;
1239                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1240                 if (_packedOwnerships[nextTokenId] == 0) {
1241                     // If the next slot is within bounds.
1242                     if (nextTokenId != _currentIndex) {
1243                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1244                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1245                     }
1246                 }
1247             }
1248         }
1249 
1250         emit Transfer(from, address(0), tokenId);
1251         _afterTokenTransfers(from, address(0), tokenId, 1);
1252 
1253         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1254         unchecked {
1255             _burnCounter++;
1256         }
1257     }
1258 
1259     // =============================================================
1260     //                     EXTRA DATA OPERATIONS
1261     // =============================================================
1262 
1263     /**
1264      * @dev Directly sets the extra data for the ownership data `index`.
1265      */
1266     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1267         uint256 packed = _packedOwnerships[index];
1268         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1269         uint256 extraDataCasted;
1270         // Cast `extraData` with assembly to avoid redundant masking.
1271         assembly {
1272             extraDataCasted := extraData
1273         }
1274         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1275         _packedOwnerships[index] = packed;
1276     }
1277 
1278     /**
1279      * @dev Called during each token transfer to set the 24bit `extraData` field.
1280      * Intended to be overridden by the cosumer contract.
1281      *
1282      * `previousExtraData` - the value of `extraData` before transfer.
1283      *
1284      * Calling conditions:
1285      *
1286      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1287      * transferred to `to`.
1288      * - When `from` is zero, `tokenId` will be minted for `to`.
1289      * - When `to` is zero, `tokenId` will be burned by `from`.
1290      * - `from` and `to` are never both zero.
1291      */
1292     function _extraData(
1293         address from,
1294         address to,
1295         uint24 previousExtraData
1296     ) internal view virtual returns (uint24) {}
1297 
1298     /**
1299      * @dev Returns the next extra data for the packed ownership data.
1300      * The returned result is shifted into position.
1301      */
1302     function _nextExtraData(
1303         address from,
1304         address to,
1305         uint256 prevOwnershipPacked
1306     ) private view returns (uint256) {
1307         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1308         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1309     }
1310 
1311     // =============================================================
1312     //                       OTHER OPERATIONS
1313     // =============================================================
1314 
1315     /**
1316      * @dev Returns the message sender (defaults to `msg.sender`).
1317      *
1318      * If you are writing GSN compatible contracts, you need to override this function.
1319      */
1320     function _msgSenderERC721A() internal view virtual returns (address) {
1321         return msg.sender;
1322     }
1323 
1324     /**
1325      * @dev Converts a uint256 to its ASCII string decimal representation.
1326      */
1327     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1328         assembly {
1329             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1330             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1331             // We will need 1 32-byte word to store the length,
1332             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1333             ptr := add(mload(0x40), 128)
1334             // Update the free memory pointer to allocate.
1335             mstore(0x40, ptr)
1336 
1337             // Cache the end of the memory to calculate the length later.
1338             let end := ptr
1339 
1340             // We write the string from the rightmost digit to the leftmost digit.
1341             // The following is essentially a do-while loop that also handles the zero case.
1342             // Costs a bit more than early returning for the zero case,
1343             // but cheaper in terms of deployment and overall runtime costs.
1344             for {
1345                 // Initialize and perform the first pass without check.
1346                 let temp := value
1347                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1348                 ptr := sub(ptr, 1)
1349                 // Write the character to the pointer.
1350                 // The ASCII index of the '0' character is 48.
1351                 mstore8(ptr, add(48, mod(temp, 10)))
1352                 temp := div(temp, 10)
1353             } temp {
1354                 // Keep dividing `temp` until zero.
1355                 temp := div(temp, 10)
1356             } {
1357                 // Body of the for loop.
1358                 ptr := sub(ptr, 1)
1359                 mstore8(ptr, add(48, mod(temp, 10)))
1360             }
1361 
1362             let length := sub(end, ptr)
1363             // Move the pointer 32 bytes leftwards to make room for the length.
1364             ptr := sub(ptr, 32)
1365             // Store the length.
1366             mstore(ptr, length)
1367         }
1368     }
1369 }
1370 
1371 interface IPurple {
1372     function mintTo(address addr, uint256 amount) external;
1373 }
1374 
1375 contract ThePurple is ERC721A  {
1376     
1377     uint256 public maxSupply;
1378 
1379     uint256 public maxFree;
1380 
1381     uint256 public cost;
1382 
1383     uint256 private maxPerWallet;
1384 
1385     uint256 public freePertx;
1386 
1387     address public owner;
1388 
1389     IPurple public pcoin;
1390 
1391     bool reveal;
1392 
1393     string uri = "ipfs://QmX7vw53hiGFoT4Sc3fhCguPV1uX5YhFYKgE7jgbkL3rmN";
1394     
1395     function mint(uint256 amount) payable public {
1396         require(totalSupply() + amount <= maxSupply);
1397         _mint(amount);
1398     }
1399     
1400     modifier onlyOwner {
1401         require(owner == msg.sender);
1402         _;
1403     }
1404 
1405     constructor(address coin) ERC721A("The Purple", "Purple") {
1406         owner = msg.sender;
1407         maxFree = 2000;
1408         maxSupply = 5555;
1409         cost = 0.002 ether;
1410         maxPerWallet = 5;
1411         freePertx = 5;
1412         pcoin = IPurple(coin);
1413     }
1414 
1415     function _mint(uint256 amount) internal {
1416         if (msg.value == 0) {
1417             require(msg.sender == tx.origin);
1418             require(amount <= freePertx);
1419             require(totalSupply() + amount <= maxFree);
1420             require(balanceOf(msg.sender) < maxPerWallet);
1421             _safeMint(msg.sender, amount);
1422             pcoin.mintTo(msg.sender, 100000);
1423             return;
1424         } 
1425         require(msg.value >= cost * amount);
1426         _safeMint(msg.sender, amount);
1427         pcoin.mintTo(msg.sender, amount * 100000);
1428     }
1429 
1430 
1431     function setUri(string memory i) onlyOwner public  {
1432         uri = i;
1433     }
1434 
1435     function setCost(uint256 c) onlyOwner public  {
1436         cost = c;
1437     }
1438 
1439     function rev() onlyOwner public  {
1440         reveal = !reveal;
1441     }
1442 
1443     function setUpConfig(uint256 f, uint256 t, uint256 m) onlyOwner public  {
1444         freePertx = f;
1445         maxFree = t;
1446         maxSupply = m;
1447     }
1448 
1449     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1450         if (!reveal) {
1451             return uri;
1452         }
1453         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1454     }
1455 
1456     function withdraw() external onlyOwner {
1457         payable(msg.sender).transfer(address(this).balance);
1458     }
1459 }