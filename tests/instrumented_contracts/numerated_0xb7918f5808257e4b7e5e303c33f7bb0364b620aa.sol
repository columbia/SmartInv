1 pragma solidity ^0.5.16;
2 
3 
4 /**
5  * @dev Standard math utilities missing in the Solidity language.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the average of two numbers. The result is rounded towards
24      * zero.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
32 /**
33  * @dev Wrappers over Solidity's arithmetic operations with added overflow
34  * checks.
35  *
36  * Arithmetic operations in Solidity wrap on overflow. This can easily result
37  * in bugs, because programmers usually assume that an overflow raises an
38  * error, which is the standard behavior in high level programming languages.
39  * `SafeMath` restores this intuition by reverting the transaction when an
40  * operation overflows.
41  *
42  * Using this library instead of the unchecked operations eliminates an entire
43  * class of bugs, so it's recommended to use it always.
44  */
45 library SafeMath {
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting on
48      * overflow.
49      *
50      * Counterpart to Solidity's `+` operator.
51      *
52      * Requirements:
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot overflow.
83      *
84      * _Available since v2.4.0._
85      */
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      * - Multiplication cannot overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      *
142      * _Available since v2.4.0._
143      */
144     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         // Solidity only automatically asserts when dividing by 0
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
165         return mod(a, b, "SafeMath: modulo by zero");
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts with custom message when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      *
179      * _Available since v2.4.0._
180      */
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 /**
188  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
189  * the optional functions; to access them see {ERC20Detailed}.
190  */
191 interface IERC20 {
192     /**
193      * @dev Returns the amount of tokens in existence.
194      */
195     function totalSupply() external view returns (uint256);
196 
197     /**
198      * @dev Returns the amount of tokens owned by `account`.
199      */
200     function balanceOf(address account) external view returns (uint256);
201 
202     /**
203      * @dev Moves `amount` tokens from the caller's account to `recipient`.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transfer(address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Returns the remaining number of tokens that `spender` will be
213      * allowed to spend on behalf of `owner` through {transferFrom}. This is
214      * zero by default.
215      *
216      * This value changes when {approve} or {transferFrom} are called.
217      */
218     function allowance(address owner, address spender) external view returns (uint256);
219 
220     /**
221      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * IMPORTANT: Beware that changing an allowance with this method brings the risk
226      * that someone may use both the old and the new allowance by unfortunate
227      * transaction ordering. One possible solution to mitigate this race
228      * condition is to first reduce the spender's allowance to 0 and set the
229      * desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address spender, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Moves `amount` tokens from `sender` to `recipient` using the
238      * allowance mechanism. `amount` is then deducted from the caller's
239      * allowance.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Emitted when `value` tokens are moved from one account (`from`) to
249      * another (`to`).
250      *
251      * Note that `value` may be zero.
252      */
253     event Transfer(address indexed from, address indexed to, uint256 value);
254 
255     /**
256      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
257      * a call to {approve}. `value` is the new allowance.
258      */
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260 }
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following 
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Converts an `address` into `address payable`. Note that this is
296      * simply a type cast: the actual underlying value is not changed.
297      *
298      * _Available since v2.4.0._
299      */
300     function toPayable(address account) internal pure returns (address payable) {
301         return address(uint160(account));
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      *
320      * _Available since v2.4.0._
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         // solhint-disable-next-line avoid-call-value
326         (bool success, ) = recipient.call.value(amount)("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 }
330 
331 /**
332  * @title SafeERC20
333  * @dev Wrappers around ERC20 operations that throw on failure (when the token
334  * contract returns false). Tokens that return no value (and instead revert or
335  * throw on failure) are also supported, non-reverting calls are assumed to be
336  * successful.
337  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
338  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
339  */
340 library SafeERC20 {
341     using SafeMath for uint256;
342     using Address for address;
343 
344     function safeTransfer(IERC20 token, address to, uint256 value) internal {
345         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
346     }
347 
348     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
349         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
350     }
351 
352     function safeApprove(IERC20 token, address spender, uint256 value) internal {
353         // safeApprove should only be called when setting an initial allowance,
354         // or when resetting it to zero. To increase and decrease it, use
355         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
356         // solhint-disable-next-line max-line-length
357         require((value == 0) || (token.allowance(address(this), spender) == 0),
358             "SafeERC20: approve from non-zero to non-zero allowance"
359         );
360         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
361     }
362 
363     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
364         uint256 newAllowance = token.allowance(address(this), spender).add(value);
365         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
366     }
367 
368     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
369         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
370         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
371     }
372 
373     /**
374      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
375      * on the return value: the return value is optional (but if data is returned, it must not be false).
376      * @param token The token targeted by the call.
377      * @param data The call data (encoded using abi.encode or one of its variants).
378      */
379     function callOptionalReturn(IERC20 token, bytes memory data) private {
380         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
381         // we're implementing it ourselves.
382 
383         // A Solidity high level call has three parts:
384         //  1. The target address is checked to verify it contains contract code
385         //  2. The call itself is made, and success asserted
386         //  3. The return value is decoded, which in turn checks the size of the returned data.
387         // solhint-disable-next-line max-line-length
388         require(address(token).isContract(), "SafeERC20: call to non-contract");
389 
390         // solhint-disable-next-line avoid-low-level-calls
391         (bool success, bytes memory returndata) = address(token).call(data);
392         require(success, "SafeERC20: low-level call failed");
393 
394         if (returndata.length > 0) { // Return data is optional
395             // solhint-disable-next-line max-line-length
396             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
397         }
398     }
399 }
400 
401 /**
402  * @dev Contract module that helps prevent reentrant calls to a function.
403  *
404  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
405  * available, which can be applied to functions to make sure there are no nested
406  * (reentrant) calls to them.
407  *
408  * Note that because there is a single `nonReentrant` guard, functions marked as
409  * `nonReentrant` may not call one another. This can be worked around by making
410  * those functions `private`, and then adding `external` `nonReentrant` entry
411  * points to them.
412  *
413  * TIP: If you would like to learn more about reentrancy and alternative ways
414  * to protect against it, check out our blog post
415  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
416  *
417  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
418  * metering changes introduced in the Istanbul hardfork.
419  */
420 contract ReentrancyGuard {
421     bool private _notEntered;
422 
423     constructor () internal {
424         // Storing an initial non-zero value makes deployment a bit more
425         // expensive, but in exchange the refund on every call to nonReentrant
426         // will be lower in amount. Since refunds are capped to a percetange of
427         // the total transaction's gas, it is best to keep them low in cases
428         // like this one, to increase the likelihood of the full refund coming
429         // into effect.
430         _notEntered = true;
431     }
432 
433     /**
434      * @dev Prevents a contract from calling itself, directly or indirectly.
435      * Calling a `nonReentrant` function from another `nonReentrant`
436      * function is not supported. It is possible to prevent this from happening
437      * by making the `nonReentrant` function external, and make it call a
438      * `private` function that does the actual work.
439      */
440     modifier nonReentrant() {
441         // On the first call to nonReentrant, _notEntered will be true
442         require(_notEntered, "ReentrancyGuard: reentrant call");
443 
444         // Any calls to nonReentrant after this point will fail
445         _notEntered = false;
446 
447         _;
448 
449         // By storing the original value once again, a refund is triggered (see
450         // https://eips.ethereum.org/EIPS/eip-2200)
451         _notEntered = true;
452     }
453 }
454 
455 /*
456  * @dev Provides information about the current execution context, including the
457  * sender of the transaction and its data. While these are generally available
458  * via msg.sender and msg.data, they should not be accessed in such a direct
459  * manner, since when dealing with GSN meta-transactions the account sending and
460  * paying for execution may not be the actual sender (as far as an application
461  * is concerned).
462  *
463  * This contract is only required for intermediate, library-like contracts.
464  */
465 contract Context {
466     // Empty internal constructor, to prevent people from mistakenly deploying
467     // an instance of this contract, which should be used via inheritance.
468     constructor () internal { }
469     // solhint-disable-previous-line no-empty-blocks
470 
471     function _msgSender() internal view returns (address payable) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view returns (bytes memory) {
476         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
477         return msg.data;
478     }
479 }
480 
481 /**
482  * @dev Contract module which provides a basic access control mechanism, where
483  * there is an account (an owner) that can be granted exclusive access to
484  * specific functions.
485  *
486  * This module is used through inheritance. It will make available the modifier
487  * `onlyOwner`, which can be applied to your functions to restrict their use to
488  * the owner.
489  */
490 contract Ownable is Context {
491     address private _owner;
492 
493     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
494 
495     /**
496      * @dev Initializes the contract setting the deployer as the initial owner.
497      */
498     constructor () internal {
499         address msgSender = _msgSender();
500         _owner = msgSender;
501         emit OwnershipTransferred(address(0), msgSender);
502     }
503 
504     /**
505      * @dev Returns the address of the current owner.
506      */
507     function owner() public view returns (address) {
508         return _owner;
509     }
510 
511     /**
512      * @dev Throws if called by any account other than the owner.
513      */
514     modifier onlyOwner() {
515         require(isOwner(), "Ownable: caller is not the owner");
516         _;
517     }
518 
519     /**
520      * @dev Returns true if the caller is the current owner.
521      */
522     function isOwner() public view returns (bool) {
523         return _msgSender() == _owner;
524     }
525 
526     /**
527      * @dev Leaves the contract without owner. It will not be possible to call
528      * `onlyOwner` functions anymore. Can only be called by the current owner.
529      *
530      * NOTE: Renouncing ownership will leave the contract without an owner,
531      * thereby removing any functionality that is only available to the owner.
532      */
533     function renounceOwnership() public onlyOwner {
534         emit OwnershipTransferred(_owner, address(0));
535         _owner = address(0);
536     }
537 
538     /**
539      * @dev Transfers ownership of the contract to a new account (`newOwner`).
540      * Can only be called by the current owner.
541      */
542     function transferOwnership(address newOwner) public onlyOwner {
543         _transferOwnership(newOwner);
544     }
545 
546     /**
547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
548      */
549     function _transferOwnership(address newOwner) internal {
550         require(newOwner != address(0), "Ownable: new owner is the zero address");
551         emit OwnershipTransferred(_owner, newOwner);
552         _owner = newOwner;
553     }
554 }
555 
556 // Inheritance
557 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
558 contract RewardsDistributionRecipient is Ownable {
559     address public rewardsDistribution;
560 
561     function notifyRewardAmount(uint256 reward) external;
562 
563     modifier onlyRewardsDistribution() {
564         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
565         _;
566     }
567 
568     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
569         rewardsDistribution = _rewardsDistribution;
570     }
571 }
572 
573 // Inheritance
574 // https://docs.synthetix.io/contracts/Pausable
575 contract Pausable is Ownable {
576     uint public lastPauseTime;
577     bool public paused;
578 
579     constructor() internal {
580         // This contract is abstract, and thus cannot be instantiated directly
581         require(owner() != address(0), "Owner must be set");
582         // Paused will be false, and lastPauseTime will be 0 upon initialisation
583     }
584 
585     /**
586      * @notice Change the paused state of the contract
587      * @dev Only the contract owner may call this.
588      */
589     function setPaused(bool _paused) external onlyOwner {
590         // Ensure we're actually changing the state before we do anything
591         if (_paused == paused) {
592             return;
593         }
594 
595         // Set our paused state.
596         paused = _paused;
597 
598         // If applicable, set the last pause time.
599         if (paused) {
600             lastPauseTime = now;
601         }
602 
603         // Let everyone know that our pause state has changed.
604         emit PauseChanged(paused);
605     }
606 
607     event PauseChanged(bool isPaused);
608 
609     modifier notPaused {
610         require(!paused, "This action cannot be performed while the contract is paused");
611         _;
612     }
613 }
614 
615 // Inheritance
616 contract UniLpRewards is RewardsDistributionRecipient, ReentrancyGuard, Pausable {
617     using SafeMath for uint256;
618     using SafeERC20 for IERC20;
619 
620     /* ========== STATE VARIABLES ========== */
621 
622     IERC20 public rewardsToken;
623     IERC20 public stakingToken;
624     uint256 public periodFinish = 0;
625     uint256 public rewardRate = 0;
626     uint256 public rewardsDuration = 30 days;
627     uint256 public lastUpdateTime;
628     uint256 public rewardPerTokenStored;
629 
630     mapping(address => uint256) public userRewardPerTokenPaid;
631     mapping(address => uint256) public rewards;
632 
633     uint256 private _totalSupply;
634     mapping(address => uint256) private _balances;
635 
636     /* ========== CONSTRUCTOR ========== */
637 
638     constructor(
639         address _rewardsToken,
640         address _stakingToken
641     ) public {
642         rewardsToken = IERC20(_rewardsToken);
643         stakingToken = IERC20(_stakingToken);
644         rewardsDistribution = msg.sender;
645     }
646 
647     /* ========== VIEWS ========== */
648 
649     function totalSupply() external view returns (uint256) {
650         return _totalSupply;
651     }
652 
653     function balanceOf(address account) external view returns (uint256) {
654         return _balances[account];
655     }
656 
657     function lastTimeRewardApplicable() public view returns (uint256) {
658         return Math.min(block.timestamp, periodFinish);
659     }
660 
661     function rewardPerToken() public view returns (uint256) {
662         if (_totalSupply == 0) {
663             return rewardPerTokenStored;
664         }
665         return
666             rewardPerTokenStored.add(
667                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
668             );
669     }
670 
671     function earned(address account) public view returns (uint256) {
672         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
673     }
674 
675     function getRewardForDuration() external view returns (uint256) {
676         return rewardRate.mul(rewardsDuration);
677     }
678 
679     /* ========== MUTATIVE FUNCTIONS ========== */
680 
681     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
682         require(amount > 0, "Cannot stake 0");
683         _totalSupply = _totalSupply.add(amount);
684         _balances[msg.sender] = _balances[msg.sender].add(amount);
685         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
686         emit Staked(msg.sender, amount);
687     }
688 
689     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
690         require(amount > 0, "Cannot withdraw 0");
691         _totalSupply = _totalSupply.sub(amount);
692         _balances[msg.sender] = _balances[msg.sender].sub(amount);
693         stakingToken.safeTransfer(msg.sender, amount);
694         emit Withdrawn(msg.sender, amount);
695     }
696 
697     function getReward() public nonReentrant updateReward(msg.sender) {
698         uint256 reward = rewards[msg.sender];
699         if (reward > 0) {
700             rewards[msg.sender] = 0;
701             rewardsToken.safeTransfer(msg.sender, reward);
702             emit RewardPaid(msg.sender, reward);
703         }
704     }
705 
706     function exit() external {
707         withdraw(_balances[msg.sender]);
708         getReward();
709     }
710 
711     /* ========== RESTRICTED FUNCTIONS ========== */
712 
713     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
714         if (block.timestamp >= periodFinish) {
715             rewardRate = reward.div(rewardsDuration);
716         } else {
717             uint256 remaining = periodFinish.sub(block.timestamp);
718             uint256 leftover = remaining.mul(rewardRate);
719             rewardRate = reward.add(leftover).div(rewardsDuration);
720         }
721 
722         // Ensure the provided reward amount is not more than the balance in the contract.
723         // This keeps the reward rate in the right range, preventing overflows due to
724         // very high values of rewardRate in the earned and rewardsPerToken functions;
725         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
726         uint balance = rewardsToken.balanceOf(address(this));
727         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
728 
729         lastUpdateTime = block.timestamp;
730         periodFinish = block.timestamp.add(rewardsDuration);
731         emit RewardAdded(reward);
732     }
733 
734     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
735     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
736         require(
737             tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken),
738             "Cannot withdraw the staking or rewards tokens"
739         );
740         IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
741         emit Recovered(tokenAddress, tokenAmount);
742     }
743 
744     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
745         require(block.timestamp > periodFinish,
746             "Previous rewards period must be complete before changing the duration for the new period"
747         );
748         rewardsDuration = _rewardsDuration;
749         emit RewardsDurationUpdated(rewardsDuration);
750     }
751 
752     /* ========== MODIFIERS ========== */
753 
754     modifier updateReward(address account) {
755         rewardPerTokenStored = rewardPerToken();
756         lastUpdateTime = lastTimeRewardApplicable();
757         if (account != address(0)) {
758             rewards[account] = earned(account);
759             userRewardPerTokenPaid[account] = rewardPerTokenStored;
760         }
761         _;
762     }
763 
764     /* ========== EVENTS ========== */
765 
766     event RewardAdded(uint256 reward);
767     event Staked(address indexed user, uint256 amount);
768     event Withdrawn(address indexed user, uint256 amount);
769     event RewardPaid(address indexed user, uint256 reward);
770     event RewardsDurationUpdated(uint256 newDuration);
771     event Recovered(address token, uint256 amount);
772 }