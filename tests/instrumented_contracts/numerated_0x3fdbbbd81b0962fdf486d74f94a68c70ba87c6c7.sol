1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: StakingRewards.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/StakingRewards.sol
11 * Docs: https://docs.synthetix.io/contracts/StakingRewards
12 *
13 * Contract Dependencies: 
14 *	- IERC20
15 *	- IStakingRewards
16 *	- Owned
17 *	- Pausable
18 *	- ReentrancyGuard
19 *	- RewardsDistributionRecipient
20 * Libraries: 
21 *	- Address
22 *	- Math
23 *	- SafeERC20
24 *	- SafeMath
25 *
26 * MIT License
27 * ===========
28 *
29 * Copyright (c) 2020 Synthetix
30 *
31 * Permission is hereby granted, free of charge, to any person obtaining a copy
32 * of this software and associated documentation files (the "Software"), to deal
33 * in the Software without restriction, including without limitation the rights
34 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
35 * copies of the Software, and to permit persons to whom the Software is
36 * furnished to do so, subject to the following conditions:
37 *
38 * The above copyright notice and this permission notice shall be included in all
39 * copies or substantial portions of the Software.
40 *
41 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
42 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
43 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
44 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
45 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
46 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
47 */
48 
49 
50 
51 pragma solidity ^0.5.0;
52 
53 /**
54  * @dev Standard math utilities missing in the Solidity language.
55  */
56 library Math {
57     /**
58      * @dev Returns the largest of two numbers.
59      */
60     function max(uint256 a, uint256 b) internal pure returns (uint256) {
61         return a >= b ? a : b;
62     }
63 
64     /**
65      * @dev Returns the smallest of two numbers.
66      */
67     function min(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a < b ? a : b;
69     }
70 
71     /**
72      * @dev Returns the average of two numbers. The result is rounded towards
73      * zero.
74      */
75     function average(uint256 a, uint256 b) internal pure returns (uint256) {
76         // (a + b) / 2 can overflow, so we distribute
77         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
78     }
79 }
80 
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         require(b <= a, "SafeMath: subtraction overflow");
123         uint256 c = a - b;
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `*` operator.
133      *
134      * Requirements:
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 c = a * b;
146         require(c / a == b, "SafeMath: multiplication overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers. Reverts on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator. Note: this function uses a
156      * `revert` opcode (which leaves remaining gas untouched) while Solidity
157      * uses an invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Solidity only automatically asserts when dividing by 0
164         require(b > 0, "SafeMath: division by zero");
165         uint256 c = a / b;
166         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b != 0, "SafeMath: modulo by zero");
184         return a % b;
185     }
186 }
187 
188 
189 /**
190  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
191  * the optional functions; to access them see `ERC20Detailed`.
192  */
193 interface IERC20 {
194     /**
195      * @dev Returns the amount of tokens in existence.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `recipient`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a `Transfer` event.
210      */
211     function transfer(address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Returns the remaining number of tokens that `spender` will be
215      * allowed to spend on behalf of `owner` through `transferFrom`. This is
216      * zero by default.
217      *
218      * This value changes when `approve` or `transferFrom` are called.
219      */
220     function allowance(address owner, address spender) external view returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * > Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an `Approval` event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a `Transfer` event.
246      */
247     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be zero.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to `approve`. `value` is the new allowance.
260      */
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 
265 /**
266  * @dev Optional functions from the ERC20 standard.
267  */
268 contract ERC20Detailed is IERC20 {
269     string private _name;
270     string private _symbol;
271     uint8 private _decimals;
272 
273     /**
274      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
275      * these values are immutable: they can only be set once during
276      * construction.
277      */
278     constructor (string memory name, string memory symbol, uint8 decimals) public {
279         _name = name;
280         _symbol = symbol;
281         _decimals = decimals;
282     }
283 
284     /**
285      * @dev Returns the name of the token.
286      */
287     function name() public view returns (string memory) {
288         return _name;
289     }
290 
291     /**
292      * @dev Returns the symbol of the token, usually a shorter version of the
293      * name.
294      */
295     function symbol() public view returns (string memory) {
296         return _symbol;
297     }
298 
299     /**
300      * @dev Returns the number of decimals used to get its user representation.
301      * For example, if `decimals` equals `2`, a balance of `505` tokens should
302      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
303      *
304      * Tokens usually opt for a value of 18, imitating the relationship between
305      * Ether and Wei.
306      *
307      * > Note that this information is only used for _display_ purposes: it in
308      * no way affects any of the arithmetic of the contract, including
309      * `IERC20.balanceOf` and `IERC20.transfer`.
310      */
311     function decimals() public view returns (uint8) {
312         return _decimals;
313     }
314 }
315 
316 
317 /**
318  * @dev Collection of functions related to the address type,
319  */
320 library Address {
321     /**
322      * @dev Returns true if `account` is a contract.
323      *
324      * This test is non-exhaustive, and there may be false-negatives: during the
325      * execution of a contract's constructor, its address will be reported as
326      * not containing a contract.
327      *
328      * > It is unsafe to assume that an address for which this function returns
329      * false is an externally-owned account (EOA) and not a contract.
330      */
331     function isContract(address account) internal view returns (bool) {
332         // This method relies in extcodesize, which returns 0 for contracts in
333         // construction, since the code is only stored at the end of the
334         // constructor execution.
335 
336         uint256 size;
337         // solhint-disable-next-line no-inline-assembly
338         assembly { size := extcodesize(account) }
339         return size > 0;
340     }
341 }
342 
343 
344 /**
345  * @title SafeERC20
346  * @dev Wrappers around ERC20 operations that throw on failure (when the token
347  * contract returns false). Tokens that return no value (and instead revert or
348  * throw on failure) are also supported, non-reverting calls are assumed to be
349  * successful.
350  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
351  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
352  */
353 library SafeERC20 {
354     using SafeMath for uint256;
355     using Address for address;
356 
357     function safeTransfer(IERC20 token, address to, uint256 value) internal {
358         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
359     }
360 
361     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
362         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
363     }
364 
365     function safeApprove(IERC20 token, address spender, uint256 value) internal {
366         // safeApprove should only be called when setting an initial allowance,
367         // or when resetting it to zero. To increase and decrease it, use
368         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
369         // solhint-disable-next-line max-line-length
370         require((value == 0) || (token.allowance(address(this), spender) == 0),
371             "SafeERC20: approve from non-zero to non-zero allowance"
372         );
373         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
374     }
375 
376     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
377         uint256 newAllowance = token.allowance(address(this), spender).add(value);
378         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
379     }
380 
381     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
382         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
383         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
384     }
385 
386     /**
387      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
388      * on the return value: the return value is optional (but if data is returned, it must not be false).
389      * @param token The token targeted by the call.
390      * @param data The call data (encoded using abi.encode or one of its variants).
391      */
392     function callOptionalReturn(IERC20 token, bytes memory data) private {
393         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
394         // we're implementing it ourselves.
395 
396         // A Solidity high level call has three parts:
397         //  1. The target address is checked to verify it contains contract code
398         //  2. The call itself is made, and success asserted
399         //  3. The return value is decoded, which in turn checks the size of the returned data.
400         // solhint-disable-next-line max-line-length
401         require(address(token).isContract(), "SafeERC20: call to non-contract");
402 
403         // solhint-disable-next-line avoid-low-level-calls
404         (bool success, bytes memory returndata) = address(token).call(data);
405         require(success, "SafeERC20: low-level call failed");
406 
407         if (returndata.length > 0) { // Return data is optional
408             // solhint-disable-next-line max-line-length
409             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
410         }
411     }
412 }
413 
414 
415 /**
416  * @dev Contract module that helps prevent reentrant calls to a function.
417  *
418  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
419  * available, which can be aplied to functions to make sure there are no nested
420  * (reentrant) calls to them.
421  *
422  * Note that because there is a single `nonReentrant` guard, functions marked as
423  * `nonReentrant` may not call one another. This can be worked around by making
424  * those functions `private`, and then adding `external` `nonReentrant` entry
425  * points to them.
426  */
427 contract ReentrancyGuard {
428     /// @dev counter to allow mutex lock with only one SSTORE operation
429     uint256 private _guardCounter;
430 
431     constructor () internal {
432         // The counter starts at one to prevent changing it from zero to a non-zero
433         // value, which is a more expensive operation.
434         _guardCounter = 1;
435     }
436 
437     /**
438      * @dev Prevents a contract from calling itself, directly or indirectly.
439      * Calling a `nonReentrant` function from another `nonReentrant`
440      * function is not supported. It is possible to prevent this from happening
441      * by making the `nonReentrant` function external, and make it call a
442      * `private` function that does the actual work.
443      */
444     modifier nonReentrant() {
445         _guardCounter += 1;
446         uint256 localCounter = _guardCounter;
447         _;
448         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
449     }
450 }
451 
452 
453 // https://docs.synthetix.io/contracts/source/interfaces/istakingrewards
454 interface IStakingRewards {
455     // Views
456     function lastTimeRewardApplicable() external view returns (uint256);
457 
458     function rewardPerToken() external view returns (uint256);
459 
460     function earned(address account) external view returns (uint256);
461 
462     function getRewardForDuration() external view returns (uint256);
463 
464     function totalSupply() external view returns (uint256);
465 
466     function balanceOf(address account) external view returns (uint256);
467 
468     // Mutative
469 
470     function stake(uint256 amount) external;
471 
472     function withdraw(uint256 amount) external;
473 
474     function getReward() external;
475 
476     function exit() external;
477 }
478 
479 
480 // https://docs.synthetix.io/contracts/source/contracts/owned
481 contract Owned {
482     address public owner;
483     address public nominatedOwner;
484 
485     constructor(address _owner) public {
486         require(_owner != address(0), "Owner address cannot be 0");
487         owner = _owner;
488         emit OwnerChanged(address(0), _owner);
489     }
490 
491     function nominateNewOwner(address _owner) external onlyOwner {
492         nominatedOwner = _owner;
493         emit OwnerNominated(_owner);
494     }
495 
496     function acceptOwnership() external {
497         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
498         emit OwnerChanged(owner, nominatedOwner);
499         owner = nominatedOwner;
500         nominatedOwner = address(0);
501     }
502 
503     modifier onlyOwner {
504         _onlyOwner();
505         _;
506     }
507 
508     function _onlyOwner() private view {
509         require(msg.sender == owner, "Only the contract owner may perform this action");
510     }
511 
512     event OwnerNominated(address newOwner);
513     event OwnerChanged(address oldOwner, address newOwner);
514 }
515 
516 
517 // Inheritance
518 
519 
520 // https://docs.synthetix.io/contracts/source/contracts/rewardsdistributionrecipient
521 contract RewardsDistributionRecipient is Owned {
522     address public rewardsDistribution;
523 
524     function notifyRewardAmount(uint256 reward) external;
525 
526     modifier onlyRewardsDistribution() {
527         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
528         _;
529     }
530 
531     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
532         rewardsDistribution = _rewardsDistribution;
533     }
534 }
535 
536 
537 // Inheritance
538 
539 
540 // https://docs.synthetix.io/contracts/source/contracts/pausable
541 contract Pausable is Owned {
542     uint public lastPauseTime;
543     bool public paused;
544 
545     constructor() internal {
546         // This contract is abstract, and thus cannot be instantiated directly
547         require(owner != address(0), "Owner must be set");
548         // Paused will be false, and lastPauseTime will be 0 upon initialisation
549     }
550 
551     /**
552      * @notice Change the paused state of the contract
553      * @dev Only the contract owner may call this.
554      */
555     function setPaused(bool _paused) external onlyOwner {
556         // Ensure we're actually changing the state before we do anything
557         if (_paused == paused) {
558             return;
559         }
560 
561         // Set our paused state.
562         paused = _paused;
563 
564         // If applicable, set the last pause time.
565         if (paused) {
566             lastPauseTime = now;
567         }
568 
569         // Let everyone know that our pause state has changed.
570         emit PauseChanged(paused);
571     }
572 
573     event PauseChanged(bool isPaused);
574 
575     modifier notPaused {
576         require(!paused, "This action cannot be performed while the contract is paused");
577         _;
578     }
579 }
580 
581 
582 // Inheritance
583 
584 
585 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
586 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
587     using SafeMath for uint256;
588     using SafeERC20 for IERC20;
589 
590     /* ========== STATE VARIABLES ========== */
591 
592     IERC20 public rewardsToken;
593     IERC20 public stakingToken;
594     uint256 public periodFinish = 0;
595     uint256 public rewardRate = 0;
596     uint256 public rewardsDuration = 7 days;
597     uint256 public lastUpdateTime;
598     uint256 public rewardPerTokenStored;
599 
600     mapping(address => uint256) public userRewardPerTokenPaid;
601     mapping(address => uint256) public rewards;
602 
603     uint256 private _totalSupply;
604     mapping(address => uint256) private _balances;
605 
606     /* ========== CONSTRUCTOR ========== */
607 
608     constructor(
609         address _owner,
610         address _rewardsDistribution,
611         address _rewardsToken,
612         address _stakingToken
613     ) public Owned(_owner) {
614         rewardsToken = IERC20(_rewardsToken);
615         stakingToken = IERC20(_stakingToken);
616         rewardsDistribution = _rewardsDistribution;
617     }
618 
619     /* ========== VIEWS ========== */
620 
621     function totalSupply() external view returns (uint256) {
622         return _totalSupply;
623     }
624 
625     function balanceOf(address account) external view returns (uint256) {
626         return _balances[account];
627     }
628 
629     function lastTimeRewardApplicable() public view returns (uint256) {
630         return Math.min(block.timestamp, periodFinish);
631     }
632 
633     function rewardPerToken() public view returns (uint256) {
634         if (_totalSupply == 0) {
635             return rewardPerTokenStored;
636         }
637         return
638             rewardPerTokenStored.add(
639                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
640             );
641     }
642 
643     function earned(address account) public view returns (uint256) {
644         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
645     }
646 
647     function getRewardForDuration() external view returns (uint256) {
648         return rewardRate.mul(rewardsDuration);
649     }
650 
651     /* ========== MUTATIVE FUNCTIONS ========== */
652 
653     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
654         require(amount > 0, "Cannot stake 0");
655         _totalSupply = _totalSupply.add(amount);
656         _balances[msg.sender] = _balances[msg.sender].add(amount);
657         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
658         emit Staked(msg.sender, amount);
659     }
660 
661     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
662         require(amount > 0, "Cannot withdraw 0");
663         _totalSupply = _totalSupply.sub(amount);
664         _balances[msg.sender] = _balances[msg.sender].sub(amount);
665         stakingToken.safeTransfer(msg.sender, amount);
666         emit Withdrawn(msg.sender, amount);
667     }
668 
669     function getReward() public nonReentrant updateReward(msg.sender) {
670         uint256 reward = rewards[msg.sender];
671         if (reward > 0) {
672             rewards[msg.sender] = 0;
673             rewardsToken.safeTransfer(msg.sender, reward);
674             emit RewardPaid(msg.sender, reward);
675         }
676     }
677 
678     function exit() external {
679         withdraw(_balances[msg.sender]);
680         getReward();
681     }
682 
683     /* ========== RESTRICTED FUNCTIONS ========== */
684 
685     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
686         if (block.timestamp >= periodFinish) {
687             rewardRate = reward.div(rewardsDuration);
688         } else {
689             uint256 remaining = periodFinish.sub(block.timestamp);
690             uint256 leftover = remaining.mul(rewardRate);
691             rewardRate = reward.add(leftover).div(rewardsDuration);
692         }
693 
694         // Ensure the provided reward amount is not more than the balance in the contract.
695         // This keeps the reward rate in the right range, preventing overflows due to
696         // very high values of rewardRate in the earned and rewardsPerToken functions;
697         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
698         uint balance = rewardsToken.balanceOf(address(this));
699         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
700 
701         lastUpdateTime = block.timestamp;
702         periodFinish = block.timestamp.add(rewardsDuration);
703         emit RewardAdded(reward);
704     }
705 
706     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
707     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
708         require(
709             tokenAddress != address(stakingToken),
710             "Cannot withdraw the staking token"
711         );
712         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
713         emit Recovered(tokenAddress, tokenAmount);
714     }
715 
716     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
717         require(
718             block.timestamp > periodFinish,
719             "Previous rewards period must be complete before changing the duration for the new period"
720         );
721         rewardsDuration = _rewardsDuration;
722         emit RewardsDurationUpdated(rewardsDuration);
723     }
724 
725     /* ========== MODIFIERS ========== */
726 
727     modifier updateReward(address account) {
728         rewardPerTokenStored = rewardPerToken();
729         lastUpdateTime = lastTimeRewardApplicable();
730         if (account != address(0)) {
731             rewards[account] = earned(account);
732             userRewardPerTokenPaid[account] = rewardPerTokenStored;
733         }
734         _;
735     }
736 
737     /* ========== EVENTS ========== */
738 
739     event RewardAdded(uint256 reward);
740     event Staked(address indexed user, uint256 amount);
741     event Withdrawn(address indexed user, uint256 amount);
742     event RewardPaid(address indexed user, uint256 reward);
743     event RewardsDurationUpdated(uint256 newDuration);
744     event Recovered(address token, uint256 amount);
745 }