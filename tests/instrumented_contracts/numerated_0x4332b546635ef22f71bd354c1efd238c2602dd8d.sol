1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-25
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-08-03
7 */
8 
9 // File: @openzeppelin/contracts/math/Math.sol
10 
11 pragma solidity ^0.5.0;
12 
13 /**
14  * @dev Standard math utilities missing in the Solidity language.
15  */
16 library Math {
17     /**
18      * @dev Returns the largest of two numbers.
19      */
20     function max(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a >= b ? a : b;
22     }
23 
24     /**
25      * @dev Returns the smallest of two numbers.
26      */
27     function min(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a < b ? a : b;
29     }
30 
31     /**
32      * @dev Returns the average of two numbers. The result is rounded towards
33      * zero.
34      */
35     function average(uint256 a, uint256 b) internal pure returns (uint256) {
36         // (a + b) / 2 can overflow, so we distribute
37         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
38     }
39 }
40 
41 // File: @openzeppelin/contracts/math/SafeMath.sol
42 
43 pragma solidity ^0.5.0;
44 
45 /**
46  * @dev Wrappers over Solidity's arithmetic operations with added overflow
47  * checks.
48  *
49  * Arithmetic operations in Solidity wrap on overflow. This can easily result
50  * in bugs, because programmers usually assume that an overflow raises an
51  * error, which is the standard behavior in high level programming languages.
52  * `SafeMath` restores this intuition by reverting the transaction when an
53  * operation overflows.
54  *
55  * Using this library instead of the unchecked operations eliminates an entire
56  * class of bugs, so it's recommended to use it always.
57  */
58 library SafeMath {
59     /**
60      * @dev Returns the addition of two unsigned integers, reverting on
61      * overflow.
62      *
63      * Counterpart to Solidity's `+` operator.
64      *
65      * Requirements:
66      * - Addition cannot overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot overflow.
83      */
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     /**
89      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
90      * overflow (when the result is negative).
91      *
92      * Counterpart to Solidity's `-` operator.
93      *
94      * Requirements:
95      * - Subtraction cannot overflow.
96      *
97      * _Available since v2.4.0._
98      */
99     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117         // benefit is lost if 'b' is also tested.
118         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return div(a, b, "SafeMath: division by zero");
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator. Note: this function uses a
149      * `revert` opcode (which leaves remaining gas untouched) while Solidity
150      * uses an invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      * - The divisor cannot be zero.
154      *
155      * _Available since v2.4.0._
156      */
157     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         // Solidity only automatically asserts when dividing by 0
159         require(b > 0, errorMessage);
160         uint256 c = a / b;
161         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         return mod(a, b, "SafeMath: modulo by zero");
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * Reverts with custom message when dividing by zero.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      *
192      * _Available since v2.4.0._
193      */
194     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b != 0, errorMessage);
196         return a % b;
197     }
198 }
199 
200 // File: @openzeppelin/contracts/GSN/Context.sol
201 
202 pragma solidity ^0.5.0;
203 
204 /*
205  * @dev Provides information about the current execution context, including the
206  * sender of the transaction and its data. While these are generally available
207  * via msg.sender and msg.data, they should not be accessed in such a direct
208  * manner, since when dealing with GSN meta-transactions the account sending and
209  * paying for execution may not be the actual sender (as far as an application
210  * is concerned).
211  *
212  * This contract is only required for intermediate, library-like contracts.
213  */
214 contract Context {
215     // Empty internal constructor, to prevent people from mistakenly deploying
216     // an instance of this contract, which should be used via inheritance.
217     constructor () internal { }
218     // solhint-disable-previous-line no-empty-blocks
219 
220     function _msgSender() internal view returns (address payable) {
221         return msg.sender;
222     }
223 
224     function _msgData() internal view returns (bytes memory) {
225         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
226         return msg.data;
227     }
228 }
229 
230 // File: @openzeppelin/contracts/ownership/Ownable.sol
231 
232 pragma solidity ^0.5.0;
233 
234 /**
235  * @dev Contract module which provides a basic access control mechanism, where
236  * there is an account (an owner) that can be granted exclusive access to
237  * specific functions.
238  *
239  * This module is used through inheritance. It will make available the modifier
240  * `onlyOwner`, which can be applied to your functions to restrict their use to
241  * the owner.
242  */
243 contract Ownable is Context {
244     address private _owner;
245 
246     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
247 
248     /**
249      * @dev Initializes the contract setting the deployer as the initial owner.
250      */
251     constructor () internal {
252         _owner = _msgSender();
253         emit OwnershipTransferred(address(0), _owner);
254     }
255 
256     /**
257      * @dev Returns the address of the current owner.
258      */
259     function owner() public view returns (address) {
260         return _owner;
261     }
262 
263     /**
264      * @dev Throws if called by any account other than the owner.
265      */
266     modifier onlyOwner() {
267         require(isOwner(), "Ownable: caller is not the owner");
268         _;
269     }
270 
271     /**
272      * @dev Returns true if the caller is the current owner.
273      */
274     function isOwner() public view returns (bool) {
275         return _msgSender() == _owner;
276     }
277 
278     /**
279      * @dev Leaves the contract without owner. It will not be possible to call
280      * `onlyOwner` functions anymore. Can only be called by the current owner.
281      *
282      * NOTE: Renouncing ownership will leave the contract without an owner,
283      * thereby removing any functionality that is only available to the owner.
284      */
285     function renounceOwnership() public onlyOwner {
286         emit OwnershipTransferred(_owner, address(0));
287         _owner = address(0);
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      * Can only be called by the current owner.
293      */
294     function transferOwnership(address newOwner) public onlyOwner {
295         _transferOwnership(newOwner);
296     }
297 
298     /**
299      * @dev Transfers ownership of the contract to a new account (`newOwner`).
300      */
301     function _transferOwnership(address newOwner) internal {
302         require(newOwner != address(0), "Ownable: new owner is the zero address");
303         emit OwnershipTransferred(_owner, newOwner);
304         _owner = newOwner;
305     }
306 }
307 
308 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
309 
310 pragma solidity ^0.5.0;
311 
312 /**
313  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
314  * the optional functions; to access them see {ERC20Detailed}.
315  */
316 interface IERC20 {
317     /**
318      * @dev Returns the amount of tokens in existence.
319      */
320     function totalSupply() external view returns (uint256);
321 
322     /**
323      * @dev Returns the amount of tokens owned by `account`.
324      */
325     function balanceOf(address account) external view returns (uint256);
326 
327     /**
328      * @dev Moves `amount` tokens from the caller's account to `recipient`.
329      *
330      * Returns a boolean value indicating whether the operation succeeded.
331      *
332      * Emits a {Transfer} event.
333      */
334     function transfer(address recipient, uint256 amount) external returns (bool);
335 
336     /**
337      * @dev Returns the remaining number of tokens that `spender` will be
338      * allowed to spend on behalf of `owner` through {transferFrom}. This is
339      * zero by default.
340      *
341      * This value changes when {approve} or {transferFrom} are called.
342      */
343     function allowance(address owner, address spender) external view returns (uint256);
344 
345     /**
346      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * IMPORTANT: Beware that changing an allowance with this method brings the risk
351      * that someone may use both the old and the new allowance by unfortunate
352      * transaction ordering. One possible solution to mitigate this race
353      * condition is to first reduce the spender's allowance to 0 and set the
354      * desired value afterwards:
355      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
356      *
357      * Emits an {Approval} event.
358      */
359     function approve(address spender, uint256 amount) external returns (bool);
360 
361     /**
362      * @dev Moves `amount` tokens from `sender` to `recipient` using the
363      * allowance mechanism. `amount` is then deducted from the caller's
364      * allowance.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * Emits a {Transfer} event.
369      */
370     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
371 
372     /**
373      * @dev Emitted when `value` tokens are moved from one account (`from`) to
374      * another (`to`).
375      *
376      * Note that `value` may be zero.
377      */
378     event Transfer(address indexed from, address indexed to, uint256 value);
379 
380     /**
381      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
382      * a call to {approve}. `value` is the new allowance.
383      */
384     event Approval(address indexed owner, address indexed spender, uint256 value);
385 }
386 
387 // File: @openzeppelin/contracts/utils/Address.sol
388 
389 pragma solidity ^0.5.5;
390 
391 /**
392  * @dev Collection of functions related to the address type
393  */
394 library Address {
395     /**
396      * @dev Returns true if `account` is a contract.
397      *
398      * This test is non-exhaustive, and there may be false-negatives: during the
399      * execution of a contract's constructor, its address will be reported as
400      * not containing a contract.
401      *
402      * IMPORTANT: It is unsafe to assume that an address for which this
403      * function returns false is an externally-owned account (EOA) and not a
404      * contract.
405      */
406     function isContract(address account) internal view returns (bool) {
407         // This method relies in extcodesize, which returns 0 for contracts in
408         // construction, since the code is only stored at the end of the
409         // constructor execution.
410 
411         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
412         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
413         // for accounts without code, i.e. `keccak256('')`
414         bytes32 codehash;
415         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
416         // solhint-disable-next-line no-inline-assembly
417         assembly { codehash := extcodehash(account) }
418         return (codehash != 0x0 && codehash != accountHash);
419     }
420 
421     /**
422      * @dev Converts an `address` into `address payable`. Note that this is
423      * simply a type cast: the actual underlying value is not changed.
424      *
425      * _Available since v2.4.0._
426      */
427     function toPayable(address account) internal pure returns (address payable) {
428         return address(uint160(account));
429     }
430 
431     /**
432      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
433      * `recipient`, forwarding all available gas and reverting on errors.
434      *
435      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
436      * of certain opcodes, possibly making contracts go over the 2300 gas limit
437      * imposed by `transfer`, making them unable to receive funds via
438      * `transfer`. {sendValue} removes this limitation.
439      *
440      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
441      *
442      * IMPORTANT: because control is transferred to `recipient`, care must be
443      * taken to not create reentrancy vulnerabilities. Consider using
444      * {ReentrancyGuard} or the
445      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
446      *
447      * _Available since v2.4.0._
448      */
449     function sendValue(address payable recipient, uint256 amount) internal {
450         require(address(this).balance >= amount, "Address: insufficient balance");
451 
452         // solhint-disable-next-line avoid-call-value
453         (bool success, ) = recipient.call.value(amount)("");
454         require(success, "Address: unable to send value, recipient may have reverted");
455     }
456 }
457 
458 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
459 
460 pragma solidity ^0.5.0;
461 
462 
463 
464 
465 /**
466  * @title SafeERC20
467  * @dev Wrappers around ERC20 operations that throw on failure (when the token
468  * contract returns false). Tokens that return no value (and instead revert or
469  * throw on failure) are also supported, non-reverting calls are assumed to be
470  * successful.
471  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
472  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
473  */
474 library SafeERC20 {
475     using SafeMath for uint256;
476     using Address for address;
477 
478     function safeTransfer(IERC20 token, address to, uint256 value) internal {
479         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
480     }
481 
482     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
483         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
484     }
485 
486     function safeApprove(IERC20 token, address spender, uint256 value) internal {
487         // safeApprove should only be called when setting an initial allowance,
488         // or when resetting it to zero. To increase and decrease it, use
489         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
490         // solhint-disable-next-line max-line-length
491         require((value == 0) || (token.allowance(address(this), spender) == 0),
492             "SafeERC20: approve from non-zero to non-zero allowance"
493         );
494         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
495     }
496 
497     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
498         uint256 newAllowance = token.allowance(address(this), spender).add(value);
499         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
500     }
501 
502     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
503         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
504         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
505     }
506 
507     /**
508      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
509      * on the return value: the return value is optional (but if data is returned, it must not be false).
510      * @param token The token targeted by the call.
511      * @param data The call data (encoded using abi.encode or one of its variants).
512      */
513     function callOptionalReturn(IERC20 token, bytes memory data) private {
514         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
515         // we're implementing it ourselves.
516 
517         // A Solidity high level call has three parts:
518         //  1. The target address is checked to verify it contains contract code
519         //  2. The call itself is made, and success asserted
520         //  3. The return value is decoded, which in turn checks the size of the returned data.
521         // solhint-disable-next-line max-line-length
522         require(address(token).isContract(), "SafeERC20: call to non-contract");
523 
524         // solhint-disable-next-line avoid-low-level-calls
525         (bool success, bytes memory returndata) = address(token).call(data);
526         require(success, "SafeERC20: low-level call failed");
527 
528         if (returndata.length > 0) { // Return data is optional
529             // solhint-disable-next-line max-line-length
530             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
531         }
532     }
533 }
534 
535 // File: staking-audit.sol
536 
537 pragma solidity ^0.5.0;
538 
539 
540 
541 
542 
543 
544 contract IRewardDistributionRecipient is Ownable {
545     address rewardDistribution;
546 
547     function notifyRewardAmount(uint256 reward) external;
548 
549     modifier onlyRewardDistribution() {
550         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
551         _;
552     }
553 
554     function setRewardDistribution(address _rewardDistribution)
555         external
556         onlyOwner
557     {
558         rewardDistribution = _rewardDistribution;
559     }
560 }
561 
562 
563 contract LPTokenWrapper {
564 
565     using SafeMath for uint256;
566     using SafeERC20 for IERC20;
567 
568     IERC20 public lp = IERC20(0x5cBEfe14c66ba706e79CA4237fF10F218461014A);
569 
570     uint256 private _totalSupply;
571     mapping(address => uint256) private _balances;
572 
573     function totalSupply() public view returns(uint256) {
574         return _totalSupply;
575     }
576 
577     function balanceOf(address account) public view returns(uint256) {
578         return _balances[account];
579     }
580 
581     function stake(uint256 amount) public {
582         _totalSupply = _totalSupply.add(amount);
583         _balances[msg.sender] = _balances[msg.sender].add(amount);
584         lp.safeTransferFrom(msg.sender, address(this), amount);
585     }
586 
587     function withdraw(uint256 amount) public {
588         _totalSupply = _totalSupply.sub(amount);
589         _balances[msg.sender] = _balances[msg.sender].sub(amount);
590         lp.safeTransfer(msg.sender, amount);
591     }
592 }
593 
594 
595 contract darkUnipool is LPTokenWrapper, IRewardDistributionRecipient {
596 
597     IERC20 public DARK = IERC20(0x3108ccFd96816F9E663baA0E8c5951D229E8C6da);
598 
599     uint256 public constant DURATION = 60 days;
600 
601     uint256 public periodFinish = 0;
602     uint256 public rewardRate = 0;
603     uint256 public lastUpdateTime;
604     uint256 public rewardPerTokenStored;
605     mapping(address => uint256) public userRewardPerTokenPaid;
606     mapping(address => uint256) public rewards;
607 
608     event RewardAdded(uint256 reward);
609     event Staked(address indexed user, uint256 amount);
610     event Withdrawn(address indexed user, uint256 amount);
611     event RewardPaid(address indexed user, uint256 reward);
612 
613     modifier updateReward(address account) {
614         rewardPerTokenStored = rewardPerToken();
615         lastUpdateTime = lastTimeRewardApplicable();
616         if (account != address(0)) {
617             rewards[account] = earned(account);
618             userRewardPerTokenPaid[account] = rewardPerTokenStored;
619         }
620         _;
621     }
622 
623     function lastTimeRewardApplicable() public view returns(uint256) {
624         return Math.min(block.timestamp, periodFinish);
625     }
626 
627     function rewardPerToken() public view returns(uint256) {
628         if (totalSupply() == 0) {
629             return rewardPerTokenStored;
630         }
631         return rewardPerTokenStored.add(
632             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(totalSupply())
633         );
634     }
635 
636     function earned(address account) public view returns(uint256) {
637         return balanceOf(account).mul(
638             rewardPerToken().sub(userRewardPerTokenPaid[account])
639         ).div(1e18).add(rewards[account]);
640     }
641 
642     function stake(uint256 amount) public updateReward(msg.sender) {
643         require(amount > 0, "Cannot stake 0");
644         super.stake(amount);
645         emit Staked(msg.sender, amount);
646     }
647 
648     function withdraw(uint256 amount) public updateReward(msg.sender) {
649         require(amount > 0, "Cannot withdraw 0");
650         super.withdraw(amount);
651         emit Withdrawn(msg.sender, amount);
652     }
653 
654     function exit() public {
655         withdraw(balanceOf(msg.sender));
656         getReward();
657     }
658 
659     function getReward() public updateReward(msg.sender) {
660         uint256 reward = earned(msg.sender);
661         if (reward > 0) {
662             rewards[msg.sender] = 0;
663             DARK.safeTransfer(msg.sender, reward);
664             emit RewardPaid(msg.sender, reward);
665         }
666     }
667 
668     function notifyRewardAmount(uint256 reward) external onlyRewardDistribution updateReward(address(0)) {
669         if (block.timestamp >= periodFinish) {
670             rewardRate = reward.div(DURATION);
671         } else {
672             uint256 remaining = periodFinish.sub(block.timestamp);
673             uint256 leftover = remaining.mul(rewardRate);
674             rewardRate = reward.add(leftover).div(DURATION);
675         }
676         lastUpdateTime = block.timestamp;
677         periodFinish = block.timestamp.add(DURATION);
678         emit RewardAdded(reward);
679     }
680 
681     function lockedDetails() external view returns (bool, uint256) {
682         return (false, periodFinish);
683     }
684 }