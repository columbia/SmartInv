1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-29
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
42 pragma solidity ^0.6.0;
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
74 pragma solidity ^0.6.0;
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
233 pragma solidity ^0.6.0;
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
263 pragma solidity ^0.6.0;
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
341 pragma solidity ^0.6.0;
342 
343 /**
344  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
345  * the optional functions; to access them see {ERC20Detailed}.
346  */
347 interface IERC20 {
348     /**
349      * @dev Returns the amount of tokens in existence.
350      */
351     function totalSupply() external view returns (uint256);
352 
353     /**
354      * @dev Returns the amount of tokens owned by `account`.
355      */
356     function balanceOf(address account) external view returns (uint256);
357 
358     /**
359      * @dev Moves `amount` tokens from the caller's account to `recipient`.
360      *
361      * Returns a boolean value indicating whether the operation succeeded.
362      *
363      * Emits a {Transfer} event.
364      */
365     function transfer(address recipient, uint256 amount) external returns (bool);
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
420 pragma solidity ^0.6.0;
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
491 pragma solidity ^0.6.0;
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
568 pragma solidity ^0.6.0;
569 
570 
571 
572 contract IRewardDistributionRecipient is Ownable {
573     address rewardDistribution;
574 
575     function notifyRewardAmount(uint256 reward) external virtual {}
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
590 // File: contracts/CurveRewards.sol
591 
592 pragma solidity ^0.6.0;
593 
594 
595 
596 
597 
598 
599 contract LPTokenWrapper {
600     using SafeMath for uint256;
601     using SafeERC20 for IERC20;
602     // Token to be staked
603     IERC20 public stakingToken = IERC20(address(0));
604     address public devFund = 0x3865078e0123D1bE111De953AAd94Cda57A11DF5;
605     address public devFund2 = 0xd2af5D1Ffa02286bF7D4542a838BBFC0B01575D9;
606     uint256 private _totalSupply;
607     mapping(address => uint256) private _balances;
608 
609     function totalSupply() public view returns (uint256) {
610         return _totalSupply;
611     }
612 
613     function balanceOf(address account) public view returns (uint256) {
614         return _balances[account];
615     }
616 
617     function stake(uint256 amount) public virtual {
618         uint256 _realAmount = amount.mul(95).div(100);
619         uint256 _taxedAmount = amount.sub(_realAmount);
620         _totalSupply = _totalSupply.add(_realAmount);
621         _balances[msg.sender] = _balances[msg.sender].add(_realAmount);
622         stakingToken.safeTransferFrom(msg.sender, address(this), _realAmount);
623         stakingToken.safeTransferFrom(msg.sender,devFund,_taxedAmount.div(2));
624         stakingToken.safeTransferFrom(msg.sender,devFund2,_taxedAmount.div(2));
625     }
626 
627     function withdraw(uint256 amount) public virtual{
628         _totalSupply = _totalSupply.sub(amount);
629         _balances[msg.sender] = _balances[msg.sender].sub(amount);
630         stakingToken.safeTransfer(msg.sender, amount);
631     } 
632     function setBPT(address BPTAddress) internal {
633         stakingToken = IERC20(BPTAddress);
634     }
635 }
636 
637 interface CalculateCycle {
638   function calculate(uint256 deployedTime,uint256 currentTime,uint256 duration) external view returns(uint256);
639 }
640 
641 contract HOCETHLPUNI is LPTokenWrapper, IRewardDistributionRecipient {
642     // Token to be rewarded
643     IERC20 public rewardToken = IERC20(address(0));
644     IERC20 public multiplierToken = IERC20(address(0));
645     CalculateCycle public calculateCycle = CalculateCycle(address(0));
646     uint256 public DURATION = 4 days;
647 
648     uint256 public periodFinish = 0;
649     uint256 public rewardRate = 0;
650     uint256 public lastUpdateTime;
651     uint256 public rewardPerTokenStored;
652     uint256 public deployedTime;
653     uint256 public constant napsDiscountRange = 8 hours;
654     uint256 public constant napsLevelOneCost = 250000000000000000;
655     uint256 public constant napsLevelTwoCost = 1 * 1e18;
656     uint256 public constant napsLevelThreeCost = 2 * 1e18;
657     uint256 public constant napsLevelFourCost = 5 * 1e18;
658     uint256 public constant napsLevelFiveCost = 10 * 1e18;
659     
660     uint256 public constant FivePercentBonus = 50000000000000000;
661     uint256 public constant FifteenPercentBonus = 150000000000000000;
662     uint256 public constant ThirtyPercentBonus = 300000000000000000;
663     uint256 public constant SixtyPercentBonus = 600000000000000000;
664     uint256 public constant HundredPercentBonus = 1000000000000000000;
665 
666     mapping(address => uint256) public userRewardPerTokenPaid;
667     mapping(address => uint256) public rewards;
668     mapping(address => uint256) public spentNAPS;
669     mapping(address => uint256) public NAPSlevel;
670 
671     event RewardAdded(uint256 reward);
672     event Staked(address indexed user, uint256 amount);
673     event Withdrawn(address indexed user, uint256 amount);
674     event RewardPaid(address indexed user, uint256 reward);
675     event Boost(uint256 level);
676     modifier updateReward(address account) {
677         rewardPerTokenStored = rewardPerToken();
678         lastUpdateTime = lastTimeRewardApplicable();
679         if (account != address(0)) {
680             rewards[account] = earned(account);
681             userRewardPerTokenPaid[account] = rewardPerTokenStored;
682         }
683         _;
684     }
685     constructor(address _stakingToken,address _rewardToken,address _multiplierToken,address _calculateCycleAddr) public{
686       setBPT(_stakingToken);
687       rewardToken = IERC20(_rewardToken);
688       multiplierToken = IERC20(_multiplierToken);
689       calculateCycle = CalculateCycle(_calculateCycleAddr);
690       deployedTime = block.timestamp;
691     }
692 
693     function lastTimeRewardApplicable() public view returns (uint256) {
694         return Math.min(block.timestamp, periodFinish);
695     }
696 
697     function rewardPerToken() public view returns (uint256) {
698         if (totalSupply() == 0) {
699             return rewardPerTokenStored;
700         }
701         return
702             rewardPerTokenStored.add(
703                 lastTimeRewardApplicable()
704                     .sub(lastUpdateTime)
705                     .mul(rewardRate)
706                     .mul(1e18)
707                     .div(totalSupply())
708             );
709     }
710 
711     function earned(address account) public view returns (uint256) {
712         return
713             balanceOf(account)
714                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
715                 .div(1e18)
716                 .mul(getTotalMultiplier(account))
717                 .div(1e18)
718                 .add(rewards[account]);
719     }
720 
721     // stake visibility is public as overriding LPTokenWrapper's stake() function
722     function stake(uint256 amount) public override updateReward(msg.sender) {
723         require(amount > 0, "Cannot stake 0");
724         super.stake(amount);
725         emit Staked(msg.sender, amount);
726     }
727 
728     function withdraw(uint256 amount) public override updateReward(msg.sender) {
729         require(amount > 0, "Cannot withdraw 0");
730         super.withdraw(amount);
731         emit Withdrawn(msg.sender, amount);
732     }
733 
734     function exit() external {
735         withdraw(balanceOf(msg.sender));
736         getReward();
737     }
738 
739     function getReward() public updateReward(msg.sender) {
740         uint256 reward = earned(msg.sender);
741         if (reward > 0) {
742             rewards[msg.sender] = 0;
743             rewardToken.safeTransfer(msg.sender, reward);
744             emit RewardPaid(msg.sender, reward);
745         }
746     }
747 
748     function notifyRewardAmount(uint256 reward)
749         external
750         override
751         onlyRewardDistribution
752         updateReward(address(0))
753     {
754         if (block.timestamp >= periodFinish) {
755             rewardRate = reward.div(DURATION);
756         } else {
757             uint256 remaining = periodFinish.sub(block.timestamp);
758             uint256 leftover = remaining.mul(rewardRate);
759             rewardRate = reward.add(leftover).div(DURATION);
760         }
761         lastUpdateTime = block.timestamp;
762         periodFinish = block.timestamp.add(DURATION);
763         emit RewardAdded(reward);
764     }
765     function setCycleContract(address _cycleContract) public onlyRewardDistribution {
766         calculateCycle = CalculateCycle(_cycleContract);
767     }
768     // naps stuff
769     function getLevel(address account) external view returns (uint256) {
770         return NAPSlevel[account];
771     }
772 
773     function getSpent(address account) external view returns (uint256) {
774         return spentNAPS[account];
775     }
776     // Returns the number of naps token to boost
777     function calculateCost(uint256 level) public view returns(uint256) {
778         uint256 cycles = calculateCycle.calculate(deployedTime,block.timestamp,napsDiscountRange);
779         // Cap it to 5 times
780         if(cycles > 5) {
781             cycles = 5;
782         }
783         // // cost = initialCost * (0.9)^cycles = initial cost * (9^cycles)/(10^cycles)
784         if (level == 1) {
785             return napsLevelOneCost.mul(9 ** cycles).div(10 ** cycles);
786         }else if(level == 2) {
787             return napsLevelTwoCost.mul(9 ** cycles).div(10 ** cycles);
788         }else if(level ==3) {
789             return napsLevelThreeCost.mul(9 ** cycles).div(10 ** cycles);
790         }else if(level ==4) {
791             return napsLevelFourCost.mul(9 ** cycles).div(10 ** cycles);
792         }else if(level ==5) {
793             return napsLevelFiveCost.mul(9 ** cycles).div(10 ** cycles);
794         }
795     }
796     
797     function purchase(uint256 level) external {
798         require(NAPSlevel[msg.sender] <= level,"Cannot downgrade level or same level");
799         uint256 cost = calculateCost(level);
800         uint256 finalCost = cost.sub(spentNAPS[msg.sender]);
801         // Owner dev fund
802         multiplierToken.safeTransferFrom(msg.sender,devFund,finalCost.div(2));
803         multiplierToken.safeTransferFrom(msg.sender,devFund2,finalCost.div(2));
804         spentNAPS[msg.sender] = spentNAPS[msg.sender].add(finalCost);
805         NAPSlevel[msg.sender] = level;
806         emit Boost(level);
807     }
808 
809     function getTotalMultiplier(address account) public view returns (uint256) {
810         uint256 napsMultiplier = 0;
811         if(NAPSlevel[account] == 1) {
812             napsMultiplier = FivePercentBonus;
813         }else if(NAPSlevel[account] == 2) {
814             napsMultiplier = FifteenPercentBonus;
815         }else if(NAPSlevel[account] == 3) {
816             napsMultiplier = ThirtyPercentBonus;
817         }else if(NAPSlevel[account] == 4) {
818             napsMultiplier = SixtyPercentBonus;
819         }else if(NAPSlevel[account] == 5) {
820             napsMultiplier = HundredPercentBonus;
821         }
822         return napsMultiplier.add(1*10**18);
823     }
824 
825     function eject() external onlyRewardDistribution {
826         require(block.timestamp > deployedTime + DURATION,"Cannot eject before period finishes");
827         uint256 currBalance = rewardToken.balanceOf(address(this));
828         rewardToken.safeTransfer(devFund,currBalance);
829     }
830 }