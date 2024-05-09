1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * iBTC Staking Rewards
9 * Synthetix: StakingRewards.sol
10 *
11 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/StakingRewards.sol
12 * Docs: https://docs.synthetix.io/contracts/StakingRewards
13 *
14 * Contract Dependencies: 
15 *	- IERC20
16 *	- IStakingRewards
17 *	- Owned
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
49 /* ===============================================
50 * Flattened with Solidifier by Coinage
51 * 
52 * https://solidifier.coina.ge
53 * ===============================================
54 */
55 
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
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b <= a, "SafeMath: subtraction overflow");
129         uint256 c = a - b;
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `*` operator.
139      *
140      * Requirements:
141      * - Multiplication cannot overflow.
142      */
143     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
145         // benefit is lost if 'b' is also tested.
146         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
147         if (a == 0) {
148             return 0;
149         }
150 
151         uint256 c = a * b;
152         require(c / a == b, "SafeMath: multiplication overflow");
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers. Reverts on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator. Note: this function uses a
162      * `revert` opcode (which leaves remaining gas untouched) while Solidity
163      * uses an invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function div(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Solidity only automatically asserts when dividing by 0
170         require(b > 0, "SafeMath: division by zero");
171         uint256 c = a / b;
172         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      */
188     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b != 0, "SafeMath: modulo by zero");
190         return a % b;
191     }
192 }
193 
194 
195 /**
196  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
197  * the optional functions; to access them see `ERC20Detailed`.
198  */
199 interface IERC20 {
200     /**
201      * @dev Returns the amount of tokens in existence.
202      */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns the amount of tokens owned by `account`.
207      */
208     function balanceOf(address account) external view returns (uint256);
209 
210     /**
211      * @dev Moves `amount` tokens from the caller's account to `recipient`.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a `Transfer` event.
216      */
217     function transfer(address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Returns the remaining number of tokens that `spender` will be
221      * allowed to spend on behalf of `owner` through `transferFrom`. This is
222      * zero by default.
223      *
224      * This value changes when `approve` or `transferFrom` are called.
225      */
226     function allowance(address owner, address spender) external view returns (uint256);
227 
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * > Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an `Approval` event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Moves `amount` tokens from `sender` to `recipient` using the
246      * allowance mechanism. `amount` is then deducted from the caller's
247      * allowance.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a `Transfer` event.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
257      * another (`to`).
258      *
259      * Note that `value` may be zero.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 value);
262 
263     /**
264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
265      * a call to `approve`. `value` is the new allowance.
266      */
267     event Approval(address indexed owner, address indexed spender, uint256 value);
268 }
269 
270 
271 /**
272  * @dev Optional functions from the ERC20 standard.
273  */
274 contract ERC20Detailed is IERC20 {
275     string private _name;
276     string private _symbol;
277     uint8 private _decimals;
278 
279     /**
280      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
281      * these values are immutable: they can only be set once during
282      * construction.
283      */
284     constructor (string memory name, string memory symbol, uint8 decimals) public {
285         _name = name;
286         _symbol = symbol;
287         _decimals = decimals;
288     }
289 
290     /**
291      * @dev Returns the name of the token.
292      */
293     function name() public view returns (string memory) {
294         return _name;
295     }
296 
297     /**
298      * @dev Returns the symbol of the token, usually a shorter version of the
299      * name.
300      */
301     function symbol() public view returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @dev Returns the number of decimals used to get its user representation.
307      * For example, if `decimals` equals `2`, a balance of `505` tokens should
308      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
309      *
310      * Tokens usually opt for a value of 18, imitating the relationship between
311      * Ether and Wei.
312      *
313      * > Note that this information is only used for _display_ purposes: it in
314      * no way affects any of the arithmetic of the contract, including
315      * `IERC20.balanceOf` and `IERC20.transfer`.
316      */
317     function decimals() public view returns (uint8) {
318         return _decimals;
319     }
320 }
321 
322 
323 /**
324  * @dev Collection of functions related to the address type,
325  */
326 library Address {
327     /**
328      * @dev Returns true if `account` is a contract.
329      *
330      * This test is non-exhaustive, and there may be false-negatives: during the
331      * execution of a contract's constructor, its address will be reported as
332      * not containing a contract.
333      *
334      * > It is unsafe to assume that an address for which this function returns
335      * false is an externally-owned account (EOA) and not a contract.
336      */
337     function isContract(address account) internal view returns (bool) {
338         // This method relies in extcodesize, which returns 0 for contracts in
339         // construction, since the code is only stored at the end of the
340         // constructor execution.
341 
342         uint256 size;
343         // solhint-disable-next-line no-inline-assembly
344         assembly { size := extcodesize(account) }
345         return size > 0;
346     }
347 }
348 
349 
350 /**
351  * @title SafeERC20
352  * @dev Wrappers around ERC20 operations that throw on failure (when the token
353  * contract returns false). Tokens that return no value (and instead revert or
354  * throw on failure) are also supported, non-reverting calls are assumed to be
355  * successful.
356  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
357  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
358  */
359 library SafeERC20 {
360     using SafeMath for uint256;
361     using Address for address;
362 
363     function safeTransfer(IERC20 token, address to, uint256 value) internal {
364         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
365     }
366 
367     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
368         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
369     }
370 
371     function safeApprove(IERC20 token, address spender, uint256 value) internal {
372         // safeApprove should only be called when setting an initial allowance,
373         // or when resetting it to zero. To increase and decrease it, use
374         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
375         // solhint-disable-next-line max-line-length
376         require((value == 0) || (token.allowance(address(this), spender) == 0),
377             "SafeERC20: approve from non-zero to non-zero allowance"
378         );
379         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
380     }
381 
382     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
383         uint256 newAllowance = token.allowance(address(this), spender).add(value);
384         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
385     }
386 
387     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
388         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
389         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
390     }
391 
392     /**
393      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
394      * on the return value: the return value is optional (but if data is returned, it must not be false).
395      * @param token The token targeted by the call.
396      * @param data The call data (encoded using abi.encode or one of its variants).
397      */
398     function callOptionalReturn(IERC20 token, bytes memory data) private {
399         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
400         // we're implementing it ourselves.
401 
402         // A Solidity high level call has three parts:
403         //  1. The target address is checked to verify it contains contract code
404         //  2. The call itself is made, and success asserted
405         //  3. The return value is decoded, which in turn checks the size of the returned data.
406         // solhint-disable-next-line max-line-length
407         require(address(token).isContract(), "SafeERC20: call to non-contract");
408 
409         // solhint-disable-next-line avoid-low-level-calls
410         (bool success, bytes memory returndata) = address(token).call(data);
411         require(success, "SafeERC20: low-level call failed");
412 
413         if (returndata.length > 0) { // Return data is optional
414             // solhint-disable-next-line max-line-length
415             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
416         }
417     }
418 }
419 
420 
421 /**
422  * @dev Contract module that helps prevent reentrant calls to a function.
423  *
424  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
425  * available, which can be aplied to functions to make sure there are no nested
426  * (reentrant) calls to them.
427  *
428  * Note that because there is a single `nonReentrant` guard, functions marked as
429  * `nonReentrant` may not call one another. This can be worked around by making
430  * those functions `private`, and then adding `external` `nonReentrant` entry
431  * points to them.
432  */
433 contract ReentrancyGuard {
434     /// @dev counter to allow mutex lock with only one SSTORE operation
435     uint256 private _guardCounter;
436 
437     constructor () internal {
438         // The counter starts at one to prevent changing it from zero to a non-zero
439         // value, which is a more expensive operation.
440         _guardCounter = 1;
441     }
442 
443     /**
444      * @dev Prevents a contract from calling itself, directly or indirectly.
445      * Calling a `nonReentrant` function from another `nonReentrant`
446      * function is not supported. It is possible to prevent this from happening
447      * by making the `nonReentrant` function external, and make it call a
448      * `private` function that does the actual work.
449      */
450     modifier nonReentrant() {
451         _guardCounter += 1;
452         uint256 localCounter = _guardCounter;
453         _;
454         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
455     }
456 }
457 
458 
459 interface IStakingRewards {
460     // Views
461     function lastTimeRewardApplicable() external view returns (uint256);
462 
463     function rewardPerToken() external view returns (uint256);
464 
465     function earned(address account) external view returns (uint256);
466 
467     function getRewardForDuration() external view returns (uint256);
468 
469     function totalSupply() external view returns (uint256);
470 
471     function balanceOf(address account) external view returns (uint256);
472 
473     // Mutative
474 
475     function stake(uint256 amount) external;
476 
477     function withdraw(uint256 amount) external;
478 
479     function getReward() external;
480 
481     function exit() external;
482 }
483 
484 
485 // https://docs.synthetix.io/contracts/Owned
486 contract Owned {
487     address public owner;
488     address public nominatedOwner;
489 
490     constructor(address _owner) public {
491         require(_owner != address(0), "Owner address cannot be 0");
492         owner = _owner;
493         emit OwnerChanged(address(0), _owner);
494     }
495 
496     function nominateNewOwner(address _owner) external onlyOwner {
497         nominatedOwner = _owner;
498         emit OwnerNominated(_owner);
499     }
500 
501     function acceptOwnership() external {
502         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
503         emit OwnerChanged(owner, nominatedOwner);
504         owner = nominatedOwner;
505         nominatedOwner = address(0);
506     }
507 
508     modifier onlyOwner {
509         require(msg.sender == owner, "Only the contract owner may perform this action");
510         _;
511     }
512 
513     event OwnerNominated(address newOwner);
514     event OwnerChanged(address oldOwner, address newOwner);
515 }
516 
517 
518 // Inheritance
519 
520 
521 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
522 contract RewardsDistributionRecipient is Owned {
523     address public rewardsDistribution;
524 
525     function notifyRewardAmount(uint256 reward) external;
526 
527     modifier onlyRewardsDistribution() {
528         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
529         _;
530     }
531 
532     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
533         rewardsDistribution = _rewardsDistribution;
534     }
535 }
536 
537 
538 // Inheritance
539 
540 
541 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
542     using SafeMath for uint256;
543     using SafeERC20 for IERC20;
544 
545     /* ========== STATE VARIABLES ========== */
546 
547     IERC20 public rewardsToken;
548     IERC20 public stakingToken;
549     uint256 public periodFinish = 0;
550     uint256 public rewardRate = 0;
551     uint256 public rewardsDuration = 7 days;
552     uint256 public lastUpdateTime;
553     uint256 public rewardPerTokenStored;
554 
555     mapping(address => uint256) public userRewardPerTokenPaid;
556     mapping(address => uint256) public rewards;
557 
558     uint256 private _totalSupply;
559     mapping(address => uint256) private _balances;
560 
561     /* ========== CONSTRUCTOR ========== */
562 
563     constructor(
564         address _owner,
565         address _rewardsDistribution,
566         address _rewardsToken,
567         address _stakingToken
568     ) public Owned(_owner) {
569         rewardsToken = IERC20(_rewardsToken);
570         stakingToken = IERC20(_stakingToken);
571         rewardsDistribution = _rewardsDistribution;
572     }
573 
574     /* ========== VIEWS ========== */
575 
576     function totalSupply() external view returns (uint256) {
577         return _totalSupply;
578     }
579 
580     function balanceOf(address account) external view returns (uint256) {
581         return _balances[account];
582     }
583 
584     function lastTimeRewardApplicable() public view returns (uint256) {
585         return Math.min(block.timestamp, periodFinish);
586     }
587 
588     function rewardPerToken() public view returns (uint256) {
589         if (_totalSupply == 0) {
590             return rewardPerTokenStored;
591         }
592         return
593             rewardPerTokenStored.add(
594                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
595             );
596     }
597 
598     function earned(address account) public view returns (uint256) {
599         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
600     }
601 
602     function getRewardForDuration() external view returns (uint256) {
603         return rewardRate.mul(rewardsDuration);
604     }
605 
606     /* ========== MUTATIVE FUNCTIONS ========== */
607 
608     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
609         require(amount > 0, "Cannot stake 0");
610         _totalSupply = _totalSupply.add(amount);
611         _balances[msg.sender] = _balances[msg.sender].add(amount);
612         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
613         emit Staked(msg.sender, amount);
614     }
615 
616     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
617         require(amount > 0, "Cannot withdraw 0");
618         _totalSupply = _totalSupply.sub(amount);
619         _balances[msg.sender] = _balances[msg.sender].sub(amount);
620         stakingToken.safeTransfer(msg.sender, amount);
621         emit Withdrawn(msg.sender, amount);
622     }
623 
624     function getReward() public nonReentrant updateReward(msg.sender) {
625         uint256 reward = rewards[msg.sender];
626         if (reward > 0) {
627             rewards[msg.sender] = 0;
628             rewardsToken.safeTransfer(msg.sender, reward);
629             emit RewardPaid(msg.sender, reward);
630         }
631     }
632 
633     function exit() external {
634         withdraw(_balances[msg.sender]);
635         getReward();
636     }
637 
638     /* ========== RESTRICTED FUNCTIONS ========== */
639 
640     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
641         if (block.timestamp >= periodFinish) {
642             rewardRate = reward.div(rewardsDuration);
643         } else {
644             uint256 remaining = periodFinish.sub(block.timestamp);
645             uint256 leftover = remaining.mul(rewardRate);
646             rewardRate = reward.add(leftover).div(rewardsDuration);
647         }
648         lastUpdateTime = block.timestamp;
649         periodFinish = block.timestamp.add(rewardsDuration);
650         emit RewardAdded(reward);
651     }
652 
653     // Added to support recovering LP Rewards from other systems to be distributed to holders
654     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
655         // If it's SNX we have to query the token symbol to ensure its not a proxy or underlying
656         bool isSNX = (keccak256(bytes("SNX")) == keccak256(bytes(ERC20Detailed(tokenAddress).symbol())));
657         // Cannot recover the staking token or the rewards token
658         require(tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken) && !isSNX, "Cannot withdraw the staking or rewards tokens");
659         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
660         emit Recovered(tokenAddress, tokenAmount);
661     }
662 
663     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
664         require(periodFinish == 0 || block.timestamp > periodFinish, "Previous rewards period must be complete before changing the duration for the new period");
665         rewardsDuration = _rewardsDuration;
666         emit RewardsDurationUpdated(rewardsDuration);
667     }
668 
669     /* ========== MODIFIERS ========== */
670 
671     modifier updateReward(address account) {
672         rewardPerTokenStored = rewardPerToken();
673         lastUpdateTime = lastTimeRewardApplicable();
674         if (account != address(0)) {
675             rewards[account] = earned(account);
676             userRewardPerTokenPaid[account] = rewardPerTokenStored;
677         }
678         _;
679     }
680 
681     /* ========== EVENTS ========== */
682 
683     event RewardAdded(uint256 reward);
684     event Staked(address indexed user, uint256 amount);
685     event Withdrawn(address indexed user, uint256 amount);
686     event RewardPaid(address indexed user, uint256 reward);
687     event RewardsDurationUpdated(uint256 newDuration);
688     event Recovered(address token, uint256 amount);
689 }