1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-09-16
7 */
8 
9 pragma solidity ^0.5.16;
10 
11 /**
12  * @dev Standard math utilities missing in the Solidity language.
13  */
14 library Math {
15     /**
16      * @dev Returns the largest of two numbers.
17      */
18     function max(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a >= b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the smallest of two numbers.
24      */
25     function min(uint256 a, uint256 b) internal pure returns (uint256) {
26         return a < b ? a : b;
27     }
28 
29     /**
30      * @dev Returns the average of two numbers. The result is rounded towards
31      * zero.
32      */
33     function average(uint256 a, uint256 b) internal pure returns (uint256) {
34         // (a + b) / 2 can overflow, so we distribute
35         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
36     }
37 }
38 
39 /**
40  * @dev Wrappers over Solidity's arithmetic operations with added overflow
41  * checks.
42  *
43  * Arithmetic operations in Solidity wrap on overflow. This can easily result
44  * in bugs, because programmers usually assume that an overflow raises an
45  * error, which is the standard behavior in high level programming languages.
46  * `SafeMath` restores this intuition by reverting the transaction when an
47  * operation overflows.
48  *
49  * Using this library instead of the unchecked operations eliminates an entire
50  * class of bugs, so it's recommended to use it always.
51  */
52 library SafeMath {
53     /**
54      * @dev Returns the addition of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `+` operator.
58      *
59      * Requirements:
60      * - Addition cannot overflow.
61      */
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a, "SafeMath: addition overflow");
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the subtraction of two unsigned integers, reverting on
71      * overflow (when the result is negative).
72      *
73      * Counterpart to Solidity's `-` operator.
74      *
75      * Requirements:
76      * - Subtraction cannot overflow.
77      */
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         require(b <= a, "SafeMath: subtraction overflow");
80         uint256 c = a - b;
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the multiplication of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `*` operator.
90      *
91      * Requirements:
92      * - Multiplication cannot overflow.
93      */
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
96         // benefit is lost if 'b' is also tested.
97         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
98         if (a == 0) {
99             return 0;
100         }
101 
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         // Solidity only automatically asserts when dividing by 0
121         require(b > 0, "SafeMath: division by zero");
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b != 0, "SafeMath: modulo by zero");
141         return a % b;
142     }
143 }
144 
145 /**
146  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
147  * the optional functions; to access them see `ERC20Detailed`.
148  */
149 interface IERC20 {
150     /**
151      * @dev Returns the amount of tokens in existence.
152      */
153     function totalSupply() external view returns (uint256);
154 
155     /**
156      * @dev Returns the amount of tokens owned by `account`.
157      */
158     function balanceOf(address account) external view returns (uint256);
159 
160     /**
161      * @dev Moves `amount` tokens from the caller's account to `recipient`.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a `Transfer` event.
166      */
167     function transfer(address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Returns the remaining number of tokens that `spender` will be
171      * allowed to spend on behalf of `owner` through `transferFrom`. This is
172      * zero by default.
173      *
174      * This value changes when `approve` or `transferFrom` are called.
175      */
176     function allowance(address owner, address spender) external view returns (uint256);
177 
178     /**
179      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * > Beware that changing an allowance with this method brings the risk
184      * that someone may use both the old and the new allowance by unfortunate
185      * transaction ordering. One possible solution to mitigate this race
186      * condition is to first reduce the spender's allowance to 0 and set the
187      * desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      *
190      * Emits an `Approval` event.
191      */
192     function approve(address spender, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Moves `amount` tokens from `sender` to `recipient` using the
196      * allowance mechanism. `amount` is then deducted from the caller's
197      * allowance.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a `Transfer` event.
202      */
203     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Emitted when `value` tokens are moved from one account (`from`) to
207      * another (`to`).
208      *
209      * Note that `value` may be zero.
210      */
211     event Transfer(address indexed from, address indexed to, uint256 value);
212 
213     /**
214      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
215      * a call to `approve`. `value` is the new allowance.
216      */
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 /**
221  * @dev Optional functions from the ERC20 standard.
222  */
223 contract ERC20Detailed is IERC20 {
224     string private _name;
225     string private _symbol;
226     uint8 private _decimals;
227 
228     /**
229      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
230      * these values are immutable: they can only be set once during
231      * construction.
232      */
233     constructor (string memory name, string memory symbol, uint8 decimals) public {
234         _name = name;
235         _symbol = symbol;
236         _decimals = decimals;
237     }
238 
239     /**
240      * @dev Returns the name of the token.
241      */
242     function name() public view returns (string memory) {
243         return _name;
244     }
245 
246     /**
247      * @dev Returns the symbol of the token, usually a shorter version of the
248      * name.
249      */
250     function symbol() public view returns (string memory) {
251         return _symbol;
252     }
253 
254     /**
255      * @dev Returns the number of decimals used to get its user representation.
256      * For example, if `decimals` equals `2`, a balance of `505` tokens should
257      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
258      *
259      * Tokens usually opt for a value of 18, imitating the relationship between
260      * Ether and Wei.
261      *
262      * > Note that this information is only used for _display_ purposes: it in
263      * no way affects any of the arithmetic of the contract, including
264      * `IERC20.balanceOf` and `IERC20.transfer`.
265      */
266     function decimals() public view returns (uint8) {
267         return _decimals;
268     }
269 }
270 
271 
272 /**
273  * @dev Collection of functions related to the address type,
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * This test is non-exhaustive, and there may be false-negatives: during the
280      * execution of a contract's constructor, its address will be reported as
281      * not containing a contract.
282      *
283      * > It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      */
286     function isContract(address account) internal view returns (bool) {
287         // This method relies in extcodesize, which returns 0 for contracts in
288         // construction, since the code is only stored at the end of the
289         // constructor execution.
290 
291         uint256 size;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { size := extcodesize(account) }
294         return size > 0;
295     }
296 }
297 
298 /**
299  * @title SafeERC20
300  * @dev Wrappers around ERC20 operations that throw on failure (when the token
301  * contract returns false). Tokens that return no value (and instead revert or
302  * throw on failure) are also supported, non-reverting calls are assumed to be
303  * successful.
304  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
305  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
306  */
307 library SafeERC20 {
308     using SafeMath for uint256;
309     using Address for address;
310 
311     function safeTransfer(IERC20 token, address to, uint256 value) internal {
312         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
313     }
314 
315     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
316         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
317     }
318 
319     function safeApprove(IERC20 token, address spender, uint256 value) internal {
320         // safeApprove should only be called when setting an initial allowance,
321         // or when resetting it to zero. To increase and decrease it, use
322         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
323         // solhint-disable-next-line max-line-length
324         require((value == 0) || (token.allowance(address(this), spender) == 0),
325             "SafeERC20: approve from non-zero to non-zero allowance"
326         );
327         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
328     }
329 
330     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
331         uint256 newAllowance = token.allowance(address(this), spender).add(value);
332         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
333     }
334 
335     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
336         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
337         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
338     }
339 
340     /**
341      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
342      * on the return value: the return value is optional (but if data is returned, it must not be false).
343      * @param token The token targeted by the call.
344      * @param data The call data (encoded using abi.encode or one of its variants).
345      */
346     function callOptionalReturn(IERC20 token, bytes memory data) private {
347         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
348         // we're implementing it ourselves.
349 
350         // A Solidity high level call has three parts:
351         //  1. The target address is checked to verify it contains contract code
352         //  2. The call itself is made, and success asserted
353         //  3. The return value is decoded, which in turn checks the size of the returned data.
354         // solhint-disable-next-line max-line-length
355         require(address(token).isContract(), "SafeERC20: call to non-contract");
356 
357         // solhint-disable-next-line avoid-low-level-calls
358         (bool success, bytes memory returndata) = address(token).call(data);
359         require(success, "SafeERC20: low-level call failed");
360 
361         if (returndata.length > 0) { // Return data is optional
362             // solhint-disable-next-line max-line-length
363             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
364         }
365     }
366 }
367 
368 /**
369  * @dev Contract module that helps prevent reentrant calls to a function.
370  *
371  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
372  * available, which can be aplied to functions to make sure there are no nested
373  * (reentrant) calls to them.
374  *
375  * Note that because there is a single `nonReentrant` guard, functions marked as
376  * `nonReentrant` may not call one another. This can be worked around by making
377  * those functions `private`, and then adding `external` `nonReentrant` entry
378  * points to them.
379  */
380 contract ReentrancyGuard {
381     /// @dev counter to allow mutex lock with only one SSTORE operation
382     uint256 private _guardCounter;
383 
384     constructor () internal {
385         // The counter starts at one to prevent changing it from zero to a non-zero
386         // value, which is a more expensive operation.
387         _guardCounter = 1;
388     }
389 
390     /**
391      * @dev Prevents a contract from calling itself, directly or indirectly.
392      * Calling a `nonReentrant` function from another `nonReentrant`
393      * function is not supported. It is possible to prevent this from happening
394      * by making the `nonReentrant` function external, and make it call a
395      * `private` function that does the actual work.
396      */
397     modifier nonReentrant() {
398         _guardCounter += 1;
399         uint256 localCounter = _guardCounter;
400         _;
401         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
402     }
403 }
404 
405 // Inheritancea
406 interface IStakingRewards {
407     // Views
408     function lastTimeRewardApplicable() external view returns (uint256);
409 
410     function rewardPerToken() external view returns (uint256);
411 
412     function earned(address account) external view returns (uint256);
413 
414     function getRewardForDuration() external view returns (uint256);
415 
416     function totalSupply() external view returns (uint256);
417 
418     function balanceOf(address account) external view returns (uint256);
419 
420     // Mutative
421 
422     function stake(uint256 amount) external;
423 
424     function withdraw(uint256 amount) external;
425 
426     function getReward() external;
427 
428     function exit() external;
429 }
430 
431 contract RewardsDistributionRecipient {
432     address public rewardsDistribution;
433 
434     function notifyRewardAmount(uint256 reward) external;
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
452     uint256 public rewardsDuration;
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
465         address _rewardsDistribution,
466         address _rewardsToken,
467         address _stakingToken,
468         uint256 _rewardsDuration
469     ) public {
470         rewardsToken = IERC20(_rewardsToken);
471         stakingToken = IERC20(_stakingToken);
472         rewardsDistribution = _rewardsDistribution;
473         rewardsDuration = _rewardsDuration;
474     }
475 
476     /* ========== VIEWS ========== */
477 
478     function totalSupply() external view returns (uint256) {
479         return _totalSupply;
480     }
481 
482     function balanceOf(address account) external view returns (uint256) {
483         return _balances[account];
484     }
485 
486     function lastTimeRewardApplicable() public view returns (uint256) {
487         return Math.min(block.timestamp, periodFinish);
488     }
489 
490     function rewardPerToken() public view returns (uint256) {
491         if (_totalSupply == 0) {
492             return rewardPerTokenStored;
493         }
494         return
495             rewardPerTokenStored.add(
496                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
497             );
498     }
499 
500     function earned(address account) public view returns (uint256) {
501         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
502     }
503 
504     function getRewardForDuration() external view returns (uint256) {
505         return rewardRate.mul(rewardsDuration);
506     }
507 
508     /* ========== MUTATIVE FUNCTIONS ========== */
509 
510     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
511         require(amount > 0, "Cannot stake 0");
512         _totalSupply = _totalSupply.add(amount);
513         _balances[msg.sender] = _balances[msg.sender].add(amount);
514 
515         // permit
516         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
517 
518         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
519         emit Staked(msg.sender, amount);
520     }
521 
522     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
523         require(amount > 0, "Cannot stake 0");
524         _totalSupply = _totalSupply.add(amount);
525         _balances[msg.sender] = _balances[msg.sender].add(amount);
526         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
527         emit Staked(msg.sender, amount);
528     }
529 
530     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
531         require(amount > 0, "Cannot withdraw 0");
532         _totalSupply = _totalSupply.sub(amount);
533         _balances[msg.sender] = _balances[msg.sender].sub(amount);
534         stakingToken.safeTransfer(msg.sender, amount);
535         emit Withdrawn(msg.sender, amount);
536     }
537 
538     function getReward() public nonReentrant updateReward(msg.sender) {
539         uint256 reward = rewards[msg.sender];
540         if (reward > 0) {
541             rewards[msg.sender] = 0;
542             rewardsToken.safeTransfer(msg.sender, reward);
543             emit RewardPaid(msg.sender, reward);
544         }
545     }
546 
547     function exit() external {
548         withdraw(_balances[msg.sender]);
549         getReward();
550     }
551 
552     /* ========== RESTRICTED FUNCTIONS ========== */
553 
554     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
555         if (block.timestamp >= periodFinish) {
556             rewardRate = reward.div(rewardsDuration);
557         } else {
558             uint256 remaining = periodFinish.sub(block.timestamp);
559             uint256 leftover = remaining.mul(rewardRate);
560             rewardRate = reward.add(leftover).div(rewardsDuration);
561         }
562 
563         // Ensure the provided reward amount is not more than the balance in the contract.
564         // This keeps the reward rate in the right range, preventing overflows due to
565         // very high values of rewardRate in the earned and rewardsPerToken functions;
566         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
567         uint balance = rewardsToken.balanceOf(address(this));
568         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
569 
570         lastUpdateTime = block.timestamp;
571         periodFinish = block.timestamp.add(rewardsDuration);
572         emit RewardAdded(reward);
573     }
574 
575     /* ========== MODIFIERS ========== */
576 
577     modifier updateReward(address account) {
578         rewardPerTokenStored = rewardPerToken();
579         lastUpdateTime = lastTimeRewardApplicable();
580         if (account != address(0)) {
581             rewards[account] = earned(account);
582             userRewardPerTokenPaid[account] = rewardPerTokenStored;
583         }
584         _;
585     }
586 
587     /* ========== EVENTS ========== */
588 
589     event RewardAdded(uint256 reward);
590     event Staked(address indexed user, uint256 amount);
591     event Withdrawn(address indexed user, uint256 amount);
592     event RewardPaid(address indexed user, uint256 reward);
593 }
594 
595 interface IUniswapV2ERC20 {
596     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
597 }