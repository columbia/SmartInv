1 // SPDX-License-Identifier: MIT
2 
3 // File: erc721a/contracts/IERC721A.sol
4 
5 
6 // ERC721A Contracts v4.2.2
7 // Creator: Chiru Labs
8 
9 pragma solidity ^0.8.4;
10 
11 /**
12  * @dev Interface of ERC721A.
13  */
14 interface IERC721A {
15     /**
16      * The caller must own the token or be an approved operator.
17      */
18     error ApprovalCallerNotOwnerNorApproved();
19 
20     /**
21      * The token does not exist.
22      */
23     error ApprovalQueryForNonexistentToken();
24 
25     /**
26      * The caller cannot approve to their own address.
27      */
28     error ApproveToCaller();
29 
30     /**
31      * Cannot query the balance for the zero address.
32      */
33     error BalanceQueryForZeroAddress();
34 
35     /**
36      * Cannot mint to the zero address.
37      */
38     error MintToZeroAddress();
39 
40     /**
41      * The quantity of tokens minted must be more than zero.
42      */
43     error MintZeroQuantity();
44 
45     /**
46      * The token does not exist.
47      */
48     error OwnerQueryForNonexistentToken();
49 
50     /**
51      * The caller must own the token or be an approved operator.
52      */
53     error TransferCallerNotOwnerNorApproved();
54 
55     /**
56      * The token must be owned by `from`.
57      */
58     error TransferFromIncorrectOwner();
59 
60     /**
61      * Cannot safely transfer to a contract that does not implement the
62      * ERC721Receiver interface.
63      */
64     error TransferToNonERC721ReceiverImplementer();
65 
66     /**
67      * Cannot transfer to the zero address.
68      */
69     error TransferToZeroAddress();
70 
71     /**
72      * The token does not exist.
73      */
74     error URIQueryForNonexistentToken();
75 
76     /**
77      * The `quantity` minted with ERC2309 exceeds the safety limit.
78      */
79     error MintERC2309QuantityExceedsLimit();
80 
81     /**
82      * The `extraData` cannot be set on an unintialized ownership slot.
83      */
84     error OwnershipNotInitializedForExtraData();
85 
86     // =============================================================
87     //                            STRUCTS
88     // =============================================================
89 
90     struct TokenOwnership {
91         // The address of the owner.
92         address addr;
93         // Stores the start time of ownership with minimal overhead for tokenomics.
94         uint64 startTimestamp;
95         // Whether the token has been burned.
96         bool burned;
97         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
98         uint24 extraData;
99     }
100 
101     // =============================================================
102     //                         TOKEN COUNTERS
103     // =============================================================
104 
105     /**
106      * @dev Returns the total number of tokens in existence.
107      * Burned tokens will reduce the count.
108      * To get the total number of tokens minted, please see {_totalMinted}.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     // =============================================================
113     //                            IERC165
114     // =============================================================
115 
116     /**
117      * @dev Returns true if this contract implements the interface defined by
118      * `interfaceId`. See the corresponding
119      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
120      * to learn more about how these ids are created.
121      *
122      * This function call must use less than 30000 gas.
123      */
124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
125 
126     // =============================================================
127     //                            IERC721
128     // =============================================================
129 
130     /**
131      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
137      */
138     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
139 
140     /**
141      * @dev Emitted when `owner` enables or disables
142      * (`approved`) `operator` to manage all of its assets.
143      */
144     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
145 
146     /**
147      * @dev Returns the number of tokens in `owner`'s account.
148      */
149     function balanceOf(address owner) external view returns (uint256 balance);
150 
151     /**
152      * @dev Returns the owner of the `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function ownerOf(uint256 tokenId) external view returns (address owner);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`,
162      * checking first that contract recipients are aware of the ERC721 protocol
163      * to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move
171      * this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement
173      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId,
181         bytes calldata data
182     ) external;
183 
184     /**
185      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external;
192 
193     /**
194      * @dev Transfers `tokenId` from `from` to `to`.
195      *
196      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
197      * whenever possible.
198      *
199      * Requirements:
200      *
201      * - `from` cannot be the zero address.
202      * - `to` cannot be the zero address.
203      * - `tokenId` token must be owned by `from`.
204      * - If the caller is not `from`, it must be approved to move this token
205      * by either {approve} or {setApprovalForAll}.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address from,
211         address to,
212         uint256 tokenId
213     ) external;
214 
215     /**
216      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
217      * The approval is cleared when the token is transferred.
218      *
219      * Only a single account can be approved at a time, so approving the
220      * zero address clears previous approvals.
221      *
222      * Requirements:
223      *
224      * - The caller must own the token or be an approved operator.
225      * - `tokenId` must exist.
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address to, uint256 tokenId) external;
230 
231     /**
232      * @dev Approve or remove `operator` as an operator for the caller.
233      * Operators can call {transferFrom} or {safeTransferFrom}
234      * for any token owned by the caller.
235      *
236      * Requirements:
237      *
238      * - The `operator` cannot be the caller.
239      *
240      * Emits an {ApprovalForAll} event.
241      */
242     function setApprovalForAll(address operator, bool _approved) external;
243 
244     /**
245      * @dev Returns the account approved for `tokenId` token.
246      *
247      * Requirements:
248      *
249      * - `tokenId` must exist.
250      */
251     function getApproved(uint256 tokenId) external view returns (address operator);
252 
253     /**
254      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
255      *
256      * See {setApprovalForAll}.
257      */
258     function isApprovedForAll(address owner, address operator) external view returns (bool);
259 
260     // =============================================================
261     //                        IERC721Metadata
262     // =============================================================
263 
264     /**
265      * @dev Returns the token collection name.
266      */
267     function name() external view returns (string memory);
268 
269     /**
270      * @dev Returns the token collection symbol.
271      */
272     function symbol() external view returns (string memory);
273 
274     /**
275      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
276      */
277     function tokenURI(uint256 tokenId) external view returns (string memory);
278 
279     // =============================================================
280     //                           IERC2309
281     // =============================================================
282 
283     /**
284      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
285      * (inclusive) is transferred from `from` to `to`, as defined in the
286      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
287      *
288      * See {_mintERC2309} for more details.
289      */
290     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
291 }
292 
293 // File: erc721a/contracts/ERC721A.sol
294 
295 
296 // ERC721A Contracts v4.2.2
297 // Creator: Chiru Labs
298 
299 pragma solidity ^0.8.4;
300 
301 
302 /**
303  * @dev Interface of ERC721 token receiver.
304  */
305 interface ERC721A__IERC721Receiver {
306     function onERC721Received(
307         address operator,
308         address from,
309         uint256 tokenId,
310         bytes calldata data
311     ) external returns (bytes4);
312 }
313 
314 /**
315  * @title ERC721A
316  *
317  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
318  * Non-Fungible Token Standard, including the Metadata extension.
319  * Optimized for lower gas during batch mints.
320  *
321  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
322  * starting from `_startTokenId()`.
323  *
324  * Assumptions:
325  *
326  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
327  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
328  */
329 contract ERC721A is IERC721A {
330     // Reference type for token approval.
331     struct TokenApprovalRef {
332         address value;
333     }
334 
335     // =============================================================
336     //                           CONSTANTS
337     // =============================================================
338 
339     // Mask of an entry in packed address data.
340     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
341 
342     // The bit position of `numberMinted` in packed address data.
343     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
344 
345     // The bit position of `numberBurned` in packed address data.
346     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
347 
348     // The bit position of `aux` in packed address data.
349     uint256 private constant _BITPOS_AUX = 192;
350 
351     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
352     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
353 
354     // The bit position of `startTimestamp` in packed ownership.
355     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
356 
357     // The bit mask of the `burned` bit in packed ownership.
358     uint256 private constant _BITMASK_BURNED = 1 << 224;
359 
360     // The bit position of the `nextInitialized` bit in packed ownership.
361     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
362 
363     // The bit mask of the `nextInitialized` bit in packed ownership.
364     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
365 
366     // The bit position of `extraData` in packed ownership.
367     uint256 private constant _BITPOS_EXTRA_DATA = 232;
368 
369     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
370     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
371 
372     // The mask of the lower 160 bits for addresses.
373     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
374 
375     // The maximum `quantity` that can be minted with {_mintERC2309}.
376     // This limit is to prevent overflows on the address data entries.
377     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
378     // is required to cause an overflow, which is unrealistic.
379     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
380 
381     // The `Transfer` event signature is given by:
382     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
383     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
384         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
385 
386     // =============================================================
387     //                            STORAGE
388     // =============================================================
389 
390     // The next token ID to be minted.
391     uint256 private _currentIndex;
392 
393     // The number of tokens burned.
394     uint256 private _burnCounter;
395 
396     // Token name
397     string private _name;
398 
399     // Token symbol
400     string private _symbol;
401 
402     // Mapping from token ID to ownership details
403     // An empty struct value does not necessarily mean the token is unowned.
404     // See {_packedOwnershipOf} implementation for details.
405     //
406     // Bits Layout:
407     // - [0..159]   `addr`
408     // - [160..223] `startTimestamp`
409     // - [224]      `burned`
410     // - [225]      `nextInitialized`
411     // - [232..255] `extraData`
412     mapping(uint256 => uint256) private _packedOwnerships;
413 
414     // Mapping owner address to address data.
415     //
416     // Bits Layout:
417     // - [0..63]    `balance`
418     // - [64..127]  `numberMinted`
419     // - [128..191] `numberBurned`
420     // - [192..255] `aux`
421     mapping(address => uint256) private _packedAddressData;
422 
423     // Mapping from token ID to approved address.
424     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
425 
426     // Mapping from owner to operator approvals
427     mapping(address => mapping(address => bool)) private _operatorApprovals;
428 
429     // =============================================================
430     //                          CONSTRUCTOR
431     // =============================================================
432 
433     constructor(string memory name_, string memory symbol_) {
434         _name = name_;
435         _symbol = symbol_;
436         _currentIndex = _startTokenId();
437     }
438 
439     // =============================================================
440     //                   TOKEN COUNTING OPERATIONS
441     // =============================================================
442 
443     /**
444      * @dev Returns the starting token ID.
445      * To change the starting token ID, please override this function.
446      */
447     function _startTokenId() internal view virtual returns (uint256) {
448         return 0;
449     }
450 
451     /**
452      * @dev Returns the next token ID to be minted.
453      */
454     function _nextTokenId() internal view virtual returns (uint256) {
455         return _currentIndex;
456     }
457 
458     /**
459      * @dev Returns the total number of tokens in existence.
460      * Burned tokens will reduce the count.
461      * To get the total number of tokens minted, please see {_totalMinted}.
462      */
463     function totalSupply() public view virtual override returns (uint256) {
464         // Counter underflow is impossible as _burnCounter cannot be incremented
465         // more than `_currentIndex - _startTokenId()` times.
466         unchecked {
467             return _currentIndex - _burnCounter - _startTokenId();
468         }
469     }
470 
471     /**
472      * @dev Returns the total amount of tokens minted in the contract.
473      */
474     function _totalMinted() internal view virtual returns (uint256) {
475         // Counter underflow is impossible as `_currentIndex` does not decrement,
476         // and it is initialized to `_startTokenId()`.
477         unchecked {
478             return _currentIndex - _startTokenId();
479         }
480     }
481 
482     /**
483      * @dev Returns the total number of tokens burned.
484      */
485     function _totalBurned() internal view virtual returns (uint256) {
486         return _burnCounter;
487     }
488 
489     // =============================================================
490     //                    ADDRESS DATA OPERATIONS
491     // =============================================================
492 
493     /**
494      * @dev Returns the number of tokens in `owner`'s account.
495      */
496     function balanceOf(address owner) public view virtual override returns (uint256) {
497         if (owner == address(0)) revert BalanceQueryForZeroAddress();
498         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
499     }
500 
501     /**
502      * Returns the number of tokens minted by `owner`.
503      */
504     function _numberMinted(address owner) internal view returns (uint256) {
505         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
506     }
507 
508     /**
509      * Returns the number of tokens burned by or on behalf of `owner`.
510      */
511     function _numberBurned(address owner) internal view returns (uint256) {
512         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
513     }
514 
515     /**
516      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
517      */
518     function _getAux(address owner) internal view returns (uint64) {
519         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
520     }
521 
522     /**
523      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
524      * If there are multiple variables, please pack them into a uint64.
525      */
526     function _setAux(address owner, uint64 aux) internal virtual {
527         uint256 packed = _packedAddressData[owner];
528         uint256 auxCasted;
529         // Cast `aux` with assembly to avoid redundant masking.
530         assembly {
531             auxCasted := aux
532         }
533         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
534         _packedAddressData[owner] = packed;
535     }
536 
537     // =============================================================
538     //                            IERC165
539     // =============================================================
540 
541     /**
542      * @dev Returns true if this contract implements the interface defined by
543      * `interfaceId`. See the corresponding
544      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
545      * to learn more about how these ids are created.
546      *
547      * This function call must use less than 30000 gas.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         // The interface IDs are constants representing the first 4 bytes
551         // of the XOR of all function selectors in the interface.
552         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
553         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
554         return
555             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
556             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
557             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
558     }
559 
560     // =============================================================
561     //                        IERC721Metadata
562     // =============================================================
563 
564     /**
565      * @dev Returns the token collection name.
566      */
567     function name() public view virtual override returns (string memory) {
568         return _name;
569     }
570 
571     /**
572      * @dev Returns the token collection symbol.
573      */
574     function symbol() public view virtual override returns (string memory) {
575         return _symbol;
576     }
577 
578     /**
579      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
580      */
581     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
582         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
583 
584         string memory baseURI = _baseURI();
585         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
586     }
587 
588     /**
589      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
590      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
591      * by default, it can be overridden in child contracts.
592      */
593     function _baseURI() internal view virtual returns (string memory) {
594         return '';
595     }
596 
597     // =============================================================
598     //                     OWNERSHIPS OPERATIONS
599     // =============================================================
600 
601     /**
602      * @dev Returns the owner of the `tokenId` token.
603      *
604      * Requirements:
605      *
606      * - `tokenId` must exist.
607      */
608     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
609         return address(uint160(_packedOwnershipOf(tokenId)));
610     }
611 
612     /**
613      * @dev Gas spent here starts off proportional to the maximum mint batch size.
614      * It gradually moves to O(1) as tokens get transferred around over time.
615      */
616     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
617         return _unpackedOwnership(_packedOwnershipOf(tokenId));
618     }
619 
620     /**
621      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
622      */
623     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
624         return _unpackedOwnership(_packedOwnerships[index]);
625     }
626 
627     /**
628      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
629      */
630     function _initializeOwnershipAt(uint256 index) internal virtual {
631         if (_packedOwnerships[index] == 0) {
632             _packedOwnerships[index] = _packedOwnershipOf(index);
633         }
634     }
635 
636     /**
637      * Returns the packed ownership data of `tokenId`.
638      */
639     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
640         uint256 curr = tokenId;
641 
642         unchecked {
643             if (_startTokenId() <= curr)
644                 if (curr < _currentIndex) {
645                     uint256 packed = _packedOwnerships[curr];
646                     // If not burned.
647                     if (packed & _BITMASK_BURNED == 0) {
648                         // Invariant:
649                         // There will always be an initialized ownership slot
650                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
651                         // before an unintialized ownership slot
652                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
653                         // Hence, `curr` will not underflow.
654                         //
655                         // We can directly compare the packed value.
656                         // If the address is zero, packed will be zero.
657                         while (packed == 0) {
658                             packed = _packedOwnerships[--curr];
659                         }
660                         return packed;
661                     }
662                 }
663         }
664         revert OwnerQueryForNonexistentToken();
665     }
666 
667     /**
668      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
669      */
670     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
671         ownership.addr = address(uint160(packed));
672         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
673         ownership.burned = packed & _BITMASK_BURNED != 0;
674         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
675     }
676 
677     /**
678      * @dev Packs ownership data into a single uint256.
679      */
680     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
681         assembly {
682             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
683             owner := and(owner, _BITMASK_ADDRESS)
684             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
685             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
686         }
687     }
688 
689     /**
690      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
691      */
692     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
693         // For branchless setting of the `nextInitialized` flag.
694         assembly {
695             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
696             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
697         }
698     }
699 
700     // =============================================================
701     //                      APPROVAL OPERATIONS
702     // =============================================================
703 
704     /**
705      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
706      * The approval is cleared when the token is transferred.
707      *
708      * Only a single account can be approved at a time, so approving the
709      * zero address clears previous approvals.
710      *
711      * Requirements:
712      *
713      * - The caller must own the token or be an approved operator.
714      * - `tokenId` must exist.
715      *
716      * Emits an {Approval} event.
717      */
718     function approve(address to, uint256 tokenId) public virtual override {
719         address owner = ownerOf(tokenId);
720 
721         if (_msgSenderERC721A() != owner)
722             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
723                 revert ApprovalCallerNotOwnerNorApproved();
724             }
725 
726         _tokenApprovals[tokenId].value = to;
727         emit Approval(owner, to, tokenId);
728     }
729 
730     /**
731      * @dev Returns the account approved for `tokenId` token.
732      *
733      * Requirements:
734      *
735      * - `tokenId` must exist.
736      */
737     function getApproved(uint256 tokenId) public view virtual override returns (address) {
738         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
739 
740         return _tokenApprovals[tokenId].value;
741     }
742 
743     /**
744      * @dev Approve or remove `operator` as an operator for the caller.
745      * Operators can call {transferFrom} or {safeTransferFrom}
746      * for any token owned by the caller.
747      *
748      * Requirements:
749      *
750      * - The `operator` cannot be the caller.
751      *
752      * Emits an {ApprovalForAll} event.
753      */
754     function setApprovalForAll(address operator, bool approved) public virtual override {
755         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
756 
757         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
758         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
759     }
760 
761     /**
762      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
763      *
764      * See {setApprovalForAll}.
765      */
766     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
767         return _operatorApprovals[owner][operator];
768     }
769 
770     /**
771      * @dev Returns whether `tokenId` exists.
772      *
773      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
774      *
775      * Tokens start existing when they are minted. See {_mint}.
776      */
777     function _exists(uint256 tokenId) internal view virtual returns (bool) {
778         return
779             _startTokenId() <= tokenId &&
780             tokenId < _currentIndex && // If within bounds,
781             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
782     }
783 
784     /**
785      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
786      */
787     function _isSenderApprovedOrOwner(
788         address approvedAddress,
789         address owner,
790         address msgSender
791     ) private pure returns (bool result) {
792         assembly {
793             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
794             owner := and(owner, _BITMASK_ADDRESS)
795             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
796             msgSender := and(msgSender, _BITMASK_ADDRESS)
797             // `msgSender == owner || msgSender == approvedAddress`.
798             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
799         }
800     }
801 
802     /**
803      * @dev Returns the storage slot and value for the approved address of `tokenId`.
804      */
805     function _getApprovedSlotAndAddress(uint256 tokenId)
806         private
807         view
808         returns (uint256 approvedAddressSlot, address approvedAddress)
809     {
810         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
811         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
812         assembly {
813             approvedAddressSlot := tokenApproval.slot
814             approvedAddress := sload(approvedAddressSlot)
815         }
816     }
817 
818     // =============================================================
819     //                      TRANSFER OPERATIONS
820     // =============================================================
821 
822     /**
823      * @dev Transfers `tokenId` from `from` to `to`.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must be owned by `from`.
830      * - If the caller is not `from`, it must be approved to move this token
831      * by either {approve} or {setApprovalForAll}.
832      *
833      * Emits a {Transfer} event.
834      */
835     function transferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) public virtual override {
840         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
841 
842         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
843 
844         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
845 
846         // The nested ifs save around 20+ gas over a compound boolean condition.
847         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
848             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
849 
850         if (to == address(0)) revert TransferToZeroAddress();
851 
852         _beforeTokenTransfers(from, to, tokenId, 1);
853 
854         // Clear approvals from the previous owner.
855         assembly {
856             if approvedAddress {
857                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
858                 sstore(approvedAddressSlot, 0)
859             }
860         }
861 
862         // Underflow of the sender's balance is impossible because we check for
863         // ownership above and the recipient's balance can't realistically overflow.
864         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
865         unchecked {
866             // We can directly increment and decrement the balances.
867             --_packedAddressData[from]; // Updates: `balance -= 1`.
868             ++_packedAddressData[to]; // Updates: `balance += 1`.
869 
870             // Updates:
871             // - `address` to the next owner.
872             // - `startTimestamp` to the timestamp of transfering.
873             // - `burned` to `false`.
874             // - `nextInitialized` to `true`.
875             _packedOwnerships[tokenId] = _packOwnershipData(
876                 to,
877                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
878             );
879 
880             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
881             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
882                 uint256 nextTokenId = tokenId + 1;
883                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
884                 if (_packedOwnerships[nextTokenId] == 0) {
885                     // If the next slot is within bounds.
886                     if (nextTokenId != _currentIndex) {
887                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
888                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
889                     }
890                 }
891             }
892         }
893 
894         emit Transfer(from, to, tokenId);
895         _afterTokenTransfers(from, to, tokenId, 1);
896     }
897 
898     /**
899      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public virtual override {
906         safeTransferFrom(from, to, tokenId, '');
907     }
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must exist and be owned by `from`.
917      * - If the caller is not `from`, it must be approved to move this token
918      * by either {approve} or {setApprovalForAll}.
919      * - If `to` refers to a smart contract, it must implement
920      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
921      *
922      * Emits a {Transfer} event.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId,
928         bytes memory _data
929     ) public virtual override {
930         transferFrom(from, to, tokenId);
931         if (to.code.length != 0)
932             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
933                 revert TransferToNonERC721ReceiverImplementer();
934             }
935     }
936 
937     /**
938      * @dev Hook that is called before a set of serially-ordered token IDs
939      * are about to be transferred. This includes minting.
940      * And also called before burning one token.
941      *
942      * `startTokenId` - the first token ID to be transferred.
943      * `quantity` - the amount to be transferred.
944      *
945      * Calling conditions:
946      *
947      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
948      * transferred to `to`.
949      * - When `from` is zero, `tokenId` will be minted for `to`.
950      * - When `to` is zero, `tokenId` will be burned by `from`.
951      * - `from` and `to` are never both zero.
952      */
953     function _beforeTokenTransfers(
954         address from,
955         address to,
956         uint256 startTokenId,
957         uint256 quantity
958     ) internal virtual {}
959 
960     /**
961      * @dev Hook that is called after a set of serially-ordered token IDs
962      * have been transferred. This includes minting.
963      * And also called after one token has been burned.
964      *
965      * `startTokenId` - the first token ID to be transferred.
966      * `quantity` - the amount to be transferred.
967      *
968      * Calling conditions:
969      *
970      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
971      * transferred to `to`.
972      * - When `from` is zero, `tokenId` has been minted for `to`.
973      * - When `to` is zero, `tokenId` has been burned by `from`.
974      * - `from` and `to` are never both zero.
975      */
976     function _afterTokenTransfers(
977         address from,
978         address to,
979         uint256 startTokenId,
980         uint256 quantity
981     ) internal virtual {}
982 
983     /**
984      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
985      *
986      * `from` - Previous owner of the given token ID.
987      * `to` - Target address that will receive the token.
988      * `tokenId` - Token ID to be transferred.
989      * `_data` - Optional data to send along with the call.
990      *
991      * Returns whether the call correctly returned the expected magic value.
992      */
993     function _checkContractOnERC721Received(
994         address from,
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) private returns (bool) {
999         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1000             bytes4 retval
1001         ) {
1002             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1003         } catch (bytes memory reason) {
1004             if (reason.length == 0) {
1005                 revert TransferToNonERC721ReceiverImplementer();
1006             } else {
1007                 assembly {
1008                     revert(add(32, reason), mload(reason))
1009                 }
1010             }
1011         }
1012     }
1013 
1014     // =============================================================
1015     //                        MINT OPERATIONS
1016     // =============================================================
1017 
1018     /**
1019      * @dev Mints `quantity` tokens and transfers them to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `quantity` must be greater than 0.
1025      *
1026      * Emits a {Transfer} event for each mint.
1027      */
1028     function _mint(address to, uint256 quantity) internal virtual {
1029         uint256 startTokenId = _currentIndex;
1030         if (quantity == 0) revert MintZeroQuantity();
1031 
1032         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1033 
1034         // Overflows are incredibly unrealistic.
1035         // `balance` and `numberMinted` have a maximum limit of 2**64.
1036         // `tokenId` has a maximum limit of 2**256.
1037         unchecked {
1038             // Updates:
1039             // - `balance += quantity`.
1040             // - `numberMinted += quantity`.
1041             //
1042             // We can directly add to the `balance` and `numberMinted`.
1043             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1044 
1045             // Updates:
1046             // - `address` to the owner.
1047             // - `startTimestamp` to the timestamp of minting.
1048             // - `burned` to `false`.
1049             // - `nextInitialized` to `quantity == 1`.
1050             _packedOwnerships[startTokenId] = _packOwnershipData(
1051                 to,
1052                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1053             );
1054 
1055             uint256 toMasked;
1056             uint256 end = startTokenId + quantity;
1057 
1058             // Use assembly to loop and emit the `Transfer` event for gas savings.
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
1344             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1345             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1346             // We will need 1 32-byte word to store the length,
1347             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1348             str := add(mload(0x40), 0x80)
1349             // Update the free memory pointer to allocate.
1350             mstore(0x40, str)
1351 
1352             // Cache the end of the memory to calculate the length later.
1353             let end := str
1354 
1355             // We write the string from rightmost digit to leftmost digit.
1356             // The following is essentially a do-while loop that also handles the zero case.
1357             // prettier-ignore
1358             for { let temp := value } 1 {} {
1359                 str := sub(str, 1)
1360                 // Write the character to the pointer.
1361                 // The ASCII index of the '0' character is 48.
1362                 mstore8(str, add(48, mod(temp, 10)))
1363                 // Keep dividing `temp` until zero.
1364                 temp := div(temp, 10)
1365                 // prettier-ignore
1366                 if iszero(temp) { break }
1367             }
1368 
1369             let length := sub(end, str)
1370             // Move the pointer 32 bytes leftwards to make room for the length.
1371             str := sub(str, 0x20)
1372             // Store the length.
1373             mstore(str, length)
1374         }
1375     }
1376 }
1377 
1378 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1379 
1380 
1381 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1382 
1383 pragma solidity ^0.8.0;
1384 
1385 /**
1386  * @dev These functions deal with verification of Merkle Tree proofs.
1387  *
1388  * The proofs can be generated using the JavaScript library
1389  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1390  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1391  *
1392  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1393  *
1394  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1395  * hashing, or use a hash function other than keccak256 for hashing leaves.
1396  * This is because the concatenation of a sorted pair of internal nodes in
1397  * the merkle tree could be reinterpreted as a leaf value.
1398  */
1399 library MerkleProof {
1400     /**
1401      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1402      * defined by `root`. For this, a `proof` must be provided, containing
1403      * sibling hashes on the branch from the leaf to the root of the tree. Each
1404      * pair of leaves and each pair of pre-images are assumed to be sorted.
1405      */
1406     function verify(
1407         bytes32[] memory proof,
1408         bytes32 root,
1409         bytes32 leaf
1410     ) internal pure returns (bool) {
1411         return processProof(proof, leaf) == root;
1412     }
1413 
1414     /**
1415      * @dev Calldata version of {verify}
1416      *
1417      * _Available since v4.7._
1418      */
1419     function verifyCalldata(
1420         bytes32[] calldata proof,
1421         bytes32 root,
1422         bytes32 leaf
1423     ) internal pure returns (bool) {
1424         return processProofCalldata(proof, leaf) == root;
1425     }
1426 
1427     /**
1428      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1429      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1430      * hash matches the root of the tree. When processing the proof, the pairs
1431      * of leafs & pre-images are assumed to be sorted.
1432      *
1433      * _Available since v4.4._
1434      */
1435     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1436         bytes32 computedHash = leaf;
1437         for (uint256 i = 0; i < proof.length; i++) {
1438             computedHash = _hashPair(computedHash, proof[i]);
1439         }
1440         return computedHash;
1441     }
1442 
1443     /**
1444      * @dev Calldata version of {processProof}
1445      *
1446      * _Available since v4.7._
1447      */
1448     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1449         bytes32 computedHash = leaf;
1450         for (uint256 i = 0; i < proof.length; i++) {
1451             computedHash = _hashPair(computedHash, proof[i]);
1452         }
1453         return computedHash;
1454     }
1455 
1456     /**
1457      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1458      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1459      *
1460      * _Available since v4.7._
1461      */
1462     function multiProofVerify(
1463         bytes32[] memory proof,
1464         bool[] memory proofFlags,
1465         bytes32 root,
1466         bytes32[] memory leaves
1467     ) internal pure returns (bool) {
1468         return processMultiProof(proof, proofFlags, leaves) == root;
1469     }
1470 
1471     /**
1472      * @dev Calldata version of {multiProofVerify}
1473      *
1474      * _Available since v4.7._
1475      */
1476     function multiProofVerifyCalldata(
1477         bytes32[] calldata proof,
1478         bool[] calldata proofFlags,
1479         bytes32 root,
1480         bytes32[] memory leaves
1481     ) internal pure returns (bool) {
1482         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1483     }
1484 
1485     /**
1486      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1487      * consuming from one or the other at each step according to the instructions given by
1488      * `proofFlags`.
1489      *
1490      * _Available since v4.7._
1491      */
1492     function processMultiProof(
1493         bytes32[] memory proof,
1494         bool[] memory proofFlags,
1495         bytes32[] memory leaves
1496     ) internal pure returns (bytes32 merkleRoot) {
1497         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1498         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1499         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1500         // the merkle tree.
1501         uint256 leavesLen = leaves.length;
1502         uint256 totalHashes = proofFlags.length;
1503 
1504         // Check proof validity.
1505         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1506 
1507         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1508         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1509         bytes32[] memory hashes = new bytes32[](totalHashes);
1510         uint256 leafPos = 0;
1511         uint256 hashPos = 0;
1512         uint256 proofPos = 0;
1513         // At each step, we compute the next hash using two values:
1514         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1515         //   get the next hash.
1516         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1517         //   `proof` array.
1518         for (uint256 i = 0; i < totalHashes; i++) {
1519             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1520             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1521             hashes[i] = _hashPair(a, b);
1522         }
1523 
1524         if (totalHashes > 0) {
1525             return hashes[totalHashes - 1];
1526         } else if (leavesLen > 0) {
1527             return leaves[0];
1528         } else {
1529             return proof[0];
1530         }
1531     }
1532 
1533     /**
1534      * @dev Calldata version of {processMultiProof}
1535      *
1536      * _Available since v4.7._
1537      */
1538     function processMultiProofCalldata(
1539         bytes32[] calldata proof,
1540         bool[] calldata proofFlags,
1541         bytes32[] memory leaves
1542     ) internal pure returns (bytes32 merkleRoot) {
1543         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1544         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1545         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1546         // the merkle tree.
1547         uint256 leavesLen = leaves.length;
1548         uint256 totalHashes = proofFlags.length;
1549 
1550         // Check proof validity.
1551         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1552 
1553         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1554         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1555         bytes32[] memory hashes = new bytes32[](totalHashes);
1556         uint256 leafPos = 0;
1557         uint256 hashPos = 0;
1558         uint256 proofPos = 0;
1559         // At each step, we compute the next hash using two values:
1560         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1561         //   get the next hash.
1562         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1563         //   `proof` array.
1564         for (uint256 i = 0; i < totalHashes; i++) {
1565             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1566             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1567             hashes[i] = _hashPair(a, b);
1568         }
1569 
1570         if (totalHashes > 0) {
1571             return hashes[totalHashes - 1];
1572         } else if (leavesLen > 0) {
1573             return leaves[0];
1574         } else {
1575             return proof[0];
1576         }
1577     }
1578 
1579     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1580         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1581     }
1582 
1583     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1584         /// @solidity memory-safe-assembly
1585         assembly {
1586             mstore(0x00, a)
1587             mstore(0x20, b)
1588             value := keccak256(0x00, 0x40)
1589         }
1590     }
1591 }
1592 
1593 // File: @openzeppelin/contracts/utils/Counters.sol
1594 
1595 
1596 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1597 
1598 pragma solidity ^0.8.0;
1599 
1600 /**
1601  * @title Counters
1602  * @author Matt Condon (@shrugs)
1603  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1604  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1605  *
1606  * Include with `using Counters for Counters.Counter;`
1607  */
1608 library Counters {
1609     struct Counter {
1610         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1611         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1612         // this feature: see https://github.com/ethereum/solidity/issues/4637
1613         uint256 _value; // default: 0
1614     }
1615 
1616     function current(Counter storage counter) internal view returns (uint256) {
1617         return counter._value;
1618     }
1619 
1620     function increment(Counter storage counter) internal {
1621         unchecked {
1622             counter._value += 1;
1623         }
1624     }
1625 
1626     function decrement(Counter storage counter) internal {
1627         uint256 value = counter._value;
1628         require(value > 0, "Counter: decrement overflow");
1629         unchecked {
1630             counter._value = value - 1;
1631         }
1632     }
1633 
1634     function reset(Counter storage counter) internal {
1635         counter._value = 0;
1636     }
1637 }
1638 
1639 // File: @openzeppelin/contracts/utils/Strings.sol
1640 
1641 
1642 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1643 
1644 pragma solidity ^0.8.0;
1645 
1646 /**
1647  * @dev String operations.
1648  */
1649 library Strings {
1650     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1651     uint8 private constant _ADDRESS_LENGTH = 20;
1652 
1653     /**
1654      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1655      */
1656     function toString(uint256 value) internal pure returns (string memory) {
1657         // Inspired by OraclizeAPI's implementation - MIT licence
1658         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1659 
1660         if (value == 0) {
1661             return "0";
1662         }
1663         uint256 temp = value;
1664         uint256 digits;
1665         while (temp != 0) {
1666             digits++;
1667             temp /= 10;
1668         }
1669         bytes memory buffer = new bytes(digits);
1670         while (value != 0) {
1671             digits -= 1;
1672             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1673             value /= 10;
1674         }
1675         return string(buffer);
1676     }
1677 
1678     /**
1679      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1680      */
1681     function toHexString(uint256 value) internal pure returns (string memory) {
1682         if (value == 0) {
1683             return "0x00";
1684         }
1685         uint256 temp = value;
1686         uint256 length = 0;
1687         while (temp != 0) {
1688             length++;
1689             temp >>= 8;
1690         }
1691         return toHexString(value, length);
1692     }
1693 
1694     /**
1695      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1696      */
1697     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1698         bytes memory buffer = new bytes(2 * length + 2);
1699         buffer[0] = "0";
1700         buffer[1] = "x";
1701         for (uint256 i = 2 * length + 1; i > 1; --i) {
1702             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1703             value >>= 4;
1704         }
1705         require(value == 0, "Strings: hex length insufficient");
1706         return string(buffer);
1707     }
1708 
1709     /**
1710      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1711      */
1712     function toHexString(address addr) internal pure returns (string memory) {
1713         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1714     }
1715 }
1716 
1717 // File: @openzeppelin/contracts/utils/Context.sol
1718 
1719 
1720 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1721 
1722 pragma solidity ^0.8.0;
1723 
1724 /**
1725  * @dev Provides information about the current execution context, including the
1726  * sender of the transaction and its data. While these are generally available
1727  * via msg.sender and msg.data, they should not be accessed in such a direct
1728  * manner, since when dealing with meta-transactions the account sending and
1729  * paying for execution may not be the actual sender (as far as an application
1730  * is concerned).
1731  *
1732  * This contract is only required for intermediate, library-like contracts.
1733  */
1734 abstract contract Context {
1735     function _msgSender() internal view virtual returns (address) {
1736         return msg.sender;
1737     }
1738 
1739     function _msgData() internal view virtual returns (bytes calldata) {
1740         return msg.data;
1741     }
1742 }
1743 
1744 // File: @openzeppelin/contracts/access/Ownable.sol
1745 
1746 
1747 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1748 
1749 pragma solidity ^0.8.0;
1750 
1751 
1752 /**
1753  * @dev Contract module which provides a basic access control mechanism, where
1754  * there is an account (an owner) that can be granted exclusive access to
1755  * specific functions.
1756  *
1757  * By default, the owner account will be the one that deploys the contract. This
1758  * can later be changed with {transferOwnership}.
1759  *
1760  * This module is used through inheritance. It will make available the modifier
1761  * `onlyOwner`, which can be applied to your functions to restrict their use to
1762  * the owner.
1763  */
1764 abstract contract Ownable is Context {
1765     address private _owner;
1766 
1767     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1768 
1769     /**
1770      * @dev Initializes the contract setting the deployer as the initial owner.
1771      */
1772     constructor() {
1773         _transferOwnership(_msgSender());
1774     }
1775 
1776     /**
1777      * @dev Throws if called by any account other than the owner.
1778      */
1779     modifier onlyOwner() {
1780         _checkOwner();
1781         _;
1782     }
1783 
1784     /**
1785      * @dev Returns the address of the current owner.
1786      */
1787     function owner() public view virtual returns (address) {
1788         return _owner;
1789     }
1790 
1791     /**
1792      * @dev Throws if the sender is not the owner.
1793      */
1794     function _checkOwner() internal view virtual {
1795         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1796     }
1797 
1798     /**
1799      * @dev Leaves the contract without owner. It will not be possible to call
1800      * `onlyOwner` functions anymore. Can only be called by the current owner.
1801      *
1802      * NOTE: Renouncing ownership will leave the contract without an owner,
1803      * thereby removing any functionality that is only available to the owner.
1804      */
1805     function renounceOwnership() public virtual onlyOwner {
1806         _transferOwnership(address(0));
1807     }
1808 
1809     /**
1810      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1811      * Can only be called by the current owner.
1812      */
1813     function transferOwnership(address newOwner) public virtual onlyOwner {
1814         require(newOwner != address(0), "Ownable: new owner is the zero address");
1815         _transferOwnership(newOwner);
1816     }
1817 
1818     /**
1819      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1820      * Internal function without access restriction.
1821      */
1822     function _transferOwnership(address newOwner) internal virtual {
1823         address oldOwner = _owner;
1824         _owner = newOwner;
1825         emit OwnershipTransferred(oldOwner, newOwner);
1826     }
1827 }
1828 
1829 // File: @openzeppelin/contracts/utils/Address.sol
1830 
1831 
1832 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1833 
1834 pragma solidity ^0.8.1;
1835 
1836 /**
1837  * @dev Collection of functions related to the address type
1838  */
1839 library Address {
1840     /**
1841      * @dev Returns true if `account` is a contract.
1842      *
1843      * [IMPORTANT]
1844      * ====
1845      * It is unsafe to assume that an address for which this function returns
1846      * false is an externally-owned account (EOA) and not a contract.
1847      *
1848      * Among others, `isContract` will return false for the following
1849      * types of addresses:
1850      *
1851      *  - an externally-owned account
1852      *  - a contract in construction
1853      *  - an address where a contract will be created
1854      *  - an address where a contract lived, but was destroyed
1855      * ====
1856      *
1857      * [IMPORTANT]
1858      * ====
1859      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1860      *
1861      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1862      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1863      * constructor.
1864      * ====
1865      */
1866     function isContract(address account) internal view returns (bool) {
1867         // This method relies on extcodesize/address.code.length, which returns 0
1868         // for contracts in construction, since the code is only stored at the end
1869         // of the constructor execution.
1870 
1871         return account.code.length > 0;
1872     }
1873 
1874     /**
1875      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1876      * `recipient`, forwarding all available gas and reverting on errors.
1877      *
1878      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1879      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1880      * imposed by `transfer`, making them unable to receive funds via
1881      * `transfer`. {sendValue} removes this limitation.
1882      *
1883      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1884      *
1885      * IMPORTANT: because control is transferred to `recipient`, care must be
1886      * taken to not create reentrancy vulnerabilities. Consider using
1887      * {ReentrancyGuard} or the
1888      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1889      */
1890     function sendValue(address payable recipient, uint256 amount) internal {
1891         require(address(this).balance >= amount, "Address: insufficient balance");
1892 
1893         (bool success, ) = recipient.call{value: amount}("");
1894         require(success, "Address: unable to send value, recipient may have reverted");
1895     }
1896 
1897     /**
1898      * @dev Performs a Solidity function call using a low level `call`. A
1899      * plain `call` is an unsafe replacement for a function call: use this
1900      * function instead.
1901      *
1902      * If `target` reverts with a revert reason, it is bubbled up by this
1903      * function (like regular Solidity function calls).
1904      *
1905      * Returns the raw returned data. To convert to the expected return value,
1906      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1907      *
1908      * Requirements:
1909      *
1910      * - `target` must be a contract.
1911      * - calling `target` with `data` must not revert.
1912      *
1913      * _Available since v3.1._
1914      */
1915     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1916         return functionCall(target, data, "Address: low-level call failed");
1917     }
1918 
1919     /**
1920      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1921      * `errorMessage` as a fallback revert reason when `target` reverts.
1922      *
1923      * _Available since v3.1._
1924      */
1925     function functionCall(
1926         address target,
1927         bytes memory data,
1928         string memory errorMessage
1929     ) internal returns (bytes memory) {
1930         return functionCallWithValue(target, data, 0, errorMessage);
1931     }
1932 
1933     /**
1934      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1935      * but also transferring `value` wei to `target`.
1936      *
1937      * Requirements:
1938      *
1939      * - the calling contract must have an ETH balance of at least `value`.
1940      * - the called Solidity function must be `payable`.
1941      *
1942      * _Available since v3.1._
1943      */
1944     function functionCallWithValue(
1945         address target,
1946         bytes memory data,
1947         uint256 value
1948     ) internal returns (bytes memory) {
1949         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1950     }
1951 
1952     /**
1953      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1954      * with `errorMessage` as a fallback revert reason when `target` reverts.
1955      *
1956      * _Available since v3.1._
1957      */
1958     function functionCallWithValue(
1959         address target,
1960         bytes memory data,
1961         uint256 value,
1962         string memory errorMessage
1963     ) internal returns (bytes memory) {
1964         require(address(this).balance >= value, "Address: insufficient balance for call");
1965         require(isContract(target), "Address: call to non-contract");
1966 
1967         (bool success, bytes memory returndata) = target.call{value: value}(data);
1968         return verifyCallResult(success, returndata, errorMessage);
1969     }
1970 
1971     /**
1972      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1973      * but performing a static call.
1974      *
1975      * _Available since v3.3._
1976      */
1977     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1978         return functionStaticCall(target, data, "Address: low-level static call failed");
1979     }
1980 
1981     /**
1982      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1983      * but performing a static call.
1984      *
1985      * _Available since v3.3._
1986      */
1987     function functionStaticCall(
1988         address target,
1989         bytes memory data,
1990         string memory errorMessage
1991     ) internal view returns (bytes memory) {
1992         require(isContract(target), "Address: static call to non-contract");
1993 
1994         (bool success, bytes memory returndata) = target.staticcall(data);
1995         return verifyCallResult(success, returndata, errorMessage);
1996     }
1997 
1998     /**
1999      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2000      * but performing a delegate call.
2001      *
2002      * _Available since v3.4._
2003      */
2004     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2005         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2006     }
2007 
2008     /**
2009      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2010      * but performing a delegate call.
2011      *
2012      * _Available since v3.4._
2013      */
2014     function functionDelegateCall(
2015         address target,
2016         bytes memory data,
2017         string memory errorMessage
2018     ) internal returns (bytes memory) {
2019         require(isContract(target), "Address: delegate call to non-contract");
2020 
2021         (bool success, bytes memory returndata) = target.delegatecall(data);
2022         return verifyCallResult(success, returndata, errorMessage);
2023     }
2024 
2025     /**
2026      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2027      * revert reason using the provided one.
2028      *
2029      * _Available since v4.3._
2030      */
2031     function verifyCallResult(
2032         bool success,
2033         bytes memory returndata,
2034         string memory errorMessage
2035     ) internal pure returns (bytes memory) {
2036         if (success) {
2037             return returndata;
2038         } else {
2039             // Look for revert reason and bubble it up if present
2040             if (returndata.length > 0) {
2041                 // The easiest way to bubble the revert reason is using memory via assembly
2042                 /// @solidity memory-safe-assembly
2043                 assembly {
2044                     let returndata_size := mload(returndata)
2045                     revert(add(32, returndata), returndata_size)
2046                 }
2047             } else {
2048                 revert(errorMessage);
2049             }
2050         }
2051     }
2052 }
2053 
2054 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2055 
2056 
2057 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2058 
2059 pragma solidity ^0.8.0;
2060 
2061 /**
2062  * @title ERC721 token receiver interface
2063  * @dev Interface for any contract that wants to support safeTransfers
2064  * from ERC721 asset contracts.
2065  */
2066 interface IERC721Receiver {
2067     /**
2068      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2069      * by `operator` from `from`, this function is called.
2070      *
2071      * It must return its Solidity selector to confirm the token transfer.
2072      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2073      *
2074      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2075      */
2076     function onERC721Received(
2077         address operator,
2078         address from,
2079         uint256 tokenId,
2080         bytes calldata data
2081     ) external returns (bytes4);
2082 }
2083 
2084 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2085 
2086 
2087 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2088 
2089 pragma solidity ^0.8.0;
2090 
2091 /**
2092  * @dev Interface of the ERC165 standard, as defined in the
2093  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2094  *
2095  * Implementers can declare support of contract interfaces, which can then be
2096  * queried by others ({ERC165Checker}).
2097  *
2098  * For an implementation, see {ERC165}.
2099  */
2100 interface IERC165 {
2101     /**
2102      * @dev Returns true if this contract implements the interface defined by
2103      * `interfaceId`. See the corresponding
2104      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2105      * to learn more about how these ids are created.
2106      *
2107      * This function call must use less than 30 000 gas.
2108      */
2109     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2110 }
2111 
2112 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2113 
2114 
2115 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2116 
2117 pragma solidity ^0.8.0;
2118 
2119 
2120 /**
2121  * @dev Implementation of the {IERC165} interface.
2122  *
2123  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2124  * for the additional interface id that will be supported. For example:
2125  *
2126  * ```solidity
2127  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2128  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2129  * }
2130  * ```
2131  *
2132  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2133  */
2134 abstract contract ERC165 is IERC165 {
2135     /**
2136      * @dev See {IERC165-supportsInterface}.
2137      */
2138     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2139         return interfaceId == type(IERC165).interfaceId;
2140     }
2141 }
2142 
2143 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2144 
2145 
2146 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
2147 
2148 pragma solidity ^0.8.0;
2149 
2150 
2151 /**
2152  * @dev Required interface of an ERC721 compliant contract.
2153  */
2154 interface IERC721 is IERC165 {
2155     /**
2156      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2157      */
2158     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2159 
2160     /**
2161      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2162      */
2163     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2164 
2165     /**
2166      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2167      */
2168     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2169 
2170     /**
2171      * @dev Returns the number of tokens in ``owner``'s account.
2172      */
2173     function balanceOf(address owner) external view returns (uint256 balance);
2174 
2175     /**
2176      * @dev Returns the owner of the `tokenId` token.
2177      *
2178      * Requirements:
2179      *
2180      * - `tokenId` must exist.
2181      */
2182     function ownerOf(uint256 tokenId) external view returns (address owner);
2183 
2184     /**
2185      * @dev Safely transfers `tokenId` token from `from` to `to`.
2186      *
2187      * Requirements:
2188      *
2189      * - `from` cannot be the zero address.
2190      * - `to` cannot be the zero address.
2191      * - `tokenId` token must exist and be owned by `from`.
2192      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2193      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2194      *
2195      * Emits a {Transfer} event.
2196      */
2197     function safeTransferFrom(
2198         address from,
2199         address to,
2200         uint256 tokenId,
2201         bytes calldata data
2202     ) external;
2203 
2204     /**
2205      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2206      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2207      *
2208      * Requirements:
2209      *
2210      * - `from` cannot be the zero address.
2211      * - `to` cannot be the zero address.
2212      * - `tokenId` token must exist and be owned by `from`.
2213      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2214      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2215      *
2216      * Emits a {Transfer} event.
2217      */
2218     function safeTransferFrom(
2219         address from,
2220         address to,
2221         uint256 tokenId
2222     ) external;
2223 
2224     /**
2225      * @dev Transfers `tokenId` token from `from` to `to`.
2226      *
2227      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2228      *
2229      * Requirements:
2230      *
2231      * - `from` cannot be the zero address.
2232      * - `to` cannot be the zero address.
2233      * - `tokenId` token must be owned by `from`.
2234      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2235      *
2236      * Emits a {Transfer} event.
2237      */
2238     function transferFrom(
2239         address from,
2240         address to,
2241         uint256 tokenId
2242     ) external;
2243 
2244     /**
2245      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2246      * The approval is cleared when the token is transferred.
2247      *
2248      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2249      *
2250      * Requirements:
2251      *
2252      * - The caller must own the token or be an approved operator.
2253      * - `tokenId` must exist.
2254      *
2255      * Emits an {Approval} event.
2256      */
2257     function approve(address to, uint256 tokenId) external;
2258 
2259     /**
2260      * @dev Approve or remove `operator` as an operator for the caller.
2261      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2262      *
2263      * Requirements:
2264      *
2265      * - The `operator` cannot be the caller.
2266      *
2267      * Emits an {ApprovalForAll} event.
2268      */
2269     function setApprovalForAll(address operator, bool _approved) external;
2270 
2271     /**
2272      * @dev Returns the account approved for `tokenId` token.
2273      *
2274      * Requirements:
2275      *
2276      * - `tokenId` must exist.
2277      */
2278     function getApproved(uint256 tokenId) external view returns (address operator);
2279 
2280     /**
2281      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2282      *
2283      * See {setApprovalForAll}
2284      */
2285     function isApprovedForAll(address owner, address operator) external view returns (bool);
2286 }
2287 
2288 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2289 
2290 
2291 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2292 
2293 pragma solidity ^0.8.0;
2294 
2295 
2296 /**
2297  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2298  * @dev See https://eips.ethereum.org/EIPS/eip-721
2299  */
2300 interface IERC721Metadata is IERC721 {
2301     /**
2302      * @dev Returns the token collection name.
2303      */
2304     function name() external view returns (string memory);
2305 
2306     /**
2307      * @dev Returns the token collection symbol.
2308      */
2309     function symbol() external view returns (string memory);
2310 
2311     /**
2312      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2313      */
2314     function tokenURI(uint256 tokenId) external view returns (string memory);
2315 }
2316 
2317 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2318 
2319 
2320 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
2321 
2322 pragma solidity ^0.8.0;
2323 
2324 
2325 
2326 
2327 
2328 
2329 
2330 
2331 /**
2332  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2333  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2334  * {ERC721Enumerable}.
2335  */
2336 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2337     using Address for address;
2338     using Strings for uint256;
2339 
2340     // Token name
2341     string private _name;
2342 
2343     // Token symbol
2344     string private _symbol;
2345 
2346     // Mapping from token ID to owner address
2347     mapping(uint256 => address) private _owners;
2348 
2349     // Mapping owner address to token count
2350     mapping(address => uint256) private _balances;
2351 
2352     // Mapping from token ID to approved address
2353     mapping(uint256 => address) private _tokenApprovals;
2354 
2355     // Mapping from owner to operator approvals
2356     mapping(address => mapping(address => bool)) private _operatorApprovals;
2357 
2358     /**
2359      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2360      */
2361     constructor(string memory name_, string memory symbol_) {
2362         _name = name_;
2363         _symbol = symbol_;
2364     }
2365 
2366     /**
2367      * @dev See {IERC165-supportsInterface}.
2368      */
2369     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2370         return
2371             interfaceId == type(IERC721).interfaceId ||
2372             interfaceId == type(IERC721Metadata).interfaceId ||
2373             super.supportsInterface(interfaceId);
2374     }
2375 
2376     /**
2377      * @dev See {IERC721-balanceOf}.
2378      */
2379     function balanceOf(address owner) public view virtual override returns (uint256) {
2380         require(owner != address(0), "ERC721: address zero is not a valid owner");
2381         return _balances[owner];
2382     }
2383 
2384     /**
2385      * @dev See {IERC721-ownerOf}.
2386      */
2387     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2388         address owner = _owners[tokenId];
2389         require(owner != address(0), "ERC721: invalid token ID");
2390         return owner;
2391     }
2392 
2393     /**
2394      * @dev See {IERC721Metadata-name}.
2395      */
2396     function name() public view virtual override returns (string memory) {
2397         return _name;
2398     }
2399 
2400     /**
2401      * @dev See {IERC721Metadata-symbol}.
2402      */
2403     function symbol() public view virtual override returns (string memory) {
2404         return _symbol;
2405     }
2406 
2407     /**
2408      * @dev See {IERC721Metadata-tokenURI}.
2409      */
2410     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2411         _requireMinted(tokenId);
2412 
2413         string memory baseURI = _baseURI();
2414         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2415     }
2416 
2417     /**
2418      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2419      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2420      * by default, can be overridden in child contracts.
2421      */
2422     function _baseURI() internal view virtual returns (string memory) {
2423         return "";
2424     }
2425 
2426     /**
2427      * @dev See {IERC721-approve}.
2428      */
2429     function approve(address to, uint256 tokenId) public virtual override {
2430         address owner = ERC721.ownerOf(tokenId);
2431         require(to != owner, "ERC721: approval to current owner");
2432 
2433         require(
2434             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2435             "ERC721: approve caller is not token owner nor approved for all"
2436         );
2437 
2438         _approve(to, tokenId);
2439     }
2440 
2441     /**
2442      * @dev See {IERC721-getApproved}.
2443      */
2444     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2445         _requireMinted(tokenId);
2446 
2447         return _tokenApprovals[tokenId];
2448     }
2449 
2450     /**
2451      * @dev See {IERC721-setApprovalForAll}.
2452      */
2453     function setApprovalForAll(address operator, bool approved) public virtual override {
2454         _setApprovalForAll(_msgSender(), operator, approved);
2455     }
2456 
2457     /**
2458      * @dev See {IERC721-isApprovedForAll}.
2459      */
2460     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2461         return _operatorApprovals[owner][operator];
2462     }
2463 
2464     /**
2465      * @dev See {IERC721-transferFrom}.
2466      */
2467     function transferFrom(
2468         address from,
2469         address to,
2470         uint256 tokenId
2471     ) public virtual override {
2472         //solhint-disable-next-line max-line-length
2473         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2474 
2475         _transfer(from, to, tokenId);
2476     }
2477 
2478     /**
2479      * @dev See {IERC721-safeTransferFrom}.
2480      */
2481     function safeTransferFrom(
2482         address from,
2483         address to,
2484         uint256 tokenId
2485     ) public virtual override {
2486         safeTransferFrom(from, to, tokenId, "");
2487     }
2488 
2489     /**
2490      * @dev See {IERC721-safeTransferFrom}.
2491      */
2492     function safeTransferFrom(
2493         address from,
2494         address to,
2495         uint256 tokenId,
2496         bytes memory data
2497     ) public virtual override {
2498         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2499         _safeTransfer(from, to, tokenId, data);
2500     }
2501 
2502     /**
2503      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2504      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2505      *
2506      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2507      *
2508      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2509      * implement alternative mechanisms to perform token transfer, such as signature-based.
2510      *
2511      * Requirements:
2512      *
2513      * - `from` cannot be the zero address.
2514      * - `to` cannot be the zero address.
2515      * - `tokenId` token must exist and be owned by `from`.
2516      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2517      *
2518      * Emits a {Transfer} event.
2519      */
2520     function _safeTransfer(
2521         address from,
2522         address to,
2523         uint256 tokenId,
2524         bytes memory data
2525     ) internal virtual {
2526         _transfer(from, to, tokenId);
2527         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2528     }
2529 
2530     /**
2531      * @dev Returns whether `tokenId` exists.
2532      *
2533      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2534      *
2535      * Tokens start existing when they are minted (`_mint`),
2536      * and stop existing when they are burned (`_burn`).
2537      */
2538     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2539         return _owners[tokenId] != address(0);
2540     }
2541 
2542     /**
2543      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2544      *
2545      * Requirements:
2546      *
2547      * - `tokenId` must exist.
2548      */
2549     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2550         address owner = ERC721.ownerOf(tokenId);
2551         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2552     }
2553 
2554     /**
2555      * @dev Safely mints `tokenId` and transfers it to `to`.
2556      *
2557      * Requirements:
2558      *
2559      * - `tokenId` must not exist.
2560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2561      *
2562      * Emits a {Transfer} event.
2563      */
2564     function _safeMint(address to, uint256 tokenId) internal virtual {
2565         _safeMint(to, tokenId, "");
2566     }
2567 
2568     /**
2569      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2570      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2571      */
2572     function _safeMint(
2573         address to,
2574         uint256 tokenId,
2575         bytes memory data
2576     ) internal virtual {
2577         _mint(to, tokenId);
2578         require(
2579             _checkOnERC721Received(address(0), to, tokenId, data),
2580             "ERC721: transfer to non ERC721Receiver implementer"
2581         );
2582     }
2583 
2584     /**
2585      * @dev Mints `tokenId` and transfers it to `to`.
2586      *
2587      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2588      *
2589      * Requirements:
2590      *
2591      * - `tokenId` must not exist.
2592      * - `to` cannot be the zero address.
2593      *
2594      * Emits a {Transfer} event.
2595      */
2596     function _mint(address to, uint256 tokenId) internal virtual {
2597         require(to != address(0), "ERC721: mint to the zero address");
2598         require(!_exists(tokenId), "ERC721: token already minted");
2599 
2600         _beforeTokenTransfer(address(0), to, tokenId);
2601 
2602         _balances[to] += 1;
2603         _owners[tokenId] = to;
2604 
2605         emit Transfer(address(0), to, tokenId);
2606 
2607         _afterTokenTransfer(address(0), to, tokenId);
2608     }
2609 
2610     /**
2611      * @dev Destroys `tokenId`.
2612      * The approval is cleared when the token is burned.
2613      *
2614      * Requirements:
2615      *
2616      * - `tokenId` must exist.
2617      *
2618      * Emits a {Transfer} event.
2619      */
2620     function _burn(uint256 tokenId) internal virtual {
2621         address owner = ERC721.ownerOf(tokenId);
2622 
2623         _beforeTokenTransfer(owner, address(0), tokenId);
2624 
2625         // Clear approvals
2626         _approve(address(0), tokenId);
2627 
2628         _balances[owner] -= 1;
2629         delete _owners[tokenId];
2630 
2631         emit Transfer(owner, address(0), tokenId);
2632 
2633         _afterTokenTransfer(owner, address(0), tokenId);
2634     }
2635 
2636     /**
2637      * @dev Transfers `tokenId` from `from` to `to`.
2638      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2639      *
2640      * Requirements:
2641      *
2642      * - `to` cannot be the zero address.
2643      * - `tokenId` token must be owned by `from`.
2644      *
2645      * Emits a {Transfer} event.
2646      */
2647     function _transfer(
2648         address from,
2649         address to,
2650         uint256 tokenId
2651     ) internal virtual {
2652         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2653         require(to != address(0), "ERC721: transfer to the zero address");
2654 
2655         _beforeTokenTransfer(from, to, tokenId);
2656 
2657         // Clear approvals from the previous owner
2658         _approve(address(0), tokenId);
2659 
2660         _balances[from] -= 1;
2661         _balances[to] += 1;
2662         _owners[tokenId] = to;
2663 
2664         emit Transfer(from, to, tokenId);
2665 
2666         _afterTokenTransfer(from, to, tokenId);
2667     }
2668 
2669     /**
2670      * @dev Approve `to` to operate on `tokenId`
2671      *
2672      * Emits an {Approval} event.
2673      */
2674     function _approve(address to, uint256 tokenId) internal virtual {
2675         _tokenApprovals[tokenId] = to;
2676         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2677     }
2678 
2679     /**
2680      * @dev Approve `operator` to operate on all of `owner` tokens
2681      *
2682      * Emits an {ApprovalForAll} event.
2683      */
2684     function _setApprovalForAll(
2685         address owner,
2686         address operator,
2687         bool approved
2688     ) internal virtual {
2689         require(owner != operator, "ERC721: approve to caller");
2690         _operatorApprovals[owner][operator] = approved;
2691         emit ApprovalForAll(owner, operator, approved);
2692     }
2693 
2694     /**
2695      * @dev Reverts if the `tokenId` has not been minted yet.
2696      */
2697     function _requireMinted(uint256 tokenId) internal view virtual {
2698         require(_exists(tokenId), "ERC721: invalid token ID");
2699     }
2700 
2701     /**
2702      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2703      * The call is not executed if the target address is not a contract.
2704      *
2705      * @param from address representing the previous owner of the given token ID
2706      * @param to target address that will receive the tokens
2707      * @param tokenId uint256 ID of the token to be transferred
2708      * @param data bytes optional data to send along with the call
2709      * @return bool whether the call correctly returned the expected magic value
2710      */
2711     function _checkOnERC721Received(
2712         address from,
2713         address to,
2714         uint256 tokenId,
2715         bytes memory data
2716     ) private returns (bool) {
2717         if (to.isContract()) {
2718             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2719                 return retval == IERC721Receiver.onERC721Received.selector;
2720             } catch (bytes memory reason) {
2721                 if (reason.length == 0) {
2722                     revert("ERC721: transfer to non ERC721Receiver implementer");
2723                 } else {
2724                     /// @solidity memory-safe-assembly
2725                     assembly {
2726                         revert(add(32, reason), mload(reason))
2727                     }
2728                 }
2729             }
2730         } else {
2731             return true;
2732         }
2733     }
2734 
2735     /**
2736      * @dev Hook that is called before any token transfer. This includes minting
2737      * and burning.
2738      *
2739      * Calling conditions:
2740      *
2741      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2742      * transferred to `to`.
2743      * - When `from` is zero, `tokenId` will be minted for `to`.
2744      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2745      * - `from` and `to` are never both zero.
2746      *
2747      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2748      */
2749     function _beforeTokenTransfer(
2750         address from,
2751         address to,
2752         uint256 tokenId
2753     ) internal virtual {}
2754 
2755     /**
2756      * @dev Hook that is called after any transfer of tokens. This includes
2757      * minting and burning.
2758      *
2759      * Calling conditions:
2760      *
2761      * - when `from` and `to` are both non-zero.
2762      * - `from` and `to` are never both zero.
2763      *
2764      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2765      */
2766     function _afterTokenTransfer(
2767         address from,
2768         address to,
2769         uint256 tokenId
2770     ) internal virtual {}
2771 }
2772 
2773 // File: contracts/ok.sol
2774 
2775 
2776 
2777 pragma solidity >=0.7.0 <0.9.0;
2778 
2779 
2780 
2781 
2782 
2783 
2784 
2785 contract PokerverseClub is ERC721A, Ownable {
2786   using Strings for uint256;
2787   using Counters for Counters.Counter;
2788 
2789   Counters.Counter private supply;
2790 
2791   string public uriPrefix = "";
2792   string public uriSuffix = ".json";
2793   string public hiddenMetadataUri;
2794 
2795   bytes32 public root = 0x89f5a3a3ddf60a38b22fa46edbf708857c966c66146825735da391e9d283a378;
2796   
2797   uint256 public cost = 0.05 ether;
2798   uint256 public maxSupply = 11111;
2799   uint256 public maxMintAmountPerTx = 50;
2800 
2801   bool public paused = false;
2802   bool public revealed = false;
2803 
2804   //mapping variables checking if already claimed
2805     mapping(address => bool) public whitelistClaimed ;
2806   //bool checking openTo  public
2807   bool public OpenToPublic = false; 
2808 
2809   uint256 public maxPresaleMintAmount = 50;
2810 
2811   constructor() ERC721A("PokerVerseClub", "Pokerverse") {
2812     setHiddenMetadataUri("ipfs://QmaT9TeBmhUafA9jM6ko277boUkgXMp8GJUxCqCXFDJVKX/1.json");
2813   }
2814 
2815   modifier mintCompliance(uint256 _mintAmount) {
2816     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
2817     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
2818     _;
2819   }
2820 
2821 
2822  function changeMerkleROOT(bytes32 _merkleRoot) public onlyOwner {
2823      root = _merkleRoot;
2824  }
2825 
2826  /*if OpenToPublic = true, merkleproof=[] and amount = _mintAmount
2827  *else merkleproof= proof sent to client
2828  *client can claim one time
2829  */
2830   function mint(bytes32[] calldata _merkleProof, uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
2831     require(!paused, "The contract is paused!");
2832 
2833      //Don't allow minting if presale is set and buyer is not in whitelisted map
2834     if (OpenToPublic) {
2835     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
2836     _safeMint(msg.sender, _mintAmount);
2837     }else{ 
2838         require(_mintAmount <= maxPresaleMintAmount, "Amount exceeded");
2839         whitelistMint(_merkleProof,msg.sender);
2840         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
2841         _safeMint(msg.sender, _mintAmount);
2842     }
2843   }
2844 
2845     function _startTokenId() internal view virtual override returns (uint256) {
2846     return 1;
2847   }
2848   
2849     function crossmint(address _to) public payable {
2850     require(cost == msg.value, "Incorrect ETH value sent");
2851     require(supply.current() + 1 <= maxSupply, "No more left");
2852     require(msg.sender == 0xdAb1a1854214684acE522439684a145E62505233,
2853       "This function is for Crossmint only."
2854     );
2855 
2856     supply.increment();
2857     uint256 newTokenId = supply.current();
2858    
2859 
2860     _safeMint(_to, newTokenId);
2861   }
2862 
2863   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2864     _safeMint(_receiver, _mintAmount);
2865   }
2866 
2867   function walletOfOwner(address _owner)
2868     public
2869     view
2870     returns (uint256[] memory)
2871   {
2872     uint256 ownerTokenCount = balanceOf(_owner);
2873     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2874     uint256 currentTokenId = 1;
2875     uint256 ownedTokenIndex = 0;
2876 
2877     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2878       address currentTokenOwner = ownerOf(currentTokenId);
2879 
2880       if (currentTokenOwner == _owner) {
2881         ownedTokenIds[ownedTokenIndex] = currentTokenId;
2882 
2883         ownedTokenIndex++;
2884       }
2885 
2886       currentTokenId++;
2887     }
2888 
2889     return ownedTokenIds;
2890   }
2891 
2892   function tokenURI(uint256 _tokenId)
2893     public
2894     view
2895     virtual
2896     override
2897     returns (string memory)
2898   {
2899     require(
2900       _exists(_tokenId),
2901       "ERC721Metadata: URI query for nonexistent token"
2902     );
2903 
2904     if (revealed == false) {
2905       return hiddenMetadataUri;
2906     }
2907 
2908     string memory currentBaseURI = _baseURI();
2909     return bytes(currentBaseURI).length > 0
2910         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2911         : "";
2912   }
2913 
2914   function setRevealed(bool _state) public onlyOwner {
2915     revealed = _state;
2916   }
2917 
2918   function setCost(uint256 _cost) public onlyOwner {
2919     cost = _cost;
2920   }
2921 
2922   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2923     maxMintAmountPerTx = _maxMintAmountPerTx;
2924   }
2925 
2926   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2927     hiddenMetadataUri = _hiddenMetadataUri;
2928   }
2929 
2930   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2931     uriPrefix = _uriPrefix;
2932   }
2933 
2934     function setOpenToPublic(bool _open) public onlyOwner {
2935       OpenToPublic = _open;
2936   }
2937 
2938   function setMaxPresaleMintAmount(uint256 _max) public onlyOwner {
2939       maxPresaleMintAmount = _max;
2940   }
2941 
2942 
2943     function whitelistMint(bytes32[] calldata _merkleProof, address _from) internal   {
2944 
2945     require(!whitelistClaimed[_from], "address has already claimed");
2946     //check if account is in whitelist
2947     bytes32 leaf=  keccak256(abi.encodePacked(_from));
2948     require(MerkleProof.verify(_merkleProof ,root ,leaf ),"Now Whitelisted");
2949     //mark address as having claimed their token 
2950         whitelistClaimed[_from]= true ;    
2951     }
2952 
2953   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2954     uriSuffix = _uriSuffix;
2955   }
2956 
2957   function setPaused(bool _state) public onlyOwner {
2958     paused = _state;
2959   }
2960 
2961   function withdraw() public onlyOwner {
2962 
2963       (bool hs, ) = payable(0x29093bA7215dc0d313707E821dAfe5C1AB683c83).call{value: address(this).balance * 50 / 100}('');
2964     require(hs);
2965     
2966     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2967     require(os);
2968 
2969 
2970   }
2971 
2972 
2973   function _baseURI() internal view virtual override returns (string memory) {
2974     return uriPrefix;
2975   }
2976 }