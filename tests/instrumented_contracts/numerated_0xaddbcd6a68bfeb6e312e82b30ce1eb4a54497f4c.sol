1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-27
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-07-26
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-07-17
11 */
12 
13 /*
14    ____            __   __        __   _
15   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
16  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
17 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
18      /___/
19 
20 * Synthetix: YAMIncentives.sol
21 *
22 * Docs: https://docs.synthetix.io/
23 *
24 *
25 * MIT License
26 * ===========
27 *
28 * Copyright (c) 2020 Synthetix
29 *
30 * Permission is hereby granted, free of charge, to any person obtaining a copy
31 * of this software and associated documentation files (the "Software"), to deal
32 * in the Software without restriction, including without limitation the rights
33 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
34 * copies of the Software, and to permit persons to whom the Software is
35 * furnished to do so, subject to the following conditions:
36 *
37 * The above copyright notice and this permission notice shall be included in all
38 * copies or substantial portions of the Software.
39 *
40 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
41 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
42 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
43 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
44 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
45 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
46 */
47 
48 // File: @openzeppelin/contracts/math/Math.sol
49 
50 pragma solidity ^0.5.0;
51 
52 /**
53  * @dev Standard math utilities missing in the Solidity language.
54  */
55 library Math {
56     /**
57      * @dev Returns the largest of two numbers.
58      */
59     function max(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a >= b ? a : b;
61     }
62 
63     /**
64      * @dev Returns the smallest of two numbers.
65      */
66     function min(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a < b ? a : b;
68     }
69 
70     /**
71      * @dev Returns the average of two numbers. The result is rounded towards
72      * zero.
73      */
74     function average(uint256 a, uint256 b) internal pure returns (uint256) {
75         // (a + b) / 2 can overflow, so we distribute
76         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
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
374     function mint(address account, uint amount) external;
375 
376     /**
377      * @dev Returns the remaining number of tokens that `spender` will be
378      * allowed to spend on behalf of `owner` through {transferFrom}. This is
379      * zero by default.
380      *
381      * This value changes when {approve} or {transferFrom} are called.
382      */
383     function allowance(address owner, address spender) external view returns (uint256);
384 
385     /**
386      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * IMPORTANT: Beware that changing an allowance with this method brings the risk
391      * that someone may use both the old and the new allowance by unfortunate
392      * transaction ordering. One possible solution to mitigate this race
393      * condition is to first reduce the spender's allowance to 0 and set the
394      * desired value afterwards:
395      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
396      *
397      * Emits an {Approval} event.
398      */
399     function approve(address spender, uint256 amount) external returns (bool);
400 
401     /**
402      * @dev Moves `amount` tokens from `sender` to `recipient` using the
403      * allowance mechanism. `amount` is then deducted from the caller's
404      * allowance.
405      *
406      * Returns a boolean value indicating whether the operation succeeded.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
411 
412     /**
413      * @dev Emitted when `value` tokens are moved from one account (`from`) to
414      * another (`to`).
415      *
416      * Note that `value` may be zero.
417      */
418     event Transfer(address indexed from, address indexed to, uint256 value);
419 
420     /**
421      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
422      * a call to {approve}. `value` is the new allowance.
423      */
424     event Approval(address indexed owner, address indexed spender, uint256 value);
425 }
426 
427 // File: @openzeppelin/contracts/utils/Address.sol
428 
429 pragma solidity ^0.5.5;
430 
431 /**
432  * @dev Collection of functions related to the address type
433  */
434 library Address {
435     /**
436      * @dev Returns true if `account` is a contract.
437      *
438      * This test is non-exhaustive, and there may be false-negatives: during the
439      * execution of a contract's constructor, its address will be reported as
440      * not containing a contract.
441      *
442      * IMPORTANT: It is unsafe to assume that an address for which this
443      * function returns false is an externally-owned account (EOA) and not a
444      * contract.
445      */
446     function isContract(address account) internal view returns (bool) {
447         // This method relies in extcodesize, which returns 0 for contracts in
448         // construction, since the code is only stored at the end of the
449         // constructor execution.
450 
451         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
452         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
453         // for accounts without code, i.e. `keccak256('')`
454         bytes32 codehash;
455         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
456         // solhint-disable-next-line no-inline-assembly
457         assembly { codehash := extcodehash(account) }
458         return (codehash != 0x0 && codehash != accountHash);
459     }
460 
461     /**
462      * @dev Converts an `address` into `address payable`. Note that this is
463      * simply a type cast: the actual underlying value is not changed.
464      *
465      * _Available since v2.4.0._
466      */
467     function toPayable(address account) internal pure returns (address payable) {
468         return address(uint160(account));
469     }
470 
471     /**
472      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
473      * `recipient`, forwarding all available gas and reverting on errors.
474      *
475      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
476      * of certain opcodes, possibly making contracts go over the 2300 gas limit
477      * imposed by `transfer`, making them unable to receive funds via
478      * `transfer`. {sendValue} removes this limitation.
479      *
480      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
481      *
482      * IMPORTANT: because control is transferred to `recipient`, care must be
483      * taken to not create reentrancy vulnerabilities. Consider using
484      * {ReentrancyGuard} or the
485      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
486      *
487      * _Available since v2.4.0._
488      */
489     function sendValue(address payable recipient, uint256 amount) internal {
490         require(address(this).balance >= amount, "Address: insufficient balance");
491 
492         // solhint-disable-next-line avoid-call-value
493         (bool success, ) = recipient.call.value(amount)("");
494         require(success, "Address: unable to send value, recipient may have reverted");
495     }
496 }
497 
498 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
499 
500 pragma solidity ^0.5.0;
501 
502 
503 
504 
505 /**
506  * @title SafeERC20
507  * @dev Wrappers around ERC20 operations that throw on failure (when the token
508  * contract returns false). Tokens that return no value (and instead revert or
509  * throw on failure) are also supported, non-reverting calls are assumed to be
510  * successful.
511  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
512  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
513  */
514 library SafeERC20 {
515     using SafeMath for uint256;
516     using Address for address;
517 
518     function safeTransfer(IERC20 token, address to, uint256 value) internal {
519         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
520     }
521 
522     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
523         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
524     }
525 
526     function safeApprove(IERC20 token, address spender, uint256 value) internal {
527         // safeApprove should only be called when setting an initial allowance,
528         // or when resetting it to zero. To increase and decrease it, use
529         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
530         // solhint-disable-next-line max-line-length
531         require((value == 0) || (token.allowance(address(this), spender) == 0),
532             "SafeERC20: approve from non-zero to non-zero allowance"
533         );
534         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
535     }
536 
537     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
538         uint256 newAllowance = token.allowance(address(this), spender).add(value);
539         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
540     }
541 
542     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
543         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
544         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
545     }
546 
547     /**
548      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
549      * on the return value: the return value is optional (but if data is returned, it must not be false).
550      * @param token The token targeted by the call.
551      * @param data The call data (encoded using abi.encode or one of its variants).
552      */
553     function callOptionalReturn(IERC20 token, bytes memory data) private {
554         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
555         // we're implementing it ourselves.
556 
557         // A Solidity high level call has three parts:
558         //  1. The target address is checked to verify it contains contract code
559         //  2. The call itself is made, and success asserted
560         //  3. The return value is decoded, which in turn checks the size of the returned data.
561         // solhint-disable-next-line max-line-length
562         require(address(token).isContract(), "SafeERC20: call to non-contract");
563 
564         // solhint-disable-next-line avoid-low-level-calls
565         (bool success, bytes memory returndata) = address(token).call(data);
566         require(success, "SafeERC20: low-level call failed");
567 
568         if (returndata.length > 0) { // Return data is optional
569             // solhint-disable-next-line max-line-length
570             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
571         }
572     }
573 }
574 
575 // File: contracts/IRewardDistributionRecipient.sol
576 
577 pragma solidity ^0.5.0;
578 
579 
580 
581 contract IRewardDistributionRecipient is Ownable {
582     address rewardDistribution;
583 
584     function notifyRewardAmount(uint256 reward) external;
585 
586     modifier onlyRewardDistribution() {
587         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
588         _;
589     }
590 
591     function setRewardDistribution(address _rewardDistribution)
592         external
593         onlyOwner
594     {
595         rewardDistribution = _rewardDistribution;
596     }
597 }
598 
599 // File: contracts/CurveRewards.sol
600 
601 pragma solidity ^0.5.0;
602 
603 
604 
605 
606 
607 
608 contract LPTokenWrapper {
609     using SafeMath for uint256;
610     using SafeERC20 for IERC20;
611 
612     IERC20 public uni_lp = IERC20(0x2C7a51A357d5739C5C74Bf3C96816849d2c9F726);
613 
614     uint256 private _totalSupply;
615 
616     mapping(address => uint256) private _balances;
617 
618     function totalSupply() public view returns (uint256) {
619         return _totalSupply;
620     }
621 
622     function balanceOf(address account) public view returns (uint256) {
623         return _balances[account];
624     }
625 
626     function stake(uint256 amount) public {
627         _totalSupply = _totalSupply.add(amount);
628         _balances[msg.sender] = _balances[msg.sender].add(amount);
629         uni_lp.safeTransferFrom(msg.sender, address(this), amount);
630     }
631 
632     function withdraw(uint256 amount) public {
633         _totalSupply = _totalSupply.sub(amount);
634         _balances[msg.sender] = _balances[msg.sender].sub(amount);
635         uni_lp.safeTransfer(msg.sender, amount);
636     }
637 }
638 
639 interface YAM {
640     function yamsScalingFactor() external returns (uint256);
641     function mint(address to, uint256 amount) external;
642 }
643 
644 contract YAMIncentivizer is LPTokenWrapper, IRewardDistributionRecipient {
645     IERC20 public yam = IERC20(0x0e2298E3B3390e3b945a5456fBf59eCc3f55DA16);
646     uint256 public constant DURATION = 625000;
647 
648     uint256 public initreward = 15 * 10**5 * 10**18; // 1.5m
649     uint256 public starttime = 1597172400 + 24 hours; // 2020-08-12 19:00:00 (UTC UTC +00:00)
650     uint256 public periodFinish = 0;
651     uint256 public rewardRate = 0;
652     uint256 public lastUpdateTime;
653     uint256 public rewardPerTokenStored;
654     mapping(address => uint256) public userRewardPerTokenPaid;
655     mapping(address => uint256) public rewards;
656 
657 
658     event RewardAdded(uint256 reward);
659     event Staked(address indexed user, uint256 amount);
660     event Withdrawn(address indexed user, uint256 amount);
661     event RewardPaid(address indexed user, uint256 reward);
662 
663     modifier updateReward(address account) {
664         rewardPerTokenStored = rewardPerToken();
665         lastUpdateTime = lastTimeRewardApplicable();
666         if (account != address(0)) {
667             rewards[account] = earned(account);
668             userRewardPerTokenPaid[account] = rewardPerTokenStored;
669         }
670         _;
671     }
672 
673     function lastTimeRewardApplicable() public view returns (uint256) {
674         return Math.min(block.timestamp, periodFinish);
675     }
676 
677     function rewardPerToken() public view returns (uint256) {
678         if (totalSupply() == 0) {
679             return rewardPerTokenStored;
680         }
681         return
682             rewardPerTokenStored.add(
683                 lastTimeRewardApplicable()
684                     .sub(lastUpdateTime)
685                     .mul(rewardRate)
686                     .mul(1e18)
687                     .div(totalSupply())
688             );
689     }
690 
691     function earned(address account) public view returns (uint256) {
692         return
693             balanceOf(account)
694                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
695                 .div(1e18)
696                 .add(rewards[account]);
697     }
698 
699     // stake visibility is public as overriding LPTokenWrapper's stake() function
700     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart {
701         require(amount > 0, "Cannot stake 0");
702         super.stake(amount);
703         emit Staked(msg.sender, amount);
704     }
705 
706     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
707         require(amount > 0, "Cannot withdraw 0");
708         super.withdraw(amount);
709         emit Withdrawn(msg.sender, amount);
710     }
711 
712     function exit() external {
713         withdraw(balanceOf(msg.sender));
714         getReward();
715     }
716 
717     function getReward() public updateReward(msg.sender) checkhalve checkStart {
718         uint256 reward = earned(msg.sender);
719         if (reward > 0) {
720             rewards[msg.sender] = 0;
721             uint256 scalingFactor = YAM(address(yam)).yamsScalingFactor();
722             uint256 trueReward = reward.mul(scalingFactor).div(10**18);
723             yam.safeTransfer(msg.sender, trueReward);
724             emit RewardPaid(msg.sender, trueReward);
725         }
726     }
727 
728     modifier checkhalve() {
729         if (block.timestamp >= periodFinish) {
730             initreward = initreward.mul(50).div(100);
731             uint256 scalingFactor = YAM(address(yam)).yamsScalingFactor();
732             uint256 newRewards = initreward.mul(scalingFactor).div(10**18);
733             yam.mint(address(this), newRewards);
734 
735             rewardRate = initreward.div(DURATION);
736             periodFinish = block.timestamp.add(DURATION);
737             emit RewardAdded(initreward);
738         }
739         _;
740     }
741 
742     modifier checkStart(){
743         require(block.timestamp >= starttime,"not start");
744         _;
745     }
746 
747 
748     function notifyRewardAmount(uint256 reward)
749         external
750         onlyRewardDistribution
751         updateReward(address(0))
752     {
753         if (block.timestamp > starttime) {
754           if (block.timestamp >= periodFinish) {
755               rewardRate = reward.div(DURATION);
756           } else {
757               uint256 remaining = periodFinish.sub(block.timestamp);
758               uint256 leftover = remaining.mul(rewardRate);
759               rewardRate = reward.add(leftover).div(DURATION);
760           }
761           lastUpdateTime = block.timestamp;
762           periodFinish = block.timestamp.add(DURATION);
763           emit RewardAdded(reward);
764         } else {
765           require(yam.balanceOf(address(this)) == 0, "already initialized");
766           yam.mint(address(this), initreward);
767           rewardRate = initreward.div(DURATION);
768           lastUpdateTime = starttime;
769           periodFinish = starttime.add(DURATION);
770           emit RewardAdded(reward);
771         }
772     }
773 
774 
775     // This function allows governance to take unsupported tokens out of the
776     // contract, since this one exists longer than the other pools.
777     // This is in an effort to make someone whole, should they seriously
778     // mess up. There is no guarantee governance will vote to return these.
779     // It also allows for removal of airdropped tokens.
780     function governanceRecoverUnsupported(IERC20 _token, uint256 amount, address to)
781         external
782     {
783         // only gov
784         require(msg.sender == owner(), "!governance");
785         // cant take staked asset
786         require(_token != uni_lp, "uni_lp");
787         // cant take reward asset
788         require(_token != yam, "yam");
789 
790         // transfer to
791         _token.safeTransfer(to, amount);
792     }
793 }