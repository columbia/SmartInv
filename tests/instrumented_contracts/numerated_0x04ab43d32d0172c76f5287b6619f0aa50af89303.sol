1 /**
2  *Submitted for verification at Etherscan.io on 2020-04-15
3 */
4 
5 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
6 
7 pragma solidity >=0.4.21 <0.7.0;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      * - Subtraction cannot overflow.
60      *
61      * _Available since v2.4.0._
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      *
119      * _Available since v2.4.0._
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         // Solidity only automatically asserts when dividing by 0
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      * - The divisor cannot be zero.
155      *
156      * _Available since v2.4.0._
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 // File: openzeppelin-solidity/contracts/GSN/Context.sol
165 
166 
167 /*
168  * @dev Provides information about the current execution context, including the
169  * sender of the transaction and its data. While these are generally available
170  * via msg.sender and msg.data, they should not be accessed in such a direct
171  * manner, since when dealing with GSN meta-transactions the account sending and
172  * paying for execution may not be the actual sender (as far as an application
173  * is concerned).
174  *
175  * This contract is only required for intermediate, library-like contracts.
176  */
177 contract Context {
178     // Empty internal constructor, to prevent people from mistakenly deploying
179     // an instance of this contract, which should be used via inheritance.
180     constructor () internal { }
181     // solhint-disable-previous-line no-empty-blocks
182 
183     function _msgSender() internal view returns (address payable) {
184         return msg.sender;
185     }
186 
187     function _msgData() internal view returns (bytes memory) {
188         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
189         return msg.data;
190     }
191 }
192 
193 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
194 
195 
196 
197 /**
198  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
199  * the optional functions; to access them see {ERC20Detailed}.
200  */
201 interface IERC20 {
202     /**
203      * @dev Returns the amount of tokens in existence.
204      */
205     function totalSupply() external view returns (uint256);
206 
207     /**
208      * @dev Returns the amount of tokens owned by `account`.
209      */
210     function balanceOf(address account) external view returns (uint256);
211 
212     /**
213      * @dev Moves `amount` tokens from the caller's account to `recipient`.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transfer(address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Returns the remaining number of tokens that `spender` will be
223      * allowed to spend on behalf of `owner` through {transferFrom}. This is
224      * zero by default.
225      *
226      * This value changes when {approve} or {transferFrom} are called.
227      */
228     function allowance(address owner, address spender) external view returns (uint256);
229 
230     /**
231      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * IMPORTANT: Beware that changing an allowance with this method brings the risk
236      * that someone may use both the old and the new allowance by unfortunate
237      * transaction ordering. One possible solution to mitigate this race
238      * condition is to first reduce the spender's allowance to 0 and set the
239      * desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address spender, uint256 amount) external returns (bool);
245     /**
246      * @dev Moves `amount` tokens from `sender` to `recipient` using the
247      * allowance mechanism. `amount` is then deducted from the caller's
248      * allowance.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * Emits a {Transfer} event.
253      */
254     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
255 
256     /**
257      * @dev Emitted when `value` tokens are moved from one account (`from`) to
258      * another (`to`).
259      *
260      * Note that `value` may be zero.
261      */
262     event Transfer(address indexed from, address indexed to, uint256 value);
263 
264     /**
265      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
266      * a call to {approve}. `value` is the new allowance.
267      */
268     event Approval(address indexed owner, address indexed spender, uint256 value);
269 }
270 
271 // File: openzeppelin-solidity/contracts/utils/Address.sol
272 
273 
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * This test is non-exhaustive, and there may be false-negatives: during the
283      * execution of a contract's constructor, its address will be reported as
284      * not containing a contract.
285      *
286      * IMPORTANT: It is unsafe to assume that an address for which this
287      * function returns false is an externally-owned account (EOA) and not a
288      * contract.
289      */
290     function isContract(address account) internal view returns (bool) {
291         // This method relies in extcodesize, which returns 0 for contracts in
292         // construction, since the code is only stored at the end of the
293         // constructor execution.
294 
295         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
296         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
297         // for accounts without code, i.e. `keccak256('')`
298         bytes32 codehash;
299         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { codehash := extcodehash(account) }
302         return (codehash != 0x0 && codehash != accountHash);
303     }
304 
305     /**
306      * @dev Converts an `address` into `address payable`. Note that this is
307      * simply a type cast: the actual underlying value is not changed.
308      *
309      * _Available since v2.4.0._
310      */
311     function toPayable(address account) internal pure returns (address payable) {
312         return address(uint160(account));
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      *
331      * _Available since v2.4.0._
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(address(this).balance >= amount, "Address: insufficient balance");
335 
336         // solhint-disable-next-line avoid-call-value
337         (bool success, ) = recipient.call.value(amount)("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 }
341 
342 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
343 
344 
345 
346 
347 
348 
349 /**
350  * @title SafeERC20
351  * @dev Wrappers around ERC20 operations that throw on failure (when the token
352  * contract returns false). Tokens that return no value (and instead revert or
353  * throw on failure) are also supported, non-reverting calls are assumed to be
354  * successful.
355  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
356  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
357  */
358 library SafeERC20 {
359     using SafeMath for uint256;
360     using Address for address;
361 
362     function safeTransfer(IERC20 token, address to, uint256 value) internal {
363         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
364     }
365 
366     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
367         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
368     }
369 
370     function safeApprove(IERC20 token, address spender, uint256 value) internal {
371         // safeApprove should only be called when setting an initial allowance,
372         // or when resetting it to zero. To increase and decrease it, use
373         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
374         // solhint-disable-next-line max-line-length
375         require((value == 0) || (token.allowance(address(this), spender) == 0),
376             "SafeERC20: approve from non-zero to non-zero allowance"
377         );
378         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
379     }
380 
381     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
382         uint256 newAllowance = token.allowance(address(this), spender).add(value);
383         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
384     }
385 
386     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
387         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
388         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
389     }
390 
391     /**
392      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
393      * on the return value: the return value is optional (but if data is returned, it must not be false).
394      * @param token The token targeted by the call.
395      * @param data The call data (encoded using abi.encode or one of its variants).
396      */
397     function callOptionalReturn(IERC20 token, bytes memory data) private {
398         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
399         // we're implementing it ourselves.
400 
401         // A Solidity high level call has three parts:
402         //  1. The target address is checked to verify it contains contract code
403         //  2. The call itself is made, and success asserted
404         //  3. The return value is decoded, which in turn checks the size of the returned data.
405         // solhint-disable-next-line max-line-length
406         require(address(token).isContract(), "SafeERC20: call to non-contract");
407 
408         // solhint-disable-next-line avoid-low-level-calls
409         (bool success, bytes memory returndata) = address(token).call(data);
410         require(success, "SafeERC20: low-level call failed");
411 
412         if (returndata.length > 0) { // Return data is optional
413             // solhint-disable-next-line max-line-length
414             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
415         }
416     }
417 }
418 
419 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
420 
421 
422 
423 /**
424  * @dev Contract module that helps prevent reentrant calls to a function.
425  *
426  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
427  * available, which can be applied to functions to make sure there are no nested
428  * (reentrant) calls to them.
429  *
430  * Note that because there is a single `nonReentrant` guard, functions marked as
431  * `nonReentrant` may not call one another. This can be worked around by making
432  * those functions `private`, and then adding `external` `nonReentrant` entry
433  * points to them.
434  */
435 contract ReentrancyGuard {
436     // counter to allow mutex lock with only one SSTORE operation
437     uint256 private _guardCounter;
438 
439     constructor () internal {
440         // The counter starts at one to prevent changing it from zero to a non-zero
441         // value, which is a more expensive operation.
442         _guardCounter = 1;
443     }
444 
445     /**
446      * @dev Prevents a contract from calling itself, directly or indirectly.
447      * Calling a `nonReentrant` function from another `nonReentrant`
448      * function is not supported. It is possible to prevent this from happening
449      * by making the `nonReentrant` function external, and make it call a
450      * `private` function that does the actual work.
451      */
452     modifier nonReentrant() {
453         _guardCounter += 1;
454         uint256 localCounter = _guardCounter;
455         _;
456         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
457     }
458 }
459 
460 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
461 
462 
463 
464 
465 
466 
467 
468 
469 /**
470  * @title Crowdsale
471  * @dev Crowdsale is a base contract for managing a token crowdsale,
472  * allowing investors to purchase tokens with ether. This contract implements
473  * such functionality in its most fundamental form and can be extended to provide additional
474  * functionality and/or custom behavior.
475  * The external interface represents the basic interface for purchasing tokens, and conforms
476  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
477  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
478  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
479  * behavior.
480  */
481 
482 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
483 
484 
485 
486 
487 
488 /**
489  * @title CappedCrowdsale
490  * @dev Crowdsale with a limit for total contributions.
491  */
492 
493 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
494 
495 
496 
497 
498 
499 /**
500  * @title TimedCrowdsale
501  * @dev Crowdsale accepting contributions only within a time frame.
502  */
503 
504 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
505 
506 
507 
508 
509 
510 /**
511  * @title FinalizableCrowdsale
512  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
513  * can do extra work after finishing.
514  */
515 
516 // File: openzeppelin-solidity/contracts/ownership/Secondary.sol
517 
518 
519 
520 /**
521  * @dev A Secondary contract can only be used by its primary account (the one that created it).
522  */
523 contract Secondary is Context {
524     address private _primary;
525 
526     /**
527      * @dev Emitted when the primary contract changes.
528      */
529     event PrimaryTransferred(
530         address recipient
531     );
532 
533     /**
534      * @dev Sets the primary account to the one that is creating the Secondary contract.
535      */
536     constructor () internal {
537         _primary = _msgSender();
538         emit PrimaryTransferred(_primary);
539     }
540 
541     /**
542      * @dev Reverts if called from any account other than the primary.
543      */
544     modifier onlyPrimary() {
545         require(_msgSender() == _primary, "Secondary: caller is not the primary account");
546         _;
547     }
548 
549     /**
550      * @return the address of the primary.
551      */
552     function primary() public view returns (address) {
553         return _primary;
554     }
555 
556     /**
557      * @dev Transfers contract to a new primary.
558      * @param recipient The address of new primary.
559      */
560     function transferPrimary(address recipient) public onlyPrimary {
561         require(recipient != address(0), "Secondary: new primary is the zero address");
562         _primary = recipient;
563         emit PrimaryTransferred(_primary);
564     }
565 }
566 
567 // File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
568 
569 
570 
571 
572 
573 
574  /**
575   * @title Escrow
576   * @dev Base escrow contract, holds funds designated for a payee until they
577   * withdraw them.
578   *
579   * Intended usage: This contract (and derived escrow contracts) should be a
580   * standalone contract, that only interacts with the contract that instantiated
581   * it. That way, it is guaranteed that all Ether will be handled according to
582   * the `Escrow` rules, and there is no need to check for payable functions or
583   * transfers in the inheritance tree. The contract that uses the escrow as its
584   * payment method should be its primary, and provide public methods redirecting
585   * to the escrow's deposit and withdraw.
586   */
587 
588 // File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
589 
590 
591 
592 
593 /**
594  * @title ConditionalEscrow
595  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
596  * @dev Intended usage: See {Escrow}. Same usage guidelines apply here.
597  */
598 
599 // File: openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol
600 
601 
602 
603 
604 /**
605  * @title RefundEscrow
606  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
607  * parties.
608  * @dev Intended usage: See {Escrow}. Same usage guidelines apply here.
609  * @dev The primary account (that is, the contract that instantiates this
610  * contract) may deposit, close the deposit period, and allow for either
611  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
612  * with `RefundEscrow` will be made through the primary contract. See the
613  * `RefundableCrowdsale` contract for an example of `RefundEscrow`’s use.
614  */
615 
616 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
617 
618 
619 
620 
621 
622 
623 
624 /**
625  * @title RefundableCrowdsale
626  * @dev Extension of `FinalizableCrowdsale` contract that adds a funding goal, and the possibility of users
627  * getting a refund if goal is not met.
628  *
629  * Deprecated, use `RefundablePostDeliveryCrowdsale` instead. Note that if you allow tokens to be traded before the goal
630  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
631  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
632  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
633  */
634 
635 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
636 
637 
638 
639 
640 
641 
642 /**
643  * @dev Implementation of the {IERC20} interface.
644  *
645  * This implementation is agnostic to the way tokens are created. This means
646  * that a supply mechanism has to be added in a derived contract using {_mint}.
647  * For a generic mechanism see {ERC20Mintable}.
648  *
649  * TIP: For a detailed writeup see our guide
650  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
651  * to implement supply mechanisms].
652  *
653  * We have followed general OpenZeppelin guidelines: functions revert instead
654  * of returning `false` on failure. This behavior is nonetheless conventional
655  * and does not conflict with the expectations of ERC20 applications.
656  *
657  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
658  * This allows applications to reconstruct the allowance for all accounts just
659  * by listening to said events. Other implementations of the EIP may not emit
660  * these events, as it isn't required by the specification.
661  *
662  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
663  * functions have been added to mitigate the well-known issues around setting
664  * allowances. See {IERC20-approve}.
665  */
666 contract ERC20 is Context, IERC20 {
667     using SafeMath for uint256;
668 
669     mapping (address => uint256) private _balances;
670 
671     mapping (address => mapping (address => uint256)) private _allowances;
672 
673     uint256 private _totalSupply;
674 
675     /**
676      * @dev See {IERC20-totalSupply}.
677      */
678     function totalSupply() public view returns (uint256) {
679         return _totalSupply;
680     }
681 
682     /**
683      * @dev See {IERC20-balanceOf}.
684      */
685     function balanceOf(address account) public view returns (uint256) {
686         return _balances[account];
687     }
688 
689     /**
690      * @dev See {IERC20-transfer}.
691      *
692      * Requirements:
693      *
694      * - `recipient` cannot be the zero address.
695      * - the caller must have a balance of at least `amount`.
696      */
697     function transfer(address recipient, uint256 amount) public returns (bool) {
698         _transfer(_msgSender(), recipient, amount);
699         return true;
700     }
701 
702     /**
703      * @dev See {IERC20-allowance}.
704      */
705     function allowance(address owner, address spender) public view returns (uint256) {
706         return _allowances[owner][spender];
707     }
708     
709 
710     /**
711      * @dev See {IERC20-approve}.
712      *
713      * Requirements:
714      *
715      * - `spender` cannot be the zero address.
716      */
717     function approve(address spender, uint256 amount) public returns (bool) {
718         _approve(_msgSender(), spender, amount);
719         return true;
720     }
721 
722     /**
723      * @dev See {IERC20-transferFrom}.
724      *
725      * Emits an {Approval} event indicating the updated allowance. This is not
726      * required by the EIP. See the note at the beginning of {ERC20};
727      *
728      * Requirements:
729      * - `sender` and `recipient` cannot be the zero address.
730      * - `sender` must have a balance of at least `amount`.
731      * - the caller must have allowance for `sender`'s tokens of at least
732      * `amount`.
733      */
734     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
735         _transfer(sender, recipient, amount);
736         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
737         return true;
738     }
739 
740     /**
741      * @dev Atomically increases the allowance granted to `spender` by the caller.
742      *
743      * This is an alternative to {approve} that can be used as a mitigation for
744      * problems described in {IERC20-approve}.
745      *
746      * Emits an {Approval} event indicating the updated allowance.
747      *
748      * Requirements:
749      *
750      * - `spender` cannot be the zero address.
751      */
752     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
753         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
754         return true;
755     }
756 
757     /**
758      * @dev Atomically decreases the allowance granted to `spender` by the caller.
759      *
760      * This is an alternative to {approve} that can be used as a mitigation for
761      * problems described in {IERC20-approve}.
762      *
763      * Emits an {Approval} event indicating the updated allowance.
764      *
765      * Requirements:
766      *
767      * - `spender` cannot be the zero address.
768      * - `spender` must have allowance for the caller of at least
769      * `subtractedValue`.
770      */
771     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
772         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
773         return true;
774     }
775 
776     /**
777      * @dev Moves tokens `amount` from `sender` to `recipient`.
778      *
779      * This is internal function is equivalent to {transfer}, and can be used to
780      * e.g. implement automatic token fees, slashing mechanisms, etc.
781      *
782      * Emits a {Transfer} event.
783      *
784      * Requirements:
785      *
786      * - `sender` cannot be the zero address.
787      * - `recipient` cannot be the zero address.
788      * - `sender` must have a balance of at least `amount`.
789      */
790     function _transfer(address sender, address recipient, uint256 amount) internal {
791         require(sender != address(0), "ERC20: transfer from the zero address");
792         require(recipient != address(0), "ERC20: transfer to the zero address");
793 
794         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
795         _balances[recipient] = _balances[recipient].add(amount);
796         emit Transfer(sender, recipient, amount);
797     }
798 
799     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
800      * the total supply.
801      *
802      * Emits a {Transfer} event with `from` set to the zero address.
803      *
804      * Requirements
805      *
806      * - `to` cannot be the zero address.
807      */
808     function _mint(address account, uint256 amount) internal {
809         require(account != address(0), "ERC20: mint to the zero address");
810 
811         _totalSupply = _totalSupply.add(amount);
812         _balances[account] = _balances[account].add(amount);
813         emit Transfer(address(0), account, amount);
814     }
815 
816      /**
817      * @dev Destroys `amount` tokens from `account`, reducing the
818      * total supply.
819      *
820      * Emits a {Transfer} event with `to` set to the zero address.
821      *
822      * Requirements
823      *
824      * - `account` cannot be the zero address.
825      * - `account` must have at least `amount` tokens.
826      */
827     function _burn(address account, uint256 amount) internal {
828         require(account != address(0), "ERC20: burn from the zero address");
829 
830         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
831         _totalSupply = _totalSupply.sub(amount);
832         emit Transfer(account, address(0), amount);
833     }
834 
835     /**
836      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
837      *
838      * This is internal function is equivalent to `approve`, and can be used to
839      * e.g. set automatic allowances for certain subsystems, etc.
840      *
841      * Emits an {Approval} event.
842      *
843      * Requirements:
844      *
845      * - `owner` cannot be the zero address.
846      * - `spender` cannot be the zero address.
847      */
848     function _approve(address owner, address spender, uint256 amount) internal {
849         require(owner != address(0), "ERC20: approve from the zero address");
850         require(spender != address(0), "ERC20: approve to the zero address");
851 
852         _allowances[owner][spender] = amount;
853         emit Approval(owner, spender, amount);
854     }
855 
856     /**
857      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
858      * from the caller's allowance.
859      *
860      * See {_burn} and {_approve}.
861      */
862     function _burnFrom(address account, uint256 amount) internal {
863         _burn(account, amount);
864         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
865     }
866 }
867 
868 // File: openzeppelin-solidity/contracts/access/Roles.sol
869 
870 
871 
872 /**
873  * @title Roles
874  * @dev Library for managing addresses assigned to a Role.
875  */
876 library Roles {
877     struct Role {
878         mapping (address => bool) bearer;
879     }
880 
881     /**
882      * @dev Give an account access to this role.
883      */
884     function add(Role storage role, address account) internal {
885         require(!has(role, account), "Roles: account already has role");
886         role.bearer[account] = true;
887     }
888 
889     /**
890      * @dev Remove an account's access to this role.
891      */
892     function remove(Role storage role, address account) internal {
893         require(has(role, account), "Roles: account does not have role");
894         role.bearer[account] = false;
895     }
896 
897     /**
898      * @dev Check if an account has this role.
899      * @return bool
900      */
901     function has(Role storage role, address account) internal view returns (bool) {
902         require(account != address(0), "Roles: account is the zero address");
903         return role.bearer[account];
904     }
905 }
906 
907 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
908 
909 
910 
911 
912 
913 contract MinterRole is Context {
914     using Roles for Roles.Role;
915 
916     event MinterAdded(address indexed account);
917     event MinterRemoved(address indexed account);
918 
919     Roles.Role private _minters;
920 
921     constructor () internal {
922         _addMinter(_msgSender());
923     }
924 
925     modifier onlyMinter() {
926         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
927         _;
928     }
929 
930     function isMinter(address account) public view returns (bool) {
931         return _minters.has(account);
932     }
933 
934     function addMinter(address account) public onlyMinter {
935         _addMinter(account);
936     }
937 
938     function renounceMinter() public {
939         _removeMinter(_msgSender());
940     }
941 
942     function _addMinter(address account) internal {
943         _minters.add(account);
944         emit MinterAdded(account);
945     }
946 
947     function _removeMinter(address account) internal {
948         _minters.remove(account);
949         emit MinterRemoved(account);
950     }
951 }
952 
953 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
954 
955 
956 
957 
958 
959 /**
960  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
961  * which have permission to mint (create) new tokens as they see fit.
962  *
963  * At construction, the deployer of the contract is the only minter.
964  */
965 contract ERC20Mintable is ERC20, MinterRole {
966     /**
967      * @dev See {ERC20-_mint}.
968      *
969      * Requirements:
970      *
971      * - the caller must have the {MinterRole}.
972      */
973      
974     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
975         _mint(account, amount);
976         return true;
977     }
978 }
979 
980 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
981 
982 
983 
984 
985 
986 /**
987  * @title MintedCrowdsale
988  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
989  * Token ownership should be transferred to MintedCrowdsale for minting.
990  */
991 
992 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
993 
994 
995 
996 
997 /**
998  * @dev Optional functions from the ERC20 standard.
999  */
1000 contract ERC20Detailed is IERC20 {
1001     string private _name;
1002     string private _symbol;
1003     uint8 private _decimals;
1004 
1005     /**
1006      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1007      * these values are immutable: they can only be set once during
1008      * construction.
1009      */
1010     constructor (string memory name, string memory symbol, uint8 decimals) public {
1011         _name = name;
1012         _symbol = symbol;
1013         _decimals = decimals;
1014     }
1015 
1016     /**
1017      * @dev Returns the name of the token.
1018      */
1019     function name() public view returns (string memory) {
1020         return _name;
1021     }
1022 
1023     /**
1024      * @dev Returns the symbol of the token, usually a shorter version of the
1025      * name.
1026      */
1027     function symbol() public view returns (string memory) {
1028         return _symbol;
1029     }
1030 
1031     /**
1032      * @dev Returns the number of decimals used to get its user representation.
1033      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1034      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1035      *
1036      * Tokens usually opt for a value of 18, imitating the relationship between
1037      * Ether and Wei.
1038      *
1039      * NOTE: This information is only used for _display_ purposes: it in
1040      * no way affects any of the arithmetic of the contract, including
1041      * {IERC20-balanceOf} and {IERC20-transfer}.
1042      */
1043     function decimals() public view returns (uint8) {
1044         return _decimals;
1045     }
1046 }
1047 
1048 // File: contracts/CovidToken.sol
1049 
1050 // solium-disable linebreak-style
1051 pragma solidity 0.5.10;
1052 
1053 
1054 
1055 
1056 
1057 
1058 /**
1059  * @title SampleCrowdsaleToken
1060  * @dev Very simple ERC20 Token that can be minted.
1061  * It is meant to be used in a crowdsale contract.
1062  */
1063 contract uniLockToken is ERC20Mintable, ERC20Detailed {
1064     
1065     constructor( string memory _name, string memory _symbol, uint8 _decimals) 
1066         ERC20Detailed(_name, _symbol, _decimals)
1067         public
1068     {
1069 
1070     
1071 }
1072 
1073 
1074 }
1075 
1076 /**
1077  * @title SampleCrowdsale
1078  * @dev This is an example of a fully fledged crowdsale.
1079  * The way to add new features to a base crowdsale is by multiple inheritance.
1080  * In this example we are providing following extensions:
1081  * CappedCrowdsale - sets a max boundary for raised funds
1082  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
1083  * MintedCrowdsale - assumes the token can be minted by the crowdsale, which does so
1084  * when receiving purchases.
1085  *
1086  * After adding multiple features it's good practice to run integration tests
1087  * to ensure that subcontracts works together as intended.
1088  */