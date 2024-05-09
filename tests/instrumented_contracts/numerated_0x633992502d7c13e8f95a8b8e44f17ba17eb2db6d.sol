1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-17
3 */
4 
5 /*
6    ____            __   __        __   _
7   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
8  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
9 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
10      /___/
11 
12 * Synthetix: BEERewards.sol
13 *
14 * Docs: https://docs.synthetix.io/
15 *
16 *
17 * MIT License
18 * ===========
19 *
20 * Copyright (c) 2020 Synthetix
21 *
22 * Permission is hereby granted, free of charge, to any person obtaining a copy
23 * of this software and associated documentation files (the "Software"), to deal
24 * in the Software without restriction, including without limitation the rights
25 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
26 * copies of the Software, and to permit persons to whom the Software is
27 * furnished to do so, subject to the following conditions:
28 *
29 * The above copyright notice and this permission notice shall be included in all
30 * copies or substantial portions of the Software.
31 *
32 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
33 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
34 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
35 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
36 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
37 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
38 */
39 
40 // File: @openzeppelin/contracts/math/Math.sol
41 
42 pragma solidity ^0.5.0;
43 
44 /**
45  * @dev Standard math utilities missing in the Solidity language.
46  */
47 library Math {
48     /**
49      * @dev Returns the largest of two numbers.
50      */
51     function max(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a >= b ? a : b;
53     }
54 
55     /**
56      * @dev Returns the smallest of two numbers.
57      */
58     function min(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a < b ? a : b;
60     }
61 
62     /**
63      * @dev Returns the average of two numbers. The result is rounded towards
64      * zero.
65      */
66     function average(uint256 a, uint256 b) internal pure returns (uint256) {
67         // (a + b) / 2 can overflow, so we distribute
68         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
69     }
70     function sqrt(uint256 x) internal pure returns (uint256 y) {
71         uint256 z = (x + 1) / 2;
72         y = x;
73         while (z < y) {
74             y = z;
75             z = (x / z + z) / 2;
76         }
77     }
78 }
79 
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      * - Subtraction cannot overflow.
135      *
136      * _Available since v2.4.0._
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      * - The divisor cannot be zero.
193      *
194      * _Available since v2.4.0._
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         // Solidity only automatically asserts when dividing by 0
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      * - The divisor cannot be zero.
230      *
231      * _Available since v2.4.0._
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/GSN/Context.sol
240 
241 pragma solidity ^0.5.0;
242 
243 /*
244  * @dev Provides information about the current execution context, including the
245  * sender of the transaction and its data. While these are generally available
246  * via msg.sender and msg.data, they should not be accessed in such a direct
247  * manner, since when dealing with GSN meta-transactions the account sending and
248  * paying for execution may not be the actual sender (as far as an application
249  * is concerned).
250  *
251  * This contract is only required for intermediate, library-like contracts.
252  */
253 contract Context {
254     // Empty internal constructor, to prevent people from mistakenly deploying
255     // an instance of this contract, which should be used via inheritance.
256     constructor () internal { }
257     // solhint-disable-previous-line no-empty-blocks
258 
259     function _msgSender() internal view returns (address payable) {
260         return msg.sender;
261     }
262 
263     function _msgData() internal view returns (bytes memory) {
264         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
265         return msg.data;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/ownership/Ownable.sol
270 
271 pragma solidity ^0.5.0;
272 
273 /**
274  * @dev Contract module which provides a basic access control mechanism, where
275  * there is an account (an owner) that can be granted exclusive access to
276  * specific functions.
277  *
278  * This module is used through inheritance. It will make available the modifier
279  * `onlyOwner`, which can be applied to your functions to restrict their use to
280  * the owner.
281  */
282 contract Ownable is Context {
283     address private _owner;
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287     /**
288      * @dev Initializes the contract setting the deployer as the initial owner.
289      */
290     constructor () internal {
291         _owner = _msgSender();
292         emit OwnershipTransferred(address(0), _owner);
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(isOwner(), "Ownable: caller is not the owner");
307         _;
308     }
309 
310     /**
311      * @dev Returns true if the caller is the current owner.
312      */
313     function isOwner() public view returns (bool) {
314         return _msgSender() == _owner;
315     }
316 
317     /**
318      * @dev Leaves the contract without owner. It will not be possible to call
319      * `onlyOwner` functions anymore. Can only be called by the current owner.
320      *
321      * NOTE: Renouncing ownership will leave the contract without an owner,
322      * thereby removing any functionality that is only available to the owner.
323      */
324     function renounceOwnership() public onlyOwner {
325         emit OwnershipTransferred(_owner, address(0));
326         _owner = address(0);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Can only be called by the current owner.
332      */
333     function transferOwnership(address newOwner) public onlyOwner {
334         _transferOwnership(newOwner);
335     }
336 
337     /**
338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
339      */
340     function _transferOwnership(address newOwner) internal {
341         require(newOwner != address(0), "Ownable: new owner is the zero address");
342         emit OwnershipTransferred(_owner, newOwner);
343         _owner = newOwner;
344     }
345 }
346 
347 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
348 
349 pragma solidity ^0.5.0;
350 
351 /**
352  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
353  * the optional functions; to access them see {ERC20Detailed}.
354  */
355 interface IERC20 {
356     /**
357      * @dev Returns the amount of tokens in existence.
358      */
359     function totalSupply() external view returns (uint256);
360 
361     /**
362      * @dev Returns the amount of tokens owned by `account`.
363      */
364     function balanceOf(address account) external view returns (uint256);
365 
366     /**
367      * @dev Moves `amount` tokens from the caller's account to `recipient`.
368      *
369      * Returns a boolean value indicating whether the operation succeeded.
370      *
371      * Emits a {Transfer} event.
372      */
373     function transfer(address recipient, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Returns the remaining number of tokens that `spender` will be
377      * allowed to spend on behalf of `owner` through {transferFrom}. This is
378      * zero by default.
379      *
380      * This value changes when {approve} or {transferFrom} are called.
381      */
382     function allowance(address owner, address spender) external view returns (uint256);
383 
384     /**
385      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
386      *
387      * Returns a boolean value indicating whether the operation succeeded.
388      *
389      * IMPORTANT: Beware that changing an allowance with this method brings the risk
390      * that someone may use both the old and the new allowance by unfortunate
391      * transaction ordering. One possible solution to mitigate this race
392      * condition is to first reduce the spender's allowance to 0 and set the
393      * desired value afterwards:
394      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
395      *
396      * Emits an {Approval} event.
397      */
398     function approve(address spender, uint256 amount) external returns (bool);
399 
400     /**
401      * @dev Moves `amount` tokens from `sender` to `recipient` using the
402      * allowance mechanism. `amount` is then deducted from the caller's
403      * allowance.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
410 
411     /**
412      * @dev Emitted when `value` tokens are moved from one account (`from`) to
413      * another (`to`).
414      *
415      * Note that `value` may be zero.
416      */
417     event Transfer(address indexed from, address indexed to, uint256 value);
418 
419     /**
420      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
421      * a call to {approve}. `value` is the new allowance.
422      */
423     event Approval(address indexed owner, address indexed spender, uint256 value);
424 }
425 
426 // File: @openzeppelin/contracts/utils/Address.sol
427 
428 pragma solidity ^0.5.5;
429 
430 /**
431  * @dev Collection of functions related to the address type
432  */
433 library Address {
434     /**
435      * @dev Returns true if `account` is a contract.
436      *
437      * This test is non-exhaustive, and there may be false-negatives: during the
438      * execution of a contract's constructor, its address will be reported as
439      * not containing a contract.
440      *
441      * IMPORTANT: It is unsafe to assume that an address for which this
442      * function returns false is an externally-owned account (EOA) and not a
443      * contract.
444      */
445     function isContract(address account) internal view returns (bool) {
446         // This method relies in extcodesize, which returns 0 for contracts in
447         // construction, since the code is only stored at the end of the
448         // constructor execution.
449 
450         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
451         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
452         // for accounts without code, i.e. `keccak256('')`
453         bytes32 codehash;
454         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
455         // solhint-disable-next-line no-inline-assembly
456         assembly { codehash := extcodehash(account) }
457         return (codehash != 0x0 && codehash != accountHash);
458     }
459 
460     /**
461      * @dev Converts an `address` into `address payable`. Note that this is
462      * simply a type cast: the actual underlying value is not changed.
463      *
464      * _Available since v2.4.0._
465      */
466     function toPayable(address account) internal pure returns (address payable) {
467         return address(uint160(account));
468     }
469 
470     /**
471      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
472      * `recipient`, forwarding all available gas and reverting on errors.
473      *
474      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
475      * of certain opcodes, possibly making contracts go over the 2300 gas limit
476      * imposed by `transfer`, making them unable to receive funds via
477      * `transfer`. {sendValue} removes this limitation.
478      *
479      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
480      *
481      * IMPORTANT: because control is transferred to `recipient`, care must be
482      * taken to not create reentrancy vulnerabilities. Consider using
483      * {ReentrancyGuard} or the
484      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
485      *
486      * _Available since v2.4.0._
487      */
488     function sendValue(address payable recipient, uint256 amount) internal {
489         require(address(this).balance >= amount, "Address: insufficient balance");
490 
491         // solhint-disable-next-line avoid-call-value
492         (bool success, ) = recipient.call.value(amount)("");
493         require(success, "Address: unable to send value, recipient may have reverted");
494     }
495 }
496 
497 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
498 
499 pragma solidity ^0.5.0;
500 
501 
502 
503 
504 /**
505  * @title SafeERC20
506  * @dev Wrappers around ERC20 operations that throw on failure (when the token
507  * contract returns false). Tokens that return no value (and instead revert or
508  * throw on failure) are also supported, non-reverting calls are assumed to be
509  * successful.
510  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
511  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
512  */
513 library SafeERC20 {
514     using SafeMath for uint256;
515     using Address for address;
516 
517     function safeTransfer(IERC20 token, address to, uint256 value) internal {
518         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
519     }
520 
521     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
522         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
523     }
524 
525     function safeApprove(IERC20 token, address spender, uint256 value) internal {
526         // safeApprove should only be called when setting an initial allowance,
527         // or when resetting it to zero. To increase and decrease it, use
528         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
529         // solhint-disable-next-line max-line-length
530         require((value == 0) || (token.allowance(address(this), spender) == 0),
531             "SafeERC20: approve from non-zero to non-zero allowance"
532         );
533         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
534     }
535 
536     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
537         uint256 newAllowance = token.allowance(address(this), spender).add(value);
538         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
539     }
540 
541     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
542         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
543         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
544     }
545 
546     /**
547      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
548      * on the return value: the return value is optional (but if data is returned, it must not be false).
549      * @param token The token targeted by the call.
550      * @param data The call data (encoded using abi.encode or one of its variants).
551      */
552     function callOptionalReturn(IERC20 token, bytes memory data) private {
553         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
554         // we're implementing it ourselves.
555 
556         // A Solidity high level call has three parts:
557         //  1. The target address is checked to verify it contains contract code
558         //  2. The call itself is made, and success asserted
559         //  3. The return value is decoded, which in turn checks the size of the returned data.
560         // solhint-disable-next-line max-line-length
561         require(address(token).isContract(), "SafeERC20: call to non-contract");
562 
563         // solhint-disable-next-line avoid-low-level-calls
564         (bool success, bytes memory returndata) = address(token).call(data);
565         require(success, "SafeERC20: low-level call failed");
566 
567         if (returndata.length > 0) { // Return data is optional
568             // solhint-disable-next-line max-line-length
569             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
570         }
571     }
572 }
573 
574 // File: contracts/IRewardDistributionRecipient.sol
575 
576 pragma solidity ^0.5.0;
577 
578 
579 
580 contract IRewardDistributionRecipient is Ownable {
581     address public rewardDistribution;
582 
583     function notifyRewardAmount(uint256 reward) external;
584 
585     modifier onlyRewardDistribution() {
586         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
587         _;
588     }
589 
590     function setRewardDistribution(address _rewardDistribution)
591         external
592         onlyOwner
593     {
594         rewardDistribution = _rewardDistribution;
595     }
596 }
597 
598 // File: contracts/CurveRewards.sol
599 
600 pragma solidity ^0.5.0;
601 
602 
603 contract LPTokenWrapper {
604     using SafeMath for uint256;
605     using SafeERC20 for IERC20;
606 
607     IERC20 public link = IERC20(0x514910771AF9Ca656af840dff83E8264EcF986CA);
608 
609     uint256 public constant DECIMALS = 1e18;
610 
611     uint256 private _totalSupply;
612     uint256 private _sqrtTotalSupply;
613     uint256 private _maxSupply;
614     mapping(address => uint256) private _balances;
615 
616     function totalSupply() public view returns (uint256) {
617         return _totalSupply;
618     }
619 
620     function balanceOf(address account) public view returns (uint256) {
621         return _balances[account];
622     }
623 
624     function stake(uint256 amount) public {
625         _totalSupply = _totalSupply.add(amount);
626         _maxSupply = Math.max(_maxSupply, _totalSupply);
627         uint256 _prevBalance = _balances[msg.sender];
628         _balances[msg.sender] = _balances[msg.sender].add(amount);
629         _sqrtTotalSupply = _sqrtTotalSupply.sub(sqrtBalance(_prevBalance)).add(sqrtBalance(_balances[msg.sender]));
630         link.safeTransferFrom(msg.sender, address(this), amount);
631     }
632 
633     function withdraw(uint256 amount) public {
634         _totalSupply = _totalSupply.sub(amount);
635         uint256 _prevBalance = _balances[msg.sender];
636         _balances[msg.sender] = _balances[msg.sender].sub(amount);
637         _sqrtTotalSupply = _sqrtTotalSupply.sub(sqrtBalance(_prevBalance)).add(sqrtBalance(_balances[msg.sender]));
638         link.safeTransfer(msg.sender, amount);
639     }
640     function sqrtTotalSupply() public view returns (uint256) {
641         return _sqrtTotalSupply;
642     }
643     function maxSupply() public view returns (uint256) {
644         return _maxSupply;
645     }
646 
647     function sqrtBalance(uint256 balance) public pure returns (uint256) {
648         if (balance < DECIMALS) {
649             return balance;
650         } else {
651             return Math.sqrt(balance.div(DECIMALS)).mul(DECIMALS);
652         }
653     }
654 }
655 
656 contract BEELINKPool is LPTokenWrapper, IRewardDistributionRecipient {
657     IERC20 public bee = IERC20(0xcD4292701995F4707AE63fb1a48d80dB2c5F04D4);
658     IERC20 public honey = IERC20(0x932441a0F11482CB5f8B8900aB981a39806F88fa);
659     uint256 public constant DURATION = 625000; // ~7 1/4 days
660     uint256 public constant HONEYWAIT = 2 days; // 2 days
661     uint256 public constant EPOCH_REWARD = 500000;
662 
663     uint256 public starttime = 1599642000; // 09/09/2020 @ 9:00am (UTC +00:00)
664     uint256 public periodFinish = 0;
665     uint256 public rewardRate = 0;
666     uint256 public lastUpdateTime;
667     uint256 public rewardPerTokenStored;
668     mapping(address => uint256) public userRewardPerTokenPaid;
669     mapping(address => uint256) public rewards;
670     mapping(address => uint256) public paidReward;
671     mapping(address => uint256) public paidHoney;
672 
673     event RewardAdded(uint256 reward);
674     event Staked(address indexed user, uint256 amount);
675     event Withdrawn(address indexed user, uint256 amount);
676     event RewardPaid(address indexed user, uint256 reward);
677     event HoneyPaid(address indexed user, uint256 reward);
678 
679     modifier checkStart() {
680         require(block.timestamp >= starttime,"not start");
681         _;
682     }
683     modifier checkHoneyWait() {
684         require(block.timestamp >= starttime.add(HONEYWAIT), "need more bees");
685         require(maxSupply() >= EPOCH_REWARD.mul(DECIMALS), "need more pollen");
686         _;
687     }
688 
689     modifier updateReward(address account) {
690         rewardPerTokenStored = rewardPerToken();
691         lastUpdateTime = lastTimeRewardApplicable();
692         if (account != address(0)) {
693             rewards[account] = earned(account);
694             userRewardPerTokenPaid[account] = rewardPerTokenStored;
695         }
696         _;
697     }
698 
699     function lastTimeRewardApplicable() public view returns (uint256) {
700         return Math.min(block.timestamp, periodFinish);
701     }
702 
703     function rewardPerToken() public view returns (uint256) {
704         if (sqrtTotalSupply() == 0) {
705             return rewardPerTokenStored;
706         }
707         return
708             rewardPerTokenStored.add(
709                 lastTimeRewardApplicable()
710                     .sub(lastUpdateTime)
711                     .mul(rewardRate)
712                     .mul(1e18)
713                     .div(sqrtTotalSupply())
714             );
715     }
716 
717     function earned(address account) public view returns (uint256) {
718         return
719             sqrtBalance(balanceOf(account))
720                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
721                 .div(1e18)
722                 .add(rewards[account]);
723     }
724 
725     // stake visibility is public as overriding LPTokenWrapper's stake() function
726     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
727         require(amount > 0, "Cannot stake 0");
728         super.stake(amount);
729         emit Staked(msg.sender, amount);
730     }
731 
732     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
733         require(amount > 0, "Cannot withdraw 0");
734         super.withdraw(amount);
735         emit Withdrawn(msg.sender, amount);
736     }
737 
738     function exit() external {
739         withdraw(balanceOf(msg.sender));
740         getReward();
741     }
742 
743     function getReward() public updateReward(msg.sender) checkStart {
744         uint256 reward = earned(msg.sender);
745         if (reward > 0) {
746             paidReward[msg.sender] = paidReward[msg.sender].add(reward);
747             rewards[msg.sender] = 0;
748             bee.safeTransfer(msg.sender, reward);
749             emit RewardPaid(msg.sender, reward);
750         }
751     }
752     function allEarned(address account) public view returns (uint256) {
753         return earned(account).add(paidReward[account]);
754     }
755     function formatSqrt(uint256 balance) internal pure returns (uint256) {
756         return Math.sqrt(balance.div(1e18)).mul(1e18);
757     }
758     // allHoney - paidHoney, see getHoney(), if should wait, need return 0
759     function earnedHoney(address account) public view returns (uint256) {
760         if (block.timestamp >= starttime.add(HONEYWAIT) && maxSupply() >= EPOCH_REWARD.mul(DECIMALS)) {
761             return formatSqrt(allEarned(account)).sub(paidHoney[account]);
762         } else {
763             return 0;
764         }
765     } 
766     function getHoney() public checkHoneyWait {
767         uint256 beeAmount = allEarned(msg.sender);
768         require(beeAmount > 1e18, "bee amount need > 1");
769         uint256 allHoney = formatSqrt(beeAmount);
770         uint256 needPayHoney = allHoney.sub(paidHoney[msg.sender]);
771         if (needPayHoney > 0) {
772             paidHoney[msg.sender] = allHoney;
773             honey.safeTransfer(msg.sender, needPayHoney);
774             emit HoneyPaid(msg.sender, needPayHoney);
775         }
776     }
777 
778     function notifyRewardAmount(uint256 reward)
779         external
780         onlyRewardDistribution
781         updateReward(address(0))
782     {
783         if (block.timestamp > starttime) {
784           if (block.timestamp >= periodFinish) {
785               rewardRate = reward.div(DURATION);
786           } else {
787               uint256 remaining = periodFinish.sub(block.timestamp);
788               uint256 leftover = remaining.mul(rewardRate);
789               rewardRate = reward.add(leftover).div(DURATION);
790           }
791           lastUpdateTime = block.timestamp;
792           periodFinish = block.timestamp.add(DURATION);
793           emit RewardAdded(reward);
794         } else {
795           rewardRate = reward.div(DURATION);
796           lastUpdateTime = starttime;
797           periodFinish = starttime.add(DURATION);
798           emit RewardAdded(reward);
799         }
800     }
801     function burnHoney(uint256 amount) external onlyRewardDistribution {
802         require(block.timestamp > starttime.add(DURATION), "not finish");
803         honey.safeTransfer(address(0), amount);
804     }
805 }
