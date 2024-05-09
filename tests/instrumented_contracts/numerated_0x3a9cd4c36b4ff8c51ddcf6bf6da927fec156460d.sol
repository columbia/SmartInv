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
11 
12 pragma solidity >=0.6.0 <0.8.0;
13 
14 /*
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with GSN meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/access/Ownable.sol
36 
37 pragma solidity >=0.6.0 <0.8.0;
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor () internal {
60         address msgSender = _msgSender();
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64 
65     /**
66      * @dev Returns the address of the current owner.
67      */
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 
103 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/IERC20.sol
104 
105 pragma solidity >=0.6.0 <0.8.0;
106 
107 /**
108  * @dev Interface of the ERC20 standard as defined in the EIP.
109  */
110 interface IERC20 {
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `recipient`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `sender` to `recipient` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/SafeERC20.sol
182 
183 pragma solidity >=0.6.0 <0.8.0;
184 
185 
186 
187 
188 /**
189  * @title SafeERC20
190  * @dev Wrappers around ERC20 operations that throw on failure (when the token
191  * contract returns false). Tokens that return no value (and instead revert or
192  * throw on failure) are also supported, non-reverting calls are assumed to be
193  * successful.
194  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
195  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
196  */
197 library SafeERC20 {
198     using SafeMath for uint256;
199     using Address for address;
200 
201     function safeTransfer(IERC20 token, address to, uint256 value) internal {
202         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
203     }
204 
205     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
206         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
207     }
208 
209     /**
210      * @dev Deprecated. This function has issues similar to the ones found in
211      * {IERC20-approve}, and its usage is discouraged.
212      *
213      * Whenever possible, use {safeIncreaseAllowance} and
214      * {safeDecreaseAllowance} instead.
215      */
216     function safeApprove(IERC20 token, address spender, uint256 value) internal {
217         // safeApprove should only be called when setting an initial allowance,
218         // or when resetting it to zero. To increase and decrease it, use
219         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
220         // solhint-disable-next-line max-line-length
221         require((value == 0) || (token.allowance(address(this), spender) == 0),
222             "SafeERC20: approve from non-zero to non-zero allowance"
223         );
224         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
225     }
226 
227     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
228         uint256 newAllowance = token.allowance(address(this), spender).add(value);
229         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
230     }
231 
232     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
233         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
234         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
235     }
236 
237     /**
238      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
239      * on the return value: the return value is optional (but if data is returned, it must not be false).
240      * @param token The token targeted by the call.
241      * @param data The call data (encoded using abi.encode or one of its variants).
242      */
243     function _callOptionalReturn(IERC20 token, bytes memory data) private {
244         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
245         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
246         // the target address contains contract code and also asserts for success in the low-level call.
247 
248         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
249         if (returndata.length > 0) { // Return data is optional
250             // solhint-disable-next-line max-line-length
251             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
252         }
253     }
254 }
255 
256 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/utils/Address.sol
257 
258 pragma solidity >=0.6.2 <0.8.0;
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // This method relies on extcodesize, which returns 0 for contracts in
283         // construction, since the code is only stored at the end of the
284         // constructor execution.
285 
286         uint256 size;
287         // solhint-disable-next-line no-inline-assembly
288         assembly { size := extcodesize(account) }
289         return size > 0;
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
312         (bool success, ) = recipient.call{ value: amount }("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain`call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335       return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
370         require(address(this).balance >= value, "Address: insufficient balance for call");
371         require(isContract(target), "Address: call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = target.call{ value: value }(data);
375         return _verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
385         return functionStaticCall(target, data, "Address: low-level static call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
395         require(isContract(target), "Address: static call to non-contract");
396 
397         // solhint-disable-next-line avoid-low-level-calls
398         (bool success, bytes memory returndata) = target.staticcall(data);
399         return _verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
403         if (success) {
404             return returndata;
405         } else {
406             // Look for revert reason and bubble it up if present
407             if (returndata.length > 0) {
408                 // The easiest way to bubble the revert reason is using memory via assembly
409 
410                 // solhint-disable-next-line no-inline-assembly
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/math/SafeMath.sol
423 
424 pragma solidity >=0.6.0 <0.8.0;
425 
426 /**
427  * @dev Wrappers over Solidity's arithmetic operations with added overflow
428  * checks.
429  *
430  * Arithmetic operations in Solidity wrap on overflow. This can easily result
431  * in bugs, because programmers usually assume that an overflow raises an
432  * error, which is the standard behavior in high level programming languages.
433  * `SafeMath` restores this intuition by reverting the transaction when an
434  * operation overflows.
435  *
436  * Using this library instead of the unchecked operations eliminates an entire
437  * class of bugs, so it's recommended to use it always.
438  */
439 library SafeMath {
440     /**
441      * @dev Returns the addition of two unsigned integers, reverting on
442      * overflow.
443      *
444      * Counterpart to Solidity's `+` operator.
445      *
446      * Requirements:
447      *
448      * - Addition cannot overflow.
449      */
450     function add(uint256 a, uint256 b) internal pure returns (uint256) {
451         uint256 c = a + b;
452         require(c >= a, "SafeMath: addition overflow");
453 
454         return c;
455     }
456 
457     /**
458      * @dev Returns the subtraction of two unsigned integers, reverting on
459      * overflow (when the result is negative).
460      *
461      * Counterpart to Solidity's `-` operator.
462      *
463      * Requirements:
464      *
465      * - Subtraction cannot overflow.
466      */
467     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
468         return sub(a, b, "SafeMath: subtraction overflow");
469     }
470 
471     /**
472      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
473      * overflow (when the result is negative).
474      *
475      * Counterpart to Solidity's `-` operator.
476      *
477      * Requirements:
478      *
479      * - Subtraction cannot overflow.
480      */
481     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
482         require(b <= a, errorMessage);
483         uint256 c = a - b;
484 
485         return c;
486     }
487 
488     /**
489      * @dev Returns the multiplication of two unsigned integers, reverting on
490      * overflow.
491      *
492      * Counterpart to Solidity's `*` operator.
493      *
494      * Requirements:
495      *
496      * - Multiplication cannot overflow.
497      */
498     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
499         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
500         // benefit is lost if 'b' is also tested.
501         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
502         if (a == 0) {
503             return 0;
504         }
505 
506         uint256 c = a * b;
507         require(c / a == b, "SafeMath: multiplication overflow");
508 
509         return c;
510     }
511 
512     /**
513      * @dev Returns the integer division of two unsigned integers. Reverts on
514      * division by zero. The result is rounded towards zero.
515      *
516      * Counterpart to Solidity's `/` operator. Note: this function uses a
517      * `revert` opcode (which leaves remaining gas untouched) while Solidity
518      * uses an invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function div(uint256 a, uint256 b) internal pure returns (uint256) {
525         return div(a, b, "SafeMath: division by zero");
526     }
527 
528     /**
529      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
530      * division by zero. The result is rounded towards zero.
531      *
532      * Counterpart to Solidity's `/` operator. Note: this function uses a
533      * `revert` opcode (which leaves remaining gas untouched) while Solidity
534      * uses an invalid opcode to revert (consuming all remaining gas).
535      *
536      * Requirements:
537      *
538      * - The divisor cannot be zero.
539      */
540     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
541         require(b > 0, errorMessage);
542         uint256 c = a / b;
543         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
544 
545         return c;
546     }
547 
548     /**
549      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
550      * Reverts when dividing by zero.
551      *
552      * Counterpart to Solidity's `%` operator. This function uses a `revert`
553      * opcode (which leaves remaining gas untouched) while Solidity uses an
554      * invalid opcode to revert (consuming all remaining gas).
555      *
556      * Requirements:
557      *
558      * - The divisor cannot be zero.
559      */
560     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
561         return mod(a, b, "SafeMath: modulo by zero");
562     }
563 
564     /**
565      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
566      * Reverts with custom message when dividing by zero.
567      *
568      * Counterpart to Solidity's `%` operator. This function uses a `revert`
569      * opcode (which leaves remaining gas untouched) while Solidity uses an
570      * invalid opcode to revert (consuming all remaining gas).
571      *
572      * Requirements:
573      *
574      * - The divisor cannot be zero.
575      */
576     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
577         require(b != 0, errorMessage);
578         return a % b;
579     }
580 }
581 
582 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/math/Math.sol
583 
584 pragma solidity >=0.6.0 <0.8.0;
585 
586 /**
587  * @dev Standard math utilities missing in the Solidity language.
588  */
589 library Math {
590     /**
591      * @dev Returns the largest of two numbers.
592      */
593     function max(uint256 a, uint256 b) internal pure returns (uint256) {
594         return a >= b ? a : b;
595     }
596 
597     /**
598      * @dev Returns the smallest of two numbers.
599      */
600     function min(uint256 a, uint256 b) internal pure returns (uint256) {
601         return a < b ? a : b;
602     }
603 
604     /**
605      * @dev Returns the average of two numbers. The result is rounded towards
606      * zero.
607      */
608     function average(uint256 a, uint256 b) internal pure returns (uint256) {
609         // (a + b) / 2 can overflow, so we distribute
610         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
611     }
612 }
613 
614 // File: contracts/bios_rewards.sol
615 
616 /*
617 *
618 * 0x_nodes pre-initialization for _KERNEL
619 * REWARDS in USDT for BIOS/wETH and BIOS
620 * forked from: Synthetix: CurveRewards.sol
621 *
622 * 0x_nodes: https://0xnodes.io
623 * twitter: https://twitter.com/0x_nodes
624 *
625 * 
626 * MIT License
627 * ===========
628 *
629 * Copyright (c) 2020 0x_nodes
630 *
631 * Permission is hereby granted, free of charge, to any person obtaining a copy
632 * of this software and associated documentation files (the "Software"), to deal
633 * in the Software without restriction, including without limitation the rights
634 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
635 * copies of the Software, and to permit persons to whom the Software is
636 * furnished to do so, subject to the following conditions:
637 *
638 * The above copyright notice and this permission notice shall be included in all
639 * copies or substantial portions of the Software.
640 *
641 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
642 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
643 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
644 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
645 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
646 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
647 */
648 
649 pragma solidity 0.6.12;
650 
651 
652 
653 
654 
655 
656 
657 
658 abstract contract IRewardDistributionRecipient is Ownable {
659     address public rewardDistribution;
660 
661     function notifyRewardAmount(uint256 reward) external virtual;
662 
663     modifier onlyRewardDistribution() {
664         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
665         _;
666     }
667 
668     function setRewardDistribution(address _rewardDistribution)
669         external
670         onlyOwner
671     {
672         rewardDistribution = _rewardDistribution;
673     }
674 }
675 
676 contract LPTokenWrapper {
677     using SafeMath for uint256;
678     using SafeERC20 for IERC20;
679 
680     IERC20 public immutable stakingToken;
681 
682     uint256 private _totalSupply;
683     mapping(address => uint256) private _balances;
684 
685     constructor(
686         address _stakingToken
687     )
688         public
689     {
690         stakingToken = IERC20(_stakingToken);
691     }
692 
693     function totalSupply() public view returns (uint256) {
694         return _totalSupply;
695     }
696 
697     function balanceOf(address account) public view returns (uint256) {
698         return _balances[account];
699     }
700 
701     function stake(uint256 amount) public virtual {
702         _totalSupply = _totalSupply.add(amount);
703         _balances[msg.sender] = _balances[msg.sender].add(amount);
704         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
705     }
706 
707     function stakeFor(address account, uint256 amount) internal {
708         _totalSupply = _totalSupply.add(amount);
709         _balances[account] = _balances[account].add(amount);
710         // we don't transferFrom here because this is only triggered
711         // when tokens have already been received
712     }
713 
714     function withdraw(uint256 amount) public virtual {
715         _totalSupply = _totalSupply.sub(amount);
716         _balances[msg.sender] = _balances[msg.sender].sub(amount);
717         stakingToken.safeTransfer(msg.sender, amount);
718     }
719 }
720 
721 contract BiosRewards is LPTokenWrapper, IRewardDistributionRecipient, ERC677Receiver {
722     IERC20 public immutable rewardToken;
723     uint256 public immutable duration;
724 
725     uint256 public periodFinish = 0;
726     uint256 public rewardRate = 0;
727     uint256 public lastUpdateTime;
728     uint256 public rewardPerTokenStored;
729     mapping(address => uint256) public userRewardPerTokenPaid;
730     mapping(address => uint256) public rewards;
731 
732     event RewardAdded(uint256 reward);
733     event Staked(address indexed user, uint256 amount);
734     event Withdrawn(address indexed user, uint256 amount);
735     event RewardPaid(address indexed user, uint256 reward);
736 
737     constructor(
738         address _rewardToken,
739         address _stakingToken,
740         uint256 _duration
741     )
742         public
743         LPTokenWrapper(_stakingToken)
744     {
745         rewardToken = IERC20(_rewardToken);
746         duration = _duration;
747     }
748 
749     modifier updateReward(address account) {
750         rewardPerTokenStored = rewardPerToken();
751         lastUpdateTime = lastTimeRewardApplicable();
752         if (account != address(0)) {
753             rewards[account] = earned(account);
754             userRewardPerTokenPaid[account] = rewardPerTokenStored;
755         }
756         _;
757     }
758 
759     function onTokenTransfer(address sender, uint256 amount, bytes memory)
760         public override updateReward(sender)
761     {
762         require(msg.sender == address(stakingToken), "!stakingToken");
763         super.stakeFor(sender, amount);
764         emit Staked(sender, amount);
765     }
766 
767     function lastTimeRewardApplicable() public view returns (uint256) {
768         return Math.min(block.timestamp, periodFinish);
769     }
770 
771     function rewardPerToken() public view returns (uint256) {
772         if (totalSupply() == 0) {
773             return rewardPerTokenStored;
774         }
775         return
776             rewardPerTokenStored.add(
777                 lastTimeRewardApplicable()
778                     .sub(lastUpdateTime)
779                     .mul(rewardRate)
780                     .mul(1e18)
781                     .div(totalSupply())
782             );
783     }
784 
785     function earned(address account) public view returns (uint256) {
786         return
787             balanceOf(account)
788                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
789                 .div(1e18)
790                 .add(rewards[account]);
791     }
792 
793     // stake visibility is public as overriding LPTokenWrapper's stake() function
794     function stake(uint256 amount) public override updateReward(msg.sender) {
795         require(amount > 0, "Cannot stake 0");
796         super.stake(amount);
797         emit Staked(msg.sender, amount);
798     }
799 
800     function withdraw(uint256 amount) public override updateReward(msg.sender) {
801         require(amount > 0, "Cannot withdraw 0");
802         super.withdraw(amount);
803         emit Withdrawn(msg.sender, amount);
804     }
805 
806     function exit() external {
807         withdraw(balanceOf(msg.sender));
808         getReward();
809     }
810 
811     function getReward() public updateReward(msg.sender) {
812         uint256 reward = earned(msg.sender);
813         if (reward > 0) {
814             rewards[msg.sender] = 0;
815             rewardToken.safeTransfer(msg.sender, reward);
816             emit RewardPaid(msg.sender, reward);
817         }
818     }
819 
820     function notifyRewardAmount(uint256 reward)
821         external
822         override
823         onlyRewardDistribution
824         updateReward(address(0))
825     {
826         if (block.timestamp >= periodFinish) {
827             rewardRate = reward.div(duration);
828         } else {
829             uint256 remaining = periodFinish.sub(block.timestamp);
830             uint256 leftover = remaining.mul(rewardRate);
831             rewardRate = reward.add(leftover).div(duration);
832         }
833         lastUpdateTime = block.timestamp;
834         periodFinish = block.timestamp.add(duration);
835         emit RewardAdded(reward);
836     }
837 }