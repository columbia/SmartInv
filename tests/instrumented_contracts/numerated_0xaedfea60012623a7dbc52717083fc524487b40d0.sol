1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 
40 /**
41  * @dev Implementation of the {IERC165} interface.
42  *
43  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
44  * for the additional interface id that will be supported. For example:
45  *
46  * ```solidity
47  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
48  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
49  * }
50  * ```
51  *
52  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
53  */
54 abstract contract ERC165 is IERC165 {
55     /**
56      * @dev See {IERC165-supportsInterface}.
57      */
58     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
59         return interfaceId == type(IERC165).interfaceId;
60     }
61 }
62 
63 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
64 
65 
66 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
67 
68 pragma solidity ^0.8.0;
69 
70 
71 /**
72  * @dev Interface for the NFT Royalty Standard.
73  *
74  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
75  * support for royalty payments across all NFT marketplaces and ecosystem participants.
76  *
77  * _Available since v4.5._
78  */
79 interface IERC2981 is IERC165 {
80     /**
81      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
82      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
83      */
84     function royaltyInfo(uint256 tokenId, uint256 salePrice)
85         external
86         view
87         returns (address receiver, uint256 royaltyAmount);
88 }
89 
90 // File: @openzeppelin/contracts/token/common/ERC2981.sol
91 
92 
93 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 
98 
99 /**
100  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
101  *
102  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
103  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
104  *
105  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
106  * fee is specified in basis points by default.
107  *
108  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
109  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
110  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
111  *
112  * _Available since v4.5._
113  */
114 abstract contract ERC2981 is IERC2981, ERC165 {
115     struct RoyaltyInfo {
116         address receiver;
117         uint96 royaltyFraction;
118     }
119 
120     RoyaltyInfo private _defaultRoyaltyInfo;
121     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
122 
123     /**
124      * @dev See {IERC165-supportsInterface}.
125      */
126     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
127         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
128     }
129 
130     /**
131      * @inheritdoc IERC2981
132      */
133     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
134         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
135 
136         if (royalty.receiver == address(0)) {
137             royalty = _defaultRoyaltyInfo;
138         }
139 
140         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
141 
142         return (royalty.receiver, royaltyAmount);
143     }
144 
145     /**
146      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
147      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
148      * override.
149      */
150     function _feeDenominator() internal pure virtual returns (uint96) {
151         return 10000;
152     }
153 
154     /**
155      * @dev Sets the royalty information that all ids in this contract will default to.
156      *
157      * Requirements:
158      *
159      * - `receiver` cannot be the zero address.
160      * - `feeNumerator` cannot be greater than the fee denominator.
161      */
162     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
163         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
164         require(receiver != address(0), "ERC2981: invalid receiver");
165 
166         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
167     }
168 
169     /**
170      * @dev Removes default royalty information.
171      */
172     function _deleteDefaultRoyalty() internal virtual {
173         delete _defaultRoyaltyInfo;
174     }
175 
176     /**
177      * @dev Sets the royalty information for a specific token id, overriding the global default.
178      *
179      * Requirements:
180      *
181      * - `receiver` cannot be the zero address.
182      * - `feeNumerator` cannot be greater than the fee denominator.
183      */
184     function _setTokenRoyalty(
185         uint256 tokenId,
186         address receiver,
187         uint96 feeNumerator
188     ) internal virtual {
189         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
190         require(receiver != address(0), "ERC2981: Invalid parameters");
191 
192         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
193     }
194 
195     /**
196      * @dev Resets royalty information for the token id back to the global default.
197      */
198     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
199         delete _tokenRoyaltyInfo[tokenId];
200     }
201 }
202 
203 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
204 
205 
206 pragma solidity ^0.8.13;
207 
208 interface IOperatorFilterRegistry {
209     /**
210      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
211      *         true if supplied registrant address is not registered.
212      */
213     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
214 
215     /**
216      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
217      */
218     function register(address registrant) external;
219 
220     /**
221      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
222      */
223     function registerAndSubscribe(address registrant, address subscription) external;
224 
225     /**
226      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
227      *         address without subscribing.
228      */
229     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
230 
231     /**
232      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
233      *         Note that this does not remove any filtered addresses or codeHashes.
234      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
235      */
236     function unregister(address addr) external;
237 
238     /**
239      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
240      */
241     function updateOperator(address registrant, address operator, bool filtered) external;
242 
243     /**
244      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
245      */
246     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
247 
248     /**
249      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
250      */
251     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
252 
253     /**
254      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
255      */
256     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
257 
258     /**
259      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
260      *         subscription if present.
261      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
262      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
263      *         used.
264      */
265     function subscribe(address registrant, address registrantToSubscribe) external;
266 
267     /**
268      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
269      */
270     function unsubscribe(address registrant, bool copyExistingEntries) external;
271 
272     /**
273      * @notice Get the subscription address of a given registrant, if any.
274      */
275     function subscriptionOf(address addr) external returns (address registrant);
276 
277     /**
278      * @notice Get the set of addresses subscribed to a given registrant.
279      *         Note that order is not guaranteed as updates are made.
280      */
281     function subscribers(address registrant) external returns (address[] memory);
282 
283     /**
284      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
285      *         Note that order is not guaranteed as updates are made.
286      */
287     function subscriberAt(address registrant, uint256 index) external returns (address);
288 
289     /**
290      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
291      */
292     function copyEntriesOf(address registrant, address registrantToCopy) external;
293 
294     /**
295      * @notice Returns true if operator is filtered by a given address or its subscription.
296      */
297     function isOperatorFiltered(address registrant, address operator) external returns (bool);
298 
299     /**
300      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
301      */
302     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
303 
304     /**
305      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
306      */
307     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
308 
309     /**
310      * @notice Returns a list of filtered operators for a given address or its subscription.
311      */
312     function filteredOperators(address addr) external returns (address[] memory);
313 
314     /**
315      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
316      *         Note that order is not guaranteed as updates are made.
317      */
318     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
319 
320     /**
321      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
322      *         its subscription.
323      *         Note that order is not guaranteed as updates are made.
324      */
325     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
326 
327     /**
328      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
329      *         its subscription.
330      *         Note that order is not guaranteed as updates are made.
331      */
332     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
333 
334     /**
335      * @notice Returns true if an address has registered
336      */
337     function isRegistered(address addr) external returns (bool);
338 
339     /**
340      * @dev Convenience method to compute the code hash of an arbitrary contract
341      */
342     function codeHashOf(address addr) external returns (bytes32);
343 }
344 
345 // File: @openzeppelin/contracts/utils/Context.sol
346 
347 
348 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @dev Provides information about the current execution context, including the
354  * sender of the transaction and its data. While these are generally available
355  * via msg.sender and msg.data, they should not be accessed in such a direct
356  * manner, since when dealing with meta-transactions the account sending and
357  * paying for execution may not be the actual sender (as far as an application
358  * is concerned).
359  *
360  * This contract is only required for intermediate, library-like contracts.
361  */
362 abstract contract Context {
363     function _msgSender() internal view virtual returns (address) {
364         return msg.sender;
365     }
366 
367     function _msgData() internal view virtual returns (bytes calldata) {
368         return msg.data;
369     }
370 }
371 
372 // File: @openzeppelin/contracts/access/Ownable.sol
373 
374 
375 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 
380 /**
381  * @dev Contract module which provides a basic access control mechanism, where
382  * there is an account (an owner) that can be granted exclusive access to
383  * specific functions.
384  *
385  * By default, the owner account will be the one that deploys the contract. This
386  * can later be changed with {transferOwnership}.
387  *
388  * This module is used through inheritance. It will make available the modifier
389  * `onlyOwner`, which can be applied to your functions to restrict their use to
390  * the owner.
391  */
392 abstract contract Ownable is Context {
393     address private _owner;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398      * @dev Initializes the contract setting the deployer as the initial owner.
399      */
400     constructor() {
401         _transferOwnership(_msgSender());
402     }
403 
404     /**
405      * @dev Throws if called by any account other than the owner.
406      */
407     modifier onlyOwner() {
408         _checkOwner();
409         _;
410     }
411 
412     /**
413      * @dev Returns the address of the current owner.
414      */
415     function owner() public view virtual returns (address) {
416         return _owner;
417     }
418 
419     /**
420      * @dev Throws if the sender is not the owner.
421      */
422     function _checkOwner() internal view virtual {
423         require(owner() == _msgSender(), "Ownable: caller is not the owner");
424     }
425 
426     /**
427      * @dev Leaves the contract without owner. It will not be possible to call
428      * `onlyOwner` functions anymore. Can only be called by the current owner.
429      *
430      * NOTE: Renouncing ownership will leave the contract without an owner,
431      * thereby removing any functionality that is only available to the owner.
432      */
433     function renounceOwnership() public virtual onlyOwner {
434         _transferOwnership(address(0));
435     }
436 
437     /**
438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
439      * Can only be called by the current owner.
440      */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         _transferOwnership(newOwner);
444     }
445 
446     /**
447      * @dev Transfers ownership of the contract to a new account (`newOwner`).
448      * Internal function without access restriction.
449      */
450     function _transferOwnership(address newOwner) internal virtual {
451         address oldOwner = _owner;
452         _owner = newOwner;
453         emit OwnershipTransferred(oldOwner, newOwner);
454     }
455 }
456 
457 // File: contracts/contract/MutableOperatorFilterer.sol
458 
459 
460 
461 pragma solidity ^0.8.13;
462 
463 
464 
465 /**
466  * @title  MutableOperatorFilterer
467  * @author shinji at shinji.xyz
468  * @notice Allows the contract to change the registrant contract as well as the registrant address it listens to.
469  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
470  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
471  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
472  *
473  *         The contract will need to be registered with the registry once it is deployed in
474  *         order for the modifier to filter addresses.
475  */
476 
477 contract MutableOperatorFilterer is Ownable {
478     /// @dev Emitted when an operator is not allowed.
479     error OperatorNotAllowed(address operator);
480 
481     // The contract with the filtering implementation
482     address public OPERATOR_FILTER_REGISTRY_ADDRESS;
483 
484     // The agent the main contract listens to for filtering operators
485     address public FILTER_REGISTRANT;
486 
487     IOperatorFilterRegistry public OPERATOR_FILTER_REGISTRY;
488 
489     constructor(
490         address operatorFilterRegistryAddress,
491         address operatorFilterRegistrant
492     ) {
493         OPERATOR_FILTER_REGISTRY_ADDRESS = operatorFilterRegistryAddress;
494         OPERATOR_FILTER_REGISTRY = IOperatorFilterRegistry(
495             OPERATOR_FILTER_REGISTRY_ADDRESS
496         );
497         FILTER_REGISTRANT = operatorFilterRegistrant;
498     }
499 
500     /**
501      * @notice Allows the owner to set a new registrant contract.
502      */
503     function setOperatorFilterRegistry(
504         address registryAddress
505     ) external onlyOwner {
506         OPERATOR_FILTER_REGISTRY_ADDRESS = registryAddress;
507         OPERATOR_FILTER_REGISTRY = IOperatorFilterRegistry(
508             OPERATOR_FILTER_REGISTRY_ADDRESS
509         );
510     }
511 
512     /**
513      * @notice Allows the owner to set a new registrant address.
514      */
515     function setFilterRegistrant(address newRegistrant) external onlyOwner {
516         FILTER_REGISTRANT = newRegistrant;
517     }
518 
519     /**
520      * @dev A helper function to check if an operator is allowed.
521      */
522     modifier onlyAllowedOperator(address from) virtual {
523         // Allow spending tokens from addresses with balance
524         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
525         // from an EOA.
526         if (from != msg.sender) {
527             _checkFilterOperator(msg.sender);
528         }
529         _;
530     }
531 
532     /**
533      * @dev A helper function to check if an operator approval is allowed.
534      */
535     modifier onlyAllowedOperatorApproval(address operator) virtual {
536         _checkFilterOperator(operator);
537         _;
538     }
539 
540     /**
541      * @dev A helper function to check if an operator is allowed.
542      */
543     function _checkFilterOperator(address operator) internal view virtual {
544         // Check registry code length to facilitate testing in environments without a deployed registry.
545         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
546             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
547             // may specify their own OperatorFilterRegistry implementations, which may behave differently
548             if (
549                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
550                     FILTER_REGISTRANT,
551                     operator
552                 )
553             ) {
554                 revert OperatorNotAllowed(operator);
555             }
556         }
557     }
558 }
559 
560 // File: erc721a/contracts/IERC721A.sol
561 
562 
563 // ERC721A Contracts v4.2.3
564 // Creator: Chiru Labs
565 
566 pragma solidity ^0.8.4;
567 
568 /**
569  * @dev Interface of ERC721A.
570  */
571 interface IERC721A {
572     /**
573      * The caller must own the token or be an approved operator.
574      */
575     error ApprovalCallerNotOwnerNorApproved();
576 
577     /**
578      * The token does not exist.
579      */
580     error ApprovalQueryForNonexistentToken();
581 
582     /**
583      * Cannot query the balance for the zero address.
584      */
585     error BalanceQueryForZeroAddress();
586 
587     /**
588      * Cannot mint to the zero address.
589      */
590     error MintToZeroAddress();
591 
592     /**
593      * The quantity of tokens minted must be more than zero.
594      */
595     error MintZeroQuantity();
596 
597     /**
598      * The token does not exist.
599      */
600     error OwnerQueryForNonexistentToken();
601 
602     /**
603      * The caller must own the token or be an approved operator.
604      */
605     error TransferCallerNotOwnerNorApproved();
606 
607     /**
608      * The token must be owned by `from`.
609      */
610     error TransferFromIncorrectOwner();
611 
612     /**
613      * Cannot safely transfer to a contract that does not implement the
614      * ERC721Receiver interface.
615      */
616     error TransferToNonERC721ReceiverImplementer();
617 
618     /**
619      * Cannot transfer to the zero address.
620      */
621     error TransferToZeroAddress();
622 
623     /**
624      * The token does not exist.
625      */
626     error URIQueryForNonexistentToken();
627 
628     /**
629      * The `quantity` minted with ERC2309 exceeds the safety limit.
630      */
631     error MintERC2309QuantityExceedsLimit();
632 
633     /**
634      * The `extraData` cannot be set on an unintialized ownership slot.
635      */
636     error OwnershipNotInitializedForExtraData();
637 
638     // =============================================================
639     //                            STRUCTS
640     // =============================================================
641 
642     struct TokenOwnership {
643         // The address of the owner.
644         address addr;
645         // Stores the start time of ownership with minimal overhead for tokenomics.
646         uint64 startTimestamp;
647         // Whether the token has been burned.
648         bool burned;
649         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
650         uint24 extraData;
651     }
652 
653     // =============================================================
654     //                         TOKEN COUNTERS
655     // =============================================================
656 
657     /**
658      * @dev Returns the total number of tokens in existence.
659      * Burned tokens will reduce the count.
660      * To get the total number of tokens minted, please see {_totalMinted}.
661      */
662     function totalSupply() external view returns (uint256);
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
676     function supportsInterface(bytes4 interfaceId) external view returns (bool);
677 
678     // =============================================================
679     //                            IERC721
680     // =============================================================
681 
682     /**
683      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
684      */
685     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
686 
687     /**
688      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
689      */
690     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
691 
692     /**
693      * @dev Emitted when `owner` enables or disables
694      * (`approved`) `operator` to manage all of its assets.
695      */
696     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
697 
698     /**
699      * @dev Returns the number of tokens in `owner`'s account.
700      */
701     function balanceOf(address owner) external view returns (uint256 balance);
702 
703     /**
704      * @dev Returns the owner of the `tokenId` token.
705      *
706      * Requirements:
707      *
708      * - `tokenId` must exist.
709      */
710     function ownerOf(uint256 tokenId) external view returns (address owner);
711 
712     /**
713      * @dev Safely transfers `tokenId` token from `from` to `to`,
714      * checking first that contract recipients are aware of the ERC721 protocol
715      * to prevent tokens from being forever locked.
716      *
717      * Requirements:
718      *
719      * - `from` cannot be the zero address.
720      * - `to` cannot be the zero address.
721      * - `tokenId` token must exist and be owned by `from`.
722      * - If the caller is not `from`, it must be have been allowed to move
723      * this token by either {approve} or {setApprovalForAll}.
724      * - If `to` refers to a smart contract, it must implement
725      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
726      *
727      * Emits a {Transfer} event.
728      */
729     function safeTransferFrom(
730         address from,
731         address to,
732         uint256 tokenId,
733         bytes calldata data
734     ) external payable;
735 
736     /**
737      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) external payable;
744 
745     /**
746      * @dev Transfers `tokenId` from `from` to `to`.
747      *
748      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
749      * whenever possible.
750      *
751      * Requirements:
752      *
753      * - `from` cannot be the zero address.
754      * - `to` cannot be the zero address.
755      * - `tokenId` token must be owned by `from`.
756      * - If the caller is not `from`, it must be approved to move this token
757      * by either {approve} or {setApprovalForAll}.
758      *
759      * Emits a {Transfer} event.
760      */
761     function transferFrom(
762         address from,
763         address to,
764         uint256 tokenId
765     ) external payable;
766 
767     /**
768      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
769      * The approval is cleared when the token is transferred.
770      *
771      * Only a single account can be approved at a time, so approving the
772      * zero address clears previous approvals.
773      *
774      * Requirements:
775      *
776      * - The caller must own the token or be an approved operator.
777      * - `tokenId` must exist.
778      *
779      * Emits an {Approval} event.
780      */
781     function approve(address to, uint256 tokenId) external payable;
782 
783     /**
784      * @dev Approve or remove `operator` as an operator for the caller.
785      * Operators can call {transferFrom} or {safeTransferFrom}
786      * for any token owned by the caller.
787      *
788      * Requirements:
789      *
790      * - The `operator` cannot be the caller.
791      *
792      * Emits an {ApprovalForAll} event.
793      */
794     function setApprovalForAll(address operator, bool _approved) external;
795 
796     /**
797      * @dev Returns the account approved for `tokenId` token.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      */
803     function getApproved(uint256 tokenId) external view returns (address operator);
804 
805     /**
806      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
807      *
808      * See {setApprovalForAll}.
809      */
810     function isApprovedForAll(address owner, address operator) external view returns (bool);
811 
812     // =============================================================
813     //                        IERC721Metadata
814     // =============================================================
815 
816     /**
817      * @dev Returns the token collection name.
818      */
819     function name() external view returns (string memory);
820 
821     /**
822      * @dev Returns the token collection symbol.
823      */
824     function symbol() external view returns (string memory);
825 
826     /**
827      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
828      */
829     function tokenURI(uint256 tokenId) external view returns (string memory);
830 
831     // =============================================================
832     //                           IERC2309
833     // =============================================================
834 
835     /**
836      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
837      * (inclusive) is transferred from `from` to `to`, as defined in the
838      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
839      *
840      * See {_mintERC2309} for more details.
841      */
842     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
843 }
844 
845 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
846 
847 
848 // ERC721A Contracts v4.2.3
849 // Creator: Chiru Labs
850 
851 pragma solidity ^0.8.4;
852 
853 
854 /**
855  * @dev Interface of ERC721AQueryable.
856  */
857 interface IERC721AQueryable is IERC721A {
858     /**
859      * Invalid query range (`start` >= `stop`).
860      */
861     error InvalidQueryRange();
862 
863     /**
864      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
865      *
866      * If the `tokenId` is out of bounds:
867      *
868      * - `addr = address(0)`
869      * - `startTimestamp = 0`
870      * - `burned = false`
871      * - `extraData = 0`
872      *
873      * If the `tokenId` is burned:
874      *
875      * - `addr = <Address of owner before token was burned>`
876      * - `startTimestamp = <Timestamp when token was burned>`
877      * - `burned = true`
878      * - `extraData = <Extra data when token was burned>`
879      *
880      * Otherwise:
881      *
882      * - `addr = <Address of owner>`
883      * - `startTimestamp = <Timestamp of start of ownership>`
884      * - `burned = false`
885      * - `extraData = <Extra data at start of ownership>`
886      */
887     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
888 
889     /**
890      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
891      * See {ERC721AQueryable-explicitOwnershipOf}
892      */
893     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
894 
895     /**
896      * @dev Returns an array of token IDs owned by `owner`,
897      * in the range [`start`, `stop`)
898      * (i.e. `start <= tokenId < stop`).
899      *
900      * This function allows for tokens to be queried if the collection
901      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
902      *
903      * Requirements:
904      *
905      * - `start < stop`
906      */
907     function tokensOfOwnerIn(
908         address owner,
909         uint256 start,
910         uint256 stop
911     ) external view returns (uint256[] memory);
912 
913     /**
914      * @dev Returns an array of token IDs owned by `owner`.
915      *
916      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
917      * It is meant to be called off-chain.
918      *
919      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
920      * multiple smaller scans if the collection is large enough to cause
921      * an out-of-gas error (10K collections should be fine).
922      */
923     function tokensOfOwner(address owner) external view returns (uint256[] memory);
924 }
925 
926 // File: erc721a/contracts/ERC721A.sol
927 
928 
929 // ERC721A Contracts v4.2.3
930 // Creator: Chiru Labs
931 
932 pragma solidity ^0.8.4;
933 
934 
935 /**
936  * @dev Interface of ERC721 token receiver.
937  */
938 interface ERC721A__IERC721Receiver {
939     function onERC721Received(
940         address operator,
941         address from,
942         uint256 tokenId,
943         bytes calldata data
944     ) external returns (bytes4);
945 }
946 
947 /**
948  * @title ERC721A
949  *
950  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
951  * Non-Fungible Token Standard, including the Metadata extension.
952  * Optimized for lower gas during batch mints.
953  *
954  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
955  * starting from `_startTokenId()`.
956  *
957  * Assumptions:
958  *
959  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
960  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
961  */
962 contract ERC721A is IERC721A {
963     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
964     struct TokenApprovalRef {
965         address value;
966     }
967 
968     // =============================================================
969     //                           CONSTANTS
970     // =============================================================
971 
972     // Mask of an entry in packed address data.
973     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
974 
975     // The bit position of `numberMinted` in packed address data.
976     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
977 
978     // The bit position of `numberBurned` in packed address data.
979     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
980 
981     // The bit position of `aux` in packed address data.
982     uint256 private constant _BITPOS_AUX = 192;
983 
984     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
985     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
986 
987     // The bit position of `startTimestamp` in packed ownership.
988     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
989 
990     // The bit mask of the `burned` bit in packed ownership.
991     uint256 private constant _BITMASK_BURNED = 1 << 224;
992 
993     // The bit position of the `nextInitialized` bit in packed ownership.
994     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
995 
996     // The bit mask of the `nextInitialized` bit in packed ownership.
997     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
998 
999     // The bit position of `extraData` in packed ownership.
1000     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1001 
1002     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1003     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1004 
1005     // The mask of the lower 160 bits for addresses.
1006     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1007 
1008     // The maximum `quantity` that can be minted with {_mintERC2309}.
1009     // This limit is to prevent overflows on the address data entries.
1010     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1011     // is required to cause an overflow, which is unrealistic.
1012     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1013 
1014     // The `Transfer` event signature is given by:
1015     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1016     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1017         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1018 
1019     // =============================================================
1020     //                            STORAGE
1021     // =============================================================
1022 
1023     // The next token ID to be minted.
1024     uint256 private _currentIndex;
1025 
1026     // The number of tokens burned.
1027     uint256 private _burnCounter;
1028 
1029     // Token name
1030     string private _name;
1031 
1032     // Token symbol
1033     string private _symbol;
1034 
1035     // Mapping from token ID to ownership details
1036     // An empty struct value does not necessarily mean the token is unowned.
1037     // See {_packedOwnershipOf} implementation for details.
1038     //
1039     // Bits Layout:
1040     // - [0..159]   `addr`
1041     // - [160..223] `startTimestamp`
1042     // - [224]      `burned`
1043     // - [225]      `nextInitialized`
1044     // - [232..255] `extraData`
1045     mapping(uint256 => uint256) private _packedOwnerships;
1046 
1047     // Mapping owner address to address data.
1048     //
1049     // Bits Layout:
1050     // - [0..63]    `balance`
1051     // - [64..127]  `numberMinted`
1052     // - [128..191] `numberBurned`
1053     // - [192..255] `aux`
1054     mapping(address => uint256) private _packedAddressData;
1055 
1056     // Mapping from token ID to approved address.
1057     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1058 
1059     // Mapping from owner to operator approvals
1060     mapping(address => mapping(address => bool)) private _operatorApprovals;
1061 
1062     // =============================================================
1063     //                          CONSTRUCTOR
1064     // =============================================================
1065 
1066     constructor(string memory name_, string memory symbol_) {
1067         _name = name_;
1068         _symbol = symbol_;
1069         _currentIndex = _startTokenId();
1070     }
1071 
1072     // =============================================================
1073     //                   TOKEN COUNTING OPERATIONS
1074     // =============================================================
1075 
1076     /**
1077      * @dev Returns the starting token ID.
1078      * To change the starting token ID, please override this function.
1079      */
1080     function _startTokenId() internal view virtual returns (uint256) {
1081         return 0;
1082     }
1083 
1084     /**
1085      * @dev Returns the next token ID to be minted.
1086      */
1087     function _nextTokenId() internal view virtual returns (uint256) {
1088         return _currentIndex;
1089     }
1090 
1091     /**
1092      * @dev Returns the total number of tokens in existence.
1093      * Burned tokens will reduce the count.
1094      * To get the total number of tokens minted, please see {_totalMinted}.
1095      */
1096     function totalSupply() public view virtual override returns (uint256) {
1097         // Counter underflow is impossible as _burnCounter cannot be incremented
1098         // more than `_currentIndex - _startTokenId()` times.
1099         unchecked {
1100             return _currentIndex - _burnCounter - _startTokenId();
1101         }
1102     }
1103 
1104     /**
1105      * @dev Returns the total amount of tokens minted in the contract.
1106      */
1107     function _totalMinted() internal view virtual returns (uint256) {
1108         // Counter underflow is impossible as `_currentIndex` does not decrement,
1109         // and it is initialized to `_startTokenId()`.
1110         unchecked {
1111             return _currentIndex - _startTokenId();
1112         }
1113     }
1114 
1115     /**
1116      * @dev Returns the total number of tokens burned.
1117      */
1118     function _totalBurned() internal view virtual returns (uint256) {
1119         return _burnCounter;
1120     }
1121 
1122     // =============================================================
1123     //                    ADDRESS DATA OPERATIONS
1124     // =============================================================
1125 
1126     /**
1127      * @dev Returns the number of tokens in `owner`'s account.
1128      */
1129     function balanceOf(address owner) public view virtual override returns (uint256) {
1130         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1131         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1132     }
1133 
1134     /**
1135      * Returns the number of tokens minted by `owner`.
1136      */
1137     function _numberMinted(address owner) internal view returns (uint256) {
1138         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1139     }
1140 
1141     /**
1142      * Returns the number of tokens burned by or on behalf of `owner`.
1143      */
1144     function _numberBurned(address owner) internal view returns (uint256) {
1145         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1146     }
1147 
1148     /**
1149      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1150      */
1151     function _getAux(address owner) internal view returns (uint64) {
1152         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1153     }
1154 
1155     /**
1156      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1157      * If there are multiple variables, please pack them into a uint64.
1158      */
1159     function _setAux(address owner, uint64 aux) internal virtual {
1160         uint256 packed = _packedAddressData[owner];
1161         uint256 auxCasted;
1162         // Cast `aux` with assembly to avoid redundant masking.
1163         assembly {
1164             auxCasted := aux
1165         }
1166         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1167         _packedAddressData[owner] = packed;
1168     }
1169 
1170     // =============================================================
1171     //                            IERC165
1172     // =============================================================
1173 
1174     /**
1175      * @dev Returns true if this contract implements the interface defined by
1176      * `interfaceId`. See the corresponding
1177      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1178      * to learn more about how these ids are created.
1179      *
1180      * This function call must use less than 30000 gas.
1181      */
1182     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1183         // The interface IDs are constants representing the first 4 bytes
1184         // of the XOR of all function selectors in the interface.
1185         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1186         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1187         return
1188             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1189             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1190             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1191     }
1192 
1193     // =============================================================
1194     //                        IERC721Metadata
1195     // =============================================================
1196 
1197     /**
1198      * @dev Returns the token collection name.
1199      */
1200     function name() public view virtual override returns (string memory) {
1201         return _name;
1202     }
1203 
1204     /**
1205      * @dev Returns the token collection symbol.
1206      */
1207     function symbol() public view virtual override returns (string memory) {
1208         return _symbol;
1209     }
1210 
1211     /**
1212      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1213      */
1214     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1215         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1216 
1217         string memory baseURI = _baseURI();
1218         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1219     }
1220 
1221     /**
1222      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1223      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1224      * by default, it can be overridden in child contracts.
1225      */
1226     function _baseURI() internal view virtual returns (string memory) {
1227         return '';
1228     }
1229 
1230     // =============================================================
1231     //                     OWNERSHIPS OPERATIONS
1232     // =============================================================
1233 
1234     /**
1235      * @dev Returns the owner of the `tokenId` token.
1236      *
1237      * Requirements:
1238      *
1239      * - `tokenId` must exist.
1240      */
1241     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1242         return address(uint160(_packedOwnershipOf(tokenId)));
1243     }
1244 
1245     /**
1246      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1247      * It gradually moves to O(1) as tokens get transferred around over time.
1248      */
1249     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1250         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1251     }
1252 
1253     /**
1254      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1255      */
1256     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1257         return _unpackedOwnership(_packedOwnerships[index]);
1258     }
1259 
1260     /**
1261      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1262      */
1263     function _initializeOwnershipAt(uint256 index) internal virtual {
1264         if (_packedOwnerships[index] == 0) {
1265             _packedOwnerships[index] = _packedOwnershipOf(index);
1266         }
1267     }
1268 
1269     /**
1270      * Returns the packed ownership data of `tokenId`.
1271      */
1272     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1273         uint256 curr = tokenId;
1274 
1275         unchecked {
1276             if (_startTokenId() <= curr)
1277                 if (curr < _currentIndex) {
1278                     uint256 packed = _packedOwnerships[curr];
1279                     // If not burned.
1280                     if (packed & _BITMASK_BURNED == 0) {
1281                         // Invariant:
1282                         // There will always be an initialized ownership slot
1283                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1284                         // before an unintialized ownership slot
1285                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1286                         // Hence, `curr` will not underflow.
1287                         //
1288                         // We can directly compare the packed value.
1289                         // If the address is zero, packed will be zero.
1290                         while (packed == 0) {
1291                             packed = _packedOwnerships[--curr];
1292                         }
1293                         return packed;
1294                     }
1295                 }
1296         }
1297         revert OwnerQueryForNonexistentToken();
1298     }
1299 
1300     /**
1301      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1302      */
1303     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1304         ownership.addr = address(uint160(packed));
1305         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1306         ownership.burned = packed & _BITMASK_BURNED != 0;
1307         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1308     }
1309 
1310     /**
1311      * @dev Packs ownership data into a single uint256.
1312      */
1313     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1314         assembly {
1315             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1316             owner := and(owner, _BITMASK_ADDRESS)
1317             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1318             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1319         }
1320     }
1321 
1322     /**
1323      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1324      */
1325     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1326         // For branchless setting of the `nextInitialized` flag.
1327         assembly {
1328             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1329             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1330         }
1331     }
1332 
1333     // =============================================================
1334     //                      APPROVAL OPERATIONS
1335     // =============================================================
1336 
1337     /**
1338      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1339      * The approval is cleared when the token is transferred.
1340      *
1341      * Only a single account can be approved at a time, so approving the
1342      * zero address clears previous approvals.
1343      *
1344      * Requirements:
1345      *
1346      * - The caller must own the token or be an approved operator.
1347      * - `tokenId` must exist.
1348      *
1349      * Emits an {Approval} event.
1350      */
1351     function approve(address to, uint256 tokenId) public payable virtual override {
1352         address owner = ownerOf(tokenId);
1353 
1354         if (_msgSenderERC721A() != owner)
1355             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1356                 revert ApprovalCallerNotOwnerNorApproved();
1357             }
1358 
1359         _tokenApprovals[tokenId].value = to;
1360         emit Approval(owner, to, tokenId);
1361     }
1362 
1363     /**
1364      * @dev Returns the account approved for `tokenId` token.
1365      *
1366      * Requirements:
1367      *
1368      * - `tokenId` must exist.
1369      */
1370     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1371         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1372 
1373         return _tokenApprovals[tokenId].value;
1374     }
1375 
1376     /**
1377      * @dev Approve or remove `operator` as an operator for the caller.
1378      * Operators can call {transferFrom} or {safeTransferFrom}
1379      * for any token owned by the caller.
1380      *
1381      * Requirements:
1382      *
1383      * - The `operator` cannot be the caller.
1384      *
1385      * Emits an {ApprovalForAll} event.
1386      */
1387     function setApprovalForAll(address operator, bool approved) public virtual override {
1388         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1389         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1390     }
1391 
1392     /**
1393      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1394      *
1395      * See {setApprovalForAll}.
1396      */
1397     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1398         return _operatorApprovals[owner][operator];
1399     }
1400 
1401     /**
1402      * @dev Returns whether `tokenId` exists.
1403      *
1404      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1405      *
1406      * Tokens start existing when they are minted. See {_mint}.
1407      */
1408     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1409         return
1410             _startTokenId() <= tokenId &&
1411             tokenId < _currentIndex && // If within bounds,
1412             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1413     }
1414 
1415     /**
1416      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1417      */
1418     function _isSenderApprovedOrOwner(
1419         address approvedAddress,
1420         address owner,
1421         address msgSender
1422     ) private pure returns (bool result) {
1423         assembly {
1424             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1425             owner := and(owner, _BITMASK_ADDRESS)
1426             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1427             msgSender := and(msgSender, _BITMASK_ADDRESS)
1428             // `msgSender == owner || msgSender == approvedAddress`.
1429             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1430         }
1431     }
1432 
1433     /**
1434      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1435      */
1436     function _getApprovedSlotAndAddress(uint256 tokenId)
1437         private
1438         view
1439         returns (uint256 approvedAddressSlot, address approvedAddress)
1440     {
1441         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1442         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1443         assembly {
1444             approvedAddressSlot := tokenApproval.slot
1445             approvedAddress := sload(approvedAddressSlot)
1446         }
1447     }
1448 
1449     // =============================================================
1450     //                      TRANSFER OPERATIONS
1451     // =============================================================
1452 
1453     /**
1454      * @dev Transfers `tokenId` from `from` to `to`.
1455      *
1456      * Requirements:
1457      *
1458      * - `from` cannot be the zero address.
1459      * - `to` cannot be the zero address.
1460      * - `tokenId` token must be owned by `from`.
1461      * - If the caller is not `from`, it must be approved to move this token
1462      * by either {approve} or {setApprovalForAll}.
1463      *
1464      * Emits a {Transfer} event.
1465      */
1466     function transferFrom(
1467         address from,
1468         address to,
1469         uint256 tokenId
1470     ) public payable virtual override {
1471         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1472 
1473         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1474 
1475         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1476 
1477         // The nested ifs save around 20+ gas over a compound boolean condition.
1478         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1479             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1480 
1481         if (to == address(0)) revert TransferToZeroAddress();
1482 
1483         _beforeTokenTransfers(from, to, tokenId, 1);
1484 
1485         // Clear approvals from the previous owner.
1486         assembly {
1487             if approvedAddress {
1488                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1489                 sstore(approvedAddressSlot, 0)
1490             }
1491         }
1492 
1493         // Underflow of the sender's balance is impossible because we check for
1494         // ownership above and the recipient's balance can't realistically overflow.
1495         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1496         unchecked {
1497             // We can directly increment and decrement the balances.
1498             --_packedAddressData[from]; // Updates: `balance -= 1`.
1499             ++_packedAddressData[to]; // Updates: `balance += 1`.
1500 
1501             // Updates:
1502             // - `address` to the next owner.
1503             // - `startTimestamp` to the timestamp of transfering.
1504             // - `burned` to `false`.
1505             // - `nextInitialized` to `true`.
1506             _packedOwnerships[tokenId] = _packOwnershipData(
1507                 to,
1508                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1509             );
1510 
1511             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1512             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1513                 uint256 nextTokenId = tokenId + 1;
1514                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1515                 if (_packedOwnerships[nextTokenId] == 0) {
1516                     // If the next slot is within bounds.
1517                     if (nextTokenId != _currentIndex) {
1518                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1519                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1520                     }
1521                 }
1522             }
1523         }
1524 
1525         emit Transfer(from, to, tokenId);
1526         _afterTokenTransfers(from, to, tokenId, 1);
1527     }
1528 
1529     /**
1530      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1531      */
1532     function safeTransferFrom(
1533         address from,
1534         address to,
1535         uint256 tokenId
1536     ) public payable virtual override {
1537         safeTransferFrom(from, to, tokenId, '');
1538     }
1539 
1540     /**
1541      * @dev Safely transfers `tokenId` token from `from` to `to`.
1542      *
1543      * Requirements:
1544      *
1545      * - `from` cannot be the zero address.
1546      * - `to` cannot be the zero address.
1547      * - `tokenId` token must exist and be owned by `from`.
1548      * - If the caller is not `from`, it must be approved to move this token
1549      * by either {approve} or {setApprovalForAll}.
1550      * - If `to` refers to a smart contract, it must implement
1551      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1552      *
1553      * Emits a {Transfer} event.
1554      */
1555     function safeTransferFrom(
1556         address from,
1557         address to,
1558         uint256 tokenId,
1559         bytes memory _data
1560     ) public payable virtual override {
1561         transferFrom(from, to, tokenId);
1562         if (to.code.length != 0)
1563             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1564                 revert TransferToNonERC721ReceiverImplementer();
1565             }
1566     }
1567 
1568     /**
1569      * @dev Hook that is called before a set of serially-ordered token IDs
1570      * are about to be transferred. This includes minting.
1571      * And also called before burning one token.
1572      *
1573      * `startTokenId` - the first token ID to be transferred.
1574      * `quantity` - the amount to be transferred.
1575      *
1576      * Calling conditions:
1577      *
1578      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1579      * transferred to `to`.
1580      * - When `from` is zero, `tokenId` will be minted for `to`.
1581      * - When `to` is zero, `tokenId` will be burned by `from`.
1582      * - `from` and `to` are never both zero.
1583      */
1584     function _beforeTokenTransfers(
1585         address from,
1586         address to,
1587         uint256 startTokenId,
1588         uint256 quantity
1589     ) internal virtual {}
1590 
1591     /**
1592      * @dev Hook that is called after a set of serially-ordered token IDs
1593      * have been transferred. This includes minting.
1594      * And also called after one token has been burned.
1595      *
1596      * `startTokenId` - the first token ID to be transferred.
1597      * `quantity` - the amount to be transferred.
1598      *
1599      * Calling conditions:
1600      *
1601      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1602      * transferred to `to`.
1603      * - When `from` is zero, `tokenId` has been minted for `to`.
1604      * - When `to` is zero, `tokenId` has been burned by `from`.
1605      * - `from` and `to` are never both zero.
1606      */
1607     function _afterTokenTransfers(
1608         address from,
1609         address to,
1610         uint256 startTokenId,
1611         uint256 quantity
1612     ) internal virtual {}
1613 
1614     /**
1615      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1616      *
1617      * `from` - Previous owner of the given token ID.
1618      * `to` - Target address that will receive the token.
1619      * `tokenId` - Token ID to be transferred.
1620      * `_data` - Optional data to send along with the call.
1621      *
1622      * Returns whether the call correctly returned the expected magic value.
1623      */
1624     function _checkContractOnERC721Received(
1625         address from,
1626         address to,
1627         uint256 tokenId,
1628         bytes memory _data
1629     ) private returns (bool) {
1630         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1631             bytes4 retval
1632         ) {
1633             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1634         } catch (bytes memory reason) {
1635             if (reason.length == 0) {
1636                 revert TransferToNonERC721ReceiverImplementer();
1637             } else {
1638                 assembly {
1639                     revert(add(32, reason), mload(reason))
1640                 }
1641             }
1642         }
1643     }
1644 
1645     // =============================================================
1646     //                        MINT OPERATIONS
1647     // =============================================================
1648 
1649     /**
1650      * @dev Mints `quantity` tokens and transfers them to `to`.
1651      *
1652      * Requirements:
1653      *
1654      * - `to` cannot be the zero address.
1655      * - `quantity` must be greater than 0.
1656      *
1657      * Emits a {Transfer} event for each mint.
1658      */
1659     function _mint(address to, uint256 quantity) internal virtual {
1660         uint256 startTokenId = _currentIndex;
1661         if (quantity == 0) revert MintZeroQuantity();
1662 
1663         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1664 
1665         // Overflows are incredibly unrealistic.
1666         // `balance` and `numberMinted` have a maximum limit of 2**64.
1667         // `tokenId` has a maximum limit of 2**256.
1668         unchecked {
1669             // Updates:
1670             // - `balance += quantity`.
1671             // - `numberMinted += quantity`.
1672             //
1673             // We can directly add to the `balance` and `numberMinted`.
1674             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1675 
1676             // Updates:
1677             // - `address` to the owner.
1678             // - `startTimestamp` to the timestamp of minting.
1679             // - `burned` to `false`.
1680             // - `nextInitialized` to `quantity == 1`.
1681             _packedOwnerships[startTokenId] = _packOwnershipData(
1682                 to,
1683                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1684             );
1685 
1686             uint256 toMasked;
1687             uint256 end = startTokenId + quantity;
1688 
1689             // Use assembly to loop and emit the `Transfer` event for gas savings.
1690             // The duplicated `log4` removes an extra check and reduces stack juggling.
1691             // The assembly, together with the surrounding Solidity code, have been
1692             // delicately arranged to nudge the compiler into producing optimized opcodes.
1693             assembly {
1694                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1695                 toMasked := and(to, _BITMASK_ADDRESS)
1696                 // Emit the `Transfer` event.
1697                 log4(
1698                     0, // Start of data (0, since no data).
1699                     0, // End of data (0, since no data).
1700                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1701                     0, // `address(0)`.
1702                     toMasked, // `to`.
1703                     startTokenId // `tokenId`.
1704                 )
1705 
1706                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1707                 // that overflows uint256 will make the loop run out of gas.
1708                 // The compiler will optimize the `iszero` away for performance.
1709                 for {
1710                     let tokenId := add(startTokenId, 1)
1711                 } iszero(eq(tokenId, end)) {
1712                     tokenId := add(tokenId, 1)
1713                 } {
1714                     // Emit the `Transfer` event. Similar to above.
1715                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1716                 }
1717             }
1718             if (toMasked == 0) revert MintToZeroAddress();
1719 
1720             _currentIndex = end;
1721         }
1722         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1723     }
1724 
1725     /**
1726      * @dev Mints `quantity` tokens and transfers them to `to`.
1727      *
1728      * This function is intended for efficient minting only during contract creation.
1729      *
1730      * It emits only one {ConsecutiveTransfer} as defined in
1731      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1732      * instead of a sequence of {Transfer} event(s).
1733      *
1734      * Calling this function outside of contract creation WILL make your contract
1735      * non-compliant with the ERC721 standard.
1736      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1737      * {ConsecutiveTransfer} event is only permissible during contract creation.
1738      *
1739      * Requirements:
1740      *
1741      * - `to` cannot be the zero address.
1742      * - `quantity` must be greater than 0.
1743      *
1744      * Emits a {ConsecutiveTransfer} event.
1745      */
1746     function _mintERC2309(address to, uint256 quantity) internal virtual {
1747         uint256 startTokenId = _currentIndex;
1748         if (to == address(0)) revert MintToZeroAddress();
1749         if (quantity == 0) revert MintZeroQuantity();
1750         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1751 
1752         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1753 
1754         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1755         unchecked {
1756             // Updates:
1757             // - `balance += quantity`.
1758             // - `numberMinted += quantity`.
1759             //
1760             // We can directly add to the `balance` and `numberMinted`.
1761             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1762 
1763             // Updates:
1764             // - `address` to the owner.
1765             // - `startTimestamp` to the timestamp of minting.
1766             // - `burned` to `false`.
1767             // - `nextInitialized` to `quantity == 1`.
1768             _packedOwnerships[startTokenId] = _packOwnershipData(
1769                 to,
1770                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1771             );
1772 
1773             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1774 
1775             _currentIndex = startTokenId + quantity;
1776         }
1777         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1778     }
1779 
1780     /**
1781      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1782      *
1783      * Requirements:
1784      *
1785      * - If `to` refers to a smart contract, it must implement
1786      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1787      * - `quantity` must be greater than 0.
1788      *
1789      * See {_mint}.
1790      *
1791      * Emits a {Transfer} event for each mint.
1792      */
1793     function _safeMint(
1794         address to,
1795         uint256 quantity,
1796         bytes memory _data
1797     ) internal virtual {
1798         _mint(to, quantity);
1799 
1800         unchecked {
1801             if (to.code.length != 0) {
1802                 uint256 end = _currentIndex;
1803                 uint256 index = end - quantity;
1804                 do {
1805                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1806                         revert TransferToNonERC721ReceiverImplementer();
1807                     }
1808                 } while (index < end);
1809                 // Reentrancy protection.
1810                 if (_currentIndex != end) revert();
1811             }
1812         }
1813     }
1814 
1815     /**
1816      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1817      */
1818     function _safeMint(address to, uint256 quantity) internal virtual {
1819         _safeMint(to, quantity, '');
1820     }
1821 
1822     // =============================================================
1823     //                        BURN OPERATIONS
1824     // =============================================================
1825 
1826     /**
1827      * @dev Equivalent to `_burn(tokenId, false)`.
1828      */
1829     function _burn(uint256 tokenId) internal virtual {
1830         _burn(tokenId, false);
1831     }
1832 
1833     /**
1834      * @dev Destroys `tokenId`.
1835      * The approval is cleared when the token is burned.
1836      *
1837      * Requirements:
1838      *
1839      * - `tokenId` must exist.
1840      *
1841      * Emits a {Transfer} event.
1842      */
1843     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1844         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1845 
1846         address from = address(uint160(prevOwnershipPacked));
1847 
1848         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1849 
1850         if (approvalCheck) {
1851             // The nested ifs save around 20+ gas over a compound boolean condition.
1852             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1853                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1854         }
1855 
1856         _beforeTokenTransfers(from, address(0), tokenId, 1);
1857 
1858         // Clear approvals from the previous owner.
1859         assembly {
1860             if approvedAddress {
1861                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1862                 sstore(approvedAddressSlot, 0)
1863             }
1864         }
1865 
1866         // Underflow of the sender's balance is impossible because we check for
1867         // ownership above and the recipient's balance can't realistically overflow.
1868         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1869         unchecked {
1870             // Updates:
1871             // - `balance -= 1`.
1872             // - `numberBurned += 1`.
1873             //
1874             // We can directly decrement the balance, and increment the number burned.
1875             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1876             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1877 
1878             // Updates:
1879             // - `address` to the last owner.
1880             // - `startTimestamp` to the timestamp of burning.
1881             // - `burned` to `true`.
1882             // - `nextInitialized` to `true`.
1883             _packedOwnerships[tokenId] = _packOwnershipData(
1884                 from,
1885                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1886             );
1887 
1888             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1889             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1890                 uint256 nextTokenId = tokenId + 1;
1891                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1892                 if (_packedOwnerships[nextTokenId] == 0) {
1893                     // If the next slot is within bounds.
1894                     if (nextTokenId != _currentIndex) {
1895                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1896                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1897                     }
1898                 }
1899             }
1900         }
1901 
1902         emit Transfer(from, address(0), tokenId);
1903         _afterTokenTransfers(from, address(0), tokenId, 1);
1904 
1905         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1906         unchecked {
1907             _burnCounter++;
1908         }
1909     }
1910 
1911     // =============================================================
1912     //                     EXTRA DATA OPERATIONS
1913     // =============================================================
1914 
1915     /**
1916      * @dev Directly sets the extra data for the ownership data `index`.
1917      */
1918     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1919         uint256 packed = _packedOwnerships[index];
1920         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1921         uint256 extraDataCasted;
1922         // Cast `extraData` with assembly to avoid redundant masking.
1923         assembly {
1924             extraDataCasted := extraData
1925         }
1926         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1927         _packedOwnerships[index] = packed;
1928     }
1929 
1930     /**
1931      * @dev Called during each token transfer to set the 24bit `extraData` field.
1932      * Intended to be overridden by the cosumer contract.
1933      *
1934      * `previousExtraData` - the value of `extraData` before transfer.
1935      *
1936      * Calling conditions:
1937      *
1938      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1939      * transferred to `to`.
1940      * - When `from` is zero, `tokenId` will be minted for `to`.
1941      * - When `to` is zero, `tokenId` will be burned by `from`.
1942      * - `from` and `to` are never both zero.
1943      */
1944     function _extraData(
1945         address from,
1946         address to,
1947         uint24 previousExtraData
1948     ) internal view virtual returns (uint24) {}
1949 
1950     /**
1951      * @dev Returns the next extra data for the packed ownership data.
1952      * The returned result is shifted into position.
1953      */
1954     function _nextExtraData(
1955         address from,
1956         address to,
1957         uint256 prevOwnershipPacked
1958     ) private view returns (uint256) {
1959         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1960         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1961     }
1962 
1963     // =============================================================
1964     //                       OTHER OPERATIONS
1965     // =============================================================
1966 
1967     /**
1968      * @dev Returns the message sender (defaults to `msg.sender`).
1969      *
1970      * If you are writing GSN compatible contracts, you need to override this function.
1971      */
1972     function _msgSenderERC721A() internal view virtual returns (address) {
1973         return msg.sender;
1974     }
1975 
1976     /**
1977      * @dev Converts a uint256 to its ASCII string decimal representation.
1978      */
1979     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1980         assembly {
1981             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1982             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1983             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1984             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1985             let m := add(mload(0x40), 0xa0)
1986             // Update the free memory pointer to allocate.
1987             mstore(0x40, m)
1988             // Assign the `str` to the end.
1989             str := sub(m, 0x20)
1990             // Zeroize the slot after the string.
1991             mstore(str, 0)
1992 
1993             // Cache the end of the memory to calculate the length later.
1994             let end := str
1995 
1996             // We write the string from rightmost digit to leftmost digit.
1997             // The following is essentially a do-while loop that also handles the zero case.
1998             // prettier-ignore
1999             for { let temp := value } 1 {} {
2000                 str := sub(str, 1)
2001                 // Write the character to the pointer.
2002                 // The ASCII index of the '0' character is 48.
2003                 mstore8(str, add(48, mod(temp, 10)))
2004                 // Keep dividing `temp` until zero.
2005                 temp := div(temp, 10)
2006                 // prettier-ignore
2007                 if iszero(temp) { break }
2008             }
2009 
2010             let length := sub(end, str)
2011             // Move the pointer 32 bytes leftwards to make room for the length.
2012             str := sub(str, 0x20)
2013             // Store the length.
2014             mstore(str, length)
2015         }
2016     }
2017 }
2018 
2019 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2020 
2021 
2022 // ERC721A Contracts v4.2.3
2023 // Creator: Chiru Labs
2024 
2025 pragma solidity ^0.8.4;
2026 
2027 
2028 
2029 /**
2030  * @title ERC721AQueryable.
2031  *
2032  * @dev ERC721A subclass with convenience query functions.
2033  */
2034 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2035     /**
2036      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2037      *
2038      * If the `tokenId` is out of bounds:
2039      *
2040      * - `addr = address(0)`
2041      * - `startTimestamp = 0`
2042      * - `burned = false`
2043      * - `extraData = 0`
2044      *
2045      * If the `tokenId` is burned:
2046      *
2047      * - `addr = <Address of owner before token was burned>`
2048      * - `startTimestamp = <Timestamp when token was burned>`
2049      * - `burned = true`
2050      * - `extraData = <Extra data when token was burned>`
2051      *
2052      * Otherwise:
2053      *
2054      * - `addr = <Address of owner>`
2055      * - `startTimestamp = <Timestamp of start of ownership>`
2056      * - `burned = false`
2057      * - `extraData = <Extra data at start of ownership>`
2058      */
2059     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2060         TokenOwnership memory ownership;
2061         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2062             return ownership;
2063         }
2064         ownership = _ownershipAt(tokenId);
2065         if (ownership.burned) {
2066             return ownership;
2067         }
2068         return _ownershipOf(tokenId);
2069     }
2070 
2071     /**
2072      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2073      * See {ERC721AQueryable-explicitOwnershipOf}
2074      */
2075     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2076         external
2077         view
2078         virtual
2079         override
2080         returns (TokenOwnership[] memory)
2081     {
2082         unchecked {
2083             uint256 tokenIdsLength = tokenIds.length;
2084             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2085             for (uint256 i; i != tokenIdsLength; ++i) {
2086                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2087             }
2088             return ownerships;
2089         }
2090     }
2091 
2092     /**
2093      * @dev Returns an array of token IDs owned by `owner`,
2094      * in the range [`start`, `stop`)
2095      * (i.e. `start <= tokenId < stop`).
2096      *
2097      * This function allows for tokens to be queried if the collection
2098      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2099      *
2100      * Requirements:
2101      *
2102      * - `start < stop`
2103      */
2104     function tokensOfOwnerIn(
2105         address owner,
2106         uint256 start,
2107         uint256 stop
2108     ) external view virtual override returns (uint256[] memory) {
2109         unchecked {
2110             if (start >= stop) revert InvalidQueryRange();
2111             uint256 tokenIdsIdx;
2112             uint256 stopLimit = _nextTokenId();
2113             // Set `start = max(start, _startTokenId())`.
2114             if (start < _startTokenId()) {
2115                 start = _startTokenId();
2116             }
2117             // Set `stop = min(stop, stopLimit)`.
2118             if (stop > stopLimit) {
2119                 stop = stopLimit;
2120             }
2121             uint256 tokenIdsMaxLength = balanceOf(owner);
2122             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2123             // to cater for cases where `balanceOf(owner)` is too big.
2124             if (start < stop) {
2125                 uint256 rangeLength = stop - start;
2126                 if (rangeLength < tokenIdsMaxLength) {
2127                     tokenIdsMaxLength = rangeLength;
2128                 }
2129             } else {
2130                 tokenIdsMaxLength = 0;
2131             }
2132             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2133             if (tokenIdsMaxLength == 0) {
2134                 return tokenIds;
2135             }
2136             // We need to call `explicitOwnershipOf(start)`,
2137             // because the slot at `start` may not be initialized.
2138             TokenOwnership memory ownership = explicitOwnershipOf(start);
2139             address currOwnershipAddr;
2140             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2141             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2142             if (!ownership.burned) {
2143                 currOwnershipAddr = ownership.addr;
2144             }
2145             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2146                 ownership = _ownershipAt(i);
2147                 if (ownership.burned) {
2148                     continue;
2149                 }
2150                 if (ownership.addr != address(0)) {
2151                     currOwnershipAddr = ownership.addr;
2152                 }
2153                 if (currOwnershipAddr == owner) {
2154                     tokenIds[tokenIdsIdx++] = i;
2155                 }
2156             }
2157             // Downsize the array to fit.
2158             assembly {
2159                 mstore(tokenIds, tokenIdsIdx)
2160             }
2161             return tokenIds;
2162         }
2163     }
2164 
2165     /**
2166      * @dev Returns an array of token IDs owned by `owner`.
2167      *
2168      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2169      * It is meant to be called off-chain.
2170      *
2171      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2172      * multiple smaller scans if the collection is large enough to cause
2173      * an out-of-gas error (10K collections should be fine).
2174      */
2175     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2176         unchecked {
2177             uint256 tokenIdsIdx;
2178             address currOwnershipAddr;
2179             uint256 tokenIdsLength = balanceOf(owner);
2180             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2181             TokenOwnership memory ownership;
2182             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2183                 ownership = _ownershipAt(i);
2184                 if (ownership.burned) {
2185                     continue;
2186                 }
2187                 if (ownership.addr != address(0)) {
2188                     currOwnershipAddr = ownership.addr;
2189                 }
2190                 if (currOwnershipAddr == owner) {
2191                     tokenIds[tokenIdsIdx++] = i;
2192                 }
2193             }
2194             return tokenIds;
2195         }
2196     }
2197 }
2198 
2199 // File: contracts/contract/V3GA.sol
2200 
2201 
2202 
2203 /**
2204 ____   ____________   ________    _____   
2205 \   \ /   /\_____  \ /  _____/   /  _  \  
2206  \   Y   /   _(__  </   \  ___  /  /_\  \ 
2207   \     /   /       \    \_\  \/    |    \
2208    \___/   /______  /\______  /\____|__  /
2209                   \/        \/         \/ 
2210 
2211 */
2212 
2213 pragma solidity ^0.8.18;
2214 
2215 
2216 
2217 
2218 
2219 
2220 contract V3GA is MutableOperatorFilterer, ERC721A, ERC721AQueryable, ERC2981 {
2221     string private baseURI;
2222     address public ownerAddr = 0xBc2E16F8058636334962D0C0E4e027238A09Ed82;
2223 
2224     // Total NFTs that can be minted
2225     uint256 public maxSupply = 2222;
2226     uint256 public mintPrice = 0.005 ether;
2227     bool public pausedMint = true;
2228 
2229     constructor(
2230         string memory name,
2231         string memory symbol,
2232         string memory initBaseURI,
2233         address operatorFilterRegistryAddress,
2234         address operatorFilterRegistrant
2235     )
2236         ERC721A(name, symbol)
2237         MutableOperatorFilterer(
2238             operatorFilterRegistryAddress,
2239             operatorFilterRegistrant
2240         )
2241     {
2242         setBaseURI(initBaseURI);
2243     }
2244 
2245     // Public mint
2246     function mint(uint256 num) external payable {
2247         uint256 supply = totalSupply();
2248         require(!pausedMint, "Minting is paused");
2249         require(supply + num < maxSupply, "Exceeds maximum NFTs supply");
2250         require(msg.value == mintPrice * num, "Ether sent is not correct");
2251         _safeMint(msg.sender, num);
2252     }
2253 
2254     function giveAway(address recipient, uint256 num) external onlyOwner {
2255         uint256 supply = totalSupply();
2256         require(supply + num < maxSupply, "Exceeds maximum NFTs supply");
2257         _safeMint(recipient, num);
2258     }
2259 
2260     function setMintPrice(uint256 priceInWei) external onlyOwner {
2261         mintPrice = priceInWei;
2262     }
2263 
2264     function paused(bool val) external onlyOwner {
2265         pausedMint = val;
2266     }
2267 
2268     function setMaxSupply(uint256 val) external onlyOwner {
2269         maxSupply = val;
2270     }
2271 
2272     function setWithdrawAddress(address val) external onlyOwner {
2273         ownerAddr = val;
2274     }
2275 
2276     function _baseURI() internal view virtual override returns (string memory) {
2277         return baseURI;
2278     }
2279 
2280     // Include trailing slash in uri
2281     function setBaseURI(string memory uri) public onlyOwner {
2282         baseURI = uri;
2283     }
2284 
2285     function withdrawAll() external payable onlyOwner {
2286         uint256 all = address(this).balance;
2287         require(payable(ownerAddr).send(all));
2288     }
2289 
2290     /********************
2291      *  OPERATOR FILTER
2292      ********************/
2293 
2294     function setApprovalForAll(
2295         address operator,
2296         bool approved
2297     ) public override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
2298         super.setApprovalForAll(operator, approved);
2299     }
2300 
2301     function approve(
2302         address operator,
2303         uint256 tokenId
2304     )
2305         public
2306         payable
2307         override(ERC721A, IERC721A)
2308         onlyAllowedOperatorApproval(operator)
2309     {
2310         super.approve(operator, tokenId);
2311     }
2312 
2313     function transferFrom(
2314         address from,
2315         address to,
2316         uint256 tokenId
2317     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2318         super.transferFrom(from, to, tokenId);
2319     }
2320 
2321     function safeTransferFrom(
2322         address from,
2323         address to,
2324         uint256 tokenId
2325     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2326         super.safeTransferFrom(from, to, tokenId);
2327     }
2328 
2329     function safeTransferFrom(
2330         address from,
2331         address to,
2332         uint256 tokenId,
2333         bytes memory data
2334     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2335         super.safeTransferFrom(from, to, tokenId, data);
2336     }
2337 
2338     /************
2339      *  IERC165
2340      ************/
2341 
2342     /**
2343      * @dev Returns true if this contract implements the interface defined by
2344      * `interfaceId`. See the corresponding
2345      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2346      * to learn more about how these ids are created.
2347      *
2348      * This function call must use less than 30000 gas.
2349      */
2350     function supportsInterface(
2351         bytes4 interfaceId
2352     ) public view virtual override(ERC721A, IERC721A, ERC2981) returns (bool) {
2353         return
2354             ERC721A.supportsInterface(interfaceId) ||
2355             ERC2981.supportsInterface(interfaceId);
2356     }
2357 
2358     /*************
2359      *  IERC2981
2360      *************/
2361 
2362     /**
2363      * @notice Allows the owner to set default royalties following EIP-2981 royalty standard.
2364      * - `feeNumerator` defaults to basis points e.g. 500 is 5%
2365      */
2366     function setDefaultRoyalty(
2367         address receiver,
2368         uint96 feeNumerator
2369     ) external onlyOwner {
2370         _setDefaultRoyalty(receiver, feeNumerator);
2371     }
2372 }