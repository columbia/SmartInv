1 //   _________ _______   ________  __      __  _________ __                        
2 //  /   _____/ \      \  \_____  \/  \    /  \/   _____//  |_  ___________  _____  
3 //  \_____  \  /   |   \  /   |   \   \/\/   /\_____  \\   __\/  _ \_  __ \/     \ 
4 //  /        \/    |    \/    |    \        / /        \|  | (  <_> )  | \/  Y Y  \
5 // /_______  /\____|__  /\_______  /\__/\  / /_______  /|__|  \____/|__|  |__|_|  /
6 //         \/         \/         \/      \/          \/                         \/ 
7 
8 // Snowstorm token geyser factory
9 // Based off SNX and UNI staking contracts
10 pragma solidity ^0.5.16;
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
87 /**
88  * @dev Contract module which provides a basic access control mechanism, where
89  * there is an account (an owner) that can be granted exclusive access to
90  * specific functions.
91  *
92  * This module is used through inheritance. It will make available the modifier
93  * `onlyOwner`, which can be aplied to your functions to restrict their use to
94  * the owner.
95  */
96 contract Ownable {
97     address private _owner;
98 
99     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
100 
101     /**
102      * @dev Initializes the contract setting the deployer as the initial owner.
103      */
104     constructor () internal {
105         _owner = msg.sender;
106         emit OwnershipTransferred(address(0), _owner);
107     }
108 
109     /**
110      * @dev Returns the address of the current owner.
111      */
112     function owner() public view returns (address) {
113         return _owner;
114     }
115 
116     /**
117      * @dev Throws if called by any account other than the owner.
118      */
119     modifier onlyOwner() {
120         require(isOwner(), "Ownable: caller is not the owner");
121         _;
122     }
123 
124     /**
125      * @dev Returns true if the caller is the current owner.
126      */
127     function isOwner() public view returns (bool) {
128         return msg.sender == _owner;
129     }
130 
131     /**
132      * @dev Leaves the contract without owner. It will not be possible to call
133      * `onlyOwner` functions anymore. Can only be called by the current owner.
134      *
135      * > Note: Renouncing ownership will leave the contract without an owner,
136      * thereby removing any functionality that is only available to the owner.
137      */
138     function renounceOwnership() public onlyOwner {
139         emit OwnershipTransferred(_owner, address(0));
140         _owner = address(0);
141     }
142 
143     /**
144      * @dev Transfers ownership of the contract to a new account (`newOwner`).
145      * Can only be called by the current owner.
146      */
147     function transferOwnership(address newOwner) public onlyOwner {
148         _transferOwnership(newOwner);
149     }
150 
151     /**
152      * @dev Transfers ownership of the contract to a new account (`newOwner`).
153      */
154     function _transferOwnership(address newOwner) internal {
155         require(newOwner != address(0), "Ownable: new owner is the zero address");
156         emit OwnershipTransferred(_owner, newOwner);
157         _owner = newOwner;
158     }
159 }
160 
161 /**
162  * @dev Wrappers over Solidity's arithmetic operations with added overflow
163  * checks.
164  *
165  * Arithmetic operations in Solidity wrap on overflow. This can easily result
166  * in bugs, because programmers usually assume that an overflow raises an
167  * error, which is the standard behavior in high level programming languages.
168  * `SafeMath` restores this intuition by reverting the transaction when an
169  * operation overflows.
170  *
171  * Using this library instead of the unchecked operations eliminates an entire
172  * class of bugs, so it's recommended to use it always.
173  */
174 library SafeMath {
175     /**
176      * @dev Returns the addition of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `+` operator.
180      *
181      * Requirements:
182      * - Addition cannot overflow.
183      */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;
186         require(c >= a, "SafeMath: addition overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201         require(b <= a, "SafeMath: subtraction overflow");
202         uint256 c = a - b;
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the multiplication of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `*` operator.
212      *
213      * Requirements:
214      * - Multiplication cannot overflow.
215      */
216     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
217         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
218         // benefit is lost if 'b' is also tested.
219         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
220         if (a == 0) {
221             return 0;
222         }
223 
224         uint256 c = a * b;
225         require(c / a == b, "SafeMath: multiplication overflow");
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the integer division of two unsigned integers. Reverts on
232      * division by zero. The result is rounded towards zero.
233      *
234      * Counterpart to Solidity's `/` operator. Note: this function uses a
235      * `revert` opcode (which leaves remaining gas untouched) while Solidity
236      * uses an invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      * - The divisor cannot be zero.
240      */
241     function div(uint256 a, uint256 b) internal pure returns (uint256) {
242         // Solidity only automatically asserts when dividing by 0
243         require(b > 0, "SafeMath: division by zero");
244         uint256 c = a / b;
245         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b != 0, "SafeMath: modulo by zero");
263         return a % b;
264     }
265 }
266 
267 /**
268  * @dev Standard math utilities missing in the Solidity language.
269  */
270 library Math {
271     /**
272      * @dev Returns the largest of two numbers.
273      */
274     function max(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a >= b ? a : b;
276     }
277 
278     /**
279      * @dev Returns the smallest of two numbers.
280      */
281     function min(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a < b ? a : b;
283     }
284 
285     /**
286      * @dev Returns the average of two numbers. The result is rounded towards
287      * zero.
288      */
289     function average(uint256 a, uint256 b) internal pure returns (uint256) {
290         // (a + b) / 2 can overflow, so we distribute
291         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
292     }
293 }
294 
295 /**
296  * @dev Optional functions from the ERC20 standard.
297  */
298 contract ERC20Detailed is IERC20 {
299     string private _name;
300     string private _symbol;
301     uint8 private _decimals;
302 
303     /**
304      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
305      * these values are immutable: they can only be set once during
306      * construction.
307      */
308     constructor (string memory name, string memory symbol, uint8 decimals) public {
309         _name = name;
310         _symbol = symbol;
311         _decimals = decimals;
312     }
313 
314     /**
315      * @dev Returns the name of the token.
316      */
317     function name() public view returns (string memory) {
318         return _name;
319     }
320 
321     /**
322      * @dev Returns the symbol of the token, usually a shorter version of the
323      * name.
324      */
325     function symbol() public view returns (string memory) {
326         return _symbol;
327     }
328 
329     /**
330      * @dev Returns the number of decimals used to get its user representation.
331      * For example, if `decimals` equals `2`, a balance of `505` tokens should
332      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
333      *
334      * Tokens usually opt for a value of 18, imitating the relationship between
335      * Ether and Wei.
336      *
337      * > Note that this information is only used for _display_ purposes: it in
338      * no way affects any of the arithmetic of the contract, including
339      * `IERC20.balanceOf` and `IERC20.transfer`.
340      */
341     function decimals() public view returns (uint8) {
342         return _decimals;
343     }
344 }
345 
346 /**
347  * @dev Collection of functions related to the address type,
348  */
349 library Address {
350     /**
351      * @dev Returns true if `account` is a contract.
352      *
353      * This test is non-exhaustive, and there may be false-negatives: during the
354      * execution of a contract's constructor, its address will be reported as
355      * not containing a contract.
356      *
357      * > It is unsafe to assume that an address for which this function returns
358      * false is an externally-owned account (EOA) and not a contract.
359      */
360     function isContract(address account) internal view returns (bool) {
361         // This method relies in extcodesize, which returns 0 for contracts in
362         // construction, since the code is only stored at the end of the
363         // constructor execution.
364 
365         uint256 size;
366         // solhint-disable-next-line no-inline-assembly
367         assembly { size := extcodesize(account) }
368         return size > 0;
369     }
370 }
371 
372 /**
373  * @title SafeERC20
374  * @dev Wrappers around ERC20 operations that throw on failure (when the token
375  * contract returns false). Tokens that return no value (and instead revert or
376  * throw on failure) are also supported, non-reverting calls are assumed to be
377  * successful.
378  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
379  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
380  */
381 library SafeERC20 {
382     using SafeMath for uint256;
383     using Address for address;
384 
385     function safeTransfer(IERC20 token, address to, uint256 value) internal {
386         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
387     }
388 
389     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
390         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
391     }
392 
393     function safeApprove(IERC20 token, address spender, uint256 value) internal {
394         // safeApprove should only be called when setting an initial allowance,
395         // or when resetting it to zero. To increase and decrease it, use
396         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
397         // solhint-disable-next-line max-line-length
398         require((value == 0) || (token.allowance(address(this), spender) == 0),
399             "SafeERC20: approve from non-zero to non-zero allowance"
400         );
401         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
402     }
403 
404     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
405         uint256 newAllowance = token.allowance(address(this), spender).add(value);
406         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
407     }
408 
409     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
410         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
411         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
412     }
413 
414     /**
415      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
416      * on the return value: the return value is optional (but if data is returned, it must not be false).
417      * @param token The token targeted by the call.
418      * @param data The call data (encoded using abi.encode or one of its variants).
419      */
420     function callOptionalReturn(IERC20 token, bytes memory data) private {
421         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
422         // we're implementing it ourselves.
423 
424         // A Solidity high level call has three parts:
425         //  1. The target address is checked to verify it contains contract code
426         //  2. The call itself is made, and success asserted
427         //  3. The return value is decoded, which in turn checks the size of the returned data.
428         // solhint-disable-next-line max-line-length
429         require(address(token).isContract(), "SafeERC20: call to non-contract");
430 
431         // solhint-disable-next-line avoid-low-level-calls
432         (bool success, bytes memory returndata) = address(token).call(data);
433         require(success, "SafeERC20: low-level call failed");
434 
435         if (returndata.length > 0) { // Return data is optional
436             // solhint-disable-next-line max-line-length
437             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
438         }
439     }
440 }
441 
442 /**
443  * @dev Contract module that helps prevent reentrant calls to a function.
444  *
445  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
446  * available, which can be aplied to functions to make sure there are no nested
447  * (reentrant) calls to them.
448  *
449  * Note that because there is a single `nonReentrant` guard, functions marked as
450  * `nonReentrant` may not call one another. This can be worked around by making
451  * those functions `private`, and then adding `external` `nonReentrant` entry
452  * points to them.
453  */
454 contract ReentrancyGuard {
455     /// @dev counter to allow mutex lock with only one SSTORE operation
456     uint256 private _guardCounter;
457 
458     constructor () internal {
459         // The counter starts at one to prevent changing it from zero to a non-zero
460         // value, which is a more expensive operation.
461         _guardCounter = 1;
462     }
463 
464     /**
465      * @dev Prevents a contract from calling itself, directly or indirectly.
466      * Calling a `nonReentrant` function from another `nonReentrant`
467      * function is not supported. It is possible to prevent this from happening
468      * by making the `nonReentrant` function external, and make it call a
469      * `private` function that does the actual work.
470      */
471     modifier nonReentrant() {
472         _guardCounter += 1;
473         uint256 localCounter = _guardCounter;
474         _;
475         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
476     }
477 }
478 
479 // Inheritance
480 interface IStakingRewards {
481     // Views
482     function lastTimeRewardApplicable() external view returns (uint256);
483 
484     function rewardPerToken() external view returns (uint256);
485 
486     function earned(address account) external view returns (uint256);
487 
488     function getRewardForDuration() external view returns (uint256);
489 
490     function totalSupply() external view returns (uint256);
491 
492     function balanceOf(address account) external view returns (uint256);
493 
494     // Mutative
495 
496     function stake(uint256 amount) external;
497 
498     function withdraw(uint256 amount) external;
499 
500     function getReward() external;
501 
502     function exit() external;
503 }
504 
505 contract RewardsDistributionRecipient {
506     address public rewardsDistribution;
507 
508     function notifyRewardAmount(uint256 reward) external;
509 
510     modifier onlyRewardsDistribution() {
511         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
512         _;
513     }
514 }
515 
516 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
517     using SafeMath for uint256;
518     using SafeERC20 for IERC20;
519 
520     /* ========== STATE VARIABLES ========== */
521 
522     IERC20 public rewardsToken;
523     IERC20 public stakingToken;
524     uint256 public periodFinish = 0;
525     uint256 public rewardRate = 0;
526     uint256 public rewardsDuration = 60 days;
527     uint256 public lastUpdateTime;
528     uint256 public rewardPerTokenStored;
529 
530     mapping(address => uint256) public userRewardPerTokenPaid;
531     mapping(address => uint256) public rewards;
532 
533     uint256 private _totalSupply;
534     mapping(address => uint256) private _balances;
535 
536     /* ========== CONSTRUCTOR ========== */
537 
538     constructor(
539         address _rewardsDistribution,
540         address _rewardsToken,
541         address _stakingToken
542     ) public {
543         rewardsToken = IERC20(_rewardsToken);
544         stakingToken = IERC20(_stakingToken);
545         rewardsDistribution = _rewardsDistribution;
546     }
547 
548     /* ========== VIEWS ========== */
549 
550     function totalSupply() external view returns (uint256) {
551         return _totalSupply;
552     }
553 
554     function balanceOf(address account) external view returns (uint256) {
555         return _balances[account];
556     }
557 
558     function lastTimeRewardApplicable() public view returns (uint256) {
559         return Math.min(block.timestamp, periodFinish);
560     }
561 
562     function rewardPerToken() public view returns (uint256) {
563         if (_totalSupply == 0) {
564             return rewardPerTokenStored;
565         }
566         return
567             rewardPerTokenStored.add(
568                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
569             );
570     }
571 
572     function earned(address account) public view returns (uint256) {
573         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
574     }
575 
576     function getRewardForDuration() external view returns (uint256) {
577         return rewardRate.mul(rewardsDuration);
578     }
579 
580     /* ========== MUTATIVE FUNCTIONS ========== */
581 
582     // not using stake with permit or uniswap tokens 
583 
584     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
585         require(amount > 0, "Cannot stake 0");
586         _totalSupply = _totalSupply.add(amount);
587         _balances[msg.sender] = _balances[msg.sender].add(amount);
588 
589         // permit
590         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
591 
592         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
593         emit Staked(msg.sender, amount);
594     }
595 
596     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
597         require(amount > 0, "Cannot stake 0");
598         _totalSupply = _totalSupply.add(amount);
599         _balances[msg.sender] = _balances[msg.sender].add(amount);
600         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
601         emit Staked(msg.sender, amount);
602     }
603 
604     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
605         require(amount > 0, "Cannot withdraw 0");
606         _totalSupply = _totalSupply.sub(amount);
607         _balances[msg.sender] = _balances[msg.sender].sub(amount);
608         stakingToken.safeTransfer(msg.sender, amount);
609         emit Withdrawn(msg.sender, amount);
610     }
611 
612     function getReward() public nonReentrant updateReward(msg.sender) {
613         uint256 reward = rewards[msg.sender];
614         if (reward > 0) {
615             rewards[msg.sender] = 0;
616             rewardsToken.safeTransfer(msg.sender, reward);
617             emit RewardPaid(msg.sender, reward);
618         }
619     }
620 
621     function exit() external {
622         withdraw(_balances[msg.sender]);
623         getReward();
624     }
625 
626     /* ========== RESTRICTED FUNCTIONS ========== */
627 
628     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
629         if (block.timestamp >= periodFinish) {
630             rewardRate = reward.div(rewardsDuration);
631         } else {
632             uint256 remaining = periodFinish.sub(block.timestamp);
633             uint256 leftover = remaining.mul(rewardRate);
634             rewardRate = reward.add(leftover).div(rewardsDuration);
635         }
636 
637         // Ensure the provided reward amount is not more than the balance in the contract.
638         // This keeps the reward rate in the right range, preventing overflows due to
639         // very high values of rewardRate in the earned and rewardsPerToken functions;
640         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
641         uint balance = rewardsToken.balanceOf(address(this));
642         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
643 
644         lastUpdateTime = block.timestamp;
645         periodFinish = block.timestamp.add(rewardsDuration);
646         emit RewardAdded(reward);
647     }
648 
649     /* ========== MODIFIERS ========== */
650 
651     modifier updateReward(address account) {
652         rewardPerTokenStored = rewardPerToken();
653         lastUpdateTime = lastTimeRewardApplicable();
654 
655         if (account != address(0)) {
656             // bonus intial liquidity to bootstrap curve
657             if (_totalSupply == 0) {
658                 rewards[account] = rewardRate
659                     .mul(rewardsDuration)
660                     .mul(1e17)
661                     .div(1e18)
662                     .mul(2)
663                     .add(earned(account));
664 
665                 // Ensure the provided reward amount is not more than the balance in the contract.
666                 // This keeps the reward rate in the right range, preventing overflows due to
667                 // very high values of rewardRate in the earned and rewardsPerToken functions;
668                 // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
669                 uint balance = rewardsToken.balanceOf(address(this));
670                 require(rewards[account] <= balance, "Provided reward too high");
671             }
672             rewards[account] = earned(account);
673 
674             userRewardPerTokenPaid[account] = rewardPerTokenStored;
675         }
676         _;
677     }
678     /* ========== EVENTS ========== */
679 
680     event RewardAdded(uint256 reward);
681     event Staked(address indexed user, uint256 amount);
682     event Withdrawn(address indexed user, uint256 amount);
683     event RewardPaid(address indexed user, uint256 reward);
684 }
685 
686 interface IUniswapV2ERC20 {
687     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
688 }