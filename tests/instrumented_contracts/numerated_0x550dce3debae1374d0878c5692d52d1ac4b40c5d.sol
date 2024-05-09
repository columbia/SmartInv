1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-19
3 */
4 
5 pragma solidity >=0.5.16;
6 
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     /**
13      * @dev Returns the largest of two numbers.
14      */
15     function max(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a >= b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two numbers.
21      */
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two numbers. The result is rounded towards
28      * zero.
29      */
30     function average(uint256 a, uint256 b) internal pure returns (uint256) {
31         // (a + b) / 2 can overflow, so we distribute
32         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
33     }
34 }
35 
36 /**
37  * @dev Wrappers over Solidity's arithmetic operations with added overflow
38  * checks.
39  *
40  * Arithmetic operations in Solidity wrap on overflow. This can easily result
41  * in bugs, because programmers usually assume that an overflow raises an
42  * error, which is the standard behavior in high level programming languages.
43  * `SafeMath` restores this intuition by reverting the transaction when an
44  * operation overflows.
45  *
46  * Using this library instead of the unchecked operations eliminates an entire
47  * class of bugs, so it's recommended to use it always.
48  */
49 library SafeMath {
50     /**
51      * @dev Returns the addition of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `+` operator.
55      *
56      * Requirements:
57      * - Addition cannot overflow.
58      */
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the subtraction of two unsigned integers, reverting on
68      * overflow (when the result is negative).
69      *
70      * Counterpart to Solidity's `-` operator.
71      *
72      * Requirements:
73      * - Subtraction cannot overflow.
74      */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     /**
80      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
81      * overflow (when the result is negative).
82      *
83      * Counterpart to Solidity's `-` operator.
84      *
85      * Requirements:
86      * - Subtraction cannot overflow.
87      *
88      * _Available since v2.4.0._
89      */
90     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the multiplication of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `*` operator.
102      *
103      * Requirements:
104      * - Multiplication cannot overflow.
105      */
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108         // benefit is lost if 'b' is also tested.
109         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the integer division of two unsigned integers. Reverts on
122      * division by zero. The result is rounded towards zero.
123      *
124      * Counterpart to Solidity's `/` operator. Note: this function uses a
125      * `revert` opcode (which leaves remaining gas untouched) while Solidity
126      * uses an invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         return div(a, b, "SafeMath: division by zero");
133     }
134 
135     /**
136      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
137      * division by zero. The result is rounded towards zero.
138      *
139      * Counterpart to Solidity's `/` operator. Note: this function uses a
140      * `revert` opcode (which leaves remaining gas untouched) while Solidity
141      * uses an invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      *
146      * _Available since v2.4.0._
147      */
148     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         // Solidity only automatically asserts when dividing by 0
150         require(b > 0, errorMessage);
151         uint256 c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return mod(a, b, "SafeMath: modulo by zero");
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts with custom message when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      *
183      * _Available since v2.4.0._
184      */
185     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         require(b != 0, errorMessage);
187         return a % b;
188     }
189 }
190 
191 /**
192  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
193  * the optional functions; to access them see {ERC20Detailed}.
194  */
195 interface IERC20 {
196     /**
197      * @dev Returns the amount of tokens in existence.
198      */
199     function totalSupply() external view returns (uint256);
200 
201     /**
202      * @dev Returns the amount of tokens owned by `account`.
203      */
204     function balanceOf(address account) external view returns (uint256);
205 
206     /**
207      * @dev Moves `amount` tokens from the caller's account to `recipient`.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transfer(address recipient, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Returns the remaining number of tokens that `spender` will be
217      * allowed to spend on behalf of `owner` through {transferFrom}. This is
218      * zero by default.
219      *
220      * This value changes when {approve} or {transferFrom} are called.
221      */
222     function allowance(address owner, address spender) external view returns (uint256);
223 
224     /**
225      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * IMPORTANT: Beware that changing an allowance with this method brings the risk
230      * that someone may use both the old and the new allowance by unfortunate
231      * transaction ordering. One possible solution to mitigate this race
232      * condition is to first reduce the spender's allowance to 0 and set the
233      * desired value afterwards:
234      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235      *
236      * Emits an {Approval} event.
237      */
238     function approve(address spender, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Moves `amount` tokens from `sender` to `recipient` using the
242      * allowance mechanism. `amount` is then deducted from the caller's
243      * allowance.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Emitted when `value` tokens are moved from one account (`from`) to
253      * another (`to`).
254      *
255      * Note that `value` may be zero.
256      */
257     event Transfer(address indexed from, address indexed to, uint256 value);
258 
259     /**
260      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
261      * a call to {approve}. `value` is the new allowance.
262      */
263     event Approval(address indexed owner, address indexed spender, uint256 value);
264 }
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * This test is non-exhaustive, and there may be false-negatives: during the
274      * execution of a contract's constructor, its address will be reported as
275      * not containing a contract.
276      *
277      * IMPORTANT: It is unsafe to assume that an address for which this
278      * function returns false is an externally-owned account (EOA) and not a
279      * contract.
280      */
281     function isContract(address account) internal view returns (bool) {
282         // This method relies in extcodesize, which returns 0 for contracts in
283         // construction, since the code is only stored at the end of the
284         // constructor execution.
285 
286         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
287         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
288         // for accounts without code, i.e. `keccak256('')`
289         bytes32 codehash;
290         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { codehash := extcodehash(account) }
293         return (codehash != 0x0 && codehash != accountHash);
294     }
295 
296     /**
297      * @dev Converts an `address` into `address payable`. Note that this is
298      * simply a type cast: the actual underlying value is not changed.
299      *
300      * _Available since v2.4.0._
301      */
302     function toPayable(address account) internal pure returns (address payable) {
303         return address(uint160(account));
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      *
322      * _Available since v2.4.0._
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         // solhint-disable-next-line avoid-call-value
328         (bool success, ) = recipient.call.value(amount)("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 }
332 
333 /**
334  * @title SafeERC20
335  * @dev Wrappers around ERC20 operations that throw on failure (when the token
336  * contract returns false). Tokens that return no value (and instead revert or
337  * throw on failure) are also supported, non-reverting calls are assumed to be
338  * successful.
339  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
340  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
341  */
342 library SafeERC20 {
343     using SafeMath for uint256;
344     using Address for address;
345 
346     function safeTransfer(IERC20 token, address to, uint256 value) internal {
347         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
348     }
349 
350     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
351         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
352     }
353 
354     function safeApprove(IERC20 token, address spender, uint256 value) internal {
355         // safeApprove should only be called when setting an initial allowance,
356         // or when resetting it to zero. To increase and decrease it, use
357         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
358         // solhint-disable-next-line max-line-length
359         require((value == 0) || (token.allowance(address(this), spender) == 0),
360             "SafeERC20: approve from non-zero to non-zero allowance"
361         );
362         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
363     }
364 
365     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
366         uint256 newAllowance = token.allowance(address(this), spender).add(value);
367         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
368     }
369 
370     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
371         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
372         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
373     }
374 
375     /**
376      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
377      * on the return value: the return value is optional (but if data is returned, it must not be false).
378      * @param token The token targeted by the call.
379      * @param data The call data (encoded using abi.encode or one of its variants).
380      */
381     function callOptionalReturn(IERC20 token, bytes memory data) private {
382         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
383         // we're implementing it ourselves.
384 
385         // A Solidity high level call has three parts:
386         //  1. The target address is checked to verify it contains contract code
387         //  2. The call itself is made, and success asserted
388         //  3. The return value is decoded, which in turn checks the size of the returned data.
389         // solhint-disable-next-line max-line-length
390         require(address(token).isContract(), "SafeERC20: call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = address(token).call(data);
394         require(success, "SafeERC20: low-level call failed");
395 
396         if (returndata.length > 0) { // Return data is optional
397             // solhint-disable-next-line max-line-length
398             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
399         }
400     }
401 }
402 
403 /**
404  * @dev Contract module that helps prevent reentrant calls to a function.
405  *
406  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
407  * available, which can be applied to functions to make sure there are no nested
408  * (reentrant) calls to them.
409  *
410  * Note that because there is a single `nonReentrant` guard, functions marked as
411  * `nonReentrant` may not call one another. This can be worked around by making
412  * those functions `private`, and then adding `external` `nonReentrant` entry
413  * points to them.
414  */
415 contract ReentrancyGuard {
416     // counter to allow mutex lock with only one SSTORE operation
417     uint256 private _guardCounter;
418 
419     constructor () internal {
420         // The counter starts at one to prevent changing it from zero to a non-zero
421         // value, which is a more expensive operation.
422         _guardCounter = 1;
423     }
424 
425     /**
426      * @dev Prevents a contract from calling itself, directly or indirectly.
427      * Calling a `nonReentrant` function from another `nonReentrant`
428      * function is not supported. It is possible to prevent this from happening
429      * by making the `nonReentrant` function external, and make it call a
430      * `private` function that does the actual work.
431      */
432     modifier nonReentrant() {
433         _guardCounter += 1;
434         uint256 localCounter = _guardCounter;
435         _;
436         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
437     }
438 }
439 
440 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
441 contract RewardsDistributionRecipient {
442     address public rewardsDistribution;
443 
444     modifier onlyRewardsDistribution() {
445         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
446         _;
447     }
448 }
449 
450 // Inheritance
451 contract DarkMatterFarm is RewardsDistributionRecipient, ReentrancyGuard {
452     using SafeMath for uint256;
453     using SafeERC20 for IERC20;
454 
455     /* ========== STATE VARIABLES ========== */
456 
457     IERC20 public rewardsToken;
458     IERC20 public stakingToken;
459     uint256 public periodFinish = 0;
460     uint256 public periodStart = 0;
461     uint256 public rewardRate = 0;
462     uint256 public rewardsDuration = 4 weeks;
463 
464     uint256 private _remainingAmount;
465     uint256 private _totalSupply;
466     mapping(address => uint256) private _balances;
467     mapping(address => uint256) private _lastRewardPaidTime;
468 
469     /* ========== CONSTRUCTOR ========== */
470 
471     constructor(
472         address _rewardsDistribution,
473         address _rewardsToken,
474         address _stakingToken
475     ) public {
476         rewardsToken = IERC20(_rewardsToken);
477         stakingToken = IERC20(_stakingToken);
478         rewardsDistribution = _rewardsDistribution;
479     }
480 
481     /* ========== VIEWS ========== */
482 
483     function totalSupply() external view returns (uint256) {
484         return _totalSupply;
485     }
486 
487     function balanceOf(address account) external view returns (uint256) {
488         return _balances[account];
489     }
490 
491     function lastTimeRewardApplicable() public view returns (uint256) {
492         return Math.min(block.timestamp, periodFinish);
493     }
494 
495     function rewardPerToken() public view returns (uint256) {
496         if (_totalSupply == 0) {
497             return 0;
498         }
499         return rewardRate.mul(1e18).div(_totalSupply);
500     }
501 
502     function lastRewardPaidTime(address account) public view returns (uint256) {
503         if (periodStart == 0) {
504             return 0;
505         }
506         return Math.max(_lastRewardPaidTime[account], periodStart);
507     }
508 
509     function earned(address account) public view returns (uint256) {
510         uint256 _lastPaidTime = lastRewardPaidTime(account);
511         if (_lastPaidTime == 0) {
512             return 0;
513         }
514         return _balances[account].mul(lastTimeRewardApplicable().sub(_lastPaidTime)).mul(rewardPerToken()).div(1e18);
515     }
516 
517     /* ========== MUTATIVE FUNCTIONS ========== */
518 
519     function stake(uint256 amount) external nonReentrant {
520         require(amount > 0, "Cannot stake 0");
521         _getReward();
522         _totalSupply = _totalSupply.add(amount);
523         _balances[msg.sender] = _balances[msg.sender].add(amount);
524         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
525         
526         emit Staked(msg.sender, amount);
527     }
528 
529     function withdraw(uint256 amount) public nonReentrant {
530         require(amount > 0, "Cannot withdraw 0");
531         _getReward();
532         _totalSupply = _totalSupply.sub(amount);
533         _balances[msg.sender] = _balances[msg.sender].sub(amount);
534         stakingToken.safeTransfer(msg.sender, amount);
535         emit Withdrawn(msg.sender, amount);
536     }
537 
538     function getReward() public nonReentrant {
539         _getReward();
540     }
541 
542     function _getReward() private {
543         uint256 reward = earned(msg.sender);
544         _lastRewardPaidTime[msg.sender] = block.timestamp;
545         if (reward > 0) {
546             rewardsToken.safeTransfer(msg.sender, reward);
547             _remainingAmount = _remainingAmount.sub(reward);
548             emit RewardPaid(msg.sender, reward);
549         }
550     }
551 
552     function exit() external {
553         withdraw(_balances[msg.sender]);
554         getReward();
555     }
556 
557     function sync() external {
558       uint balance = rewardsToken.balanceOf(address(this));
559       require(balance > 0, "Invalid balance");
560 
561       rewardRate = rewardRate.mul(balance).div(_remainingAmount);
562       _remainingAmount = balance;
563       emit Synced();
564     }
565 
566     /* ========== RESTRICTED FUNCTIONS ========== */
567 
568     function start() external onlyRewardsDistribution {
569       uint balance = rewardsToken.balanceOf(address(this));
570       require(balance > 0, "Invalid balance");
571       rewardRate = balance.div(rewardsDuration);
572 
573       periodStart = block.timestamp;
574       periodFinish = block.timestamp.add(rewardsDuration);
575       _remainingAmount = balance;
576       emit Started();
577     }
578 
579     event Started();
580     event Synced();
581     event Staked(address indexed user, uint256 amount);
582     event Withdrawn(address indexed user, uint256 amount);
583     event RewardPaid(address indexed user, uint256 reward);
584 }