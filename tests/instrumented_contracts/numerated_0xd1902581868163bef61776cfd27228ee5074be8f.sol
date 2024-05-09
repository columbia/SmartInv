1 /*
2 
3     /     |  __    / ____|
4    /      | |__) | | |
5   / /    |  _  /  | |
6  / ____   | |    | |____
7 /_/    _ |_|  _  _____|
8 
9 * ARC: staking/StakingRewardsAccrualCapped.sol
10 *
11 * Latest source (may be newer): https://github.com/arcxgame/contracts/blob/master/contracts/staking/StakingRewardsAccrualCapped.sol
12 *
13 * Contract Dependencies: 
14 *	- Accrual
15 *	- Context
16 *	- IStakingRewards
17 *	- Ownable
18 *	- RewardsDistributionRecipient
19 *	- StakingRewards
20 *	- StakingRewardsAccrual
21 * Libraries: 
22 *	- Address
23 *	- Math
24 *	- SafeERC20
25 *	- SafeMath
26 *
27 * MIT License
28 * ===========
29 *
30 * Copyright (c) 2020 ARC
31 *
32 * Permission is hereby granted, free of charge, to any person obtaining a copy
33 * of this software and associated documentation files (the "Software"), to deal
34 * in the Software without restriction, including without limitation the rights
35 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
36 * copies of the Software, and to permit persons to whom the Software is
37 * furnished to do so, subject to the following conditions:
38 *
39 * The above copyright notice and this permission notice shall be included in all
40 * copies or substantial portions of the Software.
41 *
42 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
43 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
44 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
45 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
46 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
47 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
48 */
49 
50 /* ===============================================
51 * Flattened with Solidifier by Coinage
52 * 
53 * https://solidifier.coina.ge
54 * ===============================================
55 */
56 
57 
58 pragma solidity ^0.5.0;
59 
60 /**
61  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
62  * the optional functions; to access them see {ERC20Detailed}.
63  */
64 interface IERC20 {
65     /**
66      * @dev Returns the amount of tokens in existence.
67      */
68     function totalSupply() external view returns (uint256);
69 
70     /**
71      * @dev Returns the amount of tokens owned by `account`.
72      */
73     function balanceOf(address account) external view returns (uint256);
74 
75     /**
76      * @dev Moves `amount` tokens from the caller's account to `recipient`.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transfer(address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Returns the remaining number of tokens that `spender` will be
86      * allowed to spend on behalf of `owner` through {transferFrom}. This is
87      * zero by default.
88      *
89      * This value changes when {approve} or {transferFrom} are called.
90      */
91     function allowance(address owner, address spender) external view returns (uint256);
92 
93     /**
94      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * IMPORTANT: Beware that changing an allowance with this method brings the risk
99      * that someone may use both the old and the new allowance by unfortunate
100      * transaction ordering. One possible solution to mitigate this race
101      * condition is to first reduce the spender's allowance to 0 and set the
102      * desired value afterwards:
103      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104      *
105      * Emits an {Approval} event.
106      */
107     function approve(address spender, uint256 amount) external returns (bool);
108 
109     /**
110      * @dev Moves `amount` tokens from `sender` to `recipient` using the
111      * allowance mechanism. `amount` is then deducted from the caller's
112      * allowance.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Emitted when `value` tokens are moved from one account (`from`) to
122      * another (`to`).
123      *
124      * Note that `value` may be zero.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     /**
129      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
130      * a call to {approve}. `value` is the new allowance.
131      */
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 
136 /**
137  * @dev Wrappers over Solidity's arithmetic operations with added overflow
138  * checks.
139  *
140  * Arithmetic operations in Solidity wrap on overflow. This can easily result
141  * in bugs, because programmers usually assume that an overflow raises an
142  * error, which is the standard behavior in high level programming languages.
143  * `SafeMath` restores this intuition by reverting the transaction when an
144  * operation overflows.
145  *
146  * Using this library instead of the unchecked operations eliminates an entire
147  * class of bugs, so it's recommended to use it always.
148  */
149 library SafeMath {
150     /**
151      * @dev Returns the addition of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `+` operator.
155      *
156      * Requirements:
157      * - Addition cannot overflow.
158      */
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         uint256 c = a + b;
161         require(c >= a, "SafeMath: addition overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      * - Subtraction cannot overflow.
174      */
175     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176         return sub(a, b, "SafeMath: subtraction overflow");
177     }
178 
179     /**
180      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
181      * overflow (when the result is negative).
182      *
183      * Counterpart to Solidity's `-` operator.
184      *
185      * Requirements:
186      * - Subtraction cannot overflow.
187      *
188      * _Available since v2.4.0._
189      */
190     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b <= a, errorMessage);
192         uint256 c = a - b;
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the multiplication of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `*` operator.
202      *
203      * Requirements:
204      * - Multiplication cannot overflow.
205      */
206     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
207         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
208         // benefit is lost if 'b' is also tested.
209         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
210         if (a == 0) {
211             return 0;
212         }
213 
214         uint256 c = a * b;
215         require(c / a == b, "SafeMath: multiplication overflow");
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      * - The divisor cannot be zero.
230      */
231     function div(uint256 a, uint256 b) internal pure returns (uint256) {
232         return div(a, b, "SafeMath: division by zero");
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      *
246      * _Available since v2.4.0._
247      */
248     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         // Solidity only automatically asserts when dividing by 0
250         require(b > 0, errorMessage);
251         uint256 c = a / b;
252         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
253 
254         return c;
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
269         return mod(a, b, "SafeMath: modulo by zero");
270     }
271 
272     /**
273      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
274      * Reverts with custom message when dividing by zero.
275      *
276      * Counterpart to Solidity's `%` operator. This function uses a `revert`
277      * opcode (which leaves remaining gas untouched) while Solidity uses an
278      * invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      * - The divisor cannot be zero.
282      *
283      * _Available since v2.4.0._
284      */
285     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b != 0, errorMessage);
287         return a % b;
288     }
289 }
290 
291 
292 /**
293  * @dev Collection of functions related to the address type
294  */
295 library Address {
296     /**
297      * @dev Returns true if `account` is a contract.
298      *
299      * [IMPORTANT]
300      * ====
301      * It is unsafe to assume that an address for which this function returns
302      * false is an externally-owned account (EOA) and not a contract.
303      *
304      * Among others, `isContract` will return false for the following 
305      * types of addresses:
306      *
307      *  - an externally-owned account
308      *  - a contract in construction
309      *  - an address where a contract will be created
310      *  - an address where a contract lived, but was destroyed
311      * ====
312      */
313     function isContract(address account) internal view returns (bool) {
314         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
315         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
316         // for accounts without code, i.e. `keccak256('')`
317         bytes32 codehash;
318         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
319         // solhint-disable-next-line no-inline-assembly
320         assembly { codehash := extcodehash(account) }
321         return (codehash != accountHash && codehash != 0x0);
322     }
323 
324     /**
325      * @dev Converts an `address` into `address payable`. Note that this is
326      * simply a type cast: the actual underlying value is not changed.
327      *
328      * _Available since v2.4.0._
329      */
330     function toPayable(address account) internal pure returns (address payable) {
331         return address(uint160(account));
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      *
350      * _Available since v2.4.0._
351      */
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(address(this).balance >= amount, "Address: insufficient balance");
354 
355         // solhint-disable-next-line avoid-call-value
356         (bool success, ) = recipient.call.value(amount)("");
357         require(success, "Address: unable to send value, recipient may have reverted");
358     }
359 }
360 
361 
362 /**
363  * @title SafeERC20
364  * @dev Wrappers around ERC20 operations that throw on failure (when the token
365  * contract returns false). Tokens that return no value (and instead revert or
366  * throw on failure) are also supported, non-reverting calls are assumed to be
367  * successful.
368  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
369  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
370  */
371 library SafeERC20 {
372     using SafeMath for uint256;
373     using Address for address;
374 
375     function safeTransfer(IERC20 token, address to, uint256 value) internal {
376         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
377     }
378 
379     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
380         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
381     }
382 
383     function safeApprove(IERC20 token, address spender, uint256 value) internal {
384         // safeApprove should only be called when setting an initial allowance,
385         // or when resetting it to zero. To increase and decrease it, use
386         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
387         // solhint-disable-next-line max-line-length
388         require((value == 0) || (token.allowance(address(this), spender) == 0),
389             "SafeERC20: approve from non-zero to non-zero allowance"
390         );
391         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
392     }
393 
394     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
395         uint256 newAllowance = token.allowance(address(this), spender).add(value);
396         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
397     }
398 
399     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
400         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
401         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
402     }
403 
404     /**
405      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
406      * on the return value: the return value is optional (but if data is returned, it must not be false).
407      * @param token The token targeted by the call.
408      * @param data The call data (encoded using abi.encode or one of its variants).
409      */
410     function callOptionalReturn(IERC20 token, bytes memory data) private {
411         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
412         // we're implementing it ourselves.
413 
414         // A Solidity high level call has three parts:
415         //  1. The target address is checked to verify it contains contract code
416         //  2. The call itself is made, and success asserted
417         //  3. The return value is decoded, which in turn checks the size of the returned data.
418         // solhint-disable-next-line max-line-length
419         require(address(token).isContract(), "SafeERC20: call to non-contract");
420 
421         // solhint-disable-next-line avoid-low-level-calls
422         (bool success, bytes memory returndata) = address(token).call(data);
423         require(success, "SafeERC20: low-level call failed");
424 
425         if (returndata.length > 0) { // Return data is optional
426             // solhint-disable-next-line max-line-length
427             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
428         }
429     }
430 }
431 
432 
433 /**
434  * @dev Standard math utilities missing in the Solidity language.
435  */
436 library Math {
437     /**
438      * @dev Returns the largest of two numbers.
439      */
440     function max(uint256 a, uint256 b) internal pure returns (uint256) {
441         return a >= b ? a : b;
442     }
443 
444     /**
445      * @dev Returns the smallest of two numbers.
446      */
447     function min(uint256 a, uint256 b) internal pure returns (uint256) {
448         return a < b ? a : b;
449     }
450 
451     /**
452      * @dev Returns the average of two numbers. The result is rounded towards
453      * zero.
454      */
455     function average(uint256 a, uint256 b) internal pure returns (uint256) {
456         // (a + b) / 2 can overflow, so we distribute
457         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
458     }
459 }
460 
461 
462 interface IStakingRewards {
463     // Views
464     function lastTimeRewardApplicable() external view returns (uint256);
465 
466     function rewardPerToken() external view returns (uint256);
467 
468     function earned(address account) external view returns (uint256);
469 
470     function getRewardForDuration() external view returns (uint256);
471 
472     function totalSupply() external view returns (uint256);
473 
474     function balanceOf(address account) external view returns (uint256);
475 
476     // Mutative
477 
478     function stake(uint256 amount) external;
479 
480     function withdraw(uint256 amount) external;
481 
482     function getReward() external;
483 
484     function exit() external;
485 }
486 
487 
488 /*
489  * @dev Provides information about the current execution context, including the
490  * sender of the transaction and its data. While these are generally available
491  * via msg.sender and msg.data, they should not be accessed in such a direct
492  * manner, since when dealing with GSN meta-transactions the account sending and
493  * paying for execution may not be the actual sender (as far as an application
494  * is concerned).
495  *
496  * This contract is only required for intermediate, library-like contracts.
497  */
498 contract Context {
499     // Empty internal constructor, to prevent people from mistakenly deploying
500     // an instance of this contract, which should be used via inheritance.
501     constructor () internal { }
502     // solhint-disable-previous-line no-empty-blocks
503 
504     function _msgSender() internal view returns (address payable) {
505         return msg.sender;
506     }
507 
508     function _msgData() internal view returns (bytes memory) {
509         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
510         return msg.data;
511     }
512 }
513 
514 
515 /**
516  * @dev Contract module which provides a basic access control mechanism, where
517  * there is an account (an owner) that can be granted exclusive access to
518  * specific functions.
519  *
520  * This module is used through inheritance. It will make available the modifier
521  * `onlyOwner`, which can be applied to your functions to restrict their use to
522  * the owner.
523  */
524 contract Ownable is Context {
525     address private _owner;
526 
527     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
528 
529     /**
530      * @dev Initializes the contract setting the deployer as the initial owner.
531      */
532     constructor () internal {
533         address msgSender = _msgSender();
534         _owner = msgSender;
535         emit OwnershipTransferred(address(0), msgSender);
536     }
537 
538     /**
539      * @dev Returns the address of the current owner.
540      */
541     function owner() public view returns (address) {
542         return _owner;
543     }
544 
545     /**
546      * @dev Throws if called by any account other than the owner.
547      */
548     modifier onlyOwner() {
549         require(isOwner(), "Ownable: caller is not the owner");
550         _;
551     }
552 
553     /**
554      * @dev Returns true if the caller is the current owner.
555      */
556     function isOwner() public view returns (bool) {
557         return _msgSender() == _owner;
558     }
559 
560     /**
561      * @dev Leaves the contract without owner. It will not be possible to call
562      * `onlyOwner` functions anymore. Can only be called by the current owner.
563      *
564      * NOTE: Renouncing ownership will leave the contract without an owner,
565      * thereby removing any functionality that is only available to the owner.
566      */
567     function renounceOwnership() public onlyOwner {
568         emit OwnershipTransferred(_owner, address(0));
569         _owner = address(0);
570     }
571 
572     /**
573      * @dev Transfers ownership of the contract to a new account (`newOwner`).
574      * Can only be called by the current owner.
575      */
576     function transferOwnership(address newOwner) public onlyOwner {
577         _transferOwnership(newOwner);
578     }
579 
580     /**
581      * @dev Transfers ownership of the contract to a new account (`newOwner`).
582      */
583     function _transferOwnership(address newOwner) internal {
584         require(newOwner != address(0), "Ownable: new owner is the zero address");
585         emit OwnershipTransferred(_owner, newOwner);
586         _owner = newOwner;
587     }
588 }
589 
590 
591 // SPDX-License-Identifier: MIT
592 // Copied directly from https://github.com/Synthetixio/synthetix/blob/v2.26.3/contracts/RewardsDistributionRecipient.sol
593 
594 
595 contract RewardsDistributionRecipient is Ownable {
596     address public rewardsDistribution;
597 
598     function notifyRewardAmount(uint256 reward) external;
599 
600     modifier onlyRewardsDistribution() {
601         require(
602             msg.sender == rewardsDistribution,
603             "Caller is not RewardsDistribution contract"
604         );
605         _;
606     }
607 
608     function setRewardsDistribution(
609         address _rewardsDistribution
610     )
611         external
612         onlyOwner
613     {
614         rewardsDistribution = _rewardsDistribution;
615     }
616 }
617 
618 // SPDX-License-Identifier: MIT
619 // Copied directly from https://github.com/Synthetixio/synthetix/blob/v2.26.3/contracts/StakingRewards.sol
620 
621 
622 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient {
623 
624     using SafeMath for uint256;
625     using SafeERC20 for IERC20;
626 
627     /* ========== STATE VARIABLES ========== */
628 
629     IERC20 public rewardsToken;
630     IERC20 public stakingToken;
631 
632     address public arcDAO;
633 
634     uint256 public periodFinish = 0;
635     uint256 public rewardRate = 0;
636     uint256 public rewardsDuration = 7 days;
637     uint256 public lastUpdateTime;
638     uint256 public rewardPerTokenStored;
639 
640     mapping(address => uint256) public userRewardPerTokenPaid;
641     mapping(address => uint256) public rewards;
642 
643     uint256 private _totalSupply;
644     mapping(address => uint256) private _balances;
645 
646     /* ========== EVENTS ========== */
647 
648     event RewardAdded(uint256 reward);
649     event Staked(address indexed user, uint256 amount);
650     event Withdrawn(address indexed user, uint256 amount);
651     event RewardPaid(address indexed user, uint256 reward);
652     event RewardsDurationUpdated(uint256 newDuration);
653     event Recovered(address token, uint256 amount);
654 
655     /* ========== MODIFIERS ========== */
656 
657     modifier updateReward(address account) {
658         rewardPerTokenStored = actualRewardPerToken();
659         lastUpdateTime = lastTimeRewardApplicable();
660 
661         if (account != address(0)) {
662             rewards[account] = actualEarned(account);
663             userRewardPerTokenPaid[account] = rewardPerTokenStored;
664         }
665         _;
666     }
667 
668     /* ========== CONSTRUCTOR ========== */
669 
670     constructor(
671         address _arcDAO,
672         address _rewardsDistribution,
673         address _rewardsToken,
674         address _stakingToken
675     )
676         public
677     {
678         arcDAO = _arcDAO;
679         rewardsToken = IERC20(_rewardsToken);
680         stakingToken = IERC20(_stakingToken);
681         rewardsDistribution = _rewardsDistribution;
682     }
683 
684     /* ========== VIEWS ========== */
685 
686     function totalSupply()
687         public
688         view
689         returns (uint256)
690     {
691         return _totalSupply;
692     }
693 
694     function balanceOf(
695         address account
696     )
697         public
698         view
699         returns (uint256)
700     {
701         return _balances[account];
702     }
703 
704     function lastTimeRewardApplicable()
705         public
706         view
707         returns (uint256)
708     {
709         return Math.min(block.timestamp, periodFinish);
710     }
711 
712     function actualRewardPerToken()
713         internal
714         view
715         returns (uint256)
716     {
717         if (_totalSupply == 0) {
718             return rewardPerTokenStored;
719         }
720         return
721             rewardPerTokenStored.add(
722                 lastTimeRewardApplicable()
723                     .sub(lastUpdateTime)
724                     .mul(rewardRate)
725                     .mul(1e18)
726                     .div(_totalSupply)
727             );
728     }
729 
730     function rewardPerToken()
731         public
732         view
733         returns (uint256)
734     {
735         if (_totalSupply == 0) {
736             return rewardPerTokenStored;
737         }
738         return
739             rewardPerTokenStored.add(
740                 lastTimeRewardApplicable()
741                     .sub(lastUpdateTime)
742                     .mul(rewardRate)
743                     .mul(1e18)
744                     .div(_totalSupply)
745                     .mul(2)
746                     .div(3)
747             );
748     }
749 
750     function actualEarned(
751         address account
752     )
753         internal
754         view
755         returns (uint256)
756     {
757         return _balances[account]
758             .mul(actualRewardPerToken().sub(userRewardPerTokenPaid[account]))
759             .div(1e18)
760             .add(rewards[account]);
761     }
762 
763     function earned(
764         address account
765     )
766         public
767         view
768         returns (uint256)
769     {
770         return _balances[account]
771             .mul(actualRewardPerToken().sub(userRewardPerTokenPaid[account]))
772             .div(1e18)
773             .add(rewards[account])
774             .mul(2)
775             .div(3);
776     }
777 
778     function getRewardForDuration()
779         public
780         view
781         returns (uint256)
782     {
783         return rewardRate.mul(rewardsDuration);
784     }
785 
786     /* ========== MUTATIVE FUNCTIONS ========== */
787 
788     function stake(
789         uint256 amount
790     )
791         public
792         updateReward(msg.sender)
793     {
794         require(
795             amount > 0,
796             "Cannot stake 0"
797         );
798 
799         _totalSupply = _totalSupply.add(amount);
800         _balances[msg.sender] = _balances[msg.sender].add(amount);
801 
802         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
803 
804         emit Staked(msg.sender, amount);
805     }
806 
807     function withdraw(
808         uint256 amount
809     )
810         public
811         updateReward(msg.sender)
812     {
813         require(
814             amount > 0,
815             "Cannot withdraw 0"
816         );
817 
818         _totalSupply = _totalSupply.sub(amount);
819         _balances[msg.sender] = _balances[msg.sender].sub(amount);
820 
821         stakingToken.safeTransfer(msg.sender, amount);
822 
823         emit Withdrawn(msg.sender, amount);
824     }
825 
826     function getReward()
827         public
828         updateReward(msg.sender)
829     {
830         uint256 reward = rewards[msg.sender];
831 
832         if (reward > 0) {
833             rewards[msg.sender] = 0;
834 
835             rewardsToken.safeTransfer(msg.sender, reward.mul(2).div(3));
836             rewardsToken.safeTransfer(arcDAO, reward.sub(reward.mul(2).div(3)));
837 
838             emit RewardPaid(msg.sender, reward);
839         }
840     }
841 
842     function exit() external {
843         withdraw(_balances[msg.sender]);
844         getReward();
845     }
846 
847     /* ========== RESTRICTED FUNCTIONS ========== */
848 
849     function notifyRewardAmount(
850         uint256 reward
851     )
852         external
853         onlyRewardsDistribution
854         updateReward(address(0))
855     {
856         if (block.timestamp >= periodFinish) {
857             rewardRate = reward.div(rewardsDuration);
858         } else {
859             uint256 remaining = periodFinish.sub(block.timestamp);
860             uint256 leftover = remaining.mul(rewardRate);
861             rewardRate = reward.add(leftover).div(rewardsDuration);
862         }
863 
864         // Ensure the provided reward amount is not more than the balance in the contract.
865         // This keeps the reward rate in the right range, preventing overflows due to
866         // very high values of rewardRate in the earned and rewardsPerToken functions;
867         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
868         uint balance = rewardsToken.balanceOf(address(this));
869         require(
870             rewardRate <= balance.div(rewardsDuration),
871             "Provided reward too high"
872         );
873 
874         lastUpdateTime = block.timestamp;
875         periodFinish = block.timestamp.add(rewardsDuration);
876         emit RewardAdded(reward);
877     }
878 
879     // Added to support recovering LP Rewards from other systems to be distributed to holders
880     function recoverERC20(
881         address tokenAddress,
882         uint256 tokenAmount
883     )
884         public
885         onlyOwner
886     {
887         // Cannot recover the staking token or the rewards token
888         require(
889             tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken),
890             "Cannot withdraw the staking or rewards tokens"
891         );
892 
893         IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
894         emit Recovered(tokenAddress, tokenAmount);
895     }
896 
897     function setRewardsDuration(
898         uint256 _rewardsDuration
899     )
900         external
901         onlyOwner
902     {
903         require(
904             periodFinish == 0 || block.timestamp > periodFinish,
905             "Prev period must be complete before changing duration for new period"
906         );
907         rewardsDuration = _rewardsDuration;
908         emit RewardsDurationUpdated(rewardsDuration);
909     }
910 }
911 
912 
913 // SPDX-License-Identifier: MIT
914 // Modified from https://github.com/iearn-finance/audit/blob/master/contracts/yGov/YearnGovernanceBPT.sol
915 
916 
917 /**
918  * @title Accrual is an abstract contract which allows users of some
919  *        distribution to claim a portion of tokens based on their share.
920  */
921 contract Accrual {
922 
923     using SafeMath for uint256;
924     using SafeERC20 for IERC20;
925 
926     IERC20 public accrualToken;
927 
928     uint256 public accruedIndex = 0; // previously accumulated index
929     uint256 public accruedBalance = 0; // previous calculated balance
930 
931     mapping(address => uint256) public supplyIndex;
932 
933     constructor(
934         address _accrualToken
935     )
936         public
937     {
938         accrualToken = IERC20(_accrualToken);
939     }
940 
941     function getUserBalance(
942         address owner
943     )
944         public
945         view
946         returns (uint256);
947 
948     function getTotalBalance()
949         public
950         view
951         returns (uint256);
952 
953     function updateFees()
954         public
955     {
956         if (getTotalBalance() == 0) {
957             return;
958         }
959 
960         uint256 contractBalance = accrualToken.balanceOf(address(this));
961 
962         if (contractBalance == 0) {
963             return;
964         }
965 
966         // Find the difference since the last balance stored in the contract
967         uint256 difference = contractBalance.sub(accruedBalance);
968 
969         if (difference == 0) {
970             return;
971         }
972 
973         // Use the difference to calculate a ratio
974         uint256 ratio = difference.mul(1e18).div(getTotalBalance());
975 
976         if (ratio == 0) {
977             return;
978         }
979 
980         // Update the index by adding the existing index to the ratio index
981         accruedIndex = accruedIndex.add(ratio);
982 
983         // Update the accrued balance
984         accruedBalance = contractBalance;
985     }
986 
987     function claimFees()
988         public
989     {
990         claimFor(msg.sender);
991     }
992 
993     function claimFor(
994         address recipient
995     )
996         public
997     {
998         updateFees();
999 
1000         uint256 userBalance = getUserBalance(recipient);
1001 
1002         if (userBalance == 0) {
1003             supplyIndex[recipient] = accruedIndex;
1004             return;
1005         }
1006 
1007         // Store the existing user's index before updating it
1008         uint256 existingIndex = supplyIndex[recipient];
1009 
1010         // Update the user's index to the current one
1011         supplyIndex[recipient] = accruedIndex;
1012 
1013         // Calculate the difference between the current index and the old one
1014         // The difference here is what the user will be able to claim against
1015         uint256 delta = accruedIndex.sub(existingIndex);
1016 
1017         require(
1018             delta > 0,
1019             "TokenAccrual: no tokens available to claim"
1020         );
1021 
1022         // Get the user's current balance and multiply with their index delta
1023         uint256 share = userBalance.mul(delta).div(1e18);
1024 
1025         // Transfer the tokens to the user
1026         accrualToken.safeTransfer(recipient, share);
1027 
1028         // Update the accrued balance
1029         accruedBalance = accrualToken.balanceOf(address(this));
1030     }
1031 
1032 }
1033 
1034 // SPDX-License-Identifier: MIT
1035 
1036 
1037 contract StakingRewardsAccrual is StakingRewards, Accrual {
1038 
1039     constructor(
1040         address _arcDAO,
1041         address _rewardsDistribution,
1042         address _rewardsToken,
1043         address _stakingToken,
1044         address _feesToken
1045     )
1046         public
1047         StakingRewards(
1048             _arcDAO,
1049             _rewardsDistribution,
1050             _rewardsToken,
1051             _stakingToken
1052         )
1053         Accrual(
1054             _feesToken
1055         )
1056     {}
1057 
1058     function getUserBalance(
1059         address owner
1060     )
1061         public
1062         view
1063         returns (uint256)
1064     {
1065         return balanceOf(owner);
1066     }
1067 
1068     function getTotalBalance()
1069         public
1070         view
1071         returns (uint256)
1072     {
1073         return totalSupply();
1074     }
1075 
1076 }
1077 
1078 
1079 interface IKYFV2 {
1080 
1081     function checkVerified(
1082         address _user
1083     )
1084         external
1085         view
1086         returns (bool);
1087 
1088 }
1089 
1090 // SPDX-License-Identifier: MIT
1091 
1092 
1093 contract StakingRewardsAccrualCapped is StakingRewardsAccrual {
1094 
1095     /* ========== Variables ========== */
1096 
1097     uint256 public hardCap;
1098 
1099     bool public tokensClaimable;
1100 
1101     mapping (address => bool) public kyfInstances;
1102 
1103     address[] public kyfInstancesArray;
1104 
1105     /* ========== Events ========== */
1106 
1107     event HardCapSet(uint256 _cap);
1108 
1109     event KyfStatusUpdated(address _address, bool _status);
1110 
1111     event ClaimableStatusUpdated(bool _status);
1112 
1113     /* ========== Constructor ========== */
1114 
1115     constructor(
1116         address _arcDAO,
1117         address _rewardsDistribution,
1118         address _rewardsToken,
1119         address _stakingToken,
1120         address _feesToken
1121     )
1122         public
1123         StakingRewardsAccrual(
1124             _arcDAO,
1125             _rewardsDistribution,
1126             _rewardsToken,
1127             _stakingToken,
1128             _feesToken
1129         )
1130     {
1131 
1132     }
1133 
1134     /* ========== Public View Functions ========== */
1135 
1136     function getApprovedKyfInstancesArray()
1137         public
1138         view
1139         returns (address[] memory)
1140     {
1141         return kyfInstancesArray;
1142     }
1143 
1144     function isVerified(
1145         address _user
1146     )
1147         public
1148         view
1149         returns (bool)
1150     {
1151         for (uint256 i = 0; i < kyfInstancesArray.length; i++) {
1152             IKYFV2 kyfContract = IKYFV2(kyfInstancesArray[i]);
1153             if (kyfContract.checkVerified(_user) == true) {
1154                 return true;
1155             }
1156         }
1157 
1158         return false;
1159     }
1160 
1161     /* ========== Admin Functions ========== */
1162 
1163     function setStakeHardCap(
1164         uint256 _hardCap
1165     )
1166         public
1167         onlyOwner
1168     {
1169         hardCap = _hardCap;
1170 
1171         emit HardCapSet(_hardCap);
1172     }
1173 
1174     function setTokensClaimable(
1175         bool _enabled
1176     )
1177         public
1178         onlyOwner
1179     {
1180         tokensClaimable = _enabled;
1181 
1182         emit ClaimableStatusUpdated(_enabled);
1183     }
1184 
1185     function setApprovedKYFInstance(
1186         address _kyfContract,
1187         bool _status
1188     )
1189         public
1190         onlyOwner
1191     {
1192         if (_status == true) {
1193             kyfInstancesArray.push(_kyfContract);
1194             kyfInstances[_kyfContract] = true;
1195             emit KyfStatusUpdated(_kyfContract, true);
1196             return;
1197         }
1198 
1199         // Remove the kyfContract from the kyfInstancesArray array.
1200         for (uint i = 0; i < kyfInstancesArray.length; i++) {
1201             if (address(kyfInstancesArray[i]) == _kyfContract) {
1202                 delete kyfInstancesArray[i];
1203                 kyfInstancesArray[i] = kyfInstancesArray[kyfInstancesArray.length - 1];
1204 
1205                 // Decrease the size of the array by one.
1206                 kyfInstancesArray.length--;
1207                 break;
1208             }
1209         }
1210 
1211         // And remove it from the synths mapping
1212         delete kyfInstances[_kyfContract];
1213         emit KyfStatusUpdated(_kyfContract, false);
1214     }
1215 
1216     /* ========== Public Functions ========== */
1217 
1218     function stake(
1219         uint256 _amount
1220     )
1221         public
1222         updateReward(msg.sender)
1223     {
1224         uint256 totalBalance = balanceOf(msg.sender).add(_amount);
1225 
1226         require(
1227             totalBalance <= hardCap,
1228             "Cannot stake more than the hard cap"
1229         );
1230 
1231         require(
1232             isVerified(msg.sender) == true,
1233             "Must be KYF registered to participate"
1234         );
1235 
1236         super.stake(_amount);
1237     }
1238 
1239     function getReward()
1240         public
1241         updateReward(msg.sender)
1242     {
1243         require(
1244             tokensClaimable == true,
1245             "Tokens cannnot be claimed yet"
1246         );
1247 
1248         super.getReward();
1249     }
1250 
1251 }