1 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
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
33 // File: operator-filter-registry/src/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
44  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
45  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
46  */
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
58             if (subscribe) {
59                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     OPERATOR_FILTER_REGISTRY.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Allow spending tokens from addresses with balance
72         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73         // from an EOA.
74         if (from != msg.sender) {
75             _checkFilterOperator(msg.sender);
76         }
77         _;
78     }
79 
80     modifier onlyAllowedOperatorApproval(address operator) virtual {
81         _checkFilterOperator(operator);
82         _;
83     }
84 
85     function _checkFilterOperator(address operator) internal view virtual {
86         // Check registry code length to facilitate testing in environments without a deployed registry.
87         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
88             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
89                 revert OperatorNotAllowed(operator);
90             }
91         }
92     }
93 }
94 
95 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 /**
102  * @title  DefaultOperatorFilterer
103  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
104  */
105 abstract contract DefaultOperatorFilterer is OperatorFilterer {
106     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
107 
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 // File: erc721a/contracts/IERC721A.sol
112 
113 
114 // ERC721A Contracts v4.2.3
115 // Creator: Chiru Labs
116 
117 pragma solidity ^0.8.4;
118 
119 /**
120  * @dev Interface of ERC721A.
121  */
122 interface IERC721A {
123     /**
124      * The caller must own the token or be an approved operator.
125      */
126     error ApprovalCallerNotOwnerNorApproved();
127 
128     /**
129      * The token does not exist.
130      */
131     error ApprovalQueryForNonexistentToken();
132 
133     /**
134      * Cannot query the balance for the zero address.
135      */
136     error BalanceQueryForZeroAddress();
137 
138     /**
139      * Cannot mint to the zero address.
140      */
141     error MintToZeroAddress();
142 
143     /**
144      * The quantity of tokens minted must be more than zero.
145      */
146     error MintZeroQuantity();
147 
148     /**
149      * The token does not exist.
150      */
151     error OwnerQueryForNonexistentToken();
152 
153     /**
154      * The caller must own the token or be an approved operator.
155      */
156     error TransferCallerNotOwnerNorApproved();
157 
158     /**
159      * The token must be owned by `from`.
160      */
161     error TransferFromIncorrectOwner();
162 
163     /**
164      * Cannot safely transfer to a contract that does not implement the
165      * ERC721Receiver interface.
166      */
167     error TransferToNonERC721ReceiverImplementer();
168 
169     /**
170      * Cannot transfer to the zero address.
171      */
172     error TransferToZeroAddress();
173 
174     /**
175      * The token does not exist.
176      */
177     error URIQueryForNonexistentToken();
178 
179     /**
180      * The `quantity` minted with ERC2309 exceeds the safety limit.
181      */
182     error MintERC2309QuantityExceedsLimit();
183 
184     /**
185      * The `extraData` cannot be set on an unintialized ownership slot.
186      */
187     error OwnershipNotInitializedForExtraData();
188 
189     // =============================================================
190     //                            STRUCTS
191     // =============================================================
192 
193     struct TokenOwnership {
194         // The address of the owner.
195         address addr;
196         // Stores the start time of ownership with minimal overhead for tokenomics.
197         uint64 startTimestamp;
198         // Whether the token has been burned.
199         bool burned;
200         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
201         uint24 extraData;
202     }
203 
204     // =============================================================
205     //                         TOKEN COUNTERS
206     // =============================================================
207 
208     /**
209      * @dev Returns the total number of tokens in existence.
210      * Burned tokens will reduce the count.
211      * To get the total number of tokens minted, please see {_totalMinted}.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     // =============================================================
216     //                            IERC165
217     // =============================================================
218 
219     /**
220      * @dev Returns true if this contract implements the interface defined by
221      * `interfaceId`. See the corresponding
222      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
223      * to learn more about how these ids are created.
224      *
225      * This function call must use less than 30000 gas.
226      */
227     function supportsInterface(bytes4 interfaceId) external view returns (bool);
228 
229     // =============================================================
230     //                            IERC721
231     // =============================================================
232 
233     /**
234      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
235      */
236     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
237 
238     /**
239      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
240      */
241     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
242 
243     /**
244      * @dev Emitted when `owner` enables or disables
245      * (`approved`) `operator` to manage all of its assets.
246      */
247     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
248 
249     /**
250      * @dev Returns the number of tokens in `owner`'s account.
251      */
252     function balanceOf(address owner) external view returns (uint256 balance);
253 
254     /**
255      * @dev Returns the owner of the `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function ownerOf(uint256 tokenId) external view returns (address owner);
262 
263     /**
264      * @dev Safely transfers `tokenId` token from `from` to `to`,
265      * checking first that contract recipients are aware of the ERC721 protocol
266      * to prevent tokens from being forever locked.
267      *
268      * Requirements:
269      *
270      * - `from` cannot be the zero address.
271      * - `to` cannot be the zero address.
272      * - `tokenId` token must exist and be owned by `from`.
273      * - If the caller is not `from`, it must be have been allowed to move
274      * this token by either {approve} or {setApprovalForAll}.
275      * - If `to` refers to a smart contract, it must implement
276      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
277      *
278      * Emits a {Transfer} event.
279      */
280     function safeTransferFrom(
281         address from,
282         address to,
283         uint256 tokenId,
284         bytes calldata data
285     ) external payable;
286 
287     /**
288      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
289      */
290     function safeTransferFrom(
291         address from,
292         address to,
293         uint256 tokenId
294     ) external payable;
295 
296     /**
297      * @dev Transfers `tokenId` from `from` to `to`.
298      *
299      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
300      * whenever possible.
301      *
302      * Requirements:
303      *
304      * - `from` cannot be the zero address.
305      * - `to` cannot be the zero address.
306      * - `tokenId` token must be owned by `from`.
307      * - If the caller is not `from`, it must be approved to move this token
308      * by either {approve} or {setApprovalForAll}.
309      *
310      * Emits a {Transfer} event.
311      */
312     function transferFrom(
313         address from,
314         address to,
315         uint256 tokenId
316     ) external payable;
317 
318     /**
319      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
320      * The approval is cleared when the token is transferred.
321      *
322      * Only a single account can be approved at a time, so approving the
323      * zero address clears previous approvals.
324      *
325      * Requirements:
326      *
327      * - The caller must own the token or be an approved operator.
328      * - `tokenId` must exist.
329      *
330      * Emits an {Approval} event.
331      */
332     function approve(address to, uint256 tokenId) external payable;
333 
334     /**
335      * @dev Approve or remove `operator` as an operator for the caller.
336      * Operators can call {transferFrom} or {safeTransferFrom}
337      * for any token owned by the caller.
338      *
339      * Requirements:
340      *
341      * - The `operator` cannot be the caller.
342      *
343      * Emits an {ApprovalForAll} event.
344      */
345     function setApprovalForAll(address operator, bool _approved) external;
346 
347     /**
348      * @dev Returns the account approved for `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function getApproved(uint256 tokenId) external view returns (address operator);
355 
356     /**
357      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
358      *
359      * See {setApprovalForAll}.
360      */
361     function isApprovedForAll(address owner, address operator) external view returns (bool);
362 
363     // =============================================================
364     //                        IERC721Metadata
365     // =============================================================
366 
367     /**
368      * @dev Returns the token collection name.
369      */
370     function name() external view returns (string memory);
371 
372     /**
373      * @dev Returns the token collection symbol.
374      */
375     function symbol() external view returns (string memory);
376 
377     /**
378      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
379      */
380     function tokenURI(uint256 tokenId) external view returns (string memory);
381 
382     // =============================================================
383     //                           IERC2309
384     // =============================================================
385 
386     /**
387      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
388      * (inclusive) is transferred from `from` to `to`, as defined in the
389      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
390      *
391      * See {_mintERC2309} for more details.
392      */
393     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
394 }
395 
396 // File: erc721a/contracts/ERC721A.sol
397 
398 
399 // ERC721A Contracts v4.2.3
400 // Creator: Chiru Labs
401 
402 pragma solidity ^0.8.4;
403 
404 
405 /**
406  * @dev Interface of ERC721 token receiver.
407  */
408 interface ERC721A__IERC721Receiver {
409     function onERC721Received(
410         address operator,
411         address from,
412         uint256 tokenId,
413         bytes calldata data
414     ) external returns (bytes4);
415 }
416 
417 /**
418  * @title ERC721A
419  *
420  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
421  * Non-Fungible Token Standard, including the Metadata extension.
422  * Optimized for lower gas during batch mints.
423  *
424  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
425  * starting from `_startTokenId()`.
426  *
427  * Assumptions:
428  *
429  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
430  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
431  */
432 contract ERC721A is IERC721A {
433     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
434     struct TokenApprovalRef {
435         address value;
436     }
437 
438     // =============================================================
439     //                           CONSTANTS
440     // =============================================================
441 
442     // Mask of an entry in packed address data.
443     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
444 
445     // The bit position of `numberMinted` in packed address data.
446     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
447 
448     // The bit position of `numberBurned` in packed address data.
449     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
450 
451     // The bit position of `aux` in packed address data.
452     uint256 private constant _BITPOS_AUX = 192;
453 
454     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
455     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
456 
457     // The bit position of `startTimestamp` in packed ownership.
458     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
459 
460     // The bit mask of the `burned` bit in packed ownership.
461     uint256 private constant _BITMASK_BURNED = 1 << 224;
462 
463     // The bit position of the `nextInitialized` bit in packed ownership.
464     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
465 
466     // The bit mask of the `nextInitialized` bit in packed ownership.
467     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
468 
469     // The bit position of `extraData` in packed ownership.
470     uint256 private constant _BITPOS_EXTRA_DATA = 232;
471 
472     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
473     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
474 
475     // The mask of the lower 160 bits for addresses.
476     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
477 
478     // The maximum `quantity` that can be minted with {_mintERC2309}.
479     // This limit is to prevent overflows on the address data entries.
480     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
481     // is required to cause an overflow, which is unrealistic.
482     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
483 
484     // The `Transfer` event signature is given by:
485     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
486     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
487         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
488 
489     // =============================================================
490     //                            STORAGE
491     // =============================================================
492 
493     // The next token ID to be minted.
494     uint256 private _currentIndex;
495 
496     // The number of tokens burned.
497     uint256 private _burnCounter;
498 
499     // Token name
500     string private _name;
501 
502     // Token symbol
503     string private _symbol;
504 
505     // Mapping from token ID to ownership details
506     // An empty struct value does not necessarily mean the token is unowned.
507     // See {_packedOwnershipOf} implementation for details.
508     //
509     // Bits Layout:
510     // - [0..159]   `addr`
511     // - [160..223] `startTimestamp`
512     // - [224]      `burned`
513     // - [225]      `nextInitialized`
514     // - [232..255] `extraData`
515     mapping(uint256 => uint256) private _packedOwnerships;
516 
517     // Mapping owner address to address data.
518     //
519     // Bits Layout:
520     // - [0..63]    `balance`
521     // - [64..127]  `numberMinted`
522     // - [128..191] `numberBurned`
523     // - [192..255] `aux`
524     mapping(address => uint256) private _packedAddressData;
525 
526     // Mapping from token ID to approved address.
527     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
528 
529     // Mapping from owner to operator approvals
530     mapping(address => mapping(address => bool)) private _operatorApprovals;
531 
532     // =============================================================
533     //                          CONSTRUCTOR
534     // =============================================================
535 
536     constructor(string memory name_, string memory symbol_) {
537         _name = name_;
538         _symbol = symbol_;
539         _currentIndex = _startTokenId();
540     }
541 
542     // =============================================================
543     //                   TOKEN COUNTING OPERATIONS
544     // =============================================================
545 
546     /**
547      * @dev Returns the starting token ID.
548      * To change the starting token ID, please override this function.
549      */
550     function _startTokenId() internal view virtual returns (uint256) {
551         return 0;
552     }
553 
554     /**
555      * @dev Returns the next token ID to be minted.
556      */
557     function _nextTokenId() internal view virtual returns (uint256) {
558         return _currentIndex;
559     }
560 
561     /**
562      * @dev Returns the total number of tokens in existence.
563      * Burned tokens will reduce the count.
564      * To get the total number of tokens minted, please see {_totalMinted}.
565      */
566     function totalSupply() public view virtual override returns (uint256) {
567         // Counter underflow is impossible as _burnCounter cannot be incremented
568         // more than `_currentIndex - _startTokenId()` times.
569         unchecked {
570             return _currentIndex - _burnCounter - _startTokenId();
571         }
572     }
573 
574     /**
575      * @dev Returns the total amount of tokens minted in the contract.
576      */
577     function _totalMinted() internal view virtual returns (uint256) {
578         // Counter underflow is impossible as `_currentIndex` does not decrement,
579         // and it is initialized to `_startTokenId()`.
580         unchecked {
581             return _currentIndex - _startTokenId();
582         }
583     }
584 
585     /**
586      * @dev Returns the total number of tokens burned.
587      */
588     function _totalBurned() internal view virtual returns (uint256) {
589         return _burnCounter;
590     }
591 
592     // =============================================================
593     //                    ADDRESS DATA OPERATIONS
594     // =============================================================
595 
596     /**
597      * @dev Returns the number of tokens in `owner`'s account.
598      */
599     function balanceOf(address owner) public view virtual override returns (uint256) {
600         if (owner == address(0)) revert BalanceQueryForZeroAddress();
601         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
602     }
603 
604     /**
605      * Returns the number of tokens minted by `owner`.
606      */
607     function _numberMinted(address owner) internal view returns (uint256) {
608         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
609     }
610 
611     /**
612      * Returns the number of tokens burned by or on behalf of `owner`.
613      */
614     function _numberBurned(address owner) internal view returns (uint256) {
615         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
616     }
617 
618     /**
619      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
620      */
621     function _getAux(address owner) internal view returns (uint64) {
622         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
623     }
624 
625     /**
626      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
627      * If there are multiple variables, please pack them into a uint64.
628      */
629     function _setAux(address owner, uint64 aux) internal virtual {
630         uint256 packed = _packedAddressData[owner];
631         uint256 auxCasted;
632         // Cast `aux` with assembly to avoid redundant masking.
633         assembly {
634             auxCasted := aux
635         }
636         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
637         _packedAddressData[owner] = packed;
638     }
639 
640     // =============================================================
641     //                            IERC165
642     // =============================================================
643 
644     /**
645      * @dev Returns true if this contract implements the interface defined by
646      * `interfaceId`. See the corresponding
647      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
648      * to learn more about how these ids are created.
649      *
650      * This function call must use less than 30000 gas.
651      */
652     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
653         // The interface IDs are constants representing the first 4 bytes
654         // of the XOR of all function selectors in the interface.
655         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
656         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
657         return
658             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
659             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
660             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
661     }
662 
663     // =============================================================
664     //                        IERC721Metadata
665     // =============================================================
666 
667     /**
668      * @dev Returns the token collection name.
669      */
670     function name() public view virtual override returns (string memory) {
671         return _name;
672     }
673 
674     /**
675      * @dev Returns the token collection symbol.
676      */
677     function symbol() public view virtual override returns (string memory) {
678         return _symbol;
679     }
680 
681     /**
682      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
683      */
684     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
685         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
686 
687         string memory baseURI = _baseURI();
688         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
689     }
690 
691     /**
692      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
693      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
694      * by default, it can be overridden in child contracts.
695      */
696     function _baseURI() internal view virtual returns (string memory) {
697         return '';
698     }
699 
700     // =============================================================
701     //                     OWNERSHIPS OPERATIONS
702     // =============================================================
703 
704     /**
705      * @dev Returns the owner of the `tokenId` token.
706      *
707      * Requirements:
708      *
709      * - `tokenId` must exist.
710      */
711     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
712         return address(uint160(_packedOwnershipOf(tokenId)));
713     }
714 
715     /**
716      * @dev Gas spent here starts off proportional to the maximum mint batch size.
717      * It gradually moves to O(1) as tokens get transferred around over time.
718      */
719     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
720         return _unpackedOwnership(_packedOwnershipOf(tokenId));
721     }
722 
723     /**
724      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
725      */
726     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
727         return _unpackedOwnership(_packedOwnerships[index]);
728     }
729 
730     /**
731      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
732      */
733     function _initializeOwnershipAt(uint256 index) internal virtual {
734         if (_packedOwnerships[index] == 0) {
735             _packedOwnerships[index] = _packedOwnershipOf(index);
736         }
737     }
738 
739     /**
740      * Returns the packed ownership data of `tokenId`.
741      */
742     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
743         uint256 curr = tokenId;
744 
745         unchecked {
746             if (_startTokenId() <= curr)
747                 if (curr < _currentIndex) {
748                     uint256 packed = _packedOwnerships[curr];
749                     // If not burned.
750                     if (packed & _BITMASK_BURNED == 0) {
751                         // Invariant:
752                         // There will always be an initialized ownership slot
753                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
754                         // before an unintialized ownership slot
755                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
756                         // Hence, `curr` will not underflow.
757                         //
758                         // We can directly compare the packed value.
759                         // If the address is zero, packed will be zero.
760                         while (packed == 0) {
761                             packed = _packedOwnerships[--curr];
762                         }
763                         return packed;
764                     }
765                 }
766         }
767         revert OwnerQueryForNonexistentToken();
768     }
769 
770     /**
771      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
772      */
773     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
774         ownership.addr = address(uint160(packed));
775         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
776         ownership.burned = packed & _BITMASK_BURNED != 0;
777         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
778     }
779 
780     /**
781      * @dev Packs ownership data into a single uint256.
782      */
783     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
784         assembly {
785             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
786             owner := and(owner, _BITMASK_ADDRESS)
787             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
788             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
789         }
790     }
791 
792     /**
793      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
794      */
795     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
796         // For branchless setting of the `nextInitialized` flag.
797         assembly {
798             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
799             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
800         }
801     }
802 
803     // =============================================================
804     //                      APPROVAL OPERATIONS
805     // =============================================================
806 
807     /**
808      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
809      * The approval is cleared when the token is transferred.
810      *
811      * Only a single account can be approved at a time, so approving the
812      * zero address clears previous approvals.
813      *
814      * Requirements:
815      *
816      * - The caller must own the token or be an approved operator.
817      * - `tokenId` must exist.
818      *
819      * Emits an {Approval} event.
820      */
821     function approve(address to, uint256 tokenId) public payable virtual override {
822         address owner = ownerOf(tokenId);
823 
824         if (_msgSenderERC721A() != owner)
825             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
826                 revert ApprovalCallerNotOwnerNorApproved();
827             }
828 
829         _tokenApprovals[tokenId].value = to;
830         emit Approval(owner, to, tokenId);
831     }
832 
833     /**
834      * @dev Returns the account approved for `tokenId` token.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      */
840     function getApproved(uint256 tokenId) public view virtual override returns (address) {
841         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
842 
843         return _tokenApprovals[tokenId].value;
844     }
845 
846     /**
847      * @dev Approve or remove `operator` as an operator for the caller.
848      * Operators can call {transferFrom} or {safeTransferFrom}
849      * for any token owned by the caller.
850      *
851      * Requirements:
852      *
853      * - The `operator` cannot be the caller.
854      *
855      * Emits an {ApprovalForAll} event.
856      */
857     function setApprovalForAll(address operator, bool approved) public virtual override {
858         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
859         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
860     }
861 
862     /**
863      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
864      *
865      * See {setApprovalForAll}.
866      */
867     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
868         return _operatorApprovals[owner][operator];
869     }
870 
871     /**
872      * @dev Returns whether `tokenId` exists.
873      *
874      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
875      *
876      * Tokens start existing when they are minted. See {_mint}.
877      */
878     function _exists(uint256 tokenId) internal view virtual returns (bool) {
879         return
880             _startTokenId() <= tokenId &&
881             tokenId < _currentIndex && // If within bounds,
882             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
883     }
884 
885     /**
886      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
887      */
888     function _isSenderApprovedOrOwner(
889         address approvedAddress,
890         address owner,
891         address msgSender
892     ) private pure returns (bool result) {
893         assembly {
894             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
895             owner := and(owner, _BITMASK_ADDRESS)
896             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
897             msgSender := and(msgSender, _BITMASK_ADDRESS)
898             // `msgSender == owner || msgSender == approvedAddress`.
899             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
900         }
901     }
902 
903     /**
904      * @dev Returns the storage slot and value for the approved address of `tokenId`.
905      */
906     function _getApprovedSlotAndAddress(uint256 tokenId)
907         private
908         view
909         returns (uint256 approvedAddressSlot, address approvedAddress)
910     {
911         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
912         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
913         assembly {
914             approvedAddressSlot := tokenApproval.slot
915             approvedAddress := sload(approvedAddressSlot)
916         }
917     }
918 
919     // =============================================================
920     //                      TRANSFER OPERATIONS
921     // =============================================================
922 
923     /**
924      * @dev Transfers `tokenId` from `from` to `to`.
925      *
926      * Requirements:
927      *
928      * - `from` cannot be the zero address.
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must be owned by `from`.
931      * - If the caller is not `from`, it must be approved to move this token
932      * by either {approve} or {setApprovalForAll}.
933      *
934      * Emits a {Transfer} event.
935      */
936     function transferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public payable virtual override {
941         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
942 
943         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
944 
945         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
946 
947         // The nested ifs save around 20+ gas over a compound boolean condition.
948         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
949             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
950 
951         if (to == address(0)) revert TransferToZeroAddress();
952 
953         _beforeTokenTransfers(from, to, tokenId, 1);
954 
955         // Clear approvals from the previous owner.
956         assembly {
957             if approvedAddress {
958                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
959                 sstore(approvedAddressSlot, 0)
960             }
961         }
962 
963         // Underflow of the sender's balance is impossible because we check for
964         // ownership above and the recipient's balance can't realistically overflow.
965         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
966         unchecked {
967             // We can directly increment and decrement the balances.
968             --_packedAddressData[from]; // Updates: `balance -= 1`.
969             ++_packedAddressData[to]; // Updates: `balance += 1`.
970 
971             // Updates:
972             // - `address` to the next owner.
973             // - `startTimestamp` to the timestamp of transfering.
974             // - `burned` to `false`.
975             // - `nextInitialized` to `true`.
976             _packedOwnerships[tokenId] = _packOwnershipData(
977                 to,
978                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
979             );
980 
981             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
982             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
983                 uint256 nextTokenId = tokenId + 1;
984                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
985                 if (_packedOwnerships[nextTokenId] == 0) {
986                     // If the next slot is within bounds.
987                     if (nextTokenId != _currentIndex) {
988                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
989                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
990                     }
991                 }
992             }
993         }
994 
995         emit Transfer(from, to, tokenId);
996         _afterTokenTransfers(from, to, tokenId, 1);
997     }
998 
999     /**
1000      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1001      */
1002     function safeTransferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public payable virtual override {
1007         safeTransferFrom(from, to, tokenId, '');
1008     }
1009 
1010     /**
1011      * @dev Safely transfers `tokenId` token from `from` to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - `from` cannot be the zero address.
1016      * - `to` cannot be the zero address.
1017      * - `tokenId` token must exist and be owned by `from`.
1018      * - If the caller is not `from`, it must be approved to move this token
1019      * by either {approve} or {setApprovalForAll}.
1020      * - If `to` refers to a smart contract, it must implement
1021      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes memory _data
1030     ) public payable virtual override {
1031         transferFrom(from, to, tokenId);
1032         if (to.code.length != 0)
1033             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1034                 revert TransferToNonERC721ReceiverImplementer();
1035             }
1036     }
1037 
1038     /**
1039      * @dev Hook that is called before a set of serially-ordered token IDs
1040      * are about to be transferred. This includes minting.
1041      * And also called before burning one token.
1042      *
1043      * `startTokenId` - the first token ID to be transferred.
1044      * `quantity` - the amount to be transferred.
1045      *
1046      * Calling conditions:
1047      *
1048      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1049      * transferred to `to`.
1050      * - When `from` is zero, `tokenId` will be minted for `to`.
1051      * - When `to` is zero, `tokenId` will be burned by `from`.
1052      * - `from` and `to` are never both zero.
1053      */
1054     function _beforeTokenTransfers(
1055         address from,
1056         address to,
1057         uint256 startTokenId,
1058         uint256 quantity
1059     ) internal virtual {}
1060 
1061     /**
1062      * @dev Hook that is called after a set of serially-ordered token IDs
1063      * have been transferred. This includes minting.
1064      * And also called after one token has been burned.
1065      *
1066      * `startTokenId` - the first token ID to be transferred.
1067      * `quantity` - the amount to be transferred.
1068      *
1069      * Calling conditions:
1070      *
1071      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1072      * transferred to `to`.
1073      * - When `from` is zero, `tokenId` has been minted for `to`.
1074      * - When `to` is zero, `tokenId` has been burned by `from`.
1075      * - `from` and `to` are never both zero.
1076      */
1077     function _afterTokenTransfers(
1078         address from,
1079         address to,
1080         uint256 startTokenId,
1081         uint256 quantity
1082     ) internal virtual {}
1083 
1084     /**
1085      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1086      *
1087      * `from` - Previous owner of the given token ID.
1088      * `to` - Target address that will receive the token.
1089      * `tokenId` - Token ID to be transferred.
1090      * `_data` - Optional data to send along with the call.
1091      *
1092      * Returns whether the call correctly returned the expected magic value.
1093      */
1094     function _checkContractOnERC721Received(
1095         address from,
1096         address to,
1097         uint256 tokenId,
1098         bytes memory _data
1099     ) private returns (bool) {
1100         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1101             bytes4 retval
1102         ) {
1103             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1104         } catch (bytes memory reason) {
1105             if (reason.length == 0) {
1106                 revert TransferToNonERC721ReceiverImplementer();
1107             } else {
1108                 assembly {
1109                     revert(add(32, reason), mload(reason))
1110                 }
1111             }
1112         }
1113     }
1114 
1115     // =============================================================
1116     //                        MINT OPERATIONS
1117     // =============================================================
1118 
1119     /**
1120      * @dev Mints `quantity` tokens and transfers them to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {Transfer} event for each mint.
1128      */
1129     function _mint(address to, uint256 quantity) internal virtual {
1130         uint256 startTokenId = _currentIndex;
1131         if (quantity == 0) revert MintZeroQuantity();
1132 
1133         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1134 
1135         // Overflows are incredibly unrealistic.
1136         // `balance` and `numberMinted` have a maximum limit of 2**64.
1137         // `tokenId` has a maximum limit of 2**256.
1138         unchecked {
1139             // Updates:
1140             // - `balance += quantity`.
1141             // - `numberMinted += quantity`.
1142             //
1143             // We can directly add to the `balance` and `numberMinted`.
1144             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1145 
1146             // Updates:
1147             // - `address` to the owner.
1148             // - `startTimestamp` to the timestamp of minting.
1149             // - `burned` to `false`.
1150             // - `nextInitialized` to `quantity == 1`.
1151             _packedOwnerships[startTokenId] = _packOwnershipData(
1152                 to,
1153                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1154             );
1155 
1156             uint256 toMasked;
1157             uint256 end = startTokenId + quantity;
1158 
1159             // Use assembly to loop and emit the `Transfer` event for gas savings.
1160             // The duplicated `log4` removes an extra check and reduces stack juggling.
1161             // The assembly, together with the surrounding Solidity code, have been
1162             // delicately arranged to nudge the compiler into producing optimized opcodes.
1163             assembly {
1164                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1165                 toMasked := and(to, _BITMASK_ADDRESS)
1166                 // Emit the `Transfer` event.
1167                 log4(
1168                     0, // Start of data (0, since no data).
1169                     0, // End of data (0, since no data).
1170                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1171                     0, // `address(0)`.
1172                     toMasked, // `to`.
1173                     startTokenId // `tokenId`.
1174                 )
1175 
1176                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1177                 // that overflows uint256 will make the loop run out of gas.
1178                 // The compiler will optimize the `iszero` away for performance.
1179                 for {
1180                     let tokenId := add(startTokenId, 1)
1181                 } iszero(eq(tokenId, end)) {
1182                     tokenId := add(tokenId, 1)
1183                 } {
1184                     // Emit the `Transfer` event. Similar to above.
1185                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1186                 }
1187             }
1188             if (toMasked == 0) revert MintToZeroAddress();
1189 
1190             _currentIndex = end;
1191         }
1192         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1193     }
1194 
1195     /**
1196      * @dev Mints `quantity` tokens and transfers them to `to`.
1197      *
1198      * This function is intended for efficient minting only during contract creation.
1199      *
1200      * It emits only one {ConsecutiveTransfer} as defined in
1201      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1202      * instead of a sequence of {Transfer} event(s).
1203      *
1204      * Calling this function outside of contract creation WILL make your contract
1205      * non-compliant with the ERC721 standard.
1206      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1207      * {ConsecutiveTransfer} event is only permissible during contract creation.
1208      *
1209      * Requirements:
1210      *
1211      * - `to` cannot be the zero address.
1212      * - `quantity` must be greater than 0.
1213      *
1214      * Emits a {ConsecutiveTransfer} event.
1215      */
1216     function _mintERC2309(address to, uint256 quantity) internal virtual {
1217         uint256 startTokenId = _currentIndex;
1218         if (to == address(0)) revert MintToZeroAddress();
1219         if (quantity == 0) revert MintZeroQuantity();
1220         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1221 
1222         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1223 
1224         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1225         unchecked {
1226             // Updates:
1227             // - `balance += quantity`.
1228             // - `numberMinted += quantity`.
1229             //
1230             // We can directly add to the `balance` and `numberMinted`.
1231             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1232 
1233             // Updates:
1234             // - `address` to the owner.
1235             // - `startTimestamp` to the timestamp of minting.
1236             // - `burned` to `false`.
1237             // - `nextInitialized` to `quantity == 1`.
1238             _packedOwnerships[startTokenId] = _packOwnershipData(
1239                 to,
1240                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1241             );
1242 
1243             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1244 
1245             _currentIndex = startTokenId + quantity;
1246         }
1247         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1248     }
1249 
1250     /**
1251      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1252      *
1253      * Requirements:
1254      *
1255      * - If `to` refers to a smart contract, it must implement
1256      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1257      * - `quantity` must be greater than 0.
1258      *
1259      * See {_mint}.
1260      *
1261      * Emits a {Transfer} event for each mint.
1262      */
1263     function _safeMint(
1264         address to,
1265         uint256 quantity,
1266         bytes memory _data
1267     ) internal virtual {
1268         _mint(to, quantity);
1269 
1270         unchecked {
1271             if (to.code.length != 0) {
1272                 uint256 end = _currentIndex;
1273                 uint256 index = end - quantity;
1274                 do {
1275                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1276                         revert TransferToNonERC721ReceiverImplementer();
1277                     }
1278                 } while (index < end);
1279                 // Reentrancy protection.
1280                 if (_currentIndex != end) revert();
1281             }
1282         }
1283     }
1284 
1285     /**
1286      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1287      */
1288     function _safeMint(address to, uint256 quantity) internal virtual {
1289         _safeMint(to, quantity, '');
1290     }
1291 
1292     // =============================================================
1293     //                        BURN OPERATIONS
1294     // =============================================================
1295 
1296     /**
1297      * @dev Equivalent to `_burn(tokenId, false)`.
1298      */
1299     function _burn(uint256 tokenId) internal virtual {
1300         _burn(tokenId, false);
1301     }
1302 
1303     /**
1304      * @dev Destroys `tokenId`.
1305      * The approval is cleared when the token is burned.
1306      *
1307      * Requirements:
1308      *
1309      * - `tokenId` must exist.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1314         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1315 
1316         address from = address(uint160(prevOwnershipPacked));
1317 
1318         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1319 
1320         if (approvalCheck) {
1321             // The nested ifs save around 20+ gas over a compound boolean condition.
1322             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1323                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1324         }
1325 
1326         _beforeTokenTransfers(from, address(0), tokenId, 1);
1327 
1328         // Clear approvals from the previous owner.
1329         assembly {
1330             if approvedAddress {
1331                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1332                 sstore(approvedAddressSlot, 0)
1333             }
1334         }
1335 
1336         // Underflow of the sender's balance is impossible because we check for
1337         // ownership above and the recipient's balance can't realistically overflow.
1338         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1339         unchecked {
1340             // Updates:
1341             // - `balance -= 1`.
1342             // - `numberBurned += 1`.
1343             //
1344             // We can directly decrement the balance, and increment the number burned.
1345             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1346             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1347 
1348             // Updates:
1349             // - `address` to the last owner.
1350             // - `startTimestamp` to the timestamp of burning.
1351             // - `burned` to `true`.
1352             // - `nextInitialized` to `true`.
1353             _packedOwnerships[tokenId] = _packOwnershipData(
1354                 from,
1355                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1356             );
1357 
1358             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1359             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1360                 uint256 nextTokenId = tokenId + 1;
1361                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1362                 if (_packedOwnerships[nextTokenId] == 0) {
1363                     // If the next slot is within bounds.
1364                     if (nextTokenId != _currentIndex) {
1365                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1366                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1367                     }
1368                 }
1369             }
1370         }
1371 
1372         emit Transfer(from, address(0), tokenId);
1373         _afterTokenTransfers(from, address(0), tokenId, 1);
1374 
1375         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1376         unchecked {
1377             _burnCounter++;
1378         }
1379     }
1380 
1381     // =============================================================
1382     //                     EXTRA DATA OPERATIONS
1383     // =============================================================
1384 
1385     /**
1386      * @dev Directly sets the extra data for the ownership data `index`.
1387      */
1388     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1389         uint256 packed = _packedOwnerships[index];
1390         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1391         uint256 extraDataCasted;
1392         // Cast `extraData` with assembly to avoid redundant masking.
1393         assembly {
1394             extraDataCasted := extraData
1395         }
1396         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1397         _packedOwnerships[index] = packed;
1398     }
1399 
1400     /**
1401      * @dev Called during each token transfer to set the 24bit `extraData` field.
1402      * Intended to be overridden by the cosumer contract.
1403      *
1404      * `previousExtraData` - the value of `extraData` before transfer.
1405      *
1406      * Calling conditions:
1407      *
1408      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1409      * transferred to `to`.
1410      * - When `from` is zero, `tokenId` will be minted for `to`.
1411      * - When `to` is zero, `tokenId` will be burned by `from`.
1412      * - `from` and `to` are never both zero.
1413      */
1414     function _extraData(
1415         address from,
1416         address to,
1417         uint24 previousExtraData
1418     ) internal view virtual returns (uint24) {}
1419 
1420     /**
1421      * @dev Returns the next extra data for the packed ownership data.
1422      * The returned result is shifted into position.
1423      */
1424     function _nextExtraData(
1425         address from,
1426         address to,
1427         uint256 prevOwnershipPacked
1428     ) private view returns (uint256) {
1429         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1430         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1431     }
1432 
1433     // =============================================================
1434     //                       OTHER OPERATIONS
1435     // =============================================================
1436 
1437     /**
1438      * @dev Returns the message sender (defaults to `msg.sender`).
1439      *
1440      * If you are writing GSN compatible contracts, you need to override this function.
1441      */
1442     function _msgSenderERC721A() internal view virtual returns (address) {
1443         return msg.sender;
1444     }
1445 
1446     /**
1447      * @dev Converts a uint256 to its ASCII string decimal representation.
1448      */
1449     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1450         assembly {
1451             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1452             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1453             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1454             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1455             let m := add(mload(0x40), 0xa0)
1456             // Update the free memory pointer to allocate.
1457             mstore(0x40, m)
1458             // Assign the `str` to the end.
1459             str := sub(m, 0x20)
1460             // Zeroize the slot after the string.
1461             mstore(str, 0)
1462 
1463             // Cache the end of the memory to calculate the length later.
1464             let end := str
1465 
1466             // We write the string from rightmost digit to leftmost digit.
1467             // The following is essentially a do-while loop that also handles the zero case.
1468             // prettier-ignore
1469             for { let temp := value } 1 {} {
1470                 str := sub(str, 1)
1471                 // Write the character to the pointer.
1472                 // The ASCII index of the '0' character is 48.
1473                 mstore8(str, add(48, mod(temp, 10)))
1474                 // Keep dividing `temp` until zero.
1475                 temp := div(temp, 10)
1476                 // prettier-ignore
1477                 if iszero(temp) { break }
1478             }
1479 
1480             let length := sub(end, str)
1481             // Move the pointer 32 bytes leftwards to make room for the length.
1482             str := sub(str, 0x20)
1483             // Store the length.
1484             mstore(str, length)
1485         }
1486     }
1487 }
1488 
1489 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1490 
1491 
1492 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1493 
1494 pragma solidity ^0.8.0;
1495 
1496 /**
1497  * @dev These functions deal with verification of Merkle Tree proofs.
1498  *
1499  * The tree and the proofs can be generated using our
1500  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1501  * You will find a quickstart guide in the readme.
1502  *
1503  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1504  * hashing, or use a hash function other than keccak256 for hashing leaves.
1505  * This is because the concatenation of a sorted pair of internal nodes in
1506  * the merkle tree could be reinterpreted as a leaf value.
1507  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1508  * against this attack out of the box.
1509  */
1510 library MerkleProof {
1511     /**
1512      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1513      * defined by `root`. For this, a `proof` must be provided, containing
1514      * sibling hashes on the branch from the leaf to the root of the tree. Each
1515      * pair of leaves and each pair of pre-images are assumed to be sorted.
1516      */
1517     function verify(
1518         bytes32[] memory proof,
1519         bytes32 root,
1520         bytes32 leaf
1521     ) internal pure returns (bool) {
1522         return processProof(proof, leaf) == root;
1523     }
1524 
1525     /**
1526      * @dev Calldata version of {verify}
1527      *
1528      * _Available since v4.7._
1529      */
1530     function verifyCalldata(
1531         bytes32[] calldata proof,
1532         bytes32 root,
1533         bytes32 leaf
1534     ) internal pure returns (bool) {
1535         return processProofCalldata(proof, leaf) == root;
1536     }
1537 
1538     /**
1539      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1540      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1541      * hash matches the root of the tree. When processing the proof, the pairs
1542      * of leafs & pre-images are assumed to be sorted.
1543      *
1544      * _Available since v4.4._
1545      */
1546     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1547         bytes32 computedHash = leaf;
1548         for (uint256 i = 0; i < proof.length; i++) {
1549             computedHash = _hashPair(computedHash, proof[i]);
1550         }
1551         return computedHash;
1552     }
1553 
1554     /**
1555      * @dev Calldata version of {processProof}
1556      *
1557      * _Available since v4.7._
1558      */
1559     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1560         bytes32 computedHash = leaf;
1561         for (uint256 i = 0; i < proof.length; i++) {
1562             computedHash = _hashPair(computedHash, proof[i]);
1563         }
1564         return computedHash;
1565     }
1566 
1567     /**
1568      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1569      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1570      *
1571      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1572      *
1573      * _Available since v4.7._
1574      */
1575     function multiProofVerify(
1576         bytes32[] memory proof,
1577         bool[] memory proofFlags,
1578         bytes32 root,
1579         bytes32[] memory leaves
1580     ) internal pure returns (bool) {
1581         return processMultiProof(proof, proofFlags, leaves) == root;
1582     }
1583 
1584     /**
1585      * @dev Calldata version of {multiProofVerify}
1586      *
1587      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1588      *
1589      * _Available since v4.7._
1590      */
1591     function multiProofVerifyCalldata(
1592         bytes32[] calldata proof,
1593         bool[] calldata proofFlags,
1594         bytes32 root,
1595         bytes32[] memory leaves
1596     ) internal pure returns (bool) {
1597         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1598     }
1599 
1600     /**
1601      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1602      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1603      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1604      * respectively.
1605      *
1606      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1607      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1608      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1609      *
1610      * _Available since v4.7._
1611      */
1612     function processMultiProof(
1613         bytes32[] memory proof,
1614         bool[] memory proofFlags,
1615         bytes32[] memory leaves
1616     ) internal pure returns (bytes32 merkleRoot) {
1617         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1618         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1619         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1620         // the merkle tree.
1621         uint256 leavesLen = leaves.length;
1622         uint256 totalHashes = proofFlags.length;
1623 
1624         // Check proof validity.
1625         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1626 
1627         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1628         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1629         bytes32[] memory hashes = new bytes32[](totalHashes);
1630         uint256 leafPos = 0;
1631         uint256 hashPos = 0;
1632         uint256 proofPos = 0;
1633         // At each step, we compute the next hash using two values:
1634         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1635         //   get the next hash.
1636         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1637         //   `proof` array.
1638         for (uint256 i = 0; i < totalHashes; i++) {
1639             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1640             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1641             hashes[i] = _hashPair(a, b);
1642         }
1643 
1644         if (totalHashes > 0) {
1645             return hashes[totalHashes - 1];
1646         } else if (leavesLen > 0) {
1647             return leaves[0];
1648         } else {
1649             return proof[0];
1650         }
1651     }
1652 
1653     /**
1654      * @dev Calldata version of {processMultiProof}.
1655      *
1656      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1657      *
1658      * _Available since v4.7._
1659      */
1660     function processMultiProofCalldata(
1661         bytes32[] calldata proof,
1662         bool[] calldata proofFlags,
1663         bytes32[] memory leaves
1664     ) internal pure returns (bytes32 merkleRoot) {
1665         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1666         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1667         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1668         // the merkle tree.
1669         uint256 leavesLen = leaves.length;
1670         uint256 totalHashes = proofFlags.length;
1671 
1672         // Check proof validity.
1673         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1674 
1675         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1676         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1677         bytes32[] memory hashes = new bytes32[](totalHashes);
1678         uint256 leafPos = 0;
1679         uint256 hashPos = 0;
1680         uint256 proofPos = 0;
1681         // At each step, we compute the next hash using two values:
1682         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1683         //   get the next hash.
1684         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1685         //   `proof` array.
1686         for (uint256 i = 0; i < totalHashes; i++) {
1687             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1688             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1689             hashes[i] = _hashPair(a, b);
1690         }
1691 
1692         if (totalHashes > 0) {
1693             return hashes[totalHashes - 1];
1694         } else if (leavesLen > 0) {
1695             return leaves[0];
1696         } else {
1697             return proof[0];
1698         }
1699     }
1700 
1701     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1702         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1703     }
1704 
1705     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1706         /// @solidity memory-safe-assembly
1707         assembly {
1708             mstore(0x00, a)
1709             mstore(0x20, b)
1710             value := keccak256(0x00, 0x40)
1711         }
1712     }
1713 }
1714 
1715 // File: @openzeppelin/contracts/utils/math/Math.sol
1716 
1717 
1718 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1719 
1720 pragma solidity ^0.8.0;
1721 
1722 /**
1723  * @dev Standard math utilities missing in the Solidity language.
1724  */
1725 library Math {
1726     enum Rounding {
1727         Down, // Toward negative infinity
1728         Up, // Toward infinity
1729         Zero // Toward zero
1730     }
1731 
1732     /**
1733      * @dev Returns the largest of two numbers.
1734      */
1735     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1736         return a > b ? a : b;
1737     }
1738 
1739     /**
1740      * @dev Returns the smallest of two numbers.
1741      */
1742     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1743         return a < b ? a : b;
1744     }
1745 
1746     /**
1747      * @dev Returns the average of two numbers. The result is rounded towards
1748      * zero.
1749      */
1750     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1751         // (a + b) / 2 can overflow.
1752         return (a & b) + (a ^ b) / 2;
1753     }
1754 
1755     /**
1756      * @dev Returns the ceiling of the division of two numbers.
1757      *
1758      * This differs from standard division with `/` in that it rounds up instead
1759      * of rounding down.
1760      */
1761     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1762         // (a + b - 1) / b can overflow on addition, so we distribute.
1763         return a == 0 ? 0 : (a - 1) / b + 1;
1764     }
1765 
1766     /**
1767      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1768      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1769      * with further edits by Uniswap Labs also under MIT license.
1770      */
1771     function mulDiv(
1772         uint256 x,
1773         uint256 y,
1774         uint256 denominator
1775     ) internal pure returns (uint256 result) {
1776         unchecked {
1777             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1778             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1779             // variables such that product = prod1 * 2^256 + prod0.
1780             uint256 prod0; // Least significant 256 bits of the product
1781             uint256 prod1; // Most significant 256 bits of the product
1782             assembly {
1783                 let mm := mulmod(x, y, not(0))
1784                 prod0 := mul(x, y)
1785                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1786             }
1787 
1788             // Handle non-overflow cases, 256 by 256 division.
1789             if (prod1 == 0) {
1790                 return prod0 / denominator;
1791             }
1792 
1793             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1794             require(denominator > prod1);
1795 
1796             ///////////////////////////////////////////////
1797             // 512 by 256 division.
1798             ///////////////////////////////////////////////
1799 
1800             // Make division exact by subtracting the remainder from [prod1 prod0].
1801             uint256 remainder;
1802             assembly {
1803                 // Compute remainder using mulmod.
1804                 remainder := mulmod(x, y, denominator)
1805 
1806                 // Subtract 256 bit number from 512 bit number.
1807                 prod1 := sub(prod1, gt(remainder, prod0))
1808                 prod0 := sub(prod0, remainder)
1809             }
1810 
1811             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1812             // See https://cs.stackexchange.com/q/138556/92363.
1813 
1814             // Does not overflow because the denominator cannot be zero at this stage in the function.
1815             uint256 twos = denominator & (~denominator + 1);
1816             assembly {
1817                 // Divide denominator by twos.
1818                 denominator := div(denominator, twos)
1819 
1820                 // Divide [prod1 prod0] by twos.
1821                 prod0 := div(prod0, twos)
1822 
1823                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1824                 twos := add(div(sub(0, twos), twos), 1)
1825             }
1826 
1827             // Shift in bits from prod1 into prod0.
1828             prod0 |= prod1 * twos;
1829 
1830             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1831             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1832             // four bits. That is, denominator * inv = 1 mod 2^4.
1833             uint256 inverse = (3 * denominator) ^ 2;
1834 
1835             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1836             // in modular arithmetic, doubling the correct bits in each step.
1837             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1838             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1839             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1840             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1841             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1842             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1843 
1844             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1845             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1846             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1847             // is no longer required.
1848             result = prod0 * inverse;
1849             return result;
1850         }
1851     }
1852 
1853     /**
1854      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1855      */
1856     function mulDiv(
1857         uint256 x,
1858         uint256 y,
1859         uint256 denominator,
1860         Rounding rounding
1861     ) internal pure returns (uint256) {
1862         uint256 result = mulDiv(x, y, denominator);
1863         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1864             result += 1;
1865         }
1866         return result;
1867     }
1868 
1869     /**
1870      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1871      *
1872      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1873      */
1874     function sqrt(uint256 a) internal pure returns (uint256) {
1875         if (a == 0) {
1876             return 0;
1877         }
1878 
1879         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1880         //
1881         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1882         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1883         //
1884         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1885         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1886         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1887         //
1888         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1889         uint256 result = 1 << (log2(a) >> 1);
1890 
1891         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1892         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1893         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1894         // into the expected uint128 result.
1895         unchecked {
1896             result = (result + a / result) >> 1;
1897             result = (result + a / result) >> 1;
1898             result = (result + a / result) >> 1;
1899             result = (result + a / result) >> 1;
1900             result = (result + a / result) >> 1;
1901             result = (result + a / result) >> 1;
1902             result = (result + a / result) >> 1;
1903             return min(result, a / result);
1904         }
1905     }
1906 
1907     /**
1908      * @notice Calculates sqrt(a), following the selected rounding direction.
1909      */
1910     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1911         unchecked {
1912             uint256 result = sqrt(a);
1913             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1914         }
1915     }
1916 
1917     /**
1918      * @dev Return the log in base 2, rounded down, of a positive value.
1919      * Returns 0 if given 0.
1920      */
1921     function log2(uint256 value) internal pure returns (uint256) {
1922         uint256 result = 0;
1923         unchecked {
1924             if (value >> 128 > 0) {
1925                 value >>= 128;
1926                 result += 128;
1927             }
1928             if (value >> 64 > 0) {
1929                 value >>= 64;
1930                 result += 64;
1931             }
1932             if (value >> 32 > 0) {
1933                 value >>= 32;
1934                 result += 32;
1935             }
1936             if (value >> 16 > 0) {
1937                 value >>= 16;
1938                 result += 16;
1939             }
1940             if (value >> 8 > 0) {
1941                 value >>= 8;
1942                 result += 8;
1943             }
1944             if (value >> 4 > 0) {
1945                 value >>= 4;
1946                 result += 4;
1947             }
1948             if (value >> 2 > 0) {
1949                 value >>= 2;
1950                 result += 2;
1951             }
1952             if (value >> 1 > 0) {
1953                 result += 1;
1954             }
1955         }
1956         return result;
1957     }
1958 
1959     /**
1960      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1961      * Returns 0 if given 0.
1962      */
1963     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1964         unchecked {
1965             uint256 result = log2(value);
1966             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1967         }
1968     }
1969 
1970     /**
1971      * @dev Return the log in base 10, rounded down, of a positive value.
1972      * Returns 0 if given 0.
1973      */
1974     function log10(uint256 value) internal pure returns (uint256) {
1975         uint256 result = 0;
1976         unchecked {
1977             if (value >= 10**64) {
1978                 value /= 10**64;
1979                 result += 64;
1980             }
1981             if (value >= 10**32) {
1982                 value /= 10**32;
1983                 result += 32;
1984             }
1985             if (value >= 10**16) {
1986                 value /= 10**16;
1987                 result += 16;
1988             }
1989             if (value >= 10**8) {
1990                 value /= 10**8;
1991                 result += 8;
1992             }
1993             if (value >= 10**4) {
1994                 value /= 10**4;
1995                 result += 4;
1996             }
1997             if (value >= 10**2) {
1998                 value /= 10**2;
1999                 result += 2;
2000             }
2001             if (value >= 10**1) {
2002                 result += 1;
2003             }
2004         }
2005         return result;
2006     }
2007 
2008     /**
2009      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2010      * Returns 0 if given 0.
2011      */
2012     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2013         unchecked {
2014             uint256 result = log10(value);
2015             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2016         }
2017     }
2018 
2019     /**
2020      * @dev Return the log in base 256, rounded down, of a positive value.
2021      * Returns 0 if given 0.
2022      *
2023      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2024      */
2025     function log256(uint256 value) internal pure returns (uint256) {
2026         uint256 result = 0;
2027         unchecked {
2028             if (value >> 128 > 0) {
2029                 value >>= 128;
2030                 result += 16;
2031             }
2032             if (value >> 64 > 0) {
2033                 value >>= 64;
2034                 result += 8;
2035             }
2036             if (value >> 32 > 0) {
2037                 value >>= 32;
2038                 result += 4;
2039             }
2040             if (value >> 16 > 0) {
2041                 value >>= 16;
2042                 result += 2;
2043             }
2044             if (value >> 8 > 0) {
2045                 result += 1;
2046             }
2047         }
2048         return result;
2049     }
2050 
2051     /**
2052      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2053      * Returns 0 if given 0.
2054      */
2055     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2056         unchecked {
2057             uint256 result = log256(value);
2058             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2059         }
2060     }
2061 }
2062 
2063 // File: @openzeppelin/contracts/utils/Strings.sol
2064 
2065 
2066 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2067 
2068 pragma solidity ^0.8.0;
2069 
2070 
2071 /**
2072  * @dev String operations.
2073  */
2074 library Strings {
2075     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2076     uint8 private constant _ADDRESS_LENGTH = 20;
2077 
2078     /**
2079      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2080      */
2081     function toString(uint256 value) internal pure returns (string memory) {
2082         unchecked {
2083             uint256 length = Math.log10(value) + 1;
2084             string memory buffer = new string(length);
2085             uint256 ptr;
2086             /// @solidity memory-safe-assembly
2087             assembly {
2088                 ptr := add(buffer, add(32, length))
2089             }
2090             while (true) {
2091                 ptr--;
2092                 /// @solidity memory-safe-assembly
2093                 assembly {
2094                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2095                 }
2096                 value /= 10;
2097                 if (value == 0) break;
2098             }
2099             return buffer;
2100         }
2101     }
2102 
2103     /**
2104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2105      */
2106     function toHexString(uint256 value) internal pure returns (string memory) {
2107         unchecked {
2108             return toHexString(value, Math.log256(value) + 1);
2109         }
2110     }
2111 
2112     /**
2113      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2114      */
2115     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2116         bytes memory buffer = new bytes(2 * length + 2);
2117         buffer[0] = "0";
2118         buffer[1] = "x";
2119         for (uint256 i = 2 * length + 1; i > 1; --i) {
2120             buffer[i] = _SYMBOLS[value & 0xf];
2121             value >>= 4;
2122         }
2123         require(value == 0, "Strings: hex length insufficient");
2124         return string(buffer);
2125     }
2126 
2127     /**
2128      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2129      */
2130     function toHexString(address addr) internal pure returns (string memory) {
2131         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2132     }
2133 }
2134 
2135 // File: @openzeppelin/contracts/utils/Context.sol
2136 
2137 
2138 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2139 
2140 pragma solidity ^0.8.0;
2141 
2142 /**
2143  * @dev Provides information about the current execution context, including the
2144  * sender of the transaction and its data. While these are generally available
2145  * via msg.sender and msg.data, they should not be accessed in such a direct
2146  * manner, since when dealing with meta-transactions the account sending and
2147  * paying for execution may not be the actual sender (as far as an application
2148  * is concerned).
2149  *
2150  * This contract is only required for intermediate, library-like contracts.
2151  */
2152 abstract contract Context {
2153     function _msgSender() internal view virtual returns (address) {
2154         return msg.sender;
2155     }
2156 
2157     function _msgData() internal view virtual returns (bytes calldata) {
2158         return msg.data;
2159     }
2160 }
2161 
2162 // File: @openzeppelin/contracts/access/Ownable.sol
2163 
2164 
2165 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2166 
2167 pragma solidity ^0.8.0;
2168 
2169 
2170 /**
2171  * @dev Contract module which provides a basic access control mechanism, where
2172  * there is an account (an owner) that can be granted exclusive access to
2173  * specific functions.
2174  *
2175  * By default, the owner account will be the one that deploys the contract. This
2176  * can later be changed with {transferOwnership}.
2177  *
2178  * This module is used through inheritance. It will make available the modifier
2179  * `onlyOwner`, which can be applied to your functions to restrict their use to
2180  * the owner.
2181  */
2182 abstract contract Ownable is Context {
2183     address private _owner;
2184 
2185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2186 
2187     /**
2188      * @dev Initializes the contract setting the deployer as the initial owner.
2189      */
2190     constructor() {
2191         _transferOwnership(_msgSender());
2192     }
2193 
2194     /**
2195      * @dev Throws if called by any account other than the owner.
2196      */
2197     modifier onlyOwner() {
2198         _checkOwner();
2199         _;
2200     }
2201 
2202     /**
2203      * @dev Returns the address of the current owner.
2204      */
2205     function owner() public view virtual returns (address) {
2206         return _owner;
2207     }
2208 
2209     /**
2210      * @dev Throws if the sender is not the owner.
2211      */
2212     function _checkOwner() internal view virtual {
2213         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2214     }
2215 
2216     /**
2217      * @dev Leaves the contract without owner. It will not be possible to call
2218      * `onlyOwner` functions anymore. Can only be called by the current owner.
2219      *
2220      * NOTE: Renouncing ownership will leave the contract without an owner,
2221      * thereby removing any functionality that is only available to the owner.
2222      */
2223     function renounceOwnership() public virtual onlyOwner {
2224         _transferOwnership(address(0));
2225     }
2226 
2227     /**
2228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2229      * Can only be called by the current owner.
2230      */
2231     function transferOwnership(address newOwner) public virtual onlyOwner {
2232         require(newOwner != address(0), "Ownable: new owner is the zero address");
2233         _transferOwnership(newOwner);
2234     }
2235 
2236     /**
2237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2238      * Internal function without access restriction.
2239      */
2240     function _transferOwnership(address newOwner) internal virtual {
2241         address oldOwner = _owner;
2242         _owner = newOwner;
2243         emit OwnershipTransferred(oldOwner, newOwner);
2244     }
2245 }
2246 
2247 // File: contracts/DracoPix.sol
2248 
2249 
2250 pragma solidity ^0.8.13;
2251 
2252 
2253 
2254 
2255 
2256 
2257 struct PresaleConfig {
2258   uint32 startTime;
2259   uint32 endTime;
2260 }
2261 
2262 contract DracoPix is ERC721A, Ownable, DefaultOperatorFilterer {
2263 
2264     /// ERRORS ///
2265     error ContractMint();
2266     error OutOfSupply();
2267     error ExceedsTxnLimit();
2268     error ExceedsWalletLimit();
2269     error InsufficientFunds();
2270     error InexistentToken();
2271     
2272     error MintPaused();
2273     error MintInactive();
2274     error InvalidProof();
2275 
2276     /// @dev For URI concatenation.
2277     using Strings for uint256;
2278 
2279     bytes32 public merkleRoot;
2280 
2281     string public baseURI = "ipfs://QmdkY9ttPBajrKeD5ssCPK1aUnwPygvKwerpRbDBsmzo6A/Hidden.json";
2282     
2283     uint32 publicSaleStartTime;
2284 
2285     uint256 public PRICE = 0.005 ether;
2286     uint256 public SUPPLY_MAX = 999;
2287 
2288     PresaleConfig public presaleConfig;
2289 
2290     bool public presalePaused;
2291     bool public publicSalePaused;
2292     bool public revealed;
2293 
2294     constructor(
2295         string memory _name,
2296         string memory _symbol
2297     ) ERC721A(_name, _symbol) payable {
2298         _safeMint(msg.sender, 1);
2299         presaleConfig = PresaleConfig({
2300             startTime: 1673278200, // 09th Jan 2023 15:30 UTC
2301             endTime: 1673285400  // 09th Jan 2023 17:30 UTC
2302         });
2303         publicSaleStartTime = 1673285400; // 09th Jan 2023 17:30 UTC
2304     }
2305 
2306     modifier mintCompliance() {
2307         if ((totalSupply() + 1) > SUPPLY_MAX) revert OutOfSupply();
2308         if (_numberMinted(msg.sender) > 0) revert ExceedsWalletLimit();
2309         if (msg.value < PRICE) revert InsufficientFunds();
2310         _;
2311     }
2312 
2313     function presaleMint(bytes32[] calldata _merkleProof)
2314         external
2315         payable
2316         mintCompliance() 
2317     {
2318         PresaleConfig memory config_ = presaleConfig;
2319         
2320         if (presalePaused) revert MintPaused();
2321         if (block.timestamp < config_.startTime || block.timestamp > config_.endTime) revert MintInactive();
2322 
2323         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2324         if (!MerkleProof.verify(_merkleProof, merkleRoot, leaf)) revert InvalidProof();
2325 
2326         _safeMint(msg.sender, 1);
2327     }
2328 
2329     function publicMint()
2330         external
2331         payable
2332         mintCompliance()
2333     {
2334         if (publicSalePaused) revert MintPaused();
2335         if (block.timestamp < publicSaleStartTime) revert MintInactive();
2336 
2337         _safeMint(msg.sender, 1);
2338     }
2339     
2340     /// @notice Airdrop for a single wallet.
2341     function mintForAddress(uint256 _mintAmount, address _receiver) external onlyOwner {
2342         _safeMint(_receiver, _mintAmount);
2343     }
2344 
2345     /// @notice Airdrops to multiple wallets.
2346     function batchMintForAddress(address[] calldata addresses, uint256[] calldata quantities) external onlyOwner {
2347         unchecked {
2348             uint32 i;
2349             for (i=0; i < addresses.length; ++i) {
2350                 _safeMint(addresses[i], quantities[i]);
2351             }
2352         }
2353     }
2354 
2355     function _startTokenId()
2356         internal
2357         view
2358         virtual
2359         override returns (uint256) 
2360     {
2361         return 1;
2362     }
2363 
2364     /// SETTERS ///
2365 
2366     function setRevealed(bool _state) external onlyOwner {
2367         revealed = _state;
2368     }
2369 
2370     function pausePublicSale(bool _state) external onlyOwner {
2371         publicSalePaused = _state;
2372     }
2373 
2374     function pausePresale(bool _state) external onlyOwner {
2375         presalePaused = _state;
2376     }
2377 
2378     function setPublicSaleStartTime(uint32 startTime_) external onlyOwner {
2379         publicSaleStartTime = startTime_;
2380     }
2381 
2382     function setPresaleStartTime(uint32 startTime_, uint32 endTime_) external onlyOwner {
2383         presaleConfig.startTime = startTime_;
2384         presaleConfig.endTime = endTime_;
2385     }
2386     
2387     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
2388         merkleRoot = merkleRoot_;
2389     }
2390 
2391     function setPrice(uint256 _price) external onlyOwner {
2392         PRICE = _price;
2393     }
2394 
2395     function setMaxSupply(uint256 _supply) external onlyOwner {
2396         SUPPLY_MAX = _supply;
2397     }
2398 
2399     function withdraw() external onlyOwner {
2400         payable(owner()).transfer(address(this).balance);
2401     }
2402     
2403     /// METADATA URI ///
2404 
2405     function _baseURI()
2406         internal 
2407         view 
2408         virtual
2409         override returns (string memory)
2410     {
2411         return baseURI;
2412     }
2413 
2414     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2415         baseURI = _newBaseURI;
2416     }
2417 
2418     /// @dev Returning concatenated URI with .json as suffix on the tokenID when revealed.
2419     function tokenURI(uint256 _tokenId)
2420         public
2421         view
2422         virtual
2423         override
2424         returns (string memory)
2425     {
2426         if (!_exists(_tokenId)) revert InexistentToken();
2427 
2428         if (!revealed) return _baseURI();
2429         return string(abi.encodePacked(_baseURI(), _tokenId.toString(), ".json"));
2430     }
2431 
2432     /// @dev Operator filtering
2433         function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2434         super.setApprovalForAll(operator, approved);
2435     }
2436 
2437     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2438         super.approve(operator, tokenId);
2439     }
2440 
2441     function transferFrom(address from, address to, uint256 tokenId) payable public override onlyAllowedOperator(from) {
2442         super.transferFrom(from, to, tokenId);
2443     }
2444 
2445     function safeTransferFrom(address from, address to, uint256 tokenId) payable public override onlyAllowedOperator(from) {
2446         super.safeTransferFrom(from, to, tokenId);
2447     }
2448 
2449     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2450         payable 
2451         public
2452         override
2453         onlyAllowedOperator(from)
2454     {
2455         super.safeTransferFrom(from, to, tokenId, data);
2456     }
2457 }