1 // SPDX-License-Identifier: MIT
2 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
3 
4 
5 pragma solidity ^0.8.13;
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
33 
34 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 /**
41  * @title  OperatorFilterer
42  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
43  *         registrant's entries in the OperatorFilterRegistry.
44  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
45  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
46  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
47  */
48 abstract contract OperatorFilterer {
49     error OperatorNotAllowed(address operator);
50 
51     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
52         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
53 
54     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
55         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
56         // will not revert, but the contract will need to be registered with the registry once it is deployed in
57         // order for the modifier to filter addresses.
58         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
59             if (subscribe) {
60                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
61             } else {
62                 if (subscriptionOrRegistrantToCopy != address(0)) {
63                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
64                 } else {
65                     OPERATOR_FILTER_REGISTRY.register(address(this));
66                 }
67             }
68         }
69     }
70 
71     modifier onlyAllowedOperator(address from) virtual {
72         // Allow spending tokens from addresses with balance
73         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
74         // from an EOA.
75         if (from != msg.sender) {
76             _checkFilterOperator(msg.sender);
77         }
78         _;
79     }
80 
81     modifier onlyAllowedOperatorApproval(address operator) virtual {
82         _checkFilterOperator(operator);
83         _;
84     }
85 
86     function _checkFilterOperator(address operator) internal view virtual {
87         // Check registry code length to facilitate testing in environments without a deployed registry.
88         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
89             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
90                 revert OperatorNotAllowed(operator);
91             }
92         }
93     }
94 }
95 
96 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol
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
112 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
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
397 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
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
743     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
744         if (_startTokenId() <= tokenId) {
745             packed = _packedOwnerships[tokenId];
746             // If not burned.
747             if (packed & _BITMASK_BURNED == 0) {
748                 // If the data at the starting slot does not exist, start the scan.
749                 if (packed == 0) {
750                     if (tokenId >= _currentIndex) revert OwnerQueryForNonexistentToken();
751                     // Invariant:
752                     // There will always be an initialized ownership slot
753                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
754                     // before an unintialized ownership slot
755                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
756                     // Hence, `tokenId` will not underflow.
757                     //
758                     // We can directly compare the packed value.
759                     // If the address is zero, packed will be zero.
760                     for (;;) {
761                         unchecked {
762                             packed = _packedOwnerships[--tokenId];
763                         }
764                         if (packed == 0) continue;
765                         return packed;
766                     }
767                 }
768                 // Otherwise, the data exists and is not burned. We can skip the scan.
769                 // This is possible because we have already achieved the target condition.
770                 // This saves 2143 gas on transfers of initialized tokens.
771                 return packed;
772             }
773         }
774         revert OwnerQueryForNonexistentToken();
775     }
776 
777     /**
778      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
779      */
780     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
781         ownership.addr = address(uint160(packed));
782         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
783         ownership.burned = packed & _BITMASK_BURNED != 0;
784         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
785     }
786 
787     /**
788      * @dev Packs ownership data into a single uint256.
789      */
790     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
791         assembly {
792             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
793             owner := and(owner, _BITMASK_ADDRESS)
794             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
795             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
796         }
797     }
798 
799     /**
800      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
801      */
802     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
803         // For branchless setting of the `nextInitialized` flag.
804         assembly {
805             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
806             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
807         }
808     }
809 
810     // =============================================================
811     //                      APPROVAL OPERATIONS
812     // =============================================================
813 
814     /**
815      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
816      *
817      * Requirements:
818      *
819      * - The caller must own the token or be an approved operator.
820      */
821     function approve(address to, uint256 tokenId) public payable virtual override {
822         _approve(to, tokenId, true);
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
850         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
851         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
852     }
853 
854     /**
855      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
856      *
857      * See {setApprovalForAll}.
858      */
859     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
860         return _operatorApprovals[owner][operator];
861     }
862 
863     /**
864      * @dev Returns whether `tokenId` exists.
865      *
866      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
867      *
868      * Tokens start existing when they are minted. See {_mint}.
869      */
870     function _exists(uint256 tokenId) internal view virtual returns (bool) {
871         return
872             _startTokenId() <= tokenId &&
873             tokenId < _currentIndex && // If within bounds,
874             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
875     }
876 
877     /**
878      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
879      */
880     function _isSenderApprovedOrOwner(
881         address approvedAddress,
882         address owner,
883         address msgSender
884     ) private pure returns (bool result) {
885         assembly {
886             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
887             owner := and(owner, _BITMASK_ADDRESS)
888             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
889             msgSender := and(msgSender, _BITMASK_ADDRESS)
890             // `msgSender == owner || msgSender == approvedAddress`.
891             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
892         }
893     }
894 
895     /**
896      * @dev Returns the storage slot and value for the approved address of `tokenId`.
897      */
898     function _getApprovedSlotAndAddress(uint256 tokenId)
899         private
900         view
901         returns (uint256 approvedAddressSlot, address approvedAddress)
902     {
903         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
904         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
905         assembly {
906             approvedAddressSlot := tokenApproval.slot
907             approvedAddress := sload(approvedAddressSlot)
908         }
909     }
910 
911     // =============================================================
912     //                      TRANSFER OPERATIONS
913     // =============================================================
914 
915     /**
916      * @dev Transfers `tokenId` from `from` to `to`.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must be owned by `from`.
923      * - If the caller is not `from`, it must be approved to move this token
924      * by either {approve} or {setApprovalForAll}.
925      *
926      * Emits a {Transfer} event.
927      */
928     function transferFrom(
929         address from,
930         address to,
931         uint256 tokenId
932     ) public payable virtual override {
933         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
934 
935         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
936 
937         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
938 
939         // The nested ifs save around 20+ gas over a compound boolean condition.
940         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
941             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
942 
943         if (to == address(0)) revert TransferToZeroAddress();
944 
945         _beforeTokenTransfers(from, to, tokenId, 1);
946 
947         // Clear approvals from the previous owner.
948         assembly {
949             if approvedAddress {
950                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
951                 sstore(approvedAddressSlot, 0)
952             }
953         }
954 
955         // Underflow of the sender's balance is impossible because we check for
956         // ownership above and the recipient's balance can't realistically overflow.
957         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
958         unchecked {
959             // We can directly increment and decrement the balances.
960             --_packedAddressData[from]; // Updates: `balance -= 1`.
961             ++_packedAddressData[to]; // Updates: `balance += 1`.
962 
963             // Updates:
964             // - `address` to the next owner.
965             // - `startTimestamp` to the timestamp of transfering.
966             // - `burned` to `false`.
967             // - `nextInitialized` to `true`.
968             _packedOwnerships[tokenId] = _packOwnershipData(
969                 to,
970                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
971             );
972 
973             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
974             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
975                 uint256 nextTokenId = tokenId + 1;
976                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
977                 if (_packedOwnerships[nextTokenId] == 0) {
978                     // If the next slot is within bounds.
979                     if (nextTokenId != _currentIndex) {
980                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
981                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
982                     }
983                 }
984             }
985         }
986 
987         emit Transfer(from, to, tokenId);
988         _afterTokenTransfers(from, to, tokenId, 1);
989     }
990 
991     /**
992      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
993      */
994     function safeTransferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public payable virtual override {
999         safeTransferFrom(from, to, tokenId, '');
1000     }
1001 
1002     /**
1003      * @dev Safely transfers `tokenId` token from `from` to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - `from` cannot be the zero address.
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must exist and be owned by `from`.
1010      * - If the caller is not `from`, it must be approved to move this token
1011      * by either {approve} or {setApprovalForAll}.
1012      * - If `to` refers to a smart contract, it must implement
1013      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function safeTransferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) public payable virtual override {
1023         transferFrom(from, to, tokenId);
1024         if (to.code.length != 0)
1025             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1026                 revert TransferToNonERC721ReceiverImplementer();
1027             }
1028     }
1029 
1030     /**
1031      * @dev Hook that is called before a set of serially-ordered token IDs
1032      * are about to be transferred. This includes minting.
1033      * And also called before burning one token.
1034      *
1035      * `startTokenId` - the first token ID to be transferred.
1036      * `quantity` - the amount to be transferred.
1037      *
1038      * Calling conditions:
1039      *
1040      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1041      * transferred to `to`.
1042      * - When `from` is zero, `tokenId` will be minted for `to`.
1043      * - When `to` is zero, `tokenId` will be burned by `from`.
1044      * - `from` and `to` are never both zero.
1045      */
1046     function _beforeTokenTransfers(
1047         address from,
1048         address to,
1049         uint256 startTokenId,
1050         uint256 quantity
1051     ) internal virtual {}
1052 
1053     /**
1054      * @dev Hook that is called after a set of serially-ordered token IDs
1055      * have been transferred. This includes minting.
1056      * And also called after one token has been burned.
1057      *
1058      * `startTokenId` - the first token ID to be transferred.
1059      * `quantity` - the amount to be transferred.
1060      *
1061      * Calling conditions:
1062      *
1063      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1064      * transferred to `to`.
1065      * - When `from` is zero, `tokenId` has been minted for `to`.
1066      * - When `to` is zero, `tokenId` has been burned by `from`.
1067      * - `from` and `to` are never both zero.
1068      */
1069     function _afterTokenTransfers(
1070         address from,
1071         address to,
1072         uint256 startTokenId,
1073         uint256 quantity
1074     ) internal virtual {}
1075 
1076     /**
1077      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1078      *
1079      * `from` - Previous owner of the given token ID.
1080      * `to` - Target address that will receive the token.
1081      * `tokenId` - Token ID to be transferred.
1082      * `_data` - Optional data to send along with the call.
1083      *
1084      * Returns whether the call correctly returned the expected magic value.
1085      */
1086     function _checkContractOnERC721Received(
1087         address from,
1088         address to,
1089         uint256 tokenId,
1090         bytes memory _data
1091     ) private returns (bool) {
1092         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1093             bytes4 retval
1094         ) {
1095             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1096         } catch (bytes memory reason) {
1097             if (reason.length == 0) {
1098                 revert TransferToNonERC721ReceiverImplementer();
1099             } else {
1100                 assembly {
1101                     revert(add(32, reason), mload(reason))
1102                 }
1103             }
1104         }
1105     }
1106 
1107     // =============================================================
1108     //                        MINT OPERATIONS
1109     // =============================================================
1110 
1111     /**
1112      * @dev Mints `quantity` tokens and transfers them to `to`.
1113      *
1114      * Requirements:
1115      *
1116      * - `to` cannot be the zero address.
1117      * - `quantity` must be greater than 0.
1118      *
1119      * Emits a {Transfer} event for each mint.
1120      */
1121     function _mint(address to, uint256 quantity) internal virtual {
1122         uint256 startTokenId = _currentIndex;
1123         if (quantity == 0) revert MintZeroQuantity();
1124 
1125         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1126 
1127         // Overflows are incredibly unrealistic.
1128         // `balance` and `numberMinted` have a maximum limit of 2**64.
1129         // `tokenId` has a maximum limit of 2**256.
1130         unchecked {
1131             // Updates:
1132             // - `balance += quantity`.
1133             // - `numberMinted += quantity`.
1134             //
1135             // We can directly add to the `balance` and `numberMinted`.
1136             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1137 
1138             // Updates:
1139             // - `address` to the owner.
1140             // - `startTimestamp` to the timestamp of minting.
1141             // - `burned` to `false`.
1142             // - `nextInitialized` to `quantity == 1`.
1143             _packedOwnerships[startTokenId] = _packOwnershipData(
1144                 to,
1145                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1146             );
1147 
1148             uint256 toMasked;
1149             uint256 end = startTokenId + quantity;
1150 
1151             // Use assembly to loop and emit the `Transfer` event for gas savings.
1152             // The duplicated `log4` removes an extra check and reduces stack juggling.
1153             // The assembly, together with the surrounding Solidity code, have been
1154             // delicately arranged to nudge the compiler into producing optimized opcodes.
1155             assembly {
1156                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1157                 toMasked := and(to, _BITMASK_ADDRESS)
1158                 // Emit the `Transfer` event.
1159                 log4(
1160                     0, // Start of data (0, since no data).
1161                     0, // End of data (0, since no data).
1162                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1163                     0, // `address(0)`.
1164                     toMasked, // `to`.
1165                     startTokenId // `tokenId`.
1166                 )
1167 
1168                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1169                 // that overflows uint256 will make the loop run out of gas.
1170                 // The compiler will optimize the `iszero` away for performance.
1171                 for {
1172                     let tokenId := add(startTokenId, 1)
1173                 } iszero(eq(tokenId, end)) {
1174                     tokenId := add(tokenId, 1)
1175                 } {
1176                     // Emit the `Transfer` event. Similar to above.
1177                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1178                 }
1179             }
1180             if (toMasked == 0) revert MintToZeroAddress();
1181 
1182             _currentIndex = end;
1183         }
1184         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1185     }
1186 
1187     /**
1188      * @dev Mints `quantity` tokens and transfers them to `to`.
1189      *
1190      * This function is intended for efficient minting only during contract creation.
1191      *
1192      * It emits only one {ConsecutiveTransfer} as defined in
1193      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1194      * instead of a sequence of {Transfer} event(s).
1195      *
1196      * Calling this function outside of contract creation WILL make your contract
1197      * non-compliant with the ERC721 standard.
1198      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1199      * {ConsecutiveTransfer} event is only permissible during contract creation.
1200      *
1201      * Requirements:
1202      *
1203      * - `to` cannot be the zero address.
1204      * - `quantity` must be greater than 0.
1205      *
1206      * Emits a {ConsecutiveTransfer} event.
1207      */
1208     function _mintERC2309(address to, uint256 quantity) internal virtual {
1209         uint256 startTokenId = _currentIndex;
1210         if (to == address(0)) revert MintToZeroAddress();
1211         if (quantity == 0) revert MintZeroQuantity();
1212         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1213 
1214         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1215 
1216         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1217         unchecked {
1218             // Updates:
1219             // - `balance += quantity`.
1220             // - `numberMinted += quantity`.
1221             //
1222             // We can directly add to the `balance` and `numberMinted`.
1223             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1224 
1225             // Updates:
1226             // - `address` to the owner.
1227             // - `startTimestamp` to the timestamp of minting.
1228             // - `burned` to `false`.
1229             // - `nextInitialized` to `quantity == 1`.
1230             _packedOwnerships[startTokenId] = _packOwnershipData(
1231                 to,
1232                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1233             );
1234 
1235             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1236 
1237             _currentIndex = startTokenId + quantity;
1238         }
1239         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1240     }
1241 
1242     /**
1243      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1244      *
1245      * Requirements:
1246      *
1247      * - If `to` refers to a smart contract, it must implement
1248      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1249      * - `quantity` must be greater than 0.
1250      *
1251      * See {_mint}.
1252      *
1253      * Emits a {Transfer} event for each mint.
1254      */
1255     function _safeMint(
1256         address to,
1257         uint256 quantity,
1258         bytes memory _data
1259     ) internal virtual {
1260         _mint(to, quantity);
1261 
1262         unchecked {
1263             if (to.code.length != 0) {
1264                 uint256 end = _currentIndex;
1265                 uint256 index = end - quantity;
1266                 do {
1267                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1268                         revert TransferToNonERC721ReceiverImplementer();
1269                     }
1270                 } while (index < end);
1271                 // Reentrancy protection.
1272                 if (_currentIndex != end) revert();
1273             }
1274         }
1275     }
1276 
1277     /**
1278      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1279      */
1280     function _safeMint(address to, uint256 quantity) internal virtual {
1281         _safeMint(to, quantity, '');
1282     }
1283 
1284     // =============================================================
1285     //                       APPROVAL OPERATIONS
1286     // =============================================================
1287 
1288     /**
1289      * @dev Equivalent to `_approve(to, tokenId, false)`.
1290      */
1291     function _approve(address to, uint256 tokenId) internal virtual {
1292         _approve(to, tokenId, false);
1293     }
1294 
1295     /**
1296      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1297      * The approval is cleared when the token is transferred.
1298      *
1299      * Only a single account can be approved at a time, so approving the
1300      * zero address clears previous approvals.
1301      *
1302      * Requirements:
1303      *
1304      * - `tokenId` must exist.
1305      *
1306      * Emits an {Approval} event.
1307      */
1308     function _approve(
1309         address to,
1310         uint256 tokenId,
1311         bool approvalCheck
1312     ) internal virtual {
1313         address owner = ownerOf(tokenId);
1314 
1315         if (approvalCheck)
1316             if (_msgSenderERC721A() != owner)
1317                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1318                     revert ApprovalCallerNotOwnerNorApproved();
1319                 }
1320 
1321         _tokenApprovals[tokenId].value = to;
1322         emit Approval(owner, to, tokenId);
1323     }
1324 
1325     // =============================================================
1326     //                        BURN OPERATIONS
1327     // =============================================================
1328 
1329     /**
1330      * @dev Equivalent to `_burn(tokenId, false)`.
1331      */
1332     function _burn(uint256 tokenId) internal virtual {
1333         _burn(tokenId, false);
1334     }
1335 
1336     /**
1337      * @dev Destroys `tokenId`.
1338      * The approval is cleared when the token is burned.
1339      *
1340      * Requirements:
1341      *
1342      * - `tokenId` must exist.
1343      *
1344      * Emits a {Transfer} event.
1345      */
1346     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1347         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1348 
1349         address from = address(uint160(prevOwnershipPacked));
1350 
1351         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1352 
1353         if (approvalCheck) {
1354             // The nested ifs save around 20+ gas over a compound boolean condition.
1355             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1356                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1357         }
1358 
1359         _beforeTokenTransfers(from, address(0), tokenId, 1);
1360 
1361         // Clear approvals from the previous owner.
1362         assembly {
1363             if approvedAddress {
1364                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1365                 sstore(approvedAddressSlot, 0)
1366             }
1367         }
1368 
1369         // Underflow of the sender's balance is impossible because we check for
1370         // ownership above and the recipient's balance can't realistically overflow.
1371         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1372         unchecked {
1373             // Updates:
1374             // - `balance -= 1`.
1375             // - `numberBurned += 1`.
1376             //
1377             // We can directly decrement the balance, and increment the number burned.
1378             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1379             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1380 
1381             // Updates:
1382             // - `address` to the last owner.
1383             // - `startTimestamp` to the timestamp of burning.
1384             // - `burned` to `true`.
1385             // - `nextInitialized` to `true`.
1386             _packedOwnerships[tokenId] = _packOwnershipData(
1387                 from,
1388                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1389             );
1390 
1391             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1392             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1393                 uint256 nextTokenId = tokenId + 1;
1394                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1395                 if (_packedOwnerships[nextTokenId] == 0) {
1396                     // If the next slot is within bounds.
1397                     if (nextTokenId != _currentIndex) {
1398                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1399                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1400                     }
1401                 }
1402             }
1403         }
1404 
1405         emit Transfer(from, address(0), tokenId);
1406         _afterTokenTransfers(from, address(0), tokenId, 1);
1407 
1408         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1409         unchecked {
1410             _burnCounter++;
1411         }
1412     }
1413 
1414     // =============================================================
1415     //                     EXTRA DATA OPERATIONS
1416     // =============================================================
1417 
1418     /**
1419      * @dev Directly sets the extra data for the ownership data `index`.
1420      */
1421     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1422         uint256 packed = _packedOwnerships[index];
1423         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1424         uint256 extraDataCasted;
1425         // Cast `extraData` with assembly to avoid redundant masking.
1426         assembly {
1427             extraDataCasted := extraData
1428         }
1429         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1430         _packedOwnerships[index] = packed;
1431     }
1432 
1433     /**
1434      * @dev Called during each token transfer to set the 24bit `extraData` field.
1435      * Intended to be overridden by the cosumer contract.
1436      *
1437      * `previousExtraData` - the value of `extraData` before transfer.
1438      *
1439      * Calling conditions:
1440      *
1441      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1442      * transferred to `to`.
1443      * - When `from` is zero, `tokenId` will be minted for `to`.
1444      * - When `to` is zero, `tokenId` will be burned by `from`.
1445      * - `from` and `to` are never both zero.
1446      */
1447     function _extraData(
1448         address from,
1449         address to,
1450         uint24 previousExtraData
1451     ) internal view virtual returns (uint24) {}
1452 
1453     /**
1454      * @dev Returns the next extra data for the packed ownership data.
1455      * The returned result is shifted into position.
1456      */
1457     function _nextExtraData(
1458         address from,
1459         address to,
1460         uint256 prevOwnershipPacked
1461     ) private view returns (uint256) {
1462         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1463         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1464     }
1465 
1466     // =============================================================
1467     //                       OTHER OPERATIONS
1468     // =============================================================
1469 
1470     /**
1471      * @dev Returns the message sender (defaults to `msg.sender`).
1472      *
1473      * If you are writing GSN compatible contracts, you need to override this function.
1474      */
1475     function _msgSenderERC721A() internal view virtual returns (address) {
1476         return msg.sender;
1477     }
1478 
1479     /**
1480      * @dev Converts a uint256 to its ASCII string decimal representation.
1481      */
1482     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1483         assembly {
1484             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1485             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1486             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1487             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1488             let m := add(mload(0x40), 0xa0)
1489             // Update the free memory pointer to allocate.
1490             mstore(0x40, m)
1491             // Assign the `str` to the end.
1492             str := sub(m, 0x20)
1493             // Zeroize the slot after the string.
1494             mstore(str, 0)
1495 
1496             // Cache the end of the memory to calculate the length later.
1497             let end := str
1498 
1499             // We write the string from rightmost digit to leftmost digit.
1500             // The following is essentially a do-while loop that also handles the zero case.
1501             // prettier-ignore
1502             for { let temp := value } 1 {} {
1503                 str := sub(str, 1)
1504                 // Write the character to the pointer.
1505                 // The ASCII index of the '0' character is 48.
1506                 mstore8(str, add(48, mod(temp, 10)))
1507                 // Keep dividing `temp` until zero.
1508                 temp := div(temp, 10)
1509                 // prettier-ignore
1510                 if iszero(temp) { break }
1511             }
1512 
1513             let length := sub(end, str)
1514             // Move the pointer 32 bytes leftwards to make room for the length.
1515             str := sub(str, 0x20)
1516             // Store the length.
1517             mstore(str, length)
1518         }
1519     }
1520 }
1521 
1522 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/utils/Context.sol
1523 
1524 
1525 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1526 
1527 pragma solidity ^0.8.0;
1528 
1529 /**
1530  * @dev Provides information about the current execution context, including the
1531  * sender of the transaction and its data. While these are generally available
1532  * via msg.sender and msg.data, they should not be accessed in such a direct
1533  * manner, since when dealing with meta-transactions the account sending and
1534  * paying for execution may not be the actual sender (as far as an application
1535  * is concerned).
1536  *
1537  * This contract is only required for intermediate, library-like contracts.
1538  */
1539 abstract contract Context {
1540     function _msgSender() internal view virtual returns (address) {
1541         return msg.sender;
1542     }
1543 
1544     function _msgData() internal view virtual returns (bytes calldata) {
1545         return msg.data;
1546     }
1547 }
1548 
1549 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/access/Ownable.sol
1550 
1551 
1552 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1553 
1554 pragma solidity ^0.8.0;
1555 
1556 
1557 /**
1558  * @dev Contract module which provides a basic access control mechanism, where
1559  * there is an account (an owner) that can be granted exclusive access to
1560  * specific functions.
1561  *
1562  * By default, the owner account will be the one that deploys the contract. This
1563  * can later be changed with {transferOwnership}.
1564  *
1565  * This module is used through inheritance. It will make available the modifier
1566  * `onlyOwner`, which can be applied to your functions to restrict their use to
1567  * the owner.
1568  */
1569 abstract contract Ownable is Context {
1570     address private _owner;
1571 
1572     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1573 
1574     /**
1575      * @dev Initializes the contract setting the deployer as the initial owner.
1576      */
1577     constructor() {
1578         _transferOwnership(_msgSender());
1579     }
1580 
1581     /**
1582      * @dev Throws if called by any account other than the owner.
1583      */
1584     modifier onlyOwner() {
1585         _checkOwner();
1586         _;
1587     }
1588 
1589     /**
1590      * @dev Returns the address of the current owner.
1591      */
1592     function owner() public view virtual returns (address) {
1593         return _owner;
1594     }
1595 
1596     /**
1597      * @dev Throws if the sender is not the owner.
1598      */
1599     function _checkOwner() internal view virtual {
1600         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1601     }
1602 
1603     /**
1604      * @dev Leaves the contract without owner. It will not be possible to call
1605      * `onlyOwner` functions anymore. Can only be called by the current owner.
1606      *
1607      * NOTE: Renouncing ownership will leave the contract without an owner,
1608      * thereby removing any functionality that is only available to the owner.
1609      */
1610     function renounceOwnership() public virtual onlyOwner {
1611         _transferOwnership(address(0));
1612     }
1613 
1614     /**
1615      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1616      * Can only be called by the current owner.
1617      */
1618     function transferOwnership(address newOwner) public virtual onlyOwner {
1619         require(newOwner != address(0), "Ownable: new owner is the zero address");
1620         _transferOwnership(newOwner);
1621     }
1622 
1623     /**
1624      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1625      * Internal function without access restriction.
1626      */
1627     function _transferOwnership(address newOwner) internal virtual {
1628         address oldOwner = _owner;
1629         _owner = newOwner;
1630         emit OwnershipTransferred(oldOwner, newOwner);
1631     }
1632 }
1633 
1634 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/utils/math/Math.sol
1635 
1636 
1637 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1638 
1639 pragma solidity ^0.8.0;
1640 
1641 /**
1642  * @dev Standard math utilities missing in the Solidity language.
1643  */
1644 library Math {
1645     enum Rounding {
1646         Down, // Toward negative infinity
1647         Up, // Toward infinity
1648         Zero // Toward zero
1649     }
1650 
1651     /**
1652      * @dev Returns the largest of two numbers.
1653      */
1654     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1655         return a > b ? a : b;
1656     }
1657 
1658     /**
1659      * @dev Returns the smallest of two numbers.
1660      */
1661     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1662         return a < b ? a : b;
1663     }
1664 
1665     /**
1666      * @dev Returns the average of two numbers. The result is rounded towards
1667      * zero.
1668      */
1669     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1670         // (a + b) / 2 can overflow.
1671         return (a & b) + (a ^ b) / 2;
1672     }
1673 
1674     /**
1675      * @dev Returns the ceiling of the division of two numbers.
1676      *
1677      * This differs from standard division with `/` in that it rounds up instead
1678      * of rounding down.
1679      */
1680     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1681         // (a + b - 1) / b can overflow on addition, so we distribute.
1682         return a == 0 ? 0 : (a - 1) / b + 1;
1683     }
1684 
1685     /**
1686      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1687      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1688      * with further edits by Uniswap Labs also under MIT license.
1689      */
1690     function mulDiv(
1691         uint256 x,
1692         uint256 y,
1693         uint256 denominator
1694     ) internal pure returns (uint256 result) {
1695         unchecked {
1696             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1697             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1698             // variables such that product = prod1 * 2^256 + prod0.
1699             uint256 prod0; // Least significant 256 bits of the product
1700             uint256 prod1; // Most significant 256 bits of the product
1701             assembly {
1702                 let mm := mulmod(x, y, not(0))
1703                 prod0 := mul(x, y)
1704                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1705             }
1706 
1707             // Handle non-overflow cases, 256 by 256 division.
1708             if (prod1 == 0) {
1709                 return prod0 / denominator;
1710             }
1711 
1712             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1713             require(denominator > prod1);
1714 
1715             ///////////////////////////////////////////////
1716             // 512 by 256 division.
1717             ///////////////////////////////////////////////
1718 
1719             // Make division exact by subtracting the remainder from [prod1 prod0].
1720             uint256 remainder;
1721             assembly {
1722                 // Compute remainder using mulmod.
1723                 remainder := mulmod(x, y, denominator)
1724 
1725                 // Subtract 256 bit number from 512 bit number.
1726                 prod1 := sub(prod1, gt(remainder, prod0))
1727                 prod0 := sub(prod0, remainder)
1728             }
1729 
1730             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1731             // See https://cs.stackexchange.com/q/138556/92363.
1732 
1733             // Does not overflow because the denominator cannot be zero at this stage in the function.
1734             uint256 twos = denominator & (~denominator + 1);
1735             assembly {
1736                 // Divide denominator by twos.
1737                 denominator := div(denominator, twos)
1738 
1739                 // Divide [prod1 prod0] by twos.
1740                 prod0 := div(prod0, twos)
1741 
1742                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1743                 twos := add(div(sub(0, twos), twos), 1)
1744             }
1745 
1746             // Shift in bits from prod1 into prod0.
1747             prod0 |= prod1 * twos;
1748 
1749             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1750             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1751             // four bits. That is, denominator * inv = 1 mod 2^4.
1752             uint256 inverse = (3 * denominator) ^ 2;
1753 
1754             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1755             // in modular arithmetic, doubling the correct bits in each step.
1756             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1757             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1758             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1759             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1760             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1761             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1762 
1763             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1764             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1765             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1766             // is no longer required.
1767             result = prod0 * inverse;
1768             return result;
1769         }
1770     }
1771 
1772     /**
1773      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1774      */
1775     function mulDiv(
1776         uint256 x,
1777         uint256 y,
1778         uint256 denominator,
1779         Rounding rounding
1780     ) internal pure returns (uint256) {
1781         uint256 result = mulDiv(x, y, denominator);
1782         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1783             result += 1;
1784         }
1785         return result;
1786     }
1787 
1788     /**
1789      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1790      *
1791      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1792      */
1793     function sqrt(uint256 a) internal pure returns (uint256) {
1794         if (a == 0) {
1795             return 0;
1796         }
1797 
1798         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1799         //
1800         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1801         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1802         //
1803         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1804         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1805         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1806         //
1807         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1808         uint256 result = 1 << (log2(a) >> 1);
1809 
1810         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1811         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1812         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1813         // into the expected uint128 result.
1814         unchecked {
1815             result = (result + a / result) >> 1;
1816             result = (result + a / result) >> 1;
1817             result = (result + a / result) >> 1;
1818             result = (result + a / result) >> 1;
1819             result = (result + a / result) >> 1;
1820             result = (result + a / result) >> 1;
1821             result = (result + a / result) >> 1;
1822             return min(result, a / result);
1823         }
1824     }
1825 
1826     /**
1827      * @notice Calculates sqrt(a), following the selected rounding direction.
1828      */
1829     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1830         unchecked {
1831             uint256 result = sqrt(a);
1832             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1833         }
1834     }
1835 
1836     /**
1837      * @dev Return the log in base 2, rounded down, of a positive value.
1838      * Returns 0 if given 0.
1839      */
1840     function log2(uint256 value) internal pure returns (uint256) {
1841         uint256 result = 0;
1842         unchecked {
1843             if (value >> 128 > 0) {
1844                 value >>= 128;
1845                 result += 128;
1846             }
1847             if (value >> 64 > 0) {
1848                 value >>= 64;
1849                 result += 64;
1850             }
1851             if (value >> 32 > 0) {
1852                 value >>= 32;
1853                 result += 32;
1854             }
1855             if (value >> 16 > 0) {
1856                 value >>= 16;
1857                 result += 16;
1858             }
1859             if (value >> 8 > 0) {
1860                 value >>= 8;
1861                 result += 8;
1862             }
1863             if (value >> 4 > 0) {
1864                 value >>= 4;
1865                 result += 4;
1866             }
1867             if (value >> 2 > 0) {
1868                 value >>= 2;
1869                 result += 2;
1870             }
1871             if (value >> 1 > 0) {
1872                 result += 1;
1873             }
1874         }
1875         return result;
1876     }
1877 
1878     /**
1879      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1880      * Returns 0 if given 0.
1881      */
1882     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1883         unchecked {
1884             uint256 result = log2(value);
1885             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1886         }
1887     }
1888 
1889     /**
1890      * @dev Return the log in base 10, rounded down, of a positive value.
1891      * Returns 0 if given 0.
1892      */
1893     function log10(uint256 value) internal pure returns (uint256) {
1894         uint256 result = 0;
1895         unchecked {
1896             if (value >= 10**64) {
1897                 value /= 10**64;
1898                 result += 64;
1899             }
1900             if (value >= 10**32) {
1901                 value /= 10**32;
1902                 result += 32;
1903             }
1904             if (value >= 10**16) {
1905                 value /= 10**16;
1906                 result += 16;
1907             }
1908             if (value >= 10**8) {
1909                 value /= 10**8;
1910                 result += 8;
1911             }
1912             if (value >= 10**4) {
1913                 value /= 10**4;
1914                 result += 4;
1915             }
1916             if (value >= 10**2) {
1917                 value /= 10**2;
1918                 result += 2;
1919             }
1920             if (value >= 10**1) {
1921                 result += 1;
1922             }
1923         }
1924         return result;
1925     }
1926 
1927     /**
1928      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1929      * Returns 0 if given 0.
1930      */
1931     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1932         unchecked {
1933             uint256 result = log10(value);
1934             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1935         }
1936     }
1937 
1938     /**
1939      * @dev Return the log in base 256, rounded down, of a positive value.
1940      * Returns 0 if given 0.
1941      *
1942      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1943      */
1944     function log256(uint256 value) internal pure returns (uint256) {
1945         uint256 result = 0;
1946         unchecked {
1947             if (value >> 128 > 0) {
1948                 value >>= 128;
1949                 result += 16;
1950             }
1951             if (value >> 64 > 0) {
1952                 value >>= 64;
1953                 result += 8;
1954             }
1955             if (value >> 32 > 0) {
1956                 value >>= 32;
1957                 result += 4;
1958             }
1959             if (value >> 16 > 0) {
1960                 value >>= 16;
1961                 result += 2;
1962             }
1963             if (value >> 8 > 0) {
1964                 result += 1;
1965             }
1966         }
1967         return result;
1968     }
1969 
1970     /**
1971      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1972      * Returns 0 if given 0.
1973      */
1974     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1975         unchecked {
1976             uint256 result = log256(value);
1977             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1978         }
1979     }
1980 }
1981 
1982 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/utils/Strings.sol
1983 
1984 
1985 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1986 
1987 pragma solidity ^0.8.0;
1988 
1989 
1990 /**
1991  * @dev String operations.
1992  */
1993 library Strings {
1994     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1995     uint8 private constant _ADDRESS_LENGTH = 20;
1996 
1997     /**
1998      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1999      */
2000     function toString(uint256 value) internal pure returns (string memory) {
2001         unchecked {
2002             uint256 length = Math.log10(value) + 1;
2003             string memory buffer = new string(length);
2004             uint256 ptr;
2005             /// @solidity memory-safe-assembly
2006             assembly {
2007                 ptr := add(buffer, add(32, length))
2008             }
2009             while (true) {
2010                 ptr--;
2011                 /// @solidity memory-safe-assembly
2012                 assembly {
2013                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2014                 }
2015                 value /= 10;
2016                 if (value == 0) break;
2017             }
2018             return buffer;
2019         }
2020     }
2021 
2022     /**
2023      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2024      */
2025     function toHexString(uint256 value) internal pure returns (string memory) {
2026         unchecked {
2027             return toHexString(value, Math.log256(value) + 1);
2028         }
2029     }
2030 
2031     /**
2032      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2033      */
2034     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2035         bytes memory buffer = new bytes(2 * length + 2);
2036         buffer[0] = "0";
2037         buffer[1] = "x";
2038         for (uint256 i = 2 * length + 1; i > 1; --i) {
2039             buffer[i] = _SYMBOLS[value & 0xf];
2040             value >>= 4;
2041         }
2042         require(value == 0, "Strings: hex length insufficient");
2043         return string(buffer);
2044     }
2045 
2046     /**
2047      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2048      */
2049     function toHexString(address addr) internal pure returns (string memory) {
2050         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2051     }
2052 }
2053 
2054 // File: HHS.sol
2055 
2056 
2057 
2058 pragma solidity ^0.8.13;
2059 
2060 
2061 
2062 
2063 
2064 
2065 contract HirokaHighSchool is ERC721A, Ownable, DefaultOperatorFilterer {
2066 
2067 
2068   error MintInactive();
2069   error ContractCaller();
2070   error InvalidAmount();
2071   error ExceedsSupply();
2072   error InvalidValue();
2073   error LengthsDoNotMatch();
2074   error InvalidToken();
2075   error NotTokenOwner();
2076   error TokenHasMinted(uint256 tokenId);
2077 
2078   using Strings for uint256;
2079 
2080   IERC721A public AnEnd;
2081 
2082   string public baseURI;
2083 
2084   uint256 public price = 0.005 ether;
2085   uint256 public constant MAX_SUPPLY = 444;
2086   uint256 public constant MAX_PER_TX = 5;
2087 
2088   bool public holderSaleActive = false;
2089   bool public saleActive = false;
2090 
2091   mapping(uint256 => bool) anEndTokenHasMinted;
2092 
2093 
2094   constructor(address anEndAddress) ERC721A("Hiroko High School", "HHS") {
2095     _mint(msg.sender, 1);
2096     AnEnd = IERC721A(anEndAddress);
2097   }
2098 
2099   function holderMint(uint256[] calldata anEndTokenIdsHeld) public payable {
2100     if (!holderSaleActive) revert MintInactive();
2101     if (msg.sender != tx.origin) revert ContractCaller();
2102     uint256 length = anEndTokenIdsHeld.length;
2103     unchecked {
2104       if (length + totalSupply() > MAX_SUPPLY) revert ExceedsSupply();
2105       for (uint256 i = 0; i < length; i++) {
2106         if (anEndTokenHasMinted[anEndTokenIdsHeld[i]]) revert TokenHasMinted(anEndTokenIdsHeld[i]);
2107         if (AnEnd.ownerOf(anEndTokenIdsHeld[i]) != msg.sender) revert NotTokenOwner();
2108         anEndTokenHasMinted[anEndTokenIdsHeld[i]] = true;
2109       }
2110     }
2111     _mint(msg.sender, length);
2112   }
2113 
2114   function mint(uint256 mintAmount_) public payable {
2115     if (!saleActive) revert MintInactive();
2116     if (msg.sender != tx.origin) revert ContractCaller();
2117     if (mintAmount_ > MAX_PER_TX) revert InvalidAmount();
2118     unchecked {
2119       if (mintAmount_ + totalSupply() > MAX_SUPPLY) revert ExceedsSupply();
2120       if (msg.value != mintAmount_ * price) revert InvalidValue();
2121     }
2122     _mint(msg.sender, mintAmount_);
2123   }
2124 
2125   function mintForAddress(uint256 mintAmount_, address to_) external onlyOwner {
2126     _mint(to_, mintAmount_);
2127   }
2128 
2129   function batchMintForAddresses(address[] calldata addresses_, uint256[] calldata amounts_) external onlyOwner {
2130     if (addresses_.length != amounts_.length) revert LengthsDoNotMatch();
2131     unchecked {
2132       for (uint32 i = 0; i < addresses_.length; i++) {
2133         _mint(addresses_[i], amounts_[i]);
2134       }
2135     }
2136   }
2137 
2138   function _startTokenId() internal view virtual override returns (uint256) {
2139     return 1;
2140   }
2141 
2142   function flipSaleActive() external onlyOwner {
2143     saleActive = !saleActive;
2144   }
2145 
2146   function flipHolderSale() external onlyOwner {
2147     holderSaleActive = !holderSaleActive;
2148   }
2149 
2150   function setPrice(uint256 price_) external onlyOwner {
2151     price = price_;
2152   }
2153 
2154   function withdraw() external onlyOwner {
2155     payable(owner()).transfer(address(this).balance);
2156   }
2157 
2158   function setBaseURI(string memory newBaseURI_) external onlyOwner {
2159     baseURI = newBaseURI_;
2160   }
2161 
2162   function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
2163     if (!_exists(tokenId_)) revert InvalidToken();
2164     return string(abi.encodePacked(baseURI, tokenId_.toString(), ".json"));
2165   }
2166 
2167   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2168     super.setApprovalForAll(operator, approved);
2169   }
2170 
2171   function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2172     super.approve(operator, tokenId);
2173   }
2174 
2175   function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2176     super.transferFrom(from, to, tokenId);
2177   }
2178 
2179   function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2180     super.safeTransferFrom(from, to, tokenId);
2181   }
2182 
2183   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from){
2184     super.safeTransferFrom(from, to, tokenId, data);
2185   }
2186 
2187 }