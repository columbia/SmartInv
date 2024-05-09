1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-06
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-04-15
7 */
8 
9 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
10 
11 pragma solidity >=0.4.21 <0.7.0;
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations with added overflow
15  * checks.
16  *
17  * Arithmetic operations in Solidity wrap on overflow. This can easily result
18  * in bugs, because programmers usually assume that an overflow raises an
19  * error, which is the standard behavior in high level programming languages.
20  * `SafeMath` restores this intuition by reverting the transaction when an
21  * operation overflows.
22  *
23  * Using this library instead of the unchecked operations eliminates an entire
24  * class of bugs, so it's recommended to use it always.
25  */
26 library SafeMath {
27     /**
28      * @dev Returns the addition of two unsigned integers, reverting on
29      * overflow.
30      *
31      * Counterpart to Solidity's `+` operator.
32      *
33      * Requirements:
34      * - Addition cannot overflow.
35      */
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39 
40         return c;
41     }
42 
43     /**
44      * @dev Returns the subtraction of two unsigned integers, reverting on
45      * overflow (when the result is negative).
46      *
47      * Counterpart to Solidity's `-` operator.
48      *
49      * Requirements:
50      * - Subtraction cannot overflow.
51      */
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
58      * overflow (when the result is negative).
59      *
60      * Counterpart to Solidity's `-` operator.
61      *
62      * Requirements:
63      * - Subtraction cannot overflow.
64      *
65      * _Available since v2.4.0._
66      */
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      * - Multiplication cannot overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      *
123      * _Available since v2.4.0._
124      */
125     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
126         // Solidity only automatically asserts when dividing by 0
127         require(b > 0, errorMessage);
128         uint256 c = a / b;
129         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * Reverts when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return mod(a, b, "SafeMath: modulo by zero");
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * Reverts with custom message when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      * - The divisor cannot be zero.
159      *
160      * _Available since v2.4.0._
161      */
162     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b != 0, errorMessage);
164         return a % b;
165     }
166 }
167 
168 // File: openzeppelin-solidity/contracts/GSN/Context.sol
169 
170 
171 /*
172  * @dev Provides information about the current execution context, including the
173  * sender of the transaction and its data. While these are generally available
174  * via msg.sender and msg.data, they should not be accessed in such a direct
175  * manner, since when dealing with GSN meta-transactions the account sending and
176  * paying for execution may not be the actual sender (as far as an application
177  * is concerned).
178  *
179  * This contract is only required for intermediate, library-like contracts.
180  */
181 contract Context {
182     // Empty internal constructor, to prevent people from mistakenly deploying
183     // an instance of this contract, which should be used via inheritance.
184     constructor () internal { }
185     // solhint-disable-previous-line no-empty-blocks
186 
187     function _msgSender() internal view returns (address payable) {
188         return msg.sender;
189     }
190 
191     function _msgData() internal view returns (bytes memory) {
192         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
193         return msg.data;
194     }
195 }
196 
197 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
198 
199 
200 
201 /**
202  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
203  * the optional functions; to access them see {ERC20Detailed}.
204  */
205 interface IERC20 {
206     /**
207      * @dev Returns the amount of tokens in existence.
208      */
209     function totalSupply() external view returns (uint256);
210 
211     /**
212      * @dev Returns the amount of tokens owned by `account`.
213      */
214     function balanceOf(address account) external view returns (uint256);
215 
216     /**
217      * @dev Moves `amount` tokens from the caller's account to `recipient`.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transfer(address recipient, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Returns the remaining number of tokens that `spender` will be
227      * allowed to spend on behalf of `owner` through {transferFrom}. This is
228      * zero by default.
229      *
230      * This value changes when {approve} or {transferFrom} are called.
231      */
232     function allowance(address owner, address spender) external view returns (uint256);
233 
234     /**
235      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * IMPORTANT: Beware that changing an allowance with this method brings the risk
240      * that someone may use both the old and the new allowance by unfortunate
241      * transaction ordering. One possible solution to mitigate this race
242      * condition is to first reduce the spender's allowance to 0 and set the
243      * desired value afterwards:
244      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245      *
246      * Emits an {Approval} event.
247      */
248     function approve(address spender, uint256 amount) external returns (bool);
249     /**
250      * @dev Moves `amount` tokens from `sender` to `recipient` using the
251      * allowance mechanism. `amount` is then deducted from the caller's
252      * allowance.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Emitted when `value` tokens are moved from one account (`from`) to
262      * another (`to`).
263      *
264      * Note that `value` may be zero.
265      */
266     event Transfer(address indexed from, address indexed to, uint256 value);
267 
268     /**
269      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
270      * a call to {approve}. `value` is the new allowance.
271      */
272     event Approval(address indexed owner, address indexed spender, uint256 value);
273 }
274 
275 // File: openzeppelin-solidity/contracts/utils/Address.sol
276 
277 
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * This test is non-exhaustive, and there may be false-negatives: during the
287      * execution of a contract's constructor, its address will be reported as
288      * not containing a contract.
289      *
290      * IMPORTANT: It is unsafe to assume that an address for which this
291      * function returns false is an externally-owned account (EOA) and not a
292      * contract.
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies in extcodesize, which returns 0 for contracts in
296         // construction, since the code is only stored at the end of the
297         // constructor execution.
298 
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { codehash := extcodehash(account) }
306         return (codehash != 0x0 && codehash != accountHash);
307     }
308 
309     /**
310      * @dev Converts an `address` into `address payable`. Note that this is
311      * simply a type cast: the actual underlying value is not changed.
312      *
313      * _Available since v2.4.0._
314      */
315     function toPayable(address account) internal pure returns (address payable) {
316         return address(uint160(account));
317     }
318 
319     /**
320      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
321      * `recipient`, forwarding all available gas and reverting on errors.
322      *
323      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
324      * of certain opcodes, possibly making contracts go over the 2300 gas limit
325      * imposed by `transfer`, making them unable to receive funds via
326      * `transfer`. {sendValue} removes this limitation.
327      *
328      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
329      *
330      * IMPORTANT: because control is transferred to `recipient`, care must be
331      * taken to not create reentrancy vulnerabilities. Consider using
332      * {ReentrancyGuard} or the
333      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
334      *
335      * _Available since v2.4.0._
336      */
337     function sendValue(address payable recipient, uint256 amount) internal {
338         require(address(this).balance >= amount, "Address: insufficient balance");
339 
340         // solhint-disable-next-line avoid-call-value
341         (bool success, ) = recipient.call.value(amount)("");
342         require(success, "Address: unable to send value, recipient may have reverted");
343     }
344 }
345 
346 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
347 
348 
349 
350 
351 
352 
353 /**
354  * @title SafeERC20
355  * @dev Wrappers around ERC20 operations that throw on failure (when the token
356  * contract returns false). Tokens that return no value (and instead revert or
357  * throw on failure) are also supported, non-reverting calls are assumed to be
358  * successful.
359  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
360  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
361  */
362 library SafeERC20 {
363     using SafeMath for uint256;
364     using Address for address;
365 
366     function safeTransfer(IERC20 token, address to, uint256 value) internal {
367         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
368     }
369 
370     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
371         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
372     }
373 
374     function safeApprove(IERC20 token, address spender, uint256 value) internal {
375         // safeApprove should only be called when setting an initial allowance,
376         // or when resetting it to zero. To increase and decrease it, use
377         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
378         // solhint-disable-next-line max-line-length
379         require((value == 0) || (token.allowance(address(this), spender) == 0),
380             "SafeERC20: approve from non-zero to non-zero allowance"
381         );
382         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
383     }
384 
385     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
386         uint256 newAllowance = token.allowance(address(this), spender).add(value);
387         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
388     }
389 
390     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
391         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
392         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
393     }
394 
395     /**
396      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
397      * on the return value: the return value is optional (but if data is returned, it must not be false).
398      * @param token The token targeted by the call.
399      * @param data The call data (encoded using abi.encode or one of its variants).
400      */
401     function callOptionalReturn(IERC20 token, bytes memory data) private {
402         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
403         // we're implementing it ourselves.
404 
405         // A Solidity high level call has three parts:
406         //  1. The target address is checked to verify it contains contract code
407         //  2. The call itself is made, and success asserted
408         //  3. The return value is decoded, which in turn checks the size of the returned data.
409         // solhint-disable-next-line max-line-length
410         require(address(token).isContract(), "SafeERC20: call to non-contract");
411 
412         // solhint-disable-next-line avoid-low-level-calls
413         (bool success, bytes memory returndata) = address(token).call(data);
414         require(success, "SafeERC20: low-level call failed");
415 
416         if (returndata.length > 0) { // Return data is optional
417             // solhint-disable-next-line max-line-length
418             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
419         }
420     }
421 }
422 
423 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
424 
425 
426 
427 /**
428  * @dev Contract module that helps prevent reentrant calls to a function.
429  *
430  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
431  * available, which can be applied to functions to make sure there are no nested
432  * (reentrant) calls to them.
433  *
434  * Note that because there is a single `nonReentrant` guard, functions marked as
435  * `nonReentrant` may not call one another. This can be worked around by making
436  * those functions `private`, and then adding `external` `nonReentrant` entry
437  * points to them.
438  */
439 contract ReentrancyGuard {
440     // counter to allow mutex lock with only one SSTORE operation
441     uint256 private _guardCounter;
442 
443     constructor () internal {
444         // The counter starts at one to prevent changing it from zero to a non-zero
445         // value, which is a more expensive operation.
446         _guardCounter = 1;
447     }
448 
449     /**
450      * @dev Prevents a contract from calling itself, directly or indirectly.
451      * Calling a `nonReentrant` function from another `nonReentrant`
452      * function is not supported. It is possible to prevent this from happening
453      * by making the `nonReentrant` function external, and make it call a
454      * `private` function that does the actual work.
455      */
456     modifier nonReentrant() {
457         _guardCounter += 1;
458         uint256 localCounter = _guardCounter;
459         _;
460         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
461     }
462 }
463 
464 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
465 
466 
467 
468 
469 
470 
471 
472 
473 /**
474  * @title Crowdsale
475  * @dev Crowdsale is a base contract for managing a token crowdsale,
476  * allowing investors to purchase tokens with ether. This contract implements
477  * such functionality in its most fundamental form and can be extended to provide additional
478  * functionality and/or custom behavior.
479  * The external interface represents the basic interface for purchasing tokens, and conforms
480  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
481  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
482  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
483  * behavior.
484  */
485 
486 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
487 
488 
489 
490 
491 
492 /**
493  * @title CappedCrowdsale
494  * @dev Crowdsale with a limit for total contributions.
495  */
496 
497 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
498 
499 
500 
501 
502 
503 /**
504  * @title TimedCrowdsale
505  * @dev Crowdsale accepting contributions only within a time frame.
506  */
507 
508 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
509 
510 
511 
512 
513 
514 /**
515  * @title FinalizableCrowdsale
516  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
517  * can do extra work after finishing.
518  */
519 
520 // File: openzeppelin-solidity/contracts/ownership/Secondary.sol
521 
522 
523 
524 /**
525  * @dev A Secondary contract can only be used by its primary account (the one that created it).
526  */
527 contract Secondary is Context {
528     address private _primary;
529 
530     /**
531      * @dev Emitted when the primary contract changes.
532      */
533     event PrimaryTransferred(
534         address recipient
535     );
536 
537     /**
538      * @dev Sets the primary account to the one that is creating the Secondary contract.
539      */
540     constructor () internal {
541         _primary = _msgSender();
542         emit PrimaryTransferred(_primary);
543     }
544 
545     /**
546      * @dev Reverts if called from any account other than the primary.
547      */
548     modifier onlyPrimary() {
549         require(_msgSender() == _primary, "Secondary: caller is not the primary account");
550         _;
551     }
552 
553     /**
554      * @return the address of the primary.
555      */
556     function primary() public view returns (address) {
557         return _primary;
558     }
559 
560     /**
561      * @dev Transfers contract to a new primary.
562      * @param recipient The address of new primary.
563      */
564     function transferPrimary(address recipient) public onlyPrimary {
565         require(recipient != address(0), "Secondary: new primary is the zero address");
566         _primary = recipient;
567         emit PrimaryTransferred(_primary);
568     }
569 }
570 
571 // File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
572 
573 
574 
575 
576 
577 
578  /**
579   * @title Escrow
580   * @dev Base escrow contract, holds funds designated for a payee until they
581   * withdraw them.
582   *
583   * Intended usage: This contract (and derived escrow contracts) should be a
584   * standalone contract, that only interacts with the contract that instantiated
585   * it. That way, it is guaranteed that all Ether will be handled according to
586   * the `Escrow` rules, and there is no need to check for payable functions or
587   * transfers in the inheritance tree. The contract that uses the escrow as its
588   * payment method should be its primary, and provide public methods redirecting
589   * to the escrow's deposit and withdraw.
590   */
591 
592 // File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
593 
594 
595 
596 
597 /**
598  * @title ConditionalEscrow
599  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
600  * @dev Intended usage: See {Escrow}. Same usage guidelines apply here.
601  */
602 
603 // File: openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol
604 
605 
606 
607 
608 /**
609  * @title RefundEscrow
610  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
611  * parties.
612  * @dev Intended usage: See {Escrow}. Same usage guidelines apply here.
613  * @dev The primary account (that is, the contract that instantiates this
614  * contract) may deposit, close the deposit period, and allow for either
615  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
616  * with `RefundEscrow` will be made through the primary contract. See the
617  * `RefundableCrowdsale` contract for an example of `RefundEscrow`’s use.
618  */
619 
620 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
621 
622 
623 
624 
625 
626 
627 
628 /**
629  * @title RefundableCrowdsale
630  * @dev Extension of `FinalizableCrowdsale` contract that adds a funding goal, and the possibility of users
631  * getting a refund if goal is not met.
632  *
633  * Deprecated, use `RefundablePostDeliveryCrowdsale` instead. Note that if you allow tokens to be traded before the goal
634  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
635  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
636  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
637  */
638 
639 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
640 
641 
642 
643 
644 
645 
646 /**
647  * @dev Implementation of the {IERC20} interface.
648  *
649  * This implementation is agnostic to the way tokens are created. This means
650  * that a supply mechanism has to be added in a derived contract using {_mint}.
651  * For a generic mechanism see {ERC20Mintable}.
652  *
653  * TIP: For a detailed writeup see our guide
654  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
655  * to implement supply mechanisms].
656  *
657  * We have followed general OpenZeppelin guidelines: functions revert instead
658  * of returning `false` on failure. This behavior is nonetheless conventional
659  * and does not conflict with the expectations of ERC20 applications.
660  *
661  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
662  * This allows applications to reconstruct the allowance for all accounts just
663  * by listening to said events. Other implementations of the EIP may not emit
664  * these events, as it isn't required by the specification.
665  *
666  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
667  * functions have been added to mitigate the well-known issues around setting
668  * allowances. See {IERC20-approve}.
669  */
670 contract ERC20 is Context, IERC20 {
671     using SafeMath for uint256;
672 
673     mapping (address => uint256) private _balances;
674 
675     mapping (address => mapping (address => uint256)) private _allowances;
676 
677     uint256 private _totalSupply;
678 
679     /**
680      * @dev See {IERC20-totalSupply}.
681      */
682     function totalSupply() public view returns (uint256) {
683         return _totalSupply;
684     }
685 
686     /**
687      * @dev See {IERC20-balanceOf}.
688      */
689     function balanceOf(address account) public view returns (uint256) {
690         return _balances[account];
691     }
692 
693     /**
694      * @dev See {IERC20-transfer}.
695      *
696      * Requirements:
697      *
698      * - `recipient` cannot be the zero address.
699      * - the caller must have a balance of at least `amount`.
700      */
701     function transfer(address recipient, uint256 amount) public returns (bool) {
702         _transfer(_msgSender(), recipient, amount);
703         return true;
704     }
705 
706     /**
707      * @dev See {IERC20-allowance}.
708      */
709     function allowance(address owner, address spender) public view returns (uint256) {
710         return _allowances[owner][spender];
711     }
712     
713 
714     /**
715      * @dev See {IERC20-approve}.
716      *
717      * Requirements:
718      *
719      * - `spender` cannot be the zero address.
720      */
721     function approve(address spender, uint256 amount) public returns (bool) {
722         _approve(_msgSender(), spender, amount);
723         return true;
724     }
725 
726     /**
727      * @dev See {IERC20-transferFrom}.
728      *
729      * Emits an {Approval} event indicating the updated allowance. This is not
730      * required by the EIP. See the note at the beginning of {ERC20};
731      *
732      * Requirements:
733      * - `sender` and `recipient` cannot be the zero address.
734      * - `sender` must have a balance of at least `amount`.
735      * - the caller must have allowance for `sender`'s tokens of at least
736      * `amount`.
737      */
738     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
739         _transfer(sender, recipient, amount);
740         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
741         return true;
742     }
743 
744     /**
745      * @dev Atomically increases the allowance granted to `spender` by the caller.
746      *
747      * This is an alternative to {approve} that can be used as a mitigation for
748      * problems described in {IERC20-approve}.
749      *
750      * Emits an {Approval} event indicating the updated allowance.
751      *
752      * Requirements:
753      *
754      * - `spender` cannot be the zero address.
755      */
756     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
757         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
758         return true;
759     }
760 
761     /**
762      * @dev Atomically decreases the allowance granted to `spender` by the caller.
763      *
764      * This is an alternative to {approve} that can be used as a mitigation for
765      * problems described in {IERC20-approve}.
766      *
767      * Emits an {Approval} event indicating the updated allowance.
768      *
769      * Requirements:
770      *
771      * - `spender` cannot be the zero address.
772      * - `spender` must have allowance for the caller of at least
773      * `subtractedValue`.
774      */
775     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
776         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
777         return true;
778     }
779 
780     /**
781      * @dev Moves tokens `amount` from `sender` to `recipient`.
782      *
783      * This is internal function is equivalent to {transfer}, and can be used to
784      * e.g. implement automatic token fees, slashing mechanisms, etc.
785      *
786      * Emits a {Transfer} event.
787      *
788      * Requirements:
789      *
790      * - `sender` cannot be the zero address.
791      * - `recipient` cannot be the zero address.
792      * - `sender` must have a balance of at least `amount`.
793      */
794     function _transfer(address sender, address recipient, uint256 amount) internal {
795         require(sender != address(0), "ERC20: transfer from the zero address");
796         require(recipient != address(0), "ERC20: transfer to the zero address");
797 
798         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
799         _balances[recipient] = _balances[recipient].add(amount);
800         emit Transfer(sender, recipient, amount);
801     }
802 
803     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
804      * the total supply.
805      *
806      * Emits a {Transfer} event with `from` set to the zero address.
807      *
808      * Requirements
809      *
810      * - `to` cannot be the zero address.
811      */
812     function _mint(address account, uint256 amount) internal {
813         require(account != address(0), "ERC20: mint to the zero address");
814 
815         _totalSupply = _totalSupply.add(amount);
816         _balances[account] = _balances[account].add(amount);
817         emit Transfer(address(0), account, amount);
818     }
819 
820      /**
821      * @dev Destroys `amount` tokens from `account`, reducing the
822      * total supply.
823      *
824      * Emits a {Transfer} event with `to` set to the zero address.
825      *
826      * Requirements
827      *
828      * - `account` cannot be the zero address.
829      * - `account` must have at least `amount` tokens.
830      */
831     function _burn(address account, uint256 amount) internal {
832         require(account != address(0), "ERC20: burn from the zero address");
833 
834         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
835         _totalSupply = _totalSupply.sub(amount);
836         emit Transfer(account, address(0), amount);
837     }
838 
839     /**
840      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
841      *
842      * This is internal function is equivalent to `approve`, and can be used to
843      * e.g. set automatic allowances for certain subsystems, etc.
844      *
845      * Emits an {Approval} event.
846      *
847      * Requirements:
848      *
849      * - `owner` cannot be the zero address.
850      * - `spender` cannot be the zero address.
851      */
852     function _approve(address owner, address spender, uint256 amount) internal {
853         require(owner != address(0), "ERC20: approve from the zero address");
854         require(spender != address(0), "ERC20: approve to the zero address");
855 
856         _allowances[owner][spender] = amount;
857         emit Approval(owner, spender, amount);
858     }
859 
860     /**
861      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
862      * from the caller's allowance.
863      *
864      * See {_burn} and {_approve}.
865      */
866     function _burnFrom(address account, uint256 amount) internal {
867         _burn(account, amount);
868         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
869     }
870 }
871 
872 // File: openzeppelin-solidity/contracts/access/Roles.sol
873 
874 
875 
876 /**
877  * @title Roles
878  * @dev Library for managing addresses assigned to a Role.
879  */
880 library Roles {
881     struct Role {
882         mapping (address => bool) bearer;
883     }
884 
885     /**
886      * @dev Give an account access to this role.
887      */
888     function add(Role storage role, address account) internal {
889         require(!has(role, account), "Roles: account already has role");
890         role.bearer[account] = true;
891     }
892 
893     /**
894      * @dev Remove an account's access to this role.
895      */
896     function remove(Role storage role, address account) internal {
897         require(has(role, account), "Roles: account does not have role");
898         role.bearer[account] = false;
899     }
900 
901     /**
902      * @dev Check if an account has this role.
903      * @return bool
904      */
905     function has(Role storage role, address account) internal view returns (bool) {
906         require(account != address(0), "Roles: account is the zero address");
907         return role.bearer[account];
908     }
909 }
910 
911 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
912 
913 
914 
915 
916 
917 contract MinterRole is Context {
918     using Roles for Roles.Role;
919 
920     event MinterAdded(address indexed account);
921     event MinterRemoved(address indexed account);
922 
923     Roles.Role private _minters;
924 
925     constructor () internal {
926         _addMinter(_msgSender());
927     }
928 
929     modifier onlyMinter() {
930         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
931         _;
932     }
933 
934     function isMinter(address account) public view returns (bool) {
935         return _minters.has(account);
936     }
937 
938     function addMinter(address account) public onlyMinter {
939         _addMinter(account);
940     }
941 
942     function renounceMinter() public {
943         _removeMinter(_msgSender());
944     }
945 
946     function _addMinter(address account) internal {
947         _minters.add(account);
948         emit MinterAdded(account);
949     }
950 
951     function _removeMinter(address account) internal {
952         _minters.remove(account);
953         emit MinterRemoved(account);
954     }
955 }
956 
957 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
958 
959 
960 
961 
962 
963 /**
964  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
965  * which have permission to mint (create) new tokens as they see fit.
966  *
967  * At construction, the deployer of the contract is the only minter.
968  */
969 contract ERC20Mintable is ERC20, MinterRole {
970     /**
971      * @dev See {ERC20-_mint}.
972      *
973      * Requirements:
974      *
975      * - the caller must have the {MinterRole}.
976      */
977      
978     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
979         _mint(account, amount);
980         return true;
981     }
982 }
983 
984 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
985 
986 
987 
988 
989 
990 /**
991  * @title MintedCrowdsale
992  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
993  * Token ownership should be transferred to MintedCrowdsale for minting.
994  */
995 
996 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
997 
998 
999 
1000 
1001 /**
1002  * @dev Optional functions from the ERC20 standard.
1003  */
1004 contract ERC20Detailed is IERC20 {
1005     string private _name;
1006     string private _symbol;
1007     uint8 private _decimals;
1008 
1009     /**
1010      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1011      * these values are immutable: they can only be set once during
1012      * construction.
1013      */
1014     constructor (string memory name, string memory symbol, uint8 decimals) public {
1015         _name = name;
1016         _symbol = symbol;
1017         _decimals = decimals;
1018     }
1019 
1020     /**
1021      * @dev Returns the name of the token.
1022      */
1023     function name() public view returns (string memory) {
1024         return _name;
1025     }
1026 
1027     /**
1028      * @dev Returns the symbol of the token, usually a shorter version of the
1029      * name.
1030      */
1031     function symbol() public view returns (string memory) {
1032         return _symbol;
1033     }
1034 
1035     /**
1036      * @dev Returns the number of decimals used to get its user representation.
1037      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1038      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1039      *
1040      * Tokens usually opt for a value of 18, imitating the relationship between
1041      * Ether and Wei.
1042      *
1043      * NOTE: This information is only used for _display_ purposes: it in
1044      * no way affects any of the arithmetic of the contract, including
1045      * {IERC20-balanceOf} and {IERC20-transfer}.
1046      */
1047     function decimals() public view returns (uint8) {
1048         return _decimals;
1049     }
1050 }
1051 
1052 // solium-disable linebreak-style
1053 pragma solidity 0.5.10;
1054 
1055 
1056 
1057 
1058 
1059 
1060 /**
1061  * @title SampleCrowdsaleToken
1062  * @dev Very simple ERC20 Token that can be minted.
1063  * It is meant to be used in a crowdsale contract.
1064  */
1065 contract uniLockToken is ERC20Mintable, ERC20Detailed {
1066     
1067     constructor( string memory _name, string memory _symbol, uint8 _decimals) 
1068         ERC20Detailed(_name, _symbol, _decimals)
1069         public
1070     {
1071 
1072     
1073 }
1074 
1075 
1076 }
1077 
1078 /**
1079  * @title SampleCrowdsale
1080  * @dev This is an example of a fully fledged crowdsale.
1081  * The way to add new features to a base crowdsale is by multiple inheritance.
1082  * In this example we are providing following extensions:
1083  * CappedCrowdsale - sets a max boundary for raised funds
1084  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
1085  * MintedCrowdsale - assumes the token can be minted by the crowdsale, which does so
1086  * when receiving purchases.
1087  *
1088  * After adding multiple features it's good practice to run integration tests
1089  * to ensure that subcontracts works together as intended.
1090  */