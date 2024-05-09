1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-03
3 */
4 
5 // File: @openzeppelin/contracts/math/Math.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @dev Standard math utilities missing in the Solidity language.
11  */
12 library Math {
13     /**
14      * @dev Returns the largest of two numbers.
15      */
16     function max(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a >= b ? a : b;
18     }
19 
20     /**
21      * @dev Returns the smallest of two numbers.
22      */
23     function min(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a < b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the average of two numbers. The result is rounded towards
29      * zero.
30      */
31     function average(uint256 a, uint256 b) internal pure returns (uint256) {
32         // (a + b) / 2 can overflow, so we distribute
33         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
34     }
35 }
36 
37 // File: @openzeppelin/contracts/math/SafeMath.sol
38 
39 pragma solidity ^0.5.0;
40 
41 /**
42  * @dev Wrappers over Solidity's arithmetic operations with added overflow
43  * checks.
44  *
45  * Arithmetic operations in Solidity wrap on overflow. This can easily result
46  * in bugs, because programmers usually assume that an overflow raises an
47  * error, which is the standard behavior in high level programming languages.
48  * `SafeMath` restores this intuition by reverting the transaction when an
49  * operation overflows.
50  *
51  * Using this library instead of the unchecked operations eliminates an entire
52  * class of bugs, so it's recommended to use it always.
53  */
54 library SafeMath {
55     /**
56      * @dev Returns the addition of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `+` operator.
60      *
61      * Requirements:
62      * - Addition cannot overflow.
63      */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a, "SafeMath: addition overflow");
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      * - Subtraction cannot overflow.
79      */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83 
84     /**
85      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
86      * overflow (when the result is negative).
87      *
88      * Counterpart to Solidity's `-` operator.
89      *
90      * Requirements:
91      * - Subtraction cannot overflow.
92      *
93      * _Available since v2.4.0._
94      */
95     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the multiplication of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `*` operator.
107      *
108      * Requirements:
109      * - Multiplication cannot overflow.
110      */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
113         // benefit is lost if 'b' is also tested.
114         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers. Reverts on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return div(a, b, "SafeMath: division by zero");
138     }
139 
140     /**
141      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
142      * division by zero. The result is rounded towards zero.
143      *
144      * Counterpart to Solidity's `/` operator. Note: this function uses a
145      * `revert` opcode (which leaves remaining gas untouched) while Solidity
146      * uses an invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * _Available since v2.4.0._
152      */
153     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         // Solidity only automatically asserts when dividing by 0
155         require(b > 0, errorMessage);
156         uint256 c = a / b;
157         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * Reverts when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         return mod(a, b, "SafeMath: modulo by zero");
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts with custom message when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      *
188      * _Available since v2.4.0._
189      */
190     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b != 0, errorMessage);
192         return a % b;
193     }
194 }
195 
196 // File: @openzeppelin/contracts/GSN/Context.sol
197 
198 pragma solidity ^0.5.0;
199 
200 /*
201  * @dev Provides information about the current execution context, including the
202  * sender of the transaction and its data. While these are generally available
203  * via msg.sender and msg.data, they should not be accessed in such a direct
204  * manner, since when dealing with GSN meta-transactions the account sending and
205  * paying for execution may not be the actual sender (as far as an application
206  * is concerned).
207  *
208  * This contract is only required for intermediate, library-like contracts.
209  */
210 contract Context {
211     // Empty internal constructor, to prevent people from mistakenly deploying
212     // an instance of this contract, which should be used via inheritance.
213     constructor () internal { }
214     // solhint-disable-previous-line no-empty-blocks
215 
216     function _msgSender() internal view returns (address payable) {
217         return msg.sender;
218     }
219 
220     function _msgData() internal view returns (bytes memory) {
221         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
222         return msg.data;
223     }
224 }
225 
226 // File: @openzeppelin/contracts/ownership/Ownable.sol
227 
228 pragma solidity ^0.5.0;
229 
230 /**
231  * @dev Contract module which provides a basic access control mechanism, where
232  * there is an account (an owner) that can be granted exclusive access to
233  * specific functions.
234  *
235  * This module is used through inheritance. It will make available the modifier
236  * `onlyOwner`, which can be applied to your functions to restrict their use to
237  * the owner.
238  */
239 contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor () internal {
248         _owner = _msgSender();
249         emit OwnershipTransferred(address(0), _owner);
250     }
251 
252     /**
253      * @dev Returns the address of the current owner.
254      */
255     function owner() public view returns (address) {
256         return _owner;
257     }
258 
259     /**
260      * @dev Throws if called by any account other than the owner.
261      */
262     modifier onlyOwner() {
263         require(isOwner(), "Ownable: caller is not the owner");
264         _;
265     }
266 
267     /**
268      * @dev Returns true if the caller is the current owner.
269      */
270     function isOwner() public view returns (bool) {
271         return _msgSender() == _owner;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public onlyOwner {
282         emit OwnershipTransferred(_owner, address(0));
283         _owner = address(0);
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Can only be called by the current owner.
289      */
290     function transferOwnership(address newOwner) public onlyOwner {
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      */
297     function _transferOwnership(address newOwner) internal {
298         require(newOwner != address(0), "Ownable: new owner is the zero address");
299         emit OwnershipTransferred(_owner, newOwner);
300         _owner = newOwner;
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
305 
306 pragma solidity ^0.5.0;
307 
308 /**
309  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
310  * the optional functions; to access them see {ERC20Detailed}.
311  */
312 interface IERC20 {
313     /**
314      * @dev Returns the amount of tokens in existence.
315      */
316     function totalSupply() external view returns (uint256);
317 
318     /**
319      * @dev Returns the amount of tokens owned by `account`.
320      */
321     function balanceOf(address account) external view returns (uint256);
322 
323     /**
324      * @dev Moves `amount` tokens from the caller's account to `recipient`.
325      *
326      * Returns a boolean value indicating whether the operation succeeded.
327      *
328      * Emits a {Transfer} event.
329      */
330     function transfer(address recipient, uint256 amount) external returns (bool);
331 
332     /**
333      * @dev Returns the remaining number of tokens that `spender` will be
334      * allowed to spend on behalf of `owner` through {transferFrom}. This is
335      * zero by default.
336      *
337      * This value changes when {approve} or {transferFrom} are called.
338      */
339     function allowance(address owner, address spender) external view returns (uint256);
340 
341     /**
342      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
343      *
344      * Returns a boolean value indicating whether the operation succeeded.
345      *
346      * IMPORTANT: Beware that changing an allowance with this method brings the risk
347      * that someone may use both the old and the new allowance by unfortunate
348      * transaction ordering. One possible solution to mitigate this race
349      * condition is to first reduce the spender's allowance to 0 and set the
350      * desired value afterwards:
351      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
352      *
353      * Emits an {Approval} event.
354      */
355     function approve(address spender, uint256 amount) external returns (bool);
356 
357     /**
358      * @dev Moves `amount` tokens from `sender` to `recipient` using the
359      * allowance mechanism. `amount` is then deducted from the caller's
360      * allowance.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * Emits a {Transfer} event.
365      */
366     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
367 
368     /**
369      * @dev Emitted when `value` tokens are moved from one account (`from`) to
370      * another (`to`).
371      *
372      * Note that `value` may be zero.
373      */
374     event Transfer(address indexed from, address indexed to, uint256 value);
375 
376     /**
377      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
378      * a call to {approve}. `value` is the new allowance.
379      */
380     event Approval(address indexed owner, address indexed spender, uint256 value);
381 }
382 
383 // File: @openzeppelin/contracts/utils/Address.sol
384 
385 pragma solidity ^0.5.5;
386 
387 /**
388  * @dev Collection of functions related to the address type
389  */
390 library Address {
391     /**
392      * @dev Returns true if `account` is a contract.
393      *
394      * This test is non-exhaustive, and there may be false-negatives: during the
395      * execution of a contract's constructor, its address will be reported as
396      * not containing a contract.
397      *
398      * IMPORTANT: It is unsafe to assume that an address for which this
399      * function returns false is an externally-owned account (EOA) and not a
400      * contract.
401      */
402     function isContract(address account) internal view returns (bool) {
403         // This method relies in extcodesize, which returns 0 for contracts in
404         // construction, since the code is only stored at the end of the
405         // constructor execution.
406 
407         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
408         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
409         // for accounts without code, i.e. `keccak256('')`
410         bytes32 codehash;
411         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
412         // solhint-disable-next-line no-inline-assembly
413         assembly { codehash := extcodehash(account) }
414         return (codehash != 0x0 && codehash != accountHash);
415     }
416 
417     /**
418      * @dev Converts an `address` into `address payable`. Note that this is
419      * simply a type cast: the actual underlying value is not changed.
420      *
421      * _Available since v2.4.0._
422      */
423     function toPayable(address account) internal pure returns (address payable) {
424         return address(uint160(account));
425     }
426 
427     /**
428      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
429      * `recipient`, forwarding all available gas and reverting on errors.
430      *
431      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
432      * of certain opcodes, possibly making contracts go over the 2300 gas limit
433      * imposed by `transfer`, making them unable to receive funds via
434      * `transfer`. {sendValue} removes this limitation.
435      *
436      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
437      *
438      * IMPORTANT: because control is transferred to `recipient`, care must be
439      * taken to not create reentrancy vulnerabilities. Consider using
440      * {ReentrancyGuard} or the
441      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
442      *
443      * _Available since v2.4.0._
444      */
445     function sendValue(address payable recipient, uint256 amount) internal {
446         require(address(this).balance >= amount, "Address: insufficient balance");
447 
448         // solhint-disable-next-line avoid-call-value
449         (bool success, ) = recipient.call.value(amount)("");
450         require(success, "Address: unable to send value, recipient may have reverted");
451     }
452 }
453 
454 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
455 
456 pragma solidity ^0.5.0;
457 
458 
459 
460 
461 /**
462  * @title SafeERC20
463  * @dev Wrappers around ERC20 operations that throw on failure (when the token
464  * contract returns false). Tokens that return no value (and instead revert or
465  * throw on failure) are also supported, non-reverting calls are assumed to be
466  * successful.
467  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
468  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
469  */
470 library SafeERC20 {
471     using SafeMath for uint256;
472     using Address for address;
473 
474     function safeTransfer(IERC20 token, address to, uint256 value) internal {
475         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
476     }
477 
478     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
479         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
480     }
481 
482     function safeApprove(IERC20 token, address spender, uint256 value) internal {
483         // safeApprove should only be called when setting an initial allowance,
484         // or when resetting it to zero. To increase and decrease it, use
485         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
486         // solhint-disable-next-line max-line-length
487         require((value == 0) || (token.allowance(address(this), spender) == 0),
488             "SafeERC20: approve from non-zero to non-zero allowance"
489         );
490         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
491     }
492 
493     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
494         uint256 newAllowance = token.allowance(address(this), spender).add(value);
495         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
496     }
497 
498     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
499         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
500         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
501     }
502 
503     /**
504      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
505      * on the return value: the return value is optional (but if data is returned, it must not be false).
506      * @param token The token targeted by the call.
507      * @param data The call data (encoded using abi.encode or one of its variants).
508      */
509     function callOptionalReturn(IERC20 token, bytes memory data) private {
510         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
511         // we're implementing it ourselves.
512 
513         // A Solidity high level call has three parts:
514         //  1. The target address is checked to verify it contains contract code
515         //  2. The call itself is made, and success asserted
516         //  3. The return value is decoded, which in turn checks the size of the returned data.
517         // solhint-disable-next-line max-line-length
518         require(address(token).isContract(), "SafeERC20: call to non-contract");
519 
520         // solhint-disable-next-line avoid-low-level-calls
521         (bool success, bytes memory returndata) = address(token).call(data);
522         require(success, "SafeERC20: low-level call failed");
523 
524         if (returndata.length > 0) { // Return data is optional
525             // solhint-disable-next-line max-line-length
526             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
527         }
528     }
529 }
530 
531 // File: staking-audit.sol
532 
533 pragma solidity ^0.5.0;
534 
535 
536 
537 
538 
539 
540 contract IRewardDistributionRecipient is Ownable {
541     address rewardDistribution;
542 
543     function notifyRewardAmount(uint256 reward) external;
544 
545     modifier onlyRewardDistribution() {
546         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
547         _;
548     }
549 
550     function setRewardDistribution(address _rewardDistribution)
551         external
552         onlyOwner
553     {
554         rewardDistribution = _rewardDistribution;
555     }
556 }
557 
558 
559 contract LPTokenWrapper {
560 
561     using SafeMath for uint256;
562     using SafeERC20 for IERC20;
563 
564     IERC20 public lp = IERC20(0xa1d0E215a23d7030842FC67cE582a6aFa3CCaB83);
565 
566     uint256 private _totalSupply;
567     mapping(address => uint256) private _balances;
568 
569     function totalSupply() public view returns(uint256) {
570         return _totalSupply;
571     }
572 
573     function balanceOf(address account) public view returns(uint256) {
574         return _balances[account];
575     }
576 
577     function stake(uint256 amount) public {
578         _totalSupply = _totalSupply.add(amount);
579         _balances[msg.sender] = _balances[msg.sender].add(amount);
580         lp.safeTransferFrom(msg.sender, address(this), amount);
581     }
582 
583     function withdraw(uint256 amount) public {
584         _totalSupply = _totalSupply.sub(amount);
585         _balances[msg.sender] = _balances[msg.sender].sub(amount);
586         lp.safeTransfer(msg.sender, amount);
587     }
588 }
589 
590 
591 contract Unipool is LPTokenWrapper, IRewardDistributionRecipient {
592 
593     IERC20 public OUTTOKEN = IERC20(0xa1d0E215a23d7030842FC67cE582a6aFa3CCaB83);
594 
595     uint256 public constant DURATION = 7 days;
596 
597     uint256 public periodFinish = 0;
598     uint256 public rewardRate = 0;
599     uint256 public lastUpdateTime;
600     uint256 public rewardPerTokenStored;
601     mapping(address => uint256) public userRewardPerTokenPaid;
602     mapping(address => uint256) public rewards;
603     mapping(address => uint256) public canWithdrawTime;
604 
605     event RewardAdded(uint256 reward);
606     event Staked(address indexed user, uint256 amount);
607     event Withdrawn(address indexed user, uint256 amount);
608     event RewardPaid(address indexed user, uint256 reward);
609 
610     modifier updateReward(address account) {
611         rewardPerTokenStored = rewardPerToken();
612         lastUpdateTime = lastTimeRewardApplicable();
613         if (account != address(0)) {
614             rewards[account] = earned(account);
615             userRewardPerTokenPaid[account] = rewardPerTokenStored;
616         }
617         _;
618     }
619 
620     function lastTimeRewardApplicable() public view returns(uint256) {
621         return Math.min(block.timestamp, periodFinish);
622     }
623 
624     function rewardPerToken() public view returns(uint256) {
625         if (totalSupply() == 0) {
626             return rewardPerTokenStored;
627         }
628         return rewardPerTokenStored.add(
629             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(totalSupply())
630         );
631     }
632 
633     function earned(address account) public view returns(uint256) {
634         return balanceOf(account).mul(
635             rewardPerToken().sub(userRewardPerTokenPaid[account])
636         ).div(1e18).add(rewards[account]);
637     }
638 
639     function stake(uint256 amount) public updateReward(msg.sender) {
640         require(amount > 0, "Cannot stake 0");
641         super.stake(amount);
642         canWithdrawTime[msg.sender] = now+3 days;
643         emit Staked(msg.sender, amount);
644     }
645 
646     function withdraw(uint256 amount) public updateReward(msg.sender) {
647         require(amount > 0, "Cannot withdraw 0");
648         require(now>canWithdrawTime[msg.sender],"!3 days");
649         super.withdraw(amount);
650         emit Withdrawn(msg.sender, amount);
651     }
652 
653     function exit() public {
654         withdraw(balanceOf(msg.sender));
655         getReward();
656     }
657 
658     function getReward() public updateReward(msg.sender) {
659         uint256 reward = earned(msg.sender);
660         if (reward > 0) {
661             rewards[msg.sender] = 0;
662             OUTTOKEN.safeTransfer(msg.sender, reward);
663             emit RewardPaid(msg.sender, reward);
664         }
665     }
666 
667     function notifyRewardAmount(uint256 reward) external onlyRewardDistribution updateReward(address(0)) {
668         if (block.timestamp >= periodFinish) {
669             rewardRate = reward.div(DURATION);
670         } else {
671             uint256 remaining = periodFinish.sub(block.timestamp);
672             uint256 leftover = remaining.mul(rewardRate);
673             rewardRate = reward.add(leftover).div(DURATION);
674         }
675         lastUpdateTime = block.timestamp;
676         periodFinish = block.timestamp.add(DURATION);
677         emit RewardAdded(reward);
678     }
679 
680     function lockedDetails() external view returns (bool, uint256) {
681         return (false, periodFinish);
682     }
683 }