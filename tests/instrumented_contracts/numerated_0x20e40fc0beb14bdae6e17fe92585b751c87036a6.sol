1 /**
2 
3  Q)qqqq    A)aa   Y)    yy   C)ccc  
4 Q)    qq  A)  aa   Y)  yy   C)   cc 
5 Q)    qq A)    aa   Y)yy   C)       
6 Q)  qq q A)aaaaaa    Y)    C)       
7 Q)   qq  A)    aa    Y)     C)   cc 
8  Q)qqq q A)    aa    Y)      C)ccc  
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity ^0.8.13;
15 
16 interface IOperatorFilterRegistry {
17     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
18     function register(address registrant) external;
19     function registerAndSubscribe(address registrant, address subscription) external;
20     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
21     function unregister(address addr) external;
22     function updateOperator(address registrant, address operator, bool filtered) external;
23     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
24     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
25     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
26     function subscribe(address registrant, address registrantToSubscribe) external;
27     function unsubscribe(address registrant, bool copyExistingEntries) external;
28     function subscriptionOf(address addr) external returns (address registrant);
29     function subscribers(address registrant) external returns (address[] memory);
30     function subscriberAt(address registrant, uint256 index) external returns (address);
31     function copyEntriesOf(address registrant, address registrantToCopy) external;
32     function isOperatorFiltered(address registrant, address operator) external returns (bool);
33     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
34     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
35     function filteredOperators(address addr) external returns (address[] memory);
36     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
37     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
38     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
39     function isRegistered(address addr) external returns (bool);
40     function codeHashOf(address addr) external returns (bytes32);
41 }
42 
43 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/OperatorFilterer.sol
44 
45 pragma solidity ^0.8.13;
46 
47 /**
48  * @title  OperatorFilterer
49  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
50  *         registrant's entries in the OperatorFilterRegistry.
51  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
52  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
53  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
54  */
55 
56 abstract contract OperatorFilterer {
57     error OperatorNotAllowed(address operator);
58 
59     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
60         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
61 
62     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
63         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
64         // will not revert, but the contract will need to be registered with the registry once it is deployed in
65         // order for the modifier to filter addresses.
66         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
67             if (subscribe) {
68                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
69             } else {
70                 if (subscriptionOrRegistrantToCopy != address(0)) {
71                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
72                 } else {
73                     OPERATOR_FILTER_REGISTRY.register(address(this));
74                 }
75             }
76         }
77     }
78 
79     modifier onlyAllowedOperator(address from) virtual {
80         // Check registry code length to facilitate testing in environments without a deployed registry.
81         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
82             // Allow spending tokens from addresses with balance
83             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
84             // from an EOA.
85             if (from == msg.sender) {
86                 _;
87                 return;
88             }
89             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
90                 revert OperatorNotAllowed(msg.sender);
91             }
92         }
93         _;
94     }
95 
96     modifier onlyAllowedOperatorApproval(address operator) virtual {
97         // Check registry code length to facilitate testing in environments without a deployed registry.
98         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
99             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
100                 revert OperatorNotAllowed(operator);
101             }
102         }
103         _;
104     }
105 }
106 
107 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/DefaultOperatorFilterer.sol
108 
109 pragma solidity ^0.8.13;
110 
111 /**
112  * @title  DefaultOperatorFilterer
113  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
114  */
115 abstract contract DefaultOperatorFilterer is OperatorFilterer {
116     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
117     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
118 }
119 
120 pragma solidity ^0.8.13;
121 
122 // File: erc721a/contracts/IERC721A.sol
123 
124 // ERC721A Contracts v4.2.3
125 // Creator: Chiru Labs
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
406 // ERC721A Contracts v4.2.3
407 // Creator: Chiru Labs
408 
409 pragma solidity ^0.8.4;
410 
411 /**
412  * @dev Interface of ERC721 token receiver.
413  */
414 interface ERC721A__IERC721Receiver {
415     function onERC721Received(
416         address operator,
417         address from,
418         uint256 tokenId,
419         bytes calldata data
420     ) external returns (bytes4);
421 }
422 
423 /**
424  * @title ERC721A
425  *
426  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
427  * Non-Fungible Token Standard, including the Metadata extension.
428  * Optimized for lower gas during batch mints.
429  *
430  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
431  * starting from `_startTokenId()`.
432  *
433  * Assumptions:
434  *
435  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
436  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
437  */
438 contract ERC721A is IERC721A {
439     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
440     struct TokenApprovalRef {
441         address value;
442     }
443 
444     // =============================================================
445     //                           CONSTANTS
446     // =============================================================
447 
448     // Mask of an entry in packed address data.
449     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
450 
451     // The bit position of `numberMinted` in packed address data.
452     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
453 
454     // The bit position of `numberBurned` in packed address data.
455     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
456 
457     // The bit position of `aux` in packed address data.
458     uint256 private constant _BITPOS_AUX = 192;
459 
460     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
461     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
462 
463     // The bit position of `startTimestamp` in packed ownership.
464     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
465 
466     // The bit mask of the `burned` bit in packed ownership.
467     uint256 private constant _BITMASK_BURNED = 1 << 224;
468 
469     // The bit position of the `nextInitialized` bit in packed ownership.
470     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
471 
472     // The bit mask of the `nextInitialized` bit in packed ownership.
473     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
474 
475     // The bit position of `extraData` in packed ownership.
476     uint256 private constant _BITPOS_EXTRA_DATA = 232;
477 
478     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
479     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
480 
481     // The mask of the lower 160 bits for addresses.
482     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
483 
484     // The maximum `quantity` that can be minted with {_mintERC2309}.
485     // This limit is to prevent overflows on the address data entries.
486     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
487     // is required to cause an overflow, which is unrealistic.
488     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
489 
490     // The `Transfer` event signature is given by:
491     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
492     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
493         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
494 
495     // =============================================================
496     //                            STORAGE
497     // =============================================================
498 
499     // The next token ID to be minted.
500     uint256 private _currentIndex;
501 
502     // The number of tokens burned.
503     uint256 private _burnCounter;
504 
505     // Token name
506     string private _name;
507 
508     // Token symbol
509     string private _symbol;
510 
511     // Mapping from token ID to ownership details
512     // An empty struct value does not necessarily mean the token is unowned.
513     // See {_packedOwnershipOf} implementation for details.
514     //
515     // Bits Layout:
516     // - [0..159]   `addr`
517     // - [160..223] `startTimestamp`
518     // - [224]      `burned`
519     // - [225]      `nextInitialized`
520     // - [232..255] `extraData`
521     mapping(uint256 => uint256) private _packedOwnerships;
522 
523     // Mapping owner address to address data.
524     //
525     // Bits Layout:
526     // - [0..63]    `balance`
527     // - [64..127]  `numberMinted`
528     // - [128..191] `numberBurned`
529     // - [192..255] `aux`
530     mapping(address => uint256) private _packedAddressData;
531 
532     // Mapping from token ID to approved address.
533     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
534 
535     // Mapping from owner to operator approvals
536     mapping(address => mapping(address => bool)) private _operatorApprovals;
537 
538     // =============================================================
539     //                          CONSTRUCTOR
540     // =============================================================
541 
542     constructor(string memory name_, string memory symbol_) {
543         _name = name_;
544         _symbol = symbol_;
545         _currentIndex = _startTokenId();
546     }
547 
548     // =============================================================
549     //                   TOKEN COUNTING OPERATIONS
550     // =============================================================
551 
552     /**
553      * @dev Returns the starting token ID.
554      * To change the starting token ID, please override this function.
555      */
556     function _startTokenId() internal view virtual returns (uint256) {
557         return 0;
558     }
559 
560     /**
561      * @dev Returns the next token ID to be minted.
562      */
563     function _nextTokenId() internal view virtual returns (uint256) {
564         return _currentIndex;
565     }
566 
567     /**
568      * @dev Returns the total number of tokens in existence.
569      * Burned tokens will reduce the count.
570      * To get the total number of tokens minted, please see {_totalMinted}.
571      */
572     function totalSupply() public view virtual override returns (uint256) {
573         // Counter underflow is impossible as _burnCounter cannot be incremented
574         // more than `_currentIndex - _startTokenId()` times.
575         unchecked {
576             return _currentIndex - _burnCounter - _startTokenId();
577         }
578     }
579 
580     /**
581      * @dev Returns the total amount of tokens minted in the contract.
582      */
583     function _totalMinted() internal view virtual returns (uint256) {
584         // Counter underflow is impossible as `_currentIndex` does not decrement,
585         // and it is initialized to `_startTokenId()`.
586         unchecked {
587             return _currentIndex - _startTokenId();
588         }
589     }
590 
591     /**
592      * @dev Returns the total number of tokens burned.
593      */
594     function _totalBurned() internal view virtual returns (uint256) {
595         return _burnCounter;
596     }
597 
598     // =============================================================
599     //                    ADDRESS DATA OPERATIONS
600     // =============================================================
601 
602     /**
603      * @dev Returns the number of tokens in `owner`'s account.
604      */
605     function balanceOf(address owner) public view virtual override returns (uint256) {
606         if (owner == address(0)) revert BalanceQueryForZeroAddress();
607         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
608     }
609 
610     /**
611      * Returns the number of tokens minted by `owner`.
612      */
613     function _numberMinted(address owner) internal view returns (uint256) {
614         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
615     }
616 
617     /**
618      * Returns the number of tokens burned by or on behalf of `owner`.
619      */
620     function _numberBurned(address owner) internal view returns (uint256) {
621         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
622     }
623 
624     /**
625      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
626      */
627     function _getAux(address owner) internal view returns (uint64) {
628         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
629     }
630 
631     /**
632      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
633      * If there are multiple variables, please pack them into a uint64.
634      */
635     function _setAux(address owner, uint64 aux) internal virtual {
636         uint256 packed = _packedAddressData[owner];
637         uint256 auxCasted;
638         // Cast `aux` with assembly to avoid redundant masking.
639         assembly {
640             auxCasted := aux
641         }
642         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
643         _packedAddressData[owner] = packed;
644     }
645 
646     // =============================================================
647     //                            IERC165
648     // =============================================================
649 
650     /**
651      * @dev Returns true if this contract implements the interface defined by
652      * `interfaceId`. See the corresponding
653      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
654      * to learn more about how these ids are created.
655      *
656      * This function call must use less than 30000 gas.
657      */
658     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
659         // The interface IDs are constants representing the first 4 bytes
660         // of the XOR of all function selectors in the interface.
661         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
662         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
663         return
664             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
665             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
666             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
667     }
668 
669     // =============================================================
670     //                        IERC721Metadata
671     // =============================================================
672 
673     /**
674      * @dev Returns the token collection name.
675      */
676     function name() public view virtual override returns (string memory) {
677         return _name;
678     }
679 
680     /**
681      * @dev Returns the token collection symbol.
682      */
683     function symbol() public view virtual override returns (string memory) {
684         return _symbol;
685     }
686 
687     /**
688      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
689      */
690     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
691         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
692 
693         string memory baseURI = _baseURI();
694         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
695     }
696 
697     /**
698      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
699      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
700      * by default, it can be overridden in child contracts.
701      */
702     function _baseURI() internal view virtual returns (string memory) {
703         return '';
704     }
705 
706     // =============================================================
707     //                     OWNERSHIPS OPERATIONS
708     // =============================================================
709 
710     /**
711      * @dev Returns the owner of the `tokenId` token.
712      *
713      * Requirements:
714      *
715      * - `tokenId` must exist.
716      */
717     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
718         return address(uint160(_packedOwnershipOf(tokenId)));
719     }
720 
721     /**
722      * @dev Gas spent here starts off proportional to the maximum mint batch size.
723      * It gradually moves to O(1) as tokens get transferred around over time.
724      */
725     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
726         return _unpackedOwnership(_packedOwnershipOf(tokenId));
727     }
728 
729     /**
730      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
731      */
732     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
733         return _unpackedOwnership(_packedOwnerships[index]);
734     }
735 
736     /**
737      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
738      */
739     function _initializeOwnershipAt(uint256 index) internal virtual {
740         if (_packedOwnerships[index] == 0) {
741             _packedOwnerships[index] = _packedOwnershipOf(index);
742         }
743     }
744 
745     /**
746      * Returns the packed ownership data of `tokenId`.
747      */
748     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
749         uint256 curr = tokenId;
750 
751         unchecked {
752             if (_startTokenId() <= curr)
753                 if (curr < _currentIndex) {
754                     uint256 packed = _packedOwnerships[curr];
755                     // If not burned.
756                     if (packed & _BITMASK_BURNED == 0) {
757                         // Invariant:
758                         // There will always be an initialized ownership slot
759                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
760                         // before an unintialized ownership slot
761                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
762                         // Hence, `curr` will not underflow.
763                         //
764                         // We can directly compare the packed value.
765                         // If the address is zero, packed will be zero.
766                         while (packed == 0) {
767                             packed = _packedOwnerships[--curr];
768                         }
769                         return packed;
770                     }
771                 }
772         }
773         revert OwnerQueryForNonexistentToken();
774     }
775 
776     /**
777      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
778      */
779     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
780         ownership.addr = address(uint160(packed));
781         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
782         ownership.burned = packed & _BITMASK_BURNED != 0;
783         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
784     }
785 
786     /**
787      * @dev Packs ownership data into a single uint256.
788      */
789     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
790         assembly {
791             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
792             owner := and(owner, _BITMASK_ADDRESS)
793             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
794             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
795         }
796     }
797 
798     /**
799      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
800      */
801     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
802         // For branchless setting of the `nextInitialized` flag.
803         assembly {
804             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
805             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
806         }
807     }
808 
809     // =============================================================
810     //                      APPROVAL OPERATIONS
811     // =============================================================
812 
813     /**
814      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
815      * The approval is cleared when the token is transferred.
816      *
817      * Only a single account can be approved at a time, so approving the
818      * zero address clears previous approvals.
819      *
820      * Requirements:
821      *
822      * - The caller must own the token or be an approved operator.
823      * - `tokenId` must exist.
824      *
825      * Emits an {Approval} event.
826      */
827     function approve(address to, uint256 tokenId) public payable virtual override {
828         address owner = ownerOf(tokenId);
829 
830         if (_msgSenderERC721A() != owner)
831             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
832                 revert ApprovalCallerNotOwnerNorApproved();
833             }
834 
835         _tokenApprovals[tokenId].value = to;
836         emit Approval(owner, to, tokenId);
837     }
838 
839     /**
840      * @dev Returns the account approved for `tokenId` token.
841      *
842      * Requirements:
843      *
844      * - `tokenId` must exist.
845      */
846     function getApproved(uint256 tokenId) public view virtual override returns (address) {
847         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
848 
849         return _tokenApprovals[tokenId].value;
850     }
851 
852     /**
853      * @dev Approve or remove `operator` as an operator for the caller.
854      * Operators can call {transferFrom} or {safeTransferFrom}
855      * for any token owned by the caller.
856      *
857      * Requirements:
858      *
859      * - The `operator` cannot be the caller.
860      *
861      * Emits an {ApprovalForAll} event.
862      */
863     function setApprovalForAll(address operator, bool approved) public virtual override {
864         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
865         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
866     }
867 
868     /**
869      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
870      *
871      * See {setApprovalForAll}.
872      */
873     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
874         return _operatorApprovals[owner][operator];
875     }
876 
877     /**
878      * @dev Returns whether `tokenId` exists.
879      *
880      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
881      *
882      * Tokens start existing when they are minted. See {_mint}.
883      */
884     function _exists(uint256 tokenId) internal view virtual returns (bool) {
885         return
886             _startTokenId() <= tokenId &&
887             tokenId < _currentIndex && // If within bounds,
888             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
889     }
890 
891     /**
892      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
893      */
894     function _isSenderApprovedOrOwner(
895         address approvedAddress,
896         address owner,
897         address msgSender
898     ) private pure returns (bool result) {
899         assembly {
900             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
901             owner := and(owner, _BITMASK_ADDRESS)
902             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
903             msgSender := and(msgSender, _BITMASK_ADDRESS)
904             // `msgSender == owner || msgSender == approvedAddress`.
905             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
906         }
907     }
908 
909     /**
910      * @dev Returns the storage slot and value for the approved address of `tokenId`.
911      */
912     function _getApprovedSlotAndAddress(uint256 tokenId)
913         private
914         view
915         returns (uint256 approvedAddressSlot, address approvedAddress)
916     {
917         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
918         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
919         assembly {
920             approvedAddressSlot := tokenApproval.slot
921             approvedAddress := sload(approvedAddressSlot)
922         }
923     }
924 
925     // =============================================================
926     //                      TRANSFER OPERATIONS
927     // =============================================================
928 
929     /**
930      * @dev Transfers `tokenId` from `from` to `to`.
931      *
932      * Requirements:
933      *
934      * - `from` cannot be the zero address.
935      * - `to` cannot be the zero address.
936      * - `tokenId` token must be owned by `from`.
937      * - If the caller is not `from`, it must be approved to move this token
938      * by either {approve} or {setApprovalForAll}.
939      *
940      * Emits a {Transfer} event.
941      */
942     function transferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public payable virtual override {
947         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
948 
949         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
950 
951         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
952 
953         // The nested ifs save around 20+ gas over a compound boolean condition.
954         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
955             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
956 
957         if (to == address(0)) revert TransferToZeroAddress();
958 
959         _beforeTokenTransfers(from, to, tokenId, 1);
960 
961         // Clear approvals from the previous owner.
962         assembly {
963             if approvedAddress {
964                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
965                 sstore(approvedAddressSlot, 0)
966             }
967         }
968 
969         // Underflow of the sender's balance is impossible because we check for
970         // ownership above and the recipient's balance can't realistically overflow.
971         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
972         unchecked {
973             // We can directly increment and decrement the balances.
974             --_packedAddressData[from]; // Updates: `balance -= 1`.
975             ++_packedAddressData[to]; // Updates: `balance += 1`.
976 
977             // Updates:
978             // - `address` to the next owner.
979             // - `startTimestamp` to the timestamp of transfering.
980             // - `burned` to `false`.
981             // - `nextInitialized` to `true`.
982             _packedOwnerships[tokenId] = _packOwnershipData(
983                 to,
984                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
985             );
986 
987             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
988             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
989                 uint256 nextTokenId = tokenId + 1;
990                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
991                 if (_packedOwnerships[nextTokenId] == 0) {
992                     // If the next slot is within bounds.
993                     if (nextTokenId != _currentIndex) {
994                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
995                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
996                     }
997                 }
998             }
999         }
1000 
1001         emit Transfer(from, to, tokenId);
1002         _afterTokenTransfers(from, to, tokenId, 1);
1003     }
1004 
1005     /**
1006      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public payable virtual override {
1013         safeTransferFrom(from, to, tokenId, '');
1014     }
1015 
1016     /**
1017      * @dev Safely transfers `tokenId` token from `from` to `to`.
1018      *
1019      * Requirements:
1020      *
1021      * - `from` cannot be the zero address.
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must exist and be owned by `from`.
1024      * - If the caller is not `from`, it must be approved to move this token
1025      * by either {approve} or {setApprovalForAll}.
1026      * - If `to` refers to a smart contract, it must implement
1027      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function safeTransferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) public payable virtual override {
1037         transferFrom(from, to, tokenId);
1038         if (to.code.length != 0)
1039             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1040                 revert TransferToNonERC721ReceiverImplementer();
1041             }
1042     }
1043 
1044     /**
1045      * @dev Hook that is called before a set of serially-ordered token IDs
1046      * are about to be transferred. This includes minting.
1047      * And also called before burning one token.
1048      *
1049      * `startTokenId` - the first token ID to be transferred.
1050      * `quantity` - the amount to be transferred.
1051      *
1052      * Calling conditions:
1053      *
1054      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1055      * transferred to `to`.
1056      * - When `from` is zero, `tokenId` will be minted for `to`.
1057      * - When `to` is zero, `tokenId` will be burned by `from`.
1058      * - `from` and `to` are never both zero.
1059      */
1060     function _beforeTokenTransfers(
1061         address from,
1062         address to,
1063         uint256 startTokenId,
1064         uint256 quantity
1065     ) internal virtual {}
1066 
1067     /**
1068      * @dev Hook that is called after a set of serially-ordered token IDs
1069      * have been transferred. This includes minting.
1070      * And also called after one token has been burned.
1071      *
1072      * `startTokenId` - the first token ID to be transferred.
1073      * `quantity` - the amount to be transferred.
1074      *
1075      * Calling conditions:
1076      *
1077      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1078      * transferred to `to`.
1079      * - When `from` is zero, `tokenId` has been minted for `to`.
1080      * - When `to` is zero, `tokenId` has been burned by `from`.
1081      * - `from` and `to` are never both zero.
1082      */
1083     function _afterTokenTransfers(
1084         address from,
1085         address to,
1086         uint256 startTokenId,
1087         uint256 quantity
1088     ) internal virtual {}
1089 
1090     /**
1091      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1092      *
1093      * `from` - Previous owner of the given token ID.
1094      * `to` - Target address that will receive the token.
1095      * `tokenId` - Token ID to be transferred.
1096      * `_data` - Optional data to send along with the call.
1097      *
1098      * Returns whether the call correctly returned the expected magic value.
1099      */
1100     function _checkContractOnERC721Received(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) private returns (bool) {
1106         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1107             bytes4 retval
1108         ) {
1109             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1110         } catch (bytes memory reason) {
1111             if (reason.length == 0) {
1112                 revert TransferToNonERC721ReceiverImplementer();
1113             } else {
1114                 assembly {
1115                     revert(add(32, reason), mload(reason))
1116                 }
1117             }
1118         }
1119     }
1120 
1121     // =============================================================
1122     //                        MINT OPERATIONS
1123     // =============================================================
1124 
1125     /**
1126      * @dev Mints `quantity` tokens and transfers them to `to`.
1127      *
1128      * Requirements:
1129      *
1130      * - `to` cannot be the zero address.
1131      * - `quantity` must be greater than 0.
1132      *
1133      * Emits a {Transfer} event for each mint.
1134      */
1135     function _mint(address to, uint256 quantity) internal virtual {
1136         uint256 startTokenId = _currentIndex;
1137         if (quantity == 0) revert MintZeroQuantity();
1138 
1139         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1140 
1141         // Overflows are incredibly unrealistic.
1142         // `balance` and `numberMinted` have a maximum limit of 2**64.
1143         // `tokenId` has a maximum limit of 2**256.
1144         unchecked {
1145             // Updates:
1146             // - `balance += quantity`.
1147             // - `numberMinted += quantity`.
1148             //
1149             // We can directly add to the `balance` and `numberMinted`.
1150             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1151 
1152             // Updates:
1153             // - `address` to the owner.
1154             // - `startTimestamp` to the timestamp of minting.
1155             // - `burned` to `false`.
1156             // - `nextInitialized` to `quantity == 1`.
1157             _packedOwnerships[startTokenId] = _packOwnershipData(
1158                 to,
1159                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1160             );
1161 
1162             uint256 toMasked;
1163             uint256 end = startTokenId + quantity;
1164 
1165             // Use assembly to loop and emit the `Transfer` event for gas savings.
1166             // The duplicated `log4` removes an extra check and reduces stack juggling.
1167             // The assembly, together with the surrounding Solidity code, have been
1168             // delicately arranged to nudge the compiler into producing optimized opcodes.
1169             assembly {
1170                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1171                 toMasked := and(to, _BITMASK_ADDRESS)
1172                 // Emit the `Transfer` event.
1173                 log4(
1174                     0, // Start of data (0, since no data).
1175                     0, // End of data (0, since no data).
1176                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1177                     0, // `address(0)`.
1178                     toMasked, // `to`.
1179                     startTokenId // `tokenId`.
1180                 )
1181 
1182                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1183                 // that overflows uint256 will make the loop run out of gas.
1184                 // The compiler will optimize the `iszero` away for performance.
1185                 for {
1186                     let tokenId := add(startTokenId, 1)
1187                 } iszero(eq(tokenId, end)) {
1188                     tokenId := add(tokenId, 1)
1189                 } {
1190                     // Emit the `Transfer` event. Similar to above.
1191                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1192                 }
1193             }
1194             if (toMasked == 0) revert MintToZeroAddress();
1195 
1196             _currentIndex = end;
1197         }
1198         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1199     }
1200 
1201     /**
1202      * @dev Mints `quantity` tokens and transfers them to `to`.
1203      *
1204      * This function is intended for efficient minting only during contract creation.
1205      *
1206      * It emits only one {ConsecutiveTransfer} as defined in
1207      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1208      * instead of a sequence of {Transfer} event(s).
1209      *
1210      * Calling this function outside of contract creation WILL make your contract
1211      * non-compliant with the ERC721 standard.
1212      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1213      * {ConsecutiveTransfer} event is only permissible during contract creation.
1214      *
1215      * Requirements:
1216      *
1217      * - `to` cannot be the zero address.
1218      * - `quantity` must be greater than 0.
1219      *
1220      * Emits a {ConsecutiveTransfer} event.
1221      */
1222     function _mintERC2309(address to, uint256 quantity) internal virtual {
1223         uint256 startTokenId = _currentIndex;
1224         if (to == address(0)) revert MintToZeroAddress();
1225         if (quantity == 0) revert MintZeroQuantity();
1226         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1227 
1228         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1229 
1230         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1231         unchecked {
1232             // Updates:
1233             // - `balance += quantity`.
1234             // - `numberMinted += quantity`.
1235             //
1236             // We can directly add to the `balance` and `numberMinted`.
1237             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1238 
1239             // Updates:
1240             // - `address` to the owner.
1241             // - `startTimestamp` to the timestamp of minting.
1242             // - `burned` to `false`.
1243             // - `nextInitialized` to `quantity == 1`.
1244             _packedOwnerships[startTokenId] = _packOwnershipData(
1245                 to,
1246                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1247             );
1248 
1249             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1250 
1251             _currentIndex = startTokenId + quantity;
1252         }
1253         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1254     }
1255 
1256     /**
1257      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1258      *
1259      * Requirements:
1260      *
1261      * - If `to` refers to a smart contract, it must implement
1262      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1263      * - `quantity` must be greater than 0.
1264      *
1265      * See {_mint}.
1266      *
1267      * Emits a {Transfer} event for each mint.
1268      */
1269     function _safeMint(
1270         address to,
1271         uint256 quantity,
1272         bytes memory _data
1273     ) internal virtual {
1274         _mint(to, quantity);
1275 
1276         unchecked {
1277             if (to.code.length != 0) {
1278                 uint256 end = _currentIndex;
1279                 uint256 index = end - quantity;
1280                 do {
1281                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1282                         revert TransferToNonERC721ReceiverImplementer();
1283                     }
1284                 } while (index < end);
1285                 // Reentrancy protection.
1286                 if (_currentIndex != end) revert();
1287             }
1288         }
1289     }
1290 
1291     /**
1292      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1293      */
1294     function _safeMint(address to, uint256 quantity) internal virtual {
1295         _safeMint(to, quantity, '');
1296     }
1297 
1298     // =============================================================
1299     //                        BURN OPERATIONS
1300     // =============================================================
1301 
1302     /**
1303      * @dev Equivalent to `_burn(tokenId, false)`.
1304      */
1305     function _burn(uint256 tokenId) internal virtual {
1306         _burn(tokenId, false);
1307     }
1308 
1309     /**
1310      * @dev Destroys `tokenId`.
1311      * The approval is cleared when the token is burned.
1312      *
1313      * Requirements:
1314      *
1315      * - `tokenId` must exist.
1316      *
1317      * Emits a {Transfer} event.
1318      */
1319     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1320         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1321 
1322         address from = address(uint160(prevOwnershipPacked));
1323 
1324         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1325 
1326         if (approvalCheck) {
1327             // The nested ifs save around 20+ gas over a compound boolean condition.
1328             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1329                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1330         }
1331 
1332         _beforeTokenTransfers(from, address(0), tokenId, 1);
1333 
1334         // Clear approvals from the previous owner.
1335         assembly {
1336             if approvedAddress {
1337                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1338                 sstore(approvedAddressSlot, 0)
1339             }
1340         }
1341 
1342         // Underflow of the sender's balance is impossible because we check for
1343         // ownership above and the recipient's balance can't realistically overflow.
1344         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1345         unchecked {
1346             // Updates:
1347             // - `balance -= 1`.
1348             // - `numberBurned += 1`.
1349             //
1350             // We can directly decrement the balance, and increment the number burned.
1351             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1352             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1353 
1354             // Updates:
1355             // - `address` to the last owner.
1356             // - `startTimestamp` to the timestamp of burning.
1357             // - `burned` to `true`.
1358             // - `nextInitialized` to `true`.
1359             _packedOwnerships[tokenId] = _packOwnershipData(
1360                 from,
1361                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1362             );
1363 
1364             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1365             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1366                 uint256 nextTokenId = tokenId + 1;
1367                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1368                 if (_packedOwnerships[nextTokenId] == 0) {
1369                     // If the next slot is within bounds.
1370                     if (nextTokenId != _currentIndex) {
1371                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1372                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1373                     }
1374                 }
1375             }
1376         }
1377 
1378         emit Transfer(from, address(0), tokenId);
1379         _afterTokenTransfers(from, address(0), tokenId, 1);
1380 
1381         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1382         unchecked {
1383             _burnCounter++;
1384         }
1385     }
1386 
1387     // =============================================================
1388     //                     EXTRA DATA OPERATIONS
1389     // =============================================================
1390 
1391     /**
1392      * @dev Directly sets the extra data for the ownership data `index`.
1393      */
1394     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1395         uint256 packed = _packedOwnerships[index];
1396         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1397         uint256 extraDataCasted;
1398         // Cast `extraData` with assembly to avoid redundant masking.
1399         assembly {
1400             extraDataCasted := extraData
1401         }
1402         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1403         _packedOwnerships[index] = packed;
1404     }
1405 
1406     /**
1407      * @dev Called during each token transfer to set the 24bit `extraData` field.
1408      * Intended to be overridden by the cosumer contract.
1409      *
1410      * `previousExtraData` - the value of `extraData` before transfer.
1411      *
1412      * Calling conditions:
1413      *
1414      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1415      * transferred to `to`.
1416      * - When `from` is zero, `tokenId` will be minted for `to`.
1417      * - When `to` is zero, `tokenId` will be burned by `from`.
1418      * - `from` and `to` are never both zero.
1419      */
1420     function _extraData(
1421         address from,
1422         address to,
1423         uint24 previousExtraData
1424     ) internal view virtual returns (uint24) {}
1425 
1426     /**
1427      * @dev Returns the next extra data for the packed ownership data.
1428      * The returned result is shifted into position.
1429      */
1430     function _nextExtraData(
1431         address from,
1432         address to,
1433         uint256 prevOwnershipPacked
1434     ) private view returns (uint256) {
1435         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1436         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1437     }
1438 
1439     // =============================================================
1440     //                       OTHER OPERATIONS
1441     // =============================================================
1442 
1443     /**
1444      * @dev Returns the message sender (defaults to `msg.sender`).
1445      *
1446      * If you are writing GSN compatible contracts, you need to override this function.
1447      */
1448     function _msgSenderERC721A() internal view virtual returns (address) {
1449         return msg.sender;
1450     }
1451 
1452     /**
1453      * @dev Converts a uint256 to its ASCII string decimal representation.
1454      */
1455     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1456         assembly {
1457             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1458             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1459             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1460             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1461             let m := add(mload(0x40), 0xa0)
1462             // Update the free memory pointer to allocate.
1463             mstore(0x40, m)
1464             // Assign the `str` to the end.
1465             str := sub(m, 0x20)
1466             // Zeroize the slot after the string.
1467             mstore(str, 0)
1468 
1469             // Cache the end of the memory to calculate the length later.
1470             let end := str
1471 
1472             // We write the string from rightmost digit to leftmost digit.
1473             // The following is essentially a do-while loop that also handles the zero case.
1474             // prettier-ignore
1475             for { let temp := value } 1 {} {
1476                 str := sub(str, 1)
1477                 // Write the character to the pointer.
1478                 // The ASCII index of the '0' character is 48.
1479                 mstore8(str, add(48, mod(temp, 10)))
1480                 // Keep dividing `temp` until zero.
1481                 temp := div(temp, 10)
1482                 // prettier-ignore
1483                 if iszero(temp) { break }
1484             }
1485 
1486             let length := sub(end, str)
1487             // Move the pointer 32 bytes leftwards to make room for the length.
1488             str := sub(str, 0x20)
1489             // Store the length.
1490             mstore(str, length)
1491         }
1492     }
1493 }
1494 
1495 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1496 
1497 
1498 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1499 
1500 pragma solidity ^0.8.0;
1501 
1502 /**
1503  * @dev Contract module that helps prevent reentrant calls to a function.
1504  *
1505  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1506  * available, which can be applied to functions to make sure there are no nested
1507  * (reentrant) calls to them.
1508  *
1509  * Note that because there is a single `nonReentrant` guard, functions marked as
1510  * `nonReentrant` may not call one another. This can be worked around by making
1511  * those functions `private`, and then adding `external` `nonReentrant` entry
1512  * points to them.
1513  *
1514  * TIP: If you would like to learn more about reentrancy and alternative ways
1515  * to protect against it, check out our blog post
1516  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1517  */
1518 abstract contract ReentrancyGuard {
1519     // Booleans are more expensive than uint256 or any type that takes up a full
1520     // word because each write operation emits an extra SLOAD to first read the
1521     // slot's contents, replace the bits taken up by the boolean, and then write
1522     // back. This is the compiler's defense against contract upgrades and
1523     // pointer aliasing, and it cannot be disabled.
1524 
1525     // The values being non-zero value makes deployment a bit more expensive,
1526     // but in exchange the refund on every call to nonReentrant will be lower in
1527     // amount. Since refunds are capped to a percentage of the total
1528     // transaction's gas, it is best to keep them low in cases like this one, to
1529     // increase the likelihood of the full refund coming into effect.
1530     uint256 private constant _NOT_ENTERED = 1;
1531     uint256 private constant _ENTERED = 2;
1532 
1533     uint256 private _status;
1534 
1535     constructor() {
1536         _status = _NOT_ENTERED;
1537     }
1538 
1539     /**
1540      * @dev Prevents a contract from calling itself, directly or indirectly.
1541      * Calling a `nonReentrant` function from another `nonReentrant`
1542      * function is not supported. It is possible to prevent this from happening
1543      * by making the `nonReentrant` function external, and making it call a
1544      * `private` function that does the actual work.
1545      */
1546     modifier nonReentrant() {
1547         _nonReentrantBefore();
1548         _;
1549         _nonReentrantAfter();
1550     }
1551 
1552     function _nonReentrantBefore() private {
1553         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1554         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1555 
1556         // Any calls to nonReentrant after this point will fail
1557         _status = _ENTERED;
1558     }
1559 
1560     function _nonReentrantAfter() private {
1561         // By storing the original value once again, a refund is triggered (see
1562         // https://eips.ethereum.org/EIPS/eip-2200)
1563         _status = _NOT_ENTERED;
1564     }
1565 }
1566 
1567 // File: @openzeppelin/contracts/utils/Context.sol
1568 
1569 
1570 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1571 
1572 pragma solidity ^0.8.0;
1573 
1574 /**
1575  * @dev Provides information about the current execution context, including the
1576  * sender of the transaction and its data. While these are generally available
1577  * via msg.sender and msg.data, they should not be accessed in such a direct
1578  * manner, since when dealing with meta-transactions the account sending and
1579  * paying for execution may not be the actual sender (as far as an application
1580  * is concerned).
1581  *
1582  * This contract is only required for intermediate, library-like contracts.
1583  */
1584 abstract contract Context {
1585     function _msgSender() internal view virtual returns (address) {
1586         return msg.sender;
1587     }
1588 
1589     function _msgData() internal view virtual returns (bytes calldata) {
1590         return msg.data;
1591     }
1592 }
1593 
1594 // File: @openzeppelin/contracts/access/Ownable.sol
1595 
1596 
1597 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1598 
1599 pragma solidity ^0.8.0;
1600 
1601 /**
1602  * @dev Contract module which provides a basic access control mechanism, where
1603  * there is an account (an owner) that can be granted exclusive access to
1604  * specific functions.
1605  *
1606  * By default, the owner account will be the one that deploys the contract. This
1607  * can later be changed with {transferOwnership}.
1608  *
1609  * This module is used through inheritance. It will make available the modifier
1610  * `onlyOwner`, which can be applied to your functions to restrict their use to
1611  * the owner.
1612  */
1613 abstract contract Ownable is Context {
1614     address private _owner;
1615 
1616     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1617 
1618     /**
1619      * @dev Initializes the contract setting the deployer as the initial owner.
1620      */
1621     constructor() {
1622         _transferOwnership(_msgSender());
1623     }
1624 
1625     /**
1626      * @dev Throws if called by any account other than the owner.
1627      */
1628     modifier onlyOwner() {
1629         _checkOwner();
1630         _;
1631     }
1632 
1633     /**
1634      * @dev Returns the address of the current owner.
1635      */
1636     function owner() public view virtual returns (address) {
1637         return _owner;
1638     }
1639 
1640     /**
1641      * @dev Throws if the sender is not the owner.
1642      */
1643     function _checkOwner() internal view virtual {
1644         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1645     }
1646 
1647     /**
1648      * @dev Leaves the contract without owner. It will not be possible to call
1649      * `onlyOwner` functions anymore. Can only be called by the current owner.
1650      *
1651      * NOTE: Renouncing ownership will leave the contract without an owner,
1652      * thereby removing any functionality that is only available to the owner.
1653      */
1654     function renounceOwnership() public virtual onlyOwner {
1655         _transferOwnership(address(0));
1656     }
1657 
1658     /**
1659      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1660      * Can only be called by the current owner.
1661      */
1662     function transferOwnership(address newOwner) public virtual onlyOwner {
1663         require(newOwner != address(0), "Ownable: new owner is the zero address");
1664         _transferOwnership(newOwner);
1665     }
1666 
1667     /**
1668      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1669      * Internal function without access restriction.
1670      */
1671     function _transferOwnership(address newOwner) internal virtual {
1672         address oldOwner = _owner;
1673         _owner = newOwner;
1674         emit OwnershipTransferred(oldOwner, newOwner);
1675     }
1676 }
1677 
1678 ////////////////////
1679 ///// CONTRACT /////
1680 ////////////////////
1681 pragma solidity ^0.8.17;
1682 
1683 contract QAYC is ERC721A, Ownable, DefaultOperatorFilterer, ReentrancyGuard {
1684 
1685     ////////////////
1686     ///// SPEC /////
1687     ////////////////
1688     uint256 public maxSupply = 5000;
1689     uint256 public mintCost = 0.005 ether;
1690     uint256 public walletMax = 5;
1691     bool public saleActive = false;
1692 
1693     string public baseURI = "ipfs://QmUp7Fqm9QWqmsejFH7NWMraWr7bUN7To1FHKJH2mAF6ez/";
1694 
1695     mapping(address => bool) freeMint;
1696     mapping(address => uint) addressToMinted;
1697     
1698     function _startTokenId() internal view virtual override returns (uint256) {
1699         return 1;
1700     }
1701 
1702     constructor () ERC721A("Cute Ape Yacht Club", "QAYC") {
1703     }
1704 
1705     /////////////////////
1706     ///// FUNCTIONS /////
1707     /////////////////////
1708     function mintQAYC(uint256 mintAmount) public payable nonReentrant {
1709         require(saleActive, "The sale is not active.");
1710         require(addressToMinted[msg.sender] + mintAmount <= walletMax, "This wallet already minted the maximum allocation.");
1711         require(totalSupply() + mintAmount <= maxSupply, "No more are available for mint.");
1712 
1713         if(freeMint[msg.sender]) {
1714             require(msg.value >= mintAmount * mintCost, "You require more funds to mint that many.");
1715         }
1716         else {
1717             require(msg.value >= (mintAmount - 1) * mintCost, "You require more funds to mint that many.");
1718             freeMint[msg.sender] = true;
1719         }
1720         
1721         addressToMinted[msg.sender] += mintAmount;
1722         _safeMint(msg.sender, mintAmount);
1723     }
1724 
1725     function reserveQAYC(uint256 mintAmount) public onlyOwner {
1726         require(totalSupply() + mintAmount <= maxSupply, "No more are available.");
1727         
1728         _safeMint(msg.sender, mintAmount);
1729     }
1730 
1731     /////////////////
1732     ///// OWNER /////
1733     /////////////////
1734     function setCost(uint256 newCost) external onlyOwner {
1735         mintCost = newCost;
1736     }
1737 
1738     function setWalletMax(uint256 newMax) external onlyOwner {
1739         walletMax = newMax;
1740     }
1741 
1742     function flipSale() external onlyOwner {
1743         saleActive = !saleActive;
1744     }
1745 
1746     function _baseURI() internal view virtual override returns (string memory) {
1747         return baseURI;
1748     }
1749 
1750     function setBaseURI(string memory baseURI_) external onlyOwner {
1751         baseURI = baseURI_;
1752     }
1753 
1754     function withdraw() public onlyOwner {
1755 		payable(msg.sender).transfer(address(this).balance);
1756 	}
1757     
1758     //////////////////////////////
1759     ///// OS OPERATOR FILTER /////
1760     //////////////////////////////
1761     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1762         super.setApprovalForAll(operator, approved);
1763     }
1764 
1765     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1766         super.approve(operator, tokenId);
1767     }
1768 
1769     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1770         super.transferFrom(from, to, tokenId);
1771     }
1772 
1773     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1774         super.safeTransferFrom(from, to, tokenId);
1775     }
1776 
1777     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1778         public
1779         payable
1780         override
1781         onlyAllowedOperator(from)
1782     {
1783         super.safeTransferFrom(from, to, tokenId, data);
1784     }
1785 }