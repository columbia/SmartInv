1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-09
3 */
4 
5 /*
6    ____            __   __        __   _
7   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
8  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
9 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
10      /___/
11 
12 * Synthetix: StakingRewards.sol
13 *
14 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/StakingRewards.sol
15 * Docs: https://docs.synthetix.io/contracts/StakingRewards
16 *
17 * Contract Dependencies: 
18 *	- IERC20
19 *	- IStakingRewards
20 *	- Owned
21 *	- Pausable
22 *	- ReentrancyGuard
23 *	- RewardsDistributionRecipient
24 * Libraries: 
25 *	- Address
26 *	- Math
27 *	- SafeERC20
28 *	- SafeMath
29 *
30 * MIT License
31 * ===========
32 *
33 * Copyright (c) 2021 Synthetix
34 *
35 * Permission is hereby granted, free of charge, to any person obtaining a copy
36 * of this software and associated documentation files (the "Software"), to deal
37 * in the Software without restriction, including without limitation the rights
38 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
39 * copies of the Software, and to permit persons to whom the Software is
40 * furnished to do so, subject to the following conditions:
41 *
42 * The above copyright notice and this permission notice shall be included in all
43 * copies or substantial portions of the Software.
44 *
45 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
46 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
47 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
48 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
49 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
50 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
51 */
52 
53 
54 
55 pragma solidity ^0.5.0;
56 
57 /**
58  * @dev Standard math utilities missing in the Solidity language.
59  */
60 library Math {
61     /**
62      * @dev Returns the largest of two numbers.
63      */
64     function max(uint256 a, uint256 b) internal pure returns (uint256) {
65         return a >= b ? a : b;
66     }
67 
68     /**
69      * @dev Returns the smallest of two numbers.
70      */
71     function min(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a < b ? a : b;
73     }
74 
75     /**
76      * @dev Returns the average of two numbers. The result is rounded towards
77      * zero.
78      */
79     function average(uint256 a, uint256 b) internal pure returns (uint256) {
80         // (a + b) / 2 can overflow, so we distribute
81         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
82     }
83 }
84 
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b <= a, "SafeMath: subtraction overflow");
127         uint256 c = a - b;
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `*` operator.
137      *
138      * Requirements:
139      * - Multiplication cannot overflow.
140      */
141     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
143         // benefit is lost if 'b' is also tested.
144         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
145         if (a == 0) {
146             return 0;
147         }
148 
149         uint256 c = a * b;
150         require(c / a == b, "SafeMath: multiplication overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the integer division of two unsigned integers. Reverts on
157      * division by zero. The result is rounded towards zero.
158      *
159      * Counterpart to Solidity's `/` operator. Note: this function uses a
160      * `revert` opcode (which leaves remaining gas untouched) while Solidity
161      * uses an invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Solidity only automatically asserts when dividing by 0
168         require(b > 0, "SafeMath: division by zero");
169         uint256 c = a / b;
170         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
177      * Reverts when dividing by zero.
178      *
179      * Counterpart to Solidity's `%` operator. This function uses a `revert`
180      * opcode (which leaves remaining gas untouched) while Solidity uses an
181      * invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      * - The divisor cannot be zero.
185      */
186     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
187         require(b != 0, "SafeMath: modulo by zero");
188         return a % b;
189     }
190 }
191 
192 
193 /**
194  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
195  * the optional functions; to access them see `ERC20Detailed`.
196  */
197 interface IERC20 {
198     /**
199      * @dev Returns the amount of tokens in existence.
200      */
201     function totalSupply() external view returns (uint256);
202 
203     /**
204      * @dev Returns the amount of tokens owned by `account`.
205      */
206     function balanceOf(address account) external view returns (uint256);
207 
208     /**
209      * @dev Moves `amount` tokens from the caller's account to `recipient`.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a `Transfer` event.
214      */
215     function transfer(address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Returns the remaining number of tokens that `spender` will be
219      * allowed to spend on behalf of `owner` through `transferFrom`. This is
220      * zero by default.
221      *
222      * This value changes when `approve` or `transferFrom` are called.
223      */
224     function allowance(address owner, address spender) external view returns (uint256);
225 
226     /**
227      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * > Beware that changing an allowance with this method brings the risk
232      * that someone may use both the old and the new allowance by unfortunate
233      * transaction ordering. One possible solution to mitigate this race
234      * condition is to first reduce the spender's allowance to 0 and set the
235      * desired value afterwards:
236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      *
238      * Emits an `Approval` event.
239      */
240     function approve(address spender, uint256 amount) external returns (bool);
241 
242     /**
243      * @dev Moves `amount` tokens from `sender` to `recipient` using the
244      * allowance mechanism. `amount` is then deducted from the caller's
245      * allowance.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * Emits a `Transfer` event.
250      */
251     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Emitted when `value` tokens are moved from one account (`from`) to
255      * another (`to`).
256      *
257      * Note that `value` may be zero.
258      */
259     event Transfer(address indexed from, address indexed to, uint256 value);
260 
261     /**
262      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
263      * a call to `approve`. `value` is the new allowance.
264      */
265     event Approval(address indexed owner, address indexed spender, uint256 value);
266 }
267 
268 
269 /**
270  * @dev Optional functions from the ERC20 standard.
271  */
272 contract ERC20Detailed is IERC20 {
273     string private _name;
274     string private _symbol;
275     uint8 private _decimals;
276 
277     /**
278      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
279      * these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor (string memory name, string memory symbol, uint8 decimals) public {
283         _name = name;
284         _symbol = symbol;
285         _decimals = decimals;
286     }
287 
288     /**
289      * @dev Returns the name of the token.
290      */
291     function name() public view returns (string memory) {
292         return _name;
293     }
294 
295     /**
296      * @dev Returns the symbol of the token, usually a shorter version of the
297      * name.
298      */
299     function symbol() public view returns (string memory) {
300         return _symbol;
301     }
302 
303     /**
304      * @dev Returns the number of decimals used to get its user representation.
305      * For example, if `decimals` equals `2`, a balance of `505` tokens should
306      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
307      *
308      * Tokens usually opt for a value of 18, imitating the relationship between
309      * Ether and Wei.
310      *
311      * > Note that this information is only used for _display_ purposes: it in
312      * no way affects any of the arithmetic of the contract, including
313      * `IERC20.balanceOf` and `IERC20.transfer`.
314      */
315     function decimals() public view returns (uint8) {
316         return _decimals;
317     }
318 }
319 
320 
321 /**
322  * @dev Collection of functions related to the address type,
323  */
324 library Address {
325     /**
326      * @dev Returns true if `account` is a contract.
327      *
328      * This test is non-exhaustive, and there may be false-negatives: during the
329      * execution of a contract's constructor, its address will be reported as
330      * not containing a contract.
331      *
332      * > It is unsafe to assume that an address for which this function returns
333      * false is an externally-owned account (EOA) and not a contract.
334      */
335     function isContract(address account) internal view returns (bool) {
336         // This method relies in extcodesize, which returns 0 for contracts in
337         // construction, since the code is only stored at the end of the
338         // constructor execution.
339 
340         uint256 size;
341         // solhint-disable-next-line no-inline-assembly
342         assembly { size := extcodesize(account) }
343         return size > 0;
344     }
345 }
346 
347 
348 /**
349  * @title SafeERC20
350  * @dev Wrappers around ERC20 operations that throw on failure (when the token
351  * contract returns false). Tokens that return no value (and instead revert or
352  * throw on failure) are also supported, non-reverting calls are assumed to be
353  * successful.
354  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
355  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
356  */
357 library SafeERC20 {
358     using SafeMath for uint256;
359     using Address for address;
360 
361     function safeTransfer(IERC20 token, address to, uint256 value) internal {
362         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
363     }
364 
365     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
366         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
367     }
368 
369     function safeApprove(IERC20 token, address spender, uint256 value) internal {
370         // safeApprove should only be called when setting an initial allowance,
371         // or when resetting it to zero. To increase and decrease it, use
372         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
373         // solhint-disable-next-line max-line-length
374         require((value == 0) || (token.allowance(address(this), spender) == 0),
375             "SafeERC20: approve from non-zero to non-zero allowance"
376         );
377         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
378     }
379 
380     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
381         uint256 newAllowance = token.allowance(address(this), spender).add(value);
382         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
383     }
384 
385     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
386         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
387         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
388     }
389 
390     /**
391      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
392      * on the return value: the return value is optional (but if data is returned, it must not be false).
393      * @param token The token targeted by the call.
394      * @param data The call data (encoded using abi.encode or one of its variants).
395      */
396     function callOptionalReturn(IERC20 token, bytes memory data) private {
397         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
398         // we're implementing it ourselves.
399 
400         // A Solidity high level call has three parts:
401         //  1. The target address is checked to verify it contains contract code
402         //  2. The call itself is made, and success asserted
403         //  3. The return value is decoded, which in turn checks the size of the returned data.
404         // solhint-disable-next-line max-line-length
405         require(address(token).isContract(), "SafeERC20: call to non-contract");
406 
407         // solhint-disable-next-line avoid-low-level-calls
408         (bool success, bytes memory returndata) = address(token).call(data);
409         require(success, "SafeERC20: low-level call failed");
410 
411         if (returndata.length > 0) { // Return data is optional
412             // solhint-disable-next-line max-line-length
413             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
414         }
415     }
416 }
417 
418 
419 /**
420  * @dev Contract module that helps prevent reentrant calls to a function.
421  *
422  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
423  * available, which can be aplied to functions to make sure there are no nested
424  * (reentrant) calls to them.
425  *
426  * Note that because there is a single `nonReentrant` guard, functions marked as
427  * `nonReentrant` may not call one another. This can be worked around by making
428  * those functions `private`, and then adding `external` `nonReentrant` entry
429  * points to them.
430  */
431 contract ReentrancyGuard {
432     /// @dev counter to allow mutex lock with only one SSTORE operation
433     uint256 private _guardCounter;
434 
435     constructor () internal {
436         // The counter starts at one to prevent changing it from zero to a non-zero
437         // value, which is a more expensive operation.
438         _guardCounter = 1;
439     }
440 
441     /**
442      * @dev Prevents a contract from calling itself, directly or indirectly.
443      * Calling a `nonReentrant` function from another `nonReentrant`
444      * function is not supported. It is possible to prevent this from happening
445      * by making the `nonReentrant` function external, and make it call a
446      * `private` function that does the actual work.
447      */
448     modifier nonReentrant() {
449         _guardCounter += 1;
450         uint256 localCounter = _guardCounter;
451         _;
452         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
453     }
454 }
455 
456 
457 // https://docs.synthetix.io/contracts/source/interfaces/istakingrewards
458 interface IStakingRewards {
459     // Views
460     function lastTimeRewardApplicable() external view returns (uint256);
461 
462     function rewardPerToken() external view returns (uint256);
463 
464     function earned(address account) external view returns (uint256);
465 
466     function getRewardForDuration() external view returns (uint256);
467 
468     function totalSupply() external view returns (uint256);
469 
470     function balanceOf(address account) external view returns (uint256);
471 
472     // Mutative
473 
474     function stake(uint256 amount) external;
475 
476     function withdraw(uint256 amount) external;
477 
478     function getReward() external;
479 
480     function exit() external;
481 }
482 
483 
484 // https://docs.synthetix.io/contracts/source/contracts/owned
485 contract Owned {
486     address public owner;
487     address public nominatedOwner;
488 
489     constructor(address _owner) public {
490         require(_owner != address(0), "Owner address cannot be 0");
491         owner = _owner;
492         emit OwnerChanged(address(0), _owner);
493     }
494 
495     function nominateNewOwner(address _owner) external onlyOwner {
496         nominatedOwner = _owner;
497         emit OwnerNominated(_owner);
498     }
499 
500     function acceptOwnership() external {
501         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
502         emit OwnerChanged(owner, nominatedOwner);
503         owner = nominatedOwner;
504         nominatedOwner = address(0);
505     }
506 
507     modifier onlyOwner {
508         _onlyOwner();
509         _;
510     }
511 
512     function _onlyOwner() private view {
513         require(msg.sender == owner, "Only the contract owner may perform this action");
514     }
515 
516     event OwnerNominated(address newOwner);
517     event OwnerChanged(address oldOwner, address newOwner);
518 }
519 
520 
521 // Inheritance
522 
523 
524 // https://docs.synthetix.io/contracts/source/contracts/rewardsdistributionrecipient
525 contract RewardsDistributionRecipient is Owned {
526     address public rewardsDistribution;
527 
528     function notifyRewardAmount(uint256 reward) external;
529 
530     modifier onlyRewardsDistribution() {
531         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
532         _;
533     }
534 
535     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
536         rewardsDistribution = _rewardsDistribution;
537     }
538 }
539 
540 
541 // Inheritance
542 
543 
544 // https://docs.synthetix.io/contracts/source/contracts/pausable
545 contract Pausable is Owned {
546     uint public lastPauseTime;
547     bool public paused;
548 
549     constructor() internal {
550         // This contract is abstract, and thus cannot be instantiated directly
551         require(owner != address(0), "Owner must be set");
552         // Paused will be false, and lastPauseTime will be 0 upon initialisation
553     }
554 
555     /**
556      * @notice Change the paused state of the contract
557      * @dev Only the contract owner may call this.
558      */
559     function setPaused(bool _paused) external onlyOwner {
560         // Ensure we're actually changing the state before we do anything
561         if (_paused == paused) {
562             return;
563         }
564 
565         // Set our paused state.
566         paused = _paused;
567 
568         // If applicable, set the last pause time.
569         if (paused) {
570             lastPauseTime = now;
571         }
572 
573         // Let everyone know that our pause state has changed.
574         emit PauseChanged(paused);
575     }
576 
577     event PauseChanged(bool isPaused);
578 
579     modifier notPaused {
580         require(!paused, "This action cannot be performed while the contract is paused");
581         _;
582     }
583 }
584 
585 
586 // Inheritance
587 
588 
589 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
590 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
591     using SafeMath for uint256;
592     using SafeERC20 for IERC20;
593 
594     /* ========== STATE VARIABLES ========== */
595 
596     IERC20 public rewardsToken;
597     IERC20 public stakingToken;
598     uint256 public periodFinish = 0;
599     uint256 public rewardRate = 0;
600     uint256 public rewardsDuration = 7 days;
601     uint256 public lastUpdateTime;
602     uint256 public rewardPerTokenStored;
603 
604     mapping(address => uint256) public userRewardPerTokenPaid;
605     mapping(address => uint256) public rewards;
606 
607     uint256 private _totalSupply;
608     mapping(address => uint256) private _balances;
609 
610     /* ========== CONSTRUCTOR ========== */
611 
612     constructor(
613         address _owner,
614         address _rewardsDistribution,
615         address _rewardsToken,
616         address _stakingToken
617     ) public Owned(_owner) {
618         rewardsToken = IERC20(_rewardsToken);
619         stakingToken = IERC20(_stakingToken);
620         rewardsDistribution = _rewardsDistribution;
621     }
622 
623     /* ========== VIEWS ========== */
624 
625     function totalSupply() external view returns (uint256) {
626         return _totalSupply;
627     }
628 
629     function balanceOf(address account) external view returns (uint256) {
630         return _balances[account];
631     }
632 
633     function lastTimeRewardApplicable() public view returns (uint256) {
634         return Math.min(block.timestamp, periodFinish);
635     }
636 
637     function rewardPerToken() public view returns (uint256) {
638         if (_totalSupply == 0) {
639             return rewardPerTokenStored;
640         }
641         return
642             rewardPerTokenStored.add(
643                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
644             );
645     }
646 
647     function earned(address account) public view returns (uint256) {
648         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
649     }
650 
651     function getRewardForDuration() external view returns (uint256) {
652         return rewardRate.mul(rewardsDuration);
653     }
654 
655     /* ========== MUTATIVE FUNCTIONS ========== */
656 
657     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
658         require(amount > 0, "Cannot stake 0");
659         _totalSupply = _totalSupply.add(amount);
660         _balances[msg.sender] = _balances[msg.sender].add(amount);
661         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
662         emit Staked(msg.sender, amount);
663     }
664 
665     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
666         require(amount > 0, "Cannot withdraw 0");
667         _totalSupply = _totalSupply.sub(amount);
668         _balances[msg.sender] = _balances[msg.sender].sub(amount);
669         stakingToken.safeTransfer(msg.sender, amount);
670         emit Withdrawn(msg.sender, amount);
671     }
672 
673     function getReward() public nonReentrant updateReward(msg.sender) {
674         uint256 reward = rewards[msg.sender];
675         if (reward > 0) {
676             rewards[msg.sender] = 0;
677             rewardsToken.safeTransfer(msg.sender, reward);
678             emit RewardPaid(msg.sender, reward);
679         }
680     }
681 
682     function exit() external {
683         withdraw(_balances[msg.sender]);
684         getReward();
685     }
686 
687     /* ========== RESTRICTED FUNCTIONS ========== */
688 
689     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
690         if (block.timestamp >= periodFinish) {
691             rewardRate = reward.div(rewardsDuration);
692         } else {
693             uint256 remaining = periodFinish.sub(block.timestamp);
694             uint256 leftover = remaining.mul(rewardRate);
695             rewardRate = reward.add(leftover).div(rewardsDuration);
696         }
697 
698         // Ensure the provided reward amount is not more than the balance in the contract.
699         // This keeps the reward rate in the right range, preventing overflows due to
700         // very high values of rewardRate in the earned and rewardsPerToken functions;
701         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
702         uint balance = rewardsToken.balanceOf(address(this));
703         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
704 
705         lastUpdateTime = block.timestamp;
706         periodFinish = block.timestamp.add(rewardsDuration);
707         emit RewardAdded(reward);
708     }
709 
710     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
711     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
712         require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");
713         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
714         emit Recovered(tokenAddress, tokenAmount);
715     }
716 
717     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
718         require(
719             block.timestamp > periodFinish,
720             "Previous rewards period must be complete before changing the duration for the new period"
721         );
722         rewardsDuration = _rewardsDuration;
723         emit RewardsDurationUpdated(rewardsDuration);
724     }
725 
726     /* ========== MODIFIERS ========== */
727 
728     modifier updateReward(address account) {
729         rewardPerTokenStored = rewardPerToken();
730         lastUpdateTime = lastTimeRewardApplicable();
731         if (account != address(0)) {
732             rewards[account] = earned(account);
733             userRewardPerTokenPaid[account] = rewardPerTokenStored;
734         }
735         _;
736     }
737 
738     /* ========== EVENTS ========== */
739 
740     event RewardAdded(uint256 reward);
741     event Staked(address indexed user, uint256 amount);
742     event Withdrawn(address indexed user, uint256 amount);
743     event RewardPaid(address indexed user, uint256 reward);
744     event RewardsDurationUpdated(uint256 newDuration);
745     event Recovered(address token, uint256 amount);
746 }