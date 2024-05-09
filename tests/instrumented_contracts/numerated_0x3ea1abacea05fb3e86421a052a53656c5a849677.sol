1 // File: contracts/token/ERC677Receiver.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity ^0.6.0;
5 
6 abstract contract ERC677Receiver {
7   function onTokenTransfer(address _sender, uint _value, bytes memory _data) public virtual;
8 }
9 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/GSN/Context.sol
10 
11 pragma solidity >=0.6.0 <0.8.0;
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/access/Ownable.sol
35 
36 pragma solidity >=0.6.0 <0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor () internal {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         emit OwnershipTransferred(_owner, newOwner);
98         _owner = newOwner;
99     }
100 }
101 
102 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/IERC20.sol
103 
104 pragma solidity >=0.6.0 <0.8.0;
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/SafeERC20.sol
181 
182 pragma solidity >=0.6.0 <0.8.0;
183 
184 
185 
186 
187 /**
188  * @title SafeERC20
189  * @dev Wrappers around ERC20 operations that throw on failure (when the token
190  * contract returns false). Tokens that return no value (and instead revert or
191  * throw on failure) are also supported, non-reverting calls are assumed to be
192  * successful.
193  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
194  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
195  */
196 library SafeERC20 {
197     using SafeMath for uint256;
198     using Address for address;
199 
200     function safeTransfer(IERC20 token, address to, uint256 value) internal {
201         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
202     }
203 
204     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
205         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
206     }
207 
208     /**
209      * @dev Deprecated. This function has issues similar to the ones found in
210      * {IERC20-approve}, and its usage is discouraged.
211      *
212      * Whenever possible, use {safeIncreaseAllowance} and
213      * {safeDecreaseAllowance} instead.
214      */
215     function safeApprove(IERC20 token, address spender, uint256 value) internal {
216         // safeApprove should only be called when setting an initial allowance,
217         // or when resetting it to zero. To increase and decrease it, use
218         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
219         // solhint-disable-next-line max-line-length
220         require((value == 0) || (token.allowance(address(this), spender) == 0),
221             "SafeERC20: approve from non-zero to non-zero allowance"
222         );
223         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
224     }
225 
226     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
227         uint256 newAllowance = token.allowance(address(this), spender).add(value);
228         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
229     }
230 
231     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
232         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
233         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
234     }
235 
236     /**
237      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
238      * on the return value: the return value is optional (but if data is returned, it must not be false).
239      * @param token The token targeted by the call.
240      * @param data The call data (encoded using abi.encode or one of its variants).
241      */
242     function _callOptionalReturn(IERC20 token, bytes memory data) private {
243         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
244         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
245         // the target address contains contract code and also asserts for success in the low-level call.
246 
247         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
248         if (returndata.length > 0) { // Return data is optional
249             // solhint-disable-next-line max-line-length
250             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
251         }
252     }
253 }
254 
255 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/utils/Address.sol
256 
257 pragma solidity >=0.6.2 <0.8.0;
258 
259 /**
260  * @dev Collection of functions related to the address type
261  */
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // This method relies on extcodesize, which returns 0 for contracts in
282         // construction, since the code is only stored at the end of the
283         // constructor execution.
284 
285         uint256 size;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { size := extcodesize(account) }
288         return size > 0;
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level `call`. A
317      * plain`call` is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If `target` reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325      *
326      * Requirements:
327      *
328      * - `target` must be a contract.
329      * - calling `target` with `data` must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334       return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         require(isContract(target), "Address: call to non-contract");
371 
372         // solhint-disable-next-line avoid-low-level-calls
373         (bool success, bytes memory returndata) = target.call{ value: value }(data);
374         return _verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
384         return functionStaticCall(target, data, "Address: low-level static call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
389      * but performing a static call.
390      *
391      * _Available since v3.3._
392      */
393     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
394         require(isContract(target), "Address: static call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.staticcall(data);
398         return _verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
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
421 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/math/SafeMath.sol
422 
423 pragma solidity >=0.6.0 <0.8.0;
424 
425 /**
426  * @dev Wrappers over Solidity's arithmetic operations with added overflow
427  * checks.
428  *
429  * Arithmetic operations in Solidity wrap on overflow. This can easily result
430  * in bugs, because programmers usually assume that an overflow raises an
431  * error, which is the standard behavior in high level programming languages.
432  * `SafeMath` restores this intuition by reverting the transaction when an
433  * operation overflows.
434  *
435  * Using this library instead of the unchecked operations eliminates an entire
436  * class of bugs, so it's recommended to use it always.
437  */
438 library SafeMath {
439     /**
440      * @dev Returns the addition of two unsigned integers, reverting on
441      * overflow.
442      *
443      * Counterpart to Solidity's `+` operator.
444      *
445      * Requirements:
446      *
447      * - Addition cannot overflow.
448      */
449     function add(uint256 a, uint256 b) internal pure returns (uint256) {
450         uint256 c = a + b;
451         require(c >= a, "SafeMath: addition overflow");
452 
453         return c;
454     }
455 
456     /**
457      * @dev Returns the subtraction of two unsigned integers, reverting on
458      * overflow (when the result is negative).
459      *
460      * Counterpart to Solidity's `-` operator.
461      *
462      * Requirements:
463      *
464      * - Subtraction cannot overflow.
465      */
466     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
467         return sub(a, b, "SafeMath: subtraction overflow");
468     }
469 
470     /**
471      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
472      * overflow (when the result is negative).
473      *
474      * Counterpart to Solidity's `-` operator.
475      *
476      * Requirements:
477      *
478      * - Subtraction cannot overflow.
479      */
480     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
481         require(b <= a, errorMessage);
482         uint256 c = a - b;
483 
484         return c;
485     }
486 
487     /**
488      * @dev Returns the multiplication of two unsigned integers, reverting on
489      * overflow.
490      *
491      * Counterpart to Solidity's `*` operator.
492      *
493      * Requirements:
494      *
495      * - Multiplication cannot overflow.
496      */
497     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
498         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
499         // benefit is lost if 'b' is also tested.
500         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
501         if (a == 0) {
502             return 0;
503         }
504 
505         uint256 c = a * b;
506         require(c / a == b, "SafeMath: multiplication overflow");
507 
508         return c;
509     }
510 
511     /**
512      * @dev Returns the integer division of two unsigned integers. Reverts on
513      * division by zero. The result is rounded towards zero.
514      *
515      * Counterpart to Solidity's `/` operator. Note: this function uses a
516      * `revert` opcode (which leaves remaining gas untouched) while Solidity
517      * uses an invalid opcode to revert (consuming all remaining gas).
518      *
519      * Requirements:
520      *
521      * - The divisor cannot be zero.
522      */
523     function div(uint256 a, uint256 b) internal pure returns (uint256) {
524         return div(a, b, "SafeMath: division by zero");
525     }
526 
527     /**
528      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
529      * division by zero. The result is rounded towards zero.
530      *
531      * Counterpart to Solidity's `/` operator. Note: this function uses a
532      * `revert` opcode (which leaves remaining gas untouched) while Solidity
533      * uses an invalid opcode to revert (consuming all remaining gas).
534      *
535      * Requirements:
536      *
537      * - The divisor cannot be zero.
538      */
539     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
540         require(b > 0, errorMessage);
541         uint256 c = a / b;
542         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
543 
544         return c;
545     }
546 
547     /**
548      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
549      * Reverts when dividing by zero.
550      *
551      * Counterpart to Solidity's `%` operator. This function uses a `revert`
552      * opcode (which leaves remaining gas untouched) while Solidity uses an
553      * invalid opcode to revert (consuming all remaining gas).
554      *
555      * Requirements:
556      *
557      * - The divisor cannot be zero.
558      */
559     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
560         return mod(a, b, "SafeMath: modulo by zero");
561     }
562 
563     /**
564      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
565      * Reverts with custom message when dividing by zero.
566      *
567      * Counterpart to Solidity's `%` operator. This function uses a `revert`
568      * opcode (which leaves remaining gas untouched) while Solidity uses an
569      * invalid opcode to revert (consuming all remaining gas).
570      *
571      * Requirements:
572      *
573      * - The divisor cannot be zero.
574      */
575     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
576         require(b != 0, errorMessage);
577         return a % b;
578     }
579 }
580 
581 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/math/Math.sol
582 
583 pragma solidity >=0.6.0 <0.8.0;
584 
585 /**
586  * @dev Standard math utilities missing in the Solidity language.
587  */
588 library Math {
589     /**
590      * @dev Returns the largest of two numbers.
591      */
592     function max(uint256 a, uint256 b) internal pure returns (uint256) {
593         return a >= b ? a : b;
594     }
595 
596     /**
597      * @dev Returns the smallest of two numbers.
598      */
599     function min(uint256 a, uint256 b) internal pure returns (uint256) {
600         return a < b ? a : b;
601     }
602 
603     /**
604      * @dev Returns the average of two numbers. The result is rounded towards
605      * zero.
606      */
607     function average(uint256 a, uint256 b) internal pure returns (uint256) {
608         // (a + b) / 2 can overflow, so we distribute
609         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
610     }
611 }
612 
613 // File: contracts/bios_slp_rewards.sol
614 
615 /*
616 *
617 * 0x_nodes pre-initialization for _KERNEL
618 * REWARDS in USDT for BIOS/wETH and BIOS
619 * forked from: Synthetix: CurveRewards.sol
620 *
621 * 0x_nodes: https://0xnodes.io
622 * twitter: https://twitter.com/0x_nodes
623 *
624 * 
625 * MIT License
626 * ===========
627 *
628 * Copyright (c) 2020 0x_nodes
629 *
630 * Permission is hereby granted, free of charge, to any person obtaining a copy
631 * of this software and associated documentation files (the "Software"), to deal
632 * in the Software without restriction, including without limitation the rights
633 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
634 * copies of the Software, and to permit persons to whom the Software is
635 * furnished to do so, subject to the following conditions:
636 *
637 * The above copyright notice and this permission notice shall be included in all
638 * copies or substantial portions of the Software.
639 *
640 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
641 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
642 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
643 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
644 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
645 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
646 */
647 
648 pragma solidity 0.6.12;
649 
650 
651 
652 
653 
654 
655 
656 
657 abstract contract IRewardDistributionRecipient is Ownable {
658     address public rewardDistribution;
659 
660     function notifyRewardAmount(uint256 reward) external virtual;
661 
662     modifier onlyRewardDistribution() {
663         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
664         _;
665     }
666 
667     function setRewardDistribution(address _rewardDistribution)
668         external
669         onlyOwner
670     {
671         rewardDistribution = _rewardDistribution;
672     }
673 }
674 
675 contract LPTokenWrapper {
676     using SafeMath for uint256;
677     using SafeERC20 for IERC20;
678 
679     IERC20 public immutable stakingToken;
680 
681     uint256 private _totalSupply;
682     mapping(address => uint256) private _balances;
683 
684     constructor(
685         address _stakingToken
686     )
687         public
688     {
689         stakingToken = IERC20(_stakingToken);
690     }
691 
692     function totalSupply() public view returns (uint256) {
693         return _totalSupply;
694     }
695 
696     function balanceOf(address account) public view returns (uint256) {
697         return _balances[account];
698     }
699 
700     function stake(uint256 amount) public virtual {
701         _totalSupply = _totalSupply.add(amount);
702         _balances[msg.sender] = _balances[msg.sender].add(amount);
703         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
704     }
705 
706     function stakeFor(address account, uint256 amount) internal {
707         _totalSupply = _totalSupply.add(amount);
708         _balances[account] = _balances[account].add(amount);
709         // we don't transferFrom here because this is only triggered
710         // when tokens have already been received
711     }
712 
713     function withdraw(uint256 amount) public virtual {
714         _totalSupply = _totalSupply.sub(amount);
715         _balances[msg.sender] = _balances[msg.sender].sub(amount);
716         stakingToken.safeTransfer(msg.sender, amount);
717     }
718 }
719 
720 contract BiosSlpRewards is LPTokenWrapper, IRewardDistributionRecipient, ERC677Receiver {
721     IERC20 public immutable rewardToken;
722     uint256 public immutable duration;
723 
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
736     constructor(
737         address _rewardToken,
738         address _stakingToken,
739         uint256 _duration
740     )
741         public
742         LPTokenWrapper(_stakingToken)
743     {
744         rewardToken = IERC20(_rewardToken);
745         duration = _duration;
746     }
747 
748     modifier updateReward(address account) {
749         rewardPerTokenStored = rewardPerToken();
750         lastUpdateTime = lastTimeRewardApplicable();
751         if (account != address(0)) {
752             rewards[account] = earned(account);
753             userRewardPerTokenPaid[account] = rewardPerTokenStored;
754         }
755         _;
756     }
757 
758     function onTokenTransfer(address sender, uint256 amount, bytes memory)
759         public override updateReward(sender)
760     {
761         require(msg.sender == address(stakingToken), "!stakingToken");
762         super.stakeFor(sender, amount);
763         emit Staked(sender, amount);
764     }
765 
766     function lastTimeRewardApplicable() public view returns (uint256) {
767         return Math.min(block.timestamp, periodFinish);
768     }
769 
770     function rewardPerToken() public view returns (uint256) {
771         if (totalSupply() == 0) {
772             return rewardPerTokenStored;
773         }
774         return
775             rewardPerTokenStored.add(
776                 lastTimeRewardApplicable()
777                     .sub(lastUpdateTime)
778                     .mul(rewardRate)
779                     .mul(1e18)
780                     .div(totalSupply())
781             );
782     }
783 
784     function earned(address account) public view returns (uint256) {
785         return
786             balanceOf(account)
787                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
788                 .div(1e18)
789                 .add(rewards[account]);
790     }
791 
792     // stake visibility is public as overriding LPTokenWrapper's stake() function
793     function stake(uint256 amount) public override updateReward(msg.sender) {
794         require(amount > 0, "Cannot stake 0");
795         super.stake(amount);
796         emit Staked(msg.sender, amount);
797     }
798 
799     function withdraw(uint256 amount) public override updateReward(msg.sender) {
800         require(amount > 0, "Cannot withdraw 0");
801         super.withdraw(amount);
802         emit Withdrawn(msg.sender, amount);
803     }
804 
805     function exit() external {
806         withdraw(balanceOf(msg.sender));
807         getReward();
808     }
809 
810     function getReward() public updateReward(msg.sender) {
811         uint256 reward = earned(msg.sender);
812         if (reward > 0) {
813             rewards[msg.sender] = 0;
814             rewardToken.safeTransfer(msg.sender, reward);
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
825         if (block.timestamp >= periodFinish) {
826             rewardRate = reward.div(duration);
827         } else {
828             uint256 remaining = periodFinish.sub(block.timestamp);
829             uint256 leftover = remaining.mul(rewardRate);
830             rewardRate = reward.add(leftover).div(duration);
831         }
832         lastUpdateTime = block.timestamp;
833         periodFinish = block.timestamp.add(duration);
834         emit RewardAdded(reward);
835     }
836 }