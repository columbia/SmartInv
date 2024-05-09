1 // File: contracts/incentivizers/STRNIncentives.sol
2 
3 /*
4    ____            __   __        __   _
5   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
6  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
7 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
8      /___/
9 
10 * Synthetix: STRNIncentives.sol
11 *
12 * Docs: https://docs.synthetix.io/
13 *
14 *
15 * MIT License
16 * ===========
17 *
18 * Copyright (c) 2020 Synthetix
19 *
20 * Permission is hereby granted, free of charge, to any person obtaining a copy
21 * of this software and associated documentation files (the "Software"), to deal
22 * in the Software without restriction, including without limitation the rights
23 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
24 * copies of the Software, and to permit persons to whom the Software is
25 * furnished to do so, subject to the following conditions:
26 *
27 * The above copyright notice and this permission notice shall be included in all
28 * copies or substantial portions of the Software.
29 *
30 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
31 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
32 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
33 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
34 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
35 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
36 */
37 
38 // File: @openzeppelin/contracts/math/Math.sol
39 
40 pragma solidity 0.5.15;
41 
42 /**
43  * @dev Standard math utilities missing in the Solidity language.
44  */
45 library Math {
46     /**
47      * @dev Returns the largest of two numbers.
48      */
49     function max(uint256 a, uint256 b) internal pure returns (uint256) {
50         return a >= b ? a : b;
51     }
52 
53     /**
54      * @dev Returns the smallest of two numbers.
55      */
56     function min(uint256 a, uint256 b) internal pure returns (uint256) {
57         return a < b ? a : b;
58     }
59 
60     /**
61      * @dev Returns the average of two numbers. The result is rounded towards
62      * zero.
63      */
64     function average(uint256 a, uint256 b) internal pure returns (uint256) {
65         // (a + b) / 2 can overflow, so we distribute
66         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/math/SafeMath.sol
71 
72 pragma solidity 0.5.15;
73 
74 /**
75  * @dev Wrappers over Solidity's arithmetic operations with added overflow
76  * checks.
77  *
78  * Arithmetic operations in Solidity wrap on overflow. This can easily result
79  * in bugs, because programmers usually assume that an overflow raises an
80  * error, which is the standard behavior in high level programming languages.
81  * `SafeMath` restores this intuition by reverting the transaction when an
82  * operation overflows.
83  *
84  * Using this library instead of the unchecked operations eliminates an entire
85  * class of bugs, so it's recommended to use it always.
86  */
87 library SafeMath {
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         uint256 c = a + b;
99         require(c >= a, "SafeMath: addition overflow");
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the subtraction of two unsigned integers, reverting on
106      * overflow (when the result is negative).
107      *
108      * Counterpart to Solidity's `-` operator.
109      *
110      * Requirements:
111      * - Subtraction cannot overflow.
112      */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         return sub(a, b, "SafeMath: subtraction overflow");
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      * - Subtraction cannot overflow.
125      *
126      * _Available since v2.4.0._
127      */
128     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b <= a, errorMessage);
130         uint256 c = a - b;
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `*` operator.
140      *
141      * Requirements:
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers. Reverts on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b) internal pure returns (uint256) {
170         return div(a, b, "SafeMath: division by zero");
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      *
184      * _Available since v2.4.0._
185      */
186     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         // Solidity only automatically asserts when dividing by 0
188         require(b > 0, errorMessage);
189         uint256 c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * Reverts when dividing by zero.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      * - The divisor cannot be zero.
205      */
206     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
207         return mod(a, b, "SafeMath: modulo by zero");
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts with custom message when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      * - The divisor cannot be zero.
220      *
221      * _Available since v2.4.0._
222      */
223     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b != 0, errorMessage);
225         return a % b;
226     }
227 }
228 
229 // File: @openzeppelin/contracts/GSN/Context.sol
230 
231 pragma solidity 0.5.15;
232 
233 /*
234  * @dev Provides information about the current execution context, including the
235  * sender of the transaction and its data. While these are generally available
236  * via msg.sender and msg.data, they should not be accessed in such a direct
237  * manner, since when dealing with GSN meta-transactions the account sending and
238  * paying for execution may not be the actual sender (as far as an application
239  * is concerned).
240  *
241  * This contract is only required for intermediate, library-like contracts.
242  */
243 contract Context {
244     // Empty internal constructor, to prevent people from mistakenly deploying
245     // an instance of this contract, which should be used via inheritance.
246     constructor () internal { }
247     // solhint-disable-previous-line no-empty-blocks
248 
249     function _msgSender() internal view returns (address payable) {
250         return msg.sender;
251     }
252 
253     function _msgData() internal view returns (bytes memory) {
254         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
255         return msg.data;
256     }
257 }
258 
259 // File: @openzeppelin/contracts/ownership/Ownable.sol
260 
261 pragma solidity 0.5.15;
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * This module is used through inheritance. It will make available the modifier
269  * `onlyOwner`, which can be applied to your functions to restrict their use to
270  * the owner.
271  */
272 contract Ownable is Context {
273     address private _owner;
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277     /**
278      * @dev Initializes the contract setting the deployer as the initial owner.
279      */
280     constructor () internal {
281         _owner = _msgSender();
282         emit OwnershipTransferred(address(0), _owner);
283     }
284 
285     /**
286      * @dev Returns the address of the current owner.
287      */
288     function owner() public view returns (address) {
289         return _owner;
290     }
291 
292     /**
293      * @dev Throws if called by any account other than the owner.
294      */
295     modifier onlyOwner() {
296         require(isOwner(), "Ownable: caller is not the owner");
297         _;
298     }
299 
300     /**
301      * @dev Returns true if the caller is the current owner.
302      */
303     function isOwner() public view returns (bool) {
304         return _msgSender() == _owner;
305     }
306 
307     /**
308      * @dev Leaves the contract without owner. It will not be possible to call
309      * `onlyOwner` functions anymore. Can only be called by the current owner.
310      *
311      * NOTE: Renouncing ownership will leave the contract without an owner,
312      * thereby removing any functionality that is only available to the owner.
313      */
314     function renounceOwnership() public onlyOwner {
315         emit OwnershipTransferred(_owner, address(0));
316         _owner = address(0);
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      * Can only be called by the current owner.
322      */
323     function transferOwnership(address newOwner) public onlyOwner {
324         _transferOwnership(newOwner);
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      */
330     function _transferOwnership(address newOwner) internal {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         emit OwnershipTransferred(_owner, newOwner);
333         _owner = newOwner;
334     }
335 }
336 
337 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
338 
339 pragma solidity 0.5.15;
340 
341 /**
342  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
343  * the optional functions; to access them see {ERC20Detailed}.
344  */
345 interface IERC20 {
346     /**
347      * @dev Returns the amount of tokens in existence.
348      */
349     function totalSupply() external view returns (uint256);
350 
351     /**
352      * @dev Returns the amount of tokens owned by `account`.
353      */
354     function balanceOf(address account) external view returns (uint256);
355 
356     /**
357      * @dev Moves `amount` tokens from the caller's account to `recipient`.
358      *
359      * Returns a boolean value indicating whether the operation succeeded.
360      *
361      * Emits a {Transfer} event.
362      */
363     function transfer(address recipient, uint256 amount) external returns (bool);
364     function mint(address account, uint amount) external;
365 
366     /**
367      * @dev Returns the remaining number of tokens that `spender` will be
368      * allowed to spend on behalf of `owner` through {transferFrom}. This is
369      * zero by default.
370      *
371      * This value changes when {approve} or {transferFrom} are called.
372      */
373     function allowance(address owner, address spender) external view returns (uint256);
374 
375     /**
376      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * IMPORTANT: Beware that changing an allowance with this method brings the risk
381      * that someone may use both the old and the new allowance by unfortunate
382      * transaction ordering. One possible solution to mitigate this race
383      * condition is to first reduce the spender's allowance to 0 and set the
384      * desired value afterwards:
385      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
386      *
387      * Emits an {Approval} event.
388      */
389     function approve(address spender, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Moves `amount` tokens from `sender` to `recipient` using the
393      * allowance mechanism. `amount` is then deducted from the caller's
394      * allowance.
395      *
396      * Returns a boolean value indicating whether the operation succeeded.
397      *
398      * Emits a {Transfer} event.
399      */
400     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
401 
402     /**
403      * @dev Emitted when `value` tokens are moved from one account (`from`) to
404      * another (`to`).
405      *
406      * Note that `value` may be zero.
407      */
408     event Transfer(address indexed from, address indexed to, uint256 value);
409 
410     /**
411      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
412      * a call to {approve}. `value` is the new allowance.
413      */
414     event Approval(address indexed owner, address indexed spender, uint256 value);
415 }
416 
417 // File: @openzeppelin/contracts/utils/Address.sol
418 
419 pragma solidity 0.5.15;
420 
421 /**
422  * @dev Collection of functions related to the address type
423  */
424 library Address {
425     /**
426      * @dev Returns true if `account` is a contract.
427      *
428      * This test is non-exhaustive, and there may be false-negatives: during the
429      * execution of a contract's constructor, its address will be reported as
430      * not containing a contract.
431      *
432      * IMPORTANT: It is unsafe to assume that an address for which this
433      * function returns false is an externally-owned account (EOA) and not a
434      * contract.
435      */
436     function isContract(address account) internal view returns (bool) {
437         // This method relies in extcodesize, which returns 0 for contracts in
438         // construction, since the code is only stored at the end of the
439         // constructor execution.
440 
441         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
442         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
443         // for accounts without code, i.e. `keccak256('')`
444         bytes32 codehash;
445         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
446         // solhint-disable-next-line no-inline-assembly
447         assembly { codehash := extcodehash(account) }
448         return (codehash != 0x0 && codehash != accountHash);
449     }
450 
451     /**
452      * @dev Converts an `address` into `address payable`. Note that this is
453      * simply a type cast: the actual underlying value is not changed.
454      *
455      * _Available since v2.4.0._
456      */
457     function toPayable(address account) internal pure returns (address payable) {
458         return address(uint160(account));
459     }
460 
461     /**
462      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
463      * `recipient`, forwarding all available gas and reverting on errors.
464      *
465      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
466      * of certain opcodes, possibly making contracts go over the 2300 gas limit
467      * imposed by `transfer`, making them unable to receive funds via
468      * `transfer`. {sendValue} removes this limitation.
469      *
470      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
471      *
472      * IMPORTANT: because control is transferred to `recipient`, care must be
473      * taken to not create reentrancy vulnerabilities. Consider using
474      * {ReentrancyGuard} or the
475      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
476      *
477      * _Available since v2.4.0._
478      */
479     function sendValue(address payable recipient, uint256 amount) internal {
480         require(address(this).balance >= amount, "Address: insufficient balance");
481 
482         // solhint-disable-next-line avoid-call-value
483         (bool success, ) = recipient.call.value(amount)("");
484         require(success, "Address: unable to send value, recipient may have reverted");
485     }
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
489 
490 pragma solidity 0.5.15;
491 
492 
493 
494 
495 /**
496  * @title SafeERC20
497  * @dev Wrappers around ERC20 operations that throw on failure (when the token
498  * contract returns false). Tokens that return no value (and instead revert or
499  * throw on failure) are also supported, non-reverting calls are assumed to be
500  * successful.
501  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
502  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
503  */
504 library SafeERC20 {
505     using SafeMath for uint256;
506     using Address for address;
507 
508     function safeTransfer(IERC20 token, address to, uint256 value) internal {
509         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
510     }
511 
512     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
513         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
514     }
515 
516     function safeApprove(IERC20 token, address spender, uint256 value) internal {
517         // safeApprove should only be called when setting an initial allowance,
518         // or when resetting it to zero. To increase and decrease it, use
519         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
520         // solhint-disable-next-line max-line-length
521         require((value == 0) || (token.allowance(address(this), spender) == 0),
522             "SafeERC20: approve from non-zero to non-zero allowance"
523         );
524         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
525     }
526 
527     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
528         uint256 newAllowance = token.allowance(address(this), spender).add(value);
529         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
530     }
531 
532     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
533         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
534         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
535     }
536 
537     /**
538      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
539      * on the return value: the return value is optional (but if data is returned, it must not be false).
540      * @param token The token targeted by the call.
541      * @param data The call data (encoded using abi.encode or one of its variants).
542      */
543     function callOptionalReturn(IERC20 token, bytes memory data) private {
544         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
545         // we're implementing it ourselves.
546 
547         // A Solidity high level call has three parts:
548         //  1. The target address is checked to verify it contains contract code
549         //  2. The call itself is made, and success asserted
550         //  3. The return value is decoded, which in turn checks the size of the returned data.
551         // solhint-disable-next-line max-line-length
552         require(address(token).isContract(), "SafeERC20: call to non-contract");
553 
554         // solhint-disable-next-line avoid-low-level-calls
555         (bool success, bytes memory returndata) = address(token).call(data);
556         require(success, "SafeERC20: low-level call failed");
557 
558         if (returndata.length > 0) { // Return data is optional
559             // solhint-disable-next-line max-line-length
560             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
561         }
562     }
563 }
564 
565 // File: contracts/IRewardDistributionRecipient.sol
566 
567 // pragma solidity 0.5.15;
568 
569 
570 
571 // contract IRewardDistributionRecipient is Ownable {
572 //     address rewardDistribution;
573 
574 //     function notifyRewardAmount(uint256 reward) external;
575 
576 //     modifier onlyRewardDistribution() {
577 //         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
578 //         _;
579 //     }
580 
581 //     function setRewardDistribution(address _rewardDistribution)
582 //         external
583 //         onlyOwner
584 //     {
585 //         rewardDistribution = _rewardDistribution;
586 //     }
587 // }
588 
589 // File: contracts/CurveRewards.sol
590 
591 pragma solidity 0.5.15;
592 
593 
594 contract LPTokenWrapper is Ownable{
595     using SafeMath for uint256;
596     using SafeERC20 for IERC20;
597 
598     IERC20 public uni_lp;// = IERC20(0x884ae0a307a2482e3f6b1600279d16578b8c4042);
599 
600     uint256 private _totalSupply;
601 
602     mapping(address => uint256) private _balances;
603 
604 
605     constructor(address pool) public {
606         uni_lp = IERC20(pool);
607     }
608 
609     function totalSupply() public view returns (uint256) {
610         return _totalSupply;
611     }
612 
613     function balanceOf(address account) public view returns (uint256) {
614         return _balances[account];
615     }
616 
617     function stake(address sender, uint256 amount) public onlyOwner {
618         _totalSupply = _totalSupply.add(amount);
619         _balances[sender] = _balances[sender].add(amount);
620         // uni_lp.safeTransferFrom(msg.sender, address(this), amount);
621     }
622 
623     function withdraw(address sender, uint256 amount) public onlyOwner {
624         _totalSupply = _totalSupply.sub(amount);
625         _balances[sender] = _balances[sender].sub(amount);
626         //uni_lp.safeTransfer(msg.sender, amount);
627     }
628 }
629 
630 interface STRN {
631     function mint(address to, uint256 amount) external;
632 }
633 
634 pragma solidity 0.5.15;
635 
636 contract STRNIncentivizer is Ownable {
637     using SafeMath for uint256;
638     using SafeERC20 for IERC20;
639 
640     IERC20 public strn;// = IERC20(0x6a61255575eeF1Fd45CFA406d959180F463638fc);
641 
642     address public treasury;
643 
644     // uint256 public START_DELAY = 2 minutes;
645 
646     //Daily rate adjustment, rate increase for first month then decreases daily until all tokens distributed
647     uint256 public constant DURATION = 1 days;//5 minutes;
648     uint256 public constant RATE_INCREASE_DURATION = 30 days;//150 minutes;
649 
650     uint256 public constant MAX_REWARD = 8 * 10**6 * 10**18;
651 
652     uint256 public totalRewardMinted = 0;
653 
654     uint256 public initreward = 218193723 * 10**14; // 21819.3723 daily reward strain token
655     uint256 public inittreasuryreward = 218193723 * 10**13; // 2181.93723 daily strain token goes to treasury
656     uint256 public starttime = 1603939800; // 2020-09-20 00:00:00 (UTC +00:00)
657     uint256 public periodFinish = 0;
658     uint256 public rateIncreasePeriodFinish = 0;
659     uint256 public rewardRate = 0;
660     uint256 public lastUpdateTime;
661     uint256 public rewardPerTokenStored;
662 
663     bool public initialized = false;
664 
665     LPTokenWrapper[] pools;
666 
667     mapping(address => uint256) public userRewardPerTokenPaid;
668     mapping(address => uint256) public rewards;
669 
670 
671     event RewardAdded(uint256 reward);
672     event Staked(address indexed user, uint256 amount);
673     event Withdrawn(address indexed user, uint256 amount);
674     event RewardPaid(address indexed user, uint256 reward);
675     event PoolAdded(address pool, uint256 poolSize);
676 
677     constructor(address _strn) public {
678         strn = IERC20(_strn);
679     }
680 
681     function initialize(address _treasury) public onlyOwner{
682         treasury = _treasury;
683         strn.mint(address(this), initreward);
684         strn.mint(treasury, inittreasuryreward);
685         totalRewardMinted = totalRewardMinted.add(initreward).add(inittreasuryreward);
686         // starttime = block.timestamp.add(START_DELAY);
687         rewardRate = initreward.div(DURATION);
688         lastUpdateTime = starttime;
689         periodFinish = starttime.add(DURATION);
690         rateIncreasePeriodFinish = starttime.add(RATE_INCREASE_DURATION);
691     }
692 
693     function addPool(address pool) public onlyOwner{
694         LPTokenWrapper lptoken = new LPTokenWrapper(pool);
695         pools.push(lptoken);
696         emit PoolAdded(pool, pools.length);
697     }
698 
699     function totalSupply() public view returns (uint256) {
700         uint256 total_supply = 0;
701         for (uint i = 0; i < pools.length; i++) {
702             total_supply = total_supply.add(pools[i].totalSupply());
703         }
704         return total_supply;
705     }
706 
707     function balanceOf(address account) public view returns (uint256) {
708         uint256 balance = 0;
709         for (uint i = 0; i < pools.length; i++) {
710             balance = balance.add(pools[i].balanceOf(account));
711         }
712         return balance;
713     }
714 
715     function lastTimeRewardApplicable() public view returns (uint256) {
716         return Math.min(block.timestamp, periodFinish);
717     }
718 
719     function rewardPerToken() public view returns (uint256) {
720         if (totalSupply() == 0) {
721             return rewardPerTokenStored;
722         }
723         return
724             rewardPerTokenStored.add(
725                 lastTimeRewardApplicable()
726                     .sub(lastUpdateTime)
727                     .mul(rewardRate)
728                     .mul(1e18)
729                     .div(totalSupply())
730             );
731     }
732 
733     function earned(address account) public view returns (uint256) {
734         return
735             balanceOf(account)
736                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
737                 .div(1e18)
738                 .add(rewards[account]);
739     }
740 
741     function stake(uint256 amount, uint256 poolID) public checkStart {
742         require(amount > 0, "Cannot stake 0");
743         updateReward(msg.sender);
744         pools[poolID].stake(msg.sender, amount);
745         pools[poolID].uni_lp().safeTransferFrom(msg.sender, address(this), amount);
746         emit Staked(msg.sender, amount);
747     }
748 
749     function withdraw(uint256 amount, uint256 poolID) public checkStart {
750         require(amount > 0, "Cannot withdraw 0");
751         updateReward(msg.sender);
752         pools[poolID].withdraw(msg.sender, amount);
753         pools[poolID].uni_lp().safeTransfer(msg.sender, amount);
754         emit Withdrawn(msg.sender, amount);
755     }
756 
757     function exit(uint256 poolID) external {
758         withdraw(pools[poolID].balanceOf(msg.sender), poolID);
759         getReward();
760     }
761 
762     function getReward() public checkStart {
763         updateReward(msg.sender);
764         uint256 reward = earned(msg.sender);
765         if (reward > 0) {
766             rewards[msg.sender] = 0;
767             strn.safeTransfer(msg.sender, reward);
768             emit RewardPaid(msg.sender, reward);
769         }
770     }
771 
772     function updateReward(address account) public {
773         updateRewardRate();
774         rewardPerTokenStored = rewardPerToken();
775         lastUpdateTime = lastTimeRewardApplicable();
776         if (account != address(0)) {
777             rewards[account] = earned(account);
778             userRewardPerTokenPaid[account] = rewardPerTokenStored;
779         }
780     }
781 
782     //Reward increases during first month, then decreases
783     function updateRewardRate() public {
784         uint256 reward = 0;
785         uint256 treasuryReward = 0;
786 
787         if(totalRewardMinted >= MAX_REWARD){
788             // initreward = 0;
789             // inittreasuryreward = 0;
790             // rewardRate = 0;
791             return;
792         }
793 
794         while (block.timestamp >= periodFinish) {
795 
796             if(block.timestamp < rateIncreasePeriodFinish){
797                 initreward = initreward.mul(106).div(100);
798                 inittreasuryreward = inittreasuryreward.mul(106).div(100);
799             }
800             else{
801                 initreward = initreward.mul(98).div(100);
802                 inittreasuryreward = inittreasuryreward.mul(98).div(100);
803             }
804 
805             //If exceeded max rewards, distribute the remaining rewards
806             uint256 totalrewardstomint = totalRewardMinted.add(initreward).add(inittreasuryreward);
807             if(totalrewardstomint >= MAX_REWARD){
808                 uint256 rewardsdiff = MAX_REWARD.sub(totalRewardMinted);
809                 initreward = rewardsdiff.mul(90).div(100);
810                 inittreasuryreward = rewardsdiff.sub(initreward);
811             }
812 
813             reward = reward.add(initreward);
814             treasuryReward = treasuryReward.add(inittreasuryreward);
815             totalRewardMinted = totalRewardMinted.add(initreward).add(inittreasuryreward);
816 
817             rewardRate = initreward.div(DURATION);
818             periodFinish = periodFinish.add(DURATION);
819 
820             if(totalRewardMinted >= MAX_REWARD){
821                 break;
822             }
823         }
824         strn.mint(address(this), reward);
825         strn.mint(treasury, treasuryReward);
826         emit RewardAdded(reward);
827     }
828 
829     modifier checkStart(){
830         require(block.timestamp >= starttime,"not start");
831         _;
832     }
833 
834     // This function allows governance to take unsupported tokens out of the
835     // contract, since this one exists longer than the other pools.
836     // This is in an effort to make someone whole, should they seriously
837     // mess up. There is no guarantee governance will vote to return these.
838     // It also allows for removal of airdropped tokens.
839     function rescueTokens(IERC20 _token, uint256 amount, address to)
840         external
841     {
842         // only gov
843         require(msg.sender == owner(), "!governance");
844         // cant take staked asset
845         for (uint i = 0; i < pools.length; i++) {
846             IERC20 lp = pools[i].uni_lp();
847             require(_token != lp, "uni_lp");
848         }
849         // cant take reward asset
850         require(_token != strn, "strn");
851 
852         // transfer to
853         _token.safeTransfer(to, amount);
854     }
855 }