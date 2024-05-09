1 // File: IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 // File: OperatorFilterer.sol
33 
34 
35 pragma solidity ^0.8.13;
36 
37 
38 /**
39  * @title  OperatorFilterer
40  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
41  *         registrant's entries in the OperatorFilterRegistry.
42  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
43  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
44  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
45  */
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
70         // Allow spending tokens from addresses with balance
71         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
72         // from an EOA.
73         if (from != msg.sender) {
74             _checkFilterOperator(msg.sender);
75         }
76         _;
77     }
78 
79     modifier onlyAllowedOperatorApproval(address operator) virtual {
80         _checkFilterOperator(operator);
81         _;
82     }
83 
84     function _checkFilterOperator(address operator) internal view virtual {
85         // Check registry code length to facilitate testing in environments without a deployed registry.
86         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
87             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
88                 revert OperatorNotAllowed(operator);
89             }
90         }
91     }
92 }
93 // File: DefaultOperatorFilterer.sol
94 
95 
96 pragma solidity ^0.8.13;
97 
98 
99 /**
100  * @title  DefaultOperatorFilterer
101  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
102  */
103 abstract contract DefaultOperatorFilterer is OperatorFilterer {
104     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
105 
106     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
107 }
108 // File: ReentrancyGuard.sol
109 
110 
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Contract module that helps prevent reentrant calls to a function.
116  *
117  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
118  * available, which can be applied to functions to make sure there are no nested
119  * (reentrant) calls to them.
120  *
121  * Note that because there is a single `nonReentrant` guard, functions marked as
122  * `nonReentrant` may not call one another. This can be worked around by making
123  * those functions `private`, and then adding `external` `nonReentrant` entry
124  * points to them.
125  *
126  * TIP: If you would like to learn more about reentrancy and alternative ways
127  * to protect against it, check out our blog post
128  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
129  */
130 abstract contract ReentrancyGuard {
131     // Booleans are more expensive than uint256 or any type that takes up a full
132     // word because each write operation emits an extra SLOAD to first read the
133     // slot's contents, replace the bits taken up by the boolean, and then write
134     // back. This is the compiler's defense against contract upgrades and
135     // pointer aliasing, and it cannot be disabled.
136 
137     // The values being non-zero value makes deployment a bit more expensive,
138     // but in exchange the refund on every call to nonReentrant will be lower in
139     // amount. Since refunds are capped to a percentage of the total
140     // transaction's gas, it is best to keep them low in cases like this one, to
141     // increase the likelihood of the full refund coming into effect.
142     uint256 private constant _NOT_ENTERED = 1;
143     uint256 private constant _ENTERED = 2;
144 
145     uint256 private _status;
146 
147     constructor() {
148         _status = _NOT_ENTERED;
149     }
150 
151     /**
152      * @dev Prevents a contract from calling itself, directly or indirectly.
153      * Calling a `nonReentrant` function from another `nonReentrant`
154      * function is not supported. It is possible to prevent this from happening
155      * by making the `nonReentrant` function external, and making it call a
156      * `private` function that does the actual work.
157      */
158     modifier nonReentrant() {
159         _nonReentrantBefore();
160         _;
161         _nonReentrantAfter();
162     }
163 
164     function _nonReentrantBefore() private {
165         // On the first call to nonReentrant, _status will be _NOT_ENTERED
166         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
167 
168         // Any calls to nonReentrant after this point will fail
169         _status = _ENTERED;
170     }
171 
172     function _nonReentrantAfter() private {
173         // By storing the original value once again, a refund is triggered (see
174         // https://eips.ethereum.org/EIPS/eip-2200)
175         _status = _NOT_ENTERED;
176     }
177 }
178 // File: IERC721A.sol
179 
180 
181 // ERC721A Contracts v4.2.3
182 
183 pragma solidity ^0.8.4;
184 
185 /**
186  * @dev Interface of ERC721A.
187  */
188 interface IERC721A {
189     /**
190      * The caller must own the token or be an approved operator.
191      */
192     error ApprovalCallerNotOwnerNorApproved();
193 
194     /**
195      * The token does not exist.
196      */
197     error ApprovalQueryForNonexistentToken();
198 
199     /**
200      * Cannot query the balance for the zero address.
201      */
202     error BalanceQueryForZeroAddress();
203 
204     /**
205      * Cannot mint to the zero address.
206      */
207     error MintToZeroAddress();
208 
209     /**
210      * The quantity of tokens minted must be more than zero.
211      */
212     error MintZeroQuantity();
213 
214     /**
215      * The token does not exist.
216      */
217     error OwnerQueryForNonexistentToken();
218 
219     /**
220      * The caller must own the token or be an approved operator.
221      */
222     error TransferCallerNotOwnerNorApproved();
223 
224     /**
225      * The token must be owned by `from`.
226      */
227     error TransferFromIncorrectOwner();
228 
229     /**
230      * Cannot safely transfer to a contract that does not implement the
231      * ERC721Receiver interface.
232      */
233     error TransferToNonERC721ReceiverImplementer();
234 
235     /**
236      * Cannot transfer to the zero address.
237      */
238     error TransferToZeroAddress();
239 
240     /**
241      * The token does not exist.
242      */
243     error URIQueryForNonexistentToken();
244 
245     /**
246      * The `quantity` minted with ERC2309 exceeds the safety limit.
247      */
248     error MintERC2309QuantityExceedsLimit();
249 
250     /**
251      * The `extraData` cannot be set on an unintialized ownership slot.
252      */
253     error OwnershipNotInitializedForExtraData();
254 
255     // =============================================================
256     //                            STRUCTS
257     // =============================================================
258 
259     struct TokenOwnership {
260         // The address of the owner.
261         address addr;
262         // Stores the start time of ownership with minimal overhead for tokenomics.
263         uint64 startTimestamp;
264         // Whether the token has been burned.
265         bool burned;
266         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
267         uint24 extraData;
268     }
269 
270     // =============================================================
271     //                         TOKEN COUNTERS
272     // =============================================================
273 
274     /**
275      * @dev Returns the total number of tokens in existence.
276      * Burned tokens will reduce the count.
277      * To get the total number of tokens minted, please see {_totalMinted}.
278      */
279     function totalSupply() external view returns (uint256);
280 
281     // =============================================================
282     //                            IERC165
283     // =============================================================
284 
285     /**
286      * @dev Returns true if this contract implements the interface defined by
287      * `interfaceId`. See the corresponding
288      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
289      * to learn more about how these ids are created.
290      *
291      * This function call must use less than 30000 gas.
292      */
293     function supportsInterface(bytes4 interfaceId) external view returns (bool);
294 
295     // =============================================================
296     //                            IERC721
297     // =============================================================
298 
299     /**
300      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
301      */
302     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
303 
304     /**
305      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
306      */
307     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
308 
309     /**
310      * @dev Emitted when `owner` enables or disables
311      * (`approved`) `operator` to manage all of its assets.
312      */
313     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
314 
315     /**
316      * @dev Returns the number of tokens in `owner`'s account.
317      */
318     function balanceOf(address owner) external view returns (uint256 balance);
319 
320     /**
321      * @dev Returns the owner of the `tokenId` token.
322      *
323      * Requirements:
324      *
325      * - `tokenId` must exist.
326      */
327     function ownerOf(uint256 tokenId) external view returns (address owner);
328 
329     /**
330      * @dev Safely transfers `tokenId` token from `from` to `to`,
331      * checking first that contract recipients are aware of the ERC721 protocol
332      * to prevent tokens from being forever locked.
333      *
334      * Requirements:
335      *
336      * - `from` cannot be the zero address.
337      * - `to` cannot be the zero address.
338      * - `tokenId` token must exist and be owned by `from`.
339      * - If the caller is not `from`, it must be have been allowed to move
340      * this token by either {approve} or {setApprovalForAll}.
341      * - If `to` refers to a smart contract, it must implement
342      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
343      *
344      * Emits a {Transfer} event.
345      */
346     function safeTransferFrom(
347         address from,
348         address to,
349         uint256 tokenId,
350         bytes calldata data
351     ) external payable;
352 
353     /**
354      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
355      */
356     function safeTransferFrom(
357         address from,
358         address to,
359         uint256 tokenId
360     ) external payable;
361 
362     /**
363      * @dev Transfers `tokenId` from `from` to `to`.
364      *
365      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
366      * whenever possible.
367      *
368      * Requirements:
369      *
370      * - `from` cannot be the zero address.
371      * - `to` cannot be the zero address.
372      * - `tokenId` token must be owned by `from`.
373      * - If the caller is not `from`, it must be approved to move this token
374      * by either {approve} or {setApprovalForAll}.
375      *
376      * Emits a {Transfer} event.
377      */
378     function transferFrom(
379         address from,
380         address to,
381         uint256 tokenId
382     ) external payable;
383 
384     /**
385      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
386      * The approval is cleared when the token is transferred.
387      *
388      * Only a single account can be approved at a time, so approving the
389      * zero address clears previous approvals.
390      *
391      * Requirements:
392      *
393      * - The caller must own the token or be an approved operator.
394      * - `tokenId` must exist.
395      *
396      * Emits an {Approval} event.
397      */
398     function approve(address to, uint256 tokenId) external payable;
399 
400     /**
401      * @dev Approve or remove `operator` as an operator for the caller.
402      * Operators can call {transferFrom} or {safeTransferFrom}
403      * for any token owned by the caller.
404      *
405      * Requirements:
406      *
407      * - The `operator` cannot be the caller.
408      *
409      * Emits an {ApprovalForAll} event.
410      */
411     function setApprovalForAll(address operator, bool _approved) external;
412 
413     /**
414      * @dev Returns the account approved for `tokenId` token.
415      *
416      * Requirements:
417      *
418      * - `tokenId` must exist.
419      */
420     function getApproved(uint256 tokenId) external view returns (address operator);
421 
422     /**
423      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
424      *
425      * See {setApprovalForAll}.
426      */
427     function isApprovedForAll(address owner, address operator) external view returns (bool);
428 
429     // =============================================================
430     //                        IERC721Metadata
431     // =============================================================
432 
433     /**
434      * @dev Returns the token collection name.
435      */
436     function name() external view returns (string memory);
437 
438     /**
439      * @dev Returns the token collection symbol.
440      */
441     function symbol() external view returns (string memory);
442 
443     /**
444      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
445      */
446     function tokenURI(uint256 tokenId) external view returns (string memory);
447 
448     // =============================================================
449     //                           IERC2309
450     // =============================================================
451 
452     /**
453      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
454      * (inclusive) is transferred from `from` to `to`, as defined in the
455      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
456      *
457      * See {_mintERC2309} for more details.
458      */
459     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
460 }
461 // File: ERC721A.sol
462 
463 
464 pragma solidity ^0.8.4;
465 
466 
467 /**
468  * @dev Interface of ERC721 token receiver.
469  */
470 interface ERC721A__IERC721Receiver {
471     function onERC721Received(
472         address operator,
473         address from,
474         uint256 tokenId,
475         bytes calldata data
476     ) external returns (bytes4);
477 }
478 
479 /**
480  * @title ERC721A
481  *
482  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
483  * Non-Fungible Token Standard, including the Metadata extension.
484  * Optimized for lower gas during batch mints.
485  *
486  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
487  * starting from `_startTokenId()`.
488  *
489  * Assumptions:
490  *
491  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
492  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
493  */
494 contract ERC721A is IERC721A {
495     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
496     struct TokenApprovalRef {
497         address value;
498     }
499 
500     // =============================================================
501     //                           CONSTANTS
502     // =============================================================
503 
504     // Mask of an entry in packed address data.
505     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
506 
507     // The bit position of `numberMinted` in packed address data.
508     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
509 
510     // The bit position of `numberBurned` in packed address data.
511     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
512 
513     // The bit position of `aux` in packed address data.
514     uint256 private constant _BITPOS_AUX = 192;
515 
516     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
517     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
518 
519     // The bit position of `startTimestamp` in packed ownership.
520     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
521 
522     // The bit mask of the `burned` bit in packed ownership.
523     uint256 private constant _BITMASK_BURNED = 1 << 224;
524 
525     // The bit position of the `nextInitialized` bit in packed ownership.
526     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
527 
528     // The bit mask of the `nextInitialized` bit in packed ownership.
529     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
530 
531     // The bit position of `extraData` in packed ownership.
532     uint256 private constant _BITPOS_EXTRA_DATA = 232;
533 
534     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
535     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
536 
537     // The mask of the lower 160 bits for addresses.
538     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
539 
540     // The maximum `quantity` that can be minted with {_mintERC2309}.
541     // This limit is to prevent overflows on the address data entries.
542     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
543     // is required to cause an overflow, which is unrealistic.
544     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
545 
546     // The `Transfer` event signature is given by:
547     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
548     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
549         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
550 
551     // =============================================================
552     //                            STORAGE
553     // =============================================================
554 
555     // The next token ID to be minted.
556     uint256 private _currentIndex;
557 
558     // The number of tokens burned.
559     uint256 private _burnCounter;
560 
561     // Token name
562     string private _name;
563 
564     // Token symbol
565     string private _symbol;
566 
567     // Mapping from token ID to ownership details
568     // An empty struct value does not necessarily mean the token is unowned.
569     // See {_packedOwnershipOf} implementation for details.
570     //
571     // Bits Layout:
572     // - [0..159]   `addr`
573     // - [160..223] `startTimestamp`
574     // - [224]      `burned`
575     // - [225]      `nextInitialized`
576     // - [232..255] `extraData`
577     mapping(uint256 => uint256) private _packedOwnerships;
578 
579     // Mapping owner address to address data.
580     //
581     // Bits Layout:
582     // - [0..63]    `balance`
583     // - [64..127]  `numberMinted`
584     // - [128..191] `numberBurned`
585     // - [192..255] `aux`
586     mapping(address => uint256) private _packedAddressData;
587 
588     // Mapping from token ID to approved address.
589     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
590 
591     // Mapping from owner to operator approvals
592     mapping(address => mapping(address => bool)) private _operatorApprovals;
593 
594     // =============================================================
595     //                          CONSTRUCTOR
596     // =============================================================
597 
598     constructor(string memory name_, string memory symbol_) {
599         _name = name_;
600         _symbol = symbol_;
601         _currentIndex = _startTokenId();
602     }
603 
604     // =============================================================
605     //                   TOKEN COUNTING OPERATIONS
606     // =============================================================
607 
608     /**
609      * @dev Returns the starting token ID.
610      * To change the starting token ID, please override this function.
611      */
612     function _startTokenId() internal view virtual returns (uint256) {
613         return 0;
614     }
615 
616     /**
617      * @dev Returns the next token ID to be minted.
618      */
619     function _nextTokenId() internal view virtual returns (uint256) {
620         return _currentIndex;
621     }
622 
623     /**
624      * @dev Returns the total number of tokens in existence.
625      * Burned tokens will reduce the count.
626      * To get the total number of tokens minted, please see {_totalMinted}.
627      */
628     function totalSupply() public view virtual override returns (uint256) {
629         // Counter underflow is impossible as _burnCounter cannot be incremented
630         // more than `_currentIndex - _startTokenId()` times.
631         unchecked {
632             return _currentIndex - _burnCounter - _startTokenId();
633         }
634     }
635 
636     /**
637      * @dev Returns the total amount of tokens minted in the contract.
638      */
639     function _totalMinted() internal view virtual returns (uint256) {
640         // Counter underflow is impossible as `_currentIndex` does not decrement,
641         // and it is initialized to `_startTokenId()`.
642         unchecked {
643             return _currentIndex - _startTokenId();
644         }
645     }
646 
647     /**
648      * @dev Returns the total number of tokens burned.
649      */
650     function _totalBurned() internal view virtual returns (uint256) {
651         return _burnCounter;
652     }
653 
654     // =============================================================
655     //                    ADDRESS DATA OPERATIONS
656     // =============================================================
657 
658     /**
659      * @dev Returns the number of tokens in `owner`'s account.
660      */
661     function balanceOf(address owner) public view virtual override returns (uint256) {
662         if (owner == address(0)) revert BalanceQueryForZeroAddress();
663         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
664     }
665 
666     /**
667      * Returns the number of tokens minted by `owner`.
668      */
669     function _numberMinted(address owner) internal view returns (uint256) {
670         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
671     }
672 
673     /**
674      * Returns the number of tokens burned by or on behalf of `owner`.
675      */
676     function _numberBurned(address owner) internal view returns (uint256) {
677         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
678     }
679 
680     /**
681      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
682      */
683     function _getAux(address owner) internal view returns (uint64) {
684         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
685     }
686 
687     /**
688      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
689      * If there are multiple variables, please pack them into a uint64.
690      */
691     function _setAux(address owner, uint64 aux) internal virtual {
692         uint256 packed = _packedAddressData[owner];
693         uint256 auxCasted;
694         // Cast `aux` with assembly to avoid redundant masking.
695         assembly {
696             auxCasted := aux
697         }
698         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
699         _packedAddressData[owner] = packed;
700     }
701 
702     // =============================================================
703     //                            IERC165
704     // =============================================================
705 
706     /**
707      * @dev Returns true if this contract implements the interface defined by
708      * `interfaceId`. See the corresponding
709      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
710      * to learn more about how these ids are created.
711      *
712      * This function call must use less than 30000 gas.
713      */
714     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
715         // The interface IDs are constants representing the first 4 bytes
716         // of the XOR of all function selectors in the interface.
717         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
718         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
719         return
720             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
721             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
722             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
723     }
724 
725     // =============================================================
726     //                        IERC721Metadata
727     // =============================================================
728 
729     /**
730      * @dev Returns the token collection name.
731      */
732     function name() public view virtual override returns (string memory) {
733         return _name;
734     }
735 
736     /**
737      * @dev Returns the token collection symbol.
738      */
739     function symbol() public view virtual override returns (string memory) {
740         return _symbol;
741     }
742 
743     /**
744      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
745      */
746     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
747         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
748 
749         string memory baseURI = _baseURI();
750         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
751     }
752 
753     /**
754      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
755      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
756      * by default, it can be overridden in child contracts.
757      */
758     function _baseURI() internal view virtual returns (string memory) {
759         return '';
760     }
761 
762     // =============================================================
763     //                     OWNERSHIPS OPERATIONS
764     // =============================================================
765 
766     /**
767      * @dev Returns the owner of the `tokenId` token.
768      *
769      * Requirements:
770      *
771      * - `tokenId` must exist.
772      */
773     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
774         return address(uint160(_packedOwnershipOf(tokenId)));
775     }
776 
777     /**
778      * @dev Gas spent here starts off proportional to the maximum mint batch size.
779      * It gradually moves to O(1) as tokens get transferred around over time.
780      */
781     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
782         return _unpackedOwnership(_packedOwnershipOf(tokenId));
783     }
784 
785     /**
786      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
787      */
788     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
789         return _unpackedOwnership(_packedOwnerships[index]);
790     }
791 
792     /**
793      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
794      */
795     function _initializeOwnershipAt(uint256 index) internal virtual {
796         if (_packedOwnerships[index] == 0) {
797             _packedOwnerships[index] = _packedOwnershipOf(index);
798         }
799     }
800 
801     /**
802      * Returns the packed ownership data of `tokenId`.
803      */
804     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
805         uint256 curr = tokenId;
806 
807         unchecked {
808             if (_startTokenId() <= curr)
809                 if (curr < _currentIndex) {
810                     uint256 packed = _packedOwnerships[curr];
811                     // If not burned.
812                     if (packed & _BITMASK_BURNED == 0) {
813                         // Invariant:
814                         // There will always be an initialized ownership slot
815                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
816                         // before an unintialized ownership slot
817                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
818                         // Hence, `curr` will not underflow.
819                         //
820                         // We can directly compare the packed value.
821                         // If the address is zero, packed will be zero.
822                         while (packed == 0) {
823                             packed = _packedOwnerships[--curr];
824                         }
825                         return packed;
826                     }
827                 }
828         }
829         revert OwnerQueryForNonexistentToken();
830     }
831 
832     /**
833      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
834      */
835     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
836         ownership.addr = address(uint160(packed));
837         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
838         ownership.burned = packed & _BITMASK_BURNED != 0;
839         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
840     }
841 
842     /**
843      * @dev Packs ownership data into a single uint256.
844      */
845     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
846         assembly {
847             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
848             owner := and(owner, _BITMASK_ADDRESS)
849             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
850             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
851         }
852     }
853 
854     /**
855      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
856      */
857     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
858         // For branchless setting of the `nextInitialized` flag.
859         assembly {
860             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
861             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
862         }
863     }
864 
865     // =============================================================
866     //                      APPROVAL OPERATIONS
867     // =============================================================
868 
869     /**
870      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
871      * The approval is cleared when the token is transferred.
872      *
873      * Only a single account can be approved at a time, so approving the
874      * zero address clears previous approvals.
875      *
876      * Requirements:
877      *
878      * - The caller must own the token or be an approved operator.
879      * - `tokenId` must exist.
880      *
881      * Emits an {Approval} event.
882      */
883     function approve(address to, uint256 tokenId) public payable virtual override {
884         address owner = ownerOf(tokenId);
885 
886         if (_msgSenderERC721A() != owner)
887             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
888                 revert ApprovalCallerNotOwnerNorApproved();
889             }
890 
891         _tokenApprovals[tokenId].value = to;
892         emit Approval(owner, to, tokenId);
893     }
894 
895     /**
896      * @dev Returns the account approved for `tokenId` token.
897      *
898      * Requirements:
899      *
900      * - `tokenId` must exist.
901      */
902     function getApproved(uint256 tokenId) public view virtual override returns (address) {
903         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
904 
905         return _tokenApprovals[tokenId].value;
906     }
907 
908     /**
909      * @dev Approve or remove `operator` as an operator for the caller.
910      * Operators can call {transferFrom} or {safeTransferFrom}
911      * for any token owned by the caller.
912      *
913      * Requirements:
914      *
915      * - The `operator` cannot be the caller.
916      *
917      * Emits an {ApprovalForAll} event.
918      */
919     function setApprovalForAll(address operator, bool approved) public virtual override {
920         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
921         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
922     }
923 
924     /**
925      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
926      *
927      * See {setApprovalForAll}.
928      */
929     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
930         return _operatorApprovals[owner][operator];
931     }
932 
933     /**
934      * @dev Returns whether `tokenId` exists.
935      *
936      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
937      *
938      * Tokens start existing when they are minted. See {_mint}.
939      */
940     function _exists(uint256 tokenId) internal view virtual returns (bool) {
941         return
942             _startTokenId() <= tokenId &&
943             tokenId < _currentIndex && // If within bounds,
944             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
945     }
946 
947     /**
948      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
949      */
950     function _isSenderApprovedOrOwner(
951         address approvedAddress,
952         address owner,
953         address msgSender
954     ) private pure returns (bool result) {
955         assembly {
956             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
957             owner := and(owner, _BITMASK_ADDRESS)
958             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
959             msgSender := and(msgSender, _BITMASK_ADDRESS)
960             // `msgSender == owner || msgSender == approvedAddress`.
961             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
962         }
963     }
964 
965     /**
966      * @dev Returns the storage slot and value for the approved address of `tokenId`.
967      */
968     function _getApprovedSlotAndAddress(uint256 tokenId)
969         private
970         view
971         returns (uint256 approvedAddressSlot, address approvedAddress)
972     {
973         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
974         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
975         assembly {
976             approvedAddressSlot := tokenApproval.slot
977             approvedAddress := sload(approvedAddressSlot)
978         }
979     }
980 
981     // =============================================================
982     //                      TRANSFER OPERATIONS
983     // =============================================================
984 
985     /**
986      * @dev Transfers `tokenId` from `from` to `to`.
987      *
988      * Requirements:
989      *
990      * - `from` cannot be the zero address.
991      * - `to` cannot be the zero address.
992      * - `tokenId` token must be owned by `from`.
993      * - If the caller is not `from`, it must be approved to move this token
994      * by either {approve} or {setApprovalForAll}.
995      *
996      * Emits a {Transfer} event.
997      */
998     function transferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public payable virtual override {
1003         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1004 
1005         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1006 
1007         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1008 
1009         // The nested ifs save around 20+ gas over a compound boolean condition.
1010         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1011             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1012 
1013         if (to == address(0)) revert TransferToZeroAddress();
1014 
1015         _beforeTokenTransfers(from, to, tokenId, 1);
1016 
1017         // Clear approvals from the previous owner.
1018         assembly {
1019             if approvedAddress {
1020                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1021                 sstore(approvedAddressSlot, 0)
1022             }
1023         }
1024 
1025         // Underflow of the sender's balance is impossible because we check for
1026         // ownership above and the recipient's balance can't realistically overflow.
1027         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1028         unchecked {
1029             // We can directly increment and decrement the balances.
1030             --_packedAddressData[from]; // Updates: `balance -= 1`.
1031             ++_packedAddressData[to]; // Updates: `balance += 1`.
1032 
1033             // Updates:
1034             // - `address` to the next owner.
1035             // - `startTimestamp` to the timestamp of transfering.
1036             // - `burned` to `false`.
1037             // - `nextInitialized` to `true`.
1038             _packedOwnerships[tokenId] = _packOwnershipData(
1039                 to,
1040                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1041             );
1042 
1043             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1044             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1045                 uint256 nextTokenId = tokenId + 1;
1046                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1047                 if (_packedOwnerships[nextTokenId] == 0) {
1048                     // If the next slot is within bounds.
1049                     if (nextTokenId != _currentIndex) {
1050                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1051                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1052                     }
1053                 }
1054             }
1055         }
1056 
1057         emit Transfer(from, to, tokenId);
1058         _afterTokenTransfers(from, to, tokenId, 1);
1059     }
1060 
1061     /**
1062      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1063      */
1064     function safeTransferFrom(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) public payable virtual override {
1069         safeTransferFrom(from, to, tokenId, '');
1070     }
1071 
1072     /**
1073      * @dev Safely transfers `tokenId` token from `from` to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `from` cannot be the zero address.
1078      * - `to` cannot be the zero address.
1079      * - `tokenId` token must exist and be owned by `from`.
1080      * - If the caller is not `from`, it must be approved to move this token
1081      * by either {approve} or {setApprovalForAll}.
1082      * - If `to` refers to a smart contract, it must implement
1083      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function safeTransferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) public payable virtual override {
1093         transferFrom(from, to, tokenId);
1094         if (to.code.length != 0)
1095             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1096                 revert TransferToNonERC721ReceiverImplementer();
1097             }
1098     }
1099 
1100     /**
1101      * @dev Hook that is called before a set of serially-ordered token IDs
1102      * are about to be transferred. This includes minting.
1103      * And also called before burning one token.
1104      *
1105      * `startTokenId` - the first token ID to be transferred.
1106      * `quantity` - the amount to be transferred.
1107      *
1108      * Calling conditions:
1109      *
1110      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1111      * transferred to `to`.
1112      * - When `from` is zero, `tokenId` will be minted for `to`.
1113      * - When `to` is zero, `tokenId` will be burned by `from`.
1114      * - `from` and `to` are never both zero.
1115      */
1116     function _beforeTokenTransfers(
1117         address from,
1118         address to,
1119         uint256 startTokenId,
1120         uint256 quantity
1121     ) internal virtual {}
1122 
1123     /**
1124      * @dev Hook that is called after a set of serially-ordered token IDs
1125      * have been transferred. This includes minting.
1126      * And also called after one token has been burned.
1127      *
1128      * `startTokenId` - the first token ID to be transferred.
1129      * `quantity` - the amount to be transferred.
1130      *
1131      * Calling conditions:
1132      *
1133      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1134      * transferred to `to`.
1135      * - When `from` is zero, `tokenId` has been minted for `to`.
1136      * - When `to` is zero, `tokenId` has been burned by `from`.
1137      * - `from` and `to` are never both zero.
1138      */
1139     function _afterTokenTransfers(
1140         address from,
1141         address to,
1142         uint256 startTokenId,
1143         uint256 quantity
1144     ) internal virtual {}
1145 
1146     /**
1147      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1148      *
1149      * `from` - Previous owner of the given token ID.
1150      * `to` - Target address that will receive the token.
1151      * `tokenId` - Token ID to be transferred.
1152      * `_data` - Optional data to send along with the call.
1153      *
1154      * Returns whether the call correctly returned the expected magic value.
1155      */
1156     function _checkContractOnERC721Received(
1157         address from,
1158         address to,
1159         uint256 tokenId,
1160         bytes memory _data
1161     ) private returns (bool) {
1162         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1163             bytes4 retval
1164         ) {
1165             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1166         } catch (bytes memory reason) {
1167             if (reason.length == 0) {
1168                 revert TransferToNonERC721ReceiverImplementer();
1169             } else {
1170                 assembly {
1171                     revert(add(32, reason), mload(reason))
1172                 }
1173             }
1174         }
1175     }
1176 
1177     // =============================================================
1178     //                        MINT OPERATIONS
1179     // =============================================================
1180 
1181     /**
1182      * @dev Mints `quantity` tokens and transfers them to `to`.
1183      *
1184      * Requirements:
1185      *
1186      * - `to` cannot be the zero address.
1187      * - `quantity` must be greater than 0.
1188      *
1189      * Emits a {Transfer} event for each mint.
1190      */
1191     function _mint(address to, uint256 quantity) internal virtual {
1192         uint256 startTokenId = _currentIndex;
1193         if (quantity == 0) revert MintZeroQuantity();
1194 
1195         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1196 
1197         // Overflows are incredibly unrealistic.
1198         // `balance` and `numberMinted` have a maximum limit of 2**64.
1199         // `tokenId` has a maximum limit of 2**256.
1200         unchecked {
1201             // Updates:
1202             // - `balance += quantity`.
1203             // - `numberMinted += quantity`.
1204             //
1205             // We can directly add to the `balance` and `numberMinted`.
1206             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1207 
1208             // Updates:
1209             // - `address` to the owner.
1210             // - `startTimestamp` to the timestamp of minting.
1211             // - `burned` to `false`.
1212             // - `nextInitialized` to `quantity == 1`.
1213             _packedOwnerships[startTokenId] = _packOwnershipData(
1214                 to,
1215                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1216             );
1217 
1218             uint256 toMasked;
1219             uint256 end = startTokenId + quantity;
1220 
1221             // Use assembly to loop and emit the `Transfer` event for gas savings.
1222             // The duplicated `log4` removes an extra check and reduces stack juggling.
1223             // The assembly, together with the surrounding Solidity code, have been
1224             // delicately arranged to nudge the compiler into producing optimized opcodes.
1225             assembly {
1226                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1227                 toMasked := and(to, _BITMASK_ADDRESS)
1228                 // Emit the `Transfer` event.
1229                 log4(
1230                     0, // Start of data (0, since no data).
1231                     0, // End of data (0, since no data).
1232                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1233                     0, // `address(0)`.
1234                     toMasked, // `to`.
1235                     startTokenId // `tokenId`.
1236                 )
1237 
1238                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1239                 // that overflows uint256 will make the loop run out of gas.
1240                 // The compiler will optimize the `iszero` away for performance.
1241                 for {
1242                     let tokenId := add(startTokenId, 1)
1243                 } iszero(eq(tokenId, end)) {
1244                     tokenId := add(tokenId, 1)
1245                 } {
1246                     // Emit the `Transfer` event. Similar to above.
1247                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1248                 }
1249             }
1250             if (toMasked == 0) revert MintToZeroAddress();
1251 
1252             _currentIndex = end;
1253         }
1254         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1255     }
1256 
1257     /**
1258      * @dev Mints `quantity` tokens and transfers them to `to`.
1259      *
1260      * This function is intended for efficient minting only during contract creation.
1261      *
1262      * It emits only one {ConsecutiveTransfer} as defined in
1263      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1264      * instead of a sequence of {Transfer} event(s).
1265      *
1266      * Calling this function outside of contract creation WILL make your contract
1267      * non-compliant with the ERC721 standard.
1268      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1269      * {ConsecutiveTransfer} event is only permissible during contract creation.
1270      *
1271      * Requirements:
1272      *
1273      * - `to` cannot be the zero address.
1274      * - `quantity` must be greater than 0.
1275      *
1276      * Emits a {ConsecutiveTransfer} event.
1277      */
1278     function _mintERC2309(address to, uint256 quantity) internal virtual {
1279         uint256 startTokenId = _currentIndex;
1280         if (to == address(0)) revert MintToZeroAddress();
1281         if (quantity == 0) revert MintZeroQuantity();
1282         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1283 
1284         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1285 
1286         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1287         unchecked {
1288             // Updates:
1289             // - `balance += quantity`.
1290             // - `numberMinted += quantity`.
1291             //
1292             // We can directly add to the `balance` and `numberMinted`.
1293             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1294 
1295             // Updates:
1296             // - `address` to the owner.
1297             // - `startTimestamp` to the timestamp of minting.
1298             // - `burned` to `false`.
1299             // - `nextInitialized` to `quantity == 1`.
1300             _packedOwnerships[startTokenId] = _packOwnershipData(
1301                 to,
1302                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1303             );
1304 
1305             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1306 
1307             _currentIndex = startTokenId + quantity;
1308         }
1309         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1310     }
1311 
1312     /**
1313      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1314      *
1315      * Requirements:
1316      *
1317      * - If `to` refers to a smart contract, it must implement
1318      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1319      * - `quantity` must be greater than 0.
1320      *
1321      * See {_mint}.
1322      *
1323      * Emits a {Transfer} event for each mint.
1324      */
1325     function _safeMint(
1326         address to,
1327         uint256 quantity,
1328         bytes memory _data
1329     ) internal virtual {
1330         _mint(to, quantity);
1331 
1332         unchecked {
1333             if (to.code.length != 0) {
1334                 uint256 end = _currentIndex;
1335                 uint256 index = end - quantity;
1336                 do {
1337                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1338                         revert TransferToNonERC721ReceiverImplementer();
1339                     }
1340                 } while (index < end);
1341                 // Reentrancy protection.
1342                 if (_currentIndex != end) revert();
1343             }
1344         }
1345     }
1346 
1347     /**
1348      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1349      */
1350     function _safeMint(address to, uint256 quantity) internal virtual {
1351         _safeMint(to, quantity, '');
1352     }
1353 
1354     // =============================================================
1355     //                        BURN OPERATIONS
1356     // =============================================================
1357 
1358     /**
1359      * @dev Equivalent to `_burn(tokenId, false)`.
1360      */
1361     function _burn(uint256 tokenId) internal virtual {
1362         _burn(tokenId, false);
1363     }
1364 
1365     /**
1366      * @dev Destroys `tokenId`.
1367      * The approval is cleared when the token is burned.
1368      *
1369      * Requirements:
1370      *
1371      * - `tokenId` must exist.
1372      *
1373      * Emits a {Transfer} event.
1374      */
1375     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1376         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1377 
1378         address from = address(uint160(prevOwnershipPacked));
1379 
1380         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1381 
1382         if (approvalCheck) {
1383             // The nested ifs save around 20+ gas over a compound boolean condition.
1384             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1385                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1386         }
1387 
1388         _beforeTokenTransfers(from, address(0), tokenId, 1);
1389 
1390         // Clear approvals from the previous owner.
1391         assembly {
1392             if approvedAddress {
1393                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1394                 sstore(approvedAddressSlot, 0)
1395             }
1396         }
1397 
1398         // Underflow of the sender's balance is impossible because we check for
1399         // ownership above and the recipient's balance can't realistically overflow.
1400         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1401         unchecked {
1402             // Updates:
1403             // - `balance -= 1`.
1404             // - `numberBurned += 1`.
1405             //
1406             // We can directly decrement the balance, and increment the number burned.
1407             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1408             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1409 
1410             // Updates:
1411             // - `address` to the last owner.
1412             // - `startTimestamp` to the timestamp of burning.
1413             // - `burned` to `true`.
1414             // - `nextInitialized` to `true`.
1415             _packedOwnerships[tokenId] = _packOwnershipData(
1416                 from,
1417                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1418             );
1419 
1420             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1421             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1422                 uint256 nextTokenId = tokenId + 1;
1423                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1424                 if (_packedOwnerships[nextTokenId] == 0) {
1425                     // If the next slot is within bounds.
1426                     if (nextTokenId != _currentIndex) {
1427                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1428                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1429                     }
1430                 }
1431             }
1432         }
1433 
1434         emit Transfer(from, address(0), tokenId);
1435         _afterTokenTransfers(from, address(0), tokenId, 1);
1436 
1437         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1438         unchecked {
1439             _burnCounter++;
1440         }
1441     }
1442 
1443     // =============================================================
1444     //                     EXTRA DATA OPERATIONS
1445     // =============================================================
1446 
1447     /**
1448      * @dev Directly sets the extra data for the ownership data `index`.
1449      */
1450     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1451         uint256 packed = _packedOwnerships[index];
1452         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1453         uint256 extraDataCasted;
1454         // Cast `extraData` with assembly to avoid redundant masking.
1455         assembly {
1456             extraDataCasted := extraData
1457         }
1458         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1459         _packedOwnerships[index] = packed;
1460     }
1461 
1462     /**
1463      * @dev Called during each token transfer to set the 24bit `extraData` field.
1464      * Intended to be overridden by the cosumer contract.
1465      *
1466      * `previousExtraData` - the value of `extraData` before transfer.
1467      *
1468      * Calling conditions:
1469      *
1470      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1471      * transferred to `to`.
1472      * - When `from` is zero, `tokenId` will be minted for `to`.
1473      * - When `to` is zero, `tokenId` will be burned by `from`.
1474      * - `from` and `to` are never both zero.
1475      */
1476     function _extraData(
1477         address from,
1478         address to,
1479         uint24 previousExtraData
1480     ) internal view virtual returns (uint24) {}
1481 
1482     /**
1483      * @dev Returns the next extra data for the packed ownership data.
1484      * The returned result is shifted into position.
1485      */
1486     function _nextExtraData(
1487         address from,
1488         address to,
1489         uint256 prevOwnershipPacked
1490     ) private view returns (uint256) {
1491         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1492         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1493     }
1494 
1495     // =============================================================
1496     //                       OTHER OPERATIONS
1497     // =============================================================
1498 
1499     /**
1500      * @dev Returns the message sender (defaults to `msg.sender`).
1501      *
1502      * If you are writing GSN compatible contracts, you need to override this function.
1503      */
1504     function _msgSenderERC721A() internal view virtual returns (address) {
1505         return msg.sender;
1506     }
1507 
1508     /**
1509      * @dev Converts a uint256 to its ASCII string decimal representation.
1510      */
1511     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1512         assembly {
1513             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1514             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1515             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1516             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1517             let m := add(mload(0x40), 0xa0)
1518             // Update the free memory pointer to allocate.
1519             mstore(0x40, m)
1520             // Assign the `str` to the end.
1521             str := sub(m, 0x20)
1522             // Zeroize the slot after the string.
1523             mstore(str, 0)
1524 
1525             // Cache the end of the memory to calculate the length later.
1526             let end := str
1527 
1528             // We write the string from rightmost digit to leftmost digit.
1529             // The following is essentially a do-while loop that also handles the zero case.
1530             // prettier-ignore
1531             for { let temp := value } 1 {} {
1532                 str := sub(str, 1)
1533                 // Write the character to the pointer.
1534                 // The ASCII index of the '0' character is 48.
1535                 mstore8(str, add(48, mod(temp, 10)))
1536                 // Keep dividing `temp` until zero.
1537                 temp := div(temp, 10)
1538                 // prettier-ignore
1539                 if iszero(temp) { break }
1540             }
1541 
1542             let length := sub(end, str)
1543             // Move the pointer 32 bytes leftwards to make room for the length.
1544             str := sub(str, 0x20)
1545             // Store the length.
1546             mstore(str, length)
1547         }
1548     }
1549 }
1550 // File: @openzeppelin/contracts/utils/math/Math.sol
1551 
1552 
1553 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1554 
1555 pragma solidity ^0.8.0;
1556 
1557 /**
1558  * @dev Standard math utilities missing in the Solidity language.
1559  */
1560 library Math {
1561     enum Rounding {
1562         Down, // Toward negative infinity
1563         Up, // Toward infinity
1564         Zero // Toward zero
1565     }
1566 
1567     /**
1568      * @dev Returns the largest of two numbers.
1569      */
1570     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1571         return a > b ? a : b;
1572     }
1573 
1574     /**
1575      * @dev Returns the smallest of two numbers.
1576      */
1577     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1578         return a < b ? a : b;
1579     }
1580 
1581     /**
1582      * @dev Returns the average of two numbers. The result is rounded towards
1583      * zero.
1584      */
1585     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1586         // (a + b) / 2 can overflow.
1587         return (a & b) + (a ^ b) / 2;
1588     }
1589 
1590     /**
1591      * @dev Returns the ceiling of the division of two numbers.
1592      *
1593      * This differs from standard division with `/` in that it rounds up instead
1594      * of rounding down.
1595      */
1596     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1597         // (a + b - 1) / b can overflow on addition, so we distribute.
1598         return a == 0 ? 0 : (a - 1) / b + 1;
1599     }
1600 
1601     /**
1602      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1603      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1604      * with further edits by Uniswap Labs also under MIT license.
1605      */
1606     function mulDiv(
1607         uint256 x,
1608         uint256 y,
1609         uint256 denominator
1610     ) internal pure returns (uint256 result) {
1611         unchecked {
1612             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1613             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1614             // variables such that product = prod1 * 2^256 + prod0.
1615             uint256 prod0; // Least significant 256 bits of the product
1616             uint256 prod1; // Most significant 256 bits of the product
1617             assembly {
1618                 let mm := mulmod(x, y, not(0))
1619                 prod0 := mul(x, y)
1620                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1621             }
1622 
1623             // Handle non-overflow cases, 256 by 256 division.
1624             if (prod1 == 0) {
1625                 return prod0 / denominator;
1626             }
1627 
1628             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1629             require(denominator > prod1);
1630 
1631             ///////////////////////////////////////////////
1632             // 512 by 256 division.
1633             ///////////////////////////////////////////////
1634 
1635             // Make division exact by subtracting the remainder from [prod1 prod0].
1636             uint256 remainder;
1637             assembly {
1638                 // Compute remainder using mulmod.
1639                 remainder := mulmod(x, y, denominator)
1640 
1641                 // Subtract 256 bit number from 512 bit number.
1642                 prod1 := sub(prod1, gt(remainder, prod0))
1643                 prod0 := sub(prod0, remainder)
1644             }
1645 
1646             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1647             // See https://cs.stackexchange.com/q/138556/92363.
1648 
1649             // Does not overflow because the denominator cannot be zero at this stage in the function.
1650             uint256 twos = denominator & (~denominator + 1);
1651             assembly {
1652                 // Divide denominator by twos.
1653                 denominator := div(denominator, twos)
1654 
1655                 // Divide [prod1 prod0] by twos.
1656                 prod0 := div(prod0, twos)
1657 
1658                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1659                 twos := add(div(sub(0, twos), twos), 1)
1660             }
1661 
1662             // Shift in bits from prod1 into prod0.
1663             prod0 |= prod1 * twos;
1664 
1665             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1666             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1667             // four bits. That is, denominator * inv = 1 mod 2^4.
1668             uint256 inverse = (3 * denominator) ^ 2;
1669 
1670             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1671             // in modular arithmetic, doubling the correct bits in each step.
1672             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1673             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1674             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1675             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1676             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1677             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1678 
1679             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1680             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1681             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1682             // is no longer required.
1683             result = prod0 * inverse;
1684             return result;
1685         }
1686     }
1687 
1688     /**
1689      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1690      */
1691     function mulDiv(
1692         uint256 x,
1693         uint256 y,
1694         uint256 denominator,
1695         Rounding rounding
1696     ) internal pure returns (uint256) {
1697         uint256 result = mulDiv(x, y, denominator);
1698         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1699             result += 1;
1700         }
1701         return result;
1702     }
1703 
1704     /**
1705      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1706      *
1707      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1708      */
1709     function sqrt(uint256 a) internal pure returns (uint256) {
1710         if (a == 0) {
1711             return 0;
1712         }
1713 
1714         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1715         //
1716         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1717         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1718         //
1719         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1720         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1721         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1722         //
1723         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1724         uint256 result = 1 << (log2(a) >> 1);
1725 
1726         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1727         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1728         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1729         // into the expected uint128 result.
1730         unchecked {
1731             result = (result + a / result) >> 1;
1732             result = (result + a / result) >> 1;
1733             result = (result + a / result) >> 1;
1734             result = (result + a / result) >> 1;
1735             result = (result + a / result) >> 1;
1736             result = (result + a / result) >> 1;
1737             result = (result + a / result) >> 1;
1738             return min(result, a / result);
1739         }
1740     }
1741 
1742     /**
1743      * @notice Calculates sqrt(a), following the selected rounding direction.
1744      */
1745     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1746         unchecked {
1747             uint256 result = sqrt(a);
1748             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1749         }
1750     }
1751 
1752     /**
1753      * @dev Return the log in base 2, rounded down, of a positive value.
1754      * Returns 0 if given 0.
1755      */
1756     function log2(uint256 value) internal pure returns (uint256) {
1757         uint256 result = 0;
1758         unchecked {
1759             if (value >> 128 > 0) {
1760                 value >>= 128;
1761                 result += 128;
1762             }
1763             if (value >> 64 > 0) {
1764                 value >>= 64;
1765                 result += 64;
1766             }
1767             if (value >> 32 > 0) {
1768                 value >>= 32;
1769                 result += 32;
1770             }
1771             if (value >> 16 > 0) {
1772                 value >>= 16;
1773                 result += 16;
1774             }
1775             if (value >> 8 > 0) {
1776                 value >>= 8;
1777                 result += 8;
1778             }
1779             if (value >> 4 > 0) {
1780                 value >>= 4;
1781                 result += 4;
1782             }
1783             if (value >> 2 > 0) {
1784                 value >>= 2;
1785                 result += 2;
1786             }
1787             if (value >> 1 > 0) {
1788                 result += 1;
1789             }
1790         }
1791         return result;
1792     }
1793 
1794     /**
1795      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1796      * Returns 0 if given 0.
1797      */
1798     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1799         unchecked {
1800             uint256 result = log2(value);
1801             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1802         }
1803     }
1804 
1805     /**
1806      * @dev Return the log in base 10, rounded down, of a positive value.
1807      * Returns 0 if given 0.
1808      */
1809     function log10(uint256 value) internal pure returns (uint256) {
1810         uint256 result = 0;
1811         unchecked {
1812             if (value >= 10**64) {
1813                 value /= 10**64;
1814                 result += 64;
1815             }
1816             if (value >= 10**32) {
1817                 value /= 10**32;
1818                 result += 32;
1819             }
1820             if (value >= 10**16) {
1821                 value /= 10**16;
1822                 result += 16;
1823             }
1824             if (value >= 10**8) {
1825                 value /= 10**8;
1826                 result += 8;
1827             }
1828             if (value >= 10**4) {
1829                 value /= 10**4;
1830                 result += 4;
1831             }
1832             if (value >= 10**2) {
1833                 value /= 10**2;
1834                 result += 2;
1835             }
1836             if (value >= 10**1) {
1837                 result += 1;
1838             }
1839         }
1840         return result;
1841     }
1842 
1843     /**
1844      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1845      * Returns 0 if given 0.
1846      */
1847     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1848         unchecked {
1849             uint256 result = log10(value);
1850             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1851         }
1852     }
1853 
1854     /**
1855      * @dev Return the log in base 256, rounded down, of a positive value.
1856      * Returns 0 if given 0.
1857      *
1858      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1859      */
1860     function log256(uint256 value) internal pure returns (uint256) {
1861         uint256 result = 0;
1862         unchecked {
1863             if (value >> 128 > 0) {
1864                 value >>= 128;
1865                 result += 16;
1866             }
1867             if (value >> 64 > 0) {
1868                 value >>= 64;
1869                 result += 8;
1870             }
1871             if (value >> 32 > 0) {
1872                 value >>= 32;
1873                 result += 4;
1874             }
1875             if (value >> 16 > 0) {
1876                 value >>= 16;
1877                 result += 2;
1878             }
1879             if (value >> 8 > 0) {
1880                 result += 1;
1881             }
1882         }
1883         return result;
1884     }
1885 
1886     /**
1887      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1888      * Returns 0 if given 0.
1889      */
1890     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1891         unchecked {
1892             uint256 result = log256(value);
1893             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1894         }
1895     }
1896 }
1897 
1898 // File: @openzeppelin/contracts/utils/Strings.sol
1899 
1900 
1901 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1902 
1903 pragma solidity ^0.8.0;
1904 
1905 
1906 /**
1907  * @dev String operations.
1908  */
1909 library Strings {
1910     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1911     uint8 private constant _ADDRESS_LENGTH = 20;
1912 
1913     /**
1914      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1915      */
1916     function toString(uint256 value) internal pure returns (string memory) {
1917         unchecked {
1918             uint256 length = Math.log10(value) + 1;
1919             string memory buffer = new string(length);
1920             uint256 ptr;
1921             /// @solidity memory-safe-assembly
1922             assembly {
1923                 ptr := add(buffer, add(32, length))
1924             }
1925             while (true) {
1926                 ptr--;
1927                 /// @solidity memory-safe-assembly
1928                 assembly {
1929                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1930                 }
1931                 value /= 10;
1932                 if (value == 0) break;
1933             }
1934             return buffer;
1935         }
1936     }
1937 
1938     /**
1939      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1940      */
1941     function toHexString(uint256 value) internal pure returns (string memory) {
1942         unchecked {
1943             return toHexString(value, Math.log256(value) + 1);
1944         }
1945     }
1946 
1947     /**
1948      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1949      */
1950     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1951         bytes memory buffer = new bytes(2 * length + 2);
1952         buffer[0] = "0";
1953         buffer[1] = "x";
1954         for (uint256 i = 2 * length + 1; i > 1; --i) {
1955             buffer[i] = _SYMBOLS[value & 0xf];
1956             value >>= 4;
1957         }
1958         require(value == 0, "Strings: hex length insufficient");
1959         return string(buffer);
1960     }
1961 
1962     /**
1963      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1964      */
1965     function toHexString(address addr) internal pure returns (string memory) {
1966         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1967     }
1968 }
1969 
1970 // File: @openzeppelin/contracts/utils/Context.sol
1971 
1972 
1973 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1974 
1975 pragma solidity ^0.8.0;
1976 
1977 /**
1978  * @dev Provides information about the current execution context, including the
1979  * sender of the transaction and its data. While these are generally available
1980  * via msg.sender and msg.data, they should not be accessed in such a direct
1981  * manner, since when dealing with meta-transactions the account sending and
1982  * paying for execution may not be the actual sender (as far as an application
1983  * is concerned).
1984  *
1985  * This contract is only required for intermediate, library-like contracts.
1986  */
1987 abstract contract Context {
1988     function _msgSender() internal view virtual returns (address) {
1989         return msg.sender;
1990     }
1991 
1992     function _msgData() internal view virtual returns (bytes calldata) {
1993         return msg.data;
1994     }
1995 }
1996 
1997 // File: @openzeppelin/contracts/access/Ownable.sol
1998 
1999 
2000 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2001 
2002 pragma solidity ^0.8.0;
2003 
2004 
2005 /**
2006  * @dev Contract module which provides a basic access control mechanism, where
2007  * there is an account (an owner) that can be granted exclusive access to
2008  * specific functions.
2009  *
2010  * By default, the owner account will be the one that deploys the contract. This
2011  * can later be changed with {transferOwnership}.
2012  *
2013  * This module is used through inheritance. It will make available the modifier
2014  * `onlyOwner`, which can be applied to your functions to restrict their use to
2015  * the owner.
2016  */
2017 abstract contract Ownable is Context {
2018     address private _owner;
2019 
2020     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2021 
2022     /**
2023      * @dev Initializes the contract setting the deployer as the initial owner.
2024      */
2025     constructor() {
2026         _transferOwnership(_msgSender());
2027     }
2028 
2029     /**
2030      * @dev Throws if called by any account other than the owner.
2031      */
2032     modifier onlyOwner() {
2033         _checkOwner();
2034         _;
2035     }
2036 
2037     /**
2038      * @dev Returns the address of the current owner.
2039      */
2040     function owner() public view virtual returns (address) {
2041         return _owner;
2042     }
2043 
2044     /**
2045      * @dev Throws if the sender is not the owner.
2046      */
2047     function _checkOwner() internal view virtual {
2048         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2049     }
2050 
2051     /**
2052      * @dev Leaves the contract without owner. It will not be possible to call
2053      * `onlyOwner` functions anymore. Can only be called by the current owner.
2054      *
2055      * NOTE: Renouncing ownership will leave the contract without an owner,
2056      * thereby removing any functionality that is only available to the owner.
2057      */
2058     function renounceOwnership() public virtual onlyOwner {
2059         _transferOwnership(address(0));
2060     }
2061 
2062     /**
2063      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2064      * Can only be called by the current owner.
2065      */
2066     function transferOwnership(address newOwner) public virtual onlyOwner {
2067         require(newOwner != address(0), "Ownable: new owner is the zero address");
2068         _transferOwnership(newOwner);
2069     }
2070 
2071     /**
2072      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2073      * Internal function without access restriction.
2074      */
2075     function _transferOwnership(address newOwner) internal virtual {
2076         address oldOwner = _owner;
2077         _owner = newOwner;
2078         emit OwnershipTransferred(oldOwner, newOwner);
2079     }
2080 }
2081 
2082 // File: CryptoDoges.sol
2083 
2084 
2085 pragma solidity ^0.8.13;
2086 
2087 
2088 
2089 
2090 
2091 
2092 
2093 
2094 
2095 contract CryptoDoges is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer{
2096             using Strings for uint256;
2097             uint256 public _maxSupply = 10000;
2098             uint256 public maxMintAmountPerWallet = 3;
2099             uint256 public maxMintAmountPerTx = 3;
2100             string baseURL = "";
2101             string ExtensionURL = ".json";
2102             uint256 _initalPrice = 0 ether;
2103             uint256 public costOfNFT = 0 ether;
2104             uint256 public numberOfFreeNFTs = 10000;
2105             
2106             string HiddenURL;
2107             bool revealed = true;
2108             bool paused = false;
2109             
2110             error ContractPaused();
2111             error MaxMintWalletExceeded();
2112             error MaxSupply();
2113             error InvalidMintAmount();
2114             error InsufficientFund();
2115             error NoSmartContract();
2116             error TokenNotExisting();
2117 
2118         constructor(string memory _initBaseURI) ERC721A("CryptoDoges", "DOGE") {
2119             baseURL = _initBaseURI;
2120         }
2121 
2122         // ================== Mint Function =======================
2123 
2124         modifier mintCompliance(uint256 _mintAmount) {
2125             if (msg.sender != tx.origin) revert NoSmartContract();
2126             if (totalSupply()  + _mintAmount > _maxSupply) revert MaxSupply();
2127             if (_mintAmount > maxMintAmountPerTx) revert InvalidMintAmount();
2128             if(paused) revert ContractPaused();
2129             _;
2130         }
2131 
2132         modifier mintPriceCompliance(uint256 _mintAmount) {
2133             if(balanceOf(msg.sender) + _mintAmount > maxMintAmountPerWallet) revert MaxMintWalletExceeded();
2134             if (_mintAmount < 0 || _mintAmount > maxMintAmountPerWallet) revert InvalidMintAmount();
2135               if (msg.value < checkCost(_mintAmount)) revert InsufficientFund();
2136             _;
2137         }
2138         
2139         /// @notice compliance of minting
2140         /// @dev user (msg.sender) mint
2141         /// @param _mintAmount the amount of tokens to mint
2142         function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
2143          
2144           
2145           _safeMint(msg.sender, _mintAmount);
2146           }
2147 
2148         /// @dev user (msg.sender) mint
2149         /// @param _mintAmount the amount of tokens to mint 
2150         /// @return value from number to mint
2151         function checkCost(uint256 _mintAmount) public view returns (uint256) {
2152           uint256 totalMints = _mintAmount + balanceOf(msg.sender);
2153           if ((totalMints <= numberOfFreeNFTs) ) {
2154           return _initalPrice;
2155           } else if ((balanceOf(msg.sender) == 0) && (totalMints > numberOfFreeNFTs) ) { 
2156           uint256 total = costOfNFT * (_mintAmount - numberOfFreeNFTs);
2157           return total;
2158           } 
2159           else {
2160           uint256 total2 = costOfNFT * _mintAmount;
2161           return total2;
2162             }
2163         }
2164         
2165 
2166 
2167         /// @notice airdrop function to airdrop same amount of tokens to addresses
2168         /// @dev only owner function
2169         /// @param accounts  array of addresses
2170         /// @param amount the amount of tokens to airdrop users
2171         function airdrop(address[] memory accounts, uint256 amount)public onlyOwner mintCompliance(amount) {
2172           for(uint256 i = 0; i < accounts.length; i++){
2173           _safeMint(accounts[i], amount);
2174           }
2175         }
2176 
2177         // =================== Orange Functions (Owner Only) ===============
2178 
2179         /// @dev pause/unpause minting
2180         function pause() public onlyOwner {
2181           paused = !paused;
2182         }
2183 
2184         
2185 
2186         /// @dev set URI
2187         /// @param uri  new URI
2188         function setbaseURL(string memory uri) public onlyOwner{
2189           baseURL = uri;
2190         }
2191 
2192         /// @dev extension URI like 'json'
2193         function setExtensionURL(string memory uri) public onlyOwner{
2194           ExtensionURL = uri;
2195         }
2196         
2197         /// @dev set new cost of tokenId in WEI
2198         /// @param _cost  new price in wei
2199         function setCostPrice(uint256 _cost) public onlyOwner{
2200           costOfNFT = _cost;
2201         } 
2202 
2203         /// @dev only owner
2204         /// @param perTx  new max mint per transaction
2205         function setMaxMintAmountPerTx(uint256 perTx) public onlyOwner{
2206           maxMintAmountPerTx = perTx;
2207         }
2208 
2209         /// @dev only owner
2210         /// @param perWallet  new max mint per wallet
2211         function setMaxMintAmountPerWallet(uint256 perWallet) public onlyOwner{
2212           maxMintAmountPerWallet = perWallet;
2213         }  
2214         
2215         /// @dev only owner
2216         /// @param perWallet set free number of nft per wallet
2217         function setnumberOfFreeNFTs(uint256 perWallet) public onlyOwner{
2218           numberOfFreeNFTs = perWallet;
2219         }            
2220 
2221         // ================================ Withdraw Function ====================
2222 
2223         /// @notice withdraw ether from contract.
2224         /// @dev only owner function
2225         function withdraw() public onlyOwner nonReentrant{
2226           
2227 
2228           
2229 
2230         (bool owner, ) = payable(owner()).call{value: address(this).balance}('');
2231         require(owner);
2232         }
2233         // =================== Blue Functions (View Only) ====================
2234 
2235         /// @dev return uri of token ID
2236         /// @param tokenId  token ID to find uri for
2237         ///@return value for 'tokenId uri'
2238         function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2239           if (!_exists(tokenId)) revert TokenNotExisting();   
2240 
2241         
2242 
2243         string memory currentBaseURI = _baseURI();
2244         return bytes(currentBaseURI).length > 0
2245         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
2246         : '';
2247         }
2248         
2249         /// @dev tokenId to start (1)
2250         function _startTokenId() internal view virtual override returns (uint256) {
2251           return 1;
2252         }
2253 
2254         ///@dev maxSupply of token
2255         /// @return max supply
2256         function _baseURI() internal view virtual override returns (string memory) {
2257           return baseURL;
2258         }
2259 
2260     
2261         /// @dev internal function to 
2262         /// @param from  user address where token belongs
2263         /// @param to  user address
2264         /// @param tokenId  number of tokenId
2265           function transferFrom(address from, address to, uint256 tokenId) public payable  override onlyAllowedOperator(from) {
2266         super.transferFrom(from, to, tokenId);
2267         }
2268         
2269         /// @dev internal function to 
2270         /// @param from  user address where token belongs
2271         /// @param to  user address
2272         /// @param tokenId  number of tokenId
2273         function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2274         super.safeTransferFrom(from, to, tokenId);
2275         }
2276 
2277         /// @dev internal function to 
2278         /// @param from  user address where token belongs
2279         /// @param to  user address
2280         /// @param tokenId  number of tokenId
2281         function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2282         public payable
2283         override
2284         onlyAllowedOperator(from)
2285         {
2286         super.safeTransferFrom(from, to, tokenId, data);
2287         }
2288 
2289 }