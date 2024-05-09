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
250 // File: @openzeppelin/contracts/utils/Context.sol
251 
252 
253 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @dev Provides information about the current execution context, including the
259  * sender of the transaction and its data. While these are generally available
260  * via msg.sender and msg.data, they should not be accessed in such a direct
261  * manner, since when dealing with meta-transactions the account sending and
262  * paying for execution may not be the actual sender (as far as an application
263  * is concerned).
264  *
265  * This contract is only required for intermediate, library-like contracts.
266  */
267 abstract contract Context {
268     function _msgSender() internal view virtual returns (address) {
269         return msg.sender;
270     }
271 
272     function _msgData() internal view virtual returns (bytes calldata) {
273         return msg.data;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/access/Ownable.sol
278 
279 
280 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 
285 /**
286  * @dev Contract module which provides a basic access control mechanism, where
287  * there is an account (an owner) that can be granted exclusive access to
288  * specific functions.
289  *
290  * By default, the owner account will be the one that deploys the contract. This
291  * can later be changed with {transferOwnership}.
292  *
293  * This module is used through inheritance. It will make available the modifier
294  * `onlyOwner`, which can be applied to your functions to restrict their use to
295  * the owner.
296  */
297 abstract contract Ownable is Context {
298     address private _owner;
299 
300     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
301 
302     /**
303      * @dev Initializes the contract setting the deployer as the initial owner.
304      */
305     constructor() {
306         _transferOwnership(_msgSender());
307     }
308 
309     /**
310      * @dev Throws if called by any account other than the owner.
311      */
312     modifier onlyOwner() {
313         _checkOwner();
314         _;
315     }
316 
317     /**
318      * @dev Returns the address of the current owner.
319      */
320     function owner() public view virtual returns (address) {
321         return _owner;
322     }
323 
324     /**
325      * @dev Throws if the sender is not the owner.
326      */
327     function _checkOwner() internal view virtual {
328         require(owner() == _msgSender(), "Ownable: caller is not the owner");
329     }
330 
331     /**
332      * @dev Leaves the contract without owner. It will not be possible to call
333      * `onlyOwner` functions anymore. Can only be called by the current owner.
334      *
335      * NOTE: Renouncing ownership will leave the contract without an owner,
336      * thereby removing any functionality that is only available to the owner.
337      */
338     function renounceOwnership() public virtual onlyOwner {
339         _transferOwnership(address(0));
340     }
341 
342     /**
343      * @dev Transfers ownership of the contract to a new account (`newOwner`).
344      * Can only be called by the current owner.
345      */
346     function transferOwnership(address newOwner) public virtual onlyOwner {
347         require(newOwner != address(0), "Ownable: new owner is the zero address");
348         _transferOwnership(newOwner);
349     }
350 
351     /**
352      * @dev Transfers ownership of the contract to a new account (`newOwner`).
353      * Internal function without access restriction.
354      */
355     function _transferOwnership(address newOwner) internal virtual {
356         address oldOwner = _owner;
357         _owner = newOwner;
358         emit OwnershipTransferred(oldOwner, newOwner);
359     }
360 }
361 
362 // File: erc721a/contracts/IERC721A.sol
363 
364 
365 // ERC721A Contracts v4.2.3
366 // Creator: Chiru Labs
367 
368 pragma solidity ^0.8.4;
369 
370 /**
371  * @dev Interface of ERC721A.
372  */
373 interface IERC721A {
374     /**
375      * The caller must own the token or be an approved operator.
376      */
377     error ApprovalCallerNotOwnerNorApproved();
378 
379     /**
380      * The token does not exist.
381      */
382     error ApprovalQueryForNonexistentToken();
383 
384     /**
385      * Cannot query the balance for the zero address.
386      */
387     error BalanceQueryForZeroAddress();
388 
389     /**
390      * Cannot mint to the zero address.
391      */
392     error MintToZeroAddress();
393 
394     /**
395      * The quantity of tokens minted must be more than zero.
396      */
397     error MintZeroQuantity();
398 
399     /**
400      * The token does not exist.
401      */
402     error OwnerQueryForNonexistentToken();
403 
404     /**
405      * The caller must own the token or be an approved operator.
406      */
407     error TransferCallerNotOwnerNorApproved();
408 
409     /**
410      * The token must be owned by `from`.
411      */
412     error TransferFromIncorrectOwner();
413 
414     /**
415      * Cannot safely transfer to a contract that does not implement the
416      * ERC721Receiver interface.
417      */
418     error TransferToNonERC721ReceiverImplementer();
419 
420     /**
421      * Cannot transfer to the zero address.
422      */
423     error TransferToZeroAddress();
424 
425     /**
426      * The token does not exist.
427      */
428     error URIQueryForNonexistentToken();
429 
430     /**
431      * The `quantity` minted with ERC2309 exceeds the safety limit.
432      */
433     error MintERC2309QuantityExceedsLimit();
434 
435     /**
436      * The `extraData` cannot be set on an unintialized ownership slot.
437      */
438     error OwnershipNotInitializedForExtraData();
439 
440     // =============================================================
441     //                            STRUCTS
442     // =============================================================
443 
444     struct TokenOwnership {
445         // The address of the owner.
446         address addr;
447         // Stores the start time of ownership with minimal overhead for tokenomics.
448         uint64 startTimestamp;
449         // Whether the token has been burned.
450         bool burned;
451         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
452         uint24 extraData;
453     }
454 
455     // =============================================================
456     //                         TOKEN COUNTERS
457     // =============================================================
458 
459     /**
460      * @dev Returns the total number of tokens in existence.
461      * Burned tokens will reduce the count.
462      * To get the total number of tokens minted, please see {_totalMinted}.
463      */
464     function totalSupply() external view returns (uint256);
465 
466     // =============================================================
467     //                            IERC165
468     // =============================================================
469 
470     /**
471      * @dev Returns true if this contract implements the interface defined by
472      * `interfaceId`. See the corresponding
473      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
474      * to learn more about how these ids are created.
475      *
476      * This function call must use less than 30000 gas.
477      */
478     function supportsInterface(bytes4 interfaceId) external view returns (bool);
479 
480     // =============================================================
481     //                            IERC721
482     // =============================================================
483 
484     /**
485      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
486      */
487     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
488 
489     /**
490      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
491      */
492     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
493 
494     /**
495      * @dev Emitted when `owner` enables or disables
496      * (`approved`) `operator` to manage all of its assets.
497      */
498     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
499 
500     /**
501      * @dev Returns the number of tokens in `owner`'s account.
502      */
503     function balanceOf(address owner) external view returns (uint256 balance);
504 
505     /**
506      * @dev Returns the owner of the `tokenId` token.
507      *
508      * Requirements:
509      *
510      * - `tokenId` must exist.
511      */
512     function ownerOf(uint256 tokenId) external view returns (address owner);
513 
514     /**
515      * @dev Safely transfers `tokenId` token from `from` to `to`,
516      * checking first that contract recipients are aware of the ERC721 protocol
517      * to prevent tokens from being forever locked.
518      *
519      * Requirements:
520      *
521      * - `from` cannot be the zero address.
522      * - `to` cannot be the zero address.
523      * - `tokenId` token must exist and be owned by `from`.
524      * - If the caller is not `from`, it must be have been allowed to move
525      * this token by either {approve} or {setApprovalForAll}.
526      * - If `to` refers to a smart contract, it must implement
527      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
528      *
529      * Emits a {Transfer} event.
530      */
531     function safeTransferFrom(
532         address from,
533         address to,
534         uint256 tokenId,
535         bytes calldata data
536     ) external payable;
537 
538     /**
539      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) external payable;
546 
547     /**
548      * @dev Transfers `tokenId` from `from` to `to`.
549      *
550      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
551      * whenever possible.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must be owned by `from`.
558      * - If the caller is not `from`, it must be approved to move this token
559      * by either {approve} or {setApprovalForAll}.
560      *
561      * Emits a {Transfer} event.
562      */
563     function transferFrom(
564         address from,
565         address to,
566         uint256 tokenId
567     ) external payable;
568 
569     /**
570      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
571      * The approval is cleared when the token is transferred.
572      *
573      * Only a single account can be approved at a time, so approving the
574      * zero address clears previous approvals.
575      *
576      * Requirements:
577      *
578      * - The caller must own the token or be an approved operator.
579      * - `tokenId` must exist.
580      *
581      * Emits an {Approval} event.
582      */
583     function approve(address to, uint256 tokenId) external payable;
584 
585     /**
586      * @dev Approve or remove `operator` as an operator for the caller.
587      * Operators can call {transferFrom} or {safeTransferFrom}
588      * for any token owned by the caller.
589      *
590      * Requirements:
591      *
592      * - The `operator` cannot be the caller.
593      *
594      * Emits an {ApprovalForAll} event.
595      */
596     function setApprovalForAll(address operator, bool _approved) external;
597 
598     /**
599      * @dev Returns the account approved for `tokenId` token.
600      *
601      * Requirements:
602      *
603      * - `tokenId` must exist.
604      */
605     function getApproved(uint256 tokenId) external view returns (address operator);
606 
607     /**
608      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
609      *
610      * See {setApprovalForAll}.
611      */
612     function isApprovedForAll(address owner, address operator) external view returns (bool);
613 
614     // =============================================================
615     //                        IERC721Metadata
616     // =============================================================
617 
618     /**
619      * @dev Returns the token collection name.
620      */
621     function name() external view returns (string memory);
622 
623     /**
624      * @dev Returns the token collection symbol.
625      */
626     function symbol() external view returns (string memory);
627 
628     /**
629      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
630      */
631     function tokenURI(uint256 tokenId) external view returns (string memory);
632 
633     // =============================================================
634     //                           IERC2309
635     // =============================================================
636 
637     /**
638      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
639      * (inclusive) is transferred from `from` to `to`, as defined in the
640      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
641      *
642      * See {_mintERC2309} for more details.
643      */
644     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
645 }
646 
647 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
648 
649 
650 // ERC721A Contracts v4.2.3
651 // Creator: Chiru Labs
652 
653 pragma solidity ^0.8.4;
654 
655 
656 /**
657  * @dev Interface of ERC721ABurnable.
658  */
659 interface IERC721ABurnable is IERC721A {
660     /**
661      * @dev Burns `tokenId`. See {ERC721A-_burn}.
662      *
663      * Requirements:
664      *
665      * - The caller must own `tokenId` or be an approved operator.
666      */
667     function burn(uint256 tokenId) external;
668 }
669 
670 // File: erc721a/contracts/ERC721A.sol
671 
672 
673 // ERC721A Contracts v4.2.3
674 // Creator: Chiru Labs
675 
676 pragma solidity ^0.8.4;
677 
678 
679 /**
680  * @dev Interface of ERC721 token receiver.
681  */
682 interface ERC721A__IERC721Receiver {
683     function onERC721Received(
684         address operator,
685         address from,
686         uint256 tokenId,
687         bytes calldata data
688     ) external returns (bytes4);
689 }
690 
691 /**
692  * @title ERC721A
693  *
694  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
695  * Non-Fungible Token Standard, including the Metadata extension.
696  * Optimized for lower gas during batch mints.
697  *
698  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
699  * starting from `_startTokenId()`.
700  *
701  * Assumptions:
702  *
703  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
704  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
705  */
706 contract ERC721A is IERC721A {
707     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
708     struct TokenApprovalRef {
709         address value;
710     }
711 
712     // =============================================================
713     //                           CONSTANTS
714     // =============================================================
715 
716     // Mask of an entry in packed address data.
717     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
718 
719     // The bit position of `numberMinted` in packed address data.
720     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
721 
722     // The bit position of `numberBurned` in packed address data.
723     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
724 
725     // The bit position of `aux` in packed address data.
726     uint256 private constant _BITPOS_AUX = 192;
727 
728     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
729     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
730 
731     // The bit position of `startTimestamp` in packed ownership.
732     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
733 
734     // The bit mask of the `burned` bit in packed ownership.
735     uint256 private constant _BITMASK_BURNED = 1 << 224;
736 
737     // The bit position of the `nextInitialized` bit in packed ownership.
738     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
739 
740     // The bit mask of the `nextInitialized` bit in packed ownership.
741     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
742 
743     // The bit position of `extraData` in packed ownership.
744     uint256 private constant _BITPOS_EXTRA_DATA = 232;
745 
746     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
747     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
748 
749     // The mask of the lower 160 bits for addresses.
750     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
751 
752     // The maximum `quantity` that can be minted with {_mintERC2309}.
753     // This limit is to prevent overflows on the address data entries.
754     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
755     // is required to cause an overflow, which is unrealistic.
756     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
757 
758     // The `Transfer` event signature is given by:
759     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
760     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
761         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
762 
763     // =============================================================
764     //                            STORAGE
765     // =============================================================
766 
767     // The next token ID to be minted.
768     uint256 private _currentIndex;
769 
770     // The number of tokens burned.
771     uint256 private _burnCounter;
772 
773     // Token name
774     string private _name;
775 
776     // Token symbol
777     string private _symbol;
778 
779     // Mapping from token ID to ownership details
780     // An empty struct value does not necessarily mean the token is unowned.
781     // See {_packedOwnershipOf} implementation for details.
782     //
783     // Bits Layout:
784     // - [0..159]   `addr`
785     // - [160..223] `startTimestamp`
786     // - [224]      `burned`
787     // - [225]      `nextInitialized`
788     // - [232..255] `extraData`
789     mapping(uint256 => uint256) private _packedOwnerships;
790 
791     // Mapping owner address to address data.
792     //
793     // Bits Layout:
794     // - [0..63]    `balance`
795     // - [64..127]  `numberMinted`
796     // - [128..191] `numberBurned`
797     // - [192..255] `aux`
798     mapping(address => uint256) private _packedAddressData;
799 
800     // Mapping from token ID to approved address.
801     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
802 
803     // Mapping from owner to operator approvals
804     mapping(address => mapping(address => bool)) private _operatorApprovals;
805 
806     // =============================================================
807     //                          CONSTRUCTOR
808     // =============================================================
809 
810     constructor(string memory name_, string memory symbol_) {
811         _name = name_;
812         _symbol = symbol_;
813         _currentIndex = _startTokenId();
814     }
815 
816     // =============================================================
817     //                   TOKEN COUNTING OPERATIONS
818     // =============================================================
819 
820     /**
821      * @dev Returns the starting token ID.
822      * To change the starting token ID, please override this function.
823      */
824     function _startTokenId() internal view virtual returns (uint256) {
825         return 0;
826     }
827 
828     /**
829      * @dev Returns the next token ID to be minted.
830      */
831     function _nextTokenId() internal view virtual returns (uint256) {
832         return _currentIndex;
833     }
834 
835     /**
836      * @dev Returns the total number of tokens in existence.
837      * Burned tokens will reduce the count.
838      * To get the total number of tokens minted, please see {_totalMinted}.
839      */
840     function totalSupply() public view virtual override returns (uint256) {
841         // Counter underflow is impossible as _burnCounter cannot be incremented
842         // more than `_currentIndex - _startTokenId()` times.
843         unchecked {
844             return _currentIndex - _burnCounter - _startTokenId();
845         }
846     }
847 
848     /**
849      * @dev Returns the total amount of tokens minted in the contract.
850      */
851     function _totalMinted() internal view virtual returns (uint256) {
852         // Counter underflow is impossible as `_currentIndex` does not decrement,
853         // and it is initialized to `_startTokenId()`.
854         unchecked {
855             return _currentIndex - _startTokenId();
856         }
857     }
858 
859     /**
860      * @dev Returns the total number of tokens burned.
861      */
862     function _totalBurned() internal view virtual returns (uint256) {
863         return _burnCounter;
864     }
865 
866     // =============================================================
867     //                    ADDRESS DATA OPERATIONS
868     // =============================================================
869 
870     /**
871      * @dev Returns the number of tokens in `owner`'s account.
872      */
873     function balanceOf(address owner) public view virtual override returns (uint256) {
874         if (owner == address(0)) revert BalanceQueryForZeroAddress();
875         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
876     }
877 
878     /**
879      * Returns the number of tokens minted by `owner`.
880      */
881     function _numberMinted(address owner) internal view returns (uint256) {
882         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
883     }
884 
885     /**
886      * Returns the number of tokens burned by or on behalf of `owner`.
887      */
888     function _numberBurned(address owner) internal view returns (uint256) {
889         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
890     }
891 
892     /**
893      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
894      */
895     function _getAux(address owner) internal view returns (uint64) {
896         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
897     }
898 
899     /**
900      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
901      * If there are multiple variables, please pack them into a uint64.
902      */
903     function _setAux(address owner, uint64 aux) internal virtual {
904         uint256 packed = _packedAddressData[owner];
905         uint256 auxCasted;
906         // Cast `aux` with assembly to avoid redundant masking.
907         assembly {
908             auxCasted := aux
909         }
910         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
911         _packedAddressData[owner] = packed;
912     }
913 
914     // =============================================================
915     //                            IERC165
916     // =============================================================
917 
918     /**
919      * @dev Returns true if this contract implements the interface defined by
920      * `interfaceId`. See the corresponding
921      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
922      * to learn more about how these ids are created.
923      *
924      * This function call must use less than 30000 gas.
925      */
926     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
927         // The interface IDs are constants representing the first 4 bytes
928         // of the XOR of all function selectors in the interface.
929         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
930         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
931         return
932             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
933             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
934             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
935     }
936 
937     // =============================================================
938     //                        IERC721Metadata
939     // =============================================================
940 
941     /**
942      * @dev Returns the token collection name.
943      */
944     function name() public view virtual override returns (string memory) {
945         return _name;
946     }
947 
948     /**
949      * @dev Returns the token collection symbol.
950      */
951     function symbol() public view virtual override returns (string memory) {
952         return _symbol;
953     }
954 
955     /**
956      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
957      */
958     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
959         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
960 
961         string memory baseURI = _baseURI();
962         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
963     }
964 
965     /**
966      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
967      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
968      * by default, it can be overridden in child contracts.
969      */
970     function _baseURI() internal view virtual returns (string memory) {
971         return '';
972     }
973 
974     // =============================================================
975     //                     OWNERSHIPS OPERATIONS
976     // =============================================================
977 
978     /**
979      * @dev Returns the owner of the `tokenId` token.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must exist.
984      */
985     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
986         return address(uint160(_packedOwnershipOf(tokenId)));
987     }
988 
989     /**
990      * @dev Gas spent here starts off proportional to the maximum mint batch size.
991      * It gradually moves to O(1) as tokens get transferred around over time.
992      */
993     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
994         return _unpackedOwnership(_packedOwnershipOf(tokenId));
995     }
996 
997     /**
998      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
999      */
1000     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1001         return _unpackedOwnership(_packedOwnerships[index]);
1002     }
1003 
1004     /**
1005      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1006      */
1007     function _initializeOwnershipAt(uint256 index) internal virtual {
1008         if (_packedOwnerships[index] == 0) {
1009             _packedOwnerships[index] = _packedOwnershipOf(index);
1010         }
1011     }
1012 
1013     /**
1014      * Returns the packed ownership data of `tokenId`.
1015      */
1016     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1017         uint256 curr = tokenId;
1018 
1019         unchecked {
1020             if (_startTokenId() <= curr)
1021                 if (curr < _currentIndex) {
1022                     uint256 packed = _packedOwnerships[curr];
1023                     // If not burned.
1024                     if (packed & _BITMASK_BURNED == 0) {
1025                         // Invariant:
1026                         // There will always be an initialized ownership slot
1027                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1028                         // before an unintialized ownership slot
1029                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1030                         // Hence, `curr` will not underflow.
1031                         //
1032                         // We can directly compare the packed value.
1033                         // If the address is zero, packed will be zero.
1034                         while (packed == 0) {
1035                             packed = _packedOwnerships[--curr];
1036                         }
1037                         return packed;
1038                     }
1039                 }
1040         }
1041         revert OwnerQueryForNonexistentToken();
1042     }
1043 
1044     /**
1045      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1046      */
1047     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1048         ownership.addr = address(uint160(packed));
1049         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1050         ownership.burned = packed & _BITMASK_BURNED != 0;
1051         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1052     }
1053 
1054     /**
1055      * @dev Packs ownership data into a single uint256.
1056      */
1057     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1058         assembly {
1059             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1060             owner := and(owner, _BITMASK_ADDRESS)
1061             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1062             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1063         }
1064     }
1065 
1066     /**
1067      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1068      */
1069     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1070         // For branchless setting of the `nextInitialized` flag.
1071         assembly {
1072             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1073             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1074         }
1075     }
1076 
1077     // =============================================================
1078     //                      APPROVAL OPERATIONS
1079     // =============================================================
1080 
1081     /**
1082      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1083      * The approval is cleared when the token is transferred.
1084      *
1085      * Only a single account can be approved at a time, so approving the
1086      * zero address clears previous approvals.
1087      *
1088      * Requirements:
1089      *
1090      * - The caller must own the token or be an approved operator.
1091      * - `tokenId` must exist.
1092      *
1093      * Emits an {Approval} event.
1094      */
1095     function approve(address to, uint256 tokenId) public payable virtual override {
1096         address owner = ownerOf(tokenId);
1097 
1098         if (_msgSenderERC721A() != owner)
1099             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1100                 revert ApprovalCallerNotOwnerNorApproved();
1101             }
1102 
1103         _tokenApprovals[tokenId].value = to;
1104         emit Approval(owner, to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev Returns the account approved for `tokenId` token.
1109      *
1110      * Requirements:
1111      *
1112      * - `tokenId` must exist.
1113      */
1114     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1115         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1116 
1117         return _tokenApprovals[tokenId].value;
1118     }
1119 
1120     /**
1121      * @dev Approve or remove `operator` as an operator for the caller.
1122      * Operators can call {transferFrom} or {safeTransferFrom}
1123      * for any token owned by the caller.
1124      *
1125      * Requirements:
1126      *
1127      * - The `operator` cannot be the caller.
1128      *
1129      * Emits an {ApprovalForAll} event.
1130      */
1131     function setApprovalForAll(address operator, bool approved) public virtual override {
1132         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1133         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1134     }
1135 
1136     /**
1137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1138      *
1139      * See {setApprovalForAll}.
1140      */
1141     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1142         return _operatorApprovals[owner][operator];
1143     }
1144 
1145     /**
1146      * @dev Returns whether `tokenId` exists.
1147      *
1148      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1149      *
1150      * Tokens start existing when they are minted. See {_mint}.
1151      */
1152     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1153         return
1154             _startTokenId() <= tokenId &&
1155             tokenId < _currentIndex && // If within bounds,
1156             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1157     }
1158 
1159     /**
1160      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1161      */
1162     function _isSenderApprovedOrOwner(
1163         address approvedAddress,
1164         address owner,
1165         address msgSender
1166     ) private pure returns (bool result) {
1167         assembly {
1168             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1169             owner := and(owner, _BITMASK_ADDRESS)
1170             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1171             msgSender := and(msgSender, _BITMASK_ADDRESS)
1172             // `msgSender == owner || msgSender == approvedAddress`.
1173             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1174         }
1175     }
1176 
1177     /**
1178      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1179      */
1180     function _getApprovedSlotAndAddress(uint256 tokenId)
1181         private
1182         view
1183         returns (uint256 approvedAddressSlot, address approvedAddress)
1184     {
1185         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1186         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1187         assembly {
1188             approvedAddressSlot := tokenApproval.slot
1189             approvedAddress := sload(approvedAddressSlot)
1190         }
1191     }
1192 
1193     // =============================================================
1194     //                      TRANSFER OPERATIONS
1195     // =============================================================
1196 
1197     /**
1198      * @dev Transfers `tokenId` from `from` to `to`.
1199      *
1200      * Requirements:
1201      *
1202      * - `from` cannot be the zero address.
1203      * - `to` cannot be the zero address.
1204      * - `tokenId` token must be owned by `from`.
1205      * - If the caller is not `from`, it must be approved to move this token
1206      * by either {approve} or {setApprovalForAll}.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function transferFrom(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) public payable virtual override {
1215         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1216 
1217         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1218 
1219         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1220 
1221         // The nested ifs save around 20+ gas over a compound boolean condition.
1222         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1223             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1224 
1225         if (to == address(0)) revert TransferToZeroAddress();
1226 
1227         _beforeTokenTransfers(from, to, tokenId, 1);
1228 
1229         // Clear approvals from the previous owner.
1230         assembly {
1231             if approvedAddress {
1232                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1233                 sstore(approvedAddressSlot, 0)
1234             }
1235         }
1236 
1237         // Underflow of the sender's balance is impossible because we check for
1238         // ownership above and the recipient's balance can't realistically overflow.
1239         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1240         unchecked {
1241             // We can directly increment and decrement the balances.
1242             --_packedAddressData[from]; // Updates: `balance -= 1`.
1243             ++_packedAddressData[to]; // Updates: `balance += 1`.
1244 
1245             // Updates:
1246             // - `address` to the next owner.
1247             // - `startTimestamp` to the timestamp of transfering.
1248             // - `burned` to `false`.
1249             // - `nextInitialized` to `true`.
1250             _packedOwnerships[tokenId] = _packOwnershipData(
1251                 to,
1252                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1253             );
1254 
1255             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1256             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1257                 uint256 nextTokenId = tokenId + 1;
1258                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1259                 if (_packedOwnerships[nextTokenId] == 0) {
1260                     // If the next slot is within bounds.
1261                     if (nextTokenId != _currentIndex) {
1262                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1263                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1264                     }
1265                 }
1266             }
1267         }
1268 
1269         emit Transfer(from, to, tokenId);
1270         _afterTokenTransfers(from, to, tokenId, 1);
1271     }
1272 
1273     /**
1274      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1275      */
1276     function safeTransferFrom(
1277         address from,
1278         address to,
1279         uint256 tokenId
1280     ) public payable virtual override {
1281         safeTransferFrom(from, to, tokenId, '');
1282     }
1283 
1284     /**
1285      * @dev Safely transfers `tokenId` token from `from` to `to`.
1286      *
1287      * Requirements:
1288      *
1289      * - `from` cannot be the zero address.
1290      * - `to` cannot be the zero address.
1291      * - `tokenId` token must exist and be owned by `from`.
1292      * - If the caller is not `from`, it must be approved to move this token
1293      * by either {approve} or {setApprovalForAll}.
1294      * - If `to` refers to a smart contract, it must implement
1295      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1296      *
1297      * Emits a {Transfer} event.
1298      */
1299     function safeTransferFrom(
1300         address from,
1301         address to,
1302         uint256 tokenId,
1303         bytes memory _data
1304     ) public payable virtual override {
1305         transferFrom(from, to, tokenId);
1306         if (to.code.length != 0)
1307             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1308                 revert TransferToNonERC721ReceiverImplementer();
1309             }
1310     }
1311 
1312     /**
1313      * @dev Hook that is called before a set of serially-ordered token IDs
1314      * are about to be transferred. This includes minting.
1315      * And also called before burning one token.
1316      *
1317      * `startTokenId` - the first token ID to be transferred.
1318      * `quantity` - the amount to be transferred.
1319      *
1320      * Calling conditions:
1321      *
1322      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1323      * transferred to `to`.
1324      * - When `from` is zero, `tokenId` will be minted for `to`.
1325      * - When `to` is zero, `tokenId` will be burned by `from`.
1326      * - `from` and `to` are never both zero.
1327      */
1328     function _beforeTokenTransfers(
1329         address from,
1330         address to,
1331         uint256 startTokenId,
1332         uint256 quantity
1333     ) internal virtual {}
1334 
1335     /**
1336      * @dev Hook that is called after a set of serially-ordered token IDs
1337      * have been transferred. This includes minting.
1338      * And also called after one token has been burned.
1339      *
1340      * `startTokenId` - the first token ID to be transferred.
1341      * `quantity` - the amount to be transferred.
1342      *
1343      * Calling conditions:
1344      *
1345      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1346      * transferred to `to`.
1347      * - When `from` is zero, `tokenId` has been minted for `to`.
1348      * - When `to` is zero, `tokenId` has been burned by `from`.
1349      * - `from` and `to` are never both zero.
1350      */
1351     function _afterTokenTransfers(
1352         address from,
1353         address to,
1354         uint256 startTokenId,
1355         uint256 quantity
1356     ) internal virtual {}
1357 
1358     /**
1359      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1360      *
1361      * `from` - Previous owner of the given token ID.
1362      * `to` - Target address that will receive the token.
1363      * `tokenId` - Token ID to be transferred.
1364      * `_data` - Optional data to send along with the call.
1365      *
1366      * Returns whether the call correctly returned the expected magic value.
1367      */
1368     function _checkContractOnERC721Received(
1369         address from,
1370         address to,
1371         uint256 tokenId,
1372         bytes memory _data
1373     ) private returns (bool) {
1374         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1375             bytes4 retval
1376         ) {
1377             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1378         } catch (bytes memory reason) {
1379             if (reason.length == 0) {
1380                 revert TransferToNonERC721ReceiverImplementer();
1381             } else {
1382                 assembly {
1383                     revert(add(32, reason), mload(reason))
1384                 }
1385             }
1386         }
1387     }
1388 
1389     // =============================================================
1390     //                        MINT OPERATIONS
1391     // =============================================================
1392 
1393     /**
1394      * @dev Mints `quantity` tokens and transfers them to `to`.
1395      *
1396      * Requirements:
1397      *
1398      * - `to` cannot be the zero address.
1399      * - `quantity` must be greater than 0.
1400      *
1401      * Emits a {Transfer} event for each mint.
1402      */
1403     function _mint(address to, uint256 quantity) internal virtual {
1404         uint256 startTokenId = _currentIndex;
1405         if (quantity == 0) revert MintZeroQuantity();
1406 
1407         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1408 
1409         // Overflows are incredibly unrealistic.
1410         // `balance` and `numberMinted` have a maximum limit of 2**64.
1411         // `tokenId` has a maximum limit of 2**256.
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
1430             uint256 toMasked;
1431             uint256 end = startTokenId + quantity;
1432 
1433             // Use assembly to loop and emit the `Transfer` event for gas savings.
1434             // The duplicated `log4` removes an extra check and reduces stack juggling.
1435             // The assembly, together with the surrounding Solidity code, have been
1436             // delicately arranged to nudge the compiler into producing optimized opcodes.
1437             assembly {
1438                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1439                 toMasked := and(to, _BITMASK_ADDRESS)
1440                 // Emit the `Transfer` event.
1441                 log4(
1442                     0, // Start of data (0, since no data).
1443                     0, // End of data (0, since no data).
1444                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1445                     0, // `address(0)`.
1446                     toMasked, // `to`.
1447                     startTokenId // `tokenId`.
1448                 )
1449 
1450                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1451                 // that overflows uint256 will make the loop run out of gas.
1452                 // The compiler will optimize the `iszero` away for performance.
1453                 for {
1454                     let tokenId := add(startTokenId, 1)
1455                 } iszero(eq(tokenId, end)) {
1456                     tokenId := add(tokenId, 1)
1457                 } {
1458                     // Emit the `Transfer` event. Similar to above.
1459                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1460                 }
1461             }
1462             if (toMasked == 0) revert MintToZeroAddress();
1463 
1464             _currentIndex = end;
1465         }
1466         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1467     }
1468 
1469     /**
1470      * @dev Mints `quantity` tokens and transfers them to `to`.
1471      *
1472      * This function is intended for efficient minting only during contract creation.
1473      *
1474      * It emits only one {ConsecutiveTransfer} as defined in
1475      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1476      * instead of a sequence of {Transfer} event(s).
1477      *
1478      * Calling this function outside of contract creation WILL make your contract
1479      * non-compliant with the ERC721 standard.
1480      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1481      * {ConsecutiveTransfer} event is only permissible during contract creation.
1482      *
1483      * Requirements:
1484      *
1485      * - `to` cannot be the zero address.
1486      * - `quantity` must be greater than 0.
1487      *
1488      * Emits a {ConsecutiveTransfer} event.
1489      */
1490     function _mintERC2309(address to, uint256 quantity) internal virtual {
1491         uint256 startTokenId = _currentIndex;
1492         if (to == address(0)) revert MintToZeroAddress();
1493         if (quantity == 0) revert MintZeroQuantity();
1494         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1495 
1496         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1497 
1498         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1499         unchecked {
1500             // Updates:
1501             // - `balance += quantity`.
1502             // - `numberMinted += quantity`.
1503             //
1504             // We can directly add to the `balance` and `numberMinted`.
1505             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1506 
1507             // Updates:
1508             // - `address` to the owner.
1509             // - `startTimestamp` to the timestamp of minting.
1510             // - `burned` to `false`.
1511             // - `nextInitialized` to `quantity == 1`.
1512             _packedOwnerships[startTokenId] = _packOwnershipData(
1513                 to,
1514                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1515             );
1516 
1517             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1518 
1519             _currentIndex = startTokenId + quantity;
1520         }
1521         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1522     }
1523 
1524     /**
1525      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1526      *
1527      * Requirements:
1528      *
1529      * - If `to` refers to a smart contract, it must implement
1530      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1531      * - `quantity` must be greater than 0.
1532      *
1533      * See {_mint}.
1534      *
1535      * Emits a {Transfer} event for each mint.
1536      */
1537     function _safeMint(
1538         address to,
1539         uint256 quantity,
1540         bytes memory _data
1541     ) internal virtual {
1542         _mint(to, quantity);
1543 
1544         unchecked {
1545             if (to.code.length != 0) {
1546                 uint256 end = _currentIndex;
1547                 uint256 index = end - quantity;
1548                 do {
1549                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1550                         revert TransferToNonERC721ReceiverImplementer();
1551                     }
1552                 } while (index < end);
1553                 // Reentrancy protection.
1554                 if (_currentIndex != end) revert();
1555             }
1556         }
1557     }
1558 
1559     /**
1560      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1561      */
1562     function _safeMint(address to, uint256 quantity) internal virtual {
1563         _safeMint(to, quantity, '');
1564     }
1565 
1566     // =============================================================
1567     //                        BURN OPERATIONS
1568     // =============================================================
1569 
1570     /**
1571      * @dev Equivalent to `_burn(tokenId, false)`.
1572      */
1573     function _burn(uint256 tokenId) internal virtual {
1574         _burn(tokenId, false);
1575     }
1576 
1577     /**
1578      * @dev Destroys `tokenId`.
1579      * The approval is cleared when the token is burned.
1580      *
1581      * Requirements:
1582      *
1583      * - `tokenId` must exist.
1584      *
1585      * Emits a {Transfer} event.
1586      */
1587     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1588         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1589 
1590         address from = address(uint160(prevOwnershipPacked));
1591 
1592         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1593 
1594         if (approvalCheck) {
1595             // The nested ifs save around 20+ gas over a compound boolean condition.
1596             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1597                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1598         }
1599 
1600         _beforeTokenTransfers(from, address(0), tokenId, 1);
1601 
1602         // Clear approvals from the previous owner.
1603         assembly {
1604             if approvedAddress {
1605                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1606                 sstore(approvedAddressSlot, 0)
1607             }
1608         }
1609 
1610         // Underflow of the sender's balance is impossible because we check for
1611         // ownership above and the recipient's balance can't realistically overflow.
1612         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1613         unchecked {
1614             // Updates:
1615             // - `balance -= 1`.
1616             // - `numberBurned += 1`.
1617             //
1618             // We can directly decrement the balance, and increment the number burned.
1619             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1620             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1621 
1622             // Updates:
1623             // - `address` to the last owner.
1624             // - `startTimestamp` to the timestamp of burning.
1625             // - `burned` to `true`.
1626             // - `nextInitialized` to `true`.
1627             _packedOwnerships[tokenId] = _packOwnershipData(
1628                 from,
1629                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1630             );
1631 
1632             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1633             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1634                 uint256 nextTokenId = tokenId + 1;
1635                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1636                 if (_packedOwnerships[nextTokenId] == 0) {
1637                     // If the next slot is within bounds.
1638                     if (nextTokenId != _currentIndex) {
1639                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1640                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1641                     }
1642                 }
1643             }
1644         }
1645 
1646         emit Transfer(from, address(0), tokenId);
1647         _afterTokenTransfers(from, address(0), tokenId, 1);
1648 
1649         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1650         unchecked {
1651             _burnCounter++;
1652         }
1653     }
1654 
1655     // =============================================================
1656     //                     EXTRA DATA OPERATIONS
1657     // =============================================================
1658 
1659     /**
1660      * @dev Directly sets the extra data for the ownership data `index`.
1661      */
1662     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1663         uint256 packed = _packedOwnerships[index];
1664         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1665         uint256 extraDataCasted;
1666         // Cast `extraData` with assembly to avoid redundant masking.
1667         assembly {
1668             extraDataCasted := extraData
1669         }
1670         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1671         _packedOwnerships[index] = packed;
1672     }
1673 
1674     /**
1675      * @dev Called during each token transfer to set the 24bit `extraData` field.
1676      * Intended to be overridden by the cosumer contract.
1677      *
1678      * `previousExtraData` - the value of `extraData` before transfer.
1679      *
1680      * Calling conditions:
1681      *
1682      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1683      * transferred to `to`.
1684      * - When `from` is zero, `tokenId` will be minted for `to`.
1685      * - When `to` is zero, `tokenId` will be burned by `from`.
1686      * - `from` and `to` are never both zero.
1687      */
1688     function _extraData(
1689         address from,
1690         address to,
1691         uint24 previousExtraData
1692     ) internal view virtual returns (uint24) {}
1693 
1694     /**
1695      * @dev Returns the next extra data for the packed ownership data.
1696      * The returned result is shifted into position.
1697      */
1698     function _nextExtraData(
1699         address from,
1700         address to,
1701         uint256 prevOwnershipPacked
1702     ) private view returns (uint256) {
1703         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1704         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1705     }
1706 
1707     // =============================================================
1708     //                       OTHER OPERATIONS
1709     // =============================================================
1710 
1711     /**
1712      * @dev Returns the message sender (defaults to `msg.sender`).
1713      *
1714      * If you are writing GSN compatible contracts, you need to override this function.
1715      */
1716     function _msgSenderERC721A() internal view virtual returns (address) {
1717         return msg.sender;
1718     }
1719 
1720     /**
1721      * @dev Converts a uint256 to its ASCII string decimal representation.
1722      */
1723     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1724         assembly {
1725             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1726             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1727             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1728             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1729             let m := add(mload(0x40), 0xa0)
1730             // Update the free memory pointer to allocate.
1731             mstore(0x40, m)
1732             // Assign the `str` to the end.
1733             str := sub(m, 0x20)
1734             // Zeroize the slot after the string.
1735             mstore(str, 0)
1736 
1737             // Cache the end of the memory to calculate the length later.
1738             let end := str
1739 
1740             // We write the string from rightmost digit to leftmost digit.
1741             // The following is essentially a do-while loop that also handles the zero case.
1742             // prettier-ignore
1743             for { let temp := value } 1 {} {
1744                 str := sub(str, 1)
1745                 // Write the character to the pointer.
1746                 // The ASCII index of the '0' character is 48.
1747                 mstore8(str, add(48, mod(temp, 10)))
1748                 // Keep dividing `temp` until zero.
1749                 temp := div(temp, 10)
1750                 // prettier-ignore
1751                 if iszero(temp) { break }
1752             }
1753 
1754             let length := sub(end, str)
1755             // Move the pointer 32 bytes leftwards to make room for the length.
1756             str := sub(str, 0x20)
1757             // Store the length.
1758             mstore(str, length)
1759         }
1760     }
1761 }
1762 
1763 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1764 
1765 
1766 // ERC721A Contracts v4.2.3
1767 // Creator: Chiru Labs
1768 
1769 pragma solidity ^0.8.4;
1770 
1771 
1772 
1773 /**
1774  * @title ERC721ABurnable.
1775  *
1776  * @dev ERC721A token that can be irreversibly burned (destroyed).
1777  */
1778 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1779     /**
1780      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1781      *
1782      * Requirements:
1783      *
1784      * - The caller must own `tokenId` or be an approved operator.
1785      */
1786     function burn(uint256 tokenId) public virtual override {
1787         _burn(tokenId, true);
1788     }
1789 }
1790 
1791 // File: undefined/deadgays.sol
1792 
1793 
1794 pragma solidity ^0.8.17;
1795 
1796 
1797 
1798 
1799 
1800 contract DeadGays is ERC721A, Ownable, ERC721ABurnable, DefaultOperatorFilterer {
1801     bool public isSale = false;
1802     bool public isBurn = false;
1803 
1804     uint256 public max_supply = 4444;
1805     uint256 public price = 0.00369 ether;
1806     uint256 public per_wallet = 10;
1807     uint256 public per_tx = 10;
1808     uint256 public free_per_wallet = 1;
1809 
1810     // mapping(address => uint) public burntBy;
1811     string private baseUri;
1812 
1813     constructor(string memory _baseUri) ERC721A("DeadGays", "DEGAYS") {
1814         baseUri = _baseUri;
1815         // _mint(msg.sender, 1);
1816     }
1817 
1818     function _baseURI() internal view override returns (string memory) {
1819         return baseUri;
1820     }
1821 
1822     function flipSaleState() external onlyOwner {
1823         isSale = !isSale;
1824     }
1825 
1826     function flipBurnState() external onlyOwner {
1827         isBurn = !isBurn;
1828     }
1829 
1830     function withdrawAll() external onlyOwner {
1831         uint256 balance = address(this).balance;
1832         payable(msg.sender).transfer(balance);
1833     }
1834 
1835     function mint(uint256 quantity) external payable {
1836         require(isSale, "Sale has not started yet");
1837         require(msg.sender == tx.origin, "No contracts allowed");
1838 
1839         require(quantity <= per_tx, "Transaction mint limit reached.");
1840         require(balanceOf(msg.sender) + quantity <= per_wallet, "Mint limit reached for this wallet");
1841         require(totalSupply() + quantity <= max_supply, "Not enough NFTs left to mint");
1842 
1843         if (balanceOf(msg.sender) == 0) {
1844             require(price * (quantity - free_per_wallet) <= msg.value, "Insufficient funds sent");
1845         } else 
1846             {require(price * quantity < msg.value, "Insufficient funds sent");
1847         }
1848         
1849         _mint(msg.sender, quantity);
1850     }
1851 
1852     function mintForAddress(uint256 amount, address receiver) external onlyOwner {
1853         require(totalSupply() + amount <= max_supply,"Not enough NFTs left to mint");
1854         _mint(receiver, amount);
1855     }
1856 
1857     function burn(uint256 tokenId) public virtual override {
1858         require(isBurn, "Burn is not enabled");
1859         // burntBy[msg.sender] += 1;
1860         _burn(tokenId, true);
1861     }
1862 
1863     function burnTokens(uint256[] calldata tokenIds) public {
1864         require(isBurn, "Burn is not enabled");
1865         uint256 amount = tokenIds.length;
1866 
1867         for (uint256 i = 0; i < amount;) {
1868             _burn(tokenIds[i]);
1869             unchecked { ++i; }
1870         }
1871         // burntBy[msg.sender] += amount;
1872     }
1873 
1874     function _startTokenId() internal view virtual override returns (uint256) {
1875         return 1;
1876     }
1877 
1878     function setPrice(uint256 _price) external onlyOwner {
1879         price = _price;
1880     }
1881 
1882     function setPerWallet(uint256 _per) external onlyOwner {
1883         per_wallet = _per;
1884     }
1885 
1886     function setFreePerWallet(uint256 _per) external onlyOwner {
1887         free_per_wallet = _per;
1888     }
1889 
1890     function setBaseURI(string memory _baseUri) external onlyOwner {
1891         baseUri = _baseUri;
1892     }
1893 
1894     ////////////////////////
1895     //operator
1896     ////////////////////////
1897 
1898     function setApprovalForAll(
1899         address operator,
1900         bool approved
1901     ) public override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
1902         super.setApprovalForAll(operator, approved);
1903     }
1904 
1905     function approve(
1906         address operator,
1907         uint256 tokenId
1908     ) public payable override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
1909         super.approve(operator, tokenId);
1910     }
1911 
1912     function transferFrom(
1913         address from,
1914         address to,
1915         uint256 tokenId
1916     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
1917         super.transferFrom(from, to, tokenId);
1918     }
1919 
1920     function safeTransferFrom(
1921         address from,
1922         address to,
1923         uint256 tokenId
1924     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
1925         super.safeTransferFrom(from, to, tokenId);
1926     }
1927 
1928     function safeTransferFrom(
1929         address from,
1930         address to,
1931         uint256 tokenId,
1932         bytes memory data
1933     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
1934         super.safeTransferFrom(from, to, tokenId, data);
1935     }
1936 }