1 // File: @openzeppelin/contracts/token/ERC777/IERC777.sol
2 
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /**
7  * @dev Interface of the ERC777Token standard as defined in the EIP.
8  *
9  * This contract uses the
10  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
11  * token holders and recipients react to token movements by using setting implementers
12  * for the associated interfaces in said registry. See {IERC1820Registry} and
13  * {ERC1820Implementer}.
14  */
15 interface IERC777 {
16     /**
17      * @dev Returns the name of the token.
18      */
19     function name() external view returns (string memory);
20 
21     /**
22      * @dev Returns the symbol of the token, usually a shorter version of the
23      * name.
24      */
25     function symbol() external view returns (string memory);
26 
27     /**
28      * @dev Returns the smallest part of the token that is not divisible. This
29      * means all token operations (creation, movement and destruction) must have
30      * amounts that are a multiple of this number.
31      *
32      * For most token contracts, this value will equal 1.
33      */
34     function granularity() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by an account (`owner`).
43      */
44     function balanceOf(address owner) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * If send or receive hooks are registered for the caller and `recipient`,
50      * the corresponding functions will be called with `data` and empty
51      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
52      *
53      * Emits a {Sent} event.
54      *
55      * Requirements
56      *
57      * - the caller must have at least `amount` tokens.
58      * - `recipient` cannot be the zero address.
59      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
60      * interface.
61      */
62     function send(address recipient, uint256 amount, bytes calldata data) external;
63 
64     /**
65      * @dev Destroys `amount` tokens from the caller's account, reducing the
66      * total supply.
67      *
68      * If a send hook is registered for the caller, the corresponding function
69      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
70      *
71      * Emits a {Burned} event.
72      *
73      * Requirements
74      *
75      * - the caller must have at least `amount` tokens.
76      */
77     function burn(uint256 amount, bytes calldata data) external;
78 
79     /**
80      * @dev Returns true if an account is an operator of `tokenHolder`.
81      * Operators can send and burn tokens on behalf of their owners. All
82      * accounts are their own operator.
83      *
84      * See {operatorSend} and {operatorBurn}.
85      */
86     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
87 
88     /**
89      * @dev Make an account an operator of the caller.
90      *
91      * See {isOperatorFor}.
92      *
93      * Emits an {AuthorizedOperator} event.
94      *
95      * Requirements
96      *
97      * - `operator` cannot be calling address.
98      */
99     function authorizeOperator(address operator) external;
100 
101     /**
102      * @dev Revoke an account's operator status for the caller.
103      *
104      * See {isOperatorFor} and {defaultOperators}.
105      *
106      * Emits a {RevokedOperator} event.
107      *
108      * Requirements
109      *
110      * - `operator` cannot be calling address.
111      */
112     function revokeOperator(address operator) external;
113 
114     /**
115      * @dev Returns the list of default operators. These accounts are operators
116      * for all token holders, even if {authorizeOperator} was never called on
117      * them.
118      *
119      * This list is immutable, but individual holders may revoke these via
120      * {revokeOperator}, in which case {isOperatorFor} will return false.
121      */
122     function defaultOperators() external view returns (address[] memory);
123 
124     /**
125      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
126      * be an operator of `sender`.
127      *
128      * If send or receive hooks are registered for `sender` and `recipient`,
129      * the corresponding functions will be called with `data` and
130      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
131      *
132      * Emits a {Sent} event.
133      *
134      * Requirements
135      *
136      * - `sender` cannot be the zero address.
137      * - `sender` must have at least `amount` tokens.
138      * - the caller must be an operator for `sender`.
139      * - `recipient` cannot be the zero address.
140      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
141      * interface.
142      */
143     function operatorSend(
144         address sender,
145         address recipient,
146         uint256 amount,
147         bytes calldata data,
148         bytes calldata operatorData
149     ) external;
150 
151     /**
152      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
153      * The caller must be an operator of `account`.
154      *
155      * If a send hook is registered for `account`, the corresponding function
156      * will be called with `data` and `operatorData`. See {IERC777Sender}.
157      *
158      * Emits a {Burned} event.
159      *
160      * Requirements
161      *
162      * - `account` cannot be the zero address.
163      * - `account` must have at least `amount` tokens.
164      * - the caller must be an operator for `account`.
165      */
166     function operatorBurn(
167         address account,
168         uint256 amount,
169         bytes calldata data,
170         bytes calldata operatorData
171     ) external;
172 
173     event Sent(
174         address indexed operator,
175         address indexed from,
176         address indexed to,
177         uint256 amount,
178         bytes data,
179         bytes operatorData
180     );
181 
182     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
183 
184     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
185 
186     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
187 
188     event RevokedOperator(address indexed operator, address indexed tokenHolder);
189 }
190 
191 // File: @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol
192 
193 
194 pragma solidity >=0.6.0 <0.8.0;
195 
196 /**
197  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
198  *
199  * Accounts can be notified of {IERC777} tokens being sent to them by having a
200  * contract implement this interface (contract holders can be their own
201  * implementer) and registering it on the
202  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
203  *
204  * See {IERC1820Registry} and {ERC1820Implementer}.
205  */
206 interface IERC777Recipient {
207     /**
208      * @dev Called by an {IERC777} token contract whenever tokens are being
209      * moved or created into a registered account (`to`). The type of operation
210      * is conveyed by `from` being the zero address or not.
211      *
212      * This call occurs _after_ the token contract's state is updated, so
213      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
214      *
215      * This function may revert to prevent the operation from being executed.
216      */
217     function tokensReceived(
218         address operator,
219         address from,
220         address to,
221         uint256 amount,
222         bytes calldata userData,
223         bytes calldata operatorData
224     ) external;
225 }
226 
227 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
228 
229 
230 pragma solidity >=0.6.0 <0.8.0;
231 
232 /**
233  * @dev Contract module that helps prevent reentrant calls to a function.
234  *
235  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
236  * available, which can be applied to functions to make sure there are no nested
237  * (reentrant) calls to them.
238  *
239  * Note that because there is a single `nonReentrant` guard, functions marked as
240  * `nonReentrant` may not call one another. This can be worked around by making
241  * those functions `private`, and then adding `external` `nonReentrant` entry
242  * points to them.
243  *
244  * TIP: If you would like to learn more about reentrancy and alternative ways
245  * to protect against it, check out our blog post
246  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
247  */
248 abstract contract ReentrancyGuard {
249     // Booleans are more expensive than uint256 or any type that takes up a full
250     // word because each write operation emits an extra SLOAD to first read the
251     // slot's contents, replace the bits taken up by the boolean, and then write
252     // back. This is the compiler's defense against contract upgrades and
253     // pointer aliasing, and it cannot be disabled.
254 
255     // The values being non-zero value makes deployment a bit more expensive,
256     // but in exchange the refund on every call to nonReentrant will be lower in
257     // amount. Since refunds are capped to a percentage of the total
258     // transaction's gas, it is best to keep them low in cases like this one, to
259     // increase the likelihood of the full refund coming into effect.
260     uint256 private constant _NOT_ENTERED = 1;
261     uint256 private constant _ENTERED = 2;
262 
263     uint256 private _status;
264 
265     constructor () internal {
266         _status = _NOT_ENTERED;
267     }
268 
269     /**
270      * @dev Prevents a contract from calling itself, directly or indirectly.
271      * Calling a `nonReentrant` function from another `nonReentrant`
272      * function is not supported. It is possible to prevent this from happening
273      * by making the `nonReentrant` function external, and make it call a
274      * `private` function that does the actual work.
275      */
276     modifier nonReentrant() {
277         // On the first call to nonReentrant, _notEntered will be true
278         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
279 
280         // Any calls to nonReentrant after this point will fail
281         _status = _ENTERED;
282 
283         _;
284 
285         // By storing the original value once again, a refund is triggered (see
286         // https://eips.ethereum.org/EIPS/eip-2200)
287         _status = _NOT_ENTERED;
288     }
289 }
290 
291 // File: @openzeppelin/contracts/introspection/IERC1820Registry.sol
292 
293 
294 pragma solidity >=0.6.0 <0.8.0;
295 
296 /**
297  * @dev Interface of the global ERC1820 Registry, as defined in the
298  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
299  * implementers for interfaces in this registry, as well as query support.
300  *
301  * Implementers may be shared by multiple accounts, and can also implement more
302  * than a single interface for each account. Contracts can implement interfaces
303  * for themselves, but externally-owned accounts (EOA) must delegate this to a
304  * contract.
305  *
306  * {IERC165} interfaces can also be queried via the registry.
307  *
308  * For an in-depth explanation and source code analysis, see the EIP text.
309  */
310 interface IERC1820Registry {
311     /**
312      * @dev Sets `newManager` as the manager for `account`. A manager of an
313      * account is able to set interface implementers for it.
314      *
315      * By default, each account is its own manager. Passing a value of `0x0` in
316      * `newManager` will reset the manager to this initial state.
317      *
318      * Emits a {ManagerChanged} event.
319      *
320      * Requirements:
321      *
322      * - the caller must be the current manager for `account`.
323      */
324     function setManager(address account, address newManager) external;
325 
326     /**
327      * @dev Returns the manager for `account`.
328      *
329      * See {setManager}.
330      */
331     function getManager(address account) external view returns (address);
332 
333     /**
334      * @dev Sets the `implementer` contract as ``account``'s implementer for
335      * `interfaceHash`.
336      *
337      * `account` being the zero address is an alias for the caller's address.
338      * The zero address can also be used in `implementer` to remove an old one.
339      *
340      * See {interfaceHash} to learn how these are created.
341      *
342      * Emits an {InterfaceImplementerSet} event.
343      *
344      * Requirements:
345      *
346      * - the caller must be the current manager for `account`.
347      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
348      * end in 28 zeroes).
349      * - `implementer` must implement {IERC1820Implementer} and return true when
350      * queried for support, unless `implementer` is the caller. See
351      * {IERC1820Implementer-canImplementInterfaceForAddress}.
352      */
353     function setInterfaceImplementer(address account, bytes32 _interfaceHash, address implementer) external;
354 
355     /**
356      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
357      * implementer is registered, returns the zero address.
358      *
359      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
360      * zeroes), `account` will be queried for support of it.
361      *
362      * `account` being the zero address is an alias for the caller's address.
363      */
364     function getInterfaceImplementer(address account, bytes32 _interfaceHash) external view returns (address);
365 
366     /**
367      * @dev Returns the interface hash for an `interfaceName`, as defined in the
368      * corresponding
369      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
370      */
371     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
372 
373     /**
374      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
375      *  @param account Address of the contract for which to update the cache.
376      *  @param interfaceId ERC165 interface for which to update the cache.
377      */
378     function updateERC165Cache(address account, bytes4 interfaceId) external;
379 
380     /**
381      *  @notice Checks whether a contract implements an ERC165 interface or not.
382      *  If the result is not cached a direct lookup on the contract address is performed.
383      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
384      *  {updateERC165Cache} with the contract address.
385      *  @param account Address of the contract to check.
386      *  @param interfaceId ERC165 interface to check.
387      *  @return True if `account` implements `interfaceId`, false otherwise.
388      */
389     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
390 
391     /**
392      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
393      *  @param account Address of the contract to check.
394      *  @param interfaceId ERC165 interface to check.
395      *  @return True if `account` implements `interfaceId`, false otherwise.
396      */
397     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
398 
399     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
400 
401     event ManagerChanged(address indexed account, address indexed newManager);
402 }
403 
404 // File: @openzeppelin/contracts/math/SafeMath.sol
405 
406 
407 pragma solidity >=0.6.0 <0.8.0;
408 
409 /**
410  * @dev Wrappers over Solidity's arithmetic operations with added overflow
411  * checks.
412  *
413  * Arithmetic operations in Solidity wrap on overflow. This can easily result
414  * in bugs, because programmers usually assume that an overflow raises an
415  * error, which is the standard behavior in high level programming languages.
416  * `SafeMath` restores this intuition by reverting the transaction when an
417  * operation overflows.
418  *
419  * Using this library instead of the unchecked operations eliminates an entire
420  * class of bugs, so it's recommended to use it always.
421  */
422 library SafeMath {
423     /**
424      * @dev Returns the addition of two unsigned integers, with an overflow flag.
425      *
426      * _Available since v3.4._
427      */
428     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
429         uint256 c = a + b;
430         if (c < a) return (false, 0);
431         return (true, c);
432     }
433 
434     /**
435      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
436      *
437      * _Available since v3.4._
438      */
439     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
440         if (b > a) return (false, 0);
441         return (true, a - b);
442     }
443 
444     /**
445      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
446      *
447      * _Available since v3.4._
448      */
449     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
450         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
451         // benefit is lost if 'b' is also tested.
452         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
453         if (a == 0) return (true, 0);
454         uint256 c = a * b;
455         if (c / a != b) return (false, 0);
456         return (true, c);
457     }
458 
459     /**
460      * @dev Returns the division of two unsigned integers, with a division by zero flag.
461      *
462      * _Available since v3.4._
463      */
464     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
465         if (b == 0) return (false, 0);
466         return (true, a / b);
467     }
468 
469     /**
470      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
471      *
472      * _Available since v3.4._
473      */
474     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
475         if (b == 0) return (false, 0);
476         return (true, a % b);
477     }
478 
479     /**
480      * @dev Returns the addition of two unsigned integers, reverting on
481      * overflow.
482      *
483      * Counterpart to Solidity's `+` operator.
484      *
485      * Requirements:
486      *
487      * - Addition cannot overflow.
488      */
489     function add(uint256 a, uint256 b) internal pure returns (uint256) {
490         uint256 c = a + b;
491         require(c >= a, "SafeMath: addition overflow");
492         return c;
493     }
494 
495     /**
496      * @dev Returns the subtraction of two unsigned integers, reverting on
497      * overflow (when the result is negative).
498      *
499      * Counterpart to Solidity's `-` operator.
500      *
501      * Requirements:
502      *
503      * - Subtraction cannot overflow.
504      */
505     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
506         require(b <= a, "SafeMath: subtraction overflow");
507         return a - b;
508     }
509 
510     /**
511      * @dev Returns the multiplication of two unsigned integers, reverting on
512      * overflow.
513      *
514      * Counterpart to Solidity's `*` operator.
515      *
516      * Requirements:
517      *
518      * - Multiplication cannot overflow.
519      */
520     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
521         if (a == 0) return 0;
522         uint256 c = a * b;
523         require(c / a == b, "SafeMath: multiplication overflow");
524         return c;
525     }
526 
527     /**
528      * @dev Returns the integer division of two unsigned integers, reverting on
529      * division by zero. The result is rounded towards zero.
530      *
531      * Counterpart to Solidity's `/` operator. Note: this function uses a
532      * `revert` opcode (which leaves remaining gas untouched) while Solidity
533      * uses an invalid opcode to revert (consuming all remaining gas).
534      *
535      * Requirements:
536      *
537      * - The divisor cannot be zero.
538      */
539     function div(uint256 a, uint256 b) internal pure returns (uint256) {
540         require(b > 0, "SafeMath: division by zero");
541         return a / b;
542     }
543 
544     /**
545      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
546      * reverting when dividing by zero.
547      *
548      * Counterpart to Solidity's `%` operator. This function uses a `revert`
549      * opcode (which leaves remaining gas untouched) while Solidity uses an
550      * invalid opcode to revert (consuming all remaining gas).
551      *
552      * Requirements:
553      *
554      * - The divisor cannot be zero.
555      */
556     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
557         require(b > 0, "SafeMath: modulo by zero");
558         return a % b;
559     }
560 
561     /**
562      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
563      * overflow (when the result is negative).
564      *
565      * CAUTION: This function is deprecated because it requires allocating memory for the error
566      * message unnecessarily. For custom revert reasons use {trySub}.
567      *
568      * Counterpart to Solidity's `-` operator.
569      *
570      * Requirements:
571      *
572      * - Subtraction cannot overflow.
573      */
574     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
575         require(b <= a, errorMessage);
576         return a - b;
577     }
578 
579     /**
580      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
581      * division by zero. The result is rounded towards zero.
582      *
583      * CAUTION: This function is deprecated because it requires allocating memory for the error
584      * message unnecessarily. For custom revert reasons use {tryDiv}.
585      *
586      * Counterpart to Solidity's `/` operator. Note: this function uses a
587      * `revert` opcode (which leaves remaining gas untouched) while Solidity
588      * uses an invalid opcode to revert (consuming all remaining gas).
589      *
590      * Requirements:
591      *
592      * - The divisor cannot be zero.
593      */
594     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
595         require(b > 0, errorMessage);
596         return a / b;
597     }
598 
599     /**
600      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
601      * reverting with custom message when dividing by zero.
602      *
603      * CAUTION: This function is deprecated because it requires allocating memory for the error
604      * message unnecessarily. For custom revert reasons use {tryMod}.
605      *
606      * Counterpart to Solidity's `%` operator. This function uses a `revert`
607      * opcode (which leaves remaining gas untouched) while Solidity uses an
608      * invalid opcode to revert (consuming all remaining gas).
609      *
610      * Requirements:
611      *
612      * - The divisor cannot be zero.
613      */
614     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
615         require(b > 0, errorMessage);
616         return a % b;
617     }
618 }
619 
620 // File: crosslend/data.sol
621 
622 pragma solidity >=0.6.2 <0.8.0;
623 
624 enum FinancialType{CRFI, CFil}
625 
626 struct FinancialPackage {
627   FinancialType Type;
628   
629   uint256 Days;
630   uint256 CFilInterestRate;
631   uint256 CRFIInterestRateDyn;
632   uint256 ID;
633 
634   uint256 Weight;
635   uint256 ParamCRFI;
636   uint256 ParamCFil;
637   uint256 Total;
638 }
639 
640 struct LoanCFilPackage {
641   uint256 APY;
642   uint256 PledgeRate;
643   uint256 PaymentDue;
644   uint256 PaymentDue99;
645 
646   uint256 UpdateTime;
647   uint256 Param;
648 }
649 
650 struct ViewSystemInfo{
651   FinancialPackage[] Packages;
652   uint256 AffRate;
653   uint256 AffRequire;
654   uint256 EnableAffCFil;
655   
656   LoanCFilPackage LoanCFil;
657 
658   ChainManager ChainM;
659 
660   // invest
661   uint256 NewInvestID;
662   mapping(uint256 => InvestInfo) Invests;
663   mapping(address => uint256) InvestAddrID;
664         
665   // setting power
666   address SuperAdmin;
667   mapping(address => bool) Admins;
668 
669   // statistic
670   uint256 nowInvestCRFI;
671   uint256 nowInvestCFil; 
672   uint256 cfilInterestPool;
673   uint256 crfiInterestPool;
674 
675   uint256 cfilLendingTotal;
676   uint256 crfiRewardTotal;
677   uint256 avaiCFilAmount;
678   
679   uint256 totalWeightCFil;
680   uint256 totalWeightCRFI;
681   uint256 crfiMinerPerDayCFil;
682   uint256 crfiMinerPerDayCRFI;
683   
684   uint256 ParamUpdateTime;
685 }
686 
687 struct SystemInfoView {
688   uint256 AffRate;
689   uint256 AffRequire;
690   uint256 EnableAffCFil;
691   
692   // invest
693   uint256 NewInvestID;
694 
695   // statistic
696   uint256 nowInvestCRFI;
697   uint256 nowInvestCFil; 
698   uint256 cfilInterestPool;
699   uint256 crfiInterestPool;
700 
701   uint256 cfilLendingTotal;
702   uint256 crfiRewardTotal;
703   uint256 avaiCFilAmount;
704   
705   uint256 totalWeightCFil;
706   uint256 totalWeightCRFI;
707   uint256 crfiMinerPerDayCFil;
708   uint256 crfiMinerPerDayCRFI;
709   
710   uint256 ParamUpdateTime;
711 }
712 
713 struct SystemInfo {
714 
715   FinancialPackage[] Packages;
716   uint256 AffRate;
717   uint256 AffRequire;
718   uint256 EnableAffCFil;
719   
720   LoanCFilPackage LoanCFil;
721 
722   ChainManager ChainM;
723 
724   // invest
725   uint256 NewInvestID;
726   mapping(uint256 => InvestInfo) Invests;
727   mapping(address => uint256) InvestAddrID;
728         
729   // setting power
730   address SuperAdmin;
731   mapping(address => bool) Admins;
732 
733   // statistic
734   uint256 nowInvestCRFI;
735   uint256 nowInvestCFil; 
736   uint256 cfilInterestPool;
737   uint256 crfiInterestPool;
738 
739   uint256 cfilLendingTotal;
740   uint256 crfiRewardTotal;
741   uint256 avaiCFilAmount;
742   
743   uint256 totalWeightCFil;
744   uint256 totalWeightCRFI;
745   uint256 crfiMinerPerDayCFil;
746   uint256 crfiMinerPerDayCRFI;
747   
748   uint256 ParamUpdateTime;
749 
750   mapping(string => string) kvMap;
751 }
752 
753 struct InterestDetail{
754   uint256 crfiInterest;
755   uint256 cfilInterest;
756 }
757 
758 struct LoanInvest{
759   uint256 Lending;
760   uint256 Pledge;
761   uint256 Param;
762   uint256 NowInterest;
763 }
764 
765 struct InvestInfoView {
766   address Addr;
767   uint256 ID;
768 
769   uint256 affID;
770 
771   // statistic for financial
772   uint256 totalAffTimes;
773   uint256 totalAffPackageTimes;
774   
775   uint256 totalAffCRFI;
776   uint256 totalAffCFil;
777   
778   uint256 nowInvestFinCRFI;
779   uint256 nowInvestFinCFil;
780 }
781 
782 struct InvestInfo {
783   mapping(uint256 => ChainQueue) InvestRecords;
784 
785   address Addr;
786   uint256 ID;
787 
788   uint256 affID;
789 
790   LoanInvest LoanCFil;
791 
792   // statistic for financial
793   uint256 totalAffTimes;
794   uint256 totalAffPackageTimes;
795   
796   uint256 totalAffCRFI;
797   uint256 totalAffCFil;
798   
799   uint256 nowInvestFinCRFI;
800   uint256 nowInvestFinCFil;
801 }
802 
803 
804 //////////////////// queue
805 
806 struct QueueData {
807   uint256 RecordID;
808   
809   FinancialType Type;
810   uint256 PackageID;
811   uint256 Days;
812   uint256 EndTime;
813   uint256 AffID;
814   uint256 Amount;
815 
816   uint256 ParamCRFI;
817   uint256 ParamCFil;
818 }
819 
820 struct ChainItem {
821   uint256 Next;
822   uint256 Prev;
823   uint256 My;
824   
825   QueueData Data;
826 }
827 
828 struct ChainQueue{
829   uint256 First;
830   uint256 End;
831 
832   uint256 Size;
833 }
834 
835 
836 struct ChainManager{
837   ChainItem[] rawQueue;
838 
839   ChainQueue avaiQueue;
840 }
841 
842 library ChainQueueLib{
843 
844   //////////////////// item
845   function GetNullItem(ChainManager storage chainM)
846     internal
847     view
848     returns(ChainItem storage item){
849     return chainM.rawQueue[0];
850   }
851 
852   function HasNext(ChainManager storage chainM,
853                    ChainItem storage item)
854     internal
855     view
856     returns(bool has){
857 
858     if(item.Next == 0){
859       return false;
860     }
861 
862     return true;
863   }
864 
865   function Next(ChainManager storage chainM,
866                 ChainItem storage item)
867     internal
868     view
869     returns(ChainItem storage nextItem){
870 
871     uint256 nextIdx = item.Next;
872     require(nextIdx > 0, "no next item");
873 
874     return chainM.rawQueue[uint256(nextIdx)];
875   }
876 
877   //////////////////// chain
878   function GetFirstItem(ChainManager storage chainM,
879                         ChainQueue storage chain)
880     internal
881     view
882     returns(ChainItem storage item){
883 
884     require(chain.Size > 0, "chain is empty");
885 
886     return chainM.rawQueue[chain.First];
887   }
888 
889   function GetEndItem(ChainManager storage chainM,
890                       ChainQueue storage chain)
891     internal
892     view
893     returns(ChainItem storage item){
894 
895     require(chain.Size > 0, "chain is empty");
896 
897     return chainM.rawQueue[chain.End];
898   }
899 
900   // need ensure the item is in chain
901   function DeleteItem(ChainManager storage chainM,
902                       ChainQueue storage chain,
903                       ChainItem storage item)
904     internal{
905 
906     if(chain.First == item.My){
907       PopPutFirst(chainM, chain);
908       return;
909     } else if (chain.End == item.My){
910       PopPutEnd(chainM, chain);
911       return;
912     }
913 
914     ChainItem storage next = chainM.rawQueue[item.Next];
915     ChainItem storage prev = chainM.rawQueue[item.Prev];
916 
917     next.Prev = item.Prev;
918     prev.Next = item.Next;
919 
920     item.Prev = 0;
921     item.Next = 0;
922 
923     chain.Size--;
924 
925     PutItem(chainM, item);
926   }
927 
928   function PopPutFirst(ChainManager storage chainM,
929                        ChainQueue storage chain)
930     internal{
931 
932     ChainItem storage item = PopFirstItem(chainM, chain);
933     PutItem(chainM, item);
934   }
935 
936   function PopPutEnd(ChainManager storage chainM,
937                      ChainQueue storage chain)
938     internal{
939 
940     ChainItem storage item = PopEndItem(chainM, chain);
941     PutItem(chainM, item);
942   }
943 
944   function PopEndItem(ChainManager storage chainM,
945                         ChainQueue storage chain)
946     internal
947     returns(ChainItem storage item){
948     
949     require(chain.Size >0, "chain is empty");
950     
951     uint256 itemIdx = chain.End;
952     chain.End = chainM.rawQueue[itemIdx].Prev;
953     if(chain.End > 0){
954       chainM.rawQueue[chain.End].Next = 0;
955     } else {
956       chain.First = 0;
957     }
958     chain.Size--;
959     item = chainM.rawQueue[itemIdx];
960     item.Prev = 0;
961     return item;
962   }
963 
964   function PopFirstItem(ChainManager storage chainM,
965                         ChainQueue storage chain)
966     internal
967     returns(ChainItem storage item){
968 
969     require(chain.Size > 0, "chain is empty");
970 
971     uint256 itemIdx = chain.First;
972     chain.First = chainM.rawQueue[itemIdx].Next;
973     if(chain.First > 0){
974       chainM.rawQueue[chain.First].Prev = 0;
975     } else {
976       chain.End = 0;
977     }
978     chain.Size--;
979 
980     item = chainM.rawQueue[itemIdx];
981     item.Next = 0;
982 
983     return item;
984   }
985 
986   function PushEndItem(ChainManager storage chainM,
987                        ChainQueue storage chain,
988                        ChainItem storage item)
989     internal{
990 
991     item.Prev = chain.End;
992     item.Next = 0;
993 
994     if(chain.Size == 0){
995       chain.First = item.My;
996       chain.End = item.My;
997     } else {
998       chainM.rawQueue[chain.End].Next = item.My;
999       chain.End = item.My;
1000     }
1001     chain.Size++;
1002   }
1003 
1004   //////////////////// chain manager
1005   function InitChainManager(ChainManager storage chainM)
1006     internal{
1007     if(chainM.rawQueue.length == 0){
1008       chainM.rawQueue.push();
1009     }
1010   }
1011   
1012   function GetAvaiItem(ChainManager storage chainM)
1013     internal
1014     returns(ChainItem storage item){
1015     
1016     if(chainM.avaiQueue.Size == 0){
1017       if(chainM.rawQueue.length == 0){
1018         chainM.rawQueue.push();
1019       }
1020       
1021       uint256 itemIdx = chainM.rawQueue.length;
1022       chainM.rawQueue.push();
1023 
1024       item = chainM.rawQueue[itemIdx];
1025       item.Next = 0;
1026       item.Prev = 0;
1027       item.My = itemIdx;
1028       
1029       return item;
1030     }
1031 
1032     return PopFirstItem(chainM, chainM.avaiQueue);
1033   }
1034 
1035   function PutItem(ChainManager storage chainM,
1036                    ChainItem storage item)
1037     internal{
1038     
1039     PushEndItem(chainM, chainM.avaiQueue, item);
1040   }
1041 }
1042 
1043 // File: crosslend/main.sol
1044 
1045 pragma solidity >=0.7.0 <0.8.0;
1046 pragma abicoder v2;
1047 
1048 
1049 
1050 
1051 
1052 
1053 
1054 contract CrossLend is IERC777Recipient, ReentrancyGuard{
1055   //////////////////// for using
1056   using ChainQueueLib for ChainManager;
1057   using SafeMath for uint256;
1058 
1059   //////////////////// constant
1060   IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
1061 
1062   bytes32 private constant _TOKENS_RECIPIENT_INTERFACE_HASH = keccak256("ERC777TokensRecipient");
1063 
1064   uint256 constant Decimal = 1e18;
1065 
1066   uint256 public OneDayTime;
1067 
1068   //////////////////// var
1069   SystemInfo internal SInfo;
1070   
1071   IERC777 public CRFI;
1072   IERC777 public CFil;
1073   IERC777 public SFil;
1074 
1075   //////////////////// modifier
1076   modifier IsAdmin() {
1077     require(msg.sender == SInfo.SuperAdmin || SInfo.Admins[msg.sender], "only admin");
1078     _;
1079   }
1080 
1081   modifier IsSuperAdmin() {
1082     require(SInfo.SuperAdmin == msg.sender, "only super admin");
1083     _;
1084   }
1085 
1086   //////////////////// event
1087   event AffEvent(address indexed receiver, address indexed sender, uint256 indexed affTimes, uint256 crfiInterest, uint256 cfilInterest, uint256 packageID, uint256 timestamp);
1088 
1089   event AffBought(address indexed affer, address indexed sender, uint256 indexed affPackageTimes, uint256 amount, uint256 packageID, uint256 timestamp);
1090   
1091   event loanCFilEvent(address indexed addr, uint256 cfilAmount, uint256 sfilAmount);
1092 
1093   //////////////////// constructor
1094   constructor(address crfiAddr, address cfilAddr, address sfilAddr) {
1095     CRFI = IERC777(crfiAddr);
1096     CFil = IERC777(cfilAddr);
1097     SFil = IERC777(sfilAddr);
1098     OneDayTime = 60 * 60 * 24;
1099 
1100     SInfo.SuperAdmin = msg.sender;
1101 
1102     SInfo.AffRate = Decimal / 10;
1103     SInfo.EnableAffCFil = 1;
1104 
1105     SInfo.ChainM.InitChainManager();
1106     
1107     ////////// add package
1108 
1109     SInfo.crfiMinerPerDayCFil = 1917808 * Decimal / 100;
1110     SInfo.crfiMinerPerDayCRFI = 821918 * Decimal / 100;
1111 
1112     SInfo.ParamUpdateTime = block.timestamp;
1113     
1114     // loan CFil
1115     ChangeLoanRate(201 * Decimal / 1000,
1116                    56 * Decimal / 100,
1117                    2300 * Decimal);
1118     SInfo.LoanCFil.UpdateTime = block.timestamp;
1119 
1120     // add crfi
1121     AddPackage(FinancialType.CRFI,
1122                0,
1123                (20 * Decimal) / 1000,
1124                Decimal);
1125     
1126     AddPackage(FinancialType.CRFI,
1127                90,
1128                (32 * Decimal) / 1000,
1129                (15 * Decimal) / 10);
1130 
1131     AddPackage(FinancialType.CRFI,
1132                180,
1133                (34 * Decimal) / 1000,
1134                2 * Decimal);
1135 
1136     AddPackage(FinancialType.CRFI,
1137                365,
1138                (36 * Decimal) / 1000,
1139                (25 * Decimal) / 10);
1140                    
1141     AddPackage(FinancialType.CRFI,
1142                540,
1143                (40 * Decimal) / 1000,
1144                3 * Decimal);
1145     
1146     // add cfil
1147     AddPackage(FinancialType.CFil,
1148                0,
1149                (20 * Decimal) / 1000,
1150                Decimal);
1151     
1152     AddPackage(FinancialType.CFil,
1153                90,
1154                (33 * Decimal) / 1000,
1155                (15 * Decimal) / 10);
1156 
1157     AddPackage(FinancialType.CFil,
1158                180, 
1159                (35 * Decimal) / 1000,
1160                2 * Decimal);
1161 
1162     AddPackage(FinancialType.CFil,
1163                365,
1164                (37 * Decimal) / 1000,
1165                (25 * Decimal) / 10);
1166                    
1167     AddPackage(FinancialType.CFil,
1168                540,
1169                (41 * Decimal) / 1000,
1170                3 * Decimal);
1171     
1172     // register interfaces
1173     _ERC1820_REGISTRY.setInterfaceImplementer(address(this), _TOKENS_RECIPIENT_INTERFACE_HASH, address(this));
1174   }
1175   
1176   //////////////////// super admin func
1177   function AddAdmin(address admin)
1178     public
1179     IsSuperAdmin(){
1180     require(!SInfo.Admins[admin], "already add this admin");
1181     SInfo.Admins[admin] = true;
1182   }
1183 
1184   function DelAdmin(address admin)
1185     public
1186     IsSuperAdmin(){
1187     require(SInfo.Admins[admin], "this addr is not admin");
1188     SInfo.Admins[admin] = false;
1189   }
1190 
1191   function ChangeSuperAdmin(address suAdmin)
1192     public
1193     IsSuperAdmin(){
1194     require(suAdmin != address(0x0), "empty new super admin");
1195 
1196     if(suAdmin == SInfo.SuperAdmin){
1197       return;
1198     }
1199     
1200     SInfo.SuperAdmin = suAdmin;
1201   }
1202 
1203   //////////////////// admin func
1204   function SetMap(string memory key,
1205                   string memory value)
1206     public
1207     IsAdmin(){
1208 
1209     SInfo.kvMap[key] = value;
1210   }
1211   
1212   function ChangePackageRate(uint256 packageID,
1213                              uint256 cfilInterestRate,
1214                              uint256 weight)
1215     public
1216     IsAdmin(){
1217     
1218     require(packageID < SInfo.Packages.length, "packageID error");
1219 
1220     updateAllParam();
1221     
1222     FinancialPackage storage package = SInfo.Packages[packageID];
1223     package.CFilInterestRate = cfilInterestRate;
1224 
1225     uint256 nowTotal = package.Total.mul(package.Weight) / Decimal;
1226     if(package.Type == FinancialType.CRFI){
1227       SInfo.totalWeightCRFI = SInfo.totalWeightCRFI.sub(nowTotal);
1228     } else {
1229       SInfo.totalWeightCFil = SInfo.totalWeightCFil.sub(nowTotal);
1230     }
1231 
1232     package.Weight = weight;
1233 
1234     nowTotal = package.Total.mul(package.Weight) / Decimal;
1235     if(package.Type == FinancialType.CRFI){
1236       SInfo.totalWeightCRFI = SInfo.totalWeightCRFI.add(nowTotal);
1237     } else {
1238       SInfo.totalWeightCFil = SInfo.totalWeightCFil.add(nowTotal);
1239     }
1240   }
1241 
1242   function AddPackage(FinancialType _type,
1243                       uint256 dayTimes,
1244                       uint256 cfilInterestRate,
1245                       uint256 weight)
1246     public
1247     IsAdmin(){
1248 
1249     updateAllParam();
1250     
1251     uint256 idx = SInfo.Packages.length;
1252     SInfo.Packages.push();
1253     FinancialPackage storage package = SInfo.Packages[idx];
1254 
1255     package.Type = _type;
1256     package.Days = dayTimes;
1257     package.Weight = weight;
1258     package.CFilInterestRate = cfilInterestRate;
1259     package.ID = idx;
1260   }
1261 
1262   function ChangeCRFIMinerPerDay(uint256 crfi, uint256 cfil)
1263     public
1264     IsAdmin(){
1265 
1266     updateAllParam();
1267 
1268     SInfo.crfiMinerPerDayCFil = cfil;
1269     SInfo.crfiMinerPerDayCRFI = crfi;
1270   }
1271 
1272   function ChangeLoanRate(uint256 apy, uint256 pledgeRate, uint256 paymentDue)
1273     public
1274     IsAdmin(){
1275 
1276     require(pledgeRate > 0, "pledge rate can't = 0");
1277 
1278     SInfo.LoanCFil.APY = apy;
1279     SInfo.LoanCFil.PledgeRate = pledgeRate;
1280     SInfo.LoanCFil.PaymentDue = paymentDue;
1281     SInfo.LoanCFil.PaymentDue99 = paymentDue.mul(99) / 100;
1282   }
1283 
1284   function ChangeAffCFil(bool enable)
1285     public
1286     IsAdmin(){
1287     if(enable && SInfo.EnableAffCFil == 0){
1288       SInfo.EnableAffCFil = 1;
1289     } else if(!enable && SInfo.EnableAffCFil > 0){
1290       SInfo.EnableAffCFil = 0;
1291     }
1292   }
1293 
1294   function ChangeAffRate(uint256 rate)
1295     public
1296     IsAdmin(){
1297     
1298     SInfo.AffRate = rate;
1299   }
1300 
1301   function ChangeAffRequire(uint256 amount)
1302     public
1303     IsAdmin(){
1304     SInfo.AffRequire = amount;
1305   }
1306 
1307   function WithdrawCRFIInterestPool(uint256 amount)
1308     public
1309     IsAdmin(){
1310     SInfo.crfiInterestPool = SInfo.crfiInterestPool.sub(amount);
1311     CRFI.send(msg.sender, amount, "");
1312   }
1313 
1314   function WithdrawCFilInterestPool(uint256 amount)
1315     public
1316     IsAdmin(){
1317     SInfo.cfilInterestPool = SInfo.cfilInterestPool.sub(amount);
1318     CFil.send(msg.sender, amount, "");
1319   }
1320   
1321   //////////////////// public
1322   function tokensReceived(
1323         address operator,
1324         address from,
1325         address to,
1326         uint256 amount,
1327         bytes calldata userData,
1328         bytes calldata operatorData)
1329     public
1330     override
1331     nonReentrant(){
1332 
1333     ////////// check
1334     require(userData.length > 0, "no user data");
1335     
1336     // mode = 0, normal bought financial package
1337     // mode = 2, charge cfil interest pool
1338     // mode = 3, charge crfi interest pool
1339     // mode = 4, loan cfil
1340     // mode = 5, repay cfil by loan
1341     (uint256 mode, uint256 param, address addr) = abi.decode(userData, (uint256,uint256, address));
1342     require(from != address(0x0), "from is zero");
1343 
1344     if(mode == 5){
1345       _repayLoanCFil(from, amount);
1346     }else if(mode == 4){
1347       _loanCFil(from, amount);
1348     }else if(mode == 3){
1349       require(amount > 0, "no amount");
1350       require(msg.sender == address(CRFI), "only charge crfi");
1351       SInfo.crfiInterestPool = SInfo.crfiInterestPool.add(amount);
1352       return;
1353     }else if(mode == 2){
1354       require(amount > 0, "no amount");
1355       require(msg.sender == address(CFil), "only charge cfil");
1356       SInfo.cfilInterestPool = SInfo.cfilInterestPool.add(amount);
1357       
1358       return;
1359     } else if (mode == 0){
1360       _buyFinancialPackage(from, param, addr, amount);
1361     } else {
1362       revert("mode error");
1363     }
1364   }
1365   
1366   function Withdraw(uint256 packageID, bool only, uint256 maxNum)
1367     public
1368     nonReentrant(){
1369 
1370     InvestInfo storage uInfo = SInfo.Invests[getUID(msg.sender)];
1371     
1372     uint256 cfil;
1373     uint256 cfilInterest;
1374     uint256 crfi;
1375     uint256 crfiInterest;
1376 
1377     (crfi, crfiInterest, cfil, cfilInterest) = _withdrawFinancial(uInfo, packageID, only, maxNum);
1378 
1379     if(crfi > 0){
1380       uInfo.nowInvestFinCRFI = uInfo.nowInvestFinCRFI.sub(crfi);
1381     }
1382     if(cfil > 0){
1383       uInfo.nowInvestFinCFil = uInfo.nowInvestFinCFil.sub(cfil);
1384     }
1385 
1386     withdrawCoin(uInfo.Addr, crfi, crfiInterest, cfil, cfilInterest);
1387   }
1388 
1389   //////////////////// view func
1390 
1391   function GetMap(string memory key)
1392     public
1393     view
1394     returns(string memory value){
1395 
1396     return SInfo.kvMap[key];
1397   }
1398 
1399   function GetFinancialPackage()
1400     public
1401     view
1402     returns(FinancialPackage[] memory packages){
1403 
1404     packages = new FinancialPackage[](SInfo.Packages.length);
1405     for(uint256 packageID = 0; packageID < SInfo.Packages.length; packageID++){
1406       packages[packageID] = SInfo.Packages[packageID];
1407       packages[packageID].CRFIInterestRateDyn = getFinancialCRFIRate(SInfo.Packages[packageID]);
1408     }
1409     
1410     return packages;
1411   }
1412 
1413   function GetInvesterFinRecords(address addr)
1414     public
1415     view
1416     returns(QueueData[] memory records){
1417 
1418     uint256 uid = SInfo.InvestAddrID[addr];
1419     if(uid == 0){
1420       return records;
1421     }
1422 
1423     InvestInfo storage uInfo = SInfo.Invests[uid];
1424 
1425     uint256 recordSize = 0;
1426 
1427     for(uint256 packageID = 0; packageID < SInfo.Packages.length; packageID++){
1428       ChainQueue storage chain = uInfo.InvestRecords[packageID];
1429       recordSize = recordSize.add(chain.Size);
1430     }
1431 
1432     records = new QueueData[](recordSize);
1433     uint256 id = 0;
1434     
1435     for(uint256 packageID = 0; packageID < SInfo.Packages.length; packageID++){
1436       ChainQueue storage chain = uInfo.InvestRecords[packageID];
1437       if(chain.Size == 0){
1438         continue;
1439       }
1440 
1441       ChainItem storage item = SInfo.ChainM.GetFirstItem(chain);
1442       for(;;){
1443         records[id] = item.Data;
1444         id++;
1445 
1446         if(!SInfo.ChainM.HasNext(item)){
1447           break;
1448         }
1449 
1450         item = SInfo.ChainM.Next(item);
1451       }
1452     }
1453     
1454     return records;
1455   }
1456 
1457 
1458   function GetSystemInfo()
1459     public
1460     view
1461     returns(SystemInfoView memory sInfoView){
1462 
1463     sInfoView.AffRate = SInfo.AffRate;
1464     sInfoView.AffRequire = SInfo.AffRequire;
1465     sInfoView.EnableAffCFil = SInfo.EnableAffCFil;
1466     sInfoView.NewInvestID = SInfo.NewInvestID;
1467     sInfoView.nowInvestCRFI = SInfo.nowInvestCRFI;
1468     sInfoView.nowInvestCFil = SInfo.nowInvestCFil;
1469     sInfoView.cfilInterestPool = SInfo.cfilInterestPool;
1470     sInfoView.crfiInterestPool = SInfo.crfiInterestPool;
1471 
1472     sInfoView.cfilLendingTotal = SInfo.cfilLendingTotal;
1473     sInfoView.crfiRewardTotal = SInfo.crfiRewardTotal;
1474     sInfoView.avaiCFilAmount = SInfo.avaiCFilAmount;
1475   
1476     sInfoView.totalWeightCFil = SInfo.totalWeightCFil;
1477     sInfoView.totalWeightCRFI = SInfo.totalWeightCRFI;
1478     sInfoView.crfiMinerPerDayCFil = SInfo.crfiMinerPerDayCFil;
1479     sInfoView.crfiMinerPerDayCRFI = SInfo.crfiMinerPerDayCRFI;
1480   
1481     sInfoView.ParamUpdateTime = SInfo.ParamUpdateTime;
1482 
1483     return sInfoView;
1484   }
1485 
1486   function GetPackages()
1487     public
1488     view
1489     returns(FinancialPackage[] memory financialPackages,
1490             LoanCFilPackage memory loanCFil){
1491 
1492     return (GetFinancialPackage(),
1493             SInfo.LoanCFil);
1494   }
1495 
1496 
1497   function GetInvestRecords(address addr)
1498     public
1499     view
1500     returns(QueueData[] memory records,
1501             LoanInvest memory loanInvest,
1502             InterestDetail[] memory interestDetail){
1503 
1504     uint256 uid = SInfo.InvestAddrID[addr];
1505     if(uid == 0){
1506       return (records, loanInvest, interestDetail);
1507     }
1508 
1509     InvestInfo storage uInfo = SInfo.Invests[uid];
1510 
1511     records = GetInvesterFinRecords(addr);
1512     interestDetail = new InterestDetail[](records.length+1);
1513 
1514     uint256 id = 0;
1515     for(; id < records.length; id++){
1516       (interestDetail[id].crfiInterest, interestDetail[id].cfilInterest) = _calcInvestFinancial(records[id].PackageID, records[id].Amount, records[id].ParamCRFI, records[id].ParamCFil);
1517     }
1518 
1519     interestDetail[id].cfilInterest = calcInvestLoanStatus(uInfo);
1520     interestDetail[id].cfilInterest = interestDetail[id].cfilInterest.add(uInfo.LoanCFil.NowInterest);
1521 
1522     return(records,
1523            uInfo.LoanCFil,
1524            interestDetail);
1525   }
1526 
1527   function GetInvestInfo(uint256 uid, address addr)
1528     public
1529     view
1530     returns(bool admin,
1531             InvestInfoView memory uInfoView){
1532     if(uid == 0){
1533       uid = SInfo.InvestAddrID[addr];
1534     }
1535 
1536     if(uid == 0){
1537       if(addr != address(0x0)){
1538         admin = (SInfo.SuperAdmin == addr) || (SInfo.Admins[addr]);
1539       }
1540       return (admin,
1541               uInfoView);
1542     }
1543     
1544     InvestInfo storage uInfo = SInfo.Invests[uid];
1545 
1546     admin = (SInfo.SuperAdmin == uInfo.Addr) || (SInfo.Admins[uInfo.Addr]);
1547 
1548     uInfoView.Addr = uInfo.Addr;
1549     uInfoView.ID = uInfo.ID;
1550     uInfoView.affID = uInfo.affID;
1551     uInfoView.totalAffTimes = uInfo.totalAffTimes;
1552     uInfoView.totalAffPackageTimes = uInfo.totalAffPackageTimes;
1553     uInfoView.totalAffCRFI = uInfo.totalAffCRFI;
1554     uInfoView.totalAffCFil = uInfo.totalAffCFil;
1555     uInfoView.nowInvestFinCRFI = uInfo.nowInvestFinCRFI;
1556     uInfoView.nowInvestFinCFil = uInfo.nowInvestFinCFil;
1557 
1558     return (admin,
1559             uInfoView);
1560   }
1561 
1562   function calcSFilToCFil(uint256 sfil)
1563     public
1564     view
1565     returns(uint256 cfil){
1566     cfil = sfil.mul(SInfo.LoanCFil.PledgeRate) / Decimal;
1567     return cfil;
1568   }
1569 
1570   function calcCFilToSFil(uint256 cfil)
1571     public
1572     view
1573     returns(uint256 sfil){
1574 
1575     sfil = cfil.mul(Decimal) / SInfo.LoanCFil.PledgeRate;
1576     return sfil;
1577   }
1578   
1579   //////////////////// for debug
1580 
1581   function getChainMDetail()
1582     public
1583     view
1584     returns(ChainManager memory chaimM){
1585 
1586     return SInfo.ChainM;
1587   }
1588 
1589   function getInvestChainDetail(uint256 id)
1590     public
1591     view
1592     returns(ChainQueue[] memory chains){
1593 
1594     InvestInfo storage uInfo = SInfo.Invests[id];
1595 
1596     chains = new ChainQueue[](SInfo.Packages.length);
1597 
1598     for(uint256 packageID = 0; packageID < SInfo.Packages.length; packageID++){
1599       chains[packageID] = uInfo.InvestRecords[packageID];
1600     }
1601 
1602     return chains;
1603   }
1604   
1605   //////////////////// internal func
1606   function _repayLoanCFil(address from,
1607                           uint256 cfilAmount)
1608     internal{
1609     require(cfilAmount > 0, "no cfil amount");
1610     require(msg.sender == address(CFil), "not cfil coin type");
1611 
1612     InvestInfo storage uInfo = SInfo.Invests[getUID(from)];
1613     updateInvesterLoanCFil(uInfo);
1614 
1615     // deal interest
1616     uint256 repayInterest = cfilAmount;
1617     if(uInfo.LoanCFil.NowInterest < cfilAmount){
1618       repayInterest = uInfo.LoanCFil.NowInterest;
1619     }
1620 
1621     uInfo.LoanCFil.NowInterest = uInfo.LoanCFil.NowInterest.sub(repayInterest);
1622     SInfo.cfilInterestPool = SInfo.cfilInterestPool.add(repayInterest);
1623     cfilAmount = cfilAmount.sub(repayInterest);
1624 
1625     // deal lending
1626     if(cfilAmount == 0){
1627       return;
1628     }
1629 
1630     uint256 repayLending = cfilAmount;
1631     if(uInfo.LoanCFil.Lending < cfilAmount){
1632       repayLending = uInfo.LoanCFil.Lending;
1633     }
1634 
1635     uint256 pledge = repayLending.mul(uInfo.LoanCFil.Pledge) / uInfo.LoanCFil.Lending;
1636     uInfo.LoanCFil.Lending = uInfo.LoanCFil.Lending.sub(repayLending);
1637     uInfo.LoanCFil.Pledge = uInfo.LoanCFil.Pledge.sub(pledge);
1638     SInfo.cfilLendingTotal = SInfo.cfilLendingTotal.sub(repayLending);
1639     SInfo.avaiCFilAmount = SInfo.avaiCFilAmount.add(repayLending);
1640     cfilAmount = cfilAmount.sub(repayLending);
1641 
1642     if(pledge > 0){
1643       SFil.send(from, pledge, "");
1644     }
1645     
1646     if(cfilAmount > 0){
1647       CFil.send(from, cfilAmount, "");
1648     }
1649   }
1650   
1651   function _loanCFil(address from,
1652                      uint256 sfilAmount)
1653     internal{
1654 
1655     require(sfilAmount > 0, "no sfil amount");
1656     require(msg.sender == address(SFil), "not sfil coin type");
1657 
1658     uint256 cfilAmount = calcSFilToCFil(sfilAmount);
1659     require(cfilAmount <= SInfo.avaiCFilAmount, "not enough cfil to loan");
1660     require(cfilAmount >= SInfo.LoanCFil.PaymentDue99, "cfil amount is too small");
1661 
1662     InvestInfo storage uInfo = SInfo.Invests[getUID(from)];
1663     updateInvesterLoanCFil(uInfo);
1664     
1665     if(uInfo.LoanCFil.Param < SInfo.LoanCFil.Param){
1666       uInfo.LoanCFil.Param = SInfo.LoanCFil.Param;
1667     }
1668     uInfo.LoanCFil.Lending = uInfo.LoanCFil.Lending.add(cfilAmount);
1669     uInfo.LoanCFil.Pledge = uInfo.LoanCFil.Pledge.add(sfilAmount);
1670 
1671     SInfo.cfilLendingTotal = SInfo.cfilLendingTotal.add(cfilAmount);
1672     SInfo.avaiCFilAmount = SInfo.avaiCFilAmount.sub(cfilAmount);
1673 
1674     CFil.send(from, cfilAmount, "");
1675     emit loanCFilEvent(from, cfilAmount, sfilAmount);
1676   }
1677   
1678   function _buyFinancialPackage(address from,
1679                                 uint256 packageID,
1680                                 address affAddr,
1681                                 uint256 amount)
1682     internal{
1683     // check
1684     require(amount > 0, "no amount");
1685     require(packageID < SInfo.Packages.length, "invalid packageID");
1686     FinancialPackage storage package = SInfo.Packages[packageID];
1687     if(package.Type == FinancialType.CRFI){
1688       require(msg.sender == address(CRFI), "not CRFI coin type");
1689     }else if(package.Type == FinancialType.CFil){
1690       require(msg.sender == address(CFil), "not CFil coin type");
1691     } else {
1692       revert("not avai package type");
1693     }
1694 
1695     updateAllParam();
1696     
1697     // exec
1698     InvestInfo storage uInfo = SInfo.Invests[getUID(from)];    
1699 
1700     uint256 affID = uInfo.affID;
1701 
1702     if(affID == 0 && affAddr != from && affAddr != address(0x0)){
1703       uInfo.affID = getUID(affAddr);
1704       affID = uInfo.affID;
1705     }
1706 
1707     if(package.Days == 0){
1708       affID = 0;
1709     }
1710 
1711     if(affID != 0){
1712       InvestInfo storage affInfo = SInfo.Invests[affID];
1713       affInfo.totalAffPackageTimes++;      
1714       emit AffBought(affAddr, from, affInfo.totalAffPackageTimes, amount, packageID, block.timestamp); 
1715     }
1716 
1717     ChainQueue storage recordQ = uInfo.InvestRecords[package.ID];
1718 
1719     ChainItem storage item = SInfo.ChainM.GetAvaiItem();
1720 
1721     item.Data.Type = package.Type;
1722     item.Data.PackageID = package.ID;
1723     item.Data.Days = package.Days;
1724     item.Data.EndTime = block.timestamp.add(package.Days.mul(OneDayTime));
1725     item.Data.AffID = affID;
1726     item.Data.Amount = amount;
1727     item.Data.ParamCRFI = package.ParamCRFI;
1728     item.Data.ParamCFil = package.ParamCFil;
1729 
1730     SInfo.ChainM.PushEndItem(recordQ, item);
1731 
1732     ////////// for statistic
1733     package.Total = package.Total.add(amount);
1734     if(package.Type == FinancialType.CRFI){
1735       uInfo.nowInvestFinCRFI = uInfo.nowInvestFinCRFI.add(amount);
1736       SInfo.nowInvestCRFI = SInfo.nowInvestCRFI.add(amount);
1737       SInfo.totalWeightCRFI = SInfo.totalWeightCRFI.add(amount.mul(package.Weight) / Decimal);
1738     } else if(package.Type == FinancialType.CFil){
1739       uInfo.nowInvestFinCFil = uInfo.nowInvestFinCFil.add(amount);
1740       SInfo.nowInvestCFil = SInfo.nowInvestCFil.add(amount);
1741       SInfo.avaiCFilAmount = SInfo.avaiCFilAmount.add(amount);
1742       SInfo.totalWeightCFil = SInfo.totalWeightCFil.add(amount.mul(package.Weight) / Decimal);
1743     }
1744   }
1745 
1746   function _withdrawFinancial(InvestInfo storage uInfo, uint256 onlyPackageID, bool only, uint256 maxNum)
1747     internal
1748     returns(uint256 crfi,
1749             uint256 crfiInterest,
1750             uint256 cfil,
1751             uint256 cfilInterest){
1752 
1753     updateAllParam();
1754 
1755     if(!only){
1756       onlyPackageID = 0;
1757     }
1758 
1759     if(maxNum == 0){
1760       maxNum -= 1;
1761     }
1762     
1763     (uint256 packageID, ChainItem storage item, bool has) = getFirstValidItem(uInfo, onlyPackageID);
1764     
1765     while(has && maxNum > 0 && (!only || packageID == onlyPackageID)){
1766       maxNum--;
1767       QueueData storage data = item.Data;
1768       FinancialPackage storage package = SInfo.Packages[data.PackageID];
1769 
1770       (uint256 _crfiInterest, uint256 _cfilInterest) = calcInvestFinancial(data);
1771       crfiInterest = crfiInterest.add(_crfiInterest);
1772       cfilInterest = cfilInterest.add(_cfilInterest);
1773 
1774       addAffCRFI(uInfo, data, _crfiInterest, _cfilInterest);
1775 
1776       if((block.timestamp > data.EndTime && data.Days > 0) || (data.Days ==0 && only)){
1777         package.Total = package.Total.sub(data.Amount);
1778         if(data.Type == FinancialType.CFil){
1779           cfil = cfil.add(data.Amount);
1780           SInfo.totalWeightCFil = SInfo.totalWeightCFil.sub(data.Amount.mul(package.Weight) / Decimal);
1781         } else {
1782           crfi = crfi.add(data.Amount);
1783           SInfo.totalWeightCRFI = SInfo.totalWeightCRFI.sub(data.Amount.mul(package.Weight) / Decimal);
1784         }
1785         SInfo.ChainM.PopPutFirst(uInfo.InvestRecords[packageID]);
1786         (packageID, item, has) = getFirstValidItem(uInfo, packageID);
1787       } else {
1788         data.ParamCRFI = package.ParamCRFI;
1789         data.ParamCFil = package.ParamCFil;
1790         (packageID, item, has) = getNextItem(uInfo, packageID, item);
1791       }
1792     }
1793 
1794     return (crfi, crfiInterest, cfil, cfilInterest);
1795   }
1796         
1797   function getUID(address addr) internal returns(uint256 uID){
1798     uID = SInfo.InvestAddrID[addr];
1799     if(uID != 0){
1800       return uID;
1801     }
1802     
1803     SInfo.NewInvestID++;
1804     uID = SInfo.NewInvestID;
1805 
1806     InvestInfo storage uInfo = SInfo.Invests[uID];
1807     uInfo.Addr = addr;
1808     uInfo.ID = uID;
1809         
1810     SInfo.InvestAddrID[addr] = uID;
1811     return uID;
1812   }
1813 
1814   function calcSystemLoanStatus()
1815     internal
1816     view
1817     returns(uint256 param){
1818 
1819     if(block.timestamp == SInfo.LoanCFil.UpdateTime){
1820       return SInfo.LoanCFil.Param;
1821     }
1822 
1823     uint256 diffSec = block.timestamp.sub(SInfo.LoanCFil.UpdateTime);
1824 
1825     param = SInfo.LoanCFil.Param.add(calcInterest(Decimal, SInfo.LoanCFil.APY, diffSec));
1826 
1827     return param;
1828   }
1829 
1830   function calcInvestLoanStatus(InvestInfo storage uInfo)
1831     internal
1832     view
1833     returns(uint256 cfilInterest){
1834 
1835     if(uInfo.LoanCFil.Lending == 0){
1836       return 0;
1837     }
1838     
1839     uint256 param = calcSystemLoanStatus();
1840     if(uInfo.LoanCFil.Param >= param){
1841       return 0;
1842     }
1843     
1844     cfilInterest = uInfo.LoanCFil.Lending.mul(param.sub(uInfo.LoanCFil.Param)) / Decimal;
1845     
1846     return cfilInterest;
1847   }
1848 
1849   function updateSystemLoanStatus()
1850     internal{
1851     uint256 param;
1852     param = calcSystemLoanStatus();
1853     if(param <= SInfo.LoanCFil.Param){
1854       return;
1855     }
1856 
1857     SInfo.LoanCFil.Param = param;
1858     SInfo.LoanCFil.UpdateTime = block.timestamp;
1859   }
1860 
1861   function updateInvesterLoanCFil(InvestInfo storage uInfo)
1862     internal{
1863     updateSystemLoanStatus();
1864     uint256 cfilInterest = calcInvestLoanStatus(uInfo);
1865     if(cfilInterest == 0){
1866       return;
1867     }
1868 
1869     uInfo.LoanCFil.Param = SInfo.LoanCFil.Param;
1870     uInfo.LoanCFil.NowInterest = uInfo.LoanCFil.NowInterest.add(cfilInterest);
1871   }
1872 
1873   function calcInterest(uint256 amount, uint256 rate, uint256 sec)
1874     internal
1875     view
1876     returns(uint256){
1877     
1878     return amount.mul(rate).mul(sec) / 365 / OneDayTime / Decimal;    
1879   }
1880 
1881   function getFirstValidItem(InvestInfo storage uInfo, uint256 packageID)
1882     internal
1883     view
1884     returns(uint256 newPackageID, ChainItem storage item, bool has){
1885     
1886     while(packageID < SInfo.Packages.length){
1887       ChainQueue storage chain = uInfo.InvestRecords[packageID];
1888       if(chain.Size == 0){
1889         packageID++;
1890         continue;
1891       }
1892       item = SInfo.ChainM.GetFirstItem(chain);
1893       return (packageID, item, true);
1894     }
1895 
1896     return (0, SInfo.ChainM.GetNullItem(), false);
1897   }
1898 
1899   function getNextItem(InvestInfo storage uInfo,
1900                        uint256 packageID,
1901                        ChainItem storage item)
1902     internal
1903     view
1904     returns(uint256, ChainItem storage, bool){
1905 
1906     if(packageID >= SInfo.Packages.length){
1907       return (0, item, false);
1908     }
1909 
1910     if(SInfo.ChainM.HasNext(item)){
1911       return (packageID, SInfo.ChainM.Next(item), true);
1912     }
1913 
1914     return getFirstValidItem(uInfo, packageID+1);
1915   }
1916 
1917   function addAffCRFI(InvestInfo storage uInfo, QueueData storage data, uint256 crfiInterest, uint256 cfilInterest)
1918     internal{
1919     if(data.Days == 0){
1920       return;
1921     }
1922     
1923     uint256 affID = data.AffID;
1924     if(affID == 0){
1925       return;
1926     }
1927     InvestInfo storage affInfo = SInfo.Invests[affID];
1928     if(affInfo.nowInvestFinCFil < SInfo.AffRequire){
1929       return;
1930     }
1931     
1932     uint256 affCRFI = crfiInterest.mul(SInfo.AffRate) / Decimal;
1933     uint256 affCFil;
1934 
1935     bool emitFlag;
1936     if(affCRFI != 0){
1937       emitFlag = true;
1938       affInfo.totalAffCRFI = affInfo.totalAffCRFI.add(affCRFI);
1939     }
1940 
1941     if(SInfo.EnableAffCFil > 0){
1942       affCFil = cfilInterest.mul(SInfo.AffRate) / Decimal;
1943       if(affCFil != 0){
1944         emitFlag = true;
1945         affInfo.totalAffCFil = affInfo.totalAffCFil.add(affCFil);
1946       }
1947     }
1948 
1949     if(!emitFlag){
1950       return;
1951     }
1952     
1953     affInfo.totalAffTimes++;
1954     emit AffEvent(affInfo.Addr, uInfo.Addr, affInfo.totalAffTimes, affCRFI, affCFil, data.PackageID, block.timestamp);
1955 
1956     withdrawCoin(affInfo.Addr, 0, affCRFI, 0, affCFil);
1957 
1958   }
1959 
1960   function withdrawCoin(address addr,
1961                         uint256 crfi,
1962                         uint256 crfiInterest,
1963                         uint256 cfil,
1964                         uint256 cfilInterest)
1965     internal{
1966     
1967     require(cfil <= SInfo.nowInvestCFil, "cfil invest now error");
1968     require(cfil <= SInfo.avaiCFilAmount, "not enough cfil to withdraw");    
1969     require(crfi <= SInfo.nowInvestCRFI, "crfi invest now error");
1970     
1971     if(cfil > 0){
1972       SInfo.nowInvestCFil = SInfo.nowInvestCFil.sub(cfil);
1973       SInfo.avaiCFilAmount = SInfo.avaiCFilAmount.sub(cfil);
1974     }
1975 
1976     if(crfi > 0){
1977       SInfo.nowInvestCRFI = SInfo.nowInvestCRFI.sub(crfi);
1978     }
1979     
1980     if(cfilInterest > 0){
1981       require(SInfo.cfilInterestPool >= cfilInterest, "cfil interest pool is not enough");
1982       SInfo.cfilInterestPool = SInfo.cfilInterestPool.sub(cfilInterest);
1983       cfil = cfil.add(cfilInterest);
1984     }
1985 
1986     if(crfiInterest > 0){
1987       require(SInfo.crfiInterestPool >= crfiInterest, "crfi interest pool is not enough");
1988       SInfo.crfiInterestPool = SInfo.crfiInterestPool.sub(crfiInterest);
1989       crfi = crfi.add(crfiInterest);
1990       SInfo.crfiRewardTotal = SInfo.crfiRewardTotal.add(crfiInterest);
1991     }
1992 
1993     if(cfil > 0){
1994       CFil.send(addr, cfil, "");
1995     }
1996 
1997     if(crfi > 0){
1998       CRFI.send(addr, crfi, "");
1999     }
2000   }
2001 
2002   //////////////////// for update param
2003   
2004   function getFinancialCRFIRate(FinancialPackage storage package)
2005     internal
2006     view
2007     returns(uint256 rate){
2008     if(package.Total == 0){
2009       return 0;
2010     }
2011     
2012     uint256 x = package.Total.mul(package.Weight);
2013     if(package.Type == FinancialType.CRFI){
2014       if(SInfo.totalWeightCRFI == 0){
2015         return 0;
2016       }
2017       rate = x.mul(SInfo.crfiMinerPerDayCRFI) / SInfo.totalWeightCRFI;
2018     } else {
2019       if(SInfo.totalWeightCFil == 0){
2020         return 0;
2021       }
2022       rate = x.mul(SInfo.crfiMinerPerDayCFil) / SInfo.totalWeightCFil;
2023     }
2024 
2025     rate = rate.mul(365) / package.Total ;
2026     
2027     return rate;
2028   }
2029 
2030   function calcFinancialParam(FinancialPackage storage package)
2031     internal
2032     view
2033     returns(uint256 paramCRFI,
2034             uint256 paramCFil){
2035 
2036     uint256 diffSec = block.timestamp.sub(SInfo.ParamUpdateTime);
2037     if(diffSec == 0){
2038       return (package.ParamCRFI, package.ParamCFil);
2039     }
2040 
2041     paramCFil = package.ParamCFil.add(calcInterest(Decimal, package.CFilInterestRate, diffSec));
2042     paramCRFI = package.ParamCRFI.add(calcInterest(Decimal,
2043                                                    getFinancialCRFIRate(package),
2044                                                    diffSec));
2045     return (paramCRFI, paramCFil);
2046   }
2047 
2048   function updateFinancialParam(FinancialPackage storage package)
2049     internal{
2050 
2051     (package.ParamCRFI, package.ParamCFil) = calcFinancialParam(package);
2052   }
2053 
2054   function updateAllParam()
2055     internal{
2056     if(block.timestamp == SInfo.ParamUpdateTime){
2057       return;
2058     }
2059 
2060     for(uint256 i = 0; i < SInfo.Packages.length; i++){
2061       updateFinancialParam(SInfo.Packages[i]);
2062     }
2063 
2064     SInfo.ParamUpdateTime = block.timestamp;
2065   }
2066 
2067   function _calcInvestFinancial(uint256 packageID, uint256 amount, uint256 paramCRFI, uint256 paramCFil)
2068     internal
2069     view
2070     returns(uint256 crfiInterest, uint256 cfilInterest){
2071     
2072     FinancialPackage storage package = SInfo.Packages[packageID];
2073 
2074     (uint256 packageParamCRFI, uint256 packageParamCFil) = calcFinancialParam(package);
2075     crfiInterest = amount.mul(packageParamCRFI.sub(paramCRFI)) / Decimal;
2076     cfilInterest = amount.mul(packageParamCFil.sub(paramCFil)) / Decimal;
2077 
2078     return(crfiInterest, cfilInterest);
2079   }
2080 
2081   function calcInvestFinancial(QueueData storage data)
2082     internal
2083     view
2084     returns(uint256 crfiInterest, uint256 cfilInterest){
2085     return _calcInvestFinancial(data.PackageID, data.Amount, data.ParamCRFI, data.ParamCFil);
2086   }
2087 }