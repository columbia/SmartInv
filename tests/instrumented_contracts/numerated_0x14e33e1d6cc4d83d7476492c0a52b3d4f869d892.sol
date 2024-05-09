1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     /**
12      * @dev Returns the largest of two numbers.
13      */
14     function max(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a >= b ? a : b;
16     }
17 
18     /**
19      * @dev Returns the smallest of two numbers.
20      */
21     function min(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a < b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the average of two numbers. The result is rounded towards
27      * zero.
28      */
29     function average(uint256 a, uint256 b) internal pure returns (uint256) {
30         // (a + b) / 2 can overflow, so we distribute
31         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
32     }
33 }
34 
35 // File: @openzeppelin/contracts/math/SafeMath.sol
36 
37 pragma solidity ^0.6.0;
38 
39 /**
40  * @dev Wrappers over Solidity's arithmetic operations with added overflow
41  * checks.
42  *
43  * Arithmetic operations in Solidity wrap on overflow. This can easily result
44  * in bugs, because programmers usually assume that an overflow raises an
45  * error, which is the standard behavior in high level programming languages.
46  * `SafeMath` restores this intuition by reverting the transaction when an
47  * operation overflows.
48  *
49  * Using this library instead of the unchecked operations eliminates an entire
50  * class of bugs, so it's recommended to use it always.
51  */
52 library SafeMath {
53     /**
54      * @dev Returns the addition of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `+` operator.
58      *
59      * Requirements:
60      *
61      * - Addition cannot overflow.
62      */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      *
78      * - Subtraction cannot overflow.
79      */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83 
84     /**
85      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
86      * overflow (when the result is negative).
87      *
88      * Counterpart to Solidity's `-` operator.
89      *
90      * Requirements:
91      *
92      * - Subtraction cannot overflow.
93      */
94     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the multiplication of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `*` operator.
106      *
107      * Requirements:
108      *
109      * - Multiplication cannot overflow.
110      */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
113         // benefit is lost if 'b' is also tested.
114         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers. Reverts on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return div(a, b, "SafeMath: division by zero");
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b > 0, errorMessage);
155         uint256 c = a / b;
156         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * Reverts when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         return mod(a, b, "SafeMath: modulo by zero");
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts with custom message when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b != 0, errorMessage);
191         return a % b;
192     }
193 }
194 
195 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
196 
197 pragma solidity ^0.6.0;
198 
199 /**
200  * @dev Interface of the ERC20 standard as defined in the EIP.
201  */
202 interface IERC20 {
203     /**
204      * @dev Returns the amount of tokens in existence.
205      */
206     function totalSupply() external view returns (uint256);
207 
208     /**
209      * @dev Returns the amount of tokens owned by `account`.
210      */
211     function balanceOf(address account) external view returns (uint256);
212 
213     /**
214      * @dev Moves `amount` tokens from the caller's account to `recipient`.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transfer(address recipient, uint256 amount) external returns (bool);
221 
222     /**
223      * @dev Returns the remaining number of tokens that `spender` will be
224      * allowed to spend on behalf of `owner` through {transferFrom}. This is
225      * zero by default.
226      *
227      * This value changes when {approve} or {transferFrom} are called.
228      */
229     function allowance(address owner, address spender) external view returns (uint256);
230 
231     /**
232      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * IMPORTANT: Beware that changing an allowance with this method brings the risk
237      * that someone may use both the old and the new allowance by unfortunate
238      * transaction ordering. One possible solution to mitigate this race
239      * condition is to first reduce the spender's allowance to 0 and set the
240      * desired value afterwards:
241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242      *
243      * Emits an {Approval} event.
244      */
245     function approve(address spender, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Moves `amount` tokens from `sender` to `recipient` using the
249      * allowance mechanism. `amount` is then deducted from the caller's
250      * allowance.
251      *
252      * Returns a boolean value indicating whether the operation succeeded.
253      *
254      * Emits a {Transfer} event.
255      */
256     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
257 
258     /**
259      * @dev Emitted when `value` tokens are moved from one account (`from`) to
260      * another (`to`).
261      *
262      * Note that `value` may be zero.
263      */
264     event Transfer(address indexed from, address indexed to, uint256 value);
265 
266     /**
267      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
268      * a call to {approve}. `value` is the new allowance.
269      */
270     event Approval(address indexed owner, address indexed spender, uint256 value);
271 }
272 
273 // File: @openzeppelin/contracts/utils/Address.sol
274 
275 pragma solidity ^0.6.2;
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies in extcodesize, which returns 0 for contracts in
300         // construction, since the code is only stored at the end of the
301         // constructor execution.
302 
303         uint256 size;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { size := extcodesize(account) }
306         return size > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352       return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
416 
417 pragma solidity ^0.6.0;
418 
419 
420 
421 
422 /**
423  * @title SafeERC20
424  * @dev Wrappers around ERC20 operations that throw on failure (when the token
425  * contract returns false). Tokens that return no value (and instead revert or
426  * throw on failure) are also supported, non-reverting calls are assumed to be
427  * successful.
428  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
429  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
430  */
431 library SafeERC20 {
432     using SafeMath for uint256;
433     using Address for address;
434 
435     function safeTransfer(IERC20 token, address to, uint256 value) internal {
436         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
437     }
438 
439     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
440         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
441     }
442 
443     /**
444      * @dev Deprecated. This function has issues similar to the ones found in
445      * {IERC20-approve}, and its usage is discouraged.
446      *
447      * Whenever possible, use {safeIncreaseAllowance} and
448      * {safeDecreaseAllowance} instead.
449      */
450     function safeApprove(IERC20 token, address spender, uint256 value) internal {
451         // safeApprove should only be called when setting an initial allowance,
452         // or when resetting it to zero. To increase and decrease it, use
453         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
454         // solhint-disable-next-line max-line-length
455         require((value == 0) || (token.allowance(address(this), spender) == 0),
456             "SafeERC20: approve from non-zero to non-zero allowance"
457         );
458         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
459     }
460 
461     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
462         uint256 newAllowance = token.allowance(address(this), spender).add(value);
463         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
464     }
465 
466     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
467         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
468         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
469     }
470 
471     /**
472      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
473      * on the return value: the return value is optional (but if data is returned, it must not be false).
474      * @param token The token targeted by the call.
475      * @param data The call data (encoded using abi.encode or one of its variants).
476      */
477     function _callOptionalReturn(IERC20 token, bytes memory data) private {
478         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
479         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
480         // the target address contains contract code and also asserts for success in the low-level call.
481 
482         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
483         if (returndata.length > 0) { // Return data is optional
484             // solhint-disable-next-line max-line-length
485             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/GSN/Context.sol
491 
492 pragma solidity ^0.6.0;
493 
494 /*
495  * @dev Provides information about the current execution context, including the
496  * sender of the transaction and its data. While these are generally available
497  * via msg.sender and msg.data, they should not be accessed in such a direct
498  * manner, since when dealing with GSN meta-transactions the account sending and
499  * paying for execution may not be the actual sender (as far as an application
500  * is concerned).
501  *
502  * This contract is only required for intermediate, library-like contracts.
503  */
504 abstract contract Context {
505     function _msgSender() internal view virtual returns (address payable) {
506         return msg.sender;
507     }
508 
509     function _msgData() internal view virtual returns (bytes memory) {
510         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
511         return msg.data;
512     }
513 }
514 
515 // File: @openzeppelin/contracts/access/Ownable.sol
516 
517 pragma solidity ^0.6.0;
518 
519 /**
520  * @dev Contract module which provides a basic access control mechanism, where
521  * there is an account (an owner) that can be granted exclusive access to
522  * specific functions.
523  *
524  * By default, the owner account will be the one that deploys the contract. This
525  * can later be changed with {transferOwnership}.
526  *
527  * This module is used through inheritance. It will make available the modifier
528  * `onlyOwner`, which can be applied to your functions to restrict their use to
529  * the owner.
530  */
531 contract Ownable is Context {
532     address private _owner;
533 
534     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
535 
536     /**
537      * @dev Initializes the contract setting the deployer as the initial owner.
538      */
539     constructor () internal {
540         address msgSender = _msgSender();
541         _owner = msgSender;
542         emit OwnershipTransferred(address(0), msgSender);
543     }
544 
545     /**
546      * @dev Returns the address of the current owner.
547      */
548     function owner() public view returns (address) {
549         return _owner;
550     }
551 
552     /**
553      * @dev Throws if called by any account other than the owner.
554      */
555     modifier onlyOwner() {
556         require(_owner == _msgSender(), "Ownable: caller is not the owner");
557         _;
558     }
559 
560     /**
561      * @dev Leaves the contract without owner. It will not be possible to call
562      * `onlyOwner` functions anymore. Can only be called by the current owner.
563      *
564      * NOTE: Renouncing ownership will leave the contract without an owner,
565      * thereby removing any functionality that is only available to the owner.
566      */
567     function renounceOwnership() public virtual onlyOwner {
568         emit OwnershipTransferred(_owner, address(0));
569         _owner = address(0);
570     }
571 
572     /**
573      * @dev Transfers ownership of the contract to a new account (`newOwner`).
574      * Can only be called by the current owner.
575      */
576     function transferOwnership(address newOwner) public virtual onlyOwner {
577         require(newOwner != address(0), "Ownable: new owner is the zero address");
578         emit OwnershipTransferred(_owner, newOwner);
579         _owner = newOwner;
580     }
581 }
582 
583 // File: contracts/interfaces/IRewardDistributionRecipient.sol
584 
585 pragma solidity ^0.6.0;
586 
587 
588 abstract contract IRewardDistributionRecipient is Ownable {
589     address public rewardDistribution;
590 
591     function notifyRewardAmount(uint256 reward) external virtual;
592 
593     modifier onlyRewardDistribution() {
594         require(
595             _msgSender() == rewardDistribution,
596             'Caller is not reward distribution'
597         );
598         _;
599     }
600 
601     function setRewardDistribution(address _rewardDistribution)
602         external
603         virtual
604         onlyOwner
605     {
606         rewardDistribution = _rewardDistribution;
607     }
608 }
609 
610 // File: contracts/token/LPTokenWrapper.sol
611 
612 pragma solidity ^0.6.0;
613 
614 
615 
616 
617 contract LPTokenWrapper {
618     using SafeMath for uint256;
619     using SafeERC20 for IERC20;
620 
621     IERC20 public lpt;
622 
623     uint256 private _totalSupply;
624     mapping(address => uint256) private _balances;
625 
626     function totalSupply() public view returns (uint256) {
627         return _totalSupply;
628     }
629 
630     function balanceOf(address account) public view returns (uint256) {
631         return _balances[account];
632     }
633 
634     function stake(uint256 amount) public virtual {
635         _totalSupply = _totalSupply.add(amount);
636         _balances[msg.sender] = _balances[msg.sender].add(amount);
637         lpt.safeTransferFrom(msg.sender, address(this), amount);
638     }
639 
640     function withdraw(uint256 amount) public virtual {
641         _totalSupply = _totalSupply.sub(amount);
642         _balances[msg.sender] = _balances[msg.sender].sub(amount);
643         lpt.safeTransfer(msg.sender, amount);
644     }
645 }
646 
647 // File: contracts/distribution/DAIMISLPTokenSharePool.sol
648 
649 pragma solidity ^0.6.0;
650 /**
651  *Submitted for verification at Etherscan.io on 2020-07-17
652  */
653 
654 /*
655    ____            __   __        __   _
656   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
657  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
658 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
659      /___/
660 
661 * Synthetix: BASISCASHRewards.sol
662 *
663 * Docs: https://docs.synthetix.io/
664 *
665 *
666 * MIT License
667 * ===========
668 *
669 * Copyright (c) 2020 Synthetix
670 *
671 * Permission is hereby granted, free of charge, to any person obtaining a copy
672 * of this software and associated documentation files (the "Software"), to deal
673 * in the Software without restriction, including without limitation the rights
674 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
675 * copies of the Software, and to permit persons to whom the Software is
676 * furnished to do so, subject to the following conditions:
677 *
678 * The above copyright notice and this permission notice shall be included in all
679 * copies or substantial portions of the Software.
680 *
681 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
682 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
683 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
684 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
685 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
686 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
687 */
688 
689 // File: @openzeppelin/contracts/math/Math.sol
690 
691 
692 // File: @openzeppelin/contracts/math/SafeMath.sol
693 
694 
695 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
696 
697 
698 // File: @openzeppelin/contracts/utils/Address.sol
699 
700 
701 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
702 
703 
704 // File: contracts/IRewardDistributionRecipient.sol
705 
706 
707 
708 contract DAIMISLPTokenSharePool is
709     LPTokenWrapper,
710     IRewardDistributionRecipient
711 {
712     IERC20 public mithShare;
713     uint256 public DURATION = 365 days;
714 
715     uint256 public starttime;
716     uint256 public periodFinish = 0;
717     uint256 public rewardRate = 0;
718     uint256 public lastUpdateTime;
719     uint256 public rewardPerTokenStored;
720     mapping(address => uint256) public userRewardPerTokenPaid;
721     mapping(address => uint256) public rewards;
722 
723     event RewardAdded(uint256 reward);
724     event Staked(address indexed user, uint256 amount);
725     event Withdrawn(address indexed user, uint256 amount);
726     event RewardPaid(address indexed user, uint256 reward);
727 
728     constructor(
729         address mithShare_,
730         address lptoken_,
731         uint256 starttime_
732     ) public {
733         mithShare = IERC20(mithShare_);
734         lpt = IERC20(lptoken_);
735         starttime = starttime_;
736     }
737 
738     modifier checkStart() {
739         require(
740             block.timestamp >= starttime,
741             'DAIMISLPTokenSharePool: not start'
742         );
743         _;
744     }
745 
746     modifier updateReward(address account) {
747         rewardPerTokenStored = rewardPerToken();
748         lastUpdateTime = lastTimeRewardApplicable();
749         if (account != address(0)) {
750             rewards[account] = earned(account);
751             userRewardPerTokenPaid[account] = rewardPerTokenStored;
752         }
753         _;
754     }
755 
756     function lastTimeRewardApplicable() public view returns (uint256) {
757         return Math.min(block.timestamp, periodFinish);
758     }
759 
760     function rewardPerToken() public view returns (uint256) {
761         if (totalSupply() == 0) {
762             return rewardPerTokenStored;
763         }
764         return
765             rewardPerTokenStored.add(
766                 lastTimeRewardApplicable()
767                     .sub(lastUpdateTime)
768                     .mul(rewardRate)
769                     .mul(1e18)
770                     .div(totalSupply())
771             );
772     }
773 
774     function earned(address account) public view returns (uint256) {
775         return
776             balanceOf(account)
777                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
778                 .div(1e18)
779                 .add(rewards[account]);
780     }
781 
782     // stake visibility is public as overriding LPTokenWrapper's stake() function
783     function stake(uint256 amount)
784         public
785         override
786         updateReward(msg.sender)
787         checkStart
788     {
789         require(amount > 0, 'DAIMISLPTokenSharePool: Cannot stake 0');
790         super.stake(amount);
791         emit Staked(msg.sender, amount);
792     }
793 
794     function withdraw(uint256 amount)
795         public
796         override
797         updateReward(msg.sender)
798         checkStart
799     {
800         require(amount > 0, 'DAIMISLPTokenSharePool: Cannot withdraw 0');
801         super.withdraw(amount);
802         emit Withdrawn(msg.sender, amount);
803     }
804 
805     function exit() external {
806         withdraw(balanceOf(msg.sender));
807         getReward();
808     }
809 
810     function getReward() public updateReward(msg.sender) checkStart {
811         uint256 reward = earned(msg.sender);
812         if (reward > 0) {
813             rewards[msg.sender] = 0;
814             mithShare.safeTransfer(msg.sender, reward);
815             emit RewardPaid(msg.sender, reward);
816         }
817     }
818 
819     function notifyRewardAmount(uint256 reward)
820         external
821         override
822         onlyRewardDistribution
823         updateReward(address(0))
824     {
825         if (block.timestamp > starttime) {
826             if (block.timestamp >= periodFinish) {
827                 rewardRate = reward.div(DURATION);
828             } else {
829                 uint256 remaining = periodFinish.sub(block.timestamp);
830                 uint256 leftover = remaining.mul(rewardRate);
831                 rewardRate = reward.add(leftover).div(DURATION);
832             }
833             lastUpdateTime = block.timestamp;
834             periodFinish = block.timestamp.add(DURATION);
835             emit RewardAdded(reward);
836         } else {
837             rewardRate = reward.div(DURATION);
838             lastUpdateTime = starttime;
839             periodFinish = starttime.add(DURATION);
840             emit RewardAdded(reward);
841         }
842     }
843 }