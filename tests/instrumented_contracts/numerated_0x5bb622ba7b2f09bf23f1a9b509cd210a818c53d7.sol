1 /**
2  *Submitted for verification at Etherscan.io on
3 */
4 
5 /*
6    ____            __   __        __   _
7   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
8  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
9 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
10      /___/
11 
12 * Synthetix: YFIRewards.sol
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
70 }
71 
72 // File: @openzeppelin/contracts/math/SafeMath.sol
73 
74 pragma solidity ^0.5.0;
75 
76 /**
77  * @dev Wrappers over Solidity's arithmetic operations with added overflow
78  * checks.
79  *
80  * Arithmetic operations in Solidity wrap on overflow. This can easily result
81  * in bugs, because programmers usually assume that an overflow raises an
82  * error, which is the standard behavior in high level programming languages.
83  * `SafeMath` restores this intuition by reverting the transaction when an
84  * operation overflows.
85  *
86  * Using this library instead of the unchecked operations eliminates an entire
87  * class of bugs, so it's recommended to use it always.
88  */
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      * - Subtraction cannot overflow.
127      *
128      * _Available since v2.4.0._
129      */
130     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b <= a, errorMessage);
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      * - The divisor cannot be zero.
185      *
186      * _Available since v2.4.0._
187      */
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         // Solidity only automatically asserts when dividing by 0
190         require(b > 0, errorMessage);
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      * - The divisor cannot be zero.
222      *
223      * _Available since v2.4.0._
224      */
225     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b != 0, errorMessage);
227         return a % b;
228     }
229 }
230 
231 // File: @openzeppelin/contracts/GSN/Context.sol
232 
233 pragma solidity ^0.5.0;
234 
235 /*
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with GSN meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 contract Context {
246     // Empty internal constructor, to prevent people from mistakenly deploying
247     // an instance of this contract, which should be used via inheritance.
248     constructor () internal { }
249     // solhint-disable-previous-line no-empty-blocks
250 
251     function _msgSender() internal view returns (address payable) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view returns (bytes memory) {
256         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
257         return msg.data;
258     }
259 }
260 
261 // File: @openzeppelin/contracts/ownership/Ownable.sol
262 
263 pragma solidity ^0.5.0;
264 
265 /**
266  * @dev Contract module which provides a basic access control mechanism, where
267  * there is an account (an owner) that can be granted exclusive access to
268  * specific functions.
269  *
270  * This module is used through inheritance. It will make available the modifier
271  * `onlyOwner`, which can be applied to your functions to restrict their use to
272  * the owner.
273  */
274 contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor () internal {
283         _owner = _msgSender();
284         emit OwnershipTransferred(address(0), _owner);
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(isOwner(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Returns true if the caller is the current owner.
304      */
305     function isOwner() public view returns (bool) {
306         return _msgSender() == _owner;
307     }
308 
309     /**
310      * @dev Leaves the contract without owner. It will not be possible to call
311      * `onlyOwner` functions anymore. Can only be called by the current owner.
312      *
313      * NOTE: Renouncing ownership will leave the contract without an owner,
314      * thereby removing any functionality that is only available to the owner.
315      */
316     function renounceOwnership() public onlyOwner {
317         emit OwnershipTransferred(_owner, address(0));
318         _owner = address(0);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public onlyOwner {
326         _transferOwnership(newOwner);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      */
332     function _transferOwnership(address newOwner) internal {
333         require(newOwner != address(0), "Ownable: new owner is the zero address");
334         emit OwnershipTransferred(_owner, newOwner);
335         _owner = newOwner;
336     }
337 }
338 
339 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
340 
341 pragma solidity ^0.5.0;
342 
343 /**
344  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
345  * the optional functions; to access them see {ERC20Detailed}.
346  */
347 interface IERC20 {
348 
349     function decimals() external view returns(uint8);
350 
351     /**
352      * @dev Returns the amount of tokens in existence.
353      */
354     function totalSupply() external view returns (uint256);
355 
356     /**
357      * @dev Returns the amount of tokens owned by `account`.
358      */
359     function balanceOf(address account) external view returns (uint256);
360 
361     /**
362      * @dev Moves `amount` tokens from the caller's account to `recipient`.
363      *
364      * Returns a boolean value indicating whether the operation succeeded.
365      *
366      * Emits a {Transfer} event.
367      */
368     function transfer(address recipient, uint256 amount) external returns (bool);
369     function mint(address account, uint amount) external;
370 
371     /**
372      * @dev Returns the remaining number of tokens that `spender` will be
373      * allowed to spend on behalf of `owner` through {transferFrom}. This is
374      * zero by default.
375      *
376      * This value changes when {approve} or {transferFrom} are called.
377      */
378     function allowance(address owner, address spender) external view returns (uint256);
379 
380     /**
381      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * IMPORTANT: Beware that changing an allowance with this method brings the risk
386      * that someone may use both the old and the new allowance by unfortunate
387      * transaction ordering. One possible solution to mitigate this race
388      * condition is to first reduce the spender's allowance to 0 and set the
389      * desired value afterwards:
390      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
391      *
392      * Emits an {Approval} event.
393      */
394     function approve(address spender, uint256 amount) external returns (bool);
395 
396     /**
397      * @dev Moves `amount` tokens from `sender` to `recipient` using the
398      * allowance mechanism. `amount` is then deducted from the caller's
399      * allowance.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Emitted when `value` tokens are moved from one account (`from`) to
409      * another (`to`).
410      *
411      * Note that `value` may be zero.
412      */
413     event Transfer(address indexed from, address indexed to, uint256 value);
414 
415     /**
416      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
417      * a call to {approve}. `value` is the new allowance.
418      */
419     event Approval(address indexed owner, address indexed spender, uint256 value);
420 }
421 
422 // File: @openzeppelin/contracts/utils/Address.sol
423 
424 pragma solidity ^0.5.5;
425 
426 /**
427  * @dev Collection of functions related to the address type
428  */
429 library Address {
430     /**
431      * @dev Returns true if `account` is a contract.
432      *
433      * This test is non-exhaustive, and there may be false-negatives: during the
434      * execution of a contract's constructor, its address will be reported as
435      * not containing a contract.
436      *
437      * IMPORTANT: It is unsafe to assume that an address for which this
438      * function returns false is an externally-owned account (EOA) and not a
439      * contract.
440      */
441     function isContract(address account) internal view returns (bool) {
442         // This method relies in extcodesize, which returns 0 for contracts in
443         // construction, since the code is only stored at the end of the
444         // constructor execution.
445 
446         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
447         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
448         // for accounts without code, i.e. `keccak256('')`
449         bytes32 codehash;
450         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
451         // solhint-disable-next-line no-inline-assembly
452         assembly { codehash := extcodehash(account) }
453         return (codehash != 0x0 && codehash != accountHash);
454     }
455 
456     /**
457      * @dev Converts an `address` into `address payable`. Note that this is
458      * simply a type cast: the actual underlying value is not changed.
459      *
460      * _Available since v2.4.0._
461      */
462     function toPayable(address account) internal pure returns (address payable) {
463         return address(uint160(account));
464     }
465 
466     /**
467      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
468      * `recipient`, forwarding all available gas and reverting on errors.
469      *
470      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
471      * of certain opcodes, possibly making contracts go over the 2300 gas limit
472      * imposed by `transfer`, making them unable to receive funds via
473      * `transfer`. {sendValue} removes this limitation.
474      *
475      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
476      *
477      * IMPORTANT: because control is transferred to `recipient`, care must be
478      * taken to not create reentrancy vulnerabilities. Consider using
479      * {ReentrancyGuard} or the
480      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
481      *
482      * _Available since v2.4.0._
483      */
484     function sendValue(address payable recipient, uint256 amount) internal {
485         require(address(this).balance >= amount, "Address: insufficient balance");
486 
487         // solhint-disable-next-line avoid-call-value
488         (bool success, ) = recipient.call.value(amount)("");
489         require(success, "Address: unable to send value, recipient may have reverted");
490     }
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
494 
495 pragma solidity ^0.5.0;
496 
497 
498 
499 
500 /**
501  * @title SafeERC20
502  * @dev Wrappers around ERC20 operations that throw on failure (when the token
503  * contract returns false). Tokens that return no value (and instead revert or
504  * throw on failure) are also supported, non-reverting calls are assumed to be
505  * successful.
506  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
507  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
508  */
509 library SafeERC20 {
510     using SafeMath for uint256;
511     using Address for address;
512 
513     function safeTransfer(IERC20 token, address to, uint256 value) internal {
514         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
515     }
516 
517     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
518         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
519     }
520 
521     function safeApprove(IERC20 token, address spender, uint256 value) internal {
522         // safeApprove should only be called when setting an initial allowance,
523         // or when resetting it to zero. To increase and decrease it, use
524         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
525         // solhint-disable-next-line max-line-length
526         require((value == 0) || (token.allowance(address(this), spender) == 0),
527             "SafeERC20: approve from non-zero to non-zero allowance"
528         );
529         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
530     }
531 
532     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
533         uint256 newAllowance = token.allowance(address(this), spender).add(value);
534         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
535     }
536 
537     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
538         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
539         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
540     }
541 
542     /**
543      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
544      * on the return value: the return value is optional (but if data is returned, it must not be false).
545      * @param token The token targeted by the call.
546      * @param data The call data (encoded using abi.encode or one of its variants).
547      */
548     function callOptionalReturn(IERC20 token, bytes memory data) private {
549         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
550         // we're implementing it ourselves.
551 
552         // A Solidity high level call has three parts:
553         //  1. The target address is checked to verify it contains contract code
554         //  2. The call itself is made, and success asserted
555         //  3. The return value is decoded, which in turn checks the size of the returned data.
556         // solhint-disable-next-line max-line-length
557         require(address(token).isContract(), "SafeERC20: call to non-contract");
558 
559         // solhint-disable-next-line avoid-low-level-calls
560         (bool success, bytes memory returndata) = address(token).call(data);
561         require(success, "SafeERC20: low-level call failed");
562 
563         if (returndata.length > 0) { // Return data is optional
564             // solhint-disable-next-line max-line-length
565             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
566         }
567     }
568 }
569 
570 // File: contracts/IRewardDistributionRecipient.sol
571 
572 pragma solidity ^0.5.0;
573 
574 
575 
576 contract IRewardDistributionRecipient is Ownable {
577     address rewardDistribution;
578 
579     function notifyRewardAmount(uint256 reward) internal;
580 
581     modifier onlyRewardDistribution() {
582         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
583         _;
584     }
585 
586     function setRewardDistribution(address _rewardDistribution)
587         external
588         onlyOwner
589     {
590         rewardDistribution = _rewardDistribution;
591     }
592 }
593 
594 pragma solidity >=0.4.24 <0.6.0;
595 
596 
597 /**
598  * @title Initializable
599  *
600  * @dev Helper contract to support initializer functions. To use it, replace
601  * the constructor with a function that has the `initializer` modifier.
602  * WARNING: Unlike constructors, initializer functions must be manually
603  * invoked. This applies both to deploying an Initializable contract, as well
604  * as extending an Initializable contract via inheritance.
605  * WARNING: When used with inheritance, manual care must be taken to not invoke
606  * a parent initializer twice, or ensure that all initializers are idempotent,
607  * because this is not dealt with automatically as with constructors.
608  */
609 contract Initializable {
610 
611   /**
612    * @dev Indicates that the contract has been initialized.
613    */
614   bool private initialized;
615 
616   /**
617    * @dev Indicates that the contract is in the process of being initialized.
618    */
619   bool private initializing;
620 
621   /**
622    * @dev Modifier to use in the initializer function of a contract.
623    */
624   modifier initializer() {
625     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
626 
627     bool wasInitializing = initializing;
628     initializing = true;
629     initialized = true;
630 
631     _;
632 
633     initializing = wasInitializing;
634   }
635 
636   /// @dev Returns true if and only if the function is running in the constructor
637   function isConstructor() private view returns (bool) {
638     // extcodesize checks the size of the code stored in an address, and
639     // address returns the current address. Since the code is still not
640     // deployed when running a constructor, any checks on its code size will
641     // yield zero, making it an effective way to detect if a contract is
642     // under construction or not.
643     uint256 cs;
644     assembly { cs := extcodesize(address) }
645     return cs == 0;
646   }
647 
648   // Reserved storage space to allow for layout changes in the future.
649   uint256[50] private ______gap;
650 }
651 
652 
653 // File: contracts/CurveRewards.sol
654 
655 pragma solidity ^0.5.0;
656 
657 
658 contract LPTokenWrapper is Initializable {
659     using SafeMath for uint256;
660     using SafeERC20 for IERC20;
661 
662     IERC20 public y;
663 
664     uint256 private _totalSupply;
665     mapping(address => uint256) private _balances;
666 
667     function initialize(address _y) public initializer {
668         y = IERC20(_y);
669     }
670 
671     function totalSupply() public view returns (uint256) {
672         return _totalSupply;
673     }
674 
675     function balanceOf(address account) public view returns (uint256) {
676         return _balances[account];
677     }
678 
679     function stake(uint256 amount) public {
680         _totalSupply = _totalSupply.add(amount);
681         _balances[msg.sender] = _balances[msg.sender].add(amount);
682         y.safeTransferFrom(msg.sender, address(this), amount);
683     }
684 
685     function withdraw(uint256 amount) public {
686         _totalSupply = _totalSupply.sub(amount);
687         _balances[msg.sender] = _balances[msg.sender].sub(amount);
688         y.safeTransfer(msg.sender, amount);
689     }
690 }
691 
692 contract YearnRewards is LPTokenWrapper, IRewardDistributionRecipient {
693     IERC20 public yfi;
694     uint256 public duration;
695 
696     uint256 public initreward;
697     uint256 public starttime;
698     uint256 public periodFinish = 0;
699     uint256 public rewardRate = 0;
700     uint256 public lastUpdateTime;
701     uint256 public rewardPerTokenStored;
702     uint256 public totalRewards = 0;
703     bool public fairDistribution;
704     address public deployer;
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
724     constructor () public {
725         deployer = msg.sender;
726     }
727 
728     function initialize(address _y, address _yfi, uint256 _duration, uint256 _initreward, uint256 _starttime, bool _fairDistribution) public initializer {
729         // only deployer can initialize
730         require(deployer == msg.sender);
731 
732         super.initialize(_y);
733         yfi = IERC20(_yfi);
734 
735         duration = _duration;
736         starttime = _starttime;
737         fairDistribution = _fairDistribution;
738         notifyRewardAmount(_initreward.mul(50).div(100));
739     }
740 
741     function lastTimeRewardApplicable() public view returns (uint256) {
742         return Math.min(block.timestamp, periodFinish);
743     }
744 
745     function rewardPerToken() public view returns (uint256) {
746         if (totalSupply() == 0) {
747             return rewardPerTokenStored;
748         }
749         return
750             rewardPerTokenStored.add(
751                 lastTimeRewardApplicable()
752                     .sub(lastUpdateTime)
753                     .mul(rewardRate)
754                     .mul(1e18)
755                     .div(totalSupply())
756             );
757     }
758 
759     function earned(address account) public view returns (uint256) {
760         return
761             balanceOf(account)
762                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
763                 .div(1e18)
764                 .add(rewards[account]);
765     }
766 
767     // stake visibility is public as overriding LPTokenWrapper's stake() function
768     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
769         require(amount > 0, "Cannot stake 0");
770         super.stake(amount);
771         emit Staked(msg.sender, amount);
772 
773         if (fairDistribution) {
774             // require amount below 12k for first 24 hours
775             require(balanceOf(msg.sender) <= 12000 * uint(10) ** y.decimals() || block.timestamp >= starttime.add(24*60*60));
776         }
777     }
778 
779     function withdraw(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
780         require(amount > 0, "Cannot withdraw 0");
781         super.withdraw(amount);
782         emit Withdrawn(msg.sender, amount);
783     }
784 
785     function exit() external {
786         withdraw(balanceOf(msg.sender));
787         getReward();
788     }
789 
790     function getReward() public updateReward(msg.sender) checkhalve checkStart{
791         uint256 reward = earned(msg.sender);
792         if (reward > 0) {
793             rewards[msg.sender] = 0;
794             yfi.safeTransfer(msg.sender, reward);
795             emit RewardPaid(msg.sender, reward);
796             totalRewards = totalRewards.add(reward);
797         }
798     }
799 
800     modifier checkhalve(){
801         if (block.timestamp >= periodFinish) {
802             initreward = initreward.mul(50).div(100);
803 
804             rewardRate = initreward.div(duration);
805             periodFinish = block.timestamp.add(duration);
806             emit RewardAdded(initreward);
807         }
808         _;
809     }
810 
811     modifier checkStart(){
812         require(block.timestamp > starttime,"not start");
813         _;
814     }
815 
816     function notifyRewardAmount(uint256 reward)
817         internal
818         updateReward(address(0))
819     {
820         if (block.timestamp >= periodFinish) {
821             rewardRate = reward.div(duration);
822         } else {
823             uint256 remaining = periodFinish.sub(block.timestamp);
824             uint256 leftover = remaining.mul(rewardRate);
825             rewardRate = reward.add(leftover).div(duration);
826         }
827         initreward = reward;
828         lastUpdateTime = block.timestamp;
829         periodFinish = block.timestamp.add(duration);
830         emit RewardAdded(reward);
831     }
832 }