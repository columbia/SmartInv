1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
74 
75 
76 pragma solidity ^0.8.13;
77 
78 interface IOperatorFilterRegistry {
79     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
80     function register(address registrant) external;
81     function registerAndSubscribe(address registrant, address subscription) external;
82     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
83     function unregister(address addr) external;
84     function updateOperator(address registrant, address operator, bool filtered) external;
85     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
86     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
87     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
88     function subscribe(address registrant, address registrantToSubscribe) external;
89     function unsubscribe(address registrant, bool copyExistingEntries) external;
90     function subscriptionOf(address addr) external returns (address registrant);
91     function subscribers(address registrant) external returns (address[] memory);
92     function subscriberAt(address registrant, uint256 index) external returns (address);
93     function copyEntriesOf(address registrant, address registrantToCopy) external;
94     function isOperatorFiltered(address registrant, address operator) external returns (bool);
95     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
96     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
97     function filteredOperators(address addr) external returns (address[] memory);
98     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
99     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
100     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
101     function isRegistered(address addr) external returns (bool);
102     function codeHashOf(address addr) external returns (bytes32);
103 }
104 
105 // File: operator-filter-registry/src/OperatorFilterer.sol
106 
107 
108 pragma solidity ^0.8.13;
109 
110 
111 /**
112  * @title  OperatorFilterer
113  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
114  *         registrant's entries in the OperatorFilterRegistry.
115  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
116  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
117  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
118  */
119 abstract contract OperatorFilterer {
120     error OperatorNotAllowed(address operator);
121 
122     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
123         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
124 
125     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
126         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
127         // will not revert, but the contract will need to be registered with the registry once it is deployed in
128         // order for the modifier to filter addresses.
129         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
130             if (subscribe) {
131                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
132             } else {
133                 if (subscriptionOrRegistrantToCopy != address(0)) {
134                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
135                 } else {
136                     OPERATOR_FILTER_REGISTRY.register(address(this));
137                 }
138             }
139         }
140     }
141 
142     modifier onlyAllowedOperator(address from) virtual {
143         // Allow spending tokens from addresses with balance
144         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
145         // from an EOA.
146         if (from != msg.sender) {
147             _checkFilterOperator(msg.sender);
148         }
149         _;
150     }
151 
152     modifier onlyAllowedOperatorApproval(address operator) virtual {
153         _checkFilterOperator(operator);
154         _;
155     }
156 
157     function _checkFilterOperator(address operator) internal view virtual {
158         // Check registry code length to facilitate testing in environments without a deployed registry.
159         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
160             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
161                 revert OperatorNotAllowed(operator);
162             }
163         }
164     }
165 }
166 
167 // File: @openzeppelin/contracts/utils/Context.sol
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev Provides information about the current execution context, including the
176  * sender of the transaction and its data. While these are generally available
177  * via msg.sender and msg.data, they should not be accessed in such a direct
178  * manner, since when dealing with meta-transactions the account sending and
179  * paying for execution may not be the actual sender (as far as an application
180  * is concerned).
181  *
182  * This contract is only required for intermediate, library-like contracts.
183  */
184 abstract contract Context {
185     function _msgSender() internal view virtual returns (address) {
186         return msg.sender;
187     }
188 
189     function _msgData() internal view virtual returns (bytes calldata) {
190         return msg.data;
191     }
192 }
193 
194 // File: @openzeppelin/contracts/security/Pausable.sol
195 
196 
197 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 
202 /**
203  * @dev Contract module which allows children to implement an emergency stop
204  * mechanism that can be triggered by an authorized account.
205  *
206  * This module is used through inheritance. It will make available the
207  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
208  * the functions of your contract. Note that they will not be pausable by
209  * simply including this module, only once the modifiers are put in place.
210  */
211 abstract contract Pausable is Context {
212     /**
213      * @dev Emitted when the pause is triggered by `account`.
214      */
215     event Paused(address account);
216 
217     /**
218      * @dev Emitted when the pause is lifted by `account`.
219      */
220     event Unpaused(address account);
221 
222     bool private _paused;
223 
224     /**
225      * @dev Initializes the contract in unpaused state.
226      */
227     constructor() {
228         _paused = false;
229     }
230 
231     /**
232      * @dev Modifier to make a function callable only when the contract is not paused.
233      *
234      * Requirements:
235      *
236      * - The contract must not be paused.
237      */
238     modifier whenNotPaused() {
239         _requireNotPaused();
240         _;
241     }
242 
243     /**
244      * @dev Modifier to make a function callable only when the contract is paused.
245      *
246      * Requirements:
247      *
248      * - The contract must be paused.
249      */
250     modifier whenPaused() {
251         _requirePaused();
252         _;
253     }
254 
255     /**
256      * @dev Returns true if the contract is paused, and false otherwise.
257      */
258     function paused() public view virtual returns (bool) {
259         return _paused;
260     }
261 
262     /**
263      * @dev Throws if the contract is paused.
264      */
265     function _requireNotPaused() internal view virtual {
266         require(!paused(), "Pausable: paused");
267     }
268 
269     /**
270      * @dev Throws if the contract is not paused.
271      */
272     function _requirePaused() internal view virtual {
273         require(paused(), "Pausable: not paused");
274     }
275 
276     /**
277      * @dev Triggers stopped state.
278      *
279      * Requirements:
280      *
281      * - The contract must not be paused.
282      */
283     function _pause() internal virtual whenNotPaused {
284         _paused = true;
285         emit Paused(_msgSender());
286     }
287 
288     /**
289      * @dev Returns to normal state.
290      *
291      * Requirements:
292      *
293      * - The contract must be paused.
294      */
295     function _unpause() internal virtual whenPaused {
296         _paused = false;
297         emit Unpaused(_msgSender());
298     }
299 }
300 
301 // File: @openzeppelin/contracts/access/Ownable.sol
302 
303 
304 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 
309 /**
310  * @dev Contract module which provides a basic access control mechanism, where
311  * there is an account (an owner) that can be granted exclusive access to
312  * specific functions.
313  *
314  * By default, the owner account will be the one that deploys the contract. This
315  * can later be changed with {transferOwnership}.
316  *
317  * This module is used through inheritance. It will make available the modifier
318  * `onlyOwner`, which can be applied to your functions to restrict their use to
319  * the owner.
320  */
321 abstract contract Ownable is Context {
322     address private _owner;
323 
324     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
325 
326     /**
327      * @dev Initializes the contract setting the deployer as the initial owner.
328      */
329     constructor() {
330         _transferOwnership(_msgSender());
331     }
332 
333     /**
334      * @dev Throws if called by any account other than the owner.
335      */
336     modifier onlyOwner() {
337         _checkOwner();
338         _;
339     }
340 
341     /**
342      * @dev Returns the address of the current owner.
343      */
344     function owner() public view virtual returns (address) {
345         return _owner;
346     }
347 
348     /**
349      * @dev Throws if the sender is not the owner.
350      */
351     function _checkOwner() internal view virtual {
352         require(owner() == _msgSender(), "Ownable: caller is not the owner");
353     }
354 
355     /**
356      * @dev Leaves the contract without owner. It will not be possible to call
357      * `onlyOwner` functions anymore. Can only be called by the current owner.
358      *
359      * NOTE: Renouncing ownership will leave the contract without an owner,
360      * thereby removing any functionality that is only available to the owner.
361      */
362     function renounceOwnership() public virtual onlyOwner {
363         _transferOwnership(address(0));
364     }
365 
366     /**
367      * @dev Transfers ownership of the contract to a new account (`newOwner`).
368      * Can only be called by the current owner.
369      */
370     function transferOwnership(address newOwner) public virtual onlyOwner {
371         require(newOwner != address(0), "Ownable: new owner is the zero address");
372         _transferOwnership(newOwner);
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Internal function without access restriction.
378      */
379     function _transferOwnership(address newOwner) internal virtual {
380         address oldOwner = _owner;
381         _owner = newOwner;
382         emit OwnershipTransferred(oldOwner, newOwner);
383     }
384 }
385 
386 // File: erc721a/contracts/IERC721A.sol
387 
388 
389 // ERC721A Contracts v4.2.3
390 // Creator: Chiru Labs
391 
392 pragma solidity ^0.8.4;
393 
394 /**
395  * @dev Interface of ERC721A.
396  */
397 interface IERC721A {
398     /**
399      * The caller must own the token or be an approved operator.
400      */
401     error ApprovalCallerNotOwnerNorApproved();
402 
403     /**
404      * The token does not exist.
405      */
406     error ApprovalQueryForNonexistentToken();
407 
408     /**
409      * Cannot query the balance for the zero address.
410      */
411     error BalanceQueryForZeroAddress();
412 
413     /**
414      * Cannot mint to the zero address.
415      */
416     error MintToZeroAddress();
417 
418     /**
419      * The quantity of tokens minted must be more than zero.
420      */
421     error MintZeroQuantity();
422 
423     /**
424      * The token does not exist.
425      */
426     error OwnerQueryForNonexistentToken();
427 
428     /**
429      * The caller must own the token or be an approved operator.
430      */
431     error TransferCallerNotOwnerNorApproved();
432 
433     /**
434      * The token must be owned by `from`.
435      */
436     error TransferFromIncorrectOwner();
437 
438     /**
439      * Cannot safely transfer to a contract that does not implement the
440      * ERC721Receiver interface.
441      */
442     error TransferToNonERC721ReceiverImplementer();
443 
444     /**
445      * Cannot transfer to the zero address.
446      */
447     error TransferToZeroAddress();
448 
449     /**
450      * The token does not exist.
451      */
452     error URIQueryForNonexistentToken();
453 
454     /**
455      * The `quantity` minted with ERC2309 exceeds the safety limit.
456      */
457     error MintERC2309QuantityExceedsLimit();
458 
459     /**
460      * The `extraData` cannot be set on an unintialized ownership slot.
461      */
462     error OwnershipNotInitializedForExtraData();
463 
464     // =============================================================
465     //                            STRUCTS
466     // =============================================================
467 
468     struct TokenOwnership {
469         // The address of the owner.
470         address addr;
471         // Stores the start time of ownership with minimal overhead for tokenomics.
472         uint64 startTimestamp;
473         // Whether the token has been burned.
474         bool burned;
475         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
476         uint24 extraData;
477     }
478 
479     // =============================================================
480     //                         TOKEN COUNTERS
481     // =============================================================
482 
483     /**
484      * @dev Returns the total number of tokens in existence.
485      * Burned tokens will reduce the count.
486      * To get the total number of tokens minted, please see {_totalMinted}.
487      */
488     function totalSupply() external view returns (uint256);
489 
490     // =============================================================
491     //                            IERC165
492     // =============================================================
493 
494     /**
495      * @dev Returns true if this contract implements the interface defined by
496      * `interfaceId`. See the corresponding
497      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
498      * to learn more about how these ids are created.
499      *
500      * This function call must use less than 30000 gas.
501      */
502     function supportsInterface(bytes4 interfaceId) external view returns (bool);
503 
504     // =============================================================
505     //                            IERC721
506     // =============================================================
507 
508     /**
509      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
510      */
511     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
512 
513     /**
514      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
515      */
516     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
517 
518     /**
519      * @dev Emitted when `owner` enables or disables
520      * (`approved`) `operator` to manage all of its assets.
521      */
522     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
523 
524     /**
525      * @dev Returns the number of tokens in `owner`'s account.
526      */
527     function balanceOf(address owner) external view returns (uint256 balance);
528 
529     /**
530      * @dev Returns the owner of the `tokenId` token.
531      *
532      * Requirements:
533      *
534      * - `tokenId` must exist.
535      */
536     function ownerOf(uint256 tokenId) external view returns (address owner);
537 
538     /**
539      * @dev Safely transfers `tokenId` token from `from` to `to`,
540      * checking first that contract recipients are aware of the ERC721 protocol
541      * to prevent tokens from being forever locked.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must exist and be owned by `from`.
548      * - If the caller is not `from`, it must be have been allowed to move
549      * this token by either {approve} or {setApprovalForAll}.
550      * - If `to` refers to a smart contract, it must implement
551      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
552      *
553      * Emits a {Transfer} event.
554      */
555     function safeTransferFrom(
556         address from,
557         address to,
558         uint256 tokenId,
559         bytes calldata data
560     ) external payable;
561 
562     /**
563      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
564      */
565     function safeTransferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external payable;
570 
571     /**
572      * @dev Transfers `tokenId` from `from` to `to`.
573      *
574      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
575      * whenever possible.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must be owned by `from`.
582      * - If the caller is not `from`, it must be approved to move this token
583      * by either {approve} or {setApprovalForAll}.
584      *
585      * Emits a {Transfer} event.
586      */
587     function transferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external payable;
592 
593     /**
594      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
595      * The approval is cleared when the token is transferred.
596      *
597      * Only a single account can be approved at a time, so approving the
598      * zero address clears previous approvals.
599      *
600      * Requirements:
601      *
602      * - The caller must own the token or be an approved operator.
603      * - `tokenId` must exist.
604      *
605      * Emits an {Approval} event.
606      */
607     function approve(address to, uint256 tokenId) external payable;
608 
609     /**
610      * @dev Approve or remove `operator` as an operator for the caller.
611      * Operators can call {transferFrom} or {safeTransferFrom}
612      * for any token owned by the caller.
613      *
614      * Requirements:
615      *
616      * - The `operator` cannot be the caller.
617      *
618      * Emits an {ApprovalForAll} event.
619      */
620     function setApprovalForAll(address operator, bool _approved) external;
621 
622     /**
623      * @dev Returns the account approved for `tokenId` token.
624      *
625      * Requirements:
626      *
627      * - `tokenId` must exist.
628      */
629     function getApproved(uint256 tokenId) external view returns (address operator);
630 
631     /**
632      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
633      *
634      * See {setApprovalForAll}.
635      */
636     function isApprovedForAll(address owner, address operator) external view returns (bool);
637 
638     // =============================================================
639     //                        IERC721Metadata
640     // =============================================================
641 
642     /**
643      * @dev Returns the token collection name.
644      */
645     function name() external view returns (string memory);
646 
647     /**
648      * @dev Returns the token collection symbol.
649      */
650     function symbol() external view returns (string memory);
651 
652     /**
653      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
654      */
655     function tokenURI(uint256 tokenId) external view returns (string memory);
656 
657     // =============================================================
658     //                           IERC2309
659     // =============================================================
660 
661     /**
662      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
663      * (inclusive) is transferred from `from` to `to`, as defined in the
664      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
665      *
666      * See {_mintERC2309} for more details.
667      */
668     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
669 }
670 
671 // File: erc721a/contracts/ERC721A.sol
672 
673 
674 // ERC721A Contracts v4.2.3
675 // Creator: Chiru Labs
676 
677 pragma solidity ^0.8.4;
678 
679 
680 /**
681  * @dev Interface of ERC721 token receiver.
682  */
683 interface ERC721A__IERC721Receiver {
684     function onERC721Received(
685         address operator,
686         address from,
687         uint256 tokenId,
688         bytes calldata data
689     ) external returns (bytes4);
690 }
691 
692 /**
693  * @title ERC721A
694  *
695  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
696  * Non-Fungible Token Standard, including the Metadata extension.
697  * Optimized for lower gas during batch mints.
698  *
699  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
700  * starting from `_startTokenId()`.
701  *
702  * Assumptions:
703  *
704  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
705  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
706  */
707 contract ERC721A is IERC721A {
708     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
709     struct TokenApprovalRef {
710         address value;
711     }
712 
713     // =============================================================
714     //                           CONSTANTS
715     // =============================================================
716 
717     // Mask of an entry in packed address data.
718     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
719 
720     // The bit position of `numberMinted` in packed address data.
721     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
722 
723     // The bit position of `numberBurned` in packed address data.
724     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
725 
726     // The bit position of `aux` in packed address data.
727     uint256 private constant _BITPOS_AUX = 192;
728 
729     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
730     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
731 
732     // The bit position of `startTimestamp` in packed ownership.
733     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
734 
735     // The bit mask of the `burned` bit in packed ownership.
736     uint256 private constant _BITMASK_BURNED = 1 << 224;
737 
738     // The bit position of the `nextInitialized` bit in packed ownership.
739     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
740 
741     // The bit mask of the `nextInitialized` bit in packed ownership.
742     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
743 
744     // The bit position of `extraData` in packed ownership.
745     uint256 private constant _BITPOS_EXTRA_DATA = 232;
746 
747     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
748     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
749 
750     // The mask of the lower 160 bits for addresses.
751     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
752 
753     // The maximum `quantity` that can be minted with {_mintERC2309}.
754     // This limit is to prevent overflows on the address data entries.
755     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
756     // is required to cause an overflow, which is unrealistic.
757     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
758 
759     // The `Transfer` event signature is given by:
760     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
761     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
762         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
763 
764     // =============================================================
765     //                            STORAGE
766     // =============================================================
767 
768     // The next token ID to be minted.
769     uint256 private _currentIndex;
770 
771     // The number of tokens burned.
772     uint256 private _burnCounter;
773 
774     // Token name
775     string private _name;
776 
777     // Token symbol
778     string private _symbol;
779 
780     // Mapping from token ID to ownership details
781     // An empty struct value does not necessarily mean the token is unowned.
782     // See {_packedOwnershipOf} implementation for details.
783     //
784     // Bits Layout:
785     // - [0..159]   `addr`
786     // - [160..223] `startTimestamp`
787     // - [224]      `burned`
788     // - [225]      `nextInitialized`
789     // - [232..255] `extraData`
790     mapping(uint256 => uint256) private _packedOwnerships;
791 
792     // Mapping owner address to address data.
793     //
794     // Bits Layout:
795     // - [0..63]    `balance`
796     // - [64..127]  `numberMinted`
797     // - [128..191] `numberBurned`
798     // - [192..255] `aux`
799     mapping(address => uint256) private _packedAddressData;
800 
801     // Mapping from token ID to approved address.
802     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
803 
804     // Mapping from owner to operator approvals
805     mapping(address => mapping(address => bool)) private _operatorApprovals;
806 
807     // =============================================================
808     //                          CONSTRUCTOR
809     // =============================================================
810 
811     constructor(string memory name_, string memory symbol_) {
812         _name = name_;
813         _symbol = symbol_;
814         _currentIndex = _startTokenId();
815     }
816 
817     // =============================================================
818     //                   TOKEN COUNTING OPERATIONS
819     // =============================================================
820 
821     /**
822      * @dev Returns the starting token ID.
823      * To change the starting token ID, please override this function.
824      */
825     function _startTokenId() internal view virtual returns (uint256) {
826         return 0;
827     }
828 
829     /**
830      * @dev Returns the next token ID to be minted.
831      */
832     function _nextTokenId() internal view virtual returns (uint256) {
833         return _currentIndex;
834     }
835 
836     /**
837      * @dev Returns the total number of tokens in existence.
838      * Burned tokens will reduce the count.
839      * To get the total number of tokens minted, please see {_totalMinted}.
840      */
841     function totalSupply() public view virtual override returns (uint256) {
842         // Counter underflow is impossible as _burnCounter cannot be incremented
843         // more than `_currentIndex - _startTokenId()` times.
844         unchecked {
845             return _currentIndex - _burnCounter - _startTokenId();
846         }
847     }
848 
849     /**
850      * @dev Returns the total amount of tokens minted in the contract.
851      */
852     function _totalMinted() internal view virtual returns (uint256) {
853         // Counter underflow is impossible as `_currentIndex` does not decrement,
854         // and it is initialized to `_startTokenId()`.
855         unchecked {
856             return _currentIndex - _startTokenId();
857         }
858     }
859 
860     /**
861      * @dev Returns the total number of tokens burned.
862      */
863     function _totalBurned() internal view virtual returns (uint256) {
864         return _burnCounter;
865     }
866 
867     // =============================================================
868     //                    ADDRESS DATA OPERATIONS
869     // =============================================================
870 
871     /**
872      * @dev Returns the number of tokens in `owner`'s account.
873      */
874     function balanceOf(address owner) public view virtual override returns (uint256) {
875         if (owner == address(0)) revert BalanceQueryForZeroAddress();
876         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
877     }
878 
879     /**
880      * Returns the number of tokens minted by `owner`.
881      */
882     function _numberMinted(address owner) internal view returns (uint256) {
883         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
884     }
885 
886     /**
887      * Returns the number of tokens burned by or on behalf of `owner`.
888      */
889     function _numberBurned(address owner) internal view returns (uint256) {
890         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
891     }
892 
893     /**
894      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
895      */
896     function _getAux(address owner) internal view returns (uint64) {
897         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
898     }
899 
900     /**
901      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
902      * If there are multiple variables, please pack them into a uint64.
903      */
904     function _setAux(address owner, uint64 aux) internal virtual {
905         uint256 packed = _packedAddressData[owner];
906         uint256 auxCasted;
907         // Cast `aux` with assembly to avoid redundant masking.
908         assembly {
909             auxCasted := aux
910         }
911         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
912         _packedAddressData[owner] = packed;
913     }
914 
915     // =============================================================
916     //                            IERC165
917     // =============================================================
918 
919     /**
920      * @dev Returns true if this contract implements the interface defined by
921      * `interfaceId`. See the corresponding
922      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
923      * to learn more about how these ids are created.
924      *
925      * This function call must use less than 30000 gas.
926      */
927     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
928         // The interface IDs are constants representing the first 4 bytes
929         // of the XOR of all function selectors in the interface.
930         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
931         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
932         return
933             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
934             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
935             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
936     }
937 
938     // =============================================================
939     //                        IERC721Metadata
940     // =============================================================
941 
942     /**
943      * @dev Returns the token collection name.
944      */
945     function name() public view virtual override returns (string memory) {
946         return _name;
947     }
948 
949     /**
950      * @dev Returns the token collection symbol.
951      */
952     function symbol() public view virtual override returns (string memory) {
953         return _symbol;
954     }
955 
956     /**
957      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
958      */
959     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
960         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
961 
962         string memory baseURI = _baseURI();
963         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
964     }
965 
966     /**
967      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969      * by default, it can be overridden in child contracts.
970      */
971     function _baseURI() internal view virtual returns (string memory) {
972         return '';
973     }
974 
975     // =============================================================
976     //                     OWNERSHIPS OPERATIONS
977     // =============================================================
978 
979     /**
980      * @dev Returns the owner of the `tokenId` token.
981      *
982      * Requirements:
983      *
984      * - `tokenId` must exist.
985      */
986     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
987         return address(uint160(_packedOwnershipOf(tokenId)));
988     }
989 
990     /**
991      * @dev Gas spent here starts off proportional to the maximum mint batch size.
992      * It gradually moves to O(1) as tokens get transferred around over time.
993      */
994     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
995         return _unpackedOwnership(_packedOwnershipOf(tokenId));
996     }
997 
998     /**
999      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1000      */
1001     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1002         return _unpackedOwnership(_packedOwnerships[index]);
1003     }
1004 
1005     /**
1006      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1007      */
1008     function _initializeOwnershipAt(uint256 index) internal virtual {
1009         if (_packedOwnerships[index] == 0) {
1010             _packedOwnerships[index] = _packedOwnershipOf(index);
1011         }
1012     }
1013 
1014     /**
1015      * Returns the packed ownership data of `tokenId`.
1016      */
1017     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1018         uint256 curr = tokenId;
1019 
1020         unchecked {
1021             if (_startTokenId() <= curr)
1022                 if (curr < _currentIndex) {
1023                     uint256 packed = _packedOwnerships[curr];
1024                     // If not burned.
1025                     if (packed & _BITMASK_BURNED == 0) {
1026                         // Invariant:
1027                         // There will always be an initialized ownership slot
1028                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1029                         // before an unintialized ownership slot
1030                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1031                         // Hence, `curr` will not underflow.
1032                         //
1033                         // We can directly compare the packed value.
1034                         // If the address is zero, packed will be zero.
1035                         while (packed == 0) {
1036                             packed = _packedOwnerships[--curr];
1037                         }
1038                         return packed;
1039                     }
1040                 }
1041         }
1042         revert OwnerQueryForNonexistentToken();
1043     }
1044 
1045     /**
1046      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1047      */
1048     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1049         ownership.addr = address(uint160(packed));
1050         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1051         ownership.burned = packed & _BITMASK_BURNED != 0;
1052         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1053     }
1054 
1055     /**
1056      * @dev Packs ownership data into a single uint256.
1057      */
1058     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1059         assembly {
1060             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1061             owner := and(owner, _BITMASK_ADDRESS)
1062             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1063             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1064         }
1065     }
1066 
1067     /**
1068      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1069      */
1070     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1071         // For branchless setting of the `nextInitialized` flag.
1072         assembly {
1073             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1074             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1075         }
1076     }
1077 
1078     // =============================================================
1079     //                      APPROVAL OPERATIONS
1080     // =============================================================
1081 
1082     /**
1083      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1084      * The approval is cleared when the token is transferred.
1085      *
1086      * Only a single account can be approved at a time, so approving the
1087      * zero address clears previous approvals.
1088      *
1089      * Requirements:
1090      *
1091      * - The caller must own the token or be an approved operator.
1092      * - `tokenId` must exist.
1093      *
1094      * Emits an {Approval} event.
1095      */
1096     function approve(address to, uint256 tokenId) public payable virtual override {
1097         address owner = ownerOf(tokenId);
1098 
1099         if (_msgSenderERC721A() != owner)
1100             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1101                 revert ApprovalCallerNotOwnerNorApproved();
1102             }
1103 
1104         _tokenApprovals[tokenId].value = to;
1105         emit Approval(owner, to, tokenId);
1106     }
1107 
1108     /**
1109      * @dev Returns the account approved for `tokenId` token.
1110      *
1111      * Requirements:
1112      *
1113      * - `tokenId` must exist.
1114      */
1115     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1116         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1117 
1118         return _tokenApprovals[tokenId].value;
1119     }
1120 
1121     /**
1122      * @dev Approve or remove `operator` as an operator for the caller.
1123      * Operators can call {transferFrom} or {safeTransferFrom}
1124      * for any token owned by the caller.
1125      *
1126      * Requirements:
1127      *
1128      * - The `operator` cannot be the caller.
1129      *
1130      * Emits an {ApprovalForAll} event.
1131      */
1132     function setApprovalForAll(address operator, bool approved) public virtual override {
1133         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1134         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1135     }
1136 
1137     /**
1138      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1139      *
1140      * See {setApprovalForAll}.
1141      */
1142     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1143         return _operatorApprovals[owner][operator];
1144     }
1145 
1146     /**
1147      * @dev Returns whether `tokenId` exists.
1148      *
1149      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1150      *
1151      * Tokens start existing when they are minted. See {_mint}.
1152      */
1153     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1154         return
1155             _startTokenId() <= tokenId &&
1156             tokenId < _currentIndex && // If within bounds,
1157             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1158     }
1159 
1160     /**
1161      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1162      */
1163     function _isSenderApprovedOrOwner(
1164         address approvedAddress,
1165         address owner,
1166         address msgSender
1167     ) private pure returns (bool result) {
1168         assembly {
1169             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1170             owner := and(owner, _BITMASK_ADDRESS)
1171             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1172             msgSender := and(msgSender, _BITMASK_ADDRESS)
1173             // `msgSender == owner || msgSender == approvedAddress`.
1174             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1175         }
1176     }
1177 
1178     /**
1179      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1180      */
1181     function _getApprovedSlotAndAddress(uint256 tokenId)
1182         private
1183         view
1184         returns (uint256 approvedAddressSlot, address approvedAddress)
1185     {
1186         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1187         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1188         assembly {
1189             approvedAddressSlot := tokenApproval.slot
1190             approvedAddress := sload(approvedAddressSlot)
1191         }
1192     }
1193 
1194     // =============================================================
1195     //                      TRANSFER OPERATIONS
1196     // =============================================================
1197 
1198     /**
1199      * @dev Transfers `tokenId` from `from` to `to`.
1200      *
1201      * Requirements:
1202      *
1203      * - `from` cannot be the zero address.
1204      * - `to` cannot be the zero address.
1205      * - `tokenId` token must be owned by `from`.
1206      * - If the caller is not `from`, it must be approved to move this token
1207      * by either {approve} or {setApprovalForAll}.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function transferFrom(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) public payable virtual override {
1216         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1217 
1218         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1219 
1220         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1221 
1222         // The nested ifs save around 20+ gas over a compound boolean condition.
1223         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1224             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1225 
1226         if (to == address(0)) revert TransferToZeroAddress();
1227 
1228         _beforeTokenTransfers(from, to, tokenId, 1);
1229 
1230         // Clear approvals from the previous owner.
1231         assembly {
1232             if approvedAddress {
1233                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1234                 sstore(approvedAddressSlot, 0)
1235             }
1236         }
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1241         unchecked {
1242             // We can directly increment and decrement the balances.
1243             --_packedAddressData[from]; // Updates: `balance -= 1`.
1244             ++_packedAddressData[to]; // Updates: `balance += 1`.
1245 
1246             // Updates:
1247             // - `address` to the next owner.
1248             // - `startTimestamp` to the timestamp of transfering.
1249             // - `burned` to `false`.
1250             // - `nextInitialized` to `true`.
1251             _packedOwnerships[tokenId] = _packOwnershipData(
1252                 to,
1253                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1254             );
1255 
1256             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1257             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1258                 uint256 nextTokenId = tokenId + 1;
1259                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1260                 if (_packedOwnerships[nextTokenId] == 0) {
1261                     // If the next slot is within bounds.
1262                     if (nextTokenId != _currentIndex) {
1263                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1264                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1265                     }
1266                 }
1267             }
1268         }
1269 
1270         emit Transfer(from, to, tokenId);
1271         _afterTokenTransfers(from, to, tokenId, 1);
1272     }
1273 
1274     /**
1275      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1276      */
1277     function safeTransferFrom(
1278         address from,
1279         address to,
1280         uint256 tokenId
1281     ) public payable virtual override {
1282         safeTransferFrom(from, to, tokenId, '');
1283     }
1284 
1285     /**
1286      * @dev Safely transfers `tokenId` token from `from` to `to`.
1287      *
1288      * Requirements:
1289      *
1290      * - `from` cannot be the zero address.
1291      * - `to` cannot be the zero address.
1292      * - `tokenId` token must exist and be owned by `from`.
1293      * - If the caller is not `from`, it must be approved to move this token
1294      * by either {approve} or {setApprovalForAll}.
1295      * - If `to` refers to a smart contract, it must implement
1296      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1297      *
1298      * Emits a {Transfer} event.
1299      */
1300     function safeTransferFrom(
1301         address from,
1302         address to,
1303         uint256 tokenId,
1304         bytes memory _data
1305     ) public payable virtual override {
1306         transferFrom(from, to, tokenId);
1307         if (to.code.length != 0)
1308             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1309                 revert TransferToNonERC721ReceiverImplementer();
1310             }
1311     }
1312 
1313     /**
1314      * @dev Hook that is called before a set of serially-ordered token IDs
1315      * are about to be transferred. This includes minting.
1316      * And also called before burning one token.
1317      *
1318      * `startTokenId` - the first token ID to be transferred.
1319      * `quantity` - the amount to be transferred.
1320      *
1321      * Calling conditions:
1322      *
1323      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1324      * transferred to `to`.
1325      * - When `from` is zero, `tokenId` will be minted for `to`.
1326      * - When `to` is zero, `tokenId` will be burned by `from`.
1327      * - `from` and `to` are never both zero.
1328      */
1329     function _beforeTokenTransfers(
1330         address from,
1331         address to,
1332         uint256 startTokenId,
1333         uint256 quantity
1334     ) internal virtual {}
1335 
1336     /**
1337      * @dev Hook that is called after a set of serially-ordered token IDs
1338      * have been transferred. This includes minting.
1339      * And also called after one token has been burned.
1340      *
1341      * `startTokenId` - the first token ID to be transferred.
1342      * `quantity` - the amount to be transferred.
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` has been minted for `to`.
1349      * - When `to` is zero, `tokenId` has been burned by `from`.
1350      * - `from` and `to` are never both zero.
1351      */
1352     function _afterTokenTransfers(
1353         address from,
1354         address to,
1355         uint256 startTokenId,
1356         uint256 quantity
1357     ) internal virtual {}
1358 
1359     /**
1360      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1361      *
1362      * `from` - Previous owner of the given token ID.
1363      * `to` - Target address that will receive the token.
1364      * `tokenId` - Token ID to be transferred.
1365      * `_data` - Optional data to send along with the call.
1366      *
1367      * Returns whether the call correctly returned the expected magic value.
1368      */
1369     function _checkContractOnERC721Received(
1370         address from,
1371         address to,
1372         uint256 tokenId,
1373         bytes memory _data
1374     ) private returns (bool) {
1375         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1376             bytes4 retval
1377         ) {
1378             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1379         } catch (bytes memory reason) {
1380             if (reason.length == 0) {
1381                 revert TransferToNonERC721ReceiverImplementer();
1382             } else {
1383                 assembly {
1384                     revert(add(32, reason), mload(reason))
1385                 }
1386             }
1387         }
1388     }
1389 
1390     // =============================================================
1391     //                        MINT OPERATIONS
1392     // =============================================================
1393 
1394     /**
1395      * @dev Mints `quantity` tokens and transfers them to `to`.
1396      *
1397      * Requirements:
1398      *
1399      * - `to` cannot be the zero address.
1400      * - `quantity` must be greater than 0.
1401      *
1402      * Emits a {Transfer} event for each mint.
1403      */
1404     function _mint(address to, uint256 quantity) internal virtual {
1405         uint256 startTokenId = _currentIndex;
1406         if (quantity == 0) revert MintZeroQuantity();
1407 
1408         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1409 
1410         // Overflows are incredibly unrealistic.
1411         // `balance` and `numberMinted` have a maximum limit of 2**64.
1412         // `tokenId` has a maximum limit of 2**256.
1413         unchecked {
1414             // Updates:
1415             // - `balance += quantity`.
1416             // - `numberMinted += quantity`.
1417             //
1418             // We can directly add to the `balance` and `numberMinted`.
1419             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1420 
1421             // Updates:
1422             // - `address` to the owner.
1423             // - `startTimestamp` to the timestamp of minting.
1424             // - `burned` to `false`.
1425             // - `nextInitialized` to `quantity == 1`.
1426             _packedOwnerships[startTokenId] = _packOwnershipData(
1427                 to,
1428                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1429             );
1430 
1431             uint256 toMasked;
1432             uint256 end = startTokenId + quantity;
1433 
1434             // Use assembly to loop and emit the `Transfer` event for gas savings.
1435             // The duplicated `log4` removes an extra check and reduces stack juggling.
1436             // The assembly, together with the surrounding Solidity code, have been
1437             // delicately arranged to nudge the compiler into producing optimized opcodes.
1438             assembly {
1439                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1440                 toMasked := and(to, _BITMASK_ADDRESS)
1441                 // Emit the `Transfer` event.
1442                 log4(
1443                     0, // Start of data (0, since no data).
1444                     0, // End of data (0, since no data).
1445                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1446                     0, // `address(0)`.
1447                     toMasked, // `to`.
1448                     startTokenId // `tokenId`.
1449                 )
1450 
1451                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1452                 // that overflows uint256 will make the loop run out of gas.
1453                 // The compiler will optimize the `iszero` away for performance.
1454                 for {
1455                     let tokenId := add(startTokenId, 1)
1456                 } iszero(eq(tokenId, end)) {
1457                     tokenId := add(tokenId, 1)
1458                 } {
1459                     // Emit the `Transfer` event. Similar to above.
1460                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1461                 }
1462             }
1463             if (toMasked == 0) revert MintToZeroAddress();
1464 
1465             _currentIndex = end;
1466         }
1467         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1468     }
1469 
1470     /**
1471      * @dev Mints `quantity` tokens and transfers them to `to`.
1472      *
1473      * This function is intended for efficient minting only during contract creation.
1474      *
1475      * It emits only one {ConsecutiveTransfer} as defined in
1476      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1477      * instead of a sequence of {Transfer} event(s).
1478      *
1479      * Calling this function outside of contract creation WILL make your contract
1480      * non-compliant with the ERC721 standard.
1481      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1482      * {ConsecutiveTransfer} event is only permissible during contract creation.
1483      *
1484      * Requirements:
1485      *
1486      * - `to` cannot be the zero address.
1487      * - `quantity` must be greater than 0.
1488      *
1489      * Emits a {ConsecutiveTransfer} event.
1490      */
1491     function _mintERC2309(address to, uint256 quantity) internal virtual {
1492         uint256 startTokenId = _currentIndex;
1493         if (to == address(0)) revert MintToZeroAddress();
1494         if (quantity == 0) revert MintZeroQuantity();
1495         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1496 
1497         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1498 
1499         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1500         unchecked {
1501             // Updates:
1502             // - `balance += quantity`.
1503             // - `numberMinted += quantity`.
1504             //
1505             // We can directly add to the `balance` and `numberMinted`.
1506             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1507 
1508             // Updates:
1509             // - `address` to the owner.
1510             // - `startTimestamp` to the timestamp of minting.
1511             // - `burned` to `false`.
1512             // - `nextInitialized` to `quantity == 1`.
1513             _packedOwnerships[startTokenId] = _packOwnershipData(
1514                 to,
1515                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1516             );
1517 
1518             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1519 
1520             _currentIndex = startTokenId + quantity;
1521         }
1522         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1523     }
1524 
1525     /**
1526      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1527      *
1528      * Requirements:
1529      *
1530      * - If `to` refers to a smart contract, it must implement
1531      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1532      * - `quantity` must be greater than 0.
1533      *
1534      * See {_mint}.
1535      *
1536      * Emits a {Transfer} event for each mint.
1537      */
1538     function _safeMint(
1539         address to,
1540         uint256 quantity,
1541         bytes memory _data
1542     ) internal virtual {
1543         _mint(to, quantity);
1544 
1545         unchecked {
1546             if (to.code.length != 0) {
1547                 uint256 end = _currentIndex;
1548                 uint256 index = end - quantity;
1549                 do {
1550                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1551                         revert TransferToNonERC721ReceiverImplementer();
1552                     }
1553                 } while (index < end);
1554                 // Reentrancy protection.
1555                 if (_currentIndex != end) revert();
1556             }
1557         }
1558     }
1559 
1560     /**
1561      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1562      */
1563     function _safeMint(address to, uint256 quantity) internal virtual {
1564         _safeMint(to, quantity, '');
1565     }
1566 
1567     // =============================================================
1568     //                        BURN OPERATIONS
1569     // =============================================================
1570 
1571     /**
1572      * @dev Equivalent to `_burn(tokenId, false)`.
1573      */
1574     function _burn(uint256 tokenId) internal virtual {
1575         _burn(tokenId, false);
1576     }
1577 
1578     /**
1579      * @dev Destroys `tokenId`.
1580      * The approval is cleared when the token is burned.
1581      *
1582      * Requirements:
1583      *
1584      * - `tokenId` must exist.
1585      *
1586      * Emits a {Transfer} event.
1587      */
1588     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1589         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1590 
1591         address from = address(uint160(prevOwnershipPacked));
1592 
1593         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1594 
1595         if (approvalCheck) {
1596             // The nested ifs save around 20+ gas over a compound boolean condition.
1597             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1598                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1599         }
1600 
1601         _beforeTokenTransfers(from, address(0), tokenId, 1);
1602 
1603         // Clear approvals from the previous owner.
1604         assembly {
1605             if approvedAddress {
1606                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1607                 sstore(approvedAddressSlot, 0)
1608             }
1609         }
1610 
1611         // Underflow of the sender's balance is impossible because we check for
1612         // ownership above and the recipient's balance can't realistically overflow.
1613         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1614         unchecked {
1615             // Updates:
1616             // - `balance -= 1`.
1617             // - `numberBurned += 1`.
1618             //
1619             // We can directly decrement the balance, and increment the number burned.
1620             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1621             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1622 
1623             // Updates:
1624             // - `address` to the last owner.
1625             // - `startTimestamp` to the timestamp of burning.
1626             // - `burned` to `true`.
1627             // - `nextInitialized` to `true`.
1628             _packedOwnerships[tokenId] = _packOwnershipData(
1629                 from,
1630                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1631             );
1632 
1633             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1634             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1635                 uint256 nextTokenId = tokenId + 1;
1636                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1637                 if (_packedOwnerships[nextTokenId] == 0) {
1638                     // If the next slot is within bounds.
1639                     if (nextTokenId != _currentIndex) {
1640                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1641                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1642                     }
1643                 }
1644             }
1645         }
1646 
1647         emit Transfer(from, address(0), tokenId);
1648         _afterTokenTransfers(from, address(0), tokenId, 1);
1649 
1650         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1651         unchecked {
1652             _burnCounter++;
1653         }
1654     }
1655 
1656     // =============================================================
1657     //                     EXTRA DATA OPERATIONS
1658     // =============================================================
1659 
1660     /**
1661      * @dev Directly sets the extra data for the ownership data `index`.
1662      */
1663     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1664         uint256 packed = _packedOwnerships[index];
1665         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1666         uint256 extraDataCasted;
1667         // Cast `extraData` with assembly to avoid redundant masking.
1668         assembly {
1669             extraDataCasted := extraData
1670         }
1671         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1672         _packedOwnerships[index] = packed;
1673     }
1674 
1675     /**
1676      * @dev Called during each token transfer to set the 24bit `extraData` field.
1677      * Intended to be overridden by the cosumer contract.
1678      *
1679      * `previousExtraData` - the value of `extraData` before transfer.
1680      *
1681      * Calling conditions:
1682      *
1683      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1684      * transferred to `to`.
1685      * - When `from` is zero, `tokenId` will be minted for `to`.
1686      * - When `to` is zero, `tokenId` will be burned by `from`.
1687      * - `from` and `to` are never both zero.
1688      */
1689     function _extraData(
1690         address from,
1691         address to,
1692         uint24 previousExtraData
1693     ) internal view virtual returns (uint24) {}
1694 
1695     /**
1696      * @dev Returns the next extra data for the packed ownership data.
1697      * The returned result is shifted into position.
1698      */
1699     function _nextExtraData(
1700         address from,
1701         address to,
1702         uint256 prevOwnershipPacked
1703     ) private view returns (uint256) {
1704         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1705         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1706     }
1707 
1708     // =============================================================
1709     //                       OTHER OPERATIONS
1710     // =============================================================
1711 
1712     /**
1713      * @dev Returns the message sender (defaults to `msg.sender`).
1714      *
1715      * If you are writing GSN compatible contracts, you need to override this function.
1716      */
1717     function _msgSenderERC721A() internal view virtual returns (address) {
1718         return msg.sender;
1719     }
1720 
1721     /**
1722      * @dev Converts a uint256 to its ASCII string decimal representation.
1723      */
1724     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1725         assembly {
1726             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1727             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1728             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1729             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1730             let m := add(mload(0x40), 0xa0)
1731             // Update the free memory pointer to allocate.
1732             mstore(0x40, m)
1733             // Assign the `str` to the end.
1734             str := sub(m, 0x20)
1735             // Zeroize the slot after the string.
1736             mstore(str, 0)
1737 
1738             // Cache the end of the memory to calculate the length later.
1739             let end := str
1740 
1741             // We write the string from rightmost digit to leftmost digit.
1742             // The following is essentially a do-while loop that also handles the zero case.
1743             // prettier-ignore
1744             for { let temp := value } 1 {} {
1745                 str := sub(str, 1)
1746                 // Write the character to the pointer.
1747                 // The ASCII index of the '0' character is 48.
1748                 mstore8(str, add(48, mod(temp, 10)))
1749                 // Keep dividing `temp` until zero.
1750                 temp := div(temp, 10)
1751                 // prettier-ignore
1752                 if iszero(temp) { break }
1753             }
1754 
1755             let length := sub(end, str)
1756             // Move the pointer 32 bytes leftwards to make room for the length.
1757             str := sub(str, 0x20)
1758             // Store the length.
1759             mstore(str, length)
1760         }
1761     }
1762 }
1763 
1764 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1765 
1766 
1767 // ERC721A Contracts v4.2.3
1768 // Creator: Chiru Labs
1769 
1770 pragma solidity ^0.8.4;
1771 
1772 
1773 /**
1774  * @dev Interface of ERC721AQueryable.
1775  */
1776 interface IERC721AQueryable is IERC721A {
1777     /**
1778      * Invalid query range (`start` >= `stop`).
1779      */
1780     error InvalidQueryRange();
1781 
1782     /**
1783      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1784      *
1785      * If the `tokenId` is out of bounds:
1786      *
1787      * - `addr = address(0)`
1788      * - `startTimestamp = 0`
1789      * - `burned = false`
1790      * - `extraData = 0`
1791      *
1792      * If the `tokenId` is burned:
1793      *
1794      * - `addr = <Address of owner before token was burned>`
1795      * - `startTimestamp = <Timestamp when token was burned>`
1796      * - `burned = true`
1797      * - `extraData = <Extra data when token was burned>`
1798      *
1799      * Otherwise:
1800      *
1801      * - `addr = <Address of owner>`
1802      * - `startTimestamp = <Timestamp of start of ownership>`
1803      * - `burned = false`
1804      * - `extraData = <Extra data at start of ownership>`
1805      */
1806     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1807 
1808     /**
1809      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1810      * See {ERC721AQueryable-explicitOwnershipOf}
1811      */
1812     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1813 
1814     /**
1815      * @dev Returns an array of token IDs owned by `owner`,
1816      * in the range [`start`, `stop`)
1817      * (i.e. `start <= tokenId < stop`).
1818      *
1819      * This function allows for tokens to be queried if the collection
1820      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1821      *
1822      * Requirements:
1823      *
1824      * - `start < stop`
1825      */
1826     function tokensOfOwnerIn(
1827         address owner,
1828         uint256 start,
1829         uint256 stop
1830     ) external view returns (uint256[] memory);
1831 
1832     /**
1833      * @dev Returns an array of token IDs owned by `owner`.
1834      *
1835      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1836      * It is meant to be called off-chain.
1837      *
1838      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1839      * multiple smaller scans if the collection is large enough to cause
1840      * an out-of-gas error (10K collections should be fine).
1841      */
1842     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1843 }
1844 
1845 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1846 
1847 
1848 // ERC721A Contracts v4.2.3
1849 // Creator: Chiru Labs
1850 
1851 pragma solidity ^0.8.4;
1852 
1853 
1854 
1855 /**
1856  * @title ERC721AQueryable.
1857  *
1858  * @dev ERC721A subclass with convenience query functions.
1859  */
1860 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1861     /**
1862      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1863      *
1864      * If the `tokenId` is out of bounds:
1865      *
1866      * - `addr = address(0)`
1867      * - `startTimestamp = 0`
1868      * - `burned = false`
1869      * - `extraData = 0`
1870      *
1871      * If the `tokenId` is burned:
1872      *
1873      * - `addr = <Address of owner before token was burned>`
1874      * - `startTimestamp = <Timestamp when token was burned>`
1875      * - `burned = true`
1876      * - `extraData = <Extra data when token was burned>`
1877      *
1878      * Otherwise:
1879      *
1880      * - `addr = <Address of owner>`
1881      * - `startTimestamp = <Timestamp of start of ownership>`
1882      * - `burned = false`
1883      * - `extraData = <Extra data at start of ownership>`
1884      */
1885     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1886         TokenOwnership memory ownership;
1887         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1888             return ownership;
1889         }
1890         ownership = _ownershipAt(tokenId);
1891         if (ownership.burned) {
1892             return ownership;
1893         }
1894         return _ownershipOf(tokenId);
1895     }
1896 
1897     /**
1898      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1899      * See {ERC721AQueryable-explicitOwnershipOf}
1900      */
1901     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1902         external
1903         view
1904         virtual
1905         override
1906         returns (TokenOwnership[] memory)
1907     {
1908         unchecked {
1909             uint256 tokenIdsLength = tokenIds.length;
1910             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1911             for (uint256 i; i != tokenIdsLength; ++i) {
1912                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1913             }
1914             return ownerships;
1915         }
1916     }
1917 
1918     /**
1919      * @dev Returns an array of token IDs owned by `owner`,
1920      * in the range [`start`, `stop`)
1921      * (i.e. `start <= tokenId < stop`).
1922      *
1923      * This function allows for tokens to be queried if the collection
1924      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1925      *
1926      * Requirements:
1927      *
1928      * - `start < stop`
1929      */
1930     function tokensOfOwnerIn(
1931         address owner,
1932         uint256 start,
1933         uint256 stop
1934     ) external view virtual override returns (uint256[] memory) {
1935         unchecked {
1936             if (start >= stop) revert InvalidQueryRange();
1937             uint256 tokenIdsIdx;
1938             uint256 stopLimit = _nextTokenId();
1939             // Set `start = max(start, _startTokenId())`.
1940             if (start < _startTokenId()) {
1941                 start = _startTokenId();
1942             }
1943             // Set `stop = min(stop, stopLimit)`.
1944             if (stop > stopLimit) {
1945                 stop = stopLimit;
1946             }
1947             uint256 tokenIdsMaxLength = balanceOf(owner);
1948             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1949             // to cater for cases where `balanceOf(owner)` is too big.
1950             if (start < stop) {
1951                 uint256 rangeLength = stop - start;
1952                 if (rangeLength < tokenIdsMaxLength) {
1953                     tokenIdsMaxLength = rangeLength;
1954                 }
1955             } else {
1956                 tokenIdsMaxLength = 0;
1957             }
1958             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1959             if (tokenIdsMaxLength == 0) {
1960                 return tokenIds;
1961             }
1962             // We need to call `explicitOwnershipOf(start)`,
1963             // because the slot at `start` may not be initialized.
1964             TokenOwnership memory ownership = explicitOwnershipOf(start);
1965             address currOwnershipAddr;
1966             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1967             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1968             if (!ownership.burned) {
1969                 currOwnershipAddr = ownership.addr;
1970             }
1971             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1972                 ownership = _ownershipAt(i);
1973                 if (ownership.burned) {
1974                     continue;
1975                 }
1976                 if (ownership.addr != address(0)) {
1977                     currOwnershipAddr = ownership.addr;
1978                 }
1979                 if (currOwnershipAddr == owner) {
1980                     tokenIds[tokenIdsIdx++] = i;
1981                 }
1982             }
1983             // Downsize the array to fit.
1984             assembly {
1985                 mstore(tokenIds, tokenIdsIdx)
1986             }
1987             return tokenIds;
1988         }
1989     }
1990 
1991     /**
1992      * @dev Returns an array of token IDs owned by `owner`.
1993      *
1994      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1995      * It is meant to be called off-chain.
1996      *
1997      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1998      * multiple smaller scans if the collection is large enough to cause
1999      * an out-of-gas error (10K collections should be fine).
2000      */
2001     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2002         unchecked {
2003             uint256 tokenIdsIdx;
2004             address currOwnershipAddr;
2005             uint256 tokenIdsLength = balanceOf(owner);
2006             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2007             TokenOwnership memory ownership;
2008             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2009                 ownership = _ownershipAt(i);
2010                 if (ownership.burned) {
2011                     continue;
2012                 }
2013                 if (ownership.addr != address(0)) {
2014                     currOwnershipAddr = ownership.addr;
2015                 }
2016                 if (currOwnershipAddr == owner) {
2017                     tokenIds[tokenIdsIdx++] = i;
2018                 }
2019             }
2020             return tokenIds;
2021         }
2022     }
2023 }
2024 
2025 // File: contracts/Cattietation.sol
2026 
2027 
2028 
2029 //   ____     _       _____    _____             U _____ u  _____      _       _____             U  ___ u  _   _     
2030 //U /"___|U  /"\  u  |_ " _|  |_ " _|     ___    \| ___"|/ |_ " _| U  /"\  u  |_ " _|     ___     \/"_ \/ | \ |"|    
2031 //\| | u   \/ _ \/     | |      | |      |_"_|    |  _|"     | |    \/ _ \/     | |      |_"_|    | | | |<|  \| |>   
2032 // | |/__  / ___ \    /| |\    /| |\      | |     | |___    /| |\   / ___ \    /| |\      | | .-,_| |_| |U| |\  |u   
2033 //  \____|/_/   \_\  u |_|U   u |_|U    U/| |\u   |_____|  u |_|U  /_/   \_\  u |_|U    U/| |\u\_)-\___/  |_| \_|    
2034 // _// \\  \\    >>  _// \\_  _// \\_.-,_|___|_,-.<<   >>  _// \\_  \\    >>  _// \\_.-,_|___|_,-.  \\    ||   \\,-. 
2035 //(__)(__)(__)  (__)(__) (__)(__) (__)\_)-' '-(_/(__) (__)(__) (__)(__)  (__)(__) (__)\_)-' '-(_/  (__)   (_")  (_/  
2036 
2037 pragma solidity ^0.8.13;
2038 
2039 
2040 
2041 
2042 
2043 
2044 contract Cattietation is
2045     Ownable,
2046     Pausable,
2047     ReentrancyGuard,
2048     ERC721AQueryable,
2049     OperatorFilterer
2050 {
2051     uint256 public constant MAX_SUPPLY = 800;
2052 
2053     string private _baseTokenURI;
2054     uint256 public mintPrice = 0 ether;
2055     uint256 public maxPerWallet = 1;
2056     mapping(address => uint256) public mintPerWallet;
2057     mapping(address => bool) public filteredAddress;
2058 
2059     modifier onlyEOA() {
2060         require(msg.sender == tx.origin, "Only EOA wallets can mint");
2061         _;
2062     }
2063 
2064     constructor()
2065         ERC721A("Cattietation", "CMS")
2066         OperatorFilterer(
2067             address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6),
2068             true
2069         )
2070     {
2071         filteredAddress[0x00000000000111AbE46ff893f3B2fdF1F759a8A8] = true;
2072         filteredAddress[0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e] = true;
2073 
2074         _pause();
2075     }
2076 
2077 
2078     function mint(uint256 _quantity) external payable nonReentrant onlyEOA whenNotPaused {
2079         require(
2080             (totalSupply() + _quantity) <= MAX_SUPPLY,
2081             "// Max supply exceeded."
2082         );
2083         require(
2084             (mintPerWallet[msg.sender] + _quantity) <= maxPerWallet,
2085             "// Max mint exceeded."
2086         );
2087         require(msg.value >= (mintPrice * _quantity), "// Wrong mint price.");
2088 
2089         mintPerWallet[msg.sender] += _quantity;
2090         _safeMint(msg.sender, _quantity);
2091     }
2092 
2093     function reserveMint(address receiver, uint256 mintAmount)
2094         external
2095         onlyOwner
2096     {
2097         _safeMint(receiver, mintAmount);
2098     }
2099 
2100     function setBaseURI(string calldata baseURI) external onlyOwner {
2101         _baseTokenURI = baseURI;
2102     }
2103 
2104     function _startTokenId() internal view virtual override returns (uint256) {
2105         return 1;
2106     }
2107 
2108     function setFilteredAddress(address _address, bool _isFiltered)
2109         external
2110         onlyOwner
2111     {
2112         filteredAddress[_address] = _isFiltered;
2113     }
2114 
2115     function setMintPrice(uint256 _newPrice) external onlyOwner {
2116         mintPrice = _newPrice;
2117     }
2118 
2119     function setPause() external onlyOwner {
2120         if (paused()) _unpause();
2121         else _pause();
2122     }
2123 
2124     function withdraw() external onlyOwner {
2125         payable(msg.sender).transfer(address(this).balance);
2126     }
2127 
2128     function transferFrom(
2129         address from,
2130         address to,
2131         uint256 tokenId
2132     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2133         super.transferFrom(from, to, tokenId);
2134     }
2135 
2136     function safeTransferFrom(
2137         address from,
2138         address to,
2139         uint256 tokenId
2140     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2141         super.safeTransferFrom(from, to, tokenId);
2142     }
2143 
2144     function safeTransferFrom(
2145         address from,
2146         address to,
2147         uint256 tokenId,
2148         bytes memory data
2149     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2150         super.safeTransferFrom(from, to, tokenId, data);
2151     }
2152 
2153     function approve(address to, uint256 tokenId)
2154         public
2155         payable
2156         override(ERC721A, IERC721A)
2157     {
2158         require(!filteredAddress[to], "Not allowed to approve to this address");
2159         super.approve(to, tokenId);
2160     }
2161 
2162     function setApprovalForAll(address operator, bool approved)
2163         public
2164         override(ERC721A, IERC721A)
2165     {
2166         require(
2167             !filteredAddress[operator],
2168             "Not allowed to approval this address"
2169         );
2170         super.setApprovalForAll(operator, approved);
2171     }
2172 
2173     function supportsInterface(bytes4 interfaceId)
2174         public
2175         view
2176         virtual
2177         override(ERC721A, IERC721A)
2178         returns (bool)
2179     {
2180         return ERC721A.supportsInterface(interfaceId);
2181     }
2182 
2183     function _baseURI() internal view virtual override returns (string memory) {
2184         return _baseTokenURI;
2185     }
2186 }