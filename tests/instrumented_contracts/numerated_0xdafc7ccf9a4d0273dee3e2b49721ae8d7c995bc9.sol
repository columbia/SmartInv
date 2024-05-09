1 //   _________ _______   ________  __      __  _________ __                        
2 //  /   _____/ \      \  \_____  \/  \    /  \/   _____//  |_  ___________  _____  
3 //  \_____  \  /   |   \  /   |   \   \/\/   /\_____  \\   __\/  _ \_  __ \/     \ 
4 //  /        \/    |    \/    |    \        / /        \|  | (  <_> )  | \/  Y Y  \
5 // /_______  /\____|__  /\_______  /\__/\  / /_______  /|__|  \____/|__|  |__|_|  /
6 //         \/         \/         \/      \/          \/                         \/ 
7 
8 // Snowstorm token geyser rewards contract
9 // Based off SNX and UNI staking contracts
10 
11 pragma solidity ^0.5.16;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
15  * the optional functions; to access them see `ERC20Detailed`.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a `Transfer` event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through `transferFrom`. This is
40      * zero by default.
41      *
42      * This value changes when `approve` or `transferFrom` are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * > Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an `Approval` event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a `Transfer` event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to `approve`. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 /**
89  * @dev Contract module which provides a basic access control mechanism, where
90  * there is an account (an owner) that can be granted exclusive access to
91  * specific functions.
92  *
93  * This module is used through inheritance. It will make available the modifier
94  * `onlyOwner`, which can be aplied to your functions to restrict their use to
95  * the owner.
96  */
97 contract Ownable {
98     address private _owner;
99 
100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102     /**
103      * @dev Initializes the contract setting the deployer as the initial owner.
104      */
105     constructor () internal {
106         _owner = msg.sender;
107         emit OwnershipTransferred(address(0), _owner);
108     }
109 
110     /**
111      * @dev Returns the address of the current owner.
112      */
113     function owner() public view returns (address) {
114         return _owner;
115     }
116 
117     /**
118      * @dev Throws if called by any account other than the owner.
119      */
120     modifier onlyOwner() {
121         require(isOwner(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     /**
126      * @dev Returns true if the caller is the current owner.
127      */
128     function isOwner() public view returns (bool) {
129         return msg.sender == _owner;
130     }
131 
132     /**
133      * @dev Leaves the contract without owner. It will not be possible to call
134      * `onlyOwner` functions anymore. Can only be called by the current owner.
135      *
136      * > Note: Renouncing ownership will leave the contract without an owner,
137      * thereby removing any functionality that is only available to the owner.
138      */
139     function renounceOwnership() public onlyOwner {
140         emit OwnershipTransferred(_owner, address(0));
141         _owner = address(0);
142     }
143 
144     /**
145      * @dev Transfers ownership of the contract to a new account (`newOwner`).
146      * Can only be called by the current owner.
147      */
148     function transferOwnership(address newOwner) public onlyOwner {
149         _transferOwnership(newOwner);
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      */
155     function _transferOwnership(address newOwner) internal {
156         require(newOwner != address(0), "Ownable: new owner is the zero address");
157         emit OwnershipTransferred(_owner, newOwner);
158         _owner = newOwner;
159     }
160 }
161 
162 /**
163  * @dev Wrappers over Solidity's arithmetic operations with added overflow
164  * checks.
165  *
166  * Arithmetic operations in Solidity wrap on overflow. This can easily result
167  * in bugs, because programmers usually assume that an overflow raises an
168  * error, which is the standard behavior in high level programming languages.
169  * `SafeMath` restores this intuition by reverting the transaction when an
170  * operation overflows.
171  *
172  * Using this library instead of the unchecked operations eliminates an entire
173  * class of bugs, so it's recommended to use it always.
174  */
175 library SafeMath {
176     /**
177      * @dev Returns the addition of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `+` operator.
181      *
182      * Requirements:
183      * - Addition cannot overflow.
184      */
185     function add(uint256 a, uint256 b) internal pure returns (uint256) {
186         uint256 c = a + b;
187         require(c >= a, "SafeMath: addition overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting on
194      * overflow (when the result is negative).
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      * - Subtraction cannot overflow.
200      */
201     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202         require(b <= a, "SafeMath: subtraction overflow");
203         uint256 c = a - b;
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the multiplication of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `*` operator.
213      *
214      * Requirements:
215      * - Multiplication cannot overflow.
216      */
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
219         // benefit is lost if 'b' is also tested.
220         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
221         if (a == 0) {
222             return 0;
223         }
224 
225         uint256 c = a * b;
226         require(c / a == b, "SafeMath: multiplication overflow");
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b) internal pure returns (uint256) {
243         // Solidity only automatically asserts when dividing by 0
244         require(b > 0, "SafeMath: division by zero");
245         uint256 c = a / b;
246         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         require(b != 0, "SafeMath: modulo by zero");
264         return a % b;
265     }
266 }
267 
268 /**
269  * @dev Standard math utilities missing in the Solidity language.
270  */
271 library Math {
272     /**
273      * @dev Returns the largest of two numbers.
274      */
275     function max(uint256 a, uint256 b) internal pure returns (uint256) {
276         return a >= b ? a : b;
277     }
278 
279     /**
280      * @dev Returns the smallest of two numbers.
281      */
282     function min(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a < b ? a : b;
284     }
285 
286     /**
287      * @dev Returns the average of two numbers. The result is rounded towards
288      * zero.
289      */
290     function average(uint256 a, uint256 b) internal pure returns (uint256) {
291         // (a + b) / 2 can overflow, so we distribute
292         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
293     }
294 }
295 
296 /**
297  * @dev Optional functions from the ERC20 standard.
298  */
299 contract ERC20Detailed is IERC20 {
300     string private _name;
301     string private _symbol;
302     uint8 private _decimals;
303 
304     /**
305      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
306      * these values are immutable: they can only be set once during
307      * construction.
308      */
309     constructor (string memory name, string memory symbol, uint8 decimals) public {
310         _name = name;
311         _symbol = symbol;
312         _decimals = decimals;
313     }
314 
315     /**
316      * @dev Returns the name of the token.
317      */
318     function name() public view returns (string memory) {
319         return _name;
320     }
321 
322     /**
323      * @dev Returns the symbol of the token, usually a shorter version of the
324      * name.
325      */
326     function symbol() public view returns (string memory) {
327         return _symbol;
328     }
329 
330     /**
331      * @dev Returns the number of decimals used to get its user representation.
332      * For example, if `decimals` equals `2`, a balance of `505` tokens should
333      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
334      *
335      * Tokens usually opt for a value of 18, imitating the relationship between
336      * Ether and Wei.
337      *
338      * > Note that this information is only used for _display_ purposes: it in
339      * no way affects any of the arithmetic of the contract, including
340      * `IERC20.balanceOf` and `IERC20.transfer`.
341      */
342     function decimals() public view returns (uint8) {
343         return _decimals;
344     }
345 }
346 
347 /**
348  * @dev Collection of functions related to the address type,
349  */
350 library Address {
351     /**
352      * @dev Returns true if `account` is a contract.
353      *
354      * This test is non-exhaustive, and there may be false-negatives: during the
355      * execution of a contract's constructor, its address will be reported as
356      * not containing a contract.
357      *
358      * > It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      */
361     function isContract(address account) internal view returns (bool) {
362         // This method relies in extcodesize, which returns 0 for contracts in
363         // construction, since the code is only stored at the end of the
364         // constructor execution.
365 
366         uint256 size;
367         // solhint-disable-next-line no-inline-assembly
368         assembly { size := extcodesize(account) }
369         return size > 0;
370     }
371 }
372 
373 /**
374  * @title SafeERC20
375  * @dev Wrappers around ERC20 operations that throw on failure (when the token
376  * contract returns false). Tokens that return no value (and instead revert or
377  * throw on failure) are also supported, non-reverting calls are assumed to be
378  * successful.
379  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
380  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
381  */
382 library SafeERC20 {
383     using SafeMath for uint256;
384     using Address for address;
385 
386     function safeTransfer(IERC20 token, address to, uint256 value) internal {
387         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
388     }
389 
390     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
391         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
392     }
393 
394     function safeApprove(IERC20 token, address spender, uint256 value) internal {
395         // safeApprove should only be called when setting an initial allowance,
396         // or when resetting it to zero. To increase and decrease it, use
397         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
398         // solhint-disable-next-line max-line-length
399         require((value == 0) || (token.allowance(address(this), spender) == 0),
400             "SafeERC20: approve from non-zero to non-zero allowance"
401         );
402         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
403     }
404 
405     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
406         uint256 newAllowance = token.allowance(address(this), spender).add(value);
407         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
408     }
409 
410     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
411         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
412         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
413     }
414 
415     /**
416      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
417      * on the return value: the return value is optional (but if data is returned, it must not be false).
418      * @param token The token targeted by the call.
419      * @param data The call data (encoded using abi.encode or one of its variants).
420      */
421     function callOptionalReturn(IERC20 token, bytes memory data) private {
422         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
423         // we're implementing it ourselves.
424 
425         // A Solidity high level call has three parts:
426         //  1. The target address is checked to verify it contains contract code
427         //  2. The call itself is made, and success asserted
428         //  3. The return value is decoded, which in turn checks the size of the returned data.
429         // solhint-disable-next-line max-line-length
430         require(address(token).isContract(), "SafeERC20: call to non-contract");
431 
432         // solhint-disable-next-line avoid-low-level-calls
433         (bool success, bytes memory returndata) = address(token).call(data);
434         require(success, "SafeERC20: low-level call failed");
435 
436         if (returndata.length > 0) { // Return data is optional
437             // solhint-disable-next-line max-line-length
438             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
439         }
440     }
441 }
442 
443 /**
444  * @dev Contract module that helps prevent reentrant calls to a function.
445  *
446  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
447  * available, which can be aplied to functions to make sure there are no nested
448  * (reentrant) calls to them.
449  *
450  * Note that because there is a single `nonReentrant` guard, functions marked as
451  * `nonReentrant` may not call one another. This can be worked around by making
452  * those functions `private`, and then adding `external` `nonReentrant` entry
453  * points to them.
454  */
455 contract ReentrancyGuard {
456     /// @dev counter to allow mutex lock with only one SSTORE operation
457     uint256 private _guardCounter;
458 
459     constructor () internal {
460         // The counter starts at one to prevent changing it from zero to a non-zero
461         // value, which is a more expensive operation.
462         _guardCounter = 1;
463     }
464 
465     /**
466      * @dev Prevents a contract from calling itself, directly or indirectly.
467      * Calling a `nonReentrant` function from another `nonReentrant`
468      * function is not supported. It is possible to prevent this from happening
469      * by making the `nonReentrant` function external, and make it call a
470      * `private` function that does the actual work.
471      */
472     modifier nonReentrant() {
473         _guardCounter += 1;
474         uint256 localCounter = _guardCounter;
475         _;
476         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
477     }
478 }
479 
480 // Inheritance
481 interface IStakingRewards {
482     // Views
483     function lastTimeRewardApplicable() external view returns (uint256);
484 
485     function rewardPerToken() external view returns (uint256);
486 
487     function earned(address account) external view returns (uint256);
488 
489     function getRewardForDuration() external view returns (uint256);
490 
491     function totalSupply() external view returns (uint256);
492 
493     function balanceOf(address account) external view returns (uint256);
494 
495     // Mutative
496 
497     function stake(uint256 amount) external;
498 
499     function withdraw(uint256 amount) external;
500 
501     function getReward() external;
502 
503     function exit() external;
504 }
505 
506 contract RewardsDistributionRecipient {
507     address public rewardsDistribution;
508 
509     function notifyRewardAmount(uint256 reward) external;
510 
511     modifier onlyRewardsDistribution() {
512         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
513         _;
514     }
515 }
516 
517 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
518     using SafeMath for uint256;
519     using SafeERC20 for IERC20;
520 
521     /* ========== STATE VARIABLES ========== */
522 
523     IERC20 public rewardsToken;
524     IERC20 public stakingToken;
525     uint256 public periodFinish = 0;
526     uint256 public rewardRate = 0;
527     uint256 public rewardsDuration = 14 days;
528     uint256 public lastUpdateTime;
529     uint256 public rewardPerTokenStored;
530 
531     mapping(address => uint256) public userRewardPerTokenPaid;
532     mapping(address => uint256) public rewards;
533 
534     uint256 private _totalSupply;
535     mapping(address => uint256) private _balances;
536 
537     /* ========== CONSTRUCTOR ========== */
538 
539     constructor(
540         address _rewardsDistribution,
541         address _rewardsToken,
542         address _stakingToken
543     ) public {
544         rewardsToken = IERC20(_rewardsToken);
545         stakingToken = IERC20(_stakingToken);
546         rewardsDistribution = _rewardsDistribution;
547     }
548 
549     /* ========== VIEWS ========== */
550 
551     function totalSupply() external view returns (uint256) {
552         return _totalSupply;
553     }
554 
555     function balanceOf(address account) external view returns (uint256) {
556         return _balances[account];
557     }
558 
559     function lastTimeRewardApplicable() public view returns (uint256) {
560         return Math.min(block.timestamp, periodFinish);
561     }
562 
563     function rewardPerToken() public view returns (uint256) {
564         if (_totalSupply == 0) {
565             return rewardPerTokenStored;
566         }
567         return
568             rewardPerTokenStored.add(
569                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
570             );
571     }
572 
573     function earned(address account) public view returns (uint256) {
574         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
575     }
576 
577     function getRewardForDuration() external view returns (uint256) {
578         return rewardRate.mul(rewardsDuration);
579     }
580 
581     /* ========== MUTATIVE FUNCTIONS ========== */
582 
583     // not using stake with permit or uniswap tokens 
584 
585     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
586         require(amount > 0, "Cannot stake 0");
587         _totalSupply = _totalSupply.add(amount);
588         _balances[msg.sender] = _balances[msg.sender].add(amount);
589 
590         // permit
591         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
592 
593         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
594         emit Staked(msg.sender, amount);
595     }
596 
597     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
598         require(amount > 0, "Cannot stake 0");
599         _totalSupply = _totalSupply.add(amount);
600         _balances[msg.sender] = _balances[msg.sender].add(amount);
601         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
602         emit Staked(msg.sender, amount);
603     }
604 
605     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
606         require(amount > 0, "Cannot withdraw 0");
607         _totalSupply = _totalSupply.sub(amount);
608         _balances[msg.sender] = _balances[msg.sender].sub(amount);
609         stakingToken.safeTransfer(msg.sender, amount);
610         emit Withdrawn(msg.sender, amount);
611     }
612 
613     function getReward() public nonReentrant updateReward(msg.sender) {
614         uint256 reward = rewards[msg.sender];
615         if (reward > 0) {
616             rewards[msg.sender] = 0;
617             rewardsToken.safeTransfer(msg.sender, reward);
618             emit RewardPaid(msg.sender, reward);
619         }
620     }
621 
622     function exit() external {
623         withdraw(_balances[msg.sender]);
624         getReward();
625     }
626 
627     /* ========== RESTRICTED FUNCTIONS ========== */
628 
629     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
630         if (block.timestamp >= periodFinish) {
631             rewardRate = reward.div(rewardsDuration);
632         } else {
633             uint256 remaining = periodFinish.sub(block.timestamp);
634             uint256 leftover = remaining.mul(rewardRate);
635             rewardRate = reward.add(leftover).div(rewardsDuration);
636         }
637 
638         // Ensure the provided reward amount is not more than the balance in the contract.
639         // This keeps the reward rate in the right range, preventing overflows due to
640         // very high values of rewardRate in the earned and rewardsPerToken functions;
641         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
642         uint balance = rewardsToken.balanceOf(address(this));
643         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
644 
645         lastUpdateTime = block.timestamp;
646         periodFinish = block.timestamp.add(rewardsDuration);
647         emit RewardAdded(reward);
648     }
649 
650     /* ========== MODIFIERS ========== */
651 
652     modifier updateReward(address account) {
653         rewardPerTokenStored = rewardPerToken();
654         lastUpdateTime = lastTimeRewardApplicable();
655 
656         if (account != address(0)) {
657             // bonus intial liquidity to bootstrap curve
658             if (_totalSupply == 0) {
659                 rewards[account] = rewardRate.mul(rewardsDuration).mul(1e17).div(1e18).add(earned(account));
660 
661                 // Ensure the provided reward amount is not more than the balance in the contract.
662                 // This keeps the reward rate in the right range, preventing overflows due to
663                 // very high values of rewardRate in the earned and rewardsPerToken functions;
664                 // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
665                 uint balance = rewardsToken.balanceOf(address(this));
666                 require(rewards[account] <= balance, "Provided reward too high");
667             }
668             rewards[account] = earned(account);
669 
670             userRewardPerTokenPaid[account] = rewardPerTokenStored;
671         }
672         _;
673     }
674     /* ========== EVENTS ========== */
675 
676     event RewardAdded(uint256 reward);
677     event Staked(address indexed user, uint256 amount);
678     event Withdrawn(address indexed user, uint256 amount);
679     event RewardPaid(address indexed user, uint256 reward);
680 }
681 
682 interface IUniswapV2ERC20 {
683     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
684 }