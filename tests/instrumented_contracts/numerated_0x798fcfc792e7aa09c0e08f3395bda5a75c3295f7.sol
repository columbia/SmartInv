1 // File: contracts/Owned.sol
2 
3 pragma solidity ^0.5.16;
4 
5 // https://docs.synthetix.io/contracts/source/contracts/owned
6 contract Owned {
7     address public owner;
8     address public nominatedOwner;
9 
10     constructor(address _owner) public {
11         require(_owner != address(0), "Owner address cannot be 0");
12         owner = _owner;
13         emit OwnerChanged(address(0), _owner);
14     }
15 
16     function nominateNewOwner(address _owner) external onlyOwner {
17         nominatedOwner = _owner;
18         emit OwnerNominated(_owner);
19     }
20 
21     function acceptOwnership() external {
22         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
23         emit OwnerChanged(owner, nominatedOwner);
24         owner = nominatedOwner;
25         nominatedOwner = address(0);
26     }
27 
28     modifier onlyOwner {
29         _onlyOwner();
30         _;
31     }
32 
33     function _onlyOwner() private view {
34         require(msg.sender == owner, "Only the contract owner may perform this action");
35     }
36 
37     event OwnerNominated(address newOwner);
38     event OwnerChanged(address oldOwner, address newOwner);
39 }
40 // File: contracts/Pausable.sol
41 
42 
43 // Inheritance
44 
45 
46 // https://docs.synthetix.io/contracts/source/contracts/pausable
47 contract Pausable is Owned {
48     uint public lastPauseTime;
49     bool public paused;
50 
51     constructor() internal {
52         // This contract is abstract, and thus cannot be instantiated directly
53         require(owner != address(0), "Owner must be set");
54         // Paused will be false, and lastPauseTime will be 0 upon initialisation
55     }
56 
57     /**
58      * @notice Change the paused state of the contract
59      * @dev Only the contract owner may call this.
60      */
61     function setPaused(bool _paused) external onlyOwner {
62         // Ensure we're actually changing the state before we do anything
63         if (_paused == paused) {
64             return;
65         }
66 
67         // Set our paused state.
68         paused = _paused;
69 
70         // If applicable, set the last pause time.
71         if (paused) {
72             lastPauseTime = now;
73         }
74 
75         // Let everyone know that our pause state has changed.
76         emit PauseChanged(paused);
77     }
78 
79     event PauseChanged(bool isPaused);
80 
81     modifier notPaused {
82         require(!paused, "This action cannot be performed while the contract is paused");
83         _;
84     }
85 }
86 // File: contracts/RewardsDistributionRecipient.sol
87 
88 
89 // Inheritance
90 
91 
92 // https://docs.synthetix.io/contracts/source/contracts/rewardsdistributionrecipient
93 contract RewardsDistributionRecipient is Owned {
94     address public rewardsDistribution;
95 
96     function notifyRewardAmount(uint256 reward) external;
97 
98     modifier onlyRewardsDistribution() {
99         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
100         _;
101     }
102 
103     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
104         rewardsDistribution = _rewardsDistribution;
105     }
106 }
107 // File: contracts/interfaces/IStakingRewards.sol
108 
109 
110 // https://docs.synthetix.io/contracts/source/interfaces/istakingrewards
111 interface IStakingRewards {
112     // Views
113 
114     function balanceOf(address account) external view returns (uint256);
115 
116     function earned(address account) external view returns (uint256);
117 
118     function getRewardForDuration() external view returns (uint256);
119 
120     function lastTimeRewardApplicable() external view returns (uint256);
121 
122     function rewardPerToken() external view returns (uint256);
123 
124     function rewardsDistribution() external view returns (address);
125 
126     function rewardsToken() external view returns (address);
127 
128     function totalSupply() external view returns (uint256);
129 
130     // Mutative
131 
132     function exit() external;
133 
134     function getReward() external;
135 
136     function stake(uint256 amount) external;
137 
138     function withdraw(uint256 amount) external;
139 }
140 // File: contracts/utils/ReentrancyGuard.sol
141 
142 
143 /**
144  * @dev Contract module that helps prevent reentrant calls to a function.
145  *
146  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
147  * available, which can be aplied to functions to make sure there are no nested
148  * (reentrant) calls to them.
149  *
150  * Note that because there is a single `nonReentrant` guard, functions marked as
151  * `nonReentrant` may not call one another. This can be worked around by making
152  * those functions `private`, and then adding `external` `nonReentrant` entry
153  * points to them.
154  */
155 contract ReentrancyGuard {
156     /// @dev counter to allow mutex lock with only one SSTORE operation
157     uint256 private _guardCounter;
158 
159     constructor () internal {
160         // The counter starts at one to prevent changing it from zero to a non-zero
161         // value, which is a more expensive operation.
162         _guardCounter = 1;
163     }
164 
165     /**
166      * @dev Prevents a contract from calling itself, directly or indirectly.
167      * Calling a `nonReentrant` function from another `nonReentrant`
168      * function is not supported. It is possible to prevent this from happening
169      * by making the `nonReentrant` function external, and make it call a
170      * `private` function that does the actual work.
171      */
172     modifier nonReentrant() {
173         _guardCounter += 1;
174         uint256 localCounter = _guardCounter;
175         _;
176         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
177     }
178 }
179 
180 // File: contracts/utils/Address.sol
181 
182 
183 /**
184  * @dev Collection of functions related to the address type,
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * This test is non-exhaustive, and there may be false-negatives: during the
191      * execution of a contract's constructor, its address will be reported as
192      * not containing a contract.
193      *
194      * > It is unsafe to assume that an address for which this function returns
195      * false is an externally-owned account (EOA) and not a contract.
196      */
197     function isContract(address account) internal view returns (bool) {
198         // This method relies in extcodesize, which returns 0 for contracts in
199         // construction, since the code is only stored at the end of the
200         // constructor execution.
201 
202         uint256 size;
203         // solhint-disable-next-line no-inline-assembly
204         assembly { size := extcodesize(account) }
205         return size > 0;
206     }
207 }
208 
209 // File: contracts/token/ERC20/IERC20.sol
210 
211 
212 /**
213  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
214  * the optional functions; to access them see `ERC20Detailed`.
215  */
216 interface IERC20 {
217     /**
218      * @dev Returns the amount of tokens in existence.
219      */
220     function totalSupply() external view returns (uint256);
221 
222     /**
223      * @dev Returns the amount of tokens owned by `account`.
224      */
225     function balanceOf(address account) external view returns (uint256);
226 
227     /**
228      * @dev Moves `amount` tokens from the caller's account to `recipient`.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * Emits a `Transfer` event.
233      */
234     function transfer(address recipient, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Returns the remaining number of tokens that `spender` will be
238      * allowed to spend on behalf of `owner` through `transferFrom`. This is
239      * zero by default.
240      *
241      * This value changes when `approve` or `transferFrom` are called.
242      */
243     function allowance(address owner, address spender) external view returns (uint256);
244 
245     /**
246      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * > Beware that changing an allowance with this method brings the risk
251      * that someone may use both the old and the new allowance by unfortunate
252      * transaction ordering. One possible solution to mitigate this race
253      * condition is to first reduce the spender's allowance to 0 and set the
254      * desired value afterwards:
255      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256      *
257      * Emits an `Approval` event.
258      */
259     function approve(address spender, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Moves `amount` tokens from `sender` to `recipient` using the
263      * allowance mechanism. `amount` is then deducted from the caller's
264      * allowance.
265      *
266      * Returns a boolean value indicating whether the operation succeeded.
267      *
268      * Emits a `Transfer` event.
269      */
270     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Emitted when `value` tokens are moved from one account (`from`) to
274      * another (`to`).
275      *
276      * Note that `value` may be zero.
277      */
278     event Transfer(address indexed from, address indexed to, uint256 value);
279 
280     /**
281      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
282      * a call to `approve`. `value` is the new allowance.
283      */
284     event Approval(address indexed owner, address indexed spender, uint256 value);
285 }
286 
287 // File: contracts/token/ERC20/ERC20Detailed.sol
288 
289 
290 
291 /**
292  * @dev Optional functions from the ERC20 standard.
293  */
294 contract ERC20Detailed is IERC20 {
295     string private _name;
296     string private _symbol;
297     uint8 private _decimals;
298 
299     /**
300      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
301      * these values are immutable: they can only be set once during
302      * construction.
303      */
304     constructor (string memory name, string memory symbol, uint8 decimals) public {
305         _name = name;
306         _symbol = symbol;
307         _decimals = decimals;
308     }
309 
310     /**
311      * @dev Returns the name of the token.
312      */
313     function name() public view returns (string memory) {
314         return _name;
315     }
316 
317     /**
318      * @dev Returns the symbol of the token, usually a shorter version of the
319      * name.
320      */
321     function symbol() public view returns (string memory) {
322         return _symbol;
323     }
324 
325     /**
326      * @dev Returns the number of decimals used to get its user representation.
327      * For example, if `decimals` equals `2`, a balance of `505` tokens should
328      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
329      *
330      * Tokens usually opt for a value of 18, imitating the relationship between
331      * Ether and Wei.
332      *
333      * > Note that this information is only used for _display_ purposes: it in
334      * no way affects any of the arithmetic of the contract, including
335      * `IERC20.balanceOf` and `IERC20.transfer`.
336      */
337     function decimals() public view returns (uint8) {
338         return _decimals;
339     }
340 }
341 
342 // File: contracts/math/SafeMath.sol
343 
344 
345 /**
346  * @dev Wrappers over Solidity's arithmetic operations with added overflow
347  * checks.
348  *
349  * Arithmetic operations in Solidity wrap on overflow. This can easily result
350  * in bugs, because programmers usually assume that an overflow raises an
351  * error, which is the standard behavior in high level programming languages.
352  * `SafeMath` restores this intuition by reverting the transaction when an
353  * operation overflows.
354  *
355  * Using this library instead of the unchecked operations eliminates an entire
356  * class of bugs, so it's recommended to use it always.
357  */
358 library SafeMath {
359     /**
360      * @dev Returns the addition of two unsigned integers, reverting on
361      * overflow.
362      *
363      * Counterpart to Solidity's `+` operator.
364      *
365      * Requirements:
366      * - Addition cannot overflow.
367      */
368     function add(uint256 a, uint256 b) internal pure returns (uint256) {
369         uint256 c = a + b;
370         require(c >= a, "SafeMath: addition overflow");
371 
372         return c;
373     }
374 
375     /**
376      * @dev Returns the subtraction of two unsigned integers, reverting on
377      * overflow (when the result is negative).
378      *
379      * Counterpart to Solidity's `-` operator.
380      *
381      * Requirements:
382      * - Subtraction cannot overflow.
383      */
384     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
385         require(b <= a, "SafeMath: subtraction overflow");
386         uint256 c = a - b;
387 
388         return c;
389     }
390 
391     /**
392      * @dev Returns the multiplication of two unsigned integers, reverting on
393      * overflow.
394      *
395      * Counterpart to Solidity's `*` operator.
396      *
397      * Requirements:
398      * - Multiplication cannot overflow.
399      */
400     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
401         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
402         // benefit is lost if 'b' is also tested.
403         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
404         if (a == 0) {
405             return 0;
406         }
407 
408         uint256 c = a * b;
409         require(c / a == b, "SafeMath: multiplication overflow");
410 
411         return c;
412     }
413 
414     /**
415      * @dev Returns the integer division of two unsigned integers. Reverts on
416      * division by zero. The result is rounded towards zero.
417      *
418      * Counterpart to Solidity's `/` operator. Note: this function uses a
419      * `revert` opcode (which leaves remaining gas untouched) while Solidity
420      * uses an invalid opcode to revert (consuming all remaining gas).
421      *
422      * Requirements:
423      * - The divisor cannot be zero.
424      */
425     function div(uint256 a, uint256 b) internal pure returns (uint256) {
426         // Solidity only automatically asserts when dividing by 0
427         require(b > 0, "SafeMath: division by zero");
428         uint256 c = a / b;
429         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
430 
431         return c;
432     }
433 
434     /**
435      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
436      * Reverts when dividing by zero.
437      *
438      * Counterpart to Solidity's `%` operator. This function uses a `revert`
439      * opcode (which leaves remaining gas untouched) while Solidity uses an
440      * invalid opcode to revert (consuming all remaining gas).
441      *
442      * Requirements:
443      * - The divisor cannot be zero.
444      */
445     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
446         require(b != 0, "SafeMath: modulo by zero");
447         return a % b;
448     }
449 }
450 // File: contracts/token/ERC20/SafeERC20.sol
451 
452 
453 
454 
455 
456 /**
457  * @title SafeERC20
458  * @dev Wrappers around ERC20 operations that throw on failure (when the token
459  * contract returns false). Tokens that return no value (and instead revert or
460  * throw on failure) are also supported, non-reverting calls are assumed to be
461  * successful.
462  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
463  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
464  */
465 library SafeERC20 {
466     using SafeMath for uint256;
467     using Address for address;
468 
469     function safeTransfer(IERC20 token, address to, uint256 value) internal {
470         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
471     }
472 
473     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
474         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
475     }
476 
477     function safeApprove(IERC20 token, address spender, uint256 value) internal {
478         // safeApprove should only be called when setting an initial allowance,
479         // or when resetting it to zero. To increase and decrease it, use
480         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
481         // solhint-disable-next-line max-line-length
482         require((value == 0) || (token.allowance(address(this), spender) == 0),
483             "SafeERC20: approve from non-zero to non-zero allowance"
484         );
485         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
486     }
487 
488     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
489         uint256 newAllowance = token.allowance(address(this), spender).add(value);
490         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
491     }
492 
493     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
494         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
495         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
496     }
497 
498     /**
499      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
500      * on the return value: the return value is optional (but if data is returned, it must not be false).
501      * @param token The token targeted by the call.
502      * @param data The call data (encoded using abi.encode or one of its variants).
503      */
504     function callOptionalReturn(IERC20 token, bytes memory data) private {
505         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
506         // we're implementing it ourselves.
507 
508         // A Solidity high level call has three parts:
509         //  1. The target address is checked to verify it contains contract code
510         //  2. The call itself is made, and success asserted
511         //  3. The return value is decoded, which in turn checks the size of the returned data.
512         // solhint-disable-next-line max-line-length
513         require(address(token).isContract(), "SafeERC20: call to non-contract");
514 
515         // solhint-disable-next-line avoid-low-level-calls
516         (bool success, bytes memory returndata) = address(token).call(data);
517         require(success, "SafeERC20: low-level call failed");
518 
519         if (returndata.length > 0) { // Return data is optional
520             // solhint-disable-next-line max-line-length
521             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
522         }
523     }
524 }
525 
526 // File: contracts/StakingVault.sol
527 
528 
529 
530 
531 
532 
533 // Inheritance
534 
535 
536 
537 
538 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
539 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
540     using SafeMath for uint256;
541     using SafeERC20 for IERC20;
542 
543     /* ========== STATE VARIABLES ========== */
544 
545     IERC20 public rewardsToken;
546     IERC20 public stakingToken;
547     uint256 public periodFinish = 0;
548     uint256 public rewardRate = 0;
549     uint256 public rewardsDuration = 7 days;
550     uint256 public lastUpdateTime;
551     uint256 public rewardPerTokenStored;
552 
553     mapping(address => uint256) public userRewardPerTokenPaid;
554     mapping(address => uint256) public rewards;
555 
556     uint256 private _totalSupply;
557     mapping(address => uint256) private _balances;
558 
559     /* ========== CONSTRUCTOR ========== */
560 
561     constructor(
562         address _owner,
563         address _rewardsDistribution,
564         address _rewardsToken,
565         address _stakingToken
566     ) public Owned(_owner) {
567         rewardsToken = IERC20(_rewardsToken);
568         stakingToken = IERC20(_stakingToken);
569         rewardsDistribution = _rewardsDistribution;
570     }
571 
572     /* ========== VIEWS ========== */
573 
574     function totalSupply() external view returns (uint256) {
575         return _totalSupply;
576     }
577 
578     function balanceOf(address account) external view returns (uint256) {
579         return _balances[account];
580     }
581 
582     function lastTimeRewardApplicable() public view returns (uint256) {
583         return block.timestamp < periodFinish ? block.timestamp : periodFinish;
584     }
585 
586     function rewardPerToken() public view returns (uint256) {
587         if (_totalSupply == 0) {
588             return rewardPerTokenStored;
589         }
590         return
591             rewardPerTokenStored.add(
592                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
593             );
594     }
595 
596     function earned(address account) public view returns (uint256) {
597         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
598     }
599 
600     function getRewardForDuration() external view returns (uint256) {
601         return rewardRate.mul(rewardsDuration);
602     }
603 
604     /* ========== MUTATIVE FUNCTIONS ========== */
605 
606     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
607         require(amount > 0, "Cannot stake 0");
608         _totalSupply = _totalSupply.add(amount);
609         _balances[msg.sender] = _balances[msg.sender].add(amount);
610         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
611         emit Staked(msg.sender, amount);
612     }
613 
614     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
615         require(amount > 0, "Cannot withdraw 0");
616         _totalSupply = _totalSupply.sub(amount);
617         _balances[msg.sender] = _balances[msg.sender].sub(amount);
618         stakingToken.safeTransfer(msg.sender, amount);
619         emit Withdrawn(msg.sender, amount);
620     }
621 
622     function getReward() public nonReentrant updateReward(msg.sender) {
623         uint256 reward = rewards[msg.sender];
624         if (reward > 0) {
625             rewards[msg.sender] = 0;
626             rewardsToken.safeTransfer(msg.sender, reward);
627             emit RewardPaid(msg.sender, reward);
628         }
629     }
630 
631     function exit() external {
632         withdraw(_balances[msg.sender]);
633         getReward();
634     }
635 
636     /* ========== RESTRICTED FUNCTIONS ========== */
637 
638     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
639         if (block.timestamp >= periodFinish) {
640             rewardRate = reward.div(rewardsDuration);
641         } else {
642             uint256 remaining = periodFinish.sub(block.timestamp);
643             uint256 leftover = remaining.mul(rewardRate);
644             rewardRate = reward.add(leftover).div(rewardsDuration);
645         }
646 
647         // Ensure the provided reward amount is not more than the balance in the contract.
648         // This keeps the reward rate in the right range, preventing overflows due to
649         // very high values of rewardRate in the earned and rewardsPerToken functions;
650         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
651         uint balance = rewardsToken.balanceOf(address(this));
652         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
653 
654         lastUpdateTime = block.timestamp;
655         periodFinish = block.timestamp.add(rewardsDuration);
656         emit RewardAdded(reward);
657     }
658 
659     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
660     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
661         require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");
662         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
663         emit Recovered(tokenAddress, tokenAmount);
664     }
665 
666     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
667         require(
668             block.timestamp > periodFinish,
669             "Previous rewards period must be complete before changing the duration for the new period"
670         );
671         rewardsDuration = _rewardsDuration;
672         emit RewardsDurationUpdated(rewardsDuration);
673     }
674 
675     /* ========== MODIFIERS ========== */
676 
677     modifier updateReward(address account) {
678         rewardPerTokenStored = rewardPerToken();
679         lastUpdateTime = lastTimeRewardApplicable();
680         if (account != address(0)) {
681             rewards[account] = earned(account);
682             userRewardPerTokenPaid[account] = rewardPerTokenStored;
683         }
684         _;
685     }
686 
687     /* ========== EVENTS ========== */
688 
689     event RewardAdded(uint256 reward);
690     event Staked(address indexed user, uint256 amount);
691     event Withdrawn(address indexed user, uint256 amount);
692     event RewardPaid(address indexed user, uint256 reward);
693     event RewardsDurationUpdated(uint256 newDuration);
694     event Recovered(address token, uint256 amount);
695 }