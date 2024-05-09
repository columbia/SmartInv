1 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Contract module which provides a basic access control mechanism, where
86  * there is an account (an owner) that can be granted exclusive access to
87  * specific functions.
88  *
89  * This module is used through inheritance. It will make available the modifier
90  * `onlyOwner`, which can be aplied to your functions to restrict their use to
91  * the owner.
92  */
93 contract Ownable {
94     address private _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     /**
99      * @dev Initializes the contract setting the deployer as the initial owner.
100      */
101     constructor () internal {
102         _owner = msg.sender;
103         emit OwnershipTransferred(address(0), _owner);
104     }
105 
106     /**
107      * @dev Returns the address of the current owner.
108      */
109     function owner() public view returns (address) {
110         return _owner;
111     }
112 
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         require(isOwner(), "Ownable: caller is not the owner");
118         _;
119     }
120 
121     /**
122      * @dev Returns true if the caller is the current owner.
123      */
124     function isOwner() public view returns (bool) {
125         return msg.sender == _owner;
126     }
127 
128     /**
129      * @dev Leaves the contract without owner. It will not be possible to call
130      * `onlyOwner` functions anymore. Can only be called by the current owner.
131      *
132      * > Note: Renouncing ownership will leave the contract without an owner,
133      * thereby removing any functionality that is only available to the owner.
134      */
135     function renounceOwnership() public onlyOwner {
136         emit OwnershipTransferred(_owner, address(0));
137         _owner = address(0);
138     }
139 
140     /**
141      * @dev Transfers ownership of the contract to a new account (`newOwner`).
142      * Can only be called by the current owner.
143      */
144     function transferOwnership(address newOwner) public onlyOwner {
145         _transferOwnership(newOwner);
146     }
147 
148     /**
149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
150      */
151     function _transferOwnership(address newOwner) internal {
152         require(newOwner != address(0), "Ownable: new owner is the zero address");
153         emit OwnershipTransferred(_owner, newOwner);
154         _owner = newOwner;
155     }
156 }
157 
158 // File: openzeppelin-solidity-2.3.0/contracts/math/Math.sol
159 
160 pragma solidity ^0.5.0;
161 
162 /**
163  * @dev Standard math utilities missing in the Solidity language.
164  */
165 library Math {
166     /**
167      * @dev Returns the largest of two numbers.
168      */
169     function max(uint256 a, uint256 b) internal pure returns (uint256) {
170         return a >= b ? a : b;
171     }
172 
173     /**
174      * @dev Returns the smallest of two numbers.
175      */
176     function min(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a < b ? a : b;
178     }
179 
180     /**
181      * @dev Returns the average of two numbers. The result is rounded towards
182      * zero.
183      */
184     function average(uint256 a, uint256 b) internal pure returns (uint256) {
185         // (a + b) / 2 can overflow, so we distribute
186         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
187     }
188 }
189 
190 // File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * @dev Wrappers over Solidity's arithmetic operations with added overflow
196  * checks.
197  *
198  * Arithmetic operations in Solidity wrap on overflow. This can easily result
199  * in bugs, because programmers usually assume that an overflow raises an
200  * error, which is the standard behavior in high level programming languages.
201  * `SafeMath` restores this intuition by reverting the transaction when an
202  * operation overflows.
203  *
204  * Using this library instead of the unchecked operations eliminates an entire
205  * class of bugs, so it's recommended to use it always.
206  */
207 library SafeMath {
208     /**
209      * @dev Returns the addition of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `+` operator.
213      *
214      * Requirements:
215      * - Addition cannot overflow.
216      */
217     function add(uint256 a, uint256 b) internal pure returns (uint256) {
218         uint256 c = a + b;
219         require(c >= a, "SafeMath: addition overflow");
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting on
226      * overflow (when the result is negative).
227      *
228      * Counterpart to Solidity's `-` operator.
229      *
230      * Requirements:
231      * - Subtraction cannot overflow.
232      */
233     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
234         require(b <= a, "SafeMath: subtraction overflow");
235         uint256 c = a - b;
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the multiplication of two unsigned integers, reverting on
242      * overflow.
243      *
244      * Counterpart to Solidity's `*` operator.
245      *
246      * Requirements:
247      * - Multiplication cannot overflow.
248      */
249     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
250         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
251         // benefit is lost if 'b' is also tested.
252         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
253         if (a == 0) {
254             return 0;
255         }
256 
257         uint256 c = a * b;
258         require(c / a == b, "SafeMath: multiplication overflow");
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the integer division of two unsigned integers. Reverts on
265      * division by zero. The result is rounded towards zero.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      * - The divisor cannot be zero.
273      */
274     function div(uint256 a, uint256 b) internal pure returns (uint256) {
275         // Solidity only automatically asserts when dividing by 0
276         require(b > 0, "SafeMath: division by zero");
277         uint256 c = a / b;
278         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
279 
280         return c;
281     }
282 
283     /**
284      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
285      * Reverts when dividing by zero.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      * - The divisor cannot be zero.
293      */
294     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
295         require(b != 0, "SafeMath: modulo by zero");
296         return a % b;
297     }
298 }
299 
300 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20Detailed.sol
301 
302 pragma solidity ^0.5.0;
303 
304 
305 /**
306  * @dev Optional functions from the ERC20 standard.
307  */
308 contract ERC20Detailed is IERC20 {
309     string private _name;
310     string private _symbol;
311     uint8 private _decimals;
312 
313     /**
314      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
315      * these values are immutable: they can only be set once during
316      * construction.
317      */
318     constructor (string memory name, string memory symbol, uint8 decimals) public {
319         _name = name;
320         _symbol = symbol;
321         _decimals = decimals;
322     }
323 
324     /**
325      * @dev Returns the name of the token.
326      */
327     function name() public view returns (string memory) {
328         return _name;
329     }
330 
331     /**
332      * @dev Returns the symbol of the token, usually a shorter version of the
333      * name.
334      */
335     function symbol() public view returns (string memory) {
336         return _symbol;
337     }
338 
339     /**
340      * @dev Returns the number of decimals used to get its user representation.
341      * For example, if `decimals` equals `2`, a balance of `505` tokens should
342      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
343      *
344      * Tokens usually opt for a value of 18, imitating the relationship between
345      * Ether and Wei.
346      *
347      * > Note that this information is only used for _display_ purposes: it in
348      * no way affects any of the arithmetic of the contract, including
349      * `IERC20.balanceOf` and `IERC20.transfer`.
350      */
351     function decimals() public view returns (uint8) {
352         return _decimals;
353     }
354 }
355 
356 // File: openzeppelin-solidity-2.3.0/contracts/utils/Address.sol
357 
358 pragma solidity ^0.5.0;
359 
360 /**
361  * @dev Collection of functions related to the address type,
362  */
363 library Address {
364     /**
365      * @dev Returns true if `account` is a contract.
366      *
367      * This test is non-exhaustive, and there may be false-negatives: during the
368      * execution of a contract's constructor, its address will be reported as
369      * not containing a contract.
370      *
371      * > It is unsafe to assume that an address for which this function returns
372      * false is an externally-owned account (EOA) and not a contract.
373      */
374     function isContract(address account) internal view returns (bool) {
375         // This method relies in extcodesize, which returns 0 for contracts in
376         // construction, since the code is only stored at the end of the
377         // constructor execution.
378 
379         uint256 size;
380         // solhint-disable-next-line no-inline-assembly
381         assembly { size := extcodesize(account) }
382         return size > 0;
383     }
384 }
385 
386 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/SafeERC20.sol
387 
388 pragma solidity ^0.5.0;
389 
390 
391 
392 
393 /**
394  * @title SafeERC20
395  * @dev Wrappers around ERC20 operations that throw on failure (when the token
396  * contract returns false). Tokens that return no value (and instead revert or
397  * throw on failure) are also supported, non-reverting calls are assumed to be
398  * successful.
399  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
400  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
401  */
402 library SafeERC20 {
403     using SafeMath for uint256;
404     using Address for address;
405 
406     function safeTransfer(IERC20 token, address to, uint256 value) internal {
407         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
408     }
409 
410     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
411         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
412     }
413 
414     function safeApprove(IERC20 token, address spender, uint256 value) internal {
415         // safeApprove should only be called when setting an initial allowance,
416         // or when resetting it to zero. To increase and decrease it, use
417         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
418         // solhint-disable-next-line max-line-length
419         require((value == 0) || (token.allowance(address(this), spender) == 0),
420             "SafeERC20: approve from non-zero to non-zero allowance"
421         );
422         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
423     }
424 
425     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
426         uint256 newAllowance = token.allowance(address(this), spender).add(value);
427         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
428     }
429 
430     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
431         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
432         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
433     }
434 
435     /**
436      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
437      * on the return value: the return value is optional (but if data is returned, it must not be false).
438      * @param token The token targeted by the call.
439      * @param data The call data (encoded using abi.encode or one of its variants).
440      */
441     function callOptionalReturn(IERC20 token, bytes memory data) private {
442         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
443         // we're implementing it ourselves.
444 
445         // A Solidity high level call has three parts:
446         //  1. The target address is checked to verify it contains contract code
447         //  2. The call itself is made, and success asserted
448         //  3. The return value is decoded, which in turn checks the size of the returned data.
449         // solhint-disable-next-line max-line-length
450         require(address(token).isContract(), "SafeERC20: call to non-contract");
451 
452         // solhint-disable-next-line avoid-low-level-calls
453         (bool success, bytes memory returndata) = address(token).call(data);
454         require(success, "SafeERC20: low-level call failed");
455 
456         if (returndata.length > 0) { // Return data is optional
457             // solhint-disable-next-line max-line-length
458             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
459         }
460     }
461 }
462 
463 // File: openzeppelin-solidity-2.3.0/contracts/utils/ReentrancyGuard.sol
464 
465 pragma solidity ^0.5.0;
466 
467 /**
468  * @dev Contract module that helps prevent reentrant calls to a function.
469  *
470  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
471  * available, which can be aplied to functions to make sure there are no nested
472  * (reentrant) calls to them.
473  *
474  * Note that because there is a single `nonReentrant` guard, functions marked as
475  * `nonReentrant` may not call one another. This can be worked around by making
476  * those functions `private`, and then adding `external` `nonReentrant` entry
477  * points to them.
478  */
479 contract ReentrancyGuard {
480     /// @dev counter to allow mutex lock with only one SSTORE operation
481     uint256 private _guardCounter;
482 
483     constructor () internal {
484         // The counter starts at one to prevent changing it from zero to a non-zero
485         // value, which is a more expensive operation.
486         _guardCounter = 1;
487     }
488 
489     /**
490      * @dev Prevents a contract from calling itself, directly or indirectly.
491      * Calling a `nonReentrant` function from another `nonReentrant`
492      * function is not supported. It is possible to prevent this from happening
493      * by making the `nonReentrant` function external, and make it call a
494      * `private` function that does the actual work.
495      */
496     modifier nonReentrant() {
497         _guardCounter += 1;
498         uint256 localCounter = _guardCounter;
499         _;
500         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
501     }
502 }
503 
504 // File: contracts/interfaces/IStakingRewards.sol
505 
506 pragma solidity >=0.4.24;
507 
508 
509 interface IStakingRewards {
510     // Views
511     function lastTimeRewardApplicable() external view returns (uint256);
512 
513     function rewardPerToken() external view returns (uint256);
514 
515     function earned(address account) external view returns (uint256);
516 
517     function getRewardForDuration() external view returns (uint256);
518 
519     function totalSupply() external view returns (uint256);
520 
521     function balanceOf(address account) external view returns (uint256);
522 
523     // Mutative
524 
525     function stake(uint256 amount) external;
526 
527     function withdraw(uint256 amount) external;
528 
529     function getReward() external;
530 
531     function exit() external;
532 }
533 
534 // File: contracts/RewardsDistributionRecipient.sol
535 
536 pragma solidity ^0.5.16;
537 
538 contract RewardsDistributionRecipient {
539     address public rewardsDistribution;
540 
541     function notifyRewardAmount(uint256 reward) external;
542 
543     modifier onlyRewardsDistribution() {
544         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
545         _;
546     }
547 }
548 
549 // File: contracts/StakingRewards.sol
550 
551 pragma solidity ^0.5.16;
552 
553 
554 
555 
556 
557 
558 // Inheritance
559 
560 
561 
562 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
563     using SafeMath for uint256;
564     using SafeERC20 for IERC20;
565 
566     /* ========== STATE VARIABLES ========== */
567 
568     IERC20 public rewardsToken;
569     IERC20 public stakingToken;
570     uint256 public periodFinish = 0;
571     uint256 public rewardRate = 0;
572     uint256 public rewardsDuration = 84 days;
573     uint256 public lastUpdateTime;
574     uint256 public rewardPerTokenStored;
575 
576     mapping(address => uint256) public userRewardPerTokenPaid;
577     mapping(address => uint256) public rewards;
578 
579     uint256 private _totalSupply;
580     mapping(address => uint256) private _balances;
581 
582     /* ========== CONSTRUCTOR ========== */
583 
584     constructor(
585         address _rewardsDistribution,
586         address _rewardsToken,
587         address _stakingToken
588     ) public {
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
605         return Math.min(block.timestamp, periodFinish);
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
628     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
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
681     /* ========== MODIFIERS ========== */
682 
683     modifier updateReward(address account) {
684         rewardPerTokenStored = rewardPerToken();
685         lastUpdateTime = lastTimeRewardApplicable();
686         if (account != address(0)) {
687             rewards[account] = earned(account);
688             userRewardPerTokenPaid[account] = rewardPerTokenStored;
689         }
690         _;
691     }
692 
693     /* ========== EVENTS ========== */
694 
695     event RewardAdded(uint256 reward);
696     event Staked(address indexed user, uint256 amount);
697     event Withdrawn(address indexed user, uint256 amount);
698     event RewardPaid(address indexed user, uint256 reward);
699 }
700 
701 // File: contracts/StakingRewardsFactory.sol
702 
703 pragma solidity ^0.5.16;
704 
705 
706 
707 
708 contract StakingRewardsFactory is Ownable {
709     // immutables
710     address public rewardsToken;
711     uint public stakingRewardsGenesis;
712 
713     // the staking tokens for which the rewards contract has been deployed
714     address[] public stakingTokens;
715 
716     // info about rewards for a particular staking token
717     struct StakingRewardsInfo {
718         address stakingRewards;
719         uint rewardAmount;
720     }
721 
722     // rewards info by staking token
723     mapping(address => StakingRewardsInfo) public stakingRewardsInfoByStakingToken;
724 
725     constructor(
726         address _rewardsToken,
727         uint _stakingRewardsGenesis
728     ) Ownable() public {
729         require(_stakingRewardsGenesis >= block.timestamp, 'StakingRewardsFactory::constructor: genesis too soon');
730 
731         rewardsToken = _rewardsToken;
732         stakingRewardsGenesis = _stakingRewardsGenesis;
733     }
734 
735     ///// permissioned functions
736 
737     // deploy a staking reward contract for the staking token, and store the reward amount
738     // the reward will be distributed to the staking reward contract no sooner than the genesis
739     function deploy(address stakingToken, uint rewardAmount) public onlyOwner {
740         StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[stakingToken];
741         require(info.stakingRewards == address(0), 'StakingRewardsFactory::deploy: already deployed');
742 
743         info.stakingRewards = address(new StakingRewards(/*_rewardsDistribution=*/ address(this), rewardsToken, stakingToken));
744         info.rewardAmount = rewardAmount;
745         stakingTokens.push(stakingToken);
746     }
747 
748     ///// permissionless functions
749 
750     // call notifyRewardAmount for all staking tokens.
751     function notifyRewardAmounts() public {
752         require(stakingTokens.length > 0, 'StakingRewardsFactory::notifyRewardAmounts: called before any deploys');
753         for (uint i = 0; i < stakingTokens.length; i++) {
754             notifyRewardAmount(stakingTokens[i]);
755         }
756     }
757 
758     // notify reward amount for an individual staking token.
759     // this is a fallback in case the notifyRewardAmounts costs too much gas to call for all contracts
760     function notifyRewardAmount(address stakingToken) public {
761         require(block.timestamp >= stakingRewardsGenesis, 'StakingRewardsFactory::notifyRewardAmount: not ready');
762 
763         StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[stakingToken];
764         require(info.stakingRewards != address(0), 'StakingRewardsFactory::notifyRewardAmount: not deployed');
765 
766         if (info.rewardAmount > 0) {
767             uint rewardAmount = info.rewardAmount;
768             info.rewardAmount = 0;
769 
770             require(
771                 IERC20(rewardsToken).transfer(info.stakingRewards, rewardAmount),
772                 'StakingRewardsFactory::notifyRewardAmount: transfer failed'
773             );
774             StakingRewards(info.stakingRewards).notifyRewardAmount(rewardAmount);
775         }
776     }
777 }