1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-29
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-03-08
7 */
8 
9 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/IERC20.sol
10 
11 pragma solidity ^0.5.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
15  * the optional functions; to access them see `ERC20Detailed`.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a `Transfer` event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through `transferFrom`. This is
40      * zero by default.
41      *
42      * This value changes when `approve` or `transferFrom` are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * > Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an `Approval` event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a `Transfer` event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to `approve`. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 // File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol
89 
90 pragma solidity ^0.5.0;
91 
92 /**
93  * @dev Contract module which provides a basic access control mechanism, where
94  * there is an account (an owner) that can be granted exclusive access to
95  * specific functions.
96  *
97  * This module is used through inheritance. It will make available the modifier
98  * `onlyOwner`, which can be aplied to your functions to restrict their use to
99  * the owner.
100  */
101 contract Ownable {
102     address private _owner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     /**
107      * @dev Initializes the contract setting the deployer as the initial owner.
108      */
109     constructor () internal {
110         _owner = msg.sender;
111         emit OwnershipTransferred(address(0), _owner);
112     }
113 
114     /**
115      * @dev Returns the address of the current owner.
116      */
117     function owner() public view returns (address) {
118         return _owner;
119     }
120 
121     /**
122      * @dev Throws if called by any account other than the owner.
123      */
124     modifier onlyOwner() {
125         require(isOwner(), "Ownable: caller is not the owner");
126         _;
127     }
128 
129     /**
130      * @dev Returns true if the caller is the current owner.
131      */
132     function isOwner() public view returns (bool) {
133         return msg.sender == _owner;
134     }
135 
136     /**
137      * @dev Leaves the contract without owner. It will not be possible to call
138      * `onlyOwner` functions anymore. Can only be called by the current owner.
139      *
140      * > Note: Renouncing ownership will leave the contract without an owner,
141      * thereby removing any functionality that is only available to the owner.
142      */
143     function renounceOwnership() public onlyOwner {
144         emit OwnershipTransferred(_owner, address(0));
145         _owner = address(0);
146     }
147 
148     /**
149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
150      * Can only be called by the current owner.
151      */
152     function transferOwnership(address newOwner) public onlyOwner {
153         _transferOwnership(newOwner);
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      */
159     function _transferOwnership(address newOwner) internal {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         emit OwnershipTransferred(_owner, newOwner);
162         _owner = newOwner;
163     }
164 }
165 
166 // File: openzeppelin-solidity-2.3.0/contracts/math/Math.sol
167 
168 pragma solidity ^0.5.0;
169 
170 /**
171  * @dev Standard math utilities missing in the Solidity language.
172  */
173 library Math {
174     /**
175      * @dev Returns the largest of two numbers.
176      */
177     function max(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a >= b ? a : b;
179     }
180 
181     /**
182      * @dev Returns the smallest of two numbers.
183      */
184     function min(uint256 a, uint256 b) internal pure returns (uint256) {
185         return a < b ? a : b;
186     }
187 
188     /**
189      * @dev Returns the average of two numbers. The result is rounded towards
190      * zero.
191      */
192     function average(uint256 a, uint256 b) internal pure returns (uint256) {
193         // (a + b) / 2 can overflow, so we distribute
194         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
195     }
196 }
197 
198 // File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol
199 
200 pragma solidity ^0.5.0;
201 
202 /**
203  * @dev Wrappers over Solidity's arithmetic operations with added overflow
204  * checks.
205  *
206  * Arithmetic operations in Solidity wrap on overflow. This can easily result
207  * in bugs, because programmers usually assume that an overflow raises an
208  * error, which is the standard behavior in high level programming languages.
209  * `SafeMath` restores this intuition by reverting the transaction when an
210  * operation overflows.
211  *
212  * Using this library instead of the unchecked operations eliminates an entire
213  * class of bugs, so it's recommended to use it always.
214  */
215 library SafeMath {
216     /**
217      * @dev Returns the addition of two unsigned integers, reverting on
218      * overflow.
219      *
220      * Counterpart to Solidity's `+` operator.
221      *
222      * Requirements:
223      * - Addition cannot overflow.
224      */
225     function add(uint256 a, uint256 b) internal pure returns (uint256) {
226         uint256 c = a + b;
227         require(c >= a, "SafeMath: addition overflow");
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      * - Subtraction cannot overflow.
240      */
241     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242         require(b <= a, "SafeMath: subtraction overflow");
243         uint256 c = a - b;
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the multiplication of two unsigned integers, reverting on
250      * overflow.
251      *
252      * Counterpart to Solidity's `*` operator.
253      *
254      * Requirements:
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
259         // benefit is lost if 'b' is also tested.
260         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
261         if (a == 0) {
262             return 0;
263         }
264 
265         uint256 c = a * b;
266         require(c / a == b, "SafeMath: multiplication overflow");
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         // Solidity only automatically asserts when dividing by 0
284         require(b > 0, "SafeMath: division by zero");
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      */
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         require(b != 0, "SafeMath: modulo by zero");
304         return a % b;
305     }
306 }
307 
308 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20Detailed.sol
309 
310 pragma solidity ^0.5.0;
311 
312 
313 /**
314  * @dev Optional functions from the ERC20 standard.
315  */
316 contract ERC20Detailed is IERC20 {
317     string private _name;
318     string private _symbol;
319     uint8 private _decimals;
320 
321     /**
322      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
323      * these values are immutable: they can only be set once during
324      * construction.
325      */
326     constructor (string memory name, string memory symbol, uint8 decimals) public {
327         _name = name;
328         _symbol = symbol;
329         _decimals = decimals;
330     }
331 
332     /**
333      * @dev Returns the name of the token.
334      */
335     function name() public view returns (string memory) {
336         return _name;
337     }
338 
339     /**
340      * @dev Returns the symbol of the token, usually a shorter version of the
341      * name.
342      */
343     function symbol() public view returns (string memory) {
344         return _symbol;
345     }
346 
347     /**
348      * @dev Returns the number of decimals used to get its user representation.
349      * For example, if `decimals` equals `2`, a balance of `505` tokens should
350      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
351      *
352      * Tokens usually opt for a value of 18, imitating the relationship between
353      * Ether and Wei.
354      *
355      * > Note that this information is only used for _display_ purposes: it in
356      * no way affects any of the arithmetic of the contract, including
357      * `IERC20.balanceOf` and `IERC20.transfer`.
358      */
359     function decimals() public view returns (uint8) {
360         return _decimals;
361     }
362 }
363 
364 // File: openzeppelin-solidity-2.3.0/contracts/utils/Address.sol
365 
366 pragma solidity ^0.5.0;
367 
368 /**
369  * @dev Collection of functions related to the address type,
370  */
371 library Address {
372     /**
373      * @dev Returns true if `account` is a contract.
374      *
375      * This test is non-exhaustive, and there may be false-negatives: during the
376      * execution of a contract's constructor, its address will be reported as
377      * not containing a contract.
378      *
379      * > It is unsafe to assume that an address for which this function returns
380      * false is an externally-owned account (EOA) and not a contract.
381      */
382     function isContract(address account) internal view returns (bool) {
383         // This method relies in extcodesize, which returns 0 for contracts in
384         // construction, since the code is only stored at the end of the
385         // constructor execution.
386 
387         uint256 size;
388         // solhint-disable-next-line no-inline-assembly
389         assembly { size := extcodesize(account) }
390         return size > 0;
391     }
392 }
393 
394 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/SafeERC20.sol
395 
396 pragma solidity ^0.5.0;
397 
398 
399 
400 
401 /**
402  * @title SafeERC20
403  * @dev Wrappers around ERC20 operations that throw on failure (when the token
404  * contract returns false). Tokens that return no value (and instead revert or
405  * throw on failure) are also supported, non-reverting calls are assumed to be
406  * successful.
407  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
408  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
409  */
410 library SafeERC20 {
411     using SafeMath for uint256;
412     using Address for address;
413 
414     function safeTransfer(IERC20 token, address to, uint256 value) internal {
415         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
416     }
417 
418     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
419         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
420     }
421 
422     function safeApprove(IERC20 token, address spender, uint256 value) internal {
423         // safeApprove should only be called when setting an initial allowance,
424         // or when resetting it to zero. To increase and decrease it, use
425         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
426         // solhint-disable-next-line max-line-length
427         require((value == 0) || (token.allowance(address(this), spender) == 0),
428             "SafeERC20: approve from non-zero to non-zero allowance"
429         );
430         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
431     }
432 
433     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
434         uint256 newAllowance = token.allowance(address(this), spender).add(value);
435         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
436     }
437 
438     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
439         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
440         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
441     }
442 
443     /**
444      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
445      * on the return value: the return value is optional (but if data is returned, it must not be false).
446      * @param token The token targeted by the call.
447      * @param data The call data (encoded using abi.encode or one of its variants).
448      */
449     function callOptionalReturn(IERC20 token, bytes memory data) private {
450         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
451         // we're implementing it ourselves.
452 
453         // A Solidity high level call has three parts:
454         //  1. The target address is checked to verify it contains contract code
455         //  2. The call itself is made, and success asserted
456         //  3. The return value is decoded, which in turn checks the size of the returned data.
457         // solhint-disable-next-line max-line-length
458         require(address(token).isContract(), "SafeERC20: call to non-contract");
459 
460         // solhint-disable-next-line avoid-low-level-calls
461         (bool success, bytes memory returndata) = address(token).call(data);
462         require(success, "SafeERC20: low-level call failed");
463 
464         if (returndata.length > 0) { // Return data is optional
465             // solhint-disable-next-line max-line-length
466             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
467         }
468     }
469 }
470 
471 // File: openzeppelin-solidity-2.3.0/contracts/utils/ReentrancyGuard.sol
472 
473 pragma solidity ^0.5.0;
474 
475 /**
476  * @dev Contract module that helps prevent reentrant calls to a function.
477  *
478  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
479  * available, which can be aplied to functions to make sure there are no nested
480  * (reentrant) calls to them.
481  *
482  * Note that because there is a single `nonReentrant` guard, functions marked as
483  * `nonReentrant` may not call one another. This can be worked around by making
484  * those functions `private`, and then adding `external` `nonReentrant` entry
485  * points to them.
486  */
487 contract ReentrancyGuard {
488     /// @dev counter to allow mutex lock with only one SSTORE operation
489     uint256 private _guardCounter;
490 
491     constructor () internal {
492         // The counter starts at one to prevent changing it from zero to a non-zero
493         // value, which is a more expensive operation.
494         _guardCounter = 1;
495     }
496 
497     /**
498      * @dev Prevents a contract from calling itself, directly or indirectly.
499      * Calling a `nonReentrant` function from another `nonReentrant`
500      * function is not supported. It is possible to prevent this from happening
501      * by making the `nonReentrant` function external, and make it call a
502      * `private` function that does the actual work.
503      */
504     modifier nonReentrant() {
505         _guardCounter += 1;
506         uint256 localCounter = _guardCounter;
507         _;
508         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
509     }
510 }
511 
512 // File: contracts/interfaces/IStakingRewards.sol
513 
514 pragma solidity >=0.4.24;
515 
516 
517 interface IStakingRewards {
518     // Views
519     function lastTimeRewardApplicable() external view returns (uint256);
520 
521     function rewardPerToken() external view returns (uint256);
522 
523     function earned(address account) external view returns (uint256);
524 
525     function getRewardForDuration() external view returns (uint256);
526 
527     function totalSupply() external view returns (uint256);
528 
529     function balanceOf(address account) external view returns (uint256);
530 
531     // Mutative
532 
533     function stake(uint256 amount) external;
534 
535     function withdraw(uint256 amount) external;
536 
537     function getReward() external;
538 
539     function exit() external;
540 }
541 
542 // File: contracts/RewardsDistributionRecipient.sol
543 
544 pragma solidity ^0.5.16;
545 
546 contract RewardsDistributionRecipient {
547     address public rewardsDistribution;
548 
549     function notifyRewardAmount(uint256 reward) external;
550 
551     modifier onlyRewardsDistribution() {
552         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
553         _;
554     }
555 }
556 
557 // File: contracts/StakingRewards.sol
558 
559 pragma solidity ^0.5.16;
560 
561 
562 
563 
564 
565 
566 // Inheritance
567 
568 
569 
570 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
571     using SafeMath for uint256;
572     using SafeERC20 for IERC20;
573 
574     /* ========== STATE VARIABLES ========== */
575 
576     IERC20 public rewardsToken;
577     IERC20 public stakingToken;
578     uint256 public periodFinish = 0;
579     uint256 public rewardRate = 0;
580     uint256 public rewardsDuration = 7 days;
581     uint256 public lastUpdateTime;
582     uint256 public rewardPerTokenStored;
583 
584     mapping(address => uint256) public userRewardPerTokenPaid;
585     mapping(address => uint256) public rewards;
586 
587     uint256 private _totalSupply;
588     mapping(address => uint256) private _balances;
589 
590     /* ========== CONSTRUCTOR ========== */
591 
592     constructor(
593         address _rewardsDistribution,
594         address _rewardsToken,
595         address _stakingToken
596     ) public {
597         rewardsToken = IERC20(_rewardsToken);
598         stakingToken = IERC20(_stakingToken);
599         rewardsDistribution = _rewardsDistribution;
600     }
601 
602     /* ========== VIEWS ========== */
603 
604     function totalSupply() external view returns (uint256) {
605         return _totalSupply;
606     }
607 
608     function balanceOf(address account) external view returns (uint256) {
609         return _balances[account];
610     }
611 
612     function lastTimeRewardApplicable() public view returns (uint256) {
613         return Math.min(block.timestamp, periodFinish);
614     }
615 
616     function rewardPerToken() public view returns (uint256) {
617         if (_totalSupply == 0) {
618             return rewardPerTokenStored;
619         }
620         return
621             rewardPerTokenStored.add(
622                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
623             );
624     }
625 
626     function earned(address account) public view returns (uint256) {
627         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
628     }
629 
630     function getRewardForDuration() external view returns (uint256) {
631         return rewardRate.mul(rewardsDuration);
632     }
633 
634     /* ========== MUTATIVE FUNCTIONS ========== */
635 
636     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
637         require(amount > 0, "Cannot stake 0");
638         _totalSupply = _totalSupply.add(amount);
639         _balances[msg.sender] = _balances[msg.sender].add(amount);
640         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
641         emit Staked(msg.sender, amount);
642     }
643 
644     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
645         require(amount > 0, "Cannot withdraw 0");
646         _totalSupply = _totalSupply.sub(amount);
647         _balances[msg.sender] = _balances[msg.sender].sub(amount);
648         stakingToken.safeTransfer(msg.sender, amount);
649         emit Withdrawn(msg.sender, amount);
650     }
651 
652     function getReward() public nonReentrant updateReward(msg.sender) {
653         uint256 reward = rewards[msg.sender];
654         if (reward > 0) {
655             rewards[msg.sender] = 0;
656             rewardsToken.safeTransfer(msg.sender, reward);
657             emit RewardPaid(msg.sender, reward);
658         }
659     }
660 
661     function exit() external {
662         withdraw(_balances[msg.sender]);
663         getReward();
664     }
665 
666     /* ========== RESTRICTED FUNCTIONS ========== */
667 
668     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
669         if (block.timestamp >= periodFinish) {
670             rewardRate = reward.div(rewardsDuration);
671         } else {
672             uint256 remaining = periodFinish.sub(block.timestamp);
673             uint256 leftover = remaining.mul(rewardRate);
674             rewardRate = reward.add(leftover).div(rewardsDuration);
675         }
676 
677         // Ensure the provided reward amount is not more than the balance in the contract.
678         // This keeps the reward rate in the right range, preventing overflows due to
679         // very high values of rewardRate in the earned and rewardsPerToken functions;
680         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
681         uint balance = rewardsToken.balanceOf(address(this));
682         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
683 
684         lastUpdateTime = block.timestamp;
685         periodFinish = block.timestamp.add(rewardsDuration);
686         emit RewardAdded(reward);
687     }
688 
689     /* ========== MODIFIERS ========== */
690 
691     modifier updateReward(address account) {
692         rewardPerTokenStored = rewardPerToken();
693         lastUpdateTime = lastTimeRewardApplicable();
694         if (account != address(0)) {
695             rewards[account] = earned(account);
696             userRewardPerTokenPaid[account] = rewardPerTokenStored;
697         }
698         _;
699     }
700 
701     /* ========== EVENTS ========== */
702 
703     event RewardAdded(uint256 reward);
704     event Staked(address indexed user, uint256 amount);
705     event Withdrawn(address indexed user, uint256 amount);
706     event RewardPaid(address indexed user, uint256 reward);
707 }
708 
709 // File: contracts/StakingRewardsFactory.sol
710 
711 pragma solidity ^0.5.16;
712 
713 
714 
715 
716 contract StakingRewardsFactory is Ownable {
717     // immutables
718     address public rewardsToken;
719     uint public stakingRewardsGenesis;
720 
721     // the staking tokens for which the rewards contract has been deployed
722     address[] public stakingTokens;
723 
724     // info about rewards for a particular staking token
725     struct StakingRewardsInfo {
726         address stakingRewards;
727         uint rewardAmount;
728     }
729 
730     // rewards info by staking token
731     mapping(address => StakingRewardsInfo) public stakingRewardsInfoByStakingToken;
732 
733     constructor(
734         address _rewardsToken,
735         uint _stakingRewardsGenesis
736     ) Ownable() public {
737         require(_stakingRewardsGenesis >= block.timestamp, 'StakingRewardsFactory::constructor: genesis too soon');
738 
739         rewardsToken = _rewardsToken;
740         stakingRewardsGenesis = _stakingRewardsGenesis;
741     }
742 
743     ///// permissioned functions
744 
745     // deploy a staking reward contract for the staking token, and store the reward amount
746     // the reward will be distributed to the staking reward contract no sooner than the genesis
747     function deploy(address stakingToken, uint rewardAmount) public onlyOwner {
748         StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[stakingToken];
749         require(info.stakingRewards == address(0), 'StakingRewardsFactory::deploy: already deployed');
750 
751         info.stakingRewards = address(new StakingRewards(/*_rewardsDistribution=*/ address(this), rewardsToken, stakingToken));
752         info.rewardAmount = rewardAmount;
753         stakingTokens.push(stakingToken);
754     }
755 
756     ///// permissionless functions
757 
758     // call notifyRewardAmount for all staking tokens.
759     function notifyRewardAmounts() public {
760         require(stakingTokens.length > 0, 'StakingRewardsFactory::notifyRewardAmounts: called before any deploys');
761         for (uint i = 0; i < stakingTokens.length; i++) {
762             notifyRewardAmount(stakingTokens[i]);
763         }
764     }
765 
766     // notify reward amount for an individual staking token.
767     // this is a fallback in case the notifyRewardAmounts costs too much gas to call for all contracts
768     function notifyRewardAmount(address stakingToken) public {
769         require(block.timestamp >= stakingRewardsGenesis, 'StakingRewardsFactory::notifyRewardAmount: not ready');
770 
771         StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[stakingToken];
772         require(info.stakingRewards != address(0), 'StakingRewardsFactory::notifyRewardAmount: not deployed');
773 
774         if (info.rewardAmount > 0) {
775             uint rewardAmount = info.rewardAmount;
776             info.rewardAmount = 0;
777 
778             require(
779                 IERC20(rewardsToken).transfer(info.stakingRewards, rewardAmount),
780                 'StakingRewardsFactory::notifyRewardAmount: transfer failed'
781             );
782             StakingRewards(info.stakingRewards).notifyRewardAmount(rewardAmount);
783         }
784     }
785 }