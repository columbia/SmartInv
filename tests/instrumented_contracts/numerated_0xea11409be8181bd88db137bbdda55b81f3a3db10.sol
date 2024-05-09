1 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/lib/Constants.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
7 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
8 
9 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
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
151 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
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
230 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol
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
249 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/utils/math/SafeMath.sol
250 
251 
252 
253 pragma solidity ^0.8.0;
254 
255 // CAUTION
256 // This version of SafeMath should only be used with Solidity 0.8 or later,
257 // because it relies on the compiler's built in overflow checks.
258 
259 /**
260  * @dev Wrappers over Solidity's arithmetic operations.
261  *
262  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
263  * now has built in overflow checking.
264  */
265 library SafeMath {
266     /**
267      * @dev Returns the addition of two unsigned integers, with an overflow flag.
268      *
269      * _Available since v3.4._
270      */
271     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
272         unchecked {
273             uint256 c = a + b;
274             if (c < a) return (false, 0);
275             return (true, c);
276         }
277     }
278 
279     /**
280      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
281      *
282      * _Available since v3.4._
283      */
284     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         unchecked {
286             if (b > a) return (false, 0);
287             return (true, a - b);
288         }
289     }
290 
291     /**
292      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
293      *
294      * _Available since v3.4._
295      */
296     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
297         unchecked {
298             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
299             // benefit is lost if 'b' is also tested.
300             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
301             if (a == 0) return (true, 0);
302             uint256 c = a * b;
303             if (c / a != b) return (false, 0);
304             return (true, c);
305         }
306     }
307 
308     /**
309      * @dev Returns the division of two unsigned integers, with a division by zero flag.
310      *
311      * _Available since v3.4._
312      */
313     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
314         unchecked {
315             if (b == 0) return (false, 0);
316             return (true, a / b);
317         }
318     }
319 
320     /**
321      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
322      *
323      * _Available since v3.4._
324      */
325     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
326         unchecked {
327             if (b == 0) return (false, 0);
328             return (true, a % b);
329         }
330     }
331 
332     /**
333      * @dev Returns the addition of two unsigned integers, reverting on
334      * overflow.
335      *
336      * Counterpart to Solidity's `+` operator.
337      *
338      * Requirements:
339      *
340      * - Addition cannot overflow.
341      */
342     function add(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a + b;
344     }
345 
346     /**
347      * @dev Returns the subtraction of two unsigned integers, reverting on
348      * overflow (when the result is negative).
349      *
350      * Counterpart to Solidity's `-` operator.
351      *
352      * Requirements:
353      *
354      * - Subtraction cannot overflow.
355      */
356     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
357         return a - b;
358     }
359 
360     /**
361      * @dev Returns the multiplication of two unsigned integers, reverting on
362      * overflow.
363      *
364      * Counterpart to Solidity's `*` operator.
365      *
366      * Requirements:
367      *
368      * - Multiplication cannot overflow.
369      */
370     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a * b;
372     }
373 
374     /**
375      * @dev Returns the integer division of two unsigned integers, reverting on
376      * division by zero. The result is rounded towards zero.
377      *
378      * Counterpart to Solidity's `/` operator.
379      *
380      * Requirements:
381      *
382      * - The divisor cannot be zero.
383      */
384     function div(uint256 a, uint256 b) internal pure returns (uint256) {
385         return a / b;
386     }
387 
388     /**
389      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
390      * reverting when dividing by zero.
391      *
392      * Counterpart to Solidity's `%` operator. This function uses a `revert`
393      * opcode (which leaves remaining gas untouched) while Solidity uses an
394      * invalid opcode to revert (consuming all remaining gas).
395      *
396      * Requirements:
397      *
398      * - The divisor cannot be zero.
399      */
400     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
401         return a % b;
402     }
403 
404     /**
405      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
406      * overflow (when the result is negative).
407      *
408      * CAUTION: This function is deprecated because it requires allocating memory for the error
409      * message unnecessarily. For custom revert reasons use {trySub}.
410      *
411      * Counterpart to Solidity's `-` operator.
412      *
413      * Requirements:
414      *
415      * - Subtraction cannot overflow.
416      */
417     function sub(
418         uint256 a,
419         uint256 b,
420         string memory errorMessage
421     ) internal pure returns (uint256) {
422         unchecked {
423             require(b <= a, errorMessage);
424             return a - b;
425         }
426     }
427 
428     /**
429      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
430      * division by zero. The result is rounded towards zero.
431      *
432      * Counterpart to Solidity's `/` operator. Note: this function uses a
433      * `revert` opcode (which leaves remaining gas untouched) while Solidity
434      * uses an invalid opcode to revert (consuming all remaining gas).
435      *
436      * Requirements:
437      *
438      * - The divisor cannot be zero.
439      */
440     function div(
441         uint256 a,
442         uint256 b,
443         string memory errorMessage
444     ) internal pure returns (uint256) {
445         unchecked {
446             require(b > 0, errorMessage);
447             return a / b;
448         }
449     }
450 
451     /**
452      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
453      * reverting with custom message when dividing by zero.
454      *
455      * CAUTION: This function is deprecated because it requires allocating memory for the error
456      * message unnecessarily. For custom revert reasons use {tryMod}.
457      *
458      * Counterpart to Solidity's `%` operator. This function uses a `revert`
459      * opcode (which leaves remaining gas untouched) while Solidity uses an
460      * invalid opcode to revert (consuming all remaining gas).
461      *
462      * Requirements:
463      *
464      * - The divisor cannot be zero.
465      */
466     function mod(
467         uint256 a,
468         uint256 b,
469         string memory errorMessage
470     ) internal pure returns (uint256) {
471         unchecked {
472             require(b > 0, errorMessage);
473             return a % b;
474         }
475     }
476 }
477 
478 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/utils/Context.sol
479 
480 
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev Provides information about the current execution context, including the
486  * sender of the transaction and its data. While these are generally available
487  * via msg.sender and msg.data, they should not be accessed in such a direct
488  * manner, since when dealing with meta-transactions the account sending and
489  * paying for execution may not be the actual sender (as far as an application
490  * is concerned).
491  *
492  * This contract is only required for intermediate, library-like contracts.
493  */
494 abstract contract Context {
495     function _msgSender() internal view virtual returns (address) {
496         return msg.sender;
497     }
498 
499     function _msgData() internal view virtual returns (bytes calldata) {
500         return msg.data;
501     }
502 }
503 
504 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/access/Ownable.sol
505 
506 
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @dev Contract module which provides a basic access control mechanism, where
513  * there is an account (an owner) that can be granted exclusive access to
514  * specific functions.
515  *
516  * By default, the owner account will be the one that deploys the contract. This
517  * can later be changed with {transferOwnership}.
518  *
519  * This module is used through inheritance. It will make available the modifier
520  * `onlyOwner`, which can be applied to your functions to restrict their use to
521  * the owner.
522  */
523 abstract contract Ownable is Context {
524     address private _owner;
525 
526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
527 
528     /**
529      * @dev Initializes the contract setting the deployer as the initial owner.
530      */
531     constructor() {
532         _setOwner(_msgSender());
533     }
534 
535     /**
536      * @dev Returns the address of the current owner.
537      */
538     function owner() public view virtual returns (address) {
539         return _owner;
540     }
541 
542     /**
543      * @dev Throws if called by any account other than the owner.
544      */
545     modifier onlyOwner() {
546         require(owner() == _msgSender(), "Ownable: caller is not the owner");
547         _;
548     }
549 
550     /**
551      * @dev Leaves the contract without owner. It will not be possible to call
552      * `onlyOwner` functions anymore. Can only be called by the current owner.
553      *
554      * NOTE: Renouncing ownership will leave the contract without an owner,
555      * thereby removing any functionality that is only available to the owner.
556      */
557     function renounceOwnership() public virtual onlyOwner {
558         _setOwner(address(0));
559     }
560 
561     /**
562      * @dev Transfers ownership of the contract to a new account (`newOwner`).
563      * Can only be called by the current owner.
564      */
565     function transferOwnership(address newOwner) public virtual onlyOwner {
566         require(newOwner != address(0), "Ownable: new owner is the zero address");
567         _setOwner(newOwner);
568     }
569 
570     function _setOwner(address newOwner) private {
571         address oldOwner = _owner;
572         _owner = newOwner;
573         emit OwnershipTransferred(oldOwner, newOwner);
574     }
575 }
576 
577 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
578 
579 
580 // ERC721A Contracts v4.2.3
581 // Creator: Chiru Labs
582 
583 pragma solidity ^0.8.4;
584 
585 /**
586  * @dev Interface of ERC721A.
587  */
588 interface IERC721A {
589     /**
590      * The caller must own the token or be an approved operator.
591      */
592     error ApprovalCallerNotOwnerNorApproved();
593 
594     /**
595      * The token does not exist.
596      */
597     error ApprovalQueryForNonexistentToken();
598 
599     /**
600      * Cannot query the balance for the zero address.
601      */
602     error BalanceQueryForZeroAddress();
603 
604     /**
605      * Cannot mint to the zero address.
606      */
607     error MintToZeroAddress();
608 
609     /**
610      * The quantity of tokens minted must be more than zero.
611      */
612     error MintZeroQuantity();
613 
614     /**
615      * The token does not exist.
616      */
617     error OwnerQueryForNonexistentToken();
618 
619     /**
620      * The caller must own the token or be an approved operator.
621      */
622     error TransferCallerNotOwnerNorApproved();
623 
624     /**
625      * The token must be owned by `from`.
626      */
627     error TransferFromIncorrectOwner();
628 
629     /**
630      * Cannot safely transfer to a contract that does not implement the
631      * ERC721Receiver interface.
632      */
633     error TransferToNonERC721ReceiverImplementer();
634 
635     /**
636      * Cannot transfer to the zero address.
637      */
638     error TransferToZeroAddress();
639 
640     /**
641      * The token does not exist.
642      */
643     error URIQueryForNonexistentToken();
644 
645     /**
646      * The `quantity` minted with ERC2309 exceeds the safety limit.
647      */
648     error MintERC2309QuantityExceedsLimit();
649 
650     /**
651      * The `extraData` cannot be set on an unintialized ownership slot.
652      */
653     error OwnershipNotInitializedForExtraData();
654 
655     // =============================================================
656     //                            STRUCTS
657     // =============================================================
658 
659     struct TokenOwnership {
660         // The address of the owner.
661         address addr;
662         // Stores the start time of ownership with minimal overhead for tokenomics.
663         uint64 startTimestamp;
664         // Whether the token has been burned.
665         bool burned;
666         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
667         uint24 extraData;
668     }
669 
670     // =============================================================
671     //                         TOKEN COUNTERS
672     // =============================================================
673 
674     /**
675      * @dev Returns the total number of tokens in existence.
676      * Burned tokens will reduce the count.
677      * To get the total number of tokens minted, please see {_totalMinted}.
678      */
679     function totalSupply() external view returns (uint256);
680 
681     // =============================================================
682     //                            IERC165
683     // =============================================================
684 
685     /**
686      * @dev Returns true if this contract implements the interface defined by
687      * `interfaceId`. See the corresponding
688      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
689      * to learn more about how these ids are created.
690      *
691      * This function call must use less than 30000 gas.
692      */
693     function supportsInterface(bytes4 interfaceId) external view returns (bool);
694 
695     // =============================================================
696     //                            IERC721
697     // =============================================================
698 
699     /**
700      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
701      */
702     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
703 
704     /**
705      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
706      */
707     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
708 
709     /**
710      * @dev Emitted when `owner` enables or disables
711      * (`approved`) `operator` to manage all of its assets.
712      */
713     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
714 
715     /**
716      * @dev Returns the number of tokens in `owner`'s account.
717      */
718     function balanceOf(address owner) external view returns (uint256 balance);
719 
720     /**
721      * @dev Returns the owner of the `tokenId` token.
722      *
723      * Requirements:
724      *
725      * - `tokenId` must exist.
726      */
727     function ownerOf(uint256 tokenId) external view returns (address owner);
728 
729     /**
730      * @dev Safely transfers `tokenId` token from `from` to `to`,
731      * checking first that contract recipients are aware of the ERC721 protocol
732      * to prevent tokens from being forever locked.
733      *
734      * Requirements:
735      *
736      * - `from` cannot be the zero address.
737      * - `to` cannot be the zero address.
738      * - `tokenId` token must exist and be owned by `from`.
739      * - If the caller is not `from`, it must be have been allowed to move
740      * this token by either {approve} or {setApprovalForAll}.
741      * - If `to` refers to a smart contract, it must implement
742      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes calldata data
751     ) external payable;
752 
753     /**
754      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) external payable;
761 
762     /**
763      * @dev Transfers `tokenId` from `from` to `to`.
764      *
765      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
766      * whenever possible.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must be owned by `from`.
773      * - If the caller is not `from`, it must be approved to move this token
774      * by either {approve} or {setApprovalForAll}.
775      *
776      * Emits a {Transfer} event.
777      */
778     function transferFrom(
779         address from,
780         address to,
781         uint256 tokenId
782     ) external payable;
783 
784     /**
785      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
786      * The approval is cleared when the token is transferred.
787      *
788      * Only a single account can be approved at a time, so approving the
789      * zero address clears previous approvals.
790      *
791      * Requirements:
792      *
793      * - The caller must own the token or be an approved operator.
794      * - `tokenId` must exist.
795      *
796      * Emits an {Approval} event.
797      */
798     function approve(address to, uint256 tokenId) external payable;
799 
800     /**
801      * @dev Approve or remove `operator` as an operator for the caller.
802      * Operators can call {transferFrom} or {safeTransferFrom}
803      * for any token owned by the caller.
804      *
805      * Requirements:
806      *
807      * - The `operator` cannot be the caller.
808      *
809      * Emits an {ApprovalForAll} event.
810      */
811     function setApprovalForAll(address operator, bool _approved) external;
812 
813     /**
814      * @dev Returns the account approved for `tokenId` token.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      */
820     function getApproved(uint256 tokenId) external view returns (address operator);
821 
822     /**
823      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
824      *
825      * See {setApprovalForAll}.
826      */
827     function isApprovedForAll(address owner, address operator) external view returns (bool);
828 
829     // =============================================================
830     //                        IERC721Metadata
831     // =============================================================
832 
833     /**
834      * @dev Returns the token collection name.
835      */
836     function name() external view returns (string memory);
837 
838     /**
839      * @dev Returns the token collection symbol.
840      */
841     function symbol() external view returns (string memory);
842 
843     /**
844      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
845      */
846     function tokenURI(uint256 tokenId) external view returns (string memory);
847 
848     // =============================================================
849     //                           IERC2309
850     // =============================================================
851 
852     /**
853      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
854      * (inclusive) is transferred from `from` to `to`, as defined in the
855      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
856      *
857      * See {_mintERC2309} for more details.
858      */
859     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
860 }
861 
862 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
863 
864 
865 // ERC721A Contracts v4.2.3
866 // Creator: Chiru Labs
867 
868 pragma solidity ^0.8.4;
869 
870 
871 /**
872  * @dev Interface of ERC721 token receiver.
873  */
874 interface ERC721A__IERC721Receiver {
875     function onERC721Received(
876         address operator,
877         address from,
878         uint256 tokenId,
879         bytes calldata data
880     ) external returns (bytes4);
881 }
882 
883 /**
884  * @title ERC721A
885  *
886  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
887  * Non-Fungible Token Standard, including the Metadata extension.
888  * Optimized for lower gas during batch mints.
889  *
890  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
891  * starting from `_startTokenId()`.
892  *
893  * Assumptions:
894  *
895  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
896  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
897  */
898 contract ERC721A is IERC721A {
899     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
900     struct TokenApprovalRef {
901         address value;
902     }
903 
904     // =============================================================
905     //                           CONSTANTS
906     // =============================================================
907 
908     // Mask of an entry in packed address data.
909     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
910 
911     // The bit position of `numberMinted` in packed address data.
912     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
913 
914     // The bit position of `numberBurned` in packed address data.
915     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
916 
917     // The bit position of `aux` in packed address data.
918     uint256 private constant _BITPOS_AUX = 192;
919 
920     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
921     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
922 
923     // The bit position of `startTimestamp` in packed ownership.
924     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
925 
926     // The bit mask of the `burned` bit in packed ownership.
927     uint256 private constant _BITMASK_BURNED = 1 << 224;
928 
929     // The bit position of the `nextInitialized` bit in packed ownership.
930     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
931 
932     // The bit mask of the `nextInitialized` bit in packed ownership.
933     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
934 
935     // The bit position of `extraData` in packed ownership.
936     uint256 private constant _BITPOS_EXTRA_DATA = 232;
937 
938     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
939     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
940 
941     // The mask of the lower 160 bits for addresses.
942     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
943 
944     // The maximum `quantity` that can be minted with {_mintERC2309}.
945     // This limit is to prevent overflows on the address data entries.
946     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
947     // is required to cause an overflow, which is unrealistic.
948     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
949 
950     // The `Transfer` event signature is given by:
951     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
952     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
953         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
954 
955     // =============================================================
956     //                            STORAGE
957     // =============================================================
958 
959     // The next token ID to be minted.
960     uint256 private _currentIndex;
961 
962     // The number of tokens burned.
963     uint256 private _burnCounter;
964 
965     // Token name
966     string private _name;
967 
968     // Token symbol
969     string private _symbol;
970 
971     // Mapping from token ID to ownership details
972     // An empty struct value does not necessarily mean the token is unowned.
973     // See {_packedOwnershipOf} implementation for details.
974     //
975     // Bits Layout:
976     // - [0..159]   `addr`
977     // - [160..223] `startTimestamp`
978     // - [224]      `burned`
979     // - [225]      `nextInitialized`
980     // - [232..255] `extraData`
981     mapping(uint256 => uint256) private _packedOwnerships;
982 
983     // Mapping owner address to address data.
984     //
985     // Bits Layout:
986     // - [0..63]    `balance`
987     // - [64..127]  `numberMinted`
988     // - [128..191] `numberBurned`
989     // - [192..255] `aux`
990     mapping(address => uint256) private _packedAddressData;
991 
992     // Mapping from token ID to approved address.
993     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
994 
995     // Mapping from owner to operator approvals
996     mapping(address => mapping(address => bool)) private _operatorApprovals;
997 
998     // =============================================================
999     //                          CONSTRUCTOR
1000     // =============================================================
1001 
1002     constructor(string memory name_, string memory symbol_) {
1003         _name = name_;
1004         _symbol = symbol_;
1005         _currentIndex = _startTokenId();
1006     }
1007 
1008     // =============================================================
1009     //                   TOKEN COUNTING OPERATIONS
1010     // =============================================================
1011 
1012     /**
1013      * @dev Returns the starting token ID.
1014      * To change the starting token ID, please override this function.
1015      */
1016     function _startTokenId() internal view virtual returns (uint256) {
1017         return 0;
1018     }
1019 
1020     /**
1021      * @dev Returns the next token ID to be minted.
1022      */
1023     function _nextTokenId() internal view virtual returns (uint256) {
1024         return _currentIndex;
1025     }
1026 
1027     /**
1028      * @dev Returns the total number of tokens in existence.
1029      * Burned tokens will reduce the count.
1030      * To get the total number of tokens minted, please see {_totalMinted}.
1031      */
1032     function totalSupply() public view virtual override returns (uint256) {
1033         // Counter underflow is impossible as _burnCounter cannot be incremented
1034         // more than `_currentIndex - _startTokenId()` times.
1035         unchecked {
1036             return _currentIndex - _burnCounter - _startTokenId();
1037         }
1038     }
1039 
1040     /**
1041      * @dev Returns the total amount of tokens minted in the contract.
1042      */
1043     function _totalMinted() internal view virtual returns (uint256) {
1044         // Counter underflow is impossible as `_currentIndex` does not decrement,
1045         // and it is initialized to `_startTokenId()`.
1046         unchecked {
1047             return _currentIndex - _startTokenId();
1048         }
1049     }
1050 
1051     /**
1052      * @dev Returns the total number of tokens burned.
1053      */
1054     function _totalBurned() internal view virtual returns (uint256) {
1055         return _burnCounter;
1056     }
1057 
1058     // =============================================================
1059     //                    ADDRESS DATA OPERATIONS
1060     // =============================================================
1061 
1062     /**
1063      * @dev Returns the number of tokens in `owner`'s account.
1064      */
1065     function balanceOf(address owner) public view virtual override returns (uint256) {
1066         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
1067         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1068     }
1069 
1070     /**
1071      * Returns the number of tokens minted by `owner`.
1072      */
1073     function _numberMinted(address owner) internal view returns (uint256) {
1074         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1075     }
1076 
1077     /**
1078      * Returns the number of tokens burned by or on behalf of `owner`.
1079      */
1080     function _numberBurned(address owner) internal view returns (uint256) {
1081         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1082     }
1083 
1084     /**
1085      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1086      */
1087     function _getAux(address owner) internal view returns (uint64) {
1088         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1089     }
1090 
1091     /**
1092      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1093      * If there are multiple variables, please pack them into a uint64.
1094      */
1095     function _setAux(address owner, uint64 aux) internal virtual {
1096         uint256 packed = _packedAddressData[owner];
1097         uint256 auxCasted;
1098         // Cast `aux` with assembly to avoid redundant masking.
1099         assembly {
1100             auxCasted := aux
1101         }
1102         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1103         _packedAddressData[owner] = packed;
1104     }
1105 
1106     // =============================================================
1107     //                            IERC165
1108     // =============================================================
1109 
1110     /**
1111      * @dev Returns true if this contract implements the interface defined by
1112      * `interfaceId`. See the corresponding
1113      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1114      * to learn more about how these ids are created.
1115      *
1116      * This function call must use less than 30000 gas.
1117      */
1118     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1119         // The interface IDs are constants representing the first 4 bytes
1120         // of the XOR of all function selectors in the interface.
1121         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1122         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1123         return
1124             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1125             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1126             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1127     }
1128 
1129     // =============================================================
1130     //                        IERC721Metadata
1131     // =============================================================
1132 
1133     /**
1134      * @dev Returns the token collection name.
1135      */
1136     function name() public view virtual override returns (string memory) {
1137         return _name;
1138     }
1139 
1140     /**
1141      * @dev Returns the token collection symbol.
1142      */
1143     function symbol() public view virtual override returns (string memory) {
1144         return _symbol;
1145     }
1146 
1147     /**
1148      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1149      */
1150     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1151         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
1152 
1153         string memory baseURI = _baseURI();
1154         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1155     }
1156 
1157     /**
1158      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1159      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1160      * by default, it can be overridden in child contracts.
1161      */
1162     function _baseURI() internal view virtual returns (string memory) {
1163         return '';
1164     }
1165 
1166     // =============================================================
1167     //                     OWNERSHIPS OPERATIONS
1168     // =============================================================
1169 
1170     /**
1171      * @dev Returns the owner of the `tokenId` token.
1172      *
1173      * Requirements:
1174      *
1175      * - `tokenId` must exist.
1176      */
1177     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1178         return address(uint160(_packedOwnershipOf(tokenId)));
1179     }
1180 
1181     /**
1182      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1183      * It gradually moves to O(1) as tokens get transferred around over time.
1184      */
1185     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1186         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1187     }
1188 
1189     /**
1190      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1191      */
1192     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1193         return _unpackedOwnership(_packedOwnerships[index]);
1194     }
1195 
1196     /**
1197      * @dev Returns whether the ownership slot at `index` is initialized.
1198      * An uninitialized slot does not necessarily mean that the slot has no owner.
1199      */
1200     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
1201         return _packedOwnerships[index] != 0;
1202     }
1203 
1204     /**
1205      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1206      */
1207     function _initializeOwnershipAt(uint256 index) internal virtual {
1208         if (_packedOwnerships[index] == 0) {
1209             _packedOwnerships[index] = _packedOwnershipOf(index);
1210         }
1211     }
1212 
1213     /**
1214      * Returns the packed ownership data of `tokenId`.
1215      */
1216     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1217         if (_startTokenId() <= tokenId) {
1218             packed = _packedOwnerships[tokenId];
1219             // If the data at the starting slot does not exist, start the scan.
1220             if (packed == 0) {
1221                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
1222                 // Invariant:
1223                 // There will always be an initialized ownership slot
1224                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1225                 // before an unintialized ownership slot
1226                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1227                 // Hence, `tokenId` will not underflow.
1228                 //
1229                 // We can directly compare the packed value.
1230                 // If the address is zero, packed will be zero.
1231                 for (;;) {
1232                     unchecked {
1233                         packed = _packedOwnerships[--tokenId];
1234                     }
1235                     if (packed == 0) continue;
1236                     if (packed & _BITMASK_BURNED == 0) return packed;
1237                     // Otherwise, the token is burned, and we must revert.
1238                     // This handles the case of batch burned tokens, where only the burned bit
1239                     // of the starting slot is set, and remaining slots are left uninitialized.
1240                     _revert(OwnerQueryForNonexistentToken.selector);
1241                 }
1242             }
1243             // Otherwise, the data exists and we can skip the scan.
1244             // This is possible because we have already achieved the target condition.
1245             // This saves 2143 gas on transfers of initialized tokens.
1246             // If the token is not burned, return `packed`. Otherwise, revert.
1247             if (packed & _BITMASK_BURNED == 0) return packed;
1248         }
1249         _revert(OwnerQueryForNonexistentToken.selector);
1250     }
1251 
1252     /**
1253      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1254      */
1255     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1256         ownership.addr = address(uint160(packed));
1257         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1258         ownership.burned = packed & _BITMASK_BURNED != 0;
1259         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1260     }
1261 
1262     /**
1263      * @dev Packs ownership data into a single uint256.
1264      */
1265     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1266         assembly {
1267             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1268             owner := and(owner, _BITMASK_ADDRESS)
1269             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1270             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1271         }
1272     }
1273 
1274     /**
1275      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1276      */
1277     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1278         // For branchless setting of the `nextInitialized` flag.
1279         assembly {
1280             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1281             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1282         }
1283     }
1284 
1285     // =============================================================
1286     //                      APPROVAL OPERATIONS
1287     // =============================================================
1288 
1289     /**
1290      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1291      *
1292      * Requirements:
1293      *
1294      * - The caller must own the token or be an approved operator.
1295      */
1296     function approve(address to, uint256 tokenId) public payable virtual override {
1297         _approve(to, tokenId, true);
1298     }
1299 
1300     /**
1301      * @dev Returns the account approved for `tokenId` token.
1302      *
1303      * Requirements:
1304      *
1305      * - `tokenId` must exist.
1306      */
1307     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1308         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
1309 
1310         return _tokenApprovals[tokenId].value;
1311     }
1312 
1313     /**
1314      * @dev Approve or remove `operator` as an operator for the caller.
1315      * Operators can call {transferFrom} or {safeTransferFrom}
1316      * for any token owned by the caller.
1317      *
1318      * Requirements:
1319      *
1320      * - The `operator` cannot be the caller.
1321      *
1322      * Emits an {ApprovalForAll} event.
1323      */
1324     function setApprovalForAll(address operator, bool approved) public virtual override {
1325         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1326         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1327     }
1328 
1329     /**
1330      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1331      *
1332      * See {setApprovalForAll}.
1333      */
1334     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1335         return _operatorApprovals[owner][operator];
1336     }
1337 
1338     /**
1339      * @dev Returns whether `tokenId` exists.
1340      *
1341      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1342      *
1343      * Tokens start existing when they are minted. See {_mint}.
1344      */
1345     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
1346         if (_startTokenId() <= tokenId) {
1347             if (tokenId < _currentIndex) {
1348                 uint256 packed;
1349                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
1350                 result = packed & _BITMASK_BURNED == 0;
1351             }
1352         }
1353     }
1354 
1355     /**
1356      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1357      */
1358     function _isSenderApprovedOrOwner(
1359         address approvedAddress,
1360         address owner,
1361         address msgSender
1362     ) private pure returns (bool result) {
1363         assembly {
1364             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1365             owner := and(owner, _BITMASK_ADDRESS)
1366             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1367             msgSender := and(msgSender, _BITMASK_ADDRESS)
1368             // `msgSender == owner || msgSender == approvedAddress`.
1369             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1370         }
1371     }
1372 
1373     /**
1374      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1375      */
1376     function _getApprovedSlotAndAddress(uint256 tokenId)
1377         private
1378         view
1379         returns (uint256 approvedAddressSlot, address approvedAddress)
1380     {
1381         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1382         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1383         assembly {
1384             approvedAddressSlot := tokenApproval.slot
1385             approvedAddress := sload(approvedAddressSlot)
1386         }
1387     }
1388 
1389     // =============================================================
1390     //                      TRANSFER OPERATIONS
1391     // =============================================================
1392 
1393     /**
1394      * @dev Transfers `tokenId` from `from` to `to`.
1395      *
1396      * Requirements:
1397      *
1398      * - `from` cannot be the zero address.
1399      * - `to` cannot be the zero address.
1400      * - `tokenId` token must be owned by `from`.
1401      * - If the caller is not `from`, it must be approved to move this token
1402      * by either {approve} or {setApprovalForAll}.
1403      *
1404      * Emits a {Transfer} event.
1405      */
1406     function transferFrom(
1407         address from,
1408         address to,
1409         uint256 tokenId
1410     ) public payable virtual override {
1411         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1412 
1413         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1414         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
1415 
1416         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
1417 
1418         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1419 
1420         // The nested ifs save around 20+ gas over a compound boolean condition.
1421         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1422             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1423 
1424         _beforeTokenTransfers(from, to, tokenId, 1);
1425 
1426         // Clear approvals from the previous owner.
1427         assembly {
1428             if approvedAddress {
1429                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1430                 sstore(approvedAddressSlot, 0)
1431             }
1432         }
1433 
1434         // Underflow of the sender's balance is impossible because we check for
1435         // ownership above and the recipient's balance can't realistically overflow.
1436         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1437         unchecked {
1438             // We can directly increment and decrement the balances.
1439             --_packedAddressData[from]; // Updates: `balance -= 1`.
1440             ++_packedAddressData[to]; // Updates: `balance += 1`.
1441 
1442             // Updates:
1443             // - `address` to the next owner.
1444             // - `startTimestamp` to the timestamp of transfering.
1445             // - `burned` to `false`.
1446             // - `nextInitialized` to `true`.
1447             _packedOwnerships[tokenId] = _packOwnershipData(
1448                 to,
1449                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1450             );
1451 
1452             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1453             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1454                 uint256 nextTokenId = tokenId + 1;
1455                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1456                 if (_packedOwnerships[nextTokenId] == 0) {
1457                     // If the next slot is within bounds.
1458                     if (nextTokenId != _currentIndex) {
1459                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1460                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1461                     }
1462                 }
1463             }
1464         }
1465 
1466         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1467         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1468         assembly {
1469             // Emit the `Transfer` event.
1470             log4(
1471                 0, // Start of data (0, since no data).
1472                 0, // End of data (0, since no data).
1473                 _TRANSFER_EVENT_SIGNATURE, // Signature.
1474                 from, // `from`.
1475                 toMasked, // `to`.
1476                 tokenId // `tokenId`.
1477             )
1478         }
1479         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
1480 
1481         _afterTokenTransfers(from, to, tokenId, 1);
1482     }
1483 
1484     /**
1485      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1486      */
1487     function safeTransferFrom(
1488         address from,
1489         address to,
1490         uint256 tokenId
1491     ) public payable virtual override {
1492         safeTransferFrom(from, to, tokenId, '');
1493     }
1494 
1495     /**
1496      * @dev Safely transfers `tokenId` token from `from` to `to`.
1497      *
1498      * Requirements:
1499      *
1500      * - `from` cannot be the zero address.
1501      * - `to` cannot be the zero address.
1502      * - `tokenId` token must exist and be owned by `from`.
1503      * - If the caller is not `from`, it must be approved to move this token
1504      * by either {approve} or {setApprovalForAll}.
1505      * - If `to` refers to a smart contract, it must implement
1506      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1507      *
1508      * Emits a {Transfer} event.
1509      */
1510     function safeTransferFrom(
1511         address from,
1512         address to,
1513         uint256 tokenId,
1514         bytes memory _data
1515     ) public payable virtual override {
1516         transferFrom(from, to, tokenId);
1517         if (to.code.length != 0)
1518             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1519                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1520             }
1521     }
1522 
1523     /**
1524      * @dev Hook that is called before a set of serially-ordered token IDs
1525      * are about to be transferred. This includes minting.
1526      * And also called before burning one token.
1527      *
1528      * `startTokenId` - the first token ID to be transferred.
1529      * `quantity` - the amount to be transferred.
1530      *
1531      * Calling conditions:
1532      *
1533      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1534      * transferred to `to`.
1535      * - When `from` is zero, `tokenId` will be minted for `to`.
1536      * - When `to` is zero, `tokenId` will be burned by `from`.
1537      * - `from` and `to` are never both zero.
1538      */
1539     function _beforeTokenTransfers(
1540         address from,
1541         address to,
1542         uint256 startTokenId,
1543         uint256 quantity
1544     ) internal virtual {}
1545 
1546     /**
1547      * @dev Hook that is called after a set of serially-ordered token IDs
1548      * have been transferred. This includes minting.
1549      * And also called after one token has been burned.
1550      *
1551      * `startTokenId` - the first token ID to be transferred.
1552      * `quantity` - the amount to be transferred.
1553      *
1554      * Calling conditions:
1555      *
1556      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1557      * transferred to `to`.
1558      * - When `from` is zero, `tokenId` has been minted for `to`.
1559      * - When `to` is zero, `tokenId` has been burned by `from`.
1560      * - `from` and `to` are never both zero.
1561      */
1562     function _afterTokenTransfers(
1563         address from,
1564         address to,
1565         uint256 startTokenId,
1566         uint256 quantity
1567     ) internal virtual {}
1568 
1569     /**
1570      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1571      *
1572      * `from` - Previous owner of the given token ID.
1573      * `to` - Target address that will receive the token.
1574      * `tokenId` - Token ID to be transferred.
1575      * `_data` - Optional data to send along with the call.
1576      *
1577      * Returns whether the call correctly returned the expected magic value.
1578      */
1579     function _checkContractOnERC721Received(
1580         address from,
1581         address to,
1582         uint256 tokenId,
1583         bytes memory _data
1584     ) private returns (bool) {
1585         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1586             bytes4 retval
1587         ) {
1588             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1589         } catch (bytes memory reason) {
1590             if (reason.length == 0) {
1591                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1592             }
1593             assembly {
1594                 revert(add(32, reason), mload(reason))
1595             }
1596         }
1597     }
1598 
1599     // =============================================================
1600     //                        MINT OPERATIONS
1601     // =============================================================
1602 
1603     /**
1604      * @dev Mints `quantity` tokens and transfers them to `to`.
1605      *
1606      * Requirements:
1607      *
1608      * - `to` cannot be the zero address.
1609      * - `quantity` must be greater than 0.
1610      *
1611      * Emits a {Transfer} event for each mint.
1612      */
1613     function _mint(address to, uint256 quantity) internal virtual {
1614         uint256 startTokenId = _currentIndex;
1615         if (quantity == 0) _revert(MintZeroQuantity.selector);
1616 
1617         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1618 
1619         // Overflows are incredibly unrealistic.
1620         // `balance` and `numberMinted` have a maximum limit of 2**64.
1621         // `tokenId` has a maximum limit of 2**256.
1622         unchecked {
1623             // Updates:
1624             // - `address` to the owner.
1625             // - `startTimestamp` to the timestamp of minting.
1626             // - `burned` to `false`.
1627             // - `nextInitialized` to `quantity == 1`.
1628             _packedOwnerships[startTokenId] = _packOwnershipData(
1629                 to,
1630                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1631             );
1632 
1633             // Updates:
1634             // - `balance += quantity`.
1635             // - `numberMinted += quantity`.
1636             //
1637             // We can directly add to the `balance` and `numberMinted`.
1638             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1639 
1640             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1641             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1642 
1643             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1644 
1645             uint256 end = startTokenId + quantity;
1646             uint256 tokenId = startTokenId;
1647 
1648             do {
1649                 assembly {
1650                     // Emit the `Transfer` event.
1651                     log4(
1652                         0, // Start of data (0, since no data).
1653                         0, // End of data (0, since no data).
1654                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1655                         0, // `address(0)`.
1656                         toMasked, // `to`.
1657                         tokenId // `tokenId`.
1658                     )
1659                 }
1660                 // The `!=` check ensures that large values of `quantity`
1661                 // that overflows uint256 will make the loop run out of gas.
1662             } while (++tokenId != end);
1663 
1664             _currentIndex = end;
1665         }
1666         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1667     }
1668 
1669     /**
1670      * @dev Mints `quantity` tokens and transfers them to `to`.
1671      *
1672      * This function is intended for efficient minting only during contract creation.
1673      *
1674      * It emits only one {ConsecutiveTransfer} as defined in
1675      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1676      * instead of a sequence of {Transfer} event(s).
1677      *
1678      * Calling this function outside of contract creation WILL make your contract
1679      * non-compliant with the ERC721 standard.
1680      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1681      * {ConsecutiveTransfer} event is only permissible during contract creation.
1682      *
1683      * Requirements:
1684      *
1685      * - `to` cannot be the zero address.
1686      * - `quantity` must be greater than 0.
1687      *
1688      * Emits a {ConsecutiveTransfer} event.
1689      */
1690     function _mintERC2309(address to, uint256 quantity) internal virtual {
1691         uint256 startTokenId = _currentIndex;
1692         if (to == address(0)) _revert(MintToZeroAddress.selector);
1693         if (quantity == 0) _revert(MintZeroQuantity.selector);
1694         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
1695 
1696         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1697 
1698         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1699         unchecked {
1700             // Updates:
1701             // - `balance += quantity`.
1702             // - `numberMinted += quantity`.
1703             //
1704             // We can directly add to the `balance` and `numberMinted`.
1705             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1706 
1707             // Updates:
1708             // - `address` to the owner.
1709             // - `startTimestamp` to the timestamp of minting.
1710             // - `burned` to `false`.
1711             // - `nextInitialized` to `quantity == 1`.
1712             _packedOwnerships[startTokenId] = _packOwnershipData(
1713                 to,
1714                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1715             );
1716 
1717             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1718 
1719             _currentIndex = startTokenId + quantity;
1720         }
1721         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1722     }
1723 
1724     /**
1725      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1726      *
1727      * Requirements:
1728      *
1729      * - If `to` refers to a smart contract, it must implement
1730      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1731      * - `quantity` must be greater than 0.
1732      *
1733      * See {_mint}.
1734      *
1735      * Emits a {Transfer} event for each mint.
1736      */
1737     function _safeMint(
1738         address to,
1739         uint256 quantity,
1740         bytes memory _data
1741     ) internal virtual {
1742         _mint(to, quantity);
1743 
1744         unchecked {
1745             if (to.code.length != 0) {
1746                 uint256 end = _currentIndex;
1747                 uint256 index = end - quantity;
1748                 do {
1749                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1750                         _revert(TransferToNonERC721ReceiverImplementer.selector);
1751                     }
1752                 } while (index < end);
1753                 // Reentrancy protection.
1754                 if (_currentIndex != end) _revert(bytes4(0));
1755             }
1756         }
1757     }
1758 
1759     /**
1760      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1761      */
1762     function _safeMint(address to, uint256 quantity) internal virtual {
1763         _safeMint(to, quantity, '');
1764     }
1765 
1766     // =============================================================
1767     //                       APPROVAL OPERATIONS
1768     // =============================================================
1769 
1770     /**
1771      * @dev Equivalent to `_approve(to, tokenId, false)`.
1772      */
1773     function _approve(address to, uint256 tokenId) internal virtual {
1774         _approve(to, tokenId, false);
1775     }
1776 
1777     /**
1778      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1779      * The approval is cleared when the token is transferred.
1780      *
1781      * Only a single account can be approved at a time, so approving the
1782      * zero address clears previous approvals.
1783      *
1784      * Requirements:
1785      *
1786      * - `tokenId` must exist.
1787      *
1788      * Emits an {Approval} event.
1789      */
1790     function _approve(
1791         address to,
1792         uint256 tokenId,
1793         bool approvalCheck
1794     ) internal virtual {
1795         address owner = ownerOf(tokenId);
1796 
1797         if (approvalCheck && _msgSenderERC721A() != owner)
1798             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1799                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
1800             }
1801 
1802         _tokenApprovals[tokenId].value = to;
1803         emit Approval(owner, to, tokenId);
1804     }
1805 
1806     // =============================================================
1807     //                        BURN OPERATIONS
1808     // =============================================================
1809 
1810     /**
1811      * @dev Equivalent to `_burn(tokenId, false)`.
1812      */
1813     function _burn(uint256 tokenId) internal virtual {
1814         _burn(tokenId, false);
1815     }
1816 
1817     /**
1818      * @dev Destroys `tokenId`.
1819      * The approval is cleared when the token is burned.
1820      *
1821      * Requirements:
1822      *
1823      * - `tokenId` must exist.
1824      *
1825      * Emits a {Transfer} event.
1826      */
1827     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1828         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1829 
1830         address from = address(uint160(prevOwnershipPacked));
1831 
1832         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1833 
1834         if (approvalCheck) {
1835             // The nested ifs save around 20+ gas over a compound boolean condition.
1836             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1837                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1838         }
1839 
1840         _beforeTokenTransfers(from, address(0), tokenId, 1);
1841 
1842         // Clear approvals from the previous owner.
1843         assembly {
1844             if approvedAddress {
1845                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1846                 sstore(approvedAddressSlot, 0)
1847             }
1848         }
1849 
1850         // Underflow of the sender's balance is impossible because we check for
1851         // ownership above and the recipient's balance can't realistically overflow.
1852         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1853         unchecked {
1854             // Updates:
1855             // - `balance -= 1`.
1856             // - `numberBurned += 1`.
1857             //
1858             // We can directly decrement the balance, and increment the number burned.
1859             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1860             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1861 
1862             // Updates:
1863             // - `address` to the last owner.
1864             // - `startTimestamp` to the timestamp of burning.
1865             // - `burned` to `true`.
1866             // - `nextInitialized` to `true`.
1867             _packedOwnerships[tokenId] = _packOwnershipData(
1868                 from,
1869                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1870             );
1871 
1872             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1873             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1874                 uint256 nextTokenId = tokenId + 1;
1875                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1876                 if (_packedOwnerships[nextTokenId] == 0) {
1877                     // If the next slot is within bounds.
1878                     if (nextTokenId != _currentIndex) {
1879                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1880                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1881                     }
1882                 }
1883             }
1884         }
1885 
1886         emit Transfer(from, address(0), tokenId);
1887         _afterTokenTransfers(from, address(0), tokenId, 1);
1888 
1889         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1890         unchecked {
1891             _burnCounter++;
1892         }
1893     }
1894 
1895     // =============================================================
1896     //                     EXTRA DATA OPERATIONS
1897     // =============================================================
1898 
1899     /**
1900      * @dev Directly sets the extra data for the ownership data `index`.
1901      */
1902     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1903         uint256 packed = _packedOwnerships[index];
1904         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
1905         uint256 extraDataCasted;
1906         // Cast `extraData` with assembly to avoid redundant masking.
1907         assembly {
1908             extraDataCasted := extraData
1909         }
1910         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1911         _packedOwnerships[index] = packed;
1912     }
1913 
1914     /**
1915      * @dev Called during each token transfer to set the 24bit `extraData` field.
1916      * Intended to be overridden by the cosumer contract.
1917      *
1918      * `previousExtraData` - the value of `extraData` before transfer.
1919      *
1920      * Calling conditions:
1921      *
1922      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1923      * transferred to `to`.
1924      * - When `from` is zero, `tokenId` will be minted for `to`.
1925      * - When `to` is zero, `tokenId` will be burned by `from`.
1926      * - `from` and `to` are never both zero.
1927      */
1928     function _extraData(
1929         address from,
1930         address to,
1931         uint24 previousExtraData
1932     ) internal view virtual returns (uint24) {}
1933 
1934     /**
1935      * @dev Returns the next extra data for the packed ownership data.
1936      * The returned result is shifted into position.
1937      */
1938     function _nextExtraData(
1939         address from,
1940         address to,
1941         uint256 prevOwnershipPacked
1942     ) private view returns (uint256) {
1943         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1944         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1945     }
1946 
1947     // =============================================================
1948     //                       OTHER OPERATIONS
1949     // =============================================================
1950 
1951     /**
1952      * @dev Returns the message sender (defaults to `msg.sender`).
1953      *
1954      * If you are writing GSN compatible contracts, you need to override this function.
1955      */
1956     function _msgSenderERC721A() internal view virtual returns (address) {
1957         return msg.sender;
1958     }
1959 
1960     /**
1961      * @dev Converts a uint256 to its ASCII string decimal representation.
1962      */
1963     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1964         assembly {
1965             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1966             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1967             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1968             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1969             let m := add(mload(0x40), 0xa0)
1970             // Update the free memory pointer to allocate.
1971             mstore(0x40, m)
1972             // Assign the `str` to the end.
1973             str := sub(m, 0x20)
1974             // Zeroize the slot after the string.
1975             mstore(str, 0)
1976 
1977             // Cache the end of the memory to calculate the length later.
1978             let end := str
1979 
1980             // We write the string from rightmost digit to leftmost digit.
1981             // The following is essentially a do-while loop that also handles the zero case.
1982             // prettier-ignore
1983             for { let temp := value } 1 {} {
1984                 str := sub(str, 1)
1985                 // Write the character to the pointer.
1986                 // The ASCII index of the '0' character is 48.
1987                 mstore8(str, add(48, mod(temp, 10)))
1988                 // Keep dividing `temp` until zero.
1989                 temp := div(temp, 10)
1990                 // prettier-ignore
1991                 if iszero(temp) { break }
1992             }
1993 
1994             let length := sub(end, str)
1995             // Move the pointer 32 bytes leftwards to make room for the length.
1996             str := sub(str, 0x20)
1997             // Store the length.
1998             mstore(str, length)
1999         }
2000     }
2001 
2002     /**
2003      * @dev For more efficient reverts.
2004      */
2005     function _revert(bytes4 errorSelector) internal pure {
2006         assembly {
2007             mstore(0x00, errorSelector)
2008             revert(0x00, 0x04)
2009         }
2010     }
2011 }
2012 
2013 // File: contracts/EmoGrunks.sol
2014 
2015 
2016 
2017 
2018 
2019 
2020 
2021 pragma solidity ^0.8.18;
2022 
2023 contract EmoGrunks is ERC721A, Ownable, DefaultOperatorFilterer {
2024     using SafeMath for uint256;
2025     uint256 public maxPerTransaction = 20;
2026     uint256 public supplyLimit = 10131;
2027     bool public publicSaleActive = false;
2028     string public baseURI;
2029 
2030     constructor(
2031         string memory name,
2032         string memory symbol,
2033         string memory baseURIinput
2034     ) ERC721A(name, symbol) {
2035         baseURI = baseURIinput;
2036     }
2037 
2038     function _baseURI() internal view override returns (string memory) {
2039         return baseURI;
2040     }
2041 
2042     function setBaseURI(string calldata newBaseUri) external onlyOwner {
2043         baseURI = newBaseUri;
2044     }
2045 
2046     function togglePublicSaleActive() external onlyOwner {
2047         publicSaleActive = !publicSaleActive;
2048     }
2049 
2050     function mint(uint256 _quantity) external {
2051         require(
2052             _quantity <= maxPerTransaction,
2053             "Over max per transaction! Limit is 20 per transaction."
2054         );
2055         require(publicSaleActive == true, "Not Yet Active.");
2056         require((totalSupply() + _quantity) <= supplyLimit, "Supply reached");
2057         _safeMint(msg.sender, _quantity);
2058     }
2059 
2060     function withdraw() public onlyOwner {
2061         uint256 balance = address(this).balance;
2062         payable(msg.sender).transfer(balance);
2063     }
2064 
2065     function transferFrom(
2066         address from,
2067         address to,
2068         uint256 tokenId
2069     ) public payable override(ERC721A) onlyAllowedOperator(from) {
2070         super.transferFrom(from, to, tokenId);
2071     }
2072 
2073     function safeTransferFrom(
2074         address from,
2075         address to,
2076         uint256 tokenId
2077     ) public payable override(ERC721A) onlyAllowedOperator(from) {
2078         super.safeTransferFrom(from, to, tokenId);
2079     }
2080 
2081     function safeTransferFrom(
2082         address from,
2083         address to,
2084         uint256 tokenId,
2085         bytes memory data
2086     ) public payable override(ERC721A) onlyAllowedOperator(from) {
2087         super.safeTransferFrom(from, to, tokenId, data);
2088     }
2089 }