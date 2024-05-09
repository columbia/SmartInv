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
22 *	- SafeERC20
23 *	- SafeMath
24 *
25 * MIT License
26 * ===========
27 *
28 * Copyright (c) 2022 Synthetix
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
47 
48 
49 
50 pragma solidity ^0.5.0;
51 
52 /**
53  * @dev Wrappers over Solidity's arithmetic operations with added overflow
54  * checks.
55  *
56  * Arithmetic operations in Solidity wrap on overflow. This can easily result
57  * in bugs, because programmers usually assume that an overflow raises an
58  * error, which is the standard behavior in high level programming languages.
59  * `SafeMath` restores this intuition by reverting the transaction when an
60  * operation overflows.
61  *
62  * Using this library instead of the unchecked operations eliminates an entire
63  * class of bugs, so it's recommended to use it always.
64  */
65 library SafeMath {
66     /**
67      * @dev Returns the addition of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `+` operator.
71      *
72      * Requirements:
73      * - Addition cannot overflow.
74      */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a, "SafeMath: addition overflow");
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the subtraction of two unsigned integers, reverting on
84      * overflow (when the result is negative).
85      *
86      * Counterpart to Solidity's `-` operator.
87      *
88      * Requirements:
89      * - Subtraction cannot overflow.
90      */
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b <= a, "SafeMath: subtraction overflow");
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         // Solidity only automatically asserts when dividing by 0
134         require(b > 0, "SafeMath: division by zero");
135         uint256 c = a / b;
136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b != 0, "SafeMath: modulo by zero");
154         return a % b;
155     }
156 }
157 
158 
159 /**
160  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
161  * the optional functions; to access them see `ERC20Detailed`.
162  */
163 interface IERC20 {
164     /**
165      * @dev Returns the amount of tokens in existence.
166      */
167     function totalSupply() external view returns (uint256);
168 
169     /**
170      * @dev Returns the amount of tokens owned by `account`.
171      */
172     function balanceOf(address account) external view returns (uint256);
173 
174     /**
175      * @dev Moves `amount` tokens from the caller's account to `recipient`.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a `Transfer` event.
180      */
181     function transfer(address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through `transferFrom`. This is
186      * zero by default.
187      *
188      * This value changes when `approve` or `transferFrom` are called.
189      */
190     function allowance(address owner, address spender) external view returns (uint256);
191 
192     /**
193      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * > Beware that changing an allowance with this method brings the risk
198      * that someone may use both the old and the new allowance by unfortunate
199      * transaction ordering. One possible solution to mitigate this race
200      * condition is to first reduce the spender's allowance to 0 and set the
201      * desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      *
204      * Emits an `Approval` event.
205      */
206     function approve(address spender, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Moves `amount` tokens from `sender` to `recipient` using the
210      * allowance mechanism. `amount` is then deducted from the caller's
211      * allowance.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a `Transfer` event.
216      */
217     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Emitted when `value` tokens are moved from one account (`from`) to
221      * another (`to`).
222      *
223      * Note that `value` may be zero.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /**
228      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
229      * a call to `approve`. `value` is the new allowance.
230      */
231     event Approval(address indexed owner, address indexed spender, uint256 value);
232 }
233 
234 
235 /**
236  * @dev Optional functions from the ERC20 standard.
237  */
238 contract ERC20Detailed is IERC20 {
239     string private _name;
240     string private _symbol;
241     uint8 private _decimals;
242 
243     /**
244      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
245      * these values are immutable: they can only be set once during
246      * construction.
247      */
248     constructor (string memory name, string memory symbol, uint8 decimals) public {
249         _name = name;
250         _symbol = symbol;
251         _decimals = decimals;
252     }
253 
254     /**
255      * @dev Returns the name of the token.
256      */
257     function name() public view returns (string memory) {
258         return _name;
259     }
260 
261     /**
262      * @dev Returns the symbol of the token, usually a shorter version of the
263      * name.
264      */
265     function symbol() public view returns (string memory) {
266         return _symbol;
267     }
268 
269     /**
270      * @dev Returns the number of decimals used to get its user representation.
271      * For example, if `decimals` equals `2`, a balance of `505` tokens should
272      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
273      *
274      * Tokens usually opt for a value of 18, imitating the relationship between
275      * Ether and Wei.
276      *
277      * > Note that this information is only used for _display_ purposes: it in
278      * no way affects any of the arithmetic of the contract, including
279      * `IERC20.balanceOf` and `IERC20.transfer`.
280      */
281     function decimals() public view returns (uint8) {
282         return _decimals;
283     }
284 }
285 
286 
287 /**
288  * @dev Collection of functions related to the address type,
289  */
290 library Address {
291     /**
292      * @dev Returns true if `account` is a contract.
293      *
294      * This test is non-exhaustive, and there may be false-negatives: during the
295      * execution of a contract's constructor, its address will be reported as
296      * not containing a contract.
297      *
298      * > It is unsafe to assume that an address for which this function returns
299      * false is an externally-owned account (EOA) and not a contract.
300      */
301     function isContract(address account) internal view returns (bool) {
302         // This method relies in extcodesize, which returns 0 for contracts in
303         // construction, since the code is only stored at the end of the
304         // constructor execution.
305 
306         uint256 size;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { size := extcodesize(account) }
309         return size > 0;
310     }
311 }
312 
313 
314 /**
315  * @title SafeERC20
316  * @dev Wrappers around ERC20 operations that throw on failure (when the token
317  * contract returns false). Tokens that return no value (and instead revert or
318  * throw on failure) are also supported, non-reverting calls are assumed to be
319  * successful.
320  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
321  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
322  */
323 library SafeERC20 {
324     using SafeMath for uint256;
325     using Address for address;
326 
327     function safeTransfer(IERC20 token, address to, uint256 value) internal {
328         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
329     }
330 
331     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
332         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
333     }
334 
335     function safeApprove(IERC20 token, address spender, uint256 value) internal {
336         // safeApprove should only be called when setting an initial allowance,
337         // or when resetting it to zero. To increase and decrease it, use
338         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
339         // solhint-disable-next-line max-line-length
340         require((value == 0) || (token.allowance(address(this), spender) == 0),
341             "SafeERC20: approve from non-zero to non-zero allowance"
342         );
343         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
344     }
345 
346     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
347         uint256 newAllowance = token.allowance(address(this), spender).add(value);
348         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
349     }
350 
351     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
352         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
353         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
354     }
355 
356     /**
357      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
358      * on the return value: the return value is optional (but if data is returned, it must not be false).
359      * @param token The token targeted by the call.
360      * @param data The call data (encoded using abi.encode or one of its variants).
361      */
362     function callOptionalReturn(IERC20 token, bytes memory data) private {
363         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
364         // we're implementing it ourselves.
365 
366         // A Solidity high level call has three parts:
367         //  1. The target address is checked to verify it contains contract code
368         //  2. The call itself is made, and success asserted
369         //  3. The return value is decoded, which in turn checks the size of the returned data.
370         // solhint-disable-next-line max-line-length
371         require(address(token).isContract(), "SafeERC20: call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = address(token).call(data);
375         require(success, "SafeERC20: low-level call failed");
376 
377         if (returndata.length > 0) { // Return data is optional
378             // solhint-disable-next-line max-line-length
379             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
380         }
381     }
382 }
383 
384 
385 /**
386  * @dev Contract module that helps prevent reentrant calls to a function.
387  *
388  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
389  * available, which can be aplied to functions to make sure there are no nested
390  * (reentrant) calls to them.
391  *
392  * Note that because there is a single `nonReentrant` guard, functions marked as
393  * `nonReentrant` may not call one another. This can be worked around by making
394  * those functions `private`, and then adding `external` `nonReentrant` entry
395  * points to them.
396  */
397 contract ReentrancyGuard {
398     /// @dev counter to allow mutex lock with only one SSTORE operation
399     uint256 private _guardCounter;
400 
401     constructor () internal {
402         // The counter starts at one to prevent changing it from zero to a non-zero
403         // value, which is a more expensive operation.
404         _guardCounter = 1;
405     }
406 
407     /**
408      * @dev Prevents a contract from calling itself, directly or indirectly.
409      * Calling a `nonReentrant` function from another `nonReentrant`
410      * function is not supported. It is possible to prevent this from happening
411      * by making the `nonReentrant` function external, and make it call a
412      * `private` function that does the actual work.
413      */
414     modifier nonReentrant() {
415         _guardCounter += 1;
416         uint256 localCounter = _guardCounter;
417         _;
418         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
419     }
420 }
421 
422 
423 // https://docs.synthetix.io/contracts/source/interfaces/istakingrewards
424 interface IStakingRewards {
425     // Views
426 
427     function balanceOf(address account) external view returns (uint256);
428 
429     function earned(address account) external view returns (uint256);
430 
431     function getRewardForDuration() external view returns (uint256);
432 
433     function lastTimeRewardApplicable() external view returns (uint256);
434 
435     function rewardPerToken() external view returns (uint256);
436 
437     function rewardsDistribution() external view returns (address);
438 
439     function rewardsToken() external view returns (address);
440 
441     function totalSupply() external view returns (uint256);
442 
443     // Mutative
444 
445     function exit() external;
446 
447     function getReward() external;
448 
449     function stake(uint256 amount) external;
450 
451     function withdraw(uint256 amount) external;
452 }
453 
454 
455 // https://docs.synthetix.io/contracts/source/contracts/owned
456 contract Owned {
457     address public owner;
458     address public nominatedOwner;
459 
460     constructor(address _owner) public {
461         require(_owner != address(0), "Owner address cannot be 0");
462         owner = _owner;
463         emit OwnerChanged(address(0), _owner);
464     }
465 
466     function nominateNewOwner(address _owner) external onlyOwner {
467         nominatedOwner = _owner;
468         emit OwnerNominated(_owner);
469     }
470 
471     function acceptOwnership() external {
472         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
473         emit OwnerChanged(owner, nominatedOwner);
474         owner = nominatedOwner;
475         nominatedOwner = address(0);
476     }
477 
478     modifier onlyOwner {
479         _onlyOwner();
480         _;
481     }
482 
483     function _onlyOwner() private view {
484         require(msg.sender == owner, "Only the contract owner may perform this action");
485     }
486 
487     event OwnerNominated(address newOwner);
488     event OwnerChanged(address oldOwner, address newOwner);
489 }
490 
491 
492 // Inheritance
493 
494 
495 // https://docs.synthetix.io/contracts/source/contracts/rewardsdistributionrecipient
496 contract RewardsDistributionRecipient is Owned {
497     address public rewardsDistribution;
498 
499     function notifyRewardAmount(uint256 reward) external;
500 
501     modifier onlyRewardsDistribution() {
502         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
503         _;
504     }
505 
506     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
507         rewardsDistribution = _rewardsDistribution;
508     }
509 }
510 
511 
512 // Inheritance
513 
514 
515 // https://docs.synthetix.io/contracts/source/contracts/pausable
516 contract Pausable is Owned {
517     uint public lastPauseTime;
518     bool public paused;
519 
520     constructor() internal {
521         // This contract is abstract, and thus cannot be instantiated directly
522         require(owner != address(0), "Owner must be set");
523         // Paused will be false, and lastPauseTime will be 0 upon initialisation
524     }
525 
526     /**
527      * @notice Change the paused state of the contract
528      * @dev Only the contract owner may call this.
529      */
530     function setPaused(bool _paused) external onlyOwner {
531         // Ensure we're actually changing the state before we do anything
532         if (_paused == paused) {
533             return;
534         }
535 
536         // Set our paused state.
537         paused = _paused;
538 
539         // If applicable, set the last pause time.
540         if (paused) {
541             lastPauseTime = now;
542         }
543 
544         // Let everyone know that our pause state has changed.
545         emit PauseChanged(paused);
546     }
547 
548     event PauseChanged(bool isPaused);
549 
550     modifier notPaused {
551         require(!paused, "This action cannot be performed while the contract is paused");
552         _;
553     }
554 }
555 
556 
557 // Inheritance
558 
559 
560 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
561 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
562     using SafeMath for uint256;
563     using SafeERC20 for IERC20;
564 
565     /* ========== STATE VARIABLES ========== */
566 
567     IERC20 public rewardsToken;
568     IERC20 public stakingToken;
569     uint256 public periodFinish = 0;
570     uint256 public rewardRate = 0;
571     uint256 public rewardsDuration = 7 days;
572     uint256 public lastUpdateTime;
573     uint256 public rewardPerTokenStored;
574 
575     mapping(address => uint256) public userRewardPerTokenPaid;
576     mapping(address => uint256) public rewards;
577 
578     uint256 private _totalSupply;
579     mapping(address => uint256) private _balances;
580 
581     /* ========== CONSTRUCTOR ========== */
582 
583     constructor(
584         address _owner,
585         address _rewardsDistribution,
586         address _rewardsToken,
587         address _stakingToken
588     ) public Owned(_owner) {
589         rewardsToken = IERC20(_rewardsToken);
590         stakingToken = IERC20(_stakingToken);
591         rewardsDistribution = _rewardsDistribution;
592     }
593 
594     /* ========== VIEWS ========== */
595 
596     function totalSupply() external view returns (uint256) {
597         return _totalSupply;
598     }
599 
600     function balanceOf(address account) external view returns (uint256) {
601         return _balances[account];
602     }
603 
604     function lastTimeRewardApplicable() public view returns (uint256) {
605         return block.timestamp < periodFinish ? block.timestamp : periodFinish;
606     }
607 
608     function rewardPerToken() public view returns (uint256) {
609         if (_totalSupply == 0) {
610             return rewardPerTokenStored;
611         }
612         return
613             rewardPerTokenStored.add(
614                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
615             );
616     }
617 
618     function earned(address account) public view returns (uint256) {
619         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
620     }
621 
622     function getRewardForDuration() external view returns (uint256) {
623         return rewardRate.mul(rewardsDuration);
624     }
625 
626     /* ========== MUTATIVE FUNCTIONS ========== */
627 
628     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
629         require(amount > 0, "Cannot stake 0");
630         _totalSupply = _totalSupply.add(amount);
631         _balances[msg.sender] = _balances[msg.sender].add(amount);
632         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
633         emit Staked(msg.sender, amount);
634     }
635 
636     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
637         require(amount > 0, "Cannot withdraw 0");
638         _totalSupply = _totalSupply.sub(amount);
639         _balances[msg.sender] = _balances[msg.sender].sub(amount);
640         stakingToken.safeTransfer(msg.sender, amount);
641         emit Withdrawn(msg.sender, amount);
642     }
643 
644     function getReward() public nonReentrant updateReward(msg.sender) {
645         uint256 reward = rewards[msg.sender];
646         if (reward > 0) {
647             rewards[msg.sender] = 0;
648             rewardsToken.safeTransfer(msg.sender, reward);
649             emit RewardPaid(msg.sender, reward);
650         }
651     }
652 
653     function exit() external {
654         withdraw(_balances[msg.sender]);
655         getReward();
656     }
657 
658     /* ========== RESTRICTED FUNCTIONS ========== */
659 
660     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
661         if (block.timestamp >= periodFinish) {
662             rewardRate = reward.div(rewardsDuration);
663         } else {
664             uint256 remaining = periodFinish.sub(block.timestamp);
665             uint256 leftover = remaining.mul(rewardRate);
666             rewardRate = reward.add(leftover).div(rewardsDuration);
667         }
668 
669         // Ensure the provided reward amount is not more than the balance in the contract.
670         // This keeps the reward rate in the right range, preventing overflows due to
671         // very high values of rewardRate in the earned and rewardsPerToken functions;
672         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
673         uint balance = rewardsToken.balanceOf(address(this));
674         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
675 
676         lastUpdateTime = block.timestamp;
677         periodFinish = block.timestamp.add(rewardsDuration);
678         emit RewardAdded(reward);
679     }
680 
681     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
682     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
683         require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");
684         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
685         emit Recovered(tokenAddress, tokenAmount);
686     }
687 
688     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
689         require(
690             block.timestamp > periodFinish,
691             "Previous rewards period must be complete before changing the duration for the new period"
692         );
693         rewardsDuration = _rewardsDuration;
694         emit RewardsDurationUpdated(rewardsDuration);
695     }
696 
697     /* ========== MODIFIERS ========== */
698 
699     modifier updateReward(address account) {
700         rewardPerTokenStored = rewardPerToken();
701         lastUpdateTime = lastTimeRewardApplicable();
702         if (account != address(0)) {
703             rewards[account] = earned(account);
704             userRewardPerTokenPaid[account] = rewardPerTokenStored;
705         }
706         _;
707     }
708 
709     /* ========== EVENTS ========== */
710 
711     event RewardAdded(uint256 reward);
712     event Staked(address indexed user, uint256 amount);
713     event Withdrawn(address indexed user, uint256 amount);
714     event RewardPaid(address indexed user, uint256 reward);
715     event RewardsDurationUpdated(uint256 newDuration);
716     event Recovered(address token, uint256 amount);
717 }