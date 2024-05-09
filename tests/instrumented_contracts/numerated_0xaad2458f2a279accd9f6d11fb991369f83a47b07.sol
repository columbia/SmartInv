1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 pragma solidity >=0.6.0 <0.8.0;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, with an overflow flag.
101      *
102      * _Available since v3.4._
103      */
104     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         uint256 c = a + b;
106         if (c < a) return (false, 0);
107         return (true, c);
108     }
109 
110     /**
111      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
112      *
113      * _Available since v3.4._
114      */
115     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
116         if (b > a) return (false, 0);
117         return (true, a - b);
118     }
119 
120     /**
121      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
122      *
123      * _Available since v3.4._
124      */
125     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127         // benefit is lost if 'b' is also tested.
128         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
129         if (a == 0) return (true, 0);
130         uint256 c = a * b;
131         if (c / a != b) return (false, 0);
132         return (true, c);
133     }
134 
135     /**
136      * @dev Returns the division of two unsigned integers, with a division by zero flag.
137      *
138      * _Available since v3.4._
139      */
140     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         if (b == 0) return (false, 0);
142         return (true, a / b);
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         if (b == 0) return (false, 0);
152         return (true, a % b);
153     }
154 
155     /**
156      * @dev Returns the addition of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `+` operator.
160      *
161      * Requirements:
162      *
163      * - Addition cannot overflow.
164      */
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         uint256 c = a + b;
167         require(c >= a, "SafeMath: addition overflow");
168         return c;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      *
179      * - Subtraction cannot overflow.
180      */
181     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182         require(b <= a, "SafeMath: subtraction overflow");
183         return a - b;
184     }
185 
186     /**
187      * @dev Returns the multiplication of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `*` operator.
191      *
192      * Requirements:
193      *
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         if (a == 0) return 0;
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers, reverting on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         require(b > 0, "SafeMath: division by zero");
217         return a / b;
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * reverting when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         require(b > 0, "SafeMath: modulo by zero");
234         return a % b;
235     }
236 
237     /**
238      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
239      * overflow (when the result is negative).
240      *
241      * CAUTION: This function is deprecated because it requires allocating memory for the error
242      * message unnecessarily. For custom revert reasons use {trySub}.
243      *
244      * Counterpart to Solidity's `-` operator.
245      *
246      * Requirements:
247      *
248      * - Subtraction cannot overflow.
249      */
250     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b <= a, errorMessage);
252         return a - b;
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
257      * division by zero. The result is rounded towards zero.
258      *
259      * CAUTION: This function is deprecated because it requires allocating memory for the error
260      * message unnecessarily. For custom revert reasons use {tryDiv}.
261      *
262      * Counterpart to Solidity's `/` operator. Note: this function uses a
263      * `revert` opcode (which leaves remaining gas untouched) while Solidity
264      * uses an invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271         require(b > 0, errorMessage);
272         return a / b;
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
277      * reverting with custom message when dividing by zero.
278      *
279      * CAUTION: This function is deprecated because it requires allocating memory for the error
280      * message unnecessarily. For custom revert reasons use {tryMod}.
281      *
282      * Counterpart to Solidity's `%` operator. This function uses a `revert`
283      * opcode (which leaves remaining gas untouched) while Solidity uses an
284      * invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      *
288      * - The divisor cannot be zero.
289      */
290     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
291         require(b > 0, errorMessage);
292         return a % b;
293     }
294 }
295 
296 // File: @openzeppelin/contracts/utils/Address.sol
297 
298 pragma solidity >=0.6.2 <0.8.0;
299 
300 /**
301  * @dev Collection of functions related to the address type
302  */
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      */
321     function isContract(address account) internal view returns (bool) {
322         // This method relies on extcodesize, which returns 0 for contracts in
323         // construction, since the code is only stored at the end of the
324         // constructor execution.
325 
326         uint256 size;
327         // solhint-disable-next-line no-inline-assembly
328         assembly { size := extcodesize(account) }
329         return size > 0;
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350 
351         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
352         (bool success, ) = recipient.call{ value: amount }("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain`call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375       return functionCall(target, data, "Address: low-level call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
405      * with `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
410         require(address(this).balance >= value, "Address: insufficient balance for call");
411         require(isContract(target), "Address: call to non-contract");
412 
413         // solhint-disable-next-line avoid-low-level-calls
414         (bool success, bytes memory returndata) = target.call{ value: value }(data);
415         return _verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but performing a static call.
421      *
422      * _Available since v3.3._
423      */
424     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
425         return functionStaticCall(target, data, "Address: low-level static call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430      * but performing a static call.
431      *
432      * _Available since v3.3._
433      */
434     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
435         require(isContract(target), "Address: static call to non-contract");
436 
437         // solhint-disable-next-line avoid-low-level-calls
438         (bool success, bytes memory returndata) = target.staticcall(data);
439         return _verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         // solhint-disable-next-line avoid-low-level-calls
462         (bool success, bytes memory returndata) = target.delegatecall(data);
463         return _verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
467         if (success) {
468             return returndata;
469         } else {
470             // Look for revert reason and bubble it up if present
471             if (returndata.length > 0) {
472                 // The easiest way to bubble the revert reason is using memory via assembly
473 
474                 // solhint-disable-next-line no-inline-assembly
475                 assembly {
476                     let returndata_size := mload(returndata)
477                     revert(add(32, returndata), returndata_size)
478                 }
479             } else {
480                 revert(errorMessage);
481             }
482         }
483     }
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
487 
488 
489 pragma solidity >=0.6.0 <0.8.0;
490 
491 /**
492  * @title SafeERC20
493  * @dev Wrappers around ERC20 operations that throw on failure (when the token
494  * contract returns false). Tokens that return no value (and instead revert or
495  * throw on failure) are also supported, non-reverting calls are assumed to be
496  * successful.
497  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
498  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
499  */
500 library SafeERC20 {
501     using SafeMath for uint256;
502     using Address for address;
503 
504     function safeTransfer(IERC20 token, address to, uint256 value) internal {
505         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
506     }
507 
508     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
509         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
510     }
511 
512     /**
513      * @dev Deprecated. This function has issues similar to the ones found in
514      * {IERC20-approve}, and its usage is discouraged.
515      *
516      * Whenever possible, use {safeIncreaseAllowance} and
517      * {safeDecreaseAllowance} instead.
518      */
519     function safeApprove(IERC20 token, address spender, uint256 value) internal {
520         // safeApprove should only be called when setting an initial allowance,
521         // or when resetting it to zero. To increase and decrease it, use
522         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
523         // solhint-disable-next-line max-line-length
524         require((value == 0) || (token.allowance(address(this), spender) == 0),
525             "SafeERC20: approve from non-zero to non-zero allowance"
526         );
527         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
528     }
529 
530     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).add(value);
532         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
533     }
534 
535     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
536         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
538     }
539 
540     /**
541      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
542      * on the return value: the return value is optional (but if data is returned, it must not be false).
543      * @param token The token targeted by the call.
544      * @param data The call data (encoded using abi.encode or one of its variants).
545      */
546     function _callOptionalReturn(IERC20 token, bytes memory data) private {
547         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
548         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
549         // the target address contains contract code and also asserts for success in the low-level call.
550 
551         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
552         if (returndata.length > 0) { // Return data is optional
553             // solhint-disable-next-line max-line-length
554             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
555         }
556     }
557 }
558 
559 // File: @openzeppelin/contracts/utils/Context.sol
560 
561 pragma solidity >=0.6.0 <0.8.0;
562 
563 /*
564  * @dev Provides information about the current execution context, including the
565  * sender of the transaction and its data. While these are generally available
566  * via msg.sender and msg.data, they should not be accessed in such a direct
567  * manner, since when dealing with GSN meta-transactions the account sending and
568  * paying for execution may not be the actual sender (as far as an application
569  * is concerned).
570  *
571  * This contract is only required for intermediate, library-like contracts.
572  */
573 abstract contract Context {
574     function _msgSender() internal view virtual returns (address payable) {
575         return msg.sender;
576     }
577 
578     function _msgData() internal view virtual returns (bytes memory) {
579         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
580         return msg.data;
581     }
582 }
583 
584 // File: @openzeppelin/contracts/access/Ownable.sol
585 
586 pragma solidity >=0.6.0 <0.8.0;
587 
588 /**
589  * @dev Contract module which provides a basic access control mechanism, where
590  * there is an account (an owner) that can be granted exclusive access to
591  * specific functions.
592  *
593  * By default, the owner account will be the one that deploys the contract. This
594  * can later be changed with {transferOwnership}.
595  *
596  * This module is used through inheritance. It will make available the modifier
597  * `onlyOwner`, which can be applied to your functions to restrict their use to
598  * the owner.
599  */
600 abstract contract Ownable is Context {
601     address private _owner;
602 
603     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
604 
605     /**
606      * @dev Initializes the contract setting the deployer as the initial owner.
607      */
608     constructor () internal {
609         address msgSender = _msgSender();
610         _owner = msgSender;
611         emit OwnershipTransferred(address(0), msgSender);
612     }
613 
614     /**
615      * @dev Returns the address of the current owner.
616      */
617     function owner() public view virtual returns (address) {
618         return _owner;
619     }
620 
621     /**
622      * @dev Throws if called by any account other than the owner.
623      */
624     modifier onlyOwner() {
625         require(owner() == _msgSender(), "Ownable: caller is not the owner");
626         _;
627     }
628 
629     /**
630      * @dev Leaves the contract without owner. It will not be possible to call
631      * `onlyOwner` functions anymore. Can only be called by the current owner.
632      *
633      * NOTE: Renouncing ownership will leave the contract without an owner,
634      * thereby removing any functionality that is only available to the owner.
635      */
636     function renounceOwnership() public virtual onlyOwner {
637         emit OwnershipTransferred(_owner, address(0));
638         _owner = address(0);
639     }
640 
641     /**
642      * @dev Transfers ownership of the contract to a new account (`newOwner`).
643      * Can only be called by the current owner.
644      */
645     function transferOwnership(address newOwner) public virtual onlyOwner {
646         require(newOwner != address(0), "Ownable: new owner is the zero address");
647         emit OwnershipTransferred(_owner, newOwner);
648         _owner = newOwner;
649     }
650 }
651 
652 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
653 
654 pragma solidity >=0.6.0 <0.8.0;
655 
656 /**
657  * @dev Contract module that helps prevent reentrant calls to a function.
658  *
659  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
660  * available, which can be applied to functions to make sure there are no nested
661  * (reentrant) calls to them.
662  *
663  * Note that because there is a single `nonReentrant` guard, functions marked as
664  * `nonReentrant` may not call one another. This can be worked around by making
665  * those functions `private`, and then adding `external` `nonReentrant` entry
666  * points to them.
667  *
668  * TIP: If you would like to learn more about reentrancy and alternative ways
669  * to protect against it, check out our blog post
670  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
671  */
672 abstract contract ReentrancyGuard {
673     // Booleans are more expensive than uint256 or any type that takes up a full
674     // word because each write operation emits an extra SLOAD to first read the
675     // slot's contents, replace the bits taken up by the boolean, and then write
676     // back. This is the compiler's defense against contract upgrades and
677     // pointer aliasing, and it cannot be disabled.
678 
679     // The values being non-zero value makes deployment a bit more expensive,
680     // but in exchange the refund on every call to nonReentrant will be lower in
681     // amount. Since refunds are capped to a percentage of the total
682     // transaction's gas, it is best to keep them low in cases like this one, to
683     // increase the likelihood of the full refund coming into effect.
684     uint256 private constant _NOT_ENTERED = 1;
685     uint256 private constant _ENTERED = 2;
686 
687     uint256 private _status;
688 
689     constructor () internal {
690         _status = _NOT_ENTERED;
691     }
692 
693     /**
694      * @dev Prevents a contract from calling itself, directly or indirectly.
695      * Calling a `nonReentrant` function from another `nonReentrant`
696      * function is not supported. It is possible to prevent this from happening
697      * by making the `nonReentrant` function external, and make it call a
698      * `private` function that does the actual work.
699      */
700     modifier nonReentrant() {
701         // On the first call to nonReentrant, _notEntered will be true
702         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
703 
704         // Any calls to nonReentrant after this point will fail
705         _status = _ENTERED;
706 
707         _;
708 
709         // By storing the original value once again, a refund is triggered (see
710         // https://eips.ethereum.org/EIPS/eip-2200)
711         _status = _NOT_ENTERED;
712     }
713 }
714 
715 // File: contracts/DuckBridge.sol
716 
717 pragma solidity ^0.6.0;
718 
719 contract DuckBridge is Ownable, ReentrancyGuard {
720     
721     using SafeMath for uint;
722     using SafeERC20 for IERC20;
723 
724     uint public constant FEE_UPDATE_DURATION = 1 days;
725 
726     address public verifyAddress;
727 
728     //chain -> index -> bool
729     mapping(uint => mapping(uint => bool)) public claimed;
730 
731     uint public currentIndex;
732 
733 	uint public chainId;
734 
735     uint public stableFeeUpdateTime;
736     uint public stableFee;
737     uint public newStableFee;
738 
739 	struct TokenData {
740 		address tokenAddress;
741 		bool exists;
742 		bool paused;
743 		// total fees collected
744 		uint totalFeesCollected;
745 		// current fee
746 		uint fee;
747 		// fee update time
748 		uint feeUpdateTime;
749 		// new fee
750 		uint newFee;
751 		// daily limit
752 		uint limit;
753 		// daily limit time
754 		uint limitTimestamp;
755 	}
756 
757 	mapping(uint => TokenData) public tokenList;
758 	mapping(uint => uint) public dailyTokenClaims;
759 	mapping(address => bool) public tokenAdded;
760 
761 	event NewTransferRequest(uint indexed tokenIndex, address indexed from, address indexed to, uint amount, uint index, uint toChain);
762 	event Transferred(uint indexed tokenIndex, address indexed from, address indexed to, uint amount, uint index, uint fromChain);
763 	event WithdrawnLostTokens(address indexed owner, address indexed tokenAddress, uint amountWithdrawn);
764 	event FeesWithdrawn(address indexed owner, uint indexed tokenIndex, uint amountWithdrawn);
765 	event NewActiveToken(address indexed tokenAddress, uint tokenIndex);
766 	event TokenPaused(uint tokenIndex);
767 	event TokenUnPaused(uint tokenIndex);
768 	event StableFeeChanged(uint indexed feeUpdateTime, uint newFee);
769 	event VerifyAddressChanged(address indexed newVerifyAddress);
770 	event DailyTokenLimitChanged(uint indexed tokenIndex, uint newLimit);
771 	event TokenFeeChanged(uint indexed feeUpdateTime, uint indexed tokenIndex, uint newFee);
772 
773 	constructor(
774 		address _duckAddress,
775 		address _ddimAddress,
776 		address _verifyAddress,
777 		uint _chainId,
778 		uint _stableFee
779 	)
780 		public Ownable()
781 	{
782 		verifyAddress = _verifyAddress;
783 		stableFee = _stableFee;
784 		newStableFee = _stableFee;
785 
786 		tokenList[1] = TokenData(
787 			_duckAddress,
788 			true,
789 			false,
790 			0,
791 			0,
792 			0,
793 			0,
794 			0,
795 			block.timestamp + 1 days
796 		);
797 		tokenList[2] = TokenData(
798 			_ddimAddress,
799 			true,
800 			false,
801 			0,
802 			0,
803 			0,
804 			0,
805 			0,
806 			block.timestamp + 1 days
807 		);
808 		tokenAdded[_duckAddress] = true;
809 		tokenAdded[_ddimAddress] = true;
810 
811 		chainId = _chainId;
812 
813 		emit StableFeeChanged(stableFeeUpdateTime, _stableFee);
814 		emit VerifyAddressChanged(_verifyAddress);
815 		emit NewActiveToken(_duckAddress, 1);
816 		emit NewActiveToken(_ddimAddress, 2);
817 	}
818 
819 	receive() external payable { }
820 
821 	function transferRequest(uint _tokenIndex, address _to, uint _amount, uint _chainId) external nonReentrant {
822 		TokenData storage tokenData = tokenList[_tokenIndex];
823 
824 		require(tokenData.exists, "token doesnt exist on bridge");
825 		require(!tokenData.paused, "token paused");
826 		require(_chainId != chainId, "cannot request to the same chain");
827 
828 		updateFees(_tokenIndex);
829 
830 		IERC20 token = IERC20(tokenData.tokenAddress);
831 
832 		uint _fee = calculateFee(_tokenIndex, _amount);
833 
834 		token.safeTransferFrom(msg.sender, address(this), _amount);
835 		tokenData.totalFeesCollected = tokenData.totalFeesCollected.add(_fee);
836 
837 		emit NewTransferRequest(_tokenIndex, msg.sender, _to, _amount.sub(_fee), currentIndex, _chainId);
838 		currentIndex++;
839 	}
840 
841 	function transferReceipt(
842 		uint _tokenIndex,
843 		address _from,
844 		address _to,
845 		uint _amount,
846 		uint _chainId,
847 		uint _index,
848 		bytes calldata signature
849 	) 
850 		external nonReentrant
851 	{
852 		TokenData storage tokenData = tokenList[_tokenIndex];
853 
854 		require(tokenData.exists, "token doesnt exist on bridge");
855 		require(!claimed[_chainId][_index], "already claimed");
856 		require(_chainId != chainId, "cannot claim from a different chain");
857 		require(!tokenData.paused, "token paused");
858         require(verify(_tokenIndex, _from, _to, _amount, _chainId, _index, signature), "invalid signature");
859 
860 		// if theres a limit set
861 		if (tokenData.limit > 0) {
862 			updateDailyLimit(_tokenIndex);
863 			require(dailyTokenClaims[_tokenIndex].add(_amount) <= tokenData.limit, "cannot claim above the daily limit");
864 		}
865 
866        	IERC20(tokenData.tokenAddress).safeTransfer(_to, _amount);
867 		claimed[_chainId][_index] = true;
868 		dailyTokenClaims[_tokenIndex] = dailyTokenClaims[_tokenIndex].add(_amount);
869 
870        	emit Transferred(_tokenIndex, _from, _to, _amount, _index, _chainId);
871 	}
872 
873 	function updateVerifyAddress(address _verifyAddress) external onlyOwner {
874 		verifyAddress = _verifyAddress;
875 		emit VerifyAddressChanged(_verifyAddress);
876 	}
877 
878 	function updateTokenLimit(uint _tokenIndex, uint _limit) external onlyOwner {
879 		tokenList[_tokenIndex].limit = _limit;
880 		// reset the time?
881 		// tokenList[_tokenIndex].limitTimestamp = block.timestamp + 1 days;
882 		emit DailyTokenLimitChanged(_tokenIndex, _limit);
883 	}
884 
885 	function setTokenLimitTime(uint _tokenIndex, uint _timestamp) external onlyOwner {
886 		tokenList[_tokenIndex].limitTimestamp = _timestamp;
887 	}
888 
889 	function updateStableFee(uint _newStableFee) external onlyOwner {
890 		stableFeeUpdateTime = block.timestamp + FEE_UPDATE_DURATION;
891 		newStableFee = _newStableFee;
892 		emit StableFeeChanged(stableFeeUpdateTime, _newStableFee);
893 	}
894 
895 	function updateTokenFee(uint _index, uint _newTokenFee) external onlyOwner {
896 		tokenList[_index].feeUpdateTime = block.timestamp + FEE_UPDATE_DURATION;
897 		tokenList[_index].newFee = _newTokenFee;
898 		emit TokenFeeChanged(tokenList[_index].feeUpdateTime, _index, _newTokenFee);
899 	}
900 
901 	function updateFees(uint _tokenIndex) public {
902 		updateStableFee();
903 		updateTokenFee(_tokenIndex);
904 	}
905 
906 	function withdrawFees(uint _index) external nonReentrant onlyOwner {
907 	    TokenData storage tokenData = tokenList[_index];
908 	    
909 		require(tokenData.totalFeesCollected > 0, "nothing to withdraw");
910 
911 		uint toTransfer = tokenData.totalFeesCollected;
912 		tokenData.totalFeesCollected = 0;
913 
914 		IERC20(tokenData.tokenAddress).safeTransfer(msg.sender, toTransfer);
915 
916 		emit FeesWithdrawn(msg.sender, _index, toTransfer);
917 	}
918 
919 	function addToken(uint _index, address _tokenAddress, uint _fee, uint _limit) external onlyOwner {
920 		require(!tokenList[_index].exists, "token already created");
921 
922 		tokenList[_index] = TokenData(
923 		    _tokenAddress,
924 			true,
925 			false,
926 			0,
927 			_fee,
928 			0,
929 			0,
930 			_limit,
931 			block.timestamp + 1 days
932 		);
933 		tokenAdded[_tokenAddress] = true;
934 		emit NewActiveToken(_tokenAddress, _index);
935 	}
936 
937 	function pauseToken(uint _tokenIndex) external onlyOwner {
938 		require(!tokenList[_tokenIndex].paused, "token already paused");
939 		tokenList[_tokenIndex].paused = true;
940 		emit TokenPaused(_tokenIndex);
941 	}
942 
943 	function unpauseToken(uint _tokenIndex) external onlyOwner {
944 		require(tokenList[_tokenIndex].paused, "token already unpaused");
945 		tokenList[_tokenIndex].paused = false;
946 		emit TokenUnPaused(_tokenIndex);
947 	}
948 
949 	//if something wrong
950 	function emergencyWithdraw(address _tokenAddress) external nonReentrant onlyOwner {
951 		require(!tokenAdded[_tokenAddress], "cannot withdraw from existing token");
952 
953 		uint balanceOfThis;
954 		if(_tokenAddress == address(0)) {
955 			balanceOfThis = address(this).balance;
956 			msg.sender.transfer(balanceOfThis);
957 		} else {
958 			balanceOfThis = IERC20(_tokenAddress).balanceOf(address(this));
959 			IERC20(_tokenAddress).safeTransfer(owner(), balanceOfThis);
960 		}
961 
962 		emit WithdrawnLostTokens(owner(), _tokenAddress, balanceOfThis);
963 	}
964 
965 	function updateDailyLimit(uint _tokenIndex) internal {
966 		// if the current time is still within the time limit do nothing
967 		if (block.timestamp <= tokenList[_tokenIndex].limitTimestamp) {
968 			return;
969 		}
970 
971 		// if the current time above the daily limit time, reset it with the acc amount
972 		tokenList[_tokenIndex].limitTimestamp = block.timestamp + 1 days;
973 		dailyTokenClaims[_tokenIndex] = 0;
974 	}
975 
976 	function updateTokenFee(uint _tokenIndex) internal {
977 		if(tokenList[_tokenIndex].feeUpdateTime == 0) {
978 			return;
979 		}
980 
981 		if(block.timestamp > tokenList[_tokenIndex].feeUpdateTime) {
982 			tokenList[_tokenIndex].fee = tokenList[_tokenIndex].newFee;
983 			tokenList[_tokenIndex].feeUpdateTime = 0;
984 		}
985 	}
986 
987 	function updateStableFee() internal {
988 		if(stableFeeUpdateTime == 0) {
989 			return;
990 		}
991 
992 		if(block.timestamp > stableFeeUpdateTime) {
993 			stableFee = newStableFee;
994 			stableFeeUpdateTime = 0;
995 		}
996 	}
997 
998 	function calculateFee(uint _tokenIndex, uint _amount) public view returns(uint) {
999 		if(tokenList[_tokenIndex].fee != 0) {
1000 			if(tokenList[_tokenIndex].fee >= 1e18) {
1001 				return 0;
1002 			}
1003 			return _amount.mul(tokenList[_tokenIndex].fee).div(1e18);
1004 		}
1005 
1006 		if(stableFee >= 1e18) {
1007 			return 0;
1008 		}
1009 
1010 		return _amount.mul(stableFee).div(1e18);
1011 	}
1012 	
1013 	/// signature methods.
1014 	function verify(
1015 		uint _tokenIndex,
1016 		address _from,
1017 		address _to,
1018 		uint _amount,
1019 		uint _chainId,
1020 		uint _index,
1021 		bytes calldata signature
1022 	) 
1023 		internal view returns(bool) 
1024 	{
1025 		bytes32 message = prefixed(keccak256(abi.encode(_tokenIndex, _from, _to, _amount, _chainId, _index, address(this))));
1026         return (recoverSigner(message, signature) == verifyAddress);
1027 	}
1028 
1029     function recoverSigner(bytes32 message, bytes memory sig)
1030         internal
1031         pure
1032         returns (address)
1033     {
1034         (uint8 v, bytes32 r, bytes32 s) = abi.decode(sig, (uint8, bytes32, bytes32));
1035 
1036         return ecrecover(message, v, r, s);
1037     }
1038 
1039     /// builds a prefixed hash to mimic the behavior of eth_sign.
1040     function prefixed(bytes32 hash) internal pure returns (bytes32) {
1041         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1042     }
1043 }