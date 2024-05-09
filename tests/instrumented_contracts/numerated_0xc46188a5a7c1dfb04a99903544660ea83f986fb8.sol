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
35 pragma solidity 0.5.16;
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
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      * - Subtraction cannot overflow.
88      *
89      * _Available since v2.4.0._
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      *
147      * _Available since v2.4.0._
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      *
184      * _Available since v2.4.0._
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/GSN/Context.sol
193 
194 pragma solidity 0.5.16;
195 
196 /*
197  * @dev Provides information about the current execution context, including the
198  * sender of the transaction and its data. While these are generally available
199  * via msg.sender and msg.data, they should not be accessed in such a direct
200  * manner, since when dealing with GSN meta-transactions the account sending and
201  * paying for execution may not be the actual sender (as far as an application
202  * is concerned).
203  *
204  * This contract is only required for intermediate, library-like contracts.
205  */
206 contract Context {
207     // Empty internal constructor, to prevent people from mistakenly deploying
208     // an instance of this contract, which should be used via inheritance.
209     constructor () internal { }
210     // solhint-disable-previous-line no-empty-blocks
211 
212     function _msgSender() internal view returns (address payable) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view returns (bytes memory) {
217         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
218         return msg.data;
219     }
220 }
221 
222 // File: @openzeppelin/contracts/ownership/Ownable.sol
223 
224 pragma solidity 0.5.16;
225 
226 /**
227  * @dev Contract module which provides a basic access control mechanism, where
228  * there is an account (an owner) that can be granted exclusive access to
229  * specific functions.
230  *
231  * This module is used through inheritance. It will make available the modifier
232  * `onlyOwner`, which can be applied to your functions to restrict their use to
233  * the owner.
234  */
235 contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239 
240     /**
241      * @dev Initializes the contract setting the deployer as the initial owner.
242      */
243     constructor () internal {
244         _owner = _msgSender();
245         emit OwnershipTransferred(address(0), _owner);
246     }
247 
248     /**
249      * @dev Returns the address of the current owner.
250      */
251     function owner() public view returns (address) {
252         return _owner;
253     }
254 
255     /**
256      * @dev Throws if called by any account other than the owner.
257      */
258     modifier onlyOwner() {
259         require(isOwner(), "Ownable: caller is not the owner");
260         _;
261     }
262 
263     /**
264      * @dev Returns true if the caller is the current owner.
265      */
266     function isOwner() public view returns (bool) {
267         return _msgSender() == _owner;
268     }
269 
270     /**
271      * @dev Leaves the contract without owner. It will not be possible to call
272      * `onlyOwner` functions anymore. Can only be called by the current owner.
273      *
274      * NOTE: Renouncing ownership will leave the contract without an owner,
275      * thereby removing any functionality that is only available to the owner.
276      */
277     function renounceOwnership() public onlyOwner {
278         emit OwnershipTransferred(_owner, address(0));
279         _owner = address(0);
280     }
281 
282     /**
283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
284      * Can only be called by the current owner.
285      */
286     function transferOwnership(address newOwner) public onlyOwner {
287         _transferOwnership(newOwner);
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      */
293     function _transferOwnership(address newOwner) internal {
294         require(newOwner != address(0), "Ownable: new owner is the zero address");
295         emit OwnershipTransferred(_owner, newOwner);
296         _owner = newOwner;
297     }
298 }
299 
300 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
301 
302 pragma solidity 0.5.16;
303 
304 /**
305  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
306  * the optional functions; to access them see {ERC20Detailed}.
307  */
308 interface IERC20 {
309     /**
310      * @dev Returns the amount of tokens in existence.
311      */
312     function totalSupply() external view returns (uint256);
313 
314     /**
315      * @dev Returns the amount of tokens owned by `account`.
316      */
317     function balanceOf(address account) external view returns (uint256);
318 
319     /**
320      * @dev Moves `amount` tokens from the caller's account to `recipient`.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * Emits a {Transfer} event.
325      */
326     function transfer(address recipient, uint256 amount) external returns (bool);
327     function mint(address account, uint amount) external;
328 
329     /**
330      * @dev Returns the remaining number of tokens that `spender` will be
331      * allowed to spend on behalf of `owner` through {transferFrom}. This is
332      * zero by default.
333      *
334      * This value changes when {approve} or {transferFrom} are called.
335      */
336     function allowance(address owner, address spender) external view returns (uint256);
337 
338     /**
339      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
340      *
341      * Returns a boolean value indicating whether the operation succeeded.
342      *
343      * IMPORTANT: Beware that changing an allowance with this method brings the risk
344      * that someone may use both the old and the new allowance by unfortunate
345      * transaction ordering. One possible solution to mitigate this race
346      * condition is to first reduce the spender's allowance to 0 and set the
347      * desired value afterwards:
348      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349      *
350      * Emits an {Approval} event.
351      */
352     function approve(address spender, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Moves `amount` tokens from `sender` to `recipient` using the
356      * allowance mechanism. `amount` is then deducted from the caller's
357      * allowance.
358      *
359      * Returns a boolean value indicating whether the operation succeeded.
360      *
361      * Emits a {Transfer} event.
362      */
363     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
364 
365     /**
366      * @dev Emitted when `value` tokens are moved from one account (`from`) to
367      * another (`to`).
368      *
369      * Note that `value` may be zero.
370      */
371     event Transfer(address indexed from, address indexed to, uint256 value);
372 
373     /**
374      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
375      * a call to {approve}. `value` is the new allowance.
376      */
377     event Approval(address indexed owner, address indexed spender, uint256 value);
378 }
379 
380 // File: @openzeppelin/contracts/utils/Address.sol
381 
382 pragma solidity 0.5.16;
383 
384 /**
385  * @dev Collection of functions related to the address type
386  */
387 library Address {
388     /**
389      * @dev Returns true if `account` is a contract.
390      *
391      * This test is non-exhaustive, and there may be false-negatives: during the
392      * execution of a contract's constructor, its address will be reported as
393      * not containing a contract.
394      *
395      * IMPORTANT: It is unsafe to assume that an address for which this
396      * function returns false is an externally-owned account (EOA) and not a
397      * contract.
398      */
399     function isContract(address account) internal view returns (bool) {
400         // This method relies in extcodesize, which returns 0 for contracts in
401         // construction, since the code is only stored at the end of the
402         // constructor execution.
403 
404         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
405         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
406         // for accounts without code, i.e. `keccak256('')`
407         bytes32 codehash;
408         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
409         // solhint-disable-next-line no-inline-assembly
410         assembly { codehash := extcodehash(account) }
411         return (codehash != 0x0 && codehash != accountHash);
412     }
413 
414     /**
415      * @dev Converts an `address` into `address payable`. Note that this is
416      * simply a type cast: the actual underlying value is not changed.
417      *
418      * _Available since v2.4.0._
419      */
420     function toPayable(address account) internal pure returns (address payable) {
421         return address(uint160(account));
422     }
423 
424     /**
425      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
426      * `recipient`, forwarding all available gas and reverting on errors.
427      *
428      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
429      * of certain opcodes, possibly making contracts go over the 2300 gas limit
430      * imposed by `transfer`, making them unable to receive funds via
431      * `transfer`. {sendValue} removes this limitation.
432      *
433      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
434      *
435      * IMPORTANT: because control is transferred to `recipient`, care must be
436      * taken to not create reentrancy vulnerabilities. Consider using
437      * {ReentrancyGuard} or the
438      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
439      *
440      * _Available since v2.4.0._
441      */
442     function sendValue(address payable recipient, uint256 amount) internal {
443         require(address(this).balance >= amount, "Address: insufficient balance");
444 
445         // solhint-disable-next-line avoid-call-value
446         (bool success, ) = recipient.call.value(amount)("");
447         require(success, "Address: unable to send value, recipient may have reverted");
448     }
449 }
450 
451 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
452 
453 pragma solidity 0.5.16;
454 
455 
456 
457 
458 /**
459  * @title SafeERC20
460  * @dev Wrappers around ERC20 operations that throw on failure (when the token
461  * contract returns false). Tokens that return no value (and instead revert or
462  * throw on failure) are also supported, non-reverting calls are assumed to be
463  * successful.
464  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
465  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
466  */
467 library SafeERC20 {
468     using SafeMath for uint256;
469     using Address for address;
470 
471     function safeTransfer(IERC20 token, address to, uint256 value) internal {
472         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
473     }
474 
475     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
476         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
477     }
478 
479     function safeApprove(IERC20 token, address spender, uint256 value) internal {
480         // safeApprove should only be called when setting an initial allowance,
481         // or when resetting it to zero. To increase and decrease it, use
482         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
483         // solhint-disable-next-line max-line-length
484         require((value == 0) || (token.allowance(address(this), spender) == 0),
485             "SafeERC20: approve from non-zero to non-zero allowance"
486         );
487         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
488     }
489 
490     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
491         uint256 newAllowance = token.allowance(address(this), spender).add(value);
492         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
493     }
494 
495     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
496         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
497         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
498     }
499 
500     /**
501      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
502      * on the return value: the return value is optional (but if data is returned, it must not be false).
503      * @param token The token targeted by the call.
504      * @param data The call data (encoded using abi.encode or one of its variants).
505      */
506     function callOptionalReturn(IERC20 token, bytes memory data) private {
507         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
508         // we're implementing it ourselves.
509 
510         // A Solidity high level call has three parts:
511         //  1. The target address is checked to verify it contains contract code
512         //  2. The call itself is made, and success asserted
513         //  3. The return value is decoded, which in turn checks the size of the returned data.
514         // solhint-disable-next-line max-line-length
515         require(address(token).isContract(), "SafeERC20: call to non-contract");
516 
517         // solhint-disable-next-line avoid-low-level-calls
518         (bool success, bytes memory returndata) = address(token).call(data);
519         require(success, "SafeERC20: low-level call failed");
520 
521         if (returndata.length > 0) { // Return data is optional
522             // solhint-disable-next-line max-line-length
523             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
524         }
525     }
526 }
527 
528 /**
529  * Reward Amount Interface
530  */
531 pragma solidity 0.5.16;
532 
533 contract IRewardDistributionRecipient is Ownable {
534     address rewardDistribution;
535 
536     function notifyRewardAmount(uint256 reward) external;
537 
538     modifier onlyRewardDistribution() {
539         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
540         _;
541     }
542 
543     function setRewardDistribution(address _rewardDistribution)
544         external
545         onlyOwner
546     {
547         rewardDistribution = _rewardDistribution;
548     }
549 }
550 
551 /**
552  * Staking Token Wrapper
553  */
554 pragma solidity 0.5.16;
555 
556 contract GOFTokenWrapper {
557     using SafeMath for uint256;
558     using SafeERC20 for IERC20;
559 
560     IERC20 public stakeToken = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); 
561 
562     uint256 private _totalSupply;
563     mapping(address => uint256) private _balances;
564 
565     function totalSupply() public view returns (uint256) {
566         return _totalSupply;
567     }
568 
569     function balanceOf(address account) public view returns (uint256) {
570         return _balances[account];
571     }
572 
573     function stake(uint256 amount) public {
574         _totalSupply = _totalSupply.add(amount);
575         _balances[msg.sender] = _balances[msg.sender].add(amount);
576         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
577     }
578 
579     function withdraw(uint256 amount) public {
580         _totalSupply = _totalSupply.sub(amount);
581         _balances[msg.sender] = _balances[msg.sender].sub(amount);
582         stakeToken.safeTransfer(msg.sender, amount);
583     }
584 }
585 
586 /**
587  * Eth Pool
588  */
589 pragma solidity 0.5.16;
590 
591 contract GOFETHPool is GOFTokenWrapper, IRewardDistributionRecipient {
592     IERC20 public gof = IERC20(0x488E0369f9BC5C40C002eA7c1fe4fd01A198801c);
593     uint256 public constant DURATION = 7 days;
594 
595     uint256 public constant startTime = 1599652800; //utc+8 2020-09-09 20:00:00
596     uint256 public periodFinish = 0;
597     uint256 public rewardRate = 0;
598     uint256 public lastUpdateTime;
599     uint256 public rewardPerTokenStored = 0;
600     bool private open = true;
601     uint256 private constant _gunit = 1e18;
602     mapping(address => uint256) public userRewardPerTokenPaid; 
603     mapping(address => uint256) public rewards; // Unclaimed rewards
604 
605     event RewardAdded(uint256 reward);
606     event Staked(address indexed user, uint256 amount);
607     event Withdrawn(address indexed user, uint256 amount);
608     event RewardPaid(address indexed user, uint256 reward);
609     event SetOpen(bool _open);
610 
611     modifier updateReward(address account) {
612         rewardPerTokenStored = rewardPerToken();
613         lastUpdateTime = lastTimeRewardApplicable();
614         if (account != address(0)) {
615             rewards[account] = earned(account);
616             userRewardPerTokenPaid[account] = rewardPerTokenStored;
617         }
618         _;
619     }
620 
621     function lastTimeRewardApplicable() public view returns (uint256) {
622         return Math.min(block.timestamp, periodFinish);
623     }
624 
625     /**
626      * Calculate the rewards for each token
627      */
628     function rewardPerToken() public view returns (uint256) {
629         if (totalSupply() == 0) {
630             return rewardPerTokenStored;
631         }
632         return
633             rewardPerTokenStored.add(
634                 lastTimeRewardApplicable()
635                     .sub(lastUpdateTime)
636                     .mul(rewardRate)
637                     .mul(_gunit)
638                     .div(totalSupply())
639             );
640     }
641 
642     function earned(address account) public view returns (uint256) {
643         return
644             balanceOf(account)
645                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
646                 .div(_gunit)
647                 .add(rewards[account]);
648     }
649 
650     function stake(uint256 amount) public checkOpen checkStart updateReward(msg.sender){ 
651         require(amount > 0, "Golff-ETH-POOL: Cannot stake 0");
652         super.stake(amount);
653         emit Staked(msg.sender, amount);
654     }
655 
656     function withdraw(uint256 amount) public checkStart updateReward(msg.sender){
657         require(amount > 0, "Golff-ETH-POOL: Cannot withdraw 0");
658         super.withdraw(amount);
659         emit Withdrawn(msg.sender, amount);
660     }
661 
662     function exit() external {
663         withdraw(balanceOf(msg.sender));
664         getReward();
665     }
666 
667     function getReward() public checkStart updateReward(msg.sender){
668         uint256 reward = earned(msg.sender);
669         if (reward > 0) {
670             rewards[msg.sender] = 0;
671             gof.safeTransfer(msg.sender, reward);
672             emit RewardPaid(msg.sender, reward);
673         }
674     }
675 
676     modifier checkStart(){
677         require(block.timestamp > startTime,"Golff-ETH-POOL: Not start");
678         _;
679     }
680 
681     modifier checkOpen() {
682         require(open, "Golff-ETH-POOL: Pool is closed");
683         _;
684     }
685 
686     function getPeriodFinish() external view returns (uint256) {
687         return periodFinish;
688     }
689 
690     function isOpen() external view returns (bool) {
691         return open;
692     }
693 
694     function setOpen(bool _open) external onlyOwner {
695         open = _open;
696         emit SetOpen(_open);
697     }
698 
699     function notifyRewardAmount(uint256 reward)
700         external
701         onlyRewardDistribution
702         checkOpen
703         updateReward(address(0)){
704         if (block.timestamp > startTime){
705             if (block.timestamp >= periodFinish) {
706                 uint256 period = block.timestamp.sub(startTime).div(DURATION).add(1);
707                 periodFinish = startTime.add(period.mul(DURATION));
708                 rewardRate = reward.div(periodFinish.sub(block.timestamp));
709             } else {
710                 uint256 remaining = periodFinish.sub(block.timestamp);
711                 uint256 leftover = remaining.mul(rewardRate);
712                 rewardRate = reward.add(leftover).div(remaining);
713             }
714             lastUpdateTime = block.timestamp;
715         }else {
716           rewardRate = reward.div(DURATION);
717           periodFinish = startTime.add(DURATION);
718           lastUpdateTime = startTime;
719         }
720 
721         gof.mint(address(this),reward);
722         emit RewardAdded(reward);
723 
724         // avoid overflow to lock assets
725         _checkRewardRate();
726     }
727     
728     function _checkRewardRate() internal view returns (uint256) {
729         return DURATION.mul(rewardRate).mul(_gunit);
730     }
731 }