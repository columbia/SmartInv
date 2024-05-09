1 /**
2 ╔╦╗┬ ┬┌─┐  ╔╗╔┌─┐┌─┐┌┐┌
3  ║ ├─┤├┤   ║║║│ │├─┤│││
4  ╩ ┴ ┴└─┘  ╝╚╝└─┘┴ ┴┘└┘                                                                       
5  */
6 
7 // SPDX-License-Identifier: MIT
8 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/IOperatorFilterRegistry.sol
9 
10 
11 pragma solidity ^0.8.13;
12 
13 interface IOperatorFilterRegistry {
14     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
15     function register(address registrant) external;
16     function registerAndSubscribe(address registrant, address subscription) external;
17     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
18     function unregister(address addr) external;
19     function updateOperator(address registrant, address operator, bool filtered) external;
20     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
21     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
22     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
23     function subscribe(address registrant, address registrantToSubscribe) external;
24     function unsubscribe(address registrant, bool copyExistingEntries) external;
25     function subscriptionOf(address addr) external returns (address registrant);
26     function subscribers(address registrant) external returns (address[] memory);
27     function subscriberAt(address registrant, uint256 index) external returns (address);
28     function copyEntriesOf(address registrant, address registrantToCopy) external;
29     function isOperatorFiltered(address registrant, address operator) external returns (bool);
30     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
31     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
32     function filteredOperators(address addr) external returns (address[] memory);
33     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
34     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
35     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
36     function isRegistered(address addr) external returns (bool);
37     function codeHashOf(address addr) external returns (bytes32);
38 }
39 
40 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/OperatorFilterer.sol
41 
42 
43 pragma solidity ^0.8.13;
44 
45 
46 /**
47  * @title  OperatorFilterer
48  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
49  *         registrant's entries in the OperatorFilterRegistry.
50  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
51  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
52  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
53  */
54 abstract contract OperatorFilterer {
55     error OperatorNotAllowed(address operator);
56 
57     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
58         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
59 
60     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
61         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
62         // will not revert, but the contract will need to be registered with the registry once it is deployed in
63         // order for the modifier to filter addresses.
64         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
65             if (subscribe) {
66                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
67             } else {
68                 if (subscriptionOrRegistrantToCopy != address(0)) {
69                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
70                 } else {
71                     OPERATOR_FILTER_REGISTRY.register(address(this));
72                 }
73             }
74         }
75     }
76 
77     modifier onlyAllowedOperator(address from) virtual {
78         // Check registry code length to facilitate testing in environments without a deployed registry.
79         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
80             // Allow spending tokens from addresses with balance
81             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
82             // from an EOA.
83             if (from == msg.sender) {
84                 _;
85                 return;
86             }
87             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
88                 revert OperatorNotAllowed(msg.sender);
89             }
90         }
91         _;
92     }
93 
94     modifier onlyAllowedOperatorApproval(address operator) virtual {
95         // Check registry code length to facilitate testing in environments without a deployed registry.
96         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
97             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
98                 revert OperatorNotAllowed(operator);
99             }
100         }
101         _;
102     }
103 }
104 
105 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/DefaultOperatorFilterer.sol
106 
107 
108 pragma solidity ^0.8.13;
109 
110 
111 /**
112  * @title  DefaultOperatorFilterer
113  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
114  */
115 abstract contract DefaultOperatorFilterer is OperatorFilterer {
116     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
117 
118     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
119 }
120 
121 // File: erc721a/contracts/IERC721A.sol
122 
123 
124 // ERC721A Contracts v4.2.3
125 // Creator: Chiru Labs
126 
127 pragma solidity ^0.8.4;
128 
129 /**
130  * @dev Interface of ERC721A.
131  */
132 interface IERC721A {
133     /**
134      * The caller must own the token or be an approved operator.
135      */
136     error ApprovalCallerNotOwnerNorApproved();
137 
138     /**
139      * The token does not exist.
140      */
141     error ApprovalQueryForNonexistentToken();
142 
143     /**
144      * Cannot query the balance for the zero address.
145      */
146     error BalanceQueryForZeroAddress();
147 
148     /**
149      * Cannot mint to the zero address.
150      */
151     error MintToZeroAddress();
152 
153     /**
154      * The quantity of tokens minted must be more than zero.
155      */
156     error MintZeroQuantity();
157 
158     /**
159      * The token does not exist.
160      */
161     error OwnerQueryForNonexistentToken();
162 
163     /**
164      * The caller must own the token or be an approved operator.
165      */
166     error TransferCallerNotOwnerNorApproved();
167 
168     /**
169      * The token must be owned by `from`.
170      */
171     error TransferFromIncorrectOwner();
172 
173     /**
174      * Cannot safely transfer to a contract that does not implement the
175      * ERC721Receiver interface.
176      */
177     error TransferToNonERC721ReceiverImplementer();
178 
179     /**
180      * Cannot transfer to the zero address.
181      */
182     error TransferToZeroAddress();
183 
184     /**
185      * The token does not exist.
186      */
187     error URIQueryForNonexistentToken();
188 
189     /**
190      * The `quantity` minted with ERC2309 exceeds the safety limit.
191      */
192     error MintERC2309QuantityExceedsLimit();
193 
194     /**
195      * The `extraData` cannot be set on an unintialized ownership slot.
196      */
197     error OwnershipNotInitializedForExtraData();
198 
199     // =============================================================
200     //                            STRUCTS
201     // =============================================================
202 
203     struct TokenOwnership {
204         // The address of the owner.
205         address addr;
206         // Stores the start time of ownership with minimal overhead for tokenomics.
207         uint64 startTimestamp;
208         // Whether the token has been burned.
209         bool burned;
210         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
211         uint24 extraData;
212     }
213 
214     // =============================================================
215     //                         TOKEN COUNTERS
216     // =============================================================
217 
218     /**
219      * @dev Returns the total number of tokens in existence.
220      * Burned tokens will reduce the count.
221      * To get the total number of tokens minted, please see {_totalMinted}.
222      */
223     function totalSupply() external view returns (uint256);
224 
225     // =============================================================
226     //                            IERC165
227     // =============================================================
228 
229     /**
230      * @dev Returns true if this contract implements the interface defined by
231      * `interfaceId`. See the corresponding
232      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
233      * to learn more about how these ids are created.
234      *
235      * This function call must use less than 30000 gas.
236      */
237     function supportsInterface(bytes4 interfaceId) external view returns (bool);
238 
239     // =============================================================
240     //                            IERC721
241     // =============================================================
242 
243     /**
244      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
245      */
246     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
247 
248     /**
249      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
250      */
251     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
252 
253     /**
254      * @dev Emitted when `owner` enables or disables
255      * (`approved`) `operator` to manage all of its assets.
256      */
257     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
258 
259     /**
260      * @dev Returns the number of tokens in `owner`'s account.
261      */
262     function balanceOf(address owner) external view returns (uint256 balance);
263 
264     /**
265      * @dev Returns the owner of the `tokenId` token.
266      *
267      * Requirements:
268      *
269      * - `tokenId` must exist.
270      */
271     function ownerOf(uint256 tokenId) external view returns (address owner);
272 
273     /**
274      * @dev Safely transfers `tokenId` token from `from` to `to`,
275      * checking first that contract recipients are aware of the ERC721 protocol
276      * to prevent tokens from being forever locked.
277      *
278      * Requirements:
279      *
280      * - `from` cannot be the zero address.
281      * - `to` cannot be the zero address.
282      * - `tokenId` token must exist and be owned by `from`.
283      * - If the caller is not `from`, it must be have been allowed to move
284      * this token by either {approve} or {setApprovalForAll}.
285      * - If `to` refers to a smart contract, it must implement
286      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
287      *
288      * Emits a {Transfer} event.
289      */
290     function safeTransferFrom(
291         address from,
292         address to,
293         uint256 tokenId,
294         bytes calldata data
295     ) external payable;
296 
297     /**
298      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
299      */
300     function safeTransferFrom(
301         address from,
302         address to,
303         uint256 tokenId
304     ) external payable;
305 
306     /**
307      * @dev Transfers `tokenId` from `from` to `to`.
308      *
309      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
310      * whenever possible.
311      *
312      * Requirements:
313      *
314      * - `from` cannot be the zero address.
315      * - `to` cannot be the zero address.
316      * - `tokenId` token must be owned by `from`.
317      * - If the caller is not `from`, it must be approved to move this token
318      * by either {approve} or {setApprovalForAll}.
319      *
320      * Emits a {Transfer} event.
321      */
322     function transferFrom(
323         address from,
324         address to,
325         uint256 tokenId
326     ) external payable;
327 
328     /**
329      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
330      * The approval is cleared when the token is transferred.
331      *
332      * Only a single account can be approved at a time, so approving the
333      * zero address clears previous approvals.
334      *
335      * Requirements:
336      *
337      * - The caller must own the token or be an approved operator.
338      * - `tokenId` must exist.
339      *
340      * Emits an {Approval} event.
341      */
342     function approve(address to, uint256 tokenId) external payable;
343 
344     /**
345      * @dev Approve or remove `operator` as an operator for the caller.
346      * Operators can call {transferFrom} or {safeTransferFrom}
347      * for any token owned by the caller.
348      *
349      * Requirements:
350      *
351      * - The `operator` cannot be the caller.
352      *
353      * Emits an {ApprovalForAll} event.
354      */
355     function setApprovalForAll(address operator, bool _approved) external;
356 
357     /**
358      * @dev Returns the account approved for `tokenId` token.
359      *
360      * Requirements:
361      *
362      * - `tokenId` must exist.
363      */
364     function getApproved(uint256 tokenId) external view returns (address operator);
365 
366     /**
367      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
368      *
369      * See {setApprovalForAll}.
370      */
371     function isApprovedForAll(address owner, address operator) external view returns (bool);
372 
373     // =============================================================
374     //                        IERC721Metadata
375     // =============================================================
376 
377     /**
378      * @dev Returns the token collection name.
379      */
380     function name() external view returns (string memory);
381 
382     /**
383      * @dev Returns the token collection symbol.
384      */
385     function symbol() external view returns (string memory);
386 
387     /**
388      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
389      */
390     function tokenURI(uint256 tokenId) external view returns (string memory);
391 
392     // =============================================================
393     //                           IERC2309
394     // =============================================================
395 
396     /**
397      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
398      * (inclusive) is transferred from `from` to `to`, as defined in the
399      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
400      *
401      * See {_mintERC2309} for more details.
402      */
403     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
404 }
405 
406 // File: erc721a/contracts/ERC721A.sol
407 
408 
409 // ERC721A Contracts v4.2.3
410 // Creator: Chiru Labs
411 
412 pragma solidity ^0.8.4;
413 
414 
415 /**
416  * @dev Interface of ERC721 token receiver.
417  */
418 interface ERC721A__IERC721Receiver {
419     function onERC721Received(
420         address operator,
421         address from,
422         uint256 tokenId,
423         bytes calldata data
424     ) external returns (bytes4);
425 }
426 
427 /**
428  * @title ERC721A
429  *
430  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
431  * Non-Fungible Token Standard, including the Metadata extension.
432  * Optimized for lower gas during batch mints.
433  *
434  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
435  * starting from `_startTokenId()`.
436  *
437  * Assumptions:
438  *
439  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
440  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
441  */
442 contract ERC721A is IERC721A {
443     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
444     struct TokenApprovalRef {
445         address value;
446     }
447 
448     // =============================================================
449     //                           CONSTANTS
450     // =============================================================
451 
452     // Mask of an entry in packed address data.
453     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
454 
455     // The bit position of `numberMinted` in packed address data.
456     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
457 
458     // The bit position of `numberBurned` in packed address data.
459     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
460 
461     // The bit position of `aux` in packed address data.
462     uint256 private constant _BITPOS_AUX = 192;
463 
464     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
465     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
466 
467     // The bit position of `startTimestamp` in packed ownership.
468     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
469 
470     // The bit mask of the `burned` bit in packed ownership.
471     uint256 private constant _BITMASK_BURNED = 1 << 224;
472 
473     // The bit position of the `nextInitialized` bit in packed ownership.
474     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
475 
476     // The bit mask of the `nextInitialized` bit in packed ownership.
477     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
478 
479     // The bit position of `extraData` in packed ownership.
480     uint256 private constant _BITPOS_EXTRA_DATA = 232;
481 
482     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
483     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
484 
485     // The mask of the lower 160 bits for addresses.
486     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
487 
488     // The maximum `quantity` that can be minted with {_mintERC2309}.
489     // This limit is to prevent overflows on the address data entries.
490     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
491     // is required to cause an overflow, which is unrealistic.
492     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
493 
494     // The `Transfer` event signature is given by:
495     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
496     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
497         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
498 
499     // =============================================================
500     //                            STORAGE
501     // =============================================================
502 
503     // The next token ID to be minted.
504     uint256 private _currentIndex;
505 
506     // The number of tokens burned.
507     uint256 private _burnCounter;
508 
509     // Token name
510     string private _name;
511 
512     // Token symbol
513     string private _symbol;
514 
515     // Mapping from token ID to ownership details
516     // An empty struct value does not necessarily mean the token is unowned.
517     // See {_packedOwnershipOf} implementation for details.
518     //
519     // Bits Layout:
520     // - [0..159]   `addr`
521     // - [160..223] `startTimestamp`
522     // - [224]      `burned`
523     // - [225]      `nextInitialized`
524     // - [232..255] `extraData`
525     mapping(uint256 => uint256) private _packedOwnerships;
526 
527     // Mapping owner address to address data.
528     //
529     // Bits Layout:
530     // - [0..63]    `balance`
531     // - [64..127]  `numberMinted`
532     // - [128..191] `numberBurned`
533     // - [192..255] `aux`
534     mapping(address => uint256) private _packedAddressData;
535 
536     // Mapping from token ID to approved address.
537     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
538 
539     // Mapping from owner to operator approvals
540     mapping(address => mapping(address => bool)) private _operatorApprovals;
541 
542     // =============================================================
543     //                          CONSTRUCTOR
544     // =============================================================
545 
546     constructor(string memory name_, string memory symbol_) {
547         _name = name_;
548         _symbol = symbol_;
549         _currentIndex = _startTokenId();
550     }
551 
552     // =============================================================
553     //                   TOKEN COUNTING OPERATIONS
554     // =============================================================
555 
556     /**
557      * @dev Returns the starting token ID.
558      * To change the starting token ID, please override this function.
559      */
560     function _startTokenId() internal view virtual returns (uint256) {
561         return 0;
562     }
563 
564     /**
565      * @dev Returns the next token ID to be minted.
566      */
567     function _nextTokenId() internal view virtual returns (uint256) {
568         return _currentIndex;
569     }
570 
571     /**
572      * @dev Returns the total number of tokens in existence.
573      * Burned tokens will reduce the count.
574      * To get the total number of tokens minted, please see {_totalMinted}.
575      */
576     function totalSupply() public view virtual override returns (uint256) {
577         // Counter underflow is impossible as _burnCounter cannot be incremented
578         // more than `_currentIndex - _startTokenId()` times.
579         unchecked {
580             return _currentIndex - _burnCounter - _startTokenId();
581         }
582     }
583 
584     /**
585      * @dev Returns the total amount of tokens minted in the contract.
586      */
587     function _totalMinted() internal view virtual returns (uint256) {
588         // Counter underflow is impossible as `_currentIndex` does not decrement,
589         // and it is initialized to `_startTokenId()`.
590         unchecked {
591             return _currentIndex - _startTokenId();
592         }
593     }
594 
595     /**
596      * @dev Returns the total number of tokens burned.
597      */
598     function _totalBurned() internal view virtual returns (uint256) {
599         return _burnCounter;
600     }
601 
602     // =============================================================
603     //                    ADDRESS DATA OPERATIONS
604     // =============================================================
605 
606     /**
607      * @dev Returns the number of tokens in `owner`'s account.
608      */
609     function balanceOf(address owner) public view virtual override returns (uint256) {
610         if (owner == address(0)) revert BalanceQueryForZeroAddress();
611         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
612     }
613 
614     /**
615      * Returns the number of tokens minted by `owner`.
616      */
617     function _numberMinted(address owner) internal view returns (uint256) {
618         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
619     }
620 
621     /**
622      * Returns the number of tokens burned by or on behalf of `owner`.
623      */
624     function _numberBurned(address owner) internal view returns (uint256) {
625         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
626     }
627 
628     /**
629      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
630      */
631     function _getAux(address owner) internal view returns (uint64) {
632         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
633     }
634 
635     /**
636      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
637      * If there are multiple variables, please pack them into a uint64.
638      */
639     function _setAux(address owner, uint64 aux) internal virtual {
640         uint256 packed = _packedAddressData[owner];
641         uint256 auxCasted;
642         // Cast `aux` with assembly to avoid redundant masking.
643         assembly {
644             auxCasted := aux
645         }
646         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
647         _packedAddressData[owner] = packed;
648     }
649 
650     // =============================================================
651     //                            IERC165
652     // =============================================================
653 
654     /**
655      * @dev Returns true if this contract implements the interface defined by
656      * `interfaceId`. See the corresponding
657      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
658      * to learn more about how these ids are created.
659      *
660      * This function call must use less than 30000 gas.
661      */
662     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
663         // The interface IDs are constants representing the first 4 bytes
664         // of the XOR of all function selectors in the interface.
665         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
666         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
667         return
668             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
669             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
670             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
671     }
672 
673     // =============================================================
674     //                        IERC721Metadata
675     // =============================================================
676 
677     /**
678      * @dev Returns the token collection name.
679      */
680     function name() public view virtual override returns (string memory) {
681         return _name;
682     }
683 
684     /**
685      * @dev Returns the token collection symbol.
686      */
687     function symbol() public view virtual override returns (string memory) {
688         return _symbol;
689     }
690 
691     /**
692      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
693      */
694     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
695         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
696 
697         string memory baseURI = _baseURI();
698         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
699     }
700 
701     /**
702      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
703      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
704      * by default, it can be overridden in child contracts.
705      */
706     function _baseURI() internal view virtual returns (string memory) {
707         return '';
708     }
709 
710     // =============================================================
711     //                     OWNERSHIPS OPERATIONS
712     // =============================================================
713 
714     /**
715      * @dev Returns the owner of the `tokenId` token.
716      *
717      * Requirements:
718      *
719      * - `tokenId` must exist.
720      */
721     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
722         return address(uint160(_packedOwnershipOf(tokenId)));
723     }
724 
725     /**
726      * @dev Gas spent here starts off proportional to the maximum mint batch size.
727      * It gradually moves to O(1) as tokens get transferred around over time.
728      */
729     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
730         return _unpackedOwnership(_packedOwnershipOf(tokenId));
731     }
732 
733     /**
734      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
735      */
736     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
737         return _unpackedOwnership(_packedOwnerships[index]);
738     }
739 
740     /**
741      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
742      */
743     function _initializeOwnershipAt(uint256 index) internal virtual {
744         if (_packedOwnerships[index] == 0) {
745             _packedOwnerships[index] = _packedOwnershipOf(index);
746         }
747     }
748 
749     /**
750      * Returns the packed ownership data of `tokenId`.
751      */
752     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
753         uint256 curr = tokenId;
754 
755         unchecked {
756             if (_startTokenId() <= curr)
757                 if (curr < _currentIndex) {
758                     uint256 packed = _packedOwnerships[curr];
759                     // If not burned.
760                     if (packed & _BITMASK_BURNED == 0) {
761                         // Invariant:
762                         // There will always be an initialized ownership slot
763                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
764                         // before an unintialized ownership slot
765                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
766                         // Hence, `curr` will not underflow.
767                         //
768                         // We can directly compare the packed value.
769                         // If the address is zero, packed will be zero.
770                         while (packed == 0) {
771                             packed = _packedOwnerships[--curr];
772                         }
773                         return packed;
774                     }
775                 }
776         }
777         revert OwnerQueryForNonexistentToken();
778     }
779 
780     /**
781      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
782      */
783     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
784         ownership.addr = address(uint160(packed));
785         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
786         ownership.burned = packed & _BITMASK_BURNED != 0;
787         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
788     }
789 
790     /**
791      * @dev Packs ownership data into a single uint256.
792      */
793     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
794         assembly {
795             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
796             owner := and(owner, _BITMASK_ADDRESS)
797             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
798             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
799         }
800     }
801 
802     /**
803      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
804      */
805     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
806         // For branchless setting of the `nextInitialized` flag.
807         assembly {
808             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
809             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
810         }
811     }
812 
813     // =============================================================
814     //                      APPROVAL OPERATIONS
815     // =============================================================
816 
817     /**
818      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
819      * The approval is cleared when the token is transferred.
820      *
821      * Only a single account can be approved at a time, so approving the
822      * zero address clears previous approvals.
823      *
824      * Requirements:
825      *
826      * - The caller must own the token or be an approved operator.
827      * - `tokenId` must exist.
828      *
829      * Emits an {Approval} event.
830      */
831     function approve(address to, uint256 tokenId) public payable virtual override {
832         address owner = ownerOf(tokenId);
833 
834         if (_msgSenderERC721A() != owner)
835             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
836                 revert ApprovalCallerNotOwnerNorApproved();
837             }
838 
839         _tokenApprovals[tokenId].value = to;
840         emit Approval(owner, to, tokenId);
841     }
842 
843     /**
844      * @dev Returns the account approved for `tokenId` token.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      */
850     function getApproved(uint256 tokenId) public view virtual override returns (address) {
851         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
852 
853         return _tokenApprovals[tokenId].value;
854     }
855 
856     /**
857      * @dev Approve or remove `operator` as an operator for the caller.
858      * Operators can call {transferFrom} or {safeTransferFrom}
859      * for any token owned by the caller.
860      *
861      * Requirements:
862      *
863      * - The `operator` cannot be the caller.
864      *
865      * Emits an {ApprovalForAll} event.
866      */
867     function setApprovalForAll(address operator, bool approved) public virtual override {
868         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
869         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
870     }
871 
872     /**
873      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
874      *
875      * See {setApprovalForAll}.
876      */
877     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
878         return _operatorApprovals[owner][operator];
879     }
880 
881     /**
882      * @dev Returns whether `tokenId` exists.
883      *
884      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
885      *
886      * Tokens start existing when they are minted. See {_mint}.
887      */
888     function _exists(uint256 tokenId) internal view virtual returns (bool) {
889         return
890             _startTokenId() <= tokenId &&
891             tokenId < _currentIndex && // If within bounds,
892             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
893     }
894 
895     /**
896      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
897      */
898     function _isSenderApprovedOrOwner(
899         address approvedAddress,
900         address owner,
901         address msgSender
902     ) private pure returns (bool result) {
903         assembly {
904             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
905             owner := and(owner, _BITMASK_ADDRESS)
906             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
907             msgSender := and(msgSender, _BITMASK_ADDRESS)
908             // `msgSender == owner || msgSender == approvedAddress`.
909             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
910         }
911     }
912 
913     /**
914      * @dev Returns the storage slot and value for the approved address of `tokenId`.
915      */
916     function _getApprovedSlotAndAddress(uint256 tokenId)
917         private
918         view
919         returns (uint256 approvedAddressSlot, address approvedAddress)
920     {
921         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
922         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
923         assembly {
924             approvedAddressSlot := tokenApproval.slot
925             approvedAddress := sload(approvedAddressSlot)
926         }
927     }
928 
929     // =============================================================
930     //                      TRANSFER OPERATIONS
931     // =============================================================
932 
933     /**
934      * @dev Transfers `tokenId` from `from` to `to`.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must be owned by `from`.
941      * - If the caller is not `from`, it must be approved to move this token
942      * by either {approve} or {setApprovalForAll}.
943      *
944      * Emits a {Transfer} event.
945      */
946     function transferFrom(
947         address from,
948         address to,
949         uint256 tokenId
950     ) public payable virtual override {
951         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
952 
953         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
954 
955         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
956 
957         // The nested ifs save around 20+ gas over a compound boolean condition.
958         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
959             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
960 
961         if (to == address(0)) revert TransferToZeroAddress();
962 
963         _beforeTokenTransfers(from, to, tokenId, 1);
964 
965         // Clear approvals from the previous owner.
966         assembly {
967             if approvedAddress {
968                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
969                 sstore(approvedAddressSlot, 0)
970             }
971         }
972 
973         // Underflow of the sender's balance is impossible because we check for
974         // ownership above and the recipient's balance can't realistically overflow.
975         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
976         unchecked {
977             // We can directly increment and decrement the balances.
978             --_packedAddressData[from]; // Updates: `balance -= 1`.
979             ++_packedAddressData[to]; // Updates: `balance += 1`.
980 
981             // Updates:
982             // - `address` to the next owner.
983             // - `startTimestamp` to the timestamp of transfering.
984             // - `burned` to `false`.
985             // - `nextInitialized` to `true`.
986             _packedOwnerships[tokenId] = _packOwnershipData(
987                 to,
988                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
989             );
990 
991             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
992             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
993                 uint256 nextTokenId = tokenId + 1;
994                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
995                 if (_packedOwnerships[nextTokenId] == 0) {
996                     // If the next slot is within bounds.
997                     if (nextTokenId != _currentIndex) {
998                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
999                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1000                     }
1001                 }
1002             }
1003         }
1004 
1005         emit Transfer(from, to, tokenId);
1006         _afterTokenTransfers(from, to, tokenId, 1);
1007     }
1008 
1009     /**
1010      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public payable virtual override {
1017         safeTransferFrom(from, to, tokenId, '');
1018     }
1019 
1020     /**
1021      * @dev Safely transfers `tokenId` token from `from` to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must exist and be owned by `from`.
1028      * - If the caller is not `from`, it must be approved to move this token
1029      * by either {approve} or {setApprovalForAll}.
1030      * - If `to` refers to a smart contract, it must implement
1031      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) public payable virtual override {
1041         transferFrom(from, to, tokenId);
1042         if (to.code.length != 0)
1043             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1044                 revert TransferToNonERC721ReceiverImplementer();
1045             }
1046     }
1047 
1048     /**
1049      * @dev Hook that is called before a set of serially-ordered token IDs
1050      * are about to be transferred. This includes minting.
1051      * And also called before burning one token.
1052      *
1053      * `startTokenId` - the first token ID to be transferred.
1054      * `quantity` - the amount to be transferred.
1055      *
1056      * Calling conditions:
1057      *
1058      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1059      * transferred to `to`.
1060      * - When `from` is zero, `tokenId` will be minted for `to`.
1061      * - When `to` is zero, `tokenId` will be burned by `from`.
1062      * - `from` and `to` are never both zero.
1063      */
1064     function _beforeTokenTransfers(
1065         address from,
1066         address to,
1067         uint256 startTokenId,
1068         uint256 quantity
1069     ) internal virtual {}
1070 
1071     /**
1072      * @dev Hook that is called after a set of serially-ordered token IDs
1073      * have been transferred. This includes minting.
1074      * And also called after one token has been burned.
1075      *
1076      * `startTokenId` - the first token ID to be transferred.
1077      * `quantity` - the amount to be transferred.
1078      *
1079      * Calling conditions:
1080      *
1081      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1082      * transferred to `to`.
1083      * - When `from` is zero, `tokenId` has been minted for `to`.
1084      * - When `to` is zero, `tokenId` has been burned by `from`.
1085      * - `from` and `to` are never both zero.
1086      */
1087     function _afterTokenTransfers(
1088         address from,
1089         address to,
1090         uint256 startTokenId,
1091         uint256 quantity
1092     ) internal virtual {}
1093 
1094     /**
1095      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1096      *
1097      * `from` - Previous owner of the given token ID.
1098      * `to` - Target address that will receive the token.
1099      * `tokenId` - Token ID to be transferred.
1100      * `_data` - Optional data to send along with the call.
1101      *
1102      * Returns whether the call correctly returned the expected magic value.
1103      */
1104     function _checkContractOnERC721Received(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) private returns (bool) {
1110         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1111             bytes4 retval
1112         ) {
1113             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1114         } catch (bytes memory reason) {
1115             if (reason.length == 0) {
1116                 revert TransferToNonERC721ReceiverImplementer();
1117             } else {
1118                 assembly {
1119                     revert(add(32, reason), mload(reason))
1120                 }
1121             }
1122         }
1123     }
1124 
1125     // =============================================================
1126     //                        MINT OPERATIONS
1127     // =============================================================
1128 
1129     /**
1130      * @dev Mints `quantity` tokens and transfers them to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `to` cannot be the zero address.
1135      * - `quantity` must be greater than 0.
1136      *
1137      * Emits a {Transfer} event for each mint.
1138      */
1139     function _mint(address to, uint256 quantity) internal virtual {
1140         uint256 startTokenId = _currentIndex;
1141         if (quantity == 0) revert MintZeroQuantity();
1142 
1143         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1144 
1145         // Overflows are incredibly unrealistic.
1146         // `balance` and `numberMinted` have a maximum limit of 2**64.
1147         // `tokenId` has a maximum limit of 2**256.
1148         unchecked {
1149             // Updates:
1150             // - `balance += quantity`.
1151             // - `numberMinted += quantity`.
1152             //
1153             // We can directly add to the `balance` and `numberMinted`.
1154             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1155 
1156             // Updates:
1157             // - `address` to the owner.
1158             // - `startTimestamp` to the timestamp of minting.
1159             // - `burned` to `false`.
1160             // - `nextInitialized` to `quantity == 1`.
1161             _packedOwnerships[startTokenId] = _packOwnershipData(
1162                 to,
1163                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1164             );
1165 
1166             uint256 toMasked;
1167             uint256 end = startTokenId + quantity;
1168 
1169             // Use assembly to loop and emit the `Transfer` event for gas savings.
1170             // The duplicated `log4` removes an extra check and reduces stack juggling.
1171             // The assembly, together with the surrounding Solidity code, have been
1172             // delicately arranged to nudge the compiler into producing optimized opcodes.
1173             assembly {
1174                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1175                 toMasked := and(to, _BITMASK_ADDRESS)
1176                 // Emit the `Transfer` event.
1177                 log4(
1178                     0, // Start of data (0, since no data).
1179                     0, // End of data (0, since no data).
1180                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1181                     0, // `address(0)`.
1182                     toMasked, // `to`.
1183                     startTokenId // `tokenId`.
1184                 )
1185 
1186                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1187                 // that overflows uint256 will make the loop run out of gas.
1188                 // The compiler will optimize the `iszero` away for performance.
1189                 for {
1190                     let tokenId := add(startTokenId, 1)
1191                 } iszero(eq(tokenId, end)) {
1192                     tokenId := add(tokenId, 1)
1193                 } {
1194                     // Emit the `Transfer` event. Similar to above.
1195                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1196                 }
1197             }
1198             if (toMasked == 0) revert MintToZeroAddress();
1199 
1200             _currentIndex = end;
1201         }
1202         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1203     }
1204 
1205     /**
1206      * @dev Mints `quantity` tokens and transfers them to `to`.
1207      *
1208      * This function is intended for efficient minting only during contract creation.
1209      *
1210      * It emits only one {ConsecutiveTransfer} as defined in
1211      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1212      * instead of a sequence of {Transfer} event(s).
1213      *
1214      * Calling this function outside of contract creation WILL make your contract
1215      * non-compliant with the ERC721 standard.
1216      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1217      * {ConsecutiveTransfer} event is only permissible during contract creation.
1218      *
1219      * Requirements:
1220      *
1221      * - `to` cannot be the zero address.
1222      * - `quantity` must be greater than 0.
1223      *
1224      * Emits a {ConsecutiveTransfer} event.
1225      */
1226     function _mintERC2309(address to, uint256 quantity) internal virtual {
1227         uint256 startTokenId = _currentIndex;
1228         if (to == address(0)) revert MintToZeroAddress();
1229         if (quantity == 0) revert MintZeroQuantity();
1230         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1231 
1232         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1233 
1234         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1235         unchecked {
1236             // Updates:
1237             // - `balance += quantity`.
1238             // - `numberMinted += quantity`.
1239             //
1240             // We can directly add to the `balance` and `numberMinted`.
1241             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1242 
1243             // Updates:
1244             // - `address` to the owner.
1245             // - `startTimestamp` to the timestamp of minting.
1246             // - `burned` to `false`.
1247             // - `nextInitialized` to `quantity == 1`.
1248             _packedOwnerships[startTokenId] = _packOwnershipData(
1249                 to,
1250                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1251             );
1252 
1253             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1254 
1255             _currentIndex = startTokenId + quantity;
1256         }
1257         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1258     }
1259 
1260     /**
1261      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1262      *
1263      * Requirements:
1264      *
1265      * - If `to` refers to a smart contract, it must implement
1266      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1267      * - `quantity` must be greater than 0.
1268      *
1269      * See {_mint}.
1270      *
1271      * Emits a {Transfer} event for each mint.
1272      */
1273     function _safeMint(
1274         address to,
1275         uint256 quantity,
1276         bytes memory _data
1277     ) internal virtual {
1278         _mint(to, quantity);
1279 
1280         unchecked {
1281             if (to.code.length != 0) {
1282                 uint256 end = _currentIndex;
1283                 uint256 index = end - quantity;
1284                 do {
1285                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1286                         revert TransferToNonERC721ReceiverImplementer();
1287                     }
1288                 } while (index < end);
1289                 // Reentrancy protection.
1290                 if (_currentIndex != end) revert();
1291             }
1292         }
1293     }
1294 
1295     /**
1296      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1297      */
1298     function _safeMint(address to, uint256 quantity) internal virtual {
1299         _safeMint(to, quantity, '');
1300     }
1301 
1302     // =============================================================
1303     //                        BURN OPERATIONS
1304     // =============================================================
1305 
1306     /**
1307      * @dev Equivalent to `_burn(tokenId, false)`.
1308      */
1309     function _burn(uint256 tokenId) internal virtual {
1310         _burn(tokenId, false);
1311     }
1312 
1313     /**
1314      * @dev Destroys `tokenId`.
1315      * The approval is cleared when the token is burned.
1316      *
1317      * Requirements:
1318      *
1319      * - `tokenId` must exist.
1320      *
1321      * Emits a {Transfer} event.
1322      */
1323     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1324         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1325 
1326         address from = address(uint160(prevOwnershipPacked));
1327 
1328         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1329 
1330         if (approvalCheck) {
1331             // The nested ifs save around 20+ gas over a compound boolean condition.
1332             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1333                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1334         }
1335 
1336         _beforeTokenTransfers(from, address(0), tokenId, 1);
1337 
1338         // Clear approvals from the previous owner.
1339         assembly {
1340             if approvedAddress {
1341                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1342                 sstore(approvedAddressSlot, 0)
1343             }
1344         }
1345 
1346         // Underflow of the sender's balance is impossible because we check for
1347         // ownership above and the recipient's balance can't realistically overflow.
1348         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1349         unchecked {
1350             // Updates:
1351             // - `balance -= 1`.
1352             // - `numberBurned += 1`.
1353             //
1354             // We can directly decrement the balance, and increment the number burned.
1355             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1356             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1357 
1358             // Updates:
1359             // - `address` to the last owner.
1360             // - `startTimestamp` to the timestamp of burning.
1361             // - `burned` to `true`.
1362             // - `nextInitialized` to `true`.
1363             _packedOwnerships[tokenId] = _packOwnershipData(
1364                 from,
1365                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1366             );
1367 
1368             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1369             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1370                 uint256 nextTokenId = tokenId + 1;
1371                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1372                 if (_packedOwnerships[nextTokenId] == 0) {
1373                     // If the next slot is within bounds.
1374                     if (nextTokenId != _currentIndex) {
1375                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1376                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1377                     }
1378                 }
1379             }
1380         }
1381 
1382         emit Transfer(from, address(0), tokenId);
1383         _afterTokenTransfers(from, address(0), tokenId, 1);
1384 
1385         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1386         unchecked {
1387             _burnCounter++;
1388         }
1389     }
1390 
1391     // =============================================================
1392     //                     EXTRA DATA OPERATIONS
1393     // =============================================================
1394 
1395     /**
1396      * @dev Directly sets the extra data for the ownership data `index`.
1397      */
1398     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1399         uint256 packed = _packedOwnerships[index];
1400         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1401         uint256 extraDataCasted;
1402         // Cast `extraData` with assembly to avoid redundant masking.
1403         assembly {
1404             extraDataCasted := extraData
1405         }
1406         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1407         _packedOwnerships[index] = packed;
1408     }
1409 
1410     /**
1411      * @dev Called during each token transfer to set the 24bit `extraData` field.
1412      * Intended to be overridden by the cosumer contract.
1413      *
1414      * `previousExtraData` - the value of `extraData` before transfer.
1415      *
1416      * Calling conditions:
1417      *
1418      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1419      * transferred to `to`.
1420      * - When `from` is zero, `tokenId` will be minted for `to`.
1421      * - When `to` is zero, `tokenId` will be burned by `from`.
1422      * - `from` and `to` are never both zero.
1423      */
1424     function _extraData(
1425         address from,
1426         address to,
1427         uint24 previousExtraData
1428     ) internal view virtual returns (uint24) {}
1429 
1430     /**
1431      * @dev Returns the next extra data for the packed ownership data.
1432      * The returned result is shifted into position.
1433      */
1434     function _nextExtraData(
1435         address from,
1436         address to,
1437         uint256 prevOwnershipPacked
1438     ) private view returns (uint256) {
1439         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1440         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1441     }
1442 
1443     // =============================================================
1444     //                       OTHER OPERATIONS
1445     // =============================================================
1446 
1447     /**
1448      * @dev Returns the message sender (defaults to `msg.sender`).
1449      *
1450      * If you are writing GSN compatible contracts, you need to override this function.
1451      */
1452     function _msgSenderERC721A() internal view virtual returns (address) {
1453         return msg.sender;
1454     }
1455 
1456     /**
1457      * @dev Converts a uint256 to its ASCII string decimal representation.
1458      */
1459     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1460         assembly {
1461             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1462             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1463             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1464             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1465             let m := add(mload(0x40), 0xa0)
1466             // Update the free memory pointer to allocate.
1467             mstore(0x40, m)
1468             // Assign the `str` to the end.
1469             str := sub(m, 0x20)
1470             // Zeroize the slot after the string.
1471             mstore(str, 0)
1472 
1473             // Cache the end of the memory to calculate the length later.
1474             let end := str
1475 
1476             // We write the string from rightmost digit to leftmost digit.
1477             // The following is essentially a do-while loop that also handles the zero case.
1478             // prettier-ignore
1479             for { let temp := value } 1 {} {
1480                 str := sub(str, 1)
1481                 // Write the character to the pointer.
1482                 // The ASCII index of the '0' character is 48.
1483                 mstore8(str, add(48, mod(temp, 10)))
1484                 // Keep dividing `temp` until zero.
1485                 temp := div(temp, 10)
1486                 // prettier-ignore
1487                 if iszero(temp) { break }
1488             }
1489 
1490             let length := sub(end, str)
1491             // Move the pointer 32 bytes leftwards to make room for the length.
1492             str := sub(str, 0x20)
1493             // Store the length.
1494             mstore(str, length)
1495         }
1496     }
1497 }
1498 
1499 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1500 
1501 
1502 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1503 
1504 pragma solidity ^0.8.0;
1505 
1506 /**
1507  * @dev Contract module that helps prevent reentrant calls to a function.
1508  *
1509  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1510  * available, which can be applied to functions to make sure there are no nested
1511  * (reentrant) calls to them.
1512  *
1513  * Note that because there is a single `nonReentrant` guard, functions marked as
1514  * `nonReentrant` may not call one another. This can be worked around by making
1515  * those functions `private`, and then adding `external` `nonReentrant` entry
1516  * points to them.
1517  *
1518  * TIP: If you would like to learn more about reentrancy and alternative ways
1519  * to protect against it, check out our blog post
1520  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1521  */
1522 abstract contract ReentrancyGuard {
1523     // Booleans are more expensive than uint256 or any type that takes up a full
1524     // word because each write operation emits an extra SLOAD to first read the
1525     // slot's contents, replace the bits taken up by the boolean, and then write
1526     // back. This is the compiler's defense against contract upgrades and
1527     // pointer aliasing, and it cannot be disabled.
1528 
1529     // The values being non-zero value makes deployment a bit more expensive,
1530     // but in exchange the refund on every call to nonReentrant will be lower in
1531     // amount. Since refunds are capped to a percentage of the total
1532     // transaction's gas, it is best to keep them low in cases like this one, to
1533     // increase the likelihood of the full refund coming into effect.
1534     uint256 private constant _NOT_ENTERED = 1;
1535     uint256 private constant _ENTERED = 2;
1536 
1537     uint256 private _status;
1538 
1539     constructor() {
1540         _status = _NOT_ENTERED;
1541     }
1542 
1543     /**
1544      * @dev Prevents a contract from calling itself, directly or indirectly.
1545      * Calling a `nonReentrant` function from another `nonReentrant`
1546      * function is not supported. It is possible to prevent this from happening
1547      * by making the `nonReentrant` function external, and making it call a
1548      * `private` function that does the actual work.
1549      */
1550     modifier nonReentrant() {
1551         _nonReentrantBefore();
1552         _;
1553         _nonReentrantAfter();
1554     }
1555 
1556     function _nonReentrantBefore() private {
1557         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1558         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1559 
1560         // Any calls to nonReentrant after this point will fail
1561         _status = _ENTERED;
1562     }
1563 
1564     function _nonReentrantAfter() private {
1565         // By storing the original value once again, a refund is triggered (see
1566         // https://eips.ethereum.org/EIPS/eip-2200)
1567         _status = _NOT_ENTERED;
1568     }
1569 }
1570 
1571 // File: @openzeppelin/contracts/utils/Context.sol
1572 
1573 
1574 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1575 
1576 pragma solidity ^0.8.0;
1577 
1578 /**
1579  * @dev Provides information about the current execution context, including the
1580  * sender of the transaction and its data. While these are generally available
1581  * via msg.sender and msg.data, they should not be accessed in such a direct
1582  * manner, since when dealing with meta-transactions the account sending and
1583  * paying for execution may not be the actual sender (as far as an application
1584  * is concerned).
1585  *
1586  * This contract is only required for intermediate, library-like contracts.
1587  */
1588 abstract contract Context {
1589     function _msgSender() internal view virtual returns (address) {
1590         return msg.sender;
1591     }
1592 
1593     function _msgData() internal view virtual returns (bytes calldata) {
1594         return msg.data;
1595     }
1596 }
1597 
1598 // File: @openzeppelin/contracts/access/Ownable.sol
1599 
1600 
1601 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1602 
1603 pragma solidity ^0.8.0;
1604 
1605 
1606 /**
1607  * @dev Contract module which provides a basic access control mechanism, where
1608  * there is an account (an owner) that can be granted exclusive access to
1609  * specific functions.
1610  *
1611  * By default, the owner account will be the one that deploys the contract. This
1612  * can later be changed with {transferOwnership}.
1613  *
1614  * This module is used through inheritance. It will make available the modifier
1615  * `onlyOwner`, which can be applied to your functions to restrict their use to
1616  * the owner.
1617  */
1618 abstract contract Ownable is Context {
1619     address private _owner;
1620 
1621     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1622 
1623     /**
1624      * @dev Initializes the contract setting the deployer as the initial owner.
1625      */
1626     constructor() {
1627         _transferOwnership(_msgSender());
1628     }
1629 
1630     /**
1631      * @dev Throws if called by any account other than the owner.
1632      */
1633     modifier onlyOwner() {
1634         _checkOwner();
1635         _;
1636     }
1637 
1638     /**
1639      * @dev Returns the address of the current owner.
1640      */
1641     function owner() public view virtual returns (address) {
1642         return _owner;
1643     }
1644 
1645     /**
1646      * @dev Throws if the sender is not the owner.
1647      */
1648     function _checkOwner() internal view virtual {
1649         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1650     }
1651 
1652     /**
1653      * @dev Leaves the contract without owner. It will not be possible to call
1654      * `onlyOwner` functions anymore. Can only be called by the current owner.
1655      *
1656      * NOTE: Renouncing ownership will leave the contract without an owner,
1657      * thereby removing any functionality that is only available to the owner.
1658      */
1659     function renounceOwnership() public virtual onlyOwner {
1660         _transferOwnership(address(0));
1661     }
1662 
1663     /**
1664      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1665      * Can only be called by the current owner.
1666      */
1667     function transferOwnership(address newOwner) public virtual onlyOwner {
1668         require(newOwner != address(0), "Ownable: new owner is the zero address");
1669         _transferOwnership(newOwner);
1670     }
1671 
1672     /**
1673      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1674      * Internal function without access restriction.
1675      */
1676     function _transferOwnership(address newOwner) internal virtual {
1677         address oldOwner = _owner;
1678         _owner = newOwner;
1679         emit OwnershipTransferred(oldOwner, newOwner);
1680     }
1681 }
1682 
1683 // File: contracts/The Noan.sol
1684 
1685 
1686 pragma solidity ^0.8.15;
1687 
1688 
1689 contract DreamAbstractionbyNoan is ERC721A, DefaultOperatorFilterer, Ownable {
1690 
1691     string public baseURI = "ipfs://bafybeihmyqk4wzpxmzbbzutbbychytnjpj4dzk26xoah4eq67eiwto4abi/";  
1692     string public baseExtension = ".json";
1693     uint256 public price = 0.005 ether;
1694     uint256 public maxSupply = 365;
1695     uint256 public maxPerTransaction = 5; 
1696 
1697     modifier callerIsUser() {
1698         require(tx.origin == msg.sender, "The caller is another contract");
1699         _;
1700     }
1701     constructor () ERC721A("Dream Abstraction by Noan", "DABN") {
1702     }
1703 
1704     function _startTokenId() internal view virtual override returns (uint256) {
1705         return 1;
1706     }
1707 
1708     // Mint
1709     function publicMint(uint256 amount) public payable callerIsUser{
1710         require(amount <= maxPerTransaction, "Over Max Per Transaction!");
1711         require(totalSupply() + amount <= maxSupply, "Sold Out!");
1712         uint256 mintAmount = amount;
1713         
1714         if (totalSupply() % 2 != 0 ) {
1715             mintAmount--;
1716         }
1717 
1718         require(msg.value > 0 || mintAmount == 0, "Insufficient Value!");
1719         if (msg.value >= price * mintAmount) {
1720             _safeMint(msg.sender, amount);
1721         }
1722     }    
1723 
1724     /////////////////////////////
1725     // CONTRACT MANAGEMENT 
1726     /////////////////////////////
1727 
1728     function setPrice(uint256 newPrice) public onlyOwner {
1729         price = newPrice;
1730     }
1731 
1732     function _baseURI() internal view virtual override returns (string memory) {
1733         return baseURI;
1734     }
1735 
1736     function withdraw() public onlyOwner {
1737 		payable(msg.sender).transfer(address(this).balance);
1738         
1739 	}
1740     
1741     function setBaseURI(string memory baseURI_) external onlyOwner {
1742         baseURI = baseURI_;
1743     } 
1744 
1745     /////////////////////////////
1746     // OPENSEA FILTER REGISTRY 
1747     /////////////////////////////
1748 
1749     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1750         super.setApprovalForAll(operator, approved);
1751     }
1752 
1753     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1754         super.approve(operator, tokenId);
1755     }
1756 
1757     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1758         super.transferFrom(from, to, tokenId);
1759     }
1760 
1761     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1762         super.safeTransferFrom(from, to, tokenId);
1763     }
1764 
1765     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1766         public
1767         payable
1768         override
1769         onlyAllowedOperator(from)
1770     {
1771         super.safeTransferFrom(from, to, tokenId, data);
1772     }
1773 }