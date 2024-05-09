1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 // SPDX-License-Identifier: UNLICENSED
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
595 // File: contracts/owner/Operator.sol
596 
597 pragma solidity ^0.6.0;
598 
599 
600 
601 contract Operator is Context, Ownable {
602     address private _operator;
603 
604     event OperatorTransferred(
605         address indexed previousOperator,
606         address indexed newOperator
607     );
608 
609     constructor() internal {
610         _operator = _msgSender();
611         emit OperatorTransferred(address(0), _operator);
612     }
613 
614     function operator() public view returns (address) {
615         return _operator;
616     }
617 
618     modifier onlyOperator() {
619         require(
620             _operator == msg.sender,
621             'operator: caller is not the operator'
622         );
623         _;
624     }
625 
626     function isOperator() public view returns (bool) {
627         return _msgSender() == _operator;
628     }
629 
630     function transferOperator(address newOperator_) public onlyOwner {
631         _transferOperator(newOperator_);
632     }
633 
634     function _transferOperator(address newOperator_) internal {
635         require(
636             newOperator_ != address(0),
637             'operator: zero address given for new operator'
638         );
639         emit OperatorTransferred(address(0), newOperator_);
640         _operator = newOperator_;
641     }
642 }
643 
644 // File: contracts/KATGUMPool.sol
645 
646 pragma solidity ^0.6.0;
647 
648 /*
649    ____            __   __        __   _
650   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
651  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
652 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
653      /___/
654 
655 * Synthetix: KATGUMPool.sol
656 *
657 * Docs: https://docs.synthetix.io/
658 *
659 *
660 * MIT License
661 * ===========
662 *
663 * Copyright (c) 2020 Synthetix
664 *
665 * Permission is hereby granted, free of charge, to any person obtaining a copy
666 * of this software and associated documentation files (the "Software"), to deal
667 * in the Software without restriction, including without limitation the rights
668 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
669 * copies of the Software, and to permit persons to whom the Software is
670 * furnished to do so, subject to the following conditions:
671 *
672 * The above copyright notice and this permission notice shall be included in all
673 * copies or substantial portions of the Software.
674 *
675 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
676 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
677 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
678 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
679 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
680 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
681 */
682 
683 
684 
685 
686 
687 
688 
689 contract GUMWrapper{
690     using SafeMath for uint256;
691     using SafeERC20 for IERC20;
692 
693     IERC20 public gum;
694 
695     uint256 private _totalSupply;
696     mapping(address => uint256) private _balances;
697 
698     function totalSupply() public view returns (uint256) {
699         return _totalSupply;
700     }
701 
702     function balanceOf(address account) public view returns (uint256) {
703         return _balances[account];
704     }
705 
706     function stake(uint256 amount) public virtual {
707         _totalSupply = _totalSupply.add(amount);
708         _balances[msg.sender] = _balances[msg.sender].add(amount);
709         gum.safeTransferFrom(msg.sender, address(this), amount);
710     }
711 
712     function withdraw(uint256 amount) public virtual {
713         _totalSupply = _totalSupply.sub(amount);
714         _balances[msg.sender] = _balances[msg.sender].sub(amount);
715         gum.safeTransfer(msg.sender, amount);
716     }
717 }
718 
719 contract KATGUMPool is GUMWrapper , Operator {
720     IERC20 public kat;
721     uint256 public constant DURATION = 30 days;
722     bool public stop = false;
723 
724     uint256 public initreward = 25000000 * 10**18; // 25.000.000 KAT;
725     uint256 public starttime;
726     uint256 public rewardtime;
727     uint256 public periodFinish = 0;
728     uint256 public rewardRate = 0;
729     uint256 public lastUpdateTime;
730     uint256 public rewardPerTokenStored;
731     mapping(address => uint256) public userRewardPerTokenPaid;
732     mapping(address => uint256) public rewards;
733     mapping(address => uint256) public deposits;
734 
735 
736 
737     event SetInitReward(uint256 reward);
738     event RewardAdded(uint256 reward);
739     event Staked(address indexed user, uint256 amount);
740     event Withdrawn(address indexed user, uint256 amount);
741     event RewardPaid(address indexed user, uint256 reward);
742     event EmergencyWithdraw(address indexed user);
743     event Stopped(bool stake);
744 
745     constructor(
746         address kat_,
747         address gum_,
748         uint256 starttime_
749     ) public {
750         kat = IERC20(kat_);
751         gum = IERC20(gum_);
752         starttime = starttime_;
753     }
754 
755     modifier checkStart() {
756         require(block.timestamp >= starttime, 'KATGUMPool: not start');
757         _;
758     }
759 
760     modifier updateReward(address account) {
761         rewardPerTokenStored = rewardPerToken();
762         lastUpdateTime = lastTimeRewardApplicable();
763         if (account != address(0)) {
764             rewards[account] = earned(account);
765             userRewardPerTokenPaid[account] = rewardPerTokenStored;
766         }
767         _;
768     }
769 
770     function lastTimeRewardApplicable() public view returns (uint256) {
771         return Math.min(block.timestamp, periodFinish);
772     }
773 
774     function rewardPerToken() public view returns (uint256) {
775 
776         if(stop == true){
777             return 0;
778         }
779 
780         if(block.timestamp <= rewardtime){
781             return 0;
782         }
783 
784         if (totalSupply() == 0) {
785             return rewardPerTokenStored;
786         }
787         return
788         rewardPerTokenStored.add(
789             lastTimeRewardApplicable()
790             .sub(lastUpdateTime)
791             .mul(rewardRate)
792             .mul(1e18)
793             .div(totalSupply())
794         );
795     }
796 
797     function earned(address account) public view returns (uint256) {
798         return
799         balanceOf(account)
800         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
801         .div(1e18)
802         .add(rewards[account]);
803     }
804 
805     // stake visibility is public as overriding LPTokenWrapper's stake() function
806     function stake(uint256 amount)
807     public
808     override
809     updateReward(msg.sender)
810     checkhalve
811     checkStart
812     {
813         require(amount > 0, 'KATGUMPool: Cannot stake 0');
814         uint256 newDeposit = deposits[msg.sender].add(amount);
815         deposits[msg.sender] = newDeposit;
816         super.stake(amount);
817         emit Staked(msg.sender, amount);
818     }
819 
820     function withdraw(uint256 amount)
821     public
822     override
823     updateReward(msg.sender)
824     checkhalve
825     checkStart
826     {
827         require(amount > 0, 'KATGUMPool: Cannot withdraw 0');
828         deposits[msg.sender] = deposits[msg.sender].sub(amount);
829         super.withdraw(amount);
830         emit Withdrawn(msg.sender, amount);
831     }
832 
833     function exit() external {
834         withdraw(balanceOf(msg.sender));
835         getReward();
836     }
837     
838     function emergencyWithdraw() public  onlyOperator {
839         kat.safeTransfer(msg.sender, kat.balanceOf(address(this)));
840         emit EmergencyWithdraw(msg.sender);
841     }
842     
843     function getReward() public updateReward(msg.sender) checkhalve checkStart {
844         uint256 reward = earned(msg.sender);
845         if (reward > 0) {
846             rewards[msg.sender] = 0;
847             kat.safeTransfer(msg.sender, reward);
848             emit RewardPaid(msg.sender, reward);
849         }
850     }
851 
852     modifier checkhalve() {
853         if (block.timestamp >= periodFinish) {
854             rewardRate = initreward.div(DURATION);
855             periodFinish = block.timestamp.add(DURATION);
856             emit RewardAdded(initreward);
857         }
858         _;
859     }
860 
861     function setInitReward(uint256 amount) public onlyOperator {
862         initreward = amount;
863         emit SetInitReward(initreward);
864     }
865 
866     function poolStop(bool _stake) public onlyOperator {
867         stop = _stake;
868         emit Stopped(_stake);
869     }
870 
871     function notifyRewardAmount(uint256 reward)
872     external
873     onlyOperator
874     updateReward(address(0))
875     {
876         if (block.timestamp > starttime) {
877             if (block.timestamp >= periodFinish) {
878                 rewardRate = reward.div(DURATION);
879             } else {
880                 uint256 remaining = periodFinish.sub(block.timestamp);
881                 uint256 leftover = remaining.mul(rewardRate);
882                 rewardRate = reward.add(leftover).div(DURATION);
883             }
884             lastUpdateTime = block.timestamp;
885             periodFinish = block.timestamp.add(DURATION);
886             emit RewardAdded(reward);
887         } else {
888             rewardRate = reward.div(DURATION);
889             lastUpdateTime = starttime;
890             periodFinish = starttime.add(DURATION);
891             emit RewardAdded(reward);
892         }
893     }
894 }