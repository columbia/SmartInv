1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
39 pragma solidity >=0.6.0 <0.8.0;
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
56      * @dev Returns the addition of two unsigned integers, with an overflow flag.
57      *
58      * _Available since v3.4._
59      */
60     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         uint256 c = a + b;
62         if (c < a) return (false, 0);
63         return (true, c);
64     }
65 
66     /**
67      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
68      *
69      * _Available since v3.4._
70      */
71     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         if (b > a) return (false, 0);
73         return (true, a - b);
74     }
75 
76     /**
77      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
78      *
79      * _Available since v3.4._
80      */
81     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) return (true, 0);
86         uint256 c = a * b;
87         if (c / a != b) return (false, 0);
88         return (true, c);
89     }
90 
91     /**
92      * @dev Returns the division of two unsigned integers, with a division by zero flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         if (b == 0) return (false, 0);
98         return (true, a / b);
99     }
100 
101     /**
102      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
103      *
104      * _Available since v3.4._
105      */
106     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         if (b == 0) return (false, 0);
108         return (true, a % b);
109     }
110 
111     /**
112      * @dev Returns the addition of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `+` operator.
116      *
117      * Requirements:
118      *
119      * - Addition cannot overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a, "SafeMath: addition overflow");
124         return c;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b <= a, "SafeMath: subtraction overflow");
139         return a - b;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         if (a == 0) return 0;
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156         return c;
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers, reverting on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         require(b > 0, "SafeMath: division by zero");
173         return a / b;
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
178      * reverting when dividing by zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b > 0, "SafeMath: modulo by zero");
190         return a % b;
191     }
192 
193     /**
194      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
195      * overflow (when the result is negative).
196      *
197      * CAUTION: This function is deprecated because it requires allocating memory for the error
198      * message unnecessarily. For custom revert reasons use {trySub}.
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b <= a, errorMessage);
208         return a - b;
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * CAUTION: This function is deprecated because it requires allocating memory for the error
216      * message unnecessarily. For custom revert reasons use {tryDiv}.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         return a / b;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * reverting with custom message when dividing by zero.
234      *
235      * CAUTION: This function is deprecated because it requires allocating memory for the error
236      * message unnecessarily. For custom revert reasons use {tryMod}.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b > 0, errorMessage);
248         return a % b;
249     }
250 }
251 
252 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
253 
254 
255 
256 pragma solidity >=0.6.0 <0.8.0;
257 
258 /**
259  * @dev Interface of the ERC20 standard as defined in the EIP.
260  */
261 interface IERC20 {
262     /**
263      * @dev Returns the amount of tokens in existence.
264      */
265     function totalSupply() external view returns (uint256);
266 
267     /**
268      * @dev Returns the amount of tokens owned by `account`.
269      */
270     function balanceOf(address account) external view returns (uint256);
271 
272     /**
273      * @dev Moves `amount` tokens from the caller's account to `recipient`.
274      *
275      * Returns a boolean value indicating whether the operation succeeded.
276      *
277      * Emits a {Transfer} event.
278      */
279     function transfer(address recipient, uint256 amount) external returns (bool);
280 
281     /**
282      * @dev Returns the remaining number of tokens that `spender` will be
283      * allowed to spend on behalf of `owner` through {transferFrom}. This is
284      * zero by default.
285      *
286      * This value changes when {approve} or {transferFrom} are called.
287      */
288     function allowance(address owner, address spender) external view returns (uint256);
289 
290     /**
291      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
292      *
293      * Returns a boolean value indicating whether the operation succeeded.
294      *
295      * IMPORTANT: Beware that changing an allowance with this method brings the risk
296      * that someone may use both the old and the new allowance by unfortunate
297      * transaction ordering. One possible solution to mitigate this race
298      * condition is to first reduce the spender's allowance to 0 and set the
299      * desired value afterwards:
300      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
301      *
302      * Emits an {Approval} event.
303      */
304     function approve(address spender, uint256 amount) external returns (bool);
305 
306     /**
307      * @dev Moves `amount` tokens from `sender` to `recipient` using the
308      * allowance mechanism. `amount` is then deducted from the caller's
309      * allowance.
310      *
311      * Returns a boolean value indicating whether the operation succeeded.
312      *
313      * Emits a {Transfer} event.
314      */
315     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
316 
317     /**
318      * @dev Emitted when `value` tokens are moved from one account (`from`) to
319      * another (`to`).
320      *
321      * Note that `value` may be zero.
322      */
323     event Transfer(address indexed from, address indexed to, uint256 value);
324 
325     /**
326      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
327      * a call to {approve}. `value` is the new allowance.
328      */
329     event Approval(address indexed owner, address indexed spender, uint256 value);
330 }
331 
332 // File: @openzeppelin/contracts/utils/Address.sol
333 
334 
335 
336 pragma solidity >=0.6.2 <0.8.0;
337 
338 /**
339  * @dev Collection of functions related to the address type
340  */
341 library Address {
342     /**
343      * @dev Returns true if `account` is a contract.
344      *
345      * [IMPORTANT]
346      * ====
347      * It is unsafe to assume that an address for which this function returns
348      * false is an externally-owned account (EOA) and not a contract.
349      *
350      * Among others, `isContract` will return false for the following
351      * types of addresses:
352      *
353      *  - an externally-owned account
354      *  - a contract in construction
355      *  - an address where a contract will be created
356      *  - an address where a contract lived, but was destroyed
357      * ====
358      */
359     function isContract(address account) internal view returns (bool) {
360         // This method relies on extcodesize, which returns 0 for contracts in
361         // construction, since the code is only stored at the end of the
362         // constructor execution.
363 
364         uint256 size;
365         // solhint-disable-next-line no-inline-assembly
366         assembly { size := extcodesize(account) }
367         return size > 0;
368     }
369 
370     /**
371      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
372      * `recipient`, forwarding all available gas and reverting on errors.
373      *
374      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
375      * of certain opcodes, possibly making contracts go over the 2300 gas limit
376      * imposed by `transfer`, making them unable to receive funds via
377      * `transfer`. {sendValue} removes this limitation.
378      *
379      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
380      *
381      * IMPORTANT: because control is transferred to `recipient`, care must be
382      * taken to not create reentrancy vulnerabilities. Consider using
383      * {ReentrancyGuard} or the
384      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
385      */
386     function sendValue(address payable recipient, uint256 amount) internal {
387         require(address(this).balance >= amount, "Address: insufficient balance");
388 
389         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
390         (bool success, ) = recipient.call{ value: amount }("");
391         require(success, "Address: unable to send value, recipient may have reverted");
392     }
393 
394     /**
395      * @dev Performs a Solidity function call using a low level `call`. A
396      * plain`call` is an unsafe replacement for a function call: use this
397      * function instead.
398      *
399      * If `target` reverts with a revert reason, it is bubbled up by this
400      * function (like regular Solidity function calls).
401      *
402      * Returns the raw returned data. To convert to the expected return value,
403      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
404      *
405      * Requirements:
406      *
407      * - `target` must be a contract.
408      * - calling `target` with `data` must not revert.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
413       return functionCall(target, data, "Address: low-level call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
418      * `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, 0, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but also transferring `value` wei to `target`.
429      *
430      * Requirements:
431      *
432      * - the calling contract must have an ETH balance of at least `value`.
433      * - the called Solidity function must be `payable`.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
443      * with `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
448         require(address(this).balance >= value, "Address: insufficient balance for call");
449         require(isContract(target), "Address: call to non-contract");
450 
451         // solhint-disable-next-line avoid-low-level-calls
452         (bool success, bytes memory returndata) = target.call{ value: value }(data);
453         return _verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
463         return functionStaticCall(target, data, "Address: low-level static call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
473         require(isContract(target), "Address: static call to non-contract");
474 
475         // solhint-disable-next-line avoid-low-level-calls
476         (bool success, bytes memory returndata) = target.staticcall(data);
477         return _verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
487         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
492      * but performing a delegate call.
493      *
494      * _Available since v3.4._
495      */
496     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
497         require(isContract(target), "Address: delegate call to non-contract");
498 
499         // solhint-disable-next-line avoid-low-level-calls
500         (bool success, bytes memory returndata) = target.delegatecall(data);
501         return _verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511 
512                 // solhint-disable-next-line no-inline-assembly
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
525 
526 
527 
528 pragma solidity >=0.6.0 <0.8.0;
529 
530 
531 
532 
533 /**
534  * @title SafeERC20
535  * @dev Wrappers around ERC20 operations that throw on failure (when the token
536  * contract returns false). Tokens that return no value (and instead revert or
537  * throw on failure) are also supported, non-reverting calls are assumed to be
538  * successful.
539  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
540  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
541  */
542 library SafeERC20 {
543     using SafeMath for uint256;
544     using Address for address;
545 
546     function safeTransfer(IERC20 token, address to, uint256 value) internal {
547         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
548     }
549 
550     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
551         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
552     }
553 
554     /**
555      * @dev Deprecated. This function has issues similar to the ones found in
556      * {IERC20-approve}, and its usage is discouraged.
557      *
558      * Whenever possible, use {safeIncreaseAllowance} and
559      * {safeDecreaseAllowance} instead.
560      */
561     function safeApprove(IERC20 token, address spender, uint256 value) internal {
562         // safeApprove should only be called when setting an initial allowance,
563         // or when resetting it to zero. To increase and decrease it, use
564         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
565         // solhint-disable-next-line max-line-length
566         require((value == 0) || (token.allowance(address(this), spender) == 0),
567             "SafeERC20: approve from non-zero to non-zero allowance"
568         );
569         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
570     }
571 
572     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
573         uint256 newAllowance = token.allowance(address(this), spender).add(value);
574         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
575     }
576 
577     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
578         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
579         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
580     }
581 
582     /**
583      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
584      * on the return value: the return value is optional (but if data is returned, it must not be false).
585      * @param token The token targeted by the call.
586      * @param data The call data (encoded using abi.encode or one of its variants).
587      */
588     function _callOptionalReturn(IERC20 token, bytes memory data) private {
589         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
590         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
591         // the target address contains contract code and also asserts for success in the low-level call.
592 
593         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
594         if (returndata.length > 0) { // Return data is optional
595             // solhint-disable-next-line max-line-length
596             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
597         }
598     }
599 }
600 
601 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
602 
603 
604 
605 pragma solidity >=0.6.0 <0.8.0;
606 
607 /**
608  * @dev Contract module that helps prevent reentrant calls to a function.
609  *
610  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
611  * available, which can be applied to functions to make sure there are no nested
612  * (reentrant) calls to them.
613  *
614  * Note that because there is a single `nonReentrant` guard, functions marked as
615  * `nonReentrant` may not call one another. This can be worked around by making
616  * those functions `private`, and then adding `external` `nonReentrant` entry
617  * points to them.
618  *
619  * TIP: If you would like to learn more about reentrancy and alternative ways
620  * to protect against it, check out our blog post
621  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
622  */
623 abstract contract ReentrancyGuard {
624     // Booleans are more expensive than uint256 or any type that takes up a full
625     // word because each write operation emits an extra SLOAD to first read the
626     // slot's contents, replace the bits taken up by the boolean, and then write
627     // back. This is the compiler's defense against contract upgrades and
628     // pointer aliasing, and it cannot be disabled.
629 
630     // The values being non-zero value makes deployment a bit more expensive,
631     // but in exchange the refund on every call to nonReentrant will be lower in
632     // amount. Since refunds are capped to a percentage of the total
633     // transaction's gas, it is best to keep them low in cases like this one, to
634     // increase the likelihood of the full refund coming into effect.
635     uint256 private constant _NOT_ENTERED = 1;
636     uint256 private constant _ENTERED = 2;
637 
638     uint256 private _status;
639 
640     constructor () internal {
641         _status = _NOT_ENTERED;
642     }
643 
644     /**
645      * @dev Prevents a contract from calling itself, directly or indirectly.
646      * Calling a `nonReentrant` function from another `nonReentrant`
647      * function is not supported. It is possible to prevent this from happening
648      * by making the `nonReentrant` function external, and make it call a
649      * `private` function that does the actual work.
650      */
651     modifier nonReentrant() {
652         // On the first call to nonReentrant, _notEntered will be true
653         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
654 
655         // Any calls to nonReentrant after this point will fail
656         _status = _ENTERED;
657 
658         _;
659 
660         // By storing the original value once again, a refund is triggered (see
661         // https://eips.ethereum.org/EIPS/eip-2200)
662         _status = _NOT_ENTERED;
663     }
664 }
665 
666 // File: @openzeppelin/contracts/utils/Context.sol
667 
668 
669 
670 pragma solidity >=0.6.0 <0.8.0;
671 
672 /*
673  * @dev Provides information about the current execution context, including the
674  * sender of the transaction and its data. While these are generally available
675  * via msg.sender and msg.data, they should not be accessed in such a direct
676  * manner, since when dealing with GSN meta-transactions the account sending and
677  * paying for execution may not be the actual sender (as far as an application
678  * is concerned).
679  *
680  * This contract is only required for intermediate, library-like contracts.
681  */
682 abstract contract Context {
683     function _msgSender() internal view virtual returns (address payable) {
684         return msg.sender;
685     }
686 
687     function _msgData() internal view virtual returns (bytes memory) {
688         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
689         return msg.data;
690     }
691 }
692 
693 // File: @openzeppelin/contracts/access/Ownable.sol
694 
695 
696 
697 pragma solidity >=0.6.0 <0.8.0;
698 
699 /**
700  * @dev Contract module which provides a basic access control mechanism, where
701  * there is an account (an owner) that can be granted exclusive access to
702  * specific functions.
703  *
704  * By default, the owner account will be the one that deploys the contract. This
705  * can later be changed with {transferOwnership}.
706  *
707  * This module is used through inheritance. It will make available the modifier
708  * `onlyOwner`, which can be applied to your functions to restrict their use to
709  * the owner.
710  */
711 abstract contract Ownable is Context {
712     address private _owner;
713 
714     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
715 
716     /**
717      * @dev Initializes the contract setting the deployer as the initial owner.
718      */
719     constructor () internal {
720         address msgSender = _msgSender();
721         _owner = msgSender;
722         emit OwnershipTransferred(address(0), msgSender);
723     }
724 
725     /**
726      * @dev Returns the address of the current owner.
727      */
728     function owner() public view virtual returns (address) {
729         return _owner;
730     }
731 
732     /**
733      * @dev Throws if called by any account other than the owner.
734      */
735     modifier onlyOwner() {
736         require(owner() == _msgSender(), "Ownable: caller is not the owner");
737         _;
738     }
739 
740     /**
741      * @dev Leaves the contract without owner. It will not be possible to call
742      * `onlyOwner` functions anymore. Can only be called by the current owner.
743      *
744      * NOTE: Renouncing ownership will leave the contract without an owner,
745      * thereby removing any functionality that is only available to the owner.
746      */
747     function renounceOwnership() public virtual onlyOwner {
748         emit OwnershipTransferred(_owner, address(0));
749         _owner = address(0);
750     }
751 
752     /**
753      * @dev Transfers ownership of the contract to a new account (`newOwner`).
754      * Can only be called by the current owner.
755      */
756     function transferOwnership(address newOwner) public virtual onlyOwner {
757         require(newOwner != address(0), "Ownable: new owner is the zero address");
758         emit OwnershipTransferred(_owner, newOwner);
759         _owner = newOwner;
760     }
761 }
762 
763 // File: contracts/Pausable.sol
764 
765 
766 
767 pragma solidity ^0.7.0;
768 
769 
770 // https://docs.synthetix.io/contracts/source/contracts/pausable
771 contract Pausable is Ownable {
772     uint public lastPauseTime;
773     bool public paused;
774 
775     constructor() {
776         // This contract is abstract, and thus cannot be instantiated directly
777         require(owner() != address(0), "Owner must be set");
778         // Paused will be false, and lastPauseTime will be 0 upon initialisation
779     }
780 
781     /**
782      * @notice Change the paused state of the contract
783      * @dev Only the contract owner may call this.
784      */
785     function setPaused(bool _paused) external onlyOwner {
786         // Ensure we're actually changing the state before we do anything
787         if (_paused == paused) {
788             return;
789         }
790 
791         // Set our paused state.
792         paused = _paused;
793 
794         // If applicable, set the last pause time.
795         if (paused) {
796             lastPauseTime = block.timestamp;
797         }
798 
799         // Let everyone know that our pause state has changed.
800         emit PauseChanged(paused);
801     }
802 
803     event PauseChanged(bool isPaused);
804 
805     modifier notPaused {
806         require(!paused, "This action cannot be performed while the contract is paused");
807         _;
808     }
809 }
810 
811 // File: contracts/StakingRewards.sol
812 
813 
814 pragma solidity ^0.7.0;
815 
816 
817 
818 
819 
820 
821 // Inheritance
822 
823 
824 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
825 contract StakingRewards is ReentrancyGuard, Pausable {
826     using SafeMath for uint256;
827     using SafeERC20 for IERC20;
828 
829     IERC20 public immutable rewardsToken;
830     IERC20 public immutable stakingToken;
831 
832     /* ========== STATE VARIABLES ========== */
833 
834     uint256 public periodFinish = 0;
835     uint256 public rewardRate = 0;
836     uint256 public rewardsDuration = 30 days;
837     uint256 public lastUpdateTime;
838     uint256 public rewardPerTokenStored;
839     uint256 public totalSupply;
840 
841     uint256 public poolCap;
842     uint256 public userCap;
843 
844     mapping(address => uint256) public userRewardPerTokenPaid;
845     mapping(address => uint256) public rewards;
846     mapping(address => uint256) public balanceOf;
847 
848     /* ========== CONSTRUCTOR ========== */
849 
850     constructor(address _rewardsToken, address _stakingToken, uint256 _poolCap, uint256 _userCap) {
851         rewardsToken = IERC20(_rewardsToken);
852         stakingToken = IERC20(_stakingToken);
853         poolCap = _poolCap;
854         userCap = _userCap;
855     }
856 
857     /* ========== VIEWS ========== */
858 
859     function lastTimeRewardApplicable() public view returns (uint256) {
860         return Math.min(block.timestamp, periodFinish);
861     }
862 
863     function rewardPerToken() public view returns (uint256) {
864         if (totalSupply == 0) {
865             return rewardPerTokenStored;
866         }
867         return
868             rewardPerTokenStored.add(
869                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(totalSupply)
870             );
871     }
872 
873     function earned(address account) public view returns (uint256) {
874         return balanceOf[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
875     }
876 
877     function getRewardForDuration() external view returns (uint256) {
878         return rewardRate.mul(rewardsDuration);
879     }
880 
881     /* ========== MUTATIVE FUNCTIONS ========== */
882 
883     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
884         require(amount > 0, "Cannot stake 0");
885         require(balanceOf[msg.sender].add(amount) <= userCap, "user cap reached");
886         require(totalSupply.add(amount) <= poolCap, "pool cap reached");
887         totalSupply = totalSupply.add(amount);
888         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
889         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
890         emit Staked(msg.sender, amount);
891     }
892 
893     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
894         require(amount > 0, "Cannot withdraw 0");
895         totalSupply = totalSupply.sub(amount);
896         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
897         stakingToken.safeTransfer(msg.sender, amount);
898         emit Withdrawn(msg.sender, amount);
899     }
900 
901     function getReward() public nonReentrant updateReward(msg.sender) {
902         uint256 reward = rewards[msg.sender];
903         if (reward > 0) {
904             rewards[msg.sender] = 0;
905             rewardsToken.safeTransfer(msg.sender, reward);
906             emit RewardPaid(msg.sender, reward);
907         }
908     }
909 
910     function exit() external {
911         withdraw(balanceOf[msg.sender]);
912         getReward();
913     }
914 
915     /* ========== RESTRICTED FUNCTIONS ========== */
916 
917     function notifyRewardAmount(uint256 reward) external onlyOwner updateReward(address(0)) {
918         if (block.timestamp >= periodFinish) {
919             rewardRate = reward.div(rewardsDuration);
920         } else {
921             uint256 remaining = periodFinish.sub(block.timestamp);
922             uint256 leftover = remaining.mul(rewardRate);
923             rewardRate = reward.add(leftover).div(rewardsDuration);
924         }
925 
926         // Ensure the provided reward amount is not more than the balance in the contract.
927         // This keeps the reward rate in the right range, preventing overflows due to
928         // very high values of rewardRate in the earned and rewardsPerToken functions;
929         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
930         uint balance = rewardsToken.balanceOf(address(this));
931         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
932 
933         lastUpdateTime = block.timestamp;
934         periodFinish = block.timestamp.add(rewardsDuration);
935         emit RewardAdded(reward);
936     }
937 
938     // End rewards emission earlier
939     function updatePeriodFinish(uint timestamp) external onlyOwner updateReward(address(0)) {
940         require(timestamp > block.timestamp + 7 days, "Cannot fishish rewards earlier then 1 week from now");
941         periodFinish = timestamp;
942     }
943 
944     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
945     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
946         require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");
947         IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
948         emit Recovered(tokenAddress, tokenAmount);
949     }
950 
951     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
952         require(
953             block.timestamp > periodFinish,
954             "Previous rewards period must be complete before changing the duration for the new period"
955         );
956         rewardsDuration = _rewardsDuration;
957         emit RewardsDurationUpdated(rewardsDuration);
958     }
959 
960     function updateUserCap(uint256 _userCap) external onlyOwner {
961         userCap =  _userCap;
962         emit UserCapUpdated(userCap);
963     }
964 
965     function updatePoolCap(uint256 _poolCap) external onlyOwner {
966         poolCap =  _poolCap;
967         emit PoolCapUpdated(poolCap);
968     }
969 
970     /* ========== MODIFIERS ========== */
971 
972     modifier updateReward(address account) {
973         rewardPerTokenStored = rewardPerToken();
974         lastUpdateTime = lastTimeRewardApplicable();
975         if (account != address(0)) {
976             rewards[account] = earned(account);
977             userRewardPerTokenPaid[account] = rewardPerTokenStored;
978         }
979         _;
980     }
981 
982     /* ========== EVENTS ========== */
983 
984     event RewardAdded(uint256 reward);
985     event Staked(address indexed user, uint256 amount);
986     event Withdrawn(address indexed user, uint256 amount);
987     event RewardPaid(address indexed user, uint256 reward);
988     event RewardsDurationUpdated(uint256 newDuration);
989     event UserCapUpdated(uint256 newUserCap);
990     event PoolCapUpdated(uint256 newPoolCap);
991     event Recovered(address token, uint256 amount);
992 }