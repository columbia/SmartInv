1 // Sources flattened with hardhat v2.12.3 https://hardhat.org
2 
3 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.3.1
4 
5 
6 pragma solidity ^0.8.13;
7 
8 interface IOperatorFilterRegistry {
9     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
10     function register(address registrant) external;
11     function registerAndSubscribe(address registrant, address subscription) external;
12     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
13     function unregister(address addr) external;
14     function updateOperator(address registrant, address operator, bool filtered) external;
15     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
16     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
17     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
18     function subscribe(address registrant, address registrantToSubscribe) external;
19     function unsubscribe(address registrant, bool copyExistingEntries) external;
20     function subscriptionOf(address addr) external returns (address registrant);
21     function subscribers(address registrant) external returns (address[] memory);
22     function subscriberAt(address registrant, uint256 index) external returns (address);
23     function copyEntriesOf(address registrant, address registrantToCopy) external;
24     function isOperatorFiltered(address registrant, address operator) external returns (bool);
25     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
26     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
27     function filteredOperators(address addr) external returns (address[] memory);
28     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
29     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
30     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
31     function isRegistered(address addr) external returns (bool);
32     function codeHashOf(address addr) external returns (bytes32);
33 }
34 
35 
36 // File operator-filter-registry/src/OperatorFilterer.sol@v1.3.1
37 
38 
39 pragma solidity ^0.8.13;
40 
41 /**
42  * @title  OperatorFilterer
43  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
44  *         registrant's entries in the OperatorFilterRegistry.
45  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
46  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
47  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
48  */
49 abstract contract OperatorFilterer {
50     error OperatorNotAllowed(address operator);
51 
52     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
53         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
54 
55     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
56         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
57         // will not revert, but the contract will need to be registered with the registry once it is deployed in
58         // order for the modifier to filter addresses.
59         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
60             if (subscribe) {
61                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
62             } else {
63                 if (subscriptionOrRegistrantToCopy != address(0)) {
64                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
65                 } else {
66                     OPERATOR_FILTER_REGISTRY.register(address(this));
67                 }
68             }
69         }
70     }
71 
72     modifier onlyAllowedOperator(address from) virtual {
73         // Allow spending tokens from addresses with balance
74         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
75         // from an EOA.
76         if (from != msg.sender) {
77             _checkFilterOperator(msg.sender);
78         }
79         _;
80     }
81 
82     modifier onlyAllowedOperatorApproval(address operator) virtual {
83         _checkFilterOperator(operator);
84         _;
85     }
86 
87     function _checkFilterOperator(address operator) internal view virtual {
88         // Check registry code length to facilitate testing in environments without a deployed registry.
89         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
90             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
91                 revert OperatorNotAllowed(operator);
92             }
93         }
94     }
95 }
96 
97 
98 // File operator-filter-registry/src/DefaultOperatorFilterer.sol@v1.3.1
99 
100 
101 pragma solidity ^0.8.13;
102 
103 /**
104  * @title  DefaultOperatorFilterer
105  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
106  */
107 abstract contract DefaultOperatorFilterer is OperatorFilterer {
108     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
109 
110     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
111 }
112 
113 
114 // File erc721a/contracts/IERC721A.sol@v4.2.3
115 
116 
117 // ERC721A Contracts v4.2.3
118 // Creator: Chiru Labs
119 
120 pragma solidity ^0.8.4;
121 
122 /**
123  * @dev Interface of ERC721A.
124  */
125 interface IERC721A {
126     /**
127      * The caller must own the token or be an approved operator.
128      */
129     error ApprovalCallerNotOwnerNorApproved();
130 
131     /**
132      * The token does not exist.
133      */
134     error ApprovalQueryForNonexistentToken();
135 
136     /**
137      * Cannot query the balance for the zero address.
138      */
139     error BalanceQueryForZeroAddress();
140 
141     /**
142      * Cannot mint to the zero address.
143      */
144     error MintToZeroAddress();
145 
146     /**
147      * The quantity of tokens minted must be more than zero.
148      */
149     error MintZeroQuantity();
150 
151     /**
152      * The token does not exist.
153      */
154     error OwnerQueryForNonexistentToken();
155 
156     /**
157      * The caller must own the token or be an approved operator.
158      */
159     error TransferCallerNotOwnerNorApproved();
160 
161     /**
162      * The token must be owned by `from`.
163      */
164     error TransferFromIncorrectOwner();
165 
166     /**
167      * Cannot safely transfer to a contract that does not implement the
168      * ERC721Receiver interface.
169      */
170     error TransferToNonERC721ReceiverImplementer();
171 
172     /**
173      * Cannot transfer to the zero address.
174      */
175     error TransferToZeroAddress();
176 
177     /**
178      * The token does not exist.
179      */
180     error URIQueryForNonexistentToken();
181 
182     /**
183      * The `quantity` minted with ERC2309 exceeds the safety limit.
184      */
185     error MintERC2309QuantityExceedsLimit();
186 
187     /**
188      * The `extraData` cannot be set on an unintialized ownership slot.
189      */
190     error OwnershipNotInitializedForExtraData();
191 
192     // =============================================================
193     //                            STRUCTS
194     // =============================================================
195 
196     struct TokenOwnership {
197         // The address of the owner.
198         address addr;
199         // Stores the start time of ownership with minimal overhead for tokenomics.
200         uint64 startTimestamp;
201         // Whether the token has been burned.
202         bool burned;
203         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
204         uint24 extraData;
205     }
206 
207     // =============================================================
208     //                         TOKEN COUNTERS
209     // =============================================================
210 
211     /**
212      * @dev Returns the total number of tokens in existence.
213      * Burned tokens will reduce the count.
214      * To get the total number of tokens minted, please see {_totalMinted}.
215      */
216     function totalSupply() external view returns (uint256);
217 
218     // =============================================================
219     //                            IERC165
220     // =============================================================
221 
222     /**
223      * @dev Returns true if this contract implements the interface defined by
224      * `interfaceId`. See the corresponding
225      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
226      * to learn more about how these ids are created.
227      *
228      * This function call must use less than 30000 gas.
229      */
230     function supportsInterface(bytes4 interfaceId) external view returns (bool);
231 
232     // =============================================================
233     //                            IERC721
234     // =============================================================
235 
236     /**
237      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
238      */
239     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
240 
241     /**
242      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
243      */
244     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
245 
246     /**
247      * @dev Emitted when `owner` enables or disables
248      * (`approved`) `operator` to manage all of its assets.
249      */
250     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
251 
252     /**
253      * @dev Returns the number of tokens in `owner`'s account.
254      */
255     function balanceOf(address owner) external view returns (uint256 balance);
256 
257     /**
258      * @dev Returns the owner of the `tokenId` token.
259      *
260      * Requirements:
261      *
262      * - `tokenId` must exist.
263      */
264     function ownerOf(uint256 tokenId) external view returns (address owner);
265 
266     /**
267      * @dev Safely transfers `tokenId` token from `from` to `to`,
268      * checking first that contract recipients are aware of the ERC721 protocol
269      * to prevent tokens from being forever locked.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must exist and be owned by `from`.
276      * - If the caller is not `from`, it must be have been allowed to move
277      * this token by either {approve} or {setApprovalForAll}.
278      * - If `to` refers to a smart contract, it must implement
279      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
280      *
281      * Emits a {Transfer} event.
282      */
283     function safeTransferFrom(
284         address from,
285         address to,
286         uint256 tokenId,
287         bytes calldata data
288     ) external payable;
289 
290     /**
291      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
292      */
293     function safeTransferFrom(
294         address from,
295         address to,
296         uint256 tokenId
297     ) external payable;
298 
299     /**
300      * @dev Transfers `tokenId` from `from` to `to`.
301      *
302      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
303      * whenever possible.
304      *
305      * Requirements:
306      *
307      * - `from` cannot be the zero address.
308      * - `to` cannot be the zero address.
309      * - `tokenId` token must be owned by `from`.
310      * - If the caller is not `from`, it must be approved to move this token
311      * by either {approve} or {setApprovalForAll}.
312      *
313      * Emits a {Transfer} event.
314      */
315     function transferFrom(
316         address from,
317         address to,
318         uint256 tokenId
319     ) external payable;
320 
321     /**
322      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
323      * The approval is cleared when the token is transferred.
324      *
325      * Only a single account can be approved at a time, so approving the
326      * zero address clears previous approvals.
327      *
328      * Requirements:
329      *
330      * - The caller must own the token or be an approved operator.
331      * - `tokenId` must exist.
332      *
333      * Emits an {Approval} event.
334      */
335     function approve(address to, uint256 tokenId) external payable;
336 
337     /**
338      * @dev Approve or remove `operator` as an operator for the caller.
339      * Operators can call {transferFrom} or {safeTransferFrom}
340      * for any token owned by the caller.
341      *
342      * Requirements:
343      *
344      * - The `operator` cannot be the caller.
345      *
346      * Emits an {ApprovalForAll} event.
347      */
348     function setApprovalForAll(address operator, bool _approved) external;
349 
350     /**
351      * @dev Returns the account approved for `tokenId` token.
352      *
353      * Requirements:
354      *
355      * - `tokenId` must exist.
356      */
357     function getApproved(uint256 tokenId) external view returns (address operator);
358 
359     /**
360      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
361      *
362      * See {setApprovalForAll}.
363      */
364     function isApprovedForAll(address owner, address operator) external view returns (bool);
365 
366     // =============================================================
367     //                        IERC721Metadata
368     // =============================================================
369 
370     /**
371      * @dev Returns the token collection name.
372      */
373     function name() external view returns (string memory);
374 
375     /**
376      * @dev Returns the token collection symbol.
377      */
378     function symbol() external view returns (string memory);
379 
380     /**
381      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
382      */
383     function tokenURI(uint256 tokenId) external view returns (string memory);
384 
385     // =============================================================
386     //                           IERC2309
387     // =============================================================
388 
389     /**
390      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
391      * (inclusive) is transferred from `from` to `to`, as defined in the
392      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
393      *
394      * See {_mintERC2309} for more details.
395      */
396     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
397 }
398 
399 
400 // File erc721a/contracts/ERC721A.sol@v4.2.3
401 
402 
403 // ERC721A Contracts v4.2.3
404 // Creator: Chiru Labs
405 
406 pragma solidity ^0.8.4;
407 
408 /**
409  * @dev Interface of ERC721 token receiver.
410  */
411 interface ERC721A__IERC721Receiver {
412     function onERC721Received(
413         address operator,
414         address from,
415         uint256 tokenId,
416         bytes calldata data
417     ) external returns (bytes4);
418 }
419 
420 /**
421  * @title ERC721A
422  *
423  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
424  * Non-Fungible Token Standard, including the Metadata extension.
425  * Optimized for lower gas during batch mints.
426  *
427  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
428  * starting from `_startTokenId()`.
429  *
430  * Assumptions:
431  *
432  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
433  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
434  */
435 contract ERC721A is IERC721A {
436     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
437     struct TokenApprovalRef {
438         address value;
439     }
440 
441     // =============================================================
442     //                           CONSTANTS
443     // =============================================================
444 
445     // Mask of an entry in packed address data.
446     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
447 
448     // The bit position of `numberMinted` in packed address data.
449     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
450 
451     // The bit position of `numberBurned` in packed address data.
452     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
453 
454     // The bit position of `aux` in packed address data.
455     uint256 private constant _BITPOS_AUX = 192;
456 
457     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
458     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
459 
460     // The bit position of `startTimestamp` in packed ownership.
461     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
462 
463     // The bit mask of the `burned` bit in packed ownership.
464     uint256 private constant _BITMASK_BURNED = 1 << 224;
465 
466     // The bit position of the `nextInitialized` bit in packed ownership.
467     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
468 
469     // The bit mask of the `nextInitialized` bit in packed ownership.
470     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
471 
472     // The bit position of `extraData` in packed ownership.
473     uint256 private constant _BITPOS_EXTRA_DATA = 232;
474 
475     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
476     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
477 
478     // The mask of the lower 160 bits for addresses.
479     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
480 
481     // The maximum `quantity` that can be minted with {_mintERC2309}.
482     // This limit is to prevent overflows on the address data entries.
483     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
484     // is required to cause an overflow, which is unrealistic.
485     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
486 
487     // The `Transfer` event signature is given by:
488     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
489     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
490         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
491 
492     // =============================================================
493     //                            STORAGE
494     // =============================================================
495 
496     // The next token ID to be minted.
497     uint256 private _currentIndex;
498 
499     // The number of tokens burned.
500     uint256 private _burnCounter;
501 
502     // Token name
503     string private _name;
504 
505     // Token symbol
506     string private _symbol;
507 
508     // Mapping from token ID to ownership details
509     // An empty struct value does not necessarily mean the token is unowned.
510     // See {_packedOwnershipOf} implementation for details.
511     //
512     // Bits Layout:
513     // - [0..159]   `addr`
514     // - [160..223] `startTimestamp`
515     // - [224]      `burned`
516     // - [225]      `nextInitialized`
517     // - [232..255] `extraData`
518     mapping(uint256 => uint256) private _packedOwnerships;
519 
520     // Mapping owner address to address data.
521     //
522     // Bits Layout:
523     // - [0..63]    `balance`
524     // - [64..127]  `numberMinted`
525     // - [128..191] `numberBurned`
526     // - [192..255] `aux`
527     mapping(address => uint256) private _packedAddressData;
528 
529     // Mapping from token ID to approved address.
530     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
531 
532     // Mapping from owner to operator approvals
533     mapping(address => mapping(address => bool)) private _operatorApprovals;
534 
535     // =============================================================
536     //                          CONSTRUCTOR
537     // =============================================================
538 
539     constructor(string memory name_, string memory symbol_) {
540         _name = name_;
541         _symbol = symbol_;
542         _currentIndex = _startTokenId();
543     }
544 
545     // =============================================================
546     //                   TOKEN COUNTING OPERATIONS
547     // =============================================================
548 
549     /**
550      * @dev Returns the starting token ID.
551      * To change the starting token ID, please override this function.
552      */
553     function _startTokenId() internal view virtual returns (uint256) {
554         return 0;
555     }
556 
557     /**
558      * @dev Returns the next token ID to be minted.
559      */
560     function _nextTokenId() internal view virtual returns (uint256) {
561         return _currentIndex;
562     }
563 
564     /**
565      * @dev Returns the total number of tokens in existence.
566      * Burned tokens will reduce the count.
567      * To get the total number of tokens minted, please see {_totalMinted}.
568      */
569     function totalSupply() public view virtual override returns (uint256) {
570         // Counter underflow is impossible as _burnCounter cannot be incremented
571         // more than `_currentIndex - _startTokenId()` times.
572         unchecked {
573             return _currentIndex - _burnCounter - _startTokenId();
574         }
575     }
576 
577     /**
578      * @dev Returns the total amount of tokens minted in the contract.
579      */
580     function _totalMinted() internal view virtual returns (uint256) {
581         // Counter underflow is impossible as `_currentIndex` does not decrement,
582         // and it is initialized to `_startTokenId()`.
583         unchecked {
584             return _currentIndex - _startTokenId();
585         }
586     }
587 
588     /**
589      * @dev Returns the total number of tokens burned.
590      */
591     function _totalBurned() internal view virtual returns (uint256) {
592         return _burnCounter;
593     }
594 
595     // =============================================================
596     //                    ADDRESS DATA OPERATIONS
597     // =============================================================
598 
599     /**
600      * @dev Returns the number of tokens in `owner`'s account.
601      */
602     function balanceOf(address owner) public view virtual override returns (uint256) {
603         if (owner == address(0)) revert BalanceQueryForZeroAddress();
604         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
605     }
606 
607     /**
608      * Returns the number of tokens minted by `owner`.
609      */
610     function _numberMinted(address owner) internal view returns (uint256) {
611         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
612     }
613 
614     /**
615      * Returns the number of tokens burned by or on behalf of `owner`.
616      */
617     function _numberBurned(address owner) internal view returns (uint256) {
618         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
619     }
620 
621     /**
622      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
623      */
624     function _getAux(address owner) internal view returns (uint64) {
625         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
626     }
627 
628     /**
629      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
630      * If there are multiple variables, please pack them into a uint64.
631      */
632     function _setAux(address owner, uint64 aux) internal virtual {
633         uint256 packed = _packedAddressData[owner];
634         uint256 auxCasted;
635         // Cast `aux` with assembly to avoid redundant masking.
636         assembly {
637             auxCasted := aux
638         }
639         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
640         _packedAddressData[owner] = packed;
641     }
642 
643     // =============================================================
644     //                            IERC165
645     // =============================================================
646 
647     /**
648      * @dev Returns true if this contract implements the interface defined by
649      * `interfaceId`. See the corresponding
650      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
651      * to learn more about how these ids are created.
652      *
653      * This function call must use less than 30000 gas.
654      */
655     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
656         // The interface IDs are constants representing the first 4 bytes
657         // of the XOR of all function selectors in the interface.
658         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
659         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
660         return
661             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
662             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
663             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
664     }
665 
666     // =============================================================
667     //                        IERC721Metadata
668     // =============================================================
669 
670     /**
671      * @dev Returns the token collection name.
672      */
673     function name() public view virtual override returns (string memory) {
674         return _name;
675     }
676 
677     /**
678      * @dev Returns the token collection symbol.
679      */
680     function symbol() public view virtual override returns (string memory) {
681         return _symbol;
682     }
683 
684     /**
685      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
686      */
687     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
688         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
689 
690         string memory baseURI = _baseURI();
691         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
692     }
693 
694     /**
695      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
696      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
697      * by default, it can be overridden in child contracts.
698      */
699     function _baseURI() internal view virtual returns (string memory) {
700         return '';
701     }
702 
703     // =============================================================
704     //                     OWNERSHIPS OPERATIONS
705     // =============================================================
706 
707     /**
708      * @dev Returns the owner of the `tokenId` token.
709      *
710      * Requirements:
711      *
712      * - `tokenId` must exist.
713      */
714     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
715         return address(uint160(_packedOwnershipOf(tokenId)));
716     }
717 
718     /**
719      * @dev Gas spent here starts off proportional to the maximum mint batch size.
720      * It gradually moves to O(1) as tokens get transferred around over time.
721      */
722     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
723         return _unpackedOwnership(_packedOwnershipOf(tokenId));
724     }
725 
726     /**
727      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
728      */
729     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
730         return _unpackedOwnership(_packedOwnerships[index]);
731     }
732 
733     /**
734      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
735      */
736     function _initializeOwnershipAt(uint256 index) internal virtual {
737         if (_packedOwnerships[index] == 0) {
738             _packedOwnerships[index] = _packedOwnershipOf(index);
739         }
740     }
741 
742     /**
743      * Returns the packed ownership data of `tokenId`.
744      */
745     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
746         uint256 curr = tokenId;
747 
748         unchecked {
749             if (_startTokenId() <= curr)
750                 if (curr < _currentIndex) {
751                     uint256 packed = _packedOwnerships[curr];
752                     // If not burned.
753                     if (packed & _BITMASK_BURNED == 0) {
754                         // Invariant:
755                         // There will always be an initialized ownership slot
756                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
757                         // before an unintialized ownership slot
758                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
759                         // Hence, `curr` will not underflow.
760                         //
761                         // We can directly compare the packed value.
762                         // If the address is zero, packed will be zero.
763                         while (packed == 0) {
764                             packed = _packedOwnerships[--curr];
765                         }
766                         return packed;
767                     }
768                 }
769         }
770         revert OwnerQueryForNonexistentToken();
771     }
772 
773     /**
774      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
775      */
776     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
777         ownership.addr = address(uint160(packed));
778         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
779         ownership.burned = packed & _BITMASK_BURNED != 0;
780         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
781     }
782 
783     /**
784      * @dev Packs ownership data into a single uint256.
785      */
786     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
787         assembly {
788             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
789             owner := and(owner, _BITMASK_ADDRESS)
790             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
791             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
792         }
793     }
794 
795     /**
796      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
797      */
798     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
799         // For branchless setting of the `nextInitialized` flag.
800         assembly {
801             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
802             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
803         }
804     }
805 
806     // =============================================================
807     //                      APPROVAL OPERATIONS
808     // =============================================================
809 
810     /**
811      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
812      * The approval is cleared when the token is transferred.
813      *
814      * Only a single account can be approved at a time, so approving the
815      * zero address clears previous approvals.
816      *
817      * Requirements:
818      *
819      * - The caller must own the token or be an approved operator.
820      * - `tokenId` must exist.
821      *
822      * Emits an {Approval} event.
823      */
824     function approve(address to, uint256 tokenId) public payable virtual override {
825         address owner = ownerOf(tokenId);
826 
827         if (_msgSenderERC721A() != owner)
828             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
829                 revert ApprovalCallerNotOwnerNorApproved();
830             }
831 
832         _tokenApprovals[tokenId].value = to;
833         emit Approval(owner, to, tokenId);
834     }
835 
836     /**
837      * @dev Returns the account approved for `tokenId` token.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      */
843     function getApproved(uint256 tokenId) public view virtual override returns (address) {
844         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
845 
846         return _tokenApprovals[tokenId].value;
847     }
848 
849     /**
850      * @dev Approve or remove `operator` as an operator for the caller.
851      * Operators can call {transferFrom} or {safeTransferFrom}
852      * for any token owned by the caller.
853      *
854      * Requirements:
855      *
856      * - The `operator` cannot be the caller.
857      *
858      * Emits an {ApprovalForAll} event.
859      */
860     function setApprovalForAll(address operator, bool approved) public virtual override {
861         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
862         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
863     }
864 
865     /**
866      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
867      *
868      * See {setApprovalForAll}.
869      */
870     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
871         return _operatorApprovals[owner][operator];
872     }
873 
874     /**
875      * @dev Returns whether `tokenId` exists.
876      *
877      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
878      *
879      * Tokens start existing when they are minted. See {_mint}.
880      */
881     function _exists(uint256 tokenId) internal view virtual returns (bool) {
882         return
883             _startTokenId() <= tokenId &&
884             tokenId < _currentIndex && // If within bounds,
885             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
886     }
887 
888     /**
889      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
890      */
891     function _isSenderApprovedOrOwner(
892         address approvedAddress,
893         address owner,
894         address msgSender
895     ) private pure returns (bool result) {
896         assembly {
897             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
898             owner := and(owner, _BITMASK_ADDRESS)
899             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
900             msgSender := and(msgSender, _BITMASK_ADDRESS)
901             // `msgSender == owner || msgSender == approvedAddress`.
902             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
903         }
904     }
905 
906     /**
907      * @dev Returns the storage slot and value for the approved address of `tokenId`.
908      */
909     function _getApprovedSlotAndAddress(uint256 tokenId)
910         private
911         view
912         returns (uint256 approvedAddressSlot, address approvedAddress)
913     {
914         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
915         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
916         assembly {
917             approvedAddressSlot := tokenApproval.slot
918             approvedAddress := sload(approvedAddressSlot)
919         }
920     }
921 
922     // =============================================================
923     //                      TRANSFER OPERATIONS
924     // =============================================================
925 
926     /**
927      * @dev Transfers `tokenId` from `from` to `to`.
928      *
929      * Requirements:
930      *
931      * - `from` cannot be the zero address.
932      * - `to` cannot be the zero address.
933      * - `tokenId` token must be owned by `from`.
934      * - If the caller is not `from`, it must be approved to move this token
935      * by either {approve} or {setApprovalForAll}.
936      *
937      * Emits a {Transfer} event.
938      */
939     function transferFrom(
940         address from,
941         address to,
942         uint256 tokenId
943     ) public payable virtual override {
944         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
945 
946         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
947 
948         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
949 
950         // The nested ifs save around 20+ gas over a compound boolean condition.
951         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
952             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
953 
954         if (to == address(0)) revert TransferToZeroAddress();
955 
956         _beforeTokenTransfers(from, to, tokenId, 1);
957 
958         // Clear approvals from the previous owner.
959         assembly {
960             if approvedAddress {
961                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
962                 sstore(approvedAddressSlot, 0)
963             }
964         }
965 
966         // Underflow of the sender's balance is impossible because we check for
967         // ownership above and the recipient's balance can't realistically overflow.
968         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
969         unchecked {
970             // We can directly increment and decrement the balances.
971             --_packedAddressData[from]; // Updates: `balance -= 1`.
972             ++_packedAddressData[to]; // Updates: `balance += 1`.
973 
974             // Updates:
975             // - `address` to the next owner.
976             // - `startTimestamp` to the timestamp of transfering.
977             // - `burned` to `false`.
978             // - `nextInitialized` to `true`.
979             _packedOwnerships[tokenId] = _packOwnershipData(
980                 to,
981                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
982             );
983 
984             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
985             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
986                 uint256 nextTokenId = tokenId + 1;
987                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
988                 if (_packedOwnerships[nextTokenId] == 0) {
989                     // If the next slot is within bounds.
990                     if (nextTokenId != _currentIndex) {
991                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
992                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
993                     }
994                 }
995             }
996         }
997 
998         emit Transfer(from, to, tokenId);
999         _afterTokenTransfers(from, to, tokenId, 1);
1000     }
1001 
1002     /**
1003      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public payable virtual override {
1010         safeTransferFrom(from, to, tokenId, '');
1011     }
1012 
1013     /**
1014      * @dev Safely transfers `tokenId` token from `from` to `to`.
1015      *
1016      * Requirements:
1017      *
1018      * - `from` cannot be the zero address.
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must exist and be owned by `from`.
1021      * - If the caller is not `from`, it must be approved to move this token
1022      * by either {approve} or {setApprovalForAll}.
1023      * - If `to` refers to a smart contract, it must implement
1024      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId,
1032         bytes memory _data
1033     ) public payable virtual override {
1034         transferFrom(from, to, tokenId);
1035         if (to.code.length != 0)
1036             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1037                 revert TransferToNonERC721ReceiverImplementer();
1038             }
1039     }
1040 
1041     /**
1042      * @dev Hook that is called before a set of serially-ordered token IDs
1043      * are about to be transferred. This includes minting.
1044      * And also called before burning one token.
1045      *
1046      * `startTokenId` - the first token ID to be transferred.
1047      * `quantity` - the amount to be transferred.
1048      *
1049      * Calling conditions:
1050      *
1051      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1052      * transferred to `to`.
1053      * - When `from` is zero, `tokenId` will be minted for `to`.
1054      * - When `to` is zero, `tokenId` will be burned by `from`.
1055      * - `from` and `to` are never both zero.
1056      */
1057     function _beforeTokenTransfers(
1058         address from,
1059         address to,
1060         uint256 startTokenId,
1061         uint256 quantity
1062     ) internal virtual {}
1063 
1064     /**
1065      * @dev Hook that is called after a set of serially-ordered token IDs
1066      * have been transferred. This includes minting.
1067      * And also called after one token has been burned.
1068      *
1069      * `startTokenId` - the first token ID to be transferred.
1070      * `quantity` - the amount to be transferred.
1071      *
1072      * Calling conditions:
1073      *
1074      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1075      * transferred to `to`.
1076      * - When `from` is zero, `tokenId` has been minted for `to`.
1077      * - When `to` is zero, `tokenId` has been burned by `from`.
1078      * - `from` and `to` are never both zero.
1079      */
1080     function _afterTokenTransfers(
1081         address from,
1082         address to,
1083         uint256 startTokenId,
1084         uint256 quantity
1085     ) internal virtual {}
1086 
1087     /**
1088      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1089      *
1090      * `from` - Previous owner of the given token ID.
1091      * `to` - Target address that will receive the token.
1092      * `tokenId` - Token ID to be transferred.
1093      * `_data` - Optional data to send along with the call.
1094      *
1095      * Returns whether the call correctly returned the expected magic value.
1096      */
1097     function _checkContractOnERC721Received(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) private returns (bool) {
1103         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1104             bytes4 retval
1105         ) {
1106             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1107         } catch (bytes memory reason) {
1108             if (reason.length == 0) {
1109                 revert TransferToNonERC721ReceiverImplementer();
1110             } else {
1111                 assembly {
1112                     revert(add(32, reason), mload(reason))
1113                 }
1114             }
1115         }
1116     }
1117 
1118     // =============================================================
1119     //                        MINT OPERATIONS
1120     // =============================================================
1121 
1122     /**
1123      * @dev Mints `quantity` tokens and transfers them to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `to` cannot be the zero address.
1128      * - `quantity` must be greater than 0.
1129      *
1130      * Emits a {Transfer} event for each mint.
1131      */
1132     function _mint(address to, uint256 quantity) internal virtual {
1133         uint256 startTokenId = _currentIndex;
1134         if (quantity == 0) revert MintZeroQuantity();
1135 
1136         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1137 
1138         // Overflows are incredibly unrealistic.
1139         // `balance` and `numberMinted` have a maximum limit of 2**64.
1140         // `tokenId` has a maximum limit of 2**256.
1141         unchecked {
1142             // Updates:
1143             // - `balance += quantity`.
1144             // - `numberMinted += quantity`.
1145             //
1146             // We can directly add to the `balance` and `numberMinted`.
1147             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1148 
1149             // Updates:
1150             // - `address` to the owner.
1151             // - `startTimestamp` to the timestamp of minting.
1152             // - `burned` to `false`.
1153             // - `nextInitialized` to `quantity == 1`.
1154             _packedOwnerships[startTokenId] = _packOwnershipData(
1155                 to,
1156                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1157             );
1158 
1159             uint256 toMasked;
1160             uint256 end = startTokenId + quantity;
1161 
1162             // Use assembly to loop and emit the `Transfer` event for gas savings.
1163             // The duplicated `log4` removes an extra check and reduces stack juggling.
1164             // The assembly, together with the surrounding Solidity code, have been
1165             // delicately arranged to nudge the compiler into producing optimized opcodes.
1166             assembly {
1167                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1168                 toMasked := and(to, _BITMASK_ADDRESS)
1169                 // Emit the `Transfer` event.
1170                 log4(
1171                     0, // Start of data (0, since no data).
1172                     0, // End of data (0, since no data).
1173                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1174                     0, // `address(0)`.
1175                     toMasked, // `to`.
1176                     startTokenId // `tokenId`.
1177                 )
1178 
1179                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1180                 // that overflows uint256 will make the loop run out of gas.
1181                 // The compiler will optimize the `iszero` away for performance.
1182                 for {
1183                     let tokenId := add(startTokenId, 1)
1184                 } iszero(eq(tokenId, end)) {
1185                     tokenId := add(tokenId, 1)
1186                 } {
1187                     // Emit the `Transfer` event. Similar to above.
1188                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1189                 }
1190             }
1191             if (toMasked == 0) revert MintToZeroAddress();
1192 
1193             _currentIndex = end;
1194         }
1195         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1196     }
1197 
1198     /**
1199      * @dev Mints `quantity` tokens and transfers them to `to`.
1200      *
1201      * This function is intended for efficient minting only during contract creation.
1202      *
1203      * It emits only one {ConsecutiveTransfer} as defined in
1204      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1205      * instead of a sequence of {Transfer} event(s).
1206      *
1207      * Calling this function outside of contract creation WILL make your contract
1208      * non-compliant with the ERC721 standard.
1209      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1210      * {ConsecutiveTransfer} event is only permissible during contract creation.
1211      *
1212      * Requirements:
1213      *
1214      * - `to` cannot be the zero address.
1215      * - `quantity` must be greater than 0.
1216      *
1217      * Emits a {ConsecutiveTransfer} event.
1218      */
1219     function _mintERC2309(address to, uint256 quantity) internal virtual {
1220         uint256 startTokenId = _currentIndex;
1221         if (to == address(0)) revert MintToZeroAddress();
1222         if (quantity == 0) revert MintZeroQuantity();
1223         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1224 
1225         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1226 
1227         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1228         unchecked {
1229             // Updates:
1230             // - `balance += quantity`.
1231             // - `numberMinted += quantity`.
1232             //
1233             // We can directly add to the `balance` and `numberMinted`.
1234             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1235 
1236             // Updates:
1237             // - `address` to the owner.
1238             // - `startTimestamp` to the timestamp of minting.
1239             // - `burned` to `false`.
1240             // - `nextInitialized` to `quantity == 1`.
1241             _packedOwnerships[startTokenId] = _packOwnershipData(
1242                 to,
1243                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1244             );
1245 
1246             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1247 
1248             _currentIndex = startTokenId + quantity;
1249         }
1250         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1251     }
1252 
1253     /**
1254      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1255      *
1256      * Requirements:
1257      *
1258      * - If `to` refers to a smart contract, it must implement
1259      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1260      * - `quantity` must be greater than 0.
1261      *
1262      * See {_mint}.
1263      *
1264      * Emits a {Transfer} event for each mint.
1265      */
1266     function _safeMint(
1267         address to,
1268         uint256 quantity,
1269         bytes memory _data
1270     ) internal virtual {
1271         _mint(to, quantity);
1272 
1273         unchecked {
1274             if (to.code.length != 0) {
1275                 uint256 end = _currentIndex;
1276                 uint256 index = end - quantity;
1277                 do {
1278                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1279                         revert TransferToNonERC721ReceiverImplementer();
1280                     }
1281                 } while (index < end);
1282                 // Reentrancy protection.
1283                 if (_currentIndex != end) revert();
1284             }
1285         }
1286     }
1287 
1288     /**
1289      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1290      */
1291     function _safeMint(address to, uint256 quantity) internal virtual {
1292         _safeMint(to, quantity, '');
1293     }
1294 
1295     // =============================================================
1296     //                        BURN OPERATIONS
1297     // =============================================================
1298 
1299     /**
1300      * @dev Equivalent to `_burn(tokenId, false)`.
1301      */
1302     function _burn(uint256 tokenId) internal virtual {
1303         _burn(tokenId, false);
1304     }
1305 
1306     /**
1307      * @dev Destroys `tokenId`.
1308      * The approval is cleared when the token is burned.
1309      *
1310      * Requirements:
1311      *
1312      * - `tokenId` must exist.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1317         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1318 
1319         address from = address(uint160(prevOwnershipPacked));
1320 
1321         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1322 
1323         if (approvalCheck) {
1324             // The nested ifs save around 20+ gas over a compound boolean condition.
1325             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1326                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1327         }
1328 
1329         _beforeTokenTransfers(from, address(0), tokenId, 1);
1330 
1331         // Clear approvals from the previous owner.
1332         assembly {
1333             if approvedAddress {
1334                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1335                 sstore(approvedAddressSlot, 0)
1336             }
1337         }
1338 
1339         // Underflow of the sender's balance is impossible because we check for
1340         // ownership above and the recipient's balance can't realistically overflow.
1341         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1342         unchecked {
1343             // Updates:
1344             // - `balance -= 1`.
1345             // - `numberBurned += 1`.
1346             //
1347             // We can directly decrement the balance, and increment the number burned.
1348             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1349             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1350 
1351             // Updates:
1352             // - `address` to the last owner.
1353             // - `startTimestamp` to the timestamp of burning.
1354             // - `burned` to `true`.
1355             // - `nextInitialized` to `true`.
1356             _packedOwnerships[tokenId] = _packOwnershipData(
1357                 from,
1358                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1359             );
1360 
1361             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1362             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1363                 uint256 nextTokenId = tokenId + 1;
1364                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1365                 if (_packedOwnerships[nextTokenId] == 0) {
1366                     // If the next slot is within bounds.
1367                     if (nextTokenId != _currentIndex) {
1368                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1369                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1370                     }
1371                 }
1372             }
1373         }
1374 
1375         emit Transfer(from, address(0), tokenId);
1376         _afterTokenTransfers(from, address(0), tokenId, 1);
1377 
1378         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1379         unchecked {
1380             _burnCounter++;
1381         }
1382     }
1383 
1384     // =============================================================
1385     //                     EXTRA DATA OPERATIONS
1386     // =============================================================
1387 
1388     /**
1389      * @dev Directly sets the extra data for the ownership data `index`.
1390      */
1391     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1392         uint256 packed = _packedOwnerships[index];
1393         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1394         uint256 extraDataCasted;
1395         // Cast `extraData` with assembly to avoid redundant masking.
1396         assembly {
1397             extraDataCasted := extraData
1398         }
1399         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1400         _packedOwnerships[index] = packed;
1401     }
1402 
1403     /**
1404      * @dev Called during each token transfer to set the 24bit `extraData` field.
1405      * Intended to be overridden by the cosumer contract.
1406      *
1407      * `previousExtraData` - the value of `extraData` before transfer.
1408      *
1409      * Calling conditions:
1410      *
1411      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1412      * transferred to `to`.
1413      * - When `from` is zero, `tokenId` will be minted for `to`.
1414      * - When `to` is zero, `tokenId` will be burned by `from`.
1415      * - `from` and `to` are never both zero.
1416      */
1417     function _extraData(
1418         address from,
1419         address to,
1420         uint24 previousExtraData
1421     ) internal view virtual returns (uint24) {}
1422 
1423     /**
1424      * @dev Returns the next extra data for the packed ownership data.
1425      * The returned result is shifted into position.
1426      */
1427     function _nextExtraData(
1428         address from,
1429         address to,
1430         uint256 prevOwnershipPacked
1431     ) private view returns (uint256) {
1432         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1433         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1434     }
1435 
1436     // =============================================================
1437     //                       OTHER OPERATIONS
1438     // =============================================================
1439 
1440     /**
1441      * @dev Returns the message sender (defaults to `msg.sender`).
1442      *
1443      * If you are writing GSN compatible contracts, you need to override this function.
1444      */
1445     function _msgSenderERC721A() internal view virtual returns (address) {
1446         return msg.sender;
1447     }
1448 
1449     /**
1450      * @dev Converts a uint256 to its ASCII string decimal representation.
1451      */
1452     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1453         assembly {
1454             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1455             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1456             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1457             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1458             let m := add(mload(0x40), 0xa0)
1459             // Update the free memory pointer to allocate.
1460             mstore(0x40, m)
1461             // Assign the `str` to the end.
1462             str := sub(m, 0x20)
1463             // Zeroize the slot after the string.
1464             mstore(str, 0)
1465 
1466             // Cache the end of the memory to calculate the length later.
1467             let end := str
1468 
1469             // We write the string from rightmost digit to leftmost digit.
1470             // The following is essentially a do-while loop that also handles the zero case.
1471             // prettier-ignore
1472             for { let temp := value } 1 {} {
1473                 str := sub(str, 1)
1474                 // Write the character to the pointer.
1475                 // The ASCII index of the '0' character is 48.
1476                 mstore8(str, add(48, mod(temp, 10)))
1477                 // Keep dividing `temp` until zero.
1478                 temp := div(temp, 10)
1479                 // prettier-ignore
1480                 if iszero(temp) { break }
1481             }
1482 
1483             let length := sub(end, str)
1484             // Move the pointer 32 bytes leftwards to make room for the length.
1485             str := sub(str, 0x20)
1486             // Store the length.
1487             mstore(str, length)
1488         }
1489     }
1490 }
1491 
1492 
1493 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
1494 
1495 
1496 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1497 
1498 pragma solidity ^0.8.0;
1499 
1500 /**
1501  * @dev Provides information about the current execution context, including the
1502  * sender of the transaction and its data. While these are generally available
1503  * via msg.sender and msg.data, they should not be accessed in such a direct
1504  * manner, since when dealing with meta-transactions the account sending and
1505  * paying for execution may not be the actual sender (as far as an application
1506  * is concerned).
1507  *
1508  * This contract is only required for intermediate, library-like contracts.
1509  */
1510 abstract contract Context {
1511     function _msgSender() internal view virtual returns (address) {
1512         return msg.sender;
1513     }
1514 
1515     function _msgData() internal view virtual returns (bytes calldata) {
1516         return msg.data;
1517     }
1518 }
1519 
1520 
1521 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
1522 
1523 
1524 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1525 
1526 pragma solidity ^0.8.0;
1527 
1528 /**
1529  * @dev Contract module which provides a basic access control mechanism, where
1530  * there is an account (an owner) that can be granted exclusive access to
1531  * specific functions.
1532  *
1533  * By default, the owner account will be the one that deploys the contract. This
1534  * can later be changed with {transferOwnership}.
1535  *
1536  * This module is used through inheritance. It will make available the modifier
1537  * `onlyOwner`, which can be applied to your functions to restrict their use to
1538  * the owner.
1539  */
1540 abstract contract Ownable is Context {
1541     address private _owner;
1542 
1543     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1544 
1545     /**
1546      * @dev Initializes the contract setting the deployer as the initial owner.
1547      */
1548     constructor() {
1549         _transferOwnership(_msgSender());
1550     }
1551 
1552     /**
1553      * @dev Throws if called by any account other than the owner.
1554      */
1555     modifier onlyOwner() {
1556         _checkOwner();
1557         _;
1558     }
1559 
1560     /**
1561      * @dev Returns the address of the current owner.
1562      */
1563     function owner() public view virtual returns (address) {
1564         return _owner;
1565     }
1566 
1567     /**
1568      * @dev Throws if the sender is not the owner.
1569      */
1570     function _checkOwner() internal view virtual {
1571         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1572     }
1573 
1574     /**
1575      * @dev Leaves the contract without owner. It will not be possible to call
1576      * `onlyOwner` functions anymore. Can only be called by the current owner.
1577      *
1578      * NOTE: Renouncing ownership will leave the contract without an owner,
1579      * thereby removing any functionality that is only available to the owner.
1580      */
1581     function renounceOwnership() public virtual onlyOwner {
1582         _transferOwnership(address(0));
1583     }
1584 
1585     /**
1586      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1587      * Can only be called by the current owner.
1588      */
1589     function transferOwnership(address newOwner) public virtual onlyOwner {
1590         require(newOwner != address(0), "Ownable: new owner is the zero address");
1591         _transferOwnership(newOwner);
1592     }
1593 
1594     /**
1595      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1596      * Internal function without access restriction.
1597      */
1598     function _transferOwnership(address newOwner) internal virtual {
1599         address oldOwner = _owner;
1600         _owner = newOwner;
1601         emit OwnershipTransferred(oldOwner, newOwner);
1602     }
1603 }
1604 
1605 
1606 // File @openzeppelin/contracts/utils/Address.sol@v4.8.0
1607 
1608 
1609 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1610 
1611 pragma solidity ^0.8.1;
1612 
1613 /**
1614  * @dev Collection of functions related to the address type
1615  */
1616 library Address {
1617     /**
1618      * @dev Returns true if `account` is a contract.
1619      *
1620      * [IMPORTANT]
1621      * ====
1622      * It is unsafe to assume that an address for which this function returns
1623      * false is an externally-owned account (EOA) and not a contract.
1624      *
1625      * Among others, `isContract` will return false for the following
1626      * types of addresses:
1627      *
1628      *  - an externally-owned account
1629      *  - a contract in construction
1630      *  - an address where a contract will be created
1631      *  - an address where a contract lived, but was destroyed
1632      * ====
1633      *
1634      * [IMPORTANT]
1635      * ====
1636      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1637      *
1638      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1639      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1640      * constructor.
1641      * ====
1642      */
1643     function isContract(address account) internal view returns (bool) {
1644         // This method relies on extcodesize/address.code.length, which returns 0
1645         // for contracts in construction, since the code is only stored at the end
1646         // of the constructor execution.
1647 
1648         return account.code.length > 0;
1649     }
1650 
1651     /**
1652      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1653      * `recipient`, forwarding all available gas and reverting on errors.
1654      *
1655      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1656      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1657      * imposed by `transfer`, making them unable to receive funds via
1658      * `transfer`. {sendValue} removes this limitation.
1659      *
1660      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1661      *
1662      * IMPORTANT: because control is transferred to `recipient`, care must be
1663      * taken to not create reentrancy vulnerabilities. Consider using
1664      * {ReentrancyGuard} or the
1665      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1666      */
1667     function sendValue(address payable recipient, uint256 amount) internal {
1668         require(address(this).balance >= amount, "Address: insufficient balance");
1669 
1670         (bool success, ) = recipient.call{value: amount}("");
1671         require(success, "Address: unable to send value, recipient may have reverted");
1672     }
1673 
1674     /**
1675      * @dev Performs a Solidity function call using a low level `call`. A
1676      * plain `call` is an unsafe replacement for a function call: use this
1677      * function instead.
1678      *
1679      * If `target` reverts with a revert reason, it is bubbled up by this
1680      * function (like regular Solidity function calls).
1681      *
1682      * Returns the raw returned data. To convert to the expected return value,
1683      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1684      *
1685      * Requirements:
1686      *
1687      * - `target` must be a contract.
1688      * - calling `target` with `data` must not revert.
1689      *
1690      * _Available since v3.1._
1691      */
1692     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1693         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1694     }
1695 
1696     /**
1697      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1698      * `errorMessage` as a fallback revert reason when `target` reverts.
1699      *
1700      * _Available since v3.1._
1701      */
1702     function functionCall(
1703         address target,
1704         bytes memory data,
1705         string memory errorMessage
1706     ) internal returns (bytes memory) {
1707         return functionCallWithValue(target, data, 0, errorMessage);
1708     }
1709 
1710     /**
1711      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1712      * but also transferring `value` wei to `target`.
1713      *
1714      * Requirements:
1715      *
1716      * - the calling contract must have an ETH balance of at least `value`.
1717      * - the called Solidity function must be `payable`.
1718      *
1719      * _Available since v3.1._
1720      */
1721     function functionCallWithValue(
1722         address target,
1723         bytes memory data,
1724         uint256 value
1725     ) internal returns (bytes memory) {
1726         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1727     }
1728 
1729     /**
1730      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1731      * with `errorMessage` as a fallback revert reason when `target` reverts.
1732      *
1733      * _Available since v3.1._
1734      */
1735     function functionCallWithValue(
1736         address target,
1737         bytes memory data,
1738         uint256 value,
1739         string memory errorMessage
1740     ) internal returns (bytes memory) {
1741         require(address(this).balance >= value, "Address: insufficient balance for call");
1742         (bool success, bytes memory returndata) = target.call{value: value}(data);
1743         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1744     }
1745 
1746     /**
1747      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1748      * but performing a static call.
1749      *
1750      * _Available since v3.3._
1751      */
1752     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1753         return functionStaticCall(target, data, "Address: low-level static call failed");
1754     }
1755 
1756     /**
1757      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1758      * but performing a static call.
1759      *
1760      * _Available since v3.3._
1761      */
1762     function functionStaticCall(
1763         address target,
1764         bytes memory data,
1765         string memory errorMessage
1766     ) internal view returns (bytes memory) {
1767         (bool success, bytes memory returndata) = target.staticcall(data);
1768         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1769     }
1770 
1771     /**
1772      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1773      * but performing a delegate call.
1774      *
1775      * _Available since v3.4._
1776      */
1777     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1778         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1779     }
1780 
1781     /**
1782      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1783      * but performing a delegate call.
1784      *
1785      * _Available since v3.4._
1786      */
1787     function functionDelegateCall(
1788         address target,
1789         bytes memory data,
1790         string memory errorMessage
1791     ) internal returns (bytes memory) {
1792         (bool success, bytes memory returndata) = target.delegatecall(data);
1793         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1794     }
1795 
1796     /**
1797      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1798      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1799      *
1800      * _Available since v4.8._
1801      */
1802     function verifyCallResultFromTarget(
1803         address target,
1804         bool success,
1805         bytes memory returndata,
1806         string memory errorMessage
1807     ) internal view returns (bytes memory) {
1808         if (success) {
1809             if (returndata.length == 0) {
1810                 // only check isContract if the call was successful and the return data is empty
1811                 // otherwise we already know that it was a contract
1812                 require(isContract(target), "Address: call to non-contract");
1813             }
1814             return returndata;
1815         } else {
1816             _revert(returndata, errorMessage);
1817         }
1818     }
1819 
1820     /**
1821      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1822      * revert reason or using the provided one.
1823      *
1824      * _Available since v4.3._
1825      */
1826     function verifyCallResult(
1827         bool success,
1828         bytes memory returndata,
1829         string memory errorMessage
1830     ) internal pure returns (bytes memory) {
1831         if (success) {
1832             return returndata;
1833         } else {
1834             _revert(returndata, errorMessage);
1835         }
1836     }
1837 
1838     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1839         // Look for revert reason and bubble it up if present
1840         if (returndata.length > 0) {
1841             // The easiest way to bubble the revert reason is using memory via assembly
1842             /// @solidity memory-safe-assembly
1843             assembly {
1844                 let returndata_size := mload(returndata)
1845                 revert(add(32, returndata), returndata_size)
1846             }
1847         } else {
1848             revert(errorMessage);
1849         }
1850     }
1851 }
1852 
1853 
1854 // File contracts/NFT.sol
1855 
1856 
1857 pragma solidity ^0.8.13;
1858 
1859 
1860 
1861 
1862 contract NFT is ERC721A, DefaultOperatorFilterer, Ownable {
1863     using Address for address;
1864 
1865     string private _baseTokenURI;
1866     uint256 public maxSupply;
1867     uint256 public maxMint;
1868     uint256 public price;
1869     bool public mintable;
1870 
1871     mapping(address => uint256) public minted;
1872 
1873     constructor(
1874         string memory url,
1875         string memory name,
1876         string memory symbol,
1877         address _owner,
1878         uint256 _price
1879     ) ERC721A(name, symbol) {
1880         _baseTokenURI = url;
1881         maxSupply = 3000;
1882         maxMint = 11;
1883         price = _price;
1884         mintable = true;
1885         _transferOwnership(_owner);
1886     }
1887 
1888     function _baseURI() internal view override returns (string memory) {
1889         return _baseTokenURI;
1890     }
1891 
1892     function tokenURI(
1893         uint256 tokenId
1894     ) public view override returns (string memory) {
1895         require(
1896             _exists(tokenId),
1897             "ERC721Metadata: URI query for nonexistent token"
1898         );
1899         string memory baseURI = _baseURI();
1900         return string(abi.encodePacked(baseURI, _toString(tokenId), ".json"));
1901     }
1902 
1903     function changeBaseURI(string memory baseURI) public onlyOwner {
1904         _baseTokenURI = baseURI;
1905     }
1906 
1907     function changeMintable(bool _mintable) public onlyOwner {
1908         mintable = _mintable;
1909     }
1910 
1911     function changePrice(uint256 _price) public onlyOwner {
1912         price = _price;
1913     }
1914 
1915     function changeMaxMint(uint256 _maxMint) public onlyOwner {
1916         maxMint = _maxMint;
1917     }
1918 
1919     function mint(uint256 num) public payable {
1920         uint256 amount = num * price;
1921         if (minted[msg.sender] == 0) {
1922             amount -= price;
1923         }
1924         require(mintable, "status err");
1925         require(msg.value == amount, "eth err");
1926         require(minted[msg.sender] + num <= maxMint, "num err");
1927         minted[msg.sender] += num;
1928         require(totalSupply() + num <= maxSupply, "num err");
1929         _safeMint(msg.sender, num);
1930     }
1931 
1932     function setApprovalForAll(
1933         address operator,
1934         bool approved
1935     ) public override onlyAllowedOperatorApproval(operator) {
1936         super.setApprovalForAll(operator, approved);
1937     }
1938 
1939      function _startTokenId() internal view override returns (uint256) {
1940         return 1;
1941     }
1942 
1943     function approve(
1944         address operator,
1945         uint256 tokenId
1946     ) public payable override onlyAllowedOperatorApproval(operator) {
1947         super.approve(operator, tokenId);
1948     }
1949 
1950     function transferFrom(
1951         address from,
1952         address to,
1953         uint256 tokenId
1954     ) public payable override onlyAllowedOperator(from) {
1955         super.transferFrom(from, to, tokenId);
1956     }
1957 
1958     function safeTransferFrom(
1959         address from,
1960         address to,
1961         uint256 tokenId
1962     ) public payable override onlyAllowedOperator(from) {
1963         super.safeTransferFrom(from, to, tokenId);
1964     }
1965 
1966     function safeTransferFrom(
1967         address from,
1968         address to,
1969         uint256 tokenId,
1970         bytes memory data
1971     ) public payable override onlyAllowedOperator(from) {
1972         super.safeTransferFrom(from, to, tokenId, data);
1973     }
1974 
1975     function withdraw() external onlyOwner {
1976         payable(msg.sender).transfer(address(this).balance);
1977     }
1978 
1979     function airdrop(
1980         address[] memory users,
1981         uint256[] memory nums
1982     ) public onlyOwner {
1983         require(users.length == nums.length);
1984         for (uint i = 0; i < users.length; i++) {
1985             uint256 num = nums[i];
1986             address user = users[i];
1987             require(totalSupply() + num <= maxSupply, "num err");
1988             _safeMint(user, num);
1989         }
1990     }
1991 }