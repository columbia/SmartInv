1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-02
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/IOperatorFilterRegistry.sol
7 
8 
9 pragma solidity ^0.8.13;
10 
11 interface IOperatorFilterRegistry {
12     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
13     function register(address registrant) external;
14     function registerAndSubscribe(address registrant, address subscription) external;
15     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
16     function unregister(address addr) external;
17     function updateOperator(address registrant, address operator, bool filtered) external;
18     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
19     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
20     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
21     function subscribe(address registrant, address registrantToSubscribe) external;
22     function unsubscribe(address registrant, bool copyExistingEntries) external;
23     function subscriptionOf(address addr) external returns (address registrant);
24     function subscribers(address registrant) external returns (address[] memory);
25     function subscriberAt(address registrant, uint256 index) external returns (address);
26     function copyEntriesOf(address registrant, address registrantToCopy) external;
27     function isOperatorFiltered(address registrant, address operator) external returns (bool);
28     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
29     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
30     function filteredOperators(address addr) external returns (address[] memory);
31     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
32     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
33     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
34     function isRegistered(address addr) external returns (bool);
35     function codeHashOf(address addr) external returns (bytes32);
36 }
37 
38 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/OperatorFilterer.sol
39 
40 
41 pragma solidity ^0.8.13;
42 
43 
44 /**
45  * @title  OperatorFilterer
46  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
47  *         registrant's entries in the OperatorFilterRegistry.
48  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
49  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
50  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
51  */
52 abstract contract OperatorFilterer {
53     error OperatorNotAllowed(address operator);
54 
55     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
56         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
57 
58     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
59         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
60         // will not revert, but the contract will need to be registered with the registry once it is deployed in
61         // order for the modifier to filter addresses.
62         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
63             if (subscribe) {
64                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
65             } else {
66                 if (subscriptionOrRegistrantToCopy != address(0)) {
67                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
68                 } else {
69                     OPERATOR_FILTER_REGISTRY.register(address(this));
70                 }
71             }
72         }
73     }
74 
75     modifier onlyAllowedOperator(address from) virtual {
76         // Check registry code length to facilitate testing in environments without a deployed registry.
77         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
78             // Allow spending tokens from addresses with balance
79             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
80             // from an EOA.
81             if (from == msg.sender) {
82                 _;
83                 return;
84             }
85             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
86                 revert OperatorNotAllowed(msg.sender);
87             }
88         }
89         _;
90     }
91 
92     modifier onlyAllowedOperatorApproval(address operator) virtual {
93         // Check registry code length to facilitate testing in environments without a deployed registry.
94         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
95             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
96                 revert OperatorNotAllowed(operator);
97             }
98         }
99         _;
100     }
101 }
102 
103 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/DefaultOperatorFilterer.sol
104 
105 
106 pragma solidity ^0.8.13;
107 
108 
109 /**
110  * @title  DefaultOperatorFilterer
111  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
112  */
113 abstract contract DefaultOperatorFilterer is OperatorFilterer {
114     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
115 
116     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
117 }
118 
119 // File: erc721a/contracts/IERC721A.sol
120 
121 
122 // ERC721A Contracts v4.2.3
123 // Creator: Chiru Labs
124 
125 pragma solidity ^0.8.4;
126 
127 /**
128  * @dev Interface of ERC721A.
129  */
130 interface IERC721A {
131     /**
132      * The caller must own the token or be an approved operator.
133      */
134     error ApprovalCallerNotOwnerNorApproved();
135 
136     /**
137      * The token does not exist.
138      */
139     error ApprovalQueryForNonexistentToken();
140 
141     /**
142      * Cannot query the balance for the zero address.
143      */
144     error BalanceQueryForZeroAddress();
145 
146     /**
147      * Cannot mint to the zero address.
148      */
149     error MintToZeroAddress();
150 
151     /**
152      * The quantity of tokens minted must be more than zero.
153      */
154     error MintZeroQuantity();
155 
156     /**
157      * The token does not exist.
158      */
159     error OwnerQueryForNonexistentToken();
160 
161     /**
162      * The caller must own the token or be an approved operator.
163      */
164     error TransferCallerNotOwnerNorApproved();
165 
166     /**
167      * The token must be owned by `from`.
168      */
169     error TransferFromIncorrectOwner();
170 
171     /**
172      * Cannot safely transfer to a contract that does not implement the
173      * ERC721Receiver interface.
174      */
175     error TransferToNonERC721ReceiverImplementer();
176 
177     /**
178      * Cannot transfer to the zero address.
179      */
180     error TransferToZeroAddress();
181 
182     /**
183      * The token does not exist.
184      */
185     error URIQueryForNonexistentToken();
186 
187     /**
188      * The `quantity` minted with ERC2309 exceeds the safety limit.
189      */
190     error MintERC2309QuantityExceedsLimit();
191 
192     /**
193      * The `extraData` cannot be set on an unintialized ownership slot.
194      */
195     error OwnershipNotInitializedForExtraData();
196 
197     // =============================================================
198     //                            STRUCTS
199     // =============================================================
200 
201     struct TokenOwnership {
202         // The address of the owner.
203         address addr;
204         // Stores the start time of ownership with minimal overhead for tokenomics.
205         uint64 startTimestamp;
206         // Whether the token has been burned.
207         bool burned;
208         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
209         uint24 extraData;
210     }
211 
212     // =============================================================
213     //                         TOKEN COUNTERS
214     // =============================================================
215 
216     /**
217      * @dev Returns the total number of tokens in existence.
218      * Burned tokens will reduce the count.
219      * To get the total number of tokens minted, please see {_totalMinted}.
220      */
221     function totalSupply() external view returns (uint256);
222 
223     // =============================================================
224     //                            IERC165
225     // =============================================================
226 
227     /**
228      * @dev Returns true if this contract implements the interface defined by
229      * `interfaceId`. See the corresponding
230      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
231      * to learn more about how these ids are created.
232      *
233      * This function call must use less than 30000 gas.
234      */
235     function supportsInterface(bytes4 interfaceId) external view returns (bool);
236 
237     // =============================================================
238     //                            IERC721
239     // =============================================================
240 
241     /**
242      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
243      */
244     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
245 
246     /**
247      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
248      */
249     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
250 
251     /**
252      * @dev Emitted when `owner` enables or disables
253      * (`approved`) `operator` to manage all of its assets.
254      */
255     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
256 
257     /**
258      * @dev Returns the number of tokens in `owner`'s account.
259      */
260     function balanceOf(address owner) external view returns (uint256 balance);
261 
262     /**
263      * @dev Returns the owner of the `tokenId` token.
264      *
265      * Requirements:
266      *
267      * - `tokenId` must exist.
268      */
269     function ownerOf(uint256 tokenId) external view returns (address owner);
270 
271     /**
272      * @dev Safely transfers `tokenId` token from `from` to `to`,
273      * checking first that contract recipients are aware of the ERC721 protocol
274      * to prevent tokens from being forever locked.
275      *
276      * Requirements:
277      *
278      * - `from` cannot be the zero address.
279      * - `to` cannot be the zero address.
280      * - `tokenId` token must exist and be owned by `from`.
281      * - If the caller is not `from`, it must be have been allowed to move
282      * this token by either {approve} or {setApprovalForAll}.
283      * - If `to` refers to a smart contract, it must implement
284      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
285      *
286      * Emits a {Transfer} event.
287      */
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId,
292         bytes calldata data
293     ) external payable;
294 
295     /**
296      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
297      */
298     function safeTransferFrom(
299         address from,
300         address to,
301         uint256 tokenId
302     ) external payable;
303 
304     /**
305      * @dev Transfers `tokenId` from `from` to `to`.
306      *
307      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
308      * whenever possible.
309      *
310      * Requirements:
311      *
312      * - `from` cannot be the zero address.
313      * - `to` cannot be the zero address.
314      * - `tokenId` token must be owned by `from`.
315      * - If the caller is not `from`, it must be approved to move this token
316      * by either {approve} or {setApprovalForAll}.
317      *
318      * Emits a {Transfer} event.
319      */
320     function transferFrom(
321         address from,
322         address to,
323         uint256 tokenId
324     ) external payable;
325 
326     /**
327      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
328      * The approval is cleared when the token is transferred.
329      *
330      * Only a single account can be approved at a time, so approving the
331      * zero address clears previous approvals.
332      *
333      * Requirements:
334      *
335      * - The caller must own the token or be an approved operator.
336      * - `tokenId` must exist.
337      *
338      * Emits an {Approval} event.
339      */
340     function approve(address to, uint256 tokenId) external payable;
341 
342     /**
343      * @dev Approve or remove `operator` as an operator for the caller.
344      * Operators can call {transferFrom} or {safeTransferFrom}
345      * for any token owned by the caller.
346      *
347      * Requirements:
348      *
349      * - The `operator` cannot be the caller.
350      *
351      * Emits an {ApprovalForAll} event.
352      */
353     function setApprovalForAll(address operator, bool _approved) external;
354 
355     /**
356      * @dev Returns the account approved for `tokenId` token.
357      *
358      * Requirements:
359      *
360      * - `tokenId` must exist.
361      */
362     function getApproved(uint256 tokenId) external view returns (address operator);
363 
364     /**
365      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
366      *
367      * See {setApprovalForAll}.
368      */
369     function isApprovedForAll(address owner, address operator) external view returns (bool);
370 
371     // =============================================================
372     //                        IERC721Metadata
373     // =============================================================
374 
375     /**
376      * @dev Returns the token collection name.
377      */
378     function name() external view returns (string memory);
379 
380     /**
381      * @dev Returns the token collection symbol.
382      */
383     function symbol() external view returns (string memory);
384 
385     /**
386      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
387      */
388     function tokenURI(uint256 tokenId) external view returns (string memory);
389 
390     // =============================================================
391     //                           IERC2309
392     // =============================================================
393 
394     /**
395      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
396      * (inclusive) is transferred from `from` to `to`, as defined in the
397      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
398      *
399      * See {_mintERC2309} for more details.
400      */
401     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
402 }
403 
404 // File: erc721a/contracts/ERC721A.sol
405 
406 
407 // ERC721A Contracts v4.2.3
408 // Creator: Chiru Labs
409 
410 pragma solidity ^0.8.4;
411 
412 
413 /**
414  * @dev Interface of ERC721 token receiver.
415  */
416 interface ERC721A__IERC721Receiver {
417     function onERC721Received(
418         address operator,
419         address from,
420         uint256 tokenId,
421         bytes calldata data
422     ) external returns (bytes4);
423 }
424 
425 /**
426  * @title ERC721A
427  *
428  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
429  * Non-Fungible Token Standard, including the Metadata extension.
430  * Optimized for lower gas during batch mints.
431  *
432  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
433  * starting from `_startTokenId()`.
434  *
435  * Assumptions:
436  *
437  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
438  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
439  */
440 contract ERC721A is IERC721A {
441     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
442     struct TokenApprovalRef {
443         address value;
444     }
445 
446     // =============================================================
447     //                           CONSTANTS
448     // =============================================================
449 
450     // Mask of an entry in packed address data.
451     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
452 
453     // The bit position of `numberMinted` in packed address data.
454     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
455 
456     // The bit position of `numberBurned` in packed address data.
457     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
458 
459     // The bit position of `aux` in packed address data.
460     uint256 private constant _BITPOS_AUX = 192;
461 
462     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
463     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
464 
465     // The bit position of `startTimestamp` in packed ownership.
466     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
467 
468     // The bit mask of the `burned` bit in packed ownership.
469     uint256 private constant _BITMASK_BURNED = 1 << 224;
470 
471     // The bit position of the `nextInitialized` bit in packed ownership.
472     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
473 
474     // The bit mask of the `nextInitialized` bit in packed ownership.
475     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
476 
477     // The bit position of `extraData` in packed ownership.
478     uint256 private constant _BITPOS_EXTRA_DATA = 232;
479 
480     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
481     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
482 
483     // The mask of the lower 160 bits for addresses.
484     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
485 
486     // The maximum `quantity` that can be minted with {_mintERC2309}.
487     // This limit is to prevent overflows on the address data entries.
488     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
489     // is required to cause an overflow, which is unrealistic.
490     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
491 
492     // The `Transfer` event signature is given by:
493     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
494     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
495         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
496 
497     // =============================================================
498     //                            STORAGE
499     // =============================================================
500 
501     // The next token ID to be minted.
502     uint256 private _currentIndex;
503 
504     // The number of tokens burned.
505     uint256 private _burnCounter;
506 
507     // Token name
508     string private _name;
509 
510     // Token symbol
511     string private _symbol;
512 
513     // Mapping from token ID to ownership details
514     // An empty struct value does not necessarily mean the token is unowned.
515     // See {_packedOwnershipOf} implementation for details.
516     //
517     // Bits Layout:
518     // - [0..159]   `addr`
519     // - [160..223] `startTimestamp`
520     // - [224]      `burned`
521     // - [225]      `nextInitialized`
522     // - [232..255] `extraData`
523     mapping(uint256 => uint256) private _packedOwnerships;
524 
525     // Mapping owner address to address data.
526     //
527     // Bits Layout:
528     // - [0..63]    `balance`
529     // - [64..127]  `numberMinted`
530     // - [128..191] `numberBurned`
531     // - [192..255] `aux`
532     mapping(address => uint256) private _packedAddressData;
533 
534     // Mapping from token ID to approved address.
535     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
536 
537     // Mapping from owner to operator approvals
538     mapping(address => mapping(address => bool)) private _operatorApprovals;
539 
540     // =============================================================
541     //                          CONSTRUCTOR
542     // =============================================================
543 
544     constructor(string memory name_, string memory symbol_) {
545         _name = name_;
546         _symbol = symbol_;
547         _currentIndex = _startTokenId();
548     }
549 
550     // =============================================================
551     //                   TOKEN COUNTING OPERATIONS
552     // =============================================================
553 
554     /**
555      * @dev Returns the starting token ID.
556      * To change the starting token ID, please override this function.
557      */
558     function _startTokenId() internal view virtual returns (uint256) {
559         return 0;
560     }
561 
562     /**
563      * @dev Returns the next token ID to be minted.
564      */
565     function _nextTokenId() internal view virtual returns (uint256) {
566         return _currentIndex;
567     }
568 
569     /**
570      * @dev Returns the total number of tokens in existence.
571      * Burned tokens will reduce the count.
572      * To get the total number of tokens minted, please see {_totalMinted}.
573      */
574     function totalSupply() public view virtual override returns (uint256) {
575         // Counter underflow is impossible as _burnCounter cannot be incremented
576         // more than `_currentIndex - _startTokenId()` times.
577         unchecked {
578             return _currentIndex - _burnCounter - _startTokenId();
579         }
580     }
581 
582     /**
583      * @dev Returns the total amount of tokens minted in the contract.
584      */
585     function _totalMinted() internal view virtual returns (uint256) {
586         // Counter underflow is impossible as `_currentIndex` does not decrement,
587         // and it is initialized to `_startTokenId()`.
588         unchecked {
589             return _currentIndex - _startTokenId();
590         }
591     }
592 
593     /**
594      * @dev Returns the total number of tokens burned.
595      */
596     function _totalBurned() internal view virtual returns (uint256) {
597         return _burnCounter;
598     }
599 
600     // =============================================================
601     //                    ADDRESS DATA OPERATIONS
602     // =============================================================
603 
604     /**
605      * @dev Returns the number of tokens in `owner`'s account.
606      */
607     function balanceOf(address owner) public view virtual override returns (uint256) {
608         if (owner == address(0)) revert BalanceQueryForZeroAddress();
609         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
610     }
611 
612     /**
613      * Returns the number of tokens minted by `owner`.
614      */
615     function _numberMinted(address owner) internal view returns (uint256) {
616         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
617     }
618 
619     /**
620      * Returns the number of tokens burned by or on behalf of `owner`.
621      */
622     function _numberBurned(address owner) internal view returns (uint256) {
623         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
624     }
625 
626     /**
627      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
628      */
629     function _getAux(address owner) internal view returns (uint64) {
630         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
631     }
632 
633     /**
634      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
635      * If there are multiple variables, please pack them into a uint64.
636      */
637     function _setAux(address owner, uint64 aux) internal virtual {
638         uint256 packed = _packedAddressData[owner];
639         uint256 auxCasted;
640         // Cast `aux` with assembly to avoid redundant masking.
641         assembly {
642             auxCasted := aux
643         }
644         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
645         _packedAddressData[owner] = packed;
646     }
647 
648     // =============================================================
649     //                            IERC165
650     // =============================================================
651 
652     /**
653      * @dev Returns true if this contract implements the interface defined by
654      * `interfaceId`. See the corresponding
655      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
656      * to learn more about how these ids are created.
657      *
658      * This function call must use less than 30000 gas.
659      */
660     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
661         // The interface IDs are constants representing the first 4 bytes
662         // of the XOR of all function selectors in the interface.
663         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
664         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
665         return
666             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
667             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
668             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
669     }
670 
671     // =============================================================
672     //                        IERC721Metadata
673     // =============================================================
674 
675     /**
676      * @dev Returns the token collection name.
677      */
678  
679     function name() public view virtual override returns (string memory) {
680         return _name;
681     }
682 
683     /**
684      * @dev Returns the token collection symbol.
685      */
686     function symbol() public view virtual override returns (string memory) {
687         return _symbol;
688     }
689 
690     /**
691      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
692      */
693     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
694         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
695 
696         string memory baseURI = _baseURI();
697         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI)) : '';
698     }
699 
700     /**
701      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
702      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
703      * by default, it can be overridden in child contracts.
704      */
705     function _baseURI() internal view virtual returns (string memory) {
706         return '';
707     }
708 
709     // =============================================================
710     //                     OWNERSHIPS OPERATIONS
711     // =============================================================
712 
713     /**
714      * @dev Returns the owner of the `tokenId` token.
715      *
716      * Requirements:
717      *
718      * - `tokenId` must exist.
719      */
720     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
721         return address(uint160(_packedOwnershipOf(tokenId)));
722     }
723 
724     /**
725      * @dev Gas spent here starts off proportional to the maximum mint batch size.
726      * It gradually moves to O(1) as tokens get transferred around over time.
727      */
728     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
729         return _unpackedOwnership(_packedOwnershipOf(tokenId));
730     }
731 
732     /**
733      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
734      */
735     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
736         return _unpackedOwnership(_packedOwnerships[index]);
737     }
738 
739     /**
740      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
741      */
742     function _initializeOwnershipAt(uint256 index) internal virtual {
743         if (_packedOwnerships[index] == 0) {
744             _packedOwnerships[index] = _packedOwnershipOf(index);
745         }
746     }
747 
748     /**
749      * Returns the packed ownership data of `tokenId`.
750      */
751     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
752         uint256 curr = tokenId;
753 
754         unchecked {
755             if (_startTokenId() <= curr)
756                 if (curr < _currentIndex) {
757                     uint256 packed = _packedOwnerships[curr];
758                     // If not burned.
759                     if (packed & _BITMASK_BURNED == 0) {
760                         // Invariant:
761                         // There will always be an initialized ownership slot
762                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
763                         // before an unintialized ownership slot
764                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
765                         // Hence, `curr` will not underflow.
766                         //
767                         // We can directly compare the packed value.
768                         // If the address is zero, packed will be zero.
769                         while (packed == 0) {
770                             packed = _packedOwnerships[--curr];
771                         }
772                         return packed;
773                     }
774                 }
775         }
776         revert OwnerQueryForNonexistentToken();
777     }
778 
779     /**
780      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
781      */
782     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
783         ownership.addr = address(uint160(packed));
784         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
785         ownership.burned = packed & _BITMASK_BURNED != 0;
786         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
787     }
788 
789     /**
790      * @dev Packs ownership data into a single uint256.
791      */
792     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
793         assembly {
794             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
795             owner := and(owner, _BITMASK_ADDRESS)
796             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
797             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
798         }
799     }
800 
801     /**
802      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
803      */
804     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
805         // For branchless setting of the `nextInitialized` flag.
806         assembly {
807             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
808             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
809         }
810     }
811 
812     // =============================================================
813     //                      APPROVAL OPERATIONS
814     // =============================================================
815 
816     /**
817      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
818      * The approval is cleared when the token is transferred.
819      *
820      * Only a single account can be approved at a time, so approving the
821      * zero address clears previous approvals.
822      *
823      * Requirements:
824      *
825      * - The caller must own the token or be an approved operator.
826      * - `tokenId` must exist.
827      *
828      * Emits an {Approval} event.
829      */
830     function approve(address to, uint256 tokenId) public payable virtual override {
831         address owner = ownerOf(tokenId);
832 
833         if (_msgSenderERC721A() != owner)
834             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
835                 revert ApprovalCallerNotOwnerNorApproved();
836             }
837 
838         _tokenApprovals[tokenId].value = to;
839         emit Approval(owner, to, tokenId);
840     }
841 
842     /**
843      * @dev Returns the account approved for `tokenId` token.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must exist.
848      */
849     function getApproved(uint256 tokenId) public view virtual override returns (address) {
850         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
851 
852         return _tokenApprovals[tokenId].value;
853     }
854 
855     /**
856      * @dev Approve or remove `operator` as an operator for the caller.
857      * Operators can call {transferFrom} or {safeTransferFrom}
858      * for any token owned by the caller.
859      *
860      * Requirements:
861      *
862      * - The `operator` cannot be the caller.
863      *
864      * Emits an {ApprovalForAll} event.
865      */
866     function setApprovalForAll(address operator, bool approved) public virtual override {
867         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
868         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
869     }
870 
871     /**
872      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
873      *
874      * See {setApprovalForAll}.
875      */
876     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
877         return _operatorApprovals[owner][operator];
878     }
879 
880     /**
881      * @dev Returns whether `tokenId` exists.
882      *
883      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
884      *
885      * Tokens start existing when they are minted. See {_mint}.
886      */
887     function _exists(uint256 tokenId) internal view virtual returns (bool) {
888         return
889             _startTokenId() <= tokenId &&
890             tokenId < _currentIndex && // If within bounds,
891             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
892     }
893 
894     /**
895      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
896      */
897     function _isSenderApprovedOrOwner(
898         address approvedAddress,
899         address owner,
900         address msgSender
901     ) private pure returns (bool result) {
902         assembly {
903             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
904             owner := and(owner, _BITMASK_ADDRESS)
905             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
906             msgSender := and(msgSender, _BITMASK_ADDRESS)
907             // `msgSender == owner || msgSender == approvedAddress`.
908             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
909         }
910     }
911 
912     /**
913      * @dev Returns the storage slot and value for the approved address of `tokenId`.
914      */
915     function _getApprovedSlotAndAddress(uint256 tokenId)
916         private
917         view
918         returns (uint256 approvedAddressSlot, address approvedAddress)
919     {
920         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
921         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
922         assembly {
923             approvedAddressSlot := tokenApproval.slot
924             approvedAddress := sload(approvedAddressSlot)
925         }
926     }
927 
928     // =============================================================
929     //                      TRANSFER OPERATIONS
930     // =============================================================
931 
932     /**
933      * @dev Transfers `tokenId` from `from` to `to`.
934      *
935      * Requirements:
936      *
937      * - `from` cannot be the zero address.
938      * - `to` cannot be the zero address.
939      * - `tokenId` token must be owned by `from`.
940      * - If the caller is not `from`, it must be approved to move this token
941      * by either {approve} or {setApprovalForAll}.
942      *
943      * Emits a {Transfer} event.
944      */
945     function transferFrom(
946         address from,
947         address to,
948         uint256 tokenId
949     ) public payable virtual override {
950         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
951 
952         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
953 
954         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
955 
956         // The nested ifs save around 20+ gas over a compound boolean condition.
957         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
958             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
959 
960         if (to == address(0)) revert TransferToZeroAddress();
961 
962         _beforeTokenTransfers(from, to, tokenId, 1);
963 
964         // Clear approvals from the previous owner.
965         assembly {
966             if approvedAddress {
967                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
968                 sstore(approvedAddressSlot, 0)
969             }
970         }
971 
972         // Underflow of the sender's balance is impossible because we check for
973         // ownership above and the recipient's balance can't realistically overflow.
974         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
975         unchecked {
976             // We can directly increment and decrement the balances.
977             --_packedAddressData[from]; // Updates: `balance -= 1`.
978             ++_packedAddressData[to]; // Updates: `balance += 1`.
979 
980             // Updates:
981             // - `address` to the next owner.
982             // - `startTimestamp` to the timestamp of transfering.
983             // - `burned` to `false`.
984             // - `nextInitialized` to `true`.
985             _packedOwnerships[tokenId] = _packOwnershipData(
986                 to,
987                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
988             );
989 
990             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
991             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
992                 uint256 nextTokenId = tokenId + 1;
993                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
994                 if (_packedOwnerships[nextTokenId] == 0) {
995                     // If the next slot is within bounds.
996                     if (nextTokenId != _currentIndex) {
997                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
998                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
999                     }
1000                 }
1001             }
1002         }
1003 
1004         emit Transfer(from, to, tokenId);
1005         _afterTokenTransfers(from, to, tokenId, 1);
1006     }
1007 
1008     /**
1009      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1010      */
1011     function safeTransferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) public payable virtual override {
1016         safeTransferFrom(from, to, tokenId, '');
1017     }
1018 
1019     /**
1020      * @dev Safely transfers `tokenId` token from `from` to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `from` cannot be the zero address.
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must exist and be owned by `from`.
1027      * - If the caller is not `from`, it must be approved to move this token
1028      * by either {approve} or {setApprovalForAll}.
1029      * - If `to` refers to a smart contract, it must implement
1030      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) public payable virtual override {
1040         transferFrom(from, to, tokenId);
1041         if (to.code.length != 0)
1042             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1043                 revert TransferToNonERC721ReceiverImplementer();
1044             }
1045     }
1046 
1047     /**
1048      * @dev Hook that is called before a set of serially-ordered token IDs
1049      * are about to be transferred. This includes minting.
1050      * And also called before burning one token.
1051      *
1052      * `startTokenId` - the first token ID to be transferred.
1053      * `quantity` - the amount to be transferred.
1054      *
1055      * Calling conditions:
1056      *
1057      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1058      * transferred to `to`.
1059      * - When `from` is zero, `tokenId` will be minted for `to`.
1060      * - When `to` is zero, `tokenId` will be burned by `from`.
1061      * - `from` and `to` are never both zero.
1062      */
1063     function _beforeTokenTransfers(
1064         address from,
1065         address to,
1066         uint256 startTokenId,
1067         uint256 quantity
1068     ) internal virtual {}
1069 
1070     /**
1071      * @dev Hook that is called after a set of serially-ordered token IDs
1072      * have been transferred. This includes minting.
1073      * And also called after one token has been burned.
1074      *
1075      * `startTokenId` - the first token ID to be transferred.
1076      * `quantity` - the amount to be transferred.
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` has been minted for `to`.
1083      * - When `to` is zero, `tokenId` has been burned by `from`.
1084      * - `from` and `to` are never both zero.
1085      */
1086     function _afterTokenTransfers(
1087         address from,
1088         address to,
1089         uint256 startTokenId,
1090         uint256 quantity
1091     ) internal virtual {}
1092 
1093     /**
1094      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1095      *
1096      * `from` - Previous owner of the given token ID.
1097      * `to` - Target address that will receive the token.
1098      * `tokenId` - Token ID to be transferred.
1099      * `_data` - Optional data to send along with the call.
1100      *
1101      * Returns whether the call correctly returned the expected magic value.
1102      */
1103     function _checkContractOnERC721Received(
1104         address from,
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) private returns (bool) {
1109         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1110             bytes4 retval
1111         ) {
1112             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1113         } catch (bytes memory reason) {
1114             if (reason.length == 0) {
1115                 revert TransferToNonERC721ReceiverImplementer();
1116             } else {
1117                 assembly {
1118                     revert(add(32, reason), mload(reason))
1119                 }
1120             }
1121         }
1122     }
1123 
1124     // =============================================================
1125     //                        MINT OPERATIONS
1126     // =============================================================
1127 
1128     /**
1129      * @dev Mints `quantity` tokens and transfers them to `to`.
1130      *
1131      * Requirements:
1132      *
1133      * - `to` cannot be the zero address.
1134      * - `quantity` must be greater than 0.
1135      *
1136      * Emits a {Transfer} event for each mint.
1137      */
1138     function _mint(address to, uint256 quantity) internal virtual {
1139         uint256 startTokenId = _currentIndex;
1140         if (quantity == 0) revert MintZeroQuantity();
1141 
1142         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1143 
1144         // Overflows are incredibly unrealistic.
1145         // `balance` and `numberMinted` have a maximum limit of 2**64.
1146         // `tokenId` has a maximum limit of 2**256.
1147         unchecked {
1148             // Updates:
1149             // - `balance += quantity`.
1150             // - `numberMinted += quantity`.
1151             //
1152             // We can directly add to the `balance` and `numberMinted`.
1153             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1154 
1155             // Updates:
1156             // - `address` to the owner.
1157             // - `startTimestamp` to the timestamp of minting.
1158             // - `burned` to `false`.
1159             // - `nextInitialized` to `quantity == 1`.
1160             _packedOwnerships[startTokenId] = _packOwnershipData(
1161                 to,
1162                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1163             );
1164 
1165             uint256 toMasked;
1166             uint256 end = startTokenId + quantity;
1167 
1168             // Use assembly to loop and emit the `Transfer` event for gas savings.
1169             // The duplicated `log4` removes an extra check and reduces stack juggling.
1170             // The assembly, together with the surrounding Solidity code, have been
1171             // delicately arranged to nudge the compiler into producing optimized opcodes.
1172             assembly {
1173                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1174                 toMasked := and(to, _BITMASK_ADDRESS)
1175                 // Emit the `Transfer` event.
1176                 log4(
1177                     0, // Start of data (0, since no data).
1178                     0, // End of data (0, since no data).
1179                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1180                     0, // `address(0)`.
1181                     toMasked, // `to`.
1182                     startTokenId // `tokenId`.
1183                 )
1184 
1185                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1186                 // that overflows uint256 will make the loop run out of gas.
1187                 // The compiler will optimize the `iszero` away for performance.
1188                 for {
1189                     let tokenId := add(startTokenId, 1)
1190                 } iszero(eq(tokenId, end)) {
1191                     tokenId := add(tokenId, 1)
1192                 } {
1193                     // Emit the `Transfer` event. Similar to above.
1194                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1195                 }
1196             }
1197             if (toMasked == 0) revert MintToZeroAddress();
1198 
1199             _currentIndex = end;
1200         }
1201         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1202     }
1203 
1204     /**
1205      * @dev Mints `quantity` tokens and transfers them to `to`.
1206      *
1207      * This function is intended for efficient minting only during contract creation.
1208      *
1209      * It emits only one {ConsecutiveTransfer} as defined in
1210      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1211      * instead of a sequence of {Transfer} event(s).
1212      *
1213      * Calling this function outside of contract creation WILL make your contract
1214      * non-compliant with the ERC721 standard.
1215      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1216      * {ConsecutiveTransfer} event is only permissible during contract creation.
1217      *
1218      * Requirements:
1219      *
1220      * - `to` cannot be the zero address.
1221      * - `quantity` must be greater than 0.
1222      *
1223      * Emits a {ConsecutiveTransfer} event.
1224      */
1225     function _mintERC2309(address to, uint256 quantity) internal virtual {
1226         uint256 startTokenId = _currentIndex;
1227         if (to == address(0)) revert MintToZeroAddress();
1228         if (quantity == 0) revert MintZeroQuantity();
1229         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1230 
1231         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1232 
1233         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1234         unchecked {
1235             // Updates:
1236             // - `balance += quantity`.
1237             // - `numberMinted += quantity`.
1238             //
1239             // We can directly add to the `balance` and `numberMinted`.
1240             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1241 
1242             // Updates:
1243             // - `address` to the owner.
1244             // - `startTimestamp` to the timestamp of minting.
1245             // - `burned` to `false`.
1246             // - `nextInitialized` to `quantity == 1`.
1247             _packedOwnerships[startTokenId] = _packOwnershipData(
1248                 to,
1249                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1250             );
1251 
1252             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1253 
1254             _currentIndex = startTokenId + quantity;
1255         }
1256         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1257     }
1258 
1259     /**
1260      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1261      *
1262      * Requirements:
1263      *
1264      * - If `to` refers to a smart contract, it must implement
1265      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1266      * - `quantity` must be greater than 0.
1267      *
1268      * See {_mint}.
1269      *
1270      * Emits a {Transfer} event for each mint.
1271      */
1272     function _safeMint(
1273         address to,
1274         uint256 quantity,
1275         bytes memory _data
1276     ) internal virtual {
1277         _mint(to, quantity);
1278 
1279         unchecked {
1280             if (to.code.length != 0) {
1281                 uint256 end = _currentIndex;
1282                 uint256 index = end - quantity;
1283                 do {
1284                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1285                         revert TransferToNonERC721ReceiverImplementer();
1286                     }
1287                 } while (index < end);
1288                 // Reentrancy protection.
1289                 if (_currentIndex != end) revert();
1290             }
1291         }
1292     }
1293 
1294     /**
1295      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1296      */
1297     function _safeMint(address to, uint256 quantity) internal virtual {
1298         _safeMint(to, quantity, '');
1299     }
1300 
1301     // =============================================================
1302     //                        BURN OPERATIONS
1303     // =============================================================
1304 
1305     /**
1306      * @dev Equivalent to `_burn(tokenId, false)`.
1307      */
1308     function _burn(uint256 tokenId) internal virtual {
1309         _burn(tokenId, false);
1310     }
1311 
1312     /**
1313      * @dev Destroys `tokenId`.
1314      * The approval is cleared when the token is burned.
1315      *
1316      * Requirements:
1317      *
1318      * - `tokenId` must exist.
1319      *
1320      * Emits a {Transfer} event.
1321      */
1322     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1323         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1324 
1325         address from = address(uint160(prevOwnershipPacked));
1326 
1327         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1328 
1329         if (approvalCheck) {
1330             // The nested ifs save around 20+ gas over a compound boolean condition.
1331             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1332                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1333         }
1334 
1335         _beforeTokenTransfers(from, address(0), tokenId, 1);
1336 
1337         // Clear approvals from the previous owner.
1338         assembly {
1339             if approvedAddress {
1340                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1341                 sstore(approvedAddressSlot, 0)
1342             }
1343         }
1344 
1345         // Underflow of the sender's balance is impossible because we check for
1346         // ownership above and the recipient's balance can't realistically overflow.
1347         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1348         unchecked {
1349             // Updates:
1350             // - `balance -= 1`.
1351             // - `numberBurned += 1`.
1352             //
1353             // We can directly decrement the balance, and increment the number burned.
1354             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1355             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1356 
1357             // Updates:
1358             // - `address` to the last owner.
1359             // - `startTimestamp` to the timestamp of burning.
1360             // - `burned` to `true`.
1361             // - `nextInitialized` to `true`.
1362             _packedOwnerships[tokenId] = _packOwnershipData(
1363                 from,
1364                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1365             );
1366 
1367             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1368             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1369                 uint256 nextTokenId = tokenId + 1;
1370                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1371                 if (_packedOwnerships[nextTokenId] == 0) {
1372                     // If the next slot is within bounds.
1373                     if (nextTokenId != _currentIndex) {
1374                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1375                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1376                     }
1377                 }
1378             }
1379         }
1380 
1381         emit Transfer(from, address(0), tokenId);
1382         _afterTokenTransfers(from, address(0), tokenId, 1);
1383 
1384         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1385         unchecked {
1386             _burnCounter++;
1387         }
1388     }
1389 
1390     // =============================================================
1391     //                     EXTRA DATA OPERATIONS
1392     // =============================================================
1393 
1394     /**
1395      * @dev Directly sets the extra data for the ownership data `index`.
1396      */
1397     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1398         uint256 packed = _packedOwnerships[index];
1399         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1400         uint256 extraDataCasted;
1401         // Cast `extraData` with assembly to avoid redundant masking.
1402         assembly {
1403             extraDataCasted := extraData
1404         }
1405         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1406         _packedOwnerships[index] = packed;
1407     }
1408 
1409     /**
1410      * @dev Called during each token transfer to set the 24bit `extraData` field.
1411      * Intended to be overridden by the cosumer contract.
1412      *
1413      * `previousExtraData` - the value of `extraData` before transfer.
1414      *
1415      * Calling conditions:
1416      *
1417      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1418      * transferred to `to`.
1419      * - When `from` is zero, `tokenId` will be minted for `to`.
1420      * - When `to` is zero, `tokenId` will be burned by `from`.
1421      * - `from` and `to` are never both zero.
1422      */
1423     function _extraData(
1424         address from,
1425         address to,
1426         uint24 previousExtraData
1427     ) internal view virtual returns (uint24) {}
1428 
1429     /**
1430      * @dev Returns the next extra data for the packed ownership data.
1431      * The returned result is shifted into position.
1432      */
1433     function _nextExtraData(
1434         address from,
1435         address to,
1436         uint256 prevOwnershipPacked
1437     ) private view returns (uint256) {
1438         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1439         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1440     }
1441 
1442     // =============================================================
1443     //                       OTHER OPERATIONS
1444     // =============================================================
1445 
1446     /**
1447      * @dev Returns the message sender (defaults to `msg.sender`).
1448      *
1449      * If you are writing GSN compatible contracts, you need to override this function.
1450      */
1451     function _msgSenderERC721A() internal view virtual returns (address) {
1452         return msg.sender;
1453     }
1454 
1455     /**
1456      * @dev Converts a uint256 to its ASCII string decimal representation.
1457      */
1458     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1459         assembly {
1460             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1461             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1462             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1463             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1464             let m := add(mload(0x40), 0xa0)
1465             // Update the free memory pointer to allocate.
1466             mstore(0x40, m)
1467             // Assign the `str` to the end.
1468             str := sub(m, 0x20)
1469             // Zeroize the slot after the string.
1470             mstore(str, 0)
1471 
1472             // Cache the end of the memory to calculate the length later.
1473             let end := str
1474 
1475             // We write the string from rightmost digit to leftmost digit.
1476             // The following is essentially a do-while loop that also handles the zero case.
1477             // prettier-ignore
1478             for { let temp := value } 1 {} {
1479                 str := sub(str, 1)
1480                 // Write the character to the pointer.
1481                 // The ASCII index of the '0' character is 48.
1482                 mstore8(str, add(48, mod(temp, 10)))
1483                 // Keep dividing `temp` until zero.
1484                 temp := div(temp, 10)
1485                 // prettier-ignore
1486                 if iszero(temp) { break }
1487             }
1488 
1489             let length := sub(end, str)
1490             // Move the pointer 32 bytes leftwards to make room for the length.
1491             str := sub(str, 0x20)
1492             // Store the length.
1493             mstore(str, length)
1494         }
1495     }
1496 }
1497 
1498 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1499 
1500 
1501 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1502 
1503 pragma solidity ^0.8.0;
1504 
1505 /**
1506  * @dev Contract module that helps prevent reentrant calls to a function.
1507  *
1508  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1509  * available, which can be applied to functions to make sure there are no nested
1510  * (reentrant) calls to them.
1511  *
1512  * Note that because there is a single `nonReentrant` guard, functions marked as
1513  * `nonReentrant` may not call one another. This can be worked around by making
1514  * those functions `private`, and then adding `external` `nonReentrant` entry
1515  * points to them.
1516  *
1517  * TIP: If you would like to learn more about reentrancy and alternative ways
1518  * to protect against it, check out our blog post
1519  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1520  */
1521 abstract contract ReentrancyGuard {
1522     // Booleans are more expensive than uint256 or any type that takes up a full
1523     // word because each write operation emits an extra SLOAD to first read the
1524     // slot's contents, replace the bits taken up by the boolean, and then write
1525     // back. This is the compiler's defense against contract upgrades and
1526     // pointer aliasing, and it cannot be disabled.
1527 
1528     // The values being non-zero value makes deployment a bit more expensive,
1529     // but in exchange the refund on every call to nonReentrant will be lower in
1530     // amount. Since refunds are capped to a percentage of the total
1531     // transaction's gas, it is best to keep them low in cases like this one, to
1532     // increase the likelihood of the full refund coming into effect.
1533     uint256 private constant _NOT_ENTERED = 1;
1534     uint256 private constant _ENTERED = 2;
1535 
1536     uint256 private _status;
1537 
1538     constructor() {
1539         _status = _NOT_ENTERED;
1540     }
1541 
1542     /**
1543      * @dev Prevents a contract from calling itself, directly or indirectly.
1544      * Calling a `nonReentrant` function from another `nonReentrant`
1545      * function is not supported. It is possible to prevent this from happening
1546      * by making the `nonReentrant` function external, and making it call a
1547      * `private` function that does the actual work.
1548      */
1549     modifier nonReentrant() {
1550         _nonReentrantBefore();
1551         _;
1552         _nonReentrantAfter();
1553     }
1554 
1555     function _nonReentrantBefore() private {
1556         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1557         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1558 
1559         // Any calls to nonReentrant after this point will fail
1560         _status = _ENTERED;
1561     }
1562 
1563     function _nonReentrantAfter() private {
1564         // By storing the original value once again, a refund is triggered (see
1565         // https://eips.ethereum.org/EIPS/eip-2200)
1566         _status = _NOT_ENTERED;
1567     }
1568 }
1569 
1570 // File: @openzeppelin/contracts/utils/Context.sol
1571 
1572 
1573 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1574 
1575 pragma solidity ^0.8.0;
1576 
1577 /**
1578  * @dev Provides information about the current execution context, including the
1579  * sender of the transaction and its data. While these are generally available
1580  * via msg.sender and msg.data, they should not be accessed in such a direct
1581  * manner, since when dealing with meta-transactions the account sending and
1582  * paying for execution may not be the actual sender (as far as an application
1583  * is concerned).
1584  *
1585  * This contract is only required for intermediate, library-like contracts.
1586  */
1587 abstract contract Context {
1588     function _msgSender() internal view virtual returns (address) {
1589         return msg.sender;
1590     }
1591 
1592     function _msgData() internal view virtual returns (bytes calldata) {
1593         return msg.data;
1594     }
1595 }
1596 
1597 // File: @openzeppelin/contracts/access/Ownable.sol
1598 
1599 
1600 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1601 
1602 pragma solidity ^0.8.0;
1603 
1604 
1605 /**
1606  * @dev Contract module which provides a basic access control mechanism, where
1607  * there is an account (an owner) that can be granted exclusive access to
1608  * specific functions.
1609  *
1610  * By default, the owner account will be the one that deploys the contract. This
1611  * can later be changed with {transferOwnership}.
1612  *
1613  * This module is used through inheritance. It will make available the modifier
1614  * `onlyOwner`, which can be applied to your functions to restrict their use to
1615  * the owner.
1616  */
1617 abstract contract Ownable is Context {
1618     address private _owner;
1619 
1620     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1621 
1622     /**
1623      * @dev Initializes the contract setting the deployer as the initial owner.
1624      */
1625     constructor() {
1626         _transferOwnership(_msgSender());
1627     }
1628 
1629     /**
1630      * @dev Throws if called by any account other than the owner.
1631      */
1632     modifier onlyOwner() {
1633         _checkOwner();
1634         _;
1635     }
1636 
1637     /**
1638      * @dev Returns the address of the current owner.
1639      */
1640     function owner() public view virtual returns (address) {
1641         return _owner;
1642     }
1643 
1644     /**
1645      * @dev Throws if the sender is not the owner.
1646      */
1647     function _checkOwner() internal view virtual {
1648         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1649     }
1650 
1651     /**
1652      * @dev Leaves the contract without owner. It will not be possible to call
1653      * `onlyOwner` functions anymore. Can only be called by the current owner.
1654      *
1655      * NOTE: Renouncing ownership will leave the contract without an owner,
1656      * thereby removing any functionality that is only available to the owner.
1657      */
1658     function renounceOwnership() public virtual onlyOwner {
1659         _transferOwnership(address(0));
1660     }
1661 
1662     /**
1663      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1664      * Can only be called by the current owner.
1665      */
1666     function transferOwnership(address newOwner) public virtual onlyOwner {
1667         require(newOwner != address(0), "Ownable: new owner is the zero address");
1668         _transferOwnership(newOwner);
1669     }
1670 
1671     /**
1672      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1673      * Internal function without access restriction.
1674      */
1675     function _transferOwnership(address newOwner) internal virtual {
1676         address oldOwner = _owner;
1677         _owner = newOwner;
1678         emit OwnershipTransferred(oldOwner, newOwner);
1679     }
1680 }
1681 
1682 
1683 pragma solidity ^0.8.15;
1684 
1685 
1686 contract JPEGSByCosmic999 is ERC721A, DefaultOperatorFilterer, Ownable {
1687 
1688     string public baseURI = "ipfs://QmNbQ4Dq3wxqUMe6nX8qBtNTJeQpA3nj7EtyedhwKvUNCa";  
1689     string public baseExtension = ".json";
1690     uint256 public price = 0.005 ether;
1691     uint256 public maxSupply = 999;
1692     uint256 public maxPerTransaction = 10; 
1693 
1694     modifier callerIsUser() {
1695         require(tx.origin == msg.sender, "The caller is another contract");
1696         _;
1697     }
1698     constructor () ERC721A("999 JPEGS By Cosmic", "JPEGS") {
1699     }
1700 
1701     function _startTokenId() internal view virtual override returns (uint256) {
1702         return 1;
1703     }
1704 
1705     // Mint
1706     function publicMint(uint256 amount) public payable callerIsUser{
1707         require(amount <= maxPerTransaction, "Over Max Per Transaction!");
1708         require(totalSupply() + amount <= maxSupply, "Sold Out!");
1709         uint256 mintAmount = amount;
1710         
1711         if (totalSupply() % 2 != 0 ) {
1712             mintAmount--;
1713         }
1714 
1715         require(msg.value > 0 || mintAmount == 0, "Insufficient Value!");
1716         if (msg.value >= price * mintAmount) {
1717             _safeMint(msg.sender, amount);
1718         }
1719     }     
1720 
1721     /////////////////////////////
1722     // CONTRACT MANAGEMENT 
1723     /////////////////////////////
1724 
1725     function setPrice(uint256 newPrice) public onlyOwner {
1726         price = newPrice;
1727     }
1728 
1729     function _baseURI() internal view virtual override returns (string memory) {
1730         return baseURI;
1731     }
1732 
1733     function withdraw() public onlyOwner {
1734 		payable(msg.sender).transfer(address(this).balance);
1735         
1736 	}
1737     
1738     function setBaseURI(string memory baseURI_) external onlyOwner {
1739         baseURI = baseURI_;
1740     } 
1741 
1742     /////////////////////////////
1743     // OPENSEA FILTER REGISTRY 
1744     /////////////////////////////
1745 
1746     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1747         super.setApprovalForAll(operator, approved);
1748     }
1749 
1750     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1751         super.approve(operator, tokenId);
1752     }
1753 
1754     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1755         super.transferFrom(from, to, tokenId);
1756     }
1757 
1758     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1759         super.safeTransferFrom(from, to, tokenId);
1760     }
1761 
1762     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1763         public
1764         payable
1765         override
1766         onlyAllowedOperator(from)
1767     {
1768         super.safeTransferFrom(from, to, tokenId, data);
1769     }
1770 }