1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 /**
34  * @dev Wrappers over Solidity's arithmetic operations with added overflow
35  * checks.
36  *
37  * Arithmetic operations in Solidity wrap on overflow. This can easily result
38  * in bugs, because programmers usually assume that an overflow raises an
39  * error, which is the standard behavior in high level programming languages.
40  * `SafeMath` restores this intuition by reverting the transaction when an
41  * operation overflows.
42  *
43  * Using this library instead of the unchecked operations eliminates an entire
44  * class of bugs, so it's recommended to use it always.
45  */
46 library SafeMath {
47     /**
48      * @dev Returns the addition of two unsigned integers, reverting on
49      * overflow.
50      *
51      * Counterpart to Solidity's `+` operator.
52      *
53      * Requirements:
54      * - Addition cannot overflow.
55      */
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting on
65      * overflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      * - Subtraction cannot overflow.
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         require(b <= a, "SafeMath: subtraction overflow");
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the multiplication of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `*` operator.
84      *
85      * Requirements:
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0, "SafeMath: division by zero");
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b != 0, "SafeMath: modulo by zero");
135         return a % b;
136     }
137 }
138 
139 /**
140  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
141  * the optional functions; to access them see `ERC20Detailed`.
142  */
143 interface IERC20 {
144     /**
145      * @dev Returns the amount of tokens in existence.
146      */
147     function totalSupply() external view returns (uint256);
148 
149     /**
150      * @dev Returns the amount of tokens owned by `account`.
151      */
152     function balanceOf(address account) external view returns (uint256);
153 
154     /**
155      * @dev Moves `amount` tokens from the caller's account to `recipient`.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a `Transfer` event.
160      */
161     function transfer(address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Returns the remaining number of tokens that `spender` will be
165      * allowed to spend on behalf of `owner` through `transferFrom`. This is
166      * zero by default.
167      *
168      * This value changes when `approve` or `transferFrom` are called.
169      */
170     function allowance(address owner, address spender) external view returns (uint256);
171 
172     /**
173      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * > Beware that changing an allowance with this method brings the risk
178      * that someone may use both the old and the new allowance by unfortunate
179      * transaction ordering. One possible solution to mitigate this race
180      * condition is to first reduce the spender's allowance to 0 and set the
181      * desired value afterwards:
182      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183      *
184      * Emits an `Approval` event.
185      */
186     function approve(address spender, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Moves `amount` tokens from `sender` to `recipient` using the
190      * allowance mechanism. `amount` is then deducted from the caller's
191      * allowance.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a `Transfer` event.
196      */
197     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
198 
199     /**
200      * @dev Emitted when `value` tokens are moved from one account (`from`) to
201      * another (`to`).
202      *
203      * Note that `value` may be zero.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 value);
206 
207     /**
208      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
209      * a call to `approve`. `value` is the new allowance.
210      */
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 /**
215  * @dev Optional functions from the ERC20 standard.
216  */
217 abstract contract ERC20Detailed is IERC20 {
218     string private _name;
219     string private _symbol;
220     uint8 private _decimals;
221 
222     /**
223      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
224      * these values are immutable: they can only be set once during
225      * construction.
226      */
227     constructor (string memory name, string memory symbol, uint8 decimals) public {
228         _name = name;
229         _symbol = symbol;
230         _decimals = decimals;
231     }
232 
233     /**
234      * @dev Returns the name of the token.
235      */
236     function name() public view returns (string memory) {
237         return _name;
238     }
239 
240     /**
241      * @dev Returns the symbol of the token, usually a shorter version of the
242      * name.
243      */
244     function symbol() public view returns (string memory) {
245         return _symbol;
246     }
247 
248     /**
249      * @dev Returns the number of decimals used to get its user representation.
250      * For example, if `decimals` equals `2`, a balance of `505` tokens should
251      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
252      *
253      * Tokens usually opt for a value of 18, imitating the relationship between
254      * Ether and Wei.
255      *
256      * > Note that this information is only used for _display_ purposes: it in
257      * no way affects any of the arithmetic of the contract, including
258      * `IERC20.balanceOf` and `IERC20.transfer`.
259      */
260     function decimals() public view returns (uint8) {
261         return _decimals;
262     }
263 }
264 
265 
266 /**
267  * @dev Collection of functions related to the address type,
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * This test is non-exhaustive, and there may be false-negatives: during the
274      * execution of a contract's constructor, its address will be reported as
275      * not containing a contract.
276      *
277      * > It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      */
280     function isContract(address account) internal view returns (bool) {
281         // This method relies in extcodesize, which returns 0 for contracts in
282         // construction, since the code is only stored at the end of the
283         // constructor execution.
284 
285         uint256 size;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { size := extcodesize(account) }
288         return size > 0;
289     }
290 }
291 
292 /**
293  * @title SafeERC20
294  * @dev Wrappers around ERC20 operations that throw on failure (when the token
295  * contract returns false). Tokens that return no value (and instead revert or
296  * throw on failure) are also supported, non-reverting calls are assumed to be
297  * successful.
298  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
299  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
300  */
301 library SafeERC20 {
302     using SafeMath for uint256;
303     using Address for address;
304 
305     function safeTransfer(IERC20 token, address to, uint256 value) internal {
306         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
307     }
308 
309     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
310         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
311     }
312 
313     function safeApprove(IERC20 token, address spender, uint256 value) internal {
314         // safeApprove should only be called when setting an initial allowance,
315         // or when resetting it to zero. To increase and decrease it, use
316         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
317         // solhint-disable-next-line max-line-length
318         require((value == 0) || (token.allowance(address(this), spender) == 0),
319             "SafeERC20: approve from non-zero to non-zero allowance"
320         );
321         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
322     }
323 
324     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
325         uint256 newAllowance = token.allowance(address(this), spender).add(value);
326         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
327     }
328 
329     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
330         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
331         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
332     }
333 
334     /**
335      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
336      * on the return value: the return value is optional (but if data is returned, it must not be false).
337      * @param token The token targeted by the call.
338      * @param data The call data (encoded using abi.encode or one of its variants).
339      */
340     function callOptionalReturn(IERC20 token, bytes memory data) private {
341         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
342         // we're implementing it ourselves.
343 
344         // A Solidity high level call has three parts:
345         //  1. The target address is checked to verify it contains contract code
346         //  2. The call itself is made, and success asserted
347         //  3. The return value is decoded, which in turn checks the size of the returned data.
348         // solhint-disable-next-line max-line-length
349         require(address(token).isContract(), "SafeERC20: call to non-contract");
350 
351         // solhint-disable-next-line avoid-low-level-calls
352         (bool success, bytes memory returndata) = address(token).call(data);
353         require(success, "SafeERC20: low-level call failed");
354 
355         if (returndata.length > 0) { // Return data is optional
356             // solhint-disable-next-line max-line-length
357             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
358         }
359     }
360 }
361 
362 /**
363  * @dev Contract module that helps prevent reentrant calls to a function.
364  *
365  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
366  * available, which can be aplied to functions to make sure there are no nested
367  * (reentrant) calls to them.
368  *
369  * Note that because there is a single `nonReentrant` guard, functions marked as
370  * `nonReentrant` may not call one another. This can be worked around by making
371  * those functions `private`, and then adding `external` `nonReentrant` entry
372  * points to them.
373  */
374 contract ReentrancyGuard {
375     /// @dev counter to allow mutex lock with only one SSTORE operation
376     uint256 private _guardCounter;
377 
378     constructor () internal {
379         // The counter starts at one to prevent changing it from zero to a non-zero
380         // value, which is a more expensive operation.
381         _guardCounter = 1;
382     }
383 
384     /**
385      * @dev Prevents a contract from calling itself, directly or indirectly.
386      * Calling a `nonReentrant` function from another `nonReentrant`
387      * function is not supported. It is possible to prevent this from happening
388      * by making the `nonReentrant` function external, and make it call a
389      * `private` function that does the actual work.
390      */
391     modifier nonReentrant() {
392         _guardCounter += 1;
393         uint256 localCounter = _guardCounter;
394         _;
395         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
396     }
397 }
398 
399 // Inheritancea
400 interface IStakingRewards {
401     // Views
402     function lastTimeRewardApplicable() external view returns (uint256);
403 
404     function rewardPerToken() external view returns (uint256);
405 
406     function earned(address account) external view returns (uint256);
407 
408     function getRewardForDuration() external view returns (uint256);
409 
410     function totalSupply() external view returns (uint256);
411 
412     function balanceOf(address account) external view returns (uint256);
413 
414     // Mutative
415 
416     function stakeFor(uint256 amount, address recipient) external;
417 
418     function stake(uint256 amount) external;
419 
420     function withdrawForUserByCVault(uint256 amount, address from) external;
421 
422     function withdraw(uint256 amount) external;
423 
424     function getRewardFor(address user) external;
425 
426     function getReward() external;
427 
428     function exit() external;
429 }
430 
431 abstract contract RewardsDistributionRecipient {
432     address public rewardsDistribution;
433 
434     function notifyRewardAmount(uint256 reward) external virtual;
435 
436     modifier onlyRewardsDistribution() {
437         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
438         _;
439     }
440 }
441 
442 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
443     using SafeMath for uint256;
444     using SafeERC20 for IERC20;
445 
446     /* ========== STATE VARIABLES ========== */
447 
448     IERC20 public rewardsToken;
449     IERC20 public stakingToken;
450     uint256 public periodFinish = 0;
451     uint256 public rewardRate = 0;
452     uint256 public rewardsDuration = 30 days;
453     uint256 public lastUpdateTime;
454     uint256 public rewardPerTokenStored;
455 
456     mapping(address => uint256) public userRewardPerTokenPaid;
457     mapping(address => uint256) public rewards;
458 
459     uint256 private _totalSupply;
460     mapping(address => uint256) private _balances;
461 
462     /* ========== CONSTRUCTOR ========== */
463 
464     constructor(
465         address _rewardsToken,
466         address _stakingToken
467     ) public {
468         rewardsToken = IERC20(_rewardsToken);
469         stakingToken = IERC20(_stakingToken);
470         rewardsDistribution = msg.sender;
471     }
472 
473     /* ========== VIEWS ========== */
474 
475     function totalSupply() external override view returns (uint256) {
476         return _totalSupply;
477     }
478 
479     function balanceOf(address account) external override view returns (uint256) {
480         return _balances[account];
481     }
482 
483     function lastTimeRewardApplicable() public override view returns (uint256) {
484         return Math.min(block.timestamp, periodFinish);
485     }
486 
487     function rewardPerToken() public view override returns (uint256) {
488         if (_totalSupply == 0) {
489             return rewardPerTokenStored;
490         }
491         return
492             rewardPerTokenStored.add(
493                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
494             );
495     }
496 
497     function earned(address account) public override view returns (uint256) {
498         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
499     }
500 
501     function getRewardForDuration() external override view returns (uint256) {
502         return rewardRate.mul(rewardsDuration);
503     }
504 
505     /* ========== MUTATIVE FUNCTIONS ========== */
506 
507     function stakeFor(uint256 amount, address recipient) external override nonReentrant {
508         _stake(amount, recipient);
509     }
510 
511     function stake(uint256 amount) external override nonReentrant {
512         _stake(amount, msg.sender);
513     }
514 
515     function _stake(uint256 amount, address recipient) internal updateReward(recipient) {
516         require(amount > 0, "Cannot stake 0");
517         _totalSupply = _totalSupply.add(amount);
518         _balances[recipient] = _balances[recipient].add(amount);
519         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
520         emit Staked(recipient, amount);
521     }
522 
523     function withdrawForUserByCVault(uint256 amount, address from) public override nonReentrant {
524         require(msg.sender == address(stakingToken), "!cVault");
525         _withdraw(amount, from);
526     }
527 
528     function withdraw(uint256 amount) public override nonReentrant {
529         _withdraw(amount, msg.sender);
530     }
531 
532     function _withdraw(uint256 amount, address user) internal updateReward(user) {
533         require(amount > 0, "Cannot withdraw 0");
534         _totalSupply = _totalSupply.sub(amount);
535         _balances[user] = _balances[user].sub(amount);
536         stakingToken.safeTransfer(user, amount);
537         emit Withdrawn(user, amount);
538     }
539 
540     function getRewardFor(address user) public override nonReentrant {
541         require(msg.sender == address(stakingToken), "!cVault");
542         _getReward(user);
543     }
544 
545     function getReward() public override nonReentrant {
546         _getReward(msg.sender);
547     }
548 
549     function _getReward(address user) internal updateReward(user) {
550         uint256 reward = rewards[user];
551         if (reward > 0) {
552             rewards[user] = 0;
553             rewardsToken.safeTransfer(user, reward);
554             emit RewardPaid(user, reward);
555         }
556     }
557 
558     function exit() external override {
559         _withdraw(_balances[msg.sender], msg.sender);
560         getReward();
561     }
562 
563     /* ========== RESTRICTED FUNCTIONS ========== */
564 
565     function notifyRewardAmount(uint256 reward) external override onlyRewardsDistribution updateReward(address(0)) {
566         if (block.timestamp >= periodFinish) {
567             rewardRate = reward.div(rewardsDuration);
568         } else {
569             uint256 remaining = periodFinish.sub(block.timestamp);
570             uint256 leftover = remaining.mul(rewardRate);
571             rewardRate = reward.add(leftover).div(rewardsDuration);
572         }
573 
574         // Ensure the provided reward amount is not more than the balance in the contract.
575         // This keeps the reward rate in the right range, preventing overflows due to
576         // very high values of rewardRate in the earned and rewardsPerToken functions;
577         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
578         uint balance = rewardsToken.balanceOf(address(this));
579         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
580 
581         lastUpdateTime = block.timestamp;
582         periodFinish = block.timestamp.add(rewardsDuration);
583         emit RewardAdded(reward);
584     }
585 
586     /* ========== MODIFIERS ========== */
587 
588     modifier updateReward(address account) {
589         rewardPerTokenStored = rewardPerToken();
590         lastUpdateTime = lastTimeRewardApplicable();
591         if (account != address(0)) {
592             rewards[account] = earned(account);
593             userRewardPerTokenPaid[account] = rewardPerTokenStored;
594         }
595         _;
596     }
597 
598     /* ========== EVENTS ========== */
599 
600     event RewardAdded(uint256 reward);
601     event Staked(address indexed user, uint256 amount);
602     event Withdrawn(address indexed user, uint256 amount);
603     event RewardPaid(address indexed user, uint256 reward);
604 }
605 
606 
607 contract StakingRewards_cCP3R is StakingRewards {
608     constructor (address _rewardsToken, address _stakingToken)
609         public StakingRewards(
610             _rewardsToken,
611             _stakingToken
612         )
613     {
614 
615     }
616 }