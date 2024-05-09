1 // File: @openzeppelin/contracts/math/Math.sol
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
33 // File: @openzeppelin/contracts/math/SafeMath.sol
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
192 // File: @openzeppelin/contracts/GSN/Context.sol
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
222 // File: @openzeppelin/contracts/ownership/Ownable.sol
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
302 pragma solidity ^0.5.0;
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
327 
328     /**
329      * @dev Returns the remaining number of tokens that `spender` will be
330      * allowed to spend on behalf of `owner` through {transferFrom}. This is
331      * zero by default.
332      *
333      * This value changes when {approve} or {transferFrom} are called.
334      */
335     function allowance(address owner, address spender) external view returns (uint256);
336 
337     /**
338      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * IMPORTANT: Beware that changing an allowance with this method brings the risk
343      * that someone may use both the old and the new allowance by unfortunate
344      * transaction ordering. One possible solution to mitigate this race
345      * condition is to first reduce the spender's allowance to 0 and set the
346      * desired value afterwards:
347      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
348      *
349      * Emits an {Approval} event.
350      */
351     function approve(address spender, uint256 amount) external returns (bool);
352 
353     /**
354      * @dev Moves `amount` tokens from `sender` to `recipient` using the
355      * allowance mechanism. `amount` is then deducted from the caller's
356      * allowance.
357      *
358      * Returns a boolean value indicating whether the operation succeeded.
359      *
360      * Emits a {Transfer} event.
361      */
362     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
363 
364     /**
365      * @dev Emitted when `value` tokens are moved from one account (`from`) to
366      * another (`to`).
367      *
368      * Note that `value` may be zero.
369      */
370     event Transfer(address indexed from, address indexed to, uint256 value);
371 
372     /**
373      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
374      * a call to {approve}. `value` is the new allowance.
375      */
376     event Approval(address indexed owner, address indexed spender, uint256 value);
377 }
378 
379 // File: @openzeppelin/contracts/utils/Address.sol
380 
381 pragma solidity ^0.5.5;
382 
383 /**
384  * @dev Collection of functions related to the address type
385  */
386 library Address {
387     /**
388      * @dev Returns true if `account` is a contract.
389      *
390      * This test is non-exhaustive, and there may be false-negatives: during the
391      * execution of a contract's constructor, its address will be reported as
392      * not containing a contract.
393      *
394      * IMPORTANT: It is unsafe to assume that an address for which this
395      * function returns false is an externally-owned account (EOA) and not a
396      * contract.
397      */
398     function isContract(address account) internal view returns (bool) {
399         // This method relies in extcodesize, which returns 0 for contracts in
400         // construction, since the code is only stored at the end of the
401         // constructor execution.
402 
403         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
404         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
405         // for accounts without code, i.e. `keccak256('')`
406         bytes32 codehash;
407         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
408         // solhint-disable-next-line no-inline-assembly
409         assembly { codehash := extcodehash(account) }
410         return (codehash != 0x0 && codehash != accountHash);
411     }
412 
413     /**
414      * @dev Converts an `address` into `address payable`. Note that this is
415      * simply a type cast: the actual underlying value is not changed.
416      *
417      * _Available since v2.4.0._
418      */
419     function toPayable(address account) internal pure returns (address payable) {
420         return address(uint160(account));
421     }
422 
423     /**
424      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
425      * `recipient`, forwarding all available gas and reverting on errors.
426      *
427      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
428      * of certain opcodes, possibly making contracts go over the 2300 gas limit
429      * imposed by `transfer`, making them unable to receive funds via
430      * `transfer`. {sendValue} removes this limitation.
431      *
432      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
433      *
434      * IMPORTANT: because control is transferred to `recipient`, care must be
435      * taken to not create reentrancy vulnerabilities. Consider using
436      * {ReentrancyGuard} or the
437      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
438      *
439      * _Available since v2.4.0._
440      */
441     function sendValue(address payable recipient, uint256 amount) internal {
442         require(address(this).balance >= amount, "Address: insufficient balance");
443 
444         // solhint-disable-next-line avoid-call-value
445         (bool success, ) = recipient.call.value(amount)("");
446         require(success, "Address: unable to send value, recipient may have reverted");
447     }
448 }
449 
450 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
451 
452 pragma solidity ^0.5.0;
453 
454 
455 
456 
457 /**
458  * @title SafeERC20
459  * @dev Wrappers around ERC20 operations that throw on failure (when the token
460  * contract returns false). Tokens that return no value (and instead revert or
461  * throw on failure) are also supported, non-reverting calls are assumed to be
462  * successful.
463  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
464  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
465  */
466 library SafeERC20 {
467     using SafeMath for uint256;
468     using Address for address;
469 
470     function safeTransfer(IERC20 token, address to, uint256 value) internal {
471         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
472     }
473 
474     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
475         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
476     }
477 
478     function safeApprove(IERC20 token, address spender, uint256 value) internal {
479         // safeApprove should only be called when setting an initial allowance,
480         // or when resetting it to zero. To increase and decrease it, use
481         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
482         // solhint-disable-next-line max-line-length
483         require((value == 0) || (token.allowance(address(this), spender) == 0),
484             "SafeERC20: approve from non-zero to non-zero allowance"
485         );
486         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
487     }
488 
489     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
490         uint256 newAllowance = token.allowance(address(this), spender).add(value);
491         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
492     }
493 
494     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
495         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
496         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
497     }
498 
499     /**
500      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
501      * on the return value: the return value is optional (but if data is returned, it must not be false).
502      * @param token The token targeted by the call.
503      * @param data The call data (encoded using abi.encode or one of its variants).
504      */
505     function callOptionalReturn(IERC20 token, bytes memory data) private {
506         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
507         // we're implementing it ourselves.
508 
509         // A Solidity high level call has three parts:
510         //  1. The target address is checked to verify it contains contract code
511         //  2. The call itself is made, and success asserted
512         //  3. The return value is decoded, which in turn checks the size of the returned data.
513         // solhint-disable-next-line max-line-length
514         require(address(token).isContract(), "SafeERC20: call to non-contract");
515 
516         // solhint-disable-next-line avoid-low-level-calls
517         (bool success, bytes memory returndata) = address(token).call(data);
518         require(success, "SafeERC20: low-level call failed");
519 
520         if (returndata.length > 0) { // Return data is optional
521             // solhint-disable-next-line max-line-length
522             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
523         }
524     }
525 }
526 
527 // File: new_staking.sol
528 
529 pragma solidity ^0.5.0;
530 
531 
532 
533 
534 
535 
536 contract IRewardDistributionRecipient is Ownable {
537     address rewardDistribution;
538 
539     function notifyRewardAmount(uint256 reward) external;
540 
541     modifier onlyRewardDistribution() {
542         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
543         _;
544     }
545 
546     function setRewardDistribution(address _rewardDistribution)
547         external
548         onlyOwner
549     {
550         rewardDistribution = _rewardDistribution;
551     }
552 }
553 
554 contract LPTokenWrapper {
555 
556     using SafeMath for uint256;
557     using SafeERC20 for IERC20;
558 
559     IERC20 public lp = IERC20(0xFe7308D6Ba8A64a189074f3c83a6cC56Fc13B3aF);
560 
561     uint256 private _totalSupply;
562     mapping(address => uint256) private _balances;
563 
564     function totalSupply() public view returns(uint256) {
565         return _totalSupply;
566     }
567 
568     function balanceOf(address account) public view returns(uint256) {
569         return _balances[account];
570     }
571 
572     function stake(uint256 amount) public {
573         _totalSupply = _totalSupply.add(amount);
574         _balances[msg.sender] = _balances[msg.sender].add(amount);
575         lp.safeTransferFrom(msg.sender, address(this), amount);
576     }
577 
578     function withdraw(uint256 amount) public {
579         _totalSupply = _totalSupply.sub(amount);
580         _balances[msg.sender] = _balances[msg.sender].sub(amount);
581         lp.safeTransfer(msg.sender, amount);
582     }
583 }
584 
585 
586 contract Unipool is LPTokenWrapper, IRewardDistributionRecipient {
587 
588     IERC20 public df = IERC20(0x431ad2ff6a9C365805eBaD47Ee021148d6f7DBe0);
589 
590     uint256 public constant DURATION = 7 days;
591 
592     uint256 public periodFinish = 0;
593     uint256 public rewardRate = 0;
594     uint256 public lastUpdateTime;
595     uint256 public rewardPerTokenStored;
596     mapping(address => uint256) public userRewardPerTokenPaid;
597     mapping(address => uint256) public rewards;
598 
599     event RewardAdded(uint256 reward);
600     event Staked(address indexed user, uint256 amount);
601     event Withdrawn(address indexed user, uint256 amount);
602     event RewardPaid(address indexed user, uint256 reward);
603 
604     modifier updateReward(address account) {
605         rewardPerTokenStored = rewardPerToken();
606         lastUpdateTime = lastTimeRewardApplicable();
607         if (account != address(0)) {
608             rewards[account] = earned(account);
609             userRewardPerTokenPaid[account] = rewardPerTokenStored;
610         }
611         _;
612     }
613 
614     modifier notLocked() {
615         require(block.timestamp >= periodFinish, "notLocked: Staking has not been released!");
616         _;
617     }
618 
619     function lastTimeRewardApplicable() public view returns(uint256) {
620         return Math.min(block.timestamp, periodFinish);
621     }
622 
623     function rewardPerToken() public view returns(uint256) {
624         if (totalSupply() == 0) {
625             return rewardPerTokenStored;
626         }
627         return rewardPerTokenStored.add(
628             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(totalSupply())
629         );
630     }
631 
632     function earned(address account) public view returns(uint256) {
633         return balanceOf(account).mul(
634             rewardPerToken().sub(userRewardPerTokenPaid[account])
635         ).div(1e18).add(rewards[account]);
636     }
637 
638     function stake(uint256 amount) public updateReward(msg.sender) {
639         require(amount > 0, "Cannot stake 0");
640         super.stake(amount);
641         emit Staked(msg.sender, amount);
642     }
643 
644     function withdraw(uint256 amount) public notLocked updateReward(msg.sender) {
645         require(amount > 0, "Cannot withdraw 0");
646         super.withdraw(amount);
647         emit Withdrawn(msg.sender, amount);
648     }
649 
650     function exit() public {
651         withdraw(balanceOf(msg.sender));
652         getReward();
653     }
654 
655     function getReward() public updateReward(msg.sender) {
656         uint256 reward = earned(msg.sender);
657         if (reward > 0) {
658             rewards[msg.sender] = 0;
659             df.safeTransfer(msg.sender, reward);
660             emit RewardPaid(msg.sender, reward);
661         }
662     }
663 
664     function notifyRewardAmount(uint256 reward) external onlyRewardDistribution updateReward(address(0)) {
665         if (block.timestamp >= periodFinish) {
666             rewardRate = reward.div(DURATION);
667         } else {
668             uint256 remaining = periodFinish.sub(block.timestamp);
669             uint256 leftover = remaining.mul(rewardRate);
670             rewardRate = reward.add(leftover).div(DURATION);
671         }
672         lastUpdateTime = block.timestamp;
673         periodFinish = block.timestamp.add(DURATION);
674         emit RewardAdded(reward);
675     }
676 
677     function lockedDetails() external view returns (bool, uint256) {
678         bool locked = periodFinish >= block.timestamp;
679         return (locked, periodFinish);
680     }
681 }