1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 pragma solidity 0.5.16;
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
33 // File: @openzeppelin/contracts/math/SafeMath.sol
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
75         return sub(a, b, "SafeMath: subtraction overflow");
76     }
77 
78     /**
79      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
80      * overflow (when the result is negative).
81      *
82      * Counterpart to Solidity's `-` operator.
83      *
84      * Requirements:
85      * - Subtraction cannot overflow.
86      *
87      * _Available since v2.4.0._
88      */
89     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b <= a, errorMessage);
91         uint256 c = a - b;
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the multiplication of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `*` operator.
101      *
102      * Requirements:
103      * - Multiplication cannot overflow.
104      */
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
107         // benefit is lost if 'b' is also tested.
108         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
109         if (a == 0) {
110             return 0;
111         }
112 
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the integer division of two unsigned integers. Reverts on
121      * division by zero. The result is rounded towards zero.
122      *
123      * Counterpart to Solidity's `/` operator. Note: this function uses a
124      * `revert` opcode (which leaves remaining gas untouched) while Solidity
125      * uses an invalid opcode to revert (consuming all remaining gas).
126      *
127      * Requirements:
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return div(a, b, "SafeMath: division by zero");
132     }
133 
134     /**
135      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
136      * division by zero. The result is rounded towards zero.
137      *
138      * Counterpart to Solidity's `/` operator. Note: this function uses a
139      * `revert` opcode (which leaves remaining gas untouched) while Solidity
140      * uses an invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      *
145      * _Available since v2.4.0._
146      */
147     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         // Solidity only automatically asserts when dividing by 0
149         require(b > 0, errorMessage);
150         uint256 c = a / b;
151         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * Reverts when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return mod(a, b, "SafeMath: modulo by zero");
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts with custom message when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      *
182      * _Available since v2.4.0._
183      */
184     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/GSN/Context.sol
191 /*
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with GSN meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 contract Context {
202     // Empty internal constructor, to prevent people from mistakenly deploying
203     // an instance of this contract, which should be used via inheritance.
204     constructor () internal { }
205     // solhint-disable-previous-line no-empty-blocks
206 
207     function _msgSender() internal view returns (address payable) {
208         return msg.sender;
209     }
210 
211     function _msgData() internal view returns (bytes memory) {
212         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
213         return msg.data;
214     }
215 }
216 
217 // File: @openzeppelin/contracts/ownership/Ownable.sol
218 /**
219  * @dev Contract module which provides a basic access control mechanism, where
220  * there is an account (an owner) that can be granted exclusive access to
221  * specific functions.
222  *
223  * This module is used through inheritance. It will make available the modifier
224  * `onlyOwner`, which can be applied to your functions to restrict their use to
225  * the owner.
226  */
227 contract Ownable is Context {
228     address private _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232     /**
233      * @dev Initializes the contract setting the deployer as the initial owner.
234      */
235     constructor () internal {
236         _owner = _msgSender();
237         emit OwnershipTransferred(address(0), _owner);
238     }
239 
240     /**
241      * @dev Returns the address of the current owner.
242      */
243     function owner() public view returns (address) {
244         return _owner;
245     }
246 
247     /**
248      * @dev Throws if called by any account other than the owner.
249      */
250     modifier onlyOwner() {
251         require(isOwner(), "Ownable: caller is not the owner");
252         _;
253     }
254 
255     /**
256      * @dev Returns true if the caller is the current owner.
257      */
258     function isOwner() public view returns (bool) {
259         return _msgSender() == _owner;
260     }
261 
262     /**
263      * @dev Leaves the contract without owner. It will not be possible to call
264      * `onlyOwner` functions anymore. Can only be called by the current owner.
265      *
266      * NOTE: Renouncing ownership will leave the contract without an owner,
267      * thereby removing any functionality that is only available to the owner.
268      */
269     function renounceOwnership() public onlyOwner {
270         emit OwnershipTransferred(_owner, address(0));
271         _owner = address(0);
272     }
273 
274     /**
275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
276      * Can only be called by the current owner.
277      */
278     function transferOwnership(address newOwner) public onlyOwner {
279         _transferOwnership(newOwner);
280     }
281 
282     /**
283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
284      */
285     function _transferOwnership(address newOwner) internal {
286         require(newOwner != address(0), "Ownable: new owner is the zero address");
287         emit OwnershipTransferred(_owner, newOwner);
288         _owner = newOwner;
289     }
290 }
291 
292 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
293 /**
294  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
295  * the optional functions; to access them see {ERC20Detailed}.
296  */
297 interface IERC20 {
298     /**
299      * @dev Returns the amount of tokens in existence.
300      */
301     function totalSupply() external view returns (uint256);
302 
303     /**
304      * @dev Returns the amount of tokens owned by `account`.
305      */
306     function balanceOf(address account) external view returns (uint256);
307 
308     /**
309      * @dev Moves `amount` tokens from the caller's account to `recipient`.
310      *
311      * Returns a boolean value indicating whether the operation succeeded.
312      *
313      * Emits a {Transfer} event.
314      */
315     function transfer(address recipient, uint256 amount) external returns (bool);
316     function mint(address account, uint amount) external;
317 
318     /**
319      * @dev Returns the remaining number of tokens that `spender` will be
320      * allowed to spend on behalf of `owner` through {transferFrom}. This is
321      * zero by default.
322      *
323      * This value changes when {approve} or {transferFrom} are called.
324      */
325     function allowance(address owner, address spender) external view returns (uint256);
326 
327     /**
328      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
329      *
330      * Returns a boolean value indicating whether the operation succeeded.
331      *
332      * IMPORTANT: Beware that changing an allowance with this method brings the risk
333      * that someone may use both the old and the new allowance by unfortunate
334      * transaction ordering. One possible solution to mitigate this race
335      * condition is to first reduce the spender's allowance to 0 and set the
336      * desired value afterwards:
337      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
338      *
339      * Emits an {Approval} event.
340      */
341     function approve(address spender, uint256 amount) external returns (bool);
342 
343     /**
344      * @dev Moves `amount` tokens from `sender` to `recipient` using the
345      * allowance mechanism. `amount` is then deducted from the caller's
346      * allowance.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Emitted when `value` tokens are moved from one account (`from`) to
356      * another (`to`).
357      *
358      * Note that `value` may be zero.
359      */
360     event Transfer(address indexed from, address indexed to, uint256 value);
361 
362     /**
363      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
364      * a call to {approve}. `value` is the new allowance.
365      */
366     event Approval(address indexed owner, address indexed spender, uint256 value);
367 }
368 
369 // File: @openzeppelin/contracts/utils/Address.sol
370 /**
371  * @dev Collection of functions related to the address type
372  */
373 library Address {
374     /**
375      * @dev Returns true if `account` is a contract.
376      *
377      * This test is non-exhaustive, and there may be false-negatives: during the
378      * execution of a contract's constructor, its address will be reported as
379      * not containing a contract.
380      *
381      * IMPORTANT: It is unsafe to assume that an address for which this
382      * function returns false is an externally-owned account (EOA) and not a
383      * contract.
384      */
385     function isContract(address account) internal view returns (bool) {
386         // This method relies in extcodesize, which returns 0 for contracts in
387         // construction, since the code is only stored at the end of the
388         // constructor execution.
389 
390         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
391         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
392         // for accounts without code, i.e. `keccak256('')`
393         bytes32 codehash;
394         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
395         // solhint-disable-next-line no-inline-assembly
396         assembly { codehash := extcodehash(account) }
397         return (codehash != 0x0 && codehash != accountHash);
398     }
399 
400     /**
401      * @dev Converts an `address` into `address payable`. Note that this is
402      * simply a type cast: the actual underlying value is not changed.
403      *
404      * _Available since v2.4.0._
405      */
406     function toPayable(address account) internal pure returns (address payable) {
407         return address(uint160(account));
408     }
409 
410     /**
411      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
412      * `recipient`, forwarding all available gas and reverting on errors.
413      *
414      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
415      * of certain opcodes, possibly making contracts go over the 2300 gas limit
416      * imposed by `transfer`, making them unable to receive funds via
417      * `transfer`. {sendValue} removes this limitation.
418      *
419      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
420      *
421      * IMPORTANT: because control is transferred to `recipient`, care must be
422      * taken to not create reentrancy vulnerabilities. Consider using
423      * {ReentrancyGuard} or the
424      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
425      *
426      * _Available since v2.4.0._
427      */
428     function sendValue(address payable recipient, uint256 amount) internal {
429         require(address(this).balance >= amount, "Address: insufficient balance");
430 
431         // solhint-disable-next-line avoid-call-value
432         (bool success, ) = recipient.call.value(amount)("");
433         require(success, "Address: unable to send value, recipient may have reverted");
434     }
435 }
436 
437 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
438 
439 /**
440  * @title SafeERC20
441  * @dev Wrappers around ERC20 operations that throw on failure (when the token
442  * contract returns false). Tokens that return no value (and instead revert or
443  * throw on failure) are also supported, non-reverting calls are assumed to be
444  * successful.
445  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
446  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
447  */
448 library SafeERC20 {
449     using SafeMath for uint256;
450     using Address for address;
451 
452     function safeTransfer(IERC20 token, address to, uint256 value) internal {
453         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
454     }
455 
456     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
457         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
458     }
459 
460     function safeApprove(IERC20 token, address spender, uint256 value) internal {
461         // safeApprove should only be called when setting an initial allowance,
462         // or when resetting it to zero. To increase and decrease it, use
463         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
464         // solhint-disable-next-line max-line-length
465         require((value == 0) || (token.allowance(address(this), spender) == 0),
466             "SafeERC20: approve from non-zero to non-zero allowance"
467         );
468         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
469     }
470 
471     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
472         uint256 newAllowance = token.allowance(address(this), spender).add(value);
473         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
474     }
475 
476     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
477         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
478         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
479     }
480 
481     /**
482      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
483      * on the return value: the return value is optional (but if data is returned, it must not be false).
484      * @param token The token targeted by the call.
485      * @param data The call data (encoded using abi.encode or one of its variants).
486      */
487     function callOptionalReturn(IERC20 token, bytes memory data) private {
488         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
489         // we're implementing it ourselves.
490 
491         // A Solidity high level call has three parts:
492         //  1. The target address is checked to verify it contains contract code
493         //  2. The call itself is made, and success asserted
494         //  3. The return value is decoded, which in turn checks the size of the returned data.
495         // solhint-disable-next-line max-line-length
496         require(address(token).isContract(), "SafeERC20: call to non-contract");
497 
498         // solhint-disable-next-line avoid-low-level-calls
499         (bool success, bytes memory returndata) = address(token).call(data);
500         require(success, "SafeERC20: low-level call failed");
501 
502         if (returndata.length > 0) { // Return data is optional
503             // solhint-disable-next-line max-line-length
504             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
505         }
506     }
507 }
508 
509 /**
510  * Reward Amount Interface
511  */
512 contract IRewardDistributionRecipient is Ownable {
513     address rewardDistribution;
514 
515     function notifyRewardAmount(uint256 reward) external;
516 
517     modifier onlyRewardDistribution() {
518         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
519         _;
520     }
521 
522     function setRewardDistribution(address _rewardDistribution)
523         external
524         onlyOwner
525     {
526         rewardDistribution = _rewardDistribution;
527     }
528 }
529 
530 /**
531  * Staking Token Wrapper
532  */
533 contract HDTTokenWrapper {
534     using SafeMath for uint256;
535     using SafeERC20 for IERC20;
536 
537     //WETH
538     IERC20 public stakeToken = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); 
539 
540     uint256 private _totalSupply;
541     mapping(address => uint256) private _balances;
542 
543     function totalSupply() public view returns (uint256) {
544         return _totalSupply;
545     }
546 
547     function balanceOf(address account) public view returns (uint256) {
548         return _balances[account];
549     }
550 
551     function stake(uint256 amount) public {
552         _totalSupply = _totalSupply.add(amount);
553         _balances[msg.sender] = _balances[msg.sender].add(amount);
554         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
555     }
556 
557     function withdraw(uint256 amount) public {
558         _totalSupply = _totalSupply.sub(amount);
559         _balances[msg.sender] = _balances[msg.sender].sub(amount);
560         stakeToken.safeTransfer(msg.sender, amount);
561     }
562 }
563 
564 /**
565  * HDT-WETH Pool
566  */
567 contract HDTWETHPool is HDTTokenWrapper, IRewardDistributionRecipient {
568     IERC20 public hdt = IERC20(0x1cc945Be7d0D2C852d0096A8b5714b44eD21D5D3);
569     uint256 public constant DURATION = 7 days;
570 
571     uint256 public constant startTime = 1600862400; //utc+8 2020-09-23 20:00:00
572     uint256 public periodFinish = 0;
573     uint256 public rewardRate = 0;
574     uint256 public lastUpdateTime;
575     uint256 public rewardPerTokenStored;
576     bool private open = true;
577     mapping(address => uint256) public userRewardPerTokenPaid; 
578     mapping(address => uint256) public rewards; // Unclaimed rewards
579 
580     event RewardAdded(uint256 reward);
581     event Staked(address indexed user, uint256 amount);
582     event Withdrawn(address indexed user, uint256 amount);
583     event RewardPaid(address indexed user, uint256 reward);
584     event SetOpen(bool _open);
585 
586     modifier updateReward(address account) {
587         rewardPerTokenStored = rewardPerToken();
588         lastUpdateTime = lastTimeRewardApplicable();
589         if (account != address(0)) {
590             rewards[account] = earned(account);
591             userRewardPerTokenPaid[account] = rewardPerTokenStored;
592         }
593         _;
594     }
595 
596     function lastTimeRewardApplicable() public view returns (uint256) {
597         return Math.min(block.timestamp, periodFinish);
598     }
599 
600     /**
601      * Calculate the rewards for each token
602      */
603     function rewardPerToken() public view returns (uint256) {
604         if (totalSupply() == 0) {
605             return rewardPerTokenStored;
606         }
607         return
608             rewardPerTokenStored.add(
609                 lastTimeRewardApplicable()
610                     .sub(lastUpdateTime)
611                     .mul(rewardRate)
612                     .mul(1e18)
613                     .div(totalSupply())
614             );
615     }
616 
617     function earned(address account) public view returns (uint256) {
618         return
619             balanceOf(account)
620                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
621                 .div(1e18)
622                 .add(rewards[account]);
623     }
624 
625     function stake(uint256 amount) public checkOpen checkStart updateReward(msg.sender){ 
626         require(amount > 0, "HDT-WETH-POOL: Cannot stake 0");
627         super.stake(amount);
628         emit Staked(msg.sender, amount);
629     }
630 
631     function withdraw(uint256 amount) public checkStart updateReward(msg.sender) {
632         require(amount > 0, "HDT-WETH-POOL: Cannot withdraw 0");
633         super.withdraw(amount);
634         emit Withdrawn(msg.sender, amount);
635     }
636 
637     function exit() external {
638         withdraw(balanceOf(msg.sender));
639         getReward();
640     }
641 
642     function getReward() public checkStart updateReward(msg.sender){
643         uint256 reward = earned(msg.sender);
644         if (reward > 0) {
645             rewards[msg.sender] = 0;
646             hdt.safeTransfer(msg.sender, reward);
647             emit RewardPaid(msg.sender, reward);
648         }
649     }
650 
651     modifier checkStart(){
652         require(block.timestamp > startTime,"HDT-WETH-POOL: Not start");
653         _;
654     }
655 
656     modifier checkOpen() {
657         require(open, "HDT-WETH-POOL: Pool is closed");
658         _;
659     }
660 
661     function getPeriodFinish() public view returns (uint256) {
662         return periodFinish;
663     }
664 
665     function isOpen() public view returns (bool) {
666         return open;
667     }
668 
669     function setOpen(bool _open) external onlyOwner {
670         open = _open;
671         emit SetOpen(_open);
672     }
673 
674     function notifyRewardAmount(uint256 reward)
675         external
676         onlyRewardDistribution
677         checkOpen
678         updateReward(address(0)){
679         if (block.timestamp > startTime){
680             if (block.timestamp >= periodFinish) {
681                 uint256 period = block.timestamp.sub(startTime).div(DURATION).add(1);
682                 periodFinish = startTime.add(period.mul(DURATION));
683                 rewardRate = reward.div(periodFinish.sub(block.timestamp));
684             } else {
685                 uint256 remaining = periodFinish.sub(block.timestamp);
686                 uint256 leftover = remaining.mul(rewardRate);
687                 rewardRate = reward.add(leftover).div(remaining);
688             }
689             lastUpdateTime = block.timestamp;
690             hdt.mint(address(this),reward);
691             emit RewardAdded(reward);
692         }else {
693           rewardRate = reward.div(DURATION);
694           periodFinish = startTime.add(DURATION);
695           lastUpdateTime = startTime;
696           hdt.mint(address(this),reward);
697           emit RewardAdded(reward);
698         }
699 
700         // avoid overflow to lock assets
701         _checkRewardRate();
702     }
703     
704     function _checkRewardRate() internal view returns (uint256) {
705         return DURATION.mul(rewardRate).mul(1e18);
706     }
707 }