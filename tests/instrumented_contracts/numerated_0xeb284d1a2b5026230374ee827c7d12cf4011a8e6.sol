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
678     function name() public view virtual override returns (string memory) {
679         return _name;
680     }
681 
682     /**
683      * @dev Returns the token collection symbol.
684      */
685     function symbol() public view virtual override returns (string memory) {
686         return _symbol;
687     }
688 
689     /**
690      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
691      */
692     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
693         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
694 
695         string memory baseURI = _baseURI();
696         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
697     }
698 
699     /**
700      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
701      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
702      * by default, it can be overridden in child contracts.
703      */
704     function _baseURI() internal view virtual returns (string memory) {
705         return '';
706     }
707 
708     // =============================================================
709     //                     OWNERSHIPS OPERATIONS
710     // =============================================================
711 
712     /**
713      * @dev Returns the owner of the `tokenId` token.
714      *
715      * Requirements:
716      *
717      * - `tokenId` must exist.
718      */
719     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
720         return address(uint160(_packedOwnershipOf(tokenId)));
721     }
722 
723     /**
724      * @dev Gas spent here starts off proportional to the maximum mint batch size.
725      * It gradually moves to O(1) as tokens get transferred around over time.
726      */
727     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
728         return _unpackedOwnership(_packedOwnershipOf(tokenId));
729     }
730 
731     /**
732      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
733      */
734     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
735         return _unpackedOwnership(_packedOwnerships[index]);
736     }
737 
738     /**
739      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
740      */
741     function _initializeOwnershipAt(uint256 index) internal virtual {
742         if (_packedOwnerships[index] == 0) {
743             _packedOwnerships[index] = _packedOwnershipOf(index);
744         }
745     }
746 
747     /**
748      * Returns the packed ownership data of `tokenId`.
749      */
750     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
751         uint256 curr = tokenId;
752 
753         unchecked {
754             if (_startTokenId() <= curr)
755                 if (curr < _currentIndex) {
756                     uint256 packed = _packedOwnerships[curr];
757                     // If not burned.
758                     if (packed & _BITMASK_BURNED == 0) {
759                         // Invariant:
760                         // There will always be an initialized ownership slot
761                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
762                         // before an unintialized ownership slot
763                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
764                         // Hence, `curr` will not underflow.
765                         //
766                         // We can directly compare the packed value.
767                         // If the address is zero, packed will be zero.
768                         while (packed == 0) {
769                             packed = _packedOwnerships[--curr];
770                         }
771                         return packed;
772                     }
773                 }
774         }
775         revert OwnerQueryForNonexistentToken();
776     }
777 
778     /**
779      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
780      */
781     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
782         ownership.addr = address(uint160(packed));
783         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
784         ownership.burned = packed & _BITMASK_BURNED != 0;
785         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
786     }
787 
788     /**
789      * @dev Packs ownership data into a single uint256.
790      */
791     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
792         assembly {
793             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
794             owner := and(owner, _BITMASK_ADDRESS)
795             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
796             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
797         }
798     }
799 
800     /**
801      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
802      */
803     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
804         // For branchless setting of the `nextInitialized` flag.
805         assembly {
806             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
807             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
808         }
809     }
810 
811     // =============================================================
812     //                      APPROVAL OPERATIONS
813     // =============================================================
814 
815     /**
816      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
817      * The approval is cleared when the token is transferred.
818      *
819      * Only a single account can be approved at a time, so approving the
820      * zero address clears previous approvals.
821      *
822      * Requirements:
823      *
824      * - The caller must own the token or be an approved operator.
825      * - `tokenId` must exist.
826      *
827      * Emits an {Approval} event.
828      */
829     function approve(address to, uint256 tokenId) public payable virtual override {
830         address owner = ownerOf(tokenId);
831 
832         if (_msgSenderERC721A() != owner)
833             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
834                 revert ApprovalCallerNotOwnerNorApproved();
835             }
836 
837         _tokenApprovals[tokenId].value = to;
838         emit Approval(owner, to, tokenId);
839     }
840 
841     /**
842      * @dev Returns the account approved for `tokenId` token.
843      *
844      * Requirements:
845      *
846      * - `tokenId` must exist.
847      */
848     function getApproved(uint256 tokenId) public view virtual override returns (address) {
849         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
850 
851         return _tokenApprovals[tokenId].value;
852     }
853 
854     /**
855      * @dev Approve or remove `operator` as an operator for the caller.
856      * Operators can call {transferFrom} or {safeTransferFrom}
857      * for any token owned by the caller.
858      *
859      * Requirements:
860      *
861      * - The `operator` cannot be the caller.
862      *
863      * Emits an {ApprovalForAll} event.
864      */
865     function setApprovalForAll(address operator, bool approved) public virtual override {
866         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
867         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
868     }
869 
870     /**
871      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
872      *
873      * See {setApprovalForAll}.
874      */
875     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev Returns whether `tokenId` exists.
881      *
882      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
883      *
884      * Tokens start existing when they are minted. See {_mint}.
885      */
886     function _exists(uint256 tokenId) internal view virtual returns (bool) {
887         return
888             _startTokenId() <= tokenId &&
889             tokenId < _currentIndex && // If within bounds,
890             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
891     }
892 
893     /**
894      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
895      */
896     function _isSenderApprovedOrOwner(
897         address approvedAddress,
898         address owner,
899         address msgSender
900     ) private pure returns (bool result) {
901         assembly {
902             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
903             owner := and(owner, _BITMASK_ADDRESS)
904             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
905             msgSender := and(msgSender, _BITMASK_ADDRESS)
906             // `msgSender == owner || msgSender == approvedAddress`.
907             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
908         }
909     }
910 
911     /**
912      * @dev Returns the storage slot and value for the approved address of `tokenId`.
913      */
914     function _getApprovedSlotAndAddress(uint256 tokenId)
915         private
916         view
917         returns (uint256 approvedAddressSlot, address approvedAddress)
918     {
919         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
920         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
921         assembly {
922             approvedAddressSlot := tokenApproval.slot
923             approvedAddress := sload(approvedAddressSlot)
924         }
925     }
926 
927     // =============================================================
928     //                      TRANSFER OPERATIONS
929     // =============================================================
930 
931     /**
932      * @dev Transfers `tokenId` from `from` to `to`.
933      *
934      * Requirements:
935      *
936      * - `from` cannot be the zero address.
937      * - `to` cannot be the zero address.
938      * - `tokenId` token must be owned by `from`.
939      * - If the caller is not `from`, it must be approved to move this token
940      * by either {approve} or {setApprovalForAll}.
941      *
942      * Emits a {Transfer} event.
943      */
944     function transferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) public payable virtual override {
949         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
950 
951         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
952 
953         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
954 
955         // The nested ifs save around 20+ gas over a compound boolean condition.
956         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
957             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
958 
959         if (to == address(0)) revert TransferToZeroAddress();
960 
961         _beforeTokenTransfers(from, to, tokenId, 1);
962 
963         // Clear approvals from the previous owner.
964         assembly {
965             if approvedAddress {
966                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
967                 sstore(approvedAddressSlot, 0)
968             }
969         }
970 
971         // Underflow of the sender's balance is impossible because we check for
972         // ownership above and the recipient's balance can't realistically overflow.
973         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
974         unchecked {
975             // We can directly increment and decrement the balances.
976             --_packedAddressData[from]; // Updates: `balance -= 1`.
977             ++_packedAddressData[to]; // Updates: `balance += 1`.
978 
979             // Updates:
980             // - `address` to the next owner.
981             // - `startTimestamp` to the timestamp of transfering.
982             // - `burned` to `false`.
983             // - `nextInitialized` to `true`.
984             _packedOwnerships[tokenId] = _packOwnershipData(
985                 to,
986                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
987             );
988 
989             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
990             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
991                 uint256 nextTokenId = tokenId + 1;
992                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
993                 if (_packedOwnerships[nextTokenId] == 0) {
994                     // If the next slot is within bounds.
995                     if (nextTokenId != _currentIndex) {
996                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
997                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
998                     }
999                 }
1000             }
1001         }
1002 
1003         emit Transfer(from, to, tokenId);
1004         _afterTokenTransfers(from, to, tokenId, 1);
1005     }
1006 
1007     /**
1008      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1009      */
1010     function safeTransferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public payable virtual override {
1015         safeTransferFrom(from, to, tokenId, '');
1016     }
1017 
1018     /**
1019      * @dev Safely transfers `tokenId` token from `from` to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `from` cannot be the zero address.
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must exist and be owned by `from`.
1026      * - If the caller is not `from`, it must be approved to move this token
1027      * by either {approve} or {setApprovalForAll}.
1028      * - If `to` refers to a smart contract, it must implement
1029      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) public payable virtual override {
1039         transferFrom(from, to, tokenId);
1040         if (to.code.length != 0)
1041             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1042                 revert TransferToNonERC721ReceiverImplementer();
1043             }
1044     }
1045 
1046     /**
1047      * @dev Hook that is called before a set of serially-ordered token IDs
1048      * are about to be transferred. This includes minting.
1049      * And also called before burning one token.
1050      *
1051      * `startTokenId` - the first token ID to be transferred.
1052      * `quantity` - the amount to be transferred.
1053      *
1054      * Calling conditions:
1055      *
1056      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1057      * transferred to `to`.
1058      * - When `from` is zero, `tokenId` will be minted for `to`.
1059      * - When `to` is zero, `tokenId` will be burned by `from`.
1060      * - `from` and `to` are never both zero.
1061      */
1062     function _beforeTokenTransfers(
1063         address from,
1064         address to,
1065         uint256 startTokenId,
1066         uint256 quantity
1067     ) internal virtual {}
1068 
1069     /**
1070      * @dev Hook that is called after a set of serially-ordered token IDs
1071      * have been transferred. This includes minting.
1072      * And also called after one token has been burned.
1073      *
1074      * `startTokenId` - the first token ID to be transferred.
1075      * `quantity` - the amount to be transferred.
1076      *
1077      * Calling conditions:
1078      *
1079      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1080      * transferred to `to`.
1081      * - When `from` is zero, `tokenId` has been minted for `to`.
1082      * - When `to` is zero, `tokenId` has been burned by `from`.
1083      * - `from` and `to` are never both zero.
1084      */
1085     function _afterTokenTransfers(
1086         address from,
1087         address to,
1088         uint256 startTokenId,
1089         uint256 quantity
1090     ) internal virtual {}
1091 
1092     /**
1093      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1094      *
1095      * `from` - Previous owner of the given token ID.
1096      * `to` - Target address that will receive the token.
1097      * `tokenId` - Token ID to be transferred.
1098      * `_data` - Optional data to send along with the call.
1099      *
1100      * Returns whether the call correctly returned the expected magic value.
1101      */
1102     function _checkContractOnERC721Received(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) private returns (bool) {
1108         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1109             bytes4 retval
1110         ) {
1111             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1112         } catch (bytes memory reason) {
1113             if (reason.length == 0) {
1114                 revert TransferToNonERC721ReceiverImplementer();
1115             } else {
1116                 assembly {
1117                     revert(add(32, reason), mload(reason))
1118                 }
1119             }
1120         }
1121     }
1122 
1123     // =============================================================
1124     //                        MINT OPERATIONS
1125     // =============================================================
1126 
1127     /**
1128      * @dev Mints `quantity` tokens and transfers them to `to`.
1129      *
1130      * Requirements:
1131      *
1132      * - `to` cannot be the zero address.
1133      * - `quantity` must be greater than 0.
1134      *
1135      * Emits a {Transfer} event for each mint.
1136      */
1137     function _mint(address to, uint256 quantity) internal virtual {
1138         uint256 startTokenId = _currentIndex;
1139         if (quantity == 0) revert MintZeroQuantity();
1140 
1141         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1142 
1143         // Overflows are incredibly unrealistic.
1144         // `balance` and `numberMinted` have a maximum limit of 2**64.
1145         // `tokenId` has a maximum limit of 2**256.
1146         unchecked {
1147             // Updates:
1148             // - `balance += quantity`.
1149             // - `numberMinted += quantity`.
1150             //
1151             // We can directly add to the `balance` and `numberMinted`.
1152             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1153 
1154             // Updates:
1155             // - `address` to the owner.
1156             // - `startTimestamp` to the timestamp of minting.
1157             // - `burned` to `false`.
1158             // - `nextInitialized` to `quantity == 1`.
1159             _packedOwnerships[startTokenId] = _packOwnershipData(
1160                 to,
1161                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1162             );
1163 
1164             uint256 toMasked;
1165             uint256 end = startTokenId + quantity;
1166 
1167             // Use assembly to loop and emit the `Transfer` event for gas savings.
1168             // The duplicated `log4` removes an extra check and reduces stack juggling.
1169             // The assembly, together with the surrounding Solidity code, have been
1170             // delicately arranged to nudge the compiler into producing optimized opcodes.
1171             assembly {
1172                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1173                 toMasked := and(to, _BITMASK_ADDRESS)
1174                 // Emit the `Transfer` event.
1175                 log4(
1176                     0, // Start of data (0, since no data).
1177                     0, // End of data (0, since no data).
1178                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1179                     0, // `address(0)`.
1180                     toMasked, // `to`.
1181                     startTokenId // `tokenId`.
1182                 )
1183 
1184                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1185                 // that overflows uint256 will make the loop run out of gas.
1186                 // The compiler will optimize the `iszero` away for performance.
1187                 for {
1188                     let tokenId := add(startTokenId, 1)
1189                 } iszero(eq(tokenId, end)) {
1190                     tokenId := add(tokenId, 1)
1191                 } {
1192                     // Emit the `Transfer` event. Similar to above.
1193                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1194                 }
1195             }
1196             if (toMasked == 0) revert MintToZeroAddress();
1197 
1198             _currentIndex = end;
1199         }
1200         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1201     }
1202 
1203     /**
1204      * @dev Mints `quantity` tokens and transfers them to `to`.
1205      *
1206      * This function is intended for efficient minting only during contract creation.
1207      *
1208      * It emits only one {ConsecutiveTransfer} as defined in
1209      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1210      * instead of a sequence of {Transfer} event(s).
1211      *
1212      * Calling this function outside of contract creation WILL make your contract
1213      * non-compliant with the ERC721 standard.
1214      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1215      * {ConsecutiveTransfer} event is only permissible during contract creation.
1216      *
1217      * Requirements:
1218      *
1219      * - `to` cannot be the zero address.
1220      * - `quantity` must be greater than 0.
1221      *
1222      * Emits a {ConsecutiveTransfer} event.
1223      */
1224     function _mintERC2309(address to, uint256 quantity) internal virtual {
1225         uint256 startTokenId = _currentIndex;
1226         if (to == address(0)) revert MintToZeroAddress();
1227         if (quantity == 0) revert MintZeroQuantity();
1228         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1229 
1230         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1231 
1232         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1233         unchecked {
1234             // Updates:
1235             // - `balance += quantity`.
1236             // - `numberMinted += quantity`.
1237             //
1238             // We can directly add to the `balance` and `numberMinted`.
1239             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1240 
1241             // Updates:
1242             // - `address` to the owner.
1243             // - `startTimestamp` to the timestamp of minting.
1244             // - `burned` to `false`.
1245             // - `nextInitialized` to `quantity == 1`.
1246             _packedOwnerships[startTokenId] = _packOwnershipData(
1247                 to,
1248                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1249             );
1250 
1251             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1252 
1253             _currentIndex = startTokenId + quantity;
1254         }
1255         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1256     }
1257 
1258     /**
1259      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1260      *
1261      * Requirements:
1262      *
1263      * - If `to` refers to a smart contract, it must implement
1264      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1265      * - `quantity` must be greater than 0.
1266      *
1267      * See {_mint}.
1268      *
1269      * Emits a {Transfer} event for each mint.
1270      */
1271     function _safeMint(
1272         address to,
1273         uint256 quantity,
1274         bytes memory _data
1275     ) internal virtual {
1276         _mint(to, quantity);
1277 
1278         unchecked {
1279             if (to.code.length != 0) {
1280                 uint256 end = _currentIndex;
1281                 uint256 index = end - quantity;
1282                 do {
1283                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1284                         revert TransferToNonERC721ReceiverImplementer();
1285                     }
1286                 } while (index < end);
1287                 // Reentrancy protection.
1288                 if (_currentIndex != end) revert();
1289             }
1290         }
1291     }
1292 
1293     /**
1294      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1295      */
1296     function _safeMint(address to, uint256 quantity) internal virtual {
1297         _safeMint(to, quantity, '');
1298     }
1299 
1300     // =============================================================
1301     //                        BURN OPERATIONS
1302     // =============================================================
1303 
1304     /**
1305      * @dev Equivalent to `_burn(tokenId, false)`.
1306      */
1307     function _burn(uint256 tokenId) internal virtual {
1308         _burn(tokenId, false);
1309     }
1310 
1311     /**
1312      * @dev Destroys `tokenId`.
1313      * The approval is cleared when the token is burned.
1314      *
1315      * Requirements:
1316      *
1317      * - `tokenId` must exist.
1318      *
1319      * Emits a {Transfer} event.
1320      */
1321     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1322         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1323 
1324         address from = address(uint160(prevOwnershipPacked));
1325 
1326         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1327 
1328         if (approvalCheck) {
1329             // The nested ifs save around 20+ gas over a compound boolean condition.
1330             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1331                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1332         }
1333 
1334         _beforeTokenTransfers(from, address(0), tokenId, 1);
1335 
1336         // Clear approvals from the previous owner.
1337         assembly {
1338             if approvedAddress {
1339                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1340                 sstore(approvedAddressSlot, 0)
1341             }
1342         }
1343 
1344         // Underflow of the sender's balance is impossible because we check for
1345         // ownership above and the recipient's balance can't realistically overflow.
1346         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1347         unchecked {
1348             // Updates:
1349             // - `balance -= 1`.
1350             // - `numberBurned += 1`.
1351             //
1352             // We can directly decrement the balance, and increment the number burned.
1353             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1354             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1355 
1356             // Updates:
1357             // - `address` to the last owner.
1358             // - `startTimestamp` to the timestamp of burning.
1359             // - `burned` to `true`.
1360             // - `nextInitialized` to `true`.
1361             _packedOwnerships[tokenId] = _packOwnershipData(
1362                 from,
1363                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1364             );
1365 
1366             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1367             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1368                 uint256 nextTokenId = tokenId + 1;
1369                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1370                 if (_packedOwnerships[nextTokenId] == 0) {
1371                     // If the next slot is within bounds.
1372                     if (nextTokenId != _currentIndex) {
1373                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1374                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1375                     }
1376                 }
1377             }
1378         }
1379 
1380         emit Transfer(from, address(0), tokenId);
1381         _afterTokenTransfers(from, address(0), tokenId, 1);
1382 
1383         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1384         unchecked {
1385             _burnCounter++;
1386         }
1387     }
1388 
1389     // =============================================================
1390     //                     EXTRA DATA OPERATIONS
1391     // =============================================================
1392 
1393     /**
1394      * @dev Directly sets the extra data for the ownership data `index`.
1395      */
1396     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1397         uint256 packed = _packedOwnerships[index];
1398         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1399         uint256 extraDataCasted;
1400         // Cast `extraData` with assembly to avoid redundant masking.
1401         assembly {
1402             extraDataCasted := extraData
1403         }
1404         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1405         _packedOwnerships[index] = packed;
1406     }
1407 
1408     /**
1409      * @dev Called during each token transfer to set the 24bit `extraData` field.
1410      * Intended to be overridden by the cosumer contract.
1411      *
1412      * `previousExtraData` - the value of `extraData` before transfer.
1413      *
1414      * Calling conditions:
1415      *
1416      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1417      * transferred to `to`.
1418      * - When `from` is zero, `tokenId` will be minted for `to`.
1419      * - When `to` is zero, `tokenId` will be burned by `from`.
1420      * - `from` and `to` are never both zero.
1421      */
1422     function _extraData(
1423         address from,
1424         address to,
1425         uint24 previousExtraData
1426     ) internal view virtual returns (uint24) {}
1427 
1428     /**
1429      * @dev Returns the next extra data for the packed ownership data.
1430      * The returned result is shifted into position.
1431      */
1432     function _nextExtraData(
1433         address from,
1434         address to,
1435         uint256 prevOwnershipPacked
1436     ) private view returns (uint256) {
1437         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1438         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1439     }
1440 
1441     // =============================================================
1442     //                       OTHER OPERATIONS
1443     // =============================================================
1444 
1445     /**
1446      * @dev Returns the message sender (defaults to `msg.sender`).
1447      *
1448      * If you are writing GSN compatible contracts, you need to override this function.
1449      */
1450     function _msgSenderERC721A() internal view virtual returns (address) {
1451         return msg.sender;
1452     }
1453 
1454     /**
1455      * @dev Converts a uint256 to its ASCII string decimal representation.
1456      */
1457     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1458         assembly {
1459             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1460             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1461             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1462             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1463             let m := add(mload(0x40), 0xa0)
1464             // Update the free memory pointer to allocate.
1465             mstore(0x40, m)
1466             // Assign the `str` to the end.
1467             str := sub(m, 0x20)
1468             // Zeroize the slot after the string.
1469             mstore(str, 0)
1470 
1471             // Cache the end of the memory to calculate the length later.
1472             let end := str
1473 
1474             // We write the string from rightmost digit to leftmost digit.
1475             // The following is essentially a do-while loop that also handles the zero case.
1476             // prettier-ignore
1477             for { let temp := value } 1 {} {
1478                 str := sub(str, 1)
1479                 // Write the character to the pointer.
1480                 // The ASCII index of the '0' character is 48.
1481                 mstore8(str, add(48, mod(temp, 10)))
1482                 // Keep dividing `temp` until zero.
1483                 temp := div(temp, 10)
1484                 // prettier-ignore
1485                 if iszero(temp) { break }
1486             }
1487 
1488             let length := sub(end, str)
1489             // Move the pointer 32 bytes leftwards to make room for the length.
1490             str := sub(str, 0x20)
1491             // Store the length.
1492             mstore(str, length)
1493         }
1494     }
1495 }
1496 
1497 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1498 
1499 
1500 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1501 
1502 pragma solidity ^0.8.0;
1503 
1504 /**
1505  * @dev Contract module that helps prevent reentrant calls to a function.
1506  *
1507  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1508  * available, which can be applied to functions to make sure there are no nested
1509  * (reentrant) calls to them.
1510  *
1511  * Note that because there is a single `nonReentrant` guard, functions marked as
1512  * `nonReentrant` may not call one another. This can be worked around by making
1513  * those functions `private`, and then adding `external` `nonReentrant` entry
1514  * points to them.
1515  *
1516  * TIP: If you would like to learn more about reentrancy and alternative ways
1517  * to protect against it, check out our blog post
1518  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1519  */
1520 abstract contract ReentrancyGuard {
1521     // Booleans are more expensive than uint256 or any type that takes up a full
1522     // word because each write operation emits an extra SLOAD to first read the
1523     // slot's contents, replace the bits taken up by the boolean, and then write
1524     // back. This is the compiler's defense against contract upgrades and
1525     // pointer aliasing, and it cannot be disabled.
1526 
1527     // The values being non-zero value makes deployment a bit more expensive,
1528     // but in exchange the refund on every call to nonReentrant will be lower in
1529     // amount. Since refunds are capped to a percentage of the total
1530     // transaction's gas, it is best to keep them low in cases like this one, to
1531     // increase the likelihood of the full refund coming into effect.
1532     uint256 private constant _NOT_ENTERED = 1;
1533     uint256 private constant _ENTERED = 2;
1534 
1535     uint256 private _status;
1536 
1537     constructor() {
1538         _status = _NOT_ENTERED;
1539     }
1540 
1541     /**
1542      * @dev Prevents a contract from calling itself, directly or indirectly.
1543      * Calling a `nonReentrant` function from another `nonReentrant`
1544      * function is not supported. It is possible to prevent this from happening
1545      * by making the `nonReentrant` function external, and making it call a
1546      * `private` function that does the actual work.
1547      */
1548     modifier nonReentrant() {
1549         _nonReentrantBefore();
1550         _;
1551         _nonReentrantAfter();
1552     }
1553 
1554     function _nonReentrantBefore() private {
1555         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1556         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1557 
1558         // Any calls to nonReentrant after this point will fail
1559         _status = _ENTERED;
1560     }
1561 
1562     function _nonReentrantAfter() private {
1563         // By storing the original value once again, a refund is triggered (see
1564         // https://eips.ethereum.org/EIPS/eip-2200)
1565         _status = _NOT_ENTERED;
1566     }
1567 }
1568 
1569 // File: @openzeppelin/contracts/utils/Context.sol
1570 
1571 
1572 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1573 
1574 pragma solidity ^0.8.0;
1575 
1576 /**
1577  * @dev Provides information about the current execution context, including the
1578  * sender of the transaction and its data. While these are generally available
1579  * via msg.sender and msg.data, they should not be accessed in such a direct
1580  * manner, since when dealing with meta-transactions the account sending and
1581  * paying for execution may not be the actual sender (as far as an application
1582  * is concerned).
1583  *
1584  * This contract is only required for intermediate, library-like contracts.
1585  */
1586 abstract contract Context {
1587     function _msgSender() internal view virtual returns (address) {
1588         return msg.sender;
1589     }
1590 
1591     function _msgData() internal view virtual returns (bytes calldata) {
1592         return msg.data;
1593     }
1594 }
1595 
1596 // File: @openzeppelin/contracts/access/Ownable.sol
1597 
1598 
1599 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1600 
1601 pragma solidity ^0.8.0;
1602 
1603 
1604 /**
1605  * @dev Contract module which provides a basic access control mechanism, where
1606  * there is an account (an owner) that can be granted exclusive access to
1607  * specific functions.
1608  *
1609  * By default, the owner account will be the one that deploys the contract. This
1610  * can later be changed with {transferOwnership}.
1611  *
1612  * This module is used through inheritance. It will make available the modifier
1613  * `onlyOwner`, which can be applied to your functions to restrict their use to
1614  * the owner.
1615  */
1616 abstract contract Ownable is Context {
1617     address private _owner;
1618 
1619     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1620 
1621     /**
1622      * @dev Initializes the contract setting the deployer as the initial owner.
1623      */
1624     constructor() {
1625         _transferOwnership(_msgSender());
1626     }
1627 
1628     /**
1629      * @dev Throws if called by any account other than the owner.
1630      */
1631     modifier onlyOwner() {
1632         _checkOwner();
1633         _;
1634     }
1635 
1636     /**
1637      * @dev Returns the address of the current owner.
1638      */
1639     function owner() public view virtual returns (address) {
1640         return _owner;
1641     }
1642 
1643     /**
1644      * @dev Throws if the sender is not the owner.
1645      */
1646     function _checkOwner() internal view virtual {
1647         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1648     }
1649 
1650     /**
1651      * @dev Leaves the contract without owner. It will not be possible to call
1652      * `onlyOwner` functions anymore. Can only be called by the current owner.
1653      *
1654      * NOTE: Renouncing ownership will leave the contract without an owner,
1655      * thereby removing any functionality that is only available to the owner.
1656      */
1657     function renounceOwnership() public virtual onlyOwner {
1658         _transferOwnership(address(0));
1659     }
1660 
1661     /**
1662      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1663      * Can only be called by the current owner.
1664      */
1665     function transferOwnership(address newOwner) public virtual onlyOwner {
1666         require(newOwner != address(0), "Ownable: new owner is the zero address");
1667         _transferOwnership(newOwner);
1668     }
1669 
1670     /**
1671      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1672      * Internal function without access restriction.
1673      */
1674     function _transferOwnership(address newOwner) internal virtual {
1675         address oldOwner = _owner;
1676         _owner = newOwner;
1677         emit OwnershipTransferred(oldOwner, newOwner);
1678     }
1679 }
1680 
1681 // File: contracts/The Noan.sol
1682 
1683 
1684 pragma solidity ^0.8.15;
1685 
1686 
1687 contract JPEGSByCosmic is ERC721A, DefaultOperatorFilterer, Ownable {
1688 
1689     string public baseURI = "ipfs://QmPNL8QnLhqCofUky8rt4529fxq3b8DYtD4HH3eNbb5dpA/";  
1690     string public baseExtension = ".json";
1691     uint256 public price = 0.015 ether;
1692     uint256 public maxSupply = 555;
1693     uint256 public maxPerTransaction = 10; 
1694 
1695     modifier callerIsUser() {
1696         require(tx.origin == msg.sender, "The caller is another contract");
1697         _;
1698     }
1699     constructor () ERC721A("555 JPEGS By Cosmic", "JPEGS") {
1700     }
1701 
1702     function _startTokenId() internal view virtual override returns (uint256) {
1703         return 1;
1704     }
1705 
1706     // Mint
1707     function publicMint(uint256 amount) public payable callerIsUser{
1708         require(amount <= maxPerTransaction, "Over Max Per Transaction!");
1709         require(totalSupply() + amount <= maxSupply, "Sold Out!");
1710         uint256 mintAmount = amount;
1711         
1712         if (totalSupply() % 2 != 0 ) {
1713             mintAmount--;
1714         }
1715 
1716         require(msg.value > 0 || mintAmount == 0, "Insufficient Value!");
1717         if (msg.value >= price * mintAmount) {
1718             _safeMint(msg.sender, amount);
1719         }
1720     }    
1721 
1722     /////////////////////////////
1723     // CONTRACT MANAGEMENT 
1724     /////////////////////////////
1725 
1726     function setPrice(uint256 newPrice) public onlyOwner {
1727         price = newPrice;
1728     }
1729 
1730     function _baseURI() internal view virtual override returns (string memory) {
1731         return baseURI;
1732     }
1733 
1734     function withdraw() public onlyOwner {
1735 		payable(msg.sender).transfer(address(this).balance);
1736         
1737 	}
1738     
1739     function setBaseURI(string memory baseURI_) external onlyOwner {
1740         baseURI = baseURI_;
1741     } 
1742 
1743     /////////////////////////////
1744     // OPENSEA FILTER REGISTRY 
1745     /////////////////////////////
1746 
1747     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1748         super.setApprovalForAll(operator, approved);
1749     }
1750 
1751     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1752         super.approve(operator, tokenId);
1753     }
1754 
1755     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1756         super.transferFrom(from, to, tokenId);
1757     }
1758 
1759     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1760         super.safeTransferFrom(from, to, tokenId);
1761     }
1762 
1763     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1764         public
1765         payable
1766         override
1767         onlyAllowedOperator(from)
1768     {
1769         super.safeTransferFrom(from, to, tokenId, data);
1770     }
1771 }