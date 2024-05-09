1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.5.17;
4 
5 
6 
7 // Part: IStakingRewards
8 
9 interface IStakingRewards {
10     // Views
11     function lastTimeRewardApplicable() external view returns (uint256);
12 
13     function rewardPerToken() external view returns (uint256);
14 
15     function earned(address account) external view returns (uint256);
16 
17     function getRewardForDuration() external view returns (uint256);
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     // Mutative
24 
25     function stake(uint256 amount) external;
26 
27     function withdraw(uint256 amount) external;
28 
29     function getReward() external;
30 
31     function exit() external;
32 }
33 
34 // Part: IUniswapV2ERC20
35 
36 interface IUniswapV2ERC20 {
37     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
38 }
39 
40 // Part: OpenZeppelin/openzeppelin-contracts@2.3.0/Address
41 
42 /**
43  * @dev Collection of functions related to the address type,
44  */
45 library Address {
46     /**
47      * @dev Returns true if `account` is a contract.
48      *
49      * This test is non-exhaustive, and there may be false-negatives: during the
50      * execution of a contract's constructor, its address will be reported as
51      * not containing a contract.
52      *
53      * > It is unsafe to assume that an address for which this function returns
54      * false is an externally-owned account (EOA) and not a contract.
55      */
56     function isContract(address account) internal view returns (bool) {
57         // This method relies in extcodesize, which returns 0 for contracts in
58         // construction, since the code is only stored at the end of the
59         // constructor execution.
60 
61         uint256 size;
62         // solhint-disable-next-line no-inline-assembly
63         assembly { size := extcodesize(account) }
64         return size > 0;
65     }
66 }
67 
68 // Part: OpenZeppelin/openzeppelin-contracts@2.3.0/IERC20
69 
70 /**
71  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
72  * the optional functions; to access them see `ERC20Detailed`.
73  */
74 interface IERC20 {
75     /**
76      * @dev Returns the amount of tokens in existence.
77      */
78     function totalSupply() external view returns (uint256);
79 
80     /**
81      * @dev Returns the amount of tokens owned by `account`.
82      */
83     function balanceOf(address account) external view returns (uint256);
84 
85     /**
86      * @dev Moves `amount` tokens from the caller's account to `recipient`.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a `Transfer` event.
91      */
92     function transfer(address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Returns the remaining number of tokens that `spender` will be
96      * allowed to spend on behalf of `owner` through `transferFrom`. This is
97      * zero by default.
98      *
99      * This value changes when `approve` or `transferFrom` are called.
100      */
101     function allowance(address owner, address spender) external view returns (uint256);
102 
103     /**
104      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * > Beware that changing an allowance with this method brings the risk
109      * that someone may use both the old and the new allowance by unfortunate
110      * transaction ordering. One possible solution to mitigate this race
111      * condition is to first reduce the spender's allowance to 0 and set the
112      * desired value afterwards:
113      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114      *
115      * Emits an `Approval` event.
116      */
117     function approve(address spender, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Moves `amount` tokens from `sender` to `recipient` using the
121      * allowance mechanism. `amount` is then deducted from the caller's
122      * allowance.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a `Transfer` event.
127      */
128     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Emitted when `value` tokens are moved from one account (`from`) to
132      * another (`to`).
133      *
134      * Note that `value` may be zero.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 value);
137 
138     /**
139      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
140      * a call to `approve`. `value` is the new allowance.
141      */
142     event Approval(address indexed owner, address indexed spender, uint256 value);
143 }
144 
145 // Part: OpenZeppelin/openzeppelin-contracts@2.3.0/Math
146 
147 /**
148  * @dev Standard math utilities missing in the Solidity language.
149  */
150 library Math {
151     /**
152      * @dev Returns the largest of two numbers.
153      */
154     function max(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a >= b ? a : b;
156     }
157 
158     /**
159      * @dev Returns the smallest of two numbers.
160      */
161     function min(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a < b ? a : b;
163     }
164 
165     /**
166      * @dev Returns the average of two numbers. The result is rounded towards
167      * zero.
168      */
169     function average(uint256 a, uint256 b) internal pure returns (uint256) {
170         // (a + b) / 2 can overflow, so we distribute
171         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
172     }
173 }
174 
175 // Part: OpenZeppelin/openzeppelin-contracts@2.3.0/ReentrancyGuard
176 
177 /**
178  * @dev Contract module that helps prevent reentrant calls to a function.
179  *
180  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
181  * available, which can be aplied to functions to make sure there are no nested
182  * (reentrant) calls to them.
183  *
184  * Note that because there is a single `nonReentrant` guard, functions marked as
185  * `nonReentrant` may not call one another. This can be worked around by making
186  * those functions `private`, and then adding `external` `nonReentrant` entry
187  * points to them.
188  */
189 contract ReentrancyGuard {
190     /// @dev counter to allow mutex lock with only one SSTORE operation
191     uint256 private _guardCounter;
192 
193     constructor () internal {
194         // The counter starts at one to prevent changing it from zero to a non-zero
195         // value, which is a more expensive operation.
196         _guardCounter = 1;
197     }
198 
199     /**
200      * @dev Prevents a contract from calling itself, directly or indirectly.
201      * Calling a `nonReentrant` function from another `nonReentrant`
202      * function is not supported. It is possible to prevent this from happening
203      * by making the `nonReentrant` function external, and make it call a
204      * `private` function that does the actual work.
205      */
206     modifier nonReentrant() {
207         _guardCounter += 1;
208         uint256 localCounter = _guardCounter;
209         _;
210         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
211     }
212 }
213 
214 // Part: OpenZeppelin/openzeppelin-contracts@2.3.0/SafeMath
215 
216 /**
217  * @dev Wrappers over Solidity's arithmetic operations with added overflow
218  * checks.
219  *
220  * Arithmetic operations in Solidity wrap on overflow. This can easily result
221  * in bugs, because programmers usually assume that an overflow raises an
222  * error, which is the standard behavior in high level programming languages.
223  * `SafeMath` restores this intuition by reverting the transaction when an
224  * operation overflows.
225  *
226  * Using this library instead of the unchecked operations eliminates an entire
227  * class of bugs, so it's recommended to use it always.
228  */
229 library SafeMath {
230     /**
231      * @dev Returns the addition of two unsigned integers, reverting on
232      * overflow.
233      *
234      * Counterpart to Solidity's `+` operator.
235      *
236      * Requirements:
237      * - Addition cannot overflow.
238      */
239     function add(uint256 a, uint256 b) internal pure returns (uint256) {
240         uint256 c = a + b;
241         require(c >= a, "SafeMath: addition overflow");
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the subtraction of two unsigned integers, reverting on
248      * overflow (when the result is negative).
249      *
250      * Counterpart to Solidity's `-` operator.
251      *
252      * Requirements:
253      * - Subtraction cannot overflow.
254      */
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         require(b <= a, "SafeMath: subtraction overflow");
257         uint256 c = a - b;
258 
259         return c;
260     }
261 
262     /**
263      * @dev Returns the multiplication of two unsigned integers, reverting on
264      * overflow.
265      *
266      * Counterpart to Solidity's `*` operator.
267      *
268      * Requirements:
269      * - Multiplication cannot overflow.
270      */
271     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
272         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
273         // benefit is lost if 'b' is also tested.
274         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
275         if (a == 0) {
276             return 0;
277         }
278 
279         uint256 c = a * b;
280         require(c / a == b, "SafeMath: multiplication overflow");
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers. Reverts on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      * - The divisor cannot be zero.
295      */
296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
297         // Solidity only automatically asserts when dividing by 0
298         require(b > 0, "SafeMath: division by zero");
299         uint256 c = a / b;
300         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
307      * Reverts when dividing by zero.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      * - The divisor cannot be zero.
315      */
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         require(b != 0, "SafeMath: modulo by zero");
318         return a % b;
319     }
320 }
321 
322 // Part: RewardsDistributionRecipient
323 
324 contract RewardsDistributionRecipient {
325     address public rewardsDistribution;
326 
327     function notifyRewardAmount(uint256 reward) external;
328 
329     modifier onlyRewardsDistribution() {
330         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
331         _;
332     }
333 }
334 
335 // Part: OpenZeppelin/openzeppelin-contracts@2.3.0/SafeERC20
336 
337 /**
338  * @title SafeERC20
339  * @dev Wrappers around ERC20 operations that throw on failure (when the token
340  * contract returns false). Tokens that return no value (and instead revert or
341  * throw on failure) are also supported, non-reverting calls are assumed to be
342  * successful.
343  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
344  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
345  */
346 library SafeERC20 {
347     using SafeMath for uint256;
348     using Address for address;
349 
350     function safeTransfer(IERC20 token, address to, uint256 value) internal {
351         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
352     }
353 
354     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
355         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
356     }
357 
358     function safeApprove(IERC20 token, address spender, uint256 value) internal {
359         // safeApprove should only be called when setting an initial allowance,
360         // or when resetting it to zero. To increase and decrease it, use
361         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
362         // solhint-disable-next-line max-line-length
363         require((value == 0) || (token.allowance(address(this), spender) == 0),
364             "SafeERC20: approve from non-zero to non-zero allowance"
365         );
366         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
367     }
368 
369     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
370         uint256 newAllowance = token.allowance(address(this), spender).add(value);
371         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
372     }
373 
374     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
375         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
376         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
377     }
378 
379     /**
380      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
381      * on the return value: the return value is optional (but if data is returned, it must not be false).
382      * @param token The token targeted by the call.
383      * @param data The call data (encoded using abi.encode or one of its variants).
384      */
385     function callOptionalReturn(IERC20 token, bytes memory data) private {
386         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
387         // we're implementing it ourselves.
388 
389         // A Solidity high level call has three parts:
390         //  1. The target address is checked to verify it contains contract code
391         //  2. The call itself is made, and success asserted
392         //  3. The return value is decoded, which in turn checks the size of the returned data.
393         // solhint-disable-next-line max-line-length
394         require(address(token).isContract(), "SafeERC20: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = address(token).call(data);
398         require(success, "SafeERC20: low-level call failed");
399 
400         if (returndata.length > 0) { // Return data is optional
401             // solhint-disable-next-line max-line-length
402             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
403         }
404     }
405 }
406 
407 // File: StakingRewards.sol
408 
409 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
410     using SafeMath for uint256;
411     using SafeERC20 for IERC20;
412 
413     /* ========== STATE VARIABLES ========== */
414 
415     IERC20 public rewardsToken;
416     IERC20 public stakingToken;
417     uint256 public periodFinish;
418     uint256 public rewardRate;
419     uint256 public constant rewardsDuration = 183 days;
420     uint256 public lastUpdateTime;
421     uint256 public rewardPerTokenStored;
422 
423     mapping(address => uint256) public userRewardPerTokenPaid;
424     mapping(address => uint256) public rewards;
425 
426     uint256 private _totalSupply;
427     mapping(address => uint256) private _balances;
428 
429     /* ========== CONSTRUCTOR ========== */
430 
431     constructor(
432         address _rewardsDistribution,
433         address _rewardsToken,
434         address _stakingToken
435     ) public {
436         rewardsToken = IERC20(_rewardsToken);
437         stakingToken = IERC20(_stakingToken);
438         rewardsDistribution = _rewardsDistribution;
439     }
440 
441     /* ========== VIEWS ========== */
442 
443     function totalSupply() external view returns (uint256) {
444         return _totalSupply;
445     }
446 
447     function balanceOf(address account) external view returns (uint256) {
448         return _balances[account];
449     }
450 
451     function lastTimeRewardApplicable() public view returns (uint256) {
452         return Math.min(block.timestamp, periodFinish);
453     }
454 
455     function rewardPerToken() public view returns (uint256) {
456         if (_totalSupply == 0) {
457             return rewardPerTokenStored;
458         }
459         return
460             rewardPerTokenStored.add(
461                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
462             );
463     }
464 
465     function earned(address account) public view returns (uint256) {
466         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
467     }
468 
469     function getRewardForDuration() external view returns (uint256) {
470         return rewardRate.mul(rewardsDuration);
471     }
472 
473     /* ========== MUTATIVE FUNCTIONS ========== */
474 
475     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
476         require(amount > 0, "Cannot stake 0");
477         _totalSupply = _totalSupply.add(amount);
478         _balances[msg.sender] = _balances[msg.sender].add(amount);
479 
480         // permit
481         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
482 
483         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
484         emit Staked(msg.sender, amount);
485     }
486 
487     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
488         require(amount > 0, "Cannot stake 0");
489         _totalSupply = _totalSupply.add(amount);
490         _balances[msg.sender] = _balances[msg.sender].add(amount);
491         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
492         emit Staked(msg.sender, amount);
493     }
494 
495     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
496         require(amount > 0, "Cannot withdraw 0");
497         _totalSupply = _totalSupply.sub(amount);
498         _balances[msg.sender] = _balances[msg.sender].sub(amount);
499         stakingToken.safeTransfer(msg.sender, amount);
500         emit Withdrawn(msg.sender, amount);
501     }
502 
503     function getReward() public nonReentrant updateReward(msg.sender) {
504         uint256 reward = rewards[msg.sender];
505         if (reward > 0) {
506             rewards[msg.sender] = 0;
507             rewardsToken.safeTransfer(msg.sender, reward);
508             emit RewardPaid(msg.sender, reward);
509         }
510     }
511 
512     function exit() external {
513         withdraw(_balances[msg.sender]);
514         getReward();
515     }
516 
517     /* ========== RESTRICTED FUNCTIONS ========== */
518 
519     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
520         if (block.timestamp >= periodFinish) {
521             rewardRate = reward.div(rewardsDuration);
522         } else {
523             uint256 remaining = periodFinish.sub(block.timestamp);
524             uint256 leftover = remaining.mul(rewardRate);
525             rewardRate = reward.add(leftover).div(rewardsDuration);
526         }
527 
528         // Ensure the provided reward amount is not more than the balance in the contract.
529         // This keeps the reward rate in the right range, preventing overflows due to
530         // very high values of rewardRate in the earned and rewardsPerToken functions;
531         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
532         uint balance = rewardsToken.balanceOf(address(this));
533         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
534 
535         lastUpdateTime = block.timestamp;
536         periodFinish = block.timestamp.add(rewardsDuration);
537         emit RewardAdded(reward);
538     }
539 
540     /* ========== MODIFIERS ========== */
541 
542     modifier updateReward(address account) {
543         rewardPerTokenStored = rewardPerToken();
544         lastUpdateTime = lastTimeRewardApplicable();
545         if (account != address(0)) {
546             rewards[account] = earned(account);
547             userRewardPerTokenPaid[account] = rewardPerTokenStored;
548         }
549         _;
550     }
551 
552     /* ========== EVENTS ========== */
553 
554     event RewardAdded(uint256 reward);
555     event Staked(address indexed user, uint256 amount);
556     event Withdrawn(address indexed user, uint256 amount);
557     event RewardPaid(address indexed user, uint256 reward);
558 }
