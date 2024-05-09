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
12 /*
13    ____            __   __        __   _
14   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
15  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
16 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
17      /___/
18 
19 * Synthetix: GRAPRewards.sol
20 *
21 * Docs: https://docs.synthetix.io/
22 *
23 *
24 * MIT License
25 * ===========
26 *
27 * Copyright (c) 2020 Synthetix
28 *
29 * Permission is hereby granted, free of charge, to any person obtaining a copy
30 * of this software and associated documentation files (the "Software"), to deal
31 * in the Software without restriction, including without limitation the rights
32 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
33 * copies of the Software, and to permit persons to whom the Software is
34 * furnished to do so, subject to the following conditions:
35 *
36 * The above copyright notice and this permission notice shall be included in all
37 * copies or substantial portions of the Software.
38 *
39 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
40 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
41 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
42 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
43 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
44 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
45 */
46 // File: @openzeppelin/contracts/math/Math.sol
47 /**
48  * @dev Standard math utilities missing in the Solidity language.
49  */
50 library Math {
51     /**
52      * @dev Returns the largest of two numbers.
53      */
54     function max(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a >= b ? a : b;
56     }
57 
58     /**
59      * @dev Returns the smallest of two numbers.
60      */
61     function min(uint256 a, uint256 b) internal pure returns (uint256) {
62         return a < b ? a : b;
63     }
64 
65     /**
66      * @dev Returns the average of two numbers. The result is rounded towards
67      * zero.
68      */
69     function average(uint256 a, uint256 b) internal pure returns (uint256) {
70         // (a + b) / 2 can overflow, so we distribute
71         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/math/SafeMath.sol
76 /**
77  * @dev Wrappers over Solidity's arithmetic operations with added overflow
78  * checks.
79  *
80  * Arithmetic operations in Solidity wrap on overflow. This can easily result
81  * in bugs, because programmers usually assume that an overflow raises an
82  * error, which is the standard behavior in high level programming languages.
83  * `SafeMath` restores this intuition by reverting the transaction when an
84  * operation overflows.
85  *
86  * Using this library instead of the unchecked operations eliminates an entire
87  * class of bugs, so it's recommended to use it always.
88  */
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      * - Subtraction cannot overflow.
127      *
128      * _Available since v2.4.0._
129      */
130     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b <= a, errorMessage);
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      * - The divisor cannot be zero.
185      *
186      * _Available since v2.4.0._
187      */
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         // Solidity only automatically asserts when dividing by 0
190         require(b > 0, errorMessage);
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      * - The divisor cannot be zero.
222      *
223      * _Available since v2.4.0._
224      */
225     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b != 0, errorMessage);
227         return a % b;
228     }
229 }
230 
231 // File: @openzeppelin/contracts/GSN/Context.sol
232 /*
233  * @dev Provides information about the current execution context, including the
234  * sender of the transaction and its data. While these are generally available
235  * via msg.sender and msg.data, they should not be accessed in such a direct
236  * manner, since when dealing with GSN meta-transactions the account sending and
237  * paying for execution may not be the actual sender (as far as an application
238  * is concerned).
239  *
240  * This contract is only required for intermediate, library-like contracts.
241  */
242 contract Context {
243     // Empty internal constructor, to prevent people from mistakenly deploying
244     // an instance of this contract, which should be used via inheritance.
245     constructor () internal { }
246     // solhint-disable-previous-line no-empty-blocks
247 
248     function _msgSender() internal view returns (address payable) {
249         return msg.sender;
250     }
251 
252     function _msgData() internal view returns (bytes memory) {
253         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
254         return msg.data;
255     }
256 }
257 
258 // File: @openzeppelin/contracts/ownership/Ownable.sol
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * This module is used through inheritance. It will make available the modifier
265  * `onlyOwner`, which can be applied to your functions to restrict their use to
266  * the owner.
267  */
268 contract Ownable is Context {
269     address private _owner;
270 
271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272 
273     /**
274      * @dev Initializes the contract setting the deployer as the initial owner.
275      */
276     constructor () internal {
277         _owner = _msgSender();
278         emit OwnershipTransferred(address(0), _owner);
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(isOwner(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Returns true if the caller is the current owner.
298      */
299     function isOwner() public view returns (bool) {
300         return _msgSender() == _owner;
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public onlyOwner {
311         emit OwnershipTransferred(_owner, address(0));
312         _owner = address(0);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public onlyOwner {
320         _transferOwnership(newOwner);
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      */
326     function _transferOwnership(address newOwner) internal {
327         require(newOwner != address(0), "Ownable: new owner is the zero address");
328         emit OwnershipTransferred(_owner, newOwner);
329         _owner = newOwner;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
334 /**
335  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
336  * the optional functions; to access them see {ERC20Detailed}.
337  */
338 interface IERC20 {
339     /**
340      * @dev Returns the amount of tokens in existence.
341      */
342     function totalSupply() external view returns (uint256);
343 
344     /**
345      * @dev Returns the amount of tokens owned by `account`.
346      */
347     function balanceOf(address account) external view returns (uint256);
348 
349     /**
350      * @dev Moves `amount` tokens from the caller's account to `recipient`.
351      *
352      * Returns a boolean value indicating whether the operation succeeded.
353      *
354      * Emits a {Transfer} event.
355      */
356     function transfer(address recipient, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Returns the remaining number of tokens that `spender` will be
360      * allowed to spend on behalf of `owner` through {transferFrom}. This is
361      * zero by default.
362      *
363      * This value changes when {approve} or {transferFrom} are called.
364      */
365     function allowance(address owner, address spender) external view returns (uint256);
366 
367     /**
368      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * IMPORTANT: Beware that changing an allowance with this method brings the risk
373      * that someone may use both the old and the new allowance by unfortunate
374      * transaction ordering. One possible solution to mitigate this race
375      * condition is to first reduce the spender's allowance to 0 and set the
376      * desired value afterwards:
377      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
378      *
379      * Emits an {Approval} event.
380      */
381     function approve(address spender, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Moves `amount` tokens from `sender` to `recipient` using the
385      * allowance mechanism. `amount` is then deducted from the caller's
386      * allowance.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
393 
394     /**
395      * @dev Emitted when `value` tokens are moved from one account (`from`) to
396      * another (`to`).
397      *
398      * Note that `value` may be zero.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 value);
401 
402     /**
403      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
404      * a call to {approve}. `value` is the new allowance.
405      */
406     event Approval(address indexed owner, address indexed spender, uint256 value);
407 }
408 
409 // File: @openzeppelin/contracts/utils/Address.sol
410 /**
411  * @dev Collection of functions related to the address type
412  */
413 library Address {
414     /**
415      * @dev Returns true if `account` is a contract.
416      *
417      * This test is non-exhaustive, and there may be false-negatives: during the
418      * execution of a contract's constructor, its address will be reported as
419      * not containing a contract.
420      *
421      * IMPORTANT: It is unsafe to assume that an address for which this
422      * function returns false is an externally-owned account (EOA) and not a
423      * contract.
424      */
425     function isContract(address account) internal view returns (bool) {
426         // This method relies in extcodesize, which returns 0 for contracts in
427         // construction, since the code is only stored at the end of the
428         // constructor execution.
429 
430         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
431         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
432         // for accounts without code, i.e. `keccak256('')`
433         bytes32 codehash;
434         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
435         // solhint-disable-next-line no-inline-assembly
436         assembly { codehash := extcodehash(account) }
437         return (codehash != 0x0 && codehash != accountHash);
438     }
439 
440     /**
441      * @dev Converts an `address` into `address payable`. Note that this is
442      * simply a type cast: the actual underlying value is not changed.
443      *
444      * _Available since v2.4.0._
445      */
446     function toPayable(address account) internal pure returns (address payable) {
447         return address(uint160(account));
448     }
449 
450     /**
451      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
452      * `recipient`, forwarding all available gas and reverting on errors.
453      *
454      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
455      * of certain opcodes, possibly making contracts go over the 2300 gas limit
456      * imposed by `transfer`, making them unable to receive funds via
457      * `transfer`. {sendValue} removes this limitation.
458      *
459      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
460      *
461      * IMPORTANT: because control is transferred to `recipient`, care must be
462      * taken to not create reentrancy vulnerabilities. Consider using
463      * {ReentrancyGuard} or the
464      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
465      *
466      * _Available since v2.4.0._
467      */
468     function sendValue(address payable recipient, uint256 amount) internal {
469         require(address(this).balance >= amount, "Address: insufficient balance");
470 
471         // solhint-disable-next-line avoid-call-value
472         (bool success, ) = recipient.call.value(amount)("");
473         require(success, "Address: unable to send value, recipient may have reverted");
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
478 /**
479  * @title SafeERC20
480  * @dev Wrappers around ERC20 operations that throw on failure (when the token
481  * contract returns false). Tokens that return no value (and instead revert or
482  * throw on failure) are also supported, non-reverting calls are assumed to be
483  * successful.
484  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
485  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
486  */
487 library SafeERC20 {
488     using SafeMath for uint256;
489     using Address for address;
490 
491     function safeTransfer(IERC20 token, address to, uint256 value) internal {
492         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
493     }
494 
495     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
496         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
497     }
498 
499     function safeApprove(IERC20 token, address spender, uint256 value) internal {
500         // safeApprove should only be called when setting an initial allowance,
501         // or when resetting it to zero. To increase and decrease it, use
502         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
503         // solhint-disable-next-line max-line-length
504         require((value == 0) || (token.allowance(address(this), spender) == 0),
505             "SafeERC20: approve from non-zero to non-zero allowance"
506         );
507         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
508     }
509 
510     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
511         uint256 newAllowance = token.allowance(address(this), spender).add(value);
512         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
513     }
514 
515     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
516         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
517         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
518     }
519 
520     /**
521      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
522      * on the return value: the return value is optional (but if data is returned, it must not be false).
523      * @param token The token targeted by the call.
524      * @param data The call data (encoded using abi.encode or one of its variants).
525      */
526     function callOptionalReturn(IERC20 token, bytes memory data) private {
527         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
528         // we're implementing it ourselves.
529 
530         // A Solidity high level call has three parts:
531         //  1. The target address is checked to verify it contains contract code
532         //  2. The call itself is made, and success asserted
533         //  3. The return value is decoded, which in turn checks the size of the returned data.
534         // solhint-disable-next-line max-line-length
535         require(address(token).isContract(), "SafeERC20: call to non-contract");
536 
537         // solhint-disable-next-line avoid-low-level-calls
538         (bool success, bytes memory returndata) = address(token).call(data);
539         require(success, "SafeERC20: low-level call failed");
540 
541         if (returndata.length > 0) { // Return data is optional
542             // solhint-disable-next-line max-line-length
543             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
544         }
545     }
546 }
547 
548 // File: contracts/IRewardDistributionRecipient.sol
549 contract IRewardDistributionRecipient is Ownable {
550     address public rewardDistribution;
551 
552     function notifyRewardAmount(uint256 reward) external;
553 
554     modifier onlyRewardDistribution() {
555         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
556         _;
557     }
558 
559     function setRewardDistribution(address _rewardDistribution)
560         external
561         onlyOwner
562     {
563         rewardDistribution = _rewardDistribution;
564     }
565 }
566 
567 // File: contracts/CurveRewards.sol
568 interface GRAP {
569     function grapsScalingFactor() external returns (uint256);
570 }
571 
572 contract LPTokenWrapper {
573     using SafeMath for uint256;
574     using SafeERC20 for IERC20;
575 
576     IERC20 public snx = IERC20(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F);
577 
578     uint256 private _totalSupply;
579     mapping(address => uint256) private _balances;
580 
581     function totalSupply() public view returns (uint256) {
582         return _totalSupply;
583     }
584 
585     function balanceOf(address account) public view returns (uint256) {
586         return _balances[account];
587     }
588 
589     function stake(uint256 amount) public {
590         _totalSupply = _totalSupply.add(amount);
591         _balances[msg.sender] = _balances[msg.sender].add(amount);
592         snx.safeTransferFrom(msg.sender, address(this), amount);
593     }
594 
595     function withdraw(uint256 amount) public {
596         _totalSupply = _totalSupply.sub(amount);
597         _balances[msg.sender] = _balances[msg.sender].sub(amount);
598         snx.safeTransfer(msg.sender, amount);
599     }
600 }
601 
602 contract GRAPSNXPool is LPTokenWrapper, IRewardDistributionRecipient {
603     IERC20 public grap = IERC20(0xC8D2AB2a6FdEbC25432E54941cb85b55b9f152dB);
604     uint256 public constant DURATION = 625000; // ~7 1/4 days
605 
606     uint256 public starttime = 1597881600; // 2020-08-20 00:00:00 (UTC +00:00)
607     uint256 public periodFinish = 0;
608     uint256 public rewardRate = 0;
609     uint256 public lastUpdateTime;
610     uint256 public rewardPerTokenStored;
611     mapping(address => uint256) public userRewardPerTokenPaid;
612     mapping(address => uint256) public rewards;
613 
614     event RewardAdded(uint256 reward);
615     event Staked(address indexed user, uint256 amount);
616     event Withdrawn(address indexed user, uint256 amount);
617     event RewardPaid(address indexed user, uint256 reward);
618 
619     modifier checkStart() {
620         require(block.timestamp >= starttime,"not start");
621         _;
622     }
623 
624     modifier updateReward(address account) {
625         rewardPerTokenStored = rewardPerToken();
626         lastUpdateTime = lastTimeRewardApplicable();
627         if (account != address(0)) {
628             rewards[account] = earned(account);
629             userRewardPerTokenPaid[account] = rewardPerTokenStored;
630         }
631         _;
632     }
633 
634     function lastTimeRewardApplicable() public view returns (uint256) {
635         return Math.min(block.timestamp, periodFinish);
636     }
637 
638     function rewardPerToken() public view returns (uint256) {
639         if (totalSupply() == 0) {
640             return rewardPerTokenStored;
641         }
642         return
643             rewardPerTokenStored.add(
644                 lastTimeRewardApplicable()
645                     .sub(lastUpdateTime)
646                     .mul(rewardRate)
647                     .mul(1e18)
648                     .div(totalSupply())
649             );
650     }
651 
652     function earned(address account) public view returns (uint256) {
653         return
654             balanceOf(account)
655                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
656                 .div(1e18)
657                 .add(rewards[account]);
658     }
659 
660     // stake visibility is public as overriding LPTokenWrapper's stake() function
661     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
662         require(amount > 0, "Cannot stake 0");
663         super.stake(amount);
664         emit Staked(msg.sender, amount);
665     }
666 
667     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
668         require(amount > 0, "Cannot withdraw 0");
669         super.withdraw(amount);
670         emit Withdrawn(msg.sender, amount);
671     }
672 
673     function exit() external {
674         withdraw(balanceOf(msg.sender));
675         getReward();
676     }
677 
678     function getReward() public updateReward(msg.sender) checkStart {
679         uint256 reward = earned(msg.sender);
680         if (reward > 0) {
681             rewards[msg.sender] = 0;
682             uint256 scalingFactor = GRAP(address(grap)).grapsScalingFactor();
683             uint256 trueReward = reward.mul(scalingFactor).div(10**18);
684             grap.safeTransfer(msg.sender, trueReward);
685             emit RewardPaid(msg.sender, trueReward);
686         }
687     }
688 
689     function notifyRewardAmount(uint256 reward)
690         external
691         onlyRewardDistribution
692         updateReward(address(0))
693     {
694         if (block.timestamp > starttime) {
695           if (block.timestamp >= periodFinish) {
696               rewardRate = reward.div(DURATION);
697           } else {
698               uint256 remaining = periodFinish.sub(block.timestamp);
699               uint256 leftover = remaining.mul(rewardRate);
700               rewardRate = reward.add(leftover).div(DURATION);
701           }
702           lastUpdateTime = block.timestamp;
703           periodFinish = block.timestamp.add(DURATION);
704           emit RewardAdded(reward);
705         } else {
706           rewardRate = reward.div(DURATION);
707           lastUpdateTime = starttime;
708           periodFinish = starttime.add(DURATION);
709           emit RewardAdded(reward);
710         }
711         // avoid overflow to lock assets
712         uint256 check = DURATION.mul(rewardRate).mul(1e18);
713     }
714 }