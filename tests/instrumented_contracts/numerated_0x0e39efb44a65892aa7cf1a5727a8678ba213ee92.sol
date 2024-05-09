1 // File: openzeppelin-solidity-2.3.0/contracts/math/Math.sol
2 
3 pragma solidity ^0.5.0;
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
33 // File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations with added overflow
39  * checks.
40  *
41  * Arithmetic operations in Solidity wrap on overflow. This can easily result
42  * in bugs, because programmers usually assume that an overflow raises an
43  * error, which is the standard behavior in high level programming languages.
44  * `SafeMath` restores this intuition by reverting the transaction when an
45  * operation overflows.
46  *
47  * Using this library instead of the unchecked operations eliminates an entire
48  * class of bugs, so it's recommended to use it always.
49  */
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `+` operator.
56      *
57      * Requirements:
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b <= a, "SafeMath: subtraction overflow");
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84      * @dev Returns the multiplication of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `*` operator.
88      *
89      * Requirements:
90      * - Multiplication cannot overflow.
91      */
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
94         // benefit is lost if 'b' is also tested.
95         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
96         if (a == 0) {
97             return 0;
98         }
99 
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      * - The divisor cannot be zero.
116      */
117     function div(uint256 a, uint256 b) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, "SafeMath: division by zero");
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b != 0, "SafeMath: modulo by zero");
139         return a % b;
140     }
141 }
142 
143 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/IERC20.sol
144 
145 pragma solidity ^0.5.0;
146 
147 /**
148  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
149  * the optional functions; to access them see `ERC20Detailed`.
150  */
151 interface IERC20 {
152     /**
153      * @dev Returns the amount of tokens in existence.
154      */
155     function totalSupply() external view returns (uint256);
156 
157     /**
158      * @dev Returns the amount of tokens owned by `account`.
159      */
160     function balanceOf(address account) external view returns (uint256);
161 
162     /**
163      * @dev Moves `amount` tokens from the caller's account to `recipient`.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a `Transfer` event.
168      */
169     function transfer(address recipient, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Returns the remaining number of tokens that `spender` will be
173      * allowed to spend on behalf of `owner` through `transferFrom`. This is
174      * zero by default.
175      *
176      * This value changes when `approve` or `transferFrom` are called.
177      */
178     function allowance(address owner, address spender) external view returns (uint256);
179 
180     /**
181      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * > Beware that changing an allowance with this method brings the risk
186      * that someone may use both the old and the new allowance by unfortunate
187      * transaction ordering. One possible solution to mitigate this race
188      * condition is to first reduce the spender's allowance to 0 and set the
189      * desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * Emits an `Approval` event.
193      */
194     function approve(address spender, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Moves `amount` tokens from `sender` to `recipient` using the
198      * allowance mechanism. `amount` is then deducted from the caller's
199      * allowance.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a `Transfer` event.
204      */
205     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Emitted when `value` tokens are moved from one account (`from`) to
209      * another (`to`).
210      *
211      * Note that `value` may be zero.
212      */
213     event Transfer(address indexed from, address indexed to, uint256 value);
214 
215     /**
216      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
217      * a call to `approve`. `value` is the new allowance.
218      */
219     event Approval(address indexed owner, address indexed spender, uint256 value);
220 }
221 
222 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20Detailed.sol
223 
224 pragma solidity ^0.5.0;
225 
226 
227 /**
228  * @dev Optional functions from the ERC20 standard.
229  */
230 contract ERC20Detailed is IERC20 {
231     string private _name;
232     string private _symbol;
233     uint8 private _decimals;
234 
235     /**
236      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
237      * these values are immutable: they can only be set once during
238      * construction.
239      */
240     constructor (string memory name, string memory symbol, uint8 decimals) public {
241         _name = name;
242         _symbol = symbol;
243         _decimals = decimals;
244     }
245 
246     /**
247      * @dev Returns the name of the token.
248      */
249     function name() public view returns (string memory) {
250         return _name;
251     }
252 
253     /**
254      * @dev Returns the symbol of the token, usually a shorter version of the
255      * name.
256      */
257     function symbol() public view returns (string memory) {
258         return _symbol;
259     }
260 
261     /**
262      * @dev Returns the number of decimals used to get its user representation.
263      * For example, if `decimals` equals `2`, a balance of `505` tokens should
264      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
265      *
266      * Tokens usually opt for a value of 18, imitating the relationship between
267      * Ether and Wei.
268      *
269      * > Note that this information is only used for _display_ purposes: it in
270      * no way affects any of the arithmetic of the contract, including
271      * `IERC20.balanceOf` and `IERC20.transfer`.
272      */
273     function decimals() public view returns (uint8) {
274         return _decimals;
275     }
276 }
277 
278 // File: openzeppelin-solidity-2.3.0/contracts/utils/Address.sol
279 
280 pragma solidity ^0.5.0;
281 
282 /**
283  * @dev Collection of functions related to the address type,
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * This test is non-exhaustive, and there may be false-negatives: during the
290      * execution of a contract's constructor, its address will be reported as
291      * not containing a contract.
292      *
293      * > It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies in extcodesize, which returns 0 for contracts in
298         // construction, since the code is only stored at the end of the
299         // constructor execution.
300 
301         uint256 size;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { size := extcodesize(account) }
304         return size > 0;
305     }
306 }
307 
308 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/SafeERC20.sol
309 
310 pragma solidity ^0.5.0;
311 
312 
313 
314 
315 /**
316  * @title SafeERC20
317  * @dev Wrappers around ERC20 operations that throw on failure (when the token
318  * contract returns false). Tokens that return no value (and instead revert or
319  * throw on failure) are also supported, non-reverting calls are assumed to be
320  * successful.
321  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
322  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
323  */
324 library SafeERC20 {
325     using SafeMath for uint256;
326     using Address for address;
327 
328     function safeTransfer(IERC20 token, address to, uint256 value) internal {
329         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
330     }
331 
332     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
333         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
334     }
335 
336     function safeApprove(IERC20 token, address spender, uint256 value) internal {
337         // safeApprove should only be called when setting an initial allowance,
338         // or when resetting it to zero. To increase and decrease it, use
339         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
340         // solhint-disable-next-line max-line-length
341         require((value == 0) || (token.allowance(address(this), spender) == 0),
342             "SafeERC20: approve from non-zero to non-zero allowance"
343         );
344         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
345     }
346 
347     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
348         uint256 newAllowance = token.allowance(address(this), spender).add(value);
349         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
350     }
351 
352     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
353         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
354         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
355     }
356 
357     /**
358      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
359      * on the return value: the return value is optional (but if data is returned, it must not be false).
360      * @param token The token targeted by the call.
361      * @param data The call data (encoded using abi.encode or one of its variants).
362      */
363     function callOptionalReturn(IERC20 token, bytes memory data) private {
364         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
365         // we're implementing it ourselves.
366 
367         // A Solidity high level call has three parts:
368         //  1. The target address is checked to verify it contains contract code
369         //  2. The call itself is made, and success asserted
370         //  3. The return value is decoded, which in turn checks the size of the returned data.
371         // solhint-disable-next-line max-line-length
372         require(address(token).isContract(), "SafeERC20: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = address(token).call(data);
376         require(success, "SafeERC20: low-level call failed");
377 
378         if (returndata.length > 0) { // Return data is optional
379             // solhint-disable-next-line max-line-length
380             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
381         }
382     }
383 }
384 
385 // File: openzeppelin-solidity-2.3.0/contracts/utils/ReentrancyGuard.sol
386 
387 pragma solidity ^0.5.0;
388 
389 /**
390  * @dev Contract module that helps prevent reentrant calls to a function.
391  *
392  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
393  * available, which can be aplied to functions to make sure there are no nested
394  * (reentrant) calls to them.
395  *
396  * Note that because there is a single `nonReentrant` guard, functions marked as
397  * `nonReentrant` may not call one another. This can be worked around by making
398  * those functions `private`, and then adding `external` `nonReentrant` entry
399  * points to them.
400  */
401 contract ReentrancyGuard {
402     /// @dev counter to allow mutex lock with only one SSTORE operation
403     uint256 private _guardCounter;
404 
405     constructor () internal {
406         // The counter starts at one to prevent changing it from zero to a non-zero
407         // value, which is a more expensive operation.
408         _guardCounter = 1;
409     }
410 
411     /**
412      * @dev Prevents a contract from calling itself, directly or indirectly.
413      * Calling a `nonReentrant` function from another `nonReentrant`
414      * function is not supported. It is possible to prevent this from happening
415      * by making the `nonReentrant` function external, and make it call a
416      * `private` function that does the actual work.
417      */
418     modifier nonReentrant() {
419         _guardCounter += 1;
420         uint256 localCounter = _guardCounter;
421         _;
422         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
423     }
424 }
425 
426 // File: contracts/interfaces/IStakingRewards.sol
427 
428 pragma solidity >=0.4.24;
429 
430 
431 interface IStakingRewards {
432     // Views
433     function lastTimeRewardApplicable() external view returns (uint256);
434 
435     function rewardPerToken() external view returns (uint256);
436 
437     function earned(address account) external view returns (uint256);
438 
439     // function getRewardForDuration() external view returns (uint256);
440 
441     function totalSupply() external view returns (uint256);
442 
443     function balanceOf(address account) external view returns (uint256);
444 
445     // Mutative
446 
447     function stake(uint256 amount) external;
448 
449     function withdraw(uint256 amount) external;
450 
451     function getReward() external;
452 
453     function exit() external;
454 }
455 
456 // File: contracts/RewardsDistributionRecipient.sol
457 
458 pragma solidity ^0.5.16;
459 
460 contract RewardsDistributionRecipient {
461     address public rewardsDistribution;
462 
463     function notifyRewardAmount(uint256 reward) external;
464 
465     modifier onlyRewardsDistribution() {
466         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
467         _;
468     }
469 }
470 
471 // File: contracts/StakingRewards.sol
472 
473 pragma solidity ^0.5.16;
474 
475 
476 
477 
478 
479 
480 // Inheritance
481 
482 
483 
484 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
485     using SafeMath for uint256;
486     using SafeERC20 for IERC20;
487 
488     /* ========== STATE VARIABLES ========== */
489 
490     IERC20 public rewardsToken;
491     IERC20 public stakingToken;
492     uint256 public poolClosingTimestamp = 0;
493     bool public poolClosed = false;
494     uint256 public rewardRate = 0;
495     bool public claimsBlocked = false;
496     uint256 public lastUpdateTime;
497     uint256 public rewardPerTokenStored;
498     uint256 public time = block.timestamp;
499     mapping(address => uint256) public userRewardPerTokenPaid;
500     mapping(address => uint256) public rewards;
501     uint256 private _totalSupply;
502     uint256 private rewardPerDay;
503     mapping(address => uint256) private _balances;
504 
505 
506     /* ========== CONSTRUCTOR ========== */
507 
508     constructor(
509         address _rewardsDistribution,
510         address _rewardsToken,
511         address _stakingToken,
512         uint _rewardPerDay
513     ) public {
514         rewardsToken = IERC20(_rewardsToken);
515         stakingToken = IERC20(_stakingToken);
516         rewardsDistribution = _rewardsDistribution;
517         rewardPerDay = _rewardPerDay;
518     }
519 
520     /* ========== VIEWS ========== */
521 
522     function totalSupply() external view returns (uint256) {
523         return _totalSupply;
524     }
525 
526     function balanceOf(address account) external view returns (uint256) {
527         return _balances[account];
528     }
529 
530     function lastTimeRewardApplicable() public view returns (uint256) {
531         // return Math.min(block.timestamp, periodFinish);
532         if(poolClosed){
533             return poolClosingTimestamp;
534         }
535         return block.timestamp;
536     }
537 
538     function rewardPerToken() public view returns (uint256) {
539         if (_totalSupply == 0) {
540             return rewardPerTokenStored;
541         }
542         return
543             rewardPerTokenStored.add(
544                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
545             );
546     }
547 
548     function earned(address account) public view returns (uint256) {
549         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
550     }
551 
552     /* ========== MUTATIVE FUNCTIONS ========== */
553 
554     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
555         require(amount > 0, "StakingRewards: Cannot stake 0");
556         _totalSupply = _totalSupply.add(amount);
557         _balances[msg.sender] = _balances[msg.sender].add(amount);
558 
559         // permit
560         IRouteERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
561 
562         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
563         emit Staked(msg.sender, amount);
564     }
565 
566     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
567         require(amount > 0, "StakingRewards: Cannot stake 0");
568         _totalSupply = _totalSupply.add(amount);
569         _balances[msg.sender] = _balances[msg.sender].add(amount);
570         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
571         emit Staked(msg.sender, amount);
572     }
573 
574     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
575         require(amount > 0, "StakingRewards: Cannot withdraw 0");
576         _totalSupply = _totalSupply.sub(amount);
577         _balances[msg.sender] = _balances[msg.sender].sub(amount);
578         stakingToken.safeTransfer(msg.sender, amount);
579         emit Withdrawn(msg.sender, amount);
580     }
581 
582     function getReward() public nonReentrant updateReward(msg.sender) {
583         uint256 reward = rewards[msg.sender];
584         require(!claimsBlocked, "StakingRewards: claims are blocked");
585         if (reward > 0) {
586             rewards[msg.sender] = 0;
587             rewardsToken.safeTransfer(msg.sender, reward);
588             emit RewardPaid(msg.sender, reward);
589         }
590     }
591 
592     function exit() external {
593         withdraw(_balances[msg.sender]);
594         if(!claimsBlocked){
595             getReward();
596         }
597     }
598 
599     /* ========== RESTRICTED FUNCTIONS ========== */
600 
601     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
602         rewardRate = rewardPerDay.mul(1 ether).div(1 days);
603         emit RewardAdded(reward);
604     }
605 
606     function closePool() external onlyRewardsDistribution {
607         poolClosed = true;
608         poolClosingTimestamp = block.timestamp;
609     }
610 
611     function unblockClaims() external onlyRewardsDistribution {
612         claimsBlocked = false;
613     }
614 
615     function blockClaims() external onlyRewardsDistribution {
616         claimsBlocked = true;
617     }
618 
619     function rescueFunds(address tokenAddress, address receiver) external onlyRewardsDistribution {
620         require(poolClosed, "StakingRewards: Pool is still active");
621         IERC20(tokenAddress).transfer(receiver, IERC20(tokenAddress).balanceOf(address(this)));
622     }
623 
624     /* ========== MODIFIERS ========== */
625 
626     modifier updateReward(address account) {
627         rewardPerTokenStored = rewardPerToken();
628         lastUpdateTime = lastTimeRewardApplicable();
629         if (account != address(0)) {
630             rewards[account] = earned(account);
631             userRewardPerTokenPaid[account] = rewardPerTokenStored;
632         }
633         _;
634     }
635 
636     /* ========== EVENTS ========== */
637 
638     event RewardAdded(uint256 reward);
639     event Staked(address indexed user, uint256 amount);
640     event Withdrawn(address indexed user, uint256 amount);
641     event RewardPaid(address indexed user, uint256 reward);
642 }
643 
644 interface IRouteERC20 {
645     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
646 }