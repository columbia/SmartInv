1 /**
2  *
3  *            https://ulu.finance
4  *
5  *       $$\   $$\ $$\      $$\   $$\
6  *       $$ |  $$ |$$ |     $$ |  $$ |
7  *       $$ |  $$ |$$ |     $$ |  $$ |
8  *       $$ |  $$ |$$ |     $$ |  $$ |
9  *       $$ |  $$ |$$ |     $$ |  $$ |
10  *       $$ |  $$ |$$ |     $$ |  $$ |
11  *       \$$$$$$  |$$$$$$$$\\$$$$$$  |
12  *        \______/ \________|\______/
13  *
14  *         Universal Liquidity Union
15  *
16  *            https://ulu.finance
17  *
18  **/
19 
20 /*
21    ____            __   __        __   _
22   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
23  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
24 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
25      /___/
26 
27 * Synthetix: YFIRewards.sol
28 *
29 * Docs: https://docs.synthetix.io/
30 *
31 *
32 * MIT License
33 * ===========
34 *
35 * Copyright (c) 2020 Synthetix
36 *
37 * Permission is hereby granted, free of charge, to any person obtaining a copy
38 * of this software and associated documentation files (the "Software"), to deal
39 * in the Software without restriction, including without limitation the rights
40 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
41 * copies of the Software, and to permit persons to whom the Software is
42 * furnished to do so, subject to the following conditions:
43 *
44 * The above copyright notice and this permission notice shall be included in all
45 * copies or substantial portions of the Software.
46 *
47 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
48 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
49 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
50 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
51 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
52 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
53 */
54 
55 // File: @openzeppelin/contracts/math/Math.sol
56 
57 pragma solidity ^0.5.0;
58 
59 /**
60  * @dev Standard math utilities missing in the Solidity language.
61  */
62 library Math {
63     /**
64      * @dev Returns the largest of two numbers.
65      */
66     function max(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a >= b ? a : b;
68     }
69 
70     /**
71      * @dev Returns the smallest of two numbers.
72      */
73     function min(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a < b ? a : b;
75     }
76 
77     /**
78      * @dev Returns the average of two numbers. The result is rounded towards
79      * zero.
80      */
81     function average(uint256 a, uint256 b) internal pure returns (uint256) {
82         // (a + b) / 2 can overflow, so we distribute
83         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
84     }
85 }
86 
87 // File: @openzeppelin/contracts/math/SafeMath.sol
88 
89 pragma solidity ^0.5.0;
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      * - Addition cannot overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return sub(a, b, "SafeMath: subtraction overflow");
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      * - Subtraction cannot overflow.
142      *
143      * _Available since v2.4.0._
144      */
145     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b <= a, errorMessage);
147         uint256 c = a - b;
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `*` operator.
157      *
158      * Requirements:
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) {
166             return 0;
167         }
168 
169         uint256 c = a * b;
170         require(c / a == b, "SafeMath: multiplication overflow");
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         return div(a, b, "SafeMath: division by zero");
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      *
201      * _Available since v2.4.0._
202      */
203     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         // Solidity only automatically asserts when dividing by 0
205         require(b > 0, errorMessage);
206         uint256 c = a / b;
207         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         return mod(a, b, "SafeMath: modulo by zero");
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts with custom message when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      * - The divisor cannot be zero.
237      *
238      * _Available since v2.4.0._
239      */
240     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b != 0, errorMessage);
242         return a % b;
243     }
244 }
245 
246 // File: @openzeppelin/contracts/GSN/Context.sol
247 
248 pragma solidity ^0.5.0;
249 
250 /*
251  * @dev Provides information about the current execution context, including the
252  * sender of the transaction and its data. While these are generally available
253  * via msg.sender and msg.data, they should not be accessed in such a direct
254  * manner, since when dealing with GSN meta-transactions the account sending and
255  * paying for execution may not be the actual sender (as far as an application
256  * is concerned).
257  *
258  * This contract is only required for intermediate, library-like contracts.
259  */
260 contract Context {
261     // Empty internal constructor, to prevent people from mistakenly deploying
262     // an instance of this contract, which should be used via inheritance.
263     constructor () internal {}
264     // solhint-disable-previous-line no-empty-blocks
265 
266     function _msgSender() internal view returns (address payable) {
267         return msg.sender;
268     }
269 
270     function _msgData() internal view returns (bytes memory) {
271         this;
272         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
273         return msg.data;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/ownership/Ownable.sol
278 
279 pragma solidity ^0.5.0;
280 
281 /**
282  * @dev Contract module which provides a basic access control mechanism, where
283  * there is an account (an owner) that can be granted exclusive access to
284  * specific functions.
285  *
286  * This module is used through inheritance. It will make available the modifier
287  * `onlyOwner`, which can be applied to your functions to restrict their use to
288  * the owner.
289  */
290 contract Ownable is Context {
291     address private _owner;
292 
293     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
294 
295     /**
296      * @dev Initializes the contract setting the deployer as the initial owner.
297      */
298     constructor () internal {
299         _owner = _msgSender();
300         emit OwnershipTransferred(address(0), _owner);
301     }
302 
303     /**
304      * @dev Returns the address of the current owner.
305      */
306     function owner() public view returns (address) {
307         return _owner;
308     }
309 
310     /**
311      * @dev Throws if called by any account other than the owner.
312      */
313     modifier onlyOwner() {
314         require(isOwner(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     /**
319      * @dev Returns true if the caller is the current owner.
320      */
321     function isOwner() public view returns (bool) {
322         return _msgSender() == _owner;
323     }
324 
325     /**
326      * @dev Leaves the contract without owner. It will not be possible to call
327      * `onlyOwner` functions anymore. Can only be called by the current owner.
328      *
329      * NOTE: Renouncing ownership will leave the contract without an owner,
330      * thereby removing any functionality that is only available to the owner.
331      */
332     function renounceOwnership() public onlyOwner {
333         emit OwnershipTransferred(_owner, address(0));
334         _owner = address(0);
335     }
336 
337     /**
338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
339      * Can only be called by the current owner.
340      */
341     function transferOwnership(address newOwner) public onlyOwner {
342         _transferOwnership(newOwner);
343     }
344 
345     /**
346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
347      */
348     function _transferOwnership(address newOwner) internal {
349         require(newOwner != address(0), "Ownable: new owner is the zero address");
350         emit OwnershipTransferred(_owner, newOwner);
351         _owner = newOwner;
352     }
353 }
354 
355 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
356 
357 pragma solidity ^0.5.0;
358 
359 /**
360  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
361  * the optional functions; to access them see {ERC20Detailed}.
362  */
363 interface IERC20 {
364     /**
365      * @dev Returns the amount of tokens in existence.
366      */
367     function totalSupply() external view returns (uint256);
368 
369     /**
370      * @dev Returns the amount of tokens owned by `account`.
371      */
372     function balanceOf(address account) external view returns (uint256);
373 
374     /**
375      * @dev Moves `amount` tokens from the caller's account to `recipient`.
376      *
377      * Returns a boolean value indicating whether the operation succeeded.
378      *
379      * Emits a {Transfer} event.
380      */
381     function transfer(address recipient, uint256 amount) external returns (bool);
382 
383     function mint(address account, uint amount) external;
384 
385     function burn(uint amount) external;
386 
387     /**
388      * @dev Returns the remaining number of tokens that `spender` will be
389      * allowed to spend on behalf of `owner` through {transferFrom}. This is
390      * zero by default.
391      *
392      * This value changes when {approve} or {transferFrom} are called.
393      */
394     function allowance(address owner, address spender) external view returns (uint256);
395 
396     /**
397      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * IMPORTANT: Beware that changing an allowance with this method brings the risk
402      * that someone may use both the old and the new allowance by unfortunate
403      * transaction ordering. One possible solution to mitigate this race
404      * condition is to first reduce the spender's allowance to 0 and set the
405      * desired value afterwards:
406      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
407      *
408      * Emits an {Approval} event.
409      */
410     function approve(address spender, uint256 amount) external returns (bool);
411 
412     /**
413      * @dev Moves `amount` tokens from `sender` to `recipient` using the
414      * allowance mechanism. `amount` is then deducted from the caller's
415      * allowance.
416      *
417      * Returns a boolean value indicating whether the operation succeeded.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
422 
423     /**
424      * @dev Emitted when `value` tokens are moved from one account (`from`) to
425      * another (`to`).
426      *
427      * Note that `value` may be zero.
428      */
429     event Transfer(address indexed from, address indexed to, uint256 value);
430 
431     /**
432      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
433      * a call to {approve}. `value` is the new allowance.
434      */
435     event Approval(address indexed owner, address indexed spender, uint256 value);
436 }
437 
438 // File: @openzeppelin/contracts/utils/Address.sol
439 
440 pragma solidity ^0.5.5;
441 
442 /**
443  * @dev Collection of functions related to the address type
444  */
445 library Address {
446     /**
447      * @dev Returns true if `account` is a contract.
448      *
449      * This test is non-exhaustive, and there may be false-negatives: during the
450      * execution of a contract's constructor, its address will be reported as
451      * not containing a contract.
452      *
453      * IMPORTANT: It is unsafe to assume that an address for which this
454      * function returns false is an externally-owned account (EOA) and not a
455      * contract.
456      */
457     function isContract(address account) internal view returns (bool) {
458         // This method relies in extcodesize, which returns 0 for contracts in
459         // construction, since the code is only stored at the end of the
460         // constructor execution.
461 
462         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
463         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
464         // for accounts without code, i.e. `keccak256('')`
465         bytes32 codehash;
466         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
467         // solhint-disable-next-line no-inline-assembly
468         assembly {codehash := extcodehash(account)}
469         return (codehash != 0x0 && codehash != accountHash);
470     }
471 
472     /**
473      * @dev Converts an `address` into `address payable`. Note that this is
474      * simply a type cast: the actual underlying value is not changed.
475      *
476      * _Available since v2.4.0._
477      */
478     function toPayable(address account) internal pure returns (address payable) {
479         return address(uint160(account));
480     }
481 
482     /**
483      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
484      * `recipient`, forwarding all available gas and reverting on errors.
485      *
486      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
487      * of certain opcodes, possibly making contracts go over the 2300 gas limit
488      * imposed by `transfer`, making them unable to receive funds via
489      * `transfer`. {sendValue} removes this limitation.
490      *
491      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
492      *
493      * IMPORTANT: because control is transferred to `recipient`, care must be
494      * taken to not create reentrancy vulnerabilities. Consider using
495      * {ReentrancyGuard} or the
496      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
497      *
498      * _Available since v2.4.0._
499      */
500     function sendValue(address payable recipient, uint256 amount) internal {
501         require(address(this).balance >= amount, "Address: insufficient balance");
502 
503         // solhint-disable-next-line avoid-call-value
504         (bool success,) = recipient.call.value(amount)("");
505         require(success, "Address: unable to send value, recipient may have reverted");
506     }
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
510 
511 pragma solidity ^0.5.0;
512 
513 
514 
515 
516 /**
517  * @title SafeERC20
518  * @dev Wrappers around ERC20 operations that throw on failure (when the token
519  * contract returns false). Tokens that return no value (and instead revert or
520  * throw on failure) are also supported, non-reverting calls are assumed to be
521  * successful.
522  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
523  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
524  */
525 library SafeERC20 {
526     using SafeMath for uint256;
527     using Address for address;
528 
529     function safeTransfer(IERC20 token, address to, uint256 value) internal {
530         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
531     }
532 
533     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
534         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
535     }
536 
537     function safeApprove(IERC20 token, address spender, uint256 value) internal {
538         // safeApprove should only be called when setting an initial allowance,
539         // or when resetting it to zero. To increase and decrease it, use
540         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
541         // solhint-disable-next-line max-line-length
542         require((value == 0) || (token.allowance(address(this), spender) == 0),
543             "SafeERC20: approve from non-zero to non-zero allowance"
544         );
545         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
546     }
547 
548     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
549         uint256 newAllowance = token.allowance(address(this), spender).add(value);
550         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
551     }
552 
553     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
554         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
555         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
556     }
557 
558     /**
559      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
560      * on the return value: the return value is optional (but if data is returned, it must not be false).
561      * @param token The token targeted by the call.
562      * @param data The call data (encoded using abi.encode or one of its variants).
563      */
564     function callOptionalReturn(IERC20 token, bytes memory data) private {
565         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
566         // we're implementing it ourselves.
567 
568         // A Solidity high level call has three parts:
569         //  1. The target address is checked to verify it contains contract code
570         //  2. The call itself is made, and success asserted
571         //  3. The return value is decoded, which in turn checks the size of the returned data.
572         // solhint-disable-next-line max-line-length
573         require(address(token).isContract(), "SafeERC20: call to non-contract");
574 
575         // solhint-disable-next-line avoid-low-level-calls
576         (bool success, bytes memory returndata) = address(token).call(data);
577         require(success, "SafeERC20: low-level call failed");
578 
579         if (returndata.length > 0) {// Return data is optional
580             // solhint-disable-next-line max-line-length
581             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
582         }
583     }
584 }
585 
586 // File: contracts/IRewardDistributionRecipient.sol
587 
588 pragma solidity ^0.5.0;
589 
590 
591 contract IRewardDistributionRecipient is Ownable {
592     address public rewardReferral;
593 
594     function notifyRewardAmount(uint256 reward) external;
595 
596     function setRewardReferral(address _rewardReferral) external onlyOwner {
597         rewardReferral = _rewardReferral;
598     }
599 }
600 
601 // File: contracts/CurveRewards.sol
602 
603 pragma solidity ^0.5.0;
604 
605 
606 contract LPTokenWrapper {
607     using SafeMath for uint256;
608     using SafeERC20 for IERC20;
609     using Address for address;
610 
611     IERC20 public y = IERC20(0x5E7967eeCD8828f5c50b5d1892dA091FB797eCb6);
612 
613     uint256 private _totalSupply;
614     mapping(address => uint256) private _balances;
615 
616     function totalSupply() public view returns (uint256) {
617         return _totalSupply;
618     }
619 
620     function balanceOf(address account) public view returns (uint256) {
621         return _balances[account];
622     }
623 
624     function tokenStake(uint256 amount) internal {
625         address sender = msg.sender;
626         require(!address(sender).isContract(), "Andre, we are farming in peace, go harvest somewhere else sir.");
627         require(tx.origin == sender, "Andre, stahp.");
628         _totalSupply = _totalSupply.add(amount);
629         _balances[sender] = _balances[sender].add(amount);
630         y.safeTransferFrom(sender, address(this), amount);
631     }
632 
633     function tokenWithdraw(uint256 amount) internal {
634         _totalSupply = _totalSupply.sub(amount);
635         _balances[msg.sender] = _balances[msg.sender].sub(amount);
636         y.safeTransfer(msg.sender, amount);
637     }
638 }
639 
640 interface IULUReferral {
641     function setReferrer(address farmer, address referrer) external;
642     function getReferrer(address farmer) external view returns (address);
643 }
644 
645 contract ULURewardsLINKPool is LPTokenWrapper, IRewardDistributionRecipient {
646     IERC20 public yfv = IERC20(0x035bfe6057E15Ea692c0DfdcaB3BB41a64Dd2aD4);
647 
648     uint256 public constant DURATION = 7 days;
649     uint8 public constant NUMBER_EPOCHS = 10;
650 
651     uint256 public constant REFERRAL_COMMISSION_PERCENT = 5;
652 
653     uint256 public constant EPOCH_REWARD = 2100 ether;
654     uint256 public constant TOTAL_REWARD = EPOCH_REWARD * NUMBER_EPOCHS;
655 
656     uint256 public currentEpochReward = EPOCH_REWARD;
657     uint256 public totalAccumulatedReward = 0;
658     uint8 public currentEpoch = 0;
659     uint256 public starttime = 1599310800; // Saturday, September 5, 2020 13:00:00 PM (GMT+0)
660     uint256 public periodFinish = 0;
661     uint256 public rewardRate = 0;
662     uint256 public lastUpdateTime;
663     uint256 public rewardPerTokenStored;
664     mapping(address => uint256) public userRewardPerTokenPaid;
665     mapping(address => uint256) public rewards;
666 
667     mapping(address => uint256) public accumulatedStakingPower; // will accumulate every time staker does getReward()
668 
669     uint public nextRewardMultiplier = 75; // 0% -> 200%
670 
671     event RewardAdded(uint256 reward);
672     event Burned(uint256 reward);
673     event Staked(address indexed user, uint256 amount);
674     event Withdrawn(address indexed user, uint256 amount);
675     event RewardPaid(address indexed user, uint256 reward);
676     event CommissionPaid(address indexed user, uint256 reward);
677 
678     modifier updateReward(address account) {
679         rewardPerTokenStored = rewardPerToken();
680         lastUpdateTime = lastTimeRewardApplicable();
681         if (account != address(0)) {
682             rewards[account] = earned(account);
683             userRewardPerTokenPaid[account] = rewardPerTokenStored;
684         }
685         _;
686     }
687 
688     function setNextRewardMultiplier(uint _nextRewardMultiplier) public onlyOwner {
689         require(_nextRewardMultiplier <= 200);
690         nextRewardMultiplier = _nextRewardMultiplier;
691     }
692 
693     function lastTimeRewardApplicable() public view returns (uint256) {
694         return Math.min(block.timestamp, periodFinish);
695     }
696 
697     function rewardPerToken() public view returns (uint256) {
698         if (totalSupply() == 0) {
699             return rewardPerTokenStored;
700         }
701         return
702         rewardPerTokenStored.add(
703             lastTimeRewardApplicable()
704             .sub(lastUpdateTime)
705             .mul(rewardRate)
706             .mul(1e18)
707             .div(totalSupply())
708         );
709     }
710 
711     function earned(address account) public view returns (uint256) {
712         uint256 calculatedEarned = balanceOf(account)
713             .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
714             .div(1e18)
715             .add(rewards[account]);
716         uint256 poolBalance = yfv.balanceOf(address(this));
717         // some rare case the reward can be slightly bigger than real number, we need to check against how much we have left in pool
718         if (calculatedEarned > poolBalance) return poolBalance;
719         return calculatedEarned;
720     }
721 
722     function stakingPower(address account) public view returns (uint256) {
723         return accumulatedStakingPower[account].add(earned(account));
724     }
725 
726     function stake(uint256 amount, address referrer) public updateReward(msg.sender) checkNextEpoch checkStart {
727         require(amount > 0, "Cannot stake 0");
728         require(referrer != msg.sender, "You cannot refer yourself.");
729         super.tokenStake(amount);
730         emit Staked(msg.sender, amount);
731         if (rewardReferral != address(0) && referrer != address(0)) {
732             IULUReferral(rewardReferral).setReferrer(msg.sender, referrer);
733         }
734     }
735 
736     function withdraw(uint256 amount) public updateReward(msg.sender) checkNextEpoch checkStart {
737         require(amount > 0, "Cannot withdraw 0");
738         super.tokenWithdraw(amount);
739         emit Withdrawn(msg.sender, amount);
740     }
741 
742     function exit() external {
743         withdraw(balanceOf(msg.sender));
744         getReward();
745     }
746 
747     function getReward() public updateReward(msg.sender) checkNextEpoch checkStart returns (uint256) {
748         uint256 reward = earned(msg.sender);
749         if (reward > 1) {
750             accumulatedStakingPower[msg.sender] = accumulatedStakingPower[msg.sender].add(rewards[msg.sender]);
751             rewards[msg.sender] = 0;
752 
753             uint256 actualPaid = reward.mul(100 - REFERRAL_COMMISSION_PERCENT).div(100); // 95%
754             uint256 commission = reward - actualPaid; // 5%
755 
756             yfv.safeTransfer(msg.sender, actualPaid);
757             emit RewardPaid(msg.sender, actualPaid);
758 
759             address referrer = address(0);
760             if (rewardReferral != address(0)) {
761                 referrer = IULUReferral(rewardReferral).getReferrer(msg.sender);
762             }
763             if (referrer != address(0)) { // send commission to referrer
764                 yfv.safeTransfer(referrer, commission);
765                 emit CommissionPaid(referrer, commission);
766             } else {// or burn
767                 yfv.burn(commission);
768                 emit Burned(commission);
769             }
770 
771             return actualPaid;
772         }
773         return 0;
774     }
775 
776     modifier checkNextEpoch() {
777         if (block.timestamp >= periodFinish) {
778             currentEpochReward = currentEpochReward.mul(nextRewardMultiplier).div(100); // x0.00 -> x2.00
779 
780             if (totalAccumulatedReward.add(currentEpochReward) > TOTAL_REWARD) {
781                 currentEpochReward = TOTAL_REWARD.sub(totalAccumulatedReward); // limit total reward
782             }
783 
784             if (currentEpochReward > 0) {
785                 yfv.mint(address(this), currentEpochReward);
786                 totalAccumulatedReward = totalAccumulatedReward.add(currentEpochReward);
787                 currentEpoch++;
788             }
789 
790             rewardRate = currentEpochReward.div(DURATION);
791             lastUpdateTime = block.timestamp;
792             periodFinish = block.timestamp.add(DURATION);
793             emit RewardAdded(currentEpochReward);
794         }
795         _;
796     }
797 
798     modifier checkStart() {
799         require(block.timestamp > starttime, "not start");
800         require(periodFinish > 0, "Pool has not started");
801         _;
802     }
803 
804     function notifyRewardAmount(uint256 reward) external onlyOwner updateReward(address(0)) {
805         require(periodFinish == 0, "Only can call once to start staking");
806         currentEpochReward = reward;
807 
808         if (totalAccumulatedReward.add(currentEpochReward) > TOTAL_REWARD) {
809             currentEpochReward = TOTAL_REWARD.sub(totalAccumulatedReward); // limit total reward
810         }
811 
812         rewardRate = currentEpochReward.div(DURATION);
813         yfv.mint(address(this), currentEpochReward);
814         totalAccumulatedReward = totalAccumulatedReward.add(currentEpochReward);
815         currentEpoch++;
816         lastUpdateTime = block.timestamp;
817         periodFinish = block.timestamp.add(DURATION);
818         emit RewardAdded(currentEpochReward);
819     }
820 }