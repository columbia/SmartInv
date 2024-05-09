1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.13;
4 
5 interface IOperatorFilterRegistry {
6     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
7     function register(address registrant) external;
8     function registerAndSubscribe(address registrant, address subscription) external;
9     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
10     function unregister(address addr) external;
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }
31 
32 
33 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/OperatorFilterer.sol
34 
35 pragma solidity ^0.8.13;
36 
37 /**
38  * @title  OperatorFilterer
39  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
40  *         registrant's entries in the OperatorFilterRegistry.
41  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
42  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
43  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
44  */
45 
46 abstract contract OperatorFilterer {
47     error OperatorNotAllowed(address operator);
48 
49     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
50         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
51 
52     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
53         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
54         // will not revert, but the contract will need to be registered with the registry once it is deployed in
55         // order for the modifier to filter addresses.
56         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
57             if (subscribe) {
58                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
59             } else {
60                 if (subscriptionOrRegistrantToCopy != address(0)) {
61                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
62                 } else {
63                     OPERATOR_FILTER_REGISTRY.register(address(this));
64                 }
65             }
66         }
67     }
68 
69     modifier onlyAllowedOperator(address from) virtual {
70         // Check registry code length to facilitate testing in environments without a deployed registry.
71         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
72             // Allow spending tokens from addresses with balance
73             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
74             // from an EOA.
75             if (from == msg.sender) {
76                 _;
77                 return;
78             }
79             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
80                 revert OperatorNotAllowed(msg.sender);
81             }
82         }
83         _;
84     }
85 
86     modifier onlyAllowedOperatorApproval(address operator) virtual {
87         // Check registry code length to facilitate testing in environments without a deployed registry.
88         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
89             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
90                 revert OperatorNotAllowed(operator);
91             }
92         }
93         _;
94     }
95 }
96 
97 
98 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/DefaultOperatorFilterer.sol
99 
100 pragma solidity ^0.8.13;
101 
102 /**
103  * @title  DefaultOperatorFilterer
104  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
105  */
106 abstract contract DefaultOperatorFilterer is OperatorFilterer {
107     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 
112 pragma solidity ^0.8.13;
113 
114 // File: erc721a/contracts/IERC721A.sol
115 
116 // ERC721A Contracts v4.2.3
117 // Creator: Chiru Labs
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
396 
397 // File: erc721a/contracts/ERC721A.sol
398 
399 // ERC721A Contracts v4.2.3
400 // Creator: Chiru Labs
401 
402 pragma solidity ^0.8.4;
403 
404 /**
405  * @dev Interface of ERC721 token receiver.
406  */
407 interface ERC721A__IERC721Receiver {
408     function onERC721Received(
409         address operator,
410         address from,
411         uint256 tokenId,
412         bytes calldata data
413     ) external returns (bytes4);
414 }
415 
416 /**
417  * @title ERC721A
418  *
419  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
420  * Non-Fungible Token Standard, including the Metadata extension.
421  * Optimized for lower gas during batch mints.
422  *
423  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
424  * starting from `_startTokenId()`.
425  *
426  * Assumptions:
427  *
428  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
429  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
430  */
431 contract ERC721A is IERC721A {
432     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
433     struct TokenApprovalRef {
434         address value;
435     }
436 
437     // =============================================================
438     //                           CONSTANTS
439     // =============================================================
440 
441     // Mask of an entry in packed address data.
442     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
443 
444     // The bit position of `numberMinted` in packed address data.
445     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
446 
447     // The bit position of `numberBurned` in packed address data.
448     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
449 
450     // The bit position of `aux` in packed address data.
451     uint256 private constant _BITPOS_AUX = 192;
452 
453     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
454     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
455 
456     // The bit position of `startTimestamp` in packed ownership.
457     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
458 
459     // The bit mask of the `burned` bit in packed ownership.
460     uint256 private constant _BITMASK_BURNED = 1 << 224;
461 
462     // The bit position of the `nextInitialized` bit in packed ownership.
463     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
464 
465     // The bit mask of the `nextInitialized` bit in packed ownership.
466     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
467 
468     // The bit position of `extraData` in packed ownership.
469     uint256 private constant _BITPOS_EXTRA_DATA = 232;
470 
471     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
472     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
473 
474     // The mask of the lower 160 bits for addresses.
475     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
476 
477     // The maximum `quantity` that can be minted with {_mintERC2309}.
478     // This limit is to prevent overflows on the address data entries.
479     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
480     // is required to cause an overflow, which is unrealistic.
481     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
482 
483     // The `Transfer` event signature is given by:
484     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
485     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
486         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
487 
488     // =============================================================
489     //                            STORAGE
490     // =============================================================
491 
492     // The next token ID to be minted.
493     uint256 private _currentIndex;
494 
495     // The number of tokens burned.
496     uint256 private _burnCounter;
497 
498     // Token name
499     string private _name;
500 
501     // Token symbol
502     string private _symbol;
503 
504     // Mapping from token ID to ownership details
505     // An empty struct value does not necessarily mean the token is unowned.
506     // See {_packedOwnershipOf} implementation for details.
507     //
508     // Bits Layout:
509     // - [0..159]   `addr`
510     // - [160..223] `startTimestamp`
511     // - [224]      `burned`
512     // - [225]      `nextInitialized`
513     // - [232..255] `extraData`
514     mapping(uint256 => uint256) private _packedOwnerships;
515 
516     // Mapping owner address to address data.
517     //
518     // Bits Layout:
519     // - [0..63]    `balance`
520     // - [64..127]  `numberMinted`
521     // - [128..191] `numberBurned`
522     // - [192..255] `aux`
523     mapping(address => uint256) private _packedAddressData;
524 
525     // Mapping from token ID to approved address.
526     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
527 
528     // Mapping from owner to operator approvals
529     mapping(address => mapping(address => bool)) private _operatorApprovals;
530 
531     // =============================================================
532     //                          CONSTRUCTOR
533     // =============================================================
534 
535     constructor(string memory name_, string memory symbol_) {
536         _name = name_;
537         _symbol = symbol_;
538         _currentIndex = _startTokenId();
539     }
540 
541     // =============================================================
542     //                   TOKEN COUNTING OPERATIONS
543     // =============================================================
544 
545     /**
546      * @dev Returns the starting token ID.
547      * To change the starting token ID, please override this function.
548      */
549     function _startTokenId() internal view virtual returns (uint256) {
550         return 0;
551     }
552 
553     /**
554      * @dev Returns the next token ID to be minted.
555      */
556     function _nextTokenId() internal view virtual returns (uint256) {
557         return _currentIndex;
558     }
559 
560     /**
561      * @dev Returns the total number of tokens in existence.
562      * Burned tokens will reduce the count.
563      * To get the total number of tokens minted, please see {_totalMinted}.
564      */
565     function totalSupply() public view virtual override returns (uint256) {
566         // Counter underflow is impossible as _burnCounter cannot be incremented
567         // more than `_currentIndex - _startTokenId()` times.
568         unchecked {
569             return _currentIndex - _burnCounter - _startTokenId();
570         }
571     }
572 
573     /**
574      * @dev Returns the total amount of tokens minted in the contract.
575      */
576     function _totalMinted() internal view virtual returns (uint256) {
577         // Counter underflow is impossible as `_currentIndex` does not decrement,
578         // and it is initialized to `_startTokenId()`.
579         unchecked {
580             return _currentIndex - _startTokenId();
581         }
582     }
583 
584     /**
585      * @dev Returns the total number of tokens burned.
586      */
587     function _totalBurned() internal view virtual returns (uint256) {
588         return _burnCounter;
589     }
590 
591     // =============================================================
592     //                    ADDRESS DATA OPERATIONS
593     // =============================================================
594 
595     /**
596      * @dev Returns the number of tokens in `owner`'s account.
597      */
598     function balanceOf(address owner) public view virtual override returns (uint256) {
599         if (owner == address(0)) revert BalanceQueryForZeroAddress();
600         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
601     }
602 
603     /**
604      * Returns the number of tokens minted by `owner`.
605      */
606     function _numberMinted(address owner) internal view returns (uint256) {
607         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
608     }
609 
610     /**
611      * Returns the number of tokens burned by or on behalf of `owner`.
612      */
613     function _numberBurned(address owner) internal view returns (uint256) {
614         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
615     }
616 
617     /**
618      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
619      */
620     function _getAux(address owner) internal view returns (uint64) {
621         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
622     }
623 
624     /**
625      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
626      * If there are multiple variables, please pack them into a uint64.
627      */
628     function _setAux(address owner, uint64 aux) internal virtual {
629         uint256 packed = _packedAddressData[owner];
630         uint256 auxCasted;
631         // Cast `aux` with assembly to avoid redundant masking.
632         assembly {
633             auxCasted := aux
634         }
635         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
636         _packedAddressData[owner] = packed;
637     }
638 
639     // =============================================================
640     //                            IERC165
641     // =============================================================
642 
643     /**
644      * @dev Returns true if this contract implements the interface defined by
645      * `interfaceId`. See the corresponding
646      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
647      * to learn more about how these ids are created.
648      *
649      * This function call must use less than 30000 gas.
650      */
651     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
652         // The interface IDs are constants representing the first 4 bytes
653         // of the XOR of all function selectors in the interface.
654         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
655         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
656         return
657             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
658             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
659             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
660     }
661 
662     // =============================================================
663     //                        IERC721Metadata
664     // =============================================================
665 
666     /**
667      * @dev Returns the token collection name.
668      */
669     function name() public view virtual override returns (string memory) {
670         return _name;
671     }
672 
673     /**
674      * @dev Returns the token collection symbol.
675      */
676     function symbol() public view virtual override returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
682      */
683     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
684         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
685 
686         string memory baseURI = _baseURI();
687         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
688     }
689 
690     /**
691      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
692      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
693      * by default, it can be overridden in child contracts.
694      */
695     function _baseURI() internal view virtual returns (string memory) {
696         return '';
697     }
698 
699     // =============================================================
700     //                     OWNERSHIPS OPERATIONS
701     // =============================================================
702 
703     /**
704      * @dev Returns the owner of the `tokenId` token.
705      *
706      * Requirements:
707      *
708      * - `tokenId` must exist.
709      */
710     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
711         return address(uint160(_packedOwnershipOf(tokenId)));
712     }
713 
714     /**
715      * @dev Gas spent here starts off proportional to the maximum mint batch size.
716      * It gradually moves to O(1) as tokens get transferred around over time.
717      */
718     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
719         return _unpackedOwnership(_packedOwnershipOf(tokenId));
720     }
721 
722     /**
723      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
724      */
725     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
726         return _unpackedOwnership(_packedOwnerships[index]);
727     }
728 
729     /**
730      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
731      */
732     function _initializeOwnershipAt(uint256 index) internal virtual {
733         if (_packedOwnerships[index] == 0) {
734             _packedOwnerships[index] = _packedOwnershipOf(index);
735         }
736     }
737 
738     /**
739      * Returns the packed ownership data of `tokenId`.
740      */
741     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
742         uint256 curr = tokenId;
743 
744         unchecked {
745             if (_startTokenId() <= curr)
746                 if (curr < _currentIndex) {
747                     uint256 packed = _packedOwnerships[curr];
748                     // If not burned.
749                     if (packed & _BITMASK_BURNED == 0) {
750                         // Invariant:
751                         // There will always be an initialized ownership slot
752                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
753                         // before an unintialized ownership slot
754                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
755                         // Hence, `curr` will not underflow.
756                         //
757                         // We can directly compare the packed value.
758                         // If the address is zero, packed will be zero.
759                         while (packed == 0) {
760                             packed = _packedOwnerships[--curr];
761                         }
762                         return packed;
763                     }
764                 }
765         }
766         revert OwnerQueryForNonexistentToken();
767     }
768 
769     /**
770      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
771      */
772     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
773         ownership.addr = address(uint160(packed));
774         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
775         ownership.burned = packed & _BITMASK_BURNED != 0;
776         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
777     }
778 
779     /**
780      * @dev Packs ownership data into a single uint256.
781      */
782     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
783         assembly {
784             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
785             owner := and(owner, _BITMASK_ADDRESS)
786             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
787             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
788         }
789     }
790 
791     /**
792      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
793      */
794     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
795         // For branchless setting of the `nextInitialized` flag.
796         assembly {
797             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
798             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
799         }
800     }
801 
802     // =============================================================
803     //                      APPROVAL OPERATIONS
804     // =============================================================
805 
806     /**
807      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
808      * The approval is cleared when the token is transferred.
809      *
810      * Only a single account can be approved at a time, so approving the
811      * zero address clears previous approvals.
812      *
813      * Requirements:
814      *
815      * - The caller must own the token or be an approved operator.
816      * - `tokenId` must exist.
817      *
818      * Emits an {Approval} event.
819      */
820     function approve(address to, uint256 tokenId) public payable virtual override {
821         address owner = ownerOf(tokenId);
822 
823         if (_msgSenderERC721A() != owner)
824             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
825                 revert ApprovalCallerNotOwnerNorApproved();
826             }
827 
828         _tokenApprovals[tokenId].value = to;
829         emit Approval(owner, to, tokenId);
830     }
831 
832     /**
833      * @dev Returns the account approved for `tokenId` token.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must exist.
838      */
839     function getApproved(uint256 tokenId) public view virtual override returns (address) {
840         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
841 
842         return _tokenApprovals[tokenId].value;
843     }
844 
845     /**
846      * @dev Approve or remove `operator` as an operator for the caller.
847      * Operators can call {transferFrom} or {safeTransferFrom}
848      * for any token owned by the caller.
849      *
850      * Requirements:
851      *
852      * - The `operator` cannot be the caller.
853      *
854      * Emits an {ApprovalForAll} event.
855      */
856     function setApprovalForAll(address operator, bool approved) public virtual override {
857         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
858         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
859     }
860 
861     /**
862      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
863      *
864      * See {setApprovalForAll}.
865      */
866     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
867         return _operatorApprovals[owner][operator];
868     }
869 
870     /**
871      * @dev Returns whether `tokenId` exists.
872      *
873      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
874      *
875      * Tokens start existing when they are minted. See {_mint}.
876      */
877     function _exists(uint256 tokenId) internal view virtual returns (bool) {
878         return
879             _startTokenId() <= tokenId &&
880             tokenId < _currentIndex && // If within bounds,
881             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
882     }
883 
884     /**
885      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
886      */
887     function _isSenderApprovedOrOwner(
888         address approvedAddress,
889         address owner,
890         address msgSender
891     ) private pure returns (bool result) {
892         assembly {
893             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
894             owner := and(owner, _BITMASK_ADDRESS)
895             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
896             msgSender := and(msgSender, _BITMASK_ADDRESS)
897             // `msgSender == owner || msgSender == approvedAddress`.
898             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
899         }
900     }
901 
902     /**
903      * @dev Returns the storage slot and value for the approved address of `tokenId`.
904      */
905     function _getApprovedSlotAndAddress(uint256 tokenId)
906         private
907         view
908         returns (uint256 approvedAddressSlot, address approvedAddress)
909     {
910         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
911         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
912         assembly {
913             approvedAddressSlot := tokenApproval.slot
914             approvedAddress := sload(approvedAddressSlot)
915         }
916     }
917 
918     // =============================================================
919     //                      TRANSFER OPERATIONS
920     // =============================================================
921 
922     /**
923      * @dev Transfers `tokenId` from `from` to `to`.
924      *
925      * Requirements:
926      *
927      * - `from` cannot be the zero address.
928      * - `to` cannot be the zero address.
929      * - `tokenId` token must be owned by `from`.
930      * - If the caller is not `from`, it must be approved to move this token
931      * by either {approve} or {setApprovalForAll}.
932      *
933      * Emits a {Transfer} event.
934      */
935     function transferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public payable virtual override {
940         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
941 
942         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
943 
944         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
945 
946         // The nested ifs save around 20+ gas over a compound boolean condition.
947         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
948             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
949 
950         if (to == address(0)) revert TransferToZeroAddress();
951 
952         _beforeTokenTransfers(from, to, tokenId, 1);
953 
954         // Clear approvals from the previous owner.
955         assembly {
956             if approvedAddress {
957                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
958                 sstore(approvedAddressSlot, 0)
959             }
960         }
961 
962         // Underflow of the sender's balance is impossible because we check for
963         // ownership above and the recipient's balance can't realistically overflow.
964         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
965         unchecked {
966             // We can directly increment and decrement the balances.
967             --_packedAddressData[from]; // Updates: `balance -= 1`.
968             ++_packedAddressData[to]; // Updates: `balance += 1`.
969 
970             // Updates:
971             // - `address` to the next owner.
972             // - `startTimestamp` to the timestamp of transfering.
973             // - `burned` to `false`.
974             // - `nextInitialized` to `true`.
975             _packedOwnerships[tokenId] = _packOwnershipData(
976                 to,
977                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
978             );
979 
980             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
981             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
982                 uint256 nextTokenId = tokenId + 1;
983                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
984                 if (_packedOwnerships[nextTokenId] == 0) {
985                     // If the next slot is within bounds.
986                     if (nextTokenId != _currentIndex) {
987                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
988                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
989                     }
990                 }
991             }
992         }
993 
994         emit Transfer(from, to, tokenId);
995         _afterTokenTransfers(from, to, tokenId, 1);
996     }
997 
998     /**
999      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public payable virtual override {
1006         safeTransferFrom(from, to, tokenId, '');
1007     }
1008 
1009     /**
1010      * @dev Safely transfers `tokenId` token from `from` to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `from` cannot be the zero address.
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must exist and be owned by `from`.
1017      * - If the caller is not `from`, it must be approved to move this token
1018      * by either {approve} or {setApprovalForAll}.
1019      * - If `to` refers to a smart contract, it must implement
1020      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) public payable virtual override {
1030         transferFrom(from, to, tokenId);
1031         if (to.code.length != 0)
1032             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1033                 revert TransferToNonERC721ReceiverImplementer();
1034             }
1035     }
1036 
1037     /**
1038      * @dev Hook that is called before a set of serially-ordered token IDs
1039      * are about to be transferred. This includes minting.
1040      * And also called before burning one token.
1041      *
1042      * `startTokenId` - the first token ID to be transferred.
1043      * `quantity` - the amount to be transferred.
1044      *
1045      * Calling conditions:
1046      *
1047      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1048      * transferred to `to`.
1049      * - When `from` is zero, `tokenId` will be minted for `to`.
1050      * - When `to` is zero, `tokenId` will be burned by `from`.
1051      * - `from` and `to` are never both zero.
1052      */
1053     function _beforeTokenTransfers(
1054         address from,
1055         address to,
1056         uint256 startTokenId,
1057         uint256 quantity
1058     ) internal virtual {}
1059 
1060     /**
1061      * @dev Hook that is called after a set of serially-ordered token IDs
1062      * have been transferred. This includes minting.
1063      * And also called after one token has been burned.
1064      *
1065      * `startTokenId` - the first token ID to be transferred.
1066      * `quantity` - the amount to be transferred.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` has been minted for `to`.
1073      * - When `to` is zero, `tokenId` has been burned by `from`.
1074      * - `from` and `to` are never both zero.
1075      */
1076     function _afterTokenTransfers(
1077         address from,
1078         address to,
1079         uint256 startTokenId,
1080         uint256 quantity
1081     ) internal virtual {}
1082 
1083     /**
1084      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1085      *
1086      * `from` - Previous owner of the given token ID.
1087      * `to` - Target address that will receive the token.
1088      * `tokenId` - Token ID to be transferred.
1089      * `_data` - Optional data to send along with the call.
1090      *
1091      * Returns whether the call correctly returned the expected magic value.
1092      */
1093     function _checkContractOnERC721Received(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) private returns (bool) {
1099         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1100             bytes4 retval
1101         ) {
1102             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1103         } catch (bytes memory reason) {
1104             if (reason.length == 0) {
1105                 revert TransferToNonERC721ReceiverImplementer();
1106             } else {
1107                 assembly {
1108                     revert(add(32, reason), mload(reason))
1109                 }
1110             }
1111         }
1112     }
1113 
1114     // =============================================================
1115     //                        MINT OPERATIONS
1116     // =============================================================
1117 
1118     /**
1119      * @dev Mints `quantity` tokens and transfers them to `to`.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `quantity` must be greater than 0.
1125      *
1126      * Emits a {Transfer} event for each mint.
1127      */
1128     function _mint(address to, uint256 quantity) internal virtual {
1129         uint256 startTokenId = _currentIndex;
1130         if (quantity == 0) revert MintZeroQuantity();
1131 
1132         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1133 
1134         // Overflows are incredibly unrealistic.
1135         // `balance` and `numberMinted` have a maximum limit of 2**64.
1136         // `tokenId` has a maximum limit of 2**256.
1137         unchecked {
1138             // Updates:
1139             // - `balance += quantity`.
1140             // - `numberMinted += quantity`.
1141             //
1142             // We can directly add to the `balance` and `numberMinted`.
1143             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1144 
1145             // Updates:
1146             // - `address` to the owner.
1147             // - `startTimestamp` to the timestamp of minting.
1148             // - `burned` to `false`.
1149             // - `nextInitialized` to `quantity == 1`.
1150             _packedOwnerships[startTokenId] = _packOwnershipData(
1151                 to,
1152                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1153             );
1154 
1155             uint256 toMasked;
1156             uint256 end = startTokenId + quantity;
1157 
1158             // Use assembly to loop and emit the `Transfer` event for gas savings.
1159             // The duplicated `log4` removes an extra check and reduces stack juggling.
1160             // The assembly, together with the surrounding Solidity code, have been
1161             // delicately arranged to nudge the compiler into producing optimized opcodes.
1162             assembly {
1163                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1164                 toMasked := and(to, _BITMASK_ADDRESS)
1165                 // Emit the `Transfer` event.
1166                 log4(
1167                     0, // Start of data (0, since no data).
1168                     0, // End of data (0, since no data).
1169                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1170                     0, // `address(0)`.
1171                     toMasked, // `to`.
1172                     startTokenId // `tokenId`.
1173                 )
1174 
1175                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1176                 // that overflows uint256 will make the loop run out of gas.
1177                 // The compiler will optimize the `iszero` away for performance.
1178                 for {
1179                     let tokenId := add(startTokenId, 1)
1180                 } iszero(eq(tokenId, end)) {
1181                     tokenId := add(tokenId, 1)
1182                 } {
1183                     // Emit the `Transfer` event. Similar to above.
1184                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1185                 }
1186             }
1187             if (toMasked == 0) revert MintToZeroAddress();
1188 
1189             _currentIndex = end;
1190         }
1191         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1192     }
1193 
1194     /**
1195      * @dev Mints `quantity` tokens and transfers them to `to`.
1196      *
1197      * This function is intended for efficient minting only during contract creation.
1198      *
1199      * It emits only one {ConsecutiveTransfer} as defined in
1200      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1201      * instead of a sequence of {Transfer} event(s).
1202      *
1203      * Calling this function outside of contract creation WILL make your contract
1204      * non-compliant with the ERC721 standard.
1205      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1206      * {ConsecutiveTransfer} event is only permissible during contract creation.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `quantity` must be greater than 0.
1212      *
1213      * Emits a {ConsecutiveTransfer} event.
1214      */
1215     function _mintERC2309(address to, uint256 quantity) internal virtual {
1216         uint256 startTokenId = _currentIndex;
1217         if (to == address(0)) revert MintToZeroAddress();
1218         if (quantity == 0) revert MintZeroQuantity();
1219         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1220 
1221         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1222 
1223         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1224         unchecked {
1225             // Updates:
1226             // - `balance += quantity`.
1227             // - `numberMinted += quantity`.
1228             //
1229             // We can directly add to the `balance` and `numberMinted`.
1230             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1231 
1232             // Updates:
1233             // - `address` to the owner.
1234             // - `startTimestamp` to the timestamp of minting.
1235             // - `burned` to `false`.
1236             // - `nextInitialized` to `quantity == 1`.
1237             _packedOwnerships[startTokenId] = _packOwnershipData(
1238                 to,
1239                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1240             );
1241 
1242             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1243 
1244             _currentIndex = startTokenId + quantity;
1245         }
1246         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1247     }
1248 
1249     /**
1250      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1251      *
1252      * Requirements:
1253      *
1254      * - If `to` refers to a smart contract, it must implement
1255      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1256      * - `quantity` must be greater than 0.
1257      *
1258      * See {_mint}.
1259      *
1260      * Emits a {Transfer} event for each mint.
1261      */
1262     function _safeMint(
1263         address to,
1264         uint256 quantity,
1265         bytes memory _data
1266     ) internal virtual {
1267         _mint(to, quantity);
1268 
1269         unchecked {
1270             if (to.code.length != 0) {
1271                 uint256 end = _currentIndex;
1272                 uint256 index = end - quantity;
1273                 do {
1274                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1275                         revert TransferToNonERC721ReceiverImplementer();
1276                     }
1277                 } while (index < end);
1278                 // Reentrancy protection.
1279                 if (_currentIndex != end) revert();
1280             }
1281         }
1282     }
1283 
1284     /**
1285      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1286      */
1287     function _safeMint(address to, uint256 quantity) internal virtual {
1288         _safeMint(to, quantity, '');
1289     }
1290 
1291     // =============================================================
1292     //                        BURN OPERATIONS
1293     // =============================================================
1294 
1295     /**
1296      * @dev Equivalent to `_burn(tokenId, false)`.
1297      */
1298     function _burn(uint256 tokenId) internal virtual {
1299         _burn(tokenId, false);
1300     }
1301 
1302     /**
1303      * @dev Destroys `tokenId`.
1304      * The approval is cleared when the token is burned.
1305      *
1306      * Requirements:
1307      *
1308      * - `tokenId` must exist.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1313         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1314 
1315         address from = address(uint160(prevOwnershipPacked));
1316 
1317         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1318 
1319         if (approvalCheck) {
1320             // The nested ifs save around 20+ gas over a compound boolean condition.
1321             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1322                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1323         }
1324 
1325         _beforeTokenTransfers(from, address(0), tokenId, 1);
1326 
1327         // Clear approvals from the previous owner.
1328         assembly {
1329             if approvedAddress {
1330                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1331                 sstore(approvedAddressSlot, 0)
1332             }
1333         }
1334 
1335         // Underflow of the sender's balance is impossible because we check for
1336         // ownership above and the recipient's balance can't realistically overflow.
1337         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1338         unchecked {
1339             // Updates:
1340             // - `balance -= 1`.
1341             // - `numberBurned += 1`.
1342             //
1343             // We can directly decrement the balance, and increment the number burned.
1344             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1345             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1346 
1347             // Updates:
1348             // - `address` to the last owner.
1349             // - `startTimestamp` to the timestamp of burning.
1350             // - `burned` to `true`.
1351             // - `nextInitialized` to `true`.
1352             _packedOwnerships[tokenId] = _packOwnershipData(
1353                 from,
1354                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1355             );
1356 
1357             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1358             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1359                 uint256 nextTokenId = tokenId + 1;
1360                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1361                 if (_packedOwnerships[nextTokenId] == 0) {
1362                     // If the next slot is within bounds.
1363                     if (nextTokenId != _currentIndex) {
1364                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1365                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1366                     }
1367                 }
1368             }
1369         }
1370 
1371         emit Transfer(from, address(0), tokenId);
1372         _afterTokenTransfers(from, address(0), tokenId, 1);
1373 
1374         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1375         unchecked {
1376             _burnCounter++;
1377         }
1378     }
1379 
1380     // =============================================================
1381     //                     EXTRA DATA OPERATIONS
1382     // =============================================================
1383 
1384     /**
1385      * @dev Directly sets the extra data for the ownership data `index`.
1386      */
1387     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1388         uint256 packed = _packedOwnerships[index];
1389         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1390         uint256 extraDataCasted;
1391         // Cast `extraData` with assembly to avoid redundant masking.
1392         assembly {
1393             extraDataCasted := extraData
1394         }
1395         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1396         _packedOwnerships[index] = packed;
1397     }
1398 
1399     /**
1400      * @dev Called during each token transfer to set the 24bit `extraData` field.
1401      * Intended to be overridden by the cosumer contract.
1402      *
1403      * `previousExtraData` - the value of `extraData` before transfer.
1404      *
1405      * Calling conditions:
1406      *
1407      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1408      * transferred to `to`.
1409      * - When `from` is zero, `tokenId` will be minted for `to`.
1410      * - When `to` is zero, `tokenId` will be burned by `from`.
1411      * - `from` and `to` are never both zero.
1412      */
1413     function _extraData(
1414         address from,
1415         address to,
1416         uint24 previousExtraData
1417     ) internal view virtual returns (uint24) {}
1418 
1419     /**
1420      * @dev Returns the next extra data for the packed ownership data.
1421      * The returned result is shifted into position.
1422      */
1423     function _nextExtraData(
1424         address from,
1425         address to,
1426         uint256 prevOwnershipPacked
1427     ) private view returns (uint256) {
1428         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1429         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1430     }
1431 
1432     // =============================================================
1433     //                       OTHER OPERATIONS
1434     // =============================================================
1435 
1436     /**
1437      * @dev Returns the message sender (defaults to `msg.sender`).
1438      *
1439      * If you are writing GSN compatible contracts, you need to override this function.
1440      */
1441     function _msgSenderERC721A() internal view virtual returns (address) {
1442         return msg.sender;
1443     }
1444 
1445     /**
1446      * @dev Converts a uint256 to its ASCII string decimal representation.
1447      */
1448     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1449         assembly {
1450             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1451             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1452             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1453             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1454             let m := add(mload(0x40), 0xa0)
1455             // Update the free memory pointer to allocate.
1456             mstore(0x40, m)
1457             // Assign the `str` to the end.
1458             str := sub(m, 0x20)
1459             // Zeroize the slot after the string.
1460             mstore(str, 0)
1461 
1462             // Cache the end of the memory to calculate the length later.
1463             let end := str
1464 
1465             // We write the string from rightmost digit to leftmost digit.
1466             // The following is essentially a do-while loop that also handles the zero case.
1467             // prettier-ignore
1468             for { let temp := value } 1 {} {
1469                 str := sub(str, 1)
1470                 // Write the character to the pointer.
1471                 // The ASCII index of the '0' character is 48.
1472                 mstore8(str, add(48, mod(temp, 10)))
1473                 // Keep dividing `temp` until zero.
1474                 temp := div(temp, 10)
1475                 // prettier-ignore
1476                 if iszero(temp) { break }
1477             }
1478 
1479             let length := sub(end, str)
1480             // Move the pointer 32 bytes leftwards to make room for the length.
1481             str := sub(str, 0x20)
1482             // Store the length.
1483             mstore(str, length)
1484         }
1485     }
1486 }
1487 
1488 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1489 
1490 
1491 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1492 
1493 pragma solidity ^0.8.0;
1494 
1495 /**
1496  * @dev Contract module that helps prevent reentrant calls to a function.
1497  *
1498  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1499  * available, which can be applied to functions to make sure there are no nested
1500  * (reentrant) calls to them.
1501  *
1502  * Note that because there is a single `nonReentrant` guard, functions marked as
1503  * `nonReentrant` may not call one another. This can be worked around by making
1504  * those functions `private`, and then adding `external` `nonReentrant` entry
1505  * points to them.
1506  *
1507  * TIP: If you would like to learn more about reentrancy and alternative ways
1508  * to protect against it, check out our blog post
1509  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1510  */
1511 abstract contract ReentrancyGuard {
1512     // Booleans are more expensive than uint256 or any type that takes up a full
1513     // word because each write operation emits an extra SLOAD to first read the
1514     // slot's contents, replace the bits taken up by the boolean, and then write
1515     // back. This is the compiler's defense against contract upgrades and
1516     // pointer aliasing, and it cannot be disabled.
1517 
1518     // The values being non-zero value makes deployment a bit more expensive,
1519     // but in exchange the refund on every call to nonReentrant will be lower in
1520     // amount. Since refunds are capped to a percentage of the total
1521     // transaction's gas, it is best to keep them low in cases like this one, to
1522     // increase the likelihood of the full refund coming into effect.
1523     uint256 private constant _NOT_ENTERED = 1;
1524     uint256 private constant _ENTERED = 2;
1525 
1526     uint256 private _status;
1527 
1528     constructor() {
1529         _status = _NOT_ENTERED;
1530     }
1531 
1532     /**
1533      * @dev Prevents a contract from calling itself, directly or indirectly.
1534      * Calling a `nonReentrant` function from another `nonReentrant`
1535      * function is not supported. It is possible to prevent this from happening
1536      * by making the `nonReentrant` function external, and making it call a
1537      * `private` function that does the actual work.
1538      */
1539     modifier nonReentrant() {
1540         _nonReentrantBefore();
1541         _;
1542         _nonReentrantAfter();
1543     }
1544 
1545     function _nonReentrantBefore() private {
1546         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1547         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1548 
1549         // Any calls to nonReentrant after this point will fail
1550         _status = _ENTERED;
1551     }
1552 
1553     function _nonReentrantAfter() private {
1554         // By storing the original value once again, a refund is triggered (see
1555         // https://eips.ethereum.org/EIPS/eip-2200)
1556         _status = _NOT_ENTERED;
1557     }
1558 }
1559 
1560 // File: @openzeppelin/contracts/utils/Context.sol
1561 
1562 
1563 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1564 
1565 pragma solidity ^0.8.0;
1566 
1567 /**
1568  * @dev Provides information about the current execution context, including the
1569  * sender of the transaction and its data. While these are generally available
1570  * via msg.sender and msg.data, they should not be accessed in such a direct
1571  * manner, since when dealing with meta-transactions the account sending and
1572  * paying for execution may not be the actual sender (as far as an application
1573  * is concerned).
1574  *
1575  * This contract is only required for intermediate, library-like contracts.
1576  */
1577 abstract contract Context {
1578     function _msgSender() internal view virtual returns (address) {
1579         return msg.sender;
1580     }
1581 
1582     function _msgData() internal view virtual returns (bytes calldata) {
1583         return msg.data;
1584     }
1585 }
1586 
1587 // File: @openzeppelin/contracts/access/Ownable.sol
1588 
1589 
1590 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1591 
1592 pragma solidity ^0.8.0;
1593 
1594 
1595 /**
1596  * @dev Contract module which provides a basic access control mechanism, where
1597  * there is an account (an owner) that can be granted exclusive access to
1598  * specific functions.
1599  *
1600  * By default, the owner account will be the one that deploys the contract. This
1601  * can later be changed with {transferOwnership}.
1602  *
1603  * This module is used through inheritance. It will make available the modifier
1604  * `onlyOwner`, which can be applied to your functions to restrict their use to
1605  * the owner.
1606  */
1607 abstract contract Ownable is Context {
1608     address private _owner;
1609 
1610     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1611 
1612     /**
1613      * @dev Initializes the contract setting the deployer as the initial owner.
1614      */
1615     constructor() {
1616         _transferOwnership(_msgSender());
1617     }
1618 
1619     /**
1620      * @dev Throws if called by any account other than the owner.
1621      */
1622     modifier onlyOwner() {
1623         _checkOwner();
1624         _;
1625     }
1626 
1627     /**
1628      * @dev Returns the address of the current owner.
1629      */
1630     function owner() public view virtual returns (address) {
1631         return _owner;
1632     }
1633 
1634     /**
1635      * @dev Throws if the sender is not the owner.
1636      */
1637     function _checkOwner() internal view virtual {
1638         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1639     }
1640 
1641     /**
1642      * @dev Leaves the contract without owner. It will not be possible to call
1643      * `onlyOwner` functions anymore. Can only be called by the current owner.
1644      *
1645      * NOTE: Renouncing ownership will leave the contract without an owner,
1646      * thereby removing any functionality that is only available to the owner.
1647      */
1648     function renounceOwnership() public virtual onlyOwner {
1649         _transferOwnership(address(0));
1650     }
1651 
1652     /**
1653      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1654      * Can only be called by the current owner.
1655      */
1656     function transferOwnership(address newOwner) public virtual onlyOwner {
1657         require(newOwner != address(0), "Ownable: new owner is the zero address");
1658         _transferOwnership(newOwner);
1659     }
1660 
1661     /**
1662      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1663      * Internal function without access restriction.
1664      */
1665     function _transferOwnership(address newOwner) internal virtual {
1666         address oldOwner = _owner;
1667         _owner = newOwner;
1668         emit OwnershipTransferred(oldOwner, newOwner);
1669     }
1670 }
1671 
1672 
1673 pragma solidity ^0.8.13;
1674 
1675 contract Darkflex is ERC721A, Ownable, DefaultOperatorFilterer, ReentrancyGuard {
1676     
1677     uint256 public maxSupply = 6666;
1678     uint256 public maxSupplyForPublic = 6295;
1679     uint256 public maxPerWallet = 20;
1680     uint256 public mintCost = 0.009 ether;
1681 
1682     bool public isSalesActive = false;
1683     bool public isReveal = false;
1684 
1685     string public baseURI;
1686     string public hiddenURI;
1687 
1688     address public wallet1 = 0x89FD37Ac832d04FC3f4DDafB2Bf3063f05E7cF9f;
1689     address public wallet2 = 0xF1CC1Cb4f4A29AF933B839cDbfb52f0C68D8cA1b;
1690 
1691     mapping(address => uint256) addressToMinted;
1692 
1693     constructor () ERC721A("Darkflex", "DARKFLEX") {
1694         _safeMint(msg.sender, 2);
1695         setHiddenURI("ipfs://bafkreidnukohre5dozxrjvr43adh4hw3txozsyoexfnk4rofmpnmnzhv7i");
1696     }
1697 
1698     function mint(uint256 mintAmount) public payable nonReentrant {
1699         require(msg.value >= mintAmount * mintCost, "Wrong mint amount");
1700         require(isSalesActive, "Wait, sale is not active yet");
1701         require(addressToMinted[msg.sender] + mintAmount <= maxPerWallet, "You can't mint more than limit");
1702         require(totalSupply() + mintAmount <= maxSupplyForPublic, "Sold out");
1703         
1704         addressToMinted[msg.sender] += mintAmount;
1705         _safeMint(msg.sender, mintAmount);
1706     }
1707 
1708     function reserveTeam(uint256 _mintAmount) public onlyOwner {
1709         require(totalSupply() + _mintAmount <= maxSupply, "Sold Out");
1710         
1711         _safeMint(msg.sender, _mintAmount);
1712     }
1713 
1714     function airdrop(address[] memory _addresses) public onlyOwner {
1715         require(totalSupply() + _addresses.length <= maxSupply, "Sold Out");
1716 
1717         for (uint256 i = 0; i < _addresses.length; i++) {
1718             _safeMint(_addresses[i], 1);
1719         }
1720     }
1721 
1722     function _baseURI() internal view virtual override returns (string memory) {
1723         return baseURI;
1724     }
1725 
1726     function tokenURI(uint256 tokenId)
1727         public
1728         view
1729         virtual
1730         override
1731         returns (string memory)
1732     {
1733 
1734         if (isReveal == false) {
1735             return hiddenURI;
1736         }
1737 
1738         require(
1739             _exists(tokenId),
1740             "ERC721Metadata: URI query for nonexistent token"
1741         );
1742         return string(abi.encodePacked(baseURI, _toString(tokenId), ""));
1743     }
1744 
1745     function setBaseURI(string memory baseURI_) public onlyOwner {
1746         baseURI = baseURI_;
1747     }
1748 
1749     function setHiddenURI(string memory _hiddenURI) public onlyOwner
1750     {
1751         hiddenURI = _hiddenURI;
1752     }
1753 
1754     function toggleReveal() public onlyOwner {
1755         isReveal = !isReveal;
1756     }
1757 
1758     function toggleSale() external onlyOwner {
1759         isSalesActive = !isSalesActive;
1760     }
1761 
1762     function setCost(uint256 newCost) external onlyOwner {
1763         mintCost = newCost;
1764     }
1765 
1766     function setMaxMint(uint256 newMaxMint) external onlyOwner {
1767         maxPerWallet = newMaxMint;
1768     }
1769 
1770     function withdrawAll() external onlyOwner {
1771         uint256 percent1 = address(this).balance * 15 / 100;
1772         uint256 percent2 = address(this).balance * 85 / 100;
1773         require(percent1 > 0);
1774         _withdraw(wallet1, percent1);
1775         _withdraw(wallet2, percent2);
1776     }
1777 
1778     function _withdraw(address _address, uint256 _amount) private {
1779         (bool success, ) = _address.call{value: _amount}("");
1780         require(success, "Transfer failed.");
1781     }
1782 
1783     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1784         super.setApprovalForAll(operator, approved);
1785     }
1786 
1787     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1788         super.approve(operator, tokenId);
1789     }
1790 
1791     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1792         super.transferFrom(from, to, tokenId);
1793     }
1794 
1795     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1796         super.safeTransferFrom(from, to, tokenId);
1797     }
1798 
1799     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1800         public
1801         payable
1802         override
1803         onlyAllowedOperator(from)
1804     {
1805         super.safeTransferFrom(from, to, tokenId, data);
1806     }
1807 }