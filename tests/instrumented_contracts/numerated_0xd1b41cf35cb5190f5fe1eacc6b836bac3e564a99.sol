1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
81 
82 
83 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Interface of the ERC20 standard as defined in the EIP.
89  */
90 interface IERC20 {
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `to`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transfer(address to, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through {transferFrom}. This is
127      * zero by default.
128      *
129      * This value changes when {approve} or {transferFrom} are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     /**
134      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * IMPORTANT: Beware that changing an allowance with this method brings the risk
139      * that someone may use both the old and the new allowance by unfortunate
140      * transaction ordering. One possible solution to mitigate this race
141      * condition is to first reduce the spender's allowance to 0 and set the
142      * desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address spender, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Moves `amount` tokens from `from` to `to` using the
151      * allowance mechanism. `amount` is then deducted from the caller's
152      * allowance.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transferFrom(
159         address from,
160         address to,
161         uint256 amount
162     ) external returns (bool);
163 }
164 
165 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Interface of the ERC165 standard, as defined in the
174  * https://eips.ethereum.org/EIPS/eip-165[EIP].
175  *
176  * Implementers can declare support of contract interfaces, which can then be
177  * queried by others ({ERC165Checker}).
178  *
179  * For an implementation, see {ERC165}.
180  */
181 interface IERC165 {
182     /**
183      * @dev Returns true if this contract implements the interface defined by
184      * `interfaceId`. See the corresponding
185      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
186      * to learn more about how these ids are created.
187      *
188      * This function call must use less than 30 000 gas.
189      */
190     function supportsInterface(bytes4 interfaceId) external view returns (bool);
191 }
192 
193 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
194 
195 
196 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
197 
198 pragma solidity ^0.8.0;
199 
200 
201 /**
202  * @dev Implementation of the {IERC165} interface.
203  *
204  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
205  * for the additional interface id that will be supported. For example:
206  *
207  * ```solidity
208  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
209  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
210  * }
211  * ```
212  *
213  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
214  */
215 abstract contract ERC165 is IERC165 {
216     /**
217      * @dev See {IERC165-supportsInterface}.
218      */
219     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
220         return interfaceId == type(IERC165).interfaceId;
221     }
222 }
223 
224 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC2981.sol
225 
226 
227 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 
232 /**
233  * @dev Interface for the NFT Royalty Standard.
234  *
235  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
236  * support for royalty payments across all NFT marketplaces and ecosystem participants.
237  *
238  * _Available since v4.5._
239  */
240 interface IERC2981 is IERC165 {
241     /**
242      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
243      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
244      */
245     function royaltyInfo(
246         uint256 tokenId,
247         uint256 salePrice
248     ) external view returns (address receiver, uint256 royaltyAmount);
249 }
250 
251 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/common/ERC2981.sol
252 
253 
254 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 
259 
260 /**
261  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
262  *
263  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
264  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
265  *
266  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
267  * fee is specified in basis points by default.
268  *
269  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
270  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
271  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
272  *
273  * _Available since v4.5._
274  */
275 abstract contract ERC2981 is IERC2981, ERC165 {
276     struct RoyaltyInfo {
277         address receiver;
278         uint96 royaltyFraction;
279     }
280 
281     RoyaltyInfo private _defaultRoyaltyInfo;
282     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
283 
284     /**
285      * @dev See {IERC165-supportsInterface}.
286      */
287     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
288         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
289     }
290 
291     /**
292      * @inheritdoc IERC2981
293      */
294     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
295         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
296 
297         if (royalty.receiver == address(0)) {
298             royalty = _defaultRoyaltyInfo;
299         }
300 
301         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
302 
303         return (royalty.receiver, royaltyAmount);
304     }
305 
306     /**
307      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
308      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
309      * override.
310      */
311     function _feeDenominator() internal pure virtual returns (uint96) {
312         return 10000;
313     }
314 
315     /**
316      * @dev Sets the royalty information that all ids in this contract will default to.
317      *
318      * Requirements:
319      *
320      * - `receiver` cannot be the zero address.
321      * - `feeNumerator` cannot be greater than the fee denominator.
322      */
323     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
324         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
325         require(receiver != address(0), "ERC2981: invalid receiver");
326 
327         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
328     }
329 
330     /**
331      * @dev Removes default royalty information.
332      */
333     function _deleteDefaultRoyalty() internal virtual {
334         delete _defaultRoyaltyInfo;
335     }
336 
337     /**
338      * @dev Sets the royalty information for a specific token id, overriding the global default.
339      *
340      * Requirements:
341      *
342      * - `receiver` cannot be the zero address.
343      * - `feeNumerator` cannot be greater than the fee denominator.
344      */
345     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
346         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
347         require(receiver != address(0), "ERC2981: Invalid parameters");
348 
349         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
350     }
351 
352     /**
353      * @dev Resets royalty information for the token id back to the global default.
354      */
355     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
356         delete _tokenRoyaltyInfo[tokenId];
357     }
358 }
359 
360 // File: operator-filter-registry/src/lib/Constants.sol
361 
362 
363 pragma solidity ^0.8.17;
364 
365 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
366 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
367 
368 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
369 
370 
371 pragma solidity ^0.8.13;
372 
373 interface IOperatorFilterRegistry {
374     /**
375      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
376      *         true if supplied registrant address is not registered.
377      */
378     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
379 
380     /**
381      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
382      */
383     function register(address registrant) external;
384 
385     /**
386      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
387      */
388     function registerAndSubscribe(address registrant, address subscription) external;
389 
390     /**
391      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
392      *         address without subscribing.
393      */
394     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
395 
396     /**
397      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
398      *         Note that this does not remove any filtered addresses or codeHashes.
399      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
400      */
401     function unregister(address addr) external;
402 
403     /**
404      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
405      */
406     function updateOperator(address registrant, address operator, bool filtered) external;
407 
408     /**
409      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
410      */
411     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
412 
413     /**
414      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
415      */
416     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
417 
418     /**
419      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
420      */
421     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
422 
423     /**
424      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
425      *         subscription if present.
426      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
427      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
428      *         used.
429      */
430     function subscribe(address registrant, address registrantToSubscribe) external;
431 
432     /**
433      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
434      */
435     function unsubscribe(address registrant, bool copyExistingEntries) external;
436 
437     /**
438      * @notice Get the subscription address of a given registrant, if any.
439      */
440     function subscriptionOf(address addr) external returns (address registrant);
441 
442     /**
443      * @notice Get the set of addresses subscribed to a given registrant.
444      *         Note that order is not guaranteed as updates are made.
445      */
446     function subscribers(address registrant) external returns (address[] memory);
447 
448     /**
449      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
450      *         Note that order is not guaranteed as updates are made.
451      */
452     function subscriberAt(address registrant, uint256 index) external returns (address);
453 
454     /**
455      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
456      */
457     function copyEntriesOf(address registrant, address registrantToCopy) external;
458 
459     /**
460      * @notice Returns true if operator is filtered by a given address or its subscription.
461      */
462     function isOperatorFiltered(address registrant, address operator) external returns (bool);
463 
464     /**
465      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
466      */
467     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
468 
469     /**
470      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
471      */
472     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
473 
474     /**
475      * @notice Returns a list of filtered operators for a given address or its subscription.
476      */
477     function filteredOperators(address addr) external returns (address[] memory);
478 
479     /**
480      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
481      *         Note that order is not guaranteed as updates are made.
482      */
483     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
484 
485     /**
486      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
487      *         its subscription.
488      *         Note that order is not guaranteed as updates are made.
489      */
490     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
491 
492     /**
493      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
494      *         its subscription.
495      *         Note that order is not guaranteed as updates are made.
496      */
497     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
498 
499     /**
500      * @notice Returns true if an address has registered
501      */
502     function isRegistered(address addr) external returns (bool);
503 
504     /**
505      * @dev Convenience method to compute the code hash of an arbitrary contract
506      */
507     function codeHashOf(address addr) external returns (bytes32);
508 }
509 
510 // File: operator-filter-registry/src/OperatorFilterer.sol
511 
512 
513 pragma solidity ^0.8.13;
514 
515 
516 /**
517  * @title  OperatorFilterer
518  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
519  *         registrant's entries in the OperatorFilterRegistry.
520  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
521  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
522  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
523  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
524  *         administration methods on the contract itself to interact with the registry otherwise the subscription
525  *         will be locked to the options set during construction.
526  */
527 
528 abstract contract OperatorFilterer {
529     /// @dev Emitted when an operator is not allowed.
530     error OperatorNotAllowed(address operator);
531 
532     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
533         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
534 
535     /// @dev The constructor that is called when the contract is being deployed.
536     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
537         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
538         // will not revert, but the contract will need to be registered with the registry once it is deployed in
539         // order for the modifier to filter addresses.
540         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
541             if (subscribe) {
542                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
543             } else {
544                 if (subscriptionOrRegistrantToCopy != address(0)) {
545                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
546                 } else {
547                     OPERATOR_FILTER_REGISTRY.register(address(this));
548                 }
549             }
550         }
551     }
552 
553     /**
554      * @dev A helper function to check if an operator is allowed.
555      */
556     modifier onlyAllowedOperator(address from) virtual {
557         // Allow spending tokens from addresses with balance
558         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
559         // from an EOA.
560         if (from != msg.sender) {
561             _checkFilterOperator(msg.sender);
562         }
563         _;
564     }
565 
566     /**
567      * @dev A helper function to check if an operator approval is allowed.
568      */
569     modifier onlyAllowedOperatorApproval(address operator) virtual {
570         _checkFilterOperator(operator);
571         _;
572     }
573 
574     /**
575      * @dev A helper function to check if an operator is allowed.
576      */
577     function _checkFilterOperator(address operator) internal view virtual {
578         // Check registry code length to facilitate testing in environments without a deployed registry.
579         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
580             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
581             // may specify their own OperatorFilterRegistry implementations, which may behave differently
582             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
583                 revert OperatorNotAllowed(operator);
584             }
585         }
586     }
587 }
588 
589 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
590 
591 
592 pragma solidity ^0.8.13;
593 
594 
595 /**
596  * @title  DefaultOperatorFilterer
597  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
598  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
599  *         administration methods on the contract itself to interact with the registry otherwise the subscription
600  *         will be locked to the options set during construction.
601  */
602 
603 abstract contract DefaultOperatorFilterer is OperatorFilterer {
604     /// @dev The constructor that is called when the contract is being deployed.
605     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
606 }
607 
608 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
609 
610 
611 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @dev Provides information about the current execution context, including the
617  * sender of the transaction and its data. While these are generally available
618  * via msg.sender and msg.data, they should not be accessed in such a direct
619  * manner, since when dealing with meta-transactions the account sending and
620  * paying for execution may not be the actual sender (as far as an application
621  * is concerned).
622  *
623  * This contract is only required for intermediate, library-like contracts.
624  */
625 abstract contract Context {
626     function _msgSender() internal view virtual returns (address) {
627         return msg.sender;
628     }
629 
630     function _msgData() internal view virtual returns (bytes calldata) {
631         return msg.data;
632     }
633 }
634 
635 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
636 
637 
638 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @dev Contract module which provides a basic access control mechanism, where
645  * there is an account (an owner) that can be granted exclusive access to
646  * specific functions.
647  *
648  * By default, the owner account will be the one that deploys the contract. This
649  * can later be changed with {transferOwnership}.
650  *
651  * This module is used through inheritance. It will make available the modifier
652  * `onlyOwner`, which can be applied to your functions to restrict their use to
653  * the owner.
654  */
655 abstract contract Ownable is Context {
656     address private _owner;
657 
658     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
659 
660     /**
661      * @dev Initializes the contract setting the deployer as the initial owner.
662      */
663     constructor() {
664         _transferOwnership(_msgSender());
665     }
666 
667     /**
668      * @dev Throws if called by any account other than the owner.
669      */
670     modifier onlyOwner() {
671         _checkOwner();
672         _;
673     }
674 
675     /**
676      * @dev Returns the address of the current owner.
677      */
678     function owner() public view virtual returns (address) {
679         return _owner;
680     }
681 
682     /**
683      * @dev Throws if the sender is not the owner.
684      */
685     function _checkOwner() internal view virtual {
686         require(owner() == _msgSender(), "Ownable: caller is not the owner");
687     }
688 
689     /**
690      * @dev Leaves the contract without owner. It will not be possible to call
691      * `onlyOwner` functions anymore. Can only be called by the current owner.
692      *
693      * NOTE: Renouncing ownership will leave the contract without an owner,
694      * thereby removing any functionality that is only available to the owner.
695      */
696     function renounceOwnership() public virtual onlyOwner {
697         _transferOwnership(address(0));
698     }
699 
700     /**
701      * @dev Transfers ownership of the contract to a new account (`newOwner`).
702      * Can only be called by the current owner.
703      */
704     function transferOwnership(address newOwner) public virtual onlyOwner {
705         require(newOwner != address(0), "Ownable: new owner is the zero address");
706         _transferOwnership(newOwner);
707     }
708 
709     /**
710      * @dev Transfers ownership of the contract to a new account (`newOwner`).
711      * Internal function without access restriction.
712      */
713     function _transferOwnership(address newOwner) internal virtual {
714         address oldOwner = _owner;
715         _owner = newOwner;
716         emit OwnershipTransferred(oldOwner, newOwner);
717     }
718 }
719 
720 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
721 
722 
723 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 /**
728  * @dev These functions deal with verification of Merkle Tree proofs.
729  *
730  * The tree and the proofs can be generated using our
731  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
732  * You will find a quickstart guide in the readme.
733  *
734  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
735  * hashing, or use a hash function other than keccak256 for hashing leaves.
736  * This is because the concatenation of a sorted pair of internal nodes in
737  * the merkle tree could be reinterpreted as a leaf value.
738  * OpenZeppelin's JavaScript library generates merkle trees that are safe
739  * against this attack out of the box.
740  */
741 library MerkleProof {
742     /**
743      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
744      * defined by `root`. For this, a `proof` must be provided, containing
745      * sibling hashes on the branch from the leaf to the root of the tree. Each
746      * pair of leaves and each pair of pre-images are assumed to be sorted.
747      */
748     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
749         return processProof(proof, leaf) == root;
750     }
751 
752     /**
753      * @dev Calldata version of {verify}
754      *
755      * _Available since v4.7._
756      */
757     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
758         return processProofCalldata(proof, leaf) == root;
759     }
760 
761     /**
762      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
763      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
764      * hash matches the root of the tree. When processing the proof, the pairs
765      * of leafs & pre-images are assumed to be sorted.
766      *
767      * _Available since v4.4._
768      */
769     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
770         bytes32 computedHash = leaf;
771         for (uint256 i = 0; i < proof.length; i++) {
772             computedHash = _hashPair(computedHash, proof[i]);
773         }
774         return computedHash;
775     }
776 
777     /**
778      * @dev Calldata version of {processProof}
779      *
780      * _Available since v4.7._
781      */
782     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
783         bytes32 computedHash = leaf;
784         for (uint256 i = 0; i < proof.length; i++) {
785             computedHash = _hashPair(computedHash, proof[i]);
786         }
787         return computedHash;
788     }
789 
790     /**
791      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
792      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
793      *
794      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
795      *
796      * _Available since v4.7._
797      */
798     function multiProofVerify(
799         bytes32[] memory proof,
800         bool[] memory proofFlags,
801         bytes32 root,
802         bytes32[] memory leaves
803     ) internal pure returns (bool) {
804         return processMultiProof(proof, proofFlags, leaves) == root;
805     }
806 
807     /**
808      * @dev Calldata version of {multiProofVerify}
809      *
810      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
811      *
812      * _Available since v4.7._
813      */
814     function multiProofVerifyCalldata(
815         bytes32[] calldata proof,
816         bool[] calldata proofFlags,
817         bytes32 root,
818         bytes32[] memory leaves
819     ) internal pure returns (bool) {
820         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
821     }
822 
823     /**
824      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
825      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
826      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
827      * respectively.
828      *
829      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
830      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
831      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
832      *
833      * _Available since v4.7._
834      */
835     function processMultiProof(
836         bytes32[] memory proof,
837         bool[] memory proofFlags,
838         bytes32[] memory leaves
839     ) internal pure returns (bytes32 merkleRoot) {
840         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
841         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
842         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
843         // the merkle tree.
844         uint256 leavesLen = leaves.length;
845         uint256 totalHashes = proofFlags.length;
846 
847         // Check proof validity.
848         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
849 
850         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
851         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
852         bytes32[] memory hashes = new bytes32[](totalHashes);
853         uint256 leafPos = 0;
854         uint256 hashPos = 0;
855         uint256 proofPos = 0;
856         // At each step, we compute the next hash using two values:
857         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
858         //   get the next hash.
859         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
860         //   `proof` array.
861         for (uint256 i = 0; i < totalHashes; i++) {
862             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
863             bytes32 b = proofFlags[i]
864                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
865                 : proof[proofPos++];
866             hashes[i] = _hashPair(a, b);
867         }
868 
869         if (totalHashes > 0) {
870             unchecked {
871                 return hashes[totalHashes - 1];
872             }
873         } else if (leavesLen > 0) {
874             return leaves[0];
875         } else {
876             return proof[0];
877         }
878     }
879 
880     /**
881      * @dev Calldata version of {processMultiProof}.
882      *
883      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
884      *
885      * _Available since v4.7._
886      */
887     function processMultiProofCalldata(
888         bytes32[] calldata proof,
889         bool[] calldata proofFlags,
890         bytes32[] memory leaves
891     ) internal pure returns (bytes32 merkleRoot) {
892         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
893         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
894         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
895         // the merkle tree.
896         uint256 leavesLen = leaves.length;
897         uint256 totalHashes = proofFlags.length;
898 
899         // Check proof validity.
900         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
901 
902         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
903         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
904         bytes32[] memory hashes = new bytes32[](totalHashes);
905         uint256 leafPos = 0;
906         uint256 hashPos = 0;
907         uint256 proofPos = 0;
908         // At each step, we compute the next hash using two values:
909         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
910         //   get the next hash.
911         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
912         //   `proof` array.
913         for (uint256 i = 0; i < totalHashes; i++) {
914             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
915             bytes32 b = proofFlags[i]
916                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
917                 : proof[proofPos++];
918             hashes[i] = _hashPair(a, b);
919         }
920 
921         if (totalHashes > 0) {
922             unchecked {
923                 return hashes[totalHashes - 1];
924             }
925         } else if (leavesLen > 0) {
926             return leaves[0];
927         } else {
928             return proof[0];
929         }
930     }
931 
932     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
933         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
934     }
935 
936     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
937         /// @solidity memory-safe-assembly
938         assembly {
939             mstore(0x00, a)
940             mstore(0x20, b)
941             value := keccak256(0x00, 0x40)
942         }
943     }
944 }
945 
946 // File: contracts/Nft_Staking.sol
947 
948 
949 // ERC721A Contracts v4.2.3
950 // Creator: Chiru Labs
951 
952 pragma solidity ^0.8.4;
953 
954 interface IERC721A {
955     /**
956      * The caller must own the token or be an approved operator.
957      */
958     error ApprovalCallerNotOwnerNorApproved();
959 
960     /**
961      * The token does not exist.
962      */
963     error ApprovalQueryForNonexistentToken();
964 
965     /**
966      * Cannot query the balance for the zero address.
967      */
968     error BalanceQueryForZeroAddress();
969 
970     /**
971      * Cannot mint to the zero address.
972      */
973     error MintToZeroAddress();
974 
975     /**
976      * The quantity of tokens minted must be more than zero.
977      */
978     error MintZeroQuantity();
979 
980     /**
981      * The token does not exist.
982      */
983     error OwnerQueryForNonexistentToken();
984 
985     /**
986      * The caller must own the token or be an approved operator.
987      */
988     error TransferCallerNotOwnerNorApproved();
989 
990     /**
991      * The token must be owned by `from`.
992      */
993     error TransferFromIncorrectOwner();
994 
995     /**
996      * Cannot safely transfer to a contract that does not implement the
997      * ERC721Receiver interface.
998      */
999     error TransferToNonERC721ReceiverImplementer();
1000 
1001     /**
1002      * Cannot transfer to the zero address.
1003      */
1004     error TransferToZeroAddress();
1005 
1006     /**
1007      * The token does not exist.
1008      */
1009     error URIQueryForNonexistentToken();
1010 
1011     /**
1012      * The `quantity` minted with ERC2309 exceeds the safety limit.
1013      */
1014     error MintERC2309QuantityExceedsLimit();
1015 
1016     /**
1017      * The `extraData` cannot be set on an unintialized ownership slot.
1018      */
1019     error OwnershipNotInitializedForExtraData();
1020 
1021     // =============================================================
1022     //                            STRUCTS
1023     // =============================================================
1024 
1025     struct TokenOwnership {
1026         // The address of the owner.
1027         address addr;
1028         // Stores the start time of ownership with minimal overhead for tokenomics.
1029         uint64 startTimestamp;
1030         // Whether the token has been burned.
1031         bool burned;
1032         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1033         uint24 extraData;
1034     }
1035 
1036     // =============================================================
1037     //                         TOKEN COUNTERS
1038     // =============================================================
1039 
1040     /**
1041      * @dev Returns the total number of tokens in existence.
1042      * Burned tokens will reduce the count.
1043      * To get the total number of tokens minted, please see {_totalMinted}.
1044      */
1045     function totalSupply() external view returns (uint256);
1046 
1047     // =============================================================
1048     //                            IERC165
1049     // =============================================================
1050 
1051     /**
1052      * @dev Returns true if this contract implements the interface defined by
1053      * `interfaceId`. See the corresponding
1054      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1055      * to learn more about how these ids are created.
1056      *
1057      * This function call must use less than 30000 gas.
1058      */
1059     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1060 
1061     // =============================================================
1062     //                            IERC721
1063     // =============================================================
1064 
1065     /**
1066      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1067      */
1068     event Transfer(
1069         address indexed from,
1070         address indexed to,
1071         uint256 indexed tokenId
1072     );
1073 
1074     /**
1075      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1076      */
1077     event Approval(
1078         address indexed owner,
1079         address indexed approved,
1080         uint256 indexed tokenId
1081     );
1082 
1083     /**
1084      * @dev Emitted when `owner` enables or disables
1085      * (`approved`) `operator` to manage all of its assets.
1086      */
1087     event ApprovalForAll(
1088         address indexed owner,
1089         address indexed operator,
1090         bool approved
1091     );
1092 
1093     /**
1094      * @dev Returns the number of tokens in `owner`'s account.
1095      */
1096     function balanceOf(address owner) external view returns (uint256 balance);
1097 
1098     /**
1099      * @dev Returns the owner of the `tokenId` token.
1100      *
1101      * Requirements:
1102      *
1103      * - `tokenId` must exist.
1104      */
1105     function ownerOf(uint256 tokenId) external view returns (address owner);
1106 
1107     /**
1108      * @dev Safely transfers `tokenId` token from `from` to `to`,
1109      * checking first that contract recipients are aware of the ERC721 protocol
1110      * to prevent tokens from being forever locked.
1111      *
1112      * Requirements:
1113      *
1114      * - `from` cannot be the zero address.
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must exist and be owned by `from`.
1117      * - If the caller is not `from`, it must be have been allowed to move
1118      * this token by either {approve} or {setApprovalForAll}.
1119      * - If `to` refers to a smart contract, it must implement
1120      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function safeTransferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId,
1128         bytes calldata data
1129     ) external payable;
1130 
1131     /**
1132      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1133      */
1134     function safeTransferFrom(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) external payable;
1139 
1140     /**
1141      * @dev Transfers `tokenId` from `from` to `to`.
1142      *
1143      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1144      * whenever possible.
1145      *
1146      * Requirements:
1147      *
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must be owned by `from`.
1151      * - If the caller is not `from`, it must be approved to move this token
1152      * by either {approve} or {setApprovalForAll}.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function transferFrom(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) external payable;
1161 
1162     /**
1163      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1164      * The approval is cleared when the token is transferred.
1165      *
1166      * Only a single account can be approved at a time, so approving the
1167      * zero address clears previous approvals.
1168      *
1169      * Requirements:
1170      *
1171      * - The caller must own the token or be an approved operator.
1172      * - `tokenId` must exist.
1173      *
1174      * Emits an {Approval} event.
1175      */
1176     function approve(address to, uint256 tokenId) external payable;
1177 
1178     /**
1179      * @dev Approve or remove `operator` as an operator for the caller.
1180      * Operators can call {transferFrom} or {safeTransferFrom}
1181      * for any token owned by the caller.
1182      *
1183      * Requirements:
1184      *
1185      * - The `operator` cannot be the caller.
1186      *
1187      * Emits an {ApprovalForAll} event.
1188      */
1189     function setApprovalForAll(address operator, bool _approved) external;
1190 
1191     /**
1192      * @dev Returns the account approved for `tokenId` token.
1193      *
1194      * Requirements:
1195      *
1196      * - `tokenId` must exist.
1197      */
1198     function getApproved(uint256 tokenId)
1199         external
1200         view
1201         returns (address operator);
1202 
1203     /**
1204      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1205      *
1206      * See {setApprovalForAll}.
1207      */
1208     function isApprovedForAll(address owner, address operator)
1209         external
1210         view
1211         returns (bool);
1212 
1213     // =============================================================
1214     //                        IERC721Metadata
1215     // =============================================================
1216 
1217     /**
1218      * @dev Returns the token collection name.
1219      */
1220     function name() external view returns (string memory);
1221 
1222     /**
1223      * @dev Returns the token collection symbol.
1224      */
1225     function symbol() external view returns (string memory);
1226 
1227     /**
1228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1229      */
1230     function tokenURI(uint256 tokenId) external view returns (string memory);
1231 
1232     // =============================================================
1233     //                           IERC2309
1234     // =============================================================
1235 
1236     /**
1237      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1238      * (inclusive) is transferred from `from` to `to`, as defined in the
1239      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1240      *
1241      * See {_mintERC2309} for more details.
1242      */
1243     event ConsecutiveTransfer(
1244         uint256 indexed fromTokenId,
1245         uint256 toTokenId,
1246         address indexed from,
1247         address indexed to
1248     );
1249 }
1250 
1251 /**
1252  * @dev Interface of ERC721 token receiver.
1253  */
1254 interface ERC721A__IERC721Receiver {
1255     function onERC721Received(
1256         address operator,
1257         address from,
1258         uint256 tokenId,
1259         bytes calldata data
1260     ) external returns (bytes4);
1261 }
1262 
1263 /**
1264  * @title ERC721A
1265  *
1266  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1267  * Non-Fungible Token Standard, including the Metadata extension.
1268  * Optimized for lower gas during batch mints.
1269  *
1270  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1271  * starting from `_startTokenId()`.
1272  *
1273  * Assumptions:
1274  *
1275  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1276  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1277  */
1278 contract ERC721A is IERC721A {
1279     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1280     struct TokenApprovalRef {
1281         address value;
1282     }
1283 
1284     // =============================================================
1285     //                           CONSTANTS
1286     // =============================================================
1287 
1288     // Mask of an entry in packed address data.
1289     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1290 
1291     // The bit position of `numberMinted` in packed address data.
1292     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1293 
1294     // The bit position of `numberBurned` in packed address data.
1295     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1296 
1297     // The bit position of `aux` in packed address data.
1298     uint256 private constant _BITPOS_AUX = 192;
1299 
1300     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1301     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1302 
1303     // The bit position of `startTimestamp` in packed ownership.
1304     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1305 
1306     // The bit mask of the `burned` bit in packed ownership.
1307     uint256 private constant _BITMASK_BURNED = 1 << 224;
1308 
1309     // The bit position of the `nextInitialized` bit in packed ownership.
1310     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1311 
1312     // The bit mask of the `nextInitialized` bit in packed ownership.
1313     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1314 
1315     // The bit position of `extraData` in packed ownership.
1316     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1317 
1318     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1319     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1320 
1321     // The mask of the lower 160 bits for addresses.
1322     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1323 
1324     // The maximum `quantity` that can be minted with {_mintERC2309}.
1325     // This limit is to prevent overflows on the address data entries.
1326     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1327     // is required to cause an overflow, which is unrealistic.
1328     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1329 
1330     // The `Transfer` event signature is given by:
1331     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1332     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1333         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1334 
1335     // =============================================================
1336     //                            STORAGE
1337     // =============================================================
1338 
1339     // The next token ID to be minted.
1340     uint256 private _currentIndex;
1341 
1342     // The number of tokens burned.
1343     uint256 private _burnCounter;
1344 
1345     // Token name
1346     string private _name;
1347 
1348     // Token symbol
1349     string private _symbol;
1350 
1351     // Mapping from token ID to ownership details
1352     // An empty struct value does not necessarily mean the token is unowned.
1353     // See {_packedOwnershipOf} implementation for details.
1354     //
1355     // Bits Layout:
1356     // - [0..159]   `addr`
1357     // - [160..223] `startTimestamp`
1358     // - [224]      `burned`
1359     // - [225]      `nextInitialized`
1360     // - [232..255] `extraData`
1361     mapping(uint256 => uint256) private _packedOwnerships;
1362 
1363     // Mapping owner address to address data.
1364     //
1365     // Bits Layout:
1366     // - [0..63]    `balance`
1367     // - [64..127]  `numberMinted`
1368     // - [128..191] `numberBurned`
1369     // - [192..255] `aux`
1370     mapping(address => uint256) private _packedAddressData;
1371 
1372     // Mapping from token ID to approved address.
1373     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1374 
1375     // Mapping from owner to operator approvals
1376     mapping(address => mapping(address => bool)) private _operatorApprovals;
1377 
1378     // =============================================================
1379     //                          CONSTRUCTOR
1380     // =============================================================
1381 
1382     constructor(string memory name_, string memory symbol_) {
1383         _name = name_;
1384         _symbol = symbol_;
1385         _currentIndex = _startTokenId();
1386     }
1387 
1388     // =============================================================
1389     //                   TOKEN COUNTING OPERATIONS
1390     // =============================================================
1391 
1392     /**
1393      * @dev Returns the starting token ID.
1394      * To change the starting token ID, please override this function.
1395      */
1396     function _startTokenId() internal view virtual returns (uint256) {
1397         return 0;
1398     }
1399 
1400     /**
1401      * @dev Returns the next token ID to be minted.
1402      */
1403     function _nextTokenId() internal view virtual returns (uint256) {
1404         return _currentIndex;
1405     }
1406 
1407     /**
1408      * @dev Returns the total number of tokens in existence.
1409      * Burned tokens will reduce the count.
1410      * To get the total number of tokens minted, please see {_totalMinted}.
1411      */
1412     function totalSupply() public view virtual override returns (uint256) {
1413         // Counter underflow is impossible as _burnCounter cannot be incremented
1414         // more than `_currentIndex - _startTokenId()` times.
1415         unchecked {
1416             return _currentIndex - _burnCounter - _startTokenId();
1417         }
1418     }
1419 
1420     /**
1421      * @dev Returns the total amount of tokens minted in the contract.
1422      */
1423     function _totalMinted() internal view virtual returns (uint256) {
1424         // Counter underflow is impossible as `_currentIndex` does not decrement,
1425         // and it is initialized to `_startTokenId()`.
1426         unchecked {
1427             return _currentIndex - _startTokenId();
1428         }
1429     }
1430 
1431     /**
1432      * @dev Returns the total number of tokens burned.
1433      */
1434     function _totalBurned() internal view virtual returns (uint256) {
1435         return _burnCounter;
1436     }
1437 
1438     // =============================================================
1439     //                    ADDRESS DATA OPERATIONS
1440     // =============================================================
1441 
1442     /**
1443      * @dev Returns the number of tokens in `owner`'s account.
1444      */
1445     function balanceOf(address owner)
1446         public
1447         view
1448         virtual
1449         override
1450         returns (uint256)
1451     {
1452         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
1453         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1454     }
1455 
1456     /**
1457      * Returns the number of tokens minted by `owner`.
1458      */
1459     function _numberMinted(address owner) internal view returns (uint256) {
1460         return
1461             (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) &
1462             _BITMASK_ADDRESS_DATA_ENTRY;
1463     }
1464 
1465     /**
1466      * Returns the number of tokens burned by or on behalf of `owner`.
1467      */
1468     function _numberBurned(address owner) internal view returns (uint256) {
1469         return
1470             (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) &
1471             _BITMASK_ADDRESS_DATA_ENTRY;
1472     }
1473 
1474     /**
1475      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1476      */
1477     function _getAux(address owner) internal view returns (uint64) {
1478         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1479     }
1480 
1481     /**
1482      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1483      * If there are multiple variables, please pack them into a uint64.
1484      */
1485     function _setAux(address owner, uint64 aux) internal virtual {
1486         uint256 packed = _packedAddressData[owner];
1487         uint256 auxCasted;
1488         // Cast `aux` with assembly to avoid redundant masking.
1489         assembly {
1490             auxCasted := aux
1491         }
1492         packed =
1493             (packed & _BITMASK_AUX_COMPLEMENT) |
1494             (auxCasted << _BITPOS_AUX);
1495         _packedAddressData[owner] = packed;
1496     }
1497 
1498     // =============================================================
1499     //                            IERC165
1500     // =============================================================
1501 
1502     /**
1503      * @dev Returns true if this contract implements the interface defined by
1504      * `interfaceId`. See the corresponding
1505      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1506      * to learn more about how these ids are created.
1507      *
1508      * This function call must use less than 30000 gas.
1509      */
1510     function supportsInterface(bytes4 interfaceId)
1511         public
1512         view
1513         virtual
1514         override
1515         returns (bool)
1516     {
1517         // The interface IDs are constants representing the first 4 bytes
1518         // of the XOR of all function selectors in the interface.
1519         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1520         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1521         return
1522             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1523             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1524             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1525     }
1526 
1527     // =============================================================
1528     //                        IERC721Metadata
1529     // =============================================================
1530 
1531     /**
1532      * @dev Returns the token collection name.
1533      */
1534     function name() public view virtual override returns (string memory) {
1535         return _name;
1536     }
1537 
1538     /**
1539      * @dev Returns the token collection symbol.
1540      */
1541     function symbol() public view virtual override returns (string memory) {
1542         return _symbol;
1543     }
1544 
1545     /**
1546      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1547      */
1548     function tokenURI(uint256 tokenId)
1549         public
1550         view
1551         virtual
1552         override
1553         returns (string memory)
1554     {
1555         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
1556 
1557         string memory baseURI = _baseURI();
1558         return
1559             bytes(baseURI).length != 0
1560                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
1561                 : "";
1562     }
1563 
1564     /**
1565      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1566      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1567      * by default, it can be overridden in child contracts.
1568      */
1569     function _baseURI() internal view virtual returns (string memory) {
1570         return "";
1571     }
1572 
1573     // =============================================================
1574     //                     OWNERSHIPS OPERATIONS
1575     // =============================================================
1576 
1577     /**
1578      * @dev Returns the owner of the `tokenId` token.
1579      *
1580      * Requirements:
1581      *
1582      * - `tokenId` must exist.
1583      */
1584     function ownerOf(uint256 tokenId)
1585         public
1586         view
1587         virtual
1588         override
1589         returns (address)
1590     {
1591         return address(uint160(_packedOwnershipOf(tokenId)));
1592     }
1593 
1594     /**
1595      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1596      * It gradually moves to O(1) as tokens get transferred around over time.
1597      */
1598     function _ownershipOf(uint256 tokenId)
1599         internal
1600         view
1601         virtual
1602         returns (TokenOwnership memory)
1603     {
1604         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1605     }
1606 
1607     /**
1608      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1609      */
1610     function _ownershipAt(uint256 index)
1611         internal
1612         view
1613         virtual
1614         returns (TokenOwnership memory)
1615     {
1616         return _unpackedOwnership(_packedOwnerships[index]);
1617     }
1618 
1619     /**
1620      * @dev Returns whether the ownership slot at `index` is initialized.
1621      * An uninitialized slot does not necessarily mean that the slot has no owner.
1622      */
1623     function _ownershipIsInitialized(uint256 index)
1624         internal
1625         view
1626         virtual
1627         returns (bool)
1628     {
1629         return _packedOwnerships[index] != 0;
1630     }
1631 
1632     /**
1633      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1634      */
1635     function _initializeOwnershipAt(uint256 index) internal virtual {
1636         if (_packedOwnerships[index] == 0) {
1637             _packedOwnerships[index] = _packedOwnershipOf(index);
1638         }
1639     }
1640 
1641     /**
1642      * Returns the packed ownership data of `tokenId`.
1643      */
1644     function _packedOwnershipOf(uint256 tokenId)
1645         private
1646         view
1647         returns (uint256 packed)
1648     {
1649         if (_startTokenId() <= tokenId) {
1650             packed = _packedOwnerships[tokenId];
1651             // If the data at the starting slot does not exist, start the scan.
1652             if (packed == 0) {
1653                 if (tokenId >= _currentIndex)
1654                     _revert(OwnerQueryForNonexistentToken.selector);
1655                 // Invariant:
1656                 // There will always be an initialized ownership slot
1657                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1658                 // before an unintialized ownership slot
1659                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1660                 // Hence, `tokenId` will not underflow.
1661                 //
1662                 // We can directly compare the packed value.
1663                 // If the address is zero, packed will be zero.
1664                 for (;;) {
1665                     unchecked {
1666                         packed = _packedOwnerships[--tokenId];
1667                     }
1668                     if (packed == 0) continue;
1669                     if (packed & _BITMASK_BURNED == 0) return packed;
1670                     // Otherwise, the token is burned, and we must revert.
1671                     // This handles the case of batch burned tokens, where only the burned bit
1672                     // of the starting slot is set, and remaining slots are left uninitialized.
1673                     _revert(OwnerQueryForNonexistentToken.selector);
1674                 }
1675             }
1676             // Otherwise, the data exists and we can skip the scan.
1677             // This is possible because we have already achieved the target condition.
1678             // This saves 2143 gas on transfers of initialized tokens.
1679             // If the token is not burned, return `packed`. Otherwise, revert.
1680             if (packed & _BITMASK_BURNED == 0) return packed;
1681         }
1682         _revert(OwnerQueryForNonexistentToken.selector);
1683     }
1684 
1685     /**
1686      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1687      */
1688     function _unpackedOwnership(uint256 packed)
1689         private
1690         pure
1691         returns (TokenOwnership memory ownership)
1692     {
1693         ownership.addr = address(uint160(packed));
1694         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1695         ownership.burned = packed & _BITMASK_BURNED != 0;
1696         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1697     }
1698 
1699     /**
1700      * @dev Packs ownership data into a single uint256.
1701      */
1702     function _packOwnershipData(address owner, uint256 flags)
1703         private
1704         view
1705         returns (uint256 result)
1706     {
1707         assembly {
1708             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1709             owner := and(owner, _BITMASK_ADDRESS)
1710             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1711             result := or(
1712                 owner,
1713                 or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags)
1714             )
1715         }
1716     }
1717 
1718     /**
1719      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1720      */
1721     function _nextInitializedFlag(uint256 quantity)
1722         private
1723         pure
1724         returns (uint256 result)
1725     {
1726         // For branchless setting of the `nextInitialized` flag.
1727         assembly {
1728             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1729             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1730         }
1731     }
1732 
1733     // =============================================================
1734     //                      APPROVAL OPERATIONS
1735     // =============================================================
1736 
1737     /**
1738      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1739      *
1740      * Requirements:
1741      *
1742      * - The caller must own the token or be an approved operator.
1743      */
1744     function approve(address to, uint256 tokenId)
1745         public
1746         payable
1747         virtual
1748         override
1749     {
1750         _approve(to, tokenId, true);
1751     }
1752 
1753     /**
1754      * @dev Returns the account approved for `tokenId` token.
1755      *
1756      * Requirements:
1757      *
1758      * - `tokenId` must exist.
1759      */
1760     function getApproved(uint256 tokenId)
1761         public
1762         view
1763         virtual
1764         override
1765         returns (address)
1766     {
1767         if (!_exists(tokenId))
1768             _revert(ApprovalQueryForNonexistentToken.selector);
1769 
1770         return _tokenApprovals[tokenId].value;
1771     }
1772 
1773     /**
1774      * @dev Approve or remove `operator` as an operator for the caller.
1775      * Operators can call {transferFrom} or {safeTransferFrom}
1776      * for any token owned by the caller.
1777      *
1778      * Requirements:
1779      *
1780      * - The `operator` cannot be the caller.
1781      *
1782      * Emits an {ApprovalForAll} event.
1783      */
1784     function setApprovalForAll(address operator, bool approved)
1785         public
1786         virtual
1787         override
1788     {
1789         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1790         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1791     }
1792 
1793     /**
1794      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1795      *
1796      * See {setApprovalForAll}.
1797      */
1798     function isApprovedForAll(address owner, address operator)
1799         public
1800         view
1801         virtual
1802         override
1803         returns (bool)
1804     {
1805         return _operatorApprovals[owner][operator];
1806     }
1807 
1808     /**
1809      * @dev Returns whether `tokenId` exists.
1810      *
1811      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1812      *
1813      * Tokens start existing when they are minted. See {_mint}.
1814      */
1815     function _exists(uint256 tokenId)
1816         internal
1817         view
1818         virtual
1819         returns (bool result)
1820     {
1821         if (_startTokenId() <= tokenId) {
1822             if (tokenId < _currentIndex) {
1823                 uint256 packed;
1824                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
1825                 result = packed & _BITMASK_BURNED == 0;
1826             }
1827         }
1828     }
1829 
1830     /**
1831      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1832      */
1833     function _isSenderApprovedOrOwner(
1834         address approvedAddress,
1835         address owner,
1836         address msgSender
1837     ) private pure returns (bool result) {
1838         assembly {
1839             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1840             owner := and(owner, _BITMASK_ADDRESS)
1841             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1842             msgSender := and(msgSender, _BITMASK_ADDRESS)
1843             // `msgSender == owner || msgSender == approvedAddress`.
1844             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1845         }
1846     }
1847 
1848     /**
1849      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1850      */
1851     function _getApprovedSlotAndAddress(uint256 tokenId)
1852         private
1853         view
1854         returns (uint256 approvedAddressSlot, address approvedAddress)
1855     {
1856         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1857         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1858         assembly {
1859             approvedAddressSlot := tokenApproval.slot
1860             approvedAddress := sload(approvedAddressSlot)
1861         }
1862     }
1863 
1864     // =============================================================
1865     //                      TRANSFER OPERATIONS
1866     // =============================================================
1867 
1868     /**
1869      * @dev Transfers `tokenId` from `from` to `to`.
1870      *
1871      * Requirements:
1872      *
1873      * - `from` cannot be the zero address.
1874      * - `to` cannot be the zero address.
1875      * - `tokenId` token must be owned by `from`.
1876      * - If the caller is not `from`, it must be approved to move this token
1877      * by either {approve} or {setApprovalForAll}.
1878      *
1879      * Emits a {Transfer} event.
1880      */
1881     function transferFrom(
1882         address from,
1883         address to,
1884         uint256 tokenId
1885     ) public payable virtual override {
1886         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1887 
1888         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1889         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
1890 
1891         if (address(uint160(prevOwnershipPacked)) != from)
1892             _revert(TransferFromIncorrectOwner.selector);
1893 
1894         (
1895             uint256 approvedAddressSlot,
1896             address approvedAddress
1897         ) = _getApprovedSlotAndAddress(tokenId);
1898 
1899         // The nested ifs save around 20+ gas over a compound boolean condition.
1900         if (
1901             !_isSenderApprovedOrOwner(
1902                 approvedAddress,
1903                 from,
1904                 _msgSenderERC721A()
1905             )
1906         )
1907             if (!isApprovedForAll(from, _msgSenderERC721A()))
1908                 _revert(TransferCallerNotOwnerNorApproved.selector);
1909 
1910         _beforeTokenTransfers(from, to, tokenId, 1);
1911 
1912         // Clear approvals from the previous owner.
1913         assembly {
1914             if approvedAddress {
1915                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1916                 sstore(approvedAddressSlot, 0)
1917             }
1918         }
1919 
1920         // Underflow of the sender's balance is impossible because we check for
1921         // ownership above and the recipient's balance can't realistically overflow.
1922         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1923         unchecked {
1924             // We can directly increment and decrement the balances.
1925             --_packedAddressData[from]; // Updates: `balance -= 1`.
1926             ++_packedAddressData[to]; // Updates: `balance += 1`.
1927 
1928             // Updates:
1929             // - `address` to the next owner.
1930             // - `startTimestamp` to the timestamp of transfering.
1931             // - `burned` to `false`.
1932             // - `nextInitialized` to `true`.
1933             _packedOwnerships[tokenId] = _packOwnershipData(
1934                 to,
1935                 _BITMASK_NEXT_INITIALIZED |
1936                     _nextExtraData(from, to, prevOwnershipPacked)
1937             );
1938 
1939             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1940             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1941                 uint256 nextTokenId = tokenId + 1;
1942                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1943                 if (_packedOwnerships[nextTokenId] == 0) {
1944                     // If the next slot is within bounds.
1945                     if (nextTokenId != _currentIndex) {
1946                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1947                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1948                     }
1949                 }
1950             }
1951         }
1952 
1953         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1954         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1955         assembly {
1956             // Emit the `Transfer` event.
1957             log4(
1958                 0, // Start of data (0, since no data).
1959                 0, // End of data (0, since no data).
1960                 _TRANSFER_EVENT_SIGNATURE, // Signature.
1961                 from, // `from`.
1962                 toMasked, // `to`.
1963                 tokenId // `tokenId`.
1964             )
1965         }
1966         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
1967 
1968         _afterTokenTransfers(from, to, tokenId, 1);
1969     }
1970 
1971     /**
1972      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1973      */
1974     function safeTransferFrom(
1975         address from,
1976         address to,
1977         uint256 tokenId
1978     ) public payable virtual override {
1979         safeTransferFrom(from, to, tokenId, "");
1980     }
1981 
1982     /**
1983      * @dev Safely transfers `tokenId` token from `from` to `to`.
1984      *
1985      * Requirements:
1986      *
1987      * - `from` cannot be the zero address.
1988      * - `to` cannot be the zero address.
1989      * - `tokenId` token must exist and be owned by `from`.
1990      * - If the caller is not `from`, it must be approved to move this token
1991      * by either {approve} or {setApprovalForAll}.
1992      * - If `to` refers to a smart contract, it must implement
1993      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1994      *
1995      * Emits a {Transfer} event.
1996      */
1997     function safeTransferFrom(
1998         address from,
1999         address to,
2000         uint256 tokenId,
2001         bytes memory _data
2002     ) public payable virtual override {
2003         transferFrom(from, to, tokenId);
2004         if (to.code.length != 0)
2005             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2006                 _revert(TransferToNonERC721ReceiverImplementer.selector);
2007             }
2008     }
2009 
2010     /**
2011      * @dev Hook that is called before a set of serially-ordered token IDs
2012      * are about to be transferred. This includes minting.
2013      * And also called before burning one token.
2014      *
2015      * `startTokenId` - the first token ID to be transferred.
2016      * `quantity` - the amount to be transferred.
2017      *
2018      * Calling conditions:
2019      *
2020      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2021      * transferred to `to`.
2022      * - When `from` is zero, `tokenId` will be minted for `to`.
2023      * - When `to` is zero, `tokenId` will be burned by `from`.
2024      * - `from` and `to` are never both zero.
2025      */
2026     function _beforeTokenTransfers(
2027         address from,
2028         address to,
2029         uint256 startTokenId,
2030         uint256 quantity
2031     ) internal virtual {}
2032 
2033     /**
2034      * @dev Hook that is called after a set of serially-ordered token IDs
2035      * have been transferred. This includes minting.
2036      * And also called after one token has been burned.
2037      *
2038      * `startTokenId` - the first token ID to be transferred.
2039      * `quantity` - the amount to be transferred.
2040      *
2041      * Calling conditions:
2042      *
2043      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2044      * transferred to `to`.
2045      * - When `from` is zero, `tokenId` has been minted for `to`.
2046      * - When `to` is zero, `tokenId` has been burned by `from`.
2047      * - `from` and `to` are never both zero.
2048      */
2049     function _afterTokenTransfers(
2050         address from,
2051         address to,
2052         uint256 startTokenId,
2053         uint256 quantity
2054     ) internal virtual {}
2055 
2056     /**
2057      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2058      *
2059      * `from` - Previous owner of the given token ID.
2060      * `to` - Target address that will receive the token.
2061      * `tokenId` - Token ID to be transferred.
2062      * `_data` - Optional data to send along with the call.
2063      *
2064      * Returns whether the call correctly returned the expected magic value.
2065      */
2066     function _checkContractOnERC721Received(
2067         address from,
2068         address to,
2069         uint256 tokenId,
2070         bytes memory _data
2071     ) private returns (bool) {
2072         try
2073             ERC721A__IERC721Receiver(to).onERC721Received(
2074                 _msgSenderERC721A(),
2075                 from,
2076                 tokenId,
2077                 _data
2078             )
2079         returns (bytes4 retval) {
2080             return
2081                 retval ==
2082                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
2083         } catch (bytes memory reason) {
2084             if (reason.length == 0) {
2085                 _revert(TransferToNonERC721ReceiverImplementer.selector);
2086             }
2087             assembly {
2088                 revert(add(32, reason), mload(reason))
2089             }
2090         }
2091     }
2092 
2093     // =============================================================
2094     //                        MINT OPERATIONS
2095     // =============================================================
2096 
2097     /**
2098      * @dev Mints `quantity` tokens and transfers them to `to`.
2099      *
2100      * Requirements:
2101      *
2102      * - `to` cannot be the zero address.
2103      * - `quantity` must be greater than 0.
2104      *
2105      * Emits a {Transfer} event for each mint.
2106      */
2107     function _mint(address to, uint256 quantity) internal virtual {
2108         uint256 startTokenId = _currentIndex;
2109         if (quantity == 0) _revert(MintZeroQuantity.selector);
2110 
2111         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2112 
2113         // Overflows are incredibly unrealistic.
2114         // `balance` and `numberMinted` have a maximum limit of 2**64.
2115         // `tokenId` has a maximum limit of 2**256.
2116         unchecked {
2117             // Updates:
2118             // - `address` to the owner.
2119             // - `startTimestamp` to the timestamp of minting.
2120             // - `burned` to `false`.
2121             // - `nextInitialized` to `quantity == 1`.
2122             _packedOwnerships[startTokenId] = _packOwnershipData(
2123                 to,
2124                 _nextInitializedFlag(quantity) |
2125                     _nextExtraData(address(0), to, 0)
2126             );
2127 
2128             // Updates:
2129             // - `balance += quantity`.
2130             // - `numberMinted += quantity`.
2131             //
2132             // We can directly add to the `balance` and `numberMinted`.
2133             _packedAddressData[to] +=
2134                 quantity *
2135                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
2136 
2137             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2138             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
2139 
2140             if (toMasked == 0) _revert(MintToZeroAddress.selector);
2141 
2142             uint256 end = startTokenId + quantity;
2143             uint256 tokenId = startTokenId;
2144 
2145             do {
2146                 assembly {
2147                     // Emit the `Transfer` event.
2148                     log4(
2149                         0, // Start of data (0, since no data).
2150                         0, // End of data (0, since no data).
2151                         _TRANSFER_EVENT_SIGNATURE, // Signature.
2152                         0, // `address(0)`.
2153                         toMasked, // `to`.
2154                         tokenId // `tokenId`.
2155                     )
2156                 }
2157                 // The `!=` check ensures that large values of `quantity`
2158                 // that overflows uint256 will make the loop run out of gas.
2159             } while (++tokenId != end);
2160 
2161             _currentIndex = end;
2162         }
2163         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2164     }
2165 
2166     /**
2167      * @dev Mints `quantity` tokens and transfers them to `to`.
2168      *
2169      * This function is intended for efficient minting only during contract creation.
2170      *
2171      * It emits only one {ConsecutiveTransfer} as defined in
2172      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2173      * instead of a sequence of {Transfer} event(s).
2174      *
2175      * Calling this function outside of contract creation WILL make your contract
2176      * non-compliant with the ERC721 standard.
2177      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2178      * {ConsecutiveTransfer} event is only permissible during contract creation.
2179      *
2180      * Requirements:
2181      *
2182      * - `to` cannot be the zero address.
2183      * - `quantity` must be greater than 0.
2184      *
2185      * Emits a {ConsecutiveTransfer} event.
2186      */
2187     function _mintERC2309(address to, uint256 quantity) internal virtual {
2188         uint256 startTokenId = _currentIndex;
2189         if (to == address(0)) _revert(MintToZeroAddress.selector);
2190         if (quantity == 0) _revert(MintZeroQuantity.selector);
2191         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT)
2192             _revert(MintERC2309QuantityExceedsLimit.selector);
2193 
2194         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2195 
2196         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2197         unchecked {
2198             // Updates:
2199             // - `balance += quantity`.
2200             // - `numberMinted += quantity`.
2201             //
2202             // We can directly add to the `balance` and `numberMinted`.
2203             _packedAddressData[to] +=
2204                 quantity *
2205                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
2206 
2207             // Updates:
2208             // - `address` to the owner.
2209             // - `startTimestamp` to the timestamp of minting.
2210             // - `burned` to `false`.
2211             // - `nextInitialized` to `quantity == 1`.
2212             _packedOwnerships[startTokenId] = _packOwnershipData(
2213                 to,
2214                 _nextInitializedFlag(quantity) |
2215                     _nextExtraData(address(0), to, 0)
2216             );
2217 
2218             emit ConsecutiveTransfer(
2219                 startTokenId,
2220                 startTokenId + quantity - 1,
2221                 address(0),
2222                 to
2223             );
2224 
2225             _currentIndex = startTokenId + quantity;
2226         }
2227         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2228     }
2229 
2230     /**
2231      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2232      *
2233      * Requirements:
2234      *
2235      * - If `to` refers to a smart contract, it must implement
2236      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2237      * - `quantity` must be greater than 0.
2238      *
2239      * See {_mint}.
2240      *
2241      * Emits a {Transfer} event for each mint.
2242      */
2243     function _safeMint(
2244         address to,
2245         uint256 quantity,
2246         bytes memory _data
2247     ) internal virtual {
2248         _mint(to, quantity);
2249 
2250         unchecked {
2251             if (to.code.length != 0) {
2252                 uint256 end = _currentIndex;
2253                 uint256 index = end - quantity;
2254                 do {
2255                     if (
2256                         !_checkContractOnERC721Received(
2257                             address(0),
2258                             to,
2259                             index++,
2260                             _data
2261                         )
2262                     ) {
2263                         _revert(
2264                             TransferToNonERC721ReceiverImplementer.selector
2265                         );
2266                     }
2267                 } while (index < end);
2268                 // Reentrancy protection.
2269                 if (_currentIndex != end) _revert(bytes4(0));
2270             }
2271         }
2272     }
2273 
2274     /**
2275      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2276      */
2277     function _safeMint(address to, uint256 quantity) internal virtual {
2278         _safeMint(to, quantity, "");
2279     }
2280 
2281     // =============================================================
2282     //                       APPROVAL OPERATIONS
2283     // =============================================================
2284 
2285     /**
2286      * @dev Equivalent to `_approve(to, tokenId, false)`.
2287      */
2288     function _approve(address to, uint256 tokenId) internal virtual {
2289         _approve(to, tokenId, false);
2290     }
2291 
2292     /**
2293      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2294      * The approval is cleared when the token is transferred.
2295      *
2296      * Only a single account can be approved at a time, so approving the
2297      * zero address clears previous approvals.
2298      *
2299      * Requirements:
2300      *
2301      * - `tokenId` must exist.
2302      *
2303      * Emits an {Approval} event.
2304      */
2305     function _approve(
2306         address to,
2307         uint256 tokenId,
2308         bool approvalCheck
2309     ) internal virtual {
2310         address owner = ownerOf(tokenId);
2311 
2312         if (approvalCheck && _msgSenderERC721A() != owner)
2313             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2314                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
2315             }
2316 
2317         _tokenApprovals[tokenId].value = to;
2318         emit Approval(owner, to, tokenId);
2319     }
2320 
2321     // =============================================================
2322     //                        BURN OPERATIONS
2323     // =============================================================
2324 
2325     /**
2326      * @dev Equivalent to `_burn(tokenId, false)`.
2327      */
2328     function _burn(uint256 tokenId) internal virtual {
2329         _burn(tokenId, false);
2330     }
2331 
2332     /**
2333      * @dev Destroys `tokenId`.
2334      * The approval is cleared when the token is burned.
2335      *
2336      * Requirements:
2337      *
2338      * - `tokenId` must exist.
2339      *
2340      * Emits a {Transfer} event.
2341      */
2342     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2343         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2344 
2345         address from = address(uint160(prevOwnershipPacked));
2346 
2347         (
2348             uint256 approvedAddressSlot,
2349             address approvedAddress
2350         ) = _getApprovedSlotAndAddress(tokenId);
2351 
2352         if (approvalCheck) {
2353             // The nested ifs save around 20+ gas over a compound boolean condition.
2354             if (
2355                 !_isSenderApprovedOrOwner(
2356                     approvedAddress,
2357                     from,
2358                     _msgSenderERC721A()
2359                 )
2360             )
2361                 if (!isApprovedForAll(from, _msgSenderERC721A()))
2362                     _revert(TransferCallerNotOwnerNorApproved.selector);
2363         }
2364 
2365         _beforeTokenTransfers(from, address(0), tokenId, 1);
2366 
2367         // Clear approvals from the previous owner.
2368         assembly {
2369             if approvedAddress {
2370                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2371                 sstore(approvedAddressSlot, 0)
2372             }
2373         }
2374 
2375         // Underflow of the sender's balance is impossible because we check for
2376         // ownership above and the recipient's balance can't realistically overflow.
2377         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2378         unchecked {
2379             // Updates:
2380             // - `balance -= 1`.
2381             // - `numberBurned += 1`.
2382             //
2383             // We can directly decrement the balance, and increment the number burned.
2384             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2385             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2386 
2387             // Updates:
2388             // - `address` to the last owner.
2389             // - `startTimestamp` to the timestamp of burning.
2390             // - `burned` to `true`.
2391             // - `nextInitialized` to `true`.
2392             _packedOwnerships[tokenId] = _packOwnershipData(
2393                 from,
2394                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) |
2395                     _nextExtraData(from, address(0), prevOwnershipPacked)
2396             );
2397 
2398             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2399             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2400                 uint256 nextTokenId = tokenId + 1;
2401                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2402                 if (_packedOwnerships[nextTokenId] == 0) {
2403                     // If the next slot is within bounds.
2404                     if (nextTokenId != _currentIndex) {
2405                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2406                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2407                     }
2408                 }
2409             }
2410         }
2411 
2412         emit Transfer(from, address(0), tokenId);
2413         _afterTokenTransfers(from, address(0), tokenId, 1);
2414 
2415         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2416         unchecked {
2417             _burnCounter++;
2418         }
2419     }
2420 
2421     // =============================================================
2422     //                     EXTRA DATA OPERATIONS
2423     // =============================================================
2424 
2425     /**
2426      * @dev Directly sets the extra data for the ownership data `index`.
2427      */
2428     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2429         uint256 packed = _packedOwnerships[index];
2430         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
2431         uint256 extraDataCasted;
2432         // Cast `extraData` with assembly to avoid redundant masking.
2433         assembly {
2434             extraDataCasted := extraData
2435         }
2436         packed =
2437             (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) |
2438             (extraDataCasted << _BITPOS_EXTRA_DATA);
2439         _packedOwnerships[index] = packed;
2440     }
2441 
2442     /**
2443      * @dev Called during each token transfer to set the 24bit `extraData` field.
2444      * Intended to be overridden by the cosumer contract.
2445      *
2446      * `previousExtraData` - the value of `extraData` before transfer.
2447      *
2448      * Calling conditions:
2449      *
2450      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2451      * transferred to `to`.
2452      * - When `from` is zero, `tokenId` will be minted for `to`.
2453      * - When `to` is zero, `tokenId` will be burned by `from`.
2454      * - `from` and `to` are never both zero.
2455      */
2456     function _extraData(
2457         address from,
2458         address to,
2459         uint24 previousExtraData
2460     ) internal view virtual returns (uint24) {}
2461 
2462     /**
2463      * @dev Returns the next extra data for the packed ownership data.
2464      * The returned result is shifted into position.
2465      */
2466     function _nextExtraData(
2467         address from,
2468         address to,
2469         uint256 prevOwnershipPacked
2470     ) private view returns (uint256) {
2471         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2472         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2473     }
2474 
2475     // =============================================================
2476     //                       OTHER OPERATIONS
2477     // =============================================================
2478 
2479     /**
2480      * @dev Returns the message sender (defaults to `msg.sender`).
2481      *
2482      * If you are writing GSN compatible contracts, you need to override this function.
2483      */
2484     function _msgSenderERC721A() internal view virtual returns (address) {
2485         return msg.sender;
2486     }
2487 
2488     /**
2489      * @dev Converts a uint256 to its ASCII string decimal representation.
2490      */
2491     function _toString(uint256 value)
2492         internal
2493         pure
2494         virtual
2495         returns (string memory str)
2496     {
2497         assembly {
2498             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2499             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2500             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2501             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2502             let m := add(mload(0x40), 0xa0)
2503             // Update the free memory pointer to allocate.
2504             mstore(0x40, m)
2505             // Assign the `str` to the end.
2506             str := sub(m, 0x20)
2507             // Zeroize the slot after the string.
2508             mstore(str, 0)
2509 
2510             // Cache the end of the memory to calculate the length later.
2511             let end := str
2512 
2513             // We write the string from rightmost digit to leftmost digit.
2514             // The following is essentially a do-while loop that also handles the zero case.
2515             // prettier-ignore
2516             for { let temp := value } 1 {} {
2517                 str := sub(str, 1)
2518                 // Write the character to the pointer.
2519                 // The ASCII index of the '0' character is 48.
2520                 mstore8(str, add(48, mod(temp, 10)))
2521                 // Keep dividing `temp` until zero.
2522                 temp := div(temp, 10)
2523                 // prettier-ignore
2524                 if iszero(temp) { break }
2525             }
2526 
2527             let length := sub(end, str)
2528             // Move the pointer 32 bytes leftwards to make room for the length.
2529             str := sub(str, 0x20)
2530             // Store the length.
2531             mstore(str, length)
2532         }
2533     }
2534 
2535     /**
2536      * @dev For more efficient reverts.
2537      */
2538     function _revert(bytes4 errorSelector) internal pure {
2539         assembly {
2540             mstore(0x00, errorSelector)
2541             revert(0x00, 0x04)
2542         }
2543     }
2544 }
2545 
2546 interface IERC721AQueryable is IERC721A {
2547     /**
2548      * Invalid query range (`start` >= `stop`).
2549      */
2550     error InvalidQueryRange();
2551 
2552     /**
2553      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2554      *
2555      * If the `tokenId` is out of bounds:
2556      *
2557      * - `addr = address(0)`
2558      * - `startTimestamp = 0`
2559      * - `burned = false`
2560      * - `extraData = 0`
2561      *
2562      * If the `tokenId` is burned:
2563      *
2564      * - `addr = <Address of owner before token was burned>`
2565      * - `startTimestamp = <Timestamp when token was burned>`
2566      * - `burned = true`
2567      * - `extraData = <Extra data when token was burned>`
2568      *
2569      * Otherwise:
2570      *
2571      * - `addr = <Address of owner>`
2572      * - `startTimestamp = <Timestamp of start of ownership>`
2573      * - `burned = false`
2574      * - `extraData = <Extra data at start of ownership>`
2575      */
2576     function explicitOwnershipOf(uint256 tokenId)
2577         external
2578         view
2579         returns (TokenOwnership memory);
2580 
2581     /**
2582      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2583      * See {ERC721AQueryable-explicitOwnershipOf}
2584      */
2585     function explicitOwnershipsOf(uint256[] memory tokenIds)
2586         external
2587         view
2588         returns (TokenOwnership[] memory);
2589 
2590     /**
2591      * @dev Returns an array of token IDs owned by `owner`,
2592      * in the range [`start`, `stop`)
2593      * (i.e. `start <= tokenId < stop`).
2594      *
2595      * This function allows for tokens to be queried if the collection
2596      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2597      *
2598      * Requirements:
2599      *
2600      * - `start < stop`
2601      */
2602     function tokensOfOwnerIn(
2603         address owner,
2604         uint256 start,
2605         uint256 stop
2606     ) external view returns (uint256[] memory);
2607 
2608     /**
2609      * @dev Returns an array of token IDs owned by `owner`.
2610      *
2611      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2612      * It is meant to be called off-chain.
2613      *
2614      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2615      * multiple smaller scans if the collection is large enough to cause
2616      * an out-of-gas error (10K collections should be fine).
2617      */
2618     function tokensOfOwner(address owner)
2619         external
2620         view
2621         returns (uint256[] memory);
2622 }
2623 
2624 /**
2625  * @title ERC721AQueryable.
2626  *
2627  * @dev ERC721A subclass with convenience query functions.
2628  */
2629 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2630     /**
2631      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2632      *
2633      * If the `tokenId` is out of bounds:
2634      *
2635      * - `addr = address(0)`
2636      * - `startTimestamp = 0`
2637      * - `burned = false`
2638      * - `extraData = 0`
2639      *
2640      * If the `tokenId` is burned:
2641      *
2642      * - `addr = <Address of owner before token was burned>`
2643      * - `startTimestamp = <Timestamp when token was burned>`
2644      * - `burned = true`
2645      * - `extraData = <Extra data when token was burned>`
2646      *
2647      * Otherwise:
2648      *
2649      * - `addr = <Address of owner>`
2650      * - `startTimestamp = <Timestamp of start of ownership>`
2651      * - `burned = false`
2652      * - `extraData = <Extra data at start of ownership>`
2653      */
2654     function explicitOwnershipOf(uint256 tokenId)
2655         public
2656         view
2657         virtual
2658         override
2659         returns (TokenOwnership memory ownership)
2660     {
2661         unchecked {
2662             if (tokenId >= _startTokenId()) {
2663                 if (tokenId < _nextTokenId()) {
2664                     // If the `tokenId` is within bounds,
2665                     // scan backwards for the initialized ownership slot.
2666                     while (!_ownershipIsInitialized(tokenId)) --tokenId;
2667                     return _ownershipAt(tokenId);
2668                 }
2669             }
2670         }
2671     }
2672 
2673     /**
2674      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2675      * See {ERC721AQueryable-explicitOwnershipOf}
2676      */
2677     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2678         external
2679         view
2680         virtual
2681         override
2682         returns (TokenOwnership[] memory)
2683     {
2684         TokenOwnership[] memory ownerships;
2685         uint256 i = tokenIds.length;
2686         assembly {
2687             // Grab the free memory pointer.
2688             ownerships := mload(0x40)
2689             // Store the length.
2690             mstore(ownerships, i)
2691             // Allocate one word for the length,
2692             // `tokenIds.length` words for the pointers.
2693             i := shl(5, i) // Multiply `i` by 32.
2694             mstore(0x40, add(add(ownerships, 0x20), i))
2695         }
2696         while (i != 0) {
2697             uint256 tokenId;
2698             assembly {
2699                 i := sub(i, 0x20)
2700                 tokenId := calldataload(add(tokenIds.offset, i))
2701             }
2702             TokenOwnership memory ownership = explicitOwnershipOf(tokenId);
2703             assembly {
2704                 // Store the pointer of `ownership` in the `ownerships` array.
2705                 mstore(add(add(ownerships, 0x20), i), ownership)
2706             }
2707         }
2708         return ownerships;
2709     }
2710 
2711     /**
2712      * @dev Returns an array of token IDs owned by `owner`,
2713      * in the range [`start`, `stop`)
2714      * (i.e. `start <= tokenId < stop`).
2715      *
2716      * This function allows for tokens to be queried if the collection
2717      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2718      *
2719      * Requirements:
2720      *
2721      * - `start < stop`
2722      */
2723     function tokensOfOwnerIn(
2724         address owner,
2725         uint256 start,
2726         uint256 stop
2727     ) external view virtual override returns (uint256[] memory) {
2728         return _tokensOfOwnerIn(owner, start, stop);
2729     }
2730 
2731     /**
2732      * @dev Returns an array of token IDs owned by `owner`.
2733      *
2734      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2735      * It is meant to be called off-chain.
2736      *
2737      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2738      * multiple smaller scans if the collection is large enough to cause
2739      * an out-of-gas error (10K collections should be fine).
2740      */
2741     function tokensOfOwner(address owner)
2742         external
2743         view
2744         virtual
2745         override
2746         returns (uint256[] memory)
2747     {
2748         uint256 start = _startTokenId();
2749         uint256 stop = _nextTokenId();
2750         uint256[] memory tokenIds;
2751         if (start != stop) tokenIds = _tokensOfOwnerIn(owner, start, stop);
2752         return tokenIds;
2753     }
2754 
2755     /**
2756      * @dev Helper function for returning an array of token IDs owned by `owner`.
2757      *
2758      * Note that this function is optimized for smaller bytecode size over runtime gas,
2759      * since it is meant to be called off-chain.
2760      */
2761     function _tokensOfOwnerIn(
2762         address owner,
2763         uint256 start,
2764         uint256 stop
2765     ) private view returns (uint256[] memory) {
2766         unchecked {
2767             if (start >= stop) _revert(InvalidQueryRange.selector);
2768             // Set `start = max(start, _startTokenId())`.
2769             if (start < _startTokenId()) {
2770                 start = _startTokenId();
2771             }
2772             uint256 stopLimit = _nextTokenId();
2773             // Set `stop = min(stop, stopLimit)`.
2774             if (stop >= stopLimit) {
2775                 stop = stopLimit;
2776             }
2777             uint256[] memory tokenIds;
2778             uint256 tokenIdsMaxLength = balanceOf(owner);
2779             bool startLtStop = start < stop;
2780             assembly {
2781                 // Set `tokenIdsMaxLength` to zero if `start` is less than `stop`.
2782                 tokenIdsMaxLength := mul(tokenIdsMaxLength, startLtStop)
2783             }
2784             if (tokenIdsMaxLength != 0) {
2785                 // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2786                 // to cater for cases where `balanceOf(owner)` is too big.
2787                 if (stop - start <= tokenIdsMaxLength) {
2788                     tokenIdsMaxLength = stop - start;
2789                 }
2790                 assembly {
2791                     // Grab the free memory pointer.
2792                     tokenIds := mload(0x40)
2793                     // Allocate one word for the length, and `tokenIdsMaxLength` words
2794                     // for the data. `shl(5, x)` is equivalent to `mul(32, x)`.
2795                     mstore(
2796                         0x40,
2797                         add(tokenIds, shl(5, add(tokenIdsMaxLength, 1)))
2798                     )
2799                 }
2800                 // We need to call `explicitOwnershipOf(start)`,
2801                 // because the slot at `start` may not be initialized.
2802                 TokenOwnership memory ownership = explicitOwnershipOf(start);
2803                 address currOwnershipAddr;
2804                 // If the starting slot exists (i.e. not burned),
2805                 // initialize `currOwnershipAddr`.
2806                 // `ownership.address` will not be zero,
2807                 // as `start` is clamped to the valid token ID range.
2808                 if (!ownership.burned) {
2809                     currOwnershipAddr = ownership.addr;
2810                 }
2811                 uint256 tokenIdsIdx;
2812                 // Use a do-while, which is slightly more efficient for this case,
2813                 // as the array will at least contain one element.
2814                 do {
2815                     ownership = _ownershipAt(start);
2816                     assembly {
2817                         switch mload(add(ownership, 0x40))
2818                         // if `ownership.burned == false`.
2819                         case 0 {
2820                             // if `ownership.addr != address(0)`.
2821                             // The `addr` already has it's upper 96 bits clearned,
2822                             // since it is written to memory with regular Solidity.
2823                             if mload(ownership) {
2824                                 currOwnershipAddr := mload(ownership)
2825                             }
2826                             // if `currOwnershipAddr == owner`.
2827                             // The `shl(96, x)` is to make the comparison agnostic to any
2828                             // dirty upper 96 bits in `owner`.
2829                             if iszero(shl(96, xor(currOwnershipAddr, owner))) {
2830                                 tokenIdsIdx := add(tokenIdsIdx, 1)
2831                                 mstore(
2832                                     add(tokenIds, shl(5, tokenIdsIdx)),
2833                                     start
2834                                 )
2835                             }
2836                         }
2837                         // Otherwise, reset `currOwnershipAddr`.
2838                         // This handles the case of batch burned tokens
2839                         // (burned bit of first slot set, remaining slots left uninitialized).
2840                         default {
2841                             currOwnershipAddr := 0
2842                         }
2843                         start := add(start, 1)
2844                     }
2845                 } while (!(start == stop || tokenIdsIdx == tokenIdsMaxLength));
2846                 // Store the length of the array.
2847                 assembly {
2848                     mstore(tokenIds, tokenIdsIdx)
2849                 }
2850             }
2851             return tokenIds;
2852         }
2853     }
2854 }
2855 
2856 /**
2857  * @dev Interface of ERC721ABurnable.
2858  */
2859 interface IERC721ABurnable is IERC721A {
2860     /**
2861      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2862      *
2863      * Requirements:
2864      *
2865      * - The caller must own `tokenId` or be an approved operator.
2866      */
2867     function burn(uint256 tokenId) external;
2868 }
2869 
2870 /**
2871  * @title ERC721ABurnable.
2872  *
2873  * @dev ERC721A token that can be irreversibly burned (destroyed).
2874  */
2875 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
2876     /**
2877      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2878      *
2879      * Requirements:
2880      *
2881      * - The caller must own `tokenId` or be an approved operator.
2882      */
2883     function burn(uint256 tokenId) public virtual override {
2884         _burn(tokenId, true);
2885     }
2886 }
2887 
2888 
2889 interface ERC20 {
2890     function balanceOf(address owner) external view returns (uint256);
2891 
2892     function allowance(address owner, address spender)
2893         external
2894         view
2895         returns (uint256);
2896 
2897     function approve(address spender, uint256 value) external returns (bool);
2898 
2899     function transfer(address to, uint256 value) external returns (bool);
2900 
2901     function transferFrom(
2902         address from,
2903         address to,
2904         uint256 value
2905     ) external returns (bool);
2906 }
2907 
2908 
2909 pragma solidity ^0.8.17;
2910 
2911 contract KyojinSenshi is
2912     ERC721AQueryable,
2913     ERC721ABurnable,
2914     ERC2981,
2915     DefaultOperatorFilterer,
2916     Ownable
2917 {
2918     IERC20 private _ethToken;
2919     uint256 public MAX_SUPPLY;
2920     uint256 public MINT_PRICE = 0 ether;
2921     uint256 public MAX_PER_WALLET = 1;
2922     uint256 public REWARD_AMOUNT_AZMURA = 1 ether; //
2923     uint256 public REWARD_AMOUNT_MAZUNO = 1 ether; //
2924     uint256 public REWARD_AMOUNT_NIRODA = 1 ether; //
2925     uint256 public REWARD_AMOUNT_YATSUI = 1 ether; //
2926 
2927     uint256 public REWARD_INTERVAL = 1 days; // 1 day
2928     address public ethTokenAddress = 0x544279829C40802faC96d25Feae9347473593E00;
2929 
2930     string public baseURI =
2931         "ipfs://Qmf4g8HVouyCa78vPjRjUNWHrgBAFhhpmfaeMt91siGLLT/";
2932     string public uriSuffix = ".json";
2933 
2934     bytes32 public merkleRootAzmura =
2935         0x7b0e4a35445a923ac54757d1027165cc6b7450cd9ab67a12bd21a0a1e934c2f9;
2936     bytes32 public merkleRootMazuno =
2937         0x3fbb393eeaab07f0562b820d99c8045bd3d589cdf5521289502c044a8ee50eb8;
2938     bytes32 public merkleRootNiroda =
2939         0xb1f4a6a6422dd9e0b61f4e2af3ab21fd608b8ae2ce5debd45688fa0765ff16b3;
2940     bytes32 public merkleRootYatsui =
2941         0x2ec4dfa3300fac13f8f7ba83caec0c27a1947f7e3dbdbb726f7fe06426f753fa;
2942 
2943     bytes32 public merkleRootWL =
2944         0xca9248acb357df49906452042960077cd486d1babe77a4584fc0c6744530908b;
2945 
2946     bool public WL_MINT_STATUS = true;
2947 
2948     mapping(uint256 => mapping(address => uint256)) public _lastRewardTime;
2949     mapping(address => uint256) public _claimedRewards;
2950     mapping(address => uint256) public publicMintAllowed;
2951 
2952     event Minted(address indexed owner, uint256 count);
2953 
2954     constructor() ERC721A("Kyojin Senshi", "KYO") {
2955         MAX_SUPPLY = 3200;
2956         _ethToken = IERC20(ethTokenAddress);
2957     }
2958 
2959     function _startTokenId() internal pure override returns (uint256) {
2960         return 1;
2961     }
2962 
2963     function mint(uint256 _amount) external payable {
2964         require(
2965             publicMintAllowed[msg.sender] + _amount <= MAX_PER_WALLET,
2966             "Max limit per wallet reached!"
2967         );
2968         require(totalSupply() + _amount <= MAX_SUPPLY, "Sold out");
2969         require(!WL_MINT_STATUS, "Public Mint is turned off at the moment");
2970         require(_amount > 0 && _amount <= MAX_PER_WALLET, "Invalid Amount!");
2971      
2972         require(msg.value >= MINT_PRICE * _amount, "Not enough ether provided!");
2973 
2974         for (uint256 i = 1; i <= _amount; i++) {
2975             uint256 token = totalSupply() + i;
2976             _lastRewardTime[token][msg.sender] = block.timestamp;
2977         }
2978 
2979         publicMintAllowed[msg.sender] += _amount;
2980         _safeMint(msg.sender, _amount);
2981         emit Minted(msg.sender, _amount);
2982     }
2983 
2984     function mintWL(bytes32[] memory merkleProof, uint256 _amount)
2985         external
2986         payable
2987     {
2988         require(
2989             MerkleProof.verify(
2990                 merkleProof,
2991                 merkleRootWL,
2992                 keccak256(abi.encodePacked(msg.sender))
2993             ),
2994             "Not a part of Allowlist"
2995         );
2996         require(WL_MINT_STATUS, "Public Mint is turned off at the moment");
2997         require(
2998             publicMintAllowed[msg.sender] + _amount <= MAX_PER_WALLET,
2999             "Max limit per wallet reached!"
3000         );
3001         require(totalSupply() + _amount <= MAX_SUPPLY, "Sold out");
3002         require(_amount > 0 && _amount <= MAX_PER_WALLET, "Invalid Amount!");
3003         
3004         require(msg.value >= MINT_PRICE * _amount, "Not enough ether provided!");
3005 
3006         for (uint256 i = 1; i <= _amount; i++) {
3007             uint256 token = totalSupply() + i;
3008             _lastRewardTime[token][msg.sender] = block.timestamp;
3009         }
3010 
3011         publicMintAllowed[msg.sender] += _amount;
3012         _safeMint(msg.sender, _amount);
3013         emit Minted(msg.sender, _amount);
3014     }
3015 
3016     function claimReward(
3017         uint256[] memory tokensOwned,
3018         bytes32[][] memory merkleProof
3019     ) external {
3020         uint256 totalRewards = 0;
3021         for (uint256 i = 0; i < tokensOwned.length; i++) {
3022             string memory tokenString = Strings.toString(tokensOwned[i]);
3023             bytes32 leaf = keccak256(abi.encodePacked(tokenString));
3024             bytes32[] memory _merkleProof = merkleProof[i];
3025             require(
3026                 ownerOf(tokensOwned[i]) == msg.sender,
3027                 "You are not the owner of this token."
3028             );
3029 
3030             if (MerkleProof.verify(_merkleProof, merkleRootAzmura, leaf)) {
3031                 uint256 lastRewardTime = _lastRewardTime[tokensOwned[i]][
3032                     msg.sender
3033                 ];
3034                 if (lastRewardTime + REWARD_INTERVAL <= block.timestamp) {
3035                     uint256 numRewards = (block.timestamp - lastRewardTime) /
3036                         REWARD_INTERVAL;
3037                     require(numRewards > 0, "No rewards available");
3038                     uint256 reward = REWARD_AMOUNT_AZMURA * numRewards;
3039                     totalRewards += reward;
3040                     require(_ethToken.balanceOf(address(this)) >= reward);
3041                     _claimedRewards[msg.sender] += reward;
3042                     _lastRewardTime[tokensOwned[i]][msg.sender] +=
3043                         numRewards *
3044                         REWARD_INTERVAL;
3045                     require(
3046                         _ethToken.balanceOf(address(this)) >= reward,
3047                         "Insufficient contract balance"
3048                     );
3049                     _ethToken.approve(address(this), reward);
3050                     require(
3051                         _ethToken.transferFrom(
3052                             address(this),
3053                             msg.sender,
3054                             reward
3055                         ),
3056                         "transfer failed"
3057                     );
3058                 }
3059             }
3060 
3061             if (MerkleProof.verify(_merkleProof, merkleRootMazuno, leaf)) {
3062                 uint256 lastRewardTime = _lastRewardTime[tokensOwned[i]][
3063                     msg.sender
3064                 ];
3065                 if (lastRewardTime + REWARD_INTERVAL <= block.timestamp) {
3066                     uint256 numRewards = (block.timestamp - lastRewardTime) /
3067                         REWARD_INTERVAL;
3068                     require(numRewards > 0, "No rewards available");
3069                     uint256 reward = REWARD_AMOUNT_MAZUNO * numRewards;
3070                     totalRewards += reward;
3071                     require(_ethToken.balanceOf(address(this)) >= reward);
3072                     _claimedRewards[msg.sender] += reward;
3073                     _lastRewardTime[tokensOwned[i]][msg.sender] +=
3074                         numRewards *
3075                         REWARD_INTERVAL;
3076                     require(
3077                         _ethToken.balanceOf(address(this)) >= reward,
3078                         "Insufficient contract balance"
3079                     );
3080                     _ethToken.approve(address(this), reward);
3081                     require(
3082                         _ethToken.transferFrom(
3083                             address(this),
3084                             msg.sender,
3085                             reward
3086                         ),
3087                         "transfer failed"
3088                     );
3089                 }
3090             }
3091 
3092             if (MerkleProof.verify(_merkleProof, merkleRootNiroda, leaf)) {
3093                 uint256 lastRewardTime = _lastRewardTime[tokensOwned[i]][
3094                     msg.sender
3095                 ];
3096                 if (lastRewardTime + REWARD_INTERVAL <= block.timestamp) {
3097                     uint256 numRewards = (block.timestamp - lastRewardTime) /
3098                         REWARD_INTERVAL;
3099                     require(numRewards > 0, "No rewards available");
3100                     uint256 reward = REWARD_AMOUNT_NIRODA * numRewards;
3101                     totalRewards += reward;
3102                     require(_ethToken.balanceOf(address(this)) >= reward);
3103                     _claimedRewards[msg.sender] += reward;
3104                     _lastRewardTime[tokensOwned[i]][msg.sender] +=
3105                         numRewards *
3106                         REWARD_INTERVAL;
3107                     require(
3108                         _ethToken.balanceOf(address(this)) >= reward,
3109                         "Insufficient contract balance"
3110                     );
3111                     _ethToken.approve(address(this), reward);
3112                     require(
3113                         _ethToken.transferFrom(
3114                             address(this),
3115                             msg.sender,
3116                             reward
3117                         ),
3118                         "transfer failed"
3119                     );
3120                 }
3121             }
3122 
3123             if (MerkleProof.verify(_merkleProof, merkleRootYatsui, leaf)) {
3124                 uint256 lastRewardTime = _lastRewardTime[tokensOwned[i]][
3125                     msg.sender
3126                 ];
3127                 if (lastRewardTime + REWARD_INTERVAL <= block.timestamp) {
3128                     uint256 numRewards = (block.timestamp - lastRewardTime) /
3129                         REWARD_INTERVAL;
3130                     require(numRewards > 0, "No rewards available");
3131                     uint256 reward = REWARD_AMOUNT_YATSUI * numRewards;
3132                     totalRewards += reward;
3133                     require(_ethToken.balanceOf(address(this)) >= reward);
3134                     _claimedRewards[msg.sender] += reward;
3135                     _lastRewardTime[tokensOwned[i]][msg.sender] +=
3136                         numRewards *
3137                         REWARD_INTERVAL;
3138                     require(
3139                         _ethToken.balanceOf(address(this)) >= reward,
3140                         "Insufficient contract balance"
3141                     );
3142                     _ethToken.approve(address(this), reward);
3143                     require(
3144                         _ethToken.transferFrom(
3145                             address(this),
3146                             msg.sender,
3147                             reward
3148                         ),
3149                         "transfer failed"
3150                     );
3151                 }
3152             }
3153         }
3154         require(totalRewards > 0, "Cannot claim 0 rewards");
3155     }
3156 
3157     function airdrop(address[] calldata _to, uint256 amount)
3158         external
3159         payable
3160         onlyOwner
3161     {
3162         require(totalSupply() + amount <= MAX_SUPPLY, "Sold out");
3163         for (uint256 i = 0; i < _to.length; i++) {
3164             _safeMint(_to[i], amount);
3165         }
3166     }
3167 
3168     function airdropMultiple(address[] calldata _to, uint256[] calldata amount)
3169         external
3170         payable
3171         onlyOwner
3172     {
3173         for (uint256 i = 0; i < _to.length; i++) {
3174             require(totalSupply() + amount[i] <= MAX_SUPPLY, "Sold out");
3175             _safeMint(_to[i], amount[i]);
3176         }
3177     }
3178 
3179     function treasuryMint(uint256 quantity) public onlyOwner {
3180         require(quantity > 0, "Invalid mint amount");
3181         require(
3182             totalSupply() + quantity <= MAX_SUPPLY,
3183             "Maximum supply exceeded"
3184         );
3185         _safeMint(msg.sender, quantity);
3186     }
3187 
3188     function tokenURI(uint256 tokenId)
3189         public
3190         view
3191         override(ERC721A, IERC721A)
3192         returns (string memory)
3193     {
3194         require(
3195             _exists(tokenId),
3196             "Err: ERC721AMetadata - URI query for nonexistent token"
3197         );
3198 
3199         return
3200             bytes(baseURI).length > 0
3201                 ? string(
3202                     abi.encodePacked(baseURI, _toString(tokenId), uriSuffix)
3203                 )
3204                 : "";
3205     }
3206 
3207     function withdraw() public payable onlyOwner {
3208         // =============================================================================
3209         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
3210         require(os);
3211         // =============================================================================
3212     }
3213 
3214     function withdraw_token(address _token) public onlyOwner {
3215         uint256 balance = ERC20(_token).balanceOf(address(this));
3216         require(balance > 0, "zero amount");
3217         ERC20(_token).transfer(msg.sender, balance);
3218     }
3219 
3220     function _baseURI() internal view override returns (string memory) {
3221         return baseURI;
3222     }
3223 
3224     function setPrice(uint256 _price) public onlyOwner {
3225         MINT_PRICE = _price;
3226     }
3227 
3228     function toggleWLMintStatus() public onlyOwner {
3229         WL_MINT_STATUS = !WL_MINT_STATUS;
3230     }
3231 
3232     function setBaseURI(string memory _newBaseURI) public onlyOwner {
3233         baseURI = _newBaseURI;
3234     }
3235 
3236     function setMaxPerWallet(uint256 _value) public onlyOwner {
3237         MAX_PER_WALLET = _value;
3238     }
3239 
3240     function setMerkleRootWL(bytes32 _merkleRoot) external onlyOwner {
3241         merkleRootWL = _merkleRoot;
3242     }
3243 
3244     function setRewardAmountAzmura(uint256 _reward) external onlyOwner {
3245         REWARD_AMOUNT_AZMURA = _reward;
3246     }
3247 
3248     function setRewardAmountMazuno(uint256 _reward) external onlyOwner {
3249         REWARD_AMOUNT_MAZUNO = _reward;
3250     }
3251 
3252     function setRewardAmountNiroda(uint256 _reward) external onlyOwner {
3253         REWARD_AMOUNT_NIRODA = _reward;
3254     }
3255 
3256     function setRewardAmountYatsui(uint256 _reward) external onlyOwner {
3257         REWARD_AMOUNT_YATSUI = _reward;
3258     }
3259 
3260     function setRewardInterval(uint256 _interval) external onlyOwner {
3261         REWARD_INTERVAL = _interval;
3262     }
3263 
3264     
3265 
3266     /**
3267      * @dev See {IERC721-setApprovalForAll}.
3268      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
3269      */
3270     function setApprovalForAll(address operator, bool approved)
3271         public
3272         override(ERC721A, IERC721A)
3273         onlyAllowedOperatorApproval(operator)
3274     {
3275         super.setApprovalForAll(operator, approved);
3276     }
3277 
3278     /**
3279      * @dev See {IERC721-approve}.
3280      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
3281      */
3282     function approve(address operator, uint256 tokenId)
3283         public
3284         payable
3285         override(ERC721A, IERC721A)
3286         onlyAllowedOperatorApproval(operator)
3287     {
3288         super.approve(operator, tokenId);
3289     }
3290 
3291     /**
3292      * @dev See {IERC721-transferFrom}.
3293      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
3294      */
3295     function transferFrom(
3296         address from,
3297         address to,
3298         uint256 tokenId
3299     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3300         super.transferFrom(from, to, tokenId);
3301         _lastRewardTime[tokenId][from] = block.timestamp;
3302         _lastRewardTime[tokenId][to] = block.timestamp;
3303     }
3304 
3305     /**
3306      * @dev See {IERC721-safeTransferFrom}.
3307      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
3308      */
3309     function safeTransferFrom(
3310         address from,
3311         address to,
3312         uint256 tokenId
3313     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3314         super.safeTransferFrom(from, to, tokenId);
3315         _lastRewardTime[tokenId][from] = block.timestamp;
3316         _lastRewardTime[tokenId][to] = block.timestamp;
3317     }
3318 
3319     /**
3320      * @dev See {IERC721-safeTransferFrom}.
3321      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
3322      */
3323     function safeTransferFrom(
3324         address from,
3325         address to,
3326         uint256 tokenId,
3327         bytes memory data
3328     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3329         super.safeTransferFrom(from, to, tokenId, data);
3330         _lastRewardTime[tokenId][from] = block.timestamp;
3331         _lastRewardTime[tokenId][to] = block.timestamp;
3332     }
3333 
3334     /**
3335      * @dev See {IERC165-supportsInterface}.
3336      */
3337     function supportsInterface(bytes4 interfaceId)
3338         public
3339         view
3340         virtual
3341         override(ERC721A, IERC721A, ERC2981)
3342         returns (bool)
3343     {
3344         return super.supportsInterface(interfaceId);
3345     }
3346 }