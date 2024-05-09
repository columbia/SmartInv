1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-16
3 */
4 
5 pragma solidity ^0.5.16;
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
35 /**
36  * @dev Wrappers over Solidity's arithmetic operations with added overflow
37  * checks.
38  *
39  * Arithmetic operations in Solidity wrap on overflow. This can easily result
40  * in bugs, because programmers usually assume that an overflow raises an
41  * error, which is the standard behavior in high level programming languages.
42  * `SafeMath` restores this intuition by reverting the transaction when an
43  * operation overflows.
44  *
45  * Using this library instead of the unchecked operations eliminates an entire
46  * class of bugs, so it's recommended to use it always.
47  */
48 library SafeMath {
49     /**
50      * @dev Returns the addition of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `+` operator.
54      *
55      * Requirements:
56      * - Addition cannot overflow.
57      */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting on
67      * overflow (when the result is negative).
68      *
69      * Counterpart to Solidity's `-` operator.
70      *
71      * Requirements:
72      * - Subtraction cannot overflow.
73      */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a, "SafeMath: subtraction overflow");
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82      * @dev Returns the multiplication of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `*` operator.
86      *
87      * Requirements:
88      * - Multiplication cannot overflow.
89      */
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92         // benefit is lost if 'b' is also tested.
93         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      */
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, "SafeMath: division by zero");
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b != 0, "SafeMath: modulo by zero");
137         return a % b;
138     }
139 }
140 
141 /**
142  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
143  * the optional functions; to access them see `ERC20Detailed`.
144  */
145 interface IERC20 {
146     /**
147      * @dev Returns the amount of tokens in existence.
148      */
149     function totalSupply() external view returns (uint256);
150 
151     /**
152      * @dev Returns the amount of tokens owned by `account`.
153      */
154     function balanceOf(address account) external view returns (uint256);
155 
156     /**
157      * @dev Moves `amount` tokens from the caller's account to `recipient`.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a `Transfer` event.
162      */
163     function transfer(address recipient, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Returns the remaining number of tokens that `spender` will be
167      * allowed to spend on behalf of `owner` through `transferFrom`. This is
168      * zero by default.
169      *
170      * This value changes when `approve` or `transferFrom` are called.
171      */
172     function allowance(address owner, address spender) external view returns (uint256);
173 
174     /**
175      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * > Beware that changing an allowance with this method brings the risk
180      * that someone may use both the old and the new allowance by unfortunate
181      * transaction ordering. One possible solution to mitigate this race
182      * condition is to first reduce the spender's allowance to 0 and set the
183      * desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      *
186      * Emits an `Approval` event.
187      */
188     function approve(address spender, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Moves `amount` tokens from `sender` to `recipient` using the
192      * allowance mechanism. `amount` is then deducted from the caller's
193      * allowance.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * Emits a `Transfer` event.
198      */
199     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
200 
201     /**
202      * @dev Emitted when `value` tokens are moved from one account (`from`) to
203      * another (`to`).
204      *
205      * Note that `value` may be zero.
206      */
207     event Transfer(address indexed from, address indexed to, uint256 value);
208 
209     /**
210      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
211      * a call to `approve`. `value` is the new allowance.
212      */
213     event Approval(address indexed owner, address indexed spender, uint256 value);
214 }
215 
216 /**
217  * @dev Optional functions from the ERC20 standard.
218  */
219 contract ERC20Detailed is IERC20 {
220     string private _name;
221     string private _symbol;
222     uint8 private _decimals;
223 
224     /**
225      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
226      * these values are immutable: they can only be set once during
227      * construction.
228      */
229     constructor (string memory name, string memory symbol, uint8 decimals) public {
230         _name = name;
231         _symbol = symbol;
232         _decimals = decimals;
233     }
234 
235     /**
236      * @dev Returns the name of the token.
237      */
238     function name() public view returns (string memory) {
239         return _name;
240     }
241 
242     /**
243      * @dev Returns the symbol of the token, usually a shorter version of the
244      * name.
245      */
246     function symbol() public view returns (string memory) {
247         return _symbol;
248     }
249 
250     /**
251      * @dev Returns the number of decimals used to get its user representation.
252      * For example, if `decimals` equals `2`, a balance of `505` tokens should
253      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
254      *
255      * Tokens usually opt for a value of 18, imitating the relationship between
256      * Ether and Wei.
257      *
258      * > Note that this information is only used for _display_ purposes: it in
259      * no way affects any of the arithmetic of the contract, including
260      * `IERC20.balanceOf` and `IERC20.transfer`.
261      */
262     function decimals() public view returns (uint8) {
263         return _decimals;
264     }
265 }
266 
267 
268 /**
269  * @dev Collection of functions related to the address type,
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * This test is non-exhaustive, and there may be false-negatives: during the
276      * execution of a contract's constructor, its address will be reported as
277      * not containing a contract.
278      *
279      * > It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      */
282     function isContract(address account) internal view returns (bool) {
283         // This method relies in extcodesize, which returns 0 for contracts in
284         // construction, since the code is only stored at the end of the
285         // constructor execution.
286 
287         uint256 size;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { size := extcodesize(account) }
290         return size > 0;
291     }
292 }
293 
294 /**
295  * @title SafeERC20
296  * @dev Wrappers around ERC20 operations that throw on failure (when the token
297  * contract returns false). Tokens that return no value (and instead revert or
298  * throw on failure) are also supported, non-reverting calls are assumed to be
299  * successful.
300  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
301  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
302  */
303 library SafeERC20 {
304     using SafeMath for uint256;
305     using Address for address;
306 
307     function safeTransfer(IERC20 token, address to, uint256 value) internal {
308         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
309     }
310 
311     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
312         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
313     }
314 
315     function safeApprove(IERC20 token, address spender, uint256 value) internal {
316         // safeApprove should only be called when setting an initial allowance,
317         // or when resetting it to zero. To increase and decrease it, use
318         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
319         // solhint-disable-next-line max-line-length
320         require((value == 0) || (token.allowance(address(this), spender) == 0),
321             "SafeERC20: approve from non-zero to non-zero allowance"
322         );
323         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
324     }
325 
326     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
327         uint256 newAllowance = token.allowance(address(this), spender).add(value);
328         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
329     }
330 
331     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
332         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
333         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
334     }
335 
336     /**
337      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
338      * on the return value: the return value is optional (but if data is returned, it must not be false).
339      * @param token The token targeted by the call.
340      * @param data The call data (encoded using abi.encode or one of its variants).
341      */
342     function callOptionalReturn(IERC20 token, bytes memory data) private {
343         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
344         // we're implementing it ourselves.
345 
346         // A Solidity high level call has three parts:
347         //  1. The target address is checked to verify it contains contract code
348         //  2. The call itself is made, and success asserted
349         //  3. The return value is decoded, which in turn checks the size of the returned data.
350         // solhint-disable-next-line max-line-length
351         require(address(token).isContract(), "SafeERC20: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = address(token).call(data);
355         require(success, "SafeERC20: low-level call failed");
356 
357         if (returndata.length > 0) { // Return data is optional
358             // solhint-disable-next-line max-line-length
359             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
360         }
361     }
362 }
363 
364 /**
365  * @dev Contract module that helps prevent reentrant calls to a function.
366  *
367  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
368  * available, which can be aplied to functions to make sure there are no nested
369  * (reentrant) calls to them.
370  *
371  * Note that because there is a single `nonReentrant` guard, functions marked as
372  * `nonReentrant` may not call one another. This can be worked around by making
373  * those functions `private`, and then adding `external` `nonReentrant` entry
374  * points to them.
375  */
376 contract ReentrancyGuard {
377     /// @dev counter to allow mutex lock with only one SSTORE operation
378     uint256 private _guardCounter;
379 
380     constructor () internal {
381         // The counter starts at one to prevent changing it from zero to a non-zero
382         // value, which is a more expensive operation.
383         _guardCounter = 1;
384     }
385 
386     /**
387      * @dev Prevents a contract from calling itself, directly or indirectly.
388      * Calling a `nonReentrant` function from another `nonReentrant`
389      * function is not supported. It is possible to prevent this from happening
390      * by making the `nonReentrant` function external, and make it call a
391      * `private` function that does the actual work.
392      */
393     modifier nonReentrant() {
394         _guardCounter += 1;
395         uint256 localCounter = _guardCounter;
396         _;
397         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
398     }
399 }
400 
401 // Inheritancea
402 interface IStakingRewards {
403     // Views
404     function lastTimeRewardApplicable() external view returns (uint256);
405 
406     function rewardPerToken() external view returns (uint256);
407 
408     function earned(address account) external view returns (uint256);
409 
410     function getRewardForDuration() external view returns (uint256);
411 
412     function totalSupply() external view returns (uint256);
413 
414     function balanceOf(address account) external view returns (uint256);
415 
416     // Mutative
417 
418     function stake(uint256 amount) external;
419 
420     function withdraw(uint256 amount) external;
421 
422     function getReward() external;
423 
424     function exit() external;
425 }
426 
427 contract RewardsDistributionRecipient {
428     address public rewardsDistribution;
429 
430     function notifyRewardAmount(uint256 reward) external;
431 
432     modifier onlyRewardsDistribution() {
433         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
434         _;
435     }
436 }
437 
438 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
439     using SafeMath for uint256;
440     using SafeERC20 for IERC20;
441 
442     /* ========== STATE VARIABLES ========== */
443 
444     IERC20 public rewardsToken;
445     IERC20 public stakingToken;
446     uint256 public periodFinish = 0;
447     uint256 public rewardRate = 0;
448     uint256 public rewardsDuration = 60 days;
449     uint256 public lastUpdateTime;
450     uint256 public rewardPerTokenStored;
451 
452     mapping(address => uint256) public userRewardPerTokenPaid;
453     mapping(address => uint256) public rewards;
454 
455     uint256 private _totalSupply;
456     mapping(address => uint256) private _balances;
457 
458     /* ========== CONSTRUCTOR ========== */
459 
460     constructor(
461         address _rewardsDistribution,
462         address _rewardsToken,
463         address _stakingToken
464     ) public {
465         rewardsToken = IERC20(_rewardsToken);
466         stakingToken = IERC20(_stakingToken);
467         rewardsDistribution = _rewardsDistribution;
468     }
469 
470     /* ========== VIEWS ========== */
471 
472     function totalSupply() external view returns (uint256) {
473         return _totalSupply;
474     }
475 
476     function balanceOf(address account) external view returns (uint256) {
477         return _balances[account];
478     }
479 
480     function lastTimeRewardApplicable() public view returns (uint256) {
481         return Math.min(block.timestamp, periodFinish);
482     }
483 
484     function rewardPerToken() public view returns (uint256) {
485         if (_totalSupply == 0) {
486             return rewardPerTokenStored;
487         }
488         return
489             rewardPerTokenStored.add(
490                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
491             );
492     }
493 
494     function earned(address account) public view returns (uint256) {
495         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
496     }
497 
498     function getRewardForDuration() external view returns (uint256) {
499         return rewardRate.mul(rewardsDuration);
500     }
501 
502     /* ========== MUTATIVE FUNCTIONS ========== */
503 
504     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
505         require(amount > 0, "Cannot stake 0");
506         _totalSupply = _totalSupply.add(amount);
507         _balances[msg.sender] = _balances[msg.sender].add(amount);
508 
509         // permit
510         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
511 
512         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
513         emit Staked(msg.sender, amount);
514     }
515 
516     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
517         require(amount > 0, "Cannot stake 0");
518         _totalSupply = _totalSupply.add(amount);
519         _balances[msg.sender] = _balances[msg.sender].add(amount);
520         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
521         emit Staked(msg.sender, amount);
522     }
523 
524     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
525         require(amount > 0, "Cannot withdraw 0");
526         _totalSupply = _totalSupply.sub(amount);
527         _balances[msg.sender] = _balances[msg.sender].sub(amount);
528         stakingToken.safeTransfer(msg.sender, amount);
529         emit Withdrawn(msg.sender, amount);
530     }
531 
532     function getReward() public nonReentrant updateReward(msg.sender) {
533         uint256 reward = rewards[msg.sender];
534         if (reward > 0) {
535             rewards[msg.sender] = 0;
536             rewardsToken.safeTransfer(msg.sender, reward);
537             emit RewardPaid(msg.sender, reward);
538         }
539     }
540 
541     function exit() external {
542         withdraw(_balances[msg.sender]);
543         getReward();
544     }
545 
546     /* ========== RESTRICTED FUNCTIONS ========== */
547 
548     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
549         if (block.timestamp >= periodFinish) {
550             rewardRate = reward.div(rewardsDuration);
551         } else {
552             uint256 remaining = periodFinish.sub(block.timestamp);
553             uint256 leftover = remaining.mul(rewardRate);
554             rewardRate = reward.add(leftover).div(rewardsDuration);
555         }
556 
557         // Ensure the provided reward amount is not more than the balance in the contract.
558         // This keeps the reward rate in the right range, preventing overflows due to
559         // very high values of rewardRate in the earned and rewardsPerToken functions;
560         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
561         uint balance = rewardsToken.balanceOf(address(this));
562         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
563 
564         lastUpdateTime = block.timestamp;
565         periodFinish = block.timestamp.add(rewardsDuration);
566         emit RewardAdded(reward);
567     }
568 
569     /* ========== MODIFIERS ========== */
570 
571     modifier updateReward(address account) {
572         rewardPerTokenStored = rewardPerToken();
573         lastUpdateTime = lastTimeRewardApplicable();
574         if (account != address(0)) {
575             rewards[account] = earned(account);
576             userRewardPerTokenPaid[account] = rewardPerTokenStored;
577         }
578         _;
579     }
580 
581     /* ========== EVENTS ========== */
582 
583     event RewardAdded(uint256 reward);
584     event Staked(address indexed user, uint256 amount);
585     event Withdrawn(address indexed user, uint256 amount);
586     event RewardPaid(address indexed user, uint256 reward);
587 }
588 
589 interface IUniswapV2ERC20 {
590     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
591 }