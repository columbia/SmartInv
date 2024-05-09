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
136 
137 /**
138  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
139  * the optional functions; to access them see `ERC20Detailed`.
140  */
141 interface IERC20 {
142     /**
143      * @dev Returns the amount of tokens in existence.
144      */
145     function totalSupply() external view returns (uint256);
146 
147     /**
148      * @dev Returns the amount of tokens owned by `account`.
149      */
150     function balanceOf(address account) external view returns (uint256);
151 
152     /**
153      * @dev Moves `amount` tokens from the caller's account to `recipient`.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a `Transfer` event.
158      */
159     function transfer(address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Returns the remaining number of tokens that `spender` will be
163      * allowed to spend on behalf of `sender` through `transferFrom`. This is
164      * zero by default.
165      *
166      * This value changes when `approve` or `transferFrom` are called.
167      */
168     function allowance(address sender, address spender) external view returns (uint256);
169 
170     /**
171      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * > Beware that changing an allowance with this method brings the risk
176      * that someone may use both the old and the new allowance by unfortunate
177      * transaction ordering. One possible solution to mitigate this race
178      * condition is to first reduce the spender's allowance to 0 and set the
179      * desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      *
182      * Emits an `Approval` event.
183      */
184     function approve(address spender, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Moves `amount` tokens from `sender` to `recipient` using the
188      * allowance mechanism. `amount` is then deducted from the caller's
189      * allowance.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * Emits a `Transfer` event.
194      */
195     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
196 
197     /**
198      * @dev Emitted when `value` tokens are moved from one account (`from`) to
199      * another (`to`).
200      *
201      * Note that `value` may be zero.
202      */
203     event Transfer(address indexed from, address indexed to, uint256 value);
204 
205     /**
206      * @dev Emitted when the allowance of a `spender` for an `sender` is set by
207      * a call to `approve`. `value` is the new allowance.
208      */
209     event Approval(address indexed sender, address indexed spender, uint256 value);
210 }
211 
212 /**
213  * @dev Optional functions from the ERC20 standard.
214  */
215 contract ERC20Detailed is IERC20 {
216     string private _name;
217     string private _symbol;
218     uint8 private _decimals;
219 
220     /**
221      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
222      * these values are immutable: they can only be set once during
223      * construction.
224      */
225     constructor (string memory name, string memory symbol, uint8 decimals) public {
226         _name = name;
227         _symbol = symbol;
228         _decimals = decimals;
229     }
230 
231     /**
232      * @dev Returns the name of the token.
233      */
234     function name() public view returns (string memory) {
235         return _name;
236     }
237 
238     /**
239      * @dev Returns the symbol of the token, usually a shorter version of the
240      * name.
241      */
242     function symbol() public view returns (string memory) {
243         return _symbol;
244     }
245 
246     /**
247      * @dev Returns the number of decimals used to get its user representation.
248      * For example, if `decimals` equals `2`, a balance of `505` tokens should
249      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
250      *
251      * Tokens usually opt for a value of 18, imitating the relationship between
252      * Ether and Wei.
253      *
254      * > Note that this information is only used for _display_ purposes: it in
255      * no way affects any of the arithmetic of the contract, including
256      * `IERC20.balanceOf` and `IERC20.transfer`.
257      */
258     function decimals() public view returns (uint8) {
259         return _decimals;
260     }
261 }
262 
263 
264 /**
265  * @dev Collection of functions related to the address type,
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * This test is non-exhaustive, and there may be false-negatives: during the
272      * execution of a contract's constructor, its address will be reported as
273      * not containing a contract.
274      *
275      * > It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies in extcodesize, which returns 0 for contracts in
280         // construction, since the code is only stored at the end of the
281         // constructor execution.
282 
283         uint256 size;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { size := extcodesize(account) }
286         return size > 0;
287     }
288 }
289 
290 /**
291  * @title SafeERC20
292  * @dev Wrappers around ERC20 operations that throw on failure (when the token
293  * contract returns false). Tokens that return no value (and instead revert or
294  * throw on failure) are also supported, non-reverting calls are assumed to be
295  * successful.
296  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
297  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
298  */
299 library SafeERC20 {
300     using SafeMath for uint256;
301     using Address for address;
302 
303     function safeTransfer(IERC20 token, address to, uint256 value) internal {
304         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
305     }
306 
307     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
308         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
309     }
310 
311     function safeApprove(IERC20 token, address spender, uint256 value) internal {
312         // safeApprove should only be called when setting an initial allowance,
313         // or when resetting it to zero. To increase and decrease it, use
314         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
315         // solhint-disable-next-line max-line-length
316         require((value == 0) || (token.allowance(address(this), spender) == 0),
317             "SafeERC20: approve from non-zero to non-zero allowance"
318         );
319         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
320     }
321 
322     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
323         uint256 newAllowance = token.allowance(address(this), spender).add(value);
324         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
325     }
326 
327     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
328         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
329         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
330     }
331 
332     /**
333      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
334      * on the return value: the return value is optional (but if data is returned, it must not be false).
335      * @param token The token targeted by the call.
336      * @param data The call data (encoded using abi.encode or one of its variants).
337      */
338     function callOptionalReturn(IERC20 token, bytes memory data) private {
339         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
340         // we're implementing it ourselves.
341 
342         // A Solidity high level call has three parts:
343         //  1. The target address is checked to verify it contains contract code
344         //  2. The call itself is made, and success asserted
345         //  3. The return value is decoded, which in turn checks the size of the returned data.
346         // solhint-disable-next-line max-line-length
347         require(address(token).isContract(), "SafeERC20: call to non-contract");
348 
349         // solhint-disable-next-line avoid-low-level-calls
350         (bool success, bytes memory returndata) = address(token).call(data);
351         require(success, "SafeERC20: low-level call failed");
352 
353         if (returndata.length > 0) { // Return data is optional
354             // solhint-disable-next-line max-line-length
355             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
356         }
357     }
358 }
359 
360 /**
361  * @dev Contract module that helps prevent reentrant calls to a function.
362  *
363  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
364  * available, which can be aplied to functions to make sure there are no nested
365  * (reentrant) calls to them.
366  *
367  * Note that because there is a single `nonReentrant` guard, functions marked as
368  * `nonReentrant` may not call one another. This can be worked around by making
369  * those functions `private`, and then adding `external` `nonReentrant` entry
370  * points to them.
371  */
372 contract ReentrancyGuard {
373     /// @dev counter to allow mutex lock with only one SSTORE operation
374     uint256 private _guardCounter;
375 
376     constructor () internal {
377         // The counter starts at one to prevent changing it from zero to a non-zero
378         // value, which is a more expensive operation.
379         _guardCounter = 1;
380     }
381 
382     /**
383      * @dev Prevents a contract from calling itself, directly or indirectly.
384      * Calling a `nonReentrant` function from another `nonReentrant`
385      * function is not supported. It is possible to prevent this from happening
386      * by making the `nonReentrant` function external, and make it call a
387      * `private` function that does the actual work.
388      */
389     modifier nonReentrant() {
390         _guardCounter += 1;
391         uint256 localCounter = _guardCounter;
392         _;
393         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
394     }
395 }
396 
397 // Inheritancea
398 interface IPccRewards {
399     // Views
400     function lastTimeRewardApplicable() external view returns (uint256);
401 
402     function rewardPerToken() external view returns (uint256);
403 
404     function earned(address account) external view returns (uint256);
405 
406     function getRewardForDuration() external view returns (uint256);
407 
408     function totalSupply() external view returns (uint256);
409 
410     function balanceOf(address account) external view returns (uint256);
411 
412     function inPool() external payable;
413 
414     function getReward() external;
415 }
416 
417 contract RewardsDistributionRecipient {
418     address public rewardsDistribution;
419 
420     function notifyRewardAmount(uint256 reward) external;
421 
422     modifier onlyRewardsDistribution() {
423         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
424         _;
425     }
426 }
427 
428 contract PccRewards is IPccRewards, RewardsDistributionRecipient, ReentrancyGuard {
429     using SafeMath for uint256;
430     using SafeERC20 for IERC20;
431 
432     /* ========== STATE VARIABLES ========== */
433 
434     IERC20 public rewardsToken;
435     uint256 public periodFinish = 0;
436     uint256 public rewardRate = 0;
437     uint256 public rewardsDuration = 1095 days;
438     uint256 public lastUpdateTime;
439     uint256 public rewardPerTokenStored;
440 
441     mapping(address => uint256) public userRewardPerTokenPaid;
442     mapping(address => uint256) public rewards;
443 
444     uint256 private _totalSupply;
445     mapping(address => uint256) private _balances;
446 
447     GameInterface private Game;
448 
449     /* ========== CONSTRUCTOR ========== */
450 
451     constructor() public {
452         Game = GameInterface(0xf8A4d3a0B5859a24cd1320BA014ab17F623612e2);
453         rewardsToken = IERC20(0xed6b0dC3AA8dE5908aB857a70Cb2Ff657d9b6C5d);
454         rewardsDistribution = 0x85F2408be694f59B9FCb441E401f1Ee63b2547b0;
455     }
456 
457     function()
458         external
459         payable{}
460 
461     /* ========== VIEWS ========== */
462 
463     function totalSupply() external view returns (uint256) {
464         return _totalSupply;
465     }
466 
467     function balanceOf(address account) external view returns (uint256) {
468         return _balances[account];
469     }
470 
471     function lastTimeRewardApplicable() public view returns (uint256) {
472         return Math.min(block.timestamp, periodFinish);
473     }
474 
475 
476     function rewardPerToken() public view returns (uint256) {
477         if (_totalSupply == 0) {
478             return rewardPerTokenStored;
479         }
480         return
481             rewardPerTokenStored.add(
482                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
483             );
484     }
485 
486     function remainRewardToken() public view returns(uint256) {
487         if(block.timestamp < periodFinish){
488            return rewardRate.mul(periodFinish.sub(block.timestamp));
489         }
490         return 0;
491     }
492 
493     function weekRate() public view returns(uint256) {
494         return(rewardRate.mul(1 weeks));
495     }
496 
497     function earned(address account) public view returns (uint256) {
498         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
499     }
500 
501     function getRewardForDuration() external view returns (uint256) {
502         return rewardRate.mul(rewardsDuration);
503     }
504 
505     function info(address account) public view returns(uint256,uint256,uint256) {
506         if(_totalSupply > 0)
507             return(_balances[account], earned(account), weekRate().mul(_balances[account]).div(_totalSupply));
508         return(0,0,0);
509     }
510 
511     function inPool() external payable updateReward(msg.sender) {
512         uint256 amount = msg.value;
513         require(amount > 0, "Cannot in 0");
514         _totalSupply = _totalSupply.add(amount);
515         _balances[msg.sender] = _balances[msg.sender].add(amount);
516 
517         emit InPool(msg.sender, amount);
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
529     function transferAll2Game() external onlyRewardsDistribution updateReward(msg.sender) {
530         Game.deposit.gas(200000).value(address(this).balance)();
531     }
532 
533     function transfer2Game(uint256 valin) external onlyRewardsDistribution updateReward(msg.sender) {
534         require(valin <= address(this).balance, "val error");
535         Game.deposit.gas(200000).value(valin)();
536     }
537 
538     /* ========== RESTRICTED FUNCTIONS ========== */
539 
540     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
541         if (block.timestamp >= periodFinish) {
542             rewardRate = reward.div(rewardsDuration);
543         } else {
544             uint256 remaining = periodFinish.sub(block.timestamp);
545             uint256 leftover = remaining.mul(rewardRate);
546             rewardRate = reward.add(leftover).div(rewardsDuration);
547         }
548 
549         // Ensure the provided reward amount is not more than the balance in the contract.
550         // This keeps the reward rate in the right range, preventing overflows due to
551         // very high values of rewardRate in the earned and rewardsPerToken functions;
552         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
553         uint balance = rewardsToken.balanceOf(address(this));
554         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
555 
556         lastUpdateTime = block.timestamp;
557         periodFinish = block.timestamp.add(rewardsDuration);
558         emit RewardAdded(reward);
559     }
560 
561     /* ========== MODIFIERS ========== */
562 
563     modifier updateReward(address account) {
564         rewardPerTokenStored = rewardPerToken();
565         lastUpdateTime = lastTimeRewardApplicable();
566         if (account != address(0)) {
567             rewards[account] = earned(account);
568             userRewardPerTokenPaid[account] = rewardPerTokenStored;
569         }
570         _;
571     }
572 
573     /* ========== EVENTS ========== */
574 
575     event RewardAdded(uint256 reward);
576     event InPool(address indexed user, uint256 amount);
577     event RewardPaid(address indexed user, uint256 reward);
578 }
579 
580 interface GameInterface {
581     function deposit() external payable;
582 }