1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 /*
5 55555555555555Y7JY5555555555555555555P5YJJJYYYYY555555555555
6 5555555555555557???J555555555555555PY7~~~!7?JJYY555555555555
7 555555555555555Y!?77?7J5555555555PY!^!77JY555555555555555555
8 555555555555555PY777??!!5555555557~!???Y55555555555555555555
9 555555555555555555Y?77J!?PPPP5PY7?YY555555555555555555555555
10 555555555555555555555Y?!!YJJ?777!7?JY5PP55555555555555555555
11 555555555555555555555PY77!~~~~~~~~~~~!7J5P555555555555555555
12 55555555555555555555P?^!!~~~~~~~~~!!~~~~!?555555555555555555
13 5555555555555555555PY!7~~~~~~~~~!!!!!!!!!~?P5555555555555555
14 5555555555555555555PYJ7~~~~~~~!!7!!!~!!!!~7P5555555555555555
15 555555555555555555YYY?7!~~~~~!!!!77~~~!!!!!55555555555555555
16 55555555555555555PJJYY7!~~~~~!~!Y7!~~~!~7!!55555555555555555
17 55555555555555555PJJJ5?7~~~~!?7?PY!~~!?!PY!Y5555555555555555
18 5555555555555555555??Y?7!~~~~~!!~~~~~!!!!!~JP555555555555555
19 55555555555555555555YJYJ7~~~~~~~~!!7!~!!~~~55555555555555555
20 555555555555555555555P5?J?~~~~~~~!!7!!!!~~YP5555555555555555
21 55555555555555555555555??Y?!~~~~!!!!!!!!~JP55555555555555555
22 5555555555555555555555P77J5Y?7~~~~~~~~~~?5555555555555555555
23 55555555555555555555555!!!J?JYJ?7!!!!!7YP5555555555555555555
24 555555555555555555555P?!!~!!77?JYYP5555555555555555555555555
25 5555555555555555555PGY!~~~~!!!!7775GP55555555555555555555555
26 55555555555555PPPPGGGG5YJJ????JJYYPBGGPP55555555555555555555
27 555555555PPPGGGGGGGGGBBBBBBBGBBBBBBBBBBGGGGPPP55555555555555
28 55555555PGGBBGGGGGGGGGGGBBBBBBBBBBGGGGGGGGG?7J5P555555555555
29 5555555P?!7JPBGGGGGGGGGGGGGGGGGGGGGGGGGGGGBY~~!5P55555555555
30 555555PY~~~~!PBGGGGGGGGGGGGGGGGGGGGGGGGGGGBP~~~?G55555555555
31 555555G!~~~~!JBGGGGGGGGGGGGGGGGGGGGGGGGGGGBP~~~~PP5555555555
32 55555GY~~~~!!5BGGGGGGGGGGGGGGGGGGGGGGGGGGGBB!~~~?B5555555555
33 */
34 
35 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Contract module that helps prevent reentrant calls to a function.
41  *
42  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
43  * available, which can be applied to functions to make sure there are no nested
44  * (reentrant) calls to them.
45  *
46  * Note that because there is a single `nonReentrant` guard, functions marked as
47  * `nonReentrant` may not call one another. This can be worked around by making
48  * those functions `private`, and then adding `external` `nonReentrant` entry
49  * points to them.
50  *
51  * TIP: If you would like to learn more about reentrancy and alternative ways
52  * to protect against it, check out our blog post
53  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
54  */
55 abstract contract ReentrancyGuard {
56     // Booleans are more expensive than uint256 or any type that takes up a full
57     // word because each write operation emits an extra SLOAD to first read the
58     // slot's contents, replace the bits taken up by the boolean, and then write
59     // back. This is the compiler's defense against contract upgrades and
60     // pointer aliasing, and it cannot be disabled.
61 
62     // The values being non-zero value makes deployment a bit more expensive,
63     // but in exchange the refund on every call to nonReentrant will be lower in
64     // amount. Since refunds are capped to a percentage of the total
65     // transaction's gas, it is best to keep them low in cases like this one, to
66     // increase the likelihood of the full refund coming into effect.
67     uint256 private constant _NOT_ENTERED = 1;
68     uint256 private constant _ENTERED = 2;
69 
70     uint256 private _status;
71 
72     constructor() {
73         _status = _NOT_ENTERED;
74     }
75 
76     /**
77      * @dev Prevents a contract from calling itself, directly or indirectly.
78      * Calling a `nonReentrant` function from another `nonReentrant`
79      * function is not supported. It is possible to prevent this from happening
80      * by making the `nonReentrant` function external, and making it call a
81      * `private` function that does the actual work.
82      */
83     modifier nonReentrant() {
84         // On the first call to nonReentrant, _notEntered will be true
85         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
86 
87         // Any calls to nonReentrant after this point will fail
88         _status = _ENTERED;
89 
90         _;
91 
92         // By storing the original value once again, a refund is triggered (see
93         // https://eips.ethereum.org/EIPS/eip-2200)
94         _status = _NOT_ENTERED;
95     }
96 }
97 
98 // File: erc721a/contracts/IERC721A.sol
99 
100 
101 // ERC721A Contracts v4.2.2
102 // Creator: Chiru Labs
103 
104 pragma solidity ^0.8.4;
105 
106 /**
107  * @dev Interface of ERC721A.
108  */
109 interface IERC721A {
110     /**
111      * The caller must own the token or be an approved operator.
112      */
113     error ApprovalCallerNotOwnerNorApproved();
114 
115     /**
116      * The token does not exist.
117      */
118     error ApprovalQueryForNonexistentToken();
119 
120     /**
121      * The caller cannot approve to their own address.
122      */
123     error ApproveToCaller();
124 
125     /**
126      * Cannot query the balance for the zero address.
127      */
128     error BalanceQueryForZeroAddress();
129 
130     /**
131      * Cannot mint to the zero address.
132      */
133     error MintToZeroAddress();
134 
135     /**
136      * The quantity of tokens minted must be more than zero.
137      */
138     error MintZeroQuantity();
139 
140     /**
141      * The token does not exist.
142      */
143     error OwnerQueryForNonexistentToken();
144 
145     /**
146      * The caller must own the token or be an approved operator.
147      */
148     error TransferCallerNotOwnerNorApproved();
149 
150     /**
151      * The token must be owned by `from`.
152      */
153     error TransferFromIncorrectOwner();
154 
155     /**
156      * Cannot safely transfer to a contract that does not implement the
157      * ERC721Receiver interface.
158      */
159     error TransferToNonERC721ReceiverImplementer();
160 
161     /**
162      * Cannot transfer to the zero address.
163      */
164     error TransferToZeroAddress();
165 
166     /**
167      * The token does not exist.
168      */
169     error URIQueryForNonexistentToken();
170 
171     /**
172      * The `quantity` minted with ERC2309 exceeds the safety limit.
173      */
174     error MintERC2309QuantityExceedsLimit();
175 
176     /**
177      * The `extraData` cannot be set on an unintialized ownership slot.
178      */
179     error OwnershipNotInitializedForExtraData();
180 
181     // =============================================================
182     //                            STRUCTS
183     // =============================================================
184 
185     struct TokenOwnership {
186         // The address of the owner.
187         address addr;
188         // Stores the start time of ownership with minimal overhead for tokenomics.
189         uint64 startTimestamp;
190         // Whether the token has been burned.
191         bool burned;
192         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
193         uint24 extraData;
194     }
195 
196     // =============================================================
197     //                         TOKEN COUNTERS
198     // =============================================================
199 
200     /**
201      * @dev Returns the total number of tokens in existence.
202      * Burned tokens will reduce the count.
203      * To get the total number of tokens minted, please see {_totalMinted}.
204      */
205     function totalSupply() external view returns (uint256);
206 
207     // =============================================================
208     //                            IERC165
209     // =============================================================
210 
211     /**
212      * @dev Returns true if this contract implements the interface defined by
213      * `interfaceId`. See the corresponding
214      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
215      * to learn more about how these ids are created.
216      *
217      * This function call must use less than 30000 gas.
218      */
219     function supportsInterface(bytes4 interfaceId) external view returns (bool);
220 
221     // =============================================================
222     //                            IERC721
223     // =============================================================
224 
225     /**
226      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
227      */
228     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
229 
230     /**
231      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
232      */
233     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
234 
235     /**
236      * @dev Emitted when `owner` enables or disables
237      * (`approved`) `operator` to manage all of its assets.
238      */
239     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
240 
241     /**
242      * @dev Returns the number of tokens in `owner`'s account.
243      */
244     function balanceOf(address owner) external view returns (uint256 balance);
245 
246     /**
247      * @dev Returns the owner of the `tokenId` token.
248      *
249      * Requirements:
250      *
251      * - `tokenId` must exist.
252      */
253     function ownerOf(uint256 tokenId) external view returns (address owner);
254 
255     /**
256      * @dev Safely transfers `tokenId` token from `from` to `to`,
257      * checking first that contract recipients are aware of the ERC721 protocol
258      * to prevent tokens from being forever locked.
259      *
260      * Requirements:
261      *
262      * - `from` cannot be the zero address.
263      * - `to` cannot be the zero address.
264      * - `tokenId` token must exist and be owned by `from`.
265      * - If the caller is not `from`, it must be have been allowed to move
266      * this token by either {approve} or {setApprovalForAll}.
267      * - If `to` refers to a smart contract, it must implement
268      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
269      *
270      * Emits a {Transfer} event.
271      */
272     function safeTransferFrom(
273         address from,
274         address to,
275         uint256 tokenId,
276         bytes calldata data
277     ) external;
278 
279     /**
280      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
281      */
282     function safeTransferFrom(
283         address from,
284         address to,
285         uint256 tokenId
286     ) external;
287 
288     /**
289      * @dev Transfers `tokenId` from `from` to `to`.
290      *
291      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
292      * whenever possible.
293      *
294      * Requirements:
295      *
296      * - `from` cannot be the zero address.
297      * - `to` cannot be the zero address.
298      * - `tokenId` token must be owned by `from`.
299      * - If the caller is not `from`, it must be approved to move this token
300      * by either {approve} or {setApprovalForAll}.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transferFrom(
305         address from,
306         address to,
307         uint256 tokenId
308     ) external;
309 
310     /**
311      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
312      * The approval is cleared when the token is transferred.
313      *
314      * Only a single account can be approved at a time, so approving the
315      * zero address clears previous approvals.
316      *
317      * Requirements:
318      *
319      * - The caller must own the token or be an approved operator.
320      * - `tokenId` must exist.
321      *
322      * Emits an {Approval} event.
323      */
324     function approve(address to, uint256 tokenId) external;
325 
326     /**
327      * @dev Approve or remove `operator` as an operator for the caller.
328      * Operators can call {transferFrom} or {safeTransferFrom}
329      * for any token owned by the caller.
330      *
331      * Requirements:
332      *
333      * - The `operator` cannot be the caller.
334      *
335      * Emits an {ApprovalForAll} event.
336      */
337     function setApprovalForAll(address operator, bool _approved) external;
338 
339     /**
340      * @dev Returns the account approved for `tokenId` token.
341      *
342      * Requirements:
343      *
344      * - `tokenId` must exist.
345      */
346     function getApproved(uint256 tokenId) external view returns (address operator);
347 
348     /**
349      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
350      *
351      * See {setApprovalForAll}.
352      */
353     function isApprovedForAll(address owner, address operator) external view returns (bool);
354 
355     // =============================================================
356     //                        IERC721Metadata
357     // =============================================================
358 
359     /**
360      * @dev Returns the token collection name.
361      */
362     function name() external view returns (string memory);
363 
364     /**
365      * @dev Returns the token collection symbol.
366      */
367     function symbol() external view returns (string memory);
368 
369     /**
370      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
371      */
372     function tokenURI(uint256 tokenId) external view returns (string memory);
373 
374     // =============================================================
375     //                           IERC2309
376     // =============================================================
377 
378     /**
379      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
380      * (inclusive) is transferred from `from` to `to`, as defined in the
381      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
382      *
383      * See {_mintERC2309} for more details.
384      */
385     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
386 }
387 
388 // File: erc721a/contracts/ERC721A.sol
389 
390 
391 // ERC721A Contracts v4.2.2
392 // Creator: Chiru Labs
393 
394 pragma solidity ^0.8.4;
395 
396 
397 /**
398  * @dev Interface of ERC721 token receiver.
399  */
400 interface ERC721A__IERC721Receiver {
401     function onERC721Received(
402         address operator,
403         address from,
404         uint256 tokenId,
405         bytes calldata data
406     ) external returns (bytes4);
407 }
408 
409 /**
410  * @title ERC721A
411  *
412  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
413  * Non-Fungible Token Standard, including the Metadata extension.
414  * Optimized for lower gas during batch mints.
415  *
416  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
417  * starting from `_startTokenId()`.
418  *
419  * Assumptions:
420  *
421  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
422  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
423  */
424 contract ERC721A is IERC721A {
425     // Reference type for token approval.
426     struct TokenApprovalRef {
427         address value;
428     }
429 
430     // =============================================================
431     //                           CONSTANTS
432     // =============================================================
433 
434     // Mask of an entry in packed address data.
435     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
436 
437     // The bit position of `numberMinted` in packed address data.
438     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
439 
440     // The bit position of `numberBurned` in packed address data.
441     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
442 
443     // The bit position of `aux` in packed address data.
444     uint256 private constant _BITPOS_AUX = 192;
445 
446     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
447     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
448 
449     // The bit position of `startTimestamp` in packed ownership.
450     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
451 
452     // The bit mask of the `burned` bit in packed ownership.
453     uint256 private constant _BITMASK_BURNED = 1 << 224;
454 
455     // The bit position of the `nextInitialized` bit in packed ownership.
456     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
457 
458     // The bit mask of the `nextInitialized` bit in packed ownership.
459     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
460 
461     // The bit position of `extraData` in packed ownership.
462     uint256 private constant _BITPOS_EXTRA_DATA = 232;
463 
464     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
465     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
466 
467     // The mask of the lower 160 bits for addresses.
468     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
469 
470     // The maximum `quantity` that can be minted with {_mintERC2309}.
471     // This limit is to prevent overflows on the address data entries.
472     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
473     // is required to cause an overflow, which is unrealistic.
474     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
475 
476     // The `Transfer` event signature is given by:
477     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
478     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
479         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
480 
481     // =============================================================
482     //                            STORAGE
483     // =============================================================
484 
485     // The next token ID to be minted.
486     uint256 private _currentIndex;
487 
488     // The number of tokens burned.
489     uint256 private _burnCounter;
490 
491     // Token name
492     string private _name;
493 
494     // Token symbol
495     string private _symbol;
496 
497     // Mapping from token ID to ownership details
498     // An empty struct value does not necessarily mean the token is unowned.
499     // See {_packedOwnershipOf} implementation for details.
500     //
501     // Bits Layout:
502     // - [0..159]   `addr`
503     // - [160..223] `startTimestamp`
504     // - [224]      `burned`
505     // - [225]      `nextInitialized`
506     // - [232..255] `extraData`
507     mapping(uint256 => uint256) private _packedOwnerships;
508 
509     // Mapping owner address to address data.
510     //
511     // Bits Layout:
512     // - [0..63]    `balance`
513     // - [64..127]  `numberMinted`
514     // - [128..191] `numberBurned`
515     // - [192..255] `aux`
516     mapping(address => uint256) private _packedAddressData;
517 
518     // Mapping from token ID to approved address.
519     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
520 
521     // Mapping from owner to operator approvals
522     mapping(address => mapping(address => bool)) private _operatorApprovals;
523 
524     // =============================================================
525     //                          CONSTRUCTOR
526     // =============================================================
527 
528     constructor(string memory name_, string memory symbol_) {
529         _name = name_;
530         _symbol = symbol_;
531         _currentIndex = _startTokenId();
532     }
533 
534     // =============================================================
535     //                   TOKEN COUNTING OPERATIONS
536     // =============================================================
537 
538     /**
539      * @dev Returns the starting token ID.
540      * To change the starting token ID, please override this function.
541      */
542     function _startTokenId() internal view virtual returns (uint256) {
543         return 0;
544     }
545 
546     /**
547      * @dev Returns the next token ID to be minted.
548      */
549     function _nextTokenId() internal view virtual returns (uint256) {
550         return _currentIndex;
551     }
552 
553     /**
554      * @dev Returns the total number of tokens in existence.
555      * Burned tokens will reduce the count.
556      * To get the total number of tokens minted, please see {_totalMinted}.
557      */
558     function totalSupply() public view virtual override returns (uint256) {
559         // Counter underflow is impossible as _burnCounter cannot be incremented
560         // more than `_currentIndex - _startTokenId()` times.
561         unchecked {
562             return _currentIndex - _burnCounter - _startTokenId();
563         }
564     }
565 
566     /**
567      * @dev Returns the total amount of tokens minted in the contract.
568      */
569     function _totalMinted() internal view virtual returns (uint256) {
570         // Counter underflow is impossible as `_currentIndex` does not decrement,
571         // and it is initialized to `_startTokenId()`.
572         unchecked {
573             return _currentIndex - _startTokenId();
574         }
575     }
576 
577     /**
578      * @dev Returns the total number of tokens burned.
579      */
580     function _totalBurned() internal view virtual returns (uint256) {
581         return _burnCounter;
582     }
583 
584     // =============================================================
585     //                    ADDRESS DATA OPERATIONS
586     // =============================================================
587 
588     /**
589      * @dev Returns the number of tokens in `owner`'s account.
590      */
591     function balanceOf(address owner) public view virtual override returns (uint256) {
592         if (owner == address(0)) revert BalanceQueryForZeroAddress();
593         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
594     }
595 
596     /**
597      * Returns the number of tokens minted by `owner`.
598      */
599     function _numberMinted(address owner) internal view returns (uint256) {
600         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
601     }
602 
603     /**
604      * Returns the number of tokens burned by or on behalf of `owner`.
605      */
606     function _numberBurned(address owner) internal view returns (uint256) {
607         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
608     }
609 
610     /**
611      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
612      */
613     function _getAux(address owner) internal view returns (uint64) {
614         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
615     }
616 
617     /**
618      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
619      * If there are multiple variables, please pack them into a uint64.
620      */
621     function _setAux(address owner, uint64 aux) internal virtual {
622         uint256 packed = _packedAddressData[owner];
623         uint256 auxCasted;
624         // Cast `aux` with assembly to avoid redundant masking.
625         assembly {
626             auxCasted := aux
627         }
628         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
629         _packedAddressData[owner] = packed;
630     }
631 
632     // =============================================================
633     //                            IERC165
634     // =============================================================
635 
636     /**
637      * @dev Returns true if this contract implements the interface defined by
638      * `interfaceId`. See the corresponding
639      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
640      * to learn more about how these ids are created.
641      *
642      * This function call must use less than 30000 gas.
643      */
644     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
645         // The interface IDs are constants representing the first 4 bytes
646         // of the XOR of all function selectors in the interface.
647         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
648         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
649         return
650             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
651             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
652             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
653     }
654 
655     // =============================================================
656     //                        IERC721Metadata
657     // =============================================================
658 
659     /**
660      * @dev Returns the token collection name.
661      */
662     function name() public view virtual override returns (string memory) {
663         return _name;
664     }
665 
666     /**
667      * @dev Returns the token collection symbol.
668      */
669     function symbol() public view virtual override returns (string memory) {
670         return _symbol;
671     }
672 
673     /**
674      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
675      */
676     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
677         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
678 
679         string memory baseURI = _baseURI();
680         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
681     }
682 
683     /**
684      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
685      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
686      * by default, it can be overridden in child contracts.
687      */
688     function _baseURI() internal view virtual returns (string memory) {
689         return '';
690     }
691 
692     // =============================================================
693     //                     OWNERSHIPS OPERATIONS
694     // =============================================================
695 
696     /**
697      * @dev Returns the owner of the `tokenId` token.
698      *
699      * Requirements:
700      *
701      * - `tokenId` must exist.
702      */
703     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
704         return address(uint160(_packedOwnershipOf(tokenId)));
705     }
706 
707     /**
708      * @dev Gas spent here starts off proportional to the maximum mint batch size.
709      * It gradually moves to O(1) as tokens get transferred around over time.
710      */
711     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
712         return _unpackedOwnership(_packedOwnershipOf(tokenId));
713     }
714 
715     /**
716      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
717      */
718     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
719         return _unpackedOwnership(_packedOwnerships[index]);
720     }
721 
722     /**
723      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
724      */
725     function _initializeOwnershipAt(uint256 index) internal virtual {
726         if (_packedOwnerships[index] == 0) {
727             _packedOwnerships[index] = _packedOwnershipOf(index);
728         }
729     }
730 
731     /**
732      * Returns the packed ownership data of `tokenId`.
733      */
734     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
735         uint256 curr = tokenId;
736 
737         unchecked {
738             if (_startTokenId() <= curr)
739                 if (curr < _currentIndex) {
740                     uint256 packed = _packedOwnerships[curr];
741                     // If not burned.
742                     if (packed & _BITMASK_BURNED == 0) {
743                         // Invariant:
744                         // There will always be an initialized ownership slot
745                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
746                         // before an unintialized ownership slot
747                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
748                         // Hence, `curr` will not underflow.
749                         //
750                         // We can directly compare the packed value.
751                         // If the address is zero, packed will be zero.
752                         while (packed == 0) {
753                             packed = _packedOwnerships[--curr];
754                         }
755                         return packed;
756                     }
757                 }
758         }
759         revert OwnerQueryForNonexistentToken();
760     }
761 
762     /**
763      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
764      */
765     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
766         ownership.addr = address(uint160(packed));
767         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
768         ownership.burned = packed & _BITMASK_BURNED != 0;
769         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
770     }
771 
772     /**
773      * @dev Packs ownership data into a single uint256.
774      */
775     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
776         assembly {
777             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
778             owner := and(owner, _BITMASK_ADDRESS)
779             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
780             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
781         }
782     }
783 
784     /**
785      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
786      */
787     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
788         // For branchless setting of the `nextInitialized` flag.
789         assembly {
790             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
791             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
792         }
793     }
794 
795     // =============================================================
796     //                      APPROVAL OPERATIONS
797     // =============================================================
798 
799     /**
800      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
801      * The approval is cleared when the token is transferred.
802      *
803      * Only a single account can be approved at a time, so approving the
804      * zero address clears previous approvals.
805      *
806      * Requirements:
807      *
808      * - The caller must own the token or be an approved operator.
809      * - `tokenId` must exist.
810      *
811      * Emits an {Approval} event.
812      */
813     function approve(address to, uint256 tokenId) public virtual override {
814         address owner = ownerOf(tokenId);
815 
816         if (_msgSenderERC721A() != owner)
817             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
818                 revert ApprovalCallerNotOwnerNorApproved();
819             }
820 
821         _tokenApprovals[tokenId].value = to;
822         emit Approval(owner, to, tokenId);
823     }
824 
825     /**
826      * @dev Returns the account approved for `tokenId` token.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      */
832     function getApproved(uint256 tokenId) public view virtual override returns (address) {
833         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
834 
835         return _tokenApprovals[tokenId].value;
836     }
837 
838     /**
839      * @dev Approve or remove `operator` as an operator for the caller.
840      * Operators can call {transferFrom} or {safeTransferFrom}
841      * for any token owned by the caller.
842      *
843      * Requirements:
844      *
845      * - The `operator` cannot be the caller.
846      *
847      * Emits an {ApprovalForAll} event.
848      */
849     function setApprovalForAll(address operator, bool approved) public virtual override {
850         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
851 
852         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
853         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
854     }
855 
856     /**
857      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
858      *
859      * See {setApprovalForAll}.
860      */
861     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
862         return _operatorApprovals[owner][operator];
863     }
864 
865     /**
866      * @dev Returns whether `tokenId` exists.
867      *
868      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
869      *
870      * Tokens start existing when they are minted. See {_mint}.
871      */
872     function _exists(uint256 tokenId) internal view virtual returns (bool) {
873         return
874             _startTokenId() <= tokenId &&
875             tokenId < _currentIndex && // If within bounds,
876             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
877     }
878 
879     /**
880      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
881      */
882     function _isSenderApprovedOrOwner(
883         address approvedAddress,
884         address owner,
885         address msgSender
886     ) private pure returns (bool result) {
887         assembly {
888             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
889             owner := and(owner, _BITMASK_ADDRESS)
890             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
891             msgSender := and(msgSender, _BITMASK_ADDRESS)
892             // `msgSender == owner || msgSender == approvedAddress`.
893             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
894         }
895     }
896 
897     /**
898      * @dev Returns the storage slot and value for the approved address of `tokenId`.
899      */
900     function _getApprovedSlotAndAddress(uint256 tokenId)
901         private
902         view
903         returns (uint256 approvedAddressSlot, address approvedAddress)
904     {
905         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
906         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
907         assembly {
908             approvedAddressSlot := tokenApproval.slot
909             approvedAddress := sload(approvedAddressSlot)
910         }
911     }
912 
913     // =============================================================
914     //                      TRANSFER OPERATIONS
915     // =============================================================
916 
917     /**
918      * @dev Transfers `tokenId` from `from` to `to`.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must be owned by `from`.
925      * - If the caller is not `from`, it must be approved to move this token
926      * by either {approve} or {setApprovalForAll}.
927      *
928      * Emits a {Transfer} event.
929      */
930     function transferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public virtual override {
935         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
936 
937         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
938 
939         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
940 
941         // The nested ifs save around 20+ gas over a compound boolean condition.
942         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
943             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
944 
945         if (to == address(0)) revert TransferToZeroAddress();
946 
947         _beforeTokenTransfers(from, to, tokenId, 1);
948 
949         // Clear approvals from the previous owner.
950         assembly {
951             if approvedAddress {
952                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
953                 sstore(approvedAddressSlot, 0)
954             }
955         }
956 
957         // Underflow of the sender's balance is impossible because we check for
958         // ownership above and the recipient's balance can't realistically overflow.
959         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
960         unchecked {
961             // We can directly increment and decrement the balances.
962             --_packedAddressData[from]; // Updates: `balance -= 1`.
963             ++_packedAddressData[to]; // Updates: `balance += 1`.
964 
965             // Updates:
966             // - `address` to the next owner.
967             // - `startTimestamp` to the timestamp of transfering.
968             // - `burned` to `false`.
969             // - `nextInitialized` to `true`.
970             _packedOwnerships[tokenId] = _packOwnershipData(
971                 to,
972                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
973             );
974 
975             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
976             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
977                 uint256 nextTokenId = tokenId + 1;
978                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
979                 if (_packedOwnerships[nextTokenId] == 0) {
980                     // If the next slot is within bounds.
981                     if (nextTokenId != _currentIndex) {
982                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
983                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
984                     }
985                 }
986             }
987         }
988 
989         emit Transfer(from, to, tokenId);
990         _afterTokenTransfers(from, to, tokenId, 1);
991     }
992 
993     /**
994      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) public virtual override {
1001         safeTransferFrom(from, to, tokenId, '');
1002     }
1003 
1004     /**
1005      * @dev Safely transfers `tokenId` token from `from` to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - `from` cannot be the zero address.
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must exist and be owned by `from`.
1012      * - If the caller is not `from`, it must be approved to move this token
1013      * by either {approve} or {setApprovalForAll}.
1014      * - If `to` refers to a smart contract, it must implement
1015      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) public virtual override {
1025         transferFrom(from, to, tokenId);
1026         if (to.code.length != 0)
1027             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1028                 revert TransferToNonERC721ReceiverImplementer();
1029             }
1030     }
1031 
1032     /**
1033      * @dev Hook that is called before a set of serially-ordered token IDs
1034      * are about to be transferred. This includes minting.
1035      * And also called before burning one token.
1036      *
1037      * `startTokenId` - the first token ID to be transferred.
1038      * `quantity` - the amount to be transferred.
1039      *
1040      * Calling conditions:
1041      *
1042      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1043      * transferred to `to`.
1044      * - When `from` is zero, `tokenId` will be minted for `to`.
1045      * - When `to` is zero, `tokenId` will be burned by `from`.
1046      * - `from` and `to` are never both zero.
1047      */
1048     function _beforeTokenTransfers(
1049         address from,
1050         address to,
1051         uint256 startTokenId,
1052         uint256 quantity
1053     ) internal virtual {}
1054 
1055     /**
1056      * @dev Hook that is called after a set of serially-ordered token IDs
1057      * have been transferred. This includes minting.
1058      * And also called after one token has been burned.
1059      *
1060      * `startTokenId` - the first token ID to be transferred.
1061      * `quantity` - the amount to be transferred.
1062      *
1063      * Calling conditions:
1064      *
1065      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1066      * transferred to `to`.
1067      * - When `from` is zero, `tokenId` has been minted for `to`.
1068      * - When `to` is zero, `tokenId` has been burned by `from`.
1069      * - `from` and `to` are never both zero.
1070      */
1071     function _afterTokenTransfers(
1072         address from,
1073         address to,
1074         uint256 startTokenId,
1075         uint256 quantity
1076     ) internal virtual {}
1077 
1078     /**
1079      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1080      *
1081      * `from` - Previous owner of the given token ID.
1082      * `to` - Target address that will receive the token.
1083      * `tokenId` - Token ID to be transferred.
1084      * `_data` - Optional data to send along with the call.
1085      *
1086      * Returns whether the call correctly returned the expected magic value.
1087      */
1088     function _checkContractOnERC721Received(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes memory _data
1093     ) private returns (bool) {
1094         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1095             bytes4 retval
1096         ) {
1097             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1098         } catch (bytes memory reason) {
1099             if (reason.length == 0) {
1100                 revert TransferToNonERC721ReceiverImplementer();
1101             } else {
1102                 assembly {
1103                     revert(add(32, reason), mload(reason))
1104                 }
1105             }
1106         }
1107     }
1108 
1109     // =============================================================
1110     //                        MINT OPERATIONS
1111     // =============================================================
1112 
1113     /**
1114      * @dev Mints `quantity` tokens and transfers them to `to`.
1115      *
1116      * Requirements:
1117      *
1118      * - `to` cannot be the zero address.
1119      * - `quantity` must be greater than 0.
1120      *
1121      * Emits a {Transfer} event for each mint.
1122      */
1123     function _mint(address to, uint256 quantity) internal virtual {
1124         uint256 startTokenId = _currentIndex;
1125         if (quantity == 0) revert MintZeroQuantity();
1126 
1127         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1128 
1129         // Overflows are incredibly unrealistic.
1130         // `balance` and `numberMinted` have a maximum limit of 2**64.
1131         // `tokenId` has a maximum limit of 2**256.
1132         unchecked {
1133             // Updates:
1134             // - `balance += quantity`.
1135             // - `numberMinted += quantity`.
1136             //
1137             // We can directly add to the `balance` and `numberMinted`.
1138             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1139 
1140             // Updates:
1141             // - `address` to the owner.
1142             // - `startTimestamp` to the timestamp of minting.
1143             // - `burned` to `false`.
1144             // - `nextInitialized` to `quantity == 1`.
1145             _packedOwnerships[startTokenId] = _packOwnershipData(
1146                 to,
1147                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1148             );
1149 
1150             uint256 toMasked;
1151             uint256 end = startTokenId + quantity;
1152 
1153             // Use assembly to loop and emit the `Transfer` event for gas savings.
1154             assembly {
1155                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1156                 toMasked := and(to, _BITMASK_ADDRESS)
1157                 // Emit the `Transfer` event.
1158                 log4(
1159                     0, // Start of data (0, since no data).
1160                     0, // End of data (0, since no data).
1161                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1162                     0, // `address(0)`.
1163                     toMasked, // `to`.
1164                     startTokenId // `tokenId`.
1165                 )
1166 
1167                 for {
1168                     let tokenId := add(startTokenId, 1)
1169                 } iszero(eq(tokenId, end)) {
1170                     tokenId := add(tokenId, 1)
1171                 } {
1172                     // Emit the `Transfer` event. Similar to above.
1173                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1174                 }
1175             }
1176             if (toMasked == 0) revert MintToZeroAddress();
1177 
1178             _currentIndex = end;
1179         }
1180         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1181     }
1182 
1183     /**
1184      * @dev Mints `quantity` tokens and transfers them to `to`.
1185      *
1186      * This function is intended for efficient minting only during contract creation.
1187      *
1188      * It emits only one {ConsecutiveTransfer} as defined in
1189      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1190      * instead of a sequence of {Transfer} event(s).
1191      *
1192      * Calling this function outside of contract creation WILL make your contract
1193      * non-compliant with the ERC721 standard.
1194      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1195      * {ConsecutiveTransfer} event is only permissible during contract creation.
1196      *
1197      * Requirements:
1198      *
1199      * - `to` cannot be the zero address.
1200      * - `quantity` must be greater than 0.
1201      *
1202      * Emits a {ConsecutiveTransfer} event.
1203      */
1204     function _mintERC2309(address to, uint256 quantity) internal virtual {
1205         uint256 startTokenId = _currentIndex;
1206         if (to == address(0)) revert MintToZeroAddress();
1207         if (quantity == 0) revert MintZeroQuantity();
1208         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1209 
1210         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1211 
1212         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1213         unchecked {
1214             // Updates:
1215             // - `balance += quantity`.
1216             // - `numberMinted += quantity`.
1217             //
1218             // We can directly add to the `balance` and `numberMinted`.
1219             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1220 
1221             // Updates:
1222             // - `address` to the owner.
1223             // - `startTimestamp` to the timestamp of minting.
1224             // - `burned` to `false`.
1225             // - `nextInitialized` to `quantity == 1`.
1226             _packedOwnerships[startTokenId] = _packOwnershipData(
1227                 to,
1228                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1229             );
1230 
1231             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1232 
1233             _currentIndex = startTokenId + quantity;
1234         }
1235         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1236     }
1237 
1238     /**
1239      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1240      *
1241      * Requirements:
1242      *
1243      * - If `to` refers to a smart contract, it must implement
1244      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1245      * - `quantity` must be greater than 0.
1246      *
1247      * See {_mint}.
1248      *
1249      * Emits a {Transfer} event for each mint.
1250      */
1251     function _safeMint(
1252         address to,
1253         uint256 quantity,
1254         bytes memory _data
1255     ) internal virtual {
1256         _mint(to, quantity);
1257 
1258         unchecked {
1259             if (to.code.length != 0) {
1260                 uint256 end = _currentIndex;
1261                 uint256 index = end - quantity;
1262                 do {
1263                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1264                         revert TransferToNonERC721ReceiverImplementer();
1265                     }
1266                 } while (index < end);
1267                 // Reentrancy protection.
1268                 if (_currentIndex != end) revert();
1269             }
1270         }
1271     }
1272 
1273     /**
1274      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1275      */
1276     function _safeMint(address to, uint256 quantity) internal virtual {
1277         _safeMint(to, quantity, '');
1278     }
1279 
1280     // =============================================================
1281     //                        BURN OPERATIONS
1282     // =============================================================
1283 
1284     /**
1285      * @dev Equivalent to `_burn(tokenId, false)`.
1286      */
1287     function _burn(uint256 tokenId) internal virtual {
1288         _burn(tokenId, false);
1289     }
1290 
1291     /**
1292      * @dev Destroys `tokenId`.
1293      * The approval is cleared when the token is burned.
1294      *
1295      * Requirements:
1296      *
1297      * - `tokenId` must exist.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1302         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1303 
1304         address from = address(uint160(prevOwnershipPacked));
1305 
1306         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1307 
1308         if (approvalCheck) {
1309             // The nested ifs save around 20+ gas over a compound boolean condition.
1310             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1311                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1312         }
1313 
1314         _beforeTokenTransfers(from, address(0), tokenId, 1);
1315 
1316         // Clear approvals from the previous owner.
1317         assembly {
1318             if approvedAddress {
1319                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1320                 sstore(approvedAddressSlot, 0)
1321             }
1322         }
1323 
1324         // Underflow of the sender's balance is impossible because we check for
1325         // ownership above and the recipient's balance can't realistically overflow.
1326         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1327         unchecked {
1328             // Updates:
1329             // - `balance -= 1`.
1330             // - `numberBurned += 1`.
1331             //
1332             // We can directly decrement the balance, and increment the number burned.
1333             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1334             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1335 
1336             // Updates:
1337             // - `address` to the last owner.
1338             // - `startTimestamp` to the timestamp of burning.
1339             // - `burned` to `true`.
1340             // - `nextInitialized` to `true`.
1341             _packedOwnerships[tokenId] = _packOwnershipData(
1342                 from,
1343                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1344             );
1345 
1346             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1347             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1348                 uint256 nextTokenId = tokenId + 1;
1349                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1350                 if (_packedOwnerships[nextTokenId] == 0) {
1351                     // If the next slot is within bounds.
1352                     if (nextTokenId != _currentIndex) {
1353                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1354                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1355                     }
1356                 }
1357             }
1358         }
1359 
1360         emit Transfer(from, address(0), tokenId);
1361         _afterTokenTransfers(from, address(0), tokenId, 1);
1362 
1363         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1364         unchecked {
1365             _burnCounter++;
1366         }
1367     }
1368 
1369     // =============================================================
1370     //                     EXTRA DATA OPERATIONS
1371     // =============================================================
1372 
1373     /**
1374      * @dev Directly sets the extra data for the ownership data `index`.
1375      */
1376     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1377         uint256 packed = _packedOwnerships[index];
1378         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1379         uint256 extraDataCasted;
1380         // Cast `extraData` with assembly to avoid redundant masking.
1381         assembly {
1382             extraDataCasted := extraData
1383         }
1384         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1385         _packedOwnerships[index] = packed;
1386     }
1387 
1388     /**
1389      * @dev Called during each token transfer to set the 24bit `extraData` field.
1390      * Intended to be overridden by the cosumer contract.
1391      *
1392      * `previousExtraData` - the value of `extraData` before transfer.
1393      *
1394      * Calling conditions:
1395      *
1396      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1397      * transferred to `to`.
1398      * - When `from` is zero, `tokenId` will be minted for `to`.
1399      * - When `to` is zero, `tokenId` will be burned by `from`.
1400      * - `from` and `to` are never both zero.
1401      */
1402     function _extraData(
1403         address from,
1404         address to,
1405         uint24 previousExtraData
1406     ) internal view virtual returns (uint24) {}
1407 
1408     /**
1409      * @dev Returns the next extra data for the packed ownership data.
1410      * The returned result is shifted into position.
1411      */
1412     function _nextExtraData(
1413         address from,
1414         address to,
1415         uint256 prevOwnershipPacked
1416     ) private view returns (uint256) {
1417         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1418         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1419     }
1420 
1421     // =============================================================
1422     //                       OTHER OPERATIONS
1423     // =============================================================
1424 
1425     /**
1426      * @dev Returns the message sender (defaults to `msg.sender`).
1427      *
1428      * If you are writing GSN compatible contracts, you need to override this function.
1429      */
1430     function _msgSenderERC721A() internal view virtual returns (address) {
1431         return msg.sender;
1432     }
1433 
1434     /**
1435      * @dev Converts a uint256 to its ASCII string decimal representation.
1436      */
1437     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1438         assembly {
1439             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1440             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1441             // We will need 1 32-byte word to store the length,
1442             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1443             str := add(mload(0x40), 0x80)
1444             // Update the free memory pointer to allocate.
1445             mstore(0x40, str)
1446 
1447             // Cache the end of the memory to calculate the length later.
1448             let end := str
1449 
1450             // We write the string from rightmost digit to leftmost digit.
1451             // The following is essentially a do-while loop that also handles the zero case.
1452             // prettier-ignore
1453             for { let temp := value } 1 {} {
1454                 str := sub(str, 1)
1455                 // Write the character to the pointer.
1456                 // The ASCII index of the '0' character is 48.
1457                 mstore8(str, add(48, mod(temp, 10)))
1458                 // Keep dividing `temp` until zero.
1459                 temp := div(temp, 10)
1460                 // prettier-ignore
1461                 if iszero(temp) { break }
1462             }
1463 
1464             let length := sub(end, str)
1465             // Move the pointer 32 bytes leftwards to make room for the length.
1466             str := sub(str, 0x20)
1467             // Store the length.
1468             mstore(str, length)
1469         }
1470     }
1471 }
1472 
1473 // File: @openzeppelin/contracts/utils/Context.sol
1474 
1475 
1476 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1477 
1478 pragma solidity ^0.8.0;
1479 
1480 /**
1481  * @dev Provides information about the current execution context, including the
1482  * sender of the transaction and its data. While these are generally available
1483  * via msg.sender and msg.data, they should not be accessed in such a direct
1484  * manner, since when dealing with meta-transactions the account sending and
1485  * paying for execution may not be the actual sender (as far as an application
1486  * is concerned).
1487  *
1488  * This contract is only required for intermediate, library-like contracts.
1489  */
1490 abstract contract Context {
1491     function _msgSender() internal view virtual returns (address) {
1492         return msg.sender;
1493     }
1494 
1495     function _msgData() internal view virtual returns (bytes calldata) {
1496         return msg.data;
1497     }
1498 }
1499 
1500 // File: @openzeppelin/contracts/access/Ownable.sol
1501 
1502 
1503 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1504 
1505 pragma solidity ^0.8.0;
1506 
1507 
1508 /**
1509  * @dev Contract module which provides a basic access control mechanism, where
1510  * there is an account (an owner) that can be granted exclusive access to
1511  * specific functions.
1512  *
1513  * By default, the owner account will be the one that deploys the contract. This
1514  * can later be changed with {transferOwnership}.
1515  *
1516  * This module is used through inheritance. It will make available the modifier
1517  * `onlyOwner`, which can be applied to your functions to restrict their use to
1518  * the owner.
1519  */
1520 abstract contract Ownable is Context {
1521     address private _owner;
1522 
1523     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1524 
1525     /**
1526      * @dev Initializes the contract setting the deployer as the initial owner.
1527      */
1528     constructor() {
1529         _transferOwnership(_msgSender());
1530     }
1531 
1532     /**
1533      * @dev Throws if called by any account other than the owner.
1534      */
1535     modifier onlyOwner() {
1536         _checkOwner();
1537         _;
1538     }
1539 
1540     /**
1541      * @dev Returns the address of the current owner.
1542      */
1543     function owner() public view virtual returns (address) {
1544         return _owner;
1545     }
1546 
1547     /**
1548      * @dev Throws if the sender is not the owner.
1549      */
1550     function _checkOwner() internal view virtual {
1551         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1552     }
1553 
1554     /**
1555      * @dev Leaves the contract without owner. It will not be possible to call
1556      * `onlyOwner` functions anymore. Can only be called by the current owner.
1557      *
1558      * NOTE: Renouncing ownership will leave the contract without an owner,
1559      * thereby removing any functionality that is only available to the owner.
1560      */
1561     function renounceOwnership() public virtual onlyOwner {
1562         _transferOwnership(address(0));
1563     }
1564 
1565     /**
1566      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1567      * Can only be called by the current owner.
1568      */
1569     function transferOwnership(address newOwner) public virtual onlyOwner {
1570         require(newOwner != address(0), "Ownable: new owner is the zero address");
1571         _transferOwnership(newOwner);
1572     }
1573 
1574     /**
1575      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1576      * Internal function without access restriction.
1577      */
1578     function _transferOwnership(address newOwner) internal virtual {
1579         address oldOwner = _owner;
1580         _owner = newOwner;
1581         emit OwnershipTransferred(oldOwner, newOwner);
1582     }
1583 }
1584 
1585 // File: contracts/DigiDaigakuMan.sol
1586 
1587 
1588 
1589 
1590 
1591 library Strings {
1592     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1593     uint8 private constant _ADDRESS_LENGTH = 20;
1594 
1595     /**
1596      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1597      */
1598     function toString(uint256 value) internal pure returns (string memory) {
1599         // Inspired by OraclizeAPI's implementation - MIT licence
1600         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1601 
1602         if (value == 0) {
1603             return "0";
1604         }
1605         uint256 temp = value;
1606         uint256 digits;
1607         while (temp != 0) {
1608             digits++;
1609             temp /= 10;
1610         }
1611         bytes memory buffer = new bytes(digits);
1612         while (value != 0) {
1613             digits -= 1;
1614             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1615             value /= 10;
1616         }
1617         return string(buffer);
1618     }
1619 
1620     /**
1621      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1622      */
1623     function toHexString(uint256 value) internal pure returns (string memory) {
1624         if (value == 0) {
1625             return "0x00";
1626         }
1627         uint256 temp = value;
1628         uint256 length = 0;
1629         while (temp != 0) {
1630             length++;
1631             temp >>= 8;
1632         }
1633         return toHexString(value, length);
1634     }
1635 
1636     /**
1637      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1638      */
1639     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1640         bytes memory buffer = new bytes(2 * length + 2);
1641         buffer[0] = "0";
1642         buffer[1] = "x";
1643         for (uint256 i = 2 * length + 1; i > 1; --i) {
1644             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1645             value >>= 4;
1646         }
1647         require(value == 0, "Strings: hex length insufficient");
1648         return string(buffer);
1649     }
1650 
1651     /**
1652      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1653      */
1654     function toHexString(address addr) internal pure returns (string memory) {
1655         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1656     }
1657 }
1658 library Address {
1659     /**
1660      * @dev Returns true if `account` is a contract.
1661      *
1662      * [IMPORTANT]
1663      * ====
1664      * It is unsafe to assume that an address for which this function returns
1665      * false is an externally-owned account (EOA) and not a contract.
1666      *
1667      * Among others, `isContract` will return false for the following
1668      * types of addresses:
1669      *
1670      *  - an externally-owned account
1671      *  - a contract in construction
1672      *  - an address where a contract will be created
1673      *  - an address where a contract lived, but was destroyed
1674      * ====
1675      *
1676      * [IMPORTANT]
1677      * ====
1678      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1679      *
1680      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1681      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1682      * constructor.
1683      * ====
1684      */
1685     function isContract(address account) internal view returns (bool) {
1686         // This method relies on extcodesize/address.code.length, which returns 0
1687         // for contracts in construction, since the code is only stored at the end
1688         // of the constructor execution.
1689 
1690         return account.code.length > 0;
1691     }
1692 
1693     /**
1694      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1695      * `recipient`, forwarding all available gas and reverting on errors.
1696      *
1697      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1698      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1699      * imposed by `transfer`, making them unable to receive funds via
1700      * `transfer`. {sendValue} removes this limitation.
1701      *
1702      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1703      *
1704      * IMPORTANT: because control is transferred to `recipient`, care must be
1705      * taken to not create reentrancy vulnerabilities. Consider using
1706      * {ReentrancyGuard} or the
1707      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1708      */
1709     function sendValue(address payable recipient, uint256 amount) internal {
1710         require(address(this).balance >= amount, "Address: insufficient balance");
1711 
1712         (bool success, ) = recipient.call{value: amount}("");
1713         require(success, "Address: unable to send value, recipient may have reverted");
1714     }
1715 
1716     /**
1717      * @dev Performs a Solidity function call using a low level `call`. A
1718      * plain `call` is an unsafe replacement for a function call: use this
1719      * function instead.
1720      *
1721      * If `target` reverts with a revert reason, it is bubbled up by this
1722      * function (like regular Solidity function calls).
1723      *
1724      * Returns the raw returned data. To convert to the expected return value,
1725      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1726      *
1727      * Requirements:
1728      *
1729      * - `target` must be a contract.
1730      * - calling `target` with `data` must not revert.
1731      *
1732      * _Available since v3.1._
1733      */
1734     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1735         return functionCall(target, data, "Address: low-level call failed");
1736     }
1737 
1738     /**
1739      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1740      * `errorMessage` as a fallback revert reason when `target` reverts.
1741      *
1742      * _Available since v3.1._
1743      */
1744     function functionCall(
1745         address target,
1746         bytes memory data,
1747         string memory errorMessage
1748     ) internal returns (bytes memory) {
1749         return functionCallWithValue(target, data, 0, errorMessage);
1750     }
1751 
1752     /**
1753      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1754      * but also transferring `value` wei to `target`.
1755      *
1756      * Requirements:
1757      *
1758      * - the calling contract must have an ETH balance of at least `value`.
1759      * - the called Solidity function must be `payable`.
1760      *
1761      * _Available since v3.1._
1762      */
1763     function functionCallWithValue(
1764         address target,
1765         bytes memory data,
1766         uint256 value
1767     ) internal returns (bytes memory) {
1768         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1769     }
1770 
1771     /**
1772      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1773      * with `errorMessage` as a fallback revert reason when `target` reverts.
1774      *
1775      * _Available since v3.1._
1776      */
1777     function functionCallWithValue(
1778         address target,
1779         bytes memory data,
1780         uint256 value,
1781         string memory errorMessage
1782     ) internal returns (bytes memory) {
1783         require(address(this).balance >= value, "Address: insufficient balance for call");
1784         require(isContract(target), "Address: call to non-contract");
1785 
1786         (bool success, bytes memory returndata) = target.call{value: value}(data);
1787         return verifyCallResult(success, returndata, errorMessage);
1788     }
1789 
1790     /**
1791      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1792      * but performing a static call.
1793      *
1794      * _Available since v3.3._
1795      */
1796     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1797         return functionStaticCall(target, data, "Address: low-level static call failed");
1798     }
1799 
1800     /**
1801      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1802      * but performing a static call.
1803      *
1804      * _Available since v3.3._
1805      */
1806     function functionStaticCall(
1807         address target,
1808         bytes memory data,
1809         string memory errorMessage
1810     ) internal view returns (bytes memory) {
1811         require(isContract(target), "Address: static call to non-contract");
1812 
1813         (bool success, bytes memory returndata) = target.staticcall(data);
1814         return verifyCallResult(success, returndata, errorMessage);
1815     }
1816 
1817     /**
1818      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1819      * but performing a delegate call.
1820      *
1821      * _Available since v3.4._
1822      */
1823     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1824         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1825     }
1826 
1827     /**
1828      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1829      * but performing a delegate call.
1830      *
1831      * _Available since v3.4._
1832      */
1833     function functionDelegateCall(
1834         address target,
1835         bytes memory data,
1836         string memory errorMessage
1837     ) internal returns (bytes memory) {
1838         require(isContract(target), "Address: delegate call to non-contract");
1839 
1840         (bool success, bytes memory returndata) = target.delegatecall(data);
1841         return verifyCallResult(success, returndata, errorMessage);
1842     }
1843 
1844     /**
1845      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1846      * revert reason using the provided one.
1847      *
1848      * _Available since v4.3._
1849      */
1850     function verifyCallResult(
1851         bool success,
1852         bytes memory returndata,
1853         string memory errorMessage
1854     ) internal pure returns (bytes memory) {
1855         if (success) {
1856             return returndata;
1857         } else {
1858             // Look for revert reason and bubble it up if present
1859             if (returndata.length > 0) {
1860                 // The easiest way to bubble the revert reason is using memory via assembly
1861                 /// @solidity memory-safe-assembly
1862                 assembly {
1863                     let returndata_size := mload(returndata)
1864                     revert(add(32, returndata), returndata_size)
1865                 }
1866             } else {
1867                 revert(errorMessage);
1868             }
1869         }
1870     }
1871 }
1872 pragma solidity ^0.8.13;
1873 
1874 interface IOperatorFilterRegistry {
1875     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1876     function register(address registrant) external;
1877     function registerAndSubscribe(address registrant, address subscription) external;
1878     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1879     function updateOperator(address registrant, address operator, bool filtered) external;
1880     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1881     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1882     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1883     function subscribe(address registrant, address registrantToSubscribe) external;
1884     function unsubscribe(address registrant, bool copyExistingEntries) external;
1885     function subscriptionOf(address addr) external returns (address registrant);
1886     function subscribers(address registrant) external returns (address[] memory);
1887     function subscriberAt(address registrant, uint256 index) external returns (address);
1888     function copyEntriesOf(address registrant, address registrantToCopy) external;
1889     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1890     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1891     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1892     function filteredOperators(address addr) external returns (address[] memory);
1893     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1894     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1895     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1896     function isRegistered(address addr) external returns (bool);
1897     function codeHashOf(address addr) external returns (bytes32);
1898 }
1899 pragma solidity ^0.8.13;
1900 
1901 abstract contract OperatorFilterer {
1902     error OperatorNotAllowed(address operator);
1903 
1904     IOperatorFilterRegistry constant operatorFilterRegistry =
1905         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1906 
1907     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1908         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1909         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1910         // order for the modifier to filter addresses.
1911         if (address(operatorFilterRegistry).code.length > 0) {
1912             if (subscribe) {
1913                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1914             } else {
1915                 if (subscriptionOrRegistrantToCopy != address(0)) {
1916                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1917                 } else {
1918                     operatorFilterRegistry.register(address(this));
1919                 }
1920             }
1921         }
1922     }
1923 
1924     modifier onlyAllowedOperator(address from) virtual {
1925         // Check registry code length to facilitate testing in environments without a deployed registry.
1926         if (address(operatorFilterRegistry).code.length > 0) {
1927             // Allow spending tokens from addresses with balance
1928             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1929             // from an EOA.
1930             if (from == msg.sender) {
1931                 _;
1932                 return;
1933             }
1934             if (
1935                 !(
1936                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1937                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1938                 )
1939             ) {
1940                 revert OperatorNotAllowed(msg.sender);
1941             }
1942         }
1943         _;
1944     }
1945 }
1946 
1947 
1948 pragma solidity ^0.8.13;
1949 
1950 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1951     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1952 
1953     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1954 }
1955 
1956 
1957 
1958 
1959 pragma solidity >=0.8.9 <0.9.0;
1960 
1961 contract GriefWojakYachtClub is ERC721A, DefaultOperatorFilterer, Ownable, ReentrancyGuard {
1962     using Address for address;
1963     using Strings for uint;
1964     
1965     string  public baseTokenURI = "ipfs://bafybeibd6acnuc56peyqcyqstclsezqfep2afknbcahgzgztxfu5bniite/";
1966     uint256 public MAX_WOJAK = 10000;
1967     uint256 public MAX_FREE_SUPPLY = 10000;
1968     uint256 public MAX_PER_TX = 25;
1969     uint256 public PRICE = 0.0035 ether;
1970     uint256 public MAX_FREE_PER_WALLET = 1;
1971     bool public status = false;
1972 
1973     mapping(address => uint256) public alreadyFreeMinted;
1974 
1975     constructor() ERC721A("GriefWojakYachtClub", "GWYC") {}
1976 
1977     function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1978         require(totalSupply() + _mintAmount <= MAX_WOJAK, "Max supply exceeded!");
1979         _safeMint(_receiver, _mintAmount);
1980     }
1981 
1982 
1983     function mint(uint256 amount) external payable
1984     {
1985 		require(amount <= MAX_PER_TX,"Maximum of 25 Wojaks per txn!");
1986 		require(_totalMinted() + amount <= MAX_WOJAK,"No Wojak lefts!");
1987         require(status, "Wojak has not yet begun to grieve.");
1988         uint payForCount = amount;
1989         uint minted = alreadyFreeMinted[msg.sender];
1990         if(minted < MAX_FREE_PER_WALLET && _totalMinted() < MAX_FREE_SUPPLY) {
1991             uint remainingFreeMints = MAX_FREE_PER_WALLET - minted;
1992             if(amount > remainingFreeMints) {
1993                 payForCount = amount - remainingFreeMints;
1994             }
1995             else {
1996                 payForCount = 0;
1997             }
1998         }
1999 		require(
2000 			msg.value >= payForCount * PRICE,
2001 			'Ether value sent is not sufficient'
2002 		);
2003     	alreadyFreeMinted[msg.sender] += amount;
2004 
2005         _safeMint(msg.sender, amount);
2006     }
2007 
2008     function numberMinted(address owner) public view returns (uint256) {
2009         return _numberMinted(owner);
2010     }
2011     
2012     function setBaseURI(string memory baseURI) public onlyOwner
2013     {
2014         baseTokenURI = baseURI;
2015     }
2016 
2017     function _startTokenId() internal view virtual override returns (uint256) {
2018         return 1;
2019     }
2020 
2021     function withdraw() public onlyOwner nonReentrant {
2022         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2023         require(os);
2024     }
2025 
2026     function tokenURI(uint tokenId)
2027 		public
2028 		view
2029 		override
2030 		returns (string memory)
2031 	{
2032         require(_exists(tokenId), "ERC721Metadata");
2033 
2034         return bytes(_baseURI()).length > 0 
2035             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
2036             : baseTokenURI;
2037 	}
2038 
2039     function _baseURI() internal view virtual override returns (string memory)
2040     {
2041         return baseTokenURI;
2042     }
2043 
2044 
2045     function setStatus(bool _status) external onlyOwner
2046     {
2047         status = _status;
2048     }
2049 
2050     function setPrice(uint256 _price) external onlyOwner
2051     {
2052         PRICE = _price;
2053     }
2054 
2055     function setMaxLimitPerTransaction(uint256 _limit) external onlyOwner
2056     {
2057         MAX_PER_TX = _limit;
2058     }
2059 
2060     function setLimitFreeMintPerWallet(uint256 _limit) external onlyOwner
2061     {
2062         MAX_FREE_PER_WALLET = _limit;
2063     }
2064 
2065     function setMaxFreeAmount(uint256 _amount) external onlyOwner
2066     {
2067         MAX_FREE_SUPPLY = _amount;
2068     }
2069 
2070     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2071         super.transferFrom(from, to, tokenId);
2072     }
2073 
2074     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2075         super.safeTransferFrom(from, to, tokenId);
2076     }
2077 
2078     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2079         public
2080         override
2081         onlyAllowedOperator(from)
2082     {
2083         super.safeTransferFrom(from, to, tokenId, data);
2084     }
2085 
2086 }