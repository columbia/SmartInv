1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/lib/Constants.sol
3 
4 
5 pragma solidity ^0.8.13;
6 
7 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
8 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
9 
10 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
11 
12 
13 pragma solidity ^0.8.13;
14 
15 interface IOperatorFilterRegistry {
16     /**
17      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
18      *         true if supplied registrant address is not registered.
19      */
20     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
21 
22     /**
23      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
24      */
25     function register(address registrant) external;
26 
27     /**
28      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
29      */
30     function registerAndSubscribe(address registrant, address subscription) external;
31 
32     /**
33      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
34      *         address without subscribing.
35      */
36     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
37 
38     /**
39      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
40      *         Note that this does not remove any filtered addresses or codeHashes.
41      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
42      */
43     function unregister(address addr) external;
44 
45     /**
46      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
47      */
48     function updateOperator(address registrant, address operator, bool filtered) external;
49 
50     /**
51      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
52      */
53     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
54 
55     /**
56      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
57      */
58     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
59 
60     /**
61      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
62      */
63     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
64 
65     /**
66      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
67      *         subscription if present.
68      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
69      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
70      *         used.
71      */
72     function subscribe(address registrant, address registrantToSubscribe) external;
73 
74     /**
75      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
76      */
77     function unsubscribe(address registrant, bool copyExistingEntries) external;
78 
79     /**
80      * @notice Get the subscription address of a given registrant, if any.
81      */
82     function subscriptionOf(address addr) external returns (address registrant);
83 
84     /**
85      * @notice Get the set of addresses subscribed to a given registrant.
86      *         Note that order is not guaranteed as updates are made.
87      */
88     function subscribers(address registrant) external returns (address[] memory);
89 
90     /**
91      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
92      *         Note that order is not guaranteed as updates are made.
93      */
94     function subscriberAt(address registrant, uint256 index) external returns (address);
95 
96     /**
97      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
98      */
99     function copyEntriesOf(address registrant, address registrantToCopy) external;
100 
101     /**
102      * @notice Returns true if operator is filtered by a given address or its subscription.
103      */
104     function isOperatorFiltered(address registrant, address operator) external returns (bool);
105 
106     /**
107      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
108      */
109     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
110 
111     /**
112      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
113      */
114     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
115 
116     /**
117      * @notice Returns a list of filtered operators for a given address or its subscription.
118      */
119     function filteredOperators(address addr) external returns (address[] memory);
120 
121     /**
122      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
123      *         Note that order is not guaranteed as updates are made.
124      */
125     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
126 
127     /**
128      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
129      *         its subscription.
130      *         Note that order is not guaranteed as updates are made.
131      */
132     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
133 
134     /**
135      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
136      *         its subscription.
137      *         Note that order is not guaranteed as updates are made.
138      */
139     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
140 
141     /**
142      * @notice Returns true if an address has registered
143      */
144     function isRegistered(address addr) external returns (bool);
145 
146     /**
147      * @dev Convenience method to compute the code hash of an arbitrary contract
148      */
149     function codeHashOf(address addr) external returns (bytes32);
150 }
151 
152 // File: operator-filter-registry/src/OperatorFilterer.sol
153 
154 
155 pragma solidity ^0.8.13;
156 
157 
158 /**
159  * @title  OperatorFilterer
160  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
161  *         registrant's entries in the OperatorFilterRegistry.
162  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
163  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
164  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
165  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
166  *         administration methods on the contract itself to interact with the registry otherwise the subscription
167  *         will be locked to the options set during construction.
168  */
169 
170 abstract contract OperatorFilterer {
171     /// @dev Emitted when an operator is not allowed.
172     error OperatorNotAllowed(address operator);
173 
174     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
175         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
176 
177     /// @dev The constructor that is called when the contract is being deployed.
178     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
179         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
180         // will not revert, but the contract will need to be registered with the registry once it is deployed in
181         // order for the modifier to filter addresses.
182         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
183             if (subscribe) {
184                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
185             } else {
186                 if (subscriptionOrRegistrantToCopy != address(0)) {
187                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
188                 } else {
189                     OPERATOR_FILTER_REGISTRY.register(address(this));
190                 }
191             }
192         }
193     }
194 
195     /**
196      * @dev A helper function to check if an operator is allowed.
197      */
198     modifier onlyAllowedOperator(address from) virtual {
199         // Allow spending tokens from addresses with balance
200         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
201         // from an EOA.
202         if (from != msg.sender) {
203             _checkFilterOperator(msg.sender);
204         }
205         _;
206     }
207 
208     /**
209      * @dev A helper function to check if an operator approval is allowed.
210      */
211     modifier onlyAllowedOperatorApproval(address operator) virtual {
212         _checkFilterOperator(operator);
213         _;
214     }
215 
216     /**
217      * @dev A helper function to check if an operator is allowed.
218      */
219     function _checkFilterOperator(address operator) internal view virtual {
220         // Check registry code length to facilitate testing in environments without a deployed registry.
221         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
222             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
223             // may specify their own OperatorFilterRegistry implementations, which may behave differently
224             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
225                 revert OperatorNotAllowed(operator);
226             }
227         }
228     }
229 }
230 
231 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
232 
233 
234 pragma solidity ^0.8.13;
235 
236 
237 /**
238  * @title  DefaultOperatorFilterer
239  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
240  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
241  *         administration methods on the contract itself to interact with the registry otherwise the subscription
242  *         will be locked to the options set during construction.
243  */
244 
245 abstract contract DefaultOperatorFilterer is OperatorFilterer {
246     /// @dev The constructor that is called when the contract is being deployed.
247     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
248 }
249 
250 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @dev Contract module that helps prevent reentrant calls to a function.
259  *
260  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
261  * available, which can be applied to functions to make sure there are no nested
262  * (reentrant) calls to them.
263  *
264  * Note that because there is a single `nonReentrant` guard, functions marked as
265  * `nonReentrant` may not call one another. This can be worked around by making
266  * those functions `private`, and then adding `external` `nonReentrant` entry
267  * points to them.
268  *
269  * TIP: If you would like to learn more about reentrancy and alternative ways
270  * to protect against it, check out our blog post
271  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
272  */
273 abstract contract ReentrancyGuard {
274     // Booleans are more expensive than uint256 or any type that takes up a full
275     // word because each write operation emits an extra SLOAD to first read the
276     // slot's contents, replace the bits taken up by the boolean, and then write
277     // back. This is the compiler's defense against contract upgrades and
278     // pointer aliasing, and it cannot be disabled.
279 
280     // The values being non-zero value makes deployment a bit more expensive,
281     // but in exchange the refund on every call to nonReentrant will be lower in
282     // amount. Since refunds are capped to a percentage of the total
283     // transaction's gas, it is best to keep them low in cases like this one, to
284     // increase the likelihood of the full refund coming into effect.
285     uint256 private constant _NOT_ENTERED = 1;
286     uint256 private constant _ENTERED = 2;
287 
288     uint256 private _status;
289 
290     constructor() {
291         _status = _NOT_ENTERED;
292     }
293 
294     /**
295      * @dev Prevents a contract from calling itself, directly or indirectly.
296      * Calling a `nonReentrant` function from another `nonReentrant`
297      * function is not supported. It is possible to prevent this from happening
298      * by making the `nonReentrant` function external, and making it call a
299      * `private` function that does the actual work.
300      */
301     modifier nonReentrant() {
302         _nonReentrantBefore();
303         _;
304         _nonReentrantAfter();
305     }
306 
307     function _nonReentrantBefore() private {
308         // On the first call to nonReentrant, _status will be _NOT_ENTERED
309         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
310 
311         // Any calls to nonReentrant after this point will fail
312         _status = _ENTERED;
313     }
314 
315     function _nonReentrantAfter() private {
316         // By storing the original value once again, a refund is triggered (see
317         // https://eips.ethereum.org/EIPS/eip-2200)
318         _status = _NOT_ENTERED;
319     }
320 
321     /**
322      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
323      * `nonReentrant` function in the call stack.
324      */
325     function _reentrancyGuardEntered() internal view returns (bool) {
326         return _status == _ENTERED;
327     }
328 }
329 
330 // File: @openzeppelin/contracts/utils/Context.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Provides information about the current execution context, including the
339  * sender of the transaction and its data. While these are generally available
340  * via msg.sender and msg.data, they should not be accessed in such a direct
341  * manner, since when dealing with meta-transactions the account sending and
342  * paying for execution may not be the actual sender (as far as an application
343  * is concerned).
344  *
345  * This contract is only required for intermediate, library-like contracts.
346  */
347 abstract contract Context {
348     function _msgSender() internal view virtual returns (address) {
349         return msg.sender;
350     }
351 
352     function _msgData() internal view virtual returns (bytes calldata) {
353         return msg.data;
354     }
355 }
356 
357 // File: @openzeppelin/contracts/access/Ownable.sol
358 
359 
360 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 
365 /**
366  * @dev Contract module which provides a basic access control mechanism, where
367  * there is an account (an owner) that can be granted exclusive access to
368  * specific functions.
369  *
370  * By default, the owner account will be the one that deploys the contract. This
371  * can later be changed with {transferOwnership}.
372  *
373  * This module is used through inheritance. It will make available the modifier
374  * `onlyOwner`, which can be applied to your functions to restrict their use to
375  * the owner.
376  */
377 abstract contract Ownable is Context {
378     address private _owner;
379 
380     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
381 
382     /**
383      * @dev Initializes the contract setting the deployer as the initial owner.
384      */
385     constructor() {
386         _transferOwnership(_msgSender());
387     }
388 
389     /**
390      * @dev Throws if called by any account other than the owner.
391      */
392     modifier onlyOwner() {
393         _checkOwner();
394         _;
395     }
396 
397     /**
398      * @dev Returns the address of the current owner.
399      */
400     function owner() public view virtual returns (address) {
401         return _owner;
402     }
403 
404     /**
405      * @dev Throws if the sender is not the owner.
406      */
407     function _checkOwner() internal view virtual {
408         require(owner() == _msgSender(), "Ownable: caller is not the owner");
409     }
410 
411     /**
412      * @dev Leaves the contract without owner. It will not be possible to call
413      * `onlyOwner` functions. Can only be called by the current owner.
414      *
415      * NOTE: Renouncing ownership will leave the contract without an owner,
416      * thereby disabling any functionality that is only available to the owner.
417      */
418     function renounceOwnership() public virtual onlyOwner {
419         _transferOwnership(address(0));
420     }
421 
422     /**
423      * @dev Transfers ownership of the contract to a new account (`newOwner`).
424      * Can only be called by the current owner.
425      */
426     function transferOwnership(address newOwner) public virtual onlyOwner {
427         require(newOwner != address(0), "Ownable: new owner is the zero address");
428         _transferOwnership(newOwner);
429     }
430 
431     /**
432      * @dev Transfers ownership of the contract to a new account (`newOwner`).
433      * Internal function without access restriction.
434      */
435     function _transferOwnership(address newOwner) internal virtual {
436         address oldOwner = _owner;
437         _owner = newOwner;
438         emit OwnershipTransferred(oldOwner, newOwner);
439     }
440 }
441 
442 // File: erc721a/contracts/IERC721A.sol
443 
444 
445 // ERC721A Contracts v4.2.3
446 // Creator: Chiru Labs
447 
448 pragma solidity ^0.8.4;
449 
450 /**
451  * @dev Interface of ERC721A.
452  */
453 interface IERC721A {
454     /**
455      * The caller must own the token or be an approved operator.
456      */
457     error ApprovalCallerNotOwnerNorApproved();
458 
459     /**
460      * The token does not exist.
461      */
462     error ApprovalQueryForNonexistentToken();
463 
464     /**
465      * Cannot query the balance for the zero address.
466      */
467     error BalanceQueryForZeroAddress();
468 
469     /**
470      * Cannot mint to the zero address.
471      */
472     error MintToZeroAddress();
473 
474     /**
475      * The quantity of tokens minted must be more than zero.
476      */
477     error MintZeroQuantity();
478 
479     /**
480      * The token does not exist.
481      */
482     error OwnerQueryForNonexistentToken();
483 
484     /**
485      * The caller must own the token or be an approved operator.
486      */
487     error TransferCallerNotOwnerNorApproved();
488 
489     /**
490      * The token must be owned by `from`.
491      */
492     error TransferFromIncorrectOwner();
493 
494     /**
495      * Cannot safely transfer to a contract that does not implement the
496      * ERC721Receiver interface.
497      */
498     error TransferToNonERC721ReceiverImplementer();
499 
500     /**
501      * Cannot transfer to the zero address.
502      */
503     error TransferToZeroAddress();
504 
505     /**
506      * The token does not exist.
507      */
508     error URIQueryForNonexistentToken();
509 
510     /**
511      * The `quantity` minted with ERC2309 exceeds the safety limit.
512      */
513     error MintERC2309QuantityExceedsLimit();
514 
515     /**
516      * The `extraData` cannot be set on an unintialized ownership slot.
517      */
518     error OwnershipNotInitializedForExtraData();
519 
520     // =============================================================
521     //                            STRUCTS
522     // =============================================================
523 
524     struct TokenOwnership {
525         // The address of the owner.
526         address addr;
527         // Stores the start time of ownership with minimal overhead for tokenomics.
528         uint64 startTimestamp;
529         // Whether the token has been burned.
530         bool burned;
531         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
532         uint24 extraData;
533     }
534 
535     // =============================================================
536     //                         TOKEN COUNTERS
537     // =============================================================
538 
539     /**
540      * @dev Returns the total number of tokens in existence.
541      * Burned tokens will reduce the count.
542      * To get the total number of tokens minted, please see {_totalMinted}.
543      */
544     function totalSupply() external view returns (uint256);
545 
546     // =============================================================
547     //                            IERC165
548     // =============================================================
549 
550     /**
551      * @dev Returns true if this contract implements the interface defined by
552      * `interfaceId`. See the corresponding
553      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
554      * to learn more about how these ids are created.
555      *
556      * This function call must use less than 30000 gas.
557      */
558     function supportsInterface(bytes4 interfaceId) external view returns (bool);
559 
560     // =============================================================
561     //                            IERC721
562     // =============================================================
563 
564     /**
565      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
566      */
567     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
571      */
572     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables or disables
576      * (`approved`) `operator` to manage all of its assets.
577      */
578     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
579 
580     /**
581      * @dev Returns the number of tokens in `owner`'s account.
582      */
583     function balanceOf(address owner) external view returns (uint256 balance);
584 
585     /**
586      * @dev Returns the owner of the `tokenId` token.
587      *
588      * Requirements:
589      *
590      * - `tokenId` must exist.
591      */
592     function ownerOf(uint256 tokenId) external view returns (address owner);
593 
594     /**
595      * @dev Safely transfers `tokenId` token from `from` to `to`,
596      * checking first that contract recipients are aware of the ERC721 protocol
597      * to prevent tokens from being forever locked.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be have been allowed to move
605      * this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement
607      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId,
615         bytes calldata data
616     ) external payable;
617 
618     /**
619      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
620      */
621     function safeTransferFrom(
622         address from,
623         address to,
624         uint256 tokenId
625     ) external payable;
626 
627     /**
628      * @dev Transfers `tokenId` from `from` to `to`.
629      *
630      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
631      * whenever possible.
632      *
633      * Requirements:
634      *
635      * - `from` cannot be the zero address.
636      * - `to` cannot be the zero address.
637      * - `tokenId` token must be owned by `from`.
638      * - If the caller is not `from`, it must be approved to move this token
639      * by either {approve} or {setApprovalForAll}.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) external payable;
648 
649     /**
650      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
651      * The approval is cleared when the token is transferred.
652      *
653      * Only a single account can be approved at a time, so approving the
654      * zero address clears previous approvals.
655      *
656      * Requirements:
657      *
658      * - The caller must own the token or be an approved operator.
659      * - `tokenId` must exist.
660      *
661      * Emits an {Approval} event.
662      */
663     function approve(address to, uint256 tokenId) external payable;
664 
665     /**
666      * @dev Approve or remove `operator` as an operator for the caller.
667      * Operators can call {transferFrom} or {safeTransferFrom}
668      * for any token owned by the caller.
669      *
670      * Requirements:
671      *
672      * - The `operator` cannot be the caller.
673      *
674      * Emits an {ApprovalForAll} event.
675      */
676     function setApprovalForAll(address operator, bool _approved) external;
677 
678     /**
679      * @dev Returns the account approved for `tokenId` token.
680      *
681      * Requirements:
682      *
683      * - `tokenId` must exist.
684      */
685     function getApproved(uint256 tokenId) external view returns (address operator);
686 
687     /**
688      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
689      *
690      * See {setApprovalForAll}.
691      */
692     function isApprovedForAll(address owner, address operator) external view returns (bool);
693 
694     // =============================================================
695     //                        IERC721Metadata
696     // =============================================================
697 
698     /**
699      * @dev Returns the token collection name.
700      */
701     function name() external view returns (string memory);
702 
703     /**
704      * @dev Returns the token collection symbol.
705      */
706     function symbol() external view returns (string memory);
707 
708     /**
709      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
710      */
711     function tokenURI(uint256 tokenId) external view returns (string memory);
712 
713     // =============================================================
714     //                           IERC2309
715     // =============================================================
716 
717     /**
718      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
719      * (inclusive) is transferred from `from` to `to`, as defined in the
720      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
721      *
722      * See {_mintERC2309} for more details.
723      */
724     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
725 }
726 
727 // File: erc721a/contracts/ERC721A.sol
728 
729 
730 // ERC721A Contracts v4.2.3
731 // Creator: Chiru Labs
732 
733 pragma solidity ^0.8.4;
734 
735 
736 /**
737  * @dev Interface of ERC721 token receiver.
738  */
739 interface ERC721A__IERC721Receiver {
740     function onERC721Received(
741         address operator,
742         address from,
743         uint256 tokenId,
744         bytes calldata data
745     ) external returns (bytes4);
746 }
747 
748 /**
749  * @title ERC721A
750  *
751  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
752  * Non-Fungible Token Standard, including the Metadata extension.
753  * Optimized for lower gas during batch mints.
754  *
755  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
756  * starting from `_startTokenId()`.
757  *
758  * Assumptions:
759  *
760  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
761  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
762  */
763 contract ERC721A is IERC721A {
764     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
765     struct TokenApprovalRef {
766         address value;
767     }
768 
769     // =============================================================
770     //                           CONSTANTS
771     // =============================================================
772 
773     // Mask of an entry in packed address data.
774     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
775 
776     // The bit position of `numberMinted` in packed address data.
777     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
778 
779     // The bit position of `numberBurned` in packed address data.
780     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
781 
782     // The bit position of `aux` in packed address data.
783     uint256 private constant _BITPOS_AUX = 192;
784 
785     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
786     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
787 
788     // The bit position of `startTimestamp` in packed ownership.
789     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
790 
791     // The bit mask of the `burned` bit in packed ownership.
792     uint256 private constant _BITMASK_BURNED = 1 << 224;
793 
794     // The bit position of the `nextInitialized` bit in packed ownership.
795     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
796 
797     // The bit mask of the `nextInitialized` bit in packed ownership.
798     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
799 
800     // The bit position of `extraData` in packed ownership.
801     uint256 private constant _BITPOS_EXTRA_DATA = 232;
802 
803     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
804     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
805 
806     // The mask of the lower 160 bits for addresses.
807     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
808 
809     // The maximum `quantity` that can be minted with {_mintERC2309}.
810     // This limit is to prevent overflows on the address data entries.
811     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
812     // is required to cause an overflow, which is unrealistic.
813     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
814 
815     // The `Transfer` event signature is given by:
816     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
817     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
818         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
819 
820     // =============================================================
821     //                            STORAGE
822     // =============================================================
823 
824     // The next token ID to be minted.
825     uint256 private _currentIndex;
826 
827     // The number of tokens burned.
828     uint256 private _burnCounter;
829 
830     // Token name
831     string private _name;
832 
833     // Token symbol
834     string private _symbol;
835 
836     // Mapping from token ID to ownership details
837     // An empty struct value does not necessarily mean the token is unowned.
838     // See {_packedOwnershipOf} implementation for details.
839     //
840     // Bits Layout:
841     // - [0..159]   `addr`
842     // - [160..223] `startTimestamp`
843     // - [224]      `burned`
844     // - [225]      `nextInitialized`
845     // - [232..255] `extraData`
846     mapping(uint256 => uint256) private _packedOwnerships;
847 
848     // Mapping owner address to address data.
849     //
850     // Bits Layout:
851     // - [0..63]    `balance`
852     // - [64..127]  `numberMinted`
853     // - [128..191] `numberBurned`
854     // - [192..255] `aux`
855     mapping(address => uint256) private _packedAddressData;
856 
857     // Mapping from token ID to approved address.
858     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
859 
860     // Mapping from owner to operator approvals
861     mapping(address => mapping(address => bool)) private _operatorApprovals;
862 
863     // =============================================================
864     //                          CONSTRUCTOR
865     // =============================================================
866 
867     constructor(string memory name_, string memory symbol_) {
868         _name = name_;
869         _symbol = symbol_;
870         _currentIndex = _startTokenId();
871     }
872 
873     // =============================================================
874     //                   TOKEN COUNTING OPERATIONS
875     // =============================================================
876 
877     /**
878      * @dev Returns the starting token ID.
879      * To change the starting token ID, please override this function.
880      */
881     function _startTokenId() internal view virtual returns (uint256) {
882         return 0;
883     }
884 
885     /**
886      * @dev Returns the next token ID to be minted.
887      */
888     function _nextTokenId() internal view virtual returns (uint256) {
889         return _currentIndex;
890     }
891 
892     /**
893      * @dev Returns the total number of tokens in existence.
894      * Burned tokens will reduce the count.
895      * To get the total number of tokens minted, please see {_totalMinted}.
896      */
897     function totalSupply() public view virtual override returns (uint256) {
898         // Counter underflow is impossible as _burnCounter cannot be incremented
899         // more than `_currentIndex - _startTokenId()` times.
900         unchecked {
901             return _currentIndex - _burnCounter - _startTokenId();
902         }
903     }
904 
905     /**
906      * @dev Returns the total amount of tokens minted in the contract.
907      */
908     function _totalMinted() internal view virtual returns (uint256) {
909         // Counter underflow is impossible as `_currentIndex` does not decrement,
910         // and it is initialized to `_startTokenId()`.
911         unchecked {
912             return _currentIndex - _startTokenId();
913         }
914     }
915 
916     /**
917      * @dev Returns the total number of tokens burned.
918      */
919     function _totalBurned() internal view virtual returns (uint256) {
920         return _burnCounter;
921     }
922 
923     // =============================================================
924     //                    ADDRESS DATA OPERATIONS
925     // =============================================================
926 
927     /**
928      * @dev Returns the number of tokens in `owner`'s account.
929      */
930     function balanceOf(address owner) public view virtual override returns (uint256) {
931         if (owner == address(0)) revert BalanceQueryForZeroAddress();
932         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
933     }
934 
935     /**
936      * Returns the number of tokens minted by `owner`.
937      */
938     function _numberMinted(address owner) internal view returns (uint256) {
939         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
940     }
941 
942     /**
943      * Returns the number of tokens burned by or on behalf of `owner`.
944      */
945     function _numberBurned(address owner) internal view returns (uint256) {
946         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
947     }
948 
949     /**
950      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
951      */
952     function _getAux(address owner) internal view returns (uint64) {
953         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
954     }
955 
956     /**
957      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
958      * If there are multiple variables, please pack them into a uint64.
959      */
960     function _setAux(address owner, uint64 aux) internal virtual {
961         uint256 packed = _packedAddressData[owner];
962         uint256 auxCasted;
963         // Cast `aux` with assembly to avoid redundant masking.
964         assembly {
965             auxCasted := aux
966         }
967         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
968         _packedAddressData[owner] = packed;
969     }
970 
971     // =============================================================
972     //                            IERC165
973     // =============================================================
974 
975     /**
976      * @dev Returns true if this contract implements the interface defined by
977      * `interfaceId`. See the corresponding
978      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
979      * to learn more about how these ids are created.
980      *
981      * This function call must use less than 30000 gas.
982      */
983     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
984         // The interface IDs are constants representing the first 4 bytes
985         // of the XOR of all function selectors in the interface.
986         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
987         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
988         return
989             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
990             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
991             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
992     }
993 
994     // =============================================================
995     //                        IERC721Metadata
996     // =============================================================
997 
998     /**
999      * @dev Returns the token collection name.
1000      */
1001     function name() public view virtual override returns (string memory) {
1002         return _name;
1003     }
1004 
1005     /**
1006      * @dev Returns the token collection symbol.
1007      */
1008     function symbol() public view virtual override returns (string memory) {
1009         return _symbol;
1010     }
1011 
1012     /**
1013      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1014      */
1015     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1016         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1017 
1018         string memory baseURI = _baseURI();
1019         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1020     }
1021 
1022     /**
1023      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1024      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1025      * by default, it can be overridden in child contracts.
1026      */
1027     function _baseURI() internal view virtual returns (string memory) {
1028         return '';
1029     }
1030 
1031     // =============================================================
1032     //                     OWNERSHIPS OPERATIONS
1033     // =============================================================
1034 
1035     /**
1036      * @dev Returns the owner of the `tokenId` token.
1037      *
1038      * Requirements:
1039      *
1040      * - `tokenId` must exist.
1041      */
1042     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1043         return address(uint160(_packedOwnershipOf(tokenId)));
1044     }
1045 
1046     /**
1047      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1048      * It gradually moves to O(1) as tokens get transferred around over time.
1049      */
1050     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1051         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1052     }
1053 
1054     /**
1055      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1056      */
1057     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1058         return _unpackedOwnership(_packedOwnerships[index]);
1059     }
1060 
1061     /**
1062      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1063      */
1064     function _initializeOwnershipAt(uint256 index) internal virtual {
1065         if (_packedOwnerships[index] == 0) {
1066             _packedOwnerships[index] = _packedOwnershipOf(index);
1067         }
1068     }
1069 
1070     /**
1071      * Returns the packed ownership data of `tokenId`.
1072      */
1073     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1074         uint256 curr = tokenId;
1075 
1076         unchecked {
1077             if (_startTokenId() <= curr)
1078                 if (curr < _currentIndex) {
1079                     uint256 packed = _packedOwnerships[curr];
1080                     // If not burned.
1081                     if (packed & _BITMASK_BURNED == 0) {
1082                         // Invariant:
1083                         // There will always be an initialized ownership slot
1084                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1085                         // before an unintialized ownership slot
1086                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1087                         // Hence, `curr` will not underflow.
1088                         //
1089                         // We can directly compare the packed value.
1090                         // If the address is zero, packed will be zero.
1091                         while (packed == 0) {
1092                             packed = _packedOwnerships[--curr];
1093                         }
1094                         return packed;
1095                     }
1096                 }
1097         }
1098         revert OwnerQueryForNonexistentToken();
1099     }
1100 
1101     /**
1102      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1103      */
1104     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1105         ownership.addr = address(uint160(packed));
1106         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1107         ownership.burned = packed & _BITMASK_BURNED != 0;
1108         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1109     }
1110 
1111     /**
1112      * @dev Packs ownership data into a single uint256.
1113      */
1114     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1115         assembly {
1116             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1117             owner := and(owner, _BITMASK_ADDRESS)
1118             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1119             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1120         }
1121     }
1122 
1123     /**
1124      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1125      */
1126     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1127         // For branchless setting of the `nextInitialized` flag.
1128         assembly {
1129             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1130             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1131         }
1132     }
1133 
1134     // =============================================================
1135     //                      APPROVAL OPERATIONS
1136     // =============================================================
1137 
1138     /**
1139      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1140      * The approval is cleared when the token is transferred.
1141      *
1142      * Only a single account can be approved at a time, so approving the
1143      * zero address clears previous approvals.
1144      *
1145      * Requirements:
1146      *
1147      * - The caller must own the token or be an approved operator.
1148      * - `tokenId` must exist.
1149      *
1150      * Emits an {Approval} event.
1151      */
1152     function approve(address to, uint256 tokenId) public payable virtual override {
1153         address owner = ownerOf(tokenId);
1154 
1155         if (_msgSenderERC721A() != owner)
1156             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1157                 revert ApprovalCallerNotOwnerNorApproved();
1158             }
1159 
1160         _tokenApprovals[tokenId].value = to;
1161         emit Approval(owner, to, tokenId);
1162     }
1163 
1164     /**
1165      * @dev Returns the account approved for `tokenId` token.
1166      *
1167      * Requirements:
1168      *
1169      * - `tokenId` must exist.
1170      */
1171     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1172         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1173 
1174         return _tokenApprovals[tokenId].value;
1175     }
1176 
1177     /**
1178      * @dev Approve or remove `operator` as an operator for the caller.
1179      * Operators can call {transferFrom} or {safeTransferFrom}
1180      * for any token owned by the caller.
1181      *
1182      * Requirements:
1183      *
1184      * - The `operator` cannot be the caller.
1185      *
1186      * Emits an {ApprovalForAll} event.
1187      */
1188     function setApprovalForAll(address operator, bool approved) public virtual override {
1189         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1190         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1191     }
1192 
1193     /**
1194      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1195      *
1196      * See {setApprovalForAll}.
1197      */
1198     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1199         return _operatorApprovals[owner][operator];
1200     }
1201 
1202     /**
1203      * @dev Returns whether `tokenId` exists.
1204      *
1205      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1206      *
1207      * Tokens start existing when they are minted. See {_mint}.
1208      */
1209     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1210         return
1211             _startTokenId() <= tokenId &&
1212             tokenId < _currentIndex && // If within bounds,
1213             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1214     }
1215 
1216     /**
1217      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1218      */
1219     function _isSenderApprovedOrOwner(
1220         address approvedAddress,
1221         address owner,
1222         address msgSender
1223     ) private pure returns (bool result) {
1224         assembly {
1225             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1226             owner := and(owner, _BITMASK_ADDRESS)
1227             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1228             msgSender := and(msgSender, _BITMASK_ADDRESS)
1229             // `msgSender == owner || msgSender == approvedAddress`.
1230             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1231         }
1232     }
1233 
1234     /**
1235      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1236      */
1237     function _getApprovedSlotAndAddress(uint256 tokenId)
1238         private
1239         view
1240         returns (uint256 approvedAddressSlot, address approvedAddress)
1241     {
1242         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1243         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1244         assembly {
1245             approvedAddressSlot := tokenApproval.slot
1246             approvedAddress := sload(approvedAddressSlot)
1247         }
1248     }
1249 
1250     // =============================================================
1251     //                      TRANSFER OPERATIONS
1252     // =============================================================
1253 
1254     /**
1255      * @dev Transfers `tokenId` from `from` to `to`.
1256      *
1257      * Requirements:
1258      *
1259      * - `from` cannot be the zero address.
1260      * - `to` cannot be the zero address.
1261      * - `tokenId` token must be owned by `from`.
1262      * - If the caller is not `from`, it must be approved to move this token
1263      * by either {approve} or {setApprovalForAll}.
1264      *
1265      * Emits a {Transfer} event.
1266      */
1267     function transferFrom(
1268         address from,
1269         address to,
1270         uint256 tokenId
1271     ) public payable virtual override {
1272         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1273 
1274         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1275 
1276         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1277 
1278         // The nested ifs save around 20+ gas over a compound boolean condition.
1279         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1280             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1281 
1282         if (to == address(0)) revert TransferToZeroAddress();
1283 
1284         _beforeTokenTransfers(from, to, tokenId, 1);
1285 
1286         // Clear approvals from the previous owner.
1287         assembly {
1288             if approvedAddress {
1289                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1290                 sstore(approvedAddressSlot, 0)
1291             }
1292         }
1293 
1294         // Underflow of the sender's balance is impossible because we check for
1295         // ownership above and the recipient's balance can't realistically overflow.
1296         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1297         unchecked {
1298             // We can directly increment and decrement the balances.
1299             --_packedAddressData[from]; // Updates: `balance -= 1`.
1300             ++_packedAddressData[to]; // Updates: `balance += 1`.
1301 
1302             // Updates:
1303             // - `address` to the next owner.
1304             // - `startTimestamp` to the timestamp of transfering.
1305             // - `burned` to `false`.
1306             // - `nextInitialized` to `true`.
1307             _packedOwnerships[tokenId] = _packOwnershipData(
1308                 to,
1309                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1310             );
1311 
1312             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1313             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1314                 uint256 nextTokenId = tokenId + 1;
1315                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1316                 if (_packedOwnerships[nextTokenId] == 0) {
1317                     // If the next slot is within bounds.
1318                     if (nextTokenId != _currentIndex) {
1319                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1320                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1321                     }
1322                 }
1323             }
1324         }
1325 
1326         emit Transfer(from, to, tokenId);
1327         _afterTokenTransfers(from, to, tokenId, 1);
1328     }
1329 
1330     /**
1331      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1332      */
1333     function safeTransferFrom(
1334         address from,
1335         address to,
1336         uint256 tokenId
1337     ) public payable virtual override {
1338         safeTransferFrom(from, to, tokenId, '');
1339     }
1340 
1341     /**
1342      * @dev Safely transfers `tokenId` token from `from` to `to`.
1343      *
1344      * Requirements:
1345      *
1346      * - `from` cannot be the zero address.
1347      * - `to` cannot be the zero address.
1348      * - `tokenId` token must exist and be owned by `from`.
1349      * - If the caller is not `from`, it must be approved to move this token
1350      * by either {approve} or {setApprovalForAll}.
1351      * - If `to` refers to a smart contract, it must implement
1352      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1353      *
1354      * Emits a {Transfer} event.
1355      */
1356     function safeTransferFrom(
1357         address from,
1358         address to,
1359         uint256 tokenId,
1360         bytes memory _data
1361     ) public payable virtual override {
1362         transferFrom(from, to, tokenId);
1363         if (to.code.length != 0)
1364             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1365                 revert TransferToNonERC721ReceiverImplementer();
1366             }
1367     }
1368 
1369     /**
1370      * @dev Hook that is called before a set of serially-ordered token IDs
1371      * are about to be transferred. This includes minting.
1372      * And also called before burning one token.
1373      *
1374      * `startTokenId` - the first token ID to be transferred.
1375      * `quantity` - the amount to be transferred.
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` will be minted for `to`.
1382      * - When `to` is zero, `tokenId` will be burned by `from`.
1383      * - `from` and `to` are never both zero.
1384      */
1385     function _beforeTokenTransfers(
1386         address from,
1387         address to,
1388         uint256 startTokenId,
1389         uint256 quantity
1390     ) internal virtual {}
1391 
1392     /**
1393      * @dev Hook that is called after a set of serially-ordered token IDs
1394      * have been transferred. This includes minting.
1395      * And also called after one token has been burned.
1396      *
1397      * `startTokenId` - the first token ID to be transferred.
1398      * `quantity` - the amount to be transferred.
1399      *
1400      * Calling conditions:
1401      *
1402      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1403      * transferred to `to`.
1404      * - When `from` is zero, `tokenId` has been minted for `to`.
1405      * - When `to` is zero, `tokenId` has been burned by `from`.
1406      * - `from` and `to` are never both zero.
1407      */
1408     function _afterTokenTransfers(
1409         address from,
1410         address to,
1411         uint256 startTokenId,
1412         uint256 quantity
1413     ) internal virtual {}
1414 
1415     /**
1416      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1417      *
1418      * `from` - Previous owner of the given token ID.
1419      * `to` - Target address that will receive the token.
1420      * `tokenId` - Token ID to be transferred.
1421      * `_data` - Optional data to send along with the call.
1422      *
1423      * Returns whether the call correctly returned the expected magic value.
1424      */
1425     function _checkContractOnERC721Received(
1426         address from,
1427         address to,
1428         uint256 tokenId,
1429         bytes memory _data
1430     ) private returns (bool) {
1431         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1432             bytes4 retval
1433         ) {
1434             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1435         } catch (bytes memory reason) {
1436             if (reason.length == 0) {
1437                 revert TransferToNonERC721ReceiverImplementer();
1438             } else {
1439                 assembly {
1440                     revert(add(32, reason), mload(reason))
1441                 }
1442             }
1443         }
1444     }
1445 
1446     // =============================================================
1447     //                        MINT OPERATIONS
1448     // =============================================================
1449 
1450     /**
1451      * @dev Mints `quantity` tokens and transfers them to `to`.
1452      *
1453      * Requirements:
1454      *
1455      * - `to` cannot be the zero address.
1456      * - `quantity` must be greater than 0.
1457      *
1458      * Emits a {Transfer} event for each mint.
1459      */
1460     function _mint(address to, uint256 quantity) internal virtual {
1461         uint256 startTokenId = _currentIndex;
1462         if (quantity == 0) revert MintZeroQuantity();
1463 
1464         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1465 
1466         // Overflows are incredibly unrealistic.
1467         // `balance` and `numberMinted` have a maximum limit of 2**64.
1468         // `tokenId` has a maximum limit of 2**256.
1469         unchecked {
1470             // Updates:
1471             // - `balance += quantity`.
1472             // - `numberMinted += quantity`.
1473             //
1474             // We can directly add to the `balance` and `numberMinted`.
1475             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1476 
1477             // Updates:
1478             // - `address` to the owner.
1479             // - `startTimestamp` to the timestamp of minting.
1480             // - `burned` to `false`.
1481             // - `nextInitialized` to `quantity == 1`.
1482             _packedOwnerships[startTokenId] = _packOwnershipData(
1483                 to,
1484                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1485             );
1486 
1487             uint256 toMasked;
1488             uint256 end = startTokenId + quantity;
1489 
1490             // Use assembly to loop and emit the `Transfer` event for gas savings.
1491             // The duplicated `log4` removes an extra check and reduces stack juggling.
1492             // The assembly, together with the surrounding Solidity code, have been
1493             // delicately arranged to nudge the compiler into producing optimized opcodes.
1494             assembly {
1495                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1496                 toMasked := and(to, _BITMASK_ADDRESS)
1497                 // Emit the `Transfer` event.
1498                 log4(
1499                     0, // Start of data (0, since no data).
1500                     0, // End of data (0, since no data).
1501                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1502                     0, // `address(0)`.
1503                     toMasked, // `to`.
1504                     startTokenId // `tokenId`.
1505                 )
1506 
1507                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1508                 // that overflows uint256 will make the loop run out of gas.
1509                 // The compiler will optimize the `iszero` away for performance.
1510                 for {
1511                     let tokenId := add(startTokenId, 1)
1512                 } iszero(eq(tokenId, end)) {
1513                     tokenId := add(tokenId, 1)
1514                 } {
1515                     // Emit the `Transfer` event. Similar to above.
1516                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1517                 }
1518             }
1519             if (toMasked == 0) revert MintToZeroAddress();
1520 
1521             _currentIndex = end;
1522         }
1523         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1524     }
1525 
1526     /**
1527      * @dev Mints `quantity` tokens and transfers them to `to`.
1528      *
1529      * This function is intended for efficient minting only during contract creation.
1530      *
1531      * It emits only one {ConsecutiveTransfer} as defined in
1532      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1533      * instead of a sequence of {Transfer} event(s).
1534      *
1535      * Calling this function outside of contract creation WILL make your contract
1536      * non-compliant with the ERC721 standard.
1537      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1538      * {ConsecutiveTransfer} event is only permissible during contract creation.
1539      *
1540      * Requirements:
1541      *
1542      * - `to` cannot be the zero address.
1543      * - `quantity` must be greater than 0.
1544      *
1545      * Emits a {ConsecutiveTransfer} event.
1546      */
1547     function _mintERC2309(address to, uint256 quantity) internal virtual {
1548         uint256 startTokenId = _currentIndex;
1549         if (to == address(0)) revert MintToZeroAddress();
1550         if (quantity == 0) revert MintZeroQuantity();
1551         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1552 
1553         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1554 
1555         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1556         unchecked {
1557             // Updates:
1558             // - `balance += quantity`.
1559             // - `numberMinted += quantity`.
1560             //
1561             // We can directly add to the `balance` and `numberMinted`.
1562             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1563 
1564             // Updates:
1565             // - `address` to the owner.
1566             // - `startTimestamp` to the timestamp of minting.
1567             // - `burned` to `false`.
1568             // - `nextInitialized` to `quantity == 1`.
1569             _packedOwnerships[startTokenId] = _packOwnershipData(
1570                 to,
1571                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1572             );
1573 
1574             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1575 
1576             _currentIndex = startTokenId + quantity;
1577         }
1578         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1579     }
1580 
1581     /**
1582      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1583      *
1584      * Requirements:
1585      *
1586      * - If `to` refers to a smart contract, it must implement
1587      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1588      * - `quantity` must be greater than 0.
1589      *
1590      * See {_mint}.
1591      *
1592      * Emits a {Transfer} event for each mint.
1593      */
1594     function _safeMint(
1595         address to,
1596         uint256 quantity,
1597         bytes memory _data
1598     ) internal virtual {
1599         _mint(to, quantity);
1600 
1601         unchecked {
1602             if (to.code.length != 0) {
1603                 uint256 end = _currentIndex;
1604                 uint256 index = end - quantity;
1605                 do {
1606                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1607                         revert TransferToNonERC721ReceiverImplementer();
1608                     }
1609                 } while (index < end);
1610                 // Reentrancy protection.
1611                 if (_currentIndex != end) revert();
1612             }
1613         }
1614     }
1615 
1616     /**
1617      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1618      */
1619     function _safeMint(address to, uint256 quantity) internal virtual {
1620         _safeMint(to, quantity, '');
1621     }
1622 
1623     // =============================================================
1624     //                        BURN OPERATIONS
1625     // =============================================================
1626 
1627     /**
1628      * @dev Equivalent to `_burn(tokenId, false)`.
1629      */
1630     function _burn(uint256 tokenId) internal virtual {
1631         _burn(tokenId, false);
1632     }
1633 
1634     /**
1635      * @dev Destroys `tokenId`.
1636      * The approval is cleared when the token is burned.
1637      *
1638      * Requirements:
1639      *
1640      * - `tokenId` must exist.
1641      *
1642      * Emits a {Transfer} event.
1643      */
1644     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1645         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1646 
1647         address from = address(uint160(prevOwnershipPacked));
1648 
1649         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1650 
1651         if (approvalCheck) {
1652             // The nested ifs save around 20+ gas over a compound boolean condition.
1653             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1654                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1655         }
1656 
1657         _beforeTokenTransfers(from, address(0), tokenId, 1);
1658 
1659         // Clear approvals from the previous owner.
1660         assembly {
1661             if approvedAddress {
1662                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1663                 sstore(approvedAddressSlot, 0)
1664             }
1665         }
1666 
1667         // Underflow of the sender's balance is impossible because we check for
1668         // ownership above and the recipient's balance can't realistically overflow.
1669         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1670         unchecked {
1671             // Updates:
1672             // - `balance -= 1`.
1673             // - `numberBurned += 1`.
1674             //
1675             // We can directly decrement the balance, and increment the number burned.
1676             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1677             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1678 
1679             // Updates:
1680             // - `address` to the last owner.
1681             // - `startTimestamp` to the timestamp of burning.
1682             // - `burned` to `true`.
1683             // - `nextInitialized` to `true`.
1684             _packedOwnerships[tokenId] = _packOwnershipData(
1685                 from,
1686                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1687             );
1688 
1689             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1690             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1691                 uint256 nextTokenId = tokenId + 1;
1692                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1693                 if (_packedOwnerships[nextTokenId] == 0) {
1694                     // If the next slot is within bounds.
1695                     if (nextTokenId != _currentIndex) {
1696                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1697                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1698                     }
1699                 }
1700             }
1701         }
1702 
1703         emit Transfer(from, address(0), tokenId);
1704         _afterTokenTransfers(from, address(0), tokenId, 1);
1705 
1706         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1707         unchecked {
1708             _burnCounter++;
1709         }
1710     }
1711 
1712     // =============================================================
1713     //                     EXTRA DATA OPERATIONS
1714     // =============================================================
1715 
1716     /**
1717      * @dev Directly sets the extra data for the ownership data `index`.
1718      */
1719     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1720         uint256 packed = _packedOwnerships[index];
1721         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1722         uint256 extraDataCasted;
1723         // Cast `extraData` with assembly to avoid redundant masking.
1724         assembly {
1725             extraDataCasted := extraData
1726         }
1727         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1728         _packedOwnerships[index] = packed;
1729     }
1730 
1731     /**
1732      * @dev Called during each token transfer to set the 24bit `extraData` field.
1733      * Intended to be overridden by the cosumer contract.
1734      *
1735      * `previousExtraData` - the value of `extraData` before transfer.
1736      *
1737      * Calling conditions:
1738      *
1739      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1740      * transferred to `to`.
1741      * - When `from` is zero, `tokenId` will be minted for `to`.
1742      * - When `to` is zero, `tokenId` will be burned by `from`.
1743      * - `from` and `to` are never both zero.
1744      */
1745     function _extraData(
1746         address from,
1747         address to,
1748         uint24 previousExtraData
1749     ) internal view virtual returns (uint24) {}
1750 
1751     /**
1752      * @dev Returns the next extra data for the packed ownership data.
1753      * The returned result is shifted into position.
1754      */
1755     function _nextExtraData(
1756         address from,
1757         address to,
1758         uint256 prevOwnershipPacked
1759     ) private view returns (uint256) {
1760         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1761         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1762     }
1763 
1764     // =============================================================
1765     //                       OTHER OPERATIONS
1766     // =============================================================
1767 
1768     /**
1769      * @dev Returns the message sender (defaults to `msg.sender`).
1770      *
1771      * If you are writing GSN compatible contracts, you need to override this function.
1772      */
1773     function _msgSenderERC721A() internal view virtual returns (address) {
1774         return msg.sender;
1775     }
1776 
1777     /**
1778      * @dev Converts a uint256 to its ASCII string decimal representation.
1779      */
1780     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1781         assembly {
1782             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1783             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1784             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1785             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1786             let m := add(mload(0x40), 0xa0)
1787             // Update the free memory pointer to allocate.
1788             mstore(0x40, m)
1789             // Assign the `str` to the end.
1790             str := sub(m, 0x20)
1791             // Zeroize the slot after the string.
1792             mstore(str, 0)
1793 
1794             // Cache the end of the memory to calculate the length later.
1795             let end := str
1796 
1797             // We write the string from rightmost digit to leftmost digit.
1798             // The following is essentially a do-while loop that also handles the zero case.
1799             // prettier-ignore
1800             for { let temp := value } 1 {} {
1801                 str := sub(str, 1)
1802                 // Write the character to the pointer.
1803                 // The ASCII index of the '0' character is 48.
1804                 mstore8(str, add(48, mod(temp, 10)))
1805                 // Keep dividing `temp` until zero.
1806                 temp := div(temp, 10)
1807                 // prettier-ignore
1808                 if iszero(temp) { break }
1809             }
1810 
1811             let length := sub(end, str)
1812             // Move the pointer 32 bytes leftwards to make room for the length.
1813             str := sub(str, 0x20)
1814             // Store the length.
1815             mstore(str, length)
1816         }
1817     }
1818 }
1819 
1820 // File: pixydixy final.sol
1821 
1822 
1823 
1824 pragma solidity >=0.7.0 <0.9.0;
1825 
1826 
1827 
1828 
1829 
1830 contract PixyDixy is
1831     ERC721A,
1832     Ownable,
1833     ReentrancyGuard,
1834     DefaultOperatorFilterer
1835 {
1836     string public baseURI = "ipfs://bafybeiaz46q32tes5htanf4cqzy6xj5e4wgv53jshoreir2fxaok7o2g7m/";
1837     uint256 public cost = 0.0044 ether;
1838     uint256 public maxSupply = 4444;
1839     uint256 public MaxperWallet = 10;
1840     bool public paused = true;
1841     mapping(address => bool) public FreeClaimed;
1842 
1843     constructor() ERC721A("PixyDixy", "PXYDXY") {}
1844 
1845 
1846     function mintyourPixy(uint256 tokens) public payable nonReentrant {
1847         if(paused) revert("Sale Paused");
1848         if(tokens > MaxperWallet) revert("You can mint 10 in a transaction");
1849         if(totalSupply() + tokens > maxSupply) revert("Sold out");
1850         if(numberMinted(_msgSenderERC721A()) + tokens > MaxperWallet) revert("Wallet limit reached");
1851 
1852         if (!FreeClaimed[_msgSenderERC721A()]) {
1853             uint256 pricetopay = tokens - 1;
1854             require(msg.value >= cost * pricetopay, "Incorrcet ETH amount");
1855             FreeClaimed[_msgSenderERC721A()] = true;
1856         } else {
1857             require(msg.value >= cost * tokens, "Incorrcet ETH amount");
1858         }
1859         _safeMint(_msgSenderERC721A(), tokens);
1860     }
1861     function ownermint(uint256 _mintAmount, address[] calldata destination)
1862         public
1863         onlyOwner
1864         nonReentrant
1865     {
1866         require(
1867             totalSupply() + _mintAmount <= maxSupply,
1868             "max NFT limit exceeded"
1869         );
1870         for (uint256 i = 0; i < destination.length; i++) {
1871             _safeMint(destination[i], _mintAmount);
1872         }
1873     }
1874 
1875     function tokenURI(uint256 tokenId)
1876         public
1877         view
1878         virtual
1879         override
1880         returns (string memory)
1881     {
1882         require(
1883             _exists(tokenId),
1884             "ERC721AMetadata: URI query for nonexistent token"
1885         );
1886 
1887         string memory currentBaseURI = _baseURI();
1888         return
1889             bytes(currentBaseURI).length > 0
1890                 ? string(
1891                     abi.encodePacked(
1892                         currentBaseURI,
1893                         _toString(tokenId),
1894                         ".json"
1895                     )
1896                 )
1897                 : "";
1898     }
1899 
1900     function numberMinted(address owner) public view returns (uint256) {
1901         return _numberMinted(owner);
1902     }
1903 
1904     function tokensOfOwner(address owner)
1905         public
1906         view
1907         returns (uint256[] memory)
1908     {
1909         unchecked {
1910             uint256 tokenIdsIdx;
1911             address currOwnershipAddr;
1912             uint256 tokenIdsLength = balanceOf(owner);
1913             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1914             TokenOwnership memory ownership;
1915             for (
1916                 uint256 i = _startTokenId();
1917                 tokenIdsIdx != tokenIdsLength;
1918                 ++i
1919             ) {
1920                 ownership = _ownershipAt(i);
1921                 if (ownership.burned) {
1922                     continue;
1923                 }
1924                 if (ownership.addr != address(0)) {
1925                     currOwnershipAddr = ownership.addr;
1926                 }
1927                 if (currOwnershipAddr == owner) {
1928                     tokenIds[tokenIdsIdx++] = i;
1929                 }
1930             }
1931             return tokenIds;
1932         }
1933     }
1934 
1935 
1936     function setMaxPerWallet(uint256 _limit) public onlyOwner {
1937         MaxperWallet = _limit;
1938     }
1939 
1940     function setCost(uint256 _newCost) public onlyOwner {
1941         cost = _newCost;
1942     }
1943 
1944     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1945         maxSupply = _newsupply;
1946     }
1947 
1948     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1949         baseURI = _newBaseURI;
1950     }
1951 
1952     function pause(bool _state) public onlyOwner {
1953         paused = _state;
1954     }
1955 
1956     function withdraw() public payable onlyOwner nonReentrant {
1957         uint256 balance = address(this).balance;
1958         payable(_msgSenderERC721A()).transfer(balance);
1959     }
1960 
1961         function _baseURI() internal view virtual override returns (string memory) {
1962         return baseURI;
1963     }
1964 
1965     function _startTokenId() internal view virtual override returns (uint256) {
1966         return 1;
1967     }
1968 
1969 
1970     function transferFrom(
1971         address from,
1972         address to,
1973         uint256 tokenId
1974     ) public payable override onlyAllowedOperator(from) {
1975         super.transferFrom(from, to, tokenId);
1976     }
1977 
1978     function safeTransferFrom(
1979         address from,
1980         address to,
1981         uint256 tokenId
1982     ) public payable override onlyAllowedOperator(from) {
1983         super.safeTransferFrom(from, to, tokenId);
1984     }
1985 
1986     function safeTransferFrom(
1987         address from,
1988         address to,
1989         uint256 tokenId,
1990         bytes memory data
1991     ) public payable override onlyAllowedOperator(from) {
1992         super.safeTransferFrom(from, to, tokenId, data);
1993     }
1994 }