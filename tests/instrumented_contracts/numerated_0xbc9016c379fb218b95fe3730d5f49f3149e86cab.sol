1 // File: contracts/SafeMath.sol
2 
3 pragma solidity ^0.8.11;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: contracts/StakingRewards.sol
112 
113 //pragma solidity ^0.8.11;
114 
115 //import "./ERC20Detailed.sol";
116 //import "./SafeERC20.sol";
117 //import "./ReentrancyGuard.sol";
118 
119 // Inheritance
120 //import "./IStakingRewards.sol";
121 //import "./RewardsDistributionRecipient.sol";
122 //import "./Pausable.sol";
123 
124 
125 // https://docs.synthetix.io/contracts/source/interfaces/istakingrewards
126 interface IStakingRewards {
127     // Views
128 
129     function balanceOf(address account) external view returns (uint256);
130 
131     function earned(address account) external view returns (uint256);
132 
133     function getRewardForDuration() external view returns (uint256);
134 
135     function lastTimeRewardApplicable() external view returns (uint256);
136 
137     function rewardPerToken() external view returns (uint256);
138 
139     //function rewardsDistribution() external view returns (address);
140 
141     //function rewardsToken() external view returns (address);
142 
143     function totalSupply() external view returns (uint256);
144 
145     // Mutative
146 
147     function exit() external;
148 
149     function getReward() external;
150 
151     function stake(uint256 amount) external;
152 
153     function withdraw(uint256 amount) external;
154 }
155 
156 
157 
158 /**
159  * @dev Collection of functions related to the address type,
160  */
161 library Address {
162     /**
163      * @dev Returns true if `account` is a contract.
164      *
165      * This test is non-exhaustive, and there may be false-negatives: during the
166      * execution of a contract's constructor, its address will be reported as
167      * not containing a contract.
168      *
169      * > It is unsafe to assume that an address for which this function returns
170      * false is an externally-owned account (EOA) and not a contract.
171      */
172     function isContract(address account) internal view returns (bool) {
173         // This method relies in extcodesize, which returns 0 for contracts in
174         // construction, since the code is only stored at the end of the
175         // constructor execution.
176 
177         uint256 size;
178         // solhint-disable-next-line no-inline-assembly
179         assembly { size := extcodesize(account) }
180         return size > 0;
181     }
182 }
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
186  * the optional functions; to access them see `ERC20Detailed`.
187  */
188 interface IERC20 {
189     /**
190      * @dev Returns the amount of tokens in existence.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     /**
195      * @dev Returns the amount of tokens owned by `account`.
196      */
197     function balanceOf(address account) external view returns (uint256);
198 
199     /**
200      * @dev Moves `amount` tokens from the caller's account to `recipient`.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a `Transfer` event.
205      */
206     function transfer(address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Returns the remaining number of tokens that `spender` will be
210      * allowed to spend on behalf of `owner` through `transferFrom`. This is
211      * zero by default.
212      *
213      * This value changes when `approve` or `transferFrom` are called.
214      */
215     function allowance(address owner, address spender) external view returns (uint256);
216 
217     /**
218      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * > Beware that changing an allowance with this method brings the risk
223      * that someone may use both the old and the new allowance by unfortunate
224      * transaction ordering. One possible solution to mitigate this race
225      * condition is to first reduce the spender's allowance to 0 and set the
226      * desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      *
229      * Emits an `Approval` event.
230      */
231     function approve(address spender, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Moves `amount` tokens from `sender` to `recipient` using the
235      * allowance mechanism. `amount` is then deducted from the caller's
236      * allowance.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a `Transfer` event.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to `approve`. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 
260 /**
261  * @dev Optional functions from the ERC20 standard.
262  */
263 abstract contract ERC20Detailed is IERC20  {
264     string private _name;
265     string private _symbol;
266     uint8 private _decimals;
267 
268     /**
269      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
270      * these values are immutable: they can only be set once during
271      * construction.
272      */
273     constructor (string memory name_, string memory symbol_, uint8 decimals_)  {
274         _name = name_;
275         _symbol = symbol_;
276         _decimals = decimals_;
277     }
278 
279     /**
280      * @dev Returns the name of the token.
281      */
282     function name() public view returns (string memory) {
283         return _name;
284     }
285 
286     /**
287      * @dev Returns the symbol of the token, usually a shorter version of the
288      * name.
289      */
290     function symbol() public view returns (string memory) {
291         return _symbol;
292     }
293 
294     /**
295      * @dev Returns the number of decimals used to get its user representation.
296      * For example, if `decimals` equals `2`, a balance of `505` tokens should
297      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
298      *
299      * Tokens usually opt for a value of 18, imitating the relationship between
300      * Ether and Wei.
301      *
302      * > Note that this information is only used for _display_ purposes: it in
303      * no way affects any of the arithmetic of the contract, including
304      * `IERC20.balanceOf` and `IERC20.transfer`.
305      */
306     function decimals() public view returns (uint8) {
307         return _decimals;
308     }
309 }
310 
311 /**
312  * @title SafeERC20
313  * @dev Wrappers around ERC20 operations that throw on failure (when the token
314  * contract returns false). Tokens that return no value (and instead revert or
315  * throw on failure) are also supported, non-reverting calls are assumed to be
316  * successful.
317  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
318  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
319  */
320 library SafeERC20 {
321     using SafeMath for uint256;
322     using Address for address;
323 
324     function safeTransfer(IERC20 token, address to, uint256 value) internal {
325         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
326     }
327 
328     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
329         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
330     }
331 
332     function safeApprove(IERC20 token, address spender, uint256 value) internal {
333         // safeApprove should only be called when setting an initial allowance,
334         // or when resetting it to zero. To increase and decrease it, use
335         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
336         // solhint-disable-next-line max-line-length
337         require((value == 0) || (token.allowance(address(this), spender) == 0),
338             "SafeERC20: approve from non-zero to non-zero allowance"
339         );
340         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
341     }
342 
343     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
344         uint256 newAllowance = token.allowance(address(this), spender).add(value);
345         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
346     }
347 
348     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
349         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
350         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
351     }
352 
353     /**
354      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
355      * on the return value: the return value is optional (but if data is returned, it must not be false).
356      * @param token The token targeted by the call.
357      * @param data The call data (encoded using abi.encode or one of its variants).
358      */
359     function callOptionalReturn(IERC20 token, bytes memory data) private {
360         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
361         // we're implementing it ourselves.
362 
363         // A Solidity high level call has three parts:
364         //  1. The target address is checked to verify it contains contract code
365         //  2. The call itself is made, and success asserted
366         //  3. The return value is decoded, which in turn checks the size of the returned data.
367         // solhint-disable-next-line max-line-length
368         require(address(token).isContract(), "SafeERC20: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = address(token).call(data);
372         require(success, "SafeERC20: low-level call failed");
373 
374         if (returndata.length > 0) { // Return data is optional
375             // solhint-disable-next-line max-line-length
376             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
377         }
378     }
379 }
380 
381 
382 // https://docs.synthetix.io/contracts/source/contracts/owned
383 contract Owned {
384     address public owner;
385     address public nominatedOwner;
386 
387     constructor(address _owner) public {
388         require(_owner != address(0), "Owner address cannot be 0");
389         owner = _owner;
390         emit OwnerChanged(address(0), _owner);
391     }
392 
393     function nominateNewOwner(address _owner) external onlyOwner {
394         nominatedOwner = _owner;
395         emit OwnerNominated(_owner);
396     }
397 
398     function acceptOwnership() external {
399         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
400         emit OwnerChanged(owner, nominatedOwner);
401         owner = nominatedOwner;
402         nominatedOwner = address(0);
403     }
404 
405     modifier onlyOwner {
406         _onlyOwner();
407         _;
408     }
409 
410     function _onlyOwner() private view {
411         require(msg.sender == owner, "Only the contract owner may perform this action");
412     }
413 
414     event OwnerNominated(address newOwner);
415     event OwnerChanged(address oldOwner, address newOwner);
416 }
417 // https://docs.synthetix.io/contracts/source/contracts/pausable
418 abstract contract Pausable is Owned {
419     uint public lastPauseTime;
420     bool public paused;
421 
422     constructor() internal {
423         // This contract is abstract, and thus cannot be instantiated directly
424         require(owner != address(0), "Owner must be set");
425         // Paused will be false, and lastPauseTime will be 0 upon initialisation
426     }
427 
428     /**
429      * @notice Change the paused state of the contract
430      * @dev Only the contract owner may call this.
431      */
432     function setPaused(bool _paused) external onlyOwner {
433         // Ensure we're actually changing the state before we do anything
434         if (_paused == paused) {
435             return;
436         }
437 
438         // Set our paused state.
439         paused = _paused;
440 
441         // If applicable, set the last pause time.
442         if (paused) {
443             lastPauseTime = block.timestamp;
444         }
445 
446         // Let everyone know that our pause state has changed.
447         emit PauseChanged(paused);
448     }
449 
450     event PauseChanged(bool isPaused);
451 
452     modifier notPaused {
453         require(!paused, "This action cannot be performed while the contract is paused");
454         _;
455     }
456 }
457 
458 // https://docs.synthetix.io/contracts/source/contracts/rewardsdistributionrecipient
459 abstract contract RewardsDistributionRecipient is Owned {
460     address public rewardsDistribution;
461 
462     function notifyRewardAmount(uint256 reward) virtual external;
463 
464     modifier onlyRewardsDistribution() {
465         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
466         _;
467     }
468 
469     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
470         rewardsDistribution = _rewardsDistribution;
471     }
472 }
473 
474 /**
475  * @dev Contract module that helps prevent reentrant calls to a function.
476  *
477  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
478  * available, which can be aplied to functions to make sure there are no nested
479  * (reentrant) calls to them.
480  *
481  * Note that because there is a single `nonReentrant` guard, functions marked as
482  * `nonReentrant` may not call one another. This can be worked around by making
483  * those functions `private`, and then adding `external` `nonReentrant` entry
484  * points to them.
485  */
486 abstract contract ReentrancyGuard {
487     /// @dev counter to allow mutex lock with only one SSTORE operation
488     uint256 private _guardCounter;
489 
490     constructor () internal {
491         // The counter starts at one to prevent changing it from zero to a non-zero
492         // value, which is a more expensive operation.
493         _guardCounter = 1;
494     }
495 
496     /**
497      * @dev Prevents a contract from calling itself, directly or indirectly.
498      * Calling a `nonReentrant` function from another `nonReentrant`
499      * function is not supported. It is possible to prevent this from happening
500      * by making the `nonReentrant` function external, and make it call a
501      * `private` function that does the actual work.
502      */
503     modifier nonReentrant() {
504         _guardCounter += 1;
505         uint256 localCounter = _guardCounter;
506         _;
507         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
508     }
509 }
510 
511 
512 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
513 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, Pausable {
514     using SafeMath for uint256;
515     using SafeERC20 for IERC20;
516 
517     /* ========== STATE VARIABLES ========== */
518 
519     IERC20 public rewardsToken;
520     IERC20 public stakingToken;
521     uint256 public periodFinish = 0;
522     uint256 public rewardRate = 0;
523     uint256 public rewardsDuration = 7 days;
524     uint256 public lastUpdateTime;
525     uint256 public rewardPerTokenStored;
526 
527     mapping(address => uint256) public userRewardPerTokenPaid;
528     mapping(address => uint256) public rewards;
529 
530     uint256 private _totalSupply;
531     mapping(address => uint256) private _balances;
532 
533     uint256 private _guardCounter;
534 
535     /* ========== CONSTRUCTOR ========== */
536 
537     constructor(
538         address _owner,
539         address _rewardsDistribution,
540         address _rewardsToken,
541         address _stakingToken
542     ) public Owned(_owner) {
543         rewardsToken = IERC20(_rewardsToken);
544         stakingToken = IERC20(_stakingToken);
545         rewardsDistribution = _rewardsDistribution;
546         _guardCounter = 1;
547     }
548 
549     /* ========== VIEWS ========== */
550 
551     function totalSupply() external view returns (uint256) {
552         return _totalSupply;
553     }
554 
555     function balanceOf(address account) external view returns (uint256) {
556         return _balances[account];
557     }
558 
559     function lastTimeRewardApplicable() public view returns (uint256) {
560         return block.timestamp < periodFinish ? block.timestamp : periodFinish;
561     }
562 
563     function rewardPerToken() public view returns (uint256) {
564         if (_totalSupply == 0) {
565             return rewardPerTokenStored;
566         }
567         return
568             rewardPerTokenStored.add(
569                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
570             );
571     }
572 
573     function earned(address account) public view returns (uint256) {
574         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
575     }
576 
577     function getRewardForDuration() external view returns (uint256) {
578         return rewardRate.mul(rewardsDuration);
579     }
580 
581     /* ========== MUTATIVE FUNCTIONS ========== */
582 
583     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
584         require(amount > 0, "Cannot stake 0");
585         _totalSupply = _totalSupply.add(amount);
586         _balances[msg.sender] = _balances[msg.sender].add(amount);
587         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
588         emit Staked(msg.sender, amount);
589     }
590 
591     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
592         require(amount > 0, "Cannot withdraw 0");
593         _totalSupply = _totalSupply.sub(amount);
594         _balances[msg.sender] = _balances[msg.sender].sub(amount);
595         stakingToken.safeTransfer(msg.sender, amount);
596         emit Withdrawn(msg.sender, amount);
597     }
598 
599     function getReward() public nonReentrant updateReward(msg.sender) {
600         uint256 reward = rewards[msg.sender];
601         if (reward > 0) {
602             rewards[msg.sender] = 0;
603             rewardsToken.safeTransfer(msg.sender, reward);
604             emit RewardPaid(msg.sender, reward);
605         }
606     }
607 
608     function exit() external {
609         withdraw(_balances[msg.sender]);
610         getReward();
611     }
612 
613     /* ========== RESTRICTED FUNCTIONS ========== */
614 
615     function notifyRewardAmount(uint256 reward) override external onlyRewardsDistribution updateReward(address(0)) {
616         if (block.timestamp >= periodFinish) {
617             rewardRate = reward.div(rewardsDuration);
618         } else {
619             uint256 remaining = periodFinish.sub(block.timestamp);
620             uint256 leftover = remaining.mul(rewardRate);
621             rewardRate = reward.add(leftover).div(rewardsDuration);
622         }
623 
624         // Ensure the provided reward amount is not more than the balance in the contract.
625         // This keeps the reward rate in the right range, preventing overflows due to
626         // very high values of rewardRate in the earned and rewardsPerToken functions;
627         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
628         uint balance = rewardsToken.balanceOf(address(this));
629         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
630 
631         lastUpdateTime = block.timestamp;
632         periodFinish = block.timestamp.add(rewardsDuration);
633         emit RewardAdded(reward);
634     }
635 
636     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
637     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
638         require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");
639         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
640         emit Recovered(tokenAddress, tokenAmount);
641     }
642 
643     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
644         require(
645             block.timestamp > periodFinish,
646             "Previous rewards period must be complete before changing the duration for the new period"
647         );
648         rewardsDuration = _rewardsDuration;
649         emit RewardsDurationUpdated(rewardsDuration);
650     }
651 
652     /* ========== MODIFIERS ========== */
653 
654     modifier updateReward(address account) {
655         rewardPerTokenStored = rewardPerToken();
656         lastUpdateTime = lastTimeRewardApplicable();
657         if (account != address(0)) {
658             rewards[account] = earned(account);
659             userRewardPerTokenPaid[account] = rewardPerTokenStored;
660         }
661         _;
662     }
663 
664     modifier nonReentrant() {
665         _guardCounter += 1;
666         uint256 localCounter = _guardCounter;
667         _;
668         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
669     }
670 
671     /* ========== EVENTS ========== */
672 
673     event RewardAdded(uint256 reward);
674     event Staked(address indexed user, uint256 amount);
675     event Withdrawn(address indexed user, uint256 amount);
676     event RewardPaid(address indexed user, uint256 reward);
677     event RewardsDurationUpdated(uint256 newDuration);
678     event Recovered(address token, uint256 amount);
679 }