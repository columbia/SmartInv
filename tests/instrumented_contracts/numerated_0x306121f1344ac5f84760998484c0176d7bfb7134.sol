1 // SPDX-License-Identifier: BUSL-1.1
2 
3 // File: @openzeppelin/contracts/math/SafeMath.sol
4 
5 
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         uint256 c = a + b;
30         if (c < a) return (false, 0);
31         return (true, c);
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         if (b > a) return (false, 0);
41         return (true, a - b);
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53         if (a == 0) return (true, 0);
54         uint256 c = a * b;
55         if (c / a != b) return (false, 0);
56         return (true, c);
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         if (b == 0) return (false, 0);
66         return (true, a / b);
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         if (b == 0) return (false, 0);
76         return (true, a % b);
77     }
78 
79     /**
80      * @dev Returns the addition of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `+` operator.
84      *
85      * Requirements:
86      *
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b <= a, "SafeMath: subtraction overflow");
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         if (a == 0) return 0;
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
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
140         require(b > 0, "SafeMath: division by zero");
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b > 0, "SafeMath: modulo by zero");
158         return a % b;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {trySub}.
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         return a - b;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * CAUTION: This function is deprecated because it requires allocating memory for the error
184      * message unnecessarily. For custom revert reasons use {tryDiv}.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         return a / b;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 // File: @openzeppelin/contracts/math/Math.sol
221 
222 
223 
224 pragma solidity >=0.6.0 <0.8.0;
225 
226 /**
227  * @dev Standard math utilities missing in the Solidity language.
228  */
229 library Math {
230     /**
231      * @dev Returns the largest of two numbers.
232      */
233     function max(uint256 a, uint256 b) internal pure returns (uint256) {
234         return a >= b ? a : b;
235     }
236 
237     /**
238      * @dev Returns the smallest of two numbers.
239      */
240     function min(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a < b ? a : b;
242     }
243 
244     /**
245      * @dev Returns the average of two numbers. The result is rounded towards
246      * zero.
247      */
248     function average(uint256 a, uint256 b) internal pure returns (uint256) {
249         // (a + b) / 2 can overflow, so we distribute
250         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
251     }
252 }
253 
254 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
255 
256 
257 
258 pragma solidity >=0.6.0 <0.8.0;
259 
260 /**
261  * @dev Contract module that helps prevent reentrant calls to a function.
262  *
263  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
264  * available, which can be applied to functions to make sure there are no nested
265  * (reentrant) calls to them.
266  *
267  * Note that because there is a single `nonReentrant` guard, functions marked as
268  * `nonReentrant` may not call one another. This can be worked around by making
269  * those functions `private`, and then adding `external` `nonReentrant` entry
270  * points to them.
271  *
272  * TIP: If you would like to learn more about reentrancy and alternative ways
273  * to protect against it, check out our blog post
274  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
275  */
276 abstract contract ReentrancyGuard {
277     // Booleans are more expensive than uint256 or any type that takes up a full
278     // word because each write operation emits an extra SLOAD to first read the
279     // slot's contents, replace the bits taken up by the boolean, and then write
280     // back. This is the compiler's defense against contract upgrades and
281     // pointer aliasing, and it cannot be disabled.
282 
283     // The values being non-zero value makes deployment a bit more expensive,
284     // but in exchange the refund on every call to nonReentrant will be lower in
285     // amount. Since refunds are capped to a percentage of the total
286     // transaction's gas, it is best to keep them low in cases like this one, to
287     // increase the likelihood of the full refund coming into effect.
288     uint256 private constant _NOT_ENTERED = 1;
289     uint256 private constant _ENTERED = 2;
290 
291     uint256 private _status;
292 
293     constructor () internal {
294         _status = _NOT_ENTERED;
295     }
296 
297     /**
298      * @dev Prevents a contract from calling itself, directly or indirectly.
299      * Calling a `nonReentrant` function from another `nonReentrant`
300      * function is not supported. It is possible to prevent this from happening
301      * by making the `nonReentrant` function external, and make it call a
302      * `private` function that does the actual work.
303      */
304     modifier nonReentrant() {
305         // On the first call to nonReentrant, _notEntered will be true
306         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
307 
308         // Any calls to nonReentrant after this point will fail
309         _status = _ENTERED;
310 
311         _;
312 
313         // By storing the original value once again, a refund is triggered (see
314         // https://eips.ethereum.org/EIPS/eip-2200)
315         _status = _NOT_ENTERED;
316     }
317 }
318 
319 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
320 
321 
322 
323 pragma solidity >=0.6.0 <0.8.0;
324 
325 /**
326  * @dev Interface of the ERC20 standard as defined in the EIP.
327  */
328 interface IERC20 {
329     /**
330      * @dev Returns the amount of tokens in existence.
331      */
332     function totalSupply() external view returns (uint256);
333 
334     /**
335      * @dev Returns the amount of tokens owned by `account`.
336      */
337     function balanceOf(address account) external view returns (uint256);
338 
339     /**
340      * @dev Moves `amount` tokens from the caller's account to `recipient`.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * Emits a {Transfer} event.
345      */
346     function transfer(address recipient, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Returns the remaining number of tokens that `spender` will be
350      * allowed to spend on behalf of `owner` through {transferFrom}. This is
351      * zero by default.
352      *
353      * This value changes when {approve} or {transferFrom} are called.
354      */
355     function allowance(address owner, address spender) external view returns (uint256);
356 
357     /**
358      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * IMPORTANT: Beware that changing an allowance with this method brings the risk
363      * that someone may use both the old and the new allowance by unfortunate
364      * transaction ordering. One possible solution to mitigate this race
365      * condition is to first reduce the spender's allowance to 0 and set the
366      * desired value afterwards:
367      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
368      *
369      * Emits an {Approval} event.
370      */
371     function approve(address spender, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Moves `amount` tokens from `sender` to `recipient` using the
375      * allowance mechanism. `amount` is then deducted from the caller's
376      * allowance.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * Emits a {Transfer} event.
381      */
382     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
383 
384     /**
385      * @dev Emitted when `value` tokens are moved from one account (`from`) to
386      * another (`to`).
387      *
388      * Note that `value` may be zero.
389      */
390     event Transfer(address indexed from, address indexed to, uint256 value);
391 
392     /**
393      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
394      * a call to {approve}. `value` is the new allowance.
395      */
396     event Approval(address indexed owner, address indexed spender, uint256 value);
397 }
398 
399 // File: @openzeppelin/contracts/utils/Address.sol
400 
401 
402 
403 pragma solidity >=0.6.2 <0.8.0;
404 
405 /**
406  * @dev Collection of functions related to the address type
407  */
408 library Address {
409     /**
410      * @dev Returns true if `account` is a contract.
411      *
412      * [IMPORTANT]
413      * ====
414      * It is unsafe to assume that an address for which this function returns
415      * false is an externally-owned account (EOA) and not a contract.
416      *
417      * Among others, `isContract` will return false for the following
418      * types of addresses:
419      *
420      *  - an externally-owned account
421      *  - a contract in construction
422      *  - an address where a contract will be created
423      *  - an address where a contract lived, but was destroyed
424      * ====
425      */
426     function isContract(address account) internal view returns (bool) {
427         // This method relies on extcodesize, which returns 0 for contracts in
428         // construction, since the code is only stored at the end of the
429         // constructor execution.
430 
431         uint256 size;
432         // solhint-disable-next-line no-inline-assembly
433         assembly { size := extcodesize(account) }
434         return size > 0;
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(address(this).balance >= amount, "Address: insufficient balance");
455 
456         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
457         (bool success, ) = recipient.call{ value: amount }("");
458         require(success, "Address: unable to send value, recipient may have reverted");
459     }
460 
461     /**
462      * @dev Performs a Solidity function call using a low level `call`. A
463      * plain`call` is an unsafe replacement for a function call: use this
464      * function instead.
465      *
466      * If `target` reverts with a revert reason, it is bubbled up by this
467      * function (like regular Solidity function calls).
468      *
469      * Returns the raw returned data. To convert to the expected return value,
470      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
471      *
472      * Requirements:
473      *
474      * - `target` must be a contract.
475      * - calling `target` with `data` must not revert.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
480       return functionCall(target, data, "Address: low-level call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
485      * `errorMessage` as a fallback revert reason when `target` reverts.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, 0, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but also transferring `value` wei to `target`.
496      *
497      * Requirements:
498      *
499      * - the calling contract must have an ETH balance of at least `value`.
500      * - the called Solidity function must be `payable`.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
510      * with `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
515         require(address(this).balance >= value, "Address: insufficient balance for call");
516         require(isContract(target), "Address: call to non-contract");
517 
518         // solhint-disable-next-line avoid-low-level-calls
519         (bool success, bytes memory returndata) = target.call{ value: value }(data);
520         return _verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
525      * but performing a static call.
526      *
527      * _Available since v3.3._
528      */
529     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
530         return functionStaticCall(target, data, "Address: low-level static call failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
535      * but performing a static call.
536      *
537      * _Available since v3.3._
538      */
539     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
540         require(isContract(target), "Address: static call to non-contract");
541 
542         // solhint-disable-next-line avoid-low-level-calls
543         (bool success, bytes memory returndata) = target.staticcall(data);
544         return _verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
549      * but performing a delegate call.
550      *
551      * _Available since v3.4._
552      */
553     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
554         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
564         require(isContract(target), "Address: delegate call to non-contract");
565 
566         // solhint-disable-next-line avoid-low-level-calls
567         (bool success, bytes memory returndata) = target.delegatecall(data);
568         return _verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
572         if (success) {
573             return returndata;
574         } else {
575             // Look for revert reason and bubble it up if present
576             if (returndata.length > 0) {
577                 // The easiest way to bubble the revert reason is using memory via assembly
578 
579                 // solhint-disable-next-line no-inline-assembly
580                 assembly {
581                     let returndata_size := mload(returndata)
582                     revert(add(32, returndata), returndata_size)
583                 }
584             } else {
585                 revert(errorMessage);
586             }
587         }
588     }
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
592 
593 
594 
595 pragma solidity >=0.6.0 <0.8.0;
596 
597 
598 
599 
600 /**
601  * @title SafeERC20
602  * @dev Wrappers around ERC20 operations that throw on failure (when the token
603  * contract returns false). Tokens that return no value (and instead revert or
604  * throw on failure) are also supported, non-reverting calls are assumed to be
605  * successful.
606  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
607  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
608  */
609 library SafeERC20 {
610     using SafeMath for uint256;
611     using Address for address;
612 
613     function safeTransfer(IERC20 token, address to, uint256 value) internal {
614         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
615     }
616 
617     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
618         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
619     }
620 
621     /**
622      * @dev Deprecated. This function has issues similar to the ones found in
623      * {IERC20-approve}, and its usage is discouraged.
624      *
625      * Whenever possible, use {safeIncreaseAllowance} and
626      * {safeDecreaseAllowance} instead.
627      */
628     function safeApprove(IERC20 token, address spender, uint256 value) internal {
629         // safeApprove should only be called when setting an initial allowance,
630         // or when resetting it to zero. To increase and decrease it, use
631         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
632         // solhint-disable-next-line max-line-length
633         require((value == 0) || (token.allowance(address(this), spender) == 0),
634             "SafeERC20: approve from non-zero to non-zero allowance"
635         );
636         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
637     }
638 
639     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
640         uint256 newAllowance = token.allowance(address(this), spender).add(value);
641         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
642     }
643 
644     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
645         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
646         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
647     }
648 
649     /**
650      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
651      * on the return value: the return value is optional (but if data is returned, it must not be false).
652      * @param token The token targeted by the call.
653      * @param data The call data (encoded using abi.encode or one of its variants).
654      */
655     function _callOptionalReturn(IERC20 token, bytes memory data) private {
656         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
657         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
658         // the target address contains contract code and also asserts for success in the low-level call.
659 
660         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
661         if (returndata.length > 0) { // Return data is optional
662             // solhint-disable-next-line max-line-length
663             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
664         }
665     }
666 }
667 
668 // File: contracts/libraries/MathExt.sol
669 
670 
671 pragma solidity 0.6.12;
672 
673 
674 library MathExt {
675     using SafeMath for uint256;
676 
677     uint256 public constant PRECISION = (10**18);
678 
679     /// @dev Returns x*y in precision
680     function mulInPrecision(uint256 x, uint256 y) internal pure returns (uint256) {
681         return x.mul(y) / PRECISION;
682     }
683 
684     /// @dev source: dsMath
685     /// @param xInPrecision should be < PRECISION, so this can not overflow
686     /// @return zInPrecision = (x/PRECISION) ^k * PRECISION
687     function unsafePowInPrecision(uint256 xInPrecision, uint256 k)
688         internal
689         pure
690         returns (uint256 zInPrecision)
691     {
692         require(xInPrecision <= PRECISION, "MathExt: x > PRECISION");
693         zInPrecision = k % 2 != 0 ? xInPrecision : PRECISION;
694 
695         for (k /= 2; k != 0; k /= 2) {
696             xInPrecision = (xInPrecision * xInPrecision) / PRECISION;
697 
698             if (k % 2 != 0) {
699                 zInPrecision = (zInPrecision * xInPrecision) / PRECISION;
700             }
701         }
702     }
703 
704     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
705     function sqrt(uint256 y) internal pure returns (uint256 z) {
706         if (y > 3) {
707             z = y;
708             uint256 x = y / 2 + 1;
709             while (x < z) {
710                 z = x;
711                 x = (y / x + x) / 2;
712             }
713         } else if (y != 0) {
714             z = 1;
715         }
716     }
717 }
718 
719 // File: contracts/libraries/FeeFomula.sol
720 
721 pragma solidity 0.6.12;
722 
723 
724 library FeeFomula {
725     using SafeMath for uint256;
726     using MathExt for uint256;
727 
728     uint256 private constant PRECISION = 10**18;
729     uint256 private constant R0 = 1477405064814996100; // 1.4774050648149961
730 
731     uint256 private constant C0 = (60 * PRECISION) / 10000;
732 
733     uint256 private constant A = uint256(PRECISION * 20000) / 27;
734     uint256 private constant B = uint256(PRECISION * 250) / 9;
735     uint256 private constant C1 = uint256(PRECISION * 985) / 27;
736     uint256 private constant U = (120 * PRECISION) / 100;
737 
738     uint256 private constant G = (836 * PRECISION) / 1000;
739     uint256 private constant F = 5 * PRECISION;
740     uint256 private constant L = (2 * PRECISION) / 10000;
741     // C2 = 25 * PRECISION - (F * (PRECISION - G)**2) / ((PRECISION - G)**2 + L * PRECISION)
742     uint256 private constant C2 = 20036905816356657810;
743 
744     /// @dev calculate fee from rFactorInPrecision, see section 3.2 in dmmSwap white paper
745     /// @dev fee in [15, 60] bps
746     /// @return fee percentage in Precision
747     function getFee(uint256 rFactorInPrecision) internal pure returns (uint256) {
748         if (rFactorInPrecision >= R0) {
749             return C0;
750         } else if (rFactorInPrecision >= PRECISION) {
751             // C1 + A * (r-U)^3 + b * (r -U)
752             if (rFactorInPrecision > U) {
753                 uint256 tmp = rFactorInPrecision - U;
754                 uint256 tmp3 = tmp.unsafePowInPrecision(3);
755                 return (C1.add(A.mulInPrecision(tmp3)).add(B.mulInPrecision(tmp))) / 10000;
756             } else {
757                 uint256 tmp = U - rFactorInPrecision;
758                 uint256 tmp3 = tmp.unsafePowInPrecision(3);
759                 return C1.sub(A.mulInPrecision(tmp3)).sub(B.mulInPrecision(tmp)) / 10000;
760             }
761         } else {
762             // [ C2 + sign(r - G) *  F * (r-G) ^2 / (L + (r-G) ^2) ] / 10000
763             uint256 tmp = (
764                 rFactorInPrecision > G ? (rFactorInPrecision - G) : (G - rFactorInPrecision)
765             );
766             tmp = tmp.unsafePowInPrecision(2);
767             uint256 tmp2 = F.mul(tmp).div(tmp.add(L));
768             if (rFactorInPrecision > G) {
769                 return C2.add(tmp2) / 10000;
770             } else {
771                 return C2.sub(tmp2) / 10000;
772             }
773         }
774     }
775 }
776 
777 // File: @openzeppelin/contracts/utils/Context.sol
778 
779 
780 
781 pragma solidity >=0.6.0 <0.8.0;
782 
783 /*
784  * @dev Provides information about the current execution context, including the
785  * sender of the transaction and its data. While these are generally available
786  * via msg.sender and msg.data, they should not be accessed in such a direct
787  * manner, since when dealing with GSN meta-transactions the account sending and
788  * paying for execution may not be the actual sender (as far as an application
789  * is concerned).
790  *
791  * This contract is only required for intermediate, library-like contracts.
792  */
793 abstract contract Context {
794     function _msgSender() internal view virtual returns (address payable) {
795         return msg.sender;
796     }
797 
798     function _msgData() internal view virtual returns (bytes memory) {
799         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
800         return msg.data;
801     }
802 }
803 
804 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
805 
806 
807 
808 pragma solidity >=0.6.0 <0.8.0;
809 
810 
811 
812 
813 /**
814  * @dev Implementation of the {IERC20} interface.
815  *
816  * This implementation is agnostic to the way tokens are created. This means
817  * that a supply mechanism has to be added in a derived contract using {_mint}.
818  * For a generic mechanism see {ERC20PresetMinterPauser}.
819  *
820  * TIP: For a detailed writeup see our guide
821  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
822  * to implement supply mechanisms].
823  *
824  * We have followed general OpenZeppelin guidelines: functions revert instead
825  * of returning `false` on failure. This behavior is nonetheless conventional
826  * and does not conflict with the expectations of ERC20 applications.
827  *
828  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
829  * This allows applications to reconstruct the allowance for all accounts just
830  * by listening to said events. Other implementations of the EIP may not emit
831  * these events, as it isn't required by the specification.
832  *
833  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
834  * functions have been added to mitigate the well-known issues around setting
835  * allowances. See {IERC20-approve}.
836  */
837 contract ERC20 is Context, IERC20 {
838     using SafeMath for uint256;
839 
840     mapping (address => uint256) private _balances;
841 
842     mapping (address => mapping (address => uint256)) private _allowances;
843 
844     uint256 private _totalSupply;
845 
846     string private _name;
847     string private _symbol;
848     uint8 private _decimals;
849 
850     /**
851      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
852      * a default value of 18.
853      *
854      * To select a different value for {decimals}, use {_setupDecimals}.
855      *
856      * All three of these values are immutable: they can only be set once during
857      * construction.
858      */
859     constructor (string memory name_, string memory symbol_) public {
860         _name = name_;
861         _symbol = symbol_;
862         _decimals = 18;
863     }
864 
865     /**
866      * @dev Returns the name of the token.
867      */
868     function name() public view virtual returns (string memory) {
869         return _name;
870     }
871 
872     /**
873      * @dev Returns the symbol of the token, usually a shorter version of the
874      * name.
875      */
876     function symbol() public view virtual returns (string memory) {
877         return _symbol;
878     }
879 
880     /**
881      * @dev Returns the number of decimals used to get its user representation.
882      * For example, if `decimals` equals `2`, a balance of `505` tokens should
883      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
884      *
885      * Tokens usually opt for a value of 18, imitating the relationship between
886      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
887      * called.
888      *
889      * NOTE: This information is only used for _display_ purposes: it in
890      * no way affects any of the arithmetic of the contract, including
891      * {IERC20-balanceOf} and {IERC20-transfer}.
892      */
893     function decimals() public view virtual returns (uint8) {
894         return _decimals;
895     }
896 
897     /**
898      * @dev See {IERC20-totalSupply}.
899      */
900     function totalSupply() public view virtual override returns (uint256) {
901         return _totalSupply;
902     }
903 
904     /**
905      * @dev See {IERC20-balanceOf}.
906      */
907     function balanceOf(address account) public view virtual override returns (uint256) {
908         return _balances[account];
909     }
910 
911     /**
912      * @dev See {IERC20-transfer}.
913      *
914      * Requirements:
915      *
916      * - `recipient` cannot be the zero address.
917      * - the caller must have a balance of at least `amount`.
918      */
919     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
920         _transfer(_msgSender(), recipient, amount);
921         return true;
922     }
923 
924     /**
925      * @dev See {IERC20-allowance}.
926      */
927     function allowance(address owner, address spender) public view virtual override returns (uint256) {
928         return _allowances[owner][spender];
929     }
930 
931     /**
932      * @dev See {IERC20-approve}.
933      *
934      * Requirements:
935      *
936      * - `spender` cannot be the zero address.
937      */
938     function approve(address spender, uint256 amount) public virtual override returns (bool) {
939         _approve(_msgSender(), spender, amount);
940         return true;
941     }
942 
943     /**
944      * @dev See {IERC20-transferFrom}.
945      *
946      * Emits an {Approval} event indicating the updated allowance. This is not
947      * required by the EIP. See the note at the beginning of {ERC20}.
948      *
949      * Requirements:
950      *
951      * - `sender` and `recipient` cannot be the zero address.
952      * - `sender` must have a balance of at least `amount`.
953      * - the caller must have allowance for ``sender``'s tokens of at least
954      * `amount`.
955      */
956     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
957         _transfer(sender, recipient, amount);
958         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
959         return true;
960     }
961 
962     /**
963      * @dev Atomically increases the allowance granted to `spender` by the caller.
964      *
965      * This is an alternative to {approve} that can be used as a mitigation for
966      * problems described in {IERC20-approve}.
967      *
968      * Emits an {Approval} event indicating the updated allowance.
969      *
970      * Requirements:
971      *
972      * - `spender` cannot be the zero address.
973      */
974     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
975         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
976         return true;
977     }
978 
979     /**
980      * @dev Atomically decreases the allowance granted to `spender` by the caller.
981      *
982      * This is an alternative to {approve} that can be used as a mitigation for
983      * problems described in {IERC20-approve}.
984      *
985      * Emits an {Approval} event indicating the updated allowance.
986      *
987      * Requirements:
988      *
989      * - `spender` cannot be the zero address.
990      * - `spender` must have allowance for the caller of at least
991      * `subtractedValue`.
992      */
993     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
994         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
995         return true;
996     }
997 
998     /**
999      * @dev Moves tokens `amount` from `sender` to `recipient`.
1000      *
1001      * This is internal function is equivalent to {transfer}, and can be used to
1002      * e.g. implement automatic token fees, slashing mechanisms, etc.
1003      *
1004      * Emits a {Transfer} event.
1005      *
1006      * Requirements:
1007      *
1008      * - `sender` cannot be the zero address.
1009      * - `recipient` cannot be the zero address.
1010      * - `sender` must have a balance of at least `amount`.
1011      */
1012     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1013         require(sender != address(0), "ERC20: transfer from the zero address");
1014         require(recipient != address(0), "ERC20: transfer to the zero address");
1015 
1016         _beforeTokenTransfer(sender, recipient, amount);
1017 
1018         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1019         _balances[recipient] = _balances[recipient].add(amount);
1020         emit Transfer(sender, recipient, amount);
1021     }
1022 
1023     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1024      * the total supply.
1025      *
1026      * Emits a {Transfer} event with `from` set to the zero address.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      */
1032     function _mint(address account, uint256 amount) internal virtual {
1033         require(account != address(0), "ERC20: mint to the zero address");
1034 
1035         _beforeTokenTransfer(address(0), account, amount);
1036 
1037         _totalSupply = _totalSupply.add(amount);
1038         _balances[account] = _balances[account].add(amount);
1039         emit Transfer(address(0), account, amount);
1040     }
1041 
1042     /**
1043      * @dev Destroys `amount` tokens from `account`, reducing the
1044      * total supply.
1045      *
1046      * Emits a {Transfer} event with `to` set to the zero address.
1047      *
1048      * Requirements:
1049      *
1050      * - `account` cannot be the zero address.
1051      * - `account` must have at least `amount` tokens.
1052      */
1053     function _burn(address account, uint256 amount) internal virtual {
1054         require(account != address(0), "ERC20: burn from the zero address");
1055 
1056         _beforeTokenTransfer(account, address(0), amount);
1057 
1058         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1059         _totalSupply = _totalSupply.sub(amount);
1060         emit Transfer(account, address(0), amount);
1061     }
1062 
1063     /**
1064      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1065      *
1066      * This internal function is equivalent to `approve`, and can be used to
1067      * e.g. set automatic allowances for certain subsystems, etc.
1068      *
1069      * Emits an {Approval} event.
1070      *
1071      * Requirements:
1072      *
1073      * - `owner` cannot be the zero address.
1074      * - `spender` cannot be the zero address.
1075      */
1076     function _approve(address owner, address spender, uint256 amount) internal virtual {
1077         require(owner != address(0), "ERC20: approve from the zero address");
1078         require(spender != address(0), "ERC20: approve to the zero address");
1079 
1080         _allowances[owner][spender] = amount;
1081         emit Approval(owner, spender, amount);
1082     }
1083 
1084     /**
1085      * @dev Sets {decimals} to a value other than the default one of 18.
1086      *
1087      * WARNING: This function should only be called from the constructor. Most
1088      * applications that interact with token contracts will not expect
1089      * {decimals} to ever change, and may work incorrectly if it does.
1090      */
1091     function _setupDecimals(uint8 decimals_) internal virtual {
1092         _decimals = decimals_;
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any transfer of tokens. This includes
1097      * minting and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1102      * will be to transferred to `to`.
1103      * - when `from` is zero, `amount` tokens will be minted for `to`.
1104      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1110 }
1111 
1112 // File: contracts/interfaces/IERC20Permit.sol
1113 
1114 
1115 pragma solidity 0.6.12;
1116 
1117 
1118 interface IERC20Permit is IERC20 {
1119     function permit(
1120         address owner,
1121         address spender,
1122         uint256 value,
1123         uint256 deadline,
1124         uint8 v,
1125         bytes32 r,
1126         bytes32 s
1127     ) external;
1128 }
1129 
1130 // File: contracts/libraries/ERC20Permit.sol
1131 
1132 
1133 pragma solidity 0.6.12;
1134 
1135 
1136 
1137 /// @dev https://eips.ethereum.org/EIPS/eip-2612
1138 contract ERC20Permit is ERC20, IERC20Permit {
1139     /// @dev To make etherscan auto-verify new pool, this variable is not immutable
1140     bytes32 public domainSeparator;
1141     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1142     bytes32
1143         public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1144 
1145     mapping(address => uint256) public nonces;
1146 
1147     constructor(
1148         string memory name,
1149         string memory symbol,
1150         string memory version
1151     ) public ERC20(name, symbol) {
1152         uint256 chainId;
1153         assembly {
1154             chainId := chainid()
1155         }
1156         domainSeparator = keccak256(
1157             abi.encode(
1158                 keccak256(
1159                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1160                 ),
1161                 keccak256(bytes(name)),
1162                 keccak256(bytes(version)),
1163                 chainId,
1164                 address(this)
1165             )
1166         );
1167     }
1168 
1169     function permit(
1170         address owner,
1171         address spender,
1172         uint256 value,
1173         uint256 deadline,
1174         uint8 v,
1175         bytes32 r,
1176         bytes32 s
1177     ) external override {
1178         require(deadline >= block.timestamp, "ERC20Permit: EXPIRED");
1179         bytes32 digest = keccak256(
1180             abi.encodePacked(
1181                 "\x19\x01",
1182                 domainSeparator,
1183                 keccak256(
1184                     abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline)
1185                 )
1186             )
1187         );
1188         address recoveredAddress = ecrecover(digest, v, r, s);
1189         require(
1190             recoveredAddress != address(0) && recoveredAddress == owner,
1191             "ERC20Permit: INVALID_SIGNATURE"
1192         );
1193         _approve(owner, spender, value);
1194     }
1195 }
1196 
1197 // File: contracts/interfaces/IDMMFactory.sol
1198 
1199 pragma solidity 0.6.12;
1200 
1201 
1202 interface IDMMFactory {
1203     function createPool(
1204         IERC20 tokenA,
1205         IERC20 tokenB,
1206         uint32 ampBps
1207     ) external returns (address pool);
1208 
1209     function setFeeConfiguration(address feeTo, uint16 governmentFeeBps) external;
1210 
1211     function setFeeToSetter(address) external;
1212 
1213     function getFeeConfiguration() external view returns (address feeTo, uint16 governmentFeeBps);
1214 
1215     function feeToSetter() external view returns (address);
1216 
1217     function allPools(uint256) external view returns (address pool);
1218 
1219     function allPoolsLength() external view returns (uint256);
1220 
1221     function getUnamplifiedPool(IERC20 token0, IERC20 token1) external view returns (address);
1222 
1223     function getPools(IERC20 token0, IERC20 token1)
1224         external
1225         view
1226         returns (address[] memory _tokenPools);
1227 
1228     function isPool(
1229         IERC20 token0,
1230         IERC20 token1,
1231         address pool
1232     ) external view returns (bool);
1233 }
1234 
1235 // File: contracts/interfaces/IDMMCallee.sol
1236 
1237 pragma solidity 0.6.12;
1238 
1239 interface IDMMCallee {
1240     function dmmSwapCall(
1241         address sender,
1242         uint256 amount0,
1243         uint256 amount1,
1244         bytes calldata data
1245     ) external;
1246 }
1247 
1248 // File: contracts/interfaces/IDMMPool.sol
1249 
1250 pragma solidity 0.6.12;
1251 
1252 
1253 
1254 interface IDMMPool {
1255     function mint(address to) external returns (uint256 liquidity);
1256 
1257     function burn(address to) external returns (uint256 amount0, uint256 amount1);
1258 
1259     function swap(
1260         uint256 amount0Out,
1261         uint256 amount1Out,
1262         address to,
1263         bytes calldata data
1264     ) external;
1265 
1266     function sync() external;
1267 
1268     function getReserves() external view returns (uint112 reserve0, uint112 reserve1);
1269 
1270     function getTradeInfo()
1271         external
1272         view
1273         returns (
1274             uint112 _vReserve0,
1275             uint112 _vReserve1,
1276             uint112 reserve0,
1277             uint112 reserve1,
1278             uint256 feeInPrecision
1279         );
1280 
1281     function token0() external view returns (IERC20);
1282 
1283     function token1() external view returns (IERC20);
1284 
1285     function ampBps() external view returns (uint32);
1286 
1287     function factory() external view returns (IDMMFactory);
1288 
1289     function kLast() external view returns (uint256);
1290 }
1291 
1292 // File: contracts/interfaces/IERC20Metadata.sol
1293 
1294 
1295 
1296 pragma solidity 0.6.12;
1297 
1298 
1299 /**
1300  * @dev Interface for the optional metadata functions from the ERC20 standard.
1301  */
1302 interface IERC20Metadata is IERC20 {
1303     /**
1304      * @dev Returns the name of the token.
1305      */
1306     function name() external view returns (string memory);
1307 
1308     /**
1309      * @dev Returns the symbol of the token.
1310      */
1311     function symbol() external view returns (string memory);
1312 
1313     /**
1314      * @dev Returns the decimals places of the token.
1315      */
1316     function decimals() external view returns (uint8);
1317 }
1318 
1319 // File: contracts/VolumeTrendRecorder.sol
1320 
1321 pragma solidity 0.6.12;
1322 
1323 
1324 /// @dev contract to calculate volume trend. See secion 3.1 in the white paper
1325 /// @dev EMA stands for Exponential moving average
1326 /// @dev https://en.wikipedia.org/wiki/Moving_average
1327 contract VolumeTrendRecorder {
1328     using MathExt for uint256;
1329     using SafeMath for uint256;
1330 
1331     uint256 private constant MAX_UINT128 = 2**128 - 1;
1332     uint256 internal constant PRECISION = 10**18;
1333     uint256 private constant SHORT_ALPHA = (2 * PRECISION) / 5401;
1334     uint256 private constant LONG_ALPHA = (2 * PRECISION) / 10801;
1335 
1336     uint128 internal shortEMA;
1337     uint128 internal longEMA;
1338     // total volume in current block
1339     uint128 internal currentBlockVolume;
1340     uint128 internal lastTradeBlock;
1341 
1342     event UpdateEMA(uint256 shortEMA, uint256 longEMA, uint128 lastBlockVolume, uint256 skipBlock);
1343 
1344     constructor(uint128 _emaInit) public {
1345         shortEMA = _emaInit;
1346         longEMA = _emaInit;
1347         lastTradeBlock = safeUint128(block.number);
1348     }
1349 
1350     function getVolumeTrendData()
1351         external
1352         view
1353         returns (
1354             uint128 _shortEMA,
1355             uint128 _longEMA,
1356             uint128 _currentBlockVolume,
1357             uint128 _lastTradeBlock
1358         )
1359     {
1360         _shortEMA = shortEMA;
1361         _longEMA = longEMA;
1362         _currentBlockVolume = currentBlockVolume;
1363         _lastTradeBlock = lastTradeBlock;
1364     }
1365 
1366     /// @dev records a new trade, update ema and returns current rFactor for this trade
1367     /// @return rFactor in Precision for this trade
1368     function recordNewUpdatedVolume(uint256 blockNumber, uint256 value)
1369         internal
1370         returns (uint256)
1371     {
1372         // this can not be underflow because block.number always increases
1373         uint256 skipBlock = blockNumber - lastTradeBlock;
1374         if (skipBlock == 0) {
1375             currentBlockVolume = safeUint128(
1376                 uint256(currentBlockVolume).add(value),
1377                 "volume exceeds valid range"
1378             );
1379             return calculateRFactor(uint256(shortEMA), uint256(longEMA));
1380         }
1381         uint128 _currentBlockVolume = currentBlockVolume;
1382         uint256 _shortEMA = newEMA(shortEMA, SHORT_ALPHA, currentBlockVolume);
1383         uint256 _longEMA = newEMA(longEMA, LONG_ALPHA, currentBlockVolume);
1384         // ema = ema * (1-aplha) ^(skipBlock -1)
1385         _shortEMA = _shortEMA.mulInPrecision(
1386             (PRECISION - SHORT_ALPHA).unsafePowInPrecision(skipBlock - 1)
1387         );
1388         _longEMA = _longEMA.mulInPrecision(
1389             (PRECISION - LONG_ALPHA).unsafePowInPrecision(skipBlock - 1)
1390         );
1391         shortEMA = safeUint128(_shortEMA);
1392         longEMA = safeUint128(_longEMA);
1393         currentBlockVolume = safeUint128(value);
1394         lastTradeBlock = safeUint128(blockNumber);
1395 
1396         emit UpdateEMA(_shortEMA, _longEMA, _currentBlockVolume, skipBlock);
1397 
1398         return calculateRFactor(_shortEMA, _longEMA);
1399     }
1400 
1401     /// @return rFactor in Precision for this trade
1402     function getRFactor(uint256 blockNumber) internal view returns (uint256) {
1403         // this can not be underflow because block.number always increases
1404         uint256 skipBlock = blockNumber - lastTradeBlock;
1405         if (skipBlock == 0) {
1406             return calculateRFactor(shortEMA, longEMA);
1407         }
1408         uint256 _shortEMA = newEMA(shortEMA, SHORT_ALPHA, currentBlockVolume);
1409         uint256 _longEMA = newEMA(longEMA, LONG_ALPHA, currentBlockVolume);
1410         _shortEMA = _shortEMA.mulInPrecision(
1411             (PRECISION - SHORT_ALPHA).unsafePowInPrecision(skipBlock - 1)
1412         );
1413         _longEMA = _longEMA.mulInPrecision(
1414             (PRECISION - LONG_ALPHA).unsafePowInPrecision(skipBlock - 1)
1415         );
1416         return calculateRFactor(_shortEMA, _longEMA);
1417     }
1418 
1419     function calculateRFactor(uint256 _shortEMA, uint256 _longEMA)
1420         internal
1421         pure
1422         returns (uint256)
1423     {
1424         if (_longEMA == 0) {
1425             return 0;
1426         }
1427         return (_shortEMA * MathExt.PRECISION) / _longEMA;
1428     }
1429 
1430     /// @dev return newEMA value
1431     /// @param ema previous ema value in wei
1432     /// @param alpha in Precicion (required < Precision)
1433     /// @param value current value to update ema
1434     /// @dev ema and value is uint128 and alpha < Percison
1435     /// @dev so this function can not overflow and returned ema is not overflow uint128
1436     function newEMA(
1437         uint128 ema,
1438         uint256 alpha,
1439         uint128 value
1440     ) internal pure returns (uint256) {
1441         assert(alpha < PRECISION);
1442         return ((PRECISION - alpha) * uint256(ema) + alpha * uint256(value)) / PRECISION;
1443     }
1444 
1445     function safeUint128(uint256 v) internal pure returns (uint128) {
1446         require(v <= MAX_UINT128, "overflow uint128");
1447         return uint128(v);
1448     }
1449 
1450     function safeUint128(uint256 v, string memory errorMessage) internal pure returns (uint128) {
1451         require(v <= MAX_UINT128, errorMessage);
1452         return uint128(v);
1453     }
1454 }
1455 
1456 // File: contracts/DMMPool.sol
1457 
1458 pragma solidity 0.6.12;
1459 
1460 
1461 
1462 
1463 
1464 
1465 
1466 
1467 
1468 
1469 
1470 
1471 
1472 contract DMMPool is IDMMPool, ERC20Permit, ReentrancyGuard, VolumeTrendRecorder {
1473     using SafeMath for uint256;
1474     using SafeERC20 for IERC20;
1475 
1476     uint256 internal constant MAX_UINT112 = 2**112 - 1;
1477     uint256 internal constant BPS = 10000;
1478 
1479     struct ReserveData {
1480         uint256 reserve0;
1481         uint256 reserve1;
1482         uint256 vReserve0;
1483         uint256 vReserve1; // only used when isAmpPool = true
1484     }
1485 
1486     uint256 public constant MINIMUM_LIQUIDITY = 10**3;
1487     /// @dev To make etherscan auto-verify new pool, these variables are not immutable
1488     IDMMFactory public override factory;
1489     IERC20 public override token0;
1490     IERC20 public override token1;
1491 
1492     /// @dev uses single storage slot, accessible via getReservesData
1493     uint112 internal reserve0;
1494     uint112 internal reserve1;
1495     uint32 public override ampBps;
1496     /// @dev addition param only when amplification factor > 1
1497     uint112 internal vReserve0;
1498     uint112 internal vReserve1;
1499 
1500     /// @dev vReserve0 * vReserve1, as of immediately after the most recent liquidity event
1501     uint256 public override kLast;
1502 
1503     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1504     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
1505     event Swap(
1506         address indexed sender,
1507         uint256 amount0In,
1508         uint256 amount1In,
1509         uint256 amount0Out,
1510         uint256 amount1Out,
1511         address indexed to,
1512         uint256 feeInPrecision
1513     );
1514     event Sync(uint256 vReserve0, uint256 vReserve1, uint256 reserve0, uint256 reserve1);
1515 
1516     constructor() public ERC20Permit("KyberDMM LP", "DMM-LP", "1") VolumeTrendRecorder(0) {
1517         factory = IDMMFactory(msg.sender);
1518     }
1519 
1520     // called once by the factory at time of deployment
1521     function initialize(
1522         IERC20 _token0,
1523         IERC20 _token1,
1524         uint32 _ampBps
1525     ) external {
1526         require(msg.sender == address(factory), "DMM: FORBIDDEN");
1527         token0 = _token0;
1528         token1 = _token1;
1529         ampBps = _ampBps;
1530     }
1531 
1532     /// @dev this low-level function should be called from a contract
1533     ///                 which performs important safety checks
1534     function mint(address to) external override nonReentrant returns (uint256 liquidity) {
1535         (bool isAmpPool, ReserveData memory data) = getReservesData();
1536         ReserveData memory _data;
1537         _data.reserve0 = token0.balanceOf(address(this));
1538         _data.reserve1 = token1.balanceOf(address(this));
1539         uint256 amount0 = _data.reserve0.sub(data.reserve0);
1540         uint256 amount1 = _data.reserve1.sub(data.reserve1);
1541 
1542         bool feeOn = _mintFee(isAmpPool, data);
1543         uint256 _totalSupply = totalSupply(); // gas savings, must be defined here since totalSupply can update in _mintFee
1544         if (_totalSupply == 0) {
1545             if (isAmpPool) {
1546                 uint32 _ampBps = ampBps;
1547                 _data.vReserve0 = _data.reserve0.mul(_ampBps) / BPS;
1548                 _data.vReserve1 = _data.reserve1.mul(_ampBps) / BPS;
1549             }
1550             liquidity = MathExt.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
1551             _mint(address(-1), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
1552         } else {
1553             liquidity = Math.min(
1554                 amount0.mul(_totalSupply) / data.reserve0,
1555                 amount1.mul(_totalSupply) / data.reserve1
1556             );
1557             if (isAmpPool) {
1558                 uint256 b = liquidity.add(_totalSupply);
1559                 _data.vReserve0 = Math.max(data.vReserve0.mul(b) / _totalSupply, _data.reserve0);
1560                 _data.vReserve1 = Math.max(data.vReserve1.mul(b) / _totalSupply, _data.reserve1);
1561             }
1562         }
1563         require(liquidity > 0, "DMM: INSUFFICIENT_LIQUIDITY_MINTED");
1564         _mint(to, liquidity);
1565 
1566         _update(isAmpPool, _data);
1567         if (feeOn) kLast = getK(isAmpPool, _data);
1568         emit Mint(msg.sender, amount0, amount1);
1569     }
1570 
1571     /// @dev this low-level function should be called from a contract
1572     /// @dev which performs important safety checks
1573     /// @dev user must transfer LP token to this contract before call burn
1574     function burn(address to)
1575         external
1576         override
1577         nonReentrant
1578         returns (uint256 amount0, uint256 amount1)
1579     {
1580         (bool isAmpPool, ReserveData memory data) = getReservesData(); // gas savings
1581         IERC20 _token0 = token0; // gas savings
1582         IERC20 _token1 = token1; // gas savings
1583 
1584         uint256 balance0 = _token0.balanceOf(address(this));
1585         uint256 balance1 = _token1.balanceOf(address(this));
1586         require(balance0 >= data.reserve0 && balance1 >= data.reserve1, "DMM: UNSYNC_RESERVES");
1587         uint256 liquidity = balanceOf(address(this));
1588 
1589         bool feeOn = _mintFee(isAmpPool, data);
1590         uint256 _totalSupply = totalSupply(); // gas savings, must be defined here since totalSupply can update in _mintFee
1591         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
1592         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
1593         require(amount0 > 0 && amount1 > 0, "DMM: INSUFFICIENT_LIQUIDITY_BURNED");
1594         _burn(address(this), liquidity);
1595         _token0.safeTransfer(to, amount0);
1596         _token1.safeTransfer(to, amount1);
1597         ReserveData memory _data;
1598         _data.reserve0 = _token0.balanceOf(address(this));
1599         _data.reserve1 = _token1.balanceOf(address(this));
1600         if (isAmpPool) {
1601             uint256 b = Math.min(
1602                 _data.reserve0.mul(_totalSupply) / data.reserve0,
1603                 _data.reserve1.mul(_totalSupply) / data.reserve1
1604             );
1605             _data.vReserve0 = Math.max(data.vReserve0.mul(b) / _totalSupply, _data.reserve0);
1606             _data.vReserve1 = Math.max(data.vReserve1.mul(b) / _totalSupply, _data.reserve1);
1607         }
1608         _update(isAmpPool, _data);
1609         if (feeOn) kLast = getK(isAmpPool, _data); // data are up-to-date
1610         emit Burn(msg.sender, amount0, amount1, to);
1611     }
1612 
1613     /// @dev this low-level function should be called from a contract
1614     /// @dev which performs important safety checks
1615     function swap(
1616         uint256 amount0Out,
1617         uint256 amount1Out,
1618         address to,
1619         bytes calldata callbackData
1620     ) external override nonReentrant {
1621         require(amount0Out > 0 || amount1Out > 0, "DMM: INSUFFICIENT_OUTPUT_AMOUNT");
1622         (bool isAmpPool, ReserveData memory data) = getReservesData(); // gas savings
1623         require(
1624             amount0Out < data.reserve0 && amount1Out < data.reserve1,
1625             "DMM: INSUFFICIENT_LIQUIDITY"
1626         );
1627 
1628         ReserveData memory newData;
1629         {
1630             // scope for _token{0,1}, avoids stack too deep errors
1631             IERC20 _token0 = token0;
1632             IERC20 _token1 = token1;
1633             require(to != address(_token0) && to != address(_token1), "DMM: INVALID_TO");
1634             if (amount0Out > 0) _token0.safeTransfer(to, amount0Out); // optimistically transfer tokens
1635             if (amount1Out > 0) _token1.safeTransfer(to, amount1Out); // optimistically transfer tokens
1636             if (callbackData.length > 0)
1637                 IDMMCallee(to).dmmSwapCall(msg.sender, amount0Out, amount1Out, callbackData);
1638             newData.reserve0 = _token0.balanceOf(address(this));
1639             newData.reserve1 = _token1.balanceOf(address(this));
1640             if (isAmpPool) {
1641                 newData.vReserve0 = data.vReserve0.add(newData.reserve0).sub(data.reserve0);
1642                 newData.vReserve1 = data.vReserve1.add(newData.reserve1).sub(data.reserve1);
1643             }
1644         }
1645         uint256 amount0In = newData.reserve0 > data.reserve0 - amount0Out
1646             ? newData.reserve0 - (data.reserve0 - amount0Out)
1647             : 0;
1648         uint256 amount1In = newData.reserve1 > data.reserve1 - amount1Out
1649             ? newData.reserve1 - (data.reserve1 - amount1Out)
1650             : 0;
1651         require(amount0In > 0 || amount1In > 0, "DMM: INSUFFICIENT_INPUT_AMOUNT");
1652         uint256 feeInPrecision = verifyBalanceAndUpdateEma(
1653             amount0In,
1654             amount1In,
1655             isAmpPool ? data.vReserve0 : data.reserve0,
1656             isAmpPool ? data.vReserve1 : data.reserve1,
1657             isAmpPool ? newData.vReserve0 : newData.reserve0,
1658             isAmpPool ? newData.vReserve1 : newData.reserve1
1659         );
1660 
1661         _update(isAmpPool, newData);
1662         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to, feeInPrecision);
1663     }
1664 
1665     /// @dev force balances to match reserves
1666     function skim(address to) external nonReentrant {
1667         token0.safeTransfer(to, token0.balanceOf(address(this)).sub(reserve0));
1668         token1.safeTransfer(to, token1.balanceOf(address(this)).sub(reserve1));
1669     }
1670 
1671     /// @dev force reserves to match balances
1672     function sync() external override nonReentrant {
1673         (bool isAmpPool, ReserveData memory data) = getReservesData();
1674         bool feeOn = _mintFee(isAmpPool, data);
1675         ReserveData memory newData;
1676         newData.reserve0 = IERC20(token0).balanceOf(address(this));
1677         newData.reserve1 = IERC20(token1).balanceOf(address(this));
1678         // update virtual reserves if this is amp pool
1679         if (isAmpPool) {
1680             uint256 _totalSupply = totalSupply();
1681             uint256 b = Math.min(
1682                 newData.reserve0.mul(_totalSupply) / data.reserve0,
1683                 newData.reserve1.mul(_totalSupply) / data.reserve1
1684             );
1685             newData.vReserve0 = Math.max(data.vReserve0.mul(b) / _totalSupply, newData.reserve0);
1686             newData.vReserve1 = Math.max(data.vReserve1.mul(b) / _totalSupply, newData.reserve1);
1687         }
1688         _update(isAmpPool, newData);
1689         if (feeOn) kLast = getK(isAmpPool, newData);
1690     }
1691 
1692     /// @dev returns data to calculate amountIn, amountOut
1693     function getTradeInfo()
1694         external
1695         virtual
1696         override
1697         view
1698         returns (
1699             uint112 _reserve0,
1700             uint112 _reserve1,
1701             uint112 _vReserve0,
1702             uint112 _vReserve1,
1703             uint256 feeInPrecision
1704         )
1705     {
1706         // gas saving to read reserve data
1707         _reserve0 = reserve0;
1708         _reserve1 = reserve1;
1709         uint32 _ampBps = ampBps;
1710         _vReserve0 = vReserve0;
1711         _vReserve1 = vReserve1;
1712         if (_ampBps == BPS) {
1713             _vReserve0 = _reserve0;
1714             _vReserve1 = _reserve1;
1715         }
1716         uint256 rFactorInPrecision = getRFactor(block.number);
1717         feeInPrecision = getFinalFee(FeeFomula.getFee(rFactorInPrecision), _ampBps);
1718     }
1719 
1720     /// @dev returns reserve data to calculate amount to add liquidity
1721     function getReserves() external override view returns (uint112 _reserve0, uint112 _reserve1) {
1722         _reserve0 = reserve0;
1723         _reserve1 = reserve1;
1724     }
1725 
1726     function name() public override view returns (string memory) {
1727         IERC20Metadata _token0 = IERC20Metadata(address(token0));
1728         IERC20Metadata _token1 = IERC20Metadata(address(token1));
1729         return string(abi.encodePacked("KyberDMM LP ", _token0.symbol(), "-", _token1.symbol()));
1730     }
1731 
1732     function symbol() public override view returns (string memory) {
1733         IERC20Metadata _token0 = IERC20Metadata(address(token0));
1734         IERC20Metadata _token1 = IERC20Metadata(address(token1));
1735         return string(abi.encodePacked("DMM-LP ", _token0.symbol(), "-", _token1.symbol()));
1736     }
1737 
1738     function verifyBalanceAndUpdateEma(
1739         uint256 amount0In,
1740         uint256 amount1In,
1741         uint256 beforeReserve0,
1742         uint256 beforeReserve1,
1743         uint256 afterReserve0,
1744         uint256 afterReserve1
1745     ) internal virtual returns (uint256 feeInPrecision) {
1746         // volume = beforeReserve0 * amount1In / beforeReserve1 + amount0In (normalized into amount in token 0)
1747         uint256 volume = beforeReserve0.mul(amount1In).div(beforeReserve1).add(amount0In);
1748         uint256 rFactorInPrecision = recordNewUpdatedVolume(block.number, volume);
1749         feeInPrecision = getFinalFee(FeeFomula.getFee(rFactorInPrecision), ampBps);
1750         // verify balance update matches with fomula
1751         uint256 balance0Adjusted = afterReserve0.mul(PRECISION);
1752         balance0Adjusted = balance0Adjusted.sub(amount0In.mul(feeInPrecision));
1753         balance0Adjusted = balance0Adjusted / PRECISION;
1754         uint256 balance1Adjusted = afterReserve1.mul(PRECISION);
1755         balance1Adjusted = balance1Adjusted.sub(amount1In.mul(feeInPrecision));
1756         balance1Adjusted = balance1Adjusted / PRECISION;
1757         require(
1758             balance0Adjusted.mul(balance1Adjusted) >= beforeReserve0.mul(beforeReserve1),
1759             "DMM: K"
1760         );
1761     }
1762 
1763     /// @dev update reserves
1764     function _update(bool isAmpPool, ReserveData memory data) internal {
1765         reserve0 = safeUint112(data.reserve0);
1766         reserve1 = safeUint112(data.reserve1);
1767         if (isAmpPool) {
1768             assert(data.vReserve0 >= data.reserve0 && data.vReserve1 >= data.reserve1); // never happen
1769             vReserve0 = safeUint112(data.vReserve0);
1770             vReserve1 = safeUint112(data.vReserve1);
1771         }
1772         emit Sync(data.vReserve0, data.vReserve1, data.reserve0, data.reserve1);
1773     }
1774 
1775     /// @dev if fee is on, mint liquidity equivalent to configured fee of the growth in sqrt(k)
1776     function _mintFee(bool isAmpPool, ReserveData memory data) internal returns (bool feeOn) {
1777         (address feeTo, uint16 governmentFeeBps) = factory.getFeeConfiguration();
1778         feeOn = feeTo != address(0);
1779         uint256 _kLast = kLast; // gas savings
1780         if (feeOn) {
1781             if (_kLast != 0) {
1782                 uint256 rootK = MathExt.sqrt(getK(isAmpPool, data));
1783                 uint256 rootKLast = MathExt.sqrt(_kLast);
1784                 if (rootK > rootKLast) {
1785                     uint256 numerator = totalSupply().mul(rootK.sub(rootKLast)).mul(
1786                         governmentFeeBps
1787                     );
1788                     uint256 denominator = rootK.add(rootKLast).mul(5000);
1789                     uint256 liquidity = numerator / denominator;
1790                     if (liquidity > 0) _mint(feeTo, liquidity);
1791                 }
1792             }
1793         } else if (_kLast != 0) {
1794             kLast = 0;
1795         }
1796     }
1797 
1798     /// @dev gas saving to read reserve data
1799     function getReservesData() internal view returns (bool isAmpPool, ReserveData memory data) {
1800         data.reserve0 = reserve0;
1801         data.reserve1 = reserve1;
1802         isAmpPool = ampBps != BPS;
1803         if (isAmpPool) {
1804             data.vReserve0 = vReserve0;
1805             data.vReserve1 = vReserve1;
1806         }
1807     }
1808 
1809     function getFinalFee(uint256 feeInPrecision, uint32 _ampBps) internal pure returns (uint256) {
1810         if (_ampBps <= 20000) {
1811             return feeInPrecision;
1812         } else if (_ampBps <= 50000) {
1813             return (feeInPrecision * 20) / 30;
1814         } else if (_ampBps <= 200000) {
1815             return (feeInPrecision * 10) / 30;
1816         } else {
1817             return (feeInPrecision * 4) / 30;
1818         }
1819     }
1820 
1821     function getK(bool isAmpPool, ReserveData memory data) internal pure returns (uint256) {
1822         return isAmpPool ? data.vReserve0 * data.vReserve1 : data.reserve0 * data.reserve1;
1823     }
1824 
1825     function safeUint112(uint256 x) internal pure returns (uint112) {
1826         require(x <= MAX_UINT112, "DMM: OVERFLOW");
1827         return uint112(x);
1828     }
1829 }