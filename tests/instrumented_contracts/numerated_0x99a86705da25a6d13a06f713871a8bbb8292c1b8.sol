1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: contracts/interfaces/IERC20Burnable.sol
97 
98 /*
99 * MIT License
100 * ===========
101 *
102 * Permission is hereby granted, free of charge, to any person obtaining a copy
103 * of this software and associated documentation files (the "Software"), to deal
104 * in the Software without restriction, including without limitation the rights
105 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
106 * copies of the Software, and to permit persons to whom the Software is
107 * furnished to do so, subject to the following conditions:
108 *
109 * The above copyright notice and this permission notice shall be included in all
110 * copies or substantial portions of the Software.
111 *
112 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
113 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
114 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
115 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
116 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
117 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
118 */
119 
120 pragma solidity ^0.6.2;
121 
122 interface IERC20Burnable {
123     function totalSupply() external view returns (uint256);
124     function balanceOf(address account) external view returns (uint256);
125     function transfer(address recipient, uint256 amount) external returns (bool);
126     function allowance(address owner, address spender) external view returns (uint256);
127     function approve(address spender, uint256 amount) external returns (bool);
128     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
129     function burn(uint256 amount) external;
130     event Transfer(address indexed from, address indexed to, uint256 value);
131     event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
135 
136 pragma solidity ^0.6.0;
137 
138 /**
139  * @dev Interface of the ERC20 standard as defined in the EIP.
140  */
141 interface IERC20 {
142     /**
143      * @dev Returns the amount of tokens in existence.
144      */
145     function totalSupply() external view returns (uint256);
146 
147     /**
148      * @dev Returns the amount of tokens owned by `account`.
149      */
150     function balanceOf(address account) external view returns (uint256);
151 
152     /**
153      * @dev Moves `amount` tokens from the caller's account to `recipient`.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transfer(address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Returns the remaining number of tokens that `spender` will be
163      * allowed to spend on behalf of `owner` through {transferFrom}. This is
164      * zero by default.
165      *
166      * This value changes when {approve} or {transferFrom} are called.
167      */
168     function allowance(address owner, address spender) external view returns (uint256);
169 
170     /**
171      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * IMPORTANT: Beware that changing an allowance with this method brings the risk
176      * that someone may use both the old and the new allowance by unfortunate
177      * transaction ordering. One possible solution to mitigate this race
178      * condition is to first reduce the spender's allowance to 0 and set the
179      * desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      *
182      * Emits an {Approval} event.
183      */
184     function approve(address spender, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Moves `amount` tokens from `sender` to `recipient` using the
188      * allowance mechanism. `amount` is then deducted from the caller's
189      * allowance.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
196 
197     /**
198      * @dev Emitted when `value` tokens are moved from one account (`from`) to
199      * another (`to`).
200      *
201      * Note that `value` may be zero.
202      */
203     event Transfer(address indexed from, address indexed to, uint256 value);
204 
205     /**
206      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
207      * a call to {approve}. `value` is the new allowance.
208      */
209     event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 // File: contracts/interfaces/ITreasury.sol
213 
214 pragma solidity ^0.6.2;
215 
216 
217 
218 interface ITreasury {
219     function defaultToken() external view returns (IERC20);
220     function deposit(IERC20 token, uint256 amount) external;
221     function withdraw(uint256 amount, address withdrawAddress) external;
222 }
223 
224 // File: contracts/interfaces/ISwapRouter.sol
225 
226 pragma solidity ^0.6.2;
227 
228 
229 interface SwapRouter {
230     function WETH() external pure returns (address);
231     function swapExactTokensForTokens(
232       uint amountIn,
233       uint amountOutMin,
234       address[] calldata path,
235       address to,
236       uint deadline
237     ) external returns (uint[] memory amounts);
238 }
239 
240 // File: @openzeppelin/contracts/math/SafeMath.sol
241 
242 pragma solidity ^0.6.0;
243 
244 /**
245  * @dev Wrappers over Solidity's arithmetic operations with added overflow
246  * checks.
247  *
248  * Arithmetic operations in Solidity wrap on overflow. This can easily result
249  * in bugs, because programmers usually assume that an overflow raises an
250  * error, which is the standard behavior in high level programming languages.
251  * `SafeMath` restores this intuition by reverting the transaction when an
252  * operation overflows.
253  *
254  * Using this library instead of the unchecked operations eliminates an entire
255  * class of bugs, so it's recommended to use it always.
256  */
257 library SafeMath {
258     /**
259      * @dev Returns the addition of two unsigned integers, reverting on
260      * overflow.
261      *
262      * Counterpart to Solidity's `+` operator.
263      *
264      * Requirements:
265      *
266      * - Addition cannot overflow.
267      */
268     function add(uint256 a, uint256 b) internal pure returns (uint256) {
269         uint256 c = a + b;
270         require(c >= a, "SafeMath: addition overflow");
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the subtraction of two unsigned integers, reverting on
277      * overflow (when the result is negative).
278      *
279      * Counterpart to Solidity's `-` operator.
280      *
281      * Requirements:
282      *
283      * - Subtraction cannot overflow.
284      */
285     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
286         return sub(a, b, "SafeMath: subtraction overflow");
287     }
288 
289     /**
290      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
291      * overflow (when the result is negative).
292      *
293      * Counterpart to Solidity's `-` operator.
294      *
295      * Requirements:
296      *
297      * - Subtraction cannot overflow.
298      */
299     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b <= a, errorMessage);
301         uint256 c = a - b;
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the multiplication of two unsigned integers, reverting on
308      * overflow.
309      *
310      * Counterpart to Solidity's `*` operator.
311      *
312      * Requirements:
313      *
314      * - Multiplication cannot overflow.
315      */
316     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
317         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
318         // benefit is lost if 'b' is also tested.
319         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
320         if (a == 0) {
321             return 0;
322         }
323 
324         uint256 c = a * b;
325         require(c / a == b, "SafeMath: multiplication overflow");
326 
327         return c;
328     }
329 
330     /**
331      * @dev Returns the integer division of two unsigned integers. Reverts on
332      * division by zero. The result is rounded towards zero.
333      *
334      * Counterpart to Solidity's `/` operator. Note: this function uses a
335      * `revert` opcode (which leaves remaining gas untouched) while Solidity
336      * uses an invalid opcode to revert (consuming all remaining gas).
337      *
338      * Requirements:
339      *
340      * - The divisor cannot be zero.
341      */
342     function div(uint256 a, uint256 b) internal pure returns (uint256) {
343         return div(a, b, "SafeMath: division by zero");
344     }
345 
346     /**
347      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
348      * division by zero. The result is rounded towards zero.
349      *
350      * Counterpart to Solidity's `/` operator. Note: this function uses a
351      * `revert` opcode (which leaves remaining gas untouched) while Solidity
352      * uses an invalid opcode to revert (consuming all remaining gas).
353      *
354      * Requirements:
355      *
356      * - The divisor cannot be zero.
357      */
358     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
359         require(b > 0, errorMessage);
360         uint256 c = a / b;
361         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
362 
363         return c;
364     }
365 
366     /**
367      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
368      * Reverts when dividing by zero.
369      *
370      * Counterpart to Solidity's `%` operator. This function uses a `revert`
371      * opcode (which leaves remaining gas untouched) while Solidity uses an
372      * invalid opcode to revert (consuming all remaining gas).
373      *
374      * Requirements:
375      *
376      * - The divisor cannot be zero.
377      */
378     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
379         return mod(a, b, "SafeMath: modulo by zero");
380     }
381 
382     /**
383      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
384      * Reverts with custom message when dividing by zero.
385      *
386      * Counterpart to Solidity's `%` operator. This function uses a `revert`
387      * opcode (which leaves remaining gas untouched) while Solidity uses an
388      * invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      *
392      * - The divisor cannot be zero.
393      */
394     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
395         require(b != 0, errorMessage);
396         return a % b;
397     }
398 }
399 
400 // File: @openzeppelin/contracts/utils/Address.sol
401 
402 pragma solidity ^0.6.2;
403 
404 /**
405  * @dev Collection of functions related to the address type
406  */
407 library Address {
408     /**
409      * @dev Returns true if `account` is a contract.
410      *
411      * [IMPORTANT]
412      * ====
413      * It is unsafe to assume that an address for which this function returns
414      * false is an externally-owned account (EOA) and not a contract.
415      *
416      * Among others, `isContract` will return false for the following
417      * types of addresses:
418      *
419      *  - an externally-owned account
420      *  - a contract in construction
421      *  - an address where a contract will be created
422      *  - an address where a contract lived, but was destroyed
423      * ====
424      */
425     function isContract(address account) internal view returns (bool) {
426         // This method relies in extcodesize, which returns 0 for contracts in
427         // construction, since the code is only stored at the end of the
428         // constructor execution.
429 
430         uint256 size;
431         // solhint-disable-next-line no-inline-assembly
432         assembly { size := extcodesize(account) }
433         return size > 0;
434     }
435 
436     /**
437      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
438      * `recipient`, forwarding all available gas and reverting on errors.
439      *
440      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
441      * of certain opcodes, possibly making contracts go over the 2300 gas limit
442      * imposed by `transfer`, making them unable to receive funds via
443      * `transfer`. {sendValue} removes this limitation.
444      *
445      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
446      *
447      * IMPORTANT: because control is transferred to `recipient`, care must be
448      * taken to not create reentrancy vulnerabilities. Consider using
449      * {ReentrancyGuard} or the
450      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
451      */
452     function sendValue(address payable recipient, uint256 amount) internal {
453         require(address(this).balance >= amount, "Address: insufficient balance");
454 
455         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
456         (bool success, ) = recipient.call{ value: amount }("");
457         require(success, "Address: unable to send value, recipient may have reverted");
458     }
459 
460     /**
461      * @dev Performs a Solidity function call using a low level `call`. A
462      * plain`call` is an unsafe replacement for a function call: use this
463      * function instead.
464      *
465      * If `target` reverts with a revert reason, it is bubbled up by this
466      * function (like regular Solidity function calls).
467      *
468      * Returns the raw returned data. To convert to the expected return value,
469      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
470      *
471      * Requirements:
472      *
473      * - `target` must be a contract.
474      * - calling `target` with `data` must not revert.
475      *
476      * _Available since v3.1._
477      */
478     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
479       return functionCall(target, data, "Address: low-level call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
484      * `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
489         return _functionCallWithValue(target, data, 0, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but also transferring `value` wei to `target`.
495      *
496      * Requirements:
497      *
498      * - the calling contract must have an ETH balance of at least `value`.
499      * - the called Solidity function must be `payable`.
500      *
501      * _Available since v3.1._
502      */
503     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
504         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
509      * with `errorMessage` as a fallback revert reason when `target` reverts.
510      *
511      * _Available since v3.1._
512      */
513     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
514         require(address(this).balance >= value, "Address: insufficient balance for call");
515         return _functionCallWithValue(target, data, value, errorMessage);
516     }
517 
518     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
519         require(isContract(target), "Address: call to non-contract");
520 
521         // solhint-disable-next-line avoid-low-level-calls
522         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
523         if (success) {
524             return returndata;
525         } else {
526             // Look for revert reason and bubble it up if present
527             if (returndata.length > 0) {
528                 // The easiest way to bubble the revert reason is using memory via assembly
529 
530                 // solhint-disable-next-line no-inline-assembly
531                 assembly {
532                     let returndata_size := mload(returndata)
533                     revert(add(32, returndata), returndata_size)
534                 }
535             } else {
536                 revert(errorMessage);
537             }
538         }
539     }
540 }
541 
542 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
543 
544 pragma solidity ^0.6.0;
545 
546 
547 
548 
549 /**
550  * @title SafeERC20
551  * @dev Wrappers around ERC20 operations that throw on failure (when the token
552  * contract returns false). Tokens that return no value (and instead revert or
553  * throw on failure) are also supported, non-reverting calls are assumed to be
554  * successful.
555  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
556  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
557  */
558 library SafeERC20 {
559     using SafeMath for uint256;
560     using Address for address;
561 
562     function safeTransfer(IERC20 token, address to, uint256 value) internal {
563         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
564     }
565 
566     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
567         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
568     }
569 
570     /**
571      * @dev Deprecated. This function has issues similar to the ones found in
572      * {IERC20-approve}, and its usage is discouraged.
573      *
574      * Whenever possible, use {safeIncreaseAllowance} and
575      * {safeDecreaseAllowance} instead.
576      */
577     function safeApprove(IERC20 token, address spender, uint256 value) internal {
578         // safeApprove should only be called when setting an initial allowance,
579         // or when resetting it to zero. To increase and decrease it, use
580         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
581         // solhint-disable-next-line max-line-length
582         require((value == 0) || (token.allowance(address(this), spender) == 0),
583             "SafeERC20: approve from non-zero to non-zero allowance"
584         );
585         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
586     }
587 
588     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
589         uint256 newAllowance = token.allowance(address(this), spender).add(value);
590         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
591     }
592 
593     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
594         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
595         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
596     }
597 
598     /**
599      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
600      * on the return value: the return value is optional (but if data is returned, it must not be false).
601      * @param token The token targeted by the call.
602      * @param data The call data (encoded using abi.encode or one of its variants).
603      */
604     function _callOptionalReturn(IERC20 token, bytes memory data) private {
605         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
606         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
607         // the target address contains contract code and also asserts for success in the low-level call.
608 
609         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
610         if (returndata.length > 0) { // Return data is optional
611             // solhint-disable-next-line max-line-length
612             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
613         }
614     }
615 }
616 
617 // File: contracts/LPTokenWrapper.sol
618 
619 /*
620 * MIT License
621 * ===========
622 *
623 * Permission is hereby granted, free of charge, to any person obtaining a copy
624 * of this software and associated documentation files (the "Software"), to deal
625 * in the Software without restriction, including without limitation the rights
626 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
627 * copies of the Software, and to permit persons to whom the Software is
628 * furnished to do so, subject to the following conditions:
629 *
630 * The above copyright notice and this permission notice shall be included in all
631 * copies or substantial portions of the Software.
632 *
633 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
634 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
635 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
636 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
637 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
638 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
639 */
640 
641 pragma solidity 0.6.2;
642 
643 
644 
645 
646 contract LPTokenWrapper {
647 
648     using SafeMath for uint256;
649     using SafeERC20 for IERC20;
650 
651     uint256 private _totalSupply;
652 
653     IERC20 public stakeToken;
654 
655     mapping(address => uint256) private _balances;
656 
657     constructor(IERC20 _stakeToken) public {
658         stakeToken = _stakeToken;
659     }
660 
661     function totalSupply() public view returns (uint256) {
662         return _totalSupply;
663     }
664 
665     function balanceOf(address account) public view returns (uint256) {
666         return _balances[account];
667     }
668 
669     function stake(uint256 amount) public virtual {
670         _totalSupply = _totalSupply.add(amount);
671         _balances[msg.sender] = _balances[msg.sender].add(amount);
672         // safeTransferFrom shifted to last line of overridden method
673     }
674 
675     function withdraw(uint256 amount) public virtual {
676         _totalSupply = _totalSupply.sub(amount);
677         _balances[msg.sender] = _balances[msg.sender].sub(amount);
678         // safeTransfer shifted to last line of overridden method
679     }    
680 }
681 
682 // File: contracts/AdditionalMath.sol
683 
684 pragma solidity 0.6.2;
685 
686 /*
687 #    Copyright (C) 2017  alianse777
688 #    This program is free software: you can redistribute it and/or modify
689 #    it under the terms of the GNU General Public License as published by
690 #    the Free Software Foundation, either version 3 of the License, or
691 #    (at your option) any later version.
692 #
693 #    This program is distributed in the hope that it will be useful,
694 #    but WITHOUT ANY WARRANTY; without even the implied warranty of
695 #    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
696 #    GNU General Public License for more details.
697 #
698 #    You should have received a copy of the GNU General Public License
699 #    along with this program.  If not, see <http://www.gnu.org/licenses/>.
700 #    https://github.com/alianse777/solidity-standard-library.git
701 */
702 
703 
704 library AdditionalMath {
705 
706     using SafeMath for uint256;
707 
708    /**
709     * @dev Compute square root of x
710     * @param x num to sqrt
711     * @return sqrt(x)
712     */
713    function sqrt(uint x) internal pure returns (uint){
714        uint n = x / 2;
715        uint lstX = 0;
716        while (n != lstX){
717            lstX = n;
718            n = (n + x/n) / 2; 
719        }
720        return uint(n);
721    }
722 
723 }
724 
725 // File: @openzeppelin/contracts/math/Math.sol
726 
727 pragma solidity ^0.6.0;
728 
729 /**
730  * @dev Standard math utilities missing in the Solidity language.
731  */
732 library Math {
733     /**
734      * @dev Returns the largest of two numbers.
735      */
736     function max(uint256 a, uint256 b) internal pure returns (uint256) {
737         return a >= b ? a : b;
738     }
739 
740     /**
741      * @dev Returns the smallest of two numbers.
742      */
743     function min(uint256 a, uint256 b) internal pure returns (uint256) {
744         return a < b ? a : b;
745     }
746 
747     /**
748      * @dev Returns the average of two numbers. The result is rounded towards
749      * zero.
750      */
751     function average(uint256 a, uint256 b) internal pure returns (uint256) {
752         // (a + b) / 2 can overflow, so we distribute
753         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
754     }
755 }
756 
757 // File: contracts/AlunaBoostPool.sol
758 
759 /*
760 * MIT License
761 * ===========
762 *
763 * Permission is hereby granted, free of charge, to any person obtaining a copy
764 * of this software and associated documentation files (the "Software"), to deal
765 * in the Software without restriction, including without limitation the rights
766 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
767 * copies of the Software, and to permit persons to whom the Software is
768 * furnished to do so, subject to the following conditions:
769 *
770 * The above copyright notice and this permission notice shall be included in all
771 * copies or substantial portions of the Software.
772 *
773 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
774 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
775 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
776 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
777 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
778 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
779 */
780 
781 pragma solidity 0.6.2;
782 
783 
784 
785 
786 
787 
788 
789 
790 contract AlunaBoostPool is LPTokenWrapper, Ownable {
791     
792     using AdditionalMath for uint256;
793     
794     IERC20 public rewardToken;
795     IERC20 public boostToken;
796     ITreasury public treasury;
797     SwapRouter public swapRouter;
798     IERC20 public stablecoin;
799     
800     
801     uint256 public tokenCapAmount;
802     uint256 public starttime;
803     uint256 public duration;
804     uint256 public periodFinish;
805     uint256 public rewardRate;
806     uint256 public lastUpdateTime;
807     uint256 public rewardPerTokenStored;
808     uint256 public constant SECONDS_IN_A_DAY = 86400;
809     mapping(address => uint256) public userRewardPerTokenPaid;
810     mapping(address => uint256) public rewards;
811     
812     // booster variables
813     // variables to keep track of totalSupply and balances (after accounting for multiplier)
814     uint256 public boostedTotalSupply;
815     uint256 public lastBoostPurchase; // timestamp of lastBoostPurchase
816     mapping(address => uint256) public boostedBalances;
817     mapping(address => uint256) public numBoostersBought; // each booster = 5% increase in stake amt
818     mapping(address => uint256) public nextBoostPurchaseTime; // timestamp for which user is eligible to purchase another booster
819     uint256 public globalBoosterPrice = 1e18;
820     uint256 public boostThreshold = 10;
821     uint256 public boostScaleFactor = 20;
822     uint256 public scaleFactor = 320;
823 
824     event RewardAdded(uint256 reward);
825     event RewardPaid(address indexed user, uint256 reward);
826 
827     modifier checkStart() {
828         require(block.timestamp >= starttime,"not start");
829         _;
830     }
831 
832     modifier updateReward(address account) {
833         rewardPerTokenStored = rewardPerToken();
834         lastUpdateTime = lastTimeRewardApplicable();
835         if (account != address(0)) {
836             rewards[account] = earned(account);
837             userRewardPerTokenPaid[account] = rewardPerTokenStored;
838         }
839         _;
840     }
841 
842     constructor(
843         uint256 _tokenCapAmount,
844         IERC20 _stakeToken,
845         IERC20 _rewardToken,
846         IERC20 _boostToken,
847         address _treasury,
848         SwapRouter _swapRouter,
849         uint256 _starttime,
850         uint256 _duration
851     ) public LPTokenWrapper(_stakeToken) {
852         tokenCapAmount = _tokenCapAmount;
853         boostToken = _boostToken;
854         rewardToken = _rewardToken;
855         treasury = ITreasury(_treasury);
856         stablecoin = treasury.defaultToken();
857         swapRouter = _swapRouter;
858         starttime = _starttime;
859         lastBoostPurchase = _starttime;
860         duration = _duration;
861         boostToken.safeApprove(address(_swapRouter), uint256(-1));
862         stablecoin.safeApprove(address(treasury), uint256(-1));
863     }
864     
865     function lastTimeRewardApplicable() public view returns (uint256) {
866         return Math.min(block.timestamp, periodFinish);
867     }
868 
869     function rewardPerToken() public view returns (uint256) {
870         if (boostedTotalSupply == 0) {
871             return rewardPerTokenStored;
872         }
873         return
874             rewardPerTokenStored.add(
875                 lastTimeRewardApplicable()
876                     .sub(lastUpdateTime)
877                     .mul(rewardRate)
878                     .mul(1e18)
879                     .div(boostedTotalSupply)
880             );
881     }
882 
883     function earned(address account) public view returns (uint256) {
884         return
885             boostedBalances[account]
886                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
887                 .div(1e18)
888                 .add(rewards[account]);
889     }
890 
891     function getBoosterPrice(address user)
892         public view returns (uint256 boosterPrice, uint256 newBoostBalance)
893     {
894         if (boostedTotalSupply == 0) return (0,0);
895 
896         // each previously user-purchased booster will increase price in 5%,
897         // that is, 1 booster means 5% increase, 2 boosters mean 10% and so on
898         uint256 boostersBought = numBoostersBought[user];
899         boosterPrice = globalBoosterPrice.mul(boostersBought.mul(5).add(100)).div(100);
900 
901         // increment boostersBought by 1
902         boostersBought = boostersBought.add(1);
903 
904         // if no. of boosters exceed threshold, increase booster price by boostScaleFactor
905         // for each exceeded booster
906         if (boostersBought >= boostThreshold) {
907             boosterPrice = boosterPrice
908                 .mul((boostersBought.sub(boostThreshold)).mul(boostScaleFactor).add(100))
909                 .div(100);
910         }
911 
912         // 2.5% decrease for every 2 hour interval since last global boost purchase
913         boosterPrice = calculateBoostDevaluation(boosterPrice, 975, 1000, (block.timestamp.sub(lastBoostPurchase)).div(2 hours));
914 
915         // adjust price based on expected increase in boost supply
916         // each booster will increase balance in an order of 5%
917         // boostersBought has been incremented by 1 already
918         newBoostBalance = balanceOf(user)
919             .mul(boostersBought.mul(5).add(100))
920             .div(100);
921         uint256 boostBalanceIncrease = newBoostBalance.sub(boostedBalances[user]);
922         boosterPrice = boosterPrice
923             .mul(boostBalanceIncrease)
924             .mul(scaleFactor)
925             .div(boostedTotalSupply);
926     }
927 
928     // stake visibility is public as overriding LPTokenWrapper's stake() function
929     function stake(uint256 amount) public updateReward(msg.sender) override checkStart  {
930         require(amount != 0, "Cannot stake 0");
931         super.stake(amount);
932 
933         // check user cap
934         require(
935             balanceOf(msg.sender) <= tokenCapAmount || block.timestamp >= starttime.add(SECONDS_IN_A_DAY),
936             "token cap exceeded"
937         );
938 
939         // boosters do not affect new amounts
940         boostedBalances[msg.sender] = boostedBalances[msg.sender].add(amount);
941         boostedTotalSupply = boostedTotalSupply.add(amount);
942 
943         _getReward(msg.sender);
944 
945         // transfer token last, to follow CEI pattern
946         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
947     }
948 
949     function withdraw(uint256 amount) public updateReward(msg.sender) override checkStart {
950         require(amount != 0, "Cannot withdraw 0");
951         super.withdraw(amount);
952         
953         // reset boosts :(
954         numBoostersBought[msg.sender] = 0;
955 
956         // update boosted balance and supply
957         updateBoostBalanceAndSupply(msg.sender, 0);
958 
959         // in case _getReward function fails, continue
960         //(bool success, ) = address(this).call(
961         //    abi.encodeWithSignature(
962         //       "_getReward(address)",
963         //       msg.sender
964         //   )
965         //);
966         
967         // to remove compiler warning
968         //success;
969 
970         // transfer token last, to follow CEI pattern
971         stakeToken.safeTransfer(msg.sender, amount);
972     }
973 
974     function getReward() external updateReward(msg.sender) checkStart {
975         _getReward(msg.sender);
976     }
977 
978     function exit() external {
979         withdraw(balanceOf(msg.sender));
980     }
981 
982     function setScaleFactorsAndThreshold(
983         uint256 _boostThreshold,
984         uint256 _boostScaleFactor,
985         uint256 _scaleFactor
986     ) external onlyOwner
987     {
988         boostThreshold = _boostThreshold;
989         boostScaleFactor = _boostScaleFactor;
990         scaleFactor = _scaleFactor;
991     }
992     
993     function boost() external updateReward(msg.sender) checkStart {
994         require(
995             block.timestamp > nextBoostPurchaseTime[msg.sender],
996             "early boost purchase"
997         );
998 
999         // save current booster price, since transfer is done last
1000         // since getBoosterPrice() returns new boost balance, avoid re-calculation
1001         (uint256 boosterAmount, uint256 newBoostBalance) = getBoosterPrice(msg.sender);
1002         // user's balance and boostedSupply will be changed in this function
1003         applyBoost(msg.sender, newBoostBalance);
1004         
1005         _getReward(msg.sender);
1006 
1007         boostToken.safeTransferFrom(msg.sender, address(this), boosterAmount);
1008         
1009         IERC20Burnable burnableBoostToken = IERC20Burnable(address(boostToken));
1010 
1011         // burn 25%
1012         uint256 burnAmount = boosterAmount.div(4);
1013         burnableBoostToken.burn(burnAmount);
1014         boosterAmount = boosterAmount.sub(burnAmount);
1015         
1016         // swap to stablecoin
1017         address[] memory routeDetails = new address[](3);
1018         routeDetails[0] = address(boostToken);
1019         routeDetails[1] = swapRouter.WETH();
1020         routeDetails[2] = address(stablecoin);
1021         uint[] memory amounts = swapRouter.swapExactTokensForTokens(
1022             boosterAmount,
1023             0,
1024             routeDetails,
1025             address(this),
1026             block.timestamp + 100
1027         );
1028 
1029         // transfer to treasury
1030         // index 2 = final output amt
1031         treasury.deposit(stablecoin, amounts[2]);
1032     }
1033 
1034     function notifyRewardAmount(uint256 reward)
1035         external
1036         onlyOwner
1037         updateReward(address(0))
1038     {
1039         rewardRate = reward.div(duration);
1040         lastUpdateTime = starttime;
1041         periodFinish = starttime.add(duration);
1042         emit RewardAdded(reward);
1043     }
1044     
1045     function updateBoostBalanceAndSupply(address user, uint256 newBoostBalance) internal {
1046         // subtract existing balance from boostedSupply
1047         boostedTotalSupply = boostedTotalSupply.sub(boostedBalances[user]);
1048     
1049         // when applying boosts,
1050         // newBoostBalance has already been calculated in getBoosterPrice()
1051         if (newBoostBalance == 0) {
1052             // each booster adds 5% to current stake amount, that is 1 booster means 5%,
1053             // two boosters mean 10% and so on
1054             newBoostBalance = balanceOf(user).mul(numBoostersBought[user].mul(5).add(100)).div(100);
1055         }
1056 
1057         // update user's boosted balance
1058         boostedBalances[user] = newBoostBalance;
1059     
1060         // update boostedSupply
1061         boostedTotalSupply = boostedTotalSupply.add(newBoostBalance);
1062     }
1063 
1064     function applyBoost(address user, uint256 newBoostBalance) internal {
1065         // increase no. of boosters bought
1066         numBoostersBought[user] = numBoostersBought[user].add(1);
1067 
1068         updateBoostBalanceAndSupply(user, newBoostBalance);
1069         
1070         // increase next purchase eligibility by an hour
1071         nextBoostPurchaseTime[user] = block.timestamp.add(3600);
1072 
1073         // increase global booster price by 1%
1074         globalBoosterPrice = globalBoosterPrice.mul(101).div(100);
1075 
1076         lastBoostPurchase = block.timestamp;
1077     }
1078 
1079     function _getReward(address user) internal {
1080         uint256 reward = earned(user);
1081         if (reward != 0) {
1082             rewards[user] = 0;
1083             emit RewardPaid(user, reward);
1084             rewardToken.safeTransfer(user, reward);
1085         }
1086     }
1087 
1088     /// Imported from: https://forum.openzeppelin.com/t/does-safemath-library-need-a-safe-power-function/871/7
1089    /// Modified so that it takes in 3 arguments for base
1090    /// @return the eventually newly calculated boost price
1091    function calculateBoostDevaluation(uint256 a, uint256 b, uint256 c, uint256 exponent) internal pure returns (uint256) {
1092         if (exponent == 0) {
1093             return a;
1094         }
1095         else if (exponent == 1) {
1096             return a.mul(b).div(c);
1097         }
1098         else if (a == 0 && exponent != 0) {
1099             return 0;
1100         }
1101         else {
1102             uint256 z = a.mul(b).div(c);
1103             for (uint256 i = 1; i < exponent; i++)
1104                 z = z.mul(b).div(c);
1105             return z;
1106         }
1107     }
1108 }