1 /**
2  ________ ___  ________  ________  ___  ___  _______   ________  ________  ________         
3 |\  _____\\  \|\_____  \|\_____  \|\  \|\  \|\  ___ \ |\   __  \|\   ___ \|\_____  \        
4 \ \  \__/\ \  \\|___/  /|\|___/  /\ \  \\\  \ \   __/|\ \  \|\  \ \  \_|\ \\|___/  /|       
5  \ \   __\\ \  \   /  / /    /  / /\ \   __  \ \  \_|/_\ \   __  \ \  \ \\ \   /  / /       
6   \ \  \_| \ \  \ /  /_/__  /  /_/__\ \  \ \  \ \  \_|\ \ \  \ \  \ \  \_\\ \ /  /_/__      
7    \ \__\   \ \__\\________\\________\ \__\ \__\ \_______\ \__\ \__\ \_______\\________\    
8     \|__|    \|__|\|_______|\|_______|\|__|\|__|\|_______|\|__|\|__|\|_______|\|_______|
9                                                                                                                                                                                                                                                                                                     
10  */
11 
12 // SPDX-License-Identifier: MIT
13 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/IOperatorFilterRegistry.sol
14 
15 
16 pragma solidity ^0.8.13;
17 
18 interface IOperatorFilterRegistry {
19     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
20     function register(address registrant) external;
21     function registerAndSubscribe(address registrant, address subscription) external;
22     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
23     function unregister(address addr) external;
24     function updateOperator(address registrant, address operator, bool filtered) external;
25     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
26     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
27     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
28     function subscribe(address registrant, address registrantToSubscribe) external;
29     function unsubscribe(address registrant, bool copyExistingEntries) external;
30     function subscriptionOf(address addr) external returns (address registrant);
31     function subscribers(address registrant) external returns (address[] memory);
32     function subscriberAt(address registrant, uint256 index) external returns (address);
33     function copyEntriesOf(address registrant, address registrantToCopy) external;
34     function isOperatorFiltered(address registrant, address operator) external returns (bool);
35     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
36     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
37     function filteredOperators(address addr) external returns (address[] memory);
38     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
39     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
40     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
41     function isRegistered(address addr) external returns (bool);
42     function codeHashOf(address addr) external returns (bytes32);
43 }
44 
45 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/OperatorFilterer.sol
46 
47 
48 pragma solidity ^0.8.13;
49 
50 
51 /**
52  * @title  OperatorFilterer
53  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
54  *         registrant's entries in the OperatorFilterRegistry.
55  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
56  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
57  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
58  */
59 abstract contract OperatorFilterer {
60     error OperatorNotAllowed(address operator);
61 
62     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
63         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
64 
65     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
66         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
67         // will not revert, but the contract will need to be registered with the registry once it is deployed in
68         // order for the modifier to filter addresses.
69         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
70             if (subscribe) {
71                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
72             } else {
73                 if (subscriptionOrRegistrantToCopy != address(0)) {
74                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
75                 } else {
76                     OPERATOR_FILTER_REGISTRY.register(address(this));
77                 }
78             }
79         }
80     }
81 
82     modifier onlyAllowedOperator(address from) virtual {
83         // Check registry code length to facilitate testing in environments without a deployed registry.
84         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
85             // Allow spending tokens from addresses with balance
86             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
87             // from an EOA.
88             if (from == msg.sender) {
89                 _;
90                 return;
91             }
92             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
93                 revert OperatorNotAllowed(msg.sender);
94             }
95         }
96         _;
97     }
98 
99     modifier onlyAllowedOperatorApproval(address operator) virtual {
100         // Check registry code length to facilitate testing in environments without a deployed registry.
101         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
102             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
103                 revert OperatorNotAllowed(operator);
104             }
105         }
106         _;
107     }
108 }
109 
110 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/DefaultOperatorFilterer.sol
111 
112 
113 pragma solidity ^0.8.13;
114 
115 
116 /**
117  * @title  DefaultOperatorFilterer
118  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
119  */
120 abstract contract DefaultOperatorFilterer is OperatorFilterer {
121     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
122 
123     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
124 }
125 
126 // File: erc721a/contracts/IERC721A.sol
127 
128 
129 // ERC721A Contracts v4.2.3
130 // Creator: Chiru Labs
131 
132 pragma solidity ^0.8.4;
133 
134 /**
135  * @dev Interface of ERC721A.
136  */
137 interface IERC721A {
138     /**
139      * The caller must own the token or be an approved operator.
140      */
141     error ApprovalCallerNotOwnerNorApproved();
142 
143     /**
144      * The token does not exist.
145      */
146     error ApprovalQueryForNonexistentToken();
147 
148     /**
149      * Cannot query the balance for the zero address.
150      */
151     error BalanceQueryForZeroAddress();
152 
153     /**
154      * Cannot mint to the zero address.
155      */
156     error MintToZeroAddress();
157 
158     /**
159      * The quantity of tokens minted must be more than zero.
160      */
161     error MintZeroQuantity();
162 
163     /**
164      * The token does not exist.
165      */
166     error OwnerQueryForNonexistentToken();
167 
168     /**
169      * The caller must own the token or be an approved operator.
170      */
171     error TransferCallerNotOwnerNorApproved();
172 
173     /**
174      * The token must be owned by `from`.
175      */
176     error TransferFromIncorrectOwner();
177 
178     /**
179      * Cannot safely transfer to a contract that does not implement the
180      * ERC721Receiver interface.
181      */
182     error TransferToNonERC721ReceiverImplementer();
183 
184     /**
185      * Cannot transfer to the zero address.
186      */
187     error TransferToZeroAddress();
188 
189     /**
190      * The token does not exist.
191      */
192     error URIQueryForNonexistentToken();
193 
194     /**
195      * The `quantity` minted with ERC2309 exceeds the safety limit.
196      */
197     error MintERC2309QuantityExceedsLimit();
198 
199     /**
200      * The `extraData` cannot be set on an unintialized ownership slot.
201      */
202     error OwnershipNotInitializedForExtraData();
203 
204     // =============================================================
205     //                            STRUCTS
206     // =============================================================
207 
208     struct TokenOwnership {
209         // The address of the owner.
210         address addr;
211         // Stores the start time of ownership with minimal overhead for tokenomics.
212         uint64 startTimestamp;
213         // Whether the token has been burned.
214         bool burned;
215         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
216         uint24 extraData;
217     }
218 
219     // =============================================================
220     //                         TOKEN COUNTERS
221     // =============================================================
222 
223     /**
224      * @dev Returns the total number of tokens in existence.
225      * Burned tokens will reduce the count.
226      * To get the total number of tokens minted, please see {_totalMinted}.
227      */
228     function totalSupply() external view returns (uint256);
229 
230     // =============================================================
231     //                            IERC165
232     // =============================================================
233 
234     /**
235      * @dev Returns true if this contract implements the interface defined by
236      * `interfaceId`. See the corresponding
237      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
238      * to learn more about how these ids are created.
239      *
240      * This function call must use less than 30000 gas.
241      */
242     function supportsInterface(bytes4 interfaceId) external view returns (bool);
243 
244     // =============================================================
245     //                            IERC721
246     // =============================================================
247 
248     /**
249      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
252 
253     /**
254      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
255      */
256     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
257 
258     /**
259      * @dev Emitted when `owner` enables or disables
260      * (`approved`) `operator` to manage all of its assets.
261      */
262     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
263 
264     /**
265      * @dev Returns the number of tokens in `owner`'s account.
266      */
267     function balanceOf(address owner) external view returns (uint256 balance);
268 
269     /**
270      * @dev Returns the owner of the `tokenId` token.
271      *
272      * Requirements:
273      *
274      * - `tokenId` must exist.
275      */
276     function ownerOf(uint256 tokenId) external view returns (address owner);
277 
278     /**
279      * @dev Safely transfers `tokenId` token from `from` to `to`,
280      * checking first that contract recipients are aware of the ERC721 protocol
281      * to prevent tokens from being forever locked.
282      *
283      * Requirements:
284      *
285      * - `from` cannot be the zero address.
286      * - `to` cannot be the zero address.
287      * - `tokenId` token must exist and be owned by `from`.
288      * - If the caller is not `from`, it must be have been allowed to move
289      * this token by either {approve} or {setApprovalForAll}.
290      * - If `to` refers to a smart contract, it must implement
291      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
292      *
293      * Emits a {Transfer} event.
294      */
295     function safeTransferFrom(
296         address from,
297         address to,
298         uint256 tokenId,
299         bytes calldata data
300     ) external payable;
301 
302     /**
303      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
304      */
305     function safeTransferFrom(
306         address from,
307         address to,
308         uint256 tokenId
309     ) external payable;
310 
311     /**
312      * @dev Transfers `tokenId` from `from` to `to`.
313      *
314      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
315      * whenever possible.
316      *
317      * Requirements:
318      *
319      * - `from` cannot be the zero address.
320      * - `to` cannot be the zero address.
321      * - `tokenId` token must be owned by `from`.
322      * - If the caller is not `from`, it must be approved to move this token
323      * by either {approve} or {setApprovalForAll}.
324      *
325      * Emits a {Transfer} event.
326      */
327     function transferFrom(
328         address from,
329         address to,
330         uint256 tokenId
331     ) external payable;
332 
333     /**
334      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
335      * The approval is cleared when the token is transferred.
336      *
337      * Only a single account can be approved at a time, so approving the
338      * zero address clears previous approvals.
339      *
340      * Requirements:
341      *
342      * - The caller must own the token or be an approved operator.
343      * - `tokenId` must exist.
344      *
345      * Emits an {Approval} event.
346      */
347     function approve(address to, uint256 tokenId) external payable;
348 
349     /**
350      * @dev Approve or remove `operator` as an operator for the caller.
351      * Operators can call {transferFrom} or {safeTransferFrom}
352      * for any token owned by the caller.
353      *
354      * Requirements:
355      *
356      * - The `operator` cannot be the caller.
357      *
358      * Emits an {ApprovalForAll} event.
359      */
360     function setApprovalForAll(address operator, bool _approved) external;
361 
362     /**
363      * @dev Returns the account approved for `tokenId` token.
364      *
365      * Requirements:
366      *
367      * - `tokenId` must exist.
368      */
369     function getApproved(uint256 tokenId) external view returns (address operator);
370 
371     /**
372      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
373      *
374      * See {setApprovalForAll}.
375      */
376     function isApprovedForAll(address owner, address operator) external view returns (bool);
377 
378     // =============================================================
379     //                        IERC721Metadata
380     // =============================================================
381 
382     /**
383      * @dev Returns the token collection name.
384      */
385     function name() external view returns (string memory);
386 
387     /**
388      * @dev Returns the token collection symbol.
389      */
390     function symbol() external view returns (string memory);
391 
392     /**
393      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
394      */
395     function tokenURI(uint256 tokenId) external view returns (string memory);
396 
397     // =============================================================
398     //                           IERC2309
399     // =============================================================
400 
401     /**
402      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
403      * (inclusive) is transferred from `from` to `to`, as defined in the
404      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
405      *
406      * See {_mintERC2309} for more details.
407      */
408     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
409 }
410 
411 // File: erc721a/contracts/ERC721A.sol
412 
413 
414 // ERC721A Contracts v4.2.3
415 // Creator: Chiru Labs
416 
417 pragma solidity ^0.8.4;
418 
419 
420 /**
421  * @dev Interface of ERC721 token receiver.
422  */
423 interface ERC721A__IERC721Receiver {
424     function onERC721Received(
425         address operator,
426         address from,
427         uint256 tokenId,
428         bytes calldata data
429     ) external returns (bytes4);
430 }
431 
432 /**
433  * @title ERC721A
434  *
435  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
436  * Non-Fungible Token Standard, including the Metadata extension.
437  * Optimized for lower gas during batch mints.
438  *
439  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
440  * starting from `_startTokenId()`.
441  *
442  * Assumptions:
443  *
444  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
445  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
446  */
447 contract ERC721A is IERC721A {
448     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
449     struct TokenApprovalRef {
450         address value;
451     }
452 
453     // =============================================================
454     //                           CONSTANTS
455     // =============================================================
456 
457     // Mask of an entry in packed address data.
458     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
459 
460     // The bit position of `numberMinted` in packed address data.
461     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
462 
463     // The bit position of `numberBurned` in packed address data.
464     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
465 
466     // The bit position of `aux` in packed address data.
467     uint256 private constant _BITPOS_AUX = 192;
468 
469     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
470     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
471 
472     // The bit position of `startTimestamp` in packed ownership.
473     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
474 
475     // The bit mask of the `burned` bit in packed ownership.
476     uint256 private constant _BITMASK_BURNED = 1 << 224;
477 
478     // The bit position of the `nextInitialized` bit in packed ownership.
479     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
480 
481     // The bit mask of the `nextInitialized` bit in packed ownership.
482     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
483 
484     // The bit position of `extraData` in packed ownership.
485     uint256 private constant _BITPOS_EXTRA_DATA = 232;
486 
487     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
488     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
489 
490     // The mask of the lower 160 bits for addresses.
491     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
492 
493     // The maximum `quantity` that can be minted with {_mintERC2309}.
494     // This limit is to prevent overflows on the address data entries.
495     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
496     // is required to cause an overflow, which is unrealistic.
497     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
498 
499     // The `Transfer` event signature is given by:
500     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
501     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
502         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
503 
504     // =============================================================
505     //                            STORAGE
506     // =============================================================
507 
508     // The next token ID to be minted.
509     uint256 private _currentIndex;
510 
511     // The number of tokens burned.
512     uint256 private _burnCounter;
513 
514     // Token name
515     string private _name;
516 
517     // Token symbol
518     string private _symbol;
519 
520     // Mapping from token ID to ownership details
521     // An empty struct value does not necessarily mean the token is unowned.
522     // See {_packedOwnershipOf} implementation for details.
523     //
524     // Bits Layout:
525     // - [0..159]   `addr`
526     // - [160..223] `startTimestamp`
527     // - [224]      `burned`
528     // - [225]      `nextInitialized`
529     // - [232..255] `extraData`
530     mapping(uint256 => uint256) private _packedOwnerships;
531 
532     // Mapping owner address to address data.
533     //
534     // Bits Layout:
535     // - [0..63]    `balance`
536     // - [64..127]  `numberMinted`
537     // - [128..191] `numberBurned`
538     // - [192..255] `aux`
539     mapping(address => uint256) private _packedAddressData;
540 
541     // Mapping from token ID to approved address.
542     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
543 
544     // Mapping from owner to operator approvals
545     mapping(address => mapping(address => bool)) private _operatorApprovals;
546 
547     // =============================================================
548     //                          CONSTRUCTOR
549     // =============================================================
550 
551     constructor(string memory name_, string memory symbol_) {
552         _name = name_;
553         _symbol = symbol_;
554         _currentIndex = _startTokenId();
555     }
556 
557     // =============================================================
558     //                   TOKEN COUNTING OPERATIONS
559     // =============================================================
560 
561     /**
562      * @dev Returns the starting token ID.
563      * To change the starting token ID, please override this function.
564      */
565     function _startTokenId() internal view virtual returns (uint256) {
566         return 0;
567     }
568 
569     /**
570      * @dev Returns the next token ID to be minted.
571      */
572     function _nextTokenId() internal view virtual returns (uint256) {
573         return _currentIndex;
574     }
575 
576     /**
577      * @dev Returns the total number of tokens in existence.
578      * Burned tokens will reduce the count.
579      * To get the total number of tokens minted, please see {_totalMinted}.
580      */
581     function totalSupply() public view virtual override returns (uint256) {
582         // Counter underflow is impossible as _burnCounter cannot be incremented
583         // more than `_currentIndex - _startTokenId()` times.
584         unchecked {
585             return _currentIndex - _burnCounter - _startTokenId();
586         }
587     }
588 
589     /**
590      * @dev Returns the total amount of tokens minted in the contract.
591      */
592     function _totalMinted() internal view virtual returns (uint256) {
593         // Counter underflow is impossible as `_currentIndex` does not decrement,
594         // and it is initialized to `_startTokenId()`.
595         unchecked {
596             return _currentIndex - _startTokenId();
597         }
598     }
599 
600     /**
601      * @dev Returns the total number of tokens burned.
602      */
603     function _totalBurned() internal view virtual returns (uint256) {
604         return _burnCounter;
605     }
606 
607     // =============================================================
608     //                    ADDRESS DATA OPERATIONS
609     // =============================================================
610 
611     /**
612      * @dev Returns the number of tokens in `owner`'s account.
613      */
614     function balanceOf(address owner) public view virtual override returns (uint256) {
615         if (owner == address(0)) revert BalanceQueryForZeroAddress();
616         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
617     }
618 
619     /**
620      * Returns the number of tokens minted by `owner`.
621      */
622     function _numberMinted(address owner) internal view returns (uint256) {
623         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
624     }
625 
626     /**
627      * Returns the number of tokens burned by or on behalf of `owner`.
628      */
629     function _numberBurned(address owner) internal view returns (uint256) {
630         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
631     }
632 
633     /**
634      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
635      */
636     function _getAux(address owner) internal view returns (uint64) {
637         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
638     }
639 
640     /**
641      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
642      * If there are multiple variables, please pack them into a uint64.
643      */
644     function _setAux(address owner, uint64 aux) internal virtual {
645         uint256 packed = _packedAddressData[owner];
646         uint256 auxCasted;
647         // Cast `aux` with assembly to avoid redundant masking.
648         assembly {
649             auxCasted := aux
650         }
651         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
652         _packedAddressData[owner] = packed;
653     }
654 
655     // =============================================================
656     //                            IERC165
657     // =============================================================
658 
659     /**
660      * @dev Returns true if this contract implements the interface defined by
661      * `interfaceId`. See the corresponding
662      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
663      * to learn more about how these ids are created.
664      *
665      * This function call must use less than 30000 gas.
666      */
667     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
668         // The interface IDs are constants representing the first 4 bytes
669         // of the XOR of all function selectors in the interface.
670         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
671         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
672         return
673             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
674             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
675             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
676     }
677 
678     // =============================================================
679     //                        IERC721Metadata
680     // =============================================================
681 
682     /**
683      * @dev Returns the token collection name.
684      */
685     function name() public view virtual override returns (string memory) {
686         return _name;
687     }
688 
689     /**
690      * @dev Returns the token collection symbol.
691      */
692     function symbol() public view virtual override returns (string memory) {
693         return _symbol;
694     }
695 
696     /**
697      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
698      */
699     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
700         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
701 
702         string memory baseURI = _baseURI();
703         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
704     }
705 
706     /**
707      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
708      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
709      * by default, it can be overridden in child contracts.
710      */
711     function _baseURI() internal view virtual returns (string memory) {
712         return '';
713     }
714 
715     // =============================================================
716     //                     OWNERSHIPS OPERATIONS
717     // =============================================================
718 
719     /**
720      * @dev Returns the owner of the `tokenId` token.
721      *
722      * Requirements:
723      *
724      * - `tokenId` must exist.
725      */
726     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
727         return address(uint160(_packedOwnershipOf(tokenId)));
728     }
729 
730     /**
731      * @dev Gas spent here starts off proportional to the maximum mint batch size.
732      * It gradually moves to O(1) as tokens get transferred around over time.
733      */
734     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
735         return _unpackedOwnership(_packedOwnershipOf(tokenId));
736     }
737 
738     /**
739      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
740      */
741     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
742         return _unpackedOwnership(_packedOwnerships[index]);
743     }
744 
745     /**
746      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
747      */
748     function _initializeOwnershipAt(uint256 index) internal virtual {
749         if (_packedOwnerships[index] == 0) {
750             _packedOwnerships[index] = _packedOwnershipOf(index);
751         }
752     }
753 
754     /**
755      * Returns the packed ownership data of `tokenId`.
756      */
757     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
758         uint256 curr = tokenId;
759 
760         unchecked {
761             if (_startTokenId() <= curr)
762                 if (curr < _currentIndex) {
763                     uint256 packed = _packedOwnerships[curr];
764                     // If not burned.
765                     if (packed & _BITMASK_BURNED == 0) {
766                         // Invariant:
767                         // There will always be an initialized ownership slot
768                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
769                         // before an unintialized ownership slot
770                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
771                         // Hence, `curr` will not underflow.
772                         //
773                         // We can directly compare the packed value.
774                         // If the address is zero, packed will be zero.
775                         while (packed == 0) {
776                             packed = _packedOwnerships[--curr];
777                         }
778                         return packed;
779                     }
780                 }
781         }
782         revert OwnerQueryForNonexistentToken();
783     }
784 
785     /**
786      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
787      */
788     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
789         ownership.addr = address(uint160(packed));
790         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
791         ownership.burned = packed & _BITMASK_BURNED != 0;
792         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
793     }
794 
795     /**
796      * @dev Packs ownership data into a single uint256.
797      */
798     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
799         assembly {
800             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
801             owner := and(owner, _BITMASK_ADDRESS)
802             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
803             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
804         }
805     }
806 
807     /**
808      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
809      */
810     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
811         // For branchless setting of the `nextInitialized` flag.
812         assembly {
813             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
814             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
815         }
816     }
817 
818     // =============================================================
819     //                      APPROVAL OPERATIONS
820     // =============================================================
821 
822     /**
823      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
824      * The approval is cleared when the token is transferred.
825      *
826      * Only a single account can be approved at a time, so approving the
827      * zero address clears previous approvals.
828      *
829      * Requirements:
830      *
831      * - The caller must own the token or be an approved operator.
832      * - `tokenId` must exist.
833      *
834      * Emits an {Approval} event.
835      */
836     function approve(address to, uint256 tokenId) public payable virtual override {
837         address owner = ownerOf(tokenId);
838 
839         if (_msgSenderERC721A() != owner)
840             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
841                 revert ApprovalCallerNotOwnerNorApproved();
842             }
843 
844         _tokenApprovals[tokenId].value = to;
845         emit Approval(owner, to, tokenId);
846     }
847 
848     /**
849      * @dev Returns the account approved for `tokenId` token.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      */
855     function getApproved(uint256 tokenId) public view virtual override returns (address) {
856         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
857 
858         return _tokenApprovals[tokenId].value;
859     }
860 
861     /**
862      * @dev Approve or remove `operator` as an operator for the caller.
863      * Operators can call {transferFrom} or {safeTransferFrom}
864      * for any token owned by the caller.
865      *
866      * Requirements:
867      *
868      * - The `operator` cannot be the caller.
869      *
870      * Emits an {ApprovalForAll} event.
871      */
872     function setApprovalForAll(address operator, bool approved) public virtual override {
873         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
874         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
875     }
876 
877     /**
878      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
879      *
880      * See {setApprovalForAll}.
881      */
882     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
883         return _operatorApprovals[owner][operator];
884     }
885 
886     /**
887      * @dev Returns whether `tokenId` exists.
888      *
889      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
890      *
891      * Tokens start existing when they are minted. See {_mint}.
892      */
893     function _exists(uint256 tokenId) internal view virtual returns (bool) {
894         return
895             _startTokenId() <= tokenId &&
896             tokenId < _currentIndex && // If within bounds,
897             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
898     }
899 
900     /**
901      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
902      */
903     function _isSenderApprovedOrOwner(
904         address approvedAddress,
905         address owner,
906         address msgSender
907     ) private pure returns (bool result) {
908         assembly {
909             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
910             owner := and(owner, _BITMASK_ADDRESS)
911             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
912             msgSender := and(msgSender, _BITMASK_ADDRESS)
913             // `msgSender == owner || msgSender == approvedAddress`.
914             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
915         }
916     }
917 
918     /**
919      * @dev Returns the storage slot and value for the approved address of `tokenId`.
920      */
921     function _getApprovedSlotAndAddress(uint256 tokenId)
922         private
923         view
924         returns (uint256 approvedAddressSlot, address approvedAddress)
925     {
926         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
927         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
928         assembly {
929             approvedAddressSlot := tokenApproval.slot
930             approvedAddress := sload(approvedAddressSlot)
931         }
932     }
933 
934     // =============================================================
935     //                      TRANSFER OPERATIONS
936     // =============================================================
937 
938     /**
939      * @dev Transfers `tokenId` from `from` to `to`.
940      *
941      * Requirements:
942      *
943      * - `from` cannot be the zero address.
944      * - `to` cannot be the zero address.
945      * - `tokenId` token must be owned by `from`.
946      * - If the caller is not `from`, it must be approved to move this token
947      * by either {approve} or {setApprovalForAll}.
948      *
949      * Emits a {Transfer} event.
950      */
951     function transferFrom(
952         address from,
953         address to,
954         uint256 tokenId
955     ) public payable virtual override {
956         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
957 
958         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
959 
960         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
961 
962         // The nested ifs save around 20+ gas over a compound boolean condition.
963         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
964             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
965 
966         if (to == address(0)) revert TransferToZeroAddress();
967 
968         _beforeTokenTransfers(from, to, tokenId, 1);
969 
970         // Clear approvals from the previous owner.
971         assembly {
972             if approvedAddress {
973                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
974                 sstore(approvedAddressSlot, 0)
975             }
976         }
977 
978         // Underflow of the sender's balance is impossible because we check for
979         // ownership above and the recipient's balance can't realistically overflow.
980         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
981         unchecked {
982             // We can directly increment and decrement the balances.
983             --_packedAddressData[from]; // Updates: `balance -= 1`.
984             ++_packedAddressData[to]; // Updates: `balance += 1`.
985 
986             // Updates:
987             // - `address` to the next owner.
988             // - `startTimestamp` to the timestamp of transfering.
989             // - `burned` to `false`.
990             // - `nextInitialized` to `true`.
991             _packedOwnerships[tokenId] = _packOwnershipData(
992                 to,
993                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
994             );
995 
996             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
997             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
998                 uint256 nextTokenId = tokenId + 1;
999                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1000                 if (_packedOwnerships[nextTokenId] == 0) {
1001                     // If the next slot is within bounds.
1002                     if (nextTokenId != _currentIndex) {
1003                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1004                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1005                     }
1006                 }
1007             }
1008         }
1009 
1010         emit Transfer(from, to, tokenId);
1011         _afterTokenTransfers(from, to, tokenId, 1);
1012     }
1013 
1014     /**
1015      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1016      */
1017     function safeTransferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) public payable virtual override {
1022         safeTransferFrom(from, to, tokenId, '');
1023     }
1024 
1025     /**
1026      * @dev Safely transfers `tokenId` token from `from` to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `from` cannot be the zero address.
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must exist and be owned by `from`.
1033      * - If the caller is not `from`, it must be approved to move this token
1034      * by either {approve} or {setApprovalForAll}.
1035      * - If `to` refers to a smart contract, it must implement
1036      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function safeTransferFrom(
1041         address from,
1042         address to,
1043         uint256 tokenId,
1044         bytes memory _data
1045     ) public payable virtual override {
1046         transferFrom(from, to, tokenId);
1047         if (to.code.length != 0)
1048             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1049                 revert TransferToNonERC721ReceiverImplementer();
1050             }
1051     }
1052 
1053     /**
1054      * @dev Hook that is called before a set of serially-ordered token IDs
1055      * are about to be transferred. This includes minting.
1056      * And also called before burning one token.
1057      *
1058      * `startTokenId` - the first token ID to be transferred.
1059      * `quantity` - the amount to be transferred.
1060      *
1061      * Calling conditions:
1062      *
1063      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1064      * transferred to `to`.
1065      * - When `from` is zero, `tokenId` will be minted for `to`.
1066      * - When `to` is zero, `tokenId` will be burned by `from`.
1067      * - `from` and `to` are never both zero.
1068      */
1069     function _beforeTokenTransfers(
1070         address from,
1071         address to,
1072         uint256 startTokenId,
1073         uint256 quantity
1074     ) internal virtual {}
1075 
1076     /**
1077      * @dev Hook that is called after a set of serially-ordered token IDs
1078      * have been transferred. This includes minting.
1079      * And also called after one token has been burned.
1080      *
1081      * `startTokenId` - the first token ID to be transferred.
1082      * `quantity` - the amount to be transferred.
1083      *
1084      * Calling conditions:
1085      *
1086      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1087      * transferred to `to`.
1088      * - When `from` is zero, `tokenId` has been minted for `to`.
1089      * - When `to` is zero, `tokenId` has been burned by `from`.
1090      * - `from` and `to` are never both zero.
1091      */
1092     function _afterTokenTransfers(
1093         address from,
1094         address to,
1095         uint256 startTokenId,
1096         uint256 quantity
1097     ) internal virtual {}
1098 
1099     /**
1100      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1101      *
1102      * `from` - Previous owner of the given token ID.
1103      * `to` - Target address that will receive the token.
1104      * `tokenId` - Token ID to be transferred.
1105      * `_data` - Optional data to send along with the call.
1106      *
1107      * Returns whether the call correctly returned the expected magic value.
1108      */
1109     function _checkContractOnERC721Received(
1110         address from,
1111         address to,
1112         uint256 tokenId,
1113         bytes memory _data
1114     ) private returns (bool) {
1115         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1116             bytes4 retval
1117         ) {
1118             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1119         } catch (bytes memory reason) {
1120             if (reason.length == 0) {
1121                 revert TransferToNonERC721ReceiverImplementer();
1122             } else {
1123                 assembly {
1124                     revert(add(32, reason), mload(reason))
1125                 }
1126             }
1127         }
1128     }
1129 
1130     // =============================================================
1131     //                        MINT OPERATIONS
1132     // =============================================================
1133 
1134     /**
1135      * @dev Mints `quantity` tokens and transfers them to `to`.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `quantity` must be greater than 0.
1141      *
1142      * Emits a {Transfer} event for each mint.
1143      */
1144     function _mint(address to, uint256 quantity) internal virtual {
1145         uint256 startTokenId = _currentIndex;
1146         if (quantity == 0) revert MintZeroQuantity();
1147 
1148         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1149 
1150         // Overflows are incredibly unrealistic.
1151         // `balance` and `numberMinted` have a maximum limit of 2**64.
1152         // `tokenId` has a maximum limit of 2**256.
1153         unchecked {
1154             // Updates:
1155             // - `balance += quantity`.
1156             // - `numberMinted += quantity`.
1157             //
1158             // We can directly add to the `balance` and `numberMinted`.
1159             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1160 
1161             // Updates:
1162             // - `address` to the owner.
1163             // - `startTimestamp` to the timestamp of minting.
1164             // - `burned` to `false`.
1165             // - `nextInitialized` to `quantity == 1`.
1166             _packedOwnerships[startTokenId] = _packOwnershipData(
1167                 to,
1168                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1169             );
1170 
1171             uint256 toMasked;
1172             uint256 end = startTokenId + quantity;
1173 
1174             // Use assembly to loop and emit the `Transfer` event for gas savings.
1175             // The duplicated `log4` removes an extra check and reduces stack juggling.
1176             // The assembly, together with the surrounding Solidity code, have been
1177             // delicately arranged to nudge the compiler into producing optimized opcodes.
1178             assembly {
1179                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1180                 toMasked := and(to, _BITMASK_ADDRESS)
1181                 // Emit the `Transfer` event.
1182                 log4(
1183                     0, // Start of data (0, since no data).
1184                     0, // End of data (0, since no data).
1185                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1186                     0, // `address(0)`.
1187                     toMasked, // `to`.
1188                     startTokenId // `tokenId`.
1189                 )
1190 
1191                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1192                 // that overflows uint256 will make the loop run out of gas.
1193                 // The compiler will optimize the `iszero` away for performance.
1194                 for {
1195                     let tokenId := add(startTokenId, 1)
1196                 } iszero(eq(tokenId, end)) {
1197                     tokenId := add(tokenId, 1)
1198                 } {
1199                     // Emit the `Transfer` event. Similar to above.
1200                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1201                 }
1202             }
1203             if (toMasked == 0) revert MintToZeroAddress();
1204 
1205             _currentIndex = end;
1206         }
1207         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1208     }
1209 
1210     /**
1211      * @dev Mints `quantity` tokens and transfers them to `to`.
1212      *
1213      * This function is intended for efficient minting only during contract creation.
1214      *
1215      * It emits only one {ConsecutiveTransfer} as defined in
1216      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1217      * instead of a sequence of {Transfer} event(s).
1218      *
1219      * Calling this function outside of contract creation WILL make your contract
1220      * non-compliant with the ERC721 standard.
1221      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1222      * {ConsecutiveTransfer} event is only permissible during contract creation.
1223      *
1224      * Requirements:
1225      *
1226      * - `to` cannot be the zero address.
1227      * - `quantity` must be greater than 0.
1228      *
1229      * Emits a {ConsecutiveTransfer} event.
1230      */
1231     function _mintERC2309(address to, uint256 quantity) internal virtual {
1232         uint256 startTokenId = _currentIndex;
1233         if (to == address(0)) revert MintToZeroAddress();
1234         if (quantity == 0) revert MintZeroQuantity();
1235         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1236 
1237         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1238 
1239         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1240         unchecked {
1241             // Updates:
1242             // - `balance += quantity`.
1243             // - `numberMinted += quantity`.
1244             //
1245             // We can directly add to the `balance` and `numberMinted`.
1246             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1247 
1248             // Updates:
1249             // - `address` to the owner.
1250             // - `startTimestamp` to the timestamp of minting.
1251             // - `burned` to `false`.
1252             // - `nextInitialized` to `quantity == 1`.
1253             _packedOwnerships[startTokenId] = _packOwnershipData(
1254                 to,
1255                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1256             );
1257 
1258             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1259 
1260             _currentIndex = startTokenId + quantity;
1261         }
1262         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1263     }
1264 
1265     /**
1266      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1267      *
1268      * Requirements:
1269      *
1270      * - If `to` refers to a smart contract, it must implement
1271      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1272      * - `quantity` must be greater than 0.
1273      *
1274      * See {_mint}.
1275      *
1276      * Emits a {Transfer} event for each mint.
1277      */
1278     function _safeMint(
1279         address to,
1280         uint256 quantity,
1281         bytes memory _data
1282     ) internal virtual {
1283         _mint(to, quantity);
1284 
1285         unchecked {
1286             if (to.code.length != 0) {
1287                 uint256 end = _currentIndex;
1288                 uint256 index = end - quantity;
1289                 do {
1290                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1291                         revert TransferToNonERC721ReceiverImplementer();
1292                     }
1293                 } while (index < end);
1294                 // Reentrancy protection.
1295                 if (_currentIndex != end) revert();
1296             }
1297         }
1298     }
1299 
1300     /**
1301      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1302      */
1303     function _safeMint(address to, uint256 quantity) internal virtual {
1304         _safeMint(to, quantity, '');
1305     }
1306 
1307     // =============================================================
1308     //                        BURN OPERATIONS
1309     // =============================================================
1310 
1311     /**
1312      * @dev Equivalent to `_burn(tokenId, false)`.
1313      */
1314     function _burn(uint256 tokenId) internal virtual {
1315         _burn(tokenId, false);
1316     }
1317 
1318     /**
1319      * @dev Destroys `tokenId`.
1320      * The approval is cleared when the token is burned.
1321      *
1322      * Requirements:
1323      *
1324      * - `tokenId` must exist.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1329         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1330 
1331         address from = address(uint160(prevOwnershipPacked));
1332 
1333         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1334 
1335         if (approvalCheck) {
1336             // The nested ifs save around 20+ gas over a compound boolean condition.
1337             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1338                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1339         }
1340 
1341         _beforeTokenTransfers(from, address(0), tokenId, 1);
1342 
1343         // Clear approvals from the previous owner.
1344         assembly {
1345             if approvedAddress {
1346                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1347                 sstore(approvedAddressSlot, 0)
1348             }
1349         }
1350 
1351         // Underflow of the sender's balance is impossible because we check for
1352         // ownership above and the recipient's balance can't realistically overflow.
1353         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1354         unchecked {
1355             // Updates:
1356             // - `balance -= 1`.
1357             // - `numberBurned += 1`.
1358             //
1359             // We can directly decrement the balance, and increment the number burned.
1360             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1361             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1362 
1363             // Updates:
1364             // - `address` to the last owner.
1365             // - `startTimestamp` to the timestamp of burning.
1366             // - `burned` to `true`.
1367             // - `nextInitialized` to `true`.
1368             _packedOwnerships[tokenId] = _packOwnershipData(
1369                 from,
1370                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1371             );
1372 
1373             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1374             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1375                 uint256 nextTokenId = tokenId + 1;
1376                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1377                 if (_packedOwnerships[nextTokenId] == 0) {
1378                     // If the next slot is within bounds.
1379                     if (nextTokenId != _currentIndex) {
1380                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1381                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1382                     }
1383                 }
1384             }
1385         }
1386 
1387         emit Transfer(from, address(0), tokenId);
1388         _afterTokenTransfers(from, address(0), tokenId, 1);
1389 
1390         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1391         unchecked {
1392             _burnCounter++;
1393         }
1394     }
1395 
1396     // =============================================================
1397     //                     EXTRA DATA OPERATIONS
1398     // =============================================================
1399 
1400     /**
1401      * @dev Directly sets the extra data for the ownership data `index`.
1402      */
1403     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1404         uint256 packed = _packedOwnerships[index];
1405         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1406         uint256 extraDataCasted;
1407         // Cast `extraData` with assembly to avoid redundant masking.
1408         assembly {
1409             extraDataCasted := extraData
1410         }
1411         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1412         _packedOwnerships[index] = packed;
1413     }
1414 
1415     /**
1416      * @dev Called during each token transfer to set the 24bit `extraData` field.
1417      * Intended to be overridden by the cosumer contract.
1418      *
1419      * `previousExtraData` - the value of `extraData` before transfer.
1420      *
1421      * Calling conditions:
1422      *
1423      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1424      * transferred to `to`.
1425      * - When `from` is zero, `tokenId` will be minted for `to`.
1426      * - When `to` is zero, `tokenId` will be burned by `from`.
1427      * - `from` and `to` are never both zero.
1428      */
1429     function _extraData(
1430         address from,
1431         address to,
1432         uint24 previousExtraData
1433     ) internal view virtual returns (uint24) {}
1434 
1435     /**
1436      * @dev Returns the next extra data for the packed ownership data.
1437      * The returned result is shifted into position.
1438      */
1439     function _nextExtraData(
1440         address from,
1441         address to,
1442         uint256 prevOwnershipPacked
1443     ) private view returns (uint256) {
1444         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1445         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1446     }
1447 
1448     // =============================================================
1449     //                       OTHER OPERATIONS
1450     // =============================================================
1451 
1452     /**
1453      * @dev Returns the message sender (defaults to `msg.sender`).
1454      *
1455      * If you are writing GSN compatible contracts, you need to override this function.
1456      */
1457     function _msgSenderERC721A() internal view virtual returns (address) {
1458         return msg.sender;
1459     }
1460 
1461     /**
1462      * @dev Converts a uint256 to its ASCII string decimal representation.
1463      */
1464     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1465         assembly {
1466             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1467             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1468             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1469             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1470             let m := add(mload(0x40), 0xa0)
1471             // Update the free memory pointer to allocate.
1472             mstore(0x40, m)
1473             // Assign the `str` to the end.
1474             str := sub(m, 0x20)
1475             // Zeroize the slot after the string.
1476             mstore(str, 0)
1477 
1478             // Cache the end of the memory to calculate the length later.
1479             let end := str
1480 
1481             // We write the string from rightmost digit to leftmost digit.
1482             // The following is essentially a do-while loop that also handles the zero case.
1483             // prettier-ignore
1484             for { let temp := value } 1 {} {
1485                 str := sub(str, 1)
1486                 // Write the character to the pointer.
1487                 // The ASCII index of the '0' character is 48.
1488                 mstore8(str, add(48, mod(temp, 10)))
1489                 // Keep dividing `temp` until zero.
1490                 temp := div(temp, 10)
1491                 // prettier-ignore
1492                 if iszero(temp) { break }
1493             }
1494 
1495             let length := sub(end, str)
1496             // Move the pointer 32 bytes leftwards to make room for the length.
1497             str := sub(str, 0x20)
1498             // Store the length.
1499             mstore(str, length)
1500         }
1501     }
1502 }
1503 
1504 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1505 
1506 
1507 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1508 
1509 pragma solidity ^0.8.0;
1510 
1511 /**
1512  * @dev Contract module that helps prevent reentrant calls to a function.
1513  *
1514  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1515  * available, which can be applied to functions to make sure there are no nested
1516  * (reentrant) calls to them.
1517  *
1518  * Note that because there is a single `nonReentrant` guard, functions marked as
1519  * `nonReentrant` may not call one another. This can be worked around by making
1520  * those functions `private`, and then adding `external` `nonReentrant` entry
1521  * points to them.
1522  *
1523  * TIP: If you would like to learn more about reentrancy and alternative ways
1524  * to protect against it, check out our blog post
1525  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1526  */
1527 abstract contract ReentrancyGuard {
1528     // Booleans are more expensive than uint256 or any type that takes up a full
1529     // word because each write operation emits an extra SLOAD to first read the
1530     // slot's contents, replace the bits taken up by the boolean, and then write
1531     // back. This is the compiler's defense against contract upgrades and
1532     // pointer aliasing, and it cannot be disabled.
1533 
1534     // The values being non-zero value makes deployment a bit more expensive,
1535     // but in exchange the refund on every call to nonReentrant will be lower in
1536     // amount. Since refunds are capped to a percentage of the total
1537     // transaction's gas, it is best to keep them low in cases like this one, to
1538     // increase the likelihood of the full refund coming into effect.
1539     uint256 private constant _NOT_ENTERED = 1;
1540     uint256 private constant _ENTERED = 2;
1541 
1542     uint256 private _status;
1543 
1544     constructor() {
1545         _status = _NOT_ENTERED;
1546     }
1547 
1548     /**
1549      * @dev Prevents a contract from calling itself, directly or indirectly.
1550      * Calling a `nonReentrant` function from another `nonReentrant`
1551      * function is not supported. It is possible to prevent this from happening
1552      * by making the `nonReentrant` function external, and making it call a
1553      * `private` function that does the actual work.
1554      */
1555     modifier nonReentrant() {
1556         _nonReentrantBefore();
1557         _;
1558         _nonReentrantAfter();
1559     }
1560 
1561     function _nonReentrantBefore() private {
1562         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1563         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1564 
1565         // Any calls to nonReentrant after this point will fail
1566         _status = _ENTERED;
1567     }
1568 
1569     function _nonReentrantAfter() private {
1570         // By storing the original value once again, a refund is triggered (see
1571         // https://eips.ethereum.org/EIPS/eip-2200)
1572         _status = _NOT_ENTERED;
1573     }
1574 }
1575 
1576 // File: @openzeppelin/contracts/utils/Context.sol
1577 
1578 
1579 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1580 
1581 pragma solidity ^0.8.0;
1582 
1583 /**
1584  * @dev Provides information about the current execution context, including the
1585  * sender of the transaction and its data. While these are generally available
1586  * via msg.sender and msg.data, they should not be accessed in such a direct
1587  * manner, since when dealing with meta-transactions the account sending and
1588  * paying for execution may not be the actual sender (as far as an application
1589  * is concerned).
1590  *
1591  * This contract is only required for intermediate, library-like contracts.
1592  */
1593 abstract contract Context {
1594     function _msgSender() internal view virtual returns (address) {
1595         return msg.sender;
1596     }
1597 
1598     function _msgData() internal view virtual returns (bytes calldata) {
1599         return msg.data;
1600     }
1601 }
1602 
1603 // File: @openzeppelin/contracts/access/Ownable.sol
1604 
1605 
1606 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1607 
1608 pragma solidity ^0.8.0;
1609 
1610 
1611 /**
1612  * @dev Contract module which provides a basic access control mechanism, where
1613  * there is an account (an owner) that can be granted exclusive access to
1614  * specific functions.
1615  *
1616  * By default, the owner account will be the one that deploys the contract. This
1617  * can later be changed with {transferOwnership}.
1618  *
1619  * This module is used through inheritance. It will make available the modifier
1620  * `onlyOwner`, which can be applied to your functions to restrict their use to
1621  * the owner.
1622  */
1623 abstract contract Ownable is Context {
1624     address private _owner;
1625 
1626     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1627 
1628     /**
1629      * @dev Initializes the contract setting the deployer as the initial owner.
1630      */
1631     constructor() {
1632         _transferOwnership(_msgSender());
1633     }
1634 
1635     /**
1636      * @dev Throws if called by any account other than the owner.
1637      */
1638     modifier onlyOwner() {
1639         _checkOwner();
1640         _;
1641     }
1642 
1643     /**
1644      * @dev Returns the address of the current owner.
1645      */
1646     function owner() public view virtual returns (address) {
1647         return _owner;
1648     }
1649 
1650     /**
1651      * @dev Throws if the sender is not the owner.
1652      */
1653     function _checkOwner() internal view virtual {
1654         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1655     }
1656 
1657     /**
1658      * @dev Leaves the contract without owner. It will not be possible to call
1659      * `onlyOwner` functions anymore. Can only be called by the current owner.
1660      *
1661      * NOTE: Renouncing ownership will leave the contract without an owner,
1662      * thereby removing any functionality that is only available to the owner.
1663      */
1664     function renounceOwnership() public virtual onlyOwner {
1665         _transferOwnership(address(0));
1666     }
1667 
1668     /**
1669      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1670      * Can only be called by the current owner.
1671      */
1672     function transferOwnership(address newOwner) public virtual onlyOwner {
1673         require(newOwner != address(0), "Ownable: new owner is the zero address");
1674         _transferOwnership(newOwner);
1675     }
1676 
1677     /**
1678      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1679      * Internal function without access restriction.
1680      */
1681     function _transferOwnership(address newOwner) internal virtual {
1682         address oldOwner = _owner;
1683         _owner = newOwner;
1684         emit OwnershipTransferred(oldOwner, newOwner);
1685     }
1686 }
1687 
1688 // File: contracts/The Noan.sol
1689 
1690 
1691 pragma solidity ^0.8.15;
1692 
1693 
1694 contract FizzHeadz is ERC721A, DefaultOperatorFilterer, Ownable {
1695 
1696     string public baseURI = "";
1697     uint256 public price = 0 ether;
1698     uint256 public maxSupply = 3333;
1699     uint256 public maxPerTransaction = 3; 
1700 
1701     modifier callerIsUser() {
1702         require(tx.origin == msg.sender, "The caller is another contract");
1703         _;
1704     }
1705     constructor () ERC721A("FizzHeadz", "FIZZ") {
1706     }
1707 
1708     function _startTokenId() internal view virtual override returns (uint256) {
1709         return 1;
1710     }
1711 
1712     // Mint
1713     function freeMint(uint256 amount) public payable callerIsUser{
1714         require(amount <= maxPerTransaction, "Over Max Per Transaction!");
1715         require(totalSupply() + amount <= maxSupply, "Sold Out!");
1716 
1717         _safeMint(msg.sender, amount);
1718     }    
1719 
1720     /////////////////////////////
1721     // CONTRACT MANAGEMENT 
1722     /////////////////////////////
1723 
1724     function setPrice(uint256 newPrice) public onlyOwner {
1725         price = newPrice;
1726     }
1727 
1728     function _baseURI() internal view virtual override returns (string memory) {
1729         return baseURI;
1730     }
1731 
1732     function withdraw() public onlyOwner {
1733 		payable(msg.sender).transfer(address(this).balance);
1734         
1735 	}
1736     
1737     function setBaseURI(string memory baseURI_) external onlyOwner {
1738         baseURI = baseURI_;
1739     } 
1740 
1741     /////////////////////////////
1742     // OPENSEA FILTER REGISTRY 
1743     /////////////////////////////
1744 
1745     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1746         super.setApprovalForAll(operator, approved);
1747     }
1748 
1749     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1750         super.approve(operator, tokenId);
1751     }
1752 
1753     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1754         super.transferFrom(from, to, tokenId);
1755     }
1756 
1757     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1758         super.safeTransferFrom(from, to, tokenId);
1759     }
1760 
1761     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1762         public
1763         payable
1764         override
1765         onlyAllowedOperator(from)
1766     {
1767         super.safeTransferFrom(from, to, tokenId, data);
1768     }
1769 }