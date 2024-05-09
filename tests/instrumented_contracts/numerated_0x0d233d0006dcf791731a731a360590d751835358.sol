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
36 // File: @openzeppelin/contracts/math/Math.sol
37 
38 pragma solidity ^0.5.0;
39 
40 /**
41  * @dev Standard math utilities missing in the Solidity language.
42  */
43 library Math {
44     /**
45      * @dev Returns the largest of two numbers.
46      */
47     function max(uint256 a, uint256 b) internal pure returns (uint256) {
48         return a >= b ? a : b;
49     }
50 
51     /**
52      * @dev Returns the smallest of two numbers.
53      */
54     function min(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a < b ? a : b;
56     }
57 
58     /**
59      * @dev Returns the average of two numbers. The result is rounded towards
60      * zero.
61      */
62     function average(uint256 a, uint256 b) internal pure returns (uint256) {
63         // (a + b) / 2 can overflow, so we distribute
64         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
65     }
66 }
67 
68 // File: @openzeppelin/contracts/math/SafeMath.sol
69 
70 pragma solidity ^0.5.0;
71 
72 /**
73  * @dev Wrappers over Solidity's arithmetic operations with added overflow
74  * checks.
75  *
76  * Arithmetic operations in Solidity wrap on overflow. This can easily result
77  * in bugs, because programmers usually assume that an overflow raises an
78  * error, which is the standard behavior in high level programming languages.
79  * `SafeMath` restores this intuition by reverting the transaction when an
80  * operation overflows.
81  *
82  * Using this library instead of the unchecked operations eliminates an entire
83  * class of bugs, so it's recommended to use it always.
84  */
85 library SafeMath {
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a, "SafeMath: addition overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return sub(a, b, "SafeMath: subtraction overflow");
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      * - Subtraction cannot overflow.
123      *
124      * _Available since v2.4.0._
125      */
126     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b <= a, errorMessage);
128         uint256 c = a - b;
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the multiplication of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `*` operator.
138      *
139      * Requirements:
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144         // benefit is lost if 'b' is also tested.
145         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
146         if (a == 0) {
147             return 0;
148         }
149 
150         uint256 c = a * b;
151         require(c / a == b, "SafeMath: multiplication overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers. Reverts on
158      * division by zero. The result is rounded towards zero.
159      *
160      * Counterpart to Solidity's `/` operator. Note: this function uses a
161      * `revert` opcode (which leaves remaining gas untouched) while Solidity
162      * uses an invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         return div(a, b, "SafeMath: division by zero");
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      *
182      * _Available since v2.4.0._
183      */
184     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         // Solidity only automatically asserts when dividing by 0
186         require(b > 0, errorMessage);
187         uint256 c = a / b;
188         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
205         return mod(a, b, "SafeMath: modulo by zero");
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts with custom message when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      *
219      * _Available since v2.4.0._
220      */
221     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b != 0, errorMessage);
223         return a % b;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/GSN/Context.sol
228 
229 pragma solidity ^0.5.0;
230 
231 /*
232  * @dev Provides information about the current execution context, including the
233  * sender of the transaction and its data. While these are generally available
234  * via msg.sender and msg.data, they should not be accessed in such a direct
235  * manner, since when dealing with GSN meta-transactions the account sending and
236  * paying for execution may not be the actual sender (as far as an application
237  * is concerned).
238  *
239  * This contract is only required for intermediate, library-like contracts.
240  */
241 contract Context {
242     // Empty internal constructor, to prevent people from mistakenly deploying
243     // an instance of this contract, which should be used via inheritance.
244     constructor () internal { }
245     // solhint-disable-previous-line no-empty-blocks
246 
247     function _msgSender() internal view returns (address payable) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view returns (bytes memory) {
252         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
253         return msg.data;
254     }
255 }
256 
257 // File: @openzeppelin/contracts/ownership/Ownable.sol
258 
259 pragma solidity ^0.5.0;
260 
261 /**
262  * @dev Contract module which provides a basic access control mechanism, where
263  * there is an account (an owner) that can be granted exclusive access to
264  * specific functions.
265  *
266  * This module is used through inheritance. It will make available the modifier
267  * `onlyOwner`, which can be applied to your functions to restrict their use to
268  * the owner.
269  */
270 contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275     /**
276      * @dev Initializes the contract setting the deployer as the initial owner.
277      */
278     constructor () internal {
279         _owner = _msgSender();
280         emit OwnershipTransferred(address(0), _owner);
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         require(isOwner(), "Ownable: caller is not the owner");
295         _;
296     }
297 
298     /**
299      * @dev Returns true if the caller is the current owner.
300      */
301     function isOwner() public view returns (bool) {
302         return _msgSender() == _owner;
303     }
304 
305     /**
306      * @dev Leaves the contract without owner. It will not be possible to call
307      * `onlyOwner` functions anymore. Can only be called by the current owner.
308      *
309      * NOTE: Renouncing ownership will leave the contract without an owner,
310      * thereby removing any functionality that is only available to the owner.
311      */
312     function renounceOwnership() public onlyOwner {
313         emit OwnershipTransferred(_owner, address(0));
314         _owner = address(0);
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      * Can only be called by the current owner.
320      */
321     function transferOwnership(address newOwner) public onlyOwner {
322         _transferOwnership(newOwner);
323     }
324 
325     /**
326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
327      */
328     function _transferOwnership(address newOwner) internal {
329         require(newOwner != address(0), "Ownable: new owner is the zero address");
330         emit OwnershipTransferred(_owner, newOwner);
331         _owner = newOwner;
332     }
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
336 
337 pragma solidity ^0.5.0;
338 
339 /**
340  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
341  * the optional functions; to access them see {ERC20Detailed}.
342  */
343 interface IERC20 {
344 
345     function decimals() external view returns(uint8);
346 
347     /**
348      * @dev Returns the amount of tokens in existence.
349      */
350     function totalSupply() external view returns (uint256);
351 
352     /**
353      * @dev Returns the amount of tokens owned by `account`.
354      */
355     function balanceOf(address account) external view returns (uint256);
356 
357     /**
358      * @dev Moves `amount` tokens from the caller's account to `recipient`.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * Emits a {Transfer} event.
363      */
364     function transfer(address recipient, uint256 amount) external returns (bool);
365     function mint(address account, uint amount) external;
366 
367     /**
368      * @dev Returns the remaining number of tokens that `spender` will be
369      * allowed to spend on behalf of `owner` through {transferFrom}. This is
370      * zero by default.
371      *
372      * This value changes when {approve} or {transferFrom} are called.
373      */
374     function allowance(address owner, address spender) external view returns (uint256);
375 
376     /**
377      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
378      *
379      * Returns a boolean value indicating whether the operation succeeded.
380      *
381      * IMPORTANT: Beware that changing an allowance with this method brings the risk
382      * that someone may use both the old and the new allowance by unfortunate
383      * transaction ordering. One possible solution to mitigate this race
384      * condition is to first reduce the spender's allowance to 0 and set the
385      * desired value afterwards:
386      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
387      *
388      * Emits an {Approval} event.
389      */
390     function approve(address spender, uint256 amount) external returns (bool);
391 
392     /**
393      * @dev Moves `amount` tokens from `sender` to `recipient` using the
394      * allowance mechanism. `amount` is then deducted from the caller's
395      * allowance.
396      *
397      * Returns a boolean value indicating whether the operation succeeded.
398      *
399      * Emits a {Transfer} event.
400      */
401     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
402 
403     /**
404      * @dev Emitted when `value` tokens are moved from one account (`from`) to
405      * another (`to`).
406      *
407      * Note that `value` may be zero.
408      */
409     event Transfer(address indexed from, address indexed to, uint256 value);
410 
411     /**
412      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
413      * a call to {approve}. `value` is the new allowance.
414      */
415     event Approval(address indexed owner, address indexed spender, uint256 value);
416 }
417 
418 // File: @openzeppelin/contracts/utils/Address.sol
419 
420 pragma solidity ^0.5.5;
421 
422 /**
423  * @dev Collection of functions related to the address type
424  */
425 library Address {
426     /**
427      * @dev Returns true if `account` is a contract.
428      *
429      * This test is non-exhaustive, and there may be false-negatives: during the
430      * execution of a contract's constructor, its address will be reported as
431      * not containing a contract.
432      *
433      * IMPORTANT: It is unsafe to assume that an address for which this
434      * function returns false is an externally-owned account (EOA) and not a
435      * contract.
436      */
437     function isContract(address account) internal view returns (bool) {
438         // This method relies in extcodesize, which returns 0 for contracts in
439         // construction, since the code is only stored at the end of the
440         // constructor execution.
441 
442         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
443         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
444         // for accounts without code, i.e. `keccak256('')`
445         bytes32 codehash;
446         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
447         // solhint-disable-next-line no-inline-assembly
448         assembly { codehash := extcodehash(account) }
449         return (codehash != 0x0 && codehash != accountHash);
450     }
451 
452     /**
453      * @dev Converts an `address` into `address payable`. Note that this is
454      * simply a type cast: the actual underlying value is not changed.
455      *
456      * _Available since v2.4.0._
457      */
458     function toPayable(address account) internal pure returns (address payable) {
459         return address(uint160(account));
460     }
461 
462     /**
463      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
464      * `recipient`, forwarding all available gas and reverting on errors.
465      *
466      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
467      * of certain opcodes, possibly making contracts go over the 2300 gas limit
468      * imposed by `transfer`, making them unable to receive funds via
469      * `transfer`. {sendValue} removes this limitation.
470      *
471      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
472      *
473      * IMPORTANT: because control is transferred to `recipient`, care must be
474      * taken to not create reentrancy vulnerabilities. Consider using
475      * {ReentrancyGuard} or the
476      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
477      *
478      * _Available since v2.4.0._
479      */
480     function sendValue(address payable recipient, uint256 amount) internal {
481         require(address(this).balance >= amount, "Address: insufficient balance");
482 
483         // solhint-disable-next-line avoid-call-value
484         (bool success, ) = recipient.call.value(amount)("");
485         require(success, "Address: unable to send value, recipient may have reverted");
486     }
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
490 
491 pragma solidity ^0.5.0;
492 
493 
494 
495 
496 /**
497  * @title SafeERC20
498  * @dev Wrappers around ERC20 operations that throw on failure (when the token
499  * contract returns false). Tokens that return no value (and instead revert or
500  * throw on failure) are also supported, non-reverting calls are assumed to be
501  * successful.
502  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
503  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
504  */
505 library SafeERC20 {
506     using SafeMath for uint256;
507     using Address for address;
508 
509     function safeTransfer(IERC20 token, address to, uint256 value) internal {
510         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
511     }
512 
513     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
514         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
515     }
516 
517     function safeApprove(IERC20 token, address spender, uint256 value) internal {
518         // safeApprove should only be called when setting an initial allowance,
519         // or when resetting it to zero. To increase and decrease it, use
520         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
521         // solhint-disable-next-line max-line-length
522         require((value == 0) || (token.allowance(address(this), spender) == 0),
523             "SafeERC20: approve from non-zero to non-zero allowance"
524         );
525         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
526     }
527 
528     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
529         uint256 newAllowance = token.allowance(address(this), spender).add(value);
530         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
531     }
532 
533     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
534         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
535         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     /**
539      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
540      * on the return value: the return value is optional (but if data is returned, it must not be false).
541      * @param token The token targeted by the call.
542      * @param data The call data (encoded using abi.encode or one of its variants).
543      */
544     function callOptionalReturn(IERC20 token, bytes memory data) private {
545         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
546         // we're implementing it ourselves.
547 
548         // A Solidity high level call has three parts:
549         //  1. The target address is checked to verify it contains contract code
550         //  2. The call itself is made, and success asserted
551         //  3. The return value is decoded, which in turn checks the size of the returned data.
552         // solhint-disable-next-line max-line-length
553         require(address(token).isContract(), "SafeERC20: call to non-contract");
554 
555         // solhint-disable-next-line avoid-low-level-calls
556         (bool success, bytes memory returndata) = address(token).call(data);
557         require(success, "SafeERC20: low-level call failed");
558 
559         if (returndata.length > 0) { // Return data is optional
560             // solhint-disable-next-line max-line-length
561             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
562         }
563     }
564 }
565 
566 // File: contracts/IRewardDistributionRecipient.sol
567 
568 pragma solidity ^0.5.0;
569 
570 
571 
572 contract IRewardDistributionRecipient is Ownable {
573     address rewardDistribution;
574 
575     function notifyRewardAmount(uint256 reward) internal;
576 
577     modifier onlyRewardDistribution() {
578         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
579         _;
580     }
581 
582     function setRewardDistribution(address _rewardDistribution)
583         external
584         onlyOwner
585     {
586         rewardDistribution = _rewardDistribution;
587     }
588 }
589 
590 pragma solidity >=0.4.24 <0.6.0;
591 
592 
593 /**
594  * @title Initializable
595  *
596  * @dev Helper contract to support initializer functions. To use it, replace
597  * the constructor with a function that has the `initializer` modifier.
598  * WARNING: Unlike constructors, initializer functions must be manually
599  * invoked. This applies both to deploying an Initializable contract, as well
600  * as extending an Initializable contract via inheritance.
601  * WARNING: When used with inheritance, manual care must be taken to not invoke
602  * a parent initializer twice, or ensure that all initializers are idempotent,
603  * because this is not dealt with automatically as with constructors.
604  */
605 contract Initializable {
606 
607   /**
608    * @dev Indicates that the contract has been initialized.
609    */
610   bool private initialized;
611 
612   /**
613    * @dev Indicates that the contract is in the process of being initialized.
614    */
615   bool private initializing;
616 
617   /**
618    * @dev Modifier to use in the initializer function of a contract.
619    */
620   modifier initializer() {
621     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
622 
623     bool wasInitializing = initializing;
624     initializing = true;
625     initialized = true;
626 
627     _;
628 
629     initializing = wasInitializing;
630   }
631 
632   /// @dev Returns true if and only if the function is running in the constructor
633   function isConstructor() private view returns (bool) {
634     // extcodesize checks the size of the code stored in an address, and
635     // address returns the current address. Since the code is still not
636     // deployed when running a constructor, any checks on its code size will
637     // yield zero, making it an effective way to detect if a contract is
638     // under construction or not.
639     uint256 cs;
640     assembly { cs := extcodesize(address) }
641     return cs == 0;
642   }
643 
644   // Reserved storage space to allow for layout changes in the future.
645   uint256[50] private ______gap;
646 }
647 
648 
649 // File: contracts/CurveRewards.sol
650 
651 pragma solidity ^0.5.0;
652 
653 
654 contract LPTokenWrapper is Initializable {
655     using SafeMath for uint256;
656     using SafeERC20 for IERC20;
657 
658     IERC20 public y;
659 
660     uint256 private _totalSupply;
661     mapping(address => uint256) private _balances;
662 
663     function initialize(address _y) public initializer {
664         y = IERC20(_y);
665     }
666 
667     function totalSupply() public view returns (uint256) {
668         return _totalSupply;
669     }
670 
671     function balanceOf(address account) public view returns (uint256) {
672         return _balances[account];
673     }
674 
675     function stake(uint256 amount) public {
676         _totalSupply = _totalSupply.add(amount);
677         _balances[msg.sender] = _balances[msg.sender].add(amount);
678         y.safeTransferFrom(msg.sender, address(this), amount);
679     }
680 
681     function withdraw(uint256 amount) public {
682         _totalSupply = _totalSupply.sub(amount);
683         _balances[msg.sender] = _balances[msg.sender].sub(amount);
684         y.safeTransfer(msg.sender, amount);
685     }
686 }
687 
688 contract YearnRewards is LPTokenWrapper, IRewardDistributionRecipient {
689     IERC20 public yfi;
690     uint256 public duration;
691 
692     uint256 public initreward;
693     uint256 public starttime;
694     uint256 public periodFinish = 0;
695     uint256 public rewardRate = 0;
696     uint256 public lastUpdateTime;
697     uint256 public rewardPerTokenStored;
698     uint256 public totalRewards = 0;
699     bool public fairDistribution;
700     address public deployer;
701 
702     mapping(address => uint256) public userRewardPerTokenPaid;
703     mapping(address => uint256) public rewards;
704 
705     event RewardAdded(uint256 reward);
706     event Staked(address indexed user, uint256 amount);
707     event Withdrawn(address indexed user, uint256 amount);
708     event RewardPaid(address indexed user, uint256 reward);
709 
710     modifier updateReward(address account) {
711         rewardPerTokenStored = rewardPerToken();
712         lastUpdateTime = lastTimeRewardApplicable();
713         if (account != address(0)) {
714             rewards[account] = earned(account);
715             userRewardPerTokenPaid[account] = rewardPerTokenStored;
716         }
717         _;
718     }
719 
720     constructor () public {
721         deployer = msg.sender;
722     }
723 
724     function initialize(address _y, address _yfi, uint256 _duration, uint256 _initreward, uint256 _starttime, bool _fairDistribution) public initializer {
725         // only deployer can initialize
726         require(deployer == msg.sender);
727 
728         super.initialize(_y);
729         yfi = IERC20(_yfi);
730 
731         duration = _duration;
732         starttime = _starttime;
733         fairDistribution = _fairDistribution;
734         notifyRewardAmount(_initreward.mul(50).div(100));
735     }
736 
737     function lastTimeRewardApplicable() public view returns (uint256) {
738         return Math.min(block.timestamp, periodFinish);
739     }
740 
741     function rewardPerToken() public view returns (uint256) {
742         if (totalSupply() == 0) {
743             return rewardPerTokenStored;
744         }
745         return
746             rewardPerTokenStored.add(
747                 lastTimeRewardApplicable()
748                     .sub(lastUpdateTime)
749                     .mul(rewardRate)
750                     .mul(1e18)
751                     .div(totalSupply())
752             );
753     }
754 
755     function earned(address account) public view returns (uint256) {
756         return
757             balanceOf(account)
758                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
759                 .div(1e18)
760                 .add(rewards[account]);
761     }
762 
763     // stake visibility is public as overriding LPTokenWrapper's stake() function
764     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
765         require(amount > 0, "Cannot stake 0");
766         super.stake(amount);
767         emit Staked(msg.sender, amount);
768 
769         if (fairDistribution) {
770             // require amount below 12k for first 24 hours
771             require(balanceOf(msg.sender) <= 12000 * uint(10) ** y.decimals() || block.timestamp >= starttime.add(24*60*60));
772         }
773     }
774 
775     function withdraw(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
776         require(amount > 0, "Cannot withdraw 0");
777         super.withdraw(amount);
778         emit Withdrawn(msg.sender, amount);
779     }
780 
781     function exit() external {
782         withdraw(balanceOf(msg.sender));
783         getReward();
784     }
785 
786     function getReward() public updateReward(msg.sender) checkhalve checkStart{
787         uint256 reward = earned(msg.sender);
788         if (reward > 0) {
789             rewards[msg.sender] = 0;
790             yfi.safeTransfer(msg.sender, reward);
791             emit RewardPaid(msg.sender, reward);
792             totalRewards = totalRewards.add(reward);
793         }
794     }
795 
796     modifier checkhalve(){
797         if (block.timestamp >= periodFinish) {
798             initreward = initreward.mul(50).div(100);
799 
800             rewardRate = initreward.div(duration);
801             periodFinish = block.timestamp.add(duration);
802             emit RewardAdded(initreward);
803         }
804         _;
805     }
806 
807     modifier checkStart(){
808         require(block.timestamp > starttime,"not start");
809         _;
810     }
811 
812     function notifyRewardAmount(uint256 reward)
813         internal
814         updateReward(address(0))
815     {
816         if (block.timestamp >= periodFinish) {
817             rewardRate = reward.div(duration);
818         } else {
819             uint256 remaining = periodFinish.sub(block.timestamp);
820             uint256 leftover = remaining.mul(rewardRate);
821             rewardRate = reward.add(leftover).div(duration);
822         }
823         initreward = reward;
824         lastUpdateTime = block.timestamp;
825         periodFinish = block.timestamp.add(duration);
826         emit RewardAdded(reward);
827     }
828 }