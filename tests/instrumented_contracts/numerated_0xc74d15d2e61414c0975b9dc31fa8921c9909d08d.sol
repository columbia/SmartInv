1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-02
3 */
4 
5 pragma solidity ^0.5.16;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
9  * the optional functions; to access them see `ERC20Detailed`.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a `Transfer` event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through `transferFrom`. This is
34      * zero by default.
35      *
36      * This value changes when `approve` or `transferFrom` are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * > Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an `Approval` event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a `Transfer` event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to `approve`. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 /**
83  * @dev Contract module which provides a basic access control mechanism, where
84  * there is an account (an owner) that can be granted exclusive access to
85  * specific functions.
86  *
87  * This module is used through inheritance. It will make available the modifier
88  * `onlyOwner`, which can be aplied to your functions to restrict their use to
89  * the owner.
90  */
91 contract Ownable {
92     address private _owner;
93 
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96     /**
97      * @dev Initializes the contract setting the deployer as the initial owner.
98      */
99     constructor () internal {
100         _owner = msg.sender;
101         emit OwnershipTransferred(address(0), _owner);
102     }
103 
104     /**
105      * @dev Returns the address of the current owner.
106      */
107     function owner() public view returns (address) {
108         return _owner;
109     }
110 
111     /**
112      * @dev Throws if called by any account other than the owner.
113      */
114     modifier onlyOwner() {
115         require(isOwner(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119     /**
120      * @dev Returns true if the caller is the current owner.
121      */
122     function isOwner() public view returns (bool) {
123         return msg.sender == _owner;
124     }
125 
126     /**
127      * @dev Leaves the contract without owner. It will not be possible to call
128      * `onlyOwner` functions anymore. Can only be called by the current owner.
129      *
130      * > Note: Renouncing ownership will leave the contract without an owner,
131      * thereby removing any functionality that is only available to the owner.
132      */
133     function renounceOwnership() public onlyOwner {
134         emit OwnershipTransferred(_owner, address(0));
135         _owner = address(0);
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
140      * Can only be called by the current owner.
141      */
142     function transferOwnership(address newOwner) public onlyOwner {
143         _transferOwnership(newOwner);
144     }
145 
146     /**
147      * @dev Transfers ownership of the contract to a new account (`newOwner`).
148      */
149     function _transferOwnership(address newOwner) internal {
150         require(newOwner != address(0), "Ownable: new owner is the zero address");
151         emit OwnershipTransferred(_owner, newOwner);
152         _owner = newOwner;
153     }
154 }
155 
156 /**
157  * @dev Wrappers over Solidity's arithmetic operations with added overflow
158  * checks.
159  *
160  * Arithmetic operations in Solidity wrap on overflow. This can easily result
161  * in bugs, because programmers usually assume that an overflow raises an
162  * error, which is the standard behavior in high level programming languages.
163  * `SafeMath` restores this intuition by reverting the transaction when an
164  * operation overflows.
165  *
166  * Using this library instead of the unchecked operations eliminates an entire
167  * class of bugs, so it's recommended to use it always.
168  */
169 library SafeMath {
170     /**
171      * @dev Returns the addition of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `+` operator.
175      *
176      * Requirements:
177      * - Addition cannot overflow.
178      */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         uint256 c = a + b;
181         require(c >= a, "SafeMath: addition overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         require(b <= a, "SafeMath: subtraction overflow");
197         uint256 c = a - b;
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the multiplication of two unsigned integers, reverting on
204      * overflow.
205      *
206      * Counterpart to Solidity's `*` operator.
207      *
208      * Requirements:
209      * - Multiplication cannot overflow.
210      */
211     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
213         // benefit is lost if 'b' is also tested.
214         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
215         if (a == 0) {
216             return 0;
217         }
218 
219         uint256 c = a * b;
220         require(c / a == b, "SafeMath: multiplication overflow");
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Solidity only automatically asserts when dividing by 0
238         require(b > 0, "SafeMath: division by zero");
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         require(b != 0, "SafeMath: modulo by zero");
258         return a % b;
259     }
260 }
261 
262 /**
263  * @dev Standard math utilities missing in the Solidity language.
264  */
265 library Math {
266     /**
267      * @dev Returns the largest of two numbers.
268      */
269     function max(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a >= b ? a : b;
271     }
272 
273     /**
274      * @dev Returns the smallest of two numbers.
275      */
276     function min(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a < b ? a : b;
278     }
279 
280     /**
281      * @dev Returns the average of two numbers. The result is rounded towards
282      * zero.
283      */
284     function average(uint256 a, uint256 b) internal pure returns (uint256) {
285         // (a + b) / 2 can overflow, so we distribute
286         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
287     }
288 }
289 
290 /**
291  * @dev Optional functions from the ERC20 standard.
292  */
293 contract ERC20Detailed is IERC20 {
294     string private _name;
295     string private _symbol;
296     uint8 private _decimals;
297 
298     /**
299      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
300      * these values are immutable: they can only be set once during
301      * construction.
302      */
303     constructor (string memory name, string memory symbol, uint8 decimals) public {
304         _name = name;
305         _symbol = symbol;
306         _decimals = decimals;
307     }
308 
309     /**
310      * @dev Returns the name of the token.
311      */
312     function name() public view returns (string memory) {
313         return _name;
314     }
315 
316     /**
317      * @dev Returns the symbol of the token, usually a shorter version of the
318      * name.
319      */
320     function symbol() public view returns (string memory) {
321         return _symbol;
322     }
323 
324     /**
325      * @dev Returns the number of decimals used to get its user representation.
326      * For example, if `decimals` equals `2`, a balance of `505` tokens should
327      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
328      *
329      * Tokens usually opt for a value of 18, imitating the relationship between
330      * Ether and Wei.
331      *
332      * > Note that this information is only used for _display_ purposes: it in
333      * no way affects any of the arithmetic of the contract, including
334      * `IERC20.balanceOf` and `IERC20.transfer`.
335      */
336     function decimals() public view returns (uint8) {
337         return _decimals;
338     }
339 }
340 
341 /**
342  * @dev Collection of functions related to the address type,
343  */
344 library Address {
345     /**
346      * @dev Returns true if `account` is a contract.
347      *
348      * This test is non-exhaustive, and there may be false-negatives: during the
349      * execution of a contract's constructor, its address will be reported as
350      * not containing a contract.
351      *
352      * > It is unsafe to assume that an address for which this function returns
353      * false is an externally-owned account (EOA) and not a contract.
354      */
355     function isContract(address account) internal view returns (bool) {
356         // This method relies in extcodesize, which returns 0 for contracts in
357         // construction, since the code is only stored at the end of the
358         // constructor execution.
359 
360         uint256 size;
361         // solhint-disable-next-line no-inline-assembly
362         assembly { size := extcodesize(account) }
363         return size > 0;
364     }
365 }
366 
367 /**
368  * @title SafeERC20
369  * @dev Wrappers around ERC20 operations that throw on failure (when the token
370  * contract returns false). Tokens that return no value (and instead revert or
371  * throw on failure) are also supported, non-reverting calls are assumed to be
372  * successful.
373  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
374  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
375  */
376 library SafeERC20 {
377     using SafeMath for uint256;
378     using Address for address;
379 
380     function safeTransfer(IERC20 token, address to, uint256 value) internal {
381         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
382     }
383 
384     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
385         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
386     }
387 
388     function safeApprove(IERC20 token, address spender, uint256 value) internal {
389         // safeApprove should only be called when setting an initial allowance,
390         // or when resetting it to zero. To increase and decrease it, use
391         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
392         // solhint-disable-next-line max-line-length
393         require((value == 0) || (token.allowance(address(this), spender) == 0),
394             "SafeERC20: approve from non-zero to non-zero allowance"
395         );
396         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
397     }
398 
399     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
400         uint256 newAllowance = token.allowance(address(this), spender).add(value);
401         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
402     }
403 
404     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
405         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
406         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
407     }
408 
409     /**
410      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
411      * on the return value: the return value is optional (but if data is returned, it must not be false).
412      * @param token The token targeted by the call.
413      * @param data The call data (encoded using abi.encode or one of its variants).
414      */
415     function callOptionalReturn(IERC20 token, bytes memory data) private {
416         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
417         // we're implementing it ourselves.
418 
419         // A Solidity high level call has three parts:
420         //  1. The target address is checked to verify it contains contract code
421         //  2. The call itself is made, and success asserted
422         //  3. The return value is decoded, which in turn checks the size of the returned data.
423         // solhint-disable-next-line max-line-length
424         require(address(token).isContract(), "SafeERC20: call to non-contract");
425 
426         // solhint-disable-next-line avoid-low-level-calls
427         (bool success, bytes memory returndata) = address(token).call(data);
428         require(success, "SafeERC20: low-level call failed");
429 
430         if (returndata.length > 0) { // Return data is optional
431             // solhint-disable-next-line max-line-length
432             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
433         }
434     }
435 }
436 
437 /**
438  * @dev Contract module that helps prevent reentrant calls to a function.
439  *
440  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
441  * available, which can be aplied to functions to make sure there are no nested
442  * (reentrant) calls to them.
443  *
444  * Note that because there is a single `nonReentrant` guard, functions marked as
445  * `nonReentrant` may not call one another. This can be worked around by making
446  * those functions `private`, and then adding `external` `nonReentrant` entry
447  * points to them.
448  */
449 contract ReentrancyGuard {
450     /// @dev counter to allow mutex lock with only one SSTORE operation
451     uint256 private _guardCounter;
452 
453     constructor () internal {
454         // The counter starts at one to prevent changing it from zero to a non-zero
455         // value, which is a more expensive operation.
456         _guardCounter = 1;
457     }
458 
459     /**
460      * @dev Prevents a contract from calling itself, directly or indirectly.
461      * Calling a `nonReentrant` function from another `nonReentrant`
462      * function is not supported. It is possible to prevent this from happening
463      * by making the `nonReentrant` function external, and make it call a
464      * `private` function that does the actual work.
465      */
466     modifier nonReentrant() {
467         _guardCounter += 1;
468         uint256 localCounter = _guardCounter;
469         _;
470         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
471     }
472 }
473 
474 // Inheritance
475 interface IStakingRewards {
476     // Views
477     function lastTimeRewardApplicable() external view returns (uint256);
478 
479     function rewardPerToken() external view returns (uint256);
480 
481     function earned(address account) external view returns (uint256);
482 
483     function getRewardForDuration() external view returns (uint256);
484 
485     function totalSupply() external view returns (uint256);
486 
487     function balanceOf(address account) external view returns (uint256);
488 
489     // Mutative
490 
491     function stake(uint256 amount) external;
492 
493     function withdraw(uint256 amount) external;
494 
495     function getReward() external;
496 
497     function exit() external;
498 }
499 
500 contract RewardsDistributionRecipient {
501     address public rewardsDistribution;
502 
503     function notifyRewardAmount(uint256 reward) external;
504 
505     modifier onlyRewardsDistribution() {
506         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
507         _;
508     }
509 }
510 
511 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
512     using SafeMath for uint256;
513     using SafeERC20 for IERC20;
514 
515     /* ========== STATE VARIABLES ========== */
516 
517     IERC20 public rewardsToken;
518     IERC20 public stakingToken;
519     uint256 public periodFinish = 0;
520     uint256 public rewardRate = 0;
521     uint256 public rewardsDuration = 7 days;
522     uint256 public lastUpdateTime;
523     uint256 public rewardPerTokenStored;
524 
525     mapping(address => uint256) public userRewardPerTokenPaid;
526     mapping(address => uint256) public rewards;
527 
528     uint256 private _totalSupply;
529     mapping(address => uint256) private _balances;
530 
531     /* ========== CONSTRUCTOR ========== */
532 
533     constructor(
534         address _rewardsDistribution,
535         address _rewardsToken,
536         address _stakingToken
537     ) public {
538         rewardsToken = IERC20(_rewardsToken);
539         stakingToken = IERC20(_stakingToken);
540         rewardsDistribution = _rewardsDistribution;
541     }
542 
543     /* ========== VIEWS ========== */
544 
545     function totalSupply() external view returns (uint256) {
546         return _totalSupply;
547     }
548 
549     function balanceOf(address account) external view returns (uint256) {
550         return _balances[account];
551     }
552 
553     function lastTimeRewardApplicable() public view returns (uint256) {
554         return Math.min(block.timestamp, periodFinish);
555     }
556 
557     function rewardPerToken() public view returns (uint256) {
558         if (_totalSupply == 0) {
559             return rewardPerTokenStored;
560         }
561         return
562             rewardPerTokenStored.add(
563                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
564             );
565     }
566 
567     function earned(address account) public view returns (uint256) {
568         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
569     }
570 
571     function getRewardForDuration() external view returns (uint256) {
572         return rewardRate.mul(rewardsDuration);
573     }
574 
575     /* ========== MUTATIVE FUNCTIONS ========== */
576 
577     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
578         require(amount > 0, "Cannot stake 0");
579         _totalSupply = _totalSupply.add(amount);
580         _balances[msg.sender] = _balances[msg.sender].add(amount);
581 
582         // permit
583         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
584 
585         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
586         emit Staked(msg.sender, amount);
587     }
588 
589     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
590         require(amount > 0, "Cannot stake 0");
591         _totalSupply = _totalSupply.add(amount);
592         _balances[msg.sender] = _balances[msg.sender].add(amount);
593         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
594         emit Staked(msg.sender, amount);
595     }
596 
597     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
598         require(amount > 0, "Cannot withdraw 0");
599         _totalSupply = _totalSupply.sub(amount);
600         _balances[msg.sender] = _balances[msg.sender].sub(amount);
601         stakingToken.safeTransfer(msg.sender, amount);
602         emit Withdrawn(msg.sender, amount);
603     }
604 
605     function getReward() public nonReentrant updateReward(msg.sender) {
606         uint256 reward = rewards[msg.sender];
607         if (reward > 0) {
608             rewards[msg.sender] = 0;
609             rewardsToken.safeTransfer(msg.sender, reward);
610             emit RewardPaid(msg.sender, reward);
611         }
612     }
613 
614     function exit() external {
615         withdraw(_balances[msg.sender]);
616         getReward();
617     }
618 
619     /* ========== RESTRICTED FUNCTIONS ========== */
620 
621     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
622         if (block.timestamp >= periodFinish) {
623             rewardRate = reward.div(rewardsDuration);
624         } else {
625             uint256 remaining = periodFinish.sub(block.timestamp);
626             uint256 leftover = remaining.mul(rewardRate);
627             rewardRate = reward.add(leftover).div(rewardsDuration);
628         }
629 
630         // Ensure the provided reward amount is not more than the balance in the contract.
631         // This keeps the reward rate in the right range, preventing overflows due to
632         // very high values of rewardRate in the earned and rewardsPerToken functions;
633         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
634         uint balance = rewardsToken.balanceOf(address(this));
635         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
636 
637         lastUpdateTime = block.timestamp;
638         periodFinish = block.timestamp.add(rewardsDuration);
639         emit RewardAdded(reward);
640     }
641 
642     /* ========== MODIFIERS ========== */
643 
644     modifier updateReward(address account) {
645         rewardPerTokenStored = rewardPerToken();
646         lastUpdateTime = lastTimeRewardApplicable();
647         if (account != address(0)) {
648             rewards[account] = earned(account);
649             userRewardPerTokenPaid[account] = rewardPerTokenStored;
650         }
651         _;
652     }
653 
654     /* ========== EVENTS ========== */
655 
656     event RewardAdded(uint256 reward);
657     event Staked(address indexed user, uint256 amount);
658     event Withdrawn(address indexed user, uint256 amount);
659     event RewardPaid(address indexed user, uint256 reward);
660 }
661 
662 interface IUniswapV2ERC20 {
663     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
664 }
665 
666 
667 interface IMinterV2ERC20 {
668     function mint(address dst, uint rawAmount) external;
669 }
670 
671 contract StakingRewardsFactory is Ownable {
672     using SafeMath for uint;
673     // immutables
674     address public rewardsToken;
675     address public govRewardAccount;
676     address public devRewardAccount0;
677     address public devRewardAccount1;
678     uint public stakingRateGenesis=28620;
679     uint public stakingRateTotal=1000000;//100%Percent * 10000
680     uint public stakingRewardsGenesis;
681     address public timelock;
682 
683     // the staking tokens for which the rewards contract has been deployed
684     address[] public stakingTokens;
685 
686     // info about rewards for a particular staking token
687     struct StakingRewardsInfo {
688         address stakingRewards;
689         uint16 rewardRate;
690     }
691 
692     // rewards info by staking token
693     mapping(address => StakingRewardsInfo) public stakingRewardsInfoByStakingToken;
694 
695     constructor(
696         address _rewardsToken,
697         address _govRewardAccount,
698         address _devRewardAccount0,
699         address _devRewardAccount1,
700         uint _stakingRewardsGenesis
701     ) Ownable() public {
702         require(_stakingRewardsGenesis >= block.timestamp, 'StakingRewardsFactory::constructor: genesis too soon');
703 
704         rewardsToken = _rewardsToken;
705         govRewardAccount = _govRewardAccount;
706         devRewardAccount0 = _devRewardAccount0;
707         devRewardAccount1 = _devRewardAccount1;
708         stakingRewardsGenesis = _stakingRewardsGenesis;
709         timelock = owner();
710     }
711 
712     ///// permissioned functions
713 
714     // deploy a staking reward contract for the staking token, and store the reward amount
715     // the reward will be distributed to the staking reward contract no sooner than the genesis
716     function deploy(address[] memory _stakingTokens, uint16[] memory _rewardRates) public {
717         require(msg.sender == timelock, "!timelock");
718         require(_stakingTokens.length == _rewardRates.length, "stakingTokens and rewardRates lengths mismatch");
719 
720         for (uint i = 0; i < stakingTokens.length; i++) {
721             StakingRewardsInfo storage  info = stakingRewardsInfoByStakingToken[stakingTokens[i]];
722             info.rewardRate = 0;
723         }
724         uint16  totalRate = 0;
725 
726 
727         for (uint i = 0; i < _rewardRates.length; i++) {
728             require(_rewardRates[i] > 0, "rewardRate zero");
729             require(_stakingTokens[i] != address(0), "StakingRewardsFactory::deploy: stakingToken empty");
730 
731             totalRate = totalRate + _rewardRates[i];
732 
733             StakingRewardsInfo storage  info = stakingRewardsInfoByStakingToken[_stakingTokens[i]];
734             require(info.rewardRate==0, "StakingRewardsFactory::deploy: _stakingTokens is repeat");
735 
736             info.rewardRate = _rewardRates[i];
737             if(info.stakingRewards == address(0)){
738                 info.stakingRewards = address(new StakingRewards(/*_rewardsDistribution=*/ address(this), rewardsToken, _stakingTokens[i]));
739                 stakingTokens.push(_stakingTokens[i]);
740             }
741         }
742         require(totalRate == 10000, 'StakingRewardsFactory::deploy: totalRate not equal to 10000');
743     }
744 
745     function rewardTotalToken() public view returns (uint256) {
746         if (stakingRateGenesis >= stakingRateTotal) {
747             return stakingRateTotal.mul(27).mul(1e18).div(100);
748         }
749         return stakingRateGenesis.mul(27).mul(1e18).div(100);
750     }
751 
752     ///// permissionless functions
753 
754     // call notifyRewardAmount for all staking tokens.
755     function notifyRewardAmounts() public {
756         require(stakingTokens.length > 0, 'StakingRewardsFactory::notifyRewardAmounts: called before any deploys');
757         require(block.timestamp >= stakingRewardsGenesis, 'StakingRewardsFactory::notifyRewardAmounts: reward not start');
758         require(stakingRateTotal > 0, 'StakingRewardsFactory::notifyRewardAmounts: reward is over');
759 
760         if(stakingRateGenesis >= stakingRateTotal){
761             stakingRateGenesis = stakingRateTotal;
762         }
763         uint _totalRewardAmount = rewardTotalToken();// equal 270000 * 28620 / 10000 / 100
764 
765         stakingRewardsGenesis = stakingRewardsGenesis + 7 days;
766         stakingRateTotal = stakingRateTotal.sub(stakingRateGenesis);
767         stakingRateGenesis = stakingRateGenesis.mul(9730).div(10000);//next reward rate equal stakingRateGenesis * (1-2.7%)
768 
769         _mint(_totalRewardAmount);
770 
771         uint _govFundAmount = _totalRewardAmount.div(27);// 1/27
772         uint _devFundAmount = _totalRewardAmount.mul(5).div(27);// 5/27
773         uint _devFundAmount0 = _devFundAmount.mul(80).div(100);//80%
774         _reserveRewards(govRewardAccount,_govFundAmount);
775         _reserveRewards(devRewardAccount0,_devFundAmount0);
776         _reserveRewards(devRewardAccount1,_devFundAmount.sub(_devFundAmount0));//20%
777 
778         uint _poolRewardAmount = _totalRewardAmount.sub(_govFundAmount).sub(_devFundAmount); // 21/27
779         _notifyPoolRewardAmounts(_poolRewardAmount);
780     }
781 
782     function _notifyPoolRewardAmounts(uint _poolRewardAmount) private {
783         uint _surplusRewardAmount = _poolRewardAmount;
784         uint _rewardAmount = 0;
785         address farmAddr;
786 
787         for (uint i = 0; i < stakingTokens.length; i++) {
788             StakingRewardsInfo memory info = stakingRewardsInfoByStakingToken[stakingTokens[i]];
789             if(info.rewardRate <= 0){
790                 continue;
791             }
792             if(stakingTokens[i] == rewardsToken){
793                 farmAddr = info.stakingRewards;
794                 continue;
795             }
796             _rewardAmount = _poolRewardAmount.mul(info.rewardRate).div(10000);
797             if(_rewardAmount >= _surplusRewardAmount){
798                 _rewardAmount = _surplusRewardAmount;
799             }
800             _surplusRewardAmount = _surplusRewardAmount.sub(_rewardAmount);
801             _notifyRewardAmount(info.stakingRewards,_rewardAmount);
802         }
803         _surplusRewardAmount = IERC20(rewardsToken).balanceOf(address(this));
804         if(_surplusRewardAmount > 0 && farmAddr != address(0)){
805             _notifyRewardAmount(farmAddr,_surplusRewardAmount);
806         }
807     }
808 
809 
810     // notify reward amount for an individual staking token.
811     // this is a fallback in case the notifyRewardAmounts costs too much gas to call for all contracts
812     function _notifyRewardAmount(address _stakingToken,uint _rewardAmount) private {
813         require(_stakingToken != address(0), 'StakingRewardsFactory::notifyRewardAmount: not deployed');
814 
815         if (_rewardAmount > 0) {
816             require(
817                 IERC20(rewardsToken).transfer(_stakingToken, _rewardAmount),
818                 'StakingRewardsFactory::notifyRewardAmount: transfer failed'
819             );
820             StakingRewards(_stakingToken).notifyRewardAmount(_rewardAmount);
821         }
822     }
823 
824     function _reserveRewards(address _account,uint _rawRewardsAmount) private {
825         require(_account != address(0), 'StakingRewardsFactory::_reserveRewards: not deployed');
826 
827         require(
828             IERC20(rewardsToken).transfer(_account, _rawRewardsAmount),
829             'StakingRewardsFactory::_reserveRewards: transfer failed'
830         );
831     }
832 
833     function _mint(uint _mintAmount) private {
834         require(_mintAmount > 0, 'StakingRewardsFactory::_mint: mintAmount is zero');
835 
836         IMinterV2ERC20(rewardsToken).mint(address(this), _mintAmount);
837     }
838 
839     function setTimeLock(address _timelock) public {
840         require(msg.sender == timelock, "!timelock");
841         timelock = _timelock;
842     }
843 }