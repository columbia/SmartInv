1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.4;
3 
4 
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 /**
34  * @title  OperatorFilterer
35  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
36  *         registrant's entries in the OperatorFilterRegistry.
37  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
38  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
39  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
40  */
41 abstract contract OperatorFilterer {
42     error OperatorNotAllowed(address operator);
43 
44     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
45         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
46 
47     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
48         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
49         // will not revert, but the contract will need to be registered with the registry once it is deployed in
50         // order for the modifier to filter addresses.
51         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
52             if (subscribe) {
53                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
54             } else {
55                 if (subscriptionOrRegistrantToCopy != address(0)) {
56                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
57                 } else {
58                     OPERATOR_FILTER_REGISTRY.register(address(this));
59                 }
60             }
61         }
62     }
63 
64     modifier onlyAllowedOperator(address from) virtual {
65         // Allow spending tokens from addresses with balance
66         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
67         // from an EOA.
68         if (from != msg.sender) {
69             _checkFilterOperator(msg.sender);
70         }
71         _;
72     }
73 
74     modifier onlyAllowedOperatorApproval(address operator) virtual {
75         _checkFilterOperator(operator);
76         _;
77     }
78 
79     function _checkFilterOperator(address operator) internal view virtual {
80         // Check registry code length to facilitate testing in environments without a deployed registry.
81         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
82             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
83                 revert OperatorNotAllowed(operator);
84             }
85         }
86     }
87 }
88 /**
89  * @title  DefaultOperatorFilterer
90  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
91  */
92 abstract contract DefaultOperatorFilterer is OperatorFilterer {
93     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
94 
95     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
96 }
97 
98 /**
99  * @dev Interface of ERC721A.
100  */
101 interface IERC721A {
102     /**
103      * The caller must own the token or be an approved operator.
104      */
105     error ApprovalCallerNotOwnerNorApproved();
106 
107     /**
108      * The token does not exist.
109      */
110     error ApprovalQueryForNonexistentToken();
111 
112     /**
113      * Cannot query the balance for the zero address.
114      */
115     error BalanceQueryForZeroAddress();
116 
117     /**
118      * Cannot mint to the zero address.
119      */
120     error MintToZeroAddress();
121 
122     /**
123      * The quantity of tokens minted must be more than zero.
124      */
125     error MintZeroQuantity();
126 
127     /**
128      * The token does not exist.
129      */
130     error OwnerQueryForNonexistentToken();
131 
132     /**
133      * The caller must own the token or be an approved operator.
134      */
135     error TransferCallerNotOwnerNorApproved();
136 
137     /**
138      * The token must be owned by `from`.
139      */
140     error TransferFromIncorrectOwner();
141 
142     /**
143      * Cannot safely transfer to a contract that does not implement the
144      * ERC721Receiver interface.
145      */
146     error TransferToNonERC721ReceiverImplementer();
147 
148     /**
149      * Cannot transfer to the zero address.
150      */
151     error TransferToZeroAddress();
152 
153     /**
154      * The token does not exist.
155      */
156     error URIQueryForNonexistentToken();
157 
158     /**
159      * The `quantity` minted with ERC2309 exceeds the safety limit.
160      */
161     error MintERC2309QuantityExceedsLimit();
162 
163     /**
164      * The `extraData` cannot be set on an unintialized ownership slot.
165      */
166     error OwnershipNotInitializedForExtraData();
167 
168     // =============================================================
169     //                            STRUCTS
170     // =============================================================
171 
172     struct TokenOwnership {
173         // The address of the owner.
174         address addr;
175         // Stores the start time of ownership with minimal overhead for tokenomics.
176         uint64 startTimestamp;
177         // Whether the token has been burned.
178         bool burned;
179         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
180         uint24 extraData;
181     }
182 
183     // =============================================================
184     //                         TOKEN COUNTERS
185     // =============================================================
186 
187     /**
188      * @dev Returns the total number of tokens in existence.
189      * Burned tokens will reduce the count.
190      * To get the total number of tokens minted, please see {_totalMinted}.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     // =============================================================
195     //                            IERC165
196     // =============================================================
197 
198     /**
199      * @dev Returns true if this contract implements the interface defined by
200      * `interfaceId`. See the corresponding
201      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
202      * to learn more about how these ids are created.
203      *
204      * This function call must use less than 30000 gas.
205      */
206     function supportsInterface(bytes4 interfaceId) external view returns (bool);
207 
208     // =============================================================
209     //                            IERC721
210     // =============================================================
211 
212     /**
213      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
214      */
215     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
216 
217     /**
218      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
219      */
220     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
221 
222     /**
223      * @dev Emitted when `owner` enables or disables
224      * (`approved`) `operator` to manage all of its assets.
225      */
226     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
227 
228     /**
229      * @dev Returns the number of tokens in `owner`'s account.
230      */
231     function balanceOf(address owner) external view returns (uint256 balance);
232 
233     /**
234      * @dev Returns the owner of the `tokenId` token.
235      *
236      * Requirements:
237      *
238      * - `tokenId` must exist.
239      */
240     function ownerOf(uint256 tokenId) external view returns (address owner);
241 
242     /**
243      * @dev Safely transfers `tokenId` token from `from` to `to`,
244      * checking first that contract recipients are aware of the ERC721 protocol
245      * to prevent tokens from being forever locked.
246      *
247      * Requirements:
248      *
249      * - `from` cannot be the zero address.
250      * - `to` cannot be the zero address.
251      * - `tokenId` token must exist and be owned by `from`.
252      * - If the caller is not `from`, it must be have been allowed to move
253      * this token by either {approve} or {setApprovalForAll}.
254      * - If `to` refers to a smart contract, it must implement
255      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
256      *
257      * Emits a {Transfer} event.
258      */
259     function safeTransferFrom(
260         address from,
261         address to,
262         uint256 tokenId,
263         bytes calldata data
264     ) external payable;
265 
266     /**
267      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
268      */
269     function safeTransferFrom(
270         address from,
271         address to,
272         uint256 tokenId
273     ) external payable;
274 
275     /**
276      * @dev Transfers `tokenId` from `from` to `to`.
277      *
278      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
279      * whenever possible.
280      *
281      * Requirements:
282      *
283      * - `from` cannot be the zero address.
284      * - `to` cannot be the zero address.
285      * - `tokenId` token must be owned by `from`.
286      * - If the caller is not `from`, it must be approved to move this token
287      * by either {approve} or {setApprovalForAll}.
288      *
289      * Emits a {Transfer} event.
290      */
291     function transferFrom(
292         address from,
293         address to,
294         uint256 tokenId
295     ) external payable;
296 
297     /**
298      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
299      * The approval is cleared when the token is transferred.
300      *
301      * Only a single account can be approved at a time, so approving the
302      * zero address clears previous approvals.
303      *
304      * Requirements:
305      *
306      * - The caller must own the token or be an approved operator.
307      * - `tokenId` must exist.
308      *
309      * Emits an {Approval} event.
310      */
311     function approve(address to, uint256 tokenId) external payable;
312 
313     /**
314      * @dev Approve or remove `operator` as an operator for the caller.
315      * Operators can call {transferFrom} or {safeTransferFrom}
316      * for any token owned by the caller.
317      *
318      * Requirements:
319      *
320      * - The `operator` cannot be the caller.
321      *
322      * Emits an {ApprovalForAll} event.
323      */
324     function setApprovalForAll(address operator, bool _approved) external;
325 
326     /**
327      * @dev Returns the account approved for `tokenId` token.
328      *
329      * Requirements:
330      *
331      * - `tokenId` must exist.
332      */
333     function getApproved(uint256 tokenId) external view returns (address operator);
334 
335     /**
336      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
337      *
338      * See {setApprovalForAll}.
339      */
340     function isApprovedForAll(address owner, address operator) external view returns (bool);
341 
342     // =============================================================
343     //                        IERC721Metadata
344     // =============================================================
345 
346     /**
347      * @dev Returns the token collection name.
348      */
349     function name() external view returns (string memory);
350 
351     /**
352      * @dev Returns the token collection symbol.
353      */
354     function symbol() external view returns (string memory);
355 
356     /**
357      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
358      */
359     function tokenURI(uint256 tokenId) external view returns (string memory);
360 
361     // =============================================================
362     //                           IERC2309
363     // =============================================================
364 
365     /**
366      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
367      * (inclusive) is transferred from `from` to `to`, as defined in the
368      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
369      *
370      * See {_mintERC2309} for more details.
371      */
372     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
373 }
374 
375 /**
376  * @dev Interface of ERC721 token receiver.
377  */
378 interface ERC721A__IERC721Receiver {
379     function onERC721Received(
380         address operator,
381         address from,
382         uint256 tokenId,
383         bytes calldata data
384     ) external returns (bytes4);
385 }
386 
387 /**
388  * @title ERC721A
389  *
390  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
391  * Non-Fungible Token Standard, including the Metadata extension.
392  * Optimized for lower gas during batch mints.
393  *
394  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
395  * starting from `_startTokenId()`.
396  *
397  * Assumptions:
398  *
399  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
400  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
401  */
402 contract ERC721A is IERC721A {
403     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
404     struct TokenApprovalRef {
405         address value;
406     }
407 
408     // =============================================================
409     //                           CONSTANTS
410     // =============================================================
411 
412     // Mask of an entry in packed address data.
413     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
414 
415     // The bit position of `numberMinted` in packed address data.
416     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
417 
418     // The bit position of `numberBurned` in packed address data.
419     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
420 
421     // The bit position of `aux` in packed address data.
422     uint256 private constant _BITPOS_AUX = 192;
423 
424     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
425     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
426 
427     // The bit position of `startTimestamp` in packed ownership.
428     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
429 
430     // The bit mask of the `burned` bit in packed ownership.
431     uint256 private constant _BITMASK_BURNED = 1 << 224;
432 
433     // The bit position of the `nextInitialized` bit in packed ownership.
434     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
435 
436     // The bit mask of the `nextInitialized` bit in packed ownership.
437     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
438 
439     // The bit position of `extraData` in packed ownership.
440     uint256 private constant _BITPOS_EXTRA_DATA = 232;
441 
442     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
443     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
444 
445     // The mask of the lower 160 bits for addresses.
446     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
447 
448     // The maximum `quantity` that can be minted with {_mintERC2309}.
449     // This limit is to prevent overflows on the address data entries.
450     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
451     // is required to cause an overflow, which is unrealistic.
452     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
453 
454     // The `Transfer` event signature is given by:
455     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
456     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
457         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
458 
459     // =============================================================
460     //                            STORAGE
461     // =============================================================
462 
463     // The next token ID to be minted.
464     uint256 private _currentIndex;
465 
466     // The number of tokens burned.
467     uint256 private _burnCounter;
468 
469     // Token name
470     string private _name;
471 
472     // Token symbol
473     string private _symbol;
474 
475     // Mapping from token ID to ownership details
476     // An empty struct value does not necessarily mean the token is unowned.
477     // See {_packedOwnershipOf} implementation for details.
478     //
479     // Bits Layout:
480     // - [0..159]   `addr`
481     // - [160..223] `startTimestamp`
482     // - [224]      `burned`
483     // - [225]      `nextInitialized`
484     // - [232..255] `extraData`
485     mapping(uint256 => uint256) private _packedOwnerships;
486 
487     // Mapping owner address to address data.
488     //
489     // Bits Layout:
490     // - [0..63]    `balance`
491     // - [64..127]  `numberMinted`
492     // - [128..191] `numberBurned`
493     // - [192..255] `aux`
494     mapping(address => uint256) private _packedAddressData;
495 
496     // Mapping from token ID to approved address.
497     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
498 
499     // Mapping from owner to operator approvals
500     mapping(address => mapping(address => bool)) private _operatorApprovals;
501 
502     // =============================================================
503     //                          CONSTRUCTOR
504     // =============================================================
505 
506     constructor(string memory name_, string memory symbol_) {
507         _name = name_;
508         _symbol = symbol_;
509         _currentIndex = _startTokenId();
510     }
511 
512     // =============================================================
513     //                   TOKEN COUNTING OPERATIONS
514     // =============================================================
515 
516     /**
517      * @dev Returns the starting token ID.
518      * To change the starting token ID, please override this function.
519      */
520     function _startTokenId() internal view virtual returns (uint256) {
521         return 1;
522     }
523 
524     /**
525      * @dev Returns the next token ID to be minted.
526      */
527     function _nextTokenId() internal view virtual returns (uint256) {
528         return _currentIndex;
529     }
530 
531     /**
532      * @dev Returns the total number of tokens in existence.
533      * Burned tokens will reduce the count.
534      * To get the total number of tokens minted, please see {_totalMinted}.
535      */
536     function totalSupply() public view virtual override returns (uint256) {
537         // Counter underflow is impossible as _burnCounter cannot be incremented
538         // more than `_currentIndex - _startTokenId()` times.
539         unchecked {
540             return _currentIndex - _burnCounter - _startTokenId();
541         }
542     }
543 
544     /**
545      * @dev Returns the total amount of tokens minted in the contract.
546      */
547     function _totalMinted() internal view virtual returns (uint256) {
548         // Counter underflow is impossible as `_currentIndex` does not decrement,
549         // and it is initialized to `_startTokenId()`.
550         unchecked {
551             return _currentIndex - _startTokenId();
552         }
553     }
554 
555     /**
556      * @dev Returns the total number of tokens burned.
557      */
558     function _totalBurned() internal view virtual returns (uint256) {
559         return _burnCounter;
560     }
561 
562     // =============================================================
563     //                    ADDRESS DATA OPERATIONS
564     // =============================================================
565 
566     /**
567      * @dev Returns the number of tokens in `owner`'s account.
568      */
569     function balanceOf(address owner) public view virtual override returns (uint256) {
570         if (owner == address(0)) revert BalanceQueryForZeroAddress();
571         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
572     }
573 
574     /**
575      * Returns the number of tokens minted by `owner`.
576      */
577     function _numberMinted(address owner) internal view returns (uint256) {
578         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
579     }
580 
581     /**
582      * Returns the number of tokens burned by or on behalf of `owner`.
583      */
584     function _numberBurned(address owner) internal view returns (uint256) {
585         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
586     }
587 
588     /**
589      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
590      */
591     function _getAux(address owner) internal view returns (uint64) {
592         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
593     }
594 
595     /**
596      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
597      * If there are multiple variables, please pack them into a uint64.
598      */
599     function _setAux(address owner, uint64 aux) internal virtual {
600         uint256 packed = _packedAddressData[owner];
601         uint256 auxCasted;
602         // Cast `aux` with assembly to avoid redundant masking.
603         assembly {
604             auxCasted := aux
605         }
606         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
607         _packedAddressData[owner] = packed;
608     }
609 
610     // =============================================================
611     //                            IERC165
612     // =============================================================
613 
614     /**
615      * @dev Returns true if this contract implements the interface defined by
616      * `interfaceId`. See the corresponding
617      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
618      * to learn more about how these ids are created.
619      *
620      * This function call must use less than 30000 gas.
621      */
622     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
623         // The interface IDs are constants representing the first 4 bytes
624         // of the XOR of all function selectors in the interface.
625         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
626         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
627         return
628             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
629             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
630             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
631     }
632 
633     // =============================================================
634     //                        IERC721Metadata
635     // =============================================================
636 
637     /**
638      * @dev Returns the token collection name.
639      */
640     function name() public view virtual override returns (string memory) {
641         return _name;
642     }
643 
644     /**
645      * @dev Returns the token collection symbol.
646      */
647     function symbol() public view virtual override returns (string memory) {
648         return _symbol;
649     }
650 
651     /**
652      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
653      */
654     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
655         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
656 
657         string memory baseURI = _baseURI();
658         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
659     }
660 
661     /**
662      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
663      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
664      * by default, it can be overridden in child contracts.
665      */
666     function _baseURI() internal view virtual returns (string memory) {
667         return '';
668     }
669 
670     // =============================================================
671     //                     OWNERSHIPS OPERATIONS
672     // =============================================================
673 
674     /**
675      * @dev Returns the owner of the `tokenId` token.
676      *
677      * Requirements:
678      *
679      * - `tokenId` must exist.
680      */
681     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
682         return address(uint160(_packedOwnershipOf(tokenId)));
683     }
684 
685     /**
686      * @dev Gas spent here starts off proportional to the maximum mint batch size.
687      * It gradually moves to O(1) as tokens get transferred around over time.
688      */
689     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
690         return _unpackedOwnership(_packedOwnershipOf(tokenId));
691     }
692 
693     /**
694      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
695      */
696     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
697         return _unpackedOwnership(_packedOwnerships[index]);
698     }
699 
700     /**
701      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
702      */
703     function _initializeOwnershipAt(uint256 index) internal virtual {
704         if (_packedOwnerships[index] == 0) {
705             _packedOwnerships[index] = _packedOwnershipOf(index);
706         }
707     }
708 
709     /**
710      * Returns the packed ownership data of `tokenId`.
711      */
712     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
713         uint256 curr = tokenId;
714 
715         unchecked {
716             if (_startTokenId() <= curr)
717                 if (curr < _currentIndex) {
718                     uint256 packed = _packedOwnerships[curr];
719                     // If not burned.
720                     if (packed & _BITMASK_BURNED == 0) {
721                         // Invariant:
722                         // There will always be an initialized ownership slot
723                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
724                         // before an unintialized ownership slot
725                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
726                         // Hence, `curr` will not underflow.
727                         //
728                         // We can directly compare the packed value.
729                         // If the address is zero, packed will be zero.
730                         while (packed == 0) {
731                             packed = _packedOwnerships[--curr];
732                         }
733                         return packed;
734                     }
735                 }
736         }
737         revert OwnerQueryForNonexistentToken();
738     }
739 
740     /**
741      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
742      */
743     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
744         ownership.addr = address(uint160(packed));
745         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
746         ownership.burned = packed & _BITMASK_BURNED != 0;
747         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
748     }
749 
750     /**
751      * @dev Packs ownership data into a single uint256.
752      */
753     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
754         assembly {
755             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
756             owner := and(owner, _BITMASK_ADDRESS)
757             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
758             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
759         }
760     }
761 
762     /**
763      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
764      */
765     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
766         // For branchless setting of the `nextInitialized` flag.
767         assembly {
768             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
769             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
770         }
771     }
772 
773     // =============================================================
774     //                      APPROVAL OPERATIONS
775     // =============================================================
776 
777     /**
778      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
779      * The approval is cleared when the token is transferred.
780      *
781      * Only a single account can be approved at a time, so approving the
782      * zero address clears previous approvals.
783      *
784      * Requirements:
785      *
786      * - The caller must own the token or be an approved operator.
787      * - `tokenId` must exist.
788      *
789      * Emits an {Approval} event.
790      */
791     function approve(address to, uint256 tokenId) public payable virtual override {
792         address owner = ownerOf(tokenId);
793 
794         if (_msgSenderERC721A() != owner)
795             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
796                 revert ApprovalCallerNotOwnerNorApproved();
797             }
798 
799         _tokenApprovals[tokenId].value = to;
800         emit Approval(owner, to, tokenId);
801     }
802 
803     /**
804      * @dev Returns the account approved for `tokenId` token.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must exist.
809      */
810     function getApproved(uint256 tokenId) public view virtual override returns (address) {
811         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
812 
813         return _tokenApprovals[tokenId].value;
814     }
815 
816     /**
817      * @dev Approve or remove `operator` as an operator for the caller.
818      * Operators can call {transferFrom} or {safeTransferFrom}
819      * for any token owned by the caller.
820      *
821      * Requirements:
822      *
823      * - The `operator` cannot be the caller.
824      *
825      * Emits an {ApprovalForAll} event.
826      */
827     function setApprovalForAll(address operator, bool approved) public virtual override {
828         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
829         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
830     }
831 
832     /**
833      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
834      *
835      * See {setApprovalForAll}.
836      */
837     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
838         return _operatorApprovals[owner][operator];
839     }
840 
841     /**
842      * @dev Returns whether `tokenId` exists.
843      *
844      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
845      *
846      * Tokens start existing when they are minted. See {_mint}.
847      */
848     function _exists(uint256 tokenId) internal view virtual returns (bool) {
849         return
850             _startTokenId() <= tokenId &&
851             tokenId < _currentIndex && // If within bounds,
852             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
853     }
854 
855     /**
856      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
857      */
858     function _isSenderApprovedOrOwner(
859         address approvedAddress,
860         address owner,
861         address msgSender
862     ) private pure returns (bool result) {
863         assembly {
864             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
865             owner := and(owner, _BITMASK_ADDRESS)
866             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
867             msgSender := and(msgSender, _BITMASK_ADDRESS)
868             // `msgSender == owner || msgSender == approvedAddress`.
869             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
870         }
871     }
872 
873     /**
874      * @dev Returns the storage slot and value for the approved address of `tokenId`.
875      */
876     function _getApprovedSlotAndAddress(uint256 tokenId)
877         private
878         view
879         returns (uint256 approvedAddressSlot, address approvedAddress)
880     {
881         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
882         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
883         assembly {
884             approvedAddressSlot := tokenApproval.slot
885             approvedAddress := sload(approvedAddressSlot)
886         }
887     }
888 
889     // =============================================================
890     //                      TRANSFER OPERATIONS
891     // =============================================================
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
895      *
896      * Requirements:
897      *
898      * - `from` cannot be the zero address.
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      * - If the caller is not `from`, it must be approved to move this token
902      * by either {approve} or {setApprovalForAll}.
903      *
904      * Emits a {Transfer} event.
905      */
906     function transferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public payable virtual override {
911         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
912 
913         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
914 
915         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
916 
917         // The nested ifs save around 20+ gas over a compound boolean condition.
918         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
919             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
920 
921         if (to == address(0)) revert TransferToZeroAddress();
922 
923         _beforeTokenTransfers(from, to, tokenId, 1);
924 
925         // Clear approvals from the previous owner.
926         assembly {
927             if approvedAddress {
928                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
929                 sstore(approvedAddressSlot, 0)
930             }
931         }
932 
933         // Underflow of the sender's balance is impossible because we check for
934         // ownership above and the recipient's balance can't realistically overflow.
935         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
936         unchecked {
937             // We can directly increment and decrement the balances.
938             --_packedAddressData[from]; // Updates: `balance -= 1`.
939             ++_packedAddressData[to]; // Updates: `balance += 1`.
940 
941             // Updates:
942             // - `address` to the next owner.
943             // - `startTimestamp` to the timestamp of transfering.
944             // - `burned` to `false`.
945             // - `nextInitialized` to `true`.
946             _packedOwnerships[tokenId] = _packOwnershipData(
947                 to,
948                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
949             );
950 
951             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
952             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
953                 uint256 nextTokenId = tokenId + 1;
954                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
955                 if (_packedOwnerships[nextTokenId] == 0) {
956                     // If the next slot is within bounds.
957                     if (nextTokenId != _currentIndex) {
958                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
959                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
960                     }
961                 }
962             }
963         }
964 
965         emit Transfer(from, to, tokenId);
966         _afterTokenTransfers(from, to, tokenId, 1);
967     }
968 
969     /**
970      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public payable virtual override {
977         safeTransferFrom(from, to, tokenId, '');
978     }
979 
980     /**
981      * @dev Safely transfers `tokenId` token from `from` to `to`.
982      *
983      * Requirements:
984      *
985      * - `from` cannot be the zero address.
986      * - `to` cannot be the zero address.
987      * - `tokenId` token must exist and be owned by `from`.
988      * - If the caller is not `from`, it must be approved to move this token
989      * by either {approve} or {setApprovalForAll}.
990      * - If `to` refers to a smart contract, it must implement
991      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
992      *
993      * Emits a {Transfer} event.
994      */
995     function safeTransferFrom(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) public payable virtual override {
1001         transferFrom(from, to, tokenId);
1002         if (to.code.length != 0)
1003             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1004                 revert TransferToNonERC721ReceiverImplementer();
1005             }
1006     }
1007 
1008     /**
1009      * @dev Hook that is called before a set of serially-ordered token IDs
1010      * are about to be transferred. This includes minting.
1011      * And also called before burning one token.
1012      *
1013      * `startTokenId` - the first token ID to be transferred.
1014      * `quantity` - the amount to be transferred.
1015      *
1016      * Calling conditions:
1017      *
1018      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1019      * transferred to `to`.
1020      * - When `from` is zero, `tokenId` will be minted for `to`.
1021      * - When `to` is zero, `tokenId` will be burned by `from`.
1022      * - `from` and `to` are never both zero.
1023      */
1024     function _beforeTokenTransfers(
1025         address from,
1026         address to,
1027         uint256 startTokenId,
1028         uint256 quantity
1029     ) internal virtual {}
1030 
1031     /**
1032      * @dev Hook that is called after a set of serially-ordered token IDs
1033      * have been transferred. This includes minting.
1034      * And also called after one token has been burned.
1035      *
1036      * `startTokenId` - the first token ID to be transferred.
1037      * `quantity` - the amount to be transferred.
1038      *
1039      * Calling conditions:
1040      *
1041      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1042      * transferred to `to`.
1043      * - When `from` is zero, `tokenId` has been minted for `to`.
1044      * - When `to` is zero, `tokenId` has been burned by `from`.
1045      * - `from` and `to` are never both zero.
1046      */
1047     function _afterTokenTransfers(
1048         address from,
1049         address to,
1050         uint256 startTokenId,
1051         uint256 quantity
1052     ) internal virtual {}
1053 
1054     /**
1055      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1056      *
1057      * `from` - Previous owner of the given token ID.
1058      * `to` - Target address that will receive the token.
1059      * `tokenId` - Token ID to be transferred.
1060      * `_data` - Optional data to send along with the call.
1061      *
1062      * Returns whether the call correctly returned the expected magic value.
1063      */
1064     function _checkContractOnERC721Received(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) private returns (bool) {
1070         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1071             bytes4 retval
1072         ) {
1073             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1074         } catch (bytes memory reason) {
1075             if (reason.length == 0) {
1076                 revert TransferToNonERC721ReceiverImplementer();
1077             } else {
1078                 assembly {
1079                     revert(add(32, reason), mload(reason))
1080                 }
1081             }
1082         }
1083     }
1084 
1085     // =============================================================
1086     //                        MINT OPERATIONS
1087     // =============================================================
1088 
1089     /**
1090      * @dev Mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - `to` cannot be the zero address.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event for each mint.
1098      */
1099     function _mint(address to, uint256 quantity) internal virtual {
1100         uint256 startTokenId = _currentIndex;
1101         if (quantity == 0) revert MintZeroQuantity();
1102 
1103         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1104 
1105         // Overflows are incredibly unrealistic.
1106         // `balance` and `numberMinted` have a maximum limit of 2**64.
1107         // `tokenId` has a maximum limit of 2**256.
1108         unchecked {
1109             // Updates:
1110             // - `balance += quantity`.
1111             // - `numberMinted += quantity`.
1112             //
1113             // We can directly add to the `balance` and `numberMinted`.
1114             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1115 
1116             // Updates:
1117             // - `address` to the owner.
1118             // - `startTimestamp` to the timestamp of minting.
1119             // - `burned` to `false`.
1120             // - `nextInitialized` to `quantity == 1`.
1121             _packedOwnerships[startTokenId] = _packOwnershipData(
1122                 to,
1123                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1124             );
1125 
1126             uint256 toMasked;
1127             uint256 end = startTokenId + quantity;
1128 
1129             // Use assembly to loop and emit the `Transfer` event for gas savings.
1130             // The duplicated `log4` removes an extra check and reduces stack juggling.
1131             // The assembly, together with the surrounding Solidity code, have been
1132             // delicately arranged to nudge the compiler into producing optimized opcodes.
1133             assembly {
1134                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1135                 toMasked := and(to, _BITMASK_ADDRESS)
1136                 // Emit the `Transfer` event.
1137                 log4(
1138                     0, // Start of data (0, since no data).
1139                     0, // End of data (0, since no data).
1140                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1141                     0, // `address(0)`.
1142                     toMasked, // `to`.
1143                     startTokenId // `tokenId`.
1144                 )
1145 
1146                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1147                 // that overflows uint256 will make the loop run out of gas.
1148                 // The compiler will optimize the `iszero` away for performance.
1149                 for {
1150                     let tokenId := add(startTokenId, 1)
1151                 } iszero(eq(tokenId, end)) {
1152                     tokenId := add(tokenId, 1)
1153                 } {
1154                     // Emit the `Transfer` event. Similar to above.
1155                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1156                 }
1157             }
1158             if (toMasked == 0) revert MintToZeroAddress();
1159 
1160             _currentIndex = end;
1161         }
1162         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1163     }
1164 
1165     /**
1166      * @dev Mints `quantity` tokens and transfers them to `to`.
1167      *
1168      * This function is intended for efficient minting only during contract creation.
1169      *
1170      * It emits only one {ConsecutiveTransfer} as defined in
1171      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1172      * instead of a sequence of {Transfer} event(s).
1173      *
1174      * Calling this function outside of contract creation WILL make your contract
1175      * non-compliant with the ERC721 standard.
1176      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1177      * {ConsecutiveTransfer} event is only permissible during contract creation.
1178      *
1179      * Requirements:
1180      *
1181      * - `to` cannot be the zero address.
1182      * - `quantity` must be greater than 0.
1183      *
1184      * Emits a {ConsecutiveTransfer} event.
1185      */
1186     function _mintERC2309(address to, uint256 quantity) internal virtual {
1187         uint256 startTokenId = _currentIndex;
1188         if (to == address(0)) revert MintToZeroAddress();
1189         if (quantity == 0) revert MintZeroQuantity();
1190         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1191 
1192         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1193 
1194         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1195         unchecked {
1196             // Updates:
1197             // - `balance += quantity`.
1198             // - `numberMinted += quantity`.
1199             //
1200             // We can directly add to the `balance` and `numberMinted`.
1201             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1202 
1203             // Updates:
1204             // - `address` to the owner.
1205             // - `startTimestamp` to the timestamp of minting.
1206             // - `burned` to `false`.
1207             // - `nextInitialized` to `quantity == 1`.
1208             _packedOwnerships[startTokenId] = _packOwnershipData(
1209                 to,
1210                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1211             );
1212 
1213             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1214 
1215             _currentIndex = startTokenId + quantity;
1216         }
1217         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1218     }
1219 
1220     /**
1221      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1222      *
1223      * Requirements:
1224      *
1225      * - If `to` refers to a smart contract, it must implement
1226      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1227      * - `quantity` must be greater than 0.
1228      *
1229      * See {_mint}.
1230      *
1231      * Emits a {Transfer} event for each mint.
1232      */
1233     function _safeMint(
1234         address to,
1235         uint256 quantity,
1236         bytes memory _data
1237     ) internal virtual {
1238         _mint(to, quantity);
1239 
1240         unchecked {
1241             if (to.code.length != 0) {
1242                 uint256 end = _currentIndex;
1243                 uint256 index = end - quantity;
1244                 do {
1245                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1246                         revert TransferToNonERC721ReceiverImplementer();
1247                     }
1248                 } while (index < end);
1249                 // Reentrancy protection.
1250                 if (_currentIndex != end) revert();
1251             }
1252         }
1253     }
1254 
1255     /**
1256      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1257      */
1258     function _safeMint(address to, uint256 quantity) internal virtual {
1259         _safeMint(to, quantity, '');
1260     }
1261 
1262     // =============================================================
1263     //                        BURN OPERATIONS
1264     // =============================================================
1265 
1266     /**
1267      * @dev Equivalent to `_burn(tokenId, false)`.
1268      */
1269     function _burn(uint256 tokenId) internal virtual {
1270         _burn(tokenId, false);
1271     }
1272 
1273     /**
1274      * @dev Destroys `tokenId`.
1275      * The approval is cleared when the token is burned.
1276      *
1277      * Requirements:
1278      *
1279      * - `tokenId` must exist.
1280      *
1281      * Emits a {Transfer} event.
1282      */
1283     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1284         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1285 
1286         address from = address(uint160(prevOwnershipPacked));
1287 
1288         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1289 
1290         if (approvalCheck) {
1291             // The nested ifs save around 20+ gas over a compound boolean condition.
1292             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1293                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1294         }
1295 
1296         _beforeTokenTransfers(from, address(0), tokenId, 1);
1297 
1298         // Clear approvals from the previous owner.
1299         assembly {
1300             if approvedAddress {
1301                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1302                 sstore(approvedAddressSlot, 0)
1303             }
1304         }
1305 
1306         // Underflow of the sender's balance is impossible because we check for
1307         // ownership above and the recipient's balance can't realistically overflow.
1308         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1309         unchecked {
1310             // Updates:
1311             // - `balance -= 1`.
1312             // - `numberBurned += 1`.
1313             //
1314             // We can directly decrement the balance, and increment the number burned.
1315             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1316             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1317 
1318             // Updates:
1319             // - `address` to the last owner.
1320             // - `startTimestamp` to the timestamp of burning.
1321             // - `burned` to `true`.
1322             // - `nextInitialized` to `true`.
1323             _packedOwnerships[tokenId] = _packOwnershipData(
1324                 from,
1325                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1326             );
1327 
1328             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1329             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1330                 uint256 nextTokenId = tokenId + 1;
1331                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1332                 if (_packedOwnerships[nextTokenId] == 0) {
1333                     // If the next slot is within bounds.
1334                     if (nextTokenId != _currentIndex) {
1335                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1336                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1337                     }
1338                 }
1339             }
1340         }
1341 
1342         emit Transfer(from, address(0), tokenId);
1343         _afterTokenTransfers(from, address(0), tokenId, 1);
1344 
1345         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1346         unchecked {
1347             _burnCounter++;
1348         }
1349     }
1350 
1351     // =============================================================
1352     //                     EXTRA DATA OPERATIONS
1353     // =============================================================
1354 
1355     /**
1356      * @dev Directly sets the extra data for the ownership data `index`.
1357      */
1358     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1359         uint256 packed = _packedOwnerships[index];
1360         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1361         uint256 extraDataCasted;
1362         // Cast `extraData` with assembly to avoid redundant masking.
1363         assembly {
1364             extraDataCasted := extraData
1365         }
1366         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1367         _packedOwnerships[index] = packed;
1368     }
1369 
1370     /**
1371      * @dev Called during each token transfer to set the 24bit `extraData` field.
1372      * Intended to be overridden by the cosumer contract.
1373      *
1374      * `previousExtraData` - the value of `extraData` before transfer.
1375      *
1376      * Calling conditions:
1377      *
1378      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1379      * transferred to `to`.
1380      * - When `from` is zero, `tokenId` will be minted for `to`.
1381      * - When `to` is zero, `tokenId` will be burned by `from`.
1382      * - `from` and `to` are never both zero.
1383      */
1384     function _extraData(
1385         address from,
1386         address to,
1387         uint24 previousExtraData
1388     ) internal view virtual returns (uint24) {}
1389 
1390     /**
1391      * @dev Returns the next extra data for the packed ownership data.
1392      * The returned result is shifted into position.
1393      */
1394     function _nextExtraData(
1395         address from,
1396         address to,
1397         uint256 prevOwnershipPacked
1398     ) private view returns (uint256) {
1399         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1400         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1401     }
1402 
1403     // =============================================================
1404     //                       OTHER OPERATIONS
1405     // =============================================================
1406 
1407     /**
1408      * @dev Returns the message sender (defaults to `msg.sender`).
1409      *
1410      * If you are writing GSN compatible contracts, you need to override this function.
1411      */
1412     function _msgSenderERC721A() internal view virtual returns (address) {
1413         return msg.sender;
1414     }
1415 
1416     /**
1417      * @dev Converts a uint256 to its ASCII string decimal representation.
1418      */
1419     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1420         assembly {
1421             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1422             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1423             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1424             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1425             let m := add(mload(0x40), 0xa0)
1426             // Update the free memory pointer to allocate.
1427             mstore(0x40, m)
1428             // Assign the `str` to the end.
1429             str := sub(m, 0x20)
1430             // Zeroize the slot after the string.
1431             mstore(str, 0)
1432 
1433             // Cache the end of the memory to calculate the length later.
1434             let end := str
1435 
1436             // We write the string from rightmost digit to leftmost digit.
1437             // The following is essentially a do-while loop that also handles the zero case.
1438             // prettier-ignore
1439             for { let temp := value } 1 {} {
1440                 str := sub(str, 1)
1441                 // Write the character to the pointer.
1442                 // The ASCII index of the '0' character is 48.
1443                 mstore8(str, add(48, mod(temp, 10)))
1444                 // Keep dividing `temp` until zero.
1445                 temp := div(temp, 10)
1446                 // prettier-ignore
1447                 if iszero(temp) { break }
1448             }
1449 
1450             let length := sub(end, str)
1451             // Move the pointer 32 bytes leftwards to make room for the length.
1452             str := sub(str, 0x20)
1453             // Store the length.
1454             mstore(str, length)
1455         }
1456     }
1457 }
1458 
1459 /**
1460  * @dev These functions deal with verification of Merkle Tree proofs.
1461  *
1462  * The tree and the proofs can be generated using our
1463  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1464  * You will find a quickstart guide in the readme.
1465  *
1466  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1467  * hashing, or use a hash function other than keccak256 for hashing leaves.
1468  * This is because the concatenation of a sorted pair of internal nodes in
1469  * the merkle tree could be reinterpreted as a leaf value.
1470  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1471  * against this attack out of the box.
1472  */
1473 library MerkleProof {
1474     /**
1475      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1476      * defined by `root`. For this, a `proof` must be provided, containing
1477      * sibling hashes on the branch from the leaf to the root of the tree. Each
1478      * pair of leaves and each pair of pre-images are assumed to be sorted.
1479      */
1480     function verify(
1481         bytes32[] memory proof,
1482         bytes32 root,
1483         bytes32 leaf
1484     ) internal pure returns (bool) {
1485         return processProof(proof, leaf) == root;
1486     }
1487 
1488     /**
1489      * @dev Calldata version of {verify}
1490      *
1491      * _Available since v4.7._
1492      */
1493     function verifyCalldata(
1494         bytes32[] calldata proof,
1495         bytes32 root,
1496         bytes32 leaf
1497     ) internal pure returns (bool) {
1498         return processProofCalldata(proof, leaf) == root;
1499     }
1500 
1501     /**
1502      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1503      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1504      * hash matches the root of the tree. When processing the proof, the pairs
1505      * of leafs & pre-images are assumed to be sorted.
1506      *
1507      * _Available since v4.4._
1508      */
1509     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1510         bytes32 computedHash = leaf;
1511         for (uint256 i = 0; i < proof.length; i++) {
1512             computedHash = _hashPair(computedHash, proof[i]);
1513         }
1514         return computedHash;
1515     }
1516 
1517     /**
1518      * @dev Calldata version of {processProof}
1519      *
1520      * _Available since v4.7._
1521      */
1522     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1523         bytes32 computedHash = leaf;
1524         for (uint256 i = 0; i < proof.length; i++) {
1525             computedHash = _hashPair(computedHash, proof[i]);
1526         }
1527         return computedHash;
1528     }
1529 
1530     /**
1531      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1532      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1533      *
1534      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1535      *
1536      * _Available since v4.7._
1537      */
1538     function multiProofVerify(
1539         bytes32[] memory proof,
1540         bool[] memory proofFlags,
1541         bytes32 root,
1542         bytes32[] memory leaves
1543     ) internal pure returns (bool) {
1544         return processMultiProof(proof, proofFlags, leaves) == root;
1545     }
1546 
1547     /**
1548      * @dev Calldata version of {multiProofVerify}
1549      *
1550      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1551      *
1552      * _Available since v4.7._
1553      */
1554     function multiProofVerifyCalldata(
1555         bytes32[] calldata proof,
1556         bool[] calldata proofFlags,
1557         bytes32 root,
1558         bytes32[] memory leaves
1559     ) internal pure returns (bool) {
1560         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1561     }
1562 
1563     /**
1564      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1565      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1566      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1567      * respectively.
1568      *
1569      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1570      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1571      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1572      *
1573      * _Available since v4.7._
1574      */
1575     function processMultiProof(
1576         bytes32[] memory proof,
1577         bool[] memory proofFlags,
1578         bytes32[] memory leaves
1579     ) internal pure returns (bytes32 merkleRoot) {
1580         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1581         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1582         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1583         // the merkle tree.
1584         uint256 leavesLen = leaves.length;
1585         uint256 totalHashes = proofFlags.length;
1586 
1587         // Check proof validity.
1588         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1589 
1590         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1591         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1592         bytes32[] memory hashes = new bytes32[](totalHashes);
1593         uint256 leafPos = 0;
1594         uint256 hashPos = 0;
1595         uint256 proofPos = 0;
1596         // At each step, we compute the next hash using two values:
1597         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1598         //   get the next hash.
1599         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1600         //   `proof` array.
1601         for (uint256 i = 0; i < totalHashes; i++) {
1602             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1603             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1604             hashes[i] = _hashPair(a, b);
1605         }
1606 
1607         if (totalHashes > 0) {
1608             return hashes[totalHashes - 1];
1609         } else if (leavesLen > 0) {
1610             return leaves[0];
1611         } else {
1612             return proof[0];
1613         }
1614     }
1615 
1616     /**
1617      * @dev Calldata version of {processMultiProof}.
1618      *
1619      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1620      *
1621      * _Available since v4.7._
1622      */
1623     function processMultiProofCalldata(
1624         bytes32[] calldata proof,
1625         bool[] calldata proofFlags,
1626         bytes32[] memory leaves
1627     ) internal pure returns (bytes32 merkleRoot) {
1628         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1629         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1630         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1631         // the merkle tree.
1632         uint256 leavesLen = leaves.length;
1633         uint256 totalHashes = proofFlags.length;
1634 
1635         // Check proof validity.
1636         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1637 
1638         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1639         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1640         bytes32[] memory hashes = new bytes32[](totalHashes);
1641         uint256 leafPos = 0;
1642         uint256 hashPos = 0;
1643         uint256 proofPos = 0;
1644         // At each step, we compute the next hash using two values:
1645         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1646         //   get the next hash.
1647         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1648         //   `proof` array.
1649         for (uint256 i = 0; i < totalHashes; i++) {
1650             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1651             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1652             hashes[i] = _hashPair(a, b);
1653         }
1654 
1655         if (totalHashes > 0) {
1656             return hashes[totalHashes - 1];
1657         } else if (leavesLen > 0) {
1658             return leaves[0];
1659         } else {
1660             return proof[0];
1661         }
1662     }
1663 
1664     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1665         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1666     }
1667 
1668     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1669         /// @solidity memory-safe-assembly
1670         assembly {
1671             mstore(0x00, a)
1672             mstore(0x20, b)
1673             value := keccak256(0x00, 0x40)
1674         }
1675     }
1676 }
1677 
1678 /**
1679  * @dev Standard math utilities missing in the Solidity language.
1680  */
1681 library Math {
1682     enum Rounding {
1683         Down, // Toward negative infinity
1684         Up, // Toward infinity
1685         Zero // Toward zero
1686     }
1687 
1688     /**
1689      * @dev Returns the largest of two numbers.
1690      */
1691     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1692         return a > b ? a : b;
1693     }
1694 
1695     /**
1696      * @dev Returns the smallest of two numbers.
1697      */
1698     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1699         return a < b ? a : b;
1700     }
1701 
1702     /**
1703      * @dev Returns the average of two numbers. The result is rounded towards
1704      * zero.
1705      */
1706     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1707         // (a + b) / 2 can overflow.
1708         return (a & b) + (a ^ b) / 2;
1709     }
1710 
1711     /**
1712      * @dev Returns the ceiling of the division of two numbers.
1713      *
1714      * This differs from standard division with `/` in that it rounds up instead
1715      * of rounding down.
1716      */
1717     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1718         // (a + b - 1) / b can overflow on addition, so we distribute.
1719         return a == 0 ? 0 : (a - 1) / b + 1;
1720     }
1721 
1722     /**
1723      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1724      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1725      * with further edits by Uniswap Labs also under MIT license.
1726      */
1727     function mulDiv(
1728         uint256 x,
1729         uint256 y,
1730         uint256 denominator
1731     ) internal pure returns (uint256 result) {
1732         unchecked {
1733             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1734             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1735             // variables such that product = prod1 * 2^256 + prod0.
1736             uint256 prod0; // Least significant 256 bits of the product
1737             uint256 prod1; // Most significant 256 bits of the product
1738             assembly {
1739                 let mm := mulmod(x, y, not(0))
1740                 prod0 := mul(x, y)
1741                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1742             }
1743 
1744             // Handle non-overflow cases, 256 by 256 division.
1745             if (prod1 == 0) {
1746                 return prod0 / denominator;
1747             }
1748 
1749             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1750             require(denominator > prod1);
1751 
1752             ///////////////////////////////////////////////
1753             // 512 by 256 division.
1754             ///////////////////////////////////////////////
1755 
1756             // Make division exact by subtracting the remainder from [prod1 prod0].
1757             uint256 remainder;
1758             assembly {
1759                 // Compute remainder using mulmod.
1760                 remainder := mulmod(x, y, denominator)
1761 
1762                 // Subtract 256 bit number from 512 bit number.
1763                 prod1 := sub(prod1, gt(remainder, prod0))
1764                 prod0 := sub(prod0, remainder)
1765             }
1766 
1767             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1768             // See https://cs.stackexchange.com/q/138556/92363.
1769 
1770             // Does not overflow because the denominator cannot be zero at this stage in the function.
1771             uint256 twos = denominator & (~denominator + 1);
1772             assembly {
1773                 // Divide denominator by twos.
1774                 denominator := div(denominator, twos)
1775 
1776                 // Divide [prod1 prod0] by twos.
1777                 prod0 := div(prod0, twos)
1778 
1779                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1780                 twos := add(div(sub(0, twos), twos), 1)
1781             }
1782 
1783             // Shift in bits from prod1 into prod0.
1784             prod0 |= prod1 * twos;
1785 
1786             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1787             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1788             // four bits. That is, denominator * inv = 1 mod 2^4.
1789             uint256 inverse = (3 * denominator) ^ 2;
1790 
1791             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1792             // in modular arithmetic, doubling the correct bits in each step.
1793             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1794             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1795             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1796             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1797             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1798             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1799 
1800             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1801             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1802             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1803             // is no longer required.
1804             result = prod0 * inverse;
1805             return result;
1806         }
1807     }
1808 
1809     /**
1810      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1811      */
1812     function mulDiv(
1813         uint256 x,
1814         uint256 y,
1815         uint256 denominator,
1816         Rounding rounding
1817     ) internal pure returns (uint256) {
1818         uint256 result = mulDiv(x, y, denominator);
1819         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1820             result += 1;
1821         }
1822         return result;
1823     }
1824 
1825     /**
1826      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1827      *
1828      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1829      */
1830     function sqrt(uint256 a) internal pure returns (uint256) {
1831         if (a == 0) {
1832             return 0;
1833         }
1834 
1835         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1836         //
1837         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1838         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1839         //
1840         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1841         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1842         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1843         //
1844         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1845         uint256 result = 1 << (log2(a) >> 1);
1846 
1847         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1848         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1849         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1850         // into the expected uint128 result.
1851         unchecked {
1852             result = (result + a / result) >> 1;
1853             result = (result + a / result) >> 1;
1854             result = (result + a / result) >> 1;
1855             result = (result + a / result) >> 1;
1856             result = (result + a / result) >> 1;
1857             result = (result + a / result) >> 1;
1858             result = (result + a / result) >> 1;
1859             return min(result, a / result);
1860         }
1861     }
1862 
1863     /**
1864      * @notice Calculates sqrt(a), following the selected rounding direction.
1865      */
1866     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1867         unchecked {
1868             uint256 result = sqrt(a);
1869             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1870         }
1871     }
1872 
1873     /**
1874      * @dev Return the log in base 2, rounded down, of a positive value.
1875      * Returns 0 if given 0.
1876      */
1877     function log2(uint256 value) internal pure returns (uint256) {
1878         uint256 result = 0;
1879         unchecked {
1880             if (value >> 128 > 0) {
1881                 value >>= 128;
1882                 result += 128;
1883             }
1884             if (value >> 64 > 0) {
1885                 value >>= 64;
1886                 result += 64;
1887             }
1888             if (value >> 32 > 0) {
1889                 value >>= 32;
1890                 result += 32;
1891             }
1892             if (value >> 16 > 0) {
1893                 value >>= 16;
1894                 result += 16;
1895             }
1896             if (value >> 8 > 0) {
1897                 value >>= 8;
1898                 result += 8;
1899             }
1900             if (value >> 4 > 0) {
1901                 value >>= 4;
1902                 result += 4;
1903             }
1904             if (value >> 2 > 0) {
1905                 value >>= 2;
1906                 result += 2;
1907             }
1908             if (value >> 1 > 0) {
1909                 result += 1;
1910             }
1911         }
1912         return result;
1913     }
1914 
1915     /**
1916      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1917      * Returns 0 if given 0.
1918      */
1919     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1920         unchecked {
1921             uint256 result = log2(value);
1922             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1923         }
1924     }
1925 
1926     /**
1927      * @dev Return the log in base 10, rounded down, of a positive value.
1928      * Returns 0 if given 0.
1929      */
1930     function log10(uint256 value) internal pure returns (uint256) {
1931         uint256 result = 0;
1932         unchecked {
1933             if (value >= 10**64) {
1934                 value /= 10**64;
1935                 result += 64;
1936             }
1937             if (value >= 10**32) {
1938                 value /= 10**32;
1939                 result += 32;
1940             }
1941             if (value >= 10**16) {
1942                 value /= 10**16;
1943                 result += 16;
1944             }
1945             if (value >= 10**8) {
1946                 value /= 10**8;
1947                 result += 8;
1948             }
1949             if (value >= 10**4) {
1950                 value /= 10**4;
1951                 result += 4;
1952             }
1953             if (value >= 10**2) {
1954                 value /= 10**2;
1955                 result += 2;
1956             }
1957             if (value >= 10**1) {
1958                 result += 1;
1959             }
1960         }
1961         return result;
1962     }
1963 
1964     /**
1965      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1966      * Returns 0 if given 0.
1967      */
1968     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1969         unchecked {
1970             uint256 result = log10(value);
1971             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1972         }
1973     }
1974 
1975     /**
1976      * @dev Return the log in base 256, rounded down, of a positive value.
1977      * Returns 0 if given 0.
1978      *
1979      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1980      */
1981     function log256(uint256 value) internal pure returns (uint256) {
1982         uint256 result = 0;
1983         unchecked {
1984             if (value >> 128 > 0) {
1985                 value >>= 128;
1986                 result += 16;
1987             }
1988             if (value >> 64 > 0) {
1989                 value >>= 64;
1990                 result += 8;
1991             }
1992             if (value >> 32 > 0) {
1993                 value >>= 32;
1994                 result += 4;
1995             }
1996             if (value >> 16 > 0) {
1997                 value >>= 16;
1998                 result += 2;
1999             }
2000             if (value >> 8 > 0) {
2001                 result += 1;
2002             }
2003         }
2004         return result;
2005     }
2006 
2007     /**
2008      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2009      * Returns 0 if given 0.
2010      */
2011     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2012         unchecked {
2013             uint256 result = log256(value);
2014             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2015         }
2016     }
2017 }
2018 
2019 /**
2020  * @dev String operations.
2021  */
2022 library Strings {
2023     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2024     uint8 private constant _ADDRESS_LENGTH = 20;
2025 
2026     /**
2027      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2028      */
2029     function toString(uint256 value) internal pure returns (string memory) {
2030         unchecked {
2031             uint256 length = Math.log10(value) + 1;
2032             string memory buffer = new string(length);
2033             uint256 ptr;
2034             /// @solidity memory-safe-assembly
2035             assembly {
2036                 ptr := add(buffer, add(32, length))
2037             }
2038             while (true) {
2039                 ptr--;
2040                 /// @solidity memory-safe-assembly
2041                 assembly {
2042                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2043                 }
2044                 value /= 10;
2045                 if (value == 0) break;
2046             }
2047             return buffer;
2048         }
2049     }
2050 
2051     /**
2052      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2053      */
2054     function toHexString(uint256 value) internal pure returns (string memory) {
2055         unchecked {
2056             return toHexString(value, Math.log256(value) + 1);
2057         }
2058     }
2059 
2060     /**
2061      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2062      */
2063     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2064         bytes memory buffer = new bytes(2 * length + 2);
2065         buffer[0] = "0";
2066         buffer[1] = "x";
2067         for (uint256 i = 2 * length + 1; i > 1; --i) {
2068             buffer[i] = _SYMBOLS[value & 0xf];
2069             value >>= 4;
2070         }
2071         require(value == 0, "Strings: hex length insufficient");
2072         return string(buffer);
2073     }
2074 
2075     /**
2076      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2077      */
2078     function toHexString(address addr) internal pure returns (string memory) {
2079         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2080     }
2081 }
2082 
2083 interface IEIP2981 {
2084     /// ERC165 bytes to add to interface array - set in parent contract
2085     /// implementing this standard
2086     ///
2087     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
2088 
2089     /// @notice Called with the sale price to determine how much royalty
2090     //          is owed and to whom.
2091     /// @param _tokenId - the NFT asset queried for royalty information
2092     /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
2093     /// @return receiver - address of who should be sent the royalty payment
2094     /// @return royaltyAmount - the royalty payment amount for _salePrice
2095     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver,uint256 royaltyAmount);
2096 }
2097 
2098 interface IERC165 {
2099     /**
2100      * @dev Returns true if this contract implements the interface defined by
2101      * `interfaceId`. See the corresponding
2102      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2103      * to learn more about how these ids are created.
2104      *
2105      * This function call must use less than 30 000 gas.
2106      */
2107     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2108 }
2109 
2110 
2111 contract AnleiUtils
2112 {
2113     using Strings for uint256;
2114 
2115     event Log(string);
2116 
2117     function random(uint number) public view returns(uint) {
2118         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % number;
2119     }
2120 
2121     function addressArrayEq(address[] memory arr, address addr) internal pure returns(string memory)
2122     {
2123         for(uint256 i=0; i<arr.length; i++)
2124         {
2125             if(arr[i] == addr)
2126             {
2127                 return i.toString();
2128             }
2129         }
2130         return "-1";
2131     }
2132 
2133     function isEqual(string memory a, string memory b) public pure returns (bool) {
2134         bytes memory aa = bytes(a);
2135         bytes memory bb = bytes(b);
2136         // 如果长度不等，直接返回
2137         if (aa.length != bb.length) return false;
2138         // 按位比较
2139         for(uint i = 0; i < aa.length; i ++) {
2140             if(aa[i] != bb[i]) return false;
2141         }
2142  
2143         return true;
2144     }
2145     
2146 
2147     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
2148         return parseInt(_a, 0);
2149     }
2150 
2151     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
2152         bytes memory bresult = bytes(_a);
2153         uint mint = 0;
2154         bool decimals = false;
2155         for (uint i = 0; i < bresult.length; i++) {
2156             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
2157                 if (decimals) {
2158                    if (_b == 0) {
2159                        break;
2160                    } else {
2161                        _b--;
2162                    }
2163                 }
2164                 mint *= 10;
2165                 mint += uint(uint8(bresult[i])) - 48;
2166             } else if (uint(uint8(bresult[i])) == 46) {
2167                 decimals = true;
2168             }
2169         }
2170         if (_b > 0) {
2171             mint *= 10 ** _b;
2172         }
2173         return mint;
2174     }
2175 /*
2176     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
2177         if (_i == 0) {
2178             return "0";
2179         }
2180         uint j = _i;
2181         uint len;
2182         while (j != 0) {
2183             len++;
2184             j /= 10;
2185         }
2186         bytes memory bstr = new bytes(len);
2187         uint k = len - 1;
2188         while (_i != 0) {
2189             bstr[k--] = bytes1(uint8(48 + _i % 10));
2190             _i /= 10;
2191         }
2192         return string(bstr);
2193     }
2194     
2195     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
2196         return strConcat(_a, _b, "", "", "");
2197     }
2198 
2199     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
2200         return strConcat(_a, _b, _c, "", "");
2201     }
2202 
2203     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
2204         return strConcat(_a, _b, _c, _d, "");
2205     }
2206 
2207     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
2208         bytes memory _ba = bytes(_a);
2209         bytes memory _bb = bytes(_b);
2210         bytes memory _bc = bytes(_c);
2211         bytes memory _bd = bytes(_d);
2212         bytes memory _be = bytes(_e);
2213         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
2214         bytes memory babcde = bytes(abcde);
2215         uint k = 0;
2216         uint i = 0;
2217         for (i = 0; i < _ba.length; i++) {
2218             babcde[k++] = _ba[i];
2219         }
2220         for (i = 0; i < _bb.length; i++) {
2221             babcde[k++] = _bb[i];
2222         }
2223         for (i = 0; i < _bc.length; i++) {
2224             babcde[k++] = _bc[i];
2225         }
2226         for (i = 0; i < _bd.length; i++) {
2227             babcde[k++] = _bd[i];
2228         }
2229         for (i = 0; i < _be.length; i++) {
2230             babcde[k++] = _be[i];
2231         }
2232         return string(babcde);
2233     }
2234 */
2235 
2236     
2237 }
2238 abstract contract ERC165 is IERC165 {
2239     /**
2240      * @dev See {IERC165-supportsInterface}.
2241      */
2242     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2243         return interfaceId == type(IERC165).interfaceId;
2244     }
2245 }
2246 abstract contract EIP2981AllToken is IEIP2981, ERC165 {
2247 
2248     address internal _royaltyAddr;
2249     uint256 internal _royaltyPerc; // percentage in basis (out of 10,000)
2250 
2251     /**
2252     *   @param recipient is the royalty recipient
2253     *   @param percentage is the royalty percentage
2254     */
2255     constructor(address recipient, uint256 percentage) {
2256         _setRoyaltyInfo(recipient, percentage);
2257     }
2258     
2259     /**
2260     *   @notice EIP 2981 royalty support
2261     *   @dev royalty amount not dependent on _tokenId
2262     */
2263     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view virtual override returns (address receiver, uint256 royaltyAmount) {
2264         return (_royaltyAddr, _royaltyPerc * _salePrice / 10000);
2265     }
2266 
2267     /**
2268     *   @notice override ERC 165 implementation of this function
2269     *   @dev if using this contract with another contract that suppports ERC 265, will have to override in the inheriting contract
2270     */
2271     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
2272         return interfaceId == type(IEIP2981).interfaceId || super.supportsInterface(interfaceId);
2273     }
2274 
2275     /**
2276     *   @notice function to set royalty information
2277     *   @dev to be called by inheriting contract
2278     *   @param addr is the royalty payout address for this token id
2279     *   @param perc is the royalty percentage (out of 10,000) to set for this token id
2280     */
2281     function _setRoyaltyInfo(address addr, uint256 perc) internal virtual {
2282         require(addr != address(0), "EIP2981AllToken: Cannot set royalty receipient to the zero address");
2283         require(perc < 10000, "EIP2981AllToken: Cannot set royalty percentage above 10000");
2284         _royaltyAddr = addr;
2285         _royaltyPerc = perc;
2286     }
2287 }
2288 
2289 contract OwnerBase
2290 {
2291     address public owner;
2292     
2293     constructor(){
2294         owner = msg.sender;
2295     }
2296 
2297     modifier onlyOwner {
2298         require(msg.sender == owner);
2299         _;
2300     }
2301 
2302 }
2303 
2304 
2305 contract PayAbstruct is OwnerBase
2306 {
2307     constructor()
2308     {
2309 
2310     }
2311 
2312     //////
2313     //////  Pay  //////
2314     //////
2315     //pay eth to this
2316     /*function paytocontract() external payable
2317     {
2318     }*/
2319     //this eth to owner
2320     function withdraw() onlyOwner external payable
2321     {
2322         payable(msg.sender).transfer(address(this).balance);
2323     }
2324     //get eth total
2325     function getBalance() public view returns(uint256 num)
2326     {
2327         return address(this).balance;
2328     }
2329     /*
2330     function withdraw2(address to) public onlyOwner payable{
2331         uint256 balance = address(this).balance;
2332         payable(to).transfer(balance);
2333     }*/
2334     
2335 }
2336 
2337 contract NFTClass is ERC721A,EIP2981AllToken,OwnerBase,PayAbstruct,DefaultOperatorFilterer {
2338     using Strings for uint256;
2339 
2340     //NFT json head url
2341     string private IPFS_URL = "https://nftstorage.link/ipfs/bafybeif6fnkyl4ku2ymuxezc55km2d7hin6oeyi4catmwfnsrvbhm3v644/";
2342     //Mint param
2343     uint256 public MAX_SUPPLY = 8888;//total number
2344     uint256 public USER_LIMIT = 2;//user mint total
2345     //uint256 public Mint_Price = 0.008 ether;
2346     uint256 public Mint_Price_normal = 0.008 ether;
2347     uint256 public Mint_Price_wl = 0.003 ether;
2348 
2349     //white list root - need pay eth
2350     bytes32 public merkleRoot_wlValue = 0x16858b4922a790eed48063950aba13c87bdf99655bebe69dfcb34ace38c66d70;
2351     //white list root - free
2352     bytes32 public merkleRoot_wlFree = 0x3e3e5716f9628f37b1a844c398168372cd96a1043377fc3b6051a452acf77e4e;
2353     //true = open wl time
2354     bool public whitelist_switch = true;
2355 
2356     bool private isAirdrop = false;
2357 
2358     //open blind
2359     //bool public isOpenBlind = false;//true = open blind
2360     //string public Blind_JSON_URL = "https://bafybeiheymbs6ze7nra3pgwahe2zifq4374v2j3v2zztqdbcufwwxgzppy.ipfs.nftstorage.link/FashionDucksBlindbox.json";
2361 
2362 
2363 
2364     constructor(
2365         address royaltyPayout,
2366         uint256 royaltyPerc,
2367         string memory nft_name,
2368         string memory nft_symbol
2369         )
2370         ERC721A(nft_name, nft_symbol)
2371         EIP2981AllToken(royaltyPayout, royaltyPerc)
2372     {
2373         //setNFTClass(this);
2374     }
2375     
2376     //////
2377     //////  NFT  //////
2378     //////
2379     function verify_wlValue(bytes32[] memory proof) public view returns(bool result)
2380     {
2381         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2382         return MerkleProof.verify(proof, merkleRoot_wlValue, leaf);
2383     }
2384     function verify_wlFree(bytes32[] memory proof) public view returns(bool result)
2385     {
2386         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2387         return MerkleProof.verify(proof, merkleRoot_wlFree, leaf);
2388     }
2389     //
2390     function getPokerList(address addr) public view returns(uint256[] memory)
2391     {
2392         uint256[] memory arr = new uint256[](balanceOf(addr));
2393         uint256 len = totalSupply();
2394         uint256 j=0;
2395         for (uint256 i = _startTokenId(); i <= len; i++) {
2396             if (ownerOf(i) == addr) {
2397                 arr[j++] = i;
2398             }
2399         }
2400         
2401         return arr;
2402     }
2403     //mint after
2404     /*function _afterTokenTransfers(
2405         address from,
2406         address to,
2407         uint256 startTokenId,
2408         uint256 quantity
2409     ) internal virtual override
2410     {
2411         //owner not play game
2412         if(owner != to) {
2413             for(uint256 i=startTokenId; i<startTokenId+quantity; i++)
2414             {
2415                 createPoker(to, i);
2416             }
2417         }
2418     }*/
2419     //user mint
2420     function mint(uint256 quantity, bytes32[] memory proof) external payable
2421     {
2422         bool wlv = verify_wlValue(proof);
2423         bool wlf = verify_wlFree(proof);
2424         //wl onf
2425         if(whitelist_switch) {
2426             require(wlv || wlf, "white list time.");
2427         }
2428         //not wl
2429         if(!wlv && !wlf) {
2430             require(msg.value >= Mint_Price_normal * quantity, "wrong price");
2431         }
2432         //is wl
2433         if(wlv){
2434             require(msg.value >= Mint_Price_wl * quantity, "wrong price (wl)");
2435         }
2436         //go to pay
2437         require(_totalMinted() + quantity <= MAX_SUPPLY, "Not more supply left");
2438         require(_numberMinted(msg.sender) + quantity <= USER_LIMIT, "User limit reached");
2439         //require(balanceOf(msg.sender) + quantity <= USER_LIMIT, "User limit reached");
2440         
2441 
2442         _safeMint(msg.sender, quantity);
2443     }
2444     //owner mint
2445     function creatorMint(address minter, uint256 quantity) onlyOwner public  payable
2446     {
2447         _safeMint(minter, quantity);
2448     }
2449     //airdrop my team
2450     function airdrop() onlyOwner public payable
2451     {
2452         require(isAirdrop == false);
2453         _safeMint(owner, 300);
2454         isAirdrop = true;
2455     }
2456     //function _baseURI() internal view virtual returns (string memory) {
2457     function _baseURI() internal view virtual override returns (string memory) {
2458         return IPFS_URL;
2459     }
2460     //return json file to platform
2461     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2462     {
2463         //if not open blind, return cover gif.
2464         /*if(isOpenBlind == false){
2465             return Blind_JSON_URL;
2466         }*/
2467         //if open blind, return nft png.
2468         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2469         string memory currentBaseURI = _baseURI();
2470         return bytes(currentBaseURI).length > 0
2471             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
2472             : "";
2473     }
2474     
2475     //////
2476     //////  setting  //////
2477     //////
2478     function SET_IPFS_URL(string memory uri) onlyOwner public {
2479         IPFS_URL = uri;
2480     }
2481     function SET_USER_LIMIT(uint256 val) onlyOwner public {
2482         USER_LIMIT = val;
2483     }
2484     function SET_Mint_Price_normal(uint256 val) onlyOwner public {
2485         Mint_Price_normal = val;
2486     }
2487     function SET_Mint_Price_wl(uint256 val) onlyOwner public {
2488         Mint_Price_wl = val;
2489     }
2490     function SET_MAX_SUPPLY(uint256 val) onlyOwner public {
2491         MAX_SUPPLY = val;
2492     }
2493     function SET_merkleRoot_wlValue(bytes32 val) onlyOwner public {
2494         merkleRoot_wlValue = val;
2495     }
2496     function SET_merkleRoot_wlFree(bytes32 val) onlyOwner public {
2497         merkleRoot_wlFree = val;
2498     }
2499     function SET_whitelist_switch(bool val) onlyOwner public {
2500         whitelist_switch = val;
2501     }
2502     /*function SET_OpenBlind_switch(bool val) onlyOwner public {
2503         isOpenBlind = val;
2504     }
2505     function SET_Blind_JSON_URL(string memory uri) onlyOwner public {
2506         Blind_JSON_URL = uri;
2507     }*/
2508     ////
2509     
2510     ////opensea
2511 
2512     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2513         super.setApprovalForAll(operator, approved);
2514     }
2515     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2516         super.approve(operator, tokenId);
2517     }
2518     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2519         super.transferFrom(from, to, tokenId);
2520     }
2521     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2522         super.safeTransferFrom(from, to, tokenId);
2523     }
2524     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2525         public payable
2526         override
2527         onlyAllowedOperator(from)
2528     {
2529         super.safeTransferFrom(from, to, tokenId, data);
2530     }
2531 
2532     /////
2533     function setRoyaltyAddr(address addr) onlyOwner public {
2534         _royaltyAddr = addr;
2535     }
2536     // percentage in basis (out of 10,000)
2537     // -> 10000/10000=100%=1
2538     // -> 750/10000 = 0.075*100 = 7.5%
2539     function setRoyaltyPerc(uint256 val) onlyOwner public {
2540         _royaltyPerc = val;
2541     }
2542     /// @dev see {ERC165.supportsInterface}
2543     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, EIP2981AllToken) returns (bool) {
2544         return ERC721A.supportsInterface(interfaceId) || EIP2981AllToken.supportsInterface(interfaceId);
2545     }
2546 }
2547 
2548 
2549 contract MainFD is NFTClass {
2550 
2551     constructor()
2552         NFTClass(msg.sender, 750, "FashionDucks", "FDS")
2553     {
2554         
2555     }
2556     
2557 }