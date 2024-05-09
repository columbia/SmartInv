1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
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
34 // File: operator-filter-registry/src/OperatorFilterer.sol
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
96 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
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
112 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
113 
114 
115 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Contract module that helps prevent reentrant calls to a function.
121  *
122  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
123  * available, which can be applied to functions to make sure there are no nested
124  * (reentrant) calls to them.
125  *
126  * Note that because there is a single `nonReentrant` guard, functions marked as
127  * `nonReentrant` may not call one another. This can be worked around by making
128  * those functions `private`, and then adding `external` `nonReentrant` entry
129  * points to them.
130  *
131  * TIP: If you would like to learn more about reentrancy and alternative ways
132  * to protect against it, check out our blog post
133  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
134  */
135 abstract contract ReentrancyGuard {
136     // Booleans are more expensive than uint256 or any type that takes up a full
137     // word because each write operation emits an extra SLOAD to first read the
138     // slot's contents, replace the bits taken up by the boolean, and then write
139     // back. This is the compiler's defense against contract upgrades and
140     // pointer aliasing, and it cannot be disabled.
141 
142     // The values being non-zero value makes deployment a bit more expensive,
143     // but in exchange the refund on every call to nonReentrant will be lower in
144     // amount. Since refunds are capped to a percentage of the total
145     // transaction's gas, it is best to keep them low in cases like this one, to
146     // increase the likelihood of the full refund coming into effect.
147     uint256 private constant _NOT_ENTERED = 1;
148     uint256 private constant _ENTERED = 2;
149 
150     uint256 private _status;
151 
152     constructor() {
153         _status = _NOT_ENTERED;
154     }
155 
156     /**
157      * @dev Prevents a contract from calling itself, directly or indirectly.
158      * Calling a `nonReentrant` function from another `nonReentrant`
159      * function is not supported. It is possible to prevent this from happening
160      * by making the `nonReentrant` function external, and making it call a
161      * `private` function that does the actual work.
162      */
163     modifier nonReentrant() {
164         _nonReentrantBefore();
165         _;
166         _nonReentrantAfter();
167     }
168 
169     function _nonReentrantBefore() private {
170         // On the first call to nonReentrant, _status will be _NOT_ENTERED
171         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
172 
173         // Any calls to nonReentrant after this point will fail
174         _status = _ENTERED;
175     }
176 
177     function _nonReentrantAfter() private {
178         // By storing the original value once again, a refund is triggered (see
179         // https://eips.ethereum.org/EIPS/eip-2200)
180         _status = _NOT_ENTERED;
181     }
182 }
183 
184 // File: @openzeppelin/contracts/utils/Context.sol
185 
186 
187 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 abstract contract Context {
202     function _msgSender() internal view virtual returns (address) {
203         return msg.sender;
204     }
205 
206     function _msgData() internal view virtual returns (bytes calldata) {
207         return msg.data;
208     }
209 }
210 
211 // File: @openzeppelin/contracts/access/Ownable.sol
212 
213 
214 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 
219 /**
220  * @dev Contract module which provides a basic access control mechanism, where
221  * there is an account (an owner) that can be granted exclusive access to
222  * specific functions.
223  *
224  * By default, the owner account will be the one that deploys the contract. This
225  * can later be changed with {transferOwnership}.
226  *
227  * This module is used through inheritance. It will make available the modifier
228  * `onlyOwner`, which can be applied to your functions to restrict their use to
229  * the owner.
230  */
231 abstract contract Ownable is Context {
232     address private _owner;
233 
234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236     /**
237      * @dev Initializes the contract setting the deployer as the initial owner.
238      */
239     constructor() {
240         _transferOwnership(_msgSender());
241     }
242 
243     /**
244      * @dev Throws if called by any account other than the owner.
245      */
246     modifier onlyOwner() {
247         _checkOwner();
248         _;
249     }
250 
251     /**
252      * @dev Returns the address of the current owner.
253      */
254     function owner() public view virtual returns (address) {
255         return _owner;
256     }
257 
258     /**
259      * @dev Throws if the sender is not the owner.
260      */
261     function _checkOwner() internal view virtual {
262         require(owner() == _msgSender(), "Ownable: caller is not the owner");
263     }
264 
265     /**
266      * @dev Leaves the contract without owner. It will not be possible to call
267      * `onlyOwner` functions anymore. Can only be called by the current owner.
268      *
269      * NOTE: Renouncing ownership will leave the contract without an owner,
270      * thereby removing any functionality that is only available to the owner.
271      */
272     function renounceOwnership() public virtual onlyOwner {
273         _transferOwnership(address(0));
274     }
275 
276     /**
277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
278      * Can only be called by the current owner.
279      */
280     function transferOwnership(address newOwner) public virtual onlyOwner {
281         require(newOwner != address(0), "Ownable: new owner is the zero address");
282         _transferOwnership(newOwner);
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Internal function without access restriction.
288      */
289     function _transferOwnership(address newOwner) internal virtual {
290         address oldOwner = _owner;
291         _owner = newOwner;
292         emit OwnershipTransferred(oldOwner, newOwner);
293     }
294 }
295 
296 // File: erc721a/contracts/IERC721A.sol
297 
298 
299 // ERC721A Contracts v4.2.3
300 // Creator: Chiru Labs
301 
302 pragma solidity ^0.8.4;
303 
304 /**
305  * @dev Interface of ERC721A.
306  */
307 interface IERC721A {
308     /**
309      * The caller must own the token or be an approved operator.
310      */
311     error ApprovalCallerNotOwnerNorApproved();
312 
313     /**
314      * The token does not exist.
315      */
316     error ApprovalQueryForNonexistentToken();
317 
318     /**
319      * Cannot query the balance for the zero address.
320      */
321     error BalanceQueryForZeroAddress();
322 
323     /**
324      * Cannot mint to the zero address.
325      */
326     error MintToZeroAddress();
327 
328     /**
329      * The quantity of tokens minted must be more than zero.
330      */
331     error MintZeroQuantity();
332 
333     /**
334      * The token does not exist.
335      */
336     error OwnerQueryForNonexistentToken();
337 
338     /**
339      * The caller must own the token or be an approved operator.
340      */
341     error TransferCallerNotOwnerNorApproved();
342 
343     /**
344      * The token must be owned by `from`.
345      */
346     error TransferFromIncorrectOwner();
347 
348     /**
349      * Cannot safely transfer to a contract that does not implement the
350      * ERC721Receiver interface.
351      */
352     error TransferToNonERC721ReceiverImplementer();
353 
354     /**
355      * Cannot transfer to the zero address.
356      */
357     error TransferToZeroAddress();
358 
359     /**
360      * The token does not exist.
361      */
362     error URIQueryForNonexistentToken();
363 
364     /**
365      * The `quantity` minted with ERC2309 exceeds the safety limit.
366      */
367     error MintERC2309QuantityExceedsLimit();
368 
369     /**
370      * The `extraData` cannot be set on an unintialized ownership slot.
371      */
372     error OwnershipNotInitializedForExtraData();
373 
374     // =============================================================
375     //                            STRUCTS
376     // =============================================================
377 
378     struct TokenOwnership {
379         // The address of the owner.
380         address addr;
381         // Stores the start time of ownership with minimal overhead for tokenomics.
382         uint64 startTimestamp;
383         // Whether the token has been burned.
384         bool burned;
385         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
386         uint24 extraData;
387     }
388 
389     // =============================================================
390     //                         TOKEN COUNTERS
391     // =============================================================
392 
393     /**
394      * @dev Returns the total number of tokens in existence.
395      * Burned tokens will reduce the count.
396      * To get the total number of tokens minted, please see {_totalMinted}.
397      */
398     function totalSupply() external view returns (uint256);
399 
400     // =============================================================
401     //                            IERC165
402     // =============================================================
403 
404     /**
405      * @dev Returns true if this contract implements the interface defined by
406      * `interfaceId`. See the corresponding
407      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
408      * to learn more about how these ids are created.
409      *
410      * This function call must use less than 30000 gas.
411      */
412     function supportsInterface(bytes4 interfaceId) external view returns (bool);
413 
414     // =============================================================
415     //                            IERC721
416     // =============================================================
417 
418     /**
419      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
422 
423     /**
424      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
425      */
426     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
427 
428     /**
429      * @dev Emitted when `owner` enables or disables
430      * (`approved`) `operator` to manage all of its assets.
431      */
432     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
433 
434     /**
435      * @dev Returns the number of tokens in `owner`'s account.
436      */
437     function balanceOf(address owner) external view returns (uint256 balance);
438 
439     /**
440      * @dev Returns the owner of the `tokenId` token.
441      *
442      * Requirements:
443      *
444      * - `tokenId` must exist.
445      */
446     function ownerOf(uint256 tokenId) external view returns (address owner);
447 
448     /**
449      * @dev Safely transfers `tokenId` token from `from` to `to`,
450      * checking first that contract recipients are aware of the ERC721 protocol
451      * to prevent tokens from being forever locked.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must exist and be owned by `from`.
458      * - If the caller is not `from`, it must be have been allowed to move
459      * this token by either {approve} or {setApprovalForAll}.
460      * - If `to` refers to a smart contract, it must implement
461      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
462      *
463      * Emits a {Transfer} event.
464      */
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 tokenId,
469         bytes calldata data
470     ) external payable;
471 
472     /**
473      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
474      */
475     function safeTransferFrom(
476         address from,
477         address to,
478         uint256 tokenId
479     ) external payable;
480 
481     /**
482      * @dev Transfers `tokenId` from `from` to `to`.
483      *
484      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
485      * whenever possible.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must be owned by `from`.
492      * - If the caller is not `from`, it must be approved to move this token
493      * by either {approve} or {setApprovalForAll}.
494      *
495      * Emits a {Transfer} event.
496      */
497     function transferFrom(
498         address from,
499         address to,
500         uint256 tokenId
501     ) external payable;
502 
503     /**
504      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
505      * The approval is cleared when the token is transferred.
506      *
507      * Only a single account can be approved at a time, so approving the
508      * zero address clears previous approvals.
509      *
510      * Requirements:
511      *
512      * - The caller must own the token or be an approved operator.
513      * - `tokenId` must exist.
514      *
515      * Emits an {Approval} event.
516      */
517     function approve(address to, uint256 tokenId) external payable;
518 
519     /**
520      * @dev Approve or remove `operator` as an operator for the caller.
521      * Operators can call {transferFrom} or {safeTransferFrom}
522      * for any token owned by the caller.
523      *
524      * Requirements:
525      *
526      * - The `operator` cannot be the caller.
527      *
528      * Emits an {ApprovalForAll} event.
529      */
530     function setApprovalForAll(address operator, bool _approved) external;
531 
532     /**
533      * @dev Returns the account approved for `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function getApproved(uint256 tokenId) external view returns (address operator);
540 
541     /**
542      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
543      *
544      * See {setApprovalForAll}.
545      */
546     function isApprovedForAll(address owner, address operator) external view returns (bool);
547 
548     // =============================================================
549     //                        IERC721Metadata
550     // =============================================================
551 
552     /**
553      * @dev Returns the token collection name.
554      */
555     function name() external view returns (string memory);
556 
557     /**
558      * @dev Returns the token collection symbol.
559      */
560     function symbol() external view returns (string memory);
561 
562     /**
563      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
564      */
565     function tokenURI(uint256 tokenId) external view returns (string memory);
566 
567     // =============================================================
568     //                           IERC2309
569     // =============================================================
570 
571     /**
572      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
573      * (inclusive) is transferred from `from` to `to`, as defined in the
574      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
575      *
576      * See {_mintERC2309} for more details.
577      */
578     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
579 }
580 
581 // File: erc721a/contracts/ERC721A.sol
582 
583 
584 // ERC721A Contracts v4.2.3
585 // Creator: Chiru Labs
586 
587 pragma solidity ^0.8.4;
588 
589 
590 /**
591  * @dev Interface of ERC721 token receiver.
592  */
593 interface ERC721A__IERC721Receiver {
594     function onERC721Received(
595         address operator,
596         address from,
597         uint256 tokenId,
598         bytes calldata data
599     ) external returns (bytes4);
600 }
601 
602 /**
603  * @title ERC721A
604  *
605  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
606  * Non-Fungible Token Standard, including the Metadata extension.
607  * Optimized for lower gas during batch mints.
608  *
609  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
610  * starting from `_startTokenId()`.
611  *
612  * Assumptions:
613  *
614  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
615  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
616  */
617 contract ERC721A is IERC721A {
618     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
619     struct TokenApprovalRef {
620         address value;
621     }
622 
623     // =============================================================
624     //                           CONSTANTS
625     // =============================================================
626 
627     // Mask of an entry in packed address data.
628     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
629 
630     // The bit position of `numberMinted` in packed address data.
631     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
632 
633     // The bit position of `numberBurned` in packed address data.
634     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
635 
636     // The bit position of `aux` in packed address data.
637     uint256 private constant _BITPOS_AUX = 192;
638 
639     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
640     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
641 
642     // The bit position of `startTimestamp` in packed ownership.
643     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
644 
645     // The bit mask of the `burned` bit in packed ownership.
646     uint256 private constant _BITMASK_BURNED = 1 << 224;
647 
648     // The bit position of the `nextInitialized` bit in packed ownership.
649     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
650 
651     // The bit mask of the `nextInitialized` bit in packed ownership.
652     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
653 
654     // The bit position of `extraData` in packed ownership.
655     uint256 private constant _BITPOS_EXTRA_DATA = 232;
656 
657     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
658     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
659 
660     // The mask of the lower 160 bits for addresses.
661     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
662 
663     // The maximum `quantity` that can be minted with {_mintERC2309}.
664     // This limit is to prevent overflows on the address data entries.
665     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
666     // is required to cause an overflow, which is unrealistic.
667     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
668 
669     // The `Transfer` event signature is given by:
670     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
671     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
672         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
673 
674     // =============================================================
675     //                            STORAGE
676     // =============================================================
677 
678     // The next token ID to be minted.
679     uint256 private _currentIndex;
680 
681     // The number of tokens burned.
682     uint256 private _burnCounter;
683 
684     // Token name
685     string private _name;
686 
687     // Token symbol
688     string private _symbol;
689 
690     // Mapping from token ID to ownership details
691     // An empty struct value does not necessarily mean the token is unowned.
692     // See {_packedOwnershipOf} implementation for details.
693     //
694     // Bits Layout:
695     // - [0..159]   `addr`
696     // - [160..223] `startTimestamp`
697     // - [224]      `burned`
698     // - [225]      `nextInitialized`
699     // - [232..255] `extraData`
700     mapping(uint256 => uint256) private _packedOwnerships;
701 
702     // Mapping owner address to address data.
703     //
704     // Bits Layout:
705     // - [0..63]    `balance`
706     // - [64..127]  `numberMinted`
707     // - [128..191] `numberBurned`
708     // - [192..255] `aux`
709     mapping(address => uint256) private _packedAddressData;
710 
711     // Mapping from token ID to approved address.
712     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
713 
714     // Mapping from owner to operator approvals
715     mapping(address => mapping(address => bool)) private _operatorApprovals;
716 
717     // =============================================================
718     //                          CONSTRUCTOR
719     // =============================================================
720 
721     constructor(string memory name_, string memory symbol_) {
722         _name = name_;
723         _symbol = symbol_;
724         _currentIndex = _startTokenId();
725     }
726 
727     // =============================================================
728     //                   TOKEN COUNTING OPERATIONS
729     // =============================================================
730 
731     /**
732      * @dev Returns the starting token ID.
733      * To change the starting token ID, please override this function.
734      */
735     function _startTokenId() internal view virtual returns (uint256) {
736         return 0;
737     }
738 
739     /**
740      * @dev Returns the next token ID to be minted.
741      */
742     function _nextTokenId() internal view virtual returns (uint256) {
743         return _currentIndex;
744     }
745 
746     /**
747      * @dev Returns the total number of tokens in existence.
748      * Burned tokens will reduce the count.
749      * To get the total number of tokens minted, please see {_totalMinted}.
750      */
751     function totalSupply() public view virtual override returns (uint256) {
752         // Counter underflow is impossible as _burnCounter cannot be incremented
753         // more than `_currentIndex - _startTokenId()` times.
754         unchecked {
755             return _currentIndex - _burnCounter - _startTokenId();
756         }
757     }
758 
759     /**
760      * @dev Returns the total amount of tokens minted in the contract.
761      */
762     function _totalMinted() internal view virtual returns (uint256) {
763         // Counter underflow is impossible as `_currentIndex` does not decrement,
764         // and it is initialized to `_startTokenId()`.
765         unchecked {
766             return _currentIndex - _startTokenId();
767         }
768     }
769 
770     /**
771      * @dev Returns the total number of tokens burned.
772      */
773     function _totalBurned() internal view virtual returns (uint256) {
774         return _burnCounter;
775     }
776 
777     // =============================================================
778     //                    ADDRESS DATA OPERATIONS
779     // =============================================================
780 
781     /**
782      * @dev Returns the number of tokens in `owner`'s account.
783      */
784     function balanceOf(address owner) public view virtual override returns (uint256) {
785         if (owner == address(0)) revert BalanceQueryForZeroAddress();
786         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
787     }
788 
789     /**
790      * Returns the number of tokens minted by `owner`.
791      */
792     function _numberMinted(address owner) internal view returns (uint256) {
793         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
794     }
795 
796     /**
797      * Returns the number of tokens burned by or on behalf of `owner`.
798      */
799     function _numberBurned(address owner) internal view returns (uint256) {
800         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
801     }
802 
803     /**
804      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
805      */
806     function _getAux(address owner) internal view returns (uint64) {
807         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
808     }
809 
810     /**
811      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
812      * If there are multiple variables, please pack them into a uint64.
813      */
814     function _setAux(address owner, uint64 aux) internal virtual {
815         uint256 packed = _packedAddressData[owner];
816         uint256 auxCasted;
817         // Cast `aux` with assembly to avoid redundant masking.
818         assembly {
819             auxCasted := aux
820         }
821         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
822         _packedAddressData[owner] = packed;
823     }
824 
825     // =============================================================
826     //                            IERC165
827     // =============================================================
828 
829     /**
830      * @dev Returns true if this contract implements the interface defined by
831      * `interfaceId`. See the corresponding
832      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
833      * to learn more about how these ids are created.
834      *
835      * This function call must use less than 30000 gas.
836      */
837     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
838         // The interface IDs are constants representing the first 4 bytes
839         // of the XOR of all function selectors in the interface.
840         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
841         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
842         return
843             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
844             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
845             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
846     }
847 
848     // =============================================================
849     //                        IERC721Metadata
850     // =============================================================
851 
852     /**
853      * @dev Returns the token collection name.
854      */
855     function name() public view virtual override returns (string memory) {
856         return _name;
857     }
858 
859     /**
860      * @dev Returns the token collection symbol.
861      */
862     function symbol() public view virtual override returns (string memory) {
863         return _symbol;
864     }
865 
866     /**
867      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
868      */
869     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
870         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
871 
872         string memory baseURI = _baseURI();
873         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
874     }
875 
876     /**
877      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
878      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
879      * by default, it can be overridden in child contracts.
880      */
881     function _baseURI() internal view virtual returns (string memory) {
882         return '';
883     }
884 
885     // =============================================================
886     //                     OWNERSHIPS OPERATIONS
887     // =============================================================
888 
889     /**
890      * @dev Returns the owner of the `tokenId` token.
891      *
892      * Requirements:
893      *
894      * - `tokenId` must exist.
895      */
896     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
897         return address(uint160(_packedOwnershipOf(tokenId)));
898     }
899 
900     /**
901      * @dev Gas spent here starts off proportional to the maximum mint batch size.
902      * It gradually moves to O(1) as tokens get transferred around over time.
903      */
904     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
905         return _unpackedOwnership(_packedOwnershipOf(tokenId));
906     }
907 
908     /**
909      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
910      */
911     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
912         return _unpackedOwnership(_packedOwnerships[index]);
913     }
914 
915     /**
916      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
917      */
918     function _initializeOwnershipAt(uint256 index) internal virtual {
919         if (_packedOwnerships[index] == 0) {
920             _packedOwnerships[index] = _packedOwnershipOf(index);
921         }
922     }
923 
924     /**
925      * Returns the packed ownership data of `tokenId`.
926      */
927     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
928         uint256 curr = tokenId;
929 
930         unchecked {
931             if (_startTokenId() <= curr)
932                 if (curr < _currentIndex) {
933                     uint256 packed = _packedOwnerships[curr];
934                     // If not burned.
935                     if (packed & _BITMASK_BURNED == 0) {
936                         // Invariant:
937                         // There will always be an initialized ownership slot
938                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
939                         // before an unintialized ownership slot
940                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
941                         // Hence, `curr` will not underflow.
942                         //
943                         // We can directly compare the packed value.
944                         // If the address is zero, packed will be zero.
945                         while (packed == 0) {
946                             packed = _packedOwnerships[--curr];
947                         }
948                         return packed;
949                     }
950                 }
951         }
952         revert OwnerQueryForNonexistentToken();
953     }
954 
955     /**
956      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
957      */
958     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
959         ownership.addr = address(uint160(packed));
960         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
961         ownership.burned = packed & _BITMASK_BURNED != 0;
962         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
963     }
964 
965     /**
966      * @dev Packs ownership data into a single uint256.
967      */
968     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
969         assembly {
970             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
971             owner := and(owner, _BITMASK_ADDRESS)
972             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
973             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
974         }
975     }
976 
977     /**
978      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
979      */
980     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
981         // For branchless setting of the `nextInitialized` flag.
982         assembly {
983             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
984             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
985         }
986     }
987 
988     // =============================================================
989     //                      APPROVAL OPERATIONS
990     // =============================================================
991 
992     /**
993      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
994      * The approval is cleared when the token is transferred.
995      *
996      * Only a single account can be approved at a time, so approving the
997      * zero address clears previous approvals.
998      *
999      * Requirements:
1000      *
1001      * - The caller must own the token or be an approved operator.
1002      * - `tokenId` must exist.
1003      *
1004      * Emits an {Approval} event.
1005      */
1006     function approve(address to, uint256 tokenId) public payable virtual override {
1007         address owner = ownerOf(tokenId);
1008 
1009         if (_msgSenderERC721A() != owner)
1010             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1011                 revert ApprovalCallerNotOwnerNorApproved();
1012             }
1013 
1014         _tokenApprovals[tokenId].value = to;
1015         emit Approval(owner, to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev Returns the account approved for `tokenId` token.
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must exist.
1024      */
1025     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1026         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1027 
1028         return _tokenApprovals[tokenId].value;
1029     }
1030 
1031     /**
1032      * @dev Approve or remove `operator` as an operator for the caller.
1033      * Operators can call {transferFrom} or {safeTransferFrom}
1034      * for any token owned by the caller.
1035      *
1036      * Requirements:
1037      *
1038      * - The `operator` cannot be the caller.
1039      *
1040      * Emits an {ApprovalForAll} event.
1041      */
1042     function setApprovalForAll(address operator, bool approved) public virtual override {
1043         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1044         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1045     }
1046 
1047     /**
1048      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1049      *
1050      * See {setApprovalForAll}.
1051      */
1052     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1053         return _operatorApprovals[owner][operator];
1054     }
1055 
1056     /**
1057      * @dev Returns whether `tokenId` exists.
1058      *
1059      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1060      *
1061      * Tokens start existing when they are minted. See {_mint}.
1062      */
1063     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1064         return
1065             _startTokenId() <= tokenId &&
1066             tokenId < _currentIndex && // If within bounds,
1067             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1068     }
1069 
1070     /**
1071      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1072      */
1073     function _isSenderApprovedOrOwner(
1074         address approvedAddress,
1075         address owner,
1076         address msgSender
1077     ) private pure returns (bool result) {
1078         assembly {
1079             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1080             owner := and(owner, _BITMASK_ADDRESS)
1081             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1082             msgSender := and(msgSender, _BITMASK_ADDRESS)
1083             // `msgSender == owner || msgSender == approvedAddress`.
1084             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1085         }
1086     }
1087 
1088     /**
1089      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1090      */
1091     function _getApprovedSlotAndAddress(uint256 tokenId)
1092         private
1093         view
1094         returns (uint256 approvedAddressSlot, address approvedAddress)
1095     {
1096         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1097         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1098         assembly {
1099             approvedAddressSlot := tokenApproval.slot
1100             approvedAddress := sload(approvedAddressSlot)
1101         }
1102     }
1103 
1104     // =============================================================
1105     //                      TRANSFER OPERATIONS
1106     // =============================================================
1107 
1108     /**
1109      * @dev Transfers `tokenId` from `from` to `to`.
1110      *
1111      * Requirements:
1112      *
1113      * - `from` cannot be the zero address.
1114      * - `to` cannot be the zero address.
1115      * - `tokenId` token must be owned by `from`.
1116      * - If the caller is not `from`, it must be approved to move this token
1117      * by either {approve} or {setApprovalForAll}.
1118      *
1119      * Emits a {Transfer} event.
1120      */
1121     function transferFrom(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) public payable virtual override {
1126         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1127 
1128         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1129 
1130         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1131 
1132         // The nested ifs save around 20+ gas over a compound boolean condition.
1133         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1134             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1135 
1136         if (to == address(0)) revert TransferToZeroAddress();
1137 
1138         _beforeTokenTransfers(from, to, tokenId, 1);
1139 
1140         // Clear approvals from the previous owner.
1141         assembly {
1142             if approvedAddress {
1143                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1144                 sstore(approvedAddressSlot, 0)
1145             }
1146         }
1147 
1148         // Underflow of the sender's balance is impossible because we check for
1149         // ownership above and the recipient's balance can't realistically overflow.
1150         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1151         unchecked {
1152             // We can directly increment and decrement the balances.
1153             --_packedAddressData[from]; // Updates: `balance -= 1`.
1154             ++_packedAddressData[to]; // Updates: `balance += 1`.
1155 
1156             // Updates:
1157             // - `address` to the next owner.
1158             // - `startTimestamp` to the timestamp of transfering.
1159             // - `burned` to `false`.
1160             // - `nextInitialized` to `true`.
1161             _packedOwnerships[tokenId] = _packOwnershipData(
1162                 to,
1163                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1164             );
1165 
1166             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1167             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1168                 uint256 nextTokenId = tokenId + 1;
1169                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1170                 if (_packedOwnerships[nextTokenId] == 0) {
1171                     // If the next slot is within bounds.
1172                     if (nextTokenId != _currentIndex) {
1173                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1174                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1175                     }
1176                 }
1177             }
1178         }
1179 
1180         emit Transfer(from, to, tokenId);
1181         _afterTokenTransfers(from, to, tokenId, 1);
1182     }
1183 
1184     /**
1185      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1186      */
1187     function safeTransferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) public payable virtual override {
1192         safeTransferFrom(from, to, tokenId, '');
1193     }
1194 
1195     /**
1196      * @dev Safely transfers `tokenId` token from `from` to `to`.
1197      *
1198      * Requirements:
1199      *
1200      * - `from` cannot be the zero address.
1201      * - `to` cannot be the zero address.
1202      * - `tokenId` token must exist and be owned by `from`.
1203      * - If the caller is not `from`, it must be approved to move this token
1204      * by either {approve} or {setApprovalForAll}.
1205      * - If `to` refers to a smart contract, it must implement
1206      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function safeTransferFrom(
1211         address from,
1212         address to,
1213         uint256 tokenId,
1214         bytes memory _data
1215     ) public payable virtual override {
1216         transferFrom(from, to, tokenId);
1217         if (to.code.length != 0)
1218             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1219                 revert TransferToNonERC721ReceiverImplementer();
1220             }
1221     }
1222 
1223     /**
1224      * @dev Hook that is called before a set of serially-ordered token IDs
1225      * are about to be transferred. This includes minting.
1226      * And also called before burning one token.
1227      *
1228      * `startTokenId` - the first token ID to be transferred.
1229      * `quantity` - the amount to be transferred.
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      * - When `to` is zero, `tokenId` will be burned by `from`.
1237      * - `from` and `to` are never both zero.
1238      */
1239     function _beforeTokenTransfers(
1240         address from,
1241         address to,
1242         uint256 startTokenId,
1243         uint256 quantity
1244     ) internal virtual {}
1245 
1246     /**
1247      * @dev Hook that is called after a set of serially-ordered token IDs
1248      * have been transferred. This includes minting.
1249      * And also called after one token has been burned.
1250      *
1251      * `startTokenId` - the first token ID to be transferred.
1252      * `quantity` - the amount to be transferred.
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` has been minted for `to`.
1259      * - When `to` is zero, `tokenId` has been burned by `from`.
1260      * - `from` and `to` are never both zero.
1261      */
1262     function _afterTokenTransfers(
1263         address from,
1264         address to,
1265         uint256 startTokenId,
1266         uint256 quantity
1267     ) internal virtual {}
1268 
1269     /**
1270      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1271      *
1272      * `from` - Previous owner of the given token ID.
1273      * `to` - Target address that will receive the token.
1274      * `tokenId` - Token ID to be transferred.
1275      * `_data` - Optional data to send along with the call.
1276      *
1277      * Returns whether the call correctly returned the expected magic value.
1278      */
1279     function _checkContractOnERC721Received(
1280         address from,
1281         address to,
1282         uint256 tokenId,
1283         bytes memory _data
1284     ) private returns (bool) {
1285         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1286             bytes4 retval
1287         ) {
1288             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1289         } catch (bytes memory reason) {
1290             if (reason.length == 0) {
1291                 revert TransferToNonERC721ReceiverImplementer();
1292             } else {
1293                 assembly {
1294                     revert(add(32, reason), mload(reason))
1295                 }
1296             }
1297         }
1298     }
1299 
1300     // =============================================================
1301     //                        MINT OPERATIONS
1302     // =============================================================
1303 
1304     /**
1305      * @dev Mints `quantity` tokens and transfers them to `to`.
1306      *
1307      * Requirements:
1308      *
1309      * - `to` cannot be the zero address.
1310      * - `quantity` must be greater than 0.
1311      *
1312      * Emits a {Transfer} event for each mint.
1313      */
1314     function _mint(address to, uint256 quantity) internal virtual {
1315         uint256 startTokenId = _currentIndex;
1316         if (quantity == 0) revert MintZeroQuantity();
1317 
1318         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1319 
1320         // Overflows are incredibly unrealistic.
1321         // `balance` and `numberMinted` have a maximum limit of 2**64.
1322         // `tokenId` has a maximum limit of 2**256.
1323         unchecked {
1324             // Updates:
1325             // - `balance += quantity`.
1326             // - `numberMinted += quantity`.
1327             //
1328             // We can directly add to the `balance` and `numberMinted`.
1329             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1330 
1331             // Updates:
1332             // - `address` to the owner.
1333             // - `startTimestamp` to the timestamp of minting.
1334             // - `burned` to `false`.
1335             // - `nextInitialized` to `quantity == 1`.
1336             _packedOwnerships[startTokenId] = _packOwnershipData(
1337                 to,
1338                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1339             );
1340 
1341             uint256 toMasked;
1342             uint256 end = startTokenId + quantity;
1343 
1344             // Use assembly to loop and emit the `Transfer` event for gas savings.
1345             // The duplicated `log4` removes an extra check and reduces stack juggling.
1346             // The assembly, together with the surrounding Solidity code, have been
1347             // delicately arranged to nudge the compiler into producing optimized opcodes.
1348             assembly {
1349                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1350                 toMasked := and(to, _BITMASK_ADDRESS)
1351                 // Emit the `Transfer` event.
1352                 log4(
1353                     0, // Start of data (0, since no data).
1354                     0, // End of data (0, since no data).
1355                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1356                     0, // `address(0)`.
1357                     toMasked, // `to`.
1358                     startTokenId // `tokenId`.
1359                 )
1360 
1361                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1362                 // that overflows uint256 will make the loop run out of gas.
1363                 // The compiler will optimize the `iszero` away for performance.
1364                 for {
1365                     let tokenId := add(startTokenId, 1)
1366                 } iszero(eq(tokenId, end)) {
1367                     tokenId := add(tokenId, 1)
1368                 } {
1369                     // Emit the `Transfer` event. Similar to above.
1370                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1371                 }
1372             }
1373             if (toMasked == 0) revert MintToZeroAddress();
1374 
1375             _currentIndex = end;
1376         }
1377         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1378     }
1379 
1380     /**
1381      * @dev Mints `quantity` tokens and transfers them to `to`.
1382      *
1383      * This function is intended for efficient minting only during contract creation.
1384      *
1385      * It emits only one {ConsecutiveTransfer} as defined in
1386      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1387      * instead of a sequence of {Transfer} event(s).
1388      *
1389      * Calling this function outside of contract creation WILL make your contract
1390      * non-compliant with the ERC721 standard.
1391      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1392      * {ConsecutiveTransfer} event is only permissible during contract creation.
1393      *
1394      * Requirements:
1395      *
1396      * - `to` cannot be the zero address.
1397      * - `quantity` must be greater than 0.
1398      *
1399      * Emits a {ConsecutiveTransfer} event.
1400      */
1401     function _mintERC2309(address to, uint256 quantity) internal virtual {
1402         uint256 startTokenId = _currentIndex;
1403         if (to == address(0)) revert MintToZeroAddress();
1404         if (quantity == 0) revert MintZeroQuantity();
1405         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1406 
1407         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1408 
1409         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1410         unchecked {
1411             // Updates:
1412             // - `balance += quantity`.
1413             // - `numberMinted += quantity`.
1414             //
1415             // We can directly add to the `balance` and `numberMinted`.
1416             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1417 
1418             // Updates:
1419             // - `address` to the owner.
1420             // - `startTimestamp` to the timestamp of minting.
1421             // - `burned` to `false`.
1422             // - `nextInitialized` to `quantity == 1`.
1423             _packedOwnerships[startTokenId] = _packOwnershipData(
1424                 to,
1425                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1426             );
1427 
1428             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1429 
1430             _currentIndex = startTokenId + quantity;
1431         }
1432         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1433     }
1434 
1435     /**
1436      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1437      *
1438      * Requirements:
1439      *
1440      * - If `to` refers to a smart contract, it must implement
1441      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1442      * - `quantity` must be greater than 0.
1443      *
1444      * See {_mint}.
1445      *
1446      * Emits a {Transfer} event for each mint.
1447      */
1448     function _safeMint(
1449         address to,
1450         uint256 quantity,
1451         bytes memory _data
1452     ) internal virtual {
1453         _mint(to, quantity);
1454 
1455         unchecked {
1456             if (to.code.length != 0) {
1457                 uint256 end = _currentIndex;
1458                 uint256 index = end - quantity;
1459                 do {
1460                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1461                         revert TransferToNonERC721ReceiverImplementer();
1462                     }
1463                 } while (index < end);
1464                 // Reentrancy protection.
1465                 if (_currentIndex != end) revert();
1466             }
1467         }
1468     }
1469 
1470     /**
1471      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1472      */
1473     function _safeMint(address to, uint256 quantity) internal virtual {
1474         _safeMint(to, quantity, '');
1475     }
1476 
1477     // =============================================================
1478     //                        BURN OPERATIONS
1479     // =============================================================
1480 
1481     /**
1482      * @dev Equivalent to `_burn(tokenId, false)`.
1483      */
1484     function _burn(uint256 tokenId) internal virtual {
1485         _burn(tokenId, false);
1486     }
1487 
1488     /**
1489      * @dev Destroys `tokenId`.
1490      * The approval is cleared when the token is burned.
1491      *
1492      * Requirements:
1493      *
1494      * - `tokenId` must exist.
1495      *
1496      * Emits a {Transfer} event.
1497      */
1498     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1499         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1500 
1501         address from = address(uint160(prevOwnershipPacked));
1502 
1503         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1504 
1505         if (approvalCheck) {
1506             // The nested ifs save around 20+ gas over a compound boolean condition.
1507             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1508                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1509         }
1510 
1511         _beforeTokenTransfers(from, address(0), tokenId, 1);
1512 
1513         // Clear approvals from the previous owner.
1514         assembly {
1515             if approvedAddress {
1516                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1517                 sstore(approvedAddressSlot, 0)
1518             }
1519         }
1520 
1521         // Underflow of the sender's balance is impossible because we check for
1522         // ownership above and the recipient's balance can't realistically overflow.
1523         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1524         unchecked {
1525             // Updates:
1526             // - `balance -= 1`.
1527             // - `numberBurned += 1`.
1528             //
1529             // We can directly decrement the balance, and increment the number burned.
1530             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1531             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1532 
1533             // Updates:
1534             // - `address` to the last owner.
1535             // - `startTimestamp` to the timestamp of burning.
1536             // - `burned` to `true`.
1537             // - `nextInitialized` to `true`.
1538             _packedOwnerships[tokenId] = _packOwnershipData(
1539                 from,
1540                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1541             );
1542 
1543             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1544             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1545                 uint256 nextTokenId = tokenId + 1;
1546                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1547                 if (_packedOwnerships[nextTokenId] == 0) {
1548                     // If the next slot is within bounds.
1549                     if (nextTokenId != _currentIndex) {
1550                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1551                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1552                     }
1553                 }
1554             }
1555         }
1556 
1557         emit Transfer(from, address(0), tokenId);
1558         _afterTokenTransfers(from, address(0), tokenId, 1);
1559 
1560         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1561         unchecked {
1562             _burnCounter++;
1563         }
1564     }
1565 
1566     // =============================================================
1567     //                     EXTRA DATA OPERATIONS
1568     // =============================================================
1569 
1570     /**
1571      * @dev Directly sets the extra data for the ownership data `index`.
1572      */
1573     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1574         uint256 packed = _packedOwnerships[index];
1575         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1576         uint256 extraDataCasted;
1577         // Cast `extraData` with assembly to avoid redundant masking.
1578         assembly {
1579             extraDataCasted := extraData
1580         }
1581         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1582         _packedOwnerships[index] = packed;
1583     }
1584 
1585     /**
1586      * @dev Called during each token transfer to set the 24bit `extraData` field.
1587      * Intended to be overridden by the cosumer contract.
1588      *
1589      * `previousExtraData` - the value of `extraData` before transfer.
1590      *
1591      * Calling conditions:
1592      *
1593      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1594      * transferred to `to`.
1595      * - When `from` is zero, `tokenId` will be minted for `to`.
1596      * - When `to` is zero, `tokenId` will be burned by `from`.
1597      * - `from` and `to` are never both zero.
1598      */
1599     function _extraData(
1600         address from,
1601         address to,
1602         uint24 previousExtraData
1603     ) internal view virtual returns (uint24) {}
1604 
1605     /**
1606      * @dev Returns the next extra data for the packed ownership data.
1607      * The returned result is shifted into position.
1608      */
1609     function _nextExtraData(
1610         address from,
1611         address to,
1612         uint256 prevOwnershipPacked
1613     ) private view returns (uint256) {
1614         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1615         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1616     }
1617 
1618     // =============================================================
1619     //                       OTHER OPERATIONS
1620     // =============================================================
1621 
1622     /**
1623      * @dev Returns the message sender (defaults to `msg.sender`).
1624      *
1625      * If you are writing GSN compatible contracts, you need to override this function.
1626      */
1627     function _msgSenderERC721A() internal view virtual returns (address) {
1628         return msg.sender;
1629     }
1630 
1631     /**
1632      * @dev Converts a uint256 to its ASCII string decimal representation.
1633      */
1634     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1635         assembly {
1636             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1637             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1638             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1639             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1640             let m := add(mload(0x40), 0xa0)
1641             // Update the free memory pointer to allocate.
1642             mstore(0x40, m)
1643             // Assign the `str` to the end.
1644             str := sub(m, 0x20)
1645             // Zeroize the slot after the string.
1646             mstore(str, 0)
1647 
1648             // Cache the end of the memory to calculate the length later.
1649             let end := str
1650 
1651             // We write the string from rightmost digit to leftmost digit.
1652             // The following is essentially a do-while loop that also handles the zero case.
1653             // prettier-ignore
1654             for { let temp := value } 1 {} {
1655                 str := sub(str, 1)
1656                 // Write the character to the pointer.
1657                 // The ASCII index of the '0' character is 48.
1658                 mstore8(str, add(48, mod(temp, 10)))
1659                 // Keep dividing `temp` until zero.
1660                 temp := div(temp, 10)
1661                 // prettier-ignore
1662                 if iszero(temp) { break }
1663             }
1664 
1665             let length := sub(end, str)
1666             // Move the pointer 32 bytes leftwards to make room for the length.
1667             str := sub(str, 0x20)
1668             // Store the length.
1669             mstore(str, length)
1670         }
1671     }
1672 }
1673 
1674 // File: headstailssfinal.sol
1675 
1676 
1677 
1678 //Developer : FazelPejmanfar , Twitter :@Pejmanfarfazel
1679 
1680 
1681 
1682 pragma solidity >=0.7.0 <0.9.0;
1683 
1684 
1685 
1686 
1687 
1688 contract HeadsorTails is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
1689 
1690 
1691   string public baseURI;
1692   string public notRevealedUri;
1693   uint256 public cost = 0.005 ether;
1694   uint256 public maxSupply = 3636;
1695   uint256 public MaxperWallet = 10;
1696   bool public paused = true;
1697   bool public revealed = false;
1698   mapping (address => uint256) public PublicMintofUser;
1699 
1700   constructor() ERC721A("Heads or Tails", "HEADTAIL") {}
1701 
1702   // internal
1703   function _baseURI() internal view virtual override returns (string memory) {
1704     return baseURI;
1705   }
1706       function _startTokenId() internal view virtual override returns (uint256) {
1707         return 1;
1708     }
1709 
1710   // public
1711   /// @dev Public mint 
1712   function mint(uint256 tokens) public payable nonReentrant {
1713     require(!paused, "HEADTAIL: oops contract is paused");
1714     require(tokens <= 5, "HEADTAIL: max mint amount per tx exceeded");
1715     require(totalSupply() + tokens <= maxSupply, "HEADTAIL: We Soldout");
1716     require(PublicMintofUser[_msgSenderERC721A()] + tokens <= MaxperWallet, "HEADTAIL: Max NFT Per Wallet exceeded");
1717     require(msg.value >= cost * tokens, "HEADTAIL: insufficient funds");
1718 
1719        PublicMintofUser[_msgSenderERC721A()] += tokens;
1720       _safeMint(_msgSenderERC721A(), tokens);
1721     
1722   }
1723 
1724   /// @dev use it for giveaway and team mint
1725      function airdrop(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
1726     require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1727 
1728       _safeMint(destination, _mintAmount);
1729   }
1730 
1731 /// @notice returns metadata link of tokenid
1732   function tokenURI(uint256 tokenId)
1733     public
1734     view
1735     virtual
1736     override
1737     returns (string memory)
1738   {
1739     require(
1740       _exists(tokenId),
1741       "ERC721AMetadata: URI query for nonexistent token"
1742     );
1743     
1744     if(revealed == false) {
1745         return notRevealedUri;
1746     }
1747 
1748     string memory currentBaseURI = _baseURI();
1749     return bytes(currentBaseURI).length > 0
1750         ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), ".json"))
1751         : "";
1752   }
1753 
1754      /// @notice return the number minted by an address
1755     function numberMinted(address owner) public view returns (uint256) {
1756     return _numberMinted(owner);
1757   }
1758 
1759     /// @notice return the tokens owned by an address
1760       function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1761         unchecked {
1762             uint256 tokenIdsIdx;
1763             address currOwnershipAddr;
1764             uint256 tokenIdsLength = balanceOf(owner);
1765             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1766             TokenOwnership memory ownership;
1767             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1768                 ownership = _ownershipAt(i);
1769                 if (ownership.burned) {
1770                     continue;
1771                 }
1772                 if (ownership.addr != address(0)) {
1773                     currOwnershipAddr = ownership.addr;
1774                 }
1775                 if (currOwnershipAddr == owner) {
1776                     tokenIds[tokenIdsIdx++] = i;
1777                 }
1778             }
1779             return tokenIds;
1780         }
1781     }
1782 
1783   //only owner
1784   function reveal(bool _state) public onlyOwner {
1785       revealed = _state;
1786   }
1787 
1788   /// @dev change the public max per wallet
1789   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1790     MaxperWallet = _limit;
1791   }
1792 
1793    /// @dev change the public price(amount need to be in wei)
1794   function setCost(uint256 _newCost) public onlyOwner {
1795     cost = _newCost;
1796   }
1797 
1798 
1799   /// @dev cut the supply if we dont sold out
1800     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1801     maxSupply = _newsupply;
1802   }
1803 
1804  /// @dev set your baseuri
1805   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1806     baseURI = _newBaseURI;
1807   }
1808 
1809    /// @dev set hidden uri
1810   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1811     notRevealedUri = _notRevealedURI;
1812   }
1813 
1814  /// @dev to pause and unpause your contract(use booleans true or false)
1815   function pause(bool _state) public onlyOwner {
1816     paused = _state;
1817   }
1818   
1819   /// @dev withdraw funds from contract
1820   function withdraw() public payable onlyOwner nonReentrant {
1821       uint256 balance = address(this).balance;
1822       payable(_msgSenderERC721A()).transfer(balance);
1823   }
1824 
1825 
1826   /// Opensea Royalties
1827 
1828     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1829     super.transferFrom(from, to, tokenId);
1830   }
1831 
1832   function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1833     super.safeTransferFrom(from, to, tokenId);
1834   }
1835 
1836   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
1837     super.safeTransferFrom(from, to, tokenId, data);
1838   }  
1839 }