1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-18
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.5.17;
8 
9 /*
10  * Copied from: https://github.com/iamdefinitelyahuman/unipool-fork/blob/262a574/contracts/StakingRewards.sol
11  *
12 
13 //   _________ _______   ________  __      __  _________ __                        
14 //  /   _____/ \      \  \_____  \/  \    /  \/   _____//  |_  ___________  _____  
15 //  \_____  \  /   |   \  /   |   \   \/\/   /\_____  \\   __\/  _ \_  __ \/     \ 
16 //  /        \/    |    \/    |    \        / /        \|  | (  <_> )  | \/  Y Y  \
17 // /_______  /\____|__  /\_______  /\__/\  / /_______  /|__|  \____/|__|  |__|_|  /
18 //         \/         \/         \/      \/          \/                         \/ 
19 
20 // Snowstorm token geyser factory
21 // Based off SNX and UNI staking contracts
22 * Synthetix: StakingRewards.sol
23 *
24 * Docs: https://docs.synthetix.io/
25 *
26 *
27 * MIT License
28 * ===========
29 *
30 * Copyright (c) 2020 Synthetix
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
50 
51 library Address {
52     /**
53      * @dev Returns true if `account` is a contract.
54      *
55      * This test is non-exhaustive, and there may be false-negatives: during the
56      * execution of a contract's constructor, its address will be reported as
57      * not containing a contract.
58      *
59      * > It is unsafe to assume that an address for which this function returns
60      * false is an externally-owned account (EOA) and not a contract.
61      */
62     function isContract(address account) internal view returns (bool) {
63         // This method relies in extcodesize, which returns 0 for contracts in
64         // construction, since the code is only stored at the end of the
65         // constructor execution.
66 
67         uint256 size;
68         // solhint-disable-next-line no-inline-assembly
69         assembly { size := extcodesize(account) }
70         return size > 0;
71     }
72 }
73 
74 interface IERC20 {
75     /**
76      * @dev Returns the amount of tokens in existence.
77      */
78     function totalSupply() external view returns (uint256);
79 
80     /**
81      * @dev Returns the amount of tokens owned by `account`.
82      */
83     function balanceOf(address account) external view returns (uint256);
84 
85     /**
86      * @dev Moves `amount` tokens from the caller's account to `recipient`.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a `Transfer` event.
91      */
92     function transfer(address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Returns the remaining number of tokens that `spender` will be
96      * allowed to spend on behalf of `owner` through `transferFrom`. This is
97      * zero by default.
98      *
99      * This value changes when `approve` or `transferFrom` are called.
100      */
101     function allowance(address owner, address spender) external view returns (uint256);
102 
103     /**
104      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * > Beware that changing an allowance with this method brings the risk
109      * that someone may use both the old and the new allowance by unfortunate
110      * transaction ordering. One possible solution to mitigate this race
111      * condition is to first reduce the spender's allowance to 0 and set the
112      * desired value afterwards:
113      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114      *
115      * Emits an `Approval` event.
116      */
117     function approve(address spender, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Moves `amount` tokens from `sender` to `recipient` using the
121      * allowance mechanism. `amount` is then deducted from the caller's
122      * allowance.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a `Transfer` event.
127      */
128     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Emitted when `value` tokens are moved from one account (`from`) to
132      * another (`to`).
133      *
134      * Note that `value` may be zero.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 value);
137 
138     /**
139      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
140      * a call to `approve`. `value` is the new allowance.
141      */
142     event Approval(address indexed owner, address indexed spender, uint256 value);
143 }
144 
145 interface IStakingRewards {
146     // Views
147     function lastTimeRewardApplicable() external view returns (uint256);
148 
149     function rewardPerToken() external view returns (uint256);
150 
151     function earned(address account) external view returns (uint256);
152 
153     function getRewardForDuration() external view returns (uint256);
154 
155     function totalSupply() external view returns (uint256);
156 
157     function balanceOf(address account) external view returns (uint256);
158 
159     // Mutative
160 
161     function stake(uint256 amount) external;
162 
163     function withdraw(uint256 amount) external;
164 
165     function getReward() external;
166 
167     function exit() external;
168 }
169 
170 library Math {
171     /**
172      * @dev Returns the largest of two numbers.
173      */
174     function max(uint256 a, uint256 b) internal pure returns (uint256) {
175         return a >= b ? a : b;
176     }
177 
178     /**
179      * @dev Returns the smallest of two numbers.
180      */
181     function min(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a < b ? a : b;
183     }
184 
185     /**
186      * @dev Returns the average of two numbers. The result is rounded towards
187      * zero.
188      */
189     function average(uint256 a, uint256 b) internal pure returns (uint256) {
190         // (a + b) / 2 can overflow, so we distribute
191         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
192     }
193 }
194 
195 contract Owned {
196     address public owner;
197     address public nominatedOwner;
198 
199     constructor(address _owner) public {
200         require(_owner != address(0), "Owner address cannot be 0");
201         owner = _owner;
202         emit OwnerChanged(address(0), _owner);
203     }
204 
205     function nominateNewOwner(address _owner) external onlyOwner {
206         nominatedOwner = _owner;
207         emit OwnerNominated(_owner);
208     }
209 
210     function acceptOwnership() external {
211         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
212         emit OwnerChanged(owner, nominatedOwner);
213         owner = nominatedOwner;
214         nominatedOwner = address(0);
215     }
216 
217     modifier onlyOwner {
218         _onlyOwner();
219         _;
220     }
221 
222     function _onlyOwner() private view {
223         require(msg.sender == owner, "Only the contract owner may perform this action");
224     }
225 
226     event OwnerNominated(address newOwner);
227     event OwnerChanged(address oldOwner, address newOwner);
228 }
229 
230 contract Pausable is Owned {
231     uint public lastPauseTime;
232     bool public paused;
233 
234     constructor() internal {
235         // This contract is abstract, and thus cannot be instantiated directly
236         require(owner != address(0), "Owner must be set");
237         // Paused will be false, and lastPauseTime will be 0 upon initialisation
238     }
239 
240     /**
241      * @notice Change the paused state of the contract
242      * @dev Only the contract owner may call this.
243      */
244     function setPaused(bool _paused) external onlyOwner {
245         // Ensure we're actually changing the state before we do anything
246         if (_paused == paused) {
247             return;
248         }
249 
250         // Set our paused state.
251         paused = _paused;
252 
253         // If applicable, set the last pause time.
254         if (paused) {
255             lastPauseTime = now;
256         }
257 
258         // Let everyone know that our pause state has changed.
259         emit PauseChanged(paused);
260     }
261 
262     event PauseChanged(bool isPaused);
263 
264     modifier notPaused {
265         require(!paused, "This action cannot be performed while the contract is paused");
266         _;
267     }
268 }
269 
270 contract ReentrancyGuard {
271     /// @dev counter to allow mutex lock with only one SSTORE operation
272     uint256 private _guardCounter;
273 
274     constructor () internal {
275         // The counter starts at one to prevent changing it from zero to a non-zero
276         // value, which is a more expensive operation.
277         _guardCounter = 1;
278     }
279 
280     /**
281      * @dev Prevents a contract from calling itself, directly or indirectly.
282      * Calling a `nonReentrant` function from another `nonReentrant`
283      * function is not supported. It is possible to prevent this from happening
284      * by making the `nonReentrant` function external, and make it call a
285      * `private` function that does the actual work.
286      */
287     modifier nonReentrant() {
288         _guardCounter += 1;
289         uint256 localCounter = _guardCounter;
290         _;
291         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
292     }
293 }
294 
295 contract RewardsDistributionRecipient is Owned {
296     address public rewardsDistribution;
297 
298     function notifyRewardAmount(uint256 reward, address rewardHolder) external;
299 
300     modifier onlyRewardsDistribution() {
301         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
302         _;
303     }
304 
305     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
306         rewardsDistribution = _rewardsDistribution;
307     }
308 }
309 
310 library SafeERC20 {
311     using SafeMath for uint256;
312     using Address for address;
313 
314     function safeTransfer(IERC20 token, address to, uint256 value) internal {
315         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
316     }
317 
318     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
319         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
320     }
321 
322     function safeApprove(IERC20 token, address spender, uint256 value) internal {
323         // safeApprove should only be called when setting an initial allowance,
324         // or when resetting it to zero. To increase and decrease it, use
325         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
326         // solhint-disable-next-line max-line-length
327         require((value == 0) || (token.allowance(address(this), spender) == 0),
328             "SafeERC20: approve from non-zero to non-zero allowance"
329         );
330         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
331     }
332 
333     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
334         uint256 newAllowance = token.allowance(address(this), spender).add(value);
335         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
336     }
337 
338     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
339         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
340         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
341     }
342 
343     /**
344      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
345      * on the return value: the return value is optional (but if data is returned, it must not be false).
346      * @param token The token targeted by the call.
347      * @param data The call data (encoded using abi.encode or one of its variants).
348      */
349     function callOptionalReturn(IERC20 token, bytes memory data) private {
350         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
351         // we're implementing it ourselves.
352 
353         // A Solidity high level call has three parts:
354         //  1. The target address is checked to verify it contains contract code
355         //  2. The call itself is made, and success asserted
356         //  3. The return value is decoded, which in turn checks the size of the returned data.
357         // solhint-disable-next-line max-line-length
358         require(address(token).isContract(), "SafeERC20: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = address(token).call(data);
362         require(success, "SafeERC20: low-level call failed");
363 
364         if (returndata.length > 0) { // Return data is optional
365             // solhint-disable-next-line max-line-length
366             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
367         }
368     }
369 }
370 
371 library SafeMath {
372     /**
373      * @dev Returns the addition of two unsigned integers, reverting on
374      * overflow.
375      *
376      * Counterpart to Solidity's `+` operator.
377      *
378      * Requirements:
379      * - Addition cannot overflow.
380      */
381     function add(uint256 a, uint256 b) internal pure returns (uint256) {
382         uint256 c = a + b;
383         require(c >= a, "SafeMath: addition overflow");
384 
385         return c;
386     }
387 
388     /**
389      * @dev Returns the subtraction of two unsigned integers, reverting on
390      * overflow (when the result is negative).
391      *
392      * Counterpart to Solidity's `-` operator.
393      *
394      * Requirements:
395      * - Subtraction cannot overflow.
396      */
397     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
398         require(b <= a, "SafeMath: subtraction overflow");
399         uint256 c = a - b;
400 
401         return c;
402     }
403 
404     /**
405      * @dev Returns the multiplication of two unsigned integers, reverting on
406      * overflow.
407      *
408      * Counterpart to Solidity's `*` operator.
409      *
410      * Requirements:
411      * - Multiplication cannot overflow.
412      */
413     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
414         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
415         // benefit is lost if 'b' is also tested.
416         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
417         if (a == 0) {
418             return 0;
419         }
420 
421         uint256 c = a * b;
422         require(c / a == b, "SafeMath: multiplication overflow");
423 
424         return c;
425     }
426 
427     /**
428      * @dev Returns the integer division of two unsigned integers. Reverts on
429      * division by zero. The result is rounded towards zero.
430      *
431      * Counterpart to Solidity's `/` operator. Note: this function uses a
432      * `revert` opcode (which leaves remaining gas untouched) while Solidity
433      * uses an invalid opcode to revert (consuming all remaining gas).
434      *
435      * Requirements:
436      * - The divisor cannot be zero.
437      */
438     function div(uint256 a, uint256 b) internal pure returns (uint256) {
439         // Solidity only automatically asserts when dividing by 0
440         require(b > 0, "SafeMath: division by zero");
441         uint256 c = a / b;
442         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
443 
444         return c;
445     }
446 
447     /**
448      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
449      * Reverts when dividing by zero.
450      *
451      * Counterpart to Solidity's `%` operator. This function uses a `revert`
452      * opcode (which leaves remaining gas untouched) while Solidity uses an
453      * invalid opcode to revert (consuming all remaining gas).
454      *
455      * Requirements:
456      * - The divisor cannot be zero.
457      */
458     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
459         require(b != 0, "SafeMath: modulo by zero");
460         return a % b;
461     }
462 }
463 
464 interface IChainLinkFeed {
465     function latestAnswer() external view returns (int256);
466 }
467 
468 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
469     using SafeMath for uint256;
470     using SafeERC20 for IERC20;
471 
472     /* ========== STATE VARIABLES ========== */
473     IChainLinkFeed public constant FASTGAS = IChainLinkFeed(0x169E633A2D1E6c10dD91238Ba11c4A708dfEF37C);
474 
475     IERC20 public rewardsToken;
476     IERC20 public stakingToken;
477     uint256 public periodFinish = 0;
478     uint256 public rewardRate = 0;
479     uint256 public rewardsDuration;
480     uint256 public lastUpdateTime;
481     uint256 public rewardPerTokenStored;
482     uint256 public boostPrct;
483 
484     mapping(address => uint256) public userRewardPerTokenPaid;
485     mapping(address => uint256) public rewards;
486 
487     uint256 private _totalSupply;
488     mapping(address => uint256) private _balances;
489 
490     /* ========== CONSTRUCTOR ========== */
491 
492     constructor(
493         address _owner,
494         address _rewardsDistribution,
495         address _rewardsToken,
496         address _stakingToken,
497         uint256 _rewardsDuration,
498         uint _boostPrct
499     ) public Owned(_owner) {
500         rewardsToken = IERC20(_rewardsToken);
501         stakingToken = IERC20(_stakingToken);
502         rewardsDistribution = _rewardsDistribution;
503         rewardsDuration = _rewardsDuration;
504         boostPrct = _boostPrct;
505     }
506 
507     /* ========== VIEWS ========== */
508 
509     function totalSupply() external view returns (uint256) {
510         return _totalSupply;
511     }
512 
513     function getFastGas() external view returns (uint) {
514         return uint(FASTGAS.latestAnswer());
515     }
516 
517     function balanceOf(address account) external view returns (uint256) {
518         return _balances[account];
519     }
520 
521     function lastTimeRewardApplicable() public view returns (uint256) {
522         return Math.min(block.timestamp, periodFinish);
523     }
524 
525     function rewardPerToken() public view returns (uint256) {
526         if (_totalSupply == 0) {
527             return rewardPerTokenStored;
528         }
529         return
530             rewardPerTokenStored.add(
531                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
532             );
533     }
534 
535     function earned(address account) public view returns (uint256) {
536         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
537     }
538 
539     function getRewardForDuration() external view returns (uint256) {
540         return rewardRate.mul(rewardsDuration);
541     }
542 
543     /* ========== MUTATIVE FUNCTIONS ========== */
544 
545     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
546         require(amount > 0, "Cannot stake 0");
547         _totalSupply = _totalSupply.add(amount);
548         _balances[msg.sender] = _balances[msg.sender].add(amount);
549         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
550         emit Staked(msg.sender, amount);
551     }
552 
553     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
554         require(amount > 0, "Cannot withdraw 0");
555         _totalSupply = _totalSupply.sub(amount);
556         _balances[msg.sender] = _balances[msg.sender].sub(amount);
557         stakingToken.safeTransfer(msg.sender, amount);
558         emit Withdrawn(msg.sender, amount);
559     }
560 
561     function getReward() public nonReentrant updateReward(msg.sender) {
562         uint256 reward = rewards[msg.sender];
563         if (reward > 0) {
564             // Safe gaurd against error if reward is greater than balance in contract
565             uint balance = rewardsToken.balanceOf(address(this));
566             if (rewards[msg.sender] > balance) {
567                 reward = balance;
568             }
569             rewards[msg.sender] = 0;
570             rewardsToken.safeTransfer(msg.sender, reward);
571             emit RewardPaid(msg.sender, reward);
572         }
573     }
574 
575     function exit() external {
576         withdraw(_balances[msg.sender]);
577         getReward();
578     }
579 
580     /* ========== RESTRICTED FUNCTIONS ========== */
581 
582     function notifyRewardAmount(uint256 reward, address rewardHolder) external onlyRewardsDistribution updateReward(address(0)) {
583         // handle the transfer of reward tokens via `transferFrom` to reduce the number
584         // of transactions required and ensure correctness of the reward amount
585 
586         rewardsToken.safeTransferFrom(rewardHolder, address(this), reward);
587 
588         if (block.timestamp >= periodFinish) {
589             rewardRate = reward.div(rewardsDuration);
590         } else {
591             uint256 remaining = periodFinish.sub(block.timestamp);
592             uint256 leftover = remaining.mul(rewardRate);
593             rewardRate = reward.add(leftover).div(rewardsDuration);
594         }
595 
596         lastUpdateTime = block.timestamp;
597         periodFinish = block.timestamp.add(rewardsDuration);
598         emit RewardAdded(reward);
599     }
600 
601     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
602     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
603         require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");
604         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
605         emit Recovered(tokenAddress, tokenAmount);
606     }
607 
608     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
609         require(
610             block.timestamp > periodFinish,
611             "Previous rewards period must be complete before changing the duration for the new period"
612         );
613         rewardsDuration = _rewardsDuration;
614         emit RewardsDurationUpdated(rewardsDuration);
615     }
616 
617     /* ========== MODIFIERS ========== */
618 
619     modifier updateReward(address account) {
620         rewardPerTokenStored = rewardPerToken();
621         lastUpdateTime = lastTimeRewardApplicable();
622         if (account != address(0)) {
623             // bonus intial liquidity to bootstrap curve and create more realistic APYs
624             if (_totalSupply == 0) {
625                 rewards[account] = rewardRate
626                     .mul(rewardsDuration)
627                     .mul(boostPrct)
628                     .div(100)
629                     .add(earned(account));
630 
631                 // Based on notifyRewardAmount. Internally adjust reward rate to account for boost 
632                 uint256 rewardsLeft = rewardRate.mul(rewardsDuration) - rewards[account];
633                 uint256 remaining = periodFinish.sub(block.timestamp);
634                 rewardRate = rewardsLeft.div(remaining);
635                 
636                 // Ensure the provided reward amount is not more than the balance in the contract.
637                 // This keeps the reward rate in the right range, preventing overflows due to
638                 // very high values of rewardRate in the earned and rewardsPerToken functions;
639                 // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
640                 uint balance = rewardsToken.balanceOf(address(this));
641                 require(rewards[account] <= balance, "Provided reward too high");
642                 require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
643             }
644             rewards[account] = earned(account);
645             userRewardPerTokenPaid[account] = rewardPerTokenStored;
646         }
647         _;
648     }
649 
650     /* ========== EVENTS ========== */
651 
652     event RewardAdded(uint256 reward);
653     event Staked(address indexed user, uint256 amount);
654     event Withdrawn(address indexed user, uint256 amount);
655     event RewardPaid(address indexed user, uint256 reward);
656     event RewardsDurationUpdated(uint256 newDuration);
657     event Recovered(address token, uint256 amount);
658 }