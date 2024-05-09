1 /*
2 
3 *
4 * Docs: https://docs.synthetix.io/
5 *
6 *
7 * MIT License
8 * ===========
9 *
10 * Copyright (c) 2020 Synthetix
11 *
12 * Permission is hereby granted, free of charge, to any person obtaining a copy
13 * of this software and associated documentation files (the "Software"), to deal
14 * in the Software without restriction, including without limitation the rights
15 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 * copies of the Software, and to permit persons to whom the Software is
17 * furnished to do so, subject to the following conditions:
18 *
19 * The above copyright notice and this permission notice shall be included in all
20 * copies or substantial portions of the Software.
21 *
22 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
25 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
28 */
29 
30 // File: @openzeppelin/contracts/math/Math.sol
31 
32 pragma solidity ^0.5.0;
33 
34 /**
35  * @dev Standard math utilities missing in the Solidity language.
36  */
37 library Math {
38     /**
39      * @dev Returns the largest of two numbers.
40      */
41     function max(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a >= b ? a : b;
43     }
44 
45     /**
46      * @dev Returns the smallest of two numbers.
47      */
48     function min(uint256 a, uint256 b) internal pure returns (uint256) {
49         return a < b ? a : b;
50     }
51 
52     /**
53      * @dev Returns the average of two numbers. The result is rounded towards
54      * zero.
55      */
56     function average(uint256 a, uint256 b) internal pure returns (uint256) {
57         // (a + b) / 2 can overflow, so we distribute
58         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
59     }
60 }
61 
62 // File: @openzeppelin/contracts/math/SafeMath.sol
63 
64 pragma solidity ^0.5.0;
65 
66 /**
67  * @dev Wrappers over Solidity's arithmetic operations with added overflow
68  * checks.
69  *
70  * Arithmetic operations in Solidity wrap on overflow. This can easily result
71  * in bugs, because programmers usually assume that an overflow raises an
72  * error, which is the standard behavior in high level programming languages.
73  * `SafeMath` restores this intuition by reverting the transaction when an
74  * operation overflows.
75  *
76  * Using this library instead of the unchecked operations eliminates an entire
77  * class of bugs, so it's recommended to use it always.
78  */
79 library SafeMath {
80     /**
81      * @dev Returns the addition of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      *
118      * _Available since v2.4.0._
119      */
120     function sub(
121         uint256 a,
122         uint256 b,
123         string memory errorMessage
124     ) internal pure returns (uint256) {
125         require(b <= a, errorMessage);
126         uint256 c = a - b;
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the multiplication of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `*` operator.
136      *
137      * Requirements:
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142         // benefit is lost if 'b' is also tested.
143         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
144         if (a == 0) {
145             return 0;
146         }
147 
148         uint256 c = a * b;
149         require(c / a == b, "SafeMath: multiplication overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the integer division of two unsigned integers. Reverts on
156      * division by zero. The result is rounded towards zero.
157      *
158      * Counterpart to Solidity's `/` operator. Note: this function uses a
159      * `revert` opcode (which leaves remaining gas untouched) while Solidity
160      * uses an invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      * - The divisor cannot be zero.
164      */
165     function div(uint256 a, uint256 b) internal pure returns (uint256) {
166         return div(a, b, "SafeMath: division by zero");
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      *
180      * _Available since v2.4.0._
181      */
182     function div(
183         uint256 a,
184         uint256 b,
185         string memory errorMessage
186     ) internal pure returns (uint256) {
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
223     function mod(
224         uint256 a,
225         uint256 b,
226         string memory errorMessage
227     ) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 // File: @openzeppelin/contracts/GSN/Context.sol
234 
235 pragma solidity ^0.5.0;
236 
237 /*
238  * @dev Provides information about the current execution context, including the
239  * sender of the transaction and its data. While these are generally available
240  * via msg.sender and msg.data, they should not be accessed in such a direct
241  * manner, since when dealing with GSN meta-transactions the account sending and
242  * paying for execution may not be the actual sender (as far as an application
243  * is concerned).
244  *
245  * This contract is only required for intermediate, library-like contracts.
246  */
247 contract Context {
248     // Empty internal constructor, to prevent people from mistakenly deploying
249     // an instance of this contract, which should be used via inheritance.
250     constructor() internal {}
251 
252     // solhint-disable-previous-line no-empty-blocks
253 
254     function _msgSender() internal view returns (address payable) {
255         return msg.sender;
256     }
257 
258     function _msgData() internal view returns (bytes memory) {
259         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
260         return msg.data;
261     }
262 }
263 
264 // File: @openzeppelin/contracts/ownership/Ownable.sol
265 
266 pragma solidity ^0.5.0;
267 
268 /**
269  * @dev Contract module which provides a basic access control mechanism, where
270  * there is an account (an owner) that can be granted exclusive access to
271  * specific functions.
272  *
273  * This module is used through inheritance. It will make available the modifier
274  * `onlyOwner`, which can be applied to your functions to restrict their use to
275  * the owner.
276  */
277 contract Ownable is Context {
278     address private _owner;
279 
280     event OwnershipTransferred(
281         address indexed previousOwner,
282         address indexed newOwner
283     );
284 
285     /**
286      * @dev Initializes the contract setting the deployer as the initial owner.
287      */
288     constructor() internal {
289         _owner = _msgSender();
290         emit OwnershipTransferred(address(0), _owner);
291     }
292 
293     /**
294      * @dev Returns the address of the current owner.
295      */
296     function owner() public view returns (address) {
297         return _owner;
298     }
299 
300     /**
301      * @dev Throws if called by any account other than the owner.
302      */
303     modifier onlyOwner() {
304         require(isOwner(), "Ownable: caller is not the owner");
305         _;
306     }
307 
308     /**
309      * @dev Returns true if the caller is the current owner.
310      */
311     function isOwner() public view returns (bool) {
312         return _msgSender() == _owner;
313     }
314 
315     /**
316      * @dev Leaves the contract without owner. It will not be possible to call
317      * `onlyOwner` functions anymore. Can only be called by the current owner.
318      *
319      * NOTE: Renouncing ownership will leave the contract without an owner,
320      * thereby removing any functionality that is only available to the owner.
321      */
322     function renounceOwnership() public onlyOwner {
323         emit OwnershipTransferred(_owner, address(0));
324         _owner = address(0);
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Can only be called by the current owner.
330      */
331     function transferOwnership(address newOwner) public onlyOwner {
332         _transferOwnership(newOwner);
333     }
334 
335     /**
336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
337      */
338     function _transferOwnership(address newOwner) internal {
339         require(
340             newOwner != address(0),
341             "Ownable: new owner is the zero address"
342         );
343         emit OwnershipTransferred(_owner, newOwner);
344         _owner = newOwner;
345     }
346 }
347 
348 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
349 
350 pragma solidity ^0.5.0;
351 
352 /**
353  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
354  * the optional functions; to access them see {ERC20Detailed}.
355  */
356 interface IERC20 {
357     /**
358      * @dev Returns the amount of tokens in existence.
359      */
360     function totalSupply() external view returns (uint256);
361 
362     /**
363      * @dev Returns the amount of tokens owned by `account`.
364      */
365     function balanceOf(address account) external view returns (uint256);
366 
367     /**
368      * @dev Moves `amount` tokens from the caller's account to `recipient`.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * Emits a {Transfer} event.
373      */
374     function transfer(address recipient, uint256 amount)
375         external
376         returns (bool);
377 
378     function mint(address account, uint256 amount) external;
379 
380     /**
381      * @dev Returns the remaining number of tokens that `spender` will be
382      * allowed to spend on behalf of `owner` through {transferFrom}. This is
383      * zero by default.
384      *
385      * This value changes when {approve} or {transferFrom} are called.
386      */
387     function allowance(address owner, address spender)
388         external
389         view
390         returns (uint256);
391 
392     /**
393      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
394      *
395      * Returns a boolean value indicating whether the operation succeeded.
396      *
397      * IMPORTANT: Beware that changing an allowance with this method brings the risk
398      * that someone may use both the old and the new allowance by unfortunate
399      * transaction ordering. One possible solution to mitigate this race
400      * condition is to first reduce the spender's allowance to 0 and set the
401      * desired value afterwards:
402      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
403      *
404      * Emits an {Approval} event.
405      */
406     function approve(address spender, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Moves `amount` tokens from `sender` to `recipient` using the
410      * allowance mechanism. `amount` is then deducted from the caller's
411      * allowance.
412      *
413      * Returns a boolean value indicating whether the operation succeeded.
414      *
415      * Emits a {Transfer} event.
416      */
417     function transferFrom(
418         address sender,
419         address recipient,
420         uint256 amount
421     ) external returns (bool);
422 
423     /**
424      * @dev Emitted when `value` tokens are moved from one account (`from`) to
425      * another (`to`).
426      *
427      * Note that `value` may be zero.
428      */
429     event Transfer(address indexed from, address indexed to, uint256 value);
430 
431     /**
432      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
433      * a call to {approve}. `value` is the new allowance.
434      */
435     event Approval(
436         address indexed owner,
437         address indexed spender,
438         uint256 value
439     );
440 }
441 
442 // File: @openzeppelin/contracts/utils/Address.sol
443 
444 pragma solidity ^0.5.5;
445 
446 /**
447  * @dev Collection of functions related to the address type
448  */
449 library Address {
450     /**
451      * @dev Returns true if `account` is a contract.
452      *
453      * This test is non-exhaustive, and there may be false-negatives: during the
454      * execution of a contract's constructor, its address will be reported as
455      * not containing a contract.
456      *
457      * IMPORTANT: It is unsafe to assume that an address for which this
458      * function returns false is an externally-owned account (EOA) and not a
459      * contract.
460      */
461     function isContract(address account) internal view returns (bool) {
462         // This method relies in extcodesize, which returns 0 for contracts in
463         // construction, since the code is only stored at the end of the
464         // constructor execution.
465 
466         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
467         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
468         // for accounts without code, i.e. `keccak256('')`
469         bytes32 codehash;
470 
471             bytes32 accountHash
472          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
473         // solhint-disable-next-line no-inline-assembly
474         assembly {
475             codehash := extcodehash(account)
476         }
477         return (codehash != 0x0 && codehash != accountHash);
478     }
479 
480     /**
481      * @dev Converts an `address` into `address payable`. Note that this is
482      * simply a type cast: the actual underlying value is not changed.
483      *
484      * _Available since v2.4.0._
485      */
486     function toPayable(address account)
487         internal
488         pure
489         returns (address payable)
490     {
491         return address(uint160(account));
492     }
493 
494     /**
495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
496      * `recipient`, forwarding all available gas and reverting on errors.
497      *
498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
500      * imposed by `transfer`, making them unable to receive funds via
501      * `transfer`. {sendValue} removes this limitation.
502      *
503      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
504      *
505      * IMPORTANT: because control is transferred to `recipient`, care must be
506      * taken to not create reentrancy vulnerabilities. Consider using
507      * {ReentrancyGuard} or the
508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
509      *
510      * _Available since v2.4.0._
511      */
512     function sendValue(address payable recipient, uint256 amount) internal {
513         require(
514             address(this).balance >= amount,
515             "Address: insufficient balance"
516         );
517 
518         // solhint-disable-next-line avoid-call-value
519         (bool success, ) = recipient.call.value(amount)("");
520         require(
521             success,
522             "Address: unable to send value, recipient may have reverted"
523         );
524     }
525 }
526 
527 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
528 
529 pragma solidity ^0.5.0;
530 
531 /**
532  * @title SafeERC20
533  * @dev Wrappers around ERC20 operations that throw on failure (when the token
534  * contract returns false). Tokens that return no value (and instead revert or
535  * throw on failure) are also supported, non-reverting calls are assumed to be
536  * successful.
537  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
538  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
539  */
540 library SafeERC20 {
541     using SafeMath for uint256;
542     using Address for address;
543 
544     function safeTransfer(
545         IERC20 token,
546         address to,
547         uint256 value
548     ) internal {
549         callOptionalReturn(
550             token,
551             abi.encodeWithSelector(token.transfer.selector, to, value)
552         );
553     }
554 
555     function safeTransferFrom(
556         IERC20 token,
557         address from,
558         address to,
559         uint256 value
560     ) internal {
561         callOptionalReturn(
562             token,
563             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
564         );
565     }
566 
567     function safeApprove(
568         IERC20 token,
569         address spender,
570         uint256 value
571     ) internal {
572         // safeApprove should only be called when setting an initial allowance,
573         // or when resetting it to zero. To increase and decrease it, use
574         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
575         // solhint-disable-next-line max-line-length
576         require(
577             (value == 0) || (token.allowance(address(this), spender) == 0),
578             "SafeERC20: approve from non-zero to non-zero allowance"
579         );
580         callOptionalReturn(
581             token,
582             abi.encodeWithSelector(token.approve.selector, spender, value)
583         );
584     }
585 
586     function safeIncreaseAllowance(
587         IERC20 token,
588         address spender,
589         uint256 value
590     ) internal {
591         uint256 newAllowance = token.allowance(address(this), spender).add(
592             value
593         );
594         callOptionalReturn(
595             token,
596             abi.encodeWithSelector(
597                 token.approve.selector,
598                 spender,
599                 newAllowance
600             )
601         );
602     }
603 
604     function safeDecreaseAllowance(
605         IERC20 token,
606         address spender,
607         uint256 value
608     ) internal {
609         uint256 newAllowance = token.allowance(address(this), spender).sub(
610             value,
611             "SafeERC20: decreased allowance below zero"
612         );
613         callOptionalReturn(
614             token,
615             abi.encodeWithSelector(
616                 token.approve.selector,
617                 spender,
618                 newAllowance
619             )
620         );
621     }
622 
623     /**
624      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
625      * on the return value: the return value is optional (but if data is returned, it must not be false).
626      * @param token The token targeted by the call.
627      * @param data The call data (encoded using abi.encode or one of its variants).
628      */
629     function callOptionalReturn(IERC20 token, bytes memory data) private {
630         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
631         // we're implementing it ourselves.
632 
633         // A Solidity high level call has three parts:
634         //  1. The target address is checked to verify it contains contract code
635         //  2. The call itself is made, and success asserted
636         //  3. The return value is decoded, which in turn checks the size of the returned data.
637         // solhint-disable-next-line max-line-length
638         require(address(token).isContract(), "SafeERC20: call to non-contract");
639 
640         // solhint-disable-next-line avoid-low-level-calls
641         (bool success, bytes memory returndata) = address(token).call(data);
642         require(success, "SafeERC20: low-level call failed");
643 
644         if (returndata.length > 0) {
645             // Return data is optional
646             // solhint-disable-next-line max-line-length
647             require(
648                 abi.decode(returndata, (bool)),
649                 "SafeERC20: ERC20 operation did not succeed"
650             );
651         }
652     }
653 }
654 
655 // File: contracts/IRewardDistributionRecipient.sol
656 
657 pragma solidity ^0.5.0;
658 
659 contract IRewardDistributionRecipient is Ownable {
660     address rewardDistribution = 0x3996ec035cb6987dC3B15D4836b74bAf85474F91; //change
661 
662     function notifyRewardAmount() external;
663 
664     modifier onlyRewardDistribution() {
665         require(
666             _msgSender() == rewardDistribution,
667             "Caller is not reward distribution"
668         );
669         _;
670     }
671 
672     function setRewardDistribution(address _rewardDistribution)
673         external
674         onlyOwner
675     {
676         rewardDistribution = _rewardDistribution;
677     }
678 }
679 
680 // File: contracts/CurveRewards.sol
681 
682 pragma solidity ^0.5.0;
683 
684 contract LPTokenWrapper {
685     using SafeMath for uint256;
686     using SafeERC20 for IERC20;
687 
688     IERC20 public uni_lp = IERC20(0xBd455F35BC5e531999B1C8fC72DF938767aA69b9);
689 
690     uint256 private _totalSupply;
691     mapping(address => uint256) private _balances;
692 
693     function totalSupply() public view returns (uint256) {
694         return _totalSupply;
695     }
696 
697     function balanceOf(address account) public view returns (uint256) {
698         return _balances[account];
699     }
700 
701     function stake(uint256 amount) public {
702         _totalSupply = _totalSupply.add(amount);
703         _balances[msg.sender] = _balances[msg.sender].add(amount);
704         uni_lp.safeTransferFrom(msg.sender, address(this), amount);
705     }
706 
707     function withdraw(uint256 amount) public {
708         _totalSupply = _totalSupply.sub(amount);
709         _balances[msg.sender] = _balances[msg.sender].sub(amount);
710         uni_lp.safeTransfer(msg.sender, amount);
711     }
712 }
713 
714 contract YRXpooltwo is LPTokenWrapper, IRewardDistributionRecipient {
715     IERC20 public yrx = IERC20(0x21634B64a6915b879aD13d96418a82b2a48Fcbe9);
716     uint8 public constant NUMBER_EPOCHS = 5;
717     uint256 public constant EPOCH_REWARD = 666666666666666700000;
718     uint256 public constant TOTAL_REWARD = EPOCH_REWARD * NUMBER_EPOCHS;
719     uint256 public constant DURATION = 7 days;
720     uint256 public currentEpochReward = EPOCH_REWARD;
721     uint256 public totalAccumulatedReward = 0;
722     uint8 public currentEpoch = 0;
723     uint256 public starttime = 1602842400; //Friday, October 16, 2020 12:00:00 PM GMT+02:00 || Friday, October 16, 6 PM SGT
724     uint256 public periodFinish = 0;
725     uint256 public rewardRate = 0;
726     uint256 public lastUpdateTime;
727     uint256 public rewardPerTokenStored;
728     mapping(address => uint256) public userRewardPerTokenPaid;
729     mapping(address => uint256) public rewards;
730 
731     event RewardAdded(uint256 reward);
732     event Staked(address indexed user, uint256 amount);
733     event Withdrawn(address indexed user, uint256 amount);
734     event RewardPaid(address indexed user, uint256 reward);
735 
736     modifier updateReward(address account) {
737         rewardPerTokenStored = rewardPerToken();
738         lastUpdateTime = lastTimeRewardApplicable();
739         if (account != address(0)) {
740             rewards[account] = earned(account);
741             userRewardPerTokenPaid[account] = rewardPerTokenStored;
742         }
743         _;
744     }
745 
746     function lastTimeRewardApplicable() public view returns (uint256) {
747         return Math.min(block.timestamp, periodFinish);
748     }
749 
750     function rewardPerToken() public view returns (uint256) {
751         if (totalSupply() == 0) {
752             return rewardPerTokenStored;
753         }
754         return
755             rewardPerTokenStored.add(
756                 lastTimeRewardApplicable()
757                     .sub(lastUpdateTime)
758                     .mul(rewardRate)
759                     .mul(1e18)
760                     .div(totalSupply())
761             );
762     }
763 
764     function earned(address account) public view returns (uint256) {
765         return
766             balanceOf(account)
767                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
768                 .div(1e18)
769                 .add(rewards[account]);
770     }
771 
772     // stake visibility is public as overriding LPTokenWrapper's stake() function
773     function stake(uint256 amount)
774         public
775         updateReward(msg.sender)
776         checkNextEpoch
777         checkStart
778     {
779         require(amount > 0, "Cannot stake 0");
780         super.stake(amount);
781         emit Staked(msg.sender, amount);
782     }
783 
784     function withdraw(uint256 amount)
785         public
786         updateReward(msg.sender)
787         checkStart
788     {
789         require(amount > 0, "Cannot withdraw 0");
790         super.withdraw(amount);
791         emit Withdrawn(msg.sender, amount);
792     }
793 
794     function exit() external {
795         withdraw(balanceOf(msg.sender));
796         getReward();
797     }
798 
799     function getReward()
800         public
801         updateReward(msg.sender)
802         checkNextEpoch
803         checkStart
804     {
805         uint256 reward = earned(msg.sender);
806         if (reward > 0) {
807             rewards[msg.sender] = 0;
808             yrx.safeTransfer(msg.sender, reward);
809             emit RewardPaid(msg.sender, reward);
810         }
811     }
812 
813     modifier checkNextEpoch() {
814         if (block.timestamp >= periodFinish) {
815             currentEpochReward = EPOCH_REWARD;
816 
817             if (totalAccumulatedReward.add(currentEpochReward) > TOTAL_REWARD) {
818                 currentEpochReward = TOTAL_REWARD.sub(totalAccumulatedReward); // limit total reward
819             }
820 
821             if (currentEpochReward > 0) {
822                 totalAccumulatedReward = totalAccumulatedReward.add(
823                     currentEpochReward
824                 );
825                 currentEpoch++;
826             }
827 
828             rewardRate = currentEpochReward.div(DURATION);
829             lastUpdateTime = block.timestamp;
830             periodFinish = block.timestamp.add(DURATION);
831             emit RewardAdded(currentEpochReward);
832         }
833         _;
834     }
835 
836     function emergencyDrain(address _addy) public onlyRewardDistribution {
837         IERC20 token = IERC20(_addy);
838         token.safeTransfer(msg.sender, token.balanceOf(address(this)));
839     }
840 
841     modifier checkStart() {
842         require(block.timestamp > starttime, "not start");
843         _;
844     }
845 
846     function notifyRewardAmount()
847         external
848         onlyRewardDistribution
849         updateReward(address(0))
850     {
851         if (totalAccumulatedReward.add(currentEpochReward) > TOTAL_REWARD) {
852             currentEpochReward = TOTAL_REWARD.sub(totalAccumulatedReward); // limit total reward
853         }
854 
855         rewardRate = currentEpochReward.div(DURATION);
856         totalAccumulatedReward = totalAccumulatedReward.add(currentEpochReward);
857         currentEpoch++;
858         lastUpdateTime = block.timestamp;
859         periodFinish = starttime.add(DURATION);
860         emit RewardAdded(currentEpochReward);
861     }
862 }