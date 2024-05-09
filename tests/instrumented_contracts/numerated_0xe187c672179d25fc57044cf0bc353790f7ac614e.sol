1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-18
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Contract module that helps prevent reentrant calls to a function.
16  *
17  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
18  * available, which can be applied to functions to make sure there are no nested
19  * (reentrant) calls to them.
20  *
21  * Note that because there is a single `nonReentrant` guard, functions marked as
22  * `nonReentrant` may not call one another. This can be worked around by making
23  * those functions `private`, and then adding `external` `nonReentrant` entry
24  * points to them.
25  *
26  * TIP: If you would like to learn more about reentrancy and alternative ways
27  * to protect against it, check out our blog post
28  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
29  */
30 abstract contract ReentrancyGuard {
31     // Booleans are more expensive than uint256 or any type that takes up a full
32     // word because each write operation emits an extra SLOAD to first read the
33     // slot's contents, replace the bits taken up by the boolean, and then write
34     // back. This is the compiler's defense against contract upgrades and
35     // pointer aliasing, and it cannot be disabled.
36 
37     // The values being non-zero value makes deployment a bit more expensive,
38     // but in exchange the refund on every call to nonReentrant will be lower in
39     // amount. Since refunds are capped to a percentage of the total
40     // transaction's gas, it is best to keep them low in cases like this one, to
41     // increase the likelihood of the full refund coming into effect.
42     uint256 private constant _NOT_ENTERED = 1;
43     uint256 private constant _ENTERED = 2;
44 
45     uint256 private _status;
46 
47     constructor() {
48         _status = _NOT_ENTERED;
49     }
50 
51     /**
52      * @dev Prevents a contract from calling itself, directly or indirectly.
53      * Calling a `nonReentrant` function from another `nonReentrant`
54      * function is not supported. It is possible to prevent this from happening
55      * by making the `nonReentrant` function external, and making it call a
56      * `private` function that does the actual work.
57      */
58     modifier nonReentrant() {
59         // On the first call to nonReentrant, _notEntered will be true
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64 
65         _;
66 
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: erc721a/contracts/IERC721A.sol
74 
75 
76 // ERC721A Contracts v4.2.3
77 // Creator: Chiru Labs
78 
79 pragma solidity ^0.8.4;
80 
81 /**
82  * @dev Interface of ERC721A.
83  */
84 interface IERC721A {
85     /**
86      * The caller must own the token or be an approved operator.
87      */
88     error ApprovalCallerNotOwnerNorApproved();
89 
90     /**
91      * The token does not exist.
92      */
93     error ApprovalQueryForNonexistentToken();
94 
95     /**
96      * Cannot query the balance for the zero address.
97      */
98     error BalanceQueryForZeroAddress();
99 
100     /**
101      * Cannot mint to the zero address.
102      */
103     error MintToZeroAddress();
104 
105     /**
106      * The quantity of tokens minted must be more than zero.
107      */
108     error MintZeroQuantity();
109 
110     /**
111      * The token does not exist.
112      */
113     error OwnerQueryForNonexistentToken();
114 
115     /**
116      * The caller must own the token or be an approved operator.
117      */
118     error TransferCallerNotOwnerNorApproved();
119 
120     /**
121      * The token must be owned by `from`.
122      */
123     error TransferFromIncorrectOwner();
124 
125     /**
126      * Cannot safely transfer to a contract that does not implement the
127      * ERC721Receiver interface.
128      */
129     error TransferToNonERC721ReceiverImplementer();
130 
131     /**
132      * Cannot transfer to the zero address.
133      */
134     error TransferToZeroAddress();
135 
136     /**
137      * The token does not exist.
138      */
139     error URIQueryForNonexistentToken();
140 
141     /**
142      * The `quantity` minted with ERC2309 exceeds the safety limit.
143      */
144     error MintERC2309QuantityExceedsLimit();
145 
146     /**
147      * The `extraData` cannot be set on an unintialized ownership slot.
148      */
149     error OwnershipNotInitializedForExtraData();
150 
151     // =============================================================
152     //                            STRUCTS
153     // =============================================================
154 
155     struct TokenOwnership {
156         // The address of the owner.
157         address addr;
158         // Stores the start time of ownership with minimal overhead for tokenomics.
159         uint64 startTimestamp;
160         // Whether the token has been burned.
161         bool burned;
162         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
163         uint24 extraData;
164     }
165 
166     // =============================================================
167     //                         TOKEN COUNTERS
168     // =============================================================
169 
170     /**
171      * @dev Returns the total number of tokens in existence.
172      * Burned tokens will reduce the count.
173      * To get the total number of tokens minted, please see {_totalMinted}.
174      */
175     function totalSupply() external view returns (uint256);
176 
177     // =============================================================
178     //                            IERC165
179     // =============================================================
180 
181     /**
182      * @dev Returns true if this contract implements the interface defined by
183      * `interfaceId`. See the corresponding
184      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
185      * to learn more about how these ids are created.
186      *
187      * This function call must use less than 30000 gas.
188      */
189     function supportsInterface(bytes4 interfaceId) external view returns (bool);
190 
191     // =============================================================
192     //                            IERC721
193     // =============================================================
194 
195     /**
196      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
197      */
198     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
199 
200     /**
201      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
202      */
203     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
204 
205     /**
206      * @dev Emitted when `owner` enables or disables
207      * (`approved`) `operator` to manage all of its assets.
208      */
209     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
210 
211     /**
212      * @dev Returns the number of tokens in `owner`'s account.
213      */
214     function balanceOf(address owner) external view returns (uint256 balance);
215 
216     /**
217      * @dev Returns the owner of the `tokenId` token.
218      *
219      * Requirements:
220      *
221      * - `tokenId` must exist.
222      */
223     function ownerOf(uint256 tokenId) external view returns (address owner);
224 
225     /**
226      * @dev Safely transfers `tokenId` token from `from` to `to`,
227      * checking first that contract recipients are aware of the ERC721 protocol
228      * to prevent tokens from being forever locked.
229      *
230      * Requirements:
231      *
232      * - `from` cannot be the zero address.
233      * - `to` cannot be the zero address.
234      * - `tokenId` token must exist and be owned by `from`.
235      * - If the caller is not `from`, it must be have been allowed to move
236      * this token by either {approve} or {setApprovalForAll}.
237      * - If `to` refers to a smart contract, it must implement
238      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
239      *
240      * Emits a {Transfer} event.
241      */
242     function safeTransferFrom(
243         address from,
244         address to,
245         uint256 tokenId,
246         bytes calldata data
247     ) external payable;
248 
249     /**
250      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId
256     ) external payable;
257 
258     /**
259      * @dev Transfers `tokenId` from `from` to `to`.
260      *
261      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
262      * whenever possible.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must be owned by `from`.
269      * - If the caller is not `from`, it must be approved to move this token
270      * by either {approve} or {setApprovalForAll}.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transferFrom(
275         address from,
276         address to,
277         uint256 tokenId
278     ) external payable;
279 
280     /**
281      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
282      * The approval is cleared when the token is transferred.
283      *
284      * Only a single account can be approved at a time, so approving the
285      * zero address clears previous approvals.
286      *
287      * Requirements:
288      *
289      * - The caller must own the token or be an approved operator.
290      * - `tokenId` must exist.
291      *
292      * Emits an {Approval} event.
293      */
294     function approve(address to, uint256 tokenId) external payable;
295 
296     /**
297      * @dev Approve or remove `operator` as an operator for the caller.
298      * Operators can call {transferFrom} or {safeTransferFrom}
299      * for any token owned by the caller.
300      *
301      * Requirements:
302      *
303      * - The `operator` cannot be the caller.
304      *
305      * Emits an {ApprovalForAll} event.
306      */
307     function setApprovalForAll(address operator, bool _approved) external;
308 
309     /**
310      * @dev Returns the account approved for `tokenId` token.
311      *
312      * Requirements:
313      *
314      * - `tokenId` must exist.
315      */
316     function getApproved(uint256 tokenId) external view returns (address operator);
317 
318     /**
319      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
320      *
321      * See {setApprovalForAll}.
322      */
323     function isApprovedForAll(address owner, address operator) external view returns (bool);
324 
325     // =============================================================
326     //                        IERC721Metadata
327     // =============================================================
328 
329     /**
330      * @dev Returns the token collection name.
331      */
332     function name() external view returns (string memory);
333 
334     /**
335      * @dev Returns the token collection symbol.
336      */
337     function symbol() external view returns (string memory);
338 
339     /**
340      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
341      */
342     function tokenURI(uint256 tokenId) external view returns (string memory);
343 
344     // =============================================================
345     //                           IERC2309
346     // =============================================================
347 
348     /**
349      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
350      * (inclusive) is transferred from `from` to `to`, as defined in the
351      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
352      *
353      * See {_mintERC2309} for more details.
354      */
355     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
356 }
357 
358 // File: erc721a/contracts/ERC721A.sol
359 
360 
361 // ERC721A Contracts v4.2.3
362 // Creator: Chiru Labs
363 
364 pragma solidity ^0.8.4;
365 
366 
367 /**
368  * @dev Interface of ERC721 token receiver.
369  */
370 interface ERC721A__IERC721Receiver {
371     function onERC721Received(
372         address operator,
373         address from,
374         uint256 tokenId,
375         bytes calldata data
376     ) external returns (bytes4);
377 }
378 
379 /**
380  * @title ERC721A
381  *
382  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
383  * Non-Fungible Token Standard, including the Metadata extension.
384  * Optimized for lower gas during batch mints.
385  *
386  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
387  * starting from `_startTokenId()`.
388  *
389  * Assumptions:
390  *
391  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
392  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
393  */
394 contract ERC721A is IERC721A {
395     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
396     struct TokenApprovalRef {
397         address value;
398     }
399 
400     // =============================================================
401     //                           CONSTANTS
402     // =============================================================
403 
404     // Mask of an entry in packed address data.
405     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
406 
407     // The bit position of `numberMinted` in packed address data.
408     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
409 
410     // The bit position of `numberBurned` in packed address data.
411     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
412 
413     // The bit position of `aux` in packed address data.
414     uint256 private constant _BITPOS_AUX = 192;
415 
416     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
417     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
418 
419     // The bit position of `startTimestamp` in packed ownership.
420     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
421 
422     // The bit mask of the `burned` bit in packed ownership.
423     uint256 private constant _BITMASK_BURNED = 1 << 224;
424 
425     // The bit position of the `nextInitialized` bit in packed ownership.
426     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
427 
428     // The bit mask of the `nextInitialized` bit in packed ownership.
429     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
430 
431     // The bit position of `extraData` in packed ownership.
432     uint256 private constant _BITPOS_EXTRA_DATA = 232;
433 
434     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
435     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
436 
437     // The mask of the lower 160 bits for addresses.
438     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
439 
440     // The maximum `quantity` that can be minted with {_mintERC2309}.
441     // This limit is to prevent overflows on the address data entries.
442     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
443     // is required to cause an overflow, which is unrealistic.
444     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
445 
446     // The `Transfer` event signature is given by:
447     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
448     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
449         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
450 
451     // =============================================================
452     //                            STORAGE
453     // =============================================================
454 
455     // The next token ID to be minted.
456     uint256 private _currentIndex;
457 
458     // The number of tokens burned.
459     uint256 private _burnCounter;
460 
461     // Token name
462     string private _name;
463 
464     // Token symbol
465     string private _symbol;
466 
467     // Mapping from token ID to ownership details
468     // An empty struct value does not necessarily mean the token is unowned.
469     // See {_packedOwnershipOf} implementation for details.
470     //
471     // Bits Layout:
472     // - [0..159]   `addr`
473     // - [160..223] `startTimestamp`
474     // - [224]      `burned`
475     // - [225]      `nextInitialized`
476     // - [232..255] `extraData`
477     mapping(uint256 => uint256) private _packedOwnerships;
478 
479     // Mapping owner address to address data.
480     //
481     // Bits Layout:
482     // - [0..63]    `balance`
483     // - [64..127]  `numberMinted`
484     // - [128..191] `numberBurned`
485     // - [192..255] `aux`
486     mapping(address => uint256) private _packedAddressData;
487 
488     // Mapping from token ID to approved address.
489     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
490 
491     // Mapping from owner to operator approvals
492     mapping(address => mapping(address => bool)) private _operatorApprovals;
493 
494     // =============================================================
495     //                          CONSTRUCTOR
496     // =============================================================
497 
498     constructor(string memory name_, string memory symbol_) {
499         _name = name_;
500         _symbol = symbol_;
501         _currentIndex = _startTokenId();
502     }
503 
504     // =============================================================
505     //                   TOKEN COUNTING OPERATIONS
506     // =============================================================
507 
508     /**
509      * @dev Returns the starting token ID.
510      * To change the starting token ID, please override this function.
511      */
512     function _startTokenId() internal view virtual returns (uint256) {
513         return 0;
514     }
515 
516     /**
517      * @dev Returns the next token ID to be minted.
518      */
519     function _nextTokenId() internal view virtual returns (uint256) {
520         return _currentIndex;
521     }
522 
523     /**
524      * @dev Returns the total number of tokens in existence.
525      * Burned tokens will reduce the count.
526      * To get the total number of tokens minted, please see {_totalMinted}.
527      */
528     function totalSupply() public view virtual override returns (uint256) {
529         // Counter underflow is impossible as _burnCounter cannot be incremented
530         // more than `_currentIndex - _startTokenId()` times.
531         unchecked {
532             return _currentIndex - _burnCounter - _startTokenId();
533         }
534     }
535 
536     /**
537      * @dev Returns the total amount of tokens minted in the contract.
538      */
539     function _totalMinted() internal view virtual returns (uint256) {
540         // Counter underflow is impossible as `_currentIndex` does not decrement,
541         // and it is initialized to `_startTokenId()`.
542         unchecked {
543             return _currentIndex - _startTokenId();
544         }
545     }
546 
547     /**
548      * @dev Returns the total number of tokens burned.
549      */
550     function _totalBurned() internal view virtual returns (uint256) {
551         return _burnCounter;
552     }
553 
554     // =============================================================
555     //                    ADDRESS DATA OPERATIONS
556     // =============================================================
557 
558     /**
559      * @dev Returns the number of tokens in `owner`'s account.
560      */
561     function balanceOf(address owner) public view virtual override returns (uint256) {
562         if (owner == address(0)) revert BalanceQueryForZeroAddress();
563         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
564     }
565 
566     /**
567      * Returns the number of tokens minted by `owner`.
568      */
569     function _numberMinted(address owner) internal view returns (uint256) {
570         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
571     }
572 
573     /**
574      * Returns the number of tokens burned by or on behalf of `owner`.
575      */
576     function _numberBurned(address owner) internal view returns (uint256) {
577         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
578     }
579 
580     /**
581      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
582      */
583     function _getAux(address owner) internal view returns (uint64) {
584         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
585     }
586 
587     /**
588      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
589      * If there are multiple variables, please pack them into a uint64.
590      */
591     function _setAux(address owner, uint64 aux) internal virtual {
592         uint256 packed = _packedAddressData[owner];
593         uint256 auxCasted;
594         // Cast `aux` with assembly to avoid redundant masking.
595         assembly {
596             auxCasted := aux
597         }
598         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
599         _packedAddressData[owner] = packed;
600     }
601 
602     // =============================================================
603     //                            IERC165
604     // =============================================================
605 
606     /**
607      * @dev Returns true if this contract implements the interface defined by
608      * `interfaceId`. See the corresponding
609      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
610      * to learn more about how these ids are created.
611      *
612      * This function call must use less than 30000 gas.
613      */
614     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615         // The interface IDs are constants representing the first 4 bytes
616         // of the XOR of all function selectors in the interface.
617         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
618         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
619         return
620             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
621             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
622             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
623     }
624 
625     // =============================================================
626     //                        IERC721Metadata
627     // =============================================================
628 
629     /**
630      * @dev Returns the token collection name.
631      */
632     function name() public view virtual override returns (string memory) {
633         return _name;
634     }
635 
636     /**
637      * @dev Returns the token collection symbol.
638      */
639     function symbol() public view virtual override returns (string memory) {
640         return _symbol;
641     }
642 
643     /**
644      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
645      */
646     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
647         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
648 
649         string memory baseURI = _baseURI();
650         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
651     }
652 
653     /**
654      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
655      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
656      * by default, it can be overridden in child contracts.
657      */
658     function _baseURI() internal view virtual returns (string memory) {
659         return '';
660     }
661 
662     // =============================================================
663     //                     OWNERSHIPS OPERATIONS
664     // =============================================================
665 
666     /**
667      * @dev Returns the owner of the `tokenId` token.
668      *
669      * Requirements:
670      *
671      * - `tokenId` must exist.
672      */
673     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
674         return address(uint160(_packedOwnershipOf(tokenId)));
675     }
676 
677     /**
678      * @dev Gas spent here starts off proportional to the maximum mint batch size.
679      * It gradually moves to O(1) as tokens get transferred around over time.
680      */
681     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
682         return _unpackedOwnership(_packedOwnershipOf(tokenId));
683     }
684 
685     /**
686      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
687      */
688     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
689         return _unpackedOwnership(_packedOwnerships[index]);
690     }
691 
692     /**
693      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
694      */
695     function _initializeOwnershipAt(uint256 index) internal virtual {
696         if (_packedOwnerships[index] == 0) {
697             _packedOwnerships[index] = _packedOwnershipOf(index);
698         }
699     }
700 
701     /**
702      * Returns the packed ownership data of `tokenId`.
703      */
704     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
705         uint256 curr = tokenId;
706 
707         unchecked {
708             if (_startTokenId() <= curr)
709                 if (curr < _currentIndex) {
710                     uint256 packed = _packedOwnerships[curr];
711                     // If not burned.
712                     if (packed & _BITMASK_BURNED == 0) {
713                         // Invariant:
714                         // There will always be an initialized ownership slot
715                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
716                         // before an unintialized ownership slot
717                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
718                         // Hence, `curr` will not underflow.
719                         //
720                         // We can directly compare the packed value.
721                         // If the address is zero, packed will be zero.
722                         while (packed == 0) {
723                             packed = _packedOwnerships[--curr];
724                         }
725                         return packed;
726                     }
727                 }
728         }
729         revert OwnerQueryForNonexistentToken();
730     }
731 
732     /**
733      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
734      */
735     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
736         ownership.addr = address(uint160(packed));
737         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
738         ownership.burned = packed & _BITMASK_BURNED != 0;
739         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
740     }
741 
742     /**
743      * @dev Packs ownership data into a single uint256.
744      */
745     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
746         assembly {
747             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
748             owner := and(owner, _BITMASK_ADDRESS)
749             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
750             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
751         }
752     }
753 
754     /**
755      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
756      */
757     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
758         // For branchless setting of the `nextInitialized` flag.
759         assembly {
760             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
761             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
762         }
763     }
764 
765     // =============================================================
766     //                      APPROVAL OPERATIONS
767     // =============================================================
768 
769     /**
770      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
771      * The approval is cleared when the token is transferred.
772      *
773      * Only a single account can be approved at a time, so approving the
774      * zero address clears previous approvals.
775      *
776      * Requirements:
777      *
778      * - The caller must own the token or be an approved operator.
779      * - `tokenId` must exist.
780      *
781      * Emits an {Approval} event.
782      */
783     function approve(address to, uint256 tokenId) public payable virtual override {
784         address owner = ownerOf(tokenId);
785 
786         if (_msgSenderERC721A() != owner)
787             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
788                 revert ApprovalCallerNotOwnerNorApproved();
789             }
790 
791         _tokenApprovals[tokenId].value = to;
792         emit Approval(owner, to, tokenId);
793     }
794 
795     /**
796      * @dev Returns the account approved for `tokenId` token.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      */
802     function getApproved(uint256 tokenId) public view virtual override returns (address) {
803         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
804 
805         return _tokenApprovals[tokenId].value;
806     }
807 
808     /**
809      * @dev Approve or remove `operator` as an operator for the caller.
810      * Operators can call {transferFrom} or {safeTransferFrom}
811      * for any token owned by the caller.
812      *
813      * Requirements:
814      *
815      * - The `operator` cannot be the caller.
816      *
817      * Emits an {ApprovalForAll} event.
818      */
819     function setApprovalForAll(address operator, bool approved) public virtual override {
820         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
821         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
822     }
823 
824     /**
825      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
826      *
827      * See {setApprovalForAll}.
828      */
829     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
830         return _operatorApprovals[owner][operator];
831     }
832 
833     /**
834      * @dev Returns whether `tokenId` exists.
835      *
836      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
837      *
838      * Tokens start existing when they are minted. See {_mint}.
839      */
840     function _exists(uint256 tokenId) internal view virtual returns (bool) {
841         return
842             _startTokenId() <= tokenId &&
843             tokenId < _currentIndex && // If within bounds,
844             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
845     }
846 
847     /**
848      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
849      */
850     function _isSenderApprovedOrOwner(
851         address approvedAddress,
852         address owner,
853         address msgSender
854     ) private pure returns (bool result) {
855         assembly {
856             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
857             owner := and(owner, _BITMASK_ADDRESS)
858             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
859             msgSender := and(msgSender, _BITMASK_ADDRESS)
860             // `msgSender == owner || msgSender == approvedAddress`.
861             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
862         }
863     }
864 
865     /**
866      * @dev Returns the storage slot and value for the approved address of `tokenId`.
867      */
868     function _getApprovedSlotAndAddress(uint256 tokenId)
869         private
870         view
871         returns (uint256 approvedAddressSlot, address approvedAddress)
872     {
873         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
874         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
875         assembly {
876             approvedAddressSlot := tokenApproval.slot
877             approvedAddress := sload(approvedAddressSlot)
878         }
879     }
880 
881     // =============================================================
882     //                      TRANSFER OPERATIONS
883     // =============================================================
884 
885     /**
886      * @dev Transfers `tokenId` from `from` to `to`.
887      *
888      * Requirements:
889      *
890      * - `from` cannot be the zero address.
891      * - `to` cannot be the zero address.
892      * - `tokenId` token must be owned by `from`.
893      * - If the caller is not `from`, it must be approved to move this token
894      * by either {approve} or {setApprovalForAll}.
895      *
896      * Emits a {Transfer} event.
897      */
898     function transferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) public payable virtual override {
903         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
904 
905         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
906 
907         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
908 
909         // The nested ifs save around 20+ gas over a compound boolean condition.
910         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
911             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
912 
913         if (to == address(0)) revert TransferToZeroAddress();
914 
915         _beforeTokenTransfers(from, to, tokenId, 1);
916 
917         // Clear approvals from the previous owner.
918         assembly {
919             if approvedAddress {
920                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
921                 sstore(approvedAddressSlot, 0)
922             }
923         }
924 
925         // Underflow of the sender's balance is impossible because we check for
926         // ownership above and the recipient's balance can't realistically overflow.
927         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
928         unchecked {
929             // We can directly increment and decrement the balances.
930             --_packedAddressData[from]; // Updates: `balance -= 1`.
931             ++_packedAddressData[to]; // Updates: `balance += 1`.
932 
933             // Updates:
934             // - `address` to the next owner.
935             // - `startTimestamp` to the timestamp of transfering.
936             // - `burned` to `false`.
937             // - `nextInitialized` to `true`.
938             _packedOwnerships[tokenId] = _packOwnershipData(
939                 to,
940                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
941             );
942 
943             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
944             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
945                 uint256 nextTokenId = tokenId + 1;
946                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
947                 if (_packedOwnerships[nextTokenId] == 0) {
948                     // If the next slot is within bounds.
949                     if (nextTokenId != _currentIndex) {
950                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
951                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
952                     }
953                 }
954             }
955         }
956 
957         emit Transfer(from, to, tokenId);
958         _afterTokenTransfers(from, to, tokenId, 1);
959     }
960 
961     /**
962      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) public payable virtual override {
969         safeTransferFrom(from, to, tokenId, '');
970     }
971 
972     /**
973      * @dev Safely transfers `tokenId` token from `from` to `to`.
974      *
975      * Requirements:
976      *
977      * - `from` cannot be the zero address.
978      * - `to` cannot be the zero address.
979      * - `tokenId` token must exist and be owned by `from`.
980      * - If the caller is not `from`, it must be approved to move this token
981      * by either {approve} or {setApprovalForAll}.
982      * - If `to` refers to a smart contract, it must implement
983      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
984      *
985      * Emits a {Transfer} event.
986      */
987     function safeTransferFrom(
988         address from,
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) public payable virtual override {
993         transferFrom(from, to, tokenId);
994         if (to.code.length != 0)
995             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
996                 revert TransferToNonERC721ReceiverImplementer();
997             }
998     }
999 
1000     /**
1001      * @dev Hook that is called before a set of serially-ordered token IDs
1002      * are about to be transferred. This includes minting.
1003      * And also called before burning one token.
1004      *
1005      * `startTokenId` - the first token ID to be transferred.
1006      * `quantity` - the amount to be transferred.
1007      *
1008      * Calling conditions:
1009      *
1010      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1011      * transferred to `to`.
1012      * - When `from` is zero, `tokenId` will be minted for `to`.
1013      * - When `to` is zero, `tokenId` will be burned by `from`.
1014      * - `from` and `to` are never both zero.
1015      */
1016     function _beforeTokenTransfers(
1017         address from,
1018         address to,
1019         uint256 startTokenId,
1020         uint256 quantity
1021     ) internal virtual {}
1022 
1023     /**
1024      * @dev Hook that is called after a set of serially-ordered token IDs
1025      * have been transferred. This includes minting.
1026      * And also called after one token has been burned.
1027      *
1028      * `startTokenId` - the first token ID to be transferred.
1029      * `quantity` - the amount to be transferred.
1030      *
1031      * Calling conditions:
1032      *
1033      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1034      * transferred to `to`.
1035      * - When `from` is zero, `tokenId` has been minted for `to`.
1036      * - When `to` is zero, `tokenId` has been burned by `from`.
1037      * - `from` and `to` are never both zero.
1038      */
1039     function _afterTokenTransfers(
1040         address from,
1041         address to,
1042         uint256 startTokenId,
1043         uint256 quantity
1044     ) internal virtual {}
1045 
1046     /**
1047      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1048      *
1049      * `from` - Previous owner of the given token ID.
1050      * `to` - Target address that will receive the token.
1051      * `tokenId` - Token ID to be transferred.
1052      * `_data` - Optional data to send along with the call.
1053      *
1054      * Returns whether the call correctly returned the expected magic value.
1055      */
1056     function _checkContractOnERC721Received(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) private returns (bool) {
1062         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1063             bytes4 retval
1064         ) {
1065             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1066         } catch (bytes memory reason) {
1067             if (reason.length == 0) {
1068                 revert TransferToNonERC721ReceiverImplementer();
1069             } else {
1070                 assembly {
1071                     revert(add(32, reason), mload(reason))
1072                 }
1073             }
1074         }
1075     }
1076 
1077     // =============================================================
1078     //                        MINT OPERATIONS
1079     // =============================================================
1080 
1081     /**
1082      * @dev Mints `quantity` tokens and transfers them to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - `to` cannot be the zero address.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {Transfer} event for each mint.
1090      */
1091     function _mint(address to, uint256 quantity) internal virtual {
1092         uint256 startTokenId = _currentIndex;
1093         if (quantity == 0) revert MintZeroQuantity();
1094 
1095         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1096 
1097         // Overflows are incredibly unrealistic.
1098         // `balance` and `numberMinted` have a maximum limit of 2**64.
1099         // `tokenId` has a maximum limit of 2**256.
1100         unchecked {
1101             // Updates:
1102             // - `balance += quantity`.
1103             // - `numberMinted += quantity`.
1104             //
1105             // We can directly add to the `balance` and `numberMinted`.
1106             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1107 
1108             // Updates:
1109             // - `address` to the owner.
1110             // - `startTimestamp` to the timestamp of minting.
1111             // - `burned` to `false`.
1112             // - `nextInitialized` to `quantity == 1`.
1113             _packedOwnerships[startTokenId] = _packOwnershipData(
1114                 to,
1115                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1116             );
1117 
1118             uint256 toMasked;
1119             uint256 end = startTokenId + quantity;
1120 
1121             // Use assembly to loop and emit the `Transfer` event for gas savings.
1122             // The duplicated `log4` removes an extra check and reduces stack juggling.
1123             // The assembly, together with the surrounding Solidity code, have been
1124             // delicately arranged to nudge the compiler into producing optimized opcodes.
1125             assembly {
1126                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1127                 toMasked := and(to, _BITMASK_ADDRESS)
1128                 // Emit the `Transfer` event.
1129                 log4(
1130                     0, // Start of data (0, since no data).
1131                     0, // End of data (0, since no data).
1132                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1133                     0, // `address(0)`.
1134                     toMasked, // `to`.
1135                     startTokenId // `tokenId`.
1136                 )
1137 
1138                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1139                 // that overflows uint256 will make the loop run out of gas.
1140                 // The compiler will optimize the `iszero` away for performance.
1141                 for {
1142                     let tokenId := add(startTokenId, 1)
1143                 } iszero(eq(tokenId, end)) {
1144                     tokenId := add(tokenId, 1)
1145                 } {
1146                     // Emit the `Transfer` event. Similar to above.
1147                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1148                 }
1149             }
1150             if (toMasked == 0) revert MintToZeroAddress();
1151 
1152             _currentIndex = end;
1153         }
1154         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1155     }
1156 
1157     /**
1158      * @dev Mints `quantity` tokens and transfers them to `to`.
1159      *
1160      * This function is intended for efficient minting only during contract creation.
1161      *
1162      * It emits only one {ConsecutiveTransfer} as defined in
1163      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1164      * instead of a sequence of {Transfer} event(s).
1165      *
1166      * Calling this function outside of contract creation WILL make your contract
1167      * non-compliant with the ERC721 standard.
1168      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1169      * {ConsecutiveTransfer} event is only permissible during contract creation.
1170      *
1171      * Requirements:
1172      *
1173      * - `to` cannot be the zero address.
1174      * - `quantity` must be greater than 0.
1175      *
1176      * Emits a {ConsecutiveTransfer} event.
1177      */
1178     function _mintERC2309(address to, uint256 quantity) internal virtual {
1179         uint256 startTokenId = _currentIndex;
1180         if (to == address(0)) revert MintToZeroAddress();
1181         if (quantity == 0) revert MintZeroQuantity();
1182         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1183 
1184         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1185 
1186         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1187         unchecked {
1188             // Updates:
1189             // - `balance += quantity`.
1190             // - `numberMinted += quantity`.
1191             //
1192             // We can directly add to the `balance` and `numberMinted`.
1193             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1194 
1195             // Updates:
1196             // - `address` to the owner.
1197             // - `startTimestamp` to the timestamp of minting.
1198             // - `burned` to `false`.
1199             // - `nextInitialized` to `quantity == 1`.
1200             _packedOwnerships[startTokenId] = _packOwnershipData(
1201                 to,
1202                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1203             );
1204 
1205             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1206 
1207             _currentIndex = startTokenId + quantity;
1208         }
1209         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1210     }
1211 
1212     /**
1213      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1214      *
1215      * Requirements:
1216      *
1217      * - If `to` refers to a smart contract, it must implement
1218      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1219      * - `quantity` must be greater than 0.
1220      *
1221      * See {_mint}.
1222      *
1223      * Emits a {Transfer} event for each mint.
1224      */
1225     function _safeMint(
1226         address to,
1227         uint256 quantity,
1228         bytes memory _data
1229     ) internal virtual {
1230         _mint(to, quantity);
1231 
1232         unchecked {
1233             if (to.code.length != 0) {
1234                 uint256 end = _currentIndex;
1235                 uint256 index = end - quantity;
1236                 do {
1237                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1238                         revert TransferToNonERC721ReceiverImplementer();
1239                     }
1240                 } while (index < end);
1241                 // Reentrancy protection.
1242                 if (_currentIndex != end) revert();
1243             }
1244         }
1245     }
1246 
1247     /**
1248      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1249      */
1250     function _safeMint(address to, uint256 quantity) internal virtual {
1251         _safeMint(to, quantity, '');
1252     }
1253 
1254     // =============================================================
1255     //                        BURN OPERATIONS
1256     // =============================================================
1257 
1258     /**
1259      * @dev Equivalent to `_burn(tokenId, false)`.
1260      */
1261     function _burn(uint256 tokenId) internal virtual {
1262         _burn(tokenId, false);
1263     }
1264 
1265     /**
1266      * @dev Destroys `tokenId`.
1267      * The approval is cleared when the token is burned.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1276         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1277 
1278         address from = address(uint160(prevOwnershipPacked));
1279 
1280         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1281 
1282         if (approvalCheck) {
1283             // The nested ifs save around 20+ gas over a compound boolean condition.
1284             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1285                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1286         }
1287 
1288         _beforeTokenTransfers(from, address(0), tokenId, 1);
1289 
1290         // Clear approvals from the previous owner.
1291         assembly {
1292             if approvedAddress {
1293                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1294                 sstore(approvedAddressSlot, 0)
1295             }
1296         }
1297 
1298         // Underflow of the sender's balance is impossible because we check for
1299         // ownership above and the recipient's balance can't realistically overflow.
1300         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1301         unchecked {
1302             // Updates:
1303             // - `balance -= 1`.
1304             // - `numberBurned += 1`.
1305             //
1306             // We can directly decrement the balance, and increment the number burned.
1307             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1308             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1309 
1310             // Updates:
1311             // - `address` to the last owner.
1312             // - `startTimestamp` to the timestamp of burning.
1313             // - `burned` to `true`.
1314             // - `nextInitialized` to `true`.
1315             _packedOwnerships[tokenId] = _packOwnershipData(
1316                 from,
1317                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1318             );
1319 
1320             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1321             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1322                 uint256 nextTokenId = tokenId + 1;
1323                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1324                 if (_packedOwnerships[nextTokenId] == 0) {
1325                     // If the next slot is within bounds.
1326                     if (nextTokenId != _currentIndex) {
1327                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1328                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1329                     }
1330                 }
1331             }
1332         }
1333 
1334         emit Transfer(from, address(0), tokenId);
1335         _afterTokenTransfers(from, address(0), tokenId, 1);
1336 
1337         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1338         unchecked {
1339             _burnCounter++;
1340         }
1341     }
1342 
1343     // =============================================================
1344     //                     EXTRA DATA OPERATIONS
1345     // =============================================================
1346 
1347     /**
1348      * @dev Directly sets the extra data for the ownership data `index`.
1349      */
1350     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1351         uint256 packed = _packedOwnerships[index];
1352         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1353         uint256 extraDataCasted;
1354         // Cast `extraData` with assembly to avoid redundant masking.
1355         assembly {
1356             extraDataCasted := extraData
1357         }
1358         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1359         _packedOwnerships[index] = packed;
1360     }
1361 
1362     /**
1363      * @dev Called during each token transfer to set the 24bit `extraData` field.
1364      * Intended to be overridden by the cosumer contract.
1365      *
1366      * `previousExtraData` - the value of `extraData` before transfer.
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` will be minted for `to`.
1373      * - When `to` is zero, `tokenId` will be burned by `from`.
1374      * - `from` and `to` are never both zero.
1375      */
1376     function _extraData(
1377         address from,
1378         address to,
1379         uint24 previousExtraData
1380     ) internal view virtual returns (uint24) {}
1381 
1382     /**
1383      * @dev Returns the next extra data for the packed ownership data.
1384      * The returned result is shifted into position.
1385      */
1386     function _nextExtraData(
1387         address from,
1388         address to,
1389         uint256 prevOwnershipPacked
1390     ) private view returns (uint256) {
1391         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1392         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1393     }
1394 
1395     // =============================================================
1396     //                       OTHER OPERATIONS
1397     // =============================================================
1398 
1399     /**
1400      * @dev Returns the message sender (defaults to `msg.sender`).
1401      *
1402      * If you are writing GSN compatible contracts, you need to override this function.
1403      */
1404     function _msgSenderERC721A() internal view virtual returns (address) {
1405         return msg.sender;
1406     }
1407 
1408     /**
1409      * @dev Converts a uint256 to its ASCII string decimal representation.
1410      */
1411     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1412         assembly {
1413             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1414             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1415             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1416             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1417             let m := add(mload(0x40), 0xa0)
1418             // Update the free memory pointer to allocate.
1419             mstore(0x40, m)
1420             // Assign the `str` to the end.
1421             str := sub(m, 0x20)
1422             // Zeroize the slot after the string.
1423             mstore(str, 0)
1424 
1425             // Cache the end of the memory to calculate the length later.
1426             let end := str
1427 
1428             // We write the string from rightmost digit to leftmost digit.
1429             // The following is essentially a do-while loop that also handles the zero case.
1430             // prettier-ignore
1431             for { let temp := value } 1 {} {
1432                 str := sub(str, 1)
1433                 // Write the character to the pointer.
1434                 // The ASCII index of the '0' character is 48.
1435                 mstore8(str, add(48, mod(temp, 10)))
1436                 // Keep dividing `temp` until zero.
1437                 temp := div(temp, 10)
1438                 // prettier-ignore
1439                 if iszero(temp) { break }
1440             }
1441 
1442             let length := sub(end, str)
1443             // Move the pointer 32 bytes leftwards to make room for the length.
1444             str := sub(str, 0x20)
1445             // Store the length.
1446             mstore(str, length)
1447         }
1448     }
1449 }
1450 
1451 // File: @openzeppelin/contracts/utils/Strings.sol
1452 
1453 
1454 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1455 
1456 pragma solidity ^0.8.0;
1457 
1458 /**
1459  * @dev String operations.
1460  */
1461 library Strings {
1462     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1463     uint8 private constant _ADDRESS_LENGTH = 20;
1464 
1465     /**
1466      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1467      */
1468     function toString(uint256 value) internal pure returns (string memory) {
1469         // Inspired by OraclizeAPI's implementation - MIT licence
1470         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1471 
1472         if (value == 0) {
1473             return "0";
1474         }
1475         uint256 temp = value;
1476         uint256 digits;
1477         while (temp != 0) {
1478             digits++;
1479             temp /= 10;
1480         }
1481         bytes memory buffer = new bytes(digits);
1482         while (value != 0) {
1483             digits -= 1;
1484             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1485             value /= 10;
1486         }
1487         return string(buffer);
1488     }
1489 
1490     /**
1491      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1492      */
1493     function toHexString(uint256 value) internal pure returns (string memory) {
1494         if (value == 0) {
1495             return "0x00";
1496         }
1497         uint256 temp = value;
1498         uint256 length = 0;
1499         while (temp != 0) {
1500             length++;
1501             temp >>= 8;
1502         }
1503         return toHexString(value, length);
1504     }
1505 
1506     /**
1507      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1508      */
1509     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1510         bytes memory buffer = new bytes(2 * length + 2);
1511         buffer[0] = "0";
1512         buffer[1] = "x";
1513         for (uint256 i = 2 * length + 1; i > 1; --i) {
1514             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1515             value >>= 4;
1516         }
1517         require(value == 0, "Strings: hex length insufficient");
1518         return string(buffer);
1519     }
1520 
1521     /**
1522      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1523      */
1524     function toHexString(address addr) internal pure returns (string memory) {
1525         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1526     }
1527 }
1528 
1529 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1530 
1531 
1532 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1533 
1534 pragma solidity ^0.8.0;
1535 
1536 /**
1537  * @dev Interface of the ERC165 standard, as defined in the
1538  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1539  *
1540  * Implementers can declare support of contract interfaces, which can then be
1541  * queried by others ({ERC165Checker}).
1542  *
1543  * For an implementation, see {ERC165}.
1544  */
1545 interface IERC165 {
1546     /**
1547      * @dev Returns true if this contract implements the interface defined by
1548      * `interfaceId`. See the corresponding
1549      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1550      * to learn more about how these ids are created.
1551      *
1552      * This function call must use less than 30 000 gas.
1553      */
1554     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1555 }
1556 
1557 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1558 
1559 
1560 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1561 
1562 pragma solidity ^0.8.0;
1563 
1564 
1565 /**
1566  * @dev Required interface of an ERC721 compliant contract.
1567  */
1568 interface IERC721 is IERC165 {
1569     /**
1570      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1571      */
1572     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1573 
1574     /**
1575      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1576      */
1577     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1578 
1579     /**
1580      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1581      */
1582     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1583 
1584     /**
1585      * @dev Returns the number of tokens in ``owner``'s account.
1586      */
1587     function balanceOf(address owner) external view returns (uint256 balance);
1588 
1589     /**
1590      * @dev Returns the owner of the `tokenId` token.
1591      *
1592      * Requirements:
1593      *
1594      * - `tokenId` must exist.
1595      */
1596     function ownerOf(uint256 tokenId) external view returns (address owner);
1597 
1598     /**
1599      * @dev Safely transfers `tokenId` token from `from` to `to`.
1600      *
1601      * Requirements:
1602      *
1603      * - `from` cannot be the zero address.
1604      * - `to` cannot be the zero address.
1605      * - `tokenId` token must exist and be owned by `from`.
1606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function safeTransferFrom(
1612         address from,
1613         address to,
1614         uint256 tokenId,
1615         bytes calldata data
1616     ) external;
1617 
1618     /**
1619      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1620      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1621      *
1622      * Requirements:
1623      *
1624      * - `from` cannot be the zero address.
1625      * - `to` cannot be the zero address.
1626      * - `tokenId` token must exist and be owned by `from`.
1627      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function safeTransferFrom(
1633         address from,
1634         address to,
1635         uint256 tokenId
1636     ) external;
1637 
1638     /**
1639      * @dev Transfers `tokenId` token from `from` to `to`.
1640      *
1641      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1642      *
1643      * Requirements:
1644      *
1645      * - `from` cannot be the zero address.
1646      * - `to` cannot be the zero address.
1647      * - `tokenId` token must be owned by `from`.
1648      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1649      *
1650      * Emits a {Transfer} event.
1651      */
1652     function transferFrom(
1653         address from,
1654         address to,
1655         uint256 tokenId
1656     ) external;
1657 
1658     /**
1659      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1660      * The approval is cleared when the token is transferred.
1661      *
1662      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1663      *
1664      * Requirements:
1665      *
1666      * - The caller must own the token or be an approved operator.
1667      * - `tokenId` must exist.
1668      *
1669      * Emits an {Approval} event.
1670      */
1671     function approve(address to, uint256 tokenId) external;
1672 
1673     /**
1674      * @dev Approve or remove `operator` as an operator for the caller.
1675      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1676      *
1677      * Requirements:
1678      *
1679      * - The `operator` cannot be the caller.
1680      *
1681      * Emits an {ApprovalForAll} event.
1682      */
1683     function setApprovalForAll(address operator, bool _approved) external;
1684 
1685     /**
1686      * @dev Returns the account approved for `tokenId` token.
1687      *
1688      * Requirements:
1689      *
1690      * - `tokenId` must exist.
1691      */
1692     function getApproved(uint256 tokenId) external view returns (address operator);
1693 
1694     /**
1695      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1696      *
1697      * See {setApprovalForAll}
1698      */
1699     function isApprovedForAll(address owner, address operator) external view returns (bool);
1700 }
1701 
1702 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1703 
1704 
1705 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1706 
1707 pragma solidity ^0.8.0;
1708 
1709 
1710 /**
1711  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1712  * @dev See https://eips.ethereum.org/EIPS/eip-721
1713  */
1714 interface IERC721Enumerable is IERC721 {
1715     /**
1716      * @dev Returns the total amount of tokens stored by the contract.
1717      */
1718     function totalSupply() external view returns (uint256);
1719 
1720     /**
1721      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1722      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1723      */
1724     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1725 
1726     /**
1727      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1728      * Use along with {totalSupply} to enumerate all tokens.
1729      */
1730     function tokenByIndex(uint256 index) external view returns (uint256);
1731 }
1732 
1733 // File: @openzeppelin/contracts/utils/Context.sol
1734 
1735 
1736 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1737 
1738 pragma solidity ^0.8.0;
1739 
1740 /**
1741  * @dev Provides information about the current execution context, including the
1742  * sender of the transaction and its data. While these are generally available
1743  * via msg.sender and msg.data, they should not be accessed in such a direct
1744  * manner, since when dealing with meta-transactions the account sending and
1745  * paying for execution may not be the actual sender (as far as an application
1746  * is concerned).
1747  *
1748  * This contract is only required for intermediate, library-like contracts.
1749  */
1750 abstract contract Context {
1751     function _msgSender() internal view virtual returns (address) {
1752         return msg.sender;
1753     }
1754 
1755     function _msgData() internal view virtual returns (bytes calldata) {
1756         return msg.data;
1757     }
1758 }
1759 
1760 // File: @openzeppelin/contracts/access/Ownable.sol
1761 
1762 
1763 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1764 
1765 pragma solidity ^0.8.0;
1766 
1767 
1768 /**
1769  * @dev Contract module which provides a basic access control mechanism, where
1770  * there is an account (an owner) that can be granted exclusive access to
1771  * specific functions.
1772  *
1773  * By default, the owner account will be the one that deploys the contract. This
1774  * can later be changed with {transferOwnership}.
1775  *
1776  * This module is used through inheritance. It will make available the modifier
1777  * `onlyOwner`, which can be applied to your functions to restrict their use to
1778  * the owner.
1779  */
1780 abstract contract Ownable is Context {
1781     address private _owner;
1782 
1783     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1784 
1785     /**
1786      * @dev Initializes the contract setting the deployer as the initial owner.
1787      */
1788     constructor() {
1789         _transferOwnership(_msgSender());
1790     }
1791 
1792     /**
1793      * @dev Throws if called by any account other than the owner.
1794      */
1795     modifier onlyOwner() {
1796         _checkOwner();
1797         _;
1798     }
1799 
1800     /**
1801      * @dev Returns the address of the current owner.
1802      */
1803     function owner() public view virtual returns (address) {
1804         return _owner;
1805     }
1806 
1807     /**
1808      * @dev Throws if the sender is not the owner.
1809      */
1810     function _checkOwner() internal view virtual {
1811         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1812     }
1813 
1814     /**
1815      * @dev Leaves the contract without owner. It will not be possible to call
1816      * `onlyOwner` functions anymore. Can only be called by the current owner.
1817      *
1818      * NOTE: Renouncing ownership will leave the contract without an owner,
1819      * thereby removing any functionality that is only available to the owner.
1820      */
1821     function renounceOwnership() public virtual onlyOwner {
1822         _transferOwnership(address(0));
1823     }
1824 
1825     /**
1826      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1827      * Can only be called by the current owner.
1828      */
1829     function transferOwnership(address newOwner) public virtual onlyOwner {
1830         require(newOwner != address(0), "Ownable: new owner is the zero address");
1831         _transferOwnership(newOwner);
1832     }
1833 
1834     /**
1835      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1836      * Internal function without access restriction.
1837      */
1838     function _transferOwnership(address newOwner) internal virtual {
1839         address oldOwner = _owner;
1840         _owner = newOwner;
1841         emit OwnershipTransferred(oldOwner, newOwner);
1842     }
1843 }
1844 
1845 // File: contracts/MysteryBox.sol
1846 
1847 pragma solidity >=0.8.0 <0.9.0;
1848 
1849 
1850 contract MysteryBox is ERC721A, Ownable {
1851     using Strings for uint256;
1852 
1853     /// Supply
1854     uint256 public constant MAX_SUPPLY = 10877;
1855     uint256 public PRICE = 0 ether;
1856 
1857     /// Status
1858     enum Status {
1859         NOT_LIVE,
1860         TOKEN_MINT,
1861         BURN,
1862         ENDED
1863     }
1864 
1865     /// Minting Variables
1866     IERC721Enumerable constant inBetweenersTokenContract = IERC721Enumerable(0x94638Cbf3c54c1f956a5F05cBC0F9aFb6822020d);
1867     Status public state;
1868     address private burnerContract;
1869 
1870     string public baseURI = "ipfs://QmciK5JqKLNeKFpyhZQykMehP2jUUxaR724oHRKs2XbEtF/";
1871 
1872     mapping(uint256 => bool) public inBetweenersTokenClaimed;
1873 
1874     constructor() ERC721A("Mystery Box", "INMB") {
1875     }
1876 
1877     function setBurnerContract(address _address) external onlyOwner {
1878         burnerContract = _address;
1879     }
1880 
1881     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1882         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1883         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1884     }
1885 
1886     function ownerMint(uint256 _amount) external onlyOwner {
1887         require(state == Status.NOT_LIVE || state == Status.TOKEN_MINT);
1888         require(totalSupply() + _amount <= MAX_SUPPLY, "Mystery Box claim amount exceeds supply");
1889         _safeMint(msg.sender, _amount);
1890     }
1891 
1892     function checkClaimed(uint256 _tokenId) external view returns (bool) { //added
1893         return inBetweenersTokenClaimed[_tokenId];
1894     }
1895 
1896     function getRemainingSupply() external view returns (uint256) {
1897         return MAX_SUPPLY - totalSupply();
1898     }
1899 
1900     function claimMysteryBox(uint256[] memory tokenIds) external payable {
1901         require(state == Status.TOKEN_MINT, "Claim Not Live");
1902         require(inBetweenersTokenContract.balanceOf(msg.sender) >= tokenIds.length, "Caller does not own enough inBetweeners");
1903         require (totalSupply() + tokenIds.length <= MAX_SUPPLY, "Mystery Box claim amount exceeds supply"); //added
1904 
1905 
1906         uint256 mintCounter;  
1907         for (uint256 i = 0; i < tokenIds.length; i++) {
1908             require(inBetweenersTokenClaimed[tokenIds[i]]==false,"inBetweeners tokenid claimed already"); //added
1909             require(msg.sender == inBetweenersTokenContract.ownerOf(tokenIds[i]), "Message sender is not owner of tokenid");
1910             inBetweenersTokenClaimed[tokenIds[i]] = true;
1911             mintCounter++;
1912         }
1913         _safeMint(msg.sender, mintCounter);
1914     }
1915 
1916     function setState(Status _state) external onlyOwner {
1917         state = _state;
1918     }
1919     
1920     function setURI(string calldata _newURI) external onlyOwner {
1921         baseURI = _newURI;
1922     }
1923 
1924     function userBurn(uint256 tokenId) external {
1925         require(state == Status.BURN, "Burn state not live");
1926         require(msg.sender == ownerOf(tokenId), "Caller does not own token");
1927         _burn(tokenId, true);
1928     }
1929 
1930     function ownerBurn(uint256 tokenId) external onlyOwner {
1931         require(state == Status.BURN, "Burn state not live");
1932         _burn(tokenId, true);
1933     }
1934 
1935     function contractBurn(uint256 tokenId) external onlyOwner {
1936         require(state == Status.BURN, "Burn state not live");
1937         require(msg.sender == burnerContract, "Caller does not own token");
1938         _burn(tokenId, true);
1939     }
1940 
1941     function withdrawMoney() external onlyOwner {
1942         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1943         require(success, "Withdraw failed.");
1944     }
1945 
1946 }