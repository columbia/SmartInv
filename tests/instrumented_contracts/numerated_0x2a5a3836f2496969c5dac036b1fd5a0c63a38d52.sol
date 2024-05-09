1 pragma solidity ^0.8.13;
2 
3 interface IOperatorFilterRegistry {
4     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
5     function register(address registrant) external;
6     function registerAndSubscribe(address registrant, address subscription) external;
7     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
8     function unregister(address addr) external;
9     function updateOperator(address registrant, address operator, bool filtered) external;
10     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
11     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
12     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
13     function subscribe(address registrant, address registrantToSubscribe) external;
14     function unsubscribe(address registrant, bool copyExistingEntries) external;
15     function subscriptionOf(address addr) external returns (address registrant);
16     function subscribers(address registrant) external returns (address[] memory);
17     function subscriberAt(address registrant, uint256 index) external returns (address);
18     function copyEntriesOf(address registrant, address registrantToCopy) external;
19     function isOperatorFiltered(address registrant, address operator) external returns (bool);
20     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
21     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
22     function filteredOperators(address addr) external returns (address[] memory);
23     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
24     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
25     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
26     function isRegistered(address addr) external returns (bool);
27     function codeHashOf(address addr) external returns (bytes32);
28 }
29 
30 
31 // File operator-filter-registry/src/OperatorFilterer.sol@v1.3.1
32 
33 
34 pragma solidity ^0.8.13;
35 
36 /**
37  * @title  OperatorFilterer
38  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
39  *         registrant's entries in the OperatorFilterRegistry.
40  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
41  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
42  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
43  */
44 abstract contract OperatorFilterer {
45     error OperatorNotAllowed(address operator);
46 
47     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
48         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
49 
50     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
51         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
52         // will not revert, but the contract will need to be registered with the registry once it is deployed in
53         // order for the modifier to filter addresses.
54         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
55             if (subscribe) {
56                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
57             } else {
58                 if (subscriptionOrRegistrantToCopy != address(0)) {
59                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
60                 } else {
61                     OPERATOR_FILTER_REGISTRY.register(address(this));
62                 }
63             }
64         }
65     }
66 
67     modifier onlyAllowedOperator(address from) virtual {
68         // Allow spending tokens from addresses with balance
69         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
70         // from an EOA.
71         if (from != msg.sender) {
72             _checkFilterOperator(msg.sender);
73         }
74         _;
75     }
76 
77     modifier onlyAllowedOperatorApproval(address operator) virtual {
78         _checkFilterOperator(operator);
79         _;
80     }
81 
82     function _checkFilterOperator(address operator) internal view virtual {
83         // Check registry code length to facilitate testing in environments without a deployed registry.
84         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
85             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
86                 revert OperatorNotAllowed(operator);
87             }
88         }
89     }
90 }
91 
92 
93 // File operator-filter-registry/src/DefaultOperatorFilterer.sol@v1.3.1
94 
95 
96 pragma solidity ^0.8.13;
97 
98 /**
99  * @title  DefaultOperatorFilterer
100  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
101  */
102 abstract contract DefaultOperatorFilterer is OperatorFilterer {
103     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
104 
105     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
106 }
107 
108 
109 // File erc721a/contracts/IERC721A.sol@v4.2.3
110 
111 
112 // ERC721A Contracts v4.2.3
113 // Creator: Chiru Labs
114 
115 pragma solidity ^0.8.4;
116 
117 /**
118  * @dev Interface of ERC721A.
119  */
120 interface IERC721A {
121     /**
122      * The caller must own the token or be an approved operator.
123      */
124     error ApprovalCallerNotOwnerNorApproved();
125 
126     /**
127      * The token does not exist.
128      */
129     error ApprovalQueryForNonexistentToken();
130 
131     /**
132      * Cannot query the balance for the zero address.
133      */
134     error BalanceQueryForZeroAddress();
135 
136     /**
137      * Cannot mint to the zero address.
138      */
139     error MintToZeroAddress();
140 
141     /**
142      * The quantity of tokens minted must be more than zero.
143      */
144     error MintZeroQuantity();
145 
146     /**
147      * The token does not exist.
148      */
149     error OwnerQueryForNonexistentToken();
150 
151     /**
152      * The caller must own the token or be an approved operator.
153      */
154     error TransferCallerNotOwnerNorApproved();
155 
156     /**
157      * The token must be owned by `from`.
158      */
159     error TransferFromIncorrectOwner();
160 
161     /**
162      * Cannot safely transfer to a contract that does not implement the
163      * ERC721Receiver interface.
164      */
165     error TransferToNonERC721ReceiverImplementer();
166 
167     /**
168      * Cannot transfer to the zero address.
169      */
170     error TransferToZeroAddress();
171 
172     /**
173      * The token does not exist.
174      */
175     error URIQueryForNonexistentToken();
176 
177     /**
178      * The `quantity` minted with ERC2309 exceeds the safety limit.
179      */
180     error MintERC2309QuantityExceedsLimit();
181 
182     /**
183      * The `extraData` cannot be set on an unintialized ownership slot.
184      */
185     error OwnershipNotInitializedForExtraData();
186 
187     // =============================================================
188     //                            STRUCTS
189     // =============================================================
190 
191     struct TokenOwnership {
192         // The address of the owner.
193         address addr;
194         // Stores the start time of ownership with minimal overhead for tokenomics.
195         uint64 startTimestamp;
196         // Whether the token has been burned.
197         bool burned;
198         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
199         uint24 extraData;
200     }
201 
202     // =============================================================
203     //                         TOKEN COUNTERS
204     // =============================================================
205 
206     /**
207      * @dev Returns the total number of tokens in existence.
208      * Burned tokens will reduce the count.
209      * To get the total number of tokens minted, please see {_totalMinted}.
210      */
211     function totalSupply() external view returns (uint256);
212 
213     // =============================================================
214     //                            IERC165
215     // =============================================================
216 
217     /**
218      * @dev Returns true if this contract implements the interface defined by
219      * `interfaceId`. See the corresponding
220      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
221      * to learn more about how these ids are created.
222      *
223      * This function call must use less than 30000 gas.
224      */
225     function supportsInterface(bytes4 interfaceId) external view returns (bool);
226 
227     // =============================================================
228     //                            IERC721
229     // =============================================================
230 
231     /**
232      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
235 
236     /**
237      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
238      */
239     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
240 
241     /**
242      * @dev Emitted when `owner` enables or disables
243      * (`approved`) `operator` to manage all of its assets.
244      */
245     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
246 
247     /**
248      * @dev Returns the number of tokens in `owner`'s account.
249      */
250     function balanceOf(address owner) external view returns (uint256 balance);
251 
252     /**
253      * @dev Returns the owner of the `tokenId` token.
254      *
255      * Requirements:
256      *
257      * - `tokenId` must exist.
258      */
259     function ownerOf(uint256 tokenId) external view returns (address owner);
260 
261     /**
262      * @dev Safely transfers `tokenId` token from `from` to `to`,
263      * checking first that contract recipients are aware of the ERC721 protocol
264      * to prevent tokens from being forever locked.
265      *
266      * Requirements:
267      *
268      * - `from` cannot be the zero address.
269      * - `to` cannot be the zero address.
270      * - `tokenId` token must exist and be owned by `from`.
271      * - If the caller is not `from`, it must be have been allowed to move
272      * this token by either {approve} or {setApprovalForAll}.
273      * - If `to` refers to a smart contract, it must implement
274      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
275      *
276      * Emits a {Transfer} event.
277      */
278     function safeTransferFrom(
279         address from,
280         address to,
281         uint256 tokenId,
282         bytes calldata data
283     ) external payable;
284 
285     /**
286      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
287      */
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId
292     ) external payable;
293 
294     /**
295      * @dev Transfers `tokenId` from `from` to `to`.
296      *
297      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
298      * whenever possible.
299      *
300      * Requirements:
301      *
302      * - `from` cannot be the zero address.
303      * - `to` cannot be the zero address.
304      * - `tokenId` token must be owned by `from`.
305      * - If the caller is not `from`, it must be approved to move this token
306      * by either {approve} or {setApprovalForAll}.
307      *
308      * Emits a {Transfer} event.
309      */
310     function transferFrom(
311         address from,
312         address to,
313         uint256 tokenId
314     ) external payable;
315 
316     /**
317      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
318      * The approval is cleared when the token is transferred.
319      *
320      * Only a single account can be approved at a time, so approving the
321      * zero address clears previous approvals.
322      *
323      * Requirements:
324      *
325      * - The caller must own the token or be an approved operator.
326      * - `tokenId` must exist.
327      *
328      * Emits an {Approval} event.
329      */
330     function approve(address to, uint256 tokenId) external payable;
331 
332     /**
333      * @dev Approve or remove `operator` as an operator for the caller.
334      * Operators can call {transferFrom} or {safeTransferFrom}
335      * for any token owned by the caller.
336      *
337      * Requirements:
338      *
339      * - The `operator` cannot be the caller.
340      *
341      * Emits an {ApprovalForAll} event.
342      */
343     function setApprovalForAll(address operator, bool _approved) external;
344 
345     /**
346      * @dev Returns the account approved for `tokenId` token.
347      *
348      * Requirements:
349      *
350      * - `tokenId` must exist.
351      */
352     function getApproved(uint256 tokenId) external view returns (address operator);
353 
354     /**
355      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
356      *
357      * See {setApprovalForAll}.
358      */
359     function isApprovedForAll(address owner, address operator) external view returns (bool);
360 
361     // =============================================================
362     //                        IERC721Metadata
363     // =============================================================
364 
365     /**
366      * @dev Returns the token collection name.
367      */
368     function name() external view returns (string memory);
369 
370     /**
371      * @dev Returns the token collection symbol.
372      */
373     function symbol() external view returns (string memory);
374 
375     /**
376      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
377      */
378     function tokenURI(uint256 tokenId) external view returns (string memory);
379 
380     // =============================================================
381     //                           IERC2309
382     // =============================================================
383 
384     /**
385      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
386      * (inclusive) is transferred from `from` to `to`, as defined in the
387      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
388      *
389      * See {_mintERC2309} for more details.
390      */
391     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
392 }
393 
394 
395 // File erc721a/contracts/ERC721A.sol@v4.2.3
396 
397 
398 // ERC721A Contracts v4.2.3
399 // Creator: Chiru Labs
400 
401 pragma solidity ^0.8.4;
402 
403 /**
404  * @dev Interface of ERC721 token receiver.
405  */
406 interface ERC721A__IERC721Receiver {
407     function onERC721Received(
408         address operator,
409         address from,
410         uint256 tokenId,
411         bytes calldata data
412     ) external returns (bytes4);
413 }
414 
415 /**
416  * @title ERC721A
417  *
418  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
419  * Non-Fungible Token Standard, including the Metadata extension.
420  * Optimized for lower gas during batch mints.
421  *
422  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
423  * starting from `_startTokenId()`.
424  *
425  * Assumptions:
426  *
427  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
428  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
429  */
430 contract ERC721A is IERC721A {
431     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
432     struct TokenApprovalRef {
433         address value;
434     }
435 
436     // =============================================================
437     //                           CONSTANTS
438     // =============================================================
439 
440     // Mask of an entry in packed address data.
441     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
442 
443     // The bit position of `numberMinted` in packed address data.
444     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
445 
446     // The bit position of `numberBurned` in packed address data.
447     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
448 
449     // The bit position of `aux` in packed address data.
450     uint256 private constant _BITPOS_AUX = 192;
451 
452     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
453     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
454 
455     // The bit position of `startTimestamp` in packed ownership.
456     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
457 
458     // The bit mask of the `burned` bit in packed ownership.
459     uint256 private constant _BITMASK_BURNED = 1 << 224;
460 
461     // The bit position of the `nextInitialized` bit in packed ownership.
462     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
463 
464     // The bit mask of the `nextInitialized` bit in packed ownership.
465     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
466 
467     // The bit position of `extraData` in packed ownership.
468     uint256 private constant _BITPOS_EXTRA_DATA = 232;
469 
470     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
471     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
472 
473     // The mask of the lower 160 bits for addresses.
474     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
475 
476     // The maximum `quantity` that can be minted with {_mintERC2309}.
477     // This limit is to prevent overflows on the address data entries.
478     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
479     // is required to cause an overflow, which is unrealistic.
480     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
481 
482     // The `Transfer` event signature is given by:
483     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
484     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
485         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
486 
487     // =============================================================
488     //                            STORAGE
489     // =============================================================
490 
491     // The next token ID to be minted.
492     uint256 private _currentIndex;
493 
494     // The number of tokens burned.
495     uint256 private _burnCounter;
496 
497     // Token name
498     string private _name;
499 
500     // Token symbol
501     string private _symbol;
502 
503     // Mapping from token ID to ownership details
504     // An empty struct value does not necessarily mean the token is unowned.
505     // See {_packedOwnershipOf} implementation for details.
506     //
507     // Bits Layout:
508     // - [0..159]   `addr`
509     // - [160..223] `startTimestamp`
510     // - [224]      `burned`
511     // - [225]      `nextInitialized`
512     // - [232..255] `extraData`
513     mapping(uint256 => uint256) private _packedOwnerships;
514 
515     // Mapping owner address to address data.
516     //
517     // Bits Layout:
518     // - [0..63]    `balance`
519     // - [64..127]  `numberMinted`
520     // - [128..191] `numberBurned`
521     // - [192..255] `aux`
522     mapping(address => uint256) private _packedAddressData;
523 
524     // Mapping from token ID to approved address.
525     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
526 
527     // Mapping from owner to operator approvals
528     mapping(address => mapping(address => bool)) private _operatorApprovals;
529 
530     // =============================================================
531     //                          CONSTRUCTOR
532     // =============================================================
533 
534     constructor(string memory name_, string memory symbol_) {
535         _name = name_;
536         _symbol = symbol_;
537         _currentIndex = _startTokenId();
538     }
539 
540     // =============================================================
541     //                   TOKEN COUNTING OPERATIONS
542     // =============================================================
543 
544     /**
545      * @dev Returns the starting token ID.
546      * To change the starting token ID, please override this function.
547      */
548     function _startTokenId() internal view virtual returns (uint256) {
549         return 0;
550     }
551 
552     /**
553      * @dev Returns the next token ID to be minted.
554      */
555     function _nextTokenId() internal view virtual returns (uint256) {
556         return _currentIndex;
557     }
558 
559     /**
560      * @dev Returns the total number of tokens in existence.
561      * Burned tokens will reduce the count.
562      * To get the total number of tokens minted, please see {_totalMinted}.
563      */
564     function totalSupply() public view virtual override returns (uint256) {
565         // Counter underflow is impossible as _burnCounter cannot be incremented
566         // more than `_currentIndex - _startTokenId()` times.
567         unchecked {
568             return _currentIndex - _burnCounter - _startTokenId();
569         }
570     }
571 
572     /**
573      * @dev Returns the total amount of tokens minted in the contract.
574      */
575     function _totalMinted() internal view virtual returns (uint256) {
576         // Counter underflow is impossible as `_currentIndex` does not decrement,
577         // and it is initialized to `_startTokenId()`.
578         unchecked {
579             return _currentIndex - _startTokenId();
580         }
581     }
582 
583     /**
584      * @dev Returns the total number of tokens burned.
585      */
586     function _totalBurned() internal view virtual returns (uint256) {
587         return _burnCounter;
588     }
589 
590     // =============================================================
591     //                    ADDRESS DATA OPERATIONS
592     // =============================================================
593 
594     /**
595      * @dev Returns the number of tokens in `owner`'s account.
596      */
597     function balanceOf(address owner) public view virtual override returns (uint256) {
598         if (owner == address(0)) revert BalanceQueryForZeroAddress();
599         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
600     }
601 
602     /**
603      * Returns the number of tokens minted by `owner`.
604      */
605     function _numberMinted(address owner) internal view returns (uint256) {
606         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
607     }
608 
609     /**
610      * Returns the number of tokens burned by or on behalf of `owner`.
611      */
612     function _numberBurned(address owner) internal view returns (uint256) {
613         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
614     }
615 
616     /**
617      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
618      */
619     function _getAux(address owner) internal view returns (uint64) {
620         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
621     }
622 
623     /**
624      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
625      * If there are multiple variables, please pack them into a uint64.
626      */
627     function _setAux(address owner, uint64 aux) internal virtual {
628         uint256 packed = _packedAddressData[owner];
629         uint256 auxCasted;
630         // Cast `aux` with assembly to avoid redundant masking.
631         assembly {
632             auxCasted := aux
633         }
634         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
635         _packedAddressData[owner] = packed;
636     }
637 
638     // =============================================================
639     //                            IERC165
640     // =============================================================
641 
642     /**
643      * @dev Returns true if this contract implements the interface defined by
644      * `interfaceId`. See the corresponding
645      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
646      * to learn more about how these ids are created.
647      *
648      * This function call must use less than 30000 gas.
649      */
650     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
651         // The interface IDs are constants representing the first 4 bytes
652         // of the XOR of all function selectors in the interface.
653         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
654         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
655         return
656             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
657             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
658             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
659     }
660 
661     // =============================================================
662     //                        IERC721Metadata
663     // =============================================================
664 
665     /**
666      * @dev Returns the token collection name.
667      */
668     function name() public view virtual override returns (string memory) {
669         return _name;
670     }
671 
672     /**
673      * @dev Returns the token collection symbol.
674      */
675     function symbol() public view virtual override returns (string memory) {
676         return _symbol;
677     }
678 
679     /**
680      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
681      */
682     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
683         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
684 
685         string memory baseURI = _baseURI();
686         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
687     }
688 
689     /**
690      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
691      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
692      * by default, it can be overridden in child contracts.
693      */
694     function _baseURI() internal view virtual returns (string memory) {
695         return '';
696     }
697 
698     // =============================================================
699     //                     OWNERSHIPS OPERATIONS
700     // =============================================================
701 
702     /**
703      * @dev Returns the owner of the `tokenId` token.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must exist.
708      */
709     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
710         return address(uint160(_packedOwnershipOf(tokenId)));
711     }
712 
713     /**
714      * @dev Gas spent here starts off proportional to the maximum mint batch size.
715      * It gradually moves to O(1) as tokens get transferred around over time.
716      */
717     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
718         return _unpackedOwnership(_packedOwnershipOf(tokenId));
719     }
720 
721     /**
722      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
723      */
724     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
725         return _unpackedOwnership(_packedOwnerships[index]);
726     }
727 
728     /**
729      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
730      */
731     function _initializeOwnershipAt(uint256 index) internal virtual {
732         if (_packedOwnerships[index] == 0) {
733             _packedOwnerships[index] = _packedOwnershipOf(index);
734         }
735     }
736 
737     /**
738      * Returns the packed ownership data of `tokenId`.
739      */
740     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
741         uint256 curr = tokenId;
742 
743         unchecked {
744             if (_startTokenId() <= curr)
745                 if (curr < _currentIndex) {
746                     uint256 packed = _packedOwnerships[curr];
747                     // If not burned.
748                     if (packed & _BITMASK_BURNED == 0) {
749                         // Invariant:
750                         // There will always be an initialized ownership slot
751                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
752                         // before an unintialized ownership slot
753                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
754                         // Hence, `curr` will not underflow.
755                         //
756                         // We can directly compare the packed value.
757                         // If the address is zero, packed will be zero.
758                         while (packed == 0) {
759                             packed = _packedOwnerships[--curr];
760                         }
761                         return packed;
762                     }
763                 }
764         }
765         revert OwnerQueryForNonexistentToken();
766     }
767 
768     /**
769      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
770      */
771     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
772         ownership.addr = address(uint160(packed));
773         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
774         ownership.burned = packed & _BITMASK_BURNED != 0;
775         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
776     }
777 
778     /**
779      * @dev Packs ownership data into a single uint256.
780      */
781     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
782         assembly {
783             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
784             owner := and(owner, _BITMASK_ADDRESS)
785             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
786             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
787         }
788     }
789 
790     /**
791      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
792      */
793     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
794         // For branchless setting of the `nextInitialized` flag.
795         assembly {
796             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
797             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
798         }
799     }
800 
801     // =============================================================
802     //                      APPROVAL OPERATIONS
803     // =============================================================
804 
805     /**
806      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
807      * The approval is cleared when the token is transferred.
808      *
809      * Only a single account can be approved at a time, so approving the
810      * zero address clears previous approvals.
811      *
812      * Requirements:
813      *
814      * - The caller must own the token or be an approved operator.
815      * - `tokenId` must exist.
816      *
817      * Emits an {Approval} event.
818      */
819     function approve(address to, uint256 tokenId) public payable virtual override {
820         address owner = ownerOf(tokenId);
821 
822         if (_msgSenderERC721A() != owner)
823             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
824                 revert ApprovalCallerNotOwnerNorApproved();
825             }
826 
827         _tokenApprovals[tokenId].value = to;
828         emit Approval(owner, to, tokenId);
829     }
830 
831     /**
832      * @dev Returns the account approved for `tokenId` token.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must exist.
837      */
838     function getApproved(uint256 tokenId) public view virtual override returns (address) {
839         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
840 
841         return _tokenApprovals[tokenId].value;
842     }
843 
844     /**
845      * @dev Approve or remove `operator` as an operator for the caller.
846      * Operators can call {transferFrom} or {safeTransferFrom}
847      * for any token owned by the caller.
848      *
849      * Requirements:
850      *
851      * - The `operator` cannot be the caller.
852      *
853      * Emits an {ApprovalForAll} event.
854      */
855     function setApprovalForAll(address operator, bool approved) public virtual override {
856         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
857         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
858     }
859 
860     /**
861      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
862      *
863      * See {setApprovalForAll}.
864      */
865     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
866         return _operatorApprovals[owner][operator];
867     }
868 
869     /**
870      * @dev Returns whether `tokenId` exists.
871      *
872      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
873      *
874      * Tokens start existing when they are minted. See {_mint}.
875      */
876     function _exists(uint256 tokenId) internal view virtual returns (bool) {
877         return
878             _startTokenId() <= tokenId &&
879             tokenId < _currentIndex && // If within bounds,
880             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
881     }
882 
883     /**
884      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
885      */
886     function _isSenderApprovedOrOwner(
887         address approvedAddress,
888         address owner,
889         address msgSender
890     ) private pure returns (bool result) {
891         assembly {
892             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
893             owner := and(owner, _BITMASK_ADDRESS)
894             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
895             msgSender := and(msgSender, _BITMASK_ADDRESS)
896             // `msgSender == owner || msgSender == approvedAddress`.
897             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
898         }
899     }
900 
901     /**
902      * @dev Returns the storage slot and value for the approved address of `tokenId`.
903      */
904     function _getApprovedSlotAndAddress(uint256 tokenId)
905         private
906         view
907         returns (uint256 approvedAddressSlot, address approvedAddress)
908     {
909         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
910         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
911         assembly {
912             approvedAddressSlot := tokenApproval.slot
913             approvedAddress := sload(approvedAddressSlot)
914         }
915     }
916 
917     // =============================================================
918     //                      TRANSFER OPERATIONS
919     // =============================================================
920 
921     /**
922      * @dev Transfers `tokenId` from `from` to `to`.
923      *
924      * Requirements:
925      *
926      * - `from` cannot be the zero address.
927      * - `to` cannot be the zero address.
928      * - `tokenId` token must be owned by `from`.
929      * - If the caller is not `from`, it must be approved to move this token
930      * by either {approve} or {setApprovalForAll}.
931      *
932      * Emits a {Transfer} event.
933      */
934     function transferFrom(
935         address from,
936         address to,
937         uint256 tokenId
938     ) public payable virtual override {
939         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
940 
941         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
942 
943         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
944 
945         // The nested ifs save around 20+ gas over a compound boolean condition.
946         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
947             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
948 
949         if (to == address(0)) revert TransferToZeroAddress();
950 
951         _beforeTokenTransfers(from, to, tokenId, 1);
952 
953         // Clear approvals from the previous owner.
954         assembly {
955             if approvedAddress {
956                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
957                 sstore(approvedAddressSlot, 0)
958             }
959         }
960 
961         // Underflow of the sender's balance is impossible because we check for
962         // ownership above and the recipient's balance can't realistically overflow.
963         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
964         unchecked {
965             // We can directly increment and decrement the balances.
966             --_packedAddressData[from]; // Updates: `balance -= 1`.
967             ++_packedAddressData[to]; // Updates: `balance += 1`.
968 
969             // Updates:
970             // - `address` to the next owner.
971             // - `startTimestamp` to the timestamp of transfering.
972             // - `burned` to `false`.
973             // - `nextInitialized` to `true`.
974             _packedOwnerships[tokenId] = _packOwnershipData(
975                 to,
976                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
977             );
978 
979             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
980             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
981                 uint256 nextTokenId = tokenId + 1;
982                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
983                 if (_packedOwnerships[nextTokenId] == 0) {
984                     // If the next slot is within bounds.
985                     if (nextTokenId != _currentIndex) {
986                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
987                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
988                     }
989                 }
990             }
991         }
992 
993         emit Transfer(from, to, tokenId);
994         _afterTokenTransfers(from, to, tokenId, 1);
995     }
996 
997     /**
998      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
999      */
1000     function safeTransferFrom(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) public payable virtual override {
1005         safeTransferFrom(from, to, tokenId, '');
1006     }
1007 
1008     /**
1009      * @dev Safely transfers `tokenId` token from `from` to `to`.
1010      *
1011      * Requirements:
1012      *
1013      * - `from` cannot be the zero address.
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must exist and be owned by `from`.
1016      * - If the caller is not `from`, it must be approved to move this token
1017      * by either {approve} or {setApprovalForAll}.
1018      * - If `to` refers to a smart contract, it must implement
1019      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) public payable virtual override {
1029         transferFrom(from, to, tokenId);
1030         if (to.code.length != 0)
1031             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1032                 revert TransferToNonERC721ReceiverImplementer();
1033             }
1034     }
1035 
1036     /**
1037      * @dev Hook that is called before a set of serially-ordered token IDs
1038      * are about to be transferred. This includes minting.
1039      * And also called before burning one token.
1040      *
1041      * `startTokenId` - the first token ID to be transferred.
1042      * `quantity` - the amount to be transferred.
1043      *
1044      * Calling conditions:
1045      *
1046      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1047      * transferred to `to`.
1048      * - When `from` is zero, `tokenId` will be minted for `to`.
1049      * - When `to` is zero, `tokenId` will be burned by `from`.
1050      * - `from` and `to` are never both zero.
1051      */
1052     function _beforeTokenTransfers(
1053         address from,
1054         address to,
1055         uint256 startTokenId,
1056         uint256 quantity
1057     ) internal virtual {}
1058 
1059     /**
1060      * @dev Hook that is called after a set of serially-ordered token IDs
1061      * have been transferred. This includes minting.
1062      * And also called after one token has been burned.
1063      *
1064      * `startTokenId` - the first token ID to be transferred.
1065      * `quantity` - the amount to be transferred.
1066      *
1067      * Calling conditions:
1068      *
1069      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1070      * transferred to `to`.
1071      * - When `from` is zero, `tokenId` has been minted for `to`.
1072      * - When `to` is zero, `tokenId` has been burned by `from`.
1073      * - `from` and `to` are never both zero.
1074      */
1075     function _afterTokenTransfers(
1076         address from,
1077         address to,
1078         uint256 startTokenId,
1079         uint256 quantity
1080     ) internal virtual {}
1081 
1082     /**
1083      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1084      *
1085      * `from` - Previous owner of the given token ID.
1086      * `to` - Target address that will receive the token.
1087      * `tokenId` - Token ID to be transferred.
1088      * `_data` - Optional data to send along with the call.
1089      *
1090      * Returns whether the call correctly returned the expected magic value.
1091      */
1092     function _checkContractOnERC721Received(
1093         address from,
1094         address to,
1095         uint256 tokenId,
1096         bytes memory _data
1097     ) private returns (bool) {
1098         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1099             bytes4 retval
1100         ) {
1101             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1102         } catch (bytes memory reason) {
1103             if (reason.length == 0) {
1104                 revert TransferToNonERC721ReceiverImplementer();
1105             } else {
1106                 assembly {
1107                     revert(add(32, reason), mload(reason))
1108                 }
1109             }
1110         }
1111     }
1112 
1113     // =============================================================
1114     //                        MINT OPERATIONS
1115     // =============================================================
1116 
1117     /**
1118      * @dev Mints `quantity` tokens and transfers them to `to`.
1119      *
1120      * Requirements:
1121      *
1122      * - `to` cannot be the zero address.
1123      * - `quantity` must be greater than 0.
1124      *
1125      * Emits a {Transfer} event for each mint.
1126      */
1127     function _mint(address to, uint256 quantity) internal virtual {
1128         uint256 startTokenId = _currentIndex;
1129         if (quantity == 0) revert MintZeroQuantity();
1130 
1131         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1132 
1133         // Overflows are incredibly unrealistic.
1134         // `balance` and `numberMinted` have a maximum limit of 2**64.
1135         // `tokenId` has a maximum limit of 2**256.
1136         unchecked {
1137             // Updates:
1138             // - `balance += quantity`.
1139             // - `numberMinted += quantity`.
1140             //
1141             // We can directly add to the `balance` and `numberMinted`.
1142             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1143 
1144             // Updates:
1145             // - `address` to the owner.
1146             // - `startTimestamp` to the timestamp of minting.
1147             // - `burned` to `false`.
1148             // - `nextInitialized` to `quantity == 1`.
1149             _packedOwnerships[startTokenId] = _packOwnershipData(
1150                 to,
1151                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1152             );
1153 
1154             uint256 toMasked;
1155             uint256 end = startTokenId + quantity;
1156 
1157             // Use assembly to loop and emit the `Transfer` event for gas savings.
1158             // The duplicated `log4` removes an extra check and reduces stack juggling.
1159             // The assembly, together with the surrounding Solidity code, have been
1160             // delicately arranged to nudge the compiler into producing optimized opcodes.
1161             assembly {
1162                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1163                 toMasked := and(to, _BITMASK_ADDRESS)
1164                 // Emit the `Transfer` event.
1165                 log4(
1166                     0, // Start of data (0, since no data).
1167                     0, // End of data (0, since no data).
1168                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1169                     0, // `address(0)`.
1170                     toMasked, // `to`.
1171                     startTokenId // `tokenId`.
1172                 )
1173 
1174                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1175                 // that overflows uint256 will make the loop run out of gas.
1176                 // The compiler will optimize the `iszero` away for performance.
1177                 for {
1178                     let tokenId := add(startTokenId, 1)
1179                 } iszero(eq(tokenId, end)) {
1180                     tokenId := add(tokenId, 1)
1181                 } {
1182                     // Emit the `Transfer` event. Similar to above.
1183                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1184                 }
1185             }
1186             if (toMasked == 0) revert MintToZeroAddress();
1187 
1188             _currentIndex = end;
1189         }
1190         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1191     }
1192 
1193     /**
1194      * @dev Mints `quantity` tokens and transfers them to `to`.
1195      *
1196      * This function is intended for efficient minting only during contract creation.
1197      *
1198      * It emits only one {ConsecutiveTransfer} as defined in
1199      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1200      * instead of a sequence of {Transfer} event(s).
1201      *
1202      * Calling this function outside of contract creation WILL make your contract
1203      * non-compliant with the ERC721 standard.
1204      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1205      * {ConsecutiveTransfer} event is only permissible during contract creation.
1206      *
1207      * Requirements:
1208      *
1209      * - `to` cannot be the zero address.
1210      * - `quantity` must be greater than 0.
1211      *
1212      * Emits a {ConsecutiveTransfer} event.
1213      */
1214     function _mintERC2309(address to, uint256 quantity) internal virtual {
1215         uint256 startTokenId = _currentIndex;
1216         if (to == address(0)) revert MintToZeroAddress();
1217         if (quantity == 0) revert MintZeroQuantity();
1218         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1219 
1220         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1221 
1222         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1223         unchecked {
1224             // Updates:
1225             // - `balance += quantity`.
1226             // - `numberMinted += quantity`.
1227             //
1228             // We can directly add to the `balance` and `numberMinted`.
1229             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1230 
1231             // Updates:
1232             // - `address` to the owner.
1233             // - `startTimestamp` to the timestamp of minting.
1234             // - `burned` to `false`.
1235             // - `nextInitialized` to `quantity == 1`.
1236             _packedOwnerships[startTokenId] = _packOwnershipData(
1237                 to,
1238                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1239             );
1240 
1241             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1242 
1243             _currentIndex = startTokenId + quantity;
1244         }
1245         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1246     }
1247 
1248     /**
1249      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1250      *
1251      * Requirements:
1252      *
1253      * - If `to` refers to a smart contract, it must implement
1254      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1255      * - `quantity` must be greater than 0.
1256      *
1257      * See {_mint}.
1258      *
1259      * Emits a {Transfer} event for each mint.
1260      */
1261     function _safeMint(
1262         address to,
1263         uint256 quantity,
1264         bytes memory _data
1265     ) internal virtual {
1266         _mint(to, quantity);
1267 
1268         unchecked {
1269             if (to.code.length != 0) {
1270                 uint256 end = _currentIndex;
1271                 uint256 index = end - quantity;
1272                 do {
1273                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1274                         revert TransferToNonERC721ReceiverImplementer();
1275                     }
1276                 } while (index < end);
1277                 // Reentrancy protection.
1278                 if (_currentIndex != end) revert();
1279             }
1280         }
1281     }
1282 
1283     /**
1284      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1285      */
1286     function _safeMint(address to, uint256 quantity) internal virtual {
1287         _safeMint(to, quantity, '');
1288     }
1289 
1290     // =============================================================
1291     //                        BURN OPERATIONS
1292     // =============================================================
1293 
1294     /**
1295      * @dev Equivalent to `_burn(tokenId, false)`.
1296      */
1297     function _burn(uint256 tokenId) internal virtual {
1298         _burn(tokenId, false);
1299     }
1300 
1301     /**
1302      * @dev Destroys `tokenId`.
1303      * The approval is cleared when the token is burned.
1304      *
1305      * Requirements:
1306      *
1307      * - `tokenId` must exist.
1308      *
1309      * Emits a {Transfer} event.
1310      */
1311     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1312         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1313 
1314         address from = address(uint160(prevOwnershipPacked));
1315 
1316         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1317 
1318         if (approvalCheck) {
1319             // The nested ifs save around 20+ gas over a compound boolean condition.
1320             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1321                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1322         }
1323 
1324         _beforeTokenTransfers(from, address(0), tokenId, 1);
1325 
1326         // Clear approvals from the previous owner.
1327         assembly {
1328             if approvedAddress {
1329                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1330                 sstore(approvedAddressSlot, 0)
1331             }
1332         }
1333 
1334         // Underflow of the sender's balance is impossible because we check for
1335         // ownership above and the recipient's balance can't realistically overflow.
1336         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1337         unchecked {
1338             // Updates:
1339             // - `balance -= 1`.
1340             // - `numberBurned += 1`.
1341             //
1342             // We can directly decrement the balance, and increment the number burned.
1343             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1344             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1345 
1346             // Updates:
1347             // - `address` to the last owner.
1348             // - `startTimestamp` to the timestamp of burning.
1349             // - `burned` to `true`.
1350             // - `nextInitialized` to `true`.
1351             _packedOwnerships[tokenId] = _packOwnershipData(
1352                 from,
1353                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1354             );
1355 
1356             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1357             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1358                 uint256 nextTokenId = tokenId + 1;
1359                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1360                 if (_packedOwnerships[nextTokenId] == 0) {
1361                     // If the next slot is within bounds.
1362                     if (nextTokenId != _currentIndex) {
1363                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1364                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1365                     }
1366                 }
1367             }
1368         }
1369 
1370         emit Transfer(from, address(0), tokenId);
1371         _afterTokenTransfers(from, address(0), tokenId, 1);
1372 
1373         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1374         unchecked {
1375             _burnCounter++;
1376         }
1377     }
1378 
1379     // =============================================================
1380     //                     EXTRA DATA OPERATIONS
1381     // =============================================================
1382 
1383     /**
1384      * @dev Directly sets the extra data for the ownership data `index`.
1385      */
1386     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1387         uint256 packed = _packedOwnerships[index];
1388         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1389         uint256 extraDataCasted;
1390         // Cast `extraData` with assembly to avoid redundant masking.
1391         assembly {
1392             extraDataCasted := extraData
1393         }
1394         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1395         _packedOwnerships[index] = packed;
1396     }
1397 
1398     /**
1399      * @dev Called during each token transfer to set the 24bit `extraData` field.
1400      * Intended to be overridden by the cosumer contract.
1401      *
1402      * `previousExtraData` - the value of `extraData` before transfer.
1403      *
1404      * Calling conditions:
1405      *
1406      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1407      * transferred to `to`.
1408      * - When `from` is zero, `tokenId` will be minted for `to`.
1409      * - When `to` is zero, `tokenId` will be burned by `from`.
1410      * - `from` and `to` are never both zero.
1411      */
1412     function _extraData(
1413         address from,
1414         address to,
1415         uint24 previousExtraData
1416     ) internal view virtual returns (uint24) {}
1417 
1418     /**
1419      * @dev Returns the next extra data for the packed ownership data.
1420      * The returned result is shifted into position.
1421      */
1422     function _nextExtraData(
1423         address from,
1424         address to,
1425         uint256 prevOwnershipPacked
1426     ) private view returns (uint256) {
1427         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1428         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1429     }
1430 
1431     // =============================================================
1432     //                       OTHER OPERATIONS
1433     // =============================================================
1434 
1435     /**
1436      * @dev Returns the message sender (defaults to `msg.sender`).
1437      *
1438      * If you are writing GSN compatible contracts, you need to override this function.
1439      */
1440     function _msgSenderERC721A() internal view virtual returns (address) {
1441         return msg.sender;
1442     }
1443 
1444     /**
1445      * @dev Converts a uint256 to its ASCII string decimal representation.
1446      */
1447     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1448         assembly {
1449             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1450             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1451             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1452             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1453             let m := add(mload(0x40), 0xa0)
1454             // Update the free memory pointer to allocate.
1455             mstore(0x40, m)
1456             // Assign the `str` to the end.
1457             str := sub(m, 0x20)
1458             // Zeroize the slot after the string.
1459             mstore(str, 0)
1460 
1461             // Cache the end of the memory to calculate the length later.
1462             let end := str
1463 
1464             // We write the string from rightmost digit to leftmost digit.
1465             // The following is essentially a do-while loop that also handles the zero case.
1466             // prettier-ignore
1467             for { let temp := value } 1 {} {
1468                 str := sub(str, 1)
1469                 // Write the character to the pointer.
1470                 // The ASCII index of the '0' character is 48.
1471                 mstore8(str, add(48, mod(temp, 10)))
1472                 // Keep dividing `temp` until zero.
1473                 temp := div(temp, 10)
1474                 // prettier-ignore
1475                 if iszero(temp) { break }
1476             }
1477 
1478             let length := sub(end, str)
1479             // Move the pointer 32 bytes leftwards to make room for the length.
1480             str := sub(str, 0x20)
1481             // Store the length.
1482             mstore(str, length)
1483         }
1484     }
1485 }
1486 
1487 
1488 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
1489 
1490 
1491 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1492 
1493 pragma solidity ^0.8.0;
1494 
1495 /**
1496  * @dev Provides information about the current execution context, including the
1497  * sender of the transaction and its data. While these are generally available
1498  * via msg.sender and msg.data, they should not be accessed in such a direct
1499  * manner, since when dealing with meta-transactions the account sending and
1500  * paying for execution may not be the actual sender (as far as an application
1501  * is concerned).
1502  *
1503  * This contract is only required for intermediate, library-like contracts.
1504  */
1505 abstract contract Context {
1506     function _msgSender() internal view virtual returns (address) {
1507         return msg.sender;
1508     }
1509 
1510     function _msgData() internal view virtual returns (bytes calldata) {
1511         return msg.data;
1512     }
1513 }
1514 
1515 
1516 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
1517 
1518 
1519 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1520 
1521 pragma solidity ^0.8.0;
1522 
1523 /**
1524  * @dev Contract module which provides a basic access control mechanism, where
1525  * there is an account (an owner) that can be granted exclusive access to
1526  * specific functions.
1527  *
1528  * By default, the owner account will be the one that deploys the contract. This
1529  * can later be changed with {transferOwnership}.
1530  *
1531  * This module is used through inheritance. It will make available the modifier
1532  * `onlyOwner`, which can be applied to your functions to restrict their use to
1533  * the owner.
1534  */
1535 abstract contract Ownable is Context {
1536     address private _owner;
1537 
1538     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1539 
1540     /**
1541      * @dev Initializes the contract setting the deployer as the initial owner.
1542      */
1543     constructor() {
1544         _transferOwnership(_msgSender());
1545     }
1546 
1547     /**
1548      * @dev Throws if called by any account other than the owner.
1549      */
1550     modifier onlyOwner() {
1551         _checkOwner();
1552         _;
1553     }
1554 
1555     /**
1556      * @dev Returns the address of the current owner.
1557      */
1558     function owner() public view virtual returns (address) {
1559         return _owner;
1560     }
1561 
1562     /**
1563      * @dev Throws if the sender is not the owner.
1564      */
1565     function _checkOwner() internal view virtual {
1566         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1567     }
1568 
1569     /**
1570      * @dev Leaves the contract without owner. It will not be possible to call
1571      * `onlyOwner` functions anymore. Can only be called by the current owner.
1572      *
1573      * NOTE: Renouncing ownership will leave the contract without an owner,
1574      * thereby removing any functionality that is only available to the owner.
1575      */
1576     function renounceOwnership() public virtual onlyOwner {
1577         _transferOwnership(address(0));
1578     }
1579 
1580     /**
1581      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1582      * Can only be called by the current owner.
1583      */
1584     function transferOwnership(address newOwner) public virtual onlyOwner {
1585         require(newOwner != address(0), "Ownable: new owner is the zero address");
1586         _transferOwnership(newOwner);
1587     }
1588 
1589     /**
1590      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1591      * Internal function without access restriction.
1592      */
1593     function _transferOwnership(address newOwner) internal virtual {
1594         address oldOwner = _owner;
1595         _owner = newOwner;
1596         emit OwnershipTransferred(oldOwner, newOwner);
1597     }
1598 }
1599 
1600 
1601 // File @openzeppelin/contracts/utils/Address.sol@v4.8.0
1602 
1603 
1604 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1605 
1606 pragma solidity ^0.8.1;
1607 
1608 /**
1609  * @dev Collection of functions related to the address type
1610  */
1611 library Address {
1612     /**
1613      * @dev Returns true if `account` is a contract.
1614      *
1615      * [IMPORTANT]
1616      * ====
1617      * It is unsafe to assume that an address for which this function returns
1618      * false is an externally-owned account (EOA) and not a contract.
1619      *
1620      * Among others, `isContract` will return false for the following
1621      * types of addresses:
1622      *
1623      *  - an externally-owned account
1624      *  - a contract in construction
1625      *  - an address where a contract will be created
1626      *  - an address where a contract lived, but was destroyed
1627      * ====
1628      *
1629      * [IMPORTANT]
1630      * ====
1631      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1632      *
1633      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1634      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1635      * constructor.
1636      * ====
1637      */
1638     function isContract(address account) internal view returns (bool) {
1639         // This method relies on extcodesize/address.code.length, which returns 0
1640         // for contracts in construction, since the code is only stored at the end
1641         // of the constructor execution.
1642 
1643         return account.code.length > 0;
1644     }
1645 
1646     /**
1647      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1648      * `recipient`, forwarding all available gas and reverting on errors.
1649      *
1650      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1651      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1652      * imposed by `transfer`, making them unable to receive funds via
1653      * `transfer`. {sendValue} removes this limitation.
1654      *
1655      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1656      *
1657      * IMPORTANT: because control is transferred to `recipient`, care must be
1658      * taken to not create reentrancy vulnerabilities. Consider using
1659      * {ReentrancyGuard} or the
1660      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1661      */
1662     function sendValue(address payable recipient, uint256 amount) internal {
1663         require(address(this).balance >= amount, "Address: insufficient balance");
1664 
1665         (bool success, ) = recipient.call{value: amount}("");
1666         require(success, "Address: unable to send value, recipient may have reverted");
1667     }
1668 
1669     /**
1670      * @dev Performs a Solidity function call using a low level `call`. A
1671      * plain `call` is an unsafe replacement for a function call: use this
1672      * function instead.
1673      *
1674      * If `target` reverts with a revert reason, it is bubbled up by this
1675      * function (like regular Solidity function calls).
1676      *
1677      * Returns the raw returned data. To convert to the expected return value,
1678      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1679      *
1680      * Requirements:
1681      *
1682      * - `target` must be a contract.
1683      * - calling `target` with `data` must not revert.
1684      *
1685      * _Available since v3.1._
1686      */
1687     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1688         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1689     }
1690 
1691     /**
1692      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1693      * `errorMessage` as a fallback revert reason when `target` reverts.
1694      *
1695      * _Available since v3.1._
1696      */
1697     function functionCall(
1698         address target,
1699         bytes memory data,
1700         string memory errorMessage
1701     ) internal returns (bytes memory) {
1702         return functionCallWithValue(target, data, 0, errorMessage);
1703     }
1704 
1705     /**
1706      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1707      * but also transferring `value` wei to `target`.
1708      *
1709      * Requirements:
1710      *
1711      * - the calling contract must have an ETH balance of at least `value`.
1712      * - the called Solidity function must be `payable`.
1713      *
1714      * _Available since v3.1._
1715      */
1716     function functionCallWithValue(
1717         address target,
1718         bytes memory data,
1719         uint256 value
1720     ) internal returns (bytes memory) {
1721         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1722     }
1723 
1724     /**
1725      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1726      * with `errorMessage` as a fallback revert reason when `target` reverts.
1727      *
1728      * _Available since v3.1._
1729      */
1730     function functionCallWithValue(
1731         address target,
1732         bytes memory data,
1733         uint256 value,
1734         string memory errorMessage
1735     ) internal returns (bytes memory) {
1736         require(address(this).balance >= value, "Address: insufficient balance for call");
1737         (bool success, bytes memory returndata) = target.call{value: value}(data);
1738         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1739     }
1740 
1741     /**
1742      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1743      * but performing a static call.
1744      *
1745      * _Available since v3.3._
1746      */
1747     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1748         return functionStaticCall(target, data, "Address: low-level static call failed");
1749     }
1750 
1751     /**
1752      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1753      * but performing a static call.
1754      *
1755      * _Available since v3.3._
1756      */
1757     function functionStaticCall(
1758         address target,
1759         bytes memory data,
1760         string memory errorMessage
1761     ) internal view returns (bytes memory) {
1762         (bool success, bytes memory returndata) = target.staticcall(data);
1763         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1764     }
1765 
1766     /**
1767      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1768      * but performing a delegate call.
1769      *
1770      * _Available since v3.4._
1771      */
1772     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1773         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1774     }
1775 
1776     /**
1777      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1778      * but performing a delegate call.
1779      *
1780      * _Available since v3.4._
1781      */
1782     function functionDelegateCall(
1783         address target,
1784         bytes memory data,
1785         string memory errorMessage
1786     ) internal returns (bytes memory) {
1787         (bool success, bytes memory returndata) = target.delegatecall(data);
1788         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1789     }
1790 
1791     /**
1792      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1793      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1794      *
1795      * _Available since v4.8._
1796      */
1797     function verifyCallResultFromTarget(
1798         address target,
1799         bool success,
1800         bytes memory returndata,
1801         string memory errorMessage
1802     ) internal view returns (bytes memory) {
1803         if (success) {
1804             if (returndata.length == 0) {
1805                 // only check isContract if the call was successful and the return data is empty
1806                 // otherwise we already know that it was a contract
1807                 require(isContract(target), "Address: call to non-contract");
1808             }
1809             return returndata;
1810         } else {
1811             _revert(returndata, errorMessage);
1812         }
1813     }
1814 
1815     /**
1816      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1817      * revert reason or using the provided one.
1818      *
1819      * _Available since v4.3._
1820      */
1821     function verifyCallResult(
1822         bool success,
1823         bytes memory returndata,
1824         string memory errorMessage
1825     ) internal pure returns (bytes memory) {
1826         if (success) {
1827             return returndata;
1828         } else {
1829             _revert(returndata, errorMessage);
1830         }
1831     }
1832 
1833     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1834         // Look for revert reason and bubble it up if present
1835         if (returndata.length > 0) {
1836             // The easiest way to bubble the revert reason is using memory via assembly
1837             /// @solidity memory-safe-assembly
1838             assembly {
1839                 let returndata_size := mload(returndata)
1840                 revert(add(32, returndata), returndata_size)
1841             }
1842         } else {
1843             revert(errorMessage);
1844         }
1845     }
1846 }
1847 
1848 
1849 // File contracts/NFT.sol
1850 
1851 
1852 pragma solidity ^0.8.13;
1853 
1854 
1855 
1856 
1857 contract DecdPEPE is ERC721A, DefaultOperatorFilterer, Ownable {
1858     using Address for address;
1859 
1860     string private _baseTokenURI;
1861     uint256 public maxSupply;
1862     uint256 public maxMint;
1863     uint256 public maxPerTx;
1864     uint256 public price;
1865     bool public mintable;
1866 
1867     mapping(address => uint256) public minted;
1868 
1869     constructor(
1870         string memory url,
1871         string memory name,
1872         string memory symbol,
1873         address _owner,
1874         uint256 _price
1875     ) ERC721A(name, symbol) {
1876         _baseTokenURI = url;
1877         maxSupply = 4444;
1878         maxMint = 3;
1879         maxPerTx = 3;
1880         price = _price;
1881         mintable = false;
1882         _transferOwnership(_owner);
1883     }
1884 
1885     function _baseURI() internal view override returns (string memory) {
1886         return _baseTokenURI;
1887     }
1888 
1889     function tokenURI(
1890         uint256 tokenId
1891     ) public view override returns (string memory) {
1892         require(
1893             _exists(tokenId),
1894             "ERC721Metadata: URI query for nonexistent token"
1895         );
1896         string memory baseURI = _baseURI();
1897         return string(abi.encodePacked(baseURI, _toString(tokenId), ".json"));
1898     }
1899 
1900     function changeBaseURI(string memory baseURI) public onlyOwner {
1901         _baseTokenURI = baseURI;
1902     }
1903 
1904     function changeMintable(bool _mintable) public onlyOwner {
1905         mintable = _mintable;
1906     }
1907 
1908     function changePrice(uint256 _price) public onlyOwner {
1909         price = _price;
1910     }
1911 
1912     function changeMaxMint(uint256 _maxMint) public onlyOwner {
1913         maxMint = _maxMint;
1914     }
1915 
1916     function changemaxPerTx(uint256 _maxPerTx) public onlyOwner {
1917         maxPerTx = _maxPerTx;
1918     }
1919 
1920     function changeMaxSupply(uint256 _maxSupply) public onlyOwner {
1921         maxSupply = _maxSupply;
1922     }
1923 
1924     function mint(uint256 num) public payable {
1925         uint256 amount = num * price;
1926         require(num <= maxPerTx, "Max per TX reached.");
1927         require(mintable, "status err");
1928         require(msg.value == amount, "eth err");
1929         require(minted[msg.sender] + num <= maxMint, "num err");
1930         require(msg.sender == tx.origin, "The minter is another contract");
1931         minted[msg.sender] += num;
1932         require(totalSupply() + num <= maxSupply, "num err");
1933         _safeMint(msg.sender, num);
1934     }
1935 
1936     function burn(uint256 tokenId) public {
1937         address ownerAddress = ownerOf(tokenId);
1938         require(msg.sender == ownerAddress || msg.sender == address(owner()), "Not authorized to burn");
1939         _burn(tokenId);
1940     }
1941 
1942     function setApprovalForAll(
1943         address operator,
1944         bool approved
1945     ) public override onlyAllowedOperatorApproval(operator) {
1946         super.setApprovalForAll(operator, approved);
1947     }
1948 
1949      function _startTokenId() internal view override returns (uint256) {
1950         return 1;
1951     }
1952 
1953     function approve(
1954         address operator,
1955         uint256 tokenId
1956     ) public payable override onlyAllowedOperatorApproval(operator) {
1957         super.approve(operator, tokenId);
1958     }
1959 
1960     function transferFrom(
1961         address from,
1962         address to,
1963         uint256 tokenId
1964     ) public payable override onlyAllowedOperator(from) {
1965         super.transferFrom(from, to, tokenId);
1966     }
1967 
1968     function safeTransferFrom(
1969         address from,
1970         address to,
1971         uint256 tokenId
1972     ) public payable override onlyAllowedOperator(from) {
1973         super.safeTransferFrom(from, to, tokenId);
1974     }
1975 
1976     function safeTransferFrom(
1977         address from,
1978         address to,
1979         uint256 tokenId,
1980         bytes memory data
1981     ) public payable override onlyAllowedOperator(from) {
1982         super.safeTransferFrom(from, to, tokenId, data);
1983     }
1984 
1985     function withdraw() external onlyOwner {
1986         payable(msg.sender).transfer(address(this).balance);
1987     }
1988 
1989     function airdrop(
1990         address[] memory users,
1991         uint256[] memory nums
1992     ) public onlyOwner {
1993         require(users.length == nums.length);
1994         for (uint i = 0; i < users.length; i++) {
1995             uint256 num = nums[i];
1996             address user = users[i];
1997             require(totalSupply() + num <= maxSupply, "num err");
1998             _safeMint(user, num);
1999         }
2000     }
2001 }