1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 /**
7  * @dev Standard math utilities missing in the Solidity language.
8  */
9 library Math {
10     /**
11      * @dev Returns the largest of two numbers.
12      */
13     function max(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a >= b ? a : b;
15     }
16 
17     /**
18      * @dev Returns the smallest of two numbers.
19      */
20     function min(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a < b ? a : b;
22     }
23 
24     /**
25      * @dev Returns the average of two numbers. The result is rounded towards
26      * zero.
27      */
28     function average(uint256 a, uint256 b) internal pure returns (uint256) {
29         // (a + b) / 2 can overflow, so we distribute
30         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
31     }
32 }
33 
34 // File: @openzeppelin/contracts/math/SafeMath.sol
35 
36 pragma solidity ^0.6.0;
37 
38 /**
39  * @dev Wrappers over Solidity's arithmetic operations with added overflow
40  * checks.
41  *
42  * Arithmetic operations in Solidity wrap on overflow. This can easily result
43  * in bugs, because programmers usually assume that an overflow raises an
44  * error, which is the standard behavior in high level programming languages.
45  * `SafeMath` restores this intuition by reverting the transaction when an
46  * operation overflows.
47  *
48  * Using this library instead of the unchecked operations eliminates an entire
49  * class of bugs, so it's recommended to use it always.
50  */
51 library SafeMath {
52     /**
53      * @dev Returns the addition of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `+` operator.
57      *
58      * Requirements:
59      *
60      * - Addition cannot overflow.
61      */
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a, "SafeMath: addition overflow");
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the subtraction of two unsigned integers, reverting on
71      * overflow (when the result is negative).
72      *
73      * Counterpart to Solidity's `-` operator.
74      *
75      * Requirements:
76      *
77      * - Subtraction cannot overflow.
78      */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82 
83     /**
84      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
85      * overflow (when the result is negative).
86      *
87      * Counterpart to Solidity's `-` operator.
88      *
89      * Requirements:
90      *
91      * - Subtraction cannot overflow.
92      */
93     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         uint256 c = a - b;
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the multiplication of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `*` operator.
105      *
106      * Requirements:
107      *
108      * - Multiplication cannot overflow.
109      */
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
112         // benefit is lost if 'b' is also tested.
113         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
114         if (a == 0) {
115             return 0;
116         }
117 
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers. Reverts on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator. Note: this function uses a
129      * `revert` opcode (which leaves remaining gas untouched) while Solidity
130      * uses an invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      *
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
149      *
150      * - The divisor cannot be zero.
151      */
152     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b > 0, errorMessage);
154         uint256 c = a / b;
155         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
162      * Reverts when dividing by zero.
163      *
164      * Counterpart to Solidity's `%` operator. This function uses a `revert`
165      * opcode (which leaves remaining gas untouched) while Solidity uses an
166      * invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
173         return mod(a, b, "SafeMath: modulo by zero");
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
178      * Reverts with custom message when dividing by zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b != 0, errorMessage);
190         return a % b;
191     }
192 }
193 
194 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
195 
196 pragma solidity ^0.6.0;
197 
198 /**
199  * @dev Interface of the ERC20 standard as defined in the EIP.
200  */
201 interface IERC20 {
202     /**
203      * @dev Returns the amount of tokens in existence.
204      */
205     function totalSupply() external view returns (uint256);
206 
207     /**
208      * @dev Returns the amount of tokens owned by `account`.
209      */
210     function balanceOf(address account) external view returns (uint256);
211 
212     /**
213      * @dev Moves `amount` tokens from the caller's account to `recipient`.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transfer(address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Returns the remaining number of tokens that `spender` will be
223      * allowed to spend on behalf of `owner` through {transferFrom}. This is
224      * zero by default.
225      *
226      * This value changes when {approve} or {transferFrom} are called.
227      */
228     function allowance(address owner, address spender) external view returns (uint256);
229 
230     /**
231      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * IMPORTANT: Beware that changing an allowance with this method brings the risk
236      * that someone may use both the old and the new allowance by unfortunate
237      * transaction ordering. One possible solution to mitigate this race
238      * condition is to first reduce the spender's allowance to 0 and set the
239      * desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address spender, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Moves `amount` tokens from `sender` to `recipient` using the
248      * allowance mechanism. `amount` is then deducted from the caller's
249      * allowance.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Emitted when `value` tokens are moved from one account (`from`) to
259      * another (`to`).
260      *
261      * Note that `value` may be zero.
262      */
263     event Transfer(address indexed from, address indexed to, uint256 value);
264 
265     /**
266      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
267      * a call to {approve}. `value` is the new allowance.
268      */
269     event Approval(address indexed owner, address indexed spender, uint256 value);
270 }
271 
272 // File: @openzeppelin/contracts/utils/Address.sol
273 
274 pragma solidity ^0.6.2;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies in extcodesize, which returns 0 for contracts in
299         // construction, since the code is only stored at the end of the
300         // constructor execution.
301 
302         uint256 size;
303         // solhint-disable-next-line no-inline-assembly
304         assembly { size := extcodesize(account) }
305         return size > 0;
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
328         (bool success, ) = recipient.call{ value: amount }("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain`call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351       return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
361         return _functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
381      * with `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
386         require(address(this).balance >= value, "Address: insufficient balance for call");
387         return _functionCallWithValue(target, data, value, errorMessage);
388     }
389 
390     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
391         require(isContract(target), "Address: call to non-contract");
392 
393         // solhint-disable-next-line avoid-low-level-calls
394         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
395         if (success) {
396             return returndata;
397         } else {
398             // Look for revert reason and bubble it up if present
399             if (returndata.length > 0) {
400                 // The easiest way to bubble the revert reason is using memory via assembly
401 
402                 // solhint-disable-next-line no-inline-assembly
403                 assembly {
404                     let returndata_size := mload(returndata)
405                     revert(add(32, returndata), returndata_size)
406                 }
407             } else {
408                 revert(errorMessage);
409             }
410         }
411     }
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
415 
416 pragma solidity ^0.6.0;
417 
418 
419 
420 
421 /**
422  * @title SafeERC20
423  * @dev Wrappers around ERC20 operations that throw on failure (when the token
424  * contract returns false). Tokens that return no value (and instead revert or
425  * throw on failure) are also supported, non-reverting calls are assumed to be
426  * successful.
427  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
428  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
429  */
430 library SafeERC20 {
431     using SafeMath for uint256;
432     using Address for address;
433 
434     function safeTransfer(IERC20 token, address to, uint256 value) internal {
435         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
436     }
437 
438     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
439         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
440     }
441 
442     /**
443      * @dev Deprecated. This function has issues similar to the ones found in
444      * {IERC20-approve}, and its usage is discouraged.
445      *
446      * Whenever possible, use {safeIncreaseAllowance} and
447      * {safeDecreaseAllowance} instead.
448      */
449     function safeApprove(IERC20 token, address spender, uint256 value) internal {
450         // safeApprove should only be called when setting an initial allowance,
451         // or when resetting it to zero. To increase and decrease it, use
452         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
453         // solhint-disable-next-line max-line-length
454         require((value == 0) || (token.allowance(address(this), spender) == 0),
455             "SafeERC20: approve from non-zero to non-zero allowance"
456         );
457         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
458     }
459 
460     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
461         uint256 newAllowance = token.allowance(address(this), spender).add(value);
462         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
467         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
468     }
469 
470     /**
471      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
472      * on the return value: the return value is optional (but if data is returned, it must not be false).
473      * @param token The token targeted by the call.
474      * @param data The call data (encoded using abi.encode or one of its variants).
475      */
476     function _callOptionalReturn(IERC20 token, bytes memory data) private {
477         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
478         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
479         // the target address contains contract code and also asserts for success in the low-level call.
480 
481         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
482         if (returndata.length > 0) { // Return data is optional
483             // solhint-disable-next-line max-line-length
484             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
485         }
486     }
487 }
488 
489 // File: @openzeppelin/contracts/GSN/Context.sol
490 
491 pragma solidity ^0.6.0;
492 
493 /*
494  * @dev Provides information about the current execution context, including the
495  * sender of the transaction and its data. While these are generally available
496  * via msg.sender and msg.data, they should not be accessed in such a direct
497  * manner, since when dealing with GSN meta-transactions the account sending and
498  * paying for execution may not be the actual sender (as far as an application
499  * is concerned).
500  *
501  * This contract is only required for intermediate, library-like contracts.
502  */
503 abstract contract Context {
504     function _msgSender() internal view virtual returns (address payable) {
505         return msg.sender;
506     }
507 
508     function _msgData() internal view virtual returns (bytes memory) {
509         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
510         return msg.data;
511     }
512 }
513 
514 // File: @openzeppelin/contracts/access/Ownable.sol
515 
516 pragma solidity ^0.6.0;
517 
518 /**
519  * @dev Contract module which provides a basic access control mechanism, where
520  * there is an account (an owner) that can be granted exclusive access to
521  * specific functions.
522  *
523  * By default, the owner account will be the one that deploys the contract. This
524  * can later be changed with {transferOwnership}.
525  *
526  * This module is used through inheritance. It will make available the modifier
527  * `onlyOwner`, which can be applied to your functions to restrict their use to
528  * the owner.
529  */
530 contract Ownable is Context {
531     address private _owner;
532 
533     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
534 
535     /**
536      * @dev Initializes the contract setting the deployer as the initial owner.
537      */
538     constructor () internal {
539         address msgSender = _msgSender();
540         _owner = msgSender;
541         emit OwnershipTransferred(address(0), msgSender);
542     }
543 
544     /**
545      * @dev Returns the address of the current owner.
546      */
547     function owner() public view returns (address) {
548         return _owner;
549     }
550 
551     /**
552      * @dev Throws if called by any account other than the owner.
553      */
554     modifier onlyOwner() {
555         require(_owner == _msgSender(), "Ownable: caller is not the owner");
556         _;
557     }
558 
559     /**
560      * @dev Leaves the contract without owner. It will not be possible to call
561      * `onlyOwner` functions anymore. Can only be called by the current owner.
562      *
563      * NOTE: Renouncing ownership will leave the contract without an owner,
564      * thereby removing any functionality that is only available to the owner.
565      */
566     function renounceOwnership() public virtual onlyOwner {
567         emit OwnershipTransferred(_owner, address(0));
568         _owner = address(0);
569     }
570 
571     /**
572      * @dev Transfers ownership of the contract to a new account (`newOwner`).
573      * Can only be called by the current owner.
574      */
575     function transferOwnership(address newOwner) public virtual onlyOwner {
576         require(newOwner != address(0), "Ownable: new owner is the zero address");
577         emit OwnershipTransferred(_owner, newOwner);
578         _owner = newOwner;
579     }
580 }
581 
582 // File: contracts/interfaces/IRewardDistributionRecipient.sol
583 
584 pragma solidity ^0.6.0;
585 
586 
587 abstract contract IRewardDistributionRecipient is Ownable {
588     address public rewardDistribution;
589 
590     function notifyRewardAmount(uint256 reward) external virtual;
591 
592     modifier onlyRewardDistribution() {
593         require(
594             _msgSender() == rewardDistribution,
595             'Caller is not reward distribution'
596         );
597         _;
598     }
599 
600     function setRewardDistribution(address _rewardDistribution)
601         external
602         virtual
603         onlyOwner
604     {
605         rewardDistribution = _rewardDistribution;
606     }
607 }
608 
609 // File: contracts/token/LPTokenWrapper.sol
610 
611 pragma solidity ^0.6.0;
612 
613 
614 
615 
616 contract LPTokenWrapper {
617     using SafeMath for uint256;
618     using SafeERC20 for IERC20;
619 
620     IERC20 public lpt;
621 
622     uint256 private _totalSupply;
623     mapping(address => uint256) private _balances;
624 
625     function totalSupply() public view returns (uint256) {
626         return _totalSupply;
627     }
628 
629     function balanceOf(address account) public view returns (uint256) {
630         return _balances[account];
631     }
632 
633     function stake(uint256 amount) public virtual {
634         _totalSupply = _totalSupply.add(amount);
635         _balances[msg.sender] = _balances[msg.sender].add(amount);
636         lpt.safeTransferFrom(msg.sender, address(this), amount);
637     }
638 
639     function withdraw(uint256 amount) public virtual {
640         _totalSupply = _totalSupply.sub(amount);
641         _balances[msg.sender] = _balances[msg.sender].sub(amount);
642         lpt.safeTransfer(msg.sender, amount);
643     }
644 }
645 
646 // File: contracts/distribution/ETHGMELPTokenSharePool.sol
647 
648 pragma solidity ^0.6.0;
649 /**
650  *Submitted for verification at Etherscan.io on 2020-07-17
651  */
652 
653 /*
654    ____            __   __        __   _
655   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
656  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
657 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
658      /___/
659 
660 * Synthetix: BASISCASHRewards.sol
661 *
662 * Docs: https://docs.synthetix.io/
663 *
664 *
665 * MIT License
666 * ===========
667 *
668 * Copyright (c) 2020 Synthetix
669 *
670 * Permission is hereby granted, free of charge, to any person obtaining a copy
671 * of this software and associated documentation files (the "Software"), to deal
672 * in the Software without restriction, including without limitation the rights
673 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
674 * copies of the Software, and to permit persons to whom the Software is
675 * furnished to do so, subject to the following conditions:
676 *
677 * The above copyright notice and this permission notice shall be included in all
678 * copies or substantial portions of the Software.
679 *
680 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
681 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
682 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
683 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
684 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
685 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
686 */
687 
688 // File: @openzeppelin/contracts/math/Math.sol
689 
690 
691 // File: @openzeppelin/contracts/math/SafeMath.sol
692 
693 
694 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
695 
696 
697 // File: @openzeppelin/contracts/utils/Address.sol
698 
699 
700 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
701 
702 
703 // File: contracts/IRewardDistributionRecipient.sol
704 
705 
706 
707 contract ETHGMELPTokenSharePool is
708     LPTokenWrapper,
709     IRewardDistributionRecipient
710 {
711     IERC20 public gmeToken;
712     uint256 public DURATION = 14 days;
713 
714     uint256 public starttime;
715     uint256 public periodFinish = 0;
716     uint256 public rewardRate = 0;
717     uint256 public lastUpdateTime;
718     uint256 public rewardPerTokenStored;
719     mapping(address => uint256) public userRewardPerTokenPaid;
720     mapping(address => uint256) public rewards;
721 
722     event RewardAdded(uint256 reward);
723     event Staked(address indexed user, uint256 amount);
724     event Withdrawn(address indexed user, uint256 amount);
725     event RewardPaid(address indexed user, uint256 reward);
726 
727     constructor(
728         address gmeToken_,
729         address lptoken_,
730         uint256 starttime_
731     ) public {
732         gmeToken = IERC20(gmeToken_);
733         lpt = IERC20(lptoken_);
734         starttime = starttime_;
735     }
736 
737     modifier checkStart() {
738         require(
739             block.timestamp >= starttime,
740             'ETHGMELPTokenSharePool: not start'
741         );
742         _;
743     }
744 
745     modifier updateReward(address account) {
746         rewardPerTokenStored = rewardPerToken();
747         lastUpdateTime = lastTimeRewardApplicable();
748         if (account != address(0)) {
749             rewards[account] = earned(account);
750             userRewardPerTokenPaid[account] = rewardPerTokenStored;
751         }
752         _;
753     }
754 
755     function lastTimeRewardApplicable() public view returns (uint256) {
756         return Math.min(block.timestamp, periodFinish);
757     }
758 
759     function rewardPerToken() public view returns (uint256) {
760         if (totalSupply() == 0) {
761             return rewardPerTokenStored;
762         }
763         return
764             rewardPerTokenStored.add(
765                 lastTimeRewardApplicable()
766                     .sub(lastUpdateTime)
767                     .mul(rewardRate)
768                     .mul(1e18)
769                     .div(totalSupply())
770             );
771     }
772 
773     function earned(address account) public view returns (uint256) {
774         return
775             balanceOf(account)
776                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
777                 .div(1e18)
778                 .add(rewards[account]);
779     }
780 
781     // stake visibility is public as overriding LPTokenWrapper's stake() function
782     function stake(uint256 amount)
783         public
784         override
785         updateReward(msg.sender)
786         checkStart
787     {
788         require(amount > 0, 'ETHGMELPTokenSharePool: Cannot stake 0');
789         super.stake(amount);
790         emit Staked(msg.sender, amount);
791     }
792 
793     function withdraw(uint256 amount)
794         public
795         override
796         updateReward(msg.sender)
797         checkStart
798     {
799         require(amount > 0, 'ETHGMELPTokenSharePool: Cannot withdraw 0');
800         super.withdraw(amount);
801         emit Withdrawn(msg.sender, amount);
802     }
803 
804     function exit() external {
805         withdraw(balanceOf(msg.sender));
806         getReward();
807     }
808 
809     function getReward() public updateReward(msg.sender) checkStart {
810         uint256 reward = earned(msg.sender);
811         if (reward > 0) {
812             rewards[msg.sender] = 0;
813             gmeToken.safeTransfer(msg.sender, reward);
814             emit RewardPaid(msg.sender, reward);
815         }
816     }
817 
818     function notifyRewardAmount(uint256 reward)
819         external
820         override
821         onlyRewardDistribution
822         updateReward(address(0))
823     {
824         if (block.timestamp > starttime) {
825             if (block.timestamp >= periodFinish) {
826                 // Set duration to 7 days after bootstrapping
827                 DURATION = 7 days;
828                 rewardRate = reward.div(DURATION);
829             } else {
830                 uint256 remaining = periodFinish.sub(block.timestamp);
831                 uint256 leftover = remaining.mul(rewardRate);
832                 rewardRate = reward.add(leftover).div(DURATION);
833             }
834             lastUpdateTime = block.timestamp;
835             periodFinish = block.timestamp.add(DURATION);
836             emit RewardAdded(reward);
837         } else {
838             rewardRate = reward.div(DURATION);
839             lastUpdateTime = starttime;
840             periodFinish = starttime.add(DURATION);
841             emit RewardAdded(reward);
842         }
843     }
844 }