1 pragma solidity ^0.5.0;
2 pragma solidity ^0.5.0;
3 pragma solidity ^0.5.0;
4 pragma solidity ^0.5.0;
5 pragma solidity ^0.5.0;
6 pragma solidity ^0.5.5;
7 pragma solidity ^0.5.0;
8 pragma solidity ^0.5.0;
9 pragma solidity ^0.5.0;
10 
11 
12 /**
13  *Submitted for verification at Etherscan.io on 2020-07-17
14 */
15 /*
16    ____            __   __        __   _
17   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
18  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
19 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
20      /___/
21 *
22 * Docs: https://docs.synthetix.io/
23 *
24 *
25 * MIT License
26 * ===========
27 *
28 * Copyright (c) 2020 Synthetix
29 *
30 * Permission is hereby granted, free of charge, to any person obtaining a copy
31 * of this software and associated documentation files (the "Software"), to deal
32 * in the Software without restriction, including without limitation the rights
33 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
34 * copies of the Software, and to permit persons to whom the Software is
35 * furnished to do so, subject to the following conditions:
36 *
37 * The above copyright notice and this permission notice shall be included in all
38 * copies or substantial portions of the Software.
39 *
40 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
41 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
42 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
43 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
44 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
45 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
46 */
47 // File: @openzeppelin/contracts/math/Math.sol
48 /**
49  * @dev Standard math utilities missing in the Solidity language.
50  */
51 library Math {
52     /**
53      * @dev Returns the largest of two numbers.
54      */
55     function max(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a >= b ? a : b;
57     }
58 
59     /**
60      * @dev Returns the smallest of two numbers.
61      */
62     function min(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a < b ? a : b;
64     }
65 
66     /**
67      * @dev Returns the average of two numbers. The result is rounded towards
68      * zero.
69      */
70     function average(uint256 a, uint256 b) internal pure returns (uint256) {
71         // (a + b) / 2 can overflow, so we distribute
72         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/math/SafeMath.sol
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations with added overflow
79  * checks.
80  *
81  * Arithmetic operations in Solidity wrap on overflow. This can easily result
82  * in bugs, because programmers usually assume that an overflow raises an
83  * error, which is the standard behavior in high level programming languages.
84  * `SafeMath` restores this intuition by reverting the transaction when an
85  * operation overflows.
86  *
87  * Using this library instead of the unchecked operations eliminates an entire
88  * class of bugs, so it's recommended to use it always.
89  */
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return sub(a, b, "SafeMath: subtraction overflow");
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      * - Subtraction cannot overflow.
128      *
129      * _Available since v2.4.0._
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint256 c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      *
187      * _Available since v2.4.0._
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         // Solidity only automatically asserts when dividing by 0
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts with custom message when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/GSN/Context.sol
233 /*
234  * @dev Provides information about the current execution context, including the
235  * sender of the transaction and its data. While these are generally available
236  * via msg.sender and msg.data, they should not be accessed in such a direct
237  * manner, since when dealing with GSN meta-transactions the account sending and
238  * paying for execution may not be the actual sender (as far as an application
239  * is concerned).
240  *
241  * This contract is only required for intermediate, library-like contracts.
242  */
243 contract Context {
244     // Empty internal constructor, to prevent people from mistakenly deploying
245     // an instance of this contract, which should be used via inheritance.
246     constructor () internal { }
247     // solhint-disable-previous-line no-empty-blocks
248 
249     function _msgSender() internal view returns (address payable) {
250         return msg.sender;
251     }
252 
253     function _msgData() internal view returns (bytes memory) {
254         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
255         return msg.data;
256     }
257 }
258 
259 // File: @openzeppelin/contracts/ownership/Ownable.sol
260 /**
261  * @dev Contract module which provides a basic access control mechanism, where
262  * there is an account (an owner) that can be granted exclusive access to
263  * specific functions.
264  *
265  * This module is used through inheritance. It will make available the modifier
266  * `onlyOwner`, which can be applied to your functions to restrict their use to
267  * the owner.
268  */
269 contract Ownable is Context {
270     address private _owner;
271 
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273 
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor () internal {
278         _owner = _msgSender();
279         emit OwnershipTransferred(address(0), _owner);
280     }
281 
282     /**
283      * @dev Returns the address of the current owner.
284      */
285     function owner() public view returns (address) {
286         return _owner;
287     }
288 
289     /**
290      * @dev Throws if called by any account other than the owner.
291      */
292     modifier onlyOwner() {
293         require(isOwner(), "Ownable: caller is not the owner");
294         _;
295     }
296 
297     /**
298      * @dev Returns true if the caller is the current owner.
299      */
300     function isOwner() public view returns (bool) {
301         return _msgSender() == _owner;
302     }
303 
304     /**
305      * @dev Leaves the contract without owner. It will not be possible to call
306      * `onlyOwner` functions anymore. Can only be called by the current owner.
307      *
308      * NOTE: Renouncing ownership will leave the contract without an owner,
309      * thereby removing any functionality that is only available to the owner.
310      */
311     function renounceOwnership() public onlyOwner {
312         emit OwnershipTransferred(_owner, address(0));
313         _owner = address(0);
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Can only be called by the current owner.
319      */
320     function transferOwnership(address newOwner) public onlyOwner {
321         _transferOwnership(newOwner);
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      */
327     function _transferOwnership(address newOwner) internal {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
335 /**
336  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
337  * the optional functions; to access them see {ERC20Detailed}.
338  */
339 interface IERC20 {
340     /**
341      * @dev Returns the amount of tokens in existence.
342      */
343     function totalSupply() external view returns (uint256);
344 
345     /**
346      * @dev Returns the amount of tokens owned by `account`.
347      */
348     function balanceOf(address account) external view returns (uint256);
349 
350     /**
351      * @dev Moves `amount` tokens from the caller's account to `recipient`.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * Emits a {Transfer} event.
356      */
357     function transfer(address recipient, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Returns the remaining number of tokens that `spender` will be
361      * allowed to spend on behalf of `owner` through {transferFrom}. This is
362      * zero by default.
363      *
364      * This value changes when {approve} or {transferFrom} are called.
365      */
366     function allowance(address owner, address spender) external view returns (uint256);
367 
368     /**
369      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
370      *
371      * Returns a boolean value indicating whether the operation succeeded.
372      *
373      * IMPORTANT: Beware that changing an allowance with this method brings the risk
374      * that someone may use both the old and the new allowance by unfortunate
375      * transaction ordering. One possible solution to mitigate this race
376      * condition is to first reduce the spender's allowance to 0 and set the
377      * desired value afterwards:
378      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
379      *
380      * Emits an {Approval} event.
381      */
382     function approve(address spender, uint256 amount) external returns (bool);
383 
384     /**
385      * @dev Moves `amount` tokens from `sender` to `recipient` using the
386      * allowance mechanism. `amount` is then deducted from the caller's
387      * allowance.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * Emits a {Transfer} event.
392      */
393     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
394 
395     /**
396      * @dev Emitted when `value` tokens are moved from one account (`from`) to
397      * another (`to`).
398      *
399      * Note that `value` may be zero.
400      */
401     event Transfer(address indexed from, address indexed to, uint256 value);
402 
403     /**
404      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
405      * a call to {approve}. `value` is the new allowance.
406      */
407     event Approval(address indexed owner, address indexed spender, uint256 value);
408 }
409 
410 // File: @openzeppelin/contracts/utils/Address.sol
411 /**
412  * @dev Collection of functions related to the address type
413  */
414 library Address {
415     /**
416      * @dev Returns true if `account` is a contract.
417      *
418      * This test is non-exhaustive, and there may be false-negatives: during the
419      * execution of a contract's constructor, its address will be reported as
420      * not containing a contract.
421      *
422      * IMPORTANT: It is unsafe to assume that an address for which this
423      * function returns false is an externally-owned account (EOA) and not a
424      * contract.
425      */
426     function isContract(address account) internal view returns (bool) {
427         // This method relies in extcodesize, which returns 0 for contracts in
428         // construction, since the code is only stored at the end of the
429         // constructor execution.
430 
431         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
432         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
433         // for accounts without code, i.e. `keccak256('')`
434         bytes32 codehash;
435         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
436         // solhint-disable-next-line no-inline-assembly
437         assembly { codehash := extcodehash(account) }
438         return (codehash != 0x0 && codehash != accountHash);
439     }
440 
441     /**
442      * @dev Converts an `address` into `address payable`. Note that this is
443      * simply a type cast: the actual underlying value is not changed.
444      *
445      * _Available since v2.4.0._
446      */
447     function toPayable(address account) internal pure returns (address payable) {
448         return address(uint160(account));
449     }
450 
451     /**
452      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
453      * `recipient`, forwarding all available gas and reverting on errors.
454      *
455      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
456      * of certain opcodes, possibly making contracts go over the 2300 gas limit
457      * imposed by `transfer`, making them unable to receive funds via
458      * `transfer`. {sendValue} removes this limitation.
459      *
460      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
461      *
462      * IMPORTANT: because control is transferred to `recipient`, care must be
463      * taken to not create reentrancy vulnerabilities. Consider using
464      * {ReentrancyGuard} or the
465      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
466      *
467      * _Available since v2.4.0._
468      */
469     function sendValue(address payable recipient, uint256 amount) internal {
470         require(address(this).balance >= amount, "Address: insufficient balance");
471 
472         // solhint-disable-next-line avoid-call-value
473         (bool success, ) = recipient.call.value(amount)("");
474         require(success, "Address: unable to send value, recipient may have reverted");
475     }
476 }
477 
478 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
479 /**
480  * @title SafeERC20
481  * @dev Wrappers around ERC20 operations that throw on failure (when the token
482  * contract returns false). Tokens that return no value (and instead revert or
483  * throw on failure) are also supported, non-reverting calls are assumed to be
484  * successful.
485  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
486  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
487  */
488 library SafeERC20 {
489     using SafeMath for uint256;
490     using Address for address;
491 
492     function safeTransfer(IERC20 token, address to, uint256 value) internal {
493         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
494     }
495 
496     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
497         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
498     }
499 
500     function safeApprove(IERC20 token, address spender, uint256 value) internal {
501         // safeApprove should only be called when setting an initial allowance,
502         // or when resetting it to zero. To increase and decrease it, use
503         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
504         // solhint-disable-next-line max-line-length
505         require((value == 0) || (token.allowance(address(this), spender) == 0),
506             "SafeERC20: approve from non-zero to non-zero allowance"
507         );
508         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
509     }
510 
511     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
512         uint256 newAllowance = token.allowance(address(this), spender).add(value);
513         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
514     }
515 
516     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
517         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
518         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
519     }
520 
521     /**
522      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
523      * on the return value: the return value is optional (but if data is returned, it must not be false).
524      * @param token The token targeted by the call.
525      * @param data The call data (encoded using abi.encode or one of its variants).
526      */
527     function callOptionalReturn(IERC20 token, bytes memory data) private {
528         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
529         // we're implementing it ourselves.
530 
531         // A Solidity high level call has three parts:
532         //  1. The target address is checked to verify it contains contract code
533         //  2. The call itself is made, and success asserted
534         //  3. The return value is decoded, which in turn checks the size of the returned data.
535         // solhint-disable-next-line max-line-length
536         require(address(token).isContract(), "SafeERC20: call to non-contract");
537 
538         // solhint-disable-next-line avoid-low-level-calls
539         (bool success, bytes memory returndata) = address(token).call(data);
540         require(success, "SafeERC20: low-level call failed");
541 
542         if (returndata.length > 0) { // Return data is optional
543             // solhint-disable-next-line max-line-length
544             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
545         }
546     }
547 }
548 
549 // File: contracts/IRewardDistributionRecipient.sol
550 contract IRewardDistributionRecipient is Ownable {
551     address public rewardDistribution;
552 
553     function notifyRewardAmount(uint256 reward) external;
554 
555     modifier onlyRewardDistribution() {
556         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
557         _;
558     }
559 
560     constructor () public {
561         rewardDistribution = msg.sender;
562     }
563 }
564 
565 contract LPTokenWrapper {
566     using SafeMath for uint256;
567     using SafeERC20 for IERC20;
568 
569     IERC20 public ympl_eth_uni_lp = IERC20(0xBf31956808E3352a4B215d7050e382A2078B5fF9);
570 
571     uint256 private _totalSupply;
572     mapping(address => uint256) private _balances;
573 
574     function totalSupply() public view returns (uint256) {
575         return _totalSupply;
576     }
577 
578     function balanceOf(address account) public view returns (uint256) {
579         return _balances[account];
580     }
581 
582     function stake(uint256 amount) public {
583         _totalSupply = _totalSupply.add(amount);
584         _balances[msg.sender] = _balances[msg.sender].add(amount);
585         ympl_eth_uni_lp.safeTransferFrom(msg.sender, address(this), amount);
586     }
587 
588     function withdraw(uint256 amount) public {
589         _totalSupply = _totalSupply.sub(amount);
590         _balances[msg.sender] = _balances[msg.sender].sub(amount);
591         ympl_eth_uni_lp.safeTransfer(msg.sender, amount);
592     }
593 }
594 
595 contract YmplUniPool is LPTokenWrapper, IRewardDistributionRecipient {
596     IERC20 public ympi = IERC20(0x7caB389883c4C92A9F57351755eb06538C4EDA68);
597     uint256 public constant DURATION = 2592000; // 4 weeks
598 
599     // 8/26/2020 1PM UTC
600     uint256 public starttime = 1598446800;
601     uint256 public periodFinish = 0;
602     uint256 public rewardRate = 0;
603     uint256 public lastUpdateTime;
604     uint256 public rewardPerTokenStored;
605     mapping(address => uint256) public userRewardPerTokenPaid;
606     mapping(address => uint256) public rewards;
607 
608     event RewardAdded(uint256 reward);
609     event Staked(address indexed user, uint256 amount);
610     event Withdrawn(address indexed user, uint256 amount);
611     event RewardPaid(address indexed user, uint256 reward);
612 
613     modifier checkStart(){
614         require(block.timestamp >= starttime,"not start");
615         _;
616     }
617 
618     modifier updateReward(address account) {
619         rewardPerTokenStored = rewardPerToken();
620         lastUpdateTime = lastTimeRewardApplicable();
621         if (account != address(0)) {
622             rewards[account] = earned(account);
623             userRewardPerTokenPaid[account] = rewardPerTokenStored;
624         }
625         _;
626     }
627 
628     function lastTimeRewardApplicable() public view returns (uint256) {
629         return Math.min(block.timestamp, periodFinish);
630     }
631 
632     function rewardPerToken() public view returns (uint256) {
633         if (totalSupply() == 0) {
634             return rewardPerTokenStored;
635         }
636         return
637             rewardPerTokenStored.add(
638                 lastTimeRewardApplicable()
639                     .sub(lastUpdateTime)
640                     .mul(rewardRate)
641                     .mul(1e18)
642                     .div(totalSupply())
643             );
644     }
645 
646     function earned(address account) public view returns (uint256) {
647         return
648             balanceOf(account)
649                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
650                 .div(1e18)
651                 .add(rewards[account]);
652     }
653 
654     // stake visibility is public as overriding LPTokenWrapper's stake() function
655     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
656         require(amount > 0, "Cannot stake 0");
657         super.stake(amount);
658         emit Staked(msg.sender, amount);
659     }
660 
661     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
662         require(amount > 0, "Cannot withdraw 0");
663         super.withdraw(amount);
664         emit Withdrawn(msg.sender, amount);
665     }
666 
667     function exit() external {
668         withdraw(balanceOf(msg.sender));
669         getReward();
670     }
671 
672     function getReward() public updateReward(msg.sender) checkStart {
673         uint256 reward = earned(msg.sender);
674         if (reward > 0) {
675             rewards[msg.sender] = 0;
676             ympi.safeTransfer(msg.sender, reward);
677             emit RewardPaid(msg.sender, reward);
678         }
679     }
680 
681     function notifyRewardAmount(uint256 reward)
682         external
683         onlyRewardDistribution
684         updateReward(address(0))
685     {
686         if (block.timestamp > starttime) {
687           if (block.timestamp >= periodFinish) {
688               rewardRate = reward.div(DURATION);
689           } else {
690               uint256 remaining = periodFinish.sub(block.timestamp);
691               uint256 leftover = remaining.mul(rewardRate);
692               rewardRate = reward.add(leftover).div(DURATION);
693           }
694           lastUpdateTime = block.timestamp;
695           periodFinish = block.timestamp.add(DURATION);
696           emit RewardAdded(reward);
697         } else {
698           rewardRate = reward.div(DURATION);
699           lastUpdateTime = starttime;
700           periodFinish = starttime.add(DURATION);
701           emit RewardAdded(reward);
702         }
703     }
704 }