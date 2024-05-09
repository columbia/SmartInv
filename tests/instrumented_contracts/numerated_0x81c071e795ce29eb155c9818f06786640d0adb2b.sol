1 /**
2  *  @authors: []
3  *  @reviewers: [@clesaege]
4  *  @auditors: []
5  *  @bounties: []
6  *  @deployments: []
7  *  @tools: []
8  */
9 pragma solidity ^0.5.17;
10 
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
14  * the optional functions; to access them see `ERC20Detailed`.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a `Transfer` event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through `transferFrom`. This is
39      * zero by default.
40      *
41      * This value changes when `approve` or `transferFrom` are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * > Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an `Approval` event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a `Transfer` event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to `approve`. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 /**
89  * @dev Contract module which provides a basic access control mechanism, where
90  * there is an account (an owner) that can be granted exclusive access to
91  * specific functions.
92  *
93  * This module is used through inheritance. It will make available the modifier
94  * `onlyOwner`, which can be aplied to your functions to restrict their use to
95  * the owner.
96  */
97 contract Ownable {
98     address private _owner;
99 
100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102     /**
103      * @dev Initializes the contract setting the deployer as the initial owner.
104      */
105     constructor () internal {
106         _owner = msg.sender;
107         emit OwnershipTransferred(address(0), _owner);
108     }
109 
110     /**
111      * @dev Returns the address of the current owner.
112      */
113     function owner() public view returns (address) {
114         return _owner;
115     }
116 
117     /**
118      * @dev Throws if called by any account other than the owner.
119      */
120     modifier onlyOwner() {
121         require(isOwner(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     /**
126      * @dev Returns true if the caller is the current owner.
127      */
128     function isOwner() public view returns (bool) {
129         return msg.sender == _owner;
130     }
131 
132     /**
133      * @dev Leaves the contract without owner. It will not be possible to call
134      * `onlyOwner` functions anymore. Can only be called by the current owner.
135      *
136      * > Note: Renouncing ownership will leave the contract without an owner,
137      * thereby removing any functionality that is only available to the owner.
138      */
139     function renounceOwnership() public onlyOwner {
140         emit OwnershipTransferred(_owner, address(0));
141         _owner = address(0);
142     }
143 
144     /**
145      * @dev Transfers ownership of the contract to a new account (`newOwner`).
146      * Can only be called by the current owner.
147      */
148     function transferOwnership(address newOwner) public onlyOwner {
149         _transferOwnership(newOwner);
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      */
155     function _transferOwnership(address newOwner) internal {
156         require(newOwner != address(0), "Ownable: new owner is the zero address");
157         emit OwnershipTransferred(_owner, newOwner);
158         _owner = newOwner;
159     }
160 }
161 
162 
163 /**
164  * @dev Standard math utilities missing in the Solidity language.
165  */
166 library Math {
167     /**
168      * @dev Returns the largest of two numbers.
169      */
170     function max(uint256 a, uint256 b) internal pure returns (uint256) {
171         return a >= b ? a : b;
172     }
173 
174     /**
175      * @dev Returns the smallest of two numbers.
176      */
177     function min(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a < b ? a : b;
179     }
180 
181     /**
182      * @dev Returns the average of two numbers. The result is rounded towards
183      * zero.
184      */
185     function average(uint256 a, uint256 b) internal pure returns (uint256) {
186         // (a + b) / 2 can overflow, so we distribute
187         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
188     }
189 }
190 
191 
192 /**
193  * @dev Wrappers over Solidity's arithmetic operations with added overflow
194  * checks.
195  *
196  * Arithmetic operations in Solidity wrap on overflow. This can easily result
197  * in bugs, because programmers usually assume that an overflow raises an
198  * error, which is the standard behavior in high level programming languages.
199  * `SafeMath` restores this intuition by reverting the transaction when an
200  * operation overflows.
201  *
202  * Using this library instead of the unchecked operations eliminates an entire
203  * class of bugs, so it's recommended to use it always.
204  */
205 library SafeMath {
206     /**
207      * @dev Returns the addition of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `+` operator.
211      *
212      * Requirements:
213      * - Addition cannot overflow.
214      */
215     function add(uint256 a, uint256 b) internal pure returns (uint256) {
216         uint256 c = a + b;
217         require(c >= a, "SafeMath: addition overflow");
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      * - Subtraction cannot overflow.
230      */
231     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232         require(b <= a, "SafeMath: subtraction overflow");
233         uint256 c = a - b;
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the multiplication of two unsigned integers, reverting on
240      * overflow.
241      *
242      * Counterpart to Solidity's `*` operator.
243      *
244      * Requirements:
245      * - Multiplication cannot overflow.
246      */
247     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
248         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
249         // benefit is lost if 'b' is also tested.
250         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
251         if (a == 0) {
252             return 0;
253         }
254 
255         uint256 c = a * b;
256         require(c / a == b, "SafeMath: multiplication overflow");
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the integer division of two unsigned integers. Reverts on
263      * division by zero. The result is rounded towards zero.
264      *
265      * Counterpart to Solidity's `/` operator. Note: this function uses a
266      * `revert` opcode (which leaves remaining gas untouched) while Solidity
267      * uses an invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      * - The divisor cannot be zero.
271      */
272     function div(uint256 a, uint256 b) internal pure returns (uint256) {
273         // Solidity only automatically asserts when dividing by 0
274         require(b > 0, "SafeMath: division by zero");
275         uint256 c = a / b;
276         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
277 
278         return c;
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * Reverts when dividing by zero.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      * - The divisor cannot be zero.
291      */
292     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
293         require(b != 0, "SafeMath: modulo by zero");
294         return a % b;
295     }
296 }
297 
298 /**
299  * @dev Optional functions from the ERC20 standard.
300  */
301 contract ERC20Detailed is IERC20 {
302     string private _name;
303     string private _symbol;
304     uint8 private _decimals;
305 
306     /**
307      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
308      * these values are immutable: they can only be set once during
309      * construction.
310      */
311     constructor (string memory name, string memory symbol, uint8 decimals) public {
312         _name = name;
313         _symbol = symbol;
314         _decimals = decimals;
315     }
316 
317     /**
318      * @dev Returns the name of the token.
319      */
320     function name() public view returns (string memory) {
321         return _name;
322     }
323 
324     /**
325      * @dev Returns the symbol of the token, usually a shorter version of the
326      * name.
327      */
328     function symbol() public view returns (string memory) {
329         return _symbol;
330     }
331 
332     /**
333      * @dev Returns the number of decimals used to get its user representation.
334      * For example, if `decimals` equals `2`, a balance of `505` tokens should
335      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
336      *
337      * Tokens usually opt for a value of 18, imitating the relationship between
338      * Ether and Wei.
339      *
340      * > Note that this information is only used for _display_ purposes: it in
341      * no way affects any of the arithmetic of the contract, including
342      * `IERC20.balanceOf` and `IERC20.transfer`.
343      */
344     function decimals() public view returns (uint8) {
345         return _decimals;
346     }
347 }
348 
349 
350 /**
351  * @dev Collection of functions related to the address type,
352  */
353 library Address {
354     /**
355      * @dev Returns true if `account` is a contract.
356      *
357      * This test is non-exhaustive, and there may be false-negatives: during the
358      * execution of a contract's constructor, its address will be reported as
359      * not containing a contract.
360      *
361      * > It is unsafe to assume that an address for which this function returns
362      * false is an externally-owned account (EOA) and not a contract.
363      */
364     function isContract(address account) internal view returns (bool) {
365         // This method relies in extcodesize, which returns 0 for contracts in
366         // construction, since the code is only stored at the end of the
367         // constructor execution.
368 
369         uint256 size;
370         // solhint-disable-next-line no-inline-assembly
371         assembly { size := extcodesize(account) }
372         return size > 0;
373     }
374 }
375 
376 
377 /**
378  * @title SafeERC20
379  * @dev Wrappers around ERC20 operations that throw on failure (when the token
380  * contract returns false). Tokens that return no value (and instead revert or
381  * throw on failure) are also supported, non-reverting calls are assumed to be
382  * successful.
383  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
384  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
385  */
386 library SafeERC20 {
387     using SafeMath for uint256;
388     using Address for address;
389 
390     function safeTransfer(IERC20 token, address to, uint256 value) internal {
391         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
392     }
393 
394     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
395         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
396     }
397 
398     function safeApprove(IERC20 token, address spender, uint256 value) internal {
399         // safeApprove should only be called when setting an initial allowance,
400         // or when resetting it to zero. To increase and decrease it, use
401         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
402         // solhint-disable-next-line max-line-length
403         require((value == 0) || (token.allowance(address(this), spender) == 0),
404             "SafeERC20: approve from non-zero to non-zero allowance"
405         );
406         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
407     }
408 
409     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
410         uint256 newAllowance = token.allowance(address(this), spender).add(value);
411         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
412     }
413 
414     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
415         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
416         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
417     }
418 
419     /**
420      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
421      * on the return value: the return value is optional (but if data is returned, it must not be false).
422      * @param token The token targeted by the call.
423      * @param data The call data (encoded using abi.encode or one of its variants).
424      */
425     function callOptionalReturn(IERC20 token, bytes memory data) private {
426         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
427         // we're implementing it ourselves.
428 
429         // A Solidity high level call has three parts:
430         //  1. The target address is checked to verify it contains contract code
431         //  2. The call itself is made, and success asserted
432         //  3. The return value is decoded, which in turn checks the size of the returned data.
433         // solhint-disable-next-line max-line-length
434         require(address(token).isContract(), "SafeERC20: call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = address(token).call(data);
438         require(success, "SafeERC20: low-level call failed");
439 
440         if (returndata.length > 0) { // Return data is optional
441             // solhint-disable-next-line max-line-length
442             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
443         }
444     }
445 }
446 
447 
448 /**
449  * @dev Contract module that helps prevent reentrant calls to a function.
450  *
451  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
452  * available, which can be aplied to functions to make sure there are no nested
453  * (reentrant) calls to them.
454  *
455  * Note that because there is a single `nonReentrant` guard, functions marked as
456  * `nonReentrant` may not call one another. This can be worked around by making
457  * those functions `private`, and then adding `external` `nonReentrant` entry
458  * points to them.
459  */
460 contract ReentrancyGuard {
461     /// @dev counter to allow mutex lock with only one SSTORE operation
462     uint256 private _guardCounter;
463 
464     constructor () internal {
465         // The counter starts at one to prevent changing it from zero to a non-zero
466         // value, which is a more expensive operation.
467         _guardCounter = 1;
468     }
469 
470     /**
471      * @dev Prevents a contract from calling itself, directly or indirectly.
472      * Calling a `nonReentrant` function from another `nonReentrant`
473      * function is not supported. It is possible to prevent this from happening
474      * by making the `nonReentrant` function external, and make it call a
475      * `private` function that does the actual work.
476      */
477     modifier nonReentrant() {
478         _guardCounter += 1;
479         uint256 localCounter = _guardCounter;
480         _;
481         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
482     }
483 }
484 
485 
486 contract RewardsDistributionRecipient {
487     address public rewardsDistribution;
488 
489     function notifyRewardAmount(uint256 reward) external;
490 
491     modifier onlyRewardsDistribution() {
492         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
493         _;
494     }
495 }
496 
497 interface IStakingRewards {
498     // Views
499     function lastTimeRewardApplicable() external view returns (uint256);
500 
501     function rewardPerToken() external view returns (uint256);
502 
503     function earned(address account) external view returns (uint256);
504 
505     function getRewardForDuration() external view returns (uint256);
506 
507     function totalSupply() external view returns (uint256);
508 
509     function balanceOf(address account) external view returns (uint256);
510 
511     // Mutative
512 
513     function stake(uint256 amount) external;
514 
515     function withdraw(uint256 amount) external;
516 
517     function getReward() external;
518 
519     function exit() external;
520 }
521 
522 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
523     using SafeMath for uint256;
524     using SafeERC20 for IERC20;
525 
526     /* ========== STATE VARIABLES ========== */
527 
528     IERC20 public rewardsToken;
529     IERC20 public stakingToken;
530     uint256 public periodFinish = 0;
531     uint256 public rewardRate = 0;
532     uint256 public rewardsDuration = 365 days;
533     uint256 public lastUpdateTime;
534     uint256 public rewardPerTokenStored;
535 
536     mapping(address => uint256) public userRewardPerTokenPaid;
537     mapping(address => uint256) public rewards;
538 
539     uint256 private _totalSupply;
540     mapping(address => uint256) private _balances;
541 
542     /* ========== CONSTRUCTOR ========== */
543 
544     constructor(
545         address _rewardsDistribution,
546         address _rewardsToken,
547         address _stakingToken
548     ) public {
549         rewardsToken = IERC20(_rewardsToken);
550         stakingToken = IERC20(_stakingToken);
551         rewardsDistribution = _rewardsDistribution;
552     }
553 
554     /* ========== VIEWS ========== */
555 
556     function totalSupply() external view returns (uint256) {
557         return _totalSupply;
558     }
559 
560     function balanceOf(address account) external view returns (uint256) {
561         return _balances[account];
562     }
563 
564     function lastTimeRewardApplicable() public view returns (uint256) {
565         return Math.min(block.timestamp, periodFinish);
566     }
567 
568     function rewardPerToken() public view returns (uint256) {
569         if (_totalSupply == 0) {
570             return rewardPerTokenStored;
571         }
572         return
573             rewardPerTokenStored.add(
574                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
575             );
576     }
577 
578     function earned(address account) public view returns (uint256) {
579         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
580     }
581 
582     function getRewardForDuration() external view returns (uint256) {
583         return rewardRate.mul(rewardsDuration);
584     }
585 
586     /* ========== MUTATIVE FUNCTIONS ========== */
587 
588     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
589         require(amount > 0, "Cannot stake 0");
590         _totalSupply = _totalSupply.add(amount);
591         _balances[msg.sender] = _balances[msg.sender].add(amount);
592 
593         // permit
594         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
595 
596         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
597         emit Staked(msg.sender, amount);
598     }
599 
600     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
601         require(amount > 0, "Cannot stake 0");
602         _totalSupply = _totalSupply.add(amount);
603         _balances[msg.sender] = _balances[msg.sender].add(amount);
604         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
605         emit Staked(msg.sender, amount);
606     }
607 
608     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
609         require(amount > 0, "Cannot withdraw 0");
610         _totalSupply = _totalSupply.sub(amount);
611         _balances[msg.sender] = _balances[msg.sender].sub(amount);
612         stakingToken.safeTransfer(msg.sender, amount);
613         emit Withdrawn(msg.sender, amount);
614     }
615 
616     function getReward() public nonReentrant updateReward(msg.sender) {
617         uint256 reward = rewards[msg.sender];
618         if (reward > 0) {
619             rewards[msg.sender] = 0;
620             rewardsToken.safeTransfer(msg.sender, reward);
621             emit RewardPaid(msg.sender, reward);
622         }
623     }
624 
625     function exit() external {
626         withdraw(_balances[msg.sender]);
627         getReward();
628     }
629 
630     /* ========== RESTRICTED FUNCTIONS ========== */
631 
632     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
633         if (block.timestamp >= periodFinish) {
634             rewardRate = reward.div(rewardsDuration);
635         } else {
636             uint256 remaining = periodFinish.sub(block.timestamp);
637             uint256 leftover = remaining.mul(rewardRate);
638             rewardRate = reward.add(leftover).div(rewardsDuration);
639         }
640 
641         // Ensure the provided reward amount is not more than the balance in the contract.
642         // This keeps the reward rate in the right range, preventing overflows due to
643         // very high values of rewardRate in the earned and rewardsPerToken functions;
644         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
645         uint balance = rewardsToken.balanceOf(address(this));
646         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
647 
648         lastUpdateTime = block.timestamp;
649         periodFinish = block.timestamp.add(rewardsDuration);
650         emit RewardAdded(reward);
651     }
652 
653     /* ========== MODIFIERS ========== */
654 
655     modifier updateReward(address account) {
656         rewardPerTokenStored = rewardPerToken();
657         lastUpdateTime = lastTimeRewardApplicable();
658         if (account != address(0)) {
659             rewards[account] = earned(account);
660             userRewardPerTokenPaid[account] = rewardPerTokenStored;
661         }
662         _;
663     }
664 
665     /* ========== EVENTS ========== */
666 
667     event RewardAdded(uint256 reward);
668     event Staked(address indexed user, uint256 amount);
669     event Withdrawn(address indexed user, uint256 amount);
670     event RewardPaid(address indexed user, uint256 reward);
671 }
672 
673 interface IUniswapV2ERC20 {
674     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
675 }
676 
677 
678 
679 contract StakingRewardsFactory is Ownable {
680     // immutables
681     address public rewardsToken;
682     uint public stakingRewardsGenesis;
683 
684     // the staking tokens for which the rewards contract has been deployed
685     address[] public stakingTokens;
686 
687     // info about rewards for a particular staking token
688     struct StakingRewardsInfo {
689         address stakingRewards;
690         uint rewardAmount;
691     }
692 
693     // rewards info by staking token
694     mapping(address => StakingRewardsInfo) public stakingRewardsInfoByStakingToken;
695 
696     constructor(
697         address _rewardsToken,
698         uint _stakingRewardsGenesis
699     ) Ownable() public {
700         require(_stakingRewardsGenesis >= block.timestamp, 'StakingRewardsFactory::constructor: genesis too soon');
701 
702         rewardsToken = _rewardsToken;
703         stakingRewardsGenesis = _stakingRewardsGenesis;
704     }
705 
706     ///// permissioned functions
707 
708     // deploy a staking reward contract for the staking token, and store the reward amount
709     // the reward will be distributed to the staking reward contract no sooner than the genesis
710     function deploy(address stakingToken, uint rewardAmount) public onlyOwner {
711         StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[stakingToken];
712         require(info.stakingRewards == address(0), 'StakingRewardsFactory::deploy: already deployed');
713 
714         info.stakingRewards = address(new StakingRewards(/*_rewardsDistribution=*/ address(this), rewardsToken, stakingToken));
715         info.rewardAmount = rewardAmount;
716         stakingTokens.push(stakingToken);
717     }
718 
719     ///// permissionless functions
720 
721     // call notifyRewardAmount for all staking tokens.
722     function notifyRewardAmounts() public {
723         require(stakingTokens.length > 0, 'StakingRewardsFactory::notifyRewardAmounts: called before any deploys');
724         for (uint i = 0; i < stakingTokens.length; i++) {
725             notifyRewardAmount(stakingTokens[i]);
726         }
727     }
728 
729     // transfer tokens and notify reward amount for an individual staking token.
730     function notifyRewardAmount(address stakingToken) public {
731         require(block.timestamp >= stakingRewardsGenesis, 'StakingRewardsFactory::notifyRewardAmount: not ready');
732 
733         StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[stakingToken];
734         require(info.stakingRewards != address(0), 'StakingRewardsFactory::notifyRewardAmount: not deployed');
735 
736         if (info.rewardAmount > 0) {
737             uint rewardAmount = info.rewardAmount;
738             info.rewardAmount = 0;
739 
740             require(
741                 IERC20(rewardsToken).transfer(info.stakingRewards, rewardAmount),
742                 'StakingRewardsFactory::notifyRewardAmount: transfer failed'
743             );
744             StakingRewards(info.stakingRewards).notifyRewardAmount(rewardAmount);
745         }
746     }
747 }