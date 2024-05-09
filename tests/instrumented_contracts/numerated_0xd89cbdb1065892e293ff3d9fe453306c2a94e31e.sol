1 // SPDX-License-Identifier: MIT
2 
3 /**
4 Shark!Shark!Shark!Shark!Shark!Shark!
5 Shark!Shark!Shark!Shark!Shark!Shark!
6 Shark!Shark!Shark!Shark!Shark!Shark!
7 Shark!Shark!Shark!Shark!Shark!Shark!
8 Shark!Shark!Shark!Shark!Shark!Shark!
9 Shark!Shark!Shark!Shark!Shark!Shark!
10 Shark!Shark!Shark!Shark!Shark!Shark!
11 Shark!Shark!Shark!Shark!Shark!Shark!
12 Shark!Shark!Shark!Shark!Shark!Shark!
13 Shark!Shark!Shark!Shark!Shark!Shark!
14 Shark!Shark!Shark!Shark!Shark!Shark!
15 Shark!Shark!Shark!Shark!Shark!Shark!
16 Shark!Shark!Shark!Shark!Shark!Shark!
17 **/
18 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
19 
20 // File: erc721a/contracts/IERC721A.sol
21 
22 // ERC721A Contracts v4.2.2
23 // Creator: Chiru Labs
24 
25 pragma solidity ^0.8.4;
26 
27 /**
28  * @dev Interface of ERC721A.
29  */
30 interface IERC721A {
31     /**
32      * The caller must own the token or be an approved operator.
33      */
34     error ApprovalCallerNotOwnerNorApproved();
35 
36     /**
37      * The token does not exist.
38      */
39     error ApprovalQueryForNonexistentToken();
40 
41     /**
42      * The caller cannot approve to their own address.
43      */
44     error ApproveToCaller();
45 
46     /**
47      * Cannot query the balance for the zero address.
48      */
49     error BalanceQueryForZeroAddress();
50 
51     /**
52      * Cannot mint to the zero address.
53      */
54     error MintToZeroAddress();
55 
56     /**
57      * The quantity of tokens minted must be more than zero.
58      */
59     error MintZeroQuantity();
60 
61     /**
62      * The token does not exist.
63      */
64     error OwnerQueryForNonexistentToken();
65 
66     /**
67      * The caller must own the token or be an approved operator.
68      */
69     error TransferCallerNotOwnerNorApproved();
70 
71     /**
72      * The token must be owned by `from`.
73      */
74     error TransferFromIncorrectOwner();
75 
76     /**
77      * Cannot safely transfer to a contract that does not implement the
78      * ERC721Receiver interface.
79      */
80     error TransferToNonERC721ReceiverImplementer();
81 
82     /**
83      * Cannot transfer to the zero address.
84      */
85     error TransferToZeroAddress();
86 
87     /**
88      * The token does not exist.
89      */
90     error URIQueryForNonexistentToken();
91 
92     /**
93      * The `quantity` minted with ERC2309 exceeds the safety limit.
94      */
95     error MintERC2309QuantityExceedsLimit();
96 
97     /**
98      * The `extraData` cannot be set on an unintialized ownership slot.
99      */
100     error OwnershipNotInitializedForExtraData();
101 
102     // =============================================================
103     //                            STRUCTS
104     // =============================================================
105 
106     struct TokenOwnership {
107         // The address of the owner.
108         address addr;
109         // Stores the start time of ownership with minimal overhead for tokenomics.
110         uint64 startTimestamp;
111         // Whether the token has been burned.
112         bool burned;
113         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
114         uint24 extraData;
115     }
116 
117     // =============================================================
118     //                         TOKEN COUNTERS
119     // =============================================================
120 
121     /**
122      * @dev Returns the total number of tokens in existence.
123      * Burned tokens will reduce the count.
124      * To get the total number of tokens minted, please see {_totalMinted}.
125      */
126     function totalSupply() external view returns (uint256);
127 
128     // =============================================================
129     //                            IERC165
130     // =============================================================
131 
132     /**
133      * @dev Returns true if this contract implements the interface defined by
134      * `interfaceId`. See the corresponding
135      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
136      * to learn more about how these ids are created.
137      *
138      * This function call must use less than 30000 gas.
139      */
140     function supportsInterface(bytes4 interfaceId) external view returns (bool);
141 
142     // =============================================================
143     //                            IERC721
144     // =============================================================
145 
146     /**
147      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
150 
151     /**
152      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
153      */
154     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
155 
156     /**
157      * @dev Emitted when `owner` enables or disables
158      * (`approved`) `operator` to manage all of its assets.
159      */
160     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
161 
162     /**
163      * @dev Returns the number of tokens in `owner`'s account.
164      */
165     function balanceOf(address owner) external view returns (uint256 balance);
166 
167     /**
168      * @dev Returns the owner of the `tokenId` token.
169      *
170      * Requirements:
171      *
172      * - `tokenId` must exist.
173      */
174     function ownerOf(uint256 tokenId) external view returns (address owner);
175 
176     /**
177      * @dev Safely transfers `tokenId` token from `from` to `to`,
178      * checking first that contract recipients are aware of the ERC721 protocol
179      * to prevent tokens from being forever locked.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must exist and be owned by `from`.
186      * - If the caller is not `from`, it must be have been allowed to move
187      * this token by either {approve} or {setApprovalForAll}.
188      * - If `to` refers to a smart contract, it must implement
189      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
190      *
191      * Emits a {Transfer} event.
192      */
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId,
197         bytes calldata data
198     ) external;
199 
200     /**
201      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
202      */
203     function safeTransferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external;
208 
209     /**
210      * @dev Transfers `tokenId` from `from` to `to`.
211      *
212      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
213      * whenever possible.
214      *
215      * Requirements:
216      *
217      * - `from` cannot be the zero address.
218      * - `to` cannot be the zero address.
219      * - `tokenId` token must be owned by `from`.
220      * - If the caller is not `from`, it must be approved to move this token
221      * by either {approve} or {setApprovalForAll}.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transferFrom(
226         address from,
227         address to,
228         uint256 tokenId
229     ) external;
230 
231     /**
232      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
233      * The approval is cleared when the token is transferred.
234      *
235      * Only a single account can be approved at a time, so approving the
236      * zero address clears previous approvals.
237      *
238      * Requirements:
239      *
240      * - The caller must own the token or be an approved operator.
241      * - `tokenId` must exist.
242      *
243      * Emits an {Approval} event.
244      */
245     function approve(address to, uint256 tokenId) external;
246 
247     /**
248      * @dev Approve or remove `operator` as an operator for the caller.
249      * Operators can call {transferFrom} or {safeTransferFrom}
250      * for any token owned by the caller.
251      *
252      * Requirements:
253      *
254      * - The `operator` cannot be the caller.
255      *
256      * Emits an {ApprovalForAll} event.
257      */
258     function setApprovalForAll(address operator, bool _approved) external;
259 
260     /**
261      * @dev Returns the account approved for `tokenId` token.
262      *
263      * Requirements:
264      *
265      * - `tokenId` must exist.
266      */
267     function getApproved(uint256 tokenId) external view returns (address operator);
268 
269     /**
270      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
271      *
272      * See {setApprovalForAll}.
273      */
274     function isApprovedForAll(address owner, address operator) external view returns (bool);
275 
276     // =============================================================
277     //                        IERC721Metadata
278     // =============================================================
279 
280     /**
281      * @dev Returns the token collection name.
282      */
283     function name() external view returns (string memory);
284 
285     /**
286      * @dev Returns the token collection symbol.
287      */
288     function symbol() external view returns (string memory);
289 
290     /**
291      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
292      */
293     function tokenURI(uint256 tokenId) external view returns (string memory);
294 
295     // =============================================================
296     //                           IERC2309
297     // =============================================================
298 
299     /**
300      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
301      * (inclusive) is transferred from `from` to `to`, as defined in the
302      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
303      *
304      * See {_mintERC2309} for more details.
305      */
306     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
307 }
308 
309 // File: erc721a/contracts/ERC721A.sol
310 
311 
312 // ERC721A Contracts v4.2.2
313 // Creator: Chiru Labs
314 
315 pragma solidity ^0.8.4;
316 
317 
318 /**
319  * @dev Interface of ERC721 token receiver.
320  */
321 interface ERC721A__IERC721Receiver {
322     function onERC721Received(
323         address operator,
324         address from,
325         uint256 tokenId,
326         bytes calldata data
327     ) external returns (bytes4);
328 }
329 
330 /**
331  * @title ERC721A
332  *
333  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
334  * Non-Fungible Token Standard, including the Metadata extension.
335  * Optimized for lower gas during batch mints.
336  *
337  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
338  * starting from `_startTokenId()`.
339  *
340  * Assumptions:
341  *
342  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
343  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
344  */
345 contract ERC721A is IERC721A {
346     // Reference type for token approval.
347     struct TokenApprovalRef {
348         address value;
349     }
350 
351     // =============================================================
352     //                           CONSTANTS
353     // =============================================================
354 
355     // Mask of an entry in packed address data.
356     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
357 
358     // The bit position of `numberMinted` in packed address data.
359     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
360 
361     // The bit position of `numberBurned` in packed address data.
362     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
363 
364     // The bit position of `aux` in packed address data.
365     uint256 private constant _BITPOS_AUX = 192;
366 
367     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
368     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
369 
370     // The bit position of `startTimestamp` in packed ownership.
371     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
372 
373     // The bit mask of the `burned` bit in packed ownership.
374     uint256 private constant _BITMASK_BURNED = 1 << 224;
375 
376     // The bit position of the `nextInitialized` bit in packed ownership.
377     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
378 
379     // The bit mask of the `nextInitialized` bit in packed ownership.
380     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
381 
382     // The bit position of `extraData` in packed ownership.
383     uint256 private constant _BITPOS_EXTRA_DATA = 232;
384 
385     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
386     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
387 
388     // The mask of the lower 160 bits for addresses.
389     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
390 
391     // The maximum `quantity` that can be minted with {_mintERC2309}.
392     // This limit is to prevent overflows on the address data entries.
393     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
394     // is required to cause an overflow, which is unrealistic.
395     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
396 
397     // The `Transfer` event signature is given by:
398     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
399     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
400         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
401 
402     // =============================================================
403     //                            STORAGE
404     // =============================================================
405 
406     // The next token ID to be minted.
407     uint256 private _currentIndex;
408 
409     // The number of tokens burned.
410     uint256 private _burnCounter;
411 
412     // Token name
413     string private _name;
414 
415     // Token symbol
416     string private _symbol;
417 
418     // Mapping from token ID to ownership details
419     // An empty struct value does not necessarily mean the token is unowned.
420     // See {_packedOwnershipOf} implementation for details.
421     //
422     // Bits Layout:
423     // - [0..159]   `addr`
424     // - [160..223] `startTimestamp`
425     // - [224]      `burned`
426     // - [225]      `nextInitialized`
427     // - [232..255] `extraData`
428     mapping(uint256 => uint256) private _packedOwnerships;
429 
430     // Mapping owner address to address data.
431     //
432     // Bits Layout:
433     // - [0..63]    `balance`
434     // - [64..127]  `numberMinted`
435     // - [128..191] `numberBurned`
436     // - [192..255] `aux`
437     mapping(address => uint256) private _packedAddressData;
438 
439     // Mapping from token ID to approved address.
440     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
441 
442     // Mapping from owner to operator approvals
443     mapping(address => mapping(address => bool)) private _operatorApprovals;
444 
445     // =============================================================
446     //                          CONSTRUCTOR
447     // =============================================================
448 
449     constructor(string memory name_, string memory symbol_) {
450         _name = name_;
451         _symbol = symbol_;
452         _currentIndex = _startTokenId();
453     }
454 
455     // =============================================================
456     //                   TOKEN COUNTING OPERATIONS
457     // =============================================================
458 
459     /**
460      * @dev Returns the starting token ID.
461      * To change the starting token ID, please override this function.
462      */
463     function _startTokenId() internal view virtual returns (uint256) {
464         return 0;
465     }
466 
467     /**
468      * @dev Returns the next token ID to be minted.
469      */
470     function _nextTokenId() internal view virtual returns (uint256) {
471         return _currentIndex;
472     }
473 
474     /**
475      * @dev Returns the total number of tokens in existence.
476      * Burned tokens will reduce the count.
477      * To get the total number of tokens minted, please see {_totalMinted}.
478      */
479     function totalSupply() public view virtual override returns (uint256) {
480         // Counter underflow is impossible as _burnCounter cannot be incremented
481         // more than `_currentIndex - _startTokenId()` times.
482         unchecked {
483             return _currentIndex - _burnCounter - _startTokenId();
484         }
485     }
486 
487     /**
488      * @dev Returns the total amount of tokens minted in the contract.
489      */
490     function _totalMinted() internal view virtual returns (uint256) {
491         // Counter underflow is impossible as `_currentIndex` does not decrement,
492         // and it is initialized to `_startTokenId()`.
493         unchecked {
494             return _currentIndex - _startTokenId();
495         }
496     }
497 
498     /**
499      * @dev Returns the total number of tokens burned.
500      */
501     function _totalBurned() internal view virtual returns (uint256) {
502         return _burnCounter;
503     }
504 
505     // =============================================================
506     //                    ADDRESS DATA OPERATIONS
507     // =============================================================
508 
509     /**
510      * @dev Returns the number of tokens in `owner`'s account.
511      */
512     function balanceOf(address owner) public view virtual override returns (uint256) {
513         if (owner == address(0)) revert BalanceQueryForZeroAddress();
514         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
515     }
516 
517     /**
518      * Returns the number of tokens minted by `owner`.
519      */
520     function _numberMinted(address owner) internal view returns (uint256) {
521         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
522     }
523 
524     /**
525      * Returns the number of tokens burned by or on behalf of `owner`.
526      */
527     function _numberBurned(address owner) internal view returns (uint256) {
528         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
529     }
530 
531     /**
532      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
533      */
534     function _getAux(address owner) internal view returns (uint64) {
535         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
536     }
537 
538     /**
539      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
540      * If there are multiple variables, please pack them into a uint64.
541      */
542     function _setAux(address owner, uint64 aux) internal virtual {
543         uint256 packed = _packedAddressData[owner];
544         uint256 auxCasted;
545         // Cast `aux` with assembly to avoid redundant masking.
546         assembly {
547             auxCasted := aux
548         }
549         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
550         _packedAddressData[owner] = packed;
551     }
552 
553     // =============================================================
554     //                            IERC165
555     // =============================================================
556 
557     /**
558      * @dev Returns true if this contract implements the interface defined by
559      * `interfaceId`. See the corresponding
560      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
561      * to learn more about how these ids are created.
562      *
563      * This function call must use less than 30000 gas.
564      */
565     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566         // The interface IDs are constants representing the first 4 bytes
567         // of the XOR of all function selectors in the interface.
568         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
569         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
570         return
571             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
572             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
573             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
574     }
575 
576     // =============================================================
577     //                        IERC721Metadata
578     // =============================================================
579 
580     /**
581      * @dev Returns the token collection name.
582      */
583     function name() public view virtual override returns (string memory) {
584         return _name;
585     }
586 
587     /**
588      * @dev Returns the token collection symbol.
589      */
590     function symbol() public view virtual override returns (string memory) {
591         return _symbol;
592     }
593 
594     /**
595      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
596      */
597     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
598         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
599 
600         string memory baseURI = _baseURI();
601         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
602     }
603 
604     /**
605      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
606      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
607      * by default, it can be overridden in child contracts.
608      */
609     function _baseURI() internal view virtual returns (string memory) {
610         return '';
611     }
612 
613     // =============================================================
614     //                     OWNERSHIPS OPERATIONS
615     // =============================================================
616 
617     /**
618      * @dev Returns the owner of the `tokenId` token.
619      *
620      * Requirements:
621      *
622      * - `tokenId` must exist.
623      */
624     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
625         return address(uint160(_packedOwnershipOf(tokenId)));
626     }
627 
628     /**
629      * @dev Gas spent here starts off proportional to the maximum mint batch size.
630      * It gradually moves to O(1) as tokens get transferred around over time.
631      */
632     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
633         return _unpackedOwnership(_packedOwnershipOf(tokenId));
634     }
635 
636     /**
637      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
638      */
639     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
640         return _unpackedOwnership(_packedOwnerships[index]);
641     }
642 
643     /**
644      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
645      */
646     function _initializeOwnershipAt(uint256 index) internal virtual {
647         if (_packedOwnerships[index] == 0) {
648             _packedOwnerships[index] = _packedOwnershipOf(index);
649         }
650     }
651 
652     /**
653      * Returns the packed ownership data of `tokenId`.
654      */
655     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
656         uint256 curr = tokenId;
657 
658         unchecked {
659             if (_startTokenId() <= curr)
660                 if (curr < _currentIndex) {
661                     uint256 packed = _packedOwnerships[curr];
662                     // If not burned.
663                     if (packed & _BITMASK_BURNED == 0) {
664                         // Invariant:
665                         // There will always be an initialized ownership slot
666                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
667                         // before an unintialized ownership slot
668                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
669                         // Hence, `curr` will not underflow.
670                         //
671                         // We can directly compare the packed value.
672                         // If the address is zero, packed will be zero.
673                         while (packed == 0) {
674                             packed = _packedOwnerships[--curr];
675                         }
676                         return packed;
677                     }
678                 }
679         }
680         revert OwnerQueryForNonexistentToken();
681     }
682 
683     /**
684      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
685      */
686     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
687         ownership.addr = address(uint160(packed));
688         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
689         ownership.burned = packed & _BITMASK_BURNED != 0;
690         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
691     }
692 
693     /**
694      * @dev Packs ownership data into a single uint256.
695      */
696     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
697         assembly {
698             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
699             owner := and(owner, _BITMASK_ADDRESS)
700             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
701             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
702         }
703     }
704 
705     /**
706      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
707      */
708     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
709         // For branchless setting of the `nextInitialized` flag.
710         assembly {
711             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
712             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
713         }
714     }
715 
716     // =============================================================
717     //                      APPROVAL OPERATIONS
718     // =============================================================
719 
720     /**
721      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
722      * The approval is cleared when the token is transferred.
723      *
724      * Only a single account can be approved at a time, so approving the
725      * zero address clears previous approvals.
726      *
727      * Requirements:
728      *
729      * - The caller must own the token or be an approved operator.
730      * - `tokenId` must exist.
731      *
732      * Emits an {Approval} event.
733      */
734     function approve(address to, uint256 tokenId) public virtual override {
735         address owner = ownerOf(tokenId);
736 
737         if (_msgSenderERC721A() != owner)
738             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
739                 revert ApprovalCallerNotOwnerNorApproved();
740             }
741 
742         _tokenApprovals[tokenId].value = to;
743         emit Approval(owner, to, tokenId);
744     }
745 
746     /**
747      * @dev Returns the account approved for `tokenId` token.
748      *
749      * Requirements:
750      *
751      * - `tokenId` must exist.
752      */
753     function getApproved(uint256 tokenId) public view virtual override returns (address) {
754         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
755 
756         return _tokenApprovals[tokenId].value;
757     }
758 
759     /**
760      * @dev Approve or remove `operator` as an operator for the caller.
761      * Operators can call {transferFrom} or {safeTransferFrom}
762      * for any token owned by the caller.
763      *
764      * Requirements:
765      *
766      * - The `operator` cannot be the caller.
767      *
768      * Emits an {ApprovalForAll} event.
769      */
770     function setApprovalForAll(address operator, bool approved) public virtual override {
771         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
772 
773         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
774         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
775     }
776 
777     /**
778      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
779      *
780      * See {setApprovalForAll}.
781      */
782     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
783         return _operatorApprovals[owner][operator];
784     }
785 
786     /**
787      * @dev Returns whether `tokenId` exists.
788      *
789      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
790      *
791      * Tokens start existing when they are minted. See {_mint}.
792      */
793     function _exists(uint256 tokenId) internal view virtual returns (bool) {
794         return
795             _startTokenId() <= tokenId &&
796             tokenId < _currentIndex && // If within bounds,
797             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
798     }
799 
800     /**
801      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
802      */
803     function _isSenderApprovedOrOwner(
804         address approvedAddress,
805         address owner,
806         address msgSender
807     ) private pure returns (bool result) {
808         assembly {
809             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
810             owner := and(owner, _BITMASK_ADDRESS)
811             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
812             msgSender := and(msgSender, _BITMASK_ADDRESS)
813             // `msgSender == owner || msgSender == approvedAddress`.
814             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
815         }
816     }
817 
818     /**
819      * @dev Returns the storage slot and value for the approved address of `tokenId`.
820      */
821     function _getApprovedSlotAndAddress(uint256 tokenId)
822         private
823         view
824         returns (uint256 approvedAddressSlot, address approvedAddress)
825     {
826         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
827         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
828         assembly {
829             approvedAddressSlot := tokenApproval.slot
830             approvedAddress := sload(approvedAddressSlot)
831         }
832     }
833 
834     // =============================================================
835     //                      TRANSFER OPERATIONS
836     // =============================================================
837 
838     /**
839      * @dev Transfers `tokenId` from `from` to `to`.
840      *
841      * Requirements:
842      *
843      * - `from` cannot be the zero address.
844      * - `to` cannot be the zero address.
845      * - `tokenId` token must be owned by `from`.
846      * - If the caller is not `from`, it must be approved to move this token
847      * by either {approve} or {setApprovalForAll}.
848      *
849      * Emits a {Transfer} event.
850      */
851     function transferFrom(
852         address from,
853         address to,
854         uint256 tokenId
855     ) public virtual override {
856         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
857 
858         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
859 
860         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
861 
862         // The nested ifs save around 20+ gas over a compound boolean condition.
863         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
864             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
865 
866         if (to == address(0)) revert TransferToZeroAddress();
867 
868         _beforeTokenTransfers(from, to, tokenId, 1);
869 
870         // Clear approvals from the previous owner.
871         assembly {
872             if approvedAddress {
873                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
874                 sstore(approvedAddressSlot, 0)
875             }
876         }
877 
878         // Underflow of the sender's balance is impossible because we check for
879         // ownership above and the recipient's balance can't realistically overflow.
880         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
881         unchecked {
882             // We can directly increment and decrement the balances.
883             --_packedAddressData[from]; // Updates: `balance -= 1`.
884             ++_packedAddressData[to]; // Updates: `balance += 1`.
885 
886             // Updates:
887             // - `address` to the next owner.
888             // - `startTimestamp` to the timestamp of transfering.
889             // - `burned` to `false`.
890             // - `nextInitialized` to `true`.
891             _packedOwnerships[tokenId] = _packOwnershipData(
892                 to,
893                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
894             );
895 
896             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
897             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
898                 uint256 nextTokenId = tokenId + 1;
899                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
900                 if (_packedOwnerships[nextTokenId] == 0) {
901                     // If the next slot is within bounds.
902                     if (nextTokenId != _currentIndex) {
903                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
904                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
905                     }
906                 }
907             }
908         }
909 
910         emit Transfer(from, to, tokenId);
911         _afterTokenTransfers(from, to, tokenId, 1);
912     }
913 
914     /**
915      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) public virtual override {
922         safeTransferFrom(from, to, tokenId, '');
923     }
924 
925     /**
926      * @dev Safely transfers `tokenId` token from `from` to `to`.
927      *
928      * Requirements:
929      *
930      * - `from` cannot be the zero address.
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must exist and be owned by `from`.
933      * - If the caller is not `from`, it must be approved to move this token
934      * by either {approve} or {setApprovalForAll}.
935      * - If `to` refers to a smart contract, it must implement
936      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
937      *
938      * Emits a {Transfer} event.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) public virtual override {
946         transferFrom(from, to, tokenId);
947         if (to.code.length != 0)
948             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
949                 revert TransferToNonERC721ReceiverImplementer();
950             }
951     }
952 
953     /**
954      * @dev Hook that is called before a set of serially-ordered token IDs
955      * are about to be transferred. This includes minting.
956      * And also called before burning one token.
957      *
958      * `startTokenId` - the first token ID to be transferred.
959      * `quantity` - the amount to be transferred.
960      *
961      * Calling conditions:
962      *
963      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
964      * transferred to `to`.
965      * - When `from` is zero, `tokenId` will be minted for `to`.
966      * - When `to` is zero, `tokenId` will be burned by `from`.
967      * - `from` and `to` are never both zero.
968      */
969     function _beforeTokenTransfers(
970         address from,
971         address to,
972         uint256 startTokenId,
973         uint256 quantity
974     ) internal virtual {}
975 
976     /**
977      * @dev Hook that is called after a set of serially-ordered token IDs
978      * have been transferred. This includes minting.
979      * And also called after one token has been burned.
980      *
981      * `startTokenId` - the first token ID to be transferred.
982      * `quantity` - the amount to be transferred.
983      *
984      * Calling conditions:
985      *
986      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
987      * transferred to `to`.
988      * - When `from` is zero, `tokenId` has been minted for `to`.
989      * - When `to` is zero, `tokenId` has been burned by `from`.
990      * - `from` and `to` are never both zero.
991      */
992     function _afterTokenTransfers(
993         address from,
994         address to,
995         uint256 startTokenId,
996         uint256 quantity
997     ) internal virtual {}
998 
999     /**
1000      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1001      *
1002      * `from` - Previous owner of the given token ID.
1003      * `to` - Target address that will receive the token.
1004      * `tokenId` - Token ID to be transferred.
1005      * `_data` - Optional data to send along with the call.
1006      *
1007      * Returns whether the call correctly returned the expected magic value.
1008      */
1009     function _checkContractOnERC721Received(
1010         address from,
1011         address to,
1012         uint256 tokenId,
1013         bytes memory _data
1014     ) private returns (bool) {
1015         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1016             bytes4 retval
1017         ) {
1018             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1019         } catch (bytes memory reason) {
1020             if (reason.length == 0) {
1021                 revert TransferToNonERC721ReceiverImplementer();
1022             } else {
1023                 assembly {
1024                     revert(add(32, reason), mload(reason))
1025                 }
1026             }
1027         }
1028     }
1029 
1030     // =============================================================
1031     //                        MINT OPERATIONS
1032     // =============================================================
1033 
1034     /**
1035      * @dev Mints `quantity` tokens and transfers them to `to`.
1036      *
1037      * Requirements:
1038      *
1039      * - `to` cannot be the zero address.
1040      * - `quantity` must be greater than 0.
1041      *
1042      * Emits a {Transfer} event for each mint.
1043      */
1044     function _mint(address to, uint256 quantity) internal virtual {
1045         uint256 startTokenId = _currentIndex;
1046         if (quantity == 0) revert MintZeroQuantity();
1047 
1048         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1049 
1050         // Overflows are incredibly unrealistic.
1051         // `balance` and `numberMinted` have a maximum limit of 2**64.
1052         // `tokenId` has a maximum limit of 2**256.
1053         unchecked {
1054             // Updates:
1055             // - `balance += quantity`.
1056             // - `numberMinted += quantity`.
1057             //
1058             // We can directly add to the `balance` and `numberMinted`.
1059             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1060 
1061             // Updates:
1062             // - `address` to the owner.
1063             // - `startTimestamp` to the timestamp of minting.
1064             // - `burned` to `false`.
1065             // - `nextInitialized` to `quantity == 1`.
1066             _packedOwnerships[startTokenId] = _packOwnershipData(
1067                 to,
1068                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1069             );
1070 
1071             uint256 toMasked;
1072             uint256 end = startTokenId + quantity;
1073 
1074             // Use assembly to loop and emit the `Transfer` event for gas savings.
1075             assembly {
1076                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1077                 toMasked := and(to, _BITMASK_ADDRESS)
1078                 // Emit the `Transfer` event.
1079                 log4(
1080                     0, // Start of data (0, since no data).
1081                     0, // End of data (0, since no data).
1082                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1083                     0, // `address(0)`.
1084                     toMasked, // `to`.
1085                     startTokenId // `tokenId`.
1086                 )
1087 
1088                 for {
1089                     let tokenId := add(startTokenId, 1)
1090                 } iszero(eq(tokenId, end)) {
1091                     tokenId := add(tokenId, 1)
1092                 } {
1093                     // Emit the `Transfer` event. Similar to above.
1094                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1095                 }
1096             }
1097             if (toMasked == 0) revert MintToZeroAddress();
1098 
1099             _currentIndex = end;
1100         }
1101         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1102     }
1103 
1104     /**
1105      * @dev Mints `quantity` tokens and transfers them to `to`.
1106      *
1107      * This function is intended for efficient minting only during contract creation.
1108      *
1109      * It emits only one {ConsecutiveTransfer} as defined in
1110      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1111      * instead of a sequence of {Transfer} event(s).
1112      *
1113      * Calling this function outside of contract creation WILL make your contract
1114      * non-compliant with the ERC721 standard.
1115      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1116      * {ConsecutiveTransfer} event is only permissible during contract creation.
1117      *
1118      * Requirements:
1119      *
1120      * - `to` cannot be the zero address.
1121      * - `quantity` must be greater than 0.
1122      *
1123      * Emits a {ConsecutiveTransfer} event.
1124      */
1125     function _mintERC2309(address to, uint256 quantity) internal virtual {
1126         uint256 startTokenId = _currentIndex;
1127         if (to == address(0)) revert MintToZeroAddress();
1128         if (quantity == 0) revert MintZeroQuantity();
1129         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1130 
1131         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1132 
1133         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1134         unchecked {
1135             // Updates:
1136             // - `balance += quantity`.
1137             // - `numberMinted += quantity`.
1138             //
1139             // We can directly add to the `balance` and `numberMinted`.
1140             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1141 
1142             // Updates:
1143             // - `address` to the owner.
1144             // - `startTimestamp` to the timestamp of minting.
1145             // - `burned` to `false`.
1146             // - `nextInitialized` to `quantity == 1`.
1147             _packedOwnerships[startTokenId] = _packOwnershipData(
1148                 to,
1149                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1150             );
1151 
1152             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1153 
1154             _currentIndex = startTokenId + quantity;
1155         }
1156         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1157     }
1158 
1159     /**
1160      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - If `to` refers to a smart contract, it must implement
1165      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1166      * - `quantity` must be greater than 0.
1167      *
1168      * See {_mint}.
1169      *
1170      * Emits a {Transfer} event for each mint.
1171      */
1172     function _safeMint(
1173         address to,
1174         uint256 quantity,
1175         bytes memory _data
1176     ) internal virtual {
1177         _mint(to, quantity);
1178 
1179         unchecked {
1180             if (to.code.length != 0) {
1181                 uint256 end = _currentIndex;
1182                 uint256 index = end - quantity;
1183                 do {
1184                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1185                         revert TransferToNonERC721ReceiverImplementer();
1186                     }
1187                 } while (index < end);
1188                 // Reentrancy protection.
1189                 if (_currentIndex != end) revert();
1190             }
1191         }
1192     }
1193 
1194     /**
1195      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1196      */
1197     function _safeMint(address to, uint256 quantity) internal virtual {
1198         _safeMint(to, quantity, '');
1199     }
1200 
1201     // =============================================================
1202     //                        BURN OPERATIONS
1203     // =============================================================
1204 
1205     /**
1206      * @dev Equivalent to `_burn(tokenId, false)`.
1207      */
1208     function _burn(uint256 tokenId) internal virtual {
1209         _burn(tokenId, false);
1210     }
1211 
1212     /**
1213      * @dev Destroys `tokenId`.
1214      * The approval is cleared when the token is burned.
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must exist.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1223         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1224 
1225         address from = address(uint160(prevOwnershipPacked));
1226 
1227         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1228 
1229         if (approvalCheck) {
1230             // The nested ifs save around 20+ gas over a compound boolean condition.
1231             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1232                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1233         }
1234 
1235         _beforeTokenTransfers(from, address(0), tokenId, 1);
1236 
1237         // Clear approvals from the previous owner.
1238         assembly {
1239             if approvedAddress {
1240                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1241                 sstore(approvedAddressSlot, 0)
1242             }
1243         }
1244 
1245         // Underflow of the sender's balance is impossible because we check for
1246         // ownership above and the recipient's balance can't realistically overflow.
1247         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1248         unchecked {
1249             // Updates:
1250             // - `balance -= 1`.
1251             // - `numberBurned += 1`.
1252             //
1253             // We can directly decrement the balance, and increment the number burned.
1254             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1255             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1256 
1257             // Updates:
1258             // - `address` to the last owner.
1259             // - `startTimestamp` to the timestamp of burning.
1260             // - `burned` to `true`.
1261             // - `nextInitialized` to `true`.
1262             _packedOwnerships[tokenId] = _packOwnershipData(
1263                 from,
1264                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1265             );
1266 
1267             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1268             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1269                 uint256 nextTokenId = tokenId + 1;
1270                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1271                 if (_packedOwnerships[nextTokenId] == 0) {
1272                     // If the next slot is within bounds.
1273                     if (nextTokenId != _currentIndex) {
1274                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1275                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1276                     }
1277                 }
1278             }
1279         }
1280 
1281         emit Transfer(from, address(0), tokenId);
1282         _afterTokenTransfers(from, address(0), tokenId, 1);
1283 
1284         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1285         unchecked {
1286             _burnCounter++;
1287         }
1288     }
1289 
1290     // =============================================================
1291     //                     EXTRA DATA OPERATIONS
1292     // =============================================================
1293 
1294     /**
1295      * @dev Directly sets the extra data for the ownership data `index`.
1296      */
1297     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1298         uint256 packed = _packedOwnerships[index];
1299         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1300         uint256 extraDataCasted;
1301         // Cast `extraData` with assembly to avoid redundant masking.
1302         assembly {
1303             extraDataCasted := extraData
1304         }
1305         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1306         _packedOwnerships[index] = packed;
1307     }
1308 
1309     /**
1310      * @dev Called during each token transfer to set the 24bit `extraData` field.
1311      * Intended to be overridden by the cosumer contract.
1312      *
1313      * `previousExtraData` - the value of `extraData` before transfer.
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` will be minted for `to`.
1320      * - When `to` is zero, `tokenId` will be burned by `from`.
1321      * - `from` and `to` are never both zero.
1322      */
1323     function _extraData(
1324         address from,
1325         address to,
1326         uint24 previousExtraData
1327     ) internal view virtual returns (uint24) {}
1328 
1329     /**
1330      * @dev Returns the next extra data for the packed ownership data.
1331      * The returned result is shifted into position.
1332      */
1333     function _nextExtraData(
1334         address from,
1335         address to,
1336         uint256 prevOwnershipPacked
1337     ) private view returns (uint256) {
1338         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1339         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1340     }
1341 
1342     // =============================================================
1343     //                       OTHER OPERATIONS
1344     // =============================================================
1345 
1346     /**
1347      * @dev Returns the message sender (defaults to `msg.sender`).
1348      *
1349      * If you are writing GSN compatible contracts, you need to override this function.
1350      */
1351     function _msgSenderERC721A() internal view virtual returns (address) {
1352         return msg.sender;
1353     }
1354 
1355     /**
1356      * @dev Converts a uint256 to its ASCII string decimal representation.
1357      */
1358     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1359         assembly {
1360             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1361             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1362             // We will need 1 32-byte word to store the length,
1363             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1364             str := add(mload(0x40), 0x80)
1365             // Update the free memory pointer to allocate.
1366             mstore(0x40, str)
1367 
1368             // Cache the end of the memory to calculate the length later.
1369             let end := str
1370 
1371             // We write the string from rightmost digit to leftmost digit.
1372             // The following is essentially a do-while loop that also handles the zero case.
1373             // prettier-ignore
1374             for { let temp := value } 1 {} {
1375                 str := sub(str, 1)
1376                 // Write the character to the pointer.
1377                 // The ASCII index of the '0' character is 48.
1378                 mstore8(str, add(48, mod(temp, 10)))
1379                 // Keep dividing `temp` until zero.
1380                 temp := div(temp, 10)
1381                 // prettier-ignore
1382                 if iszero(temp) { break }
1383             }
1384 
1385             let length := sub(end, str)
1386             // Move the pointer 32 bytes leftwards to make room for the length.
1387             str := sub(str, 0x20)
1388             // Store the length.
1389             mstore(str, length)
1390         }
1391     }
1392 }
1393 
1394 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1395 
1396 pragma solidity ^0.8.0;
1397 
1398 /**
1399  * @dev Contract module that helps prevent reentrant calls to a function.
1400  *
1401  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1402  * available, which can be applied to functions to make sure there are no nested
1403  * (reentrant) calls to them.
1404  *
1405  * Note that because there is a single `nonReentrant` guard, functions marked as
1406  * `nonReentrant` may not call one another. This can be worked around by making
1407  * those functions `private`, and then adding `external` `nonReentrant` entry
1408  * points to them.
1409  *
1410  * TIP: If you would like to learn more about reentrancy and alternative ways
1411  * to protect against it, check out our blog post
1412  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1413  */
1414 abstract contract ReentrancyGuard {
1415     // Booleans are more expensive than uint256 or any type that takes up a full
1416     // word because each write operation emits an extra SLOAD to first read the
1417     // slot's contents, replace the bits taken up by the boolean, and then write
1418     // back. This is the compiler's defense against contract upgrades and
1419     // pointer aliasing, and it cannot be disabled.
1420 
1421     // The values being non-zero value makes deployment a bit more expensive,
1422     // but in exchange the refund on every call to nonReentrant will be lower in
1423     // amount. Since refunds are capped to a percentage of the total
1424     // transaction's gas, it is best to keep them low in cases like this one, to
1425     // increase the likelihood of the full refund coming into effect.
1426     uint256 private constant _NOT_ENTERED = 1;
1427     uint256 private constant _ENTERED = 2;
1428 
1429     uint256 private _status;
1430 
1431     constructor() {
1432         _status = _NOT_ENTERED;
1433     }
1434 
1435     /**
1436      * @dev Prevents a contract from calling itself, directly or indirectly.
1437      * Calling a `nonReentrant` function from another `nonReentrant`
1438      * function is not supported. It is possible to prevent this from happening
1439      * by making the `nonReentrant` function external, and making it call a
1440      * `private` function that does the actual work.
1441      */
1442     modifier nonReentrant() {
1443         // On the first call to nonReentrant, _notEntered will be true
1444         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1445 
1446         // Any calls to nonReentrant after this point will fail
1447         _status = _ENTERED;
1448 
1449         _;
1450 
1451         // By storing the original value once again, a refund is triggered (see
1452         // https://eips.ethereum.org/EIPS/eip-2200)
1453         _status = _NOT_ENTERED;
1454     }
1455 }
1456 // File: @openzeppelin/contracts/utils/Context.sol
1457 
1458 
1459 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1460 
1461 pragma solidity ^0.8.0;
1462 
1463 /**
1464  * @dev Provides information about the current execution context, including the
1465  * sender of the transaction and its data. While these are generally available
1466  * via msg.sender and msg.data, they should not be accessed in such a direct
1467  * manner, since when dealing with meta-transactions the account sending and
1468  * paying for execution may not be the actual sender (as far as an application
1469  * is concerned).
1470  *
1471  * This contract is only required for intermediate, library-like contracts.
1472  */
1473 abstract contract Context {
1474     function _msgSender() internal view virtual returns (address) {
1475         return msg.sender;
1476     }
1477 
1478     function _msgData() internal view virtual returns (bytes calldata) {
1479         return msg.data;
1480     }
1481 }
1482 
1483 // File: @openzeppelin/contracts/access/Ownable.sol
1484 
1485 
1486 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1487 
1488 pragma solidity ^0.8.0;
1489 
1490 
1491 /**
1492  * @dev Contract module which provides a basic access control mechanism, where
1493  * there is an account (an owner) that can be granted exclusive access to
1494  * specific functions.
1495  *
1496  * By default, the owner account will be the one that deploys the contract. This
1497  * can later be changed with {transferOwnership}.
1498  *
1499  * This module is used through inheritance. It will make available the modifier
1500  * `onlyOwner`, which can be applied to your functions to restrict their use to
1501  * the owner.
1502  */
1503 abstract contract Ownable is Context {
1504     address private _owner;
1505 
1506     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1507 
1508     /**
1509      * @dev Initializes the contract setting the deployer as the initial owner.
1510      */
1511     constructor() {
1512         _transferOwnership(_msgSender());
1513     }
1514 
1515     /**
1516      * @dev Throws if called by any account other than the owner.
1517      */
1518     modifier onlyOwner() {
1519         _checkOwner();
1520         _;
1521     }
1522 
1523     /**
1524      * @dev Returns the address of the current owner.
1525      */
1526     function owner() public view virtual returns (address) {
1527         return _owner;
1528     }
1529 
1530     /**
1531      * @dev Throws if the sender is not the owner.
1532      */
1533     function _checkOwner() internal view virtual {
1534         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1535     }
1536 
1537     /**
1538      * @dev Leaves the contract without owner. It will not be possible to call
1539      * `onlyOwner` functions anymore. Can only be called by the current owner.
1540      *
1541      * NOTE: Renouncing ownership will leave the contract without an owner,
1542      * thereby removing any functionality that is only available to the owner.
1543      */
1544     function renounceOwnership() public virtual onlyOwner {
1545         _transferOwnership(address(0));
1546     }
1547 
1548     /**
1549      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1550      * Can only be called by the current owner.
1551      */
1552     function transferOwnership(address newOwner) public virtual onlyOwner {
1553         require(newOwner != address(0), "Ownable: new owner is the zero address");
1554         _transferOwnership(newOwner);
1555     }
1556 
1557     /**
1558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1559      * Internal function without access restriction.
1560      */
1561     function _transferOwnership(address newOwner) internal virtual {
1562         address oldOwner = _owner;
1563         _owner = newOwner;
1564         emit OwnershipTransferred(oldOwner, newOwner);
1565     }
1566 }
1567 
1568 // File: contracts/DigiDaigakuMan.sol
1569 
1570 
1571 
1572 
1573 
1574 library Strings {
1575     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1576     uint8 private constant _ADDRESS_LENGTH = 20;
1577 
1578     /**
1579      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1580      */
1581     function toString(uint256 value) internal pure returns (string memory) {
1582         // Inspired by OraclizeAPI's implementation - MIT licence
1583         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1584 
1585         if (value == 0) {
1586             return "0";
1587         }
1588         uint256 temp = value;
1589         uint256 digits;
1590         while (temp != 0) {
1591             digits++;
1592             temp /= 10;
1593         }
1594         bytes memory buffer = new bytes(digits);
1595         while (value != 0) {
1596             digits -= 1;
1597             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1598             value /= 10;
1599         }
1600         return string(buffer);
1601     }
1602 
1603     /**
1604      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1605      */
1606     function toHexString(uint256 value) internal pure returns (string memory) {
1607         if (value == 0) {
1608             return "0x00";
1609         }
1610         uint256 temp = value;
1611         uint256 length = 0;
1612         while (temp != 0) {
1613             length++;
1614             temp >>= 8;
1615         }
1616         return toHexString(value, length);
1617     }
1618 
1619     /**
1620      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1621      */
1622     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1623         bytes memory buffer = new bytes(2 * length + 2);
1624         buffer[0] = "0";
1625         buffer[1] = "x";
1626         for (uint256 i = 2 * length + 1; i > 1; --i) {
1627             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1628             value >>= 4;
1629         }
1630         require(value == 0, "Strings: hex length insufficient");
1631         return string(buffer);
1632     }
1633 
1634     /**
1635      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1636      */
1637     function toHexString(address addr) internal pure returns (string memory) {
1638         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1639     }
1640 }
1641 library Address {
1642     /**
1643      * @dev Returns true if `account` is a contract.
1644      *
1645      * [IMPORTANT]
1646      * ====
1647      * It is unsafe to assume that an address for which this function returns
1648      * false is an externally-owned account (EOA) and not a contract.
1649      *
1650      * Among others, `isContract` will return false for the following
1651      * types of addresses:
1652      *
1653      *  - an externally-owned account
1654      *  - a contract in construction
1655      *  - an address where a contract will be created
1656      *  - an address where a contract lived, but was destroyed
1657      * ====
1658      *
1659      * [IMPORTANT]
1660      * ====
1661      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1662      *
1663      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1664      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1665      * constructor.
1666      * ====
1667      */
1668     function isContract(address account) internal view returns (bool) {
1669         // This method relies on extcodesize/address.code.length, which returns 0
1670         // for contracts in construction, since the code is only stored at the end
1671         // of the constructor execution.
1672 
1673         return account.code.length > 0;
1674     }
1675 
1676     /**
1677      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1678      * `recipient`, forwarding all available gas and reverting on errors.
1679      *
1680      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1681      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1682      * imposed by `transfer`, making them unable to receive funds via
1683      * `transfer`. {sendValue} removes this limitation.
1684      *
1685      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1686      *
1687      * IMPORTANT: because control is transferred to `recipient`, care must be
1688      * taken to not create reentrancy vulnerabilities. Consider using
1689      * {ReentrancyGuard} or the
1690      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1691      */
1692     function sendValue(address payable recipient, uint256 amount) internal {
1693         require(address(this).balance >= amount, "Address: insufficient balance");
1694 
1695         (bool success, ) = recipient.call{value: amount}("");
1696         require(success, "Address: unable to send value, recipient may have reverted");
1697     }
1698 
1699     /**
1700      * @dev Performs a Solidity function call using a low level `call`. A
1701      * plain `call` is an unsafe replacement for a function call: use this
1702      * function instead.
1703      *
1704      * If `target` reverts with a revert reason, it is bubbled up by this
1705      * function (like regular Solidity function calls).
1706      *
1707      * Returns the raw returned data. To convert to the expected return value,
1708      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1709      *
1710      * Requirements:
1711      *
1712      * - `target` must be a contract.
1713      * - calling `target` with `data` must not revert.
1714      *
1715      * _Available since v3.1._
1716      */
1717     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1718         return functionCall(target, data, "Address: low-level call failed");
1719     }
1720 
1721     /**
1722      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1723      * `errorMessage` as a fallback revert reason when `target` reverts.
1724      *
1725      * _Available since v3.1._
1726      */
1727     function functionCall(
1728         address target,
1729         bytes memory data,
1730         string memory errorMessage
1731     ) internal returns (bytes memory) {
1732         return functionCallWithValue(target, data, 0, errorMessage);
1733     }
1734 
1735     /**
1736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1737      * but also transferring `value` wei to `target`.
1738      *
1739      * Requirements:
1740      *
1741      * - the calling contract must have an ETH balance of at least `value`.
1742      * - the called Solidity function must be `payable`.
1743      *
1744      * _Available since v3.1._
1745      */
1746     function functionCallWithValue(
1747         address target,
1748         bytes memory data,
1749         uint256 value
1750     ) internal returns (bytes memory) {
1751         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1752     }
1753 
1754     /**
1755      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1756      * with `errorMessage` as a fallback revert reason when `target` reverts.
1757      *
1758      * _Available since v3.1._
1759      */
1760     function functionCallWithValue(
1761         address target,
1762         bytes memory data,
1763         uint256 value,
1764         string memory errorMessage
1765     ) internal returns (bytes memory) {
1766         require(address(this).balance >= value, "Address: insufficient balance for call");
1767         require(isContract(target), "Address: call to non-contract");
1768 
1769         (bool success, bytes memory returndata) = target.call{value: value}(data);
1770         return verifyCallResult(success, returndata, errorMessage);
1771     }
1772 
1773     /**
1774      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1775      * but performing a static call.
1776      *
1777      * _Available since v3.3._
1778      */
1779     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1780         return functionStaticCall(target, data, "Address: low-level static call failed");
1781     }
1782 
1783     /**
1784      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1785      * but performing a static call.
1786      *
1787      * _Available since v3.3._
1788      */
1789     function functionStaticCall(
1790         address target,
1791         bytes memory data,
1792         string memory errorMessage
1793     ) internal view returns (bytes memory) {
1794         require(isContract(target), "Address: static call to non-contract");
1795 
1796         (bool success, bytes memory returndata) = target.staticcall(data);
1797         return verifyCallResult(success, returndata, errorMessage);
1798     }
1799 
1800     /**
1801      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1802      * but performing a delegate call.
1803      *
1804      * _Available since v3.4._
1805      */
1806     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1807         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1808     }
1809 
1810     /**
1811      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1812      * but performing a delegate call.
1813      *
1814      * _Available since v3.4._
1815      */
1816     function functionDelegateCall(
1817         address target,
1818         bytes memory data,
1819         string memory errorMessage
1820     ) internal returns (bytes memory) {
1821         require(isContract(target), "Address: delegate call to non-contract");
1822 
1823         (bool success, bytes memory returndata) = target.delegatecall(data);
1824         return verifyCallResult(success, returndata, errorMessage);
1825     }
1826 
1827     /**
1828      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1829      * revert reason using the provided one.
1830      *
1831      * _Available since v4.3._
1832      */
1833     function verifyCallResult(
1834         bool success,
1835         bytes memory returndata,
1836         string memory errorMessage
1837     ) internal pure returns (bytes memory) {
1838         if (success) {
1839             return returndata;
1840         } else {
1841             // Look for revert reason and bubble it up if present
1842             if (returndata.length > 0) {
1843                 // The easiest way to bubble the revert reason is using memory via assembly
1844                 /// @solidity memory-safe-assembly
1845                 assembly {
1846                     let returndata_size := mload(returndata)
1847                     revert(add(32, returndata), returndata_size)
1848                 }
1849             } else {
1850                 revert(errorMessage);
1851             }
1852         }
1853     }
1854 }
1855 pragma solidity ^0.8.13;
1856 
1857 interface IOperatorFilterRegistry {
1858     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1859     function register(address registrant) external;
1860     function registerAndSubscribe(address registrant, address subscription) external;
1861     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1862     function updateOperator(address registrant, address operator, bool filtered) external;
1863     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1864     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1865     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1866     function subscribe(address registrant, address registrantToSubscribe) external;
1867     function unsubscribe(address registrant, bool copyExistingEntries) external;
1868     function subscriptionOf(address addr) external returns (address registrant);
1869     function subscribers(address registrant) external returns (address[] memory);
1870     function subscriberAt(address registrant, uint256 index) external returns (address);
1871     function copyEntriesOf(address registrant, address registrantToCopy) external;
1872     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1873     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1874     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1875     function filteredOperators(address addr) external returns (address[] memory);
1876     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1877     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1878     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1879     function isRegistered(address addr) external returns (bool);
1880     function codeHashOf(address addr) external returns (bytes32);
1881 }
1882 pragma solidity ^0.8.13;
1883 
1884 abstract contract OperatorFilterer {
1885     error OperatorNotAllowed(address operator);
1886 
1887     IOperatorFilterRegistry constant operatorFilterRegistry =
1888         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1889 
1890     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1891         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1892         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1893         // order for the modifier to filter addresses.
1894         if (address(operatorFilterRegistry).code.length > 0) {
1895             if (subscribe) {
1896                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1897             } else {
1898                 if (subscriptionOrRegistrantToCopy != address(0)) {
1899                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1900                 } else {
1901                     operatorFilterRegistry.register(address(this));
1902                 }
1903             }
1904         }
1905     }
1906 
1907     modifier onlyAllowedOperator(address from) virtual {
1908         // Check registry code length to facilitate testing in environments without a deployed registry.
1909         if (address(operatorFilterRegistry).code.length > 0) {
1910             // Allow spending tokens from addresses with balance
1911             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1912             // from an EOA.
1913             if (from == msg.sender) {
1914                 _;
1915                 return;
1916             }
1917             if (
1918                 !(
1919                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1920                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1921                 )
1922             ) {
1923                 revert OperatorNotAllowed(msg.sender);
1924             }
1925         }
1926         _;
1927     }
1928 }
1929 
1930 
1931 pragma solidity ^0.8.13;
1932 
1933 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1934     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1935 
1936     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1937 }
1938 
1939 
1940 pragma solidity >=0.8.9 <0.9.0;
1941 
1942 contract SharkGang is ERC721A, DefaultOperatorFilterer, Ownable, ReentrancyGuard {
1943     using Address for address;
1944     using Strings for uint;
1945     
1946     string  public baseTokenURI = "ipfs://bafybeiepdk7kjz4bjybky5bvzjlwrqdgcjuwga35nc3au77xurebgn7ewq/";
1947     uint256 public MAX_SHARK = 6969;
1948     uint256 public MAX_PER_TX = 15;
1949     uint256 public PRICE = 0.00369 ether;
1950     uint256 public MAX_FREE_PER_WALLET = 1;
1951     bool public paused = true;
1952 
1953     mapping(address => uint256) private _freeMintedCount;
1954 
1955     constructor() ERC721A("Shark Gang Official", "SGO") {}
1956 
1957     function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1958         require(totalSupply() + _mintAmount <= MAX_SHARK, "Max supply exceeded!");
1959         _safeMint(_receiver, _mintAmount);
1960     }
1961 
1962 
1963     function mint(uint256 _quantity) external payable
1964     {
1965 		require(
1966             _quantity <= MAX_PER_TX, "Max per transaction is 15"
1967             );
1968 		require(
1969             _totalMinted() + _quantity <= MAX_SHARK, "No Shark lefts!"
1970             );
1971         require(
1972             !paused, "Minting paused"
1973             );
1974         uint payForCount = _quantity;
1975         
1976         uint freeMintCount = _freeMintedCount[msg.sender];
1977 
1978         if (freeMintCount < 1) {
1979                 if (_quantity > 1) {
1980                     payForCount = _quantity - 1;
1981                 } else {
1982                     payForCount = 0;
1983                 }
1984 
1985                 _freeMintedCount[msg.sender] = 1;
1986             }
1987 		require(
1988 			msg.value >= payForCount * PRICE,
1989 			"Incorrect ETH amount"
1990 		);
1991 
1992         _safeMint(msg.sender, _quantity);
1993     }
1994 
1995     function freeMintedCount(address owner) external view returns (uint256) {
1996         return _freeMintedCount[owner];
1997     }
1998     
1999     function numberMinted(address owner) public view returns (uint256) {
2000         return _numberMinted(owner);
2001     }
2002     
2003     function setBaseURI(string memory baseURI) public onlyOwner
2004     {
2005         baseTokenURI = baseURI;
2006     }
2007 
2008     function _startTokenId() internal view virtual override returns (uint256) {
2009         return 0;
2010     }
2011 
2012     function withdraw() public onlyOwner nonReentrant {
2013         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2014         require(os);
2015     }
2016 
2017     function tokenURI(uint tokenId)
2018 		public
2019 		view
2020 		override
2021 		returns (string memory)
2022 	{
2023         require(_exists(tokenId), "ERC721Metadata");
2024 
2025         return bytes(_baseURI()).length > 0 
2026             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
2027             : baseTokenURI;
2028 	}
2029 
2030     function _baseURI() internal view virtual override returns (string memory)
2031     {
2032         return baseTokenURI;
2033     }
2034 
2035 
2036     function flipSale(bool _paused) external onlyOwner
2037     {
2038         paused = _paused;
2039     }
2040 
2041     function setPrice(uint256 _price) external onlyOwner
2042     {
2043         PRICE = _price;
2044     }
2045 
2046     function setMaxLimitPerTransaction(uint256 _limit) external onlyOwner
2047     {
2048         MAX_PER_TX = _limit;
2049     }
2050 
2051     function setLimitFreeMintPerWallet(uint256 _limit) external onlyOwner
2052     {
2053         MAX_FREE_PER_WALLET = _limit;
2054     }
2055 
2056     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2057         super.transferFrom(from, to, tokenId);
2058     }
2059 
2060     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2061         super.safeTransferFrom(from, to, tokenId);
2062     }
2063 
2064     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2065         public
2066         override
2067         onlyAllowedOperator(from)
2068     {
2069         super.safeTransferFrom(from, to, tokenId, data);
2070     }
2071 
2072 }