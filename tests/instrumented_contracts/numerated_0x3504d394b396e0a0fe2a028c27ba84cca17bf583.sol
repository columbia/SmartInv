1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 
34 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2
35 
36 
37 
38 pragma solidity >=0.6.0 <0.8.0;
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 
115 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
116 
117 
118 
119 pragma solidity >=0.6.0 <0.8.0;
120 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         uint256 c = a + b;
142         if (c < a) return (false, 0);
143         return (true, c);
144     }
145 
146     /**
147      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
148      *
149      * _Available since v3.4._
150      */
151     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         if (b > a) return (false, 0);
153         return (true, a - b);
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) return (true, 0);
166         uint256 c = a * b;
167         if (c / a != b) return (false, 0);
168         return (true, c);
169     }
170 
171     /**
172      * @dev Returns the division of two unsigned integers, with a division by zero flag.
173      *
174      * _Available since v3.4._
175      */
176     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
177         if (b == 0) return (false, 0);
178         return (true, a / b);
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
183      *
184      * _Available since v3.4._
185      */
186     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         if (b == 0) return (false, 0);
188         return (true, a % b);
189     }
190 
191     /**
192      * @dev Returns the addition of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `+` operator.
196      *
197      * Requirements:
198      *
199      * - Addition cannot overflow.
200      */
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a + b;
203         require(c >= a, "SafeMath: addition overflow");
204         return c;
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      *
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218         require(b <= a, "SafeMath: subtraction overflow");
219         return a - b;
220     }
221 
222     /**
223      * @dev Returns the multiplication of two unsigned integers, reverting on
224      * overflow.
225      *
226      * Counterpart to Solidity's `*` operator.
227      *
228      * Requirements:
229      *
230      * - Multiplication cannot overflow.
231      */
232     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
233         if (a == 0) return 0;
234         uint256 c = a * b;
235         require(c / a == b, "SafeMath: multiplication overflow");
236         return c;
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers, reverting on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator. Note: this function uses a
244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
245      * uses an invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function div(uint256 a, uint256 b) internal pure returns (uint256) {
252         require(b > 0, "SafeMath: division by zero");
253         return a / b;
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * reverting when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
269         require(b > 0, "SafeMath: modulo by zero");
270         return a % b;
271     }
272 
273     /**
274      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
275      * overflow (when the result is negative).
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {trySub}.
279      *
280      * Counterpart to Solidity's `-` operator.
281      *
282      * Requirements:
283      *
284      * - Subtraction cannot overflow.
285      */
286     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
287         require(b <= a, errorMessage);
288         return a - b;
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
293      * division by zero. The result is rounded towards zero.
294      *
295      * CAUTION: This function is deprecated because it requires allocating memory for the error
296      * message unnecessarily. For custom revert reasons use {tryDiv}.
297      *
298      * Counterpart to Solidity's `/` operator. Note: this function uses a
299      * `revert` opcode (which leaves remaining gas untouched) while Solidity
300      * uses an invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
307         require(b > 0, errorMessage);
308         return a / b;
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
313      * reverting with custom message when dividing by zero.
314      *
315      * CAUTION: This function is deprecated because it requires allocating memory for the error
316      * message unnecessarily. For custom revert reasons use {tryMod}.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      *
324      * - The divisor cannot be zero.
325      */
326     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         require(b > 0, errorMessage);
328         return a % b;
329     }
330 }
331 
332 
333 // File @openzeppelin/contracts/utils/Address.sol@v3.4.2
334 
335 
336 
337 pragma solidity >=0.6.2 <0.8.0;
338 
339 /**
340  * @dev Collection of functions related to the address type
341  */
342 library Address {
343     /**
344      * @dev Returns true if `account` is a contract.
345      *
346      * [IMPORTANT]
347      * ====
348      * It is unsafe to assume that an address for which this function returns
349      * false is an externally-owned account (EOA) and not a contract.
350      *
351      * Among others, `isContract` will return false for the following
352      * types of addresses:
353      *
354      *  - an externally-owned account
355      *  - a contract in construction
356      *  - an address where a contract will be created
357      *  - an address where a contract lived, but was destroyed
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // This method relies on extcodesize, which returns 0 for contracts in
362         // construction, since the code is only stored at the end of the
363         // constructor execution.
364 
365         uint256 size;
366         // solhint-disable-next-line no-inline-assembly
367         assembly { size := extcodesize(account) }
368         return size > 0;
369     }
370 
371     /**
372      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
373      * `recipient`, forwarding all available gas and reverting on errors.
374      *
375      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
376      * of certain opcodes, possibly making contracts go over the 2300 gas limit
377      * imposed by `transfer`, making them unable to receive funds via
378      * `transfer`. {sendValue} removes this limitation.
379      *
380      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
381      *
382      * IMPORTANT: because control is transferred to `recipient`, care must be
383      * taken to not create reentrancy vulnerabilities. Consider using
384      * {ReentrancyGuard} or the
385      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
386      */
387     function sendValue(address payable recipient, uint256 amount) internal {
388         require(address(this).balance >= amount, "Address: insufficient balance");
389 
390         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
391         (bool success, ) = recipient.call{ value: amount }("");
392         require(success, "Address: unable to send value, recipient may have reverted");
393     }
394 
395     /**
396      * @dev Performs a Solidity function call using a low level `call`. A
397      * plain`call` is an unsafe replacement for a function call: use this
398      * function instead.
399      *
400      * If `target` reverts with a revert reason, it is bubbled up by this
401      * function (like regular Solidity function calls).
402      *
403      * Returns the raw returned data. To convert to the expected return value,
404      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
405      *
406      * Requirements:
407      *
408      * - `target` must be a contract.
409      * - calling `target` with `data` must not revert.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
414       return functionCall(target, data, "Address: low-level call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
419      * `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, 0, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but also transferring `value` wei to `target`.
430      *
431      * Requirements:
432      *
433      * - the calling contract must have an ETH balance of at least `value`.
434      * - the called Solidity function must be `payable`.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
444      * with `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
449         require(address(this).balance >= value, "Address: insufficient balance for call");
450         require(isContract(target), "Address: call to non-contract");
451 
452         // solhint-disable-next-line avoid-low-level-calls
453         (bool success, bytes memory returndata) = target.call{ value: value }(data);
454         return _verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
464         return functionStaticCall(target, data, "Address: low-level static call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a static call.
470      *
471      * _Available since v3.3._
472      */
473     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
474         require(isContract(target), "Address: static call to non-contract");
475 
476         // solhint-disable-next-line avoid-low-level-calls
477         (bool success, bytes memory returndata) = target.staticcall(data);
478         return _verifyCallResult(success, returndata, errorMessage);
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
483      * but performing a delegate call.
484      *
485      * _Available since v3.4._
486      */
487     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
488         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
493      * but performing a delegate call.
494      *
495      * _Available since v3.4._
496      */
497     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
498         require(isContract(target), "Address: delegate call to non-contract");
499 
500         // solhint-disable-next-line avoid-low-level-calls
501         (bool success, bytes memory returndata) = target.delegatecall(data);
502         return _verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
506         if (success) {
507             return returndata;
508         } else {
509             // Look for revert reason and bubble it up if present
510             if (returndata.length > 0) {
511                 // The easiest way to bubble the revert reason is using memory via assembly
512 
513                 // solhint-disable-next-line no-inline-assembly
514                 assembly {
515                     let returndata_size := mload(returndata)
516                     revert(add(32, returndata), returndata_size)
517                 }
518             } else {
519                 revert(errorMessage);
520             }
521         }
522     }
523 }
524 
525 
526 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.2
527 
528 
529 
530 pragma solidity >=0.6.0 <0.8.0;
531 
532 
533 
534 /**
535  * @title SafeERC20
536  * @dev Wrappers around ERC20 operations that throw on failure (when the token
537  * contract returns false). Tokens that return no value (and instead revert or
538  * throw on failure) are also supported, non-reverting calls are assumed to be
539  * successful.
540  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
541  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
542  */
543 library SafeERC20 {
544     using SafeMath for uint256;
545     using Address for address;
546 
547     function safeTransfer(IERC20 token, address to, uint256 value) internal {
548         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
549     }
550 
551     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
552         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
553     }
554 
555     /**
556      * @dev Deprecated. This function has issues similar to the ones found in
557      * {IERC20-approve}, and its usage is discouraged.
558      *
559      * Whenever possible, use {safeIncreaseAllowance} and
560      * {safeDecreaseAllowance} instead.
561      */
562     function safeApprove(IERC20 token, address spender, uint256 value) internal {
563         // safeApprove should only be called when setting an initial allowance,
564         // or when resetting it to zero. To increase and decrease it, use
565         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
566         // solhint-disable-next-line max-line-length
567         require((value == 0) || (token.allowance(address(this), spender) == 0),
568             "SafeERC20: approve from non-zero to non-zero allowance"
569         );
570         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
571     }
572 
573     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
574         uint256 newAllowance = token.allowance(address(this), spender).add(value);
575         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
576     }
577 
578     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
579         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
580         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
581     }
582 
583     /**
584      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
585      * on the return value: the return value is optional (but if data is returned, it must not be false).
586      * @param token The token targeted by the call.
587      * @param data The call data (encoded using abi.encode or one of its variants).
588      */
589     function _callOptionalReturn(IERC20 token, bytes memory data) private {
590         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
591         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
592         // the target address contains contract code and also asserts for success in the low-level call.
593 
594         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
595         if (returndata.length > 0) { // Return data is optional
596             // solhint-disable-next-line max-line-length
597             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
598         }
599     }
600 }
601 
602 
603 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.2
604 
605 
606 
607 pragma solidity >=0.6.0 <0.8.0;
608 
609 /**
610  * @dev Contract module that helps prevent reentrant calls to a function.
611  *
612  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
613  * available, which can be applied to functions to make sure there are no nested
614  * (reentrant) calls to them.
615  *
616  * Note that because there is a single `nonReentrant` guard, functions marked as
617  * `nonReentrant` may not call one another. This can be worked around by making
618  * those functions `private`, and then adding `external` `nonReentrant` entry
619  * points to them.
620  *
621  * TIP: If you would like to learn more about reentrancy and alternative ways
622  * to protect against it, check out our blog post
623  * https://blog.openzeppelin.com/reentrancy-after-istangldm/[Reentrancy After Istangldm].
624  */
625 abstract contract ReentrancyGuard {
626     // Booleans are more expensive than uint256 or any type that takes up a full
627     // word because each write operation emits an extra SLOAD to first read the
628     // slot's contents, replace the bits taken up by the boolean, and then write
629     // back. This is the compiler's defense against contract upgrades and
630     // pointer aliasing, and it cannot be disabled.
631 
632     // The values being non-zero value makes deployment a bit more expensive,
633     // but in exchange the refund on every call to nonReentrant will be lower in
634     // amount. Since refunds are capped to a percentage of the total
635     // transaction's gas, it is best to keep them low in cases like this one, to
636     // increase the likelihood of the full refund coming into effect.
637     uint256 private constant _NOT_ENTERED = 1;
638     uint256 private constant _ENTERED = 2;
639 
640     uint256 private _status;
641 
642     constructor () internal {
643         _status = _NOT_ENTERED;
644     }
645 
646     /**
647      * @dev Prevents a contract from calling itself, directly or indirectly.
648      * Calling a `nonReentrant` function from another `nonReentrant`
649      * function is not supported. It is possible to prevent this from happening
650      * by making the `nonReentrant` function external, and make it call a
651      * `private` function that does the actual work.
652      */
653     modifier nonReentrant() {
654         // On the first call to nonReentrant, _notEntered will be true
655         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
656 
657         // Any calls to nonReentrant after this point will fail
658         _status = _ENTERED;
659 
660         _;
661 
662         // By storing the original value once again, a refund is triggered (see
663         // https://eips.ethereum.org/EIPS/eip-2200)
664         _status = _NOT_ENTERED;
665     }
666 }
667 
668 
669 // File contracts/lib/Babylonian.sol
670 
671 
672 
673 pragma solidity ^0.6.0;
674 
675 library Babylonian {
676     function sqrt(uint256 y) internal pure returns (uint256 z) {
677         if (y > 3) {
678             z = y;
679             uint256 x = y / 2 + 1;
680             while (x < z) {
681                 z = x;
682                 x = (y / x + x) / 2;
683             }
684         } else if (y != 0) {
685             z = 1;
686         }
687         // else z = 0
688     }
689 }
690 
691 
692 // File @openzeppelin/contracts/utils/Context.sol@v3.4.2
693 
694 
695 
696 pragma solidity >=0.6.0 <0.8.0;
697 
698 /*
699  * @dev Provides information about the current execution context, including the
700  * sender of the transaction and its data. While these are generally available
701  * via msg.sender and msg.data, they should not be accessed in such a direct
702  * manner, since when dealing with GSN meta-transactions the account sending and
703  * paying for execution may not be the actual sender (as far as an application
704  * is concerned).
705  *
706  * This contract is only required for intermediate, library-like contracts.
707  */
708 abstract contract Context {
709     function _msgSender() internal view virtual returns (address payable) {
710         return msg.sender;
711     }
712 
713     function _msgData() internal view virtual returns (bytes memory) {
714         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
715         return msg.data;
716     }
717 }
718 
719 
720 // File @openzeppelin/contracts/GSN/Context.sol@v3.4.2
721 
722 
723 
724 pragma solidity >=0.6.0 <0.8.0;
725 
726 
727 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.2
728 
729 
730 
731 pragma solidity >=0.6.0 <0.8.0;
732 
733 /**
734  * @dev Contract module which provides a basic access control mechanism, where
735  * there is an account (an owner) that can be granted exclusive access to
736  * specific functions.
737  *
738  * By default, the owner account will be the one that deploys the contract. This
739  * can later be changed with {transferOwnership}.
740  *
741  * This module is used through inheritance. It will make available the modifier
742  * `onlyOwner`, which can be applied to your functions to restrict their use to
743  * the owner.
744  */
745 abstract contract Ownable is Context {
746     address private _owner;
747 
748     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
749 
750     /**
751      * @dev Initializes the contract setting the deployer as the initial owner.
752      */
753     constructor () internal {
754         address msgSender = _msgSender();
755         _owner = msgSender;
756         emit OwnershipTransferred(address(0), msgSender);
757     }
758 
759     /**
760      * @dev Returns the address of the current owner.
761      */
762     function owner() public view virtual returns (address) {
763         return _owner;
764     }
765 
766     /**
767      * @dev Throws if called by any account other than the owner.
768      */
769     modifier onlyOwner() {
770         require(owner() == _msgSender(), "Ownable: caller is not the owner");
771         _;
772     }
773 
774     /**
775      * @dev Leaves the contract without owner. It will not be possible to call
776      * `onlyOwner` functions anymore. Can only be called by the current owner.
777      *
778      * NOTE: Renouncing ownership will leave the contract without an owner,
779      * thereby removing any functionality that is only available to the owner.
780      */
781     function renounceOwnership() public virtual onlyOwner {
782         emit OwnershipTransferred(_owner, address(0));
783         _owner = address(0);
784     }
785 
786     /**
787      * @dev Transfers ownership of the contract to a new account (`newOwner`).
788      * Can only be called by the current owner.
789      */
790     function transferOwnership(address newOwner) public virtual onlyOwner {
791         require(newOwner != address(0), "Ownable: new owner is the zero address");
792         emit OwnershipTransferred(_owner, newOwner);
793         _owner = newOwner;
794     }
795 }
796 
797 
798 // File contracts/owner/Operator.sol
799 
800 
801 
802 pragma solidity 0.6.12;
803 
804 
805 contract Operator is Context, Ownable {
806     address private _operator;
807 
808     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
809 
810     constructor() internal {
811         _operator = _msgSender();
812         emit OperatorTransferred(address(0), _operator);
813     }
814 
815     function operator() public view returns (address) {
816         return _operator;
817     }
818 
819     modifier onlyOperator() {
820         require(_operator == msg.sender, "operator: caller is not the operator");
821         _;
822     }
823 
824     function isOperator() public view returns (bool) {
825         return _msgSender() == _operator;
826     }
827 
828     function transferOperator(address newOperator_) public onlyOwner {
829         _transferOperator(newOperator_);
830     }
831 
832     function _transferOperator(address newOperator_) internal {
833         require(newOperator_ != address(0), "operator: zero address given for new operator");
834         emit OperatorTransferred(address(0), newOperator_);
835         _operator = newOperator_;
836     }
837 }
838 
839 
840 // File contracts/utils/ContractGuard.sol
841 
842 
843 
844 pragma solidity 0.6.12;
845 
846 contract ContractGuard {
847     mapping(uint256 => mapping(address => bool)) private _status;
848 
849     function checkSameOriginReentranted() internal view returns (bool) {
850         return _status[block.number][tx.origin];
851     }
852 
853     function checkSameSenderReentranted() internal view returns (bool) {
854         return _status[block.number][msg.sender];
855     }
856 
857     modifier onlyOneBlock() {
858         require(!checkSameOriginReentranted(), "ContractGuard: one block, one function");
859         require(!checkSameSenderReentranted(), "ContractGuard: one block, one function");
860 
861         _;
862 
863         _status[block.number][tx.origin] = true;
864         _status[block.number][msg.sender] = true;
865     }
866 }
867 
868 
869 // File contracts/interfaces/IBasisAsset.sol
870 
871 
872 
873 pragma solidity ^0.6.0;
874 
875 interface IBasisAsset {
876     function mint(address recipient, uint256 amount) external returns (bool);
877 
878     function burn(uint256 amount) external;
879 
880     function burnFrom(address from, uint256 amount) external;
881 
882     function isOperator() external returns (bool);
883 
884     function operator() external view returns (address);
885 
886     function transferOperator(address newOperator_) external;
887 }
888 
889 
890 // File contracts/interfaces/IOracle.sol
891 
892 
893 
894 pragma solidity 0.6.12;
895 
896 interface IOracle {
897     function update() external;
898 
899     function consult(address _token, uint256 _amountIn) external view returns (uint144 amountOut);
900 
901     function twap(address _token, uint256 _amountIn) external view returns (uint144 _amountOut);
902 }
903 
904 
905 // File contracts/interfaces/IBoardroom.sol
906 
907 
908 
909 pragma solidity 0.6.12;
910 
911 interface IBoardroom {
912     function balanceOf(address _member) external view returns (uint256);
913 
914     function earned(address _member) external view returns (uint256);
915 
916     function canWithdraw(address _member) external view returns (bool);
917 
918     function canClaimReward(address _member) external view returns (bool);
919 
920     function epoch() external view returns (uint256);
921 
922     function nextEpochPoint() external view returns (uint256);
923 
924     function getGldmPrice() external view returns (uint256);
925 
926     function setOperator(address _operator) external;
927 
928     function setLockUp(uint256 _withdrawLockupEpochs, uint256 _rewardLockupEpochs) external;
929 
930     function stake(uint256 _amount) external;
931 
932     function withdraw(uint256 _amount) external;
933 
934     function exit() external;
935 
936     function claimReward() external;
937 
938     function allocateSeigniorage(uint256 _amount) external;
939 
940     function governanceRecoverUnsupported(
941         address _token,
942         uint256 _amount,
943         address _to
944     ) external;
945 }
946 
947 
948 // File contracts/Treasury.sol
949 
950 
951 
952 pragma solidity 0.6.12;
953 
954 
955 contract Treasury is ContractGuard {
956     using SafeERC20 for IERC20;
957     using Address for address;
958     using SafeMath for uint256;
959 
960     /* ========= CONSTANT VARIABLES ======== */
961 
962     uint256 public constant PERIOD = 6 hours;
963 
964     /* ========== STATE VARIABLES ========== */
965 
966     // governance
967     address public operator;
968 
969     // flags
970     bool public initialized = false;
971 
972     // epoch
973     uint256 public startTime;
974     uint256 public epoch = 0;
975     uint256 public epochSupplyContractionLeft = 0;
976 
977     // exclusions from total supply
978     address[] public excludedFromTotalSupply = [
979         address(0x32707372b88beF099DD2AE190804e519831eeDf4) // GldmGenesisPool
980     ];
981 
982     // core components
983     address public gldm;
984     address public bgldm;
985     address public sgldm;
986 
987     address public boardroom;
988     address public gldmOracle;
989 
990     // price
991     uint256 public gldmPriceOne;
992     uint256 public gldmPriceCeiling;
993 
994     uint256 public seigniorageSaved;
995 
996     uint256[] public supplyTiers;
997     uint256[] public maxExpansionTiers;
998 
999     uint256 public maxSupplyExpansionPercent;
1000     uint256 public bondDepletionFloorPercent;
1001     uint256 public seigniorageExpansionFloorPercent;
1002     uint256 public maxSupplyContractionPercent;
1003     uint256 public maxDebtRatioPercent;
1004 
1005     // 28 first epochs (1 week) with 4.5% expansion regardless of GLDM price
1006     uint256 public bootstrapEpochs;
1007     uint256 public bootstrapSupplyExpansionPercent;
1008 
1009     /* =================== Added variables =================== */
1010     uint256 public previousEpochGldmPrice;
1011     uint256 public maxDiscountRate; // when purchasing bond
1012     uint256 public maxPremiumRate; // when redeeming bond
1013     uint256 public discountPercent;
1014     uint256 public premiumThreshold;
1015     uint256 public premiumPercent;
1016     uint256 public mintingFactorForPayingDebt; // print extra GLDM during debt phase
1017 
1018     address public daoFund;
1019     uint256 public daoFunsGldmdPercent;
1020 
1021     address public devFund;
1022     uint256 public devFunsGldmdPercent;
1023 
1024     /* =================== Events =================== */
1025 
1026     event Initialized(address indexed executor, uint256 at);
1027     event BurnedBonds(address indexed from, uint256 bondAmount);
1028     event RedeemedBonds(address indexed from, uint256 gldmAmount, uint256 bondAmount);
1029     event BoughtBonds(address indexed from, uint256 gldmAmount, uint256 bondAmount);
1030     event TreasuryFunded(uint256 timestamp, uint256 seigniorage);
1031     event BoardroomFunded(uint256 timestamp, uint256 seigniorage);
1032     event DaoFundFunded(uint256 timestamp, uint256 seigniorage);
1033     event DevFundFunded(uint256 timestamp, uint256 seigniorage);
1034 
1035     /* =================== Modifier =================== */
1036 
1037     modifier onlyOperator() {
1038         require(operator == msg.sender, "Treasury: caller is not the operator");
1039         _;
1040     }
1041 
1042     modifier checkCondition() {
1043         require(now >= startTime, "Treasury: not started yet");
1044 
1045         _;
1046     }
1047 
1048     modifier checkEpoch() {
1049         require(now >= nextEpochPoint(), "Treasury: not opened yet");
1050 
1051         _;
1052 
1053         epoch = epoch.add(1);
1054         epochSupplyContractionLeft = (getGldmPrice() > gldmPriceCeiling) ? 0 : getGldmCirculatingSupply().mul(maxSupplyContractionPercent).div(10000);
1055     }
1056 
1057     modifier checkOperator() {
1058         require(
1059             IBasisAsset(gldm).operator() == address(this) &&
1060                 IBasisAsset(bgldm).operator() == address(this) &&
1061                 IBasisAsset(sgldm).operator() == address(this) &&
1062                 Operator(boardroom).operator() == address(this),
1063             "Treasury: need more permission"
1064         );
1065 
1066         _;
1067     }
1068 
1069     modifier notInitialized() {
1070         require(!initialized, "Treasury: already initialized");
1071 
1072         _;
1073     }
1074 
1075     /* ========== VIEW FUNCTIONS ========== */
1076 
1077     function isInitialized() public view returns (bool) {
1078         return initialized;
1079     }
1080 
1081     // epoch
1082     function nextEpochPoint() public view returns (uint256) {
1083         return startTime.add(epoch.mul(PERIOD));
1084     }
1085 
1086     // oracle
1087     function getGldmPrice() public view returns (uint256 gldmPrice) {
1088         try IOracle(gldmOracle).consult(gldm, 1e18) returns (uint144 price) {
1089             return uint256(price);
1090         } catch {
1091             revert("Treasury: failed to consult GLDM price from the oracle");
1092         }
1093     }
1094 
1095     function getGldmUpdatedPrice() public view returns (uint256 _gldmPrice) {
1096         try IOracle(gldmOracle).twap(gldm, 1e18) returns (uint144 price) {
1097             return uint256(price);
1098         } catch {
1099             revert("Treasury: failed to consult GLDM price from the oracle");
1100         }
1101     }
1102 
1103     // budget
1104     function getReserve() public view returns (uint256) {
1105         return seigniorageSaved;
1106     }
1107 
1108     function getBurnableGldmLeft() public view returns (uint256 _burnableGldmLeft) {
1109         uint256 _gldmPrice = getGldmPrice();          
1110         if (_gldmPrice <= gldmPriceOne) {             
1111             uint256 _gldmSupply = getGldmCirculatingSupply(); 
1112             uint256 _bondMaxSupply = _gldmSupply.mul(maxDebtRatioPercent).div(10000);
1113             uint256 _bondSupply = IERC20(bgldm).totalSupply();
1114             if (_bondMaxSupply > _bondSupply) {
1115                 uint256 _maxMintableBond = _bondMaxSupply.sub(_bondSupply);
1116                 uint256 _maxBurnableGldm = _maxMintableBond.mul(_gldmPrice).div(1e18);
1117                 _burnableGldmLeft = Math.min(epochSupplyContractionLeft, _maxBurnableGldm);
1118             }
1119         }
1120     }
1121 
1122     function getRedeemableBonds() public view returns (uint256 _redeemableBonds) {
1123         uint256 _gldmPrice = getGldmPrice();
1124         if (_gldmPrice > gldmPriceCeiling) {
1125             uint256 _totalGldm = IERC20(gldm).balanceOf(address(this));
1126             uint256 _rate = getBondPremiumRate();
1127             if (_rate > 0) {
1128                 _redeemableBonds = _totalGldm.mul(1e18).div(_rate);
1129             }
1130         }
1131     }
1132 
1133     function getBondDiscountRate() public view returns (uint256 _rate) {
1134         uint256 _gldmPrice = getGldmPrice();
1135         if (_gldmPrice <= gldmPriceOne) {
1136             if (discountPercent == 0) {
1137                 // no discount
1138                 _rate = gldmPriceOne;
1139             } else {
1140                 uint256 _bondAmount = gldmPriceOne.mul(1e18).div(_gldmPrice); // to burn 1 GLDM
1141                 uint256 _discountAmount = _bondAmount.sub(gldmPriceOne).mul(discountPercent).div(10000);
1142                 _rate = gldmPriceOne.add(_discountAmount);
1143                 if (maxDiscountRate > 0 && _rate > maxDiscountRate) {
1144                     _rate = maxDiscountRate;
1145                 }
1146             }
1147         }
1148     }
1149 
1150     function getBondPremiumRate() public view returns (uint256 _rate) {
1151         uint256 _gldmPrice = getGldmPrice();
1152         if (_gldmPrice > gldmPriceCeiling) {
1153             uint256 _gldmPricePremiumThreshold = gldmPriceOne.mul(premiumThreshold).div(100);
1154             if (_gldmPrice >= _gldmPricePremiumThreshold) {
1155                 //Price > 1.10
1156                 uint256 _premiumAmount = _gldmPrice.sub(gldmPriceOne).mul(premiumPercent).div(10000);
1157                 _rate = gldmPriceOne.add(_premiumAmount);
1158                 if (maxPremiumRate > 0 && _rate > maxPremiumRate) {
1159                     _rate = maxPremiumRate;
1160                 }
1161             } else {
1162                 // no premium bonus
1163                 _rate = gldmPriceOne;
1164             }
1165         }
1166     }
1167 
1168     /* ========== GOVERNANCE ========== */
1169 
1170     function initialize(
1171         address _gldm,
1172         address _bgldm,
1173         address _gldmshare,
1174         address _gldmOracle,
1175         address _boardroom,
1176         uint256 _startTime
1177     ) public notInitialized {
1178         gldm = _gldm;
1179         bgldm = _bgldm;
1180         sgldm = _gldmshare;
1181         gldmOracle = _gldmOracle;
1182         boardroom = _boardroom;
1183         startTime = _startTime;
1184 
1185         gldmPriceOne = 10**18; // This is to allow a PEG of 100 GLDM per wBNB
1186         gldmPriceCeiling = gldmPriceOne.mul(101).div(100);
1187 
1188         // Dynamic max expansion percent
1189         supplyTiers = [0 ether, 500000 ether, 1000000 ether, 1500000 ether, 2000000 ether, 5000000 ether, 10000000 ether, 20000000 ether, 50000000 ether];
1190         maxExpansionTiers = [450, 400, 350, 300, 250, 200, 150, 125, 100];
1191 
1192         maxSupplyExpansionPercent = 400; // Upto 4.0% supply for expansion
1193 
1194         bondDepletionFloorPercent = 10000; // 100% of Bond supply for depletion floor
1195         seigniorageExpansionFloorPercent = 3500; // At least 35% of expansion reserved for boardroom
1196         maxSupplyContractionPercent = 300; // Upto 3.0% supply for contraction (to burn GLDM and mint tBOND)
1197         maxDebtRatioPercent = 4500; // Upto 35% supply of tBOND to purchase
1198 
1199         premiumThreshold = 110;
1200         premiumPercent = 7000;
1201 
1202         // First 28 epochs with 4.5% expansion
1203         bootstrapEpochs = 0;
1204         bootstrapSupplyExpansionPercent = 450;
1205 
1206         // set seigniorageSaved to it's balance
1207         seigniorageSaved = IERC20(gldm).balanceOf(address(this));
1208 
1209         initialized = true;
1210         operator = msg.sender;
1211         emit Initialized(msg.sender, block.number);
1212     }
1213 
1214     function setOperator(address _operator) external onlyOperator {
1215         operator = _operator;
1216     }
1217 
1218     function setBoardroom(address _boardroom) external onlyOperator {
1219         boardroom = _boardroom;
1220     }
1221 
1222     function setGldmOracle(address _gldmOracle) external onlyOperator {
1223         gldmOracle = _gldmOracle;
1224     }
1225 
1226     function setGldmPriceCeiling(uint256 _gldmPriceCeiling) external onlyOperator {
1227         require(_gldmPriceCeiling >= gldmPriceOne && _gldmPriceCeiling <= gldmPriceOne.mul(120).div(100), "out of range"); // [$1.0, $1.2]
1228         gldmPriceCeiling = _gldmPriceCeiling;
1229     }
1230 
1231     function setMaxSupplyExpansionPercents(uint256 _maxSupplyExpansionPercent) external onlyOperator {
1232         require(_maxSupplyExpansionPercent >= 10 && _maxSupplyExpansionPercent <= 1000, "_maxSupplyExpansionPercent: out of range"); // [0.1%, 10%]
1233         maxSupplyExpansionPercent = _maxSupplyExpansionPercent;
1234     }
1235 
1236     function setSupplyTiersEntry(uint8 _index, uint256 _value) external onlyOperator returns (bool) {
1237         require(_index >= 0, "Index has to be higher than 0");
1238         require(_index < 9, "Index has to be lower than count of tiers");
1239         if (_index > 0) {
1240             require(_value > supplyTiers[_index - 1]);
1241         }
1242         if (_index < 8) {
1243             require(_value < supplyTiers[_index + 1]);
1244         }
1245         supplyTiers[_index] = _value;
1246         return true;
1247     }
1248 
1249     function setMaxExpansionTiersEntry(uint8 _index, uint256 _value) external onlyOperator returns (bool) {
1250         require(_index >= 0, "Index has to be higher than 0");
1251         require(_index < 9, "Index has to be lower than count of tiers");
1252         require(_value >= 10 && _value <= 1000, "_value: out of range"); // [0.1%, 10%]
1253         maxExpansionTiers[_index] = _value;
1254         return true;
1255     }
1256 
1257     function setBondDepletionFloorPercent(uint256 _bondDepletionFloorPercent) external onlyOperator {
1258         require(_bondDepletionFloorPercent >= 500 && _bondDepletionFloorPercent <= 10000, "out of range"); // [5%, 100%]
1259         bondDepletionFloorPercent = _bondDepletionFloorPercent;
1260     }
1261 
1262     function setMaxSupplyContractionPercent(uint256 _maxSupplyContractionPercent) external onlyOperator {
1263         require(_maxSupplyContractionPercent >= 100 && _maxSupplyContractionPercent <= 1500, "out of range"); // [0.1%, 15%]
1264         maxSupplyContractionPercent = _maxSupplyContractionPercent;
1265     }
1266 
1267     function setMaxDebtRatioPercent(uint256 _maxDebtRatioPercent) external onlyOperator {
1268         require(_maxDebtRatioPercent >= 1000 && _maxDebtRatioPercent <= 10000, "out of range"); // [10%, 100%]
1269         maxDebtRatioPercent = _maxDebtRatioPercent;
1270     }
1271 
1272     function setBootstrap(uint256 _bootstrapEpochs, uint256 _bootstrapSupplyExpansionPercent) external onlyOperator {
1273         require(_bootstrapEpochs <= 120, "_bootstrapEpochs: out of range"); // <= 1 month
1274         require(_bootstrapSupplyExpansionPercent >= 100 && _bootstrapSupplyExpansionPercent <= 1000, "_bootstrapSupplyExpansionPercent: out of range"); // [1%, 10%]
1275         bootstrapEpochs = _bootstrapEpochs;
1276         bootstrapSupplyExpansionPercent = _bootstrapSupplyExpansionPercent;
1277     }
1278 
1279     function setExtraFunds(
1280         address _daoFund,
1281         uint256 _daoFunsGldmdPercent,
1282         address _devFund,
1283         uint256 _devFunsGldmdPercent
1284     ) external onlyOperator {
1285         require(_daoFund != address(0), "zero");
1286         require(_daoFunsGldmdPercent <= 3000, "out of range"); // <= 30%
1287         require(_devFund != address(0), "zero");
1288         require(_devFunsGldmdPercent <= 1000, "out of range"); // <= 10%
1289         daoFund = _daoFund;
1290         daoFunsGldmdPercent = _daoFunsGldmdPercent;
1291         devFund = _devFund;
1292         devFunsGldmdPercent = _devFunsGldmdPercent;
1293     }
1294 
1295     function setMaxDiscountRate(uint256 _maxDiscountRate) external onlyOperator {
1296         maxDiscountRate = _maxDiscountRate;
1297     }
1298 
1299     function setMaxPremiumRate(uint256 _maxPremiumRate) external onlyOperator {
1300         maxPremiumRate = _maxPremiumRate;
1301     }
1302 
1303     function setDiscountPercent(uint256 _discountPercent) external onlyOperator {
1304         require(_discountPercent <= 20000, "_discountPercent is over 200%");
1305         discountPercent = _discountPercent;
1306     }
1307 
1308     function setPremiumThreshold(uint256 _premiumThreshold) external onlyOperator {
1309         require(_premiumThreshold >= gldmPriceCeiling, "_premiumThreshold exceeds gldmPriceCeiling");
1310         require(_premiumThreshold <= 150, "_premiumThreshold is higher than 1.5");
1311         premiumThreshold = _premiumThreshold;
1312     }
1313 
1314     function setPremiumPercent(uint256 _premiumPercent) external onlyOperator {
1315         require(_premiumPercent <= 20000, "_premiumPercent is over 200%");
1316         premiumPercent = _premiumPercent;
1317     }
1318 
1319     function setMintingFactorForPayingDebt(uint256 _mintingFactorForPayingDebt) external onlyOperator {
1320         require(_mintingFactorForPayingDebt >= 10000 && _mintingFactorForPayingDebt <= 20000, "_mintingFactorForPayingDebt: out of range"); // [100%, 200%]
1321         mintingFactorForPayingDebt = _mintingFactorForPayingDebt;
1322     }
1323 
1324     /* ========== MUTABLE FUNCTIONS ========== */
1325 
1326     function _updateGldmPrice() internal {
1327         try IOracle(gldmOracle).update() {} catch {}
1328     }
1329 
1330     function getGldmCirculatingSupply() public view returns (uint256) {
1331         IERC20 gldmErc20 = IERC20(gldm);
1332         uint256 totalSupply = gldmErc20.totalSupply();
1333         uint256 balanceExcluded = 0;
1334         for (uint8 entryId = 0; entryId < excludedFromTotalSupply.length; ++entryId) {
1335             balanceExcluded = balanceExcluded.add(gldmErc20.balanceOf(excludedFromTotalSupply[entryId]));
1336         }
1337         return totalSupply.sub(balanceExcluded);
1338     }
1339 
1340     function buyBonds(uint256 _gldmAmount, uint256 targetPrice) external onlyOneBlock checkCondition checkOperator {
1341         require(_gldmAmount > 0, "Treasury: cannot purchase bonds with zero amount");
1342 
1343         uint256 gldmPrice = getGldmPrice();
1344         require(gldmPrice == targetPrice, "Treasury: GLDM price moved");
1345         require(
1346             gldmPrice < gldmPriceOne, // price < $1
1347             "Treasury: gldmPrice not eligible for bond purchase"
1348         );
1349 
1350         require(_gldmAmount <= epochSupplyContractionLeft, "Treasury: not enough bond left to purchase");
1351 
1352         uint256 _rate = getBondDiscountRate();
1353         require(_rate > 0, "Treasury: invalid bond rate");
1354 
1355         uint256 _bondAmount = _gldmAmount.mul(_rate).div(1e18);
1356         uint256 gldmSupply = getGldmCirculatingSupply();
1357         uint256 newBondSupply = IERC20(bgldm).totalSupply().add(_bondAmount);
1358         require(newBondSupply <= gldmSupply.mul(maxDebtRatioPercent).div(10000), "over max debt ratio");
1359 
1360         IBasisAsset(gldm).burnFrom(msg.sender, _gldmAmount);
1361         IBasisAsset(bgldm).mint(msg.sender, _bondAmount);
1362 
1363         epochSupplyContractionLeft = epochSupplyContractionLeft.sub(_gldmAmount);
1364         _updateGldmPrice();
1365 
1366         emit BoughtBonds(msg.sender, _gldmAmount, _bondAmount);
1367     }
1368 
1369     function redeemBonds(uint256 _bondAmount, uint256 targetPrice) external onlyOneBlock checkCondition checkOperator {
1370         require(_bondAmount > 0, "Treasury: cannot redeem bonds with zero amount");
1371 
1372         uint256 gldmPrice = getGldmPrice();
1373         require(gldmPrice == targetPrice, "Treasury: GLDM price moved");
1374         require(
1375             gldmPrice > gldmPriceCeiling, // price > $1.01
1376             "Treasury: gldmPrice not eligible for bond purchase"
1377         );
1378 
1379         uint256 _rate = getBondPremiumRate();
1380         require(_rate > 0, "Treasury: invalid bond rate");
1381 
1382         uint256 _gldmAmount = _bondAmount.mul(_rate).div(1e18);
1383         require(IERC20(gldm).balanceOf(address(this)) >= _gldmAmount, "Treasury: treasury has no more budget");
1384 
1385         seigniorageSaved = seigniorageSaved.sub(Math.min(seigniorageSaved, _gldmAmount));
1386 
1387         IBasisAsset(bgldm).burnFrom(msg.sender, _bondAmount);
1388         IERC20(gldm).safeTransfer(msg.sender, _gldmAmount);
1389 
1390         _updateGldmPrice();
1391 
1392         emit RedeemedBonds(msg.sender, _gldmAmount, _bondAmount);
1393     }
1394 
1395     function _sendToBoardroom(uint256 _amount) internal {
1396         IBasisAsset(gldm).mint(address(this), _amount);
1397 
1398         uint256 _daoFunsGldmdAmount = 0;
1399         if (daoFunsGldmdPercent > 0) {
1400             _daoFunsGldmdAmount = _amount.mul(daoFunsGldmdPercent).div(10000);
1401             IERC20(gldm).transfer(daoFund, _daoFunsGldmdAmount);
1402             emit DaoFundFunded(now, _daoFunsGldmdAmount);
1403         }
1404 
1405         uint256 _devFunsGldmdAmount = 0;
1406         if (devFunsGldmdPercent > 0) {
1407             _devFunsGldmdAmount = _amount.mul(devFunsGldmdPercent).div(10000);
1408             IERC20(gldm).transfer(devFund, _devFunsGldmdAmount);
1409             emit DevFundFunded(now, _devFunsGldmdAmount);
1410         }
1411 
1412         _amount = _amount.sub(_daoFunsGldmdAmount).sub(_devFunsGldmdAmount);
1413 
1414         IERC20(gldm).safeApprove(boardroom, 0);
1415         IERC20(gldm).safeApprove(boardroom, _amount);
1416         IBoardroom(boardroom).allocateSeigniorage(_amount);
1417         emit BoardroomFunded(now, _amount);
1418     }
1419 
1420     function _calculateMaxSupplyExpansionPercent(uint256 _gldmSupply) internal returns (uint256) {
1421         for (uint8 tierId = 8; tierId >= 0; --tierId) {
1422             if (_gldmSupply >= supplyTiers[tierId]) {
1423                 maxSupplyExpansionPercent = maxExpansionTiers[tierId];
1424                 break;
1425             }
1426         }
1427         return maxSupplyExpansionPercent;
1428     }
1429 
1430     function allocateSeigniorage() external onlyOneBlock checkCondition checkEpoch checkOperator {
1431         _updateGldmPrice();
1432         previousEpochGldmPrice = getGldmPrice();
1433         uint256 gldmSupply = getGldmCirculatingSupply().sub(seigniorageSaved);
1434         if (epoch < bootstrapEpochs) {
1435             // 28 first epochs with 4.5% expansion
1436             _sendToBoardroom(gldmSupply.mul(bootstrapSupplyExpansionPercent).div(10000));
1437         } else {
1438             if (previousEpochGldmPrice > gldmPriceCeiling) {
1439                 // Expansion ($GLDM Price > 1 $ETH): there is some seigniorage to be allocated
1440                 uint256 bondSupply = IERC20(bgldm).totalSupply();
1441                 uint256 _percentage = previousEpochGldmPrice.sub(gldmPriceOne);
1442                 uint256 _savedForBond;
1443                 uint256 _savedForBoardroom;
1444                 uint256 _mse = _calculateMaxSupplyExpansionPercent(gldmSupply).mul(1e14);
1445                 if (_percentage > _mse) {
1446                     _percentage = _mse;
1447                 }
1448                 if (seigniorageSaved >= bondSupply.mul(bondDepletionFloorPercent).div(10000)) {
1449                     // saved enough to pay debt, mint as usual rate
1450                     _savedForBoardroom = gldmSupply.mul(_percentage).div(1e18);
1451                 } else {
1452                     // have not saved enough to pay debt, mint more
1453                     uint256 _seigniorage = gldmSupply.mul(_percentage).div(1e18);
1454                     _savedForBoardroom = _seigniorage.mul(seigniorageExpansionFloorPercent).div(10000);
1455                     _savedForBond = _seigniorage.sub(_savedForBoardroom);
1456                     if (mintingFactorForPayingDebt > 0) {
1457                         _savedForBond = _savedForBond.mul(mintingFactorForPayingDebt).div(10000);
1458                     }
1459                 }
1460                 if (_savedForBoardroom > 0) {
1461                     _sendToBoardroom(_savedForBoardroom);
1462                 }
1463                 if (_savedForBond > 0) {
1464                     seigniorageSaved = seigniorageSaved.add(_savedForBond);
1465                     IBasisAsset(gldm).mint(address(this), _savedForBond);
1466                     emit TreasuryFunded(now, _savedForBond);
1467                 }
1468             }
1469         }
1470     }
1471 
1472     function governanceRecoverUnsupported(
1473         IERC20 _token,
1474         uint256 _amount,
1475         address _to
1476     ) external onlyOperator {
1477         // do not allow to drain core tokens
1478         require(address(_token) != address(gldm), "gldm");
1479         require(address(_token) != address(bgldm), "bond");
1480         require(address(_token) != address(sgldm), "share");
1481         _token.safeTransfer(_to, _amount);
1482     }
1483 
1484     function boardroomSetOperator(address _operator) external onlyOperator {
1485         IBoardroom(boardroom).setOperator(_operator);
1486     }
1487 
1488     function boardroomSetLockUp(uint256 _withdrawLockupEpochs, uint256 _rewardLockupEpochs) external onlyOperator {
1489         IBoardroom(boardroom).setLockUp(_withdrawLockupEpochs, _rewardLockupEpochs);
1490     }
1491 
1492     function boardroomAllocateSeigniorage(uint256 amount) external onlyOperator {
1493         IBoardroom(boardroom).allocateSeigniorage(amount);
1494     }
1495 
1496     function boardroomGovernanceRecoverUnsupported(
1497         address _token,
1498         uint256 _amount,
1499         address _to
1500     ) external onlyOperator {
1501         IBoardroom(boardroom).governanceRecoverUnsupported(_token, _amount, _to);
1502     }
1503 }