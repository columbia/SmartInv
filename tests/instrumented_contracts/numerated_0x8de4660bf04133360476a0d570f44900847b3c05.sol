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
27         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
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
159     function transfer(address recipient, uint256 amount)
160         external
161         returns (bool);
162 
163     /**
164      * @dev Returns the remaining number of tokens that `spender` will be
165      * allowed to spend on behalf of `owner` through `transferFrom`. This is
166      * zero by default.
167      *
168      * This value changes when `approve` or `transferFrom` are called.
169      */
170     function allowance(address owner, address spender)
171         external
172         view
173         returns (uint256);
174 
175     /**
176      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * > Beware that changing an allowance with this method brings the risk
181      * that someone may use both the old and the new allowance by unfortunate
182      * transaction ordering. One possible solution to mitigate this race
183      * condition is to first reduce the spender's allowance to 0 and set the
184      * desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      *
187      * Emits an `Approval` event.
188      */
189     function approve(address spender, uint256 amount) external returns (bool);
190 
191     /**
192      * @dev Moves `amount` tokens from `sender` to `recipient` using the
193      * allowance mechanism. `amount` is then deducted from the caller's
194      * allowance.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * Emits a `Transfer` event.
199      */
200     function transferFrom(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) external returns (bool);
205 
206     function mint(address recipient, uint256 amount) external returns (bool);
207 
208     function burn(address spender, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Emitted when `value` tokens are moved from one account (`from`) to
212      * another (`to`).
213      *
214      * Note that `value` may be zero.
215      */
216     event Transfer(address indexed from, address indexed to, uint256 value);
217 
218     /**
219      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
220      * a call to `approve`. `value` is the new allowance.
221      */
222     event Approval(
223         address indexed owner,
224         address indexed spender,
225         uint256 value
226     );
227 }
228 
229 /**
230  * @dev Optional functions from the ERC20 standard.
231  */
232 contract ERC20Detailed is IERC20 {
233     string private _name;
234     string private _symbol;
235     uint8 private _decimals;
236 
237     /**
238      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
239      * these values are immutable: they can only be set once during
240      * construction.
241      */
242     constructor(
243         string memory name,
244         string memory symbol,
245         uint8 decimals
246     ) public {
247         _name = name;
248         _symbol = symbol;
249         _decimals = decimals;
250     }
251 
252     /**
253      * @dev Returns the name of the token.
254      */
255     function name() public view returns (string memory) {
256         return _name;
257     }
258 
259     /**
260      * @dev Returns the symbol of the token, usually a shorter version of the
261      * name.
262      */
263     function symbol() public view returns (string memory) {
264         return _symbol;
265     }
266 
267     /**
268      * @dev Returns the number of decimals used to get its user representation.
269      * For example, if `decimals` equals `2`, a balance of `505` tokens should
270      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
271      *
272      * Tokens usually opt for a value of 18, imitating the relationship between
273      * Ether and Wei.
274      *
275      * > Note that this information is only used for _display_ purposes: it in
276      * no way affects any of the arithmetic of the contract, including
277      * `IERC20.balanceOf` and `IERC20.transfer`.
278      */
279     function decimals() public view returns (uint8) {
280         return _decimals;
281     }
282 }
283 
284 /**
285  * @dev Collection of functions related to the address type,
286  */
287 library Address {
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * This test is non-exhaustive, and there may be false-negatives: during the
292      * execution of a contract's constructor, its address will be reported as
293      * not containing a contract.
294      *
295      * > It is unsafe to assume that an address for which this function returns
296      * false is an externally-owned account (EOA) and not a contract.
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies in extcodesize, which returns 0 for contracts in
300         // construction, since the code is only stored at the end of the
301         // constructor execution.
302 
303         uint256 size;
304         // solhint-disable-next-line no-inline-assembly
305         assembly {
306             size := extcodesize(account)
307         }
308         return size > 0;
309     }
310 }
311 
312 /**
313  * @title SafeERC20
314  * @dev Wrappers around ERC20 operations that throw on failure (when the token
315  * contract returns false). Tokens that return no value (and instead revert or
316  * throw on failure) are also supported, non-reverting calls are assumed to be
317  * successful.
318  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
319  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
320  */
321 library SafeERC20 {
322     using SafeMath for uint256;
323     using Address for address;
324 
325     function safeTransfer(
326         IERC20 token,
327         address to,
328         uint256 value
329     ) internal {
330         callOptionalReturn(
331             token,
332             abi.encodeWithSelector(token.transfer.selector, to, value)
333         );
334     }
335 
336     function safeTransferFrom(
337         IERC20 token,
338         address from,
339         address to,
340         uint256 value
341     ) internal {
342         callOptionalReturn(
343             token,
344             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
345         );
346     }
347 
348     function safeApprove(
349         IERC20 token,
350         address spender,
351         uint256 value
352     ) internal {
353         // safeApprove should only be called when setting an initial allowance,
354         // or when resetting it to zero. To increase and decrease it, use
355         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
356         // solhint-disable-next-line max-line-length
357         require(
358             (value == 0) || (token.allowance(address(this), spender) == 0),
359             "SafeERC20: approve from non-zero to non-zero allowance"
360         );
361         callOptionalReturn(
362             token,
363             abi.encodeWithSelector(token.approve.selector, spender, value)
364         );
365     }
366 
367     function safeIncreaseAllowance(
368         IERC20 token,
369         address spender,
370         uint256 value
371     ) internal {
372         uint256 newAllowance =
373             token.allowance(address(this), spender).add(value);
374         callOptionalReturn(
375             token,
376             abi.encodeWithSelector(
377                 token.approve.selector,
378                 spender,
379                 newAllowance
380             )
381         );
382     }
383 
384     function safeDecreaseAllowance(
385         IERC20 token,
386         address spender,
387         uint256 value
388     ) internal {
389         uint256 newAllowance =
390             token.allowance(address(this), spender).sub(value);
391         callOptionalReturn(
392             token,
393             abi.encodeWithSelector(
394                 token.approve.selector,
395                 spender,
396                 newAllowance
397             )
398         );
399     }
400 
401     /**
402      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
403      * on the return value: the return value is optional (but if data is returned, it must not be false).
404      * @param token The token targeted by the call.
405      * @param data The call data (encoded using abi.encode or one of its variants).
406      */
407     function callOptionalReturn(IERC20 token, bytes memory data) private {
408         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
409         // we're implementing it ourselves.
410 
411         // A Solidity high level call has three parts:
412         //  1. The target address is checked to verify it contains contract code
413         //  2. The call itself is made, and success asserted
414         //  3. The return value is decoded, which in turn checks the size of the returned data.
415         // solhint-disable-next-line max-line-length
416         require(address(token).isContract(), "SafeERC20: call to non-contract");
417 
418         // solhint-disable-next-line avoid-low-level-calls
419         (bool success, bytes memory returndata) = address(token).call(data);
420         require(success, "SafeERC20: low-level call failed");
421 
422         if (returndata.length > 0) {
423             // Return data is optional
424             // solhint-disable-next-line max-line-length
425             require(
426                 abi.decode(returndata, (bool)),
427                 "SafeERC20: ERC20 operation did not succeed"
428             );
429         }
430     }
431 }
432 
433 /**
434  * @dev Contract module that helps prevent reentrant calls to a function.
435  *
436  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
437  * available, which can be aplied to functions to make sure there are no nested
438  * (reentrant) calls to them.
439  *
440  * Note that because there is a single `nonReentrant` guard, functions marked as
441  * `nonReentrant` may not call one another. This can be worked around by making
442  * those functions `private`, and then adding `external` `nonReentrant` entry
443  * points to them.
444  */
445 contract ReentrancyGuard {
446     /// @dev counter to allow mutex lock with only one SSTORE operation
447     uint256 private _guardCounter;
448 
449     constructor() internal {
450         // The counter starts at one to prevent changing it from zero to a non-zero
451         // value, which is a more expensive operation.
452         _guardCounter = 1;
453     }
454 
455     /**
456      * @dev Prevents a contract from calling itself, directly or indirectly.
457      * Calling a `nonReentrant` function from another `nonReentrant`
458      * function is not supported. It is possible to prevent this from happening
459      * by making the `nonReentrant` function external, and make it call a
460      * `private` function that does the actual work.
461      */
462     modifier nonReentrant() {
463         _guardCounter += 1;
464         uint256 localCounter = _guardCounter;
465         _;
466         require(
467             localCounter == _guardCounter,
468             "ReentrancyGuard: reentrant call"
469         );
470     }
471 }
472 
473 // Inheritancea
474 interface IStakingRewards {
475     // Views
476     function lastTimeRewardApplicable() external view returns (uint256);
477 
478     function rewardPerToken() external view returns (uint256);
479 
480     function earned(address account) external view returns (uint256);
481 
482     function getRewardForDuration() external view returns (uint256);
483 
484     function totalSupply() external view returns (uint256);
485 
486     function balanceOf(address account) external view returns (uint256);
487 
488     // Mutative
489 
490     function stake(uint256 amount) external;
491 
492     function withdraw(uint256 amount) external;
493 
494     function getReward() external;
495 
496     function exit() external;
497 }
498 
499 contract RewardsDistributionRecipient {
500     address public rewardsDistribution;
501 
502     function notifyRewardAmount(uint256 reward, uint256 duration) external;
503 
504     modifier onlyRewardsDistribution() {
505         require(
506             msg.sender == rewardsDistribution,
507             "Caller is not RewardsDistribution contract"
508         );
509         _;
510     }
511 }
512 
513 contract StakingRewards is
514     IStakingRewards,
515     RewardsDistributionRecipient,
516     ReentrancyGuard
517 {
518     using SafeMath for uint256;
519     using SafeERC20 for IERC20;
520 
521     /* ========== STATE VARIABLES ========== */
522 
523     IERC20 public rewardsToken;
524     IERC20 public stakingToken;
525     IERC20 public vToken;
526     uint256 public periodFinish = 0;
527     uint256 public rewardRate = 0;
528     uint256 public rewardsDuration = 30 days;
529     uint256 public lastUpdateTime;
530     uint256 public rewardPerTokenStored;
531 
532     mapping(address => uint256) public userRewardPerTokenPaid;
533     mapping(address => uint256) public rewards;
534 
535     uint256 private _totalSupply;
536     mapping(address => uint256) private _balances;
537 
538     /* ========== CONSTRUCTOR ========== */
539 
540     constructor(
541         address _rewardsDistribution,
542         address _rewardsToken,
543         address _stakingToken
544     ) public {
545         rewardsToken = IERC20(_rewardsToken);
546         stakingToken = IERC20(_stakingToken);
547         rewardsDistribution = _rewardsDistribution;
548     }
549 
550     /* ========== VIEWS ========== */
551 
552     function setVtoken(address _addr) external onlyRewardsDistribution {
553         vToken = IERC20(_addr);
554     }
555 
556     function totalSupply() external view returns (uint256) {
557         return _totalSupply;
558     }
559 
560     function balanceOf(address account) external view returns (uint256) {
561         return _balances[account];
562     }
563 
564     function lastTimeRewardApplicable() public view returns (uint256) {
565         return Math.min(block.timestamp, periodFinish);
566     }
567 
568     function rewardPerToken() public view returns (uint256) {
569         if (_totalSupply == 0) {
570             return rewardPerTokenStored;
571         }
572         return
573             rewardPerTokenStored.add(
574                 lastTimeRewardApplicable()
575                     .sub(lastUpdateTime)
576                     .mul(rewardRate)
577                     .mul(1e18)
578                     .div(_totalSupply)
579             );
580     }
581 
582     function earned(address account) public view returns (uint256) {
583         return
584             _balances[account]
585                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
586                 .div(1e18)
587                 .add(rewards[account]);
588     }
589 
590     function getRewardForDuration() external view returns (uint256) {
591         return rewardRate.mul(rewardsDuration);
592     }
593 
594     /* ========== MUTATIVE FUNCTIONS ========== */
595 
596     function stake(uint256 amount)
597         external
598         nonReentrant
599         updateReward(msg.sender)
600     {
601         require(amount > 0, "Cannot stake 0");
602         _totalSupply = _totalSupply.add(amount);
603         _balances[msg.sender] = _balances[msg.sender].add(amount);
604         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
605         vToken.mint(msg.sender, amount);
606         emit Staked(msg.sender, amount);
607     }
608 
609     function withdraw(uint256 amount)
610         public
611         nonReentrant
612         updateReward(msg.sender)
613     {
614         require(amount > 0, "Cannot withdraw 0");
615         _totalSupply = _totalSupply.sub(amount);
616         _balances[msg.sender] = _balances[msg.sender].sub(amount);
617         stakingToken.safeTransfer(msg.sender, amount);
618         vToken.burn(msg.sender, amount);
619         emit Withdrawn(msg.sender, amount);
620     }
621 
622     function getReward() public nonReentrant updateReward(msg.sender) {
623         uint256 reward = rewards[msg.sender];
624         require(reward > 0, "Reward can not be 0!");
625         rewards[msg.sender] = 0;
626         rewardsToken.safeTransfer(msg.sender, reward);
627         emit RewardPaid(msg.sender, reward);
628     }
629 
630     function exit() external {
631         withdraw(_balances[msg.sender]);
632         getReward();
633     }
634 
635     /* ========== RESTRICTED FUNCTIONS ========== */
636 
637     function notifyRewardAmount(uint256 reward, uint256 _rewardsDuration)
638         external
639         onlyRewardsDistribution
640         updateReward(address(0))
641     {
642         // Ensure the provided reward amount is not more than the balance in the contract.
643         // This keeps the reward rate in the right range, preventing overflows due to
644         // very high values of rewardRate in the earned and rewardsPerToken functions;
645         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
646         uint256 balance = rewardsToken.balanceOf(address(this));
647         if (block.timestamp >= periodFinish) {
648             rewardsDuration = _rewardsDuration;
649             rewardRate = reward.div(rewardsDuration);
650             require(
651                 rewardRate <= balance.div(rewardsDuration),
652                 "Provided reward too high"
653             );
654             periodFinish = block.timestamp.add(rewardsDuration);
655         } else {
656             uint256 remaining = periodFinish.sub(block.timestamp);
657             uint256 leftover = remaining.mul(rewardRate);
658             rewardRate = reward.add(leftover).div(remaining);
659             require(
660                 rewardRate <= balance.div(remaining),
661                 "Provided reward too high"
662             );
663         }
664 
665         lastUpdateTime = block.timestamp;
666         emit RewardAdded(reward, _rewardsDuration);
667     }
668 
669     /* ========== MODIFIERS ========== */
670 
671     modifier updateReward(address account) {
672         rewardPerTokenStored = rewardPerToken();
673         lastUpdateTime = lastTimeRewardApplicable();
674         if (account != address(0)) {
675             rewards[account] = earned(account);
676             userRewardPerTokenPaid[account] = rewardPerTokenStored;
677         }
678         _;
679     }
680 
681     /* ========== EVENTS ========== */
682 
683     event RewardAdded(uint256 reward, uint256 duration);
684     event Staked(address indexed user, uint256 amount);
685     event Withdrawn(address indexed user, uint256 amount);
686     event RewardPaid(address indexed user, uint256 reward);
687 }
688 
689 interface IUniswapV2ERC20 {
690     function permit(
691         address owner,
692         address spender,
693         uint256 value,
694         uint256 deadline,
695         uint8 v,
696         bytes32 r,
697         bytes32 s
698     ) external;
699 }