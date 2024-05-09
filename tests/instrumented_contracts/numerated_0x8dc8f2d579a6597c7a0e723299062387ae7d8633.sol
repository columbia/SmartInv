1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-01
3 */
4 
5 // File: contracts/SafeMath.sol
6 
7 pragma solidity ^0.8.11;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         require(b <= a, "SafeMath: subtraction overflow");
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the multiplication of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `*` operator.
60      *
61      * Requirements:
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      * - The divisor cannot be zero.
88      */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Solidity only automatically asserts when dividing by 0
91         require(b > 0, "SafeMath: division by zero");
92         uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
100      * Reverts when dividing by zero.
101      *
102      * Counterpart to Solidity's `%` operator. This function uses a `revert`
103      * opcode (which leaves remaining gas untouched) while Solidity uses an
104      * invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      * - The divisor cannot be zero.
108      */
109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b != 0, "SafeMath: modulo by zero");
111         return a % b;
112     }
113 }
114 
115 // File: contracts/StakingRewards.sol
116 
117 //pragma solidity ^0.8.11;
118 
119 //import "./ERC20Detailed.sol";
120 //import "./SafeERC20.sol";
121 //import "./ReentrancyGuard.sol";
122 
123 // Inheritance
124 //import "./IStakingRewards.sol";
125 //import "./RewardsDistributionRecipient.sol";
126 //import "./Pausable.sol";
127 
128 
129 // https://docs.synthetix.io/contracts/source/interfaces/istakingrewards
130 interface IStakingRewards {
131     // Views
132 
133     function balanceOf(address account) external view returns (uint256);
134 
135     function earned(address account) external view returns (uint256);
136 
137     function getRewardForDuration() external view returns (uint256);
138 
139     function lastTimeRewardApplicable() external view returns (uint256);
140 
141     function rewardPerToken() external view returns (uint256);
142 
143     //function rewardsDistribution() external view returns (address);
144 
145     //function rewardsToken() external view returns (address);
146 
147     function totalSupply() external view returns (uint256);
148 
149     // Mutative
150 
151     function exit() external;
152 
153     function getReward() external;
154 
155     function stake(uint256 amount) external;
156 
157     function withdraw(uint256 amount) external;
158 }
159 
160 
161 
162 /**
163  * @dev Collection of functions related to the address type,
164  */
165 library Address {
166     /**
167      * @dev Returns true if `account` is a contract.
168      *
169      * This test is non-exhaustive, and there may be false-negatives: during the
170      * execution of a contract's constructor, its address will be reported as
171      * not containing a contract.
172      *
173      * > It is unsafe to assume that an address for which this function returns
174      * false is an externally-owned account (EOA) and not a contract.
175      */
176     function isContract(address account) internal view returns (bool) {
177         // This method relies in extcodesize, which returns 0 for contracts in
178         // construction, since the code is only stored at the end of the
179         // constructor execution.
180 
181         uint256 size;
182         // solhint-disable-next-line no-inline-assembly
183         assembly { size := extcodesize(account) }
184         return size > 0;
185     }
186 }
187 
188 /**
189  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
190  * the optional functions; to access them see `ERC20Detailed`.
191  */
192 interface IERC20 {
193     /**
194      * @dev Returns the amount of tokens in existence.
195      */
196     function totalSupply() external view returns (uint256);
197 
198     /**
199      * @dev Returns the amount of tokens owned by `account`.
200      */
201     function balanceOf(address account) external view returns (uint256);
202 
203     /**
204      * @dev Moves `amount` tokens from the caller's account to `recipient`.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * Emits a `Transfer` event.
209      */
210     function transfer(address recipient, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Returns the remaining number of tokens that `spender` will be
214      * allowed to spend on behalf of `owner` through `transferFrom`. This is
215      * zero by default.
216      *
217      * This value changes when `approve` or `transferFrom` are called.
218      */
219     function allowance(address owner, address spender) external view returns (uint256);
220 
221     /**
222      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * > Beware that changing an allowance with this method brings the risk
227      * that someone may use both the old and the new allowance by unfortunate
228      * transaction ordering. One possible solution to mitigate this race
229      * condition is to first reduce the spender's allowance to 0 and set the
230      * desired value afterwards:
231      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232      *
233      * Emits an `Approval` event.
234      */
235     function approve(address spender, uint256 amount) external returns (bool);
236 
237     /**
238      * @dev Moves `amount` tokens from `sender` to `recipient` using the
239      * allowance mechanism. `amount` is then deducted from the caller's
240      * allowance.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * Emits a `Transfer` event.
245      */
246     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
247 
248     /**
249      * @dev Emitted when `value` tokens are moved from one account (`from`) to
250      * another (`to`).
251      *
252      * Note that `value` may be zero.
253      */
254     event Transfer(address indexed from, address indexed to, uint256 value);
255 
256     /**
257      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
258      * a call to `approve`. `value` is the new allowance.
259      */
260     event Approval(address indexed owner, address indexed spender, uint256 value);
261 }
262 
263 
264 /**
265  * @dev Optional functions from the ERC20 standard.
266  */
267 abstract contract ERC20Detailed is IERC20  {
268     string private _name;
269     string private _symbol;
270     uint8 private _decimals;
271 
272     /**
273      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
274      * these values are immutable: they can only be set once during
275      * construction.
276      */
277     constructor (string memory name_, string memory symbol_, uint8 decimals_)  {
278         _name = name_;
279         _symbol = symbol_;
280         _decimals = decimals_;
281     }
282 
283     /**
284      * @dev Returns the name of the token.
285      */
286     function name() public view returns (string memory) {
287         return _name;
288     }
289 
290     /**
291      * @dev Returns the symbol of the token, usually a shorter version of the
292      * name.
293      */
294     function symbol() public view returns (string memory) {
295         return _symbol;
296     }
297 
298     /**
299      * @dev Returns the number of decimals used to get its user representation.
300      * For example, if `decimals` equals `2`, a balance of `505` tokens should
301      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
302      *
303      * Tokens usually opt for a value of 18, imitating the relationship between
304      * Ether and Wei.
305      *
306      * > Note that this information is only used for _display_ purposes: it in
307      * no way affects any of the arithmetic of the contract, including
308      * `IERC20.balanceOf` and `IERC20.transfer`.
309      */
310     function decimals() public view returns (uint8) {
311         return _decimals;
312     }
313 }
314 
315 /**
316  * @title SafeERC20
317  * @dev Wrappers around ERC20 operations that throw on failure (when the token
318  * contract returns false). Tokens that return no value (and instead revert or
319  * throw on failure) are also supported, non-reverting calls are assumed to be
320  * successful.
321  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
322  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
323  */
324 library SafeERC20 {
325     using SafeMath for uint256;
326     using Address for address;
327 
328     function safeTransfer(IERC20 token, address to, uint256 value) internal {
329         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
330     }
331 
332     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
333         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
334     }
335 
336     function safeApprove(IERC20 token, address spender, uint256 value) internal {
337         // safeApprove should only be called when setting an initial allowance,
338         // or when resetting it to zero. To increase and decrease it, use
339         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
340         // solhint-disable-next-line max-line-length
341         require((value == 0) || (token.allowance(address(this), spender) == 0),
342             "SafeERC20: approve from non-zero to non-zero allowance"
343         );
344         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
345     }
346 
347     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
348         uint256 newAllowance = token.allowance(address(this), spender).add(value);
349         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
350     }
351 
352     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
353         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
354         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
355     }
356 
357     /**
358      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
359      * on the return value: the return value is optional (but if data is returned, it must not be false).
360      * @param token The token targeted by the call.
361      * @param data The call data (encoded using abi.encode or one of its variants).
362      */
363     function callOptionalReturn(IERC20 token, bytes memory data) private {
364         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
365         // we're implementing it ourselves.
366 
367         // A Solidity high level call has three parts:
368         //  1. The target address is checked to verify it contains contract code
369         //  2. The call itself is made, and success asserted
370         //  3. The return value is decoded, which in turn checks the size of the returned data.
371         // solhint-disable-next-line max-line-length
372         require(address(token).isContract(), "SafeERC20: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = address(token).call(data);
376         require(success, "SafeERC20: low-level call failed");
377 
378         if (returndata.length > 0) { // Return data is optional
379             // solhint-disable-next-line max-line-length
380             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
381         }
382     }
383 }
384 
385 
386 // https://docs.synthetix.io/contracts/source/contracts/owned
387 contract Owned {
388     address public owner;
389     address public nominatedOwner;
390 
391     constructor(address _owner) public {
392         require(_owner != address(0), "Owner address cannot be 0");
393         owner = _owner;
394         emit OwnerChanged(address(0), _owner);
395     }
396 
397     function nominateNewOwner(address _owner) external onlyOwner {
398         nominatedOwner = _owner;
399         emit OwnerNominated(_owner);
400     }
401 
402     function acceptOwnership() external {
403         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
404         emit OwnerChanged(owner, nominatedOwner);
405         owner = nominatedOwner;
406         nominatedOwner = address(0);
407     }
408 
409     modifier onlyOwner {
410         _onlyOwner();
411         _;
412     }
413 
414     function _onlyOwner() private view {
415         require(msg.sender == owner, "Only the contract owner may perform this action");
416     }
417 
418     event OwnerNominated(address newOwner);
419     event OwnerChanged(address oldOwner, address newOwner);
420 }
421 // https://docs.synthetix.io/contracts/source/contracts/pausable
422 abstract contract Pausable is Owned {
423     uint public lastPauseTime;
424     bool public paused;
425 
426     constructor() internal {
427         // This contract is abstract, and thus cannot be instantiated directly
428         require(owner != address(0), "Owner must be set");
429         // Paused will be false, and lastPauseTime will be 0 upon initialisation
430     }
431 
432     /**
433      * @notice Change the paused state of the contract
434      * @dev Only the contract owner may call this.
435      */
436     function setPaused(bool _paused) external onlyOwner {
437         // Ensure we're actually changing the state before we do anything
438         if (_paused == paused) {
439             return;
440         }
441 
442         // Set our paused state.
443         paused = _paused;
444 
445         // If applicable, set the last pause time.
446         if (paused) {
447             lastPauseTime = block.timestamp;
448         }
449 
450         // Let everyone know that our pause state has changed.
451         emit PauseChanged(paused);
452     }
453 
454     event PauseChanged(bool isPaused);
455 
456     modifier notPaused {
457         require(!paused, "This action cannot be performed while the contract is paused");
458         _;
459     }
460 }
461 
462 // https://docs.synthetix.io/contracts/source/contracts/rewardsdistributionrecipient
463 abstract contract RewardsDistributionRecipient is Owned {
464     address public rewardsDistribution;
465 
466     function notifyRewardAmount(uint256 reward) virtual external;
467 
468     modifier onlyRewardsDistribution() {
469         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
470         _;
471     }
472 
473     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
474         rewardsDistribution = _rewardsDistribution;
475     }
476 }
477 
478 /**
479  * @dev Contract module that helps prevent reentrant calls to a function.
480  *
481  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
482  * available, which can be aplied to functions to make sure there are no nested
483  * (reentrant) calls to them.
484  *
485  * Note that because there is a single `nonReentrant` guard, functions marked as
486  * `nonReentrant` may not call one another. This can be worked around by making
487  * those functions `private`, and then adding `external` `nonReentrant` entry
488  * points to them.
489  */
490 abstract contract ReentrancyGuard {
491     /// @dev counter to allow mutex lock with only one SSTORE operation
492     uint256 private _guardCounter;
493 
494     constructor () internal {
495         // The counter starts at one to prevent changing it from zero to a non-zero
496         // value, which is a more expensive operation.
497         _guardCounter = 1;
498     }
499 
500     /**
501      * @dev Prevents a contract from calling itself, directly or indirectly.
502      * Calling a `nonReentrant` function from another `nonReentrant`
503      * function is not supported. It is possible to prevent this from happening
504      * by making the `nonReentrant` function external, and make it call a
505      * `private` function that does the actual work.
506      */
507     modifier nonReentrant() {
508         _guardCounter += 1;
509         uint256 localCounter = _guardCounter;
510         _;
511         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
512     }
513 }
514 
515 
516 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
517 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, Pausable {
518     using SafeMath for uint256;
519     using SafeERC20 for IERC20;
520 
521     /* ========== STATE VARIABLES ========== */
522 
523     IERC20 public rewardsToken;
524     IERC20 public stakingToken;
525     uint256 public periodFinish = 0;
526     uint256 public rewardRate = 0;
527     uint256 public rewardsDuration = 7 days;
528     uint256 public lastUpdateTime;
529     uint256 public rewardPerTokenStored;
530 
531     mapping(address => uint256) public userRewardPerTokenPaid;
532     mapping(address => uint256) public rewards;
533 
534     uint256 private _totalSupply;
535     mapping(address => uint256) private _balances;
536 
537     uint256 private _guardCounter;
538 
539     /* ========== CONSTRUCTOR ========== */
540 
541     constructor(
542         address _owner,
543         address _rewardsDistribution,
544         address _rewardsToken,
545         address _stakingToken
546     ) public Owned(_owner) {
547         rewardsToken = IERC20(_rewardsToken);
548         stakingToken = IERC20(_stakingToken);
549         rewardsDistribution = _rewardsDistribution;
550         _guardCounter = 1;
551     }
552 
553     /* ========== VIEWS ========== */
554 
555     function totalSupply() external view returns (uint256) {
556         return _totalSupply;
557     }
558 
559     function balanceOf(address account) external view returns (uint256) {
560         return _balances[account];
561     }
562 
563     function lastTimeRewardApplicable() public view returns (uint256) {
564         return block.timestamp < periodFinish ? block.timestamp : periodFinish;
565     }
566 
567     function rewardPerToken() public view returns (uint256) {
568         if (_totalSupply == 0) {
569             return rewardPerTokenStored;
570         }
571         return
572             rewardPerTokenStored.add(
573                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
574             );
575     }
576 
577     function earned(address account) public view returns (uint256) {
578         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
579     }
580 
581     function getRewardForDuration() external view returns (uint256) {
582         return rewardRate.mul(rewardsDuration);
583     }
584 
585     /* ========== MUTATIVE FUNCTIONS ========== */
586 
587     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
588         require(amount > 0, "Cannot stake 0");
589         _totalSupply = _totalSupply.add(amount);
590         _balances[msg.sender] = _balances[msg.sender].add(amount);
591         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
592         emit Staked(msg.sender, amount);
593     }
594 
595     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
596         require(amount > 0, "Cannot withdraw 0");
597         _totalSupply = _totalSupply.sub(amount);
598         _balances[msg.sender] = _balances[msg.sender].sub(amount);
599         stakingToken.safeTransfer(msg.sender, amount);
600         emit Withdrawn(msg.sender, amount);
601     }
602 
603     function getReward() public nonReentrant updateReward(msg.sender) {
604         uint256 reward = rewards[msg.sender];
605         if (reward > 0) {
606             rewards[msg.sender] = 0;
607             rewardsToken.safeTransfer(msg.sender, reward);
608             emit RewardPaid(msg.sender, reward);
609         }
610     }
611 
612     function exit() external {
613         withdraw(_balances[msg.sender]);
614         getReward();
615     }
616 
617     /* ========== RESTRICTED FUNCTIONS ========== */
618 
619     function notifyRewardAmount(uint256 reward) override external onlyRewardsDistribution updateReward(address(0)) {
620         if (block.timestamp >= periodFinish) {
621             rewardRate = reward.div(rewardsDuration);
622         } else {
623             uint256 remaining = periodFinish.sub(block.timestamp);
624             uint256 leftover = remaining.mul(rewardRate);
625             rewardRate = reward.add(leftover).div(rewardsDuration);
626         }
627 
628         // Ensure the provided reward amount is not more than the balance in the contract.
629         // This keeps the reward rate in the right range, preventing overflows due to
630         // very high values of rewardRate in the earned and rewardsPerToken functions;
631         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
632         uint balance = rewardsToken.balanceOf(address(this));
633         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
634 
635         lastUpdateTime = block.timestamp;
636         periodFinish = block.timestamp.add(rewardsDuration);
637         emit RewardAdded(reward);
638     }
639 
640     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
641     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
642         require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");
643         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
644         emit Recovered(tokenAddress, tokenAmount);
645     }
646 
647     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
648         require(
649             block.timestamp > periodFinish,
650             "Previous rewards period must be complete before changing the duration for the new period"
651         );
652         rewardsDuration = _rewardsDuration;
653         emit RewardsDurationUpdated(rewardsDuration);
654     }
655 
656     /* ========== MODIFIERS ========== */
657 
658     modifier updateReward(address account) {
659         rewardPerTokenStored = rewardPerToken();
660         lastUpdateTime = lastTimeRewardApplicable();
661         if (account != address(0)) {
662             rewards[account] = earned(account);
663             userRewardPerTokenPaid[account] = rewardPerTokenStored;
664         }
665         _;
666     }
667 
668     modifier nonReentrant() {
669         _guardCounter += 1;
670         uint256 localCounter = _guardCounter;
671         _;
672         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
673     }
674 
675     /* ========== EVENTS ========== */
676 
677     event RewardAdded(uint256 reward);
678     event Staked(address indexed user, uint256 amount);
679     event Withdrawn(address indexed user, uint256 amount);
680     event RewardPaid(address indexed user, uint256 reward);
681     event RewardsDurationUpdated(uint256 newDuration);
682     event Recovered(address token, uint256 amount);
683 }