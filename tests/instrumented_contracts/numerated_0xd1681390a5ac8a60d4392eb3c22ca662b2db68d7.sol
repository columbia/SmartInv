1 // Sources flattened with hardhat v2.0.7 https://hardhat.org
2 
3 // File openzeppelin-solidity-2.3.0/contracts/math/Math.sol@v2.3.0
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     /**
12      * @dev Returns the largest of two numbers.
13      */
14     function max(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a >= b ? a : b;
16     }
17 
18     /**
19      * @dev Returns the smallest of two numbers.
20      */
21     function min(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a < b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the average of two numbers. The result is rounded towards
27      * zero.
28      */
29     function average(uint256 a, uint256 b) internal pure returns (uint256) {
30         // (a + b) / 2 can overflow, so we distribute
31         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
32     }
33 }
34 
35 
36 // File openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol@v2.3.0
37 
38 pragma solidity ^0.5.0;
39 
40 /**
41  * @dev Wrappers over Solidity's arithmetic operations with added overflow
42  * checks.
43  *
44  * Arithmetic operations in Solidity wrap on overflow. This can easily result
45  * in bugs, because programmers usually assume that an overflow raises an
46  * error, which is the standard behavior in high level programming languages.
47  * `SafeMath` restores this intuition by reverting the transaction when an
48  * operation overflows.
49  *
50  * Using this library instead of the unchecked operations eliminates an entire
51  * class of bugs, so it's recommended to use it always.
52  */
53 library SafeMath {
54     /**
55      * @dev Returns the addition of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `+` operator.
59      *
60      * Requirements:
61      * - Addition cannot overflow.
62      */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      * - Subtraction cannot overflow.
78      */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b <= a, "SafeMath: subtraction overflow");
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the multiplication of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `*` operator.
91      *
92      * Requirements:
93      * - Multiplication cannot overflow.
94      */
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97         // benefit is lost if 'b' is also tested.
98         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
99         if (a == 0) {
100             return 0;
101         }
102 
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         // Solidity only automatically asserts when dividing by 0
122         require(b > 0, "SafeMath: division by zero");
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b != 0, "SafeMath: modulo by zero");
142         return a % b;
143     }
144 }
145 
146 
147 // File openzeppelin-solidity-2.3.0/contracts/token/ERC20/IERC20.sol@v2.3.0
148 
149 pragma solidity ^0.5.0;
150 
151 /**
152  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
153  * the optional functions; to access them see `ERC20Detailed`.
154  */
155 interface IERC20 {
156     /**
157      * @dev Returns the amount of tokens in existence.
158      */
159     function totalSupply() external view returns (uint256);
160 
161     /**
162      * @dev Returns the amount of tokens owned by `account`.
163      */
164     function balanceOf(address account) external view returns (uint256);
165 
166     /**
167      * @dev Moves `amount` tokens from the caller's account to `recipient`.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a `Transfer` event.
172      */
173     function transfer(address recipient, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Returns the remaining number of tokens that `spender` will be
177      * allowed to spend on behalf of `owner` through `transferFrom`. This is
178      * zero by default.
179      *
180      * This value changes when `approve` or `transferFrom` are called.
181      */
182     function allowance(address owner, address spender) external view returns (uint256);
183 
184     /**
185      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * > Beware that changing an allowance with this method brings the risk
190      * that someone may use both the old and the new allowance by unfortunate
191      * transaction ordering. One possible solution to mitigate this race
192      * condition is to first reduce the spender's allowance to 0 and set the
193      * desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      *
196      * Emits an `Approval` event.
197      */
198     function approve(address spender, uint256 amount) external returns (bool);
199 
200     /**
201      * @dev Moves `amount` tokens from `sender` to `recipient` using the
202      * allowance mechanism. `amount` is then deducted from the caller's
203      * allowance.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a `Transfer` event.
208      */
209     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Emitted when `value` tokens are moved from one account (`from`) to
213      * another (`to`).
214      *
215      * Note that `value` may be zero.
216      */
217     event Transfer(address indexed from, address indexed to, uint256 value);
218 
219     /**
220      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
221      * a call to `approve`. `value` is the new allowance.
222      */
223     event Approval(address indexed owner, address indexed spender, uint256 value);
224 }
225 
226 
227 // File openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20Detailed.sol@v2.3.0
228 
229 pragma solidity ^0.5.0;
230 
231 /**
232  * @dev Optional functions from the ERC20 standard.
233  */
234 contract ERC20Detailed is IERC20 {
235     string private _name;
236     string private _symbol;
237     uint8 private _decimals;
238 
239     /**
240      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
241      * these values are immutable: they can only be set once during
242      * construction.
243      */
244     constructor (string memory name, string memory symbol, uint8 decimals) public {
245         _name = name;
246         _symbol = symbol;
247         _decimals = decimals;
248     }
249 
250     /**
251      * @dev Returns the name of the token.
252      */
253     function name() public view returns (string memory) {
254         return _name;
255     }
256 
257     /**
258      * @dev Returns the symbol of the token, usually a shorter version of the
259      * name.
260      */
261     function symbol() public view returns (string memory) {
262         return _symbol;
263     }
264 
265     /**
266      * @dev Returns the number of decimals used to get its user representation.
267      * For example, if `decimals` equals `2`, a balance of `505` tokens should
268      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
269      *
270      * Tokens usually opt for a value of 18, imitating the relationship between
271      * Ether and Wei.
272      *
273      * > Note that this information is only used for _display_ purposes: it in
274      * no way affects any of the arithmetic of the contract, including
275      * `IERC20.balanceOf` and `IERC20.transfer`.
276      */
277     function decimals() public view returns (uint8) {
278         return _decimals;
279     }
280 }
281 
282 
283 // File openzeppelin-solidity-2.3.0/contracts/utils/Address.sol@v2.3.0
284 
285 pragma solidity ^0.5.0;
286 
287 /**
288  * @dev Collection of functions related to the address type,
289  */
290 library Address {
291     /**
292      * @dev Returns true if `account` is a contract.
293      *
294      * This test is non-exhaustive, and there may be false-negatives: during the
295      * execution of a contract's constructor, its address will be reported as
296      * not containing a contract.
297      *
298      * > It is unsafe to assume that an address for which this function returns
299      * false is an externally-owned account (EOA) and not a contract.
300      */
301     function isContract(address account) internal view returns (bool) {
302         // This method relies in extcodesize, which returns 0 for contracts in
303         // construction, since the code is only stored at the end of the
304         // constructor execution.
305 
306         uint256 size;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { size := extcodesize(account) }
309         return size > 0;
310     }
311 }
312 
313 
314 // File openzeppelin-solidity-2.3.0/contracts/token/ERC20/SafeERC20.sol@v2.3.0
315 
316 pragma solidity ^0.5.0;
317 
318 
319 
320 /**
321  * @title SafeERC20
322  * @dev Wrappers around ERC20 operations that throw on failure (when the token
323  * contract returns false). Tokens that return no value (and instead revert or
324  * throw on failure) are also supported, non-reverting calls are assumed to be
325  * successful.
326  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
327  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
328  */
329 library SafeERC20 {
330     using SafeMath for uint256;
331     using Address for address;
332 
333     function safeTransfer(IERC20 token, address to, uint256 value) internal {
334         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
335     }
336 
337     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
338         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
339     }
340 
341     function safeApprove(IERC20 token, address spender, uint256 value) internal {
342         // safeApprove should only be called when setting an initial allowance,
343         // or when resetting it to zero. To increase and decrease it, use
344         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
345         // solhint-disable-next-line max-line-length
346         require((value == 0) || (token.allowance(address(this), spender) == 0),
347             "SafeERC20: approve from non-zero to non-zero allowance"
348         );
349         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
350     }
351 
352     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
353         uint256 newAllowance = token.allowance(address(this), spender).add(value);
354         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
355     }
356 
357     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
358         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
359         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
360     }
361 
362     /**
363      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
364      * on the return value: the return value is optional (but if data is returned, it must not be false).
365      * @param token The token targeted by the call.
366      * @param data The call data (encoded using abi.encode or one of its variants).
367      */
368     function callOptionalReturn(IERC20 token, bytes memory data) private {
369         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
370         // we're implementing it ourselves.
371 
372         // A Solidity high level call has three parts:
373         //  1. The target address is checked to verify it contains contract code
374         //  2. The call itself is made, and success asserted
375         //  3. The return value is decoded, which in turn checks the size of the returned data.
376         // solhint-disable-next-line max-line-length
377         require(address(token).isContract(), "SafeERC20: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = address(token).call(data);
381         require(success, "SafeERC20: low-level call failed");
382 
383         if (returndata.length > 0) { // Return data is optional
384             // solhint-disable-next-line max-line-length
385             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
386         }
387     }
388 }
389 
390 
391 // File openzeppelin-solidity-2.3.0/contracts/utils/ReentrancyGuard.sol@v2.3.0
392 
393 pragma solidity ^0.5.0;
394 
395 /**
396  * @dev Contract module that helps prevent reentrant calls to a function.
397  *
398  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
399  * available, which can be aplied to functions to make sure there are no nested
400  * (reentrant) calls to them.
401  *
402  * Note that because there is a single `nonReentrant` guard, functions marked as
403  * `nonReentrant` may not call one another. This can be worked around by making
404  * those functions `private`, and then adding `external` `nonReentrant` entry
405  * points to them.
406  */
407 contract ReentrancyGuard {
408     /// @dev counter to allow mutex lock with only one SSTORE operation
409     uint256 private _guardCounter;
410 
411     constructor () internal {
412         // The counter starts at one to prevent changing it from zero to a non-zero
413         // value, which is a more expensive operation.
414         _guardCounter = 1;
415     }
416 
417     /**
418      * @dev Prevents a contract from calling itself, directly or indirectly.
419      * Calling a `nonReentrant` function from another `nonReentrant`
420      * function is not supported. It is possible to prevent this from happening
421      * by making the `nonReentrant` function external, and make it call a
422      * `private` function that does the actual work.
423      */
424     modifier nonReentrant() {
425         _guardCounter += 1;
426         uint256 localCounter = _guardCounter;
427         _;
428         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
429     }
430 }
431 
432 
433 // File contracts/IStakingRewards.sol
434 
435 pragma solidity >=0.4.24;
436 
437 
438 // https://docs.synthetix.io/contracts/source/interfaces/istakingrewards
439 interface IStakingRewards {
440     // Views
441     function lastTimeRewardApplicable() external view returns (uint256);
442 
443     function rewardPerToken() external view returns (uint256);
444 
445     function earned(address account) external view returns (uint256);
446 
447     function getRewardForDuration() external view returns (uint256);
448 
449     function totalSupply() external view returns (uint256);
450 
451     function balanceOf(address account) external view returns (uint256);
452 
453     // Mutative
454 
455     function stake(uint256 amount) external;
456 
457     function withdraw(uint256 amount) external;
458 
459     function getReward() external;
460 
461     function exit() external;
462 }
463 
464 
465 // File contracts/Owned.sol
466 
467 pragma solidity ^0.5.16;
468 
469 
470 // https://docs.synthetix.io/contracts/source/contracts/owned
471 contract Owned {
472     address public owner;
473     address public nominatedOwner;
474 
475     constructor(address _owner) public {
476         require(_owner != address(0), "Owner address cannot be 0");
477         owner = _owner;
478         emit OwnerChanged(address(0), _owner);
479     }
480 
481     function nominateNewOwner(address _owner) external onlyOwner {
482         nominatedOwner = _owner;
483         emit OwnerNominated(_owner);
484     }
485 
486     function acceptOwnership() external {
487         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
488         emit OwnerChanged(owner, nominatedOwner);
489         owner = nominatedOwner;
490         nominatedOwner = address(0);
491     }
492 
493     modifier onlyOwner {
494         _onlyOwner();
495         _;
496     }
497 
498     function _onlyOwner() private view {
499         require(msg.sender == owner, "Only the contract owner may perform this action");
500     }
501 
502     event OwnerNominated(address newOwner);
503     event OwnerChanged(address oldOwner, address newOwner);
504 }
505 
506 
507 // File contracts/Pausable.sol
508 
509 pragma solidity ^0.5.16;
510 
511 // Inheritance
512 
513 // https://docs.synthetix.io/contracts/source/contracts/pausable
514 contract Pausable is Owned {
515     uint public lastPauseTime;
516     bool public paused;
517 
518     constructor() internal {
519         // This contract is abstract, and thus cannot be instantiated directly
520         require(owner != address(0), "Owner must be set");
521         // Paused will be false, and lastPauseTime will be 0 upon initialisation
522     }
523 
524     /**
525      * @notice Change the paused state of the contract
526      * @dev Only the contract owner may call this.
527      */
528     function setPaused(bool _paused) external onlyOwner {
529         // Ensure we're actually changing the state before we do anything
530         if (_paused == paused) {
531             return;
532         }
533 
534         // Set our paused state.
535         paused = _paused;
536 
537         // If applicable, set the last pause time.
538         if (paused) {
539             lastPauseTime = now;
540         }
541 
542         // Let everyone know that our pause state has changed.
543         emit PauseChanged(paused);
544     }
545 
546     event PauseChanged(bool isPaused);
547 
548     modifier notPaused {
549         require(!paused, "This action cannot be performed while the contract is paused");
550         _;
551     }
552 }
553 
554 
555 // File contracts/StakingRewards.sol
556 
557 pragma solidity ^0.5.16;
558 
559 
560 
561 
562 
563 // Inheritance
564 
565 
566 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
567 contract StakingRewards is IStakingRewards, ReentrancyGuard, Pausable {
568     using SafeMath for uint256;
569     using SafeERC20 for IERC20;
570 
571     /* ========== STATE VARIABLES ========== */
572 
573     IERC20 public rewardsToken;
574     IERC20 public stakingToken;
575     uint256 public periodFinish = 0;
576     uint256 public rewardRate = 0;
577     uint256 public rewardsDuration = 7 days;
578     uint256 public lastUpdateTime;
579     uint256 public rewardPerTokenStored;
580 
581     mapping(address => uint256) public userRewardPerTokenPaid;
582     mapping(address => uint256) public rewards;
583 
584     uint256 private _totalSupply;
585     mapping(address => uint256) private _balances;
586 
587     /* ========== CONSTRUCTOR ========== */
588 
589     constructor(
590         address _owner,
591         address _rewardsToken,
592         address _stakingToken
593     ) public Owned(_owner) {
594         rewardsToken = IERC20(_rewardsToken);
595         stakingToken = IERC20(_stakingToken);
596     }
597 
598     /* ========== VIEWS ========== */
599 
600     function totalSupply() external view returns (uint256) {
601         return _totalSupply;
602     }
603 
604     function balanceOf(address account) external view returns (uint256) {
605         return _balances[account];
606     }
607 
608     function lastTimeRewardApplicable() public view returns (uint256) {
609         return Math.min(block.timestamp, periodFinish);
610     }
611 
612     function rewardPerToken() public view returns (uint256) {
613         if (_totalSupply == 0) {
614             return rewardPerTokenStored;
615         }
616         return
617             rewardPerTokenStored.add(
618                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
619             );
620     }
621 
622     function earned(address account) public view returns (uint256) {
623         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
624     }
625 
626     function getRewardForDuration() external view returns (uint256) {
627         return rewardRate.mul(rewardsDuration);
628     }
629 
630     /* ========== MUTATIVE FUNCTIONS ========== */
631 
632     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
633         require(amount > 0, "Cannot stake 0");
634         _totalSupply = _totalSupply.add(amount);
635         _balances[msg.sender] = _balances[msg.sender].add(amount);
636         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
637         emit Staked(msg.sender, amount);
638     }
639 
640     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
641         require(amount > 0, "Cannot withdraw 0");
642         _totalSupply = _totalSupply.sub(amount);
643         _balances[msg.sender] = _balances[msg.sender].sub(amount);
644         stakingToken.safeTransfer(msg.sender, amount);
645         emit Withdrawn(msg.sender, amount);
646     }
647 
648     function getReward() public nonReentrant updateReward(msg.sender) {
649         uint256 reward = rewards[msg.sender];
650         if (reward > 0) {
651             rewards[msg.sender] = 0;
652             rewardsToken.safeTransfer(msg.sender, reward);
653             emit RewardPaid(msg.sender, reward);
654         }
655     }
656 
657     function exit() external {
658         withdraw(_balances[msg.sender]);
659         getReward();
660     }
661 
662     /* ========== RESTRICTED FUNCTIONS ========== */
663 
664     function notifyRewardAmount(uint256 reward) external onlyOwner updateReward(address(0)) {
665         if (block.timestamp >= periodFinish) {
666             rewardRate = reward.div(rewardsDuration);
667         } else {
668             uint256 remaining = periodFinish.sub(block.timestamp);
669             uint256 leftover = remaining.mul(rewardRate);
670             rewardRate = reward.add(leftover).div(rewardsDuration);
671         }
672 
673         // Ensure the provided reward amount is not more than the balance in the contract.
674         // This keeps the reward rate in the right range, preventing overflows due to
675         // very high values of rewardRate in the earned and rewardsPerToken functions;
676         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
677         uint balance = rewardsToken.balanceOf(address(this));
678         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
679 
680         lastUpdateTime = block.timestamp;
681         periodFinish = block.timestamp.add(rewardsDuration);
682         emit RewardAdded(reward);
683     }
684 
685     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
686     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
687         require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");
688         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
689         emit Recovered(tokenAddress, tokenAmount);
690     }
691 
692     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
693         require(
694             block.timestamp > periodFinish,
695             "Previous rewards period must be complete before changing the duration for the new period"
696         );
697         rewardsDuration = _rewardsDuration;
698         emit RewardsDurationUpdated(rewardsDuration);
699     }
700 
701     /* ========== MODIFIERS ========== */
702 
703     modifier updateReward(address account) {
704         rewardPerTokenStored = rewardPerToken();
705         lastUpdateTime = lastTimeRewardApplicable();
706         if (account != address(0)) {
707             rewards[account] = earned(account);
708             userRewardPerTokenPaid[account] = rewardPerTokenStored;
709         }
710         _;
711     }
712 
713     /* ========== EVENTS ========== */
714 
715     event RewardAdded(uint256 reward);
716     event Staked(address indexed user, uint256 amount);
717     event Withdrawn(address indexed user, uint256 amount);
718     event RewardPaid(address indexed user, uint256 reward);
719     event RewardsDurationUpdated(uint256 newDuration);
720     event Recovered(address token, uint256 amount);
721 }