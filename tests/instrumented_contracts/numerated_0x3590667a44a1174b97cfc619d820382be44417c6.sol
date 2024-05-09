1 // SPDX-License-Identifier: MIT
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
32 
33 
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
44  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
45  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
46  */
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
58             if (subscribe) {
59                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     OPERATOR_FILTER_REGISTRY.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Check registry code length to facilitate testing in environments without a deployed registry.
72         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
73             // Allow spending tokens from addresses with balance
74             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
75             // from an EOA.
76             if (from == msg.sender) {
77                 _;
78                 return;
79             }
80             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
81                 revert OperatorNotAllowed(msg.sender);
82             }
83         }
84         _;
85     }
86 
87     modifier onlyAllowedOperatorApproval(address operator) virtual {
88         // Check registry code length to facilitate testing in environments without a deployed registry.
89         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
90             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
91                 revert OperatorNotAllowed(operator);
92             }
93         }
94         _;
95     }
96 }
97 
98 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/DefaultOperatorFilterer.sol
99 
100 
101 pragma solidity ^0.8.13;
102 
103 
104 /**
105  * @title  DefaultOperatorFilterer
106  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
107  */
108 abstract contract DefaultOperatorFilterer is OperatorFilterer {
109     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
110 
111     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
112 }
113 
114 // File: @openzeppelin/contracts/utils/Context.sol
115 
116 
117 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 // File: @openzeppelin/contracts/access/Ownable.sol
142 
143 
144 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 
149 /**
150  * @dev Contract module which provides a basic access control mechanism, where
151  * there is an account (an owner) that can be granted exclusive access to
152  * specific functions.
153  *
154  * By default, the owner account will be the one that deploys the contract. This
155  * can later be changed with {transferOwnership}.
156  *
157  * This module is used through inheritance. It will make available the modifier
158  * `onlyOwner`, which can be applied to your functions to restrict their use to
159  * the owner.
160  */
161 abstract contract Ownable is Context {
162     address private _owner;
163 
164     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
165 
166     /**
167      * @dev Initializes the contract setting the deployer as the initial owner.
168      */
169     constructor() {
170         _transferOwnership(_msgSender());
171     }
172 
173     /**
174      * @dev Throws if called by any account other than the owner.
175      */
176     modifier onlyOwner() {
177         _checkOwner();
178         _;
179     }
180 
181     /**
182      * @dev Returns the address of the current owner.
183      */
184     function owner() public view virtual returns (address) {
185         return _owner;
186     }
187 
188     /**
189      * @dev Throws if the sender is not the owner.
190      */
191     function _checkOwner() internal view virtual {
192         require(owner() == _msgSender(), "Ownable: caller is not the owner");
193     }
194 
195     /**
196      * @dev Leaves the contract without owner. It will not be possible to call
197      * `onlyOwner` functions anymore. Can only be called by the current owner.
198      *
199      * NOTE: Renouncing ownership will leave the contract without an owner,
200      * thereby removing any functionality that is only available to the owner.
201      */
202     function renounceOwnership() public virtual onlyOwner {
203         _transferOwnership(address(0));
204     }
205 
206     /**
207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
208      * Can only be called by the current owner.
209      */
210     function transferOwnership(address newOwner) public virtual onlyOwner {
211         require(newOwner != address(0), "Ownable: new owner is the zero address");
212         _transferOwnership(newOwner);
213     }
214 
215     /**
216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
217      * Internal function without access restriction.
218      */
219     function _transferOwnership(address newOwner) internal virtual {
220         address oldOwner = _owner;
221         _owner = newOwner;
222         emit OwnershipTransferred(oldOwner, newOwner);
223     }
224 }
225 
226 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Contract module that helps prevent reentrant calls to a function.
235  *
236  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
237  * available, which can be applied to functions to make sure there are no nested
238  * (reentrant) calls to them.
239  *
240  * Note that because there is a single `nonReentrant` guard, functions marked as
241  * `nonReentrant` may not call one another. This can be worked around by making
242  * those functions `private`, and then adding `external` `nonReentrant` entry
243  * points to them.
244  *
245  * TIP: If you would like to learn more about reentrancy and alternative ways
246  * to protect against it, check out our blog post
247  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
248  */
249 abstract contract ReentrancyGuard {
250     // Booleans are more expensive than uint256 or any type that takes up a full
251     // word because each write operation emits an extra SLOAD to first read the
252     // slot's contents, replace the bits taken up by the boolean, and then write
253     // back. This is the compiler's defense against contract upgrades and
254     // pointer aliasing, and it cannot be disabled.
255 
256     // The values being non-zero value makes deployment a bit more expensive,
257     // but in exchange the refund on every call to nonReentrant will be lower in
258     // amount. Since refunds are capped to a percentage of the total
259     // transaction's gas, it is best to keep them low in cases like this one, to
260     // increase the likelihood of the full refund coming into effect.
261     uint256 private constant _NOT_ENTERED = 1;
262     uint256 private constant _ENTERED = 2;
263 
264     uint256 private _status;
265 
266     constructor() {
267         _status = _NOT_ENTERED;
268     }
269 
270     /**
271      * @dev Prevents a contract from calling itself, directly or indirectly.
272      * Calling a `nonReentrant` function from another `nonReentrant`
273      * function is not supported. It is possible to prevent this from happening
274      * by making the `nonReentrant` function external, and making it call a
275      * `private` function that does the actual work.
276      */
277     modifier nonReentrant() {
278         _nonReentrantBefore();
279         _;
280         _nonReentrantAfter();
281     }
282 
283     function _nonReentrantBefore() private {
284         // On the first call to nonReentrant, _status will be _NOT_ENTERED
285         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
286 
287         // Any calls to nonReentrant after this point will fail
288         _status = _ENTERED;
289     }
290 
291     function _nonReentrantAfter() private {
292         // By storing the original value once again, a refund is triggered (see
293         // https://eips.ethereum.org/EIPS/eip-2200)
294         _status = _NOT_ENTERED;
295     }
296 }
297 
298 // File: erc721a/contracts/IERC721A.sol
299 
300 
301 // ERC721A Contracts v4.2.3
302 // Creator: Chiru Labs
303 
304 pragma solidity ^0.8.4;
305 
306 /**
307  * @dev Interface of ERC721A.
308  */
309 interface IERC721A {
310     /**
311      * The caller must own the token or be an approved operator.
312      */
313     error ApprovalCallerNotOwnerNorApproved();
314 
315     /**
316      * The token does not exist.
317      */
318     error ApprovalQueryForNonexistentToken();
319 
320     /**
321      * Cannot query the balance for the zero address.
322      */
323     error BalanceQueryForZeroAddress();
324 
325     /**
326      * Cannot mint to the zero address.
327      */
328     error MintToZeroAddress();
329 
330     /**
331      * The quantity of tokens minted must be more than zero.
332      */
333     error MintZeroQuantity();
334 
335     /**
336      * The token does not exist.
337      */
338     error OwnerQueryForNonexistentToken();
339 
340     /**
341      * The caller must own the token or be an approved operator.
342      */
343     error TransferCallerNotOwnerNorApproved();
344 
345     /**
346      * The token must be owned by `from`.
347      */
348     error TransferFromIncorrectOwner();
349 
350     /**
351      * Cannot safely transfer to a contract that does not implement the
352      * ERC721Receiver interface.
353      */
354     error TransferToNonERC721ReceiverImplementer();
355 
356     /**
357      * Cannot transfer to the zero address.
358      */
359     error TransferToZeroAddress();
360 
361     /**
362      * The token does not exist.
363      */
364     error URIQueryForNonexistentToken();
365 
366     /**
367      * The `quantity` minted with ERC2309 exceeds the safety limit.
368      */
369     error MintERC2309QuantityExceedsLimit();
370 
371     /**
372      * The `extraData` cannot be set on an unintialized ownership slot.
373      */
374     error OwnershipNotInitializedForExtraData();
375 
376     // =============================================================
377     //                            STRUCTS
378     // =============================================================
379 
380     struct TokenOwnership {
381         // The address of the owner.
382         address addr;
383         // Stores the start time of ownership with minimal overhead for tokenomics.
384         uint64 startTimestamp;
385         // Whether the token has been burned.
386         bool burned;
387         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
388         uint24 extraData;
389     }
390 
391     // =============================================================
392     //                         TOKEN COUNTERS
393     // =============================================================
394 
395     /**
396      * @dev Returns the total number of tokens in existence.
397      * Burned tokens will reduce the count.
398      * To get the total number of tokens minted, please see {_totalMinted}.
399      */
400     function totalSupply() external view returns (uint256);
401 
402     // =============================================================
403     //                            IERC165
404     // =============================================================
405 
406     /**
407      * @dev Returns true if this contract implements the interface defined by
408      * `interfaceId`. See the corresponding
409      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
410      * to learn more about how these ids are created.
411      *
412      * This function call must use less than 30000 gas.
413      */
414     function supportsInterface(bytes4 interfaceId) external view returns (bool);
415 
416     // =============================================================
417     //                            IERC721
418     // =============================================================
419 
420     /**
421      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
422      */
423     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
424 
425     /**
426      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
427      */
428     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
429 
430     /**
431      * @dev Emitted when `owner` enables or disables
432      * (`approved`) `operator` to manage all of its assets.
433      */
434     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
435 
436     /**
437      * @dev Returns the number of tokens in `owner`'s account.
438      */
439     function balanceOf(address owner) external view returns (uint256 balance);
440 
441     /**
442      * @dev Returns the owner of the `tokenId` token.
443      *
444      * Requirements:
445      *
446      * - `tokenId` must exist.
447      */
448     function ownerOf(uint256 tokenId) external view returns (address owner);
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`,
452      * checking first that contract recipients are aware of the ERC721 protocol
453      * to prevent tokens from being forever locked.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must exist and be owned by `from`.
460      * - If the caller is not `from`, it must be have been allowed to move
461      * this token by either {approve} or {setApprovalForAll}.
462      * - If `to` refers to a smart contract, it must implement
463      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId,
471         bytes calldata data
472     ) external payable;
473 
474     /**
475      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
476      */
477     function safeTransferFrom(
478         address from,
479         address to,
480         uint256 tokenId
481     ) external payable;
482 
483     /**
484      * @dev Transfers `tokenId` from `from` to `to`.
485      *
486      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
487      * whenever possible.
488      *
489      * Requirements:
490      *
491      * - `from` cannot be the zero address.
492      * - `to` cannot be the zero address.
493      * - `tokenId` token must be owned by `from`.
494      * - If the caller is not `from`, it must be approved to move this token
495      * by either {approve} or {setApprovalForAll}.
496      *
497      * Emits a {Transfer} event.
498      */
499     function transferFrom(
500         address from,
501         address to,
502         uint256 tokenId
503     ) external payable;
504 
505     /**
506      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
507      * The approval is cleared when the token is transferred.
508      *
509      * Only a single account can be approved at a time, so approving the
510      * zero address clears previous approvals.
511      *
512      * Requirements:
513      *
514      * - The caller must own the token or be an approved operator.
515      * - `tokenId` must exist.
516      *
517      * Emits an {Approval} event.
518      */
519     function approve(address to, uint256 tokenId) external payable;
520 
521     /**
522      * @dev Approve or remove `operator` as an operator for the caller.
523      * Operators can call {transferFrom} or {safeTransferFrom}
524      * for any token owned by the caller.
525      *
526      * Requirements:
527      *
528      * - The `operator` cannot be the caller.
529      *
530      * Emits an {ApprovalForAll} event.
531      */
532     function setApprovalForAll(address operator, bool _approved) external;
533 
534     /**
535      * @dev Returns the account approved for `tokenId` token.
536      *
537      * Requirements:
538      *
539      * - `tokenId` must exist.
540      */
541     function getApproved(uint256 tokenId) external view returns (address operator);
542 
543     /**
544      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
545      *
546      * See {setApprovalForAll}.
547      */
548     function isApprovedForAll(address owner, address operator) external view returns (bool);
549 
550     // =============================================================
551     //                        IERC721Metadata
552     // =============================================================
553 
554     /**
555      * @dev Returns the token collection name.
556      */
557     function name() external view returns (string memory);
558 
559     /**
560      * @dev Returns the token collection symbol.
561      */
562     function symbol() external view returns (string memory);
563 
564     /**
565      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
566      */
567     function tokenURI(uint256 tokenId) external view returns (string memory);
568 
569     // =============================================================
570     //                           IERC2309
571     // =============================================================
572 
573     /**
574      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
575      * (inclusive) is transferred from `from` to `to`, as defined in the
576      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
577      *
578      * See {_mintERC2309} for more details.
579      */
580     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
581 }
582 
583 // File: erc721a/contracts/ERC721A.sol
584 
585 
586 // ERC721A Contracts v4.2.3
587 // Creator: Chiru Labs
588 
589 pragma solidity ^0.8.4;
590 
591 
592 /**
593  * @dev Interface of ERC721 token receiver.
594  */
595 interface ERC721A__IERC721Receiver {
596     function onERC721Received(
597         address operator,
598         address from,
599         uint256 tokenId,
600         bytes calldata data
601     ) external returns (bytes4);
602 }
603 
604 /**
605  * @title ERC721A
606  *
607  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
608  * Non-Fungible Token Standard, including the Metadata extension.
609  * Optimized for lower gas during batch mints.
610  *
611  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
612  * starting from `_startTokenId()`.
613  *
614  * Assumptions:
615  *
616  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
617  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
618  */
619 contract ERC721A is IERC721A {
620     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
621     struct TokenApprovalRef {
622         address value;
623     }
624 
625     // =============================================================
626     //                           CONSTANTS
627     // =============================================================
628 
629     // Mask of an entry in packed address data.
630     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
631 
632     // The bit position of `numberMinted` in packed address data.
633     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
634 
635     // The bit position of `numberBurned` in packed address data.
636     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
637 
638     // The bit position of `aux` in packed address data.
639     uint256 private constant _BITPOS_AUX = 192;
640 
641     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
642     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
643 
644     // The bit position of `startTimestamp` in packed ownership.
645     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
646 
647     // The bit mask of the `burned` bit in packed ownership.
648     uint256 private constant _BITMASK_BURNED = 1 << 224;
649 
650     // The bit position of the `nextInitialized` bit in packed ownership.
651     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
652 
653     // The bit mask of the `nextInitialized` bit in packed ownership.
654     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
655 
656     // The bit position of `extraData` in packed ownership.
657     uint256 private constant _BITPOS_EXTRA_DATA = 232;
658 
659     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
660     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
661 
662     // The mask of the lower 160 bits for addresses.
663     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
664 
665     // The maximum `quantity` that can be minted with {_mintERC2309}.
666     // This limit is to prevent overflows on the address data entries.
667     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
668     // is required to cause an overflow, which is unrealistic.
669     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
670 
671     // The `Transfer` event signature is given by:
672     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
673     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
674         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
675 
676     // =============================================================
677     //                            STORAGE
678     // =============================================================
679 
680     // The next token ID to be minted.
681     uint256 private _currentIndex;
682 
683     // The number of tokens burned.
684     uint256 private _burnCounter;
685 
686     // Token name
687     string private _name;
688 
689     // Token symbol
690     string private _symbol;
691 
692     // Mapping from token ID to ownership details
693     // An empty struct value does not necessarily mean the token is unowned.
694     // See {_packedOwnershipOf} implementation for details.
695     //
696     // Bits Layout:
697     // - [0..159]   `addr`
698     // - [160..223] `startTimestamp`
699     // - [224]      `burned`
700     // - [225]      `nextInitialized`
701     // - [232..255] `extraData`
702     mapping(uint256 => uint256) private _packedOwnerships;
703 
704     // Mapping owner address to address data.
705     //
706     // Bits Layout:
707     // - [0..63]    `balance`
708     // - [64..127]  `numberMinted`
709     // - [128..191] `numberBurned`
710     // - [192..255] `aux`
711     mapping(address => uint256) private _packedAddressData;
712 
713     // Mapping from token ID to approved address.
714     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
715 
716     // Mapping from owner to operator approvals
717     mapping(address => mapping(address => bool)) private _operatorApprovals;
718 
719     // =============================================================
720     //                          CONSTRUCTOR
721     // =============================================================
722 
723     constructor(string memory name_, string memory symbol_) {
724         _name = name_;
725         _symbol = symbol_;
726         _currentIndex = _startTokenId();
727     }
728 
729     // =============================================================
730     //                   TOKEN COUNTING OPERATIONS
731     // =============================================================
732 
733     /**
734      * @dev Returns the starting token ID.
735      * To change the starting token ID, please override this function.
736      */
737     function _startTokenId() internal view virtual returns (uint256) {
738         return 0;
739     }
740 
741     /**
742      * @dev Returns the next token ID to be minted.
743      */
744     function _nextTokenId() internal view virtual returns (uint256) {
745         return _currentIndex;
746     }
747 
748     /**
749      * @dev Returns the total number of tokens in existence.
750      * Burned tokens will reduce the count.
751      * To get the total number of tokens minted, please see {_totalMinted}.
752      */
753     function totalSupply() public view virtual override returns (uint256) {
754         // Counter underflow is impossible as _burnCounter cannot be incremented
755         // more than `_currentIndex - _startTokenId()` times.
756         unchecked {
757             return _currentIndex - _burnCounter - _startTokenId();
758         }
759     }
760 
761     /**
762      * @dev Returns the total amount of tokens minted in the contract.
763      */
764     function _totalMinted() internal view virtual returns (uint256) {
765         // Counter underflow is impossible as `_currentIndex` does not decrement,
766         // and it is initialized to `_startTokenId()`.
767         unchecked {
768             return _currentIndex - _startTokenId();
769         }
770     }
771 
772     /**
773      * @dev Returns the total number of tokens burned.
774      */
775     function _totalBurned() internal view virtual returns (uint256) {
776         return _burnCounter;
777     }
778 
779     // =============================================================
780     //                    ADDRESS DATA OPERATIONS
781     // =============================================================
782 
783     /**
784      * @dev Returns the number of tokens in `owner`'s account.
785      */
786     function balanceOf(address owner) public view virtual override returns (uint256) {
787         if (owner == address(0)) revert BalanceQueryForZeroAddress();
788         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
789     }
790 
791     /**
792      * Returns the number of tokens minted by `owner`.
793      */
794     function _numberMinted(address owner) internal view returns (uint256) {
795         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
796     }
797 
798     /**
799      * Returns the number of tokens burned by or on behalf of `owner`.
800      */
801     function _numberBurned(address owner) internal view returns (uint256) {
802         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
803     }
804 
805     /**
806      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
807      */
808     function _getAux(address owner) internal view returns (uint64) {
809         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
810     }
811 
812     /**
813      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
814      * If there are multiple variables, please pack them into a uint64.
815      */
816     function _setAux(address owner, uint64 aux) internal virtual {
817         uint256 packed = _packedAddressData[owner];
818         uint256 auxCasted;
819         // Cast `aux` with assembly to avoid redundant masking.
820         assembly {
821             auxCasted := aux
822         }
823         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
824         _packedAddressData[owner] = packed;
825     }
826 
827     // =============================================================
828     //                            IERC165
829     // =============================================================
830 
831     /**
832      * @dev Returns true if this contract implements the interface defined by
833      * `interfaceId`. See the corresponding
834      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
835      * to learn more about how these ids are created.
836      *
837      * This function call must use less than 30000 gas.
838      */
839     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
840         // The interface IDs are constants representing the first 4 bytes
841         // of the XOR of all function selectors in the interface.
842         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
843         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
844         return
845             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
846             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
847             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
848     }
849 
850     // =============================================================
851     //                        IERC721Metadata
852     // =============================================================
853 
854     /**
855      * @dev Returns the token collection name.
856      */
857     function name() public view virtual override returns (string memory) {
858         return _name;
859     }
860 
861     /**
862      * @dev Returns the token collection symbol.
863      */
864     function symbol() public view virtual override returns (string memory) {
865         return _symbol;
866     }
867 
868     /**
869      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
870      */
871     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
872         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
873 
874         string memory baseURI = _baseURI();
875         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
876     }
877 
878     /**
879      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
880      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
881      * by default, it can be overridden in child contracts.
882      */
883     function _baseURI() internal view virtual returns (string memory) {
884         return '';
885     }
886 
887     // =============================================================
888     //                     OWNERSHIPS OPERATIONS
889     // =============================================================
890 
891     /**
892      * @dev Returns the owner of the `tokenId` token.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      */
898     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
899         return address(uint160(_packedOwnershipOf(tokenId)));
900     }
901 
902     /**
903      * @dev Gas spent here starts off proportional to the maximum mint batch size.
904      * It gradually moves to O(1) as tokens get transferred around over time.
905      */
906     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
907         return _unpackedOwnership(_packedOwnershipOf(tokenId));
908     }
909 
910     /**
911      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
912      */
913     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
914         return _unpackedOwnership(_packedOwnerships[index]);
915     }
916 
917     /**
918      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
919      */
920     function _initializeOwnershipAt(uint256 index) internal virtual {
921         if (_packedOwnerships[index] == 0) {
922             _packedOwnerships[index] = _packedOwnershipOf(index);
923         }
924     }
925 
926     /**
927      * Returns the packed ownership data of `tokenId`.
928      */
929     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
930         uint256 curr = tokenId;
931 
932         unchecked {
933             if (_startTokenId() <= curr)
934                 if (curr < _currentIndex) {
935                     uint256 packed = _packedOwnerships[curr];
936                     // If not burned.
937                     if (packed & _BITMASK_BURNED == 0) {
938                         // Invariant:
939                         // There will always be an initialized ownership slot
940                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
941                         // before an unintialized ownership slot
942                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
943                         // Hence, `curr` will not underflow.
944                         //
945                         // We can directly compare the packed value.
946                         // If the address is zero, packed will be zero.
947                         while (packed == 0) {
948                             packed = _packedOwnerships[--curr];
949                         }
950                         return packed;
951                     }
952                 }
953         }
954         revert OwnerQueryForNonexistentToken();
955     }
956 
957     /**
958      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
959      */
960     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
961         ownership.addr = address(uint160(packed));
962         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
963         ownership.burned = packed & _BITMASK_BURNED != 0;
964         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
965     }
966 
967     /**
968      * @dev Packs ownership data into a single uint256.
969      */
970     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
971         assembly {
972             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
973             owner := and(owner, _BITMASK_ADDRESS)
974             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
975             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
976         }
977     }
978 
979     /**
980      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
981      */
982     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
983         // For branchless setting of the `nextInitialized` flag.
984         assembly {
985             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
986             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
987         }
988     }
989 
990     // =============================================================
991     //                      APPROVAL OPERATIONS
992     // =============================================================
993 
994     /**
995      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
996      * The approval is cleared when the token is transferred.
997      *
998      * Only a single account can be approved at a time, so approving the
999      * zero address clears previous approvals.
1000      *
1001      * Requirements:
1002      *
1003      * - The caller must own the token or be an approved operator.
1004      * - `tokenId` must exist.
1005      *
1006      * Emits an {Approval} event.
1007      */
1008     function approve(address to, uint256 tokenId) public payable virtual override {
1009         address owner = ownerOf(tokenId);
1010 
1011         if (_msgSenderERC721A() != owner)
1012             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1013                 revert ApprovalCallerNotOwnerNorApproved();
1014             }
1015 
1016         _tokenApprovals[tokenId].value = to;
1017         emit Approval(owner, to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev Returns the account approved for `tokenId` token.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must exist.
1026      */
1027     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1028         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1029 
1030         return _tokenApprovals[tokenId].value;
1031     }
1032 
1033     /**
1034      * @dev Approve or remove `operator` as an operator for the caller.
1035      * Operators can call {transferFrom} or {safeTransferFrom}
1036      * for any token owned by the caller.
1037      *
1038      * Requirements:
1039      *
1040      * - The `operator` cannot be the caller.
1041      *
1042      * Emits an {ApprovalForAll} event.
1043      */
1044     function setApprovalForAll(address operator, bool approved) public virtual override {
1045         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1046         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1047     }
1048 
1049     /**
1050      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1051      *
1052      * See {setApprovalForAll}.
1053      */
1054     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1055         return _operatorApprovals[owner][operator];
1056     }
1057 
1058     /**
1059      * @dev Returns whether `tokenId` exists.
1060      *
1061      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1062      *
1063      * Tokens start existing when they are minted. See {_mint}.
1064      */
1065     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1066         return
1067             _startTokenId() <= tokenId &&
1068             tokenId < _currentIndex && // If within bounds,
1069             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1070     }
1071 
1072     /**
1073      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1074      */
1075     function _isSenderApprovedOrOwner(
1076         address approvedAddress,
1077         address owner,
1078         address msgSender
1079     ) private pure returns (bool result) {
1080         assembly {
1081             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1082             owner := and(owner, _BITMASK_ADDRESS)
1083             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1084             msgSender := and(msgSender, _BITMASK_ADDRESS)
1085             // `msgSender == owner || msgSender == approvedAddress`.
1086             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1087         }
1088     }
1089 
1090     /**
1091      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1092      */
1093     function _getApprovedSlotAndAddress(uint256 tokenId)
1094         private
1095         view
1096         returns (uint256 approvedAddressSlot, address approvedAddress)
1097     {
1098         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1099         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1100         assembly {
1101             approvedAddressSlot := tokenApproval.slot
1102             approvedAddress := sload(approvedAddressSlot)
1103         }
1104     }
1105 
1106     // =============================================================
1107     //                      TRANSFER OPERATIONS
1108     // =============================================================
1109 
1110     /**
1111      * @dev Transfers `tokenId` from `from` to `to`.
1112      *
1113      * Requirements:
1114      *
1115      * - `from` cannot be the zero address.
1116      * - `to` cannot be the zero address.
1117      * - `tokenId` token must be owned by `from`.
1118      * - If the caller is not `from`, it must be approved to move this token
1119      * by either {approve} or {setApprovalForAll}.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function transferFrom(
1124         address from,
1125         address to,
1126         uint256 tokenId
1127     ) public payable virtual override {
1128         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1129 
1130         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1131 
1132         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1133 
1134         // The nested ifs save around 20+ gas over a compound boolean condition.
1135         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1136             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1137 
1138         if (to == address(0)) revert TransferToZeroAddress();
1139 
1140         _beforeTokenTransfers(from, to, tokenId, 1);
1141 
1142         // Clear approvals from the previous owner.
1143         assembly {
1144             if approvedAddress {
1145                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1146                 sstore(approvedAddressSlot, 0)
1147             }
1148         }
1149 
1150         // Underflow of the sender's balance is impossible because we check for
1151         // ownership above and the recipient's balance can't realistically overflow.
1152         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1153         unchecked {
1154             // We can directly increment and decrement the balances.
1155             --_packedAddressData[from]; // Updates: `balance -= 1`.
1156             ++_packedAddressData[to]; // Updates: `balance += 1`.
1157 
1158             // Updates:
1159             // - `address` to the next owner.
1160             // - `startTimestamp` to the timestamp of transfering.
1161             // - `burned` to `false`.
1162             // - `nextInitialized` to `true`.
1163             _packedOwnerships[tokenId] = _packOwnershipData(
1164                 to,
1165                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1166             );
1167 
1168             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1169             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1170                 uint256 nextTokenId = tokenId + 1;
1171                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1172                 if (_packedOwnerships[nextTokenId] == 0) {
1173                     // If the next slot is within bounds.
1174                     if (nextTokenId != _currentIndex) {
1175                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1176                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1177                     }
1178                 }
1179             }
1180         }
1181 
1182         emit Transfer(from, to, tokenId);
1183         _afterTokenTransfers(from, to, tokenId, 1);
1184     }
1185 
1186     /**
1187      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1188      */
1189     function safeTransferFrom(
1190         address from,
1191         address to,
1192         uint256 tokenId
1193     ) public payable virtual override {
1194         safeTransferFrom(from, to, tokenId, '');
1195     }
1196 
1197     /**
1198      * @dev Safely transfers `tokenId` token from `from` to `to`.
1199      *
1200      * Requirements:
1201      *
1202      * - `from` cannot be the zero address.
1203      * - `to` cannot be the zero address.
1204      * - `tokenId` token must exist and be owned by `from`.
1205      * - If the caller is not `from`, it must be approved to move this token
1206      * by either {approve} or {setApprovalForAll}.
1207      * - If `to` refers to a smart contract, it must implement
1208      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1209      *
1210      * Emits a {Transfer} event.
1211      */
1212     function safeTransferFrom(
1213         address from,
1214         address to,
1215         uint256 tokenId,
1216         bytes memory _data
1217     ) public payable virtual override {
1218         transferFrom(from, to, tokenId);
1219         if (to.code.length != 0)
1220             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1221                 revert TransferToNonERC721ReceiverImplementer();
1222             }
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before a set of serially-ordered token IDs
1227      * are about to be transferred. This includes minting.
1228      * And also called before burning one token.
1229      *
1230      * `startTokenId` - the first token ID to be transferred.
1231      * `quantity` - the amount to be transferred.
1232      *
1233      * Calling conditions:
1234      *
1235      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1236      * transferred to `to`.
1237      * - When `from` is zero, `tokenId` will be minted for `to`.
1238      * - When `to` is zero, `tokenId` will be burned by `from`.
1239      * - `from` and `to` are never both zero.
1240      */
1241     function _beforeTokenTransfers(
1242         address from,
1243         address to,
1244         uint256 startTokenId,
1245         uint256 quantity
1246     ) internal virtual {}
1247 
1248     /**
1249      * @dev Hook that is called after a set of serially-ordered token IDs
1250      * have been transferred. This includes minting.
1251      * And also called after one token has been burned.
1252      *
1253      * `startTokenId` - the first token ID to be transferred.
1254      * `quantity` - the amount to be transferred.
1255      *
1256      * Calling conditions:
1257      *
1258      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1259      * transferred to `to`.
1260      * - When `from` is zero, `tokenId` has been minted for `to`.
1261      * - When `to` is zero, `tokenId` has been burned by `from`.
1262      * - `from` and `to` are never both zero.
1263      */
1264     function _afterTokenTransfers(
1265         address from,
1266         address to,
1267         uint256 startTokenId,
1268         uint256 quantity
1269     ) internal virtual {}
1270 
1271     /**
1272      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1273      *
1274      * `from` - Previous owner of the given token ID.
1275      * `to` - Target address that will receive the token.
1276      * `tokenId` - Token ID to be transferred.
1277      * `_data` - Optional data to send along with the call.
1278      *
1279      * Returns whether the call correctly returned the expected magic value.
1280      */
1281     function _checkContractOnERC721Received(
1282         address from,
1283         address to,
1284         uint256 tokenId,
1285         bytes memory _data
1286     ) private returns (bool) {
1287         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1288             bytes4 retval
1289         ) {
1290             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1291         } catch (bytes memory reason) {
1292             if (reason.length == 0) {
1293                 revert TransferToNonERC721ReceiverImplementer();
1294             } else {
1295                 assembly {
1296                     revert(add(32, reason), mload(reason))
1297                 }
1298             }
1299         }
1300     }
1301 
1302     // =============================================================
1303     //                        MINT OPERATIONS
1304     // =============================================================
1305 
1306     /**
1307      * @dev Mints `quantity` tokens and transfers them to `to`.
1308      *
1309      * Requirements:
1310      *
1311      * - `to` cannot be the zero address.
1312      * - `quantity` must be greater than 0.
1313      *
1314      * Emits a {Transfer} event for each mint.
1315      */
1316     function _mint(address to, uint256 quantity) internal virtual {
1317         uint256 startTokenId = _currentIndex;
1318         if (quantity == 0) revert MintZeroQuantity();
1319 
1320         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1321 
1322         // Overflows are incredibly unrealistic.
1323         // `balance` and `numberMinted` have a maximum limit of 2**64.
1324         // `tokenId` has a maximum limit of 2**256.
1325         unchecked {
1326             // Updates:
1327             // - `balance += quantity`.
1328             // - `numberMinted += quantity`.
1329             //
1330             // We can directly add to the `balance` and `numberMinted`.
1331             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1332 
1333             // Updates:
1334             // - `address` to the owner.
1335             // - `startTimestamp` to the timestamp of minting.
1336             // - `burned` to `false`.
1337             // - `nextInitialized` to `quantity == 1`.
1338             _packedOwnerships[startTokenId] = _packOwnershipData(
1339                 to,
1340                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1341             );
1342 
1343             uint256 toMasked;
1344             uint256 end = startTokenId + quantity;
1345 
1346             // Use assembly to loop and emit the `Transfer` event for gas savings.
1347             // The duplicated `log4` removes an extra check and reduces stack juggling.
1348             // The assembly, together with the surrounding Solidity code, have been
1349             // delicately arranged to nudge the compiler into producing optimized opcodes.
1350             assembly {
1351                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1352                 toMasked := and(to, _BITMASK_ADDRESS)
1353                 // Emit the `Transfer` event.
1354                 log4(
1355                     0, // Start of data (0, since no data).
1356                     0, // End of data (0, since no data).
1357                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1358                     0, // `address(0)`.
1359                     toMasked, // `to`.
1360                     startTokenId // `tokenId`.
1361                 )
1362 
1363                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1364                 // that overflows uint256 will make the loop run out of gas.
1365                 // The compiler will optimize the `iszero` away for performance.
1366                 for {
1367                     let tokenId := add(startTokenId, 1)
1368                 } iszero(eq(tokenId, end)) {
1369                     tokenId := add(tokenId, 1)
1370                 } {
1371                     // Emit the `Transfer` event. Similar to above.
1372                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1373                 }
1374             }
1375             if (toMasked == 0) revert MintToZeroAddress();
1376 
1377             _currentIndex = end;
1378         }
1379         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1380     }
1381 
1382     /**
1383      * @dev Mints `quantity` tokens and transfers them to `to`.
1384      *
1385      * This function is intended for efficient minting only during contract creation.
1386      *
1387      * It emits only one {ConsecutiveTransfer} as defined in
1388      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1389      * instead of a sequence of {Transfer} event(s).
1390      *
1391      * Calling this function outside of contract creation WILL make your contract
1392      * non-compliant with the ERC721 standard.
1393      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1394      * {ConsecutiveTransfer} event is only permissible during contract creation.
1395      *
1396      * Requirements:
1397      *
1398      * - `to` cannot be the zero address.
1399      * - `quantity` must be greater than 0.
1400      *
1401      * Emits a {ConsecutiveTransfer} event.
1402      */
1403     function _mintERC2309(address to, uint256 quantity) internal virtual {
1404         uint256 startTokenId = _currentIndex;
1405         if (to == address(0)) revert MintToZeroAddress();
1406         if (quantity == 0) revert MintZeroQuantity();
1407         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1408 
1409         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1410 
1411         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1412         unchecked {
1413             // Updates:
1414             // - `balance += quantity`.
1415             // - `numberMinted += quantity`.
1416             //
1417             // We can directly add to the `balance` and `numberMinted`.
1418             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1419 
1420             // Updates:
1421             // - `address` to the owner.
1422             // - `startTimestamp` to the timestamp of minting.
1423             // - `burned` to `false`.
1424             // - `nextInitialized` to `quantity == 1`.
1425             _packedOwnerships[startTokenId] = _packOwnershipData(
1426                 to,
1427                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1428             );
1429 
1430             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1431 
1432             _currentIndex = startTokenId + quantity;
1433         }
1434         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1435     }
1436 
1437     /**
1438      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1439      *
1440      * Requirements:
1441      *
1442      * - If `to` refers to a smart contract, it must implement
1443      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1444      * - `quantity` must be greater than 0.
1445      *
1446      * See {_mint}.
1447      *
1448      * Emits a {Transfer} event for each mint.
1449      */
1450     function _safeMint(
1451         address to,
1452         uint256 quantity,
1453         bytes memory _data
1454     ) internal virtual {
1455         _mint(to, quantity);
1456 
1457         unchecked {
1458             if (to.code.length != 0) {
1459                 uint256 end = _currentIndex;
1460                 uint256 index = end - quantity;
1461                 do {
1462                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1463                         revert TransferToNonERC721ReceiverImplementer();
1464                     }
1465                 } while (index < end);
1466                 // Reentrancy protection.
1467                 if (_currentIndex != end) revert();
1468             }
1469         }
1470     }
1471 
1472     /**
1473      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1474      */
1475     function _safeMint(address to, uint256 quantity) internal virtual {
1476         _safeMint(to, quantity, '');
1477     }
1478 
1479     // =============================================================
1480     //                        BURN OPERATIONS
1481     // =============================================================
1482 
1483     /**
1484      * @dev Equivalent to `_burn(tokenId, false)`.
1485      */
1486     function _burn(uint256 tokenId) internal virtual {
1487         _burn(tokenId, false);
1488     }
1489 
1490     /**
1491      * @dev Destroys `tokenId`.
1492      * The approval is cleared when the token is burned.
1493      *
1494      * Requirements:
1495      *
1496      * - `tokenId` must exist.
1497      *
1498      * Emits a {Transfer} event.
1499      */
1500     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1501         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1502 
1503         address from = address(uint160(prevOwnershipPacked));
1504 
1505         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1506 
1507         if (approvalCheck) {
1508             // The nested ifs save around 20+ gas over a compound boolean condition.
1509             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1510                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1511         }
1512 
1513         _beforeTokenTransfers(from, address(0), tokenId, 1);
1514 
1515         // Clear approvals from the previous owner.
1516         assembly {
1517             if approvedAddress {
1518                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1519                 sstore(approvedAddressSlot, 0)
1520             }
1521         }
1522 
1523         // Underflow of the sender's balance is impossible because we check for
1524         // ownership above and the recipient's balance can't realistically overflow.
1525         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1526         unchecked {
1527             // Updates:
1528             // - `balance -= 1`.
1529             // - `numberBurned += 1`.
1530             //
1531             // We can directly decrement the balance, and increment the number burned.
1532             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1533             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1534 
1535             // Updates:
1536             // - `address` to the last owner.
1537             // - `startTimestamp` to the timestamp of burning.
1538             // - `burned` to `true`.
1539             // - `nextInitialized` to `true`.
1540             _packedOwnerships[tokenId] = _packOwnershipData(
1541                 from,
1542                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1543             );
1544 
1545             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1546             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1547                 uint256 nextTokenId = tokenId + 1;
1548                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1549                 if (_packedOwnerships[nextTokenId] == 0) {
1550                     // If the next slot is within bounds.
1551                     if (nextTokenId != _currentIndex) {
1552                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1553                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1554                     }
1555                 }
1556             }
1557         }
1558 
1559         emit Transfer(from, address(0), tokenId);
1560         _afterTokenTransfers(from, address(0), tokenId, 1);
1561 
1562         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1563         unchecked {
1564             _burnCounter++;
1565         }
1566     }
1567 
1568     // =============================================================
1569     //                     EXTRA DATA OPERATIONS
1570     // =============================================================
1571 
1572     /**
1573      * @dev Directly sets the extra data for the ownership data `index`.
1574      */
1575     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1576         uint256 packed = _packedOwnerships[index];
1577         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1578         uint256 extraDataCasted;
1579         // Cast `extraData` with assembly to avoid redundant masking.
1580         assembly {
1581             extraDataCasted := extraData
1582         }
1583         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1584         _packedOwnerships[index] = packed;
1585     }
1586 
1587     /**
1588      * @dev Called during each token transfer to set the 24bit `extraData` field.
1589      * Intended to be overridden by the cosumer contract.
1590      *
1591      * `previousExtraData` - the value of `extraData` before transfer.
1592      *
1593      * Calling conditions:
1594      *
1595      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1596      * transferred to `to`.
1597      * - When `from` is zero, `tokenId` will be minted for `to`.
1598      * - When `to` is zero, `tokenId` will be burned by `from`.
1599      * - `from` and `to` are never both zero.
1600      */
1601     function _extraData(
1602         address from,
1603         address to,
1604         uint24 previousExtraData
1605     ) internal view virtual returns (uint24) {}
1606 
1607     /**
1608      * @dev Returns the next extra data for the packed ownership data.
1609      * The returned result is shifted into position.
1610      */
1611     function _nextExtraData(
1612         address from,
1613         address to,
1614         uint256 prevOwnershipPacked
1615     ) private view returns (uint256) {
1616         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1617         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1618     }
1619 
1620     // =============================================================
1621     //                       OTHER OPERATIONS
1622     // =============================================================
1623 
1624     /**
1625      * @dev Returns the message sender (defaults to `msg.sender`).
1626      *
1627      * If you are writing GSN compatible contracts, you need to override this function.
1628      */
1629     function _msgSenderERC721A() internal view virtual returns (address) {
1630         return msg.sender;
1631     }
1632 
1633     /**
1634      * @dev Converts a uint256 to its ASCII string decimal representation.
1635      */
1636     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1637         assembly {
1638             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1639             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1640             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1641             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1642             let m := add(mload(0x40), 0xa0)
1643             // Update the free memory pointer to allocate.
1644             mstore(0x40, m)
1645             // Assign the `str` to the end.
1646             str := sub(m, 0x20)
1647             // Zeroize the slot after the string.
1648             mstore(str, 0)
1649 
1650             // Cache the end of the memory to calculate the length later.
1651             let end := str
1652 
1653             // We write the string from rightmost digit to leftmost digit.
1654             // The following is essentially a do-while loop that also handles the zero case.
1655             // prettier-ignore
1656             for { let temp := value } 1 {} {
1657                 str := sub(str, 1)
1658                 // Write the character to the pointer.
1659                 // The ASCII index of the '0' character is 48.
1660                 mstore8(str, add(48, mod(temp, 10)))
1661                 // Keep dividing `temp` until zero.
1662                 temp := div(temp, 10)
1663                 // prettier-ignore
1664                 if iszero(temp) { break }
1665             }
1666 
1667             let length := sub(end, str)
1668             // Move the pointer 32 bytes leftwards to make room for the length.
1669             str := sub(str, 0x20)
1670             // Store the length.
1671             mstore(str, length)
1672         }
1673     }
1674 }
1675 
1676 // File: contracts/MemesWorld.sol
1677 
1678 
1679 
1680 pragma solidity ^0.8.0;
1681 
1682 
1683 
1684 
1685 
1686 
1687 
1688 contract MemesWorld is ERC721A, DefaultOperatorFilterer, Ownable {
1689 
1690     mapping (address => bool) public minterAddress;
1691     string public baseURI;  
1692     uint256 public price = 0;
1693     uint256 public maxSupply = 2500;
1694     uint256 public MINT_LIMIT = 10;
1695     bool public mintActive;
1696     mapping (address => uint256) public walletPublic;
1697 
1698 
1699     constructor () ERC721A("Meme's World NFT", "MEMEWRLD") {
1700         mintActive = false;
1701     }
1702 
1703     function _startTokenId() internal view virtual override returns (uint256) {
1704         return 1;
1705     }
1706 
1707     // Mint
1708         function Mint(uint256 numTokens) public payable {
1709         require(mintActive , "Mint is not active.");
1710         require(numTokens > 0 && numTokens <= MINT_LIMIT);
1711         require(totalSupply() + numTokens <= maxSupply);
1712         require(MINT_LIMIT >= numTokens, "Surpassed Mint Limit.");
1713         require(msg.value >= numTokens * price, "Invalid funds provided");
1714         _safeMint(msg.sender, numTokens);
1715     }
1716 
1717 
1718     // Contract Key Functions
1719 
1720     function mintSwitch() public onlyOwner {
1721         mintActive = !mintActive;
1722     }
1723 
1724     function setPrice(uint256 newPrice) public onlyOwner {
1725         price = newPrice;
1726     }
1727 
1728     function _baseURI() internal view virtual override returns (string memory) {
1729         return baseURI;
1730     }
1731 
1732     function withdrawFunds() public onlyOwner {
1733 		payable(msg.sender).transfer(address(this).balance);
1734         
1735 	}
1736         function setBaseURI(string memory baseURI_) external onlyOwner {
1737         baseURI = baseURI_;
1738         
1739     }
1740 
1741         function setMaxMints(uint256 newMax) public onlyOwner {
1742         MINT_LIMIT = newMax;
1743 
1744     }
1745 
1746 
1747     // Opensea Filter Registry (Royalty Enforcement)
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