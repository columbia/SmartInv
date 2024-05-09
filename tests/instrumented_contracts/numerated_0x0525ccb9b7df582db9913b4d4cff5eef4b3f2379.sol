1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-29
3  */
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
68         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
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
130     function sub(
131         uint256 a,
132         uint256 b,
133         string memory errorMessage
134     ) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      *
190      * _Available since v2.4.0._
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
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
233     function mod(
234         uint256 a,
235         uint256 b,
236         string memory errorMessage
237     ) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/GSN/Context.sol
244 
245 pragma solidity ^0.6.0;
246 
247 /*
248  * @dev Provides information about the current execution context, including the
249  * sender of the transaction and its data. While these are generally available
250  * via msg.sender and msg.data, they should not be accessed in such a direct
251  * manner, since when dealing with GSN meta-transactions the account sending and
252  * paying for execution may not be the actual sender (as far as an application
253  * is concerned).
254  *
255  * This contract is only required for intermediate, library-like contracts.
256  */
257 contract Context {
258     // Empty internal constructor, to prevent people from mistakenly deploying
259     // an instance of this contract, which should be used via inheritance.
260     constructor() internal {}
261 
262     // solhint-disable-previous-line no-empty-blocks
263 
264     function _msgSender() internal view returns (address payable) {
265         return msg.sender;
266     }
267 
268     function _msgData() internal view returns (bytes memory) {
269         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
270         return msg.data;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/ownership/Ownable.sol
275 
276 pragma solidity ^0.6.0;
277 
278 /**
279  * @dev Contract module which provides a basic access control mechanism, where
280  * there is an account (an owner) that can be granted exclusive access to
281  * specific functions.
282  *
283  * This module is used through inheritance. It will make available the modifier
284  * `onlyOwner`, which can be applied to your functions to restrict their use to
285  * the owner.
286  */
287 contract Ownable is Context {
288     address private _owner;
289 
290     event OwnershipTransferred(
291         address indexed previousOwner,
292         address indexed newOwner
293     );
294 
295     /**
296      * @dev Initializes the contract setting the deployer as the initial owner.
297      */
298     constructor() internal {
299         _owner = _msgSender();
300         emit OwnershipTransferred(address(0), _owner);
301     }
302 
303     /**
304      * @dev Returns the address of the current owner.
305      */
306     function owner() public view returns (address) {
307         return _owner;
308     }
309 
310     /**
311      * @dev Throws if called by any account other than the owner.
312      */
313     modifier onlyOwner() {
314         require(isOwner(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     /**
319      * @dev Returns true if the caller is the current owner.
320      */
321     function isOwner() public view returns (bool) {
322         return _msgSender() == _owner;
323     }
324 
325     /**
326      * @dev Leaves the contract without owner. It will not be possible to call
327      * `onlyOwner` functions anymore. Can only be called by the current owner.
328      *
329      * NOTE: Renouncing ownership will leave the contract without an owner,
330      * thereby removing any functionality that is only available to the owner.
331      */
332     function renounceOwnership() public onlyOwner {
333         emit OwnershipTransferred(_owner, address(0));
334         _owner = address(0);
335     }
336 
337     /**
338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
339      * Can only be called by the current owner.
340      */
341     function transferOwnership(address newOwner) public onlyOwner {
342         _transferOwnership(newOwner);
343     }
344 
345     /**
346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
347      */
348     function _transferOwnership(address newOwner) internal {
349         require(
350             newOwner != address(0),
351             "Ownable: new owner is the zero address"
352         );
353         emit OwnershipTransferred(_owner, newOwner);
354         _owner = newOwner;
355     }
356 }
357 
358 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
359 
360 pragma solidity ^0.6.0;
361 
362 /**
363  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
364  * the optional functions; to access them see {ERC20Detailed}.
365  */
366 interface IERC20 {
367     /**
368      * @dev Returns the amount of tokens in existence.
369      */
370     function totalSupply() external view returns (uint256);
371 
372     /**
373      * @dev Returns the amount of tokens owned by `account`.
374      */
375     function balanceOf(address account) external view returns (uint256);
376 
377     /**
378      * @dev Moves `amount` tokens from the caller's account to `recipient`.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * Emits a {Transfer} event.
383      */
384     function transfer(address recipient, uint256 amount)
385         external
386         returns (bool);
387 
388     /**
389      * @dev Returns the remaining number of tokens that `spender` will be
390      * allowed to spend on behalf of `owner` through {transferFrom}. This is
391      * zero by default.
392      *
393      * This value changes when {approve} or {transferFrom} are called.
394      */
395     function allowance(address owner, address spender)
396         external
397         view
398         returns (uint256);
399 
400     /**
401      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
402      *
403      * Returns a boolean value indicating whether the operation succeeded.
404      *
405      * IMPORTANT: Beware that changing an allowance with this method brings the risk
406      * that someone may use both the old and the new allowance by unfortunate
407      * transaction ordering. One possible solution to mitigate this race
408      * condition is to first reduce the spender's allowance to 0 and set the
409      * desired value afterwards:
410      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
411      *
412      * Emits an {Approval} event.
413      */
414     function approve(address spender, uint256 amount) external returns (bool);
415 
416     /**
417      * @dev Moves `amount` tokens from `sender` to `recipient` using the
418      * allowance mechanism. `amount` is then deducted from the caller's
419      * allowance.
420      *
421      * Returns a boolean value indicating whether the operation succeeded.
422      *
423      * Emits a {Transfer} event.
424      */
425     function transferFrom(
426         address sender,
427         address recipient,
428         uint256 amount
429     ) external returns (bool);
430 
431     /**
432      * @dev Emitted when `value` tokens are moved from one account (`from`) to
433      * another (`to`).
434      *
435      * Note that `value` may be zero.
436      */
437     event Transfer(address indexed from, address indexed to, uint256 value);
438 
439     /**
440      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
441      * a call to {approve}. `value` is the new allowance.
442      */
443     event Approval(
444         address indexed owner,
445         address indexed spender,
446         uint256 value
447     );
448 }
449 
450 // File: @openzeppelin/contracts/utils/Address.sol
451 
452 pragma solidity ^0.6.0;
453 
454 /**
455  * @dev Collection of functions related to the address type
456  */
457 library Address {
458     /**
459      * @dev Returns true if `account` is a contract.
460      *
461      * This test is non-exhaustive, and there may be false-negatives: during the
462      * execution of a contract's constructor, its address will be reported as
463      * not containing a contract.
464      *
465      * IMPORTANT: It is unsafe to assume that an address for which this
466      * function returns false is an externally-owned account (EOA) and not a
467      * contract.
468      */
469     function isContract(address account) internal view returns (bool) {
470         // This method relies in extcodesize, which returns 0 for contracts in
471         // construction, since the code is only stored at the end of the
472         // constructor execution.
473 
474         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
475         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
476         // for accounts without code, i.e. `keccak256('')`
477         bytes32 codehash;
478 
479 
480             bytes32 accountHash
481          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
482         // solhint-disable-next-line no-inline-assembly
483         assembly {
484             codehash := extcodehash(account)
485         }
486         return (codehash != 0x0 && codehash != accountHash);
487     }
488 
489     /**
490      * @dev Converts an `address` into `address payable`. Note that this is
491      * simply a type cast: the actual underlying value is not changed.
492      *
493      * _Available since v2.4.0._
494      */
495     function toPayable(address account)
496         internal
497         pure
498         returns (address payable)
499     {
500         return address(uint160(account));
501     }
502 
503     /**
504      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
505      * `recipient`, forwarding all available gas and reverting on errors.
506      *
507      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
508      * of certain opcodes, possibly making contracts go over the 2300 gas limit
509      * imposed by `transfer`, making them unable to receive funds via
510      * `transfer`. {sendValue} removes this limitation.
511      *
512      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
513      *
514      * IMPORTANT: because control is transferred to `recipient`, care must be
515      * taken to not create reentrancy vulnerabilities. Consider using
516      * {ReentrancyGuard} or the
517      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
518      *
519      * _Available since v2.4.0._
520      */
521     function sendValue(address payable recipient, uint256 amount) internal {
522         require(
523             address(this).balance >= amount,
524             "Address: insufficient balance"
525         );
526 
527         // solhint-disable-next-line avoid-call-value
528         (bool success, ) = recipient.call.value(amount)("");
529         require(
530             success,
531             "Address: unable to send value, recipient may have reverted"
532         );
533     }
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
537 
538 pragma solidity ^0.6.0;
539 
540 /**
541  * @title SafeERC20
542  * @dev Wrappers around ERC20 operations that throw on failure (when the token
543  * contract returns false). Tokens that return no value (and instead revert or
544  * throw on failure) are also supported, non-reverting calls are assumed to be
545  * successful.
546  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
547  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
548  */
549 library SafeERC20 {
550     using SafeMath for uint256;
551     using Address for address;
552 
553     function safeTransfer(
554         IERC20 token,
555         address to,
556         uint256 value
557     ) internal {
558         callOptionalReturn(
559             token,
560             abi.encodeWithSelector(token.transfer.selector, to, value)
561         );
562     }
563 
564     function safeTransferFrom(
565         IERC20 token,
566         address from,
567         address to,
568         uint256 value
569     ) internal {
570         callOptionalReturn(
571             token,
572             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
573         );
574     }
575 
576     function safeApprove(
577         IERC20 token,
578         address spender,
579         uint256 value
580     ) internal {
581         // safeApprove should only be called when setting an initial allowance,
582         // or when resetting it to zero. To increase and decrease it, use
583         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
584         // solhint-disable-next-line max-line-length
585         require(
586             (value == 0) || (token.allowance(address(this), spender) == 0),
587             "SafeERC20: approve from non-zero to non-zero allowance"
588         );
589         callOptionalReturn(
590             token,
591             abi.encodeWithSelector(token.approve.selector, spender, value)
592         );
593     }
594 
595     function safeIncreaseAllowance(
596         IERC20 token,
597         address spender,
598         uint256 value
599     ) internal {
600         uint256 newAllowance = token.allowance(address(this), spender).add(
601             value
602         );
603         callOptionalReturn(
604             token,
605             abi.encodeWithSelector(
606                 token.approve.selector,
607                 spender,
608                 newAllowance
609             )
610         );
611     }
612 
613     function safeDecreaseAllowance(
614         IERC20 token,
615         address spender,
616         uint256 value
617     ) internal {
618         uint256 newAllowance = token.allowance(address(this), spender).sub(
619             value,
620             "SafeERC20: decreased allowance below zero"
621         );
622         callOptionalReturn(
623             token,
624             abi.encodeWithSelector(
625                 token.approve.selector,
626                 spender,
627                 newAllowance
628             )
629         );
630     }
631 
632     /**
633      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
634      * on the return value: the return value is optional (but if data is returned, it must not be false).
635      * @param token The token targeted by the call.
636      * @param data The call data (encoded using abi.encode or one of its variants).
637      */
638     function callOptionalReturn(IERC20 token, bytes memory data) private {
639         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
640         // we're implementing it ourselves.
641 
642         // A Solidity high level call has three parts:
643         //  1. The target address is checked to verify it contains contract code
644         //  2. The call itself is made, and success asserted
645         //  3. The return value is decoded, which in turn checks the size of the returned data.
646         // solhint-disable-next-line max-line-length
647         require(address(token).isContract(), "SafeERC20: call to non-contract");
648 
649         // solhint-disable-next-line avoid-low-level-calls
650         (bool success, bytes memory returndata) = address(token).call(data);
651         require(success, "SafeERC20: low-level call failed");
652 
653         if (returndata.length > 0) {
654             // Return data is optional
655             // solhint-disable-next-line max-line-length
656             require(
657                 abi.decode(returndata, (bool)),
658                 "SafeERC20: ERC20 operation did not succeed"
659             );
660         }
661     }
662 }
663 
664 // File: contracts/IRewardDistributionRecipient.sol
665 
666 pragma solidity ^0.6.0;
667 
668 contract IRewardDistributionRecipient is Ownable {
669     address rewardDistribution;
670 
671     function notifyRewardAmount(uint256 reward) external virtual {}
672 
673     modifier onlyRewardDistribution() {
674         require(
675             _msgSender() == rewardDistribution,
676             "Caller is not reward distribution"
677         );
678         _;
679     }
680 
681     function setRewardDistribution(address _rewardDistribution)
682         external
683         onlyOwner
684     {
685         rewardDistribution = _rewardDistribution;
686     }
687 }
688 
689 // File: contracts/CurveRewards.sol
690 
691 pragma solidity ^0.6.0;
692 
693 contract LPTokenWrapper {
694     using SafeMath for uint256;
695     using SafeERC20 for IERC20;
696     // Token to be staked
697     IERC20 public stakingToken = IERC20(address(0));
698     address public devFund = 0xB8b485b42A456Df5201EAa86565614c40bA7fb4E;
699     uint256 private _totalSupply;
700     mapping(address => uint256) private _balances;
701 
702     function totalSupply() public view returns (uint256) {
703         return _totalSupply;
704     }
705 
706     function balanceOf(address account) public view returns (uint256) {
707         return _balances[account];
708     }
709 
710     function stake(uint256 amount) public virtual {
711         _totalSupply = _totalSupply.add(amount);
712         _balances[msg.sender] = _balances[msg.sender].add(amount);
713         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
714     }
715 
716     function withdraw(uint256 amount) public virtual {
717         _totalSupply = _totalSupply.sub(amount);
718         _balances[msg.sender] = _balances[msg.sender].sub(amount);
719         stakingToken.safeTransfer(msg.sender, amount);
720     }
721 
722     function setBPT(address BPTAddress) internal {
723         stakingToken = IERC20(BPTAddress);
724     }
725 }
726 
727 interface MultiplierInterface {
728     function getTotalMultiplier(address account)
729         external
730         view
731         returns (uint256);
732 }
733 
734 interface CalculateCycle {
735     function calculate(
736         uint256 deployedTime,
737         uint256 currentTime,
738         uint256 duration
739     ) external view returns (uint256);
740 }
741 
742 contract NAPCORD is LPTokenWrapper, IRewardDistributionRecipient {
743     // Token to be rewarded
744     IERC20 public rewardToken = IERC20(address(0));
745     IERC20 public multiplierToken = IERC20(address(0));
746     MultiplierInterface public multiplier = MultiplierInterface(address(0));
747     CalculateCycle public calculateCycle = CalculateCycle(address(0));
748     uint256 public DURATION = 4 weeks;
749 
750     uint256 public periodFinish = 0;
751     uint256 public rewardRate = 0;
752     uint256 public lastUpdateTime;
753     uint256 public rewardPerTokenStored;
754     uint256 public deployedTime;
755     uint256 public constant napsDiscountRange = 8 hours;
756     uint256 public constant napsLevelOneCost = 10000000000000000000000;
757     uint256 public constant napsLevelTwoCost = 20000000000000000000000;
758     uint256 public constant napsLevelThreeCost = 30000000000000000000000;
759     uint256 public constant TenPercentBonus = 1 * 10**17;
760     uint256 public constant TwentyPercentBonus = 2 * 10**17;
761     uint256 public constant ThirtyPercentBonus = 3 * 10**17;
762     uint256 public constant FourtyPercentBonus = 4 * 10**17;
763 
764     mapping(address => uint256) public userRewardPerTokenPaid;
765     mapping(address => uint256) public rewards;
766     mapping(address => uint256) public spentNAPS;
767     mapping(address => uint256) public NAPSlevel;
768 
769     event RewardAdded(uint256 reward);
770     event Staked(address indexed user, uint256 amount);
771     event Withdrawn(address indexed user, uint256 amount);
772     event RewardPaid(address indexed user, uint256 reward);
773     event Boost(uint256 level);
774     modifier updateReward(address account) {
775         rewardPerTokenStored = rewardPerToken();
776         lastUpdateTime = lastTimeRewardApplicable();
777         if (account != address(0)) {
778             rewards[account] = earned(account);
779             userRewardPerTokenPaid[account] = rewardPerTokenStored;
780         }
781         _;
782     }
783 
784     constructor(
785         address _stakingToken,
786         address _rewardToken,
787         address _multiplierToken,
788         address _calculateCycleAddr,
789         address _multiplierAddr
790     ) public {
791         setBPT(_stakingToken);
792         rewardToken = IERC20(_rewardToken);
793         multiplierToken = IERC20(_multiplierToken);
794         calculateCycle = CalculateCycle(_calculateCycleAddr);
795         multiplier = MultiplierInterface(_multiplierAddr);
796         deployedTime = block.timestamp;
797     }
798 
799     function lastTimeRewardApplicable() public view returns (uint256) {
800         return Math.min(block.timestamp, periodFinish);
801     }
802 
803     function rewardPerToken() public view returns (uint256) {
804         if (totalSupply() == 0) {
805             return rewardPerTokenStored;
806         }
807         return
808             rewardPerTokenStored.add(
809                 lastTimeRewardApplicable()
810                     .sub(lastUpdateTime)
811                     .mul(rewardRate)
812                     .mul(1e18)
813                     .div(totalSupply())
814             );
815     }
816 
817     function earned(address account) public view returns (uint256) {
818         return
819             balanceOf(account)
820                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
821                 .div(1e18)
822                 .mul(getTotalMultiplier(account))
823                 .div(1e18)
824                 .add(rewards[account]);
825     }
826 
827     // stake visibility is public as overriding LPTokenWrapper's stake() function
828     function stake(uint256 amount) public override updateReward(msg.sender) {
829         require(amount > 0, "Cannot stake 0");
830         super.stake(amount);
831         emit Staked(msg.sender, amount);
832     }
833 
834     function withdraw(uint256 amount) public override updateReward(msg.sender) {
835         require(amount > 0, "Cannot withdraw 0");
836         super.withdraw(amount);
837         emit Withdrawn(msg.sender, amount);
838     }
839 
840     function exit() external {
841         withdraw(balanceOf(msg.sender));
842         getReward();
843     }
844 
845     function getReward() public updateReward(msg.sender) {
846         uint256 reward = earned(msg.sender);
847         if (reward > 0) {
848             rewards[msg.sender] = 0;
849             rewardToken.safeTransfer(msg.sender, reward.mul(97).div(100));
850             // 3 percent goes back to the dev fund
851             rewardToken.safeTransfer(devFund, reward.mul(3).div(100));
852             emit RewardPaid(msg.sender, reward);
853         }
854     }
855 
856     function notifyRewardAmount(uint256 reward)
857         external
858         override
859         onlyRewardDistribution
860         updateReward(address(0))
861     {
862         if (block.timestamp >= periodFinish) {
863             rewardRate = reward.div(DURATION);
864         } else {
865             uint256 remaining = periodFinish.sub(block.timestamp);
866             uint256 leftover = remaining.mul(rewardRate);
867             rewardRate = reward.add(leftover).div(DURATION);
868         }
869         lastUpdateTime = block.timestamp;
870         periodFinish = block.timestamp.add(DURATION);
871         emit RewardAdded(reward);
872     }
873 
874     function setCycleContract(address _cycleContract)
875         public
876         onlyRewardDistribution
877     {
878         calculateCycle = CalculateCycle(_cycleContract);
879     }
880 
881     // naps stuff
882     function getLevel(address account) external view returns (uint256) {
883         return NAPSlevel[account];
884     }
885 
886     function getSpent(address account) external view returns (uint256) {
887         return spentNAPS[account];
888     }
889 
890     // Returns the number of naps token to boost
891     function calculateCost(uint256 level) public view returns (uint256) {
892         uint256 cycles = calculateCycle.calculate(
893             deployedTime,
894             block.timestamp,
895             napsDiscountRange
896         );
897         // Cap it to 5 times
898         if (cycles > 5) {
899             cycles = 5;
900         }
901         // // cost = initialCost * (0.9)^cycles = initial cost * (9^cycles)/(10^cycles)
902         if (level == 1) {
903             return napsLevelOneCost.mul(9**cycles).div(10**cycles);
904         } else if (level == 2) {
905             return napsLevelTwoCost.mul(9**cycles).div(10**cycles);
906         } else if (level == 3) {
907             return napsLevelThreeCost.mul(9**cycles).div(10**cycles);
908         }
909     }
910 
911     function purchase(uint256 level) external {
912         require(
913             NAPSlevel[msg.sender] <= level,
914             "Cannot downgrade level or same level"
915         );
916         uint256 cost = calculateCost(level);
917         uint256 finalCost = cost.sub(spentNAPS[msg.sender]);
918         // Owner dev fund
919         rewardToken.safeTransferFrom(msg.sender, devFund, finalCost);
920         spentNAPS[msg.sender] = spentNAPS[msg.sender].add(finalCost);
921         NAPSlevel[msg.sender] = level;
922         emit Boost(level);
923     }
924 
925     function setMultiplierAddress(address multiplierAddress)
926         external
927         onlyRewardDistribution
928     {
929         multiplier = MultiplierInterface(multiplierAddress);
930     }
931 
932     function getTotalMultiplier(address account) public view returns (uint256) {
933         uint256 zzzMultiplier = multiplier.getTotalMultiplier(account);
934         uint256 napsMultiplier = 0;
935         if (NAPSlevel[account] == 1) {
936             napsMultiplier = TenPercentBonus;
937         } else if (NAPSlevel[account] == 2) {
938             napsMultiplier = TwentyPercentBonus;
939         } else if (NAPSlevel[account] == 3) {
940             napsMultiplier = FourtyPercentBonus;
941         }
942         return zzzMultiplier.add(napsMultiplier).add(1 * 10**18);
943     }
944 
945     function eject() external onlyRewardDistribution {
946         require(
947             block.timestamp > periodFinish,
948             "Cannot eject before period finishes"
949         );
950         uint256 currBalance = rewardToken.balanceOf(address(this));
951         rewardToken.safeTransfer(devFund, currBalance);
952     }
953 }