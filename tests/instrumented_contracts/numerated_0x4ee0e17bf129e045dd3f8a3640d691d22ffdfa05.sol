1 pragma solidity ^0.5.16;
2 
3 
4 /**
5  * @dev Standard math utilities missing in the Solidity language.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the average of two numbers. The result is rounded towards
24      * zero.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
32 /**
33  * @dev Wrappers over Solidity's arithmetic operations with added overflow
34  * checks.
35  *
36  * Arithmetic operations in Solidity wrap on overflow. This can easily result
37  * in bugs, because programmers usually assume that an overflow raises an
38  * error, which is the standard behavior in high level programming languages.
39  * `SafeMath` restores this intuition by reverting the transaction when an
40  * operation overflows.
41  *
42  * Using this library instead of the unchecked operations eliminates an entire
43  * class of bugs, so it's recommended to use it always.
44  */
45 library SafeMath {
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting on
48      * overflow.
49      *
50      * Counterpart to Solidity's `+` operator.
51      *
52      * Requirements:
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot overflow.
83      *
84      * _Available since v2.4.0._
85      */
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      * - Multiplication cannot overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      *
142      * _Available since v2.4.0._
143      */
144     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         // Solidity only automatically asserts when dividing by 0
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
165         return mod(a, b, "SafeMath: modulo by zero");
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts with custom message when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      *
179      * _Available since v2.4.0._
180      */
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 /**
188  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
189  * the optional functions; to access them see {ERC20Detailed}.
190  */
191 interface IERC20 {
192     /**
193      * @dev Returns the amount of tokens in existence.
194      */
195     function totalSupply() external view returns (uint256);
196 
197     /**
198      * @dev Returns the amount of tokens owned by `account`.
199      */
200     function balanceOf(address account) external view returns (uint256);
201 
202     /**
203      * @dev Moves `amount` tokens from the caller's account to `recipient`.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transfer(address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Returns the remaining number of tokens that `spender` will be
213      * allowed to spend on behalf of `owner` through {transferFrom}. This is
214      * zero by default.
215      *
216      * This value changes when {approve} or {transferFrom} are called.
217      */
218     function allowance(address owner, address spender) external view returns (uint256);
219 
220     /**
221      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * IMPORTANT: Beware that changing an allowance with this method brings the risk
226      * that someone may use both the old and the new allowance by unfortunate
227      * transaction ordering. One possible solution to mitigate this race
228      * condition is to first reduce the spender's allowance to 0 and set the
229      * desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address spender, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Moves `amount` tokens from `sender` to `recipient` using the
238      * allowance mechanism. `amount` is then deducted from the caller's
239      * allowance.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Emitted when `value` tokens are moved from one account (`from`) to
249      * another (`to`).
250      *
251      * Note that `value` may be zero.
252      */
253     event Transfer(address indexed from, address indexed to, uint256 value);
254 
255     /**
256      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
257      * a call to {approve}. `value` is the new allowance.
258      */
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260 }
261 
262 /**
263  * @dev Optional functions from the ERC20 standard.
264  */
265 contract ERC20Detailed is IERC20 {
266     string private _name;
267     string private _symbol;
268     uint8 private _decimals;
269 
270     /**
271      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
272      * these values are immutable: they can only be set once during
273      * construction.
274      */
275     constructor (string memory name, string memory symbol, uint8 decimals) public {
276         _name = name;
277         _symbol = symbol;
278         _decimals = decimals;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei.
303      *
304      * NOTE: This information is only used for _display_ purposes: it in
305      * no way affects any of the arithmetic of the contract, including
306      * {IERC20-balanceOf} and {IERC20-transfer}.
307      */
308     function decimals() public view returns (uint8) {
309         return _decimals;
310     }
311 }
312 
313 /**
314  * @dev Collection of functions related to the address type
315  */
316 library Address {
317     /**
318      * @dev Returns true if `account` is a contract.
319      *
320      * This test is non-exhaustive, and there may be false-negatives: during the
321      * execution of a contract's constructor, its address will be reported as
322      * not containing a contract.
323      *
324      * IMPORTANT: It is unsafe to assume that an address for which this
325      * function returns false is an externally-owned account (EOA) and not a
326      * contract.
327      */
328     function isContract(address account) internal view returns (bool) {
329         // This method relies in extcodesize, which returns 0 for contracts in
330         // construction, since the code is only stored at the end of the
331         // constructor execution.
332 
333         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
334         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
335         // for accounts without code, i.e. `keccak256('')`
336         bytes32 codehash;
337         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
338         // solhint-disable-next-line no-inline-assembly
339         assembly { codehash := extcodehash(account) }
340         return (codehash != 0x0 && codehash != accountHash);
341     }
342 
343     /**
344      * @dev Converts an `address` into `address payable`. Note that this is
345      * simply a type cast: the actual underlying value is not changed.
346      *
347      * _Available since v2.4.0._
348      */
349     function toPayable(address account) internal pure returns (address payable) {
350         return address(uint160(account));
351     }
352 
353     /**
354      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
355      * `recipient`, forwarding all available gas and reverting on errors.
356      *
357      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
358      * of certain opcodes, possibly making contracts go over the 2300 gas limit
359      * imposed by `transfer`, making them unable to receive funds via
360      * `transfer`. {sendValue} removes this limitation.
361      *
362      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
363      *
364      * IMPORTANT: because control is transferred to `recipient`, care must be
365      * taken to not create reentrancy vulnerabilities. Consider using
366      * {ReentrancyGuard} or the
367      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
368      *
369      * _Available since v2.4.0._
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         // solhint-disable-next-line avoid-call-value
375         (bool success, ) = recipient.call.value(amount)("");
376         require(success, "Address: unable to send value, recipient may have reverted");
377     }
378 }
379 
380 /**
381  * @title SafeERC20
382  * @dev Wrappers around ERC20 operations that throw on failure (when the token
383  * contract returns false). Tokens that return no value (and instead revert or
384  * throw on failure) are also supported, non-reverting calls are assumed to be
385  * successful.
386  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
387  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
388  */
389 library SafeERC20 {
390     using SafeMath for uint256;
391     using Address for address;
392 
393     function safeTransfer(IERC20 token, address to, uint256 value) internal {
394         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
395     }
396 
397     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
398         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
399     }
400 
401     function safeApprove(IERC20 token, address spender, uint256 value) internal {
402         // safeApprove should only be called when setting an initial allowance,
403         // or when resetting it to zero. To increase and decrease it, use
404         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
405         // solhint-disable-next-line max-line-length
406         require((value == 0) || (token.allowance(address(this), spender) == 0),
407             "SafeERC20: approve from non-zero to non-zero allowance"
408         );
409         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
410     }
411 
412     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
413         uint256 newAllowance = token.allowance(address(this), spender).add(value);
414         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
415     }
416 
417     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
418         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
419         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
420     }
421 
422     /**
423      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
424      * on the return value: the return value is optional (but if data is returned, it must not be false).
425      * @param token The token targeted by the call.
426      * @param data The call data (encoded using abi.encode or one of its variants).
427      */
428     function callOptionalReturn(IERC20 token, bytes memory data) private {
429         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
430         // we're implementing it ourselves.
431 
432         // A Solidity high level call has three parts:
433         //  1. The target address is checked to verify it contains contract code
434         //  2. The call itself is made, and success asserted
435         //  3. The return value is decoded, which in turn checks the size of the returned data.
436         // solhint-disable-next-line max-line-length
437         require(address(token).isContract(), "SafeERC20: call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = address(token).call(data);
441         require(success, "SafeERC20: low-level call failed");
442 
443         if (returndata.length > 0) { // Return data is optional
444             // solhint-disable-next-line max-line-length
445             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
446         }
447     }
448 }
449 
450 /**
451  * @dev Contract module that helps prevent reentrant calls to a function.
452  *
453  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
454  * available, which can be applied to functions to make sure there are no nested
455  * (reentrant) calls to them.
456  *
457  * Note that because there is a single `nonReentrant` guard, functions marked as
458  * `nonReentrant` may not call one another. This can be worked around by making
459  * those functions `private`, and then adding `external` `nonReentrant` entry
460  * points to them.
461  */
462 contract ReentrancyGuard {
463     // counter to allow mutex lock with only one SSTORE operation
464     uint256 private _guardCounter;
465 
466     constructor () internal {
467         // The counter starts at one to prevent changing it from zero to a non-zero
468         // value, which is a more expensive operation.
469         _guardCounter = 1;
470     }
471 
472     /**
473      * @dev Prevents a contract from calling itself, directly or indirectly.
474      * Calling a `nonReentrant` function from another `nonReentrant`
475      * function is not supported. It is possible to prevent this from happening
476      * by making the `nonReentrant` function external, and make it call a
477      * `private` function that does the actual work.
478      */
479     modifier nonReentrant() {
480         _guardCounter += 1;
481         uint256 localCounter = _guardCounter;
482         _;
483         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
484     }
485 }
486 
487 interface IStakingRewards {
488     // Views
489     function lastRewardPaidTime(address account) external view returns (uint256);
490 
491     function lastTimeRewardApplicable() external view returns (uint256);
492 
493     function rewardPerToken() external view returns (uint256);
494 
495     function earned(address account) external view returns (uint256);
496 
497     function totalSupply() external view returns (uint256);
498 
499     function balanceOf(address account) external view returns (uint256);
500 
501     // Mutative
502 
503     function stake(uint256 amount) external;
504 
505     function withdraw(uint256 amount) external;
506 
507     function getReward() external;
508 
509     function exit() external;
510 
511     function sync() external;
512 }
513 
514 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
515 contract RewardsDistributionRecipient {
516     address public rewardsDistribution;
517 
518     function start() external;
519 
520     modifier onlyRewardsDistribution() {
521         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
522         _;
523     }
524 }
525 
526 // Inheritance
527 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
528     using SafeMath for uint256;
529     using SafeERC20 for IERC20;
530 
531     /* ========== STATE VARIABLES ========== */
532 
533     IERC20 public rewardsToken;
534     IERC20 public stakingToken;
535     uint256 public periodFinish = 0;
536     uint256 public periodStart = 0;
537     uint256 public rewardRate = 0;
538     uint256 public rewardsDuration = 8 weeks;
539 
540     uint256 private _remainingAmount;
541     uint256 private _totalSupply;
542     mapping(address => uint256) private _balances;
543     mapping(address => uint256) private _lastRewardPaidTime;
544 
545     /* ========== CONSTRUCTOR ========== */
546 
547     constructor(
548         address _rewardsDistribution,
549         address _rewardsToken,
550         address _stakingToken
551     ) public {
552         rewardsToken = IERC20(_rewardsToken);
553         stakingToken = IERC20(_stakingToken);
554         rewardsDistribution = _rewardsDistribution;
555     }
556 
557     /* ========== VIEWS ========== */
558 
559     function totalSupply() external view returns (uint256) {
560         return _totalSupply;
561     }
562 
563     function balanceOf(address account) external view returns (uint256) {
564         return _balances[account];
565     }
566 
567     function lastTimeRewardApplicable() public view returns (uint256) {
568         return Math.min(block.timestamp, periodFinish);
569     }
570 
571     function rewardPerToken() public view returns (uint256) {
572         if (_totalSupply == 0) {
573             return 0;
574         }
575         return rewardRate.mul(1e18).div(_totalSupply);
576     }
577 
578     function lastRewardPaidTime(address account) public view returns (uint256) {
579         if (periodStart == 0) {
580             return 0;
581         }
582         return Math.max(_lastRewardPaidTime[account], periodStart);
583     }
584 
585     function earned(address account) public view returns (uint256) {
586         uint256 _lastPaidTime = lastRewardPaidTime(account);
587         if (_lastPaidTime == 0) {
588             return 0;
589         }
590         return _balances[account].mul(lastTimeRewardApplicable().sub(_lastPaidTime)).mul(rewardPerToken()).div(1e18);
591     }
592 
593     /* ========== MUTATIVE FUNCTIONS ========== */
594 
595     function stake(uint256 amount) external nonReentrant {
596         require(amount > 0, "Cannot stake 0");
597         _getReward();
598         _totalSupply = _totalSupply.add(amount);
599         _balances[msg.sender] = _balances[msg.sender].add(amount);
600         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
601         
602         emit Staked(msg.sender, amount);
603     }
604 
605     function withdraw(uint256 amount) public nonReentrant {
606         require(amount > 0, "Cannot withdraw 0");
607         _getReward();
608         _totalSupply = _totalSupply.sub(amount);
609         _balances[msg.sender] = _balances[msg.sender].sub(amount);
610         stakingToken.safeTransfer(msg.sender, amount);
611         emit Withdrawn(msg.sender, amount);
612     }
613 
614     function getReward() public nonReentrant {
615         _getReward();
616     }
617 
618     function _getReward() private {
619         uint256 reward = earned(msg.sender);
620         _lastRewardPaidTime[msg.sender] = block.timestamp;
621         if (reward > 0) {
622             rewardsToken.safeTransfer(msg.sender, reward);
623             _remainingAmount = _remainingAmount.sub(reward);
624             emit RewardPaid(msg.sender, reward);
625         }
626     }
627 
628     function exit() external {
629         withdraw(_balances[msg.sender]);
630         getReward();
631     }
632 
633     function sync() external {
634       uint balance = rewardsToken.balanceOf(address(this));
635       require(balance > 0, "Invalid balance");
636 
637       rewardRate = rewardRate.mul(balance).div(_remainingAmount);
638       _remainingAmount = balance;
639       emit Synced();
640     }
641 
642     /* ========== RESTRICTED FUNCTIONS ========== */
643 
644     function start() external onlyRewardsDistribution {
645       uint balance = rewardsToken.balanceOf(address(this));
646       require(balance > 0, "Invalid balance");
647       rewardRate = balance.div(rewardsDuration);
648 
649       periodStart = block.timestamp;
650       periodFinish = block.timestamp.add(rewardsDuration);
651       _remainingAmount = balance;
652       emit Started();
653     }
654 
655     event Started();
656     event Synced();
657     event Staked(address indexed user, uint256 amount);
658     event Withdrawn(address indexed user, uint256 amount);
659     event RewardPaid(address indexed user, uint256 reward);
660 }