1 // File: contracts/Owned.sol
2 
3 pragma solidity ^0.5.16;
4 
5 contract Owned {
6     address public owner;
7     address public nominatedOwner;
8 
9     constructor(address _owner) public {
10         require(_owner != address(0), "Owner address cannot be 0");
11         owner = _owner;
12         emit OwnerChanged(address(0), _owner);
13     }
14 
15     function nominateNewOwner(address _owner) external onlyOwner {
16         nominatedOwner = _owner;
17         emit OwnerNominated(_owner);
18     }
19 
20     function acceptOwnership() external {
21         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
22         emit OwnerChanged(owner, nominatedOwner);
23         owner = nominatedOwner;
24         nominatedOwner = address(0);
25     }
26 
27     modifier onlyOwner {
28         _onlyOwner();
29         _;
30     }
31 
32     function _onlyOwner() private view {
33         require(msg.sender == owner, "Only the contract owner may perform this action");
34     }
35 
36     event OwnerNominated(address newOwner);
37     event OwnerChanged(address oldOwner, address newOwner);
38 }
39 
40 // File: contracts/Pausable.sol
41 
42 pragma solidity ^0.5.16;
43 
44 // Inheritance
45 
46 
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
86 
87 // File: contracts/RewardsDistributionRecipient.sol
88 
89 pragma solidity ^0.5.16;
90 
91 // Inheritance
92 
93 
94 contract RewardsDistributionRecipient is Owned {
95     address public rewardsDistribution;
96 
97     function notifyRewardAmount(uint256 reward) external;
98 
99     modifier onlyRewardsDistribution() {
100         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
101         _;
102     }
103 
104     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
105         rewardsDistribution = _rewardsDistribution;
106     }
107 }
108 
109 // File: contracts/interfaces/IStakingRewards.sol
110 
111 pragma solidity >=0.4.24;
112 
113 
114 interface IStakingRewards {
115     // Views
116     function lastTimeRewardApplicable() external view returns (uint256);
117 
118     function rewardPerToken() external view returns (uint256);
119 
120     function earned(address account) external view returns (uint256);
121 
122     function getRewardForDuration() external view returns (uint256);
123 
124     function totalSupply() external view returns (uint256);
125 
126     function balanceOf(address account) external view returns (uint256);
127 
128     // Mutative
129 
130     function stake(uint256 amount) external;
131 
132     function withdraw(uint256 amount) external;
133 
134     function getReward() external;
135 
136     function exit() external;
137 }
138 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
139 
140 pragma solidity ^0.5.0;
141 
142 /**
143  * @dev Contract module that helps prevent reentrant calls to a function.
144  *
145  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
146  * available, which can be aplied to functions to make sure there are no nested
147  * (reentrant) calls to them.
148  *
149  * Note that because there is a single `nonReentrant` guard, functions marked as
150  * `nonReentrant` may not call one another. This can be worked around by making
151  * those functions `private`, and then adding `external` `nonReentrant` entry
152  * points to them.
153  */
154 contract ReentrancyGuard {
155     /// @dev counter to allow mutex lock with only one SSTORE operation
156     uint256 private _guardCounter;
157 
158     constructor () internal {
159         // The counter starts at one to prevent changing it from zero to a non-zero
160         // value, which is a more expensive operation.
161         _guardCounter = 1;
162     }
163 
164     /**
165      * @dev Prevents a contract from calling itself, directly or indirectly.
166      * Calling a `nonReentrant` function from another `nonReentrant`
167      * function is not supported. It is possible to prevent this from happening
168      * by making the `nonReentrant` function external, and make it call a
169      * `private` function that does the actual work.
170      */
171     modifier nonReentrant() {
172         _guardCounter += 1;
173         uint256 localCounter = _guardCounter;
174         _;
175         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
176     }
177 }
178 
179 // File: @openzeppelin/contracts/utils/Address.sol
180 
181 pragma solidity ^0.5.0;
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
209 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
210 
211 pragma solidity ^0.5.0;
212 
213 /**
214  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
215  * the optional functions; to access them see `ERC20Detailed`.
216  */
217 interface IERC20 {
218     /**
219      * @dev Returns the amount of tokens in existence.
220      */
221     function totalSupply() external view returns (uint256);
222 
223     /**
224      * @dev Returns the amount of tokens owned by `account`.
225      */
226     function balanceOf(address account) external view returns (uint256);
227 
228     /**
229      * @dev Moves `amount` tokens from the caller's account to `recipient`.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * Emits a `Transfer` event.
234      */
235     function transfer(address recipient, uint256 amount) external returns (bool);
236 
237     /**
238      * @dev Returns the remaining number of tokens that `spender` will be
239      * allowed to spend on behalf of `owner` through `transferFrom`. This is
240      * zero by default.
241      *
242      * This value changes when `approve` or `transferFrom` are called.
243      */
244     function allowance(address owner, address spender) external view returns (uint256);
245 
246     /**
247      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * > Beware that changing an allowance with this method brings the risk
252      * that someone may use both the old and the new allowance by unfortunate
253      * transaction ordering. One possible solution to mitigate this race
254      * condition is to first reduce the spender's allowance to 0 and set the
255      * desired value afterwards:
256      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257      *
258      * Emits an `Approval` event.
259      */
260     function approve(address spender, uint256 amount) external returns (bool);
261 
262     /**
263      * @dev Moves `amount` tokens from `sender` to `recipient` using the
264      * allowance mechanism. `amount` is then deducted from the caller's
265      * allowance.
266      *
267      * Returns a boolean value indicating whether the operation succeeded.
268      *
269      * Emits a `Transfer` event.
270      */
271     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
272 
273     /**
274      * @dev Emitted when `value` tokens are moved from one account (`from`) to
275      * another (`to`).
276      *
277      * Note that `value` may be zero.
278      */
279     event Transfer(address indexed from, address indexed to, uint256 value);
280 
281     /**
282      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
283      * a call to `approve`. `value` is the new allowance.
284      */
285     event Approval(address indexed owner, address indexed spender, uint256 value);
286 }
287 
288 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
289 
290 pragma solidity ^0.5.0;
291 
292 
293 /**
294  * @dev Optional functions from the ERC20 standard.
295  */
296 contract ERC20Detailed is IERC20 {
297     string private _name;
298     string private _symbol;
299     uint8 private _decimals;
300 
301     /**
302      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
303      * these values are immutable: they can only be set once during
304      * construction.
305      */
306     constructor (string memory name, string memory symbol, uint8 decimals) public {
307         _name = name;
308         _symbol = symbol;
309         _decimals = decimals;
310     }
311 
312     /**
313      * @dev Returns the name of the token.
314      */
315     function name() public view returns (string memory) {
316         return _name;
317     }
318 
319     /**
320      * @dev Returns the symbol of the token, usually a shorter version of the
321      * name.
322      */
323     function symbol() public view returns (string memory) {
324         return _symbol;
325     }
326 
327     /**
328      * @dev Returns the number of decimals used to get its user representation.
329      * For example, if `decimals` equals `2`, a balance of `505` tokens should
330      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
331      *
332      * Tokens usually opt for a value of 18, imitating the relationship between
333      * Ether and Wei.
334      *
335      * > Note that this information is only used for _display_ purposes: it in
336      * no way affects any of the arithmetic of the contract, including
337      * `IERC20.balanceOf` and `IERC20.transfer`.
338      */
339     function decimals() public view returns (uint8) {
340         return _decimals;
341     }
342 }
343 
344 // File: @openzeppelin/contracts/math/SafeMath.sol
345 
346 pragma solidity ^0.5.0;
347 
348 /**
349  * @dev Wrappers over Solidity's arithmetic operations with added overflow
350  * checks.
351  *
352  * Arithmetic operations in Solidity wrap on overflow. This can easily result
353  * in bugs, because programmers usually assume that an overflow raises an
354  * error, which is the standard behavior in high level programming languages.
355  * `SafeMath` restores this intuition by reverting the transaction when an
356  * operation overflows.
357  *
358  * Using this library instead of the unchecked operations eliminates an entire
359  * class of bugs, so it's recommended to use it always.
360  */
361 library SafeMath {
362     /**
363      * @dev Returns the addition of two unsigned integers, reverting on
364      * overflow.
365      *
366      * Counterpart to Solidity's `+` operator.
367      *
368      * Requirements:
369      * - Addition cannot overflow.
370      */
371     function add(uint256 a, uint256 b) internal pure returns (uint256) {
372         uint256 c = a + b;
373         require(c >= a, "SafeMath: addition overflow");
374 
375         return c;
376     }
377 
378     /**
379      * @dev Returns the subtraction of two unsigned integers, reverting on
380      * overflow (when the result is negative).
381      *
382      * Counterpart to Solidity's `-` operator.
383      *
384      * Requirements:
385      * - Subtraction cannot overflow.
386      */
387     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
388         require(b <= a, "SafeMath: subtraction overflow");
389         uint256 c = a - b;
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the multiplication of two unsigned integers, reverting on
396      * overflow.
397      *
398      * Counterpart to Solidity's `*` operator.
399      *
400      * Requirements:
401      * - Multiplication cannot overflow.
402      */
403     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
404         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
405         // benefit is lost if 'b' is also tested.
406         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
407         if (a == 0) {
408             return 0;
409         }
410 
411         uint256 c = a * b;
412         require(c / a == b, "SafeMath: multiplication overflow");
413 
414         return c;
415     }
416 
417     /**
418      * @dev Returns the integer division of two unsigned integers. Reverts on
419      * division by zero. The result is rounded towards zero.
420      *
421      * Counterpart to Solidity's `/` operator. Note: this function uses a
422      * `revert` opcode (which leaves remaining gas untouched) while Solidity
423      * uses an invalid opcode to revert (consuming all remaining gas).
424      *
425      * Requirements:
426      * - The divisor cannot be zero.
427      */
428     function div(uint256 a, uint256 b) internal pure returns (uint256) {
429         // Solidity only automatically asserts when dividing by 0
430         require(b > 0, "SafeMath: division by zero");
431         uint256 c = a / b;
432         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
433 
434         return c;
435     }
436 
437     /**
438      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
439      * Reverts when dividing by zero.
440      *
441      * Counterpart to Solidity's `%` operator. This function uses a `revert`
442      * opcode (which leaves remaining gas untouched) while Solidity uses an
443      * invalid opcode to revert (consuming all remaining gas).
444      *
445      * Requirements:
446      * - The divisor cannot be zero.
447      */
448     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
449         require(b != 0, "SafeMath: modulo by zero");
450         return a % b;
451     }
452 }
453 
454 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
455 
456 pragma solidity ^0.5.0;
457 
458 
459 
460 
461 /**
462  * @title SafeERC20
463  * @dev Wrappers around ERC20 operations that throw on failure (when the token
464  * contract returns false). Tokens that return no value (and instead revert or
465  * throw on failure) are also supported, non-reverting calls are assumed to be
466  * successful.
467  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
468  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
469  */
470 library SafeERC20 {
471     using SafeMath for uint256;
472     using Address for address;
473 
474     function safeTransfer(IERC20 token, address to, uint256 value) internal {
475         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
476     }
477 
478     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
479         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
480     }
481 
482     function safeApprove(IERC20 token, address spender, uint256 value) internal {
483         // safeApprove should only be called when setting an initial allowance,
484         // or when resetting it to zero. To increase and decrease it, use
485         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
486         // solhint-disable-next-line max-line-length
487         require((value == 0) || (token.allowance(address(this), spender) == 0),
488             "SafeERC20: approve from non-zero to non-zero allowance"
489         );
490         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
491     }
492 
493     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
494         uint256 newAllowance = token.allowance(address(this), spender).add(value);
495         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
496     }
497 
498     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
499         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
500         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
501     }
502 
503     /**
504      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
505      * on the return value: the return value is optional (but if data is returned, it must not be false).
506      * @param token The token targeted by the call.
507      * @param data The call data (encoded using abi.encode or one of its variants).
508      */
509     function callOptionalReturn(IERC20 token, bytes memory data) private {
510         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
511         // we're implementing it ourselves.
512 
513         // A Solidity high level call has three parts:
514         //  1. The target address is checked to verify it contains contract code
515         //  2. The call itself is made, and success asserted
516         //  3. The return value is decoded, which in turn checks the size of the returned data.
517         // solhint-disable-next-line max-line-length
518         require(address(token).isContract(), "SafeERC20: call to non-contract");
519 
520         // solhint-disable-next-line avoid-low-level-calls
521         (bool success, bytes memory returndata) = address(token).call(data);
522         require(success, "SafeERC20: low-level call failed");
523 
524         if (returndata.length > 0) { // Return data is optional
525             // solhint-disable-next-line max-line-length
526             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
527         }
528     }
529 }
530 
531 // File: @openzeppelin/contracts/math/Math.sol
532 
533 pragma solidity ^0.5.0;
534 
535 /**
536  * @dev Standard math utilities missing in the Solidity language.
537  */
538 library Math {
539     /**
540      * @dev Returns the largest of two numbers.
541      */
542     function max(uint256 a, uint256 b) internal pure returns (uint256) {
543         return a >= b ? a : b;
544     }
545 
546     /**
547      * @dev Returns the smallest of two numbers.
548      */
549     function min(uint256 a, uint256 b) internal pure returns (uint256) {
550         return a < b ? a : b;
551     }
552 
553     /**
554      * @dev Returns the average of two numbers. The result is rounded towards
555      * zero.
556      */
557     function average(uint256 a, uint256 b) internal pure returns (uint256) {
558         // (a + b) / 2 can overflow, so we distribute
559         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
560     }
561 }
562 
563 // File: contracts/FixedLockStaking.sol
564 
565 pragma solidity ^0.5.16;
566 
567 
568 
569 
570 
571 // Inheritance
572 
573 
574 
575 
576 
577 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
578 contract FixedLockStaking is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
579     using SafeMath for uint256;
580     using SafeERC20 for IERC20;
581 
582     /* ========== STATE VARIABLES ========== */
583 
584     IERC20 public rewardsToken;
585     IERC20 public stakingToken;
586     uint256 public periodFinish = 0;
587     uint256 public rewardRate = 0;
588     uint256 public rewardsDuration = 0;
589     uint256 public lastUpdateTime;
590     uint256 public rewardPerTokenStored;
591 
592     mapping(address => uint256) public userRewardPerTokenPaid;
593     mapping(address => uint256) public rewards;
594 
595     uint256 private _totalSupply;
596     mapping(address => uint256) private _balances;
597 
598     /* ========== CONSTRUCTOR ========== */
599 
600     constructor(
601         address _owner,
602         address _rewardsDistribution,
603         address _rewardsToken,
604         address _stakingToken,
605         uint256 _rewardsDuration
606     ) public Owned(_owner) {
607         rewardsToken = IERC20(_rewardsToken);
608         stakingToken = IERC20(_stakingToken);
609         rewardsDistribution = _rewardsDistribution;
610         rewardsDuration = _rewardsDuration;
611     }
612 
613     /* ========== VIEWS ========== */
614 
615     function totalSupply() external view returns (uint256) {
616         return _totalSupply;
617     }
618 
619     function balanceOf(address account) external view returns (uint256) {
620         return _balances[account];
621     }
622 
623     function lastTimeRewardApplicable() public view returns (uint256) {
624         return Math.min(block.timestamp, periodFinish);
625     }
626 
627     function rewardPerToken() public view returns (uint256) {
628         if (_totalSupply == 0) {
629             return rewardPerTokenStored;
630         }
631         return
632             rewardPerTokenStored.add(
633                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
634             );
635     }
636 
637     function earned(address account) public view returns (uint256) {
638         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
639     }
640 
641     function getRewardForDuration() external view returns (uint256) {
642         return rewardRate.mul(rewardsDuration);
643     }
644 
645     /* ========== MUTATIVE FUNCTIONS ========== */
646 
647     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
648         require(amount > 0, "Cannot stake 0");
649         _totalSupply = _totalSupply.add(amount);
650         _balances[msg.sender] = _balances[msg.sender].add(amount);
651         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
652         emit Staked(msg.sender, amount);
653     }
654 
655     function withdraw(uint256 amount) public nonReentrant checkPeriodEnded updateReward(msg.sender) {
656         require(amount > 0, "Cannot withdraw 0");
657         _totalSupply = _totalSupply.sub(amount);
658         _balances[msg.sender] = _balances[msg.sender].sub(amount);
659         stakingToken.safeTransfer(msg.sender, amount);
660         emit Withdrawn(msg.sender, amount);
661     }
662 
663     function getReward() public nonReentrant checkPeriodEnded updateReward(msg.sender) {
664         uint256 reward = rewards[msg.sender];
665         if (reward > 0) {
666             rewards[msg.sender] = 0;
667             rewardsToken.safeTransfer(msg.sender, reward);
668             emit RewardPaid(msg.sender, reward);
669         }
670     }
671 
672     function exit() checkPeriodEnded external {
673         withdraw(_balances[msg.sender]);
674         getReward();
675     }
676 
677     /* ========== RESTRICTED FUNCTIONS ========== */
678 
679     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
680         require(block.timestamp >= periodFinish, "cannot notify reward until period ended");
681 
682         rewardRate = reward.div(rewardsDuration);
683 
684         // Ensure the provided reward amount is not more than the balance in the contract.
685         // This keeps the reward rate in the right range, preventing overflows due to
686         // very high values of rewardRate in the earned and rewardsPerToken functions;
687         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
688         uint balance = rewardsToken.balanceOf(address(this));
689         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
690 
691         lastUpdateTime = block.timestamp;
692         periodFinish = block.timestamp.add(rewardsDuration);
693         emit RewardAdded(reward);
694     }
695 
696     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
697         require(
698             block.timestamp > periodFinish,
699             "Previous rewards period must be complete before changing the duration for the new period"
700         );
701         rewardsDuration = _rewardsDuration;
702         emit RewardsDurationUpdated(rewardsDuration);
703     }
704 
705     /* ========== MODIFIERS ========== */
706     modifier checkPeriodEnded() {
707         require(periodFinish <= block.timestamp, "locking is not finished");
708         _;
709     }
710 
711     modifier updateReward(address account) {
712         rewardPerTokenStored = rewardPerToken();
713         lastUpdateTime = lastTimeRewardApplicable();
714         if (account != address(0)) {
715             rewards[account] = earned(account);
716             userRewardPerTokenPaid[account] = rewardPerTokenStored;
717         }
718         _;
719     }
720 
721     /* ========== EVENTS ========== */
722 
723     event RewardAdded(uint256 reward);
724     event Staked(address indexed user, uint256 amount);
725     event Withdrawn(address indexed user, uint256 amount);
726     event RewardPaid(address indexed user, uint256 reward);
727     event RewardsDurationUpdated(uint256 newDuration);
728     event Recovered(address token, uint256 amount);
729 }