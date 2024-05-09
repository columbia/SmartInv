1 // File: @openzeppelin\contracts\math\Math.sol
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
33 // File: @openzeppelin\contracts\math\SafeMath.sol
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
192 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
193 
194 pragma solidity ^0.5.0;
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
222 // File: @openzeppelin\contracts\ownership\Ownable.sol
223 
224 pragma solidity ^0.5.0;
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
244         address msgSender = _msgSender();
245         _owner = msgSender;
246         emit OwnershipTransferred(address(0), msgSender);
247     }
248 
249     /**
250      * @dev Returns the address of the current owner.
251      */
252     function owner() public view returns (address) {
253         return _owner;
254     }
255 
256     /**
257      * @dev Throws if called by any account other than the owner.
258      */
259     modifier onlyOwner() {
260         require(isOwner(), "Ownable: caller is not the owner");
261         _;
262     }
263 
264     /**
265      * @dev Returns true if the caller is the current owner.
266      */
267     function isOwner() public view returns (bool) {
268         return _msgSender() == _owner;
269     }
270 
271     /**
272      * @dev Leaves the contract without owner. It will not be possible to call
273      * `onlyOwner` functions anymore. Can only be called by the current owner.
274      *
275      * NOTE: Renouncing ownership will leave the contract without an owner,
276      * thereby removing any functionality that is only available to the owner.
277      */
278     function renounceOwnership() public onlyOwner {
279         emit OwnershipTransferred(_owner, address(0));
280         _owner = address(0);
281     }
282 
283     /**
284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
285      * Can only be called by the current owner.
286      */
287     function transferOwnership(address newOwner) public onlyOwner {
288         _transferOwnership(newOwner);
289     }
290 
291     /**
292      * @dev Transfers ownership of the contract to a new account (`newOwner`).
293      */
294     function _transferOwnership(address newOwner) internal {
295         require(newOwner != address(0), "Ownable: new owner is the zero address");
296         emit OwnershipTransferred(_owner, newOwner);
297         _owner = newOwner;
298     }
299 }
300 
301 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
302 
303 pragma solidity ^0.5.0;
304 
305 /**
306  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
307  * the optional functions; to access them see {ERC20Detailed}.
308  */
309 interface IERC20 {
310     /**
311      * @dev Returns the amount of tokens in existence.
312      */
313     function totalSupply() external view returns (uint256);
314 
315     /**
316      * @dev Returns the amount of tokens owned by `account`.
317      */
318     function balanceOf(address account) external view returns (uint256);
319 
320     /**
321      * @dev Moves `amount` tokens from the caller's account to `recipient`.
322      *
323      * Returns a boolean value indicating whether the operation succeeded.
324      *
325      * Emits a {Transfer} event.
326      */
327     function transfer(address recipient, uint256 amount) external returns (bool);
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
380 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
381 
382 pragma solidity ^0.5.5;
383 
384 /**
385  * @dev Collection of functions related to the address type
386  */
387 library Address {
388     /**
389      * @dev Returns true if `account` is a contract.
390      *
391      * [IMPORTANT]
392      * ====
393      * It is unsafe to assume that an address for which this function returns
394      * false is an externally-owned account (EOA) and not a contract.
395      *
396      * Among others, `isContract` will return false for the following
397      * types of addresses:
398      *
399      *  - an externally-owned account
400      *  - a contract in construction
401      *  - an address where a contract will be created
402      *  - an address where a contract lived, but was destroyed
403      * ====
404      */
405     function isContract(address account) internal view returns (bool) {
406         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
407         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
408         // for accounts without code, i.e. `keccak256('')`
409         bytes32 codehash;
410         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
411         // solhint-disable-next-line no-inline-assembly
412         assembly { codehash := extcodehash(account) }
413         return (codehash != accountHash && codehash != 0x0);
414     }
415 
416     /**
417      * @dev Converts an `address` into `address payable`. Note that this is
418      * simply a type cast: the actual underlying value is not changed.
419      *
420      * _Available since v2.4.0._
421      */
422     function toPayable(address account) internal pure returns (address payable) {
423         return address(uint160(account));
424     }
425 
426     /**
427      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
428      * `recipient`, forwarding all available gas and reverting on errors.
429      *
430      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
431      * of certain opcodes, possibly making contracts go over the 2300 gas limit
432      * imposed by `transfer`, making them unable to receive funds via
433      * `transfer`. {sendValue} removes this limitation.
434      *
435      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
436      *
437      * IMPORTANT: because control is transferred to `recipient`, care must be
438      * taken to not create reentrancy vulnerabilities. Consider using
439      * {ReentrancyGuard} or the
440      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
441      *
442      * _Available since v2.4.0._
443      */
444     function sendValue(address payable recipient, uint256 amount) internal {
445         require(address(this).balance >= amount, "Address: insufficient balance");
446 
447         // solhint-disable-next-line avoid-call-value
448         (bool success, ) = recipient.call.value(amount)("");
449         require(success, "Address: unable to send value, recipient may have reverted");
450     }
451 }
452 
453 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
454 
455 pragma solidity ^0.5.0;
456 
457 
458 
459 
460 /**
461  * @title SafeERC20
462  * @dev Wrappers around ERC20 operations that throw on failure (when the token
463  * contract returns false). Tokens that return no value (and instead revert or
464  * throw on failure) are also supported, non-reverting calls are assumed to be
465  * successful.
466  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
467  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
468  */
469 library SafeERC20 {
470     using SafeMath for uint256;
471     using Address for address;
472 
473     function safeTransfer(IERC20 token, address to, uint256 value) internal {
474         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
475     }
476 
477     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
478         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
479     }
480 
481     function safeApprove(IERC20 token, address spender, uint256 value) internal {
482         // safeApprove should only be called when setting an initial allowance,
483         // or when resetting it to zero. To increase and decrease it, use
484         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
485         // solhint-disable-next-line max-line-length
486         require((value == 0) || (token.allowance(address(this), spender) == 0),
487             "SafeERC20: approve from non-zero to non-zero allowance"
488         );
489         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
490     }
491 
492     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
493         uint256 newAllowance = token.allowance(address(this), spender).add(value);
494         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
495     }
496 
497     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
498         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
499         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
500     }
501 
502     /**
503      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
504      * on the return value: the return value is optional (but if data is returned, it must not be false).
505      * @param token The token targeted by the call.
506      * @param data The call data (encoded using abi.encode or one of its variants).
507      */
508     function callOptionalReturn(IERC20 token, bytes memory data) private {
509         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
510         // we're implementing it ourselves.
511 
512         // A Solidity high level call has three parts:
513         //  1. The target address is checked to verify it contains contract code
514         //  2. The call itself is made, and success asserted
515         //  3. The return value is decoded, which in turn checks the size of the returned data.
516         // solhint-disable-next-line max-line-length
517         require(address(token).isContract(), "SafeERC20: call to non-contract");
518 
519         // solhint-disable-next-line avoid-low-level-calls
520         (bool success, bytes memory returndata) = address(token).call(data);
521         require(success, "SafeERC20: low-level call failed");
522 
523         if (returndata.length > 0) { // Return data is optional
524             // solhint-disable-next-line max-line-length
525             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
526         }
527     }
528 }
529 
530 // File: contracts\IRewardDistributionRecipient.sol
531 
532 pragma solidity ^0.5.0;
533 
534 
535 contract IRewardDistributionRecipient is Ownable {
536     address rewardDistribution;
537 
538     function notifyRewardAmount(uint256 reward) external;
539 
540     modifier onlyRewardDistribution() {
541         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
542         _;
543     }
544 
545     function setRewardDistribution(address _rewardDistribution)
546         external
547         onlyOwner
548     {
549         rewardDistribution = _rewardDistribution;
550     }
551 }
552 
553 // File: contracts\Unipool.sol
554 
555 pragma solidity ^0.5.0;
556 
557 contract LPTokenWrapper {
558     using SafeMath for uint256;
559     using SafeERC20 for IERC20;
560 
561     IERC20 public uni = IERC20(0x2b645a6A426f22fB7954dC15E583e3737B8d1434);
562 
563     uint256 private _totalSupply;
564     mapping(address => uint256) private _balances;
565 
566     function totalSupply() public view returns (uint256) {
567         return _totalSupply;
568     }
569 
570     function balanceOf(address account) public view returns (uint256) {
571         return _balances[account];
572     }
573 
574     function stake(uint256 amount) public {
575         _totalSupply = _totalSupply.add(amount);
576         _balances[msg.sender] = _balances[msg.sender].add(amount);
577         uni.safeTransferFrom(msg.sender, address(this), amount);
578     }
579 
580     function withdraw(uint256 amount) public {
581         _totalSupply = _totalSupply.sub(amount);
582         _balances[msg.sender] = _balances[msg.sender].sub(amount);
583         uni.safeTransfer(msg.sender, amount);
584     }
585 }
586 
587 contract Curvepool is LPTokenWrapper, IRewardDistributionRecipient {
588     IERC20 public snx = IERC20(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F);
589     uint256 public constant DURATION = 7 days;
590 
591     uint256 public periodFinish = 0;
592     uint256 public rewardRate = 0;
593     uint256 public lastUpdateTime;
594     uint256 public rewardPerTokenStored;
595     mapping(address => uint256) public userRewardPerTokenPaid;
596     mapping(address => uint256) public rewards;
597 
598     event RewardAdded(uint256 reward);
599     event Staked(address indexed user, uint256 amount);
600     event Withdrawn(address indexed user, uint256 amount);
601     event RewardPaid(address indexed user, uint256 reward);
602 
603     modifier updateReward(address account) {
604         rewardPerTokenStored = rewardPerToken();
605         lastUpdateTime = lastTimeRewardApplicable();
606         if (account != address(0)) {
607             rewards[account] = earned(account);
608             userRewardPerTokenPaid[account] = rewardPerTokenStored;
609         }
610         _;
611     }
612 
613     function lastTimeRewardApplicable() public view returns (uint256) {
614         return Math.min(block.timestamp, periodFinish);
615     }
616 
617     function rewardPerToken() public view returns (uint256) {
618         if (totalSupply() == 0) {
619             return rewardPerTokenStored;
620         }
621         return
622             rewardPerTokenStored.add(
623                 lastTimeRewardApplicable()
624                     .sub(lastUpdateTime)
625                     .mul(rewardRate)
626                     .mul(1e18)
627                     .div(totalSupply())
628             );
629     }
630 
631     function earned(address account) public view returns (uint256) {
632         return
633             balanceOf(account)
634                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
635                 .div(1e18)
636                 .add(rewards[account]);
637     }
638 
639     // stake visibility is public as overriding LPTokenWrapper's stake() function
640     function stake(uint256 amount) public updateReward(msg.sender) {
641         require(amount > 0, "Cannot stake 0");
642         super.stake(amount);
643         emit Staked(msg.sender, amount);
644     }
645 
646     function withdraw(uint256 amount) public updateReward(msg.sender) {
647         require(amount > 0, "Cannot withdraw 0");
648         super.withdraw(amount);
649         emit Withdrawn(msg.sender, amount);
650     }
651 
652     function exit() external {
653         withdraw(balanceOf(msg.sender));
654         getReward();
655     }
656 
657     function getReward() public updateReward(msg.sender) {
658         uint256 reward = earned(msg.sender);
659         if (reward > 0) {
660             rewards[msg.sender] = 0;
661             snx.safeTransfer(msg.sender, reward);
662             emit RewardPaid(msg.sender, reward);
663         }
664     }
665 
666     function notifyRewardAmount(uint256 reward)
667         external
668         onlyRewardDistribution
669         updateReward(address(0))
670     {
671         if (block.timestamp >= periodFinish) {
672             rewardRate = reward.div(DURATION);
673         } else {
674             uint256 remaining = periodFinish.sub(block.timestamp);
675             uint256 leftover = remaining.mul(rewardRate);
676             rewardRate = reward.add(leftover).div(DURATION);
677         }
678         lastUpdateTime = block.timestamp;
679         periodFinish = block.timestamp.add(DURATION);
680         emit RewardAdded(reward);
681     }
682 }