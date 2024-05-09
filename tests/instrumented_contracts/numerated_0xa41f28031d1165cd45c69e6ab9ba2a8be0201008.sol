1 //            _____                    _____                    _____                _____          
2 //           /\    \                  /\    \                  /\    \              |\    \         
3 //          /::\    \                /::\____\                /::\    \             |:\____\        
4 //         /::::\    \              /:::/    /               /::::\    \            |::|   |        
5 //        /::::::\    \            /:::/    /               /::::::\    \           |::|   |        
6 //       /:::/\:::\    \          /:::/    /               /:::/\:::\    \          |::|   |        
7 //      /:::/  \:::\    \        /:::/____/               /:::/__\:::\    \         |::|   |        
8 //     /:::/    \:::\    \      /::::\    \              /::::\   \:::\    \        |::|   |        
9 //    /:::/    / \:::\    \    /::::::\    \   _____    /::::::\   \:::\    \       |::|___|______  
10 //   /:::/    /   \:::\    \  /:::/\:::\    \ /\    \  /:::/\:::\   \:::\____\      /::::::::\    \ 
11 //  /:::/____/     \:::\____\/:::/  \:::\    /::\____\/:::/  \:::\   \:::|    |    /::::::::::\____\
12 //  \:::\    \      \::/    /\::/    \:::\  /:::/    /\::/   |::::\  /:::|____|   /:::/~~~~/~~      
13 //   \:::\    \      \/____/  \/____/ \:::\/:::/    /  \/____|:::::\/:::/    /   /:::/    /         
14 //    \:::\    \                       \::::::/    /         |:::::::::/    /   /:::/    /          
15 //     \:::\    \                       \::::/    /          |::|\::::/    /   /:::/    /           
16 //      \:::\    \                      /:::/    /           |::| \::/____/    \::/    /            
17 //       \:::\    \                    /:::/    /            |::|  ~|           \/____/             
18 //        \:::\    \                  /:::/    /             |::|   |                               
19 //         \:::\____\                /:::/    /              \::|   |                               
20 //          \::/    /                \::/    /                \:|   |                               
21 //           \/____/                  \/____/                  \|___|                               
22 //                                                                                   
23 
24 
25 
26 
27 
28 // File: operator-filter-registry/src/lib/Constants.sol
29 
30 
31 pragma solidity ^0.8.17;
32 
33 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
34 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
35 
36 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
37 
38 
39 pragma solidity ^0.8.13;
40 
41 interface IOperatorFilterRegistry {
42     /**
43      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
44      *         true if supplied registrant address is not registered.
45      */
46     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
47 
48     /**
49      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
50      */
51     function register(address registrant) external;
52 
53     /**
54      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
55      */
56     function registerAndSubscribe(address registrant, address subscription) external;
57 
58     /**
59      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
60      *         address without subscribing.
61      */
62     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
63 
64     /**
65      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
66      *         Note that this does not remove any filtered addresses or codeHashes.
67      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
68      */
69     function unregister(address addr) external;
70 
71     /**
72      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
73      */
74     function updateOperator(address registrant, address operator, bool filtered) external;
75 
76     /**
77      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
78      */
79     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
80 
81     /**
82      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
83      */
84     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
85 
86     /**
87      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
88      */
89     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
90 
91     /**
92      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
93      *         subscription if present.
94      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
95      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
96      *         used.
97      */
98     function subscribe(address registrant, address registrantToSubscribe) external;
99 
100     /**
101      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
102      */
103     function unsubscribe(address registrant, bool copyExistingEntries) external;
104 
105     /**
106      * @notice Get the subscription address of a given registrant, if any.
107      */
108     function subscriptionOf(address addr) external returns (address registrant);
109 
110     /**
111      * @notice Get the set of addresses subscribed to a given registrant.
112      *         Note that order is not guaranteed as updates are made.
113      */
114     function subscribers(address registrant) external returns (address[] memory);
115 
116     /**
117      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
118      *         Note that order is not guaranteed as updates are made.
119      */
120     function subscriberAt(address registrant, uint256 index) external returns (address);
121 
122     /**
123      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
124      */
125     function copyEntriesOf(address registrant, address registrantToCopy) external;
126 
127     /**
128      * @notice Returns true if operator is filtered by a given address or its subscription.
129      */
130     function isOperatorFiltered(address registrant, address operator) external returns (bool);
131 
132     /**
133      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
134      */
135     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
136 
137     /**
138      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
139      */
140     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
141 
142     /**
143      * @notice Returns a list of filtered operators for a given address or its subscription.
144      */
145     function filteredOperators(address addr) external returns (address[] memory);
146 
147     /**
148      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
149      *         Note that order is not guaranteed as updates are made.
150      */
151     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
152 
153     /**
154      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
155      *         its subscription.
156      *         Note that order is not guaranteed as updates are made.
157      */
158     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
159 
160     /**
161      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
162      *         its subscription.
163      *         Note that order is not guaranteed as updates are made.
164      */
165     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
166 
167     /**
168      * @notice Returns true if an address has registered
169      */
170     function isRegistered(address addr) external returns (bool);
171 
172     /**
173      * @dev Convenience method to compute the code hash of an arbitrary contract
174      */
175     function codeHashOf(address addr) external returns (bytes32);
176 }
177 
178 // File: operator-filter-registry/src/OperatorFilterer.sol
179 
180 
181 pragma solidity ^0.8.13;
182 
183 
184 /**
185  * @title  OperatorFilterer
186  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
187  *         registrant's entries in the OperatorFilterRegistry.
188  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
189  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
190  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
191  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
192  *         administration methods on the contract itself to interact with the registry otherwise the subscription
193  *         will be locked to the options set during construction.
194  */
195 
196 abstract contract OperatorFilterer {
197     /// @dev Emitted when an operator is not allowed.
198     error OperatorNotAllowed(address operator);
199 
200     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
201         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
202 
203     /// @dev The constructor that is called when the contract is being deployed.
204     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
205         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
206         // will not revert, but the contract will need to be registered with the registry once it is deployed in
207         // order for the modifier to filter addresses.
208         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
209             if (subscribe) {
210                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
211             } else {
212                 if (subscriptionOrRegistrantToCopy != address(0)) {
213                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
214                 } else {
215                     OPERATOR_FILTER_REGISTRY.register(address(this));
216                 }
217             }
218         }
219     }
220 
221     /**
222      * @dev A helper function to check if an operator is allowed.
223      */
224     modifier onlyAllowedOperator(address from) virtual {
225         // Allow spending tokens from addresses with balance
226         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
227         // from an EOA.
228         if (from != msg.sender) {
229             _checkFilterOperator(msg.sender);
230         }
231         _;
232     }
233 
234     /**
235      * @dev A helper function to check if an operator approval is allowed.
236      */
237     modifier onlyAllowedOperatorApproval(address operator) virtual {
238         _checkFilterOperator(operator);
239         _;
240     }
241 
242     /**
243      * @dev A helper function to check if an operator is allowed.
244      */
245     function _checkFilterOperator(address operator) internal view virtual {
246         // Check registry code length to facilitate testing in environments without a deployed registry.
247         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
248             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
249             // may specify their own OperatorFilterRegistry implementations, which may behave differently
250             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
251                 revert OperatorNotAllowed(operator);
252             }
253         }
254     }
255 }
256 
257 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
258 
259 
260 pragma solidity ^0.8.13;
261 
262 
263 /**
264  * @title  DefaultOperatorFilterer
265  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
266  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
267  *         administration methods on the contract itself to interact with the registry otherwise the subscription
268  *         will be locked to the options set during construction.
269  */
270 
271 abstract contract DefaultOperatorFilterer is OperatorFilterer {
272     /// @dev The constructor that is called when the contract is being deployed.
273     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
274 }
275 
276 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
277 
278 
279 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 // CAUTION
284 // This version of SafeMath should only be used with Solidity 0.8 or later,
285 // because it relies on the compiler's built in overflow checks.
286 
287 /**
288  * @dev Wrappers over Solidity's arithmetic operations.
289  *
290  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
291  * now has built in overflow checking.
292  */
293 library SafeMath {
294     /**
295      * @dev Returns the addition of two unsigned integers, with an overflow flag.
296      *
297      * _Available since v3.4._
298      */
299     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
300         unchecked {
301             uint256 c = a + b;
302             if (c < a) return (false, 0);
303             return (true, c);
304         }
305     }
306 
307     /**
308      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
309      *
310      * _Available since v3.4._
311      */
312     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
313         unchecked {
314             if (b > a) return (false, 0);
315             return (true, a - b);
316         }
317     }
318 
319     /**
320      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
321      *
322      * _Available since v3.4._
323      */
324     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
325         unchecked {
326             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
327             // benefit is lost if 'b' is also tested.
328             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
329             if (a == 0) return (true, 0);
330             uint256 c = a * b;
331             if (c / a != b) return (false, 0);
332             return (true, c);
333         }
334     }
335 
336     /**
337      * @dev Returns the division of two unsigned integers, with a division by zero flag.
338      *
339      * _Available since v3.4._
340      */
341     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
342         unchecked {
343             if (b == 0) return (false, 0);
344             return (true, a / b);
345         }
346     }
347 
348     /**
349      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
350      *
351      * _Available since v3.4._
352      */
353     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
354         unchecked {
355             if (b == 0) return (false, 0);
356             return (true, a % b);
357         }
358     }
359 
360     /**
361      * @dev Returns the addition of two unsigned integers, reverting on
362      * overflow.
363      *
364      * Counterpart to Solidity's `+` operator.
365      *
366      * Requirements:
367      *
368      * - Addition cannot overflow.
369      */
370     function add(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a + b;
372     }
373 
374     /**
375      * @dev Returns the subtraction of two unsigned integers, reverting on
376      * overflow (when the result is negative).
377      *
378      * Counterpart to Solidity's `-` operator.
379      *
380      * Requirements:
381      *
382      * - Subtraction cannot overflow.
383      */
384     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
385         return a - b;
386     }
387 
388     /**
389      * @dev Returns the multiplication of two unsigned integers, reverting on
390      * overflow.
391      *
392      * Counterpart to Solidity's `*` operator.
393      *
394      * Requirements:
395      *
396      * - Multiplication cannot overflow.
397      */
398     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
399         return a * b;
400     }
401 
402     /**
403      * @dev Returns the integer division of two unsigned integers, reverting on
404      * division by zero. The result is rounded towards zero.
405      *
406      * Counterpart to Solidity's `/` operator.
407      *
408      * Requirements:
409      *
410      * - The divisor cannot be zero.
411      */
412     function div(uint256 a, uint256 b) internal pure returns (uint256) {
413         return a / b;
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
418      * reverting when dividing by zero.
419      *
420      * Counterpart to Solidity's `%` operator. This function uses a `revert`
421      * opcode (which leaves remaining gas untouched) while Solidity uses an
422      * invalid opcode to revert (consuming all remaining gas).
423      *
424      * Requirements:
425      *
426      * - The divisor cannot be zero.
427      */
428     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
429         return a % b;
430     }
431 
432     /**
433      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
434      * overflow (when the result is negative).
435      *
436      * CAUTION: This function is deprecated because it requires allocating memory for the error
437      * message unnecessarily. For custom revert reasons use {trySub}.
438      *
439      * Counterpart to Solidity's `-` operator.
440      *
441      * Requirements:
442      *
443      * - Subtraction cannot overflow.
444      */
445     function sub(
446         uint256 a,
447         uint256 b,
448         string memory errorMessage
449     ) internal pure returns (uint256) {
450         unchecked {
451             require(b <= a, errorMessage);
452             return a - b;
453         }
454     }
455 
456     /**
457      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
458      * division by zero. The result is rounded towards zero.
459      *
460      * Counterpart to Solidity's `/` operator. Note: this function uses a
461      * `revert` opcode (which leaves remaining gas untouched) while Solidity
462      * uses an invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      *
466      * - The divisor cannot be zero.
467      */
468     function div(
469         uint256 a,
470         uint256 b,
471         string memory errorMessage
472     ) internal pure returns (uint256) {
473         unchecked {
474             require(b > 0, errorMessage);
475             return a / b;
476         }
477     }
478 
479     /**
480      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
481      * reverting with custom message when dividing by zero.
482      *
483      * CAUTION: This function is deprecated because it requires allocating memory for the error
484      * message unnecessarily. For custom revert reasons use {tryMod}.
485      *
486      * Counterpart to Solidity's `%` operator. This function uses a `revert`
487      * opcode (which leaves remaining gas untouched) while Solidity uses an
488      * invalid opcode to revert (consuming all remaining gas).
489      *
490      * Requirements:
491      *
492      * - The divisor cannot be zero.
493      */
494     function mod(
495         uint256 a,
496         uint256 b,
497         string memory errorMessage
498     ) internal pure returns (uint256) {
499         unchecked {
500             require(b > 0, errorMessage);
501             return a % b;
502         }
503     }
504 }
505 
506 // File: @openzeppelin/contracts/utils/Counters.sol
507 
508 
509 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @title Counters
515  * @author Matt Condon (@shrugs)
516  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
517  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
518  *
519  * Include with `using Counters for Counters.Counter;`
520  */
521 library Counters {
522     struct Counter {
523         // This variable should never be directly accessed by users of the library: interactions must be restricted to
524         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
525         // this feature: see https://github.com/ethereum/solidity/issues/4637
526         uint256 _value; // default: 0
527     }
528 
529     function current(Counter storage counter) internal view returns (uint256) {
530         return counter._value;
531     }
532 
533     function increment(Counter storage counter) internal {
534         unchecked {
535             counter._value += 1;
536         }
537     }
538 
539     function decrement(Counter storage counter) internal {
540         uint256 value = counter._value;
541         require(value > 0, "Counter: decrement overflow");
542         unchecked {
543             counter._value = value - 1;
544         }
545     }
546 
547     function reset(Counter storage counter) internal {
548         counter._value = 0;
549     }
550 }
551 
552 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
553 
554 
555 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev Contract module that helps prevent reentrant calls to a function.
561  *
562  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
563  * available, which can be applied to functions to make sure there are no nested
564  * (reentrant) calls to them.
565  *
566  * Note that because there is a single `nonReentrant` guard, functions marked as
567  * `nonReentrant` may not call one another. This can be worked around by making
568  * those functions `private`, and then adding `external` `nonReentrant` entry
569  * points to them.
570  *
571  * TIP: If you would like to learn more about reentrancy and alternative ways
572  * to protect against it, check out our blog post
573  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
574  */
575 abstract contract ReentrancyGuard {
576     // Booleans are more expensive than uint256 or any type that takes up a full
577     // word because each write operation emits an extra SLOAD to first read the
578     // slot's contents, replace the bits taken up by the boolean, and then write
579     // back. This is the compiler's defense against contract upgrades and
580     // pointer aliasing, and it cannot be disabled.
581 
582     // The values being non-zero value makes deployment a bit more expensive,
583     // but in exchange the refund on every call to nonReentrant will be lower in
584     // amount. Since refunds are capped to a percentage of the total
585     // transaction's gas, it is best to keep them low in cases like this one, to
586     // increase the likelihood of the full refund coming into effect.
587     uint256 private constant _NOT_ENTERED = 1;
588     uint256 private constant _ENTERED = 2;
589 
590     uint256 private _status;
591 
592     constructor() {
593         _status = _NOT_ENTERED;
594     }
595 
596     /**
597      * @dev Prevents a contract from calling itself, directly or indirectly.
598      * Calling a `nonReentrant` function from another `nonReentrant`
599      * function is not supported. It is possible to prevent this from happening
600      * by making the `nonReentrant` function external, and making it call a
601      * `private` function that does the actual work.
602      */
603     modifier nonReentrant() {
604         _nonReentrantBefore();
605         _;
606         _nonReentrantAfter();
607     }
608 
609     function _nonReentrantBefore() private {
610         // On the first call to nonReentrant, _status will be _NOT_ENTERED
611         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
612 
613         // Any calls to nonReentrant after this point will fail
614         _status = _ENTERED;
615     }
616 
617     function _nonReentrantAfter() private {
618         // By storing the original value once again, a refund is triggered (see
619         // https://eips.ethereum.org/EIPS/eip-2200)
620         _status = _NOT_ENTERED;
621     }
622 }
623 
624 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
625 
626 
627 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 /**
632  * @dev Interface of the ERC20 standard as defined in the EIP.
633  */
634 interface IERC20 {
635     /**
636      * @dev Emitted when `value` tokens are moved from one account (`from`) to
637      * another (`to`).
638      *
639      * Note that `value` may be zero.
640      */
641     event Transfer(address indexed from, address indexed to, uint256 value);
642 
643     /**
644      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
645      * a call to {approve}. `value` is the new allowance.
646      */
647     event Approval(address indexed owner, address indexed spender, uint256 value);
648 
649     /**
650      * @dev Returns the amount of tokens in existence.
651      */
652     function totalSupply() external view returns (uint256);
653 
654     /**
655      * @dev Returns the amount of tokens owned by `account`.
656      */
657     function balanceOf(address account) external view returns (uint256);
658 
659     /**
660      * @dev Moves `amount` tokens from the caller's account to `to`.
661      *
662      * Returns a boolean value indicating whether the operation succeeded.
663      *
664      * Emits a {Transfer} event.
665      */
666     function transfer(address to, uint256 amount) external returns (bool);
667 
668     /**
669      * @dev Returns the remaining number of tokens that `spender` will be
670      * allowed to spend on behalf of `owner` through {transferFrom}. This is
671      * zero by default.
672      *
673      * This value changes when {approve} or {transferFrom} are called.
674      */
675     function allowance(address owner, address spender) external view returns (uint256);
676 
677     /**
678      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
679      *
680      * Returns a boolean value indicating whether the operation succeeded.
681      *
682      * IMPORTANT: Beware that changing an allowance with this method brings the risk
683      * that someone may use both the old and the new allowance by unfortunate
684      * transaction ordering. One possible solution to mitigate this race
685      * condition is to first reduce the spender's allowance to 0 and set the
686      * desired value afterwards:
687      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
688      *
689      * Emits an {Approval} event.
690      */
691     function approve(address spender, uint256 amount) external returns (bool);
692 
693     /**
694      * @dev Moves `amount` tokens from `from` to `to` using the
695      * allowance mechanism. `amount` is then deducted from the caller's
696      * allowance.
697      *
698      * Returns a boolean value indicating whether the operation succeeded.
699      *
700      * Emits a {Transfer} event.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 amount
706     ) external returns (bool);
707 }
708 
709 // File: @openzeppelin/contracts/interfaces/IERC20.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 // File: @openzeppelin/contracts/utils/math/Math.sol
718 
719 
720 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 /**
725  * @dev Standard math utilities missing in the Solidity language.
726  */
727 library Math {
728     enum Rounding {
729         Down, // Toward negative infinity
730         Up, // Toward infinity
731         Zero // Toward zero
732     }
733 
734     /**
735      * @dev Returns the largest of two numbers.
736      */
737     function max(uint256 a, uint256 b) internal pure returns (uint256) {
738         return a > b ? a : b;
739     }
740 
741     /**
742      * @dev Returns the smallest of two numbers.
743      */
744     function min(uint256 a, uint256 b) internal pure returns (uint256) {
745         return a < b ? a : b;
746     }
747 
748     /**
749      * @dev Returns the average of two numbers. The result is rounded towards
750      * zero.
751      */
752     function average(uint256 a, uint256 b) internal pure returns (uint256) {
753         // (a + b) / 2 can overflow.
754         return (a & b) + (a ^ b) / 2;
755     }
756 
757     /**
758      * @dev Returns the ceiling of the division of two numbers.
759      *
760      * This differs from standard division with `/` in that it rounds up instead
761      * of rounding down.
762      */
763     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
764         // (a + b - 1) / b can overflow on addition, so we distribute.
765         return a == 0 ? 0 : (a - 1) / b + 1;
766     }
767 
768     /**
769      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
770      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
771      * with further edits by Uniswap Labs also under MIT license.
772      */
773     function mulDiv(
774         uint256 x,
775         uint256 y,
776         uint256 denominator
777     ) internal pure returns (uint256 result) {
778         unchecked {
779             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
780             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
781             // variables such that product = prod1 * 2^256 + prod0.
782             uint256 prod0; // Least significant 256 bits of the product
783             uint256 prod1; // Most significant 256 bits of the product
784             assembly {
785                 let mm := mulmod(x, y, not(0))
786                 prod0 := mul(x, y)
787                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
788             }
789 
790             // Handle non-overflow cases, 256 by 256 division.
791             if (prod1 == 0) {
792                 return prod0 / denominator;
793             }
794 
795             // Make sure the result is less than 2^256. Also prevents denominator == 0.
796             require(denominator > prod1);
797 
798             ///////////////////////////////////////////////
799             // 512 by 256 division.
800             ///////////////////////////////////////////////
801 
802             // Make division exact by subtracting the remainder from [prod1 prod0].
803             uint256 remainder;
804             assembly {
805                 // Compute remainder using mulmod.
806                 remainder := mulmod(x, y, denominator)
807 
808                 // Subtract 256 bit number from 512 bit number.
809                 prod1 := sub(prod1, gt(remainder, prod0))
810                 prod0 := sub(prod0, remainder)
811             }
812 
813             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
814             // See https://cs.stackexchange.com/q/138556/92363.
815 
816             // Does not overflow because the denominator cannot be zero at this stage in the function.
817             uint256 twos = denominator & (~denominator + 1);
818             assembly {
819                 // Divide denominator by twos.
820                 denominator := div(denominator, twos)
821 
822                 // Divide [prod1 prod0] by twos.
823                 prod0 := div(prod0, twos)
824 
825                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
826                 twos := add(div(sub(0, twos), twos), 1)
827             }
828 
829             // Shift in bits from prod1 into prod0.
830             prod0 |= prod1 * twos;
831 
832             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
833             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
834             // four bits. That is, denominator * inv = 1 mod 2^4.
835             uint256 inverse = (3 * denominator) ^ 2;
836 
837             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
838             // in modular arithmetic, doubling the correct bits in each step.
839             inverse *= 2 - denominator * inverse; // inverse mod 2^8
840             inverse *= 2 - denominator * inverse; // inverse mod 2^16
841             inverse *= 2 - denominator * inverse; // inverse mod 2^32
842             inverse *= 2 - denominator * inverse; // inverse mod 2^64
843             inverse *= 2 - denominator * inverse; // inverse mod 2^128
844             inverse *= 2 - denominator * inverse; // inverse mod 2^256
845 
846             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
847             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
848             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
849             // is no longer required.
850             result = prod0 * inverse;
851             return result;
852         }
853     }
854 
855     /**
856      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
857      */
858     function mulDiv(
859         uint256 x,
860         uint256 y,
861         uint256 denominator,
862         Rounding rounding
863     ) internal pure returns (uint256) {
864         uint256 result = mulDiv(x, y, denominator);
865         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
866             result += 1;
867         }
868         return result;
869     }
870 
871     /**
872      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
873      *
874      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
875      */
876     function sqrt(uint256 a) internal pure returns (uint256) {
877         if (a == 0) {
878             return 0;
879         }
880 
881         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
882         //
883         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
884         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
885         //
886         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
887         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
888         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
889         //
890         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
891         uint256 result = 1 << (log2(a) >> 1);
892 
893         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
894         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
895         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
896         // into the expected uint128 result.
897         unchecked {
898             result = (result + a / result) >> 1;
899             result = (result + a / result) >> 1;
900             result = (result + a / result) >> 1;
901             result = (result + a / result) >> 1;
902             result = (result + a / result) >> 1;
903             result = (result + a / result) >> 1;
904             result = (result + a / result) >> 1;
905             return min(result, a / result);
906         }
907     }
908 
909     /**
910      * @notice Calculates sqrt(a), following the selected rounding direction.
911      */
912     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
913         unchecked {
914             uint256 result = sqrt(a);
915             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
916         }
917     }
918 
919     /**
920      * @dev Return the log in base 2, rounded down, of a positive value.
921      * Returns 0 if given 0.
922      */
923     function log2(uint256 value) internal pure returns (uint256) {
924         uint256 result = 0;
925         unchecked {
926             if (value >> 128 > 0) {
927                 value >>= 128;
928                 result += 128;
929             }
930             if (value >> 64 > 0) {
931                 value >>= 64;
932                 result += 64;
933             }
934             if (value >> 32 > 0) {
935                 value >>= 32;
936                 result += 32;
937             }
938             if (value >> 16 > 0) {
939                 value >>= 16;
940                 result += 16;
941             }
942             if (value >> 8 > 0) {
943                 value >>= 8;
944                 result += 8;
945             }
946             if (value >> 4 > 0) {
947                 value >>= 4;
948                 result += 4;
949             }
950             if (value >> 2 > 0) {
951                 value >>= 2;
952                 result += 2;
953             }
954             if (value >> 1 > 0) {
955                 result += 1;
956             }
957         }
958         return result;
959     }
960 
961     /**
962      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
963      * Returns 0 if given 0.
964      */
965     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
966         unchecked {
967             uint256 result = log2(value);
968             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
969         }
970     }
971 
972     /**
973      * @dev Return the log in base 10, rounded down, of a positive value.
974      * Returns 0 if given 0.
975      */
976     function log10(uint256 value) internal pure returns (uint256) {
977         uint256 result = 0;
978         unchecked {
979             if (value >= 10**64) {
980                 value /= 10**64;
981                 result += 64;
982             }
983             if (value >= 10**32) {
984                 value /= 10**32;
985                 result += 32;
986             }
987             if (value >= 10**16) {
988                 value /= 10**16;
989                 result += 16;
990             }
991             if (value >= 10**8) {
992                 value /= 10**8;
993                 result += 8;
994             }
995             if (value >= 10**4) {
996                 value /= 10**4;
997                 result += 4;
998             }
999             if (value >= 10**2) {
1000                 value /= 10**2;
1001                 result += 2;
1002             }
1003             if (value >= 10**1) {
1004                 result += 1;
1005             }
1006         }
1007         return result;
1008     }
1009 
1010     /**
1011      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1012      * Returns 0 if given 0.
1013      */
1014     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1015         unchecked {
1016             uint256 result = log10(value);
1017             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1018         }
1019     }
1020 
1021     /**
1022      * @dev Return the log in base 256, rounded down, of a positive value.
1023      * Returns 0 if given 0.
1024      *
1025      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1026      */
1027     function log256(uint256 value) internal pure returns (uint256) {
1028         uint256 result = 0;
1029         unchecked {
1030             if (value >> 128 > 0) {
1031                 value >>= 128;
1032                 result += 16;
1033             }
1034             if (value >> 64 > 0) {
1035                 value >>= 64;
1036                 result += 8;
1037             }
1038             if (value >> 32 > 0) {
1039                 value >>= 32;
1040                 result += 4;
1041             }
1042             if (value >> 16 > 0) {
1043                 value >>= 16;
1044                 result += 2;
1045             }
1046             if (value >> 8 > 0) {
1047                 result += 1;
1048             }
1049         }
1050         return result;
1051     }
1052 
1053     /**
1054      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1055      * Returns 0 if given 0.
1056      */
1057     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1058         unchecked {
1059             uint256 result = log256(value);
1060             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1061         }
1062     }
1063 }
1064 
1065 // File: @openzeppelin/contracts/utils/Strings.sol
1066 
1067 
1068 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 
1073 /**
1074  * @dev String operations.
1075  */
1076 library Strings {
1077     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1078     uint8 private constant _ADDRESS_LENGTH = 20;
1079 
1080     /**
1081      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1082      */
1083     function toString(uint256 value) internal pure returns (string memory) {
1084         unchecked {
1085             uint256 length = Math.log10(value) + 1;
1086             string memory buffer = new string(length);
1087             uint256 ptr;
1088             /// @solidity memory-safe-assembly
1089             assembly {
1090                 ptr := add(buffer, add(32, length))
1091             }
1092             while (true) {
1093                 ptr--;
1094                 /// @solidity memory-safe-assembly
1095                 assembly {
1096                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1097                 }
1098                 value /= 10;
1099                 if (value == 0) break;
1100             }
1101             return buffer;
1102         }
1103     }
1104 
1105     /**
1106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1107      */
1108     function toHexString(uint256 value) internal pure returns (string memory) {
1109         unchecked {
1110             return toHexString(value, Math.log256(value) + 1);
1111         }
1112     }
1113 
1114     /**
1115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1116      */
1117     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1118         bytes memory buffer = new bytes(2 * length + 2);
1119         buffer[0] = "0";
1120         buffer[1] = "x";
1121         for (uint256 i = 2 * length + 1; i > 1; --i) {
1122             buffer[i] = _SYMBOLS[value & 0xf];
1123             value >>= 4;
1124         }
1125         require(value == 0, "Strings: hex length insufficient");
1126         return string(buffer);
1127     }
1128 
1129     /**
1130      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1131      */
1132     function toHexString(address addr) internal pure returns (string memory) {
1133         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1134     }
1135 }
1136 
1137 // File: @openzeppelin/contracts/utils/Context.sol
1138 
1139 
1140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1141 
1142 pragma solidity ^0.8.0;
1143 
1144 /**
1145  * @dev Provides information about the current execution context, including the
1146  * sender of the transaction and its data. While these are generally available
1147  * via msg.sender and msg.data, they should not be accessed in such a direct
1148  * manner, since when dealing with meta-transactions the account sending and
1149  * paying for execution may not be the actual sender (as far as an application
1150  * is concerned).
1151  *
1152  * This contract is only required for intermediate, library-like contracts.
1153  */
1154 abstract contract Context {
1155     function _msgSender() internal view virtual returns (address) {
1156         return msg.sender;
1157     }
1158 
1159     function _msgData() internal view virtual returns (bytes calldata) {
1160         return msg.data;
1161     }
1162 }
1163 
1164 // File: @openzeppelin/contracts/access/Ownable.sol
1165 
1166 
1167 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 
1172 /**
1173  * @dev Contract module which provides a basic access control mechanism, where
1174  * there is an account (an owner) that can be granted exclusive access to
1175  * specific functions.
1176  *
1177  * By default, the owner account will be the one that deploys the contract. This
1178  * can later be changed with {transferOwnership}.
1179  *
1180  * This module is used through inheritance. It will make available the modifier
1181  * `onlyOwner`, which can be applied to your functions to restrict their use to
1182  * the owner.
1183  */
1184 abstract contract Ownable is Context {
1185     address private _owner;
1186 
1187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1188 
1189     /**
1190      * @dev Initializes the contract setting the deployer as the initial owner.
1191      */
1192     constructor() {
1193         _transferOwnership(_msgSender());
1194     }
1195 
1196     /**
1197      * @dev Throws if called by any account other than the owner.
1198      */
1199     modifier onlyOwner() {
1200         _checkOwner();
1201         _;
1202     }
1203 
1204     /**
1205      * @dev Returns the address of the current owner.
1206      */
1207     function owner() public view virtual returns (address) {
1208         return _owner;
1209     }
1210 
1211     /**
1212      * @dev Throws if the sender is not the owner.
1213      */
1214     function _checkOwner() internal view virtual {
1215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1216     }
1217 
1218     /**
1219      * @dev Leaves the contract without owner. It will not be possible to call
1220      * `onlyOwner` functions anymore. Can only be called by the current owner.
1221      *
1222      * NOTE: Renouncing ownership will leave the contract without an owner,
1223      * thereby removing any functionality that is only available to the owner.
1224      */
1225     function renounceOwnership() public virtual onlyOwner {
1226         _transferOwnership(address(0));
1227     }
1228 
1229     /**
1230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1231      * Can only be called by the current owner.
1232      */
1233     function transferOwnership(address newOwner) public virtual onlyOwner {
1234         require(newOwner != address(0), "Ownable: new owner is the zero address");
1235         _transferOwnership(newOwner);
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Internal function without access restriction.
1241      */
1242     function _transferOwnership(address newOwner) internal virtual {
1243         address oldOwner = _owner;
1244         _owner = newOwner;
1245         emit OwnershipTransferred(oldOwner, newOwner);
1246     }
1247 }
1248 
1249 // File: @openzeppelin/contracts/utils/Address.sol
1250 
1251 
1252 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1253 
1254 pragma solidity ^0.8.1;
1255 
1256 /**
1257  * @dev Collection of functions related to the address type
1258  */
1259 library Address {
1260     /**
1261      * @dev Returns true if `account` is a contract.
1262      *
1263      * [IMPORTANT]
1264      * ====
1265      * It is unsafe to assume that an address for which this function returns
1266      * false is an externally-owned account (EOA) and not a contract.
1267      *
1268      * Among others, `isContract` will return false for the following
1269      * types of addresses:
1270      *
1271      *  - an externally-owned account
1272      *  - a contract in construction
1273      *  - an address where a contract will be created
1274      *  - an address where a contract lived, but was destroyed
1275      * ====
1276      *
1277      * [IMPORTANT]
1278      * ====
1279      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1280      *
1281      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1282      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1283      * constructor.
1284      * ====
1285      */
1286     function isContract(address account) internal view returns (bool) {
1287         // This method relies on extcodesize/address.code.length, which returns 0
1288         // for contracts in construction, since the code is only stored at the end
1289         // of the constructor execution.
1290 
1291         return account.code.length > 0;
1292     }
1293 
1294     /**
1295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1296      * `recipient`, forwarding all available gas and reverting on errors.
1297      *
1298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1300      * imposed by `transfer`, making them unable to receive funds via
1301      * `transfer`. {sendValue} removes this limitation.
1302      *
1303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1304      *
1305      * IMPORTANT: because control is transferred to `recipient`, care must be
1306      * taken to not create reentrancy vulnerabilities. Consider using
1307      * {ReentrancyGuard} or the
1308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1309      */
1310     function sendValue(address payable recipient, uint256 amount) internal {
1311         require(address(this).balance >= amount, "Address: insufficient balance");
1312 
1313         (bool success, ) = recipient.call{value: amount}("");
1314         require(success, "Address: unable to send value, recipient may have reverted");
1315     }
1316 
1317     /**
1318      * @dev Performs a Solidity function call using a low level `call`. A
1319      * plain `call` is an unsafe replacement for a function call: use this
1320      * function instead.
1321      *
1322      * If `target` reverts with a revert reason, it is bubbled up by this
1323      * function (like regular Solidity function calls).
1324      *
1325      * Returns the raw returned data. To convert to the expected return value,
1326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1327      *
1328      * Requirements:
1329      *
1330      * - `target` must be a contract.
1331      * - calling `target` with `data` must not revert.
1332      *
1333      * _Available since v3.1._
1334      */
1335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1336         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1337     }
1338 
1339     /**
1340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1341      * `errorMessage` as a fallback revert reason when `target` reverts.
1342      *
1343      * _Available since v3.1._
1344      */
1345     function functionCall(
1346         address target,
1347         bytes memory data,
1348         string memory errorMessage
1349     ) internal returns (bytes memory) {
1350         return functionCallWithValue(target, data, 0, errorMessage);
1351     }
1352 
1353     /**
1354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1355      * but also transferring `value` wei to `target`.
1356      *
1357      * Requirements:
1358      *
1359      * - the calling contract must have an ETH balance of at least `value`.
1360      * - the called Solidity function must be `payable`.
1361      *
1362      * _Available since v3.1._
1363      */
1364     function functionCallWithValue(
1365         address target,
1366         bytes memory data,
1367         uint256 value
1368     ) internal returns (bytes memory) {
1369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1370     }
1371 
1372     /**
1373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1374      * with `errorMessage` as a fallback revert reason when `target` reverts.
1375      *
1376      * _Available since v3.1._
1377      */
1378     function functionCallWithValue(
1379         address target,
1380         bytes memory data,
1381         uint256 value,
1382         string memory errorMessage
1383     ) internal returns (bytes memory) {
1384         require(address(this).balance >= value, "Address: insufficient balance for call");
1385         (bool success, bytes memory returndata) = target.call{value: value}(data);
1386         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1387     }
1388 
1389     /**
1390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1391      * but performing a static call.
1392      *
1393      * _Available since v3.3._
1394      */
1395     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1396         return functionStaticCall(target, data, "Address: low-level static call failed");
1397     }
1398 
1399     /**
1400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1401      * but performing a static call.
1402      *
1403      * _Available since v3.3._
1404      */
1405     function functionStaticCall(
1406         address target,
1407         bytes memory data,
1408         string memory errorMessage
1409     ) internal view returns (bytes memory) {
1410         (bool success, bytes memory returndata) = target.staticcall(data);
1411         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1412     }
1413 
1414     /**
1415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1416      * but performing a delegate call.
1417      *
1418      * _Available since v3.4._
1419      */
1420     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1421         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1422     }
1423 
1424     /**
1425      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1426      * but performing a delegate call.
1427      *
1428      * _Available since v3.4._
1429      */
1430     function functionDelegateCall(
1431         address target,
1432         bytes memory data,
1433         string memory errorMessage
1434     ) internal returns (bytes memory) {
1435         (bool success, bytes memory returndata) = target.delegatecall(data);
1436         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1437     }
1438 
1439     /**
1440      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1441      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1442      *
1443      * _Available since v4.8._
1444      */
1445     function verifyCallResultFromTarget(
1446         address target,
1447         bool success,
1448         bytes memory returndata,
1449         string memory errorMessage
1450     ) internal view returns (bytes memory) {
1451         if (success) {
1452             if (returndata.length == 0) {
1453                 // only check isContract if the call was successful and the return data is empty
1454                 // otherwise we already know that it was a contract
1455                 require(isContract(target), "Address: call to non-contract");
1456             }
1457             return returndata;
1458         } else {
1459             _revert(returndata, errorMessage);
1460         }
1461     }
1462 
1463     /**
1464      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1465      * revert reason or using the provided one.
1466      *
1467      * _Available since v4.3._
1468      */
1469     function verifyCallResult(
1470         bool success,
1471         bytes memory returndata,
1472         string memory errorMessage
1473     ) internal pure returns (bytes memory) {
1474         if (success) {
1475             return returndata;
1476         } else {
1477             _revert(returndata, errorMessage);
1478         }
1479     }
1480 
1481     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1482         // Look for revert reason and bubble it up if present
1483         if (returndata.length > 0) {
1484             // The easiest way to bubble the revert reason is using memory via assembly
1485             /// @solidity memory-safe-assembly
1486             assembly {
1487                 let returndata_size := mload(returndata)
1488                 revert(add(32, returndata), returndata_size)
1489             }
1490         } else {
1491             revert(errorMessage);
1492         }
1493     }
1494 }
1495 
1496 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1497 
1498 
1499 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1500 
1501 pragma solidity ^0.8.0;
1502 
1503 /**
1504  * @title ERC721 token receiver interface
1505  * @dev Interface for any contract that wants to support safeTransfers
1506  * from ERC721 asset contracts.
1507  */
1508 interface IERC721Receiver {
1509     /**
1510      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1511      * by `operator` from `from`, this function is called.
1512      *
1513      * It must return its Solidity selector to confirm the token transfer.
1514      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1515      *
1516      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1517      */
1518     function onERC721Received(
1519         address operator,
1520         address from,
1521         uint256 tokenId,
1522         bytes calldata data
1523     ) external returns (bytes4);
1524 }
1525 
1526 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1527 
1528 
1529 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1530 
1531 pragma solidity ^0.8.0;
1532 
1533 /**
1534  * @dev Interface of the ERC165 standard, as defined in the
1535  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1536  *
1537  * Implementers can declare support of contract interfaces, which can then be
1538  * queried by others ({ERC165Checker}).
1539  *
1540  * For an implementation, see {ERC165}.
1541  */
1542 interface IERC165 {
1543     /**
1544      * @dev Returns true if this contract implements the interface defined by
1545      * `interfaceId`. See the corresponding
1546      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1547      * to learn more about how these ids are created.
1548      *
1549      * This function call must use less than 30 000 gas.
1550      */
1551     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1552 }
1553 
1554 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1555 
1556 
1557 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1558 
1559 pragma solidity ^0.8.0;
1560 
1561 
1562 /**
1563  * @dev Interface for the NFT Royalty Standard.
1564  *
1565  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1566  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1567  *
1568  * _Available since v4.5._
1569  */
1570 interface IERC2981 is IERC165 {
1571     /**
1572      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1573      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1574      */
1575     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1576         external
1577         view
1578         returns (address receiver, uint256 royaltyAmount);
1579 }
1580 
1581 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1582 
1583 
1584 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 
1589 /**
1590  * @dev Implementation of the {IERC165} interface.
1591  *
1592  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1593  * for the additional interface id that will be supported. For example:
1594  *
1595  * ```solidity
1596  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1597  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1598  * }
1599  * ```
1600  *
1601  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1602  */
1603 abstract contract ERC165 is IERC165 {
1604     /**
1605      * @dev See {IERC165-supportsInterface}.
1606      */
1607     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1608         return interfaceId == type(IERC165).interfaceId;
1609     }
1610 }
1611 
1612 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1613 
1614 
1615 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1616 
1617 pragma solidity ^0.8.0;
1618 
1619 
1620 
1621 /**
1622  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1623  *
1624  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1625  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1626  *
1627  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1628  * fee is specified in basis points by default.
1629  *
1630  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1631  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1632  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1633  *
1634  * _Available since v4.5._
1635  */
1636 abstract contract ERC2981 is IERC2981, ERC165 {
1637     struct RoyaltyInfo {
1638         address receiver;
1639         uint96 royaltyFraction;
1640     }
1641 
1642     RoyaltyInfo private _defaultRoyaltyInfo;
1643     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1644 
1645     /**
1646      * @dev See {IERC165-supportsInterface}.
1647      */
1648     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1649         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1650     }
1651 
1652     /**
1653      * @inheritdoc IERC2981
1654      */
1655     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1656         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1657 
1658         if (royalty.receiver == address(0)) {
1659             royalty = _defaultRoyaltyInfo;
1660         }
1661 
1662         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1663 
1664         return (royalty.receiver, royaltyAmount);
1665     }
1666 
1667     /**
1668      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1669      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1670      * override.
1671      */
1672     function _feeDenominator() internal pure virtual returns (uint96) {
1673         return 10000;
1674     }
1675 
1676     /**
1677      * @dev Sets the royalty information that all ids in this contract will default to.
1678      *
1679      * Requirements:
1680      *
1681      * - `receiver` cannot be the zero address.
1682      * - `feeNumerator` cannot be greater than the fee denominator.
1683      */
1684     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1685         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1686         require(receiver != address(0), "ERC2981: invalid receiver");
1687 
1688         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1689     }
1690 
1691     /**
1692      * @dev Removes default royalty information.
1693      */
1694     function _deleteDefaultRoyalty() internal virtual {
1695         delete _defaultRoyaltyInfo;
1696     }
1697 
1698     /**
1699      * @dev Sets the royalty information for a specific token id, overriding the global default.
1700      *
1701      * Requirements:
1702      *
1703      * - `receiver` cannot be the zero address.
1704      * - `feeNumerator` cannot be greater than the fee denominator.
1705      */
1706     function _setTokenRoyalty(
1707         uint256 tokenId,
1708         address receiver,
1709         uint96 feeNumerator
1710     ) internal virtual {
1711         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1712         require(receiver != address(0), "ERC2981: Invalid parameters");
1713 
1714         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1715     }
1716 
1717     /**
1718      * @dev Resets royalty information for the token id back to the global default.
1719      */
1720     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1721         delete _tokenRoyaltyInfo[tokenId];
1722     }
1723 }
1724 
1725 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1726 
1727 
1728 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1729 
1730 pragma solidity ^0.8.0;
1731 
1732 
1733 /**
1734  * @dev Required interface of an ERC721 compliant contract.
1735  */
1736 interface IERC721 is IERC165 {
1737     /**
1738      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1739      */
1740     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1741 
1742     /**
1743      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1744      */
1745     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1746 
1747     /**
1748      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1749      */
1750     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1751 
1752     /**
1753      * @dev Returns the number of tokens in ``owner``'s account.
1754      */
1755     function balanceOf(address owner) external view returns (uint256 balance);
1756 
1757     /**
1758      * @dev Returns the owner of the `tokenId` token.
1759      *
1760      * Requirements:
1761      *
1762      * - `tokenId` must exist.
1763      */
1764     function ownerOf(uint256 tokenId) external view returns (address owner);
1765 
1766     /**
1767      * @dev Safely transfers `tokenId` token from `from` to `to`.
1768      *
1769      * Requirements:
1770      *
1771      * - `from` cannot be the zero address.
1772      * - `to` cannot be the zero address.
1773      * - `tokenId` token must exist and be owned by `from`.
1774      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1776      *
1777      * Emits a {Transfer} event.
1778      */
1779     function safeTransferFrom(
1780         address from,
1781         address to,
1782         uint256 tokenId,
1783         bytes calldata data
1784     ) external;
1785 
1786     /**
1787      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1788      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1789      *
1790      * Requirements:
1791      *
1792      * - `from` cannot be the zero address.
1793      * - `to` cannot be the zero address.
1794      * - `tokenId` token must exist and be owned by `from`.
1795      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1797      *
1798      * Emits a {Transfer} event.
1799      */
1800     function safeTransferFrom(
1801         address from,
1802         address to,
1803         uint256 tokenId
1804     ) external;
1805 
1806     /**
1807      * @dev Transfers `tokenId` token from `from` to `to`.
1808      *
1809      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1810      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1811      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1812      *
1813      * Requirements:
1814      *
1815      * - `from` cannot be the zero address.
1816      * - `to` cannot be the zero address.
1817      * - `tokenId` token must be owned by `from`.
1818      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1819      *
1820      * Emits a {Transfer} event.
1821      */
1822     function transferFrom(
1823         address from,
1824         address to,
1825         uint256 tokenId
1826     ) external;
1827 
1828     /**
1829      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1830      * The approval is cleared when the token is transferred.
1831      *
1832      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1833      *
1834      * Requirements:
1835      *
1836      * - The caller must own the token or be an approved operator.
1837      * - `tokenId` must exist.
1838      *
1839      * Emits an {Approval} event.
1840      */
1841     function approve(address to, uint256 tokenId) external;
1842 
1843     /**
1844      * @dev Approve or remove `operator` as an operator for the caller.
1845      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1846      *
1847      * Requirements:
1848      *
1849      * - The `operator` cannot be the caller.
1850      *
1851      * Emits an {ApprovalForAll} event.
1852      */
1853     function setApprovalForAll(address operator, bool _approved) external;
1854 
1855     /**
1856      * @dev Returns the account approved for `tokenId` token.
1857      *
1858      * Requirements:
1859      *
1860      * - `tokenId` must exist.
1861      */
1862     function getApproved(uint256 tokenId) external view returns (address operator);
1863 
1864     /**
1865      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1866      *
1867      * See {setApprovalForAll}
1868      */
1869     function isApprovedForAll(address owner, address operator) external view returns (bool);
1870 }
1871 
1872 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1873 
1874 
1875 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1876 
1877 pragma solidity ^0.8.0;
1878 
1879 
1880 /**
1881  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1882  * @dev See https://eips.ethereum.org/EIPS/eip-721
1883  */
1884 interface IERC721Metadata is IERC721 {
1885     /**
1886      * @dev Returns the token collection name.
1887      */
1888     function name() external view returns (string memory);
1889 
1890     /**
1891      * @dev Returns the token collection symbol.
1892      */
1893     function symbol() external view returns (string memory);
1894 
1895     /**
1896      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1897      */
1898     function tokenURI(uint256 tokenId) external view returns (string memory);
1899 }
1900 
1901 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1902 
1903 
1904 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1905 
1906 pragma solidity ^0.8.0;
1907 
1908 
1909 
1910 
1911 
1912 
1913 
1914 
1915 /**
1916  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1917  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1918  * {ERC721Enumerable}.
1919  */
1920 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1921     using Address for address;
1922     using Strings for uint256;
1923 
1924     // Token name
1925     string private _name;
1926 
1927     // Token symbol
1928     string private _symbol;
1929 
1930     // Mapping from token ID to owner address
1931     mapping(uint256 => address) private _owners;
1932 
1933     // Mapping owner address to token count
1934     mapping(address => uint256) private _balances;
1935 
1936     // Mapping from token ID to approved address
1937     mapping(uint256 => address) private _tokenApprovals;
1938 
1939     // Mapping from owner to operator approvals
1940     mapping(address => mapping(address => bool)) private _operatorApprovals;
1941 
1942     /**
1943      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1944      */
1945     constructor(string memory name_, string memory symbol_) {
1946         _name = name_;
1947         _symbol = symbol_;
1948     }
1949 
1950     /**
1951      * @dev See {IERC165-supportsInterface}.
1952      */
1953     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1954         return
1955             interfaceId == type(IERC721).interfaceId ||
1956             interfaceId == type(IERC721Metadata).interfaceId ||
1957             super.supportsInterface(interfaceId);
1958     }
1959 
1960     /**
1961      * @dev See {IERC721-balanceOf}.
1962      */
1963     function balanceOf(address owner) public view virtual override returns (uint256) {
1964         require(owner != address(0), "ERC721: address zero is not a valid owner");
1965         return _balances[owner];
1966     }
1967 
1968     /**
1969      * @dev See {IERC721-ownerOf}.
1970      */
1971     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1972         address owner = _ownerOf(tokenId);
1973         require(owner != address(0), "ERC721: invalid token ID");
1974         return owner;
1975     }
1976 
1977     /**
1978      * @dev See {IERC721Metadata-name}.
1979      */
1980     function name() public view virtual override returns (string memory) {
1981         return _name;
1982     }
1983 
1984     /**
1985      * @dev See {IERC721Metadata-symbol}.
1986      */
1987     function symbol() public view virtual override returns (string memory) {
1988         return _symbol;
1989     }
1990 
1991     /**
1992      * @dev See {IERC721Metadata-tokenURI}.
1993      */
1994     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1995         _requireMinted(tokenId);
1996 
1997         string memory baseURI = _baseURI();
1998         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1999     }
2000 
2001     /**
2002      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2003      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2004      * by default, can be overridden in child contracts.
2005      */
2006     function _baseURI() internal view virtual returns (string memory) {
2007         return "";
2008     }
2009 
2010     /**
2011      * @dev See {IERC721-approve}.
2012      */
2013     function approve(address to, uint256 tokenId) public virtual override {
2014         address owner = ERC721.ownerOf(tokenId);
2015         require(to != owner, "ERC721: approval to current owner");
2016 
2017         require(
2018             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2019             "ERC721: approve caller is not token owner or approved for all"
2020         );
2021 
2022         _approve(to, tokenId);
2023     }
2024 
2025     /**
2026      * @dev See {IERC721-getApproved}.
2027      */
2028     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2029         _requireMinted(tokenId);
2030 
2031         return _tokenApprovals[tokenId];
2032     }
2033 
2034     /**
2035      * @dev See {IERC721-setApprovalForAll}.
2036      */
2037     function setApprovalForAll(address operator, bool approved) public virtual override {
2038         _setApprovalForAll(_msgSender(), operator, approved);
2039     }
2040 
2041     /**
2042      * @dev See {IERC721-isApprovedForAll}.
2043      */
2044     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2045         return _operatorApprovals[owner][operator];
2046     }
2047 
2048     /**
2049      * @dev See {IERC721-transferFrom}.
2050      */
2051     function transferFrom(
2052         address from,
2053         address to,
2054         uint256 tokenId
2055     ) public virtual override {
2056         //solhint-disable-next-line max-line-length
2057         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2058 
2059         _transfer(from, to, tokenId);
2060     }
2061 
2062     /**
2063      * @dev See {IERC721-safeTransferFrom}.
2064      */
2065     function safeTransferFrom(
2066         address from,
2067         address to,
2068         uint256 tokenId
2069     ) public virtual override {
2070         safeTransferFrom(from, to, tokenId, "");
2071     }
2072 
2073     /**
2074      * @dev See {IERC721-safeTransferFrom}.
2075      */
2076     function safeTransferFrom(
2077         address from,
2078         address to,
2079         uint256 tokenId,
2080         bytes memory data
2081     ) public virtual override {
2082         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2083         _safeTransfer(from, to, tokenId, data);
2084     }
2085 
2086     /**
2087      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2088      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2089      *
2090      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2091      *
2092      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2093      * implement alternative mechanisms to perform token transfer, such as signature-based.
2094      *
2095      * Requirements:
2096      *
2097      * - `from` cannot be the zero address.
2098      * - `to` cannot be the zero address.
2099      * - `tokenId` token must exist and be owned by `from`.
2100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2101      *
2102      * Emits a {Transfer} event.
2103      */
2104     function _safeTransfer(
2105         address from,
2106         address to,
2107         uint256 tokenId,
2108         bytes memory data
2109     ) internal virtual {
2110         _transfer(from, to, tokenId);
2111         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2112     }
2113 
2114     /**
2115      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
2116      */
2117     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
2118         return _owners[tokenId];
2119     }
2120 
2121     /**
2122      * @dev Returns whether `tokenId` exists.
2123      *
2124      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2125      *
2126      * Tokens start existing when they are minted (`_mint`),
2127      * and stop existing when they are burned (`_burn`).
2128      */
2129     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2130         return _ownerOf(tokenId) != address(0);
2131     }
2132 
2133     /**
2134      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2135      *
2136      * Requirements:
2137      *
2138      * - `tokenId` must exist.
2139      */
2140     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2141         address owner = ERC721.ownerOf(tokenId);
2142         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2143     }
2144 
2145     /**
2146      * @dev Safely mints `tokenId` and transfers it to `to`.
2147      *
2148      * Requirements:
2149      *
2150      * - `tokenId` must not exist.
2151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2152      *
2153      * Emits a {Transfer} event.
2154      */
2155     function _safeMint(address to, uint256 tokenId) internal virtual {
2156         _safeMint(to, tokenId, "");
2157     }
2158 
2159     /**
2160      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2161      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2162      */
2163     function _safeMint(
2164         address to,
2165         uint256 tokenId,
2166         bytes memory data
2167     ) internal virtual {
2168         _mint(to, tokenId);
2169         require(
2170             _checkOnERC721Received(address(0), to, tokenId, data),
2171             "ERC721: transfer to non ERC721Receiver implementer"
2172         );
2173     }
2174 
2175     /**
2176      * @dev Mints `tokenId` and transfers it to `to`.
2177      *
2178      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2179      *
2180      * Requirements:
2181      *
2182      * - `tokenId` must not exist.
2183      * - `to` cannot be the zero address.
2184      *
2185      * Emits a {Transfer} event.
2186      */
2187     function _mint(address to, uint256 tokenId) internal virtual {
2188         require(to != address(0), "ERC721: mint to the zero address");
2189         require(!_exists(tokenId), "ERC721: token already minted");
2190 
2191         _beforeTokenTransfer(address(0), to, tokenId, 1);
2192 
2193         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
2194         require(!_exists(tokenId), "ERC721: token already minted");
2195 
2196         unchecked {
2197             // Will not overflow unless all 2**256 token ids are minted to the same owner.
2198             // Given that tokens are minted one by one, it is impossible in practice that
2199             // this ever happens. Might change if we allow batch minting.
2200             // The ERC fails to describe this case.
2201             _balances[to] += 1;
2202         }
2203 
2204         _owners[tokenId] = to;
2205 
2206         emit Transfer(address(0), to, tokenId);
2207 
2208         _afterTokenTransfer(address(0), to, tokenId, 1);
2209     }
2210 
2211     /**
2212      * @dev Destroys `tokenId`.
2213      * The approval is cleared when the token is burned.
2214      * This is an internal function that does not check if the sender is authorized to operate on the token.
2215      *
2216      * Requirements:
2217      *
2218      * - `tokenId` must exist.
2219      *
2220      * Emits a {Transfer} event.
2221      */
2222     function _burn(uint256 tokenId) internal virtual {
2223         address owner = ERC721.ownerOf(tokenId);
2224 
2225         _beforeTokenTransfer(owner, address(0), tokenId, 1);
2226 
2227         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
2228         owner = ERC721.ownerOf(tokenId);
2229 
2230         // Clear approvals
2231         delete _tokenApprovals[tokenId];
2232 
2233         unchecked {
2234             // Cannot overflow, as that would require more tokens to be burned/transferred
2235             // out than the owner initially received through minting and transferring in.
2236             _balances[owner] -= 1;
2237         }
2238         delete _owners[tokenId];
2239 
2240         emit Transfer(owner, address(0), tokenId);
2241 
2242         _afterTokenTransfer(owner, address(0), tokenId, 1);
2243     }
2244 
2245     /**
2246      * @dev Transfers `tokenId` from `from` to `to`.
2247      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2248      *
2249      * Requirements:
2250      *
2251      * - `to` cannot be the zero address.
2252      * - `tokenId` token must be owned by `from`.
2253      *
2254      * Emits a {Transfer} event.
2255      */
2256     function _transfer(
2257         address from,
2258         address to,
2259         uint256 tokenId
2260     ) internal virtual {
2261         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2262         require(to != address(0), "ERC721: transfer to the zero address");
2263 
2264         _beforeTokenTransfer(from, to, tokenId, 1);
2265 
2266         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
2267         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2268 
2269         // Clear approvals from the previous owner
2270         delete _tokenApprovals[tokenId];
2271 
2272         unchecked {
2273             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
2274             // `from`'s balance is the number of token held, which is at least one before the current
2275             // transfer.
2276             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
2277             // all 2**256 token ids to be minted, which in practice is impossible.
2278             _balances[from] -= 1;
2279             _balances[to] += 1;
2280         }
2281         _owners[tokenId] = to;
2282 
2283         emit Transfer(from, to, tokenId);
2284 
2285         _afterTokenTransfer(from, to, tokenId, 1);
2286     }
2287 
2288     /**
2289      * @dev Approve `to` to operate on `tokenId`
2290      *
2291      * Emits an {Approval} event.
2292      */
2293     function _approve(address to, uint256 tokenId) internal virtual {
2294         _tokenApprovals[tokenId] = to;
2295         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2296     }
2297 
2298     /**
2299      * @dev Approve `operator` to operate on all of `owner` tokens
2300      *
2301      * Emits an {ApprovalForAll} event.
2302      */
2303     function _setApprovalForAll(
2304         address owner,
2305         address operator,
2306         bool approved
2307     ) internal virtual {
2308         require(owner != operator, "ERC721: approve to caller");
2309         _operatorApprovals[owner][operator] = approved;
2310         emit ApprovalForAll(owner, operator, approved);
2311     }
2312 
2313     /**
2314      * @dev Reverts if the `tokenId` has not been minted yet.
2315      */
2316     function _requireMinted(uint256 tokenId) internal view virtual {
2317         require(_exists(tokenId), "ERC721: invalid token ID");
2318     }
2319 
2320     /**
2321      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2322      * The call is not executed if the target address is not a contract.
2323      *
2324      * @param from address representing the previous owner of the given token ID
2325      * @param to target address that will receive the tokens
2326      * @param tokenId uint256 ID of the token to be transferred
2327      * @param data bytes optional data to send along with the call
2328      * @return bool whether the call correctly returned the expected magic value
2329      */
2330     function _checkOnERC721Received(
2331         address from,
2332         address to,
2333         uint256 tokenId,
2334         bytes memory data
2335     ) private returns (bool) {
2336         if (to.isContract()) {
2337             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2338                 return retval == IERC721Receiver.onERC721Received.selector;
2339             } catch (bytes memory reason) {
2340                 if (reason.length == 0) {
2341                     revert("ERC721: transfer to non ERC721Receiver implementer");
2342                 } else {
2343                     /// @solidity memory-safe-assembly
2344                     assembly {
2345                         revert(add(32, reason), mload(reason))
2346                     }
2347                 }
2348             }
2349         } else {
2350             return true;
2351         }
2352     }
2353 
2354     /**
2355      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2356      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2357      *
2358      * Calling conditions:
2359      *
2360      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
2361      * - When `from` is zero, the tokens will be minted for `to`.
2362      * - When `to` is zero, ``from``'s tokens will be burned.
2363      * - `from` and `to` are never both zero.
2364      * - `batchSize` is non-zero.
2365      *
2366      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2367      */
2368     function _beforeTokenTransfer(
2369         address from,
2370         address to,
2371         uint256, /* firstTokenId */
2372         uint256 batchSize
2373     ) internal virtual {
2374         if (batchSize > 1) {
2375             if (from != address(0)) {
2376                 _balances[from] -= batchSize;
2377             }
2378             if (to != address(0)) {
2379                 _balances[to] += batchSize;
2380             }
2381         }
2382     }
2383 
2384     /**
2385      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2386      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2387      *
2388      * Calling conditions:
2389      *
2390      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
2391      * - When `from` is zero, the tokens were minted for `to`.
2392      * - When `to` is zero, ``from``'s tokens were burned.
2393      * - `from` and `to` are never both zero.
2394      * - `batchSize` is non-zero.
2395      *
2396      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2397      */
2398     function _afterTokenTransfer(
2399         address from,
2400         address to,
2401         uint256 firstTokenId,
2402         uint256 batchSize
2403     ) internal virtual {}
2404 }
2405 
2406 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
2407 
2408 
2409 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
2410 
2411 pragma solidity ^0.8.0;
2412 
2413 
2414 
2415 /**
2416  * @title ERC721 Burnable Token
2417  * @dev ERC721 Token that can be burned (destroyed).
2418  */
2419 abstract contract ERC721Burnable is Context, ERC721 {
2420     /**
2421      * @dev Burns `tokenId`. See {ERC721-_burn}.
2422      *
2423      * Requirements:
2424      *
2425      * - The caller must own `tokenId` or be an approved operator.
2426      */
2427     function burn(uint256 tokenId) public virtual {
2428         //solhint-disable-next-line max-line-length
2429         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2430         _burn(tokenId);
2431     }
2432 }
2433 
2434 // File: contracts/LarvaFactory.sol
2435 
2436 //SPDX-License-Identifier: MIT
2437 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
2438 
2439 pragma solidity ^0.8.17;
2440 
2441 
2442 
2443 
2444 
2445 
2446 
2447 
2448 
2449 
2450 
2451 
2452 
2453 
2454 
2455 
2456 
2457 
2458 
2459 
2460 
2461 
2462 contract LarvaFactory is 
2463     ERC721,
2464     ERC2981,
2465     Ownable,
2466     DefaultOperatorFilterer,
2467     ReentrancyGuard {   
2468     using Counters for Counters.Counter;
2469     using Strings for uint256;
2470 
2471     Counters.Counter private tokenCounter;
2472 
2473     address chryDnaContract;
2474 
2475     string private baseURI;
2476     string public verificationHash;
2477 
2478     address private mintPasses;
2479 
2480     bool public isRedeemPeriodActive;
2481     bool public isHatchPeriodActive;
2482 
2483     bool public isMetadataFrozen;
2484 
2485     mapping(uint256 => bytes32) public seedOf;
2486     mapping(uint256 => bytes32) public hatchDataOf;
2487     mapping(uint256 => uint256) public accountNonceOf;
2488     mapping(uint256 => uint8) public signOf;
2489     mapping(uint256 => bool) public hatched;
2490     
2491     // ============ EVENTS ============
2492 
2493     event Minted(
2494         address indexed buyer, 
2495         uint256 indexed tokenId);
2496 
2497     event Hatched(
2498         address indexed hatcher, 
2499         uint256 indexed tokenId);        
2500 
2501     // ============= ERRORS =============
2502 
2503     error BurnFailed(uint256 tokenId);
2504     error NotMintPassOwner(uint256 tokenId, address collector);
2505 
2506     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
2507 
2508     modifier canUpdateMetadata() {
2509         require(!isMetadataFrozen, "Metadata is frozen");
2510         _;
2511     }
2512 
2513     modifier redeemPeriodActive() {
2514         require(isRedeemPeriodActive, "Redeem period is not open");
2515         _;
2516     }
2517 
2518     modifier hatchPeriodActive() {
2519         require(isHatchPeriodActive, "Hatch period is not open");
2520         _;
2521     }
2522         
2523     modifier onlyTokenHolder(uint256 tokenId) {
2524         require(msg.sender == ownerOf(tokenId), "Only the owner can hatch");
2525         _;
2526     }
2527 
2528     modifier isValidSign(uint8 sign) {
2529         require(
2530             sign >= 0 && sign < 12,
2531             "Sign must be between 0 and 11 inclusive"
2532         );
2533         _;
2534     }    
2535 
2536     constructor(address _mintPasses
2537     ) ERC721("CHRYSALISM", "CHRY") {
2538         mintPasses = _mintPasses;
2539     }
2540 
2541     // ============ PUBLIC FUNCTIONS FOR REDEEMING AND HATCHING ============
2542 
2543     function redeem(uint8 numberOfTokens, uint256[] calldata mintPassTokenIds, uint8[] memory signs, uint256 accountNonce)
2544         external
2545         nonReentrant
2546         redeemPeriodActive
2547     {
2548         for (uint8 i = 0; i < numberOfTokens; i++) {
2549             ERC721PartnerSeaDropBurnable mintPassContract = ERC721PartnerSeaDropBurnable(mintPasses);
2550 
2551             if (mintPassContract.ownerOf(mintPassTokenIds[i]) != msg.sender) {
2552                 revert NotMintPassOwner(mintPassTokenIds[i], msg.sender);
2553             }
2554 
2555             mintPassContract.burn(mintPassTokenIds[i]);
2556 
2557             mint(signs[i], accountNonce);
2558         }
2559     }
2560 
2561     function hatch(uint256 tokenId, bytes32 hatchData) 
2562         external 
2563         nonReentrant 
2564         hatchPeriodActive
2565         onlyTokenHolder(tokenId) {
2566         require(hatched[tokenId] == false, "Token is hatched already");
2567 
2568         hatchDataOf[tokenId] = hatchData;
2569         hatched[tokenId] = true;
2570 
2571         emit Hatched(
2572             msg.sender, 
2573             tokenId);  
2574     }
2575 
2576     // ============ PUBLIC READ-ONLY FUNCTIONS ============
2577 
2578     function getBaseURI() external view returns (string memory) {
2579         return baseURI;
2580     }
2581 
2582     function getLastTokenId() external view returns (uint256) {
2583         return tokenCounter.current();
2584     }
2585 
2586     function getSeed(uint tokenId) public view returns(bytes32) {
2587         return seedOf[tokenId];
2588     }
2589 
2590     function getHatchData(uint tokenId) public view returns(bytes32) {
2591         return hatchDataOf[tokenId];
2592     }    
2593 
2594     function getSign(uint tokenId) public view returns(uint8) {
2595         return signOf[tokenId];
2596     }
2597 
2598     function getAccountNonce(uint tokenId) public view returns(uint256) {
2599         return accountNonceOf[tokenId];
2600     }    
2601 
2602     function getHatched(uint tokenId) public view returns(bool) {
2603         return hatched[tokenId];
2604     }
2605 
2606     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
2607 
2608     function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) 
2609         public
2610         onlyOwner
2611     {
2612       _setDefaultRoyalty(_receiver, _feeNumerator);
2613     }
2614 
2615     // prevent updating of baseUri. cannot be reversed
2616     function freezeMetadata() 
2617         external
2618         onlyOwner
2619     {
2620         isMetadataFrozen = true;
2621     }
2622 
2623     function setBaseURI(string memory _baseURI) 
2624         external 
2625         onlyOwner
2626         canUpdateMetadata 
2627     {
2628         baseURI = _baseURI;
2629     }
2630 
2631     function setVerificationHash(string memory _verificationHash)
2632         external
2633         onlyOwner
2634     {
2635         verificationHash = _verificationHash;
2636     }
2637 
2638     function setIsRedeemPeriodActive(bool _isRedeemPeriodActive)
2639         external
2640         onlyOwner
2641     {
2642         isRedeemPeriodActive = _isRedeemPeriodActive;
2643     }
2644 
2645     function setIsHatchPeriodActive(bool _isHatchPeriodActive)
2646         external
2647         onlyOwner
2648     {
2649         isHatchPeriodActive = _isHatchPeriodActive;
2650     }
2651 
2652     function withdraw() 
2653         public 
2654         onlyOwner 
2655     {
2656         uint256 balance = address(this).balance;
2657         payable(msg.sender).transfer(balance);
2658     }
2659 
2660     function withdrawTokens(IERC20 token) 
2661         public 
2662         onlyOwner 
2663     {
2664         uint256 balance = token.balanceOf(address(this));
2665         token.transfer(msg.sender, balance);
2666     }
2667 
2668     // ============ SUPPORTING FUNCTIONS ============ 
2669 
2670     function mint(uint8 sign, uint256 accountNonce)
2671         isValidSign(sign)
2672         private
2673     {
2674         uint256 tokenId = nextTokenId();
2675 
2676         bytes32 seed = bytes32(keccak256(abi.encodePacked(msg.sender, sign, block.number, tokenId)));
2677 
2678         seedOf[tokenId] = seed;
2679         signOf[tokenId] = sign;
2680         accountNonceOf[tokenId] = accountNonce;
2681         hatched[tokenId] = false;
2682 
2683         _safeMint(msg.sender, tokenId);
2684 
2685         emit Minted(
2686             msg.sender, 
2687             tokenId);  
2688     }
2689 
2690     function nextTokenId() 
2691         private
2692         returns (uint256) 
2693     {
2694         tokenCounter.increment();
2695         return tokenCounter.current();
2696     }
2697 
2698     // ============ FUNCTION OVERRIDES ============
2699 
2700     function supportsInterface(bytes4 interfaceId)
2701         public
2702         view
2703         virtual
2704         override(ERC721, ERC2981)
2705         returns (bool)
2706     {
2707         return
2708             interfaceId == type(IERC2981).interfaceId ||
2709             super.supportsInterface(interfaceId);
2710     }
2711 
2712     /**
2713      * @dev See {IERC721Metadata-tokenURI}.
2714      */
2715     function tokenURI(uint256 tokenId)
2716         public
2717         view
2718         virtual
2719         override
2720         returns (string memory)
2721     {
2722         require(_exists(tokenId), "Nonexistent token");
2723 
2724         return
2725             string(abi.encodePacked(baseURI, "/", tokenId.toString()));
2726     }
2727 
2728     // OPERATOR FILTER OVERRIDES
2729     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2730         super.setApprovalForAll(operator, approved);
2731     }
2732 
2733     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2734         super.approve(operator, tokenId);
2735     }
2736 
2737     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2738         super.transferFrom(from, to, tokenId);
2739     }
2740 
2741     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2742         super.safeTransferFrom(from, to, tokenId);
2743     }
2744 
2745     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2746         public
2747         override
2748         onlyAllowedOperator(from)
2749     {
2750         super.safeTransferFrom(from, to, tokenId, data);
2751     }
2752 }
2753 
2754 contract ERC721PartnerSeaDropBurnable {
2755     function burn(uint256 tokenId) external {}
2756     function ownerOf(uint256 tokenId) external view returns (address) {}
2757 }