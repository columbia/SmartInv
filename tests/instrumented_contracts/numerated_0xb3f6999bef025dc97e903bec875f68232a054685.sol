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
33 
34 
35 
36 
37 /**
38  * @title  OperatorFilterer
39  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
40  *         registrant's entries in the OperatorFilterRegistry.
41  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
42  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
43  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
44  */
45 abstract contract OperatorFilterer {
46     error OperatorNotAllowed(address operator);
47 
48     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
49         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
50 
51     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
52         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
53         // will not revert, but the contract will need to be registered with the registry once it is deployed in
54         // order for the modifier to filter addresses.
55         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
56             if (subscribe) {
57                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
58             } else {
59                 if (subscriptionOrRegistrantToCopy != address(0)) {
60                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
61                 } else {
62                     OPERATOR_FILTER_REGISTRY.register(address(this));
63                 }
64             }
65         }
66     }
67 
68     modifier onlyAllowedOperator(address from) virtual {
69         // Check registry code length to facilitate testing in environments without a deployed registry.
70         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
71             // Allow spending tokens from addresses with balance
72             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73             // from an EOA.
74             if (from == msg.sender) {
75                 _;
76                 return;
77             }
78             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
79                 revert OperatorNotAllowed(msg.sender);
80             }
81         }
82         _;
83     }
84 
85     modifier onlyAllowedOperatorApproval(address operator) virtual {
86         // Check registry code length to facilitate testing in environments without a deployed registry.
87         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
88             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
89                 revert OperatorNotAllowed(operator);
90             }
91         }
92         _;
93     }
94 }
95 
96 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/DefaultOperatorFilterer.sol
97 
98 
99 pragma solidity ^0.8.13;
100 
101 
102 /**
103  * @title  DefaultOperatorFilterer
104  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
105  */
106 abstract contract DefaultOperatorFilterer is OperatorFilterer {
107     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
108 
109     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
110 }
111 
112 // File: erc721a/contracts/IERC721A.sol
113 
114 
115 // ERC721A Contracts v4.2.3
116 // Creator: Chiru Labs
117 
118 pragma solidity ^0.8.4;
119 
120 /**
121  * @dev Interface of ERC721A.
122  */
123 interface IERC721A {
124     /**
125      * The caller must own the token or be an approved operator.
126      */
127     error ApprovalCallerNotOwnerNorApproved();
128 
129     /**
130      * The token does not exist.
131      */
132     error ApprovalQueryForNonexistentToken();
133 
134     /**
135      * Cannot query the balance for the zero address.
136      */
137     error BalanceQueryForZeroAddress();
138 
139     /**
140      * Cannot mint to the zero address.
141      */
142     error MintToZeroAddress();
143 
144     /**
145      * The quantity of tokens minted must be more than zero.
146      */
147     error MintZeroQuantity();
148 
149     /**
150      * The token does not exist.
151      */
152     error OwnerQueryForNonexistentToken();
153 
154     /**
155      * The caller must own the token or be an approved operator.
156      */
157     error TransferCallerNotOwnerNorApproved();
158 
159     /**
160      * The token must be owned by `from`.
161      */
162     error TransferFromIncorrectOwner();
163 
164     /**
165      * Cannot safely transfer to a contract that does not implement the
166      * ERC721Receiver interface.
167      */
168     error TransferToNonERC721ReceiverImplementer();
169 
170     /**
171      * Cannot transfer to the zero address.
172      */
173     error TransferToZeroAddress();
174 
175     /**
176      * The token does not exist.
177      */
178     error URIQueryForNonexistentToken();
179 
180     /**
181      * The `quantity` minted with ERC2309 exceeds the safety limit.
182      */
183     error MintERC2309QuantityExceedsLimit();
184 
185     /**
186      * The `extraData` cannot be set on an unintialized ownership slot.
187      */
188     error OwnershipNotInitializedForExtraData();
189 
190     // =============================================================
191     //                            STRUCTS
192     // =============================================================
193 
194     struct TokenOwnership {
195         // The address of the owner.
196         address addr;
197         // Stores the start time of ownership with minimal overhead for tokenomics.
198         uint64 startTimestamp;
199         // Whether the token has been burned.
200         bool burned;
201         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
202         uint24 extraData;
203     }
204 
205     // =============================================================
206     //                         TOKEN COUNTERS
207     // =============================================================
208 
209     /**
210      * @dev Returns the total number of tokens in existence.
211      * Burned tokens will reduce the count.
212      * To get the total number of tokens minted, please see {_totalMinted}.
213      */
214     function totalSupply() external view returns (uint256);
215 
216     // =============================================================
217     //                            IERC165
218     // =============================================================
219 
220     /**
221      * @dev Returns true if this contract implements the interface defined by
222      * `interfaceId`. See the corresponding
223      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
224      * to learn more about how these ids are created.
225      *
226      * This function call must use less than 30000 gas.
227      */
228     function supportsInterface(bytes4 interfaceId) external view returns (bool);
229 
230     // =============================================================
231     //                            IERC721
232     // =============================================================
233 
234     /**
235      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
236      */
237     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
238 
239     /**
240      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
241      */
242     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
243 
244     /**
245      * @dev Emitted when `owner` enables or disables
246      * (`approved`) `operator` to manage all of its assets.
247      */
248     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
249 
250     /**
251      * @dev Returns the number of tokens in `owner`'s account.
252      */
253     function balanceOf(address owner) external view returns (uint256 balance);
254 
255     /**
256      * @dev Returns the owner of the `tokenId` token.
257      *
258      * Requirements:
259      *
260      * - `tokenId` must exist.
261      */
262     function ownerOf(uint256 tokenId) external view returns (address owner);
263 
264     /**
265      * @dev Safely transfers `tokenId` token from `from` to `to`,
266      * checking first that contract recipients are aware of the ERC721 protocol
267      * to prevent tokens from being forever locked.
268      *
269      * Requirements:
270      *
271      * - `from` cannot be the zero address.
272      * - `to` cannot be the zero address.
273      * - `tokenId` token must exist and be owned by `from`.
274      * - If the caller is not `from`, it must be have been allowed to move
275      * this token by either {approve} or {setApprovalForAll}.
276      * - If `to` refers to a smart contract, it must implement
277      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
278      *
279      * Emits a {Transfer} event.
280      */
281     function safeTransferFrom(
282         address from,
283         address to,
284         uint256 tokenId,
285         bytes calldata data
286     ) external payable;
287 
288     /**
289      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
290      */
291     function safeTransferFrom(
292         address from,
293         address to,
294         uint256 tokenId
295     ) external payable;
296 
297     /**
298      * @dev Transfers `tokenId` from `from` to `to`.
299      *
300      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
301      * whenever possible.
302      *
303      * Requirements:
304      *
305      * - `from` cannot be the zero address.
306      * - `to` cannot be the zero address.
307      * - `tokenId` token must be owned by `from`.
308      * - If the caller is not `from`, it must be approved to move this token
309      * by either {approve} or {setApprovalForAll}.
310      *
311      * Emits a {Transfer} event.
312      */
313     function transferFrom(
314         address from,
315         address to,
316         uint256 tokenId
317     ) external payable;
318 
319     /**
320      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
321      * The approval is cleared when the token is transferred.
322      *
323      * Only a single account can be approved at a time, so approving the
324      * zero address clears previous approvals.
325      *
326      * Requirements:
327      *
328      * - The caller must own the token or be an approved operator.
329      * - `tokenId` must exist.
330      *
331      * Emits an {Approval} event.
332      */
333     function approve(address to, uint256 tokenId) external payable;
334 
335     /**
336      * @dev Approve or remove `operator` as an operator for the caller.
337      * Operators can call {transferFrom} or {safeTransferFrom}
338      * for any token owned by the caller.
339      *
340      * Requirements:
341      *
342      * - The `operator` cannot be the caller.
343      *
344      * Emits an {ApprovalForAll} event.
345      */
346     function setApprovalForAll(address operator, bool _approved) external;
347 
348     /**
349      * @dev Returns the account approved for `tokenId` token.
350      *
351      * Requirements:
352      *
353      * - `tokenId` must exist.
354      */
355     function getApproved(uint256 tokenId) external view returns (address operator);
356 
357     /**
358      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
359      *
360      * See {setApprovalForAll}.
361      */
362     function isApprovedForAll(address owner, address operator) external view returns (bool);
363 
364     // =============================================================
365     //                        IERC721Metadata
366     // =============================================================
367 
368     /**
369      * @dev Returns the token collection name.
370      */
371     function name() external view returns (string memory);
372 
373     /**
374      * @dev Returns the token collection symbol.
375      */
376     function symbol() external view returns (string memory);
377 
378     /**
379      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
380      */
381     function tokenURI(uint256 tokenId) external view returns (string memory);
382 
383     // =============================================================
384     //                           IERC2309
385     // =============================================================
386 
387     /**
388      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
389      * (inclusive) is transferred from `from` to `to`, as defined in the
390      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
391      *
392      * See {_mintERC2309} for more details.
393      */
394     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
395 }
396 
397 // File: erc721a/contracts/ERC721A.sol
398 
399 
400 // ERC721A Contracts v4.2.3
401 // Creator: Chiru Labs
402 
403 pragma solidity ^0.8.4;
404 
405 
406 /**
407  * @dev Interface of ERC721 token receiver.
408  */
409 interface ERC721A__IERC721Receiver {
410     function onERC721Received(
411         address operator,
412         address from,
413         uint256 tokenId,
414         bytes calldata data
415     ) external returns (bytes4);
416 }
417 
418 /**
419  * @title ERC721A
420  *
421  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
422  * Non-Fungible Token Standard, including the Metadata extension.
423  * Optimized for lower gas during batch mints.
424  *
425  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
426  * starting from `_startTokenId()`.
427  *
428  * Assumptions:
429  *
430  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
431  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
432  */
433 contract ERC721A is IERC721A {
434     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
435     struct TokenApprovalRef {
436         address value;
437     }
438 
439     // =============================================================
440     //                           CONSTANTS
441     // =============================================================
442 
443     // Mask of an entry in packed address data.
444     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
445 
446     // The bit position of `numberMinted` in packed address data.
447     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
448 
449     // The bit position of `numberBurned` in packed address data.
450     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
451 
452     // The bit position of `aux` in packed address data.
453     uint256 private constant _BITPOS_AUX = 192;
454 
455     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
456     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
457 
458     // The bit position of `startTimestamp` in packed ownership.
459     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
460 
461     // The bit mask of the `burned` bit in packed ownership.
462     uint256 private constant _BITMASK_BURNED = 1 << 224;
463 
464     // The bit position of the `nextInitialized` bit in packed ownership.
465     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
466 
467     // The bit mask of the `nextInitialized` bit in packed ownership.
468     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
469 
470     // The bit position of `extraData` in packed ownership.
471     uint256 private constant _BITPOS_EXTRA_DATA = 232;
472 
473     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
474     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
475 
476     // The mask of the lower 160 bits for addresses.
477     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
478 
479     // The maximum `quantity` that can be minted with {_mintERC2309}.
480     // This limit is to prevent overflows on the address data entries.
481     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
482     // is required to cause an overflow, which is unrealistic.
483     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
484 
485     // The `Transfer` event signature is given by:
486     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
487     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
488         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
489 
490     // =============================================================
491     //                            STORAGE
492     // =============================================================
493 
494     // The next token ID to be minted.
495     uint256 private _currentIndex;
496 
497     // The number of tokens burned.
498     uint256 private _burnCounter;
499 
500     // Token name
501     string private _name;
502 
503     // Token symbol
504     string private _symbol;
505 
506     // Mapping from token ID to ownership details
507     // An empty struct value does not necessarily mean the token is unowned.
508     // See {_packedOwnershipOf} implementation for details.
509     //
510     // Bits Layout:
511     // - [0..159]   `addr`
512     // - [160..223] `startTimestamp`
513     // - [224]      `burned`
514     // - [225]      `nextInitialized`
515     // - [232..255] `extraData`
516     mapping(uint256 => uint256) private _packedOwnerships;
517 
518     // Mapping owner address to address data.
519     //
520     // Bits Layout:
521     // - [0..63]    `balance`
522     // - [64..127]  `numberMinted`
523     // - [128..191] `numberBurned`
524     // - [192..255] `aux`
525     mapping(address => uint256) private _packedAddressData;
526 
527     // Mapping from token ID to approved address.
528     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
529 
530     // Mapping from owner to operator approvals
531     mapping(address => mapping(address => bool)) private _operatorApprovals;
532 
533     // =============================================================
534     //                          CONSTRUCTOR
535     // =============================================================
536 
537     constructor(string memory name_, string memory symbol_) {
538         _name = name_;
539         _symbol = symbol_;
540         _currentIndex = _startTokenId();
541     }
542 
543     // =============================================================
544     //                   TOKEN COUNTING OPERATIONS
545     // =============================================================
546 
547     /**
548      * @dev Returns the starting token ID.
549      * To change the starting token ID, please override this function.
550      */
551     function _startTokenId() internal view virtual returns (uint256) {
552         return 0;
553     }
554 
555     /**
556      * @dev Returns the next token ID to be minted.
557      */
558     function _nextTokenId() internal view virtual returns (uint256) {
559         return _currentIndex;
560     }
561 
562     /**
563      * @dev Returns the total number of tokens in existence.
564      * Burned tokens will reduce the count.
565      * To get the total number of tokens minted, please see {_totalMinted}.
566      */
567     function totalSupply() public view virtual override returns (uint256) {
568         // Counter underflow is impossible as _burnCounter cannot be incremented
569         // more than `_currentIndex - _startTokenId()` times.
570         unchecked {
571             return _currentIndex - _burnCounter - _startTokenId();
572         }
573     }
574 
575     /**
576      * @dev Returns the total amount of tokens minted in the contract.
577      */
578     function _totalMinted() internal view virtual returns (uint256) {
579         // Counter underflow is impossible as `_currentIndex` does not decrement,
580         // and it is initialized to `_startTokenId()`.
581         unchecked {
582             return _currentIndex - _startTokenId();
583         }
584     }
585 
586     /**
587      * @dev Returns the total number of tokens burned.
588      */
589     function _totalBurned() internal view virtual returns (uint256) {
590         return _burnCounter;
591     }
592 
593     // =============================================================
594     //                    ADDRESS DATA OPERATIONS
595     // =============================================================
596 
597     /**
598      * @dev Returns the number of tokens in `owner`'s account.
599      */
600     function balanceOf(address owner) public view virtual override returns (uint256) {
601         if (owner == address(0)) revert BalanceQueryForZeroAddress();
602         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
603     }
604 
605     /**
606      * Returns the number of tokens minted by `owner`.
607      */
608     function _numberMinted(address owner) internal view returns (uint256) {
609         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
610     }
611 
612     /**
613      * Returns the number of tokens burned by or on behalf of `owner`.
614      */
615     function _numberBurned(address owner) internal view returns (uint256) {
616         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
617     }
618 
619     /**
620      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
621      */
622     function _getAux(address owner) internal view returns (uint64) {
623         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
624     }
625 
626     /**
627      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
628      * If there are multiple variables, please pack them into a uint64.
629      */
630     function _setAux(address owner, uint64 aux) internal virtual {
631         uint256 packed = _packedAddressData[owner];
632         uint256 auxCasted;
633         // Cast `aux` with assembly to avoid redundant masking.
634         assembly {
635             auxCasted := aux
636         }
637         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
638         _packedAddressData[owner] = packed;
639     }
640 
641     // =============================================================
642     //                            IERC165
643     // =============================================================
644 
645     /**
646      * @dev Returns true if this contract implements the interface defined by
647      * `interfaceId`. See the corresponding
648      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
649      * to learn more about how these ids are created.
650      *
651      * This function call must use less than 30000 gas.
652      */
653     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
654         // The interface IDs are constants representing the first 4 bytes
655         // of the XOR of all function selectors in the interface.
656         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
657         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
658         return
659             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
660             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
661             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
662     }
663 
664     // =============================================================
665     //                        IERC721Metadata
666     // =============================================================
667 
668     /**
669      * @dev Returns the token collection name.
670      */
671     function name() public view virtual override returns (string memory) {
672         return _name;
673     }
674 
675     /**
676      * @dev Returns the token collection symbol.
677      */
678     function symbol() public view virtual override returns (string memory) {
679         return _symbol;
680     }
681 
682     /**
683      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
684      */
685     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
686         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
687 
688         string memory baseURI = _baseURI();
689         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
690     }
691 
692     /**
693      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
694      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
695      * by default, it can be overridden in child contracts.
696      */
697     function _baseURI() internal view virtual returns (string memory) {
698         return '';
699     }
700 
701     // =============================================================
702     //                     OWNERSHIPS OPERATIONS
703     // =============================================================
704 
705     /**
706      * @dev Returns the owner of the `tokenId` token.
707      *
708      * Requirements:
709      *
710      * - `tokenId` must exist.
711      */
712     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
713         return address(uint160(_packedOwnershipOf(tokenId)));
714     }
715 
716     /**
717      * @dev Gas spent here starts off proportional to the maximum mint batch size.
718      * It gradually moves to O(1) as tokens get transferred around over time.
719      */
720     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
721         return _unpackedOwnership(_packedOwnershipOf(tokenId));
722     }
723 
724     /**
725      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
726      */
727     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
728         return _unpackedOwnership(_packedOwnerships[index]);
729     }
730 
731     /**
732      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
733      */
734     function _initializeOwnershipAt(uint256 index) internal virtual {
735         if (_packedOwnerships[index] == 0) {
736             _packedOwnerships[index] = _packedOwnershipOf(index);
737         }
738     }
739 
740     /**
741      * Returns the packed ownership data of `tokenId`.
742      */
743     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
744         uint256 curr = tokenId;
745 
746         unchecked {
747             if (_startTokenId() <= curr)
748                 if (curr < _currentIndex) {
749                     uint256 packed = _packedOwnerships[curr];
750                     // If not burned.
751                     if (packed & _BITMASK_BURNED == 0) {
752                         // Invariant:
753                         // There will always be an initialized ownership slot
754                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
755                         // before an unintialized ownership slot
756                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
757                         // Hence, `curr` will not underflow.
758                         //
759                         // We can directly compare the packed value.
760                         // If the address is zero, packed will be zero.
761                         while (packed == 0) {
762                             packed = _packedOwnerships[--curr];
763                         }
764                         return packed;
765                     }
766                 }
767         }
768         revert OwnerQueryForNonexistentToken();
769     }
770 
771     /**
772      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
773      */
774     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
775         ownership.addr = address(uint160(packed));
776         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
777         ownership.burned = packed & _BITMASK_BURNED != 0;
778         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
779     }
780 
781     /**
782      * @dev Packs ownership data into a single uint256.
783      */
784     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
785         assembly {
786             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
787             owner := and(owner, _BITMASK_ADDRESS)
788             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
789             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
790         }
791     }
792 
793     /**
794      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
795      */
796     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
797         // For branchless setting of the `nextInitialized` flag.
798         assembly {
799             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
800             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
801         }
802     }
803 
804     // =============================================================
805     //                      APPROVAL OPERATIONS
806     // =============================================================
807 
808     /**
809      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
810      * The approval is cleared when the token is transferred.
811      *
812      * Only a single account can be approved at a time, so approving the
813      * zero address clears previous approvals.
814      *
815      * Requirements:
816      *
817      * - The caller must own the token or be an approved operator.
818      * - `tokenId` must exist.
819      *
820      * Emits an {Approval} event.
821      */
822     function approve(address to, uint256 tokenId) public payable virtual override {
823         address owner = ownerOf(tokenId);
824 
825         if (_msgSenderERC721A() != owner)
826             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
827                 revert ApprovalCallerNotOwnerNorApproved();
828             }
829 
830         _tokenApprovals[tokenId].value = to;
831         emit Approval(owner, to, tokenId);
832     }
833 
834     /**
835      * @dev Returns the account approved for `tokenId` token.
836      *
837      * Requirements:
838      *
839      * - `tokenId` must exist.
840      */
841     function getApproved(uint256 tokenId) public view virtual override returns (address) {
842         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
843 
844         return _tokenApprovals[tokenId].value;
845     }
846 
847     /**
848      * @dev Approve or remove `operator` as an operator for the caller.
849      * Operators can call {transferFrom} or {safeTransferFrom}
850      * for any token owned by the caller.
851      *
852      * Requirements:
853      *
854      * - The `operator` cannot be the caller.
855      *
856      * Emits an {ApprovalForAll} event.
857      */
858     function setApprovalForAll(address operator, bool approved) public virtual override {
859         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
860         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
861     }
862 
863     /**
864      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
865      *
866      * See {setApprovalForAll}.
867      */
868     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
869         return _operatorApprovals[owner][operator];
870     }
871 
872     /**
873      * @dev Returns whether `tokenId` exists.
874      *
875      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
876      *
877      * Tokens start existing when they are minted. See {_mint}.
878      */
879     function _exists(uint256 tokenId) internal view virtual returns (bool) {
880         return
881             _startTokenId() <= tokenId &&
882             tokenId < _currentIndex && // If within bounds,
883             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
884     }
885 
886     /**
887      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
888      */
889     function _isSenderApprovedOrOwner(
890         address approvedAddress,
891         address owner,
892         address msgSender
893     ) private pure returns (bool result) {
894         assembly {
895             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
896             owner := and(owner, _BITMASK_ADDRESS)
897             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
898             msgSender := and(msgSender, _BITMASK_ADDRESS)
899             // `msgSender == owner || msgSender == approvedAddress`.
900             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
901         }
902     }
903 
904     /**
905      * @dev Returns the storage slot and value for the approved address of `tokenId`.
906      */
907     function _getApprovedSlotAndAddress(uint256 tokenId)
908         private
909         view
910         returns (uint256 approvedAddressSlot, address approvedAddress)
911     {
912         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
913         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
914         assembly {
915             approvedAddressSlot := tokenApproval.slot
916             approvedAddress := sload(approvedAddressSlot)
917         }
918     }
919 
920     // =============================================================
921     //                      TRANSFER OPERATIONS
922     // =============================================================
923 
924     /**
925      * @dev Transfers `tokenId` from `from` to `to`.
926      *
927      * Requirements:
928      *
929      * - `from` cannot be the zero address.
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must be owned by `from`.
932      * - If the caller is not `from`, it must be approved to move this token
933      * by either {approve} or {setApprovalForAll}.
934      *
935      * Emits a {Transfer} event.
936      */
937     function transferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public payable virtual override {
942         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
943 
944         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
945 
946         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
947 
948         // The nested ifs save around 20+ gas over a compound boolean condition.
949         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
950             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
951 
952         if (to == address(0)) revert TransferToZeroAddress();
953 
954         _beforeTokenTransfers(from, to, tokenId, 1);
955 
956         // Clear approvals from the previous owner.
957         assembly {
958             if approvedAddress {
959                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
960                 sstore(approvedAddressSlot, 0)
961             }
962         }
963 
964         // Underflow of the sender's balance is impossible because we check for
965         // ownership above and the recipient's balance can't realistically overflow.
966         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
967         unchecked {
968             // We can directly increment and decrement the balances.
969             --_packedAddressData[from]; // Updates: `balance -= 1`.
970             ++_packedAddressData[to]; // Updates: `balance += 1`.
971 
972             // Updates:
973             // - `address` to the next owner.
974             // - `startTimestamp` to the timestamp of transfering.
975             // - `burned` to `false`.
976             // - `nextInitialized` to `true`.
977             _packedOwnerships[tokenId] = _packOwnershipData(
978                 to,
979                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
980             );
981 
982             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
983             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
984                 uint256 nextTokenId = tokenId + 1;
985                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
986                 if (_packedOwnerships[nextTokenId] == 0) {
987                     // If the next slot is within bounds.
988                     if (nextTokenId != _currentIndex) {
989                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
990                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
991                     }
992                 }
993             }
994         }
995 
996         emit Transfer(from, to, tokenId);
997         _afterTokenTransfers(from, to, tokenId, 1);
998     }
999 
1000     /**
1001      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1002      */
1003     function safeTransferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) public payable virtual override {
1008         safeTransferFrom(from, to, tokenId, '');
1009     }
1010 
1011     /**
1012      * @dev Safely transfers `tokenId` token from `from` to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `from` cannot be the zero address.
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must exist and be owned by `from`.
1019      * - If the caller is not `from`, it must be approved to move this token
1020      * by either {approve} or {setApprovalForAll}.
1021      * - If `to` refers to a smart contract, it must implement
1022      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId,
1030         bytes memory _data
1031     ) public payable virtual override {
1032         transferFrom(from, to, tokenId);
1033         if (to.code.length != 0)
1034             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1035                 revert TransferToNonERC721ReceiverImplementer();
1036             }
1037     }
1038 
1039     /**
1040      * @dev Hook that is called before a set of serially-ordered token IDs
1041      * are about to be transferred. This includes minting.
1042      * And also called before burning one token.
1043      *
1044      * `startTokenId` - the first token ID to be transferred.
1045      * `quantity` - the amount to be transferred.
1046      *
1047      * Calling conditions:
1048      *
1049      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1050      * transferred to `to`.
1051      * - When `from` is zero, `tokenId` will be minted for `to`.
1052      * - When `to` is zero, `tokenId` will be burned by `from`.
1053      * - `from` and `to` are never both zero.
1054      */
1055     function _beforeTokenTransfers(
1056         address from,
1057         address to,
1058         uint256 startTokenId,
1059         uint256 quantity
1060     ) internal virtual {}
1061 
1062     /**
1063      * @dev Hook that is called after a set of serially-ordered token IDs
1064      * have been transferred. This includes minting.
1065      * And also called after one token has been burned.
1066      *
1067      * `startTokenId` - the first token ID to be transferred.
1068      * `quantity` - the amount to be transferred.
1069      *
1070      * Calling conditions:
1071      *
1072      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1073      * transferred to `to`.
1074      * - When `from` is zero, `tokenId` has been minted for `to`.
1075      * - When `to` is zero, `tokenId` has been burned by `from`.
1076      * - `from` and `to` are never both zero.
1077      */
1078     function _afterTokenTransfers(
1079         address from,
1080         address to,
1081         uint256 startTokenId,
1082         uint256 quantity
1083     ) internal virtual {}
1084 
1085     /**
1086      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1087      *
1088      * `from` - Previous owner of the given token ID.
1089      * `to` - Target address that will receive the token.
1090      * `tokenId` - Token ID to be transferred.
1091      * `_data` - Optional data to send along with the call.
1092      *
1093      * Returns whether the call correctly returned the expected magic value.
1094      */
1095     function _checkContractOnERC721Received(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes memory _data
1100     ) private returns (bool) {
1101         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1102             bytes4 retval
1103         ) {
1104             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1105         } catch (bytes memory reason) {
1106             if (reason.length == 0) {
1107                 revert TransferToNonERC721ReceiverImplementer();
1108             } else {
1109                 assembly {
1110                     revert(add(32, reason), mload(reason))
1111                 }
1112             }
1113         }
1114     }
1115 
1116     // =============================================================
1117     //                        MINT OPERATIONS
1118     // =============================================================
1119 
1120     /**
1121      * @dev Mints `quantity` tokens and transfers them to `to`.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `quantity` must be greater than 0.
1127      *
1128      * Emits a {Transfer} event for each mint.
1129      */
1130     function _mint(address to, uint256 quantity) internal virtual {
1131         uint256 startTokenId = _currentIndex;
1132         if (quantity == 0) revert MintZeroQuantity();
1133 
1134         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1135 
1136         // Overflows are incredibly unrealistic.
1137         // `balance` and `numberMinted` have a maximum limit of 2**64.
1138         // `tokenId` has a maximum limit of 2**256.
1139         unchecked {
1140             // Updates:
1141             // - `balance += quantity`.
1142             // - `numberMinted += quantity`.
1143             //
1144             // We can directly add to the `balance` and `numberMinted`.
1145             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1146 
1147             // Updates:
1148             // - `address` to the owner.
1149             // - `startTimestamp` to the timestamp of minting.
1150             // - `burned` to `false`.
1151             // - `nextInitialized` to `quantity == 1`.
1152             _packedOwnerships[startTokenId] = _packOwnershipData(
1153                 to,
1154                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1155             );
1156 
1157             uint256 toMasked;
1158             uint256 end = startTokenId + quantity;
1159 
1160             // Use assembly to loop and emit the `Transfer` event for gas savings.
1161             // The duplicated `log4` removes an extra check and reduces stack juggling.
1162             // The assembly, together with the surrounding Solidity code, have been
1163             // delicately arranged to nudge the compiler into producing optimized opcodes.
1164             assembly {
1165                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1166                 toMasked := and(to, _BITMASK_ADDRESS)
1167                 // Emit the `Transfer` event.
1168                 log4(
1169                     0, // Start of data (0, since no data).
1170                     0, // End of data (0, since no data).
1171                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1172                     0, // `address(0)`.
1173                     toMasked, // `to`.
1174                     startTokenId // `tokenId`.
1175                 )
1176 
1177                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1178                 // that overflows uint256 will make the loop run out of gas.
1179                 // The compiler will optimize the `iszero` away for performance.
1180                 for {
1181                     let tokenId := add(startTokenId, 1)
1182                 } iszero(eq(tokenId, end)) {
1183                     tokenId := add(tokenId, 1)
1184                 } {
1185                     // Emit the `Transfer` event. Similar to above.
1186                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1187                 }
1188             }
1189             if (toMasked == 0) revert MintToZeroAddress();
1190 
1191             _currentIndex = end;
1192         }
1193         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1194     }
1195 
1196     /**
1197      * @dev Mints `quantity` tokens and transfers them to `to`.
1198      *
1199      * This function is intended for efficient minting only during contract creation.
1200      *
1201      * It emits only one {ConsecutiveTransfer} as defined in
1202      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1203      * instead of a sequence of {Transfer} event(s).
1204      *
1205      * Calling this function outside of contract creation WILL make your contract
1206      * non-compliant with the ERC721 standard.
1207      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1208      * {ConsecutiveTransfer} event is only permissible during contract creation.
1209      *
1210      * Requirements:
1211      *
1212      * - `to` cannot be the zero address.
1213      * - `quantity` must be greater than 0.
1214      *
1215      * Emits a {ConsecutiveTransfer} event.
1216      */
1217     function _mintERC2309(address to, uint256 quantity) internal virtual {
1218         uint256 startTokenId = _currentIndex;
1219         if (to == address(0)) revert MintToZeroAddress();
1220         if (quantity == 0) revert MintZeroQuantity();
1221         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1222 
1223         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1224 
1225         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1226         unchecked {
1227             // Updates:
1228             // - `balance += quantity`.
1229             // - `numberMinted += quantity`.
1230             //
1231             // We can directly add to the `balance` and `numberMinted`.
1232             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1233 
1234             // Updates:
1235             // - `address` to the owner.
1236             // - `startTimestamp` to the timestamp of minting.
1237             // - `burned` to `false`.
1238             // - `nextInitialized` to `quantity == 1`.
1239             _packedOwnerships[startTokenId] = _packOwnershipData(
1240                 to,
1241                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1242             );
1243 
1244             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1245 
1246             _currentIndex = startTokenId + quantity;
1247         }
1248         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1249     }
1250 
1251     /**
1252      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1253      *
1254      * Requirements:
1255      *
1256      * - If `to` refers to a smart contract, it must implement
1257      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1258      * - `quantity` must be greater than 0.
1259      *
1260      * See {_mint}.
1261      *
1262      * Emits a {Transfer} event for each mint.
1263      */
1264     function _safeMint(
1265         address to,
1266         uint256 quantity,
1267         bytes memory _data
1268     ) internal virtual {
1269         _mint(to, quantity);
1270 
1271         unchecked {
1272             if (to.code.length != 0) {
1273                 uint256 end = _currentIndex;
1274                 uint256 index = end - quantity;
1275                 do {
1276                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1277                         revert TransferToNonERC721ReceiverImplementer();
1278                     }
1279                 } while (index < end);
1280                 // Reentrancy protection.
1281                 if (_currentIndex != end) revert();
1282             }
1283         }
1284     }
1285 
1286     /**
1287      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1288      */
1289     function _safeMint(address to, uint256 quantity) internal virtual {
1290         _safeMint(to, quantity, '');
1291     }
1292 
1293     // =============================================================
1294     //                        BURN OPERATIONS
1295     // =============================================================
1296 
1297     /**
1298      * @dev Equivalent to `_burn(tokenId, false)`.
1299      */
1300     function _burn(uint256 tokenId) internal virtual {
1301         _burn(tokenId, false);
1302     }
1303 
1304     /**
1305      * @dev Destroys `tokenId`.
1306      * The approval is cleared when the token is burned.
1307      *
1308      * Requirements:
1309      *
1310      * - `tokenId` must exist.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1315         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1316 
1317         address from = address(uint160(prevOwnershipPacked));
1318 
1319         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1320 
1321         if (approvalCheck) {
1322             // The nested ifs save around 20+ gas over a compound boolean condition.
1323             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1324                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1325         }
1326 
1327         _beforeTokenTransfers(from, address(0), tokenId, 1);
1328 
1329         // Clear approvals from the previous owner.
1330         assembly {
1331             if approvedAddress {
1332                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1333                 sstore(approvedAddressSlot, 0)
1334             }
1335         }
1336 
1337         // Underflow of the sender's balance is impossible because we check for
1338         // ownership above and the recipient's balance can't realistically overflow.
1339         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1340         unchecked {
1341             // Updates:
1342             // - `balance -= 1`.
1343             // - `numberBurned += 1`.
1344             //
1345             // We can directly decrement the balance, and increment the number burned.
1346             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1347             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1348 
1349             // Updates:
1350             // - `address` to the last owner.
1351             // - `startTimestamp` to the timestamp of burning.
1352             // - `burned` to `true`.
1353             // - `nextInitialized` to `true`.
1354             _packedOwnerships[tokenId] = _packOwnershipData(
1355                 from,
1356                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1357             );
1358 
1359             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1360             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1361                 uint256 nextTokenId = tokenId + 1;
1362                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1363                 if (_packedOwnerships[nextTokenId] == 0) {
1364                     // If the next slot is within bounds.
1365                     if (nextTokenId != _currentIndex) {
1366                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1367                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1368                     }
1369                 }
1370             }
1371         }
1372 
1373         emit Transfer(from, address(0), tokenId);
1374         _afterTokenTransfers(from, address(0), tokenId, 1);
1375 
1376         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1377         unchecked {
1378             _burnCounter++;
1379         }
1380     }
1381 
1382     // =============================================================
1383     //                     EXTRA DATA OPERATIONS
1384     // =============================================================
1385 
1386     /**
1387      * @dev Directly sets the extra data for the ownership data `index`.
1388      */
1389     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1390         uint256 packed = _packedOwnerships[index];
1391         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1392         uint256 extraDataCasted;
1393         // Cast `extraData` with assembly to avoid redundant masking.
1394         assembly {
1395             extraDataCasted := extraData
1396         }
1397         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1398         _packedOwnerships[index] = packed;
1399     }
1400 
1401     /**
1402      * @dev Called during each token transfer to set the 24bit `extraData` field.
1403      * Intended to be overridden by the cosumer contract.
1404      *
1405      * `previousExtraData` - the value of `extraData` before transfer.
1406      *
1407      * Calling conditions:
1408      *
1409      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1410      * transferred to `to`.
1411      * - When `from` is zero, `tokenId` will be minted for `to`.
1412      * - When `to` is zero, `tokenId` will be burned by `from`.
1413      * - `from` and `to` are never both zero.
1414      */
1415     function _extraData(
1416         address from,
1417         address to,
1418         uint24 previousExtraData
1419     ) internal view virtual returns (uint24) {}
1420 
1421     /**
1422      * @dev Returns the next extra data for the packed ownership data.
1423      * The returned result is shifted into position.
1424      */
1425     function _nextExtraData(
1426         address from,
1427         address to,
1428         uint256 prevOwnershipPacked
1429     ) private view returns (uint256) {
1430         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1431         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1432     }
1433 
1434     // =============================================================
1435     //                       OTHER OPERATIONS
1436     // =============================================================
1437 
1438     /**
1439      * @dev Returns the message sender (defaults to `msg.sender`).
1440      *
1441      * If you are writing GSN compatible contracts, you need to override this function.
1442      */
1443     function _msgSenderERC721A() internal view virtual returns (address) {
1444         return msg.sender;
1445     }
1446 
1447     /**
1448      * @dev Converts a uint256 to its ASCII string decimal representation.
1449      */
1450     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1451         assembly {
1452             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1453             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1454             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1455             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1456             let m := add(mload(0x40), 0xa0)
1457             // Update the free memory pointer to allocate.
1458             mstore(0x40, m)
1459             // Assign the `str` to the end.
1460             str := sub(m, 0x20)
1461             // Zeroize the slot after the string.
1462             mstore(str, 0)
1463 
1464             // Cache the end of the memory to calculate the length later.
1465             let end := str
1466 
1467             // We write the string from rightmost digit to leftmost digit.
1468             // The following is essentially a do-while loop that also handles the zero case.
1469             // prettier-ignore
1470             for { let temp := value } 1 {} {
1471                 str := sub(str, 1)
1472                 // Write the character to the pointer.
1473                 // The ASCII index of the '0' character is 48.
1474                 mstore8(str, add(48, mod(temp, 10)))
1475                 // Keep dividing `temp` until zero.
1476                 temp := div(temp, 10)
1477                 // prettier-ignore
1478                 if iszero(temp) { break }
1479             }
1480 
1481             let length := sub(end, str)
1482             // Move the pointer 32 bytes leftwards to make room for the length.
1483             str := sub(str, 0x20)
1484             // Store the length.
1485             mstore(str, length)
1486         }
1487     }
1488 }
1489 
1490 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1491 
1492 
1493 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1494 
1495 pragma solidity ^0.8.0;
1496 
1497 /**
1498  * @dev Contract module that helps prevent reentrant calls to a function.
1499  *
1500  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1501  * available, which can be applied to functions to make sure there are no nested
1502  * (reentrant) calls to them.
1503  *
1504  * Note that because there is a single `nonReentrant` guard, functions marked as
1505  * `nonReentrant` may not call one another. This can be worked around by making
1506  * those functions `private`, and then adding `external` `nonReentrant` entry
1507  * points to them.
1508  *
1509  * TIP: If you would like to learn more about reentrancy and alternative ways
1510  * to protect against it, check out our blog post
1511  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1512  */
1513 abstract contract ReentrancyGuard {
1514     // Booleans are more expensive than uint256 or any type that takes up a full
1515     // word because each write operation emits an extra SLOAD to first read the
1516     // slot's contents, replace the bits taken up by the boolean, and then write
1517     // back. This is the compiler's defense against contract upgrades and
1518     // pointer aliasing, and it cannot be disabled.
1519 
1520     // The values being non-zero value makes deployment a bit more expensive,
1521     // but in exchange the refund on every call to nonReentrant will be lower in
1522     // amount. Since refunds are capped to a percentage of the total
1523     // transaction's gas, it is best to keep them low in cases like this one, to
1524     // increase the likelihood of the full refund coming into effect.
1525     uint256 private constant _NOT_ENTERED = 1;
1526     uint256 private constant _ENTERED = 2;
1527 
1528     uint256 private _status;
1529 
1530     constructor() {
1531         _status = _NOT_ENTERED;
1532     }
1533 
1534     /**
1535      * @dev Prevents a contract from calling itself, directly or indirectly.
1536      * Calling a `nonReentrant` function from another `nonReentrant`
1537      * function is not supported. It is possible to prevent this from happening
1538      * by making the `nonReentrant` function external, and making it call a
1539      * `private` function that does the actual work.
1540      */
1541     modifier nonReentrant() {
1542         _nonReentrantBefore();
1543         _;
1544         _nonReentrantAfter();
1545     }
1546 
1547     function _nonReentrantBefore() private {
1548         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1549         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1550 
1551         // Any calls to nonReentrant after this point will fail
1552         _status = _ENTERED;
1553     }
1554 
1555     function _nonReentrantAfter() private {
1556         // By storing the original value once again, a refund is triggered (see
1557         // https://eips.ethereum.org/EIPS/eip-2200)
1558         _status = _NOT_ENTERED;
1559     }
1560 }
1561 
1562 // File: @openzeppelin/contracts/utils/Context.sol
1563 
1564 
1565 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1566 
1567 pragma solidity ^0.8.0;
1568 
1569 /**
1570  * @dev Provides information about the current execution context, including the
1571  * sender of the transaction and its data. While these are generally available
1572  * via msg.sender and msg.data, they should not be accessed in such a direct
1573  * manner, since when dealing with meta-transactions the account sending and
1574  * paying for execution may not be the actual sender (as far as an application
1575  * is concerned).
1576  *
1577  * This contract is only required for intermediate, library-like contracts.
1578  */
1579 abstract contract Context {
1580     function _msgSender() internal view virtual returns (address) {
1581         return msg.sender;
1582     }
1583 
1584     function _msgData() internal view virtual returns (bytes calldata) {
1585         return msg.data;
1586     }
1587 }
1588 
1589 // File: @openzeppelin/contracts/access/Ownable.sol
1590 
1591 
1592 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1593 
1594 pragma solidity ^0.8.0;
1595 
1596 
1597 /**
1598  * @dev Contract module which provides a basic access control mechanism, where
1599  * there is an account (an owner) that can be granted exclusive access to
1600  * specific functions.
1601  *
1602  * By default, the owner account will be the one that deploys the contract. This
1603  * can later be changed with {transferOwnership}.
1604  *
1605  * This module is used through inheritance. It will make available the modifier
1606  * `onlyOwner`, which can be applied to your functions to restrict their use to
1607  * the owner.
1608  */
1609 abstract contract Ownable is Context {
1610     address private _owner;
1611 
1612     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1613 
1614     /**
1615      * @dev Initializes the contract setting the deployer as the initial owner.
1616      */
1617     constructor() {
1618         _transferOwnership(_msgSender());
1619     }
1620 
1621     /**
1622      * @dev Throws if called by any account other than the owner.
1623      */
1624     modifier onlyOwner() {
1625         _checkOwner();
1626         _;
1627     }
1628 
1629     /**
1630      * @dev Returns the address of the current owner.
1631      */
1632     function owner() public view virtual returns (address) {
1633         return _owner;
1634     }
1635 
1636     /**
1637      * @dev Throws if the sender is not the owner.
1638      */
1639     function _checkOwner() internal view virtual {
1640         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1641     }
1642 
1643     /**
1644      * @dev Leaves the contract without owner. It will not be possible to call
1645      * `onlyOwner` functions anymore. Can only be called by the current owner.
1646      *
1647      * NOTE: Renouncing ownership will leave the contract without an owner,
1648      * thereby removing any functionality that is only available to the owner.
1649      */
1650     function renounceOwnership() public virtual onlyOwner {
1651         _transferOwnership(address(0));
1652     }
1653 
1654     /**
1655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1656      * Can only be called by the current owner.
1657      */
1658     function transferOwnership(address newOwner) public virtual onlyOwner {
1659         require(newOwner != address(0), "Ownable: new owner is the zero address");
1660         _transferOwnership(newOwner);
1661     }
1662 
1663     /**
1664      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1665      * Internal function without access restriction.
1666      */
1667     function _transferOwnership(address newOwner) internal virtual {
1668         address oldOwner = _owner;
1669         _owner = newOwner;
1670         emit OwnershipTransferred(oldOwner, newOwner);
1671     }
1672 }
1673 
1674 // File: contracts/TheCanineExperiment.sol
1675 
1676 
1677 
1678 pragma solidity ^0.8.15;
1679 
1680 
1681 
1682 
1683 
1684 
1685 
1686 
1687 contract TheCanineExperiment is ERC721A, DefaultOperatorFilterer, Ownable {
1688 
1689     mapping (address => bool) public minterAddress;
1690     bool public flipMint;
1691     string public baseURI;  
1692     uint256 public price = 1000000000;
1693     uint256 public boxSupply = 4000;
1694     uint256 public mintMax = 100;
1695     mapping (address => uint256) public walletPublic;
1696 
1697 
1698     constructor () ERC721A("The Canine Experiment", "CANINE") {
1699         flipMint = false;
1700     }
1701 
1702     function _startTokenId() internal view virtual override returns (uint256) {
1703         return 1;
1704     }
1705 
1706     // Mint
1707     function publicMint(uint256 qty) external payable
1708     {
1709         require(flipMint , "Mint has not begun.");
1710         require(qty <= mintMax, "Reached Max!");
1711         require(totalSupply() + qty <= boxSupply,"Boxes Sold Out!");
1712         require(msg.value >= qty * price,"Missing ETH!");
1713         walletPublic[msg.sender] += qty;
1714         _safeMint(msg.sender, qty);
1715     }
1716 
1717        function airdropToken(uint256[] calldata amount, address[] calldata owners) public onlyOwner {
1718         for(uint256 i = 0; i < owners.length; ++i) {            
1719             _safeMint(owners[i], amount[i]); // Minting of the token
1720         }
1721     }
1722 
1723 
1724     /////////////////////////////
1725     // CONTRACT MANAGEMENT 
1726     /////////////////////////////
1727 
1728     function toggleMint() public onlyOwner {
1729         flipMint = !flipMint;
1730     }
1731 
1732     function setPrice(uint256 newPrice) public onlyOwner {
1733         price = newPrice;
1734     }
1735 
1736     function _baseURI() internal view virtual override returns (string memory) {
1737         return baseURI;
1738     }
1739 
1740     function withdrawFunds() public onlyOwner {
1741 		payable(msg.sender).transfer(address(this).balance);
1742         
1743 	}
1744         function setBaseURI(string memory baseURI_) external onlyOwner {
1745         baseURI = baseURI_;
1746         
1747     }
1748 
1749         function setMaxMints(uint256 newMax) public onlyOwner {
1750         mintMax = newMax;
1751 
1752     }
1753 
1754 
1755     /////////////////////////////
1756     // OPENSEA FILTER REGISTRY 
1757     /////////////////////////////
1758 
1759     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1760         super.setApprovalForAll(operator, approved);
1761     }
1762 
1763     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1764         super.approve(operator, tokenId);
1765     }
1766 
1767     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1768         super.transferFrom(from, to, tokenId);
1769     }
1770 
1771     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1772         super.safeTransferFrom(from, to, tokenId);
1773     }
1774 
1775     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1776         public
1777         payable
1778         override
1779         onlyAllowedOperator(from)
1780     {
1781         super.safeTransferFrom(from, to, tokenId, data);
1782     }
1783 }