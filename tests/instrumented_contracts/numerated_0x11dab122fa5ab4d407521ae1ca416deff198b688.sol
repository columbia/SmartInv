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
37 
38 
39 pragma solidity ^0.6.0;
40 
41 /**
42  * @dev Wrappers over Solidity's arithmetic operations with added overflow
43  * checks.
44  *
45  * Arithmetic operations in Solidity wrap on overflow. This can easily result
46  * in bugs, because programmers usually assume that an overflow raises an
47  * error, which is the standard behavior in high level programming languages.
48  * `SafeMath` restores this intuition by reverting the transaction when an
49  * operation overflows.
50  *
51  * Using this library instead of the unchecked operations eliminates an entire
52  * class of bugs, so it's recommended to use it always.
53  */
54 library SafeMath {
55     /**
56      * @dev Returns the addition of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `+` operator.
60      *
61      * Requirements:
62      *
63      * - Addition cannot overflow.
64      */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      *
80      * - Subtraction cannot overflow.
81      */
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the multiplication of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `*` operator.
108      *
109      * Requirements:
110      *
111      * - Multiplication cannot overflow.
112      */
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b, "SafeMath: multiplication overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers. Reverts on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return div(a, b, "SafeMath: division by zero");
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator. Note: this function uses a
148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
149      * uses an invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         return mod(a, b, "SafeMath: modulo by zero");
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts with custom message when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b != 0, errorMessage);
193         return a % b;
194     }
195 }
196 
197 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
198 
199 
200 
201 pragma solidity ^0.6.0;
202 
203 /**
204  * @dev Interface of the ERC20 standard as defined in the EIP.
205  */
206 interface IERC20 {
207     /**
208      * @dev Returns the amount of tokens in existence.
209      */
210     function totalSupply() external view returns (uint256);
211 
212     /**
213      * @dev Returns the amount of tokens owned by `account`.
214      */
215     function balanceOf(address account) external view returns (uint256);
216 
217     /**
218      * @dev Moves `amount` tokens from the caller's account to `recipient`.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transfer(address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Returns the remaining number of tokens that `spender` will be
228      * allowed to spend on behalf of `owner` through {transferFrom}. This is
229      * zero by default.
230      *
231      * This value changes when {approve} or {transferFrom} are called.
232      */
233     function allowance(address owner, address spender) external view returns (uint256);
234 
235     /**
236      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * IMPORTANT: Beware that changing an allowance with this method brings the risk
241      * that someone may use both the old and the new allowance by unfortunate
242      * transaction ordering. One possible solution to mitigate this race
243      * condition is to first reduce the spender's allowance to 0 and set the
244      * desired value afterwards:
245      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246      *
247      * Emits an {Approval} event.
248      */
249     function approve(address spender, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Moves `amount` tokens from `sender` to `recipient` using the
253      * allowance mechanism. `amount` is then deducted from the caller's
254      * allowance.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * Emits a {Transfer} event.
259      */
260     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
261 
262     /**
263      * @dev Emitted when `value` tokens are moved from one account (`from`) to
264      * another (`to`).
265      *
266      * Note that `value` may be zero.
267      */
268     event Transfer(address indexed from, address indexed to, uint256 value);
269 
270     /**
271      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
272      * a call to {approve}. `value` is the new allowance.
273      */
274     event Approval(address indexed owner, address indexed spender, uint256 value);
275 }
276 
277 // File: @openzeppelin/contracts/utils/Address.sol
278 
279 
280 
281 pragma solidity ^0.6.2;
282 
283 /**
284  * @dev Collection of functions related to the address type
285  */
286 library Address {
287     /**
288      * @dev Returns true if `account` is a contract.
289      *
290      * [IMPORTANT]
291      * ====
292      * It is unsafe to assume that an address for which this function returns
293      * false is an externally-owned account (EOA) and not a contract.
294      *
295      * Among others, `isContract` will return false for the following
296      * types of addresses:
297      *
298      *  - an externally-owned account
299      *  - a contract in construction
300      *  - an address where a contract will be created
301      *  - an address where a contract lived, but was destroyed
302      * ====
303      */
304     function isContract(address account) internal view returns (bool) {
305         // This method relies in extcodesize, which returns 0 for contracts in
306         // construction, since the code is only stored at the end of the
307         // constructor execution.
308 
309         uint256 size;
310         // solhint-disable-next-line no-inline-assembly
311         assembly { size := extcodesize(account) }
312         return size > 0;
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(address(this).balance >= amount, "Address: insufficient balance");
333 
334         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
335         (bool success, ) = recipient.call{ value: amount }("");
336         require(success, "Address: unable to send value, recipient may have reverted");
337     }
338 
339     /**
340      * @dev Performs a Solidity function call using a low level `call`. A
341      * plain`call` is an unsafe replacement for a function call: use this
342      * function instead.
343      *
344      * If `target` reverts with a revert reason, it is bubbled up by this
345      * function (like regular Solidity function calls).
346      *
347      * Returns the raw returned data. To convert to the expected return value,
348      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
349      *
350      * Requirements:
351      *
352      * - `target` must be a contract.
353      * - calling `target` with `data` must not revert.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
358       return functionCall(target, data, "Address: low-level call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
363      * `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
368         return _functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
393         require(address(this).balance >= value, "Address: insufficient balance for call");
394         return _functionCallWithValue(target, data, value, errorMessage);
395     }
396 
397     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
398         require(isContract(target), "Address: call to non-contract");
399 
400         // solhint-disable-next-line avoid-low-level-calls
401         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
402         if (success) {
403             return returndata;
404         } else {
405             // Look for revert reason and bubble it up if present
406             if (returndata.length > 0) {
407                 // The easiest way to bubble the revert reason is using memory via assembly
408 
409                 // solhint-disable-next-line no-inline-assembly
410                 assembly {
411                     let returndata_size := mload(returndata)
412                     revert(add(32, returndata), returndata_size)
413                 }
414             } else {
415                 revert(errorMessage);
416             }
417         }
418     }
419 }
420 
421 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
422 
423 
424 
425 pragma solidity ^0.6.0;
426 
427 
428 
429 
430 /**
431  * @title SafeERC20
432  * @dev Wrappers around ERC20 operations that throw on failure (when the token
433  * contract returns false). Tokens that return no value (and instead revert or
434  * throw on failure) are also supported, non-reverting calls are assumed to be
435  * successful.
436  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
437  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
438  */
439 library SafeERC20 {
440     using SafeMath for uint256;
441     using Address for address;
442 
443     function safeTransfer(IERC20 token, address to, uint256 value) internal {
444         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
445     }
446 
447     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
448         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
449     }
450 
451     /**
452      * @dev Deprecated. This function has issues similar to the ones found in
453      * {IERC20-approve}, and its usage is discouraged.
454      *
455      * Whenever possible, use {safeIncreaseAllowance} and
456      * {safeDecreaseAllowance} instead.
457      */
458     function safeApprove(IERC20 token, address spender, uint256 value) internal {
459         // safeApprove should only be called when setting an initial allowance,
460         // or when resetting it to zero. To increase and decrease it, use
461         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
462         // solhint-disable-next-line max-line-length
463         require((value == 0) || (token.allowance(address(this), spender) == 0),
464             "SafeERC20: approve from non-zero to non-zero allowance"
465         );
466         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
467     }
468 
469     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
470         uint256 newAllowance = token.allowance(address(this), spender).add(value);
471         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
472     }
473 
474     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
475         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
476         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
477     }
478 
479     /**
480      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
481      * on the return value: the return value is optional (but if data is returned, it must not be false).
482      * @param token The token targeted by the call.
483      * @param data The call data (encoded using abi.encode or one of its variants).
484      */
485     function _callOptionalReturn(IERC20 token, bytes memory data) private {
486         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
487         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
488         // the target address contains contract code and also asserts for success in the low-level call.
489 
490         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
491         if (returndata.length > 0) { // Return data is optional
492             // solhint-disable-next-line max-line-length
493             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
494         }
495     }
496 }
497 
498 // File: @openzeppelin/contracts/GSN/Context.sol
499 
500 
501 
502 pragma solidity ^0.6.0;
503 
504 /*
505  * @dev Provides information about the current execution context, including the
506  * sender of the transaction and its data. While these are generally available
507  * via msg.sender and msg.data, they should not be accessed in such a direct
508  * manner, since when dealing with GSN meta-transactions the account sending and
509  * paying for execution may not be the actual sender (as far as an application
510  * is concerned).
511  *
512  * This contract is only required for intermediate, library-like contracts.
513  */
514 abstract contract Context {
515     function _msgSender() internal view virtual returns (address payable) {
516         return msg.sender;
517     }
518 
519     function _msgData() internal view virtual returns (bytes memory) {
520         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
521         return msg.data;
522     }
523 }
524 
525 // File: @openzeppelin/contracts/access/Ownable.sol
526 
527 
528 
529 pragma solidity ^0.6.0;
530 
531 /**
532  * @dev Contract module which provides a basic access control mechanism, where
533  * there is an account (an owner) that can be granted exclusive access to
534  * specific functions.
535  *
536  * By default, the owner account will be the one that deploys the contract. This
537  * can later be changed with {transferOwnership}.
538  *
539  * This module is used through inheritance. It will make available the modifier
540  * `onlyOwner`, which can be applied to your functions to restrict their use to
541  * the owner.
542  */
543 contract Ownable is Context {
544     address private _owner;
545 
546     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
547 
548     /**
549      * @dev Initializes the contract setting the deployer as the initial owner.
550      */
551     constructor () internal {
552         address msgSender = _msgSender();
553         _owner = msgSender;
554         emit OwnershipTransferred(address(0), msgSender);
555     }
556 
557     /**
558      * @dev Returns the address of the current owner.
559      */
560     function owner() public view returns (address) {
561         return _owner;
562     }
563 
564     /**
565      * @dev Throws if called by any account other than the owner.
566      */
567     modifier onlyOwner() {
568         require(_owner == _msgSender(), "Ownable: caller is not the owner");
569         _;
570     }
571 
572     /**
573      * @dev Leaves the contract without owner. It will not be possible to call
574      * `onlyOwner` functions anymore. Can only be called by the current owner.
575      *
576      * NOTE: Renouncing ownership will leave the contract without an owner,
577      * thereby removing any functionality that is only available to the owner.
578      */
579     function renounceOwnership() public virtual onlyOwner {
580         emit OwnershipTransferred(_owner, address(0));
581         _owner = address(0);
582     }
583 
584     /**
585      * @dev Transfers ownership of the contract to a new account (`newOwner`).
586      * Can only be called by the current owner.
587      */
588     function transferOwnership(address newOwner) public virtual onlyOwner {
589         require(newOwner != address(0), "Ownable: new owner is the zero address");
590         emit OwnershipTransferred(_owner, newOwner);
591         _owner = newOwner;
592     }
593 }
594 
595 // File: contracts/interfaces/IRewardDistributionRecipient.sol
596 
597 pragma solidity ^0.6.0;
598 
599 
600 abstract contract IRewardDistributionRecipient is Ownable {
601     address public rewardDistribution;
602 
603     function notifyRewardAmount(uint256 reward) external virtual;
604 
605     modifier onlyRewardDistribution() {
606         require(
607             _msgSender() == rewardDistribution,
608             'Caller is not reward distribution'
609         );
610         _;
611     }
612 
613     function setRewardDistribution(address _rewardDistribution)
614         external
615         virtual
616         onlyOwner
617     {
618         rewardDistribution = _rewardDistribution;
619     }
620 }
621 
622 // File: contracts/token/LPTokenWrapper.sol
623 
624 pragma solidity ^0.6.0;
625 
626 
627 
628 
629 contract LPTokenWrapper {
630     using SafeMath for uint256;
631     using SafeERC20 for IERC20;
632 
633     IERC20 public lpt;
634 
635     uint256 private _totalSupply;
636     mapping(address => uint256) private _balances;
637 
638     function totalSupply() public view returns (uint256) {
639         return _totalSupply;
640     }
641 
642     function balanceOf(address account) public view returns (uint256) {
643         return _balances[account];
644     }
645 
646     function stake(uint256 amount) public virtual {
647         _totalSupply = _totalSupply.add(amount);
648         _balances[msg.sender] = _balances[msg.sender].add(amount);
649         lpt.safeTransferFrom(msg.sender, address(this), amount);
650     }
651 
652     function withdraw(uint256 amount) public virtual {
653         _totalSupply = _totalSupply.sub(amount);
654         _balances[msg.sender] = _balances[msg.sender].sub(amount);
655         lpt.safeTransfer(msg.sender, amount);
656     }
657 }
658 
659 // File: contracts/distribution/DAIONSLPTokenSharePool.sol
660 
661 pragma solidity ^0.6.0;
662 /**
663  *Submitted for verification at Etherscan.io on 2020-07-17
664  */
665 
666 /*
667    ____            __   __        __   _
668   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
669  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
670 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
671      /___/
672 
673 * Synthetix: BASISCASHRewards.sol
674 *
675 * Docs: https://docs.synthetix.io/
676 *
677 *
678 * MIT License
679 * ===========
680 *
681 * Copyright (c) 2020 Synthetix
682 *
683 * Permission is hereby granted, free of charge, to any person obtaining a copy
684 * of this software and associated documentation files (the "Software"), to deal
685 * in the Software without restriction, including without limitation the rights
686 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
687 * copies of the Software, and to permit persons to whom the Software is
688 * furnished to do so, subject to the following conditions:
689 *
690 * The above copyright notice and this permission notice shall be included in all
691 * copies or substantial portions of the Software.
692 *
693 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
694 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
695 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
696 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
697 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
698 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
699 */
700 
701 // File: @openzeppelin/contracts/math/Math.sol
702 
703 
704 // File: @openzeppelin/contracts/math/SafeMath.sol
705 
706 
707 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
708 
709 
710 // File: @openzeppelin/contracts/utils/Address.sol
711 
712 
713 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
714 
715 
716 // File: contracts/IRewardDistributionRecipient.sol
717 
718 
719 
720 contract DAIONSLPTokenSharePool is
721     LPTokenWrapper,
722     IRewardDistributionRecipient
723 {
724     IERC20 public oneShare;
725     uint256 public DURATION = 180 days;
726 
727     uint256 public starttime;
728     uint256 public periodFinish = 0;
729     uint256 public rewardRate = 0;
730     uint256 public lastUpdateTime;
731     uint256 public rewardPerTokenStored;
732     mapping(address => uint256) public userRewardPerTokenPaid;
733     mapping(address => uint256) public rewards;
734 
735     event RewardAdded(uint256 reward);
736     event Staked(address indexed user, uint256 amount);
737     event Withdrawn(address indexed user, uint256 amount);
738     event RewardPaid(address indexed user, uint256 reward);
739 
740     constructor(
741         address oneShare_,
742         address lptoken_,
743         uint256 starttime_
744     ) public {
745         oneShare = IERC20(oneShare_);
746         lpt = IERC20(lptoken_);
747         starttime = starttime_;
748     }
749 
750     modifier checkStart() {
751         require(
752             block.timestamp >= starttime,
753             'DAIBASLPTokenSharePool: not start'
754         );
755         _;
756     }
757 
758     modifier updateReward(address account) {
759         rewardPerTokenStored = rewardPerToken();
760         lastUpdateTime = lastTimeRewardApplicable();
761         if (account != address(0)) {
762             rewards[account] = earned(account);
763             userRewardPerTokenPaid[account] = rewardPerTokenStored;
764         }
765         _;
766     }
767 
768     function lastTimeRewardApplicable() public view returns (uint256) {
769         return Math.min(block.timestamp, periodFinish);
770     }
771 
772     function rewardPerToken() public view returns (uint256) {
773         if (totalSupply() == 0) {
774             return rewardPerTokenStored;
775         }
776         return
777             rewardPerTokenStored.add(
778                 lastTimeRewardApplicable()
779                     .sub(lastUpdateTime)
780                     .mul(rewardRate)
781                     .mul(1e18)
782                     .div(totalSupply())
783             );
784     }
785 
786     function earned(address account) public view returns (uint256) {
787         return
788             balanceOf(account)
789                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
790                 .div(1e18)
791                 .add(rewards[account]);
792     }
793 
794     // stake visibility is public as overriding LPTokenWrapper's stake() function
795     function stake(uint256 amount)
796         public
797         override
798         updateReward(msg.sender)
799         checkStart
800     {
801         require(amount > 0, 'DAIBASLPTokenSharePool: Cannot stake 0');
802         super.stake(amount);
803         emit Staked(msg.sender, amount);
804     }
805 
806     function withdraw(uint256 amount)
807         public
808         override
809         updateReward(msg.sender)
810         checkStart
811     {
812         require(amount > 0, 'DAIBASLPTokenSharePool: Cannot withdraw 0');
813         super.withdraw(amount);
814         emit Withdrawn(msg.sender, amount);
815     }
816 
817     function exit() external {
818         withdraw(balanceOf(msg.sender));
819         getReward();
820     }
821 
822     function getReward() public updateReward(msg.sender) checkStart {
823         uint256 reward = earned(msg.sender);
824         if (reward > 0) {
825             rewards[msg.sender] = 0;
826             oneShare.safeTransfer(msg.sender, reward);
827             emit RewardPaid(msg.sender, reward);
828         }
829     }
830 
831     function notifyRewardAmount(uint256 reward)
832         external
833         override
834         onlyRewardDistribution
835         updateReward(address(0))
836     {
837         if (block.timestamp > starttime) {
838             if (block.timestamp >= periodFinish) {
839                 rewardRate = reward.div(DURATION);
840             } else {
841                 uint256 remaining = periodFinish.sub(block.timestamp);
842                 uint256 leftover = remaining.mul(rewardRate);
843                 rewardRate = reward.add(leftover).div(DURATION);
844             }
845             lastUpdateTime = block.timestamp;
846             periodFinish = block.timestamp.add(DURATION);
847             emit RewardAdded(reward);
848         } else {
849             rewardRate = reward.div(DURATION);
850             lastUpdateTime = starttime;
851             periodFinish = starttime.add(DURATION);
852             emit RewardAdded(reward);
853         }
854     }
855 }