1 pragma solidity ^0.5.16;
2 
3 /**
4  * @dev Standard math utilities missing in the Solidity language.
5  */
6 library Math {
7     /**
8      * @dev Returns the largest of two numbers.
9      */
10     function max(uint256 a, uint256 b) internal pure returns (uint256) {
11         return a >= b ? a : b;
12     }
13 
14     /**
15      * @dev Returns the smallest of two numbers.
16      */
17     function min(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a < b ? a : b;
19     }
20 
21     /**
22      * @dev Returns the average of two numbers. The result is rounded towards
23      * zero.
24      */
25     function average(uint256 a, uint256 b) internal pure returns (uint256) {
26         // (a + b) / 2 can overflow, so we distribute
27         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
28     }
29 }
30 
31 /**
32  * @dev Wrappers over Solidity's arithmetic operations with added overflow
33  * checks.
34  *
35  * Arithmetic operations in Solidity wrap on overflow. This can easily result
36  * in bugs, because programmers usually assume that an overflow raises an
37  * error, which is the standard behavior in high level programming languages.
38  * `SafeMath` restores this intuition by reverting the transaction when an
39  * operation overflows.
40  *
41  * Using this library instead of the unchecked operations eliminates an entire
42  * class of bugs, so it's recommended to use it always.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      * - Addition cannot overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      * - Subtraction cannot overflow.
69      */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a, "SafeMath: subtraction overflow");
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the multiplication of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `*` operator.
82      *
83      * Requirements:
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Solidity only automatically asserts when dividing by 0
113         require(b > 0, "SafeMath: division by zero");
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b != 0, "SafeMath: modulo by zero");
133         return a % b;
134     }
135 }
136 /**
137  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
138  * the optional functions; to access them see `ERC20Detailed`.
139  */
140 interface IERC20 {
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `recipient`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a `Transfer` event.
157      */
158     function transfer(address recipient, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through `transferFrom`. This is
163      * zero by default.
164      *
165      * This value changes when `approve` or `transferFrom` are called.
166      */
167     function allowance(address owner, address spender) external view returns (uint256);
168 
169     /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * > Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an `Approval` event.
182      */
183     function approve(address spender, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Moves `amount` tokens from `sender` to `recipient` using the
187      * allowance mechanism. `amount` is then deducted from the caller's
188      * allowance.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a `Transfer` event.
193      */
194     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Emitted when `value` tokens are moved from one account (`from`) to
198      * another (`to`).
199      *
200      * Note that `value` may be zero.
201      */
202     event Transfer(address indexed from, address indexed to, uint256 value);
203 
204     /**
205      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
206      * a call to `approve`. `value` is the new allowance.
207      */
208     event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210 /**
211  * @dev Optional functions from the ERC20 standard.
212  */
213 contract ERC20Detailed is IERC20 {
214     string private _name;
215     string private _symbol;
216     uint8 private _decimals;
217 
218     /**
219      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
220      * these values are immutable: they can only be set once during
221      * construction.
222      */
223     constructor (string memory name, string memory symbol, uint8 decimals) public {
224         _name = name;
225         _symbol = symbol;
226         _decimals = decimals;
227     }
228 
229     /**
230      * @dev Returns the name of the token.
231      */
232     function name() public view returns (string memory) {
233         return _name;
234     }
235 
236     /**
237      * @dev Returns the symbol of the token, usually a shorter version of the
238      * name.
239      */
240     function symbol() public view returns (string memory) {
241         return _symbol;
242     }
243 
244     /**
245      * @dev Returns the number of decimals used to get its user representation.
246      * For example, if `decimals` equals `2`, a balance of `505` tokens should
247      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
248      *
249      * Tokens usually opt for a value of 18, imitating the relationship between
250      * Ether and Wei.
251      *
252      * > Note that this information is only used for _display_ purposes: it in
253      * no way affects any of the arithmetic of the contract, including
254      * `IERC20.balanceOf` and `IERC20.transfer`.
255      */
256     function decimals() public view returns (uint8) {
257         return _decimals;
258     }
259 }
260 /**
261  * @dev Collection of functions related to the address type,
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * This test is non-exhaustive, and there may be false-negatives: during the
268      * execution of a contract's constructor, its address will be reported as
269      * not containing a contract.
270      *
271      * > It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies in extcodesize, which returns 0 for contracts in
276         // construction, since the code is only stored at the end of the
277         // constructor execution.
278 
279         uint256 size;
280         // solhint-disable-next-line no-inline-assembly
281         assembly { size := extcodesize(account) }
282         return size > 0;
283     }
284 }
285 /**
286  * @title SafeERC20
287  * @dev Wrappers around ERC20 operations that throw on failure (when the token
288  * contract returns false). Tokens that return no value (and instead revert or
289  * throw on failure) are also supported, non-reverting calls are assumed to be
290  * successful.
291  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
292  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
293  */
294 library SafeERC20 {
295     using SafeMath for uint256;
296     using Address for address;
297 
298     function safeTransfer(IERC20 token, address to, uint256 value) internal {
299         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
300     }
301 
302     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
303         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
304     }
305 
306     function safeApprove(IERC20 token, address spender, uint256 value) internal {
307         // safeApprove should only be called when setting an initial allowance,
308         // or when resetting it to zero. To increase and decrease it, use
309         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
310         // solhint-disable-next-line max-line-length
311         require((value == 0) || (token.allowance(address(this), spender) == 0),
312             "SafeERC20: approve from non-zero to non-zero allowance"
313         );
314         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
315     }
316 
317     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
318         uint256 newAllowance = token.allowance(address(this), spender).add(value);
319         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
320     }
321 
322     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
323         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
324         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
325     }
326 
327     /**
328      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
329      * on the return value: the return value is optional (but if data is returned, it must not be false).
330      * @param token The token targeted by the call.
331      * @param data The call data (encoded using abi.encode or one of its variants).
332      */
333     function callOptionalReturn(IERC20 token, bytes memory data) private {
334         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
335         // we're implementing it ourselves.
336 
337         // A Solidity high level call has three parts:
338         //  1. The target address is checked to verify it contains contract code
339         //  2. The call itself is made, and success asserted
340         //  3. The return value is decoded, which in turn checks the size of the returned data.
341         // solhint-disable-next-line max-line-length
342         require(address(token).isContract(), "SafeERC20: call to non-contract");
343 
344         // solhint-disable-next-line avoid-low-level-calls
345         (bool success, bytes memory returndata) = address(token).call(data);
346         require(success, "SafeERC20: low-level call failed");
347 
348         if (returndata.length > 0) { // Return data is optional
349             // solhint-disable-next-line max-line-length
350             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
351         }
352     }
353 }
354 /**
355  * @dev Contract module that helps prevent reentrant calls to a function.
356  *
357  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
358  * available, which can be aplied to functions to make sure there are no nested
359  * (reentrant) calls to them.
360  *
361  * Note that because there is a single `nonReentrant` guard, functions marked as
362  * `nonReentrant` may not call one another. This can be worked around by making
363  * those functions `private`, and then adding `external` `nonReentrant` entry
364  * points to them.
365  */
366 contract ReentrancyGuard {
367     /// @dev counter to allow mutex lock with only one SSTORE operation
368     uint256 private _guardCounter;
369 
370     constructor () internal {
371         // The counter starts at one to prevent changing it from zero to a non-zero
372         // value, which is a more expensive operation.
373         _guardCounter = 1;
374     }
375 
376     /**
377      * @dev Prevents a contract from calling itself, directly or indirectly.
378      * Calling a `nonReentrant` function from another `nonReentrant`
379      * function is not supported. It is possible to prevent this from happening
380      * by making the `nonReentrant` function external, and make it call a
381      * `private` function that does the actual work.
382      */
383     modifier nonReentrant() {
384         _guardCounter += 1;
385         uint256 localCounter = _guardCounter;
386         _;
387         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
388     }
389 }
390 interface IStakingRewards {
391     // Views
392     function lastTimeRewardApplicable() external view returns (uint256);
393 
394     function rewardPerToken() external view returns (uint256);
395 
396     function earned(address account) external view returns (uint256);
397 
398     function getRewardForDuration() external view returns (uint256);
399 
400     function totalSupply() external view returns (uint256);
401 
402     function balanceOf(address account) external view returns (uint256);
403 
404     // Mutative
405 
406     function stake(uint256 amount) external;
407 
408     function withdraw(uint256 amount) external;
409 
410     function getReward() external;
411 
412     function exit() external;
413 }
414 contract RewardsDistributionRecipient {
415     address public rewardsDistribution;
416 
417     function notifyRewardAmount(uint256 reward) external;
418 
419     modifier onlyRewardsDistribution() {
420         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
421         _;
422     }
423 }
424 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
425     using SafeMath for uint256;
426     using SafeERC20 for IERC20;
427 
428     /* ========== STATE VARIABLES ========== */
429 
430     IERC20 public rewardsToken;
431     IERC20 public stakingToken;
432     uint256 public periodFinish = 0;
433     uint256 public rewardRate = 0;
434     uint256 public rewardsDuration;
435     uint256 public lastUpdateTime;
436     uint256 public rewardPerTokenStored;
437 
438     mapping(address => uint256) public userRewardPerTokenPaid;
439     mapping(address => uint256) public rewards;
440 
441     uint256 private _totalSupply;
442     mapping(address => uint256) private _balances;
443 
444     /* ========== CONSTRUCTOR ========== */
445 
446     constructor(
447         address _rewardsDistribution,
448         address _rewardsToken,
449         address _stakingToken,
450         uint _rewardsDurationDays
451     ) public {
452         rewardsToken = IERC20(_rewardsToken);
453         stakingToken = IERC20(_stakingToken);
454         rewardsDistribution = _rewardsDistribution;
455         rewardsDuration = _rewardsDurationDays * (1 days);
456     }
457 
458     /* ========== VIEWS ========== */
459 
460     function totalSupply() external view returns (uint256) {
461         return _totalSupply;
462     }
463 
464     function balanceOf(address account) external view returns (uint256) {
465         return _balances[account];
466     }
467 
468     function lastTimeRewardApplicable() public view returns (uint256) {
469         return Math.min(block.timestamp, periodFinish);
470     }
471 
472     function rewardPerToken() public view returns (uint256) {
473         if (_totalSupply == 0) {
474             return rewardPerTokenStored;
475         }
476         return
477             rewardPerTokenStored.add(
478                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
479             );
480     }
481 
482     function earned(address account) public view returns (uint256) {
483         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
484     }
485 
486     function getRewardForDuration() external view returns (uint256) {
487         return rewardRate.mul(rewardsDuration);
488     }
489 
490     /* ========== MUTATIVE FUNCTIONS ========== */
491 
492     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
493         require(amount > 0, "Cannot stake 0");
494         _totalSupply = _totalSupply.add(amount);
495         _balances[msg.sender] = _balances[msg.sender].add(amount);
496 
497         // permit
498         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
499 
500         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
501         emit Staked(msg.sender, amount);
502     }
503 
504     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
505         require(amount > 0, "Cannot stake 0");
506         _totalSupply = _totalSupply.add(amount);
507         _balances[msg.sender] = _balances[msg.sender].add(amount);
508         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
509         emit Staked(msg.sender, amount);
510     }
511 
512     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
513         require(amount > 0, "Cannot withdraw 0");
514         _totalSupply = _totalSupply.sub(amount);
515         _balances[msg.sender] = _balances[msg.sender].sub(amount);
516         stakingToken.safeTransfer(msg.sender, amount);
517         emit Withdrawn(msg.sender, amount);
518     }
519 
520     function getReward() public nonReentrant updateReward(msg.sender) {
521         uint256 reward = rewards[msg.sender];
522         if (reward > 0) {
523             rewards[msg.sender] = 0;
524             rewardsToken.safeTransfer(msg.sender, reward);
525             emit RewardPaid(msg.sender, reward);
526         }
527     }
528 
529     function exit() external {
530         withdraw(_balances[msg.sender]);
531         getReward();
532     }
533 
534     /* ========== RESTRICTED FUNCTIONS ========== */
535 
536     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
537         if (block.timestamp >= periodFinish) {
538             rewardRate = reward.div(rewardsDuration);
539         } else {
540             uint256 remaining = periodFinish.sub(block.timestamp);
541             uint256 leftover = remaining.mul(rewardRate);
542             rewardRate = reward.add(leftover).div(rewardsDuration);
543         }
544 
545         // Ensure the provided reward amount is not more than the balance in the contract.
546         // This keeps the reward rate in the right range, preventing overflows due to
547         // very high values of rewardRate in the earned and rewardsPerToken functions;
548         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
549         uint balance = rewardsToken.balanceOf(address(this));
550         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
551 
552         lastUpdateTime = block.timestamp;
553         periodFinish = block.timestamp.add(rewardsDuration);
554         emit RewardAdded(reward);
555     }
556 
557     /* ========== MODIFIERS ========== */
558 
559     modifier updateReward(address account) {
560         rewardPerTokenStored = rewardPerToken();
561         lastUpdateTime = lastTimeRewardApplicable();
562         if (account != address(0)) {
563             rewards[account] = earned(account);
564             userRewardPerTokenPaid[account] = rewardPerTokenStored;
565         }
566         _;
567     }
568 
569     /* ========== EVENTS ========== */
570 
571     event RewardAdded(uint256 reward);
572     event Staked(address indexed user, uint256 amount);
573     event Withdrawn(address indexed user, uint256 amount);
574     event RewardPaid(address indexed user, uint256 reward);
575 }
576 
577 interface IUniswapV2ERC20 {
578     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
579 }