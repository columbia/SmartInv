1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/lib/Constants.sol
3 
4 
5 pragma solidity ^0.8.17;
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
253 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
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
320 }
321 
322 // File: @openzeppelin/contracts/utils/Context.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Provides information about the current execution context, including the
331  * sender of the transaction and its data. While these are generally available
332  * via msg.sender and msg.data, they should not be accessed in such a direct
333  * manner, since when dealing with meta-transactions the account sending and
334  * paying for execution may not be the actual sender (as far as an application
335  * is concerned).
336  *
337  * This contract is only required for intermediate, library-like contracts.
338  */
339 abstract contract Context {
340     function _msgSender() internal view virtual returns (address) {
341         return msg.sender;
342     }
343 
344     function _msgData() internal view virtual returns (bytes calldata) {
345         return msg.data;
346     }
347 }
348 
349 // File: @openzeppelin/contracts/access/Ownable.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Contract module which provides a basic access control mechanism, where
359  * there is an account (an owner) that can be granted exclusive access to
360  * specific functions.
361  *
362  * By default, the owner account will be the one that deploys the contract. This
363  * can later be changed with {transferOwnership}.
364  *
365  * This module is used through inheritance. It will make available the modifier
366  * `onlyOwner`, which can be applied to your functions to restrict their use to
367  * the owner.
368  */
369 abstract contract Ownable is Context {
370     address private _owner;
371 
372     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
373 
374     /**
375      * @dev Initializes the contract setting the deployer as the initial owner.
376      */
377     constructor() {
378         _transferOwnership(_msgSender());
379     }
380 
381     /**
382      * @dev Throws if called by any account other than the owner.
383      */
384     modifier onlyOwner() {
385         _checkOwner();
386         _;
387     }
388 
389     /**
390      * @dev Returns the address of the current owner.
391      */
392     function owner() public view virtual returns (address) {
393         return _owner;
394     }
395 
396     /**
397      * @dev Throws if the sender is not the owner.
398      */
399     function _checkOwner() internal view virtual {
400         require(owner() == _msgSender(), "Ownable: caller is not the owner");
401     }
402 
403     /**
404      * @dev Leaves the contract without owner. It will not be possible to call
405      * `onlyOwner` functions anymore. Can only be called by the current owner.
406      *
407      * NOTE: Renouncing ownership will leave the contract without an owner,
408      * thereby removing any functionality that is only available to the owner.
409      */
410     function renounceOwnership() public virtual onlyOwner {
411         _transferOwnership(address(0));
412     }
413 
414     /**
415      * @dev Transfers ownership of the contract to a new account (`newOwner`).
416      * Can only be called by the current owner.
417      */
418     function transferOwnership(address newOwner) public virtual onlyOwner {
419         require(newOwner != address(0), "Ownable: new owner is the zero address");
420         _transferOwnership(newOwner);
421     }
422 
423     /**
424      * @dev Transfers ownership of the contract to a new account (`newOwner`).
425      * Internal function without access restriction.
426      */
427     function _transferOwnership(address newOwner) internal virtual {
428         address oldOwner = _owner;
429         _owner = newOwner;
430         emit OwnershipTransferred(oldOwner, newOwner);
431     }
432 }
433 
434 // File: erc721a/contracts/IERC721A.sol
435 
436 
437 // ERC721A Contracts v4.2.3
438 // Creator: Chiru Labs
439 
440 pragma solidity ^0.8.4;
441 
442 /**
443  * @dev Interface of ERC721A.
444  */
445 interface IERC721A {
446     /**
447      * The caller must own the token or be an approved operator.
448      */
449     error ApprovalCallerNotOwnerNorApproved();
450 
451     /**
452      * The token does not exist.
453      */
454     error ApprovalQueryForNonexistentToken();
455 
456     /**
457      * Cannot query the balance for the zero address.
458      */
459     error BalanceQueryForZeroAddress();
460 
461     /**
462      * Cannot mint to the zero address.
463      */
464     error MintToZeroAddress();
465 
466     /**
467      * The quantity of tokens minted must be more than zero.
468      */
469     error MintZeroQuantity();
470 
471     /**
472      * The token does not exist.
473      */
474     error OwnerQueryForNonexistentToken();
475 
476     /**
477      * The caller must own the token or be an approved operator.
478      */
479     error TransferCallerNotOwnerNorApproved();
480 
481     /**
482      * The token must be owned by `from`.
483      */
484     error TransferFromIncorrectOwner();
485 
486     /**
487      * Cannot safely transfer to a contract that does not implement the
488      * ERC721Receiver interface.
489      */
490     error TransferToNonERC721ReceiverImplementer();
491 
492     /**
493      * Cannot transfer to the zero address.
494      */
495     error TransferToZeroAddress();
496 
497     /**
498      * The token does not exist.
499      */
500     error URIQueryForNonexistentToken();
501 
502     /**
503      * The `quantity` minted with ERC2309 exceeds the safety limit.
504      */
505     error MintERC2309QuantityExceedsLimit();
506 
507     /**
508      * The `extraData` cannot be set on an unintialized ownership slot.
509      */
510     error OwnershipNotInitializedForExtraData();
511 
512     // =============================================================
513     //                            STRUCTS
514     // =============================================================
515 
516     struct TokenOwnership {
517         // The address of the owner.
518         address addr;
519         // Stores the start time of ownership with minimal overhead for tokenomics.
520         uint64 startTimestamp;
521         // Whether the token has been burned.
522         bool burned;
523         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
524         uint24 extraData;
525     }
526 
527     // =============================================================
528     //                         TOKEN COUNTERS
529     // =============================================================
530 
531     /**
532      * @dev Returns the total number of tokens in existence.
533      * Burned tokens will reduce the count.
534      * To get the total number of tokens minted, please see {_totalMinted}.
535      */
536     function totalSupply() external view returns (uint256);
537 
538     // =============================================================
539     //                            IERC165
540     // =============================================================
541 
542     /**
543      * @dev Returns true if this contract implements the interface defined by
544      * `interfaceId`. See the corresponding
545      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
546      * to learn more about how these ids are created.
547      *
548      * This function call must use less than 30000 gas.
549      */
550     function supportsInterface(bytes4 interfaceId) external view returns (bool);
551 
552     // =============================================================
553     //                            IERC721
554     // =============================================================
555 
556     /**
557      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
558      */
559     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
560 
561     /**
562      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
563      */
564     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
565 
566     /**
567      * @dev Emitted when `owner` enables or disables
568      * (`approved`) `operator` to manage all of its assets.
569      */
570     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
571 
572     /**
573      * @dev Returns the number of tokens in `owner`'s account.
574      */
575     function balanceOf(address owner) external view returns (uint256 balance);
576 
577     /**
578      * @dev Returns the owner of the `tokenId` token.
579      *
580      * Requirements:
581      *
582      * - `tokenId` must exist.
583      */
584     function ownerOf(uint256 tokenId) external view returns (address owner);
585 
586     /**
587      * @dev Safely transfers `tokenId` token from `from` to `to`,
588      * checking first that contract recipients are aware of the ERC721 protocol
589      * to prevent tokens from being forever locked.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must exist and be owned by `from`.
596      * - If the caller is not `from`, it must be have been allowed to move
597      * this token by either {approve} or {setApprovalForAll}.
598      * - If `to` refers to a smart contract, it must implement
599      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
600      *
601      * Emits a {Transfer} event.
602      */
603     function safeTransferFrom(
604         address from,
605         address to,
606         uint256 tokenId,
607         bytes calldata data
608     ) external payable;
609 
610     /**
611      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
612      */
613     function safeTransferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) external payable;
618 
619     /**
620      * @dev Transfers `tokenId` from `from` to `to`.
621      *
622      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
623      * whenever possible.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must be owned by `from`.
630      * - If the caller is not `from`, it must be approved to move this token
631      * by either {approve} or {setApprovalForAll}.
632      *
633      * Emits a {Transfer} event.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) external payable;
640 
641     /**
642      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
643      * The approval is cleared when the token is transferred.
644      *
645      * Only a single account can be approved at a time, so approving the
646      * zero address clears previous approvals.
647      *
648      * Requirements:
649      *
650      * - The caller must own the token or be an approved operator.
651      * - `tokenId` must exist.
652      *
653      * Emits an {Approval} event.
654      */
655     function approve(address to, uint256 tokenId) external payable;
656 
657     /**
658      * @dev Approve or remove `operator` as an operator for the caller.
659      * Operators can call {transferFrom} or {safeTransferFrom}
660      * for any token owned by the caller.
661      *
662      * Requirements:
663      *
664      * - The `operator` cannot be the caller.
665      *
666      * Emits an {ApprovalForAll} event.
667      */
668     function setApprovalForAll(address operator, bool _approved) external;
669 
670     /**
671      * @dev Returns the account approved for `tokenId` token.
672      *
673      * Requirements:
674      *
675      * - `tokenId` must exist.
676      */
677     function getApproved(uint256 tokenId) external view returns (address operator);
678 
679     /**
680      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
681      *
682      * See {setApprovalForAll}.
683      */
684     function isApprovedForAll(address owner, address operator) external view returns (bool);
685 
686     // =============================================================
687     //                        IERC721Metadata
688     // =============================================================
689 
690     /**
691      * @dev Returns the token collection name.
692      */
693     function name() external view returns (string memory);
694 
695     /**
696      * @dev Returns the token collection symbol.
697      */
698     function symbol() external view returns (string memory);
699 
700     /**
701      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
702      */
703     function tokenURI(uint256 tokenId) external view returns (string memory);
704 
705     // =============================================================
706     //                           IERC2309
707     // =============================================================
708 
709     /**
710      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
711      * (inclusive) is transferred from `from` to `to`, as defined in the
712      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
713      *
714      * See {_mintERC2309} for more details.
715      */
716     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
717 }
718 
719 // File: erc721a/contracts/ERC721A.sol
720 
721 
722 // ERC721A Contracts v4.2.3
723 // Creator: Chiru Labs
724 
725 pragma solidity ^0.8.4;
726 
727 
728 /**
729  * @dev Interface of ERC721 token receiver.
730  */
731 interface ERC721A__IERC721Receiver {
732     function onERC721Received(
733         address operator,
734         address from,
735         uint256 tokenId,
736         bytes calldata data
737     ) external returns (bytes4);
738 }
739 
740 /**
741  * @title ERC721A
742  *
743  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
744  * Non-Fungible Token Standard, including the Metadata extension.
745  * Optimized for lower gas during batch mints.
746  *
747  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
748  * starting from `_startTokenId()`.
749  *
750  * Assumptions:
751  *
752  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
753  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
754  */
755 contract ERC721A is IERC721A {
756     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
757     struct TokenApprovalRef {
758         address value;
759     }
760 
761     // =============================================================
762     //                           CONSTANTS
763     // =============================================================
764 
765     // Mask of an entry in packed address data.
766     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
767 
768     // The bit position of `numberMinted` in packed address data.
769     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
770 
771     // The bit position of `numberBurned` in packed address data.
772     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
773 
774     // The bit position of `aux` in packed address data.
775     uint256 private constant _BITPOS_AUX = 192;
776 
777     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
778     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
779 
780     // The bit position of `startTimestamp` in packed ownership.
781     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
782 
783     // The bit mask of the `burned` bit in packed ownership.
784     uint256 private constant _BITMASK_BURNED = 1 << 224;
785 
786     // The bit position of the `nextInitialized` bit in packed ownership.
787     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
788 
789     // The bit mask of the `nextInitialized` bit in packed ownership.
790     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
791 
792     // The bit position of `extraData` in packed ownership.
793     uint256 private constant _BITPOS_EXTRA_DATA = 232;
794 
795     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
796     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
797 
798     // The mask of the lower 160 bits for addresses.
799     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
800 
801     // The maximum `quantity` that can be minted with {_mintERC2309}.
802     // This limit is to prevent overflows on the address data entries.
803     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
804     // is required to cause an overflow, which is unrealistic.
805     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
806 
807     // The `Transfer` event signature is given by:
808     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
809     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
810         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
811 
812     // =============================================================
813     //                            STORAGE
814     // =============================================================
815 
816     // The next token ID to be minted.
817     uint256 private _currentIndex;
818 
819     // The number of tokens burned.
820     uint256 private _burnCounter;
821 
822     // Token name
823     string private _name;
824 
825     // Token symbol
826     string private _symbol;
827 
828     // Mapping from token ID to ownership details
829     // An empty struct value does not necessarily mean the token is unowned.
830     // See {_packedOwnershipOf} implementation for details.
831     //
832     // Bits Layout:
833     // - [0..159]   `addr`
834     // - [160..223] `startTimestamp`
835     // - [224]      `burned`
836     // - [225]      `nextInitialized`
837     // - [232..255] `extraData`
838     mapping(uint256 => uint256) private _packedOwnerships;
839 
840     // Mapping owner address to address data.
841     //
842     // Bits Layout:
843     // - [0..63]    `balance`
844     // - [64..127]  `numberMinted`
845     // - [128..191] `numberBurned`
846     // - [192..255] `aux`
847     mapping(address => uint256) private _packedAddressData;
848 
849     // Mapping from token ID to approved address.
850     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
851 
852     // Mapping from owner to operator approvals
853     mapping(address => mapping(address => bool)) private _operatorApprovals;
854 
855     // =============================================================
856     //                          CONSTRUCTOR
857     // =============================================================
858 
859     constructor(string memory name_, string memory symbol_) {
860         _name = name_;
861         _symbol = symbol_;
862         _currentIndex = _startTokenId();
863     }
864 
865     // =============================================================
866     //                   TOKEN COUNTING OPERATIONS
867     // =============================================================
868 
869     /**
870      * @dev Returns the starting token ID.
871      * To change the starting token ID, please override this function.
872      */
873     function _startTokenId() internal view virtual returns (uint256) {
874         return 0;
875     }
876 
877     /**
878      * @dev Returns the next token ID to be minted.
879      */
880     function _nextTokenId() internal view virtual returns (uint256) {
881         return _currentIndex;
882     }
883 
884     /**
885      * @dev Returns the total number of tokens in existence.
886      * Burned tokens will reduce the count.
887      * To get the total number of tokens minted, please see {_totalMinted}.
888      */
889     function totalSupply() public view virtual override returns (uint256) {
890         // Counter underflow is impossible as _burnCounter cannot be incremented
891         // more than `_currentIndex - _startTokenId()` times.
892         unchecked {
893             return _currentIndex - _burnCounter - _startTokenId();
894         }
895     }
896 
897     /**
898      * @dev Returns the total amount of tokens minted in the contract.
899      */
900     function _totalMinted() internal view virtual returns (uint256) {
901         // Counter underflow is impossible as `_currentIndex` does not decrement,
902         // and it is initialized to `_startTokenId()`.
903         unchecked {
904             return _currentIndex - _startTokenId();
905         }
906     }
907 
908     /**
909      * @dev Returns the total number of tokens burned.
910      */
911     function _totalBurned() internal view virtual returns (uint256) {
912         return _burnCounter;
913     }
914 
915     // =============================================================
916     //                    ADDRESS DATA OPERATIONS
917     // =============================================================
918 
919     /**
920      * @dev Returns the number of tokens in `owner`'s account.
921      */
922     function balanceOf(address owner) public view virtual override returns (uint256) {
923         if (owner == address(0)) revert BalanceQueryForZeroAddress();
924         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
925     }
926 
927     /**
928      * Returns the number of tokens minted by `owner`.
929      */
930     function _numberMinted(address owner) internal view returns (uint256) {
931         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
932     }
933 
934     /**
935      * Returns the number of tokens burned by or on behalf of `owner`.
936      */
937     function _numberBurned(address owner) internal view returns (uint256) {
938         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
939     }
940 
941     /**
942      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
943      */
944     function _getAux(address owner) internal view returns (uint64) {
945         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
946     }
947 
948     /**
949      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
950      * If there are multiple variables, please pack them into a uint64.
951      */
952     function _setAux(address owner, uint64 aux) internal virtual {
953         uint256 packed = _packedAddressData[owner];
954         uint256 auxCasted;
955         // Cast `aux` with assembly to avoid redundant masking.
956         assembly {
957             auxCasted := aux
958         }
959         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
960         _packedAddressData[owner] = packed;
961     }
962 
963     // =============================================================
964     //                            IERC165
965     // =============================================================
966 
967     /**
968      * @dev Returns true if this contract implements the interface defined by
969      * `interfaceId`. See the corresponding
970      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
971      * to learn more about how these ids are created.
972      *
973      * This function call must use less than 30000 gas.
974      */
975     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
976         // The interface IDs are constants representing the first 4 bytes
977         // of the XOR of all function selectors in the interface.
978         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
979         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
980         return
981             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
982             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
983             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
984     }
985 
986     // =============================================================
987     //                        IERC721Metadata
988     // =============================================================
989 
990     /**
991      * @dev Returns the token collection name.
992      */
993     function name() public view virtual override returns (string memory) {
994         return _name;
995     }
996 
997     /**
998      * @dev Returns the token collection symbol.
999      */
1000     function symbol() public view virtual override returns (string memory) {
1001         return _symbol;
1002     }
1003 
1004     /**
1005      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1006      */
1007     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1008         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1009 
1010         string memory baseURI = _baseURI();
1011         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1012     }
1013 
1014     /**
1015      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1016      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1017      * by default, it can be overridden in child contracts.
1018      */
1019     function _baseURI() internal view virtual returns (string memory) {
1020         return '';
1021     }
1022 
1023     // =============================================================
1024     //                     OWNERSHIPS OPERATIONS
1025     // =============================================================
1026 
1027     /**
1028      * @dev Returns the owner of the `tokenId` token.
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must exist.
1033      */
1034     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1035         return address(uint160(_packedOwnershipOf(tokenId)));
1036     }
1037 
1038     /**
1039      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1040      * It gradually moves to O(1) as tokens get transferred around over time.
1041      */
1042     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1043         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1044     }
1045 
1046     /**
1047      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1048      */
1049     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1050         return _unpackedOwnership(_packedOwnerships[index]);
1051     }
1052 
1053     /**
1054      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1055      */
1056     function _initializeOwnershipAt(uint256 index) internal virtual {
1057         if (_packedOwnerships[index] == 0) {
1058             _packedOwnerships[index] = _packedOwnershipOf(index);
1059         }
1060     }
1061 
1062     /**
1063      * Returns the packed ownership data of `tokenId`.
1064      */
1065     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1066         uint256 curr = tokenId;
1067 
1068         unchecked {
1069             if (_startTokenId() <= curr)
1070                 if (curr < _currentIndex) {
1071                     uint256 packed = _packedOwnerships[curr];
1072                     // If not burned.
1073                     if (packed & _BITMASK_BURNED == 0) {
1074                         // Invariant:
1075                         // There will always be an initialized ownership slot
1076                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1077                         // before an unintialized ownership slot
1078                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1079                         // Hence, `curr` will not underflow.
1080                         //
1081                         // We can directly compare the packed value.
1082                         // If the address is zero, packed will be zero.
1083                         while (packed == 0) {
1084                             packed = _packedOwnerships[--curr];
1085                         }
1086                         return packed;
1087                     }
1088                 }
1089         }
1090         revert OwnerQueryForNonexistentToken();
1091     }
1092 
1093     /**
1094      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1095      */
1096     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1097         ownership.addr = address(uint160(packed));
1098         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1099         ownership.burned = packed & _BITMASK_BURNED != 0;
1100         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1101     }
1102 
1103     /**
1104      * @dev Packs ownership data into a single uint256.
1105      */
1106     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1107         assembly {
1108             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1109             owner := and(owner, _BITMASK_ADDRESS)
1110             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1111             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1112         }
1113     }
1114 
1115     /**
1116      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1117      */
1118     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1119         // For branchless setting of the `nextInitialized` flag.
1120         assembly {
1121             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1122             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1123         }
1124     }
1125 
1126     // =============================================================
1127     //                      APPROVAL OPERATIONS
1128     // =============================================================
1129 
1130     /**
1131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1132      * The approval is cleared when the token is transferred.
1133      *
1134      * Only a single account can be approved at a time, so approving the
1135      * zero address clears previous approvals.
1136      *
1137      * Requirements:
1138      *
1139      * - The caller must own the token or be an approved operator.
1140      * - `tokenId` must exist.
1141      *
1142      * Emits an {Approval} event.
1143      */
1144     function approve(address to, uint256 tokenId) public payable virtual override {
1145         address owner = ownerOf(tokenId);
1146 
1147         if (_msgSenderERC721A() != owner)
1148             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1149                 revert ApprovalCallerNotOwnerNorApproved();
1150             }
1151 
1152         _tokenApprovals[tokenId].value = to;
1153         emit Approval(owner, to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev Returns the account approved for `tokenId` token.
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must exist.
1162      */
1163     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1164         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1165 
1166         return _tokenApprovals[tokenId].value;
1167     }
1168 
1169     /**
1170      * @dev Approve or remove `operator` as an operator for the caller.
1171      * Operators can call {transferFrom} or {safeTransferFrom}
1172      * for any token owned by the caller.
1173      *
1174      * Requirements:
1175      *
1176      * - The `operator` cannot be the caller.
1177      *
1178      * Emits an {ApprovalForAll} event.
1179      */
1180     function setApprovalForAll(address operator, bool approved) public virtual override {
1181         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1182         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1183     }
1184 
1185     /**
1186      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1187      *
1188      * See {setApprovalForAll}.
1189      */
1190     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1191         return _operatorApprovals[owner][operator];
1192     }
1193 
1194     /**
1195      * @dev Returns whether `tokenId` exists.
1196      *
1197      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1198      *
1199      * Tokens start existing when they are minted. See {_mint}.
1200      */
1201     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1202         return
1203             _startTokenId() <= tokenId &&
1204             tokenId < _currentIndex && // If within bounds,
1205             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1206     }
1207 
1208     /**
1209      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1210      */
1211     function _isSenderApprovedOrOwner(
1212         address approvedAddress,
1213         address owner,
1214         address msgSender
1215     ) private pure returns (bool result) {
1216         assembly {
1217             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1218             owner := and(owner, _BITMASK_ADDRESS)
1219             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1220             msgSender := and(msgSender, _BITMASK_ADDRESS)
1221             // `msgSender == owner || msgSender == approvedAddress`.
1222             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1223         }
1224     }
1225 
1226     /**
1227      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1228      */
1229     function _getApprovedSlotAndAddress(uint256 tokenId)
1230         private
1231         view
1232         returns (uint256 approvedAddressSlot, address approvedAddress)
1233     {
1234         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1235         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1236         assembly {
1237             approvedAddressSlot := tokenApproval.slot
1238             approvedAddress := sload(approvedAddressSlot)
1239         }
1240     }
1241 
1242     // =============================================================
1243     //                      TRANSFER OPERATIONS
1244     // =============================================================
1245 
1246     /**
1247      * @dev Transfers `tokenId` from `from` to `to`.
1248      *
1249      * Requirements:
1250      *
1251      * - `from` cannot be the zero address.
1252      * - `to` cannot be the zero address.
1253      * - `tokenId` token must be owned by `from`.
1254      * - If the caller is not `from`, it must be approved to move this token
1255      * by either {approve} or {setApprovalForAll}.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function transferFrom(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) public payable virtual override {
1264         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1265 
1266         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1267 
1268         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1269 
1270         // The nested ifs save around 20+ gas over a compound boolean condition.
1271         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1272             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1273 
1274         if (to == address(0)) revert TransferToZeroAddress();
1275 
1276         _beforeTokenTransfers(from, to, tokenId, 1);
1277 
1278         // Clear approvals from the previous owner.
1279         assembly {
1280             if approvedAddress {
1281                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1282                 sstore(approvedAddressSlot, 0)
1283             }
1284         }
1285 
1286         // Underflow of the sender's balance is impossible because we check for
1287         // ownership above and the recipient's balance can't realistically overflow.
1288         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1289         unchecked {
1290             // We can directly increment and decrement the balances.
1291             --_packedAddressData[from]; // Updates: `balance -= 1`.
1292             ++_packedAddressData[to]; // Updates: `balance += 1`.
1293 
1294             // Updates:
1295             // - `address` to the next owner.
1296             // - `startTimestamp` to the timestamp of transfering.
1297             // - `burned` to `false`.
1298             // - `nextInitialized` to `true`.
1299             _packedOwnerships[tokenId] = _packOwnershipData(
1300                 to,
1301                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1302             );
1303 
1304             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1305             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1306                 uint256 nextTokenId = tokenId + 1;
1307                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1308                 if (_packedOwnerships[nextTokenId] == 0) {
1309                     // If the next slot is within bounds.
1310                     if (nextTokenId != _currentIndex) {
1311                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1312                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1313                     }
1314                 }
1315             }
1316         }
1317 
1318         emit Transfer(from, to, tokenId);
1319         _afterTokenTransfers(from, to, tokenId, 1);
1320     }
1321 
1322     /**
1323      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1324      */
1325     function safeTransferFrom(
1326         address from,
1327         address to,
1328         uint256 tokenId
1329     ) public payable virtual override {
1330         safeTransferFrom(from, to, tokenId, '');
1331     }
1332 
1333     /**
1334      * @dev Safely transfers `tokenId` token from `from` to `to`.
1335      *
1336      * Requirements:
1337      *
1338      * - `from` cannot be the zero address.
1339      * - `to` cannot be the zero address.
1340      * - `tokenId` token must exist and be owned by `from`.
1341      * - If the caller is not `from`, it must be approved to move this token
1342      * by either {approve} or {setApprovalForAll}.
1343      * - If `to` refers to a smart contract, it must implement
1344      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1345      *
1346      * Emits a {Transfer} event.
1347      */
1348     function safeTransferFrom(
1349         address from,
1350         address to,
1351         uint256 tokenId,
1352         bytes memory _data
1353     ) public payable virtual override {
1354         transferFrom(from, to, tokenId);
1355         if (to.code.length != 0)
1356             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1357                 revert TransferToNonERC721ReceiverImplementer();
1358             }
1359     }
1360 
1361     /**
1362      * @dev Hook that is called before a set of serially-ordered token IDs
1363      * are about to be transferred. This includes minting.
1364      * And also called before burning one token.
1365      *
1366      * `startTokenId` - the first token ID to be transferred.
1367      * `quantity` - the amount to be transferred.
1368      *
1369      * Calling conditions:
1370      *
1371      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1372      * transferred to `to`.
1373      * - When `from` is zero, `tokenId` will be minted for `to`.
1374      * - When `to` is zero, `tokenId` will be burned by `from`.
1375      * - `from` and `to` are never both zero.
1376      */
1377     function _beforeTokenTransfers(
1378         address from,
1379         address to,
1380         uint256 startTokenId,
1381         uint256 quantity
1382     ) internal virtual {}
1383 
1384     /**
1385      * @dev Hook that is called after a set of serially-ordered token IDs
1386      * have been transferred. This includes minting.
1387      * And also called after one token has been burned.
1388      *
1389      * `startTokenId` - the first token ID to be transferred.
1390      * `quantity` - the amount to be transferred.
1391      *
1392      * Calling conditions:
1393      *
1394      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1395      * transferred to `to`.
1396      * - When `from` is zero, `tokenId` has been minted for `to`.
1397      * - When `to` is zero, `tokenId` has been burned by `from`.
1398      * - `from` and `to` are never both zero.
1399      */
1400     function _afterTokenTransfers(
1401         address from,
1402         address to,
1403         uint256 startTokenId,
1404         uint256 quantity
1405     ) internal virtual {}
1406 
1407     /**
1408      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1409      *
1410      * `from` - Previous owner of the given token ID.
1411      * `to` - Target address that will receive the token.
1412      * `tokenId` - Token ID to be transferred.
1413      * `_data` - Optional data to send along with the call.
1414      *
1415      * Returns whether the call correctly returned the expected magic value.
1416      */
1417     function _checkContractOnERC721Received(
1418         address from,
1419         address to,
1420         uint256 tokenId,
1421         bytes memory _data
1422     ) private returns (bool) {
1423         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1424             bytes4 retval
1425         ) {
1426             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1427         } catch (bytes memory reason) {
1428             if (reason.length == 0) {
1429                 revert TransferToNonERC721ReceiverImplementer();
1430             } else {
1431                 assembly {
1432                     revert(add(32, reason), mload(reason))
1433                 }
1434             }
1435         }
1436     }
1437 
1438     // =============================================================
1439     //                        MINT OPERATIONS
1440     // =============================================================
1441 
1442     /**
1443      * @dev Mints `quantity` tokens and transfers them to `to`.
1444      *
1445      * Requirements:
1446      *
1447      * - `to` cannot be the zero address.
1448      * - `quantity` must be greater than 0.
1449      *
1450      * Emits a {Transfer} event for each mint.
1451      */
1452     function _mint(address to, uint256 quantity) internal virtual {
1453         uint256 startTokenId = _currentIndex;
1454         if (quantity == 0) revert MintZeroQuantity();
1455 
1456         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1457 
1458         // Overflows are incredibly unrealistic.
1459         // `balance` and `numberMinted` have a maximum limit of 2**64.
1460         // `tokenId` has a maximum limit of 2**256.
1461         unchecked {
1462             // Updates:
1463             // - `balance += quantity`.
1464             // - `numberMinted += quantity`.
1465             //
1466             // We can directly add to the `balance` and `numberMinted`.
1467             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1468 
1469             // Updates:
1470             // - `address` to the owner.
1471             // - `startTimestamp` to the timestamp of minting.
1472             // - `burned` to `false`.
1473             // - `nextInitialized` to `quantity == 1`.
1474             _packedOwnerships[startTokenId] = _packOwnershipData(
1475                 to,
1476                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1477             );
1478 
1479             uint256 toMasked;
1480             uint256 end = startTokenId + quantity;
1481 
1482             // Use assembly to loop and emit the `Transfer` event for gas savings.
1483             // The duplicated `log4` removes an extra check and reduces stack juggling.
1484             // The assembly, together with the surrounding Solidity code, have been
1485             // delicately arranged to nudge the compiler into producing optimized opcodes.
1486             assembly {
1487                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1488                 toMasked := and(to, _BITMASK_ADDRESS)
1489                 // Emit the `Transfer` event.
1490                 log4(
1491                     0, // Start of data (0, since no data).
1492                     0, // End of data (0, since no data).
1493                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1494                     0, // `address(0)`.
1495                     toMasked, // `to`.
1496                     startTokenId // `tokenId`.
1497                 )
1498 
1499                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1500                 // that overflows uint256 will make the loop run out of gas.
1501                 // The compiler will optimize the `iszero` away for performance.
1502                 for {
1503                     let tokenId := add(startTokenId, 1)
1504                 } iszero(eq(tokenId, end)) {
1505                     tokenId := add(tokenId, 1)
1506                 } {
1507                     // Emit the `Transfer` event. Similar to above.
1508                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1509                 }
1510             }
1511             if (toMasked == 0) revert MintToZeroAddress();
1512 
1513             _currentIndex = end;
1514         }
1515         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1516     }
1517 
1518     /**
1519      * @dev Mints `quantity` tokens and transfers them to `to`.
1520      *
1521      * This function is intended for efficient minting only during contract creation.
1522      *
1523      * It emits only one {ConsecutiveTransfer} as defined in
1524      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1525      * instead of a sequence of {Transfer} event(s).
1526      *
1527      * Calling this function outside of contract creation WILL make your contract
1528      * non-compliant with the ERC721 standard.
1529      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1530      * {ConsecutiveTransfer} event is only permissible during contract creation.
1531      *
1532      * Requirements:
1533      *
1534      * - `to` cannot be the zero address.
1535      * - `quantity` must be greater than 0.
1536      *
1537      * Emits a {ConsecutiveTransfer} event.
1538      */
1539     function _mintERC2309(address to, uint256 quantity) internal virtual {
1540         uint256 startTokenId = _currentIndex;
1541         if (to == address(0)) revert MintToZeroAddress();
1542         if (quantity == 0) revert MintZeroQuantity();
1543         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1544 
1545         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1546 
1547         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1548         unchecked {
1549             // Updates:
1550             // - `balance += quantity`.
1551             // - `numberMinted += quantity`.
1552             //
1553             // We can directly add to the `balance` and `numberMinted`.
1554             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1555 
1556             // Updates:
1557             // - `address` to the owner.
1558             // - `startTimestamp` to the timestamp of minting.
1559             // - `burned` to `false`.
1560             // - `nextInitialized` to `quantity == 1`.
1561             _packedOwnerships[startTokenId] = _packOwnershipData(
1562                 to,
1563                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1564             );
1565 
1566             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1567 
1568             _currentIndex = startTokenId + quantity;
1569         }
1570         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1571     }
1572 
1573     /**
1574      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1575      *
1576      * Requirements:
1577      *
1578      * - If `to` refers to a smart contract, it must implement
1579      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1580      * - `quantity` must be greater than 0.
1581      *
1582      * See {_mint}.
1583      *
1584      * Emits a {Transfer} event for each mint.
1585      */
1586     function _safeMint(
1587         address to,
1588         uint256 quantity,
1589         bytes memory _data
1590     ) internal virtual {
1591         _mint(to, quantity);
1592 
1593         unchecked {
1594             if (to.code.length != 0) {
1595                 uint256 end = _currentIndex;
1596                 uint256 index = end - quantity;
1597                 do {
1598                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1599                         revert TransferToNonERC721ReceiverImplementer();
1600                     }
1601                 } while (index < end);
1602                 // Reentrancy protection.
1603                 if (_currentIndex != end) revert();
1604             }
1605         }
1606     }
1607 
1608     /**
1609      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1610      */
1611     function _safeMint(address to, uint256 quantity) internal virtual {
1612         _safeMint(to, quantity, '');
1613     }
1614 
1615     // =============================================================
1616     //                        BURN OPERATIONS
1617     // =============================================================
1618 
1619     /**
1620      * @dev Equivalent to `_burn(tokenId, false)`.
1621      */
1622     function _burn(uint256 tokenId) internal virtual {
1623         _burn(tokenId, false);
1624     }
1625 
1626     /**
1627      * @dev Destroys `tokenId`.
1628      * The approval is cleared when the token is burned.
1629      *
1630      * Requirements:
1631      *
1632      * - `tokenId` must exist.
1633      *
1634      * Emits a {Transfer} event.
1635      */
1636     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1637         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1638 
1639         address from = address(uint160(prevOwnershipPacked));
1640 
1641         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1642 
1643         if (approvalCheck) {
1644             // The nested ifs save around 20+ gas over a compound boolean condition.
1645             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1646                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1647         }
1648 
1649         _beforeTokenTransfers(from, address(0), tokenId, 1);
1650 
1651         // Clear approvals from the previous owner.
1652         assembly {
1653             if approvedAddress {
1654                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1655                 sstore(approvedAddressSlot, 0)
1656             }
1657         }
1658 
1659         // Underflow of the sender's balance is impossible because we check for
1660         // ownership above and the recipient's balance can't realistically overflow.
1661         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1662         unchecked {
1663             // Updates:
1664             // - `balance -= 1`.
1665             // - `numberBurned += 1`.
1666             //
1667             // We can directly decrement the balance, and increment the number burned.
1668             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1669             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1670 
1671             // Updates:
1672             // - `address` to the last owner.
1673             // - `startTimestamp` to the timestamp of burning.
1674             // - `burned` to `true`.
1675             // - `nextInitialized` to `true`.
1676             _packedOwnerships[tokenId] = _packOwnershipData(
1677                 from,
1678                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1679             );
1680 
1681             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1682             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1683                 uint256 nextTokenId = tokenId + 1;
1684                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1685                 if (_packedOwnerships[nextTokenId] == 0) {
1686                     // If the next slot is within bounds.
1687                     if (nextTokenId != _currentIndex) {
1688                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1689                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1690                     }
1691                 }
1692             }
1693         }
1694 
1695         emit Transfer(from, address(0), tokenId);
1696         _afterTokenTransfers(from, address(0), tokenId, 1);
1697 
1698         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1699         unchecked {
1700             _burnCounter++;
1701         }
1702     }
1703 
1704     // =============================================================
1705     //                     EXTRA DATA OPERATIONS
1706     // =============================================================
1707 
1708     /**
1709      * @dev Directly sets the extra data for the ownership data `index`.
1710      */
1711     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1712         uint256 packed = _packedOwnerships[index];
1713         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1714         uint256 extraDataCasted;
1715         // Cast `extraData` with assembly to avoid redundant masking.
1716         assembly {
1717             extraDataCasted := extraData
1718         }
1719         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1720         _packedOwnerships[index] = packed;
1721     }
1722 
1723     /**
1724      * @dev Called during each token transfer to set the 24bit `extraData` field.
1725      * Intended to be overridden by the cosumer contract.
1726      *
1727      * `previousExtraData` - the value of `extraData` before transfer.
1728      *
1729      * Calling conditions:
1730      *
1731      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1732      * transferred to `to`.
1733      * - When `from` is zero, `tokenId` will be minted for `to`.
1734      * - When `to` is zero, `tokenId` will be burned by `from`.
1735      * - `from` and `to` are never both zero.
1736      */
1737     function _extraData(
1738         address from,
1739         address to,
1740         uint24 previousExtraData
1741     ) internal view virtual returns (uint24) {}
1742 
1743     /**
1744      * @dev Returns the next extra data for the packed ownership data.
1745      * The returned result is shifted into position.
1746      */
1747     function _nextExtraData(
1748         address from,
1749         address to,
1750         uint256 prevOwnershipPacked
1751     ) private view returns (uint256) {
1752         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1753         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1754     }
1755 
1756     // =============================================================
1757     //                       OTHER OPERATIONS
1758     // =============================================================
1759 
1760     /**
1761      * @dev Returns the message sender (defaults to `msg.sender`).
1762      *
1763      * If you are writing GSN compatible contracts, you need to override this function.
1764      */
1765     function _msgSenderERC721A() internal view virtual returns (address) {
1766         return msg.sender;
1767     }
1768 
1769     /**
1770      * @dev Converts a uint256 to its ASCII string decimal representation.
1771      */
1772     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1773         assembly {
1774             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1775             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1776             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1777             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1778             let m := add(mload(0x40), 0xa0)
1779             // Update the free memory pointer to allocate.
1780             mstore(0x40, m)
1781             // Assign the `str` to the end.
1782             str := sub(m, 0x20)
1783             // Zeroize the slot after the string.
1784             mstore(str, 0)
1785 
1786             // Cache the end of the memory to calculate the length later.
1787             let end := str
1788 
1789             // We write the string from rightmost digit to leftmost digit.
1790             // The following is essentially a do-while loop that also handles the zero case.
1791             // prettier-ignore
1792             for { let temp := value } 1 {} {
1793                 str := sub(str, 1)
1794                 // Write the character to the pointer.
1795                 // The ASCII index of the '0' character is 48.
1796                 mstore8(str, add(48, mod(temp, 10)))
1797                 // Keep dividing `temp` until zero.
1798                 temp := div(temp, 10)
1799                 // prettier-ignore
1800                 if iszero(temp) { break }
1801             }
1802 
1803             let length := sub(end, str)
1804             // Move the pointer 32 bytes leftwards to make room for the length.
1805             str := sub(str, 0x20)
1806             // Store the length.
1807             mstore(str, length)
1808         }
1809     }
1810 }
1811 
1812 // File: idolo.sol
1813 
1814 
1815 
1816 pragma solidity >=0.7.0 <0.9.0;
1817 
1818 
1819 
1820 
1821 
1822 contract IDOLO is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
1823     string public baseURI;
1824     string public notRevealedUri;
1825     uint256 public price = 0.0045 ether;
1826     uint256 public supply = 3333;
1827     uint256 public perwallet = 8;
1828     uint256 public pertx = 4;
1829     bool public paused = true;
1830     bool public ishidden = false;
1831 
1832     constructor() ERC721A("IDOLO", "IDOLO") {}
1833 
1834     function publicmint(uint256 tokens) public payable nonReentrant {
1835         require(!paused, "SYMBOL:contract paused");
1836         require(tokens <= pertx, "SYMBOL: max mint amount per tx has exceeded");
1837         require(totalSupply() + tokens <= supply, "SYMBOL: We have unfortunately soldout");
1838         require(
1839             numberMinted(_msgSenderERC721A()) + tokens <= perwallet,
1840             "SYMBOL: Max NFT Per Wallet exceeded"
1841         );
1842         require(msg.value >= price * tokens, "SYMBOL: insufficient funds");
1843         _safeMint(_msgSenderERC721A(), tokens);
1844     }
1845 
1846     function mintforteam(uint256 _amount, address _address)
1847         public
1848         onlyOwner
1849         nonReentrant
1850     {
1851         require(totalSupply() + _amount <= supply, "max limit of NFTs exceeded");
1852 
1853         _safeMint(_address, _amount);
1854     }
1855 
1856     function _baseURI() internal view virtual override returns (string memory) {
1857         return baseURI;
1858     }
1859 
1860     function _startTokenId() internal view virtual override returns (uint256) {
1861         return 1;
1862     }
1863 
1864     function tokenURI(uint256 tokenId)
1865         public
1866         view
1867         virtual
1868         override
1869         returns (string memory)
1870     {
1871         require(
1872             _exists(tokenId),
1873             "ERC721AMetadata: URI query for nonexistent token"
1874         );
1875 
1876         if (ishidden == false) {
1877             return notRevealedUri;
1878         }
1879 
1880         string memory currentBaseURI = _baseURI();
1881         return
1882             bytes(currentBaseURI).length > 0
1883                 ? string(
1884                     abi.encodePacked(
1885                         currentBaseURI,
1886                         _toString(tokenId),
1887                         ".json"
1888                     )
1889                 )
1890                 : "";
1891     }
1892 
1893     function numberMinted(address owner) public view returns (uint256) {
1894         return _numberMinted(owner);
1895     }
1896 
1897     function tokensOfOwner(address owner)
1898         public
1899         view
1900         returns (uint256[] memory)
1901     {
1902         unchecked {
1903             uint256 tokenIdsIdx;
1904             address currOwnershipAddr;
1905             uint256 tokenIdsLength = balanceOf(owner);
1906             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1907             TokenOwnership memory ownership;
1908             for (
1909                 uint256 i = _startTokenId();
1910                 tokenIdsIdx != tokenIdsLength;
1911                 ++i
1912             ) {
1913                 ownership = _ownershipAt(i);
1914                 if (ownership.burned) {
1915                     continue;
1916                 }
1917                 if (ownership.addr != address(0)) {
1918                     currOwnershipAddr = ownership.addr;
1919                 }
1920                 if (currOwnershipAddr == owner) {
1921                     tokenIds[tokenIdsIdx++] = i;
1922                 }
1923             }
1924             return tokenIds;
1925         }
1926     }
1927 
1928     function transferFrom(
1929         address from,
1930         address to,
1931         uint256 tokenId
1932     ) public payable override onlyAllowedOperator(from) {
1933         super.transferFrom(from, to, tokenId);
1934     }
1935 
1936     function safeTransferFrom(
1937         address from,
1938         address to,
1939         uint256 tokenId
1940     ) public payable override onlyAllowedOperator(from) {
1941         super.safeTransferFrom(from, to, tokenId);
1942     }
1943 
1944     function safeTransferFrom(
1945         address from,
1946         address to,
1947         uint256 tokenId,
1948         bytes memory data
1949     ) public payable override onlyAllowedOperator(from) {
1950         super.safeTransferFrom(from, to, tokenId, data);
1951     }
1952 
1953     function reveal(bool _state) public onlyOwner {
1954         ishidden = _state;
1955     }
1956 
1957     function setperwallet(uint256 _limit) public onlyOwner {
1958         perwallet = _limit;
1959     }
1960 
1961     function setpertx(uint256 _limit) public onlyOwner {
1962         pertx = _limit;
1963     }
1964 
1965     function setprice(uint256 _newCost) public onlyOwner {
1966         price = _newCost;
1967     }
1968 
1969     function setsupply(uint256 _newsupply) public onlyOwner {
1970         supply = _newsupply;
1971     }
1972 
1973     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1974         baseURI = _newBaseURI;
1975     }
1976 
1977     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1978         notRevealedUri = _notRevealedURI;
1979     }
1980 
1981     function pause(bool _state) public onlyOwner {
1982         paused = _state;
1983     }
1984 
1985     function withdraw() public payable onlyOwner nonReentrant {
1986         payable(_msgSenderERC721A()).transfer(address(this).balance);
1987     }
1988 }