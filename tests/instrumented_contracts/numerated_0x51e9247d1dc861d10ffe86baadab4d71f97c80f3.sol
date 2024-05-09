1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: YFIRewards.sol
9 *
10 * Docs: https://docs.synthetix.io/
11 *
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 Synthetix
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 // solhint-disable max-line-length
37 
38 // File: @openzeppelin/contracts/math/Math.sol
39 
40 pragma solidity ^0.5.0;
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
72 pragma solidity ^0.5.0;
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
231 pragma solidity ^0.5.0;
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
261 pragma solidity ^0.5.0;
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
339 pragma solidity ^0.5.0;
340 
341 /**
342  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
343  * the optional functions; to access them see {ERC20Detailed}.
344  */
345 interface IERC20 {
346 
347     function decimals() external view returns(uint8);
348 
349     /**
350      * @dev Returns the amount of tokens in existence.
351      */
352     function totalSupply() external view returns (uint256);
353 
354     /**
355      * @dev Returns the amount of tokens owned by `account`.
356      */
357     function balanceOf(address account) external view returns (uint256);
358 
359     /**
360      * @dev Moves `amount` tokens from the caller's account to `recipient`.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * Emits a {Transfer} event.
365      */
366     function transfer(address recipient, uint256 amount) external returns (bool);
367     function mint(address account, uint amount) external;
368 
369     /**
370      * @dev Returns the remaining number of tokens that `spender` will be
371      * allowed to spend on behalf of `owner` through {transferFrom}. This is
372      * zero by default.
373      *
374      * This value changes when {approve} or {transferFrom} are called.
375      */
376     function allowance(address owner, address spender) external view returns (uint256);
377 
378     /**
379      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * IMPORTANT: Beware that changing an allowance with this method brings the risk
384      * that someone may use both the old and the new allowance by unfortunate
385      * transaction ordering. One possible solution to mitigate this race
386      * condition is to first reduce the spender's allowance to 0 and set the
387      * desired value afterwards:
388      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
389      *
390      * Emits an {Approval} event.
391      */
392     function approve(address spender, uint256 amount) external returns (bool);
393 
394     /**
395      * @dev Moves `amount` tokens from `sender` to `recipient` using the
396      * allowance mechanism. `amount` is then deducted from the caller's
397      * allowance.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * Emits a {Transfer} event.
402      */
403     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
404 
405     /**
406      * @dev Emitted when `value` tokens are moved from one account (`from`) to
407      * another (`to`).
408      *
409      * Note that `value` may be zero.
410      */
411     event Transfer(address indexed from, address indexed to, uint256 value);
412 
413     /**
414      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
415      * a call to {approve}. `value` is the new allowance.
416      */
417     event Approval(address indexed owner, address indexed spender, uint256 value);
418 }
419 
420 // File: @openzeppelin/contracts/utils/Address.sol
421 
422 pragma solidity ^0.5.5;
423 
424 /**
425  * @dev Collection of functions related to the address type
426  */
427 library Address {
428     /**
429      * @dev Returns true if `account` is a contract.
430      *
431      * This test is non-exhaustive, and there may be false-negatives: during the
432      * execution of a contract's constructor, its address will be reported as
433      * not containing a contract.
434      *
435      * IMPORTANT: It is unsafe to assume that an address for which this
436      * function returns false is an externally-owned account (EOA) and not a
437      * contract.
438      */
439     function isContract(address account) internal view returns (bool) {
440         // This method relies in extcodesize, which returns 0 for contracts in
441         // construction, since the code is only stored at the end of the
442         // constructor execution.
443 
444         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
445         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
446         // for accounts without code, i.e. `keccak256('')`
447         bytes32 codehash;
448         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
449         // solhint-disable-next-line no-inline-assembly
450         assembly { codehash := extcodehash(account) }
451         return (codehash != 0x0 && codehash != accountHash);
452     }
453 
454     /**
455      * @dev Converts an `address` into `address payable`. Note that this is
456      * simply a type cast: the actual underlying value is not changed.
457      *
458      * _Available since v2.4.0._
459      */
460     function toPayable(address account) internal pure returns (address payable) {
461         return address(uint160(account));
462     }
463 
464     /**
465      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
466      * `recipient`, forwarding all available gas and reverting on errors.
467      *
468      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
469      * of certain opcodes, possibly making contracts go over the 2300 gas limit
470      * imposed by `transfer`, making them unable to receive funds via
471      * `transfer`. {sendValue} removes this limitation.
472      *
473      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
474      *
475      * IMPORTANT: because control is transferred to `recipient`, care must be
476      * taken to not create reentrancy vulnerabilities. Consider using
477      * {ReentrancyGuard} or the
478      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
479      *
480      * _Available since v2.4.0._
481      */
482     function sendValue(address payable recipient, uint256 amount) internal {
483         require(address(this).balance >= amount, "Address: insufficient balance");
484 
485         // solhint-disable-next-line avoid-call-value
486         (bool success, ) = recipient.call.value(amount)("");
487         require(success, "Address: unable to send value, recipient may have reverted");
488     }
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
492 
493 pragma solidity ^0.5.0;
494 
495 
496 
497 
498 /**
499  * @title SafeERC20
500  * @dev Wrappers around ERC20 operations that throw on failure (when the token
501  * contract returns false). Tokens that return no value (and instead revert or
502  * throw on failure) are also supported, non-reverting calls are assumed to be
503  * successful.
504  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
505  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
506  */
507 library SafeERC20 {
508     using SafeMath for uint256;
509     using Address for address;
510 
511     function safeTransfer(IERC20 token, address to, uint256 value) internal {
512         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
513     }
514 
515     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
516         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
517     }
518 
519     function safeApprove(IERC20 token, address spender, uint256 value) internal {
520         // safeApprove should only be called when setting an initial allowance,
521         // or when resetting it to zero. To increase and decrease it, use
522         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
523         // solhint-disable-next-line max-line-length
524         require((value == 0) || (token.allowance(address(this), spender) == 0),
525             "SafeERC20: approve from non-zero to non-zero allowance"
526         );
527         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
528     }
529 
530     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).add(value);
532         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
533     }
534 
535     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
536         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
537         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
538     }
539 
540     /**
541      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
542      * on the return value: the return value is optional (but if data is returned, it must not be false).
543      * @param token The token targeted by the call.
544      * @param data The call data (encoded using abi.encode or one of its variants).
545      */
546     function callOptionalReturn(IERC20 token, bytes memory data) private {
547         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
548         // we're implementing it ourselves.
549 
550         // A Solidity high level call has three parts:
551         //  1. The target address is checked to verify it contains contract code
552         //  2. The call itself is made, and success asserted
553         //  3. The return value is decoded, which in turn checks the size of the returned data.
554         // solhint-disable-next-line max-line-length
555         require(address(token).isContract(), "SafeERC20: call to non-contract");
556 
557         // solhint-disable-next-line avoid-low-level-calls
558         (bool success, bytes memory returndata) = address(token).call(data);
559         require(success, "SafeERC20: low-level call failed");
560 
561         if (returndata.length > 0) { // Return data is optional
562             // solhint-disable-next-line max-line-length
563             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
564         }
565     }
566 }
567 
568 // File: contracts/IRewardDistributionRecipient.sol
569 
570 pragma solidity ^0.5.0;
571 
572 
573 
574 contract IRewardDistributionRecipient is Ownable {
575     address rewardDistribution;
576 
577     function notifyRewardAmount(uint256 reward) internal;
578 
579     modifier onlyRewardDistribution() {
580         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
581         _;
582     }
583 
584     function setRewardDistribution(address _rewardDistribution)
585         external
586         onlyOwner
587     {
588         rewardDistribution = _rewardDistribution;
589     }
590 }
591 
592 pragma solidity >=0.4.24 <0.6.0;
593 
594 
595 /**
596  * @title Initializable
597  *
598  * @dev Helper contract to support initializer functions. To use it, replace
599  * the constructor with a function that has the `initializer` modifier.
600  * WARNING: Unlike constructors, initializer functions must be manually
601  * invoked. This applies both to deploying an Initializable contract, as well
602  * as extending an Initializable contract via inheritance.
603  * WARNING: When used with inheritance, manual care must be taken to not invoke
604  * a parent initializer twice, or ensure that all initializers are idempotent,
605  * because this is not dealt with automatically as with constructors.
606  */
607 contract Initializable {
608 
609   /**
610    * @dev Indicates that the contract has been initialized.
611    */
612   bool private initialized;
613 
614   /**
615    * @dev Indicates that the contract is in the process of being initialized.
616    */
617   bool private initializing;
618 
619   /**
620    * @dev Modifier to use in the initializer function of a contract.
621    */
622   modifier initializer() {
623     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
624 
625     bool wasInitializing = initializing;
626     initializing = true;
627     initialized = true;
628 
629     _;
630 
631     initializing = wasInitializing;
632   }
633 
634   /// @dev Returns true if and only if the function is running in the constructor
635   function isConstructor() private view returns (bool) {
636     // extcodesize checks the size of the code stored in an address, and
637     // address returns the current address. Since the code is still not
638     // deployed when running a constructor, any checks on its code size will
639     // yield zero, making it an effective way to detect if a contract is
640     // under construction or not.
641     uint256 cs;
642     assembly { cs := extcodesize(address) }
643     return cs == 0;
644   }
645 
646   // Reserved storage space to allow for layout changes in the future.
647   uint256[50] private ______gap;
648 }
649 
650 
651 // File: contracts/CurveRewards.sol
652 
653 // solhint-enable max-line-length
654 pragma solidity ^0.5.0;
655 
656 contract LPTokenWrapper is Initializable {
657     using SafeMath for uint256;
658     using SafeERC20 for IERC20;
659 
660     IERC20 public y;
661 
662     uint256 private _totalSupply;
663     mapping(address => uint256) private _balances;
664 
665     function setStakeToken(address _y) internal {
666         y = IERC20(_y);
667     }
668 
669     function totalSupply() public view returns (uint256) {
670         return _totalSupply;
671     }
672 
673     function balanceOf(address account) public view returns (uint256) {
674         return _balances[account];
675     }
676 
677     function stake(uint256 amount) public {
678         _totalSupply = _totalSupply.add(amount);
679         _balances[msg.sender] = _balances[msg.sender].add(amount);
680         y.safeTransferFrom(msg.sender, address(this), amount);
681     }
682 
683     function withdraw(uint256 amount) public {
684         _totalSupply = _totalSupply.sub(amount);
685         _balances[msg.sender] = _balances[msg.sender].sub(amount);
686         y.safeTransfer(msg.sender, amount);
687     }
688 }
689 
690 contract AaplPool1 is LPTokenWrapper, IRewardDistributionRecipient {
691     IERC20 public based;
692     uint256 public duration;
693 
694     uint256 public initreward;
695     uint256 public starttime;
696     uint256 public periodFinish = 0;
697     uint256 public rewardRate = 0;
698     uint256 public lastUpdateTime;
699     uint256 public rewardPerTokenStored;
700     uint256 public totalRewards = 0;
701     bool public fairDistribution;
702     address public deployer;
703 
704     address constant uniFactory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
705 
706     mapping(address => uint256) public userRewardPerTokenPaid;
707     mapping(address => uint256) public rewards;
708 
709     event RewardAdded(uint256 reward);
710     event Staked(address indexed user, uint256 amount);
711     event Withdrawn(address indexed user, uint256 amount);
712     event RewardPaid(address indexed user, uint256 reward);
713 
714     modifier updateReward(address account) {
715         rewardPerTokenStored = rewardPerToken();
716         lastUpdateTime = lastTimeRewardApplicable();
717         if (account != address(0)) {
718             rewards[account] = earned(account);
719             userRewardPerTokenPaid[account] = rewardPerTokenStored;
720         }
721         _;
722     }
723 
724     modifier onlyDeployer() {
725         require(msg.sender == deployer);
726         _;
727     }
728 
729     constructor () public {
730         deployer = msg.sender;
731     }
732 
733     // https://uniswap.org/docs/v2/smart-contract-integration/getting-pair-addresses/
734     function genUniAddr(address left, address right) internal pure returns (address) {
735         address first = left < right ? left : right;
736         address second = left < right ? right : left;
737         address pair = address(uint(keccak256(abi.encodePacked(
738           hex'ff',
739           uniFactory,
740           keccak256(abi.encodePacked(first, second)),
741           hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f'
742         ))));
743         return pair;
744     }
745 
746     // changing function signature to break deployer code intentionally.
747     // ensures we can't accidentally use previous deployer
748     function initialize(
749         uint256 _duration,
750         uint256 _initreward,
751         uint256 _starttime,
752         address _susd,
753         address _based,
754         bool _fairDistribution
755     ) public onlyDeployer initializer {
756         setStakeToken(
757             genUniAddr(_based, _susd)
758         );
759         based = IERC20(_based);
760 
761         duration = _duration;
762         starttime = _starttime;
763         fairDistribution = _fairDistribution;
764         notifyRewardAmount(_initreward.mul(50).div(100));
765     }
766 
767     function lastTimeRewardApplicable() public view returns (uint256) {
768         return Math.min(block.timestamp, periodFinish);
769     }
770 
771     function rewardPerToken() public view returns (uint256) {
772         if (totalSupply() == 0) {
773             return rewardPerTokenStored;
774         }
775         return
776             rewardPerTokenStored.add(
777                 lastTimeRewardApplicable()
778                     .sub(lastUpdateTime)
779                     .mul(rewardRate)
780                     .mul(1e18)
781                     .div(totalSupply())
782             );
783     }
784 
785     function earned(address account) public view returns (uint256) {
786         return
787             balanceOf(account)
788                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
789                 .div(1e18)
790                 .add(rewards[account]);
791     }
792 
793     // stake visibility is public as overriding LPTokenWrapper's stake() function
794     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
795         require(amount > 0, "Cannot stake 0");
796         super.stake(amount);
797         emit Staked(msg.sender, amount);
798 
799         if (fairDistribution) {
800             // require amount below 12k for first 24 hours
801             require(
802                 balanceOf(msg.sender) <= 12000 * uint(10) ** y.decimals()
803                 || block.timestamp >= starttime.add(24*60*60),
804                 "fair distribution error"
805             );
806         }
807     }
808 
809     function withdraw(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
810         require(amount > 0, "Cannot withdraw 0");
811         super.withdraw(amount);
812         emit Withdrawn(msg.sender, amount);
813     }
814 
815     function exit() external {
816         withdraw(balanceOf(msg.sender));
817         getReward();
818     }
819 
820     function getReward() public updateReward(msg.sender) checkhalve checkStart{
821         uint256 reward = earned(msg.sender);
822         if (reward > 0) {
823             rewards[msg.sender] = 0;
824             based.safeTransfer(msg.sender, reward);
825             emit RewardPaid(msg.sender, reward);
826             totalRewards = totalRewards.add(reward);
827         }
828     }
829 
830     modifier checkhalve(){
831         if (block.timestamp >= periodFinish) {
832             initreward = initreward.mul(50).div(100);
833 
834             rewardRate = initreward.div(duration);
835             periodFinish = block.timestamp.add(duration);
836             emit RewardAdded(initreward);
837         }
838         _;
839     }
840 
841     modifier checkStart(){
842         require(block.timestamp > starttime,"not start");
843         _;
844     }
845 
846     function notifyRewardAmount(uint256 reward)
847         internal
848         updateReward(address(0))
849     {
850         if (block.timestamp >= periodFinish) {
851             rewardRate = reward.div(duration);
852         } else {
853             uint256 remaining = periodFinish.sub(block.timestamp);
854             uint256 leftover = remaining.mul(rewardRate);
855             rewardRate = reward.add(leftover).div(duration);
856         }
857         initreward = reward;
858         lastUpdateTime = block.timestamp;
859         periodFinish = block.timestamp.add(duration);
860         emit RewardAdded(reward);
861     }
862 }