1 // SPDX-License-Identifier: MIT
2 // File: contracts/Baseball Cap A/IOperatorFilterRegistry.sol
3 
4 
5 pragma solidity ^0.8.0;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function unregister(address addr) external;
13     function updateOperator(address registrant, address operator, bool filtered) external;
14     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
15     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
16     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
17     function subscribe(address registrant, address registrantToSubscribe) external;
18     function unsubscribe(address registrant, bool copyExistingEntries) external;
19     function subscriptionOf(address addr) external returns (address registrant);
20     function subscribers(address registrant) external returns (address[] memory);
21     function subscriberAt(address registrant, uint256 index) external returns (address);
22     function copyEntriesOf(address registrant, address registrantToCopy) external;
23     function isOperatorFiltered(address registrant, address operator) external returns (bool);
24     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
25     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
26     function filteredOperators(address addr) external returns (address[] memory);
27     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
28     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
29     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
30     function isRegistered(address addr) external returns (bool);
31     function codeHashOf(address addr) external returns (bytes32);
32 }
33 // File: contracts/Baseball Cap A/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.0;
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
94 // File: contracts/Baseball Cap A/DefaultOperatorFilterer.sol
95 
96 
97 pragma solidity ^0.8.0;
98 
99 
100 /**
101  * @title  DefaultOperatorFilterer
102  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
103  */
104 abstract contract DefaultOperatorFilterer is OperatorFilterer {
105     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
106 
107     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
108 }
109 // File: erc721a/contracts/IERC721A.sol
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
394 // File: erc721a/contracts/ERC721A.sol
395 
396 
397 // ERC721A Contracts v4.2.3
398 // Creator: Chiru Labs
399 
400 pragma solidity ^0.8.4;
401 
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
1487 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1488 
1489 
1490 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1491 
1492 pragma solidity ^0.8.0;
1493 
1494 /**
1495  * @dev Interface of the ERC165 standard, as defined in the
1496  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1497  *
1498  * Implementers can declare support of contract interfaces, which can then be
1499  * queried by others ({ERC165Checker}).
1500  *
1501  * For an implementation, see {ERC165}.
1502  */
1503 interface IERC165 {
1504     /**
1505      * @dev Returns true if this contract implements the interface defined by
1506      * `interfaceId`. See the corresponding
1507      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1508      * to learn more about how these ids are created.
1509      *
1510      * This function call must use less than 30 000 gas.
1511      */
1512     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1513 }
1514 
1515 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1516 
1517 
1518 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1519 
1520 pragma solidity ^0.8.0;
1521 
1522 
1523 /**
1524  * @dev Implementation of the {IERC165} interface.
1525  *
1526  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1527  * for the additional interface id that will be supported. For example:
1528  *
1529  * ```solidity
1530  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1531  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1532  * }
1533  * ```
1534  *
1535  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1536  */
1537 abstract contract ERC165 is IERC165 {
1538     /**
1539      * @dev See {IERC165-supportsInterface}.
1540      */
1541     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1542         return interfaceId == type(IERC165).interfaceId;
1543     }
1544 }
1545 
1546 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1547 
1548 
1549 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1550 
1551 pragma solidity ^0.8.0;
1552 
1553 
1554 /**
1555  * @dev Interface for the NFT Royalty Standard.
1556  *
1557  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1558  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1559  *
1560  * _Available since v4.5._
1561  */
1562 interface IERC2981 is IERC165 {
1563     /**
1564      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1565      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1566      */
1567     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1568         external
1569         view
1570         returns (address receiver, uint256 royaltyAmount);
1571 }
1572 
1573 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1574 
1575 
1576 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1577 
1578 pragma solidity ^0.8.0;
1579 
1580 
1581 
1582 /**
1583  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1584  *
1585  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1586  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1587  *
1588  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1589  * fee is specified in basis points by default.
1590  *
1591  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1592  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1593  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1594  *
1595  * _Available since v4.5._
1596  */
1597 abstract contract ERC2981 is IERC2981, ERC165 {
1598     struct RoyaltyInfo {
1599         address receiver;
1600         uint96 royaltyFraction;
1601     }
1602 
1603     RoyaltyInfo private _defaultRoyaltyInfo;
1604     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1605 
1606     /**
1607      * @dev See {IERC165-supportsInterface}.
1608      */
1609     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1610         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1611     }
1612 
1613     /**
1614      * @inheritdoc IERC2981
1615      */
1616     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1617         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1618 
1619         if (royalty.receiver == address(0)) {
1620             royalty = _defaultRoyaltyInfo;
1621         }
1622 
1623         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1624 
1625         return (royalty.receiver, royaltyAmount);
1626     }
1627 
1628     /**
1629      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1630      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1631      * override.
1632      */
1633     function _feeDenominator() internal pure virtual returns (uint96) {
1634         return 10000;
1635     }
1636 
1637     /**
1638      * @dev Sets the royalty information that all ids in this contract will default to.
1639      *
1640      * Requirements:
1641      *
1642      * - `receiver` cannot be the zero address.
1643      * - `feeNumerator` cannot be greater than the fee denominator.
1644      */
1645     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1646         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1647         require(receiver != address(0), "ERC2981: invalid receiver");
1648 
1649         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1650     }
1651 
1652     /**
1653      * @dev Removes default royalty information.
1654      */
1655     function _deleteDefaultRoyalty() internal virtual {
1656         delete _defaultRoyaltyInfo;
1657     }
1658 
1659     /**
1660      * @dev Sets the royalty information for a specific token id, overriding the global default.
1661      *
1662      * Requirements:
1663      *
1664      * - `receiver` cannot be the zero address.
1665      * - `feeNumerator` cannot be greater than the fee denominator.
1666      */
1667     function _setTokenRoyalty(
1668         uint256 tokenId,
1669         address receiver,
1670         uint96 feeNumerator
1671     ) internal virtual {
1672         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1673         require(receiver != address(0), "ERC2981: Invalid parameters");
1674 
1675         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1676     }
1677 
1678     /**
1679      * @dev Resets royalty information for the token id back to the global default.
1680      */
1681     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1682         delete _tokenRoyaltyInfo[tokenId];
1683     }
1684 }
1685 
1686 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1687 
1688 
1689 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1690 
1691 pragma solidity ^0.8.0;
1692 
1693 // CAUTION
1694 // This version of SafeMath should only be used with Solidity 0.8 or later,
1695 // because it relies on the compiler's built in overflow checks.
1696 
1697 /**
1698  * @dev Wrappers over Solidity's arithmetic operations.
1699  *
1700  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1701  * now has built in overflow checking.
1702  */
1703 library SafeMath {
1704     /**
1705      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1706      *
1707      * _Available since v3.4._
1708      */
1709     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1710         unchecked {
1711             uint256 c = a + b;
1712             if (c < a) return (false, 0);
1713             return (true, c);
1714         }
1715     }
1716 
1717     /**
1718      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1719      *
1720      * _Available since v3.4._
1721      */
1722     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1723         unchecked {
1724             if (b > a) return (false, 0);
1725             return (true, a - b);
1726         }
1727     }
1728 
1729     /**
1730      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1731      *
1732      * _Available since v3.4._
1733      */
1734     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1735         unchecked {
1736             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1737             // benefit is lost if 'b' is also tested.
1738             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1739             if (a == 0) return (true, 0);
1740             uint256 c = a * b;
1741             if (c / a != b) return (false, 0);
1742             return (true, c);
1743         }
1744     }
1745 
1746     /**
1747      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1748      *
1749      * _Available since v3.4._
1750      */
1751     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1752         unchecked {
1753             if (b == 0) return (false, 0);
1754             return (true, a / b);
1755         }
1756     }
1757 
1758     /**
1759      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1760      *
1761      * _Available since v3.4._
1762      */
1763     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1764         unchecked {
1765             if (b == 0) return (false, 0);
1766             return (true, a % b);
1767         }
1768     }
1769 
1770     /**
1771      * @dev Returns the addition of two unsigned integers, reverting on
1772      * overflow.
1773      *
1774      * Counterpart to Solidity's `+` operator.
1775      *
1776      * Requirements:
1777      *
1778      * - Addition cannot overflow.
1779      */
1780     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1781         return a + b;
1782     }
1783 
1784     /**
1785      * @dev Returns the subtraction of two unsigned integers, reverting on
1786      * overflow (when the result is negative).
1787      *
1788      * Counterpart to Solidity's `-` operator.
1789      *
1790      * Requirements:
1791      *
1792      * - Subtraction cannot overflow.
1793      */
1794     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1795         return a - b;
1796     }
1797 
1798     /**
1799      * @dev Returns the multiplication of two unsigned integers, reverting on
1800      * overflow.
1801      *
1802      * Counterpart to Solidity's `*` operator.
1803      *
1804      * Requirements:
1805      *
1806      * - Multiplication cannot overflow.
1807      */
1808     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1809         return a * b;
1810     }
1811 
1812     /**
1813      * @dev Returns the integer division of two unsigned integers, reverting on
1814      * division by zero. The result is rounded towards zero.
1815      *
1816      * Counterpart to Solidity's `/` operator.
1817      *
1818      * Requirements:
1819      *
1820      * - The divisor cannot be zero.
1821      */
1822     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1823         return a / b;
1824     }
1825 
1826     /**
1827      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1828      * reverting when dividing by zero.
1829      *
1830      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1831      * opcode (which leaves remaining gas untouched) while Solidity uses an
1832      * invalid opcode to revert (consuming all remaining gas).
1833      *
1834      * Requirements:
1835      *
1836      * - The divisor cannot be zero.
1837      */
1838     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1839         return a % b;
1840     }
1841 
1842     /**
1843      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1844      * overflow (when the result is negative).
1845      *
1846      * CAUTION: This function is deprecated because it requires allocating memory for the error
1847      * message unnecessarily. For custom revert reasons use {trySub}.
1848      *
1849      * Counterpart to Solidity's `-` operator.
1850      *
1851      * Requirements:
1852      *
1853      * - Subtraction cannot overflow.
1854      */
1855     function sub(
1856         uint256 a,
1857         uint256 b,
1858         string memory errorMessage
1859     ) internal pure returns (uint256) {
1860         unchecked {
1861             require(b <= a, errorMessage);
1862             return a - b;
1863         }
1864     }
1865 
1866     /**
1867      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1868      * division by zero. The result is rounded towards zero.
1869      *
1870      * Counterpart to Solidity's `/` operator. Note: this function uses a
1871      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1872      * uses an invalid opcode to revert (consuming all remaining gas).
1873      *
1874      * Requirements:
1875      *
1876      * - The divisor cannot be zero.
1877      */
1878     function div(
1879         uint256 a,
1880         uint256 b,
1881         string memory errorMessage
1882     ) internal pure returns (uint256) {
1883         unchecked {
1884             require(b > 0, errorMessage);
1885             return a / b;
1886         }
1887     }
1888 
1889     /**
1890      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1891      * reverting with custom message when dividing by zero.
1892      *
1893      * CAUTION: This function is deprecated because it requires allocating memory for the error
1894      * message unnecessarily. For custom revert reasons use {tryMod}.
1895      *
1896      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1897      * opcode (which leaves remaining gas untouched) while Solidity uses an
1898      * invalid opcode to revert (consuming all remaining gas).
1899      *
1900      * Requirements:
1901      *
1902      * - The divisor cannot be zero.
1903      */
1904     function mod(
1905         uint256 a,
1906         uint256 b,
1907         string memory errorMessage
1908     ) internal pure returns (uint256) {
1909         unchecked {
1910             require(b > 0, errorMessage);
1911             return a % b;
1912         }
1913     }
1914 }
1915 
1916 // File: @openzeppelin/contracts/utils/Strings.sol
1917 
1918 
1919 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1920 
1921 pragma solidity ^0.8.0;
1922 
1923 /**
1924  * @dev String operations.
1925  */
1926 library Strings {
1927     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1928 
1929     /**
1930      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1931      */
1932     function toString(uint256 value) internal pure returns (string memory) {
1933         // Inspired by OraclizeAPI's implementation - MIT licence
1934         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1935 
1936         if (value == 0) {
1937             return "0";
1938         }
1939         uint256 temp = value;
1940         uint256 digits;
1941         while (temp != 0) {
1942             digits++;
1943             temp /= 10;
1944         }
1945         bytes memory buffer = new bytes(digits);
1946         while (value != 0) {
1947             digits -= 1;
1948             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1949             value /= 10;
1950         }
1951         return string(buffer);
1952     }
1953 
1954     /**
1955      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1956      */
1957     function toHexString(uint256 value) internal pure returns (string memory) {
1958         if (value == 0) {
1959             return "0x00";
1960         }
1961         uint256 temp = value;
1962         uint256 length = 0;
1963         while (temp != 0) {
1964             length++;
1965             temp >>= 8;
1966         }
1967         return toHexString(value, length);
1968     }
1969 
1970     /**
1971      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1972      */
1973     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1974         bytes memory buffer = new bytes(2 * length + 2);
1975         buffer[0] = "0";
1976         buffer[1] = "x";
1977         for (uint256 i = 2 * length + 1; i > 1; --i) {
1978             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1979             value >>= 4;
1980         }
1981         require(value == 0, "Strings: hex length insufficient");
1982         return string(buffer);
1983     }
1984 }
1985 
1986 // File: @openzeppelin/contracts/utils/Context.sol
1987 
1988 
1989 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1990 
1991 pragma solidity ^0.8.0;
1992 
1993 /**
1994  * @dev Provides information about the current execution context, including the
1995  * sender of the transaction and its data. While these are generally available
1996  * via msg.sender and msg.data, they should not be accessed in such a direct
1997  * manner, since when dealing with meta-transactions the account sending and
1998  * paying for execution may not be the actual sender (as far as an application
1999  * is concerned).
2000  *
2001  * This contract is only required for intermediate, library-like contracts.
2002  */
2003 abstract contract Context {
2004     function _msgSender() internal view virtual returns (address) {
2005         return msg.sender;
2006     }
2007 
2008     function _msgData() internal view virtual returns (bytes calldata) {
2009         return msg.data;
2010     }
2011 }
2012 
2013 // File: @openzeppelin/contracts/access/Ownable.sol
2014 
2015 
2016 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2017 
2018 pragma solidity ^0.8.0;
2019 
2020 
2021 /**
2022  * @dev Contract module which provides a basic access control mechanism, where
2023  * there is an account (an owner) that can be granted exclusive access to
2024  * specific functions.
2025  *
2026  * By default, the owner account will be the one that deploys the contract. This
2027  * can later be changed with {transferOwnership}.
2028  *
2029  * This module is used through inheritance. It will make available the modifier
2030  * `onlyOwner`, which can be applied to your functions to restrict their use to
2031  * the owner.
2032  */
2033 abstract contract Ownable is Context {
2034     address private _owner;
2035 
2036     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2037 
2038     /**
2039      * @dev Initializes the contract setting the deployer as the initial owner.
2040      */
2041     constructor() {
2042         _transferOwnership(_msgSender());
2043     }
2044 
2045     /**
2046      * @dev Returns the address of the current owner.
2047      */
2048     function owner() public view virtual returns (address) {
2049         return _owner;
2050     }
2051 
2052     /**
2053      * @dev Throws if called by any account other than the owner.
2054      */
2055     modifier onlyOwner() {
2056         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2057         _;
2058     }
2059 
2060     /**
2061      * @dev Leaves the contract without owner. It will not be possible to call
2062      * `onlyOwner` functions anymore. Can only be called by the current owner.
2063      *
2064      * NOTE: Renouncing ownership will leave the contract without an owner,
2065      * thereby removing any functionality that is only available to the owner.
2066      */
2067     function renounceOwnership() public virtual onlyOwner {
2068         _transferOwnership(address(0));
2069     }
2070 
2071     /**
2072      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2073      * Can only be called by the current owner.
2074      */
2075     function transferOwnership(address newOwner) public virtual onlyOwner {
2076         require(newOwner != address(0), "Ownable: new owner is the zero address");
2077         _transferOwnership(newOwner);
2078     }
2079 
2080     /**
2081      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2082      * Internal function without access restriction.
2083      */
2084     function _transferOwnership(address newOwner) internal virtual {
2085         address oldOwner = _owner;
2086         _owner = newOwner;
2087         emit OwnershipTransferred(oldOwner, newOwner);
2088     }
2089 }
2090 
2091 // File: contracts/Baseball Cap A/BaseballCapA .sol
2092 
2093 
2094 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2095 
2096 pragma solidity ^0.8.0;
2097 
2098 
2099 
2100 
2101 
2102 
2103 
2104 
2105 contract BaseballCapA is ERC721A, ERC2981, Ownable, DefaultOperatorFilterer {
2106     using SafeMath for uint256;
2107 
2108     uint256 public constant MAX_SUPPLY = 20000;
2109     uint256 public constant FREE_SUPPLY = 3;
2110     uint256 public constant PAID_SUPPLY = 10;
2111 
2112     uint256 private _flag;
2113     string private _defTokenURI = "https://ipfs.io/ipfs/QmaaCw2NsxM4So1V9sTsTHUeuLZXK11QjbCPLCEEf7zj5w";
2114     string private _baseTokenURI = "";
2115 
2116     mapping(address => bool) private _hasMinted;
2117 
2118     event NewMint(address indexed msgSender, uint256 indexed mintQuantity);
2119 
2120     constructor() ERC721A("ABaseballCap", "ABC") {
2121         _setDefaultRoyalty(msg.sender, 0);
2122     }
2123 
2124     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981)
2125     returns (bool) {
2126       return super.supportsInterface(interfaceId);
2127     }
2128 
2129     function _startTokenId() internal view override virtual returns (uint256) {
2130         return 1;
2131     }
2132 
2133     function transferOut(address _to) public onlyOwner {
2134         uint256 balance = address(this).balance;
2135         payable(_to).transfer(balance);
2136     }
2137 
2138     function changeTokenURIFlag(uint256 flag) external onlyOwner {
2139         _flag = flag;
2140     }
2141 
2142     function changeDefURI(string calldata _tokenURI) external onlyOwner {
2143         _defTokenURI = _tokenURI;
2144     }
2145 
2146     function changeURI(string calldata _tokenURI) external onlyOwner {
2147         _baseTokenURI = _tokenURI;
2148     }
2149 
2150     function _baseURI() internal view virtual override returns (string memory) {
2151         return _baseTokenURI;
2152     }
2153 
2154     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2155         if (_flag == 0) {
2156             return _defTokenURI;
2157         } else {
2158             require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2159             return string(abi.encodePacked(_baseTokenURI, Strings.toString(tokenId)));
2160         }
2161     }
2162 
2163     function mint(uint256 quantity) public payable {
2164         require(totalSupply() + quantity <= MAX_SUPPLY, "ERC721: Exceeds maximum supply");
2165         require(quantity == 1 || quantity == FREE_SUPPLY || quantity == PAID_SUPPLY, "ERC721: Invalid quantity");
2166 
2167         if (quantity <= FREE_SUPPLY ) {
2168             _safeMint(msg.sender,quantity);
2169         } else {
2170             require(msg.value >= 0.0001 ether, "ERC721: Insufficient payment");
2171             _safeMint(msg.sender,quantity);
2172         }
2173         
2174         emit NewMint(msg.sender, quantity);
2175     }
2176 
2177 }