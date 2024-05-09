1 // File: operator-filter-registry/src/lib/Constants.sol
2 
3 
4 pragma solidity ^0.8.17;
5 
6 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
7 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
8 
9 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
10 
11 
12 pragma solidity ^0.8.13;
13 
14 interface IOperatorFilterRegistry {
15     /**
16      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
17      *         true if supplied registrant address is not registered.
18      */
19     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
20 
21     /**
22      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
23      */
24     function register(address registrant) external;
25 
26     /**
27      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
28      */
29     function registerAndSubscribe(address registrant, address subscription) external;
30 
31     /**
32      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
33      *         address without subscribing.
34      */
35     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
36 
37     /**
38      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
39      *         Note that this does not remove any filtered addresses or codeHashes.
40      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
41      */
42     function unregister(address addr) external;
43 
44     /**
45      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
46      */
47     function updateOperator(address registrant, address operator, bool filtered) external;
48 
49     /**
50      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
51      */
52     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
53 
54     /**
55      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
56      */
57     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
58 
59     /**
60      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
61      */
62     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
63 
64     /**
65      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
66      *         subscription if present.
67      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
68      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
69      *         used.
70      */
71     function subscribe(address registrant, address registrantToSubscribe) external;
72 
73     /**
74      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
75      */
76     function unsubscribe(address registrant, bool copyExistingEntries) external;
77 
78     /**
79      * @notice Get the subscription address of a given registrant, if any.
80      */
81     function subscriptionOf(address addr) external returns (address registrant);
82 
83     /**
84      * @notice Get the set of addresses subscribed to a given registrant.
85      *         Note that order is not guaranteed as updates are made.
86      */
87     function subscribers(address registrant) external returns (address[] memory);
88 
89     /**
90      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
91      *         Note that order is not guaranteed as updates are made.
92      */
93     function subscriberAt(address registrant, uint256 index) external returns (address);
94 
95     /**
96      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
97      */
98     function copyEntriesOf(address registrant, address registrantToCopy) external;
99 
100     /**
101      * @notice Returns true if operator is filtered by a given address or its subscription.
102      */
103     function isOperatorFiltered(address registrant, address operator) external returns (bool);
104 
105     /**
106      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
107      */
108     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
109 
110     /**
111      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
112      */
113     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
114 
115     /**
116      * @notice Returns a list of filtered operators for a given address or its subscription.
117      */
118     function filteredOperators(address addr) external returns (address[] memory);
119 
120     /**
121      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
122      *         Note that order is not guaranteed as updates are made.
123      */
124     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
125 
126     /**
127      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
128      *         its subscription.
129      *         Note that order is not guaranteed as updates are made.
130      */
131     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
132 
133     /**
134      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
135      *         its subscription.
136      *         Note that order is not guaranteed as updates are made.
137      */
138     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
139 
140     /**
141      * @notice Returns true if an address has registered
142      */
143     function isRegistered(address addr) external returns (bool);
144 
145     /**
146      * @dev Convenience method to compute the code hash of an arbitrary contract
147      */
148     function codeHashOf(address addr) external returns (bytes32);
149 }
150 
151 // File: operator-filter-registry/src/OperatorFilterer.sol
152 
153 
154 pragma solidity ^0.8.13;
155 
156 
157 /**
158  * @title  OperatorFilterer
159  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
160  *         registrant's entries in the OperatorFilterRegistry.
161  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
162  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
163  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
164  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
165  *         administration methods on the contract itself to interact with the registry otherwise the subscription
166  *         will be locked to the options set during construction.
167  */
168 
169 abstract contract OperatorFilterer {
170     /// @dev Emitted when an operator is not allowed.
171     error OperatorNotAllowed(address operator);
172 
173     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
174         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
175 
176     /// @dev The constructor that is called when the contract is being deployed.
177     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
178         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
179         // will not revert, but the contract will need to be registered with the registry once it is deployed in
180         // order for the modifier to filter addresses.
181         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
182             if (subscribe) {
183                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
184             } else {
185                 if (subscriptionOrRegistrantToCopy != address(0)) {
186                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
187                 } else {
188                     OPERATOR_FILTER_REGISTRY.register(address(this));
189                 }
190             }
191         }
192     }
193 
194     /**
195      * @dev A helper function to check if an operator is allowed.
196      */
197     modifier onlyAllowedOperator(address from) virtual {
198         // Allow spending tokens from addresses with balance
199         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
200         // from an EOA.
201         if (from != msg.sender) {
202             _checkFilterOperator(msg.sender);
203         }
204         _;
205     }
206 
207     /**
208      * @dev A helper function to check if an operator approval is allowed.
209      */
210     modifier onlyAllowedOperatorApproval(address operator) virtual {
211         _checkFilterOperator(operator);
212         _;
213     }
214 
215     /**
216      * @dev A helper function to check if an operator is allowed.
217      */
218     function _checkFilterOperator(address operator) internal view virtual {
219         // Check registry code length to facilitate testing in environments without a deployed registry.
220         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
221             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
222             // may specify their own OperatorFilterRegistry implementations, which may behave differently
223             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
224                 revert OperatorNotAllowed(operator);
225             }
226         }
227     }
228 }
229 
230 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
231 
232 
233 pragma solidity ^0.8.13;
234 
235 
236 /**
237  * @title  DefaultOperatorFilterer
238  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
239  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
240  *         administration methods on the contract itself to interact with the registry otherwise the subscription
241  *         will be locked to the options set during construction.
242  */
243 
244 abstract contract DefaultOperatorFilterer is OperatorFilterer {
245     /// @dev The constructor that is called when the contract is being deployed.
246     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
247 }
248 
249 // File: @openzeppelin/contracts/utils/Context.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev Provides information about the current execution context, including the
258  * sender of the transaction and its data. While these are generally available
259  * via msg.sender and msg.data, they should not be accessed in such a direct
260  * manner, since when dealing with meta-transactions the account sending and
261  * paying for execution may not be the actual sender (as far as an application
262  * is concerned).
263  *
264  * This contract is only required for intermediate, library-like contracts.
265  */
266 abstract contract Context {
267     function _msgSender() internal view virtual returns (address) {
268         return msg.sender;
269     }
270 
271     function _msgData() internal view virtual returns (bytes calldata) {
272         return msg.data;
273     }
274 }
275 
276 // File: @openzeppelin/contracts/access/Ownable.sol
277 
278 
279 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 
284 /**
285  * @dev Contract module which provides a basic access control mechanism, where
286  * there is an account (an owner) that can be granted exclusive access to
287  * specific functions.
288  *
289  * By default, the owner account will be the one that deploys the contract. This
290  * can later be changed with {transferOwnership}.
291  *
292  * This module is used through inheritance. It will make available the modifier
293  * `onlyOwner`, which can be applied to your functions to restrict their use to
294  * the owner.
295  */
296 abstract contract Ownable is Context {
297     address private _owner;
298 
299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301     /**
302      * @dev Initializes the contract setting the deployer as the initial owner.
303      */
304     constructor() {
305         _transferOwnership(_msgSender());
306     }
307 
308     /**
309      * @dev Throws if called by any account other than the owner.
310      */
311     modifier onlyOwner() {
312         _checkOwner();
313         _;
314     }
315 
316     /**
317      * @dev Returns the address of the current owner.
318      */
319     function owner() public view virtual returns (address) {
320         return _owner;
321     }
322 
323     /**
324      * @dev Throws if the sender is not the owner.
325      */
326     function _checkOwner() internal view virtual {
327         require(owner() == _msgSender(), "Ownable: caller is not the owner");
328     }
329 
330     /**
331      * @dev Leaves the contract without owner. It will not be possible to call
332      * `onlyOwner` functions anymore. Can only be called by the current owner.
333      *
334      * NOTE: Renouncing ownership will leave the contract without an owner,
335      * thereby removing any functionality that is only available to the owner.
336      */
337     function renounceOwnership() public virtual onlyOwner {
338         _transferOwnership(address(0));
339     }
340 
341     /**
342      * @dev Transfers ownership of the contract to a new account (`newOwner`).
343      * Can only be called by the current owner.
344      */
345     function transferOwnership(address newOwner) public virtual onlyOwner {
346         require(newOwner != address(0), "Ownable: new owner is the zero address");
347         _transferOwnership(newOwner);
348     }
349 
350     /**
351      * @dev Transfers ownership of the contract to a new account (`newOwner`).
352      * Internal function without access restriction.
353      */
354     function _transferOwnership(address newOwner) internal virtual {
355         address oldOwner = _owner;
356         _owner = newOwner;
357         emit OwnershipTransferred(oldOwner, newOwner);
358     }
359 }
360 
361 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev Interface of the ERC165 standard, as defined in the
370  * https://eips.ethereum.org/EIPS/eip-165[EIP].
371  *
372  * Implementers can declare support of contract interfaces, which can then be
373  * queried by others ({ERC165Checker}).
374  *
375  * For an implementation, see {ERC165}.
376  */
377 interface IERC165 {
378     /**
379      * @dev Returns true if this contract implements the interface defined by
380      * `interfaceId`. See the corresponding
381      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
382      * to learn more about how these ids are created.
383      *
384      * This function call must use less than 30 000 gas.
385      */
386     function supportsInterface(bytes4 interfaceId) external view returns (bool);
387 }
388 
389 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 /**
398  * @dev Implementation of the {IERC165} interface.
399  *
400  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
401  * for the additional interface id that will be supported. For example:
402  *
403  * ```solidity
404  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
405  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
406  * }
407  * ```
408  *
409  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
410  */
411 abstract contract ERC165 is IERC165 {
412     /**
413      * @dev See {IERC165-supportsInterface}.
414      */
415     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
416         return interfaceId == type(IERC165).interfaceId;
417     }
418 }
419 
420 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
421 
422 
423 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 
428 /**
429  * @dev Interface for the NFT Royalty Standard.
430  *
431  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
432  * support for royalty payments across all NFT marketplaces and ecosystem participants.
433  *
434  * _Available since v4.5._
435  */
436 interface IERC2981 is IERC165 {
437     /**
438      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
439      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
440      */
441     function royaltyInfo(uint256 tokenId, uint256 salePrice)
442         external
443         view
444         returns (address receiver, uint256 royaltyAmount);
445 }
446 
447 // File: @openzeppelin/contracts/token/common/ERC2981.sol
448 
449 
450 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 
455 
456 /**
457  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
458  *
459  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
460  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
461  *
462  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
463  * fee is specified in basis points by default.
464  *
465  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
466  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
467  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
468  *
469  * _Available since v4.5._
470  */
471 abstract contract ERC2981 is IERC2981, ERC165 {
472     struct RoyaltyInfo {
473         address receiver;
474         uint96 royaltyFraction;
475     }
476 
477     RoyaltyInfo private _defaultRoyaltyInfo;
478     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
479 
480     /**
481      * @dev See {IERC165-supportsInterface}.
482      */
483     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
484         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
485     }
486 
487     /**
488      * @inheritdoc IERC2981
489      */
490     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
491         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
492 
493         if (royalty.receiver == address(0)) {
494             royalty = _defaultRoyaltyInfo;
495         }
496 
497         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
498 
499         return (royalty.receiver, royaltyAmount);
500     }
501 
502     /**
503      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
504      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
505      * override.
506      */
507     function _feeDenominator() internal pure virtual returns (uint96) {
508         return 10000;
509     }
510 
511     /**
512      * @dev Sets the royalty information that all ids in this contract will default to.
513      *
514      * Requirements:
515      *
516      * - `receiver` cannot be the zero address.
517      * - `feeNumerator` cannot be greater than the fee denominator.
518      */
519     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
520         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
521         require(receiver != address(0), "ERC2981: invalid receiver");
522 
523         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
524     }
525 
526     /**
527      * @dev Removes default royalty information.
528      */
529     function _deleteDefaultRoyalty() internal virtual {
530         delete _defaultRoyaltyInfo;
531     }
532 
533     /**
534      * @dev Sets the royalty information for a specific token id, overriding the global default.
535      *
536      * Requirements:
537      *
538      * - `receiver` cannot be the zero address.
539      * - `feeNumerator` cannot be greater than the fee denominator.
540      */
541     function _setTokenRoyalty(
542         uint256 tokenId,
543         address receiver,
544         uint96 feeNumerator
545     ) internal virtual {
546         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
547         require(receiver != address(0), "ERC2981: Invalid parameters");
548 
549         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
550     }
551 
552     /**
553      * @dev Resets royalty information for the token id back to the global default.
554      */
555     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
556         delete _tokenRoyaltyInfo[tokenId];
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
845 // File: erc721a/contracts/ERC721A.sol
846 
847 
848 // ERC721A Contracts v4.2.3
849 // Creator: Chiru Labs
850 
851 pragma solidity ^0.8.4;
852 
853 
854 /**
855  * @dev Interface of ERC721 token receiver.
856  */
857 interface ERC721A__IERC721Receiver {
858     function onERC721Received(
859         address operator,
860         address from,
861         uint256 tokenId,
862         bytes calldata data
863     ) external returns (bytes4);
864 }
865 
866 /**
867  * @title ERC721A
868  *
869  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
870  * Non-Fungible Token Standard, including the Metadata extension.
871  * Optimized for lower gas during batch mints.
872  *
873  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
874  * starting from `_startTokenId()`.
875  *
876  * Assumptions:
877  *
878  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
879  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
880  */
881 contract ERC721A is IERC721A {
882     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
883     struct TokenApprovalRef {
884         address value;
885     }
886 
887     // =============================================================
888     //                           CONSTANTS
889     // =============================================================
890 
891     // Mask of an entry in packed address data.
892     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
893 
894     // The bit position of `numberMinted` in packed address data.
895     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
896 
897     // The bit position of `numberBurned` in packed address data.
898     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
899 
900     // The bit position of `aux` in packed address data.
901     uint256 private constant _BITPOS_AUX = 192;
902 
903     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
904     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
905 
906     // The bit position of `startTimestamp` in packed ownership.
907     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
908 
909     // The bit mask of the `burned` bit in packed ownership.
910     uint256 private constant _BITMASK_BURNED = 1 << 224;
911 
912     // The bit position of the `nextInitialized` bit in packed ownership.
913     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
914 
915     // The bit mask of the `nextInitialized` bit in packed ownership.
916     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
917 
918     // The bit position of `extraData` in packed ownership.
919     uint256 private constant _BITPOS_EXTRA_DATA = 232;
920 
921     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
922     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
923 
924     // The mask of the lower 160 bits for addresses.
925     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
926 
927     // The maximum `quantity` that can be minted with {_mintERC2309}.
928     // This limit is to prevent overflows on the address data entries.
929     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
930     // is required to cause an overflow, which is unrealistic.
931     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
932 
933     // The `Transfer` event signature is given by:
934     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
935     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
936         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
937 
938     // =============================================================
939     //                            STORAGE
940     // =============================================================
941 
942     // The next token ID to be minted.
943     uint256 private _currentIndex;
944 
945     // The number of tokens burned.
946     uint256 private _burnCounter;
947 
948     // Token name
949     string private _name;
950 
951     // Token symbol
952     string private _symbol;
953 
954     // Mapping from token ID to ownership details
955     // An empty struct value does not necessarily mean the token is unowned.
956     // See {_packedOwnershipOf} implementation for details.
957     //
958     // Bits Layout:
959     // - [0..159]   `addr`
960     // - [160..223] `startTimestamp`
961     // - [224]      `burned`
962     // - [225]      `nextInitialized`
963     // - [232..255] `extraData`
964     mapping(uint256 => uint256) private _packedOwnerships;
965 
966     // Mapping owner address to address data.
967     //
968     // Bits Layout:
969     // - [0..63]    `balance`
970     // - [64..127]  `numberMinted`
971     // - [128..191] `numberBurned`
972     // - [192..255] `aux`
973     mapping(address => uint256) private _packedAddressData;
974 
975     // Mapping from token ID to approved address.
976     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
977 
978     // Mapping from owner to operator approvals
979     mapping(address => mapping(address => bool)) private _operatorApprovals;
980 
981     // =============================================================
982     //                          CONSTRUCTOR
983     // =============================================================
984 
985     constructor(string memory name_, string memory symbol_) {
986         _name = name_;
987         _symbol = symbol_;
988         _currentIndex = _startTokenId();
989     }
990 
991     // =============================================================
992     //                   TOKEN COUNTING OPERATIONS
993     // =============================================================
994 
995     /**
996      * @dev Returns the starting token ID.
997      * To change the starting token ID, please override this function.
998      */
999     function _startTokenId() internal view virtual returns (uint256) {
1000         return 0;
1001     }
1002 
1003     /**
1004      * @dev Returns the next token ID to be minted.
1005      */
1006     function _nextTokenId() internal view virtual returns (uint256) {
1007         return _currentIndex;
1008     }
1009 
1010     /**
1011      * @dev Returns the total number of tokens in existence.
1012      * Burned tokens will reduce the count.
1013      * To get the total number of tokens minted, please see {_totalMinted}.
1014      */
1015     function totalSupply() public view virtual override returns (uint256) {
1016         // Counter underflow is impossible as _burnCounter cannot be incremented
1017         // more than `_currentIndex - _startTokenId()` times.
1018         unchecked {
1019             return _currentIndex - _burnCounter - _startTokenId();
1020         }
1021     }
1022 
1023     /**
1024      * @dev Returns the total amount of tokens minted in the contract.
1025      */
1026     function _totalMinted() internal view virtual returns (uint256) {
1027         // Counter underflow is impossible as `_currentIndex` does not decrement,
1028         // and it is initialized to `_startTokenId()`.
1029         unchecked {
1030             return _currentIndex - _startTokenId();
1031         }
1032     }
1033 
1034     /**
1035      * @dev Returns the total number of tokens burned.
1036      */
1037     function _totalBurned() internal view virtual returns (uint256) {
1038         return _burnCounter;
1039     }
1040 
1041     // =============================================================
1042     //                    ADDRESS DATA OPERATIONS
1043     // =============================================================
1044 
1045     /**
1046      * @dev Returns the number of tokens in `owner`'s account.
1047      */
1048     function balanceOf(address owner) public view virtual override returns (uint256) {
1049         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1050         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1051     }
1052 
1053     /**
1054      * Returns the number of tokens minted by `owner`.
1055      */
1056     function _numberMinted(address owner) internal view returns (uint256) {
1057         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1058     }
1059 
1060     /**
1061      * Returns the number of tokens burned by or on behalf of `owner`.
1062      */
1063     function _numberBurned(address owner) internal view returns (uint256) {
1064         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1065     }
1066 
1067     /**
1068      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1069      */
1070     function _getAux(address owner) internal view returns (uint64) {
1071         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1072     }
1073 
1074     /**
1075      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1076      * If there are multiple variables, please pack them into a uint64.
1077      */
1078     function _setAux(address owner, uint64 aux) internal virtual {
1079         uint256 packed = _packedAddressData[owner];
1080         uint256 auxCasted;
1081         // Cast `aux` with assembly to avoid redundant masking.
1082         assembly {
1083             auxCasted := aux
1084         }
1085         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1086         _packedAddressData[owner] = packed;
1087     }
1088 
1089     // =============================================================
1090     //                            IERC165
1091     // =============================================================
1092 
1093     /**
1094      * @dev Returns true if this contract implements the interface defined by
1095      * `interfaceId`. See the corresponding
1096      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1097      * to learn more about how these ids are created.
1098      *
1099      * This function call must use less than 30000 gas.
1100      */
1101     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1102         // The interface IDs are constants representing the first 4 bytes
1103         // of the XOR of all function selectors in the interface.
1104         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1105         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1106         return
1107             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1108             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1109             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1110     }
1111 
1112     // =============================================================
1113     //                        IERC721Metadata
1114     // =============================================================
1115 
1116     /**
1117      * @dev Returns the token collection name.
1118      */
1119     function name() public view virtual override returns (string memory) {
1120         return _name;
1121     }
1122 
1123     /**
1124      * @dev Returns the token collection symbol.
1125      */
1126     function symbol() public view virtual override returns (string memory) {
1127         return _symbol;
1128     }
1129 
1130     /**
1131      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1132      */
1133     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1134         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1135 
1136         string memory baseURI = _baseURI();
1137         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1138     }
1139 
1140     /**
1141      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1142      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1143      * by default, it can be overridden in child contracts.
1144      */
1145     function _baseURI() internal view virtual returns (string memory) {
1146         return '';
1147     }
1148 
1149     // =============================================================
1150     //                     OWNERSHIPS OPERATIONS
1151     // =============================================================
1152 
1153     /**
1154      * @dev Returns the owner of the `tokenId` token.
1155      *
1156      * Requirements:
1157      *
1158      * - `tokenId` must exist.
1159      */
1160     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1161         return address(uint160(_packedOwnershipOf(tokenId)));
1162     }
1163 
1164     /**
1165      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1166      * It gradually moves to O(1) as tokens get transferred around over time.
1167      */
1168     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1169         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1170     }
1171 
1172     /**
1173      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1174      */
1175     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1176         return _unpackedOwnership(_packedOwnerships[index]);
1177     }
1178 
1179     /**
1180      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1181      */
1182     function _initializeOwnershipAt(uint256 index) internal virtual {
1183         if (_packedOwnerships[index] == 0) {
1184             _packedOwnerships[index] = _packedOwnershipOf(index);
1185         }
1186     }
1187 
1188     /**
1189      * Returns the packed ownership data of `tokenId`.
1190      */
1191     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1192         uint256 curr = tokenId;
1193 
1194         unchecked {
1195             if (_startTokenId() <= curr)
1196                 if (curr < _currentIndex) {
1197                     uint256 packed = _packedOwnerships[curr];
1198                     // If not burned.
1199                     if (packed & _BITMASK_BURNED == 0) {
1200                         // Invariant:
1201                         // There will always be an initialized ownership slot
1202                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1203                         // before an unintialized ownership slot
1204                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1205                         // Hence, `curr` will not underflow.
1206                         //
1207                         // We can directly compare the packed value.
1208                         // If the address is zero, packed will be zero.
1209                         while (packed == 0) {
1210                             packed = _packedOwnerships[--curr];
1211                         }
1212                         return packed;
1213                     }
1214                 }
1215         }
1216         revert OwnerQueryForNonexistentToken();
1217     }
1218 
1219     /**
1220      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1221      */
1222     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1223         ownership.addr = address(uint160(packed));
1224         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1225         ownership.burned = packed & _BITMASK_BURNED != 0;
1226         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1227     }
1228 
1229     /**
1230      * @dev Packs ownership data into a single uint256.
1231      */
1232     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1233         assembly {
1234             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1235             owner := and(owner, _BITMASK_ADDRESS)
1236             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1237             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1238         }
1239     }
1240 
1241     /**
1242      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1243      */
1244     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1245         // For branchless setting of the `nextInitialized` flag.
1246         assembly {
1247             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1248             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1249         }
1250     }
1251 
1252     // =============================================================
1253     //                      APPROVAL OPERATIONS
1254     // =============================================================
1255 
1256     /**
1257      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1258      * The approval is cleared when the token is transferred.
1259      *
1260      * Only a single account can be approved at a time, so approving the
1261      * zero address clears previous approvals.
1262      *
1263      * Requirements:
1264      *
1265      * - The caller must own the token or be an approved operator.
1266      * - `tokenId` must exist.
1267      *
1268      * Emits an {Approval} event.
1269      */
1270     function approve(address to, uint256 tokenId) public payable virtual override {
1271         address owner = ownerOf(tokenId);
1272 
1273         if (_msgSenderERC721A() != owner)
1274             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1275                 revert ApprovalCallerNotOwnerNorApproved();
1276             }
1277 
1278         _tokenApprovals[tokenId].value = to;
1279         emit Approval(owner, to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev Returns the account approved for `tokenId` token.
1284      *
1285      * Requirements:
1286      *
1287      * - `tokenId` must exist.
1288      */
1289     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1290         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1291 
1292         return _tokenApprovals[tokenId].value;
1293     }
1294 
1295     /**
1296      * @dev Approve or remove `operator` as an operator for the caller.
1297      * Operators can call {transferFrom} or {safeTransferFrom}
1298      * for any token owned by the caller.
1299      *
1300      * Requirements:
1301      *
1302      * - The `operator` cannot be the caller.
1303      *
1304      * Emits an {ApprovalForAll} event.
1305      */
1306     function setApprovalForAll(address operator, bool approved) public virtual override {
1307         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1308         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1309     }
1310 
1311     /**
1312      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1313      *
1314      * See {setApprovalForAll}.
1315      */
1316     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1317         return _operatorApprovals[owner][operator];
1318     }
1319 
1320     /**
1321      * @dev Returns whether `tokenId` exists.
1322      *
1323      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1324      *
1325      * Tokens start existing when they are minted. See {_mint}.
1326      */
1327     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1328         return
1329             _startTokenId() <= tokenId &&
1330             tokenId < _currentIndex && // If within bounds,
1331             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1332     }
1333 
1334     /**
1335      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1336      */
1337     function _isSenderApprovedOrOwner(
1338         address approvedAddress,
1339         address owner,
1340         address msgSender
1341     ) private pure returns (bool result) {
1342         assembly {
1343             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1344             owner := and(owner, _BITMASK_ADDRESS)
1345             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1346             msgSender := and(msgSender, _BITMASK_ADDRESS)
1347             // `msgSender == owner || msgSender == approvedAddress`.
1348             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1349         }
1350     }
1351 
1352     /**
1353      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1354      */
1355     function _getApprovedSlotAndAddress(uint256 tokenId)
1356         private
1357         view
1358         returns (uint256 approvedAddressSlot, address approvedAddress)
1359     {
1360         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1361         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1362         assembly {
1363             approvedAddressSlot := tokenApproval.slot
1364             approvedAddress := sload(approvedAddressSlot)
1365         }
1366     }
1367 
1368     // =============================================================
1369     //                      TRANSFER OPERATIONS
1370     // =============================================================
1371 
1372     /**
1373      * @dev Transfers `tokenId` from `from` to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - `from` cannot be the zero address.
1378      * - `to` cannot be the zero address.
1379      * - `tokenId` token must be owned by `from`.
1380      * - If the caller is not `from`, it must be approved to move this token
1381      * by either {approve} or {setApprovalForAll}.
1382      *
1383      * Emits a {Transfer} event.
1384      */
1385     function transferFrom(
1386         address from,
1387         address to,
1388         uint256 tokenId
1389     ) public payable virtual override {
1390         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1391 
1392         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1393 
1394         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1395 
1396         // The nested ifs save around 20+ gas over a compound boolean condition.
1397         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1398             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1399 
1400         if (to == address(0)) revert TransferToZeroAddress();
1401 
1402         _beforeTokenTransfers(from, to, tokenId, 1);
1403 
1404         // Clear approvals from the previous owner.
1405         assembly {
1406             if approvedAddress {
1407                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1408                 sstore(approvedAddressSlot, 0)
1409             }
1410         }
1411 
1412         // Underflow of the sender's balance is impossible because we check for
1413         // ownership above and the recipient's balance can't realistically overflow.
1414         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1415         unchecked {
1416             // We can directly increment and decrement the balances.
1417             --_packedAddressData[from]; // Updates: `balance -= 1`.
1418             ++_packedAddressData[to]; // Updates: `balance += 1`.
1419 
1420             // Updates:
1421             // - `address` to the next owner.
1422             // - `startTimestamp` to the timestamp of transfering.
1423             // - `burned` to `false`.
1424             // - `nextInitialized` to `true`.
1425             _packedOwnerships[tokenId] = _packOwnershipData(
1426                 to,
1427                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1428             );
1429 
1430             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1431             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1432                 uint256 nextTokenId = tokenId + 1;
1433                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1434                 if (_packedOwnerships[nextTokenId] == 0) {
1435                     // If the next slot is within bounds.
1436                     if (nextTokenId != _currentIndex) {
1437                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1438                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1439                     }
1440                 }
1441             }
1442         }
1443 
1444         emit Transfer(from, to, tokenId);
1445         _afterTokenTransfers(from, to, tokenId, 1);
1446     }
1447 
1448     /**
1449      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1450      */
1451     function safeTransferFrom(
1452         address from,
1453         address to,
1454         uint256 tokenId
1455     ) public payable virtual override {
1456         safeTransferFrom(from, to, tokenId, '');
1457     }
1458 
1459     /**
1460      * @dev Safely transfers `tokenId` token from `from` to `to`.
1461      *
1462      * Requirements:
1463      *
1464      * - `from` cannot be the zero address.
1465      * - `to` cannot be the zero address.
1466      * - `tokenId` token must exist and be owned by `from`.
1467      * - If the caller is not `from`, it must be approved to move this token
1468      * by either {approve} or {setApprovalForAll}.
1469      * - If `to` refers to a smart contract, it must implement
1470      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1471      *
1472      * Emits a {Transfer} event.
1473      */
1474     function safeTransferFrom(
1475         address from,
1476         address to,
1477         uint256 tokenId,
1478         bytes memory _data
1479     ) public payable virtual override {
1480         transferFrom(from, to, tokenId);
1481         if (to.code.length != 0)
1482             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1483                 revert TransferToNonERC721ReceiverImplementer();
1484             }
1485     }
1486 
1487     /**
1488      * @dev Hook that is called before a set of serially-ordered token IDs
1489      * are about to be transferred. This includes minting.
1490      * And also called before burning one token.
1491      *
1492      * `startTokenId` - the first token ID to be transferred.
1493      * `quantity` - the amount to be transferred.
1494      *
1495      * Calling conditions:
1496      *
1497      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1498      * transferred to `to`.
1499      * - When `from` is zero, `tokenId` will be minted for `to`.
1500      * - When `to` is zero, `tokenId` will be burned by `from`.
1501      * - `from` and `to` are never both zero.
1502      */
1503     function _beforeTokenTransfers(
1504         address from,
1505         address to,
1506         uint256 startTokenId,
1507         uint256 quantity
1508     ) internal virtual {}
1509 
1510     /**
1511      * @dev Hook that is called after a set of serially-ordered token IDs
1512      * have been transferred. This includes minting.
1513      * And also called after one token has been burned.
1514      *
1515      * `startTokenId` - the first token ID to be transferred.
1516      * `quantity` - the amount to be transferred.
1517      *
1518      * Calling conditions:
1519      *
1520      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1521      * transferred to `to`.
1522      * - When `from` is zero, `tokenId` has been minted for `to`.
1523      * - When `to` is zero, `tokenId` has been burned by `from`.
1524      * - `from` and `to` are never both zero.
1525      */
1526     function _afterTokenTransfers(
1527         address from,
1528         address to,
1529         uint256 startTokenId,
1530         uint256 quantity
1531     ) internal virtual {}
1532 
1533     /**
1534      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1535      *
1536      * `from` - Previous owner of the given token ID.
1537      * `to` - Target address that will receive the token.
1538      * `tokenId` - Token ID to be transferred.
1539      * `_data` - Optional data to send along with the call.
1540      *
1541      * Returns whether the call correctly returned the expected magic value.
1542      */
1543     function _checkContractOnERC721Received(
1544         address from,
1545         address to,
1546         uint256 tokenId,
1547         bytes memory _data
1548     ) private returns (bool) {
1549         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1550             bytes4 retval
1551         ) {
1552             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1553         } catch (bytes memory reason) {
1554             if (reason.length == 0) {
1555                 revert TransferToNonERC721ReceiverImplementer();
1556             } else {
1557                 assembly {
1558                     revert(add(32, reason), mload(reason))
1559                 }
1560             }
1561         }
1562     }
1563 
1564     // =============================================================
1565     //                        MINT OPERATIONS
1566     // =============================================================
1567 
1568     /**
1569      * @dev Mints `quantity` tokens and transfers them to `to`.
1570      *
1571      * Requirements:
1572      *
1573      * - `to` cannot be the zero address.
1574      * - `quantity` must be greater than 0.
1575      *
1576      * Emits a {Transfer} event for each mint.
1577      */
1578     function _mint(address to, uint256 quantity) internal virtual {
1579         uint256 startTokenId = _currentIndex;
1580         if (quantity == 0) revert MintZeroQuantity();
1581 
1582         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1583 
1584         // Overflows are incredibly unrealistic.
1585         // `balance` and `numberMinted` have a maximum limit of 2**64.
1586         // `tokenId` has a maximum limit of 2**256.
1587         unchecked {
1588             // Updates:
1589             // - `balance += quantity`.
1590             // - `numberMinted += quantity`.
1591             //
1592             // We can directly add to the `balance` and `numberMinted`.
1593             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1594 
1595             // Updates:
1596             // - `address` to the owner.
1597             // - `startTimestamp` to the timestamp of minting.
1598             // - `burned` to `false`.
1599             // - `nextInitialized` to `quantity == 1`.
1600             _packedOwnerships[startTokenId] = _packOwnershipData(
1601                 to,
1602                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1603             );
1604 
1605             uint256 toMasked;
1606             uint256 end = startTokenId + quantity;
1607 
1608             // Use assembly to loop and emit the `Transfer` event for gas savings.
1609             // The duplicated `log4` removes an extra check and reduces stack juggling.
1610             // The assembly, together with the surrounding Solidity code, have been
1611             // delicately arranged to nudge the compiler into producing optimized opcodes.
1612             assembly {
1613                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1614                 toMasked := and(to, _BITMASK_ADDRESS)
1615                 // Emit the `Transfer` event.
1616                 log4(
1617                     0, // Start of data (0, since no data).
1618                     0, // End of data (0, since no data).
1619                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1620                     0, // `address(0)`.
1621                     toMasked, // `to`.
1622                     startTokenId // `tokenId`.
1623                 )
1624 
1625                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1626                 // that overflows uint256 will make the loop run out of gas.
1627                 // The compiler will optimize the `iszero` away for performance.
1628                 for {
1629                     let tokenId := add(startTokenId, 1)
1630                 } iszero(eq(tokenId, end)) {
1631                     tokenId := add(tokenId, 1)
1632                 } {
1633                     // Emit the `Transfer` event. Similar to above.
1634                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1635                 }
1636             }
1637             if (toMasked == 0) revert MintToZeroAddress();
1638 
1639             _currentIndex = end;
1640         }
1641         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1642     }
1643 
1644     /**
1645      * @dev Mints `quantity` tokens and transfers them to `to`.
1646      *
1647      * This function is intended for efficient minting only during contract creation.
1648      *
1649      * It emits only one {ConsecutiveTransfer} as defined in
1650      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1651      * instead of a sequence of {Transfer} event(s).
1652      *
1653      * Calling this function outside of contract creation WILL make your contract
1654      * non-compliant with the ERC721 standard.
1655      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1656      * {ConsecutiveTransfer} event is only permissible during contract creation.
1657      *
1658      * Requirements:
1659      *
1660      * - `to` cannot be the zero address.
1661      * - `quantity` must be greater than 0.
1662      *
1663      * Emits a {ConsecutiveTransfer} event.
1664      */
1665     function _mintERC2309(address to, uint256 quantity) internal virtual {
1666         uint256 startTokenId = _currentIndex;
1667         if (to == address(0)) revert MintToZeroAddress();
1668         if (quantity == 0) revert MintZeroQuantity();
1669         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1670 
1671         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1672 
1673         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1674         unchecked {
1675             // Updates:
1676             // - `balance += quantity`.
1677             // - `numberMinted += quantity`.
1678             //
1679             // We can directly add to the `balance` and `numberMinted`.
1680             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1681 
1682             // Updates:
1683             // - `address` to the owner.
1684             // - `startTimestamp` to the timestamp of minting.
1685             // - `burned` to `false`.
1686             // - `nextInitialized` to `quantity == 1`.
1687             _packedOwnerships[startTokenId] = _packOwnershipData(
1688                 to,
1689                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1690             );
1691 
1692             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1693 
1694             _currentIndex = startTokenId + quantity;
1695         }
1696         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1697     }
1698 
1699     /**
1700      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1701      *
1702      * Requirements:
1703      *
1704      * - If `to` refers to a smart contract, it must implement
1705      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1706      * - `quantity` must be greater than 0.
1707      *
1708      * See {_mint}.
1709      *
1710      * Emits a {Transfer} event for each mint.
1711      */
1712     function _safeMint(
1713         address to,
1714         uint256 quantity,
1715         bytes memory _data
1716     ) internal virtual {
1717         _mint(to, quantity);
1718 
1719         unchecked {
1720             if (to.code.length != 0) {
1721                 uint256 end = _currentIndex;
1722                 uint256 index = end - quantity;
1723                 do {
1724                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1725                         revert TransferToNonERC721ReceiverImplementer();
1726                     }
1727                 } while (index < end);
1728                 // Reentrancy protection.
1729                 if (_currentIndex != end) revert();
1730             }
1731         }
1732     }
1733 
1734     /**
1735      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1736      */
1737     function _safeMint(address to, uint256 quantity) internal virtual {
1738         _safeMint(to, quantity, '');
1739     }
1740 
1741     // =============================================================
1742     //                        BURN OPERATIONS
1743     // =============================================================
1744 
1745     /**
1746      * @dev Equivalent to `_burn(tokenId, false)`.
1747      */
1748     function _burn(uint256 tokenId) internal virtual {
1749         _burn(tokenId, false);
1750     }
1751 
1752     /**
1753      * @dev Destroys `tokenId`.
1754      * The approval is cleared when the token is burned.
1755      *
1756      * Requirements:
1757      *
1758      * - `tokenId` must exist.
1759      *
1760      * Emits a {Transfer} event.
1761      */
1762     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1763         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1764 
1765         address from = address(uint160(prevOwnershipPacked));
1766 
1767         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1768 
1769         if (approvalCheck) {
1770             // The nested ifs save around 20+ gas over a compound boolean condition.
1771             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1772                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1773         }
1774 
1775         _beforeTokenTransfers(from, address(0), tokenId, 1);
1776 
1777         // Clear approvals from the previous owner.
1778         assembly {
1779             if approvedAddress {
1780                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1781                 sstore(approvedAddressSlot, 0)
1782             }
1783         }
1784 
1785         // Underflow of the sender's balance is impossible because we check for
1786         // ownership above and the recipient's balance can't realistically overflow.
1787         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1788         unchecked {
1789             // Updates:
1790             // - `balance -= 1`.
1791             // - `numberBurned += 1`.
1792             //
1793             // We can directly decrement the balance, and increment the number burned.
1794             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1795             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1796 
1797             // Updates:
1798             // - `address` to the last owner.
1799             // - `startTimestamp` to the timestamp of burning.
1800             // - `burned` to `true`.
1801             // - `nextInitialized` to `true`.
1802             _packedOwnerships[tokenId] = _packOwnershipData(
1803                 from,
1804                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1805             );
1806 
1807             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1808             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1809                 uint256 nextTokenId = tokenId + 1;
1810                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1811                 if (_packedOwnerships[nextTokenId] == 0) {
1812                     // If the next slot is within bounds.
1813                     if (nextTokenId != _currentIndex) {
1814                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1815                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1816                     }
1817                 }
1818             }
1819         }
1820 
1821         emit Transfer(from, address(0), tokenId);
1822         _afterTokenTransfers(from, address(0), tokenId, 1);
1823 
1824         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1825         unchecked {
1826             _burnCounter++;
1827         }
1828     }
1829 
1830     // =============================================================
1831     //                     EXTRA DATA OPERATIONS
1832     // =============================================================
1833 
1834     /**
1835      * @dev Directly sets the extra data for the ownership data `index`.
1836      */
1837     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1838         uint256 packed = _packedOwnerships[index];
1839         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1840         uint256 extraDataCasted;
1841         // Cast `extraData` with assembly to avoid redundant masking.
1842         assembly {
1843             extraDataCasted := extraData
1844         }
1845         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1846         _packedOwnerships[index] = packed;
1847     }
1848 
1849     /**
1850      * @dev Called during each token transfer to set the 24bit `extraData` field.
1851      * Intended to be overridden by the cosumer contract.
1852      *
1853      * `previousExtraData` - the value of `extraData` before transfer.
1854      *
1855      * Calling conditions:
1856      *
1857      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1858      * transferred to `to`.
1859      * - When `from` is zero, `tokenId` will be minted for `to`.
1860      * - When `to` is zero, `tokenId` will be burned by `from`.
1861      * - `from` and `to` are never both zero.
1862      */
1863     function _extraData(
1864         address from,
1865         address to,
1866         uint24 previousExtraData
1867     ) internal view virtual returns (uint24) {}
1868 
1869     /**
1870      * @dev Returns the next extra data for the packed ownership data.
1871      * The returned result is shifted into position.
1872      */
1873     function _nextExtraData(
1874         address from,
1875         address to,
1876         uint256 prevOwnershipPacked
1877     ) private view returns (uint256) {
1878         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1879         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1880     }
1881 
1882     // =============================================================
1883     //                       OTHER OPERATIONS
1884     // =============================================================
1885 
1886     /**
1887      * @dev Returns the message sender (defaults to `msg.sender`).
1888      *
1889      * If you are writing GSN compatible contracts, you need to override this function.
1890      */
1891     function _msgSenderERC721A() internal view virtual returns (address) {
1892         return msg.sender;
1893     }
1894 
1895     /**
1896      * @dev Converts a uint256 to its ASCII string decimal representation.
1897      */
1898     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1899         assembly {
1900             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1901             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1902             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1903             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1904             let m := add(mload(0x40), 0xa0)
1905             // Update the free memory pointer to allocate.
1906             mstore(0x40, m)
1907             // Assign the `str` to the end.
1908             str := sub(m, 0x20)
1909             // Zeroize the slot after the string.
1910             mstore(str, 0)
1911 
1912             // Cache the end of the memory to calculate the length later.
1913             let end := str
1914 
1915             // We write the string from rightmost digit to leftmost digit.
1916             // The following is essentially a do-while loop that also handles the zero case.
1917             // prettier-ignore
1918             for { let temp := value } 1 {} {
1919                 str := sub(str, 1)
1920                 // Write the character to the pointer.
1921                 // The ASCII index of the '0' character is 48.
1922                 mstore8(str, add(48, mod(temp, 10)))
1923                 // Keep dividing `temp` until zero.
1924                 temp := div(temp, 10)
1925                 // prettier-ignore
1926                 if iszero(temp) { break }
1927             }
1928 
1929             let length := sub(end, str)
1930             // Move the pointer 32 bytes leftwards to make room for the length.
1931             str := sub(str, 0x20)
1932             // Store the length.
1933             mstore(str, length)
1934         }
1935     }
1936 }
1937 
1938 // File: contracts/contracts/RINGERPUNKS.sol
1939 
1940 //SPDX-License-Identifier: Unlicense
1941 pragma solidity ^0.8.20;
1942 
1943 
1944 
1945 
1946 
1947 //I AM PUNK
1948 contract RingerPunks is ERC721A, ERC2981, DefaultOperatorFilterer, Ownable {
1949 
1950     uint256 public constant MAX_SUPPLY = 5555;
1951     uint256 public constant PRICE = 0.003 ether;
1952     uint256 public constant MAX_PER_WALLET = 5;
1953 
1954     string private baseUri;
1955     bool public isMintActive = false;
1956 
1957     constructor(
1958         string memory _baseUri
1959     ) ERC721A("RingerPunks", "RNGRP") {
1960         _mint(msg.sender, 1);
1961         baseUri = _baseUri;
1962         setDefaultRoyalty(msg.sender, 500);
1963     }
1964 
1965     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1966         super.setApprovalForAll(operator, approved);
1967     }
1968 
1969     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1970         super.approve(operator, tokenId);
1971     }
1972 
1973     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1974         super.transferFrom(from, to, tokenId);
1975     }
1976 
1977     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1978         super.safeTransferFrom(from, to, tokenId);
1979     }
1980 
1981     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
1982         super.safeTransferFrom(from, to, tokenId, data);
1983     }
1984 
1985     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool){
1986         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
1987     }
1988 
1989     //puUUUUUUUUUUUUUUUUUUUUUUNK miNt
1990     function mint(uint256 mintAmount) public payable {
1991         require(msg.sender == tx.origin, "No contracts");
1992         require(isMintActive, "Sale not active");
1993         require(_totalMinted() + mintAmount <= MAX_SUPPLY, "Exceeds max supply");
1994         require(balanceOf(msg.sender) + mintAmount <= MAX_PER_WALLET, "Exceeds max per wallet");
1995         uint256 _quantity = mintAmount;
1996         uint256 freeMinted = _getAux(msg.sender);
1997         if (freeMinted < 1) {
1998             _quantity = mintAmount - 1;
1999             _setAux(msg.sender, 1);
2000         }
2001         if (_quantity > 0) {
2002             require(PRICE * _quantity <= msg.value,"Insufficient funds sent");
2003         }
2004         _mint(msg.sender, mintAmount);
2005     }
2006 
2007     function _startTokenId() internal view virtual override returns (uint256) {
2008         return 1;
2009     }
2010 
2011     function _baseURI() internal view override returns (string memory) {
2012         return baseUri;
2013     }
2014 
2015     function withdrawAll() external onlyOwner {
2016         (bool os, ) = payable(msg.sender).call{value: address(this).balance}("");
2017         require(os);
2018     }
2019 
2020     function setBaseUri(string memory _uri) external onlyOwner {
2021         baseUri = _uri;
2022     }
2023 
2024     function setMintActive(bool mintState) external onlyOwner {
2025         isMintActive = mintState;
2026     }
2027 
2028     function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
2029         _setDefaultRoyalty(receiver, feeNumerator);
2030     }
2031 
2032     function deleteDefaultRoyalty() public onlyOwner {
2033         _deleteDefaultRoyalty();
2034     }
2035 }