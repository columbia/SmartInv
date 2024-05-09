1 /**
2           _____                    _____                    _____                    _____          
3          /\    \                  /\    \                  /\    \                  /\    \         
4         /::\    \                /::\    \                /::\    \                /::\    \        
5        /::::\    \              /::::\    \              /::::\    \              /::::\    \       
6       /::::::\    \            /::::::\    \            /::::::\    \            /::::::\    \      
7      /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \     
8     /:::/__\:::\    \        /:::/__\:::\    \        /:::/__\:::\    \        /:::/__\:::\    \    
9    /::::\   \:::\    \      /::::\   \:::\    \      /::::\   \:::\    \      /::::\   \:::\    \   
10   /::::::\   \:::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \  
11  /:::/\:::\   \:::\____\  /:::/\:::\   \:::\    \  /:::/\:::\   \:::\____\  /:::/\:::\   \:::\    \ 
12 /:::/  \:::\   \:::|    |/:::/  \:::\   \:::\____\/:::/  \:::\   \:::|    |/:::/__\:::\   \:::\____\
13 \::/   |::::\  /:::|____|\::/    \:::\  /:::/    /\::/   |::::\  /:::|____|\:::\   \:::\   \::/    /
14  \/____|:::::\/:::/    /  \/____/ \:::\/:::/    /  \/____|:::::\/:::/    /  \:::\   \:::\   \/____/ 
15        |:::::::::/    /            \::::::/    /         |:::::::::/    /    \:::\   \:::\    \     
16        |::|\::::/    /              \::::/    /          |::|\::::/    /      \:::\   \:::\____\    
17        |::| \::/____/               /:::/    /           |::| \::/____/        \:::\   \::/    /    
18        |::|  ~|                    /:::/    /            |::|  ~|               \:::\   \/____/     
19        |::|   |                   /:::/    /             |::|   |                \:::\    \         
20        \::|   |                  /:::/    /              \::|   |                 \:::\____\        
21         \:|   |                  \::/    /                \:|   |                  \::/    /        
22          \|___|                   \/____/                  \|___|                   \/____/         
23                                                                                                     
24 */
25 
26 // SPDX-License-Identifier: MIT
27 
28 pragma solidity ^0.8.13;
29 
30 interface IOperatorFilterRegistry {
31     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
32     function register(address registrant) external;
33     function registerAndSubscribe(address registrant, address subscription) external;
34     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
35     function unregister(address addr) external;
36     function updateOperator(address registrant, address operator, bool filtered) external;
37     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
38     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
39     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
40     function subscribe(address registrant, address registrantToSubscribe) external;
41     function unsubscribe(address registrant, bool copyExistingEntries) external;
42     function subscriptionOf(address addr) external returns (address registrant);
43     function subscribers(address registrant) external returns (address[] memory);
44     function subscriberAt(address registrant, uint256 index) external returns (address);
45     function copyEntriesOf(address registrant, address registrantToCopy) external;
46     function isOperatorFiltered(address registrant, address operator) external returns (bool);
47     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
48     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
49     function filteredOperators(address addr) external returns (address[] memory);
50     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
51     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
52     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
53     function isRegistered(address addr) external returns (bool);
54     function codeHashOf(address addr) external returns (bytes32);
55 }
56 
57 
58 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/OperatorFilterer.sol
59 
60 pragma solidity ^0.8.13;
61 
62 /**
63  * @title  OperatorFilterer
64  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
65  *         registrant's entries in the OperatorFilterRegistry.
66  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
67  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
68  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
69  */
70 
71 abstract contract OperatorFilterer {
72     error OperatorNotAllowed(address operator);
73 
74     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
75         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
76 
77     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
78         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
79         // will not revert, but the contract will need to be registered with the registry once it is deployed in
80         // order for the modifier to filter addresses.
81         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
82             if (subscribe) {
83                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
84             } else {
85                 if (subscriptionOrRegistrantToCopy != address(0)) {
86                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
87                 } else {
88                     OPERATOR_FILTER_REGISTRY.register(address(this));
89                 }
90             }
91         }
92     }
93 
94     modifier onlyAllowedOperator(address from) virtual {
95         // Check registry code length to facilitate testing in environments without a deployed registry.
96         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
97             // Allow spending tokens from addresses with balance
98             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
99             // from an EOA.
100             if (from == msg.sender) {
101                 _;
102                 return;
103             }
104             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
105                 revert OperatorNotAllowed(msg.sender);
106             }
107         }
108         _;
109     }
110 
111     modifier onlyAllowedOperatorApproval(address operator) virtual {
112         // Check registry code length to facilitate testing in environments without a deployed registry.
113         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
114             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
115                 revert OperatorNotAllowed(operator);
116             }
117         }
118         _;
119     }
120 }
121 
122 
123 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/DefaultOperatorFilterer.sol
124 
125 pragma solidity ^0.8.13;
126 
127 /**
128  * @title  DefaultOperatorFilterer
129  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
130  */
131 abstract contract DefaultOperatorFilterer is OperatorFilterer {
132     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
133     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
134 }
135 
136 
137 pragma solidity ^0.8.13;
138 
139 // File: erc721a/contracts/IERC721A.sol
140 
141 // ERC721A Contracts v4.2.3
142 // Creator: Chiru Labs
143 
144 /**
145  * @dev Interface of ERC721A.
146  */
147 interface IERC721A {
148     /**
149      * The caller must own the token or be an approved operator.
150      */
151     error ApprovalCallerNotOwnerNorApproved();
152 
153     /**
154      * The token does not exist.
155      */
156     error ApprovalQueryForNonexistentToken();
157 
158     /**
159      * Cannot query the balance for the zero address.
160      */
161     error BalanceQueryForZeroAddress();
162 
163     /**
164      * Cannot mint to the zero address.
165      */
166     error MintToZeroAddress();
167 
168     /**
169      * The quantity of tokens minted must be more than zero.
170      */
171     error MintZeroQuantity();
172 
173     /**
174      * The token does not exist.
175      */
176     error OwnerQueryForNonexistentToken();
177 
178     /**
179      * The caller must own the token or be an approved operator.
180      */
181     error TransferCallerNotOwnerNorApproved();
182 
183     /**
184      * The token must be owned by `from`.
185      */
186     error TransferFromIncorrectOwner();
187 
188     /**
189      * Cannot safely transfer to a contract that does not implement the
190      * ERC721Receiver interface.
191      */
192     error TransferToNonERC721ReceiverImplementer();
193 
194     /**
195      * Cannot transfer to the zero address.
196      */
197     error TransferToZeroAddress();
198 
199     /**
200      * The token does not exist.
201      */
202     error URIQueryForNonexistentToken();
203 
204     /**
205      * The `quantity` minted with ERC2309 exceeds the safety limit.
206      */
207     error MintERC2309QuantityExceedsLimit();
208 
209     /**
210      * The `extraData` cannot be set on an unintialized ownership slot.
211      */
212     error OwnershipNotInitializedForExtraData();
213 
214     // =============================================================
215     //                            STRUCTS
216     // =============================================================
217 
218     struct TokenOwnership {
219         // The address of the owner.
220         address addr;
221         // Stores the start time of ownership with minimal overhead for tokenomics.
222         uint64 startTimestamp;
223         // Whether the token has been burned.
224         bool burned;
225         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
226         uint24 extraData;
227     }
228 
229     // =============================================================
230     //                         TOKEN COUNTERS
231     // =============================================================
232 
233     /**
234      * @dev Returns the total number of tokens in existence.
235      * Burned tokens will reduce the count.
236      * To get the total number of tokens minted, please see {_totalMinted}.
237      */
238     function totalSupply() external view returns (uint256);
239 
240     // =============================================================
241     //                            IERC165
242     // =============================================================
243 
244     /**
245      * @dev Returns true if this contract implements the interface defined by
246      * `interfaceId`. See the corresponding
247      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
248      * to learn more about how these ids are created.
249      *
250      * This function call must use less than 30000 gas.
251      */
252     function supportsInterface(bytes4 interfaceId) external view returns (bool);
253 
254     // =============================================================
255     //                            IERC721
256     // =============================================================
257 
258     /**
259      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
262 
263     /**
264      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
265      */
266     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
267 
268     /**
269      * @dev Emitted when `owner` enables or disables
270      * (`approved`) `operator` to manage all of its assets.
271      */
272     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
273 
274     /**
275      * @dev Returns the number of tokens in `owner`'s account.
276      */
277     function balanceOf(address owner) external view returns (uint256 balance);
278 
279     /**
280      * @dev Returns the owner of the `tokenId` token.
281      *
282      * Requirements:
283      *
284      * - `tokenId` must exist.
285      */
286     function ownerOf(uint256 tokenId) external view returns (address owner);
287 
288     /**
289      * @dev Safely transfers `tokenId` token from `from` to `to`,
290      * checking first that contract recipients are aware of the ERC721 protocol
291      * to prevent tokens from being forever locked.
292      *
293      * Requirements:
294      *
295      * - `from` cannot be the zero address.
296      * - `to` cannot be the zero address.
297      * - `tokenId` token must exist and be owned by `from`.
298      * - If the caller is not `from`, it must be have been allowed to move
299      * this token by either {approve} or {setApprovalForAll}.
300      * - If `to` refers to a smart contract, it must implement
301      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
302      *
303      * Emits a {Transfer} event.
304      */
305     function safeTransferFrom(
306         address from,
307         address to,
308         uint256 tokenId,
309         bytes calldata data
310     ) external payable;
311 
312     /**
313      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
314      */
315     function safeTransferFrom(
316         address from,
317         address to,
318         uint256 tokenId
319     ) external payable;
320 
321     /**
322      * @dev Transfers `tokenId` from `from` to `to`.
323      *
324      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
325      * whenever possible.
326      *
327      * Requirements:
328      *
329      * - `from` cannot be the zero address.
330      * - `to` cannot be the zero address.
331      * - `tokenId` token must be owned by `from`.
332      * - If the caller is not `from`, it must be approved to move this token
333      * by either {approve} or {setApprovalForAll}.
334      *
335      * Emits a {Transfer} event.
336      */
337     function transferFrom(
338         address from,
339         address to,
340         uint256 tokenId
341     ) external payable;
342 
343     /**
344      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
345      * The approval is cleared when the token is transferred.
346      *
347      * Only a single account can be approved at a time, so approving the
348      * zero address clears previous approvals.
349      *
350      * Requirements:
351      *
352      * - The caller must own the token or be an approved operator.
353      * - `tokenId` must exist.
354      *
355      * Emits an {Approval} event.
356      */
357     function approve(address to, uint256 tokenId) external payable;
358 
359     /**
360      * @dev Approve or remove `operator` as an operator for the caller.
361      * Operators can call {transferFrom} or {safeTransferFrom}
362      * for any token owned by the caller.
363      *
364      * Requirements:
365      *
366      * - The `operator` cannot be the caller.
367      *
368      * Emits an {ApprovalForAll} event.
369      */
370     function setApprovalForAll(address operator, bool _approved) external;
371 
372     /**
373      * @dev Returns the account approved for `tokenId` token.
374      *
375      * Requirements:
376      *
377      * - `tokenId` must exist.
378      */
379     function getApproved(uint256 tokenId) external view returns (address operator);
380 
381     /**
382      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
383      *
384      * See {setApprovalForAll}.
385      */
386     function isApprovedForAll(address owner, address operator) external view returns (bool);
387 
388     // =============================================================
389     //                        IERC721Metadata
390     // =============================================================
391 
392     /**
393      * @dev Returns the token collection name.
394      */
395     function name() external view returns (string memory);
396 
397     /**
398      * @dev Returns the token collection symbol.
399      */
400     function symbol() external view returns (string memory);
401 
402     /**
403      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
404      */
405     function tokenURI(uint256 tokenId) external view returns (string memory);
406 
407     // =============================================================
408     //                           IERC2309
409     // =============================================================
410 
411     /**
412      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
413      * (inclusive) is transferred from `from` to `to`, as defined in the
414      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
415      *
416      * See {_mintERC2309} for more details.
417      */
418     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
419 }
420 
421 
422 // File: erc721a/contracts/ERC721A.sol
423 
424 // ERC721A Contracts v4.2.3
425 // Creator: Chiru Labs
426 
427 pragma solidity ^0.8.4;
428 
429 /**
430  * @dev Interface of ERC721 token receiver.
431  */
432 interface ERC721A__IERC721Receiver {
433     function onERC721Received(
434         address operator,
435         address from,
436         uint256 tokenId,
437         bytes calldata data
438     ) external returns (bytes4);
439 }
440 
441 /**
442  * @title ERC721A
443  *
444  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
445  * Non-Fungible Token Standard, including the Metadata extension.
446  * Optimized for lower gas during batch mints.
447  *
448  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
449  * starting from `_startTokenId()`.
450  *
451  * Assumptions:
452  *
453  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
454  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
455  */
456 contract ERC721A is IERC721A {
457     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
458     struct TokenApprovalRef {
459         address value;
460     }
461 
462     // =============================================================
463     //                           CONSTANTS
464     // =============================================================
465 
466     // Mask of an entry in packed address data.
467     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
468 
469     // The bit position of `numberMinted` in packed address data.
470     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
471 
472     // The bit position of `numberBurned` in packed address data.
473     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
474 
475     // The bit position of `aux` in packed address data.
476     uint256 private constant _BITPOS_AUX = 192;
477 
478     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
479     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
480 
481     // The bit position of `startTimestamp` in packed ownership.
482     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
483 
484     // The bit mask of the `burned` bit in packed ownership.
485     uint256 private constant _BITMASK_BURNED = 1 << 224;
486 
487     // The bit position of the `nextInitialized` bit in packed ownership.
488     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
489 
490     // The bit mask of the `nextInitialized` bit in packed ownership.
491     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
492 
493     // The bit position of `extraData` in packed ownership.
494     uint256 private constant _BITPOS_EXTRA_DATA = 232;
495 
496     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
497     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
498 
499     // The mask of the lower 160 bits for addresses.
500     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
501 
502     // The maximum `quantity` that can be minted with {_mintERC2309}.
503     // This limit is to prevent overflows on the address data entries.
504     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
505     // is required to cause an overflow, which is unrealistic.
506     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
507 
508     // The `Transfer` event signature is given by:
509     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
510     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
511         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
512 
513     // =============================================================
514     //                            STORAGE
515     // =============================================================
516 
517     // The next token ID to be minted.
518     uint256 private _currentIndex;
519 
520     // The number of tokens burned.
521     uint256 private _burnCounter;
522 
523     // Token name
524     string private _name;
525 
526     // Token symbol
527     string private _symbol;
528 
529     // Mapping from token ID to ownership details
530     // An empty struct value does not necessarily mean the token is unowned.
531     // See {_packedOwnershipOf} implementation for details.
532     //
533     // Bits Layout:
534     // - [0..159]   `addr`
535     // - [160..223] `startTimestamp`
536     // - [224]      `burned`
537     // - [225]      `nextInitialized`
538     // - [232..255] `extraData`
539     mapping(uint256 => uint256) private _packedOwnerships;
540 
541     // Mapping owner address to address data.
542     //
543     // Bits Layout:
544     // - [0..63]    `balance`
545     // - [64..127]  `numberMinted`
546     // - [128..191] `numberBurned`
547     // - [192..255] `aux`
548     mapping(address => uint256) private _packedAddressData;
549 
550     // Mapping from token ID to approved address.
551     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
552 
553     // Mapping from owner to operator approvals
554     mapping(address => mapping(address => bool)) private _operatorApprovals;
555 
556     // =============================================================
557     //                          CONSTRUCTOR
558     // =============================================================
559 
560     constructor(string memory name_, string memory symbol_) {
561         _name = name_;
562         _symbol = symbol_;
563         _currentIndex = _startTokenId();
564     }
565 
566     // =============================================================
567     //                   TOKEN COUNTING OPERATIONS
568     // =============================================================
569 
570     /**
571      * @dev Returns the starting token ID.
572      * To change the starting token ID, please override this function.
573      */
574     function _startTokenId() internal view virtual returns (uint256) {
575         return 0;
576     }
577 
578     /**
579      * @dev Returns the next token ID to be minted.
580      */
581     function _nextTokenId() internal view virtual returns (uint256) {
582         return _currentIndex;
583     }
584 
585     /**
586      * @dev Returns the total number of tokens in existence.
587      * Burned tokens will reduce the count.
588      * To get the total number of tokens minted, please see {_totalMinted}.
589      */
590     function totalSupply() public view virtual override returns (uint256) {
591         // Counter underflow is impossible as _burnCounter cannot be incremented
592         // more than `_currentIndex - _startTokenId()` times.
593         unchecked {
594             return _currentIndex - _burnCounter - _startTokenId();
595         }
596     }
597 
598     /**
599      * @dev Returns the total amount of tokens minted in the contract.
600      */
601     function _totalMinted() internal view virtual returns (uint256) {
602         // Counter underflow is impossible as `_currentIndex` does not decrement,
603         // and it is initialized to `_startTokenId()`.
604         unchecked {
605             return _currentIndex - _startTokenId();
606         }
607     }
608 
609     /**
610      * @dev Returns the total number of tokens burned.
611      */
612     function _totalBurned() internal view virtual returns (uint256) {
613         return _burnCounter;
614     }
615 
616     // =============================================================
617     //                    ADDRESS DATA OPERATIONS
618     // =============================================================
619 
620     /**
621      * @dev Returns the number of tokens in `owner`'s account.
622      */
623     function balanceOf(address owner) public view virtual override returns (uint256) {
624         if (owner == address(0)) revert BalanceQueryForZeroAddress();
625         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
626     }
627 
628     /**
629      * Returns the number of tokens minted by `owner`.
630      */
631     function _numberMinted(address owner) internal view returns (uint256) {
632         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
633     }
634 
635     /**
636      * Returns the number of tokens burned by or on behalf of `owner`.
637      */
638     function _numberBurned(address owner) internal view returns (uint256) {
639         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
640     }
641 
642     /**
643      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
644      */
645     function _getAux(address owner) internal view returns (uint64) {
646         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
647     }
648 
649     /**
650      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
651      * If there are multiple variables, please pack them into a uint64.
652      */
653     function _setAux(address owner, uint64 aux) internal virtual {
654         uint256 packed = _packedAddressData[owner];
655         uint256 auxCasted;
656         // Cast `aux` with assembly to avoid redundant masking.
657         assembly {
658             auxCasted := aux
659         }
660         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
661         _packedAddressData[owner] = packed;
662     }
663 
664     // =============================================================
665     //                            IERC165
666     // =============================================================
667 
668     /**
669      * @dev Returns true if this contract implements the interface defined by
670      * `interfaceId`. See the corresponding
671      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
672      * to learn more about how these ids are created.
673      *
674      * This function call must use less than 30000 gas.
675      */
676     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
677         // The interface IDs are constants representing the first 4 bytes
678         // of the XOR of all function selectors in the interface.
679         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
680         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
681         return
682             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
683             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
684             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
685     }
686 
687     // =============================================================
688     //                        IERC721Metadata
689     // =============================================================
690 
691     /**
692      * @dev Returns the token collection name.
693      */
694     function name() public view virtual override returns (string memory) {
695         return _name;
696     }
697 
698     /**
699      * @dev Returns the token collection symbol.
700      */
701     function symbol() public view virtual override returns (string memory) {
702         return _symbol;
703     }
704 
705     /**
706      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
707      */
708     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
709         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
710 
711         string memory baseURI = _baseURI();
712         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
713     }
714 
715     /**
716      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
717      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
718      * by default, it can be overridden in child contracts.
719      */
720     function _baseURI() internal view virtual returns (string memory) {
721         return '';
722     }
723 
724     // =============================================================
725     //                     OWNERSHIPS OPERATIONS
726     // =============================================================
727 
728     /**
729      * @dev Returns the owner of the `tokenId` token.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      */
735     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
736         return address(uint160(_packedOwnershipOf(tokenId)));
737     }
738 
739     /**
740      * @dev Gas spent here starts off proportional to the maximum mint batch size.
741      * It gradually moves to O(1) as tokens get transferred around over time.
742      */
743     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
744         return _unpackedOwnership(_packedOwnershipOf(tokenId));
745     }
746 
747     /**
748      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
749      */
750     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
751         return _unpackedOwnership(_packedOwnerships[index]);
752     }
753 
754     /**
755      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
756      */
757     function _initializeOwnershipAt(uint256 index) internal virtual {
758         if (_packedOwnerships[index] == 0) {
759             _packedOwnerships[index] = _packedOwnershipOf(index);
760         }
761     }
762 
763     /**
764      * Returns the packed ownership data of `tokenId`.
765      */
766     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
767         uint256 curr = tokenId;
768 
769         unchecked {
770             if (_startTokenId() <= curr)
771                 if (curr < _currentIndex) {
772                     uint256 packed = _packedOwnerships[curr];
773                     // If not burned.
774                     if (packed & _BITMASK_BURNED == 0) {
775                         // Invariant:
776                         // There will always be an initialized ownership slot
777                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
778                         // before an unintialized ownership slot
779                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
780                         // Hence, `curr` will not underflow.
781                         //
782                         // We can directly compare the packed value.
783                         // If the address is zero, packed will be zero.
784                         while (packed == 0) {
785                             packed = _packedOwnerships[--curr];
786                         }
787                         return packed;
788                     }
789                 }
790         }
791         revert OwnerQueryForNonexistentToken();
792     }
793 
794     /**
795      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
796      */
797     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
798         ownership.addr = address(uint160(packed));
799         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
800         ownership.burned = packed & _BITMASK_BURNED != 0;
801         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
802     }
803 
804     /**
805      * @dev Packs ownership data into a single uint256.
806      */
807     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
808         assembly {
809             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
810             owner := and(owner, _BITMASK_ADDRESS)
811             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
812             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
813         }
814     }
815 
816     /**
817      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
818      */
819     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
820         // For branchless setting of the `nextInitialized` flag.
821         assembly {
822             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
823             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
824         }
825     }
826 
827     // =============================================================
828     //                      APPROVAL OPERATIONS
829     // =============================================================
830 
831     /**
832      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
833      * The approval is cleared when the token is transferred.
834      *
835      * Only a single account can be approved at a time, so approving the
836      * zero address clears previous approvals.
837      *
838      * Requirements:
839      *
840      * - The caller must own the token or be an approved operator.
841      * - `tokenId` must exist.
842      *
843      * Emits an {Approval} event.
844      */
845     function approve(address to, uint256 tokenId) public payable virtual override {
846         address owner = ownerOf(tokenId);
847 
848         if (_msgSenderERC721A() != owner)
849             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
850                 revert ApprovalCallerNotOwnerNorApproved();
851             }
852 
853         _tokenApprovals[tokenId].value = to;
854         emit Approval(owner, to, tokenId);
855     }
856 
857     /**
858      * @dev Returns the account approved for `tokenId` token.
859      *
860      * Requirements:
861      *
862      * - `tokenId` must exist.
863      */
864     function getApproved(uint256 tokenId) public view virtual override returns (address) {
865         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
866 
867         return _tokenApprovals[tokenId].value;
868     }
869 
870     /**
871      * @dev Approve or remove `operator` as an operator for the caller.
872      * Operators can call {transferFrom} or {safeTransferFrom}
873      * for any token owned by the caller.
874      *
875      * Requirements:
876      *
877      * - The `operator` cannot be the caller.
878      *
879      * Emits an {ApprovalForAll} event.
880      */
881     function setApprovalForAll(address operator, bool approved) public virtual override {
882         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
883         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
884     }
885 
886     /**
887      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
888      *
889      * See {setApprovalForAll}.
890      */
891     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
892         return _operatorApprovals[owner][operator];
893     }
894 
895     /**
896      * @dev Returns whether `tokenId` exists.
897      *
898      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
899      *
900      * Tokens start existing when they are minted. See {_mint}.
901      */
902     function _exists(uint256 tokenId) internal view virtual returns (bool) {
903         return
904             _startTokenId() <= tokenId &&
905             tokenId < _currentIndex && // If within bounds,
906             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
907     }
908 
909     /**
910      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
911      */
912     function _isSenderApprovedOrOwner(
913         address approvedAddress,
914         address owner,
915         address msgSender
916     ) private pure returns (bool result) {
917         assembly {
918             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
919             owner := and(owner, _BITMASK_ADDRESS)
920             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
921             msgSender := and(msgSender, _BITMASK_ADDRESS)
922             // `msgSender == owner || msgSender == approvedAddress`.
923             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
924         }
925     }
926 
927     /**
928      * @dev Returns the storage slot and value for the approved address of `tokenId`.
929      */
930     function _getApprovedSlotAndAddress(uint256 tokenId)
931         private
932         view
933         returns (uint256 approvedAddressSlot, address approvedAddress)
934     {
935         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
936         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
937         assembly {
938             approvedAddressSlot := tokenApproval.slot
939             approvedAddress := sload(approvedAddressSlot)
940         }
941     }
942 
943     // =============================================================
944     //                      TRANSFER OPERATIONS
945     // =============================================================
946 
947     /**
948      * @dev Transfers `tokenId` from `from` to `to`.
949      *
950      * Requirements:
951      *
952      * - `from` cannot be the zero address.
953      * - `to` cannot be the zero address.
954      * - `tokenId` token must be owned by `from`.
955      * - If the caller is not `from`, it must be approved to move this token
956      * by either {approve} or {setApprovalForAll}.
957      *
958      * Emits a {Transfer} event.
959      */
960     function transferFrom(
961         address from,
962         address to,
963         uint256 tokenId
964     ) public payable virtual override {
965         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
966 
967         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
968 
969         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
970 
971         // The nested ifs save around 20+ gas over a compound boolean condition.
972         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
973             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
974 
975         if (to == address(0)) revert TransferToZeroAddress();
976 
977         _beforeTokenTransfers(from, to, tokenId, 1);
978 
979         // Clear approvals from the previous owner.
980         assembly {
981             if approvedAddress {
982                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
983                 sstore(approvedAddressSlot, 0)
984             }
985         }
986 
987         // Underflow of the sender's balance is impossible because we check for
988         // ownership above and the recipient's balance can't realistically overflow.
989         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
990         unchecked {
991             // We can directly increment and decrement the balances.
992             --_packedAddressData[from]; // Updates: `balance -= 1`.
993             ++_packedAddressData[to]; // Updates: `balance += 1`.
994 
995             // Updates:
996             // - `address` to the next owner.
997             // - `startTimestamp` to the timestamp of transfering.
998             // - `burned` to `false`.
999             // - `nextInitialized` to `true`.
1000             _packedOwnerships[tokenId] = _packOwnershipData(
1001                 to,
1002                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1003             );
1004 
1005             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1006             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1007                 uint256 nextTokenId = tokenId + 1;
1008                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1009                 if (_packedOwnerships[nextTokenId] == 0) {
1010                     // If the next slot is within bounds.
1011                     if (nextTokenId != _currentIndex) {
1012                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1013                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1014                     }
1015                 }
1016             }
1017         }
1018 
1019         emit Transfer(from, to, tokenId);
1020         _afterTokenTransfers(from, to, tokenId, 1);
1021     }
1022 
1023     /**
1024      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public payable virtual override {
1031         safeTransferFrom(from, to, tokenId, '');
1032     }
1033 
1034     /**
1035      * @dev Safely transfers `tokenId` token from `from` to `to`.
1036      *
1037      * Requirements:
1038      *
1039      * - `from` cannot be the zero address.
1040      * - `to` cannot be the zero address.
1041      * - `tokenId` token must exist and be owned by `from`.
1042      * - If the caller is not `from`, it must be approved to move this token
1043      * by either {approve} or {setApprovalForAll}.
1044      * - If `to` refers to a smart contract, it must implement
1045      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) public payable virtual override {
1055         transferFrom(from, to, tokenId);
1056         if (to.code.length != 0)
1057             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1058                 revert TransferToNonERC721ReceiverImplementer();
1059             }
1060     }
1061 
1062     /**
1063      * @dev Hook that is called before a set of serially-ordered token IDs
1064      * are about to be transferred. This includes minting.
1065      * And also called before burning one token.
1066      *
1067      * `startTokenId` - the first token ID to be transferred.
1068      * `quantity` - the amount to be transferred.
1069      *
1070      * Calling conditions:
1071      *
1072      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1073      * transferred to `to`.
1074      * - When `from` is zero, `tokenId` will be minted for `to`.
1075      * - When `to` is zero, `tokenId` will be burned by `from`.
1076      * - `from` and `to` are never both zero.
1077      */
1078     function _beforeTokenTransfers(
1079         address from,
1080         address to,
1081         uint256 startTokenId,
1082         uint256 quantity
1083     ) internal virtual {}
1084 
1085     /**
1086      * @dev Hook that is called after a set of serially-ordered token IDs
1087      * have been transferred. This includes minting.
1088      * And also called after one token has been burned.
1089      *
1090      * `startTokenId` - the first token ID to be transferred.
1091      * `quantity` - the amount to be transferred.
1092      *
1093      * Calling conditions:
1094      *
1095      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1096      * transferred to `to`.
1097      * - When `from` is zero, `tokenId` has been minted for `to`.
1098      * - When `to` is zero, `tokenId` has been burned by `from`.
1099      * - `from` and `to` are never both zero.
1100      */
1101     function _afterTokenTransfers(
1102         address from,
1103         address to,
1104         uint256 startTokenId,
1105         uint256 quantity
1106     ) internal virtual {}
1107 
1108     /**
1109      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1110      *
1111      * `from` - Previous owner of the given token ID.
1112      * `to` - Target address that will receive the token.
1113      * `tokenId` - Token ID to be transferred.
1114      * `_data` - Optional data to send along with the call.
1115      *
1116      * Returns whether the call correctly returned the expected magic value.
1117      */
1118     function _checkContractOnERC721Received(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) private returns (bool) {
1124         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1125             bytes4 retval
1126         ) {
1127             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1128         } catch (bytes memory reason) {
1129             if (reason.length == 0) {
1130                 revert TransferToNonERC721ReceiverImplementer();
1131             } else {
1132                 assembly {
1133                     revert(add(32, reason), mload(reason))
1134                 }
1135             }
1136         }
1137     }
1138 
1139     // =============================================================
1140     //                        MINT OPERATIONS
1141     // =============================================================
1142 
1143     /**
1144      * @dev Mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * Emits a {Transfer} event for each mint.
1152      */
1153     function _mint(address to, uint256 quantity) internal virtual {
1154         uint256 startTokenId = _currentIndex;
1155         if (quantity == 0) revert MintZeroQuantity();
1156 
1157         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1158 
1159         // Overflows are incredibly unrealistic.
1160         // `balance` and `numberMinted` have a maximum limit of 2**64.
1161         // `tokenId` has a maximum limit of 2**256.
1162         unchecked {
1163             // Updates:
1164             // - `balance += quantity`.
1165             // - `numberMinted += quantity`.
1166             //
1167             // We can directly add to the `balance` and `numberMinted`.
1168             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1169 
1170             // Updates:
1171             // - `address` to the owner.
1172             // - `startTimestamp` to the timestamp of minting.
1173             // - `burned` to `false`.
1174             // - `nextInitialized` to `quantity == 1`.
1175             _packedOwnerships[startTokenId] = _packOwnershipData(
1176                 to,
1177                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1178             );
1179 
1180             uint256 toMasked;
1181             uint256 end = startTokenId + quantity;
1182 
1183             // Use assembly to loop and emit the `Transfer` event for gas savings.
1184             // The duplicated `log4` removes an extra check and reduces stack juggling.
1185             // The assembly, together with the surrounding Solidity code, have been
1186             // delicately arranged to nudge the compiler into producing optimized opcodes.
1187             assembly {
1188                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1189                 toMasked := and(to, _BITMASK_ADDRESS)
1190                 // Emit the `Transfer` event.
1191                 log4(
1192                     0, // Start of data (0, since no data).
1193                     0, // End of data (0, since no data).
1194                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1195                     0, // `address(0)`.
1196                     toMasked, // `to`.
1197                     startTokenId // `tokenId`.
1198                 )
1199 
1200                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1201                 // that overflows uint256 will make the loop run out of gas.
1202                 // The compiler will optimize the `iszero` away for performance.
1203                 for {
1204                     let tokenId := add(startTokenId, 1)
1205                 } iszero(eq(tokenId, end)) {
1206                     tokenId := add(tokenId, 1)
1207                 } {
1208                     // Emit the `Transfer` event. Similar to above.
1209                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1210                 }
1211             }
1212             if (toMasked == 0) revert MintToZeroAddress();
1213 
1214             _currentIndex = end;
1215         }
1216         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1217     }
1218 
1219     /**
1220      * @dev Mints `quantity` tokens and transfers them to `to`.
1221      *
1222      * This function is intended for efficient minting only during contract creation.
1223      *
1224      * It emits only one {ConsecutiveTransfer} as defined in
1225      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1226      * instead of a sequence of {Transfer} event(s).
1227      *
1228      * Calling this function outside of contract creation WILL make your contract
1229      * non-compliant with the ERC721 standard.
1230      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1231      * {ConsecutiveTransfer} event is only permissible during contract creation.
1232      *
1233      * Requirements:
1234      *
1235      * - `to` cannot be the zero address.
1236      * - `quantity` must be greater than 0.
1237      *
1238      * Emits a {ConsecutiveTransfer} event.
1239      */
1240     function _mintERC2309(address to, uint256 quantity) internal virtual {
1241         uint256 startTokenId = _currentIndex;
1242         if (to == address(0)) revert MintToZeroAddress();
1243         if (quantity == 0) revert MintZeroQuantity();
1244         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1245 
1246         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1247 
1248         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1249         unchecked {
1250             // Updates:
1251             // - `balance += quantity`.
1252             // - `numberMinted += quantity`.
1253             //
1254             // We can directly add to the `balance` and `numberMinted`.
1255             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1256 
1257             // Updates:
1258             // - `address` to the owner.
1259             // - `startTimestamp` to the timestamp of minting.
1260             // - `burned` to `false`.
1261             // - `nextInitialized` to `quantity == 1`.
1262             _packedOwnerships[startTokenId] = _packOwnershipData(
1263                 to,
1264                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1265             );
1266 
1267             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1268 
1269             _currentIndex = startTokenId + quantity;
1270         }
1271         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1272     }
1273 
1274     /**
1275      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1276      *
1277      * Requirements:
1278      *
1279      * - If `to` refers to a smart contract, it must implement
1280      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1281      * - `quantity` must be greater than 0.
1282      *
1283      * See {_mint}.
1284      *
1285      * Emits a {Transfer} event for each mint.
1286      */
1287     function _safeMint(
1288         address to,
1289         uint256 quantity,
1290         bytes memory _data
1291     ) internal virtual {
1292         _mint(to, quantity);
1293 
1294         unchecked {
1295             if (to.code.length != 0) {
1296                 uint256 end = _currentIndex;
1297                 uint256 index = end - quantity;
1298                 do {
1299                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1300                         revert TransferToNonERC721ReceiverImplementer();
1301                     }
1302                 } while (index < end);
1303                 // Reentrancy protection.
1304                 if (_currentIndex != end) revert();
1305             }
1306         }
1307     }
1308 
1309     /**
1310      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1311      */
1312     function _safeMint(address to, uint256 quantity) internal virtual {
1313         _safeMint(to, quantity, '');
1314     }
1315 
1316     // =============================================================
1317     //                        BURN OPERATIONS
1318     // =============================================================
1319 
1320     /**
1321      * @dev Equivalent to `_burn(tokenId, false)`.
1322      */
1323     function _burn(uint256 tokenId) internal virtual {
1324         _burn(tokenId, false);
1325     }
1326 
1327     /**
1328      * @dev Destroys `tokenId`.
1329      * The approval is cleared when the token is burned.
1330      *
1331      * Requirements:
1332      *
1333      * - `tokenId` must exist.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1338         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1339 
1340         address from = address(uint160(prevOwnershipPacked));
1341 
1342         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1343 
1344         if (approvalCheck) {
1345             // The nested ifs save around 20+ gas over a compound boolean condition.
1346             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1347                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1348         }
1349 
1350         _beforeTokenTransfers(from, address(0), tokenId, 1);
1351 
1352         // Clear approvals from the previous owner.
1353         assembly {
1354             if approvedAddress {
1355                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1356                 sstore(approvedAddressSlot, 0)
1357             }
1358         }
1359 
1360         // Underflow of the sender's balance is impossible because we check for
1361         // ownership above and the recipient's balance can't realistically overflow.
1362         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1363         unchecked {
1364             // Updates:
1365             // - `balance -= 1`.
1366             // - `numberBurned += 1`.
1367             //
1368             // We can directly decrement the balance, and increment the number burned.
1369             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1370             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1371 
1372             // Updates:
1373             // - `address` to the last owner.
1374             // - `startTimestamp` to the timestamp of burning.
1375             // - `burned` to `true`.
1376             // - `nextInitialized` to `true`.
1377             _packedOwnerships[tokenId] = _packOwnershipData(
1378                 from,
1379                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1380             );
1381 
1382             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1383             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1384                 uint256 nextTokenId = tokenId + 1;
1385                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1386                 if (_packedOwnerships[nextTokenId] == 0) {
1387                     // If the next slot is within bounds.
1388                     if (nextTokenId != _currentIndex) {
1389                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1390                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1391                     }
1392                 }
1393             }
1394         }
1395 
1396         emit Transfer(from, address(0), tokenId);
1397         _afterTokenTransfers(from, address(0), tokenId, 1);
1398 
1399         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1400         unchecked {
1401             _burnCounter++;
1402         }
1403     }
1404 
1405     // =============================================================
1406     //                     EXTRA DATA OPERATIONS
1407     // =============================================================
1408 
1409     /**
1410      * @dev Directly sets the extra data for the ownership data `index`.
1411      */
1412     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1413         uint256 packed = _packedOwnerships[index];
1414         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1415         uint256 extraDataCasted;
1416         // Cast `extraData` with assembly to avoid redundant masking.
1417         assembly {
1418             extraDataCasted := extraData
1419         }
1420         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1421         _packedOwnerships[index] = packed;
1422     }
1423 
1424     /**
1425      * @dev Called during each token transfer to set the 24bit `extraData` field.
1426      * Intended to be overridden by the cosumer contract.
1427      *
1428      * `previousExtraData` - the value of `extraData` before transfer.
1429      *
1430      * Calling conditions:
1431      *
1432      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1433      * transferred to `to`.
1434      * - When `from` is zero, `tokenId` will be minted for `to`.
1435      * - When `to` is zero, `tokenId` will be burned by `from`.
1436      * - `from` and `to` are never both zero.
1437      */
1438     function _extraData(
1439         address from,
1440         address to,
1441         uint24 previousExtraData
1442     ) internal view virtual returns (uint24) {}
1443 
1444     /**
1445      * @dev Returns the next extra data for the packed ownership data.
1446      * The returned result is shifted into position.
1447      */
1448     function _nextExtraData(
1449         address from,
1450         address to,
1451         uint256 prevOwnershipPacked
1452     ) private view returns (uint256) {
1453         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1454         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1455     }
1456 
1457     // =============================================================
1458     //                       OTHER OPERATIONS
1459     // =============================================================
1460 
1461     /**
1462      * @dev Returns the message sender (defaults to `msg.sender`).
1463      *
1464      * If you are writing GSN compatible contracts, you need to override this function.
1465      */
1466     function _msgSenderERC721A() internal view virtual returns (address) {
1467         return msg.sender;
1468     }
1469 
1470     /**
1471      * @dev Converts a uint256 to its ASCII string decimal representation.
1472      */
1473     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1474         assembly {
1475             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1476             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1477             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1478             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1479             let m := add(mload(0x40), 0xa0)
1480             // Update the free memory pointer to allocate.
1481             mstore(0x40, m)
1482             // Assign the `str` to the end.
1483             str := sub(m, 0x20)
1484             // Zeroize the slot after the string.
1485             mstore(str, 0)
1486 
1487             // Cache the end of the memory to calculate the length later.
1488             let end := str
1489 
1490             // We write the string from rightmost digit to leftmost digit.
1491             // The following is essentially a do-while loop that also handles the zero case.
1492             // prettier-ignore
1493             for { let temp := value } 1 {} {
1494                 str := sub(str, 1)
1495                 // Write the character to the pointer.
1496                 // The ASCII index of the '0' character is 48.
1497                 mstore8(str, add(48, mod(temp, 10)))
1498                 // Keep dividing `temp` until zero.
1499                 temp := div(temp, 10)
1500                 // prettier-ignore
1501                 if iszero(temp) { break }
1502             }
1503 
1504             let length := sub(end, str)
1505             // Move the pointer 32 bytes leftwards to make room for the length.
1506             str := sub(str, 0x20)
1507             // Store the length.
1508             mstore(str, length)
1509         }
1510     }
1511 }
1512 
1513 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1514 
1515 
1516 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1517 
1518 pragma solidity ^0.8.0;
1519 
1520 /**
1521  * @dev Contract module that helps prevent reentrant calls to a function.
1522  *
1523  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1524  * available, which can be applied to functions to make sure there are no nested
1525  * (reentrant) calls to them.
1526  *
1527  * Note that because there is a single `nonReentrant` guard, functions marked as
1528  * `nonReentrant` may not call one another. This can be worked around by making
1529  * those functions `private`, and then adding `external` `nonReentrant` entry
1530  * points to them.
1531  *
1532  * TIP: If you would like to learn more about reentrancy and alternative ways
1533  * to protect against it, check out our blog post
1534  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1535  */
1536 abstract contract ReentrancyGuard {
1537     // Booleans are more expensive than uint256 or any type that takes up a full
1538     // word because each write operation emits an extra SLOAD to first read the
1539     // slot's contents, replace the bits taken up by the boolean, and then write
1540     // back. This is the compiler's defense against contract upgrades and
1541     // pointer aliasing, and it cannot be disabled.
1542 
1543     // The values being non-zero value makes deployment a bit more expensive,
1544     // but in exchange the refund on every call to nonReentrant will be lower in
1545     // amount. Since refunds are capped to a percentage of the total
1546     // transaction's gas, it is best to keep them low in cases like this one, to
1547     // increase the likelihood of the full refund coming into effect.
1548     uint256 private constant _NOT_ENTERED = 1;
1549     uint256 private constant _ENTERED = 2;
1550 
1551     uint256 private _status;
1552 
1553     constructor() {
1554         _status = _NOT_ENTERED;
1555     }
1556 
1557     /**
1558      * @dev Prevents a contract from calling itself, directly or indirectly.
1559      * Calling a `nonReentrant` function from another `nonReentrant`
1560      * function is not supported. It is possible to prevent this from happening
1561      * by making the `nonReentrant` function external, and making it call a
1562      * `private` function that does the actual work.
1563      */
1564     modifier nonReentrant() {
1565         _nonReentrantBefore();
1566         _;
1567         _nonReentrantAfter();
1568     }
1569 
1570     function _nonReentrantBefore() private {
1571         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1572         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1573 
1574         // Any calls to nonReentrant after this point will fail
1575         _status = _ENTERED;
1576     }
1577 
1578     function _nonReentrantAfter() private {
1579         // By storing the original value once again, a refund is triggered (see
1580         // https://eips.ethereum.org/EIPS/eip-2200)
1581         _status = _NOT_ENTERED;
1582     }
1583 }
1584 
1585 // File: @openzeppelin/contracts/utils/Context.sol
1586 
1587 
1588 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1589 
1590 pragma solidity ^0.8.0;
1591 
1592 /**
1593  * @dev Provides information about the current execution context, including the
1594  * sender of the transaction and its data. While these are generally available
1595  * via msg.sender and msg.data, they should not be accessed in such a direct
1596  * manner, since when dealing with meta-transactions the account sending and
1597  * paying for execution may not be the actual sender (as far as an application
1598  * is concerned).
1599  *
1600  * This contract is only required for intermediate, library-like contracts.
1601  */
1602 abstract contract Context {
1603     function _msgSender() internal view virtual returns (address) {
1604         return msg.sender;
1605     }
1606 
1607     function _msgData() internal view virtual returns (bytes calldata) {
1608         return msg.data;
1609     }
1610 }
1611 
1612 // File: @openzeppelin/contracts/access/Ownable.sol
1613 
1614 
1615 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1616 
1617 pragma solidity ^0.8.0;
1618 
1619 
1620 /**
1621  * @dev Contract module which provides a basic access control mechanism, where
1622  * there is an account (an owner) that can be granted exclusive access to
1623  * specific functions.
1624  *
1625  * By default, the owner account will be the one that deploys the contract. This
1626  * can later be changed with {transferOwnership}.
1627  *
1628  * This module is used through inheritance. It will make available the modifier
1629  * `onlyOwner`, which can be applied to your functions to restrict their use to
1630  * the owner.
1631  */
1632 abstract contract Ownable is Context {
1633     address private _owner;
1634 
1635     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1636 
1637     /**
1638      * @dev Initializes the contract setting the deployer as the initial owner.
1639      */
1640     constructor() {
1641         _transferOwnership(_msgSender());
1642     }
1643 
1644     /**
1645      * @dev Throws if called by any account other than the owner.
1646      */
1647     modifier onlyOwner() {
1648         _checkOwner();
1649         _;
1650     }
1651 
1652     /**
1653      * @dev Returns the address of the current owner.
1654      */
1655     function owner() public view virtual returns (address) {
1656         return _owner;
1657     }
1658 
1659     /**
1660      * @dev Throws if the sender is not the owner.
1661      */
1662     function _checkOwner() internal view virtual {
1663         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1664     }
1665 
1666     /**
1667      * @dev Leaves the contract without owner. It will not be possible to call
1668      * `onlyOwner` functions anymore. Can only be called by the current owner.
1669      *
1670      * NOTE: Renouncing ownership will leave the contract without an owner,
1671      * thereby removing any functionality that is only available to the owner.
1672      */
1673     function renounceOwnership() public virtual onlyOwner {
1674         _transferOwnership(address(0));
1675     }
1676 
1677     /**
1678      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1679      * Can only be called by the current owner.
1680      */
1681     function transferOwnership(address newOwner) public virtual onlyOwner {
1682         require(newOwner != address(0), "Ownable: new owner is the zero address");
1683         _transferOwnership(newOwner);
1684     }
1685 
1686     /**
1687      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1688      * Internal function without access restriction.
1689      */
1690     function _transferOwnership(address newOwner) internal virtual {
1691         address oldOwner = _owner;
1692         _owner = newOwner;
1693         emit OwnershipTransferred(oldOwner, newOwner);
1694     }
1695 }
1696 
1697 
1698 pragma solidity ^0.8.15;
1699 
1700 contract RARE is ERC721A, DefaultOperatorFilterer, Ownable, ReentrancyGuard {
1701 
1702     string public baseURI = "ipfs://QmRh8njsM2PS1PFG1z9YsWEno21ZaPYEmmyiKp89jrPLXt/";
1703     uint256 public maxRareSupply = 6969;
1704     uint256 public maxRarePerWallet = 20;
1705     uint256 public mintRareCost = 0.002 ether;
1706     bool public isRareSaleActive = false;
1707 
1708     mapping(address => uint) addressToMinted;
1709     mapping(address => bool) freeMintClaimed;
1710 
1711     modifier callerIsUser() {
1712         require(tx.origin == msg.sender, "Rare mint caller is another contract");
1713         _;
1714     }
1715 
1716     constructor () ERC721A("This is Rare", "RARE") {
1717     }
1718 
1719     function _startTokenId() internal view virtual override returns (uint256) {
1720         return 1;
1721     }
1722 
1723     // Public Mint
1724     function mintRare(uint256 mintAmount) public payable callerIsUser nonReentrant {
1725         require(isRareSaleActive, "Rare sale isn't active");
1726         require(addressToMinted[msg.sender] + mintAmount <= maxRarePerWallet, "exceeded Rare allocation per wallet");
1727         require(totalSupply() + mintAmount <= maxRareSupply, "Rare is sold out");
1728 
1729         if(freeMintClaimed[msg.sender]) {
1730             require(msg.value >= mintAmount * mintRareCost, "not enough funds for requested Rare");
1731         }
1732         else {
1733             require(msg.value >= (mintAmount - 1) * mintRareCost, "not enough funds for requested Rare");
1734             freeMintClaimed[msg.sender] = true;
1735         }
1736         
1737         addressToMinted[msg.sender] += mintAmount;
1738         _safeMint(msg.sender, mintAmount);
1739     }
1740 
1741     // Reserve Treasury
1742     function reserveRare(uint256 mintAmount) public onlyOwner {
1743         require(totalSupply() + mintAmount <= maxRareSupply, "Rare is sold out");
1744         
1745         _safeMint(msg.sender, mintAmount);
1746     }
1747 
1748     /////////////////////////////
1749     // CONTRACT MANAGEMENT 
1750     /////////////////////////////
1751 
1752     function toggleRareSale() external onlyOwner {
1753         isRareSaleActive = !isRareSaleActive;
1754     }
1755 
1756     function setRareCost(uint256 newRareCost) external onlyOwner {
1757         mintRareCost = newRareCost;
1758     }
1759 
1760     function _baseURI() internal view virtual override returns (string memory) {
1761         return baseURI;
1762     }
1763 
1764     function setBaseURI(string memory baseURI_) external onlyOwner {
1765         baseURI = baseURI_;
1766     } 
1767 
1768     function withdraw() public onlyOwner {
1769 		payable(msg.sender).transfer(address(this).balance);
1770 	}
1771     
1772     /////////////////////////////
1773     // OPENSEA FILTER REGISTRY 
1774     /////////////////////////////
1775 
1776     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1777         super.setApprovalForAll(operator, approved);
1778     }
1779 
1780     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1781         super.approve(operator, tokenId);
1782     }
1783 
1784     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1785         super.transferFrom(from, to, tokenId);
1786     }
1787 
1788     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1789         super.safeTransferFrom(from, to, tokenId);
1790     }
1791 
1792     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1793         public
1794         payable
1795         override
1796         onlyAllowedOperator(from)
1797     {
1798         super.safeTransferFrom(from, to, tokenId, data);
1799     }
1800 }